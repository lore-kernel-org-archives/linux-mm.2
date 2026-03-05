Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE2ECF47CB1
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 18:35:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DB2E6B0089; Thu,  5 Mar 2026 13:35:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BC646B008A; Thu,  5 Mar 2026 13:35:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DF3A6B008C; Thu,  5 Mar 2026 13:35:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F0E46B0089
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 13:35:09 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B47338A843
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 18:35:08 +0000 (UTC)
X-FDA: 84512861496.12.77DC629
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id CBB822000B
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 18:35:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b="W3n/Pr9b";
	spf=pass (imf13.hostedemail.com: domain of carges@cloudflare.com designates 209.85.167.174 as permitted sender) smtp.mailfrom=carges@cloudflare.com;
	dmarc=pass (policy=reject) header.from=cloudflare.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772735706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vgAFxRCuIe2k8MVOR2tfsVRzGrubB49ONrVdiGmmwX0=;
	b=yJ2oTzmbecfeSEMn+9s0EL2cbG6R1BoVePLdthPS53H9lVhwqEqeXRCebvdOSRi0HZ5F+n
	CNcFJtI6e2hVPlTrHhgZEbERgXWplBSK8JSLZ0/op1fyABs+z4Ffp8KnSLe4kA8K++NerG
	93farIqUGjXvpnuNuaYoOdr8C/MiWfU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b="W3n/Pr9b";
	spf=pass (imf13.hostedemail.com: domain of carges@cloudflare.com designates 209.85.167.174 as permitted sender) smtp.mailfrom=carges@cloudflare.com;
	dmarc=pass (policy=reject) header.from=cloudflare.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772735706; a=rsa-sha256;
	cv=none;
	b=UhDB18kEOnAMQbIGalM/Ok0IkjdWJBwvopjBGp4WBtVMMCkhOlZ1ldlPcl67Ie5EvbqcHa
	TQmk14SalvVOQJL2Lkj3X4EWVwIkqMgZ6fbTsaxNJnroqyhDsvenDm97s1ny13rmsqCG0o
	EgEE6m9PbCknodKLSaP7KspdycFH7PQ=
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-463f00cda04so5333195b6e.2
        for <linux-mm@kvack.org>; Thu, 05 Mar 2026 10:35:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1772735706; x=1773340506; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vgAFxRCuIe2k8MVOR2tfsVRzGrubB49ONrVdiGmmwX0=;
        b=W3n/Pr9bdtndINZ0NsBS1rKe5k7BYUzwFtO5k2QYhsVMWdKsah/lb6L2FN+EnWeUtX
         XFnZ1713gmjf0V9jSLfR3M72Uw902y2//5mwFnP/VHYhlODLLvECZcpHduV3dJaCczFl
         oUFFfcN5Kig7yQ7Z6FCa50TUas3YBf6CGZ3ADu52dIHZCylNIZtxzp9icLjPkFUvuqxX
         d3WxynRfDLB53O5eU4CEmE1Q4Z9Nn7TneiOAzGZOXSx1c4purjUvbkdUjtjY0ciAdfgz
         FO0UgC8LufO82dyobLHq3C0pQYIteeYuV0YCJBaogGWusaLarQqO4ZhDQnamEi/8cKaH
         J+2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772735706; x=1773340506;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vgAFxRCuIe2k8MVOR2tfsVRzGrubB49ONrVdiGmmwX0=;
        b=adGNR071mE1ivP8fki8WU9I7HEyWAil36FzSMUF5e19l8IK9vktCzBkJ0YxJ1gU0fE
         fNjAgm6KpiccS4zB6C5RAkfDXXmf8WgO52a8Llb04GZ4/DPZ73Uq8BjBB6qRCFBySMDY
         t3PP6eC3XhKNH0cQ5mnIMcZOv+r+fVoAFuQ4FR8L8w0YyyERcnZO/JtKhYPw9aVzqacD
         Bf5ej9fJ6GyxWlTSmmFVgg0XkjgByLk1oOB2ISJxhMxNfkeLQ1M34bQF8EQE+060z3Eq
         rDLQVPWFoH8oJkqcQ17MHTcRS8pq7lYOnL2Pk+ZHjZw2AhaeqzWz15rVQ1tEF4f336bS
         3wDw==
X-Forwarded-Encrypted: i=1; AJvYcCWgVE4XIPssXf0+dg8Uq3emMlLbvsQjl3kcC9Zwu7xtbv/CrltUAm4bUsR5leyvOUD4bkPVJChWtA==@kvack.org
X-Gm-Message-State: AOJu0Yxpb0WYGjAOzBaIas0LhNOBDJsOjpOcUPKbW/NrDU+KwGrnlMj9
	KNqPUz37HvELU/YnMifGjnu0jcxBkZGnSfzkYdMyM8eIuKE+ZDPyZv6oWevE34kt+YA=
X-Gm-Gg: ATEYQzzdK5ulR4BVuIJpnWhN8eYiA1qW1MdLwkdPxP1gHqbHViWRbtKsJ37UdJRHfnQ
	MUA5yNdZVz/FaiQA/TYv9FyVtsH+DvwVZE6FN0pl0waeUUDqBXbGdawTQE6Pp2/PRKPDAI1XLDM
	ulpghqdZNX1UZfv1M2PIpw2AsuGA2yVAo/lLoNXzEg2rZdRLfUK+r8Qwkf1yjE1tic33dVibGLX
	3hlXFtIOOUa9gk3dQECYTFrID4mYUGvMhah8llQ4j85x9e2KWoWijbxpGvq65wU4WBXCDcDRVCl
	JWbeChrBAAjLdJUNslofpPWVPlNGV6IEGSzQ6ngZmUe7y5knnw83JsdsNEDjostcYOcFbw69q9J
	IiOqAFuzRSezogH9gOiq1Yyfej3utm6QYNuYDA2Y8D0z+ALmm7Yu97fYqSO+ty5qcfymsUEK5zO
	yaLgHWUR1x
X-Received: by 2002:a05:6808:1308:b0:462:d09a:cdca with SMTP id 5614622812f47-466d865e866mr326534b6e.32.1772735705745;
        Thu, 05 Mar 2026 10:35:05 -0800 (PST)
Received: from 20HS2G4.. ([2a09:bac1:76c0:540::3ce:23])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-464bb59b66fsm13913851b6e.10.2026.03.05.10.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2026 10:35:05 -0800 (PST)
From: Chris J Arges <carges@cloudflare.com>
To: willy@infradead.org,
	akpm@linux-foundation.org,
	william.kucharski@oracle.com
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@cloudflare.com,
	Chris J Arges <carges@cloudflare.com>
Subject: [PATCH RFC 1/1] mm/filemap: handle large folio split race in page cache lookups
Date: Thu,  5 Mar 2026 12:34:33 -0600
Message-ID: <20260305183438.1062312-2-carges@cloudflare.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260305183438.1062312-1-carges@cloudflare.com>
References: <20260305183438.1062312-1-carges@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CBB822000B
X-Stat-Signature: y6aaawcomxnq57a6yz4sh7dctjjw8nbh
X-Rspam-User: 
X-HE-Tag: 1772735706-454237
X-HE-Meta: U2FsdGVkX1+oiZy0kIcDBe+mVYDpzYs3Hdb8WklahL9aVHO+76pUzI/ShOZ2B7NF6BwcCSihGKRPBzDS5m+7NXPyabc4vmRHrDfvzRm6GCNq71ehMgUdyc39WZq+Q9DBbWKU605qszIh82H6oFd6UAKoe3ibk1UomqnU2sTOMLQwMZFa6kDqJu9TEnZOlLOnRJwN9e0zB9hZlheRiSTdQz8Tb2yosI2AmdLDlybL+mmvcl00lvTKBGUSPHZwMMdOMit0M4rIxQ80mukOL1X0qlvvT1Kv1IO+picnPxzMM1rwOgMJLa8NbiPBT3Lh7vrD+Ubeo62xYA2DY4F9UkaMeZ1U5rQ2s0YlLSEKcxs9wLJ6LkENeqjNrm7k+Uq7WBYxMnNsrfSrpVX6+RTi36PVEOMj8tIhG2lOVDkKFAzA9CjL9NiGNQpSLGnytbz8R5bAQbAO7hS4ZhLhXUIa/KfI9P/9cys0W0XPmd603m1EEH3pm4tXrjB9ColSnlP8U26HnIjibGMpcBirL/89oWuB24EYWr3kmv4aA8q7Q5LMZwb07OgIBz1CESmbn9fXdu7+Wk/Ub+43Aifnf4fg5mVculkk10tF7aw0oZWqfj9caR8veniAMWw2ZzMLCq1tYtGScjAR2Yc7+3Ci+K3GbxngqZ7zrPX/yYcz86i34ZWxj31VRHWh7xf+yLP6bk46Xy/Vxp16n6ivCWTdIRXcEihHguBnPa6O8oDDKwCBYDeHk3dZMS5FveeHIo7rr7/T4CTf/YUNa1BXUbrQlxa+vIxs/ZBf5xahGfOHtjv1Llz4LWgtTEC0egtu4RCJN3VxOZY7mISN9e1L7TRiEuMlCQjbU5PMYOtmGhQpyuCZBsKnIHJR27qN9NQEE48g2NlLGkrWuIqRaVydpXODDpiOb7SkbsYMvYiJ+CpJIEBZ0Lw+mBX8ySYfGT5hfUi/AsHeVBeXwh59eqxsOqDva9KmRFk
 JhseieMj
 KeGLv55JTr9bpIbIRlRIPoLsqroxsVOXwPsHN1NVg9MbcgI4mqeQ4mUY1FkrZ7RH8dpZDy0S5M84qTErOL+rZqSz+wMFQQY6GDwjvEseYHgs2ZiyE6+5xRhMuYjL146Ecuua/wkLcd3RBriasHYiKGflae+fB5wcNtJQbaYc4+eZw4+Mzk1NWeIBXG5gqHaygJXMtsZpxTbomJ4Dy3sVW3ALqETC3eu1W/qTFOqhGLnNcLqqZOytx9fJh/7uCLO0v4Kyj9acg8mUTDiVS/yM7Zd7V949Ty0L01D/2HJ0JlCSaPYO7pfeHU4PVc9sWSr8QpQy+0kcFHQfWQCA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We have been hitting VM_BUG_ON_FOLIO(!folio_contains(folio, index)) in
production environments. These machines are using XFS with large folio
support enabled and are under high memory pressure.

From reading the code it seems plausible that folio splits due to memory
reclaim are racing with filemap_fault() serving mmap page faults.

The existing code checks for truncation (folio->mapping != mapping) and
retries, but there does not appear to be equivalent handling for the
split case. The result is:

  kernel BUG at mm/filemap.c:3519!
  VM_BUG_ON_FOLIO(!folio_contains(folio, index), folio)

This RFC patch extends the existing truncation retry checks to also
cover the case where the folio no longer contains the target index.

Fixes: e292e6d644ce ("filemap: Convert filemap_fault to folio")
Signed-off-by: Chris J Arges <carges@cloudflare.com>
---
 mm/filemap.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 6cd7974d4ada..334d3f700beb 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1954,13 +1954,13 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 			folio_lock(folio);
 		}

-		/* Has the page been truncated? */
-		if (unlikely(folio->mapping != mapping)) {
+		/* Has the page been truncated or split? */
+		if (unlikely(folio->mapping != mapping) ||
+		    unlikely(!folio_contains(folio, index))) {
 			folio_unlock(folio);
 			folio_put(folio);
 			goto repeat;
 		}
-		VM_BUG_ON_FOLIO(!folio_contains(folio, index), folio);
 	}

 	if (fgp_flags & FGP_ACCESSED)
@@ -2179,10 +2179,9 @@ unsigned find_lock_entries(struct address_space *mapping, pgoff_t *start,
 			if (!folio_trylock(folio))
 				goto put;
 			if (folio->mapping != mapping ||
-			    folio_test_writeback(folio))
+			    folio_test_writeback(folio) ||
+			    !folio_contains(folio, xas.xa_index))
 				goto unlock;
-			VM_BUG_ON_FOLIO(!folio_contains(folio, xas.xa_index),
-					folio);
 		} else {
 			nr = 1 << xas_get_order(&xas);
 			base = xas.xa_index & ~(nr - 1);
@@ -3570,13 +3569,13 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 	if (!lock_folio_maybe_drop_mmap(vmf, folio, &fpin))
 		goto out_retry;

-	/* Did it get truncated? */
-	if (unlikely(folio->mapping != mapping)) {
+	/* Did it get truncated or split? */
+	if (unlikely(folio->mapping != mapping) ||
+	    unlikely(!folio_contains(folio, index))) {
 		folio_unlock(folio);
 		folio_put(folio);
 		goto retry_find;
 	}
-	VM_BUG_ON_FOLIO(!folio_contains(folio, index), folio);

 	/*
 	 * We have a locked folio in the page cache, now we need to check
--
2.43.0


