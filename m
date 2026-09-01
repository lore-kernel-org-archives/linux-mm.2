Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26D82C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 16:53:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DE5C6B009E; Tue,  1 Sep 2026 12:53:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 168CD6B009F; Tue,  1 Sep 2026 12:53:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02FC16B00A0; Tue,  1 Sep 2026 12:53:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C1FD56B009E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:53:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2C45DA023A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:53:24 +0000 (UTC)
X-FDA: 85165789128.17.8DCFAF3
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5DCE840006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:53:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nKMxMgBE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788281602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=StFN0pa1Zvrg1UiKZ1dKZ3qIfBRxQYisRtQtzyiPhrc=;
	b=hhQFxOJkfGRiPmJZK1ZTEQleQBET+m0ZlUbOgacl+9x+bpXYT02MLZNr/88QZeBCe0y9V9
	l/TvSlK7t7vHcs/mC0gOS6XvG86LiyuU22pgfnHv8pK6yciHZhe7WlVkk5JR0eRqA1YEdS
	XdvH11n/Wpus0doUzQ/STCCX7wjz7H8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nKMxMgBE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788281602;
	b=TuBrJpC0MfAKgIgmn1Pfv8eJ3Bk7P75qjsiab6+urxscNeSTYxg/vymJ87CRGQ6XrjdCmU
	mYyBmJfYVajeqA+cTn2+YoaT0nVSqcrA80GsRAq3p5fNQeBPbq7JEDhA9Ow1RV6fkdKTDl
	RnxeIuLXeUfYNeuzdJ93+6pF5g9shqY=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2cfbbdfa60bso13641865ad.3
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 09:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788281601; x=1788886401; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=StFN0pa1Zvrg1UiKZ1dKZ3qIfBRxQYisRtQtzyiPhrc=;
        b=nKMxMgBEdaP/zsi7mTd+ep1megQBx4hTF6thGaJcVQMato832t22hlUyYhVOLlSLie
         XoELshNYHQohs32Ur0onBaagQ+AS/JNP9TjBZAGPavHgIQbfJbHoZJsd4REtRi4V1j9g
         bqIl6xFuds1TnZfojoy9hjBF9d76lFJef6qbA+427UZhl3Wc8wxRd6n15KTswULOO0Og
         R08xhGZZD/swdBgJgNuefvXJxfVNLgyLqNMF9pOi+7F+0CLnC1DQ1infFF16fGk0HSBo
         prdOCFH2LMyoqU5b3qtg0CUP/KVJ7cr1zZ681vb/INmGYC1OKRxRfLRWgRN5j6ePMKf3
         T1cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788281601; x=1788886401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=StFN0pa1Zvrg1UiKZ1dKZ3qIfBRxQYisRtQtzyiPhrc=;
        b=oV/KGCrIjLTjJt3HT7LEhqq5Tbcw3fuDG87beKUoDCPNwB2Tx2Xt5IaUSsnFcxnXlq
         e5hEAfYW4lbhZuf7ASAGA2q/4l4D1VIK17qB3e8ig2VsFi2Qdyxhk8Ky2h2N2rn+/xyn
         CfSwhPjkgHcCNiEe6VVS7kHpXu/z+dcsJjnHbjpEKMz/ich7T82geMB2/5tUoQOYo8Mj
         KcoCwxJXLqjW56h+bRa8XTv80rUcsWyMQAvOlQLQPGhmrH3BgBwlIf4r09vwbw4qXZAU
         +iER+WVALswNq9Vksw+SJ3xioeUHrz7ssgMzV0Ce9VVwp9sbA27i0kF2efT5SyL//QgC
         8dFA==
X-Forwarded-Encrypted: i=1; AKwUvBwghrW9jNsjMEqwZruz2tAVCwPBMA2Y6OqLPO/tt7RsoK/SIkduWLhKaAOwnZAExXNyUdSEvp11qw==@kvack.org
X-Gm-Message-State: AFuF++ngjMxBX3Uj5Aql/hbp7Edf0OWJ5hrH7YWfitUYMC62C//3ggT0
	/Dp3HsVBMsf6TO4gdKDITRtGSPGbCpDzEnwgetIIzsFTUX2w0eCGfA4W
X-Gm-Gg: AYBFou1MPOaOHDJBzVuAwgP1SUNIfwgoVIIfbVIN3W/wwGvc0kk7R2rn1T5GgcEfreG
	1eroP65hqRnv9cs8WRtx162VBBHKfYZfv46oWzPdR9kiZPhevLTCSwEAJlrPQngSOurQFaqbTYC
	WKQCU8Uu0fDXMKsogezdptORg80O8tJwOulW2nsyhfNRdsaYUZtUXaE70CuF8Xh3bCi5Ce9LwC7
	1+8vwx48QsdaOfykMT8YnR7bRob6eOALYrlyu2UqLcrT1DwPFtOxva1q1/AzYa0MRkFEGV6bO7m
	BWJCY6uEh0awJr0nIrgCSAY9dFmDP1SVPT7ksxc+jR3DrbrruOO609vupY3ofXg842Ci7nUFmMM
	r2ZN/ZiJ7L6pV5BZj0+hbt2fd97EZqouPDo1LGcB/Ty7ARfwSxT9b4+e+lzN3vsWsvcV58eCIfD
	zkCnfK8pkjJ/jBYnYsc5VLmjWizfpt0dU03XxNOdRut6HhbheidQJ6WUw=
X-Received: by 2002:a17:902:f68c:b0:2d8:d4cd:dc8f with SMTP id d9443c01a7336-2d8d4cddf3dmr340213455ad.18.1788281601095;
        Tue, 01 Sep 2026 09:53:21 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dadd357efbsm1762325ad.4.2026.09.01.09.53.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 09:53:20 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/4] percpu: remove redundant assignments to bits
Date: Wed,  2 Sep 2026 01:53:01 +0900
Message-ID: <20260901165307.1026248-2-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260901165307.1026248-1-ekffu200098@gmail.com>
References: <20260901165307.1026248-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: pe9rz63wnqw1q13c6s7hm45zya1nuod6
X-Rspamd-Queue-Id: 5DCE840006
X-HE-Tag: 1788281602-154148
X-HE-Meta: U2FsdGVkX1/l0J4Ao5uZnMvVfvo+crxQ9XLFk81jZCF39KjTrKmlekwbfPAcQlmOrjXDEzrUyEs3UrkleRnkDFYbgnM61g3KQfHg0VAFdhqfQUACNkSh1UxdZONz07GLaeffVAeq6kN1WbHm6lnkGockyr4gc4T/UbgKrjRvLkBPC2bAmIqiw9ZsdSt0aNpBBYR+o32bmvKDl1bOC3c6eLheL7dIUwl7NC9rPtLXprFJZicAr4qkVjaw3uMjZm8EUf3oG2pr/GXDxP3PKyCYLJgzwH8IoeNgWvXsxNIwGynLTxPqBTba9R3uiCWOzD2J2ATevAEeDBARzjY+SnCPw7eDO6pQ9fQL14anFr3KDr6tUrVOn5dZBeEVMbeTS0Pwu4JNpWO4sxrDQhPm7sDvbWeqW4zAatqUk3BYMT75il7oz3TRmfNkJEsvodGYrxtBQkwmrfVHCEwvSHFWanaFUrXvw2Ak5eiMJ+/FNn6TiEaT+o28jk2kDZMVOhct3pTY1PgP6u5u7U2rNWE8rHT7ByR8BjvGoVgz3td6Q0H8aaBE5fW9Lu5y4KNgT68m9Mkc9dfNOarBvpcDs6vpvEv+lZRtv47SHKsX/kREYMsXo2IBLkNGaOKZ6VMBxvOLMzUXvq65dKe85IfMb8UBByerszaIonFVcqNsB0LbFRBjv5XkBfj8/xdHB9CobA1opHxjPM5rainadMMcqG5DmicR2uArx/Yt8qkBLbsOahiwEslQHrBRgQiMZR4MhTDQxhDmggOI5EWlYN23j4EKvQ7RuxwuVsQ8NJxTukxmddMKYxFLVOTq/9vKtqDKYGNFKYmi8r5yLfmjn7ogvsr8S0U0RNgmOr01OIBESqJ2d+Wqk7vJ0CtozvCFCPX3Fp21tvmWAYYfji3f4N+O1FkY4IvIUtebaD+OnVOo2QD/bOzRHr2UXnG2twtKy4x3FUCqEtJnbLK2Iko7Brx5kgXpWO+
 vXrcmHSm
 ptet87lAz/kVs6unJUkjIFqrlfmRGG/e/74tkVRbtVpL8AYVLVohMfL1lRTcr13Av9KHet5Ep6fXotsExE7Enqw/4PALAkx2D9Up52cm3CckPVm7/eo5VFlz/m15XiWCTyHrH2x9nlmEZdcHGcYbLp732DU3XnIOWYzj7HjqZDAFnGqhvdDQ88fw9lBcwxWbNHoBpPYCPw36hJzK3llJdfl4FmPF0CVm5cNrG62ubcY1RWbnwTjFF+Zj2ClHo5mhK8B3nlt553vyY+/lnX4/jA++tJ2V/JUTi4j4n6two70UTaZ5XQQF3DYhefwhBtEP+EaVbmb3itURytfquR6qnQySoEvRE5X4qhhDyCy2XB7Gri2+c9VOzJDVA+a4NjbohqTJvdV90pjCyGzkbbZdtxljfgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pcpu_chunk_refresh_hint() and pcpu_find_block_fit() set bits to 0 and
later call pcpu_next_md_free_region() or pcpu_next_fit_region(), which
unconditionally set *bits to 0. Nothing uses it in between, so the
assignments have no effect.

Remove redundant assignments.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/percpu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index a802d72c116f..5700385fe6a4 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -758,7 +758,6 @@ static void pcpu_chunk_refresh_hint(struct pcpu_chunk *chunk, bool full_scan)
 		chunk_md->contig_hint = 0;
 	}
 
-	bits = 0;
 	pcpu_for_each_md_free_region(chunk, bit_off, bits)
 		pcpu_block_update(chunk_md, bit_off, bit_off + bits);
 }
@@ -1122,7 +1121,6 @@ static int pcpu_find_block_fit(struct pcpu_chunk *chunk, int alloc_bits,
 		return -1;
 
 	bit_off = pcpu_next_hint(chunk_md, alloc_bits);
-	bits = 0;
 	pcpu_for_each_fit_region(chunk, alloc_bits, align, bit_off, bits) {
 		if (!pop_only || pcpu_is_populated(chunk, bit_off, bits,
 						   &next_off))
-- 
2.43.0


