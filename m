Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E65FC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 17:08:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0E4B6B009D; Thu, 27 Aug 2026 13:07:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E97716B00A0; Thu, 27 Aug 2026 13:07:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D60676B00A1; Thu, 27 Aug 2026 13:07:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A81D16B009D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:07:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3872EA0135
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:07:53 +0000 (UTC)
X-FDA: 85147681626.01.3BE110B
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf28.hostedemail.com (Postfix) with ESMTP id 50B2EC0007
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:07:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n3TUn+mi;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787850471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X1Wah6nl+6SXRnAC3yP5MjJt6U0qsEQsAHa2pGjMsI8=;
	b=MNFIEfYrS6LryrI4jA45NGXjis6brdBmeYYuVSsoMuI5Ran83qPuOUZ1PZ0/0HzXEANf8V
	mUbI/qBUPZCrRvDsY8+PjTwv/s/+aggQrWYBQoC2i3WkTURfCr129UwLW04gkqn/ODeDap
	kagbgyVHlI/ilxsP492e7mUQlp9wx3k=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787850471;
	b=xhk3jYJBNRvDeWIQ7uk1654/WojzGl1OGgPavPXu00jJ4Qa7B8e8EhM3rLQWj3k147WtJ+
	sNHWTB+oG48eB+J/4954ndFt3GAGqr2ID/i2huf2yyBILN5A107Q3r4HJ7aqlsjg6ph6N9
	E4pFpjd8XD2NpWE/t22GhJW95PFaY0o=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n3TUn+mi;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c2529b3139fso10309166b.3
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:07:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787850470; cv=none;
        d=google.com; s=arc-20260327;
        b=b9jfQmkKEA/7QIVDek2aOpUHaJnwqs0F5yO8Kky/Bavjv7BKvqAhCFuEhsLgi87ahf
         dfezRPWiYweaZk6tuMO86jtt6ggFu3Q6Y5aCzvyVW8a2Kd/w04GJPhe60UKBu/ACWvuC
         ihuVlVMMZcr50si4Exw81dd9d4MS9cPn2qVKsIAsv+UzgzUTOW9UdB+r/3KDsllCyL81
         je/poko/A00zz4ForbMC71ZdL3g2/T+rgjw/97HdbWrwlxiznSO4kyp3pI9RjbwgFczD
         A1C3lEDVytnYULFnae+0jE26BEWHW7M97s9uXoLl0e1xgJtND0zujTwDN/5bTT8kbGO1
         mnUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=X1Wah6nl+6SXRnAC3yP5MjJt6U0qsEQsAHa2pGjMsI8=;
        fh=gW5ivs51vbjATpS7fTtCbsRWfHNWurt1lFXO5nnQLVM=;
        b=CQ2Woeuk/fMYkPGzwIkFf7LxpEbSI2tgKqXNhWdmvN4Z/VNGjrKMu/s1ExnJxzwkXm
         k3Fm0BGDrS9cY8NEonqwqwU/rNz3yzTO6vQ/uGCoybUK1FYvj4ykSz6O7jCL/4xYQHdO
         ++ZBEUcDQUM/Re7YX+n+WhhLcIr9P9ZLu6Ck7PT0+Uc4RbcKVoAAbqlArdsHzCVSeNWj
         o6edB4FqhLUt+OS+/qmRVP+qw7VdtLUqc9ie5yhCh24ZnHgsVjMlMBlxI2eNSB5lRlNq
         1IzQBFjH3Fd2VI6RaGxbtLGzkg5rFgNZkQqlmORxwxBF6dxf5rAWwnpeG24r6N2h+yb8
         bMaA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787850470; x=1788455270; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=X1Wah6nl+6SXRnAC3yP5MjJt6U0qsEQsAHa2pGjMsI8=;
        b=n3TUn+miVIVlami9KdCU/8kTyMl6uylfuLCeLiXEUVaL0SiNiRt+4L6PT9AbacKmph
         rKQ3j4DyknZe+o4F5uI7E3g2nJWog1a+smuMuVB4i23zLLZBB599u9qddIjhoAfwpaWJ
         CTu6/XS3rHzWOBOEAarQNdvHsoDY2wCE9ud50HwUmt91fQ9TVUQrJbhb15+k4pZFzwNr
         zRy5QaU89eAXC6gsg8MsBVV3V782QFH4Yzin0wK9+/vJWYuJDGpsLEbyKfpI8nlbifMd
         H6Z0fEb8e6p1eBf5wtqrAtaH5fA/fuGbSTq/2Xx9mF7ymXJoaHgcaDm7/pfTMhrg6953
         q0Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787850470; x=1788455270;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X1Wah6nl+6SXRnAC3yP5MjJt6U0qsEQsAHa2pGjMsI8=;
        b=cvtIvVqAIV/K0PnwjBg41ZkPGoJHX4wtAo+XgdU5YF/aFX38CiZYxO6fP0zo4Q4044
         oLFuhHU4plJNHbI0J1nA3hNJQPYicUO72pe3+qeLFb6H0QRciwKP7SCpN9iH5D4xPLzI
         h+OwoDLIdf7exl9TQFuHMmmRgglGN8vlV5X9FoHeYeaLNjGPnuNLK80cdDsjmYU5xvci
         3cPFhHGRvjDSVKeY6MhOmhvPJOTgT2l7HpFIMBmjVSAJxAbeQv3phlgHUfNF3H+UC6Ar
         jfluoaYxjniHXZq2kaLAYjOGV/97lpvAaANsrTafoEZi1X7tI0z8d11t/T5V8jcHmFmI
         TA4Q==
X-Gm-Message-State: AFuF++lvcADVJ/jG4Nb1POjma1dLvvkisred9spm8ZSiIY7GyU2jmgGW
	U/OEnOxkgUL43OQoIGe04z8pLImTcFmgWLZD/4DurBpRbOBeN3PezTncbQ1LpoOFhgQ6L7YsS3j
	2MSjyPz9OBh8COV0DCGEi14o3+6UP57I=
X-Gm-Gg: AR+sD13dMZjXAqqABkeJT0spveIh3qBRsnJST6weB9JOGNICOYjeoe5tzRrfioTrYsk
	pK1Q562DfCna4WI5OcEZIs7DYXCnbNA0GoyDWbcgXFj4/XvZ9uYzA1OdFYaC/FI2E/O4t3X7Je7
	ZkexzFZ/CEHcggoQjhJRuypLc7Xf6W879xj8PGoc5a8dEKyzViAh6Eo9zmOQXrQw48vOdIOOrB2
	tP9hzwAXO6JMbcXhYNXra8MDwzbZkt65XRCwhvDqz/NDdmOs2hHR4fZoLgWNhSLX5EFGClhxIdI
	EN7GnBW+qw1Z4qfnECABFxdNL+cszRCtvv5jNAn+sgHeoGsgyI6Z7oHSezqbiXCChQ9cEmSF9qz
	R
X-Received: by 2002:a17:907:9612:b0:c16:4e5:944a with SMTP id
 a640c23a62f3a-c25574341c1mr5180266b.21.1787850469508; Thu, 27 Aug 2026
 10:07:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-2-9b43f5163238@tencent.com> <50bb70bc-d442-43df-ab4f-a158c8b05ac7@kernel.org>
In-Reply-To: <50bb70bc-d442-43df-ab4f-a158c8b05ac7@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 28 Aug 2026 01:07:12 +0800
X-Gm-Features: AcwNN1VW04jGDYJxUtXMKMvDJ1L6CFo4aT-tplWH99K5U7NNuODw0RlF0OYIkHQ
Message-ID: <CAMgjq7DNdaBdQ5Y3ctg6kfydt6cKHWtO4hitx-MO2YDu4Q-Obw@mail.gmail.com>
Subject: Re: [PATCH v3 02/18] mm/huge_memory: fix rejection of swap cache
 folios with a mapping
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Shivam Kalra <shivamkalra98@zohomail.in>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: xkqprrnjzb7ojdeqr79617bjrj1m9uc3
X-Rspamd-Queue-Id: 50B2EC0007
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787850471-820278
X-HE-Meta: U2FsdGVkX19F9+gunbBfknFNv9riRvCZ2vtzI9GlXXVHkTSINSS0fZhuGr8N462mb+xv92hAyipW522AnUfymk1vuCNsIYUyfJZT3DZ1iuDplfFHOfCGTIkCkxFqH3LankHkOfSjGXbAIfHwmh++vtZjzEI+N4fkMEVsy6SbpPK9WhB2lcu1JfU3mhqlG67Z+DXHrLpW15XDvruNLsLvk1zmtzh43LWxwoT9qzk3oqtdzENkE15yXNYjDVtopNNd4bRT4jtdlGis/fExJpajKA9ZFLEkApdXyUSjTETgsjBIou4R6Amr6KDkqM2TsgzEqSaQKbIRwpM6otruz86590silbaDhwSUXl4Gwsu40HoqBjfCNQppAfbJUQhaFS2LeHp3ncF8j+0PEwa0eo7JIALJ3TAUkrf1Anv2I1XYYCz8tKgzng4CRJs63K3MlqFZEPQcRDEUKwFLD0OMSPCOn5Umdwf8SprLpKSJAsRzUiVY4B2zBw7WYsk3LG+IAjCIjPUHLCCwCqlpzB8oOnSJ4FPYvpUEfR/q6uix2Byqfy9/w+DmXIhC2h9kX5bz4dv02OA9L6EsEsKxyMJttX3zeMiHfFOPeDTjjQU2qVWrrMREdD4kG+X31q4AEkS6e5l1dKoJ5fexGR+73ERVGIHW6xbhF1RNhZGmPZgOu2fdcOZX2JibZAjWwTJbswq1e2nSODib0NW79XGGhy8A7dvuqBliYGvTyMFOuUxydoB8AaPLwP05JdNhPx+kBEkwsuaOzTG74P6O3p3XITqvCmI22uFQNVBmdwVBrvKEam4XS1sfZlbAb9UnEJCCBm7irqdhIGVPKnfTTSPiKrk50DRTXzmLkEvPt2OAhRDy5Wag2y9OHMcyYu8vQNkyIFqJRNKfi6tsq37bPxITArvUXKTxHLhpoVSkQqkVGih2PKyF6r5mS8Zfv7pGnl0VDNPTbeWYw0ISNCmFO540FusUAq5
 an71oHb+
 fKIf/Fg6bmTz7qF+MtDOa4nY595tgFdEHSvpRcNm35ZYssNC40z8brYaOsS7mgeOyxmffxY2vUUrMOaUCpAQqwOR2hYK+FWTbh6M0U/OM9PDx+76hQ27schZqc4VfrDTAWfVwx0PfodeGHd/j2/AdMhdqO6Allyg1pDUuYnP1X0S/wpe5YKdPkEXNdt0f44Q87oBstaG3Mq7egOwIO3dre9wJfDOa2LwQh9pAHtyhPD+xkKOZ2SpqxDMMlsOpY4guPLA6TBfLUNZ0AnuMQXGJf9jAKRJjnpIAbCXw7DfJ4f2/8xA1NNiWeTk5e6eSZ31An5xP8HNrUJLsG4yJxem8cC0emRnoeGPfGJBnL5mbqUej4V6rbDE5BINgvorG41f7maMG0br4wi376PMdrvblL3deqaCpbGRB7GNIgGa88NNottgIEw8GQxwpcVOyc7di7jzFGLASpW3RQL3FYi/+b/1jKmyIirjwp74uB0ooPM9i3xQrs7kEoIswocbzYUiGHdmCa02WAmiTzdY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 12:00=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 8/20/26 20:55, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > A folio in the swap cache cannot be split if it has a mapping (shmem).
> > The split code does a defensive check for this in
> > __folio_freeze_and_split_unmapped, after the folio ref has been frozen
> > and the NR_SHMEM_THPS/NR_FILE_THPS counters have been decremented. It
> > rejects the split and returns -EINVAL without unfreezing the folio or
> > restoring the counters. That error path is buggy: if it is ever taken,
> > it leaves the folio frozen and stuck, skews the counters, and fires
> > the VM_WARN_ON_ONCE_FOLIO for a state that is actually legitimate.
> >
> > Check for this case up front in folio_check_splittable and return
> > -EBUSY before any state is modified, so the split routine always backs
> > out cleanly.
> >
> > Also fix a bracket style issue that checkpatch.pl keeps complaining
> > about.
> >
> > Fixes: 00527733d0dc ("mm/huge_memory: add two new (not yet used) functi=
ons for folio_split()")
> > Fixes: 714b056c8321 ("mm/huge_memory: convert VM_BUG* to VM_WARN* in __=
folio_split")
> > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/huge_memory.c | 27 ++++++++++++++++-----------
> >  1 file changed, 16 insertions(+), 11 deletions(-)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index ced400f72d43..a6759a14e057 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -3878,6 +3878,9 @@ static int __split_unmapped_folio(struct folio *f=
olio, int new_order,
> >  int folio_check_splittable(struct folio *folio, unsigned int new_order=
,
> >                          enum split_type split_type)
> >  {
> > +     bool is_anon =3D folio_test_anon(folio);
> > +     bool is_swapcache =3D folio_test_swapcache(folio);
>
> Both const please.

Thanks for the review, got it, will update and try to use const more.

>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

