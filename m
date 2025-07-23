Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70588C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:47:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF45A6B00FD; Wed, 23 Jul 2025 10:47:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA55E6B00FE; Wed, 23 Jul 2025 10:47:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C45E36B00FF; Wed, 23 Jul 2025 10:47:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B0C1B6B00FD
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:13 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 86BA88075B
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:13 +0000 (UTC)
X-FDA: 83695807146.04.B121BE0
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	by imf30.hostedemail.com (Postfix) with ESMTP id C07088000D
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=XnHADMOS;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753282031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hrgbtdA3RdwzYLcpgmSOZtyyO0wlzXdBbkaeyV0ZrEA=;
	b=C3MnRrAIGPGDwzDtVSOjP+h1YDTYGvuMQ+dr35Mr4azjQt1FD9nujCFKQ5kt/kUaw+KwWp
	v51SWC7u2H1fUu7JqM/MUa7GAqd6qlUdhzTsZktnAsgAw3gW3JLB3I894KfVrHmJKIM9cj
	d8GHnpstFW3YRNixzB/wMtKFBhgN3GQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=XnHADMOS;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753282031; a=rsa-sha256;
	cv=none;
	b=Z43DO6whwYkIdnVJjhyrJKVMHAVCCZy/utMacdSoQN6aq1yyQJ70vWpBYtrpEq/X91dzha
	b2A/EDFefLyBRUN+W+i7VbcYP80sLldkBeI3lGnuvozEFWj6ZkFGgtLJZHujCzkgbNNNpu
	sxWuJsUUjsc7qUorh3tqpD1eS+h5HBA=
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-e8d713e64c5so6321992276.0
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1753282031; x=1753886831; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hrgbtdA3RdwzYLcpgmSOZtyyO0wlzXdBbkaeyV0ZrEA=;
        b=XnHADMOS5aPZsnT+0pv0s2VPeFTkvYXKwZmxAzVvBtTlUQWNEo3iRW7XkSKrYS8Qqf
         +rYPfXCS3UNUuibpTQVt7b39jZRUYkQfxnMKJEY7uYs9Wzxi0ghBF8yHI/elW7lf8KzK
         E3+Umnchqy+cTbWqSLAujH7o1bxnPFqZETDo8AZgQs0V4xI83wV2mu+rk3oO6l1TUTOP
         ak8gV1gJ6/uP3/JG8qRzg+90cjBpd0v5Q1+6O3nRMlgi9VRkLIWNp7OAjSHhISri1uTf
         gmDpoxIgmJv36U/jiydR0q0VaU89RWMGrr+ilC6IukczcFA9IONRoIarmrWEavlQIkL8
         S6QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753282031; x=1753886831;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hrgbtdA3RdwzYLcpgmSOZtyyO0wlzXdBbkaeyV0ZrEA=;
        b=aj0LTWoveoQ/xPulXPohF1Om4Bn2AFlD3VyobAISdgha10QYsaKU1JmVqFgwxd9IdC
         dXna5sLW5wThUNg2Fl2R4UvgGbb4vyZZV4S7iPrno63IWLDenDpq64VlQAjA1XzX1GiE
         If2qOOdfym5y42j1tCGjIzYZGEVU6aWPUuMt8YADwmFn+XWevJbZXkHoLBQjM3h8p+Lg
         SdILpJrXZLVuHrmMLQYlGuvBZjRgZZNQlY3xS7Ixj8eBFKSGkSo6m9Qz++MbMVVfo5fY
         6AyA4ugHGnQ4U1REUm2jD5vDP3T4J0XEBZMjLpMlAtnuyUhJ6+SysG6xs0fQzmjCt3nz
         xq9g==
X-Forwarded-Encrypted: i=1; AJvYcCXvsSGoAvuIJKcoxR0A2JA0NpDo/8/OKXRziJHqgZVeh5hW5lwpJYCJWc5dG2V2yETCjtlJIc7+NQ==@kvack.org
X-Gm-Message-State: AOJu0YwNUS2tyjkQNkzh3BuJcau+V3Z5rJI/IQcye94U6CVqM6VygJF3
	Bza2RvbnizFUGixLK5sVA011LjxdRn3pLnUboC91tEwZTV8aNu6/ls24R4+04SNEkb4=
X-Gm-Gg: ASbGncs1YR1iV+hed80CtYpNfMuMzRC5kL8cn/6d7/gUw+Mk7KSSoOyX802CPR0ixUV
	qz+MtsXancRP9k84VuJOp9HdZ0kaG9HA9LuC/GEkVszWJOWdP1olxPLvy4lpV8K/FPeMYooPJ6D
	Y6WtFF0tnGps+9L1SuEGCvYMyfe2ctPSH57/IUwOv25LWygC+XSX8M61/GzBr++Ic5My/C98KBl
	RzmP3FDZyI+AInUEdrslTRWFiOI3Hqz9QQnfzDcAjsrx2n173O4ElKfW6inM1mqJ8ECBdsjL5gg
	bMiw++Bo9coeKE4sfJ9EQclJfxFmHqmHeve3BRW+WleI7nn/USVY6gbITbird51h+BTNZZu0/bq
	le+M7UuadF/Vg2SF2DdiORpdikjd+TN5jwS5gsX/WPYgn+tAAlCFe346k1x593YXw24iCdXFZ5u
	/TFksHVgvBqUT7wQ==
X-Google-Smtp-Source: AGHT+IEtHo37LGPot/hXX3d5/RxjiZTetvWjVt3dWuTs4pORFq/5bZ2tCgRCgkPbneoKEGKAmSRK9g==
X-Received: by 2002:a05:690c:f8e:b0:718:3b9f:f1f0 with SMTP id 00721157ae682-719b42e0146mr44064387b3.26.1753282030545;
        Wed, 23 Jul 2025 07:47:10 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719532c7e4fsm30482117b3.72.2025.07.23.07.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 07:47:09 -0700 (PDT)
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
Subject: [PATCH v2 08/32] kho: don't unpreserve memory during abort
Date: Wed, 23 Jul 2025 14:46:21 +0000
Message-ID: <20250723144649.1696299-9-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C07088000D
X-Rspamd-Server: rspam06
X-Stat-Signature: 51kttimuqzmz8fy6gi7h4ef3pfcozq58
X-HE-Tag: 1753282031-382728
X-HE-Meta: U2FsdGVkX1/AyP5Q+jcKsT26OS9bQO2NNMygJ1IVFpoywpkbWR545gPSk6CxNSHkeXK4YnFF1v+3G2BA97hAmHs3rYBd86boVoYYBZCAmKgQMJ85CQ3RwIuNzXHbwaVfES52/QM5fNfCTjM5VJm9qpX1w7lr4INVy0ADw4QQTYKho1QYvsBHs0OH3MgnEeZbmS9AXD79Tw5QI4anwTK40ySojMzVFjpnwdYPAarZOqWABNcB+/YXfQfMZHAeEwAwlqWBaRboVPI3rRmts8vWtcSgcR+escr0nmuBghuoRwjNqdilJRUEo47SDtu/JHoM9P90edx/9qbv0rMpOynH4KeVfh4kxGe4BhS+GIC8ESIgS21n+Ui/i7AtJRXTURR/DtuJCfI0uprE5WiVwKjAwbtEZi42GvqdR2TS32qXnLSHBoQfcZVUNERQnPvlrlPwGYt+9ISSH55f83mq2ZSfT5iAw2nPSRh0olcijqPWmcx9O0PuJixiq+beGnBIP2ABsFVKxsXOXl8JbGEEo8arnE2LLIbPbDXTGoyHR/TNJbdcMFvTAFuIFhdiz1F9bK8vmAnn6lXDlATtKFdZD+oCEAYNyApGWWN49k8/rfedKfNy0aKgYxFIwyIufcok0MPJVcFHVqPOVOGNoQwNxJImpx0pAmr7IJrlHw1XNrZLpx8AsiYwpVd2nT7ouRX4fSl4+rxQAqOko73pRPSdSF+9F9H4yrduO1vl1u91sEZgSbfW5FkovR9jA9luQbD5de+yB7Mqlzaa4Zu5txQT7mUe1dNP0thUsjEJU+dEiQixI9Sk6USBZi2Ab8tvnO6OhbJXoNCiGWHewdffyP7lm4Fla56qtPQECNS0gqHYuKx/dORBsg9TU9agBOSEMGDeLFfvL2GadS16tmV0yKhZ8DPbMchVZhpgSzak7OL/OT2aaRFHeuWFjlYVxOgfdfuD3swl4XxUbn8hV+VQGdwS+zK
 3X6Nqa8j
 XY4qh9I2z6OldDtWnRP46nIMQBGuQRMO0viqqy1vXVxRy0tWdZM6xmv4NFskZWUCRUsNa+DYGjJWnlkYpeH4tC+u0lbMBVDXbZYzcdMq7flZwrHP2p8Ad8Cz9Dj4F+isHI+xLdiCw87l9nsSnB7G0DvxaFL6U6tUAQBYH/mUAOtIAoT6AY9bkp28ebW9OHWCjV8GZXBsk5pyYCD5RuX3qQLBQhAEvYch3pk3gIKjed1NktHMCgIqJGbUpcTAJtHdRpnLcrMg85SUVkSMuXcmyFQ8xKc08sVMZvqO93BhEskVU6KAHPwgORm/upg+8zvmYEyQkVdzfMkYrKXJNC/UVKTX/pOISQ/bWvfNrbaKjLDtjEli4ALvFCFGUWFgzt1a1iicnW+9H7UWp74TN4XbUUDq5iOiZdi6/Wsr6kU7Sh+EzpqCizz5JJkC6I04R5+aFp9sRH8eRnRqznYC7KLrbU1Vj2yHT+scdSCcckCpmnXpz+DqZ+xjtMHTyJg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KHO allows clients to preserve memory regions at any point before the
KHO state is finalized. The finalization process itself involves KHO
performing its own actions, such as serializing the overall
preserved memory map.

If this finalization process is aborted, the current implementation
destroys KHO's internal memory tracking structures
(`kho_out.ser.track.orders`). This behavior effectively unpreserves
all memory from KHO's perspective, regardless of whether those
preservations were made by clients before the finalization attempt
or by KHO itself during finalization.

This premature unpreservation is incorrect. An abort of the
finalization process should only undo actions taken by KHO as part of
that specific finalization attempt. Individual memory regions
preserved by clients prior to finalization should remain preserved,
as their lifecycle is managed by the clients themselves. These
clients might still need to call kho_unpreserve_folio() or
kho_unpreserve_phys() based on their own logic, even after a KHO
finalization attempt is aborted.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/kexec_handover.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 26ad926912a7..7908886170f0 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -778,31 +778,12 @@ EXPORT_SYMBOL_GPL(kho_unpreserve_phys);
 
 static int __kho_abort(void)
 {
-	int err = 0;
-	unsigned long order;
-	struct kho_mem_phys *physxa;
-
-	xa_for_each(&kho_out.track.orders, order, physxa) {
-		struct kho_mem_phys_bits *bits;
-		unsigned long phys;
-
-		xa_for_each(&physxa->phys_bits, phys, bits)
-			kfree(bits);
-
-		xa_destroy(&physxa->phys_bits);
-		kfree(physxa);
-	}
-	xa_destroy(&kho_out.track.orders);
-
 	if (kho_out.preserved_mem_map) {
 		kho_mem_ser_free(kho_out.preserved_mem_map);
 		kho_out.preserved_mem_map = NULL;
 	}
 
-	if (err)
-		pr_err("Failed to abort KHO finalization: %d\n", err);
-
-	return err;
+	return 0;
 }
 
 int kho_abort(void)
-- 
2.50.0.727.gbf7dc18ff4-goog


