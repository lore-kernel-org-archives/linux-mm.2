Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62767606A320
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 17:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ITbY2xIN
Received: by kanga.kvack.org (Postfix)
	id 881046B0536; Tue, 20 Oct 2026 13:24:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 812BC6B0537; Tue, 20 Oct 2026 13:24:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D3826B0538; Tue, 20 Oct 2026 13:24:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 445836B0536
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:24:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B88F3C02DF
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 17:24:34 +0000 (UTC)
X-FDA: 85343678868.06.BA08ADD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2E26B40003
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 17:24:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ITbY2xIN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792517073;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jwGZahhsUmVXZY/Ar+27y5mt+AoWwAxI81rgF9PccxQ=;
	b=DmlHzShmLNSBoL1inKrwcNurMQsrnjhddxI+zF+moAEdd47lt7RtOK6h+gs44Wr85aUW4/
	sc43tz27rmbcHoVMGedXAkqcZORdRJOibRWEbhMTC0S7CENfCrNVS+Hiva9BCMot4B8ZrH
	84h3LLThmzaxZLbw4i8r7NcPulT8XeM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ITbY2xIN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792517073;
	b=ZenPw6LknZ99STQD6o6bSGL5mlArtQYMNK8KsZtYjZ2g+SX3wGDrICiKEY1g5hALlxalZi
	4g1vSUw9i9dDQUOItKnAAp+fbTSR49oLBanUK3c0vbrhXYjEsU67QS521jOpOM6o8T3wmR
	52F+O6XNhFrX+rgZktENiycOpkIt0f8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 476CF6022C;
	Tue, 20 Oct 2026 17:24:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 100281F000C9;
	Tue, 20 Oct 2026 17:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792517071;
	bh=jwGZahhsUmVXZY/Ar+27y5mt+AoWwAxI81rgF9PccxQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ITbY2xIN3pCE7c/fsGf8tTLhN21u/fq0ICnU8IaI8YdS04Gi5LavDzrm82epHarPT
	 HFOBo/d2ZgTwiHMQxQWhr58y8EbwsltlpuV+bxDmOxsKksZdKWn3jQzv/cgJa/cTv+
	 r563DyfsIywc2sloNk9Nj15eA/TT7dReYPNGkjwvZ1acX+5pSYdLownhcPnGaIh5ER
	 0JrNAKws/8vQoqgkVU1O/RFZxT4tSyjlasLt4pO02RtPCkwuM1XDOfhmdQQ0eyNOnn
	 WwiYtoPAYaytm5f7NnWL/2vnPzHsxm7+aSWmXLqduWpYsuumJEImBgZsk0vtTowl7M
	 aSDze2VHfmaVg==
Message-ID: <sashiko-outbox-179416@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/5] mm/page_alloc: snapshot the preferred zone
 against shrink rebuilds
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?R3JlZ29yeSBQcmljZSAoTWV0YSk=?= <gourry@gourry.net>, linux-mm@kvack.org
Cc: kernel-team@meta.com, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, mgorman@techsingularity.net, jiang.liu@huawei.com, Bessel.Wang@huawei.com
In-Reply-To: <20261019172346.3344005-4-gourry@gourry.net>
References: <20261019172346.3344005-1-gourry@gourry.net>
 <20261019172346.3344005-4-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 17:24:29 +0000
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2E26B40003
X-Stat-Signature: hqkjkrfaidudwdm4agchaxqjrnxp1eui
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792517073-963414
X-HE-Meta: U2FsdGVkX1+z1pwnsqdR+01fqp4JPDjF/QKToK4OVK/i+bmPBS1QZYiGUiiQqM/70LrpMVF7txiLRbpVNlfAaG7CIUHwtDC/2skzL7KCsFw+azQ3Ke2uqF54U61VSWv94HMaIAuNFAMObpGbh4XmS99vYIcLmdAHRZ5exN+e8M4G5DKUvtLe7UK6AjFTnmoJe/bGfe6+jhKd+UQQKq7cIpIgcqF8hWZPQ8upmr82z873zSF27lcB17M1hYzypZJUQbRhQFBSo2mTirDf+rSAmE6M1J5FbhO4SmOPas2q+A0CdDnWBdeE/xrbYS8mjuEGTRZ19Xp8KFCO+jR39WZ/2FMaTRkPmH6gzhzf3D3syjPal0m2VSnVf8AoKHQfHadSi+M3RHJpotRCv8EVMTjKjTbK7nCDOIK5RTJVLbKz0AZvwQaRR1bDg1P6mjbBKidY9on2SdMpkjXqAV/AFbJIYZ5YnMlpPF+5bJVOeFO7k3Ai81nKzSC6l3f7VzhoVmULL6G6xS9MHHlYg+N+BhrAXukZqWOnyOXnSgUEzyu43UhzAbaDMNkYfGVcQyDX4dS4HJmNapbPqGrkbelGi6Nc55F7lFVIg0SOT+iUpBbzr/jsZf2he+TwH7Z2xmvi8yL8APxRfSp3cx+ubw8n3PCMVdWH2Tk8qC0d/wVSLdGYmsKE5pKHN0g08Tk6kLIun1VYMxViZ5/zd6KvwYUTif/GvJogsAcQutsoD5DEfSS5k1P8I3ENNYU37eaExeWz3z5cGqh3XWDE60A7KezJoqA61G+sYxDNquvZHfNDcMs/aV8TDY06Tmjs958270zC0Z48m3BSnhTfauwbfyc4Yt9jHctfc71RSyp/Gze1QQ15SJDftY5Qy6DVnJsFZb1/AHezFOYHrVJJYK2lqTOQhuW2Vka0b1PX9NIz/1y9oGpa6tmUQtXpAAx7Ipl6pEYiiiv/qqW7O111iyhKVM0sbry
 pVDYXBuM
 EDL6oU5CZh83aWVoCErCvDqXd/pttuBq/1Qk5ZlgZLAVjSRO9GG5eLmnB7LIajRgmoouHYLkYxfvAdE1e7GN79az2WSrrYeQ3hrSUVPpOxcRQcZbal2mPiA3u9G0mrh76VT5/ERjMH3a3AjABijfRWPLEJCOlJvaRtrmY9PJg06f+K2orfso96jB6qn/QiIDnXyvrK1BBBz08nWSN0FxK6z2ds/KoPnH5ncOTOr19L0AAd+wHS40xjvjGdp95SjwxNvWq2EcSDyZfQ1XNgujO19KT9tQaM4m1F79l+4mD2TdC2ghIa8uUl9uM0zrYeDP4kenJ4rD3h+d/rX/dtMWOCr//tUaNQYuFHFEtfhWFYZaLJ8uOuAvr6AKw78vegPUCH4pHLeRb68vWyi+KawWmT+KvfZYJml7DIXCuRRzlYnnk4OIHbRFIdtIT+Ro+mKbKTjn8MZRuXVnzdyy3rp8inIMLzLT4+cMZu2xOFpl0D7/FvFif4aOMqPxieC1IrHrI5Q3aEod7gtzSPQLYGT7y7BWlSuvk0dH69LMOYC1iBA6wsmW3l1i4VBU3SgKfl5d1M3KZWG1H2o6z+Z8Qf6METlztmG7TNY/hY4FqrTpyZK5j3XnrD6eSMreiWshZDlB+8tfwuMiRNpsNIMByYsKzXyvSwf1bVPl0aBVxmcVuXIWtNmPmAe2Lm2u2pK4vEyj+gpZLviD3VD/WUsTtRagSAwqE8f7PUcT6u6lnEaUje1D8BQbq6vCuOLq63VeVe5G2KvvnzdYnPnAnSrWgCpViRJmF6w==
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
- [Medium] mm/page_alloc: unvalidated preferred_zone snapshot on zonelist r=
ebuild
--

commit 90d885c28b5b5085097cfbd698658be9e20b2d0b
Author: Gregory Price (Meta) <gourry@gourry.net>

mm/page_alloc: snapshot the preferred zone against shrink rebuilds

This commit snapshots ac->preferred_zoneref->zone once in
get_page_from_freelist() and alloc_pages_bulk_noprof() to prevent a NULL
pointer dereference if a concurrent zonelist rebuild overwrites the preferr=
ed
slot with a NULL terminator mid-walk.

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index aa3cd44fdaa5b..75a440ebcead6 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3807,12 +3807,21 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned i=
nt order, int alloc_flags,
>  {
>  	struct zoneref *z;
>  	struct zone *zone;
> +	struct zone *preferred_zone;
>  	struct pglist_data *last_pgdat =3D NULL;
>  	bool last_pgdat_dirty_ok =3D false;
>  	bool no_fallback;
>  	bool skip_kswapd_nodes =3D nr_online_nodes > 1;
>  	bool skipped_kswapd_nodes =3D false;
> =20
> +	/*
> +	 * A concurrent zonelist rebuild can NULL or replace this slot. Zones
> +	 * are never freed, so reading it once keeps a usable zone.
> +	 */
> +	preferred_zone =3D READ_ONCE(ac->preferred_zoneref->zone);
> +	if (!preferred_zone)
> +		return NULL;
> +
>  retry:
>  	/*
>  	 * Scan zonelist, looking for a zone with enough free.
> @@ -3862,7 +3871,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int=
 order, int alloc_flags,
>  		}
> =20
>  		if (no_fallback && !defrag_mode && nr_online_nodes > 1 &&
> -		    zone !=3D zonelist_zone(ac->preferred_zoneref)) {
> +		    zone !=3D preferred_zone) {
>  			int local_nid;
> =20
>  			/*
> @@ -3870,7 +3879,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int=
 order, int alloc_flags,
>  			 * fragmenting fallbacks. Locality is more important
>  			 * than fragmentation avoidance.
>  			 */
> -			local_nid =3D zonelist_node_idx(ac->preferred_zoneref);
> +			local_nid =3D zone_to_nid(preferred_zone);
>  			if (zone_to_nid(zone) !=3D local_nid) {
>  				alloc_flags &=3D ~ALLOC_NOFRAGMENT;
>  				goto retry;
> @@ -3932,7 +3941,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int=
 order, int alloc_flags,
>  				goto try_this_zone;
> =20
>  			if (!node_reclaim_enabled() ||
> -			    !zone_allows_reclaim(zonelist_zone(ac->preferred_zoneref), zone))
> +			    !zone_allows_reclaim(preferred_zone, zone))
>  				continue;
> =20
>  			if (!node_reclaim(zone->zone_pgdat, gfp_mask, order))
> @@ -3945,7 +3954,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int=
 order, int alloc_flags,
>  		}
> =20
>  try_this_zone:
> -		page =3D rmqueue(zonelist_zone(ac->preferred_zoneref), zone, order,
> +		page =3D rmqueue(preferred_zone, zone, order,
>  				gfp_mask, alloc_flags, ac->migratetype);
>  		if (page) {
>  			prep_new_page(page, order, gfp_mask, alloc_flags);
> @@ -5199,6 +5208,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, in=
t preferred_nid,
>  {
>  	struct page *page;
>  	struct zone *zone;
> +	struct zone *preferred_zone;
>  	struct zoneref *z;
>  	struct per_cpu_pages *pcp;
>  	struct list_head *pcp_list;
> @@ -5247,6 +5257,11 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, i=
nt preferred_nid,
>  	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &gfp, &a=
lloc_flags))
>  		goto out;
> =20
> +	/* Read once; see get_page_from_freelist(). */
> +	preferred_zone =3D READ_ONCE(ac.preferred_zoneref->zone);
> +	if (!preferred_zone)
> +		goto failed;
> +
>  	/* Find an allowed local zone that meets the low watermark. */
>  	z =3D ac.preferred_zoneref;
>  	for_next_zone_zonelist_nodemask(zone, z, ac.highest_zoneidx, ac.nodemas=
k) {
> @@ -5260,8 +5275,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, in=
t preferred_nid,
>  			continue;
>  		}
> =20
> -		if (nr_online_nodes > 1 && zone !=3D zonelist_zone(ac.preferred_zonere=
f) &&
> -		    zone_to_nid(zone) !=3D zonelist_node_idx(ac.preferred_zoneref)) {
> +		if (nr_online_nodes > 1 && zone !=3D preferred_zone &&
> +		    zone_to_nid(zone) !=3D zone_to_nid(preferred_zone)) {
>  			goto failed;
>  		}
> =20
> @@ -5269,7 +5284,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, in=
t preferred_nid,
>  retry_this_zone:
>  		mark =3D wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK) + nr_pages =
- nr_populated;
>  		if (zone_watermark_fast(zone, 0,  mark,
> -				zonelist_zone_idx(ac.preferred_zoneref),
> +				zone_idx(preferred_zone),
>  				alloc_flags, gfp)) {
>  			break;
>  		}

[Severity: Medium]
What happens if build_all_zonelists() replaces ac->preferred_zoneref->zone
with an ineligible zone before preferred_zone is read?

After prepare_alloc_pages() or __alloc_pages_slowpath() initializes
ac->preferred_zoneref via first_zones_zonelist(), a concurrent zonelist
rebuild can overwrite that slot with a zone whose index exceeds
ac->highest_zoneidx (such as ZONE_MOVABLE for a GFP_KERNEL allocation) or a
zone on a node excluded by ac->nodemask.

Both get_page_from_freelist() and alloc_pages_bulk_noprof() only check
preferred_zone for NULL without checking zonelist_zone_valid(). Inside the
zonelist walk, for_next_zone_zonelist_nodemask() reloads
ac->preferred_zoneref->zone into zone and skips it when
!zonelist_zone_valid(zone, ac):

	z =3D ac->preferred_zoneref;
	for_next_zone_zonelist_nodemask(zone, z, ac->highest_zoneidx,
					ac->nodemask) {
		struct page *page;
		unsigned long mark;

		if (unlikely(!zonelist_zone_valid(zone, ac)))
			continue;

However, preferred_zone remains pointing to the rejected zone:

1. In alloc_pages_bulk_noprof(), zone_watermark_fast() receives
   zone_idx(preferred_zone) as highest_zoneidx. If preferred_zone was
   replaced by ZONE_MOVABLE while ac.highest_zoneidx is ZONE_NORMAL,
   __zone_watermark_ok() and zone_watermark_fast() will index
   zone->lowmem_reserve[ZONE_MOVABLE] instead of
   zone->lowmem_reserve[ZONE_NORMAL]. And if preferred_zone was replaced by=
 a
   zone on a node outside ac.nodemask, the check
   zone_to_nid(zone) !=3D zone_to_nid(preferred_zone) will abort the bulk
   allocation via goto failed as soon as it visits the first valid zone in
   ac.nodemask.

2. In get_page_from_freelist(), if preferred_zone was replaced by a zone on=
 a
   disallowed node, visiting the first valid zone in ac->nodemask sees
   zone !=3D preferred_zone and zone_to_nid(zone) !=3D zone_to_nid(preferre=
d_zone),
   prematurely clearing ALLOC_NOFRAGMENT and jumping to retry. It also pass=
es
   the disallowed preferred_zone to zone_allows_reclaim() and to
   rmqueue() -> zone_statistics(), misaccounting local allocations on the
   first valid node as NUMA_MISS and NUMA_FOREIGN.

Should preferred_zone be validated with zonelist_zone_valid() (or set from
the first valid zone encountered in the loop) so that an invalidated slot is
not used as the preferred zone?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019172346.3344=
005-1-gourry@gourry.net?part=3D3

