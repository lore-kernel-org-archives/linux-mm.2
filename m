Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4435CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 09:35:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D9208E0020; Fri, 12 Sep 2025 05:35:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2895C8E0006; Fri, 12 Sep 2025 05:35:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 178288E0020; Fri, 12 Sep 2025 05:35:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 01AC38E0006
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:35:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A4FDE86934
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:35:40 +0000 (UTC)
X-FDA: 83880090840.29.C31CBCB
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf28.hostedemail.com (Postfix) with ESMTP id B66F4C000A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:35:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=pMSFA+pe;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757669739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8wqlXppzbfyIOcS8BfKoIJCpvoAzpjciPU1+yNHw35A=;
	b=LIoUWyszce4dFNJnPlCJrKHWVjiB73YLN+3vtgeQsJ1/3/yBsbR0F3WSCg6aoevoXhwyHD
	O/PBH5PP+UTOhjQT+0E/Dyb9sdpQWImO6AE1EuZ1Nn/xrsKFaz1mbW8HGI4ZK9D9vDjq/X
	JFtF52ivaX4Lz/mza5Uwv3ATrvJCENI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=pMSFA+pe;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757669739; a=rsa-sha256;
	cv=none;
	b=aH7lIzQrJ+zA40gY3cNqM5KuXJcSoY9w2P4jmdvZI1K0/zejGAa9Q0zSSAmjzKJEi+ENd8
	pJI23fXZqUkv/L8PFhdHNBdwi3IbVoGySQYNv9mGNoZ0Nt6B2UOgl/GHgvpVzKi2KvQ+a/
	zBTO3KWoDJVechZnJf5llTTe/5rB72c=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757669734; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=8wqlXppzbfyIOcS8BfKoIJCpvoAzpjciPU1+yNHw35A=;
	b=pMSFA+pelvuI8iwqwK5jY/u+ojM+DaXKl3vIaUP/GIL0nFDMgY2jnF8oLfJ0whghQ5FflQ6kL+3sqjfOzxgRMuXBF2sbz3Bv4NV3dcRUkt9fKXt7+6Krvl5SVATBzlT58YnuaWmP5uCoZzGCU3xKeOBUTp4Hd9v2DNP5jXb7pGE=
Received: from 30.74.144.122(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WnqpLMs_1757669731 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 12 Sep 2025 17:35:32 +0800
Message-ID: <068a41eb-3a5c-4749-a8f6-c1bda1fb6a4b@linux.alibaba.com>
Date: Fri, 12 Sep 2025 17:35:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 09/15] khugepaged: add per-order mTHP collapse failure
 statistics
To: Nico Pache <npache@redhat.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Cc: david@redhat.com, ziy@nvidia.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
 corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
 baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
 wangkefeng.wang@huawei.com, usamaarif642@gmail.com, sunnanyong@huawei.com,
 vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com,
 yang@os.amperecomputing.com, kas@kernel.org, aarcange@redhat.com,
 raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com,
 tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
 cl@gentwo.org, jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
References: <20250912032810.197475-1-npache@redhat.com>
 <20250912032810.197475-10-npache@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250912032810.197475-10-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B66F4C000A
X-Rspamd-Server: rspam05
X-Stat-Signature: wmnpmz5h7motiugi3jo1t1ai3ao1hg4h
X-Rspam-User: 
X-HE-Tag: 1757669737-123189
X-HE-Meta: U2FsdGVkX18hYmLVE0uUBJCrJv0CA9fEriHwwXMM/fAC5SVelS1mMayV14kTVE9HAJw/y2SEVmEt5r0KPs6VrNhOL+EcemDSTj8J7crV0HWAu9hKOoUcbSO2G/U/K0WzLRb9DHCH6NxJ/sG92y4u0R2CFCh7sSVgRFOA4w1CltmMfHP5sG9kz93Ble8xlZjxhUnrNYGanqwqD7khgIzBnKXpg0y+vVD6kRIxDMkZlQSPA/Pg3cQiSFE9yLJWSssfbWM8UZDC+p0d9N0545cREZHcOeh4qXKLSlUp3VUGc3Ju/El1sb73Hq/tiHWXP0BnvroWixL/qwuCL23uJhfM5f45/hvzzQRRjGImu5Knf4u2rxhKJ1ZFVOhbzzFuuoB1SolCubrOmdylr1TuqMxjBEJ8n79FZ1ClVJolt1JBhCX+WdwBOEhXM30qvZ37pxn4W4sSSQsT7RgC+UhJ+qDjwbrGAhSTYAy6QbTgae63QD8WkNHrbm+TOX9Qeml7e7XdglWKJYTv8Klp7sYwRpox1v95AO1eREYWzd8MlwE3ua7kOcKbaSbl4a01BkMKEdyMfP6PXJ/rf6f+HL7RawT/HkcBk3WPJbVrqsPsQf95hYp3YQk98thm3btN1SteqYKCtTAE7GLL4DDOSEHXQph+iqHwnNvBdNuBBAfMMaYuT1VUEa4JPZ8eK6EyLZxUvaM4cDm++g0wRwgD55uaRWP0NnHZNex6Dw3K8cQoyPEBQh0ZyDTtFu8bdzBb7jBTJm9z87DLj6ZtyFUI3OqXmwLcsXneFTGCQ413X9+ihvW9vHVeqjmbEg5dsnK+Lz66wPTIUYiIK/vC+QdxVGJYvj08tGQyuDGgFpReuK3snba/hNbR8kgP9d5Vqm4GUm6n76f4Pfb9gpCTw/LCRpg08U7Lx0HxWj9WEjAXdHBvZ6ClHwByDuw16kNrFTyPYVZ7tPPTwBj7AaS7Ea0hhA39LGE
 8DGjTjNc
 QeAtx87NLq6qStKM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/12 11:28, Nico Pache wrote:
> Add three new mTHP statistics to track collapse failures for different
> orders when encountering swap PTEs, excessive none PTEs, and shared PTEs:
> 
> - collapse_exceed_swap_pte: Increment when mTHP collapse fails due to swap
> 	PTEs
> 
> - collapse_exceed_none_pte: Counts when mTHP collapse fails due to
>    	exceeding the none PTE threshold for the given order
> 
> - collapse_exceed_shared_pte: Counts when mTHP collapse fails due to shared
>    	PTEs
> 
> These statistics complement the existing THP_SCAN_EXCEED_* events by
> providing per-order granularity for mTHP collapse attempts. The stats are
> exposed via sysfs under
> `/sys/kernel/mm/transparent_hugepage/hugepages-*/stats/` for each
> supported hugepage size.
> 
> As we currently dont support collapsing mTHPs that contain a swap or
> shared entry, those statistics keep track of how often we are
> encountering failed mTHP collapses due to these restrictions.
> 
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

