Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45DB81077607
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 21:29:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 516916B033D; Wed, 18 Mar 2026 17:29:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C7826B033E; Wed, 18 Mar 2026 17:29:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B5E86B033F; Wed, 18 Mar 2026 17:29:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2B3E66B033D
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 17:29:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C2559140192
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 21:29:32 +0000 (UTC)
X-FDA: 84560475384.29.B15A57B
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf05.hostedemail.com (Postfix) with ESMTP id CC49E100004
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 21:29:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b+dsrKCr;
	spf=pass (imf05.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773869370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZBW46ZC0WhDy5jK+PZL6RrKdXs21bneTx4tgRUYVNYs=;
	b=Dfm8nteXbtWk2Kqg5Sl513sze/ppUpXStMyPtxuzejNreRlD4+wj/eaOmRSJnTLX8RdlbC
	1jx4Cst9FluXT98io+eSNcQIBEnErhs3e6adsDyyqCP/5bEkfL2lT0NZh6B18uGhv/M+rD
	+m0CrgDltPW+pxKSB2O4YIgfyXNbJ0Q=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773869370; a=rsa-sha256;
	cv=pass;
	b=oNoHFmVy1ejAxPnHekEPxUDUQ2L33B9gdtusnL66rhkkXM2T+CbmHQrXKPPLX2Xs9kQG5M
	UfqTuv0PqRtav3L/tQJ7IyyWd4C1kWOKjvOGN1U9u/Il/CrfEV8NWpmzsiJYmgshhF68oP
	2b3n/29/eNLiHUfBGFeLCRdRH+XPI/I=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b+dsrKCr;
	spf=pass (imf05.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-89a14be4733so4779816d6.2
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:29:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773869370; cv=none;
        d=google.com; s=arc-20240605;
        b=FtUpUOA+DmrsbrdiDz9g8aQN4uEsmb1oWp7fk02Fewl+g/xmDAldyvs8wSn6Ns59+T
         VxsNnT/PtVJX19QtgM2rkt97DPhxI7RdB/c00f9eg5l6pFJIIjftniJSouFTG03f9CCw
         UBhKxuOWoSkhpqt03o4tnmh1w/NLCs4ondW+co8SsoCc6V+EeSDQVMixyamlpbyOgxBD
         X1PKB3ccrYdZIk3LqzJ4BlWkLHvXE0lrdhvV0vKs8X2Z4iK0p8/qn6qFzLbe7pt969hn
         rLKYPMkZHq9y5Oxy8r/HIMMvB1RyPRYEIiUwXPsc4WM9cXXNRSM2JbEBAp6qzyXn0Iya
         TO8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZBW46ZC0WhDy5jK+PZL6RrKdXs21bneTx4tgRUYVNYs=;
        fh=k2uzLZDLFD1vFCe+wXS+9xi2loFEPcpMC16Wgksf1xo=;
        b=F8nt+XBotb+KW0QSQ7v9FPpyhAi1GduH8O4qn5NMV1vSb9Qf0SPPh94/AbkiFyYv+R
         eLd49mNBEFhou8tWEkRDvnmQwwgrpGiMrdfA23dnbMwKNhk5htcH+rFH4pKBu6FyLNwE
         fLuGwOz89J/ctjL/qORS/N/tk/YSFRMTHfYBBjUNoYfc86cxMqw6bsEK9A5u/tA2n0mC
         9K7sa4SusK8ORMZaGL62KfxHYwT2n1axnKvtnwIIZixvyITU3xh55H9gCenMI9xnWocw
         CphPjSh49iuURLeqkNpdAsWyGC+cXnXhfKlWFBZMV0XjuxQFoUw8s8ynGNqYqTHJqV6v
         1tXw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773869370; x=1774474170; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZBW46ZC0WhDy5jK+PZL6RrKdXs21bneTx4tgRUYVNYs=;
        b=b+dsrKCrKJ1UroDpFSbYutzARFh1raa/GAUIn1nFMJZglnN4KQd2M+n7RVP8S6N6ei
         qvvGPMqCmCR8ZJoW8ni3kkeDvuNFIGr5jp75azhvU1VqbaGDNxHRHYLaR/zaS5c/3r5Y
         /jlH5MB1iYO0yZytmX5TlQPxjE/9NYq2B0sf8hICiFNeav8my3xp0NbIesRtJ9rHwNMH
         TPwwG9meHbzFO4vCnACuTvsrl3EvprbgHFyB4rEDZZ/gyx09EeMP4uLLHkmNlToKCaFt
         cjKmlD0gB18+H6KKad9ZPkakJ979W+S5JUngYEua1VxXPQffixd5+g8JhAU4gGQ9/hdx
         sHnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773869370; x=1774474170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZBW46ZC0WhDy5jK+PZL6RrKdXs21bneTx4tgRUYVNYs=;
        b=HOetBy+HS1lewQhzbwS4HHGhfOpFGHfLQlKulnA/1bspe8g17TnT8JTAm/7gTwANTY
         qdetKDOs/FspSslH0CSVywRbmwfIgvi8oDqLaAeBfD42yTQcCs46RQ05CRRZmtGKQg/K
         amGa7N8FQ7qRNubeWQZ7TIKTCiGOJP+RqlplhS2Lm+jAW78aAmrfJk1sKuaCZ+b0mMxF
         o6kNdSvChx8F2CmNRZsAwYl3wE8Q29oCufb/HNjJZrjiNveC5RP6xxwODpk2ETVk4QmB
         Yw7ZIsrCElZmM8Mrl9z6voROd0xMyPZoBUGXDPMqhNBi1aLGzWWCD0o3ABO05h+N6CXe
         bbjQ==
X-Forwarded-Encrypted: i=1; AJvYcCXP+vPyG/aHl0zMBgcDiitP9bWCvRX7OW3icqejYR8LDBO9bLBIPRKPPmRQwzqmoNL0TSKoM5gbWQ==@kvack.org
X-Gm-Message-State: AOJu0Yx+7Up+gTl6FrcNiAbgHyL/mcFpbInDBY7zLGma//GBb6YMX1QN
	ksE2ncb4N39pTCBapPjtM8dAus6jhKPqt02+ltDhVlYH+lliAG4ZLBeF5/k3jADuUjLUR3LU0TI
	Wgq5Ru6F4XsMOdiKNDF2upnqNaA2E5O4=
X-Gm-Gg: ATEYQzx1Ia1BHyD0LMXi942Rc/DA55q4j77EP7JaDizzGR2xQYGgPEm7HjegI3YxF7v
	8UI4/uoWM0DlGAhzL+JNn5SbGNytWnnADOCCLVOXoHqGxps9kD4fXMWakWyaiD1+Ek95cNSZdh6
	kKAmLKzuGW3UJaxpPa1Sj0zotqgYxHg8oaKUSr+G3/KHzKICMI98NPXnZuBF+icd1oo95sLSG6U
	kRgxUGhnAIfSaO7d1L9SCcwvPfNQC1mpOde8mwkxatvjt3gf+h9YYbz6QhIt99XJ4/6dx4bB9Li
	R8rQI+kdLmdi3OqD
X-Received: by 2002:a05:6214:1bcd:b0:89c:4ea7:a716 with SMTP id
 6a1803df08f44-89c6b6fce3dmr76513296d6.63.1773869369500; Wed, 18 Mar 2026
 14:29:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260318-b4-switch-mglru-v2-v4-1-1b927c93659d@gmail.com>
 <CAGsJ_4xHvtjkPp5Ar16UXqZhQYHpdYcqCWMmFbGGUvK-kCH+uw@mail.gmail.com>
 <8c01a707-f798-4649-8441-d82dd0dac7b9@gmail.com> <CAGsJ_4y+SwwCtDu8zPYnuSdyS+1=q77d1Fwq6eHbqrnw8-6K=w@mail.gmail.com>
 <4807e460-054c-49ed-9792-f5000d7b3820@gmail.com>
In-Reply-To: <4807e460-054c-49ed-9792-f5000d7b3820@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 19 Mar 2026 05:29:18 +0800
X-Gm-Features: AaiRm52qPa1_u3B52HrBgnrs9M7Y4iKa0nDcEawn-AaMXXeJOp-93BbMronpItU
Message-ID: <CAGsJ_4yZEOS+Ht38hqeUGnzLktuVUfvCgusqS4JQCb34eYLXYQ@mail.gmail.com>
Subject: Re: [PATCH v4] mm/mglru: fix cgroup OOM during MGLRU state switching
To: Leno Hou <lenohou@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Jialing Wang <wjl.linux@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Kairui Song <ryncsn@gmail.com>, Bingfang Guo <bfguo@icloud.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: uyq4xhfzy1s4gjp3uhqskqqcen7h83tw
X-Rspam-User: 
X-Rspamd-Queue-Id: CC49E100004
X-Rspamd-Server: rspam12
X-HE-Tag: 1773869370-630835
X-HE-Meta: U2FsdGVkX1/nIKYbUgja/JuS+6btM7n7XClCuzMoDT1r7dZbuQ+QdXAw0XHnjcuXNZz4ClNWmXV96JWrFDt993xE5IWuTs3p+ZUZJ4TlEMeUR4hGSv0AEaLKnLwNXhQ2A8fYdyEb3icttiikIwwK+q9IR3n3Nfxb9zHBvRU/BkPa0qhqZUrG4VDAQ4Nm3t908YBBf0C1ZIpTmpzehoX7I3tO1aYwRitsFDvNufLAt26YYumBCxXf2aMynmsJmZyCGUzdcTG7C7RwhnGi0F2pedv3Kw4axwM+K7NkkvDhm/CaQ7LiGIzxfICbntvjDp6kVAHrB+LrW0hs48L7Dl2G/TUyjboM3QmT+pOWP2J7lmPCRzEbAXJE+RN1S4wvguOLW5mhkq1Itgz8Bnf3ZxvOcMfkGfETdfLKGbE+Kyf8I8z/kGYFm+bg/IezfT0nreD9StK02LJMOioti6arl/gkILr3Hi3ixK5PSDrWFYL3wZSaEXUEfIm0EXjRtF3ttZVj8mbvKsys+2yOMSK0Z9PJ0dT+ySqnh92vCuMx2NkMbxmxXEf3+4+1MCTft7uKLjnPJgvH1vC+SDHo+SRokRLcdCHJE18XR6jCYxliLASRyie35F/sAXNlrLNauj6MEWasrXcq5bAd+vVaQ8vzFGxwyml9cf7+4/9JIYyH2F5ftlnUIaZvEJQwtwlxij3dO9CIhPfMyuaQHn1hbdSTIL98Vbny2F1IMSEmF3vNSoj6paEzdrL+wtZoDxhh4PeUApmOF0iDb2tTMi+5GfRY8dGfvxfgI2ZYZVcgXBZXStDkxdA8GbwTQ92Q8SEhojjRDxYRKjknbbyT02g/gxQ+hF/5v24IimMqK51vKfU5BXW5UoAzUou8HXMljpqxpUPiDGWxoC/XlNmrPeidYFwj3LywpyibcFGszwG9npy3znUtfnQcPp/swAsYuW0T9Kdt2TeSkjKDkq6nSVaiEpIE0UJ
 JYcJCZAC
 AdWWH0nnl/w1zGI5KKvKOb15wgjX2FY10TR78nDNETJazPZhZJUSm4kBx7Aly2vO+AycVqEiUdGMIFMktz4IKvYmCKCGD3B8kKGyHnwBG/FaG2MPWYeEpFXCtfaY0ThWytROToDvLuG+ZYD+rDVpAFdsT9WJPAHgX+jOBKwAVXnIGrbZ/ZMPTEdJhxVJa68SFP3UNEquQOxDgLSxPiWefWOCpwa9PTwnqJCMudtMgJ9aMrR90yEG/f2PfLgda6zDfOivzFWKeKewAd1jOtTZF0DM3j++YKbrxUDh+5fs0prGPa8kOP6w4hXi1PBGgjODzGQl2hqHTS6Q6H/0lbBH7Sc7e2art+JjjX5GOFM/2UHddpantv1yBanyooXCp0UtCO7BeB5j1lJMZFxIOez97vAgmFi3SqKV22NOGsG3ovUrNVTQyChSAYv+oGN18taLtmYWHnii0FBX8X02VwySIk24uOw84txi30OH6jsaEOFRmtbkPMDNIgwit2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 8:56=E2=80=AFPM Leno Hou <lenohou@gmail.com> wrote:
>
> On 3/18/26 4:30 PM, Barry Song wrote:
> > On Wed, Mar 18, 2026 at 4:17=E2=80=AFPM Leno Hou <lenohou@gmail.com> wr=
ote:
> [...]
> >>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
> >>>> index 33287ba4a500..88b9db06e331 100644
> >>>> --- a/mm/vmscan.c
> >>>> +++ b/mm/vmscan.c
> >>>> @@ -886,7 +886,7 @@ static enum folio_references folio_check_referen=
ces(struct folio *folio,
> >>>>           if (referenced_ptes =3D=3D -1)
> >>>>                   return FOLIOREF_KEEP;
> >>>>
> >>>> -       if (lru_gen_enabled()) {
> >>
> >> documentation as following:
> >>
> >> /*
> >>    * During the MGLRU state transition (lru_gen_switching), we force
> >>    * folios to follow the traditional active/inactive reference checki=
ng.
> >>    *
> >>    * While MGLRU is switching,the generational state of folios is in f=
lux.
> >>    * Falling back to the traditional logic (which relies on PG_referen=
ced/
> >>    * PG_active flags that are consistent across both mechanisms) provi=
des
> >>    * a stable, safe behavior for the folio until it is fully migrated =
back
> >>    * to the traditional LRU lists. This avoids relying on potentially
> >>    * inconsistent MGLRU generational metadata during the transition.
> >>    */
> >>
> >>>> +       if (lru_gen_enabled() && !lru_gen_draining()) {
> >>>
> >>> I=E2=80=99m curious what prompted you to do this.
> >>>
> >>> This feels a bit odd. I assume this effectively makes
> >>> folios on MGLRU, as well as those on active/inactive
> >>> lists, always follow the active/inactive logic.
> >>>
> >>> It might be fine, but it needs thorough documentation here.
> >>>
> >>> another approach would be:
> >>> diff --git a/mm/vmscan.c b/mm/vmscan.c
> >>> index 33287ba4a500..91b60664b652 100644
> >>> --- a/mm/vmscan.c
> >>> +++ b/mm/vmscan.c
> >>> @@ -122,6 +122,9 @@ struct scan_control {
> >>>           /* Proactive reclaim invoked by userspace */
> >>>           unsigned int proactive:1;
> >>>
> >>> +       /* Are we reclaiming from MGLRU */
> >>> +       unsigned int lru_gen:1;
> >>> +
> >>>           /*
> >>>            * Cgroup memory below memory.low is protected as long as w=
e
> >>>            * don't threaten to OOM. If any cgroup is reclaimed at
> >>> @@ -886,7 +889,7 @@ static enum folio_references
> >>> folio_check_references(struct folio *folio,
> >>>           if (referenced_ptes =3D=3D -1)
> >>>                   return FOLIOREF_KEEP;
> >>>
> >>> -       if (lru_gen_enabled()) {
> >>> +       if (sc->lru_gen) {
> >>>                   if (!referenced_ptes)
> >>>                           return FOLIOREF_RECLAIM;
> >>>
> >>> This makes the logic perfectly correct (you know exactly
> >>> where your folios come from), but I=E2=80=99m not sure it=E2=80=99s w=
orth it.
> >>>
> >>> Anyway, I=E2=80=99d like to understand why you always need to
> >>> use the active/inactive logic even for folios from MGLRU.
> >>> To me, it seems to work only by coincidence, which isn=E2=80=99t good=
.
> >>>
> >>> Thanks
> >>> Barry
> >>
> >> Hi Barry,
> >>
> >> I agree that using !lru_gen_draining() feels a bit like a fallback pat=
h.
> >> However, after considering your suggestion for sc->lru_gen, I=E2=80=99=
m
> >> concerned about the broad impact of modifying struct scan_control.Sinc=
e
> >> lru_drain_core is a very transient state, I prefer a localized fix tha=
t
> >> doesn't propagate architectural changes throughout the entire reclaim =
stack.
> >>
> >> You mentioned that using the active/inactive logic feels like it works
> >> by 'coincidence'. To clarify, this is an intentional fallback: because
> >> the generational metadata in MGLRU becomes unreliable during draining,
> >> we intentionally downgrade these folios to the traditional logic. Sinc=
e
> >> the PG_referenced and PG_active bits are maintained by the core VM and
> >> are consistent regardless of whether MGLRU is active, this fallback is
> >> technically sound and robust.
> >>
> >> I have added detailed documentation to the code to explain this design
> >> choice, clarifying that it's a deliberate transition strategy rather
> >> than a coincidence."
> >
> > Nope. You still haven=E2=80=99t explained why the active/inactive LRU
> > logic makes it work. MGLRU and active/inactive use different
> > methods to determine whether a folio is hot or cold. You=E2=80=99re
> > forcing active/inactive logic to decide hot/cold for an MGLRU
> > folio. It=E2=80=99s not that simple=E2=80=94PG_referenced isn=E2=80=99t=
 maintained
> > by the core; it=E2=80=99s specific to active/inactive. See folio_mark_a=
ccessed().
> >
> > Best Regards
> > Barry
>
> Hi Barry,
>
> Thank you for your patience and for pointing out the version-specific
> nuances. You are absolutely correct=E2=80=94my previous assumption that t=
he
> traditional reference-checking logic would serve as a robust fallback
> was fundamentally flawed.
>
> After re-examining the code in v7.0 and comparing it with older versions
> (e.g., v6.1), I see the core issue you highlighted:
>
> 1. Evolution of PG_referenced: In older kernels, lru_gen_inc_refs()
> often interacted with the PG_referenced bit, which inadvertently
> provided a 'coincidental' hint for the legacy reclaim path. However, in
> v7.0+, lru_gen_inc_refs() has evolved to use set_mask_bits() on the
> LRU_REFS_MASK bitfield, and it no longer relies on or updates the legacy
> PG_referenced bit for MGLRU folios.
>
> 2. The Logic Flaw: When switching from MGLRU to the traditional LRU,
> these folios arrive at the legacy reclaim path with PG_referenced unset
> or stale. If I force them through the legacy folio_check_references()
> path, folio_test_clear_referenced(folio) predictably returns 0. The
> legacy path interprets this as a 'cold' folio, leading to premature
> reclamation. You are correct that forcing this active/inactive logic
> onto MGLRU folios is logically inconsistent.
>
>
> 3. My Revised Approach: Instead of attempting to patch
> folio_check_references() with a fallback logic, I have decided to keep
> the folio_check_references() logic unchanged.
>
> The system handles this transition safely through the kernel's existing
> reclaim loop and retry mechanisms:
>
>     a) While MGLRU is draining, folios are moved back to the traditional
>     LRU lists. Once migrated, these folios will naturally begin
> participating in the legacy reclaim path.
>
>     b) Although some folios might be initially underestimated as 'cold'
> in the very first reclaim pass immediately after the switch, the
> kernel's reclaim loop will naturally re-evaluate them. As they are
> accessed, the standard legacy mechanism will correctly maintain the
> PG_referenced bit, and the system will converge to the correct state
> without needing an explicit fallback path or state-checking in
> folio_check_references().
>
>
> This approach avoids the logical corruption caused by forcing
> incompatible evaluation methods and relies on the natural convergence of
> the existing reclaim loop.
>
>
> Does this alignment with the existing reclaim mechanism address your
> concerns about logical consistency?

My gut feeling is that we probably don=E2=80=99t need to worry
too much about the accuracy of hot/cold evaluation during
switching, since the system is already in a volatile state
at that point. So as long as we avoid introducing unusual
logic=E2=80=94such as forcing active/inactive decisions onto MGLRU
folios=E2=80=94I=E2=80=99m fine with it.

Ideally, we would add an sc->lru_gen boolean so we know
exactly where the folios come from, rather than relying on
folio_lru_gen(folio) !=3D -1, which can be misleading.
However, if this doesn=E2=80=99t bring much improvement, it may
not be worth increasing the complexity.

Thanks
Barry

