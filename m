Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6C01606A327
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=DYBNTCju
Received: by kanga.kvack.org (Postfix)
	id 72F686B05B5; Mon,  2 Nov 2026 06:30:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E5B76B05B6; Mon,  2 Nov 2026 06:30:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CF766B05BB; Mon,  2 Nov 2026 06:30:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A15A6B05B5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:30:38 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BA43A1C4582
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:30:37 +0000 (UTC)
X-FDA: 85389961314.07.C26A4BC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id BFF674000D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:30:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DYBNTCju;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793619035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CRcAAdDtxfvhiN3FxCxHzMeH/u99dXfU5Bg9p97f0JM=;
	b=joJOsoMppuVd39DJcxJTmw45O6pb805RNu9nHQ4lQHtZHUhl7wBGyU2MnosYtePPIcNSL3
	qZReWN2z8vGA+2luWaHMFwyP8Fp2O6lIVMsiZrW8FMM42B+mKBvsiOqM1dt/g8j6F2fIBF
	DWOmAyVkGBoks2ROOYtuqeXUuzamxOA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DYBNTCju;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793619035;
	b=pIyBYp6ssJXxf0jc6vIf8n0Gj+dFkcG0G2yXjakfn8WpYfrryXw7Aa/bD/BrtmAt38NEKB
	VMgyF4AHShMZdYO7tg5mmc7wYz0y9hJd0HtA6wAIo4EQOK/TW0+w4/Bh0YXi1KBr3HNYXB
	0v3f+ln27qQX52zGsoBb5+lAqn9uRX0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E16FE2972;
	Mon,  2 Nov 2026 03:30:31 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1D4843F632;
	Mon,  2 Nov 2026 03:30:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793619035; bh=Sw+xggMs2qE0Q6AJwqQnNIkUKXTOb9DvrrWvEhrdg/I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=DYBNTCju9KLhx1Uf/2ZV5xUHD+k1ZPTzfbxwIwkW7VQtiqAg06kct9byIWCXPX/zP
	 irVmO02l4jmV/UCHRnBdVzSRopuPLkBalvbB/8o5DoItmdypE6a5XCoTr6heaMOV0p
	 f/0Vevi3K3Yzx+BRu6qLUEeEdW+AADSsfNrseamg=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 02 Nov 2026 11:30:18 +0000
Subject: [PATCH v2 3/4] mm: internal: introduce FPB_LOCKLESS for
 folio_pte_batch_flags()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-refactor_gup_fast-v2-3-bc1ac018c834@arm.com>
References: <20261102-refactor_gup_fast-v2-0-bc1ac018c834@arm.com>
In-Reply-To: <20261102-refactor_gup_fast-v2-0-bc1ac018c834@arm.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, 
 Yuan-Hao Hsu <aa9736195201@gmail.com>, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1419; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=tCihATTsHWbMkStcGZ7Q1Wj7uPA2CiSswJU8uh6IE6Y=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq6HRRGiU+bxM1kUrCOK4b+2Rhrv/oW+j2tstlw
 vHVl1HQtb6JAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCauh0UQAKCRBt1cPRWsUx
 M+bwC/4rm0ElvL6bKsVkVUMYXx6f3uAp09TvKf+K6oGFbEltPNTtW0dg2vxE127w9A5FfcIlEig
 PJpr0EiOPCu3JetCvvRkN9oq4lzLCEstecmu1Xrl9pFEPrhSdAWROkSDqPfUPv3Pm/0SDnaLPX6
 YbU9U1E7JZFP58ZbhNydGH9HFdlPP85+qPsU2+L4ioqAQ4y+abD+iDw1HUYVyK29HVk5V3RIPDv
 X1fK+VT7/CGbo1nSYiD0yt5gZiHzNa8YVGmHvjjtIM4UhtfJ0MvE8fpXi9kWCiV2YSeqfb1NDVH
 s0epsr7lA6B3XKNyVuVyRMWs34VBawfnGKSCWD/Un86RBINVkm7T7piCrSSqARElA6g793woOov
 rMZsgJq8VbV1wSu7wuCLdva0SL5VTvM9qULnblVSviCJcoL9YUotebsu0E87xa7OhK25rb0GJFX
 mEnwT+uxVS36J3EXTUBnmfkq7ChpBsnIVHFweSr2mYi15I69X61aYnfTyztbnlCCIrmvw=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Queue-Id: BFF674000D
X-Stat-Signature: i817r8q3zshisiaax5d7ehz87irkza46
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793619035-316497
X-HE-Meta: U2FsdGVkX185RGEIwj+gigRoBz4Wy0C0ztRHCMpFrpboKMq3MlUozOH5SCWMt26mmSHqrCyO5+/RUgED3fye1CnQ9oeMVhk9lyIinSsSspVcZN270H9MPWtCpfJUsAMivWza3sGPu7wzmhd1E4UM2Jq+jZGjRrFgRVm7KYdGvJbFHX9VIvDOvcmN+O1wlE8Zhf3qduyX5B1QC0ksh4Wjm46NcyFMhmUuP4M2gI6uI/buafAkw+aX/nlQ0GQ/Y1sr4I0C6hzqZ2t2bDhj9+FQJGlxLDySRKc+D85whNSM2dwj/WQoDKvxRIBQ0wH1lFCb0T3DqqQiUKyqw26Tkgiiqn6RNljtoJ4LfIGwaPnB+wo6xO5I4Juoz2e7KUBokuo8wkn0sAsVI0x4jd0XsluELDec/EfpyKWpr3B2M1taY4b/rDYVSomMzaEAvgtoRvrt+gmsRBNDoFRqbBhnzZhq2JZh2UEDhVd2jZO2mFlFqYcldp9qkF97s3I6epCOll6dAuoSD33K7sXVFvZmWl5rPPoRMy0Dbjg0I0JK385Q5IDMdVw9qg2LeYXTASwEo9OiSV7F57MFTBBpBPujLaWkizwxKzwopmTPgNxRXtpgB09cSS+HWlO4KujFJWmT9jc2bFBgX5Qw/r6KDlTxExTrWzb2j7dusyE/NH23xWSJGU94JxEUpJCZLdCmtu94ll8F9pFg468o9TFWIzq8OP6cIl4xzpJk7Eiu+C0i4/mQlAoO9LlHTSfUFS3WfcX3tDmUnEDXMujZOZ/IusJi0Jded8G+2qebbmC3WaEr4jwG2fwh7qTls9hje+FXphV7myCoYGc5kpBA6i/DEXtJ5YlaWleIzjYZKP9prfDdgVpGSfgkZh+ITAjcFXCE5GLM0twaAs03BOHZwOTDYne5uDU1Qu5o9H7Aj5g7qaWa+GKf+iEsQZ7X9QR+HzSWn//cMOCpiD2z6b3Fedln6QNbc25
 sQKkBJ1o
 BGvnov/ES9jPDxDvJQqJlEbZdQGxNjtybK/JOfJ6rRyuPUTgjJiSvqlfNWvtxoRgpTgQ13fG1WkrXYyPW9v8hR90qyENcqekNe4yV+kCDPQJgSre3z02LBYGSjiYHKAHNkl6SL18SWLuXyLg4/AYvkdptYvKyTSruWOFZ3tP/H8htudMUM7gNvP0qnPx0hKm9UzLk8PUfw+IjzT3ipx4kZ4nctO/3VfO9H471EWM1lwIBcb0FCshPCF1/h99ye77zMwhp0QRBqAzFmVIq2hNa7y0b2OG96g8GjkhhfxE3n3PwuAb9QrUl0aHlkH9kqtmNwE4nxwJAUKZkIKw=
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

Signed-off-by: Yuan-Hao Hsu <aa9736195201@gmail.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 mm/internal.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/internal.h b/mm/internal.h
index b4d0df4c35adf..c1824b0193f4d 100644
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
@@ -442,7 +448,7 @@ static inline unsigned int folio_pte_batch_flags(struct folio *folio,
 	ptep = ptep + nr;
 
 	while (nr < max_nr) {
-		pte = ptep_get(ptep);
+		pte = (flags & FPB_LOCKLESS) ? ptep_get_lockless(ptep) : ptep_get(ptep);
 
 		if (!pte_same(__pte_batch_clear_ignored(pte, flags), expected_pte))
 			break;

-- 
2.43.0


