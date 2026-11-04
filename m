Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E69D9606A32C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XGBnkNLX
Received: by kanga.kvack.org (Postfix)
	id 064C26B05B2; Wed,  4 Nov 2026 11:05:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0148D6B05B3; Wed,  4 Nov 2026 11:05:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E21CA6B05B4; Wed,  4 Nov 2026 11:05:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BDC6F6B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:05:53 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 56613C07DB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:05:53 +0000 (UTC)
X-FDA: 85397912586.16.7828AAC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 890E52001A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:05:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XGBnkNLX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793808351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KQOlEBXPj3aUpi/4be1OgcxwZwKCG7z2LEPq88kuQWI=;
	b=vLBHSOrtHy8ILWRHxgheL71Vg338WzmigtOIjya8+ri/1OKXDECWFwrjQAZr/kGklbF2h5
	Eo33qtWeCIEZ+1zeZ/aHFMea9lzPryG5II2bzeCQVQfGgBfX5GaTDKBBswEa93PmL6ARfM
	oK7vg1WWihJ40RLfdNUroQwBtbNdfF0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XGBnkNLX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793808351;
	b=2ZVqKz5R+BIDVXSIsEHOsPnktmlvSDfKHWqTpp7PESjbUJAJjatrpY0Glgp2qUxvgS+X6H
	aeifwrqx6gl2Q7TUO6hnfMvbV9zYEvNeKODYOVTxWP1Y1dnmSYHR7zcQTRYAmF0rkgj5Lt
	QJo5exRNpZv5klUVAq4908eaRCz2W/M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E6D160609;
	Wed,  4 Nov 2026 16:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3D11F00919;
	Wed,  4 Nov 2026 16:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793808350;
	bh=KQOlEBXPj3aUpi/4be1OgcxwZwKCG7z2LEPq88kuQWI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XGBnkNLXs0XuijqK3zM9ttmSgU1UTQ/rg+h8cBP8P4uqXYo4giEahBxrcuY3adchR
	 Fzz7Kxc72wqhaVNQqSU9qwgaKTHR4jiazsTntiru7aBN8SpcxaCtNCfMoRM0qLRbM6
	 FW6Ty/z8Pf+pWUCFsvGkMcVTffrWDJ+342v4yosfovPQ/IFAhRGraZqwVzgNsmhgIJ
	 mSCwhQsqcG5n/DtSo/ELArgdQn8d62OS2gFbWIwmDsUMzNcEsKBCKIhxbVyWz0I/Yt
	 x2jdFxCv0RjOk8EQ3HmNynII7gOiS5tnlHRd5mkZ/nBVMeSeLm5puPCpWiUBvL2fOk
	 RJnav2hHIjLXw==
Message-ID: <af2102a2-206d-4c5e-ba1d-1ef42b2b6338@kernel.org>
Date: Wed, 4 Nov 2026 17:05:29 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 02/18] splice: don't steal page cache folios
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Jan Kara <jack@suse.cz>,
 Hugh Dickins <hughd@google.com>, Christian Brauner <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Harry Yoo <harry@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Oscar Salvador
 <osalvador@suse.de>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 "Paul E. McKenney" <paulmck@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Luis Chamberlain <mcgrof@kernel.org>,
 Ilya Gladyshev <ilya.gladyshev@linux.dev>, Jaegeuk Kim <jaegeuk@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 kernel-team@meta.com
References: <20261104130118.2507513-1-kas@kernel.org>
 <20261104130118.2507513-3-kas@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261104130118.2507513-3-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 890E52001A
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: pfdawppay43o1scqwxc14yue9tsfs6f3
X-HE-Tag: 1793808351-998227
X-HE-Meta: U2FsdGVkX1/VUHOW9oxSR+UaoLQOZ0t+SzFtXAmGUXR0LWjnwR/dGf++j4irBnSJsdUMJc/Vi4OEEItKw9EFFHYiIcrZ/5Ci75sd+y/BbVSvccOWVZjjD6YkkfEwPOFQDEdZyNuPZovfSlc9LsfruiZTM6MDeiBx8EWQvFubfr8nMxsk6ZebIwLXe6+YlnqHUCHr7pr5J3ISoXK68jnZHPErGVvMUCA0Zbt+fy990z++jCrRjkG+oaNS/glktJOpRQeLp/kJZXR8gsgFbB/PgqRqRbBh8l7ouAQYOKbqyhrjp0nbX0UL+2zp26sksAeiszN9uxW3NEwgf/A4Cy9UiksY5hQkj0xz2rENf1SzDP3XfJSijTn25e2gxu5iRx7/KeomZJzCiggYJX+4ZBPQ3Tu2iAHKjqEd1IUbpR3c7SX7HGUnZxiKwAZAmXKunNjAR4CeNDahsh7/a6cc+XCIm0RfElq1+9eGNZZWTjrT0u6knZJ5WtVG9GSF55tSf25m+tLeYNx+bYino7Gr4N/ZPGMhCF2KFLXkqwWhj7pYsDM4F3aL9BA1XI+fsVRQ3fKjwm4AAQeyXhJL+pJR4kwVhrsf9Hb8THNhXazIHyrDnHKQl1GTmajn8KT49u+rqAc6oZqIRlWqM8r+3X+Ii4yVHR04kS/FQtVwJvjm98ZMvK22zcdN2ASEYQGwvDBwZTrVOZJxqqww/DMGfV7UDl7QROx0mXgMeKHOaS39m/5xTwrJpRWWw3avr6AyCoRNfBq2r+M1ZAyPYhBKcDqVwuzz/bzX71JG/iL5WE81DudWwz8/qSs6tsvMVaqg5ep36+bALttOLNEcojUuoZ4PedVOFqOZc+Bjmh1EhDRkIIR8V439yziHCu77hppxLpoKzyg8dcD7jw9P0dFeAKd6/fWnwb1/SWdfkqDtZAsc2ceMZ0GL6U13cILKFBASliUHQCXycbwCqAqdoS72pe9yv59
 hEVfa9cc
 jjCdoJSVQq95T/NGelb2wofNN+0BXtlqHXUrCtdhWtkpYuGBY/xXqK2azTUA/RskF6IKD6VslodCUTqyRa1bcbHMVn5z4cj9rYY13DhrJKPryzsM4NABHC2sTjf7RGdfl3DUMparQc2JeVH7TE9VM+KDW8aGowg5c10DHVRGUn7vNut49oh/LnAhm5hi1YKIy5yfU6LNdu4b3Se1A86GQoqbL55ZfG9kkaT8I1o9EUppoUpeh//V8WtZsek2VBBfg52Tf8IMG8MV25PDPr1HGwnSgFQznevpY7I+jzG7aCI09/AqSJDF1fIVsTEyEMCnwTMDx7mFEsXwGfqp6rHmwSWqaZXRiH0D4IAwVd/K2I4f02bkMav+X2bFYDj/ISMIk5Fb+WxOAUH9Ky+YbEON/ScNjgujFSwzoKV6k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/4/26 14:00, Kiryl Shutsemau (Meta) wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> 
> PG_rcu_free holds back the reuse of a folio's memory until a grace
> period after the folio is freed.  A stolen page cache pipe buffer is
> reused without being freed: remove_mapping() takes the folio out of the
> page cache and the caller keeps it.  fuse_try_move_folio() puts it into
> a fuse file, where writes change it under a reader that found it before
> the steal.
> 
> Drop ->try_steal from page_cache_pipe_buf_ops.  fuse_try_move_folio()
> and virtio_console's pipe_to_sg() then copy, as they already do when
> stealing fails.  SPLICE_F_MOVE from the page cache into a fuse file or
> a virtio console now copies.
> 
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> [kas: rewrote the changelog]
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  fs/splice.c | 51 ---------------------------------------------------

Removing code is always nice, even independent of the other changes :)

The description doesn't really describe the impact of this change. I assume a
slowdown of certain workloads (does anybody really care?), and temporary
increased memory consumption (as we keep the pagecache page).

No idea how often stealing actually succeeds ... a bit of history why it was
added in the first place and why we no longer care now would be nice.

-- 
Cheers,

David

