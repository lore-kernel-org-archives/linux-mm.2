Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88F94606A32E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 03:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=BZb2wHrh
Received: by kanga.kvack.org (Postfix)
	id 87F156B05CE; Mon, 23 Nov 2026 22:11:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82E0C6B05CF; Mon, 23 Nov 2026 22:11:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71D0B6B05D0; Mon, 23 Nov 2026 22:11:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4CFA16B05CE
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 22:11:58 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E1A57120A09
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:11:56 +0000 (UTC)
X-FDA: 85468538232.19.DAF1422
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf25.hostedemail.com (Postfix) with ESMTP id F392EA0003
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:11:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=BZb2wHrh;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf25.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795489915;
	b=6l9DHqg7ZiYnliR4U+tcZCYkbV016u2BleeIFDq+Pfb3Gg1KY/MUBugEOCk6SgnW7hfx2e
	6DnWh/pWw+/S4cQT2kXV07ZpsvSU7KhRk/9kvHfQXm4HBLLrENzp7pnG+OYc84DaYEI6Sy
	KUmh7U0GmN4X9EaXeVvvGGv8A4fvKLo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795489915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ZgqWwZi6y0m3JBXH+oDDQOBp9DTmzu1OxZuchkyzNM=;
	b=qkqSFrWrewUZrebLTPXVHq/qCv0uolOtRIje2+0Cy6dfAsMZRPpOXQwPLThRJpdsn42fkY
	ynWIfiw7KiGlyZVUMC8PZwwLLUye+hytuF9CLi0C0bQtBGAqU3oyyli/dgI409qwF1uO1N
	CchIMWfSOUnOyRL4njvQiOVNBZwHhaI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=BZb2wHrh;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf25.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=2ZgqWwZi6y0m3JBXH+oDDQOBp9DTmzu1OxZuchkyzNM=;
	b=BZb2wHrhZ0+3hf+fCa70sfJb0yGBURbMoRCH9BAzZwSvu6Jkz89gfEzqn+ONfG9DyTftTGsaC
	w5F5leIcO66mWV/ey6ndbY/CF00BN5PQ/ZTZ2t0cTu39FgFPu6iELMKazyte2OcmP2L/yVzd522
	a0ZKQK4P1aJrmvwswqBi9mM=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4jYSWf3Z2Vz1K9Bh;
	Tue, 24 Nov 2026 11:11:26 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id AA66A40565;
	Tue, 24 Nov 2026 11:11:43 +0800 (CST)
Received: from [10.173.98.163] (10.173.98.163) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 24 Nov 2026 11:11:42 +0800
Subject: Re: [PATCH v3] mm/memory-failure: set PG_hwpoison of a non-hugetlb
 page under hugetlb_lock
To: Mani Tofigh <mt4022@columbia.edu>
CC: David Hildenbrand <david@kernel.org>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Kiryl Shutsemau <kas@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Mike Kravetz <mike.kravetz@oracle.com>, Matthew Wilcox
	<willy@infradead.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<tz2294@columbia.edu>, <stable@vger.kernel.org>, Muchun Song
	<muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Andrew Morton
	<akpm@linux-foundation.org>
References: <20261106-hwpoison-hugetlb-ro-v3-1-c11186963647@columbia.edu>
 <42a60f57-5323-f981-8ef3-2e5d67623902@huawei.com>
 <a87cbd92-0e07-4f84-9a6f-8db0b1778fcf@columbia.edu>
 <b0f30561-aabf-2bf5-2204-20907c40ef43@huawei.com>
 <08b18b88-3ab4-4681-bec8-f4564fe9f1dc@columbia.edu>
 <77680005-7178-cb1d-6e20-e23519839222@huawei.com>
 <56de516a-c895-44a0-94f5-ea7bc5bd3ef9@columbia.edu>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <53d2f7e6-581a-ec05-6dc5-59a892ace835@huawei.com>
Date: Tue, 24 Nov 2026 11:11:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <56de516a-c895-44a0-94f5-ea7bc5bd3ef9@columbia.edu>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 whupemk100004.china.huawei.com (7.152.185.74)
X-Stat-Signature: 7wi4zr4dk9u1yphtrmwkzzfx3axgwuo1
X-Rspam-User:
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: F392EA0003
X-Rspamd-Server: rspam03
X-HE-Tag: 1795489911-430695
X-HE-Meta: U2FsdGVkX1/SfBh9hbA333WzY8OOUupsnsGZEsIgIJl22aoE9s2zctWiZiXS9TC6aiItwD+F8lae5fjwmGy471b5b4zDCsjo3lkXMWHBroNcHTzfERuyizQz2kj+AswKWIq0Wj/wV8R6m2DrYCWMB7STtLwtXrN4yQABIeoHWJ2TcQr8pHiX0ZBv3UcxhmxbCdt1YRgMIGiqohzlTCmsYQXwRfvOQHGMB46ybbZVlHB23fK3WlyAvzEUUo4y8p5bDZdxUSFIoYRIIULZ6/cJkTnlJ85fMOE4aQisKvGXfrZ0F8V8ut/FiW3CTPXjVCEDfjWb3S2LI4UTXCWGawUWvK8tZzxOeC8p0tbizLAk1veHuUB2bID9isnZDqboHKbDdn8ef1ffg6qmb3Y93oD9pluofOuY1Da00STlTOBCsGqViI3tedCXzzj6o2F5QVwNb6Td/OY4hEzy0QWDfuQt1QNg4ojUf4MDznVeNbzaEBXIx85M7gRzWEeLa6HAGCdj2Kvb7B1adaGYOQd1gmsmFM3IIgqekV45raDO67AhV2f59iX1rD65I2hhfbMynzzLPPnnFOWp3xPTY1sbnqsLmvkh7mEmm1DWnB9frpf51shj3gQtyi6CryTh5Kasukslsa4ZAzouUuQcwcpPW62WOm3EDZcfEcc14iMs6+JZdAVUYEEvVGqms/zkOPagEX/702FuA7GoNg7ogr1dQS2TVg9EJazWMhUD6817DWvNVEaNNmC/7bQRJD19WF3jOnyDQ0qz3R4m26OEPHycs0P2Ondf+igo2u8Df5WAClAZNmOdeOBsfISSTwGHscBbqp8molb5YUO2kHfHNMe7YNIOPLPyDtaVFpg76M2Sl00+GP5Wa0WYzx5xHy915SymeedpZdtQQ+FiazODxNSn0RF3HN3aUIWBEdjh4V6DydkOSBgZIqLDJCnwntUbwmhcUVXGEfEn3hACEW5eSAcHApz
 0qg7cESI
 AO+cLYDOtRhYaDUc0GEcz+4tgz6+u6UtvPQMDQRB4vVI+HxbH1HMse10E73BbGKsvjyDt3TD2Bz6HbsyVSWgy6LJfilj2ONpQSgwreUBix7AvVO2qBYsYB3fMS4fH+e2IqHOjeRrh9ub5o6lc5ISMKGjR1NLf5RW8RFDbLJzQ51SWD3NtRvnShKNepgWUx60NAKPjxHp26Jdhdxx87ITQIfdro9A2BMyaKJMXTSjx8OpwRPZRRg0k+6R3wX7ZEDwkKJERH1FcJ+Sp23a06wGRRPRg0aEGzpa5H/XRa4ju6z/RM7kOWCnsjYw2V2A+5rOwxXHUOjXAurACVqZs3sTbVEYI8NQCntEGnU9gv8Ja0WQodfeGxa8cmCbl1uRXoA6MmfQhf5YPH1O8MD+oopl8YsD8qx7TDth5XNR8zLwT6iYXMfS8G+REH2D80jex3qO4EMiJXtvaz4k2LLknh6VAZXY27/0iOCUi3piJIe30X7JhLVZmMVJwQ/Shndpvh+Gi1Ae800FeJYRIKfiqM1KW+QKbZxCHvn3sfzJXPVaEFjwMGG85NbidtYgkVen7XaecyQGNnOuA/+NJle5SD/i6TKri02TnHF4/bG9x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026/11/24 2:52, Mani Tofigh wrote:
> On 11/23/26 2:26 AM, Miaohe Lin wrote:
>> If P's struct page is past the first vmemmap page, the hwpoison flag is lost. In this case,
>> do we need to do something? Now that hwpoison flag is already lost, I don't think so. And
>> TestClearPageHWPoison won't do anything in this case. Or do you mean TestClearPageHWPoison
>> will always write even if hwpoison flag is not set? If so, can test + clear do the work?
> 
> 
> Yup, that's what I meant. And good call, test + clear works too.
> 
>> I think we can correctly clear the stale flag from the first round.
> 
> 
> Yes actually, so just this under Muchun's rwsem:
> if (PageHWPoison(p))
>   ClearPageHWPoison(p);
> 
> should be enough? I can do this for v5; sounds good?

Yes, sounds good to me. And some comments might be helpful. But do we really need that rwsem?
Could we avoid using that specified rwsem?

Thanks.
.

