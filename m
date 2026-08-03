Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A873CC55196
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 19:43:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A437F6B007B; Mon,  3 Aug 2026 15:43:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1BCF6B0088; Mon,  3 Aug 2026 15:43:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90A616B008A; Mon,  3 Aug 2026 15:43:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 675976B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:43:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7B6688077C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:43:00 +0000 (UTC)
X-FDA: 85060981320.03.B84C251
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id B5B7E1C0002
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:42:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qbKoRxLh;
	spf=pass (imf18.hostedemail.com: domain of maxi.saparov@gmail.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=maxi.saparov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785786178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rwuoYLIZuv5ApTNScLZwtjL2AQGWD4RWVJHiBkDbMFE=;
	b=bAUVswc+M+BD4ZF4eYfy4m0RR+GZ62Kbb9P7zfbMOJ+xGMJJe+DWmq3UKA50KYPRKQZnkg
	cXdHbC64pHkCfMQM3Xy54u1avq+LQeJ3OT9ZMOJJOYHiIa5UqmBWzIHrebUOl2v49ep5J0
	mAhxF/8gwv1jwSw4gjL5kmjId2p0Evo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785786178;
	b=CO9cZiCvMZmUFXGvLVMW+NhyCflqkV5K5Iifkd6pCRvNGDeh/8UhIYSP732UaUPfJggqWE
	1K9jXqHQTFzcsAqbEX+FO8wIOcbMnU1jb2kzl7peSOXL0Jnoii8xwZY2lwIh0iDIi8mjSh
	KZkxGAKFgFkHO7Lp5RE+fsAYMld5SqU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qbKoRxLh;
	spf=pass (imf18.hostedemail.com: domain of maxi.saparov@gmail.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=maxi.saparov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-92e533aacf2so182067385a.2
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 12:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785786178; x=1786390978; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rwuoYLIZuv5ApTNScLZwtjL2AQGWD4RWVJHiBkDbMFE=;
        b=qbKoRxLhBXcUw31cryTc0QEnuFsJlm+wkYqMEGQiJuTtoLSLPxpYIsDebVzL1dm1uc
         MqQoiGSmDj1OvDJDlHFxQeTcjcb1qvudCcKJldQP0cPc7+e3ibg+IvcU07DRuzGUdlm3
         QycmFLFwN5FZjSZF5LahmnqW/A58tf/UY4WDuD8FHrds1baRhAV14zPjvfl46MVX1/VL
         6jVQPWekSUrVZAKQ9pMk5EZB8a2vLRALUTICXKmxeYjPMoh0atlOiqrffdDfEZUI5vaK
         WhcjZGCFUGhvuJIgMtlFpmshDqXT3at9hoFY5irKP4PreEq9prPheITkllfXfksxbNZ4
         CGoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785786178; x=1786390978;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rwuoYLIZuv5ApTNScLZwtjL2AQGWD4RWVJHiBkDbMFE=;
        b=ONYIgwKz9WBGlpPsYDyDwTjbCHh4g8wHGGwJc7w4W4rC8veVCuI17ikPB06jX2BdOE
         ZpCS6ZwGUOY9fQQk5lSFSsgtGXSEr/Szty3+UazELHB2XUUpoYNxXPh8v2IvDQBl7NeY
         0JUxc6tVYC2fbuPHYWqwUJQzcVL0E7mQmWWBDuK6r/9W7GD7NSB3rREMIn/qsDwaGttL
         XA5GHSa6uffu6iF0Oz07fRg7YgSBtWFCndMqBNFRJ3vtujXTdvfvKKutS5K8aagh1mOU
         2/9qKJNtypK/H1odxpS3eImq9b8i3ePB//W2TbiHAQAHaPbIHKs7QvlD0Qae05RCXjNa
         KEXg==
X-Forwarded-Encrypted: i=1; AHgh+RqtjNrh6dS8h/lLBJn0sXk9m1rdxxg0trl9zBF0wIGSEP+jsFAK3y8mt1pndsn1y9KgqMrf+umrZw==@kvack.org
X-Gm-Message-State: AOJu0YyXh6O/BsfyIMmdhbgrm4QUZrPUpDwAjeqjqIwwTMdSKUnIlwlJ
	M36QQBOFaaTUqp+TIlc4rBnCPci10VKuZzmpnY9bjqzbFnKTmjdc1bGL
X-Gm-Gg: AR+sD11mN/io1rBG32upEh5Mk4gM2JJN9NmwtKfq3w2oLB8aWnXSqC/2E2TcUavVR+A
	dIf8WdwCQaA0MnOXCry96iYcSrxFzofYSuj3xCS6RQcSZz9D+uv7Dy9BzL2FNUSG08ecnh2dXmn
	OAU9tbv08RPW3xb+sjiwufmZ7WfDr6DJ5jqyHTlDlW+3mblv3ia75HpJMmgCeQ24PbZtJp/ofC6
	xHY+uxMThHqrwMqW/Mm7e1aDIbJVAedmdea23kQvHMX3vej1XQLqDtibMyLqKili7XkpO3LkJ6C
	+X3Nb+CorJxIJXsJszPM6i7BmHkB5pJ/jdZCz/kTf7GZwBhAqZw5Qq4iQOEsnWV3KapQiveYZTl
	9JPN4zqDXQqXc2wCCoeUf6OZ+6D78r0Z6yBHWC/bAix+0dDBOeTGVJHUjrq9bcy26+ttx2J8zkx
	LptQDCiLGkhlN8khBd0xEaIHfqpMCiKVY5L1/xmTZsYXFSDIaUVk4kjX1cHlwKxp6jZTwnhECry
	BmATG65AMvfyJ6bFNp5Fq1Z0pyUdh95CW9QAr9H9rj/xM0H8Nj8Hpc0wTqPLBgoWmWHXPkH
X-Received: by 2002:a05:620a:284e:b0:92e:db1f:185c with SMTP id af79cd13be357-934a0aaee08mr2254503585a.43.1785786177782;
        Mon, 03 Aug 2026 12:42:57 -0700 (PDT)
Received: from CW-D0XG2Q16P7-L (pool-173-68-111-115.nycmny.fios.verizon.net. [173.68.111.115])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9349bc25410sm729451885a.7.2026.08.03.12.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 12:42:57 -0700 (PDT)
From: Maxi Saparov <maxi.saparov@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>,
	Evangelos Petrongonas <epetron@amazon.de>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	sdimitropoulos@coreweave.com,
	Maxi Saparov <masaparov@coreweave.com>,
	stable@vger.kernel.org
Subject: [PATCH] kho: do not reserve scratch memory in the kdump kernel
Date: Mon,  3 Aug 2026 15:39:38 -0400
Message-ID: <20260803193938.8778-1-maxi.saparov@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B5B7E1C0002
X-Stat-Signature: usnrtu5fbhmfbs41tj55qcwj8d7n5rw9
X-HE-Tag: 1785786178-687341
X-HE-Meta: U2FsdGVkX18fTEFatLYVRz8OAEyKiIPFnqzKmO26Oa7KeACyDeak2QGPXCTL9Gim7/YMNbD8eCnFy4sMXQcKzebqY4SY8Ief8XFFQ0rn9ZuLYqxKPVv58ZO2NmgFaBGOUdZA/RfIvwqWiTQ41Jf3BhoZcRSU7rnXtTkby7LjBeFwnLyVMUk+iqe8RBJV8NV1CB9rGZs+K9sg1GmPKZGajq58stehal3wEFwTdFvyZi5dUXSIHUkJKYsOFYoNPub7q7AyJjBcf4xGt2bYpWMyJNi0aeRAlnZ3rk3+U+ZNhl7kwfP1IUE5et7w1ea3K/T14sXWeS8jWcA2gd4WxN17cVkCECmOl3G3rUZ8THEjzdVdycVyelLk/m12weeMHMqW3HAYV+Unswe4s+sS2fD1d3lXJmSUUuJqhkgJUNvd52VA38B6X2fBENYOPclfzQ11D9I6bOZ2NkIB5auLX7VYXBY12/lKJ0XgJ5dJcM2dQi5HV61aEgn67ZsLuqVW8iE7TItoY4WMrLho5vBwHThOczkynIFL+i28t4NtYsQZy7cZzw+kkQe8sllE32N9zMJDMTVuvR1qic4iFyOsRFKHgyCTaw2f0zEX20ms7Z8E6zoFrtRVsfYF97EblwaPJVotEKfnmXuBJ6GD8oWWAbtsFyITaLDFVS6kFTtT/0nc3UAogHgImPj97+c0ycwmIukBARR5JNU1vbRz0JvxuMh7DcDyLK3ln2Ut1whBTmYulQKHLcCP2CzEUFQSPARgufc1n34NhZsOKYplRlWqcYW7VIrL3RTW2JSeHlH57HsiGaq2g8486Oiiy5BusRdNZorKP/WvALGf2z+gE2fUE4CHejEUnUWc+TkKSItH3HXsiSFol0be76hCQ2uNADoaDGW8aV0ZjLT458/W4bBBIWebym/3ayvp/l6Vtj+4tXZ3xWdjFwMvPyzg3eH7dfeaF0bfxGYMZMM3rkvYjPQd+pr
 XsKH3IZL
 z5EJURdS9+Pu0JdZqLjUlUeJFSht3BzM9EDTK19ggiO0EZRazGtDlHIbGhEHWtW3mN/iF19pTuEEtyF0f67CXhVFBeXny9aa7sN/TOGU3NdPT5M4NxbXoyIjf67T8vtf65XRQ5tusatkzKMG4DYmzRvwqKfd94nj50wDQDrTiEcPIBRaOYMaFm0R+FVWxGpv2Bfam5DYCJWG+5fBcAmjMuV31OgYg+UnM3Sfyrswqf8WG8X+sl+pLVqmgnf9uEn6/Y1GY6M0+fyToFIa6T7CKhLragqLs6zV2aJX1eqr+mKaF6rZlvmYYkY7GMopyv72BIWp9UOYJsY0G51agmmTegiNWnvAzNKIhfNbEeY9hQRtYigMIrmHV9PkYr2j9atqlDFAfgjYFlpL5evJZjp4PDJSrOSxNf0s9w3bQ5gQGI3nGi/tfEuiiCrHR2S4yfid0d0QtJGG4QAAaNdeycQVMmxH1o6NjfbzEBXHjfXoPqTPk9txUPmKg484drdMrvs6L1v0M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Maxi Saparov <masaparov@coreweave.com>

If a kernel with CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT=y (or kho=on)
does not receive a handover FDT, it reserves KHO scratch memory in
kho_reserve_scratch(). The function computes the sizes from the early
memblock reservations of the kernel. The default scratch_scale is
200%. The lowmem and global scratch areas each get twice the size of
the early reservations. Each NUMA node gets one more scratch area at
the same scale.

The kdump kernel always takes this path. Since commit a6715d7ec472
("kho: skip KHO for crash kernel"), the kernel does not add KHO
metadata to the crash kimage. As a result, the kdump kernel never
receives a handover FDT and always reserves scratch memory.

The kdump kernel boots in the small crashkernel= memory reservation.
On our x86 hosts, the kernel and initramfs make approximately 176 MB
of early reservations. The scratch areas then use approximately
650 MB more of the crashkernel memory. When a large early allocation
fails, the kdump kernel panics:

  bio: can't create integrity buf pool

A kdump kernel has nothing to hand over: its only task is to dump the
memory of the old kernel and reboot. Disable KHO in the kdump kernel
so that it does not reserve scratch memory.

Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
Cc: stable@vger.kernel.org
Signed-off-by: Maxi Saparov <masaparov@coreweave.com>
---
 kernel/liveupdate/kexec_handover.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 6fad9152387a..53b59edb5b36 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -12,6 +12,7 @@
 
 #include <linux/cleanup.h>
 #include <linux/cma.h>
+#include <linux/crash_dump.h>
 #include <linux/kmemleak.h>
 #include <linux/count_zeros.h>
 #include <linux/kasan.h>
@@ -1636,6 +1637,9 @@ void __init kho_memory_init(void)
 
 		if (kho_mem_retrieve(kho_get_fdt()))
 			kho_in.fdt_phys = 0;
+	} else if (is_kdump_kernel()) {
+		kho_enable = false;
+		pr_info("disabled in the kdump kernel\n");
 	} else {
 		kho_reserve_scratch();
 	}

base-commit: 3a0b8fa2eb36afc88b62a95f33f0c77c71fa5ded
-- 
2.55.0


