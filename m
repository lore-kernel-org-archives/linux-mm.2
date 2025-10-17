Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6AF6CCD183
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 01:33:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF05E8E000A; Thu, 16 Oct 2025 21:33:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC86D8E0002; Thu, 16 Oct 2025 21:33:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E04F58E000A; Thu, 16 Oct 2025 21:33:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D14A18E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 21:33:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 45A9B47602
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 01:33:23 +0000 (UTC)
X-FDA: 84005883486.09.9567019
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf02.hostedemail.com (Postfix) with ESMTP id 984D680007
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 01:33:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=OQUDtwAv;
	spf=pass (imf02.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760664801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cOZXmjsZS9OxXu4N7oRurav92/uEjQsnoWP0P8FrzTI=;
	b=sI4CXic8ONwhg+s6ngO9Kn3WzXGCg1NPqvbiOPe0ITj4EwdD7sh0JcHH/2qCkzILCk5P7d
	1kA4IUu6TKnkWjCPtqpT6ILITS0hVo2SaxYUorMYMk8mi67Ryr/6SmL1e5LMdCgpMymCUd
	OisWZ5tbOug+qZzZGTIUydOdIQXetuA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=OQUDtwAv;
	spf=pass (imf02.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760664801; a=rsa-sha256;
	cv=none;
	b=GpZ1GLJsiBmcpNVDN6KxBk0cbLrDruzNzPFuFvOgyZdzgZp+EpWCTxfKCPrN5FAC6tWNFj
	3J5pxWly5jMJ5kZ91n/NaWhTHIvqnqwO5gQmw5TVuiNPgYz4yC/Dc5kOxW8rBGJBjrmZAn
	Xhs38/rp226iMIyOHo+xIVPp3CleGE8=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=cOZXmjsZS9OxXu4N7oRurav92/uEjQsnoWP0P8FrzTI=;
	b=OQUDtwAvSlzH3jJXM1px/U5utZvNgBVRCiVCLJOruIdAqY0bls74bIGexMC6gFOEXG4gowKA3
	lXpfsmNahdfpUzJgXH7ala4qw1jpAXKTWMZ0T8oE7D7H6CnrQt/PNnsOqlQ1tQ8vD5pbikwEATH
	1pZReGqKjZuM2OWPzy4BNx8=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cnnPy3vxYzKm6X;
	Fri, 17 Oct 2025 09:32:54 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id BC40B1A016C;
	Fri, 17 Oct 2025 09:33:15 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 17 Oct 2025 09:33:14 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <akpm@linux-foundation.org>
CC: <Liam.Howlett@oracle.com>, <xieyuanbin1@huawei.com>, <david@redhat.com>,
	<liaohua4@huawei.com>, <lilinjie8@huawei.com>, <linmiaohe@huawei.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<lorenzo.stoakes@oracle.com>, <mhocko@suse.com>, <nao.horiguchi@gmail.com>,
	<rppt@kernel.org>, <surenb@google.com>, <vbabka@suse.cz>, <will@kernel.org>
Subject: Re: [PATCH RESEND] mm/memory-failure: not select MEMORY_ISOLATION
Date: Fri, 17 Oct 2025 09:32:57 +0800
Message-ID: <20251017013257.1181-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251016140218.15579-1-xieyuanbin1@huawei.com>
References: <20251016140218.15579-1-xieyuanbin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 984D680007
X-Stat-Signature: bz5azejc3f48n35e8n9a99ne6ype7ow3
X-Rspam-User: 
X-HE-Tag: 1760664800-574510
X-HE-Meta: U2FsdGVkX18CqC3ShTp/UuALI57aAHpLfeuVRqPMfIhEiZOUKtErlkl2vcEVYo4tkFNWa8mYJaHZ1O1wa/lY3ShwSCqGHrKeXwBv/SkW4NDgtgTQY0m29Bs4FFx6HDBQvJQlYvRctv5Va6H4/B9zOlLlf21YSZgBIm2OJuTFsmCZXNyiqtXaex0glfH6WdzhonhYS4j4p+bQr5+2iJnqVSZKeQS/bwZMMNMtJz2P8IsC417RSxq2EJBKkazws5v7Q2Oz11FeShkQYBDYYcSmN5gL1GQ6dYswlngZFbv6CrE9Snt/WNYUzG8BhtPfgWXZEHq7Vuev9VbWffLBiiNdsfd7VQVzH8h2SdkCbPGoVJ5a2aekOAjP6MBCn3RMNXx2cqEg7gE61NT2CrxbcYFCUMG8ZG7b1W5I5enGaOTOW+fk1MXttayU/CqIiaOLsH09u2BL7hJI8anPcenk4e+nfTASiMt2swNSdVfweNKxPv0cOwSvuHJfiChfd6cHu6JI4WM+bulhXpHPKsHLJx3b3LNyh2Qyxgu9hY/7EZpDgLdfVRKlR/esbuYhEtU1L/6h0XaKBfVN8dw5OVOVHUjPUgn5xkejcvo+B+rrjf4f1Lsv93LxCNCYp1y20D2YcNjw0A0um9e4ey6zDVolq8G0qD1l3IHrKtJdV4BWsxlUrVkDDZQ+KUg3EaFdKl69UEC+smqPygDeISMcR3M0tib6ivFTSdr1kD34s8qxXV7n0GmYJIwOVqhljyOcStz/CQBwFBYs1xZVnt3rGKWkjol7YV6YvJutjaORFyjkqQOFhvXOTHHu0cVs0gCnZ91UUiM9CfCEfdAf4L9Ws8XMYLkpFTiZcZ6rMyz+wmVZS/aYiSTCq2D6Xq8ksq3kvpYvTeBXfUbUdYX6nS4NIHvUtTJmh+w7cGzHe51ykLEpHqF8PN/Z+RQUDEXOJsvWr4LLSmN8lpVugHo29rJnS5858dm
 F8aZVNYv
 SIye+ZY38vBjY1LkhcoNy4CWtpHx9QSdhXltFvOoGNGqjb5vXnyavO7/26hE+AhmhG2ZD2ZSln4kuMo/eh/nEgks1rI0pdr70gLEuwF3BnnuPpNDMvFH1PPzQd37O05ohBHMGn0QbTuzRsN2Wt9kf93UZlFdIGTWkzp1JEi9T77nEe1blHiwSx2SZ0NjO7AHiE4SHphsEoZXgtTBplOgsRU2YkPaiRvIFFf444RtrvLmf0wU3a08Sjp3SGK3tiMG2Mysnt3Reag6uaK/hZZVi2JO/YUanKpUBCjEMQSrmcq7+DpD/YTd/VTV8yjZxwYTjz2D1zqZUlvDIL90eIA0QwLIbsXRx/jyLmZY1p6kz5NuhhfHWHQKQVROYAW0Xh5+0Wjd/21KufzCl2vD0W51bQoU0eFD9J9hJ5Mrido3Medhz+VDiDketKJMo/RKgjSBESD6V
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 17 Oct, Andrew Morton <akpm@linux-foundation.org> wrote:

>> We added that "select MEMORY_ISOLATION" in commit ee6f509c3274 ("mm:
>> factor out memory isolate functions").
>> However, in commit add05cecef80 ("mm: soft-offline: don't free target
>> page in successful page migration") we remove the need for it, where
>> we removed the calls to set_migratetype_isolate() etc.
>>
>> What CONFIG_MEMORY_FAILURE soft-offline support wants is
>> migrate_pages() support. But that comes with CONFIG_MIGRATION.
>> And isolate_folio_to_list() has nothing to do with CONFIG_MEMORY_ISOLATION.
>>
>> Therefore, we can remove "select MEMORY_ISOLATION" of MEMORY_FAILURE.
>
> We already merged this?

Oh, I didn't know this had already happened.
I'm sorry about that, forget it.

Xie Yuanbin

