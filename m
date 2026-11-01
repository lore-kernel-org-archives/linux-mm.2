Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35B58606A329
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 20:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WPNGg2UF
Received: by kanga.kvack.org (Postfix)
	id 2243C6B05B2; Sun,  1 Nov 2026 15:02:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FAB86B05B3; Sun,  1 Nov 2026 15:02:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 137C76B05B4; Sun,  1 Nov 2026 15:02:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E4F846B05B2
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 15:02:57 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6DE88809E2
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 20:02:55 +0000 (UTC)
X-FDA: 85387623510.11.C8059FE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id BF97018000B
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 20:02:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WPNGg2UF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793563373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0SOJOJhsdif+go/5LJX1b5wSejdt1NsbUiyp9y70uTo=;
	b=SlFHtCQPZCq9+ROdoJtUVFwEL2+fmoU6+MuUL9/ywiqqJzmIZ/vhLIwNQ0Ipfz6zbTgYbo
	JrtQYgbTJ3bLyCi79t+ogIhvgkp7yo5k+/KqqwpPY2SZ41CKBSV7mPOmROvir3tM3oZEJK
	HsUyJt0h0JM4XTBRsK6j0ntXsC0ObBc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WPNGg2UF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793563373;
	b=bm8jenRDeXFx0CEUCF20GRGgjNVmHkPv/YIIaRbCHbLgG3mP3FZozZZF37+t5iwftuxUAM
	dlzmyxa9LKvQx7BZS5SYUIwo0FE2rRMjOHDgPT0C2E9bvz7aWAdNY8tG5CWbH/gPUGSy8s
	qmOS+9NAX3c3jY7tAOeIdxgsSJgKyFQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0581543CE4;
	Sun,  1 Nov 2026 20:02:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD5F1F00A1F;
	Sun,  1 Nov 2026 20:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793563372;
	bh=0SOJOJhsdif+go/5LJX1b5wSejdt1NsbUiyp9y70uTo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WPNGg2UFCH8oHLxBKLsk+XSbOwxF9rgh4nqmQJ4tGq+b/EXkueNSv/mUnpHe3LXTa
	 vVluDdes8rduQB1kHH0qnPxYIyTpIdeNMxc8d3/hE32sD/nAC42CBB2NZjzjwaoFKq
	 VSfWDWS4ofbNNxRwkpWxOicfIWhXrFR5GTU++pvsJt1mFFhIjNQMHzbTibJdmUZwEl
	 shnLe4dYc7bBcVf24pjhWeZ+yUtZLJ3rqG60ptgsmN8Uot0ZF7l/u6/9+ih0PTdWtU
	 cK/6PBKoyC0PY6UDnhR/dmnnBtE45aSMdmbZobi90DRIuD7AmkyMtioQdRZsBRVIOO
	 QgUz6fdgRIgag==
Date: Sun, 1 Nov 2026 22:02:37 +0200
From: Mike Rapoport <rppt@kernel.org>
To: vrilutza@gmail.com
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
	Borislav Petkov <bp@suse.de>, linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com, linux-mm@kvack.org,
	Ilya Leoshkevich <iii@linux.ibm.com>
Subject: Re: [PATCH v2 3/4] mm: Factor __pfn_valid() out of pfn_valid()
Message-ID: <auea3Sn6eOHFyM_R@kernel.org>
References: <20261101-kmsan-serie-v2-0-f97f66dc57ef@gmail.com>
 <20261101-kmsan-serie-v2-3-f97f66dc57ef@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261101-kmsan-serie-v2-3-f97f66dc57ef@gmail.com>
X-Rspamd-Queue-Id: BF97018000B
X-Stat-Signature: qpnzf7q5snw4jiesh7cdgbzt7xs56hmx
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793563373-493310
X-HE-Meta: U2FsdGVkX1+nyPtr8iyFAhuuew5XUl4urdUZwz0nDfUhqd+BBihdlgJstStpfkA5DwJsUw+U0nOnQsHmsRVktp4gffwG++gCDn3cSei3pwqVc3Yr/gypwrKKBGYoDZdDNrNLzkmox2pCB0qKYa0814oEcBkGh24jQuSqutwlqfldPTWjjMEo/w7vZv/JbasnEDMzi+jOR8KC0R5HUTSgi9b47nOVTEBnJj3iafDY8vxGC6KtqCZ9zo72SGBn2cnur/LjKVFbLRh6S5HDKP0HtggE/O8CyNFoqt4HBfhT6mS7/ezCYsd9uxFhhzv8OwkcJ74q9nKEgZXeaTgL/f/wq++ueIA8YQYHvq+x/FnifXfU/LP2g5zf29a2wSunQZnGOoa4jSmsJOscfEuqYbwc3uh6jRhGIprF30LaqlpA8CPMMzkGINbkLf5Uog18FYDUXSL4X4IK8KmHFal+geN208lLRIQ+3q5RTubgoNFXfSmNhPQV8GWAXUnDoIhJkocCV+ljHqBlbTo/MIz5NkyqS+JESOPYcAl4pD1yrgXVaNc97XCTYHvGshyqmpCx486F07jhTzANkqhvbjEtx2LROopM7zCRfkroxJJWa4ndiJMRhDZHimhVV2NDLqh05alJ8WMH9/gsThrSeapn6thl8Pq4aKOvwQ+4G3UESKcGQyC7vb5pcU5XFBOX3zGmiO89f2IM++42AUmWP56e/dVUeQ/EwogLNz6nzWABtDV8X3ziJLqHoAlWacCkqJquUjdmM1+mXSBsXwSZ2dWIzNRX7SA5F7ZTdsn2p0hp1qqgt6j4/8Hg63w2N++FabGj2UZdAgoNrnvAXqI/5zUw2AxcbM59YeeeTKcagILjUmG7cJpsPVk76y9dfJSc/EbIshytklEsGh6c9qhXNsys0xuKpn+MR8ISiqUF26fC8h+2t02F3UsMmP9+6eY6hI0YUdi1vNgVeeonYGltNoCmII9
 ZfKgHlAn
 bQfNCUAHUOXjmuZ4wHYLpefJaD+ld9A0Y89QH8rpkyv741h68mMHWCIxFvSy5f4sjLwylbHNkWEBAiGgfBPbWC+SlYt5lMMzd2nCZit1AB/c9eVIhI1FFa2chy6IXNXOS9vTPxSE6Hokdmk/Z+NUjH5x9n9krCC5dVHzENKQ5TdYOHVyuCfTMAPUDdVC0AoOVfP6NmLkg3I+/jbJbXUojxA6abn4kWAAbvBgNQyb60+YHbFhr4xW4tWWqoTFMT4VXE4c1PKpBgvX496wc3qYtGW1Mf3QIP59oqp1+SYogJ9X9m7Ed6AH7TdFC1bKG70Pls0TvBB82zJm8ow6VdH8dB9kSUMHg1VUByA8A26sgEA4jy1J98KvySkxmIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 01, 2026 at 07:04:38PM +0200, Viorel Cernateanu via B4 Relay wrote:
> From: Viorel Cernateanu <vrilutza@gmail.com>
> 
> KMSAN needs to validate a PFN during metadata lookup without entering
> instrumented code. Calling pfn_valid() also calls
> rcu_read_lock_sched(), which can enter instrumented code and recurse
> into the metadata lookup.
> 
> Extract the PFN checks into __pfn_valid(), whose caller must already
> be in an RCU-sched read-side critical section. Keep pfn_valid() as
> the wrapper that acquires and releases that protection.
> 
> This lets KMSAN reuse the existing PFN validation while providing
> the required protection without instrumented helpers.
> 
> The wrapper now also holds the RCU-sched read lock during the
> initial range checks, which previously ran before acquiring it.
> 
> Suggested-by: Alexander Potapenko <glider@google.com>
> Signed-off-by: Viorel Cernateanu <vrilutza@gmail.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/mmzone.h | 42 +++++++++++++++++++++++++-----------------
>  1 file changed, 25 insertions(+), 17 deletions(-)

-- 
Sincerely yours,
Mike.

