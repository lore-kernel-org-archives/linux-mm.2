Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7E1ECE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 15:40:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C16F8E0017; Mon, 17 Nov 2025 10:40:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 072138E0002; Mon, 17 Nov 2025 10:40:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA3988E0017; Mon, 17 Nov 2025 10:40:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D37298E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:40:57 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7F28256D4E
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 15:40:57 +0000 (UTC)
X-FDA: 84120512154.16.7CDF775
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf09.hostedemail.com (Postfix) with ESMTP id BA02914000E
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 15:40:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nUZ5k4wX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of peng8420.li@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=peng8420.li@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763394055; a=rsa-sha256;
	cv=none;
	b=rsPJfdtobxwLxoG1Q4EtyfkmB58pCD41OAIPZs2LjOUCM+sj53FKJpc7jm7czdpm9LzzLc
	7bfB22+75sH0UZJWVlpUxEQ8AtSAVEqsJh2di3st3jari4LmNH7nZesSM1avNQx/vvdQCD
	G5DNSrp4Wzotxm5rnuB2HuqwGGf+svE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nUZ5k4wX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of peng8420.li@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=peng8420.li@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763394055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5U0JdcXFT4piWxgb5tZGsXwJdCzE395g5AsJI2GGFWY=;
	b=tUH4jwrDt4U4XK7wH1P1SwOjn1YjbJ8/PlXdwu8mLK7xoqmHu3hLuMWmViGckYJxN2jNAl
	9TTLcFFyo8IdSt2aPbxSBMNZpBmvt1NO2aSouN8eRP6nToTjHyAuP+psyYBIebEVKeXq2+
	PeqfFGs2kzJ5re4UQKLd/x127RgJmqM=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2958db8ae4fso40941885ad.2
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 07:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763394053; x=1763998853; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5U0JdcXFT4piWxgb5tZGsXwJdCzE395g5AsJI2GGFWY=;
        b=nUZ5k4wXKyoQc0P1RLere1gUUSlkUGstIsgObE+7sYsZeIwCuITSZy+eZW8RzZ6jHU
         RHKqVLkAfUZ2gjC1PFB5J+fummVdIgDJcB5CN09gVQdbNODV1PK29yRxxJnSDtWwD3mW
         /e7jjEMtCYKhSmTuboxhrvsVh8F6/TZPGZK6zJIF6VuuoMbH9Vaelx3THYjI4ISV7EVg
         gAwzXUVpaWYG6rPm7M6dbTvL784/SzEwxKCtpa9502M2/CDCSUW+oCtAmZUmLwyJy2Qk
         vg5U/SQK7Y8RwDgs/vuyebrwgbwUiewpaJsjf3jaYOZAYFHnYxZNBPDxjxUYxQ2AaCnV
         NqWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763394053; x=1763998853;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5U0JdcXFT4piWxgb5tZGsXwJdCzE395g5AsJI2GGFWY=;
        b=j7KYakL9JcyLZ6ird8PXSlbauFW7LMxwf2VDvMPIQFc6ebw8dCWGwk7NKZirjgXJAt
         t8F/WMDheIwarpV92Y1GkeaGUf8A/cPjp43tUv/YWofGRAXz/1RdvMxdZ61eWHeoXXOE
         0eDLs/9zpLpe28PYUyUJstQxwCV9Ec6QNhHzh+x6k/W8RZAhTS6YESAhDhvXlBfo023a
         buig/eYpR8wUM+2Bh3NnjTI5CTmPI/ikkKX1R7MAgASHiw3s5RQtHKGHMuq59P5/veeO
         riE7+bdv1J7VGIKRMCokSp4gQj42Y8u+CF3jV5elac153OPLol85vqw3pL6GLD4sMGUt
         Uqow==
X-Gm-Message-State: AOJu0YzD5tlSv9aJlCDJyjq+++0MiSA83P6l5FZVABAR+Ikm3R4VfzYI
	BvPAvaQ4+ZOJGN8mtTTXqC6d6nUu2TjvmVt6kTZx91mzjTyoJge0keSj0PMAx0Hk
X-Gm-Gg: ASbGnctheiZiijpYQ/gThHn5c/QuJlGmapwvEToDXXHV5PEztUPlMF+N1Tg7c2ho3Pd
	51h5X+kM1TOix2L45mlDkZQRc6+Ju/AEo2EoAXiFnY0/owubdVMxmiMMtrXUqqEIGIlKuJPndrZ
	UhVWljsFLGALEWIYDJ/RVGWFdznat8rYMkWd8BgxB2QngpJGg3Sp49Tk4eXcX6AqTtjIrHJJOUo
	kIIZWmvU0bwCf6MLUeM/lMxtUAxej87ktm0jbZGHUzshHY9GRZ20ymHXZHF5vYnyQvZRWczxS18
	qs0LT0pHqas+2fwjBHdOniNb2RAZSNImXip15cGvQl3cq2irBA7EuWOgAun9DYpvGucG9YGYbDq
	z4ISTZHTnXJ1Jn95vkapmBkrQU+dFbRmuML64zyw4WEa1Ul0=
X-Google-Smtp-Source: AGHT+IG94GWUfo1tU4nyNmfuFRJx73Acx0EtwkoRss7I8Jkn89BKQuLHaUxf6oFUW0up/oVo8FeZ8g==
X-Received: by 2002:a17:903:3b8e:b0:298:485d:557d with SMTP id d9443c01a7336-2986a752869mr156594135ad.45.1763394052926;
        Mon, 17 Nov 2025 07:40:52 -0800 (PST)
Received: from gmail.com ([117.147.72.154])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-299daf12fe9sm51167715ad.74.2025.11.17.07.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 07:40:51 -0800 (PST)
From: Peng Li <peng8420.li@gmail.com>
X-Google-Original-From: Peng Li
To: linux-mm@kvack.org,
	akpm@linux-foundation.org
Cc: david@redhat.com,
	osalvador@suse.de,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	linux-kernel@vger.kernel.org,
	dan.j.williams@intel.com,
	Peng Li <peng8420.li@gmail.com>,
	David Hildenbrand <david@kernel.org>
Subject: [PATCH v3 2/2] selftests/mm: gup_test: fix comment regarding origin of FOLL_WRITE
Date: Mon, 17 Nov 2025 23:40:12 +0800
Message-ID: <20251117154012.197499-2-peng8420.li@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251117154012.197499-1-peng8420.li@gmail.com>
References: <20251117154012.197499-1-peng8420.li@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BA02914000E
X-Stat-Signature: mt7bygceddpzr344aqs9ahyisigbswbc
X-Rspam-User: 
X-HE-Tag: 1763394055-415822
X-HE-Meta: U2FsdGVkX1/32XtrUQyEfkOQRFe8ieVqEvj+JHneJZ7N5WzrlW7wYz7ivMY6UkrX0fJfprYuW2xy5F1rgUuGCtTFIQ7VQiyInIgLgGH40kWn5cyQYc4PaG1VUI5YwbsIR06bYoz2+/Yzg70prAUJUVAQC5uKYhS2CVAL1bnPwRGWhiRBVjHrEUN/NtjUPjg3muBR36pNoiPBq5mVrvpxHlNy4z/Bt24jncO4fK+Trg+AzbDi2Jrp2lxt8/TuStliA9iBbBflH0rIL8IAcybCqte33ns+Ee/V4xITfXC0lN9LEe83KcEhD+fERj0Y7KyJ0+cnGmmmIjnzhAERShVAPcVjmdR/BZe/NvD5Q8l31KXPAb6AiQ/suGCxI/4TvykOOyW/+4RPrxEUMK1+EMkwt8ElTkq9ufoMaEm92nfK+/elniEqsOo1QY1xr5cEVK9iNEu/ELyDkBdhHKgUcoFIjWwcbzpwnej+wrcpO8CGTotkjJXPanRs8XFXSPPyOW/4f+2VDG0SCqqMBTjKlvO/Qaqd2+ynx1gn0rHHEoMQpKIoHIsc00mHJ/K4/+Mlo4yKR2LrsTa+EMBrzclh4bcN89DCxV21mDyhzcvAWMS3exBMfTpl7ewhrTDbJvoRfqwlbLk9P0k/DqoFDLzmLL9DjCrLqd+8a4Y/Cac6/JggcnHqDafSaht1f9c9AuZrtSUkjCf22XPBkqJmleWIdnlttYz6/aIIJChpxFAMNoMqln/k2pTpfRSXXLq0lR1lN6l5coiMb8rOCXkLnAqiDyfJ4jRsHBpQoeT8Wvd6ygN23pGJrq8y6k4JOHfxRFZ3zq0w1wKuPPJsiK9wj8a5/5GWJbwNKcEWRKr1ZMfp9xCgiVtix2xqtMoqXhr6UoIpbwEb6mLcCfZb6b4QAMWfl0BayRuUMaFVHF7wVzcnV14K6kcNPRJIQtbDARx6z4khW6CpNEgda604ghd10DMsaYD
 f/MN2fQn
 7EwZ0UBy9k60wojI8l7H5/Pb5vd1JwY6exWzSykio4hlzBQMN5BqZ2S67Zu11iLt3UhfSu2K8WAr9JYm4CUAAtYJ8oxEy160Py1P/ssG/WCptES36OamZ25lCDXjggQaOHl7BmI/keTpByFjKsa0+qt7JIpaR489kQiZz/F8Hai953GCITmagcfDv97p5qcr4ggyvJvR/3NMsxPw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Peng Li <peng8420.li@gmail.com>

The 'FOLL_WRITE' of the copied source is located in mm_types.h
of mm, not mm.h, so fix it.

Signed-off-by: Peng Li <peng8420.li@gmail.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 tools/testing/selftests/mm/gup_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/gup_test.c b/tools/testing/selftests/mm/gup_test.c
index 75f7134d529d..40c1538a17b4 100644
--- a/tools/testing/selftests/mm/gup_test.c
+++ b/tools/testing/selftests/mm/gup_test.c
@@ -17,7 +17,7 @@
 
 #define MB (1UL << 20)
 
-/* Just the flags we need, copied from mm.h: */
+/* Just the flags we need, copied from the kernel internals. */
 #define FOLL_WRITE	0x01	/* check pte is writable */
 
 #define GUP_TEST_FILE "/sys/kernel/debug/gup_test"
-- 
2.43.0


