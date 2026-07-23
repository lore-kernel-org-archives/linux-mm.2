Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB933C4453A
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 02:05:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 963D66B00A9; Wed, 22 Jul 2026 22:05:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93ACB6B00AA; Wed, 22 Jul 2026 22:05:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87A576B00AB; Wed, 22 Jul 2026 22:05:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5E5D26B00A9
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 22:05:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A95B8C03B8
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:05:21 +0000 (UTC)
X-FDA: 85018399242.20.61F2AB3
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9DE4A20009
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:05:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=j21Jbnt7;
	spf=pass (imf03.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=xiqi2@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784772319;
	b=eTUZgNx0Gza0O7ZDrIEpMgXJtvpxEMXWypSUGEf8SRUgBfquDuV6G73N+LINsbSPGiNQND
	sz+NkfVQYxp6m7kAxhqVUAE9cU88U90hoPTmpSCEB2Sr3NSES4q8d0M0JWKK07NbCKSA+m
	6Y7rFIBiLVthOgDJGSGxzuKbBFVVpOQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=j21Jbnt7;
	spf=pass (imf03.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=xiqi2@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784772319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hzYIGpBXbFZonwDEQCBbDgP46W9DkA6XzZteCy3etkg=;
	b=rk3FmyZOzTRgYTg7QbZRQEd24YkYW+MtqRK3pAc2HUyIT0oJlLMmdclwgvKY/lBvtDBn9K
	973DRbExH2UvC4J8nCRnh1rF4yg6PAWE7ytQnTBs0QDx3K+bk3gdtlZs6IF0fpJl3KRXDd
	zfDPEppW3PG2m9FgJO28FQ1wzhY1dBk=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=hzYIGpBXbFZonwDEQCBbDgP46W9DkA6XzZteCy3etkg=;
	b=j21Jbnt74JDV9NCT72cBGojfiVTFeBkYsniDEPCn/vszEk51Xxy62OO7uzzzjhsOyN0VBrTjE
	8WcqQwo0IFxJ4fVzYbQHXRU5xLMiXyO2Zu3tLKDghEulrlrN1iV06FDO80v7dkdcDMTNoWTziJL
	2gvYE0V/Eqdn1V3W7kfskB4=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4h5Djc4m4kz1prlh;
	Thu, 23 Jul 2026 09:55:48 +0800 (CST)
Received: from kwepemo200010.china.huawei.com (unknown [7.202.195.178])
	by mail.maildlp.com (Postfix) with ESMTPS id C98C04057D;
	Thu, 23 Jul 2026 10:05:13 +0800 (CST)
Received: from [10.174.178.56] (10.174.178.56) by
 kwepemo200010.china.huawei.com (7.202.195.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 23 Jul 2026 10:05:12 +0800
Message-ID: <0adae468-745f-4f38-bb1a-151b91bb47dd@huawei.com>
Date: Thu, 23 Jul 2026 10:05:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6.y] mm/memory-failure: fix missing ->mf_stats count
 when hugetlb folio already poisoned
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, Naoya Horiguchi <naoya.horiguchi@nec.com>,
	Andrew Morton <akpm@linux-foundation.org>, Miaohe Lin <linmiaohe@huawei.com>,
	Sasha Levin <sashal@kernel.org>, Jane Chu <jane.chu@oracle.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<sunnanyong@huawei.com>, <wangkefeng.wang@huawei.com>, <david@kernel.org>
References: <20260721121956.124887-1-xiqi2@huawei.com>
 <2026072119-facial-encircle-f1c8@gregkh>
Content-Language: en-GB
From: Qi Xi <xiqi2@huawei.com>
In-Reply-To: <2026072119-facial-encircle-f1c8@gregkh>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.56]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemo200010.china.huawei.com (7.202.195.178)
X-Stat-Signature: wmqy1q1658515myqshi84fcuuu3dagmf
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9DE4A20009
X-Rspam-User: 
X-HE-Tag: 1784772318-51287
X-HE-Meta: U2FsdGVkX19hsUgqrQ/X7GHxbQGCSyCoMe9cQrqUtY/anELH0z2mo09KwXBIUCOAyhQPOlJrhAV9Q9H16H/VVyRwPOOlNISOGf7IIcf+yfS99E2NUPzSR7PSOkENTSVgfUKMQPTrZU/fMq+sEiuWOLrn9KPmQRAI+aAKY758OQyojizcJoO90l+YcC7C+fO11c2o3TdwmpQdFOfxisgFVcMSszH8yZQ3EkU261aV7AfcXYR1KN0KnLYJxx21GlToy1k07eyBRID0shExw4MojmnranbfQlDQYA2Heyazya720yMbW6p07hnVVPhJpIMmc63XCC8Cq+5d/n3PevAV9JI78jdMjRJWj9+z5jdHi2ZX4ReeNSjgyP59jBzejaZNIi0SVY9niFG1GFkwY3+W0hRTwPRiI9okjUv/V0JVrWaqUJRJn5wsngP1JZ6gR+HANiU6NQkjqxEICuN6hT48aEuoak3MXSLlJc1duztbTE0pHBNyCbOn9N5Oe7n0rQWdhXdfXhDo984GeTpZRhxIyvaUF74jAVVpL+Xdl3wqm8n+vasTAUC9IaN5e7ECMdnvi3FM5oNA10mJzY7bRI97NcX7L+G7QMX9jjaZcf5Xaka7P/JPZWzrnTb5P7eyWw+PpsMwa3WJ2um78nDSg1qNMoTViBN8CwCt3EbHyXgYv1ezpYAiEuN3W6VcF6Fuz4zyV5yvugQ8n+qw4FPJ+9zPgZoadIndr4e9kWb6ewXi773pAe36rZfTYmduxtYqT9mtuuNhOOyuj755M8IjKNeYN9loVYc8qs9cu9B07KX+9i4FyN/cRjerDYp9rLw/TeQfBImd+UrQqEne6uya4D+jM8BOFwY6iGhNlua+jrctqhCI3KScAnlFouqw2swysEM5V42VX7eTZ4OEU6mjKZ4ls/EX30/aBDH8uzHPIZCBu2/6WEzPSCkKJSzXIN+dm/sGcgSxEqR3f6nSswkAQVP
 jYVSpL8l
 4FbY3gLiAUNwLFw58HSnIJEZ7NjpasPzouWu6vslbCEPTf5IoGIBGUbj/KMe+6dsc8m/ruVC/dShlLgZVr2m8dxc13GEYHQSfcDsD9JKQ8SZj5DVaxtBgiAbMXDQv7EuSlJb8GYd0eqSFbTBOjT9aKcJ77g4TeeZMwypdSxl8nSOPwYrFjL6b3ni7iFbzb5sNs6yrm+T4a3v9qEdk7uUf5vVtephm6iZFFrOJqAsU+k7Py8xauXJwFFnS5I0oc8NEnTegxXK3LrNBg8RI7ItF7loas2unH9Yv006SLV8z49xaxK1z5QH1I04tqGieICA8PQQ80u3wjVEgGrjL+nP0mlmEfVpQvlw9xnt94S7/fPpHYXfRUyAV//UAgvY1CtCXOGeHIInj//uJK6M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

You're right, I apologize for the misleading tag. This patch is a
follow-up fix for the defective backport 252bb328b36f — the bug does
not exist on mainline, so it's not a direct backport of any upstream
commit. I'll correct this in the next version.

Also, as in your earlier comment on the v1 thread about needing
maintainer acks — I'll ask for feedback from maintainers first before
sending the next revision.

Thanks,
Qi

On 21/07/2026 22:11, Greg Kroah-Hartman wrote:
> On Tue, Jul 21, 2026 at 08:19:56PM +0800, Qi Xi wrote:
>> [ Upstream commit a148a2040191b12b45b82cb29c281cb3036baf90 ]
> That is not what this commit is :(
>
>

