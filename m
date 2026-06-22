Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAC31CD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 14:29:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19B126B00B6; Mon, 22 Jun 2026 10:22:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14C1D6B00BA; Mon, 22 Jun 2026 10:22:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 088CE6B00BB; Mon, 22 Jun 2026 10:22:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8EC406B00B6
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:22:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0CD7CA01B1
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:22:11 +0000 (UTC)
X-FDA: 84907763262.09.8B5ADE8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7385A140003
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:22:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YKh7fVcO;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782138129;
	b=1nSiyuEeLTEQEiUqyHcdVSRZrM0R5VYVNwQXuP4xnusyWlGyNF3ReE4pc39wymJ6zcvYW8
	1B3Uct7C7idBc4IkrNUopLas2uX4xOKvz5BeAnxSnzyh91S9fdSgCiuWiECaDAGggrb5cb
	TbQw0DPmFt80B63j+0GsjWwlW7NQMCY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YKh7fVcO;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782138129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yDzAJDAVQX7rFXuERBq8+a6fsMKEIvYdRJNiU0vHoME=;
	b=NEYL3ARADIicIdkIsJRy6NQHrHK2JaZJQph21D6V8+SJoQKtYmTzmOed6HI7YTdddii6Rs
	SCmMdeC2ZGLeHVx8NJyxBwQeESpu3XkOSjgqcE7SinwqIpV8RchE57OOwhKIIAx+j/vVRY
	Ua4UhzEYRnqlfGN77qo/OJWWeR9LNuQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 13ACE60202;
	Mon, 22 Jun 2026 14:22:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6CA1F00A3A;
	Mon, 22 Jun 2026 14:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782138128;
	bh=yDzAJDAVQX7rFXuERBq8+a6fsMKEIvYdRJNiU0vHoME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YKh7fVcOTLzrba1i52g2yPRRyhzaMsT7D1T5XMmeIjdfwjU93hAXKEa+ABrHYgHOD
	 Oi0yPqszRwvXa6XCAFdqXEgzBnaYp2MeYf7mMIdXR/20MSzsgtQgJ2mWkfcAqQLT1L
	 3OTNfhIBI5Fafxg9aUPEO/rxGSsdEFyKdY3U7pueLPjuPQMnh0r5LP+yMSS0mPtZ0Y
	 PDCM3jecb/b7hF9w2Ep1/msVGFVH1HFa+98fJx8RHXkA5K0FLEDwtoJpb9lbTXplUC
	 X4LTGt19LVVyqeYCaJ6AHhOa/HjXxJ8OD4IcxpFYsVt9fzFXmjtvvVBho2fdwUGGWt
	 LGVt5ITAIeuBQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 16/18] mm/damon/vaddr: remove attrs param from __damon_va_check_access()
Date: Mon, 22 Jun 2026 07:21:36 -0700
Message-ID: <20260622142139.30269-17-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260622142139.30269-1-sj@kernel.org>
References: <20260622142139.30269-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: su6es3mtzgawiqj9f49tydjtqqq9y9ku
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7385A140003
X-HE-Tag: 1782138129-707992
X-HE-Meta: U2FsdGVkX1/ep2VJl1m0jbg7chhDQ1RV7uswPjAuNV5YHnMjHhgLS4l+lARfO70JhU3X2ZMgsHx3RlJ3rclgIjq6g9ZDHUn+W5uSBqNJpXl927CYV2n4OqbJW8ajXXwnl/4sEsB6naSTMVRN88QpXLMDAjA16e1DE7Ng0hh9qCD3gU7UVm3A/qK04oAJ5xvLL5F4IM1hQWCh7chfr3ilnJ78sEkphiac6afEvAvIVPh5RYkt+Wq3Fdk6qexA3TXrZi7VzAtC+CluO2Bp5Pj2UNhvm7DhttgiHW1/pc/YNXRBDf0TDbrWporItWTLmekUxmwfMt3umLp8WaCba+xVob2EeTbUkmOfAVE9pjmk1mV2cVdCZjfSY/7UhrYvg1uVr3NVdMR/lfNXOi8QQUXbkJRx9ya5cgPmSs0ZXb4AgdiU3NzHGJQwtZQYmRwIAaOCBQXQ4kmc5kkEKH2ypc8YB0Iax4zJAGY7FdV8zphwC+CFSBgU7Oblwl6+a8Q4oBwmezpHEo62JTsicKKrSiHktMfasMoi51pMmEkpaFpdiHE69pCWEX0Eb5rHUhTxccY78QD5XVn2t9VFX3aWUq7RIh3+YP3SrBujxkG7dS4kHZi0lLFuUgVa6ID4J49i2T9gVJNDi0skrhpuX3KGKCrbD93L9D+7W324o5AMXp34Ml0w1Xbf2XrN9KWODb2zO1tArIKM9dHUh0JNXCmq4OWsVp5dOFf490VmYPBB/PYTpcAxAigDwjyNJFQBcCwl3o3ynQJhl3SrUIZTzTFyoqauojC78I+oCqrYpLm8mqdibcWiwBHPjwZUZViglLintiHsKzG1UaRAEqPCKu5/OrYChe/5FY/YogCzacDdjQSAyjL4mmIBHcbM5jACJ9Xyv6XN6ZboC0bJ1e6M2WiUTUL3AnCmXDDyR9Wi+NrTBz1srhxVPPoIrHxPVzlUtMsbfBgMVrXdjnrIxNGvNKeDkF+
 pEAWH2Fs
 QIUvE3dTBmtqWxheEZtY+TEGeGDyahZjLVybdJyVXuAGoqzSGrENhZOMiZ4PPSoZXhCQiJQhk/8+yxOcBicsYjkLrYTf3XROqoY6VjlvPP0aD819k+H7pVV78x42Lx2tA+zpEv1uC6rsGlkvQNSkUy5kO/sNWHnEuWYf099+nPx2YKSk/0is/aDPvOLa2ynKHoiI0Ulear2hH/N+5X/kMuVrF6swsoL7K8lTV5SZIYVcZ6H5WrqqrDrtySd5mc/Lp4OYpNcxgo0a8F6z/VyT3zhWXmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function is not using attrs parameter.  Remove it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 2e12cc628fea0..ec08fc6624479 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -495,8 +495,7 @@ static bool damon_va_young(struct mm_struct *mm, unsigned long addr,
  * r	the region to be checked
  */
 static void __damon_va_check_access(struct mm_struct *mm,
-				struct damon_region *r, bool same_target,
-				struct damon_attrs *attrs)
+				struct damon_region *r, bool same_target)
 {
 	static unsigned long last_addr;
 	static unsigned long last_folio_sz = PAGE_SIZE;
@@ -532,8 +531,7 @@ static unsigned int damon_va_check_accesses(struct damon_ctx *ctx)
 		mm = damon_get_mm(t);
 		same_target = false;
 		damon_for_each_region(r, t) {
-			__damon_va_check_access(mm, r, same_target,
-					&ctx->attrs);
+			__damon_va_check_access(mm, r, same_target);
 			max_nr_accesses = max(r->nr_accesses, max_nr_accesses);
 			same_target = true;
 		}
-- 
2.47.3

