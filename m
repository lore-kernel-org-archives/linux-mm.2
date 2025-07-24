Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B1CC87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 23:37:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 333858E00C8; Thu, 24 Jul 2025 19:37:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E4268E007C; Thu, 24 Jul 2025 19:37:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AC878E00C8; Thu, 24 Jul 2025 19:37:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0738B8E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:37:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8A84216056C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:37:31 +0000 (UTC)
X-FDA: 83700772302.15.9F8C43D
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id 79973C0008
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:37:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=EI93BVSz;
	spf=pass (imf28.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753400249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jnGfibRKNEJZsKsgrkgY/LkGeimQVZTGPU49pFGQkew=;
	b=dCmwR5cJawXY8GHFUo2ETT9LwQfKwJA/wgiogZ6460Z4Yt4sp8lTU04yw8lm4UBmZmZASj
	41KnpZZKjEPd3fFtqB1AWPhYzSLwJBcvXZA2DjvS97i/xZdGHAxOBc40yFI/P9fwF8lVND
	PFcODJkYeKU7ohIjvIREyozELeRjUtg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=EI93BVSz;
	spf=pass (imf28.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753400249; a=rsa-sha256;
	cv=none;
	b=n2Cp+/mQmO/QJzGpE1+ocWmNyYX9JAXWJh8Lijnxrmdb2MOZi1qPR+ASpfJ/YpmKiasdDF
	SQ77gtFuatiVn3Q3+JZLA9mE4LGG3A4Y6tRV8Z/xSsNj6SLC7JgaaH5wVeR7X5HY9jB1l5
	bwmUhbKetkGTx88u69M1wRfpmDDqK+0=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-234fcadde3eso20913255ad.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753400248; x=1754005048; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jnGfibRKNEJZsKsgrkgY/LkGeimQVZTGPU49pFGQkew=;
        b=EI93BVSzJx3+O7bV5lGEXkZBJvS+L4LFHNM3BqNnLwbKxBl5Xgm3tAw4RTox5FR+S8
         xx05au/Y6FNAKO/kZFuIQ8EGbQVlh+w3xz6E0LPn9ZrkJSsqx7woLG2H9rvtBUkhOBvf
         ZHASoKTGqZIsj726h3UW0gSdMBbINrdhFqU9lzxo/xBBGZk1oK7sWrKG3M+boz52riE3
         hsD5cIGM9eYFbHtq4jjioMnN7lfNYYZlv9q4M6Fswyj5Xepgd9+1WBdXAI4FkajfztLa
         hPaPmnrExglWxvrKbJDHrEU/q3vAdbjif1JpEmQjbGX2u1INUuAbb96C0mYRAVp6+1n+
         9tcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753400248; x=1754005048;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jnGfibRKNEJZsKsgrkgY/LkGeimQVZTGPU49pFGQkew=;
        b=jCIsMTPAIVSdcTz46C3do2pFO/uG0hR1M3TGSM3N8JD8zupd6nWvtaV/Aaq953AVJJ
         MzEkP7HGB6srCx15cNG1X9Gvn5WXlKB1V4+Ci1j1XtqHz20YunX9XBoqtJJDzX37wIhs
         gbR7iMokp/AWIHX+ahCgglc58+ngEvy5HulMtbojnl292Hs8Zk98f2Cp7VtQJVPs65gw
         f5oJTsl3vApZWCdXkT+/l26UEcdV/GcpbTNInUal+do8AyAlX3PNxMWSoneggxKDo5wN
         Ua4j98QiaMnudFlnypLp5qE6KIp355KhVKbu6CDBC6OJ+AbllpIN8YVdp5J+vrtHq631
         ZswQ==
X-Forwarded-Encrypted: i=1; AJvYcCW59F4B5n+sdq4x9cnlCy2Ptm6H+zza+nGEt/641mPxbCbKOSx8aRs2Wpyt9ksFfbqZAEWL3jI4Dg==@kvack.org
X-Gm-Message-State: AOJu0YzUl1OQGv9HwEATLp9TXy4eX7zePf4hH+l0ygq7xGL7hoSfCgk7
	BTssZnKTm/0IrR6nTYOUgSybvOJLjxhbfRuPonz2vY1qF7wVIwiOlQLjWXIsdUtEFVtIcIXBwZu
	yFeeY
X-Gm-Gg: ASbGncv6F3iwE5PPME65zn22pwR9+AL3SqThKjTQyo0uGSM0QUpYdIEN+hWwmja2qRV
	Vlan1Zz+rn8EUXTrgHMWkPwz3Y8Qdf2+TG8QY2qZjlqGEgFBxaNzTpkaOoA1wUKXCS/33DWZAqF
	PjVXtFt6F7x6G4Mce4CBR8XvhYCxzBwVtq6F3blRZAyazsUfezyY3HY4hoR59tzJTi5s85SirLw
	wrD1bugPUCK7SqQzNE8sWgk8N2Z+W5cHdH0CPR7Sa8cjai9Z5QqI/M1rmMJe9TMeqQCiRiUrg12
	0FGGpe63OtrqJaGMcXsi7IF81IJuq38qrNZ7K1/GqnS0V1LnJHO5oLSd3irKAM+X/ZyJPQOrk5w
	ZLfwfirifOyER8KkswxRzpmlxcThJifVN
X-Google-Smtp-Source: AGHT+IGkF9wRjCt3t8wgcEzoS0u0I/CZsVHEJO+NVtX/XmjUgLckj9jfIg2rldjVpQc+NplTKJU2kw==
X-Received: by 2002:a17:902:f707:b0:235:c781:c305 with SMTP id d9443c01a7336-23f981932f0mr136844375ad.24.1753400248250;
        Thu, 24 Jul 2025 16:37:28 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fa48bc706sm23598685ad.106.2025.07.24.16.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 16:37:27 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 24 Jul 2025 16:37:03 -0700
Subject: [PATCH 10/11] scs: generic scs code updated to leverage hw
 assisted shadow stack
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250724-riscv_kcfi-v1-10-04b8fa44c98c@rivosinc.com>
References: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
In-Reply-To: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Masahiro Yamada <masahiroy@kernel.org>, 
 Nathan Chancellor <nathan@kernel.org>, 
 Nicolas Schier <nicolas.schier@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@redhat.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Monk Chiang <monk.chiang@sifive.com>, 
 Kito Cheng <kito.cheng@sifive.com>, Justin Stitt <justinstitt@google.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, 
 rick.p.edgecombe@intel.com, broonie@kernel.org, cleger@rivosinc.com, 
 samitolvanen@google.com, apatel@ventanamicro.com, ajones@ventanamicro.com, 
 conor.dooley@microchip.com, charlie@rivosinc.com, samuel.holland@sifive.com, 
 bjorn@rivosinc.com, fweimer@redhat.com, jeffreyalaw@gmail.com, 
 heinrich.schuchardt@canonical.com, andrew@sifive.com, ved@rivosinc.com, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Stat-Signature: 6t7t9qjgmqc8kecq735bxhn37kwcgb5e
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 79973C0008
X-Rspam-User: 
X-HE-Tag: 1753400249-412627
X-HE-Meta: U2FsdGVkX18mBi1xQHREbD4CmCaoK+g7QG2rI1Wo5B5EPKC0KovCvzwwFRRtWE7W+CExfggKS6AtC1yKzK1cipnFvqpLrHFFCMUisGMdzrpOH1D8QAsGfbCmfKuIeZwZFQwLBPFnpduuh4SYFXO/yT7K2LUXWFZW9D4gj5qlmILZhGuEI6aWWx6Smb08pzclWF/tSfOxkl+RHNGd6TEr/j2vWV+aQxEYzdn4pixNzP1L5kEwsAa3jUOVubTwXaasVJbZwYj7wCLZtG0Qd3xl1AxkAG8B5xA7hyFBjT7NPPTDG2D2KBfOprik6fKI9TJ+MGmyXKluB1Hmx0Xa09Bs3Eg9kv/makRCc+JTMw6ADIpZL8kZCTjsjHmAVv+mL8G2fi8TY/FzQYyOHCSJevfKwuKtolbieEWgRDWBGUBqyyGv/M0NSncis7jY9DHNxUTuQ/+LKYW3/J9p7OVDDXdVd9qWwWIryUm6aT0waXzj72lHwkW6hRART1wlKbl56PDki94Wiu2ehbLWDEMx/1Ad5cKArMRfrNsCpir9qzizkDKKw1kYL5mj0Fl58PvGUjYaBCPvSxsLu4HjDEfMQWTbilcj9EKkGAVh8fhHMH70LRFFezxYKOKLTgID0AjBq3FFZRst5JEFJ3ummTVzo/44TaLRlZZK+oxNEty91FnoJ3xqBxz0cZpYzYXsBAGit3O1m3sFGoa13p5hQVT/c0P0Mh5gJqZRZLQ8lkrJcEjaS4mcPkauB0JVgFJ2eUgT2Oos3Lmz+JBuDTcxvCj80cnO2m0AzTEM40k1FLuKVc7ej3jPorep8EP5X06XMRNdRTXoVzo35G6OQGILQ7Xh/TKxQfOh1HKYl1cGPTtjN9aEtfhVpxHXCJenyuNw1mfrIfynQ3wby+FhfeuuzyAfTa8mrTiEXGor77dtkCAwSQZUGKgyT2iiCcVRCfVA2jp0lf1Ha6mKCLFRMRQ3/00MBQF
 NJ4S7G6t
 D49Fw1RQKRChYpuXdU4eG3OIhhgu3IQM5gqbP3xRAEiyGxtNVigy+kw/wFcQUCWEZrmh4tRaAocyp2lqyStH6sabnei0wmesIQYnh1kYRQbpBO2q/uQ5UqSdgpywNiojAUHDpBhk0zQ9fJnDazU7L3ZBvcb1C2TiWIXB3o/ML229hEwcGdTSEkcNW8c9F8FU3gwPgTYTVG63Jsqf3qhfVUDpAsMntOqQokoew2B6C1RpeaSBqXuA/Tp5Danqi1EqOiTEwZ0qBkAwSFTsuKRv8h9WizfEJ5dG3+l9Fn7e+jQinOJGMjfJbLm9gclAEMFU8EM1sKp3ibnagElUOBcFewk0O+GOuwTQ7XNLsa6dkwfLzd6z1IwMbC+OvkXpmGNNtTXGG7DFAI4FHEzNVhX9wvWNcGUysNclObpsWuF5tlo7a8txMEcV9oPtSUfoVRPU/Xw2t7QCFzfzJUrm/7m9RuqBeqNshklubSypxezxdCwULmT/IusUSQwjuauY3N68+QEBc5U8dYpVX4acNw8ja5rn24FQuUlIH2fVo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If shadow stack have memory protections from underlying cpu, use those
protections. arches can define PAGE_KERNEL_SHADOWSTACK to vmalloc such shadow
stack pages. Hw assisted shadow stack pages grow downwards like regular
stack. Clang based software shadow call stack grows low to high address.
Thus this patch addresses some of those needs due to opposite direction
of shadow stack. Furthermore, hw shadow stack can't be memset because memset
uses normal stores. Lastly to store magic word at base of shadow stack, arch
specific shadow stack store has to be performed.

Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 include/linux/scs.h | 26 +++++++++++++++++++++++++-
 kernel/scs.c        | 38 +++++++++++++++++++++++++++++++++++---
 2 files changed, 60 insertions(+), 4 deletions(-)

diff --git a/include/linux/scs.h b/include/linux/scs.h
index 4ab5bdc898cf..6ceee07c2d1a 100644
--- a/include/linux/scs.h
+++ b/include/linux/scs.h
@@ -12,6 +12,7 @@
 #include <linux/poison.h>
 #include <linux/sched.h>
 #include <linux/sizes.h>
+#include <asm/scs.h>
 
 #ifdef CONFIG_SHADOW_CALL_STACK
 
@@ -37,22 +38,45 @@ static inline void scs_task_reset(struct task_struct *tsk)
 	 * Reset the shadow stack to the base address in case the task
 	 * is reused.
 	 */
+#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
+	task_scs_sp(tsk) = task_scs(tsk) + SCS_SIZE;
+#else
 	task_scs_sp(tsk) = task_scs(tsk);
+#endif
 }
 
 static inline unsigned long *__scs_magic(void *s)
 {
+#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
+	return (unsigned long *)(s);
+#else
 	return (unsigned long *)(s + SCS_SIZE) - 1;
+#endif
 }
 
 static inline bool task_scs_end_corrupted(struct task_struct *tsk)
 {
 	unsigned long *magic = __scs_magic(task_scs(tsk));
-	unsigned long sz = task_scs_sp(tsk) - task_scs(tsk);
+	unsigned long sz;
+
+#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
+	sz = (task_scs(tsk) + SCS_SIZE) - task_scs_sp(tsk);
+#else
+	sz = task_scs_sp(tsk) - task_scs(tsk);
+#endif
 
 	return sz >= SCS_SIZE - 1 || READ_ONCE_NOCHECK(*magic) != SCS_END_MAGIC;
 }
 
+static inline void __scs_store_magic(unsigned long *s, unsigned long magic_val)
+{
+#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
+	arch_scs_store(s, magic_val);
+#else
+	*__scs_magic(s) = magic_val;
+#endif
+}
+
 DECLARE_STATIC_KEY_FALSE(dynamic_scs_enabled);
 
 static inline bool scs_is_dynamic(void)
diff --git a/kernel/scs.c b/kernel/scs.c
index d7809affe740..5910c0a8eabd 100644
--- a/kernel/scs.c
+++ b/kernel/scs.c
@@ -11,6 +11,7 @@
 #include <linux/scs.h>
 #include <linux/vmalloc.h>
 #include <linux/vmstat.h>
+#include <asm-generic/set_memory.h>
 
 #ifdef CONFIG_DYNAMIC_SCS
 DEFINE_STATIC_KEY_FALSE(dynamic_scs_enabled);
@@ -32,19 +33,31 @@ static void *__scs_alloc(int node)
 {
 	int i;
 	void *s;
+	pgprot_t prot = PAGE_KERNEL;
+
+#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
+	prot = PAGE_KERNEL_SHADOWSTACK;
+#endif
 
 	for (i = 0; i < NR_CACHED_SCS; i++) {
 		s = this_cpu_xchg(scs_cache[i], NULL);
 		if (s) {
 			s = kasan_unpoison_vmalloc(s, SCS_SIZE,
 						   KASAN_VMALLOC_PROT_NORMAL);
+/*
+ * If software shadow stack, its safe to memset. Else memset is not
+ * possible on hw protected shadow stack. memset constitutes stores and
+ * stores to shadow stack memory are disallowed and will fault.
+ */
+#ifndef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
 			memset(s, 0, SCS_SIZE);
+#endif
 			goto out;
 		}
 	}
 
 	s = __vmalloc_node_range(SCS_SIZE, 1, VMALLOC_START, VMALLOC_END,
-				    GFP_SCS, PAGE_KERNEL, 0, node,
+				    GFP_SCS, prot, 0, node,
 				    __builtin_return_address(0));
 
 out:
@@ -59,7 +72,7 @@ void *scs_alloc(int node)
 	if (!s)
 		return NULL;
 
-	*__scs_magic(s) = SCS_END_MAGIC;
+	__scs_store_magic(__scs_magic(s), SCS_END_MAGIC);
 
 	/*
 	 * Poison the allocation to catch unintentional accesses to
@@ -87,6 +100,16 @@ void scs_free(void *s)
 			return;
 
 	kasan_unpoison_vmalloc(s, SCS_SIZE, KASAN_VMALLOC_PROT_NORMAL);
+	/*
+	 * Hardware protected shadow stack is not writeable by regular stores
+	 * Thus adding this back to free list will raise faults by vmalloc
+	 * It needs to be writeable again. It's good sanity as well because
+	 * then it can't be inadvertently accesses and if done, it will fault.
+	 */
+#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
+	set_memory_rw((unsigned long)s, (SCS_SIZE/PAGE_SIZE));
+#endif
+
 	vfree_atomic(s);
 }
 
@@ -96,6 +119,9 @@ static int scs_cleanup(unsigned int cpu)
 	void **cache = per_cpu_ptr(scs_cache, cpu);
 
 	for (i = 0; i < NR_CACHED_SCS; i++) {
+#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
+		set_memory_rw((unsigned long)cache[i], (SCS_SIZE/PAGE_SIZE));
+#endif
 		vfree(cache[i]);
 		cache[i] = NULL;
 	}
@@ -122,7 +148,13 @@ int scs_prepare(struct task_struct *tsk, int node)
 	if (!s)
 		return -ENOMEM;
 
-	task_scs(tsk) = task_scs_sp(tsk) = s;
+	task_scs(tsk) = s;
+#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
+	task_scs_sp(tsk) = s + SCS_SIZE;
+#else
+	task_scs_sp(tsk) = s;
+#endif
+
 	return 0;
 }
 

-- 
2.43.0


