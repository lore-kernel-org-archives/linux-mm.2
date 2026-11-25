Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EA6B606A323
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 11:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K04vPm7L
Received: by kanga.kvack.org (Postfix)
	id 1FF1C6B09B5; Wed, 25 Nov 2026 06:15:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B0B76B09B7; Wed, 25 Nov 2026 06:15:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 077D76B09B8; Wed, 25 Nov 2026 06:15:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4C196B09B5
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:15:15 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2C63F40EA5
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:15:15 +0000 (UTC)
X-FDA: 85473384990.19.D6F626C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4C563180012
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:15:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K04vPm7L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795605313;
	b=kDg8fRzVVcg2DmWI0ngcFIdR78DR3C7dhcZ8VPC+CL5oFt2sjMMjBjD9t9fEEu0LO5h3Yv
	p5fyMbGrQdXH4R9GU8r49Z0x8w0SHqrHszx1lO9rCrHO3jLH0PTMhji4WVRrTZ3iopW5tX
	TU8svZJLrO8FSS1ayK0Q62bOuISr12c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795605313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=auwkFguZjnJpCB7sXs9BgjbEzuKBmhkz5UG1UPVs/U0=;
	b=LdKmv9dwQ9s6cHY3l3FB9l5RSyeXExrPJ8doKH3yhjgYOhi81urZ+lCCXU8aqS+jyzM7xc
	eiS38BWcSgQ2Z24uVJbfOcfU1TcZCMsOf29E43lYBWQ/1Q/O+pvb3GtI+cypQ8kFl/qRcD
	IVoAsbEA5O6olcstp2+tIqAqnxg57AQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K04vPm7L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 66F53436F7;
	Wed, 25 Nov 2026 11:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D931F000C6;
	Wed, 25 Nov 2026 11:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795605312;
	bh=auwkFguZjnJpCB7sXs9BgjbEzuKBmhkz5UG1UPVs/U0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=K04vPm7LaWVWHmWu6GpbwYZvyhrtZ/rWgvMLEPL2Ai5OEw4CHwelX/sJ81gHpwsPF
	 Sxgw/ex3Ydj7xrvmMrcHv07i13nTxE5CvbWmQHsMe7RzULazyvHiwSU0BaKb5fMHWY
	 rp/n47hB0buT7UAI6LR7a2g6ZnPjGduUe8fNY6pTkioSt3ZDow1PFiNrlmDicL3Qfb
	 vr1kYs+oEl6hOT5lRwrA6EvIk0hUkQIwckFmHFa49GpvIVH+gzrB6UgKmPFnHhzizi
	 OK48F6YaiMj/eC+6j8HNjutlyH0qb4Vl88Hd3B+cFT7GNYqpzaUM8oVL0fnl9ukbx4
	 ef8+9zHZy6r0w==
Message-ID: <413a7751-a368-42fd-8983-c3b44a86fd0c@kernel.org>
Date: Wed, 25 Nov 2026 12:15:02 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] mm/khugepaged: use NOFS while collapse_file() holds
 folio locks
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Zach O'Keefe <zokeefe@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Hugh Dickins <hughd@google.com>, Kiryl Shutsemau <kas@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@surriel.com>,
 Song Liu <songliubraving@fb.com>
Cc: "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
References: <20261125100058.15200-1-azpijr@gmail.com>
 <20261125100058.15200-5-azpijr@gmail.com>
 <8c60bed8-6857-4361-91b5-c8fed8a083c3@kernel.org>
 <66fd4450-6e17-4a1c-be76-38758a62073a@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <66fd4450-6e17-4a1c-be76-38758a62073a@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4C563180012
X-Stat-Signature: s8n6u1sf16q4yxxdahnjs36hyk1n5z6p
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795605313-52752
X-HE-Meta: U2FsdGVkX1/DcnVbtAH+PRBsaBoJQh/kljsDlvtwJoTDt1Acava9OGCMS0UjAdYva8bAdAFGcdLTPVGG0LrzROpyhsGJ4Rumpa/rj52lEE/WVit26cZhFWDVxe0e8QiGalhBGjp8tAyPp1mvSZ86Q3VZTkHVa7Bf9TNY54s66WGBJCY5tp88RhhYqL6AtZ/T06hKVdXHZq/g9t3XBKAh/IwzHnAfN7JTpvFrcPNKkZ+0utFYOgjRZlemKAyiQVfBKO1GmHjNMY9nR7uo3yjlH4lUbIbuO+NCEqtemKPCn34YitbmPAihZ9U0ZJJ3Uo56WLrmE7WYbZTUb0wdbNRDiFGuWs5vclcNMhVjcjLreR43rkFj97jq0BWIjhcMoWwtfGHKjnXEx0suKiapUyfLsIJR/tPV5dzR3a/WXGWuJGtEPDUsxtwagvp3hCw0A5kN74NNC+gBOWy2EFzYcsU0z+ZgdVpm/4JvVBP1SWpyM+9A9Qe5AZwNr7ZOq5PwPw1gh3zaaZDcNWRdpMgcJGvtobeMTMGz+yjKzdL0Fg+ZolcUQVEUldxsm0t/W3Ek+1gYpHRQvnyVQZ374IQeHXAiZT4/3IftBmV8g60DZHLKaGsrrYahaKqhinSOFgEs0A0LH5brZ7SYxdXbZeFQ0OYbRzxjtdq/PVYJE/iNXBP7pGqToqQPKg029vnrBSVOcQDsqdQj3V/J9Zz9+FlzoaWXyb+X3TBK1At3QE9KD8rx3xIpebYjt/Ld96rh+pj9e2f50hnfxP0nnEps5WTFoEmEQxSCob1P2PK2YXk6w65Cv/3eS5tSnzpB97kVAvkQabSB1+oVJRhmjpLvGl23HZuHhPPzUiJSDb0958a4cv/AX/yPl8Ai4mnPBr4I58pJd3cgXJruEGCspxefqFxHHy8uHxeXAdY6ZLAXkv3TZPyLoiNBUyBa3O0un22Qku0w6/OTHmnTOmoU+EAyuw9pa/t
 vceMD8Vr
 BUO9GXoBgexB/fe+7UGf2S//zGoLHNVBgLU41uWQfaNJ9nUpRxPxC45LKNugiHBSNTLVV21W68EjfOVCKzsh1XsR3SNZdPPaWu5WpwMS5A1ybyxlEbR6ijWYylZTdUwZum63b2DHlzyltAiKFQa/6eRfv7VtHV2nZ0Hm2tNYnb4kaYlDZgIpVai5HacyVahNKwyUg7n0X/s1p7o1La9R5D8dS4/xQUpD+8P6MAUagMcASifpTUOri8m5TONHV4U8e+svcRqKVuPVh5k6wwaDCr/qRIh2Lk0F6izJikbbz9Ww2AuowOhZzE0/o6RGz+B7sN5CDtLzslvsFSBRi31bOeMSz/cFATu1bVioWUYOg8Sw0XQyJRCie0wdNJoOh1Odi5A8tfp4Td/Vds8urEDlxUnU7qlQY7uFyJ51C0d542e56+eM5RKYdx2dkAKWv+1mV3ND/shT5xQbz3Pu2K+hSxoPeOzVorANPdHUXjYF1FtK7PW9+ZHubd9O/cw9YLoK2ou7uEc95XvsB3P2nxuO3hzzL3wEHG4sFLVmnesC8KQ5q8pJX1AOWetJ9uA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/25/26 12:12, Jose A. Perez de Azpillaga wrote:
> On 11/25/26 11:55 AM, David Hildenbrand (Arm) wrote:
>> On 11/25/26 10:59, Jose A. Perez de Azpillaga wrote:
>>> collapse_file() keeps the folios it collapses locked until it is done.
>>> With those locks held, it calls filemap_release_folio() with GFP_KERNEL,
>>> and for shmem it swaps folios in with the mapping gfp, which includes
>>> __GFP_FS.
>>>
>>> As when splitting folios, allocating with __GFP_FS while holding folio
>>> locks can deadlock in direct reclaim or compaction, and __GFP_FS also
>>> lets filemap_release_folio() wait on the filesystem.
>> How is that possible with my fixes?
>>
> 
> it isn't, sorry. I'll drop 4/4.

So there are no other allocations in there besides the one done by splitting?

-- 
Cheers,

David

