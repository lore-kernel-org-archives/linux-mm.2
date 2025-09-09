Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3320BCAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 01:00:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E41B8E0014; Mon,  8 Sep 2025 21:00:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 895598E0002; Mon,  8 Sep 2025 21:00:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 782E48E0014; Mon,  8 Sep 2025 21:00:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5B13B8E0002
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 21:00:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 256F8160326
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:00:26 +0000 (UTC)
X-FDA: 83867906052.05.DCEB123
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf08.hostedemail.com (Postfix) with ESMTP id 69F98160019
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:00:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k5AgyHHe;
	spf=pass (imf08.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757379624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bxrQ50WwxcJf+ZNsWb3xAkAINo/uoo8WPlO+broFxXY=;
	b=zRR4NmQozrckuLbF21gFfVGjQZcBVrd4vQ3+AQK6Y6bKLUQySypI8Y0cDra8BVC+dNyi9B
	gZ0tw/opGTIVm59QC08ULyD9hLO4tm+n7Ac9cpRCiQDCKGRtUncwJp/OalJxQvKbF1/DNe
	E8gOkRZjZWfX5r9GlQN5eIgAxhVbF9Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k5AgyHHe;
	spf=pass (imf08.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757379624; a=rsa-sha256;
	cv=none;
	b=AYuU72vGXzKmUpizDolvYOPBUbfQRD/bizRv648I+03MVybboDeYSgxdr1tbWGSF/KRe/+
	mXPv6faQ5v4Mnup1ZeGZRteWUPfvGCiSDoF2ICVTSoFHlsxoqRsp/sLy0zYNjyGUUntLjd
	+bXuz6/+flR2Dp/H8Wh9Y7aneC8mOOg=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-327f87275d4so4910970a91.1
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 18:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757379623; x=1757984423; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bxrQ50WwxcJf+ZNsWb3xAkAINo/uoo8WPlO+broFxXY=;
        b=k5AgyHHe8tnDLvC41R5k/z97ssO5Av7DsGBFrPcWTdQCFubUAIlgIKWlUHfalGMZx5
         P5vJXZumWkD2kC4DJ26fXnIdR5Rdthv8O9fK+OzyupH/SiExqNxAqdEtE/fHWv2aJ9U8
         +2FAwLt1jfrXZIDvJZVVnrjzcCIYjhi7cXkLYnsUrUEgc5jbObgvkB84OxIcYXA5qVFW
         Fwg/b8YuobR/npqYmnoqrW23D9600rC04wM9L9uwezLan4rfx5ZvTubY90BVkeAT0m3C
         7emQ8T59NU8ev28pEl0nDr/jjoLZrLHcc38nMBdjOZ1aJIhmK98ePTPQ+zQlskbQ51I0
         0Ycw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757379623; x=1757984423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bxrQ50WwxcJf+ZNsWb3xAkAINo/uoo8WPlO+broFxXY=;
        b=oL4KykaZiShaw6sj8iEO37yCqLYKUGBZDah0Sa19qf3XrckjKwYPcHSW2u6j/I6RHW
         jBSSVYXHADTj2ywxv3FAMfb18RYbYVElQ+yGjFjlFQgTuFnY9xR3ofd4ve134xwrLD/C
         EZ7VIur7ImpDTztcmDtRBvRCONwO49dvmZHhUxaSW9k2aXQpVxMevdNjfSegqLpHOvU9
         O0wHoZdftK48001ADvZ+9qvBrdlEqAmYiA4eIgSdL84gjxyQsfwsN9t1/OaOPMi06WYJ
         fi+mkPRZQlw2cXQn7UhUaa58Z8U8gDYmf67/eCBTOBuZIepw2uww3JqdHJ9vWG7w8TcN
         CJUg==
X-Forwarded-Encrypted: i=1; AJvYcCXCPMaMvbSlaHKio0xZ1WjzB0tJEtVurmGf2QZouzn8SUDSQtL4k+zfdMcP7zdKdUb3jrL460XkqQ==@kvack.org
X-Gm-Message-State: AOJu0YxmJOLK/ZFENdP4XVaHHjVgiWn1nXnHfY1pI4SqgUdY97cw+Frt
	cFnXVh9pnSDuCUkEu45hOvzt4xlT9edOmk/SwhHP4hpcyK9/R/rdWHUv
X-Gm-Gg: ASbGncs9PORPdqIzfWbUVW+thNjbGXO5THICLOWnTHhrQ+n7t/h1j7+In2cD443JNqA
	AXTeCp+CM6Jm5yJRxvbBDcEPs7dMxFbQ87cqEwLG90XJ0Ef6C/8a0s2i1WvKe6sYA38OHF1mL07
	0Bn8/D8AYsmokXRMY0Twr3zYx7UU/BHRWCv15F/98dBs6HGlSRrk/jVGVRIM+NGQzX4MqC/DwGa
	aBuk4w8I/rT8hNs42HgauV4OlE580a8BWzuDGFebLxVYP9O1ClchYEfsWIYOe97/pZjgVHTUudM
	h6CTJNJnK/AxjCnYYcCd6oGjT3kL1TSBXNaMiUtnl4zQzsOZHAzquYbzBdMfuLusyu7bauZyNJD
	n+sOHkJiUmrBcuVa/9pL0i6q8xuEgSfqfozJV4Vyd808vRemF+FykqYQs0JRxmig=
X-Google-Smtp-Source: AGHT+IFeNRsm2QUYba1YavtLTYPQrodCKr9T+9C2GXnH04y7bOF/iflwDTL9GGDN4Q/Rcq7n4vEJ1Q==
X-Received: by 2002:a17:90b:3d81:b0:32b:8edb:12ce with SMTP id 98e67ed59e1d1-32d43f18b0bmr16536473a91.15.1757379623296;
        Mon, 08 Sep 2025 18:00:23 -0700 (PDT)
Received: from localhost.localdomain ([2001:558:600a:7:44e6:767e:cc5a:a060])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b4e673ad423sm24264403a12.50.2025.09.08.18.00.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 08 Sep 2025 18:00:22 -0700 (PDT)
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: bpf@vger.kernel.org,
	linux-mm@kvack.org
Cc: vbabka@suse.cz,
	harry.yoo@oracle.com,
	shakeel.butt@linux.dev,
	mhocko@suse.com,
	bigeasy@linutronix.de,
	andrii@kernel.org,
	memxor@gmail.com,
	akpm@linux-foundation.org,
	peterz@infradead.org,
	rostedt@goodmis.org,
	hannes@cmpxchg.org
Subject: [PATCH slab v5 5/6] slab: Reuse first bit for OBJEXTS_ALLOC_FAIL
Date: Mon,  8 Sep 2025 18:00:06 -0700
Message-Id: <20250909010007.1660-6-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
References: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 69F98160019
X-Rspamd-Server: rspam05
X-Stat-Signature: dgtrgt95d3orongx7ry7t7wijzpwfkts
X-Rspam-User: 
X-HE-Tag: 1757379624-885302
X-HE-Meta: U2FsdGVkX1904C8816C8AVrgmZ5a9ZwNCM4+gozeiSUSYY+ZocIuOeP9JFRyhgand3R4FZf4dyyBQpkygoVPchSCS2jGKi6Juhi3xtn3agDzVZW4aBaFDcfkyYBNNz564EHMcoS+YtTPBC6syewCz3hE8WEHZbE9Bs2171tnv/bu02h7tvit1Bbzzom2FcjrtTl5/kiVGRNF+nWWq3XhOuxkvjtTrJ7cSdyZoKF+UPfFsWg5MTrzrJuANjUO7VkKBCBw8xnsXBj2x5xJhjQRzi0v/XvFRLTVfck+UCjMSNEYi/u4r4gGSVelUFxUxo79Fchc2PW72myeRQdKOuLRfl9+2GLY5UUMZNpXgvHFpI5XHcPq4S+/wuOlVDftyaLJpjclnJYWPXEGxYusofrxBz6J5on2NrCbyj2+zhCUtgCFm3rz2aJuJbcV2njs2YFwrsASDJyUIqedUamuNak/W7KGsRGYwxNTH05nKMnCooaZz+99QqHpY8zNmxcbrn7U+6Eu8uX65BE9xGyevkSFI7tCfln1n0sj+uvGXUOMEU66GyLx8GsWp3MvkDeeHaPVlAo8/ZwxIddLMYxMl1TzllwXx9HaFIUT4cLgiTvmRtDK/QYPm59dBDYWr2/NnlsdnQLIYN1uGuvQ7DEld+ozwDZpf1tbYk1nJ4Zz+FEFjB0y9nagzev72X/B3IlUSQh5aUn97PbnyGCf34rH2tzCiTS1pV/Zx0cdZgTf0RR6S9uSw0hIzbiuU1Bq0KYcGM19EEHMPB8GNgl5wtxRq8275TFAiB8t6n0hDz3Fd2XLrrd6lJ6+jmw48WhTrBQ4CGcvDZM3s6VnQsGH5+9hsHqtjMmN6U/YshEpr+G6lzsBgvDEjSvDU6tyxEUAxqpOMVL8nz0AUGnjyaC4VF88/7K7gHTQW8PRasVw3WWvjpebozafk+YL2/pXz1esh5OnMLiMHhnO4gCRnnsKTuM5uNG
 XwbrEI/c
 tQMuyARtv3HqnknHBL4up5h7YXv3S9AS2f3kmXKDACWESTdkpzGgdF5kBixiEs3X8HK5lztaTF4MkiTCN9dBiiafQWp7wlecA0Xcv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alexei Starovoitov <ast@kernel.org>

Since the combination of valid upper bits in slab->obj_exts with
OBJEXTS_ALLOC_FAIL bit can never happen,
use OBJEXTS_ALLOC_FAIL == (1ull << 0) as a magic sentinel
instead of (1ull << 2) to free up bit 2.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/memcontrol.h | 10 ++++++++--
 mm/slub.c                  |  2 +-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 785173aa0739..d254c0b96d0d 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -341,17 +341,23 @@ enum page_memcg_data_flags {
 	__NR_MEMCG_DATA_FLAGS  = (1UL << 2),
 };
 
+#define __OBJEXTS_ALLOC_FAIL	MEMCG_DATA_OBJEXTS
 #define __FIRST_OBJEXT_FLAG	__NR_MEMCG_DATA_FLAGS
 
 #else /* CONFIG_MEMCG */
 
+#define __OBJEXTS_ALLOC_FAIL	(1UL << 0)
 #define __FIRST_OBJEXT_FLAG	(1UL << 0)
 
 #endif /* CONFIG_MEMCG */
 
 enum objext_flags {
-	/* slabobj_ext vector failed to allocate */
-	OBJEXTS_ALLOC_FAIL = __FIRST_OBJEXT_FLAG,
+	/*
+	 * Use bit 0 with zero other bits to signal that slabobj_ext vector
+	 * failed to allocate. The same bit 0 with valid upper bits means
+	 * MEMCG_DATA_OBJEXTS.
+	 */
+	OBJEXTS_ALLOC_FAIL = __OBJEXTS_ALLOC_FAIL,
 	/* the next bit after the last actual flag */
 	__NR_OBJEXTS_FLAGS  = (__FIRST_OBJEXT_FLAG << 1),
 };
diff --git a/mm/slub.c b/mm/slub.c
index 212161dc0f29..61841ba72120 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2051,7 +2051,7 @@ static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
 	 * objects with no tag reference. Mark all references in this
 	 * vector as empty to avoid warnings later on.
 	 */
-	if (obj_exts & OBJEXTS_ALLOC_FAIL) {
+	if (obj_exts == OBJEXTS_ALLOC_FAIL) {
 		unsigned int i;
 
 		for (i = 0; i < objects; i++)
-- 
2.47.3


