Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B92CA606A32C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 02:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=JSHWac6K
Received: by kanga.kvack.org (Postfix)
	id B0CBE6B05B1; Fri,  6 Nov 2026 21:56:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE40B6B05B2; Fri,  6 Nov 2026 21:56:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D3C66B05B3; Fri,  6 Nov 2026 21:56:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 783B66B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 21:56:45 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EF74C8027E
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:56:44 +0000 (UTC)
X-FDA: 85406810328.28.D60CCAE
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf06.hostedemail.com (Postfix) with ESMTP id 875C2180003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:56:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=JSHWac6K;
	spf=pass (imf06.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794020203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4RmMIdBBuZwqIZN+owVd5A29e0OX2sjKrvShRAWyn5E=;
	b=DDHxKo9tE07BN3Je6dj5npcV4hcey1p6bUJQafG/VyEdpsujFsjXS8cxpvK3LQr7j11kPN
	GcvxVYL4qcETDKrwsav6eK0isP6enNDv/SfdP65oLylAM+qyEgn2dS1/dchBe5HXzcBBiT
	RWa6z58HS5RLEXRQ/DR9JGZFUNzP/AE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794020203;
	b=O7hxe9CCWmJofLX38Y+btsbW3riowHQ0ijUOgetJ2yNBsvjYMclTDLN+c1uiCGTJWh8orw
	jdEbF1rIxv9/8nqYf13cJxE3V9dAi0YAojmgVQaUUDZSuegwEHkduk/qQsVQrwZZl6dycw
	uSa9nN6FxPinZlxhdeTMdq9hTZTjyeE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=JSHWac6K;
	spf=pass (imf06.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=4RmMIdBBuZwqIZN+owVd5A29e0OX2sjKrvShRAWyn5E=;
	b=JSHWac6KDmDIgwP1MxkYKpxq2tN+bAszM/0/2Xz8AF5oK+q8ZEB7r4zI161PcKtkKXFWMkQjm
	GVrhoNpYDkWh0dy6q5+BJs5eZZd2xJbKhJlXV90EHYtWGWxLeODp0qWgVXRu8gDxAsVKB1ZtrhU
	SnI8kkA9OoG/lKgBS936bCA=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4jM10H08Zzz1K97J;
	Sat,  7 Nov 2026 10:56:31 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 9D8D040578;
	Sat,  7 Nov 2026 10:56:37 +0800 (CST)
Received: from [10.174.178.56] (10.174.178.56) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sat, 7 Nov 2026 10:56:36 +0800
Message-ID: <a069cb8e-d255-41e3-8907-387add57d46d@huawei.com>
Date: Sat, 7 Nov 2026 10:56:35 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/ksm: fix ksm_exit() deadlock on exec error path
To: "Xu Xin (vivo)" <xu.xin@linux.dev>, <akpm@linux-foundation.org>,
	<david@kernel.org>
CC: <chengming.zhou@linux.dev>, <liam@infradead.org>, <ljs@kernel.org>,
	<vbabka@kernel.org>, <jannh@google.com>, <pfalcato@suse.de>,
	<kees@kernel.org>, <ziy@nvidia.com>, <gourry@gourry.net>,
	<anthony.yznaga@oracle.com>, <linux-mm@kvack.org>,
	<wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
References: <20261106013906.2229780-1-tujinjiang@huawei.com>
 <au2T9iCCt9VM2IxN@dgvxl46587.localhost.localdomain>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <au2T9iCCt9VM2IxN@dgvxl46587.localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Stat-Signature: b9z54s1mw8hfbyxncqg1rxi3isbpqpd3
X-Rspamd-Queue-Id: 875C2180003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794020202-908490
X-HE-Meta: U2FsdGVkX185w+xaFEO97JMes2z5f1/SDUDglqoI/7LHjNFKDPxhz43VSHQaWXEtxXQlJl3Vu69ULhmx6V2gicGW8He7QPwBtvc9GUw9+6Lpi6XBv7uiNf7kM8O2aXIWJ7Wxgmk2b5EupS2Ll8pvi4W1G1fRyjW7ZR/oQhiRQVv+QRX+nFwiNW+wpBbxr2qPmDQ3qHp2e7lJHNWvSY6CokVem+zHkA1alfWlL21HI7RMIW4gjYWQHEY7IbTP9u6LfQ7ay84W6yzUrpuRaFWmvBjSzRtNA1RM9blxKj85arLKT6nDifpymNP3M9G60tm2Jj4dW0UUZRs026hEguHHrE4/wBzLDv7hwLE6F8D6pMpp+JQMagFln+j849B7zlLEffSEbJ4qCVHwLU38ZNdvdQHNe79kdChpIYUwBwlLxP0R8KB5NjN6QE877il7Njm9xOdcRTiJGTu+WxNDJoeAb5D415y9FHc+UEB6oCBlYD42EQcCQGv5sOXYQL+BMMnATtrvKS44DXDsiGdcfVhiUlNJpoZ+o7V8TjFThq+nwGYeliJHKyZMiB0AmN76v1AeiaUOyOH1oQHenrUQ1qcfeoo0+m/SOr1az4L0nkTvBEdxiep/G/4IwgxQIHDceWOCL6vPle8baF3oLuAL/YsIPKt3AmYZPnz8UcqJ4tMkaC69/WJvRQ4BagIXShIPpQ7rolvgtkppm7cykZZFkVu6mG/YKensHv/bZYKOqXx+4hnpsmzAByYtm4zLwWyE8op17OPTy1tKOpM5mCPqT1SgAzBtypajH1XDGcw1oNzFKG0rtxRnfPgFLke7lnNbyR2c2mjGDLiC/yxTawwEhaxUnvFIB00LZhxhu+Sxx43+2r3OmIwWoJEbboj9EWEY/q4XwXKSc8MY5qwbznqJOqxnuaj27FilNa/EdeF5Cy7rtEkS4Qug0mJsfL2OriaiPXAD18a9zVB56HBKIEcGmvF
 yBgPUY/v
 XdDdAEJ55n3smDqaobYvU9lstgns0dwFSdqDpCnIlA9sbDLsYWq+4CqDUmTVMTgYAJNAbBb6QLIVdz0DCI0SAY6vPDVTX5NyhAzQ0ylVIFg8PXsRp61qSjrhxanW/DZyTPmDetcWNG0Tz/l92bk3XJ3dToV1YvkEcBgJg3kKir2dRw7DrdWz+tp/aZGF227sFgIc4iUE1gipGxwvjLrm1IsrWwIvLT+S1cxcOAW/ZFFVoYOAUTQ4N9mkaCXjPbu2FkboJe2rpQgYOa/r80bzId5iBCwaWEFdOWCCWw/mzkCUUdynug7jQiL9iMV/qExRlWmKtfaNe6xCL3IK+SmUWAWLeHdj53WsdR3XWr8TNld/ub3tA/RnC6yHCyG2qkuPJYSox4nLTEli9CcEZ4tZ94aqI2nXI9meH45i9f96Zy/I/dPatmNVpqLqzNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


在 2026/11/6 16:46, Xu Xin (vivo) 写道:
> On Fri, Nov 06, 2026 at 09:39:06AM +0800, Jinjiang Tu wrote:
>> create_init_stack_vma() registers the new mm with ksmd via ksm_execve()
>> while holding mmap_write_lock(), and calls ksm_exit() before dropping the
>> lock. When insert_vm_struct() fails, __ksm_exit() takes mmap_write_lock()
>> again when the mm is ksmd's current scan cursor, leading to deadlock.
>>
>> The early registration is no longer needed after commit 590c03ca6a3f
>> ("mm/ksm: fix exec/fork inheritance support for prctl"). ksm_vma_flags()
>> calls __ksm_enter() when the first mergeable VMA is created. Remove
>> ksm_execve() and its stubs.
>>
>> Tested with ksm_functional_tests, all tests pass.
>>
>> Fixes: 3a9e567ca45f ("mm/ksm: fix ksm exec support for prctl")
>> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> Need to Cc stable@vger.kernel.org ？

Indeed.


