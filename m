Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C304A1061B18
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 22:20:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 057BE6B008C; Mon, 30 Mar 2026 18:20:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0085C6B0095; Mon, 30 Mar 2026 18:20:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5FE96B0096; Mon, 30 Mar 2026 18:20:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D4AF76B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 18:20:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7EC74BC046
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 22:20:32 +0000 (UTC)
X-FDA: 84604149504.04.CE65E2D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id AD25C14000A
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 22:20:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GZPwof4m;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GZPwof4m;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774909230; a=rsa-sha256;
	cv=none;
	b=4TeoDK3Syp5oBQs3irkWeZndlB/VGUusYPbbvR7rHJMyExU1douCvdOuHn0/4mLMtvX9DM
	PhvvRk0fkrHTjGuKC14mg4br0X1PEjAvdMQdxXXJAphvbEauReRnqaKQl2fXsuf+ITIIyd
	Ez6Xli7ds89u72K3wwGeygfMea5yKRQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774909230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ckEbP66ZVflBFDtVuH4wAApfQrdF5dTS8fSPXCgrRsg=;
	b=ZUBI1WQllQ0TRA/LZz4QhSOOPPQWZZGHyezVOTcav6CpxTVUY6CHmF6FD4jjYZPGUuHKQX
	pL8N75gzBAn2Xqs0thp5f1Bqn3oNp+bWk0pssTBfledDHTpmoOuhXmb9pAGgM4fAxfpqwi
	q3EY/+LuqkXw8L0W1n8l6UJEvYFv8hg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BB09D44569;
	Mon, 30 Mar 2026 22:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF28C2BCB0;
	Mon, 30 Mar 2026 22:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774909229;
	bh=O38+3wGB1K/Bcl20TaXMCgTluv50pmECdZ6mPiI6auY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=GZPwof4muIY2wI3sdUX5XsgmMn1DFFsgIwqOMHbDbWxzBJ3VhrEv8sd+AJFQvKU3r
	 8UykO9lDFsInYxWReaeoSXPjQZZiJz+kiHsXRO3j3pyy1IzN3WQgC1kNCfny9L4EyI
	 qLM16d1ahd6z0nCdjYujxAMTKHeya7gJO/7iffIY=
Date: Mon, 30 Mar 2026 15:20:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Carlier <devnexen@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Kairui Song <kasong@tencent.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat
 Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song
 <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, NeilBrown
 <neil@brown.name>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] mm/page_io: fix PSWPIN undercount for large folios
 in sio_read_complete()
Message-Id: <20260330152028.fa5a9c8adf19c7904c9c5b63@linux-foundation.org>
In-Reply-To: <20260330071229.14614-1-devnexen@gmail.com>
References: <20260330071229.14614-1-devnexen@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AD25C14000A
X-Stat-Signature: 941juto9x6d1qcc1msi6g77487kuynw8
X-Rspam-User: 
X-HE-Tag: 1774909230-244665
X-HE-Meta: U2FsdGVkX1+RsPKqW9wJSFrppkE9pUlDI5leHpqESWECOvI/jA+8uaFTlDqS5vtTDXJkP2i94kYhfKEEJhbP3qgWMVvdCWHRkKn+xDi4rL8UaxzDhxC3O6k8TtJfcrVXE3rQm7tUSYDtZ3t1jGxqkJRarqrwvCfZfrjykAfClnfXOmajGC/ah/HLaZXW3gPC2WS7TtEpuuq6Zm/H5pGHDHjY8/77z8zv3oDYgjGOEoHzKhZBErP9nak9aeLJZvyLHKv8ZBFGWYuRLZIDrpPoANwRj/c1BCJwNwQQQ6BnqxVEhi+SYnpCQg36WGfsirmD0/xKQ/r5lvlDjoitJdEiKVeBY7ni5ZYw0soBpRrw49MTp2dy7cFmyB8pikCuhTd1LzZzcEK6GuIj714LsbB+NsCna5IrKivsvxgcu+/Kfp1810FRs8vkTFxfITrARZ0rCbVRh6RykfuNijVkoa1GFV4+6+QUe+NuZP9iIpoUg4QsElhLXbT/I+X6T31FKzhooflihIr0i8aJLQboTC9Z/k7+C/wfV2Uv+NgY4BOh3bgxYFVRtEXmRld/8JXwmFhXt6ck0FF2GUnWBz0g/gWmHEHfu6xX+CkxblsGYzfrBttomVJiS9pyD1gycPIShdJH1MiNiRjB+AL5M3Gu4o4F3KgtG/efk+Cnut69iK3lOG6YV5Ygtuxssa1oMjQi2G/5SmiwfK2dm6dwhUPZb/jVpmLAi3zhynXgzldrWXKh/QSWoxDySYVyTWug/B1QddfgKhPcL3YGh6NfIdXFm5+lnGglZNtR0T/NlEQ8dtT9MTQFOL44rZXh/r2Sp8UvOp5jKAnyZtO4VXTqpRG3uCV6kfb09T5f+FrcoP9Cv8zKJwZIddPHSdal/GG/fczIPVoSGam8jCLT+odYyHzm/JpeAXky4crSkLT6IB08kJ7G9l0uXd1qvOkCGtWkyb20MldigTWTsCVCavKBdFMp5K9
 UreL11BX
 osv5hDkAM+TLV9f4JxPrEnjPoY9FEdXK7VArK2o37KJ8q05nkW7hbyOVAK2JvahrjeKlALxd4dnJNf8ZTbdK403CtLY5P66Le3Zl0rAGZWIjJIQp7qFHx0JPRuRbNAku1V+wGrvtqlPbohZCc0MAFOIn96HwPYN2UUghZbj0Qf8QS8hAaz+W6hG2PLkfScmYPViAS3Hjtoi8T/+fkqxH3P6yvyXR8FnUEmur/z2KJyu9lUdcT9vSnr4ZWPL4EZ3al7zV2IaICqV5yyuRzBXcJD9GBa1Lti1AvX0Oj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 30 Mar 2026 08:12:29 +0100 David Carlier <devnexen@gmail.com> wrote:

> sio_read_complete() uses sio->pages to account global PSWPIN vm events,
> but sio->pages tracks the number of bvec entries (folios), not base
> pages. For large folios this undercounts compared to the per-memcg path
> which correctly uses folio_nr_pages(), and compared to the bdev read
> paths which also use folio_nr_pages().
> 
> Use sio->len >> PAGE_SHIFT instead, which gives the correct base page
> count since sio->len is accumulated via folio_size(folio).

Thanks.  What are the userspace-visible runtime effects of the bug? 
Just /proc/vmstat wrongness?

Seems pretty minor, and it's been in there for several years.  But I
guess I'll slip a cc:stable in there, let it trickle back at a later
time.

> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -497,7 +497,7 @@ static void sio_read_complete(struct kiocb *iocb, long ret)
>  			folio_mark_uptodate(folio);
>  			folio_unlock(folio);
>  		}
> -		count_vm_events(PSWPIN, sio->pages);
> +		count_vm_events(PSWPIN, sio->len >> PAGE_SHIFT);
>  	} else {
>  		for (p = 0; p < sio->pages; p++) {
>  			struct folio *folio = page_folio(sio->bvec[p].bv_page);
> -- 
> 2.53.0
> 

