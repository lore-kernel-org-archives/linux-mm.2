Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E343C79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:26:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 364696B0095; Tue,  8 Sep 2026 11:26:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 315A16B0096; Tue,  8 Sep 2026 11:26:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DDB66B0098; Tue,  8 Sep 2026 11:26:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EDC0B6B0095
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:25:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 89D0314036D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:25:59 +0000 (UTC)
X-FDA: 85190970438.26.B65C867
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 83EC580002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:25:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aIPoFbWn;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788881157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NLL5t97riWq5Zu+ReRl9pR+1kEZ80aHdKkkE9El90lc=;
	b=pIEL5old37gPV9GdYQqA6HzmRa6UU1t7DyTXD9jXKe7TkWJrPw6FKwFqf/6t2/BHULEHu1
	UTz75C7BLEW5M91D6qf/PJLm1t3edJfwXjXAca9rIxWPA/78PRYM+C3zg+xONaSr52IvAT
	BXvLbdzrLqN03U/C0nGvGn9qVB7wHnc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788881157;
	b=QcgQhZYh4vGMESnGDJ6ti+yiB2GuDmprVZPtGxiUxUbUAKso2b5F8eFLUy8WVPcxl4m4Tk
	IyDcbbXA5ooUmUCCv1PhYeXTfHpxM6Xmf51ZFc9npmxI9Vq4xVO2NrRWe0urLiRI0SNQ84
	7s5/0gjDOVmtgPsrAOiNxTLfcFWqTK8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aIPoFbWn;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C39FE43430;
	Tue,  8 Sep 2026 15:25:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FBC01F00A3E;
	Tue,  8 Sep 2026 15:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788881156;
	bh=NLL5t97riWq5Zu+ReRl9pR+1kEZ80aHdKkkE9El90lc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aIPoFbWnDCAK2rK8PR+iH8Vps4cfkge7ZyoHMyMsQipULlAqeC8wHruNKj+VVMkMt
	 CqlAM5+Bxm+T9/fHDwGYDd6ftMe9abHQJip/ot+e17skfgj/kEgbzp1BOY6GW950T5
	 Yv0oS7Ce89UXMG/QovUY4yIT3CKoKEJmlEmv0JU9JUktg102mquX7jjb5emSXr58Vv
	 fp3QpI3eJ5VvT6AZwdft92OoNvhIwcNDIjHWnEB5N6gI6ENlQEDD1NWF7RpG5Y4vFw
	 Mqmvz2VMWcEK6ah/cM/5pxsD/aszTERGRNxDArhg2oUKawES5YItfJzlUf1s8MXmf1
	 j7tLI8Bisb3rw==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.ams.internal (Postfix) with ESMTP id 7808F198003A;
	Tue,  8 Sep 2026 11:25:49 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Tue, 08 Sep 2026 11:25:53 -0400
X-ME-Sender: <xms:_Cigaje9FRO_OGuWBqzWBvHv5zWaO4010Dk337-2LRq7ZEWvWc8h1g>
    <xme:_CigasQFOtA3bH0iFVK3KCvqrkZtptG4Jz92AkMpThKylse-J7Z0QqCaUFQjJpLpy
    nmzB0gv75WNY_sPsgdR_sxaMOABYoZ95EHlIzrpunrjvKBtKvifUm0>
X-ME-Received: <xmr:_CigaqmwrgW4QpFRWktIYM4j8UXE-LlpAJLPF-2BpiuwIZgbfvyoZR4-Nao>
X-ME-Proxy-Cause: dmFkZTEb2T3SF9BXFaCq6Y7MiXTtJ1ovoHmlskKKyQz74Er/5FJa3tWOsXEjWGtdcJ4Go6
    Ta0l/J3gvvprxj5O7HnzuAYqoQXGtcuHEGyCho/qrQD1FPdUR7Xf+EKDfUOaB9oXEzBRrF
    t9VrvpJkYHKvWDkZDzWQJxJkPROr1SmDNami2TGx3knpupG+c1faSP3dh/FuLuR6OMQKqz
    kn/xBFbt/vNohUevxk6tRPc3/HHyHA0y7CiwR1Z7EPnURPu3AWqoTfw8//6PgcsJZXqWDl
    YpW2hISp/9iCrQcQd2xjm362PxVejFW0C28VwZ1mch3qpaiswmuK3UT2orIoV/JhxfAgd1
    5qA371ZAr/otAXQgDnRnYGqrAl/Fd58jNcu+5+LSMULuayWiyyPBbamouZldJ36/JAUWIr
    M/9ZbdhjM/LxxDYereX/96Pcf2Vv6bstoedRDGcxM8mKRgZr93gth/OwqP5qehi/9gGx+G
    bRZSPOYSBgqFBU6Ag9OV33JDG2xImSJ0a9kFalv49g/FzdcwENOaeW3StmLrYD0wVguUrX
    1jqQCOPr1mQtcu6KYIPLYY8E7TDo42PCbpXLGxEOzpOjEQ9mR4f7oNSiyFfbXtk3FzrsIp
    yR5kAbcUZzJsKXda4T8BVMg1djPEYFS4YY/2p3Ndj+gNzeyo66GGY9IfVIMQ
X-ME-Proxy: <xmx:_CigaoZOLW6ZiIRdGzCXzzjrEKo6fAGLDWyWuXJrqigHs0Kge3x1rg>
    <xmx:_Cigal3_56a60cWkJrEt6_1tSxma3S79BtpJuzPGTm6-1kNJJ39gJw>
    <xmx:_CigagoqJp27kMI6QFDj3K6glZU8fEDd-FvbDIokiag9uH4EeFe1kA>
    <xmx:_CigahzTIxd3MDCQ4h5wGf4PDfn6iY_RCBQ-X5UUkcSY74WxE0Kn1g>
    <xmx:_Sigavg6MMd9CFLhWO1YiuFkeTXtLp6gaHk61CmnNpkjK7NrDsZ1aWsi>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Sep 2026 11:25:48 -0400 (EDT)
Date: Tue, 8 Sep 2026 16:25:47 +0100
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
Subject: Re: [PATCH v4 11/17] mm/huge_memory: move filemap management into
 the file split helper
Message-ID: <aqAo4dFGofAJzkRn@thinkstation>
References: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
 <20260908-swap-thp-cleanup-v4-11-b532a3f20e71@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908-swap-thp-cleanup-v4-11-b532a3f20e71@tencent.com>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 66ssojhwxzbieam5ikar9kfte8cwgkfa
X-Rspamd-Queue-Id: 83EC580002
X-HE-Tag: 1788881157-146109
X-HE-Meta: U2FsdGVkX19TNrRTxwnTMjmlMycZbf/2OQCG9GiUTd1d1F3tG03XOFzz3ZzTkzbI7YtCrShtRTIStiVbr57du9ekwrmkOK3LWjjPVbyhIAnznxfwpAPNrsuy6v0jPF6GMEBgcVXFCaSJfX67B+HUV3HQx71q8oJelPoXqXOVOoSJ1SW76mcIApN/cuinMzNVatjAPyrwnK8USif/1ApQ68dXOkAHE90hlwBAn6KOI5MlG9b3nXG+3rPUpmrjb9YS9K7fgLPUMY4kcOQbRCEpIt1AOQM289ZRlPxW0UPCRPTjp45pxqdF0EKf3h+CwvqSLBLrkTYO8tp2AShq5Ol3vLp5TqJhqNB+dJjWV9VKu3Xuge/pTF0Ru3C5Ozc+N/1XY3lWL3vz4ILGa+zRrCDoL404sZpPKtB2+nm1LGL2cAYq/RTBo8GqtSg+jICvgSpLlAaiOGwuIQA/zv8vnIlgzSxnlhU5w50KApZyvcY8evpTPsoOwSGdqMrfrXetuNpzTm2WENyChKQIDacTeMru330J2sbq6cPILv+Mh29yCTkE4gaRC5ztE8h2CzLSSX1KBRSNfLlIfXFHaPeKCFK+MW0zoZfZ5/tElxF4fJnJhUqpITwqbXPu40QMtm7aQw/gKSEmC6CGidtd0BLJ0as0VrDbxPt66hZhNVLhuqfD1lWsZ4mEXbsPZUgEWC6NNjwnDHUmSyqTpZs7tpgr8LQwNHPJJGKMyvaVfYAf4PgQP4RHIgxOBHRa7XXLDLrwGIJwtiOdwIAlHwQgGH/HmWypHLWyZyLny3mqD6nkJTeBoxqVaNDWzQmVEvl5Im9ZQId9LhEAQS/kKic7LN2W0cwJZ+cHrp+lgrykITVLmmaijHBgkl1nja+rp0lQ4OkNglCzWAnKxx+q5JmINNh5/4KgmI1gZyDK6/kCsiLiDKNBBlKI8HSsteZWIY0Ene7psHiC857cvUb+1gzqyeJqrXF
 yfT5WDls
 q0uWbHGZ3MKjetmSAP3wNKL+Bip14cCYBv79Rhc5dyuGN/0f6X4889nGONkRZ9Z1s2YP43UzpnOyq8HjEKDbxdQKpPTmb8xIROHGRfT2Q06bF30F0WiuZqlQJHM504KebwdMITRuYPkIMauOZb7Gs7kCmVax3gXWC2LEI1UM8ld2zT22l6iF6AyEDinViQMMK2UYbwS03V6MAwMDObRsp5M3ZTK4ixfS+Ax7OL9kgiNMSha2EASR04P95hzPjOuAyc79lGrRS3SLM8/af6250HUTHhPrWL+RlVeATaRRmOIl3pUnqW6eEiiwyWeiVllko6se0+MMFMyI2N1n/teTJ3nIIpp4/LcYs6h47gzYbpZ49DjQs+NsMhqlrYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 02:12:15AM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Only file split needs the filemap and xarray handling and related
> variables.  Move them out of __folio_split() into the file helper so
> the helper is self-contained, and simplify the parameters.
> 
> No functional change.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

