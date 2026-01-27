Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADAB4D2F036
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 14:38:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 211C26B0092; Tue, 27 Jan 2026 09:38:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BAE36B0093; Tue, 27 Jan 2026 09:38:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DD756B0095; Tue, 27 Jan 2026 09:38:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F11106B0092
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:38:46 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B7756C0ADC
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:38:46 +0000 (UTC)
X-FDA: 84378000252.05.D273FF4
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf18.hostedemail.com (Postfix) with ESMTP id D693E1C000B
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:38:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Q1GNF3jd
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769524725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mGV9QY0eKC+XLC5jci/d/FFQqBpectBL2Qr4Jd0liqE=;
	b=rpU2T9VeOFINxPiRhH3OZqe0Iuj6ED3YSecaYKUS3tk0mA3w1S6H+PvtP2yDoGGhiXWA0J
	vAk8p4944WREmzTVG2sHDqCWzmfEoVV2xSZbbEKNOR6vTCx+bbleIdnTumWP1owfWXB9Ss
	EfXWwaZQvQ7vFypXqTHrTBs4ni7aAMQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Q1GNF3jd;
	spf=none (imf18.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769524725; a=rsa-sha256;
	cv=none;
	b=BrZ3+AKmfFJP9X5TVacQhuQL+dFYsVOQmDZtZPCE5lPsajekVWSLxVwJ6dZSock67nS/P0
	u5BNir8UcL0rerokORiDDFg1iySfY6zLi8pumoXpjPrQsH31Y0w9hI45LBxGSPN+4FToG7
	6938/oRn1KoLpzKoBhR0LO1GaOSq9lU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=mGV9QY0eKC+XLC5jci/d/FFQqBpectBL2Qr4Jd0liqE=; b=Q1GNF3jdZtMn3P4r5/R4swjm0H
	3yUVhKTRKvrV3Kn3O6O6PrJZ9qQtu+MGveR9TBXf0QG/h7G4dfNYoNB0RTmvYrdehJ+TdBrfXiTQM
	opXZSQg5NymiQfotFJJXTlkF59l6CNxQoiM5Th3sNlsN36ssJi/h0zPw+Ty3AnQskbqOF6hha/A/U
	xt0ufAkOO4ewK5AGtMJkGqTXwejFC3MK43AXlxweD5Xg7SToiXnICmKYiojiWbLY6P2hbRGuUnwNS
	KM56g3mb5GJcjtdTCXmPTPuVNwY0f7xsd8d5zn94hZ20fwcDF40y6AvtWyNCtxF8OmB8vEtY56VWT
	F9BJlIqA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vkkDG-00H3bi-VI; Tue, 27 Jan 2026 14:38:39 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 27 Jan 2026 06:37:39 -0800
Subject: [PATCH v6 4/4] kho: document kexec-metadata tracking feature
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260127-kho-v6-4-56f9396681c2@debian.org>
References: <20260127-kho-v6-0-56f9396681c2@debian.org>
In-Reply-To: <20260127-kho-v6-0-56f9396681c2@debian.org>
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-mm@kvack.org, usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com, 
 riel@surriel.com, Breno Leitao <leitao@debian.org>, 
 SeongJae Park <sj@kernel.org>, kernel-team@meta.com
X-Mailer: b4 0.15-dev-f4305
X-Developer-Signature: v=1; a=openpgp-sha256; l=2465; i=leitao@debian.org;
 h=from:subject:message-id; bh=BibzqRu4Th29Z9ZLDMxo+dYOx89bJU5ET1VM3xltlKE=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpeM3XfBATMClwlLj2ScoQxI7DhQS7XCCiu3I5D
 FtWzWXHM32JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaXjN1wAKCRA1o5Of/Hh3
 bT7WD/41L7tomElTT+B/OFwWEDmD1wkVMFmcJDn4NThPerzTRJ16JJaxnLwDPKxdO9zeHGNw5d0
 nN4ounqpCCm6im1A/MwlfK4BJHlPVp4yfZM/x1WKXGwwRELNyxBVx1rQCmzk76Jo30v0n7aqC/n
 4374aKlmnLBDboqebEyzibBkMI3ORDPaQZyCz7IqZTc8wA35G5CqraUwN3GZjV99zsaFw/v18zt
 /3afIV7lpZD1KCUKxLsRgUQPUZV87oTOn/VmFI5BCfBt91jII4fRIaYeZf0ppOQKS7Hv7UkG+8+
 halD0xRANRnrceVvs83HsA7SgrSMoM33X8xCo0DWbzJCuE9eXHAcd+7lXaCY4pJz+kuZ/RO8SIf
 8wwjqyc64nteoaG8m4CYwL4mhRhWECW5VWer/xNKXZXwHTLUYR32eXDiYpetNvSLiG9B+eji/Uk
 CdtK/gTZK7aU7TXoJ79kI1uerPEyn7gSyK3ADnwBgaNK+ej5PmLec15uXw9mV1CHDaZB1IgQLc8
 9Br6cicR2iiVlFYzDgpcVbVAyWEuVbOHuOSSvQsvgWj0p4Q6bmRc5KlFx5AwJKxaxL1B+JGGKUF
 Gh8ZblvWHSE/QeNGsxcvad8RwH4eZ86cTCjDM2HSvwNk36BWmSp/cZfgVeVoXbCkXh020Q35Hl9
 xdCbfDI/GQcqWHA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D693E1C000B
X-Stat-Signature: 11aa1p6e7y9jp79y7c3tnw1g4sf74cmj
X-Rspam-User: 
X-HE-Tag: 1769524724-875147
X-HE-Meta: U2FsdGVkX19ab733OPwL+DLxUAKagNc16I1z/v9tFXf0I/GdbeB8UGI4TTsE5Xm8ru2rHRWh5Gu2+ZfhqzwsR2/Ps7cxxQDa7z8E/MsvlBluVD+B9e3I2g5cFt9aWSJFfsg3K4z3xSzWVzso4H8JhcnHC5KNT6+b5yC5qPFy1QZ2gUk1A7ZFheaVpkMuO7ciU3CBzrTOpoUna1qMjecrYVRDkaaW4ZQA8rDmWaT5pM9UEr5eQ70IMh/j+CM6+pWprzi/0CpY7Q70vxXLzeTfAjO+LagZp18c8x1ov1LJKnP1tojER82F5UU7CI67Xu1m5pLUnwuO4K4tAtmYRIbo6/IES2j1ODrsPNcjRNNxmVtdWvvg829+CpD1CxznVTcMqAgmY4KxQBzKNVEC8jce5/5zpoEWRvpI4vn1/MCV4c16fuL4ik1oLA47GMFQdkH2ykB46/tmftZN6kmBITXbtwzQE6/IdvA0Ytxq3mKggY19is9FFAGOxj0O1s8Tu5HAYJg8I47pSN9f78m1a70gTmtt269MpwruMsDs8fn1ijXVMsc/Ixx4G9dsAIDxPh9yjcSctW7iKPOVpreoeEnku18XI7/cXx+MpQeRAe9ohQk71sFE9+F3KmOXVimenRNCycqLwPnuf0Dp2JkaSRW/5KwOKdQbDC9cg7qUoBptMXCqa2A0ftfs/Y+mJD7svr0LUJQovfqrKUEAwx2fRzg2QfDyTEfopR9lmLbk0EybbJ0qT4CELUqq6xfUOuYf2qGJMaal0QxwSXzzUzy1GkAU5LxmEDwYdRwOS0JU6tsnCq+gcgGu277oCbrI9X49o9fcQjEZ2c6yPY78+vJDs0TrXVFiK8oybY9hdMkuFlmQ9S0dCISniqdUvxR1GFVnkJGjUURCRJek2WZULByY/7RMxzIme7WNZXFf6BjZM97zqJkOgSaX16pkTg7nM9j+PwcfIp86hVEjcYxT1P3Yd0k
 umzqJ/xH
 PlZOADn3N6AaM8k6S65+OBzUJmOqbmza41dyOHbhbq00/vzPo/XT+Vo41xtyoLonSnKT5JA45e8R+J5gduylWksIA6pM33opdU7OoAgp7g8owNbXcEHUR75zowp/w/zyMkO4H/L1ASSsM/enpcrljHgSLwMrTu+zZvtPs8nnNhsegKTuaY16ZQQH72A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add documentation for the kexec-metadata feature that tracks the
previous kernel version and kexec boot count across kexec reboots.
This helps diagnose bugs that only reproduce when kexecing from
specific kernel versions.

Suggested-by: Mike Rapoport <rppt@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 Documentation/admin-guide/mm/kho.rst | 39 ++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/Documentation/admin-guide/mm/kho.rst b/Documentation/admin-guide/mm/kho.rst
index 6dc18ed4b8861..3771e764bb513 100644
--- a/Documentation/admin-guide/mm/kho.rst
+++ b/Documentation/admin-guide/mm/kho.rst
@@ -62,6 +62,45 @@ You can move the system out of KHO finalization phase again by calling ::
 After this command, the KHO FDT is no longer available in
 ``/sys/kernel/debug/kho/out/fdt``.
 
+Kexec Metadata
+==============
+
+KHO automatically tracks metadata about the kexec chain, passing information
+about the previous kernel to the next kernel. This feature helps diagnose
+bugs that only reproduce when kexecing from specific kernel versions.
+
+On each KHO kexec, the kernel logs the previous kernel's version and the
+number of kexec reboots since the last cold boot::
+
+    [    0.000000] KHO: exec from: 6.19.0-rc4-next-20260107 (count 1)
+
+The metadata includes:
+
+``previous_release``
+    The kernel version string (from ``uname -r``) of the kernel that
+    initiated the kexec.
+
+``kexec_count``
+    The number of kexec boots since the last cold boot. On cold boot,
+    this counter starts at 0 and increments with each kexec. This helps
+    identify issues that only manifest after multiple consecutive kexec
+    reboots.
+
+Use Cases
+---------
+
+This metadata is particularly useful for debugging kexec transition bugs,
+where a buggy kernel kexecs into a new kernel and the bug manifests only
+in the second kernel. Examples of such bugs include:
+
+- Memory corruption from the previous kernel affecting the new kernel
+- Incorrect hardware state left by the previous kernel
+- Firmware/ACPI state issues that only appear in kexec scenarios
+
+At scale, correlating crashes to the previous kernel version enables
+faster root cause analysis when issues only occur in specific kernel
+transition scenarios.
+
 debugfs Interfaces
 ==================
 

-- 
2.47.3


