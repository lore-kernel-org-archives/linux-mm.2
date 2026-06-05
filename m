Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F0BECD6E74
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 10:28:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A516B6B0005; Fri,  5 Jun 2026 06:28:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A02826B0088; Fri,  5 Jun 2026 06:28:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 917B06B008A; Fri,  5 Jun 2026 06:28:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C6976B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 06:28:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 250AF1A0B31
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 10:28:54 +0000 (UTC)
X-FDA: 84845485788.11.AD8ED5B
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf17.hostedemail.com (Postfix) with ESMTP id CE3AD4000D
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 10:28:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf17.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780655331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hB9nZHbj3LW7tg6p17wSYFXexCPVeKqxLkj6L5mhTGA=;
	b=lTvCr3ZMh/8uaHw/NJj/+5sklbrT1VDltMHbyw5V86dv42o0CUlvowQXVIqNk6+rZxxcFk
	mcZJeerdYEmUvOAluOMg3ywoKfKapBk4TqSd6dyhRDcQ7udHFJVqNEV1viPm4JKXBrhCr+
	Tim+8Qfu/Mm5JufN95yz/jdVnNlUckY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf17.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780655331;
	b=TguAtfRzQwJD2s4uxSIdieJcYr8gbm1vWjwW1bg+byTfUKqsoMRKvQZHaGdRhNuihq2KUi
	VxN7qgMqBSrfVOTkLO29czijsxnxM6/Sy5kDlyGm/uLE94j/O+Xa6LTX9hk36kB+xRG+2O
	cLzMUhs4ootihYenbJzsaAkQ3vO/2Ns=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4gWyLf1WBlzHnGgv;
	Fri,  5 Jun 2026 18:27:54 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 81F1C40584;
	Fri,  5 Jun 2026 18:28:49 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 5 Jun 2026 13:28:48 +0300
Message-ID: <441348c8-f98b-4eff-9fb6-784932b390a9@huawei-partners.com>
Date: Fri, 5 Jun 2026 13:28:48 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 4/4] Documentation/admin-guide/mm/damon: add
 DAMON-based Hugepage Management
To: SeongJae Park <sj@kernel.org>
CC: <artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260605010943.83146-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260605010943.83146-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CE3AD4000D
X-Stat-Signature: kyewxzbq8j8jgtiey4w6zw8hmbgqrws7
X-HE-Tag: 1780655331-539840
X-HE-Meta: U2FsdGVkX18sXVqKFkFQ+cyOixi/nYdv6brxiW+gMncdCIhlC/6DVxjSu9/GIiJRP1pBKNJiSBrzUkvDKDQfuKMVRmz1BcPY6pcjAi5f0lloj9b4Z7AdBRBdSv7F1spba4QfZmCdsOVk6X+2HeDgiyTJNAsZDNcCHYLRNeN35x/Oxgj9iCSFxSzvhGDE7zU8B0HV2juIdSKm5fAqLrld2F7PV6jH7NElZdyN8wblKVK1w6vNAd0FNqWWPvxCmAugNEn+2WOrN7KBGnzHEOkCogvQVd8IzP4Ck72DJlvHpR/76i9aEoL35AhsVu7jUc5+BKW40OHRblhZee3fUhgTam0tAsthUFDLiHnxtM22t5pB6NMCUPt6Kio650d4FKTaST59xsW6yJlHcD9zGYZT4fJbsZ7clPlihzG+y8WwD2aNjudndplL42oWaPcGsNve15issjiRF2quzFMXUqi+/3jhfsXnL71Z3E7CCBHRTmk1OeepMYH/nQPunV67Yt1VOQWN/iHUqfHD5ezysQHw5si3Hd/7xmo7vIeiyfBvTw2KUu9tnV8W3ZjHCUDaz2L4AuavzGZZqsK1q24pFs2rGnC6cIOPu+VCPgpsvApdp8NoV5PJLkVQ9L/OYHMePNknDKL3Mzf+OgiA1bT5nTDMT7N99YYPJkDin81bAriSpeg/dwySVe6vyuoGflBAL621KCM2AmOIK5hCHgJUGN2XSfMvUObD8/pFN18yH3OoHL119N4tMXLjaKkX/9q1IDxWbekLpiWjxZ4sJArRrsGWeHLsH5FpjShP0DraZNBeDB+X34CM8njizGdBly0GWhOeaBUqU0vT4geMNA+TcliND76oDN3+TzWrwhAMDkZwAVVOL1MG1rfjNCoy/WPc73G7HwS8Rlo8zrrXPT8n8lx3HBuMMKy2uEFboRKlwnJxg3mXYFJujCf96OunAUNX3DVggPZ9XmdWFADEXDbFwIu
 15Ti5uO7
 Xz/N9Ccgk1Z+aaG3lU/G0ITYwiogbJQArbIit2jQxNFCxGrubM358NnU3+M+KX5Fd6TmnmTFpgdG7uaWfAS1WVcukMJBTUMCQRcjg7pblF6YmC4i2xsu6r/kR0Fsm13YAUV8q/dkYAyio+vVpwrnuQJsHQyYFe2FRx1eAtz8P0d/AkMIGE2RnqXhvAHbodwGU0VGKXQbACRDxMh+Qb5+H/ScirRS7EDIsgMNRfvQr13uYbpNBOxT/GTgOZqcpscntppazLb7+0qTuAPcASZjX3puMFCtRry5n25waoSZzMC6ZCWrHcMBz9tw1MyzZ15N+rd97
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/5/2026 4:09 AM, SeongJae Park wrote:
> On Thu, 4 Jun 2026 15:03:37 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> 
>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>
>> Add documentation for the DAMON-based Hugepage Management
>> (SAMPLE_DAMON_HUGEPAGE) feature, which automatically manages
>> huge pages by identifying hot memory regions and collapsing
>> them back to regular pages. The documentation covers the
>> module's features, operation, and all available module
>> parameters.
> 
> For sample modules, I'd like the code to be simple enough to be able to
> understand it without a dedicated documentation.  Apparntly this documentation
> is made since you were following the pattern of non-sample modules like
> reclaim.c and lru_sort.c.  Could you please make the sample module simpler and
> drop this patch?

As mentioned in my reply to the cover letter, I will remove almost all
the module parameters to make it more simple.
 
> 
> Thanks,
> SJ
> 
> [...]
> 

-- 
Asier Gutierrez
Huawei


