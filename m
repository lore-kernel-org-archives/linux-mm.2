Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76B4BCCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 16:10:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C41788E00CE; Fri, 24 Oct 2025 12:10:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B52838E00C9; Fri, 24 Oct 2025 12:10:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97DEE8E00CE; Fri, 24 Oct 2025 12:10:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F0EB8E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:10:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 519A01A0F0B
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:10:14 +0000 (UTC)
X-FDA: 84033494748.10.686FE87
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf14.hostedemail.com (Postfix) with ESMTP id 83DA4100005
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:10:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="kv/s0LHx";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761322212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tqVXyF+IsYXkvSZaiTZ7JkU0PjsMFTNFd+jvNj7uHBc=;
	b=agmxPcIAUUAKx3JvxkZatLwhcanomMzHcXjjCN5xAHZQTDV8m21d4rpDMWm1LOCuuVWhxi
	itE/PtxmmPGHcWQNZwVFUd+epeuwtQnSqvVr+3vy5ApTDAjkHadxBuBiAhzWYYfHGBC4Xk
	Ww3b8bRGpZcdrb+ESEnihHNeps+Ce0Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761322212; a=rsa-sha256;
	cv=none;
	b=06BE0qsHQVKiRlSRQd7QjGymyDrZBY+FpVfiUh9e3aa0I6uPAYTElnuwxdFaQCA9W17z+P
	/fAlHHluUWSR26gt3yEZ4dFI0XvPyo9whmobERNHFs/A8/qd8JCCuzZNhvtO9fEnp8a/Hm
	wrBYz+PGcpOFTlAu/WW4XLIGRv1V8g0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="kv/s0LHx";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-63e3804362cso2178317d50.2
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761322211; x=1761927011; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tqVXyF+IsYXkvSZaiTZ7JkU0PjsMFTNFd+jvNj7uHBc=;
        b=kv/s0LHxqKTYobxQsht9upcynQGtHbkUaWZO3YznjKGe/StG6leRwXowCQVofDmHCG
         3JSWR194x4to3yEDuU7BzLvb+5UCOISTP58LD7giVue7n7xtmXN1Smi0gVp7DJYwbpg7
         +bRzb6e/VQcP/iN1sVYYE9zkMKGsdbHzz2LmlTbbBPtdAj0h+J7KybNWgPwCCiJCtkIo
         WEpxJda+GnH3GPMqX7nOZ3xCKfMIAFbnaL8NESgl34wnbyiXn5gHKJLdkuL5Z29mvHs2
         gR1eWV0Gr0T9J856+LSfP1qb/xrP47aUZNffsAriWFsnzcmm5lQvYEDNB/l0CyrriNs1
         2mgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761322211; x=1761927011;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tqVXyF+IsYXkvSZaiTZ7JkU0PjsMFTNFd+jvNj7uHBc=;
        b=GXFHWQp+Lb/DpDm/YbfvtR7AVUyEWs6OkEVPGBtiytae1kQRet9bbciG9BOECYi8eh
         MNus2+Ew1hLM6aZgy/wQwTJ1BkVcNLJfy1bxeXc7Hs7/y2hrExULPGk7i9bT0tvgB0DX
         GYW7pHXSzNhAqL+aYSuJqmk/te0iq2Et39LP+7JW8ufDX9/TI5UTNHuVLWkqYcj3DbId
         Vebut+JRvj37rbfZOwYh0LjAoztKf7l5sp8Qtg1iQXUpk5DN7Ba9hbw7uDevPZDntclg
         OpUjHMIDxAHCCtMMJo7YRox2UJ59c0S2HdcHTbJWjaZWRzTSqG9H0m4tTWdxQUfReUck
         fNQA==
X-Forwarded-Encrypted: i=1; AJvYcCV/UWqLSBuMbxuG24WoGEG8wGlg9ezldAR+sKWijI9izOZIstHpQBt2kQv+zkrd107/IERg1cvjYQ==@kvack.org
X-Gm-Message-State: AOJu0YyP20GXrF+SBmE6uMFE3zDDWFVIsOIbQgo1PQtX38gQwdKvSrPt
	+sH86oTpmjjPDOcGCfc4cyG16mFBt+GpDnWEM6EJSJ6SFELwgHCFCKej4oWfGgceS3M=
X-Gm-Gg: ASbGncuJ777N+mayjZPdgyOS4fnaFihzQE+YdYH/+84USJdzuz/OwpbawqoF88YQAPt
	TQbfkN3s0kVw9brsS7v4NsWopP/xnytpTyHUe//CKvu9Lt2wFY5PYp9BDqOiW923jxmNzeoLgPm
	0nGiHD6ltXoxoa163yb1JK2ayCEGh2Dx3MvJzjxxvpOhc7fMqufHt+moN3DR0ZtEyYCgNuGnkFl
	uK4JnlxNbcmMYPF6qLh/9gVukLSH04aHKri2z2gk5naFYGeL8AjIGrQ8VWrMxRjMRuD1pwHQZkT
	cJnzmCToXkYI22xc8xO6jPSkx5Zgnm0ctUUzJ53CtQHRwPPNIurgOR4jmo3+Wv3n6taY1BAIKYW
	QrNMzX2lqq1iwqY3Nx0NtinVTThtm6+QLE5uTdMl+cmoubKjdDrbFHZ1JFJLbZYJI3aEwOSMh9J
	BtPsXev9K3prgA5AT0w6Ux3tb080M6zCqxXJ1p+MRdFMozLxWxu29qL5FQDvX80Fr1Cf6NeeTdB
	i9llDDeNBR1Yqbt2QTnH2WJC+SLJ2mO/g==
X-Google-Smtp-Source: AGHT+IE1Y1ssC3vDPwXKD9Vohv1X1EAngxcUz/MZcTAaLZ2Xt65ito/oPm7FTBXTLQh5v9nY6sOF/g==
X-Received: by 2002:a05:690c:4991:b0:784:8994:298c with SMTP id 00721157ae682-78489942dc2mr350965587b3.28.1761322209785;
        Fri, 24 Oct 2025 09:10:09 -0700 (PDT)
Received: from soleen.us-east4-b.c.cloudtop-prod-us-east.internal (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-785cd6edd87sm14099197b3.51.2025.10.24.09.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 09:10:09 -0700 (PDT)
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
	tj@kernel.org
Subject: [PATCH v8 5/8] kho: don't unpreserve memory during abort
Date: Fri, 24 Oct 2025 12:09:59 -0400
Message-ID: <20251024161002.747372-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.1.821.gb6fe4d2222-goog
In-Reply-To: <20251024161002.747372-1-pasha.tatashin@soleen.com>
References: <20251024161002.747372-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 83DA4100005
X-Rspamd-Server: rspam02
X-Stat-Signature: rk8sfa86rgcu9zip9f6pyzobcd1wm81c
X-HE-Tag: 1761322212-278595
X-HE-Meta: U2FsdGVkX1+kUoOdN9Td4/6QNIPLgMm7WADIIi1nEeeSoKHge0WjugVubaZgISGTRG7Tr1zHSiiaTwOHo/krE8aDDSEv3eUiuBdrdkBdl8H6TMV0osTO5KbSvPX0qHElyTwQXQBJM/wN8yXokZ0pZgGuBevfEvATzFizXFBOSO1/9b7rPXEm9XdJYXzufvAKAsg92Qucc6eP0k3PSgmytzwxU+Kn4ZQE+fFHUvkpaXUdRLWD2CHsqHTnLF9H1EABJsrvklhEDT1x2d0yxftM6GSEUyGVywm8mW8rCsrGl6HHgGxLDlGEyGkTf0qloX5mLo0jridvZVNrrf3iqCnENKRc/mMe5Whfg1gIgQwucqQUwYvIgIbR7ft24kZj/nYWqSZr6FFcE4/yXpkighDWvL74C/pbcYA7AtlxdxnDVQru1z7AaWX2JIRrj1ta3R3rIJwavhzEF8lgf2aNw8ZrUzJERpfEG2jJQb4KQ1ba894tw69xbfu7uAFX1FzyWQuq8Mgh0LPoesylBj/f9rS6rRDMWT1NasMwuyBUHO9i28nX2104tBw2nuPRj5mxbz3w+N/XODaOx08svIDeG9nHCWEJHrYQVmwzQIMjFryl32x5rRpG7kVe88G8dsipZPfD7CKETO7yxrdgC9J2V6QHth5mtM2ykd2Zpj41aTfqPpxXx3YOk3npziIaHasK2YfrQ1El/Nl4dqqXL0JrGOtYzz+82pRfRgwDPrPoXCZNushWPXkQ9ajClGt8gtZwIW0q6ryYqRtOtxkq5Jf1mBJfjQu23VlxnSKxRBVgBSn1xc54B2D47wLLmEty4BWdB/VGNe+kZV+T4MdR55KVaLoZD5qVuTpqa1BJ0j11kw3eqA56IMD5XFvta9PMXHiT2NrWcgIv5OjKG/pK3Q8f6Bl1n8NMJJAosvYGK5TVMdxSSIiY1yczs+/8y9hXmHSH1GFyoFTf8A7smwDgh1TVost
 cq4sBP/U
 QSChoPuMiqnA5a0A/6Gu+Aa2JLRKZgHFnh4eb9hL/S+IvQxZhiGPcVTDo/k6zFxEm24p9XC/k571S5UJVnav+SemOVjYWVRVPyhKtcMAFZHtcAfKBp6kV/IZdopDvdLZ8t4z6GeAPoTObwPSnXajK5Pd8/h6LgXOLQ/JWe9x51ohHvQDP5+lQZt59D/9o4dWVf+KcH6vfQPdmlKyQML9/e3hvHx1G50CpcGqpYXFNqOO5apNtNsDQmCAO1tD4VFjnsqOP3xDwiiqZrQPcLXMXWYu+6MV48GVNbC8/
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
index 994ee0b70757..6aa25d304bad 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -1098,31 +1098,12 @@ EXPORT_SYMBOL_GPL(kho_restore_vmalloc);
 
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
2.51.1.821.gb6fe4d2222-goog


