Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2E92CF885D
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 20:11:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D65F6B002A; Thu, 20 Nov 2025 15:11:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 286816B002F; Thu, 20 Nov 2025 15:11:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 176326B0030; Thu, 20 Nov 2025 15:11:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 00C0B6B002A
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:11:21 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E6DC413A948
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 20:11:17 +0000 (UTC)
X-FDA: 84132079794.18.15FCDE4
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9379E1C0006
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 20:11:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=o7y49xd1;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763669476; a=rsa-sha256;
	cv=none;
	b=QBBtP5LfsW4aZW/19WXPgKqHp3knXRdU3bmu4oylxCzPpx681VyahCfUG1RgjhBFdcx3Hc
	IU0NtsXex8boNRBt0nRerulPw8Wgc+6+it86ok8f0ICcnJpJcuplXCZtvhqD8p6nWP2vh4
	Ea7u8viFe0qHbSKijQhAdExv8jmF32I=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=o7y49xd1;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763669476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Mk5oAJEe+EJXniRo6EvF68sF+I7K1SlxfHz2eY7y68=;
	b=nSP6sEFqqRuVyesay3hqpVBuUs+KKlj5nct00Tu7ynqld1Lp0yjYUwnBNxQk/ffpRYDkGS
	35gi+Yc8XSFc61WX/O9GzjBaTrXfuIJXr20JgL4TZjhBiQcOi31GprdxzctTrZwlonw0UH
	YwHsSmHleAF4Uq2b5/sAqxs0SqTyc7A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4Mk5oAJEe+EJXniRo6EvF68sF+I7K1SlxfHz2eY7y68=; b=o7y49xd1bIJss61h943uGovO6C
	ndWFoS+qBoj2F4mMR/4Pax/u0+HLveLzEm5oqc87spBpJbgjwDW1RViTTYttbelqxTST3Sgq0LwY1
	0jWs6lyb2EpBQiaPxlApurqaG/JgLTstPzf0HqHXGYzgB8z8fz+lugiiG/OHTJBpkMvXPHNiqu7uD
	ioRQNeqtWPrI7fp/39IvGYqOZwrLPRFw/gxpYGkY27LgQLE5lnUg/jiqJFeBn+tLJtB5YmAdj7mQ6
	IStDtWHQ707sDjH//GCPmWtdektwZ0Yp5+ie+Y4CPQ8zwRIcqU44/vtpiFQXbFpGb3N7HSVIK7ke5
	dnhe6i3A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vMAzl-00000001jnZ-0eR7;
	Thu, 20 Nov 2025 20:11:09 +0000
Date: Thu, 20 Nov 2025 20:11:08 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Harry Yoo <harry.yoo@oracle.com>,
	David Rientjes <rientjes@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] slab fix for 6.18-rc7
Message-ID: <aR913JM35YDVSCjF@casper.infradead.org>
References: <3f4ec3be-0725-43cc-a75b-72549ebdc5c9@suse.cz>
 <CAHk-=whUBuZmRNGCxjnAkFQLO_HVV8SgWEAUg+3z4EARD9MM3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whUBuZmRNGCxjnAkFQLO_HVV8SgWEAUg+3z4EARD9MM3Q@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9379E1C0006
X-Stat-Signature: d7zsqf7igk9umz8655ea5aaac8yerdn3
X-HE-Tag: 1763669474-395799
X-HE-Meta: U2FsdGVkX180e7eJqzPFZayo/GWpWh/8s1rg6JlvUHVTdyUPy7agfFVDi869aP7CKZ75tirPXo+qjlssnrNq6FdxijFQl8F1aOefp2U6TuRKbZReneW+yoCBsddNLk+ZvLCsHwSebQu1bzr3gnunMTAJr3j/BCMa2DWp115fe9fLEX502p8gvCU2MIBTDdfvsRq4SOf3JMBWkV6f4lf3d37jE5Iwt850ZUH6MclRgqU7PEFUo6sCUBMNHP0CuEkGYlraQwOZMq9sxkO498pofwlVf4tP9yj763cXJAP2NxHsclRhg3KhfTIUoMHnpSEVKbY7mQ4T1p6NnptgdU9w6qhYIJR5oa2KSqu1Jw0ZL2v7vby+6C4BZ1jzoy17KqcpccKioznhkMjOYlwqQ1MW5KMjlA+sBvXqkUGSBNiQB27wM6CGY60DyC6ML0deQZFqfUGhRNjjFbVL4akqRD8ISdiMkKZiZLiceaX/gyY41fyvvY3DWUe992wVQ2EjTB46n6cNS+nAE2WjYUXowIJkGccIZYh5+mQEWh2nAyvJVfV1mZSCtT6rYt8pyhG/9KjI70Q54Zk0peU5qSWaoW7Ob0ZiaYUzFV5Mu/ijt0fobHh5JNXLPRdIgAHJYYhzTvIuZC9x98mLIkS91+8BiKaP0zxYgey3XW8U+FHV+xuEuIZizNy3ASWeGqKLkdWYFAks+bz1AOBpQBFBgtxskfcHEZNfSQCmHh6ufGud82U6B2/582ompTEw8m4VesuPjoMH3719RErEKJVmxXVqHxZzfvmYWBKZZAdEexIAsWxv8WlEQlnG/PTsHxmq7CD2fSqzuuR9+hxLWiAGk7OKupT6L5TVnH9rpbV5kzUOt1uKt/Dq7xz+3L8ne9gM8N8yxv7KvdcesWgNWzYe1pgO6waX3uDapmxZNONCDGpAQ6iBR0dE6MZEuu1Q2Xe67d0Qq1DkI72y/ENvPiynnKbGTcV
 s4uoWBj7
 WnnhjoFG6qh5a/+Z84n+zAidJAn8KBNj19pjaH0719qEZNvaLOTAtl18WamtAlO32J7aZBZnQ+NovMJIR4coY5Aw5koBppHJ16fg5WSIw75q2ygkPqTCgsrHzjzpCTEe5eju2zlt8DMHfUIP85Xm8t/lLERr27GVvBVANjovZIbxh+2+GdPTGt3J7HMLaG2VCrlLgVLSyno7FZkguk0sWjQqQgPHngIIEqw7U0eQovjdCB5mm8f050sHMUXRmAI2Gqyh1X0UXkgRPEmNCBGbqDgtHrXTIRD3jGk4Y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 10:58:13AM -0800, Linus Torvalds wrote:
> On Thu, 20 Nov 2025 at 10:45, Vlastimil Babka <vbabka@suse.cz> wrote:
> >
> > * Fix mempool poisoning order>0 pages with CONFIG_HIGHMEM (Vlastimil Babka)
> 
> I've pulled this, but honestly, CONFIG_HIGHMEM should be considered a
> dying breed, and I'd have been happier with just not adding extra code
> for that thing.

Would you rather see something like this that hides the fact it's
dealing with HIGHMEM?


diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 0091ad1986bf..68b952e68176 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -623,8 +623,10 @@ PAGEFLAG_FALSE(HighMem, highmem)
 /* Does kmap_local_folio() only allow access to one page of the folio? */
 #ifdef CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP
 #define folio_test_partial_kmap(f)	true
+#define PagePartialKmap(p)		true
 #else
 #define folio_test_partial_kmap(f)	folio_test_highmem(f)
+#define PagePartialKmap(p)		PageHighMem(p)
 #endif
 
 #ifdef CONFIG_SWAP
diff --git a/mm/mempool.c b/mm/mempool.c
index 1c38e873e546..b1f5d81d70c6 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -67,11 +67,19 @@ static void check_element(mempool_t *pool, void *element)
 		__check_element(pool, element, kmem_cache_size(pool->pool_data));
 	} else if (pool->free == mempool_free_pages) {
 		/* Mempools backed by page allocator */
-		int order = (int)(long)pool->pool_data;
-		void *addr = kmap_local_page((struct page *)element);
-
-		__check_element(pool, addr, 1UL << (PAGE_SHIFT + order));
-		kunmap_local(addr);
+		size_t len = 1UL << (long)pool->pool_data;
+		do {
+			struct page *page = (struct page *)element;
+			void *addr = kmap_local_page(page);
+			size_t chunk = len;
+
+			if (PagePartialKmap(page) && chunk > PAGE_SIZE)
+				chunk = PAGE_SIZE;
+			__check_element(pool, addr, chunk);
+			kunmap_local(addr);
+			len -= chunk;
+			element += chunk;
+		} while (len > 0);
 	}
 }
 
(not actually tested, but based on memcpy_from_folio())

