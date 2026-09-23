Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED380C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 12:26:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F54D6B009B; Wed, 23 Sep 2026 08:26:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 057116B009D; Wed, 23 Sep 2026 08:26:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3A4E6B009E; Wed, 23 Sep 2026 08:26:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BBE4B6B009B
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:26:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 497CA4077C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:26:25 +0000 (UTC)
X-FDA: 85244949930.11.2CBB6D1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7B0BE8000A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:26:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NKiBxuMD;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790166383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AbDU6yMDumi5audQ2f3QR8iaBeD7dJkhv3W8jo0Hg4s=;
	b=76RIddLr8SWLupIya4cHKmvHDrbVHxZm6hzU5IEFcZsbTrj0kRBtSdUjeIfR2yO6ismk5X
	SmYJl0SNx6/twxMecCI3QimglIbVCnx5mhHH7EHaFD6iJx46weIkxsi6yjI5whrR1c1R9y
	F2Y+51sNTLgvzSMcQqpgqBfZg60U8DA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790166383;
	b=JLstPp/6ze+MxVwwFaUvoPw/UVT7a6olHiW22pWEXfiwzrqE70Qx2H8TrR6J7HcmAW3HI4
	b1MnoEIOlnNn1iNAVGe6Qjh37P50bEIndiqRRdkN2zIsApBELhUhsqEOPSMTCv8UNNspPO
	hXi3Kubj/qJEwv49CyG2HDKDy+S5/AU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NKiBxuMD;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E5444601FB;
	Wed, 23 Sep 2026 12:26:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7555B1F000FF;
	Wed, 23 Sep 2026 12:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790166382;
	bh=AbDU6yMDumi5audQ2f3QR8iaBeD7dJkhv3W8jo0Hg4s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NKiBxuMDMpHw9yT8qdZ2SGbSwto2PGI8KbhkODxWVitvTLH+9noJw+g6qr637JoPg
	 jQhLkB4EOaDgTihmBG5QjxyGSdP+X0hmmL/dfdv5zms0gIjaYqUbkgDQ3W8CglKoGU
	 /9tViZiM2EW41H6G4Bs8tNfy55RSTAlIF5IcTfX7IuowdsupcHkNNjtp/KZPutYR2G
	 3d9a3q/48n+xHKZfCsIRD741DdXOcF4My+2w4/ooISl+72gAI53Sl9X/I4+gjLC7WP
	 k5FDXrwvBcfpFqhNr6kr3681/VLnrLQ3lpuZrRtXkrmxOoEnDsOhrETwg16WN2hyvE
	 vgebn3sjW8Agg==
Message-ID: <a333e26e-4e31-46c5-9996-9df9556c4675@kernel.org>
Date: Wed, 23 Sep 2026 14:26:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/12] mm/collapse: name the per-table scan reset for
 what it resets
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>
References: <20260916093145.4022188-1-kirill@shutemov.name>
 <20260916093145.4022188-8-kirill@shutemov.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260916093145.4022188-8-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: fbwuw1hnk7tqxfxip5f4xyariattr1bk
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7B0BE8000A
X-HE-Tag: 1790166383-336432
X-HE-Meta: U2FsdGVkX1/twrtCwyeitsLu3AaXeLGlNthxA1mZMchkN5PvIizqeOLH6Rq52PhAwk+2nZM3mIt9S+P87lT8KcNoYRJPY9tpHgGmbu+X8hF08SVwWYnpWuT7xS5+6aoQ0IRsytuEs+DEVCRftk9Zm6sUTeOYqsIXHD6EVNkv9W8bcK1vHxEmeAfeYtqBqnF2nKlmxq5T4jE8X3HU+NxL/1k5B5BxQhJDTzJI2sMXKqIG4BlChaYB6wcUEOLg4PQyt/WKOJgAnUQmnIwcHFWin5VsZfV1d96Tv5o0Viz/t5r5E2KLCZJVC33oAdfg/VNl248FGV0vzSKkY/gvGKgClx23eyoepmtIEnogEmAUrMi6NWsIBiKZ97t+iVb/UyqDG753eAB1QV7Eq0D7HfndlvlfWcLmGBtXlckpeVpKeLn7p18Y7R88jd4WusAhLc/vKVeBdPegGUSnG7j0SOpQRZRh0HRHnlIj0LqVJtl03TH1KvQffbzxKuh0pzeJgupir27Kg038TBQwOd7ngEYWodDV48KcR6USmC9MXEsn6GynFDSq+muJDkW0CZ0qxRweK9VqFApNpiprONjJKSUFdUsjfSp/2b43rvg4jqQN6xjNw1BPPPASJxxbINqW8102Sfa+pnxe4SbfZCkZUwHjZ81/cwzLif0LMKODncHWwWcv/LvdPqDiY7cBODMXtdPcO97DhsOFvAWl3iFU0sYFv9kvLGJ5aecInREpOD5HYRIsNrI0UBZhPdv4rIzEUMYxfqxS9iE4VDdfOcmd2Nw7B/qnsPL9ACitecbD1krGwIsDtdwUXY2b5l6eFnWkiTOzf1B4NHIpeLejmfC8rRR8IYKFdQrs1QdsNMv+KSPOm85SzQlrtY5erYWF6h7XMmvbEsd9nOqHfuw2qddxnKSaB8M2KSS3N9nDSrUr2a9DmXvGL9kW/r5Q5+Zd9CRZRVhAoTQMJxCEpHvJBGHWIDQ
 xl3gpWbp
 +8fx5FeqcTM/e1WAH0eBHMF24cjfjtCiBGRR6aOkJBE6MQ5nyTdCJ63NN6APTo+47Go0KB1QfhM1pDya9UDKj6ACN/BmRlPmxs1bai8c4JNAFmirNcfII0xJ9yyZZIRknRs8gHORsBwSFbn1wvkxr9SzyBj+GHUuLPr8XmWmtw8CYSHLUwTG/IOnu6xr/SsMz41yDVi6UeXsD5hWAGKCEDIlP+ixY3MH1wJg0LYSpButMjlHYNWVbMb95LEwdc5sCXH5wJHl2nXUQwOSG6ppQx7jrH7L8Ab1qotxkY6ufm5thj+6pB/2HcvA8WPR35X0foCvtATiIOf1D74k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/16/26 11:31, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> collapse_control_init_scan() resets what one scan accumulates: the node
> load, the allocation nodemask and the eligible-PTE bitmap.  It runs before
> every PTE table a scan is given, not once per control, so its name points
> at the wrong thing.
> 
> Call it collapse_scan_reset().
> 
> Preparation for giving a control a real init and release, run once each
> for a whole series of scans.  Two names a word apart would then stand for
> two different jobs.
> 
> No functional change.
> 
> Assisted-by: LLM
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

