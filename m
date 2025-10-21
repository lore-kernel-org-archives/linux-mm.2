Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 953F5CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 12:54:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74DA48E001A; Tue, 21 Oct 2025 08:54:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FE2F8E0002; Tue, 21 Oct 2025 08:54:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63B478E001A; Tue, 21 Oct 2025 08:54:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 511608E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:54:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0B5D011A18D
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:54:19 +0000 (UTC)
X-FDA: 84022114638.21.217A9CD
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf23.hostedemail.com (Postfix) with ESMTP id DEC8F140013
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:54:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=MtYMSWVA;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf23.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761051257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D5CTH0PcVQtwvHnKvGV7QFPZYK3yvjP/nxrw8vGteL8=;
	b=UPlrBVWV0vtGOdxN4uNGtFNuJn1DqcSNIZG/07WcNs3tASlBznGiRgqSDAMf5w0X7G0nTV
	S8UfEazPfPqrm2QZo6Bu0UmjKcAlZjxBQ64GRii+LAfP2p89bnFPSBxmrGrennLZhJJT0A
	TUpmFJCU5iGpn4s9QQXXGyqImt/BSDM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761051257; a=rsa-sha256;
	cv=none;
	b=mBzlZJLs1zXSQdTwwOnmPhmyn8Ph5ppeb68Wk2mtLTujEfQ4HYfhTMq9+qUjkEeX7jZ9J3
	v5YTBqsmLg9SawGjUP0SLrFt8CzwW4ofONto+wnOv8u/OqdhWnauNDPPbYgMmDeXBolr+E
	BP/jvGtg9XpRjkxzoDddzjSyffK1gvg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=MtYMSWVA;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf23.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=D5CTH0PcVQtwvHnKvGV7QFPZYK3yvjP/nxrw8vGteL8=;
	b=MtYMSWVALwj0vtqWs4wdWILw5F07KbRq9ciDZrO58ybRq4ZPDRXJ6IDpSF8p2sJn//yOszxqQ
	fs3eVPkPFiKPwUHXtNXz1GIXGJ64xryBQe+V9w2QVUMf4Usl0QGl7uQ470A9WZ0PRJ6xxl53MIc
	jXKvwKY2UrP3Tl462WiSKQg=
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4crXKk1xvdzmVC5;
	Tue, 21 Oct 2025 20:53:46 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 4226B18001B;
	Tue, 21 Oct 2025 20:54:10 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 21 Oct 2025 20:54:09 +0800
Message-ID: <3554c866-5087-4beb-8d63-6a3cea02d431@huawei.com>
Date: Tue, 21 Oct 2025 20:54:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/4] mm: mprotect: convert to folio_needs_prot_numa()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, David Hildenbrand
	<david@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>, Zi Yan
	<ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts
	<ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	<Liam.Howlett@oracle.com>
References: <20251020061845.3347258-4-wangkefeng.wang@huawei.com>
 <335895bc-c2ef-4ee1-a423-06c673a67147@lucifer.local>
 <1a97f0e2-fc97-4257-8540-cff06a789e32@huawei.com>
 <5ff1ee06-375b-4d5b-b513-7b8cab4e8139@redhat.com>
 <f1d3d11b-6ac8-4747-b2e7-952d4fc3e09b@lucifer.local>
 <719c8df8-b4c9-4a6a-bedf-d62becdb09d2@redhat.com>
 <759578b3-d582-48cc-90af-491210ecd90f@lucifer.local>
 <3ee89484-9cdf-4c50-a5db-79b9f2ca6886@huawei.com>
 <967f61db-0ee3-4257-a44e-69ef15ced012@redhat.com>
 <944fe458-6391-4cb9-8719-dbaf69f3958d@lucifer.local>
 <72e2f6b9-d241-43aa-9a3b-2f13c763bef8@lucifer.local>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <72e2f6b9-d241-43aa-9a3b-2f13c763bef8@lucifer.local>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Queue-Id: DEC8F140013
X-Rspamd-Server: rspam02
X-Stat-Signature: c96bkbr5iib6gmb7cuaycfk6rywopg1c
X-HE-Tag: 1761051255-192472
X-HE-Meta: U2FsdGVkX19npDnZdojJkD8qaGtcWlbtScBz7PtSAPWtbXc/m07FexVjaXdsWO4mfpqqbhjfz36kHdX5c2vKCRbif7oDPEx9e/LEa0OgmRoOMe5OvhxTFFG1IE14o0elAtXlFcWKQqvWt0vag2aG+mqvnv3ka7YtBCj19/F18Y8y5jXJPhotnmASIa2m74ADzx0cjrGFmrbqY17avRF3ZwW9f0D+HFyZMNL0Yy2ahEiJu/BLJYGvp85cA/B8zRzyrvy51jrq8Bk2W7uT+Q2/cNP/9y0cy+FNp2Z5igfwvQnCEGwK1nJl1mwTMEfd40Q2FQ9BY4bP0AOgftfBXWhdCn/Ey2rJ/fNIFOOXEdeb8FdB07Z1vB11qK+0IMQzx/gAVfGHSMEOUW3XT/YlPkOz2NO5I0kMjnHIVLodNVZGQRJgwQab98T7CmfYrVu8hj1+yc3wUmRqPMlnMm4e2hAdSasxnUjsubOFtrQyc3xBgdlhHOK5KrOdP3kfgREcBl3LHIoGqiBLNOZjAkq5WsB8jt13cFWvDxwzQPc2qdlhJ/3IWS7jjo+3EuMdhAMvBtAnRBz6EzS/nB+//z1uFa9tOrt4yICjXBHb170aOFtRSd9NSCk3/fSP/exsEHMnBB6hvcFPES5jecTHvyHrlBacLQipyYvwrbU1juVimCAvfm3UO1RhefcT43QlLL+Hvkf0kH5p30n8LwUJ1yvpGuPvKrbuvMJrsOh2+mbHbZvqMZ+vHX49up0b7bG+HklzlBr4NwSCa7hh6dBrJ5G6QzJBokn1dTEDwDKpWYZq9DrwPUmGEmqzFT11rgwV4g8pDt8lx8M1AmS8oHT5XVCLJ8vvm0OZEAHxZtmtB/pgY9eHLfx4D/pJ06D4S4jEHmsTmufTVdiSYvSjGyvjFx2VC9KZYG0MPvL1UI6gNS4wpkwdI1PBtf0YTwxlgldefiwhTy1UNlp+Sv2ALms2ujoy6dX
 RaeJBjmC
 +rb6iC4ZYTTQ9HMF7k9VU+MS6tCxwS1QrGzPRxcMx41Uggd4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/21 17:45, Lorenzo Stoakes wrote:
> On Tue, Oct 21, 2025 at 10:25:08AM +0100, Lorenzo Stoakes wrote:
>> On Tue, Oct 21, 2025 at 11:13:32AM +0200, David Hildenbrand wrote:
>>> On 21.10.25 10:41, Kefeng Wang wrote:
>>>> Maybe folio_needs_protnone_mapping()?
>>>
>>> I think prot_numa should be in the name one way or the other, because we
>>> also have ordinary PROT_NONE unrealted to NUMA faults.
>>
>> folio_can_map_prot_numa() semes to me to be the best choice.
>>
> 
> I don't want to hold up the series so if you guys feel strongly, leave it
> as-is. But this reads better to me.

Let's keep things as-is for now.

> 
> Apologies for this noise Kefeng this is hardly the most important thing in
> the world :)
> 

Never mind，thanks for all the reviews and suggestions :)

> Cheers, Lorenzo
> 


