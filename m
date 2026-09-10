Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57FB4C79FB6
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 02:58:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56F016B008A; Wed,  9 Sep 2026 22:58:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51FF96B008C; Wed,  9 Sep 2026 22:58:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E9176B0092; Wed,  9 Sep 2026 22:58:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 228026B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 22:58:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 042DF1603DB
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:58:12 +0000 (UTC)
X-FDA: 85196343666.23.C5A1804
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1EC0B1C0006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:58:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Gc+tE2ww;
	spf=pass (imf18.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789009091;
	b=AAmyudxCEz3+A5i5FsURPBPh3rHm4Zil0yxqxQmhPZ2EVycfgaaBxu5rqp9pu6k0mBRxYY
	liOtnewlbXBce3pDSShwWKstKnROjzKxtM2n29aVEpsxJrq8rclDftqJnok0M6Q2FDqCzc
	iLYuX+54lM/RoF93Nr5rnxK2/ngzD2g=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Gc+tE2ww;
	spf=pass (imf18.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789009091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hVpVdp35yd0WL5lFaPpLBZXCA6v6qcrTGwvBbOPs54o=;
	b=XiO0yHEiuzD2Uro5xrL7p3Ua/efGfSL6HnUrZP3ZO6/3p+V+6AyFE1djsyiG7u7dFsZyKS
	zUWpXffJSV2NmvPSf7l/U4pY5/WLua4Yi4uhG5HtaimlOEhLSWbEaxYER+JYYFRdfsOaa5
	14jiX/PY6DebOhvnZ/sCsZ7bSIJJbWQ=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=hVpVdp35yd0WL5lFaPpLBZXCA6v6qcrTGwvBbOPs54o=;
	b=Gc+tE2wwGqBmQOpSFmtWVRB+yndJFeuODTubPqpb2kgMFcFylChVDodZ3egWZhrkOnFuUoErh
	frwWaZqtozpO4Ub3DX++BHfGauQjEjZhVEd2LkpV2tjqeChjSWO64QZS/BklFYvpZuGNk9B75X7
	MTLvDlzJO29qSm4W5mkZLh8=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hgMWq67Gwz12LHf;
	Thu, 10 Sep 2026 10:46:47 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id A874640561;
	Thu, 10 Sep 2026 10:57:59 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 10:57:58 +0800
Message-ID: <c84c5864-43ef-414f-acd2-99db78ee9358@huawei.com>
Date: Thu, 10 Sep 2026 10:57:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/rmap: fix missing barrier between anon_vma init and
 vma->anon_vma publish
To: Jann Horn <jannh@google.com>
CC: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
	<lance.yang@linux.dev>, <riel@surriel.com>, <liam@infradead.org>,
	<vbabka@kernel.org>, <harry@kernel.org>, <minchan.kim@gmail.com>,
	<lwoodman@redhat.com>, <kamezawa.hiroyu@jp.fujitsu.com>,
	<linux-mm@kvack.org>, <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
References: <20260908122924.554373-1-tujinjiang@huawei.com>
 <CAG48ez29qhPAiEz2SHy2JDiOJcF2Xv8Y2prZNGxw4Q+08DyCXQ@mail.gmail.com>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <CAG48ez29qhPAiEz2SHy2JDiOJcF2Xv8Y2prZNGxw4Q+08DyCXQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1EC0B1C0006
X-Stat-Signature: 6bdbhdxgi85kiu3pxb849b3o5rrnoiww
X-Rspam-User: 
X-HE-Tag: 1789009089-446016
X-HE-Meta: U2FsdGVkX1/cCP3jpd3CuIeHIZO5polr7xgWVKVQsAGP4XZC4btp/cfDkhaxZ6CZl2Dk9xpJUJx8b9D/EAf89lZAPhimE+KAq2aKnwPvBRjoyxJngEi2o28Usw30OEvpzmlSVOqehHuC8hoOCSC9b7oS6wKKWrn+u57MQJvafygO/p2SI6iBc/hrN5WL3WplaZapxDI2FNiHIUhqtJsvm/dEzBKjxIFcKqm5cVxKrve2B0akei0IEo6oFpFW2VqrkdlFUQL1Zm7SjbB9NNHdJVen8jild3oTV4ynXWchb4jA7aHeLPxpEPQCrHJz9Vj5Dvdz7UrswKQi76kgGvIG6KnfQr8Go1hEqpg3JoxJnM6xzKVfi4z4oVW9qDLzPkWB0Smnd+hV327zMB9jDsbv2mSvkYB8mrSF1ir3wjxItJSgvQFl3YpCU2aB1BYp7gzO0lJe2vBj2v3pRA9yexSf1bNu4qnxaW8z+zcKIhjkCB+Z9RpsO5N7I8jm07FXMSOF9nhQ+sgy72zl5OLNo3lKGuOmXimIy/EbaqaKiq9uycEyNSmFh+FoWdvTf5rDs2twuz0AzOBNy8OOAxwR+1BVMV+QPzF7uDT5+N4OFYaWW1Nv0VMNHJUgrjSbgvRW2weIw049ZM8EH+UR7oEN4W9FxYUMyLUdiXLGFCcvJ4X7rkrg62+Z7w2F27tjYwjsKofUBCEreZlYXPW0mNOlYZFRAXaTAvhDZUAkTlWkLL1ZPbaAthXoei8SC85+FVgENaHkF6HjRn6JFjM0u8rMHLmZ7Re6M15r9m9oU0Vbxg58wJ597syBFu2ED3Z3Oui/zsYzKHJ+mcRhkXvPGuW8NbGtoCrJS6UBqgpjatH9VNpX+NuEUtNTGKeIHZPxUC1WkLp8JCMqmw7qvnpOg70ifW9vIBVEzCA0q0LYjR7d++fNz70Nx53VSv/RiG16vnKLnT/S3rNvUIK/knESNfonT32
 Is4V+ZsC
 D2DL5p1nrb924oKC9GcotnMMqvvl2dogtU1IahFsDTfbfJf1zJh8joSmh7BxuVzm0c+BDEYbHLIcclUM6ZtJ1CHA+LA51VCgV27HRdXMN+yxlZHT4yYM6Y+QEBg8s34lGgs9L2VqfuoJQ3lUhuqmoGukdX8QylkRxKtBr93ROTiZ07gmXNCopUyD/Tig+VfHbM6LSsY9Elq9JiOG1FzdMuMF9cPmcZGrJ8smKQ7dy+M6y/s64qnMvVzFtBmju+YqLQxxlW5sDgmXV8ULr+eTuzr64WyBT/2Ld+csnLtAiNKzi6Uvv9sk8IHSGPBX5URwkhrwWobm8EpDPNM4RpTYF0hQkQ4TsADTW0EXIIckoERZUtdpm0wjAwSCARd4ikzdMseSrvr2aWe2QpyFLeedh7UnqiTppqTuRzl+mV9PbMGVY1Ea0fxGRjDsajmV7NYToJEdCq9QrRq96OxAFTEc1No2LnQ7uJNA2Pm0Uti7N6wVYhSgQGjojU6A+8bUeBvnzlFTALA6dODHJuil5nbShyk0OAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/9/9 23:25, Jann Horn 写道:
> On Tue, Sep 8, 2026 at 2:57 PM Jinjiang Tu <tujinjiang@huawei.com> wrote:
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index d1819fd69938..f3b21aaa34ee 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -209,7 +209,11 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
>>          /* page_table_lock to protect against threads */
>>          spin_lock(&mm->page_table_lock);
>>          if (likely(!vma->anon_vma)) {
>> -               vma->anon_vma = anon_vma;
>> +               /*
>> +                * Make anon_vma fields visible before anon_vma is published.
>> +                * Paired with an address dependency in reusable_anon_vma().
>> +                */
>> +               smp_store_release(&vma->anon_vma, anon_vma);
> Yes, this should go in. There are remaining theoretical issues (we
> really should also be using READ_ONCE() in places like unuse_mm(), see
> <https://lore.kernel.org/all/20230726214103.3261108-4-jannh@google.com/>),
> but this is the important fix.

Theoretically yes, but I'm curious whether these are actual problems in practice.

In hugepage_vma_revalidate() and unuse_mm(), the code only checks whether anon_vma
is non-NULL — it doesn't dereference anon_vma to access its fields.

In KSM, rmap_item->anon_vma is assigned from vma->anon_vma, and the rmap_item is
then inserted into a stable node. There is a very long time window before
rmap_walk_ksm() could ever observe it.

>

