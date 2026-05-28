Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D33F1CD5BC9
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 03:31:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 031F96B0005; Wed, 27 May 2026 23:31:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F25596B0088; Wed, 27 May 2026 23:31:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3A506B008A; Wed, 27 May 2026 23:31:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D48336B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 23:31:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 87A0EC2663
	for <linux-mm@kvack.org>; Thu, 28 May 2026 03:31:35 +0000 (UTC)
X-FDA: 84815403750.15.72D6CBE
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf05.hostedemail.com (Postfix) with ESMTP id 26422100003
	for <linux-mm@kvack.org>; Thu, 28 May 2026 03:31:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=AGMvFtGV;
	spf=pass (imf05.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779939093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c5Hk8QYPMIPNx8ud4lNIyGEeROuyNFJv+XxWeF1fn+k=;
	b=RpHG2RHQG1bJA1ZoYCplGDqYg99kJAWnoeswgXObVbqUXlD9IcZh+QXw0UY9udfsly9IIM
	epoTFf3DJpRXxAfjMgn+EDZjFc/rOsRcq2vbnAt1gFUrb5yyimr+ANluU3TPTz2Y2h62Et
	NPkcUsStWKSdkCHRPm/I8e6xVtC69M8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=AGMvFtGV;
	spf=pass (imf05.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779939093; a=rsa-sha256;
	cv=none;
	b=7ea+rdegiL2VI5kLUqccJ8+Ymev3ehUdy9LH3sqYp4dnlkMoPcEdT+PrkFOhaRs6oWZDI2
	q3XeBLjeBa7Pkr0IdKYOQSF63l1LFagergLP8DYXaB6wmK9UZMp/PuApITzcQxXgWDpPIO
	qU1wKDC9WILIOdRuXtwEqg6wSIJMOUU=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=c5Hk8QYPMIPNx8ud4lNIyGEeROuyNFJv+XxWeF1fn+k=;
	b=AGMvFtGVwo6Y0FHx8ka/ETADMQfqFwzqcD1HYVjhSZUd6/XUeReV/gHwMQJIZ09YEab+gT9Fg
	NmLag4kgDCv/OxazIufHenWHXQV2yvL/55BwNXDX39TJgPoP+nERrRPgbhocQRBhk9SFKAIYR1q
	Oe/hLUGX4t/K+Dr9p/UNT6w=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4gQsJq6rdbz1prMF;
	Thu, 28 May 2026 11:23:39 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 951064056A;
	Thu, 28 May 2026 11:31:28 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 28 May 2026 11:31:28 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 28 May 2026 11:31:26 +0800
Subject: Re: [PATCH RFC v3 5/7] mm: selftests: Add shmem into memory failure
 test
To: Lisa Wang <wyihan@google.com>
CC: <rientjes@google.com>, <seanjc@google.com>, <ackerleytng@google.com>,
	<vannapurve@google.com>, <michael.roth@amd.com>, <jiaqiyan@google.com>,
	<tabba@google.com>, <dave.hansen@linux.intel.com>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Hugh Dickins
	<hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, "David
 Hildenbrand" <david@kernel.org>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, <linux-kselftest@vger.kernel.org>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
References: <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-0-718f45eb7c75@google.com>
 <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-5-718f45eb7c75@google.com>
 <9effbeca-3453-f0fe-571f-85f8923e1385@huawei.com>
 <ahcjRGwLFEN2NH3b@google.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <85ae0dea-3f49-3102-059f-55f5f67c91ac@huawei.com>
Date: Thu, 28 May 2026 11:31:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <ahcjRGwLFEN2NH3b@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam12
X-Stat-Signature: u6e36yo3k3uz7imcqrw5rwdyrd5gc8sc
X-Rspam-User: 
X-Rspamd-Queue-Id: 26422100003
X-HE-Tag: 1779939093-963879
X-HE-Meta: U2FsdGVkX18O8041fsRedaPkj34ky+hA2DCbyGxtuUdE03aJ0p2NnJczfpSwBdfPk90fjF6Skc1J3SY+lQkVFf+5ZpCwfrjOlRJiArP7QNYzqbPLPRDuL/htxAvbs0gLb5bnPbkFmZ+xuOze0V1hCClOZlRUhH7RoSw/CgRo3PKQjtXMH4lDeQa1Lbjg0AkWUyFz1fiEwFJznPkYunPaaBrXBEy39qYWLZu1ZDSTVWTVCn7o4Q+91wEg7vSpv2c6mqNKdDQq8EAQmyWEuSw9z9qlkyqc1wwJSF9xuP+oaKXjM/CDxAmKFLGan2vFJnYxHNvxGYW+h+32VLel9SrNo5uz8natX7r3hgOJN0oFy+hXSc16wVu8CuyTihNDqkikQbTLJhPIhXmsCpDWDJsfjqTviDayhD763a1zju+QBG0SH9fYBJa1vxZwyv5qL4IJHr8LtmhIKf5dxiM6ks/FvtACW8Yeqb5z/b0odX2N+Q8b7Ec/dRyUWA2LIx1k6XsbTwQCUqdXpPxXrpKJh87XIMgs08SxbCaIBh02SaBeUUNr3O2To/es+47+9KteInLy7KgYwckoGfHaDygyDkzys9UPUNdvZUaELJ0XCqelJGdtjUjiQsAJq++btD6ww4EFDQV6NzXpuK8/pod3i4nPn8JEsOJuyKyvqXv8spSkXzkqx5Vkz4WNKmkIdR7/W9do6DIySF7d2rvjDNv3vJT4VjaIzyJa1WmVHUiDQ3o+DZOWdW0+bc6vm+VZl+QkVGh+H4f+YGSsHErgAuZu7HTajdJTsOEstKHouGuG7o4n4oiO6vixfyZpRZuGuMjiqmUnTPXd5uQgQQdeT63qjnyPOp1fOMh2/r4e1vZRRt7XNNTrS98lzMuj5P7KJTPjQlEkSjjKWBzPwUGx9KwWImbXSPxHGzWiO3TlK/imUGK5u6M+aQnxVdclR5dDRi7mHlcL8un26gpTCSEfG1Z98Rm
 23fyd1vU
 SdPq2c9LMR0UHXUh0ZKM85SfvcwlVSF0uooWwEPSWt7rTYL+dFDzSbgJGPmrOLfNB+/oVc640tlA63Z+GhNgM+4YQtPxxCHG1Q0kX4MzEjKDKp/zHdJzU9IlXAhwp+U6bxRj3EY58CHEtARPXkRwwkSFsP1p2ljwQwZ/HTq6TqMpf+C+GOjFnVxufDK++F2R7Gq38PhMMzapR5cuq5TOfTc0SYPXQKk/Qapfok8titg9DDd3jYqfjr4EpMR/1gpsvdPbQUoEF1s6a/HuhJgLN3l2Pu+N9Eg/rBRnJLSVN0gEWXa1fm0Koa+e4hnZxEhTeWbtRAZFK7fCpIPq9NwJVhGu7r0lMy3N16/F7JkTmAYtvM7inpw/jVdMAdzP/YhNlp0vAtnyhlZYVHuI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/5/28 1:00, Lisa Wang wrote:
>> On Mon, Apr 13, 2026 at 07:57:55PM +0800, Miaohe Lin wrote:
> [...snip...]
>>> -
>>> +	case MADV_SOFT_DIRTY_SHMEM:
>>>  		/* The page content should remain unchanged. */
>>>  		ASSERT_TRUE(check_memory(vaddr, self->page_size));
>>
>> Why we skip check_memory() for case MADV_SOFT_CLEAN_SHMEM?
> 
> Because we did not write 0xce to clean_shmem.
> The difference between clean and dirty pagecache is whether we synced
> the dirty pages to disk. However, the difference between clean and dirty
> shmem is whether we initialized it with 0xce. Thus, we need to skip
> check_memory(), which checking 0xce,  for clean_shmem.

Got it.

> 
>>> +	case MADV_HARD_CLEAN_SHMEM:
>>> +	case MADV_SOFT_CLEAN_SHMEM:
>>> +		/* It is not expected to receive a SIGBUS signal. */
>>> +		ASSERT_EQ(setjmp, 0);
> [...snip...]
>>> +   if (variant->type == MADV_HARD) {
>>> +           check(_metadata, self, addr, MADV_HARD_DIRTY_SHMEM, ret);
>>> +		ret = sigsetjmp(signal_jmp_buf, 1);
>>> +		if (ret == 0)
>>> +			FORCE_READ(*addr);
>>> +		check(_metadata, self, addr, READ_ERROR, ret);
>>> +	} else {
>>
>> Should we always add a FORCE_READ() just after variant->inject to verify the accessibility
>> to the addr for soft-offline case ?
>>
>> Thanks.
> 
> In dirty_shmem, check() already verifies accessibility to the address
> through memcmp(). Thus, we only need FORCE_READ() in clean_shmem. Will
> add this in the next version. Thanks !

Thanks for your work.
.


