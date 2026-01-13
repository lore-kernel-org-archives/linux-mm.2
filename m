Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AB55D29DDE
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 07:32:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB0D26B0005; Tue, 13 Jan 2026 02:32:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5E826B0089; Tue, 13 Jan 2026 02:32:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6A736B008A; Tue, 13 Jan 2026 02:32:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A6F406B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 02:32:10 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A20B1AE6F
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 07:32:10 +0000 (UTC)
X-FDA: 84326122020.07.5652669
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf09.hostedemail.com (Postfix) with ESMTP id A0C50140004
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 07:32:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=h-partners.com;
	spf=pass (imf09.hostedemail.com: domain of gladyshev.ilya1@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gladyshev.ilya1@h-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768289528; a=rsa-sha256;
	cv=none;
	b=ck3nC5ixelzMQt/htoRquZnwUHnpfCUIeqqFEQ1okk9o1pxxD2ZS8VeenuOJE3C1tpzCUV
	OD0uLU7J4isqu03wThhJENrjrahU67Sk5uIL9GTj5oLrPp/ZunGRRscm++s6dvFDqxEgH5
	Qxpdzw59O48yRGpAaBK1mCCOpgFy9LQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=h-partners.com;
	spf=pass (imf09.hostedemail.com: domain of gladyshev.ilya1@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gladyshev.ilya1@h-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768289528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0+4Cx4HORlZQI3txY2AC6bEjG8UQ7lFSUauSK+obA1E=;
	b=q4e4pxUhBtm43MQizGmjAiKEQ/Ts7KBOXIs0jg0uySuBRbq1NyAJd33LafyLlxpFBUd6Bj
	Wmzm0PidcBcx2eb4mYp1UbUmnzCIpUERhJ1bc6/UEeLbN2RIokt+EE0/gf6kQ6A6oCdlRu
	URlYbBDAb6iTnDlQo29n/e0wxrc5f7s=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dr1CM5PGlzHnH51;
	Tue, 13 Jan 2026 15:31:43 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 4726840086;
	Tue, 13 Jan 2026 15:32:01 +0800 (CST)
Received: from [10.123.123.67] (10.123.123.67) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 13 Jan 2026 10:31:57 +0300
Message-ID: <cb821f39-ce0c-44fd-aec1-9ad19e6355f5@h-partners.com>
Date: Tue, 13 Jan 2026 10:31:55 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] mm: improve folio refcount scalability
To: Kiryl Shutsemau <kirill@shutemov.name>
CC: <guohanjun@huawei.com>, <wangkefeng.wang@huawei.com>,
	<weiyongjun1@huawei.com>, <yusongping@huawei.com>, <leijitang@huawei.com>,
	<artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<alexander.grubnikov@huawei.com>, <gorbunov.ivan@h-partners.com>,
	<akpm@linux-foundation.org>, <david@kernel.org>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<harry.yoo@oracle.com>, <willy@infradead.org>, <yuzhao@google.com>,
	<baolin.wang@linux.alibaba.com>, <muchun.song@linux.dev>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<gladyshev.ilya1@h-partners.com>
References: <cover.1766145604.git.gladyshev.ilya1@h-partners.com>
 <ec023298-c26d-437b-a023-b49509f83c5a@h-partners.com>
 <aWTfduyPXjhymyzW@thinkstation>
 <d9fe0fb8-2c83-4eeb-8513-853522909253@h-partners.com>
 <aWUdHYjHPQGpF-92@thinkstation>
Content-Language: en-US
From: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
In-Reply-To: <aWUdHYjHPQGpF-92@thinkstation>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.67]
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Queue-Id: A0C50140004
X-Rspamd-Server: rspam06
X-Stat-Signature: r45bcxyujmdbeot199wiejhxxz8ahr4n
X-Rspam-User: 
X-HE-Tag: 1768289527-625438
X-HE-Meta: U2FsdGVkX19fcQcNiAjaC7Knht+ip/XVCJ2+OlTrtSg0rbjyVo4Ag6GRrTKMCee/d40nMUERRbqiUMfJh5k2/72piHQiIHCyvztzhW86hgn/17xOjPP5tXdRn+hyiupw1a5NB3FcIr8H7RJepqurvPQztROLx4tg+fo9Oa7S2AYpMPxN3xGW1YxMLhgF8ycdzgrvdREq1YmnL8uABHlFZ121xM8PaSwG+/hTRCQTZaBgyeYNmOP9JWxTrSBElBQk1rMYzEAaxi0GdM8n6q2R4b1Bh9fO/6Qo6yMIINtTjPRENJB56sOJjhljl4lHJz1m40B7rXxGJLKVCMiJN3UrJ44cV0HbWIUYtvD6cg1z4Nvt2Eu09W2nDprxa+pAufcO1Hf5hNxvyrv5h5JXpTdtw1xV0i0fjtt/d8eQUEGsEK1mfC0CXbr/g+/Dr1UfjJ9yPC6ThurSh0YS5glaMYGmoEJ2cqFeIXXXDI3nohT/nlHH7VI7o6krPtbeQszpnBa7Rtw6+O7gocfB6jTQf4M6ZHOayQSvJjbdsXlKxOhNarg/mrZYTRYfU9/5KgqR4xh9pe7TXEicHwjbJ53hrPLfy3IsVQC/hBCQD3XLMg5mXBsY23tQsFYPO/i7XfNAK/XtjmDQjGtTdeSM7iR+q3kLQz1jc/fVOz3uPLb30vMtxtvntwNMA2OlIcj5EHr77E+xoJzBlPBWkvEwSmY+vZluWXbWwSFSLvcJubl73vTfR325hGA5Ru1O/OPA7cOP9NMr+3BK/fAoKCy/TLOvNsNk0veZQ8mMqt7zXELYDwkbPD8DlhjU5I8MLx0s0r6lC3Otn0aYftlidO9/xlRKD3nxxwAOICu6+J/nmTOMxssMPcqmZgq72zCP36Jam3MXGky9ZdSg57up9ULuonfkw/QmPmBVhTJTd3pcgV2CnioA3/XAO7gOqsMSV5dRqshVcOdRXq0BhtHCXc9LyZz4bGX
 65zoHKEb
 RaqkhUJymiBEd3G8oLuSBB1fr/hTzQfYEb1Upvcbul/hSBdAyaF8lQi66HO+JcwEEYUTZ9HLQLFx/Ypft14kglM9WR9nYLJOrlbXqlzn0aChLv50XAllgoO4uxTV5OuZy7nbw3tO8Orgo7ZvxOTatYb/0qV+a5Etu9i5niavW56EwlGC52cIkVawYTikijnQrAOo99a95AA9t9gGXG4LqCn/Qkg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/12/2026 7:17 PM, Kiryl Shutsemau wrote:
> On Mon, Jan 12, 2026 at 05:32:10PM +0300, Gladyshev Ilya wrote:
>> On 1/12/2026 2:49 PM, Kiryl Shutsemau wrote:
>>> On Mon, Jan 12, 2026 at 11:30:38AM +0300, Gladyshev Ilya wrote:
>>>> Gentle ping on this proposal
>>>
>>> I generally like the idea, but I would like to hear from folks who
>>> actually understand serialization.
>>>
>>> Also, do you have number for "a full CAS loop when the counter is
>>> approaching overflow" thing?
>>>
>> I am not sure that overflow is a real problem because you need a very
>> specific race condition over a long time to achieve it...
> 
> Yes. But if the page is popular for pinning, GUP_PIN_COUNTING_BIAS can
> cut the "very long time" substantially.
> 
>> But as a safeguard, everything lower than 2^31 - #max concurrent
>> accesses (~#num cpu) should work, so let's say 2^30
> 
> What I meant is when we put a branch/loop in the hot path, your
> performance numbers will likely not look as attractive. Am I wrong?
> 
It would be under the same branch as the single CAS that already exists 
in this patch:

   if (page_count_writable(page)) {
     val = atomic_add_return(nr, &page->_refcount);
     ret = !(val & PAGEREF_LOCKED_BIT);

     if (unlikely(!ret)) {
       atomic_cmpxchg_relaxed(&page->_refcount, val, PAGEREF_LOCKED_BIT);
       /* [Proposed] if (failed && big enough) { CAS loop } */
     }		
   }

Unless the "failed try_lock()" is the hot path somewhere[1], this added 
branch will be hidden under the already existing [unlikely taken] branch

[1]: Which I doubt, because failed try_lock() usually includes heavy 
re-lookup

