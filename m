Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B4DCEFCE21
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 17:29:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C893C6B0005; Wed,  4 Mar 2026 12:29:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C36CF6B0088; Wed,  4 Mar 2026 12:29:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B38B06B0089; Wed,  4 Mar 2026 12:29:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A1F7B6B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 12:29:14 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3CC5A1A03EC
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:29:14 +0000 (UTC)
X-FDA: 84509066628.30.D4F24A2
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf02.hostedemail.com (Postfix) with ESMTP id 20CFE8000F
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:29:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="MJb+0/no";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=vbabka@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772645352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=65xmuhmKWXk7/zG1c9ETdfnsqvoYsZIAuDHWDGSpid4=;
	b=gGNyH55J6vmIeyHh+38GmYaTjZd1R83ffqYsF2U8f2pMmHOw4hGHHchd+NplzDQBq3NHrf
	0gO+ffHp8EPTN/2LVoYE1Yyd3OPb3Fih8lgjqJsgxYGI+HgCyt/+7YtLkA6wwpaAMOxGT5
	qprRFK24Efy4MIFh+s8deEoCmQSGHus=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772645352; a=rsa-sha256;
	cv=none;
	b=pENkTjgTghyKWk3Yob4At9Iqs8O3qNIpCW7v+ziATIcy4xZqNc4z0PLjK4DIOKw1/ZdfN+
	hbyquMjkjmEg+oH0IaZe5rcZDyPSOki3XRvvAtaOToWu74K9UjhhZn7LQtGyOLN1Wan+Ev
	qq1TCN9sI6mfsg4MEbCpnk/Tals9y28=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="MJb+0/no";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=vbabka@suse.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4832c8f9d87so7952555e9.3
        for <linux-mm@kvack.org>; Wed, 04 Mar 2026 09:29:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772645350; x=1773250150; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=65xmuhmKWXk7/zG1c9ETdfnsqvoYsZIAuDHWDGSpid4=;
        b=MJb+0/noOi829SSM6nLcf1zTe6MHe1RiSsIxLBM2qPHtQCIaep/7hDcXvEHcIXGEI0
         tayyQPhTgaFHyZoLZT/N0UY4X8dqDhFyDvNxgDDf+CfAjidiiK7Fqr0Y7HDnM4uH65l1
         /YYL+O4LA39pAs+soQoepT3UEiV6TIF9XoNdXGKNTpPwyRQt4jyw3oUk4ogkBzMe6a6J
         eVUxf4oaL78RIgtr22bNq7W7JXyYRLAwROBoQc/d82GYQpXhOQrjMEELM5X1s4tfgzda
         EH59ukl4rZuKJwbdtdTObsCa28Ud6Jkrw1hjcKU7ncYVmi1aEMSQcjJJGJmS+g9toWxL
         sZyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772645350; x=1773250150;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=65xmuhmKWXk7/zG1c9ETdfnsqvoYsZIAuDHWDGSpid4=;
        b=nn7hgNEJsB19koNApIz9JQLmHPx1IhXXpMbDBR1o6AtCLzkdDwpYA3fWy+mso3ti1N
         E0ymWYvmlNQ7NERWEHlM+0Y++BwcjsiKwiRzY772Wl+oEBF9lX+vqdC6FWKcpiiXay5u
         Sb+L8FnvyDkdSwPLHm7noyrPxzq9bchQo1WqL4f/40UO00JPDBBL7oW85vFqvXV6cbLB
         jW3W8mTbA1n9wXGPsOWjEshvxwlyHNUupWoroFVXA2UIFMQi8zCGuB731lYGGknd7F4E
         45kRpAwPk/oQi1CnlyaOvlS6EniX2OvcX31NlMLq+OSpmAmceYzWLn+kaAF8T2vLfTbU
         6S7A==
X-Forwarded-Encrypted: i=1; AJvYcCX6EmdEL+LvpwCNd06B2IyqEtTm5eMG1fC8aLtc9T/cyrqLTkVScnzhog6W91QJFdZmUAJH5cVLZQ==@kvack.org
X-Gm-Message-State: AOJu0YwW0IgEn0TMg1yee0Z4IQ8yhFaywSqRiEqhzIH3Voc06E4StPyh
	KsLelTLrE/SMqe3IyXY2GP2R67oJtmDfVbbcsbeUm/rrRLGCjPDcT7kJilC1Wf7C1z8=
X-Gm-Gg: ATEYQzzoO9Mu8JzdblsUfjtkfXAenDgkko0KWLDj2NYQhTUQt/sVyWlkb0zDpH2SJGe
	Det215PR0Id17GVOHFckU8CEov+yF3FAFcrFN6xPMdPAifjyLMVmAbJEnwb6WeQPZkBoDg+Lgj2
	IB/9D9vhVtIOWVGbLXGE3glFkgZdOtqqWsIlEVRIMGIOKW7DUDM7LHOSMIt+XGSL9KQ7BjRc9sd
	2kUlJ5Dp+slSN4S08mG1OUAg6kGn7he9cDZtWf23zZqX9HTHZrkEggOEu6bXjMl9P5gEyW7f799
	3P0yIWil70yxzpCUE2LCuN9cNdVkhD1SeEJNn7Rt59/H1gqCFubp5oXGfiaEJfirLLFRVVbF2IK
	z0lUu371HvhspUCS9BQpBO0seJ/SgAK+alszxDDpHlJ3XiIKBBy0kbm2HDYjPPtbXY8hJuQTi4P
	cCNhHSqFxqYkEDUpirpDoYnl09GqGDj/qTrxT/5BGnkcv7/MF3vAlVoYA=
X-Received: by 2002:a05:600c:b8d:b0:483:816b:67cf with SMTP id 5b1f17b1804b1-485198c1829mr26244965e9.4.1772645350259;
        Wed, 04 Mar 2026 09:29:10 -0800 (PST)
Received: from ?IPV6:2001:1a48:8:903:654a:5c5e:479:172d? ([2001:1a48:8:903:654a:5c5e:479:172d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4851a8aaa20sm31926495e9.2.2026.03.04.09.29.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2026 09:29:09 -0800 (PST)
Message-ID: <101ac423-252d-4ef8-a07c-34f5d59820f5@suse.com>
Date: Wed, 4 Mar 2026 18:29:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] smaps: Report PMD page size for pure PMD mappings
To: Andi Kleen <ak@linux.intel.com>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <20260303201556.107960-1-ak@linux.intel.com>
From: Vlastimil Babka <vbabka@suse.com>
Content-Language: en-US
In-Reply-To: <20260303201556.107960-1-ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 20CFE8000F
X-Stat-Signature: 4ra9wxw7n6ppis4nu3tffmf36q9q5mw7
X-Rspam-User: 
X-HE-Tag: 1772645351-526617
X-HE-Meta: U2FsdGVkX1+dLz9Zzk0W4Zt0qG8qmyq0e/m5C5YCFGkSR/eqNbgOHxTSxyXrpKjWtefn6iITHLelLqx0JKoUE9/fKbVt+InpOx73WBCy+qfTFEWBrbzg/gug7vsnbHl7ldMWceu2xmPUPEltB43ZHENcjsYBmB+8xPIsfMqIa60rLzODp5/+n5+FuwyhQmbz5tgPEMPEQfz76wAu3INVSawXTMz7lWw14yyVIua9Rcuy6TCnLY9vRPkiKgKdgZGD+AkcaukUAYEIuhAghcYT8fgHh0rUBJNsw476oONi8gv3SeMTN2Novtmn8HIXE3ohe9lXGFwHYPr8KU31E9su9Swh/zZbwdOUTr2lLlMGqwPz0e9xtk+A3sGFRhVSu3wje5IYUKOpU4gEOQt87MAeTYbWWX8dDjoGXcy2euMWx3rBk9GvvSXwIWoIFpf0uRKonUU+KGFp0s8dZi6iuhlNDdYz7mXySAbnWcYWbWcZwR7wlGupAqhr13MGdzRRbDI9zCqG1k8cwXcoZoUnGPvaMlsTbSUdQN+G/YAPlz9rDHfamChEHCw089GKeuw0Rk/s4Ar6yK13izFOdutV2OIg1NcH4yMKJfbI3PnsfH71H5GDYoW6InU6zn8YSfE7VqcbiG6p7wG2fbVgKUVKmd4SOuZcOTxi5gPAcXJUeqN/DnKCO0+PxJjfbcpotqiEwzevARtVN8JiKUYtSaiy+YIY/GEA4ighUkNrksH2W7DHTJ7Mh/sY+4viWnBVM2VKNFDpy7kBAfZwaHFUTpnlDl0D7JLSh0GspdatGN/Q60E663QGDwhh2A0ef/vdHQ1kV9v3Q02AkKnVUP+QvT31IdFlhTsjFEBrmBgcB4V4JfhTT6YZ7a6EYrqZBYnQCo2Y+i7539lLDx9LEFIzuhuslQWQxj4J7jes2lfdNipn3AdltUBjW4FeSyt1Tc2xhV2g3Y5jbvvRnTjPIL+yGNmW48V
 t3C+TcsE
 RubvaA3gpIM7Svpx3afSlZaMTkM1tqB4cwF0gqKDNenIq+Iuzy5eHcJCilkL/nXuOCfEbkqypb98lm7tXoCGVG7DIzBvcWizkyibRpkDUjBCNnbZcwOVvlBSxmA0ZpyccNi79YxQ1bYeqb640LGAHkEvrBKtwt85pJnW73TNqNjaTTw5Pg58/JPaWoc9LkHBdf6YqvObOE7kbZXOWErkkNHhKmWBpDE1yMOFXK4ut939gHDadddxrqpDOIjQ7cR34DBtWOpevcdmc4wl32bkrymahyE2VdQzrj0CEN2q3v1gXWS1wk+S7TTMbI1qUGs623ZVK4++1eHzaQFofzM5pWeEp3n5GOMmLpbKC1tR5ugfmlheCRKsYZFWRfjPmkC0tqRSW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Why do you keep not CCing people from v1/v2 discussions? David said that
already on v2. It seems rather rude to me.

On 3/3/26 9:15 PM, Andi Kleen wrote:
> When a smaps mapping is only PMD mappings report the
> PMD page size for MMUPageSize instead of the base page size.
> 
> This is a revised version of an earlier patch that tried
> to report multiple page sizes, but there were many objections
> mainly centered around compatibility for mixed page size
> reporting. This patch side steps all of this by
> only handling the non mixed case in the simplest possible way.
> It also avoids a problem introduced with v2 that page sizes
> for mappings with no pages were incorrectly reported.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Will this be useful in practice or just confusing? There can be e.g.
misaligned mappings, or other reasons why there won't be 100% THP
coverage. This all or nothing value (IIUC) seems inferior to the
counters we have that say how much is pmd mapped, so I'm not really sure
it's worth changing this.

> ---
>  fs/proc/task_mmu.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index e091931d7ca1..a5c7bc88a539 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1371,6 +1371,7 @@ static int show_smap(struct seq_file *m, void *v)
>  {
>  	struct vm_area_struct *vma = v;
>  	struct mem_size_stats mss = {};
> +	unsigned ps;
>  
>  	smap_gather_stats(vma, &mss, 0);
>  
> @@ -1378,7 +1379,16 @@ static int show_smap(struct seq_file *m, void *v)
>  
>  	SEQ_PUT_DEC("Size:           ", vma->vm_end - vma->vm_start);
>  	SEQ_PUT_DEC(" kB\nKernelPageSize: ", vma_kernel_pagesize(vma));
> -	SEQ_PUT_DEC(" kB\nMMUPageSize:    ", vma_mmu_pagesize(vma));
> +	ps = vma_mmu_pagesize(vma);
> +	/*
> +	 * When the mapping is only PMD THP report the correct page size.
> +	 * When multiple pages are there the user has to figure it out
> +	 * from other fields.
> +	 */
> +	if (mss.shmem_thp + mss.file_thp + mss.anonymous_thp == mss.resident &&
> +	    mss.resident)
> +		ps = HPAGE_PMD_SIZE;
> +	SEQ_PUT_DEC(" kB\nMMUPageSize:    ", ps);
>  	seq_puts(m, " kB\n");
>  
>  	__show_smap(m, &mss, false);


