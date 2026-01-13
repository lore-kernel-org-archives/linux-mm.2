Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFF4ED2F32D
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 19:16:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 220D36B008A; Tue, 13 Jan 2026 14:16:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C0DB6B008C; Tue, 13 Jan 2026 14:16:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09F606B0092; Tue, 13 Jan 2026 14:16:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EA6776B008A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:16:04 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9FF511A0260
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:16:04 +0000 (UTC)
X-FDA: 84327895848.05.FBAA487
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	by imf19.hostedemail.com (Postfix) with ESMTP id 92B241A0008
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:16:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Jb3qYH+X;
	spf=pass (imf19.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768331762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kNWxc7urAc+WPUb7dtJ1KQJNNzOu7ZjngdMJAMiDVCE=;
	b=3rY/kTLxlkehF/zqh2wcwGKGpPhoiYwP2ZuL3TbaPSSqpKdfcOceAUZKSovkKmU42COA7h
	ZJpigHls1OwyVVCdj3Yiw0AxNmDziE50XolPcg0e54xgZSDShdDP43jTYEs9aJbpBuIfJ2
	Asd+LroGvatvEUF2jYTfxvRBO0RvYYg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Jb3qYH+X;
	spf=pass (imf19.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768331762; a=rsa-sha256;
	cv=none;
	b=nFJounhUZFXJipeXcNjlPUvAnvW8uwHhOk1ERkC6Z9EtDfJbVXg2JUgmeK8Rtbwd1P8ikY
	8Y1fn7XwoXBq2l6LMkjuI1ED61JoIatKvSpc76VtbyaKvsi+VrGpMMF+1ZY1jPw+rs6Zcu
	XiXuHEj5WK0/cbYMyn47hRWaUJeSdAI=
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-38316b89455so6506381fa.2
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:16:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768331761; x=1768936561; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kNWxc7urAc+WPUb7dtJ1KQJNNzOu7ZjngdMJAMiDVCE=;
        b=Jb3qYH+XkXcdrv56XUfrA4+WB5OH0TmIvNFAAzZoE7X5sV9VHLSwiKmrsbl4CTTAtv
         YTy1jWJv1nHFUqaN3GuwBQuj14h0ZI3jzkCLcZ5ikSQ98j8E+tDIWSgkYD4OIYTc6v4H
         B2DucLXGfgS6Z1MsmCodBR+cwEuoz4CqK3sAon1MwznuYI+MS0c2ErHlbQ1VdEfkRlbE
         HNPxWBus/bZ2RTmNY+CMpZsDQ2bhb3bDvMjw0XbOR6NbdufwKO3l0e2REMFJ14LphiBU
         7NLzh5X9vOmORPv3w8OlCU8wQiLwpSHP3a3C7/VBG0S5gt+5wBAlMILTplNxBsYArRh+
         IBoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768331761; x=1768936561;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kNWxc7urAc+WPUb7dtJ1KQJNNzOu7ZjngdMJAMiDVCE=;
        b=d36Ui4YeIry7pafOWHZXVeQTCo3z4pDa1UrIXO/n9mdItt+KfWuYUPjZq7MV/FRGLe
         nA1jlMhoUDlIvK8an0LrygNu635laNWKhJ5rXrZHcM2G0x5nky0Yo2Z74A7Bgx4VJc+B
         CM0IC69GmrOfqMtc2YI1NwnL6/ZatzDupkXqK1MLt8vGfn/wMLdVXPuI7qgXpgHX6awD
         Y/MWxZVKqvn+It96YRWfW/QIiw8y+aNjEKIM4Plhmw0ftpH9Ywrhbeq+lpKF5kJTcrlD
         3JORyamfiBuHnx0tX/OzQcNWxsuTwHtvdqOrw95Y2GK0bRbTarA7J2KK9agXwrbc6cdF
         N8tQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIl1lgx1zhnh7HABmomDlYPtcyIotXQQGyVPu1vrqBar8iAR9GJsMRoXF+kspPOPTuffz5fVEnaA==@kvack.org
X-Gm-Message-State: AOJu0YxnF8kIrudp6s4YP3MXPH4S1VtG/RsPpoDU/1UakoxoFyWZzmrW
	7u+1+e7Cp1UUnOdHnT/qJ1HKnQitUSgDGkunmlKdJvA4KO801X457wS9
X-Gm-Gg: AY/fxX5aImH380DzPU76jwlIecO7Ome14Eru3BMKHHSUk2P9MdM0HFUGRr/405wbF+I
	mBqestc5BM9rQ7T2RiI6lEV10MgfsgMZ7wZ6Z1vpOCwjBJBYjKFAyIzHiQIkgHecZOAb7peRDKi
	AqERhlsNtiIDtT6DaZ7vIbefwJOrhGHwWtJJTIXstj8oAujBpcjwNY4SyDpncruKpR/cvcoMRDD
	M7BfZRVYz5makT26DmnA5s4U/QXIh5FObEPnSbTFaHJi5+izxY07ljtm3WYiQHFpy28M88INvqe
	iBlhzyl1MWbz9TbHFauexpXClMc5IgbKQ/DXYRQP7E4DBksFqxQcLL6thWe3s7WBhTjFhdFHJl1
	vH6RjamfS1iQ8G8fO+YLEBq9gQeyrFSgRKicLG9TraIqRDRnI+k403n79S2DvYeSP7IxEJGlWxQ
	qwpAaGJvR4DOXhBMDzNd6gZ6CSFUDSwGq4Kg==
X-Google-Smtp-Source: AGHT+IEWr6drC+zpyxpYdRsl+WTpwPbMxB4PxC6CXmyNXqXAc6ksEPPqWnLy4U69o0ywwEWEZ9DZXw==
X-Received: by 2002:a05:6512:3b25:b0:59b:7291:9cd8 with SMTP id 2adb3069b0e04-59b72919e55mr4212248e87.7.1768331760373;
        Tue, 13 Jan 2026 11:16:00 -0800 (PST)
Received: from dellarbn.yandex.net ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59b6a97e94csm5568773e87.91.2026.01.13.11.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 11:15:59 -0800 (PST)
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
	Maciej Wieczor-Retman <m.wieczorretman@pm.me>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	kasan-dev@googlegroups.com,
	Uladzislau Rezki <urezki@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	joonki.min@samsung-slsi.corp-partner.google.com,
	stable@vger.kernel.org
Subject: [PATCH 1/2] mm/kasan: Fix KASAN poisoning in vrealloc()
Date: Tue, 13 Jan 2026 20:15:15 +0100
Message-ID: <20260113191516.31015-1-ryabinin.a.a@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <CANP3RGeuRW53vukDy7WDO3FiVgu34-xVJYkfpm08oLO3odYFrA@mail.gmail.com>
References: <CANP3RGeuRW53vukDy7WDO3FiVgu34-xVJYkfpm08oLO3odYFrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 92B241A0008
X-Stat-Signature: qe489higtef19bh8hjt6ryqfpkaciwpk
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768331762-1324
X-HE-Meta: U2FsdGVkX19eDzBsV8kSeCW21l/GcaoB4Z804ILVT1Kqw470Eei9ZmSRQ4kHiZLVJgq15JthJhMh+5ILj4q/MHRaqN3ZSKddQJfX6L1U1ksB4EVyBW/Ur+7v+o+Tk4KxJ+tRTr8Y8ivCJXVPAp6zP0w5dh7Vi/E5tSkdhYqrERLEadqcafcnErYASfKfNVYfKCL1kmG8XL4Uf1Vkl9nHJHSoGQqTNOF5FeiOAsHZHeYuHvYQwSRV7jKoakpcklYQGtw/4ncdv5JItLVnESvFAqz9Wi8GvsbWR8jDNuEtba8LHOeLYzN5L0Yo8lJqX2bj4SDxwEgfPigbc2rkjK3+BGvK3EPuF7R/OZMlgKJzkew+h3uGcyZohRbTMl2JUNt2/hTOEfo3SoNZJiYTJeWfJr/6SVCgbwc1J3L3i+Urr85YlPEeUkk8Uum4oRQQ9JJBCQzCet8f/3g1g/8+NLjIVJEqHb+EwmGank0Gq6KBU4DsNqXtaKLVCtwozOc3Gktb58H4ZaQF3YIinj1NJ3rv3VH2wL1TXxj7SfjZeY3paNd9DlsbVZIa9tnqEOdETTvxJiDnX2HrWeGJNrQJuclZChQb711y0Shdg70Mqs2emil0YGI1C526LLIwc27LqhfzUaDzsVqQo2zitXud475n57LsTWXYzSg/mKnohxPIzREhgfoOMO65P4RrzRb0Ql9goyAWM0DC3vlP7z3XabkDmnowTgh1M2Tz6XBhw7SyYf87LjqnGSaphjSGlgsx5EIgGluPQkK4P2BIfNrp2om2RAJmFTtchO8nO+ZKyxNml6anF9erVWnAZycDrFJ8iwh3URBwYNhEIf0BJtouysVEBbRwksI0WsDlVwcF6bJgol446utNSFSer0FIojYhKKfbLLC+nL7FR5SPoGjwmYB3Ru/MB7/hDcEd1Zfj/+P7BEJbCFLt053andvEju3ILSS9Kx+ssInXm5dmiAhKT8x
 RLQUPCCV
 mWNFRv32Ixq5zYQAtCyEcNwSxr2LH6hymxaz/8v56/OquKys8h7Fgl9inTamRYUc82/QArvq1iq30kRO/X5MbSVrEKs/EuKZyBOuN2BjQ0zDE/f/wNbEivIxwx4IYK55K8gm6BNKHihB05Uz3PdO3toME0xVzY/9Y7I9jL386508W54j8kIPsMTycXg996sifv8+U9OWIOFf+hCkA2ogsHbYCkOl64owcNsD/1+/mM+zNF5lCS2WMLk818GRnKGNU3Q+FpOUowlLZ419Lvms0EJh1n0+9VlTvJpYChFn3GwQ/XPrYJnKG00m2vFyYb7/UKjWVxWJDZScPjgIJk56ZfNIIBPWXv8fTHAd8TWRsIVNxcQtQoWCuAF+A+vqom7QDJQRjW9wVUeEvSQI6VeMAs1rywoOP+KCOjC2c2HTuIIxP6XwQIgk3YxATkHi3TGQ4gxytnN/JcXb8fulOOcKSw1G7J1PWp+WOLqxBnwQUn9vQfYwzY3kMY7Ec0TSI6kTYNkf3ENKY6zufYFp1U0SnnC2fYQn7T9Mi+5A2CZDHkvV+mRlGCQpIluR17TPtEoXfKLQnJzgHVmIqaFpL1liJI0S4aukNIboq5DxVu/fx772RLaWbYeuJb5rH7cKAoqW9V2Xj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A KASAN warning can be triggered when vrealloc() changes the requested
size to a value that is not aligned to KASAN_GRANULE_SIZE.

    ------------[ cut here ]------------
    WARNING: CPU: 2 PID: 1 at mm/kasan/shadow.c:174 kasan_unpoison+0x40/0x48
    ...
    pc : kasan_unpoison+0x40/0x48
    lr : __kasan_unpoison_vmalloc+0x40/0x68
    Call trace:
     kasan_unpoison+0x40/0x48 (P)
     vrealloc_node_align_noprof+0x200/0x320
     bpf_patch_insn_data+0x90/0x2f0
     convert_ctx_accesses+0x8c0/0x1158
     bpf_check+0x1488/0x1900
     bpf_prog_load+0xd20/0x1258
     __sys_bpf+0x96c/0xdf0
     __arm64_sys_bpf+0x50/0xa0
     invoke_syscall+0x90/0x160

Introduce a dedicated kasan_vrealloc() helper that centralizes
KASAN handling for vmalloc reallocations. The helper accounts for KASAN
granule alignment when growing or shrinking an allocation and ensures
that partial granules are handled correctly.

Use this helper from vrealloc_node_align_noprof() to fix poisoning
logic.

Reported-by: Maciej Żenczykowski <maze@google.com>
Reported-by: <joonki.min@samsung-slsi.corp-partner.google.com>
Closes: https://lkml.kernel.org/r/CANP3RGeuRW53vukDy7WDO3FiVgu34-xVJYkfpm08oLO3odYFrA@mail.gmail.com
Fixes: d699440f58ce ("mm: fix vrealloc()'s KASAN poisoning logic")
Cc: stable@vger.kernel.org
Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
---
 include/linux/kasan.h |  6 ++++++
 mm/kasan/shadow.c     | 24 ++++++++++++++++++++++++
 mm/vmalloc.c          |  7 ++-----
 3 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index 9c6ac4b62eb9..ff27712dd3c8 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -641,6 +641,9 @@ kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms,
 		__kasan_unpoison_vmap_areas(vms, nr_vms, flags);
 }
 
+void kasan_vrealloc(const void *start, unsigned long old_size,
+		unsigned long new_size);
+
 #else /* CONFIG_KASAN_VMALLOC */
 
 static inline void kasan_populate_early_vm_area_shadow(void *start,
@@ -670,6 +673,9 @@ kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms,
 			  kasan_vmalloc_flags_t flags)
 { }
 
+static inline void kasan_vrealloc(const void *start, unsigned long old_size,
+				unsigned long new_size) { }
+
 #endif /* CONFIG_KASAN_VMALLOC */
 
 #if (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)) && \
diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index 32fbdf759ea2..e9b6b2d8e651 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -651,6 +651,30 @@ void __kasan_poison_vmalloc(const void *start, unsigned long size)
 	kasan_poison(start, size, KASAN_VMALLOC_INVALID, false);
 }
 
+void kasan_vrealloc(const void *addr, unsigned long old_size,
+		unsigned long new_size)
+{
+	if (!kasan_enabled())
+		return;
+
+	if (new_size < old_size) {
+		kasan_poison_last_granule(addr, new_size);
+
+		new_size = round_up(new_size, KASAN_GRANULE_SIZE);
+		old_size = round_up(old_size, KASAN_GRANULE_SIZE);
+		if (new_size < old_size)
+			__kasan_poison_vmalloc(addr + new_size,
+					old_size - new_size);
+	} else if (new_size > old_size) {
+		old_size = round_down(old_size, KASAN_GRANULE_SIZE);
+		__kasan_unpoison_vmalloc(addr + old_size,
+					new_size - old_size,
+					KASAN_VMALLOC_PROT_NORMAL |
+					KASAN_VMALLOC_VM_ALLOC |
+					KASAN_VMALLOC_KEEP_TAG);
+	}
+}
+
 #else /* CONFIG_KASAN_VMALLOC */
 
 int kasan_alloc_module_shadow(void *addr, size_t size, gfp_t gfp_mask)
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 41dd01e8430c..2536d34df058 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4322,7 +4322,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 		if (want_init_on_free() || want_init_on_alloc(flags))
 			memset((void *)p + size, 0, old_size - size);
 		vm->requested_size = size;
-		kasan_poison_vmalloc(p + size, old_size - size);
+		kasan_vrealloc(p, old_size, size);
 		return (void *)p;
 	}
 
@@ -4330,16 +4330,13 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 	 * We already have the bytes available in the allocation; use them.
 	 */
 	if (size <= alloced_size) {
-		kasan_unpoison_vmalloc(p + old_size, size - old_size,
-				       KASAN_VMALLOC_PROT_NORMAL |
-				       KASAN_VMALLOC_VM_ALLOC |
-				       KASAN_VMALLOC_KEEP_TAG);
 		/*
 		 * No need to zero memory here, as unused memory will have
 		 * already been zeroed at initial allocation time or during
 		 * realloc shrink time.
 		 */
 		vm->requested_size = size;
+		kasan_vrealloc(p, old_size, size);
 		return (void *)p;
 	}
 
-- 
2.52.0


