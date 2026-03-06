Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03270F51404
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 06:14:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CF906B0005; Fri,  6 Mar 2026 01:14:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 286CF6B0089; Fri,  6 Mar 2026 01:14:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 185DD6B008A; Fri,  6 Mar 2026 01:14:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 08CDB6B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 01:14:41 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5D25A1C461
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:14:40 +0000 (UTC)
X-FDA: 84514624320.01.3B81778
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6F9232000B
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:14:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=QNFDz2Gh;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772777678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zmRPAF62Mchrk/WjhbPTvXdOO9DYmUP5hbIL4elCOy8=;
	b=Hu9ybs9mg1eZsyARhBe4x0NgKJBCebgjm918I0v7XASD5NQQFmtSElZtUydP8s/euV5ZQo
	yGv3kGCTRwHP5rcmfJMnlrsJkDx69mvvPlisWNCK0L0VLGXcKOu2JduaUIAWNPc2kBeHsG
	a9RZkmPRmrAD1k6JQXdy3eyvE83Dvc8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772777678; a=rsa-sha256;
	cv=none;
	b=qAFOWYlG6cMeTv/Sev0eyc6zOlVyJ6UIgKZE8Nk9fsoGGD3yeNjAfWwOjecdyiL4vn/SjT
	EGHEG7H2GNoLO2XSSkOLQNIYS8V7mY5ByQBIg7V3f90X8Sdxt7I5Y8ieOO0lRhPOa+Bx6w
	r6rSq/bkzduT1ogoTW2yK1+/FEFZbGQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=QNFDz2Gh;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772777673; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=zmRPAF62Mchrk/WjhbPTvXdOO9DYmUP5hbIL4elCOy8=;
	b=QNFDz2GhrUxr720v7DzkJd+r9w06ajnsDc81l48FvvSKxHUKehZY+SSmMraS8WxUiu1ad0MPx/xtZnbkJVih1c6Sd2fdENFMtCY9b9WZNveTR+eZmekNeCUKr7VD7dtzuq0Rs3V1tx8NKbkF5B54nbOQXNA/8P9Eq3v4xr7D+Qg=
Received: from 30.74.144.109(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X-MLeMQ_1772777671 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Mar 2026 14:14:32 +0800
Message-ID: <3d3ee8ee-2aa1-4351-9965-c9ed5b858c96@linux.alibaba.com>
Date: Fri, 6 Mar 2026 14:14:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] mm: thp: reduce unnecessary
 start_stop_khugepaged() calls
To: Breno Leitao <leitao@debian.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, usamaarif642@gmail.com,
 kas@kernel.org, kernel-team@meta.com,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
References: <20260305-thp_logs-v2-0-96b3ad795894@debian.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260305-thp_logs-v2-0-96b3ad795894@debian.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6F9232000B
X-Stat-Signature: wyiyk4fmdn9sjnbh8snhhqrzwby38yer
X-HE-Tag: 1772777677-638468
X-HE-Meta: U2FsdGVkX19lp77NYqxVI/bvqtGAW0u5HNtP32JYXHbKEUJxxkGCmRojvxgv/USFH7TAECFZcWm1Piq7T+GWlE2qC1QZXe9biEmCJAMqIO3Aj3CPHUuUJN0xQVwT1r87FaGO+5HJymwdiagno9URD1jR/wuZw8P86WWsWFm8FYw4Im+5D8Iu1FV8ZahlD4hgiL2jMaZZqgPLfkCsd6qRG2cGjiWu2u5KnhmvdNVhz5r5YPVdGT6t1c8R9YqoQgEUkbT9CMHLFrwj9GSN4nxZcpsUnvR2h7pO7u2wLty6KVAg8TthMCM59cXMIjdhzZDXOgq0He7OiC++3zyCjmeDwi16qGc/8F+E+FkSc7v6A+u4CHUNGr7oppjr1WRIaDIeFgX4y4X2XlgvPwIV8/UZoJ1PRm2KSisI9fMB1enMe42yYSpnCA88Lx8Vrf4Hto4FI+p7uYpKatKYLOzvpDnaQQFGyeid4xR81Sb2+vpbGkOh6aLlzW5m82NgCo0f1JBCED818jcDRYZf6ALDdW7TxhlwCC6/uLABwMScphbuM8WsbKtA9fZ+6JNoKoi4Hb+MiLnibblzPFrVN1IgplMMjSA7WEoUq/5oDqEqqnXbPVoNwBEno7IozlsB48qRwtFYmKoFrd6O74uz+FKO18nMN7uZ/Amw49R5Dx2elcJ0hqe/SFNOA7wlKk594KdzWO0Eq580GKcb+DuhBeVfTEHP/GxmZSpOpbQHe/SONMFO/Aw65cToLewvnIzzVhTzcQjtM+b6DnoANeid0Sp8/72o9wVPv+zcdpTYKlCxCMfnkj66aa0HTrqXhk/c5rvHrKnn5r/Lrnrr9ukBwGikXR7oNUzQwYiVBAyXk5vOEhuJ1/EtvxgyOHgJDkvPuA2rWdIDmy2RfenB5+UYZ5UvnkZA6BqvGG4PCI1emgMnNUAiYwCmnJAH7L2nAlqFvULe5kWrS0SFAzFwMO2OWN9qsj6
 YsojhXVR
 ARULenNPGkUFav1B88XTh3yk51ODQJYqDUorpcoRu2ZL4J9rhZmVOHASlbS6SySJVLBnahdJktA0W/aRc7fnlBowtO0n/DL/2VvcqjaFkN+RN7WpvztZ9o8PpLZVOWtQxkVpDnR69zH3VKq41xLN60B1gmfZstwjEZ6zfAGPqx8WtLQMYgL1UwmsaI0woS+/jvU7v4bckh+qOUNf/kabwNOG09n5KcyPTIBqVNDUX3sUmRHZItbdFjks4O/ogvfhyoQ/Pey0LGlB7E2Wa4kwii6V2CoB7z4laAnQCh5DylDXIBX3vpKyS0f1iUKLszDdF4haTRzEOcIqi9W0Ez+26OIw/5ZeZAEM0CbH6EQGRjlFN+oROlmFvADwTbHfBDh6e40RlaeY0y/LwJ712R4W+Ac3LsyulKfCTD/WBO831JUNvvbrmkcOXafz8nGJ+PuW9xSAA+N8Rrls5kvmxfWGDTwsTBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/5/26 10:04 PM, Breno Leitao wrote:
> Writing to /sys/kernel/mm/transparent_hugepage/enabled causes
> start_stop_khugepaged() called independent of any change.
> start_stop_khugepaged() SPAMs the printk ring buffer overflow with the
> exact same message, even when nothing changes.
> 
> For instance, if you have a custom vm.min_free_kbytes, just touching
> /sys/kernel/mm/transparent_hugepage/enabled causes a printk message.
> Example:
> 
>        # sysctl -w vm.min_free_kbytes=112382
>        # for i in $(seq 100); do echo never > /sys/kernel/mm/transparent_hugepage/enabled ; done
> 
> and you have 100 WARN messages like the following, which is pretty dull:
> 
>        khugepaged: min_free_kbytes is not updated to 112381 because user defined value 112382 is preferred
> 
> A similar message shows up when setting thp to "always":
> 
>        # for i in $(seq 100); do
>        #       echo 1024 > /proc/sys/vm/min_free_kbytes
>        #       echo always > /sys/kernel/mm/transparent_hugepage/enabled
>        # done
> 
> And then, we have 100 messages like:
> 
>        khugepaged: raising min_free_kbytes from 1024 to 67584 to help transparent hugepage allocations
> 
> This is more common when you have a configuration management system that
> writes the THP configuration without an extra read, assuming that
> nothing will happen if there is no change in the configuration, but it
> prints these annoying messages.
> 
> For instance, at Meta's fleet, ~10K servers were producing 3.5M of
> these messages per day.
> 
> Fix this by making the sysfs _store helpers a no-op if there is no state
> change.
> 
> This version is heavily based on Lorezo's suggestion on V1.

Thanks for doing this. And you should also consider the shmem parts: 
shmem_enabled_store() and thpsize_shmem_enabled_store(), both of which 
will also call start_stop_khugepaged().

That means you can also generate lots of messages with the following script.

# for i in $(seq 100); do
#       echo 1024 > /proc/sys/vm/min_free_kbytes
#       echo always > /sys/kernel/mm/transparent_hugepage/shmem_enabled
# done


> ---
> Changes in v2:
> - V2 is heavily based on Lorenzo and Kiryl feedback on v1.
> - Link to v1: https://patch.msgid.link/20260304-thp_logs-v1-0-59038218a253@debian.org
> 
> ---
> Breno Leitao (3):
>        mm: khugepaged: export set_recommended_min_free_kbytes()
>        mm: huge_memory: refactor anon_enabled_store() with change_anon_orders()
>        mm: huge_memory: refactor enabled_store() with change_enabled()
> 
>   include/linux/khugepaged.h |   1 +
>   mm/huge_memory.c           | 135 +++++++++++++++++++++++++++++----------------
>   mm/khugepaged.c            |   2 +-
>   3 files changed, 90 insertions(+), 48 deletions(-)
> ---
> base-commit: 9dd5012f78d699f7a6051583dc53adeb401e28f0
> change-id: 20260303-thp_logs-059d6b80f6d6
> 
> Best regards,
> --
> Breno Leitao <leitao@debian.org>


