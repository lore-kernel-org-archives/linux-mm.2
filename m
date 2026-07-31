Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37B5EC5516D
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 17:49:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C6426B00AA; Fri, 31 Jul 2026 13:49:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 477346B00AB; Fri, 31 Jul 2026 13:49:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3666A6B00AC; Fri, 31 Jul 2026 13:49:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F00BD6B00AA
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 13:49:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 75775A147C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:49:35 +0000 (UTC)
X-FDA: 85049809110.13.1DBCA7F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id CAE9640004
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:49:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JYtB/zJE";
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785520173;
	b=Dxc8uzOwV4a+pMae9p9bbYZyxcxIIM03363iwOLJL3LmZ5Qot1hsn+WZiW4InrKZEUFCvB
	dpCik9BWVl8/CpsbYwkpcAg/F8gOCwZTzGBBcEhnD+kN5B6YzEgLQLDqQzBk1TvT5ZEy67
	BGbhOk2vL4eY9WW53abnvfqa3oK1Brc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JYtB/zJE";
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785520173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/+IlztmyqYuuXlGVT0cph9tanuKKLkq7z25QvgzYv6g=;
	b=wlzBOLPFrZX1XFs003VSfii8fUKWvKQgiDQ/1IshZXgbWBK9xsr4ErVK+VZmGOtdCiyr4f
	ehT6RLZpi0bkCaBWMQTkm2vKk+KLWupUpUFxlwFkESZnkSO2f+zryAS/deQV+biv4deJZu
	dSDjquV+EVZwVmTqXGTDxLTgChZNRA8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 894B6600C3;
	Fri, 31 Jul 2026 17:49:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30A01F00AC4;
	Fri, 31 Jul 2026 17:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785520172;
	bh=/+IlztmyqYuuXlGVT0cph9tanuKKLkq7z25QvgzYv6g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=JYtB/zJEZ0LkWBkIp7+O/oltIUsdXqYZq0qhsQUFYpPDn/qFOCinYN9gucrzMUyl8
	 tJd4nZ5wkcviTVyevyDvtTy4n3fp7v7omMHe53yF1q7tAonA78OLe0XskXfmrVb9Tm
	 tkd65uNjWxX8hayREMZ/2mWr0WdmsUvEwNhgXe5U5KL85WIsWGnoE9wM6k0bBaVbU+
	 OnuwKMMxSQhvUDP+9bdEwJMA/ba5xoLaG28zpQ+l7L4mnJMGrfTxJMoYIbtahMYMoY
	 +gFwy5k2OxVm6YAef1tm0l2LR4AZAeYwnXolbHiAxE9Foy/lQKx8Vmywv/9fLDYM/5
	 PghZrsHzacl9Q==
From: Pratyush Yadav <pratyush@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  David Hildenbrand
 <david@kernel.org>,  Lorenzo Stoakes <ljs@kernel.org>,  "Liam R. Howlett"
 <liam@infradead.org>,  Vlastimil Babka <vbabka@kernel.org>,  Mike Rapoport
 <rppt@kernel.org>,  Suren Baghdasaryan <surenb@google.com>,  Michal Hocko
 <mhocko@suse.com>,  Baoquan He <baoquan.he@linux.dev>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Pratyush Yadav <pratyush@kernel.org>,
  Miaohe Lin <linmiaohe@huawei.com>,  Naoya Horiguchi
 <nao.horiguchi@gmail.com>,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  kexec@lists.infradead.org,
  rmikey@meta.com,  riel@surriel.com,  kernel-team@meta.com,  Kiryl
 Shutsemau <kas@kernel.org>
Subject: Re: [PATCH v2] kexec: keep the next kernel off hardware-poisoned pages
In-Reply-To: <20260730-kexec_posioned-v2-1-f92d18551f64@debian.org> (Breno
	Leitao's message of "Thu, 30 Jul 2026 08:55:50 -0700")
References: <20260730-kexec_posioned-v2-1-f92d18551f64@debian.org>
Date: Fri, 31 Jul 2026 19:49:27 +0200
Message-ID: <2vxzecgj6od4.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CAE9640004
X-Stat-Signature: 1yb74xwc5irirnxss9d5k3mj9qzh64bh
X-Rspam-User: 
X-HE-Tag: 1785520173-701400
X-HE-Meta: U2FsdGVkX186RQKhMj9tcwFY73s7DvRUTxJL/kQWLTvOvzzMJ3IOyJPQNEHMWJnZoyiniPebFjFZ89KGLQBBBOsT3mP6mAn0Af+8+SNTJLI+p8UMHMVTBV5eNFGlrAHsdy+hCet3ckdTAB/w1rbfs7pkjvoYv0O4dExSDojBMfskaJUhZMRfn+ivviLa7p8R6Ggkmfs8W5DThYkm3ha9ylFzF8TQmRXj5XyUBs924kXdvSAOUeRNz4iNZeKHBlkkdS/VVrFf/O6eL0N29cC6ksySVA5voNNAa9YF2mlT+jU7/ZxxkTeDvkdQxOlk/XXMZGC3MIOMhRmi9KFT3X+FWUK0ocWHRU0Ht8ysO9jLQXOEzBxK5mocsDEQkGHZ9FNZyRWzcUIcjacYv4KgyJzuxfoUfYK5sewvUegG8eDcxABLQtJCdMg9jcXmwRu7Z98lMkUwxazCgYqx1cRO19IjP7PLd43idin+iwLwqwQZ4VQ3zPGXyTIY5iHGLf+TbFo97jGOP7hWBFfg/hbufp4aWAz5snOMEaeUoaDlUXGh/SddmiNXG7LUQw8EMcruywJSpkOWvUFo0f4D+yaOSPkeuLYdRXWdyN6qwr3XixmBWy9gBOPzrm2Q66V7IfQi2x2WxDeQUJvfL6K5AMtbCGLINChLf8s0hE1hW93PksF8I9M9lK35wvg8u5rnWLhPzMlzJlcOxofEQppjziMn3dqlWmmpOcQ3ovH9mDpJGMB/x9qBj8X5gJLl0u91vvAqjen9ovKEZjndggtg6/ws31o2rHe1Vnru/Mhej0goO5V61fkgeLVLITiolG2L4vWUqhw0aGLrYbTY5/Ny5Xq4TB6ZSwx9Kr/K9jCw2ortfvzhXhsOL8KOlczbY28FF9ndkPEkh7WKTwipJMng5l72vBh/rFNHiJxBPuFncKxCnBhSA+h+jLaWAODPMiJQ+MwLW229yI4Or4L/mwRifsHMR4s
 mKHNpagt
 pdAc1sEkU0HGEGdNqbnKwKLF3mnkHUeqc6S9z9qDN5prGpOOvZPWOHxMqMVq/Aj58hV3TlSsosEkxJBiYVtD3ONK8Gl05CsdzGkpAfPABKAxfV0SLzgEX3y7k6MMVFGM0vRKRTMA8fS9dDozUPfxPWTm9uB6MjnsZl5w1k9Bo39LCg7V2bLdJVwWxeigN3AR4VucMb5hsDLHx2I+ajJw0NycvxVoGMTA4GzeTs7j+abMn4jFK908tyHgfWy+IaGpVJ02wqthbdBlnIAPhlBp7xR2kJNeMDRLycP+kwnO8CxRFytPldip6dt7kx/tSsrstTgdSJZmkONB2g0YvKRijzwUE7iBm6vo0OlGgotWUNKF0BDe0i0dwm/E+GVHfKWUYNf+EdCwJoriLK/6q8F+uRC2rv//wRSsbtkrg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30 2026, Breno Leitao wrote:

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
> Changes in v2:
> - EDITME: describe what is new in this series revision.
> - EDITME: use bulletpoints and terse descriptions.
> - Link to v1: https://patch.msgid.link/20260728-kexec_posioned-v1-1-160c81d180fe@debian.org
> ---
>  include/linux/mm.h  |  8 ++++++++
>  kernel/kexec_core.c | 10 ++++++++++
>  kernel/kexec_file.c | 19 +++++++++++++++++++
>  mm/memory-failure.c | 28 ++++++++++++++++++++++++++++
>  4 files changed, 65 insertions(+)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 7fabe6c66b4b7..48cad9a519d08 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -5192,6 +5192,8 @@ extern const struct attribute_group memory_failure_attr_group;
>  extern void memory_failure_queue(unsigned long pfn, int flags);
>  void num_poisoned_pages_inc(unsigned long pfn);
>  void num_poisoned_pages_sub(unsigned long pfn, long i);
> +bool range_contains_hwpoison(phys_addr_t start, unsigned long size,
> +			     phys_addr_t *poison);
>  #else
>  static inline void memory_failure_queue(unsigned long pfn, int flags)
>  {
> @@ -5204,6 +5206,12 @@ static inline void num_poisoned_pages_inc(unsigned long pfn)
>  static inline void num_poisoned_pages_sub(unsigned long pfn, long i)
>  {
>  }
> +
> +static inline bool range_contains_hwpoison(phys_addr_t start, unsigned long size,
> +					   phys_addr_t *poison)
> +{
> +	return false;
> +}
>  #endif
>  
>  #if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_MEMORY_HOTPLUG)
> diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
> index dc770b9a6d053..9f6ed3c04299b 100644
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
> +					    image->segment[i].memsz, NULL))
> +			return -EADDRNOTAVAIL;
> +	}
> +
>  	/*
>  	 * The destination addresses are searched from system RAM rather than
>  	 * being allocated from the buddy allocator, so they are not guaranteed
> diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
> index 59fb9d71e9d86..95cc981a557be 100644
> --- a/kernel/kexec_file.c
> +++ b/kernel/kexec_file.c
> @@ -475,6 +475,7 @@ static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
>  {
>  	struct kimage *image = kbuf->image;
>  	unsigned long temp_start, temp_end;
> +	phys_addr_t poisoned_addr;
>  
>  	temp_end = min(end, kbuf->buf_max);
>  	temp_start = temp_end - kbuf->memsz + 1;
> @@ -504,6 +505,14 @@ static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
>  			continue;
>  		}
>  
> +		if (range_contains_hwpoison(temp_start, temp_end - temp_start + 1,
> +					    &poisoned_addr)) {
> +			if (poisoned_addr < kbuf->memsz)
> +				return 0;
> +			temp_start = poisoned_addr - kbuf->memsz;
> +			continue;
> +		}
> +
>  		/* We found a suitable memory range */
>  		break;
>  	} while (1);
> @@ -520,6 +529,7 @@ static int locate_mem_hole_bottom_up(unsigned long start, unsigned long end,
>  {
>  	struct kimage *image = kbuf->image;
>  	unsigned long temp_start, temp_end;
> +	phys_addr_t poisoned_addr;
>  
>  	temp_start = max(start, kbuf->buf_min);
>  
> @@ -546,6 +556,15 @@ static int locate_mem_hole_bottom_up(unsigned long start, unsigned long end,
>  			continue;
>  		}
>  
> +		/*
> +		 * Avoid placing the next kernel on hardware-poisoned memory.
> +		 */
> +		if (range_contains_hwpoison(temp_start, temp_end - temp_start + 1,
> +					    &poisoned_addr)) {
> +			temp_start = poisoned_addr + PAGE_SIZE;
> +			continue;
> +		}
> +
>  		/* We found a suitable memory range */
>  		break;
>  	} while (1);
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index a8b03e2920ba8..04a1883d51fda 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -96,6 +96,34 @@ void num_poisoned_pages_sub(unsigned long pfn, long i)
>  		memblk_nr_poison_sub(pfn, i);
>  }
>  
> +/*
> + * Return true if any online page in [start, start + size) is hardware
> + * poisoned.  On a hit, when @poison is not NULL, @poison is set to the
> + * address of the first poisoned page, which is ugly, but I cannot only

Won't the last page be better? If two poisoned pages land in the range,
you'd like to search past the last one.

> + * return phys_addr_t, thus this "extra" parameter, instead of returning
> + * the hit.
> + */
> +bool range_contains_hwpoison(phys_addr_t start, unsigned long size,
> +			     phys_addr_t *poison)

Perhaps

    phys_addr_t range_last_hwpoison(phys_addr_t start, unsigned long size)  ?

And if no poisoned page lands here then a default of 0 or ~0UL?

> +{
> +	unsigned long pfn, end_pfn;
> +
> +	if (!size || !atomic_long_read(&num_poisoned_pages))
> +		return false;
> +
> +	end_pfn = PHYS_PFN(start + size - 1);
> +	for (pfn = PHYS_PFN(start); pfn <= end_pfn; pfn++) {
> +		struct page *page = pfn_to_online_page(pfn);
> +
> +		if (page && PageHWPoison(page)) {
> +			if (poison)
> +				*poison = PFN_PHYS(pfn);
> +			return true;
> +		}
> +	}
> +	return false;
> +}
> +
>  /**
>   * MF_ATTR_RO - Create sysfs entry for each memory failure statistics.
>   * @_name: name of the file in the per NUMA sysfs directory.
>
> ---
> base-commit: c5e32e86ca02b003f86e095d379b38148999293d
> change-id: 20260727-kexec_posioned-72bb0a4143a0
>
> Best regards,
> --  
>
> Breno Leitao <leitao@debian.org>
>

-- 
Regards,
Pratyush Yadav

