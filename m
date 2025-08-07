Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4400FC87FDA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 01:44:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAF606B008C; Wed,  6 Aug 2025 21:44:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D88156B0092; Wed,  6 Aug 2025 21:44:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9CB66B0093; Wed,  6 Aug 2025 21:44:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC6246B008C
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:44:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 75BF5C01A3
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:44:51 +0000 (UTC)
X-FDA: 83748267582.12.EDFFBD6
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf21.hostedemail.com (Postfix) with ESMTP id A739F1C0006
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:44:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KJROmmM7;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754531089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QL9c1v+BMlgTEn5uRe69e/JcEH0iWS47GlDWai1cxXk=;
	b=ZKmgNvv30flNY9Oi/UHh9VtxqYCBU+lRMDudbFYxSPg4YaZR4ZLu5+hCw7sr8yxfcUDKyz
	FxCbDjA796telDvwDUe4zB0b2Sxr1nfOBLIm4Y5vNdB7bee6w4/RSu6kUQW1edAZu9p+EU
	DTcLOTS7wX1SHoLIJNNasLohF2JaaF8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754531089; a=rsa-sha256;
	cv=none;
	b=zW/7A1BWFWfaGHZMbx/bCa3g32nyakCII8TSACd/o5n9eWKTyhED8JzfC21lYIn9panz6q
	igj+iASFJHAtfwP9mwNvG4YVRDJlWt5S5XApTPGiox1OP3CG2PX1eyCHxCmdUS2Ec0AuBK
	uOB0y1MThNpKgkXbCjThzLLzq/AzFIY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KJROmmM7;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-6f8aa9e6ffdso6082396d6.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 18:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754531089; x=1755135889; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QL9c1v+BMlgTEn5uRe69e/JcEH0iWS47GlDWai1cxXk=;
        b=KJROmmM7JBb+rQ3BQ9YGgyrZxK97v4x9TcLy2DSaBtrlG8h4qJfUwJNPkKQx3TSUzX
         7JmNuUb0qe+EJ+js1vwS5l5JyrdxlkehhrQOMnqN9FEedh/1d6SOaefSi1JNNHiR89fD
         a7MS8Q/euzF/tLtwlvNed+yVwO8lmhT8xn66RKFbH0w4o3lnTmeTfMDbKMKUbteoV19z
         lj6sCL0V8cCMGNU+GbU993zsm7aiNKldlqOV+etTUYRZFWco66YBMhgQFZuVj3EIoG+Q
         jYmWnkBVCoa3qeUEBJC2iGVv42VKJgUoy6Id4JoT6SWTIGMyAAJSWJjUxe9PFD9ztXrw
         X8mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754531089; x=1755135889;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QL9c1v+BMlgTEn5uRe69e/JcEH0iWS47GlDWai1cxXk=;
        b=S0fDe8Yncv4NIvK+OOQqiqfJNMgGs+yEtH0qIvtzZ2LtCKGKdSCPksP1lA/xnOzYP3
         /A0qSLNjDIBnCj006KjDVz6qmA2XvX4bl9DUD/qG/lY/T+j/bouUTWcQgU5WhBBegzF7
         3WT/40GeOq5DycNfGyXGJxcNQOA3XUC6npcRJbtcavQiDITVVsXbiRU4u9isMFvT797V
         Z6YVlhSzsm29HHdFDFUs5uZwYKSa94jB2inEC1VqzX4v13hcL5rdS5uEhUwKC41GQDg0
         wcz25FpkRdrfMc8TkvRb9M8kY2/jrXuSATX0A5WAk+5bi+uH4Q+/JgJbF8zR8xyIGvw3
         9XTw==
X-Forwarded-Encrypted: i=1; AJvYcCViA6jyFWaecondK7srlezpBj3YB5bciGEdxteFaNuGIxnH5v7t+ByUwu1cbXPS0jA73xeyskJT1g==@kvack.org
X-Gm-Message-State: AOJu0YyDXtmh7M8bj5dqHnTGMvWtJ+Fon6uQiB5AYtSOz7Y2xZmClP4C
	lPdj+BKwm5DtBiX7HuYq2e2+3ygZb1pkqem3/y1uGrcPRA/kUTd9HHkVdl70nvenBtA=
X-Gm-Gg: ASbGnct6s5dbP5KaA0SAZtAHTzLI7JcLN++U8ASM3x5zoEouBlGiJADebZLuivqntTc
	sVwVM9JZW8wEhPbpWwXgPiqVKP0Z6ddfRxH879lskxSBOAo7Qy+DqZ0IsCqZ7Xkwv37aeMly2EX
	bIg4yVLWfm4q/CQTA/iHfNDRNB8CgXXb+7Fhe5LkmAHcu/aCxx3YUhEG8Qizr9gz5cEpRe7u+Y2
	8OPI7P8YpdQBMa3Mgz6LvwoIkuVdEK9OTJHOaTQmvuQoZ1lyWxVaZFPIst87hO+olDIaaYTiBSL
	GL0ruJflQgJcq5MVEDu8roeDdYreGmU/9CXjFZMc7Jl+zyRgl6YHjsJahRdSn3N1NVcZwXTvUi5
	xCnu1dRw1FpYsuWzgIgwiPnT6PsvLeh7n3l8j2NZvIgGqTwwpxLJrL912PzYWiBSZ/NUBJ6XI6H
	zGbJ5/9Q0wgH4vn6Cebqjwup0=
X-Google-Smtp-Source: AGHT+IHEETHVqmTbuWgs08Fwqn+h92i7koaC3q6+hGqOy8xHcPTrkyrnZKvlXSo9rTCs6WBaAbd2Hw==
X-Received: by 2002:ad4:4ee4:0:b0:709:76b4:5936 with SMTP id 6a1803df08f44-7098a898d5bmr22807336d6.55.1754531088556;
        Wed, 06 Aug 2025 18:44:48 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cde5a01sm92969046d6.70.2025.08.06.18.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 18:44:47 -0700 (PDT)
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
Subject: [PATCH v3 01/30] kho: init new_physxa->phys_bits to fix lockdep
Date: Thu,  7 Aug 2025 01:44:07 +0000
Message-ID: <20250807014442.3829950-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
In-Reply-To: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: txupk6jpwt591ukqqq1ira44tab6wzit
X-Rspamd-Queue-Id: A739F1C0006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754531089-70929
X-HE-Meta: U2FsdGVkX18fYY/rLH+05pq6HAMKj78yGECf9NjeX5T3kAKYAdgeoCkaNqixUYQH/1JiMeeTznOnWKVNCYEcMHfJm/vOv7Z4Z79uYf5jEFpd5moLAfK124djIVOys7AQgm8mzfcStT2SdKU8ogoxvTlsK5tqDqI3Ei3A+NH8SWgm2i8HWnynjNYakLqbNCwMNGE5vYKdmI1H5pvG9uhjvXpodutNryhymtgfPy9//G9PrvclRtn5TnbetMg0vurGIurTvpRF75Bnc5nG1YJacd5Jgm78l1DHxmrC0zObV/aNPLiwgAJ7hDFuLnfKQRyogcI51FElHn8qE5ErTyaaQdqHzFWkb1/cmUy7tls8ewmS6T2jdyadP1VA2C0SSNsizbugv6IEhsAVvEfxIPsiQ1bOAWfLocw1iVrWQ3uxMYh9Z0DadYGBAsXtPxXyrNPg19dXrSaZt7GEoka+wBY2Nqoy0/KT2c5i9/lMemhTvfv8nOd0FFRy9ycF6PHDIzATKI1xy9v9ScpYnxovmrGgp3e/aXFWRSlt2Qm86zpfphyvl5uCrtOz50BJ9SHl4bHV6voPtONHbd7Izpuo/AeXYf3bW/sPKbiMzFbqdrU1iSj/f0SCRHz8dpEmOirFoq6ONsqPLEGO8ZKTBvRtw+Oyabeicmb4UcmoSgdLm+cnjMo+AjqHwpeC/GGyoGNjgOkORNJiUkOfMYWdrI7LAar4ikPsmlcFAiFxPMSOS47gsU6eg1jDxmUT0U7kjfNOHVh298uEntXHgWeSM48OSU9sKWhAsu9UVt44abBeTGaIcaPEbuyOEkH7zM7VeYBvV/PeB7GDtvPbQVpR/wHEGntoMiFO+5TPQ7nxKjxb7AzBlMqtNCRH08p8tXXouJZqWa+VhHvZuNQmKrPHcdkxV6iDFGbzjqNZB0rs4vwoBxz5oz92xV5CFGBdFi8aOOK2yB24N3LuD6Tzj+6NMDS02jk
 cIZmpCj7
 VVNhbf2y8VFdvPZg/Re/5de1jeHbgnAcmM4jQzlz5wkPrcLA+fS2+MyencY918PkX+ZPtNfpdNhqL1qUmq+YSp473lw1AHjQzEo1qf/q8FUJDI8RZYIuXZd78yP1D8t3ShrkOjMb087SwOKukk4BY+bkWH6cqf5PsJ0k2lZ2XJAezUwJUzH4rM+Glrrap9sTAVNvf2lbBKwCj1aKLayEsi/hmLIxmRz4Zh8a1In0XuTIXMmJoWsR/rkyLlqIQSpKXT3rodaRdEueQFZ+TphqjTSAURVFPsv1dYC/QlqVW6gpRch+6R0hTlBSYGCppXnFAZ7pxcEsg5jf8FlQu5FhSS+8sQ97kJS2903bwBjRXc7Vd0rXnGUXREUfjUH7uM+mCmaTVPR85qeoms8OtHvQi89a8BCKns8gWLYOypIByUFZH/SC3l+jasifNwNNniIzwP1thfx5dBBVgpTLtSKUkmeHOKYoEglnjsOYFnjY5UE4aF/pz54pQSmQb7g==
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
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 kernel/kexec_handover.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index e49743ae52c5..6240bc38305b 100644
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
+			int err = xa_err(physxa);
+
+			xa_destroy(&new_physxa->phys_bits);
+			kfree(new_physxa);
+
+			return err;
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
2.50.1.565.gc32cd1483b-goog


