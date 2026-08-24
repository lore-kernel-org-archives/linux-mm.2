Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55D70C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 10:50:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 646C96B008C; Mon, 24 Aug 2026 06:50:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F7E16B0092; Mon, 24 Aug 2026 06:50:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50D456B0095; Mon, 24 Aug 2026 06:50:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C2B56B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 06:50:00 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B0166404C8
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:49:59 +0000 (UTC)
X-FDA: 85135842918.28.FB3A1D8
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf26.hostedemail.com (Postfix) with ESMTP id D51CB140009
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:49:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b02rLtm9;
	spf=pass (imf26.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787568597;
	b=5PQwEzCuWY1gGv5dVtCG9qGxkrHTK+bFnpOMCC2iawoHyDVJ6el7lRO9aAPPwpgu4PdIjC
	fnfq757pe2sjXVenfXunZeCa+Ncq+Bbj8hX6Iai2IMSePXzA/j/ve10ZIOFNeew4SUdLS1
	PK/COK5Fv2QOPI1LZDu68O1uqSsmavY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b02rLtm9;
	spf=pass (imf26.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787568597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nOd8+4g2mnunbTTjfkzCI8WvVdyCHxk83j5KrKNRFdg=;
	b=rxC/d4fvYP57xeOLD7/QacgLrbHecqTumIrSFpuso23xm56mpjUy3oDgN9CdvshSTXPCyh
	inwFIJuX/grVNIhvprDL9rWRDf0Lp7aXSOIJaxRbpG+claj95fLjGLqU4XsAtOg8+nEOgL
	2b3Fc4P/bdPEiMFwUfaX6sdPV0B2Rhs=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c197e7e4e94so586340066b.2
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787568596; x=1788173396; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nOd8+4g2mnunbTTjfkzCI8WvVdyCHxk83j5KrKNRFdg=;
        b=b02rLtm9Rl4MtjD3K8YkQ390Ljt9iyAnwRfdg5twO6fRIxZumG7dR7mhV8vrXzBpv4
         bTCidp7+TiPXcXUETvnlw002zPdM69B7+t5gw4qh8Ck3ddkucJC+d4xpxCqO7n7t33yl
         47BMZyW+GXcovJVEd1BByC1LcqHyE0Gl946JKNxj/jgGiDqJNhfU6DpgWRBKd4+nXoYv
         qinUCV5hDmyYFMdnaAriRZCDxZTIup86Sg6j6qsH0+W9EUcRnblu9wlXOE0vVdXxu4r3
         rdXikXsXuIPE3uFWrOo8H9ZksH0yoQbuW5lKRRB9rUwF6qMBamahzE0TmkOruMOZpIjA
         sAAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787568596; x=1788173396;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nOd8+4g2mnunbTTjfkzCI8WvVdyCHxk83j5KrKNRFdg=;
        b=KanRDUJBu7mWDZB497K0Z7xkSkEd+59KuLKws9OF16tFf5hZXJJNB0HdHE9YIV9YlG
         uqT7vL9XY+wRfiQmeRx/KsgNSg4kGbetsmumPR/2YmeM7EXdYY/G3RKvQiWA+sh+2+QI
         t8NjR1QXm2SU+pWNDOkJl+sPuAvKinN5dpCgbfos9mxwK8qyij5SAWM14mLkjc5jZZsA
         YYcnwd0/4rNd7soupGKWNDPtsJ+6RV/5z5mSyxXtn+qSfr7IrSKSs0WY9y2fHK+vTNEF
         143RtG9c0tfCEPpnTLOHP8YRasZhor68lW5lX4NOcXOemso5LzDenMPLeFi9TG3PWWga
         osHg==
X-Forwarded-Encrypted: i=1; AHgh+RqzhrMxOrzUwvmMRvu1GmDpzrFDzFhLP9escHhcYT5ZZ9ZVfRlQ0mIwccSBZkLDM+i/yT1ana4usQ==@kvack.org
X-Gm-Message-State: AFuF++lwOIyjpRctd+r+MZbWW8gFAY9cN3GgbF28X8TDliruKOQRE0N2
	mjQFTHj0Ox8mKvvYMTo5BZ8Xqd23NF/IwMoaGiFA5IzYopgUs44V5Isq
X-Gm-Gg: AR+sD13nATLyaWQ0P56J+wytKEGcDVfp1eInNgU2VobCc7nVQ2AEYb+Wu4zRsa4WEoj
	bANPtWzpjan9Ta6QYpW7B8UFcjb/5CKmOzlBIU0UqYxz9NhZExLCR5Ibwr6/QAb/GUxv1g89oqV
	SGCyTZOKcgsCbLU4UDhqDGtbVDl4kQsOP/+CA0rrFed1xRro3vOu0YmW881y0bZgdXIdjznSaxw
	csYaa8gHDmsLJmw7aPN50e/WCQlkASRlRMXh0dF3GREpFh3ZgKp8Z/78tUU/UE+srMImIt932B+
	ALqSfGzBDh5o+HxipFERqYRxPB9yZomOXIw4pf9G1YrXSY3dxh4GzY9ySnldqyh/5cMxMgyzP6U
	j7QlTLUvER3GZLn89O73kvUlp57yVbTXBWHOxTgNj6BAEBAlMqLU+0nbWTchCySeRND04N+WGo5
	T9dWYGN1RLrx5k74aMjnqTCm8w8aZn40b9EiLbBgKmIBzRc/d9ImUoAEiGViwp+tZQL+yp7LZ49
	50p
X-Received: by 2002:a17:907:97c4:b0:c20:af9d:454a with SMTP id a640c23a62f3a-c2492621bf8mr1999188266b.16.1787568595897;
        Mon, 24 Aug 2026 03:49:55 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5e:1100:7303:647d:7cc4:8552])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249672becesm1236373966b.42.2026.08.24.03.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 03:49:55 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: andrii.nakryiko@gmail.com
Cc: akpm@linux-foundation.org,
	andrii@kernel.org,
	ast@kernel.org,
	bpf@vger.kernel.org,
	brauner@kernel.org,
	daniel@iogearbox.net,
	david@kernel.org,
	eddyz87@gmail.com,
	kpsingh@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	matt@bobrowski.net,
	memxor@gmail.com,
	song@kernel.org,
	tasos.papagiannnis@gmail.com,
	utilityemal77@gmail.com,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH bpf-next 2/3] bpf: Add user memory access kfuncs for linux_binprm
Date: Mon, 24 Aug 2026 13:49:30 +0300
Message-ID: <20260824104930.83453-1-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <CAEf4BzZTM5SehNnM83U3Kj0cz=NN=JwUtG-pcvSHdvZBsHdM3g@mail.gmail.com>
References: <CAEf4BzZTM5SehNnM83U3Kj0cz=NN=JwUtG-pcvSHdvZBsHdM3g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D51CB140009
X-Rspam-User: 
X-Stat-Signature: fuhmc5tgsgfigy3qzyo9f4m7nkn7rqkd
X-Rspamd-Server: rspam06
X-HE-Tag: 1787568597-476464
X-HE-Meta: U2FsdGVkX191mpPV9hd0Bwz02VGh2A7DYMlPMyO6KK6x6aTFKIRWYX7pjwrlFlTk4b7wLFRf4bsEmyBcGVU1ynTMi7fbBmSs3GtwGnmUcs69NJJB1FJXeXyR+AyOmSCJLT+S6wnQmaP2R+SZIrKZL4JM5/S5pY97Jv0+Aev3eioFqyA2P4NnDp46XZnL6L4fhrrzsO1QsOUU60vs3jxKqUWH0n4wqOFo2V4Unqn5NNFYJ8KWIqek1sFrdbg4rYDrqNOAqHXCRgg7H2Z7CUm+PDvz5h25egihhfBLFRhskV/Q5Nn9yJFWFNEbiP8GYnS8sJakGz/5hAFWHC5wsvOHz9s8RcIjaf+CefaQbV4ROyYSM8KPpz+RcF3xC1Cd/3ns6eHQhX0jxP0o3AwBA4NhcHiis7G93uiu4SUuKEkEOTdZcaPLhzM4gyABCFSYLY0Pq0g4j2leYTRafgKouQNaFzUxfk2hse0zRAEsoN4noJZOfOI+SaC98KlUHntCC3FYocrYhzTQlej2LJga3mPQzAxMbOKSuEWpjrG1n772G3E5w8yhxppUgfCBCp0UHyIFX9exQryzvxxLoQRdRTflE1xnxIypwf+w9Wr5TVsGAKADoGL0cEsoqC0yIOqkvxLQ1dJWXsfUTqf3LiCEhWS9m5OnJwVGKYhdTwbFl6dCRHU8diUVAiHJzPGMBr/DhZi2cc6V+u/IzYJXhsWTwZoan0PqyrClaihhnFBW3w3B6mgBVPklYr5VuvUhqXNV9Px4V2AYdEl3lIy9P6Lu0OApzJhwfZqQ7V235uKXVUXzp7RzccsZmxhKoWH1y0JCvtQJQU0gc0cuyMHzjHBggBJFNLzsJ201VjqvyFcqMadYhEgEEXkczyv7sFJqmxRjoakP7LZY42UnhCLG2zAY8mM/qVN7YXw5lsrbmAMA2qyDmpQYCzy+enmuDW7fdy80DLy3JaHXJTO36+rFWVfPn1A
 GmmvRNIQ
 b2kXeWRdpncVv2PKnQdtB9ifx+jIcC7SYVcepiwABGyfD6YtQ/dL8tIIj21Z3eJD+EIb0gVXs6EnjmSPJ70CcgXlPLZw8e6D2X22Ei6/7qkgFwmNtYbTHwE4BKG7wZ9W+rhx7eEeYsBqWji8eXfSOSozMAa6bRnnFz2qPFgUkBcpq2731x6pbfSwTH/K/EhYaXpwErph1j4mO5uPvy3Qw7OaUU6dHnEdCLbGK9zBvrjBvIEJpUfPtU2viscb8QwBpTIlgn5ZgQtgZCC3Lwj+JDXAFfhxnuPxD9cic7GBfWOFAenDRWde6fdnfgTmOyIOrLwVh4uMwYdWxv1QywhS1xyrpaPtkMw8Cpeis1muNVmRHCoqRstjntIT9ea0qPIy3Bfdef+IkRX1+LidSLWE3wgcjU7CqgToeznyC/lFN7OioZwUJPH1hs0hiaDPUMNTAeTw5RNfFk7C6fB0OEMva8xug9Mv+UNxXNF1uhHSWKQXEm5Im+JHRwXP5u2ZR1QkfHO34oEG9PF8Lz4o6Tnk7CM8VH63sowXUdpJ4aSE40F+rBJWiK9GXG1kHcrPcRftv7WDbT83afx3CmMHAsBf8+UeHZteqlskGc6Z+2Ho99Hs+VMVUtTo+j9IShX45jSXoFocinz5jlZgHpEl+JZjwbM2jXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the review!

> making this linux_binprm-specific seems short-sighted and overly
> specialized, why not pass `const struct mm *` and call new kfuncs
> bpf_copy_from_user_mm[_str] ?

> and this seems to belong right next to bpf_copy_from_user_task_str()
> and others in kernel/bpf/helpers.c (and bpf_copy_from_user_task
> variants should just delegate to this mm-based APIs and minimize code
> duplication)

This is exactly what I did in my previous set of patches:
https://lore.kernel.org/bpf/20260811112154.94053-1-tasos.papagiannnis@gmail.com/T/
https://patchwork.kernel.org/project/netdevbpf/list/?series=1144046&state=*
https://sashiko.dev/#/patchset/20260811112154.94053-1-tasos.papagiannnis%40gmail.com
https://github.com/kernel-patches/bpf/pull/13211

where I got AI reviews with 2 main issues:

1.  Does marking bprm->mm as trusted-or-null here create a use-after-free
    vulnerability on the execve error path?
    Looking at free_bprm() in fs/exec.c, when an error occurs:
    fs/exec.c:free_bprm() {
        ...
        if (bprm->mm) {
            acct_arg_size(bprm, 0);
            mmput(bprm->mm);
        }
        ...
    }
    The object is freed via mmput(), but the bprm->mm pointer is not set to NULL.
    Could subsequent traceable cleanup functions (such as free_arg_pages) expose
    this dangling reference to BPF programs, bypassing the verifier's safety
    guarantees?

This is something that I believe is easy to fix.

2.  Does this break the BPF load-compatibility guarantee documented in
    Documentation/bpf/bpf_design_QA.rst?

    Before this patch, walking bprm->mm produced a dereferenceable register
    in every program type. In sleepable programs, in_rcu_cs() is false, so
    check_ptr_to_btf_access() sets flag = PTR_UNTRUSTED. In non-sleepable
    programs, in_rcu_cs() is true but mm is not in any __safe_rcu* list, so
    clear_trusted_flags() produces a plain PTR_TO_BTF_ID.

    Both PTR_TO_BTF_ID and PTR_TO_BTF_ID|PTR_UNTRUSTED satisfy the guard in
    check_mem_access():

    } else if (base_type(reg->type) == PTR_TO_BTF_ID &&
                !type_may_be_null(reg->type)) {
            err = check_ptr_to_btf_access(env, regs, reg, argno, off, size, t,
                                            value_regno);

    so bprm->mm->arg_start loads with no NULL check.

    After this patch, btf_nested_type_is_trusted() matches
    linux_binprm__safe_trusted_or_null.mm, so check_ptr_to_btf_access() sets
    flag |= PTR_TRUSTED | PTR_MAYBE_NULL. Now type_may_be_null() is true, the
    arm above is skipped, and control falls to the final else:

    } else {
            verbose(env, "%s invalid mem access '%s'\n", reg_arg_name(env, argno),
                    reg_type_str(env, reg->type));
            return -EACCES;
    }

    Any existing program that reads through bprm->mm without an explicit NULL
    check now fails bpf_prog_load() with -EACCES.

This sounds to me a bit more complicated. In a prog attached to lsm/security_bprm_check,
bprm is trusted but bprm->mm is not trusted. So we need a way to have bprm->mm trusted
to pass it as an argument to the helpers. In that series, I marked linux_binprm->mm as
trusted-or-null, which breaks all existing programs that use
linux_binprm->mm->something.

Another approach would be to add one more kfunc (i.e. bpf_get_bprm_mm) to get
the mm from bprm and have it trusted.

The reason that I didn't push that further was that mm in general is
bound to either linux_binprm or task_struct during its lifetime. We already
have helpers for task_struct, and I thought that adding helpers for linux_binprm
would be enough. Other than that, there is only one security_*() function that
takes mm_struct as an argument (i.e. security_vm_enough_memory_mm), and possibly
in that case we do not need to read the memory contents, but only metadata
(possibly I am oversimplifying here, but this is to show my thinking).

Unless I am missing something obvious, I can see two possible approaches here:
  1. Keep the bprm-specific kfuncs as they are now.
  2. Rework this around the mm variants that you proposed and add one
     more kfunc (i.e. bpf_get_bprm_mm) to make that work.

Does the second approach sound reasonable to you?

Thanks,
Anastasios

