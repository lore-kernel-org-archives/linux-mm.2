Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F042C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 16:47:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6BA06B00A0; Fri, 25 Jul 2025 12:47:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C436F6B00A1; Fri, 25 Jul 2025 12:47:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B59696B00A2; Fri, 25 Jul 2025 12:47:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A6D976B00A0
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 12:47:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D4FE1BBB80
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:47:15 +0000 (UTC)
X-FDA: 83703367230.15.57E40A2
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf15.hostedemail.com (Postfix) with ESMTP id E5DB6A0011
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:47:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=PBj7rjOf;
	spf=pass (imf15.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753462034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vHLTqitS8m73sB1NoWWs/yPMz8aTSpmBU53QgGw/vVs=;
	b=papQLD220TvC792o1tCkQw0XEVx26q2ERbuuq8tEZ98mKtb4Ji/BJMlXhmOJqvxH9SPE8n
	A1w7SAjAPv2jDU1kd+5bsnAbk8C5rx+Y0gM4UcZ/g3mZjNy0fs5puzGYeCTa4LEJ+CXb8g
	9K7MXZIt9gwsqRMni5aqFYDYCSYA7qQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=PBj7rjOf;
	spf=pass (imf15.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753462034; a=rsa-sha256;
	cv=none;
	b=15SjpEuXfwF9M6Z/v4ntQGdbgIbyppIPycqgh1/o0SemFHo1OTyqZ4CpUEuC/eiuBibZbo
	7bEZopc/mFy8xPdyFPI5AOv9t9Xc3iiL3NPm0TR/YcR0LWwv/OA0hOkjBLW5MvXxlQYLCA
	On+clbi+sn5ei98eOpAub0XUdzA6WsY=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-74b54af901bso1627828b3a.2
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 09:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753462033; x=1754066833; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vHLTqitS8m73sB1NoWWs/yPMz8aTSpmBU53QgGw/vVs=;
        b=PBj7rjOfl0TL9l8wzz7UFcy3eccPb0eXCvHW45yq4/KzBfkx5IHL6kuBHSoSzzBPx6
         MeVPwU3O54i9CBs9OXoyDZFBIhfs6Nf3PUKem39d++8Fj8r/f39VUSvkSWl6A7tQEycW
         sdL4dsxa/ZbjhEyR9RE5+gh0MU0b97hqA6QQj6Il2Yl6uxqcgAhJF4crsT4AgMYnDrEj
         jhpKW1vFCfCcyuh7Sge4gdm8ALireF1+e0vGLgYCD6P+l+l0m8p27TbTAPjjgnRMQhOZ
         AEGNpiRkvbxUSA/EgAVZnTcLKRnQLRJ1rOfbYlNTItuKdMYV9KVRAl484Cquj7kJL3EZ
         hE4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753462033; x=1754066833;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vHLTqitS8m73sB1NoWWs/yPMz8aTSpmBU53QgGw/vVs=;
        b=C3x3aX77UxrhV3OIY7lcsIAQXxvxYvW8C5fWixaqMDswzwjpMgkzPjNxT1Ak5hrLF7
         05mimI3ato373yYBlYA9701KgRJvVjGD7SBGGIXxbwNXw3uuUp9J25M6+Goawte1tbJi
         WVbVQfa8ADCQeIPIh/wFUwY+xLbEkd97tmbXzLheytdDN4MkqiJInq6tMXhrpNDBfQwW
         L48ASRKT7IU2LFlbf04i5lYBXZHlJ2ebxFmHy1DRO36vV1Sdz6sImxzv+C6lb/SNtanl
         ZPIRs63D4h1xQZNEj1pw0O1hU/fofZ0y0uLDZqTN2tbBxl9QHqUEGhmI2XlO6B+oT2KR
         AYGA==
X-Forwarded-Encrypted: i=1; AJvYcCX21bHTdo76z2AzmJ56PjoKDTg48nmZZdpdgL9B/LPZEQKnytOUeyppa5wonCbTnNmZgJBxHXeRZQ==@kvack.org
X-Gm-Message-State: AOJu0YxqPIOkiRdJ+6iUG6w7KDcV8jSExI1KQaGJ21CSSa+xqlsl148N
	enrqXbZHCW2lHdEDUXrLc8cLdbCbtK/kgwFFNPv7B1E5DbPsPlrp6rgrvWdLf/6Bzwg=
X-Gm-Gg: ASbGncuNkElnlvxoxIsRKfZl6XWehGjirLmRgFLK6kSp6ZqgDwf056OcaTIl9tw2zJt
	rs/XYrcvV4zgX7U6ZIuxVB4LdSuuUBVBDLtU7t7Wl5/DKryJssdVciF1A7OLoYkL4V3wNJuhul8
	kDrAnyLf3OeJSELXeBhK3kkPkUm67QBjaJr2JVkPde068I+a/Jh/4LXi8Pg9R3aHQ23BwlKmyOu
	Z0McXbsth9n1GBzx6TsNCWtEA/S7SMqMWif12Ec0w6UVJRa798vr0l/l0Wr2IHcKG3r5xBjXvxW
	+HlAM8EmU20+/v67dDqkyJQXjU+U5zDJrIoQrOjF1JrtrS8c4+Rw0nT1p7Q9jY+5bN7cxtcqlu4
	ub82m+WYFydkhsXtD9deeMZedl9gNbbDW
X-Google-Smtp-Source: AGHT+IHxx3Jq+s72rQKTRVQE8Bq7kbAijuZ/ZVTSRX63AJDAbUraG/5Y8poHwWgKyEfuOloxC+qeAg==
X-Received: by 2002:a05:6a00:1790:b0:74c:3547:7f0c with SMTP id d2e1a72fcca58-7633626d5afmr4307957b3a.3.1753462032636;
        Fri, 25 Jul 2025 09:47:12 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7640b4d15cfsm119033b3a.119.2025.07.25.09.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 09:47:12 -0700 (PDT)
Date: Fri, 25 Jul 2025 09:47:08 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>, Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Monk Chiang <monk.chiang@sifive.com>,
	Kito Cheng <kito.cheng@sifive.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
	llvm@lists.linux.dev, rick.p.edgecombe@intel.com,
	broonie@kernel.org, cleger@rivosinc.com, apatel@ventanamicro.com,
	ajones@ventanamicro.com, conor.dooley@microchip.com,
	charlie@rivosinc.com, samuel.holland@sifive.com, bjorn@rivosinc.com,
	fweimer@redhat.com, jeffreyalaw@gmail.com,
	heinrich.schuchardt@canonical.com, andrew@sifive.com,
	ved@rivosinc.com
Subject: Re: [PATCH 10/11] scs: generic scs code updated to leverage hw
 assisted shadow stack
Message-ID: <aIO1DOrhUTolFWO6@debug.ba.rivosinc.com>
References: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
 <20250724-riscv_kcfi-v1-10-04b8fa44c98c@rivosinc.com>
 <20250725161327.GC1724026@google.com>
 <aIOz_wxxCr8tPgXz@debug.ba.rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aIOz_wxxCr8tPgXz@debug.ba.rivosinc.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: E5DB6A0011
X-Rspamd-Server: rspam06
X-Stat-Signature: qhadsbgbzhgtn1ix66e9g5zc3senhmjx
X-HE-Tag: 1753462033-898466
X-HE-Meta: U2FsdGVkX18xetnIz8xggaN03Eq4VbBKfCNxSMGeDEnQGDva77z0H8pwU8FyC/Ylw5tcA1JOCWlAhOwyNNdA1YlWLQNVs1EKSzlE9i7alKlKWy09MYJR7szcCmt7qm0viZ2F0YI+Ilk2InLpCGpG+G3eByOltC2z6telSM7uof3oyfy76x0lWi+qfOvL0ESPvJ8/IyvpdMfI+LolFHTEjR63PxD4jplCDBoALoJKe4+2Ubq7xW39e/yilnnyzMnaVc3RG3pMJCJO0/NY44mMlR5TaZPPtpRALfe+29Z2OkqyZtH7r4KpsBa83Z6QWKcPJSaaKIAcwB65aq7ErtlAOoL6kp53VzGqzVh1DOKoTUcpKFZXpwUkINwuC4qWKjofhdd62TOonmFkLmYGS/sO1DZNLZm+ri9rwq7W1cWd21Zm/pRLSDDgNfcJxmS0QQr9ENxQ5MG0nGfFuvDKJJVaHVqx3NyI+aY/o/wGV28VuH5C87EJseN+ujDIh065NhPphUZpr/3AXIF/7pMa6Zrah+hQqD+Sy+vDuuvVw6iIB309fYBInPFfwflO4VXNja1AsdYV9LWQPn9KB86m8j0LMFvFCl6piYIOd59swdGOFTYlbFMSWimVDtCX3X1oJqY8lA5C6o4vvAiMEF1lc8tNENrc/vkTlWwm//tTFfqmmebtSIDUXqt0fsoWPyFEcow4ZqY3OWroW5epQUFdqH/zYVTEWUUftxRTz6MTqBeUwgOYvpx7evW12NBvIKrTDabFtRx03wcjYORP164uq6fwvgiHJIjiaG13/nnDLQadmpaAGBxGmu6N7QTE+rX9wxEO8ygewSe6MW1Etrc7bDo+Dc0hKonzu5ML0dcFf/8oyB3u+7TE2dksEVJyqxjj2L/KRfdkW6TRPF2J8NE/CraG2Nz9Ducbq9K28W1UcL97woFQlx5ycuo/rvgEK69lNuNL0Jai6B/oehoGGTwsxrY
 M7Rkd2yH
 Uoe1yKlbK9L5yln5SaP8c2Ud+m+5k6HXLb5O/7jsrEeq6xj1CGJ5AVtK+DmcHc0K08TZaZuVxyqYKHHPo1nyhyVeUBBjLeJqXpeAhIu0L1TMbjwvVrN3d8ZT3G5lmyt/CnGNh3NESGNAWCPq5DOl6f82wNcVH3+FKfOQkzv5YC+5qw746DtSQmutqpmOT6b5ZI+cOQGVQ9qNbsEL/Wk+mR9HfN/+C20Jg0g5zrOlj4OWj5Y6jWXwb0eMRe+fpqW4rLKWmjwK2bBIFdh2cXHPPGpwQ50boAnbNWMAGCnVn58hD8RJMCSOqap+VpjSiP3Xwqw5nD1pCtDfkjhAeDl8qX7YFN2KEb/pnXjaixDEe69sDCckN4u8KvE9/dm5wBTCRfPNw7N9cjUT3sW/DUhyyvNuX/GX+F5A//lDwKB7iWm1W4jiAjVJuw3MJt04C8LMxeC/ydMtkcrMaHBdWpmcmJOgXDLRyg3wWrNP++L5rmve3GMZkUbAIOBMkveqOOjSvy9sRiQrpcMVw5Ik4g5ooxYxlO4AwhyuZY98tKD2e20PfiOVJzXVWrp+IuWbLF0SodtuU7nrbIlO/oMP5A/D5TBuTv6ulf2GAdK7a
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry forgot to respond to rest of the comments.

On Fri, Jul 25, 2025 at 09:42:39AM -0700, Deepak Gupta wrote:
>On Fri, Jul 25, 2025 at 04:13:27PM +0000, Sami Tolvanen wrote:
>>On Thu, Jul 24, 2025 at 04:37:03PM -0700, Deepak Gupta wrote:
>>>If shadow stack have memory protections from underlying cpu, use those
>>>protections. arches can define PAGE_KERNEL_SHADOWSTACK to vmalloc such shadow
>>>stack pages. Hw assisted shadow stack pages grow downwards like regular
>>>stack. Clang based software shadow call stack grows low to high address.
>>
>>Is this the case for all the current hardware shadow stack
>>implementations? If not, we might want a separate config for the
>>shadow stack direction instead.
>
>Is there something like this for regular stack as well?
>I could copy same mechanism.
>
>>
>>>Thus this patch addresses some of those needs due to opposite direction
>>>of shadow stack. Furthermore, hw shadow stack can't be memset because memset
>>>uses normal stores. Lastly to store magic word at base of shadow stack, arch
>>>specific shadow stack store has to be performed.
>>>
>>>Signed-off-by: Deepak Gupta <debug@rivosinc.com>
>>>---
>>> include/linux/scs.h | 26 +++++++++++++++++++++++++-
>>> kernel/scs.c        | 38 +++++++++++++++++++++++++++++++++++---
>>> 2 files changed, 60 insertions(+), 4 deletions(-)
>>>
>>>diff --git a/include/linux/scs.h b/include/linux/scs.h
>>>index 4ab5bdc898cf..6ceee07c2d1a 100644
>>>--- a/include/linux/scs.h
>>>+++ b/include/linux/scs.h
>>>@@ -12,6 +12,7 @@
>>> #include <linux/poison.h>
>>> #include <linux/sched.h>
>>> #include <linux/sizes.h>
>>>+#include <asm/scs.h>
>>>
>>> #ifdef CONFIG_SHADOW_CALL_STACK
>>>
>>>@@ -37,22 +38,45 @@ static inline void scs_task_reset(struct task_struct *tsk)
>>> 	 * Reset the shadow stack to the base address in case the task
>>> 	 * is reused.
>>> 	 */
>>>+#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
>>>+	task_scs_sp(tsk) = task_scs(tsk) + SCS_SIZE;
>>>+#else
>>> 	task_scs_sp(tsk) = task_scs(tsk);
>>>+#endif
>>> }
>>>
>>> static inline unsigned long *__scs_magic(void *s)
>>> {
>>>+#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
>>>+	return (unsigned long *)(s);
>>>+#else
>>> 	return (unsigned long *)(s + SCS_SIZE) - 1;
>>>+#endif
>>> }
>>>
>>> static inline bool task_scs_end_corrupted(struct task_struct *tsk)
>>> {
>>> 	unsigned long *magic = __scs_magic(task_scs(tsk));
>>>-	unsigned long sz = task_scs_sp(tsk) - task_scs(tsk);
>>>+	unsigned long sz;
>>>+
>>>+#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
>>>+	sz = (task_scs(tsk) + SCS_SIZE) - task_scs_sp(tsk);
>>>+#else
>>>+	sz = task_scs_sp(tsk) - task_scs(tsk);
>>>+#endif
>>>
>>> 	return sz >= SCS_SIZE - 1 || READ_ONCE_NOCHECK(*magic) != SCS_END_MAGIC;
>>> }
>>>
>>>+static inline void __scs_store_magic(unsigned long *s, unsigned long magic_val)
>>>+{
>>>+#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
>>>+	arch_scs_store(s, magic_val);
>>>+#else
>>>+	*__scs_magic(s) = magic_val;
>>>+#endif
>>>+}
>>>+
>>
>>I'm not a huge fan of all the ifdefs. We could clean this up by
>>allowing architectures to simply override some these functions, or at
>>least use if (IS_ENABLED(CONFIG...)) instead. Will, any thoughts about
>>this?

Yes I don't like it either.
I'll do something about it in next iteration.

>>
>>> DECLARE_STATIC_KEY_FALSE(dynamic_scs_enabled);
>>>
>>> static inline bool scs_is_dynamic(void)
>>>diff --git a/kernel/scs.c b/kernel/scs.c
>>>index d7809affe740..5910c0a8eabd 100644
>>>--- a/kernel/scs.c
>>>+++ b/kernel/scs.c
>>>@@ -11,6 +11,7 @@
>>> #include <linux/scs.h>
>>> #include <linux/vmalloc.h>
>>> #include <linux/vmstat.h>
>>>+#include <asm-generic/set_memory.h>
>>>
>>> #ifdef CONFIG_DYNAMIC_SCS
>>> DEFINE_STATIC_KEY_FALSE(dynamic_scs_enabled);
>>>@@ -32,19 +33,31 @@ static void *__scs_alloc(int node)
>>> {
>>> 	int i;
>>> 	void *s;
>>>+	pgprot_t prot = PAGE_KERNEL;
>>>+
>>>+#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
>>>+	prot = PAGE_KERNEL_SHADOWSTACK;
>>>+#endif
>>
>>I would rather define the shadow stack protection flags in the header
>>file and allow them to be overridden in asm/scs.h.

Yes that's good idea. I'll do that.

>>
>>> 	for (i = 0; i < NR_CACHED_SCS; i++) {
>>> 		s = this_cpu_xchg(scs_cache[i], NULL);
>>> 		if (s) {
>>> 			s = kasan_unpoison_vmalloc(s, SCS_SIZE,
>>> 						   KASAN_VMALLOC_PROT_NORMAL);
>>>+/*
>>>+ * If software shadow stack, its safe to memset. Else memset is not
>>>+ * possible on hw protected shadow stack. memset constitutes stores and
>>>+ * stores to shadow stack memory are disallowed and will fault.
>>>+ */
>>>+#ifndef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
>>> 			memset(s, 0, SCS_SIZE);
>>>+#endif
>>
>>This could also be moved to a static inline function that
>>architectures can override if they have hardware shadow stacks that
>>cannot be cleared at this point.

Make sense.

>>
>>> 			goto out;
>>> 		}
>>> 	}
>>>
>>> 	s = __vmalloc_node_range(SCS_SIZE, 1, VMALLOC_START, VMALLOC_END,
>>>-				    GFP_SCS, PAGE_KERNEL, 0, node,
>>>+				    GFP_SCS, prot, 0, node,
>>> 				    __builtin_return_address(0));
>>>
>>> out:
>>>@@ -59,7 +72,7 @@ void *scs_alloc(int node)
>>> 	if (!s)
>>> 		return NULL;
>>>
>>>-	*__scs_magic(s) = SCS_END_MAGIC;
>>>+	__scs_store_magic(__scs_magic(s), SCS_END_MAGIC);
>>>
>>> 	/*
>>> 	 * Poison the allocation to catch unintentional accesses to
>>>@@ -87,6 +100,16 @@ void scs_free(void *s)
>>> 			return;
>>>
>>> 	kasan_unpoison_vmalloc(s, SCS_SIZE, KASAN_VMALLOC_PROT_NORMAL);
>>>+	/*
>>>+	 * Hardware protected shadow stack is not writeable by regular stores
>>>+	 * Thus adding this back to free list will raise faults by vmalloc
>>>+	 * It needs to be writeable again. It's good sanity as well because
>>>+	 * then it can't be inadvertently accesses and if done, it will fault.
>>>+	 */
>>>+#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
>>>+	set_memory_rw((unsigned long)s, (SCS_SIZE/PAGE_SIZE));
>>>+#endif
>>
>>Another candidate for an arch-specific function to reduce the number
>>of ifdefs in the generic code.

Yes I'll do these changes in next iteration.
>>
>>Sami

