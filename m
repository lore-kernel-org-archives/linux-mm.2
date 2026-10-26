Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6069E606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 09:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=WmFrow3D
Received: by kanga.kvack.org (Postfix)
	id 846706B05B0; Mon, 26 Oct 2026 05:38:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F6C66B05B1; Mon, 26 Oct 2026 05:38:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70B876B05B2; Mon, 26 Oct 2026 05:38:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 450516B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 05:38:31 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D9F5C14068C
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:38:30 +0000 (UTC)
X-FDA: 85364277180.13.B2A7B62
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf13.hostedemail.com (Postfix) with ESMTP id F172F20005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:38:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=WmFrow3D;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793007509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x+EqPqnUrdL97N89dZ6gFIZevXV0kvlIFkPLD7q7NEY=;
	b=u/svA4N/2byMyOUhawDe2uEfshYdnugCC+Bcl9phCMW5S0fRsZG4j01YhdQqIzVIGcYYId
	D8cVSxD/9BWLxGwpJK2cxdgVu5ptQmEoJOjYe6QCsv0rBGV9/4W11FWwww2h6W9aDV7gJA
	zlYoEVED28G87LEN13Eeek6+QgA2la0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=WmFrow3D;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793007509;
	b=aNlmyJW5ifFs9mhmRcPiX3Tt9+gjVdoThzqXi+skjOHYaSSn3IIW7AuVyvL6FVrodt2scm
	4V+7DdW4zZv3daq34P95USj0m9MrbnCyTwQYjoJEe/s+ikcph3IUCzF+LeWKu6gxBZUFd2
	TCqlTLrDqE09ixBsDg1mns9KB7VP0l8=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a2072b9832so19392495e9.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 02:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793007507; x=1793612307; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=x+EqPqnUrdL97N89dZ6gFIZevXV0kvlIFkPLD7q7NEY=;
        b=WmFrow3DmQXPY+H9VioYOQQWulsL57GETbqo8bSHSk0k0S2SENdryLFMdA4ocH/nLD
         dNyj3Aq0wGTQP0/WxRGbMjgC4j6No7diXHNtrzUWLoKBpMoqC7QXr/8AXlvifajyCIUw
         u8So4mp1Ah2KRWf1e+I5VCj0vouRY65YiU7Loqc/Z5fGYrUTEKCd9zTpawC5zpytM7b5
         aFSAmYSAPjvp1VX1gsrBKWUoRUYrICc2RrcZySu1RV+jEZ7pbOahw0bXCwyniejkI1zr
         +LPz/SKA8DwmrOiCykYs/Pw3xMN+p1AfJu5eANcbpupaIZdw468rSfnylX2pQtOIGaqv
         7f9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793007507; x=1793612307;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x+EqPqnUrdL97N89dZ6gFIZevXV0kvlIFkPLD7q7NEY=;
        b=FbHGjybtef7ji5H4FjVuMtu3QI5OltIeI9ehQQTa317hn+KV9fAT1+sQ8VLjiGEzF4
         sGgQXDwJjKECxEhx1q0OckYPxQkNMNsZyCmHU6KUdJdBtIqV1u6IPCgoHzjhhsGYMebK
         +r7mZn+XwScJWLpLnts0NIgy/E+6olp7orn1y9r4yqEOeGzUVfTKSAGTknQnOD6g2e/f
         pwkklkaI8iClFhw+G3MJ3OP9fVLtPsmvt1g/lKHXyMg+6I1eUPTVC7O5fXZhv9RdmtZ+
         HE37mkHS6uA+mVmy8d+mB71AeDhg8XWheImIrA0r5ygAOzmjA1Hik0xeeaZMKjtpUK9C
         dTtQ==
X-Forwarded-Encrypted: i=1; AKwUvBxgS+B/EJx25HP3aCqb2+VZKO7IBQGb+xzJHCnETSXRsqVe5FFOKyGobeThB2e/JSetcIE9Txvrxw==@kvack.org
X-Gm-Message-State: AFq9FYLZm8oeq6RDlFSzBITA4lQR49IivckqhILFr1ySNFHiEHZMsGqS
	5cX4qrebyrt55cn9EKBq6cu2WbycjJh4Jv3RKMgmdofKqCY4IE8hQI3qJOVDCZMxIZVYcGXUvZy
	RixFMOUY=
X-Gm-Gg: AYBFou0LSbBJ4afIAQvF1m5XLC5UIzjKrghJVZXiXZWlm/zZrzdaMxEsX97nKhYJpub
	gCVrJranuYoFccKUYeHiGi8KlGQ4QoKP1M+GOmP4CcEyTLkTs0E8PLFpuBtIBIs8YFve5s5WpNe
	9j0rHwMrxWy88COTrDl0mB6cA3QpSWQU/6hvQyPtJPdQvr5xdvhXMK0X1rQF/lS5AFegabWUM9P
	lQ96K1+Tyte450l08Wl45QJappBzrEnJB57rTOSlu9H5MurEII9LJ778gf3h9jODkEH38rP8jGe
	mTc7hSVV7/R51QbqId0SL1p0heuzt8+wlGFjMDos+q+TTdNpVLJ7H62fD/O5f+s1d9127b58uah
	6sYyWrGpefpo/wC1ZFJVLLVS3eeDACKZHmqgkcvCB9lmf+tk2TihcGaxiI6aV9Y77OQwOrzr5Fy
	v8ZGXoN1P07b0nNWn0eOdNpzKcQeAO510hy093qa4M3fpncJC2lGU3l2ddm1hi+hx5Loy7+iVo0
	C9PDDnrpKZPHfHpwoTrEiAEAPrPKssnvMqS3Eum2+z7550HCBzGf+/NCWeLwRqrxDPXDKla+eg8
	eBpTSBrnOaQoYjE0
X-Received: by 2002:a05:600c:8b63:b0:4a2:1960:6fa with SMTP id 5b1f17b1804b1-4a35ae7027emr123797325e9.4.1793007507462;
        Mon, 26 Oct 2026 02:38:27 -0700 (PDT)
Received: from localhost (109-81-20-177.rct.o2.cz. [109.81.20.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a359fbb725sm181656095e9.0.2026.10.26.02.38.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 02:38:27 -0700 (PDT)
Date: Mon, 26 Oct 2026 10:38:26 +0100
From: Michal Hocko <mhocko@suse.com>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 2/2] memcg: don't go through the lruvec for folio and
 kmem lruvec stat updates
Message-ID: <at8fkp9hR7Mvjy4J@tiehlicka>
References: <20261023195417.1391216-1-joannelkoong@gmail.com>
 <20261023195417.1391216-3-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261023195417.1391216-3-joannelkoong@gmail.com>
X-Rspamd-Queue-Id: F172F20005
X-Stat-Signature: 1j9yoeu5t4j4a8papmnc4rpjwgawbqon
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793007508-458124
X-HE-Meta: U2FsdGVkX19NqeeLAI/mSuYbuk4+TA+mrcol//ZTcoa1Ry7Lzrg4s8FpIestrXI2h3Ct43HlkudFVVBoMl4sRJwdpph8a+eO0O26QJ5vpJldyKyTyaEg6IM6Z8xq0DtKdoIL40NjCmenP6+XBaGZtFWvDQ+tOkaXCs6hKjk3Qz9m28uMELpI3mxPsvjCISPz+xaiDWfY1Da0e2HTtYqmg97r/tqBEP3AU9aqCDte3pS67kidQ2NH33Q+kEeiooLayjmjhm0pxj/GaxkstOe/qVLzeOPXkEtfH4ZPeRMn2YEcDxLxVagPailC+XQHCYqzPG4Tqvs0HdG7jGHRpeVHJQrvnK2ryrDwG3aYwpsFJXC0VaUm/nc13/w82RwkzfsL+uj0gsKAsnG+3YrKF0PFhca3qfLXlY+ey+P5TGqolqAK60DlQCbLKbGljEDAw9U36CLnm8kAf2+dLiCcyvHMpUV+KG7jSH4JtDHVqd6p1SHqAyq3zl33XunCT1wCAvwYQzcINzK2SdDaB53bHan4wofokibjvMv3oiZBiD8p1XbG3PmnUK3H3duMCq85kzrYNcqlSPjSkJZ4UgV/DnapYsfV//wSJFJoIYkQt4kyROlOEiJ3bbHHY+bx69hSkZcwvg2CxUv8U2NBkZLsQFjD5Qdr7htept9CpPbJlEu3R3Yo9VRb0VppTQ8NSe0uIUT7E2W9H5gAd9O7nvuXndM1u2rSRzKELF/JBhX5/MDgVRvR2fR0c4zzZ1OonnF0KFHNu6PgSSXM9wlYl8TyRPkVQvihGYx0r92KCbHkId43R/R3O39KuRLLrCTJkbC4ayjZRUwnpgak48cfPIAYm0CKaXbrlDdut8XoNMkljKmOPNMBxKudi3DBOx84imFHem0AVJDJYMuHus8E9RlOZB0iAY/cPWUYb2Dapgwsqjy0zOfN6SXbs66m446/8phxNVAdeQWLDhVrGjVpahK/D4H
 dwx6Tax6
 qlK8gWeQv7caizw7H6dJKkH+/1h9g8NquD8zM4yX6Sa6eNUKlIEb/XPFLon9+xvOsTgoEyrzGcR01VJvwX5lnEy06Mc4LiPtN08wDxfMUFXZWw1uHxRwJuduqbLOg13U5RBhFkYLVgRBd66q+mQQ7s08YGhQX8IoUX6it5ZTJvA4xA/9EBLmFDPgPIKgPxnVR9USDx20Kk1udaX8OJjKSCMQvlJR38Y2fXzUYMSLA3mIItaZ7Y2j3VE6/MCjcJZDwrwENP5nhW/iX+CY6i98r2iKKdllhirzSkUfwzua+xcQZoAq898IWWp4+4yYk0gsx+amTQwM1KV7UjqeWRiArr8BVIu99B8usnYmVCmFI3J1x30xWoxV+egOpz1flUU1ZyHuuHixgE9xSXhfZioftaeqS9o7i9A9C07N0dhcDoFI3dT8qww7VdpRijA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri 23-10-26 12:54:17, Joanne Koong wrote:
> lruvec_stat_mod_folio() and mod_lruvec_kmem_state() already know the memcg
> and the node, but look up the lruvec with mem_cgroup_lruvec() and update
> the stats through mod_lruvec_state(), which reads lruvec->pgdat and
> mem_cgroup_per_node->memcg to get them back. lruvec->pgdat shares a
> 128-byte cacheline pair with lines that the lru_lock holder writes
> constantly (lru_lock or lru_zone_size[], depending on the alignment of
> struct mem_cgroup_per_node), so on CPUs that do spatial prefetching
> these per-folio stat updates contend with the lru_lock holder.
> 
> Pass the memcg and node they already know to mod_memcg_node_state()
> instead.
> 
> On top of the mem_cgroup_per_node rearrangement, on a 2-socket Skylake
> (80 CPUs) with threads faulting in and freeing shmem in a single memcg,
> this improves throughput by about 3% at 20 threads (5.59M -> 5.77M
> pages/sec) and 2% at 80 threads (8.66M -> 8.82M).
> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  mm/memcontrol.c | 71 ++++++++++++++++++++-----------------------------
>  1 file changed, 29 insertions(+), 42 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a05d9a8baa1b..9f33cc5c8293 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -587,7 +587,7 @@ unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
>  	return x;
>  }
>  
> -static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
> +static void __mod_memcg_lruvec_state(struct mem_cgroup *memcg, int nid,
>  				     enum node_stat_item idx, long val);
>  
>  void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
> @@ -596,16 +596,11 @@ void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
>  	int nid;
>  
>  	for_each_node(nid) {
> -		struct lruvec *child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
> -		struct lruvec *parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
> -		unsigned long value = lruvec_page_state_local(child_lruvec, idx);
> -		struct mem_cgroup_per_node *child_pn, *parent_pn;
> +		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
> +		unsigned long value = lruvec_page_state_local(lruvec, idx);
>  
> -		child_pn = container_of(child_lruvec, struct mem_cgroup_per_node, lruvec);
> -		parent_pn = container_of(parent_lruvec, struct mem_cgroup_per_node, lruvec);
> -
> -		__mod_memcg_lruvec_state(child_pn, idx, -value);
> -		__mod_memcg_lruvec_state(parent_pn, idx, value);
> +		__mod_memcg_lruvec_state(memcg, nid, idx, -value);
> +		__mod_memcg_lruvec_state(parent, nid, idx, value);
>  	}
>  }
>  
> @@ -990,10 +985,10 @@ void reparent_memcg_state_local(struct mem_cgroup *memcg,
>  }
>  #endif
>  
> -static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
> +static void __mod_memcg_lruvec_state(struct mem_cgroup *memcg, int nid,
>  				     enum node_stat_item idx, long val)
>  {
> -	struct mem_cgroup *memcg = pn->memcg;
> +	struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
>  	int i = memcg_stats_index(idx);
>  	int cpu;
>  
> @@ -1015,21 +1010,23 @@ static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
>  	put_cpu();
>  }
>  
> +static void mod_memcg_node_state(struct mem_cgroup *memcg, int nid,
> +				 enum node_stat_item idx, int val)
> +{
> +	bool rcu_locked = false;
> +
> +	memcg = get_non_dying_memcg_start(memcg, &rcu_locked);
> +	__mod_memcg_lruvec_state(memcg, nid, idx, val);
> +	get_non_dying_memcg_end(rcu_locked);
> +}
> +
>  void mod_memcg_lruvec_state(struct lruvec *lruvec,
>  			    enum node_stat_item idx, int val)
>  {
> -	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>  	struct mem_cgroup_per_node *pn;
> -	struct mem_cgroup *memcg;
> -	bool rcu_locked = false;
>  
>  	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
> -	memcg = get_non_dying_memcg_start(pn->memcg, &rcu_locked);
> -	pn = memcg->nodeinfo[pgdat->node_id];
> -
> -	__mod_memcg_lruvec_state(pn, idx, val);
> -
> -	get_non_dying_memcg_end(rcu_locked);
> +	mod_memcg_node_state(pn->memcg, lruvec_pgdat(lruvec)->node_id, idx, val);
>  }
>  
>  /**
> @@ -1058,19 +1055,13 @@ void lruvec_stat_mod_folio(struct folio *folio, enum node_stat_item idx,
>  {
>  	struct mem_cgroup *memcg;
>  	pg_data_t *pgdat = folio_pgdat(folio);
> -	struct lruvec *lruvec;
> +
> +	mod_node_page_state(pgdat, idx, val);
>  
>  	rcu_read_lock();
>  	memcg = folio_memcg(folio);
> -	/* Untracked pages have no memcg, no lruvec. Update only the node */
> -	if (!memcg) {
> -		rcu_read_unlock();
> -		mod_node_page_state(pgdat, idx, val);
> -		return;
> -	}
> -
> -	lruvec = mem_cgroup_lruvec(memcg, pgdat);
> -	mod_lruvec_state(lruvec, idx, val);
> +	if (memcg)
> +		mod_memcg_node_state(memcg, pgdat->node_id, idx, val);
>  	rcu_read_unlock();
>  }
>  EXPORT_SYMBOL(lruvec_stat_mod_folio);
> @@ -1079,23 +1070,19 @@ void mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
>  {
>  	pg_data_t *pgdat = page_pgdat(virt_to_page(p));
>  	struct mem_cgroup *memcg;
> -	struct lruvec *lruvec;
> +
> +	mod_node_page_state(pgdat, idx, val);
>  
>  	rcu_read_lock();
>  	memcg = mem_cgroup_from_virt(p);
>  
>  	/*
> -	 * Untracked pages have no memcg, no lruvec. Update only the
> -	 * node. If we reparent the slab objects to the root memcg,
> -	 * when we free the slab object, we need to update the per-memcg
> -	 * vmstats to keep it correct for the root memcg.
> +	 * If we reparent the slab objects to the root memcg, when we free the
> +	 * slab object, we need to update the per-memcg vmstats to keep it
> +	 * correct for the root memcg.
>  	 */
> -	if (!memcg) {
> -		mod_node_page_state(pgdat, idx, val);
> -	} else {
> -		lruvec = mem_cgroup_lruvec(memcg, pgdat);
> -		mod_lruvec_state(lruvec, idx, val);
> -	}
> +	if (memcg)
> +		mod_memcg_node_state(memcg, pgdat->node_id, idx, val);
>  	rcu_read_unlock();
>  }
>  
> -- 
> 2.52.0

-- 
Michal Hocko
SUSE Labs

