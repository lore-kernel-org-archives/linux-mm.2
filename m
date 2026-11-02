Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54AD3606A327
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 09:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=GFViRWO2
Received: by kanga.kvack.org (Postfix)
	id 718676B00EF; Mon,  2 Nov 2026 04:31:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C9936B05B1; Mon,  2 Nov 2026 04:31:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DF996B05B2; Mon,  2 Nov 2026 04:31:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 43D5E6B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 04:31:38 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D02C9A89F0
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:31:37 +0000 (UTC)
X-FDA: 85389661434.04.6F3BC0A
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf09.hostedemail.com (Postfix) with ESMTP id C5329140009
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:31:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=GFViRWO2;
	spf=pass (imf09.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=xiqi2@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793611896;
	b=PBhp+oQEF09IRsILjY+Vnqui0f6cTCvUBhOB/a0jT9pGtyQmYnrXoCoaRW+Fsupilp2/C8
	vuba798OmlVKIuoMpeA9OW+BjyLlFE3PNkgH+U3yrEmnrDE7lraVfhiICj/TpENoLcho0p
	rnf73Oet15Nb2jldFEmKvoDQZxQjX1A=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=GFViRWO2;
	spf=pass (imf09.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=xiqi2@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793611896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wMpxUgI5WYQHqOiTNMupmrDcZlh4/8zsVO74lnqUK2M=;
	b=ehdeYlPmD5GnXpqfveXARlYlKFsXIp3x2YHRGA3Q86E0VUFEF4TekPIGiCVLajqqJEEJr+
	kwkU9AfPFgG/tN0RpJ2x75ZVU6h8jf9j5AXppZC8EOdCPxu777Z0KUbEez93zxi0xsvozt
	9HhiAaUEEz5H7SWxBBtRGEcwFKDHCBw=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=wMpxUgI5WYQHqOiTNMupmrDcZlh4/8zsVO74lnqUK2M=;
	b=GFViRWO2yIuo/FApP9DGv+3L9CtGEV/hhU7sxasp04wFv3gtE9SMfiHVIeGoL3T3T7taCwKU4
	Xo2dYrVTvZmBDBCK+EiT48D5coM/DbZV8tbR4UqCq4xmw4TCDc3ACgaZcEGYd1v04cltniCH6oU
	5p32Fbh37mJJ1JDOoDXWPZU=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4jJ5zz6J3Wz1T4G4;
	Mon,  2 Nov 2026 17:31:11 +0800 (CST)
Received: from kwepemo200010.china.huawei.com (unknown [7.202.195.178])
	by mail.maildlp.com (Postfix) with ESMTPS id B04864057D;
	Mon,  2 Nov 2026 17:31:28 +0800 (CST)
Received: from [10.174.177.203] (10.174.177.203) by
 kwepemo200010.china.huawei.com (7.202.195.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 2 Nov 2026 17:31:27 +0800
Message-ID: <17c910a3-edbb-4f1e-8a6a-f02fbca9e606@huawei.com>
Date: Mon, 2 Nov 2026 17:31:27 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate: fix softlockup in do_pages_stat() with huge
 page arrays
To: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>
CC: Qi Xi <xiqi5703@163.com>, <linux-mm@kvack.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn
	<joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, Alistair
 Popple <apopple@nvidia.com>, Qiliang Yuan <odys.yuan@gmail.com>,
	<linux-kernel@vger.kernel.org>, <wangkefeng.wang@huawei.com>,
	<sunnanyong@huawei.com>
References: <20261031033330.3416326-1-xiqi5703@163.com>
 <76579248-64db-47bf-b8d0-4eb3ca556f5a@kernel.org>
 <20261031094253.d28f484e7e27de469cfa76d2@linux-foundation.org>
 <4806f76f-1fd3-4554-8656-86f4802785fc@kernel.org>
Content-Language: en-GB
From: Qi Xi <xiqi2@huawei.com>
In-Reply-To: <4806f76f-1fd3-4554-8656-86f4802785fc@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemo200010.china.huawei.com (7.202.195.178)
X-Stat-Signature: an3imioa9ih7jq4t4sczottobp465kn7
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C5329140009
X-Rspam-User: 
X-HE-Tag: 1793611893-850145
X-HE-Meta: U2FsdGVkX19DX45auV8C8jRqVy6QsSPJ8yk1p2YVFpUQ4pc88s6EuMVUsT96/ClgDSUeqBYqLv2FGJmUrr4td3sEwXkurvWYEGRM49rryrS6D6NG6X3xQo5L+VdI3c/dMcslpdY62NWuBWpYKneitzrS4yfvdeLa/BJlcJtSswiScBcIY7ir9OlubkgVZmqhm3s0kJFKtx39tHV/SOT84lU11SUOs7Vru859lEcdwzfHA4ueVkS77If+Z2ISdP41wrluBucePReBgUMrTbRclih3p1kVDTS1L3HH7IL8LBdp4f+nS/rcCi0JRS/TouZMiC9JbD5BKEAoJD9W2DSDI5+g9hMBcCh/qXoPlJ6fLUh5H/K4uD2Sm/OwSpu5ACg0F6lgmEDb2L76xVT+5LjDsLjOj7sAytK1NgLdyHM6kL5dKPE9Pv3I3ahemenHzPqpn2ho3yV+XcglpiCarwEK5OB9tPc6/WG02aofcuUmzLCfCeLiiylDm8gartU0ILnWlzNrQSmLNwef6Zy6W4cBHTQ+nw0GoSnzGhSuBRQzFZiancKW+cc1ZkGSNyKid3o/fu0Ui8LroQ2Rxxbv+f90qqvF1cDF0bWwvQGyqE1WjWYaSAeC3C0oI2lBqPDSRRYUihw5t7G9MM/qyqabTRkc9vqtgggO6S9jT743AetROGXaN1Y+gPldfjtVTWpbQQd3mLPpMx4RHsTlFVTrqxeMgRIEHZX2X77TjaQN4KvJiOmoMF4Y6becDcXS1IuLFBAt4EoYL3J7XW049qFthv2g8PQvrsNX8DzsB5wBKTDxqimuq78pRsXurAZqsaWkpfu6hWjXdf5NKyj3rR56zIAD3E4oHDgHuQ0YY2O701RnclvNsyY/9KIJNJZPd28Y5ZQeEdXmoVCMklSeZ7x5qv1PRSL8ZyHNyx2SoKeszuCAudhRskV1dggS58axdDe+fXixp6VsJHEjbC4MNQoIQw+
 4h52kJKF
 nv3Klq7D7erogoOLn0ucolvbD04ccVLPG5k00gLXXwv4rEmPFTtUYpMuxXBfiPvYF5LY+voDtXfDuDeKFM4kh+cxYVm/rO3U5kKWi6+I5JOiz/27C7IOfDczytNppwqnH9e0job7kiktyCNJYb2vCYdWrGHjEehJNdujPO3kSPOUw/+hnmL0/rR63AGaQIQQQRWgWb0+G6KzU2sVkkNKY13jl9bB/QpkEl9z1pP+43/DE7URs7MH2pxlAoEGk1f/qu73uvND2UrPiBMIrzHmmwDgqNMwB69QXRo01izrnZoYIPq2jgUZF/ibw776yOu9erIUAKT7OWag8q5fV/Axcri4WA1VFJh+06WcMQicNtuxevNLPHo93hSyR/c0QDbUlp56xzaX/lV18oMi9DPtEC7Mr8NHTUhhI6a3mtlKC7KkSOnlgfe+zVla3kBgofmLfFoCxAqg71xvmZS91U+lalGqNP7erVx5ZScAGwBGOfWjoz7SadA+yI1YQcvFHTkociwkj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On 02/11/2026 17:07, David Hildenbrand (Arm) wrote:
> On 10/31/26 17:42, Andrew Morton wrote:
>> On Sat, 31 Oct 2026 11:52:30 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
>>
>>> On 10/31/26 04:33, Qi Xi wrote:
>>>> From: Qi Xi <xiqi2@huawei.com>
>>>>
>>>> do_pages_stat() walks the user page array in 16-page chunks but never
>>>> reschedules, so a huge nr_pages can hold a CPU past the watchdog
>>>> threshold on non-preemptible kernels. Add cond_resched() to the loop so
>>>> long move_pages() node-query calls yield periodically.
>>>>
>>>> With KASAN and function tracing enabled, a move_pages() node query
>>>> (nodes == NULL) over 10 million page entries (~40GB) can trigger the
>>>> softlockup on a PREEMPT_NONE kernel.
>>>>
>>>> Fixes: 80bba1290ab5 ("mm: no get_user/put_user while holding mmap_sem in do_pages_stat?")
>>>> Signed-off-by: Qi Xi <xiqi2@huawei.com>
>>>> ---
>>>>   mm/migrate.c | 1 +
>>>>   1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>>> index 7bdcdb57652f..6c2371020cc5 100644
>>>> --- a/mm/migrate.c
>>>> +++ b/mm/migrate.c
>>>> @@ -2545,6 +2545,7 @@ static int do_pages_stat(struct mm_struct *mm, unsigned long nr_pages,
>>>>   
>>>>   		chunk_offset += chunk_nr;
>>>>   		nr_pages -= chunk_nr;
>>>> +		cond_resched();
>>>>   	}
>>>>   	return nr_pages ? -EFAULT : 0;
>>>>   }
>>> I though we wanted to stop throwing in cond_resched() at this point?
>> It's almost unneeded in current mainline kernels.  PREEMPT_NONE can
>> still be selected by
>>
>> 	All supported Alpha configurations
>>
>> 	All supported Hexagon configurations
>>
>> 	Non-ColdFire configurations (classic m68k)
>>
>> However 99% of the world are on 5.x and 6.x kernels and many of those
>> machines use PREEMPT_NONE.
>>
>>
>> IOW, cond_resched() is not really needed in mainline, needed in
>> -stable.
> But where did the submitter reproduce this?
>
> Why should we even care reading the above?
>
> I'm all confused now.
Sorry for the confusion. I reproduced it on a 6.6-based arm64 kernel
with CONFIG_PREEMPT_NONE=y, KASAN and function tracing enabled.

Mainline now only allows PREEMPT_NONE on alpha, hexagon and
classic m68k; the mainstream architectures  cannot select it anymore.
So, as Andrew said, the practical value is for 5.x/6.x stable users.

I'll send a v2 with this written and CC stable.

Qi

