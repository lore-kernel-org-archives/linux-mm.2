Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CF93606A326
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Xzvi+fwj
Received: by kanga.kvack.org (Postfix)
	id 86A5E6B05D2; Mon,  9 Nov 2026 07:32:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 842476B05D3; Mon,  9 Nov 2026 07:32:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7314B6B05D4; Mon,  9 Nov 2026 07:32:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 417216B05D2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:32:46 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B969E1C3FF4
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:32:45 +0000 (UTC)
X-FDA: 85415519490.20.AA67989
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id B797014000E
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:32:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Xzvi+fwj;
	spf=pass (imf09.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794227564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eYR4omfoaDYRoyPO00ZjD9zOhe+EFLjS6UyKBeubBuo=;
	b=18SdzCRfOM+7QC9WrAk1tvlS+HSfrGT8Xu0jhR39HFNgqJ8gcWrrw1chCKQLugD2HpolO6
	2XgAw5Thawbo0ftxafZIR4h+H3TJvr50gLYX72JqpgaI0tcEc7fu58W1rRcr40V1Y9BVNd
	L6akwrMbnSyaofIfd6WbDfPSsEkEmmM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794227564;
	b=Rmg5nqaAXMQu9cMc6CAleM0jhmtL+GhhebiY64PrMh/rjitqfyHntCUv1N4XYtaJ1D2xpy
	N1bbUMOObGs/2iLwH3J1367B7pzXq4E0t/o3CfRenyUCa+ASWhUFE6B0W+EFfBKhEiBtIK
	Waz68M/iet1+7lwyGMh03OQmLs9dBr4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Xzvi+fwj;
	spf=pass (imf09.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AE6E8176B;
	Mon,  9 Nov 2026 04:32:39 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D40953F632;
	Mon,  9 Nov 2026 04:32:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794227562; bh=rpIgaFxGIS2OpZ/04dxOWCg4oswFTkrUNhImFASv33Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Xzvi+fwj6Ql49JH8ZAMSY54p6KtYX+j2cPFBile8oHOKD4sCIH9V/E3uBcGrr+dTk
	 l209JS0K3ERTgIEiYqeSBxDm2jr/EPqODT4xfCLQhIZsAFNYNJv1Gbf1J2iEzyktal
	 zPGgU8vJ8QCod1tPHSIl5OhM3hAMhkllxZQx4Lxs=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 09 Nov 2026 12:32:28 +0000
Subject: [PATCH v3 4/6] mm: internal: introduce FPB_LOCKLESS for
 folio_pte_batch_flags()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-refactor_gup_fast-v3-4-2aaef02df0e1@arm.com>
References: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
In-Reply-To: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, 
 Yuan-Hao Hsu <aa9736195201@gmail.com>, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1473; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=zUmOfeEtgCPPDBn9D5DQwJr7Mb3p5wBZZ/qksfsLDvg=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq8b1e0Vdbvp6DE910kKDUB/xYIbOq8i0PvfXSC
 EdlGbTA7vyJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCavG9XgAKCRBt1cPRWsUx
 M8KMC/0V4hpszVTAKsMwHN5yZ2t8icMnLuux/itj5pY5wypcIDiWCYEScPNz6F/SftTDZVnQiCJ
 cvB9FKKKREPcPPA2op+iOEIhbg4aq58Sq3NsUdYmXlWlmq1YkmwQQuSn53uxaHAp4qwv5fLbbj9
 2Orno381MLcYrim1wBhFqPAL5OpGMOJbc1xexYtBh9A3sPoyxpA7eXA98uuL8qznqOc8OK7AcCQ
 zX96mMHRlKQ+u3GqC8fBcdmocishYmnjbQakeiOvihTqKHUrNmNusr/B/JOuyUUNb8X6hsjTjrk
 E62mTcpRIoAZdH+UxoW0h4g+S2rJRkIeXDKtNsV3GZdQGi2P2qFRBIh03RfnA0uia8GV8PDCFW/
 ENKZf9bU0ZOs/cB0unfLtd86EhRMNczcTIcAV0HtKRH/5gM07R7zXDyB8VVhxoS/PQ+qwQaOSj3
 PeqTa6ZrBp0Mx/DxmlJmT2n7K27gj3nVYm2NZp9bJFvv4BRhRtoCZRHAOiKeD0KELB+70=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B797014000E
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: zx3yjuzxjhsfiu6e1xs3g584r6uj9qoy
X-Rspam-User: 
X-HE-Tag: 1794227563-819498
X-HE-Meta: U2FsdGVkX1/+kRmd13iFlD/LAe6YaJuaOVesr6upeVH1tijKLOoU069cxGCPfWPIN6D2IHfwyygO2r77B6Wx7UAsOXCoe5pq07iHZSkXzX792zxqN9/wQeeIF/GHsG15G1jf7LhWWIheGw/jmMPdYE3B9PA8CssACkAPO2jB+SqEl/4+ZrpDwf/Oy3jdcoZFmuYT8DABwA3GByyZGtgJJBitivD+PYQvT6L0DYgaEqxQs8PvwX1P7xoQZR9vYbL1ZKOROorTSzhTLfEPwVGsub5yY2R+GvPcGuX7tTTSTZDGdRNcPJcTnYwkwbJk6be26sTgrRN0XMB9Z3p+NrReCnlvPrH6Dl8oCk0d7XELbxdJk+vOxPlO78xqoVPW+OkcwouHwMJo+YS+ZPuokxQZIyjQ48sAVihAV8i749jVpke9GmBXA9AP3qAXGuxjH6C9mUwgcGfAebWFneOGrxGF7eV6mxakm9xsDYP0DNgAd2T5bLmUfvlDzU34YsM4s60zcNGqO8gBCcPnrzcslINQKlKrBSJqf7JmM+1D0Owr1j+4fxRjEdQrnwgCZrFRRXREQTvEqmTyS7U5bDWDNV1OUHrOuzbVVd+A3oK+x2sRTc4DwOalLcH7I0r2AW1lcSUn9r78HudF3w2mI03mZTuzpIpyMHbnLly3MCM0qqK1GG0ZDrE21Sv9IVeMV2KFJe6FwTdb3PG4wu5A7dxJGRryfnzD4niKADjA1g6u7cWHwKkSkF/Qm8ayjw2Nc6pI1qrSR1Lfwu6RcbjjTRvIrjk2NXSgwiGLfUTlmH2rcsEwWHEh/NQNY6rnZ7CvDvH1oAVpsDS/7/bVTUVbtqd3RiW1GKKF/c5TSLl5KkEwxeV+fcNncFk8gXDj/WvGwaGrHj/F7AG8KM+kLkMRR15RCK5rHIsNYsQm1ctM3Bv/v29pLmGDK3/P3XDC6krYgnbTU73Z2nuRG03u9xvrbhq64P9
 lDg4jG7O
 rp54XYZhrwJ4t1IUrWfwwIFtmx9sY9S2kL9kwbxVrhfYbN0zY9jGHZ/1ZYyKDz74RNcDNso56KrrTrG6/AQQF0pIDwY1kKCrismqn2R0HYt6puO+6bUsu7ewuVl4AwAv9HIFpqUZlO0MzFLd5kWxlHUSHNq5ZQO8ybsK7+LOAjWMrZ8mNTKPHqUlhdYf9rE7scHH5pzlpn3Qepgzc9dPKw11sYJG71m03Sepp36QffMfR47HTHYbPbuH/nHm9Ri+JUC4kSjOiOjEIPD83ilefmuZYKsRxfkXPmtmo8xBkbjZkZcU/W+d6aaRGeAf2eVejXn33bX1VDoE11eGV6PE72+qNiUCwQVSbv6iC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Yuan-Hao Hsu <aa9736195201@gmail.com>

Add support for calling folio_pte_batch_flags() in GUP-fast context when we are
not holding the PT lock. Instead of reading PTEs through ptep_get(), we have to
use ptep_get_lockless().

Specify the new behavior through a new flag FPB_LOCKLESS. We'll make use of this
functionality for batching PTEs in gup_fast_pte_range() next.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Yuan-Hao Hsu <aa9736195201@gmail.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 mm/internal.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/internal.h b/mm/internal.h
index 7a315c0a93f49..e4992ca0dbd6a 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -373,6 +373,12 @@ typedef int __bitwise fpb_t;
  */
 #define FPB_MERGE_YOUNG_DIRTY		((__force fpb_t)BIT(4))
 
+/*
+ * Read the page table entries with ptep_get_lockless(): the caller does not
+ * hold the page table lock (e.g, GUP-fast).
+ */
+#define FPB_LOCKLESS			((__force fpb_t)BIT(5))
+
 static inline pte_t __pte_batch_clear_ignored(pte_t pte, fpb_t flags)
 {
 	if (!(flags & FPB_RESPECT_DIRTY))
@@ -441,7 +447,7 @@ static inline unsigned int folio_pte_batch_flags(struct folio *folio,
 	ptep = ptep + nr;
 
 	while (nr < max_nr) {
-		pte = ptep_get(ptep);
+		pte = (flags & FPB_LOCKLESS) ? ptep_get_lockless(ptep) : ptep_get(ptep);
 
 		if (!pte_same(__pte_batch_clear_ignored(pte, flags), expected_pte))
 			break;

-- 
2.43.0


