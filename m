Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49F4FC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 13:48:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 645F66B0088; Fri, 28 Aug 2026 09:48:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F7C56B008A; Fri, 28 Aug 2026 09:48:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 534FB6B009D; Fri, 28 Aug 2026 09:48:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 320886B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:48:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2B3B1403C9
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:48:32 +0000 (UTC)
X-FDA: 85150808064.05.F28D90A
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8581C20009
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:48:29 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="zP/rGh0d";
	spf=pass (imf31.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787924910;
	b=DF5mOraQH5rksElj6sGQB7E0GlvaWnac1qwvOnlgrPvOl5Cd1ZlRHo3+6QqVM6sQW+3PSE
	/qBDiA+nBlKFk4DdGlPh7Nxjzt4YztzDS1M0UlSYTW9tFoKYhB1wKsPa12xpzRylb1YUDr
	IkFgPmcA4b+gj5ULMaZhvO62yUqhqhI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="zP/rGh0d";
	spf=pass (imf31.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787924910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J1ieJYPbDNiuX52GiK9zhEf0t/H/HbxHvWGNyCiu+v4=;
	b=QHqu+1x/0fOeHJjBxkA6yLvdl5FQIHrF5+T2h4QCPkKw78IygLuECb4FtdQp9LsoCgTppM
	XaDzC0MGoEp7J9o7ieP4mYl2znbHkKDXdxp10+0BmDBNAEP4LKVHJZfx33USVPsZkHDXC9
	lwSE43nMnF3ZthZiWI9JmVuDfb1PQrk=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=J1ieJYPbDNiuX52GiK9zhEf0t/H/HbxHvWGNyCiu+v4=;
	b=zP/rGh0dk1BELBjq0Zc4Qfjd02Y7orAY3TV0npmdI4UvF3g7xH08DJENULFGscJ40/322ZqNk
	DL9Be3+jtvS3SUcQi+I5dwrCRJvdS0l04jxaSb0pxDcMaF/wLdInLyExZIXJ+dXiGn2u0VoRyuw
	NtzuCm+VCxHXRaV7gGC8Ioc=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hWfpf4qYFzJ46ZW;
	Fri, 28 Aug 2026 21:47:54 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id AF62740571;
	Fri, 28 Aug 2026 21:48:17 +0800 (CST)
Received: from mscphis00949.huawei.com (10.123.66.11) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 28 Aug 2026 16:48:17 +0300
From: Nikita Panov <panov.nikita@huawei.com>
To: <willy@infradead.org>
CC: <akpm@linux-foundation.org>, <artem.kuzin@huawei.com>,
	<catalin.marinas@arm.com>, <cl@gentwo.org>, <david@kernel.org>,
	<liam@infradead.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux@armlinux.org.uk>, <ljs@kernel.org>, <mark.rutland@arm.com>,
	<mhocko@suse.com>, <panov.nikita@huawei.com>, <rppt@kernel.org>,
	<surenb@google.com>, <vbabka@kernel.org>, <wangkefeng.wang@huawei.com>,
	<will@kernel.org>
Subject: Re: [RFC PATCH 00/18] mm: arm64: Add kernel replication feature
Date: Fri, 28 Aug 2026 21:35:47 +0800
Message-ID: <20260828133547.154953-1-panov.nikita@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <apCLzAaw6oRIqbSH@casper.infradead.org>
References: <apCLzAaw6oRIqbSH@casper.infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.66.11]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500004.china.huawei.com (7.188.26.250)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8581C20009
X-Stat-Signature: xkfe6pxtowrd3sp8r47iwciyagew4u7g
X-Rspam-User: 
X-HE-Tag: 1787924909-500808
X-HE-Meta: U2FsdGVkX1/cDpz05tzs8v54FhCPg2zHvtLuAh6yoo9BIVSbI5HwVYcn8z2IxyaY7RopjHDKaRPOmw/d5N00vOu1fPMzesW1MMGXWhbR9BvR8kXJPmQR1wattuJMj1KH8YRkFiTyGXnnxuCXR6p4nEmrHsv1ldU3mpKra8ITsq2vRJxiybbQ54KNvuUe6DOekjby087LUWX8IYezfU2ElTzx74kGMCQZh3GfODMiVD0JBOd1OX93q19a8y9fm4jHOCwQRmMIBSlwpCgfmec4j5ut/nc7FMtDQQ1g8e5Xq/P18dWqR5vJTa7gKRN18Ocxpdhh8Q3hsXB4klYTrc0kJ5Br1Mgi7vcoUUTOG/Kusob96cfs2zMvESIFF+yqsa9v51dismI7l7hlfjAXo7hXByOoSmCETR1jza6Hr1C3OmTP02CbL5pX/V46Fjl7iNNaJGf7hZ9NJXNWGBOC9ZUU6Vf4D61ZIXdh3MkDfAoY8NHbYV9MPR4gKPKGSUOn9jOUm3w6GKfwlzsEmROFnKibs4yYNWLIBuoCt6Hi9ZWeSqOtGU36Em37BKbNBH+0VOZ0g4UwWRQn78nislI7EPDXgBdPRGhJBJjIVhG42Y3P2SxzyPevMRYSOw3A6CfApz43mpeq0jyEScIhKSj5FruCw7f5USA3024aqlemnN2z70pNSQuRXYQ+lTs+pZMrKsontWutpmdjr2u/A2xxPUz7qDL+M73QaGtUj3Zl0QXY8NWiZ5eX2XS0+/jZ5PWKZb3whdsm6+ALk2kF0HsDf2yjUVDlgudJi6JaZ41wMdjy229RNLy/4//xTI+tSozU8TyUSl8QJsfPJAEuOmHPtN93PpaLZComfJW+6vm9O3KYi10HgdfEEJyhIoT0NMdK4B4JqoxsCcmSJhnUSL4iv45weomuW9jj8HLTvJKSUXmpQncHNvk0LNHLuPZHNk2xIz5SlrxDAWomktiIPNExg6l
 GN0kdi2c
 FPrL2KkTb3U9Dib0jHBNFPOgjmm5O4WTougVxLJTwQPWiUNDuQOmr0PCxpgwjQePncYMy7kB4i+6OaVl7SruoPAgo76q8/V+Gqy3//DylmNglKeWc7Xg7vzoKympsm6EqCPFBDRuaDj8Ga9ETI5gPcJiu2J6hl3+6kX3CD0FALrn59VKutNwkRgMAqUs5eohk1XzcX6Bg/wlDxvBIdCJLz/OS6go364mEOC6++4pHf/5vNHKbeExVcKrEFhPNBu0ncQ2WJTT9wvL//8o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, thanks for your comment.

On 8/27/2026 10:11 PM, Matthew Wilcox wrote:
> On Fri, Aug 28, 2026 at 12:11:40AM +0800, Nikita Panov wrote:
>> There were several prior submissions with some sort of replication
>> for NUMA systems, including one from our side for the x86_64 platform.
>> In the last couple years, several research articles related to solving
>> locality issues on NUMA machines through replication emerged as well.
>
> You're lumping a lot of different NUMA replication things together in
> your list.  That doesn't give me confidence you know what you're doing.
>
> I *think* what you're doing here is kernel text replication.  Other
> architectures (mips, arm) have managed to do this without core MM
> changes.  Why can't you?

Yes, this patch set is for kernel text and rodata replication.
For arm such technique was not adapted by the Linux kernel.

Regarding mips, this is achieved through the TLB lockdown feature.
For aarch64 this feature is *implementation-defined*. Moreover, looks like
not a single vendor of modern enterprise aarch64 servers actually implements
it. But even having this feature would not allow us to implement
fully function kernel rodata replication:
1. TLB capacity is very limited, we can't lockdown a significant amount of
entries. In case if small pages are used for kernel text mapping (64k kernels)
this approach is not suitable.
2. Some core modifications are still required - text patching at least should
be aware of memory replicas. But yes, changes are significantly
smaller and easier.
3. Replication in kernel modules most likely will not be possible due to limited
TLB capacity as well.

Implementation could have been done only for 4K page size kernels
(maybe for 16K as well, if we do not mind some memory overconsumption),
only for kernel text and rodata. In addition, locking TLB entries for
the kernel reduces TLB capacity for user space applications.
How badly this will affect performance, I cannot say without actual hardware.

BR
Nikita Panov


