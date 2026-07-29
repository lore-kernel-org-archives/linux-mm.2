Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89CEDC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:22:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 370C36B0098; Wed, 29 Jul 2026 10:22:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31F7C6B00A7; Wed, 29 Jul 2026 10:22:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25CDF6B00B8; Wed, 29 Jul 2026 10:22:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EA9BF6B0098
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:22:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 25EADA066A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:57:09 +0000 (UTC)
X-FDA: 85041663378.19.399352A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5F89C40009
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:57:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xmqcde07;
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785326227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3MHqEoaGOKzk9Iff8e6HT/j15eXEiVkvdlAAoZTG4f4=;
	b=8dIzE5vGU30UYu1hbJxXe6iZU+msQQpNHES0r/VunJ6Dex5ODBJvBZ2IDNGGAFBg5xa7Ex
	7h8d75TjLJiKHT2olBdjRPAJYhmJAbn76+XjMhk2idy1tMdUrBu1c8uIJCqQ+c1Z+41Bb2
	MsAfibfnc3cdzfq+dleXWZ3GuMMRD4M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785326227;
	b=FanUT4vE5hQcGug1mPEN127QrmV7Iijs1R1kZjWQ2lz4/2NCl9htPIIBiZLjjaCPPDLzPZ
	IW5Wh86Dv4rP+Y7Evm4K3Gq6kHOdk05lW3x8kj1h7F4X/mEOSoeLzoH2PE3GZBT0Ned8yc
	K0EXTaOjVG2J0Eg4kOArUgyerB8ClUE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xmqcde07;
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 840CC4372C;
	Wed, 29 Jul 2026 11:57:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC831F00A3A;
	Wed, 29 Jul 2026 11:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785326226;
	bh=3MHqEoaGOKzk9Iff8e6HT/j15eXEiVkvdlAAoZTG4f4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Xmqcde07rhKigYnfqfFgM+V+S+G84iFflTUPnnW/QqFBYoRduAW8DmMEfmXZSQykI
	 WnH65KFGJIkuFfiuyYkqXsvQ/hhyodbbvwwu52Ac0ZbYbHT+3ezeuvbHLaplBiVrKv
	 xbPSWI1/IZbgNO0XJVyxyzlsqlAu6a2rBiZCgk2vCIIZssY+eMW2ig08WE5YhIl1A3
	 4VLNqjmQ6Y5LnpCbVSo835Hq7YR9p777fGwgCWi0N1D9w3k2Bumh0cK7VdlN0R/bNj
	 /i7Jqyo0wzTGVFNQdPcjLBIPlsSga7RWsUJf8DyuivF6DX13R9Rr7xUuOZfP1cChW5
	 0MQzYsPyFAIzQ==
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
Subject: Re: [PATCH] kexec: keep the next kernel off hardware-poisoned pages
In-Reply-To: <20260728-kexec_posioned-v1-1-160c81d180fe@debian.org> (Breno
	Leitao's message of "Tue, 28 Jul 2026 09:22:57 -0700")
References: <20260728-kexec_posioned-v1-1-160c81d180fe@debian.org>
Date: Wed, 29 Jul 2026 13:57:01 +0200
Message-ID: <2vxz7bme80vm.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5F89C40009
X-Stat-Signature: 49gf9hmycw4pf16dywie4y8ny9j1hysr
X-Rspam-User: 
X-HE-Tag: 1785326227-324752
X-HE-Meta: U2FsdGVkX19q/jIkdCYqCzXrv0yg0h1NNKBCZnOvAqNwcjHd44+q1+soL006Eyhpnm7QpUQkx5B8f/sJqCp+aI5P0wvlPzp6reKYMk/r3EEtMq+mniAxKPVxlpzt29PIhT18vrQD+I8WOpgg7V3ndixFL9sT6r5VcJwEoiUMc9H/Wj+6ppQKExdNt+fh5i5yGQKj9DeBILX6VNPw0aQMDgCrZFtSR1oL61F6WvxChqIyVtOi/o2UJjKx8FP6qGTt9an9IU7mPrjWRsO8H1TXata9RII9+sUm2f6lDuDeGPh8D+vGYAEwjsJ56KKpWgsapCPOjtEqwEtQpHRBZKLRJDWUhz7Olq3NQ66t9SoeTL4cZjI2dU8JFsdu6eEijY/mleNjW+MZWjV05dmKO6vzXz9n10Sbb8gb6XNSSiJ6CvCIXM1obbxpirE8WWW9kzSUamCgz6SJcQjTCZKq0g6c9DfSmJcloFe9WjTJ6iVCwF4hYnI7yqcdN0EKA4NMNczyqk7+BeVnQi9DOeC/QfZBnZdBbpSSOVQJ+C29HPWYtXPXCQH5Wbsr1a9eqKTK/XPSCGNhPhLw3jkrO4QG2gxihPjjm7B2HpF6+OyjP+A1gNiqUQWCyc2AJyRQlip/qp8GKgdlqqxP6bIo9NTP1x4AAyx8eCEJlNQm0UCnXLSBxjmZTLJXHT/05iv7FJKWxFPF4dVwbCnT24bx3Sk1yzSMz3l3CKUnZiw8rLJ1K/X0GD6VA8v6Bec0POc/BSnx/dgPQOlLTYwj+eGBZnMSJ682jrnrH6aP67Ko7Ja90wHvC31R3ImLZKcvnJukSIHfHFmiCR8cPmr/SiGAnrbQaxcyDJLl7vBpMZAICGDGb85ODm89f6nIbofLMco66NOZIljH4ILNbx4it8iIu/uRLSlvYKuu66DEGszgcOatUKy9ijma5pDg09USt53OBIwxtxPRu/T1uqFRFfByDnp/jKA
 o6Em7Z7E
 SrFTZ9q4L+DoWWqWuNaBSBeCs59fRPNbPP50vDDKR7Gxy8Wgw8wYuglnaPMtdLEtDV/eqsdcGWKja/Yodm6d3kLVFkC3xTu1Pns7oWDYxs37c5fzbmpGNYy0Pp2K/Z8ztVRI5UCeojz20WBwJg5Xe+RyFiAMNXTs81k+TLBhwgPT66qqSlL6Rla3EhKh0HW0PFXBabUMVar3VD5HgMDSuQ8MhlmHxdPE/m2UNpGg6G/6EhmsfeLZJ2RgddMXqWjfxLZQWQa4QIWfwxGaZUXWy3NnAaaRO/eN1oVSzfkGXXtZKmozPRWfF7eTQXYNi7Dk1UC0PhKomSomBVcTl50Ox+WRYCH28NbAOFLwHkOoSWiMUw+/JCBzxCz3JYby5AYAqSnf8a6qFMxBudv0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28 2026, Breno Leitao wrote:

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

kexec_locate_mem_hole() uses kexec_alloc_contig() to try to find a
contiguous range from CMA. If found, it uses that and skips relocation.
Do you know if CMA tracks poisoned pages and skips allocating them?

sanity_check_segment_list() will catch these anyway and error out, but
would be nice if CMA can track poisoned pages in the first place.
Anyway, that is out of scope for this patch, but something you might
want to look into.

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

Sashiko complains about this
https://sashiko.dev/#/patchset/20260728-kexec_posioned-v1-1-160c81d180fe@debian.org:

    If we find a hardware-poisoned page within a large segment, does this loop in
    locate_mem_hole_top_down() cause a CPU soft lockup?

    Since temp_start is shifted by only PAGE_SIZE, the next iteration will call
    range_contains_hwpoison() again. As seen in mm/memory-failure.c, that
    function does a linear scan from the new start address:

    	for (pfn = PHYS_PFN(start); pfn <= end_pfn; pfn++) {
    		if (pfn_valid(pfn) && PageHWPoison(pfn_to_page(pfn)))
    			return true;
    	}

    This means we could rescan almost the entire segment over and over until it
    finally moves past the poisoned page. For a very large segment like a 512MB
    initrd, this would iterate billions of times without yielding.

    Could range_contains_hwpoison() return the address of the poisoned page so
    the hole finder can skip past it efficiently?

Which does seem to make sense. Same problem below.

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
> +			return true;
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

