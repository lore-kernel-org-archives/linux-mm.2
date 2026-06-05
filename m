Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E25ECD8C85
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 17:08:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E72F6B0099; Fri,  5 Jun 2026 13:08:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 449A36B009B; Fri,  5 Jun 2026 13:08:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C5EC6B009E; Fri,  5 Jun 2026 13:08:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 07A3D6B0099
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:08:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BE839120224
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:08:48 +0000 (UTC)
X-FDA: 84846493536.15.7E1A424
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf31.hostedemail.com (Postfix) with ESMTP id DB4A420003
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:08:46 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EhITXlwj;
	spf=pass (imf31.hostedemail.com: domain of 3mwIjagkKCIQ1iz2v0ip2owwotm.kwutqv25-uus3iks.wzo@flex--tarunsahu.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3mwIjagkKCIQ1iz2v0ip2owwotm.kwutqv25-uus3iks.wzo@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780679327;
	b=ba75t4K+ysaBNDGy/RxKzW8IfNaOOmzhViL5SE3Xnhx+A4UN9JgFfOiR0zQvtn6XV8sEWJ
	YUmhel/MaiIiTv9I6IIUVKYvEpY1M9lAtGoyoFprWXpqHGetjLGMH/4BdQANg17yghs2Bm
	JT7XA1XZtF7/rCdWe3L+NOimSXxjpoY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EhITXlwj;
	spf=pass (imf31.hostedemail.com: domain of 3mwIjagkKCIQ1iz2v0ip2owwotm.kwutqv25-uus3iks.wzo@flex--tarunsahu.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3mwIjagkKCIQ1iz2v0ip2owwotm.kwutqv25-uus3iks.wzo@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780679327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mUNSpB3dfOvSGnAPr0UW6nHYEMpqSvyWhzAeEo+qvXw=;
	b=wQZqJFmlZRDhHarrkMj8Bvfs6ZOITYHGobfi4ELF93fuhLR9kOQ82Xj1+I0WJ6yLX3cQuk
	QKQJCML7cCQNjbAPRs2zGewu6ZW4QFNjUpPxuypGnA1xDsmqCtK6vd1CYVrTtggehkgDPC
	52CHONusvj22Gt3sqiEEyIq3IRVrTz4=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-bee29ce0889so953666b.2
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 10:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780679325; x=1781284125; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mUNSpB3dfOvSGnAPr0UW6nHYEMpqSvyWhzAeEo+qvXw=;
        b=EhITXlwjbCBo1lFcM9mh8A2aLFzFU3a9xH1FxVm51oUcbU4BDfWXEt68+ZT4WsGKH+
         /4yg+2nFh+J8W5427e9tIDX2ARvltSTLEcSzP/Qi5wBQlKBPqQ+UaXhgTjFSkNWaLwhL
         ukPvTR2vWxf9YVG9orx7pc838/tXFHGmYUk+xNblSSF37TmZ5JNxsEonnZyygT/IjuKs
         S0Fjvyd8vUTd7yu8HPvCVpZQiQ68G1cj9A/VETy1XfOERi0l6cH2jUJZB93l+LER6r9r
         yybwD+vaxpNpejqE0xpqJLV4Me6B7yvYF04Xi/zPFUYUlWzQ6g2L+wJGQkt4EqHzO58U
         kpjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780679325; x=1781284125;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mUNSpB3dfOvSGnAPr0UW6nHYEMpqSvyWhzAeEo+qvXw=;
        b=LIenPMl3PBOOTvjFpq848wsZkivRWjnvEW6SdNgauffMjs+p2Ga+JXL1B2sqepmJFx
         CCY/AA4fp0n5uxDHTk34c5rYgtFbcv2XXfu4j2BqeDEfPzSpCh7UU69wGC0H4I6Qopy/
         h5sj6YMTLl+HLwjMWm1Hr9Q9Fgi6MYo0m6wRK5LSNJBfr9mhW8HAhlXv+DAFVmgvfiiN
         9hMmCNcj+pwMSi1cY/yYGnddv5UZeFot7Aa36qt2c5KsbTgBZqtLofnePFOLskumAVvs
         LX2fvRJ5rhs6A0KSzNIUwpp9JcUmIFJ5uDc2r0vyqMhmOfHIWvHy89mAiHBAOl6R4pYl
         yqIw==
X-Forwarded-Encrypted: i=1; AFNElJ8peKPaLYYwHDVBfGcC7Dz5BdW/aH1ejCbA6hZWJh2Yk7FsHQRDtkPBwNxRd34ULBwI3iBynLJrSw==@kvack.org
X-Gm-Message-State: AOJu0YxwnHRQe6dCMeBgcqH3lzjj54w5PtugTAie0TXOGR/DVwiU7per
	QGw/yb8We9TLgEsj8m/T0w9SY63lqnMiib/4vvvRLhIbOttqP2yuN/fw4xuj5VoyBUELBWi4SOz
	aoHUldzVUC4ieA+CZxg==
X-Received: from ejbzc9.prod.google.com ([2002:a17:906:9889:b0:bc1:3569:5260])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:9812:b0:bec:18d5:ddec with SMTP id a640c23a62f3a-bf37311392cmr242121166b.41.1780679323496;
 Fri, 05 Jun 2026 10:08:43 -0700 (PDT)
Date: Fri,  5 Jun 2026 17:08:27 +0000
In-Reply-To: <cover.1780676742.git.tarunsahu@google.com>
Mime-Version: 1.0
References: <cover.1780676742.git.tarunsahu@google.com>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
Message-ID: <c17394cb12c805a7026047beda2563c7bad44a61.1780676742.git.tarunsahu@google.com>
Subject: [RFC PATCH v2 02/10] liveupdate: Add LIVEUPDATE_GUEST_MEMFD config option
From: Tarun Sahu <tarunsahu@google.com>
To: Jonathan Corbet <corbet@lwn.net>, vannapurve@google.com, 
	Tarun Sahu <tarunsahu@google.com>, fvdl@google.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Shuah Khan <skhan@linuxfoundation.org>, sagis@google.com, 
	aneesh.kumar@kernel.org, skhawaja@google.com, vipinsh@google.com, 
	ackerleytng@google.com, Pratyush Yadav <pratyush@kernel.org>, david@redhat.com, 
	dmatlack@google.com, mark.rutland@arm.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	seanjc@google.com, axelrasmussen@google.com
Cc: linux-kselftest@vger.kernel.org, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kvm@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DB4A420003
X-Rspam-User: 
X-Stat-Signature: x5i3anttygdt89hdr9b66cub7ugejuhf
X-HE-Tag: 1780679326-947695
X-HE-Meta: U2FsdGVkX19yq9f8QQgT5xVy2XzNrphDu/XNiXLRAXVpYpXm1WVM4CGabCYcGQF1FhZdkUVOrvxV+6BA+XtniAzZG2qWCPqeECoCijs8GFJCzZQBlEH78AcFoHsG21+P3wOFkoBIKt8Za/LBhjeNfXREQ8PqA9aZ13YCg6s+iWQiC4z+EIbgKmlteh8O+xQpMTyHmnx7M2CU5EAaWg1xaNdVc/DhvlZxxXiLaZvrl7tctfNtRwRZkrkLJ6GJJdaaxQa0+HI2F5RZbs4h4G9m679yTquRAy2tyevm6ZJrLHIL/eNWn5mC/SFCTgPYCgSQwB3wfAJFoAUWd6Qjp6gFXCxFQ9HyuGjC73yjva02XBkEJK42HxL/jg9U9PFobhr4/lAnjMF9SOGJFcWiu/UC2B7PiTM8Hou3nmOyIaE3y2+nK4N71ON7apHsqm1lVb5xxu+hqKNiifNO/W1a7ZJZqqUCCwqZvRtXXYjcNBYRANyN/AKrGwbTY9z07kIWHtAd+LUK6UNbRahABGrs5Qgwcj1xtuWVdbZXpzsSwcYwTvDIZ/aNhKyyrGNDiMUjVYpfTZDcR+k3O9P5ue9YONxv6i24qnHtEvvjhP116512ksQJHEZF1S4ps0ZAG7VbRnXyMXHRSsEr1FoZGeqc6IBbFwrBqMp/HjqEvF8/Y4YeRg5perKgfcK0uwlmiW6QJoZ61/4tqCKGPvOJSY3MXLJMCwaTOFQ6kMYZAQYcXlUreD+rDfn5mUKty1de6aEua6l8eFHReZzdNqIUXTawyreLk7o2OTK1VG/++5812qBeezEUQuAp2VfFw63TyNo9xGcSg8Isk9gSRWK/ceLOqysmknZlKcSyEAR343OeGjoXCK1L7DI8RANBMIb2JBidk5UXAO4gJY302yPgqHwHVvVlOatP1TluCvwqU/OM+ghq8hIRRD4Jqux1hAooXU3nCxnDTuhwx16ZgCa0sYFexKj
 OLAQ+G35
 7RpNNe4sJGm9BlrLPHi1hYDKHFy8OwuSEZ59oapNa1Vmo0xs61qTeT+rfUjkQ+qF4bmWgdQbr4gS0YyFf+qRuoiPd8E+YB+vOCcOELhBETVOaxTV/Xqa8RWtN22m9o4IlrMEDSBJ9lfNlbmZJxp344hIslNHPG9pXgYy5M/DOzTd0oTSgatutSr/vNY2FGVkmdjtx50/x5iOcWarc3YBqy30XhTL3x9iTV5gxfUw7OKgwak89cFnv287qrPFHwmNZbDBcZPDZoZBtUbcY7+wogLy3b8jL82She6chLEJkwP94zqbbbA8noomgRoevg+l6l+mE+cpGXxdpKUG3m+h95h1LlVwNKFmd5JhNaAZy1Q+mGpyUL6hjrH/WHENknGRQNMkKTDDBTMVp6fAyyJheyrT5TXkaCoex+Cn687boC9GfZrC48sbpGDWdx38e+ynKqOz0vOlUI+Ula1O+T+zdnvd/ZfNUZPv8kuIn/6RC9nNCdGaPKueVC/+NpKxEVmEy/RgBHZynM6y9zwr0C+5JpusirJAzbGSJMwqv9uOdNz/khtbxzu5JcS+NruHUka/NU5onewf8tVssOnWpSm+yHIVIr77EnFsO12FgiOD6fQAjK+c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce the LIVEUPDATE_GUEST_MEMFD Kconfig option. This option
enables live update support for KVM guest_memfd files, enabling
guest_memfd-backed memory preservation across kernel upgrades.

Currently this support only guest_memfd files that are full-shared
and pre-faulted.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 kernel/liveupdate/Kconfig | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index 1a8513f16ef7..0bbc4037192e 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -88,4 +88,19 @@ config LIVEUPDATE_MEMFD
 
 	  If unsure, say N.
 
+config LIVEUPDATE_GUEST_MEMFD
+	bool "Live update support for guest_memfd"
+	depends on LIVEUPDATE
+	depends on KVM_GUEST_MEMFD
+	default LIVEUPDATE
+	help
+	  Enable live update support for KVM guest_memfd files. This allows
+	  preserving VM Memory backed by guest_memfd file across kernel live
+	  updates.
+
+	  This can only be used for the guest_memfd that are fully-shared
+	  and pre-faulted.
+
+	  If unsure, say N.
+
 endmenu
-- 
2.54.0.1032.g2f8565e1d1-goog


