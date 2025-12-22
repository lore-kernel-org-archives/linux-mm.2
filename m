Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71384E677F6
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 16:50:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B62CC6B0089; Mon, 22 Dec 2025 11:50:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B23A56B008A; Mon, 22 Dec 2025 11:50:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A333C6B008C; Mon, 22 Dec 2025 11:50:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 92BC46B0089
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 11:50:22 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 321821370A4
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 16:50:22 +0000 (UTC)
X-FDA: 84247695084.15.C7A2E0C
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	by imf14.hostedemail.com (Postfix) with ESMTP id 392D2100008
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 16:50:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=deltatee.com header.s=20200525 header.b=qWc9bzQ+;
	spf=pass (imf14.hostedemail.com: domain of logang@deltatee.com designates 204.191.154.188 as permitted sender) smtp.mailfrom=logang@deltatee.com;
	dmarc=pass (policy=quarantine) header.from=deltatee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766422220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t8GQsgEnNEdrFwBBtAuZn0Q9GIr1eN47gP4XtMI9muc=;
	b=KDHc1/M/sqW7c5M5UNlRmF9bv1qZNQhh+0rGmFGDD6UpY+XQ/NBzUzZ6qTLMdM/5+uJxYx
	Re7Adtj9lfThzzzLbGCMyvGBFuWgn2OkzVOM6W52aWWLWRH1xVh/Ic4MJngv7jEMD79QWB
	8yhqYCuiaIwXFJg2y7v0gE12kDic324=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=deltatee.com header.s=20200525 header.b=qWc9bzQ+;
	spf=pass (imf14.hostedemail.com: domain of logang@deltatee.com designates 204.191.154.188 as permitted sender) smtp.mailfrom=logang@deltatee.com;
	dmarc=pass (policy=quarantine) header.from=deltatee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766422220; a=rsa-sha256;
	cv=none;
	b=a6R1SuJ/siUQRxpk9AMhN+QAl4yXc/W1MTuGyCOpe9L84Pi8mWSoTRBG8wa8WlyIT+7O/A
	OdM/en13oIaWVIvq3RYZ+DL/aIUN+eFN1w2t72vHIEulIL4ZusW5EXW7KCfHuLgsHCPTXB
	uDWSjmhafOt6I5v3SmQY6bGuG5W41GQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=t8GQsgEnNEdrFwBBtAuZn0Q9GIr1eN47gP4XtMI9muc=; b=qWc9bzQ+KWzrrDDEfmRCfKMy+q
	BpQQ82uAdGJVYXBD4KbGvK6kg/vNGd4ro2s3ZAI08XZMZmPOKf73pPfo8VjP/fLk6D6ZYFADioP3P
	GhiuFn2SS6ykpv7UgUvLbr5nUfYtfCetjQsvpQX44xh6MOMuFgnEgw6iQT1oXEAQFU9Qw5jf+F/Iw
	BXqB+iX4HfwVfIH5wkARC9vO9NKsItHqonsl3W8aK0PiHf+oE92O/7LLApq+cSgM045iM+LHzVQwI
	q7KHwMC32e1xDGMn9M5r8AELIYedCjq6alJDW5jr7ILlAmaD/C8LTLwE5FIKbnMcKdxmI5Kimu8P1
	V7mFoPvw==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1vXj6w-00000008Jb7-2atl;
	Mon, 22 Dec 2025 09:50:19 -0700
Message-ID: <4a91cfe7-75f5-49a4-89a4-fd6717e7e9d2@deltatee.com>
Date: Mon, 22 Dec 2025 09:50:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Hou Tao <houtao@huaweicloud.com>, linux-kernel@vger.kernel.org
Cc: linux-pci@vger.kernel.org, linux-mm@kvack.org,
 linux-nvme@lists.infradead.org, Bjorn Helgaas <bhelgaas@google.com>,
 Alistair Popple <apopple@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich
 <dakr@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Keith Busch
 <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 houtao1@huawei.com
References: <20251220040446.274991-1-houtao@huaweicloud.com>
 <20251220040446.274991-3-houtao@huaweicloud.com>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20251220040446.274991-3-houtao@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: houtao@huaweicloud.com, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-mm@kvack.org, linux-nvme@lists.infradead.org, bhelgaas@google.com, apopple@nvidia.com, leonro@nvidia.com, gregkh@linuxfoundation.org, tj@kernel.org, rafael@kernel.org, dakr@kernel.org, akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, sagi@grimberg.me, houtao1@huawei.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH 02/13] PCI/P2PDMA: Fix the warning condition in
 p2pmem_alloc_mmap()
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 392D2100008
X-Stat-Signature: 1ku391u87q4hhhtgs8scyk68wz6ueeh9
X-Rspam-User: 
X-HE-Tag: 1766422219-520365
X-HE-Meta: U2FsdGVkX1+1Uvpqq9USnVrHoI6GmkHQ2Tge62LTt/bAnw+GNPZyCoP/eVsEhAix61VrippBkY533vGmiHIGdv/N1B2Reljpz9PM7/bW+S4uOd++yMROKkf2xEUYyVf+MUbIL7LUS/eYOgLWNoYAoyetEdGYGOP0IOawgbz4izGFA318wz5ac5guTzxdVr+SqRKohFI771/WpKLvcfO8Wkut3kehbm4/FMBLCr1g57rIHZSU9cJQ6aQvNRxq0r7n/UkXnSRP4mDXWjq9OObjy8VNTUjz+logtzPJMYIoxfFDuPmwgbjaSS39Wq5lV04Qqm+8FA0IaksX870BKkIwXTMyG5zP7bw6MTGHN0gx5X4UWtzCSb/8aD16aWbn6mpZAHyFbBPQldsx/9kA0NZ5gJ43D8J5IgLvE+TcN7RJN8uAAcWlpY7oGwfJCT7uvp9Y/CY/C3u27EVVAxySzl31NkbdhUG+dC2EjDOjL8LaaYkzJ9kRvRUwT0UDys84OEPsj2VA5Q4n97Yar53kyIHA4OHhAIpvmLPmr0+cVGOGR1g72aSMLeTFTYIiFbDPs/U3KPFlds6q6lFeQHmEb0c6T0+ybn9wJ4RP5u8habAZ7uZWzWQcwBokFxC36lwEaS9K8fZkJZg3V1fDTYUg6X9dbPZnvwUPLjrsT1KRo7v1h2EIuynrOjLHlz39WJuy+4zq+S/lLYVlUYmH+l3YxovMJ+r2AQl71/66DRc1dYmGyNMCZUHjFIlKHCh4ymwDUmrk+eCIYH7dv/VrWO06Rn0cqOFDZEHN+XiwIDpL5gb8BS9619jdyRwk70u7uxdBRL1LNH+F/8MHAeWP2C6UCKHj9BLCMMlWtKtzLZhUxQC0MDx5CJD/Ty+FFYXW5d9HcyEA9aCzD0lpELM1fBnVqQwwBDFLvwbqdo+DSlXPCz+nPycyKxdpucNj9sBjDXMSG+EfpvU2hfg2JV6uFpRs/S3
 1sqzlrik
 hlG34lZQ7z/bX/zX6YREV4deHYCXccQqFPEaQNEcktBRMKzjFyA9m7ct+Slyot8xTXKPl88SpxzNsAp7odu5yv4KK51kSHc/uVeyW7/eJ+vJN0wuo0iJJklm8wd55FOXyWfDQGAoaPY589BKQnET/BOwviWZ0hK/dPbVX/mreMCPXOy3DL+5emDZ6YjOmzlGvHQNM9H/TojkWBnS/69AEXjsrssYuKqM7/ma7NiKLgEdb8sprfC+uLK7D+rvXKzZcYFqACIP7ZcrpkKl+jzRHlspBG/YQNYbVo6jnxR691JKCf9BGRcgnhEWyyLJn04WvWe6fMuLB5eLsPYIAAOnWFdl6f9lRvfZP5lAznMQhBSYpts8ULVosDn+7oxI3It6fl4ir5L8s9lo8vI4DiL4MEn0heco9yXCCFJGqGusc2+fyOL3TVR8Z4YPdIg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025-12-19 21:04, Hou Tao wrote:
> From: Hou Tao <houtao1@huawei.com>
> 
> Commit b7e282378773 has already changed the initial page refcount of
> p2pdma page from one to zero, however, in p2pmem_alloc_mmap() it uses
> "VM_WARN_ON_ONCE_PAGE(!page_ref_count(page))" to assert the initial page
> refcount should not be zero and the following will be reported when
> CONFIG_DEBUG_VM is enabled:
> 
>  page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x380400000
>  flags: 0x20000000002000(reserved|node=0|zone=4)
>  raw: 0020000000002000 ff1100015e3ab440 0000000000000000 0000000000000000
>  raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
>  page dumped because: VM_WARN_ON_ONCE_PAGE(!page_ref_count(page))
>  ------------[ cut here ]------------
>  WARNING: CPU: 5 PID: 449 at drivers/pci/p2pdma.c:240 p2pmem_alloc_mmap+0x83a/0xa60
> 
> Fix by using "page_ref_count(page)" as the assertion condition.
> 
> Fixes: b7e282378773 ("mm/mm_init: move p2pdma page refcount initialisation to p2pdma")
> Signed-off-by: Hou Tao <houtao1@huawei.com>

Thanks for the fix

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

Logan



