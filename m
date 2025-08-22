Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EA7ECA0EFA
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 02:57:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1C4C8E006D; Thu, 21 Aug 2025 22:57:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CBE28E0056; Thu, 21 Aug 2025 22:57:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 893E48E006D; Thu, 21 Aug 2025 22:57:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 707488E0056
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 22:57:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E4C2D1A0541
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 02:57:43 +0000 (UTC)
X-FDA: 83802883206.30.41F83D4
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf17.hostedemail.com (Postfix) with ESMTP id 67B574000B
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 02:57:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OsbxunWD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755831462; a=rsa-sha256;
	cv=none;
	b=CqtkU2DKhj7oA82RhgcopWOh72Pe64IwxWwLzDgr8AdRKgdDvrzazOfJbV7qGDsR8KS0wJ
	bvOcNL2ND57dEsaadUspIQsnfs0ss2xxxBAVXmk4rEomYM/gL53bN1LhNQEpLzGSuRnMDe
	HldiwtQ1fdz1y2JdTwDBw/jAaZ8O8DU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OsbxunWD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755831462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=QM6ZZcjAsWUjNjLk9+5e3bZNbCpR3x1yF6anLCH5Nas=;
	b=AMcZhBdzdgac02s0jqu3rKYx25bTVtFcZeN/yJe3NFSOa41Z6UBFAGJYfVBzNS+yLiI9WS
	BgGjywUspyQd80RWvNm1cj7R8uaW01+YGFfQhBuj0E/aVWSkx0OKDblGhRCQlVX29K+zQd
	ucqa3N5SsSBIvofH9IUP5jS6oQNsdbM=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-afcb7a8dd3dso241165266b.3
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 19:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755831461; x=1756436261; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QM6ZZcjAsWUjNjLk9+5e3bZNbCpR3x1yF6anLCH5Nas=;
        b=OsbxunWDlk02KPxUYp2hRqFzNtp8WvvSV2LocMLxmfadhA5iJtzWSSBSYqYcbdam6Q
         r9hyVGrYBqdSHpBCMZEqeRnlrY+xpE4BIcZaXifuuPrT/Hi6oGhGBnB02VFIIyhn1Y7q
         hXQil9ul7eukYoAuOVh2jlSLovfVhaQsG7Gf1npywMiZ0eDVPwFYX5jBqay1miGXTLqY
         xbnSbTH6mv00CM9gsF3kaqN5eMzYU0zJvW8zLTnN5eAD0QW4hK2MCehxglDUkQIM3JLL
         9mZcBH64tlg83dqbFVfHoqc4boZ3lT3f8ODwEmQ6DeDtejFraIEq5rUISqz9KNl/Soqo
         fxhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755831461; x=1756436261;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QM6ZZcjAsWUjNjLk9+5e3bZNbCpR3x1yF6anLCH5Nas=;
        b=YA2TxuB3dHWJjMMMzcKDO51FjFhnlAU8v2Ev+5YeWIOOTckQ9wSKceHBz8eCz/FQWx
         8z/PXlr6lrt1zxpDq8YlkZCfRO/bD52xglAPHWj4TTXfWI3klP09SCM8iXEIe6/Z5pGr
         XS1hvaf+lk86asp0VZpfvHpVp3NVpSxPac0Khp35L/AlTCbraVABMiduys2NZBA2wK1I
         O1svuSgttOKoSSvj9PjDFnBYDCMvl3Rsd6RMQPa549BCm/JTnH5eSDVEFZSjjhew0LO+
         zlcwHG4w5Y2pGCOTGSXqedNp1wt3kIXqOHmyLOjexrIjLPB18Kb2tYInurCPQQXb8hDE
         SZ6Q==
X-Gm-Message-State: AOJu0Yz1m9156H5s35/t2xACr21tYhuqcWDj8uj6uxE5y7447xKgcUyt
	JPnjFIyYqGUXtIcSffRauRmqU45PbzwtRoTgeJgG7/SlX9mG63vmAhI7
X-Gm-Gg: ASbGnctSpq/OUHPoIIQssM2t54oLO+1pa6ABrrlqL3+IRfAbYVeqS34u5R7RLsAhFCi
	8y2ncmxoXImf/TSaWKZZNfCHYtqo7aZbfM97uGlVcRdj5iVQWQ8F5+h+EHjyvVYYsxq8BlpRipX
	kNLk7DLSIwCd5zrYeuf3Se22r+EAyLE+ulo2nkAzivbAuxrGxZYrKmJ+j8ZTS38lg7CgORp0Om0
	SD8/jyeGA7PZt1Pcb9MLqHX34E/ySTqlGSpjtkvvDccgTBOkDLf6bI/VFJO3zGn+PJWXlE4bpkE
	qhxGpF8xZadP690MkQFn4bryaotVDRteJy4sMwVs+wAO+/CWggyEngvmSscIEUXWXIDtKA4U0Oo
	RB+rHx9HLnuv24dvKJhrJ4+OHnBTdzKOU6ZH9
X-Google-Smtp-Source: AGHT+IEXzzswC0XQ9rLOu1GUP+4XTKR6zYMMVXmXre93BzbdLCw7Gam4vNP85w3+Dy5997Tzsyd2GA==
X-Received: by 2002:a17:907:1c91:b0:af9:341b:7fd7 with SMTP id a640c23a62f3a-afe29605d3fmr98808366b.49.1755831460519;
        Thu, 21 Aug 2025 19:57:40 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afded4c8713sm514489766b.78.2025.08.21.19.57.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 21 Aug 2025 19:57:40 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH] mm/khugepaged: use list_xxx() helper to improve readability
Date: Fri, 22 Aug 2025 02:57:32 +0000
Message-Id: <20250822025732.9025-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 67B574000B
X-Stat-Signature: 17rrce9wnh3o5z7qizsoao5wxcws97uz
X-HE-Tag: 1755831462-235302
X-HE-Meta: U2FsdGVkX19N407HhssjTXduXZADy/DHj1jrCk0BQOIJvxDAGnRaPW0q4E5R7VytWGGNCPsp5M/D5a3bOrDplsvA1QEjQXMN5DM16lv2nk9K1nlg9HcUw67UQ8+UrAOZODvjPkaOPfko/ur9DwK+1Yi4/LY8XyljP8WdcjIOZ3GpZTZpJil8E5r/5FZSEhZcQU2f2/SlIWJ4aYH/N/HICQ0a2SJY9fcS+zcUA4eRgV+wVzaaTDXQTZEE3Qq2xShiDkBZ/HAe6NnjYmhEhD4acaXkxkAgeBHzLZQjnawKkCCdqeJXhwfzn38g9x/3IfkjemeQtxBJXu6kcwzgFRJwifP3Al4fOlyO5dK4ozvbv2ZmXWHX3aSV0fjXbNb8XIObGS+7tpPm9jWvhDhzZMummT0dYSdTODZrjE7S4PTKTuolzzAAplZoFFHyrjzb9+MD31iN5VsSjsZGo7En4FBzzaqqlSK4QrgitMne1pwW5vecGWtX3X9LC9UB3hisbNrS3JWiH7ENI5kV+cF6nkeffpDbiQpndEdsdwUxdG1K5wsIQMBis0qwjiZFtgF5tk3VzEWEJcwCEvSr7xmD3MpK5iGaZtdY0n2kwc5okNWQH/KhLL3WlzGy7wHDO0Cnwq8f8rSTQORkIBtRK6gk57zVdoeLSBhm+C63v1ffynNDKqF3pFuOWI80AIUW3N+y+xite93+IseNYCkt7A5a8lw8wxISz1KGrhvGvsm+LUyvqhMbYApr6F9FcFQybCSGqQJ+UoA75hX6hXbWEB86FOll9dfgt4QJHTs4eoMmWyQrLeSjvUTD/XJZvuBWabsGZ+9jzA5E6bcGIRm/pmTyTaKHdgOXiMhSIzUmWGO8x90UuC0Ph9ta6SakbslG0IFinWHCg8P8RmVroLI+zSJs5H2i6FzGiyragXNb0PxN14z9IjxzBIkzG9MZRlxoh40JWAILaYqGUfJP/7NJAC+PFHp
 wJ99zebF
 q5PmY1MaLAaz1yH5m0Gr9Lln4QWxH65mPmED8Yof411L8wgo577/D4I0K+JOJ9uOPtuNNh1UGFeAkdjraw7TiIqIAPjC3JevpBYugTkaOmNY/QgKgpEw7TJvvaD70pQ4gdJJdoIIar2AkzWZUEzO1RrFYN+5UxjJd0z8e8cw1XFEdQCCtp18m99583cTRlWlQUin1KdkzSmJoANEC4jwylGLoJ06/aBmgD77KyHlpkWd8/5KEQfaS26+LzA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In general, khugepaged_scan_mm_slot() iterates khugepaged_scan.mm_head list
to get a mm_struct for collapse memory.

Use list_xxx() helper would be more obvious to the list iteration
operation.

No functional change.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
---
 mm/khugepaged.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index d3d4f116e14b..24e18a7f8a93 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2402,7 +2402,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 		mm_slot = khugepaged_scan.mm_slot;
 		slot = &mm_slot->slot;
 	} else {
-		slot = list_entry(khugepaged_scan.mm_head.next,
+		slot = list_first_entry(&khugepaged_scan.mm_head,
 				     struct mm_slot, mm_node);
 		mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
 		khugepaged_scan.address = 0;
@@ -2515,9 +2515,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 		 * khugepaged runs here, khugepaged_exit will find
 		 * mm_slot not pointing to the exiting mm.
 		 */
-		if (slot->mm_node.next != &khugepaged_scan.mm_head) {
-			slot = list_entry(slot->mm_node.next,
-					  struct mm_slot, mm_node);
+		if (!list_is_last(&slot->mm_node, &khugepaged_scan.mm_head)) {
+			slot = list_next_entry(slot, mm_node);
 			khugepaged_scan.mm_slot =
 				mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
 			khugepaged_scan.address = 0;
-- 
2.34.1


