Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 601C4C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 09:24:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5788B6B024C; Thu, 13 Aug 2026 05:24:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 528316B043C; Thu, 13 Aug 2026 05:24:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CB726B043D; Thu, 13 Aug 2026 05:24:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D9A76B024C
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:24:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 34FEEA2662
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:24:15 +0000 (UTC)
X-FDA: 85095710070.08.C04EAFC
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf14.hostedemail.com (Postfix) with ESMTP id A1203100005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:24:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=1Ip5Lfc5;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786613053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9KxJ4CU7OMfeQGCDQe3sqmyqrEL33tRgSM91SKD5Z7M=;
	b=fEfIB9rDpFRqHcQLOc62GYJ7FLDMc4/qhqCa1On9nVWyasrWKfuwJvEA5RZQ12KwiEOw8a
	yysvwYE0VusaApDk6ctdCOOpdNePXovp1CfTtbADtAzIvBfGL8wLv67nGNAejytU41A8pk
	Z5SLn8LoVnWJRCFWgqsK9ruy94hoT1c=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=1Ip5Lfc5;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786613053;
	b=kBgieEs9ypLhu4KorlFCHoPRgDNL5grSE7AtOyUMqVtA6IcFps2ATPT/fRiQE8/clN4azL
	425+1xZ2HNBqOUD3NHdjPmIxvXDNOCGTn+GX1d7gKtTmOl15nxkFYNU7g/4HfJv60sAjwQ
	e670CPQb5znwx2x2x8elMWdQAr7NN6M=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=9KxJ4CU7OMfeQGCDQe3sqmyqrEL33tRgSM91SKD5Z7M=;
	b=1Ip5Lfc5yZCJ73hsdB5wFH7n/dyJ9KFSIrnp4uJDuHZ4KADMJFIrYDBwJffos081x9fzLGUit
	tlhqA1J5+S0VU6/gsnjkJi0muOFAOq+Btwgqo9oqhuKragvBPWD5hv4aAfTB2SGtGut5nxrL5mk
	nJWzERkIh/OOOdy5vYJ/g+4=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hLKQr1yRrzKm4b;
	Thu, 13 Aug 2026 17:13:24 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 72BE440580;
	Thu, 13 Aug 2026 17:24:05 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 13 Aug 2026 17:24:04 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <david@kernel.org>
CC: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <bp@alien8.de>,
	<byungchul@sk.com>, <gourry@gourry.net>, <joshua.hahnjy@gmail.com>,
	<liam@infradead.org>, <liaohua4@huawei.com>, <lilinjie8@huawei.com>,
	<linmiaohe@huawei.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<ljs@kernel.org>, <matthew.brost@intel.com>, <mhocko@suse.com>,
	<nao.horiguchi@gmail.com>, <rakie.kim@sk.com>, <rppt@kernel.org>,
	<surenb@google.com>, <tony.luck@intel.com>, <vbabka@kernel.org>,
	<xieyuanbin1@huawei.com>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>
Subject: Re: [PATCH] mm/Kconfig: allow user to select MIGRATION if MEMORY_FAILURE is enabled
Date: Thu, 13 Aug 2026 17:23:43 +0800
Message-ID: <20260813092343.214324-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <837c2e83-ad5f-42f5-afef-5132e02fc19a@kernel.org>
References: <837c2e83-ad5f-42f5-afef-5132e02fc19a@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspam-User: 
X-Rspamd-Queue-Id: A1203100005
X-Rspamd-Server: rspam07
X-Stat-Signature: cf3k53n9hzuizo91frm6xmitfxyayc8g
X-HE-Tag: 1786613051-599698
X-HE-Meta: U2FsdGVkX19KrmsObNrMAGQn0VnnnOg4RIemwYj0aX1duz/3czpNofFijTZ3F/m8ktGQlpC7OVmYIG/SxMNovQxbi1UCk7Y5ObCcbZnHPcz02UMqUV8ENnMgwBr/m5vwAXae6eCRdouKyuGrgDJrPFwkxz+AWFvsLgZUq1yYH3tsj4G4YgZWr4C767qXVebYTAlRvVTBiSyNnscDV1k3x5gLuj5eThs/88QPM90o+xnIjqhvaJVEPEUDaqdy6eciOWvmU1PXQFVLeuC+kEkrdZRaMJbDmFT9+sEC6KKXYWF76ilqzkTb01FMQg5/7VfWpt0b1RptmgjOCe00ySRZd0J5N2iFbQ9O81qNvEBXYJYfJJUTyQShm1Gx7Kzm1yDp3+AgHH4jDLtbCcSxLIFeWJEXlgJ8xDw5pmExDj+0Kswx/VJCe8mejgjEVjpIUsg9KgoaYYOBuDFIjkI3aMQR9picIBpDscamFmOR46Bav2gJqe+VtZa98s9k2yBDQm0YBoPy5Hs+TvnlWz1L6nsktzqZHHtUW6uxTkzI3FMUlQWw6fSjwdugay9fFb3G+VXGbSFkziNCJoLLNqjzYGeScaF2OwO2WF520vdYTsJZ0KeROe5vMbLHxP//O8+vzSfSVyyG72bPXHr/vjYx+pU+8Q/cvzajeWWQKhfqFO84XDqq9TNz2HUvkGLwWE16BwrgJVganaKTY79VrQtBwEupMLikPOmOP+k8ctAnNK/iByDR/DWtiSW/VpvciS31L4+128pTMLYjWkdCwWHS5Z2NwNAhLKdIlw+bcboazJZ3QG58Cy03P7BZ7U/rPVI3t3gCYVeyJMkXq8lkCPzJVp6E1EXdB3/nMxj6jBGpaAWBp/pjpkFlifPxJdzRhRqS9OhAZ/DWbuWPdD0VsYiSoMdhcjhtkNhY3SzFufiGE6JH3EmNp1G1KutgaxaSlluZ4E9oY2O7rUvlPwX86dxK/Oi
 8mw/F14x
 M0qSquiAMJ4OYOO79s1lZ3MKnHfuuqRdm0OoBtEjcZBp5GI3pPieZGL0d5Ma/nWmpthHniVixtHRMQitNASJ9smeKfvjk+dDPz2l9lB+CLuTd96T7VStwV5M4QX74JN0P9j2eV2NvN9GYHt8Xjxaok93p6lcRxaKymhhoOO8yM/L+VP1PimJw6MA/PHlKhTK8YVhOKhNnL1FClZn0tY+Jqb9KaAGUWEUxw0ij43naeteT8Pk3JHNUExpRRZoPMbKNorCDQcIuhzelKjItULqpvQqLT9uywWj18wzHbVa6zslzl39s6qIh8srZd93pFsc8wj2pF9Y6PnM83q/WuCC1DcWBHMS0p7cUqPPFv57sdjCkOAcIctn2VYPidBQtO6Bp8bnTZFW1izrgWNEFzjdMQPLyyJkhdyDi6hht
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for replying.

On Thu, 13 Aug 2026 11:11:11 +0200, David Hildenbrand wrote:
> On 8/13/26 09:23, Xie Yuanbin wrote:
>> I think that just making MEMORY_FAILURE select MIGRATION is also a very
>> good solution, and I respect the maintainers' opinion.
>
> There must be a good reason to do something fine grained like
> MEMORY_FAILURE_MIGRATON, really.
>
> So if there is a use case out there that absolutely doesn't want
> CONFIG_MIGRATION but does want CONFIG_MEMORY_FAILURE, we could discuss it.

At least so far, I haven't encountered such a use case.

> As really only softdirty needs page migration (IIRC), we could also just put
> that under a separate config that implies CONFIG_MIGRATION, like
> CONFIG_MEMORY_FAILURE_SOFT_OFFLINE. But I'd rather avoid that unless really
> required.

Okay, I understand it now. Making MEMORY_FAILURE select MIGRATION should
be enough.

