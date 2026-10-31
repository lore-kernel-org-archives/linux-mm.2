Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 244EE606A324
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 08:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=MtOdxnO+
Received: by kanga.kvack.org (Postfix)
	id 492266B05B1; Sat, 31 Oct 2026 04:03:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46A026B05B2; Sat, 31 Oct 2026 04:03:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A7CE6B05B3; Sat, 31 Oct 2026 04:03:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1AB3E6B05B1
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 04:03:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8DB751408D3
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 08:03:28 +0000 (UTC)
X-FDA: 85382181696.08.7ED2541
Received: from mta1.migadu.com (out-159.mta1.migadu.com [95.215.58.159])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5CDFA80003
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 08:03:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MtOdxnO+;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.159 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793433806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gbmKrXUxMGpkX3MNHgLNV7gSiCM3yMUiLklT1taAK08=;
	b=WQUAJMVLfBEe/ZnNEcdIylIyNS/U0RM6kgnwJhAtZDyHhr2TOD8Req08WPBrbUGwjPJgR6
	OjMoELinqSEV7tOJb/EDrEV10qcgxI1vqBpSx4fdCE4mKBzmKEHeS9dOEfFlA9s1eoDZBf
	AENyb5lgImt0qiF5t6ZRe/TJTk4p7pg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MtOdxnO+;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.159 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793433806;
	b=aRwbM4J+J7iCaLumsMXnKSkcjWLJjvMWuM7FfRdCzr6slJYEcqMpU4dBMD+7ydukRXX+Cx
	/ZssBeI58ui0tkRTgSPG6lhLeuU89cWjw+mQIlFY41OSEQfZF0tITO/IcLanFuKpzspff0
	ZuKOgj5zbX8wAILyIsXNKoq3qeIvrm8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2ExtZ8QuR1DZDKx/RuoMNZw4ql/mM6Uzh+5t41m9Wew=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793433805; v=1; x=1794038605;
 b=MtOdxnO+rZ+rR2RiU9T8zCHm+uVQh+saqsPcKmIPqLDat6KVd8JIstJRDfm6EMvhBqjELZPD
 nQSqol8lBN+oD4kRHhB1ooMsbX52rMCuv+d8wFmwu0+n4Ai9zaq9V4CsnaNydPXSzDgqJ/3JaW2
 JmWGVxhLIrJaWKB90grTeLqE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 91100bf70793d15d;
	Sat, 31 Oct 2026 08:03:24 +0000
X-Mizu-Trace-ID: 91100bf70793d15d
X-Migadu-Flow: FLOW_OUT
Message-ID: <158ad4d4-a57d-4c6b-a840-0f6b9d5bbf7f@linux.dev>
Date: Sat, 31 Oct 2026 16:03:17 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/12] mm: hugetlb_vmemmap: remove HugeTLB-specific
 vmemmap optimization macros
To: Muchun Song <songmuchun@bytedance.com>, Oscar Salvador
 <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, James Houghton
 <jthoughton@google.com>, David Hildenbrand <david@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261020115306.813483-1-songmuchun@bytedance.com>
 <20261020115306.813483-2-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261020115306.813483-2-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5CDFA80003
X-Stat-Signature: 6tqxy3gpfjh9efb1xtxjgwf7xbgza116
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793433806-916271
X-HE-Meta: U2FsdGVkX18WD+QqDaiEm3NAsbdadjoy9E2bhku3LWfuK/D6JQSY5iKQEUCGazS8onz5htbukWyxFj6zuOyzu9BmqLuNgVCwatHB1hl3f40RBCLA8WsmiqUSx7si+S0kElAzdUeEzNIJgByod+IUSGUOUaRGSSn0Q9GV7XVgC7POzP3YX/fPQ8Syq0O6WKfO14KjLaz9EpOecxt+jc3kpQiQc1lg/s5LGicwjIXvx/XbLaB2vxtRltUu4WIT3AhWMihX65+T1YVZ0VQzSdsMQM8vPTDy43HcvTcw+vnLG+xubAZDIYLuw1nFOwwlbF1yJSPY2eOQrmiYsz2V+f7GklNWPyWAKCMU+zMu9f5I4iVhUuFXbS5CQbLlsIuvwiuP3TrZcDtaDyPuE2H5gYpi17j7UyAODSAfo10a99AyPGFXmwEj5XtU8SS3vU9pFBH0yaMzKzcNKFtVs4lqMM83OB8xqmYnpNK/irsNW/IE4/r4Clj13FYTDQCh4K+FG3Clye5AxYZSArgERw/MQuxWlroQo32XNvyAW8JKUKZJtGwTVHgCEURwxf1Af8h1dP5RxUetvsXyqjjtDvGzZ2EfdldJVy2PF/N9h42qmp9IqOWISn5usjgLDRJ6wScuS9XNv1fT0bkrmChVEKkXoR8Kgya6xMkJ4/Yd6Ncam/fxr1lMSot22t6g7wK8OTKvdsX4FS140G6jI+VP3TP1e9yPPnaOn3+N2egu2IiHsacR32DcRT+L0bRoAYmYg7HAtLATQpB9j2lxuHpYKNHykO8udk2cswdv41FKX8GJNiFqctIrDRAETG8VQW+kv5xqM38nRiVnG2zcjN4Q9bpQb69Wdx6BsWCgBaowaY5TYjtLi6fbBIEJBHSViLwPvCZweDrHUlCmV0g7ex+KYDg/gz0j01V9TRAyMbog9dr4mwmE7MVF6542PC7AZxCk4UM3Y5yZzkq6vXzSOx4T//Y3SBb
 5l7ck2yO
 yrKMccHtUQi0/m85hcZLrddcnzeJaIoR3v55+VDatHcfsRWAsEx7c+SYf029XmAxCFBi5J3SUvVnEE5J/X2sS+Eh47CknCbCkNRFqBxGxyrd0icz6PaDoE6IgEJWWdmIoaBuh3N+zzEAhy90b2mbloymDGCxgu4fxYSFf4r7ewNLIEToQDFrjQ4OGJowF0YPuvNaRRYT77IY1zgCK1OllS8Y4Zxe+UFMFoKNZfFIP6cKtQrz5sue84FNfUvWYq12pb2r5NWoyTgmlhT197XYOZVwcpZn5StNPyn0MxtEDH4qa8U2uiLeZ0r0Lxg9cNegHLKR0Q0s5rfRXeDxNKnL0DKm33A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/20/26 7:52 PM, Muchun Song wrote:
> Vmemmap optimization is no longer HugeTLB-specific, so the remaining
> HugeTLB-local reserve macros are redundant.
> 
> Replace them with the generic definitions to remove duplication and keep
> the HugeTLB vmemmap code aligned with the common optimization macros.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>   include/linux/vmemmap-optimization.h |  4 ++--
>   mm/hugetlb.c                         |  4 ++--
>   mm/hugetlb_vmemmap.c                 |  8 ++++----
>   mm/hugetlb_vmemmap.h                 | 10 ++--------
>   4 files changed, 10 insertions(+), 16 deletions(-)

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi

