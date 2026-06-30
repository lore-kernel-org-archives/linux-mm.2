Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27FBAC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 19:09:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B17A16B00B5; Tue, 30 Jun 2026 15:09:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC8406B00B6; Tue, 30 Jun 2026 15:09:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B9326B00B7; Tue, 30 Jun 2026 15:09:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7035F6B00B5
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:09:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DDBDA1A0500
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:09:11 +0000 (UTC)
X-FDA: 84937516902.03.E010361
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf22.hostedemail.com (Postfix) with ESMTP id 46A90C000C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:09:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=RKh0kJj7;
	spf=pass (imf22.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782846550;
	b=OsuGn0FJZn5URvhUyoh5GelREt0bmotyBcJz2PibHRXCTwnTVp9sjP9c4wPFDMe3YFn0Pd
	7LnEPVp5bEuSkAuDKr8VfxjvnNtVPfn5GLgHXUMFy0O9uaR+MONJgD8gVksmmMNDRUaQPU
	FjBHoZ9hPf6C6SFd4GRe2DgjUqtMKx8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782846550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0kaHdhZZieDrrxJiHdXSNOC3F/Y8uD5iXdhmdi4dH0M=;
	b=4g5IELJiYu8ctxEaAe4/4tLWSVfN0xckS+4rWbcP31cjGzcWY6IPL2OFViK6n2hVsoF3Zb
	cV0pXloo85kkf7stX/4edc9pmSdmNGpQzGFdf7+E6XUsWQCsd+Vl7qU+ClGErBW7RJEKk0
	brM3AsfmveY+CeFhNodeXXL+wXhhekk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=RKh0kJj7;
	spf=pass (imf22.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0kaHdhZZieDrrxJiHdXSNOC3F/Y8uD5iXdhmdi4dH0M=; b=RKh0kJj79M15Qw8NbUKDxSJoZc
	9OMktzlqvb6Dcdxmyfu3/Yxy8VCu80gGyQZERYzhY/H2rHThtuK4epGjhp/KdYACYxcAICNRWu9/y
	XyxprKCX2jeFm72+DNLCVr4zwZV1NQekLdmU3BlLq76p8WKFrIMAk0Ui1NJzBbkwXSCgDbqUCXfrt
	vCtemZvPOaIon6POEZXySYA9hZgKsJ4DFLp4fn+/+5ip00N67L3kPsosjqvyX+4bH5SIRn6ctq2om
	/W97HebRJ2V/nEaag1+VGX+GFtxZVMKfcR1ICtlUac8bDyGe4SUmB3Hm6MElnmtZhet0hxHp0diLM
	Kd8bppuQ==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wedpT-000000005xp-1SMI;
	Tue, 30 Jun 2026 19:09:08 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>,
	Chris Mason <clm@meta.com>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH v2 12/19] maple_tree: Catch race in mas_alloc_cyclic()
Date: Tue, 30 Jun 2026 15:08:36 -0400
Message-ID: <20260630190843.3563858-13-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630190843.3563858-1-liam@infradead.org>
References: <20260630190843.3563858-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: z6itzo39q4hwb3qtmu5g44uauxns58it
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 46A90C000C
X-HE-Tag: 1782846550-658183
X-HE-Meta: U2FsdGVkX1+6arke/xjHUGIAlY1kT6lUW6yAEYByAmxOnbjATymMyCbrbGnTiATo4Fafp9S0/wxBErfLdMcPWFY31RUPM6I+YSUzIgA30y5Bsp29XyrQYW0CDFZyKDrOxx674x7RrpDXjUm4oQ6948AZdruPndjrPXwzLUtlQWdwU9rBp9UpeKgOjVcwXYUsRi6MglCvtZPf8/PhoxntR0K6uLMiKadHqsHHFdeb3v7eWuHS4Apv/yPutlKbUrARVZpotTnZ5gTLXc2UpGoOeI++RJtwQFukfXSJ7UXKf6UWIn7iVewPQ7Y3OKbG0JJWp8L+JShTDxDV9jnIXjRY9LzoLJmMW6sZnDFvvvVGQyDQsZ3YQhdnIk+Q1W6LRQR90yOxTNJrz6i6emqHFRSPQWX3ILtmuZvMsVOhaeCucaW+2FGZX1LwjUsHLRwRLAVLsqz+eGl35oanxQOt66UOdQemXWzyXLPmOGB0iRPerMTDjjwFUzWonWWRGvP66eYlP8H68D5mXbBuBEVOZNQAKRaQw6Orp7x2JGv+5subJikQ+XrVzws+dpFRqsDOmOFqJQMQ3ZP1OayaJRo0oYDPADLYaDs8hr3EaBSEkmrrcH3s36Cs2OqFjkhYDLFNtoKu83AxtMr9wzAoSrfwLdy1zHJkixtPMTjC6XwhQPrauq8um6MTkomCDk92XKN2zGURxtgTu9UxmcqZ+t5jvCaaVUuiNR6jfjIkP6ukOwxjwm1Ziwq8quQqO4CcDwgb1FvU8nqq2siGUNJjEYo93NJO9VO/oOL7G52gjcl85jaBItUAJOWCkII72UU89AYAtcIDjTvmsG63c6mGDiBTVs9UwU0CJ6oeegrGAYWd6rguS581wec04ckdy5uESidvyMy0K4Klso56i3ALb3lZ08VcvOkDd6u5M8gvPzfMHijb2vke82TS/mIubD227iZiAx5LtIymvkapLwI2aTtSv8B
 yoI3LIYd
 XdPo4nStmasdlHQa53Xo3sRHgVQOZ4E35Qp1i4zW9pxRa/2bTsWOMkxGRqEee17qNeUYUwDxHvSTyi4q0A3WaUkBBzwzzOlULHsb63/p+nGKjvTWV/de+A6+BloxhvQcfMoIaLckN+HuRBPMnXVUqIBiN/2aPd2g1mOwY5apyxm5MnpiasVGSbZ6BlUl/QLuDvmyYKLjehurjvduo2nF1M8wFVQIWkaS+vbwb+xzrivDlMJquaq8TpYS4KWuLGVtyfaoXdLQl5k+d3DupudcKRYq1VZbYQbMhLZZvHV7/GjiaHya95kefHXq+p2cjN8tbwW40ULBlhYf8lVcAngsRbPD5BaA3cuTvo2aDRrWtpn9M2ZxCv0kJtK2R+O/0tyvZpFksvVTFcs2S51VSD97pruQW3eye7PEyHAWKsqZKGyNaby0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If mas_alloc_cyclic() is called during a low memory situation, it is
possible the lock may be dropped so reclaim can occur.  There is a
window where some other task may allocate the same id and cause the
mas_insert() to fail with -EEXIST.  In this scenario the function will
return -EEXIST, which is not expected.

Modifying the retry on mas_nomem() to re-search for a slot means that
any race with other writes will not matter as the lock will be held
between finding the index and writing the index.

Moving the flag logic avoids cases where the flag is modified on drop
lock/reacquire or when the write fails after clearing the flag.

No existing users are exposed to this issue.

Fixes: 9b6713cc75229 ("maple_tree: Add mtree_alloc_cyclic()")
Reported-by: Chris Mason <clm@meta.com>
Cc: Chuck Lever <cel@kernel.org>
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 lib/maple_tree.c | 43 ++++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 768193406c3db..1bc177bf42f9f 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3867,35 +3867,40 @@ int mas_alloc_cyclic(struct ma_state *mas, unsigned long *startp,
 		void *entry, unsigned long range_lo, unsigned long range_hi,
 		unsigned long *next, gfp_t gfp)
 {
-	unsigned long min = range_lo;
-	int ret = 0;
-
-	range_lo = max(min, *next);
-	ret = mas_empty_area(mas, range_lo, range_hi, 1);
-	if ((mas->tree->ma_flags & MT_FLAGS_ALLOC_WRAPPED) && ret == 0) {
-		mas->tree->ma_flags &= ~MT_FLAGS_ALLOC_WRAPPED;
-		ret = 1;
-	}
-	if (ret < 0 && range_lo > min) {
-		mas_reset(mas);
-		ret = mas_empty_area(mas, min, range_hi, 1);
-		if (ret == 0)
-			ret = 1;
-	}
-	if (ret < 0)
-		return ret;
+	int ret;
+	unsigned long min;
 
+	min = range_lo;
 	do {
+		range_lo = max(min, *next);
+		ret = mas_empty_area(mas, range_lo, range_hi, 1);
+		if (ret < 0 && range_lo > min) {
+			mas_reset(mas);
+			ret = mas_empty_area(mas, min, range_hi, 1);
+			if (ret == 0)
+				ret = 1;
+		}
+		if (ret < 0)
+			goto out;
+
 		mas_insert(mas, entry);
 	} while (mas_nomem(mas, gfp));
-	if (mas_is_err(mas))
-		return xa_err(mas->node);
 
+	if (mas_is_err(mas)) {
+		ret = xa_err(mas->node);
+		goto out;
+	}
+
+	if ((mas->tree->ma_flags & MT_FLAGS_ALLOC_WRAPPED) && ret == 0) {
+		mas->tree->ma_flags &= ~MT_FLAGS_ALLOC_WRAPPED;
+		ret = 1;
+	}
 	*startp = mas->index;
 	*next = *startp + 1;
 	if (*next == 0)
 		mas->tree->ma_flags |= MT_FLAGS_ALLOC_WRAPPED;
 
+out:
 	mas_destroy(mas);
 	return ret;
 }
-- 
2.47.3


