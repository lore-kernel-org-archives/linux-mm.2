Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0616FFCD0DD
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 08:31:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48E236B012D; Wed, 18 Mar 2026 04:31:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43EE76B012F; Wed, 18 Mar 2026 04:31:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 354D76B0130; Wed, 18 Mar 2026 04:31:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 203BE6B012D
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 04:31:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7AF5F1B8466
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:31:13 +0000 (UTC)
X-FDA: 84558514026.15.3C53E9A
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8584C4000D
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:31:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O1gP7w6d;
	spf=pass (imf27.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773822671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7+1fVeUC+UYdNq0tyzSP85sezL1o3FF4lDWSJaKwgMc=;
	b=7FOFydhCJVOpbNTMrqP5cC6iA1YpIZ/weOSD/Z4yHTHvSBCaEhg5rp7IZB3qwW6gW453kx
	nqNzCrJogFHekTR9pNspJtTaSB9GbUiDZT4IoK/Ny0kcNGRXhfh6N1HNQHAYTs9yqB9bnO
	zIHciUxQ+4i7X8V7IB/o0eN5G6IO+68=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O1gP7w6d;
	spf=pass (imf27.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773822671; a=rsa-sha256;
	cv=pass;
	b=oZorrARiF/zSKQ70uxxiLHP4Ee6Vxtpx4a5MQFI+VMkvprmacDn7uUmnXyqS9TSA1Vo1cc
	tuhlIyCQuIfkCGjIuH9g9cF/SqKfutA069Oa72BEO472o3JlFgbGUNYBnWDqLWPbo4a2RO
	9OYyGaiYVvyXra08kZDdaZT/Wh3zUnI=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-506362ac5f7so61765481cf.1
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 01:31:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773822671; cv=none;
        d=google.com; s=arc-20240605;
        b=cv69mM+0lbyMPfPKjigQgCGSYDom5P9lZxNhJu4I5ilOG1pUqLF9XxQxqwO14ejNPV
         jLHupCbohvZ2F0lbOcXltAlcVlMoSrDUpZJZYyux0Y8RSSBA8WobKrzBzyOABdavXX27
         XcRQf2icHrnd8qmYqMcVAxAmwyKCpc124aAgjPNYlQooleFy2u6FSYyyeMVl1JNbFARN
         Pd0GJwzMVsSTOJIaIV3XuNBNSinMEYdmxE2Cc29QFAF3PBTDPLOCgSBrmJXRl18+srSq
         3Q55k9rLS4vgYUzHIC5lX9wG0N25Xmzn/+Vr2rZbRjUzGylNqmo/T+tZcSUwMwXEZl52
         nChA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7+1fVeUC+UYdNq0tyzSP85sezL1o3FF4lDWSJaKwgMc=;
        fh=a3TjRLgfDK0dFNqPgsMW87AR1cdALavO7ptuOr4jphA=;
        b=gMPT0OK3QO99Fr6L4/jAIirTfM4qL/Cd0TCrqbWo3nujq1EFoGDr6MvmAQ+MzMNOCh
         9Yc1vs1cOZp3dzo+mPIBgmg8QYhXY3Rnqs2RoRN1pfvHP7POy684wLLJSmsfFORmHlbx
         9ZFmVjwFuoIXslQnxurJ/bzgZGIxCcXHc6GYtZ7XYaalVs2/ctKB7od47uw2zIbfOuVA
         /pSS7ErVd0g7WbKR+HMm2xBNjF03uBx7cwap+VUl6pb5DuHPz9q8RHrvLitmMPXZZ7Fv
         i7rXev/WawNmPGdeF35xv5vk4tIfzVCWCDRZJDHsHV8RT4gKu6VpDfsEE2SLiWLhLbiU
         L1Xw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773822671; x=1774427471; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7+1fVeUC+UYdNq0tyzSP85sezL1o3FF4lDWSJaKwgMc=;
        b=O1gP7w6dq+YZiVSWRQBiOWH67+1GAZPhhKOf5oNoPBFvxallBIuegPOPWJGfDgPtG7
         wROagiUvml7wpaMWTLSr2fpx88jXpgsGha4CHzkjD3VOODbfkfaiOxKgc1zX2n5+wh+a
         M8fiiFCJXQgG8ISv90y30oioW1iLVy1CXCTgAqREaZHkM93KtKvsDfV5Ep8jvFXwrzmh
         y1besPuavE0q3Xr1hqy21TNT0H8Di6fnfuE5FwOQAxr/APl4spnwMPUokU7U7mleXIog
         GOw3vB0AwTuXPuiHA1+lihLYryru7OhBClUDDBZMOaH39chYMt2pXexCwCeU3mhTNUSd
         o+Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773822671; x=1774427471;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7+1fVeUC+UYdNq0tyzSP85sezL1o3FF4lDWSJaKwgMc=;
        b=KHyY06Ln3ysxMbTnReVkjIsCuf6viuZWtgLKQslYbFM5NxdgFkhhBXU5btxRYyhfWP
         YeegO48DBFJhW7prrQtYv3DpEMkCm1OcD6ZlAzVqfSCI4GL7b4lhX9TR2CbUK3Ow+YDe
         HJTWhxo37Zd7FYGRkDv1iNl+9IIKQykTkCbfWAiHQha8QS6aV2uacqj0ux0MiKdGzJZc
         TgRljzbbbEFSNHz6YjVgVUGYCwFiWcswkrwQY9s5QgY9mSpN9MiAFwebFKIQIQeCH7wI
         DK8mJyKA+i6ITimCTRV0y4Gol75b4W1dkqZ03DokJzuryy0dMPV5yAv+j9PIOtjLY6wu
         PZ1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXycFlrtCp/MppfSGcegRI/Bc6qHuJYGhY6d8uk5W4BpHxaa7v1InsWa7Z6Vs1GhxNxblubNlBjWw==@kvack.org
X-Gm-Message-State: AOJu0YwY9wz2HmSKZhxFwdwqvmRCTmJ7qQNehZ6tr9tp2BcxNLAYBaHS
	1F6Xyo7fDgZ31MYKIUDe1auIT68fcQ6nV9cqG74R8pQI9vnBVENPInXXiU2iEefdIDMcnfIFONT
	UAHxeyc8Nd/7iPQa66bZ4evVhkb9fECs=
X-Gm-Gg: ATEYQzzU8wpagLztKSS8W60KIE8i/LGH2eGc9oirsSwt2GpbbkuJ3sgbcMS2QPnZYn0
	lgl3/jvYZB5g65THOUyvwt4JRBrX0EotXIaUc2rt4ylUl9cpTAOSCz51BtN1ymj+Yr/90p0CEjs
	zNFWM82hY352r3Wq3dlUbQ2dPR+HSy/oQ+0cS3LVygJUecP7Q6D1NnV6hSOjgZrUgyzvyNvnnA6
	bqj6ce0gdvff6ANjOQr8HrQ3E07d2S2CakO/Ex+NWbRhQ7XeQy6AFAl6Yt8yNmUuTWVGoFA5HHu
	avkGr5UPR2TY5a2t
X-Received: by 2002:ac8:5848:0:b0:509:3257:c050 with SMTP id
 d75a77b69052e-50b14797e3cmr30015331cf.24.1773822670066; Wed, 18 Mar 2026
 01:31:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260318-b4-switch-mglru-v2-v4-1-1b927c93659d@gmail.com>
 <CAGsJ_4xHvtjkPp5Ar16UXqZhQYHpdYcqCWMmFbGGUvK-kCH+uw@mail.gmail.com> <8c01a707-f798-4649-8441-d82dd0dac7b9@gmail.com>
In-Reply-To: <8c01a707-f798-4649-8441-d82dd0dac7b9@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 18 Mar 2026 16:30:56 +0800
X-Gm-Features: AaiRm524WVeBJOY_8tdt1YQPr1Lf4x2tyyTbog5tXqKO39Orsqdtt0nbwdFu61c
Message-ID: <CAGsJ_4y+SwwCtDu8zPYnuSdyS+1=q77d1Fwq6eHbqrnw8-6K=w@mail.gmail.com>
Subject: Re: [PATCH v4] mm/mglru: fix cgroup OOM during MGLRU state switching
To: Leno Hou <lenohou@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Jialing Wang <wjl.linux@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Kairui Song <ryncsn@gmail.com>, Bingfang Guo <bfguo@icloud.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4ioynn7beorw8iyye6gpqqnxfknnmcqr
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 8584C4000D
X-HE-Tag: 1773822671-704189
X-HE-Meta: U2FsdGVkX18P53C6OjTiHSVXverq8+ijPb6vR1clrWpCQcYU/4bQVVlHGtleKebctUCjxfllSG08euKEF2aqSZoo5XdZwwLTIoyq2NL+7641hQSYn11OJE4JNKOKoHWoKqi2SePGz8kqQtsYKDjtUk0I098q0KhNjnuj3jWlCZ+hFwaMRA4ZL0zfXJNWfH2b4WjaFx+C2vtXiP2HOQkXbdVxgOsGqEKafJDk5MJoa1/z5rgQgAqTtWhXvflfnzJByR1pdf1uVkR/9booUtC42NCTDT4BpGqgmzY1R68DktqiGdOryxI1XUq/jy5n/zcndffhAcooFWUdoh9pJLRsKCCqfAXOHBvQq8ku7CGjETEkzpgUlK73fPWAFjpQgHiC37AvepEYMYOoGAuHoBRjhV65QMnkSrxPhqHneQh2bssfwCTNhn/Fk9lCQEFMn2XqgVqeke4mUuU+6jjpV2/k6mkkiwPB9BM2w/L/FMt8W8eFxX4DNtIFbAgzHxpiMXjCya6jFtGHRjaliNrJ/PrK3kGt3ARgBPVw3TiF8yKyoHWpVWawmHfXQnqeug9qn59vbmFkMQgQVV/VIGeN8xgCrIHXjhaPczjQqlpttHeMNw33SjikNNHh4Qrzli8rTYaHJGZ7GvRc+0Qy9FNdXB1iuFs3S/OEFRltnHB7Bst+fVVVhXkzLYDBGBiqy7vxe4q71ImPBAVLZo2urvO3QLx3aDMeH/XHeTPmOS2fdC6pbiCo7dWL5I5G6J80Sp3zzijkmtxWvhTRX5FhF0Fa6ap7cfaEJUvXq/TjXzL+KeToCWJxerRpe+X/Tpz/VTNWufojxD5IXOFdHy9kZQzGroZeo7hW8gFK8QHAGZoQI63dYBEFfI6xZZUwNMY1PEUXkIlTfc4b1YxGs6hwMT/OWvHqjb0yfExNs6teHqrGdeYu/GEZzbQVTFz6KlNcUfcBSVceZGIPRf3WOGu050s854c
 UomhYVHx
 3QmbHsCd7M2uGLzxtj2rUwjYIr9AMmh/MSeWcZH80mtIfAf9J6eK+TJRQD+MevHepkluQ5Cq4sovgdBSytglNk0fWDclKW+jKcAxgxb43odkP8CJvYXxSWxDFueXtwpAtRI0K4t81at5pBYEdIHRYLzJlzM6fNqcXOf7/P26Ediy4L/G2FAP5uWoSzXo7yaQ9H9lIMIZCk2c7tWmWzJlVF/EKPx6i3VAFt4DNQUFM8HXfFQuY3FaA1QcM65sW346lEUTm7/ppbzIu1FCpCGi0qkY7u5bFM1OeZGVBFi3ZEivF7o80yOOZD2aaiwosnjHJc624Yfo8LliGV9ypPnpwLd04uwX/0C7v1AVKmJJJTm2fWQQFR5OBXDRlguHHGWwI8+4a+vq6Ofr8By2HRgXoFTtsB5FX1Hk2hS5jSMYqHaH0niImvBKYywRBuBZpm1WEG0/z6yBVlA2S4TSEMUIq/ZOS3A3HPl4hl7cFJGXekKh4/omhDGTX2MDKWrwinNbO/pFUQYxLD7gg49c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 4:17=E2=80=AFPM Leno Hou <lenohou@gmail.com> wrote:
>
> On 3/18/26 3:16 PM, Barry Song wrote:
> > On Wed, Mar 18, 2026 at 11:29=E2=80=AFAM Leno Hou via B4 Relay
> > <devnull+lenohou.gmail.com@kernel.org> wrote:
> >>
> >> From: Leno Hou <lenohou@gmail.com>
> >
> > [...]
> >
> >>
> >> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> >> index ad50688d89db..1f6b19bf365b 100644
> >> --- a/include/linux/mm_inline.h
> >> +++ b/include/linux/mm_inline.h
> >> @@ -102,6 +102,12 @@ static __always_inline enum lru_list folio_lru_li=
st(const struct folio *folio)
> >>
> >>   #ifdef CONFIG_LRU_GEN
> >>
> >> +static inline bool lru_gen_draining(void)
> >> +{
> >> +       DECLARE_STATIC_KEY_FALSE(lru_drain_core);
> >> +
> >> +       return static_branch_unlikely(&lru_drain_core);
> >> +}
> >
> > Can we name it lru_gen_switch() or lru_switch?
> > Since =E2=80=9Cdrain=E2=80=9D implies disabling MGLRU, the operation
> > could just as well be enabling it. Also, can we drop
> > the _core suffix?
>
> OK. Next V5 patch will be:
>
> +static inline bool lru_gen_switching(void)
> +{
> +       DECLARE_STATIC_KEY_FALSE(lru_switch);
> +
> +       return static_branch_unlikely(&lru_switch);
> +}
>
> >
> >
> >>   #ifdef CONFIG_LRU_GEN_ENABLED
> >>   static inline bool lru_gen_enabled(void)
> >>   {
> >> @@ -316,6 +322,11 @@ static inline bool lru_gen_enabled(void)
> >>          return false;
> >>   }
> >>
> >> +static inline bool lru_gen_draining(void)
> >
> > lru_gen_switching()? >
> >> +{
> >> +       return false;
> >> +}
> >> +
> >>   static inline bool lru_gen_in_fault(void)
> >>   {
> >>          return false;
> >> diff --git a/mm/rmap.c b/mm/rmap.c
> >> index 6398d7eef393..0b5f663f3062 100644
> >> --- a/mm/rmap.c
> >> +++ b/mm/rmap.c
> >> @@ -966,7 +966,7 @@ static bool folio_referenced_one(struct folio *fol=
io,
> >>                          nr =3D folio_pte_batch(folio, pvmw.pte, pteva=
l, max_nr);
> >>                  }
>
> OK. I'll be add following ducumentation that just you said.
> /* When LRU is switching, we don=E2=80=99t know where the surrounding fol=
ios
> are. =E2=80=94they could be on active/inactive lists or on MGLRU. So the
> simplest approach is to disable this look-around optimization.
> */
> >> -               if (lru_gen_enabled() && pvmw.pte) {
> >> +               if (lru_gen_enabled() && !lru_gen_draining() && pvmw.p=
te) {
> >
> > Ack. When LRU is switching, we don=E2=80=99t know where the
> > surrounding folios are=E2=80=94they could be on active/inactive
> > lists or on MGLRU. So the simplest approach is to
> > disable this look-around optimization.
> > But please add a comment here explaining it.
> >
> >
> >>                          if (lru_gen_look_around(&pvmw, nr))
> >>                                  referenced++;
> >>                  } else if (pvmw.pte) {
> >> diff --git a/mm/vmscan.c b/mm/vmscan.c
> >> index 33287ba4a500..88b9db06e331 100644
> >> --- a/mm/vmscan.c
> >> +++ b/mm/vmscan.c
> >> @@ -886,7 +886,7 @@ static enum folio_references folio_check_reference=
s(struct folio *folio,
> >>          if (referenced_ptes =3D=3D -1)
> >>                  return FOLIOREF_KEEP;
> >>
> >> -       if (lru_gen_enabled()) {
>
> documentation as following:
>
> /*
>   * During the MGLRU state transition (lru_gen_switching), we force
>   * folios to follow the traditional active/inactive reference checking.
>   *
>   * While MGLRU is switching,the generational state of folios is in flux.
>   * Falling back to the traditional logic (which relies on PG_referenced/
>   * PG_active flags that are consistent across both mechanisms) provides
>   * a stable, safe behavior for the folio until it is fully migrated back
>   * to the traditional LRU lists. This avoids relying on potentially
>   * inconsistent MGLRU generational metadata during the transition.
>   */
>
> >> +       if (lru_gen_enabled() && !lru_gen_draining()) {
> >
> > I=E2=80=99m curious what prompted you to do this.
> >
> > This feels a bit odd. I assume this effectively makes
> > folios on MGLRU, as well as those on active/inactive
> > lists, always follow the active/inactive logic.
> >
> > It might be fine, but it needs thorough documentation here.
> >
> > another approach would be:
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 33287ba4a500..91b60664b652 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -122,6 +122,9 @@ struct scan_control {
> >          /* Proactive reclaim invoked by userspace */
> >          unsigned int proactive:1;
> >
> > +       /* Are we reclaiming from MGLRU */
> > +       unsigned int lru_gen:1;
> > +
> >          /*
> >           * Cgroup memory below memory.low is protected as long as we
> >           * don't threaten to OOM. If any cgroup is reclaimed at
> > @@ -886,7 +889,7 @@ static enum folio_references
> > folio_check_references(struct folio *folio,
> >          if (referenced_ptes =3D=3D -1)
> >                  return FOLIOREF_KEEP;
> >
> > -       if (lru_gen_enabled()) {
> > +       if (sc->lru_gen) {
> >                  if (!referenced_ptes)
> >                          return FOLIOREF_RECLAIM;
> >
> > This makes the logic perfectly correct (you know exactly
> > where your folios come from), but I=E2=80=99m not sure it=E2=80=99s wor=
th it.
> >
> > Anyway, I=E2=80=99d like to understand why you always need to
> > use the active/inactive logic even for folios from MGLRU.
> > To me, it seems to work only by coincidence, which isn=E2=80=99t good.
> >
> > Thanks
> > Barry
>
> Hi Barry,
>
> I agree that using !lru_gen_draining() feels a bit like a fallback path.
> However, after considering your suggestion for sc->lru_gen, I=E2=80=99m
> concerned about the broad impact of modifying struct scan_control.Since
> lru_drain_core is a very transient state, I prefer a localized fix that
> doesn't propagate architectural changes throughout the entire reclaim sta=
ck.
>
> You mentioned that using the active/inactive logic feels like it works
> by 'coincidence'. To clarify, this is an intentional fallback: because
> the generational metadata in MGLRU becomes unreliable during draining,
> we intentionally downgrade these folios to the traditional logic. Since
> the PG_referenced and PG_active bits are maintained by the core VM and
> are consistent regardless of whether MGLRU is active, this fallback is
> technically sound and robust.
>
> I have added detailed documentation to the code to explain this design
> choice, clarifying that it's a deliberate transition strategy rather
> than a coincidence."

Nope. You still haven=E2=80=99t explained why the active/inactive LRU
logic makes it work. MGLRU and active/inactive use different
methods to determine whether a folio is hot or cold. You=E2=80=99re
forcing active/inactive logic to decide hot/cold for an MGLRU
folio. It=E2=80=99s not that simple=E2=80=94PG_referenced isn=E2=80=99t mai=
ntained
by the core; it=E2=80=99s specific to active/inactive. See folio_mark_acces=
sed().

Best Regards
Barry

