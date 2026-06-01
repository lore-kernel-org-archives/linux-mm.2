Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EA8ACD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 13:22:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A18706B039B; Mon,  1 Jun 2026 09:22:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EF176B039D; Mon,  1 Jun 2026 09:22:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92C316B039E; Mon,  1 Jun 2026 09:22:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 84B096B039B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:22:13 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2E9001A06BA
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:22:13 +0000 (UTC)
X-FDA: 84831407346.08.A804BD6
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id 69B0718000F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:22:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=pEAqU15w;
	spf=pass (imf24.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780320131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pOb9LhqR/KnOruqnLWEoD+CcFArNG+gznSArhzOADF0=;
	b=Oa+kZaK4uEVZIPpVWDVXBZMlU4+t3huFqkAgSUQeG8/ooKxUPrBjm4YoRiknl7inr/9Ra5
	Eu7xi8nVKHfCX/FAivJM/TJ0J9ixX2VM7XnM913WGY6jwLcJp8xJapZXrG33LLFdZGxnWp
	eRfKl+Ayz8A5c8vgQ6EgKQ20Gz+gKxw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780320131; a=rsa-sha256;
	cv=none;
	b=IxWwP1drUUlv88oQGMfTTNcO78AJkp1xSbtJ5U8VLq8Fk6og6AJffhnR8ErbPP9U8j3U/s
	6uSs9CgMi0q45OsBCGkqdKTVPEcngZPkex3JG5uXrK3rohF39rR3NnFNkGo7aQ3M7Fkj52
	w0/B07MxWQRDzpCWWxqKskO8qGSe6yY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=pEAqU15w;
	spf=pass (imf24.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pOb9LhqR/KnOruqnLWEoD+CcFArNG+gznSArhzOADF0=; b=pEAqU15wY3w7FBx9lf+IeFDYcA
	ZMtqkG79AngwWMDjJfNb+l77I4o0kjUf8yR2RUtyq/6cxL4IYNE0ZWTh/s8cykofwmrRu7RFwPxxb
	cqWnYivy4OZwETNsxEZ08R0wcKGqfcrtRGkoKTiSe2QMMpwRjuYPSMgmBlhMlqtB+8bzV5Vux5r2o
	mB7EVz9Wwic6DI1NSh4Gv3nrJ24JCyHxXsmm5f3oEjZzfEHMlW61UDHuXdXD1hw4tjVUQamIjcTjd
	G/FK9fBCVQUFypMWEGSwixw5k8csrjn4COsjIP0w8eYpnFbvrg70jGQVBq8Webn8HYe3uq6hK7VG/
	XG2j8IWg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wU2aj-0000000094j-0Q3n;
	Mon, 01 Jun 2026 13:22:05 +0000
Date: Mon, 1 Jun 2026 14:22:04 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Chi Zhiling <chizhiling@163.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: Re: [PATCH v2 3/5] mm/shmem: introduce copy_zero_to_iter() for large
 zeroing
Message-ID: <ah2HfH3jJZDiNAQc@casper.infradead.org>
References: <20260601055704.167436-1-chizhiling@163.com>
 <20260601055704.167436-4-chizhiling@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601055704.167436-4-chizhiling@163.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: jnbz74q5h69cyndo71eo8ms3j87ngh7e
X-Rspamd-Queue-Id: 69B0718000F
X-Rspam-User: 
X-HE-Tag: 1780320131-847909
X-HE-Meta: U2FsdGVkX18wOpJtQ8yL8pGX906B5EuZXGLLCV9KUWEtTVr7OETWm/qGB5QJNnUV5ysp2ik3PueqBzKOIBeH+mZJQFmMEpsVB5kpHk4Ob6SMe6XaDWpdbuF2K/YSO/Rc50DCjVNgqdB5NBCGd1fmnunkpv54yLDMGMe81rYWFcV8yV2t9V9LKC6pTIGlacDnUwbnd6CeT7Qx9lrv7V/qRa6LWNWEdswnrgdvIEwU0kV8Whx1Y3nGYRqIMbJzxaO+yi7E2gEUvhb/B4OxA4oI1dwTILaEUfCyvIlsQxO3ljpEGZ/X12j28m9IjzjOOM34NG2Mzq72Cq6jqURwdxPQSE9LNDGWk/IYtuWB6gf+zDleElTsPR+tKZn9zO9W9WK1ppHxgQutjJwchXJ1PSJgF6Tf6TfEPCSy/tN2Z5CNYY5vZRDxfG6yXbzq4lcQMC1bwj34/ELuKdnyVP5YNZxTKtcaTK+n6CYcvGJ1/jZGdbUlg3YK8oq0JHFOrlwnKzgyHagLd0eOhjkYZIAcUKI2mukAfe1DexNQaSyB+mlyNei7C5q+Sz9vtWofTxL9j3i0AcMH5+RVnND0+VPmfQcUp4kpOZKKp+AhIU729JSITVLFQ8UoqiCJLHL6F/py2q4tUqrnp4AdVfHNcXCs3sYWoUAcWK0drllKI0hVUuEdBK40WQgvxJDUNzvgLEwI0XCfwi9hmhWtcyQvm0a7tasA++qGgWGfT3iSVXfHkrzRl8S8sDoUFiIglNQ/sU7ClPQMczXwWEcg++hQfnG2SubksfkcsPTdzRgr2qhqDCV9/FoLKNIYr4Cqy90QOekJwJ7Mmzwl0mt+4GDRuTENvAdqL87Nsi5KFW0qTvTs5N8+gIQXr8pzmy7NeBJJoTNXjpDXqUZb7r3VEmJJBgBR7+OzyTwvRaGrQtn84EsiOngtC/88ZDvBamqSrHi6V6rRBILiHz+MO+HJh8WHlvQiL3d
 N5MgBNmd
 GtFZL5Knv6pehV+usJBvTF/wPsxqCqJUeE1XkOZ6C16pxb33trBD35Gpb/HSHPGXgySD7UORvuWU2ehc4hU7/uY4PLMCXmZom4De3Ncal6qF58rUEt3uZymKdaBaDRctKpst9vUa6Wt7/pX52Nxovj+95f+et69T4UgViH6qi+mdimfnsgJf5CybTmuyv9AqPJqDo4szx+bp6gtEtqnA3kc35lJgwNqmpO0tvWn1MTjZ7l8SxeeX6HLKREqKFjHbsZHtkFd4rmDQFH1PS4TzY+aPeKSMBNbHt39ZUMCi9+75MxKSii2+RfDWLTCASGRXnsBi7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 01:57:02PM +0800, Chi Zhiling wrote:
> Currently, holes larger than PAGE_SIZE cannot be handled because
> ZERO_PAGE is limited to a single page. Add copy_zero_to_iter() as a
> wrapper to support copying larger zero ranges to the iterator.

I think Hugh put this optimisation in the wrong place, and you're
perpetuating that ;-)

So perhaps we can start by moving this optimisation to lib/iov_iter.c?
And then you can redo your optimisation on top of that.

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 243662af1af7..06c54d719fcd 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -451,7 +451,23 @@ static __always_inline
 size_t zero_to_user_iter(void __user *iter_to, size_t progress,
 			 size_t len, void *priv, void *priv2)
 {
-	return clear_user(iter_to, len);
+	/*
+	 * it is noticeably faster to copy the zero page instead of
+	 * calling clear_user().  Shame.
+	 */
+	void *from = page_address(ZERO_PAGE(0));
+	size_t res = 0;
+
+	while (1) {
+		size_t n = min(len, PAGE_SIZE);
+		n = copy_to_user_iter(iter_to, progress, n, from, priv2);
+		res += n;
+		len -= n;
+		if (!len || !n)
+			break;
+	}
+
+	return res;
 }
 
 static __always_inline
diff --git a/mm/shmem.c b/mm/shmem.c
index 3b5dc21b323c..112cae9f9e4f 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3427,19 +3427,7 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 			else
 				ret = copy_page_to_iter(page, offset, nr, to);
 			folio_put(folio);
-		} else if (user_backed_iter(to)) {
-			/*
-			 * Copy to user tends to be so well optimized, but
-			 * clear_user() not so much, that it is noticeably
-			 * faster to copy the zero page instead of clearing.
-			 */
-			ret = copy_page_to_iter(ZERO_PAGE(0), offset, nr, to);
 		} else {
-			/*
-			 * But submitting the same page twice in a row to
-			 * splice() - or others? - can result in confusion:
-			 * so don't attempt that optimization on pipes etc.
-			 */
 			ret = iov_iter_zero(nr, to);
 		}
 

