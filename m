Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66E9ECCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 12:20:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFA0F8E01C4; Thu, 30 Oct 2025 08:20:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B82FD8E007D; Thu, 30 Oct 2025 08:20:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A23B38E01C4; Thu, 30 Oct 2025 08:20:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8701D8E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 08:20:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 389645C5C7
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:20:46 +0000 (UTC)
X-FDA: 84054689292.23.0E186E3
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf28.hostedemail.com (Postfix) with ESMTP id C4B9BC000B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:20:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Loym6yJk;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf28.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761826844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bcOo5smro3BBVFhgM9fw1MzLtV1oJ1QG7H2cNzOgLhc=;
	b=ijM6LFGGSYHM+Ym1DNqsVUf1ZtA6v3fcbOyfcFu0l0iShiBU0sXeBEeig2BQ9pe8CyRdu8
	FQ+HMhUp0DR6RNdEaj1w/l53o7DsmrH3hyPrYSDmmHvaafrLk0c39FC7lCu21qKIZG+sM2
	9DB+1vFieMi46mrxO7Zn2qITWI3wZGM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761826844; a=rsa-sha256;
	cv=none;
	b=8rr1CZi5cxY3duaMhBXQbQbcdmCMEJF4mIt7I4oRxYb5Sv8rbYH1Bmq8Tivhcn1sA6qsDP
	h0O1hgKzsewWG59hws+L+IFB999LjE9PxehbguRBFX+Urcvr1V66gTMSyZo/zcdquNMHti
	qEdMZigK+B+ZNBIbq+ZXqPPc/FoEK4A=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Loym6yJk;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf28.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=bcOo5smro3BBVFhgM9fw1MzLtV1oJ1QG7H2cNzOgLhc=;
	b=Loym6yJk7E7apAwTDq/cnmFCKi+7Jb4uT2TVtKOjlmsrJyP9tyJSz4yEQw0QP9sAlkwrp18lL
	t3Fb4d/oSlol584j72OZJkje6xQ1qTXYvzVK1p4DDCjhIXrr1tMTus3UalpvnJeq49hNLQCAiE6
	+B/Ytf1nRgBV+7Ct6r9W4Ug=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4cy38l739Lz1prQR;
	Thu, 30 Oct 2025 20:20:07 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id F0D9318007F;
	Thu, 30 Oct 2025 20:20:37 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 30 Oct 2025 20:20:37 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 30 Oct 2025 20:20:36 +0800
Subject: Re: [PATCH v4 3/3] mm/huge_memory: fix kernel-doc comments for
 folio_split() and related.
To: Zi Yan <ziy@nvidia.com>
CC: <kernel@pankajraghav.com>, <akpm@linux-foundation.org>,
	<mcgrof@kernel.org>, <nao.horiguchi@gmail.com>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, "Matthew Wilcox
 (Oracle)" <willy@infradead.org>, Wei Yang <richard.weiyang@gmail.com>, "Yang
 Shi" <shy828301@gmail.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <david@redhat.com>,
	<jane.chu@oracle.com>
References: <20251030014020.475659-1-ziy@nvidia.com>
 <20251030014020.475659-4-ziy@nvidia.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <6e2c1fb1-8a22-d300-5b49-ed908e032a61@huawei.com>
Date: Thu, 30 Oct 2025 20:20:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20251030014020.475659-4-ziy@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam01
X-Stat-Signature: 4sajqetqdkxi7ydtmad5ze5kbbscc119
X-Rspam-User: 
X-Rspamd-Queue-Id: C4B9BC000B
X-HE-Tag: 1761826843-566149
X-HE-Meta: U2FsdGVkX1/x3c4grtkhlPPrf5Y/4CEgRnqtIbjSEpCXPbsup4FAU+ZihnhOAWGuWYj6+mBvol9bkykk0EqJGrEfpvXuyaG1Q/CgCQEBGzDWQrgudthljBV7vvBqlrYOT4GFLc+eIPxugB/+Nzn3Z6X5G8IMcpmM15zXz0ypQjHZJiIXL3LA6ttXjznQAT3ZB/KDVcaJ0dV251K0Jq++HpBnLFiqyhTvhnfkmZYUFX11Ys27J7XkagXnadYqhj2hGBh1x911rGu0sMmfTlOwqSiobtsdzOh/a+9/oCSqvDQnbwi6ItSRTx6+GfR+i3Kv5oqcPBE0hIonl+cg6TFM7TdWRZVqN8HQIUnSDvqO+V/IUkKJgz7M2bivOHLyfzeM9En5Oah3S62aR1sLsvHSpDM9EmuFy9iYG2LIVtvttMUjqhEvek7VI5RVHW8Z6oKTFJgCS/qRNFos/8JfzX05g48rZQOEwjC+uZ+CLd9t49d6RhCoS2CRfYlPlFNUeZJNC2u0iwSM5q95VlAVefU8mrOKK8RVQJJxxHkh4ThQYMdvsPLPmrAewR7YhlM2BDhGNzWzLikXY6lK9s95gYMCInWhQQixSXJn3AT4r12WfczhWDb7MMFQgo4cLzCdMeW0lVAbZf/WMTil0lMUatSZuCtQan/Cl/7EMNPbJXJz4APSdOKW2zOKnmax3k1/rTNFeyVZtjrUjbHeVQURM1CPUXTogUNyUl3c2hSSJ6kIbTihdF4v+fFlUegWQUzmyEoHRtue6St45mV1+cfeVQFliolImy2WMo5M7h8z/gDLeveisfSoSwplsVxfFCwfuGVNpHXPS5g8KHrywMo/3pw4bjerYIG+LVvDGLRkFMACJsDbv1F8Bo4M8y5RMW29IUbz1qwxgeyf7OTkSqEI7VBAb1/NSCvQkw5WbTRs5Gad15gmlwOMh5vRtkQqlIlWnSGIhoGCaFee2iF9OHWnSr+
 ynd93Xeq
 3ovh7mEQrepGEFCYsrk3KBovkmg9+TwudixWZOOypWVj6v/HFIGMFd4p9QedEvG2/1Rpyne5+JQlJpzlHRTheeRqr9jlN4gtxWWf9ccWVhUq6i67uTftriLEo6Ynic74e5WSvbib9D9V536WftdVGErdmIkgG8mf+9FzYQm1gXOfVP3VF9t1i81hudno2VZocuLQLPCBK8vEwMk3JxIqX1bn0fPb3LUQ9Umb72oQ6qfeJu+3Llh7f1r4XbnrWlPo8Wy8DYZOfx7l0fQcY96LCakFTSPncMe6B/3vGhQG6nyesMvQm7n4dnge3cuYjO5WS1ks+xmjLEtMGdPqg96iKz7K4pR9i9STdKTF8aUE93WSy3lAsacdQgC4T5p1GJMfS++fGDULDclo2fAZrs5keRo2MICzn3MRQ6rAunSxg62LIn0/djgx20AF0Zi3I3novKPq2iV+9GxzS6bnQygAx0eSbcpHLd87TVxQXpzs4+Yfx2h8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/30 9:40, Zi Yan wrote:
> try_folio_split_to_order(), folio_split, __folio_split(), and
> __split_unmapped_folio() do not have correct kernel-doc comment format.
> Fix them.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Acked-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

