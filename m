Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD4BB606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fnLEbREK
Received: by kanga.kvack.org (Postfix)
	id D08906B05DA; Mon, 26 Oct 2026 19:25:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE03B6B05DB; Mon, 26 Oct 2026 19:25:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA8326B05DC; Mon, 26 Oct 2026 19:25:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 934C56B05DA
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:25:12 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 236F1806FD
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:25:12 +0000 (UTC)
X-FDA: 85366360464.16.CB0DD6C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5F65CC0003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:25:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fnLEbREK;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793057110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k1Zlag/DNuh0RzHvANliw7JgpC1PTEsuWY1OUAoAx8Y=;
	b=Toxyu/hiS/2vxG8BK2bq94fj828D1nPL+SNFcMqKu3mMEkmN164wR2U6ly9gEC39wVgOfE
	QVhutV36DBekOp0fmBdka7YKAs5ngS1h48plsdmHRT3YV3kodsTxRt7Uijb5//b8M5EMKo
	j1opQr9Aw67qn3PItiYKKd8a76q6Vqk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fnLEbREK;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793057110;
	b=dPl9Zm+kStiWOHoP2ceuyfvn1xeAZeBq8p6hEUBm0QDw+2pr/SO8QGZYwlGMCmuR04e+Ho
	xNzHj66R5Nbew/1iZgh3GirjW8tec4DEweUaM44D56+z+GEMS+Hfz55ZrVcUwWewMFkeM3
	CHhCkbC6H4dtGey4Xfr3bRUqf/oHf9M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B044440349;
	Mon, 26 Oct 2026 23:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE9C1F031E0;
	Mon, 26 Oct 2026 23:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793057109;
	bh=k1Zlag/DNuh0RzHvANliw7JgpC1PTEsuWY1OUAoAx8Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fnLEbREKUCIw3x3D22mrcZnRxIlnJim3GobgkFHE+QN5rPvlAjVqot2WvzRAG1xKA
	 5H7kD8aq2n70G55NtkQDHhj7rYvSZefDvllEGiQIq5tVGRQZnpBGDZwlWt9kr9nXjD
	 KT9w8JmxAv+rDcqcSEaH42DuiiIcSduz+eeDMkp8Eb1qL9xHOOIwY9t463bHSIcHJa
	 qlO6fVGU43GVMPDuQtga3X8z75Z/YHhduXBbnXNHKzHp32YroM2VQCfMAvUvQqY/0h
	 5hSZkqRt/bf2hTQsQcrmxRUn1ge8dnuh0mYqMYmY13+1QLbdmwGOEsVckCCPrZ2ejt
	 y29huz6g4kJCw==
Message-ID: <f0029758-5f2e-4c26-9b25-dbc4b3f33701@kernel.org>
Date: Tue, 27 Oct 2026 00:24:46 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/16] mm/shmem: avoid moving the truncation start
 backwards
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Lukas Czerner <lczerner@redhat.com>,
 Carlos Maiolino <cmaiolino@redhat.com>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Stevens <stevensd@chromium.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 William Kucharski <william.kucharski@oracle.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>,
 stable@vger.kernel.org
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-7-703206d5fa0c@kernel.org>
 <2E377C76-D62C-4A2A-94E3-ABC40C6FCDD2@nvidia.com>
 <583728ed-dc63-4685-9ac5-5a980db55973@kernel.org>
 <B1241F56-8000-411D-A137-24596E599C85@nvidia.com>
 <0D22B04E-5730-4D3A-ADA6-9F1AF94F06AA@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <0D22B04E-5730-4D3A-ADA6-9F1AF94F06AA@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5F65CC0003
X-Stat-Signature: gc6cegib9dtqtfdbe3o1jodohtsb6i8m
X-Rspam-User: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793057110-659740
X-HE-Meta: U2FsdGVkX19VtgDe69kC4gXIDYyhP7swRALYBmnqiZy63RMcKWgad+IDlA1zWRL2xbGq6ZlHqbd+8OtcBlRRul49EL0fMyxgBanS0LYQWbhQN3hdJq7ZQdJnGdR2zWN+NWkbUnGINeNHUngVz78hPLEo1q6icaoOuy3kQvvQpGQv/A9okDj9G7RAjKJdhu0YHwj7Uc3R2kgLaQ3z/Bu+k5IOpAQ+n7JiPPrcRqiEZgt3RIZzu9/kHKmTJwoQATe7TG3+r/wN1R7OgaSnc8v1UvdlxdUhgNv9LabgQVnbKNHzq06E+9M+yRsdPZ/kri0adVbXFdfYsQHAGjh4FTwbb7wiyz0zpY7jqig0mqO8YGf4nbE1Lsrir6GI95tfOfCKq18ixVjnqy6oOjwVDTWozut1mk9CiuKqe46TZKV03pivuI/OopzBAFLyFF3dUcKNFliGBFdAa7Sm8f43OTXCAlIP1brbKqgWZHHekmv0J1D9XSPXE3PZimHMu4Tk332zFlOeG+iQmnJUoF0y7D1y/vKtqTRg+1LrajT6ISesZ/SW9g+Umg+5grMtPiviosLG4X1qQLnhcyo0HEWYtS7BbjdnO0fZnJq3Xp3Z6VG818A+vdX6ncnCyqavjWirmfJfw8+cIYkVAHg+eQsrX2sVuaefXN6iZjxsEgriiU+3kQJwaIumk4sib3cfZzDoMWlX1xLfZAwoWzYO3P3CQ9IcWA7A5SqLfxv845gg9ax6A+bHUqejvl66KkVQzamFHxtl3Uv7rd153ec+63pBlD3seuHxA1A0VSnkiBCGqAattqrQI31bLtRemiyBoCmgYOBsQOwOqbElQWDe1ve+y2fsxVo/sIQ+75IJ3ys3UOuhSTzyy2ZWKPvcdJqz5xG1w3iMhVplciQZ1zgxgAF1Agvhfzsv9y0slsPwyM3AQ2SDw04OwPL9W2vmsVE/Cx9z2hMolcMC2ScmD4DgqQDGXoB
 Pa8Bj5yC
 hPtXe4GTzeQbmhxUXoSLHnIK+Qm8Qcvv2a1usYtBxsRjZ5t4gYG0L9Xa6fU+KlOYd9JHfK5kIXjWjYJL1NnBA++NmyNqu4yLaMhaXZzEVMxpXAyYWxBh8idxFFqyNpnx1U8VTjP7dukKIF9yhgI4UH1gwtSUolkgrTVJPRGE3uzcYiYHy2Hxwo13fMNko305xnPQKH+054pM1Egw1oAydsxNML65bdvZYVop74T7AT6O3evCy8cVpxKi8sVqQaF6qDsiF0ncpzVQqauuxgdCSdIwNNaOaAVOsFVg81AssNv2htLDHZop10wh1GwdHkTILD3zJK6f6P8RW8wC4KbLjc4WD+pQk6hEXRL+rzy+sM+z37lg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 00:16, Zi Yan wrote:
> On 26 Oct 2026, at 18:39, Zi Yan wrote:
> 
>> On 26 Oct 2026, at 17:13, David Hildenbrand (Arm) wrote:
>>
>>>
>>> How confident are we that it fixes the same issue?
>>
>> The issue here is that folio_next_index(folio) used in the mainline
>> code can be an index lower than lstart and the fix is use max()
>> to prevent start going backwards. (I wrote this to make sure
>> I understand the issue correctly)
>>
>> Zhang Yi’s patch passes start into truncate_inode_parital_folio(),
>> which has a new signature, and it is updated with the folio’s index
>> within the [lstart, lend] range at the beginning.
>>
>> So this patch fixes the issue at the caller and Zhang Yi’s patch
>> fixes the issue inside truncate_inode_partial_folio().
>>
>>>
>>> Does it also cover #8?
>>
>> No, patch 8 is still needed. I am checking it on how to rebase it
>> on mm-stable.
>>
>> Patch 9, 10, 11 might need rebase on mm-stable too.
>>
>> Since these patches are on top of mainline instead of mm-stable,
>> you will need to rebase them. IIRC, Zhang Yi’s patches are needed
>> for ext4 + iomap buffered I/O conversion. Hmm, but Zhang Yi’s
>> ext4 iomap patches has landed in mainline but its dependency
>> is not. So we cannot drop Zhang Yi’s patches and ask for a
>> resend. Adding Zhang Yi here.
> 
> To clarify the dependency, without Zhang Yi’s
> truncate_inode_partial_folio() patchset, the ext4 + iomap changes
> would cause data loss. We probably want to get Zhang Yi’s patches
> in first to avoid that.

Ugh, what a mess.

> 
> Patch 7 to 11 do not apply cleanly on top of mm-stable due to Zhang Yi’s
> truncate fix, where
> 
> 1. patch 7 can be dropped as I discussed above,
> 2. patch 8 needs a folio->mapping guard for the added statement,
> 3. patch 9-11 can be applied with fuzzy, but I need to look into
> them about functionalities before fully trust what LLM says.
Yeah, let me take a look tomorrow.

I cannot put into words how much this shmem + pagecache shite annoys me.

What a piece of crap people created here. And looking at the massive changes to
fix stuff, what a piece of crap people are creating.

I better go to sleep now :)

-- 
Cheers,

David

