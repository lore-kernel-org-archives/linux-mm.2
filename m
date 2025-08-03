Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 668A5C87FCB
	for <linux-mm@archiver.kernel.org>; Sun,  3 Aug 2025 05:42:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8C336B0088; Sun,  3 Aug 2025 01:42:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D16356B0089; Sun,  3 Aug 2025 01:42:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDD326B008A; Sun,  3 Aug 2025 01:42:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AB6316B0088
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 01:42:09 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3B6D1BAA50
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 05:42:09 +0000 (UTC)
X-FDA: 83734350378.01.B158CF8
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf15.hostedemail.com (Postfix) with ESMTP id 63682A000C
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 05:42:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of honggyu.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=honggyu.kim@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754199727; a=rsa-sha256;
	cv=none;
	b=1Ks5G2ge0Zw/1z8VqJM8FFA52TWs61hnVaNnvR411LVFHiIJ4JAp/8C8EG7VPdCmmmQ4OU
	9/w4yDCyVr7QOhT4IUovpfbR2/BLJlLhISAjgmlQYD58f20qWiCobTopcPz9JQ9JVYSeHG
	axfEsm99sQYJHVigisLZY911s8KcUXs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of honggyu.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=honggyu.kim@sk.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754199727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ogwyqp0vCMrwlryfrNmNznQZIqhYceTiMjxDAv++QVE=;
	b=nPLg3DyvkJ+c/P/V3VDzGq5jrRqA9ll6tVOuqgerQiO6NBMTu3l8rKg6KaH2spOIDo4HDy
	D7wOKQb+2IxlWQIzXI4JGS0MMTHX9OT6kx4Bc210175ZuZLc77I9LA9UYR27W2fct8HA/H
	fkICNma5nxL4q8LVhc1M3SVCsjCiEKA=
X-AuditID: a67dfc5b-681ff7000002311f-8c-688ef6a62620
Message-ID: <356d8739-d47a-4d62-bec2-38ce8f4a91a1@sk.com>
Date: Sun, 3 Aug 2025 14:41:58 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: kernel_team@skhynix.com, Sang-Heon Jeon <ekffu200098@gmail.com>,
 damon@lists.linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: update expired description of damos_action
Content-Language: ko
To: SeongJae Park <sj@kernel.org>
References: <20250803053028.51309-1-sj@kernel.org>
From: Honggyu Kim <honggyu.kim@sk.com>
In-Reply-To: <20250803053028.51309-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsXC9ZZnke6yb30ZBj3z5S2e/P/NanHiRYLF
	vTX/WS0Of33D5MDisXPWXXaPTas62Tw2fZrE7vFi80zGAJYoLpuU1JzMstQifbsEroyZfz0L
	9ipWLPnwlK2Bcbt0FyMnh4SAiUT/p2vsMHbn5V+sIDavgKXEpUMP2EBsFgEViQd71zNCxAUl
	Ts58wgJiiwrIS9y/NQOsl1mgQOLxuTdgvcICnhK7H31igoiLSMzubGMGsUUEFCXOPb4IVMPB
	ISRgJLF+WyRImE1ATeLKy0lg5ZwCxhJb9kOUMwuYSXRt7WKEsOUlmrfOBopzAZ05g01i5vn3
	rBA3S0ocXHGDZQKj4Cwk581CsnoWklmzkMxawMiyilEoM68sNzEzx0QvozIvs0IvOT93EyMw
	xJfV/onewfjpQvAhRgEORiUe3h3fejOEWBPLiitzDzFKcDArifCe6+rOEOJNSaysSi3Kjy8q
	zUktPsQozcGiJM5r9K08RUggPbEkNTs1tSC1CCbLxMEp1cBYVXr2sOM6tkhZeY9tr/J+lcgc
	uPxqew3T/derkxrd/NoW88tPNpv6lynxv8KdMFMp4Z3XJ/ZkXvvAfk1j97abWpPqFvD2J0to
	JZhHCL+bMPGhR5Hv/Yif3WUXP3Q557OsqLIQMazX/28s/t9mq/put6KJj99v054w934i57WT
	evvOLpt3fbWDEktxRqKhFnNRcSIAFzshh20CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsXCNUNLT3fZt74Mg4PLJC2e/P/NanHiRYLF
	4bknWS3urfnPanH46xsmB1aPnbPusntsWtXJ5rHp0yR2jxebZzJ6LH7xgSmANYrLJiU1J7Ms
	tUjfLoErY+Zfz4K9ihVLPjxla2DcLt3FyMkhIWAi0Xn5FyuIzStgKXHp0AM2EJtFQEXiwd71
	jBBxQYmTM5+wgNiiAvIS92/NYAexmQUKJB6fewPWKyzgKbH70ScmiLiIxOzONmYQW0RAUeLc
	44tANRwcQgJGEuu3RYKE2QTUJK68nARWzilgLLFlP0Q5s4CZRNfWLkYIW16ieets5gmMfLOQ
	XDELyYZZSFpmIWlZwMiyilEkM68sNzEzx1SvODujMi+zQi85P3cTIzBgl9X+mbiD8ctl90OM
	AhyMSjy8O771ZgixJpYVV+YeYpTgYFYS4T3X1Z0hxJuSWFmVWpQfX1Sak1p8iFGag0VJnNcr
	PDVBSCA9sSQ1OzW1ILUIJsvEwSnVwBg7RWgN053jD/c+q+QQP8DlEd97y5Z/9Y0YBf0psn8T
	gxuUZ6inx6/PU0suXbFo5ak6zmPl7ixlu5LjcvVlio8edC3wOvMyQfTvHJ4dN4+nX5/clHhz
	peOdddzaNZNTzAKl+etNXzctK+zPFHVR19yyJEyx4+X7M1snVBzw37bVYoLhpsXyDkosxRmJ
	hlrMRcWJAIspxaFUAgAA
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 63682A000C
X-Stat-Signature: zqzngrzstm8qh396wpxb5benbr7qd64b
X-HE-Tag: 1754199725-770020
X-HE-Meta: U2FsdGVkX18K53OekDBD8fBV3HMfcu5gcp6QyApRdcTuYWzZeW269o2f5lAiSfMeon2pH6cCPM7qYUO6kAq9xXQ9PKWI38TnkhTAtMHBJkK0MAV0M/qbbd+6ATR4XJshiFGevDZmShNXr7cJLNNiCfXmlyNkOws8CgQgOzjPWubfKfOMb2/kAo1vDA4utEfiJ2NJAdkZZSTAqy4HDe24rYU7I0+BggZPu5wVZezDMZgztOpd3QaHJ7xcpmnMUDEdZIwDCsd49Ua2YkWbAtM//Xz220eZQZrGfrTOqrl2Rc37F3OvUlWEx5iWRauHZ17tdGwyIYug8U/6sRn67aSRDps54VnnabzpmpBmqqdZw5gnfwoT3jOq8Njil82RCIC2SEeyAJJw/WMvc4z6BT18LL2Tgz5FGYfe8JnKFgvhknIYRo+J36gZ45IygEKxwsmlGu2TXRs0A0cSHuPxTrKzEN/8kroQ/Ap/GGsjiK1eeekw5d4ufjMggF6fNCxwLAze46GaVhsyJf+u24g18uuFt1Kf74wz7qW6zGh1vR2OKGttnckb11mR+m8D/KXQ/o9jo7kHvqSmpjlhI4SI5XIRqs75cRwtg/pEMS8yeYjSyGoGDObzMCJ+ubk6/Fl3RNDaEKvqyy9WIWSdNqSCTC4wiow8c07RNuBn/85TpckJ0JAzwCKupwCDXC221DyroMvPBTRtUwpvLQjo7wDMYn+JLkHFtuy7j3M90ORnQyg+kCE+LSkD4yUFaryZ5v4rUkL3mX4nRxbuMEPwxKKgoyPVDYCELsB4u467Tt9tYClAVEJ5y9J29f5bJxS+2Sa6QJJQzkMKgcari23SASw7ggr6h/ZHRXn+/IUtyKkrjNhTKpTGWNkhIy//VFG0PkS2A8RW/NRe5HMlDkYuPJeO+p80Lsc0PT7q1U3AZJQ2yjtqTvxF8+cSMoIYXcRiFM2RPltylP/V8hyMGNz5WuF4YQL
 AsVMjC4G
 SgZ21Ow9Yu3YwcBaBt5Uxc8Ni/t88HHGF9eVoaB//Cd8Y7QtpqLbH0B1fMbRrwJ5RYFUYHwdMPcHUgWVvRIOI9NXZknCYRDWWwMihvRZFLfX0IRjchNif3Ws+XNM7Iu5PRBcXx91DWIYm1/c+KjKWFRvcvYvIZNZ9iPAfFnLpCMaaV4A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/3/2025 2:30 PM, SeongJae Park wrote:
> On Sun, 3 Aug 2025 13:43:03 +0900 Honggyu Kim <honggyu.kim@sk.com> wrote:
> 
>> Hi SeongJae,
>>
>> On 8/3/2025 1:22 PM, SeongJae Park wrote:
>>> On Sun, 3 Aug 2025 11:03:12 +0900 Honggyu Kim <honggyu.kim@sk.com> wrote:
>>>
>>>> Hi SeongJae and Sang-Heon,
>>>>
>>>> On 8/2/2025 1:50 AM, SeongJae Park wrote:
>>>>> On Sat, 2 Aug 2025 01:11:09 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
>>>>>
>>>>>> Hi, Honggyu
>>>>>>
>>>>>> On Fri, Aug 1, 2025 at 8:35 PM Honggyu Kim <honggyu.kim@sk.com> wrote:
>>>>>>>
>>>>>>> Hi Sang-Heon and SeongJae,
>>>>>>>
>>>>>>> On 8/1/2025 2:58 AM, SeongJae Park wrote:
>>>>>>>> Hello Sang-Heon,
>>>>>>>>
>>>>>>>> On Thu, 31 Jul 2025 22:22:30 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
>>>>>>>>
>>>>>>>>> Nowadays, damos operation actions support more various operation set.
>>>>>>>>> But comments(also, generated documentation) doesn't updated.
>>>>>>>>> So, fix the comments with current support status.
>>>>> [...]
>>>>>>>>> diff --git a/include/linux/damon.h b/include/linux/damon.h
>>>>> [...]
>>>>>>>>>       * @DAMOS_WILLNEED:  Call ``madvise()`` for the region with MADV_WILLNEED.
>>>>>>>>>       * @DAMOS_COLD:              Call ``madvise()`` for the region with MADV_COLD.
>>>>>>>>> - * @DAMOS_PAGEOUT:   Call ``madvise()`` for the region with MADV_PAGEOUT.
>>>>>>>>> + * @DAMOS_PAGEOUT:   Reclaim the region.
>>>>>>>>
>>>>>>>> Nice!
>>>>>>>
>>>>>>> But doesn't it make confusion about whether this pages out to disk or does
>>>>>>> demotion to the lower tier memory?  It's because PAGEOUT action doesn't do
>>>>>>> demotion, but it looks "reclaim" includes pageout and demotion together in my
>>>>>>> understanding since /sys/kernel/mm/numa/demotion_enabled was introduced.
>>>>>
>>>>> To my understanding, DAMOS_PAGEOUT can also do demotion when demotion_enabled
>>>>> is set.  Am I missing something?
>>>>
>>>> Actually no, please see below.
>>>
>>> I'm unsure to what point you are saying "no".  Are you saying DAMOS_PAGEOUT can
>>> also do demotion when demotion_enabled is set?  Or not?  Could you please
>>> clarify, and add more explanations about why you think so?
>>
>> I checked it again and found I pointed out in the wrong place. Please see below.
>>
>>>
>>>>
>>>> do_demote_pass in shrink_folio_list()
>>>> https://github.com/torvalds/linux/blob/v6.16/mm/vmscan.c#L1122
>>>>
>>>> The do_demote_pass is used here.
>>>> https://github.com/torvalds/linux/blob/v6.16/mm/vmscan.c#L1293-L1302
>>>>
>>>> can_demote() implementation returns false when demotion_enabled is on.
>>>> https://github.com/torvalds/linux/blob/v6.16/mm/vmscan.c#L350-L351
>>>
>>> I'm again get confused.  Isn't it opposite?
>>
>> The thing is that DAMOS_PAGEOUT call sequence is as follows.
>>
>>     DAMOS_PAGEOUT
>>     -> damon_pa_pageout
>>     -> reclaim_pages
>>     -> reclaim_folio_list
>>
>> In reclaim_folio_list(), it sets "no_demotion = 1" in scan_control, then invokes
>> shrink_folio_list().
> 
> Thank you, this clarifies.  DAMOS_PAGEOUT doesn't demote pages even if
> demotion_enabled is set.  Thank you for enlightening me.

Thank you too. Glad to hear that.

> 
> So, "reclaim" means "reclaim".  shrink_folio_list() can do demotions when
> demotion_enabled is set.  I hence still don't think this patch is saying
> something very wrong, and how it could be improved.  Do you have more specific
> change suggestions for this patch for an improvment?

I would just like to make the term "reclaim" clearer and we may be able to 
define what "reclaim" is.  I think we can choose between the following two
different definitions.

Definition 1. "reclaim" includes "pageout" and "demotion".
In this case, we better clarify all the other documents that mentions about
those terms.

Definition 2. "reclaim" only includes "pageout", but "demotion" is out of scope.
In this case, shrink_folio_list just do pageout, but "demotion" is only
exceptional case so we can say the "demotion" escapes from "reclaim" logic.

We might have to clarify the term "reclaim" for those cases whether it includes 
"demotion" or not.  We might have to discuss with other mm developers together.

Thanks,
Honggyu

