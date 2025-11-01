Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64A6DCCFA00
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 14:24:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A4438E00BE; Sat,  1 Nov 2025 10:23:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4077B8E008A; Sat,  1 Nov 2025 10:23:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2597A8E00BE; Sat,  1 Nov 2025 10:23:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 00BDD8E008A
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 10:23:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C73791A0684
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:23:51 +0000 (UTC)
X-FDA: 84062257062.19.F6CC78E
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	by imf05.hostedemail.com (Postfix) with ESMTP id ED4B9100010
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:23:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=HohJ5cYa;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762007030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y89e1Xc3DS2D9wc25qIhLt1elzzrVrlmI1KWnbpgyDg=;
	b=RR7eI0E0B7S8f6Jk2DvZnTdaS+K0PEmkFRkjikTP5th4RC8txDPMFfsCdAESoWLv0ZhM9k
	q9RW1l7j4jpOySLExb4SGDHlvyphcCRQfGfJTmxadKOO+qObg8uhkZL86xivBxv7KmKcKj
	4HKI3SXN/orZhvwh6Xh8X56ydWUaugU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=HohJ5cYa;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762007030; a=rsa-sha256;
	cv=none;
	b=7/vSkvLriAVeDLpRGrjlX6AJUJFG6TN2rhG/Ddw3AnVw1M4wU4Ul6xynhSmBy1CCXiwoVk
	6f6k51aJfmVkO1e8NDU9QIa0+cDcyy0pJBLl8PbjDNhZY9PRET5D1eWv+yxQYgf/mwYDp2
	pyDsEEGRsBYnB9giLZEGHtv2rjV3/C0=
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-5db37a935f1so1296472137.1
        for <linux-mm@kvack.org>; Sat, 01 Nov 2025 07:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762007029; x=1762611829; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y89e1Xc3DS2D9wc25qIhLt1elzzrVrlmI1KWnbpgyDg=;
        b=HohJ5cYaOYVKALVytbIAcYwZs29GC44iJhtSxCKcXRmq/ZRzQEZ9iSrPcdcEuVngHB
         MS1YknYvX7o5kmpcUXcQvBniZ9X+rQ7xKzhmmMBDDwZpXIuX5MbH9mRdiTGx9NabSWeg
         QmVNjVyrtZcZ1o8h1Nk/k0PYvUryKblsjPxlyK8CxPJo2pjl1Tjr2UteEaKhB0ND7/u6
         /XmlNx3ocMjef75T+BE4Zym/IMN+VTWhp/BRDwRjjaEKpiYf4zs9w4i45Vapn9y2pdZM
         L5dO9+0EOCU3CzuVaAg90cMyE3qxyHaRzipTOImxVgzhVE253Dg1ehSCPrAY4DrLC9rB
         pJ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762007029; x=1762611829;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y89e1Xc3DS2D9wc25qIhLt1elzzrVrlmI1KWnbpgyDg=;
        b=U52AR2jOBdRfNcc2Bj7ttsEJi/lDbh05Owu47V0pGcyso1QJpHV++5z6tm3w8I3Bep
         bvQqQX3w24hToC573lX0hTrnCsjWleew3JNwLkwYskRB361o1f3r5TBZCbtBhRwVVsce
         XdcE0HNPR1vn72XEfo0xvxFJc4TaF9rMkdscQF4gpX+AX8nrNr4mqtrRXqlH8xzsjo2c
         +LztGWBNEH815BR1KsSYy+pV6aSpIaMmn+h9WwcEt//7rOp6lpdmeL3PoGbAyFF3cV6i
         r/CzYq0d0av94eQkAteVvY18vx8rKc0ooQqv2XA0eTh3AFQt5SNc+HFeII+b6zJTRmWt
         Z+yw==
X-Forwarded-Encrypted: i=1; AJvYcCUZORyL8TM2gc76Ul6JMTSQYPiqOmrFAfaKGkzbV5ZUCwVSzWfmaG7fs23DmqS3+iVQD8ITb9+7Zw==@kvack.org
X-Gm-Message-State: AOJu0YwTo5IHMaKnkpuJlI7PXl792llpMdM0NyzWnpBI1wg3G/CJ8363
	McOGHbQTI3G1+vtDTiMU768PDUisLH2GjyfJCzr9BS4bsNOWzt7+z+9+uo7hY0S8a1A=
X-Gm-Gg: ASbGncshV82zmMDnNDhjh857Wkvd4adGlxj1DorN9ZAZfA6Omt6qXkHiKIELz7kmXXr
	5I5xZl+a/s8S7HnHgf+V5OoxLZU73+ttXyJICcLXjVV/Nt1QIQS/DYDvW3M0Df5KiyCKAsO8ehI
	MVNj0i9UreOlOb+knKruKkgDJxLwcQmUZ1guDz7/Blg2dED/EARwoz8po6d2VFOM7aDTpclnxl8
	1+uypK/dV+pUP9b3N7MThaOfyDjikR91y+B91cx7LzZSvt5dQm0L6a5QZEGewa6LIB+UMx9gTyb
	kIPg76WNCZJjwkjmtDfCI3MtDev8vdur+3S4HYIppLGfd6i8NbFICgDDZrd0kc2x6Px+buwTM0W
	UgGw6S73NFijuXAM+Ka9Hw2etEWKugYLDUc0HmbCKXD2dBiVn6O10GAT4531jxJk1dN5PLj/mfo
	CCgdijb20TKVB7JK7VX/tlvyT/HW7FYse2b88/f0oWON7K6/6vi0LTt/5j0XZj
X-Google-Smtp-Source: AGHT+IGFDCScfqliWb9KcrLwkQzx/ze/7HdLlm3rrxqjpvvjEhbQ+nHt0IFtgECikftA3CUT6aFcGQ==
X-Received: by 2002:a05:6102:441b:b0:5d6:5e9:9e0c with SMTP id ada2fe7eead31-5dbb11f02d1mr1796389137.4.1762007029092;
        Sat, 01 Nov 2025 07:23:49 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-559449647e0sm1776242e0c.3.2025.11.01.07.23.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Nov 2025 07:23:48 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	brauner@kernel.org,
	corbet@lwn.net,
	graf@amazon.com,
	jgg@ziepe.ca,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	masahiroy@kernel.org,
	ojeda@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	rppt@kernel.org,
	tj@kernel.org,
	yanjun.zhu@linux.dev
Subject: [PATCH v9 9/9] liveupdate: kho: Use %pe format specifier for error pointer printing
Date: Sat,  1 Nov 2025 10:23:25 -0400
Message-ID: <20251101142325.1326536-10-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
In-Reply-To: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
References: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ED4B9100010
X-Stat-Signature: xw8e56be544t1fmmsx1cuwb3pnp3pkm8
X-Rspam-User: 
X-HE-Tag: 1762007029-812619
X-HE-Meta: U2FsdGVkX18g/6LraXnkqmY7JcXV2SLAL9rPq7nV/1lHScP5JjVSOnEqJRhE72M/d83/NSY9a2O00Q6C0to2jhm790Y3pw0GKnJuWkOxPlFxWbmI930prtyWGiKe1Tx+BG1Ip7xtnO4jol/5Jm4Fi7eGZ/GNblm0RUjVx+t071AnRVvtw0av7wFdbRnTQRAjN+DbaSIFyCflmJaOITdgjqKZdCwnD4M50Odre+X3GdLZEDgBD6CuOhLjfwcHPylulUfoJzeh8tBOlmDwQBFQ+uXaYl69NoC7z08QeXDDlmXh8vAZFIFORD1PH7/+5lS4uZej7zifW8HWu8bPZCSjHBDN3mwxIXw5DPo1cvCs7MFXcdZ1rdNHiuMIIFPNFQIqmpye19kyainOrZev7Jza2p3VwcyqdUD+2nzQtux1JO8zeFXFZpkw07vmsOLkDQ+4Ac1p1c/DXbI3bqNeFMaO+W5YN/G9PKhvs+S449QgLim248VJjRwicr5NUtmtXDTSYAze8PrP8hX4gxPtjotA8lmVxGCBqVf8nFKZ3/i25PRfSxLUIKSztVchQBS/b7E7FheQ7FyhnlVVjerKMbTOlJLsiL7Z4h5e3EKBTcBdOgX3R2R0EXr+joOA0rJNOVCvC1e4tl2VE82oD5P9icWOX8g5WXr66WAknKFXFtprJBYbo7KkVy+wkzgES+bu1iucsq6aCPoPJGhRGc+t7HyRvVDT2meI7Va1iGG6PJJ6qo3v5TPNFTItsYMyXKpn7akab7R0VAUSCnuVFBniZpLur4E0qWdbBBJ3d4jLMrvgziH5Evj15ZiuV2jvMD3hzT4e36T7WQoAlak4j0S+qhQvh8nFkyOg0QKEAleZqodjOtezc1OYwO9MWx3VfWuniBrCGhplx/E7Qk0OTSeqqUQe9TydH40OKq0MorXx8i/oKUDHSlANL+jI//IIvbvbbw9MYHMy5fDD4FhD7GpZIbK
 ggpd0wUK
 P/RpFgbmbvxY1x8viniUyyJ38ok1co+kfQVy/rCdZopThye5bm8YB2mrlar9qzOCBidUMxOiANuzvbl+182uRKK5Jc597RzyfHuRiiUBUZ8gn42RnTzJAcnBXP0hyMik8fLoMQW7F9xixtbN2LRGXRd2S9gkITRmV3OMxU7RTu8cKZxAHTJlr64Sk66sMJFdvV2eASxXEWB+fhdSXVDGLCrq1H0NaPOtWANp5fijg7ED7z3KtvfRgdA6b5vaMXgUAKzkSVScX+m8jRJEyrq1A6uOARMCL4dWNvRFyiUCYGCDX6ko4rwkelnFVOE0iYzQjkWcaqCp/WxVpA36Q1Jc6KuT+Rhs+in7fwRv/Kq9lNGljcP34RoO+LP8+yMNqGK1uFWwM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhu Yanjun <yanjun.zhu@linux.dev>

Make pr_xxx() call to use the %pe format specifier instead of %d.
The %pe specifier prints a symbolic error string (e.g., -ENOMEM,
-EINVAL) when given an error pointer created with ERR_PTR(err).

This change enhances the clarity and diagnostic value of the error
message by showing a descriptive error name rather than a numeric
error code.

Note, that some err are still printed by value, as those errors
might come from libfdt and not regular errnos.

Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Co-developed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Simon Horman <horms@kernel.org>
---
 kernel/liveupdate/kexec_handover.c         |  4 ++--
 kernel/liveupdate/kexec_handover_debugfs.c | 10 ++++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index be945c133a2f..167c761988d3 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1448,8 +1448,8 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 		memblock_add(area->addr, size);
 		err = memblock_mark_kho_scratch(area->addr, size);
 		if (WARN_ON(err)) {
-			pr_warn("failed to mark the scratch region 0x%pa+0x%pa: %d",
-				&area->addr, &size, err);
+			pr_warn("failed to mark the scratch region 0x%pa+0x%pa: %pe",
+				&area->addr, &size, ERR_PTR(err));
 			goto out;
 		}
 		pr_debug("Marked 0x%pa+0x%pa as scratch", &area->addr, &size);
diff --git a/kernel/liveupdate/kexec_handover_debugfs.c b/kernel/liveupdate/kexec_handover_debugfs.c
index 46e9e6c0791f..ac739d25094d 100644
--- a/kernel/liveupdate/kexec_handover_debugfs.c
+++ b/kernel/liveupdate/kexec_handover_debugfs.c
@@ -150,8 +150,8 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 		err = __kho_debugfs_fdt_add(&dbg->fdt_list, sub_fdt_dir, name,
 					    phys_to_virt(*fdt_phys));
 		if (err) {
-			pr_warn("failed to add fdt %s to debugfs: %d\n", name,
-				err);
+			pr_warn("failed to add fdt %s to debugfs: %pe\n", name,
+				ERR_PTR(err));
 			continue;
 		}
 	}
@@ -168,8 +168,10 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 	 * reviving state from KHO and setting up KHO for the next
 	 * kexec.
 	 */
-	if (err)
-		pr_err("failed exposing handover FDT in debugfs: %d\n", err);
+	if (err) {
+		pr_err("failed exposing handover FDT in debugfs: %pe\n",
+		       ERR_PTR(err));
+	}
 }
 
 __init int kho_out_debugfs_init(struct kho_debugfs *dbg)
-- 
2.51.1.930.gacf6e81ea2-goog


