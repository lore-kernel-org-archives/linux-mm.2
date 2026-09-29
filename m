Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88902CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 04:03:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F9286B0093; Tue, 29 Sep 2026 00:03:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CFD86B0095; Tue, 29 Sep 2026 00:03:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E62A6B0096; Tue, 29 Sep 2026 00:03:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 314076B0093
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 00:03:25 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 38B361603D0
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:03:24 +0000 (UTC)
X-FDA: 85265455128.23.1E39D13
Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1BADE140004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:03:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=fXGriWoj;
	spf=pass (imf23.hostedemail.com: domain of zack.rusin@broadcom.com designates 209.85.216.98 as permitted sender) smtp.mailfrom=zack.rusin@broadcom.com;
	dmarc=pass (policy=reject) header.from=broadcom.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790654602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wf4+8fPuDTBmj6DTA0OwZVxSovvEfEo3g6LDTXOjhgc=;
	b=A+pvxR99xCw7L1HLDMCcoapt0voUT0CH39YTCHtnDuJ+0XtsGOkhxVOoRn8kXWpTEdiLNJ
	pkmpX01AAZRiH2BFxHUAZkPWX9fnpPzyGWVpPoLb5C5gU3WkQD5vsDMhNCjdnbNKvphyD3
	qbDzv27wNCStnrOKgNAwHn4eyTONGnQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=fXGriWoj;
	spf=pass (imf23.hostedemail.com: domain of zack.rusin@broadcom.com designates 209.85.216.98 as permitted sender) smtp.mailfrom=zack.rusin@broadcom.com;
	dmarc=pass (policy=reject) header.from=broadcom.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790654602;
	b=cg9JHs1NcCtzwxtokkt+vCt6aOzXhNqIu+mpEzGAatDDTz9OYLO12tzxtigjV3wUNnH6lI
	9m14tVH1OoRFjcnNyhpRRrfaOL2lrYYrV0SNRkZyPtZMVkd/9p2JtAq9X0BDwR6WQsNmOc
	Aj89yMb2OkJC0rJ37f9LEIb06eFyf6g=
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-3964dfb5a69so1448143a91.1
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:03:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790654601; x=1791259401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wf4+8fPuDTBmj6DTA0OwZVxSovvEfEo3g6LDTXOjhgc=;
        b=krIaW69x2VG6XHpUYSq3E+75XUgzK/LVhs31y8mDee9257u7E9e6DJIsl0U9Jzdpr3
         imNjUGnV53dh/JZXYvSlvNLSMY1elJtH4ovde05gELHdWqpIAFmcIOJ5GhYMVgpGjFG3
         vK6NW7B24g2mSKsFeQB445Y6HZOoMIHFir2MHsKoskpkJNws53731yO26xCn8H8+9rmB
         B6XyI6Pjfjm16d+EPIeMhtNWTLX41iMNjZevOpu8hPotElCzJpBb3WBjD0xiyb50Vg+D
         WlAn4zOXXBVEXrEy8fUr6In4Xh6J2r8p1mvT8TO1ZYJWVUP76FVR1tOw0epf139hSGYm
         hU1A==
X-Forwarded-Encrypted: i=1; AKwUvBxkco68ReWT3iP3Ssjy/A+J6EpUtsPS+L4JU5NP+XVVwpMJJUWehyiUWJd4RzGmShrg/ieIyZadbg==@kvack.org
X-Gm-Message-State: AFq9FYJTA8U57UQltkctaWCpNzC3hvZ0JNNjjNNj8Qc15+a4Irqc1FuN
	fd+7A+laA9U5kTgbRyc3vTZQjB3Ef+vpCii6iQRwCGQuvRVEtiKGPjiVAXQcq3gIN8jsyzPl0KL
	Q65uzch4RTRbXClO1viya1Y/cr5GnhE50QkebAPLxF1oJdJRnMlMhzpe3dtt/lURVMI4qFxS9z+
	3unXSdwAnoB1iLfYHDxK8mUWWD5rtOAI2/yfyB1amTL6zBYe1TKkErh8AYQSG9+qKaGBQ16fMRR
	oM=
X-Gm-Gg: AYBFou2pmlZ5K9gHmTcVWzBddML5uBwf9y6ha5+dv3y0t1nkJwRlH1MoYsqggEvDsM0
	rL90DjSLn86UfaXkAWKLtEaLbu7GIMMBrojXEjv2afCpXinKyy48/mZBfBoeJ+JseouvnvgPLpW
	/YzcKIMAV9CtdugIaHQXVoVmtPs/BtTMIbWBiszqRnSNvcsKQu52QTV9FojOEsZfLO8iGYlaNTk
	/w6l8vXgpkFWDRp5kq3C/OUrGIYgYmwvVdQ1/i4Ssqkl+uccSKEeGm9+7hveBeFtPhAjON3PUWs
	Kz7VtTagad85VSyEVYwaQciHWi7d0fBrMopGSQf7i41lTTtKrix/qNjyWHCx7q31/pIvQYqIBYI
	ypHilAovXByKd99NwS3d47E0YTUp/NwoWRRLyUlfrw3PDm0/uMXG8jhUdXvUn0Gj7peDxGgYPoK
	9+ZzzClfR2nT953KRixS+8cP3xCuG8Uni1e1s=
X-Received: by 2002:a17:90b:384b:b0:3a0:c360:a562 with SMTP id 98e67ed59e1d1-3a0c360bd58mr7336759a91.14.1790654600909;
        Mon, 28 Sep 2026 21:03:20 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-120.dlp.protect.broadcom.com. [144.49.247.120])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3a49770c554sm1018831a91.0.2026.09.28.21.03.16
        for <linux-mm@kvack.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Sep 2026 21:03:20 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-342217d8d53so12162507eec.0
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1790654595; x=1791259395; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wf4+8fPuDTBmj6DTA0OwZVxSovvEfEo3g6LDTXOjhgc=;
        b=fXGriWoj0620aKqpEx+gu+WC0idqlvNFnbNL90pBfgikztdLKOYuIhqaG8JuLxpBef
         rnReoulkRH8J6n4lyldjy5D2fRO2OeF2OJmBryrvxihbGwzdksFhHhO1pZK1EFeTtrYe
         pRbzzBhVFh/EjKcGmcYoKBIMyzTuKZHt7f5Vg=
X-Forwarded-Encrypted: i=1; AKwUvByXyXpQJkHub9bRNrdA5spNEd7yeeRyx3clhSFwg3a0gzKt6OxLBTsiCDuR+kjgf5dKQB+aaSl65A==@kvack.org
X-Received: by 2002:a05:7300:c8cc:b0:33b:a4dc:d5e1 with SMTP id 5a478bee46e88-3426fbbe36fmr11863808eec.8.1790654595157;
        Mon, 28 Sep 2026 21:03:15 -0700 (PDT)
X-Received: by 2002:a05:7300:c8cc:b0:33b:a4dc:d5e1 with SMTP id 5a478bee46e88-3426fbbe36fmr11863746eec.8.1790654594365;
        Mon, 28 Sep 2026 21:03:14 -0700 (PDT)
Received: from vertex.localdomain ([192.19.144.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-347323f5a7esm10952571eec.15.2026.09.28.21.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 21:03:12 -0700 (PDT)
From: Zack Rusin <zack.rusin@broadcom.com>
To: Kiryl Shutsemau <kas@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	virtualization@lists.linux.dev,
	bcm-kernel-feedback-list@broadcom.com,
	linux-kernel@vger.kernel.org,
	Christoph Lameter <cl@gentwo.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bo Gan <bo.gan@broadcom.com>,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org,
	linux-coco@lists.linux.dev,
	kvm@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-doc@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Ashish Kalra <ashish.kalra@amd.com>
Subject: [PATCH v2 2/6] percpu: Bound decrypted storage for all x86 encrypted guests
Date: Tue, 29 Sep 2026 00:02:51 -0400
Message-ID: <20260929040256.543767-3-zack.rusin@broadcom.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260929040256.543767-1-zack.rusin@broadcom.com>
References: <20260929040256.543767-1-zack.rusin@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1BADE140004
X-Stat-Signature: mhbes3nnxj6dyseuxgegej6jo6as3piy
X-Rspam-User: 
X-HE-Tag: 1790654601-888928
X-HE-Meta: U2FsdGVkX1/3fz+waclVvbsFk4/q1YW1LNtlPMfvwOU/tIJJY9MZQEl8ImWgBGTr2XEVmj3EeqXMQDYBFBRHkTlz9VEn8eI+htuVpX8HORInbd8wnir+dHbYJR5ppXXyjf9VZ1+M5HAj2rYQ5RAgbWxqySebpTmP4nusoQdkxMB8io9RwSLHQzD5pIe6CO5BWn3xi8vOKdpwbkJ/ixOPw1BQaVmv3qQtW5MElB6OWu5HXC8/e1AtfMUByI1AKXVt8WZPVH8xc+1h2K1Ep534r4Dhra7XQvvkUUTfdLIc9OXZ/oc5oRO5Nd1Wl9dTip2ffOdebRVuuuI8AjftZO9EBaG2xJtLaIHcROnjtm3DLZGrrk5N1cS7sF56jU1kCT6pCKxhw56pV63imQcX1XmijT/BAs/DwxrZZyLslBfaAeIH4UJNfqYhrvu581n8TyLMmk9+qH6U+hSNyRVnMvVGhhLIif0cfS2Xl17StdYxjidpDXqe5h9OGGZe9JzU6ffSXHve2JXuoLNr8Sp6UdpfKR4biFtkEVtTyUqGyqfZHb+e/G0vEw69Va6C0d2yl0GrzQ2+pp8ua2c0FYbpaoszl1z9sH1acyZ6742qHRA15kELfWcYPlhGF3uZgaquEETE4aoc3a4s1oPREkd/+PfjS2mwyld/+8vfeO4fBqlX/m1a/775T7HUrpUxRGjVwu5oBneIooiekfiSNoqK8qBqpCmy3sSgJAZ7T2nbwNh8RF4VJnONOIEc5eji54tPrDIondc7pwgl+OD6ULJopeoS0+H0/khlPWfEbXeOns7U9nOz/X2L2pM/IT66MHQ1h8grHZtDc9dvjt3Eek95O+aMAc/zSPazusUNbGnLHVx9MwSuPOyQdzKeOMyyMPTvCQjJHfBzTcr6KQt6svXJlbvgqYHel2QBRc45f1qXeMxXziYXT3QQJTK6X/G/7jd5v8DSU6tqPGYFBQDScNzKulH
 XzsUGi00
 oNlq5T04rTAipEiNOJQ+8GnZDESZaJUEouo4xjAxH1B7Q9DdCjXSriSDG1Bki/7DcFAXqS8oOEEHk2klaXJttJ6BAXqGB+lSlDr7u5R/kc+fy3+DPNnWi0IW1hGfQs8jG6jU5rtbqIFysFNFXfeAfThgZWJaCEnodJOq0Uc2wo6o6lVattWu1kPHmQXUomRDvmnzXEwYKpBnmTHR+7DB+wH1oBHe6ox2lKqRVB++92b2PdNSIoNZm1nEsem2wRCS8eCZxdU8KgVQkFnYIr7SLpLmrHba5xhyGRS4f+HEsrCiw9pWXMdVhEGcPQqRozULh0BnubMZLjGqvsUoEqz2WsjGVJhT0SEYPXLD+k3HUDIyzEXrwCPsP4opb/oTju3ZX72qSgkQZ/rio86qOQgAYxhagSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TDX also needs shared per-CPU buffers. Use X86_MEM_ENCRYPT for their
definition and placement, and provide page-aligned boundaries so the
architecture can convert each CPU's whole section before registration.

Define the boundaries in the SMP template or UP data as appropriate.
Drop the unused DECLARE_PER_CPU_DECRYPTED() macro.

Suggested-by: Kiryl Shutsemau <kas@kernel.org>
Link: https://lore.kernel.org/r/aqqGUAX65s4LdJkr@thinkstation
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
---
 include/asm-generic/vmlinux.lds.h | 12 ++++++++----
 include/linux/percpu-defs.h       |  7 ++-----
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 64bc2bfdd2ec..145fcdbbe9db 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -368,11 +368,13 @@
 /*
  * .data section
  */
-#if defined(CONFIG_AMD_MEM_ENCRYPT) && !defined(CONFIG_SMP)
+#if defined(CONFIG_X86_MEM_ENCRYPT) && !defined(CONFIG_SMP)
 #define DATA_DECRYPTED							\
 	. = ALIGN(PAGE_SIZE);						\
+	__start_percpu_decrypted = .;					\
 	*(.data..decrypted)						\
-	. = ALIGN(PAGE_SIZE);
+	. = ALIGN(PAGE_SIZE);						\
+	__end_percpu_decrypted = .;
 #else
 #define DATA_DECRYPTED	*(.data..decrypted)
 #endif
@@ -1022,11 +1024,13 @@
  * Note: We use a separate section so that only this section gets
  * decrypted to avoid exposing more than we wish.
  */
-#ifdef CONFIG_AMD_MEM_ENCRYPT
+#if defined(CONFIG_X86_MEM_ENCRYPT) && defined(CONFIG_SMP)
 #define PERCPU_DECRYPTED_SECTION					\
 	. = ALIGN(PAGE_SIZE);						\
+	__start_percpu_decrypted = .;					\
 	*(.data..percpu..decrypted)					\
-	. = ALIGN(PAGE_SIZE);
+	. = ALIGN(PAGE_SIZE);						\
+	__end_percpu_decrypted = .;
 #else
 #define PERCPU_DECRYPTED_SECTION
 #endif
diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index dbe3267a0a13..fdb666a1b4de 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -169,13 +169,10 @@
 	DEFINE_PER_CPU_SECTION(type, name, "..read_mostly")
 
 /*
- * Declaration/definition used for per-CPU variables that should be accessed
+ * Definition used for built-in per-CPU variables that should be accessed
  * as decrypted when memory encryption is enabled in the guest.
  */
-#ifdef CONFIG_AMD_MEM_ENCRYPT
-#define DECLARE_PER_CPU_DECRYPTED(type, name)				\
-	DECLARE_PER_CPU_SECTION(type, name, "..decrypted")
-
+#ifdef CONFIG_X86_MEM_ENCRYPT
 #define DEFINE_PER_CPU_DECRYPTED(type, name)				\
 	DEFINE_PER_CPU_SECTION(type, name, "..decrypted")
 #else
-- 
2.53.0


