Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53C07CD98D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 20:36:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D52406B0005; Tue, 16 Jun 2026 16:36:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDB896B008A; Tue, 16 Jun 2026 16:36:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA3F66B0093; Tue, 16 Jun 2026 16:36:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D0726B0005
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 16:36:43 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E13BF8C86F
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:36:33 +0000 (UTC)
X-FDA: 84886933866.16.BFA3435
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf04.hostedemail.com (Postfix) with ESMTP id 20B7F40005
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:36:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KmhSeddz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3ak4xagkKCCUUBSVOTBIVHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--tarunsahu.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3ak4xagkKCCUUBSVOTBIVHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781642192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jd6aM+E7kwCHb8eK+55ADMe/nKQDxUMiF45qEHRKNGs=;
	b=8f69PHsn9oMf+Ss6ufgASPmPiT7ZO9oAC4eMVV6HKbxL2E1TuWxywmZxsxVMk0MgTTZhys
	C90xuvcUwcWDgStNDaQixA6WIqj6OKPOkNXbsaSpQx/7tFXZBSvSkLnTE//pvecRy8DEiQ
	MdVQXVmS17LBhLtPYZkxFrQvEw200og=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KmhSeddz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3ak4xagkKCCUUBSVOTBIVHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--tarunsahu.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3ak4xagkKCCUUBSVOTBIVHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781642192;
	b=WX53e7ChlniHDNI9ViVOIDlSX7fMvYvMYxsyk3O2hgf7sTBNBebVc5TV2eexjAoN5PD/nc
	VhgfNaXJqla7TO4GsDccjF0cPTIdxesNqqtclkI089Sa7OkeETKhuzaKlNHM76QIqDYxwG
	KOwcNSctwjYcrOvtRAvk1YoEt+93s8g=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-bdad545342aso627406766b.0
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 13:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781642191; x=1782246991; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jd6aM+E7kwCHb8eK+55ADMe/nKQDxUMiF45qEHRKNGs=;
        b=KmhSeddzzRF9j1N/sIXrSc3qgbzg6JE8rC9xhJuQLX9c9a29FRrgCMmWeSSdgWD3jJ
         GfOxORRzDak2HmRumAO+cp1BGbKsbqilYW5OT/xmg9pUFXxklWOPrWPtFbn3eCI5IwOj
         V+gsFolfh7WDdX5fHzqLXJqif2Q/tqPy3aQSYGvfxsHZQlsYGTs7pgyZvtsh6op2dHvK
         1yJz5sFULlZdfuex+EYx/0RewgQw9FKS9e2uZsjSnyB7IGIRycW27gQqRSElHEbCG1xr
         K78EFtrx/crUdUYv5Sg2hdKvb0zalUd5I7MfGamJPTVmOzJEiAH9I3NkJKOsK/LwpYuo
         B5iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781642191; x=1782246991;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jd6aM+E7kwCHb8eK+55ADMe/nKQDxUMiF45qEHRKNGs=;
        b=VpS4TAG6gydkY8NJoaRE6aw1/ACXv0nawt7DRELDa+6neDzaEVO77kkSSPAuGVlroP
         6Rft/7GN+mITqbTOgA1DtkTHez0lsRMLWQM6AT3niXowJckgYg1erdZRUcGB0tHQMhqO
         spI4iE35LPrqVlQzADN/Dtyh9GJlAJt9Qvb5TuoYg44KhXekKwXQYm/UIrbvFojvLgp4
         rYvJNzyHYzsNuG3hfPsmPc2+JfBcta12oUeYLq+r44on8FVVsXx2HfxxOfQwvU8+FlT+
         zJMcB6TXhLtVvfXapRBWkxGGx2Oer+rOJ1YGOQdeSApF01wPbisdz8DQtaeVXGizx13X
         Ptlw==
X-Forwarded-Encrypted: i=1; AFNElJ/O21TRWQAezofq4gcdGS/V+d/6ZpLNTitWTyNU+GeOQ51ChqNBTtg7WyYWpe4niGpsjAtGzeu8AA==@kvack.org
X-Gm-Message-State: AOJu0Yzf7JwVadVByQkx+ROGYOjPzqIFct2sNA4hIXBHKHdHVvLhMAeD
	vtXnWniTyDNNq9XVuf/8fDsP3kRy4tFMxMRKaaDJpKipu25cPPSPny1DSylYjesNH3x6Y+bAcSa
	5ejINfskINoO+TFDp7Q==
X-Received: from edf28.prod.google.com ([2002:a05:6402:21dc:b0:692:3d87:5b0d])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:3707:b0:68f:c63f:1ed5 with SMTP id 4fb4d7f45d1cf-693c6a9351bmr6482036a12.28.1781616234872;
 Tue, 16 Jun 2026 06:23:54 -0700 (PDT)
Date: Tue, 16 Jun 2026 13:23:50 +0000
In-Reply-To: <cover.1781615759.git.tarunsahu@google.com>
Mime-Version: 1.0
References: <cover.1781615759.git.tarunsahu@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <242340780dcbace523a7460953ad754cc0016217.1781615759.git.tarunsahu@google.com>
Subject: [PATCH v2 1/2] kho: add KHOSER_COPY_TYPE(UN)SAFE for phys copy
From: Tarun Sahu <tarunsahu@google.com>
To: Alexander Graf <graf@amazon.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kexec@lists.infradead.org, Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: w1pmr1h8ieaocq16ketu5eosj78zgwah
X-Rspamd-Queue-Id: 20B7F40005
X-HE-Tag: 1781642191-409907
X-HE-Meta: U2FsdGVkX19hGgbtvPa9VLsqfVm7V2q4gr4VtjKxpY9n1edVhe6yKjpRIikM2MuKGlzmY7t6kQZaEL3hMbW2jRSAkgi0lfXqUEXRQw6U/0nMw+9eMT5SvKfyegiYID0Yk+NcN7SFETmeQXFRWHtWt8RFgD2uRTGVNh1M6J+VLhT8HXV0echGd8sYNMjn/ABnFYRS0Cg/ApmQgcrj70g7u/Z/kMQeSGuzYvOQSXI84oG7bOpjpW29dBUEymo2vM7Of908mLp0m96JnCAi/9m40IhyRsHNqxUE2RmMFoeFs5d2jAOYpxCf6yJE+5nJ3Wq9n6plIgx8co26Wpw4ckVEtQ39HXCbLryCHUrV1M8pC2xw4YdZcItDbLY5GTZdKqR4ffNGYOzE8+QyfKQIvKSEl5+57vgd1aq6HTWsDw2SpYy5d7QqprquUmCKA6FdaR1EQlNmQcnobkc+7SqU0nofNNV23K2TJ1X3hxiHJjXZ1Zmw0Zx8a7kpCfh26aXecRuDQJPK+kTP6jPG9QGToh2S5yxTdzUb8UrJBLNWbemYhwu9VOu0Kivtv0FHecrAon2pjcJt/xoi1qECxIGd1ClCkT99rSwAPo8LKysVvDUzxJDs8eLQw5vHuWEPUgESFyXIRJolLcJCMtWJ/IJqBEBxbjDZopaI9EE0R0f5Emd0NLx2I9EVWXViiX32pWIJg38aAeU+6gS48yCCK21z8aCvQV86Np9R3wTQ8WIBziNEob2vTtPGRzDQKGJbIf1jMlqap7AGrGwsgfaYtPVtitxCrDIv0lt7TOk38VSI9eiZcy/wrbAprqNt6AZ8mWOFWQzEwxxt2iB5ZthAplwJ7BFrofh4L81zs/geAY/wDZgVJ0U7LMsVdUSmF9yVuP1CGZE/rBDmFvw7rYKD2dBua5G9DDfd8lz6z5FOzIM5OHUZ2VAwELaKUEQnFy1tb03GefIQM7pa6cpiXcAUej2ujDc
 cdGXKHrJ
 ETxauZxHxOPBuqv0cF1Ekcx+WlWWfKkHJdrWytDSWjsA6vnfm0qb+aNSGMM7xY3aqkokGzA2yiwEVRiVHMeyejnQzS8XY5GGoP1OIYPezmzfylal7XYPLLuUAuvLzVQPSgnVBQUAm2Bx3w1B2k+M5GHAAYGLFJNsUSB+4B1CsDIC8fyy+g/V2HLJLSB+MqO/QGLFeyH2sjCgNK8Jm9t6JUB/oznNl+m13utJRuVR3mVEGU8RGx+aaGTTaI8yUNdT537iDamNXuQDMbCGUY0vSW6smaKVOIsOX1bdHyGXjWMRd8R5V0U/1FAXx7B9Xmep2W0Tkd2NoMDKiqKiGMasGgA68g/DmPBjuK/oCCsq6f4ug3tPD0LFhwzXetMb2w/fRJo9mIvpA4o130bY2d1BS1S55NT38Se5MU5Bg1UYAvb2i5gBJTeGAnHNtnUok4dGPDiVpjFnxWpwKVN4SLnz/z9dl6NqkxJaPFvovjsamEkjGfb04iTm+3GxMnkgm9of3fAX4M6U2Ahtt5bqDdXZaX9Fm/ICqolzNuYII7LQNcLDZIKue3Bgku7R8v+BDrFM+jMto6kut6XLJwhaeJSUNi6QdJpjFho27qnHIsc67INK0tApVDCAvW7sS3RcjMbjmVTtpyZtHocGNgRhJHr5TMcg5xvTACDkz8CerEVRUs+BN5xGDwTN5CpZCblvpoDgYr6CP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adding KHOSER_COPY_TYPESAFE and KHOSER_COPY_TYPEUNSAFE to copy one
serializeable pointer to another. It basically allows copy of phys val
of the serializeable pointer.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kho/abi/kexec_handover.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
index db9bda6dd310..1606369dc1ec 100644
--- a/include/linux/kho/abi/kexec_handover.h
+++ b/include/linux/kho/abi/kexec_handover.h
@@ -139,6 +139,18 @@
 		(typeof((s).ptr))((s).phys ? phys_to_virt((s).phys) : NULL); \
 	})
 
+/* Copies one serializable pointer to another of same type. */
+#define KHOSER_COPY_TYPESAFE(dest, src) \
+	({ \
+		typecheck(typeof((dest).ptr), (src).ptr); \
+		(dest).phys = (src).phys; \
+	})
+
+/* Copies one serializable pointer to another. */
+#define KHOSER_COPY_TYPEUNSAFE(dest, src) \
+	({ \
+		(dest).phys = (src).phys; \
+	})
 /*
  * This header is embedded at the beginning of each `kho_vmalloc_chunk`
  * and contains a pointer to the next chunk in the linked list,
-- 
2.54.0.1136.gdb2ca164c4-goog


