Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22361606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 08:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QFMreN2H
Received: by kanga.kvack.org (Postfix)
	id 335C96B0133; Tue, 20 Oct 2026 04:29:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E6426B014A; Tue, 20 Oct 2026 04:29:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D5EF6B014B; Tue, 20 Oct 2026 04:29:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D917C6B0133
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:29:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 56A91A85C6
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:29:26 +0000 (UTC)
X-FDA: 85342330332.18.28BE214
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id BF3F120008
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:29:24 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QFMreN2H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792484964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nOSbJ7FVYKa0j5cQ1UDk8PN44WEuG/N56IbAtfMsa/Q=;
	b=YggY6IICoY2OgqawA/A3EEbsERD2Qa4l27tyc1NapS2eeLdcdvCCTcspSKbWHmYYpBLLEU
	gw+ixb9p/IgGUMS30dCDoYKFgWDNVtWV/9OcUvTs7Dy2udJPLZyuryaP6/isWEENnuILI5
	anx4FjxbJUgqvDfNyePSiJj+hylDhjs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QFMreN2H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792484964;
	b=8HigVW6x02jtUJUxs6MuT3c+Yz1W26O+ag10MEbCWtgf0vdgCXXxLq8+fbuNg4CTgJNNYj
	FZRREXWM7Ino2/2qAqROs7kXzQCUA20jwU1Sgf683zDGXymHAHem6MoahFFO3UAWdcrGvK
	9iqU2aQDzCwC2ZHNLSxp66TBSPEm4uM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 493ED60D7E
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D561F000C9
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792484963;
	bh=nOSbJ7FVYKa0j5cQ1UDk8PN44WEuG/N56IbAtfMsa/Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=QFMreN2HS1XOHuvF6A9j1l6aQmhcdkY/i4iAapBFw5Kw5nl2Hi6fMI3B+mjCL0BPE
	 L1s6fj3fUpJTp9VDHomqH95JYNNoqi20MgrmJgVOFHT/C4m87ADwHj5bJJ7+ij7uiO
	 50OP5l6pHaYpxtc+krvhVHn9P48ESVxUtDNc3Og9bGVc5ylVipelcuwwnr+4gScCuH
	 y1E4eho6xF176MCjb1p3RAzDp9gHxm7hmLiz1l9MTlg1PUqkHDNvYng3W/YzNJBkAh
	 5hSUpDMsjsuoN0eOr6l7IcPqQd80TN3MVKZzhw4tIIyrwopSHmys81jCV2v2tYYDnD
	 +IkDoxKrLGJmg==
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-53381e53b80so35724741cf.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 01:29:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwAxVK/xAfus7ZtbzP55CjnJZFlIu2iNzjsULhf3elTNQIci34uMW1Q5WOuOAeI/BjyyxZK6EI+Uw==@kvack.org
X-Gm-Message-State: AFq9FYLTbCN5T3tKco2ChDN9YW57sMtGGUYaXt/ObYwbplESZBTgMdCG
	Dr3Cv547qwLuIwAWkCbahnwB3Cd+qJABSbxGIJYbq7gjetQMiIGantfeNQM0A122BKzVP8iEB5I
	+XKbWP4KttnyaA1tvcX2k0n3/aERSHws=
X-Received: by 2002:a05:620a:4046:b0:93c:771e:b672 with SMTP id
 af79cd13be357-93f29d31ab6mr1654736785a.54.1792484962293; Tue, 20 Oct 2026
 01:29:22 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261020023548.3242028-1-ridong.chen@linux.dev> <CAMgjq7BonFtsvHMRYXXToqWBHTzNa52EU9B4ZqD-k-DJ2inQDg@mail.gmail.com>
In-Reply-To: <CAMgjq7BonFtsvHMRYXXToqWBHTzNa52EU9B4ZqD-k-DJ2inQDg@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 20 Oct 2026 16:29:11 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yAYMiRoJRLLt9B_+qdMhOFmizDy-PSbQ3jkMxV0zJqPA@mail.gmail.com>
X-Gm-Features: AclHuK915CznKXWfKwMDuCTMJaWaV8XDDBIH7x6_vFup2LGTi9Kuma6cm_MfalU
Message-ID: <CAGsJ_4yAYMiRoJRLLt9B_+qdMhOFmizDy-PSbQ3jkMxV0zJqPA@mail.gmail.com>
Subject: Re: [PATCH mm-new] mm/mglru: clarify the generation placement in lru_gen_folio_seq()
To: Kairui Song <ryncsn@gmail.com>
Cc: Ridong Chen <ridong.chen@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BF3F120008
X-Stat-Signature: geqj6dfitne3sjimd117dwo58xi3p3ib
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792484964-65993
X-HE-Meta: U2FsdGVkX19VVnO+WWIib4lb2BiElBgPYf8UpW+zIqbKxJJ/gBEqSqtbi/2Bya8j7cQc/5YmcloUq0C8O/LOTCGFia2apq6ZYpmMG6lqhcijwCFKwl+wyAPxVOmm1tK+ko/GTc5Hl0gQ9UG14gTLWZnPECPZklRmfIpzOPlPBaX08BdwbDDvYLfKMnXyeYgNXnQ3NS/PP0utn0wTbbnQbXiiQD0F3VQVqU0/5C6HmrWFIVELG5NL9F/Xeif4zMNDPG/O/83K3hhPkWG4QmN6cC8YTyYmKDw598gxTt1/XQcsUzmqU4FSlqun4M/RWW+EJw9k5qd3WoQAH74jCEygNh0+hiTvF8oiMxMt97sKt3eOsJtG+GswcqBgA6Woqun3qpZecQdMxYYKErJa7tCcYe7g/ojbng+kMy9W8hiD0LgcTSsYcstT7gNTyo2rKb0mBmn2SpakBz1KpZ6EHWJgj71FNE+6H1jwSD2uMvDtrkd1bf1TCMEPT/rgqQ/+NIYn1tnEMDIvX+C16C2DS/0buCwCwgZ/aOjwfpIimQBxUhBmED4pK/FTS6YY6WhBsxVXcpaRnsvFFFK8DVXqIXdazBib+N/S8pHK1NBXwwbid7gqwNhO1EiyiBztkcKm4WQSrivnvX9Uysx2Bpg/h6Hp68STSOSNDdEIMlNXUTx7l5sBXshY+79BqsUHYHGkQWKuGZGknb7rcLptCDKYDsiAedDoi0Dqv2FbOXB/ORFQ+/k3qi15UwmW7iXgxCuqiLzM4aJemddKXxWWcx+9czduqzrUng5y5DQP4x7ByJD5nMCNvN3kZ3lKVvBlatYt1LXaofjwF320UamvtXv5ilrMRNsp6okPPHjtioK7oevx04m4w7uGGIqTxSDwB8GCwDJmzKqM9Xs6/HZU37JXQv4UszE0w3k+AgtUO9YhgGu4Or1gR1ma8QlIdSJHpsdwW0dWX7LnkWVxyC0qmvxjd8L
 0hXuWfvq
 PGlx5uK7qnhzzsb1hAYto6hVb7WYqAG+Z+De/pCEz/avBTCC9xtS9oub7GOt0jh4/ieiQgvrb3Fg5uNZ85jvwEq3nabU2dCkpmH+JQGn/c4Q2VYcvt2I+s10SVnq6fTMSOP3ISL3dyXx1ErmBaPT1fTKTsU56x2haUPeXHnVIwK4Uq/viBqYT1cC3lUGrskIhT4HJSDt/yvhPprqQ/7sx3U0p57/HrL+EAUI/LQVtLDSyDX7NvrdkhTrn+oaq4Yob7Dwr3AhWSDhY50zfLsyMbFtIWdyZ1Pk//3NBBS/jB3zyE+DjEC5kLekk4fBpu7dmt+/r5cCQjPtZZ6aPAxWqqG0tVRwxgqgplJpFsPTo1raetI9sgCGoM2zjOh/UFmSoBqva
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 4:20=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Tue, Oct 20, 2026 at 10:36=E2=80=AFAM Ridong Chen <ridong.chen@linux.d=
ev> wrote:
> >
> > From: Ridong Chen <chenridong@xiaomi.com>
> >
> > lru_gen_folio_seq() computes how many generations below max_seq a
> > folio should be added to, but stores it in a variable named "gen".
> > Elsewhere in MGLRU "gen" means an index into lrugen->folios[], i.e.
> > seq % MAX_NR_GENS, so reusing the name for a relative offset is
> > confusing.
> >
> > The comment table above the code also no longer matches it. It only
> > covers the PG_active and the final branch, leaving out the reclaiming
> > and "can't evict yet" cases, and it lists LRU_REFS_FLAGS as an input
> > although lru_gen_folio_seq() never looks at it.
> >
> > Rename the local variable to "age", redraw the table so that each
> > branch maps to the age and seq it produces, and note that the result
> > is clamped to min_seq[type].
> >
> > No functional change.
> >
> > Assisted-by: LLM
> > Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> > ---
> >  include/linux/mm_inline.h | 48 ++++++++++++++++++++++++++-------------
> >  1 file changed, 32 insertions(+), 16 deletions(-)
> >
> > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > index ab69b9930893..a933d8c14558 100644
> > --- a/include/linux/mm_inline.h
> > +++ b/include/linux/mm_inline.h
> > @@ -302,34 +302,50 @@ static inline unsigned long lru_gen_folio_seq(con=
st struct lruvec *lruvec,
> >                                               const struct folio *folio=
,
> >                                               bool reclaiming)
> >  {
> > -       int gen;
> > +       int age;
> >         int type =3D folio_is_file_lru(folio);
> >         const struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> >
> >         /*
> > -        * +-----------------------------------+-----------------------=
------------+
> > -        * | Accessed through page tables and  | Accessed through file =
descriptors |
> > -        * | promoted by folio_update_gen()    | and protected by folio=
_inc_gen()  |
> > -        * +-----------------------------------+-----------------------=
------------+
> > -        * | PG_active (set while isolated)    |                       =
            |
> > -        * +-----------------+-----------------+-----------------+-----=
------------+
> > -        * |  PG_workingset  |  PG_referenced  |  PG_workingset  |  LRU=
_REFS_FLAGS |
> > -        * +-----------------------------------+-----------------------=
------------+
> > -        * |<---------- MIN_NR_GENS ---------->|                       =
            |
> > -        * |<---------------------------- MAX_NR_GENS -----------------=
----------->|
> > +        *            +-----------------+-----------------+------------=
-----+-----------------+
> > +        * age        |        1        |        2        |        3   =
     |        4        |
> > +        *            +-----------------+-----------------+------------=
-----+-----------------+
> > +        * seq        |     max_seq     |    max_seq-1    |    max_seq-=
2    |    max_seq-3    |
>
> I think this comment update is not beneficial, we might have more than
> 4 gens in the furture, so hardcoding a number is not a good idea.
>
> > +        *            +-----------------------------------+------------=
-----------------------+
> > +        *            |<---------- MIN_NR_GENS ---------->|            =
                       |
> > +        *            |<---------------------------- MAX_NR_GENS ------=
---------------------->|
> > +        *            +-----------------------------------+------------=
-----------------------+
> > +        *            | Accessed through page tables and  | Accessed th=
rough file descriptors |
> > +        *            | promoted by folio_update_gen()    | and protect=
ed by folio_inc_gen()  |
> > +        *            +-----------------+-----------------+------------=
-----+-----------------+
> > +        * PG_active  |  PG_workingset  | !PG_workingset  |            =
     |                 |
> > +        *            +-----------------+-----------------+------------=
-----+-----------------+
> > +        * reclaiming |                 |                 |            =
     |     always      |
> > +        *            +-----------------+-----------------+------------=
-----+-----------------+
> > +        * can't      |                 |  anon && not in |            =
     |                 |
> > +        * evict yet  |                 |  swapcache, or  |            =
     |                 |
> > +        *            |                 |  PG_reclaim &&  |            =
     |                 |
> > +        *            |                 | dirty/writeback |            =
     |                 |
>
> I think it's better not to describe too many details in the comment as
> it actually easier to just look at the code.
>
> > +        *            +-----------------+-----------------+------------=
-----+-----------------+
> > +        * else       |                 |                 |  PG_working=
set  | !PG_workingset  |
> > +        *            |                 |                 |       or   =
     |       &&        |
> > +        *            |                 |                 |  PG_referen=
ced  | !PG_referenced  |
> > +        *            +-----------------+-----------------+------------=
-----+-----------------+
> > +        *
> > +        * The resulting seq is clamped to min_seq[type].
> >          */
> >         if (folio_test_active(folio))
> > -               gen =3D MIN_NR_GENS - folio_test_workingset(folio);
> > +               age =3D MIN_NR_GENS - folio_test_workingset(folio);
>
> That's a very nice rename, the `gen` variable is so confusing to me
> for a long time, I thought about renaming it to `gap`, `age` looks
> much better. Thanks!

Agreed with the rename part. Maybe this doesn't conflict much
with MGLRU-FG either. It could be cherry-picked before
MGLRU-FG or included as part of the MGLRU-FG series.
I'd vote for the latter.

