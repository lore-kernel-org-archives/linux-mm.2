Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D69ABC55172
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 14:52:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C95C96B0088; Sat,  1 Aug 2026 10:52:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1FC46B008A; Sat,  1 Aug 2026 10:52:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE73E6B0092; Sat,  1 Aug 2026 10:52:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 85C5B6B0088
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 10:52:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E7A6E140333
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 14:52:20 +0000 (UTC)
X-FDA: 85052991240.20.42B1094
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf23.hostedemail.com (Postfix) with ESMTP id 17D0614000F
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 14:52:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="dY/qZWe/";
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785595939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GcGm8f+HjinZy6KpUpQibmKA3BxQ4Nicuuq7tor/vmY=;
	b=BP38p2ifyG/dMp/d9rK+jiG7KaGblmYIc7gK04nwEV+Qr8foPOcxUvfgDugKwUBZSYUXBb
	DWb7MI38Ov8dc62iyfp4dor8zUrf1IIZzm2OJ4fBq/GZhzYrggxmedovC40zBtCvw3GMbv
	+hefbcKFO/1m4HQNj0ua2JqG1uYgx6A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785595939;
	b=U9JHO8Kj49JUiHEjfHGiwYT2Z78SBnV6p+vliQ/mDb1AdVwA9CgXe0vtC/oYbyiWBmA8IU
	wQaXRevc3rHm1vMKgj/pd0PwLvhcML07qFpovOLxNARf0AHJEwP6WTMG7xOAt6fxJc2OBS
	x9zRLu8ApnQOa2RzHemmrgW946iO1zo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="dY/qZWe/";
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785595936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GcGm8f+HjinZy6KpUpQibmKA3BxQ4Nicuuq7tor/vmY=;
	b=dY/qZWe/pctIzM3LCzB73J/MmbY3+GUl3Wm5oBdOtv9fzRMojtyF2M4U6ZiLC3BIP315zn
	SGGrWvW/q4nommTh9uVRrqk/1lgBEVXiKouBxZ49ldIobitG/aClAOMJIDcVixCOgXUkt4
	itTlKiyeiGTV8Aws3LDIYftmReuBv0o=
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
	Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH RFC 04/14] fs/crypto: stop setting PG_private on bounce page
Date: Sat,  1 Aug 2026 07:52:07 -0700
Message-ID: <20260801145208.1930586-1-usama.arif@linux.dev>
In-Reply-To: <20260731-remove-pg_private-v1-4-142c97ba3562@nvidia.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 17D0614000F
X-Stat-Signature: qrikjqiq44ybnygfktt887z1u9gkyg56
X-Rspam-User: 
X-HE-Tag: 1785595938-462179
X-HE-Meta: U2FsdGVkX19lOP20jOs2o/3u7HklN/3aB4Cg61lP3sRMowN+Pm7AcUld9Q+8QWvaOL/cEFcucCNZfdEJ7X4G2NNL5+DrGydp8JIJtlMjPsfi4maIoDt0gBX0ZcWdje3IfNf6IKts8TNP3g53l2rytwG7Opx5JZD5dlmxb+c/nmhng96CivtZINrTA4JElQptIs6LTG/yP2L0Jo1H/Hw3MT5HkeRh8L/ZsA4z7koMUo0Y5UtthYNRl1qf6ehrtJk+Z2cd3IgaaSaZBUuh1oUGXkiajif+1yV4ZvBap8YSrZPNC1KfC7LU373qL7RQ5AWN9izx5Q7g/DgzwKatRRnnm3/3IMbP0biSndUKNF2Rg+oQszCE1bQcnGo9Vc5VXHEtOiRo4o6g1F4lCk+2KLLyKEh0gYvFrcx3vjh40RLy21/RiK8/vsoVYJMY8qhTCupMMBdIEFXusiuIRp3pZRL3uA0cbaiJmzbA9xNOIFr45BZFXx4DNS90myeT/3GQA8lH8LwWeI51Lh9vFGmfyOEpe5EjZ/Zfa5QnjAY0A7sUn0K88EiAc9oRhlbg9NBzj63qqwDwWLMjUrNspoBYbRiI9c4jTxDCZyhsmdQUBl6wqAwINPoXig6pziI0JCAKDMOA6pTZgtzbeNuagk9wwJe1INj6guCs7z6n758bvC4Nbt0l6vMnkJyi9riTKyqVvfzwZ3ymgLy1rZMp9rCSwYuV6iFn5lFgJCgYPKiWDEdS66bxrnKqpZ1dYFmms0LQbUe7xMt5RkzsvUVpCtBNm/ljoMAbvvTjGse47AXxSSUVa/Je7x8+TXtlBzUuki5hZKNyyRTWHiwxXeiuFVFsDeGtGUJzdF750GfZ/Xk19ilFYl1hATHQfZ3ZfB+okZm2d0WfmaDa8WCocDkV9eRTFP6srD/J3F9euvclrJck8AQgTNBsPxCAaK35bXiicIaG14r5sM+lAzGH6VmCt/leR3Q
 EO6p4yVA
 y0pQpvVIh20gV51lfHyQxufUmEfmhF4F7eOP1cv/6GyESMMCOnRhJ8Hwb+YpyHu56mnK/Tz/c8tzAqeDJxhpDFw2RZAEvMX1nKBtSOjq0KYlEDSB+TVeSHthfwMZqAHfwRxceEaBXMog95LLyM+WtHr1S19WM6h4BR2zm3Fpa6+Bct4GSf00xL8qp77rOJLdNvQLfTBD7h2aFrgjY31QFcUqHauSnilrYeAnyCTBEpiglvVjDtMbGme3oh6D7JfFOWgFaa+UE1B346FkpCYs4Frd5HwFzbC9+zDbId1R8/GvxSAc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 31 Jul 2026 22:13:27 -0400 Zi Yan <ziy@nvidia.com> wrote:

> The point to a plaintext folio is stored in page->private and cannot be
> NULL, making PG_private redundant.

s/point to/pointer to/


And fscrypt_free_bounce_page() NULLs it, so that needs to be corrected.

 
> It prepares for a future commit that remove PG_private.
> 
> No funtional change intended.
> 
> Assisted-by: Claude:claude-opus-4-8
> Assisted-by: Codex:gpt-5
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> To: Eric Biggers <ebiggers@kernel.org>
> To: "Theodore Y. Ts'o" <tytso@mit.edu>
> To: Jaegeuk Kim <jaegeuk@kernel.org>
> Cc: linux-fscrypt@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  fs/crypto/crypto.c | 2 --
>  1 file changed, 2 deletions(-)

Nothing in fscrypt or its users tests PG_private on a bounce page, so
this looks right to me. The commit message needs to be corrected but code
looks correct.

Feel free to add:

Acked-by: Usama Arif <usama.arif@linux.dev>


> 
> diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
> index 570a2231c945a..c8a98dd94650f 100644
> --- a/fs/crypto/crypto.c
> +++ b/fs/crypto/crypto.c
> @@ -73,7 +73,6 @@ void fscrypt_free_bounce_page(struct page *bounce_page)
>  	if (!bounce_page)
>  		return;
>  	set_page_private(bounce_page, (unsigned long)NULL);
> -	ClearPagePrivate(bounce_page);
>  	mempool_free(bounce_page, fscrypt_bounce_page_pool);
>  }
>  EXPORT_SYMBOL(fscrypt_free_bounce_page);
> @@ -202,7 +201,6 @@ struct page *fscrypt_encrypt_pagecache_blocks(struct folio *folio,
>  			return ERR_PTR(err);
>  		}
>  	}
> -	SetPagePrivate(ciphertext_page);
>  	set_page_private(ciphertext_page, (unsigned long)folio);
>  	return ciphertext_page;
>  }
> 
> -- 
> 2.53.0
> 
> 

