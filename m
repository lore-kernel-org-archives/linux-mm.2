Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4ABCCD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 18:38:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 266826B0005; Tue,  9 Jun 2026 14:38:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23DB16B0088; Tue,  9 Jun 2026 14:38:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 154766B0092; Tue,  9 Jun 2026 14:38:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 04BE26B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:38:26 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A86B81C2F03
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 18:38:25 +0000 (UTC)
X-FDA: 84861234570.26.C46E194
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id C3F8F8000C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 18:38:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ReS0cNxu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781030303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RzunsuXM/BmGhSTvSvdTH3BVKFXN4EMIUO99GMhQnO0=;
	b=e1oJakcDnorSnyCRhKRdZMynl5Dg4t+2niJ706RH3BmGN+BgpEmnzBNstuP3Awo5+4Oj5n
	VCjgJyXUPTGXpvwjWlhUWcmZXMBTPG1UEdGk2gbTjgc7oDwyfreQdD/gTsLtYjUp85h93I
	IAWdaS6EN+r3uOdY3nGBL5Rsq+GOTKs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ReS0cNxu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781030303;
	b=S2Ak6t6RUMbPldoerSYh6RI+qhhrJrTeIZRP2bl7NKLud/vccwR7Zm5ALPgOBf/uYjCgxB
	lfn04cDB0scjNKXM1Ld5JQBqJKiuUSJUPOu9P0rAn61hpWRpiMA/kxA/PuKu1ZtWqPyGXS
	rYtB/9/wsQtMN8LejJH3z4zJCZp16VU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D996C405CA;
	Tue,  9 Jun 2026 18:38:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D52F1F00893;
	Tue,  9 Jun 2026 18:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781030302;
	bh=RzunsuXM/BmGhSTvSvdTH3BVKFXN4EMIUO99GMhQnO0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ReS0cNxuV3XtLmj4dzpz4jEfcWJV1nd/wJgsnVw/xFfmlVLsVgqpBeLAgS+jHfXXT
	 vV3990K2v6CpEmI9c+iFk2O0pSyIOmyWduvEqM7y+5zQKoLZSeCp4rM1CWXp1mMpqs
	 KjBTvy0PW2yHhcQ8G437QpsnSDwCMbSBNVeVXn3z0oyvcOBuwd8+QyE6Pl6Oi+LGIs
	 N93vP5jwLyYaacUkQYqTwB6ycmOuc3msqDPirfoFVbL+OvyrPch1poQ3z2TPAh/bs8
	 XNjFsh2Y6tCJRQDBhs0PNrhHBL6b0tVl5ynbx5AvkBJA9u3gJxhkCK5wpoxRDibXzs
	 cDrCJAIN6XWiA==
Message-ID: <8c1f468e-b50a-487a-a267-8d1ea5a61c87@kernel.org>
Date: Tue, 9 Jun 2026 20:38:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH splitout] mm: memory-failure: serialize
 TestSetPageHWPoison with zone->lock
To: Andrew Morton <akpm@linux-foundation.org>,
 "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 virtualization@lists.linux.dev, linux-mm@kvack.org,
 Andrea Arcangeli <aarcange@redhat.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>
References: <df06b66fe4ff8e925ee0714955abc2183a727b90.1780998980.git.mst@redhat.com>
 <20260609111020.e88f51a7b6ebc37360d66fdc@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260609111020.e88f51a7b6ebc37360d66fdc@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ixdxm4hxzmydagbp7kpwtz5mf1zjh1yy
X-Rspamd-Queue-Id: C3F8F8000C
X-HE-Tag: 1781030303-790761
X-HE-Meta: U2FsdGVkX1/hAiQhK3J1kbN3rSGB8t0F7sgf8nRdE/H2CHMdsXwcTBSJquCJ6D4kgTK3kfR1QqWDV0WsPb2uaU5SXBOhQEfvEZ1iggxnNjmSkzkTfhstQM841i/b89nxmjQ8mWa1OzXfedpI5Kapu56E1o9vKrwirtLF4hNP1NAzKHefQufDGD1rDE5fS6nixl0LyOMjynRVcYH+DkbsZ24LLTtD7D8t8k6/+sqwUg6UkUEpan1gBm4dvLWTLFnXZrtnTnaWb5MnNBAL7bWc63r67XEYDbwjAcucUcJipXWRNNb2jDbyd/NFmHQllyVXmtSGwWCqvkYPQnyiG1ISFtG8/QyM26GUZ3T7F0oqOPNXuTqTxekdroBG0gdRWtPf74G7Yuc8qhPr6PVrG5M3kmOgCnuofCJR/iBaaP7ieHU4evuP6BmwCAmLPUCM3wUsRsvtIb+PiX6yH3VN4q1FZbFvqJLINXK3URkY1wjWsRaHMkCm1kHamo+SgqTJ2ZhRVEX3Sk3S5TInh6dFqxVt2Z4BN9b5O760Gv7dDezs3ydM2jrxqKqBtI4HX2QKDuOsjeZQKhUyai483QRw/1GKu+2pltf5jf2oz3hIfZZ9QAAAiZ8XkUqLVoNwW/RzfB88vuwbV8WPpIq8/p/tDk1P/yQXjmVXpm37FYyBz58gWlLH2+610ftG1t3rabKZ8C/h7Pte1XTWdKWRwwbJYHSFXW4zzaia263VcrR7vMxs4kUMz4wlLFzudaepN33HZrbDTnu/2h6uZE5qmrmFvMLr8bYTxGRK1Q8xs77Ub+n5T3/T6M82wIVx+fkJ5mnDc1lo+In8yJQvh7Vyli1tI8fTasQ261xA+DeOWQ4a0TD5k3gvnUp3zdukOYlOQ+3i9YHDf8NIib5R8gNlWspmBYH2fQCaJ+ztDJaPBNGKRyuH7jCef8tCm09du9ziomVSvPPheleTDXOlEOyZaism656
 p3jtI82K
 XPEqycolqnHfuO+z4bFt4t7gqxCpKyUnb0Kl0a12cE6O/RLom8nNtwGEyRXqyULqyb0PCSSbF9bVW0SGcVwsGk0NabbII+983XfehBm2C+2y5PPUYL3dzKgYqmcvlb4P4TpOmxZp0VOlBPnRy7q5r8K8Q26xXS1NfrSS8DekdUD/gu0YSJ5RIdiShD8LGFzKG63SxOaMDMWxqnyW6dqO3KpLFkuKJOLiWiiZ9U5E8xbKOsy1XLnS7clZIe52KVKvkbkFsU94qZxglPU0uvnwejs+yr8y5zExBHlzPdImRp8aDnm0LCRwRCKDbhq5PNgXbsa/PVsQIyAlcMqLMtC3fS7Uv4joUGPdFrUnlgKu0w4ERf8S5obcasWuaXtdY1Ch61TM3mNrf7o33iuVUd9iYHOyAL9gDGkjb7Cwr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 20:10, Andrew Morton wrote:
> On Tue, 9 Jun 2026 06:12:49 -0400 "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
>> TestSetPageHWPoison() is called without zone->lock, so its atomic
>> update to page->flags can race with non-atomic flag operations
>> that run under zone->lock in the buddy allocator.
>>
>> In particular, __free_pages_prepare() does:
>>
>>     page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
>>
>> This non-atomic read-modify-write, while correctly excluding
>> __PG_HWPOISON from the mask, can still lose a concurrent
>> TestSetPageHWPoison if the read happens before the poison bit
>> is set and the write happens after.  Will only get worse if/when
>> we add more non-atomic flag operations.
>>
>> Fix by acquiring zone->lock around TestSetPageHWPoison and
>> around ClearPageHWPoison in the retry path.  This
>> serializes with all buddy flag manipulation.  The cost is
>> negligible: one lock/unlock in an extremely rare path
>> (hardware memory errors).
>>
>> Note: SetPageHWPoison and TestClearPageHWPoison calls elsewhere
>> in this file operate on pages already removed from the buddy
>> allocator or on non-buddy pages (DAX, hugetlb), so they do not
>> need zone->lock protection.
> 
> Sashiko is saying this doesn't do anything "Because
> __free_pages_prepare() executes entirely locklessly".  Did it goof?
> 
> https://sashiko.dev/#/patchset/df06b66fe4ff8e925ee0714955abc2183a727b90.1780998980.git.mst@redhat.com

Battle of the bots: it's right.

-- 
Cheers,

David

