Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAFD9CAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 01:03:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEE928E000D; Sun, 28 Sep 2025 21:03:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2B248E0001; Sun, 28 Sep 2025 21:03:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 954868E000D; Sun, 28 Sep 2025 21:03:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 82D3C8E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 21:03:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 52838118DBF
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:03:41 +0000 (UTC)
X-FDA: 83940490242.30.3CF443F
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf27.hostedemail.com (Postfix) with ESMTP id 88F5B4000A
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:03:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ZCzubTPn;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759107819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=seHRxlr9qoYmGWxME4ah/Rh2okXUsVbz/ndLeC4LCP8=;
	b=3Jh+sAS/K08eVE9dVhzcX3/HikSj+LJchVOoMPX9t/+Wv0dnpGgwBnNR7o03f0c8uHgOsA
	uRM87OKdZrhzIPK33wupH2M2LUbXac4IdhJm2uDBIKJOVhRg22iT0sUjO1BfoXAiR9BnOY
	hUYEyreAJJJDD/xiDeX3rJ8Yp8kE1ho=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ZCzubTPn;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759107819; a=rsa-sha256;
	cv=none;
	b=fMfKbtcXbgwa3wfCwZYKXY7Lyw2jsyM4u+zKfAFMtBbySfCrOU7HglxEjLzRMDd9cCsHqx
	5xsg5lwEgDRlc8sYxS07wwj9meIBcKvXxIgTuVq9kmMSCPs/A/hI2ClF9yoYNW/pTy4afp
	/cQbgzWAB6mxOjoOhn8sZ7TQkjM8zIc=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4de2c59796aso21437341cf.1
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 18:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759107819; x=1759712619; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=seHRxlr9qoYmGWxME4ah/Rh2okXUsVbz/ndLeC4LCP8=;
        b=ZCzubTPnzON/jH2cLY3COPpbnBjWGFtnDYpPU9kGOZ69Jeo60PtzSsu36xiSE0jt2q
         HbpqhlQbmqD/wRjgV/l/yaQGt2ZFX5LmOqerBr0fhVWKnXmh04ze1EsdvWazcnN76j+2
         41H33M1EYaD2ZJkB15fM8HHOhXMdP+cbqMJvnZ+s8ZGBg6uBWx13rHh2xpEJUiH4b3Ku
         ATMMvBvrYiWO1kZqsQN9FAux30+U1HFcqbMsBrzHog65SmrgSxOU4a1HpBPtlg30l02B
         s86yR4p0BTjmfqkqiaAjJsqDsUJ3ynjaQCDQUHAc1Ghf7AoIyhME6hN/mEXoahAW6QPF
         HFYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759107819; x=1759712619;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=seHRxlr9qoYmGWxME4ah/Rh2okXUsVbz/ndLeC4LCP8=;
        b=ndkGC2/Pd/0aaoN00M3p5uXwr6dnJnXc1vjXpzv0NcaFS0XZ3l4HHMiML2fXQa5Zuf
         8d9uuPY5yvdc/krmXf63593vwcUPLrXqsSom5UDH2cNIDUR+0EpwnzeDeD5uUmpih1Fr
         zNaPENJ8y2kUQz1t82w6tFYAWAX4Q91vto6xu7ZjWBDDTYMedWLKBOOCtdpiOc/l+P9N
         EIWgaT6E/nFX9ei8QZKQ+1Cpy6RMnRH7Oj8a7BiFcyBLuPWJWi3rjocLfkhpy7Cqes61
         v+BuAb2OaYA8AxNiT3FJAUqlzewZHuwEMF+lc+OzRirld68LmAvsvcaO2sZUfLY19da2
         gw6w==
X-Forwarded-Encrypted: i=1; AJvYcCV/5QWrjVCKzRUS6PmAxit1oMvP4+iHIezRSlK4JvdoSpB1NwxyqVoCLKoJbg8i20yDKu/XXfEbBw==@kvack.org
X-Gm-Message-State: AOJu0YwKlg8mkbOgPSypiGr5a/cSxp6Qq9m4WFBFSLmXBQ/S6GrfG4aB
	vZ5xwZapg2twni6KSGzG5+91g88wZ6pDE+q5qaQZ28MntZFXQhp0HBEiUPpm0bAOhB4=
X-Gm-Gg: ASbGncuJOK7VxfbFqfxZcNNttd0WXI2rDqX0s4ez8s8SKQgqEMuRbp1U+HJQzBeJYrG
	JnoxACXFthDOuZJqG3drSeFyN3GssIF0a5LEZx2qcMlfndFhbsv9NbXAhT7B5FVWiei7qbFxZly
	ywE+dlRa79OdZqxtgWF6uV0yflE5L+XcO1ZLztbOjx/ldOLvyLwx/PtofMtTwio3LCazoE3Fasy
	w5TIIF38gY1BcrZKX9qCNwFTcXJ7UUr1uzchdJaGUBEKmPk6Rz6qI77zeo/LE3HN0UUk2FdUEVW
	lfgPrTPJAgLDYbJFHCphKrIJuh4L1hGgZUH8e7kXqhIGTciXTflD4BpLZIOXgJ50jDyQhMY1zQv
	U3Oq4W/MqdV7Gr9+PIUFAE1D2ASj8UxbttIlmRArIEdNssEb0/sGSE+CxIrU5/0k2NJB+AjaDed
	YgIt8MVqg=
X-Google-Smtp-Source: AGHT+IGWluQyWGzOMAK6ELVmstmCfELrwzvUE/VJRxrRrDSk2QQU4Sd30xTz+Cb2R/+uvVNJIiSTzA==
X-Received: by 2002:a05:622a:4012:b0:4b3:4f82:2b2a with SMTP id d75a77b69052e-4da4744e220mr214493921cf.4.1759107818629;
        Sun, 28 Sep 2025 18:03:38 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4db0c0fbe63sm64561521cf.23.2025.09.28.18.03.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Sep 2025 18:03:38 -0700 (PDT)
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
	witu@nvidia.com,
	hughd@google.com,
	skhawaja@google.com,
	chrisl@kernel.org,
	steven.sistare@oracle.com
Subject: [PATCH v4 05/30] kho: don't unpreserve memory during abort
Date: Mon, 29 Sep 2025 01:02:56 +0000
Message-ID: <20250929010321.3462457-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 88F5B4000A
X-Rspamd-Server: rspam05
X-Stat-Signature: k6q9hoxkfqcmk9fypxxpsm7ju87jg6rm
X-Rspam-User: 
X-HE-Tag: 1759107819-484004
X-HE-Meta: U2FsdGVkX18RsiXcoCCw0khST3RhBa3PF4KVzSHEp0U7FT8NWVlF3i6mlLiaSdFVY8lOD8KeVIK3us1dAauG5hpy/5GZKpOv8nq6yEtRZEUO6PBDe2512qvGbfhFX7ONV+Vy7xy4sPyXMdg5H8Pq4IFzS22jqlBXSdVbtoWsTmOOwBTPAAB+XPl4MtgZVl+kmxKokDk2UxX1l/XbYwgVb35bXU5auPteY0LP/jzuqkjYfOc9HC3x4c72aQ6za4F/FIF3d8FoHdm3WlU9sNpM/b8mKY97L2PChZ7MGvqHNc2uPuIWxjSMGQiTRYAEkRurikhCE7GsqP/XnVVPxTYaCxGBrCS1STKYz6vNpbYRHkRXIkHctvtyOzR0A4Zzoj/3LHvkzj5nV1vjqCZr199z3Wgn9sMQ4WtqTVM66RIknKX3Njk7iE49g54kUo2UG3UftfAfAmW+7YJEpDn1GfouvEdikXU3OkqQGrgj/zlnEJcIIzdmxkJ/DK1VS/4VelkkvUgPVQ5xc4I1NQfuNLqKY3a7XckRlRjRTKP9MqBk/RaomBIiQxRXjbWJmXsJgN1iQBhIciV8SQh+4KXy25d1TVX/XzPO5gqbrhjA3OaexhbULgYVJNRzTdqeQU7sBgPLdBrWaDOCOHYLbfWXnM8HRI4/aiMz97EegNLwVNdJBiditALpxy0rDGckFuEUVhSlK1CiwLFIIjYA3mrnzve0P20RWB+sgT9hIINiQUqOyb/1qRGZZyfnmUXqXlrEkWJWx7Kcr8vpbBBl7kTQy6IetpwxaOfVxzo9WKolpM/FRHbv42R6eSzLyE58I/ujEukZSJ1t5nAiGYErl4gG3qcDZ3SJKu8DAt/sqt0aC6fSYIZfVhVdEuH3sJcKGx9F6ncJWQ27l35ty3VGm/ZTqXwKHP6Z10sQR1F5BXtO+XP1aFzrWsU1SFeQjfRs5LgIwN69UPpPB2i6c/neOeqO9NA
 /03Koxq/
 sFEN8Obx7o6TZvDf5JSZTm8vY4f7+zhLTlVf498f5TcRgPDajecXOEDHc+82I1Q1tvj3q/OCzrfPoTpi+KLVfU1C7ncPq1pYUCijvex5gQprgHmCj4wuJbOIrBIgXlG4HhDCFGU06qi8L3zEVY5M4F9D0+Vk0f7XYdF11tHIxu9umB/f2MSEb78CBUm+ZPfWPiWyCml9Wxb3Sma5Y1VB/3GxQgdEqRRj5XmGTygedPzs7ZGH0FJJiKB4/tSuKgp63ecAsfKfX0qr6YrrTtvoFUnk1ZvvTARQUlYBbdKT3Am+JorolqupYHUzw2btpr456R9X30ttL7fYbJY/qBuK9Z5XBcVibDEYs3sPC6YSdjifLmVs=
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
index 26e035eb1314..61b31cfc75f2 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -1083,31 +1083,12 @@ EXPORT_SYMBOL_GPL(kho_restore_vmalloc);
 
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
2.51.0.536.g15c5d4f767-goog


