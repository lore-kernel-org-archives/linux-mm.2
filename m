Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FE17C79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 08:31:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 916066B0093; Wed,  9 Sep 2026 04:31:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EE4A6B0095; Wed,  9 Sep 2026 04:31:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 803E06B0096; Wed,  9 Sep 2026 04:31:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 596876B0093
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 04:31:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4700312012D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:31:12 +0000 (UTC)
X-FDA: 85193553984.21.3F72462
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6242820005
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:31:10 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GbsAcXuG;
	spf=pass (imf31.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788942670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=49b79tXZ1ojnOBAvllMdWWZAZmvMuellAdm87qct6mc=;
	b=oPy8lskwiqOwfmUFqE6HjPvZR7qTH+t3IJyp6279QjCvE5ozmuAaKhddg8YGGG4xjj+NhP
	FL0QRRYey9XMEwf3h82NAoj4NhWEAaMncr9WDXvx8hHCQbAEhR6PbRLJQb3SQfBBQN9w9c
	239SgJkxqxtyHZKEpX5ptPYtwm144uE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GbsAcXuG;
	spf=pass (imf31.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788942670;
	b=5v44T6islX9kdX2P3reFVFKLVRyuFFtY/fdGUVjfSdI+CyfpGvtTXHZENwiIBgfZhm7S8e
	WefP6iScJ42JDpmW01HMNo055TnM0Ue/45HGBq0xWEqJeqhqAlZt+EY/uS3uMOaaPYLDWh
	ZgbRnSL2HZ2xhP4qDCk8ygjZwvmtYmQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DBF376022B;
	Wed,  9 Sep 2026 08:31:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199B71F0156C;
	Wed,  9 Sep 2026 08:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788942669;
	bh=49b79tXZ1ojnOBAvllMdWWZAZmvMuellAdm87qct6mc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GbsAcXuGf1IDvWOWI+HlxmRVesIJFVh265mmk2oPPmSWnNXtpzhBbHaKt+6t6Vv4h
	 iKMIZM9b5SupHiuHBAgBgyrY4roYpgGaCc8Mx6Di6DPaw2EX1ZNh05dM40s+BGcEgU
	 CU4KUe1V9TAmcvAV04GpjTZgxVdAE+nF8JW/GKlVs5b2OdT3MbAIuHvUtFOuOBOcxJ
	 Rgl8UC5t9IGS3pvsMyoHCjF90OJVUDqQ3gs1QQQS/z7h+IrdT+jsaVNBaVT9xyyoUo
	 7q45Bex8sccRdrxSARIz/Vsz3Z+ze6XsU+JMDEzOJ6QiZTjNM8oJklfwQjrCoIeRQu
	 qdUXXf0HZTZlQ==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 6BAEC198004A;
	Wed,  9 Sep 2026 04:31:02 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Wed, 09 Sep 2026 04:31:06 -0400
X-ME-Sender: <xms:RRmhajLo2v2YFUXYtRvA0EJOlfM7ANT-p9PwTOsBBBWUcJScxOWdYw>
    <xme:RRmhan_tBSDvxxngx3WIEcVCdhn99398lxYom_n-00fmSho4OhXFQC3MyUQYFMypu
    eadl7EhckQh8-Ny3keImGGAcD9mB-vrnZrGPET_111xoeg_9t7BGhjd>
X-ME-Received: <xmr:RRmhaqR5Qq_NWV-x2FAyIVNc4SW9Nl0sSLoLZfkVzYuoFbDxVjnVM04rOGo>
X-ME-Proxy-Cause: dmFkZTELTlhkwM0l2R+5g/fxcwFlNyvdctxCrOr40Ut1USJWCs2K1PvKMMexdwKir4zss/
    yqEmTxidW3Pd1h5Q7tq5KIJixyQaQNHBOGsDvKp12L1QF2hGcsRKUXGxjiFAfB6VgS+EvT
    jAXLkiQ97wco/XOrWqDxCPn87uNjzVV6DHh0kKPPYrvPOLITT0CSx5lhwJzVHbpSojPi7D
    ZfIqQfbl59h9lG+jkdlshuUFh4XrLfbDTmpDqR9sxWMbAGRZAcdW6OWQv5bDHxlREtVgi6
    +4jk0+KsyqERUGW6jWU2PIyljNd6vZkpy3FIOdT1djFwfZpocijMiIo73BKDKmv+7SYHXn
    8dzDpj1favalkqenN0D4sC6w3rZV8uhdM/PlJYIm2ncZoZ4N5nIivXHDIhv1zsVEgvTd21
    w/piBQ48F7x130E/RfW1skPteyxPvdn9/2iCJ3Z+FGJhjjaoPDVYmiS+wyDLcCPHFAqKAs
    4bKfvkMrWr2C6WE6DfoKvRnx81x8Mxx1MfCdHcSl1TkockztyseNfN2Kx9TXRCsgJDG3gN
    k8v4ZWt8GS+SWkQlzmeQuKGO7W8A5i0jQTKfzdUVrsqV/7z8cTilBoJIsG1UMcrXgiglkp
    HMhmqBKvGw3EzsT1ivksTlI39xJcRTjdnHAp6DYJzd6wQrjbWw9RN7r16F3g
X-ME-Proxy: <xmx:RRmhaiNPUCXqPoWQ9CnfgNWwx84w68OnQ96KP-dFtONse_OHrHcT7A>
    <xmx:RRmhalgFxGW3dFuukqIZQu2eciI9sSoA_XBkcRLLdMpQhn0o-ppCeA>
    <xmx:RRmhalJHSiVQHIUfzqvRGyAExaVFuwdrc3SmOPx_eyvaeZyjUZH28A>
    <xmx:RRmhavY5wE_UaR3xY58GJcRLxWs9iaB1OUkoA-J70fbxNU9FVGDazw>
    <xmx:Rhmham2pfAoNPNA-G6mqGL8hWgZxpg16_DuTuH_SolAczFKAAjKatiMb>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 9 Sep 2026 04:31:01 -0400 (EDT)
Date: Wed, 9 Sep 2026 09:31:00 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Yeoreum Yun <yeoreum.yun@arm.com>, Shivam Kalra <shivamkalra98@zohomail.in>, 
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v4 16/17] mm/huge_memory: count only swap cache refs in
 anon folio split
Message-ID: <aqEYs-oUx4CE2Yja@thinkstation>
References: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
 <20260908-swap-thp-cleanup-v4-16-b532a3f20e71@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908-swap-thp-cleanup-v4-16-b532a3f20e71@tencent.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6242820005
X-Stat-Signature: ti74mdosyhzmbpnorr5opdex3jqoxafw
X-Rspam-User: 
X-HE-Tag: 1788942670-30414
X-HE-Meta: U2FsdGVkX19g0YUiOCpMRgIf4h1RyI6PoLvDTZoIKyToLWpfLtUE9Yx3VDsbIFCq0T+hCFCmK1Dyj/RtaAb1iVV7wEB//ItFdIklgQlxsauWW3FlHgJ5eXxDkDf2K4VbQQFai1QnEmuCgt/ziTWacuQ/K30MzAf7mFyTVW4FIUELzHXgwzi1coPBixOz0SWB8+4bStqGpYcR+FsNJb7qjhjhjKHBau91OZwzkt+0Y2RUzc3Nh0lwqOFTa1EoMCcCO69z+YwYSo/il35MYtlXlUPfKIi6XP1mHChieQ1TQ6l9Aev3wH5E78gd5XwcsO8ykCNDIcUyINSiwRbarWwVwnrlU3nLoOy/CYZC6HurA5mO/O1z9RrSP1b+NTh1kxKRytrrDok9dVYD4181oRR54Qp9HBnrl8+wto05TsGxoxIDPz737u8gzEgCK1eZbj9mHxeF8hVwbwdGEcXfhs+XJ/zOY/12yZdbqRjd//NmqkJW7UsiQVkP6OKEhGZehFMXCSIeeX56d/uDMeo5u6avsmLQE+piUcucV0u4fyhGTWQBFtsu6eUmG0p1/Sj0ZSCZLslG8xe8Pw1KRNVqV9sdaavE5i/hSQCdpp3HNQiZHYXHvYiG5dIRvZJnFSIZst5LcjO1A5xdSH8a4TUdR6hbHSKkoJA3ihptYfHk200ssG8L+fv8mdUDiFUfbjOOnxXV9y3vK0KXN2GJFMns1hcA94MDxCIuGei/W/h8NJYMOg1Ph5464/Scgqi5gO5vWbTaeLlaaptGIoaSH9u15aAasokwu+UwSkihC3ORiGwGvR41NIfGSr9Ak9GeXhrjZ/kuJHpbpeWLbEabye2LF/QkDJ98gt2z4A0dn/B7GHxDq/DFxkX7uBHTqn1VId6Rwf+qCLWVecm2CX2ybJqivhdY7w0tTXc7dHTm3ket+uUrcgoPpFpEOB9utIr6Zk18elY+MILxcar+IKXqGRGYFOk
 3JW7zzg0
 JJi33Ui3yD4Z3ndMsu4OnEK+oI7CfQP8iSSxvi70mocWapaWj39bT1erX+yKLMfnKrAsdx/c75GXebUxH5lluW4nBe+liSNN8IB5GIQHdamDE8Q0xAG7vN1z6YazpiULitEceRFpBFAJpxKVdHGavIyXHV7ydW/dGyIg2dUWdI5F6ivCBVHggj1d3/KKFgFDAT3ncrkCJ7jZKv8HIN1VR6c5bud61HZRZJLTp0lDncqeu1ywSjAYPGFDaQWjz1C3EvbfSUIr01M5eiVjeuO1M9zCnpjpLJcFyZXqnQPWEn+XRiro6idOw4fSpJh1KZkaaiPglliW03TXVOt4twMCpPSLreHOSsByg70tyUaYNvc0NC9d3xO03PZe3NZt31yCrrwyL5VpyHsTs8OZZIvZHvLQVIFwTSjDA1FTpwJmsCUHaN9LKeYE/czXovbCzquuAuZxFSFz9lj5kmwVoshiRPBzPSZQz+73uEFsw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 02:12:20AM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Only __folio_freeze_split_anon() sees anon folios and swap cache folios
> now. The file split helper only handles page cache folios, which hold
> exactly folio_nr_pages() references.
> 
> Rename folio_cache_ref_count() to folio_swapcache_ref_count() and drop
> the anon check so the helper counts what its name says. The file split
> helper now uses folio_nr_pages() directly.
> 
> No feature change.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

