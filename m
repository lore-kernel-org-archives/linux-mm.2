Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6511ED12D6E
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 14:36:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFEBF6B0012; Wed,  3 Dec 2025 09:36:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD5A76B0023; Wed,  3 Dec 2025 09:36:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEC0D6B0024; Wed,  3 Dec 2025 09:36:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9ECC06B0012
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:36:22 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 51A1C16060A
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 14:36:22 +0000 (UTC)
X-FDA: 84178410204.22.CFC0204
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4030B14000E
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 14:36:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XzfmbaTJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764772580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WqZz+UdQZ7oDFGWPY3pfq+b8hIScIuAU1EHuxuuGOkM=;
	b=jieHEZOzhB9xAHNz/XoKWNVJpNHbHQw3Q8+o4DH+5qrWYi9Z4raIb3iKYa0VTX06SzufAq
	9eB7qCGds6FuuALOLpl1gvONtN+wWVHXYtFEU7bfMQlIxhiXpEGRs2osPJNSDRlGLzd71R
	FIkQRml7hDoVjy+lYFMkr1PkX2xzEEo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XzfmbaTJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764772580; a=rsa-sha256;
	cv=none;
	b=inIoqMxKHF1zGSocS+pXwHCbTFbabmTgA+e4MD5VRp4Nd6fhcaUceelYEA99Gkbny0G/g9
	x0U3KSHGqPd0gYM03yqy+l6cRz/qjxGaYawUTG2KBiY0r/ezTVkg8pFmWhfoy7D4v0iCum
	MQdRgbTPp6iA0CXI6cZ6QbSSe04Q+mk=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b73b24f1784so34310266b.0
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 06:36:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764772578; x=1765377378; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WqZz+UdQZ7oDFGWPY3pfq+b8hIScIuAU1EHuxuuGOkM=;
        b=XzfmbaTJuA0uXhOZi5oFgqf4nqudTR4xvH8ECD8rFvNZqGixoS+fRH4XXjDjyW+H83
         UweR8RVbgc8lV1SgrDOqdLYFba+82VQrBVh0Umie3JYUnQA38j9xoTzVzcohVJChF5jz
         5WdfpPvj1vaHSjlc5DiHbnL+je1GQ9uZbfopZm+qYsibDVMfRQUdwoER83qq4my7SmiF
         Z4DnuVhkjcHlPKdeUoMPV9Lr6kRmLJEgIUBxde44Ryzj7q/yJp3BZOM2X+n2YFK3SW+m
         HK05CSM16sqH2KKsWcxIdNO7VLDIfoSLd8A06LCzchi4RXTssGZbQGSHJBn4w4+P+Ols
         Lnrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764772578; x=1765377378;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WqZz+UdQZ7oDFGWPY3pfq+b8hIScIuAU1EHuxuuGOkM=;
        b=nqwQ9CDYRB008bfmM/5LdU+oZ05iq+4Wxtfy7lNNUmU8wVMBMYANxYxitTJfrtaVWE
         4pFNkDnYuZaflIK2WQwy1w/LMhYQVXuAJNd89dmNqscMk/evcosNZduKUi1rIyl4Z6lU
         TJmrZR1qw7/FUFX97H1zcftVrASeM7jFfl9unmH4CoYAwN5PhC5lweWPTTxCRKloPc2O
         68LjiSEGcI5V2mAHuGQj3uJeT2N5MxL7J/xaaueBqCfA9q/E3oOcJovUn9WAjWgSNsMM
         psUedx3ZRlbu0aViK6zCMZGBQvk6JSpLaF9LfzyuNguWmpz6jly8zxDnuIIYZxxaGXkb
         Doow==
X-Forwarded-Encrypted: i=1; AJvYcCV+07mbwzusNPW7dtNKJuXpqv+O7cmBxH/mNx7HfpS0Sn9Qs120XHAKFSqa6/1EqyornlOoLhTDZg==@kvack.org
X-Gm-Message-State: AOJu0YyAZ8DuBOUR+azl3JYCD0xUxU28lt5tnGekJs+zm7+QZDqMZ9TT
	cMykDZxoO4v3i/wVOqsYE7ybkYw5bgsX27xYrctvK2efOS17GIngSEaQ
X-Gm-Gg: ASbGncvv6bh/bcqBQw2TNknjvVlowc3zNthfjHCu5bMv9OhxceUgEgkT+asQYOfKNLB
	DyneFQDV/X6KHMrLbWqFvvyzObOC1TqZbKTpxrSU2x42Vm2znsZz9oYXqKzpGiA/KVNHdpmeK9S
	9DVWET1zcqnLFpACJxfZfSLk5tCqqltdULJHSCF5LxgGzyZa+OtBVahC232Qs9L3FsA6bdSkUG5
	h2kL8GxhTbU82TbKQ59YaWLCqvFJydMzUAKPYYkIkXoOSI1cmY4gP4REmEFNRp0605DYqC1vwvv
	dcy6WS86MjFkLo+hBcb/PowJLcHlUbK9NsKIG5fd/PZd99AIZVdU485kT5wf017Yk4iO3TnDgXZ
	gEaHhkHLdt/EFt7omMLmd0py4VyGhAo9HVEP9/KiqTqFeNZfZeGJpRiZn1CCbBU7HWjn7SLeeLG
	eKYamjUyANJJ29YFvw1Ux3+ldkkwIRm4AsdgxV7k/8I0P5SS2ausRxP/lKp7bDziGD9tU=
X-Google-Smtp-Source: AGHT+IEbSuoxuxIiiYavA9kyt0Y9xc37GOyuFjuL5z6ypyq1o/k1KWV6Pc/twF0cxMdezGXnX1EIXg==
X-Received: by 2002:a17:907:97c1:b0:b73:1aba:2ebf with SMTP id a640c23a62f3a-b79d611ec22mr349376166b.2.1764772578287;
        Wed, 03 Dec 2025 06:36:18 -0800 (PST)
Received: from f (cst-prg-14-82.cust.vodafone.cz. [46.135.14.82])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76f51c8393sm1811480366b.31.2025.12.03.06.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 06:36:17 -0800 (PST)
Date: Wed, 3 Dec 2025 15:36:08 +0100
From: Mateusz Guzik <mjguzik@gmail.com>
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: Jan Kara <jack@suse.cz>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 0/4] Optimize rss_stat initialization/teardown for
 single-threaded tasks
Message-ID: <6vss7walhjfjmgau5sytf5b3lyjadmfi4seh6amxlthl3sig3b@dpbuhz6ds26y>
References: <20251127233635.4170047-1-krisman@suse.de>
 <f1a1b7ba-c084-4e41-9242-8255f2664b76@efficios.com>
 <yvghqmbugs3oejsvbh5rrw76rvtr2wfwqysjd7tw67z4tzpdbp@6zehhuzumiez>
 <CAGudoHEyX1gdwG_MVf-M2KMHBE1Juo6VbfSyp3rbXoS+5JaNtw@mail.gmail.com>
 <877bv6i5ts.fsf@mailhost.krisman.be>
 <CAGudoHFZhrNwM8bnkFUkad4x_ibZZqbax_psF7CX_SrFQprJbw@mail.gmail.com>
 <CAGudoHGYC=TdLfzQ0wW5NOrZh1Xy9aSHEYiMLqv_ekX5f52M7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAGudoHGYC=TdLfzQ0wW5NOrZh1Xy9aSHEYiMLqv_ekX5f52M7g@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 4030B14000E
X-Rspamd-Server: rspam11
X-Stat-Signature: c1yi8ufbnphybr5e41g14kk411c8ruz9
X-HE-Tag: 1764772579-829412
X-HE-Meta: U2FsdGVkX18FYkuzEDhMojPs2TbfRwPfu3tDuJQc/7vLM8hk1Uc5dhptTeQVKdRS4BgDjzuS3cZ5q8aGzZQlHbkmKkNjotvc+KWTcCzMRSD/b5XD2TQ6YH3Fpx6dsg6Z3oHtZhaP4sul9xDhbd8lwoAVFU7B3Cl01Ax+Wl6eZfUdcmwTykkGe8Vin+Hn6Mz/5rlTGjuL/p/R9tRjZH4Q7Yjy2vpBCNDvGv8Q8LlOXqthE6EyD1UtwwOUVaTCfnsDeHhUYxbxV60Y5J6ESXlqOpxRVbBitsNlfeQDRsFEyl1vxO6BPRzBgnhbJmGVdf1IENro+fEd2cUhBRs6p5vd2QDF1rtJE1kJsOZ0FgacP0ngiu/ndmt5Cseihyl2zQGP5IBi8tpSkvxvpkR5n7fggYnZc1b3wLhavEyIE+YcsG6zCfLgaqZ1xMmhPc6FufIzCrLdIjvikVMBGwN5tbKL/hD3TwsEt2jrvkidNUuP3u1N6jsKgdqjDxnh2CR6NqOZH8KTh4Piz3c1GZePAWolCXkEyz2cMZ+XPRcfjvKpzMlVANVn/SnRpevxg79JscShnb2GayvlQacgFBUqaj0eds9sI+uKrkfMQ70hkpwtXYY+74qd81ug7kWItY5VGtdwIfzmyXtT2D+Zj7WgIfMYrdplPJiFRwZ6c+rgIEP8Hjk7Y5vwuEcyI8Ly99oWVy/CIB25KVo5njDcQtsuZEX0jOLWiVeGwO1Ksa/VOFfvIMog1b6mdNb5TaQN+pt2j17pvcDbnzvS3Q+rcD+60LRvXSHuL1mUmhGd6pbfNlneKt08tJhtZ5cCzlUx7A5X7tPuhpkfthIb2X3hBmjnobIcpa7SmhiUDM1NuuJgLbN+3+8GGUBriURq9D/oqf1lS6zg63rTQu0qXPlH1hj5nka3wMNmUza8cUVnlX4LaTAC6dGLp193wvf+G80ABJ5jqPJs5KbN8Ujn/M7afMonCap
 9lF1J1ti
 tvz+I4OfWZ4yS8CbvLTYYLveNZZY8rFT7x+mnIGZi9nnfAkOU9uiS+ZmjsQ85pihe0BmGV5tR+0aDFkgS0wBgmV0rBAyr6JamMuhVwvluVdSlsYBsqmL0ZzW33g5AA7aYkybCpM5CSgpym2J3ewQbgbzp/9LJ0r6liNYyMinXs/tP6A6YtatXKS1QYTLVVd/nh50R+nt/OM8InGA4hYo9GaOMWbu9kKhkBks7p0ZQAdM4zcWLoW+xFbwVHke54ae0qnwpd3sscFmuAL6kex0JOB4OPfCh2c+CjFqm8XVtLTFWzA4gSkH8C1xjSljbkdyoWaipEgk6aPGNFwxnCxyk9VfQDqePgTvTU6E7biP6WoluOfIynAm0T17IUBeV5QqBCK7wCUzv5Nv07ZMlqhgYGcClc1lt8Zi3dkJjJpL91X7vZaVZ4f3SsYEbY8CuuaqxhZf6cwdqbjTHo59HnPwZfgm7dyPV1iNg522NigJLe5Vrt1ub12Reg3Tanla0Fgt5Dh63QghxvLiwfFpivZD8a1erdhq2iXks2c1eRasNzCKmXuY4Wrhwh1MSUg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 03, 2025 at 12:54:34PM +0100, Mateusz Guzik wrote:
> So I got another idea and it boils down to coalescing cid init with
> rss checks on exit.
> 
 
So short version is I implemented a POC and I have the same performance
for single-threaded processes as your patchset when testing on Sapphire
Rapids in an 80-way vm.

Caveats:
- there is a performance bug on the cpu vs rep movsb (see https://lore.kernel.org/all/mwwusvl7jllmck64xczeka42lglmsh7mlthuvmmqlmi5stp3na@raiwozh466wz/), I worked around it like so:
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index e20e25b8b16c..1b538f7bbd89 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -189,6 +189,29 @@ ifeq ($(CONFIG_STACKPROTECTOR),y)
     endif
 endif
 
+ifdef CONFIG_CC_IS_GCC
+#
+# Inline memcpy and memset handling policy for gcc.
+#
+# For ops of sizes known at compilation time it quickly resorts to issuing rep
+# movsq and stosq. On most uarchs rep-prefixed ops have a significant startup
+# latency and it is faster to issue regular stores (even if in loops) to handle
+# small buffers.
+#
+# This of course comes at an expense in terms of i-cache footprint. bloat-o-meter
+# reported 0.23% increase for enabling these.
+#
+# We inline up to 256 bytes, which in the best case issues few movs, in the
+# worst case creates a 4 * 8 store loop.
+#
+# The upper limit was chosen semi-arbitrarily -- uarchs wildly differ between a
+# threshold past which a rep-prefixed op becomes faster, 256 being the lowest
+# common denominator. Someone(tm) should revisit this from time to time.
+#
+KBUILD_CFLAGS += -mmemcpy-strategy=unrolled_loop:256:noalign,libcall:-1:noalign
+KBUILD_CFLAGS += -mmemset-strategy=unrolled_loop:256:noalign,libcall:-1:noalign
+endif
+
 #
 # If the function graph tracer is used with mcount instead of fentry,
 # '-maccumulate-outgoing-args' is needed to prevent a GCC bug

- qemu version i'm saddled with does not pass FSRS to the guest, thus:
diff --git a/arch/x86/lib/memset_64.S b/arch/x86/lib/memset_64.S
index fb5a03cf5ab7..a692bb4cece4 100644
--- a/arch/x86/lib/memset_64.S
+++ b/arch/x86/lib/memset_64.S
@@ -30,7 +30,7 @@
  * which the compiler could/should do much better anyway.
  */
 SYM_TYPED_FUNC_START(__memset)
-       ALTERNATIVE "jmp memset_orig", "", X86_FEATURE_FSRS
+//     ALTERNATIVE "jmp memset_orig", "", X86_FEATURE_FSRS
 
        movq %rdi,%r9
        movb %sil,%al

Baseline commit (+ the 2 above hacks) is the following:
commit a8ec08bf32595ea4b109e3c7f679d4457d1c58c0
Merge: ed80cc758b78 48233291461b
Author: Vlastimil Babka <vbabka@suse.cz>
Date:   Tue Nov 25 14:38:41 2025 +0100

    Merge branch 'slab/for-6.19/mempool_alloc_bulk' into slab/for-next

This is what the ctor/dtor branch is rebased on. It is missing some of
the further changes to cid machinery in upstream, but they don't
fundamentally mess with the core idea of the patch (pcpu memory is still
allocated on mm creation and it is being zeroed) so I did not bother
rebasing -- end perf will be the same.

Benchmark is a static binary executing itself in a loop: http://apollo.backplane.com/DFlyMisc/doexec.c
    
$ cc -O2 -o static-doexec doexec.c
$ taskset --cpu-list 1 ./static-doexec 1

With ctor+dtor+unified walk I'm seeing 2% improvement over the baseline and the same performance as lazy counter.

If nobody is willing to productize this I'm going to do it.

non-production hack below for reference:
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index cb9c6b16c311..f952ec1f59d1 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1439,7 +1439,7 @@ static inline cpumask_t *mm_cidmask(struct mm_struct *mm)
 	return (struct cpumask *)cid_bitmap;
 }
 
-static inline void mm_init_cid(struct mm_struct *mm, struct task_struct *p)
+static inline void mm_init_cid_percpu(struct mm_struct *mm, struct task_struct *p)
 {
 	int i;
 
@@ -1457,6 +1457,15 @@ static inline void mm_init_cid(struct mm_struct *mm, struct task_struct *p)
 	cpumask_clear(mm_cidmask(mm));
 }
 
+static inline void mm_init_cid(struct mm_struct *mm, struct task_struct *p)
+{
+	mm->nr_cpus_allowed = p->nr_cpus_allowed;
+	atomic_set(&mm->max_nr_cid, 0);
+	raw_spin_lock_init(&mm->cpus_allowed_lock);
+	cpumask_copy(mm_cpus_allowed(mm), &p->cpus_mask);
+	cpumask_clear(mm_cidmask(mm));
+}
+
 static inline int mm_alloc_cid_noprof(struct mm_struct *mm)
 {
 	mm->pcpu_cid = alloc_percpu_noprof(struct mm_cid);
diff --git a/kernel/fork.c b/kernel/fork.c
index a26319cddc3c..1575db9f0198 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -575,21 +575,46 @@ static inline int mm_alloc_id(struct mm_struct *mm) { return 0; }
 static inline void mm_free_id(struct mm_struct *mm) {}
 #endif /* CONFIG_MM_ID */
 
+/*
+ * pretend this is fully integrated into hotplug support
+ */
+__cacheline_aligned_in_smp DEFINE_SEQLOCK(cpu_hotplug_lock);
+
 static void check_mm(struct mm_struct *mm)
 {
-	int i;
+	long rss_stat[NR_MM_COUNTERS];
+	unsigned cpu_seq;
+	int i, cpu;
 
 	BUILD_BUG_ON_MSG(ARRAY_SIZE(resident_page_types) != NR_MM_COUNTERS,
 			 "Please make sure 'struct resident_page_types[]' is updated as well");
 
-	for (i = 0; i < NR_MM_COUNTERS; i++) {
-		long x = percpu_counter_sum(&mm->rss_stat[i]);
+	cpu_seq = read_seqbegin(&cpu_hotplug_lock);
+	local_irq_disable();
+	for (i = 0; i < NR_MM_COUNTERS; i++)
+		rss_stat[i] = mm->rss_stat[i].count;
+
+	for_each_possible_cpu(cpu) {
+		struct mm_cid *pcpu_cid = per_cpu_ptr(mm->pcpu_cid, cpu);
+
+		pcpu_cid->cid = MM_CID_UNSET;
+		pcpu_cid->recent_cid = MM_CID_UNSET;
+		pcpu_cid->time = 0;
 
-		if (unlikely(x)) {
+		for (i = 0; i < NR_MM_COUNTERS; i++)
+			rss_stat[i] += *per_cpu_ptr(mm->rss_stat[i].counters, cpu);
+	}
+	local_irq_enable();
+	if (read_seqretry(&cpu_hotplug_lock, cpu_seq))
+		BUG();
+
+	for (i = 0; i < NR_MM_COUNTERS; i++) {
+		if (unlikely(rss_stat[i])) {
 			pr_alert("BUG: Bad rss-counter state mm:%p type:%s val:%ld Comm:%s Pid:%d\n",
-				 mm, resident_page_types[i], x,
+				 mm, resident_page_types[i], rss_stat[i],
 				 current->comm,
 				 task_pid_nr(current));
+			/* XXXBUG: ZERO IT OUT */
 		}
 	}
 
@@ -2953,10 +2978,19 @@ static int sighand_ctor(void *data)
 static int mm_struct_ctor(void *object)
 {
 	struct mm_struct *mm = object;
+	int cpu;
 
 	if (mm_alloc_cid(mm))
 		return -ENOMEM;
 
+	for_each_possible_cpu(cpu) {
+		struct mm_cid *pcpu_cid = per_cpu_ptr(mm->pcpu_cid, cpu);
+
+		pcpu_cid->cid = MM_CID_UNSET;
+		pcpu_cid->recent_cid = MM_CID_UNSET;
+		pcpu_cid->time = 0;
+	}
+
 	if (percpu_counter_init_many(mm->rss_stat, 0, GFP_KERNEL,
 				     NR_MM_COUNTERS)) {
 		mm_destroy_cid(mm);
diff --git a/mm/percpu.c b/mm/percpu.c
index 7d036f42b5af..47e23ea90d7b 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1693,7 +1693,7 @@ static void pcpu_memcg_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
 
 	obj_cgroup_put(objcg);
 }
-bool pcpu_charge(void *ptr, size_t size, gfp_t gfp)
+bool pcpu_charge(void __percpu *ptr, size_t size, gfp_t gfp)
 {
 	struct obj_cgroup *objcg = NULL;
 	void *addr;
@@ -1710,7 +1710,7 @@ bool pcpu_charge(void *ptr, size_t size, gfp_t gfp)
 	return true;
 }
 
-void pcpu_uncharge(void *ptr, size_t size)
+void pcpu_uncharge(void __percpu *ptr, size_t size)
 {
 	void *addr;
 	struct pcpu_chunk *chunk;

