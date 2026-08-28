Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F798C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 12:42:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 314286B008C; Fri, 28 Aug 2026 08:42:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2965D6B0092; Fri, 28 Aug 2026 08:42:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15DDF6B0095; Fri, 28 Aug 2026 08:42:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E49E46B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 08:42:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7ED511A0349
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 12:42:03 +0000 (UTC)
X-FDA: 85150640526.05.4601F5B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0AB59120004
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 12:42:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Pi3v2UDn;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf29.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787920922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fOOErk9kx1LUUsIH+ihqTAkp4s+n4NYBXTagYvHGXok=;
	b=M+4dwRmp4zgjh253EJJguW9LaxZ/FdN91knT04SbEaiU+DSH8hXQIfKUXErBVxracsHHMe
	a+pPprWBhlCG/M798mtZBI0gEz5oSq27uJNTpE6iTi773SpKpNmi4afzgAf2rvGF/5Ng8I
	hnGrwXMFNNRExxE1XCl89u96/LhiRcs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Pi3v2UDn;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf29.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787920922;
	b=LNi78hoTO44It358zqYDij/6GPSlSeuojtX/ckznb6BHU4hG2uumJJNGPeZOYL5hQk7mzZ
	HkmvjE+QM1AXqhjO9w8yru6Qo9gfOGOCRIwlnvyIDTOp6vceSIOhgz4lOEnc/+PoSM6dmn
	MMF6XOZoy/HY0VOMj5NROKmyFWDrclQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fOOErk9kx1LUUsIH+ihqTAkp4s+n4NYBXTagYvHGXok=; b=Pi3v2UDn5tSqmbtKPiAIqYtln1
	e3ippwoYEwrMHwU8+8U7n6fMm7hPZvXt5XcS8l96v5TPNPp8qAnJEnyFzd4RsAf99V/EL+YVDmfrR
	lRoL5MfJqEWmyn2MRf5W18/93DaKy1xmUjxD15xTREg/ddJ78a/gUK/JDkDuCeCSLVqpe5iSBrf0f
	MsNSN3RlBRU7cYYNaq5RM47oT5s317cFo9TZak9nPBi5n4M47+Hj9Kn8w9y6uiyKvbCpqoM/ejXTN
	ZLFKqB0EpP7NvgCQ1zIxmMbltUfyIHS5uuzkrJCmAT0vjeV7f9FBGxIHZOls9oco2hSrnuvooSyTj
	hbZACARg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wzvu2-0000000Ehny-3KzH;
	Fri, 28 Aug 2026 12:41:50 +0000
Date: Fri, 28 Aug 2026 13:41:50 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Yuan-Hao Hsu <aa9736195201@gmail.com>,
	Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
	David Hildenbrand <david@kernel.org>, Linux MM <linux-mm@kvack.org>,
	Christian Brauner <brauner@kernel.org>,
	"zhangyi (F)" <yi.zhang@huawei.com>, tujinjiang@huawe.com
Subject: Re: [PATCH] ovl: implement ->get_unmapped_area()
Message-ID: <apGCDtf-gE1osJqE@casper.infradead.org>
References: <20260827170718.497-1-aa9736195201@gmail.com>
 <CAOQ4uxjxDV0U9yrDA_StN968P_6cpjRAN2mBCx1c_RYd7BF4Og@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjxDV0U9yrDA_StN968P_6cpjRAN2mBCx1c_RYd7BF4Og@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: jn41jiuo5yhjp8pf8m7z93fecahasw4a
X-Rspamd-Queue-Id: 0AB59120004
X-HE-Tag: 1787920920-238768
X-HE-Meta: U2FsdGVkX19OKh/s5v9CWRceRVLU43+r1UMYgE+OVoQGZXs9nkMxfLazehHWbn6T9DCCxWlwXwT6a7XpVkkmghAk58ZBDKueKeO4vFOZKHP8HafdFO4V1usZ9k0nAb3siwmz6Cm0d/1kQ/zVdyhx/WzdPSAyjzgzRURD7YUPN9TkERiMipDOT3YOMZYZ/6auSecgY1RVPNRf+q9YbHZ8gGRErb7DxpNgvhBbcD1/5D7a9NpXiJNdGvHr+EitAiXYOi+jBt2yC/aSmaFlsazhF2Gfd+ghQtmOvC7XBgZURJrIbQ+dDdZFQh7l38x35KisUdsJJbh5ngFDy9w82WB8cMm27mCg+7nWZVSD+4N+WSREkrvhcJXWYcQUSwnPFSy4IWs9gIWjtKyfEdqvRkDsJig7+GW4vvAf49zHX0R4a4z/aEF3HzqBP3TW1CW24TU/OfZDZ8JnX44iuscn59FcuCsNQfyGVgtHyc2F282Fze3FzZg3Ukg/YO5QmAqzNxnoHPiSZdMBWUJnh0a9LkOY0RYk3iM9P5HVcCu6rUh0sSEA+4R/2oqji2Pbq+TQV1KEgaROLLANvZsnm0msaW9sdAaZrB7q64BLd6qeeTazeNgftNHYLKsOoQS9Kp/cWvGCLMx4BnoPt5Eus1cr0IWoOmbRaIzxx2V835P2x8E9ZQQvaTx5VtdEh8K5GiWLUZSEyyx21V5DyA6KaKu/U5NKjqAphPWUDm6F4GKD/v+f79J4PFYw6/4GjllHN7dSC850oi5bMucloR547XXp1Tt3XSrFfGiu4wp7W/PdBNjRRDch0qcM/1UOqa9J4Ig+gXUniGJoUMyr3aOIqKlmg8pHxG8R2Gp2utfk2CXI1lAbSuom25e/0CH7YwfGxaT5u8/BpULsGvcC3HIqB+Iz0Vhh/b05noAjhVN3K0QjcIp3UE6fUQ+fNMQyNshdSE4k31w3jSVLrtktLxKeX/a6UvP
 j/cHweWM
 G3VrIj1NCD46fzOZ40o68DLZRjEFEnhDvDELRR6t6Sg2Qo+icT5E57Wd1m0Ps1iNF6ppRsnI1r1gNxn9OzE9hZJLtCiT69NPJC8LRBTXOCLfj7xVthpi3wqAwDvTCN/T/w02aZw9P97COkteFElTmp4iSL/EbEhjSfGwu1gSKZknvQwo52gF7R8G4PNDIcFT57C2ZOjRqyzPtP2Tk03/cGCWaCYg1lTtKrE/LXs6oca8x+xWQV08sP0mrMcB7r/3bcK2jfWsGvvFjaQRE4ebKEGvcx+Pf0S0zkDq1J9xpmUHROR9oT/cVwu/efEOYdMyT9f6niteZxXGL9mPbSnEj8Wbhvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 02:23:11PM +0200, Amir Goldstein wrote:
> Since mmap is going through backing_file_mmap() probably a good idea to
> pass this method through a backing_file helper as well.
> 
> But more importantly, adding MM people to this patch review, mainly the ones
> that participated in the discussion over patch to fix similar issues
> in 2024 [1].
> Most of the concerns in that patch seem to have been addressed (?)
> 
> [1] https://lore.kernel.org/linux-unionfs/20241205143038.3260233-1-tujinjiang@huawei.com/

No, not at all.  All this patch needs to be is:

+++ b/fs/overlayfs/file.c
@@ -657,6 +657,7 @@ const struct file_operations ovl_file_operations = {
        .fallocate      = ovl_fallocate,
        .fadvise        = ovl_fadvise,
        .flush          = ovl_flush,
+       .get_unmapped_area = thp_get_unmapped_area,
        .splice_read    = ovl_splice_read,
        .splice_write   = ovl_splice_write,


All this "oh we have to call the underlying filesystem's
get_unmapepd_area" betrays a lack of understanding of the problem.

And Lorenzo suggested this in the linked thread:

https://lore.kernel.org/linux-unionfs/69b72e3d-b101-4641-9ce5-51346c93a98d@lucifer.local/


