Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32561C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 20:01:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12F076B00CE; Mon, 20 Jul 2026 16:01:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1070E6B00CF; Mon, 20 Jul 2026 16:01:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3A3E6B00D5; Mon, 20 Jul 2026 16:01:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1EC86B00CE
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 16:01:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5CB2414027D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 20:01:07 +0000 (UTC)
X-FDA: 85010223774.16.0FD8FE8
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8650110000F
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 20:01:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WxJwgl8s;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784577665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nHyzRN69SIvrGhU2BxqAEaCwqvk6nXUkdLyvQIyO8KI=;
	b=IfYBy/xVJ+c2WDPCIQGGW1EphjV1ggSWSPWlBxP7fQf1yTDHBKfGpEQyhXAn4b7dX8ZJNa
	GXTGyannBvN51Wmhk2cAKjoYC661Zc5aH/h+LcYFOV276khBa/48HUu2uWHrQ3UGRZ3NDh
	wUYJj6VOyHjK3A3w7mvy4sKok3Nk0yY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WxJwgl8s;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784577665;
	b=RPPbNi82GmWQDJBNEdnKQd+IxYdgxnVSt//SNds2C/TIUgTknNNvyGCLEvNqslbgCioF2H
	Z8DeuxUT7vE41EdPrXVdueUiIHE6aFaoRwubkB8scMp1vskGN9EA6rm239MprufN5/3REf
	5CVTstcPvLRKBzG8h/Iwsny+KZ9gWU4=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ceb096e675so104437005ad.0
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 13:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784577664; x=1785182464; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nHyzRN69SIvrGhU2BxqAEaCwqvk6nXUkdLyvQIyO8KI=;
        b=WxJwgl8sDTP0gaOWRGZs5ujubcFFbHW2rR89f1HdJrsrSm9htJfPk8cwjM34HnLV+G
         JhuVHyWUrw/+ThTmUqA5iSszS3FwKTXFXGkJZgWTihz2XZH8GTy95vrbsvkQL0vG7Tfz
         tOwRH0R5WSWbfx6MUi/NEsaKLyeWuHvDUaiXTB0NwaZPwiUCwR76f0l5OggopLveoLBO
         yAHQQ+tDgF5sh/IjVWS/M8vQFRgRYfpPWvRLvFvGK5ZVH1QUacSdysLTsCZxcZh42hFo
         GsT1poszbqiEjGRS7owKJl6erbElQQ2mwdnGe30RCCaQHgNrKT9axFHeSqN8ktaZuoIt
         i0aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784577664; x=1785182464;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nHyzRN69SIvrGhU2BxqAEaCwqvk6nXUkdLyvQIyO8KI=;
        b=eVYZzXTFRzPg3eDPO2DYGh0YSWyhG/3ILKDYBNyzEKfN2xaRgkbUbSVq/TO0DtZQeR
         qIMdNtZikuByigHHItbowXREBUyk39QbrUKdtydewcIcKcqVPgHpi4c3G0HmfFEMV//S
         kA0+tvrJa2LOFxNT5nANkN86iZ7/6N+E08TvTBi2H6aT9wfUD1my6LCLDjxHJg16zbNY
         R4ee9nY9PCDFS0n9hHfOX4ftxfuDNxf/GtaUB39EJ1Woy4+ViQ2n9X0XIFlHdbTocv/M
         Cba+inh4Oi46Oa2HDWqTKIjBFfJbQQSmmroALUdOiagg7hmHCgYPFRJHURWq7CaJuOsK
         PwYA==
X-Forwarded-Encrypted: i=1; AHgh+RpyMiiXgOwCqorC2R1MZ97TODvjQ8BFEBbO+fWgVo+vIni0lhwLi8r0CrC7SCIbECulCnsnDREknw==@kvack.org
X-Gm-Message-State: AOJu0YzNX+//+sn9Pqf558WIF5bh1cpdW2IDSF7ywfBhgF2LAG/6uXPp
	3onW2ZNwKWn72C5AOMGmysehXD6yLS0YjyGcBYcLTUP5sRdfGemYS3Dl
X-Gm-Gg: AR+sD12xlZSaSzdMkEXOli/PqdzRCRi2SWy/Q9Z6nY5Uu1tdg4wu1volYZ4Zc2RAyH6
	XsTCYC/T+7cA6CZwlXowYblY+teGd9tVWt7zhiBuwtzFVV8GyI4np5cUtm0757ncQvrLder2UQE
	/6ZSQ0B/Xp+Zm9i/6OHo7ClGCx2mh9DNBaK7bTLhJZ3xKvVTsD2dK77H/iZ0+mu31JoQN20cvHK
	z/oCKuVxI9Qf1L/OwCNzw5EwtjlXwxNvwuxfBvDIFDmNNPW3YxAnLUZgHAfGoNX96zNi6nwxbJ9
	AZgEzje64TWUkx1qvYYnXK5BU/3K0iZqm3dtXLGWHdVnkYq4dMLlvesIwBX5YnMMqj+oJbHd+zg
	m3Mm0NOEDVy0TkRRnKnenQJDbJHQo6u+zwZPrc91xVsej+6y4QLb46Wr/kFY5Fw0OjBbEkBwrJO
	acNwpYq1nenKe6bRZQ2M7abs0LvPG2FEfU4Q==
X-Received: by 2002:a17:902:eccb:b0:2c9:ff83:41fa with SMTP id d9443c01a7336-2cf3496204fmr169889025ad.24.1784577664139;
        Mon, 20 Jul 2026 13:01:04 -0700 (PDT)
Received: from fedora ([2601:644:937c:6c90:6d4e:7b2d:4a39:fb0c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf3476f70esm61611825ad.77.2026.07.20.13.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 13:01:03 -0700 (PDT)
Date: Mon, 20 Jul 2026 13:01:00 -0700
From: Vishal Moola <vishal.moola@gmail.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Lu Baolu <baolu.lu@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Kiryl Shutsemau <kas@kernel.org>,
	iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] x86/mm/pat: allocate split page tables as kernel page
 tables
Message-ID: <al5-fDRStgU6gjk6@fedora>
References: <20260720-fix-cpa-kernel-pagetables-v1-1-0766e782cefe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720-fix-cpa-kernel-pagetables-v1-1-0766e782cefe@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8650110000F
X-Rspam-User: 
X-Stat-Signature: oyz39a96jfhp5jyo6hckj4ei61d6ccss
X-HE-Tag: 1784577665-113665
X-HE-Meta: U2FsdGVkX19L0ktq/6W0DRJ2q7xfILErUyFGsJWo7Cv6zeGdpSIPdN3Jm17ipNKauF3yYT8QjDAF3bBo21vhnR2Vs/z9ShxqyunGY9ZPRL6cTcUXYZAWem68W+6nHs1xyUTKBg20PYRR13wiRzh6FQq3JlVppiykNHMWpiDWxTvXg45I4Fb35fUqr1m4nwSEXdoS1/iOw+5/4oz0UPXX2i8af2gfFi9s5Yfn6VegpRZOUBndi1gaY5DzlOQQ7QTG3DImHWlXKrNVDAYyYDNUeiVXSrpqYW+jnTXVvX/15Z7hiTOyNdqvgl0AfXNSfAIx74TKPJm4b+IijJRyTpbxU7oGvczi1RMhPHGjKWHhc6AJt/cNfTdXPAKOogkVaxH4Dedd3fGbe0MQAg0sfeyKEbAy2Q5Vx5bzK10BONnw1xMyZshhnYzpe3SoStOcRPZtsdu/d9pbpRjarB5xqTDwdBByjrbJl7BEajVLojG/1FZTJjVuTCqGE/EZvErRI0mPLg7TEr2UwTHraZgKo8MzLLZ/5xeCIMsQkLOoldNjd0pBVfeSw2pDn6lx2Y3q8jwSXfzMmpFSkbrYtzEN1pS/ZW0OP1v3yn4becynru5YwCnnHItEKWwh64UWmoPHHnl/UDgLd2Vn27H8Id9PVRxYz5gDmxhKWbb8JY6XQF8y3gGEkNXF8D/KQND1UEMufToAKWhvK86I83/CnhvXLOX7D4BAWG0T8xElwo/wgp/YgFXp8kJkOeEyFmSMdGKNakWpmdR/fSU3EhPeGXJ8u5p75PHIdRkPjMiHynGxKFnBsbqlhk4zyI/Um0ZHj04Ynvqwk/DqCfSoTKH3NdKbGuV6WucVrJ3HrbgeZkRyIYDh4Gqa4nYix1qyndfmN/A/ji/yUwifWLwAOywBADCIaKYQbMfN9YKCkIDf9rSwL2fc+4+qqv6e3IHCdIWYzEs7v7qUmwXBqB+DBCDtitzafKg
 aFlzRRsv
 wnLNgC3j/ACUT7z7Bw7rC+pTtSDophZolzkGe4dUuTAFJtZrTmmoKVL9BEeONGxxVAjr95FnL/uy8CA9H2JigSfRjI28xHjC/ki0BAlyyDRDdKvu8KNuYfgPc2V7Ijfx/NHqAd/NJXZbyl/hurjtBuEySatqGksSBuXeFbkOv9OsA1V8ZNhTivEHVJrGrt0HWpGiv4Aq8j6BBKj5sLIvHTiCq4s+yuij8Oy5VokCN4swDsWxOTQ3g0qbcyuVmDYdhn+AtnIxLkyH3mrM3GMN1G8y8FpLcEEsS8qS/FLwYb/lhx8UcPbul9dQizq1UeDqtNt9Ucqt9LXXdb4lABj85x8JeNVM+pj/i+Mlm6KFLi+vAF6cQe3VrhhluauZuEYCcMhP5QM12nNBtJGp2JrDOpIJ7/BpCLst1HIf/BdeIIeL3mC3QB0BhB4AV13gbTT8koKmQq5uNcYDJWVYwuc8dHiJr8AO/buWhQ7Z3z02MM47BjPfmk4+XJ3GwDb7VIqyDlhZnOYA/SHWNQY2jBHt0qrablm8Zeuad0u/e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 10:27:29AM +0100, Lorenzo Stoakes (ARM) wrote:
> When splitting a large page in CPA in __split_large_page() we allocate a
> PTE directly without going through the standard page table allocation
> routines such as pte_alloc_one_kernel().
> 
> This means the page table constructor is never called nor is the page table
> marked as a kernel page table.
> 
> The former results in the folio associated with the page table not being
> marked as a page table (__pagetable_ctor() is never called thus neither is
> __folio_set_pgtable()) nor are statistics updated to reflect
> it (lruvec_stat_add_folio() is never called).
> 
> The latter issue of failing to mark the page table as a kernel page
> table (ptdesc_set_kernel() is never called) is far more problematic.
> 
> Since commit 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page
> tables") kernel page table freeing has been batched and since the
> subsequent commit e37d5a2d60a3 ("iommu/sva: invalidate stale IOTLB entries
> for kernel address space") IOTLB cache entries for kernel page tables have
> been invalidated upon being freed.
> 
> Since split page tables are freed without this invalidation, the IOTLB can
> contain stale entries for them.
> 
> Resolve the issue by using the ordinary PTE allocation API at split time.
> 
> This results in these kernel page tables invoking a page table constructor,
> and thus requires a page table destructor.
> 
> Since we cannot assume one is always present (early allocated direct map
> page tables are not marked as such), we conditionally call
> pagetable_dtor_free() if the PG_table folio flag for the ptdesc is set,
> otherwise we free the page table via pagetable_free().
> 
> Regardless of which path is taken page tables marked as kernel page tables,
> which now includes split page tables, take the correct route through
> pagetable_free_kernel().
> 
> There is a user-visible side effect in that split page tables will appear
> in nr_page_table_pages in /proc/vmstat (as do other kernel page tables
> allocated after early boot), however this is a positive change.
> 
> This issue started being markedly problematic after commit
> 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page tables") so
> choose this as the Fixes target.
> 
> Fixes: 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page tables")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  arch/x86/mm/pat/set_memory.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index 301fb9e77d91..a67ca33b9dd1 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -439,7 +439,11 @@ static void __cpa_collapse_large_pages(struct cpa_data *cpa)
>  
>  	list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
>  		list_del(&ptdesc->pt_list);
> -		pagetable_free(ptdesc);
> +
> +		if (folio_test_pgtable(ptdesc_folio(ptdesc)))
> +			pagetable_dtor_free(ptdesc);
> +		else
> +			pagetable_free(ptdesc);

Lets not introduce more folio-ptdesc crossovers, we're trying to get
rid of them :)

I believe pagetable_dtor_free() should do what you're looking for on its
own anyway.

