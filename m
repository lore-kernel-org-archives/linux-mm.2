Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58F28F531DE
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 11:08:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C087F6B0096; Tue, 14 Apr 2026 07:08:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB9816B0098; Tue, 14 Apr 2026 07:08:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF71F6B0099; Tue, 14 Apr 2026 07:08:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9EDF86B0096
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:08:30 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 613F9160575
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:08:30 +0000 (UTC)
X-FDA: 84656887980.07.B226B3E
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf21.hostedemail.com (Postfix) with ESMTP id BBA1B1C0009
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:08:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776164908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+2wk77Ll2Cgdf1/iF+XmSnox2oYS5cT/x/ZKhsL5Pjs=;
	b=QSMDE8FasBQ5Q/g7XswrP58b71fFSUNzggjTJituCBm1VGpbYcMkOzQczbFxWj5oVoxm1m
	5YKJJXt20NdfllDFpme+shU03Qxl295AAJPoEn1GlpUcokM8aCo3ElZG0lLW7Yl2Q8diWP
	v7z3qBKs1JbrnKm4oJebCvxpn680xJE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776164908; a=rsa-sha256;
	cv=none;
	b=wHZ6DnW1lCTrvmvaku0Q/QQxTzSFR3BGLGvCCLj8nh6ti3cpb5xeO2aO6/kgd5jpKn+ih2
	RV1hO56wy5yP6pEbXKOvVjIfMCE3bpnBE8Sjo0Xp2GGiuUMKTOATqYk4SK1fuEPGKTwmRL
	Jumne0neZRzvpRUmCAf7EkfOr3xH61A=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fw1j46KR5zHnGgW;
	Tue, 14 Apr 2026 19:08:08 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id CF6ED40569;
	Tue, 14 Apr 2026 19:08:22 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 14 Apr 2026 14:08:22 +0300
Message-ID: <90f923fd-a521-44d8-9d7d-d137b0119002@huawei-partners.com>
Date: Tue, 14 Apr 2026 14:08:21 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 1/1] mm/damon: generalize ctx_target creation for
 damon_ops_id and add vaddr support
To: SeongJae Park <sj@kernel.org>
CC: <artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260414004739.83961-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260414004739.83961-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BBA1B1C0009
X-Stat-Signature: w6qyj6h1n1fthuj85miiqpt7ck9prw3a
X-Rspam-User: 
X-HE-Tag: 1776164907-960036
X-HE-Meta: U2FsdGVkX1/iVQh9opWPHwZWBgsy6SlzLSdKrMKmmaP+TvHvkk6s69W/f+RMgXcamEZRbw4itdthjoB22Mn295fHaaDfpjUFqtoN62zcIDGRfn67W011D+dQMeBxNnpJy6HRV7aQYtXu/B2V3E+wYxQO1PnTiRBnkusNMrx6vkSVZMoSBuxIFE8qtdr4SfyJRrIBY5phEHprO2DUos0HoYHJ1XAJ0Tpp3mvxBPADdWS2i8r/LRX/VV6OtnIRVVX17BAcct73m3TsQCwYli4h/F8PIkiCLheSFCVzS4SFGkZJHxBlyNiJoKGtnWH1+EHJbTNbQl6g4q9BRRswkdLBaSHCtNf5ZFJzHklgNykNTH2PuIOODpFgDBilANwVsJPPlz3OB9SgFAp4TCrU5BQIoHVGWgjVrgVzkd9zkA/k9+B12HnZTNpjYZQDm3tDZ650i2tk2cUulOb0bwESFPErvMe+F2tfqW2SksOP6rvCHOVuaUcDZi8nEV9dBSiouQmdNnwsEZuOlEPFl5Z1fjtiQjtnCnM+LDPsOn2HIGlheBx4vRUMGfzCMnWve/u5/fNQ2tUgclU1WT7C4uiIlr52LrzagzcrWIU6IGTM1AWV4cO0Khyi4YJfsCUOA7lH2J2K0mwK0WQ+tPPDuzO39daGTcpqKweYsteXIgF+VsDiKayDfqTIQQRCTsjBHuhPTqOZOtr1mAz1S2/wYCQWJ2PDyGMFxVMbiX8TDrmLk39dr0y9HzrBzbvQl9Iv0SXc5C54WBagmjwDY2yLCmS0RBDbWdCk9JPw1IniM0pyv2ediNKYDJiEGl4qz8kulJ1xE7706pDhSs8HmNoS7ta77/pDM7KUXOHB+ljqrk0IbTIorCk3Q6/QegLqvJ2e1U1lJP5yiwfcpgJndPLlLuuOHfWRmHxVyGv5fIDZZulortIRMzmkk9FC/cOuRZO+RnAFRVmPfl6rqvIeP63boxgpauu
 BFdDabOO
 eSFUkHGzlg5x4BsOT4DQ9HSqIc1rku/qCgdLEzhthR9EWF90aF7WUkMQTTgUyDkVHBS3MsZNC9+0K7VCu4mHO7nYAJIps6np0QsGWqc+h8HQ+KHafO0EJCbyFxt09nPvR6hDz9NlbZFyZvHMrKGfaN4J+XblZLWxUd2NNm7oJuWNvtWS2JyZF8REHqP9WREpAcPCMaOgWtesob7kQlnkGpE0Vjgunwnkhn5Wsv5O4leEa9nlGObeypTZgVAS9b44r9YektEq/D4Wr0I0sZVuujLctISeiPrN+iTR/RfLG3iN753iurf9DIuTWiGF/91db6b08XzIXy0J1IMDhnbbqEEKfzeevkXywpDxc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

On 4/14/2026 3:47 AM, SeongJae Park wrote:
> On Mon, 13 Apr 2026 14:59:43 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> 
>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>
>> This patch adds a new function damon_modules_new_vaddr_ctx_target.
>> Since ctx_target creation for vaddr and paddr is almost identical,
>> the logic is extracted to a new function,
>> damon_modules_new_ctx_target, and vaddr and paddr functions are left
>> just as interfaces.
>>
>> This change was suggested earlier[1] and it is needed to allow
>> developers to create DAMON modules that use DAMON_OPS_PADDR targets.
> 
> You mean DAMON_OPS_VADDR?

Right, I missed that.
 
> And I agree this can be useful if we will make a DAMON module that runs for
> virtual address spaces.  But we don't add new functions without their callers.
> So this patch should be submitted only together with the caller of the
> function.

Fair enough. I will carry on working on the module for hugepages autotuning,
which will use this function. I will resubmit this along with the caller.

>>
>> [1]: https://lore.kernel.org/damon/20260311005759.90440-1-sj@kernel.org/
> 
> 
> Thanks,
> SJ
> 
> [...]

-- 
Asier Gutierrez
Huawei


