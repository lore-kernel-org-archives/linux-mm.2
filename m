Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80E0B606A328
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 20:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=RwQPWwj2
Received: by kanga.kvack.org (Postfix)
	id A06816B05B2; Mon, 26 Oct 2026 16:02:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98FD26B05B3; Mon, 26 Oct 2026 16:02:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8302C6B05B4; Mon, 26 Oct 2026 16:02:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5B3686B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:02:31 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D0D5BC083E
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:02:28 +0000 (UTC)
X-FDA: 85365849576.30.E26D4B8
Received: from mta1.migadu.com (out-163.mta1.migadu.com [95.215.58.163])
	by imf27.hostedemail.com (Postfix) with ESMTP id 58AF140009
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:02:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RwQPWwj2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of nico.pache@linux.dev designates 95.215.58.163 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793044947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N2COgMJdxeQAvx7S+Q6UBvbh8mW4nF5CYPzexiu1PKI=;
	b=CjpyxKfr3Ydbdjtp8Di0l4AB++Pm1mI5jVsM/6JNkkX3Uohjvz+RgwZi0zgjmXYSriMd31
	CTszf4yc4+whimY8Cty2iQlvOOcptpek0fMx/ku+ZjD8NM5kQNTr1CDAKEnMNx7o9swusA
	yLYNcmlI2B9/I9oRWfO4SL70Fjswgi8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RwQPWwj2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of nico.pache@linux.dev designates 95.215.58.163 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793044947;
	b=Usm/4KREU8o5OJvjLsGz2Qa8DCNHhqM+xmxByYgT5MSHxyfVHCWZEzPRDewzxu7CBC+8zG
	ux5f+LgCuiC/U4pc35srIjKAOtZMpZTi428cRobnu7LacCsyQy6hYtVgJhd2yO0a3YIoEa
	VOOddS5V/2pVO7s5BW4hB8YrPsqwfRw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3c5zx73qa9zbzHK/OsBfgB2TbAsXfenQkA8z7M0+31Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793044944; v=1; x=1793649744;
 b=RwQPWwj2gNAPc2T9Da0Ydt7uByrbnkZxx893QmEYC78jdsFuEgrVG/Kz8kkqwubbEVmakYnX
 F7O/IQde9Y6WKxftAjM7IBrsfIwVzA6bUDD8otYjayJlk36aIPQBSVNtpDHgmx9MtuV/plrcJh2
 HZxw+2wIlJDc/bkdvmwBBr/4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ea248a7b7212ccb7;
	Mon, 26 Oct 2026 20:02:24 +0000
X-Mizu-Trace-ID: ea248a7b7212ccb7
X-Migadu-Flow: FLOW_OUT
Message-ID: <dee39669-b726-480e-8ca6-10f19512da68@linux.dev>
Date: Mon, 26 Oct 2026 14:02:19 -0600
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/huge_memory.c: skip zero-page remapping when
 underused THP shrinker is disabled
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Yu Zhao <yuzhao@google.com>, Xu Xin <xu.xin@linux.dev>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Usama Arif <usamaarif642@gmail.com>, aarcange@redhat.com
References: <20261025-b4-ksm_fixv2-v2-0-8b61ad0491f1@linux.dev>
 <20261025-b4-ksm_fixv2-v2-1-8b61ad0491f1@linux.dev>
 <CAGsJ_4zUVpBJazRxc1CzN6u5XvpUaGnaf-_7JMz-rGK_ZTYMtw@mail.gmail.com>
 <e865f7f0-087c-4fe5-b729-6e6946cd20f6@linux.dev>
 <CAGsJ_4wp_jCtCeMx39nW0Z1Jm5pja7_V6XNwLB6p7zTan0c3VA@mail.gmail.com>
Content-Language: en-US
From: Nico Pache <nico.pache@linux.dev>
In-Reply-To: <CAGsJ_4wp_jCtCeMx39nW0Z1Jm5pja7_V6XNwLB6p7zTan0c3VA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 58AF140009
X-Stat-Signature: 8a4yn37sumc6y4mg8grbat4a1z3j59mm
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793044946-580124
X-HE-Meta: U2FsdGVkX18jjvYaraA4O+cO06JKeBw40PAefoLZ8Q0RPyvgn8ITvBGBZML+K/Ct6N7N5ztKbi71MvZLvCkN6SReClj7EuHKF844QgcdtebP8OMQ7YlDEUfeqMEEy1tDB4BOM/bb/jDTPLgxqNRzg8VTFf2TO7MTYZpkkZ5GStn99xmR9eZnowZhROhzBvrIeDcF9tQQ8x+xwcpS5LexDBCNj9EK229gklqLxwjmpMkJruWmqMXTKz8tB53dDHaWp3rQz3R+1OfrCa3LSxB0Dj+W94CWkVkezEmxM5gcz6g5Ae4dGHwd/Sy99bDbt6uYZH5stOYe/nfMJS/x6DW+9cLXFJ2HpPJiCTa15QNeedWUnwdQGNWdygDEd+i9u7gQb+MfjaA3b/XhhCvRL9wkeINVJb/H+q6Fnhr0G7mB0qHi9dAc3PcuHyYobVTIwgHO91YXaJppvb9F9OLOS3NnS20zYz0CVl8/lnvpqnXYePyJErKybM3YXLeEiNwo4pDunrnFGzhQL/k02NAY/c/UCLQQIo8Px1MSCef4+pmdewBU6YP2ME84wU+kdJMMgE9SMOFt136fBuwUmXfogT7EaJdoIHMbBEeHxS/7jTI3ALBSWKwoUmX+JJsZMGZGETBYlMKQewHYFsUzVq5Y++jrGiwiP3GkuGsIkZbRqTKMG3rp4O/xYN19H6gW3y3zoLHK8mwVaTDhtaYOEhfsIwfXx4CnKjvno23VI71te0kZgj/3RXpKMVAPx2MNOjKOBF88TSB26t8t1dpgONMzjh3YP39DUfaEGkqdFHFIki27Rl6wmdfe7ahwO5iNPqjZ0QIZ4SQUGT2bC+8Ik4E1nwoHRRjrevR+FItPY7T5sBVbHkJeMrDbNF6Is1N9CG65r6f2QQz26fnSZNLW+7YjrGg9sdpc6DBnZiYgwFkiLxVXjO0xI9E2vzlgCXl+VCZS4nJ0SHrcIoWbrR7V+eMxgoc
 hbmmMtBu
 Gjp/v+c5NQ6m+bSLGDWXwervQSOz1dBfgIS2SfIxU3UkKy07vWqTBSf1faAv9pClRH97xWI5EvdsjhQNgNWtSlG4cZ2YdvrUIjnpbTJovv5YsNw77r+lmsFiGjITewONzFbz1+zZ/3ek37yVbGq3G7hWn0P+6Q50K/8AYsHG8MHfry8PvNP9wd7mKRnAqUzm7U0wKkHhMYOzR3nW1xu4Y+7+z2C/KrrWWqA3z/RVKzGNVAaHVw9upMG5m/PtUnJBj/eTBTxpbmYoCKp5xMKKoduC96XNLJUvWVyQGwIW5C6/dr9IVuOMnhZ7h8OiIZFjX0W2v9/kF3qec1TgWWfW6swo3CY/9tTG5ZmGPsmzN0Qy3FkDf8AyZpHRUhgiLbrvTfh5hA70LnmhHA8OvpI7f+JgKL98UJyoo6xRx80ZRRT7hEOaw95ILknsCR1mGc019RZniJrFwgChq4uQdgNavwqUJCK4ByAxNNUnc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/25/26 10:52 PM, Barry Song wrote:
> On Mon, Oct 26, 2026 at 5:48 AM Nico Pache <nico.pache@linux.dev> wrote:
>>
>>
>>
>> On 10/25/26 2:28 PM, Barry Song wrote:
>>> On Mon, Oct 26, 2026 at 1:40 AM Nico Pache (Red Hat)
>>> <nico.pache@linux.dev> wrote:
>>>>
>>>> The zero-page remapping in __folio_split() was added to support the
>>>> underused THP shrinker. When the shrinker is disabled via
>>>> shrink_underused, gate TTU_USE_SHARED_ZEROPAGE on split_underused_thp
>>>> to avoid scanning subpages for zero content unnecessarily.
>>>>
>>>> Suggested-by: David Hildenbrand <david@kernel.org>
>>>> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
>>>> Signed-off-by: Nico Pache <nico.pache@linux.dev>
>>>
>>> is b1f202060afe a correct fixes tag? as
>>> commit b1f202060afe has no even "split_underused_thp" there.
>>
>> I believe so. IIUC these two series were merged together. While
>> 81d3ff3c6f7 introduces the toggle, b1f202060afe is where the behavior
>> started.
>>
>> I guess you could argue that the Fixes should include both?
>>
>> Not entirely sure!
> 
> Thanks for the clarification. I guess it's fine.
> 
> BTW, with the code below, we no longer add fully mapped
> folios to deferred_split_folio. So the scanning code only
> handles partially mapped folios to set up zero-page mappings
> for their subpages.
> 
> I'm still not quite sure whether this is really harmful, though.
> Am I missing something, or was there some discussion I missed?

The issue is not in the actual shrinker code or the deferred split list.

The issue is that any split leads to this zero-page remapping 
indiscriminate of the actual toggle. The same way this toggle is gating 
things going on the deferred split list, we should be gating the actual 
zero-page remapping too.

There were two pieces to the underutilized shrinker, first we check if a 
THP is underutilized, if so we split, and the split+remapping handles 
the freeing of that memory. However, functionally this also made ANY 
split do this zero page remapping, not just those coming from the shrinker.

-- Nico

> 
> void deferred_split_folio(struct folio *folio, bool partially_mapped)
> {
>          ...
>          /*
>           * Order 1 folios have no space for a deferred list, but we also
>           * won't waste much memory by not adding them to the deferred list.
>           */
>          if (folio_order(folio) <= 1)
>                  return;
> 
>          if (!partially_mapped && !split_underused_thp)
>                  return;
> }


