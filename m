Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC312CCFA05
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 14:23:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF2E08E00BA; Sat,  1 Nov 2025 10:23:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCAEB8E008A; Sat,  1 Nov 2025 10:23:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1D978E00BA; Sat,  1 Nov 2025 10:23:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AD44B8E008A
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 10:23:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 645D5BA664
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:23:50 +0000 (UTC)
X-FDA: 84062257020.17.BD1A214
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	by imf16.hostedemail.com (Postfix) with ESMTP id 72005180006
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:23:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Yy+pxDgE;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762007028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pSrsMv9vHZViaOOimguQYKUYT4fHRN671HybCTbnJQs=;
	b=Dtu/pZ2k346/yJNifCamoA5ZwMoo6/6reHkq2D2xy4nSGE56+wULGcAk1BLbCd6HzY6gBH
	4ilLU3u9ZNoIA3gyvvpVM0BbdRKf9BL1Hs8OcZAIbOKyC61eeL8yJVL/L67PX6YDxyk70L
	M84ysVngpaCjUTKsxcAlN8pB/2wURtc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Yy+pxDgE;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762007028; a=rsa-sha256;
	cv=none;
	b=be7NyvuHxePx2G5nybkG8hGVT6jYaWiYi9xaKIRuc/ffjmIdUTSNMKZy+UZQeILDkRQVyQ
	PsVFXtFLb9rBinE6EowRfG0kQUBNQJinY5fToe1jK6XzegELWvM7FUg26Gl+7A0R3Hqaxx
	58fyV9CZfaf2YUhBMic31OYwh8D0cGA=
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-89019079fbeso1459856241.2
        for <linux-mm@kvack.org>; Sat, 01 Nov 2025 07:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762007027; x=1762611827; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pSrsMv9vHZViaOOimguQYKUYT4fHRN671HybCTbnJQs=;
        b=Yy+pxDgEdypvSvIT/Hmr3MAyhkZmqFvlDwk7MBHLi/zDlPWHiYU0KYt1T/t9vHaplI
         pEHP9JjadMXNlFclSoYyjK3Jc7GfqEVtFVH9FXZGCTXY9pNmrkfpwIHd37q1Wt20Jwr8
         K/bA2GEM+OQ/jLL60rt4/eswcvudLD5pSGJLeXrnQuSz0JBYzQC8MAq3GIoN0SEc3REl
         /x526DwDxb7OJcW2HQ/HOE+qTaO5e/iXyQ9zG19w4Eo4PKmAa+02FvCsOTcneWYw9+7i
         cpO0O5eB4K6bxXXMiO/7pG9Idquxv1lWdWWOpxC6qrwvF6pI1bx7+hqDkz4cs2k+nD8k
         adkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762007027; x=1762611827;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pSrsMv9vHZViaOOimguQYKUYT4fHRN671HybCTbnJQs=;
        b=ti6cgVH5vGuAvCaWkhKu7XwvMa4g6vFU5xmURq2zmhf0XLtEWOH0JtZNHlsSh9oiTx
         9GeBke6GOPXmeO9TO2G3VL0YUvmFApOJHPdQD7IRCZ5bBaDFkxtdM4XFcQghqtOny1Ec
         CtwkQ0bgELrYypsL9mfNS08iEtv4sqNwUo58AfeCCoAuIBbM+uagyKnPQEtjBnWZzGqP
         3wEQ4PQC/Pn/7RHQcRQyQc7Q+UNvVpvATX4XiALoB5pFD3mvlmFYHtdVnReesc6wc5P7
         YeIzDWdWzoQAl2RzBZvtBE0MRzqJ7soG2OXC0e0Wyl+u1A628La7m5T0mF116aDlEITD
         rCMw==
X-Forwarded-Encrypted: i=1; AJvYcCUqVfMmAGB62wykHVyYWhKc56vomFeAOung3Nci2xG2kx2UzbCrbXVLqW7DxY5/jXrHXZuF3FTapA==@kvack.org
X-Gm-Message-State: AOJu0Yw54woI6jL+k3sLXlyAjGlqU1jMVd7pyQUHTONRnXsOSW6BcV/h
	VJUBI6IdjuCVfVR0RG7FHuniJTgGLeyiuozM/UTRsCY0/2XUdA/8n69ruP8YRqmaUAg=
X-Gm-Gg: ASbGncvEVPKj2IbXxLTVX3DUPabF9kTTeKcAoGp8sLy0G2Q/+u6gW65Hh2l0ABaHUHM
	9gJJWY4NF2kTztoCZeUXLsb/rLi8REmOpzJKvH/1LgkB1w6XXWjTVV88HI5EpeatY5LCkk7BeD7
	XL3RLWVmaUTwSPelw1Z8PUqBW+ay+UIzVREX6ZDuZCBQ20qSJHvBgeZOkhPZH1DbIauo9TRZdJ5
	ThgggJFF4aFRqQs7YRUl4oXHgobVWDR7IAoBlzRJ8+9JXcqaDPHX0Xv8is7uXe8MP/vEpi4tJCQ
	GWOQ6tDSKcFLbsGPuXx118JUH4VHzzfZO5bBdSsye/OlJkV8Fz/i7JKPbiikZ3kCDL4zu5e1bLV
	JlJ92mFF9r5N7e39hu+VuGAEPJVk93Yy6Wc8Awv/T967NbwRA00BnFq3i9GPVIPaTsMXrUsYNaa
	bg03M3woegCLzk8N8PUBOiqwPbgSLze3FuN/kHlw+EiohmTZ9c0ryCEzxCn4zI
X-Google-Smtp-Source: AGHT+IEQrc/UahYLt7ANSOW5+mMj6ZVaZ8HuruQYEbIlio2ExuETGUVUCqnEvcl9P/bAjVq8vDxMwQ==
X-Received: by 2002:a05:6123:2e9:b0:552:2c5a:c057 with SMTP id 71dfb90a1353d-5593e548e2amr2464325e0c.13.1762007027406;
        Sat, 01 Nov 2025 07:23:47 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-559449647e0sm1776242e0c.3.2025.11.01.07.23.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Nov 2025 07:23:46 -0700 (PDT)
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
Subject: [PATCH v9 8/9] MAINTAINERS: update KHO maintainers
Date: Sat,  1 Nov 2025 10:23:24 -0400
Message-ID: <20251101142325.1326536-9-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
In-Reply-To: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
References: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ribr5rge4mzpjs4ye3boejjmdghh9g9o
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 72005180006
X-HE-Tag: 1762007028-400316
X-HE-Meta: U2FsdGVkX1+8Ki4iWtyzDGkcX7xkOdWuBkUw0iHNL/NwQk/kNy+b5H1YIYLsMsuQh1JPFTo7y4HScPMQd2IFACmP9ug4F1Dg4q0tKjOx8FgConU2DgdFa+JOQ2awTfXiGpH4DZRoJHPdoCcOzCxN1mAZTbqr3LfuGvWw9kRTvflXTHc7RmzbxP5bFwBtCc0QCf/TjIE4pIm7FQQsmb885FEyHTYdnDeDWMOLNZGyhPnYLLjzcejQRPhplZWTf8+arrTTD3svYTzXserZuE2fplFCxBrI4tK/bMHP8ntSCxkUXKRxCoqKAkSpBmYsLgqIpBAo2PBaT4aLrpyRsQl2oQVp/jGBV8RUH8Dho67ATqjyZKtxqaKuewYkNPtZIKuVNnDhlqTIxmn5rJtsAOe5HBNjnCDp5CvwoLkMHXYN9IRFZ5DVxNF5i5LkmKfdRBwnfOF4ZD21BpDikkNuJ/Uc5YrrYkk2RCe8CulckHtD8fFc322QHL6UGAVnFBlgeIj5HAHATz80RfBSkbfAfnolsuJ5phgZcMy3ATTQet3WfEgODYjFOtLoFt65q1vRF5pEgEdvWbYPxiRnB62S+5+Swf7KVXel75QiXrX/HmLacllZ3zspkOEgEog5zMHoiuGiQOIjBJnv5U/qCjA2XkVYERtTfD4slhV5EI9Yvicjqm847lDmxSnosxD5YqrS4+ZfANn4axuaT5xFSimKeD/1BlW+SPV6u9hnwdqFkkCH7smf5qKQQopyVAkDHgIN6h/iaqXDgH1kvXNrHYbBBjwUiugYgd3fbcacj5jP1owtEVu9XmrQnVAvq/0Y6wc575liOeIcPlinmTO0GNt/ybd8ckCzofw5T0QRN3LY7pe+fN7Tp3ygMbpswDPCNN2qQHozjPQCDE1R+rbqBi1JJgmWvJJI/mAQ2UnUY5GMzQjZF9VCRcbBIsMTRRzEYj5ChNhEhwXaSsdZb/E8xe/PYpP
 14Hjgi0F
 ZNmDlamnqzlJeffjIgpF6Vet/pA92HFqL4Zt9feva5FeGabSO1MGng4i8kziL4uBJo/Dsj12ZCq1bBBWAkYme5Mn35Fbpc9XB7sAgY0ezToDmG/y/i6zpvvjRup7q2r6IPgJmsjgVsMvdfQ8IiKzrF1j9sS+RDO830LORLEXCTeymGVX6aaFl0dAisC+n2i+D1v5LLRrgt6ucdV38QR3pOep3I0D7VfUXWJtfO9+O2DTdxMXB4jZ5A1JblFhcT83T6CNXZ5L0PC+2TwtSWJ+uuSBhgMH589vsMVtFGSdxNU78a3yAANsrmb32M2QQjxlfTxdPtNvguBj6Y7gn9SsTsW5ifeRtDCLpJ0OhwpiaT8NQuGhKQIosdMxENTtCY4AugxoEu4PmYa5uJ3DvpVQ0xUZ3XgePHZ0yEmQEWQJdYq4Qo0CV8q0I5ARt0fRRqtJpAz9O5US6FSfgUdYE9/kaxfWZ/4CkKfMltZftB/LPK0+5dDaUJPqAE7xx4SiXI036dRMUs6/1rKI8Wi0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changyuan does not have cycles to commit to the upstream work of KHO.
Remove from KHO maintainers.

Signed-off-by: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 764df916fae7..6200de2027fe 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13788,7 +13788,7 @@ F:	kernel/kexec*
 KEXEC HANDOVER (KHO)
 M:	Alexander Graf <graf@amazon.com>
 M:	Mike Rapoport <rppt@kernel.org>
-M:	Changyuan Lyu <changyuanl@google.com>
+M:	Pasha Tatashin <pasha.tatashin@soleen.com>
 L:	kexec@lists.infradead.org
 L:	linux-mm@kvack.org
 S:	Maintained
-- 
2.51.1.930.gacf6e81ea2-goog


