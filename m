Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A97FACDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 21:10:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E0CD6B0088; Wed, 24 Jun 2026 17:10:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76AD16B008A; Wed, 24 Jun 2026 17:10:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 634A46B008C; Wed, 24 Jun 2026 17:10:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B0716B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 17:10:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3B00A1C5D5F
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:04:16 +0000 (UTC)
X-FDA: 84916034112.04.AE6C85E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3924340005
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:04:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q8ilKcna;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782335054;
	b=Xp1VhQHLqyU7Q3gSs5jooeo/HdWKFKhlXdl/jjISb28kvRCKQ0l+G7IDYVQXW0MR9Xjd9B
	C7KqZFhIyL0CkU85ufL+9xlj/c3zTww0lf/MG0jXP9gVG0oOwWMJSOETAcaO7Qf+vsIWXh
	aLylhImj4thTNwtx89IbuO/2gIeVdKw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782335054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uhzfdr8rkOH5yXjCbu2XC5gM/T5oWvJSqZTjxiv2X2g=;
	b=m2yMatIQXuDJzaB9Bpw2Uh6P22zVA0zmiN4cEPvkgvb5JEm5JwYOIsZzThhEReQ2KADWQ2
	o2uLKVZ9VBuDoxVCzE0f+A5xUqmhiMjwS9N7HqN3R2TrJ+wRE6Za6WPGkk/eLm3FEhfahk
	pw5nqUZnuK1ABtTTKSdz140lYYyBAb8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q8ilKcna;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 748BD4439F
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0771F00ACA
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782335053;
	bh=Uhzfdr8rkOH5yXjCbu2XC5gM/T5oWvJSqZTjxiv2X2g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Q8ilKcnamutl68M4TDwiacr7mqdGuigj6cqO2IydgpXDfcb7Nwg1HKhkUXCUtOnbt
	 Ze0VjvpmL11T82CZ89dg82SXGMmFmSpd4H+N3dQ85Vlf5y4983MVE/+w6DjprXzqiV
	 wE4MLkjKwPvMbVnNPE8mswg1RGlQLZhsm+eF8HvLnoj2XWuuNovSHGb2z4nL/lEAX5
	 dBVW3R7G+eQkdw2HZPxY2kz7lYly5CV97X/LkaMudV/GveNGb3Ij5e3N6pZY/7CEZL
	 5sLPOHuKwNhh6IskXbnw4r1hLBzCZHX8Y5lyPmfwaSnlAOdtXh9jGI1QhcGmYyG1xx
	 ZBPAJH9y3mwQw==
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-9158fbaa4bbso147384385a.1
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:04:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/u7QLt73aF7q0baEXvMmfq9geXPuROje8Jiv7hzRjGU5fuEMnjbyH+zE3dupvLqQ0xC1RboADFYA==@kvack.org
X-Gm-Message-State: AOJu0Yxe83ypXmMlpVO/ebqoh/OUFducU0R9XfXBucf5WAADDa1sxw5n
	jasW9NfMikTyFCkM4eA3WJKt2S/2hdxIP/UlheEmUoBbp2uqSgr3hPwA/vcTzGCuZyHBcXJxY8V
	RzNM5kWMvZg3BaV/KyovMag/W3GtLIaQ=
X-Received: by 2002:a05:620a:44ce:b0:925:42fa:76be with SMTP id
 af79cd13be357-92781a19f4bmr867328685a.13.1782335052657; Wed, 24 Jun 2026
 14:04:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260623231635.43086-1-baohua@kernel.org> <20260623231635.43086-2-baohua@kernel.org>
 <bf2bbffa-dc68-4a3e-a8e6-1ad57c10255b@kernel.org>
In-Reply-To: <bf2bbffa-dc68-4a3e-a8e6-1ad57c10255b@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Thu, 25 Jun 2026 05:04:01 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wJ-2JFY4+ADf-Bn2PrbpvOnWeVwZY3unKnB=TZ71-hzQ@mail.gmail.com>
X-Gm-Features: AVVi8CdSh7x6vNnGkcceMki29IY2p3mKEZYZxFqaai6GdXVCfMeteq7IwBxne7c
Message-ID: <CAGsJ_4wJ-2JFY4+ADf-Bn2PrbpvOnWeVwZY3unKnB=TZ71-hzQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] mm: avoid unnecessary lru drain for wp_can_reuse_anon_folio()
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, baoquan.he@linux.dev, 
	chrisl@kernel.org, jp.kobryn@linux.dev, kasong@tencent.com, 
	liam@infradead.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
	mhocko@suse.com, nphamcs@gmail.com, rppt@kernel.org, shakeel.butt@linux.dev, 
	shikemeng@huaweicloud.com, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, youngjun.park@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: awykqxs4c8f43d8hxawgbt1dwhk1hfhp
X-Rspamd-Queue-Id: 3924340005
X-Rspamd-Server: rspam06
X-HE-Tag: 1782335054-417810
X-HE-Meta: U2FsdGVkX1/F2M8R44HjpTWF1Ko3gQ4kSqZaeCgJ90Iebc5JDi9tyw6quo+joFpcgYdG/nHhvH6tk4UneJRLURw9e9x/3E++kPab6W8RvrKT7byx4mbOm1i1K5d/EtBTeITgXGCTOnPOEkCXqzhAZor21BiKzOCCNsgYd4h0UKccBTxXB84vugpXH1yjv3oSRqxs5TeeSFb1FG7qsw3GeYVMx4dxl8yb3Y1iKax7C2WIslg1EeoLJtae9t5wcyQu/LfxkGlOKrVz/upxtiqkxdJ8x4eFAJIym9UcMmwI6LCILeSkXT243HuNq6ZUf4B/m+kKdMB1zvrNeqqk4mtXCo2bw8M+h6FUSnOn+TOBIMFC2tRJlbvoypOJ3L0KY7pGibaYrbaiDFWJFEuPNL5xiZ9D0InlPycm2lWuTScWnEtQCwBb/5UIeuF5yrLBiHmkJUUKphhZPfsZaFaQOP26ujGZuiuooAQVOIKAKShxb/sO4k5mBkRxMgE5hZFGS9ydUofjsObu7wRjhPZIx8STfcGAL6K8IeLqdTlVxlKLx646ql/HnT+QoCdFcgEBnffZ+ybHsfhX5z0Ir2ULipdLRBi3wmqwJm3gV/W1TRplMBN5Fd2fqUZzHjqd7WcQpR4M0EUQ6dM3JFMLlc9TtBZ1Xzp04ghbcGQJ63Z6KvoeNsYEtaQO3aWvDiBluBPPBm5YUaNifHlGQF/phRe6ZV8SP8TOMDBQ06OHo2eTmIynRqx7ultMDqxcrbWY6BxM6Kc9PH8nxoen8NM52V8fvC1iyOeZBfiXEb94CIV+ZxFUQAQMddIYxDY3s7GVRhn2CDp2FgPjs+/++NHuBfd8pGz0JTKX4Ax0FBwkWb7TU48zsL9oZt0pLt7T34rYPs1zROxJhYMQWh5awF8ahSodyYRwv/MU38AUvVP0/GAK1f/RPhp5YLjGcOT1/OsSeGrJ1iNRLpUfGmMWTcc26w8P9Yj
 in4nTVpk
 1qkZL8mR8KVVg+B8xGBMU1JO1ojuViKLl6dtXgwRscDJO55s3r3T3MI7m5lITpnbhno5XGULODJFazO5q3qS5jAK5RJJLlBOD0fes5l/ZcidDubO1jSfhe7WNUnfsPSU35iBFp3YN1lm9tQ4uxUMFMHcBFSilvicRRMwrZhuOKnDRbERqfhrkj4TFNbyJ4ds4nzup9xgfUVKQ+OFjUId45ROeUrsGty3Jfaps5HDlFLpUjxH/wQMVEwaCXwyID5eHYvDcp3j8rRyuIvt2qZbNGJnuYZ6LOv1gYacOcbmGkiXSsGhSo+R80reorYZp3xK1mYcn7Cl0sR4pbfVqHmhYslDFXr17Hx9sH6WITv2NCpVz3JG/PXZ2X8w6zFvS+a9sh3kE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 11:02=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 6/24/26 01:16, Barry Song (Xiaomi) wrote:
> > We always unconditionally drain the LRU before retrying anon folio
> > reuse in wp_can_reuse_anon_folio(). Instead, assume !LRU anon folios
> > are in lru_cache, and use the refcount to avoid many unnecessary LRU
> > drains.
> >
> > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> > Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > ---
> >  mm/memory.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index ff338c2abe92..f6848f4234a6 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -4193,12 +4193,18 @@ static bool wp_can_reuse_anon_folio(struct foli=
o *folio,
> >        */
> >       if (folio_test_ksm(folio) || folio_ref_count(folio) > 3)
> >               return false;
> > -     if (!folio_test_lru(folio))
> > +     if (!folio_test_lru(folio)) {
> > +             /*
> > +              * Assume folio is on lru_cache and holds a cache referen=
ce.
> > +              */
> > +             if (folio_ref_count(folio) > 2 + folio_test_swapcache(fol=
io))
> > +                     return false;
>
> I'm not keen on making this function even uglier, so no, not like that.
>
> We have the earlier "folio_ref_count(folio) > 3" check.
>
> In which scenarios can you trigger this such that we would care?
>
> If the answer is "I don't know" there is no reason for a change.

As I replied to Shakeel in the v1 discussion [1], this can avoid a
large number of drains, both during Ubuntu boot and under normal
workloads:

"I booted the system into Ubuntu, and after

boot completed I observed:

wp_reuse_skipped_drain: 5542
do_swap_skipped_drain: 0

Then I built the kernel in a 1GB memcg using zRAM swap, and observed:

wp_reuse_skipped_drain: 25017
do_swap_skipped_drain: 43595

So in summary, even without swap-in we can save a significant number of
drains in wp_can_reuse_anon_folio(). With heavy swap-in workloads, most
of the savings come from avoiding drains in do_swap_page(), while we
still see a substantial number of skipped drains in wp_can_reuse_anon_folio=
()."

This is exactly the case where folio_ref_count(folio) =3D=3D 3 and
!folio_test_swapcache(folio). That is why checking
folio_ref_count(folio) > 3 does not help.

[1] https://lore.kernel.org/linux-mm/CAGsJ_4yCeAmpfo_8ef4MrRyRD_UtV-xGm6F4G=
pSjvLVPQsbiEg@mail.gmail.com/

Best Regards
Barry

