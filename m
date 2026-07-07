Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DE86C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:53:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D0C26B00C2; Tue,  7 Jul 2026 09:53:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 759C06B00C5; Tue,  7 Jul 2026 09:53:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 648676B00C6; Tue,  7 Jul 2026 09:53:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 39CFC6B00C2
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:53:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B5B72C19D0
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:53:20 +0000 (UTC)
X-FDA: 84962122560.19.BA1F414
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6783540007
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:53:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=to19MXZH;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783432399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TW//luzf+xXNmQVXXXLPR3JvmqQnE7kuTImybvRM7t8=;
	b=x3u9Uuw0dKJRbzVoQ6uuPzz+HegWxZVf0fv8Q3V3hO8DPJuZ38hHClDN93+49hG1XENIS0
	IIbvKqRtNE9ZYKnVb4wvWag9bTeiW+ZZAwe3R9DEAnviypUqN6sSpNGpP5f4fVyKVGnVvz
	vLRHBARibtobgOIrQgmdO6KmMmuiyks=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783432399;
	b=s/gyb47mcANyiwqq2fekEbCgX6aJM3l0jCwWAg8T2AwiIPbFLieuZXWwxLmm+MdQ0IGRxM
	r7SFVQ/Negf/M8uYgPbt+6G1ICq1onDLIWdmWu8CJ9p1RMiX7HqTe2MCOHHx/SmGehPa9p
	+DCh4dMyrNj+/TXEvaae3WJkSg89+g0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=to19MXZH;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783432395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TW//luzf+xXNmQVXXXLPR3JvmqQnE7kuTImybvRM7t8=;
	b=to19MXZH26e0lK1SUKTTJ/uF1uv1irzloYSgrhIXP/h2zaO7qKu2jEVZLEoqktGXDOHIoZ
	x174qMBX0FMFqTcolmCaR8/rwB/PPZLUa+BDIgxnwPmTuoCDzPQJWjqfJRX8ZBAUw69q/f
	CFrb4qGIIK3QWlv6sEGALnyP+ghvVcQ=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	matthew.brost@intel.com,
	npache@redhat.com,
	rakie.kim@sk.com,
	ryan.roberts@arm.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org
Cc: sashiko-bot <sashiko-bot@kernel.org>
Subject: [PATCH 1/3] mm/mempolicy: skip device-private PMDs when queueing folios
Date: Tue,  7 Jul 2026 06:45:07 -0700
Message-ID: <20260707135255.292870-2-usama.arif@linux.dev>
In-Reply-To: <20260707135255.292870-1-usama.arif@linux.dev>
References: <20260707135255.292870-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6783540007
X-Stat-Signature: 47tz68dn7pk66ytgmahtgsj8ntkhiwnm
X-HE-Tag: 1783432397-335454
X-HE-Meta: U2FsdGVkX1/sOuXchlR4y9Xe8YUiwgsLa8fZMf3jhJ31ohrtWAYleyewct1H2+3Y992gRBTki/L+FxrEPxZjDqtrbwapSJJlvehBP8i4L6z4uswSkBtEVh0+FhkDsuLh7EGWfXD4pDxH2L0i9OXyrMR2dW5m9VlaOBcV+TfQKOiDBGvO9iKmMgGZYAG8pNqYZTs3asVxFZSCaRr1+JEo9E9pIDIETo8vVd2rY2nwAePziDDtaCDfK6f6R8ZxCiJC8YXQaXSgU+saSWi1kdC2kIZ4w7Z+vvF7lLpNGvEAEXqZTbQv0NZhI7G7FnVHUV59/KVZ38vd8q5QTh3LK4HXLYi3LZm9kQYA6idkXG50l5dlO+M1hwQlu8ADW7JSzm/5xbI0qpio7Kp59Sd30D7LwuGunncUPxVK1x5vr8VWOyW5olacfPCdZyBVWz9Wwt3ksxOmtRiFAP0VWwzC8m9oC3cdzE0GzcLGcyWIDZI/atZVIQM2PCRxy7oBt4aW7S611nGYl15xTyHz1xcktO+pSSUL9VHMWsuqIyOG0IuV1eDbuRg01hFq/b+HCxduZvB2lfTmqqmPN2r+MVIDd6qOTS1V/6GNJZi/rEzJrQFISaLWyK8wRGotnh2kLbSDcpjoXu+fDr1wq3RVWsJJNY8Jnv5gNwJeUvpHmr1CD/LeBN2whlxBhOshJlFyZ+SpJd9yPBuiSXdYWFVn7jcdSYQ+4Y7iz03UfiGpQHnVZ9iPMaH1oPVgF3A9TlgoPJv9HTi4mueE9EzQngog1pHQP6nM1SCu8CxS4XyvZy9CEDU1DMLOMDE0Qr9gOLbyK7Dc74eF9NcbNs/NVH1qkzj/9ZFpB2M7k9ITdQ5jyN22heYyqdmOmacvPitLBtzhN0t4xbWMGA3ukayNwVa8f9VLDr6vlDJ4+s9U6o88miXHiTL86fgjRl3gmjcOS9Rn6VzsOh/enf58tiKdamjoxqP7VsK
 Mp5Of3MP
 z5yXfQbT7veGgaRewwvYAcmwtbWEyGx6eo6kAXCzOYhtClAuuKPnX1qxB2VVh60imn3h1NSOAszQAynRpmYGlMFmdw+QHHXMX4HLzVVz766IFfK2AjkJ5ChJEG/YxYVxuex8vNPQ9y5HqsqeLxkh6Zi+mRhQWSySdJjR3i0Cmgw2fK08mFSNvvtbkzMrfrwgjrqrUPUOGZ8VV3REC0SVE8UxvnuRRZvNw3PuOAIsTRe3uQQtKZu5UQSaM0KFDmkEnPxax3ELxjLSLotejdi+NzcCOo3SrVWuBb5AlzjyJFdy5fh3+lTaSTg67GPJHdJ/PEZpCRe8cBmRW1yfVKpXvQR3HrPK2Cr95MP83NU/pEeI9k0U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

queue_folios_pmd() is called under pmd_trans_huge_lock(), whose
pmd_is_huge() check returns true for any non-present, non-none huge
PMD - including a device-private swap entry. Passing such a PMD to
pmd_folio() extracts garbage bits as a PFN and returns a bogus folio
pointer.

Potential trigger: an HMM-based GPU driver migrates an anonymous THP
folio to device memory via migrate_vma_pages(), leaving a device-private
PMD. Userspace then calls mbind(), migrate_pages() or
set_mempolicy_home_node() on that range.

Skip device-private PMDs, matching how queue_folios_pte_range() skips
device-private PTE entries by checking !pte_present().

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%40linux.dev?part=6
Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/mempolicy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 914f81863db5..eda817539c77 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -659,6 +659,8 @@ static void queue_folios_pmd(pmd_t *pmd, struct mm_walk *walk)
 		qp->nr_failed++;
 		return;
 	}
+	if (unlikely(pmd_is_device_private_entry(*pmd)))
+		return;
 	folio = pmd_folio(*pmd);
 	if (is_huge_zero_folio(folio)) {
 		walk->action = ACTION_CONTINUE;
-- 
2.53.0-Meta


