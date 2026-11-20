Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 177D3606A333
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 08:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QfOUDmuI
Received: by kanga.kvack.org (Postfix)
	id 3DFC76B05CE; Fri, 20 Nov 2026 03:09:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B5E36B05D1; Fri, 20 Nov 2026 03:09:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A5C46B05D2; Fri, 20 Nov 2026 03:09:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E312E6B05CE
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:09:26 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 89112160DF0
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:09:26 +0000 (UTC)
X-FDA: 85454772732.01.BD59B5E
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf14.hostedemail.com (Postfix) with ESMTP id AE3B5100003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:09:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=QfOUDmuI;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795162164;
	b=deQv9QiPK6UlyA0/ARNSW/WEqYPTrM6foNEenRU8YA4dTCPW7KLJqhI8xxMa24CQbfG6JN
	PiqCbSTyZtxPSC3LHZRKTJQCueAgX3r2EbNXPvZlQae31ZlRDzSQwAKc7bQHYLuxnI9kSj
	9iyuJkZX+ghlMM1H8ZokqbyAOOykIEY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795162164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Aii1Zfo1wGWnDIZetJGz7kxMUVcRFhoSt4sJOKHr7bI=;
	b=LH8pH+wTDDcilKkl+6k92AZsr488yjbmELIgu9hSW4VF47tdgD+KGWWlUJhtGTew+n7lGg
	ui/8inY3TpH0iL1lONJgRsSgztJrI4/LzfGm8oDp13GWqa8YWLhbEQLrMClR0Vej+xcpxd
	EfD6FTsTEDRai+G0lBE7BND5ICN0m2A=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=QfOUDmuI;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4bb6adaf0f1so4803075e9.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:09:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795162163; cv=none;
        d=google.com; s=arc-20260327;
        b=fsxBdpNiGbgUR18sFTd4T/7rjciUoW+cVSzWpsn+mFa0no27n7H0Zf3QL5lAQ900mu
         Ojq/8lyUw+lCDtvo4Fu8I025gzvh66CH6Bc7GJxW77Ng86D1ZoqpCkjYRqA3JilXGZNN
         L2lJTh5PBCD/pafF1bJTQaA4f+ksvsA46RvNnMPCfLtMHxeyAlLplut8Q3rd2PJQAUoO
         fHrxIfMZFsaS8zrVnXgmt34yozjhdddnIHNg4qptx1wc/OTlUn/kKQM1zbvbIFIp2xHW
         4Xg9pWDbWOsKfWcbFcsy97CfTUj8IKhghKPbE8qFBt7q/8KrYpQwPdSRaub4CNlvZmo/
         qVfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Aii1Zfo1wGWnDIZetJGz7kxMUVcRFhoSt4sJOKHr7bI=;
        fh=01xpVHe4kda/rS6+PGv7HHxY0OOMMTM3Wu/tKcvhHys=;
        b=I5OgCN/tD5QzzD5pyHT4n/sgGinTGREuFvNuEpuNABkUayyCAiRPgJpOrn6nOsXdjF
         Zq1SnBuzo2xUnImCcX7eXUVLD/rCGcBpDsB22BQuZBKxGq7rKeLVDBGXJzA51hbBPDpE
         xHjI8zSJwyf5a/I84HZO72L/jFu97e+L/vb6LRGl+X4bLEqjrkuT7avuCj4qwaaD92wa
         zdtaiHjCuuDC9udwxyR0+/urRHDLXkSDCi9/bY+qFEefx8pbpHDc7AFzTs0WE+yIfCWu
         8J9HSzXZ4e4F8ksnf364/fM3EC8p8PC8jlYcfMjv4P8Y6EJRIWFEByRyZkwQxC5NKlFM
         cCiw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795162163; x=1795766963; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Aii1Zfo1wGWnDIZetJGz7kxMUVcRFhoSt4sJOKHr7bI=;
        b=QfOUDmuIUJwOENLIrPAPLBc4Ud5y4dwu48Dies+Xsu7yvawyOvFo+Nmu2w7TvsPuy4
         4csQGwt/Ye1ZebujN5Zx5R6r3LBFQ8VCVulDxfUbpLyHam0mRqqrOSUlmBdKzc+rg/9Z
         VIECu9Udh18lp71vNftvPwrNj4aHOAoNmQ9McegRyeXTREmN/G+9lVMbeOjQNejqgxgB
         ar14ecPyKY8iQn2Bhhw7PnjOLVBSpbhyYo2vUyP5UYXVQLK9WrqR0zKCyf4JI4iRJa9j
         XJ4mweYFr9b5jT7ETC8B3DJ7gwUFnoG0Zsus+g4bnXdD2Pj4IdJQbJ2mJ7TixbWA2QgK
         s8kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795162163; x=1795766963;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Aii1Zfo1wGWnDIZetJGz7kxMUVcRFhoSt4sJOKHr7bI=;
        b=a8QZzMTO2xdEUL2gUlZC7E3aNrnuyD9eszS7YEdVPH2IeycH1GCbBha03uMs7Ox7Lh
         z6fgBwrL3iKDSLWvh3adZymjgf0qg5Sa2kTnbhwprypuA8CEfPzTJ08+7eQsKQAFh9jL
         yUoOxBHUnM30pkKqlNrmNKrvHTKO7xswmFAVM5E4pRZ7qixmNBzbHTgFc7v1q+T1IdCl
         Pjk0JbStyKm6q0/ZmpBD2p/lSx01aQJpRhWAeuF2gA9ht6FD9UeRRB0Kdh6J7PwvWrNk
         VDr3c+zfVU42h4FI61kZ2tGUvQX8znQSNzVteZmLiE/SIW1mTWp2loEtTlyyEMiiw+wK
         K+xQ==
X-Gm-Message-State: APuU4Z/Aj35ahKs0zJVCaceQhf9ofkSvhmfR1UXWDwlnWIm/BuE6Tm2M
	4sBeT3GLOUsitecYk8Kj49ouJLYlnYmWxAf8sURGw/gVTHBqqk6o7kjmZAhvu2KgILhrIWVqt11
	fDwNbe7GMyRiuQlTqzTfxhoKwsUhm2uo=
X-Gm-Gg: AYBFou1cW6M1kOWJC1ryr+45tph/d8NlX5Z3KK9A4yPBZgy4BCNSxGEud+fqUaubhrs
	Js1AonLief4mPiQvEfs0X+zU7/ggCyQsg+Ac1pr8bvK2HpQd5MtzzQ/Xv8HYnTRqsDW6zHXCvwC
	IndtChrR27fzqHjs3LTzcj9Na4SvZicsYX28ORTDiv9RTauizgYBvbstGxs+CSti5Fg4Xt3ff8O
	CBZ4elUVE6T5aHjpU1qfjYZh3+zlCE6sgZmSPc4JXnuyOTSd9UQ0uLzx8Hoqwl1Hf3tQjnEOMGm
	tWBqKvaIZERwbRNhiIqQ4gpWPZPaKXVjpLf+ighwQNY9tOwDdZw7mLLVPI/5pM7HFGBCClYm3gt
	IujIH2/ZRsJY/CYpEgLE8WyLfbWefvwEbcctsndTjp6CYybKK90Fe2oV0opwnuA+R9w==
X-Received: by 2002:a05:600c:820d:b0:4a1:dfaf:f465 with SMTP id
 5b1f17b1804b1-4bb887c2ca3mr50773205e9.4.1795162162231; Fri, 20 Nov 2026
 00:09:22 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-6-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-6-9eee2fe97a2d@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 20 Nov 2026 16:09:10 +0800
X-Gm-Features: AclHuK_VKlqqEhyVsFjwMPNFqZB7zpvWpa4YrOLbcuQl6B76cFC6fUDgwP17mRM
Message-ID: <CAN_Opa_jb1pN=-Z+4WRoXVDSe0YfppeY319iagMdQoMgtOQSSg@mail.gmail.com>
Subject: Re: [PATCH v5 06/17] mm/mglru: frequency guided workingset promotion (MGLRU-FG)
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User:
X-Rspamd-Queue-Id: AE3B5100003
X-Stat-Signature: 1498wrde1k3xaw5htkfww8r9edjb7cpf
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-HE-Tag: 1795162164-153592
X-HE-Meta: U2FsdGVkX1+mZYk/3qrKYgtIkCDsYZjvf0Vz8v71UHBmJbq1rgNtFmJ+8PtArUELqFuM6lFwljVBOzemNAArzl3gDo6kjGBdzMsnlZm2TV2vAw1Bi/raZc7UGlG/fnsoqsfklc1ghAkp8S1gK5eQNunr/JOTMV3MM0Mar6e/7IqcTYv07yunis8jayeSXlk0Fy9WHGmAn+1xqLZifd3hW3bXjdK2kD05vAb9milqk8pECHiWpLbZLxpxbCbdad/IIGgt6B+jWxXzLnHyqbbgtpQsKo54tC3pwuZEEObp2OACGVux9VLpu8DQnVS8s7261kmafxlqqcQT2p/nkKd8shzalBiBoxqe2se7H92IxytE5TKkWyOUrG0KUdgpjl4z37kMOR18VE3zUxx758Drw1NVa82KLL9BXbUV7u/R3FdQAYES7xT6XJN9RFIzdL5MRFcefKBPtsB7SjdlKhNE7CDNO3PEXnnUH6H4uQ51pxCtETjCBsPqXdIhtaerxNynYFGTWcUoDbm108BbdP0C63CHhFOyi303ciAQL1JttKXQOMqnphfdmJLOJNrlkU2z1xPAEgAftmmoohnPTzx5NIewUrCo5tqZKG7auBeVdFXimQbPlu2/7oFlx0nghRSQZRh8Jrd3y4IKICOUCOX7TgrLEgCHTKbWOnzTTH3xwDZ6pPRvazY1Wpw558kKck/cC+lbejcLkJBi6VbxOvNNSSVYO6LecI+2CytwG38V79atrhStqgCXFYCrkHrOa4BWrTmJnH4BnZmu3/bLT7G3UyGFrHLcWx7I3Qp8LO2EEYMkF/23BrsBPx0rRJ1SM8Ji3zVR+XuEUce7v0GFr9MK8efD/w4XZVqteUA518dKK3Yarr9JE/W16VyK8uiLBHAHQI++pJl/VVluLT7zS5riBiNJBBfuQXKJlRTZzcj3Mg28SuWdHi/0kR48kP5D0w5pSbDstGBSN5KbTko28Pj
 mbwKgcM0
 VZ0FkjTuBKnn8NVjSIk4aWHzIQ336T/nVSfBA20g0dJehmdreX7YObwiMZaFr3mMf5wzsu/YgWYSKEkeLZXnWS8kg7bL5J9BXbM79NdukHqEgAR9tVxEGI62ywmxlWipmT6WUXo0U+CUaZtjH7glfa1VlEDUp7kFQzqu7qGWhZnjihnJHJcHTzV5DJqoCx0gJciRZqsN6wgdypeZ15DJhYh3ZzR/MYDDRZN/c3T7Z3wblCP1ocHko5/ibFdglUgfnz6hoTTKnIgyNhAZVu3aX6SBbo/qvqO3lW2Rj9x4S3aMeRLF/lpgJzaEKbnv+kQegQJ3hyasFQEUaEOrQbnjvQ+4xU1Op/ogQ7eqjJ4CU1gnvH9BO3JCkX3O1XydVHnqdBHCbDYZGmggx0N18l9jyKSHRMK6upwFPj9jAadkEYqh98rzX4/5f8iBI3WQJq67UrgXyeidVBXAkxU07FyyoVR17u2CP65qazmQWWf1vzB2qGZQlvFkBwrUQF1YGtfbdsc8dH/w4vy85j7EsFMmupDygnVG+YVx3MUVOY9tjIW4T5BzkkdKAUWjGEQmXcoF+CTmY6gIpeirtBZ9fPP5iQDajEU0zEhOrj3PYbJJq9yryj6fFyezDxBbxqUyD6tMG0jAaXhdcoFJ7w0zREG9rZ8rIv9zSXmj66CmLt975mV+tJeRqJcYK+oh1upJXAwg6nWrCKGS2O6Nb5fXRpKJuw1hhX182A+MYvw4Z/lQzJvbzLzJ28PJckbyKYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ssLRU referenced count set by lru_set_refs_flags().
>   */
> -static inline int lru_get_refs_flags(unsigned long flags)
> +static inline unsigned int lru_get_refs_flags(unsigned long flags)
>  {
> -       if (!(flags & BIT(PG_referenced)))
> -               return 0;
> -       /*
> -        * Return the total number of accesses including PG_referenced. Also see
> -        * the comment on LRU_REFS_FLAGS.
> -        */
> -       return ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) + 1;
> +       unsigned int refs;
> +
> +       /* Decode the per-folio reference state. */
> +       refs  = !!(flags & BIT(PG_referenced));
> +       refs |= !!(flags & BIT(PG_workingset)) << 1;
> +       refs |= ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) << 2;
> +       return refs;
>  }
>
> -static inline int folio_lru_refs(const struct folio *folio)
> +static inline unsigned int folio_lru_refs(const struct folio *folio)
>  {
>         return lru_get_refs_flags(READ_ONCE(*const_folio_flags(folio, 0)));
>  }
>
> +/*
> + * Referenced at least twice. Unlike lru_refs_is_active() this is not
> + * bounds-checked: folio_inc_lru_refs() evaluates refs unclamped.
> + */
> +static inline bool lru_refs_is_workingset(unsigned int refs)
> +{
> +       return refs >= LRU_REFS_WORKINGSET;
> +}
> +
>  static inline void folio_set_lru_refs(struct folio *folio, unsigned int refs)
>  {
>         unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
> @@ -238,14 +252,26 @@ static inline void folio_set_lru_refs(struct folio *folio, unsigned int refs)
>         } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
>  }
>
> +void folio_inc_lru_refs(struct folio *folio, unsigned int flags);
> +
>  static inline int folio_lru_gen(const struct folio *folio)
>  {
>         return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, 0)));
>  }
>
> +static inline bool lru_gen_is_old(struct lruvec *lruvec, int type, int gen)
> +{
> +       unsigned long min_seq = READ_ONCE(lruvec->lrugen.min_seq[type]);
> +
> +       /* The MIN_NR_GENS oldest generations, which eviction scans next */
> +       BUILD_BUG_ON(MIN_NR_GENS != 2);
> +       return gen == lru_gen_from_seq(min_seq) ||
> +              gen == lru_gen_from_seq(min_seq + 1);
> +}
> +
>  static inline bool lru_gen_is_active(const struct lruvec *lruvec, int gen)
>  {
> -       unsigned long max_seq = lruvec->lrugen.max_seq;
> +       unsigned long max_seq = READ_ONCE(lruvec->lrugen.max_seq);
>
>         VM_WARN_ON_ONCE(gen >= MAX_NR_GENS);
>
> @@ -302,23 +328,24 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
>                                               bool reclaiming)
>  {
>         int age;
> +       bool workingset = lru_refs_is_workingset(folio_lru_refs(folio));
>         int type = folio_is_file_lru(folio);
>         const struct lru_gen_folio *lrugen = &lruvec->lrugen;
>
>         /*
> -        * +-----------------------------------+-----------------------------------+
> -        * | Accessed through page tables and  | Accessed through file descriptors |
> -        * | promoted by folio_update_gen()    | and protected by folio_inc_gen()  |
> -        * +-----------------------------------+-----------------------------------+
> -        * | PG_active (set while isolated)    |                                   |
> -        * +-----------------+-----------------+-----------------+-----------------+
> -        * |  PG_workingset  |  PG_referenced  |  PG_workingset  |  LRU_REFS_FLAGS |
> -        * +-----------------------------------+-----------------------------------+
> -        * |<---------- MIN_NR_GENS ---------->|                                   |
> -        * |<---------------------------- MAX_NR_GENS ---------------------------->|
> +        * +------------------------------------------+------------------------------------------+
> +        * |     Accessed through page tables and     |     Accessed through file descriptors    |
> +        * | promoted by folio_inc_lru_refs_walk()    | protected by folio_inc_lru_refs/inc_gen  |
> +        * +------------------------------------------+------------------------------------------+
> +        * | PG_active (set at isolation or refault)  |                                          |
> +        * +--------------------+---------------------+--------------------+---------------------+
> +        * |     LRU_REFS_MAX   | LRU_REFS_WORKINGSET |    LRU_REFS_MAX    | LRU_REFS_WORKINGSET |
> +        * +------------------------------------------+------------------------------------------+
> +        * |<-------------- MIN_NR_GENS ------------->|                                          |
> +        * |<----------------------------------- MAX_NR_GENS ----------------------------------->|
>          */
>         if (folio_test_active(folio))
> -               age = MIN_NR_GENS - folio_test_workingset(folio);
> +               age = MIN_NR_GENS - workingset;
>         else if (reclaiming)
>                 age = MAX_NR_GENS;
>         else if ((!folio_is_file_lru(folio) && !folio_test_swapcache(folio)) ||
> @@ -326,7 +353,7 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
>                   (folio_test_dirty(folio) || folio_test_writeback(folio))))
>                 age = MIN_NR_GENS;
>         else
> -               age = MAX_NR_GENS - (folio_test_workingset(folio) || folio_test_referenced(folio));
> +               age = MAX_NR_GENS - workingset;
>
>         return max(READ_ONCE(lrugen->max_seq) - age + 1, READ_ONCE(lrugen->min_seq[type]));
>  }
> @@ -341,6 +368,7 @@ static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct folio *foli
>         int zone = folio_zonenum(folio);
>         struct lru_gen_folio *lrugen = &lruvec->lrugen;
>
> +       BUILD_BUG_ON(BIT(LRU_GEN_WIDTH - 1) != MAX_NR_GENS);
>         VM_WARN_ON_ONCE_FOLIO(gen != -1, folio);
>
>         if (folio_test_unevictable(folio) || !lrugen->enabled)
> @@ -408,7 +436,6 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
>   */
>  static inline void folio_migrate_lru_refs(struct folio *new, const struct folio *old)
>  {
> -       BUILD_BUG_ON(LRU_REFS_MASK & BIT(PG_referenced));
>         folio_set_lru_refs(new, folio_lru_refs(old));
>  }
>  #else /* !CONFIG_LRU_GEN */
> @@ -444,6 +471,10 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
>         return false;
>  }
>
> +static inline void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
> +{
> +}
> +
>  static inline void folio_migrate_lru_refs(struct folio *new, const struct folio *old)
>  {
>         if (folio_test_referenced(old))
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 4c4aad95b0b6..5470dd708e44 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -453,57 +453,103 @@ enum lruvec_flags {
>  #define MAX_NR_GENS            4U
>
>  /*
> - * Each generation is divided into multiple tiers. A folio accessed N times
> - * through file descriptors is in tier order_base_2(N). A folio in the first
> - * tier (N=0,1) is marked by PG_referenced unless it was faulted in through page
> - * tables or read ahead. A folio in the last tier (MAX_NR_TIERS-1) is marked by
> - * PG_workingset. A folio in any other tier (1<N<5) between the first and last
> - * is marked by additional bits of LRU_REFS_WIDTH in folio->flags.
> + * Each generation is divided into multiple tiers. A folio's referenced
> + * count maps to a tier as shown below (with one extra refs bit):
>   *
> - * In contrast to moving across generations which requires the LRU lock, moving
> - * across tiers only involves atomic operations on folio->flags and therefore
> - * has a negligible cost in the buffered access path. In the eviction path,
> - * comparisons of refaulted/(evicted+protected) from the first tier and the rest
> - * infer whether folios accessed multiple times through file descriptors are
> - * statistically hot and thus worth protecting.
> + * MGLRU (frequency guidance)
> + *  Refs  Tier  |- Refs: observed accesses, capped on promotion.
> + *   0      0   |- Mostly cold pages, readahead, etc. [1]
> + *   1      0   |= LRU_REFS_REFERENCED: Used at least once. [2]
> + * -WORKINGSET-+|- Workingset floor, unless explicitly reset. [3]
> + *   2      1<-+|= LRU_REFS_WORKINGSET: Classical workingset, accessed twice, protected. [4]
> + *   3      2   |- LRU_REFS_PROTECTED: Protected workingset, promoted pages capped at here. [5]
> + *   4      2   |
> + *   5      3   |- The tier here is MAX_NR_TIERS - 1
> + *   6      3   |
> + *   7      3   |= LRU_REFS_MAX: Promotion candidate. [6]
> + * -PROMOTION->-/
>   *
> - * MAX_NR_TIERS is set to 4 so that the multi-gen LRU can support twice the
> - * number of categories of the active/inactive LRU when keeping track of
> - * accesses through file descriptors. This uses MAX_NR_TIERS-2 spare bits in
> - * folio->flags, masked by LRU_REFS_MASK.
> + * Ideally each tier holds folios of similar access patterns: lower tiers
> + * are less important and evicted faster.  A page's reference count and
> + * tier are capped when it changes generation, preventing it from
> + * dominating the new generation based on old-generation access history.
> + * The generation and refs together represent logical refs: hotness relative
> + * to the aging window. Promotion moves the folio forward and caps refs;
> + * gen aging then lowers logical refs even without updating the stored count.
> + * This avoids a separate full-cache aging walk to reduce old hotness.
> + *
> + * Refs tracks accesses from two sources: page table (lazily collected by
> + * the page table aging walk or rmap eviction lookup) and file descriptors
> + * (by folio_mark_accessed).  Page table accesses promote more readily
> + * because the accessed bit is sticky (undercounts repeated accesses),
> + * passively collected, and page faults are generally more important as
> + * userspace does not expect a memory access to block on reclaim.  Both
> + * access types increment refs by one; the result is capped at
> + * LRU_REFS_PROTECTED on promotion or deferral, or LRU_REFS_MAX otherwise.
> + *
> + * 1. Tier is fls(N-1) for N > 1, 0 otherwise.  Folios with zero
> + *    accesses (refs == 0) are generally cold, e.g. readahead folios.
> + *
> + * 2. Folios accessed once stay on tier 0: one-time usage does not
> + *    qualify for tier protection. A second access can advance the folio,
> + *    aligning with classical LRU's use-twice threshold.  A page table
> + *    access that brings refs to LRU_REFS_WORKINGSET promotes to the
> + *    latest gen. A file access at that refs count only defers eviction
> + *    from the tail gens of its type.
> + *
> + * 3. Folios accessed at least twice are considered workingset.  This
> + *    mostly aligns with classical LRU: at least one I/O is saved by
> + *    keeping them in memory. Unless explicitly reset, these folios stay
> + *    at or above tier 1 (the workingset floor), so tier 0 stays a clean tier
> + *    for cold cache while tier 1 serves as the fallback line for
> + *    actually reused or historically hot folios.
> + *
> + * 4. Starting from tier 1, PID protection sacrifices lower tiers to
> + *    protect higher tiers by comparing refault rates for long-term
> + *    accuracy, and caps higher refs to LRU_REFS_WORKINGSET.  Rejected
> + *    folios also keep at most that count on putback, allowing further
> + *    accesses to distinguish their hotness again.
> + *
> + * 5. Pages beyond the ordinary workingset tier form new tiers for the
> + *    PID controller to protect differently.  Folios at or above this
> + *    level are capped at LRU_REFS_PROTECTED on promotion or deferral,
> + *    and at LRU_REFS_WORKINGSET under PID protection in the oldest
> + *    generation, where they represent a historical workingset.
> + *
> + * 6. A further cache access at LRU_REFS_MAX advances an older folio by one
> + *    generation, with refs capped to LRU_REFS_PROTECTED. Folios already in
> + *    the newest generation just saturate their refs.
> + *
> + * Tiering uses PG_referenced and PG_workingset as the lower two bits,
> + * and the bits masked by LRU_REFS_MASK as the higher bits, so the refs
> + * count ranges from 0 to LRU_REFS_MAX.
> + *
> + * Cold hints can reset refs with lru_gen_clear_refs(). Refault restores
> + * its referenced count, capped at LRU_REFS_PROTECTED, which aligns with
> + * promotion.  Fault-driven refaults of previous workingset folios set
> + * PG_active, so they are placed in the latest gen.
> + *
> + * MAX_NR_TIERS is set to 4 so that the multi-gen LRU can support twice
> + * the number of categories of the active/inactive LRU.
>   */
>  #define MAX_NR_TIERS           4U
>  #define LRU_TIER_MIN           0U
>  #define LRU_TIER_MAX           (MAX_NR_TIERS - 1)
>
> +/* Access source flags for folio_inc_lru_refs() */
> +#define LRU_REF_MAPPED         0x1U
> +#define LRU_REF_EXEC           0x2U
> +
> +#define LRU_REFS_REFERENCED    0x1
> +#define LRU_REFS_WORKINGSET    0x2
> +#define LRU_REFS_PROTECTED     0x3
> +
>  #ifndef __GENERATING_BOUNDS_H
>
>  #define LRU_GEN_MASK           ((BIT(LRU_GEN_WIDTH) - 1) << LRU_GEN_PGOFF)
>  #define LRU_REFS_MASK          ((BIT(LRU_REFS_WIDTH) - 1) << LRU_REFS_PGOFF)
> -#define LRU_REFS_MAX           BIT(LRU_REFS_WIDTH)
> -
> -/*
> - * For folios accessed multiple times through file descriptors,
> - * lru_gen_inc_refs() sets additional bits of LRU_REFS_WIDTH in folio->flags
> - * after PG_referenced, then PG_workingset after LRU_REFS_WIDTH. After all its
> - * bits are set, i.e., LRU_REFS_FLAGS|BIT(PG_workingset), a folio is lazily
> - * promoted into the second oldest generation in the eviction path. And when
> - * folio_inc_gen() does that, it clears LRU_REFS_FLAGS so that
> - * lru_gen_inc_refs() can start over. Note that for this case, LRU_REFS_MASK is
> - * only valid when PG_referenced is set.
> - *
> - * For folios accessed multiple times through page tables, folio_update_gen()
> - * from a page table walk or lru_gen_set_refs() from a rmap walk sets
> - * PG_referenced after the accessed bit is cleared for the first time.
> - * Thereafter, those two paths set PG_workingset and promote folios to the
> - * youngest generation. Like folio_inc_gen(), folio_update_gen() also clears
> - * PG_referenced. Note that for this case, LRU_REFS_MASK is not used.
> - *
> - * For both cases above, after PG_workingset is set on a folio, it remains until
> - * this folio is either reclaimed, or "deactivated" by lru_gen_clear_refs(). It
> - * can be set again if lru_gen_test_recent() returns true upon a refault.
> - */
> -#define LRU_REFS_FLAGS         (LRU_REFS_MASK | BIT(PG_referenced))
> +#define LRU_REFS_FLAGS         (LRU_REFS_MASK | BIT(PG_referenced) | BIT(PG_workingset))
> +#define LRU_REFS_MAX           (BIT(LRU_REFS_WIDTH + 2) - 1)
>
>  struct lruvec;
>  struct page_vma_mapped_walk;
> diff --git a/kernel/bounds.c b/kernel/bounds.c
> index 02b619eb6106..06a034713b5d 100644
> --- a/kernel/bounds.c
> +++ b/kernel/bounds.c
> @@ -25,7 +25,7 @@ int main(void)
>         DEFINE(SPINLOCK_SIZE, sizeof(spinlock_t));
>  #ifdef CONFIG_LRU_GEN
>         DEFINE(LRU_GEN_WIDTH, order_base_2(MAX_NR_GENS + 1));
> -       DEFINE(__LRU_REFS_WIDTH, MAX_NR_TIERS - 2);
> +       DEFINE(__LRU_REFS_WIDTH, MAX_NR_TIERS - 3);
>  #else
>         DEFINE(LRU_GEN_WIDTH, 0);
>         DEFINE(__LRU_REFS_WIDTH, 0);
> diff --git a/mm/folio.c b/mm/folio.c
> index ea3adb6a89d7..06c9cde834f7 100644
> --- a/mm/folio.c
> +++ b/mm/folio.c
> @@ -352,32 +352,6 @@ static void __lru_cache_activate_folio(struct folio *folio)
>
>  #ifdef CONFIG_LRU_GEN
>
> -static void lru_gen_inc_refs(struct folio *folio)
> -{
> -       unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
> -       int refs;
> -
> -       if (folio_test_unevictable(folio))
> -               return;
> -
> -       /* see the comment on LRU_REFS_FLAGS */
> -       if (!folio_lru_refs(folio)) {
> -               folio_set_lru_refs(folio, 1);
> -               return;
> -       }
> -
> -       do {
> -               new_flags = old_flags;
> -               refs = lru_get_refs_flags(old_flags);
> -               if (refs == LRU_REFS_MAX) {
> -                       if (!folio_test_workingset(folio))
> -                               folio_set_workingset(folio);
> -                       return;
> -               }
> -               lru_set_refs_flags(&new_flags, refs + 1);
> -       } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
> -}
> -
>  static bool lru_gen_clear_refs(struct folio *folio)
>  {
>         int gen = folio_lru_gen(folio);
> @@ -388,7 +362,6 @@ static bool lru_gen_clear_refs(struct folio *folio)
>                 return true;
>
>         folio_set_lru_refs(folio, 0);
> -       folio_clear_workingset(folio);
>
>         rcu_read_lock();
>         seq = READ_ONCE(folio_lruvec(folio)->lrugen.min_seq[type]);
> @@ -399,10 +372,6 @@ static bool lru_gen_clear_refs(struct folio *folio)
>
>  #else /* !CONFIG_LRU_GEN */
>
> -static void lru_gen_inc_refs(struct folio *folio)
> -{
> -}
> -
>  static bool lru_gen_clear_refs(struct folio *folio)
>  {
>         return false;
> @@ -428,7 +397,8 @@ void folio_mark_accessed(struct folio *folio)
>         if (folio_test_dropbehind(folio))
>                 return;
>         if (lru_gen_enabled()) {
> -               lru_gen_inc_refs(folio);
> +               if (!folio_test_unevictable(folio))
> +                       folio_inc_lru_refs(folio, 0);
>                 return;
>         }
>
> @@ -474,21 +444,6 @@ void folio_add_lru(struct folio *folio)
>                         folio_test_unevictable(folio), folio);
>         VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
>
> -       /*
> -        * For refaulted workingset folios, set PG_active so they
> -        * can be added to active generations.
> -        * For prefaulted file folios, folio_mark_accessed() sets
> -        * PG_referenced so lru_gen_folio_seq() places them into
> -        * the second oldest generation.
> -        */
> -       if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
> -           lru_gen_in_fault() && !(current->flags & PF_MEMALLOC)) {
> -               if (folio_test_workingset(folio))
> -                       folio_set_active(folio);
> -               else if (!folio_test_referenced(folio))
> -                       folio_mark_accessed(folio);
> -       }
> -
>         folio_batch_add_and_move(folio, lru_add);
>  }
>  EXPORT_SYMBOL(folio_add_lru);
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 0f24b6ebc1eb..a02504c5a7d7 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -818,38 +818,204 @@ enum folio_references {
>  };
>
>  #ifdef CONFIG_LRU_GEN
> +/******************************************************************************
> + *                     Referenced count feedback
> + ******************************************************************************/
> +
>  /*
> - * Only used on a mapped folio in the eviction (rmap walk) path, where promotion
> - * needs to be done by taking the folio off the LRU list and then adding it back
> - * with PG_active set. In contrast, the aging (page table walk) path uses
> - * folio_update_gen().
> + * The folio_inc_lru_refs{_*} helpers below collect the referenced info
> + * (hotness) from the page table walker, the rmap walk upon eviction, the
> + * rmap look-around, and file descriptors (folio_mark_accessed).
> + *
> + * Each access adds one to the refs count, capped at LRU_REFS_MAX.  A
> + * fresh folio's refs go from 0 to LRU_REFS_REFERENCED to
> + * LRU_REFS_WORKINGSET, and so on.
> + *
> + * Mapped access (PT, LRU_REF_MAPPED) has a higher priority since the
> + * accessed bit is sticky (it under-counts repeated accesses) and a fault
> + * could be more costly than FD I/O. So, a page table access always
> + * promotes a folio on an expiring gen by at least one gen. And starting
> + * from the second access (refs == LRU_REFS_WORKINGSET), it moves the folio
> + * to the newest gen. Executable file folios promote on their first access
> + * to avoid I/O thrashing. The refs are increased at a normal pace though.
> + *
> + * File descriptor accesses (FD) are a precise access method. So, only
> + * since the second access (refs == LRU_REFS_WORKINGSET), every access
> + * will promote a folio if the folio is on an expiring gen (close to
> + * min_seq). If the folio is not on an expiring gen, it will be promoted
> + * when its refs exceed LRU_REFS_MAX; the newest gen just saturates.
> + *
> + * Promotion, regarding the source, always caps the refs at
> + * LRU_REFS_PROTECTED, so folios in a newer gen start at or below the
> + * protected tier, and folios with lower refs in a newer gen are logically
> + * hotter than a folio in an older gen with higher refs.
> + *
> + * A folio with refs at or above LRU_REFS_WORKINGSET is considered a
> + * workingset, and the tiers starting there engage PID protection.
> + * PID-protected folios (folio_inc_gen) are capped at
> + * LRU_REFS_WORKINGSET independently to make full use of tiering.
>   */
> -static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma_flags)
> -{
> -       /* see the comment on LRU_REFS_FLAGS */
> -       if (!folio_test_referenced(folio) && !folio_test_workingset(folio)) {
> -               /* Activate file-backed executable folios after first usage. */
> -               if (is_exec_file_folio(folio, vma_flags)) {
> -                       folio_set_workingset(folio);
> -                       folio_set_lru_refs(folio, 0);
> -                       return true;
> +
> +/**
> + * folio_inc_lru_refs - Update the folio's LRU refs and lazily promote it.
> + * @folio: The folio being accessed.
> + * @flags: The type of ref: FD access, or mapped access optionally with
> + * executable access.
> + *
> + * Used by both cache access (flags == 0) and page table access (flags ==
> + * LRU_REF_MAPPED, optionally with LRU_REF_EXEC).
> + * Context: The caller must keep the folio alive by a reference or the page
> + * table lock of a mapped folio.
> + */
> +void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
> +{
> +       int max_gen;
> +       int type, refs, old_gen, gen;
> +       unsigned long new_flags, old_flags, max_seq;
> +       struct lru_gen_folio *lrugen;
> +       struct lruvec *lruvec = NULL;
> +
> +       type = folio_is_file_lru(folio);
> +       old_flags = READ_ONCE(*folio_flags(folio, 0));
> +       do {
> +               new_flags = old_flags;
> +               old_gen = lru_get_gen_flags(old_flags);
> +               refs = lru_get_refs_flags(old_flags) + 1;
> +               gen = old_gen;
> +               if (old_gen < 0)
> +                       goto out;
> +               /*
> +                * Lock the lruvec if the folio is on-list. We are already
> +                * doing lazy promotion so in theory we don't need this,
> +                * but for now, concurrent aging would still corrupt the
> +                * size counters.  This is a temporary limitation and
> +                * will be lifted very soon, so the lock here is not a
> +                * performance concern.
> +                */
> +               if (!lruvec) {
> +                       lruvec = lruvec_live_lock_irq(folio_lruvec(folio));
> +                       lrugen = &lruvec->lrugen;
>                 }

Can we do the lookup under RCU and preserve IRQ state here?
filemap_read() can reach folio_lruvec() without RCU held. On non-RT,
lruvec_unlock_irq() can re-enable IRQs while KVM's hva_to_pfn_retry()
still holds gpc->lock.

Thanks,
Kunwu

