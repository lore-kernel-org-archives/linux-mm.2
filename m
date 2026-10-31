Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E71EF606A320
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 10:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=icloud.com header.i=@icloud.com header.a=rsa-sha256 header.s=1a1hai header.b=UHL8n9Pi
Received: by kanga.kvack.org (Postfix)
	id 1497C6B05B8; Sat, 31 Oct 2026 06:35:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 120F76B05B9; Sat, 31 Oct 2026 06:35:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 036DD6B05BA; Sat, 31 Oct 2026 06:35:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C6C286B05B8
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 06:35:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6328BA091C
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 10:35:52 +0000 (UTC)
X-FDA: 85382565744.15.E64AFEE
Received: from outbound.st.icloud.com (st-2005b-snip4-11.eps.apple.com [57.103.79.23])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6197D100002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 10:35:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=UHL8n9Pi;
	spf=pass (imf14.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.79.23 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793442950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3wvj0yteebUhNouzV0u1oXFuQXUQTsJ5ZBVwO6rlosI=;
	b=KPdOtAUffhVbb2ZbR0Tv4M6taZrl2JdtNrxN37vtLU4fvoEolir6peyrLvYxMoqKn+9V+7
	6bpiLv67jm4cMYDQ2ZE44z7H4qxRUSLWnEOh9myb0puCk634/MhJ4xkRcD8AzjGftjbx11
	BJpXBr3DdB0rdwAKV7dH1hdVOxu/fO8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=UHL8n9Pi;
	spf=pass (imf14.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.79.23 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793442950;
	b=rIe2fiZ9j+QHNp03JMdADKnEvdfrRgf/EDNGvf/Wxx+wpEiXbq71fj5mXUE5/Tk9v22Hmp
	2II/l0zgI6py8GjPVjVlber2JhAI/mcVJYehO/EwRlunz7I8/o42SOPe9vczB6rUuZshwi
	7fiV5NsddvkVahVEup7NXK9pZmYNPjk=
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-7 (Postfix) with ESMTPS id 97CF01800162;
	Sat, 31 Oct 2026 10:35:46 +0000 (UTC)
X-ICL-RepId: 01a19187-9dd9-71bc-8209-cc9cb851003e
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQtJCkMGXwFeCEADQwZbC1BcHA4XXhtCFUsVXANcDkswUBtfAkIPHBNWFRMLU1ZbE1UXRgkZCF0dGQpQUAZcEhhcFFxQWB5GElYNXQkZGEZeUBtfAkIPHBNWFRMdQxkPKwhKBEMHRQJeCyUTCVNWWxNVF0YJGQhdHRkVWgkKVwBAC04CXQRaHxJYDFAFGh9eEhQeXxhEAx8GD1UHQAZSAkUKQQteDg5XE3kMVgNUDlwEFxtcAAlLRglJHQ4EVAddBV0=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1793442949; x=1824978949; bh=3wvj0yteebUhNouzV0u1oXFuQXUQTsJ5ZBVwO6rlosI=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=UHL8n9PiBuFiHXs+F6S3QPKrJqgxSJAVKm+6lf5kujeTrBK/V3Jz2ZkGRII/zoVExP7yRw+yoTH7ZCD9OsdF+hfI1b+Emv1zN94m5r5g+IWaNZQwtPbMWg7ChWFpj0HlA3cxzuGlkMSBfJgf6Oy+nEU1HaC2hkiMl0CgDnzIgt0z0yVociRpTdlv3bNf3wCvpXLXb2rPFWgTfI8AT40YQBVZfBUXh+I47Yk1e0ITjjRDxMjx8JTQGWN7yAPUauC2kzpD3jB6INR9/sUbnbxdSuGy0vVDffKVcmc+v4RduN1B6xB26FfUMVQt+SQGmyeE0ZjywVo9WgCp8NnKjhcUZA==
Received: from [192.168.5.15] (unknown [17.156.216.30])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-7 (Postfix) with ESMTPSA id 8931818002A4;
	Sat, 31 Oct 2026 10:35:39 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Date: Sat, 31 Oct 2026 18:35:11 +0800
Subject: [PATCH v6 4/5] mm/vmscan: extract folio unmap logic into
 folio_try_unmap()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-batch-tlb-flush-v6-4-190539839eec@tencent.com>
References: <20261031-batch-tlb-flush-v6-0-190539839eec@tencent.com>
In-Reply-To: <20261031-batch-tlb-flush-v6-0-190539839eec@tencent.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zhang Peng <bruzzhang@tencent.com>
X-Mailer: b4 0.14.3
X-Authority-Info-Out: v=2.4 cv=IYqKmGqa c=1 sm=1 tr=0 ts=6ae5c484
 cx=c_apl:c_pps:t_out a=oyWFxbOnq+dmhQrAPgaJYA==:117
 a=oyWFxbOnq+dmhQrAPgaJYA==:17 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=VwQbUJbxAAAA:8 a=TAw1jgvpd6mOHMWS3hAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMxMDA0MiBTYWx0ZWRfXwKIQMpiFCVuQ
 M7lCuOYrwdg8vuDNQpQWEGCWqndiAn1pSpeOJ/fQs611CdA9dHlUAhawXbulPJ+mjT1K7uv1XKh
 KArPxcB7mRytPdlbtgjUK+VIIhPQYiMnQpHioVxJeOSrCM1j/0slXX52gNxE6SXaAgP0EaEhult
 CeB7Rvg6P7eTC/SO5ThLJqLhCSiP7YNOQnveyP67/t+D9ODdwt3vSRJkqD0btRdY0Gspx69xU+7
 59MGX8eKWUn6KoE8iIHWoTWkRcMMJHWz0Fm95ShlVkvUX9px5jrIkJKnZsy6Q76VIU0WzItUjoO
 fnyGfIWx6PUK9c1DixOViKpQ3gR1jWp7VgYIWhC1kxSoosKXC2erOXdlgHHelQ=
X-Proofpoint-GUID: EXQZDjnrhNSrllZK3KzfNYimNc6jZuoJ
X-Proofpoint-ORIG-GUID: EXQZDjnrhNSrllZK3KzfNYimNc6jZuoJ
X-JNJ: AAAAAAABbjoSBQGhxSG3QjLu8H6BM+qzsziPc4u861tewazawSpDoHwz/Oa1LthFuXc/S0
 avTB5AwIlFzE4uMFYrRMzMeXojhAc2yTzgFv+2gxaNhHWmfcKRjVoVnL2E2k3VmZLI6u6V
 4kcoVMgoOw5CkjSeDywUmQnooF/MST7I45yxIkrHyXj+oQr+PbiCgx7UoglLNBQ+4qhUrU
 ZpDF5nXCMWP4GHfHPmF0++uLCFMO9b5BCkptRiZkIPXeLfAQoLFwMZOpBBKQZ/5dyYMSwY
 VfKj9/DEyR0V92RudLak0uB07ecOJT3opsG+KDw/Q2erVpLqaAJ4IyCLaNBgBF3WFOxuzv
 7jVvCbbuBPZQ40wFV+V1aYtWp8JMyEvRrr6caHyJ96lney71OgYlB8mL18uHLph1hQmRyS
 miNkPPe4Y684hdHlMguWn4KVMkSLqoAUhuS7JJotYD2pt9ulLt/sr6z24+5jR8dJW/saHq
 cBwNtsWxiiom1uAdrmCooAu9pRadiDSICIoJPXBwOY1nANkvaUje2/6CfuX+v6Kf4Fn+f6
 CVz1VLaclY4sx4UnVrNtw+nrb2xuABZFYu3TFNXW7SJL/xbzEdueqfirwPEmcROR1bea/i
 IUJPZVMOSUmYkTGqQBduW9efoYyFIgbXjOVDS9pk4X3qmR4YlkClrQWn6J1WnGLrtMk8f+
 Zxxbo+w1pSd0ymnK0Ia7q1nBb/3RCaDnZeLtJi7Z9eRrgf2qEMXnqoDs4hbBWXraPa6KGp
 BZVUgWTmRv39X7VbFU3Xqruvn25ptXUkoz4ic8vYlw7OSmmEHUY1uMOYNijyOOB4KVPyV7
 DF5SVfvMIcXUR91EfvWTtgQ71NaErQTkns22HDwOwnn5Ul64n2AANXF88uPx8Gs7zyfmd9
 8lyjr/FQpGAhzpLLTdQQAesPlyo1pEwwo=
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6197D100002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: fsr3ewsm4n4ny5t9c17z4ti8t1ncxekk
X-HE-Tag: 1793442950-736941
X-HE-Meta: U2FsdGVkX1+DWFXsv0OYTDYJFQjL98enGPXMbbm1lRCgF5TsJm28Ccqouuq/F00lSL6pPKEIvIuGw/fyi3uQuKHMe7x8w4nUN+LPtoj+7oluPnuwrufpnn70noROQMvCz2yZxjJxRPYlKWLM+NCzjevXz+qXYIjuSSv82su7/NALZkr85QjFfPF/eevNr5zu2R9+4HsJB1NoB9CpxddzMjoX58/ntgFkhrh0G0dt+LOCqVsy0/4a0Ddcd1ADse2yPw+GlBvc2MuelP1TjjKb70EtDyBIFB8kEjkSEqSi+/yFbTkceUWf/EvqsYGoEpRk8srf9uxHnf/HGxuhcZkXPxhMJKBt7ZLZYoSn6JX931YF79CTCPR/b3hNXJvkI4OIrG4zcQfFjxagfuC+dfhV107Co/4cmuENdId/0LWpvg3/8kasgn/Eehbi6eN9RewRVrZdkudFyPn2K2HFFOFRirOX72NHnFgEAj5twp+gtWN7zh6UentvgBnmIZwIWeHGwDIUwcAzYguym+z/YlZPihk9+aYuv+kLl6K39Ljm3TbcmL6cHg6Vnf48o/CP90+KFXscOCPYO7Uu4+Xq5wjvHqFkzUlV20rx3KmbM7+0g8tTaR05K/78pJ3qp+gXjayXX0E/LOe4sCTj2AGeDgRcNrYYioloCkOBwMPC3hW3BPSv/jcBPXSgZA0I9u3xBJCmlXJKFR4oh+w7iY+GKXp8912o6mBA9u97VrcR8n4G2zbV6qehv8qo6XO16t7u9yhBbhItVUgIJ5GanGX+ckcmsEyGSbDDHM/grqK01+t7DF+c98iYXTmhqLiRQgl7sZ15gIB/RSc/YFl5dH8yCUpUc8B2WTdo1geyKAPeN/pJjzwR2cNDb2cTWFcXBNO4KVaWHVgsv7WuZoROD1OzhaDABMgioFKxLMxDLIDKKfIXmN8OUZVnVE2fUSkMgQWuC/mEd/os6Xvdw9RDy3uFXWm
 yPgpcO/B
 oIPf1NnVhcJRlMaYeTgfoRBTKsKZCr6eyrONddueTv9/cENPuPW+g2uUot8ldWF5056+7HEzt4XoOVkWtvPZXBEshxO3F7yeMfpQ/Kgs9NNSTCe4NCuOF1ZAyQG1+F2zXzh6SzmuQp0CQFYrQHQ5QngCKHvO970WS7yZvL1LTD5JUL8BvKYPBnzTaEEBFXVdosyodtH0HxR+ksk15LANwQA5XYH7jm/oLbQgaCJfMupyOaeqWBsgrziOqecqXKYjPRC4mQsKWtHw1Bm2Pfso5a9CKZnPVVd/vUcw9JnhZYXR2a1u99hLNzDgthe2GKGbQmuzlwINfK2o+ii9N+baeOgIWU7EJ8eeAiZhvssm3CuP5MlLb7g9/sCf6uv4+eP9GJmTsRqMU7yHXU3tNl3+zewzUD0vTmTFlwp69sdfYLnxywg2aC7jPgcCcMJgz4qYHnzr0pIzjSlOrjlw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Zhang Peng <bruzzhang@tencent.com>

shrink_folio_list() contains a self-contained block that sets up
TTU flags and calls try_to_unmap(), accounting for failures via
reclaim_stat. Extract it into folio_try_unmap() to reduce the size
of shrink_folio_list() and make the unmap step independently readable.

folio_try_unmap() is only called when the folio is actually mapped;
the !folio_mapped() check stays in the caller, keeping the function's
semantics clear: it tries to unmap a mapped folio and returns whether
the unmap succeeded.

No functional change.

Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
---
 mm/vmscan.c | 65 +++++++++++++++++++++++++++++++++----------------------------
 1 file changed, 35 insertions(+), 30 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 36e3f0829f08..061414ff45bb 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1334,6 +1334,38 @@ static enum folio_pageout_result folio_try_pageout(struct folio *folio,
 	unreachable();
 }
 
+static bool folio_try_unmap(struct folio *folio, struct reclaim_stat *stat,
+		unsigned int nr_pages)
+{
+	enum ttu_flags flags = TTU_BATCH_FLUSH;
+	const bool was_swapbacked = folio_test_swapbacked(folio);
+
+	if (folio_test_pmd_mappable(folio))
+		flags |= TTU_SPLIT_HUGE_PMD;
+	/*
+	 * Without TTU_SYNC, try_to_unmap will only begin to hold PTL
+	 * from the first present PTE within a large folio. Some
+	 * initial PTEs might be skipped due to races with parallel
+	 * PTE writes in which PTEs can be cleared temporarily before
+	 * being written new present values. This will lead to a large
+	 * folio is still mapped while some subpages have been
+	 * partially unmapped after try_to_unmap; TTU_SYNC helps
+	 * try_to_unmap acquire PTL from the first PTE, eliminating the
+	 * influence of temporary PTE values.
+	 */
+	if (folio_test_large(folio))
+		flags |= TTU_SYNC;
+
+	try_to_unmap(folio, flags);
+	if (folio_mapped(folio)) {
+		stat->nr_unmap_fail += nr_pages;
+		if (!was_swapbacked && folio_test_swapbacked(folio))
+			stat->nr_lazyfree_fail += nr_pages;
+		return false;
+	}
+	return true;
+}
+
 /*
  * Reclaimed folios are counted in the return value.
  */
@@ -1612,36 +1644,9 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		 * The folio is mapped into the page tables of one or more
 		 * processes. Try to unmap it here.
 		 */
-		if (folio_mapped(folio)) {
-			enum ttu_flags flags = TTU_BATCH_FLUSH;
-			bool was_swapbacked = folio_test_swapbacked(folio);
-
-			if (folio_test_pmd_mappable(folio))
-				flags |= TTU_SPLIT_HUGE_PMD;
-			/*
-			 * Without TTU_SYNC, try_to_unmap will only begin to
-			 * hold PTL from the first present PTE within a large
-			 * folio. Some initial PTEs might be skipped due to
-			 * races with parallel PTE writes in which PTEs can be
-			 * cleared temporarily before being written new present
-			 * values. This will lead to a large folio is still
-			 * mapped while some subpages have been partially
-			 * unmapped after try_to_unmap; TTU_SYNC helps
-			 * try_to_unmap acquire PTL from the first PTE,
-			 * eliminating the influence of temporary PTE values.
-			 */
-			if (folio_test_large(folio))
-				flags |= TTU_SYNC;
-
-			try_to_unmap(folio, flags);
-			if (folio_mapped(folio)) {
-				stat->nr_unmap_fail += nr_pages;
-				if (!was_swapbacked &&
-				    folio_test_swapbacked(folio))
-					stat->nr_lazyfree_fail += nr_pages;
-				goto activate_locked;
-			}
-		}
+		if (folio_mapped(folio) &&
+		    !folio_try_unmap(folio, stat, nr_pages))
+			goto activate_locked;
 
 		/*
 		 * Folio is unmapped now so it cannot be newly pinned anymore.

-- 
2.56.0


