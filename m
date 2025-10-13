Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E646DCCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 07:28:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5220C8E000B; Mon, 13 Oct 2025 03:28:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FA4E8E0002; Mon, 13 Oct 2025 03:28:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 436D88E000B; Mon, 13 Oct 2025 03:28:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 31C2A8E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 03:28:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BABBA1DF2E5
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:28:17 +0000 (UTC)
X-FDA: 83992262634.05.16790CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id D02421C000D
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:28:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nbL2UtGh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760340496; a=rsa-sha256;
	cv=none;
	b=4EsYlSF7sqah14vLrM1+FON91ITSzTDYsjXjy/+bZvVz9WUbGvfsoknc1DQrT8Zr6fSW/u
	eGnG9mr3wb/naSBdGrjCNRl2BIfXD1vdmfKvdmw30hD0I2lB/VnncR0QM266sBUng5kmGv
	R+T+I2REsjtTvhZSxi5JDEtm8E671fs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nbL2UtGh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760340496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xLfbxzkeO2ERTe7jXAN1BDvl0RebdDO86nNEGcRvVPk=;
	b=ZMMpoPmU1+TsELhqAS8iuiKSdOm8kQkRHNF7BgrzlBi0ovNaTXviOPs1s8o0PPHvJ5NXKm
	HwLOlbftxwqo3mcENwwVrMU/iTvgPidiKGQQc1W1+ZtdfQInAYbPqplgIGtTSeUcwoVPoe
	Us79Ra1B3Saprfylg564rJeyPq8ZGv4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AF5C345048;
	Mon, 13 Oct 2025 07:28:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC21AC4CEE7;
	Mon, 13 Oct 2025 07:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760340494;
	bh=LXq06zOJDZCJjFxJSMriSR2r1NN0TNY9ryW7UFEsHNE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nbL2UtGhHwSUcGWW+HFftTr1Zex2h56UWPi+59Dlbir/2koiJXfOyrHQboEf6dLFp
	 DYECR09j/iAerh8uOTGkq3WkobLDm3Kp1DAN5ThsizadNmN9snCCVcjNt+sh3H/SRi
	 9R8SvKkNNdcmwOqnJqo1kZ6mIvWSCEqzE6qVnN7efWns9muMgrNEAH6pGZoqjzQQ7o
	 MLIY7oXQVhj3QtNHmSuaYExcIgWzSaK27QgdY3UuvUaXb1ZcmNuW1ZAkOQYodFtOWo
	 eUyo1Rm/AoUSn7fraueBneQSX4KBMfTlQsdXCd69lPvhULXHr6e/qObo9nvsq+IS+t
	 zAL5OVBdmdBeA==
Date: Mon, 13 Oct 2025 10:28:04 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Jann Horn <jannh@google.com>, Vasant Hegde <vasant.hegde@amd.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@intel.com>,
	Alistair Popple <apopple@nvidia.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>,
	iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 5/8] x86/mm: Use pagetable_free()
Message-ID: <aOyqBKjIut4fNr_B@kernel.org>
References: <20250919054007.472493-1-baolu.lu@linux.intel.com>
 <20250919054007.472493-6-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919054007.472493-6-baolu.lu@linux.intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D02421C000D
X-Stat-Signature: 9diom7zmod86r3n4dxbi1wrhtfoco8tz
X-HE-Tag: 1760340495-430192
X-HE-Meta: U2FsdGVkX18HzyhyHSX4ri1EwBGgr3dfEGrpG439eEypMircn8QptF5TDvHh4fGIDTL3syQc+gSdU0VyDI2rnlNl8dRF2MOqH879FUrX3TRsmHqaHW8P4s3/jxSSrQC6ZLvXOW+cnFqjkMYBIv/MKOL9SFOH4D7lO1jxi7bB3Ysks/BfBTzyspVug6eUGbg0KpC+nhPi5bRm++8gUj23Vy8EWyFpH66aMkvbYwUr5lsgvoe9cev+cSpJM0zzvLBbCTXrMq+6gBdAkL0kFwb52jbjy8rJYLZ/DAuockPSMt19fuuy/SpgyEUIPCJjjkjazl4HYSMxS+pdCZVZbWMkfzfy3Vm3BxR4UeqdUEbbvzzG0SFQZ5hMGcWnFyg3cePJgzXdpJRlgME2OddARHCt2Gzwf2CzWP+LQlmV5zAV23XPZHyuhjlMlrj0uNWen1Z2SxgtifYqp4dATNairZXvugMeyl3QMfVzgvoHBl73keO8zKFVT/1j5OnJmMTQrPoAsu1VBs+qeT2qEwxeknb2EfD/5I9XHWNLoqXvAONB9SxHXcBq3IfSz1veZghr16pMhB/N+D4VmErvDx4Ar/183hciEcq80oaH1cu3hsBy3cWUJbvJ4NbVMeoPtsMGzybR17Z3DH4PHBch+SYZQSClVH5vX6f/y3bMRdqnD7La0t/yhOCjSiTcwBqTtevittZnlR3HPx4N4J90Hhzmj/GEIPFGuZHtkcxe5jLIE9xcJihpR7fpBA6pqv7xtRcF5U5AT6lC+jUB2kGcL+q9Ke5bPTZ+RWVQc0HrEaI2aIsryXgiL7NdgnH7Z1ZlafeZxIGxxOQxLPqXW97jqgUiwKOe81287HeDt5MwtEr7r2fAl8Zt4xdOTnN0lIshZG5RWdgtopIYKzcY0w9/abSND/VpzvWZDTkoGVqY57mvYa/3OG3gZL+RiSzX1eNKnNuTCTqL8s4XdtmxgqZ+4XBOokb
 sIW8HHDw
 4gVMCZWS5svF0DNLUNaJV5bybfQsitKRFvw+ItVH2hzTWT/JGwRSlDLVvZ6JUv5b9gGseFg7lBjIk0znkfPsWhEk7sl0DRKzg30azCy0MPqNIW8+z3oUFpd9NlHybqZPyP56zkIw0NQ6VDZ0QYtv5LWwqAlpTlV74k5lkDMjwIfLzo6gaiTV77xmoTkfUWg2c8FTtDOqDdNahzqJglkIdZEeO07qwLrjNECXv2ppkFLtpAfkACCKbJIqyBbtXEBTU/M+09ZjqaT2Qj3uUvtwDype1pMST8h1TfkprYEB3KAtcu5B5FT+Scp7gm1F/XTWmta258HNMCGDXw5Oso7jr4fVmiDUkEfOskl2B
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 01:40:03PM +0800, Lu Baolu wrote:
> The kernel's memory management subsystem provides a dedicated interface,
> pagetable_free(), for freeing page table pages. Updates two call sites to
> use pagetable_free() instead of the lower-level __free_page() or
> free_pages(). This improves code consistency and clarity, and ensures the
> correct freeing mechanism is used.
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  arch/x86/mm/init_64.c        | 2 +-
>  arch/x86/mm/pat/set_memory.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index b9426fce5f3e..3d9a5e4ccaa4 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -1031,7 +1031,7 @@ static void __meminit free_pagetable(struct page *page, int order)
>  		free_reserved_pages(page, nr_pages);
>  #endif
>  	} else {
> -		free_pages((unsigned long)page_address(page), order);
> +		pagetable_free(page_ptdesc(page));
>  	}
>  }
>  
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index 8834c76f91c9..8b78a8855024 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -438,7 +438,7 @@ static void cpa_collapse_large_pages(struct cpa_data *cpa)
>  
>  	list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
>  		list_del(&ptdesc->pt_list);
> -		__free_page(ptdesc_page(ptdesc));
> +		pagetable_free(ptdesc);
>  	}
>  }
>  
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

