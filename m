Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 007F5CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 15:10:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CD496B00A6; Fri, 12 Sep 2025 11:10:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A51B6B00A7; Fri, 12 Sep 2025 11:10:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E1A36B00A8; Fri, 12 Sep 2025 11:10:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F2A06B00A6
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:10:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D663C8728D
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:10:16 +0000 (UTC)
X-FDA: 83880934032.07.E9B9305
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id E171240016
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:10:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=Xm5kYzQN;
	spf=pass (imf12.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.170 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757689814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MYpcsE3JJVoPh3yiGg+2u2fE9IOmYvM0Rb6jQc+GT84=;
	b=TZ1WsoNfy8jPQvRgXGRe/89U1fJOfjjqBARc+B3Q/Cl/NoH0Wy5zZSgf8rW36Hx4+CuCec
	XFjH3qZBvztmBfIzMMS5OyrdsrxpfgSAERX0gBVGoC2TTprpwvOqOyVKvhU5+9bmta2wZM
	ADsx5JxX0FG855DHn4OHcaVctLr+Zas=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757689815; a=rsa-sha256;
	cv=none;
	b=0bRYhS94/KFueqlfGK1XvfGiyaPmHHaHJQZQsJkRT+b/K3JjbA4p0CTmhSc6kX8shK1DHh
	5I+vhrxg76HSNjHzWO1kkvVgSnk/Dk6Q+8MGZILwEDMYV1mkLWGzPBGaxwurNcn6+WGKvw
	RASy4VpqTK/cw3lE8depB2/pz1mIe3c=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=Xm5kYzQN;
	spf=pass (imf12.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.170 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-724b9ba77d5so20256117b3.3
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757689814; x=1758294614; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MYpcsE3JJVoPh3yiGg+2u2fE9IOmYvM0Rb6jQc+GT84=;
        b=Xm5kYzQNEkrFgPcjij7HFByXeGpakIYajTs5Pu8pZPRadmdDnvSi7oQilDaGM+CbGy
         5NOxZdYwCkjQI0HneZ3lq6g81OKX/aDKjO5oV43o+KFXo0xOWdbV735Yd0Xn3Oy0mL/q
         FA4u+8sbfUtHdv32GgBx6lsN/VeU/AVSRLwlAf2VTE96t46etoY66yyUDPFf3hSl6nst
         SOKuKOF/1o8tlgsguCA4/KlO3DOZ04LUCub+SweRsqz1j4rJFRSZ8riRdKiuyVTmKFuk
         nf2JfNEYZ15S7P+qKsxCssspLscMqp0UH8QLuI38t/Eg1TZBUqbImn/i+VhY6q2RUMk3
         iHSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757689814; x=1758294614;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MYpcsE3JJVoPh3yiGg+2u2fE9IOmYvM0Rb6jQc+GT84=;
        b=BpEU3gsRjzuX/UB8j/6HHhbd8WFX9cKR+AperdcXRoYlWhrb6jjWUbCMYoTHeh75/k
         N0bm24fVvOCLHdQ/UqKTwk33wGyB+GKyOMA++NDcQU2vXmRAM0vYwZdZ/YyyZyEPNXZI
         gXq7BxA4K5tR7qDDkqUl++fsGS4ofu30y+sfASclI4gSLg+jlucuccS8IGFUBOK1TCOM
         1XbYknY+tbjjaK3UzYvXBAC3s1k/JAREk6EGn6/hXXJDObzeOFZ8vd2rnf8TW5oVl3Tw
         DLG+9+J1mvnDWkxFY1D/oe+aJxLm2DBjr0EcZAJ+QWzpeex91vGX9ypZoztWBkNtXnUx
         +05A==
X-Forwarded-Encrypted: i=1; AJvYcCUxjj4kxR6x9N8NLCI+MWsRA00W0GwbrO9fd+QFEQK7oB6nK6+UymKb5Hq0dJC3HK6vP39EpKRk6Q==@kvack.org
X-Gm-Message-State: AOJu0YznIJmWiYgpUDkahhaC3nHB+usNfYnMKPD073+uOyEcFagOVcq+
	oXaCUaqTyBp0+BgArQ0OcU1DMCmleGOIRLidJ4i/X9ICqo8HujfoId8mur2VPCxYWGk=
X-Gm-Gg: ASbGncvcul37xbweMCvMI6eQ7aLeExGdhZORwVNI+36Y7Q3ONbFlGmOy/Jm6XfiTGMO
	13j8WzKrB0z8qzwfHcUHN4M6exauF5WC6GHWX2jwqcYRbbpo8ssJfI7SRXucewyTTqhF2TMgeJ7
	Vu4Kk/vg4skQoIvRyhyXaKSDzNq/8kKNbr95x8i6ypFYWzxiekag+vu4Byi+u8zgTBzNbcdiCvb
	5osRcZLt428kH/5Ni9tVRj0FwCECkZoR6Ap/Yu1Xe/VvmRSgs5zSw6UnOukIoyEE1w9kMn4f1/3
	CyJbFTKjVt5SernVV2dojssMXsBa9Grbc6BUDz7blHamnW9YU7cY712/VRJ4mvZqJ2t5IVDsukI
	LiXunGLsAbJ1DtKR4mu7gh8y2Jxq113+vC7HQJbD+Fpk+
X-Google-Smtp-Source: AGHT+IE2B/J5wRLXOu5lnuN+Axv8riYyigPru1eeeYCbQIMixSd8q/6Ui1Mo233PH+t3U62U0f7UQg==
X-Received: by 2002:a05:690c:10c:b0:71f:c7ae:fb73 with SMTP id 00721157ae682-730659befadmr31464037b3.42.1757689810056;
        Fri, 12 Sep 2025 08:10:10 -0700 (PDT)
Received: from eugen-station.. ([145.224.119.89])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-624841586c1sm1302244d50.6.2025.09.12.08.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 08:10:09 -0700 (PDT)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com,
	rdunlap@infradead.org,
	corbet@lwn.net,
	david@redhat.com,
	mhocko@suse.com
Cc: tudor.ambarus@linaro.org,
	mukesh.ojha@oss.qualcomm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	jonechou@google.com,
	rostedt@goodmis.org,
	linux-doc@vger.kernel.org,
	devicetree@vger.kernel.org,
	Eugen Hristev <eugen.hristev@linaro.org>
Subject: [RFC][PATCH v3 04/16] Documentation: kmemdump: Add section for coreimage ELF
Date: Fri, 12 Sep 2025 18:08:43 +0300
Message-ID: <20250912150855.2901211-5-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912150855.2901211-1-eugen.hristev@linaro.org>
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E171240016
X-Stat-Signature: nuh7s8reehqq9pwnhsfha7yfukomdcs9
X-Rspam-User: 
X-HE-Tag: 1757689814-11196
X-HE-Meta: U2FsdGVkX1+rvJytFb42NTzahB49pdiA10JF62rDpu4stXubzMJ42szN74BCm+5vjQqhcfImGtFfx74VAHXA8lmM3o29J+GiAUk+B0zbOWCmXacQjdePH7mqjzjvBAHFFW9Rh4Cy8VJdmmeRYBSQaDeKWJAkC/4iXTMmowmxpOOoKaK36856By6xhyC+4CrSItuVfnpqeJCul41AcyL7nGpkV1IhwbR+bJ/14rNaPBID9oyR3Bn7MUx01FUxP7BRyFwIY5GeKBqNwMibuDdrYgRDTIMVCZh6oVMfqSuyF6anO9B1rS33GWnJuoh0il6NGAXUgBSpTbwlK2/eYeMCEg7ND2Kj9MzCXZV1rwDT0ILTmn44jdtKt98GEM7bPkE658TTdUrgcjrW7XbxgRoNFJ/oakxZiL9Tgxgl8L0N9ZlM3rkihhfyF5CEmCSaynU8mAU3xHeMyw35Jg0kTTsPdx7X478iX7J9rIU+FpWRhqdpkBxRWt7FmfV/la4NS+ABnW7Qk0LAgucTI5qr9eejcgfm5913l0lyAgoK+D47snEcL20gBzgzEm3QmWBbi/Ta1+6kJy7wmcuiDHaCgsYVC/YL5icwrnOmA9qj7mmKAj2HGgL53/5kcFVpOlUxE2leCKMC4h56oFiXOWgNbblAKNNYi05Zqp1T5YV5yKkC6kzy+X2c0f39VQmQ/ASlBoM7uiQ893n/uMSZuhtg+r5MEnC3fEr0QssE20hMP1bg6dw9A3+2L2WGCs7CTUSDNRdJ5RPT0bRUa6ruP2a3ZXvdz3LqtKd29K1K2FQrVHGZI0eaaGkPkmVtwwV4iNMDlytwlf42kKrthrH5LsCPbMCY523hFEqx9vG1rWu3QAvG436qz1HYvLBhnXHktZ+FBsxVZKvyzDhUahAtXH9hweeCBjpxjrt/g/4ngunx1OE6oL6AX4LORvoPsL0FgOeQK2XbPfg1BiE2HqahZDMJJs1
 Va11acHW
 n9IVs/wvvms/w/g6gRwAT8kRCQdsOb6uFpZ12QR4yIhns/GSxxBkIWZf/jcf1eeyDkmDQOBAOYwFDUBEZKVxTLXbHnJ69ZnPTzlRmx2YWtwfWpppzmY73HaKXWuIKG5Tv8ia1PtgHpbgwB4xRlsbQgebymR5Dgiginkvb5XMoO97kw81Q86PVMchJ/+wVCqvBz9xTcWmwNkI9EizvhBWtKkRXdbNEaG3uuhrPNS3wuMxXXb6UmFLb6hmSvuBiqXN3i8If2TkJenP7ftgSsQ4SqVeM8qWE9rCLAbua89gpUzhJ/L17Co1xBgQmyul8hzb64deyDP0E+gkDiSU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add section describing the utility of coreimage ELF generation for
kmemdump.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 Documentation/dev-tools/kmemdump.rst | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/dev-tools/kmemdump.rst b/Documentation/dev-tools/kmemdump.rst
index 504321de951a..5616843e0407 100644
--- a/Documentation/dev-tools/kmemdump.rst
+++ b/Documentation/dev-tools/kmemdump.rst
@@ -27,6 +27,14 @@ are limited.
 Although the kernel has multiple debugging mechanisms, kmemdump fits
 a particular model which is not covered by the others.
 
+kmemdump can also prepare specific regions of the kernel that can be
+put together to form a minimal core image file. To achieve this, the first
+region is an ELF header with program headers for each region, and another
+region contains specific ELF NOTE section with vmcoreinfo.
+There are also multiple regions registered with basic kernel information
+that will allow debugging tools like 'crash' to load the image.
+To enable this feature, use CONFIG_KMEMDUMP_COREIMAGE.
+
 kmemdump Internals
 ==================
 
-- 
2.43.0


