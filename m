Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BDEAC55172
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 04:17:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19C716B00B5; Tue,  4 Aug 2026 00:17:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1732B6B00B7; Tue,  4 Aug 2026 00:17:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 089D56B00B9; Tue,  4 Aug 2026 00:17:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E037F6B00B5
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:17:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BF919A2373
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:17:40 +0000 (UTC)
X-FDA: 85062278280.10.F17DC5E
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8B9F520005
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:17:37 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Hc/REYrJ";
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785817057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=64J9NQ8wINxMWeOp2Yatp476UcvWi6dCmOU/qEHakuw=;
	b=DmionSez0KaKIQ2RSKhDnMiRpmMcfsl1SvnhjC5q2BUYGSzN/fOUnQ3bxM5VMtShGdB4IY
	SXU1NTnAstFiPG0lpnCvxA5AgIOYvwRViSbsDLYWgjwcnHdZbqJCu48V+ysFgfhdGRrQDo
	iCC06jqL5lBaRl/b6y0EWy+ulJzKkQg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Hc/REYrJ";
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785817057;
	b=QsJ4iOLC4LSwkW/OGCDZYIfncKy/JJzIHNgWSWRM4tvQ176tb34ay/UobTFsQW4vzBuCjs
	8bM8mqB1hlFUVzWjMGdSbrjoBnff1HvQZYYViFXcKZF7eFQ/ClTDq+jNZPL0elBYFmL3Ai
	Z7OXeSy95qt9VuWbVjYXSYtapCnnRoQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785772104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=64J9NQ8wINxMWeOp2Yatp476UcvWi6dCmOU/qEHakuw=;
	b=Hc/REYrJ28ABa30xrZ1S2G43zd3wYxS73exkn7ftrzeE6o48WnpuEbf10dM7FlgtRX0zIu
	WAbiZSO2Oti/9AmQcDnzXRIizlL4Q75woxE1p5gOjf8tcfILoGLFnqI6oK1iOwaONhC7UM
	olzNTFCByzZQd4kxyfr5PJN95Cd6BME=
From: Usama Arif <usama.arif@linux.dev>
To: Zi Yan <ziy@nvidia.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH RFC 06/14] fs/f2fs: stop using PG_private
Date: Mon,  3 Aug 2026 08:48:16 -0700
Message-ID: <20260803154817.3112697-1-usama.arif@linux.dev>
In-Reply-To: <20260731-remove-pg_private-v1-6-142c97ba3562@nvidia.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8B9F520005
X-Stat-Signature: z15mszbd6jxeb5soh6abga5fqp9yo5nt
X-HE-Tag: 1785817057-7266
X-HE-Meta: U2FsdGVkX18ju2Nh5UfEIipUwWX3DepIKT6foGn/SHLA+dMyhq7vgm9e8sYvH3r5RzxWlBaGvy3K9d8Je3/kN8HolHK9YGHzeafPuTRAaTClACV2eLgLgF1aSwgf9sWINZHr+G1Hdvpqy5qVUvHReF2J+gaebcG7oMY6y+G3cNvjct662pQ/Vxg72fnI0La1Ui+QAeJH+bOe2BoTgqgWsTBUENR3mB2u1CJ6IIRJknB0/RlaFQBHJsDKXR0Ebbgq+Gd8sijSgb6WbZaeOSKE0KdXDfzt2vCxxyWeeqvwsAGsy5lVtEs39QYFSh9sU9tEsiiZjx+kY7ghNbJ5kfLTp4X1+JDee1vfapAVFfetar24YMDYnoUBRIy5x+9GiP57tJ7fj+MKdrGo0xavWNN0W2hYbACKnvUj+TLEs5kjw3og7zg9b/D6/ggR7QzzevCy2VQwuH8pdw7V4SQjkbTocj0qw3DfzqhBBRmXboDD1kgU5OT8/pnQ4wDJ5Fzb9EwXtlIFMTl3bFdfMgxQCRkTjsh2zWbO++5YyeDlLJ7ltIs1MkHQ80p9bjqplbwfjtwQqLYhP+aiDnzOLua5HG1pKM3ozmR8Q/VDNlM/Una+jrAdF7mRa/PiY3TIUuuKY7T0ReZlLk42fFf+seVESoAqAIg1Eyjt35cN1C2cZnZcc4zU+xo6qjvCKebExvI7qyuJYD9CgUBXp+aPMNPYhEDWEJ4BOPzBgB0bxnwwRLO6elSt7+VurTE6i6zJ+NwDbBxBFnxmDZtdX9DmJzkbjr6AGWRtqpdPKpAkiE/RQAo4YWZLY4o46K1TdUQl6QT/Ye5EoSbh7a0IonC/A/l2fNq2It6LTe7b16tsz+S51oLm2A+rE4Jg/6+Ox/+MMnfREWDzIYVICoMzIKoMYqDCwJiAbo61y38Z1+GjObtrBxIbC+AEnZOfkm1kO+sBAVCGX/XQDYxT9r3bQ1vtKsMj4L8
 SRC6Niy0
 R6Ld9Zred9HhAlQ5WvaFVwjjPQVqEwhppkimD+JybpknlfCAymWWhqKcxqFqf2WgfhjC0R49aOdIG3+QcGmDptX2p2MHgFR6g6BQ+ipZ1JfSt+SO7ZIfmwh/hflL1KmR7aG0GHr3Pj1cn9kdeZCLKWv754gRl99z6+hZX+KxhqrPaZx+Yz1sigIwmdcDdI2Rl+7lrvo6xij9FM3wNp5g/IuKZ3wf9hJzFJBipmTBdOETBld9k/AWPeoYxU2fJsOcX3kh1ZGkbVLJr+CREJOw2LY5bIVXnnA0B+HQMoAElk3jKRNkDvnnERj05JWAyhTXYCzii
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 31 Jul 2026 22:13:29 -0400 Zi Yan <ziy@nvidia.com> wrote:

> f2fs sets its PAGE_PRIVATE_* flags in page->private and checking
> page->private != NULL is equivalent to checking PG_private. Change
> PagePrivate() to page_private(). Meanwhile, in set_page_private_##name(),
> page->private is first set to 0/NULL before an PAGE_PRIVATE_* flag is set,
> but it can cause confusion when PG_private is removed and
> page->private != NULL is used instead. Change it to initialize
> page->private to PAGE_PRIVATE_NOT_POINTER instead and retain the original
> semantics.
> 
> It prepares for a future commit that removes PG_private.
> 
> No funtional change intended.
> 
> Assisted-by: Claude:claude-opus-4-8
> Assisted-by: Codex:gpt-5
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> To: Jaegeuk Kim <jaegeuk@kernel.org>
> To: Chao Yu <chao@kernel.org>
> Cc: linux-f2fs-devel@lists.sourceforge.net
> Cc: linux-kernel@vger.kernel.org
> ---
>  fs/f2fs/f2fs.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Acked-by: Usama Arif <usama.arif@linux.dev>

> 
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 8f3e632f315cc..edf01eb4b3b30 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -2643,7 +2643,7 @@ static inline bool folio_test_f2fs_##name(const struct folio *folio)	\
>  }									\
>  static inline bool page_private_##name(struct page *page) \
>  { \
> -	return PagePrivate(page) && \
> +	return page_private(page) && \
>  		test_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)) && \
>  		test_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
>  }
> @@ -2662,9 +2662,9 @@ static inline void folio_set_f2fs_##name(struct folio *folio)		\
>  }									\
>  static inline void set_page_private_##name(struct page *page) \
>  { \
> -	if (!PagePrivate(page)) \
> -		attach_page_private(page, (void *)0); \
> -	set_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)); \
> +	if (!page_private(page)) \
> +		attach_page_private(page, \
> +				(void *)BIT(PAGE_PRIVATE_NOT_POINTER)); \
>  	set_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
>  }
>  
> 
> -- 
> 2.53.0
> 
> 

