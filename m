Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6D6ACA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 10:10:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AB238E004D; Wed, 20 Aug 2025 06:10:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 582A68E0003; Wed, 20 Aug 2025 06:10:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BF3C8E004D; Wed, 20 Aug 2025 06:10:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C5348E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 06:10:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EEFF0B98A2
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:10:34 +0000 (UTC)
X-FDA: 83796716388.27.0885F00
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id A85271C0004
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:10:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf21.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755684633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PjAMikHfWrpHiEzgFZIdUflBvcI9deDkg9SZqTvLmIA=;
	b=BqJtXNgTwV75qfm6b05trkyslyWbcnTYuyOHJ0FtD0In4RIwcNGFcxPyH2n6b1sWa8g1Of
	q2m/Dp2skqShkMEUg9GIe/arEbQb/TS5Pmjo+C0ngBsOkOdNYbZojAu5maQybKGYQq3TGi
	BdcU7P++U7CCdiYglbFqQOsrMcpOr7M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf21.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755684633; a=rsa-sha256;
	cv=none;
	b=gz6bBWzIg5I6QPkj5zRBn70MugtzN9vLGZ3unM5kEn1fJQl5mk5j6AnyXV7VY/vgqxv8eL
	qt4Tw/MCAYEKmDySzPYmwPq0vBK7mbi9WWw5v6VlD4qaPtpXWhoncmwfSvNb8bv0WrYNce
	1yUM/DzMPUa4bJfIfSu6pYoYpvMKBes=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4c6Mg92sFlz27jPT;
	Wed, 20 Aug 2025 18:11:33 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 15F441A0188;
	Wed, 20 Aug 2025 18:10:28 +0800 (CST)
Received: from [10.174.176.250] (10.174.176.250) by
 dggpemf200018.china.huawei.com (7.185.36.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 20 Aug 2025 18:10:27 +0800
Message-ID: <688958ee-4db6-4c33-8640-df69e5d87e9b@huawei.com>
Date: Wed, 20 Aug 2025 18:10:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH -next 14/16] mm/damon/core: convert sz to byte units
 when updating state
To: SeongJae Park <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
References: <20250813170806.6251-1-sj@kernel.org>
From: Quanmin Yan <yanquanmin1@huawei.com>
In-Reply-To: <20250813170806.6251-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.250]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Stat-Signature: ob5c5zgar6dqrxzsz6r5fbx1ob7hzokp
X-Rspam-User: 
X-Rspamd-Queue-Id: A85271C0004
X-Rspamd-Server: rspam01
X-HE-Tag: 1755684632-395862
X-HE-Meta: U2FsdGVkX19zk2buJnujmIgb6YDavEqkkprOyWpMhLPqyQPGcFmPPm4Csfgr3fdxetGuugi8FU0t5b4WaSFWUJ+b6Po7GGCAjD6Xi//BWgJsdYjB2anO8a9eLdf3NWTJGbpq1bDKXIZ/uTawXKKEQ+jvGrB7mwwtW21Z/F35LHKsRztZwqyBtY+czUfT89IduENSutzpzac9YH6+PBTVPB0GwCd/5ydaGreI+FP4fYDfWr/tA8PvWOrJptsIHeE4Tb8Gu7WSbGdVtB/QxhJM+XF6pceVAbSzIu0qxk8moMG0ysUgl20pDB1pNPfriK0vmbqPW7YfNLAzujR5WcR+4tXa6B3SKm2QUyF18+CgS2MHKvOKyxlvLM19xbyUM/pDfiby/iiI65HDTVQEIKQVBzlZaHLQClX05mpTxz5hiBDUHHrtXTFL70khpcmqkSKwI4J0UpCg961T5OOoPiONSq+RzexQLFbo/1rb44L5iKW7ta2Qcv/bGUWD2bNcWNx1SvzQVh8yBDBPyfNfiulFhnE/6vIqNDu/7Ya5lC5JTBDSuwRhtVN2mhGAy3Fvehz3BqVri7K2gfJ8n8rVpLfslZPhcJRYo2rfD6BhEgbUr/RbFSNjsSo+2Fjyq8NyRYUp1TITc4ln8BcmKRRyjLI9IBFN7shphzZsnsWMe4O4QLoacYKh3wFIbZ7U1ONSTEFB9EyuJNc1pLKMvt5IYFM/YuwPcqpqVnLYETsggqnBuza5pgP9Kocr+EQwVvYvC6A0RjL65QsDRCZe/9KgJOXvaBIdyfegv4XzRnZtlDyt8mRo1D2hPoS2Oj5DTa5IIHxprdM81BCfuE+ISXGLZmy6h42ZqN2W3tvX0CViLNlyPsF7g4/4AMF4uZlmze3DXUXavfwtL4RWUMSO9YOLX1vPm+2iYDSBtdqSoKZEqyNcbaMGVFUkUIU+2kL55wgPK5n8kKH2om11V2yJQgWQDO3
 sd/mtoYC
 JYOHR680redX4a1142YvGPTbym4GVMaZrzu8eEH+9FcCfzdMljvbT/2RaF8mtCR4zPRlylc7F8bzBJxFrceYm0FQ0u2Qs7vMs71BrOopND2UHiT+ozXyd+L4MM/2rl2zUM20JZmtByp/bEo12gpueqs9tFUZRdVC6Qq8ei0LWa2WQf6/7JnU1jrY3dye8Fxrpl9g03BBjx93fV8m9qZHotdvYoiaaMrmYJ0vCDNotOmvYpZCpMF6P0a4reTnjHLOthXK9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

在 2025/8/14 1:08, SeongJae Park 写道:
> On Wed, 13 Aug 2025 13:07:04 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
>
>> After introducing ctx->addr_unit, the unit of sz might not
>> be in bytes. However, sz_applied is returned in bytes after
>> processing by paddr.
> This is not an intended behavior, but a bug of my code.  Let's update patches
> 3-6 of this series to return sz_applied as core-layer address unit, instead of
> bytes.
>
>> To maintain external consistency, sz
>> is converted to byte units when updating the state.
> Users could keep the consistency by multiplying the addr_unit, which they set
> themselves.

Thanks for the clarification! this patch has been dropped from the v2 series.

Thanks,
Quanmin Yan


