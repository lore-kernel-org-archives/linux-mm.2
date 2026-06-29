Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CD73C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:42:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EFAD6B00D9; Mon, 29 Jun 2026 10:42:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C7266B00DB; Mon, 29 Jun 2026 10:42:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F203E6B00DC; Mon, 29 Jun 2026 10:42:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3B2C6B00D9
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:42:43 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E90381A0160
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:42:42 +0000 (UTC)
X-FDA: 84933216564.27.4BFF0BC
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6DAC2140018
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:42:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=S17asRHh;
	spf=pass (imf26.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744161;
	b=XSOIkIqwpj6CpVQKhc8qP7GzNksG4TpWA3VKh8q4jcsy2aPl67j2FOORajRZb5EeT3XK/W
	dHqRjIFlH896U0270ST9mSWr2JczofXVnWN2cHjqbxSYTz0DO7E/RfGDYv8na4ycpLS3o1
	+ju6WNEh5O7+dEqqDa7JnS6KIq2ipTQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p0Y0c1iyoLH4zFiPixcIiDtiPMLPH+Nu+9iRuZ1+D08=;
	b=YBaObMAGpHi8shBe6QttacKPb6+KEiWEN+tcPSmedLTBJ9bQ+hoUIrNiNa8TX3IzrVTfwO
	OCWXa5unnOMcXdyQHy8rP8vcmWsy1OsYdX5V4gWudRIVYIRFZnUNBwsdyl+V+ptmwDzLUi
	HyOHS2fghdvG0lQYepUBa2/jG6uGgT8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=S17asRHh;
	spf=pass (imf26.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=p0Y0c1iyoLH4zFiPixcIiDtiPMLPH+Nu+9iRuZ1+D08=; b=S17asRHh5hcqiM5dHnX2H5HJpm
	Vl9Sg2oxN7SSfdNSqZANoQuQPKVJKpJLod8QV3oD3TFqBMdQrCYPSXn7/82PoJOf1zvP4Kbs3sZj/
	zE7XPnqxTaw9TQA+DLze9n3EdW5Om25W1dwMfbTaJTQl+hSBM2BuWsjcPrD2adpJo5l0+kQfgLr1J
	sZT7yUy11zYvYqNXZljC5bJMO1+4s4Gr19aDZKZM2fkf4sRemEoOJ5djrcUolroSDfeyGnMdtm6EO
	/csJFAZsKJcscS55CWTe0S/k8Te/lHukIInJ3UeNbzCiO50ybI7v56TYxVo9P0goYBm/NiI3aVzRx
	EXjmRxzw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weDC4-0000000EuYb-1rXG;
	Mon, 29 Jun 2026 14:42:40 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH 05/18] maple_tree: Drop dead code from mas_extend_spanning_null()
Date: Mon, 29 Jun 2026 10:41:32 -0400
Message-ID: <20260629144145.1572283-6-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629144145.1572283-1-liam@infradead.org>
References: <20260629144145.1572283-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 15884zqfz36bgze746rn6rdxr491s6qa
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6DAC2140018
X-HE-Tag: 1782744161-699299
X-HE-Meta: U2FsdGVkX1+lzX9n8GSwEiWbEZNfMQGbzWqZbmzovSgbcJBz/Md1FTConTuitetFK8edh6lDw9fCPTLFMOLiZTy8zDzmc15umOssIcFANXU5IW/gpglUfoTPjzAQK0Wn6Sc7okF5jWW4Cqt4VUkyAxI4VzgLRDfajqWFxsfu/5kJJRc2soTTTyGgQazwzlhdJgnZ+jFjp75eMLHLEkHcq3NpwkGxoCaFajNnI37ol+ldABFDB4Kbbnb5fJEwgph187QWKC6IwnFfUCJOudsM0zmMQwiYvIyT19V7wP+JXhG5iAOdh11jTqE/A83I8E71rZ4BUgTgggyYocbObJnkMaRu+y6BmLi2NdMKjyZlh/sWRSjTs+5am8jCB64bL6a8X1X5So0FRn8Hw1DMfaR+FFBZ64Rtf5ZIxoD0bDD/fOMzPok4R6+isHJXEnTLped1SenGD/bZiSBXK4VFroubx1iFtE2qHq2AW8rsIzOQeT3yoBm262wIqbAenk51dEI/aVe2/B3KT5lNrb5E7ofhjJ5lM9bJe8sZwZTQrtWoWp3DOQmhQiyUe4dB+UHgoaJX8yiIhf7ithvqK+hr6rm7Q4A+Gy8o3KVCAXDyqS9AVeiXz4Xxdd63vnxQEn4NHXIkdwzaIZXpqhKGaLhdNk30gbZn1u0f9j0cmW/cQ1XEv2gDiW8AcQk1BX9kObbh6DRROc5EovYG4+xkAl70sZSSXiqGSDHeG1W5LANfuvzxiD4n00Zjmx6hufVYjSeqqMmNn7wmeO1az9P/DCeppEJZM+bcw9RFiBYh08fRVZOVdL+vpOZDoq8esZ5rpWuWed8ZZwRSiTQGSgVpNmym38kt7yfx4hhwXkfHYc6jLwNtgq5pyIw6UpWnXIQr2CswE4zEK37UGjwKzco1qLgBw4DFZzUQE0GyXBlWYpM8azbBGlTpgr4yMEdw1HkYQ7feNej0JoBRV43QDAJBgpFEO+8
 J8pXHAqd
 zzPZL2S3PBvdU3KMskamwZMwn8U9ZfQkpMJiy616jmBTyowm6o59oE+SUzmt5DpQpzicMFzmdc+fj1DilIPhPUA9dSvJRCQv4cw3W2my5Vb7mhEI2qMgGRusTshp+cpNV4BqXCQOMydNPKJ2xwUZwkVUr7GQkCtjcLMJ2TckNVaahwQkA0T+mBWFZCi7sTY7ATi2F9Gs+MLm/J8Rq0n0u+Wt7s/Nr+a3rD3OfcgcXHqw0ovPUKR0gdYQyl8VnuTjWp7hyjJ+uLaNPXt8h5IfOExI//M67OMvEDJx1xG0DmVxwgjmgrOAKbb29OxFHMSq36xgSfj1+Jfdnray5q/6Jj5CJ4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mas_extend_spanning_null() had a clause if the end of the range being
written (mas->last) is the same as the end of the existing range it is
overwriting (wr_mas->r_max), action will be taken.

This code path is not possible because the only calling function
increments mas->last (unless it's ULONG_MAX) to walk to one beyond the
write and then resets the value back to the initial value.

In the case of mas->last == ULONG_MAX, then the second part of the
statement will always be false - mas->last cannot be less than the node
max.

This code never executed and is flawed anyways (the arguments are
incorrectly ordered), so removing it is the safest action.  Since the
code never executes, it is not fixing any issue so Fixes tag is not
given.

Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 lib/maple_tree.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 1b2713190675d..f0aa08902b462 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -2993,13 +2993,6 @@ static inline void mas_extend_spanning_null(struct ma_wr_state *l_wr_mas,
 		if (r_mas->last < r_wr_mas->r_max)
 			r_mas->last = r_wr_mas->r_max;
 		r_mas->offset++;
-	} else if ((r_mas->last == r_wr_mas->r_max) &&
-	    (r_mas->last < r_mas->max) &&
-	    !mas_slot_locked(r_mas, r_wr_mas->slots, r_mas->offset + 1)) {
-		r_mas->last = mas_safe_pivot(r_mas, r_wr_mas->pivots,
-					     r_wr_mas->type, r_mas->offset + 1);
-		r_mas->offset++;
-		r_wr_mas->r_max = r_mas->last;
 	}
 }
 
-- 
2.47.3


