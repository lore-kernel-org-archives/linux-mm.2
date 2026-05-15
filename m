Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 675D8CD4F3C
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 03:28:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A217E6B0005; Thu, 14 May 2026 23:28:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F8F26B0088; Thu, 14 May 2026 23:28:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 935BB6B008A; Thu, 14 May 2026 23:28:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8325C6B0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 23:28:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2958B40516
	for <linux-mm@kvack.org>; Fri, 15 May 2026 03:28:32 +0000 (UTC)
X-FDA: 84768221664.29.26708CB
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5623F40005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 03:28:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n39RfDmC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=imv4bel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778815710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ol/PaD6xXPeH1cz3x0IVMh0FYdd5XYNZgnuzZiE8wVw=;
	b=5q1NqWga2wps9nNzNpYpYeJVE65SkCLeWpvpEMFjK/nUCjdAiOh88lrpxV/hLG0ycunzSV
	lNoj6Q8i6iyD37t2WixTv0etkhIxgVJm6eQhRwSgADN09rhD3aFkTqoYLexYDfNIYscM7z
	GAe3Hl4nNkCt7zyy/RF75qfM+l4WcDw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778815710; a=rsa-sha256;
	cv=none;
	b=x/j/KwF5CYFm68EU6y6WZqSkRjy0V+Icv2N8zxRiR4qjQNIk9vkMaWWhYYpVGEl1S7U5iC
	VvIFyHpAP6fr16RlpzFBz9cdrWDm8S9yCZHl+xfDmpglQ8s9nYmPBlN6kOI6oG5QV8E7ax
	Ea1HdRFBcLVzc4W/5oRRrPSJdUZ2I5o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n39RfDmC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=imv4bel@gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-836ebdeb969so4038365b3a.3
        for <linux-mm@kvack.org>; Thu, 14 May 2026 20:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778815709; x=1779420509; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ol/PaD6xXPeH1cz3x0IVMh0FYdd5XYNZgnuzZiE8wVw=;
        b=n39RfDmC/Ib3AuSEG4h9FQ0/THZoo4mX+MH7cSBaQ38/K8DoVxN67cZhHuQTqNVrKK
         iYhc9YPyNpA9zmpW7UQHBrmpWknMLXvfPUismIlOrtE7TT5BegqRL8ZxPuHHYNrw/1zJ
         leBMoP36houzo0L/xFBUR4fC24o58MRF2vD63BlSXx1QpXwfWZmLyfY/bkbgKViiORGH
         EnLAxE7ISJ9jvcgXi8dYYUXlx2Dr9NLtBmm2Uv4fulE0f4FkjFMxOB1NQPqJmYB9xfOg
         jWXjoUZfgQ/UY6y98KFQFYV5Nof1VgtKX8aROxADTKNsLsl2SbTEY0bKfC3569Z1yjpp
         cYOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778815709; x=1779420509;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ol/PaD6xXPeH1cz3x0IVMh0FYdd5XYNZgnuzZiE8wVw=;
        b=i+R9SFoGM3+/cYtUb2j5fs+iv6/uH0gsmbv/0k9C0PO1eXIncsTDXeC3jFcxK5hG34
         MgUHe6IbkvhRX6UIg4qvBsC1+QtgF0nPz8DUsdGF+BlCJFtTLUZ8ZC5v477TPMCOIbkm
         9gE+1lUDe3druvjRY7vMmYIT63ZYzbTfdMOkZwbn276LL7Xn7bzl9FTnCSlzC4XGSAjW
         SEFmoqPyKGIOafcQ89+PgDeL7wJ43uJedKueogovJZRtdwwHIoEWfAOmceFdkJ7G4NwT
         9T1BcSZa54WmGQ1Q/oCKTANOqaCbdJgnYD3zQJ2QjljcQikPHYNWyzF+xz+BK+fIMRBH
         cJEw==
X-Forwarded-Encrypted: i=1; AFNElJ+czdp8sTRRdsLUkc3bpNliX0PbT1SYfyWd406K2kEfx+ksHSKw3oayChzOI+gjsokEWrYqTvWT8g==@kvack.org
X-Gm-Message-State: AOJu0Yw+curMnvl35bJIbchGVYuKbcOvKxN00qjeaKmaxIegcLH/LpJF
	aAU0Jqt5MbYky7WVPNe9mu4YSjkCGvqaueZ4G+KFHh8cdNZIiULKRnrn
X-Gm-Gg: Acq92OGyPvrB9BxR7sgsyY26VwP/MSyVga5KqinFMTJUoDWFY6ptYNIhUz9ZIiRUhx4
	t0cxb/c9lwPFLvrjYIlPPTpk0giq43JgB0w5Umg3987wEzyeYK1FsSn/bZKkJ4iOMs+IHBg7O4b
	UQQUoHIlazA8F0tzCBwrBN7RVJ4z246CTOk2bKzCGgipkiR2Fl1erplAbc5oUIRazprk885OD8H
	orHsePdMvwy0xXiPQUie288ZEgOMKPflaTsGUuPqDLV94kTH5yuqYMyTP8TG0I0uRrGlBF4Bm85
	q7+LaJZQVgPuSEmOxPTOOM413sLmNf814Qv8IPMQLoGcgCsTu9lp4U/rNRZfMMCURLaxSrZJYPI
	x4RV2SmFb1WdgSZmoogGo0WXleL/0lxNqLJuVtqc3b5fo/naBY9I/l/lMog6I0l+eVFikQnxTVC
	FK73IlzrJjvpNmWYud3FDZkYBcBR4ehBCWOY1eabwCmuQ=
X-Received: by 2002:a05:6a00:240e:b0:835:cc47:6fe8 with SMTP id d2e1a72fcca58-83f33dae668mr2576158b3a.46.1778815709089;
        Thu, 14 May 2026 20:28:29 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f19c5c045sm5254784b3a.37.2026.05.14.20.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 20:28:28 -0700 (PDT)
Date: Fri, 15 May 2026 12:28:24 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: oleg@redhat.com, mingo@redhat.com, peterz@infradead.org,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	torvalds@linux-foundation.org, qsa@qualys.com, kees@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, imv4bel@gmail.com
Subject: Re: [PATCH v2] exec: mirror set_dumpable() to thread-group siblings'
 user_dumpable
Message-ID: <agaS2CF0BN9EyAqA@v4bel>
References: <agZ_Ug3EzCYn-Jkg@v4bel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agZ_Ug3EzCYn-Jkg@v4bel>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5623F40005
X-Stat-Signature: y7kpowg6xdkawk4edjjrshfqirmrhjru
X-Rspam-User: 
X-HE-Tag: 1778815710-173566
X-HE-Meta: U2FsdGVkX18Ri75M2RMhL6bn6ISvPkFug44qK7dlCSlTVS3KfBATrDwnPaGnjqOpXIhWpfAHRgWJgWGPVQqbGax6DQ6pvQZ1rXykyqU8osshSpP4ZplTgDAwz+n4jBSLbyBFgzM17AtUtvg2hA6fmvDUW9qGtZDFsvAG4OxZ29Ma3X9v14eq1ClVJbwI1J0hRyNP/AAaHXq4Ie8ctRMaEqLMTejm2SnnuCXb4noEYbvuoRtM1lZ/943gzHZqu94rO5ZZChNlGYpYskpLoSxNyUZbMfenZ7zsjJeh3hYiMqZYa0G+yTNLhACPvqUz0ADo9yUMZyX/eAvSSPj6Uit5mccZda+Dwd/Vjt4Cr1EsutDxZQ5mZEaON+F+GgwO/VajRHOr01T8kjiMmd3vdBNE1A0ARIyNCFO6AOWYO372a9T+g6D8iijPG96E98QOahb5s7yr4iyzbw8cyVfYZoAsY2a41ybHVTw2UXjWaugA+pyC+TJeEoI2i9Sdcf4Fp5Q9JGTF0WAoIE7BkzoNIHSEUKdDMcuWfUPOMhRa1dd1fi77ecMMrOhpkyPS0kqVVQhjbAFZ+RBlekQEVi3Il6hT/ovWerg2hq69QSS5MXyWqQFzxc/53qXPGpuYw5VP9K/sunN9TlLovq2uE6XCJ+SVYmrAZn39Artzc4JUdkjFT0/QVlIexQBh36lgVSep9UWRREBPaEP5dtEfP0h4hHrn4rL6aOuWlo9VRpA4SAYaS1o3oadDI2IFt/PUimKLZ9BC+np9N7YCre1sYngcaWUVScA5EDruBRS7UAVwJvlCpggHzGwoVjzzLuFZ8XVmypQ6XWDupAzsNDij56OTar5J9yxAW4XqhDrf9IKWvVEt6sCdD/Ibhz36PTCIByUlDF+GxvxTMYf+XYuAiIwV5oNPPy2mi8IYTg+Vixrx9Qdw3jpqmtgbbudbkIk8dF/a1BkinDW+5uQsjn5IHcGawv+
 /qo+SYbz
 GxXz67GkGVpzpF+FFYPeV/zfYKhGPwN7+Q5cGyboAW717T66kmRuj8/exhLIwA+ETmNeXkuGR4DVqu+cxQxWVBAdjGOZPK4pdHi0yENvW7+4pkBGxdBU8JY+ANBUAqThceiq6RvDeb0G03+6Zjr2QRmBHBHbEWNyCUGLalkWN0BSVVj0GrW0TwA0ro3vA8NP68QDTwVv13sTsN/PN8n90VfEckLMvr8R2yoq7MsLnPPnyqNfX/aNwTcw7IDsKWrFuJO29euFbv4cbgTsRAVX/wVCCIowWnNDX+9DSRja27u7Y7uKwaYLva6EwKldpKFZj3Q0nv1XHrtedVs44NLjCu++7x+J/BN8GGyytDH6xvlL0yTHQJgdQMDW+FM+uXzb+b25lu/MB3FWRETq6zrDS2m+MuFPED0z5wyQKVZCPx46bQgsNvvv9Q/PxQ8UipnLzseQvOFjXkf9/GsPMgmvgXHxdVubZPXcszDlaiXHNsoD+osEvOsSxnt9nDVP4+U1DpmZimcwrljaOLQA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 15, 2026 at 11:05:06AM +0900, Hyunwoo Kim wrote:
> task_still_dumpable() reads task->user_dumpable when task->mm is NULL.
> That cache is written exactly once in exit_mm(): a single
> get_dumpable(mm) load taken just before task->mm is cleared.
> 
> The load is not ordered against set_dumpable() writes performed by
> CLONE_VM siblings, either via commit_creds() (an euid/egid/fsuid/fsgid
> change or a capability gain - !cred_cap_issubset(old, new)) or via
> prctl(PR_SET_DUMPABLE). If a sibling stores SUID_DUMP_DISABLE after
> the exiting thread observed SUID_DUMP_USER, the live shared mm and the
> cached value diverge with no later refresh, so task_still_dumpable()
> keeps returning SUID_DUMP_USER for the exiting task.
> 
> In set_dumpable(), after the atomic update to mm->flags, walk every
> thread in current's thread group under rcu_read_lock() and mirror the
> new SUID_DUMP_USER bit into each task's user_dumpable cache. All
> in-tree callers of set_dumpable() pass current->mm (commit_creds(),
> prctl(PR_SET_DUMPABLE), begin_new_exec()), so for_each_thread(current)
> covers exactly the CLONE_VM thread group whose mm was just updated.
> 
> The mirror takes task_lock(t) around each per-task write to serialize
> with exit_mm()'s own user_dumpable RMW: the bit-field shares a word
> with neighbor fields, and without serialization a race-window expansion
> between the mirror's store and exit_mm()'s store on the same word can
> lose the mirror's update.
> 
> This keeps the cache in sync with the latest set_dumpable() result
> even after every thread in the group has passed exit_mm().
> 
> Fixes: 31e62c2ebbfd ("ptrace: slightly saner 'get_dumpable()' logic")
> Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
> ---
> Changes in v2:
> - Move the update from a read-side sibling walk in task_still_dumpable()
>   to a write-side mirror in set_dumpable(); v1 left the cache stale
>   when no live sibling mm remained.
> - v1: https://lore.kernel.org/all/agZjJdaIGCvf0z_1@v4bel/
> ---
>  fs/exec.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index ba12b4c466f6..9732b38b727f 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1910,10 +1910,26 @@ EXPORT_SYMBOL(set_binfmt);
>   */
>  void set_dumpable(struct mm_struct *mm, int value)
>  {
> +	struct task_struct *t;
> +	bool user;
> +
>  	if (WARN_ON((unsigned)value > SUID_DUMP_ROOT))
>  		return;
>  
>  	__mm_flags_set_mask_dumpable(mm, value);
> +
> +	/*
> +	 * Mirror to every sibling's user_dumpable cache, serialized with
> +	 * exit_mm()'s write via task_lock(t) to avoid bit-field RMW races.
> +	 */
> +	user = (value == SUID_DUMP_USER);
> +	rcu_read_lock();
> +	for_each_thread(current, t) {
> +		task_lock(t);
> +		t->user_dumpable = user;
> +		task_unlock(t);
> +	}
> +	rcu_read_unlock();
>  }
>  
>  static inline struct user_arg_ptr native_arg(const char __user *const __user *p)
> -- 
> 2.43.0
> 

Withdrawing this patch.

On re-checking, it only fires in a contrived (meaningless) scenario;
real binary flows are blocked by 31e62c2ebbfd.


Best regards,
Hyunwoo Kim

