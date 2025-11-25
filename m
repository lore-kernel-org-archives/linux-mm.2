Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58290D0EE0E
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 16:59:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49B006B0022; Tue, 25 Nov 2025 11:59:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 421746B0023; Tue, 25 Nov 2025 11:59:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29C066B0024; Tue, 25 Nov 2025 11:59:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 198006B0022
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:59:05 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D09625841E
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:59:04 +0000 (UTC)
X-FDA: 84149739408.24.BA030C0
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0A1E11C000F
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:59:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VkoWhh7O;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764089943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XpaVBm1+//tbxkEQIq/GBWXpVmrV48zOyAjTKxFhzXo=;
	b=zKjp6Fv2nskv4a8OqRKIjyBiyL7xyAy/2/6t/PqJryqVuKkJknGyGMSbI6+thi5yGKPaj3
	dpXGlMBUndDQfcmAwjl1clQckT+2IqM6QDcT/aIwpFrGavAdVOo+yySZKAdcTHMmUHMbyA
	gEuT9LE8LafmhjOsT7EtFRlX6ROh+dc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764089943; a=rsa-sha256;
	cv=none;
	b=ouV719g3n++AeobVwP36qQcO5ILFpBrLtMUPb4GviXR3XKavOtl7nDAheVhKuHrFan1yHv
	1lGpWCnwjB25UcqerDDBaD6yL3JTnmxEHyvBL4qCNP9o8Z93cTNIJEb/fTm4hplXqT6q/V
	/aoy5lU8t6/a8aUNM+d8wJTPqDXT3Os=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VkoWhh7O;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-789524e6719so132247b3.1
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:59:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764089942; x=1764694742; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XpaVBm1+//tbxkEQIq/GBWXpVmrV48zOyAjTKxFhzXo=;
        b=VkoWhh7OcR3tOeDHxr2Etou5YTgaWrO2ac0R+7Tvw7q2laSNPekFjVwzfo4fUDy43n
         Br4EKVtDc4KICg8lUpNQVdlIF0+RLFHWpRh0aTJgUteVWBNF0fp/rLZ6TS0fEOS2k7D7
         4+dJ5U+GgYAdQAJ7Fup7bdl+BPWiKcu2vArmTJe8Amp0pGXn3s7iapdBY0aSEgv3BZU8
         mqejPVBnQ6IzWPpViUEZHVPS83KLPoFYmjttCXANft4hxVhdmn/51jWN+lwgtPR3rDUu
         S6KnmsegnZnDMsUOuMN9d0qnpf3UlzeYMz2R+Fjd5LYPawzicJL/GRzM0VK1IhWtCYFQ
         VzQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764089942; x=1764694742;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XpaVBm1+//tbxkEQIq/GBWXpVmrV48zOyAjTKxFhzXo=;
        b=WeLhb46V+v83v6BM/14xGXXo160I20ZAX7XmrmVoICR8r4UuYmveGjJSEXRh/YET01
         xSqppn4oASpOQwoHm/i78RDXZwFJV6Vyi7RPDeRkr5Cw2EvYMm87lNbDMFFNMi3Oi54a
         USpMObOnhj0mdK79q0fOazzoDh6epJvgm9glY89uxeCFsgSD8rXcYso/eZJvRt46YmKb
         OlMzPrFijY0Ye0CdJ0xLKBRj/D8hDcp513huet3ham3JI1c5iT0r7aw61s5xiG92825G
         7sFpZvd7HGqcb7akMS45GTAWXxQ+AIofluooBnlQIhcWwkDa/mWCjMn7gdmu0/MpEzue
         G54A==
X-Forwarded-Encrypted: i=1; AJvYcCVFX1apz5oFqz016GwEMm51ZQCu2UV/NmNZ/3+v0XAftJghoCnkZ3Q56m9X8YrX9NVK50Y6nzf1Tg==@kvack.org
X-Gm-Message-State: AOJu0Yzjsl6EROh0qK8hqwknIuShPFvJGdVD62J89T5GEputLRjVkCs5
	BLdsJbUBksCeBsJn9JSY4Q+TgRQBOzvgJUCS/U0qPq/F7BE2/0WCK9gmliH6GQTG16A=
X-Gm-Gg: ASbGnctSfRH2Z8iiiJGQNYYtTxe2+2xp0tad8aZq1/HayxlUVe02q/QY8WroHazkz2+
	j0lPTzzUJhWBD0HSKFbM7Ok3RuaYddXz9X4XZv0pIo0+anX3vfSU4ULjYFGeqUuDXb2Ffp/CtbJ
	8H3ld2FEvELVKEu1T/KPtdg8UvnFfCd4TqEgS+bXjl84ozTncJEOO9LKZBeBvsDNr4bobkcRN2b
	Fw7+t2jF3Vb5WpC+BteoCgYRuecHjxJz1pRVf5RZOQkyYD3MQ1fPZV7ZPJx+Ul/UARcgJ4DdYkS
	9RLaW2TpPXyIhNoIavNcpjYjM4sPaAgR0BB2avcxMiDVKcrrejmgLdXbb27rpsuSQLdmKmC6lDn
	SrFAK2mZQ+J4ZSLecrJBDBD3VUljZ/0MBVvcJ2m5Xd2P+525N+9mM22s0l5DG7EN66ddVDTzHEi
	no9PBAcWKsrt/j8ADvjDzxCkn+h5JTKrdWJn5IkEZ6xp5kjIrs0BGaFc5FeJpAgnxu
X-Google-Smtp-Source: AGHT+IGT9/1MeLVmxLppNhw6ATfBnky7RFeGJGgEupGtHFRdbpi4HufaHsrUZln7Z2M/tCwpjqT1eg==
X-Received: by 2002:a05:690e:c41:b0:640:db57:8d93 with SMTP id 956f58d0204a3-642f8dee6bemr14317878d50.15.1764089942010;
        Tue, 25 Nov 2025 08:59:02 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a798a5518sm57284357b3.14.2025.11.25.08.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 08:59:01 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
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
	chrisl@kernel.org
Subject: [PATCH v8 03/18] kexec: call liveupdate_reboot() before kexec
Date: Tue, 25 Nov 2025 11:58:33 -0500
Message-ID: <20251125165850.3389713-4-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.460.gd25c4c69ec-goog
In-Reply-To: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
References: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0A1E11C000F
X-Stat-Signature: wye3c35um6qit6dj1qht7qwisf8ikua7
X-HE-Tag: 1764089942-466619
X-HE-Meta: U2FsdGVkX1+yZ5nT9wGpWovJiprMraG1FN9QrApTJtdV7y4q9guArrYnFlHCoOumYcZpMFu2BAweFfWjkH5MItFeklcVWgMkZQAQuJjfXBVZtWyNlnyG05wkbVddyNb8v5L2Qt8/Np1DLeAKLm32U6Uon6C9JgRhStbZ1NJwMmVUqT2WaQBRtOPNRmGKr/y8dqvejeoFqmErrGuDvMMzckFnEQ3RrusVlFYMGpN/Kyod2rfczAvqtMRuUUuq9AXJ0Fbcm5FAOtfSoGwahMtUsgNzw6qrJmt2rTTLxn2r4qE2YRwK48ykTNSxbgH93MGdcMmNy2R14PxO7rwBczLbCnDoIan6DPd+AV1ot66jxP6iVOLXGH/mU9poBjtFGF9zDFnCBaE92QbPK7mIJf1lX2N4TVbrl5nrX9w00hEPr2JlvFD57UXWEUmBGANpHd/274vj+QWz2ZdfMhSVSpXq5JAy9AXfTAhiGwgnK2/sO1l8TI7WlDGNxxdPonMrR6gDYbYQyeTXQ4BTj17QIkvNmGXYy3mMN1LPq1cJj8wP0QorlyMg6O1ivNfoVf8z2ATt1mew+uTpVWONnXNRFyw7Y4FcfxbXLONAadXYENMbAPq6uwxbI15J1heOIoRezKM69ocNXky5jQvdRCUY3zLlfgnqMvOy9i8MEcW8+4RsZutHj7lW6ldjxyGYiphYsZhtS1qKGEjGEwAJa3gCFJCTNPd/cSlwJC4ivf/lwrFyo/7L6Sn0l7uAiTiKMsFtVHFxdzyukHhx06yWdba+UdKvnhXLQe7rieYbtxk5x4xO2k8MnnAUhAvpq/kKuJHdkk4YwxwKgiWDBhTssybBYUrJqyc3kxVzgWlvr1ffBVMbom30lZe9ZBxfXLz6PADZ74btH8Wx5WTLzA+Z2qsaOKfwvnkMmQVyDYJNmpczLNZUC7JJauZ81kPY0htk+32uUjPXhllPICeApF4xzJYqOUU
 uWiH72gB
 1YMsH47jEAtXbKeWskwRN26vsB2u/3dknO8+qZnDsnyuSJHZrKzavpm4gXV/vGwiuDs9LPP1qVnVbUCsU1tkzlCRJs4gVlmmszHK1Sp+6XqWlyVbKH3oKgEx0flNqofUWEG8MKbtzlmaMmUQBS0cjL2a7/iYZqQrMP6DuyZqsDWC9nMfs7vFrpzDE0mXH5cIXI6uJDsPQLJyN4pUUUDlaV5ANbfLEKaw2hMdcyo9DoDAhdcgd46OY+eYQzetet68t1G73fUXYrmxmoy2SvvahGdISet0zav10wCiUgjtg6O0zQEcJSDqClYhE+CrkipJURRLwMQp2E+hdLs+D0idSehVQkYtCoEWN/CF7rUIOwGjFVvLxrp6g6j/q8L1ci0kunsuVJjyYXUrdLUaTqGYoqj7EPNX4zO8z2rWKrVkrC84Mvqa1g6o2wLHM3Bq9k/FhHlyUDHTH+FtGFzDMK0uZ77VpunhxyL629rKC5tDKp31TYuTAJPmOhK33jw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Modify the kernel_kexec() to call liveupdate_reboot().

This ensures that the Live Update Orchestrator is notified just
before the kernel executes the kexec jump. The liveupdate_reboot()
function triggers the final freeze event, allowing participating
FDs perform last-minute check or state saving within the blackout
window.

If liveupdate_reboot() returns an error (indicating a failure during
LUO finalization), the kexec operation is aborted to prevent proceeding
with an inconsistent state. An error is returned to user.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
---
 kernel/kexec_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index a8890dd03a1d..3122235c225b 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -15,6 +15,7 @@
 #include <linux/kexec.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
+#include <linux/liveupdate.h>
 #include <linux/highmem.h>
 #include <linux/syscalls.h>
 #include <linux/reboot.h>
@@ -1145,6 +1146,10 @@ int kernel_kexec(void)
 		goto Unlock;
 	}
 
+	error = liveupdate_reboot();
+	if (error)
+		goto Unlock;
+
 #ifdef CONFIG_KEXEC_JUMP
 	if (kexec_image->preserve_context) {
 		/*
-- 
2.52.0.460.gd25c4c69ec-goog


