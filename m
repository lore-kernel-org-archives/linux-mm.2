Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6D0C606A6AD
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 00:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vbh7eel0
Received: by kanga.kvack.org (Postfix)
	id EA1176B00EF; Sun, 22 Nov 2026 19:40:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2AA66B05B0; Sun, 22 Nov 2026 19:40:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF2916B05B1; Sun, 22 Nov 2026 19:40:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 992546B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:40:37 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C45A5120619
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:40:36 +0000 (UTC)
X-FDA: 85464528072.06.5566FA6
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf03.hostedemail.com (Postfix) with ESMTP id E9F9D20004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:40:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vbh7eel0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795394435;
	b=XN+Lp5+aKfd/83BZFhPiFexbDNlbxM28cINvBOQIvW23QdQai+5wXEVYrpivYhlnRC9G+1
	ALGtPUnCp1IvP26cZk5YaL5ZqlxHtPSqntCotrpQyf6U8tvdcnqjt9I7brH+/7s+BN/Dz0
	9z/ods3S5zu8mXQvTuiPxKv+K/5Ly5g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795394435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JhBGO+Bzff2sfRtYfk09jmNW/MhpZG21e/W39Xvcbis=;
	b=QNwfGXu2bBXRwNZdwTrx0Rs1enA0+0TP1gyxAqpwc87sur9Pg0VWKneeUhoIUXxjAIzHNs
	NgarQ6GMTx0Jg9hU3h7+gignEuqy2FRvsnxR4vdSlYgOWB+UMjRHTvds5jITAGP/g8QpnM
	zMTCkqtiLkxMqOemr++xSNX9tzgti+8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vbh7eel0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8c700d6cc0bso1938777b3a.1
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 16:40:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795394434; x=1795999234; darn=kvack.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JhBGO+Bzff2sfRtYfk09jmNW/MhpZG21e/W39Xvcbis=;
        b=vbh7eel0VwpEiu4bgN/aDwLM9wRZqXHcV6bRScfXmPauaa658JCmubf7jdX8gWldXZ
         v7pLTw4W9+EnOO9PBy87pU8V/sk1sqMtsLx0q3E7sZ/89NJW5Kz4Z7zG04TaYZaan2FC
         WAc2mrFqS5Hxq3rV6G1XSnw52Q7xmWrIak6A3Zn/I+FssavCFeFXdq8umhZzn6Yko77s
         qMHVb9LcNhI+COt/jPf1Uh+n3E3LTDm+Vub2v+Y9ahs8lr2PkHVIbxVgnDY7ComE5iLw
         rTXEDAtlMExp3lpmQzUeBj8UCvOoTqy7Z8vNzrCkmZfUcJD/zzeIYO7/YDCwqXPOSfyw
         N9kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795394434; x=1795999234;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JhBGO+Bzff2sfRtYfk09jmNW/MhpZG21e/W39Xvcbis=;
        b=OxSNTjvYNoXclNRXJXZl8vCTP09+Ob5IUkujwTJzZ6KBoov5/bgIGuW0MbaenV/E2I
         YLxNmx3vQ06S6OPADauR5O9qtsudLJGHHrwq0u/wC2+DDMmIoh5QN0DM/3UOqIvyem8X
         HudAiUDVJ2/8W+Q24GHzBSAGBeW005ALqve/5T3LXDnuA1/A2j7yoNXe0JxCn/Pp/GR1
         ObCOZxR7ozXRIsoCrFqGqtyMGSpQOYMz6MLhH+GIT8zXn3+2zIuxvxMYYNeJGL3xa2gB
         /T9YA2Vp5c7X54ljND9MT0IeeBMc8aErv3ITu3QMelKymjo1MwE8xAYXYUPqFxAZDzPD
         vxCQ==
X-Forwarded-Encrypted: i=1; AL+hErFM769RulvEslIcDaNrUCNSXwhrBVeouj9cSqfCMkVqL8QzB/LnN/wYD8BsAADMPtvneaRF2WKPHg==@kvack.org
X-Gm-Message-State: APuU4Z9jqvl7/KXurv51lHDPdHZxooUykR9GSLgqSmGY9Ifw8iPLylt/
	FS2WAjZSvghNNgHr1DPA7Y33A/Wn0TGM0Vn8CGsKfRiB8UraVAMUnJGY
X-Gm-Gg: AZFdTZcwkCgnup1lj3lAXEkve4AbbGj+WRLKxSKY6GdscaNHjArDtHUpbYPzn8D3Om6
	SWsrjR+nsNJCt1xF1BOJ4w9/wJc8PCs1kpm/RWjs8gATigUdDIKAvsVpqJKVGD3dZYj9mEvYpEL
	+4Og+7EnFDWM4ssweVJyc6vurL8wi00bHAZvjTt1Soc/uJzwwQ2avlCC2H9TNKHVauFQxtBMmav
	xsYcf3ePxRT/VyX2cCwwBXK3ZaTx94ZhMM9RfG+91P0TF7PbpUU8hx4HGpxSAPq24ZU1wd63hy9
	c5sWW+lUkW7PlIN6lfncwnmRN7Cwnzsvh1MASzujKoEiVJqCLl7viuzNFvwjFLL2taKKYiD1V5V
	lM2WHnhOxxdz7dwytrWENb5JOs3uoDH1iYeUOSeCeP/KJxzIUE5nowxOF/XDQ4ETufVvyYeaiuq
	XY+Ebkp0m0dlBiKFlsy6h+aZoLos7+sd2aL4i1xUayZFReu9ryatlfiR12sFtyFiprxBoCZo5yj
	M3E1G2DHeaqTbyCvmTPq+KmTYjYmmUE2VVHPAkcH5ZyIg/lJbjKG+xzvPE0gMZikOqh6TNd9ii4
	QRMfgcDtYswo/TS1P7CzMvG9ci0QBjGxUs6O449zCS4dJAuoA2NDp/+qGzyORVYPo9DSZbHD47O
	7EgWim0PVWg/nVbO0ZR073zc+werKLXwPm4U=
X-Received: by 2002:a05:6300:492:b0:3e0:df21:9df2 with SMTP id adf61e73a8af0-4014ca45234mr5333075637.10.1795394433438;
        Sun, 22 Nov 2026 16:40:33 -0800 (PST)
Received: from localhost ([153.61.198.251])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87343f726sm4738195b3a.36.2026.11.22.16.40.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 16:40:32 -0800 (PST)
Content-Type: text/plain; charset=UTF-8
Date: Mon, 23 Nov 2026 00:40:32 +0000
Message-Id: <DN267JUKDRNS.2VMV07CQ58R4X@gmail.com>
Cc: <bpf@vger.kernel.org>, "Puranjay Mohan" <puranjay12@gmail.com>, "Andrii
 Nakryiko" <andrii@kernel.org>, "Daniel Borkmann" <daniel@iogearbox.net>,
 "Martin KaFai Lau" <martin.lau@kernel.org>, "Eduard Zingerman"
 <eddyz87@gmail.com>, "Kumar Kartikeya Dwivedi" <memxor@gmail.com>, "Mykyta
 Yatsenko" <mykyta.yatsenko5@gmail.com>, <kernel-team@meta.com>, "Liam R.
 Howlett" <liam@infradead.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Shakeel Butt"
 <shakeel.butt@linux.dev>, "Pedro Falcato" <pfalcato@suse.de>, "David
 Hildenbrand" <david@kernel.org>, "Jann Horn" <jannh@google.com>,
 <linux-mm@kvack.org>, "Chris Mason" <mason@kernel.org>
Subject: Re: [PATCH bpf v6 2/3] bpf: switch task_vma iterator from mmap_lock
 to per-VMA locks
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, "Puranjay Mohan"
 <puranjay@kernel.org>
In-Reply-To: <awGZWsCp6v63H_py@gremlin>
References: <20260408154539.3832150-1-puranjay@kernel.org> <20260408154539.3832150-3-puranjay@kernel.org> <awGZWsCp6v63H_py@gremlin>
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E9F9D20004
X-Stat-Signature: djdyfd4ey4scbsctws4osp7chaedixe9
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795394434-409962
X-HE-Meta: U2FsdGVkX18LXq7418OG6nqWNs7TY8ntHUoo5d+WoLSYW+rzhtiNPh3QFsN5Pe5EN278NdyFjEr700M1sDxxqiSU86PSjQXfyXQTf1Xuo/uHJq0NhtW1on6fvjhBUySbExV3yixWXsnQ/WfIH/uwxNAEG/s9VvKE5Tp/YxHpYU+YHK/3hXKdF3kHTfgu65njaSG5iTifj+OoSfWrpm5flCbCZQEdvyQt5mUwkBRtN4HpjCKSN7ZPPh47YS0h4iiN7kMIW0HivJmhBkVhylVS2tmSWiyRht4rN5r1/Ca1VkMNgz9LxPoaPbmOciZxKAcrOCNUXwJ1susuY0bpTPeaSSakNu8tmexQDpAi57mzWSJV/gSjOtof7Fj3NZxgXgWdIsxt0UESNrEfSZiAZUpdV21X+cobNJw7PbD3wRHo8NJt0j+Wt2Ugo7a2P/jPmLVzhU8sArjloy15cDmt3d8bWXUeuQmZJQOxOExxody3JMfXro8OmN25HEpRoNFPKReXO2zzj/dpzycLLXTSvrQnHeLD9n5TcRsFYiq6Oqu454+VjA89AcxrpmF6F0O2o2DPBmx543bbPRD4Hlpz/2IwayXU/4F4BZ17Y9vcEVFCclpqR8oD0IoP2kOs5SP+P5O0kIGo2MEglvLx8aiyCu7e78vC0EDcU8e5rV6tn3TsEJ3eVpHF0L0UANw/xhxZ2TjK/6RDSnk136FER08qJvdP9NiVp+Qs9qTQvFQzYRlbftV4Zl/OhhkYZCsn95dbNc46xdNjfZnb/+FfTiYACwhtXiRQ1OGXHBMj7JvFKNIcR5DK/iS7agHrzSJbF/qGmt1f4w0RcPKAzb4Ku7P9za2fRAVVIhIDie1MHBQQqp4TMkBOJ1ljv5OA4aCjw6zHN7utpCllAFTXmQuSar9UbY2PRHxiEi2m9SjN7epDYaf0rRE4IfQ1tZ157T24a2+BexK4hMpaKPIMn5HGqYQ+V4U
 Stq3YPuw
 Vpwk4uwC56BzHVVjUl1veEPkBzC7zkoOdEjsrE7mS8lCdzrQrqcDoSTfTKg6wW2wuUfi25GnrIRYpnsnhXhD1rQ8p9Q/Q/Eq4WQ3pksjDVCS2Q36cgeenSR7mpgjg+1AG5b+o/EiJjyQFCOzfDVWC+nQvZXdKua7+dsBnweSJ6Q5zm2Gtd2HWpmVetsAa+96rW0UlmxM/KKDuFL2+sWj+bxYDrM6PynniD68DXdOM+/6QEN+PcecVTsoJdbxUrZAFEuhT08rMnvVSM7c09pai5XhJ0lRAE/WfLLGVsSfeh9o3516ZnSWCZvGQ7dGU8W53S30aEuHjolYdJBjEHJ2Zqlo4ayUTabx7xW4dS11jgSOYEINRbzz9zNolB9fEIvSUttq434n4FDBT5s3HdQz4HiGSjSX8lhb8aezYIIoWQ9HQdRzyCgE4awiy4Nr6ExXhy/aki1kKrWlumajcFaMjxTnUY0XPMN+6UcDlthmawFyOmmkns4agWAi2Wpo03JOY8xLFpIev/ToU0EryEG+7bT4/TxT3ujyhiDT2+uVRJHwO0ykR+B4Zb8eOWxaEUaS7VM9x+MwEwOfQ4ipAxnrO5tLXG6OtrGQXnrV+JljFu/8w802IW/aUFNLt0jUbRXHLzs89vUc1Gk7vhRs/+Aw+KcHiE/kcK0d3eq2eUD41h03HRJ3jDh7BkEUg05f/YAMtAIgvYm5YVg8sslqJmsgSXMLIPJwyUBrfW6Rr9zZ7kbJcvvfwZDrcr9iaV/s9zTsuFEER3jB8NgqmMiZpdnwbNopB92D6d4taPqVdzfdCZL2kjw5r9vfSwbsZJuoUKsUpMeAwGxplbJ2ZlrhntsTos3h1rYaPbn3e7kYw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 05:40 AM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> This is buggy and can result in deadlock. You need to revert it or restrict
> which contexts it can be called in.

Yeah. It's a bug though very much theoretical.
A revert would bring back an actual deadlock that people hit in production.
So here is that.

> I'm a little surprised you didn't cc- or even ping mm or the VMA team here, we
> are always willing to help and it's clearly sub-optimal to write duplicative,
> open-coded VMA traversal in BPF.

Fair point. Will cc mm next time.

> It's not really sensible to alter core mm to accommodate this at this stage, so
> probably the best course is to disallow this code path for softirq context, or
> you could look into patching the x86 code.

A softirq check is not enough. A tracing prog can run in task context
with pgd_lock held and irqs on:

  pgd_alloc()
    spin_lock(&pgd_lock)
      queued_spin_lock_slowpath()
        trace_contention_end()          <- pgd_lock is held
          tp_btf/contention_end prog
            bpf_iter_task_vma_next()
              lock_vma_under_rcu()
                vma_start_read()
                  mmdrop(other_mm)      <- last put takes pgd_lock again

Equally theoretical deadlock, but since we're discussing hypothetical bugs...

can vma_start_read() use mmdrop_async() like free_signal_struct() ?
It changes only the last put of other_mm in err_unstable.
_destroy() already calls mmput_async() from the same contexts,
so the fix costs nothing to mm afaict.
We can fix it on bpf side, but below fix is much cleaner.

diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index d7c6a94..a3333ed 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -43,6 +43,7 @@ static inline void smp_mb__after_mmgrab(void)
 }
 
 extern void __mmdrop(struct mm_struct *mm);
+void mmdrop_async(struct mm_struct *mm);
 
 static inline void mmdrop(struct mm_struct *mm)
 {
diff --git a/kernel/fork.c b/kernel/fork.c
index 5efceb8..177d5c0 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -752,7 +752,7 @@ static void mmdrop_async_fn(struct work_struct *work)
 	__mmdrop(mm);
 }
 
-static void mmdrop_async(struct mm_struct *mm)
+void mmdrop_async(struct mm_struct *mm)
 {
 	if (unlikely(atomic_dec_and_test(&mm->mm_count))) {
 		INIT_WORK(&mm->async_put_work, mmdrop_async_fn);
diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index 834bbf8..6b9a1bb 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -306,11 +306,11 @@ err_unstable:
 	 */
 	other_mm = vma->vm_mm; /* use a copy as vma can be freed after we drop vm_refcnt */
 
	/* __mmdrop() is a heavy operation, do it after dropping RCU lock. */
 	rcu_read_unlock();
 	mmgrab(other_mm);
 	vma_refcount_put(vma);
-	mmdrop(other_mm);
+	mmdrop_async(other_mm);
 
 	return NULL;
 }

