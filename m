Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A1B7C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:47:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB6DD6B00AE; Wed, 23 Jul 2025 10:46:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8ED96B00B0; Wed, 23 Jul 2025 10:46:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7D856B00B1; Wed, 23 Jul 2025 10:46:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C90456B00AE
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:46:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 69E90133799
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:46:59 +0000 (UTC)
X-FDA: 83695806558.09.481DB50
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf22.hostedemail.com (Postfix) with ESMTP id 78A5FC000D
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:46:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=aPGlA4ko;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753282017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=inB1PU3JWa0vbtTol7UPnIAGavYFixpKMP3Mnwcd84A=;
	b=qYrhrmzGJzObqyV03XAVqCRx0QqWUBNPDXlIg8UrfKEc8gIsUCUKVJaVlYFFxnozTFS19D
	aglSxw62+XaxGGLQhMzyd2ftbM6nOpC7DgpQd1aCGLsG1KdZ2fcnU0FZirWqnWuoQLZvEh
	h08Zt3k3k0LdGqpvCmf0hJUPCsRncr0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753282017; a=rsa-sha256;
	cv=none;
	b=F7Ejyr4dqplDuP+iWjVvlMDUzIPKnTeU1X74N22S7aWzs64h1kTDGcNATyCiVVknvr9SMN
	R5U+IFPpd+3VaHmw8OWvdLYL1OMhnTwWYiXEDESLrTOyA/EWK99J9lyTvHdt+Cb+N/hTs/
	T/4Za8Du+uQwQ18b9Ft4+ZQFj72Ty8Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=aPGlA4ko;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-719c4aa9b19so1152007b3.0
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1753282016; x=1753886816; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=inB1PU3JWa0vbtTol7UPnIAGavYFixpKMP3Mnwcd84A=;
        b=aPGlA4koejVkSjAbpQohOI4T/67Hkbq6R5hhWmf8LlhZ/0IBpyxA3NBUVQsWeJgbT4
         Ggx/9YYFjdqvEXiZC0aKIXY8jjqDG6XF0d0fWDKiVaYyiX6NyB/OjqsS6aACM8oxEgLp
         pfD1HbieSkh5DTqZd2f06fLte6BwIbd2NXQe7S8tjtyHyTTrgn2kAIyZAFgbd35JiQXN
         tWOZyx5wus+1fzn7BwoNMpRwvjxQA9vugT8CIvV352pMxAKi89D33Nw3kXXclRGRLiTC
         kQ4i16wR1o8haJCmlz8KoZ2LHSA04Vfx35I8rBnIbRnBHe8CXpD5Mnx58ACadNsOTdt+
         8HgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753282016; x=1753886816;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=inB1PU3JWa0vbtTol7UPnIAGavYFixpKMP3Mnwcd84A=;
        b=ceg8g4wBXCy4EnJQBMe4htmdtsgqEPApINW9Ut/zR9zWhDKgCwzod+AYWdFIadwzLk
         ZSulmoxBpriVRKaA0RHeAtGqyt3GJDQA0B8Q5+8pwfyopyq384rrdCOw7bg/a92XA1UJ
         eHTekLhv5govlps0BAo5gfNA9MmAiR5EphVSSrmaHqj4SzPzNZtyRuHo7KbfUAhTUHqf
         5GqDV9bbxxgn1D9bfdazMJxF3XaJyg1sXp7ANAd3aBK7d5TEKlQdy9b5XynSk2ym6Rxc
         efGaGWF/+SoMRU71lOqKfjcY73euzaB4NFjasdJlpLqulF1Qqz2dWsdrN+3Ul2U8gOKe
         ikJA==
X-Forwarded-Encrypted: i=1; AJvYcCWwnPfEeZuPurPU0ouaGXrCNqgnBKXKByJ6mgDbe3d1Oo70AI9LhA43tvN+EV0v6G5HfboURFaavQ==@kvack.org
X-Gm-Message-State: AOJu0YxmaMRtPHgKstW+gmltUAY52S3U4Z1tvu4J+almLoJp6hoM4k2/
	Ag0Kk5+2X09VAbXyqR8CJAz9wEre9ZI6WNd/Lwyd+CS32yzQX5ZTgDQi7+vmJthrLdE=
X-Gm-Gg: ASbGncviKqbi6fDv71XveGdjKhSITHt/bKy4TtOZRo8zjYH+lQEEF8t+armRuFeV9GZ
	r8BVDoil3ZNGLLL8hrxX2G3pHQ4zSuUBCSHr8OpJ6M4fINhrktcAAoKe8NxOb8lRa5N3caiM0Lh
	G5S1ldcpgHE/fGvSO5mykGAHKDudqoVU8pPvF7BaZG93rCoNXFfx5jJIume1kCk93xh9q9fgF0D
	yTG3UOgYBPPtF76npQvxrZLQeVSGTGyD7lVjO/QKAs0y4ISVlBIzYm2KIjyNrdoCj0xBxs4oiUl
	i8DaIfE7xa3BPrB06qhmRrnKw0XQTMFYKUTfjKGqRrSPgIUSCfD61Lbl+YBrSks/y6PwvwyTsFT
	SqB2WW/zVwDTyRji+luGyG7CpI/Uzr6dLJgSZRFSk0vkRAu4rOHPbbDbn3t4rmNPvWZOsCIOTW7
	HMVZM9i9jgzZ+wrw==
X-Google-Smtp-Source: AGHT+IHbn/J5Pj5jthdHC0UvAscyWuGSIeItHc3xuSaAqAb6w+jHqSJyHG/OBKZLtTuVuVxeIgZROw==
X-Received: by 2002:a05:690c:3693:b0:70d:f3f9:1898 with SMTP id 00721157ae682-719b4258e07mr46642237b3.35.1753282016453;
        Wed, 23 Jul 2025 07:46:56 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719532c7e4fsm30482117b3.72.2025.07.23.07.46.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 07:46:55 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	changyuanl@google.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com,
	ojeda@kernel.org,
	aliceryhl@google.com,
	masahiroy@kernel.org,
	akpm@linux-foundation.org,
	tj@kernel.org,
	yoann.congal@smile.fr,
	mmaurer@google.com,
	roman.gushchin@linux.dev,
	chenridong@huawei.com,
	axboe@kernel.dk,
	mark.rutland@arm.com,
	jannh@google.com,
	vincent.guittot@linaro.org,
	hannes@cmpxchg.org,
	dan.j.williams@intel.com,
	david@redhat.com,
	joel.granados@kernel.org,
	rostedt@goodmis.org,
	anna.schumaker@oracle.com,
	song@kernel.org,
	zhangguopeng@kylinos.cn,
	linux@weissschuh.net,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	gregkh@linuxfoundation.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rafael@kernel.org,
	dakr@kernel.org,
	bartosz.golaszewski@linaro.org,
	cw00.choi@samsung.com,
	myungjoo.ham@samsung.com,
	yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com,
	quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com,
	ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com,
	leon@kernel.org,
	lukas@wunner.de,
	bhelgaas@google.com,
	wagi@kernel.org,
	djeffery@redhat.com,
	stuart.w.hayes@gmail.com,
	ptyadav@amazon.de,
	lennart@poettering.net,
	brauner@kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	saeedm@nvidia.com,
	ajayachandra@nvidia.com,
	jgg@nvidia.com,
	parav@nvidia.com,
	leonro@nvidia.com,
	witu@nvidia.com
Subject: [PATCH v2 01/32] kho: init new_physxa->phys_bits to fix lockdep
Date: Wed, 23 Jul 2025 14:46:14 +0000
Message-ID: <20250723144649.1696299-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 78A5FC000D
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: uys5yzc46xwnyu4brxtqi8f1uhyek71w
X-HE-Tag: 1753282017-468039
X-HE-Meta: U2FsdGVkX18CjhbqA+SehGQ3szaEGE+OuzfiUI/koKNBeQSEYWkDQkQdB2COHWe5BBv7MFzRBtrr9G64blvPs4mF1rd+kWE7a4ARN4LqJKDimNleIr4BJ9hlfyNzsJeke/viXp0spIVlKQIr3O/u9SrN+uI6TK71+8RH7tI7tP8W1KIVdlLylDm7VsgZhrgxkM265TlO5dxSLFuG2SE6mVYEByJxurDQaY6IG7DlOeZFNx7jdlNYzpAj7QmwOSW20cZ5a1mlzVROAguzSlQlLORBeeWxXzQddIJ92OQaMad6cU4goPPvqLRit1KNuvzTzQE9CkpLC5u0m2AHXtXh8rmaVd76wQ2ZFyN0TTbwY7TkHzLhYtjV0rmyNh/Z+WSEHSzI18m556txrelr8fXuNUYA6KsSsr99uB1Ko8dGmYAlvLqs0pY7KS04tXnT7Gfjy3a1Ow/R8gc+hYtwbuZfJ00miUMfcpvp/5waV4ZIkZapfzZNPM7H/6mEMvj5TJ9zVqPqKSiAWEP5aZZocN5QGmuICnjy8v9vsWbJN2DvZ242EIljRlKOP0hUpl8Xy3EJGXaaFRsc38NFJkzdstPP8SN28KlfMr5jFL22H443p2RXEqSmb5MALrL8M4vqPVHfovgqZujUgoRVCLiK713SLagE7ykhKjtlBrSyhiGd25pSJGqqIMoIcaWVttK69UrZSpmTdBohy63wcAvmn08oqt+p/ikl4ETr/MmuXldKYdSMWuxW5gdX662sR1AV+p8xsYP2/NikmITvkH18ffV0rMK8XtMYl5b3ebZm22QPgWcw3Qh6/cTM7eHHC2upNqPY2o1fadLqHmRbtq2UWcznVzz8Udcxr+tpqxy9WidjOLLJD7TxA9f9XNLTvRf16TNua/jGSVJDN4nSX0Ct5QQhjR2+n2UswsYIs9RcdXb2S768SQ9BCPTISZIiv72uFRan5+UzOtTsiH1kIvPowdi
 g9/RHNBV
 HBg9sEJw731Xiuke013+1yZ0eIv5HbNa8bQhWcjFqjxwgF5LwuiyC+wjL0GPMMcZwuniYGsFTTbaFvKeb4fEw+I0mgFDsHAUKgsf17fzBZ0uZikus52CizG8RDnBUt+VpjSMBF34unagd7Agi8HtIjXjgdTur9nPUA5Z2vD2c4GtUX/TqWF453Kdw0N95+1JNwgYpjiYn26ttQhZXXSDkZRt6UwF3gzpXdw1K3QywOi5DnHntFhskjxc3fH9zzJOFC49PZn2aIpzC1oFWloYSojPXmaAuHPyKnFl7pBxGfL2+gfVRp2GVRcp819x95A/YF0b1hNR020KHdbTdezrDg0rI/iZOgtuT5fjAQp0jDoKCHopr8CRgfKZQY5/26n/KSU4e1gTvvRrzogqSOkJNzdgiM0Vx0w+4LXHWFyCgSoXMlOTwU3iZ7Bp13LuRfl9ayAg1x+p3YD7GfBonVOPK1iclQM4pqCrdSab2ChK3u219wl/FT/8t4QtSXrrITvNwa73aeL56sVYEDankVmGJQWJ90qW1acWuKxE1SFPUNmhRcSI1NtcZPaJDrMC7Av62vsfrNka5aGPQoAw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Lockdep shows the following warning:

INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.

[<ffffffff810133a6>] dump_stack_lvl+0x66/0xa0
[<ffffffff8136012c>] assign_lock_key+0x10c/0x120
[<ffffffff81358bb4>] register_lock_class+0xf4/0x2f0
[<ffffffff813597ff>] __lock_acquire+0x7f/0x2c40
[<ffffffff81360cb0>] ? __pfx_hlock_conflict+0x10/0x10
[<ffffffff811707be>] ? native_flush_tlb_global+0x8e/0xa0
[<ffffffff8117096e>] ? __flush_tlb_all+0x4e/0xa0
[<ffffffff81172fc2>] ? __kernel_map_pages+0x112/0x140
[<ffffffff813ec327>] ? xa_load_or_alloc+0x67/0xe0
[<ffffffff81359556>] lock_acquire+0xe6/0x280
[<ffffffff813ec327>] ? xa_load_or_alloc+0x67/0xe0
[<ffffffff8100b9e0>] _raw_spin_lock+0x30/0x40
[<ffffffff813ec327>] ? xa_load_or_alloc+0x67/0xe0
[<ffffffff813ec327>] xa_load_or_alloc+0x67/0xe0
[<ffffffff813eb4c0>] kho_preserve_folio+0x90/0x100
[<ffffffff813ebb7f>] __kho_finalize+0xcf/0x400
[<ffffffff813ebef4>] kho_finalize+0x34/0x70

This is becase xa has its own lock, that is not initialized in
xa_load_or_alloc.

Modifiy __kho_preserve_order(), to properly call
xa_init(&new_physxa->phys_bits);

Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/kexec_handover.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 5a21dbe17950..1ff6b242f98c 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -144,14 +144,35 @@ static int __kho_preserve_order(struct kho_mem_track *track, unsigned long pfn,
 				unsigned int order)
 {
 	struct kho_mem_phys_bits *bits;
-	struct kho_mem_phys *physxa;
+	struct kho_mem_phys *physxa, *new_physxa;
 	const unsigned long pfn_high = pfn >> order;
 
 	might_sleep();
 
-	physxa = xa_load_or_alloc(&track->orders, order, sizeof(*physxa));
-	if (IS_ERR(physxa))
-		return PTR_ERR(physxa);
+	physxa = xa_load(&track->orders, order);
+	if (!physxa) {
+		new_physxa = kzalloc(sizeof(*physxa), GFP_KERNEL);
+		if (!new_physxa)
+			return -ENOMEM;
+
+		xa_init(&new_physxa->phys_bits);
+		physxa = xa_cmpxchg(&track->orders, order, NULL, new_physxa,
+				    GFP_KERNEL);
+		if (xa_is_err(physxa)) {
+			int err_ret = xa_err(physxa);
+
+			xa_destroy(&new_physxa->phys_bits);
+			kfree(new_physxa);
+
+			return err_ret;
+		}
+		if (physxa) {
+			xa_destroy(&new_physxa->phys_bits);
+			kfree(new_physxa);
+		} else {
+			physxa = new_physxa;
+		}
+	}
 
 	bits = xa_load_or_alloc(&physxa->phys_bits, pfn_high / PRESERVE_BITS,
 				sizeof(*bits));
-- 
2.50.0.727.gbf7dc18ff4-goog


