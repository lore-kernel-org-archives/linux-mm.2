Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E143D606A335
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 17:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iDxqQhow
Received: by kanga.kvack.org (Postfix)
	id 0EBD26B05B7; Mon,  9 Nov 2026 12:24:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09D626B05B8; Mon,  9 Nov 2026 12:24:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7E6B6B05B9; Mon,  9 Nov 2026 12:24:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BAA5F6B05B7
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:24:18 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E4A47A841D
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:24:17 +0000 (UTC)
X-FDA: 85416254154.28.FA04BD7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 26A65180003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:24:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iDxqQhow;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794245056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/aSAxr7TF1nfjT/HWiDs+7ns10jo5fbdPg/x0SCDIHs=;
	b=6+i62RpNjZfNW1F38rP2KXDxBisvJfTNXsqjUWXKDtIhnQuraEcpps3Jg6pwneOPLqfiac
	N9ULNJJnNMJCdCS6UOo7EPL17Rg9/ZrDxaUfRu3sgfR02RndEcUmY6IK9730NiXJ/VwG0/
	ci1dIqeNXbpxpAb2Si3V/l7fOKlwgPo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794245056;
	b=W3QWjnaPT/Z0YYASdGl4qqwkxKl+yfYz5Vuy8kEYhrUliaJxY1PvggSFgL9E8Wc3l6zTHS
	A3x5dCzqrDzQrVmaEGeGV9NRwWEgcQViskas06lOoGXp5Fm2GeH/D2oBSF6t6NqMLLPnD9
	Qvdv0cvyxM3p5J/FTXX2H/8NtyoHfRw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iDxqQhow;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6189E41607;
	Mon,  9 Nov 2026 17:24:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2FD51F008A3;
	Mon,  9 Nov 2026 17:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794245055;
	bh=/aSAxr7TF1nfjT/HWiDs+7ns10jo5fbdPg/x0SCDIHs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iDxqQhowEYVH36uK8isMhxGwgKmT4ozWL9rSdUjNWzrBo3moZtLoNOSvoVSUND1DU
	 Z8AD+H/zvOBRivvUcXJxAh4a4AZz2ZNDg55SbcCfObS90h8dUDN60lUYO71TVIOhY8
	 Y1GstciRTQt0rYz+zKmsbn1pPvifXUMe1fnnfIkU4WLLMhL/c/5m69u63sLKRX8XVk
	 1AV+QUD+WE2Xbj8s0b+cviQC7bEr3H1n0iHRSST8nMw681/5s+LA0KtcxsuqbFQW9c
	 6tqcoOl7W1dz0n+qVrfeJE8TA1jc4cLRLlL3cWGuak+W4c9NURwTpeu/h+DCgKeTV/
	 1VzI36dbDHEEg==
Message-ID: <8504e28f-faeb-41e3-842e-0cb74d1a25ad@kernel.org>
Date: Mon, 9 Nov 2026 18:23:58 +0100
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAHk-=whnH5qLJH3Wd3bOxv--Ei6674Jo4iifGD_MqzyJg2Jm4g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: s9xxznfcogbr4nf85djqnppff9zf7zom
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 26A65180003
X-HE-Tag: 1794245055-961561
X-HE-Meta: U2FsdGVkX18vxPY4a76eSaA13mCfxmStbB6tY6XnlNg6kgvxgY1j5un1K/bts6hNbK6Yqj4viRrc0ErUNIW3j/G0XE3FTE1DA78x1Fvm0j6OSVQEZZMIo3HSD4DIW6x0D3EEj9w9GQQStGXebdJTTDQHafyjE+u8oMIm6trNvJC3OdK1fjvUFWWglhalRzhKeMoZ6dBa/X3NCzTxDiEsHaoryWm6uYM/UmCp9NkvAm+LVehzedywh9vO7aBUy3pcTs/onNdp1FuyHchnitlokyoniVIJCAcJtzgAz+P5GhZX3HUiH2/QoC2IHk6XJU+iUbDvvzbobJQqGHCGWq1LDYU2ZbpTcpQqVFf6E3y0ckJqIdWjmI9DLlJvStKNQYQw7EfqfRvo3Gq57Z3FV8n9WbuHeKWH8ACc8UZY/KCBAcY4zNtmVeXXRUXZ2TmmVS4uBJulzpqiD31h72+A5dZTUHn6gYAh/HoFs+nryLyawiqAWe2BCzTdVJsarmYX5vr6HH9cuIQUlV5P01mXzeJO6S+Or6HrXS7ZE5hl+ElTkNTmuP7X9pbfJ0b5eP25HKZzrWDxlAT4YT5gT98Hlo2He12re40L4Mlx3kt854lz6ZabyCvkjZSm+sGfOy3ZqoY0oj95vx0eQFtHhEqoV+IfbZCGk6sG9w79DjNO9fT8x3H8CQe21j53Y+sTDeIVxkpY34/8b9azKZNcMWmvF9OPFk3rB34Otwq8KF0VhhnutkRjiKs+P0VgdoMaZMC53O/NArerOEsArDSzZ+fsjV22KoeX1FW4y0qE6n7w7D82HmahsllqKAJL4nmv2/D9+koCKgwKxTQn/+TsyPbV8eeu2MjeUpzU8jEi4BuddPwXMnBDh12Lpm3F/NCS9IjdWHND8neZ9xLbHutfyVHffg5RObPjLfxVsRba+74/QnveNHJeFPWIirghV7nKPlMcmgp7WI/5YlPNMy4Xod6IV4W
 Bjttj4GP
 8Bfb3iyHLpkwgxYl09dL+5pGucquWrXyr6LoucTX26ZjQZcaQbQ3rGu0/dv4qY63IfDrb5n1+472bnxbDH1AmWlWamJMvuTEBATFz4p6WWPI3E5Hj5Ywm8K9p0m3oNaamZXMtCRnAROWemFI1OZiDrXJVdz1CnfjoPMU4cybM0hwUhZC1CzAaagB20VyFLBcR83gl2ebEbeaV3dLyAgQOUahwMRX2HTeDR+VUTda4sYhbF8J0uWbI5bL/gbkVxZeX9yY0Xu0+vobTRkuuilOEUntNvxmqWqCJik0z8p5n1uTpgEzCHh/Wh5lWcxaUGX9T5huuesKT1ejgL5xfFWPuglKCLgDGV4nhq303Fy2Nd7fJ6ck73ox7jecdobkGYJTgDBlG6cx3JbdIhID3uA45eu8MPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/9/26 16:56, Linus Torvalds wrote:
> On Mon, 9 Nov 2026 at 06:43, David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>> Can we just rework that code first to have some clear folio freeing path, IOW
>> doing this in a folio-specific helper?
> 
> I think you're making things worse rather than better.

The current code deals with pages vs. folios in ways that already makes this
code only work with folios even in the short term.

We'll be starting to let page_folio() fail soon on things that are not actual
folios. PG_folio for that is already in the works.

> 
> The whole point was to hook into *one* place: the page freeing.

Right, and I'd hook into the folio freeing path if it is folio-specific.

And we will need clean path for freeing folios either way as we are starting to
decouple struct page from struct folio as envisioned by Willy.

If we actually manage to make this generic for different memdescs in the future,
it can obviously stay on the generic path.

> 
> Trying to make it specific to one special freeing path only makes it
> fragile and less obvious, and results in anybody who then uses some
> other freeing model to miss the RCU thing.
> 
> It also means that suddenly nobody else can use the RCU path for their own uses.
> 
> Look at all the kmalloc RCU freeing: it's used all over the place. RCU
> has basically taken over the kernel. Every single performance-critical
> lock-free area of the kernel wants RCU freeing.
> 
> I think trying to corral it into some special case is the last thing
> we want to do. It only makes things less potentially useful and more
> fragile.
Let me wrap my head around how this would look when we decouple pages from
folios, where pages might not have a ->lru anymore, or not even a refcount.

-- 
Cheers,

David

