Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACB17606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 15:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=p5l9ljFZ
Received: by kanga.kvack.org (Postfix)
	id 713BF6B05B0; Thu, 26 Nov 2026 10:01:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C6526B05B1; Thu, 26 Nov 2026 10:01:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DC686B05B2; Thu, 26 Nov 2026 10:01:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B1F96B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 10:01:55 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A20D1404A9
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 15:01:54 +0000 (UTC)
X-FDA: 85477584948.24.6948F3A
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9DB1E12001F
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 15:01:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=p5l9ljFZ;
	spf=pass (imf29.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795705312;
	b=h0nYgm7L+JH7PXTYgXYz3SYMQGhM+vwREB9SAsikw74ZA3t+z4UKrrRNn7c2BUyXTlQfzF
	AC/eWjhO+Oi/8YnHZz/I9Xu0nUcFjhYRiDtKI6PQdhimLdSKEUVWKdHpmD8PkChTp4JK1Z
	rT7nG04RYsQBY3nnudyVpZxmwQ/0tJM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795705312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CnA3zlb6+Q4MfV6Y5oL8cXYKHj+wdTkqxg32r451qEk=;
	b=jP5WxkDdgjo6TN1ntnW6zSqSLaNu09nkiXF9FDoDzP2CL8jAo2we+gSWs7jR5VlNY3Px9i
	gsmxuxSU7gjB6UYLgxbsNt19QAwfu6WijPdW1YLqfPsKSytQ77if9Rmn/3B/g1dQFEg1hj
	FembNcOQF2A0eWhybQdkpU1992I33Wo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=p5l9ljFZ;
	spf=pass (imf29.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2f01f296937so54067895ad.3
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:01:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795705311; x=1796310111; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CnA3zlb6+Q4MfV6Y5oL8cXYKHj+wdTkqxg32r451qEk=;
        b=p5l9ljFZ3nYFv/4geekBsvljmkaQHIiInwNszrGBohP18cuC6y+YgN05EzvsCW/LZm
         b5sZ4qj1ePKz1DgEM4ScYc4gMUFItYci0JsauQLg0+sPF5H9zjI748mESjnn7wIMqhSh
         w9IIldjyoLrRMTIbFk01bZQQYiFmYDa2DYVHmnbEgmQWUKtlCLDC5HTLGUKKUvwbK0Tf
         q9BLo3FyCe+JRQmeR7zzHlwdZisNgRzsg7/3vcrXAVFfxHCzzuLqv6i8+WxLEmZRe/gs
         zK5Ae86v7X82INCpHVgypj2LdA2TOec31g3LbsOj9Zj+gl5g/kVGueBFH4mD6RtfFXHY
         nBWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795705311; x=1796310111;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CnA3zlb6+Q4MfV6Y5oL8cXYKHj+wdTkqxg32r451qEk=;
        b=ekunLgKxm42IFH97UAdv0XSXqLg+RzDEsd6myWow/LfMG/bKwhKy1tgVOLU6BJ3u7A
         L5iUIXk12QX2D6hdOVs8YOwwMN3ybbG+fNIWyBiDtAZY0ek9HgrW+e4VaySWkZY7Zm6M
         xnsdR+3mQDf8zdbRrHfEaGIZP44tBhGTKZSL2mXQEYzstNzdabQbozlWZlZz6G7CGUr7
         2GJqicneXl8T5rFIWNeVOXcR+2r/ay0wN+Y5vb0194ulDNtme/eTvReB/Ss5/ETotvLn
         fZT+X5026JO46YBKVE5m9h3puWczyIiDxQwc/86M50/9sEZd1CqCs59owmjuEQ3Yqlm5
         wwcg==
X-Forwarded-Encrypted: i=1; AL+hErGdGUKlTfrJpQ/7NF/zTt58blFIZBg2d41sAS3/VaQn0Rue1FSNZK8m9GfzayiKAYpD8EO0sWVZYA==@kvack.org
X-Gm-Message-State: APuU4Z9TOSVBGuuA9UbCRThXRpmoKGHGS4PxMR0LtDBEEW8ErrnOc8xY
	cy9UqNSpuVUK0OwlWnN1OJhh6V7DQLrKvMra6vhWJ5gDgTO7TxnJeHCy
X-Gm-Gg: AZFdTZdC53W425hgfyokKZb+uLCwrpPV6hEuMnAY/R0LdvUZM4zFpgZIOSh1A1fVwsH
	fiZ3OPyjqfm6Rqu0mjdW830RezJg8VbQm0Y2Jnvi1Y8fMlv1k1DrRb9FYPU9R3KeSPVGI5kYBXX
	GlYwNBgebti4gfTcsv8zQqjEtQSzEpPYTtmqi7tcLvm4Gx5ai4jA7IDF+fNmhYyBwgvWbamhKu2
	dnnKz8X5QMFFhjgQ3azWWRUdu4syVMPIxkzaU8mxkKK1ygYBxYAr7acoJwEIGprEVK5BthOdwVO
	5yTwOCFJGJDkb+Euwk6wGo0yJx4dcgUwTaM5wNpyguo2EpcnOUORsv1OojkG/72Rvr9JGGlNlw6
	h9Q6cH6kBNKsTfScR+Puaz7rRY+JnZg/WLbxZ4XMfSszi4IbHa///MPq7XKYOqHJrMosKuncDxA
	aVKjadaddOtPxmvvOW8C2nN10Yz/8onEa8n6y0hDtfTbG62lr4UWoI5P2NnqFPzko27rsapWwpO
	y5qXBL6yLZ90cIRPjGXWt4cbqBFrbXZIZ6s0Td9qCtHb1DlsC4ygrupI6VQCIZv9uJ8rGZd5RBe
	HXEvySOpebKkS7c5LKIHzgmFIsQ4xXT8YgYohIfoc9+u
X-Received: by 2002:a17:902:ec8a:b0:2ef:e25e:e13c with SMTP id d9443c01a7336-2f03efb015amr233195175ad.5.1795705310670;
        Thu, 26 Nov 2026 07:01:50 -0800 (PST)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f15663fsm103299005ad.76.2026.11.26.07.01.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 07:01:50 -0800 (PST)
Date: Thu, 26 Nov 2026 23:01:33 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Hugh Dickins <hughd@google.com>, SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
	Yu Zhao <yuzhao@google.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Tal Zussman <tz2294@columbia.edu>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
	Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org, Tianyi Chen <hi@tychen.cc>, 
	Ridong Chen <ridong.chen@linux.dev>
Subject: Re: [PATCH v6 10/18] mm/mglru, gup: mark folios referenced via a
 fast helper
Message-ID: <c37b9336-95ac-4787-8a7c-73f6ee9d17c2@gmail.com>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-10-8ffea39934a6@tencent.com>
 <6c3d32a9-3004-4a17-b854-7088e69f164a@gmail.com>
 <awfb-vGF62XvcX_F@KASONG-MC4>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awfb-vGF62XvcX_F@KASONG-MC4>
X-Rspam-User:
X-Rspamd-Queue-Id: 9DB1E12001F
X-Stat-Signature: iyz95jrcjgrusnd5e1sdkhe5zb4g5z89
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795705312-15747
X-HE-Meta: U2FsdGVkX1/NgXS3a+tEHWg1SdbVe89oh4v3Ia+dnnOjtXtw6Gr4xWGFOdZNBirAsDNHRnldIoOayeCahxR5uKGy5fz2ng1JWwU4KEbuBZKG+OYFWjZXLZl/5U9p2cWOUZAfydv2hnAOsgVmbV7yumY0KxMAzT2ptFXg/Yu5/ROI8D3kor5z8ULIRrIcbUEWrNuHH1csz7shU8EJKAPeG/3lHxhsnz0CZS11vRLcO/fZAzZwx7ngjWkjOszl/c+CmGzxeQKIjq83mkSeCaJ+t439W4wNAGuab1+TWp0zYgmckn2rc/sZaB8XXIu4yVFImQV0ucbTIW3uO2j6Y4ehPi/rWAwud2VsFbUaQ2gRuO49JyfCyQOFczULDo8PKMqVDPdFM81l4/QvMNKD70G9dz+LOPVZxnSx57oqRSZkx2+9cCycViYwtqNeMIcG1STJdnIOoV1XV1pr5iu4dkPBiMs0PoWxPNW1l3eNBLJGYIXRPPhs7A9G+QZabKgi3zbf0OsmLpmJUP2sg8E/lUljq4xhOzoFes+ZcYSAo94UjAg0m19PUOiIwEf+1+9hN0wviJeCdRvBWHtN5GG4AyWOL3LeSQ10sM6QQyqXfHnQVWT3PyFA5v7lPAucuEMuCctwrUuFpfH+c44XSxlc5JF3FHIVZ1sBhxmiPVzO3APFqdLe/Y4rP5uGGFctcVlnBfCaVPvfexI/Y8wWL/MkN0r2vqI1tx804+IYluibasug/+Iz+8PNuX40xIVfCiINii1SkoQN/6Gjh7c8FP4akOnUuaUfoqYyCMRluEeMeHw662KEomA/qnka10KnGOx1tDXA26ofNfK4KO5hmS22GB6ZPLZP0sYQewbNOQKATR22hWiQcfB9pAtSmQw1qaVf3XDBSlctMvR5opmPhRq9K0ZFmpN3d4YZ0g2Reo2l3ewQpc7l0+Nn0nueH38fRTMD9sBCzHDH3cW740oopREdRoP
 qBXqBYfu
 bXsTy0G5Bm7A43PwtwQfCZbwCs7eyFpgQa7CCBEzDykssSeLvLUVXIhZs+w1k6Ve5zLNKmZBBu8IGsrj49OCXTK3XrTPNfCeJV5zfQqd8iiitcgxYiMQ8zMgCaAGFAKIojCmhDnxmUxkOojad6FQWdpPFOU2MCQdgJpCUeesjJxGLEYhJwyEvv92CiDzi+OPcYE+bfUkiODEFXPflAp7j58I8KTfjnrXbIY7GMtorcbzFXhpSZr4fGgEr9Ol4dd4bBE6IRUOkz1kFJ6cjCG33UhLxVIMK1AK8/LDni2XR3h+BlNJ5heKIUkeqVAXLQFGQwZ6gAJ7Xgt2MiWD/YMA+MrK0cemfjPs/7/vrHW43UWMvX1GEfRIthu4zXqq4E/73Kt1OeC3kBTm2Ksktk3ua/rxhKT+/75kxiqJdqhfEOxhk2YyHh/kPWOfGxralQNutxOQXIvZtcM0/D510pnCGKdsStBqxpHdhRs29bJXkPmTa3JP4qyjqcD81WCnsl0SJif+TEKcjCzEpk2z9INIHk9oiXKayUcHOy4XOJ3obGrrI1vaS1HOvgtkwCoPOk6BBmiNGrJzHI0xs674ETvC34SLKY2j+kV6hIvN3GPh3R9nSEwNMzn1jx05zMRlNgmmKWRQDc/Dl6qnq/bcL/6g7ZUNCaisXhgfb7sIIcCmEWEcJPZMJPjZRyBflw6W9v0Qgq9fzJq7JRfNZQbg3Q3z6q+ngXkC1Ckdf2f0nL3dTfBVQ6cpz2qITESUjo14zrpb+6flTQHdwT1uGYWs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 26, 2026 at 03:16:32PM +0800, Kairui Song wrote:
> On Wed, Nov 25, 2026 at 09:47:18PM +0800, Vernon Yang wrote:
> > On Tue, Nov 24, 2026 at 02:53:02AM +0800, Kairui Song via B4 Relay wrote:
> > > +/**
> > > + * folio_inc_lru_refs_fast - Bump folio refs count without promotion.
> > > + * @folio: the folio
> > > + *
> > > + * Raise refs from 0 to LRU_REFS_REFERENCED and leave hotter folios
> > > + * untouched. For a folio off the gen lists with MGLRU off, a plain
> > > + * PG_referenced set.
> > > + */
> > > +static __always_inline void folio_inc_lru_refs_fast(struct folio *folio)
> > > +{
> > > +	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
> > > +	unsigned int refs;
> > > +
> > > +	do {
> > > +		refs = lru_get_refs_flags(old_flags);
> > > +		if (lru_get_gen_flags(old_flags) < 0 && !lru_gen_enabled()) {
> > > +			/* For CLRU, just do folio_set_referenced() */
> > > +			if (refs & LRU_REFS_REFERENCED)
> > > +				break;
> > > +			refs |= LRU_REFS_REFERENCED;
> > > +		} else {
> > > +			if (refs)
> > > +				break;
> > > +			refs = LRU_REFS_REFERENCED;
> > > +		}
> > > +		new_flags = old_flags;
> > > +		lru_set_refs_flags(&new_flags, refs);
> > > +	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
> > > +}
> >
> > The implementation code of this function looks a bit convoluted.
> > Would it be better to simplify it into the following code?
> >
> > 	do {
> > 		bool clru = !lru_gen_enabled() && lru_get_gen_flags(old_flags) < 0;
> >
> > 		refs = lru_get_refs_flags(old_flags);
> > 		if (clru ? (refs & LRU_REFS_REFERENCED) : refs)
> > 			break;
> > 		new_flags = old_flags;
> > 		lru_set_refs_flags(&new_flags, refs | LRU_REFS_REFERENCED);
> > 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
>
> Hello Vernon,
>
> That's very good suggestion!
>
> Only one thing here is that
> `!lru_gen_enabled() && lru_get_gen_flags(old_flags) < 0` doesn't mean
> it's classical LRU, maybe it's just isolated. How about bool on_gen?
> Or bool has_gen?
>

Thank you for your explanation!

For has_gen, looks to me good.

For on_gen, it could be misunderstood as "whether MGLRU is enabled".
So I prefer has_gen personally.

--
Cheers,
Vernon

