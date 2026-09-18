Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27070C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 18:47:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D2506B008C; Fri, 18 Sep 2026 14:47:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3801B6B0093; Fri, 18 Sep 2026 14:47:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 292C66B0095; Fri, 18 Sep 2026 14:47:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 020256B008C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:47:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DDF46A6399
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 18:47:12 +0000 (UTC)
X-FDA: 85227765504.30.EAB82FB
Received: from outbound.mr.icloud.com (mr-2004d-snip4-11.eps.apple.com [57.103.69.251])
	by imf03.hostedemail.com (Postfix) with ESMTP id DEA1E20009
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 18:47:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=ubOPqoMp;
	spf=pass (imf03.hostedemail.com: domain of bfguo@icloud.com designates 57.103.69.251 as permitted sender) smtp.mailfrom=bfguo@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789757231;
	b=k9L5OHjMLZ9pCyVoqFWHZXzfCvheeLFXlc6fEzDB9cQBiCiEotmUfjMGSw2qtBEF6d51Ik
	DJmYU5bWTAU6iiQv9IJX2Elry9l9t16tuT44RMC5YCtLfEQBR6bovtbOI2yvde7DsPqs5D
	qgHFQ+hH4SrLA19KUM8F3f0s8bRPD6Q=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=ubOPqoMp;
	spf=pass (imf03.hostedemail.com: domain of bfguo@icloud.com designates 57.103.69.251 as permitted sender) smtp.mailfrom=bfguo@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789757231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=98HzfH5LQbU4THhLy0oNL83Rvid2RqxSwBxj16wy9gY=;
	b=xhQ2qMeYmr0GqJxVsdar9aFwTGxuBdaOL7fvmoJjCP+Iwea11pdsisKkblghv5zqLdfdhA
	32Gz32ijDs6dY6OZoFqQPT8YyINgywPxQldeugDGPf+rS98oIfMo1jFsdl6o3OCEV+W+Ra
	s1i48Geuuj+Is+8k3VSbtvy7pikDCOI=
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-5 (Postfix) with ESMTPS id 6A3DE180060B;
	Fri, 18 Sep 2026 18:47:04 +0000 (UTC)
X-ICL-RepId: 01a0b5d7-f56b-7dff-a0c5-f60fe72f6cd7
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhOAEMGWQdeCEwCQwZYClBcHA4PUQxHH3kRUAFYHlZeWhdeTVEPDxlaFFwYU0VRH1RYQQ4KWgtQUR1fAgoERwRbF0YDU0VfAhcRUAFYHlZeWhdeTUcfQE1iSQFaGVscQBdKbk1TDw8ZWhRcGFNFUR9UWF4EU1YOEUhKcQtuD38CZkB5CG40YzB7MX0qcSp8N34tfEB6KAJOGQxKHVJWWxNVF0YJ
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1789757229; x=1792349229; bh=98HzfH5LQbU4THhLy0oNL83Rvid2RqxSwBxj16wy9gY=; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=ubOPqoMp/atbHlEh7GHc6fkUdCug91L6fesDjA6beg98TEIkbxnkqW64zNi7QS6KThnW9mX7aZMSjP1gGcnfiayB7UxtrBp13xWDJZ4cOdoKSjiz6ubNQabPlSWUBN8ra7RTPRw2j5SB+dOvag9cYenoZrSiKzW8npirQ3+Qtc051R1HO4by91xgU8cBZQmdWh2dY6ICzjBcjK0PAjZS2Op6OT+sWH/hw9fMmSCaUa9TZ/A7mE7foRMHAuLnrJbV5Pc6a1m4fkRakdF4J3hAMfVAnEVK8Sdd0FYBwcz3wsW5fEvigJCrBokq3gBBRnkGdXqVDd3mKQ2v617TD50CkQ==
mail-alias-created-date: 1772519804199
Received: from BINGFANGGUO-MC0 (unknown [17.156.200.36])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-5 (Postfix) with ESMTPSA id 91FE918002DA;
	Fri, 18 Sep 2026 18:46:56 +0000 (UTC)
Date: Sat, 19 Sep 2026 02:46:52 +0800
From: Bingfang Guo <bfguo@icloud.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: bingfangguo@tencent.com, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] memcg: manipulate memcg private ID references by ID
Message-ID: <aq2BfYdMr_8JeY_Q@BINGFANGGUO-MC0>
References: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
 <20260918-bingfangguo-memcgid-rework-v1-3-5bbf3220d88f@tencent.com>
 <aq1_Qhid7-62pHcW@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq1_Qhid7-62pHcW@linux.dev>
X-Proofpoint-GUID: DGpDKgWQtL7ACZVDH7PUneR8AkuGP2kz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDI3MCBTYWx0ZWRfX9q2xu2/8WnDX
 gJD8ZkG00jeCoe0rzAEw64JkJfAcT/YyR4S7u9g7wA3hvTRlslRE6UDJoJ9VPp0PXHXmb4XDL+C
 8mGY5kZMHjiO6No9vsrzNwD97RhtcJWboI3JNyPEkJ8oe2roJG2jpf+15ic8/xEwbFuhKD0ARll
 rVXTo4Q73JIA2Wmgn9+RBxHFDSLLbkzXPe29V8OSpjAoRaP98aCjfNMDwL3u97w9DyV1QotNuRD
 rJkSefYNP1zBrG/GcsAGPOR/CMn0An2HDJJABCSPSrg+PwAsZHkCR8DQU1YGNc4ZGN8A4Klc+YD
 Cmp9YT+xh1WsDWZFR5K92G6vmBsyJSVmOEdm076ofPXX/FdY2mpfhVPwyy1s6I=
X-Authority-Info-Out: v=2.4 cv=JKs2csKb c=1 sm=1 tr=0 ts=6aad872b
 cx=c_apl:c_pps:t_out a=9mRn2PO/+PIrVdEbaIuMPg==:117
 a=9mRn2PO/+PIrVdEbaIuMPg==:17 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10
 a=x7bEGLp0ZPQA:10 a=vu5NlEYW-o8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=3QkjYGG84asobQ1p_Z0A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: DGpDKgWQtL7ACZVDH7PUneR8AkuGP2kz
X-JNJ: AAAAAAABYKIPoNpk7LFkdDOy59FPlsFhtV47gyHdpz71DZgqVoRGYu0K9OfYrOjcmMz76jCIkiHhnpBl+Ux09JnNE0D6CUc7qYXKgQehab3QS/t+pWFlYlxonXppmqrFyLcdKAgpI953wGS8VqbwbZDK8v2N9P20QQZB7q+Zu1BpwKGOL7IjVyoAGxnWqZPQs0ScRyzq3G59Lo7L6Gr7cnvVlR6Xt5Tt485I5IZ1SQnNbv1bWEFxS+VXzg2quB1Myvm3hpL0DoxTMQ/nUjlp9APywyE5mvlmpiSyN6XGu3CQm3sJiM1JOxsqSj2D7pcwlPqdx1NcLo5R1gaxkHLH3mPl/LC0JbAvosNEpmUZoAcD1Q08pVV2VcHcnHtwQISuFKrUAhrL2871mlzAM79h00oPJ50OicDFEA3TjTvaBOMJZJIYqfJ68HxmhFXk+ZlCMTs1kExBKJqUYVECAsondqho3DAEa34e8i1Oyd2lwpi3e/08tDHw0s7eya3CzildvCMUSg1ADVBvB3NdOSHuvTlsirThOQpTPxgnDiSSmpsn8L3XjgtQEnBOlTpxgXjVScYMZZuI0s0qpJESSBNro5aHzBFJ20eU5BFvhpbtDAF/xOQfQanJ7tIja6PumdARVCZP7HLzhXOLAfN/OyeQx9tTsc3yh8NmbLH0xVW5fl/AYI4jo/Th8aIzW8hXwTnz+kOHrreUJklnMEZuDs5EXt9laTtHbpohB0kmoQ/GdTtAUgcQ+eGqea34QXPXddw/IzAceSa3igZHXn1RiW3XEGAr06Zit8lEzMAG8NOoT5aYP2SUGKVNKZLigb9GNk6oGQLyI2gteG5fyJ0EeSWa+46aJP+6La0vK9/CmQGqBcUsmTHCl5ZIQldeUxOJfvdwWMob+Qtn1ag2+6uQwqYsGCu7SbKllSL1d4KSqVVx2J0pbKS6xYs7jODUWh+zBFE7TE6jo2NqNsBrVFZmkUtf6Cl
 BJV3T6sO
 K304d4Rw6abEawg2hkGqKnVM1+dhbjLSKcVCsv7uZZHHZekt6zbLymL+fzt4JNxV7rynWl/JcS1FiERU0YKJURhXGAwe1MVx+/OL/YbAZaOi1/s/y9rQxXCKLZxF64+gll2OQHABZX4390necIlIrH5dJA2elEG3JWUDMJ7mzn2OZYDKk2FVyCIzR3OBImnD2vEILiYWXcwAiDDfyJpUKpCeFOo4bbQjsWMhIJN3dMOSFcPgPz2sxedTyi2P4vxAp8dDJQjLUaEM6BweRW1xaSAqlqdTs1wI97lxTgMV4ZS1MMj3E0DRBevR/nmTm7G5zJ6a/jUB4gnmbhTcNXjlEkbYE8P2mi0hLnTHoFRy6ZyxO28WAnkiyFkAU0iYIEP9lbhh8v4MkTKhBBwrwqPMEnwpnp9AUGkJBV+pHQPdmJDgJDtyY5vpEchuLclSrH5qJ+EEuviPVHE4=
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DEA1E20009
X-Stat-Signature: 9p84n5mrxqpr8spetxex3h5a49odh1bz
X-HE-Tag: 1789757230-360486
X-HE-Meta: U2FsdGVkX19ZWV5ueTRDdu+P2xMvb9B9OUtw+Nvnf4XVC0/uNGdx3WU3yjTPh4Okv4GuwjtaFNPPz16J3Z6KSDJEa+qCkdVprEe4gdbJ4XPJhUOqOw1r+UuWcQCXnyb2MBHBUe/0z8i2dMEFb7Ty0WtEaBWkI2Dxg0CUWj7zh/64DZcGVzHIQri17APJj66LKdv6+GSHKikbIeEW8wKIdt0nguoRSo+U6ASTwgCaMTNccf3TRGdrPdJ6l3KwAgzxgBCAJZ+vP/VTcO/PosiBHi+xPOtV/3zOo5mUK6jCAwVOzp3WHGuVQiT4+Nd7Gt1qRXlB+ovF+MDvMc7OCQGpymrx73BbBr55kl6yeuYKypW7asc227QXOe1wAmn/69aqYDf81KINZ7j/ozeDprZ4fI7E5fCJ0VNrLjs2g1MDb3r9FC3AXewoJJoogECaSFQw4yIob2DzMaeFgxUxEZ+pEks4D0uXMyGhF2oarwX3kuqow6C1Pee2NmuCKkGRaCORX/7xfr3XBNfK4O52+giaBJ/YqgoK9n3JjdbH6VIN6x8IE1WPFTwTY91JapCy6M4trUjyVfnJ6sb+R+RtwYoktqmFrAmiS7rB5aCJSS8vFgh4rlbLXS9bHo5AXtY9kCWYS7oHMoOqYOI2BOlSpY1P/SehrY92wU/VAMG9FlIxM/1Aeqra4e1NeWvDyp7mFrunBumqmjs1zMsTwGQ/daF+3C8hY5JDZm7I1FE9nFzYSKRb1kmi35nOi0ogq+9Q85ZySwe4Pr7lc4dycCe4v5f2oT6DRSQ6EVRhXplrnRVL51OrhraMeP87Tq6A52CjGNUWYXNqj6eo2tnCtSTW9SS8IkRCpLkakFn56i5kivZBCnNJqDGZuj18UpBI9sN6lML9Bc+w3PQXlZXtIWQ+yImBcPQRQEZlYs3f5jM0Wmuh7huESGkiP2GbLbA5sZfV1l9NNbL0ZFX5UMS3cKXVc5c
 cCP3vfj/
 0oRpFVpD0kEpMamY8/2AI3XaBH1sJUwSEeGzbNBcUaL1IvBhAuXw9Hn4nFDbn0GQBVtdeP6IBXCMUuYMMBGDBWz2togX1u3B+X4LzFUCcuKMt35uY5l/xSPHr7VNqXmIwt3MCWiARhAhXkH8fHmmaQ/H1F9Gsv6m8r2imkRxMSlgOVsv9H+aGnx8FqbwY3TPswRc+1RM7jqXy++dF/dl14nGFAMhsX8A2CWtYgvOet+aEJelnGUfd5rskhD8pbdU1utzEsmtOKnCeCXnaj6q0QYA7X8i5lIT39t6tQj4mrHtZiYSG7CjHZ2cOQA3OT/waN/PlDOmSiA044SVeWtc6/l68JCMUfzNrliAlBfCS5l+Q+igrASoR9nP3PrBPT+fZ19Gmc9kiUZooU5zfjBXydZmdFXGcxJ6u35i+21aTRcTY/pRjJxYjdSdvJ9Zdi4ZCXtJYoZ5BcBRXaoo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 11:14:03AM +0800, Shakeel Butt wrote:
> On Fri, Sep 18, 2026 at 05:18:42PM +0800, Bingfang Guo via B4 Relay wrote:
> > From: Bingfang Guo <bingfangguo@tencent.com>
> > 
> > This is a preparatory work for moving memcgid from memcg to objcg.
> > 
> > Swap entries retain a private ID rather than a memcg pointer. Once
> > private ID references are moved to objcgs, the ID can also outlive the
> > memcg to which it was originally assigned.  So it's better to make the
> > get and put functions accept the ID itself instead of the memcg.
> > 
> > Rename mem_cgroup_private_id_get_online() to
> > mem_cgroup_private_id_get(), and make it return the ID only.  If the
> > memcg is already dying, the dying memcg will still be used for charging
> > and stats accounting in v2 swap charging path. But they are hierarchical
> > and will be reparented after offlining so it doesn't matter.
> > 
> > Make mem_cgroup_private_id_put() take the ID and resolve the reference
> > holder internally. Convert swap uncharge and charge rollback to release
> > the reference using that ID.  This introduces an extra xarray lookup for
> > now, which will be removed in the final patch.
> > 
> > Separate the online-state reference release into
> > mem_cgroup_private_id_kill(). The offline path already has the memcg
> > pointer and can call the underlying put helper directly.
> > 
> > Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
> > ---
> >  mm/memcontrol-v1.c |  7 +++----
> >  mm/memcontrol-v1.h |  3 +--
> >  mm/memcontrol.c    | 32 +++++++++++++++++++++++---------
> >  3 files changed, 27 insertions(+), 15 deletions(-)
> > 
> > diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> > index ed015fdd95123..b7f2868885071 100644
> > --- a/mm/memcontrol-v1.c
> > +++ b/mm/memcontrol-v1.c
> > @@ -268,7 +268,7 @@ void memcg1_commit_charge(struct folio *folio, struct mem_cgroup *memcg)
> >   */
> >  void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
> >  {
> > -	struct mem_cgroup *memcg, *swap_memcg;
> > +	struct mem_cgroup *memcg;
> >  	struct obj_cgroup *objcg;
> >  	unsigned int nr_entries;
> >  	unsigned short private_id;
> > @@ -298,9 +298,8 @@ void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
> >  	 * if the ID refers to the root memcg.
> >  	 */
> >  	nr_entries = folio_nr_pages(folio);
> > -	swap_memcg = mem_cgroup_private_id_get_online(memcg, nr_entries);
> > -	private_id = mem_cgroup_private_id(swap_memcg);
> > -	mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
> > +	private_id = mem_cgroup_private_id_get(memcg, nr_entries);
> > +	mod_memcg_state(memcg, MEMCG_SWAP, nr_entries);
> >  
> >  	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries, private_id);
> >  
> > diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
> > index 23be2512702dc..281425273ea97 100644
> > --- a/mm/memcontrol-v1.h
> > +++ b/mm/memcontrol-v1.h
> > @@ -27,8 +27,7 @@ static inline bool mem_cgroup_private_id_is_root(unsigned short id)
> >  	return id == mem_cgroup_private_id(root_mem_cgroup);
> >  }
> >  
> > -struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg,
> > -						    unsigned int n);
> > +unsigned short mem_cgroup_private_id_get(struct mem_cgroup *memcg, unsigned int n);
> >  
> >  void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
> >  				       struct mem_cgroup *parent, int idx);
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index bfe53e4392f09..ed44b3e7ac938 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -4082,7 +4082,7 @@ static void mem_cgroup_private_id_remove(struct mem_cgroup *memcg)
> >  	}
> >  }
> >  
> > -static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
> > +static void __mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
> >  {
> >  	if (refcount_sub_and_test(n, &memcg->private_id_ref)) {
> >  		mem_cgroup_private_id_remove(memcg);
> > @@ -4092,7 +4092,22 @@ static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned
> >  	}
> >  }
> >  
> > -struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, unsigned int n)
> > +static inline void mem_cgroup_private_id_put(unsigned short id, unsigned int n)
> > +{
> > +	struct mem_cgroup *memcg;
> > +
> > +	rcu_read_lock();
> 
> Use lockdep_assert_in_rcu_read_lock() here instead of taking rcu as both callers
> already taking rcu read lock.
> 

Thanks for pointing out this.

Agreed.  Both two callers are already holding the rcu lock so
taking the lock here is unnecessary. So I will drop the
rcu_read_lock() and use that in the next version!

My concern is that: mem_cgroup_private_id_put() looks like a
universal put function, requiring rcu held (which is true today)
is not that obvious to the users.  So I think adding a short kdoc
comment to make it clear later might be a good idea.

