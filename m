Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0893F10F995C
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 17:26:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD6676B0089; Wed,  8 Apr 2026 13:26:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B609A6B008C; Wed,  8 Apr 2026 13:26:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2EE46B0089; Wed,  8 Apr 2026 13:26:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9064D6B0089
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:26:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 491BF139CA9
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 17:26:14 +0000 (UTC)
X-FDA: 84636067068.19.4D897EA
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf05.hostedemail.com (Postfix) with ESMTP id 732EF100010
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 17:26:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qzCLoAew;
	spf=pass (imf05.hostedemail.com: domain of 3s4_WaQYKCII24ongtmuumrk.iusrot03-ssq1giq.uxm@flex--wyihan.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3s4_WaQYKCII24ongtmuumrk.iusrot03-ssq1giq.uxm@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775669172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i55NDozws+Qi2zC4BPESxJxfrP5x0dQcJH7CMgcHTvw=;
	b=qwx1Hvq4EbVSzGbE/nkEqo3Z8ZVOHRmOQWgnmy8d8xJ9FKmiAclZaFv3fZqut9Whean+Ou
	d+wn1nZZt+/P+KWJtdKr7XNwXfKZiOLW0S3kLdEStnNINVIERt1+R9Y13jzY66KQ/VOSha
	rrU8Or7zW4gQeQ7AfhdafDGyFPAuh58=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qzCLoAew;
	spf=pass (imf05.hostedemail.com: domain of 3s4_WaQYKCII24ongtmuumrk.iusrot03-ssq1giq.uxm@flex--wyihan.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3s4_WaQYKCII24ongtmuumrk.iusrot03-ssq1giq.uxm@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775669172; a=rsa-sha256;
	cv=none;
	b=Yt54vPbWGj6WL4WJODqxLGa4AQwxUXptorpJVLjRY37H2HK9FkEOsLoDf73claJ9Trao3v
	FVNXJeKwSIfg6hsdU/qPGcWeXvmdyJ4YAZO+sJBwSi9qHALwtznBWreUN8uvHF6G2ToM9y
	mBuFnvhEuQBUERww4OfpzCu6NhgPYyc=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82c89d4ce16so25361b3a.2
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 10:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775669171; x=1776273971; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=i55NDozws+Qi2zC4BPESxJxfrP5x0dQcJH7CMgcHTvw=;
        b=qzCLoAew4RxdStgOJQf6lU94+9e6Q/9/7bLp1JK3W4rq13z+ojEkOEK+jkhdsAxRCb
         W//Gp889sWZKeinvyvdvPlMhNpkmQI+l0PQC8UplfeEAWwzQEyvapIexgDmSvc0EXEMd
         eotleslr7lDCkpYlqSOocEjurh9Z0V3BaA+BYPj2Hu/VOr9Npl9a6eIE4HWF2KhiRBVk
         FBEuukmYB+ZVDVbKywYjWW7u/l/6ZIRLMP+UXXjipmH09DR+0/Wfz6Uh94NP81zygtZ3
         ZgjgrH8p7Vam07A6SofTtujig5WIRvty48xZAE6UuFbu/DgyxJNlegMecmIpVG4WicrG
         5eoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775669171; x=1776273971;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i55NDozws+Qi2zC4BPESxJxfrP5x0dQcJH7CMgcHTvw=;
        b=r8w6l6Ii1A7Jemm2VwzCukAZ0SeAS+52+jgmvxdNy6h7eW3h4TDA1L0AoidsbvWj96
         6vaefGgDGbhYhfkcmxbB+UMFTC4T0FP/Oxg7SUiUTSIQqkfgTcWjoMJbS8X+SX0585xC
         PTCp4Wmg6Wywby7Xg9/RreUjoCoOrmglR4iHAMEJ0uD3UJf/gfg2b4Ey0bH2X4odT9KB
         /r/dAWku6Iq7b7xGZ9vmWKCqYf31kjqUu0HPUuCTlCpWWAVCeJ0RFM5COBmyS7sU61zN
         I5Hwvs3AlnSYd+frsDPyF80Hm8wmDLruv7SHEXbcKYof1Yt+oGEDOrsZUFLV1zFEvhAZ
         3Vsw==
X-Forwarded-Encrypted: i=1; AJvYcCXfI6ODViObWft5M38cESN6hApzBXvmnLBhL1cCSLIQxabtH0vw6ZiGGy8darfrDM6bwRLSgD8/2A==@kvack.org
X-Gm-Message-State: AOJu0YwUO6giw4DsEw4vEcw/dE1wVsaFwnH+Pr7qqZ2lbAH50sdei8jx
	GsnKZsPR8rW4rLIqdYe732DH1XkX8NP/izX1EzPC1od0minbZ+hZinbaCBr8ZMnEYkLaDg31QEx
	kcbdChw==
X-Received: from pfx30.prod.google.com ([2002:a05:6a00:a45e:b0:82a:6bbe:c0dd])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:6c9e:b0:821:81ef:5de8
 with SMTP id d2e1a72fcca58-82d0da4680bmr20598726b3a.12.1775669171123; Wed, 08
 Apr 2026 10:26:11 -0700 (PDT)
Date: Wed, 08 Apr 2026 17:24:42 +0000
In-Reply-To: <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-0-718f45eb7c75@google.com>
Mime-Version: 1.0
References: <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-0-718f45eb7c75@google.com>
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775669168; l=2390;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=tCUAER8XAOCDEwqKOePrak2HLKwWUrDfij0Iac7Dp58=; b=buXgD0W2k9Th2g3W9/TO/6Ez7VzKspI14jx1Q91h6/d29lN7r5B3H1yOm0SeG+gIqR4hNTHhQ
 1k5jFUJpx39BlVEg10kkWolRIctuvMivfofoisa1Uv7IEef0KJmZW7e
X-Mailer: b4 0.14.3
Message-ID: <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-1-718f45eb7c75@google.com>
Subject: [PATCH RFC v3 1/7] mm: memory_failure: Clarify the MF_DELAYED definition
From: Lisa Wang <wyihan@google.com>
To: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com, 
	vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com, 
	tabba@google.com, dave.hansen@linux.intel.com, Lisa Wang <wyihan@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 732EF100010
X-Stat-Signature: xtesuu8n15sssgnnazw7y51pccn8193o
X-Rspam-User: 
X-HE-Tag: 1775669172-166104
X-HE-Meta: U2FsdGVkX187KfR8P7G53mkS9teR13udsG2HL0ZQH7LilrHYTOA95bPzmH2ku97qQGJ6LN9Ms6NFn/WX1tExgu0vEg2LS7W6to5aJLdpE3nLqMN993qiGlCfxDPMacqUJxuhzNm8RfruFIn+XRQwPdAWwW6WqbjAxlKJfVl/3wDHRMJTp/TBGvO00ND29sQcsL/XXtT8kaNaS7PVbne7E35yCFoYKN2ngl8OVcS8ti95q/oI6nBTZ6RzTLAShl6RlrbP2jShnfLtytVP0sMuRk1Gnood2c41ws5Pda6sk1khqIRx9Xh8Wyhyr6rqzf17sQaxyd60eSbmdx1C9BQ2Bx0jl2Mv+IltOsYQWeiuQewXOc6g7DowKpuR0hOZx9GCOP0jzyMgRShf7GcWhYQAdgMZcPJoD3ZBCOxMmtTUksveNU8e02ZrYsI01tWz99nxlofOgNpMS4i525pkZ3UdrmrKEg/DNf3WjLEthJ+v+dBhmG0AqqOsIHi/7+2bUU/Kq7rVe4RAYltKWkTbu5RohehANo0aYyZ8r26WBdbzvFYb5LyippgQ3WkuC9+HvDdK4Ptf9T/Z2nZE5h1CRRPsepmodXWYglO40xZOIeQlXB+VjbYSKvFq28oM/EjgIDuwGqgIUOF8SsG9NPZbOym6e0DAfCGiqjwXQYIDI/gtFYHScLEIVUT9zKDNt7qDQ8yMRGTMGyPvdK0yuSbD9kexIbZVsNfSno+W0TbtQkEM6YjxhqUTQ3rDmqQE5JFBtqFlvNElaKwqEcwoUlgkMuNk/5Es7llK+PFRsneIW2nDXQA2sLhHnTK4MWSWwqJO1RCU27gEha//uSKjiyElKdcLKObLLQ+EIBsXwZiniIf76QVKKfo9lJh6x1Zgj4g/cal0BMlqx+qMcMnIAhFtxUPwq9qEFq2BG8MN3f2WPeDhjcbfXefKovz3Sm1tieopf/G4W2XdpasHsuiaVVW567/
 7rzrW4wq
 BYikbcOBdsyDl/u6M4Wu2Jfbia9NmDJmD3yoO1M6CIUk0jE2eecBfi66MZLQcG+j/87LXtDE9vTHEnojF1clf3//vjKBL8mQvKcSeisoqbLJLFDsobndavLJzrms8eu1kUjVSHxek7VyEe3LxL3qq3LVNRzQ1On/pJo5GjOfZhZjLaz/BNQXUfD1ncNfBE0kV02//MoyU1DNT/Y8hckF0cm1HXaBLXz1H/CssdTZtbhclRWt2132mV/a/ICsVizuzt709JFYFDIjyz5+Q3/TDU7FgoNa806ggMcatry1mOT0IUOzfXi7Noy60Dg8fIOdA9SWwTGVDC9LwORUVKkqx8r6uXyfR0AfplAhGA79kN+KAjjn20U66Mo5tP20D0548HXaNzKGJPIlUIhlK29dIfkoAcnLzbKl1P4mX1s0U4j7kG7XE5rzmvtBusZWLKB8mJlnNAuuOB8MoJD2B6O4/iEl1TiQollXDwupiwJwpT/GohqETSZhmRncNgposfOBNY+k5EOpzD7A2lXauvzRVYLkf+gyOqYek7ePDkqhpJoHUWGDvtxk82BUWZ70bUf4nGDO1iJn2cyBLI9LcWaaHCbDRWwmUpPOSuS94hYczhufzmOAwwSGy8V8t0iEh8358uYtPOaq405p/ueDdvyLe7jVgC9GoqflOfkj5bcVocIZsCHodAbqI+wodrMDDcfSrbCyak6Vnfika+JOcX3XEe3HaWB0+fMyTZnaGcYXd6dCs9Yf+UnV2DU9/sA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch clarifies the definition of MF_DELAYED to represent cases
where a folio's removal is initiated but not immediately completed
(e.g., due to remaining metadata references).

Signed-off-by: Lisa Wang <wyihan@google.com>
---
 mm/memory-failure.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index ee42d4361309..2e53b3024391 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -849,24 +849,25 @@ static int kill_accessing_process(struct task_struct *p, unsigned long pfn,
 }
 
 /*
- * MF_IGNORED - The m-f() handler marks the page as PG_hwpoisoned'ed.
+ * MF_IGNORED - The m-f() handler marks the page as PG_hwpoison'ed.
  * But it could not do more to isolate the page from being accessed again,
  * nor does it kill the process. This is extremely rare and one of the
  * potential causes is that the page state has been changed due to
  * underlying race condition. This is the most severe outcomes.
  *
- * MF_FAILED - The m-f() handler marks the page as PG_hwpoisoned'ed.
+ * MF_FAILED - The m-f() handler marks the page as PG_hwpoison'ed.
  * It should have killed the process, but it can't isolate the page,
  * due to conditions such as extra pin, unmap failure, etc. Accessing
  * the page again may trigger another MCE and the process will be killed
  * by the m-f() handler immediately.
  *
- * MF_DELAYED - The m-f() handler marks the page as PG_hwpoisoned'ed.
- * The page is unmapped, and is removed from the LRU or file mapping.
- * An attempt to access the page again will trigger page fault and the
- * PF handler will kill the process.
+ * MF_DELAYED - The m-f() handler marks the page as PG_hwpoison'ed.
+ * It means the page was unmapped and partially isolated (e.g. removed from
+ * file mapping or the LRU) but full cleanup is deferred (e.g. the metadata
+ * for the memory, as in struct page/folio, is still referenced). Any
+ * further access to the page will result in the process being killed.
  *
- * MF_RECOVERED - The m-f() handler marks the page as PG_hwpoisoned'ed.
+ * MF_RECOVERED - The m-f() handler marks the page as PG_hwpoison'ed.
  * The page has been completely isolated, that is, unmapped, taken out of
  * the buddy system, or hole-punched out of the file mapping.
  */

-- 
2.53.0.1213.gd9a14994de-goog


