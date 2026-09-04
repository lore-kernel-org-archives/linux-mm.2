Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52ACEC61DD6
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 03:39:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 686376B0099; Thu,  3 Sep 2026 23:39:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65D9B6B009B; Thu,  3 Sep 2026 23:39:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54D5A6B009D; Thu,  3 Sep 2026 23:39:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E89726B0099
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 23:39:32 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7412AC0721
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:39:32 +0000 (UTC)
X-FDA: 85174674984.01.99EFBED
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id A32E140007
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:39:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=QcO+CNGN;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf17.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788493170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MNwQxIddTEnFNFTYEgM9wD4+3ebO+BflR2FwcYl3w2A=;
	b=AwoK13NNnZ9rpLgXJmJDH+vmXsxV6tEpgI4w9LXhnIqWp8uZ0sdYxRuaEG+aLj08GnmHdV
	c0kQvoCvXO0YJ5PFD5zrQoiDjYyBq0xxposBJw/Cnjro3cRt1r8yEL4eRykqn0f/peKJ+h
	2KZCX3OfSkWmMOLvKKAi4u6PXBNvSmM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788493170;
	b=H7Luutd7Iaz3iJaZEXp2CQW/UCsrde+KG0sLtoW4/Jv9L8A7eN3cSO34Oi+elr2YTRy0lP
	3EzRxKxS+CYGRzNNUmPbeueV6vruO151tNl46n5HAGKKJD3ClKieje7AUxKP8WfPsW1TE8
	Y3eLmSj7T5w4jrwCUHi651XImJKldD4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=QcO+CNGN;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf17.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-84f38f3b36eso407513b3a.1
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 20:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788493168; x=1789097968; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=MNwQxIddTEnFNFTYEgM9wD4+3ebO+BflR2FwcYl3w2A=;
        b=QcO+CNGNWVegKpkSQzsD28Di+vUI8baB/o+3lgG+AjHrn6HvD2MV4YOsmRvw8c/Mil
         b1Bdam9Y/ss6bURMWZNi+MDRaKsd3CVSvEZSWip5skLWqHA+HMc4pC6yvLqYSUwlMBpp
         HfmVUDEvk07VYwA70rO4eYilaOgjCjQS2IDwA7lAK0g4XZzqcrGrBIhHJmHntXjbLBLm
         9LYeR1dk/MtWR0ZZLi0dIZNNgqtmqXmmhPLN8AhpBJZWQSIkSr6cDHa1tGeLf0b+27gs
         BOFF/kHvDuZ0AsCCvycXGDt8XdOIo30IlBfht+x+8KJQWUn8H7OxoNXd9O70ux0uBO9W
         MPZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788493168; x=1789097968;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MNwQxIddTEnFNFTYEgM9wD4+3ebO+BflR2FwcYl3w2A=;
        b=fbOcyUkNWDXxIq0zs8/163BOHB11Ew6kZArrql8lAKj66SE7/gPzGVAmHVZUhubhfl
         ccc/+CVjsEprzxD+Y++oXysDL6PFJHlP137egKknnZssIscYsLMjDfx9EvUVvOJv9Zlb
         UCztC3azUXYgdH1caDrdnNRVbTVt5yJOWCUDAmGVu949j79x+mAQU6fqv1JIDGSIVrXu
         MGKWsPS5GQkU/3T+IfYFqaPu9jOFEc5LvlNwRlDkNP17ship3fwcFdA/UAkLkd/oygG5
         VWM7HTCwAsfm8MPKFEj5MgWZTS4OaCnQoaTZ2wsI2p8adn6t1NQAqXPn85Q+DsSi2Cxm
         qL2A==
X-Gm-Message-State: AFuF++nzaNPB+6sAHl6/jQmtuySB/sYWrcX+Zy6uWlQJ49FRiw8oe+M6
	xCPPT/ynsv92WwK8BsNouMvA5uVppQmDSL/3TG95wqj/oKpzRt147tEI+mEuvC012jk=
X-Gm-Gg: AYBFou0ZZ7Vf1P5CXh177lDKn4lJ/GAOKOelZ9GIdhCgxodohxmUTr5aUe3hJlQZ9b2
	EdcYTDHFk7vGEFo3ylKtLkmJc/ekJwFTEcjFbgPNd7PwBCE21p+RgBnvLi5hK1n/6nzMLJ82RQq
	ZIBfZflCUlDm5lFsQL9tJHdeUTvh9wzymUUOAuQvn/7zyf6GFlh9s2sXg7/xm9p1MRC+09taUrX
	E4bTjtEUx9mky1J6Mfil2khlHVg+xzZ1QEdgWZa3cSchpkVyEXs5O6yGiaCEP5RZsyPMfF1Yrm1
	1IH73n+HQMKdb6CQtd/992WEoEojo2wjjhsO7y2Z+sIzut41FswlLMWW21FZ4ApXyCTXJptCvDT
	2cy8JlsH/2k8YNKrpZjfjU590p7Wd8Nvg7bMucAWK6dWo0NnIyBo4MdViUIo39tV4es+4GYmA9+
	J4Nys3Hu1Kcfz+cY0nZbpuF45RlQyLQcZG4SRWMDgDEjVLy749hHd/wEDP/yj7kFp267Qhsy8fb
	56dQ1QkTP1eR3vu1bbySiPms6BsRuaU
X-Received: by 2002:a05:6a00:8016:b0:857:74ae:ad76 with SMTP id d2e1a72fcca58-8616b46b125mr5070023b3a.26.1788493167991;
        Thu, 03 Sep 2026 20:39:27 -0700 (PDT)
Received: from [100.81.12.150] ([61.213.176.57])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86152e39a38sm603701b3a.39.2026.09.03.20.39.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2026 20:39:27 -0700 (PDT)
Message-ID: <5f34e3e1-749e-44d1-b3e7-50e11f7240e3@bytedance.com>
Date: Fri, 4 Sep 2026 11:39:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [External] Re: [PATCH v2] writeback, memcg: skip foreign dirty
 tracking for bdev inodes
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, axboe@kernel.dk, tj@kernel.org, jack@suse.cz
References: <20260903083303.2769873-1-sunjunchao@bytedance.com>
 <20260903123427.eb0beab18ff68d4632aece6c@linux-foundation.org>
From: Julian Sun <sunjunchao@bytedance.com>
In-Reply-To: <20260903123427.eb0beab18ff68d4632aece6c@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A32E140007
X-Stat-Signature: ggk3k49zix3mboiyd7dwauuxqpad9k5g
X-Rspam-User: 
X-HE-Tag: 1788493169-846404
X-HE-Meta: U2FsdGVkX1/Njejnxz6TAnAnY/69gz1Tmt09h3qjj9WOq81iLp44052h8/Tc1mqk+VIEGbVkefOIRKhouQAi2iBvca/rXd/T6DPkz3W5qFvztST0pq/kIL/6ZE62hoOpbT9FCfTsJIM8bWmB02DEA2kt+y9CqmW8RuhuewrlL2+wQ6PutGo3/ZlDsvZEXpUSB0PX/PyR1OwVm6XlUgBRUy3bkquccRd9LLXvg0a7Lev5C4LSmPvU4rJ6Fp+rm0zvrz9YWuC6ay3N9n6gDJueOMpM1HzshQEkMmjpGNRvSBgkFFoSEkpDBq5G8Wpgj7sG8snqsDJ6NA6om1gS6ZrGK37Ja8gagfKRAON4KspMA+Du+rM/fckmE7fYRUhvvHBARFIcl7vp9kKf5xM9W3Y/FhGZABRG5ZpjJzBkhyY3lKlIwhl3WV7cd62CXet79tgo8uKQr93UsPw1hQyQN5VyH21T9/JHv7kGlVRDygVevgktSXj7f7I+0OrPjxzDs45YVlMICW8IzsiTYFW4Yrr1Luh07ZouakltyAxiW91QUH6tqhtHCXdOfMVkJz5aJT4yC5DpkTkBTqT4KhCun/YdPr5kFNNadVOlKzaWh73XyeB2veBkZxRUWzQNqdgfabXwP5VBE/LocRBMD0J12616bOzaJrNKBbmjoxAtLDBOPSWUYzXyP2KCh05SnxBsO9jmBaZmwOHv/qkeFxp1MtMjpyazTs8Ll2PwVOtx5HdV/oueVOtz7cRpebTgEA77oRphcFwzX6tRofxy/WlyYp0VOF7Z6+WfoZdbQTN6Z4Gaggmb9RcfQCvodUmhnUpPdJLWdarKV5TEqqyKVb77BjJYVzMjTTSiTVhQfVwkRCXKoutknqlW17RfxIpMfLKAniWn3uovd3OH8v3cWFD21cTjCJ1G1iVAgRbrAUevgm7AqMfMd7LC+Sn7n948F+YJDLNyVLEEVM83pcZcw8Pn0f8
 um4t+KXo
 hpNGVfwjo+ZQCfQqUEQQpI+R1vFQ53Tw9gs3BnlQ1A7DRfFCzAGv3cZWdRp0Zs4tQQJCAbP/ovy7jtSpoWm1Fi23x4pKlmD8kona4inGVzTLVZDllIGifvzxaYgqT3u1ab4j0EkwnhVr2BbwMAoOlon0ePWxttAAlUWZnUW/v9PsjjcuM8tJLLM12WWjAoJNCqtJ8XVGT8VLNYGe3dIlIJQkv7CbwFfWXVJAbHHaWH5pHqjzhGlMdIJgQYkrddXNXHavPkrAu+wsxKBJD4+MHNm0kOg63Xi9V/SBgv6Hm211FkC0jIHdnYB3/3H6ZhYifalkjeO+k7d5UVOur0inHBFJPWV0KmYs1vXsDwh7BjN1cSyU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/4/26 3:34 AM, Andrew Morton wrote:
> On Thu,  3 Sep 2026 16:33:03 +0800 Julian Sun <sunjunchao@bytedance.com> wrote:
> 
>> Foreign dirty flushing handles cases where a dirtied folio's memcg and
>> the memcg owning its inode wb differ.
>>
>> wbc_detach_inode() notes that "concurrent write sharing of an inode is
>> expected to be very rare". This expectation does not hold for bdev inodes.
>> A bdev inode and mapping are shared by buffered users of the block device,
>> while the inode has a single wb owner. On ext4, buffer-cache folios used
>> by metadata and journal I/O can therefore be charged to different memcgs
>> while sharing the same mapping. Normal bdev activity can thus produce
>> frequent folio/wb ownership mismatches.
>>
>> This was reproduced on cgroup v2 with the memory and I/O controllers
>> enabled, using ext4 on a loop device. jbd2 repeatedly generated
>> track_foreign_dirty events for bdev folios charged to unrelated memcgs.
>> When one of those memcgs entered dirty throttling, the resulting record led
>> to a flush_foreign event and queued writeback with reason=foreign_flush for
>> the bdev inode's root wb.
>>
>> Skip foreign dirty tracking when the folio mapping's host inode is on the
>> blockdev pseudo superblock. This prevents bdev-originated records from
>> triggering later foreign flushes.
>>
>> The tradeoff is that dirty throttling in the folio's memcg no longer uses
>> bdev dirtiness to queue writeback on the bdev inode's owner wb. Those
>> folios remain subject to normal writeback. This is preferable because a
>> single bdev wb owner does not identify which cgroup is responsible for a
>> mapping shared by buffered bdev users. Flushing it can write back data
>> unrelated to the throttled memcg. Dirty accounting, normal writeback, and
>> foreign dirty tracking for non-bdev inodes remain unchanged.
> 
> When fixing something, please always describe the userspace-visible
> runtime effects.

Sorry, I overlooked this aspect.
> 
> I'm thinking probably "unnecessary I/O"?  If so, has this been
> quantified/measured?  If not, can the effects be guessed about?

We suspect that a large amount of prematurely triggered foreign 
writeback consumes device writeback bandwidth, thereby degrading the 
performance of the entire writeback path.

On one production machine, the total nr_pages of the foreign-flush works 
was 630,681,285, or about 2.4 TiB, while the machine had only 400 GiB of 
memory. Although nr_pages does not represent the number of dirty pages 
that will ultimately be written back, the actual number of pages written 
back may still be very large because the corresponding wb was 
continuously accumulating dirty pages.>
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -3898,6 +3898,15 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
>>   	u64 oldest_at = now;
>>   	int oldest = -1;
>>   	int i;
>> +	struct address_space *mapping = folio_mapping(folio);
>> +	struct inode *bdev_inode = mapping ? mapping->host : NULL;
>> +
>> +	/*
>> +	 * Bdev inodes are usually shared by many memcgs so foreign
>> +	 * tracking leads to frequent flushes which is counterproductive.
>> +	 */
>> +	if (bdev_inode && sb_is_blkdev_sb(bdev_inode->i_sb))
>> +		return;
>>   
>>   	trace_track_foreign_dirty(folio, wb);
>>   
>> -- 
>> 2.39.5

Thanks,
-- 
Julian Sun <sunjunchao@bytedance.com>

