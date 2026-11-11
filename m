Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6120D606A332
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 10:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JAas8Nft
Received: by kanga.kvack.org (Postfix)
	id 893746B05B2; Wed, 11 Nov 2026 05:04:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86A8B6B05B3; Wed, 11 Nov 2026 05:04:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 780906B05B5; Wed, 11 Nov 2026 05:04:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D1E06B05B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 05:04:00 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AE24816023B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:03:59 +0000 (UTC)
X-FDA: 85422402198.07.2FD6267
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id B98E240008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:03:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JAas8Nft;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794391437;
	b=qPdw82U2lY/NCPeExHrek9rx0Kx59TogZzot7MejvlrPftJIFqU9bCVM2TsS+Hn4PN0ObA
	u6QogAOwmFNuYj0VcEqZ6LzUvDVSjXR6814V57zU2NwM6q3Qx8xLffUMVAAOGGSF7YcNDD
	Uf1KBHDoPK1USbr9BDbvd0ty4NdSL2g=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JAas8Nft;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794391437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SgJ/EmvItW0Xtf2MfU9fVv2igwmrCK9D6xMb8nPEVqk=;
	b=fIYQ9LLdVzkpNn7hy9VP4ms0g1X+7fi3N2BM1itHEzYqj9lGD/1FD4u54ylVtqQygUeDUZ
	Ytpfh31V0EbFMcbrHYaRyZvv4FFwm1cfReTyTjy5vYg/+Oj1NjEIL1gpt0xpxTV/xgsirx
	7A6aUDeIMFVOfSymgg25o5P0uDRh5Zg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 33D3F43458;
	Wed, 11 Nov 2026 10:03:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2BA1F00A06;
	Wed, 11 Nov 2026 10:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794391436;
	bh=SgJ/EmvItW0Xtf2MfU9fVv2igwmrCK9D6xMb8nPEVqk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JAas8NftKHwhapG6wdDfEQ7OHn1pMdGTyFWozv15UkYFmQPx2IQDAK+zhO6YP/Ckd
	 XD3sITi5phxQlHpRxA4hxQlKzatvirBHqDhP4TKsilBmQgny8+L7ruptavXWwNMm1M
	 0addY/qm5puIo5wA0Ug6/tfYeDqrjjRpxDagFYkywJT1i29bL/i0cUvzm1cVtt3GeI
	 U5FP8Mx6QJPKSVHlgrf0ApH0JNq/CpZw/22Re0wfyk8M4nOJ++Ul7wdixR+Fxky4Kc
	 nxZIcTkRIJ3e85SKmY/Lyfqq0Kj/C0hMsTS7tf881neEwCbSmxV38AUbDDYB/BHxF9
	 8YiwSozzOgPSQ==
Message-ID: <f39a0ec3-be81-43f0-91e8-145ec139b1bc@kernel.org>
Date: Wed, 11 Nov 2026 11:03:38 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 01/18] mm: free PG_rcu_free folios only after an
 RCU grace period
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kiryl Shutsemau <kas@kernel.org>,
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAHk-=wihE=ioLKrwzz=WQSJg6HhB-syu4hqZ2QFwgnwYmmLEgg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: p4y4ro8swediaxjp7h4fegp3ykcipmu5
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B98E240008
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794391437-203751
X-HE-Meta: U2FsdGVkX1/+VgumwOBUupy1sn6Nh/bai7jE5asT64Qq0epdisBcW75wo/0ENYcp8Yifwy1TEn4INpnhS3vPNI6IemX3MrkDumHqbGt1PDfv+XbAI5RMaiFVOf5NmaFUSXyOA3FyqilSjjJQaOovRHl6Y/o2pkK0ERoUbsJ7J/hZr3mHKBOAmOnl6KO0xCoRI5EMQfa9cM3sCbPHgksFPLwLMJQ08HdXSoKelAI1+6C8d0Oy//hV3rSPVIfBdZUIC1eTNumXgup74tZA7X2uZ48lwTr1mnbJkm80tYH8XoM4S/65ivmH28fo9zTfg4dC+cC1COSbCC2qjzjj4DnXx5u66byLGpDol//Jt8ovmH1HqDAPTqwhvaFTaBEs9HDWirqr575S1Uld1cnKMvZciiTjkYRwGvw314KrjJM+g1hBFUj2tPiACGMbOyFqVIGWprENaExFMMOwB2PwM772BraIllT1KS/r0GZzWssN+F2xtl9/ezTQSqSRBYXP7fU+4GL30phVOHHHyTVVR6gxmSNTmSZsd9slsqbcKUZu9X39MiR/bBIXXUC/0rGHuUHkTcvCfputqaW3JR8iOj/yQqfQH3zqd4bfs5JLQRvkgV4sFVGJpvQ0Xh1Gx1NxNJ9rpwSviuZiQ2Fj8zKCq+9zICNcTn8Wez4++4K+4FRUz4SfkFetPZ60ZNePpHK+Agqi+3An5QGHdKw8RQ2wVXwuddpKH8xxklnhv16mggYoLmF8J6lWIcW7h3A4CrvRbLizEf7cZRngNFeLDNA/s0NB6svGPiipnOW1i75V7U6achlWxEHKFUNPabwLxjCCWiTEWTo2vpT/UIuIN+Mce6TA9rPhmj3dM8dsfoowsK3EOZSSYLNPkea5oi1TrP5uAZE3Q/QJNrXdMT5BVWjmbrgYMdqv+IFiu+p92VNpX/tIVBFWLgdBzp4vJMWo73z73+x3raBnu3YZ204qJS1O2Pf
 v4jIDIT5
 eGhIe1udethAO4hAFlxVzjy3JqmMrLBtz8q63ThfEyCfnXVAd7/5ELme9JPELT1e+PHGEW2UATKX8ghnxKC3t/qG9UnzXsqfUrjwEIuJfyuq3pCzhGaBQKxDQkqwanRmsy1oP41LRf/sDLDMij4YRwatMp1j/Qd/uuKS2sVvvZVsF8BRJMb4WJFfXGWtB8Wu7xp9CRM/mIyRYSlpNUoRoqOeRYQGhNrBrhPi07gTGWy9H1rKrpMzfrdAxKMMxNR2+1ObDrM+fgsrB2xMlMSxZ+i4syrbxgyjyS6FIWV1odw2kw7Og1xvRuNjNUPPs4XSJfhM9z79jKAuAKKCOz10kWQ/AHznnmcqcIvdY+/6cCRBAOT1Rrqvo858ltqbb1u4RRlvmo02+/iGwC1tBHzvauf34pw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/9/26 19:01, Linus Torvalds wrote:
> On Mon, 9 Nov 2026 at 09:24, David Hildenbrand (Arm) <david@kernel.org> wrote:
>>>
>>> I think trying to corral it into some special case is the last thing
>>> we want to do. It only makes things less potentially useful and more
>>> fragile.
>> Let me wrap my head around how this would look when we decouple pages from
>> folios, where pages might not have a ->lru anymore, or not even a refcount.
> 
> So for an example of a place that already does RCU freeing of pages -
> *not* folios - look at the TLB shootdown.

Yes, I am well aware of that handling. Unfortunately. :)

> 
> It's very round-about and hard to tell, but it's using
> 
>   tlb_remove_table_free
>     call_rcu(&batch->rcu, tlb_remove_table_rcu);
> 
> and that then does
> 
>   tlb_remove_table_rcu ->
>     __tlb_remove_table_free ->
>       __tlb_remove_table ->
>         pagetable_dtor_free ->
>           pagetable_free ->
>             __pagetable_free ->
>                __free_pages(page, compound_order(page))
> 
> (and I might have messed this up - this really is a rats nest of
> nested inline functions).
> 
> And in order to do this all, it sets up *another* page just to contain
> the batching (which is also RCU-free'd)

Yeah, I recall some details about ->lru not being usable (as reused for other
purposes by some architectures) and some things about multiple page tables
residing in a single physical page on some architectures (at least powerpc),
which makes using ptdesc / ->lru impossible as well, as we might only be freeing
parts of a page instead of full pages.

And some page tables today might already be allocated from slab (I think at
least sparc64 and m68k do that).

So that's one of the reason why tlb_remove_table() consumes a void * pointer
instead of a page/ptdesc pointer. It's all linked to
CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE IIRC.

> 
> Now, the batching is probably a very good thing in that context, so
> I'm not actually suggesting this should be converted to some common
> RCU-freeing thing.
> 
> Rather, I'm pointing out that we have existing hacks in this area that
> have grown up over time and would have been a *lot* less hacky if we
> had had a proper RCU-freeing page allocator back when that whole TLB
> freeing code was written.

See, I am not sure about that given the challenge with
CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE. And apparently powerpc is using that, which
is not quite the museum piece (compared to m68k and sparc64 :) )

In a perfect world without these corner cases that make our life hard, possibly.

> 
> So I'm not saying "we should unify this". But I *am* saying "look, RCU
> freeing of pages is _already_ a thing, and we have complicated hacky
> things in place for it".
> 
> And they are complicated not because they necessarily should be
> complicated, but because we solved the TLB shootdown after we already
> had tons of complex architecture-specific code in place, and we
> basically ended up adding that RCU phase on top of that existing
> per-architecture complexity and abstraction.

Jup.

> 
> *NOW* it would be actually fairly painful to try to convert the TLB
> shootdown to a new order. But originally, it would have been very nice
> if we had just had a "Oh, mark this page for RCU freeing".
> 
> (In all fairness, we also did it that way because some architectures
> don't need the RCU delay simply because they have some other hardware
> page walking infrastructure than the actual page tables the kernel
> builds up. Not that those architectures *matter* today, but some of
> that per-architecture inline function stuff is required to basically
> isolate these kinds of decisions from the MM code - that deep inline
> function indirection has a reason that is entirely independent of the
> freeing side).

There are some dirty details when it comes to the upcoming page vs. folio split
that I am still unclear about.

The page table example you mention above is another prime example of the
challenges we'll face: page tables will have a separately allocated memdesc
("ptdesc"), just like folios will have their memdesc ("folio") separately allocated.

When RCU freeing, we'll really have to keep the allocated memdesc alive as well.
RCU-freeing the page only is not sufficient.

There was even talk about allocating page tables from slab later, as long as we
can adjust a "struct ptdesc" to it. Which would solve the problem of powerpc
etc. that don't operate on full pages for page tables.

So I might be completely off, but what I imagine is that the memdescs will get
RCU-freed (these are not pages), and once they are then getting freed, they will
probably take the physical page with them.

And freeing memdescs through RCU will likely be memdesc specific.

I really don't know, Willy might know more about these plans.

But I am overloaded with all the Fixes, so my brain doesn't work quite right.

-- 
Cheers,

David

