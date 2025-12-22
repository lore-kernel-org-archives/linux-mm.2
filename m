Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04BD5E677F4
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 16:50:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D7DC6B0088; Mon, 22 Dec 2025 11:50:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15BC56B0089; Mon, 22 Dec 2025 11:50:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 067146B008A; Mon, 22 Dec 2025 11:50:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E3EDA6B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 11:50:07 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 67F1914027E
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 16:50:07 +0000 (UTC)
X-FDA: 84247694454.17.5A48F57
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	by imf18.hostedemail.com (Postfix) with ESMTP id 353A01C0012
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 16:50:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=deltatee.com header.s=20200525 header.b=ee8WmXun;
	spf=pass (imf18.hostedemail.com: domain of logang@deltatee.com designates 204.191.154.188 as permitted sender) smtp.mailfrom=logang@deltatee.com;
	dmarc=pass (policy=quarantine) header.from=deltatee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766422205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kg190DLkPKaiJohQI6jqmDPUrKa96yp2xevLyMH3St0=;
	b=LkArhQIxn4RHrXH+s8cY+5AGXY9k2OFAczr7fF7D03HrBqSJktHXCyf1gqopIXh1Z7W65E
	NZJ49fDRzKpAuPw8vNSxa28OnBQtdC0Jsjndq6Vz0jFHfcm7ae+PVlArLpNmObn719pllO
	XMJzUwXbi5Sykl6BxETbbc+LgPtFqwU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=deltatee.com header.s=20200525 header.b=ee8WmXun;
	spf=pass (imf18.hostedemail.com: domain of logang@deltatee.com designates 204.191.154.188 as permitted sender) smtp.mailfrom=logang@deltatee.com;
	dmarc=pass (policy=quarantine) header.from=deltatee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766422205; a=rsa-sha256;
	cv=none;
	b=QA2u0pd+g+rdQtMaGTkycp4X6S7zyZKUoz1cJLWabxTu0GWfnaY3f9CpSkzreuzWNdKrk0
	GitjsM/z4GJt8xmZWT9da+QlWGKSSToK+pTJ5Le9d4JRto2x+qa4NYBqMMzk/R2IqxQ6uH
	EABcIQEdbqkdF4h1Dd4FwArFhwn1n+M=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=Kg190DLkPKaiJohQI6jqmDPUrKa96yp2xevLyMH3St0=; b=ee8WmXunPJLOsQa4E7AD0Qn0/W
	CJseKOSYhTHpdSF3EIwXXjV0QzPZFAOy9hUJChrTEzpfA7nmQ9UeMhrgoJmyyOnkjwB7IRUVLyobP
	zO5/D77jRsl6BgVBDnzdECyg7Gfr1rcES7bXQAIEOHiG0zUJZTPhAQatgzPN0ZvO5VBglFlXHZh5E
	zP/wqKqGoD7/BLOf5J4trN1m/sRkvSkoAbe4rHTGFj8bmGM0n30zAHBo+GEpIE+zDYGUOBx49vEXW
	2QPhSmMNSQIReNrNkFDZtzuh2uEXXd+/+JNvdyCTrs2ol95Nt0H/hs+5EkslWz28fs3K52AdQtVdH
	FXi0e4UA==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1vXj6h-00000008Jae-1nLB;
	Mon, 22 Dec 2025 09:50:03 -0700
Message-ID: <7ee29764-487a-4b23-8580-a9f45d73e088@deltatee.com>
Date: Mon, 22 Dec 2025 09:49:41 -0700
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
 <20251220040446.274991-2-houtao@huaweicloud.com>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20251220040446.274991-2-houtao@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: houtao@huaweicloud.com, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-mm@kvack.org, linux-nvme@lists.infradead.org, bhelgaas@google.com, apopple@nvidia.com, leonro@nvidia.com, gregkh@linuxfoundation.org, tj@kernel.org, rafael@kernel.org, dakr@kernel.org, akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, sagi@grimberg.me, houtao1@huawei.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH 01/13] PCI/P2PDMA: Release the per-cpu ref of pgmap when
 vm_insert_page() fails
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 353A01C0012
X-Stat-Signature: 4b1qcybsbi3a1pkph4eh7ftkreiqx3dx
X-Rspam-User: 
X-HE-Tag: 1766422204-923917
X-HE-Meta: U2FsdGVkX1/G5pReaSCla83Eum8fU02sIU7pUu1dSWBkmd88UWQXYxEZ5cUt1snPmSVUtRR9rLdkM5U1iUb+qypdMSPlBxBqmsQtrgxbR7hIGay5zhb3PnlenOrSct6eYz1RL0qHIOnjDyi1zI636xKD+cxHEGeU2cyaEjDmU7PbGqnPrLSY/Tafu6DTTPBG14TG7pqoqvPGInZVU8LNlvkrURDxKWLq+La105yzAbC0mGVB/kmxrbagY9T+DiP/bR18KT945rw3J3IwyoNPtje6R3Obdi2lTLAAjwKi1bU0pdfKUWTcrl4reHyTcYqKBRekJ8Y4TR8cB60rOVIoLPup+33kl1bmJD/QdwAN86Ki/P7cGqvK0ae0L6kczdwd7n2PHu6soLZlRsHy8yMpNUvElTKHEaJzH8ppjmOAuSb+bO1OTPRDELPRvIov6Tgy6h1crtAbGZ4Oqu2vI23kLD4qmuwpywXywRf1lyaQt8Q/WRiom6XWpOkJP458OM2yVHDWsZQbGUnVh2KlADLA3OHLXNV9ZX2sRtat2JEQFS1CwLQS7QNRxNeDWae8BHGcdkFO6t+1+8zlsz6Dax0JFrjiTU4wE4M9PZEgCdpxcj3IP4TBbkFn0t8uaBMB6QK0tLbi2Cxuxo1u8ipj2EdLG64gjbb/dD5CEQtHYi0PId42Mw6XVLrG5XGtpA+Oi0WZWLAs6pla2w/ASjVTns5hsQSioEjk2HnOnK4+AuGS+UhlOIcjDE9Ln9er0Qvvu2pbLa7bDAxveDgm3HBHIqcrJb13oS2voHun5jOL9ULwPYDT8WEfvMVd6rrPYGykslI+chEEHFzpDTd4cl0pF7/aY81YGcqK1HuLXFd4Tg5mjq1MEdap1puKmT7zLZ26P7EeuU/lmaCkw8lhIRhmwFHFvuTlHPLbWp/elpz6sNlpvV+ZrPUTZ4CkwffyHYD3386DgDrkouX4HwZBXoaG4XX
 rJA+BqLn
 O2CYcn1EFro+HOHXpekH9S77ATH502J1pTWVzszF4U4nhTOPzqgRufhryPk4oZu6D91vkfZtIkrYAmL7VrOVLUXKFT9B+buxz+LsCve3LiM4HdYxfww/lLiWPlDR3v+4bZjHdEKV2ktgUe3DxxFrygk5yg9N0X+MVGC8B11WUVLu8oL9lq17HaVrFkX25refys/EwlQfjnZspFQ4kJP1jd89oZ8cMV+QKcUmnI3R82C9qOQnecObxWZf/lSZpHNHA7KJPi2Y08YPjEVHotVOxuhFJm2mULI1zAEZcN3X0LYqlGNZvWypDUX1TKv/cTK8BQfAGhhR37LbeJ3y8OAsYRGfgcTp4a2amDFRweBlA16Twxvj9i20iacZ6BlOKjYT6+O/BSV4y1PW0d2m0+OtJ76hf+ZMv2TRgdBSI4e11zLTrMC1ee8+fWBrD6A==
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
> When vm_insert_page() fails in p2pmem_alloc_mmap(), p2pmem_alloc_mmap()
> doesn't invoke percpu_ref_put() to free the per-cpu ref of pgmap
> acquired after gen_pool_alloc_owner(), and memunmap_pages() will hang
> forever when trying to remove the PCIe device.
> 
> Fix it by adding the missed percpu_ref_put().
> 
> Fixes: 7e9c7ef83d78 ("PCI/P2PDMA: Allow userspace VMA allocations through sysfs")
> Signed-off-by: Hou Tao <houtao1@huawei.com>
Nice catch, thanks:

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>


Logan

