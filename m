Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33FC1D2D0FC
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 23:35:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A38B6B0088; Tue, 13 Jan 2026 18:35:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 951FC6B0089; Tue, 13 Jan 2026 18:35:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85E526B008A; Tue, 13 Jan 2026 18:35:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 752726B0088
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 18:35:44 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2AD481602C8
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 23:35:44 +0000 (UTC)
X-FDA: 84328550208.07.65C092A
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	by imf16.hostedemail.com (Postfix) with ESMTP id C2B37180003
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 23:35:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=deltatee.com header.s=20200525 header.b=j2r+6Q9R;
	spf=pass (imf16.hostedemail.com: domain of logang@deltatee.com designates 204.191.154.188 as permitted sender) smtp.mailfrom=logang@deltatee.com;
	dmarc=pass (policy=quarantine) header.from=deltatee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768347342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BSFJmjqkr3SG+Wmzr05iwRwKLgAbLdJHQWRc2GNC65g=;
	b=rKrAEN4y9E86zsOcRuH0KW7fzhtt/h69U0JsL0M6gpFt6Pld9YUeNagAL+RY1spBAObaWb
	tR8vLMuhSNq5BRTxhr4bAycjbzK5hHEaKvW6dCUuke3ERUphgSRUgr9R9EkNmg8OtW21zZ
	1PsGyfW6w+1rznF1+/+jhNeB/CexOGM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=deltatee.com header.s=20200525 header.b=j2r+6Q9R;
	spf=pass (imf16.hostedemail.com: domain of logang@deltatee.com designates 204.191.154.188 as permitted sender) smtp.mailfrom=logang@deltatee.com;
	dmarc=pass (policy=quarantine) header.from=deltatee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768347342; a=rsa-sha256;
	cv=none;
	b=B+xA7yDhk3euGKXr8fPn1LWu9qE0TwlsjJBT6bia+ACgX0izFi2PscJSaudTOYTHr9kT/L
	tfkOyXp3V8xIBwbm1bfozS3ffeFF+ZReSKSBIlx20/WdywESgXmPutw6xh2BvIBKEbZk7R
	zJW22FtvI2XQMS3HAFn+WiG7NTCdkcs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=BSFJmjqkr3SG+Wmzr05iwRwKLgAbLdJHQWRc2GNC65g=; b=j2r+6Q9Rd1jlEMASSc+4qmx7gT
	wAMSprno495z+UF0PvP/iZLFC+KkJsLKKbfNeXHjm9yNdml575qdsEtvTg8L7oIl/2UpblCFvdllL
	oDC8D/H3i7ybC4bucF+qUUiDKin2wW90hxwp5txaulpA4sST+834nRRD0Xv+u+lnXBaOy/c5PFyxE
	9/Eo72mJQSkEJnZ7Ozt5V56yP7w9gAJ4xJe6oJa3an+mbmkx3I7KclYQRqIDXKdXZkbXDpjCo42nB
	rnFCeC+sYuIx1NohJPt69cjom2QdSDVIpJ62dRl1DbSRhqYj/Zg+rGOmNCKMFWHi8SusF7VxhkwI8
	VMe4hlOQ==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1vfnvG-00000000mAR-2Lj7;
	Tue, 13 Jan 2026 16:35:39 -0700
Message-ID: <e2e4cbdd-2abe-4e25-9cf2-746af5ede443@deltatee.com>
Date: Tue, 13 Jan 2026 16:34:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Alistair Popple <apopple@nvidia.com>, helgaas@kernel.org
Cc: houtao@huaweicloud.com, linux-kernel@vger.kernel.org,
 linux-pci@vger.kernel.org, linux-mm@kvack.org,
 linux-nvme@lists.infradead.org, bhelgaas@google.com, leonro@nvidia.com,
 gregkh@linuxfoundation.org, tj@kernel.org, rafael@kernel.org,
 dakr@kernel.org, akpm@linux-foundation.org, david@kernel.org,
 lorenzo.stoakes@oracle.com, kbusch@kernel.org, axboe@kernel.dk, hch@lst.de,
 sagi@grimberg.me, houtao1@huawei.com
References: <20260112005440.998543-1-apopple@nvidia.com>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20260112005440.998543-1-apopple@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: apopple@nvidia.com, helgaas@kernel.org, houtao@huaweicloud.com, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-mm@kvack.org, linux-nvme@lists.infradead.org, bhelgaas@google.com, leonro@nvidia.com, gregkh@linuxfoundation.org, tj@kernel.org, rafael@kernel.org, dakr@kernel.org, akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, sagi@grimberg.me, houtao1@huawei.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH] PCI/P2PDMA: Reset page reference count when page mapping
 fails
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
X-Rspam-User: 
X-Stat-Signature: b1osybhh3i15gmjq379aen117tf17asq
X-Rspamd-Queue-Id: C2B37180003
X-Rspamd-Server: rspam04
X-HE-Tag: 1768347341-502561
X-HE-Meta: U2FsdGVkX1/ilRSbbj2bqfzHJTjMPWu9rgh6/wgU8KArmx3s1STHVyrkOdV6tX+GMg8bd6N179LK/LrQlBiwkl+vMOu71bfPRuXo/NpB7XEfWwjr7ceFmNu6fEUzoV0z0+YQzn8rbJnFs+1Ua/dpGX+sJlJagFnOzlATWDRvFy85T45cpRSUJ/haqRwcmov0uVlhDsHMIFSkJE2k6yjK4z76QbNzubAEtUsarv7PY4J/8Ct1ZgMPEbO+ad/qiRrmckVVmLMe+Clv7ZoggwQKfoRrx1B3k4IV2RjHaON21xsGhm743UpYPVPvgLJxaAIuM1NeN9/3kmxyV4cnRiomLH7rNlC1RAKMNp3XVXWDPFsOpCGQa/ZvyeYCmo7lxpgOaNKUnRrWDMUp1nkxyx6IENXCyF+xtOCjhK/liFFBJ0fjYar+Jl5P1Y5ALbE/SaG9Flqr9cJZg6aK6EzvKP3BDntwpxKbYoUGMjNozqe6HmCyULyL3eQ7PdcwIgB7UdXMH5tA2QNGGbpXLSblaHpYgPf3iXgjR+6NtVB6/WcqR5jv7Gtwm8OYjbazcoIRcX42ngHDqDwJdR+P8vBBPLVeLhFnPG4QOLD0dUD4NWEWvcnItEaFvGlqA62UD23U1U85H9oi0CmaEUJDZ7f/Q4der7O3O1VKsb8ysNVQW7Lo56LjTxqLLITnuHSVwr3CJSpNELDDeq8JUWss43hiKC+9hmTYKg8mchnP12NbDnJ8pkYRxGNhgM9O8MBpiI4yXwv7o9KPrUhNLf2vLhhUYwO+la7vwzV+MWwJPRvDWU4fF3ceCOZbXyi12bbWmbV4OEsShqiFWROBdWzMrcYyxQixsu2Ik7qfS/A/oYTdpmLMtLAwtWuKpZsVhJiDRgOcRRVUQTjdKB9BDbE82Caav0BPlGwpcFidKpWFPquVrnvQ/I2UpcZ5JWBuVl29Zd2aKl0Qj9qvSdZVxDryneGIPZR
 fcQNMmQn
 utB2QJ6ha/ufkWHbeQrNNaTO/WTTdV4xH7JgkPR1Xh9Kwsr7VlWEOJ2QqlnZi0wPZxS0XMerwku28Eu+8pRG5DM7YwWOMlxc4AS/xjSfs3RqkpcQ5ZZ4TI5Zanq52mj+bBCY+ZsHgshdCLdo4OKc1Gda5n2ja6o3AhMrpUvBRV9lEBVfSuAM1yC92v6/uNIOJjsO89JkdIUCeJDLmCeJ9u3ZWaujZTb1oAwl9EavyKm1HZ286D0M4Ahoo6PLZo5ByaZnzncltorua/PtfPrADPLNTFWSXoWVH11HscuEn4ClSlU72gwC6ocz9A+5itSbMyTlR5nEt550UI3BUHDybixgu/fzUdf8ejirMH/9nLEjcqmMAGnAbt7BdtfiWVGZLyVk1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alistair,

On 2026-01-11 17:54, Alistair Popple wrote:
> When mapping a p2pdma page the page reference count is initialised to
> 1 prior to calling vm_insert_page(). This is to avoid vm_insert_page()
> warning if the page refcount is zero. Prior to setting the page count
> there is a check to ensure the page is currently free (ie. has a zero
> reference count).
> 
> However vm_insert_page() can fail. In this case the pages are freed
> back to the genalloc pool, but that does not reset the page refcount.
> So a future allocation of the same page will see the elevated page
> refcount from the previous set_page_count() call triggering the
> VM_WARN_ON_ONCE_PAGE checking that the page is free.
> 
> Fix this by resetting the page refcount back to zero using
> set_page_count(). Note that put_page() is not used because that
> would result in freeing the page twice due to implicitly calling
> p2pdma_folio_free().
> 
> Fixes: b7e282378773 ("mm/mm_init: move p2pdma page refcount initialisation to p2pdma")
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

I had time today to pull out some old hardware and run this patch
through my old p2pdma smoke tests. I don't think the tests exercise the
change, but it looks correct to me on review.

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

Thanks for the fix!

Logan

