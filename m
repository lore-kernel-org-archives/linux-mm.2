Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C13D1CA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 09:19:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B856A8E0028; Mon,  1 Sep 2025 05:19:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5C3B8E0002; Mon,  1 Sep 2025 05:19:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A51168E0028; Mon,  1 Sep 2025 05:19:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 936AE8E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 05:19:40 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 517F5C0707
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:19:40 +0000 (UTC)
X-FDA: 83840133720.07.6631BA2
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf28.hostedemail.com (Postfix) with ESMTP id 79670C0004
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:19:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b="ijRTvK/O";
	spf=pass (imf28.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756718378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K3Upj2m2g1j8fphq8NY5txcaBLQgQOVfeQ4k3TdopfU=;
	b=HaJ0NFRDtvvF1LrIwDvRVI3kzq2Z7QInJutGLsHQwjMPLKT+bihHcCgAW0s/v7mMuZg35V
	Lrmm7cuQuDykPZbkmOr1TJkYjFJaiHOGN2p4sX9YgO3qYjOE69Q0c95qTKW2ujinMIe/L7
	dZZrCgadjnksWmau2zP44XpZXfkmv5Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756718378; a=rsa-sha256;
	cv=none;
	b=G3NY2qZ36zQKRN9poWe+mAYS5dwzZzODKVYN5sILTjzuRetKjeXfhbfNKlNlF9ibxjo3tE
	2syBiSGlORwIjPA5hjfQR00ApWThUSfu2nCXE27dmSr5p9ZJpxbSLL4JyYThIZ/LGx217u
	3QwrBFLq9FBsD4vnGTKb0OCQzMkrFW0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b="ijRTvK/O";
	spf=pass (imf28.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b042eb09948so112265366b.3
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 02:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756718377; x=1757323177; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K3Upj2m2g1j8fphq8NY5txcaBLQgQOVfeQ4k3TdopfU=;
        b=ijRTvK/Oh7HXuwT3lIYcOdUgD8A2HLDYUygFiormmLc/kWtTI97dvTeKkwJG1gRUMQ
         LQHo0gx/0D9sQROyhrJay4jsic1sHWMhdy1IPJ4pca4iHjENxpbUcuJAXpbuh9H9xgmb
         xjh+lg9XJ0ULigMpwFRcyN/P6ZOx0CX88BnpAuIahZexHTLWQ5Jg9Sri0V/2pb9qFVKQ
         vLXdLOlTV5PrAxNf+DW/vX2wRVR8N4eCy5lUF7vbpSjpBMIngFMd0gYEqNObE2CY7JCZ
         If0u7u+aa7xzmiqgVeZbWUYSovZYDjfEMk/9qWC9tIzTBY/Ei+9xjgw/z8W6M9a+IYcW
         ctUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756718377; x=1757323177;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K3Upj2m2g1j8fphq8NY5txcaBLQgQOVfeQ4k3TdopfU=;
        b=onhQF92NJSYYARE8fNusDZQXWCiep8rjQXhn0OCj3PN+PW9gt0wKRIK5DbwKBiHU5H
         QJKxGJs1VTp1be/g4xPe1bB+7dvZE4aWBFzp4z/DqAJWGNXeRVXr0g/0BwstIaEhBH/Y
         NzviJSRjglRoGCLOOu5sjtnGuk432YpyhMaziti94XmYLYwL0/x7llmsP9nBV9o11gnS
         iCLDEhkWYr+XjPh+Xo4zM9gDq2nBQop0fAmFjNHcczJ7V+TA3anAe4Ky4i0hw6Dx+ZcS
         yuJtDEsJwWzW/IneOCufonSCD1OMWMYeYVBGiG8dNKhwqUemQrkFHa3/EOxLn1zTIv7g
         9yWw==
X-Forwarded-Encrypted: i=1; AJvYcCUnB2Ac0hGod8xv6ZHhXa7Zg1akgnn9vUy1Va7Yfynpjvua7WDa0GiWvcEsP0aIgOtAN2dcxiw/YQ==@kvack.org
X-Gm-Message-State: AOJu0YzTqkp6neKrc8kVMJlAqInafg6srMGg6xmZigMm6jgMp/mQrqiI
	Aj9mfenFqZygsg7TLbai9MbWVALHYh5YAhnuy5lc8OdX5TBA3eQcPoGHfCmdQ+aEqoY=
X-Gm-Gg: ASbGnctLWEjGxiDUIe2ClVjm8iwbWNeDUTQ5eQA3qg+GvmshdAO2WJLMv0UPryi51J8
	hgXXCrMEhbuwA5sVmeUcb1blGvq6/y+qZevvOM/8M05sS8+w32xrymgxXyDDCB99XXuJbl1ENu7
	THHI7AcUr+o+0K4X7WhqKhGiSpvP9KsY28IpjvbWqWXyxCUMRMKVvntBvO+vLM0Ady8GzQahhaP
	8vOvzC2C2forvjcts2ZszwrWphPAbyUIdyWxK2J29UiVCSxloOFTSRPeVq06vsYLYqZJ4BAgShr
	mcDOhFOdmcVaNAkFWv3FhKRbPwni5Ueo004G8p43ZewlyBnmMlHZ57Bxs+XhGJcMnXYPT7YnMYe
	5gslhFXH90iPpx1URw3hOQP9RDYeebnAlTMD/rBFNQSSOY6poiDKWShDG/hShI4SKAWP7vUotS8
	rRYIlv7C/K0+3KWX+Us8p74uDVXHnszbqu
X-Google-Smtp-Source: AGHT+IHU03tJneIRXPXjJBcv8U2Bz02uUMfdpAyBKwgR6+o6K1xVYVpx/SIyHdw8wkNyrhH8/CTQOg==
X-Received: by 2002:a17:906:9f8e:b0:afe:c6a0:d116 with SMTP id a640c23a62f3a-b01d8a6b6ffmr681548166b.18.1756718376821;
        Mon, 01 Sep 2025 02:19:36 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b01902d0e99sm541005766b.12.2025.09.01.02.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 02:19:36 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	willy@infradead.org,
	hughd@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	vishal.moola@gmail.com,
	linux@armlinux.org.uk,
	James.Bottomley@HansenPartnership.com,
	deller@gmx.de,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	davem@davemloft.net,
	andreas@gaisler.com,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	chris@zankel.net,
	jcmvbkbc@gmail.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	max.kellermann@ionos.com,
	thuth@redhat.com,
	broonie@kernel.org,
	osalvador@suse.de,
	jfalempe@redhat.com,
	mpe@ellerman.id.au,
	nysal@linux.ibm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v4 07/12] parisc: add `const` to mmap_upper_limit() parameter
Date: Mon,  1 Sep 2025 11:19:10 +0200
Message-ID: <20250901091916.3002082-8-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901091916.3002082-1-max.kellermann@ionos.com>
References: <20250901091916.3002082-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 79670C0004
X-Stat-Signature: ursyrw6xgto6qzq7wxmiiuaatage5t9n
X-Rspam-User: 
X-HE-Tag: 1756718378-492150
X-HE-Meta: U2FsdGVkX1/eGmznPAE9wOr7Kyx9Dqkg75WA6wZ+1IeRcOFDLV2Hn0QwBoPOB6aREnQyDaUIjYWzjp9yKizW7IlDutNKqFnXub9cU3wnk46D0pVl0at+ZytwtjYnPTwUbfpiarzPDkkeLKE/zoOgmxtrlwhr/5yBijKp2cD+lcaZW9+jSmFn1b9XgQoNUtWfwWvgAURvO29sTBDTPY5hgO/jKeDSx4x6S356tVR0h8FwOmnxcBDtu6EU+gjDJ5Snv44Vn9emK31vfxe97zkDjkkzOvSmcZus1hkOibBg3xm7/b3iQIpj22zpSphqxTL9oplYabZTo2eZcDkTufIsbLf6j9eisMSSfcN2iteoeclDYOtuxECI7Hv3vCFKx5XFSiHeMxsikct4ndtjLwR228tDN7iI4gVJujOWw/3eEaKJuYbivbS/iHxD+yIMADTt9CZkPVTPnej8WSlQDrjf9uupjDqX3p74xZUGd4O5jnoZLQI07NrKKuLO0lOKENG0XMF4afKenIoZQAAqWQl1TBl6+ox7syQgL8g5hjnLJJ4jvYRGf6p9odfqjeOVjGH5teSdIiEFBLdP8EMaiNBB9Ohawd1p8UaZMxihGJDJDGskup4egmlSyzYITbl1pxbCg5Gt1CCPV7AYw2Jn5qQ4lrFaQZlRxo6+wVS/0sbIu32DYu4ztihaHSNkUoLjgaqgxSl9LkXIbbO0zmnqXTo1D/9PLpvGkEv9NEszbpZbk57AFvN9I651iLO8rdSEwv+kUrdDF32S6D/Z4HMdPNjuOKFFGUQMTu+kxuy5SwuTrB/2W4Jxun982vj+DBgYUcnx2kOgF3q3cOa+avlSG5gqqrM954khxx+iSHrMx1SCCDYMnkqf+dJIEo3c1GFYfxfU4lpjsQjwZ5aiO8omwNFaHTbRczEfcNcjUDxgnkimVyysguxS+hQJsFNT/NyFj//djIvdFudbhXu/qBjs+Gd
 TL6UkB5I
 ZsD59uVmyw4ALRGkEs3NRYWUe+wQKCIGw+CLEuv/9kWb6GtVSbq/5z967jIW4DC8GLoyP5Mf8/FLCoRUumUrP3YiSZo5Iep6GLjn+YVBHAFFDkqpD1SrQy74St11IIR0Nl0r36gWkd6WM1Qgpmy+Th3PoEQpBIZ+YlBpYZgcxghMmKOoQ0plz8YbaeWJYAUIrhQxERAw+EleSxV9Yw3NTaQFLM3rdLsls1ddKVVWHDIaShj5QAqsWaWDqKl9BvwCiC0YARZBFY/NhCK+Zl0qCdDOQjXuw1fq0PbyPftES/r2udwlLMppUo4BQsqpwTB8UOISE25JCUzRFKZ5EFw+Ok6v8inlry7mcYxSjhC9Ef0VoGpvMxltnHf1uaKqnLh7UQv+Q2SJe8tOSMoqaphVEYn11tJ70EvB+IiXudl/qfRyg4a+9d1InbfxXmQ2/MrU6hgsZBL/pYTEZoHVNXK43U8UAbg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The memory management (mm) subsystem is a fundamental low-level component
of the Linux kernel. Establishing const-correctness at this foundational
level enables higher-level subsystems, such as filesystems and drivers,
to also adopt const-correctness in their interfaces. This patch lays
the groundwork for broader const-correctness throughout the kernel
by starting with the core mm subsystem.

This patch adds const qualifier to the rlimit pointer parameter in
parisc's mmap_upper_limit() function that does not modify the referenced
memory, improving type safety and enabling compiler optimizations.

Functions improved:
- mmap_upper_limit()

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 arch/parisc/include/asm/processor.h | 2 +-
 arch/parisc/kernel/sys_parisc.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/include/asm/processor.h b/arch/parisc/include/asm/processor.h
index 4c14bde39aac..dd0b5e199559 100644
--- a/arch/parisc/include/asm/processor.h
+++ b/arch/parisc/include/asm/processor.h
@@ -48,7 +48,7 @@
 #ifndef __ASSEMBLER__
 
 struct rlimit;
-unsigned long mmap_upper_limit(struct rlimit *rlim_stack);
+unsigned long mmap_upper_limit(const struct rlimit *rlim_stack);
 unsigned long calc_max_stack_size(unsigned long stack_max);
 
 /*
diff --git a/arch/parisc/kernel/sys_parisc.c b/arch/parisc/kernel/sys_parisc.c
index f852fe274abe..c2bbaef7e6b7 100644
--- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -77,7 +77,7 @@ unsigned long calc_max_stack_size(unsigned long stack_max)
  * indicating that "current" should be used instead of a passed-in
  * value from the exec bprm as done with arch_pick_mmap_layout().
  */
-unsigned long mmap_upper_limit(struct rlimit *rlim_stack)
+unsigned long mmap_upper_limit(const struct rlimit *const rlim_stack)
 {
 	unsigned long stack_base;
 
-- 
2.47.2


