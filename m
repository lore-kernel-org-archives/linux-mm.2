Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E669CCFA05
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 05:00:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6624F8E000C; Sat,  8 Nov 2025 00:00:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 612F28E0003; Sat,  8 Nov 2025 00:00:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 528748E000C; Sat,  8 Nov 2025 00:00:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3661A8E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 00:00:38 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9B7511406B2
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 05:00:37 +0000 (UTC)
X-FDA: 84086239314.28.7D4D44D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id D7FC140008
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 05:00:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=c9BGTl1I;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762578036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Uicbi0GzrwSMJpZH2t7k0frWbxeMbuqQjQce1tcheY=;
	b=d3zq+YTi7CFqCmjiqQ88HdiwXAxU/FmvAnF6/lMeHdwrLmhRms5lZ7V9aY5XrHgMM/s5Hj
	xeqefeZQYyyCSEgyWhJ6vPNPspiuw2YkGMhnt75CK9Oi9CChLdB3RvNtYJfUxUC+5Aqqfs
	mSmF0NMKQTPGsQyUOCshNizjIxaNG+A=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=c9BGTl1I;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762578036; a=rsa-sha256;
	cv=none;
	b=g6kQj9iLDC3TzAGkL0ike1ohWOazN61rmJaQuDAf+XLndO/qB/NX32wJr+sUabVM56qN0s
	CKdNIoFdRdnNyy6iS7MSCGqThueJenxxpag8K+FBpun8i9MBeMG00SL3xHhUQIAmSk/4Mk
	YOl2n64basBL5cHjwgWtVFFlgeF5swI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3Uicbi0GzrwSMJpZH2t7k0frWbxeMbuqQjQce1tcheY=; b=c9BGTl1IhpGMc9TG9YorRjI7Wa
	U+f+thBN5xTPat81KAWaLN3ryZjJvTB5eRqJfXQSinjl4FUTrIJ69r41RohLuxdiHYbiOm96L0t4c
	E2Aec+1dECFxXC6QWT1toOEr/cDVt/iAkzvZsrDdunN/b3D6c2qOl/wakEfOeYKmYfHW8h5xeOlPB
	dzbuzv7hYTAHA4sArHbeF7Om5WeJ/diVhKJACE6yydWpzfN8v/4Fg0pmaQrETTc4Fx33+DSE132X9
	Zqd6Jv2/0oxcjmBAbuC4JOYOMhGEH4Gs/n6QZ4RjLg7+HLl0hieST60DtGmxHg6vurTQQLpAYQVlm
	Cvfs80ow==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vHb3s-00000009gXx-3I0G;
	Sat, 08 Nov 2025 05:00:28 +0000
Date: Sat, 8 Nov 2025 05:00:28 +0000
From: Matthew Wilcox <willy@infradead.org>
To: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>
Cc: Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 10/10] mm: Use folio_next_pos()
Message-ID: <aQ7ObHvd8FXb8Taz@casper.infradead.org>
References: <20251024170822.1427218-1-willy@infradead.org>
 <20251024170822.1427218-11-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251024170822.1427218-11-willy@infradead.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D7FC140008
X-Stat-Signature: xi38ih6iyr7y55qdebzi4hnbti7nnern
X-Rspam-User: 
X-HE-Tag: 1762578034-548328
X-HE-Meta: U2FsdGVkX1/tiYd/QMMg+Z5ER76JZ8VfaYl6I17YcH+/mIwYyRcBdsUzR+/6tBCBvjQ1ppZYV1YqvLRwfDzedqRSP+0fgOHpaiaAKXBYXJmYNxbj1M6D0fST4j+5MWr80QuEfMDT7hQdFDolnUi9e4asp16Z8P9X2yZVitUwtHhdlrCbXIS+R+nKz6+wCSwAZwdHJi9iKrXNY635D3J40gCcOeQSWjyfIhmbRdUItDLhNMVX10tflbVcqLnPGHhHtPZeyW5rFVqeY0csnESS36xskk8Qw1f/VAv2ulgm6eeWnErlKxPKGlQqAHzTHVcu71GhXamaEUA2fUKAL4vP7p+X3gxZgeBcYXBfoUzzF5lMroXNNXTwxJDbkjDbFeeieZjcJVxKNgnsvW+pvzlQA+zHZ8ke0Fa6ukuV1BHspjSHHBsxM73Zq1rEZb278uWMy7BJYKwUUwXSDfSEK78HRZSa27FN2fG53yeKIP6WwBq9UHZDqkb9oaL4rBQGaqz+GMMzx+rQNFP1wTbIOevGRI5SLRjRx4uZfjtnebWLuxpvTZy2x0PgglWc8HGQMWTvNnzvmyQQ4qjJebmINqS+NH+NpMGZ0hB/TCkjczE6EErtDZXNFE3v/hES44wCvjs7G+yYDJBhjg09h1j/wguIExI6WPIQiOlQmkTtL74gZ25KjLvZlMTz0kDCGDhO9BhitteNnbQFm8FCirV4xnJMEXVCQ2FryGJOIso1wNgS7tlKqwfPlvrC1WmAgwFRSpgHX21sLJZZj1iuyWwOliW5AKjB+UrnHfLDzMkcPI3R1Xmm1LPVVlyu73ydboUZ11u/+NdDDhKVnsBRCwdyxP7JedUWHe8t8KEs83s71v6BwyYqlmbngcmRPtxHd3C3bU0W/WRYYAhguTxDl8PbAwOcZFkwvEaGgbIy6xhU9SWbpWUVIz5jZTfZG4Vf7TkZDrV5YKH0PWkxhfpQgaf+nRX
 kYy+KQZK
 4y5sPzr3PExX3RFB1c5TOdLmkQZbP8A2r12Lq7YdyyOx7/U7cqUIbv9w85sYIHPTqHbc1Oa+aVMgtEVfJFiddWMYps+JHLrjTVRI0owtkPAKvvXsUvsotadKrsNa2MF4yWsfPGSLCjtKA61uuaLkYZ54Rq4omtJYvfY/lPL4cILhWRwPNNw8DvJgGoFhEJHJh/vElqg9Y69R593fk2fpPewmKfXwZuE6xLxr71X/OjBR0xdKDOPZvYwhyA/GC7O+O7vLIc1LGAAR22691oOB00L0QPh/WvqzQ3lCGvpA45rgdP9rpO7KsF0TeQHjVjMftddZEzWSiiXcHx6nxdBuW1ERdW5YIbh+WscjbBgZgDwhBf5hUCkxiTGVip1OJaaIgmG9L
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 06:08:18PM +0100, Matthew Wilcox (Oracle) wrote:
> +++ b/mm/truncate.c
> @@ -387,7 +387,7 @@ void truncate_inode_pages_range(struct address_space *mapping,
>  	same_folio = (lstart >> PAGE_SHIFT) == (lend >> PAGE_SHIFT);
>  	folio = __filemap_get_folio(mapping, lstart >> PAGE_SHIFT, FGP_LOCK, 0);
>  	if (!IS_ERR(folio)) {
> -		same_folio = lend < folio_pos(folio) + folio_size(folio);
> +		same_folio = lend < folio_next_pos(folio);

This causes an intermittent failure with XFS.  Two reports here:
https://lore.kernel.org/linux-xfs/aQohjfEFmU8lef6M@casper.infradead.org/

This is a fun one.  The "fix" I'm running with right now is:

-               same_folio = lend < folio_next_pos(folio);
+               same_folio = lend < (u64)folio_next_pos(folio);

folio_pos() and folio_next_pos() return an loff_t.  folio_size() returns
a size_t.  So folio_pos() + folio_size() is unsigned (by the usual C
promotion rules).  Before this patch, this was an unsigned comparison
against lend, and with the patch it's now a signed comparison.  Since
lend can be -1 (to mean 'end of file'), same_folio will now be 'true'
when it used to be 'false'.

Funnily, on 32-bit systems, size_t is u32 and loff_t is s64, so their
addition is also s64.  That means this has been wrong on 32-bit systems
for ... a while.  And nobody noticed, so I guess nobody's testing 32-bit
all that hard.

Anyway, what's the *right* way to fix this?  Cast to (unsigned long
long)?  There's an ssize_t, but I really want the opposite, a uloff_t.

(now i'm going to go back through all the other patches in this series
and see if I've made the same mistake anywhere else)

