Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D24F2606A337
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 00:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mF6fdhEA
Received: by kanga.kvack.org (Postfix)
	id 9068D6B0626; Thu, 12 Nov 2026 19:15:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B7E16B0627; Thu, 12 Nov 2026 19:15:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CDBD6B0628; Thu, 12 Nov 2026 19:15:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4CE746B0626
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:15:15 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D36631C5E00
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:15:14 +0000 (UTC)
X-FDA: 85428176148.29.F0EDFD7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 44054C0009
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:15:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mF6fdhEA;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794528913;
	b=c/aBKdZUAmXsgXllGok47Zr6DvNm2fka3Hfh7ISy6IOyLjcmQM3WGh00WVQZj0TV54NIe1
	lUB9HQaMASvs50hW2CR6486/YXCTPuqJXaf5J3LMzB+w5yOAvHA7x1ffcssHhGTMnto4Yd
	+0Vtg+HD67S6EK9rormY90jAbLetITc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mF6fdhEA;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794528913;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GD+I+3GQDqtGZF/Bu6We6sIGybUshi/kL26Zg3f3D/A=;
	b=WZ15PFAEkRYg6htIhDj9yyK5crqFjB5dl8zlagqhDYpfcJ+LLVRKwSSclIR7cCs5p/R0qS
	Y9xGt4H11o1cDJ2mAu8njFhqiCdgd7dLUW+xnlF6U5B9ymB9+kwjW6PBhzAOpW7sgGqkqE
	j3YWTBg/Gv00yKTylkxzaWr9uTPRbVY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A1A00614AA;
	Fri, 13 Nov 2026 00:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6FB1F000C9;
	Fri, 13 Nov 2026 00:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794528912;
	bh=GD+I+3GQDqtGZF/Bu6We6sIGybUshi/kL26Zg3f3D/A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mF6fdhEAw9rjiNFI3sYb5edsvUT6sKg5TdziR8xclyxym5YVMBM14Pu3ozklnef7o
	 icpfyb6Nd6Jo+SJJlt5xKNvaFRCyrm03v9LwxyceWVx71mZOR8fvtKIw0vf5vwk5vA
	 TLWmn+WSWljlfROn6YR38HklamkjVbo30TeLD+9SSrFopJx6nBLi89oF8jl0bMPW4p
	 lnG5uIS7ARwgsLyJTcdXBn58bc4giwMHA1bOyLmE42vYVRIw7s/iMrDf02Hc8iYeFX
	 dSaJ5RK7wIungB/UMNuJPE/tx5u3HRta2z+3ztIm/maECOsngkiG+ZXQlmEYQyDxbA
	 bvZFiDvmVYKjw==
Message-ID: <sashiko-outbox-211977@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm: list_lru: don't use a new memcg's lists for an
 offline memcg
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shakeel Butt" <shakeel.butt@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Dave Chinner" <david@fromorbit.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "David
 Hildenbrand" <david@kernel.org>, "Michal Hocko" <mhocko@kernel.org>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Muchun Song" <muchun.song@linux.dev>, "Qi
 Zheng" <qi.zheng@linux.dev>, "Meta kernel team" <kernel-team@meta.com>, linux-mm@kvack.org, "Chris
 Mason" <mason@kernel.org>
In-Reply-To: <20261112221248.3512447-1-shakeel.butt@linux.dev>
References: <20261112221248.3512447-1-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 00:15:11 +0000
X-Stat-Signature: xbjkjs7rx36g4e376mhsxtdmw6ohohjj
X-Rspamd-Queue-Id: 44054C0009
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794528913-658553
X-HE-Meta: U2FsdGVkX1/K2F5lS1K+FAMPbHts9c1tAqwhaX9odSW5oSusfnvppyA31eQtgGNsbh48Z6AO3msJza2aidFmL+kmxijreJkSUTMvJqa0WWP1ysHdY6GZom5ToIGAhacN8FW0EJzTLxjMvW6OXUUwV2vvpoaLIE97STmDOCjNhdEmJQDzIqsfxHZ/uUgO6g9VLOQja4fRBppepL0W7oVKepJV4NfiBS5/X2ug0VNExxvl/yIDOTUTp8fK/8OLWemyqnEQOcRfdNuHT5GHpVBWUD8sHx9nkMkYqCn6pICAxRHX8w0t2miM84lEKsfnvK2J+t7XXgBgoNKP6W5+aabHxHSZAjzIrF+dJ92PHIL7al+ijSY/Uv6MjUKstzs+TQ5QpwSsAzdXsc6dR8kO2PrtLYRQA1VXpQYNv/YCq8KwnWeF4QgZ9uEgtp2KQUacnPAflj70C/SH4JW92nqWxVsElcgW4VMzS9tc8X/j5WvXwPXcHDthqtD32K4dkkAy03SRtTU1mOtTjdpNATZG6HpSEritig4tIEUfA/TrDwNEry4ywbdolL+1XQh6z475i7JplCcZ+sN/AFY3HHGRbnsJDZ5u1/gTpcmgFtmCSxBX3GSL5ERJoGC5BAU9AgCuJV4Ut34onzQ0vzw5QUcBYc1RimbrZKFohY5i3b1fZysWovAF4mRP4+gzpsSMD0KPN1K914aIuEqR9NN8Gf3MJ79bR75uhwYojhUxHfcVtJTyBssaSAy0nLl58IupaXmXEtjTraUOiPGMAk0KPgOLkPpXcNa1YlDvr3MTeRuXllcPcl0Xd70TYisEvNH1pDo9lTwUMNJBxepWSL/4IShHtmTf9WBCxXFxBbSfxZNv21nlWH2tb9xBO8ml0LQtllbXI982/gAaUKCDyGpdWlVMyPx2tEtT9F3BrOX+Zjl230mqEci7pzA8/6tSoic2ASeR+7OnhHFgtsNEvX1S52w2oig
 C/1SZVg5
 vynekjNNnwHoiPlepNgXduQ9XMn/WDsuJWXvusBdEAlhcgk6yIqRg2SvU8ZQEan5PeBrlhuwJI5uCckqm6RxFMWH+f5B49KaaL1GyLYob3oPj+sgaA3P43mjwZ8NdrZ88AygqHVvJF2Rx6Wl+6jsqCzHbweeDhtvkpdgIYvtiI47vtlg82lBpheezG/KcphnXeS5YaFG3WGaoSO7nruRQzsll9jtrmre1zusm7okudB47xYvB1CiMcTGaveh413RTvEHAS5lC649gi5D4xf7RWJvPJ9Qt+uUcbH1mEN68q1jVLhEm3FkPREza7TuzQnydv3fR4IitXi4/sW64NgnujKgNeD3eyJ503AEDFPC78RgJuy1OrDs23UeQx8jUNqHFCdMpvJRexy2Yya5Jq3o4GQ0+F4JB101f422kxuZ9qyhLkeqhD+k8oHcxLr1KEgAl0knXaxTans/4GytUgxvO6ui5P5L0EzWXhT0AaifAwauP+LMX42mUW1iFR7XeTJCdEMlJZyJEBUQ+20xnNPX0Ryjs/e0+mYu4jJ0D43UiWRKhDy7dUpYvz5iIufHdUVrjWPA8wrAhUTZqVkSom3DyhowZeu4WKCVAxMD6IsygfdnSuGKVLHzn61ga2AX6aHNRZUvVR6hz9Iow6s8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] mm: list_lru: missing mlru->memcg check in
  memcg_list_lru_allocated()
--

commit d213b82b7b4ca4978c858df10a2a8cdea14626e4
Author: Shakeel Butt <shakeel.butt@linux.dev>

mm: list_lru: don't use a new memcg's lists for an offline memcg

This commit records the owning memcg in struct list_lru_memcg and checks it
in list_lru_from_memcg() so that an offline memcg whose kmemcg_id was reused
does not use the new memcg's lists.

> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index d1d256822ccc7..937dbf239c9d4 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -72,12 +72,15 @@ static int lru_shrinker_id(struct list_lru *lru)
>  }
> =20
>  static inline struct list_lru_one *
> -list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
> +list_lru_from_memcg(struct list_lru *lru, int nid, struct mem_cgroup *me=
mcg)
>  {
> +	int idx =3D memcg_kmem_id(memcg);
> +
>  	if (list_lru_memcg_aware(lru) && idx >=3D 0) {
>  		struct list_lru_memcg *mlru =3D xa_load(&lru->xa, idx);
> =20
> -		return mlru ? &mlru->node[nid] : NULL;
> +		/* Lists at a reused index belong to another memcg. */
> +		return mlru && mlru->memcg =3D=3D memcg ? &mlru->node[nid] : NULL;
>  	}
>  	return &lru->node[nid].lru;
>  }

[ ... ]

> @@ -602,6 +604,8 @@ static int __memcg_list_lru_alloc(struct mem_cgroup *=
memcg,
>  			if (!mlru)
>  				return -ENOMEM;
>  		}
> +		/* Set before the lists are published, and never changed after. */
> +		mlru->memcg =3D pos;
>  		xas_set(&xas, pos->kmemcg_id);
>  		do {
>  			xas_lock_irqsave(&xas, flags);

[Severity: High]
Does memcg_list_lru_allocated() also need to check mlru->memcg =3D=3D memcg?

mm/list_lru.c:memcg_list_lru_allocated() {
	int idx =3D memcg->kmemcg_id;

	return idx < 0 || xa_load(&lru->xa, idx);
}

Consider a hierarchy root -> P -> C where P is online and neither P nor C
has allocated a list_lru_memcg in lru->xa yet:

CPU0                                  CPU1
folio_memcg_list_lru_alloc(folio, lru)
  rcu_read_lock()
  memcg =3D folio_memcg(folio)  /* C */
                                      mem_cgroup_css_offline(C)
                                        memcg_reparent_objcgs(C)
                                        mem_cgroup_private_id_kill(C)
                                      /* M2 gets C's kmemcg_id and
                                       * allocates lru->xa[idx] */
  memcg_list_lru_allocated(C, lru)
    xa_load(&lru->xa, idx)  /* M2's mlru */
    /* returns true; P is not allocated */
  rcu_read_unlock()

deferred_split_folio(folio)
  folio_lru_add(folio)
    lock_list_lru_of_memcg(lru, nid, &P)
      list_lru_from_memcg(lru, nid, P)  /* NULL */
      VM_WARN_ON(!css_is_dying(&P->css))
      /* walks up to root and queues folio on root's list */

Once P later allocates its own list_lru_memcg,
__folio_unqueue_deferred_split() locks P's list_lru_one while unlinking the
folio from root's list without holding root's lock, corrupting the list.  A
matching RCU read lock around xa_load() and the mlru->memcg =3D=3D memcg ch=
eck
in memcg_list_lru_allocated() would avoid this.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112221248.3512=
447-1-shakeel.butt@linux.dev?part=3D1

