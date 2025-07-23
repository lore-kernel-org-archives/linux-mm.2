Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9581C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:34:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 614456B00C0; Wed, 23 Jul 2025 10:34:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C4F46B00C1; Wed, 23 Jul 2025 10:34:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B4046B00C2; Wed, 23 Jul 2025 10:34:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 35A616B00C0
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:34:05 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A22E48072C
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:34:04 +0000 (UTC)
X-FDA: 83695774008.16.3A0417F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6A5D24000A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:34:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sBf234vd
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753281243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2B1Vo0/j3crJLhvogIai1rlzti+SXL6KBl2BvGLFRhs=;
	b=Twbp762e1xcH9MAnbYYoPoO2YX5Zkb0bpJQCZokMM9FBxVOnD5yLanRL+YEZW0izk+TbQe
	5tQPitEgyv7OevxJCidG/ifQBvpIAR1um+cLWcuG+QZ2sx8EZ5zYHsOCGR1Ds5CTuNWg8Q
	/G+z7Sgi8fvN0PS6yR5GscqS51KR7bg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sBf234vd;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753281243; a=rsa-sha256;
	cv=none;
	b=HyMyVFcLMrJpyU0bMgWWS0RpzHYNdWN19p+ZDtPG4/NiZRCmJrQ+ofRm2H+gJXyxz4ezxW
	7Gij7Y/KbyVCiOM9zG7zXDSaMTOo86VcmPw9+pOTQDbWi+iV0FbV3p1zg8yNeQXoMgP+a4
	tyrdw5lLDZ49hImsnuH4X25k/oeTOC0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2B1Vo0/j3crJLhvogIai1rlzti+SXL6KBl2BvGLFRhs=; b=sBf234vd9tTmtB4mGJO2IwKMol
	7fb0Xmtgn+nj1hGNM5uxxxgM48aPT4lP6jh+BzTUNLl/GHIKRIoIlO4q2O9aDNEYWk9dYxq6eW43i
	ul3hjgcdF3aCz+McqDWehRRBtz0f1nR/TklA6RR+RXyGZcwEsFx+d1Lgl+ei2GPnJE+3T+QRD7G6V
	hYxgjHWh0QO+m6xkekEmgQ4hSV7qxarvVS5nc73ZnLWkKyJnY+ZQlRQWoGXPSlarLeL2r2J7pAJE7
	N2JqSp+uY+ln2juW+KcTsBjngH55i3LZByWQHqRcn/BQoAiM2ViGbEd3fbmXYD8H38FrMpubaBwtw
	s34NQXuQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ueaXc-0000000DLA2-0fWm;
	Wed, 23 Jul 2025 14:33:56 +0000
Date: Wed, 23 Jul 2025 15:33:55 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Chi Zhiling <chizhiling@163.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: Re: [RFC PATCH 2/3] mm/filemap: Avoid modifying iocb->ki_flags for
 AIO in filemap_get_pages()
Message-ID: <aIDy076Sxt544qja@casper.infradead.org>
References: <20250723101825.607184-1-chizhiling@163.com>
 <20250723101825.607184-3-chizhiling@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250723101825.607184-3-chizhiling@163.com>
X-Stat-Signature: umjino7jp5399sfbonzjr7ne9wztm7xs
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6A5D24000A
X-Rspam-User: 
X-HE-Tag: 1753281242-63006
X-HE-Meta: U2FsdGVkX18yqdPQULBbgi9fIW8+RpdsfQYXLzG1JLosfIYCdwSYT/H8YqwWvS+MtkWxPP++jSrRg461HOo7kmWpZpglBZSmR/+ZXVms2cu+CTbzBpp5XssNdITaLsGP6joTc224wsuGJWdK4TUSvfyFIVjWWhumRghKBuolQjWMysWvEKre6mXwVKNAop7/ZRma2cQNPP70BQbOTFJv5QGBmdnSdZZ1254TWB1VGwyGt2Dyoh4/D9jcAGdYDdpEadLbGfzLMtdQYGO7iQpDwcYoqRTp+la3jL9GhYB4W6p0+RpVTwKzPLIUOQY1paEcsJ3sixHzEzFkH0HdrIhPo9Gvkcp32wQktyUUWXJelwJqLKgM0LuJDCo3Yo89FTIqrsmoyhzahACww78/ewtmDW69kqQKFCj7oRDRMTOS5FDgctPjotKgYwP4/Iiv/3uAHAANdiKtrMPLu2NmSjJETeixUiSktlVLe1donYI8ORrcIGqWJ5PTRH7ST/Y8XBh5of2ssWlDXd4ovTPhJuWgJ4YD33CjNrKY799ryhyKsSGWJtJCUBI0ZjNi67od8fTTiIKKDKs+y48MrUbifF6f0N/VaTOM4pJ9Nawdks7PcINfCHMAB1K9ClxfGXVr9ak1L0zth+pXl6+d/KUBMMnT9w1aqZTFN7aigmqOTx+QZ0m9weVzSJ4owDDX6hcKz1QW4VKSWSn/F3ErF+5Pi/qkL9b3ljkwaDFKAz3JCNFhNd19PQrE66zYQgniig51+HnoyehKKs5533Uk10afv77Vr59PcuY2S24My2e4h9zerJuRi1eprgfA62MwVVHRaFjLp/7N8fSPECpCHrfdejSrVaKUw95ig4G8df6eqVu1g5ACbRyr0b6c7TYCyvZHFjWelkkFz4z8FL7XYFX0o/ENwNQ5T6kq+PfY+26qiTfzUM3WT1w5AWiSxiW3KfxY+ZwHxA+0SqZK6nLUxoD9shK
 H8lNFS31
 WZuSjgOO1RGbzbwTuxbo0/i96qE9a0f2D0k8cia4ffR/U8bxE6RI6u5miL8NZJ1CmiR4M/XNYrUqKfZPZ7u3z8pBVvKhu/OqqsZa0YxQOkRNI7Wd4E/j+9sKd1qenKodFj+fENm9YMuAm0EWfjH/Rq+TDS/lSL8esDmMw9Rc1i5gZ7Nv5MyvvPxKv95CpwrPrRVGSU0azEqoXH+C/RG48E1mPHpJTnGv3UkeR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 06:18:24PM +0800, Chi Zhiling wrote:
> From: Chi Zhiling <chizhiling@kylinos.cn>
> 
> Setting IOCB_NOWAIT in filemap_get_pages() for AIO is only used to
> indicate not to block in the filemap_update_page(), with no other purpose.
> Moreover, in filemap_read(), IOCB_NOWAIT will be set again for AIO.
> 
> Therefore, adding a parameter to the filemap_update_page function to
> explicitly indicate not to block serves the same purpose as indicating
> through iocb->ki_flags, thus avoiding modifications to iocb->ki_flags.
> 
> This patch does not change the original logic and is preparation for the
> next patch.

Passing multiple booleans to a function is an antipattern.
Particularly in this case, since we could just pass iocb->ki_flags
to the function.

But I think there's a less complicated way to do what you want.
Just don't call filemap_update_page() if there are uptodate folios
in the batch:

+++ b/mm/filemap.c
@@ -2616,9 +2616,10 @@ static int filemap_get_pages(struct kiocb *iocb, size_t count,
                        goto err;
        }
        if (!folio_test_uptodate(folio)) {
-               if ((iocb->ki_flags & IOCB_WAITQ) &&
-                   folio_batch_count(fbatch) > 1)
-                       iocb->ki_flags |= IOCB_NOWAIT;
+               if (folio_batch_count(fbatch) > 1) {
+                       err = -EAGAIN;
+                       goto err;
+               }
                err = filemap_update_page(iocb, mapping, count, folio,
                                          need_uptodate);
                if (err)


