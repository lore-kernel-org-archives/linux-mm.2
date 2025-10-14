Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E971ECCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 06:28:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EE318E00B0; Tue, 14 Oct 2025 02:28:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C5CF8E0005; Tue, 14 Oct 2025 02:28:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DBBD8E00B0; Tue, 14 Oct 2025 02:28:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0DBD48E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 02:28:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BC8DEBAED1
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:28:34 +0000 (UTC)
X-FDA: 83995740948.07.B9CF843
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	by imf28.hostedemail.com (Postfix) with ESMTP id F13F2C0006
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:28:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LdfSD6nz;
	spf=pass (imf28.hostedemail.com: domain of hughd@google.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760423313; a=rsa-sha256;
	cv=none;
	b=bZOvSfXGBtQR5u4EyuDpAVWgW8mFRwKTP84eSb3ipU/j9dtXKyJ+zBD1D7DuPCDN1906Le
	9SXP6FIU9mTEY9oTpjW8mn/jy9Ly6NHepws7Caxhf8rOybrFWs38casW+/4bS+QKJJqUHz
	2elACObY9XfIhoH2ZJ03nTASoHbne5c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LdfSD6nz;
	spf=pass (imf28.hostedemail.com: domain of hughd@google.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760423313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=brM2AXzbshOug5S8YTD/rMQwcF1ZQ1CEjKwrbSaUSno=;
	b=zF1nykS/+OrUN7dTDAtOaXhFxfy9+IRHo8OgpOKLrbOZHEYChr6WWmHJpnxpi46lJH0erq
	jgJ2nhEFmt23fyozAhwyiOxR2+3qLquWIiHGRZs1flIKf+aon3BQZgS2h+LN4SXuVJznDx
	sTNG7NCgVuQMxzriqHynAU7wYtUq+/I=
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7ab0012e05aso3590711a34.1
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 23:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760423312; x=1761028112; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=brM2AXzbshOug5S8YTD/rMQwcF1ZQ1CEjKwrbSaUSno=;
        b=LdfSD6nzhfpFRt/SO77j8mxW3sPVOBtX/bLFHghoawzOOjWt6c3rLc6UvvhAsjXa0e
         p7H329kuJx0xJj1lMTf6qwLwfPBM29LKDwJXrwTAiGJ9Jg3heXq/wsLp8QxKf1wXro+8
         rnvw4a5hN5CTcQ0GOLnViEjLqDkfQnWUknXR7b7nZ0Zt8bcuRYwSvQA/7rt0E08+WBGv
         RkD3rzvhOE030pzEQX+aaZy5P5MKQyoY6iZk8ac5LG/Y034ZwBTEsWbGLFaUKZEJHuju
         mHAIsH7pa2WEHVhUjUknMfjiioNmloOPngzt6K3P8KE66m2d/M5cO1TDzEPdMmFyrdJg
         8icA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760423312; x=1761028112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=brM2AXzbshOug5S8YTD/rMQwcF1ZQ1CEjKwrbSaUSno=;
        b=nxFsw9ybnE+DsuhQJC3hMwcPu+wo8D5Ul9ZcWrG20Ff0FDqGTn9HjVlJYtH2RijNwl
         nMY4a1KRIGIlB2Rus8tLZENmBwlaCxb2Z1RevN8CoUrzuRYmNsMxCL5pHab/mZ6BO7pt
         WGlqCfn2baMKr2vM3SL/j4EohpmptQuuXlO5lP9knAIqhu1JdmA7bM5serdKRrN5czlv
         bcRTj72Lq9vHo9RdKBZKV2GpjC+gKO/6KHipxmuztLGe29UsigzTrk/Zuc6BaFb7zIAo
         0diU2rYZf61PcjgnQcWlnGP0+CmRWsPrmLB+Ozdmof5siVVedIQADrYW0i/52J+ELG4E
         kEdg==
X-Forwarded-Encrypted: i=1; AJvYcCX8xeM4GdCPX86Za4LkcWcQaGHg3RyM3Y7C59ronAgFdz+y7LvzmNiMj+7p+0vke1+UvS5p6TM7/Q==@kvack.org
X-Gm-Message-State: AOJu0YzR40dS1qKpeokBmaP7JsB79+ImjOfF188mKoGPYZEJOhRfAC5l
	xk8Ydf317cv1JH4jDBPBIvQHhs4J1JWvy3dFdNS9+NEt4mGiW6XOe2MvBzxvsAe7qw==
X-Gm-Gg: ASbGncv48IWlYA+kX2SsVjZHDyGyr99oR9GCwrGM0AGwQOq7uAWl+XdEjiDLd1Fy6iz
	1I50obOHbdBHEwciQnK5Yhy3SKTlAUFck0Tjj9wGJgdyYtwLhcx8Aijn/VGfo1I33o+X7MUn5Zd
	ZsbCrxfo9gvmwRHldSIKKA6AZUOiHl5qu83gCaOyt3ScoiVGXVQooVzbhpAMsbhTOJtXveTR6RN
	PYcX3RMiuDZuVmFJxZ0D9DUQjf0p1levv4rY4eUCXREas7dlw4aVzk9Q5OIXd5KlBY3WXhNO8wr
	3G9MdNj+F4lpa7CkQnhAgvtt9dhzoicJyaCafQvgNUcj9z2UG5NqWQFVq8tSa3v2DmNUnuQBJD7
	g0j+I/GckMxNAraCz0VbJfIZZ+wFgPPIXHJ7dUrxeRjvXD4OGXX1c7CLTRd7UdBc0RsKhI5CZpk
	/nx4913C8t9HlU0IJMW/OSIJgi9OzCMB7/
X-Google-Smtp-Source: AGHT+IHpAC62Y/PpF9N39pOEV4oQ+R34+qD97A9mi5Ss82ojK2v3fSuKrUmSuLa+MCNnAOAp+Ihp0w==
X-Received: by 2002:a05:6830:710c:b0:744:f113:fef8 with SMTP id 46e09a7af769-7c0df7becc1mr11002097a34.35.1760423311621;
        Mon, 13 Oct 2025 23:28:31 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c0f915eed4sm4209133a34.36.2025.10.13.23.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 23:28:30 -0700 (PDT)
Date: Mon, 13 Oct 2025 23:28:16 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Kalesh Singh <kaleshsingh@google.com>
cc: akpm@linux-foundation.org, minchan@kernel.org, lorenzo.stoakes@oracle.com, 
    david@redhat.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
    pfalcato@suse.de, kernel-team@android.com, android-mm@google.com, 
    stable@vger.kernel.org, SeongJae Park <sj@kernel.org>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
    Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
    Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
    Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
    Jann Horn <jannh@google.com>, Steven Rostedt <rostedt@goodmis.org>, 
    Masami Hiramatsu <mhiramat@kernel.org>, 
    Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
    Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
    Juri Lelli <juri.lelli@redhat.com>, 
    Vincent Guittot <vincent.guittot@linaro.org>, 
    Dietmar Eggemann <dietmar.eggemann@arm.com>, 
    Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
    Valentin Schneider <vschneid@redhat.com>, Shuah Khan <shuah@kernel.org>, 
    linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
    linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 1/5] mm: fix off-by-one error in VMA count limit
 checks
In-Reply-To: <20251013235259.589015-2-kaleshsingh@google.com>
Message-ID: <144f3ee6-1a5f-57fc-d5f8-5ce54a3ac139@google.com>
References: <20251013235259.589015-1-kaleshsingh@google.com> <20251013235259.589015-2-kaleshsingh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Stat-Signature: 3gsgr4ty6goyxh8ta7nm7bppoigwhzxs
X-Rspamd-Queue-Id: F13F2C0006
X-Rspamd-Server: rspam09
X-HE-Tag: 1760423312-617840
X-HE-Meta: U2FsdGVkX1+iUYFkp/Ny/Ro6TV0KJMBme631qbEmX59fQIQbmXK9LD16PjRNxJ1+Z4gitcXiqZB6y5bMHl31TgSyhMGwsEaTuTrOpGtamSIbHj4DBJWz5VkV2XbdK9l7UJWZx+qQoyMzEyVIjsVTW5z6/Yo9sF5MRbKRGvZpV7O/EYk9fs7pefBmvD5uSm0um+AiIjw6FHVzR+iEpuudSupWVNMh7VPqtj2ceu/+4uRFC9ndxf42KNsnY6aV1d3vjvQixm7wi1Xzv63D3AUXd8B6BfiIKGbRdH5NC0zVw/X5rkUlU9GVjcCZ3n9YbpVVydVAwunoFKgRnLX/rYDk0nHlDrCU329I13IFyqZbu/P7+3iRb5JbcTHHESnrDrTTKV1CkuhJj7l6NKqm1Gh4VfAzB5b9/0JB93m4+J06laDYIaH24dJwUmcKZP3j6FMm56DvHqFdWf5Ixx3E6O50x9C++D9/wfc+y9SEhzpDNTTa2/a1Oz45RUIp4zvd2gzq0e32e6YgCxLOslGO22m/pESKMtBFhXo41BJ9FSM2E0KTFKfjyB9sDeVHDVaOmHQW/BS//8mEXaumSuOjInBSGPKSN2/jAFaNJxiSJzen9R8xbta18VZ552qZmBStNqzxRKSpOJJkM5nUS5euXrmOcEgSXLb+VSqlXmh7zjFtpBIG0nJ/6kbiJvDDvmt+usX11Mf/Jq5FXS/IkYHOrWOWjwmoUtqpkXVxeHSL4RsPpcb1lxISBUlZj471BXLOhQsu1IELrHQf9ek8/D+pE71+I7Kv1NtVtZyCCwQNrRzZIADxIAgYmthDdmXLpFRzNodWIdvmO5TD+VDi6pQk8PPaAhnr90LfBXzQ0IYzB+5aQlHpUmJPBZcxFc0tFnt7E4GP8SgMqvS8dgqMYq31RNggEmDhPud1fAAQBDYWqgJXCSMylFGxlpSh3dbSKOpt3aRJ0VRBP6vF4lFWY3IZ6xU
 T1f69FpS
 hG48CBmk65dFx+iAAN9/44mmoPYbrH7oLzBbnv3lbZMRTrknVU3H28I2mUFb3xegYKGczP5fkwGuei2T5rdhsVWudF8VxXwk9qh4EzK/CRIqN0VCSAQEFs8rDBFrWHodeBJQDuJsbZBVAcRiG6GqxLDcdxFtD/nQAGqE9h2/6KOG7CILkjI2tKmzGU5O44U0odvO6/8//BOo7V8jBw7gABCCt9hQxA9ViYehJAP1JCnsMu8Kf5ClmAfj3ITOkfxNGvBaUW4VZZ7Zx6uGDgGDbwCelUqkCKygXvo51YtIk9/bgdU45PnFYdVbBcCHhWYCnhmjSDPTw/2HiRYutLkCtmZoM3u5Ddmidwq7xQMypWiUcvOaCASYraVih2dXB4eTXDsdpHO00lpQjNI4PnLZdQ1yDR5l3KyAnXzEmJa0AJgO5GkNRX/rA0SoOaUzbRx3lmDyfthDifv7wkJsHALMu9SmgWjcoEWa5zt1z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 13 Oct 2025, Kalesh Singh wrote:

> The VMA count limit check in do_mmap() and do_brk_flags() uses a
> strict inequality (>), which allows a process's VMA count to exceed
> the configured sysctl_max_map_count limit by one.
> 
> A process with mm->map_count == sysctl_max_map_count will incorrectly
> pass this check and then exceed the limit upon allocation of a new VMA
> when its map_count is incremented.
> 
> Other VMA allocation paths, such as split_vma(), already use the
> correct, inclusive (>=) comparison.
> 
> Fix this bug by changing the comparison to be inclusive in do_mmap()
> and do_brk_flags(), bringing them in line with the correct behavior
> of other allocation paths.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: <stable@vger.kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Acked-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---
> 
> Changes in v3:
>  - Collect Reviewed-by and Acked-by tags.
> 
> Changes in v2:
>  - Fix mmap check, per Pedro
> 
>  mm/mmap.c | 2 +-
>  mm/vma.c  | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 644f02071a41..da2cbdc0f87b 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -374,7 +374,7 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
>  		return -EOVERFLOW;
>  
>  	/* Too many mappings? */
> -	if (mm->map_count > sysctl_max_map_count)
> +	if (mm->map_count >= sysctl_max_map_count)
>  		return -ENOMEM;
>  
>  	/*
> diff --git a/mm/vma.c b/mm/vma.c
> index a2e1ae954662..fba68f13e628 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2797,7 +2797,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  	if (!may_expand_vm(mm, vm_flags, len >> PAGE_SHIFT))
>  		return -ENOMEM;
>  
> -	if (mm->map_count > sysctl_max_map_count)
> +	if (mm->map_count >= sysctl_max_map_count)
>  		return -ENOMEM;
>  
>  	if (security_vm_enough_memory_mm(mm, len >> PAGE_SHIFT))
> -- 
> 2.51.0.760.g7b8bcc2412-goog

Sorry for letting you go so far before speaking up (I had to test what
I believed to be true, and had hoped that meanwhile one of your many
illustrious reviewers would say so first, but no): it's a NAK from me.

These are not off-by-ones: at the point of these checks, it is not
known whether an additional map/vma will have to be added, or the
addition will be merged into an existing map/vma.  So the checks
err on the lenient side, letting you get perhaps one more than the
sysctl said, but not allowing any more than that.

Which is all that matters, isn't it? Limiting unrestrained growth.

In this patch you're proposing to change it from erring on the
lenient side to erring on the strict side - prohibiting merges
at the limit which have been allowed for many years.

Whatever one thinks about the merits of erring on the lenient versus
erring on the strict side, I see no reason to make this change now,
and most certainly not with a Fixes Cc: stable. There is no danger
in the current behaviour; there is danger in prohibiting what was
allowed before.

As to the remainder of your series: I have to commend you for doing
a thorough and well-presented job, but I cannot myself see the point in
changing 21 files for what almost amounts to a max_map_count subsystem.
I call it misdirected effort, not at all to my taste, which prefers the
straightforward checks already there; but accept that my taste may be
out of fashion, so won't stand in the way if others think it worthwhile.

Hugh

