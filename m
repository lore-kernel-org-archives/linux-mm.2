Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 075FDC87FD3
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 01:44:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC6B46B0092; Wed,  6 Aug 2025 21:44:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C771B6B0095; Wed,  6 Aug 2025 21:44:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3DC86B0096; Wed,  6 Aug 2025 21:44:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A14826B0092
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:44:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 26A8B116212
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:44:53 +0000 (UTC)
X-FDA: 83748267666.14.B577D51
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4CCA716000D
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:44:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jF4rXkot;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754531091; a=rsa-sha256;
	cv=none;
	b=vdafbntgZ6GlXAREZu/M/ra8Hmso+gFC0LYtfD8brfrK05vaxnJlmAtYmWy0rmsvBaQN7F
	uZHMM33xeQx2Umy99DAM73C+7t3XBYV4n1mxfdSsLLhzDnPWp6W0Z4HeFZkpKU+QhxQ9rx
	9mICV6Z4mL/YxJFR1QNF0tisKyjq4IU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jF4rXkot;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754531091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zshHU08ID0A8NXQB//otilnse1ea1iiCCRjsJeEREns=;
	b=ju4YYw9f6pLNPXLPjQs7gvrVFfgVHamuuPc5v9YrN137FMQaNJSGVwEQ2yDnYeFNpq0jW3
	cq4em7y2BNygeT2XRsmE6ubtWnjxv7Zqw68To8XhpXn6kHSQI91bfKc6Ml8m7p4BxfXn2M
	e5NSAzAfEiUTHSe6TlYkBuM/xjzerI8=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-70749d4c598so5101926d6.0
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 18:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754531090; x=1755135890; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zshHU08ID0A8NXQB//otilnse1ea1iiCCRjsJeEREns=;
        b=jF4rXkotrAH/cjg4269N5Aa7SGjnELhEWY6STrvwTx3s1XCPM9mwMc3cuKnU0VCpCa
         VlML7tzhNcWy5b2SFsHF4kYpK+Q1qDzhQPxNesVvDGU/LdCqM5vds+kV1K0T+tidgV1a
         QEF8IRIRPjVnlpuNUqx9qZ1ups1wifnWQm/RKChiCD7R9GFsC5XV+5u4p0rRePShL8Nt
         zhwzN1UK6GsetsMrIrWee5VFhpVjhxxUqt4WbbJ7AuE6p+6RsaXSofanGWeJJNnp9UFd
         X0O49OJnFKh4PEiLExuKZo30WhT/cu921fFfEKAb2QHqvpMJN5BUP8ghAAcqvBMhzpGN
         yRsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754531090; x=1755135890;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zshHU08ID0A8NXQB//otilnse1ea1iiCCRjsJeEREns=;
        b=ZrtcRbtpeOmY6ll17XAHub635+F6sC0Hk/wnjGmXjfFyDKIMmUWYu4KIkn06vyB4YG
         bSrsL8SXg4pHmNyHd3m+VHrc0JlMSWwNQYzRYHdEkiu2HahspYgmbCwMZwPyg9acYRFA
         SCr5g2YW92f3MpPNK9Ib0VqCDJYvR6+eH+swBlwpU7meAYTZSw0Bj8zsRZxAhdvk1J8j
         k8rUfciuK/Yd33ptVqaLMNbrnX2lDi+HeOEJSZcD/MNr0BJCwGwy6gsdPXoybQ9SiQVn
         gadL89jYQ6oMy3AyiCBNaiKnyy1lNmtGPjJH3YOnVvBptJZdsop1wwVKytSUpxntSJfC
         F3Uw==
X-Forwarded-Encrypted: i=1; AJvYcCX4ci6x5RiVkKOHbGAxOF4E1kAhMpDWTJaY2dn/dBDmc+FChd997WOMq1GP6lVbygV07Yy+7XOF5A==@kvack.org
X-Gm-Message-State: AOJu0Ywuu1BicMTD0eUr85mRv1XkWqMQkLnfEY2SQP6atWDQ4Hzn6I54
	QAOvVFAPcqqKTwZzk8kZmFY2m5lGO73tF7q1Sz58H0MpMYlETUPhX2+ZqoYVxUNkFMo=
X-Gm-Gg: ASbGnctRoDU3Yf9hEShhen9Ae384rVgiZjTAPdsay6pudyplowEBvOcAEt7ps2tlR/h
	GC5iI9r+qGufbqVxFJoFF68FDh3kX/TVI0ENpJU35FCLtlZe0tbBiodF7VfFZGMPNhMti8gp5Ik
	Qwx2HFhAZEGy1kpBLEwH7x04WXU88hsMG8w6bQLRZG9/VS0aopkUVY8ta9Ipl6yJzJR5mfydu6I
	Gt0QaFVEobnH6/v13EeIbi+uzZmUfLx98PXU1k5mcLNgDgX8nMkMksgRlvk+QE5FMLnIai48ISN
	0q7aGLzvOHVl1VTqdWRxDDTqLhrJtUTk3+b6fu0WfJRCmKcEiFPW558LkpnJSK2uOHy8wgz7tyg
	Nv5QSLa8q80ROt4WBTDFbIrMRy1GVnhiefEoDoW7ptyfAIXeHbyWHU1hXa7rjupUlJygqSDNNbO
	LG6g+rHnjy5KqK
X-Google-Smtp-Source: AGHT+IHnmZoVOKyFNNYjLIT5+3p7MrntTaDtd4zF5EXEXaUvK/PtJPkVc+qy8Wy9N2jknjRUu/0o0g==
X-Received: by 2002:a05:6214:300f:b0:707:29f9:3bd1 with SMTP id 6a1803df08f44-7097964ce99mr76335266d6.46.1754531090257;
        Wed, 06 Aug 2025 18:44:50 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cde5a01sm92969046d6.70.2025.08.06.18.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 18:44:49 -0700 (PDT)
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
Subject: [PATCH v3 02/30] kho: mm: Don't allow deferred struct page with KHO
Date: Thu,  7 Aug 2025 01:44:08 +0000
Message-ID: <20250807014442.3829950-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
In-Reply-To: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: toa9cxry71cnswe7ci9816e11kj5umsx
X-Rspam-User: 
X-Rspamd-Queue-Id: 4CCA716000D
X-Rspamd-Server: rspam02
X-HE-Tag: 1754531091-495167
X-HE-Meta: U2FsdGVkX19cIbvLEhgqzhCd/d/EZq5/nIS2O2mGkpYuWMeR3eFzoo0gr9beaHKvUsLRVfvj4WUVt4EXn7SU34XiI/hB/xYGoEcsg/dABYZdgd5WVt7hhziLaRJpxlnWvPI+ExXyt5mH5mxVG8A010BMgAi4m/2oh1vP3BFlhc8RR4+KlqbfVuDEjoRQ7VdOhNWxL2Pufa9Fo3LI0Okpol6rClmaWiD0zoqoNSWOVUO/gyaQv5371b8kUaxefRcjXt8939kXIqb6z9ZSEqQIOdDLJp9DT+F6CrsDksgfcYl6fTWZx/OpqC4CrpCgXrKtwXBcTtUI+aYV9AXoBp9/eXi396CyoPIh+buDBURdJqN4kSNpvWekOVHvByloYZhOqTka0z59nefYoDQibSBMfYsI63LZkTFEPdGKW83M0Gkj8zR2sSCuVY/RJE6jm8hxoPzcl31sxsJ+XMkv4YaTbBIk03Crke2aZyEseqvBd5y6r0uJQmyby/pmO5o45H8TrG3v+4w5BeK86hi9kTH0RdfhvtllRLR70wFN9FuYQvhCHohQoHRXD6MZnxzZ/ylPL8gwjML93M15AlseGnqPl31nBIcueXZTyJo6tUHkgHjoZMwyii9i7EDH3hOWIa4ej8i3s2mEF7jIJB+n78JPHeOQux5mRHzbcIgNRJtNa1w6BsBUsxTgSjK0QwHgVBqSgQyb5POtSp4lipH52VqfdygYItX47Wws++HjagAuWW4pTOCYENaXx0uxzh0yZx5ozpJN8UnGSArP8faB+6Fwfe1BxGEWScvia+t0EoO7Zc8IfMArs22IY1M5ub10YSSjf01fsz57COFSoM78N1Bu+Nc2hyCeH6tzml6caolfZYw7cUNDAZJa+9sd6rhIOTL23wrsnoM7WUqkI3+ozr/V8/8pKYU+Vosd/XKDltJFDYyQ8GUihYX3ofuRoCA9FNKSmqhx4bIbHxhsXviArAr
 a9Akg7yg
 r7dMFUl6NtlkhWTz84GnF7lIAczpwVUmQ0t3/sdJwZSH3Y/c2z7h+nwzemizUWMnyDghOmkSyX/LLeezdxSNoklQB8HYqzhQXv1m/TnZLXH33GuG8dJTjGFDvcR8kVnXuKbM7GADcmhk+Y5lDoqvcvKdCk6aDl81qPzGQE97Sz6URxhqZOedKHCCaNbLXwwNzf5WG+78Vc9bpPTJ1scYKUa2upsTykXmR7vfUpdANe4o3J93nwMjoTV6X2v2YvKJjpe58TMXquvKYOJtcOppm0nmj4Qy9qqigCnyXqueWpg+Hm62Q/YqH8yp1oh/NKC83QN+qu8G0KpZR601n2IdA+g3vjiu5tdnlpPcA/74wrOZuv6/rm3+RmAzruS92GKkKLegw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KHO uses struct pages for the preserved memory early in boot, however,
with deferred struct page initialization, only a small portion of
memory has properly initialized struct pages.

This problem was detected where vmemmap is poisoned, and illegal flag
combinations are detected.

Don't allow them to be enabled together, and later we will have to
teach KHO to work properly with deferred struct page init kernel
feature.

Fixes: 990a950fe8fd ("kexec: add config option for KHO")

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 kernel/Kconfig.kexec | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
index 2ee603a98813..1224dd937df0 100644
--- a/kernel/Kconfig.kexec
+++ b/kernel/Kconfig.kexec
@@ -97,6 +97,7 @@ config KEXEC_JUMP
 config KEXEC_HANDOVER
 	bool "kexec handover"
 	depends on ARCH_SUPPORTS_KEXEC_HANDOVER && ARCH_SUPPORTS_KEXEC_FILE
+	depends on !DEFERRED_STRUCT_PAGE_INIT
 	select MEMBLOCK_KHO_SCRATCH
 	select KEXEC_FILE
 	select DEBUG_FS
-- 
2.50.1.565.gc32cd1483b-goog


