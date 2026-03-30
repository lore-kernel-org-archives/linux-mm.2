Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72F41FF4953
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 07:02:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D9E66B0092; Mon, 30 Mar 2026 03:02:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88B056B0095; Mon, 30 Mar 2026 03:02:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 779836B0096; Mon, 30 Mar 2026 03:02:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 634706B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 03:02:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 12BA01B8929
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:02:13 +0000 (UTC)
X-FDA: 84601835346.02.9D953EC
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1F5CA40011
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:02:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ET0PV2RE;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf07.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774854131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GhJnq8tM70t/LeoIB8KC+c1fKSsvfayGrRahNCduYkc=;
	b=EAh5YzXmb5YTWztyl329raKtHc4sg7jpNzAjJY65589BLSKXzEX0jDvk57jKOYkBo41C40
	97/XaWwLoeFH7X/GkQ11M23lUyEBUJAJKik//NeuMWeMaWswscrWKmGqwKGpxYDICnd7kW
	E8YXvTSFFeOTU3I8JB28iL/7tuWitwE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774854131; a=rsa-sha256;
	cv=none;
	b=7JvxSCSjNIcIqNa2qIhOyh0z/nY5iS2OI8IwlKluHvqCoro74akZ3i8Q+ZnAh1nGG3kA4B
	n5ADdtXkae8dc/nwM8kq758XuS14ddsIFuG4TuB+Zcfa7dGmCl8wSqvJnT7AXeZlrCtaBh
	fk5KSxJaPM+N9dmDxaoNyywh1GKH0wk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ET0PV2RE;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf07.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=GhJnq8tM70t/LeoIB8KC+c1fKSsvfayGrRahNCduYkc=;
	b=ET0PV2REqA05mUNuZDSOpL4GG6YqcTyUCgAEA6QuGHjF1pHqkipPGGlgfhJXaCw8+X2N/9Bmd
	k+z7DZBKwelquOB19CR7gH1lE92OZZsrSd/evGhRpePP2vtl5epc+kwpr54Bg4Hh/tfCh9AlkHD
	NU4nbhp175q/e4CXdqxm+14=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4fkhqR42pfzpTHt;
	Mon, 30 Mar 2026 14:56:19 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id E58EE40569;
	Mon, 30 Mar 2026 15:02:03 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 30 Mar 2026 15:02:03 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 30 Mar 2026 15:02:02 +0800
Subject: Re: [PATCH RFC v2 2/7] mm: memory_failure: Allow truncate_error_folio
 to return MF_DELAYED
To: Lisa Wang <wyihan@google.com>
CC: <rientjes@google.com>, <seanjc@google.com>, <ackerleytng@google.com>,
	<vannapurve@google.com>, <michael.roth@amd.com>, <jiaqiyan@google.com>,
	<tabba@google.com>, <dave.hansen@linux.intel.com>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Hugh Dickins
	<hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, "David
 Hildenbrand" <david@kernel.org>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>
References: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com>
 <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-2-92c596402a7a@google.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <2f177e0f-2eb0-48d0-b48c-7a0a340caf5d@huawei.com>
Date: Mon, 30 Mar 2026 15:02:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-2-92c596402a7a@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Queue-Id: 1F5CA40011
X-Stat-Signature: mdioz1kftwp3btxpmbu4mreqk9f3j1uj
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774854128-878601
X-HE-Meta: U2FsdGVkX1+TIZyOtbRQz3VK9mqGUvqtCDCLIGhm2AxPoh2zrgPiaoo4za7rzc2dpbZvC4UCfkhJK4N79uP9794/vxOK2H9wgnOI/DrpaZDQqL9U5hFYwIqr7EfVzLSYx3gAafoFDcaFNEw6NcDibhTOsIoRA0jPUZtTcY7CyLPcKOQuQb/bKsC5IJrO6qFDWJsxFNXAPKt9xRYbvF+IDCcOG5UZLVqjfNFk2BJ1AaS4QnUyO2sBRMurvhImzaH/mKtPyD8Uye/l3/raIAvOkWvNMxJdgxGr/i5zf6t0VE7HjRk0GxzRJfqei766KgsVxwe8/hBQkdofOFQCyMr03xSXF96PsEzOzoQB/q0BcwXj4XUrhjhTGBFLhZvxbFDT2f4N11fdzrBS/wQBnxU0ccrlIu1c2WygIgvDfmBmNGdkd8mDzCCfkjMJkdh893L9Yuf7beICWPG1C1iqS1XUdyBikgkjNdRq1dIGmoMu9SNfllxfcT5fYHwe16eDrKAnio1Hmq+Zjo0a3/8E5C02gJmm5IWYNRNfXPHTq/2Mxs4KICpvcKL5QbCT0z3ZoaMW6mdsIf0n8bE9gCfB1z3pm0fztMQ6eXE9GIjn6TgXZWi0hFbr+5olDjoVr1b0slrD63h6dwA9uWCjnbYVeO1asPmqKvAQ8shij2gyEVLLCgHps9plYgRsj6ayV4olhYwetvsvuxubdqlvOhYYFKyHyVcJHDpbuMlszjm8+t90qXAyFOEwWGYX941EW1dwJ3DBAjU4WJAYb2PdOFrI2IQ4GUG+ABB9kRP3Rf5A9iVfJlDDFC7WBaLI8iqNipgvNCAbRM4KcnAN05gVFVZyRRIZT4fiKQLOT+QHN2v274WSjXwL0ANtzJ5WlDYfWDpdcxK7trwzcBhIyxGcoM31MZ0Mtm1fz+ZUSaPatin2xC80FUU9zmyvaZZr3MZCqNa3Vd/5kB7SrCAkygty1kR67JI
 JysFMrrz
 rJwhfOjlZAxUKFknn40cvdkaBZgjV76AuIXuLQl2ppTiRMqT70a7mBAqoqZODXKmvkT9o+dFCn2ym0DmlwZJdlYcX96WEzO6AbBuFbOlwlPoOCEK0pnG+uhBW3Y/ZpDgDr7+gYgIK8Z5z/UN4m5/cTJN7VNh24n3zlQz3zuerrJa5AcVX5uBBh0N6gVB7+ohxAAaCySx3W99n29fHwbwumxgaQ0PAoNYAUdxOEcY9gR+TGHXj0jm3le8hxJ+h8bpTggYTkS1wswc2GKRCyVgdAWIgVnnDTHE9ZpBy/07zbPUbkfUguwIukcKjKknfL6SNIXjGDh6wM8op7UWctsfNynNRDkz4mUEMJZzsc+KSJu03DK3e4ql0iPTIXN756jQJKTCf0Gynk1ej8lhGQ8bypIV8Wpeq6Z0YubRf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/3/20 7:30, Lisa Wang wrote:
> The .error_remove_folio a_ops is used by different filesystems to handle
> folio truncation upon discovery of a memory failure in the memory
> associated with the given folio.
> 
> Currently, MF_DELAYED is treated as an error, causing "Failed to punch
> page" to be written to the console. MF_DELAYED is then relayed to the
> caller of truncate_error_folio() as MF_FAILED. This further causes
> memory_failure() to return -EBUSY, which then always causes a SIGBUS.
> 
> This is also implies that regardless of whether the thread's memory
> corruption kill policy is PR_MCE_KILL_EARLY or PR_MCE_KILL_LATE, a
> memory failure with MF_DELAYED will always cause a SIGBUS.
> 
> Update truncate_error_folio() to return MF_DELAYED to the caller if the
> .error_remove_folio() callback reports MF_DELAYED.
> 
> Signed-off-by: Lisa Wang <wyihan@google.com>
> ---
>  mm/memory-failure.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 4f143334d5a1..57f7762e7418 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -941,6 +941,8 @@ static int truncate_error_folio(struct folio *folio, unsigned long pfn,
>  	if (mapping->a_ops->error_remove_folio) {
>  		int err = mapping->a_ops->error_remove_folio(mapping, folio);
>  
> +		if (err == MF_DELAYED)
> +			return err;

Will it be better to add a pr_info here to provide some information for users?

Thanks.
.

