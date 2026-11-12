Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7D72606A331
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c7b2RtdT
Received: by kanga.kvack.org (Postfix)
	id F32526B05C3; Thu, 12 Nov 2026 07:32:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE1CF6B05DA; Thu, 12 Nov 2026 07:32:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAAB26B05DB; Thu, 12 Nov 2026 07:32:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AB5326B05C3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:32:20 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3C0AA160252
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:32:20 +0000 (UTC)
X-FDA: 85426404840.22.0C66B03
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7223320007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:32:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c7b2RtdT;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794486738;
	b=cxv7wvJfjxgxSDgz3jfFTV09Pa5bia5Hw/SI2iNdDGM5uDeYiowItfdwjIGvGlf6trITlw
	LFUtEwjq3Dga/Ay+eG7xMCzEV3rwMOKI5ACqeMj1kojx5MNPVGJFuApiDYg0xuqr68TaLf
	y3ZRrmaHJQwiVKVaYShKE9N0sS9eLRE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c7b2RtdT;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794486738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/0Nn7OA0YlSzxRYVQPnJYHdM+16KC7XB/f6ArytZHYI=;
	b=NQcQDDkVPfinR0SW05jjKqLoYCpuq49Lk29jz34Ny7Hae0s3JSqcV7HGnqq+mPtyzEoVAb
	t0Lzx4Dvvs8USfTMjdM9LXD9saE4sNrpF9SP4BA4QySmW5AxADpLpODDrRrHpKWOAZrKDT
	anVYuIGpIJI71k80bs/G9+tjQIok1gY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E57D47038;
	Thu, 12 Nov 2026 12:32:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925A91F00A07;
	Thu, 12 Nov 2026 12:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794486737;
	bh=/0Nn7OA0YlSzxRYVQPnJYHdM+16KC7XB/f6ArytZHYI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=c7b2RtdTLtIz0vkgbAYrym+dG29Wb2E4K0rNtFnrkYrU7U6fWrjEz23dl6OtszE3b
	 SOmtdAoZsy5KeKOC+/VgMAibVVUnSLCsG/PCeEvrEIGROultdLtfMDoMUL3i7GnApO
	 Yn+9d3ZYvpy2IeNC/EQHse0nkLDcQ+M4G2h17s9JOyv9HNtR1VkRgNXvGKZXsxZQt3
	 DN+pN2kYgktqaiCUbPuFjYjGbtBNIaeKQJEN6JuzuaeH5P+HGpIYYIxJgfMg+XUtDc
	 bA2KtlhkNmPnQwEwbuwByZeYSjJOW7Vm7cpwCJ7Zdr1B0890spWvDOK3UsCv9zQk6v
	 Zk+px+/0oaslg==
Message-ID: <fa90c536-3b3a-417e-a09f-011a12e73048@kernel.org>
Date: Thu, 12 Nov 2026 13:32:02 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 01/18] mm: free PG_rcu_free folios only after an
 RCU grace period
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Jan Kara <jack@suse.cz>,
 Hugh Dickins <hughd@google.com>, Christian Brauner <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Harry Yoo <harry@kernel.org>,
 Miklos Szeredi <miklos@szeredi.hu>, Miaohe Lin <linmiaohe@huawei.com>,
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
 <20261104130118.2507513-2-kas@kernel.org>
 <ecad7b3c-7244-425a-9413-04d49f221057@kernel.org>
 <au2lsbDkyWt-To0C@thinkstation>
 <aa2a1e32-9b1d-4545-b2e0-03d213593023@kernel.org>
 <CAHk-=whnH5qLJH3Wd3bOxv--Ei6674Jo4iifGD_MqzyJg2Jm4g@mail.gmail.com>
 <8504e28f-faeb-41e3-842e-0cb74d1a25ad@kernel.org>
 <CAHk-=wihE=ioLKrwzz=WQSJg6HhB-syu4hqZ2QFwgnwYmmLEgg@mail.gmail.com>
 <f39a0ec3-be81-43f0-91e8-145ec139b1bc@kernel.org>
 <avWv-0LafPyo90ln@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <avWv-0LafPyo90ln@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7223320007
X-Stat-Signature: gcr8rj5dn8798j3chidjrjox6pn7yorw
X-Rspam-User: 
X-HE-Tag: 1794486738-182932
X-HE-Meta: U2FsdGVkX18YElTS2Kynji4Bs61FiuzmEouUIsa8b8MJHsnMolgI0D4BP+UUgVRBHmQjjcfAe5rKl/OnILMHyg3eOi6qf9VqNOtw2TtQDI3OYIIHYEjb49vSs2WZ2FVaQ5PzK1xcGs7gtDvJYeokNgmZ+viMOLykSnEt4HIKEx55jC4Dtd4dcQpWPF+Fidebv2QR5Qgs5/OwBLnw//oYkmDN9kbR95no0H1mHwffu8p/1QUFKrSm9u8AV7xUWJzIas4LrUyE2UUdiM0BU7+uCF6elA2aN7k34BinrMmzcaK0DQyoCwdyD4KapS8e/bPA2M159VAR1GccBg0llcLNmUXPONwlSvcAOoLeXT4+4HFavP4n69Nq3FfZOlIMzeILFeb1vpJwrmUdkqrSrS+yIRlHclPSLBPWB/SzMk+GbgKgNSFR9Gp83CgwydtigD7yASfzm97155ljYFircYufgso+KLge3Iiw1Jh3EOJDymWu+Xj6BjlKVTOtZdFfj0s5hus+2K71tLmQy1xj73XaFbKDK5lB9MR1Zc1EcC17lW87nGyDsH3cbC0HuRotzj97W6xBnNmRa3XoDbG0HhwMarwVj67kZMaJ86Y6D2dUm+iVRsNLKyBsuptT5w0pVbKcZrirIs0TkJASwcZfhI9rgWz2+godeI81JhvFGR8TO1ELEDUGtFpDnMsFQvvNxHS2zwZuP/d7AMsaQKkaKgpRD9ja4R14UD9x/NUoIy1w2WxoLJgn1yXsbx5jIkb4HITPCUSIXdnH64Hs2865sK80uLxAmZolzYfBf22pAvYo9HXXj5CfiItgBNo4EjvoH7992G7fQGVVZs7GZkpq2aZeuy8QM22DLbt/Kg769ZcfU6hp0gOtj/s4NoilDja5/0280y85BLNGks2Iy5AHDdT7NbK3Pn6CpL5raKWcpHwk7/hsd2ys4Gub5vs7notz/i8Ow0i+MyCJlzAhy3Yp6Oz
 CH8QqMyt
 42ZQTf3y5PLmPn7mp/B0iKuNCB0k1HTBSXsTg0N6DSI7WnKk88AfAb0Q2afzSy5vgH2SohwaQgnm12mtXXPuD/iJyYTtvvbjHRQuBEq9Kuy2xO/iDReU8gX2U4+rEUIs/QgvrsBrMbYHUCzBRVPRvIBLtSf1Ruz7b7NFLGVTAwtcfWrpa9XhFHKPf4+KkO5D/OlU8YPj/2Z7ZqDuJDve8pW1/9/hzcq2AcfX7NRuBTlLDfDQbgvyqr2iTNW5hjf4tKSnY9jUHwyAReBFJ39u44y+beftXOQQnXCoIZOQ3SSYLLjb09Bjr7/GT8hgDj+goAGHU27TQSrIuW1wu/nNCXdUhSmREoFcwzYWe6OMmwbjFO0D7LZMoiCcPH76GswjD1iwY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 13:26, Kiryl Shutsemau wrote:
> On Wed, Nov 11, 2026 at 11:03:38AM +0100, David Hildenbrand (Arm) wrote:
>> So I might be completely off, but what I imagine is that the memdescs will get
>> RCU-freed (these are not pages), and once they are then getting freed, they will
>> probably take the physical page with them.
>>
>> And freeing memdescs through RCU will likely be memdesc specific.
>>
>> I really don't know, Willy might know more about these plans.
> 
> Right: once the folio is allocated separately, the lockless read
> dereferences it too, so it has to wait for the grace period along with
> its pages.  The per-CPU batching and the waits in the allocator later
> in the series do not depend on where the check sits.
> 
> Until then the folio is the struct page, and __free_pages_prepare() is
> the one place every page cache folio passes, so v3 keeps the check
> there. 

If we go that way, don't make it effectively folio-centric in the
implementation. That's what triggered my response in the first place.

-- 
Cheers,

David

