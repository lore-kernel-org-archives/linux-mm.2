Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B71D6606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 02:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZQUtdKcr
Received: by kanga.kvack.org (Postfix)
	id B612A6B00EF; Fri, 30 Oct 2026 22:42:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC2D56B05B1; Fri, 30 Oct 2026 22:42:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98AA46B05B2; Fri, 30 Oct 2026 22:42:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 736E76B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 22:42:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DCBB8140855
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 02:42:58 +0000 (UTC)
X-FDA: 85381374036.21.389E47B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id EBC2A40007
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 02:42:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZQUtdKcr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793414577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XbvjHIncb8G+BYsmpLe0PUSaotGhY48mcOIF6+E1fiA=;
	b=O64QtqxAoEppsyBOvFIb/EblVcJw3sc/mPsByVXFcXR0LgEsgKLWS8XpqLvyKUR5G/gS4o
	Xc0F7LdoeOUxNZ8X4Tej3SUO4acIDVGB3U7AjeNOCuuMoE/eZ9QIiRoMSv0MO1g0ClvDsn
	eYx2XlD3WLtdbnER+vQQmAinwpVNM3U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZQUtdKcr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793414577;
	b=hkl9d6e8NB4iDNqBfK6Ng+1Dihfrw3HY3Ud8E+eHvlBhKh/3NlHHhzr9obhNSKDhIROq0l
	NqtAyJM4GZrIH9jrKINBlDUJohxuDWeNTYiRRT+dTFONNOsH348nxIqRaR3QPgi7sOL07/
	3nYXufHFWSkf6z3ulyJ0XWgzOBU8scc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC62043759
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 02:42:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA611F00A02
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 02:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793414575;
	bh=XbvjHIncb8G+BYsmpLe0PUSaotGhY48mcOIF6+E1fiA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ZQUtdKcrS6RDP3uE5pAO0mfK3gPkgf3kTf1CXS5kTnnOqP0hRgEdNUeC7QYUH5O+T
	 jY6284N1dSZONlv9RR5zpkHT5XhWxgnla/CPrxYLDjL3UGvQAVPK6JVcH2FMQY55Js
	 UpFO8bsCGzez+m7ir0msUKVwZ2pKhjKE3yvzR3RoWneih1OgDKUw3qPKYVgh+7eXlG
	 2ZZdpRRCXwNPHr7tVdC3HoNZ3n0t8CbGrFPKmf5edGLXI7q/7X6yrZPpQstbM2FsVg
	 Vh+XT3MO9ifEFsm5iMU2+UIByb1ZH96aMlKdkhG8ARBg0nRGNB2E8z7eLjh0m00WsV
	 Z7BLZvp74Go1Q==
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-9440304604aso137521085a.0
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 19:42:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzoy3uGJzSE3rTB/TjaVOyi/XEzzw/NuwdkdZKsUJ5fF7sEyJ/mlDcZxRdtm89POBabU7jXoK2LnA==@kvack.org
X-Gm-Message-State: AFq9FYIaV1lxPvVO4uyQw4ZVK+CZhza6EfmQEVCD+6rOR/XtMZECySY+
	OGjV3N7RKaiixIfzPEac9MrtVgOGSUi5hKk3j3Ht17ScuzQCs82WUsbOsKUnMschiG8tK01G9An
	4oG7wvMTO5uKLyjK+5gSlfTR51rumq8k=
X-Received: by 2002:a05:620a:1999:b0:93c:891b:90f1 with SMTP id
 af79cd13be357-944133ab8aemr1157540585a.26.1793414575057; Fri, 30 Oct 2026
 19:42:55 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026084035.535989-1-hui.zhu@linux.dev> <CAMgjq7AJSU9jUBTHGcm05mtGBH4EMQ_ua9YNwuLOGVzhkdLKkA@mail.gmail.com>
In-Reply-To: <CAMgjq7AJSU9jUBTHGcm05mtGBH4EMQ_ua9YNwuLOGVzhkdLKkA@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 31 Oct 2026 10:42:44 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zPZg6pCuhDtTpSkueS2EDSfWeYa23h7kC9hEU0iGB-+w@mail.gmail.com>
X-Gm-Features: AclHuK8OP7DyMs9ASLJHmA1rKTTTWsz_2q-gGMGDEWgbxTqGh_WEH7YWpp83KIg
Message-ID: <CAGsJ_4zPZg6pCuhDtTpSkueS2EDSfWeYa23h7kC9hEU0iGB-+w@mail.gmail.com>
Subject: Re: [PATCH v2] mm/mglru: fix a no-op lru_gen_clear_refs() call in lru_lazyfree()
To: Kairui Song <ryncsn@gmail.com>
Cc: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Yu Zhao <yuzhao@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EBC2A40007
X-Stat-Signature: mtxhgitq7cutgzgxp5g4bhh9qfzs4cfc
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793414576-37642
X-HE-Meta: U2FsdGVkX18xf8dcKvSE3/KMOXUQUpKSDLIzMadAfolL0wiVjiQquFH3PXqGtAQKXMOSn9y9k9n4T1eHE9t3ZeD/kG0wQJYpgmpZG5zpK9xZwqRPSH7nW4RIHtZ/Fss/+fKLfa9heMOnCDevmCvR0mVXCHgApOjF9SvRGhv1PPesoCuxHNdwo6f1QKRUg/5lIfGmN1Q7n7lHXAyvoUfeiDlAet2hyxRoXfO9tQpuMcnQ8ENFZwBD5XyAIXcxBsBZJFonDs+s6W1RetBlqS9jccxlhCzzgDyKu7P56gLz6XalyXf/J/pW34b/gWqxoJrPvfHyihXEwrikcmbGPZ02lJUAWpdxR8yJ1DoqwpALbOQAYS6khHEHfUCmdkt2l6naDaMri3/sxR/q4KyeL9YjHocXE+2srRsCp3HcSVJoPjzsgAdLKCTHtLM0DjRd5lb/C28aYX4ebviZAKG41VoI6TdJW5j9Yu0kk/OyQBjMTIAZz+QMT1BV3W7m6liPKJ6lvbaUVd0UoLAmrSw67OfXGqYmmRqR9+1iw2evvRZ8Dr+gRlpHLx3PXZPKUupbe4cfq25ZTJiD9K9/NVoWIc+gQKohOJqLuoe5k+lSrHpJC8tEpoGnzqfCgnjxcADfTwT/V5yE7EFj+/Y+KgeNQNphGEpv5xPZKDFB+isrKnIeSxFDxKLIXjBbjP2C24KKUIOnvTqACNwNGFoC6dHA1AaFciATk0k5EXpHgobmnN7RNFMdfO9nBhUXxeQuhpEoxAQIKInawjD6RJ2NYz3KPzd5ppY0VpFA8fMRrXwyKzGw9zoLNi+NehNDAsl8X1o9FycGFjm9pXMlgFhR8/YNGxJJBw1Z6NOmShK9XNW8P1CMJ4VSPeSLLsMZ4+GhGokONT18dob95AE/+jPNgBlTSiir/EV/43n2mNZEohDNsQg1SEkvDFx3oqXalGmfJr2NOUKT4GFGeh49Ni5c7+xVhhB
 WTyK/6RU
 9ptM5WQyzpIW8bz4OMlltITl47aqJmTfeQ4BFvtFqV0YU6+lxHF48OxnIibN0dgOB86GicqpFrT9alEghHEph4DUiNjqDQgncjRTNkDAPxsrtSMgNY9j/pcIW1bL9BynZuZ+aOWlEKu/xPNVuDBuOVqkmz7VTmuzNhB/nwi2hXPqnQWAYd7PiWmlsTtjvidYg9vTRBC2+1/nIdYgVg4NsBzPloTGoWO3r6u6uMU69kCLjDXBi2rxFjoQPRpqjbdeV1DtLCzUrPFc7q43CFbtPplf2MdLumyOzKUJAs76fOdARpLc9WdGXNOOc2b25SrmBJKJMMfiaNNYtyykLIynz7lZJU2DB6p5Hm4opPMcKWSHfCSKeCc5HNYJBAR3bPt4UytmC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 7:40=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Mon, Oct 26, 2026 at 4:41=E2=80=AFPM Hui Zhu <hui.zhu@linux.dev> wrote=
:
> >
> > From: Hui Zhu <zhuhui@kylinos.cn>
> >
> > lru_lazyfree() calls lru_gen_clear_refs() after lruvec_del_folio(), but
> > lru_gen_del_folio() has already cleared LRU_GEN_MASK, so folio_lru_gen(=
)
> > returns -1 and lru_gen_clear_refs() exits at its "gen < 0" check withou=
t
> > clearing the refs or PG_workingset.
> >
> > A MADV_FREE folio therefore keeps the state it had before madvise(2),
> > even though madvise_free_pte_range() has already cleared the accessed a=
nd
> > dirty bits of its PTEs.  lru_gen_folio_seq() places it one generation
> > younger, and PG_workingset puts it in the last tier, so sort_folio()
> > promotes and protects it instead of evicting it and charges it to
> > lrugen->protected[], which read_ctrl_pos() uses to balance anon against
> > file reclaim.  __folio_inc_gen() clears the refs but not PG_workingset,
> > so this repeats every time the folio reaches the oldest generation.  If
> > the folio is redirtied first, ttu_anon_lazyfree_folio() keeps it and
> > lru_gen_eviction() packs the stale state into the shadow entry, so a
> > later refault is promoted to the youngest generation.
> >
> > Call lru_gen_clear_refs() while the folio is still on the generation
> > list, as deactivate_file_folio() and folio_deactivate() already do.  It=
s
> > return value only says whether the folio is in the oldest generation,
> > which lru_lazyfree() does not need because it re-adds the folio below.
> > Keep folio_clear_referenced() unconditional: the classic LRU needs it,
> > and it also covers the folios that lru_gen_clear_refs() skips.
> >
> > Fixes: cc8ec7be78ff ("mm/mglru: optimize deactivation")
> > Suggested-by: Barry Song <baohua@kernel.org>
> > Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> > ---
> > Changelog:
> > v2:
> > Call lru_gen_clear_refs() before lruvec_del_folio() instead of
> > open-coding the flag clears; drop the lru_gen_enabled() branch and
> > the comment (Barry Song).
> >
> >  mm/folio.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/mm/folio.c b/mm/folio.c
> > index 35e242b48870..ea3adb6a89d7 100644
> > --- a/mm/folio.c
> > +++ b/mm/folio.c
> > @@ -597,12 +597,10 @@ static void lru_lazyfree(struct lruvec *lruvec, s=
truct folio *folio)
> >             folio_test_swapcache(folio) || folio_test_unevictable(folio=
))
> >                 return;
> >
> > +       lru_gen_clear_refs(folio);
> >         lruvec_del_folio(lruvec, folio);
> >         folio_clear_active(folio);
> > -       if (lru_gen_enabled())
> > -               lru_gen_clear_refs(folio);
> > -       else
> > -               folio_clear_referenced(folio);
> > +       folio_clear_referenced(folio);
>
> Why can't we just call folio_set_lru_refs(.., 0), and should we clear
> PG_workingset? Keeping it helps PSI on refualt / redirty tracking (not
> sure if meaningful but CLRU does this), clearing it makes eviction
> better, but the eviction issue is MGLRU-only, CLRU keeps it.

I recall that in v1 [1], Hui mentioned:

"Use folio_clear_referenced() rather than
folio_set_lru_refs(), which is not defined without
CONFIG_LRU_GEN."

I assume we can support this, but doesn't the code below
also look a bit weird?


diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 829977d399e6..66ed805a48f5 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -431,6 +431,15 @@ static inline void folio_migrate_lru_refs(struct
folio *new, const struct folio
        if (folio_test_referenced(old))
                folio_set_referenced(new);
 }
+
+static inline void folio_set_lru_refs(struct folio *folio, unsigned int re=
fs)
+{
+       if (!refs)
+               folio_clear_referenced(folio);
+       else if (refs =3D=3D 1)
+               folio_set_referenced(folio);
+}
+
 #endif /* CONFIG_LRU_GEN */

[1] https://lore.kernel.org/linux-mm/20261023080430.465305-1-hui.zhu@linux.=
dev/

Best,
Barry

