Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C606CC43602
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 15:05:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79D5F6B00BA; Tue, 30 Jun 2026 11:04:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7757D6B00BF; Tue, 30 Jun 2026 11:04:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AA476B00BA; Tue, 30 Jun 2026 11:04:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D1266B00BA
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:04:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4F45B1C5D5F
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:04:58 +0000 (UTC)
X-FDA: 84936901476.12.66407F4
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id 71C49180011
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:04:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gyUz3kxH;
	spf=pass (imf06.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782831896;
	b=OqkimZPWno8v4DrvQNv5IOLTfXY7plyUVc5K7Mfo7dh3k18by7pVrnZK0nZ0+4spqSJKWB
	+FG+T1Og0NbVh8XpM8etb8cZBKuj4JMhqxckPM7NoQ638d42IyR4Iez4fNPlwJTY9BQ6cz
	fvgzZtpw9k7VvEv9nKIT69QsSLpnUIk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782831896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RxV5fEpsJGHhE3L8vdcj3Th/5v0heJ6mrreI6jrRPh0=;
	b=Qzi4LSa/f7xJP9uhKxJu0Pt6r2Crine8Iopn19tZk+MVaV7Rq0MdgnB1CF2iWa+QdhF03q
	ss+VR2IwhQacpYbSiTGTj52CI/rJfg898pDClymu/SuBo80cqfQ1tWOiWdi/ySt/R+CnMd
	JH5fOfMylUUTczr584zoE6l8DTsmHOk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gyUz3kxH;
	spf=pass (imf06.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2c9f44ddf26so10023785ad.3
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782831895; x=1783436695; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RxV5fEpsJGHhE3L8vdcj3Th/5v0heJ6mrreI6jrRPh0=;
        b=gyUz3kxHmNhrJ+TVAmKpYqpEDNS4eFDjGtIsOuuwoXokVqObfFIAGRCRxoZgwri8tk
         GcsfnyUMWJhPyakhhLzTkqEyVS6udlSDwjNiwjmrYgmgJZ5G7eP74rDddYFO67Dob8Mz
         AorXfLuyxzxHWvsBFX5twlG0Jub0/7fVb+VoSskH5OMpmCGcwK8wPKU8GuNDaTJ5wNxy
         EtusRIRHqW9LU+OJ8hhNCWZfEmk0gC2ZDp8+z3DvYgX2/LeyqrS66VUQ8sfyJ3rZkkC1
         bXtXwtV9VipsFQpnwXXeIHvZOuuYakExtWDvz1CPXL9PoxxWW/AOgidGnefO8/uy44Xg
         NjEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782831895; x=1783436695;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RxV5fEpsJGHhE3L8vdcj3Th/5v0heJ6mrreI6jrRPh0=;
        b=aDoI2R8hDELCKBFCDL+qrhrarczh5vqGxXWZ0Zm/tu0uIq4YcxTPBF2Hc64Nf1IAGX
         CCIewyn5F/M4dGiZeoc9Oa2VX1RW6KhkMS4igvcDdQZ4EjKkpYVpF5oXyyihOshg2wFp
         4lnsh0BaEkauQN1VVgQHcIoLaJ+yYimr+Yo9SeeCs2MK3fobEtVQlkpvWjzPmjancOib
         O/3WPmyYb3akGXoeuZ//uUs+EbgryDJkBG7IDipNba+nIO7r+E0XBdmW2kVwgqVVaXHq
         FKsgYUkRGR+9i3PBJFFbCwGfunKsqVZLmGTWha2OODlgETvfy7UO/DDZrAM1Dm03FeBH
         eaVA==
X-Gm-Message-State: AOJu0Yyyg5Ra72cu2bivmFw+XaUIc4X2RhBhLeOv89CPFtxSaMSOolIr
	2puYNe1P/JiGBlbOGUV6/hs088/8BmhZswxmH9iqfCi32Ba1qwMEvpZe
X-Gm-Gg: AfdE7ck2k4yEIjv9SQxUqfpPS5fzMugpcQLmFKdvnc3SK11fbY8pE05rRDycgqziga7
	89vc8uU58aZauwO9BeqhSafhS/JShJ2lrTvwkWMbLyZof3plhklUbo6NK9xbne4U8FSWUbjZOLc
	sBFQq4SbYpHGxJo80R1L02CKnF8u9I34yR+TMSquOWvrM9FkbwA74hOY4aevilqMd62wmUzDH2c
	1IY2nC4Ga3QOr0oEaDd6hwPh585PkaQJBEtMSrOg2kHKpeJf8qCP7u3BnZ7AudqwJjKE5yDajc0
	C8DGDW26gCvkV2uD4qhIP/e2Gbdl4rBZCXbHv9tXq9yQKYkShMbszJbgs4EZtg8yp/TFTFwkSz+
	EY5oSe/f+JjHPB4H4UpOI4qUW1t+PbByfHSLhc2xVN0Ge1zc8M1hAWwgukotcq2SyT73b4SqjRW
	4U9CWhf7A=
X-Received: by 2002:a17:902:f788:b0:2c9:d8c6:1dc3 with SMTP id d9443c01a7336-2ca5a449b1fmr7717425ad.0.1782831895138;
        Tue, 30 Jun 2026 08:04:55 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca37a70bc0sm16250465ad.10.2026.06.30.08.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 08:04:54 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Russell King <linux@armlinux.org.uk>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: [PATCH v3 5/8] ARM: remove unreachable invalid range check in kasan_init()
Date: Wed,  1 Jul 2026 00:04:10 +0900
Message-ID: <20260630150413.1718632-6-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260630150413.1718632-1-ekffu200098@gmail.com>
References: <20260630150413.1718632-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: czs1e5b3wjimrsf4eohq3mraaqhmazt6
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 71C49180011
X-HE-Tag: 1782831896-62975
X-HE-Meta: U2FsdGVkX19lCchMmz90Cx61T+TpRQgkbUtZwBV/0nqplXSMGbFJfXhYhVAtEEhZkia18pMW2RjvWRCNm4BL58DywocSAiN/3Vy7u5kdzcvCARgIx+mG/Lem4gJfefXyCZZTDQWKjdUU+h1rFiSUinwX35GMsP9lpAuY6lWi6uhG9V3bK32D9q/fcTHMCqk6qryzMrU81gUWNkdtR5kWR1/OKpkz+0THDyncYUhPqmZOlxCkxdd8jU/zGGueVoO3H/msYcM6qme350JZvu0Ie6RepS3mHmQGEF/hfKlxME92rxV+7QryCM4g6JZm2RDW4nldWIOc42dEQ9UGUhum3td1idNt+Zco+ubnW18CZilvlnSkLCFBUgF+9diS/AO00nMUl+aUzQW3RuvaUS7aX7vkp5sgvKAljeqeCs+4e8hSuYBH9NN8Wofa/5QDVULVgbfhKgNEGd6JNLLaCjdfQ3g9FxJkL1vkdtXJpfCnCty0B3WdbWSd+iKiLqJaV7F2sWosQJQwl/Yh2HBDIKXdMcXvOYszGPKhNiT3EKXAMrgPMK0qjiaQdXO0KHwvgDEXmqI//VcdWi4Pd1SJjMixtJ7IRhakfMmV6F+cAAVCb2nF3DjCK063fZBIycQO/Ji4Vz+YofRaHp8I6d1kICWHKag6wtxNwrjD7QT44CwqkDAnvuxRQAiVA6yQRg0YD5BB6H1Cluc7bc77yAZeuMR+nAuL819UXMgp3j2mvdcIuUXDAmLTv0bEBn2fh4rL2YCKgB4rll3H+5y5dQi8WqFbORnfGkmMAKErZMD0Q/gvPTU4PDwq8Saz5aAVxiXro83QJUUpskKOdAZk6hzi263InuBIVVqJTjuGDjOtQlbkEzyWojgYH9EJD/qlmE9pEhaGTzNrIsosnZ+YDByxAaC9phE/npEiHzDo07BEBRhtmO/qEn07rffPXWIDCtDysv+yRlKmhvgGwKJPZy19jLJ
 VAxigBtf
 fOQjDRKP/WjBcxhcSSSrgDTIAJ0XSdKP6odFBcix/N8ROacMEnkNty2iBraZCmqABmGZMrdASWCspa2Ly1j+vUkarBv2wkq05tgungcsvQnDOSdFMFljbYLa2tTQ3r9FmAif8PfafQ/VThKWiSrosQsbqbR4h56uy1SMA8Hjac7AC0H9itcHFzecW3abPRhJg+RHR08j0yBF70NbfnQKoA36Tm6iwb97AGBLbnYK9F1/jbZ3f3+Fs5/BjDMQV+NC/mqIijjQuifb7HBi7QGz9xmVbxwdpo80d/DtiHRF7MBIIfekxzWecDxj9N9cH7t1bMfzJm/FQ3siSALGYTW7V2BMlShpJQy/s6TYqnUiQ67QCqfDLiilUOq80zcIhNGgrkflkCIS0qSqRXLBXRLPd/VVqKz/fLXUGwvmfuJVa4WpvsSeIRU9DyPEdMp3G0Kq22thiRDJPFbvTZn3Y/wkGgDP6QQSFJRNwcAw2zlb23vNxV4ybz4rMa+/XuDqQc4xSLH5oLDkELcE5zuIksNE9x0EiDbzzn5Q8vkrH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kasan_init() maps each memblock region with for_each_mem_range(), which
guarantees pa_start < pa_end. Then it skips any region with
pa_start >= arm_lowmem_limit, so pa_start < arm_lowmem_limit is guaranteed
as well.

When pa_end <= arm_lowmem_limit, pa_start < pa_end means start < end, so
the start >= end check is unreachable.

When pa_end > arm_lowmem_limit, end is clamped to __va(arm_lowmem_limit),
and pa_start < arm_lowmem_limit means start < end, so the check is
unreachable as well.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 arch/arm/mm/kasan_init.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/arm/mm/kasan_init.c b/arch/arm/mm/kasan_init.c
index c6625e808bf8..1f7c74c5df9e 100644
--- a/arch/arm/mm/kasan_init.c
+++ b/arch/arm/mm/kasan_init.c
@@ -262,12 +262,6 @@ void __init kasan_init(void)
 				&pa_start, &pa_end, &arm_lowmem_limit);
 			end = __va(arm_lowmem_limit);
 		}
-		if (start >= end) {
-			pr_info("Skipping invalid memory block %pa-%pa (virtual %p-%p)\n",
-				&pa_start, &pa_end, start, end);
-			continue;
-		}
-
 		create_mapping(start, end);
 	}
 
-- 
2.43.0


