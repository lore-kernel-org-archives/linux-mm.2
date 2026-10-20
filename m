Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CA4C606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 17:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oQTPChcn
Received: by kanga.kvack.org (Postfix)
	id 26EE16B0535; Tue, 20 Oct 2026 13:24:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 218736B0536; Tue, 20 Oct 2026 13:24:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1067A6B0537; Tue, 20 Oct 2026 13:24:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D69196B0535
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:24:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6CFE61C2179
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 17:24:32 +0000 (UTC)
X-FDA: 85343678784.16.A19D996
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id B0763C000D
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 17:24:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oQTPChcn;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792517070;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4xJJmU5rHTBbqNB8qX0H3I1zlzmfhbUR6pXqrPeXgTI=;
	b=lRDRlTT5TFuO36rCy2MxLrxXgAnZbmg69xZj2pK9YRzTd2hYJ6uLZ8DBGdQR+K9gUOJ5Mx
	4ypyc4YxT2swuAbCW88LqaYFmeqh1X3jr9ji1ToWX6cbYolXmdkRsVtChxvXk2LqmM9rd3
	ZA4MdEKs0mwnIGAgZsIMcYNQbA4Q3xo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oQTPChcn;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792517070;
	b=aKA+C6N7FxE1F2u2D9dYL122v6oJqqrHQDnbw3DIEVZHLyHP19HwvrgYgB/OHVTztEUszk
	x3E54IoAJXi0kIv13gKrDs68YyacHG7xkrtUInlAZTztCCR4stvYW+2XBEKYBztD2Owtk/
	Xm3uXuYOFgsjgMivl43g+4oAFn3ILHE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D219411BD;
	Tue, 20 Oct 2026 17:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168DE1F000C9;
	Tue, 20 Oct 2026 17:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792517069;
	bh=4xJJmU5rHTBbqNB8qX0H3I1zlzmfhbUR6pXqrPeXgTI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oQTPChcn7BFZYUgyX418j3W9jezUCavmm2OyebTNhTU5QEEF2b1YL0R/8nrKJUS+S
	 6Vwcmbzvy8FPljpURoDFE74V5UIWI+Erdvfdinl+sJKtxg6YoK6QDsfU1SxEvFm4Aw
	 AJ32RgHCf4HOzYFtN3F/h6i4ftA0aotK8zVZpCo+gXLGYOwNsnu1P+l8S9bdPFAQHo
	 IuNx3+A2ABONhLdr6jwfl+D0k8GxcwTdjYA4JETiBKOW5OkCed8AN/SwGseR9B9KwG
	 oazqdrcaz/I1xXIz4fm2OxQIkvKHBobvTGEoCwTver3iI0nQvTsIEDXFl3isPp/E35
	 twWMeLLNMmAXw==
Message-ID: <sashiko-outbox-179415@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/5] mm/page_alloc: validate zonelist slots against
 concurrent rebuilds
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?R3JlZ29yeSBQcmljZSAoTWV0YSk=?= <gourry@gourry.net>, linux-mm@kvack.org
Cc: kernel-team@meta.com, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, mgorman@techsingularity.net, jiang.liu@huawei.com, Bessel.Wang@huawei.com
In-Reply-To: <20261019172346.3344005-3-gourry@gourry.net>
References: <20261019172346.3344005-1-gourry@gourry.net>
 <20261019172346.3344005-3-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 17:24:27 +0000
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B0763C000D
X-Stat-Signature: b4r9jhrs5g7swri6km7o89x9dhjotesx
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792517070-936688
X-HE-Meta: U2FsdGVkX1+8kWy7S0y65HFuiZ+7A9bu4WCqE05cWRLYU7tuSStmuAK+B+3sfryxDNyBWhMdSH69/Wk1qN23yY4IlEFkQPxJQHU0FyR5xjo/P3MWH8F/20rsr+bg0qXkB9rH1mk8FuNBeSHHg0+qFzyJA0/r+TChHvK0rwyj1l6DspyiBzvNe9F+ZB0sfUuw6n7TK68QeV24Uk9x8j6oHeC84/YxGLmdEpaOkl4No4uFtbXBu9/2iDrKqNSL33kp2sPfu9bT/1Xl/RERXWdX3KzQA+jl2ZJjAaiBDOFQOkhRSmoZDylcaXeDMNldZBRmgsXtGsfZFhzlTyprkLX7DtNsggVooy8DfS3R4gpsBHq/Mzlx1BBd2yCqW4oQvp2H32w9qojxXnbPT0iLANRnOrhAEpdAGDtQ7n9T6bn3R+B/waFSWvSMvZla4G5Mf9VvkKm00BfQ86TKL6F64bo4QXM+qrsKku4kri3ZHBmmNnCCnWZwuzQGb8gEBYwBqgQgmH7K1Vk5AerKC6ne6AbHdhrvVZZTdSobsI9duCPR02x7oekzQdB+XDpQVTsgbZr9ypKJvnVIPep5mLZCr7ERFGZhVN6oyVODYEvf2WtY9vngr9p2o2Yn6uTHsviK5emStKXjbL1AC9TZmOdPjDOKa9L7paUt7mAQmgRwhwSRgRshY+cD3ENvT/5vWoPmg3bRD0igzzwrgH9l4zD0RXNbMqM3QObksE7V5hOrh30FcfnQjs8iebPsF+zfn+hkR1LkCSGJg+V2O5Ay+z/tpia44TV8aik2Q3EDBwbOyf6tQyR4Nl4goI98hO0k+lG+iWxLvHYrx++F375t+LCvTVCkblLQDxXpeKDMbgHLzesJJH5VH9HdYLhB464ROkTRzBruPQwxefSS9KKzGrRot/rl23IIJ4RyTihWupI6GEZAut6F9I91j9McNtexo2F41TKVmb8Sq64QISBlRJiJZtc
 fPl4mjGI
 sGhL9f1QLOb0k9A5/YVjRiiehdCP3G/tufM/8Krrw0c2nX9qKzaJsHy8Vnf9RCt+cDMkX7M9CKk+me1VOvRMCAUqZKZLUQrmEMPEQd/gtxLghaNf0VtaRcu592EfzPXDjc39363XSOj4t5kUC0aciZxFCLGm9PZ28HZb+YRfjaBIniBLf7JNOPnoekoZPQUruc2pNfO+h6FTZU/pXqrKIaNihj5oTNvKumG9F0BrhH7CUQo+w76CAYilt4Hc+p5gw7MsSz94dI/kuRBN2Gquf92uL+pK/xdMZfzQ6wLzWmv/2eUr+9h0Yp3vGj5hYMsrA/KkYoXU+TTUT4vFwXWNr+K0FjiX7MolE6oKN4zyQLT70JcekC4LaMtwXNpEd1r+P4S7JVXYxpm/w/nvgMGdjVbAyHtMF7YO92qPJAO6yIlHpviqwhckNUJYxvGIHaPKpfXjLSKQ8acKGoC6u0vkfqaJRYVsTylVgps6RiGif4tv7PXmyzuH0HjAkrdJREelk/uQ0T9uZyprGGk+Ej4qkgoPmmmzA3OUFu9NZQ7SU4HQZJfbBeggB6HIWwRR/5/RGF/5lubGFRPLP2hbDIK3P8z1y3iY085FBCq3wdMYVnHJ+ZXqK3TtbBC1z4cJehgynv8wwktaDku4FGqlvaCRtVZLaoyg16MgCX/9Rf1aPfTt75F6V3RtTiK0YS9eVFnbcGkC/SF95bSkHg+F3Ba9Kv1UOHGGG9FgEOnZqWFAj5FzHwk2ErxdVePbxIji+3Qj4cVLgAjZwdtBhrFROhv5tgs3NtnlBeuNaqRZP
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
- [Medium] mm/page_alloc: stale preferred_zoneref after zonelist_zone_valid=
() skips slot
--

commit c301c4c2a3915ab844aff8ba7e717c949c45cabd
Author: Gregory Price (Meta) <gourry@gourry.net>

mm/page_alloc: validate zonelist slots against concurrent rebuilds

This commit adds zonelist_zone_valid() to recheck the loaded zone pointer
against highest_zoneidx and the nodemask in get_page_from_freelist() and
alloc_pages_bulk_noprof(), preventing in-flight zonelist walks from using an
ineligible zone after a concurrent hotplug rebuild shifts zonelist slots.

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index c7125f6693574..aa3cd44fdaa5b 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3784,6 +3784,19 @@ static inline unsigned int alloc_flags_cma(gfp_t g=
fp_mask)
>  	return ALLOC_DEFAULT;
>  }
> =20
> +/*
> + * The zonelist can be rebuilt in place while it is walked, so the itera=
tor's
> + * filters may have passed a slot that now holds a different zone. Reche=
ck the
> + * zone itself.
> + */
> +static inline bool zonelist_zone_valid(struct zone *zone,
> +				       const struct alloc_context *ac)
> +{
> +	if (zone_idx(zone) > ac->highest_zoneidx)
> +		return false;
> +	return !ac->nodemask || node_isset(zone_to_nid(zone), *ac->nodemask);
> +}
> +
>  /*
>   * get_page_from_freelist goes through the zonelist trying to allocate
>   * a page.
> @@ -3812,6 +3825,9 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int=
 order, int alloc_flags,
>  		struct page *page;
>  		unsigned long mark;
> =20
> +		if (unlikely(!zonelist_zone_valid(zone, ac)))
> +			continue;
> +
>  		if (cpusets_enabled() &&
>  			(alloc_flags & ALLOC_CPUSET) &&
>  			!__cpuset_zone_allowed(zone, gfp_mask))
> @@ -5236,6 +5252,9 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, in=
t preferred_nid,
>  	for_next_zone_zonelist_nodemask(zone, z, ac.highest_zoneidx, ac.nodemas=
k) {
>  		unsigned long mark;
> =20
> +		if (unlikely(!zonelist_zone_valid(zone, &ac)))
> +			continue;
> +
>  		if (cpusets_enabled() && (alloc_flags & ALLOC_CPUSET) &&
>  		    !__cpuset_zone_allowed(zone, gfp)) {
>  			continue;

[Severity: Medium]
When zonelist_zone_valid() rejects and skips the initial slot at
z =3D=3D ac->preferred_zoneref after a concurrent online_pages() ->
build_all_zonelists() shifts an ineligible zone (such as ZONE_MOVABLE for a
GFP_KERNEL request, or a zone from a node outside ac->nodemask) into that
slot, does ac->preferred_zoneref remain pointing at the rejected slot for t=
he
rest of the walk?

In both get_page_from_freelist() and alloc_pages_bulk_noprof(), the walk
starts at z =3D ac->preferred_zoneref (and in the follow-up commit
"mm/page_alloc: snapshot the preferred zone against shrink rebuilds",
preferred_zone =3D READ_ONCE(ac->preferred_zoneref->zone) is snapshotted be=
fore
the loop without validating or updating it when the initial slot is skipped=
).

In alloc_pages_bulk_noprof(), subsequent iterations still consult
ac.preferred_zoneref for the local-node check and watermark check, as well =
as
for statistics at the end of the function:

mm/page_alloc.c:alloc_pages_bulk_noprof() {
    ...
		if (nr_online_nodes > 1 && zone !=3D zonelist_zone(ac.preferred_zoneref) =
&&
		    zone_to_nid(zone) !=3D zonelist_node_idx(ac.preferred_zoneref)) {
			goto failed;
		}

		cond_accept_memory(zone, 0, alloc_flags);
retry_this_zone:
		mark =3D wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK) + nr_pages - n=
r_populated;
		if (zone_watermark_fast(zone, 0,  mark,
				zonelist_zone_idx(ac.preferred_zoneref),
				alloc_flags, gfp)) {
			break;
		}
    ...
	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
	zone_statistics(zonelist_zone(ac.preferred_zoneref), zone, nr_account);
}

If a zone from a disallowed node was shifted into ac.preferred_zoneref, the
node comparison against zonelist_node_idx(ac.preferred_zoneref) will trigger
on the first allowed zone in ac.nodemask and jump to failed, aborting the
bulk allocation into the single-page fallback. Additionally,
zone_watermark_fast() receives zonelist_zone_idx(ac.preferred_zoneref) as
highest_zoneidx, indexing zone->lowmem_reserve[] with the rejected zone's
index (for example, ZONE_MOVABLE for a GFP_KERNEL allocation).

Similarly, in get_page_from_freelist(), later iterations still reference
ac->preferred_zoneref:

mm/page_alloc.c:get_page_from_freelist() {
    ...
		if (no_fallback && !defrag_mode && nr_online_nodes > 1 &&
		    zone !=3D zonelist_zone(ac->preferred_zoneref)) {
			int local_nid;

			local_nid =3D zonelist_node_idx(ac->preferred_zoneref);
			if (zone_to_nid(zone) !=3D local_nid) {
				alloc_flags &=3D ~ALLOC_NOFRAGMENT;
				goto retry;
			}
		}
    ...
			if (!node_reclaim_enabled() ||
			    !zone_allows_reclaim(zonelist_zone(ac->preferred_zoneref), zone))
				continue;
    ...
try_this_zone:
		page =3D rmqueue(zonelist_zone(ac->preferred_zoneref), zone, order,
				gfp_mask, alloc_flags, ac->migratetype);
}

Could this cause get_page_from_freelist() to treat the first valid zone on
the allowed node as remote and prematurely strip ALLOC_NOFRAGMENT, as well =
as
pass the rejected zone to zone_allows_reclaim() and rmqueue() ->
zone_statistics() (and prior to the follow-up commit snapshotting
preferred_zone, risk a NULL pointer dereference if a concurrent offline
shrinks the zonelist so ac->preferred_zoneref->zone becomes NULL)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019172346.3344=
005-1-gourry@gourry.net?part=3D2

