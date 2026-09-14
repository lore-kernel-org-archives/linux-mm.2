Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AE30C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 13:17:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D8A06B0088; Mon, 14 Sep 2026 09:17:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 260836B00A0; Mon, 14 Sep 2026 09:17:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12AF16B00A1; Mon, 14 Sep 2026 09:17:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF4FD6B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:17:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 70346140132
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:17:40 +0000 (UTC)
X-FDA: 85212419880.27.409418C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9FBC420011
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:17:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kik6WOQK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kik6WOQK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789391858;
	b=XeOeCu8ySFJ3TSaDd90pn2jVmUdZar9FTAeNj+a65puZv03JxSlL3THmQo0wCKb2cGRyPa
	K7ruUrcpOHbZKhnyuVqr+Y1iFnB5iM7G8mpCPYObGTiEg5fA2Ov7v7UTz6ANLjklofIV3q
	cmE5b59TRjage6o2gPg01vWczpdMwMU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789391858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hhUbJrfw6vW2Rpyvmw88xbSS4WfUjxj+d6KMf+zk/XA=;
	b=cVt7SsH+OxKH1z/Z27hfooPUpAjNJHcIFyjlqkig9jsBI9LPCkKVGslh2Q1Y4gv8DSnwOu
	rN1W9zaD06PQmbtSejIeNEOc/J6grLURkBSiD24EK/eUdvV1+SUBEA45nUMHbOnvu9XpBY
	szXlVjR2Ku7al9ayEJI14tQR4gdMBRQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 24C4060120;
	Mon, 14 Sep 2026 13:17:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC1DB1F000FF;
	Mon, 14 Sep 2026 13:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789391857;
	bh=hhUbJrfw6vW2Rpyvmw88xbSS4WfUjxj+d6KMf+zk/XA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kik6WOQKTvM9ZwoIKKjJrNrdc7isnaDKhleSp9hWvx3NYkGsF9cz9od8V/H6jOhUv
	 vQTWoqiWmQ3IlCDiOL8EEKkH6rkAFkOsEkx6s5wnLGmh1RFtOi7dkkyhdjTrkEaFn9
	 WdA0z/hrNNcDVgDGiGqcvC5/EDKdQCdRRvI8Z/0d2o+OrWjKcMslgW2PiKVk4d+Qw8
	 N1l4+y4mgKDbZhzCTyxCOWBnV9FkqB7AQBpV+ajBYEcexVj3HVishW7GUcTUpHcanC
	 kcz6rGf9oj+GggO1Pt2IJPUVaEiytEp1en8fLo+jtDoCNA/OvuSJnOdIl0aAwy88ZI
	 PYbtbl+vtbsXg==
Message-ID: <3c82cbf0-0f4b-4ced-8f88-5106c4dbf212@kernel.org>
Date: Mon, 14 Sep 2026 15:17:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/16] f2fs: stop using PG_private
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
 linux-f2fs-devel@lists.sourceforge.net
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
 <20260913-remove-pg_private-v4-6-848550f7574e@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260913-remove-pg_private-v4-6-848550f7574e@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9FBC420011
X-Stat-Signature: skxjxkoogubzfezeux9m5htxpi8zezku
X-Rspamd-Server: rspam01
X-HE-Tag: 1789391858-575239
X-HE-Meta: U2FsdGVkX18ob+nIPnbVOqKNTVWrmkiz37od6VsHhkBY333roq/biz9cYEVt0kr11Zx4HtddLvvdqkFNEreO2HpCfV/0UmtQrY8dz/hAJfII9vs59wAuNuMtYOOexNcAjZaouwYhrZ9NgiBafexUtvCRZRlP0DD42bOFIYRyraOptkWge595UNkwQ5ZmcMpAAB7x2rZl7EFSPDfg4ADNm8x4IXzbBNMPjZYcWEj3Z3fJOp995+7YTV26auAVUt6xYpbh3adYfe6JfWiab8lq8T3xI1pJXrUPqQuyB/6eMtHWzv36uQjAkbCJ0Afzm/Sn0D/SQs7ZIMCHrRVpak754xHnRlTRfFiCaxuhutDQOQVdN5WMe45cOXjpa3PfdTCkW5kORjTi9n5spdCyxGaoTsaxw2PMIlKp0V/6momG7Q5uFX0OwlYvTP99BxSTi5qcdpj0FeJJsxbDMPsr+iF+LngiQ061H8TwM8YDLVpIDxZsW8vfFEV8JD84CIJLQbFCoCHigObRsy+fEi1LiqeiySr3sclt0cWRRgPBlbtWXwKBj078f/k7LK217nlzK0h4QVfjLCNs1a96H8JhbnKDc2CfHAd6xKxMrI7DhbHwUax+8+ooKAFYzKlrshm/wCggt9l2cd1C01trZUiQK8C9ZGSeGXtlNiGcAnPxfGsU5x2opX22D9rVuq4OYqm8W3XAhzWZfxiPLLY2EBXg11ZB8QFAxgTDLdmTqCdk6Q0dBvTmgX55aQ8i0aUTlOjzTuqmEOosKIe+V5fUdpkNB9QqSxm2ayn1x3whqZvRYNdEI9G8Owbh+ItG28KcKdFKaKElvEzZeFM4uJsNQPZlNioE5kPtqyx7v9rusyjXLSHhXXXmHS6RRNjK+5MkkN5U+8FT4Rrkvi1e3G2O6F4JIyEHAG86ThZ3urxTerO8j0JFRIQVb/w24p/wnPrqgYh0rTj/OJYOBftYpgbvJWlqVuc
 6o9RAuPE
 57RjqL07VOuWQkAABMRyGc/hqRaLQ2nH2A2h9d40839YlZBodCJJtkl3vzu8uGkbArBZvjiveE9d47aOaSI6GfJePch1ZMeXxHCcnnQaMddQIWoAkzUMD1uOHtjISVuLq6nA1mbElhfiCxpEUNUej01FYSrfuahOizjwbfSEoH4dihFrF+bHt6qJ3w5yJF4wXEUB5PC3mRDgHNhsOmSuqmIhrynoOCCAkYsVTH6aXdWoPT59ailos8t+FQh9ZPte3xLUOPu/wnKnp+xFok6THsrmos/0zuoD4JtajvSU/gAq15Zp+IALLUotXfmQIotsuVajsA01ZMuAElaX+7SGiIk3uFbv/x37PJZYv++602fsI/uFuTey2fCsYM22bp9NVWGmw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 04:24, Zi Yan wrote:
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
> No functional change intended.
> 
> Assisted-by: LLM
> To: Jaegeuk Kim <jaegeuk@kernel.org>
> To: Chao Yu <chao@kernel.org>
> Cc: linux-f2fs-devel@lists.sourceforge.net
> Cc: linux-kernel@vger.kernel.org
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Acked-by: Chao Yu <chao@kernel.org>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

