Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DF4ECDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 10:52:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2721E6B008A; Tue, 23 Jun 2026 06:52:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 249C66B008C; Tue, 23 Jun 2026 06:52:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 111236B0092; Tue, 23 Jun 2026 06:52:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D39EE6B008A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:52:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5332F8E0D7
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:52:08 +0000 (UTC)
X-FDA: 84910862736.29.FD02D31
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf28.hostedemail.com (Postfix) with ESMTP id 84493C0004
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:52:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=brpb07B0;
	spf=pass (imf28.hostedemail.com: domain of 3VGU6agkKCGES9QTMR9GTFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--tarunsahu.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3VGU6agkKCGES9QTMR9GTFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782211926;
	b=JiBU54P53d+BZDItwcrN6RMWqELfmLFidAFlnxFKxSfU/H1lxkTJVS/gM2hLL//9g7BhgB
	VxD1BO0gsaM50yLpI+OxvznF45CtoXIA8/foKlHUAg53yQg8OHP7c6YRn+YQ29eia9jo14
	InCxOd0ut3wpe4faXkhzGHaNiBqJ3kw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782211926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Wz5oprksRaCrRIjUlZSqxfZyBEaRT4sgoIBdS9jtKw=;
	b=Mn1Jbc+cEwAtwerXSk0TmUs2hoErlXcaRexw+xwyXN/Pk1Ds5h012wok66KuFIhy+ySY4r
	meTxUgD96vAq4dBv5Jcyfq33p0CmhnA0RoggMmDUQUYGbhuksDuy3i1XdPb+kd+Lyx6E5H
	iS/yr/BDiCyqacG1Sh6O+IbYbhQP2Wc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=brpb07B0;
	spf=pass (imf28.hostedemail.com: domain of 3VGU6agkKCGES9QTMR9GTFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--tarunsahu.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3VGU6agkKCGES9QTMR9GTFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-bf481a6e4e6so592681966b.3
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 03:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782211925; x=1782816725; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1Wz5oprksRaCrRIjUlZSqxfZyBEaRT4sgoIBdS9jtKw=;
        b=brpb07B0yEPMXO7w6kXUBC1yToro9g1MxqOZ6i2/YNqJCv5xy0t8mfKLDZWmpDWqDR
         ffSsFsEjsTOwZqTSij5//34PhWAwbPjjDhr79hwd/tjKft3ua+WFhnYWFpZgwBhu3+b0
         IU02FpwUnoz/stEG5mHpEaf316oQX9vmGPRri4/KvgcURWr0TzxrfxVE5sSBO3HhoY0P
         /7a30opSUU3f2Y13adZDFQZg4LD6MIgmVEJ7nBeV0Mip3N4W++sfMowd0cls2UFZM/vc
         bfGWuIa9TKKRwPRO6RanLnP1jlKtdqrzMjOk32br/Fo51LEJK+Puws5Y2R5PNRzBh0s9
         Nh0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782211925; x=1782816725;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Wz5oprksRaCrRIjUlZSqxfZyBEaRT4sgoIBdS9jtKw=;
        b=MuHikYaU4NyWpt5Bf/nWlGYA90RSlhSPJkrhjjFKC5xCCDFIy+nhTWKwqE0HYO6wAc
         qzqYiVQRuBgKcjBnd3dahRKPP1uFFqcFJ/X8w8bmycyL7dCiZBSFbV/eE0tb7dEbOIT9
         z4E+rzQBOpKVJFgEHo5jBHuJ587LNf6HjXAUzCAgUbg/AMXk0Wh6uxT468/VbSb1eE20
         aB9+5TtqTmD83Yycg7qAt0F9pzhttYO6gO9h+PhOUvbTe7E1nZnJoAMjTaZeofm4vMAB
         2Z8Mp/SuKn6+gfJY8G3cMvEhO0UHuhFzC663wv9fzIa7iYnsJ8VCV0jIYz7TIdZCyv9F
         0Xpg==
X-Forwarded-Encrypted: i=1; AFNElJ9TEYvDGt0FYD0I93Iw1V00zTK5sbK4DlJoySWz++wfOr2DQtlKtKd/hqmahi8GBbGcn/uz8j3xPQ==@kvack.org
X-Gm-Message-State: AOJu0Yyl0XJd5HGLZnqNsyKTKOxRgGTxElwtO/b4SNc1JLHlLVj0n3CY
	MBqe4Hpym5O/diyGywZch5cgOfxMC81xTFCBQGXXst57AICU9mcJpHR3rdA+XUWw8UV1CVHS1IT
	30MD7683MfIDj6mMSqA==
X-Received: from ejef19.prod.google.com ([2002:a17:906:3913:b0:b9d:975a:28a8])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:a083:b0:c11:1753:25cc with SMTP id a640c23a62f3a-c1117532ecfmr18544666b.42.1782211924283;
 Tue, 23 Jun 2026 03:52:04 -0700 (PDT)
Date: Tue, 23 Jun 2026 10:51:59 +0000
In-Reply-To: <20260623105201.3724592-1-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260623105201.3724592-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.rc0.786.g65d90a0328-goog
Message-ID: <20260623105201.3724592-2-tarunsahu@google.com>
Subject: [PATCH v5 1/3] mm/memfd_luo: validate serialized_data before conversion
From: Tarun Sahu <tarunsahu@google.com>
To: Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Alexander Graf <graf@amazon.com>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 84493C0004
X-Stat-Signature: ho9sp6h6ecyfycqay1s97zdfruy49wsh
X-HE-Tag: 1782211926-994485
X-HE-Meta: U2FsdGVkX19tR596JPDrAa327AxYUZMDRaC7BXXW5e8lGh+oAZefN98ypmyEjRKeDhf851NOjeDl2u3i6U1ZVGIpn7/1r1txNE36UVF4QTuLuHpzpqaweQLJ642Ve8JEIu/G1L4f3ZzSeCx+uQQyJ+CpsaYXyu7RE+ZI1bxDnKbMJd9JqZSSZp4JaDvf5FjhBjGcWzbqhqeR2Kac3VvLl5Ux2i7iuywch/QCT/CM+05vpP6jjzgM6t1gULVhyEyS5UANj4AvTIjOFGo/AkzJy2AMXrfipyFIMDmL4vlOueXfLeieyuzc/lQxuuV85yzboabr7RMuENRsupeXCIyUFKAJFRHS8toXxO7imAUHK7PSFUdlwHmMToO3kHdOi+P8zGSDdY5iMAFlbOTysHx1RpINYrhZyRPAR7LLdQLHmoJFcE91LuezIV5unsTVhBH5Mb4bgcArhSYNbDG8KEYFsm/3uB9EiFbll62umOjrMAyuYUHm7fFcFASq8d1NBNoREVNF3AsLRCKU8AzgWmIb9oCIdgE6PlhSEXrwNxzBNI9BehULlq/aBNDHZpoJAeSCVc3b3bwb1pnPemwbvFBsMo2P9vV0r6iVe+YBLIEwEzt8JMxtZMGcnbMqVsHb99j9aP8yE4wRCOGSLMqsr5XlXlm5NMfzmino9HaUuBZ8CWUBFS4SEITI1CVguTVFkzpc8Wb5FMeJrqElxzjSK5aEpDiPFT/U62n/1b23QxKdIjCmeK1h6Jf7lNp/W96BnQu2S3Cahr24+MUBKNpRfozitgcz9wXHif8pC+0i1nezMUEIhRh2dnnoPFqrn6a5ipMImuPeXP7IJGm9MfMB8PA3Tf78m9uvyp/HhMOik4N+ZyiHSy6S6FeVywElXHiwhbezVwa4xbmLSNgbk5qfFpOF7kveFGjVo05WCdRJqyqxxwcQWEM7v0XUgO54FCjOf9H9XSTxRP59mw21Exe1H1l
 iI5w3gu7
 qMKINv4qczCQa+S8EDu1MYZON38eBLfWuBdCtyhZJuztX5CMlTpXhodXdGobFs25Wz3DZi0PpNshlhBJp9AcEoJbhhFHM6Bb7x6pAH5VwnLmWbIyXJYs8gch3qwW22ALDvpMTNxlb222lUhG4/RIQxJH30XTh27I1YOotrbqwEbznRYm/eKHBfzxnFzWrWH9S3NzbzSA6uE2Cq98YHChCJGqdDn25zp26V5UOQudOwpbb9AiMuaognPARk5uR9TK7BS4GBb4PysDEHRUDvPwWqvFaWnrv6R9mQo4zyjw1bBBB7twawdYllOCmQVaXPuLdwCRzmo/tljERkw1izGver78MFwpiZydPpt4x7zlpYGDnIqzbqKc8jyYgmYWUg9QQDxcrJnO9Baw+RV2MuuIqY+KZqhgwG8LhmCgm4QIxcUS2KnaJYIzYI7bIZidsePmltyV9hWnEjZgqEWmlwg9yiDajEd+Cr8MAGkZzy/B8ClNvZvdIwk+nQass509PmgSr6XyCGc/F5d2XG6HSemZDuLmaFPaCTKQ/kWtIRQO9TBAaz/jiDGouZQkzNL+J3ZMUE+Wxr/SHm6Iv5lIlv0qxUAWIyIgNGbrjAIzNrztXp7LSf94=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In memfd_luo_finish() and memfd_luo_retrieve(), phys_to_virt() was called
on args->serialized_data before checking if the physical address is valid.
Since physical address 0 does not map to virtual NULL (due to direct
mapping offsets), the subsequent check 'if (!ser)' was ineffective at
catching a missing serialized_data, leading to unsafe dereferences later.

Validate that args->serialized_data is non-zero before calling
phys_to_virt().

Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 mm/memfd_luo.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 59de210bee5f..10f3983b0060 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -397,10 +397,11 @@ static void memfd_luo_finish(struct liveupdate_file_op_args *args)
 	if (args->retrieve_status)
 		return;
 
-	ser = phys_to_virt(args->serialized_data);
-	if (!ser)
+	if (!args->serialized_data)
 		return;
 
+	ser = phys_to_virt(args->serialized_data);
+
 	if (ser->nr_folios) {
 		folios_ser = kho_restore_vmalloc(&ser->folios);
 		if (!folios_ser)
@@ -522,10 +523,11 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 	struct file *file;
 	int err;
 
-	ser = phys_to_virt(args->serialized_data);
-	if (!ser)
+	if (!args->serialized_data)
 		return -EINVAL;
 
+	ser = phys_to_virt(args->serialized_data);
+
 	/* Make sure the file only has seals supported by this version. */
 	if (ser->seals & ~MEMFD_LUO_ALL_SEALS) {
 		err = -EOPNOTSUPP;
-- 
2.55.0.rc0.786.g65d90a0328-goog


