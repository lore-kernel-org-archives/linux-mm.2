Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40F83CC6B2D
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 03:23:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32E176B0095; Thu, 15 Oct 2026 23:23:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DDD36B0096; Thu, 15 Oct 2026 23:23:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 158816B009E; Thu, 15 Oct 2026 23:23:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D77526B0095
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:23:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 621F9140265
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:23:43 +0000 (UTC)
X-FDA: 85327044726.11.FE5D5F6
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6E15E120005
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:23:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fcLI0nNF;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792121021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8YNJkTl/DWHv1ezxEcAU72VeJT6fYlt0s29Bmaa9qVQ=;
	b=Wsc+BJynIU8ZKQhHlbNACjshb+y+Sv56qkz6V5FQJePII001fstt3avhwMAhkGILxGYipu
	a4chwmGPQKq88g42yUmLi45YsTNA2WsQ0R3PHI9jVZevd64tIqrS6UeiRo8iyDRBJ8UsSu
	7BNTLuT6YN7X4yuqfDiUFh6wS0MzJqk=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fcLI0nNF;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792121021;
	b=o5KA8mc8WcOQDKzR5bSC7SRVJbvodiHMYdi0AXG/h5oZyeicUBXkCjgSxV/sGcccYySLQa
	7HjuyER1KTG+mWpWrZSSX0iIBZa/N+kuTHDwjAIY9hPsIkG9W/Hlx6ez70mwFgtggzTtwQ
	XysvdC+ML7a5EQfYUz9Y7awN9H/9Uko=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a018792ab3so47055495e9.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 20:23:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792121020; cv=none;
        d=google.com; s=arc-20260327;
        b=jRDP3K1pPKgbrEwWnrI+ZomJxbg1IiPI/whrYOUk8PGiycFYHI/K0hvLGG/6AOryWq
         ujawoB0fQbXPfgPn+y6EkhZtsPWUQ0xVe3DRmLl0bEzbpRBeAyTVAI0zFBf0zONXoJ9J
         /rQvnBgsM6iK3ZdXwuqV3elTVnWocEFnSqXee02x2aR7wtKJdmOgp/nqL58Jg1bHrDaQ
         LER08E+bQE6TMujUJnTta9nbjjSAknGX7BrqtZhdlENuOdgZBNn1AARqAuAun38xzt0f
         phIyojNoESK9tw6UVFopc8UQFRVxgNfNtzpBDYaIRVovLE7rp1q/Buq42qQBsl+s9RPh
         j7Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8YNJkTl/DWHv1ezxEcAU72VeJT6fYlt0s29Bmaa9qVQ=;
        fh=UbFbBGJMeGBlNhDQuHgflExuS2KSMckujpchjd3ItD8=;
        b=Ammz3hXWe12m1u8PlhVsWxdKWgihkl6t5tLU9R5yrtuCYuoVETa19QICUCs9lTTmAD
         DgFuDXqMqkWvxuWi38dSkvhflUpZavNi39K4FRs2mz+VXo5vCy8MCcL+GGs2CY7IkCzD
         SJF9ThctYDPBtX69GhZ3EtTffSnLT7/8FVaBuW/XRYLBsjow2ILzNlERkvOiLrbkiMPI
         RhQ3oJaitU9N7M2ZfTCMtahPZnCaEN8QoTTTHflmr74RTm9Kl6H3wdjODDQ8ulO7QTIU
         pG12DxFCAbqawVfJXZ5fKGuaoskej+hKhfnSf4Z+Kv9NiOUd+9lyzS03BQ3gChm6HWEP
         4l8w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792121020; x=1792725820; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8YNJkTl/DWHv1ezxEcAU72VeJT6fYlt0s29Bmaa9qVQ=;
        b=fcLI0nNFS0VEgva++mtuYeO+kUDkbWkJ4UY5EnE/FOilI1yerpNsTXhZj3SG3N8MKO
         Z6OKxVCSVUBWgqoZjZOeS/Y9XCfElWvjT4ZG6cyokW2LalIT3TUirWZ/tXbO9kCUV0Ew
         3/Og7HQA3W3Revs6xp82U1S4IRYRoPt2Y6lfkgzvv39+aag6QKXeFOq3tkd09xZ5miB7
         rpBDUJXk9nir4YqOULGD0R5xJHT7xE4ShwUWiiGxALEguSLGdRGYRiQ6d5XgeHXhKgo+
         5dufkIYbNt+k48dUfrdyNRiiqVcm9yHbbrodG/DfAxjQeChAJjvlAdzgOqCDexYk5IU+
         WvLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792121020; x=1792725820;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8YNJkTl/DWHv1ezxEcAU72VeJT6fYlt0s29Bmaa9qVQ=;
        b=IpMZqImj//fkuBZ8Mk/KZpukAdi8cVz2wzQvC2hZYAdtKndC1gxBx3yOyGmpnrExgW
         /LEBtl6lUQEDXt9oNJA/BxwVxDYDWWx62qFfG+eRL9kIKwuTEsHZfwYqqcvGe8A/3TkS
         3Y6wBYlZDAgz09NyL+6KYKEHtz0AE+7uGyFO09iYl2CIlEMSMCEaYOmv+etJ95aQoMSa
         HEVFichBRoncsyvrgyvKrejVYVHUwNp0hBev1yvALV76E8kjN3WecPw+R5l4JPpwSQq3
         l9NFYVszcALnbsZAeyrPZ//VwL/bRMhPV1+spAHU94FRcl6+VHr8utFKspxg37qagZrX
         XuqA==
X-Forwarded-Encrypted: i=1; AKwUvBwmoOOqJbZ8LxFUy4CqVSVh5enQsUY6U8GYPxtu8TU4/FoE6DbFv/Lm9mHpyejapgG4Uj8m9BzDVQ==@kvack.org
X-Gm-Message-State: AFq9FYL/RAekMGD5JfT4Gq2ulJSyMaSstQ8jjQDcVmvAai56083DA+Q0
	bp3WTeiXaHLhEGbFbMhyizMsiJsPS+EvIZNn6xJsTIgvJHW1fha3X3ISe1Y5AnvwUbsmpdLvM9r
	Aw1AAIvMVeJcQqLBxUQhDSsFQjGIUPQI=
X-Gm-Gg: AYBFou3UH+iHC2GxJ/aWxN5T7UwDOdjD2hiCNyoDWCTWflnnZ02AS+LuSJYOYiRQrFB
	Xp6Z3/FHjwFKKj6jke9OrhKaOU+2Qn+5ldGX+hxkm3PhWIdjvoRpvnXxxUx3cra55VNOpV/DS6f
	IdiZTfq4PLArhZJ3X5tObXMQMjXsyGOiINqL+zJpko+dxqMUluDBPCoJH6oJ8kZ1BE8kirc2MWV
	1oIzd656Nxy5fk+CE/b3lTZnkOUJI1PPyoWtloUBhqgBKjEtUTV1UP4HUHF3j0cDByWHiEDpK15
	KWU6lLKmH7I5dy2rIJXHP7rIyN93WNgdT1KySgyKn8CYTGD13EhV2+Ei
X-Received: by 2002:a05:600c:1d0b:b0:4a0:13ea:2ec3 with SMTP id
 5b1f17b1804b1-4a18e4ddca6mr422203805e9.35.1792121018258; Thu, 15 Oct 2026
 20:23:38 -0700 (PDT)
MIME-Version: 1.0
References: <20261003-mglru-fg-v3-0-cbd4546a5bd9@tencent.com>
 <20261003-mglru-fg-v3-13-cbd4546a5bd9@tencent.com> <CAN_Opa-GVYVg1mUc=PJFfE8ZLCoAWjzDoWoxA8FEfsPAYGdijA@mail.gmail.com>
 <atBL2inthrJH_ng4@KASONG-MC4>
In-Reply-To: <atBL2inthrJH_ng4@KASONG-MC4>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 16 Oct 2026 11:23:26 +0800
X-Gm-Features: AclHuK_N9VwznAnK-_rOKQvlcBwO7N2BPlytUJO1x0sN6vdiDFScfhSSqrqgPcw
Message-ID: <CAN_Opa-42w3BwKV-DBjy-x-Ldi+RQgbRcgjGmsT_jzM4+4=K+g@mail.gmail.com>
Subject: Re: [PATCH RFC v3 13/17] mm/mglru: make folio_inc_lru_refs lruvec lockless
To: Kairui Song <ryncsn@gmail.com>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nico Pache <nico.pache@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: n1qkxjfhbj97q5qbqbbsttx7shqezdhh
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E15E120005
X-Rspamd-Server: rspam08
X-HE-Tag: 1792121021-955436
X-HE-Meta: U2FsdGVkX18O9Un2MHrhuKJE3BPWCTLdmf+xBUZd/e5iBgNC75wrybhbuK6klVdxYVNUXMl441h893QUbgQK24DjD88fsj+sWFSQB7/0hGx/rhG8klS1i7RScmn0P4O4jZzs8X4JEq915mAEd61eTGXasDURsv7nM0Gi9nlqsXPtwh6ulNmcnUAJ6NQcTwluBJZR2KiwnxCh6tRbRCQr5AmUjA/MthoDju/VOw65oK66TurmRqARZsvCO/l4hC44SVhjMxrdR/5xsCpTfadgbyzdloRQolj8rELlxK1FmoXNmfn5+QUIa24HJNkDeZhhbxsgkVDbtKwM/ttbXMLsqjcM8unmi0TIbPeNXn4yrvMQeCw4A9sseLNtBsw6qJFgTezEwNWjxgagARv9L55wL/W2e+37Il6S1Aoe6GAC+QWb4KjNGO8asNo2bVaYC7ajoF9vb4q2ME2h3Z3fR4iVTkYzgD06ApxLWnQ5H0wBmriYRJwO8PIlRt62hvoHVcu4GoLSPsthtLk6z033c5NGsRFZQbqlK6f9Xe2DtjGh/VMsnb10aq3JCoysem007//53DVnSi/rJOuDBkuOlek3geILdqDXr/UOIRlugBKFa8Ktzffg61HB0Wocuaw26L1jvJatyExbg1U/r3j90fBz++WrrxfARghghPKPoeFvtS5dFAm4btcX2As2M7jrDe8W1ne9OLGPgBAYnGczYIyhEAm3O47rlQIqjzT+jLlYoQOYhJy1U0NTVETVt519EBNNE4m1+UuKFjkPOIKmOi+YPEJkG+WYqJZBv/RlE2h6soCinhcbXBk7N01DM4/sORbtcGxaKBBziyQx+R2P8P7X0iJCBjAqCHVxz+hN6SQnCn/neBLfpIFkLrehaETkLWabesTYzMCfECZkubTr3ubNiOIqJDEQ0rxhkdv8EYYvpZCAAiE6xio02kSObCUr6/AJaZoBJEKDa9zs0lJ5Mg0
 4om6G4WX
 wBO+dbq+n8jL1usp9SAho+2utkH3hmv8rp/6d+wXyrnJDbA2GgcLueFoZNa0KYOlrPxIbsE9/CYuwDLgxYofchH0iiKMpszREfeAVam14/S8bE+5KgZujqroN0jkGaqbDK13MeuwXATPBq9MhM1eDWLR5ONKVPfGACdKlDDzX2tNzuzsHXXr5+qzLMRfKCp0B+lAcc3pBTmQnXg1Nbv8Z/GMASG3EqHU6RjQ0pxSqSD/KiFPdXblXk8SIRtx9ZN10ElLUVETpyur3G4rjk111d/hIlbOlcRntbQcXG0b6/bUkm9K602mKcy5SqfHS7kQpqhfcEwL9tp2vVrnvoYvyw/Cv+p13PvTW+oSvhAZg3L1S5kBFB3gnd+IGUm1f9OckiMTD9YZ+9J3lHbaRnkyNr0DjdreaethCjKH/D1y9SKVMIxJNJyuahWiwvNcbC3vc3jSY2XEfYFEW2lsRx2kLUwwmTm7YPoKhLHh2tbRH9P2q0icnhppBJdB0WDC7VqtenLbnNCWOYTXeFxrCgVJ2kx+q9v8qQxek4WBEq4F0YSJtBStkEbxSlBUynhfpFcDqT5qtPhobtqR1FBcElqHSL1Uqig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 11:46=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> On Mon, Oct 05, 2026 at 01:29:00AM +0800, KunWu Chan wrote:
> > On Sat, Oct 3, 2026 at 8:55=E2=80=AFPM Kairui Song via B4 Relay
> > <devnull+kasong.tencent.com@kernel.org> wrote:
> > >
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > The lruvec spinlock in folio_inc_lru_refs was only taken to keep
> > > concurrent aging from corrupting the size counters.  This is no
> > > longer needed: the per-generation counters are atomic, and the
> > > active/inactive ABI counters are updated per folio and linearized by
> > > the CAS on the folio flags, so concurrent aging can no longer corrupt
> > > them.  The same argument already allowed folio_reset_lru_refs() to
> > > drop the lock.
> > >
> > > Use folio_lruvec_live_get()/folio_lruvec_live_put() to hold the RCU
> > > read lock around the lruvec lookup, and drop the spinlock entirely.
> > >
> > > Without the lock, aging can advance max_seq while a promotion is in
> > > flight.  Generations are indexed by seq % MAX_NR_GENS, so the folio
> > > flags can return to the value read earlier and the cmpxchg succeeds
> > > with a target gen computed from a stale max_seq.  Recheck max_seq aft=
er
> > > a gen-changing cmpxchg: if it moved, account the committed update and
> > > retry with LRU_REF_FORCE, which promotes the folio to the newest gen.
> > > The retry may count the access twice, which is acceptable and avoids
> > > folio_activate(), whose LRU lock causes latency jitter.  smp_rmb()
> > > orders the flags read, including the one returned by a failed
> > > cmpxchg(), before the max_seq read.
> > >
> > > Also simplify the post-CAS accounting guards: gen is only assigned
> > > non-negative values after the old_gen < 0 early exit, so gen !=3D old=
_gen
> > > implies gen >=3D 0, and lru_gen_update_size() needs no explicit guard=
.
> > > The active/inactive ABI update keeps its gen >=3D 0 check because an
> > > off-LRU folio has no lruvec to update.
> > >
> > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > ---
> > >  include/linux/mm_inline.h | 10 +++++-----
> > >  include/linux/mmzone.h    |  3 ++-
> > >  mm/vmscan.c               | 47 ++++++++++++++++++++++++++++---------=
----------
> > >  3 files changed, 35 insertions(+), 25 deletions(-)
> > >
> > > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > > index ee7fcbe2366b..b68d68101248 100644
> > > --- a/include/linux/mm_inline.h
> > > +++ b/include/linux/mm_inline.h
> > > @@ -293,10 +293,9 @@ static inline int folio_lru_gen(const struct fol=
io *folio)
> > >         return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, =
0)));
> > >  }
> > >
> > > -static inline void lru_gen_update_size(struct lruvec *lruvec, struct=
 folio *folio,
> > > -                                      int old_gen, int new_gen)
> > > +static inline void lru_gen_update_size(struct lruvec *lruvec, int ty=
pe,
> > > +               struct folio *folio, int old_gen, int new_gen)
> > >  {
> > > -       int type =3D folio_is_file_lru(folio);
> > >         int zone =3D folio_zonenum(folio);
> > >         int delta =3D folio_nr_pages(folio);
> > >         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> > > @@ -371,7 +370,7 @@ static inline bool lru_gen_add_folio(struct lruve=
c *lruvec, struct folio *folio,
> > >         /* use the refs from the atomic snapshot to avoid raced updat=
e */
> > >         refs =3D lru_get_refs_flags(flags);
> > >
> > > -       lru_gen_update_size(lruvec, folio, -1, gen);
> > > +       lru_gen_update_size(lruvec, type, folio, -1, gen);
> > >         if (lru_refs_is_active(refs))
> > >                 lru +=3D LRU_ACTIVE;
> > >         __update_lru_size(lruvec, lru, zone, delta);
> > > @@ -389,6 +388,7 @@ static inline bool lru_gen_del_folio(struct lruve=
c *lruvec, struct folio *folio,
> > >  {
> > >         unsigned long flags;
> > >         int gen, refs;
> > > +       int type =3D folio_is_file_lru(folio);
> > >         int zone =3D folio_zonenum(folio);
> > >         int delta =3D folio_nr_pages(folio);
> > >         enum lru_list lru =3D folio_is_file_lru(folio) * LRU_INACTIVE=
_FILE;
> > > @@ -411,7 +411,7 @@ static inline bool lru_gen_del_folio(struct lruve=
c *lruvec, struct folio *folio,
> > >         if (!reclaiming && ((max_seq - gen) % MAX_NR_GENS) < MIN_NR_G=
ENS)
> > >                 folio_set_active(folio);
> > >
> > > -       lru_gen_update_size(lruvec, folio, gen, -1);
> > > +       lru_gen_update_size(lruvec, type, folio, gen, -1);
> > >         if (lru_refs_is_active(refs))
> > >                 lru +=3D LRU_ACTIVE;
> > >         __update_lru_size(lruvec, lru, zone, -delta);
> > > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > > index e096fd0a5047..d78e3f97423e 100644
> > > --- a/include/linux/mmzone.h
> > > +++ b/include/linux/mmzone.h
> > > @@ -558,9 +558,10 @@ enum lruvec_flags {
> > >  #define LRU_TIER_MIN           0U
> > >  #define LRU_TIER_MAX           (MAX_NR_TIERS - 1)
> > >
> > > -/* Access source flags for folio_inc_lru_refs() */
> > > +/* Flags for folio_inc_lru_refs() */
> > >  #define LRU_REF_MAPPED         0x1U
> > >  #define LRU_REF_EXEC           0x2U
> > > +#define LRU_REF_FORCE          0x4U
> > >
> > >  #define LRU_REFS_REFERENCED    0x1
> > >  #define LRU_REFS_WORKINGSET    0x2
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index ae4a0522a8d5..9cc06a95d931 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -982,38 +982,33 @@ void folio_inc_lru_refs(struct folio *folio, un=
signed int flags)
> > >         long nr_pages =3D folio_nr_pages(folio);
> > >         struct lru_gen_folio *lrugen;
> > >         struct lruvec *lruvec =3D NULL;
> > > +       bool aged =3D false;
> > >
> > > +retry:
> > >         old_flags =3D READ_ONCE(*folio_flags(folio, 0));
> > >         do {
> > >                 new_flags =3D old_flags;
> > >                 old_gen =3D lru_get_gen_flags(old_flags);
> > >                 old_refs =3D lru_get_refs_flags(old_flags);
> > > -               file =3D folio_flags_is_file_lru(&old_flags);
> > >                 refs =3D old_refs + 1;
> > >                 gen =3D old_gen;
> > > +               file =3D folio_flags_is_file_lru(&old_flags);
> > >                 if (old_gen < 0)
> > >                         goto out;
> > > -               /*
> > > -                * Lock the lruvec if the folio is on-list. We are al=
ready
> > > -                * doing lazy promotion so in theory we don't need th=
is,
> > > -                * but for now, concurrent aging would still corrupt =
the
> > > -                * size counters.  This is a temporary limitation and
> > > -                * will be lifted very soon, so the lock here is not =
a
> > > -                * performance concern.
> > > -                */
> > >                 if (!lruvec) {
> > > -                       lruvec =3D lruvec_live_lock_irq(folio_lruvec(=
folio));
> > > +                       lruvec =3D folio_lruvec_live_get(folio);
> > >                         lrugen =3D &lruvec->lrugen;
> > >                 }
> > > +               /* Failed cmpxchg() does not order old_flags before m=
ax_seq. */
> > > +               smp_rmb();
> > >                 max_seq =3D READ_ONCE(lrugen->max_seq);
> > >                 max_gen =3D lru_gen_from_seq(max_seq);
> > >                 min_gen =3D lru_gen_from_seq(READ_ONCE(lrugen->min_se=
q[file]));
> > >                 if (old_gen =3D=3D max_gen)
> > >                         goto out;
> > > -
> > > -               if (flags & (LRU_REF_MAPPED | LRU_REF_EXEC)) {
> > > -                       /* Promote second page table access or execut=
able */
> > > -                       if (refs > LRU_REFS_REFERENCED || flags & LRU=
_REF_EXEC)
> > > +               if (flags & (LRU_REF_MAPPED | LRU_REF_EXEC | LRU_REF_=
FORCE)) {
> > > +                       if (refs > LRU_REFS_REFERENCED ||
> > > +                           flags & (LRU_REF_EXEC | LRU_REF_FORCE))
> > >                                 gen =3D max_gen;
> > >                         /* First access only defers eviction from the=
 oldest gen */
> > >                         else if (old_gen =3D=3D min_gen)
> > > @@ -1037,9 +1032,19 @@ void folio_inc_lru_refs(struct folio *folio, u=
nsigned int flags)
> > >                         break;
> > >         } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_=
flags));
> > >
> > > -       if (gen !=3D old_gen)
> > > -               lru_gen_update_size(lruvec, folio, old_gen, gen);
> > > -       if (lru_refs_is_active(old_refs) !=3D lru_refs_is_active(refs=
) && old_gen >=3D 0) {
> > > +       if (gen !=3D old_gen) {
> > > +               /*
> > > +                * Gen-index reuse can fool cmpxchg(). Retry lockless=
ly, accepting
> > > +                * an extra reference to avoid folio_activate() laten=
cy.
> > > +                */
> > > +               if (unlikely(READ_ONCE(lrugen->max_seq) !=3D max_seq)=
) {
> > > +                       flags =3D LRU_REF_FORCE;
> > > +                       aged =3D true;
> > > +               }
> > > +               lru_gen_update_size(lruvec, file, folio, old_gen, gen=
);
> > > +       }
> > > +
> > > +       if (lru_refs_is_active(old_refs) !=3D lru_refs_is_active(refs=
) && gen >=3D 0) {
> > >                 enum lru_list lru =3D file * LRU_INACTIVE_FILE;
> > >
> >
> > Hi Kairui,
> >
> > One question about the retry path.
> >
> > When `max_seq` changes after a gen-changing cmpxchg, the retry uses
> > `LRU_REF_FORCE` and promotes the folio directly to `max_gen`. In the
> > normal first `LRU_REF_MAPPED` access path, the same folio is only moved
> > to the next generation when it is in the oldest generation.
> >
> > Is the stronger promotion on the retry intentional? In other words,
> > does detecting that `max_seq` advanced during the update justify
> > promoting the folio all the way to the newest generation, rather than
> > re-evaluating the original promotion policy with the new `max_seq`?
>
> I think we are fine, that window is very very rare already, and the
> problem is we may cause hotness inversion if the gen number lapped
> with each other. To making things easier, if the max_seq changed,
> just force promote it so we won't lose any hotness info. It may
> over protect but the chance is like once in a million so I think
> it's fine.

Makes sense =E2=80=94 over-protecting once in a million is clearly the
safer side.
Thanks for the explanation. I'll look at v4 and follow up there.

