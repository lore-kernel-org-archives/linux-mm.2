Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 461F7CD98F6
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 14:59:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2107E6B009B; Thu, 18 Jun 2026 10:59:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E7CC6B009D; Thu, 18 Jun 2026 10:59:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 127F16B00A0; Thu, 18 Jun 2026 10:59:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E0E866B009B
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:59:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5B49EC0592
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:59:44 +0000 (UTC)
X-FDA: 84893342688.23.F1C2E63
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf23.hostedemail.com (Postfix) with ESMTP id 427B214000C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:59:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781794782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CfViTBT8JOO6hc0x/UUKvjQMxqtciSaN2WlWdVs/LdU=;
	b=ocHQURu/GMP6jf/u5F8Sb30w/xPFEeWBsv6bDsrIEWgkajLYKwJNGd4++S6r2Abf+Uieau
	aA/j4dPys2o8PddZwxXXnTIJEs8jTEM7nB15/4Nz3MbPXkhJea9S7MXxDb4f3hTVKhYGC/
	bLPofbpn849es+pcqkXqki49xhMaf10=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781794782;
	b=oGKklOLxeldbCbuoNNBVIlfSNrELQtJx3H/IBSRNLJjpD/DC6AITH9Bh95lLytTEIWjkpn
	GNsq1AH4cJ/mDGD7EolkwlQ+erH2ULVy2HA/Bz7zKk02yhWUi5WWWMi5V9zgaol0YYOJ4F
	Led0EudfjzENVaalvgrXloLwCt2OemI=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4gh3lf4ZKJzJ468c;
	Thu, 18 Jun 2026 22:59:10 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 71FA840575;
	Thu, 18 Jun 2026 22:59:37 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Jun 2026 17:59:36 +0300
Message-ID: <4cefc3af-67eb-4bde-89f6-8c3ea3c93588@huawei-partners.com>
Date: Thu, 18 Jun 2026 17:59:36 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/3] mm/damon: introduce DAMON_HUGEPAGE for hot region
 hugepage collapsing
To: SeongJae Park <sj@kernel.org>
CC: <artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260618145734.4477-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260618145734.4477-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 427B214000C
X-Stat-Signature: iyhsapzoqbgm3wjrhc7ah4nfigm7ispf
X-Rspam-User: 
X-HE-Tag: 1781794781-998127
X-HE-Meta: U2FsdGVkX182xIo2xYpW72FnJHtJTnx9Cpdw3btzY1RXhVmwotz1SCHvvMTyjqLy7IMdhmr76yz8kMpSPAHktgBxGOFRukWSygaFhlW4b1XQF+5Fso1fif4qKFUSxf+uMC7g2DkSJsIpbtv4XUY5D44klGaPaDoCbt+d6Sg7be+EJf/Av0VUjHOcr1+8ohbO8OdA09jP4gHxAff5ckdUq8O+5yYNROO+k0nGMFJfqOj9+QUtxsq0jOtcEnyU36NSoT0q8Kq0SKlaTWtyBpJGBsw9LZSsi4OohLlxmwkZO9fRSejxg62SJNUd8g69PTnqqsVK8xoIUKozHqhtKmE7P3/pgIqH8quJ3fX1tBQd0D/gmVZ7tavsFYlEGiuvn4T1y0l3vmIGEWa/IWNWfIn0TeT1d/47nw9qTTGxxjJaCvk/UJoDz3RbfwLXslIan/dxcEkrHVOuLD30DoC7o0IGyW29Kp6AeqsqTZQUh3yOChRBFp69CCgcgFer1qM64JM5cjZ+vdwr/5QNFd+G+mzScVGmcsxWziJ5LEhA09LVvmGRnHs+Eu/vW9wYVZQg9mAsnTiGJVO8Lc3Z7wVFzBMkxwvCDKjUoErIzhW7AsyNCIv3Hllww+/4wKDxf2JN0jej95XLQevGWCvtb1f4lynKc0RdmNRQlV1XBkenLjD2uLv4Hej0KRkKuTDTTT2XNHKSiek14W27KyZdwZGNC6JeCWB0/nlS63jEXYxjevRvF4up9GVQkkocEmj8BVobq7fwRgqjNxwHgkfVq6LTdIIljDRQDXgCzE5a207ZGobo7isTiY8bv9VTWaxMmM0MPbRUonHGM4TzSBy0F/FmPIwNwYgsv+QHF9HPQcGpeBCA2DiSbvwuqkZyVaW30gNzpB5EAU3lw2Ky9nA9k+lh1LG63WffF01AdP0hb2fiso1SrXJTgz2PbyJpEghfSOozdZBmY33teFhO/zF16lkydHP
 bXjBhc5i
 Eyudsw2Dw4P9NPEk7KoPkWtGOCbOobDJn98fvGGko3RPxaWzj59XLj8+hqr3FCPBKDm8/uI0i/6TGxfFrLs8//EVjbBEICslb5XCCMJe2kvDNGNyAr5U9UYhuYql3LFlFuFb68l275djK0YfNs3Ra+BXgpebAbW+vqWqO24pZxdhJ+t58gXzbiLtvE33cE6Fc424jq2SCvCtpoAyLLiSQhb3Ieo2msuRkt/V0L7XSEbl+6ZM64x+LkeLnP4+OlmvCX1XrnMGee9bv0eOXm6oz/uIFQzw4ZIgESHVmpRI4fPq9Bg47fPWjCgvGITPBU6vR9QXJdK8SV2F9Q60Ht0sjkavtqyQ/Js/78nLm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/18/2026 5:57 PM, SeongJae Park wrote:
> On Thu, 18 Jun 2026 14:51:42 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:
> 
>> Hi SJ,
>>
>> On 6/18/2026 3:16 AM, SeongJae Park wrote:
>>> On Tue, 16 Jun 2026 21:04:52 -0700 SeongJae Park <sj@kernel.org> wrote:
>>>
>>>> On Tue, 16 Jun 2026 15:03:15 +0000 <gutierrez.asier@huawei-partners.com> wrote:
>>>>
>>>>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>>>>
>>>>> This patch introduces a new DAMON module (SAMPLE_DAMON_HPAGE)
>>>>> which collapses hot regions into huge pages.
>>>
>>> As I mentioned on the previous version of this series, this sample module looks
>>> much better than the initial shape to my humble eyes.  Much smaller and
>>> simpler.  I really appreciate Asier's efforts on making this.
>>>
>>> However... I was asking myself if this module is really needed last night, and
>>> still got not real good and confident answer.
>>>
>>> After all, this is a sample module.  The purpose is to show sample code thhat
>>> helps people understanding how they can use DAMON API.  Maybe we can argue this
>>> module can be helpful at understanding how DAMOS quota goal can be used.  But,
>>> mtier is already showing that.  So I cannot say what new advantage this module
>>> is really bringing.
>> You are right, the main goal was to show how this quota goal can be used. 
>>> Meanwhile, this patch adds ~200 lines of code.  It is a very small and simple
>>> sample module, but still we should maintain it.  I, to be honest, getting
>>> little bit concerned about the maintenance overhead now.
>> I understand your concerns. I know code need maintenance, and DAMON is already
>> growing significantly.
>>> So, if Asier has a good reason to add this module that I'm missing, I'd like to
>>> humbly ask to consider dropping of this module for now.  I'm so sorry for
>>> raising this concern this late.  But, Asier, may I ask what do you think?
>> So, are you suggesting to drop the module and upstreaming only the DAMOS quota
>> goal stuff?> 
> 
> Yes, if you don't mind.
Sure. I will do it a bit later.

Thanks a lot for your help reviewing the code so far.
> 
> Thanks,
> SJ
> 
> [...]
> 

-- 
Asier Gutierrez
Huawei


