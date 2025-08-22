Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC458CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 08:56:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3004C8E0083; Fri, 22 Aug 2025 04:56:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B1B78E0056; Fri, 22 Aug 2025 04:56:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C6E88E0083; Fri, 22 Aug 2025 04:56:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 09F4F8E0056
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 04:56:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7784C1606CD
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:56:20 +0000 (UTC)
X-FDA: 83803786920.21.CC35055
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf17.hostedemail.com (Postfix) with ESMTP id 90E8840009
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:56:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=VTdciTEk;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755852978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=37BnT9v6DlKGFDynxeqJe+bPT06bE+On28yLwgCqtM0=;
	b=SBKuWyzRyfkXd78MLcH+LS706q2yJkYq4+u/fJ0T9y0RR2Zs3IC8WdkEu5e51ZVVNl7krL
	Tthg233qqy1nrLGdTu1ESBwz/PAWS1qjvVwHmfo/gIh2SX7ffk3qGnwQPJSVEa8dYv58Qe
	/RIA4e4Lxl2TiakHseA9+VuVOiSgqzM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=VTdciTEk;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755852978; a=rsa-sha256;
	cv=none;
	b=R3ccRawMncT5Yi3Sd3C9UPmjk47K0jbO5mKlC+xb5XGPbMa4nwJN3UmrBT61uPtCQ3noSQ
	zl5fTWByF8+8CeQHDwHrfMJQGLVr8Hg0yy4Qgyp+Rirqa6H3JLCvjZDnCJXKfh4kX8Izpy
	IfWJoOGncl7QFea50L+zfxlO+kUeuvU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755852972; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=37BnT9v6DlKGFDynxeqJe+bPT06bE+On28yLwgCqtM0=;
	b=VTdciTEkG3C+PqH1SzPF70dol/tZY8iQnrkmPoPV35HpDCKtmOEtnJDuNlJrBY9iRROBo92br2Oq51ojdCmppD2eXayjLDcU8htHVFF0BbAFfYHUQUJjAw6Q/HwYXR4wMGQB8U27qk+2ArjdWfWohEyXKYIpzNdfv6XxyfN4DDI=
Received: from 30.74.144.125(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WmJ6Sk9_1755852970 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 22 Aug 2025 16:56:11 +0800
Message-ID: <c0f1b65d-be38-407c-b9c2-87b24f830acc@linux.alibaba.com>
Date: Fri, 22 Aug 2025 16:56:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: use list_xxx() helper to improve
 readability
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org
Cc: linux-mm@kvack.org
References: <20250822025732.9025-1-richard.weiyang@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250822025732.9025-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hiat5aku8zb5bsrx95gcchzyxdbq3qaf
X-Rspam-User: 
X-Rspamd-Queue-Id: 90E8840009
X-Rspamd-Server: rspam01
X-HE-Tag: 1755852976-422918
X-HE-Meta: U2FsdGVkX18Q+A/X/9yNrE/ie6u6hMH2YQFM+HzssbAYDaLrdIkbnQk6SmpDAL9WB5AaK68Ck+4srQ3/8aa466NTJqlX5REGUM+hOKWHHC04GM0zt4agC+XX8dnCUW6NxV9hRvMzS9bj6P5Fxtjz5uhNyOcc+XmP2DtIaFC2maCD3865nR04G865TmfvdAqJKYQ9YADnaz9eG1K2ICHI9Fl2vYXG4jUFXKjsOc4QyavjaFrCG9JOUsoAtikerIOTy3h+na82HLN0uprV5Gtp0HDRA+XSAjZNIz10oI8O3AJAjU+3oW3b8yUxrwi6lwJ4AeFQYhRrv/in0YWojI2S/q2bHOSBqJToza7EJcR9Frvpo1SngILLwQR6RiIXxmj59jaDtU9iT+ZsTtTemkhWCaW5m0yWs1AGbAsZygJSfPmTAteH2g0n5Am0k3215IsBpUkCuutveBB0Jck400Gl5wgQaRGcF6KpRVsqfsXsHJTTGyLWnyHCxcRNnJlrb0lr60eSi4DbugSyZ7HTQmmzyEsBlWCmWZuGTiLLU8kCypI8mP4yfkrLc2gJECWtHAvGsANZArMOSgyX4mjjsk7WZzXdNV9mGvXJc6vj6IewidmcLXQxp/zj1KoyzJDzt8efIKLl1rRDfqosZc1EIxn5F2QWL3jT5pILhpXYW7EnRKLEIzJvvMmJBsUiny3PRJ64vFUZOGIp1GWZLeTFQaLl+cQfb7T8fFlsrAbLsw7Hf/iL2zG61zKeabrYF9xx95R+Yw1jqb121ppYJLob0PJWADIavc9PUzaS7Sk0p3slS7RvwCCDUQIksVxuOzpmTl93EfLXrgvEngyDD6CO9vNtwSNr2BHo84GDm54ZB0D4FIeMG5Yy4XfdlfH8RN4fGtZAo8+Jx4hIK6cJuHacboxWcl8E4zpfPIZZrC/Vd7bZ/TvIqVtn/EVPwQiPtHYd1S7qPONDqUWhPTd2tCQ9pkf
 JgIaysKy
 5vgTeIJl+RWOd1YCZJk7ugs8nfumLji3oIL5C5EO/TrU6k8tZqaDSTCHpzMElQsPNGFfgDtgzrKOujDj7GBzcRRGEtDSiwgVNciZ1KtPS3rVT72qBKZSmRDdts6Pv1Ku+1wvfyX+b/xQeGXmqg1vxDDR1SzMd9/rmnpdQF4dQm4ZOob19BCLVT9C4pM/FP6cgFzo8XeYyEby2msrGOy2r92SiPvVE/vVBf5/s+EAeP3UmyyM/KCBsdN8iL6YIXv8Y29yUrWmXm+elzkx0V5tDMcUEe9kJRdYs9nAOsmlq0+VXlXFuX2kpFVTSxbESC5J9SJXosr5DHhMqd6cWMV2jCjBE2svvBA99PJDzinOVSZNMzcBU8uLnnZrd0ECsoHWYMXO5kg9VONoaAmyZHlBw04JoR97Szbl/AQfLKxnt1Iq4+E7iRNnVGDCfP/tFsrLZSAWkn93kah1lMGQH9ig72hN52Bi96ef+aMn/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/22 10:57, Wei Yang wrote:
> In general, khugepaged_scan_mm_slot() iterates khugepaged_scan.mm_head list
> to get a mm_struct for collapse memory.
> 
> Use list_xxx() helper would be more obvious to the list iteration
> operation.
> 
> No functional change.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

>   mm/khugepaged.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index d3d4f116e14b..24e18a7f8a93 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2402,7 +2402,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>   		mm_slot = khugepaged_scan.mm_slot;
>   		slot = &mm_slot->slot;
>   	} else {
> -		slot = list_entry(khugepaged_scan.mm_head.next,
> +		slot = list_first_entry(&khugepaged_scan.mm_head,
>   				     struct mm_slot, mm_node);
>   		mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
>   		khugepaged_scan.address = 0;
> @@ -2515,9 +2515,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>   		 * khugepaged runs here, khugepaged_exit will find
>   		 * mm_slot not pointing to the exiting mm.
>   		 */
> -		if (slot->mm_node.next != &khugepaged_scan.mm_head) {
> -			slot = list_entry(slot->mm_node.next,
> -					  struct mm_slot, mm_node);
> +		if (!list_is_last(&slot->mm_node, &khugepaged_scan.mm_head)) {
> +			slot = list_next_entry(slot, mm_node);
>   			khugepaged_scan.mm_slot =
>   				mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
>   			khugepaged_scan.address = 0;


