Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADDE6C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 11:14:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 896686B0140; Tue,  1 Sep 2026 07:14:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81FE56B0142; Tue,  1 Sep 2026 07:14:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C02E6B0143; Tue,  1 Sep 2026 07:14:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3B8F66B0140
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:14:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C7C2E16035A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:13:59 +0000 (UTC)
X-FDA: 85164933798.11.C2FADAB
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf09.hostedemail.com (Postfix) with ESMTP id DA518140008
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:13:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=geZdjMDo;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788261237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zo2PPYoJf8/8P2lpcn6RCiPhS+p7e95CjAJ1PNJ8eY4=;
	b=8rscACPm5rt/qq7LWTo/iMiaBferPThicVclc4ptXa4i9mkBbL/cOMP/audCTmuC5tq2Jr
	bhg/W7aXMLphvNoHp7/OnL02xENwmfH6/gqgodxHE3TfFaO+LjzG+MkWdHbLCt4pz0vEL2
	NOAWzHsiFSFIpjZpG6xrK9CeqN1JLm4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788261237;
	b=3j27upbIgZquqHua6pOjlzQ+V6YViR3dl+6/c1hUaEO8P89zy0SVaLwUH5KU76a/9XBVCj
	CEPJx2B6Qj1xRPpCQBoqUgwKTOSrvKV01tdZKKihGaa06E84gKW9kyqkF/IZH0iE25+dfq
	Mb5OOTtfe46MaiitIXkQevuqm+elh+A=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=geZdjMDo;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c207cb16cf5so762660866b.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 04:13:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788261236; cv=none;
        d=google.com; s=arc-20260327;
        b=aVJHnfSZL9gdwYky8KSu9EAG47y4hAiBrx8LlHnFF62RfVbW7G7bsvs8uxTCqWhDig
         vEHosKwxIk+GDK23JhR/ciUL8Bv/pasQO7EIHpx9QdHI95c30qB7TeY2xj50QZCqKML3
         hOaSqK+mzimQmfY2jlG1rMuqKzGit70mo+fj3Ysdn6M7M6dTqPl6aTmCvgZLip+iMnxq
         Cl4lvKtXJd7X9WbMlOV0ygW0ibEXoKfLwkvsAuQGNk58fMm1QhLZ3LHO/dNgdT9fNi52
         +2omQgSnTCoWmK2+pjbbh+UkIOPyxLtescGQffK8l+kulD+x3OjAQlCaq6tyP1ZDEw5v
         +Yeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Zo2PPYoJf8/8P2lpcn6RCiPhS+p7e95CjAJ1PNJ8eY4=;
        fh=81Y0rrjAe3LxU/1tyZoOABAVvqIHcl+84cGlS7E5yjw=;
        b=oX9B7TYPBJiprsKbxhtfUJg/nah6l2SZJ73eaz3vKRHNVjy2OxXRE5JqDEs8TjN5Us
         UTyv5/Eub70mwidpuv9EREYRTU/NPFWvth5r+ncYn1OBoBE3pSNo4g50EDOkoVHSCF2g
         LbmXJs3RRNYx2FRcC5a74JLFmWqVpJV9ABfUTkFOtSx3jKtesIJiQsjwa2Sbc8J5RUcb
         VHUNuiC/eqLMecikBhuSutxh9sZugsXUs7c3yl/p6C0xRCJ/myV3+1NShmzYU/j+4HzI
         4SbBfbaZz5Rq4TDxR4snS/5NBx2e9hVJqXoGy54EjTyNK8rNDPBoJpOHGTV4jCRD+i0A
         mgPQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788261236; x=1788866036; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Zo2PPYoJf8/8P2lpcn6RCiPhS+p7e95CjAJ1PNJ8eY4=;
        b=geZdjMDoXDtIF1eSeIUmPjSs7nP9SXNvrPInEMWFB6+n6FL+YWLE6oPOxjWL7NVjXK
         PqNTOh3CjQ4GGkIGbbdcrJgUXs2ZsYsvvYjJ12KCxJSxopRpBclnIEAzKww28FWY9uzZ
         HEXYG5PlZravdfnUmT1BZn2L4Tw5W2A9gssBAcRAfF/R7Nolq/VniGwJMMEectu4tddt
         otdnbYcYbEttqN9Ap02x5N5RJI1mGhSgZHncYCimX2s1+v3a6cIq6AtSjvdNIsInD6r5
         KChJsBxhsay0Rn4P8JcJ2+XViJD8mxdpXtXTijGuvhVz6oGfrB23WX8yXN5aPh3FkQqt
         bXVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788261236; x=1788866036;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Zo2PPYoJf8/8P2lpcn6RCiPhS+p7e95CjAJ1PNJ8eY4=;
        b=puMMdaiZW+e1padE3ohWTCK1kNz0uBIlCxUJyA3HzXTVEkZFfBudj+0PfYBpMrFlZY
         tNYI12pMiyIU1zEQLnrcppgSK0T47ex6hw3tzIehAycbMyaizIlC0AAnd2vCZ9CCjs0V
         5DEZ7ZNPbrxbYZg3jMgEHmgFV0XCBXtiNvsNhlP5QLqU06oBwAKcpkQMKU0EyShCLUl5
         vu1G0L5Ar9KVp2r2JubaOoHmtXpXL9+g490xl9zXhKPUb0EgjQQiWJOQPRwJ0+3HQ92H
         vlS/WY2CrEb1N2Gd4LCnBvoCWH9hmvaKlPDZmj+6iTpXwySQzBFjrcL0SBweFkn0Qqul
         peww==
X-Gm-Message-State: AFuF++l2UkbtXV8VazfyCS+tD8zOdMTruNDnyeTAIEL0eu269YRN/Ten
	G1Mxs93luPTWPv0hRDCFX3OqAMxWSbn/ophwfeMS4FZ3l1dzpxdyY/FyAdSQFekUOjauxUfMoMR
	sksV1M41OYvoPdsvpL6INBguceDYkCTw=
X-Gm-Gg: AR+sD10Fs081AI7XbOyouBuEiW8s029YsIygxYbVeq+3kR3Fgc5KUnUygU+E5X03TC8
	A3AZtRv4bBE69Ulu72gf5jyTAHao1QWTTl6U/gCbvJCGjJ2smmoPZfqJiapIidfXfz8UDbUbM++
	G2nlUhK/xDVnuhTs0pClEqORjH3sO67DtiVJQWJQJrlmysZzAHxZnnDwaddNllr260D7fa4/YXW
	T8X1TJH1TC/M+fJEzbO0MzOJT6zffWI+WMNVg/Zmr6Z5n9IAr+zdqpAiIDU7V9rp1gsY5Zp3FR+
	u8VJMUKlt4jk6mnksIJkhiVeUUxmivDRUXrQhQKqwChWZyzsBq/DD1Fzz3tsN7t3STD16FzX37P
	j
X-Received: by 2002:a17:907:934a:b0:c21:34a3:4df9 with SMTP id
 a640c23a62f3a-c25b3b0003cmr478506666b.3.1788261236124; Tue, 01 Sep 2026
 04:13:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260831-mglru-flags-cleanup-v4-0-2d15dde0d7ee@tencent.com>
 <20260831-mglru-flags-cleanup-v4-6-2d15dde0d7ee@tencent.com> <CAGsJ_4y7MrUeHn4NvtpyyZ3EY-6dTUD4vhitw6Sy6tfRq6Tf9A@mail.gmail.com>
In-Reply-To: <CAGsJ_4y7MrUeHn4NvtpyyZ3EY-6dTUD4vhitw6Sy6tfRq6Tf9A@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 1 Sep 2026 19:13:19 +0800
X-Gm-Features: AcwNN1X-j4abCvg1T2GB3Ar-5P2Ua0p1HBjUPKbFFW5g6FNochd-6przwbyCyV4
Message-ID: <CAMgjq7CiewVYOsBoXMjg+tgbUMsXgYoTe1gJiEoADQdusffeng@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] mm/mglru: fix potential generation folio number leak
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: u34agzcnmnsg3k9i37o1aypx5aedgizt
X-Rspamd-Queue-Id: DA518140008
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788261237-586646
X-HE-Meta: U2FsdGVkX1+YsFRVuheX7s3P7V1YUutjjRD8sHCd866t3sDacLYqZprfQm29DgIFsfRq9oNZsx25VjKsdBp4E+5shYPQfI6mmzgeBxxoYytxQsi7Ob89c0fqa2fEqRxOCRz31aPpTDM4WcfA3kWLESjeFqXVJX1jSSJK9ZWKutinzhzaJkJlkYwtmyboFUd2Z6Dy16hEWVBY6wz99iTqKsARUuwD1myPGdnMV+zwK+Pi5BXgIDlB70ck9ep9v6Fl7soEEhhdMQZqLUhof5CLYZ8whEGkkxZGmuKpk+NKUlbQA1ofCwSLhAFFIw/jTDq2uFJ5CXBDvT6gG8nz465OuFFTjot3T4n0ud9SAoTT6rd8OsvVOe/awupAZjFShfxdJB8WGpLqD+D36rUE/Dj0t/5grpjq4L8v7rIYGoq4HmV8Pu9dQXvziQAJwqX5f/TN59PuLlpkZBzRFxZGnb9Sk873DpdhNEWhV++5qVMIvko1POvGaPLEL+vTZrs73iMViA005WHXW33KzF9+h3bar1+H8ULugJynksdJxxxyCvmyU+ISxha2hrLHnyN9mehnUKi6P+6yXJfQAaXmoF7moKibcTZMbbB4I0ITq/wHPtOgrQfOViDTt+EX3g0su+0Zx/cG9y05Rn7CSdagRBV2Zmz7vfSOwQQkXrE305ooutKOUQWZAYUMaiStyS+jMblnrh0Zo19dXQ6wRV8z1IwS++8Ef+ESrSXPwSH6aERIf3gwib4Z7KZrpvkXYQybgJ3DqDPkdozRWA+poMjHnNgw1abGl2tHDjz9VvHqm08xQG96KmLtED2Nuvlzy4Ny741o2tdIOq4vQs+r7UwbKe5EfLNmJExMfg6tX9YAExLYCB/QK1WYDtveH1UEgz5V/TGUpqT7Vl/6M2Aa4DH8XTIgDoaU5GiFMuj2lwX1Bp9Jmb3F+uzRaSFfn/0VJDDYZ1rZ9TsqA8u3dvn+f9n8D5p
 TPqM8/oS
 XL8/w6TDs2sbx9ZETsA3AEtVjrZjayzbGo9lTcaqfemgD3l/yzKMlRG6FZSOcg5Qub9grok+kKgzKm5GLsJpyjSqk7EZ3DSGOW0xPxmXawMfKwD/ryypeVv71Yqwy9qEgA+eJIThqvhTXoRBQWdPS4DI0ML3FHPYRp9pcBPVcgJoJrSm0LcX0KDhCFxkrXH+1JW3+x9yVAZW3bEe/Voqbs+wjiKdYiHh3lgwSW5BIue5s9lYj7cm+Ufl/Lnis78ISaZ4HeIfOBVLvGb/Euvik1yWEPb03KxkaPIkkVmyZgIn551shFRo5UdjiZh0kZetHUh4YNN7C/f6mDuqXGyxer0GztgRa3lZZ0lfng/j91AXDuExNidqv/R2IrGEERY0Z/Sf8SziAylLpHgeO64jkQAriszPly3AM5kUc3PPixollePtXnwFp427mRWuKnT6c0u5CNMSb18Bi4EnDqA39IuDnro/aaCpPopze2cUhyt75QtzIzRMqrRzB0rJyoAbaBCufREhQH2bYMQ9Y0ul7hF1AXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 1, 2026 at 6:56=E2=80=AFPM Barry Song <baohua@kernel.org> wrote=
:
>
> On Mon, Aug 31, 2026 at 2:43=E2=80=AFAM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Each generation of MGLRU accounts anon and file folio numbers
> > separately, and the page table walker updates each generation's
> > counters in batch once the walk is done. The walker promotes a
> > folio's generation with a cmpxchg on folio->flags, and
> > update_batch_size() then reads the live flags again to pick the
> > anon/file column to charge. The walk holds neither the lruvec lock nor
> > the folio lock, so the type can flip between the cmpxchg and that
> > read: the lazyfree path clears PG_swapbacked, and reclaim sets it back
> > on a dirty lazyfree folio. The batched delta pair is then recorded in
> > the wrong type column. Nothing reconciles it afterwards, permanently
> > skewing lrugen->nr_pages and the reclaim budgets derived from it.
> >
> > Fix it by capturing the type from the flags snapshot the cmpxchg
> > linearized against: folio_update_gen() returns the type of the state
> > it transitioned from, and update_batch_size() accounts with that.
> >
> > A folio's type only changes while it is off the LRU list, inside a
> > del/add pair under the lruvec lock, with the gen bits cleared in
> > between. The generation and PG_swapbacked sit in the same
> > folio->flags word, so the cmpxchg snapshot captures them together.
> > Let G be the generation that snapshot captured (old_gen) and G' the
> > one it wrote (new_gen); the CAS can land in only three places:
> >
> >   - before the del: the folio is anon at G; the batch records anon
> >     G -> G', and the del later removes the folio from the anon
> >     counters;
> >   - between del and add: gen =3D=3D -1, so folio_update_gen() returns -=
1
> >     without touching the flags and no batch is recorded; the del/add
> >     pair accounts for the move alone;
> >   - after the add: the folio is file at the fresh generation the add
> >     charged; the batch records file, that gen -> G', matching that
> >     charge.
> >
> > Unlike the drift of lazy promotions, which sort_folio() repairs under
> > the lruvec lock, the phantom deltas from before this fix land in a
> > column the folio never occupies again, so nothing ever repairs them.
> >
> > Fixes: 018ee47f1489 ("mm: multi-gen LRU: exploit locality in rmap")
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  include/linux/mm_inline.h |  7 ++++++-
> >  mm/vmscan.c               | 13 +++++++------
> >  2 files changed, 13 insertions(+), 7 deletions(-)
> >

Thanks for the review!

> > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > index 047295ae6e8a..7e487c23aff7 100644
> > --- a/include/linux/mm_inline.h
> > +++ b/include/linux/mm_inline.h
> > @@ -10,6 +10,11 @@
> >  #include <linux/userfaultfd_k.h>
> >  #include <linux/leafops.h>
> >
> > +static inline int folio_flags_is_file_lru(const unsigned long *flags)
> > +{
> > +       return !test_bit(PG_swapbacked, flags);
> > +}
> > +
> >  /**
> >   * folio_is_file_lru - Should the folio be on a file LRU or anon LRU?
> >   * @folio: The folio to test.
> > @@ -27,7 +32,7 @@
> >   */
> >  static inline int folio_is_file_lru(const struct folio *folio)
> >  {
> > -       return !folio_test_swapbacked(folio);
> > +       return folio_flags_is_file_lru(const_folio_flags(folio, 0));
> >  }
>
> I guess we don't need to change this function? It seems more natural to
> me to keep using `!folio_test_swapbacked(folio)` here.
>
> In `folio_update_gen()`, you already use
> `*is_file =3D folio_flags_is_file_lru(&old_flags)` to get the type from
> `old_flags`. I guess that's all we need?

Yeah, that's all we need, I was thinking that using
folio_flags_is_file_lru here can avoid any further change to
PG_swapbacked causing inconsistency of folio_is_file_lru and
folio_flags_is_file_lru, seems a bit easier to maintain.

>
> >
> >  static __always_inline void __update_lru_size(struct lruvec *lruvec,
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 724b6e034e69..87e667c410ed 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -3269,7 +3269,8 @@ static bool positive_ctrl_err(struct ctrl_pos *sp=
, struct ctrl_pos *pv)
> >   *********************************************************************=
*********/
> >
> >  /* promote pages accessed through page tables */
> > -static int folio_update_gen(struct folio *folio, int new_gen, const vm=
a_flags_t *vma_flags)
> > +static int folio_update_gen(struct folio *folio, int new_gen, int *is_=
file,
>
> Rather than is_file, I feel was_file would be more accurate here,
> since it doesn't represent what the folio is now.

I'm fine either way, is_file seems more natual to me. Or maybe simply
rename it as "type"? Just the below:

> > @@ -3532,9 +3533,9 @@ static void walk_update_folio(struct lru_gen_mm_w=
alk *walk, struct vm_area_struc
> >                 folio_mark_dirty(folio);
> >
> >         if (walk) {
> > -               old_gen =3D folio_update_gen(folio, new_gen, &vma->flag=
s);
> > +               old_gen =3D folio_update_gen(folio, new_gen, &file, &vm=
a->flags);
> >                 if (old_gen >=3D 0 && old_gen !=3D new_gen)
> > -                       update_batch_size(walk, folio, old_gen, new_gen=
);
> > +                       update_batch_size(walk, folio, old_gen, new_gen=
, file);
>
> This is one more place where we rely on `LRU_GEN_ANON =3D 0` and
> `LRU_GEN_FILE =3D 1`.
>
> We do this kind of thing quite often in MGLRU, such as `type =3D !type`.
> It relies on the numeric values of the type constants, which is sort of
> a semantic abuse, but it's hard to find a shorter way to express it.

We also ahve WORKINGSET_ANON, WORKINGSET_FILE, ANON_AND_FILE. I can
rename the newly added parameter to "type" here if that looks better.

