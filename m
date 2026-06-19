Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EBBFCD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 13:38:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18B006B0088; Fri, 19 Jun 2026 09:38:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13C966B008A; Fri, 19 Jun 2026 09:38:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02A006B008C; Fri, 19 Jun 2026 09:38:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFB0B6B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 09:38:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1E48F8DF0F
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 13:38:20 +0000 (UTC)
X-FDA: 84896766360.08.1A459F9
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6164F2000D
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 13:38:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=To0I8s1j;
	spf=pass (imf13.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781876298;
	b=OPx4kdONp+q0E6iiJWVaL4OkIokxZ5KdeZM4tQlEulyixfOmeU+oXcOpE1mQQYeIrhCPNd
	H5qnleS/u3tphNav6a7EmXE3pdvH7c+9mRYBcqhBBJPjhtmlpDurUusDEEeOWVDPbfnBJs
	FjnYr8YGTfzLMK3F+N/FurX7TLDj3pI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=To0I8s1j;
	spf=pass (imf13.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781876298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BMwaRfaSNig8cK1GvVKyG1ZNglpL5+cdZWNunlOULDQ=;
	b=QEie2UczZd9FEMphWYZ2Wublp9XnC+NjOMzbHvLYcGNWJaG6eYiMf0SSK8ASwqUL+JMLU4
	9VIIvt1fbpKk+tLmB1aAV2sQQ8uGcoy5GsClLgb9M6yWlCB2o+1V89//0QMGEWYXBCUCmW
	D7CfLCHWTPRqVFign9Z4WY7wqssjjkM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BMwaRfaSNig8cK1GvVKyG1ZNglpL5+cdZWNunlOULDQ=; b=To0I8s1jfrFK9OLyjtKYgwtcMs
	iyArb3g2zZ8KFEBOaJk7YNqG/XUTQYotcN/d8ouwTpYsFaDVQT8VErpSBKdWDiVJHEnPGyb2vL0Rx
	HsK6hVyAJ5WSdXWpK+GLqf3j+t/aiDZW6HxlOj5g6ZoEjPQnWhiN4vSyHoqNUxi6db8Dw6iWUf9fZ
	ShJDqyEIwVxAdzWfcnE40PHlSbAE1X0/tK0I6KjsT4ya4YpWeiRSzvN3cITut95THq8d5mLeCJsV+
	pmxOOpHH5WpEHZ9x0HQL1pZA2wnvtqH5wksmJOBxh/U3PBLnKuHXJim8jOd5T0PHhbVi3mO8Hb58l
	Pc742lNQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1waZQA-0000000GJ8G-1okT;
	Fri, 19 Jun 2026 13:38:10 +0000
Date: Fri, 19 Jun 2026 14:38:10 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Luiz Capitulino <luizcap@redhat.com>,
	Ketan <ketan.kishore@oss.qualcomm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	kernel@oss.qualcomm.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: page_ext: validate section in for_each_page_ext
 iterator
Message-ID: <ajVGQg0hJCUThz5Q@casper.infradead.org>
References: <20260617-page_ext-v1-1-37ad802b1a38@oss.qualcomm.com>
 <1dbebf73-6c46-44e1-ac6a-f5ffa9849b37@kernel.org>
 <698e5cdc-8f1d-4984-bb54-a4b7979b4dc8@redhat.com>
 <3149fcee-eded-49b0-baf4-ab69c27ff063@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3149fcee-eded-49b0-baf4-ab69c27ff063@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6164F2000D
X-Stat-Signature: qgjcrnpeid779jiwaqwde64urjqz37gq
X-HE-Tag: 1781876297-156600
X-HE-Meta: U2FsdGVkX1+Rjji1EtNjkPMwMxU+9W2YPwlVDX60nPw/wfsTZ4Eevo/8xbyDy931wkhFw0DnkUYrHPMgDex0Ymj5cv8NmxrXPGYbar/T6gA9yPz1rMkHR9RYhQcjtbvFm3qSRFm+jCXGeY93fIpn+NcZVe8MqiFhXS7idXNjHjHl+rkTLxei4vMxpWeGm+aU9BQUssYBc+Zd3/hpOX7jgzJ1AfzlSPdWyUTi4JeS+HL7KTMVjMvDgAPssBfDdWTCPrIE9Olyi76Y+jxNH0WY6x4NEuDo9vcB9xCleH3NnHrKDhw3oXlWyJ9/DfMcqJRmdEA4RJqtgptPXvYzIrpzdLr9ndSY1nMZNOuIwiF8Fvu42TaHn7ocX9czY/Xz6uq9xwbX7YQbRguo75oJY6+sZhZl6Lj+hLeu/JkKqGkJOcKA/PMtBWYOLqE9ir6hSys1athunIcpygY2BMgYe6J7xj4yuu0Sme1MioA6qyACPptvckrC3xXjfVUGMaYvggEznKKd8jg4o66dNdreON5LmIdQ+qDF3+ZmC7XtEuu7gSKapzrym2uHMNhBdmxPXGXqzi210d6q/Wvd698KbxEnSDks+CWey1X6V6CbPOcUIy1pO+WixJzSmSfEGxRJWiGPSuHcg3P3/0UtKCTBfk8Fie7fqNvGqPqipTwzhI+RZ/jl4q7HbZmTmQfksQt+cOnkDMwAOpdt7kZ/z4UNJiOJuiTUS2F8bh+lVRqyL2JMICofMnz1AiMan4I/0G0Hq0o5Fo9UJ+dqqU0OJzTvppWrFlvhNXfpHAn1IANNYH5oQNw3/KtOU/pVAmZiSiTv5ClqqpUPnPjX0DwI8UJj8DKREs/Ei/fYeKX7pNXCXDzuVIofPFyRhrwQ6G6WqZIG9xkFZn9BQQ15kZ9t94soYMtlyB2BkjT34/RhT4mP26In1+e6d2vK3wqwtwrWFH38jrM/wYZh9qee4CX0bDQghYR
 qvmMkfOU
 zQDEdpevwTNiwAoGQJcfrjDNfUPQOixte4PAPBVkVzF5sp4BlsbpKE7iEgGT6nTAdnrOSaBAIOR+bXleq35Pp1fzsdJQZqG1EVm0U+9seBtRc6Bhtx7oMoEUL6Qfdb2RRjiHRYWH4P/3KPq7UGsT802C+FUxdMwtB5UipewgJ21Q7FN4R/1dIIfEybYRn+5XrTULB6voQ5lCDThPpmGQZBaXYA6CTMgLnd8fePXqK65zgdVD6WSefy8axLh9k2y4noL/W9eRr/x6oBBqfRaanHJFhmK6gdF+AJeuX/+AANbb4UIwc384MqYrkQSOwgZk/Zp5Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 10:00:59AM +0200, David Hildenbrand (Arm) wrote:
> Likely we should just handle that in the iterator, looking up page-ext for something
> that doesn't exist is weird.

Yes, but I prefer to pass 'max' to the _next step explicitly, rather
than put it in the iterator struct.  Untested patch attached.

The other way to do it is s/index/remaining/ and count it down rather
than upwards.  But that assumes none of the iterator users look at
iter->index, and I don't have the patience to check that.

I find it weird that somebody botheresd to add kernel-doc for
page_ext_iter_begin/next.  They're internal implementation and really
shouldn't have public documentation.

diff --git a/include/linux/page_ext.h b/include/linux/page_ext.h
index 61e876e255e8..4f7d7a8709de 100644
--- a/include/linux/page_ext.h
+++ b/include/linux/page_ext.h
@@ -120,14 +120,18 @@ struct page_ext_iter {
  * page_ext_iter_begin() - Prepare for iterating through page extensions.
  * @iter: page extension iterator.
  * @pfn: PFN of the page we're interested in.
+ * @count: maximum number of page extensions to return.
  *
  * Must be called with RCU read lock taken.
  *
  * Return: NULL if no page_ext exists for this page.
  */
 static inline struct page_ext *page_ext_iter_begin(struct page_ext_iter *iter,
-						unsigned long pfn)
+		unsigned long pfn, unsigned long count)
 {
+	if (count == 0)
+		return NULL;
+
 	iter->index = 0;
 	iter->start_pfn = pfn;
 	iter->page_ext = page_ext_lookup(pfn);
@@ -138,19 +142,22 @@ static inline struct page_ext *page_ext_iter_begin(struct page_ext_iter *iter,
 /**
  * page_ext_iter_next() - Get next page extension
  * @iter: page extension iterator.
+ * @count: maximum number of page extensions to return.
  *
  * Must be called with RCU read lock taken.
  *
  * Return: NULL if no next page_ext exists.
  */
-static inline struct page_ext *page_ext_iter_next(struct page_ext_iter *iter)
+static inline struct page_ext *page_ext_iter_next(struct page_ext_iter *iter,
+		unsigned long count)
 {
 	unsigned long pfn;
 
 	if (WARN_ON_ONCE(!iter->page_ext))
 		return NULL;
 
-	iter->index++;
+	if (iter->index++ >= count)
+		return NULL;
 	pfn = iter->start_pfn + iter->index;
 
 	if (page_ext_iter_next_fast_possible(pfn))
@@ -183,9 +190,9 @@ static inline struct page_ext *page_ext_iter_get(const struct page_ext_iter *ite
  * IMPORTANT: must be called with RCU read lock taken.
  */
 #define for_each_page_ext(__page, __pgcount, __page_ext, __iter) \
-	for (__page_ext = page_ext_iter_begin(&__iter, page_to_pfn(__page));\
-		__page_ext && __iter.index < __pgcount;          \
-		__page_ext = page_ext_iter_next(&__iter))
+	for (__page_ext = page_ext_iter_begin(&__iter, page_to_pfn(__page), __pgcount); \
+		__page_ext; \
+		__page_ext = page_ext_iter_next(&__iter, __pgcount))
 
 #else /* !CONFIG_PAGE_EXTENSION */
 struct page_ext;

