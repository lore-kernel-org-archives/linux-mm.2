Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAF96606D812
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 21:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=l5bjvXjI
Received: by kanga.kvack.org (Postfix)
	id CD9F26B05B1; Thu,  5 Nov 2026 16:53:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB09F6B05B2; Thu,  5 Nov 2026 16:53:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9FC96B05B3; Thu,  5 Nov 2026 16:53:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 881486B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:53:19 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DC49EC0C30
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:53:18 +0000 (UTC)
X-FDA: 85402416876.01.3B8C3EB
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf11.hostedemail.com (Postfix) with ESMTP id 01A6340005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:53:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=l5bjvXjI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793915597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ydingrYB6uW4rebn/QPgfSs9E1VGseZYnprZrlSzIHI=;
	b=0nUBoNUYO7rs2V6VM1xCHim2S8B6iXegR4Ab08Si0hHxx7E9J5low2LwHOKTLQSzFpQi6d
	U0hlVz+62TQ1eiZKvHx9IQT2yqolq6Htz3Mexsl/6GHh0+PHsKDAcx3fndBB8RkjjegTcq
	59yOKzEMzvGfyz6HWxrFiCqDcA0Nzuw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=l5bjvXjI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793915597;
	b=hMFebnyoZZ7gX1lhc67P7Mu2NFGkdX6ndx3N1ASZtvLjGPjpqVJz0ow63L4C8B7sdDhXQS
	LAevRNRD0y1uBPF5uDbT0SZHcQwqasvYsGRwaia/2skJ4zvwGDtnFHjuiZvEt5vyaALn64
	V1lJSqre0oFfG/QceveQ2jDuqIDAahE=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a210470b49so52705e9.2
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 13:53:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793915596; x=1794520396; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ydingrYB6uW4rebn/QPgfSs9E1VGseZYnprZrlSzIHI=;
        b=l5bjvXjIaofjvOyh4kK27amuDa2Q6zsI4GzkFh6ybxbLpzVGyaFpbnpjIWRRef+ZFg
         hlcjn2EA9Mtrpy6kKfb9eb9rI5tbwDYUIf17mSZylBJ/ZXHCWTRiSWawvDZqj5Lyz3gR
         qBSPjjI3xKkzMkiYIse6dXPqWHREODj2FrIZrBJeTO1uGXdRhf8dt/UU2yhNuTQg/e0y
         /G6Jud3BIa9Ma6jLTLseceIzQp9niUmE+zvYzAEm60ovBK4jQvEiExGM98XDjsJ33ZnP
         qr9kjTgg/gdM0Gpkv82lKav/G+bdxIgzMYtrbfLHYiYwqzp2EsDReRh6eqFL5nlXNCC+
         ntFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793915596; x=1794520396;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ydingrYB6uW4rebn/QPgfSs9E1VGseZYnprZrlSzIHI=;
        b=IP7bLFxg50oxnt15pXkIVE29yE5c+7xGeJoIQ5M2w7oej7/bYO8ZeOaD0m05SFoWLb
         uF/lL333EuCB88uSb7i3NoTZ+OvVm/xediB/MNQrGfDMZPsbLsWtNK+Mijr+DTBFM0RK
         AdPRZtpOFsj1vIjXDGNjGSG7W3qEHzGjTGd1QCfyIFxxJNvvzVRENSARWbv2J8RFftIw
         VlBvXVB/CJcjsyjGalriJqbqFCEu1FVu8+w3f35uHjHgUIRyuuGbxmoRy51Ph+7xmZfI
         iFTebeheQDDMSFJJz7BmN8k1HfnWXXFCiongkyTfUKd0fXcqg4kbkNFszNpFQ6opzTOp
         lGfA==
X-Gm-Message-State: APuU4Z/OyaXtvvI10Xv8nbZZvUTe1dfOlKv5ZBpgA2eYkAAltSQpQGoa
	HNsksj09IKiZp0Rx9Sa1x8GyFGHmv1hkvdaNN3gLXlFDkQ+x32L1U1Hh
X-Gm-Gg: AYBFou2UP/7UHFXoK19OK5SN68E8ehq/neg1et/87tbZYHOg2hu145UCFjo5NWODxwC
	PrYMx0DPZHRgWUR8nmvYpHYm8xe0vpmRQBj/S6tL8Jy1vLAADDd0dZc5HhS/ZywrqCKDA7/C96k
	8iBqbBIQ/RCEhDfWuMDGujzZRpen/If9upQlDjo85M2aAjXyIpjZIwhaJy7Dre+vXOc8+0zcHsf
	56om/kkDlgC/rfaiDTwKuXO+sm0/OlnpSVkufAtNKeW3Sw3ejENK3FlQQZzIpNj6B/UMoSNQ6bU
	xMyPSjrKX7+/EmnJZP2y4/wY0LSYs8MxsWwHUiGcqGYJWXllhFBDZkyZUVOQusiNW0QqBEeC4Zg
	oRRxPq56Wsow7Q3Nk3lpsplvSm4/0RcrzLk+PxGOl64Nj9Q/T03BzTQ4Bsz7/vArSF2r4JtKNT3
	YM+ig4khWpW5dzkqtTWyslsd0nnsRHGO8f0klkjEESe8YEv4Rp2hFJMn76kF1b9vZKLlZf9qw05
	O5IeK5rTmoZCovHG6F6kGJ0i9/JQpXF60poa8BvvKQEQ62y4bRdteb2tGkxew+mekcxVJEVytRO
	OjO1V8AUR/5JQIIvJqG0LEfi
X-Received: by 2002:a05:600c:6992:b0:4a3:59c9:a754 with SMTP id 5b1f17b1804b1-4b6df11da05mr6193785e9.22.1793915595572;
        Thu, 05 Nov 2026 13:53:15 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b6ed5b8159sm5295235e9.2.2026.11.05.13.53.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 13:53:15 -0800 (PST)
Message-ID: <551892bd-d7ca-4c79-9c7b-9d3d08c913e4@gmail.com>
Date: Thu, 5 Nov 2026 22:53:13 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm/khugepaged: release contended mmap read lock
 after scanning enough VMAs
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261105-khugepaged-latency-fix-v2-0-4384bbfe4606@kernel.org>
 <20261105-khugepaged-latency-fix-v2-3-4384bbfe4606@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261105-khugepaged-latency-fix-v2-3-4384bbfe4606@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 01A6340005
X-Stat-Signature: 3uifddxgoemcdnzepn3zeeiedajtosie
X-Rspam-User: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793915596-920886
X-HE-Meta: U2FsdGVkX18+Ozg2QIpC/4NKqlnp3hw4FL9hLgbTpbYK2E/npYTODhynsmHyMIyC24UGH4dtv0lRca0poI0bbkBQlI8/UJn8iPOwT2vXV0sCsqJWPVFm14WEDaWwsSKOF6S6K2OKGIsIHuG8odhkpad3xCleCz7dPLqDYd8oIGaS137n+P3bI9Aw85Pzs68tgDqEYRdIy1NHjfYT+lFjT1DMr2/4rnZNsrkqfA33+iUADYwSZOy/7DfY3FoQjXhxj8TDAiaf5Ap3Lt3TKbrERTFS9ekdlfxSb7w29rgwk14iSrvnElwE1179TvgP7d9jhIH0RgtooY+3lM5ovRp053WPjNg9jl+dCuwBkgXwO0IfF8649kRDAkEnLirPM16LRUe90palBbSUhYV82iqDnkvUF0QzywqkkEHmJUsW60xk8GfQCna+LJU858XmsPfmv3JeH9P5ZwyZs4LkBbvlDL0zLwVXkgOs4FVmCkdrcmJatVazFTkGryoWMFs1k4Yx+gNM5ulyEMFC8AdzpHP1lxYHe8ze7slGVD6/hE0fSMTMyml8V1BLnFvIGcA0oSdFb4NI5J/yvL4soAxs0KH2Ia1DgoNmiBuXSb9LdXNCvRSDSqLvUhfsFucPQ8LVhSjaxRob+hUDcDpFUJMdrAUqlNN/c5Z1/MoS5UdOTDINwY2oHJPcWnUpSiqXIFktzZnL87iWkZVLjEgeWCIwIf7ReOswhZo25GlSgZCnHOR4SeYbgcyC3WL7Yd0fegEh9W04Cx0SEHM6Y9ySV5ALIoFn3TSEl38qUjydPi9/gwfwYbIFcSvnqkJYYwl9FmGksudCqIbToPgEXdKPGBoLcMtOIpouKw85V1FWdrNOAEqa5MvWDyrL2NmjsfAsDLm1THEfGWzAHt4/krO+ebOwYYhW+X7GshGLJdyOxD90cBxNb/BGBd8eOwA/3IVufAKT/1rTJf2pFGXocgTzONz6AG1
 ls65kvGp
 7Jvs/vNvrx3RCmLDwm91rJKCPQ7gtW2KRO23CNkEyz6S6RNMVmnl+SVZV9mgp0FRdfRIObQflAt7xAO7TD+lBpKmcuBJdFCfPGNnUS5+vYZrPZwbehvIPHH65CoxrgVskvGy4xX6iNvrjcfJwPYThL2567Yv0Mx2daihfE/aFtV7b8Pgn4X/KmMsWQsrt79XYJP2mq/791Y37nQ/BpViguEN3Oc8vaIaTtgQ8/OIU26hSuAt3UxwIZSNCoiSbWO6z8AOr1bTluFXwSM3jO4QSGLbc4r0DMZAZP3TdLHITVEg5Lq1sOUyXqTNhRofpv63pb7pm4GDJlTyosVnSN7ZewpUhiMzEnDXlSCmUUgZrvVj9LgxPbXhM8S9nhqL2YIrq44hhtTKBYeapBbaiTbPQyyzugpm/ZNhGT/PbCYVzagw0Ez+h++xC57uNgRwjDOkKeFpB3E+7TjYTvl7JsCXdSsQZGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 9:57 PM, Lorenzo Stoakes (ARM) wrote:
> khugepaged walks an mm's VMAs under the mmap read lock in
> collapse_scan_mm_slot(), checking for ineligible VMAs first, and skipping
> them if encountered.
> 
> It charges cc->progress 1 page against the /sys/.../pages_to_scan budget
> when these are encountered, however only checking this budget once an
> eligible PMD-spanning VMA is encountered.
> 
> It can therefore hold the mmap read lock for a long time if there are a
> large number of ineligible VMAs present in an mm, over which time no mmap
> write locks (and thus no VMA write locks) can be acquired.
> 
> Address this by checking whether the mmap lock is contended after every
> KHUGEPAGED_MAX_VMA_SCAN_BATCH VMAs walked, that is a quarter of the
> pages_to_scan budget, and if so dropping and re-acquiring the mmap read
> lock before resuming the walk from the per-mm cursor.
> 
> As the walk is resumed from the cursor rather than the VMA that was current
> when the lock was dropped, the cursor must never move backwards. A VMA
> ending at the top of the address space causes ALIGN() to wrap the cursor to
> zero, so treat such a VMA as the last in the mm rather than skipping past
> it.
> 
> This was tested locally with ~1M ineligible VMAs mapped ahead of a
> collapsible region of memory, and resulted in a reduced mmap_lock hold time
> of 170us down from 95ms.
> 
> This was also observed to reduce mmap_lock stalls in concurrent threads of
> a similar duration. Note that a reader re-acquiring the lock can currently
> steal it from a writer that is queued but not yet running, so the full
> benefit to writers depends on the separate rwsem change at [0].
> 
> Local measurements indicated no change for ordinary use cases, so this is
> all upside.
> 
> This work came out of investigations into mmap stalls when getting latency
> numbers for an unrelated patch series.
> 
> [0]: https://lore.kernel.org/all/20261105-rwsem-dont-steal-from-queued-writer-v1-1-275e070f426f@kernel.org/
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/khugepaged.c | 31 +++++++++++++++++++++++++++++--
>  1 file changed, 29 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 216c4b8d28c4..eaa01dae5a03 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -66,6 +66,12 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
>  
>  static struct kmem_cache *mm_slot_cache __ro_after_init;
>  
> +/*
> + * The number of VMAs to walk before checking for, and relieving, mmap lock
> + * contention, as a function of the pages_to_scan budget.
> + */
> +#define KHUGEPAGED_MAX_VMA_SCAN_BATCH(pages_to_scan) ((pages_to_scan) / 4)
> +
>  /**
>   * struct khugepaged_mm_slot - khugepaged information per mm that is being scanned
>   * @slot: hash lookup from mm to mm_slot
> @@ -2910,6 +2916,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
>  	struct mm_struct *mm;
>  	struct vm_area_struct *vma;
>  	unsigned int progress_prev = cc->progress;
> +	unsigned int nr_vmas_batch = 0;
>  
>  	lockdep_assert_held(&khugepaged_mm_lock);
>  	*result = SCAN_FAIL;
> @@ -2942,15 +2949,35 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
>  	for_each_vma(vmi, vma) {
>  		unsigned long hstart, hend;
>  
> +		/* Relieve mmap lock contention after walking a batch of VMAs. */
> +		if (nr_vmas_batch++ >= KHUGEPAGED_MAX_VMA_SCAN_BATCH(progress_max)) {
> +			nr_vmas_batch = 0;
> +			if (mmap_lock_is_contended(mm)) {
> +				mmap_read_unlock(mm);
> +				cond_resched();
> +				mmap_read_lock(mm);
> +				vma_iter_set(&vmi, mm_slot->address);
> +				continue;
> +			}
> +		}
> +

with pages_to_scan below 4 the batch is 0, so under constant contention
we keep dropping the lock at the cursor and never scan anything, don't we?

-- 
cheers,
jose a. p-a

