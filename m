Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4B23C61DBD
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 03:08:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08C466B008C; Wed, 26 Aug 2026 23:08:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03C946B0092; Wed, 26 Aug 2026 23:08:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E970B6B0095; Wed, 26 Aug 2026 23:08:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C89596B008C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 23:08:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5D601A02C7
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:08:42 +0000 (UTC)
X-FDA: 85145566884.18.D78C0FF
Received: from mta1.migadu.com (out-153.mta1.migadu.com [95.215.58.153])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5A78020002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:08:40 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tLIWahFZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.153 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787800120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TBTevkLtBQYfBGrZL7q8D98wBgw40SCkpQHlduNMoPI=;
	b=RaSOIcqtTZaGhJ77WAwlAMK/+tLmSNz93zAE2tS7WZeMbCsGnKoQRkhSUcjsPg9LmUWCTf
	+RlclEvdHr+ktbMhHbNLcC3aXyBl5g1uzvrvsD9TX0/uyHROnMDBS9IwlkraCpQGS/+mn0
	7R1ykDLKylV2nrw0jzuPki4ssh6hZL4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787800120;
	b=f4S/rAEqK0QNmWock1VmaLlGfiWxKsr0SGgoKkbSQAjNfaYu1MwOSaWG0Pt3NHjvcnguYX
	FIf2inrEZlCaMe8bTy9HacbNI1GabZnky27N+Aw2ZOy+CgB1ZUjJEnEI2Z+FznVxwp7t6s
	aXu7A1tfd8fXlUOxWD5hygzrzbFmSQI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tLIWahFZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.153 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TBTevkLtBQYfBGrZL7q8D98wBgw40SCkpQHlduNMoPI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787800119; v=1; x=1788404919;
 b=tLIWahFZd5r7cgmWL3RR7N2eFLVUQvS/eO7RRo64IOZlLgQ4u4BZRXlmnmEjuIXdOSq8VlVR
 3t4mdR7o8KDvjwo11aYWN9ui6CiO2l3h84CLTWiazXxk6s7QF82+uOkLQIsU1j0KUu+OiPNt9m6
 D7QfgpjWe+myCMkH6bsIiPCc=
X-Envelope-To: linux-mm@kvack.org
Received: from smtpclient.apple (2408:8606:1800:501::1:d)
	by mta10.migadu.com with ESMTPS id 6175ff980d4bddf9;
	Thu, 27 Aug 2026 03:08:39 +0000
X-Mizu-Trace-ID: 6175ff980d4bddf9
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] mm/memcontrol: fix data-race on reading jiffies_64
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260827025457.116191-1-jiayuan.chen@linux.dev>
Date: Thu, 27 Aug 2026 11:08:20 +0800
Cc: linux-mm@kvack.org,
 stable@vger.kernel.org,
 syzbot+ced4d9a8cadb5ef3adae@syzkaller.appspotmail.com,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Yosry Ahmed <yosry@kernel.org>,
 Chris Li <chrisl@kernel.org>,
 Jens Axboe <axboe@kernel.dk>,
 Jan Kara <jack@suse.cz>,
 Tejun Heo <tj@kernel.org>,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <73260DE5-E87A-41BD-BF5F-37163DDD25B4@linux.dev>
References: <20260827025457.116191-1-jiayuan.chen@linux.dev>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
X-Mailer: Apple Mail (2.3864.600.51.1.1)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5A78020002
X-Stat-Signature: uexq3gtobghsdz9oy4ydn9ii9rp5hycx
X-Rspam-User: 
X-HE-Tag: 1787800120-578601
X-HE-Meta: U2FsdGVkX1+SXm8BwQNuxqtK+X6Ya1dv+bsjxQbXlAnrKm/wxHEOq/EUxOYMJJA6ikGqWBVHkMy1SwgDeDfaw/MXB/FEHvYmXy7w4rryImfUS932T7Ruqy6+AqXxQXKIih7ydofP6GQ0feF0RtA4Ez0xcr5/Hu8yFqp9EdsukqJH6UgHK5ehJKecL6SiFgVcmaAwGpq37DKUs9iXvgT2m99LkdmdiaNHvufDkeC8vouV2ljiGr5WlY9z4glBdQBka87mC0d+i1IWVP5Gtoqazkv9rGkwLwzcfdD2uYNUd97nitImK4rc8gMVrB4OkSC2NGIn2IM4Wnnfezu+muKG1vI7M2wFSua1d69t1XLlRzffKDhqd4TGiWwsLIWvvnVO1ApphGsWGmDpTDildwYPmvzFpREYBxwZeu78H652jyaVlLi7GRj0Pndfkt1u+wwNO5PEzkFjWqmA79VlqTjN/LCaWw6dVkbbJ6RP2l4QkR+HvBXMRgCWJfI/LeEPTHgVu6ETLyb8+c7q74VVjmo1imxu71apEZO/1+foK+BOMy3OKXw+c+bBMBQ96ZgGY1qD2RQMMeyH5mpCsRyrNsJ5rEd/kI6EojysJsfktRh4a9JTJUaYaweuG0sObj537r48DLi/9Qrmqz65sdZ/KTdFuj3JsZ+9HnbK9OROX5kFPrV5Kcj350YBV/GQOC2Z/51Nw5PzE0vrHXOWSPb8GvyalRAgdEK6fWjxGpDj0/7bFXLvcAZ2Omdm0BOfXw10B7WhYfhaNYENus4g2nBHIAW+jFPn2OC9sOBZ+zpGrHLaXeoMfvWu3sV8CldlgqzTCSIqZT2DRFloHaSEfh502g5/MQJcsjDJCgimEADp3vIQ37CJgLtLr/iW6iQS8ujcXEWlotl1oE7ieGUk03SLHkMtSRmz8cCukhoZmRLvaKvqkEDfoGN5bx+9mpAeNboD/rLZ4umZdlgV8oIFIF8c/kU
 AFSvlq5m
 m7Qhyp+NiN+PE7o3h5SSs5AHv1O25ABNOGWsGZNdx6zsByqQBSsrzaR1u3hlJjrXvgXAtUuT8RnsMxqvXd3vwOsjU+tfIVssUucFQHkMQ7T4ab+X/waRdJpJqsg5l/TteEAtdrOs6B4ylZiKIkTY6u/Q5o48SWDhoib2CE7dh/AuGvF0umIYjwblrPwnnKTdyGAZrIH1c0hHrV2ZxE07BVEKWhwv4mT0qO5r3T3brg4Wi3wj7PS17TLsZXt7OXZS6kAx1i0vOsjbOfb2cJNx+aBdeE4/LBINQsX8DE42+/Fj8INRPjXin6MiH0ovSDOZWs0nnXX09C0GS1UqscPPxW5MRQlIP7gQ8HeN60SHlJxdElc3OPIXnCsS6SqFowr9IFW25QD9iAnbKf6e9NO8q2IiKKsaQlEjp7XLqIHBfS8jeDDasHF0n7CL25AXqPaTsvnKhm96XyHaze+OEymY8GeMVkO95gv20JHS44aIkA6ACzPuPUIAc6ezUbq21xrqvesjHFzFkdbzyHzKzo64+c5tqVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 27, 2026, at 10:54, Jiayuan Chen <jiayuan.chen@linux.dev> =
wrote:
>=20
> KCSAN reported a data-race between tick_do_update_jiffies64() updating
> jiffies_64 and mem_cgroup_flush_stats_ratelimited() reading it =
directly.
>=20
> Unlike jiffies, jiffies_64 is not volatile, so raw reads are plain
> accesses and can even be torn on 32-bit. Use get_jiffies_64() instead,
> and fix the same pattern in mem_cgroup_flush_foreign().
>=20
> Cc: <stable@vger.kernel.org>
> Fixes: 508bed884767 ("mm: memcg: change flush_next_time to =
flush_last_time")
> Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty =
flushing")
> Reported-by: syzbot+ced4d9a8cadb5ef3adae@syzkaller.appspotmail.com
> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


