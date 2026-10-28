Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51BB860A2605
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 20:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=hLkTVheJ
Received: by kanga.kvack.org (Postfix)
	id 721DB6B05B2; Wed, 28 Oct 2026 16:11:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F9D46B05B3; Wed, 28 Oct 2026 16:11:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60F206B05B4; Wed, 28 Oct 2026 16:11:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3A69B6B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:11:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C53BEA024E
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:11:05 +0000 (UTC)
X-FDA: 85373128890.11.76D4F0B
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf03.hostedemail.com (Postfix) with ESMTP id D32C220002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:11:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=hLkTVheJ;
	spf=pass (imf03.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793218263;
	b=lxCUdhkaHEFLuKIbfMMPvmItY++X5hYlJmmZ1yq+hdAb40aglXYeFd0EEP+mdRPSdarNJE
	l5DtHqRYsRWODUy2QK6iOSArEWCNFDTHoTWfYcbb1Leamd1g59iARZljmrh/bQtRgKNRLG
	u3UG0b7pbWzsEIAGIPIV8J7FZq+Y2mg=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=hLkTVheJ;
	spf=pass (imf03.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793218263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ieVwSKOmF05EqHDhXoM6Ev5vmdo6Ln+FEC5KQGbFME0=;
	b=fCdmbEjwJaNeAu3mvmd773bzncBVfzDtLkRrXmR4/o5b6vgs8iU2VFm5RvTedgebwAbtsV
	2ZzWd+gdDFQM+OnHWf57iUoJUjCqK5KxDPv3QxpVuNNFv/dOBccmDADk+wnv176cBbwWC1
	OsoSPH17qmfAPNsRaqI7+g38CHTEj54=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a018493d57so18345e9.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:11:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793218262; cv=none;
        d=google.com; s=arc-20260327;
        b=pspLagQBrZBFMyxJ6aHvPkpmlstUNPE5ZnLKa+sYUbnmj5LLU6TjP8Arr33JyPmJpV
         O6LsDlsonEzcv69cq5bUdn5GPVAJA906NhABRhh8/iSG7YqWMbTBTtYNabuADjrUquUE
         /rtifIIzrV86XueWYYIpYYUR7dHmxRe7EEIpReR6dfzlq/A38FHLcFBtudqHjh+pSV6E
         KIta6L5iNeDzQqGHJhFehQA/4D/XkYV/Dj28gMFa42hlkEKDOJ3C+AJlc28PNfBXPlAh
         VGkeg2B3xPxufME0+SvlVQEbzAde49KDAE8ujzBHp76ogrVVK8KLw4T/d1pQUgVQ8vWd
         VUAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ieVwSKOmF05EqHDhXoM6Ev5vmdo6Ln+FEC5KQGbFME0=;
        fh=TXwqPoLOO+NGF8K64tyXahNlkfZFh+fowjxmz4frLVI=;
        b=o8Fj3vvXTOqPM6zTF/J7onKVBDcKS6yyOFqjh7ghAaIEjlzorSYlqJtmUl8jdD38z0
         MR1N4ROo8vxYyQK51VhZ2bIsDmjEAyCxd/wsHx2O3/gMxqdcEGEgoGwckoGaKcA1vhbl
         G0WbIUKkkhZ2lfRgMCAc8+A/QVBoOqm2q+qfaSiIQCApvzuUFdMEB5+NC2dfmFACBpr/
         cW1p1y6edOd02rdKro3v626KOy+G8rtT8WYSgSWeftevIedAb6qXeEB9mcWhDRZMgHi8
         K7PgjDuX3BJ/ld+Md1tEvg/I0a/PfYKMv2/xaAanMxRCevgmv7jLWeigjP0KjGuR+Q8T
         j2wQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793218262; x=1793823062; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ieVwSKOmF05EqHDhXoM6Ev5vmdo6Ln+FEC5KQGbFME0=;
        b=hLkTVheJRyHgCy7kcBAuyt3oKMbSn1v4mHl9zMaNisTSZjiLzS0KKG/neWgiGEizQm
         9uJYgMZb5xZMCRSbYcdgAKDYpy1g/LIVzaYS//0xfH/V1kw8USpVPm4HFLdXSOHSii8Q
         0RyvPLOkd9mddxcreyGGm47EF84vDTIX0urErkT6Po39IbBV5zJn3E1mHrSpIYJXc20Z
         qI+dZ/rvTgolYE3UFQNpRycdWHDC497Y8oVe7cCWVdus+C8rxXC7z4AXnYxAaChKqxRF
         ctESxkJrZUXKNP1NPBVy/MlHaSilnctXTkY4epQF+myQbnrr+UTcCJ+zYpKgAn2RM/1h
         f3Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793218262; x=1793823062;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ieVwSKOmF05EqHDhXoM6Ev5vmdo6Ln+FEC5KQGbFME0=;
        b=rxeNQdRsThHLUKCyPj/jyr4q9JIISWwV+oQtYEHJRV2qVC8FwTwVyGrpAt5+xBxVLj
         tiSPcLi8bFP+402/1dKJpdCAb8VBd++hWXa0h4KTXHwjUPXPcmzXUHLNTdCMbo8OTiBg
         lhhSF2rRYoo7vLiQg7pbXAJYgL2drghUBWRX3b3W7OJmg39OAYPRGmfH0YoI5brYVPVP
         CBG0G6Z6WdggE6rmxnBksTx1AQzfZTCNxhSDX5ILuilimg17Fdq30ohqzWC/rPsEl47Y
         6iFe+ILX6XVGiIvgI2HMhJdsEEX3B/UbJf87f/t/EAcSKEncZG8ETg9Q3aIvtGpczG97
         3PcA==
X-Forwarded-Encrypted: i=1; AKwUvBxSfHt1uhPqxrPYlBWc+G4fXPOU5skq3ut77ED0khr6BYAgYIW32lSXe8xum8fzvRjoFFlv8xFiaQ==@kvack.org
X-Gm-Message-State: AFq9FYKiTPqN8nVID0HsetGKXfEGxUxFG7OVWVsc5VXj28eZIIXqkwNW
	/6McQnKMj8yiUhGNsm4DTc4EOex9KyyDphJ7Q4Mo42Jesx9LljYBe6WugZIC1CtD1KL7fAYUwUW
	YxKN/aQqo0Se2s7ifU0fvsTVhcigHgK+RaeeB1zMc
X-Gm-Gg: AYBFou3ZORgs80Hg5FKySaHgMijjbBpeGxo1i4Hfv3jspzJB7HdYuct7yH/AxSAYtCP
	mh/cLWzPVb/k38tQ+SMVksk+S9m0Pdkpci9D34HyVg3tUstP7A/hNAvsPFuyy8CVkMom7f4sujZ
	jSwadSHT9SS8oCeu602gLTTURik3Ykn7BLxyXaAatHO8LbxVnDpxn2FzQP/LhsBqwRbSuheK01l
	lZNmY4vA4I0ON77DS4domRNhVF/IG81LZ52YkNiomt6RtV4aM/WH7hK04+Hs4X0acn2KRMnDbdq
	nLoWVm6RWrXWzaz2heiPK8LLaHeeHpX63AM10RDN3Iove7NgkcKJUJPC3yeIThjn5vUPeFFE39C
	psDcTQg7AkGpqjhw3o1OZMBpExBQZH0A5WkbW5K2G5wMmHrNfiZodPx0kiREtdG5ifwcijeo1as
	4x9ktniOfH01zafkJ61d2oT3k=
X-Received: by 2002:a05:600c:5903:b0:4a2:a8c:22ae with SMTP id
 5b1f17b1804b1-4aa9617c228mr122895e9.12.1793218262038; Wed, 28 Oct 2026
 13:11:02 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261028010611.3929937-1-tjmercier@google.com>
 <20261028010611.3929937-2-tjmercier@google.com> <auHLzLazLr4iA_Pn@KASONG-MC4>
In-Reply-To: <auHLzLazLr4iA_Pn@KASONG-MC4>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Wed, 28 Oct 2026 13:10:48 -0700
X-Gm-Features: AclHuK8Bs1IRBhRVIWz--v-y6aB5LNo_Pu_T9E7KUcmFBJKynmoafpKWfnr2kyE
Message-ID: <CABdmKX2xEPL3tTWS22rDeVeCKuT9QhW9QAQdXGLSjUJEvSnWiQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/vmscan: remove redundant !mem_cgroup_online() checks
To: Kairui Song <ryncsn@gmail.com>
Cc: roman.gushchin@linux.dev, muchun.song@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: D32C220002
X-Stat-Signature: bzz9ctjjen8ruh8ij8sdrrmr7brzpo5r
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793218263-22179
X-HE-Meta: U2FsdGVkX188riece4jJiSY+pYL6QXLHlbIfxrtqjG7AUXhlZSgaJGqUoELUrjwGx9hKmihXwKxjeOtmMjoDcRm5z3FjvmSQnDA2DQ/OxyKf2T3KTtiitDG+Zg9EAZDlVOOvK/6DbzcM63RS2wHO8BNNnmCRhD1TZS3Px25SVxCYGtvt+Ts9obJ7+eD/h+0G3QAXa1u+MD9znANkllRxaRc72Q+fQ+pL/IcASENnkUCV+ziG5CpzCX5r+6ZwK1cWKkuREXp0msTLp1rsaRZ4OARiLMfAS3ahNpdOyWb5uT/xMs0fFFxWaynQNzdcZJDy55KbutPR0x+cleOygHKShsesgecDPnaHHAMDQP1H8muhI31VxiQ0XcgnfwjfskueR1A/YDkGmW1bDaC4KkmOtEMt2S1o1qrd6YxgzPLMauTig9sQUu7S//71i24qikv+Nrvs8eQlKfWJCEmwbggBaD+AKYWwNtN1C2BGqLhT4DT4HMtjKgGxhOlG5mlY9fPKCKN2ISJQR9TBxBL8UHUZ33cwOteOwXs7xWHnf6bMQNn0uW28zFK7Lo7zHiGcLUBfNyoeczO0UfvKcHC8UrLfBM3p50pjzUf2Ekqn7PZ2E5YCwDVJumS7rwr76ounR1GHHsyl6kfIYFAy9LmmAydVhErz98tHae8PYm7NIs5F+2G84X7ZXNXauMPEuRJyOXZYMjjhjXJDZnTOHWh3rEpymiR9/2f8FMxKEHcZV797MN0iEwIK5vCiU2tzX5jk9kpgGl8OTDZ/xk28ndDFFbaIVa4UDjbWIowkrHmhREvmdRB7GTubzOK+w1SPK6xHgq0BUhbudrGJ9E/Nt1grkYxTfRmBIqZ2BJDPuKBh+c9Gp0+n0WZnMW91kdQ2WoGGBEFETiyK11cWhZzBKSxyCTh5sR5gKrmHsDMx12RxR0Z8ddDpXcneFrAVAmAecAZXeAjsMI4RIE7ZX9RUldamne9
 Sw9pa1pD
 +mNs5aNy0FtPpAl2dEB1obZQQO22q1IpZN4l2s4G5HihYX0dsibMAb/p/LQ7I1AcJOuURG2/O910H+u9Y0OWxT9ZlLXsAAgmKJa0UtxtXG/Xia0TZ/308b6sHkK1mopSbzxfVs5/H5JzYygadZDMuyxiOLmed7BkMSBLOXz2BMU2v9S9V3ZVO//oHtMAY0neqH7OLdfzfOpYR3DgOg4pDFuoiqlI7hL2ksFmjqnD5X3RnUBrug9Jlr+qr8pwOqHccMdSI5/W1XGNVjD6KhNg0siDVquluuh8FNLvQBdejfm+sAr4Stx3mBLrYDbiTNrNQ4DdpPY1W7WgylN2O2Z99TepqPCTGZrA3GAuJuJCFjZiKqau6nUkWyC+XDlG06OktYwZ6izJxkk3DKvFhVFq363/Sag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 3:20=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Tue, Oct 27, 2026 at 06:06:05PM +0800, T.J. Mercier wrote:
> > Since commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of
> > dying memory cgroup for LRU folios") and commit 0e0ac326c511 ("memcg:
> > move LRU size accounting on reparenting instead of copying it"),
> > mem_cgroup_css_offline() reparents all LRU folios to the parent memcg
> > and zeroes the child's lrugen->nr_pages and lru_zone_size before the
> > memcg is offlined. Nothing can repopulate the offlined memcg's lruvec
> > afterwards. A folio that is off the LRU during reparenting looks up its
> > lruvec through its objcg, which now points to the parent so it is put
> > back on the parent's LRU.
> >
> > As a result, lruvec_lru_size() and lruvec_evictable_size() are always 0
> > when !mem_cgroup_online(memcg) is true, making the offlined memcg speci=
al
> > cases in get_scan_count(), lruvec_is_sizable(), and shrink_one() dead
> > code. Remove them.
> >
> > With the get_nr_to_scan() special case removed, an offlined memcg that
> > still has stale effective protection now has
> > apply_proportional_protection() applied like get_scan_count() does, so
> > the MGLRU and traditional LRU behavior is now the same.
> >
> > Signed-off-by: T.J. Mercier <tjmercier@google.com>
> > ---
> >  include/linux/mmzone.h |  8 ++++----
> >  mm/vmscan.c            | 28 +++++-----------------------
> >  2 files changed, 9 insertions(+), 27 deletions(-)
>
> Nice!
>
> >
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index 3b96d6c7123b..7f078ff0dd76 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -638,10 +638,10 @@ struct lru_gen_mm_walk {
> >   * The events that trigger the above operations are:
> >   * 1. The first attempt to reclaim a memcg below low, which triggers
> >   *    MEMCG_LRU_TAIL;
> > - * 2. The first attempt to reclaim a memcg offlined or below reclaimab=
le size
> > - *    threshold, which triggers MEMCG_LRU_TAIL;
> > - * 3. The second attempt to reclaim a memcg offlined or below reclaima=
ble size
> > - *    threshold, which triggers MEMCG_LRU_YOUNG;
> > + * 2. The first attempt to reclaim a memcg below reclaimable size thre=
shold,
> > + *    which triggers MEMCG_LRU_TAIL;
> > + * 3. The second attempt to reclaim a memcg below reclaimable size thr=
eshold,
> > + *    which triggers MEMCG_LRU_YOUNG;
> >   * 4. Attempting to reclaim a memcg below min, which triggers MEMCG_LR=
U_YOUNG;
> >   * 5. Finishing the aging on the eviction path, which triggers MEMCG_L=
RU_YOUNG;
> >   * 6. Offlining a memcg, which triggers MEMCG_LRU_OLD.
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 9959ca158ce8..636152d8c94d 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -2754,13 +2754,6 @@ static void get_scan_count(struct lruvec *lruvec=
, struct scan_control *sc,
> >               scan =3D apply_proportional_protection(memcg, sc, lruvec_=
size);
> >               scan >>=3D sc->priority;
> >
> > -             /*
> > -              * If the cgroup's already been deleted, make sure to
> > -              * scrape out the remaining cache.
> > -              */
> > -             if (!scan && !mem_cgroup_online(memcg))
> > -                     scan =3D min(lruvec_size, SWAP_CLUSTER_MAX);
> > -
> >               switch (scan_balance) {
> >               case SCAN_EQUAL:
> >                       /* Scan lists relative to size */
> > @@ -2769,14 +2762,8 @@ static void get_scan_count(struct lruvec *lruvec=
, struct scan_control *sc,
> >                       /*
> >                        * Scan types proportional to swappiness and
> >                        * their relative recent reclaim efficiency.
> > -                      * Make sure we don't miss the last page on
> > -                      * the offlined memory cgroups because of a
> > -                      * round-off error.
> >                        */
> > -                     scan =3D mem_cgroup_online(memcg) ?
> > -                            div64_u64(scan * fraction[file], denominat=
or) :
> > -                            DIV64_U64_ROUND_UP(scan * fraction[file],
> > -                                               denominator);
> > +                     scan =3D div64_u64(scan * fraction[file], denomin=
ator);
> >                       break;
> >               case SCAN_FILE:
> >               case SCAN_ANON:
> > @@ -4355,12 +4342,11 @@ static bool lruvec_is_sizable(struct lruvec *lr=
uvec, struct scan_control *sc)
> >  {
> >       unsigned long total;
> >       int swappiness =3D get_swappiness(lruvec, sc);
> > -     struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
> >
> >       total =3D lruvec_evictable_size(lruvec, swappiness);
> >
> >       /* whether the size is big enough to be helpful */
> > -     return mem_cgroup_online(memcg) ? (total >> sc->priority) : total=
;
> > +     return total >> sc->priority;
> >  }
> >
> >  static bool lruvec_is_reclaimable(struct lruvec *lruvec, struct scan_c=
ontrol *sc,
> > @@ -5199,10 +5185,6 @@ static long get_nr_to_scan(struct lruvec *lruvec=
, struct scan_control *sc,
> >
> >       evictable =3D lruvec_evictable_size(lruvec, swappiness);
> >
> > -     /* try to scrape all its memory if this memcg was deleted */
> > -     if (!mem_cgroup_online(memcg))
> > -             return evictable;
> > -
> >       nr_to_scan =3D apply_proportional_protection(memcg, sc, evictable=
);
> >       nr_to_scan >>=3D sc->priority;
> >
> > @@ -5325,13 +5307,13 @@ static int shrink_one(struct lruvec *lruvec, st=
ruct scan_control *sc)
> >
> >       flush_reclaim_state(sc);
> >
> > -     if (need_rotate && mem_cgroup_online(memcg))
> > +     if (need_rotate)
> >               return MEMCG_LRU_YOUNG;
> >
> > -     if (!need_rotate && lruvec_is_sizable(lruvec, sc))
> > +     if (lruvec_is_sizable(lruvec, sc))
> >               return 0;
> >
> > -     /* one retry if offlined or too small */
> > +     /* one retry if too small */
> >       return READ_ONCE(lruvec->lrugen.seg) !=3D MEMCG_LRU_TAIL ?
> >              MEMCG_LRU_TAIL : MEMCG_LRU_YOUNG;
> >  }
>
> This part looks much cleaner, thanks!
>
> Reviewed-by: Kairui Song <kasong@tencent.com>

Thanks Kairui

