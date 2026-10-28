Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9CCF606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DyBfNOG9
Received: by kanga.kvack.org (Postfix)
	id ADCB56B05C7; Wed, 28 Oct 2026 11:47:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A66616B05C8; Wed, 28 Oct 2026 11:47:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9550E6B05C9; Wed, 28 Oct 2026 11:47:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 597C56B05C7
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:47:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E48C1A6AC0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:47:50 +0000 (UTC)
X-FDA: 85372465500.23.AD307EC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 51A3D2000F
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:47:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DyBfNOG9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793202469;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gm5Pa+SfEN25ZsoL/x1th6axKtBUPsnPTC476m8ttcQ=;
	b=QE++Un4LPx4uAaMLGA8BAFmr7kVpGxB4yN+xLAA8nJ5bw+N0JZqu3gLJjh44v60omQmhwU
	HKdrzKXpihULBSF9pKqD1063meIUdPZt/otiVXJemcNga3s8rhUjL/1ZMnO1FN7BGA+IGx
	HNCA/wmSvXWaN+TELe/IKsGlIHACXLU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DyBfNOG9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793202469;
	b=KT7ZW+IKiNJgLfe3CxcsOnDw28n9+giK2lrFfuaEesJW4D7VpkHx0u6hkJrk+MgGSF/MYM
	4rM00S0ej+sbRLzN62e0MtZ5goI13JHkGNRQufFHnAccPMoQWG9PglSqyR20ijLRDoa77L
	+2Q4riDwpK3cyOsPC+dJqQ2O9AscevA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D0B741B41;
	Wed, 28 Oct 2026 15:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39B01F01825;
	Wed, 28 Oct 2026 15:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793202468;
	bh=Gm5Pa+SfEN25ZsoL/x1th6axKtBUPsnPTC476m8ttcQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DyBfNOG9ElvZByyqlqRmv5MAICySVTvwFGUUaSNYtJ/MsRMK1SBjemKRQ3X2GPK88
	 Q+d8yxYMTovWnOrKg+dr/1QBxPQC9bH/7DKGv/ABHGJcWUVFovCrB1OERVOX9pvyxh
	 L4vu7+4sywCkgAao01diNw1cGp8lQsn9WJU5DRvFlwgWpQky+6twNiSac1kTKMFpS0
	 oXnUF/RAWjHcCIN1GgI+c/pu2Dao3HTesiqwnfLI/IwS/H0bccfl1AXAoHQptoDdJb
	 EC6K/xi8vqpjYlrAox2hggMaCmt2uMytG2WJp0vrvSplOpHbGlnTNl80o2RXqpjtX5
	 sr0FjfubHe3tA==
Message-ID: <sashiko-outbox-188081@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 9/9] mm/page_alloc: check pageblock pfns under span
 seqlock
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?Vmxhc3RpbWlsIEJhYmthIChTVVNFKQ==?= <vbabka@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Zi Yan" <ziy@nvidia.com>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Mike Rapoport" <rppt@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Oscar Salvador" <osalvador@suse.de>,
 =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>
Cc: "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Johannes Weiner" <hannes@cmpxchg.org>, linux-mm@kvack.org, "Josef
 Bacik" <josef@toxicpanda.com>
In-Reply-To: <20261027-pgalloc-ai-hotfixes-v1-9-9c7d1aca801e@kernel.org>
References: <20261027-pgalloc-ai-hotfixes-v1-0-9c7d1aca801e@kernel.org>
 <20261027-pgalloc-ai-hotfixes-v1-9-9c7d1aca801e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 15:47:47 +0000
X-Rspamd-Queue-Id: 51A3D2000F
X-Stat-Signature: 8x8ygt5ey6qzhqqoy68psd3nqxkpo6ug
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793202469-132147
X-HE-Meta: U2FsdGVkX18JMSVk5rafsIs3GPUW4va25iFMPduMlPqvESeJv7QahzIoB2B48k+wbfeB8fF38GRfeZQDfRzig7u/4GW8YoO9N4jJca6YjQZWijWbflsako3Di01RKA1uF+zR8QV2wC4K5QocwB6+WVCXjuZ9YQ32TTUiZ68nIXF1z2F4AhSfzcolF6jO9CiCvX/mWqvOTtwPxl2obRzrlHuCni4oIjUjqksXR7pjzmyryWfvlhQHchA3/p/9QodLq4GSF9y53zSUAHuWS6xDmHLiVlpy5Xsx0utETWn0jbyrEX2wztHhzzc75ShweGfwOSVcki/Gc0kVLuAHxUubfEQw8I3LioU67K/9QZDSrVU2m3ma57dgCzKrTTJNMNJJoO9Qg47zzhF97Z4gh8vo2TV1PZoWHtbpjuvUcieihNKTqxdosp7iCKfqC+4HMLVrvLJshy1KpDgJTWSohz7NOJe6qZlnp/V22ctiJgG3I2Nqh5H00OPB2Yv0qw1SEnM8y5ByYDDCMxTXYGLb3M/gEyWnTX5EWHOlgoWigxuVcNAxgTL6Edclv6UXXUvPerRmVLh53ntChM7CdbuU+L32/Is8crjyxGgbP38wPye1sN9GWM2i/ALJFhaysusTdOzsWnOzOE/jFbEbARzJhkteS+Aw52pINIsVW4+fs7RmcJVEcV2MWTc0yT0NZ+WrCw6EvCCoBkzZjfyZGOVUhNjWcQEwb0PE3pzyM/H/S7zgae1honChANMVlg6Dqw8Fr2mGtBZ2GMuT6s9ZtoLASqNMMsjY4LZt7hGsi+erKFqUIRNX4RZhkan4rEBMgODfgyijT1m72jFIAPDcIOS+P+zEXH0JKnxmLMN1S9iEopoevGMjP2192AiziHcahOfyJxHIwAQ1ZE/jY/j55sZ9N3hKLWZOSx4OKDL14OOj7zPcCEq68r93fpMrnRvV1Ycm6ii5Cslw7srG75MAHY2p0gq
 DKCQEdx/
 zK2ow5ISzfOSmSK75fzSZkgny148T6ugyl4Ftz5aGxx59uc7Pn9MJwFR8OA8RrTrEw4Sj7Fa7SEhebidGBNt6yHHUoo7AgeIYkAN22xzQt3Ssg3OMrMI9m84xjqfONWZPwFI+YvycQcha10Oe3Nmr0UNbrq37NOLFhm4q6ujryBMkdqzKrSgB2FwEdYekLkxB+dcL/38EGoW0DiXu+XTfBy70dWE0Ah/CJ0lmz4MHu0WxTO+SUkbq56XhIRL7Qy/fobRUrYjQNiMBiUnpssCzJYgAscbqNne/5PMX6vF/JLw31EA5CKBnMzJapbosnHy0Rk+teO6YS7kTYyO8DgRVkrfAs3CY4Wpx+C7CpGe9HNf63osKiodpvCX4meVsjVYsUEaI+wEzUBjwc8j3Z32Zff2J7JUusOT4DGB1xNQMBPZjJBnaOFa95f/Ir1Ro8cEiCz3DZD1FhicfcILvKsIkLVa8sbTG21m45v+BnOPHhyg8N37hweIuG4KSKcEv6BugzK0tJXz4+RoEbXXTPKehcqeN6HmfeXEbnk2ugAHYuMMsdjKPERELUeZjHuOuOQKacNpwR1qgbb7vSknTklhL64AojWVUNBAfmIB3aAnFGBYyV8ZrmJw2mKWLw5rqJAl83RqUBZWRBqBvcSJ0ysAzTgAClwadG4gldmTAWHuyKLCwjttE7JuC7KXLvePHb66Sdh7Z6Auy5FQbxIjMlmF7pCn+/rE1nGFESlDBqoPS269OwI0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mm: NMI deadlock and invalid wait context in zone_spans_pfn_stable=
()
--

commit 46b6bec2b8c6bc868d5bf37583c51e88e5fe1429
Author: Josef Bacik <josef@toxicpanda.com>

mm/page_alloc: check pageblock pfns under span seqlock

This patch adds zone_spans_pfn_stable() to read zone->zone_start_pfn and
zone->spanned_pages under zone->span_seqlock when checking pageblock PFNs in
get_pfnblock_bitmap_bitidx() under CONFIG_DEBUG_VM.

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 8f8885165045b..f7bb0d59efc81 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -357,6 +357,21 @@ static __always_inline bool is_standalone_pb_bit(enu=
m pageblock_bits pb_bit)
>  	return pb_bit >=3D PB_compact_skip && pb_bit < __NR_PAGEBLOCK_BITS;
>  }
> =20
> +/* Memory hotplug can resize the zone while we look at its span */
> +static bool __maybe_unused zone_spans_pfn_stable(struct zone *zone,
> +						 unsigned long pfn)
> +{
> +	unsigned int seq;
> +	bool ret;
> +
> +	do {
> +		seq =3D zone_span_seqbegin(zone);
> +		ret =3D zone_spans_pfn(zone, pfn);
> +	} while (zone_span_seqretry(zone, seq));
> +
> +	return ret;
> +}
> +
>  static __always_inline void
>  get_pfnblock_bitmap_bitidx(const struct page *page, unsigned long pfn,
>  			   unsigned long **bitmap_word, unsigned long *bitidx)
> @@ -370,7 +385,7 @@ get_pfnblock_bitmap_bitidx(const struct page *page, u=
nsigned long pfn,
>  	BUILD_BUG_ON(NR_PAGEBLOCK_BITS !=3D 4);
>  #endif
>  	BUILD_BUG_ON(__MIGRATE_TYPE_END > PAGEBLOCK_MIGRATETYPE_MASK);
> -	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
> +	VM_BUG_ON_PAGE(!zone_spans_pfn_stable(page_zone(page), pfn), page);

[Severity: High]
Can calling zone_spans_pfn_stable() here cause an NMI deadlock or an invalid
wait context when freeing or allocating pages through the nolock paths with
CONFIG_DEBUG_VM and CONFIG_MEMORY_HOTPLUG enabled?

free_pages_nolock(), free_frozen_pages_nolock(), and alloc_pages_nolock() c=
an
be called from NMI, hardirq, or while holding a raw_spinlock_t. On the free
path, __free_frozen_pages() calls get_pfnblock_migratetype() before checking
can_spin_trylock():

free_pages_nolock()
  ___free_pages()
    __free_frozen_pages()
      get_pfnblock_migratetype()
        __get_pfnblock_flags_mask()
          get_pfnblock_bitmap_bitidx()
            zone_spans_pfn_stable()
              zone_span_seqbegin()

In mm/page_alloc.c:__free_frozen_pages():
	zone =3D page_zone(page);
	migratetype =3D get_pfnblock_migratetype(page, pfn);
	if (unlikely(migratetype >=3D MIGRATE_PCPTYPES)) {
		if (unlikely(is_migrate_isolate(migratetype))) {
			free_one_page(zone, page, pfn, order, fpi_flags);
			return;
		}
		migratetype =3D MIGRATE_MOVABLE;
	}

	if (unlikely((fpi_flags & FPI_NOLOCK) && !can_spin_trylock())) {
		add_page_to_zone_llist(zone, page, order);
		return;
	}

On the write side, mm/memory_hotplug.c:zone_set_span() updates the span usi=
ng
write_seqlock_irqsave(&zone->span_seqlock, flags), which disables regular
interrupts but cannot mask NMIs:

	write_seqlock_irqsave(&zone->span_seqlock, flags);
	zone->zone_start_pfn =3D start_pfn;
	zone->spanned_pages =3D spanned_pages;
	write_sequnlock_irqrestore(&zone->span_seqlock, flags);

This seems to introduce three regressions on the nolock paths:

1. If an NMI interrupts zone_set_span() while the sequence count is odd and
the NMI handler calls free_pages_nolock(), free_frozen_pages_nolock(), or
alloc_pages_nolock() on a page in that zone, read_seqbegin() in
zone_span_seqbegin() will spin forever waiting for the interrupted writer on
the same CPU.

2. With CONFIG_PROVE_LOCKING enabled, read_seqbegin() calls
seqcount_lockdep_reader_access(), which records a non-trylock lock_acquire()
on span_seqlock and triggers a lockdep inconsistent NMI usage splat once
zone_set_span() has used the lock.

3. On CONFIG_PREEMPT_RT, zone->span_seqlock is a seqlock_t backed by a
sleeping spinlock_t. If a concurrent writer is active (seq & 1),
read_seqbegin() takes spin_lock(&zone->span_seqlock.lock) via
__seqprop_spinlock_sequence(), attempting to acquire a sleeping lock from
NMI, hardirq, or raw_spinlock_t context.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027-pgalloc-ai=
-hotfixes-v1-0-9c7d1aca801e@kernel.org?part=3D9

