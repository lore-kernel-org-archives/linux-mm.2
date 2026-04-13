Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCCADE93805
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 03:35:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18B866B0089; Sun, 12 Apr 2026 23:35:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 163506B008A; Sun, 12 Apr 2026 23:35:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09FB06B0092; Sun, 12 Apr 2026 23:35:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E9A0E6B0089
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 23:35:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 910BF1A09E4
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 03:35:07 +0000 (UTC)
X-FDA: 84652116654.08.3903D7A
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3AFDD10000A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 03:35:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=dKSsW1eQ;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf05.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776051305; a=rsa-sha256;
	cv=none;
	b=gGtwkgdHo/j5gGNC2c33rN5W0tGdi0MAY8/Q9gbA9HSqP8g/a5wPz4fr5mxKiZ9MLlVumo
	l6VxPdAqJEh1qsj0rSIh+TCLRJbgZIOW8IJSHvqJJPQxPVcVt643jubSU2DaV1F+wEbqr5
	NXmAmJWVcpnh/GmJy/s6UxdMKDjCGd8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=dKSsW1eQ;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf05.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776051305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0lo8Xlh8J6AAcOfJlZi1VaS6PaTCJdZoDYuoT/zI/d8=;
	b=nKCEWWimX59HIBsFt2dSTSWdPH7G1CCUay92a5DQpYEAAqlQQ+qwCs7nZgC9iblMqWyxAW
	gJdU2MccjAMbRV6EVsf5wkBARNuO4Uq3wglpWXTp8uyL4Bi4Pu6lMSmPbyx/AQrt+UoFRy
	DjlqgPhhFtNpD3O3UuiDO6cuaJ5F6s8=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=0lo8Xlh8J6AAcOfJlZi1VaS6PaTCJdZoDYuoT/zI/d8=;
	b=dKSsW1eQ1/cdHkunTqu4A83di7BCBCT8wS5h6xfCfFBEtG+7ubbFtUUSG4F+xTed/xU+DmrKw
	x3QDMPf9qZxNXaJsBEiBtWUCvLuNMYdHxo0cKUfN6C8W+bjlayz2F5vMkDY3zRgAIS0r0Wp4nwC
	sDxdhKJu5UjXTPq3WNgEWPo=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4fvCYV3Rcdz1K980;
	Mon, 13 Apr 2026 11:28:46 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 3404940571;
	Mon, 13 Apr 2026 11:35:01 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 13 Apr 2026 11:35:01 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 13 Apr 2026 11:35:00 +0800
Subject: Re: [PATCH v2 1/3] mm/memory-failure: report MF_MSG_KERNEL for
 reserved pages
To: Breno Leitao <leitao@debian.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <kernel-team@meta.com>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
References: <20260331-ecc_panic-v2-0-9e40d0f64f7a@debian.org>
 <20260331-ecc_panic-v2-1-9e40d0f64f7a@debian.org>
 <e074d5de-f494-4995-2521-32de4f2bd34f@huawei.com>
 <adkCtR0LzJ7aWfm-@gmail.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <1265c3f5-9fdc-8718-6323-147fcbf52de4@huawei.com>
Date: Mon, 13 Apr 2026 11:34:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <adkCtR0LzJ7aWfm-@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Queue-Id: 3AFDD10000A
X-Stat-Signature: 91wrx59gw15379byimpgg4zpcbmn3np9
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776051304-18630
X-HE-Meta: U2FsdGVkX194dBYOT++y53kWppe6tthdcV91Ty1SxDyGwnW3H4DU86ZJhlEndanzIgEkNvG/vD3aTuRhS+uFFkhoytUegTiNSuOwxcUNKZX1EMi3JrGim0QuRYtdXVCXqoJcpMp5iDmtXmlXxRiyndYzhN5V25yVMtBo9KflFFuYHlFvW8mFjCkgen7zZBktYuy9UNkkqDvXXae3G12cM8XhtURbtg4KfOpMErUiIV4Bsk2X0xNVrkwXELcYdZsJVFuLuicudH40Utauy1O1N4sUA5snnV39mXxYcMRuSVlMbkF8UhgnQvk4YP641MGzqr7v5hSalZbWZUw10r26C5AMLrkm4KBGE6oulB3V/hXGIcdq5+DFEZKkejonkFdyXV1KG/1h8pQzTtkp8l/gR0JKcI7JsIIJmXLRevobP625iyjWMoDpjD+BEUR5QCO/YSbVcM0x/gExPsgq0FgHIX5TFVeFHzHCBwiMUSLPAz2Po3XOeVBTxRWS+61yiSIOz51PAtmz9ffZ9vCMyhRdagEULg2umzf08VQIyW6YyD/i5QidgvL4wF5OUU9E5/iyNDKgamm8ZgND1HZ2J2rffO5+h4vpV8APtuDYOWtvy4LHaID4RpxraXC20CAXOmqSSjsrmk3CyuxU6LufihrsjfLv56rE7rpO8H/zezJHbCu/aUXZxZm+DDDrJH3RTnseBlQQrt2DRIAU/4NCK4F5W7ONXt21NR3S0LH9duz2yKFB00Szyaj9EPD0VI1eE/4xWcAjsA2iXBwq1vLe4Qd0ZZL+hfDBWbH6zB/yMAFcJaJqVzOeAOIuKpqw/BVq58dVSE22IGEA1zm7rn6k9asZrnV/H43kZC52ZigdCcpFoVrs9T5U580tGg9j0fvQsFd3TJkjAlfIyWkdDtMqZrEcWQoZEmKNjSLKh0u2rVRvvahCtW4IOvz2N4f+rFbfYV/YwMemkWBqs35YkST/G60
 HJznri/Z
 ird7WmgciWgGg6KFp0d2fYjLlWmNYPVF9CS4fERYPgBQDk1HnKkqZSgCFrMgzqMj5hOnZ6NNYkTLZC8jw80hqCvYQ+UquEiBT4/mEhxxtpPX8LhDrMIRKCJvd2mIFr2h3/hmQg2HNoVyXl6ZogaOjciBxlcALaEjzTD8qSre0xaRUJBcAWlBtkpCyPHugBDGrxavoOoe6KebtA9CEeh0q1yUGY0rfpYzRI6g6DUhcfeJbygorxzzZsQdWOhuVyYpPvz9exh/xzUASVIFOgPSHd1DY6zWzSWl5LTOfneo0AL8crk9uZU2AbO0l48F16c1sgvnIdNmEuV8F51fcG2NnbIOJspmL6lvrmhNXeglfrA2YIWhTXfpdEmlFYVzJYIrJ1WVquX/7VJhL/5qAS836H8UppvaydkK63dHV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/4/10 22:03, Breno Leitao wrote:
> On Tue, Apr 07, 2026 at 10:56:39AM +0800, Miaohe Lin wrote:
>> On 2026/3/31 19:00, Breno Leitao wrote:
>>> When get_hwpoison_page() returns a negative value, distinguish
>>> reserved pages from other failure cases by reporting MF_MSG_KERNEL
>>> instead of MF_MSG_GET_HWPOISON. Reserved pages belong to the kernel
>>> and should be classified accordingly for proper handling by the
>>> panic_on_unrecoverable_memory_failure mechanism.
>>>
>>> Signed-off-by: Breno Leitao <leitao@debian.org>
>>> ---
>>>  mm/memory-failure.c | 6 +++++-
>>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>>> index ee42d4361309..6ff80e01b91a 100644
>>> --- a/mm/memory-failure.c
>>> +++ b/mm/memory-failure.c
>>> @@ -2432,7 +2432,11 @@ int memory_failure(unsigned long pfn, int flags)
>>>  		}
>>>  		goto unlock_mutex;
>>>  	} else if (res < 0) {
>>> -		res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
>>> +		if (PageReserved(p))
>>> +			res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);
>>
>> Is it safe or common to check page flags without holding extra refcnt?
> 
> 
> Yes, this is safe. At this point the page has HWPoison set, preventing
> reallocation.
> 
> PageReserved is an atomic flag test on struct page memory that's always
> valid for online PFNs.
> 
> Reserved pages are inherently stable (kernel text, firmware, etc.) and
> don't change status dynamically.
> 
> This follows the same pattern as the existing is_free_buddy_page(p)
> check a few lines above, which also reads page state without an extra
> refcount.

Got it. Thanks for your explanation.

Thanks.
.

