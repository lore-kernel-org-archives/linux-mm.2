Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45DE5606A332
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 16:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=pmsCvEI/
Received: by kanga.kvack.org (Postfix)
	id 576086B016E; Tue, 20 Oct 2026 12:01:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5269D6B0171; Tue, 20 Oct 2026 12:01:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EEF56B0172; Tue, 20 Oct 2026 12:01:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 11A4A6B016E
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 12:01:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6F290A793B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 16:01:14 +0000 (UTC)
X-FDA: 85343468868.28.E0093A3
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf13.hostedemail.com (Postfix) with ESMTP id 745032000E
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 16:01:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="pmsCvEI/";
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792512072;
	b=E+stIwfCDrctAPcHnU1nbl5w9uTXY2b+cu4davjuMn81xFEYGCkZYcL9xcvpdBCwiIIoq1
	uhF01IVX/Llkh6C7UgbDdtYO9AVX+tVjcw+5eem9DK8px/ZC23pufUG79pmPIt9JMXsB4q
	H8Pf7/UxgMjjNFZjKkwwd1bkVQwZ+70=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="pmsCvEI/";
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792512072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HeZwgriUF7LL7AlcLgHE2qOU1a0jMQO559qSB3XGdoQ=;
	b=TQ1aREQVfpsA/OX0YdI+n6cy2/2Qvew5SZgpLiz3KO77dRRpSM530rOUOi3Bq78eza03TM
	rJGYi4j3mbLxYLbvej3yh7UIusA/ldfaZ4+w2fpZI43xEiHvxpeHRN3ZnxQ6Vy9XTeKuh7
	13fykg3zciMoBI5wds1JeP4pZCnlGwI=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6b1aa27963eso1209714a12.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:01:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792512071; cv=none;
        d=google.com; s=arc-20260327;
        b=dVQA4Oh7wNPNLPJ4Mb1f/aHkkCZqUMjlwTA5i7nGFo5TJTsWMHPoo1Da9Qp6Ot6edq
         UEzHOeJGYnCkE4VmqJEMS2oAiLBsmdFFtUX5Jl0r5OPMqTx9uE5gC2Qi4hndUPFj2aVD
         0pVjVSV6mwU3OcttG5vxP4GeZnibMYowe+R4R/ZURkqjUWzOJEVT92ADaGB5E5aGGsT/
         mSc4d4ayxWxgV+85DJn8NRuKdamxw2gO2WRJgRrvQoQ8YPuj0s2zGsx6vcC5vBq+nUCJ
         ukwEm33OOT6/GTnDLVJE6k3FZMAypa4XC8VAz4ynRmwzIKmJ/kHgal4CrB+nt8T5uhyZ
         +fIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HeZwgriUF7LL7AlcLgHE2qOU1a0jMQO559qSB3XGdoQ=;
        fh=fFHjkPSTu8UuBSIKVjX3ygJryuw7LEnH4J+4KP9lay8=;
        b=Oq+dQiNUBDF23ngnBgRa/o2zsib/pqifQ+R0Dc0eUkG3MJR0U2JNQBOju00s0gdnd6
         4xIrZz/WA6I88CBKuFAlq2bEnX5RZQWZfWalWS8Sn5usXECyQdUfc0cGv0wN+WWvUEAn
         Fvl6ghDewa6vNqhp1zjT933vprHeS3wG92ohoi6ue7husX0zDuScklscdkV+g2oPT8PT
         4VOvQbAlJXh+x4H8gpy6UsZKTtOyLB5JSxcdyOfj2GsHGJy2fxzSwDsoLzJ82W1l9o+3
         DBsTnVXGiYWb6Z5bGmlq5bOAT/OERrS5MRBPxE3zRJ8Oma9diA3+RpxXIzFqJq958Jf3
         zqHw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792512071; x=1793116871; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HeZwgriUF7LL7AlcLgHE2qOU1a0jMQO559qSB3XGdoQ=;
        b=pmsCvEI/2+DW/dz047N9EmN5BnHMoUdppqnDQqy/OTg/lbOIebHGEJnIK9sPPfNcif
         cziu2hUONPBH/h3q0Ib9RFAKdBpCPuSIjjENMQ9pFwxts+XT0XeQZJvR1SQBF+fjchze
         /nOwJ/MDvW32hF5rf5AS83/qcZhGcKP31pQFFVHx1/oZwzTtcyg2aFhqPDYo7wD571Qy
         GAsETBq9Dy8dNGiK+3DY+48iBg2WEzqP2Xze5mAg7ecNQQ0+ANzhIHBADxsB/+8zKMCM
         L/jD2LENP1/tBx0YZ3zed5GO7QmfY2ho9UrsDYSGHLer/TICEZBi1QruI4UuwP1EBLt8
         mg1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792512071; x=1793116871;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HeZwgriUF7LL7AlcLgHE2qOU1a0jMQO559qSB3XGdoQ=;
        b=JsvN+5WR8H2aqGjItUyXOV4uTWosCSR/lykvyO7mANBdYo2PWf7BpqEhdCbd+UocCv
         S3/vtPNnhWCLEg0fUap/mbllrhxLHcGvf81XMSyFCPYWFduy89aemcn90/ArRlsFn8sG
         CRqJt6VZXgcPXf0JyAcYZS5R08yuTW+gltijqshEGm3MiNbl7yJlFcCORSY/GQ6Hy6PO
         oNTSc9oKZOEHN2neUOqSA7PYvU2/HXxRAMOrNBNPrwqMfyYknRk0LgD6uNaMmszMzRD4
         EYHrLzyMkEwpU99MtS67isg9Lh+I9Nimrm0GI7Vj55C7F+I60bQG1MqgrsWTRdS+57W7
         knVg==
X-Forwarded-Encrypted: i=1; AKwUvBy6J/srsfAHisH+9fk5lLRiAYHezmjpmlAD3hwr4YgMVYbAqv8k1sIiNKrdAZc81kSnqxqLdW6T/g==@kvack.org
X-Gm-Message-State: AFq9FYIWLe1GIkpcgcnhOVox8tcKxpKAMOsreWQxJSLeUTQFuew2mBby
	4OjLw3Tcn1vSgrd1IcvYIhVeA8H5FGuZ1z3/5QmbNOJ6TpuKMCTfxUTAXDSfgt4jZfLua8PXkBQ
	ADvqT0mP1FaSQL9rQpnlUHSJlA2BClAE=
X-Gm-Gg: AYBFou3S3EDUmEjHUf8DN2BuFf55ISqO9rCH8LZGlxbSCpPz565QE1nnOsFyZW/Xj39
	KRU2xHSeDO7/UyvD/l0TTbu6Xi8ORr2XPqVXD+6FcwxVP+ibOFsodnFyg8G5Snywnil0SsHW8rx
	A1M13m3vfndf2A5gBuH+UEDsSKyQ5DnPt/WYMSjd/ByGLiYrBL3Obj9zGMERztvscdd0ml3yKLt
	hey0I7SOK5kIrlwPQdGA3ILadJrYdb5QeKaO8qOKBgUd5La/qjdHhHE40f/SbWuOkk6dhxSQOIU
	uLk1tTLyJosT/TPsjtM8sKtXsECwGp3TxR7oiv3WZi4+ZXNOuC0toWQBsZ7aNahqvwy+YieNbY4
	dZvF8fZ6kmNzNTCy3nxXaGuw2WRwU4wpJPxhS7DMxMZAs/O3ffCR02BbuBAdvHxpOEZDkkA==
X-Received: by 2002:a17:906:1007:20b0:c42:6632:a369 with SMTP id
 a640c23a62f3a-c46044f0844mr152320366b.21.1792512070606; Tue, 20 Oct 2026
 09:01:10 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261020023548.3242028-1-ridong.chen@linux.dev>
 <CAMgjq7BonFtsvHMRYXXToqWBHTzNa52EU9B4ZqD-k-DJ2inQDg@mail.gmail.com>
 <CAGsJ_4yAYMiRoJRLLt9B_+qdMhOFmizDy-PSbQ3jkMxV0zJqPA@mail.gmail.com> <8aa3e14d-6573-4359-919d-a8e9d372032f@linux.dev>
In-Reply-To: <8aa3e14d-6573-4359-919d-a8e9d372032f@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 21 Oct 2026 00:00:33 +0800
X-Gm-Features: AclHuK9jZ-Plmsy-neTFF6d0Ihg-UjZ1hIhDVLA86eSGaSBJ72aBhXEAavtHBBc
Message-ID: <CAMgjq7DcmsyZUcaLSQeJYWgJ67N=PSSFEo-UpOM=HrHREnZfeg@mail.gmail.com>
Subject: Re: [PATCH mm-new] mm/mglru: clarify the generation placement in lru_gen_folio_seq()
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Barry Song <baohua@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: rp9hqwtioct54ph9xtaox4pfbefcwqfe
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 745032000E
X-Rspam-User: 
X-HE-Tag: 1792512072-723043
X-HE-Meta: U2FsdGVkX194COT9TqbBK43v8y75Jd+Fn4dfPW0yFZgu9ExmZrZy1To8m8buC2J85rUCOEZWRdL/k5JoOIhpNS5H/qjReO2h+to2O6/ool18XItteFVGQtAGgZYQNyEFHRu5jUjznArz+ZrCCisjCdaOJ77aAjxfQgUN4anVmgHGHTYakPDuQCeFQU5W24HRqVjDaSnfV4bUoTiD83D37pEDsBeGH3Fv3hssU4YW1WC+USBH/LE5yQqlemvkt2vnNk+dN19vK2hhuT2IMR0g1NodCai0TxI27S22voU3rx8UoEyKkSNiaRhU+bSto63/O0c9mYDKErWr9+K7ZsbL14ltCqOJg+/wvbxnQbB4CCmbv9iXDBnr6uQM3RL/rv28ay+voMpt27ByhBBjnu95kXben33VNkDnyN7fZDYqw8zQVbhNbY6XCnACmM+HHneNQeKm12En6B9ctwRE17qQ04xzadowufnGoZlIX48JDOch8DmQoQEPL38ZNyH00RJRwHYQSO8CIWdUNIqK8cSBENEXGbFKq/Q5FsxjI4g46j2j3DoGlSK5aEKflX0AxhS+PgyNWe9wYQSR5mqsXu3zrC7Sokct5zqh40TCEc4SnZ7GV4S64D+qqlNeEPLTI4dhP/pvPciJZh49Js3iVAJ7B64wiutwW41oeANXN/fIWdj2917RrT2EIegoYMexxqHUHO6xAOU2oiKqcnY54XpxKuJDGNxThKAkoS1IRalpKQREylAEysbhUE7e7rC9roIT6kwJItekpVC3PXn/nRDvudaDPM760KDZMGHAra61l6Z/99+18+tADK+mF3EGUJVxO6JQ7aJPIe6QBoUcDMlM+zNYET1PN/cxjGIfDMdeynMNHmGgt18X5tlBNknJa0N6lwORDZJYd+nyBNUhYAlo4Tft95tSLl3WszM2MigqAp+NcRSmrmiBKBIto9Hehr1TemHLWEaSr4leLPmk8cE
 L1sEGy4j
 6VqstGBPLPVn76cEw3J23yL0IA9LP/7TACUex6wVPLy2/pp84ppxE95tZl5umZj+UTlluiBOiNap/XJecjbQ3+v552Q1RyU529xq1m9NeVngfALV2D675KW211ttCGgcFcW7t5m6PXKa+/R9t4S5Amsvyc+jur0agkrMcQrKq09HWJ7Pr4oRBTeUVH68Gk2oKrLL5yFzi+SP1BPRKS63Avg4bvSd0habOpJpJUIHK3wqMuGp2VbLBOZiuKyBg2dq/SlPgniR3kC+psjKHHUi+GJ2jsfmlIls/qo1hXVB8xL/TJkKLHM4aiqgQUHpOoWjvc42DnGi8NtOUFW7OT6hcdLFYyCY9OpI9/5mAw0kUul8/Pgr9zrrc+uyWaB58HuXhoS/P6YzaBTWQDMD3uJ2aRwwooEX65QKnzTUPNBfX/uyPzgymVSTBhQp11WLhHsvQM5oVcYk4aUd3hQtKE89+LHQR8o7x435yRcFUV7H986CuSryOmu4/TPVK8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 5:27=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
> On 10/20/2026 4:29 PM, Barry Song wrote:
> > On Tue, Oct 20, 2026 at 4:20=E2=80=AFPM Kairui Song <ryncsn@gmail.com> =
wrote:
> >>
> >> On Tue, Oct 20, 2026 at 10:36=E2=80=AFAM Ridong Chen <ridong.chen@linu=
x.dev> wrote:
> >>>
> >>> From: Ridong Chen <chenridong@xiaomi.com>
> >>>
> >>> lru_gen_folio_seq() computes how many generations below max_seq a
> >>> folio should be added to, but stores it in a variable named "gen".
> >>> Elsewhere in MGLRU "gen" means an index into lrugen->folios[], i.e.
> >>> seq % MAX_NR_GENS, so reusing the name for a relative offset is
> >>> confusing.
> >>>
> >>> The comment table above the code also no longer matches it. It only
> >>> covers the PG_active and the final branch, leaving out the reclaiming
> >>> and "can't evict yet" cases, and it lists LRU_REFS_FLAGS as an input
> >>> although lru_gen_folio_seq() never looks at it.
> >>>
> >>> Rename the local variable to "age", redraw the table so that each
> >>> branch maps to the age and seq it produces, and note that the result
> >>> is clamped to min_seq[type].
> >>>
> >>> No functional change.
> >>>
> >>> Assisted-by: LLM
> >>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> >>> ---
> >>>   include/linux/mm_inline.h | 48 ++++++++++++++++++++++++++----------=
---
> >>>   1 file changed, 32 insertions(+), 16 deletions(-)
> >>>
> >>> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> >>> index ab69b9930893..a933d8c14558 100644
> >>> --- a/include/linux/mm_inline.h
> >>> +++ b/include/linux/mm_inline.h
> >>> @@ -302,34 +302,50 @@ static inline unsigned long lru_gen_folio_seq(c=
onst struct lruvec *lruvec,
> >>>                                                const struct folio *fo=
lio,
> >>>                                                bool reclaiming)
> >>>   {
> >>> -       int gen;
> >>> +       int age;
> >>>          int type =3D folio_is_file_lru(folio);
> >>>          const struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> >>>
> >>>          /*
> >>> -        * +-----------------------------------+---------------------=
--------------+
> >>> -        * | Accessed through page tables and  | Accessed through fil=
e descriptors |
> >>> -        * | promoted by folio_update_gen()    | and protected by fol=
io_inc_gen()  |
> >>> -        * +-----------------------------------+---------------------=
--------------+
> >>> -        * | PG_active (set while isolated)    |                     =
              |
> >>> -        * +-----------------+-----------------+-----------------+---=
--------------+
> >>> -        * |  PG_workingset  |  PG_referenced  |  PG_workingset  |  L=
RU_REFS_FLAGS |
> >>> -        * +-----------------------------------+---------------------=
--------------+
> >>> -        * |<---------- MIN_NR_GENS ---------->|                     =
              |
> >>> -        * |<---------------------------- MAX_NR_GENS ---------------=
------------->|
> >>> +        *            +-----------------+-----------------+----------=
-------+-----------------+
> >>> +        * age        |        1        |        2        |        3 =
       |        4        |
> >>> +        *            +-----------------+-----------------+----------=
-------+-----------------+
> >>> +        * seq        |     max_seq     |    max_seq-1    |    max_se=
q-2    |    max_seq-3    |
> >>
> >> I think this comment update is not beneficial, we might have more than
> >> 4 gens in the furture, so hardcoding a number is not a good idea.
> >>
> >>> +        *            +-----------------------------------+----------=
-------------------------+
> >>> +        *            |<---------- MIN_NR_GENS ---------->|          =
                         |
> >>> +        *            |<---------------------------- MAX_NR_GENS ----=
------------------------>|
> >>> +        *            +-----------------------------------+----------=
-------------------------+
> >>> +        *            | Accessed through page tables and  | Accessed =
through file descriptors |
> >>> +        *            | promoted by folio_update_gen()    | and prote=
cted by folio_inc_gen()  |
> >>> +        *            +-----------------+-----------------+----------=
-------+-----------------+
> >>> +        * PG_active  |  PG_workingset  | !PG_workingset  |          =
       |                 |
> >>> +        *            +-----------------+-----------------+----------=
-------+-----------------+
> >>> +        * reclaiming |                 |                 |          =
       |     always      |
> >>> +        *            +-----------------+-----------------+----------=
-------+-----------------+
> >>> +        * can't      |                 |  anon && not in |          =
       |                 |
> >>> +        * evict yet  |                 |  swapcache, or  |          =
       |                 |
> >>> +        *            |                 |  PG_reclaim &&  |          =
       |                 |
> >>> +        *            |                 | dirty/writeback |          =
       |                 |
> >>
> >> I think it's better not to describe too many details in the comment as
> >> it actually easier to just look at the code.
> >>
>
> Fair points.
>
> What confused me about the current table is that it is not clear
> which dimension it is drawn along. The columns are generations, but
> the rows mix access paths (page tables vs. file descriptors) with
> the flags that protect each of them, and some of those, like
> LRU_REFS_FLAGS, are not inputs to lru_gen_folio_seq() at all. So
> when reading it next to the code, it is hard to tell which branch
> puts a folio where.
>
> How about keeping the existing table for the design overview, and
> just adding a short note above it on what "age" means, without
> hardcoding the number of generations, e.g.:
>
>          /*
>           * The folio is added to seq =3D max_seq + 1 - age, so age 1 is
>           * the youngest generation. Ages up to MIN_NR_GENS are active,
>           * and the result is clamped to min_seq[type].
>           */
>
> >>> +        *            +-----------------+-----------------+----------=
-------+-----------------+
> >>> +        * else       |                 |                 |  PG_worki=
ngset  | !PG_workingset  |
> >>> +        *            |                 |                 |       or =
       |       &&        |
> >>> +        *            |                 |                 |  PG_refer=
enced  | !PG_referenced  |
> >>> +        *            +-----------------+-----------------+----------=
-------+-----------------+
> >>> +        *
> >>> +        * The resulting seq is clamped to min_seq[type].
> >>>           */
> >>>          if (folio_test_active(folio))
> >>> -               gen =3D MIN_NR_GENS - folio_test_workingset(folio);
> >>> +               age =3D MIN_NR_GENS - folio_test_workingset(folio);
> >>
> >> That's a very nice rename, the `gen` variable is so confusing to me
> >> for a long time, I thought about renaming it to `gap`, `age` looks
> >> much better. Thanks!
> >
> > Agreed with the rename part. Maybe this doesn't conflict much
> > with MGLRU-FG either. It could be cherry-picked before
> > MGLRU-FG or included as part of the MGLRU-FG series.
> > I'd vote for the latter.
>
> Sounds good to me. Kairui, would you like to pick up the rename, and
> the comment change above if you agree, as part of MGLRU-FG?

Good idea, will do!

