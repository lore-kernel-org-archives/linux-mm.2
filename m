Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E19ECCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 07:39:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC3668E000C; Thu,  9 Oct 2025 03:39:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9A9D8E0002; Thu,  9 Oct 2025 03:39:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B0458E000C; Thu,  9 Oct 2025 03:39:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8A8D58E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 03:39:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1A224C0AE5
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 07:39:36 +0000 (UTC)
X-FDA: 83977775952.09.2C66163
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6AE8A40008
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 07:39:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=u7mRIsYE;
	spf=pass (imf11.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759995574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ws1QWS1SxNWWPViN/1fQpFGlPzNSlgREQgIxN0gMQfM=;
	b=BO7jtWOc1Sx/1VYHA6dWmWi6ie2HA7OYotYqOCOaWhC2bj9j11r/y6pw8feTgPMfIOlDp5
	gsyh7iFZYhYTZ0q7oT4FzKTcXQf+TcPVhGbWaY6Dw26SWvHFXGwadyEseVPyrSTdvezUmz
	RwGtcrkAZVdZHkkMgnp0VNoya1hawBs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=u7mRIsYE;
	spf=pass (imf11.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759995574; a=rsa-sha256;
	cv=none;
	b=N4L1xzwY1JoZBSqqoYsRu2gxRZFlarYcqDAoqEERtnb+nYsLNPL/IkG1p9hd/pvHb0/IPK
	er/EjBNabh7ioGOQveTN03YbsDeGWf96v+aXS0kFSC3rlxciT2uJYaykjGPcozVIoV3ia1
	dIDnYOs6ckTZaZzkR324CHRhtnc7jdA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Ws1QWS1SxNWWPViN/1fQpFGlPzNSlgREQgIxN0gMQfM=;
	b=u7mRIsYEMtXyJfvnau1s8DhoBjkD5LC60mpdYdgmtiPIiZU7U9EbFu0ZGBIJkHOBLVo8c2SqZ
	/FMJkS7kLoi0gnal7SQjl5qzoicZ5iKX946fNxVXx+QU6Wpwj+i1ZdX/50hkSxDbjWN2B93cNKR
	mP4kcNFk++iaJfT5HF/lfyE=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4cj1wH2Lppz1K98v;
	Thu,  9 Oct 2025 15:39:11 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 386AF1A016C;
	Thu,  9 Oct 2025 15:39:27 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 9 Oct 2025 15:39:27 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 9 Oct 2025 15:39:26 +0800
Subject: Re: [syzbot] [mm?] WARNING in memory_failure
To: <jane.chu@oracle.com>, Zi Yan <ziy@nvidia.com>
CC: syzbot <syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>,
	<syzkaller-bugs@googlegroups.com>, <akpm@linux-foundation.org>,
	<david@redhat.com>, <kernel@pankajraghav.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <mcgrof@kernel.org>,
	<nao.horiguchi@gmail.com>
References: <68dcb33a.a00a0220.102ee.0053.GAE@google.com>
 <2afee6bb-b2f0-4a86-ba8c-d33b0b477473@oracle.com>
 <637BC0B5-B911-4A79-8107-BD7CDB351660@nvidia.com>
 <A4321695-9F12-4C7C-ACC9-72FD84B6DB2C@nvidia.com>
 <57d9aa32-2fc8-48d2-b68b-3308c7d58125@oracle.com>
 <CD6D8EBD-F139-41BC-9A59-5033EF5A09BC@nvidia.com>
 <ae74c0b4-7115-4856-a3f0-c61945f64c7d@oracle.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <f5870e90-2c3d-7d65-fcc3-92ec5a1fe177@huawei.com>
Date: Thu, 9 Oct 2025 15:39:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <ae74c0b4-7115-4856-a3f0-c61945f64c7d@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Queue-Id: 6AE8A40008
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: h56kfs15enfhugnn55foakgwi3k4dmke
X-HE-Tag: 1759995572-753174
X-HE-Meta: U2FsdGVkX19FirPW726hlcVnOw3yCOIlePU2Zwc4PPjE7MN/Bz0Q1ubsknYG2ZIgS1shiHwC8cKx8JhWN+rFmBadVy5B6W/eP8xNSAX0q2V+6akndV47QU8HWis/Bgmz+hm4QrwRxhtGOO+4Zs/VnPbBQENEpCqFw4GpylhRBEvoiAJv1vh6DSUerjBvGwOw3WHuenI1QkPR4cvny+Y87z0KDuzzfw1qNk1FufBnSKLEUCFdhlocEakKCPPBCUeBtDQtA87Pn+qwq4OAK+hrwByEMdx+P/aCR0XopkAxQbOLwTzOIkyzhRTsFPsOXDJxakBkHrRnm0CsQrsFIC+IdA+qhKF12h3VR2U/b/BU7dTpSs0JrKGzXnj4W5o1gqfdGHB5NopPIS9gQHN3kh27gfxOHYr0lJQ3OxaV6R+B8+yrgzK1nGj7mR/+IskJTrmlyTs+ubT4Omrwpg3+4OPtT6htSMz7/stEFa/mIIzkUSUTR3XnQ4VKyetGR/ynXb9QPdo5k72uqsRlVnf9kjv2Gu27qLKVd0zv1FNypnONmPo7xiZtBEu5mxQnHdI8H3F/C8PIB8RJTydoklcgkTmdCA5Wymldhhm7z3EQvT2MvFWwcNALu/Y/NDHNUN2rijxlcUgxexjvC/0bKUjmwHsPTcz56Dpl/duzVa0gxReAXND7DeHwAfFPYjt6pLPjic5MEqfec8OhI6o8UsunGWjOyj/Q4+FcXy5vuNikPLZd6mBIfVzAloLscVH8wYpA2CKa9p/Gukbzz3bp3kqnwEfkeHd02Afa1FsYX0jZAamEIeDSUYLBP7rsWJ1f5LFyj/sTKpj9VtsCYm6WRXor7bAIjKitgC4QpqCOO/C39K46OX1/7WqpT9DKrkYbIWTnFVPVuif4mNwNmYBlEYcvQhGdrntaGAXfIC9I1hdMpbGJAfG2xaayR4b4Xpt7OZmlJrC9bHTWizanXEKRW/06Qzw
 R2CExCDD
 LbOPE1MNPmptw3j90QZSF/h3TgdGY/EkfOfTL/rr8kgR+esp5245PFTEdEwYFwJSISH461edA84Egr5ODRjSa79nPCFMkjRSErf5FLkmj2i2mf6y8Wq5Q84pOrOQb11oX8qivInUfyR33uUxC0dRYlT3oC3/DTxCM5x04gbuKVOueafeVzMpQyUXBU21oBnV+4GG6rLH00QCmu0C7yrNcD++nldCj7ta3ZtnoAsNgW+GRJdkBbz9oV/6TxOGdEn/QFQZnANtgDOgDi4rcZBcRYjMLUPmqEGj5GZSEQR5nuVqGAI89fijMa1MCcnQxDTdvX+OVldeXP2Elkln5q3zdP0tCvschQjmHEm2leLQK2LsxEEh8WNy2RQBoXYtLlKqJ5zKDpjxXzT6x8jMFEAsFuTm0mdH+bQIeFEPFFYj39UO0iJTZvkfFvJU0U4LZ3tT/5tiSvcyh/fWL80wrP7OvgOhiKceFeGvkAByoqSvb5XsXM9x4NLleiu5aaKJSIg3W6llxflag+ayuCpCJ8LPgb/L9bJevo/3OekF9iILnlgdOCPe6vrkK1vmK+VFLpTHzpdOiXGWAU9EFg8Gz41SGhr91rNEK5y4UNcHSWLIh0Iwpx48iQ5hEx76h9k/RwtYY0Eqn3Cnll51nONfe8eBSmvwus6yDkRI0fmn7edHp45zvTZJigtqtzC2GEH0VZo35dQ3Uv0OgtGveIxmVQiCiTpOxo0GC9dnMooej
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/3 1:47, jane.chu@oracle.com wrote:
> 
> 
> On 10/2/2025 6:54 AM, Zi Yan wrote:
>> On 2 Oct 2025, at 1:23, jane.chu@oracle.com wrote:
>>
>>> On 10/1/2025 7:04 PM, Zi Yan wrote:
>>>> On 1 Oct 2025, at 20:38, Zi Yan wrote:
>>>>
>>>>> On 1 Oct 2025, at 19:58, jane.chu@oracle.com wrote:
>>>>>
>>>>>> Hi, Zi Yan,
>>>>>>
>>>>>> On 9/30/2025 9:51 PM, syzbot wrote:
>>>>>>> Hello,
>>>>>>>
>>>>>>> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
>>>>>>> lost connection to test machine
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> Tested on:
>>>>>>>
>>>>>>> commit:         d8795075 mm/huge_memory: do not change split_huge_page..
>>>>>>> git tree:       https://github.com/x-y-z/linux-dev.git fix_split_page_min_order-for-kernelci
>>>>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=17ce96e2580000
>>>>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=714d45b6135c308e
>>>>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=e6367ea2fdab6ed46056
>>>>>>> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
>>>>>>> userspace arch: arm64
>>>>>>>
>>>>>>> Note: no patches were applied.
>>>>>>>
>>>>>>
>>>>>
>>>>> Thank you for looking into this.
>>>>>
>>>>>> My hunch is that
>>>>>> https://github.com/x-y-z/linux-dev.git fix_split_page_min_order-for-kernelci
>>>>>> alone is not enough.  Perhaps on ARM64, the page cache pages of /dev/nullb0 in
>>>>> Yes, it only has the first patch, which fails a split if it cannot be
>>>>> split to the intended order (order-0 in this case).
>>>>>
>>>>>
>>>>>> the test case are probably with min_order > 0, therefore THP split fails, as the console message show:
>>>>>> [  200.378989][T18221] Memory failure: 0x124d30: recovery action for unsplit thp: Failed
>>>>>>
>>>>>> With lots of poisoned THP pages stuck in the page cache, OOM could trigger too soon.
>>>>>
>>>>> That is my understanding too. Thanks for the confirmation.
>>>>>
>>>>>>
>>>>>> I think it's worth to try add the additional changes I suggested earlier -
>>>>>> https://lore.kernel.org/lkml/7577871f-06be-492d-b6d7-8404d7a045e0@oracle.com/
>>>>>>
>>>>>> So that in the madvise HWPOISON cases, large huge pages are splitted to smaller huge pages, and most of them remain usable in the page cache.
>>>>>
>>>>> Yep, I am going to incorporate your suggestion as the second patch and make
>>>>> syzbot check it again.
>>>>
>>>>
>>>> #syz test: https://github.com/x-y-z/linux-dev.git fix_split_page_min_order_and_opt_memory_failure-for-kernelci
>>>>
>>>
>>> There is a bug here,
>>>
>>>         if (try_to_split_thp_page(p, new_order, false) || new_order) {
>>>             res = -EHWPOISON;
>>>             kill_procs_now(p, pfn, flags, folio);  <---
>>>
>>> If try_to_split_thp_page() succeeded on min_order, 'folio' should be retaken:  folio = page_folio(page) before moving on to kill_procs_now().
>>
>> Thank you for pointing it out. Let me fix it and let syzbot test it again.
>>

Sorry for late. I just got back from my vacation. :)

>> BTW, do you mind explaining why soft offline case does not want to split?
>> Like memory failure case, splitting it would make other after-split folios
>> available.
> 
> That's exactly what I think.  Let's wait for Miaohe, not sure if he has other concern.

It might be because even if split is skipped, the folio is still accessible (thus available)
from user sapce and premature split might lead to potential performance loss. But it's fine
to me to split folio first in soft offline case. No strong opinion.


Thanks both.
.

