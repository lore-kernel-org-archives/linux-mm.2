Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2944C5AD2B
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 01:59:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CAA96B0088; Fri,  7 Aug 2026 21:59:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37C796B008A; Fri,  7 Aug 2026 21:59:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2477A6B008C; Fri,  7 Aug 2026 21:59:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B1DB6B0088
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:59:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7B1AC1C08E1
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 01:59:30 +0000 (UTC)
X-FDA: 85076445300.01.E926193
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id CAF3140011
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 01:59:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=AArNvhku;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf17.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786154369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SIvIwzkqmZhuegbtm5Nq+eVaw1LjimqMZHDkKzPKrJY=;
	b=q+B/HE3NiILfTzsCsiW1pvtyIzQe3xlqGYOZbU6EoObglBJ03IrwkTaSakGWRUS5nz4vS5
	IHfg+lycU92p7TqGJUMejZUAi9phYU1H6FI2rrPCB2WmybeIQmPP7efJqvtvMp/6apXVwL
	9lpqH8ev+3wgQ6aD8WCWRZovN7Mg380=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=AArNvhku;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf17.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786154369;
	b=L2XncblkWylAOwlLGHse/Nbv7zBw5ykJQr7ukANjm87ZAjPhBwW6esPiaJQSGui+kMf2wl
	qfhxU11k/Ard/tAdZ9RlyagNJ6Q07C4tS5eHIMQdXl18bqTR0Bt1kYiAGfUanwYwfe5RK/
	FKk0qI2qFHq4Ynz+/yHUDZTvdeqX6KA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SIvIwzkqmZhuegbtm5Nq+eVaw1LjimqMZHDkKzPKrJY=; b=AArNvhkuNQ6BtLLzEpEqmk9isg
	K1aOpr64+HpKUDqgQ7Ba0T3G+e5fGIsJkNl9E57wMi6OodQnOP6IGMep8uZl8X4oyTQlBOxLvRVM7
	ruush9ENJSVvpGRibHuLUYGEHyaxb0BaOenh1rQk0ESgqG978bhKDHMTECuEzfn8oUR1NVl07KA0Z
	vgYSKxlkLqAx9aAiLfIBHKq7QafX2BxXXWHu9kxcfpN5cVx5UxEgRXatsV4ivVwk6eU6V/OrfE0lW
	zijJoY8pus3azxb+5HR/GSCInWd8PI93iP3hrC8Ay0yDhxu+n3jXp+pdjWutyL9y+2GZ3QlTZfVjP
	XKXnuMog==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wsPWd-0000000DGXR-2Os8;
	Fri, 07 Aug 2026 18:42:35 +0000
Date: Fri, 7 Aug 2026 19:42:35 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tal Zussman <tz2294@columbia.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Christoph Hellwig <hch@lst.de>,
	Yosry Ahmed <yosry@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] mm/page_io: convert write completion handlers to
 folios
Message-ID: <anYnG1nkAvfK3Lhb@casper.infradead.org>
References: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
 <20260806-b4-page_io-folios-v1-1-0899bac3b826@columbia.edu>
 <anYMrST8NQ2ZT9gX@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anYMrST8NQ2ZT9gX@cmpxchg.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CAF3140011
X-Stat-Signature: 6nt7u9taqam8xk78utmdqcor5xsk9k4a
X-Rspam-User: 
X-HE-Tag: 1786154366-844348
X-HE-Meta: U2FsdGVkX1+dlEi3ayzc7ns4ZJoMzCAbwraHkKwe3awIPm+re1nCXLGZOgKBnHv1qyLnfzSHAbt0VWwfDMXN2c56R/73/vbrKJfYxEoTCFDGQ+Be4P+6tsFzQWtku24mR18+K4vph96AXcM5tSflVvWUkUWbmdaz9qv2dG0wS0r2olrn0S5ERRljIY+pMFJY5/go283u1ax3dZW2HgEkb/GAXeJJtHWNiXiqP8O8NPln5mvb6LTLQBuInUC2FdSfzfciaBxyylefQMl2bkLhSsN5S+DIOdusHQvjalFa10OgANi0Wp9sCRUYSqgswCCor8kov0Yg2iNftdSGp8XH0ISx1vbuA7V45WLYW2bkVL89x1rbGkSh7lb6Yq2k3TOKxJJc6oajLI5jSHetoE5XHKO+H/AxYBMHrB8maYocmaNeX+FE8tLf2vBsJpgKmVbQHwhZNMb+vMejXKqoinCEu37kAbCVHK3ZjaUYkT2M1ZRujMOKLekkH4qS+gWmZjp6wBkTT26ilAKzSiKIGzta7Ukhn3plGA870D1bSsEc+8TG/nOyKu3dDgdiv42InzBhkT72eE+8GhpuLXLvpXGBkyPFJ2shGf0/giJNnFHHTUqlLcOy8L2dBKYd5jZ5VSBY8Dftt2LXQUx1eFdYK8KZbjYmYXrzcvu3FcLwWkdq13lGWg6w3oKFrlWhtKxUP9WuOfnDWFvw/14KCwOIRl6eXOi8ZOvbz1ajI0ui202jmbmYUj3sCU3HPj1W6qfrkKChKGYHyLjqitI6VkjAXui91TS6enFuuvN9PZQXFGdwTfT+GOLo9cWTVFzX2U5A21Q9T/AG9x0AbDueLzNIxj2sa7BKT8iNuKdLv5onC7xA1D/CnY2+gTc21chucatWA6FDu9lEHLHR5Yr4cb5n6g+mWti9EnhlP39rXjvBxpzRT28fANREsrVXKESkIeI92sHWfFdw5jO1v3h5tGzP8iN
 00Cj/2/Z
 4aWrAHzcqdJ5k5t2/hIx1GvkZdZHeSPOWJRel7JkYD4vl0z+6mAckNmFFeH8DRSlU/qpUl1b08HcnKmed6xHe0xijmny0dqBJ8Fvwntxlvxl5nD7gJn+2LiSMnk6v7zvxYN0tNrd3AzX0biEUftJ3oCMOADJ1RIq362WIzjiHU7PXMGuF5iJbTc730BIPCzr/qdop0+RKmbp/Yb2kc02YXksq+SCfeByA3ExS7fl42oey3AurxeVJBWu9FRUJIyhcMvsQOvyrMbukNSZadfDdHMVb88hcnXMHLWk0EZCmqm9CzUAYWKBZEvgcdXZ/57NMnjjof4SYQR166rrgAGl9+zI2qP/0g6bmIjUYIT1WsmnlJ23RuB96UYReH70e8v0CgAGu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 12:49:49PM -0400, Johannes Weiner wrote:
> On Thu, Aug 06, 2026 at 06:55:33PM -0400, Tal Zussman wrote:
> > Convert swap_write_end() and swap_fs_write_complete() to operate on
> > folios directly instead of going through the folio-compat page APIs.
> > This removes calls to end_page_writeback() and set_page_dirty(), and the
> > last caller of ClearPageReclaim(), saving two calls to compound_head()
> > per folio on the write error path.
> > 
> > Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> 
> Also the last end_page_writeback() user in mm/ :) Nice.

And some uses of bv_page ;-)  This is just good stuff all around.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

