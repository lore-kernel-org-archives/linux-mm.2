Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 740BECCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 09:55:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC66D8E0006; Fri,  3 Oct 2025 05:55:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C77688E0001; Fri,  3 Oct 2025 05:55:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B66148E0006; Fri,  3 Oct 2025 05:55:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A49EB8E0001
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 05:55:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3646C13BA95
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:55:26 +0000 (UTC)
X-FDA: 83956345452.16.4ADAD3A
Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	by imf14.hostedemail.com (Postfix) with ESMTP id 26549100006
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:55:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="Y KXl0kV";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=X7eDBLGf;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759485324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6QLmZW6AumgcBgrIJdbQLtM/VKgNyMz7vuwNzepZmkA=;
	b=ymUYXCxGoDt+xh0RFCyv0wV2QCEg6wJyLHqSroyUG2bOecfH7wE7FK4zpbbuBJlTg/cmCP
	FjYOkc+aaOapf67KuQHNwxZ8AA3CTfbI9XnU0XvRH+HQUVNfk1Pry930guBLPK0CkOKQtG
	7dE54tKVH7jQge7bqXQ/LK3E/HQrnhs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759485324; a=rsa-sha256;
	cv=none;
	b=dZN8v+cvciwe3Tckl8X2kSdOVayYUj6S9OboBJWActyHLuWesHMJkF1g2XZTJNJweETRXP
	mK4M68dCHhxdUcuHc2poAMi/7q/vsdiJ/nP1Lu5la13Y7oZ7bw5WgN9ci8LdaTomD3UpVO
	zk6rcOnxROvh7xF4hZHW+sWtBBoeUTY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="Y KXl0kV";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=X7eDBLGf;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 218197A0057;
	Fri,  3 Oct 2025 05:55:23 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 03 Oct 2025 05:55:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1759485322; x=
	1759571722; bh=6QLmZW6AumgcBgrIJdbQLtM/VKgNyMz7vuwNzepZmkA=; b=Y
	KXl0kV91+VoNewLV7v5HgoTDPHVAoHckYmQDIf0qPIxNCwQMXlAOAIdZoWRYIbWN
	FPOZ2bQVWIpO8GduZ3L04vJkc1vNOgfVSxNcb/5I2DC0Jri9ine6Rh6uBuDeqY3n
	XkLJe5CIu282iunfBUjPoB+OAgocYuC07V2KMZKE1UoDb6Cy7MH9TrbFgu+sygrS
	0Bzgg9Koh9bwn2YKw57ZNoRWGoiMvnEwvmzby/G2W+RbEuVNfkkR5YIuL+tj9aTm
	IRKfbb2qu+QMsy4LGo2T6Qu10dmZPwnE59lShc6p9/OtkKfekH2dXKGoiMTbXeAs
	qc+Jdi8f99Dh/I+MaOGyQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1759485322; x=1759571722; bh=6QLmZW6AumgcBgrIJdbQLtM/VKgNyMz7vuw
	NzepZmkA=; b=X7eDBLGfQOfWh7OCV0p4RZZ+EygXRbWNIGgToPYw4xnf1t5EdBZ
	eC2y9gy+KReSA8KQ4Xpdd8ndaORmYVdj4Cxcj9fADj2g47ipR4fGKFMkGItmNsz4
	lx4WdVPkAxDRuzIIwuEzK7flqR+VqeWxJAvHpjb/2+crbPv+ID/ueYZwo2USOShe
	uw+dQ6mEWOYFAKcuYhq1UhXy4LZhp+kHBrYNHykYTscQ5EVHpz31WfGDkJZ+Nt5p
	3w8xPnllHxM1LtndZC+gyZHNRBWQbpImn9v6gnK+Gk3BDnmQhBpTxk3razL/1yhz
	PgC+kgfcKJ8YdN6FZVzjTYTxcvik+ARasLQ==
X-ME-Sender: <xms:ip3faG-ZTfRypcn55_z8Pm3yn235hsk_sLL57yF-5jtycLHymVJg5w>
    <xme:ip3faAxuhcPyuaFzQBJAe9kqPjqaVKNp-DNOWidxFQWbeOmWLRrQzYZ0XiEer0iwx
    R-48PruRCEqfud46hKUJel8KyBjlqr-UoYPorCLKBl1bfYTm3YCWNQ>
X-ME-Received: <xmr:ip3faL7-mG9JtVfkyVsWuKy9X2haiMSZvaJyiw9RDH5lvyowAkbG3UmUrslz2w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdekkeehlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeegfeehleevvdetffeluefftdffledvgfetheegieevtefgfefhieej
    heevkeeigeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlsehshhhuthgvmhho
    vhdrnhgrmhgvpdhnsggprhgtphhtthhopeekpdhmohguvgepshhmthhpohhuthdprhgtph
    htthhopehtohhrvhgrlhgusheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhr
    tghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehmtg
    hgrhhofheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgr
    tghkrdhorhhg
X-ME-Proxy: <xmx:ip3faP8llCKYKAal9vcUBVo-b2SZqfzqkxXFljIE32-Xetm-oGVxRA>
    <xmx:ip3faIoF2I_aodUKXNyPisnmXfWL5hT0YfKHN4o4MeYbhxbXhgoA9A>
    <xmx:ip3faIp1FZCWzD1uF4KqUrYVzUYzk67N34rKeJq6mAMFc_DjeaNVXA>
    <xmx:ip3faD2WM9DYWJuFPACTHaXP8Wis09XozGrCidvVj9JPbBGmbBjpng>
    <xmx:ip3faNleJky3Nn9ED2Ezk6QnfboYPZ2gB-25vM4QRZ2OSXBsvvfUtJkh>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Oct 2025 05:55:21 -0400 (EDT)
Date: Fri, 3 Oct 2025 10:55:19 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: Optimizing small reads
Message-ID: <flg637pjmcnxqpgmsgo5yvikwznak2rl4il2srddcui2564br5@zmpwmxibahw2>
References: <CAHk-=wj00-nGmXEkxY=-=Z_qP6kiGUziSFvxHJ9N-cLWry5zpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wj00-nGmXEkxY=-=Z_qP6kiGUziSFvxHJ9N-cLWry5zpA@mail.gmail.com>
X-Rspamd-Queue-Id: 26549100006
X-Stat-Signature: i1mwdnwsj8sy6oeuok4i1as9wxyxqrah
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759485323-670126
X-HE-Meta: U2FsdGVkX18fd8Z8kUbqe6ekoblr43PisOVxhSDJhBe3Zn4EsQ7eCSAzadqJwUGY8kaXH8pAOvwKq/rrbhTOcGS2iBLfSTWBiA63ruRd4h15q0Y9om+ucFlC7X1xnvfrVsq9CugW0cA50qjfJYsa+jJevUHEQPe10aWU1BMeYZHi7Amlc73Cx9UqfoE4p2xwPljba4TcCTZjNmxNjzJHrX9bUpp7LSl706m556Jf2LwDRarnXweXZhhrE1qKx9+xZuT7+7w1z6KfYP3XtxgDO/RE/PrJtEqO1iWVtcIoHW5TGT6Cntd5Ko78GhgCbBFvsnJsAzLnja9bPYfNMjuf337TkoP91pj2k+pUuZaeegtcW0QPmLjFBVz7gVKbp6KvBnGpHeGWdFT3PJtyMCnn0O0CMkroCmAFumj8c2LqyCGwdpqS+x9EV6kBUSPJlO9aeyFiP7dIEhZ4yMoAyucdvHMWJ9+y+Y562/1V9PEiyd2uZs3pl2fpn740NJ35WxeXI+Lu4kJ575hsITUMkw8xe6/pJQu/KZ3KYfQm619e3HFE+8qMRxcnvktAIpWd36WU7r+m+lnuHmiwSds/UDwx4/7+09l5Xv2gBUiQYDkv/CU7B1qj8EtlWb1m4FWfNsl6FSwhcha4Fy1CjkxBFt3F3i7gbGrUkIZr4ELXyscfOcroqDZRbOUzrnTEpz2AVaRzSSX7LBvGlhOIeYhCTZtQRk3o7ZQTamv4RubaFK0x3Hq8Ou8q3zh2xjr+CDUFfly5GagLP6y1yZRA7rkjFfIdqwbOMwuUd8GK40eaTv96PHI9pDuRk7/aCJJYdPVKSHEYFo2AYN835mVdYy/5GQsMEvb8Rhtt7b7sJh2Cav8FdArwk9EXZyzHB7CeLpmmOZUG3+mL5eP0nnwBvUK5If4rA6OpGIMC7QkC2WxTVFxgwQf8uS+oDku1ftKDWscfeo3Z7uM4N8cNGOAKViKwQ9+
 PjyawlNt
 fMsymJMzrlLs8rgmQJJa7XwsBAy6PL9wvDrBxVXqu/WnBPsAmy02/Wxyp3Q/NbU/RwM8Q5DS3Iobe/JtLPBUw01wQNOk5UesjFUhy+gBgs6YNvT6cTINRpivqItb+Po14bC7a+4xWPkP9bk96wC0RGA8eHaDMy6QCHy1s5ZgqujzbFSO3iGC9hmpNdJUQen09WMMW0I9oQqfJuyUwkF5Y10RzjQeT/vURbzWUyU0tZ1+K7Txds06e9IIJGmQOkmQ0fJXHmH8Gj11UgkkxHsMDCrgO2c2VLsPB3cNKeGU6CfkANN8BL5gttL7/fuDRZbKd+z2CqukjvNB2fMhjUt6ufaNDX5+gHYjBDPzqvBGtE6BMPJrxgZNbRWzOqQl48XnvRvyKp1igjurU7Xzj7Zt+ph5FbGh2K6k6y45ItBfPghLKlLlZiPGwV1KHk2Gwdl2FCvFsOdne0h3aDRVcYmCuDY4FHlDM0x+vI9aUPP8b/kINjxxxm6Fcu8+hAI1iMMtBUcG15Y5cJpj/bag5Z45oeZqvah4hInogIbxVUPTK4Oktb4I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 02, 2025 at 07:18:35PM -0700, Linus Torvalds wrote:
> Willy,
>  I've literally been running this patch in my tree now for 18 months,
> and have never seen any issues. However back when I posted it
> originally, Luis reported that it caused failures on xfstest
> 
>   * generic/095
>   * generic/741
> 
> although I still have no idea how that could happen. I've looked at
> the patch occasionally over the months I've been carrying it, trying
> to figure out how it could possibly matter, and have never figured it
> out.
> 
> I'm not planning on moving it to my mainline tree now either, but I
> decided I might as well at least repost it to see if somebody else has
> any interest or comments on it. The impetus for this patch is
> obviously from your posting back in early 2024 about some real user
> that did a lot of really small reads. It still sounds like a very odd
> load to me, but apparently there was a good real-life reason for it.
> 
> I still think this patch actually looks quite nice - which surprised
> me when I wrote it originally. I started out writing it as a "let's
> see what this hacky thing results in", but it didn't turn out very
> hacky at all.
> 
> And it looks ridiculously good on some strange small-read benchmarks,
> although I say that purely from memory, since I've long since lost the
> code that tested this. Now it's been "tested" purely by virtue of
> basically being something I've been running on my own machine for a
> long time.
> 
> Anyway, feel free to ignore it. I can keep carrying this patch in my
> local tree forever or until it actually causes more conflicts than I
> feel comfortable keeping around. But so far in the last 18+ months it
> has never caused any real pain (I have my own tree that contains a few
> random patches for other reasons anyway, although lately this has
> actually been the biggest of that little lot).
> 
>              Linus


From bf11d657e1f9a010ae0253feb27c2471b897d25d Mon Sep 17 00:00:00 2001
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 26 Feb 2024 15:18:44 -0800
Subject: [PATCH] mm/filemap: do small reads in RCU-mode read without refcounts

Hackety hack hack concept from report by Willy.

Mommy, I'm scared.

Link: https://lore.kernel.org/all/Zduto30LUEqIHg4h@casper.infradead.org/
Not-yet-signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 mm/filemap.c | 137 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 127 insertions(+), 10 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index a52dd38d2b4a..f15bc1108585 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2677,6 +2677,96 @@ static void filemap_end_dropbehind_read(struct folio *folio)
 	}
 }
 
+/*
+ * I can't be bothered to care about HIGHMEM for the fast read case
+ */
+#ifdef CONFIG_HIGHMEM
+#define filemap_fast_read(mapping, pos, buffer, size) 0
+#else
+
+/*
+ * Called under RCU with size limited to the file size and one page
+ */
+static inline unsigned long filemap_folio_copy_rcu(struct address_space *mapping, loff_t pos, char *buffer, size_t size)
+{
+	struct inode *inode;
+	loff_t file_size;
+	XA_STATE(xas, &mapping->i_pages, pos >> PAGE_SHIFT);
+	struct folio *folio;
+	size_t offset;
+
+	/* Limit it to the file size */
+	inode = mapping->host;
+	file_size = i_size_read(inode);
+	if (unlikely(pos >= file_size))
+		return 0;
+	if (size > file_size - pos)
+		size = file_size - pos;
+
+	xas_reset(&xas);
+	folio = xas_load(&xas);
+	if (xas_retry(&xas, folio))
+		return 0;
+
+	if (!folio || xa_is_value(folio))
+		return 0;
+
+	if (!folio_test_uptodate(folio))
+		return 0;
+
+	/* No fast-case if we are supposed to start readahead */
+	if (folio_test_readahead(folio))
+		return 0;
+	/* .. or mark it accessed */
+	if (!folio_test_referenced(folio))
+		return 0;
+
+	/* Do the data copy */
+	offset = pos & (folio_size(folio) - 1);
+	memcpy(buffer, folio_address(folio) + offset, size);

So, you intentionally bypassing refcount bump on the folio which is part
of the usual page cache lookup protocol.

But without the pin, what prevents the folio from being freed and
reallocated in the same spot under you? Do we wait for a grace period
somewhere in this reallocation cycle? I don't see it.

memcpy() could catch the folio in the middle of zeroing on reallocation,
so the data would not be consistent either.

+
+	/*
+	 * After we've copied the data from the folio,
+	 * do some final sanity checks.
+	 */
+	smp_rmb();
+
+	if (unlikely(folio != xas_reload(&xas)))
+		return 0;
+
+	/*
+	 * This is just a heuristic: somebody could still truncate and then
+	 * write to extend it to the same size..
+	 */
+	if (file_size != inode->i_size)
+		return 0;
+
+	return size;
+}
+
+/*
+ * Iff we can complete the read completely in one atomic go under RCU,
+ * do so here. Otherwise return 0 (no partial reads, please - this is
+ * purely for the trivial fast case).
+ */
+static inline unsigned long filemap_fast_read(struct address_space *mapping, loff_t pos, char *buffer, size_t size)
+{
+	unsigned long pgoff;
+
+	/* Don't even try for page-crossers */
+	pgoff = pos & ~PAGE_MASK;
+	if (pgoff + size > PAGE_SIZE)
+		return 0;
+
+	/* Let's see if we can just do the read under RCU */
+	rcu_read_lock();
+	size = filemap_folio_copy_rcu(mapping, pos, buffer, size);
+	rcu_read_unlock();
+
+	return size;
+}
+#endif /* !HIGHMEM */
+
 /**
  * filemap_read - Read data from the page cache.
  * @iocb: The iocb to read.
@@ -2697,7 +2787,10 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 	struct file_ra_state *ra = &filp->f_ra;
 	struct address_space *mapping = filp->f_mapping;
 	struct inode *inode = mapping->host;
-	struct folio_batch fbatch;
+	union {
+		struct folio_batch fbatch;
+		__DECLARE_FLEX_ARRAY(char, buffer);
+	} area __uninitialized;
 	int i, error = 0;
 	bool writably_mapped;
 	loff_t isize, end_offset;
@@ -2711,7 +2804,31 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 		return 0;
 
 	iov_iter_truncate(iter, inode->i_sb->s_maxbytes - iocb->ki_pos);
-	folio_batch_init(&fbatch);
+
+	/*
+	 * Try a quick lockless read into the 'area' union. Note that
+	 * this union is intentionally marked "__uninitialized", because
+	 * any compiler initialization would be pointless since this
+	 * can fill it will garbage.
+	 */
+	if (iov_iter_count(iter) <= sizeof(area)) {
+		unsigned long count = iov_iter_count(iter);
+
+		count = filemap_fast_read(mapping, iocb->ki_pos, area.buffer, count);
+		if (count) {
+			size_t copied = copy_to_iter(area.buffer, count, iter);
+			if (unlikely(!copied))
+				return already_read ? already_read : -EFAULT;
+			ra->prev_pos = iocb->ki_pos += copied;
+			file_accessed(filp);
+			return copied + already_read;
+		}
+	}
+
+	/*
+	 * This actually properly initializes the fbatch for the slow case
+	 */
+	folio_batch_init(&area.fbatch);
 
 	do {
 		cond_resched();
@@ -2727,7 +2844,7 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 		if (unlikely(iocb->ki_pos >= i_size_read(inode)))
 			break;
 
-		error = filemap_get_pages(iocb, iter->count, &fbatch, false);
+		error = filemap_get_pages(iocb, iter->count, &area.fbatch, false);
 		if (error < 0)
 			break;
 
@@ -2755,11 +2872,11 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 		 * mark it as accessed the first time.
 		 */
 		if (!pos_same_folio(iocb->ki_pos, last_pos - 1,
-				    fbatch.folios[0]))
-			folio_mark_accessed(fbatch.folios[0]);
+				    area.fbatch.folios[0]))
+			folio_mark_accessed(area.fbatch.folios[0]);
 
-		for (i = 0; i < folio_batch_count(&fbatch); i++) {
-			struct folio *folio = fbatch.folios[i];
+		for (i = 0; i < folio_batch_count(&area.fbatch); i++) {
+			struct folio *folio = area.fbatch.folios[i];
 			size_t fsize = folio_size(folio);
 			size_t offset = iocb->ki_pos & (fsize - 1);
 			size_t bytes = min_t(loff_t, end_offset - iocb->ki_pos,
@@ -2790,13 +2907,13 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 			}
 		}
 put_folios:
-		for (i = 0; i < folio_batch_count(&fbatch); i++) {
-			struct folio *folio = fbatch.folios[i];
+		for (i = 0; i < folio_batch_count(&area.fbatch); i++) {
+			struct folio *folio = area.fbatch.folios[i];
 
 			filemap_end_dropbehind_read(folio);
 			folio_put(folio);
 		}
-		folio_batch_init(&fbatch);
+		folio_batch_init(&area.fbatch);
 	} while (iov_iter_count(iter) && iocb->ki_pos < isize && !error);
 
 	file_accessed(filp);
-- 
2.51.0.419.gf70362ddf4


-- 
  Kiryl Shutsemau / Kirill A. Shutemov

