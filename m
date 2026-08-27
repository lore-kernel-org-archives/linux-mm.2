Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94AA4C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 23:32:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E56BE6B009F; Thu, 27 Aug 2026 19:31:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2D7E6B00A0; Thu, 27 Aug 2026 19:31:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1C926B00A1; Thu, 27 Aug 2026 19:31:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AED726B009F
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:31:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 53E13A0240
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:31:37 +0000 (UTC)
X-FDA: 85148648634.17.C8708A9
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8B549C000F
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:31:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TNmpijZW;
	spf=pass (imf10.hostedemail.com: domain of 31siQaggKCAcz0l2luzknvvnsl.jvtspu14-ttr2hjr.vyn@flex--stevensd.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=31siQaggKCAcz0l2luzknvvnsl.jvtspu14-ttr2hjr.vyn@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787873495;
	b=LiMW5FxKrz7eZt/0vx0r6QSMo9XDVUJNODMVYB3FGmtHfRnDWQVMNgTkG0GKP5YW0kEoaz
	VSWdLmBWDXUBERYpJFoZxuWhX73bZWWaRVd3dL6AX5ppCMjVXVZFbkCGXncKM/Dl1o7+dn
	KhwdgvkxFw/v4VwjmqE0zAO3a6+g5Fs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TNmpijZW;
	spf=pass (imf10.hostedemail.com: domain of 31siQaggKCAcz0l2luzknvvnsl.jvtspu14-ttr2hjr.vyn@flex--stevensd.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=31siQaggKCAcz0l2luzknvvnsl.jvtspu14-ttr2hjr.vyn@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787873495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=63v8voqDYPPccdvhHdT2gYF/erUoDbYrARzDm1If6YE=;
	b=GSBFRpEKA+A5KFQ+nN1N762DLxbk5EUP/GTM2RYpb8jP94NjSUPoqj38m6bgy9ZQJFuPkI
	JszBr8jeT71Q0vCF9jYQrXnyLBpQa/yq/rnOQ8uNNhX5Iyu2JLMiBlkG/5xcpj1iUfpPhe
	oHBSRP6pU3eCkwOrYKzLNI4BIbBtvgU=
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc1ca15334cso309439a12.1
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787873494; x=1788478294; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=63v8voqDYPPccdvhHdT2gYF/erUoDbYrARzDm1If6YE=;
        b=TNmpijZW3/a+sUTqPooixgzzZfA6Uj9+SC6OEuZ+jn6IC79n8VeoTFf7ctnbTqxzBM
         hEBuoFP8tHdF2UaMv22lbPhSz5ookaVEbGZIRKI3Do80nZIUOEu+DxgvuUL/2eMIS62b
         fMXuxXlz+2iCmDLTjkpaXzNGdEmJcrpojP64XC72NP3oLNWa6EkwKdKOWJQHimPL7IBQ
         IA3y00oKFZgSuMDFy4wnZS6ANYiORRBDuyLITnAhIoVMs7dnwzq2SfO2py1Bg2tIPk6T
         vV2dPH61N3wU2JkHRowHEETnYYlwbrxjXBoKkyROUxCeJOvk+SD7K3vnfCwEKIRVwb42
         RMdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787873494; x=1788478294;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=63v8voqDYPPccdvhHdT2gYF/erUoDbYrARzDm1If6YE=;
        b=bfmr1DQdxknOIL5fThld6k6LkNAbG/OXHRAJPErAA0tnGBd7ycf3MQ7h9VTtO5jEzt
         TROOwttd8tuk+EYbeYIc1V+3jA5iAM3a1YvnQZjP4F6v0kJUCHyazpPJu/+WZuKumsR0
         DgUSEe23NykeT2L//pbkUw7xuqxYZFz87jVpuzXHTUAlN30Q5QxAvcs/au0GATz+4+ah
         g6niACLe77HTDCwTtH/yxrLgpYchyQU53sls49roWxkQYZ+b13v9s33rY1vlSGCbtm6l
         ttmagicC/orjq+UTmgoR/jQwSKRHu8iYqQB66HYG0WT0XCXDrJrnaCJS9VHVIEZPnIYK
         cAyg==
X-Forwarded-Encrypted: i=1; AHgh+RoDg60v17XWqgXHfofb6s7JQtAad0HHkdk5BYwKNQoXlWKYuY2G5MrvXZ6b8aGiM31A4moaufyUYQ==@kvack.org
X-Gm-Message-State: AFuF++kaXQ9N/c/6aVlITmYh6V8IqMV7nock8xrQPDAEYird7s1o+v+b
	L2ELAPFb48NNi1Wo/jdOd069T3DsRVqvHG7Jw+p+UX9qLqqy0hQUFDJZxPI9nkVfCkibhYViabr
	FoqtvdiIPhRqMpQ==
X-Received: from dybpd7.prod.google.com ([2002:a05:7301:4547:b0:327:dce2:b13c])
 (user=stevensd job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1850:b0:2d5:e3ce:3988 with SMTP id d9443c01a7336-2d74dddceebmr49959775ad.11.1787873494176;
 Thu, 27 Aug 2026 16:31:34 -0700 (PDT)
Date: Thu, 27 Aug 2026 16:29:47 -0700
In-Reply-To: <20260827232948.2520558-1-stevensd@google.com>
Mime-Version: 1.0
References: <20260827232948.2520558-1-stevensd@google.com>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Message-ID: <20260827232948.2520558-10-stevensd@google.com>
Subject: [RFC 09/10] x86: Enable reclaimable stacks
From: David Stevens <stevensd@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Uladzislau Rezki <urezki@gmail.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, suleiman@google.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev, 
	David Stevens <stevensd@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8B549C000F
X-Stat-Signature: yk7835w3fb77apyfa4q6tegum5akcqmt
X-Rspam-User: 
X-HE-Tag: 1787873495-860708
X-HE-Meta: U2FsdGVkX1+DCqJiqi7PwyNc4r5K9EzZpqSzA0MQQppWE73m1gskreAV6Jf4MInDlArq05T+EaUazWUznR0/cRXyPfTF5mzYo4taj3qFMltK85EqeGig0GHPaB++GcNm/wmztNC87jpcqhub1tOZU8iwD/wX5pUCrl4yjFdPdzmZ493vpSGX+lSI8gh3rPoAfkxADRAjAImlkkk5ZhT+gZQCty1JqBB2teOpC9/BGnB3Cah9N+uRurio6weiXr5Hu1lpmaVlV2j41FUAQEfumefEGNdrTpx+VKCY+EW0y70b4hwl7H9VneGzk+Vz4ki7qVFP+JNVyB1Cv+l+TSyiTFbEfJE/7RSMg2zzILwp6x5iUFPE6w6Hr7SacthvkZzAUbnRyBV1NIGELdkECM5pST4QQPV4/BN82S2u+HTs4sKj4vm2wp6F2NERbddHpEou1v1/lRat9S0oUpFvoXCSy9xHIKQTNqd/ZCPVAELAnM9p3ZOOBehvK+xRTDutzDKQi1fVotoSyndrqV00sM6mR9Hv1ihjgvy6glb1z55Q7AsePZ6GEZ+ViSgUzKwY5plx7Lrf5fcpfKglQftk6yF75Dgq3xOzfDAIB9zwRiFbjvB+LCewOI1/3hW38XbwvK0NssZTczU63hANXYY6gewvETysCrIrk3hywZrtfzMNEWljzSeSYQYqGJIhkE0udvXZ1LQGI0NLENBsS0IyCOK4MfIXhC6qqGHwIeMhWNBLYijpDzrtQlaodBqOqvwK1nJIpuZqukgNo/38MQz64f5XbfxFCRGyeT7x2PoZFZF82siMmDompmRb/o684StIN9i6fEyodIRespC8HovCAI61wf0/a70/cChQo8aQShYR1Q8mo75TBwO55WXgB9P3TEG6haUJtWWKzfkrYqKHcg3N14d5yL/IKmFLG37YUQAGMSPFlafq5SGZJUb0mxRdXF4HfvAobW2tMkbU8vl1xdm
 HkgiDNzc
 OhkHbg4RbADLSUFFG7NyDGOJzW7f4vSzKCyVRYlReJ/x39DZTJAnDJs7b9QCgU+i+aGPj41hFiMS/XrMSDg48m55GK7c0mdhuJTMoYhh/QbHzY1020DSnTuH7mEf81bXBGf6A0gClDLpZdR2IrztBw7niAR6OfWgVn51yzbSrNSXYi+3RxCEwsRu5lz0bh6rsAcVBvfA3/tuDFVcrq+yTz1HR3EoAPCJ9oH514nHcujCUItFHPQphLXmysjNh6PmbX2G10G1libI1HgXFbN7Nijg2vFJ+Bd+0ViinuclExZPYnSZQcMWUHYfJnukaINHHn7IG+e+N0a/LTWYJ1lvc5gP4+umStZq14ZBzxB1Qmckcg8BOfJNa9zsK9Ryy16TWEK8BtSmyld0ol1y/JEQodHBpbZxmB6rJaEOiqz1lwunq0T28Bx6mq7IIIXICYTwEagXAt3j7svg+dqSCKkR6LIWiW6AGZE3LTmLwyduZ6oVAk7aFU+by6mFNmU3mrsBmHJoNrQLH2/m5nZGprNotgsaQpLXY45kjsJEQXLYOq5Jj/Fj8ETOm+TcZZ61EoS66Qn15OTz2228znoXpST1A33/41w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement top_of_blocked_task_stack() to get the stack pointer out of
a thread_struct and enable HAVE_ARCH_RECLAIMABLE_STACK.

Signed-off-by: David Stevens <stevensd@google.com>
---
 arch/x86/Kconfig                 | 1 +
 arch/x86/include/asm/processor.h | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index bdad90f210e4..652d5a9c0830 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -211,6 +211,7 @@ config X86
 	select HAVE_ARCH_USERFAULTFD_WP         if X86_64 && USERFAULTFD
 	select HAVE_ARCH_USERFAULTFD_MINOR	if X86_64 && USERFAULTFD
 	select HAVE_ARCH_VMAP_STACK		if X86_64
+	select HAVE_ARCH_RECLAIMABLE_STACK	if X86_64
 	select HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
 	select HAVE_ARCH_WITHIN_STACK_FRAMES
 	select HAVE_ASM_MODVERSIONS
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 87b1d4c0727e..207e7adced64 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -690,6 +690,11 @@ extern void start_thread(struct pt_regs *regs, unsigned long new_ip,
 #define GET_TSC_CTL(adr)	get_tsc_mode((adr))
 #define SET_TSC_CTL(val)	set_tsc_mode((val))
 
+static inline unsigned long top_of_blocked_task_stack(struct thread_struct *thread)
+{
+	return thread->sp;
+}
+
 extern int get_tsc_mode(unsigned long adr);
 extern int set_tsc_mode(unsigned int val);
 
-- 
2.55.0.897.gb25b4bd76c-goog


