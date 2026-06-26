Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4063CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 09:02:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB14A6B0099; Fri, 26 Jun 2026 05:02:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A88AC6B009D; Fri, 26 Jun 2026 05:02:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99DAD6B009E; Fri, 26 Jun 2026 05:02:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 774E36B0099
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 05:02:50 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0FB9C1C2C64
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:02:50 +0000 (UTC)
X-FDA: 84921473700.26.0B19E02
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf11.hostedemail.com (Postfix) with ESMTP id 18F6240015
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:02:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=xOsqfN68;
	spf=pass (imf11.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782464568;
	b=WvP4ecOdrBXZZ53UO/GGkybUAfhhOPdEhftaDpKXBFcnhmt0ruhcntNDH+plOwB2PASuO1
	B4Dj9iqZrTQjNKi0GvGSDqQcZY4YPFS65EZpi/uRicscFhxOx+O+0U73nIuPd7ULCy5s3x
	14VZmJXtaI+UctrVKBH2/2FsEe25PYU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782464568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0FmHvDLaa2RCl7vvyihcGV8T554t1KTf1jeCpH+Yfxw=;
	b=XPIY4MqkRkr0yHiUYXiCVV8VGYT8UBIAq1suCJOykXc9NozG0Gh1k35UBowkSqHBy8nbq3
	X2Eot0z1sTy5ws0bPZ0adbSXCKrjr6NzoT7eJJnAg77GPU8wfjRD/yAj3FG10n1hCG8FGQ
	eZSEZMthpbxgbFx3noPSj6bkzdhwvfA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=xOsqfN68;
	spf=pass (imf11.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=0FmHvDLaa2RCl7vvyihcGV8T554t1KTf1jeCpH+Yfxw=;
	b=xOsqfN68PenTtQ5tfYxVbyUkbtXrG4r+WiWVkMVN6P24VTF9p6GNP61DCw8inQiHcqjn8Tnvc
	Mr5pyO92rr8kuPhh9C1oX9Yq+HIYxynVRiFWW0L/ClBdXOLDuCxw4sOtjR5vwkXFVWGVTJFrhdW
	XWHhnkeY6vISQ7fy7IiysI0=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4gmqG76YmTzLlYp;
	Fri, 26 Jun 2026 16:53:35 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 7C27540573;
	Fri, 26 Jun 2026 17:02:42 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 26 Jun
 2026 17:02:41 +0800
Message-ID: <6dfe38f0-0df3-429d-ba26-66bb3f94965c@huawei.com>
Date: Fri, 26 Jun 2026 17:02:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] fs/proc: fix KPF_KSM reported for all anonymous pages
To: "David Hildenbrand (Arm)" <david@kernel.org>, <akpm@linux-foundation.org>,
	<ziy@nvidia.com>, <luizcap@redhat.com>, <willy@infradead.org>,
	<linmiaohe@huawei.com>, <svetly.todorov@memverge.com>, <xu.xin16@zte.com.cn>,
	<chengming.zhou@linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
References: <20260626013252.2846774-1-tujinjiang@huawei.com>
 <a63b7138-617f-46de-96f9-e56528aee3aa@kernel.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <a63b7138-617f-46de-96f9-e56528aee3aa@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 18F6240015
X-Stat-Signature: qc8kuikaxr4atp9zhky6xfemgyh9ufxs
X-HE-Tag: 1782464566-592623
X-HE-Meta: U2FsdGVkX196DM16WYYA9+qyx1gnpKPvtY2S19eMxZD+Lw/or/RJAEVs0wfUBjomJdsEa3BZ2vQ6cK1BO8mshfrsHnGFJQKrt2lTSONAsymuzmqlVPWhkQvhrqBqy5SAy2YzweKy5CveABuA5pSsb6aQaPz4tXj9ZxEOGPeilG8Iyy7RAEnolRQRBUymBj7DbMYKTdzRHnEBK0AmfMPWsuFpuYgFsJFo8CJVsz843OEiR62KmfDwMCj61hUIoT5XrtVhisR+OXAb1JYKu2A2Wyw0VLn+XtNzjeEIYsdX1ybSVJMS4rChJ62BMN1ImNQog6z4nsoBDOr8Gk97wwITG7PqDhYCBWJXmmhsHsKNXYxmfi2cglkgSs442SKVt6z5NGAHZwjY54uw3JVfwfm3zdtw6xbZFyqhTRS4nj4l3gFozMjwxFftwINslipPbXaQyJQbqY03FJzZI9XZK1VeEMr/0bT7mhSWPc9BXlPvxoyNwJ87qW07MWh7DGsPLS8Tpu633ncI8GmSklM7a0fMZwLOXt8X7qRspSpyDVZQHcUjr8qiLV+CpPQRKRQADgSLA5JHXSa9Vtu4xp3ux7km+eKXxovJ93eOa4O16jO4ceJUBcU+x3DtpVmLfs/c265lacwEGdOZTUNZz0zBKANvMKWtYeX8aZ4tRp1xKDI2pfyt3SqHwZ9vpUimkCmAEneEm+wuGulE8RC4k4IKoB2snEbWu9yyBilfm1TI3wcHdgPtNY8Bmck8YLoJlHjIdwM2MFQmpXuuY4wx9pc6xm1CNCqkXktilChcHdHwD+/9/Ygk+HJdpQf4Dy3KSWK5CKGPTJIPKAWI3Q3g6hHh1bz3lm52gatpaH9lhnQZOyYotoPezKZrUY9yuZwpaN/YXlez19aOrG6w9I+Vf9WVcK91Tm+Ro6dvdbr1OnJF5GCmJfYQLnh1d/IJkgIpxEY70woTQaaNn62FFKDR4BcZNx9
 hhN/ctQP
 /oUSm1RXF01I+2s8Lt4bKPV8lGy5lFFcAp92jq65lG6ysCBzCBebuE92wQjHPX6rQrxd46IPglL5qooFbxdVyPICUIVKU8i35v60Ch583v2VGkLnx40TSPLZrlKJlSv5qQkdY+kIMJNN5kXOnZ8GcJcpr94dK9yacIcMx5YyPYG/PBT8bEMWBq92Oaeuu+KGrZF0KHZZzudNSzuSZb6damm571oYJq++pXDIubagPkgsmhbWVO7BN0Es76Oo88FshV7OxAUoQxNWfkK+R7Q5EGJ1jBkwfKobeVDTub83mnBv/oVREQgB5bblFVLXesKO8osqvPtVpS/0+QiPPZA3vpJMyB5yrolgns6Lrkxda7GwfK78GKMuZfxrF+3vjMepjzzLyXTIftLHx/dPoC57y9dDq5LTRkal906gYL3Fi5Gmqd+XZDClvP0ClaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/6/26 16:13, David Hildenbrand (Arm) 写道:
> On 6/26/26 03:32, Jinjiang Tu wrote:
>> Reading /proc/kpageflags for any anonymous page returns KPF_KSM set, even
>> when KSM is not in use. As a result, tools misclassify all anonymous pages
>> as KSM merged.
>>
>> In stable_page_flags(), if the page is anonymous, then use (mapping &
>> FOLIO_MAPPING_KSM) check to identify if the anonymous page is KSM page.
>> However, FOLIO_MAPPING_KSM is FOLIO_MAPPING_ANON | FOLIO_MAPPING_ANON_KSM,
>> (mapping & FOLIO_MAPPING_KSM) check returns true for all nonymous pages.
>>
>> To fix it, use FOLIO_MAPPING_ANON_KSM instead.
>>
>> Fixes: dee3d0bef2b0 ("proc: rewrite stable_page_flags()")
>> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
>> ---
> With spelling fix
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks.

> And I'd appreciate if someone could look into cleaning up the code to switch
> back to folio helpers now that we have folio+page snapshots.

I would like to do it.

>

