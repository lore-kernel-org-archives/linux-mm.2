Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23A2DC87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 11:06:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A146D6B00B7; Thu,  7 Aug 2025 07:06:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99CEC6B00BB; Thu,  7 Aug 2025 07:06:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88D636B00BC; Thu,  7 Aug 2025 07:06:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 731326B00B7
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 07:06:45 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 25AFB5C8BA
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 11:06:45 +0000 (UTC)
X-FDA: 83749683570.25.58C413D
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3C7311A000E
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 11:06:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754564803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3ZU3vmfThu556jKZjCZjroOITyD9dOVOE9K0Dd9X7ho=;
	b=ii8YXYXl6+a/QtckKTe0g+ZEksF9I5+xs24jsPgEE751nhsi1CC0J+sz9Uh6dbtydRzsf3
	mYIl0uH3ndK0ZckrbAV8nMgs6Gpxj1OMmk42D/e/anpx9EwSPjvrQ0cRdtbioeZAiciu0H
	SsWdi8zhEOwtSEDI5fFijffs9eYXaUk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754564803; a=rsa-sha256;
	cv=none;
	b=1z5TZT7yf4HN+t7wJIbzfwoUlnxBCta8EzSwM1OBWYf4tVR2fP47E0z4AdXcP154KA+3qs
	iGGZUtiUVZMAjE0PbbJnwPj6DpEnbRpRGqt+qJlxUDnYNoNCr1vSI34UXV8uZ0VTZD5Q36
	Tivg0dtJnqYJB1J1KYjrx7C4J1yB9j8=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4byPWw6DG8z2YPj9;
	Thu,  7 Aug 2025 19:07:40 +0800 (CST)
Received: from kwepemo200002.china.huawei.com (unknown [7.202.195.209])
	by mail.maildlp.com (Postfix) with ESMTPS id D90231A0188;
	Thu,  7 Aug 2025 19:06:37 +0800 (CST)
Received: from [10.174.178.49] (10.174.178.49) by
 kwepemo200002.china.huawei.com (7.202.195.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 7 Aug 2025 19:06:37 +0800
Message-ID: <14abf20d-d3d0-46fe-8184-6dbc97a4e5ab@huawei.com>
Date: Thu, 7 Aug 2025 19:06:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory-failure: fix infinite UCE for VM_PFNMAP pfn
To: David Hildenbrand <david@redhat.com>, <linmiaohe@huawei.com>,
	<nao.horiguchi@gmail.com>, <akpm@linux-foundation.org>,
	<xueshuai@linux.alibaba.com>, <ziy@nvidia.com>, <osalvador@suse.de>,
	<linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>
References: <20250806020520.631203-1-tujinjiang@huawei.com>
 <1a4df59e-e734-4ff5-b1b0-0a754afb6f67@redhat.com>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <1a4df59e-e734-4ff5-b1b0-0a754afb6f67@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.49]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemo200002.china.huawei.com (7.202.195.209)
X-Stat-Signature: bozxrd6cstbgdxa7w7zx9gsrjyy9wdm9
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3C7311A000E
X-Rspam-User: 
X-HE-Tag: 1754564801-875087
X-HE-Meta: U2FsdGVkX1/4CJvDPLj/JfOwEBbPZCiwL+WsFUlyG8lIwxGIs0rHKvPShZeuN8i37Gvo+wHqSgPwpim5xs6q4ObGhdmi9Xy3omeRVaB/bSlQI55oQ2KMo20lsLIZRfuJ9GU8c6hT1rq5mqqPsS+uXqusTuajAQZ7+i/6A8jGq+lV0WlubxE0di5LmJxoin3Op7zSuekRsar2JAXAKFcrsL2d/elY/+oC/j4A8BgkFFutVOK3ejvM1e6HfC6fGN+QhQZOyNyeuG5o57jprBYiShzo6EBRwhFxM8YM1xARbEoZM0aUDJ85sAL2r7bVYk7nrK0mDKW5tjNhy2ncvZ3oJGptdV4oi7zFF7xlO6XGDQt9H3kO22S1xhB+dmOrQBD5YwKIcQfS9QHltBQyiB59WezWSnro1dmRftOMsrT3cSfSmoWL6t69habF/XPXkG2w64jKUQw8SYJru6JZByjyOcHg0sa8xv+5Yy4Fy67dB5YNNLY7+eA786Feh7rvindOaXW6wbYbsQeK+W7VwDjEgYpgFt/CyqoEE/ibYb1sUbwQ8BqoprbA4yONF+9Qa9UTzYl2yfODr9SjLaBnHIQcqTS3I8sFq8eTLYnCvsBVCEGK1Kx8pQqCpKJiX4MPwPvd58rxQ9C7x431bhh/3XT8kzQe9v180rwsrGxImdK+LLYXr1h8x3K249An8jF64z8sTXKc2xpGn4GlrvUpyzlRD9AoQ5CX/LUHBhpmKVq6ThHtkeVY1gN5i7O9stpOSxmWbVfjmdEJ9pmsxb60F9dxKk/ldleKbTqNRVERAtFhMcWP23UImiSewg25TLyS2xmWCpI0b3joJtqbNKPgpiKdAUA3sK4N02P/QpmF3445EbNjSbIdRXXnt+tuzRcsZIDsXgA0WbhKbQTMTaPvZ2pTjuL77yUrSxYc4Km0epjHC88EmA+WVEVmoapLhpduXKyU70WzX+NiZuJ7Nba88gF
 UauAVcMG
 CRfEbqOkfW/6VaGA+4S7/XrUN8sihSwksSN5/+XnlgClzM9ipa+Nz2vUEriAE8R0RQyIEmxMIIZbLTO7VK1HMsDf7km4VC381KGTDfi4kRO6XbWu7mn51DXbwdMv0NwQqxc+KhsITkkq500EkZN5DP8w8+qOfU5GTXZSi0dW5sjOGjWkUFKdSVweuF8FckuWgmUAYQ9acadlG0jD3Ubvu87lcvyH2pkfh4zVm+doJjdqei4UP6LYWpa1gmBkJPOZ3N0bzPR4pUgUpw4P4XxmLBXr2wEkA+UXho8WE5zuHrjGMcx197AaFw6fyFRRkWmfQaZAIGJUiYPel9PGuq0XDKfBbrG2CwyLU5ifk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/8/6 20:39, David Hildenbrand 写道:
> On 06.08.25 04:05, Jinjiang Tu wrote:
>> When memory_failure() is called for a already hwpoisoned pfn,
>> kill_accessing_process() will be called to kill current task. 
>> However, if
>> the vma of the accessing vaddr is VM_PFNMAP, walk_page_range() will skip
>> the vma in walk_page_test() and return 0.
>
> That check is dubious and it's on my todo list to revisit that, 
> because it doesn't make sense for COW VM_PFNMAP mappings.
>
> But I am curious, is this about having an anon page in a COW 
> VM_PFNMAP, or on "what kidn of page" do you get the fault?
The pfn is RAM pfn, which is mapped with remap_pfn_range(). There is no 
COW.

