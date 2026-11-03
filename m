Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81285606A33C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 09:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GV++1Djw
Received: by kanga.kvack.org (Postfix)
	id ACFAA6B05B2; Tue,  3 Nov 2026 04:49:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A53296B05B3; Tue,  3 Nov 2026 04:49:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 969A96B05B4; Tue,  3 Nov 2026 04:49:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 71EA56B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 04:49:04 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA6D7140339
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:49:03 +0000 (UTC)
X-FDA: 85393334166.11.FE10EBA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0F55EA0003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:49:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GV++1Djw;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793699342;
	b=cOCzVdt3h3VPy/LCtHGWe31Xnuuo3c4EOpuhDWiEyDneIj1trlIFR7YvzunPwSotsbV8C2
	1L5ExiWVaaYzs1948NFrt8/LCiTrpPkTCE44lSYkskLDRm1Y7XWkmMmUo4QzxikhEYUqtq
	eqn2Zi3kIo7gLtYKrTRiPs5/eYCTsaQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GV++1Djw;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793699342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cgwH7+eb4DO1f1hZBo5/HU3TXgqaVoeCZLybivmvUJo=;
	b=BSv4gtUWw6F8HKdjyaRKb+S3MV8WcXpp/pWnTH2/tF/dOaz15B6lkQQvpMA+L5ZiE1bj4M
	eGFzjc7VhEt7AM5MMnq9Qegi51kBL37epjEYQ8jB/P/4JXbQCTSRd6DJZKyEbSDZryWwxR
	OzpfdMelpTOceyjM9YZbbfObXW3/Nu0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9BC37605CB;
	Tue,  3 Nov 2026 09:49:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74261F000C1;
	Tue,  3 Nov 2026 09:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793699340;
	bh=cgwH7+eb4DO1f1hZBo5/HU3TXgqaVoeCZLybivmvUJo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GV++1DjwxRqBZTgtqKQjH8FDRWWNjQ0UExyz4D4wPRG6CXHgHqlai8IgSZ5/B9AVO
	 fyr6sYpt+ugUguBnTwfa9EONvXK3lfiCOo8fFL2gesEHkb4WUZGfvT6fCfMJNsI31Z
	 Vw/EI3JAg4jrRuPcmYktzzSqUrEL7bUe5ETL5f1c0mbZHI+qxZizlD4FmPKJbOX8x8
	 UcFo7Cvy49IASUxO9wd2cXytT8/WMCHJsvvJP/mjOG1ZnH5zkongCwU5jFXzRP2W/i
	 UHtO33zaLptW2P5/6tQLOOQzYQ1+oU9XS++2xZHKEc1aCasgMoti+lnda5b6BltK8l
	 casrwkwEvaa2g==
Date: Tue, 3 Nov 2026 11:48:43 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	kas@kernel.org, kexec@lists.infradead.org,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	shakeel.butt@linux.dev, linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, rmikey@meta.com,
	riel@surriel.com, harry@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v6 3/7] mm/memory-failure: add hwpoison_boot_page() to
 flag an inherited frame
Message-ID: <aumt-4kfGGtoXuh-@kernel.org>
References: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
 <20261016-hwpoison-kho-v6-3-f304255147da@debian.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016-hwpoison-kho-v6-3-f304255147da@debian.org>
X-Stat-Signature: h3qfte5aw1m4smsiwks4f7dexx19qfr6
X-Rspamd-Queue-Id: 0F55EA0003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793699341-261180
X-HE-Meta: U2FsdGVkX18rNYmWDKaI5uNRwK5tMKbowIh5rWVOVGnV+q2HxnH3qU3ieEdtJg7ERRKKtjyd6cGzniC+czaOTxAz01g4vg3VidpgGbWpfnlaCi8tPQOzW4Im+qEbKTAJbeGUCrHLa/w5XiZZNTa3rxQAx5qOdq7c9sv4Y8Pdi5PAKWMuKMgpPUiXb1yjiRu8uxl9jROgHKl6FJ3TE9vt3U6Tnyqe+WaqGHPM35BVcVs/edd3i56kAt/cB6SdkBfx5NF1ZsyNGNy0g9mtekOnmb0UWLB3DwZZIm3Mwgircnf7LH3WZ8ngYfequWhkig1ilz+Po5WoDvcUiqo/XuU1UD8h65feRZNMbsNlVpNZc3OZuayfntKYgH5fVYT0KTELZ8P6Ahi+aIUJDPCLBkNExJwQBMcvlvHmaGL0t8kY5hZDOW6nOYgTPX45t7OzoRo2LoSJN28LWzvL+4+ip3viT4ssPM3x5sYJ4e3H1p9lwCPKQSNZZjKsPo4fAng6Mn9q/tPxqz9NIhSE/lYGdioep2Dji3NOruWp1nhXMFs+duKeha+E5+0C6LSCuO1TYeUuEPuFc4e72Ku/AdbUxgKvh6buRAYp1UJjgCHTFReUnsDRd36/BacgUGblnxqi1fpB9X3wj7Cu3BVZwBkg5U/L5/tavx/fL5Z2ffMbk6TJhrs6LqEIERH53f8RK/S3XdvMaV7SPCIPvj5FaHyuxKUANJsY82C/qyuCY+m7/v4poplkb1xnyKK8XfL+BQoDhl79yZi0eabM4eF5vJ7r6uLPHqGzGDULSB46CsUHFy1afa2+Zgwse3KNDW2VQHDjBlta8rOsg+WD+z5nSdKp+ckpdblABhiinwNFBJ9/RKWwJRqJD8GhwQrBKfKCf0IBCiIeDNYNlAsOok4Y0gCqQvPgQgH9GThw0OJ8dIakOpQZjFQ2Vz5LXknQ/EknmJRE8OeeUGG0vCWrurUOWTJO/HP
 sBkZo7DU
 wXV1O4qw+LrzdZmvnnUMJD4LTUrw+O33J5/UpMzYsksG2BcCvAQXUStyXHWFIzO9DcU5E4VA/7s5h8dJSQDZ4gM74JFhHBLYvz6ZKPKNhI6d2McmxEnMr5a/9gEj8SdXIFfqhXjuKj//mdnoWLd2ZjWWTMaVyA+nZMgbMmAm71Gbz7dhuC27tglyBtkpASBnmA10C1dEoSodd7eMr5cySQpS1fBx6i0m/iODZ0OX9/646VU8D8yLHqp0PWK+XmmD5d+ufa+53kInUnEh6FDr1A9ysB147B7E1uYnS+sRu6zB0tX+tgf4QoWLTp/+mHLdhzfftINJb5a3UpeEre8DhEmB8n56Mad24hFBvrVBF8KI8oX7OPQasT6g5YWaleyxMR45XvqTv5jokwG4bLXQBEB/euw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 16, 2026 at 05:15:43AM -0700, Breno Leitao wrote:
> A kernel that kexecs inherits the frames its predecessor found
> hardware-poisoned. It has to carry them as PG_hwpoison in its own memmap,
> so that everything that already understands the flag covers them,
> including the kexec segment placement check.
> 
> Add a helper that sets the flag and counts the frame in
> num_poisoned_pages. It runs while the memmap is initialised, before
> memory_dev_init() has run. memblk_nr_poison_inc() divides by
> sections_per_block, which memory_dev_init() sets, so the helper
> increments num_poisoned_pages itself instead of calling
> num_poisoned_pages_inc().
> 
> An inherited frame is a hardware failure like any other, so the helper
> sets hw_memory_failure. Without it, unpoison_memory() accepts the frame,
> clears the flag and drops the last reference, which frees a frame that
> is still bad.
> 
> The helper also counts the frame as managed, as a frame that fails at
> run time stays counted. Memory offlining subtracts every frame of the
> block that is not PageOffline, so a frame that was never counted leaves
> the managed page count too low after an offline.
> 
> The per-node memory failure statistics are not updated. This kernel
> handled no failure, it only inherited one.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  mm/internal.h       | 5 +++++
>  mm/memory-failure.c | 8 ++++++++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index da14c56fb24e11..4bd3bbce86e0ad 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1169,6 +1169,7 @@ void SetPageHWPoisonTakenOff(struct page *page);
>  void ClearPageHWPoisonTakenOff(struct page *page);
>  bool take_page_off_buddy(struct page *page);
>  bool put_page_back_buddy(struct page *page);
> +void __init hwpoison_boot_page(struct page *page);
>  struct task_struct *task_early_kill(struct task_struct *tsk, int force_early);
>  void add_to_kill_ksm(struct task_struct *tsk, const struct page *p,
>  		     struct vm_area_struct *vma, struct list_head *to_kill,
> @@ -1181,6 +1182,10 @@ static inline int unmap_poisoned_folio(struct folio *folio, unsigned long pfn, b
>  {
>  	return -EBUSY;
>  }
> +
> +static inline void hwpoison_boot_page(struct page *page)
> +{
> +}
>  #endif

We've been splitting internal.h to smaller headers, maybe it's time to add
"memory-faulure.h"?
  
>  extern unsigned long  __must_check vm_mmap_pgoff(struct file *, unsigned long,
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index a2ca8df501caee..d0d6b184ee469f 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -96,6 +96,14 @@ void num_poisoned_pages_sub(unsigned long pfn, long i)
>  		memblk_nr_poison_sub(pfn, i);
>  }
>  
> +void __init hwpoison_boot_page(struct page *page)
> +{
> +	SetPageHWPoison(page);
> +	atomic_long_inc(&num_poisoned_pages);
> +	hw_memory_failure = true;
> +	adjust_managed_page_count(page, 1);
> +}
> +
>  /*
>   * Return the first or the last hardware-poisoned online page in [start,
>   * start + size), or PHYS_ADDR_MAX if the range is clean.
> 
> -- 
> 2.53.0-Meta
> 

-- 
Sincerely yours,
Mike.

