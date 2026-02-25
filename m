Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC532F4BB9E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 11:05:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 422C36B00AB; Wed, 25 Feb 2026 06:05:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F79D6B00AC; Wed, 25 Feb 2026 06:05:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FA136B00AD; Wed, 25 Feb 2026 06:05:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 193996B00AB
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 06:05:06 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CE8911A0525
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:05:05 +0000 (UTC)
X-FDA: 84482696970.25.104C4E9
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id F1FC240012
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:05:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lOWVMKYO;
	spf=pass (imf04.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772017504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h3hNSWrs4Z8eGQlDuu6Oyc+V7lXYEg9lf6KbC142PjA=;
	b=dmHyd89sASoN+iToXeeXJ81UFyDdl0TTLVoth3EQtoGZ6ClGf72lr0a24X4aHSex+eJP6X
	xej7f6yEFlmM69msJaCT4F33qR+eFnYmEHRbsQTPNKzh2dSYswL5pFKyi7BCH00+VHlGpJ
	67TkYvGCXaAaOZ3pLjZBUuvM3YImqYw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lOWVMKYO;
	spf=pass (imf04.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772017504; a=rsa-sha256;
	cv=none;
	b=a7VflFfkJI+/onLxf8lSGU6oR3m/aN56kJX2rLWDADr/bTb2RF5UANFwvHY2kFgD3OxZks
	w20fx8mhpzq2cVSf8QP6lgYE3kM7JYsETnEyv6Qc8a2miLR4xcOmm3QpgPsNt3D/9pBt5P
	AedvAi4WJ2EEqXOJ/0p+b+KolUN6aQU=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2ab077e3f32so26160475ad.3
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:05:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772017503; x=1772622303; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h3hNSWrs4Z8eGQlDuu6Oyc+V7lXYEg9lf6KbC142PjA=;
        b=lOWVMKYOXkCXxFGjyNrrg8oXfK4wtYuvIq2YyD42SJrZ8c5XrqWUiW8Z4W0GAK9674
         W5ieTNZ9nefV36LfOJmmDVQtlKJXBxM3MxRtMq6w2yQEoRwSvG8WSP2KNuIXzKyPJ8QF
         mytB6mtQ8Mfvg+gt5Tz+bP2xrSy5s+e3L7C8dhSIYyHM9UuUJ9pAQBhyuhRGM5KjOvSr
         5VTBwaoMkaoaAhxmC0jAMNtZOcnlO+jkSU1IjH4T+n9S1thnUvoW6MyWQ12kJfeOQfq/
         4l4FJpQQVy4/FqIEMXC7YcOpv1bSJxSQv+m0Uutq5gexlRykUpEW4zWJ5QpfEMgFUxEN
         0Aug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772017503; x=1772622303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h3hNSWrs4Z8eGQlDuu6Oyc+V7lXYEg9lf6KbC142PjA=;
        b=qmNWtM07xSRo0PEBdb7XonNwiMBlpQShyS9Z82nXvjjmTAIwemWDFFLJGDrh792DM9
         maBROUvrNiNEwqFHuKJSee+DfgJO8aywahqqnZe7gikYafOFruTLv43zoVJ3G92H632p
         mbjhU3SPsYaqrUEz8S52AR92rWcBSxaNAYBUj4GtXpHkjTC5HvQyBypOXYRBUCFJWdL4
         3WGyXdRBUu/0cUyCYbNNHTHbxrlZ9DhQVYMJA1R1GPoze1MKFOsI+y0P8D8A/lmHy2rp
         hvaZYbJYCX+eoj4qjhX0sLHQAfsZ/NOAYrYcV0oFZGF3DSnzOUZfu1YYLklMHN+9xr3t
         uUDw==
X-Gm-Message-State: AOJu0YxGSurjcY8wUvhXxynRoK6vq9E6ZYRU4ffHpz5yW8SSKWm9FwzT
	F9pxZNauqzL6SxPvQBvQRAmfEJ5qZEzNDehfyMvvf6XucNnsrlmdmPjN
X-Gm-Gg: ATEYQzxL1aLRVJxNNFf6LfA+D5dwqx2BkZ1X59S33wBXFs3uwwGF9QR5g0C8BQ8RuoY
	LuTgbUrHjs+N/LAzQaq4cwU6NHDqsOkcZXG4BAKrjFBwVxJfglz40NHCKhRAY2zQArYXzECEAe1
	E57VA64oWMRHdx+abU75vEyMIx4Lyy1SaPDtha34Uzfb5XpdoY3w7mlKKiMKILuI3KIJqWjjM2F
	BpgdGwbsROJOHn73ypaPmEFOeiICaDJ0erPA7lsO2Cj28dZ+oHJ4QX/8Ua3HGrf28PqCS7whG6G
	lOjhxdHET6cI8p2TCcRHdG4IkKX/CWuyefMs1ky5L6VB7kbpN9c9+6xaP8xDox95N2wLRMBqORH
	dU3aZnERuw8HpsdViHcoRNlR9RN+1qF8425EihogDlCJzNkITjxYbBcNIhS09Dc5T2RiU4y8KAB
	3996V+WFbmnMjSvQSB/2kNKCA9myvgO2vEFnDfHLcAKg==
X-Received: by 2002:a17:902:c94a:b0:2a9:649:6f5 with SMTP id d9443c01a7336-2add11aeeadmr23737835ad.12.1772017502631;
        Wed, 25 Feb 2026 03:05:02 -0800 (PST)
Received: from dw-tp.ibmuc.com ([203.81.242.210])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad7503f9f5sm138365975ad.77.2026.02.25.03.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 03:05:02 -0800 (PST)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Christophe Leroy <chleroy@kernel.org>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [RFC v1 04/10] powerpc/64s/tlbflush-radix: Remove unused radix__flush_tlb_pwc()
Date: Wed, 25 Feb 2026 16:34:25 +0530
Message-ID: <efb8f299f33659fe07697a038138eb5760c78707.1772013273.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772013273.git.ritesh.list@gmail.com>
References: <cover.1772013273.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F1FC240012
X-Stat-Signature: qrzozt61dqcpget4bh7y3nk45x1n1b9e
X-HE-Tag: 1772017503-775760
X-HE-Meta: U2FsdGVkX1/vxr6fK5HhAQMsrFbns/GRj4fIlxK5Ozpu6D4uuDtCeEC5zSgyVl2FnhTV55WRuHLjZdBOZf+N+1u69qxVkxLEiUNYV5qt6mR27DHttxHaUGGSn0d0Mi5zCPlS/EEmLqbT8rI4Pri2BBQAjatooH3UAx52y9rZTnLZ85dM/gzLYhk8VlosVF5ucgCPVAzUj/2z6UyUwjErSl1oAQROoZZnFTGfeiZgUeSjQKT9I6eG8wkbjv3QgZfRjdyZxg139cuLmOkuCFW2cpGCMDVbvGcW+nhcBfU3kBq+XV6oU9eo8Mol2CnRS7y4yv2QqX6vgZq3fo2oLa+pImgFgB4zgHy8OWb8aVZTuCEWNm4yav9ifnUw4GUTIRdzmnpdRmmWRxvm2KkJkfG/yL4csxULwcHuDisX4VT6Z8Ni+SeyqK2LZahDemWCUm3Lm5kchmePTgHP8OGnF7hlwAurF4gwx0woDrCE7Y0+SH6dQCG59ifdAqYYCPud6boMj41HhVLlO5x/g8IF8PmhJTK0ptLnV4UpxNJxEcPkzkLPkW8enHei45Izdi99gjxqoU7POY2wXgeiQyOxPlUsQ429/FhQBOBL20KFn+9XttRSUf1t6l7Wm0Yvm2OPvIRmZ4JfdgNsj6UL8rVGF/YrcMtdNjoWGG+B/weqNTXu1hOb8UnkVAYwDVGOUK8iINyQ6bBNKqOiQzz88czxYP4VjUqYNqC5ty4MTpZ5BE27WQcdxCVrq9t8TBmPmYA+tqlgYBa9S/jDLs64ZDmtTK7T0vOSWTJ1Rti+W2yjCFCkcy6ip6LnvfG3iarIHN1SuncAsXnmzvNtXzTx19aACQjSy97ywT85Qq5gBNaIoU06gN3HotwfusphHqGCAHFFgoejC0DzKdKrVcxqzMmoBIIx4WdJaQ/XDB9CXULXZc267ehqr8zieZAyc112eBWZ9BkEXjlFDefZAbc4YeUUk+O
 CsGkuf5g
 UeWprkNTYQqH+Xj6bUARAK7+qEQp8mR/fz906IvimkUAG/E7LfBy1b3BVl/sABuSXBXGN8BjLNVubpGsxX7KjoXzvPJIC9UCbXPYOwZTrvTPFtIsy0AfFdHjfRAkiEl4ZdtKSH8EZdw6tn0c5tTCxk9Z7cQ0ZmdDKNXlCvHXqa3M9+3iWoAkpHg+YHMmVVgV56Dl2siEEvJaQIN3LMGTxHxAhIt3LXm1hIlb8G57NPvSPHN5znKo+GBxszvDXJTv5SWcrGazWDO8TzngHhlg8MvtNN6Ebs3oLdrDAeZDa703RoqcYg7pUPqmttydN3PvfJ7jrXeo9TCD8N/DdNOgpe0YT0LfYirVGeuUx0iCdk8N1PJCrpq3QxKhrESB+gxcrLtw7wNZcnfIjF1nNypK3DojXCZoOyWNMekjv0KvKs+G0rfkE8MBdkfVb710Wqftt8TReogzFa5VZzxMuaA6whj44lR9dCwEhGmcqls+rj+Cpck5eJtV4yB835QnE9WSsqvKLS/LIhub0uNczhHj+3mD+n/qS+pLwOG3euVbG5gOYTXev3mdgGhXwvWhJ3iMrOKm3bw3x+zBlQU39LsEr08KlbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 52162ec784fa
("powerpc/mm/book3s64/radix: Use freed_tables instead of need_flush_all")
removed radix__flush_tlb_pwc() definition, but missed to remove the extern
declaration. This patch removes it.

Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 arch/powerpc/include/asm/book3s/64/tlbflush-radix.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/include/asm/book3s/64/tlbflush-radix.h b/arch/powerpc/include/asm/book3s/64/tlbflush-radix.h
index a38542259fab..de9b96660582 100644
--- a/arch/powerpc/include/asm/book3s/64/tlbflush-radix.h
+++ b/arch/powerpc/include/asm/book3s/64/tlbflush-radix.h
@@ -92,7 +92,6 @@ extern void radix__flush_tlb_page_psize(struct mm_struct *mm, unsigned long vmad
 #define radix__flush_tlb_page(vma,addr)	radix__local_flush_tlb_page(vma,addr)
 #define radix__flush_tlb_page_psize(mm,addr,p) radix__local_flush_tlb_page_psize(mm,addr,p)
 #endif
-extern void radix__flush_tlb_pwc(struct mmu_gather *tlb, unsigned long addr);
 extern void radix__flush_tlb_collapsed_pmd(struct mm_struct *mm, unsigned long addr);
 extern void radix__flush_tlb_all(void);
 
-- 
2.53.0


