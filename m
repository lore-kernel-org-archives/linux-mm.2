Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCC44CDB47A
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 03:00:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6509E8E000C; Thu, 13 Nov 2025 22:00:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B3228E0002; Thu, 13 Nov 2025 22:00:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47B518E000C; Thu, 13 Nov 2025 22:00:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 364BB8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 22:00:38 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 04FEC4C24A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:00:37 +0000 (UTC)
X-FDA: 84107709756.16.B1CD6F3
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf23.hostedemail.com (Postfix) with ESMTP id 357DE140012
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:00:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LdZUcAAb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763089236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=yoGwnOdJWrl0ut0GAuKH4GZkYvGu6fccguAXlKejBfo=;
	b=HWY3coSS9m+wWAwujSr+zK3AkzwUIWId0EsFz80495LISs54axM74Z1MfPpUp+A5GbrlWA
	ChKRdR5U3h3pjIx81tpw1Ro4UDzGj73iGpKA7gfra6mUGcR/XOQrCpFuOQRsCn5O999NG5
	+wrNjOhlvfp5O7obG/wzE4Cxq/6FhFs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763089236; a=rsa-sha256;
	cv=none;
	b=mQwpfDN/hSuLCOZ8FPgvKj9/4zTeZ+o8zT2ZnP5o/sPQECP4Th6BRsox36P47ik0LPJ0uR
	VS7ZJDLciCnyXT4EmJ5NKSBjCQ+AbxWANWXNx/IOlWDkxCnsoSsnmLah91Y/ac9dYzkcoJ
	IWSjAeAAmjnR0U1rf3UtZ1kjpficKb4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LdZUcAAb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b736f48ba11so8662066b.0
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:00:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763089234; x=1763694034; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yoGwnOdJWrl0ut0GAuKH4GZkYvGu6fccguAXlKejBfo=;
        b=LdZUcAAbKRrAM3niWmdZeU7xWmaD5Ge6lFtrbyFejCNbVF7/M+HjtgpXKgw+qrB2Y8
         yViY/bsVqec86+TuSmMmmI0yTs8QrbCMvqZIYwd8SaYFnk1gyHptdHDAkhVzb8nh8yv3
         JOzjyjx7LFgFvtU+0gvad/v+Re8QN/t/mxe9y09zCY/0m8ZIVcHonHVN89CmIDdRVCdu
         BO2sRFWdPEQPOY540SaqaKAsZtboLqD6REtw8FuI+MD8FbzoLhXIdEu5xNCZo7tmygsL
         mfGMNW2KGG43aQ9cvhYZGv1XNXhO9BonqNfchNullov0amrD7f18CaHJUn3qCO1JvM01
         sI9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763089234; x=1763694034;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yoGwnOdJWrl0ut0GAuKH4GZkYvGu6fccguAXlKejBfo=;
        b=kWlZJ5nFcY6vcwQoD8VAWQl778ge1ioobSPWkuMWU4HQ8UcV/OyV6Dww9mbhgtOeq4
         wlCLzB2zr41tayfWH3q4B1M6+Q1c52f6afWSCWSezhjkAAacXqVzSAGsHQXR8AF8NB10
         i3oh2ooS+kU2UnV19zI5Vqyv0lhOKa4Zk6cpgpgtLXV6L9EqcLRi7AvNGxeolifylRMB
         TMI75hHucTiSljrFVk4MyosimBlpFdMz+vsz4ybt/MrD9OxCRaCLHynSWnbN0WS6DwWO
         r0f0JhD9kaKIMR2Dy/fGje5Y5HdfSBXKp0GD06n3HlpteQcO6kjNhNqeyvEHVz4qFBd9
         g5jw==
X-Gm-Message-State: AOJu0YyMCb1mveQHHF/b4FRbxDY/ySXYwJNjr+auUCTH16IrFC/0zs14
	pZggBbpRYs3WNQsWNK6F6iqXPG1R560f5aV1IPLV1C8E+TFE62l16gF3
X-Gm-Gg: ASbGncvBrlICnNOgCgRvv46kpV/XoDESjg3hHYdPrytdVl1jPrrPcMtoqo1iE0EbIQK
	06UADLZlsKT+yoEsX0zY6EkFrglKjZ0RWHXgw8i/woxXwC4kBumLTzw7DUqOLU+xGACujFYjDZt
	CtUm91bdsOX0f655ZzGUbcyGEUOMRqpUQFLrefeYSOdM2LX7ajfpZC+sy7A2TGLhIU0z0xJxQCL
	z5W29Wrvy6kzWJ26iwpDq4lFswUILnQZ3IePOn0zcsOFNQAsdyt5iFiEZNOTTM3yV8tkoSRlJ/+
	/Fno3k/jITQ/MxRH0fR4KS1F5Qj54oXI+xB1VB1Mj8Pd1mimhnLun8KHU8Hn4/o5AH95fzC0aFz
	YoGOZYWIZsYCXChu9PV+StDfgJ9yfQ7i361VcKl3NXzHjAUzYJoN8IDcm8HjCloMVoRZc2y6/Eu
	IYmcTP31xhieJRZOGX0/z1f10T
X-Google-Smtp-Source: AGHT+IEj2IjyuBPiMB+BaT4MHDRs7WRsiDZuBEb9fZy3s8dDq7IaFqVc7Art3qbUGfwVcD3vVXnm9A==
X-Received: by 2002:a17:907:9703:b0:b72:6224:7e95 with SMTP id a640c23a62f3a-b7365749ef4mr147192766b.1.1763089234318;
        Thu, 13 Nov 2025 19:00:34 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fad43dfsm292482866b.20.2025.11.13.19.00.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 13 Nov 2025 19:00:34 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [Patch v2 2/3] mm/khugepaged: continue to collapse on SCAN_PMD_NONE
Date: Fri, 14 Nov 2025 03:00:27 +0000
Message-Id: <20251114030028.7035-3-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251114030028.7035-1-richard.weiyang@gmail.com>
References: <20251114030028.7035-1-richard.weiyang@gmail.com>
X-Stat-Signature: k48wtgfg6w6qetzxoqcrqj6cabdah6xn
X-Rspam-User: 
X-Rspamd-Queue-Id: 357DE140012
X-Rspamd-Server: rspam10
X-HE-Tag: 1763089236-720819
X-HE-Meta: U2FsdGVkX1/QPlCUotXG6VatKs287TJ44XqMqbx9XAxCGfM0bT+SEvJpF6MOPYW0RCpiryILMGsIpSkq1UyjxFJhF0/xFp5TCgdYtI9xl02o6dRXmcPmsghqgirCLs0fdILUyCsR7HUI035LK9ty4BcIVwX7Wi5sCe/dDuhKQiXELxuIYrGMmHV7m3wA/14Y5fkjs1RKW4VvHBowG/Xx7KWUOXPKePMfaekeQByPQaXiMH6I4qX6R1Tim2tCK1U7w0ebuRQp55CnMXciPrlLOX1FDMgcIvZNhrmgwMLr9np+Bs+ZJISCqDnsE6XDGuQCtPBBuCqhkAJTFN+uwZJGSowK9MgI6nosFH/BPi4dwbPRAmfFr3JETRsYdiT7sqOSd3ALBSDaIh0ZBlxWYyeXZvAv0YQJO5cL3KoIhOoOcL7PlzzxO5qCdgaFB0gkdlOZWPPmK3zqb5iV2KJHNFS8UGHO3YUEr8/nvQ7KI4bwUeBYDVCkfpeLDBlwyzLHn7wfVigfrVYlZmyY7rQBP5817dqXTkgO4a+mRUiTqvFe/dUqu4W4csuYgcSXoqBityCV9QFXw5dvQsgD8b8uoe9+gZVLgBC5SaWITLSDtyt53D+zJhDZD/Rt+HfIWwmsL66HLgGgk1ABTwFpAbS1Mqlsmu0T+qDp/SLIlJTY8Aev5dw9H5VDK3B6UyRj2J41LTeJK56Rh8mC0oz0wsZbv6FrwxRHtAzBPoMi8DCOuUw++KSiYXU9/cLNsWdJiEidRdS2g9bLcG5juprYpmZcpKQVDMk7OPzqndou0U9dv5dkvTwElbAuVYt0ZpVtK7+V/znuSbXZHOjDyb46hOnpDSRP82D2SI2x+UDXsU1DfiEMiwHEUWOgAFvsdXMJw4PdkKHexCc863wQMskdIFg1JHI0oCw7rnd8RBJGDmHcQZ5W/BQLmYVMKClj2k53qT7A6zUTJCC9NbTr9kYRuGaNUAG
 0fc1RnL6
 cIuOBl3AiiqJbOfnCOq1LRu4Wuwd79ozRkQKvBb6FIYhvqBDQaTmXu0EN7vaa4AjorM9UGsSN87UPLCC5mywl36c1aM5DKHDG5sNUyVIuK2lCwQ2jng0sPuiGj/VFMFk3U1hN9I4+kfvNTCTagarBILPhExauj2zRl7OUVsHw1S4FEUOu5HB4D1mRvqBrg4T2Xq39LoZCrbWkODtTSFCybAiomOi1ky8cMe+xOWIb0RzYS2o3L9mG73jBRdsnDNazkKuSh0S7rbPu2G8aSQ6u4ynavGSa05tyDE1G5KBzoqw78uxvUi5vuEmQW26I5r4ITWbaSUWegfWJiiifBcNBB8LFfAHdGQ6gokoegKyvuf/0sLOs+dTw9QFObL6ND7lm9Q4AiGdRNhZTkOQIxGEIQ2j7G0vR4lz1Sckp+KsP91IGeEfbN70ukZwlYEaAiYlJ2EqoLn5qymS5O5NZFHiyXjioJgTtpIdBgiw0sAgEW52vCJ4e3In0Pvn8r4mcGWIJHrD40LT7Juo9aj4bTiL9xsxqLUaYjq6VAPWrKYlOs0+fG0H/Wz++lqbLwao8L1uW07Cv4rYmG6bE69nKSqnS8rlYjRk8J8GmjHO/u1vaimR/Ijnd4A4IAguX+/eI16T/8IL2Mfpl2/pjd4n6tZBTAgXCeQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SCAN_PMD_NONE means current pmd is empty, but we can still continue
collapse next pmd range.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/khugepaged.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1fc8986a28b3..2ee5048b764e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2833,6 +2833,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			goto handle_result;
 		/* Whitelisted set of results where continuing OK */
 		case SCAN_PMD_NULL:
+		case SCAN_PMD_NONE:
 		case SCAN_PTE_NON_PRESENT:
 		case SCAN_PTE_UFFD_WP:
 		case SCAN_LACK_REFERENCED_PAGE:
-- 
2.34.1


