Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A652CC55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 07:30:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 493816B008A; Thu,  6 Aug 2026 03:30:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46A136B0092; Thu,  6 Aug 2026 03:30:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 381E06B0093; Thu,  6 Aug 2026 03:30:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E85DE6B008A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 03:30:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6385A1606BD
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:30:18 +0000 (UTC)
X-FDA: 85070021316.08.F660E6A
Received: from mail-pj2-f11.google.com (mail-pj2-f11.google.com [74.125.227.139])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7627B100006
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:30:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MucAp3l3;
	spf=pass (imf14.hostedemail.com: domain of zhanghongru06@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786001416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=irsV3UUmbsPIUvx/Xa2IxxMY0Ug7vOgp56JTztI0ESo=;
	b=vUyTuXiROkB6drRkv0DUiJkkr0RktPCb/IiY9SSmrfkbXbxHH7UrZ6eu00obRhWeC/rWqy
	+8TPfli+oZ59RaCcVR48fVPj3zh+3OcAv9eOnYSmSeCDiHHYtgYc3vkRVv5eHXhDShSyqT
	KERnv/Ud5Q2zWirGcmwFHGm45OUtlTQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MucAp3l3;
	spf=pass (imf14.hostedemail.com: domain of zhanghongru06@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786001416;
	b=EXhboMcX7/yThyPvj7HtdhGOLsFF0itQcqNPhQdXwVQ/vZz+AN2QAeUKsYTyio0xGIaD7T
	pnEV86rP14XQGRneIrkP4NcMz60Ahz8KtmMzc3YVH8b8GurdEwGqT//z9qTv/a659lEiTw
	n+IGwKopfpaf7R4IrLjXGEOjJ3H9eB4=
Received: by mail-pj2-f11.google.com with SMTP id d9443c01a7336-2ceb5a39c48so6780365ad.1
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 00:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786001415; x=1786606215; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=irsV3UUmbsPIUvx/Xa2IxxMY0Ug7vOgp56JTztI0ESo=;
        b=MucAp3l3KIKxR9/UjKJZ86UUxX7Q569kvrupSI6+j4CDnae9E19TEQYZshtvwKV7Mw
         Q4HXyIS+NfNIIRZO25zgglNBDaTyxVjvfYRgxdBmgrghwQNRqihxJif68i2E4NJkNvoI
         4vP+tyw2a/CZAeUJW8VNzWxsUSfa5LxecqLC6sqvUwHMwtaJhW9gqZuos6JF9SbURpVv
         BZHSSpJPXH4kZY/x+LFqIrXYRqb5Mi8+GTUFJFQBJ988aN2fgFXr/I66i0WuBnwttw/d
         c6sqOXxjQNf60i4H/aJZK//7a+5FBQFqUbEHHv1xJSZZ95oXpYziIUem/mlV4nNPc3mI
         K8XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786001415; x=1786606215;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=irsV3UUmbsPIUvx/Xa2IxxMY0Ug7vOgp56JTztI0ESo=;
        b=TFjhWEggyD5eeRhKeqE8QkVrwpXmn4Ny0jQU1SxO/P2UqQLe2EaUsLtH/XrudjpPVm
         3+KtrYBSztfjrzgB0+FLSD0IthKE9EZOEUVjS29KNfIsoQnThrNYjrGUmg8i+KqvrWrC
         D7O7+8UFVOzV3f+Z93BjYzFosfaK0TzDQhmRJFctnQFEFkhJzK+Qf9u5n2vYaDLb1tjW
         NKQJ307rFjAtFcNzUWJ9fbRHBFKwmWNGo1nmPVQ02qipIqTzW+Xc7cgbtJzhoP9E9mW/
         vsu4O5+x7jnguwCVdsBMyVZbvErOsKdnzggXEGLgK+oYyT2204E8heKKvxI4O6OWRLHf
         AFYg==
X-Forwarded-Encrypted: i=1; AHgh+Rquc+GkO+fblKETY7LIfmLDU819NilT7SuVK8oL0BVaNuCAvTsCXHxUnRnI029F4qT+N2P+iY6h7A==@kvack.org
X-Gm-Message-State: AOJu0Yx1P2i3842fAj+3XpwPiyryU7JjoS1c1wBLk6bNJFLbDeh9dDK5
	pS8uuTcOE8/UEakwCT4nbc9pOK/qmi6XXhcqqtrhY0l3yCQOT4Z7hA7Q
X-Gm-Gg: AR+sD129opfcw+mfsF/0sE+H8IFNPASwKQKUmMnj7DZg3rxNCV3oVbQ2iMb2ASThcQW
	XrgHNSqIQCzNvFvkiuYkWHnhCsVldMQZ0OmmsbcFPJY63U4aRa9XMV2tUnmxldDG9i+ipCneFcj
	AyUXDPmh7mnL9WRK6IOOcaPNcMDNrHJczYR/1YLuZZM7/v/xc12RmKV8Pu+Jvx09WT8V5w3bYf+
	kzhDnTLI+/76/y30hd/1wDJ2xRZmdDFaSV3cMX4sFOwzkvD2ooa/BofclYWi33cu+LXYOmGAtqs
	oPWU1HIJK9fBAL1o1aQgZ1GmzLvsNpkERRc3uvNYQIKYovoM5o8sVRc2iQ+Rwjm2mZ30A0/G5En
	lXFjNcOMurz/NtqMcsZGf1wDZw58m0V7GyyUAuZqH/C+k3Pr8M1Y1kELc/DqsDUV7Faa1G/VEnz
	mosQ/Fx0PUr1t6pIiyh/CYCtSUbo2PnUSPR+KirC4kjC3L1taf6ElmgN3Q1xX9xNgyyBs0N+tpf
	RYaEMbi54ZFtQDi
X-Received: by 2002:a05:6a00:1250:b0:847:97a4:d6b3 with SMTP id d2e1a72fcca58-84f2e05124dmr13179356b3a.16.1786001414418;
        Thu, 06 Aug 2026 00:30:14 -0700 (PDT)
Received: from zhr-ThinkStation-K.mioffice.cn ([2408:8607:1b00:8:7dbc:3daf:8e91:7035])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbe708e7860sm2534892a12.22.2026.08.06.00.30.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 00:30:13 -0700 (PDT)
From: Hongru Zhang <zhanghongru06@gmail.com>
X-Google-Original-From: Hongru Zhang <zhanghongru@xiaomi.com>
To: baohua@kernel.org,
	ljs@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@suse.com,
	rppt@kernel.org,
	shakeel.butt@linux.dev,
	surenb@google.com,
	vbabka@kernel.org,
	willy@infradead.org,
	zhanghongru06@gmail.com,
	zhanghongru@xiaomi.com
Subject: Re: [RFC PATCH v4 1/3] mm: allow page faults to request VMA-lock retry
Date: Thu,  6 Aug 2026 15:29:34 +0800
Message-ID: <20260806072934.77976-1-zhanghongru@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAGsJ_4x_ed4m57-8rZ53PBoGy-aa-z1thOvGOp7RAb2qP28dKw@mail.gmail.com>
References: <CAGsJ_4x_ed4m57-8rZ53PBoGy-aa-z1thOvGOp7RAb2qP28dKw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kgibpcty84qn9gjk3n6ds3xk5pras3kk
X-Rspamd-Queue-Id: 7627B100006
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786001416-912513
X-HE-Meta: U2FsdGVkX18lOkuauJnjyhlfGBG7MBFqcwkKj1i2y91xbaHLRRXshX84Z2LdIT92xxTeiGIa3I/15jrsN1iD8cAQI3wsFsB6u22vqm34wXz4gdcfTLoJMO1tJIQ95+WuzdbD6GokQ3n7+X96p1X9d2Zcx5Pje90RXJNGcTDCvdHifGatLvn1iIyk06JR/ApP/EduCzv3SaozUYvVf1lZsVIKphXZ/91wt0VXcKGH93Puqs643cP49yZeJjUbUoU9V7BDCGpohH0WzzyQ0RZV24KQAMHTbWEYkB42cHtlJxVNDpgOAV54Ul/7gANsZDG5QvDIC3Tvs3MFDu30tOTP37+FP8+6Pjz0Ucubn5dpOcre1AIeuHZzBvUKen5NNKmFBFfJQVLkP0uhSpurIHSmYCS/Rmpf8Ml/wr2RLbZeygalsNAa1qZVRyV3oU0tj1HQLO8P1yNeZt03w0oC3D2dyEp5q3Ocg3CNAfHkRy+NoaSkKOj75pCMo7TLKsYMDJPn+RXTMTiMhb6dKACv68H+/AE095QgI85vG+GlGSHk7XfrkN3ObpuacxSK0QcrNbGkfVaSIWqWhiGcF7+Uu3RwAU55k+ysZ1qJmdvstJVoAl76QHBCStEvv9un5XdVLs1BDcVDTGrwFHnDauZtxbBgu3RqYGbNQrvkJLAI01ZXWHMUWQ/A8R4qX3itgzV8gOtT1MmlRwJVsLxP8jxSgEAwRmpyPIIUkecLuVdf93C58dFgDLY1HxBpViFTJlwoRraXHR9EO8P+R5uUnky9q0rj2EPPcFjrcyXQJ0snlQc4bJUgcZPxKWGhfKH83lKCKq/vlq3BxMSzVnYkrN0DBjzFcrtonHrREDcejCMNl1+bl2qc+otD7gKng9nbrtfUJKaQrGUCEZ2n3u6/6orCzWJzSgXZQchXrkMVSAwLPkZ2dQ0W8AcD+FPdDptqB6icTpz+h2COZwJt4rdT3OL1Wdd
 kQXw9feV
 KMXxVT5AlN+jJsOOvrOzAPoTwlmJ6ltUOzx6gIyL8Lb2LWIDTWnxiVT2kfH/EfXwSF9uAAvEoKRJZiPlz7BZpwNcszCaafT73Iz2Tj1Sq+24NK7Jr0vWB7V9Fhp2o1l5A1E8klRDEgUA5wb0VmoM9YpMo0pTY6HWXxQNZ1+mDQLeMUm3VEdNU7U6RhMNdAPKeMC3elkb9fQz1as2Vitrad7U34TxozoaUdSp3jIKiyq+C4KKjDku6BeXHb6zl5Z/zCtNYXcf3R3DHyTmBuJ+8IeZVQ1S8ohHZAHxvSSJaYdgvsLHrXIqd8+Y7dEFhxbE+U/xBi75vBQe7UgV1bebqZ2aXI5m0RuZcKr40CS+n2/osz7izno784zE4qUtEB9r36vpbZSkurxZmRQfcO1UwVD/RpiRoaFnodA6ox9EpOv6ibMz6G7oPP3tPb2wZ3D3iyoFz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Tue, Aug 4, 2026 at 8:32 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > On Tue, Aug 04, 2026 at 05:52:19PM +0800, Hongru Zhang wrote:
> > > From: Hongru Zhang <zhanghongru@xiaomi.com>
> > >
> > > Page faults handled under the per-VMA lock currently fall back to the
> > > mmap_lock path whenever handle_mm_fault() returns VM_FAULT_RETRY. This
> > > means that lower-level fault handlers have no way to tell the
> > > architecture fault handler that the retry can safely continue under the
> > > per-VMA lock.
> > >
> > > Add VM_FAULT_MAY_USE_VMA_LOCK as an advisory bit that can be returned
> >
> > I don't love that name or that faulting retry behaviour is _modified_ by a
> > value that indicates fault resolution state... ugh.
> >
> > It's kinda confusing things 'VM_FAULT_RETRY' is 'you have to retry this
> > fault'.
> >
> > 'VM_FAULT_MAY_...' is starting to bring in effectively configuration
> > options into it and that's kinda horrible.
> >
> > I mean is there any reason we shouldn't ALWAYS do this if a VMA lock was
> > used?
> >
> > It's not too expensive to do a single retry with the VMA lock before
> > falling back to the mmap lock.
> >
> > So maybe simplify like that?
> >
> > And like that this series becomes a single patch right?
>
> This is a brilliant idea. That's a genius insight, Lorenzo.
>
> I guess the conceptual model could simply be:
>
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 45b99c3b1442..3592bcc9bbd7 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -1222,6 +1222,7 @@ void do_user_addr_fault(struct pt_regs *regs,
> 	struct mm_struct *mm;
> 	vm_fault_t fault;
> 	unsigned int flags = FAULT_FLAG_DEFAULT;
> +	bool vma_lock_retried = false;
>
> 	tsk = current;
> 	mm = tsk->mm;
> @@ -1331,6 +1332,7 @@ void do_user_addr_fault(struct pt_regs *regs,
> 	if (!(flags & FAULT_FLAG_USER))
> 		goto lock_mmap;
>
> +vma_lock:
> 	vma = lock_vma_under_rcu(mm, address);
> 	if (!vma)
> 		goto lock_mmap;
> @@ -1352,6 +1354,11 @@ void do_user_addr_fault(struct pt_regs *regs,
> 	if (fault & VM_FAULT_MAJOR)
> 		flags |= FAULT_FLAG_TRIED;
>
> +	if (!vma_lock_retried) {
> +		vma_lock_retried = true;
> +		goto vma_lock;
> +	}
> +
> 	/* Quick path to respond to signals */
> 	if (fault_signal_pending(fault, regs)) {
> 		if (!user_mode(regs))
>
> Nothing else needs to change then. I wonder if there is a cleaner
> way to implement the idea, but it is really stunning.
>
> Best Regards
> Barry

Filemap Throughput (higher is better):
+---------+------------+---------------------+---------------------+---------------------+
| Threads |  Vanilla   |       RFC v4        |          P1         |          P2         |
+---------+------------+---------------------+---------------------+---------------------+
|   40    | 1069.34 /s | 1404.47 /s (+31.3%) | 1400.13 /s (+30.9%) | 1412.38 /s (+32.1%) |
+---------+------------+---------------------+---------------------+---------------------+
|   60    | 1038.12 /s | 1682.88 /s (+62.1%) | 1683.37 /s (+62.2%) | 1685.23 /s (+62.3%) |
+---------+------------+---------------------+---------------------+---------------------+
|   80    | 1042.62 /s | 1766.72 /s (+69.5%) | 1767.83 /s (+69.6%) | 1771.73 /s (+69.9%) |
+---------+------------+---------------------+---------------------+---------------------+

Swap Throughput (higher is better):
+--------------+-------------+----------------------+----------------------+----------------------+
| mmap writers |   Vanilla   |        RFC v4        |          P1          |          P2          |
+--------------+-------------+----------------------+----------------------+----------------------+
|      0       | 17303.09 /s | 18394.51 /s  (+6.3%) | 17899.48 /s  (+3.4%) | 18337.30 /s  (+6.0%) |
+--------------+-------------+----------------------+----------------------+----------------------+
|      2       | 16728.04 /s | 18591.68 /s (+11.1%) | 18346.72 /s  (+9.7%) | 18848.17 /s (+12.7%) |
+--------------+-------------+----------------------+----------------------+----------------------+
|      4       | 12596.23 /s | 18534.00 /s (+47.1%) | 16095.20 /s (+27.8%) | 18507.62 /s (+46.9%) |
+--------------+-------------+----------------------+----------------------+----------------------+

The key difference between P1 and P2 is how FAULT_FLAG_TRIED is handled: P1
keeps the existing major-fault-only setting before the retry, while P2 sets it
before the VMA-lock retry for all retrying faults.

In filemap throughput test, each reader thread operates on its own file.
In swap throughput test, all reader threads fault the same memory area.


P1:

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 45b99c3b1442..c3ab30d32a15 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1222,6 +1222,7 @@ void do_user_addr_fault(struct pt_regs *regs,
 	struct mm_struct *mm;
 	vm_fault_t fault;
 	unsigned int flags = FAULT_FLAG_DEFAULT;
+	bool vma_lock_retried = false;
 
 	tsk = current;
 	mm = tsk->mm;
@@ -1331,6 +1332,7 @@ void do_user_addr_fault(struct pt_regs *regs,
 	if (!(flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
+lock_vma:
 	vma = lock_vma_under_rcu(mm, address);
 	if (!vma)
 		goto lock_mmap;
@@ -1360,6 +1362,12 @@ void do_user_addr_fault(struct pt_regs *regs,
 						 ARCH_DEFAULT_PKEY);
 		return;
 	}
+
+	if (!vma_lock_retried) {
+		vma_lock_retried = true;
+		goto lock_vma;
+	}
+
 lock_mmap:


P2:

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 45b99c3b1442..9507b8a0fe18 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1222,6 +1222,7 @@ void do_user_addr_fault(struct pt_regs *regs,
 	struct mm_struct *mm;
 	vm_fault_t fault;
 	unsigned int flags = FAULT_FLAG_DEFAULT;
+	bool vma_lock_retried = false;
 
 	tsk = current;
 	mm = tsk->mm;
@@ -1331,6 +1332,7 @@ void do_user_addr_fault(struct pt_regs *regs,
 	if (!(flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
+lock_vma:
 	vma = lock_vma_under_rcu(mm, address);
 	if (!vma)
 		goto lock_mmap;
@@ -1349,8 +1351,6 @@ void do_user_addr_fault(struct pt_regs *regs,
 		goto done;
 	}
 	count_vm_vma_lock_event(VMA_LOCK_RETRY);
-	if (fault & VM_FAULT_MAJOR)
-		flags |= FAULT_FLAG_TRIED;
 
 	/* Quick path to respond to signals */
 	if (fault_signal_pending(fault, regs)) {
@@ -1360,6 +1360,13 @@ void do_user_addr_fault(struct pt_regs *regs,
 						 ARCH_DEFAULT_PKEY);
 		return;
 	}
+
+	if (!vma_lock_retried) {
+		flags |= FAULT_FLAG_TRIED;
+		vma_lock_retried = true;
+		goto lock_vma;
+	}
+
 lock_mmap:

