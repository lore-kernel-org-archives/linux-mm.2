Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D6D2C88E7F
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 17:45:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 156AA6B0088; Wed, 16 Sep 2026 13:45:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12DEF6B008C; Wed, 16 Sep 2026 13:45:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 044356B0092; Wed, 16 Sep 2026 13:45:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D16056B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:45:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 43CB41407FA
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:45:28 +0000 (UTC)
X-FDA: 85220352336.05.667B6DD
Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1E68D18000C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:45:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nuAaffrY;
	spf=pass (imf06.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789580726;
	b=hkXBbpP4PqWS8Cygyb7UlvBuv15uSPc7jeZZhTi0GvaFvNsvkz3sjjuXWCA7qoHAduD2oL
	wRz4rAD67UANrGeSP0mOfFCF0WgztIHwlYFVYoAc+GPBwcrdgEkc+/m3WEO/rAKgWiJIo4
	U/TvF5T76x1SCkmloGiSl9TtjZYOX8M=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nuAaffrY;
	spf=pass (imf06.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789580726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IOYv3QgMRUMifmGGTF2BeO7ylrbnq7wWgArM3pERBA8=;
	b=MmCPJEWvScE1uAMkos5eX2vAdv6fn04iBW+t2+g8r35NPUrRGaViGtAXjrjCYaKeK1zBwu
	LpvlENZfj6s+9Ox3uHl6FBG+gMEUnN2FGWAoht3aCmTbswsGYqKWpueX067QD/nE12CLx9
	sTRh2rg8RNil1eA/MnijVEVEPueHwVU=
Received: by mail-yx2-f12.google.com with SMTP id 956f58d0204a3-66fb7488033so185182d50.2
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:45:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789580725; cv=none;
        d=google.com; s=arc-20260327;
        b=M0CWg4cSuSM1/mVaY0+dA5fpF6dmascRVwgGKiyhT3nORPM+iPiJHGD/dyhuwz4hnQ
         cjSQD+jADe/ZvbuSxZP1gL2Lu4SqSR1OXPU6hlMwcz0JhBva54hmw7EhoOG1Jx8RO/bb
         qeHLXqzBj4CEqSz9/p2VfmzuFiW7n5/14D5mpXYT3JCIN9AyeilQZc609oVz+cKLWZHl
         nOA0h0qiiwX2zBbKnDI6JBzN37LoseGebqmaYB/ILmdmRfGCzF5oedWtLg0HpccJSa7Z
         3iicYBBe2tI7dLO7TibLJ7gFy8FUQOFHoTZXY72JlPmrp4ofPLoItxcA7Tai5t7fbDmx
         JARg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=IOYv3QgMRUMifmGGTF2BeO7ylrbnq7wWgArM3pERBA8=;
        fh=hfNtkLD4PN812ndipcjFAWUO4jXuStyhQFEhQsAZ+so=;
        b=WNfgT2V+d4U1d2DM7gTjXmIu9BrACZekp/fipuqPMrR8GW4/vEadCLPMVmtJmHoprm
         eKJ6c3obG5ejUsg2ukzJA60Olxkl0MGVX44C8mVIKwdlgvaG7LPGPjHPoDBBMndu7gPj
         2xQ8VBwrih+lgthnPwOZRi9X9nAFu9XSIMhOr8HABR1ViWfGzluYKUZq8tCmE3qK3Cjf
         /gsEUgiSGycmkd/tX3lAM7+q8CackbvF3QtUoPfVBNvydvn1U6AiidoEe5WhzRKmkKz0
         hu8CfY2Ekd0W8oigtlM/Cn8Tw5NBxvdIXmClq8ONO15v3t4lKMuG3M+DqdI1YcOYEODX
         Dz2w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789580725; x=1790185525; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IOYv3QgMRUMifmGGTF2BeO7ylrbnq7wWgArM3pERBA8=;
        b=nuAaffrYYwzsErkJPSV6H0GAo8LsT9zpr4U4L9wS9YXHShDocz3U494Q9Gk3w7XvJv
         22AlA0khfmef+NEzAC+LQ0oHNvumnUbkYzyro6T4PyZbJFiyHf46i/Dmk0j4rP/3buwS
         fTp6iRYoaBbzmrMX48N8UMGLeAgxR7s0suVLp4lkAXCqr9s8Vw6hGDuPvvL1+VmMvmKW
         tKAW7IV9oj26hv6RrDRJI15KGkuSzjGgJaP5d5t+CGwZvfqDxo5KpgvTpIX9tkZ3r8s1
         cTW1NGc0XwG32u1gQuzvtnXBRzwyYisjmdGUbT6NBVVpgpmp5qDjJPDBLacWcnUSOfk/
         +FXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789580725; x=1790185525;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IOYv3QgMRUMifmGGTF2BeO7ylrbnq7wWgArM3pERBA8=;
        b=DY/st4HC3SUNCWoEoKEVmXKkbKiTXJaoOvS5akAC20E62WGLadAAWDFl56rboQVGIq
         3cbYIj+7tzR1velRmHM3BuR4xjNaoZdLMQg42bCX+LBdgvZwjiJ4mLCZSJL8S5EnWRVA
         0D8CovPpzxMyhlDEP5w9lDvGV6qe1dTB5wDk4ueGMiSA0hLAFJDJYLFXemRf+uC13GA+
         u+GXmtGcE+qyths7lzCFBGz46IpeqWu5ChrmH9d18Sc/yr8nQmytWosJ9/kYmWsOMke2
         /loA3TGsz9ABP9N+PlU5AzNWUcMpJEE6W5mESsT1XtAsNZPDTEbYmJPn2Hvs8OHF6jYr
         fOrw==
X-Forwarded-Encrypted: i=1; AKwUvBwY+bFsclU7XrFNBpQ0PXeWD/0A8llh2p9HDDQVJFsP7zgUSa8JBPfa74amgQ4TQ98sH+M6WGjb3w==@kvack.org
X-Gm-Message-State: AFuF++mnHn3I04FdujoOdkLvDz5piQEE4qsmjBDC4jGIBBWV1v22V9+E
	iUbjePxfWwScVL807pzGCooGbPmzdndbGyj+SAHvJZSlaQSufJbKuP93BpSmH3LqxABRlaYb3Uc
	zgmTJMwqMoqE5YJc2ZT7T82MyRzMiW18=
X-Gm-Gg: AYBFou1dUptMyTnmZibcepSS5SjvN9AsJe/iWuyyh605kZz2DAJza6tHUCEvOnpH6YQ
	k3FReW+qlGxQHGyLBS/CBKywef9u0n0yv7dfUx/HIlzxzCl12dWP22oMnVyUiDXFlLv3kD2b6zE
	3JSKepgBq1I1jTixX00q+u2ZzTtanE9o5B1ZrtZ3xkmq75JqnlbnF24Z3K0za3n8lrmwaQRWxLM
	o7e4LqDcQsHuqMF7pit2AnOyBeZVKp/mb+MxsGpgNjaWBAOILYO1/sdEsDSO5CMh8Z7gfYYAg2+
	uYBgZyv5LDTRXhE67FgcFO/2EsE40zXj4JwYaLvztQr/FUEjBd4avg==
X-Received: by 2002:a05:690e:174d:b0:671:335c:d6b with SMTP id
 956f58d0204a3-6716344be02mr1247899d50.5.1789580724461; Wed, 16 Sep 2026
 10:45:24 -0700 (PDT)
Received: from 95991385052 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 16 Sep 2026 13:45:23 -0400
Received: from 95991385052 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 16 Sep 2026 13:45:23 -0400
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <20260914093300.100495-1-huangshaobo3@xiaomi.com>
References: <20260806123020.90869-1-huangshaobo3@xiaomi.com> <20260914093300.100495-1-huangshaobo3@xiaomi.com>
MIME-Version: 1.0
Date: Wed, 16 Sep 2026 13:45:23 -0400
X-Gm-Features: AcwNN1UbSz9j_YK2TyroR0WvWmqVkz_Hz7gqfmErLvR7rOVGTQ8tgDgYEplJIPk
Message-ID: <CAPAsAGzVsmj4xRsJeBBBt5FvgUqWa7eyb4w=EBkm8GGeLF1EhA@mail.gmail.com>
Subject: Re: [PATCH v2] fork: reset pointer tag of vmapped thread stack before vfree
To: Shaobo Huang <huangshaobo3@xiaomi.com>, mingo@redhat.com, peterz@infradead.org, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, akpm@linux-foundation.org, 
	david@kernel.org, kees@kernel.org
Cc: dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, 
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, glider@google.com, andreyknvl@gmail.com, dvyukov@google.com, 
	vincenzo.frascino@arm.com, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1E68D18000C
X-Stat-Signature: mbe7gkgegdcfys4fpdtyj78fddzwkgxt
X-HE-Tag: 1789580725-283263
X-HE-Meta: U2FsdGVkX19Kbxy/aBK0OLlAA1sM8bsAgukUTquXoTeIVFlq04mu0tObCjoF+K7B4LbRiloYHbVdOomgTB+XE0zlyBIQV5ubYuol3GlnMPLxDs+zHfI2gQsrxl9EXlG7V1K9CV/H1bQPuVbrmOCl96FBFeCVhYIXr7noqx2XKiFDVwbjIGdboa+qSD96Kh4IDtpB1WMnhNXUWseNNN1pd6R0PGaHpLoE7qxqVBVPeCJvVOfJfmXN2bPAnl8lznbYF2GmmDfJl0fpe8Qp71o4O+zZX3UU4iVv/oxTUTACt1nH28gV92h81RtUnzMfJVowe17Nh/GPODP3KpAkn9WDkDmOBm1sn4XaCTMQ/mUcI+PPWZFctN4/CFJiJW5jgHddYciruCG+y1DDtgqR0nul7anFpH+E9vNMkHVVQ0tEABW+vStB5K9IK+SPOiK/H+RveZZ5cqkku3T7wgkBUbqVooxqul1AX0F58OoDQoC+dSJShKLACK+tyQ7I23G/bgYlWPPXYKxGEKkmzLMDw6tDlnyBrarx9zzDpjv9AYdH1VCAPIQZTI4MI02mfO5Y7qbNHMqm9IT1+9CEbY+xiflXXqOcNWqADuKBC8WBGEfD8uFl/UXCYdISxXVPo2cIDUemgmIxH1x3kqcctYr8OsNRQKtyTENb5ZGzyZHwMhoo1vQZx6vJSJIo2kUp8LeESNbiJ4vpAS+pECYTrAlqTYrlDnkHfxFIAHiPEGynHXky7CPFfmXLi6Ga7BUg4ocpr3eQtcmtXypw1EroMvW5O9HV1uHN/tGqxm1WDkEo55bFzYXOsVS/0Bt0rxJA8mQr7NtSmP7itQs+VUTfsHLek3ggI09OBgybU6bYGve8x9yvJ+0INZCtmscZVQnIiHY9Up0A8IgfJ+58zSrMUNv0b66OscIsYnLrfsiaoI/13E2kjpe+kJ2SAGzLLHkA5N5mG5VSoRvQ4fcoLgdv1cHcuaw
 E0pGae/r
 QCQQfbyIK6KSTvXGLR1/ROeBsTDrdB/GI50nN85NOWiIwxiRm8ds6j05CfPiQexvmOF3dIvVVahodOCqq5Y/zqhnANXZdeUAAOgR+hNa8E4+SkJsby/uBHVtBcdWdzgeq8kwcOtCOPtHMwUgxjA0QulBCvCs8Lq9zg4yWr9qKXy27tLzJyXNnjlBOV7ZulGiwrrE+/5kQVSMSdfKNKhcw0+rDwN2D1ycaXEDpqP3rFwoFAM1UILzHSrwZWgl06jAL843uiH1pvHduJMoF2clPVlTZf9j++qOVN/36yildoG7wD/yrPRRo4+5gFoBfbHlym79hRWNmRA1d6QO8qiTUZOek1zJZYRj5B0AlzeAJ+2Yi5wZN0H4/VyZCWo8YRZRWVSbjyFbofWRIxHmhzgGOAQY0mgzQgJ0bzm7dglASIiHqBi1ON10jlszCkRrDKENPyo1ucj+ga9gB6ciuYXfh7jmV++UjntK4YG9bdnHYUBsVio/b4Z4DABYrxZEFH4K5GmoNc1pKcqR1Xq/Uimyu9yAI22rij+N3n8TI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shaobo Huang <huangshaobo3@xiaomi.com> writes:

> thread_stack_free_rcu() frees the vmalloc'd thread stack via
> vfree(vm_area->addr).  In RCU callback context, vfree() routes to
> vfree_atomic(), which calls llist_add((struct llist_node *)addr, ...)
> and writes 8 bytes to the base of the region being freed.
>
> With KASAN_SW_TAGS, vm_area->addr carries a random tag.  If
> kasan_unpoison_task_stack_below() has rewritten the shadow covering
> [base, sp] to KASAN_TAG_KERNEL (0xff) -- which it does on every CPU
> resume for the current task's stack -- the llist_add store checks
> shadow[base] (0xff) against the pointer tag (random) and reports an
> invalid-access, although writing to the base of a stack queued for
> deferred free is legitimate.
>
> Reset the pointer tag to KASAN_TAG_KERNEL before vfree() so that
> kasan_check_range() short-circuits the check, the same way the task
> accesses its own stack at runtime via sp.  The vmalloc lookup is safe:
> __find_vmap_area() resets the tag before comparing against va_start.
>
> Fixes: 9f7d416c3612 ("kprobes: Unpoison stack in jprobe_return() for KASAN")

This commit merely renamed the resume helper without changing what it
unpoisons. Only generic KASAN existed back then, so it cannot have
introduced a tagged-mode problem.

The problem became visible with

  449e0b4ed5a1 ("fork: clean-up naming of vm_stack/vm_struct variables
in vmap stacks code")

which changed thread_stack_free_rcu() from vfree(vm_stack) to
vfree(vm_area->addr). vm_stack is derived from tsk->stack, whose tag
alloc_thread_stack_node() resets to 0xff. Since that commit, vfree_atomic()
gets the tagged vm_area->addr instead.

> Cc: stable@vger.kernel.org
> Assisted-by: zhipuai:glm-5.2
> Signed-off-by: Shaobo Huang <huangshaobo3@xiaomi.com>
> ---
> Changes since v1:
> - Drop the 12-line comment; keep just the one-line fix.
> - Fix the Fixes: tag to point to the commit that introduced
>   kasan_unpoison_task_stack_below (9f7d416c3612), which added
>   both the function definition and the _cpu_resume call site, not
>   the 2016 vfree_atomic commit.
> - Add Assisted-by tag per Documentation/process/coding-assistants.rst.
> - Use real name (Shaobo Huang) instead of "sparkhuang".
> - Trim the commit message; remove the full KASAN dump.
> v1:
>   https://lore.kernel.org/all/20260806123020.90869-1-huangshaobo3@xiaomi.com/
> ---
>  kernel/fork.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 45300f59cf2c..9a66b10749de 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -238,7 +238,7 @@ static void thread_stack_free_rcu(struct rcu_head *rh)
>  	if (try_release_thread_stack_to_cache(vm_stack->stack_vm_area))
>  		return;
>
> -	vfree(vm_area->addr);
> +	vfree(kasan_reset_tag(vm_area->addr));

Thanks for report the problem and the patch. NAK on the fix though.
It addresses the symptom rather than the cause.

The problem is not that vfree() is called with a tagged pointer. The
problem is the 0xff written into the shadow by
kasan_unpoison_task_stack_below().

That helper is only needed in generic mode. There the compiler expects
the stack shadow to be zero, so the redzones left behind by discarded
frames must be cleared before the stack is reused.

The tagged mode has no such requirement. The compiler fully initializes
the shadow of stack variables on function entry, so stale tags left
below the watermark are harmless.

kasan_unpoison_task_stack_below() should simply be a no-op in tagged
mode. I'll send a patch.

