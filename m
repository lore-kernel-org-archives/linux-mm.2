Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFAF3CDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 09:57:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EA546B00B4; Thu, 25 Jun 2026 05:57:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6728C6B00B5; Thu, 25 Jun 2026 05:57:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53AFC6B00B6; Thu, 25 Jun 2026 05:57:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 26C7F6B00B4
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:57:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8B522120574
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:57:33 +0000 (UTC)
X-FDA: 84917982786.17.90B7CE9
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf14.hostedemail.com (Postfix) with ESMTP id 99B9810000A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:57:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IQ7a9WIF;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782381451;
	b=MrgrnYRexbyGRXGqaPv0tnLfj+UFMLQjvnM2GhM3pwIEIef1X98VZ5upyY0Brvzvn+g2K3
	4S4sn2bwywe/qhLFTazxlYZlZJWenAJHKACncQJmdBIGG9yJTvZ/QHfj9e85OH1li8NkgN
	PE+hfU9rIdImguJwI9K6x2Yo4TtJPLU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782381451;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rYTjzOSxFoYpxoE4t1ZZfdj5C3kUNVB/dQ5bdM12Xk0=;
	b=Ks1a0MHjKbfsF0ZyfyEu0dh9j7xAUGg1Mt8GCB1sqfZbS/FHSIs/j5Dhp1kAy/NHosiw67
	y8q7LbCqHa/dYX/KSsfKatvlZLZBOmXh9FZ1hBFQ7UYlnyB7ExwpQzax+I/yX8qkbK5cNS
	V18CbGbjA/GPTcWTaM6h26RIfR235CE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IQ7a9WIF;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-bec43ee8ff0so205915866b.1
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 02:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782381450; x=1782986250; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rYTjzOSxFoYpxoE4t1ZZfdj5C3kUNVB/dQ5bdM12Xk0=;
        b=IQ7a9WIFN8Q/oKhazOD6e7P7q5vM4fHRsS8GGdI4zFyNN5CjnpVZz9Jgs4H9K9ipIP
         Yigq8lNo3JyUlp7aqpThJdhOrPyJ4wPInovaLiK0ghEsZ8VfsqEtuwwjhmSndFB20dRv
         kfHNhtXsaXul/3IF8l9vdQ+zwoxBZ4BRB3eEPbLoCZQY3pEUvGBMIbo7BBUXo7Vmxu1V
         022GAcb0pBvYuhUMjkDhKgnx5Jx02EiqGuAlN16NCzOO+9USQlkKYt6Ymwv3CNtrPd6Y
         fJpigiGjPuFv9FoaIhM88TuKqU0LzNjFUhFDybsN2+RKhXlfyTXcfoRNgR80inUBGrAe
         CN1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782381450; x=1782986250;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rYTjzOSxFoYpxoE4t1ZZfdj5C3kUNVB/dQ5bdM12Xk0=;
        b=TUx6EgyhWxuWmc31NuCbTC7XxoE/TZ2lK4o/HBEJmRveIoj/9XpZfRXU8KPb/nQp/R
         Sx8HHFDbXyrpDIicFRpimj9ixdJO8YfCpct7VI/WkFEUvBoaM9Bp6Qfyar5kM7M8AsD+
         XMY0X1Z08Rr8l75mmWgKfUdsVnEoBXtIgtPJiRrP7iUITIT/tBfRwD7x5jhxWo+usxEZ
         AGx0QX0RgjB+TFxJDumyJk0CG/HospTp/ZeR2kKOyXBEi7eGb3Cnzy+850UJNJTvLFQ1
         SuvJTb/N2EsTdk5S8gAaIxGO+03NI57vbNMwpXAe+UyFaCc6tQENa4sDQISoLPC9m03c
         g3tg==
X-Forwarded-Encrypted: i=1; AHgh+RowP9y7/nd17EQ8i+kSIQKPr/ZSFW2BjzsL50AU0gLQ85mJ8l6Zw5hBod4bObF3057k6WJn5eNmhw==@kvack.org
X-Gm-Message-State: AOJu0YxAfBau25ggKEESyoInW0EmYKA6bE+eP6XdAvbZq5gBpEBfnBQz
	ZdXNV8ZFgIJCmVsDDyK+T0p3sM4Cf5IQ2GVX4eqlPw88TbZRNvErD9qt
X-Gm-Gg: AfdE7cmB7H9MMGIGrMnGJHenumJczqWf6818Mlz+jl4xAP7sdTJ/DuNyao/p+GuWXER
	ph2hWBE74UdAvbszN8JZZS+JkAjgwdiJJ0Zk35I4PLslHSYynFA4slWiikYjigaCoVMysW7zYJo
	MrVztpNTWs9mWwJevIYn7y2Zv/3guwCPFf0JfgezIWYmoB5Pz4UI+Lowv1clAT/3gxgq5KQ5KOp
	V0rlldNKmEPXNWdpsi22Rd0JFKbnhdRxHWSnjoCuoFxz6j6MIQkHxsV8jy+7aCrDSJQCr3EqjCy
	4p7ea24ZJXRGXH5f9ZY2rvXO9e3VYJjj2hvfGVhgqxkAxWMb/s0gZF1vfBQ/hpbFTHdl7nDmfI1
	SCKuN67TifreXQldbby7YWcRxs2yW4H0bwtd5VqlwoveQFK2orw4+firgLkZqkrImjwgTA4oyQe
	c0G16ZwQDSg0w=
X-Received: by 2002:a17:907:c8a4:b0:bef:3ab2:bed1 with SMTP id a640c23a62f3a-c10309ba204mr624280266b.16.1782381449884;
        Thu, 25 Jun 2026 02:57:29 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c11fbed6c78sm144027766b.60.2026.06.25.02.57.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Jun 2026 02:57:29 -0700 (PDT)
Date: Thu, 25 Jun 2026 09:57:28 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: richard.weiyang@gmail.com, akpm@linux-foundation.org, david@kernel.org,
	ljs@kernel.org, riel@surriel.com, liam@infradead.org,
	vbabka@kernel.org, harry@kernel.org, jannh@google.com,
	ziy@nvidia.com, sj@kernel.org, balbirs@nvidia.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [Patch mm-hotfixes v4] mm/page_vma_mapped: fix device-private
 PMD handling
Message-ID: <20260625095728.woikmkxb6gskth3b@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260624065353.1622-1-richard.weiyang@gmail.com>
 <20260624085756.6598-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624085756.6598-1-lance.yang@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: mfbx3joi84mgjofhymdpo9z7fi4aymmn
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 99B9810000A
X-HE-Tag: 1782381451-711641
X-HE-Meta: U2FsdGVkX1+Xy67OwesBlvJmpLLjXRT7YPPpEScrAvLkNTDuBGSWIPhYiL6vPPlKiJHHVJGfM4A+D+GYqqxtKSasQV1noEI5yzwyNbLoNs3Ww0IOsevCRHE8CzVxehfkdfN1saoPd6QQha5sxVSqh6TdjQ88Tf2j1321KYVUbtidvHtd2K7PZOFDxbEfq4SqJiflDta+L+FQF9fzLJ+hn3ZXtmqLEScmm3Cag1K2ZVdeTw7nLVmlEXDOVi5N7JXV2eTn+9nbfWAaTO3Lv7TUGwON455QgDJLlRJiLlHsPoCPSk0rmUOGNnbxzbrDjXdxJvXrTwDd3fQ8KBU9E00rmy/Q7FwoZZ1nBRP7ghnHwtxhMY8jitoTzpQOaRwqS0ohvkMoEXUsl4vShNag7YnChIRbEkj/MNuhWiLYE+52msQvEUWErOPEMHCT2xEXIZUIAKljJhxx1wK67SB6dPH5MIR8LbIWBH2i1MYeiQnw4D1eeEEd+HA8cLx4p31WTrIbQO53112GK57RRDMSbZ1Pv6f3Ocy4uO/1VpxM6xvrSh89tH4hEgzSbv4ChaWf270VMU/EsjrnJG61AbrbzoImDSGjDnVO+KQ71L9Lwt7bIT+JguaFewMbvaHyYX26LpV9Tm3meEdv5MXmBAoEGF00hdzDHPotFY1DjJQSoY+p6ZzZ87hVVIEcCVHXqsv6+GygBpUFzbdb2AoQY2jrCysYUBP+0bHF4nW+1W0Idb6E66k8iPMe4FNd4hXe7FexH4IuiPMYGu4qfIJU/JU5BkTPOFbCsJshZzNJMB8hf7gS1fDk/GKmcL3dXexV7M1YQ1q51Nn0o6aRGucpFb1jymd2oXCc0GMPbew9aCf0rCKOt+4EoEEbiE3W+T138oB5OcBjk6t7gj56/kuaYMtSjfPI7RGWq322d1pJE5dJHSlmdKH5R65elZCb04QwG/6RGPaqVJl3A4YsyKjjNvtdOIA
 w53fra7U
 +3QsZsoopSgpeQay44meaEcxFSj9DhhnM6gCzM9Wr+Tla5Sbz4AjRg32mIVqIfQJfm8OfGRA/jy7NcbNLT2DAcQivByQFRaLJ9cfImkGeofM/C4tv9VHBjZ0RxXTWqADHFeryKVjq/k7PaRjNvYzBxEHC1sASQdx6yfILeuF3JLxZRJ4E4QyqJMd9hwBMvZj/DWqnNWx37mn7RZ3TWrKAEUb4T8VvtXa5sAy1BtZHSM3g7m5Pa5eL+6TAsDwSUkRDAnuW+snDJskoFWXUs26pasKamXOn/9ngT0u7TSJu4n1ccGT3hbHzUVoz5ke9/NQEdvKMRja7gM4XoT2O0T7OZz76qvLQ/3YeZpvzYVsnSDlmPsd40lqG8h6DsAkXpycLOSVQvELSFE5gOMAyYP2v7itF4mu7TiOYOrfnPbKtJI9VFRwuU/AC76mY1/LCti8EMnGPt1Y9CB+VyQAgZK/JZHZ6nNSRb5lRZLMygRgwN44lo+/CU5aD0iHi+HjjX95nIDLgVGZHiWahGANzbIu0kTG/0bRL7aVICY4uLv177He9JMDuSNzrvIQj3z1XWr7wIMrqkwNP9GvO7c8CDop9VnQbMuhl18eK8ruJ/7i2wafzy0C9ZMO1FWV6SzHCT0LM/bzDN9zCL9rFKzGnJ9tVFUpuE4fY/AX1pVtOtOEdg1DsxBOxwTwComsytMUsVuXPAz8R9GJyA7lSrdELJWz0H3RbrPJhp7v825KkkpHXn+5MDVi7LqH4aBDbnozkyNK4HgsXjO/oBQ7o3uk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 04:57:56PM +0800, Lance Yang wrote:
>
>On Wed, Jun 24, 2026 at 06:53:53AM +0000, Wei Yang wrote:
>>Commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
>>device-private entries") introduced the concept of device-private
>>PMD entries, but did not correctly update the rmap walk code to
>>account for them.
>>
>>As a result, when page_vma_mapped_walk() encounters device-private
>>PMD entries, it takes no action other than to acquire the PMD lock
>>and exit.
>>
>>However this is highly problematic for two reasons - firstly,
>>device private entries possess a PFN so check_pmd() needs to be
>>called to ensure an overlapping PFN range.
>>
>>Secondly, and more importantly, if PVMW_MIGRATION is set the
>>caller assumes the returned entry is a migration entry, resulting
>>in memory corruption when the caller tries to interpret the device
>>private entry as such.
>>
>>In addition, commit 146287290023 ("mm/huge_memory: implement
>>device-private THP splitting") allowed device private PMDs to be
>>split like THP mappings, but again did not update this code path.
>>
>>As a result, we might race a PMD split prior to acquiring the PMD
>>lock.
>>
>>This patch addresses all of these issues by invoking check_pmd(),
>>ensuring PMVW_MIGRATION is not set and checks whether a split raced
>>us we do for PMD THP and migration entries.
>>
>>Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
>>Cc: <stable@vger.kernel.org>
>>Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>Suggested-by: David Hildenbrand <david@kernel.org>
>
>Shouldn't we add
>
>Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
>
>as well?
>
>v4 mostly follows Lorenzo's comments, code bits included. Feels only fair.

Fair enough, added.

>
>>Cc: David Hildenbrand <david@kernel.org>
>>Cc: Balbir Singh <balbirs@nvidia.com>
>>Cc: SeongJae Park <sj@kernel.org>
>>Cc: Zi Yan <ziy@nvidia.com>
>>Cc: Lorenzo Stoakes <ljs@kernel.org>
>>Cc: Lance Yang <lance.yang@linux.dev>
>>
>>---
>>v4:
>>  * refine subject and commit log based on Lorenzo's suggestion
>>  * put pmd device-private entry handling in its own if branch,
>>    suggested by Lorenzo
>>
>>v3:
>>  * remove cleanup part, only fix the issue for device-private entry
>>  * refine user effect description based on Lorenzo's suggestion
>>
>>v2: https://lore.kernel.org/all/20260616063436.20455-1-richard.weiyang@gmail.com/T/#u
>>  * specify the possible error case of current code and user visible effect
>>  * besides fix, cleanup the pmd entry handling based on David's suggestion
>>
>>v1: https://lore.kernel.org/linux-mm/20260508013728.21285-1-richard.weiyang@gmail.com/
>>---
>> mm/page_vma_mapped.c | 20 +++++++++++++++-----
>> 1 file changed, 15 insertions(+), 5 deletions(-)
>>
>>diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>index 2ccbabfb2cc1..17dff8aab9f9 100644
>>--- a/mm/page_vma_mapped.c
>>+++ b/mm/page_vma_mapped.c
>>@@ -269,14 +269,24 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>
>
>Hmm ... looks like there may still be a race here ...
>
>Current code picks the branch from the lockless PMD value:
>
>		pmde = pmdp_get_lockless(pvmw->pmd);
>
>		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
>			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>			pmde = *pvmw->pmd;
>			if (!pmd_present(pmde)) {
>				softleaf_t entry;
>
>				if (!thp_migration_supported() ||
>				    !(pvmw->flags & PVMW_MIGRATION))
>					return not_found(pvmw);
>				entry = softleaf_from_pmd(pmde);
>
>				if (!softleaf_is_migration(entry) ||
>				    !check_pmd(softleaf_to_pfn(entry), pvmw))
>					return not_found(pvmw);
>				return true;
>			}
>		}
>
>But after taking PTL, the PMD may already be a different non-present PMD
>type:
>
>CPU0: pmde = pmdp_get_lockless();   // sees PMD migration entry
>
>CPU1: remove_migration_ptes(src, dst /* device-private */)
>        ... via rmap_walk(dst) ...
>        page_vma_mapped_walk(&pvmw /* src, PVMW_MIGRATION */)
>          returns with PTL held for the PMD migration entry
>        remove_migration_pmd(new = dst page)
>          installs a device-private PMD
>        next page_vma_mapped_walk()
>          drops PTL via not_found()
>
>CPU0: takes PTL
>      pmde = *pvmw->pmd;            // now device-private PMD
>
>So when PVMW_MIGRATION is not set, current code can return not_found()
>before we even decode the locked PMD as a device-private entry.
>
>Commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
>device-private entries") made the
>
>device-private PMD <-> PMD migration
>
>transition possible.
>
>set_pmd_migration_entry() can replace a device-private PMD with a PMD
>migration entry, and remove_migration_pmd() can restore a PMD migration
>entry back to a device-private PMD when the new folio is device-private.
>

Nice catch.

But I think this matters if migration fail and restore the pmd to src folio.
When we successfully migrate to new folio, check_pmd() could catch it and
return not_found(). IIUC.

One more question: assume A unmap a folio, and B migrate the same one. 

If B set_pmd_migration_entry() first, then A won't see this PMD from
page_vma_mapped_walk(), IIUC. Then B failed to migrate, and restore the folio
as this PMD migration entry is there. So A should check the status after
unmap, right? Would it see unstable status?

I am a little lost what is the correct way to do here.

>Maybe decode the locked softleaf entry first, before the migration-only
>checks? Something like this on top:
>
>---8<---
>diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>index 17dff8aab9f9..97babd408dba 100644
>--- a/mm/page_vma_mapped.c
>+++ b/mm/page_vma_mapped.c
>@@ -249,10 +249,18 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
> 			if (!pmd_present(pmde)) {
> 				softleaf_t entry;
>
>+				entry = softleaf_from_pmd(pmde);
>+				if (softleaf_is_device_private(entry)) {
>+					if (pvmw->flags & PVMW_MIGRATION)
>+						return not_found(pvmw);
>+					if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>+						return not_found(pvmw);
>+					return true;
>+				}
>+

If we have to do this, I am afraid we can put all three cases handling
here...

Not necessary to put pmd_is_device_private_entry() handling in two places.

> 				if (!thp_migration_supported() ||
> 				    !(pvmw->flags & PVMW_MIGRATION))
> 					return not_found(pvmw);
>-				entry = softleaf_from_pmd(pmde);
>
> 				if (!softleaf_is_migration(entry) ||
> 				    !check_pmd(softleaf_to_pfn(entry), pvmw))
>@@ -266,7 +274,10 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
> 					return not_found(pvmw);
> 				return true;
> 			}
>-			/* THP pmd was split under us: handle on pte level */
>+			/*
>+			 * THP pmd was split under us, or device-private PMD
>+			 * changed under us: handle on pte level.
>+			 */
> 			spin_unlock(pvmw->ptl);
> 			pvmw->ptl = NULL;
> 		} else if (pmd_is_device_private_entry(pmde)) {
>--
>
>Anyway, that stuff is getting kinda messy now. Feels like it really needs
>a cleanup on top before it bites us again :)

Agree.

I haven't imagined this would be more complicated than I thought :-)

>Cheers, Lance

-- 
Wei Yang
Help you, Help me

