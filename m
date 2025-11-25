Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59AB8D0EE0E
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 16:59:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2767E6B002E; Tue, 25 Nov 2025 11:59:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 201F06B002F; Tue, 25 Nov 2025 11:59:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 005356B0030; Tue, 25 Nov 2025 11:59:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA35B6B002E
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:59:17 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A7AFDB80B8
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:59:17 +0000 (UTC)
X-FDA: 84149739954.09.7022550
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf23.hostedemail.com (Postfix) with ESMTP id C29BC140014
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:59:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=UnLV7NC1;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764089955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n2VZ/uSTE9rekrj+aF+jwkex/aSDTyF9XJpHnZs+90c=;
	b=E+vI4m6vHFrUXBcDoj+3QlBZ/nHdBT5CnTgkqTvGbRJgp8J/6nEkYyPtPH0aL84/oVAsGi
	FxKqECw1qSSMSbw6+MQ50qXHbrohFqWh4HuceeJT+DKOH60iSlQ7QO0RrKddi8HvuUHd73
	BUpwTuGL/DoiD+YeBGUUr4QzMH5RMGY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764089955; a=rsa-sha256;
	cv=none;
	b=Y/T20Z59lF1LF5twmP3uRkotCI2MN+y9CsliWkR4KfHy6Nox2qYdtV9Qvx1/rZ08cdHdEr
	RHMYuzsUbZ8FPLpEtN9nouRedwN9PMDEBRS3VyTTFwRAGb1u6EmfpkfIg1D4NQmSYfTB08
	sSdbGIuwmsS/qjglsHkKkUMqzP8bGCU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=UnLV7NC1;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-78a7af9fe4fso59832667b3.2
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764089955; x=1764694755; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n2VZ/uSTE9rekrj+aF+jwkex/aSDTyF9XJpHnZs+90c=;
        b=UnLV7NC1tFKrlUcRZO8YymLaj7Rf8rkfQTEPHIUNi1PRgxoGvg0i5sc5pn2mhgIhsv
         7oQ1K/Yil4EZ1k9frgOkYt07XVwfJe/J5X5oYy03VYRtKSNhTJSSX7H+6Dz0TvqCbb2f
         rl5HF7nhpCMtKfa08UXoZnfFhgFzIWfJI/g474b9VhnKZ+0nFc+dlg9Pwj5zhGplQamT
         qLYqjfekJK/VSWqcoBziyp7ED/EdY6pBulym9OJQqkLGCzHixClcOvPa0+qHDWNT3rJy
         bYn+jqXUxGJekoYu5Z4Bg6irA1tLLJbbGiRcyJAI+W7w6AL2+EHGdrB10tnjlOHaRJs5
         +OkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764089955; x=1764694755;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=n2VZ/uSTE9rekrj+aF+jwkex/aSDTyF9XJpHnZs+90c=;
        b=BtEFlmk1IG7exTcRXMzSqdelY80DdYUoHwEDfj8k1Xe5fToHb72WFI8K4/EVZPlMDt
         Z3KRQ4y92p+uw0xrzXmlKOjElXRKGM0V/V3cqN/A4HqV5KcjCqbCXP+uX8lRJVkD+DQL
         qXSlLiPkP/BIRvY4HB6L+QRo3R4o3HDzO1c295l9oAiXyVZXmIhHuC8VQkS9Y0SIZ7ej
         +eMRRMZpFKlg3OEwOlHNR8RnGekeb65dFt12BTnfiNvQItbPYIBjsz6RcO3cP3xSwbEX
         5E9FuX0WUZlWThncYmTZS6/PrMNPhwE5QXoJV/MCwGpRKcteFQKqd59ZsuuHnUnXIZim
         p3IQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvp7c67CET04wElioHAw7KwK0kv5PEa6JfQwDy48fwNqYGTzE4AcndrlK77xy0t9/jNzluXOI2Hw==@kvack.org
X-Gm-Message-State: AOJu0YxJ7cZfIjOMOZ0dM4qjDgvpW8v/k7D2sYRvIOo7Uls+JNyALFIn
	mwGwJ0uYkEjSCAi3OLcSrsGcMdMW7gNz9m6fpq4rnlokZr/XMD8hOEsxc0+KZ0NXK8k=
X-Gm-Gg: ASbGnctd+DS5CSdfKFien+mYSu8PrL42KQXTyQRrasP1DYowa0+bTvHpdUKC8gbU6W8
	XkAxvvebG4yklJL/oZuOd3+Z8u3bEv5Wi3JUnnoYXVpcSEd+GmUy1yNXtrsIdDB7Oasohs8s7RU
	wE8wCGC8qUK3qBqlDXIkLoSFx0CszhT64NaRDwq+t/m94o7lZThgfCeFJc/6px+S56DTfnT1EO6
	sCht1eKOc9lU+UUIkRb1ICjfQJrVlG28dQSKz11tf9fb3NQ8vZjSUDR0eJEhxZ/ZU2i+OOoxZD1
	fm9pT2BLiEz1sHtKBNm9OUzNns1zBoZpgFY8UDGyXX+cnTiVtQJ74gAqs26yrt3zMA8ut9KkB6v
	7Triel5bZ9b1uspXGIo5dBF6UHsGJ2VurS6XS6ADRUf2y4vkcY8BHdPgvZ/+KvcXVZMNUCoxi6H
	j+D4rC3VAwOZBUvX7khRXvwMMVix4RRF2/L1pA202UoqHpT+zMifQcXYfTTjA5+O73CovtKXQkb
	Z+4Hds=
X-Google-Smtp-Source: AGHT+IHp/uLRINC+2mEmiuoSxBmCL/SWIZK6CY7B3JageMUTar9wmfaPytTKzucTyEwNZIYxmxjOcA==
X-Received: by 2002:a05:690c:61c6:b0:786:4fd5:e5dc with SMTP id 00721157ae682-78a8b53925emr120116757b3.36.1764089954718;
        Tue, 25 Nov 2025 08:59:14 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a798a5518sm57284357b3.14.2025.11.25.08.59.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 08:59:14 -0800 (PST)
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
Subject: [PATCH v8 09/18] MAINTAINERS: add liveupdate entry
Date: Tue, 25 Nov 2025 11:58:39 -0500
Message-ID: <20251125165850.3389713-10-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.460.gd25c4c69ec-goog
In-Reply-To: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
References: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C29BC140014
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: nxzciudb68ng6de1co7s6imymy8hu4gt
X-HE-Tag: 1764089955-769563
X-HE-Meta: U2FsdGVkX1+NtP+clSH/l7u+hTvAYoX9PmZl1G+4hCrwfpQhBIq6VWuB9R07gntvWqJg0rgCvAkVdlSy8b19bMqaZtqyE1DuLlh1Ax0QgmYgz4Dcz0RXMsqjf2/JJhLQLjV85uWwlyaPEdesabj9J3STTbIkvKLg3xjpohAO96qvpaqIvcRNreTiZL2fB6BFWFPK1nnY5BSNrs6kucHoRt3joDpOlkAyxI8sgaWFjdwkmhSXn0YRq7h0E3m+37SZi7PkoStrJ1os3JJXuy/CgQXNmuZvCAAvLeBYrKfkzkvP1dZQR8b6G71dizahF094BVLcD9yFH/1KJ3NJauLiIOlEnTJnYGxYMJHbY+iSX3TlnVwgCfSyFduI2g0Uht9lR9U/EDE8k8WQKMjrsQMZP9VtQAhC4aYzMmDnG4nDcKuONo44Ws7o4/v/aLF6B0nWUrQI1FZAuzv3oXI7571tfKhEOzShSyCaUO+TgiI6K7QVp/970ND1dNTSxqlbhvszpHbOulxkc3+a4G5W4Imw7qLBZ+efIqOMYC3IXgp7+S6NeegnFoEbLjWyl+iiRTnALbookI27cXpd+HEXRmsJ+tpbMiPTTibIxgBXabbMKYY1Wk3wYTt7U2mqSMJsWl8dpzx+1wJuMMVWln5ttOUTWjSmrOlHTrjAyAhWmnC+ELsw5tYdo7cFlM0KklU/6XQMkRFNYKeXYW1dZGYDeQK73YOdO7haAA9MltihHydq+oTwGX9AUK2Oyu/lK/L9w2qttomS2lQDW1FRwGcgsLmO5po0M4W3SSHo8jUHbAvtFvVACXY7bTWxYPomw4yv46zLLROjUfaX8AqAuf2SXiyjkoLs2+yPBBHZhmhwVZDLBXTymtqj7eMwdJbMHJoP+BwOA2s0c79EXP8rkVRho5X1VC4PJC6+qRSZthNX7y+S2rkWfyrDd5I9erpPN9WzVs28BrELPYzze/pM28CnwVK
 dy7d/3IA
 LovNPJ8o5fBuzNrRZqKfQZ6FApJ51KzoNCuP8CNe+vaL9kqa49jQTC3FokvqCuFaETQ/3qppZQk7IGiGOjmA14k9Wb4tj0N9XssXAIhot3vUQZ4S2ev0mF/jaXl+IdmT3z2y6XjRQEu+3r031nhrwBlahCGkAcrVxJOzS17QQtV3YPsyft6NB2WOJyLPI0vE/vTfDrKqoLE+GjnvJICYdsgNyBJB0CqrzECv7aTGFGbPfNrPT5+smsrwGji+RNPJNZNPSxeoxFGHTdu35RiEt6SKGPSIAKrkKRgFbDsPxjI1LJt1MBMxFS6zQbzIrBRKFfsxLLHdVsG1TBuvlKyjribbMw7KavgDm/GoEaULcYxK6uA3+n8RIi8B0e0BVI4Cj0mOivgSUM6aRzaVNUAapzreB7HcSHIjl+rrTl6b04Q2yfO8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a MAINTAINERS file entry for the new Live Update Orchestrator
introduced in previous patches.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
---
 MAINTAINERS | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b46425e3b4d3..868d3d23fdea 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14466,6 +14466,18 @@ F:	kernel/module/livepatch.c
 F:	samples/livepatch/
 F:	tools/testing/selftests/livepatch/
 
+LIVE UPDATE
+M:	Pasha Tatashin <pasha.tatashin@soleen.com>
+M:	Mike Rapoport <rppt@kernel.org>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	Documentation/core-api/liveupdate.rst
+F:	Documentation/userspace-api/liveupdate.rst
+F:	include/linux/liveupdate.h
+F:	include/linux/liveupdate/
+F:	include/uapi/linux/liveupdate.h
+F:	kernel/liveupdate/
+
 LLC (802.2)
 L:	netdev@vger.kernel.org
 S:	Odd fixes
-- 
2.52.0.460.gd25c4c69ec-goog


