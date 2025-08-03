Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A1FAC87FD3
	for <linux-mm@archiver.kernel.org>; Sun,  3 Aug 2025 02:03:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D7DF6B0088; Sat,  2 Aug 2025 22:03:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1884F6B0089; Sat,  2 Aug 2025 22:03:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09E736B008A; Sat,  2 Aug 2025 22:03:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F00706B0088
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 22:03:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 61CFB1605C2
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 02:03:18 +0000 (UTC)
X-FDA: 83733798876.13.2BD08A1
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf14.hostedemail.com (Postfix) with ESMTP id AAC73100005
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 02:03:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of honggyu.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=honggyu.kim@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754186596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yRv+mOpQoD6U5GLypuJ9Q9oHbdAl3bq/9iBgLO0b3IY=;
	b=IMHsVyKuLRxF3KqtcHFOiDr556EcZ8scwGhCsIEMC2eqZaeUhA7FoU9OOck9tusqwhLHT2
	yK6TuOzsafsLY65Dt8zIM5sbsmELONfvNwBgnQqtI2YtPDjn2RYQMo4ZlWCx1Ab6C/0tD3
	8gXZf5BxLbM2XGJtbVLPpMvgsBZdWPQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of honggyu.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=honggyu.kim@sk.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754186596; a=rsa-sha256;
	cv=none;
	b=v2WSyr/BpD7Zfro0X8LqB3jG9PqpEbjKwGuosnI5Ya0+8uqnAKpuHn8Dlju7jA9Rg273Ng
	1g0vSCN9pu95puhLeN6oxY7dXtzcIrpaMfwDbiFRboNPhwzMWTlHuBgZ6XfkYSBeE+2pri
	WeAHxJW+7vlryQs5jBCv+0cYE0HSNdA=
X-AuditID: a67dfc5b-669ff7000002311f-c6-688ec3604c23
Message-ID: <a31c84fc-71ac-4aa2-9bfb-123868a91cd3@sk.com>
Date: Sun, 3 Aug 2025 11:03:12 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: kernel_team@skhynix.com, damon@lists.linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: update expired description of damos_action
To: SeongJae Park <sj@kernel.org>, Sang-Heon Jeon <ekffu200098@gmail.com>
References: <20250801165041.8350-1-sj@kernel.org>
Content-Language: ko
From: Honggyu Kim <honggyu.kim@sk.com>
In-Reply-To: <20250801165041.8350-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsXC9ZZnoW7i4b4MgykzWS2e/P/NanHiRYLF
	vTX/WS0Of33D5MDisXPWXXaPTas62Tw2fZrE7vFi80zGAJYoLpuU1JzMstQifbsErowtFxex
	FjwVrZjYdYq9gfGvYBcjJ4eEgInEjk13WWHs7y/Ws4PYvAKWEhdfzGUGsVkEVCQ+/Z7BCBEX
	lDg58wkLiC0qIC9x/9YMsHpmATeJq9fvgdnCAp4Sux99YgKxRYDs61vms3UxcnAICRhKbD6k
	CFEuIjG7sw1sPJuAmsSVl5PAyjkFjCRe3uxkgqgxk+ja2sUIYctLNG+dDVTPBXTmHDaJqWvf
	skHcLClxcMUNlgmMgrOQnDcLyY5ZSGbNQjJrASPLKkahzLyy3MTMHBO9jMq8zAq95PzcTYzA
	IF9W+yd6B+OnC8GHGAU4GJV4eHd8680QYk0sK67MPcQowcGsJMJ7rqs7Q4g3JbGyKrUoP76o
	NCe1+BCjNAeLkjiv0bfyFCGB9MSS1OzU1ILUIpgsEwenVAOjibX2sTpxG7O9LvfY2GODHed+
	Ucp9umbV8qrz2RHfr01I7Uw/zly322miC9d6vvcTmW+nvmvafbMtytvD91ccd7JPc7BTIe8u
	4ZIq4XlKmwSK9273/3Z55flTdlW7l+r1lJop7nBZ8eVGY87z92rHVj6R2beGhb2+O3Cpwab5
	8hHuU7U4AhWVWIozEg21mIuKEwEkA30ZbgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsXCNUNLTzfhcF+GwZ4X5hZP/v9mtTjxIsHi
	8NyTrBb31vxntTj89Q2TA6vHzll32T02repk89j0aRK7x4vNMxk9Fr/4wBTAGsVlk5Kak1mW
	WqRvl8CVseXiItaCp6IVE7tOsTcw/hXsYuTkkBAwkfj+Yj07iM0rYClx8cVcZhCbRUBF4tPv
	GYwQcUGJkzOfsIDYogLyEvdvzQCrZxZwk7h6/R6YLSzgKbH70ScmEFsEyL6+ZT5bFyMHh5CA
	ocTmQ4oQ5SISszvbwMazCahJXHk5CaycU8BI4uXNTiaIGjOJrq1djBC2vETz1tnMExj5ZiG5
	YhaSUbOQtMxC0rKAkWUVo0hmXlluYmaOqV5xdkZlXmaFXnJ+7iZGYMguq/0zcQfjl8vuhxgF
	OBiVeHh3fOvNEGJNLCuuzD3EKMHBrCTCe66rO0OINyWxsiq1KD++qDQntfgQozQHi5I4r1d4
	aoKQQHpiSWp2ampBahFMlomDU6qB8c5Dyc/m5U8NCuxZTh+pixezLVbIvLZw7Zbdhv2T/0yZ
	e1pM+X3qmmvbpgvaVrpZndTw1V7AopX28pOJMmfYlI1RD/ZIaylrFWSUf7Q+oWTofnDP8lO7
	b279rzOx6tOXlSpP7YKc8k6HbZTb8C5gY0r4mqgpm0+frcvvu1U1ecZ9M8e6je9NtyixFGck
	GmoxFxUnAgC/05lTVQIAAA==
X-CFilter-Loop: Reflected
X-Stat-Signature: 1i1ooeuq35p6huhzbumcffxhodk4ojsi
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AAC73100005
X-Rspam-User: 
X-HE-Tag: 1754186595-359445
X-HE-Meta: U2FsdGVkX19U68FtSBipnUfl2a3SJXPZTFjycpxhBfLvfu4gmZ94ZOaYBEuypp45mt8klwi1zDsx4Gci7KyVGJ5kjYqW8ZI3m/PMiK7dFJRZqTV4F770GGo6XuaUvFgGZv4jwkeMGkpKyDETCFNtqFsczE2z5UD2+d5FDnoWTOcziOuIA23ddBzJPS97bKKyX4yUBkWHeYKUek7LXFelYy1k377DUJnGsgYsUl9wIwtfkUS2YyR5gXQRa08qZ2NWOH8TYvFFQxGILZ29WT+1BD2bY0k2urcGlX6Dr2Zpn4uhrBoEpvNK2TrVFWmovJSrvCiWU+wAAZUPK7p0HZVpMyQV66p5RSwFhQWxPB4zsraztMUeVcF0ZR5deOr9qmwBTBEw7d7DdegQwUEpCRaVM6wPOACac9GienAR1+C9gKtbFunJm7kQ0R1oLBSAxUJI6GWVsA6h6hS7JR4r55VS3uUznG/j8LanrpGjpdIg0+rpl5qS8gUSIWzIASR5LgcZCDUMnLmEfUgQgJSDHWG2NduuaqB/6+DXDPm4BpaYKzQ+lUH1hQmyQ26fIkQXXas8VezTOF1FtkRuFiaEa12MarNHwmwy8oQlRfYSPA7mq0ynTCJgtqXaFYKjCx5jh32IweHnNWWWydH+pvgoKmGEmmo373QvpNZ1nKUKh5C6Wbg2FdJVipJcL6xWyTTF3v/MPAoXaSzxDHoMysblCKLL48KxQvGhE9LGUlc5hyHOpeuzHPKHB2OXOZtpMneogM1f7VT/I9i8CJdov0Y0AI8/hQzPfVD5F4c3NfLNh0GjdCW5DGcikJqMJjSfXBxilta0PQNnmY1NeiAmKE/WW+OJArWnFhSTGoeKu3otTL0dFUnjatMtCPzWbdtV6xtARGwOVdyFRIEmE76iQgoHPBG0QmWDHauvDrc9adU8y2w4BLj22w6Hh9dALnaI3WfzqgwwVs/L2n7d/KTbvK34511
 0oDjHdMm
 egZ3kfNdpMih8gvt73YF4vPha2W4p3/aOeMawIVxsddOoOMAedhcwC0ovFX8EBeTopqdMrHj0+m7FciLqRbU1u68BsIbXvVYUeyIu9LvaICkxajdCZH7havHSERQAKjve9axLvwYwHbkefQZtTbPqtTY9bpO4FkJSZlEkqcxKVm0FCHI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae and Sang-Heon,

On 8/2/2025 1:50 AM, SeongJae Park wrote:
> On Sat, 2 Aug 2025 01:11:09 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> 
>> Hi, Honggyu
>>
>> On Fri, Aug 1, 2025 at 8:35 PM Honggyu Kim <honggyu.kim@sk.com> wrote:
>>>
>>> Hi Sang-Heon and SeongJae,
>>>
>>> On 8/1/2025 2:58 AM, SeongJae Park wrote:
>>>> Hello Sang-Heon,
>>>>
>>>> On Thu, 31 Jul 2025 22:22:30 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
>>>>
>>>>> Nowadays, damos operation actions support more various operation set.
>>>>> But comments(also, generated documentation) doesn't updated.
>>>>> So, fix the comments with current support status.
> [...]
>>>>> diff --git a/include/linux/damon.h b/include/linux/damon.h
> [...]
>>>>>     * @DAMOS_WILLNEED:  Call ``madvise()`` for the region with MADV_WILLNEED.
>>>>>     * @DAMOS_COLD:              Call ``madvise()`` for the region with MADV_COLD.
>>>>> - * @DAMOS_PAGEOUT:   Call ``madvise()`` for the region with MADV_PAGEOUT.
>>>>> + * @DAMOS_PAGEOUT:   Reclaim the region.
>>>>
>>>> Nice!
>>>
>>> But doesn't it make confusion about whether this pages out to disk or does
>>> demotion to the lower tier memory?  It's because PAGEOUT action doesn't do
>>> demotion, but it looks "reclaim" includes pageout and demotion together in my
>>> understanding since /sys/kernel/mm/numa/demotion_enabled was introduced.
> 
> To my understanding, DAMOS_PAGEOUT can also do demotion when demotion_enabled
> is set.  Am I missing something?

Actually no, please see below.

do_demote_pass in shrink_folio_list()
https://github.com/torvalds/linux/blob/v6.16/mm/vmscan.c#L1122

The do_demote_pass is used here.
https://github.com/torvalds/linux/blob/v6.16/mm/vmscan.c#L1293-L1302

can_demote() implementation returns false when demotion_enabled is on.
https://github.com/torvalds/linux/blob/v6.16/mm/vmscan.c#L350-L351

The replated commit is as follows.
mm/migrate: add sysfs interface to enable reclaim migration
https://github.com/torvalds/linux/commit/20b51af15e014cac63b58a4f8b8b323ac35bccce

> 
>>
>> My intention was just to synchronize with the Design documentation.
>>
>> So how about changing the description to `Page out the region`, Would
>> this be also confusing?
>> I feel like it would be clearer than using word "reclaim"

I don't have a good idea but it looks like recusive explanation.

> 
> In my opinion, "reclaim" is good.

I wish there could be better term that distinguishes between swap out and
demotion.  In my understanding "reclaim" includes both swap out and demotion.

I also found that man page explanation about MADV_PAGEOUT is "reclaim these 
pages".  If this is correct, then maybe demotion isn't included in "reclaim".

Thanks,
Honggyu

