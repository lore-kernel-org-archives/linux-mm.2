Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FB11CCD193
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 09:21:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B5478E0011; Wed, 15 Oct 2025 05:21:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 865548E0002; Wed, 15 Oct 2025 05:21:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A1B78E0011; Wed, 15 Oct 2025 05:21:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6891D8E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:21:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EAC4613C1C8
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:21:51 +0000 (UTC)
X-FDA: 83999806422.16.BD2D447
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf10.hostedemail.com (Postfix) with ESMTP id 287A0C000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:21:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=fGI7Kelm;
	spf=pass (imf10.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760520110; a=rsa-sha256;
	cv=none;
	b=c+UE1BkbtK0/uag/rLVVi4eIBsF4iplBWj+L4kr8ujkIiLZMU7IJFa+Lp0okaKMwBnzV4R
	Mwjbyw0blcshzEVA3Dg4C2imaTOOy4RE6d6s+GAU9bPKYNQg+Hqn0Z2ifbiHzvr3icjlUE
	w+08QKIg+j2QY33XqamnKmz6+DxXz6U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=fGI7Kelm;
	spf=pass (imf10.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760520110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ut3ym92PKRZJOT8ifJTrsTPIBp/8Vpsh/XWCGrJvV4=;
	b=AfPeqOxI88qZOiJnQj5Ud6l1WzCmEiAiq/+Ucx1804En1G+ju+etazU2gt0GOg3ilqS3ch
	bidxVhU1SzuC9UGdyYa5qDqj4s9ls6S3xrWo6Kd7kxfrj3NttyvaMxGfIVcFMwYO7ssgik
	dvFx5ozU2lCfR/6gw+2nBGKCbyF+9kY=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=0ut3ym92PKRZJOT8ifJTrsTPIBp/8Vpsh/XWCGrJvV4=;
	b=fGI7KelmgVszOSH0ZvAA6L9NZdBlIBlvB81QVbp9BsJNFAq9bepQv7BrilwxSdv3ovzVXF0ib
	Sr4EGoMB+5NXD38+kQqcccGSkmkkTtIVzVe7V1GSW/wZzHqhZQdtfuaOAn6aDPClbScNzQxv2Wa
	2jtF3THDpG7XPT3KEVH0Ca0=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4cmltg6RpKzcZxv;
	Wed, 15 Oct 2025 17:20:43 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 431EC180B67;
	Wed, 15 Oct 2025 17:21:42 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 15 Oct 2025 17:21:41 +0800
Message-ID: <92490858-fa4c-49dd-bb3b-2820c794a8dd@huawei.com>
Date: Wed, 15 Oct 2025 17:21:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm: huge_memory: use folio_skip_prot_numa() for
 pmd folio
To: Dev Jain <dev.jain@arm.com>, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, <linux-mm@kvack.org>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
	<lance.yang@linux.dev>, <Liam.Howlett@oracle.com>, Sidhartha Kumar
	<sidhartha.kumar@oracle.com>
References: <20251014113349.2618158-1-wangkefeng.wang@huawei.com>
 <20251014113349.2618158-4-wangkefeng.wang@huawei.com>
 <1c020f8f-4722-45e4-af1f-ee3d4a67068b@arm.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <1c020f8f-4722-45e4-af1f-ee3d4a67068b@arm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Stat-Signature: 9s1wguboc9sbc7mjbfc95xhqksmfei4o
X-Rspamd-Queue-Id: 287A0C000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1760520108-111214
X-HE-Meta: U2FsdGVkX1+V/bLwuI3nsIYSxXubzhNR2/J+S/FjDRe0yvucMZCk6tr4GZFbf5sermaGOHjnpNUPFzH0oMImrDYllnWq+YjLkl6wY/cpgGQmDI+Q81/8xBzfeH0iayE5H8c2PnM/j0Fi1zCK01BMLk8+22579EBk8xZEMB17a7YAD2clifSp35gIDOZ43ofneAZY/F8U0pKYC2p43HFz2Xyv4vz2EmFXg6Q1OaOVCipvj1SARtvZxAsrvyM8i3DoOs/xecvwcb7DL94A2KSdkNsldErJleJE0xe5GfaBy+JFuJUC+0Z6vgeRAsCAhZW0iCD7ijd4YyeS+7WI7peyH7SFSawWztB+SDubgKM/iM6tQzio/DOPuWsCzYfie74zuEzrVqJB5OJijx2LfiOlUnchSIzsyNQce6fPSMBaZKFe/zeBjOEgMWhFwVfJfxwXxmHzePqmBCSiBgta9jWZ87JHC69e79cWihwH3f6XFcg+sTUdUM+sCqgGNOvyyygLT1XggEf0Z7j/jFG7G8RPfI+oTqHdFchUTDPT7lfcQ9FfKB5mZHipw7wQqEF2oXL3+4qUPQsnW/eXbFyxUgAF9YGRaKu7g94IJyMBd2dYmrZHtzcQe0jlQJYRJGxl5gQYMH0f8Mo6Ej193qdVQ8gjMePO46v/gd1XEA3VHlYtP6C6K+W+3XGRao/27uPB6SwL2aLriQUYyEdgt7Owj4FTLCusB2T5buso4LRe38cARkohD/05+RQITP2FDk6raoHBAay7SnbiV9LECRGz04CARlcnsBKO7ttL3lgcWOSK2S9oUKKgh1Mb6T1fAjbv+frhrf0CsvUlYMQfTQ9aJBBV1ylhtGBiU4OjNfdvUaTwN5wvetzUSWOWV43mFGhIvGK3VZESth9EFMrMD/TtYWrjnczsTOEyZg4REiM5QcHmT+DpOMhjJNXeU9QrGylLgcF2Vj67U4An2SkHOqmPuvD
 dF2APiW5
 TGyiSwFiY9YMuAq/Mh8dcnACPFfX/vwnUjSTcyPaWW3fWzD4j8riAfq0ukUUuVnVUe1f+8ruQ6OPBJwz5Drw13m0O5Hh/oFZn6HBL5yg4WdsBzIZ97ZSmb887zgm+UYOGL5ZDLCPpJV5Romw2W3xsy3gz69EGfIp9vYoV35jCf3H05xqr1lYXBX0EAF075Z3dlOa6i1dcMGk9ioEZnfWTu1i+aCAgS5MIOR111SGYxyX2zdoOx/xYLKLF6jZUyckOHIX7tY6CarkzqbAulYWBVYL/MaHBqtBAEURTztDIP60jWY4IkUG12TzjcWSLn8KwpyvG0m9+0pmNT1rN6VfbcaFQG/IIPCxohQnHKwsxIScPEkYNbesQiPNtUeBeoVNZT4quH8xvoCLwX++lqwX5SJfCs48LcDgDwp2b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/15 15:30, Dev Jain wrote:
> 
> On 14/10/25 5:03 pm, Kefeng Wang wrote:
>> Rename prot_numa_skip() to folio_skip_prot_numa(), and remove
>> ret by directly return value instead of goto style.
>>
>> The folio skip checks for prot numa should be suitable for pmd
>> folio too, which helps to avoid unnecessary pmd change and folio
>> migration attempts.
>>
>> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> 
> In the review of my mprotect pte batching series, reviewers had
> noted that the branch "if (folio_use_access_time(folio))" in
> folio_skip_prot_numa() did not belong there - it should be done
> outside of the function. But I see that that would duplicate a line
> now that this function has two users. So in light of that, would you
> mind changing the name of this function to 
> folio_skip_or_process_prot_numa()?
>

The name is a bit long, and it only update access_time not change the
pte, so maybe we leave it as is?


