Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C92C5606A332
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 07:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=RyA1wphN
Received: by kanga.kvack.org (Postfix)
	id DA9606B00EF; Wed,  4 Nov 2026 02:55:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D55956B05B1; Wed,  4 Nov 2026 02:55:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C42FC6B05B4; Wed,  4 Nov 2026 02:55:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A07BB6B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:55:47 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1B79040686
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 07:55:47 +0000 (UTC)
X-FDA: 85396677534.17.4057DCA
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf02.hostedemail.com (Postfix) with ESMTP id CCD7E80002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 07:55:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=RyA1wphN;
	spf=pass (imf02.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793778945;
	b=8cvz4ZreqJx7heCrjBUhWYsxycwloC7T8Doke+5ulTOfBCg2gGdSCXwBYLeCHyk5lpZHna
	Gsl926cmhfq3JQHDnzGDnuuJhfVaaKOePLvqN9bXBWUxoz/e4aG0FuRvBwZr59dUh+bmkE
	AMN5MNbSLhgZ47krsxabzT2nQGcaX9w=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=RyA1wphN;
	spf=pass (imf02.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793778945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I2RVWsP67jO+YLENwruOvOgNLvlMuyI5Iq8dOZmwn9A=;
	b=aim9yG2SsLmV6Fsy9ScoPXNG0Rbp0Qfp5GP0bMOW+Z7TG4yyzrmF5CxE/SAnPmHjnE1PXp
	i0uGh/K43DZ/LKQs00i6vSFDayckmqbzgdyAf5eaYwjASM8UZQS6+d3rpr9QiAqNyjm95h
	dMyzT3LwX2/mHYLWxsA1zDgdVuqk0cM=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c434376dbebso67783066b.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 23:55:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793778943; cv=none;
        d=google.com; s=arc-20260327;
        b=dUh8kNKW5orAvAqnZzM5Xq7RSTmy6H2HPiSUwhLz+GJbdfBi6mxLFd0tnQG1sgT0Q1
         0DPgbgF9rghaoFVvgbBpvq9qJn96PIApHoylqIZZG/9XNlsgyUqkYclZnoAS11cU4HG+
         geN7bcT9OmQ2HqTNJeZWRUokKQjFm0Ga/Fov5mDLIYrOPYsOkGD82Q6OAT5YL8WWOs/3
         vQvaOhiNfXO3p49h5HR8x+ySgGF2dY+R0uqcOdsBp88asQ9n8v6fUc17CcfbDIocEznc
         RNwwIndw6MFt57laI86mD2Mq+SRMF5LRuMSMEFBlWqCcIXP2IfCx8Ik36/yOdedi2ax0
         +Mxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=I2RVWsP67jO+YLENwruOvOgNLvlMuyI5Iq8dOZmwn9A=;
        fh=hBx2fhE16EzeQY4JX93DS6lSOnF/1OVklGEDIt1LUmw=;
        b=na8KGWnwcJYCEjmRWRdNhW7HGEeRu7kr2rPdLA+dvShXSz6pNJUAvppvvWyjP3T5HM
         O01xGuhCaZjXUOGPEvtD+AgrhQmVbKgbsRm/afwl/CvbJNFOhWkoGSk5W6OEmXcTDiS1
         zqF08mLdpEN6Q3lw6oGrZwPyxtfjQ4vSNa9m5LWHqWrjNnS7gmpvbkq5ioCRVbR8LHGE
         MNvi7tNqa4BPiNBP+uHiSqmMq41QbXPa+ZAOlZMc1HIhWBLgR6h1SeNCQiO+yqJMLjk/
         hVBYm/DqSZA0w7Xv++XdcrP6FJKcu1vQcYbicwZv7JRRefEu04Zbqk2rKJrl9FCLf8Og
         LAfg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1793778943; x=1794383743; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=I2RVWsP67jO+YLENwruOvOgNLvlMuyI5Iq8dOZmwn9A=;
        b=RyA1wphNnldkWXmQ1KZrJQjPpnlbniyy2raC7JC4jmDmM+Sq5QtaYZ3LFFqHdGN8fM
         AVl/P+c7ODDunW+JCL+fI51bLnZjGjXVWFeXTNz0kld7lT90/6WmX9LvK1AqRMwaWxC6
         Yxq24Dwab392ycYulzk+WXsDSsPsQSVTWKQj55ob3uuPhenj0xK4GihN0e7okKKKUFFI
         YGX3/hsZuDHTkBf0GtouWrU0Y+IK7h8b0HKqm2xj0RJ5MoLVAyNLe8QvMptzZr7aQBvO
         LB0v/nRAvC06WfRDUkFQJqAr6dhl1NM6gxlf5XMpTmzYUQ4wtE6JwMy2wJgC2ue+xKRn
         ndzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793778943; x=1794383743;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I2RVWsP67jO+YLENwruOvOgNLvlMuyI5Iq8dOZmwn9A=;
        b=QiVne0SU+YpSXnGneZQ7EOCmhVURQ3h2i6hFGzfw4lCESynurs7pKSAvc12uqzU0Ug
         vZ4v6FUIV26b1nut6JdbUvFu2RPjZGBh2vpEPOyzJpbcJobSgTVn/32zN1LG5qqJGPkk
         yQY3Uf6rMn8GOsbSVCJAQHCdUmGLy1C9VMii67DdkPpnFxGbpOO0MSZiqIxRpjRvZ9hu
         uxQ10Ymv5Tl8j2mbHFm0F8KRKnaAp4xxEeBOl/6HEHWOqKhB9dj+aldl2nOYyuTYq+j3
         UqwXXBSPTp5je6jZzfzPfU3H70NZEnWbb/Lf9ljnBvVWxRahjx4n0tlHrjIPVqM3b2GL
         ybeQ==
X-Forwarded-Encrypted: i=1; AKwUvBykqEvTVGFgKG9JKgxlK90CJvRKGdcPQdFxwg6r18iboKfgnQF5b57a6795w704Q2cl1k6uW4+gtw==@kvack.org
X-Gm-Message-State: APuU4Z+fleQzghL4Y07smfpvyf1Y/0KhIg0BygUkF5Ihl2281nSwav4H
	jLnDs8mYlMjLHH9z3TpJULg6R8N2Kd7ES4yXdC+k5QtQGjpPT6E5EqMcJ/EkG1gASfQO4qMoR1S
	DoFVFF38Ruejmi9d5AHQEDaMGLvPBbMgpnX+l494cHg==
X-Gm-Gg: AYBFou21DfEDT44ASfFEILYnTbwihZrx0YgXMknOVNcJQCiSCi0mjfVIVUnFYhAbadu
	dNTgHBSzWUb6JkrEwR5D6QX9GhdqXg0g7HlFTqJAuHijO7tHXK52PDLyyDTMq4rDkI2N+GoGT3R
	dsP8bkl0V+a2gPcXt4FWfOKbOvHabBdmzBBiez/3eT0Nn8G8r4m1pl3poowY85pilrkW7LPPxVx
	dSmlYYsyRiSkX0H+Hn+c7buMBxA9hsJjTGFTU1lQ9TW2LvVKvPNw50eRvPGwx2cdAfwyko5Xhch
	MKqYoE/UNv2CrOhxdFRBnwGTBrPH34OaR9FUHIfHleoKLifOOBTaEVu5L2NLRRHF9vOrf5HEhKu
	qZDFzIWWJPIr508n3USo6hz/GfKkBVW3mja3eTBApyOdTSZwDyizygksPV0kRtalolg==
X-Received: by 2002:a17:906:9946:b0:c4d:939:526b with SMTP id
 a640c23a62f3a-c4d0939530bmr123502666b.0.1793778943224; Tue, 03 Nov 2026
 23:55:43 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261103113711.1832834-1-max.kellermann@ionos.com>
 <20261103113711.1832834-4-max.kellermann@ionos.com> <CAGsJ_4y+LX-CSnDJ59VT2nc-i=rB=4iMuBQYawMCktk-_SPykg@mail.gmail.com>
In-Reply-To: <CAGsJ_4y+LX-CSnDJ59VT2nc-i=rB=4iMuBQYawMCktk-_SPykg@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 4 Nov 2026 08:55:31 +0100
X-Gm-Features: AclHuK9db34czdLJDGuWdv4eeJ4Wz3rR25lYZqq6bke9pbWo9X2wFnS-q5qCw2o
Message-ID: <CAKPOu+9XP8CP-EiLqd_Q-F6EWUQPgi4Ysz7wu8LZijR+j0_uyQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] mm/mglru: cache the last memcg node, make tail
 insertion constant time
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CCD7E80002
X-Stat-Signature: uopkrpbwhssa16p9z8oet7k4okrjp3q5
X-Rspam-User: 
X-HE-Tag: 1793778944-78033
X-HE-Meta: U2FsdGVkX18RxIfqE0OgA1Zbyz5ov+MJgTyvM3equLQkEogydoQz2PwJ+ud7zcuCKO9XmI4gXiOKaNpKjpihIUEmG+oOutO8+YLU+7jybtQCdKhzn38H0RBIRzsGV2QNgezlQGnQKuaAJAl6yHqVNp64WYtr5L2d//sMwiuejhyrXqEoaotLo/tpJ9jx0xk3qTFmssVrsXYSwBDlzjw2eAFHa20XSAZHRkhgAO4rGiNqQTRE2i1RWPgRrEzNIAmE31wCnTYJv/WheobOHjGGvnKrH02AbAZj5kLq0cVft5zVtZ+NwJPRwSHOldn8q2YGV+WWNw7yfd9iNJGstDRXzyrq8RVMPjqtUXDleV3rF96ceSNK5X82IWR/rBFpGT3G6dBrssjta8i/h4+R0zMtdiuLG4uRV6rmOGTRK3fITf7kwD6wIQIbnY8xpyl16gahThhMjVgX54h9AFbFYAD9aFnE0M2n/HnIwoQYBw0RG+kwga8ap6geJJnX4yJPXMCMtYy8kVOLH5myZZcgHixhnErXcWYsHozhVBuLhvGOMARZ6r5J14bJOLXve+qB1NfTqmtCG8+zjtEaygmGS2HIqpDXATm03+3Hmu2pzrgJrDi+k/FHDk31lhamvyAS9BqNGUp03Omj9ENF0Pu4la65xuLCPiwjcbURsHIOYT6kXgSBYxbLHNUsgQEzaisFP3HLF94eF3lKoG9rxPA00kr+BVsZirHifUbkE6lu/aQw6jgb/T3BooM6cnNZlRAY9CB/VsUMPjEx0+FvIJP1ibjd7qHPLbezlReoB3DI6bk0ZUrCQoIOve3XVxIMbZC5NZJNa7950twGSK+Eqbs0uiAGZu5Tdum1B2AjiN66ms6PaUfXGeqH/kTTZheeZNdPz/5jRM0mdwJ3rqc3mDq+JzMgOmLQ8XRlzlA8uSs58NPkn8qIqqr2rSjFxL5r0tCXJspt0QA0UaN0P+WUxkjpytf
 VVu2NB6k
 gnCoy867bJsF8253DL7W6qWy47dZ2xGK2noQ5BU5I4/2GICwNuv5fmAyJ+uYE42I2oPZ0sOzAVW6kmO44c0dbLPJM5uWYIrduNDQKiJjs5KWtYOE07C8LfQu8vgtO9kaKNYmlfGp4fQsryFjckUBnoMZIHCzjtxyE6hnl25+VXgrwvW1witPoYNaQ8Bv2CoIrvCp7Vz92H9Wz3oNFYQmOJxTbllm+jc9fGPHOdLvvjgVIeLMuBYMgqzslLs9fP7WTJyukJCmGZpRYiSitxq+2+19OGp0Ylm2H5wObsmLT+n8hajACkHA2zoyLUXUIgs5GXGgfQLP20Bu+Skk69fppZwazry7xzOasX2VKTsYELKThsw/ZUyscKvP6UMIyAVIpX77MEkYFv2FYMVc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 4, 2026 at 4:40=E2=80=AFAM Barry Song <baohua@kernel.org> wrote=
:
>
> On Tue, Nov 3, 2026 at 7:37=E2=80=AFPM Max Kellermann <max.kellermann@ion=
os.com> wrote:
> >
> > Rotating or onlining a memcg currently uses hlist_nulls_add_tail_rcu()
> > which walks the destination bin to find its tail while holding
> > `memcg_lru.lock` with interrupts disabled.  With thousands of cgroups,
> > this takes a long time and causes severe lock contention.
>
> This is the main cause of the soft lockups and RCU stalls,
> right? If so, we may want to add a Fixes tag.

Yes. I added (for v3): Fixes: e4dde56cd208 ("mm: multi-gen LRU:
per-node lru_gen_folio lists")

This commit added lru_gen_rotate_memcg() which calls
hlist_nulls_add_tail_rcu() (full linked list walk under spinlock).

> The fix itself may not be directly applicable to stable
> kernels, but based on the logic of this patch, we should
> be able to work out a backport, right?

The primary copy of these patches lives in our kernel branch that is
based on 6.18 LTS.  So I already have a set of patches that can be
backported more easily.  Do you want me to submit these versions, too
- and if yes, how?

For me, it is not entirely clear if a stable backport is really
necessary (thus I did not Cc stable).  It's not a bug; just awful
performance when you have thousands of memcgs, but few people have
that.  But that's up for you to decide.

> Another option is to leave the cleanups in patches 1 and 2
> out for now, and make patch 3 self-contained as the first
> patch in your series, if that makes backporting easier.

I don't think that makes backporting any easier - they are not really
cleanups, but refactoring to make [3/5] as simple&small as possible.
I wouldn't squash them; it improves nothing but makes review harder.

> I'd appreciate it if you could also mention Ridong's earlier
> work in the changelog:
>
> https://lore.kernel.org/all/20251119083722.1365680-1-chenridong@huaweiclo=
ud.com/

Aye.

> > +       if (at_head || !last)
> >                 hlist_nulls_add_head_rcu(&lrugen->list, head);
>
> Do we still need at_head now that MEMCG_LRU_OLD has been removed?

Yes, for the "!last" case.  This is, unfortunately, a special case.
If you prefer, we could move this special-casing to the hlist_nulls
API so callers need not be aware of it.

--=20
Max Kellermann
Principal Architect
Hosting Technology

cm4all | Im Mediapark 6a | 50670 K=C3=B6ln | Germany
General information about the company can be found here:
https://www.cm4all.com/impressum
A member of the IONOS Group

