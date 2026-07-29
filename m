Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCBD3C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:19:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C424C6B00E9; Wed, 29 Jul 2026 10:19:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF1746B00EB; Wed, 29 Jul 2026 10:19:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABA726B00EC; Wed, 29 Jul 2026 10:19:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 81C7E6B00E9
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:19:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ADA8EA1A76
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:33:29 +0000 (UTC)
X-FDA: 85041301338.14.1C644E6
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf23.hostedemail.com (Postfix) with ESMTP id 22D4F14000B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:33:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=0cbv10gE;
	spf=pass (imf23.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785317607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l28RUUIO0sTYXTUgslp8RhU5Xau1YXhJe+DpH+cC4Js=;
	b=1YrQZKlfNClFbK+glO5MAV49/cv+r73Fme7tybuF783WRIq0VaYxUXhM72Y39C9vfyoCVK
	PBBL8it8+rBlaLKVJMwMkl5l9gDCRj/mFhYjCcpCajFuLPRI3/KfKESQ2hxPMwsitmtIUh
	+ZhxOX4y7HL7ArVkk4USkDvrEK3Oen0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785317607;
	b=RHSMDHMwdakNtpX5l3Rt0PeMlZ+LRFk6FrDc5MysSxgNPJ8OLEFPzDHpTlohyaoBQcKuq/
	8+dTip48Ea4bT8CrOXiIUSdZgTCgghLylv78hs8MDq3hf8nVX1w59gFKMTjBGgFsJPH3Pv
	bQcPmn8WWa3//5v0PFv79+m79Y54YNI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=0cbv10gE;
	spf=pass (imf23.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=l28RUUIO0sTYXTUgslp8RhU5Xau1YXhJe+DpH+cC4Js=;
	b=0cbv10gEwX5uu9GIcx/ZyCSFDsAMaWqXcnMDdrzJ6IyLWtJojWvfk8o1RVjTRNKzAwe3xAGcb
	HchCKLYBh9BmJo2N85ZSseW5l5z3Y/n/vzf3322ZrFh4b+N/3rS65VcHVJTLTWLty1vMUH84yjK
	1I7foOTOqYlmbZv6hROzRnE=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4h96Mr4BNtzLlXX;
	Wed, 29 Jul 2026 17:23:52 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 9365B40572;
	Wed, 29 Jul 2026 17:33:19 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 29 Jul 2026 17:33:19 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 29 Jul 2026 17:33:18 +0800
Subject: Re: [PATCH] kexec: keep the next kernel off hardware-poisoned pages
To: Breno Leitao <leitao@debian.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<kexec@lists.infradead.org>, <rmikey@meta.com>, <riel@surriel.com>,
	<kernel-team@meta.com>, Kiryl Shutsemau <kas@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Baoquan He
	<baoquan.he@linux.dev>, Pasha Tatashin <pasha.tatashin@soleen.com>, "Pratyush
 Yadav" <pratyush@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>
References: <20260728-kexec_posioned-v1-1-160c81d180fe@debian.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <16c18549-c9a1-ba55-91b8-52d9368ebbc0@huawei.com>
Date: Wed, 29 Jul 2026 17:33:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260728-kexec_posioned-v1-1-160c81d180fe@debian.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 22D4F14000B
X-Stat-Signature: 1jrqeokhf8xiajebiqhkuizpz4z3c7wg
X-HE-Tag: 1785317605-13682
X-HE-Meta: U2FsdGVkX18H4eE3r52cSnPL+MbqSmfBMTJ/iFE2ExEojKJw1lNee5LFpA96pmWthO/s5ecyJBoiU+qzyTm3PsLxY5g/9NijlKCb338DAydOmCFOZU1MciUUEEPj2tvRT1oCl/SykHFdj2Q8jmeP6wpqhGFOk4Rd4OxwUb5u3SqXPnaqbAB0/24MA5eHtxw/DkxM56Ij0yXFBRIfpKQkI6Gvuo1cWvMWkMhVlWufgflYUc6CchJFylVHn6XgKqF/dQJ27aJDejzK8e8V9fb2zfW7/vOaJEmyL049QKS1Z3GpRRKDoPnp0iIBQxsXgBxBO8bn94c0w1GKspDRAHOPpPszpZhCJArVPeNsTRKkJpzMQqLLf04LeAJh9o8z2oM6Yd4++Axg/xg+mZEZxPCikDsPgSpAmY5LaPHoaPd+H7vWADb3sdC95WnsPwW0OrF9vr492wef3VmodAlsTzGUIJmFggrLvAfx2iH2Q162dd3VBiwgTIKjCU5Bg9pjT4ecoAu5Bbs3Ll64AyZdfA81TvppFnTYTkC5BZPxTn2UBFV7YIKBmf7diBtkWKhngToSeFehxMLlh5H3H2/NLf3P53Hc7Dmll+RCKDJuy+RGDv+pz4rXNGftwgyXP66a1gjOvByhPGlu9cma57myoyDt7ut5ilK/2K/8JB6T9iIh3pq/F4raKuSgizJa+wZkKb+ZXkcAOU/4xnQg7ICaESb3ciSZtzZZAvbSUH2wKHbY+85RSpABaF6jFOSIkyyupWHRpGl1bdkqbEZC3eRIsEzXVIwbdjQoRhLNJpGAR0Z8gkvT5FPTlfBNCmBmKtZlTVJHUei13Lio6zF8IqTXTWqto7GjL7ehuz1mlNEDLGgk/jMKU99qiyvYdaQR7KlBE7PqpO5kbgnYn1G81rJin0Xb50vNvuUK0W57JCf90bVEj96h3cdtEG+3HAS3+GfjXZ5mFgphfMkvno8Z9JAfZSN
 DgoKUdrM
 ntH5/S9y+rutQsruqxKM8qAQBpRmMBCPfaJw0by2tWaplqzBaYJ6+IhtTOFmBy8GPI/MbhQt2eSftaXIwX/rmisv/FsFqSLHhrdFmSKvNyeO4k9BjvRR9t4HH2VyxJIRsgSi/VnTAfms+OfKaxjA+soonNeFzeEbyODRs014k7+VOi8PWy8APHuL8aPsWr2WYDnxA49qdd7cfVeoXwpPvPcI4IQcJ0X2Sj9kgIRxBmVrbrn7zc660Atkdgy4bHef78EarMTA30+I2Rq3532tJeTrGiPefT+OfkoWgPI3i2AaC5001MaTPaMPzD3cHlYqyJahuckC+oQBB/dHj3J5R1wNfHAGJlYByrW/aMB5yIdaWa6F6lRV36fepfv9Pj7SqjtA1g7i4wE74gg4X5IYYKDcb1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/7/29 0:22, Breno Leitao wrote:
> Memory failures (such as unrecoverable ECCs errors) are getting more and
> more common. The kernel knows how to handle it while running, marking it
> as poisoned (and SIGBUS user tasks).
> 
> Poisoned memory is removed from the buddy allocator, but, not from
> other places. A current problem is that kexec will load new kernel
> on top of a bad/poisoned memory, which is undesirable.
> 
> If the next kernel's image, initrd or purgatory lands on poisoned frame,
> the relocation copy writes to the bad memory and the machine checks
> during the kexec.
> 
> Skip hardware-poisoned frames when placing segments: check them in the
> kexec_file hole finder so it lays the next kernel down on good memory,
> and reject a poisoned destination in sanity_check_segment_list() for
> the kexec_load path, which cannot relocate.
> 
> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  include/linux/mm.h  |  6 ++++++
>  kernel/kexec_core.c | 10 ++++++++++
>  kernel/kexec_file.c | 14 ++++++++++++++
>  mm/memory-failure.c | 18 ++++++++++++++++++
>  4 files changed, 48 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 7fabe6c66b4b7..a89108bcc3f90 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -5192,6 +5192,7 @@ extern const struct attribute_group memory_failure_attr_group;
>  extern void memory_failure_queue(unsigned long pfn, int flags);
>  void num_poisoned_pages_inc(unsigned long pfn);
>  void num_poisoned_pages_sub(unsigned long pfn, long i);
> +bool range_contains_hwpoison(phys_addr_t start, unsigned long size);
>  #else
>  static inline void memory_failure_queue(unsigned long pfn, int flags)
>  {
> @@ -5204,6 +5205,11 @@ static inline void num_poisoned_pages_inc(unsigned long pfn)
>  static inline void num_poisoned_pages_sub(unsigned long pfn, long i)
>  {
>  }
> +
> +static inline bool range_contains_hwpoison(phys_addr_t start, unsigned long size)
> +{
> +	return false;
> +}
>  #endif
>  
>  #if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_MEMORY_HOTPLUG)
> diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
> index dc770b9a6d053..18793f925835f 100644
> --- a/kernel/kexec_core.c
> +++ b/kernel/kexec_core.c
> @@ -212,6 +212,16 @@ int sanity_check_segment_list(struct kimage *image)
>  	}
>  #endif
>  
> +	/*
> +	 * Reject destinations that land on hardware-poisoned memory: the
> +	 * relocation copy would machine-check on the bad frame.
> +	 */
> +	for (i = 0; i < nr_segments; i++) {
> +		if (range_contains_hwpoison(image->segment[i].mem,
> +					    image->segment[i].memsz))
> +			return -EADDRNOTAVAIL;
> +	}
> +
>  	/*
>  	 * The destination addresses are searched from system RAM rather than
>  	 * being allocated from the buddy allocator, so they are not guaranteed
> diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
> index 59fb9d71e9d86..cd77350f12f85 100644
> --- a/kernel/kexec_file.c
> +++ b/kernel/kexec_file.c
> @@ -504,6 +504,13 @@ static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
>  			continue;
>  		}
>  
> +		/* Avoid placing the next kernel on hardware-poisoned memory */
> +		if (range_contains_hwpoison(temp_start,
> +					    temp_end - temp_start + 1)) {
> +			temp_start = temp_start - PAGE_SIZE;
> +			continue;
> +		}
> +
>  		/* We found a suitable memory range */
>  		break;
>  	} while (1);
> @@ -546,6 +553,13 @@ static int locate_mem_hole_bottom_up(unsigned long start, unsigned long end,
>  			continue;
>  		}
>  
> +		/* Avoid placing the next kernel on hardware-poisoned memory */
> +		if (range_contains_hwpoison(temp_start,
> +					    temp_end - temp_start + 1)) {
> +			temp_start = temp_start + PAGE_SIZE;
> +			continue;
> +		}
> +
>  		/* We found a suitable memory range */
>  		break;
>  	} while (1);
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index a8b03e2920ba8..032bb23db7566 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -96,6 +96,24 @@ void num_poisoned_pages_sub(unsigned long pfn, long i)
>  		memblk_nr_poison_sub(pfn, i);
>  }
>  
> +/*
> + * Check if any page in [start, start + size) has hardware-poisoned segments
> + */
> +bool range_contains_hwpoison(phys_addr_t start, unsigned long size)
> +{
> +	unsigned long pfn, end_pfn;
> +
> +	if (!size || !atomic_long_read(&num_poisoned_pages))
> +		return false;
> +
> +	end_pfn = PHYS_PFN(start + size - 1);
> +	for (pfn = PHYS_PFN(start); pfn <= end_pfn; pfn++) {
> +		if (pfn_valid(pfn) && PageHWPoison(pfn_to_page(pfn)))

Should we use pfn_to_online_page here? I doubt we might meet the same problem
in [1] if pfn_to_page is used here.

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=d613f53c83ec47089c4e25859d5e8e0359f6f8da

Thanks.
.



