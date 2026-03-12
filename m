Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C358D106ACE7
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 20:08:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AA4E6B009D; Thu, 12 Mar 2026 16:08:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 061B76B009F; Thu, 12 Mar 2026 16:08:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA32D6B00A0; Thu, 12 Mar 2026 16:08:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D9F1E6B009D
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:08:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9AE5C160440
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:08:43 +0000 (UTC)
X-FDA: 84538498926.08.4701F53
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9AA1A18000B
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:08:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="eF/t88l8";
	spf=pass (imf16.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773346121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vI+2f0BK18gOdclBPROWIuuyekk+4frl3myDaAZuGkk=;
	b=m61H/GvLvtczxKXblmz7TH2AcogOdXWiGHSUXbPiPK+4SpnLqHRlsuz+xQz9k+dVObxl8+
	6MLRU0YPzOunye3gK5M7PG7cX6ybqOytFKJEIOzYmulOjTObHf6IsTulVjWSAC3aJ1Ke2k
	omm1VIv1zJJLL6u9A68X6UhEETl0uJI=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="eF/t88l8";
	spf=pass (imf16.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773346121; a=rsa-sha256;
	cv=pass;
	b=qezoHZFZYOuQrHeZtDU5LSNmBw0/iioytLfPMfafIuTm43vVDegMwf0dTsEve12UwaiLJE
	N+71GTi9TwaJJEFFTKPMVW1Zsppc/o2nF8avcICYBFW4l/utdf5kGiDRuheElGS25wLUrS
	258CsotGBcyxj0+eqWq5KbtY3cc2Jkc=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8cd79e43da3so146605285a.1
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 13:08:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773346121; cv=none;
        d=google.com; s=arc-20240605;
        b=Y8tVDf0nOQoSXK45D+JsVEHjYAJiil+xMj/OLCQnKHyiaA8ifGnsTOwr6EfBF7vDd0
         BSq+vg5FZcVDyZs1dt9Me2eerRUqwqDSndb45UnVcU9OuC557/qfhkEe+iTkwopxzWrc
         ABlSD1AD+zpyPJXxyl4t+TEWOYEXV1Jfd7Tn+v2NfO4BflnIZ7l+x6+jg2xqhJ9KiwAM
         +pvCfos9pfxaiOyQzGqTYAzwh+DjL0IkqWYWfKwzUNPGwQX3/+T5HsgHxTdZ9GBOrMak
         QhBfLqPZO+XJA03XvUIOnCpS2dGiTugzSUV8gu6bMv3NKkfWCvHCdnGmzrQ+AFr+ZFoG
         sGjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vI+2f0BK18gOdclBPROWIuuyekk+4frl3myDaAZuGkk=;
        fh=N9Zg3O40RinlG/uVanLOlmFpCSoO/Gqi1cIOglADxWU=;
        b=YoCiNcQjXSYXZbJZ+ZG+gaGWqm6phzGVq3uQ6BOjtijNZf2b8pON9SwWoEIfGmRl61
         200qNKq8J7F5wA2CCaeOSh6fDQJw/9kJtYjOLLXipkZrqoPprc8ZKnwTcMy3FuWgIMC6
         odTyePJRJY/CLQPMFsEqahtODGwFalZoV80QbjQkyxx/prfK1pvLqREobwOUYAxpo5DV
         vvmMm8FLwPFEkahdH9UyKYfDLF07wMftVkmXaqOqJqi/ZDw7pyVocp3um/qi5m+Z4S6I
         7fPf24sRn8cnJXx8ydvdDohwBTk7TaRQsTgRK2RWorIlq4BwWxTveQUB6eKs94UqF87D
         HirA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773346121; x=1773950921; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vI+2f0BK18gOdclBPROWIuuyekk+4frl3myDaAZuGkk=;
        b=eF/t88l8a+o1ZnssIAV6TmyFF0invcOMrPlZ6N10/mlfbEzghxSoREI3/3JBlxZP0Y
         FjL/3MG/cfmAEuekN7A6FdiplOOX2TZskke1qLnFgJw6aGMSU0y2oWVFIBCxmqttuU8U
         n9VL6t68ROEGKHu7erJMVhRu/tERrmjg/po1c3Ow6GTOawbdy+YbJBzdJCPk+oBEFOcT
         wkCkEe00R5/gxb7HyKhInh4LJMnTiOW+pA18uqQgU2lK9NxTbXkVs44WTnoS1bCo/T6R
         EegpKtLiwiDj2qvUxlzBcYLe2krfj0wsK0JDmUQZsFuzACvpzULxxMW5oDd0ayVE6g+O
         Q+0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773346121; x=1773950921;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vI+2f0BK18gOdclBPROWIuuyekk+4frl3myDaAZuGkk=;
        b=BtI27r3ne5ngxMJDYMeG8QANUpXlF0VB5vK/S1noIO2emhAKq7FsmS+oHd22CR2vmR
         F/tMUSUyxSMBVVWrc9AHwuVcs6sZllknF+7TjgeiIIzyaFTO43BPSKd/lxjP5MCbPaKx
         6BECcnGHBPcwT3Qdpo06qxDTJIdfFf+NenMS3pmi7HLda9EF+8FC4g/uvg4v97Kqof2s
         ad+2vPVe9nUssX0FzzxnYB90zpaseW1omaleebxNq6q/Toxj53Ml2N2xSY71P+S9lAFh
         huAQvep8c1Rqo0NDukEADZt16K+1aSx05tGMG0T8f1vSSl3TPUFZadeBmT5s/KWrh4Lz
         ayDQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYZOZR7+Bv2pv/vj8j276fXMCTOL6N37IgSatlXbDXoO9DO2g8BGSdlFGbAGlaGd+UUo+hikQGkQ==@kvack.org
X-Gm-Message-State: AOJu0YxTRSpqd3dvpyuHNvjDUGUMFs+1QikiDaz1zHI+4lR7l43pAliJ
	f6l+StyA8GasCJe3laZRILrUp1NdFs45Uf8bWQ7wg+gZ16ijl2fiy9NP8zCKrledmUXw6SU+sWp
	3ujKWeySAWpS8BKd0vDDs4XXbc/AmnjE=
X-Gm-Gg: ATEYQzznyKh2IgOFEOVbCnaysGfIYTXAcw8xWYAZMPvMpIs8M2ifYCxRQkni1DrFDQk
	HKe/DCs1cdMf1DMIMbzxRP0iln0X6i3wQEBP0KNA4WkVxzHXX2DaXCWTvyDcTtJW0w8auap0Es8
	TkW+GDlJx3y7hfGnoqzP8xvYsxV+YvyT3V3OjUG55numf6RXjbHiLQLv5VKFeZzj5O0mnBioLux
	fqhTdcEZvCBpOq34HRZf3IZBis11NeqoHqbDghFtl5LFmKzX8xvXJd54BJN6divL1WIk+6wR0c/
	j43iNg==
X-Received: by 2002:a05:620a:6cc2:b0:8cd:b4e8:5288 with SMTP id
 af79cd13be357-8cdb5a5a948mr144533485a.23.1773346120360; Thu, 12 Mar 2026
 13:08:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260311-b4-switch-mglru-v2-v2-0-080cb9321463@gmail.com>
 <20260311-b4-switch-mglru-v2-v2-1-080cb9321463@gmail.com> <CAGsJ_4xxXD68pHfsEf2=AygDDbp8+hEJm3KQL9WCPr6xfjtMng@mail.gmail.com>
 <CAGQVrL9AmqOeGa4Ovv6v-0qdy_+4MeupEeU_HQ=-YWm5wRV_ag@mail.gmail.com>
In-Reply-To: <CAGQVrL9AmqOeGa4Ovv6v-0qdy_+4MeupEeU_HQ=-YWm5wRV_ag@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 13 Mar 2026 04:08:29 +0800
X-Gm-Features: AaiRm50gJZ50RmmnBF6i8e_M0hLXKg_vyYw6XbMmx19yl-sbVO9fFyYsbEvgM2c
Message-ID: <CAGsJ_4zeEpdGmDLKb8Z1NP7q+o2uqvzb1-u1oXZ8SaqOw_CJkg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm/mglru: fix cgroup OOM during MGLRU state switching
To: Leno Hou <lenohou@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Jialing Wang <wjl.linux@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Kairui Song <ryncsn@gmail.com>, Bingfang Guo <bfguo@icloud.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9AA1A18000B
X-Rspamd-Server: rspam07
X-Stat-Signature: uyajtbmc3hzj55b8t999gwczh834xwrr
X-Rspam-User: 
X-HE-Tag: 1773346121-941207
X-HE-Meta: U2FsdGVkX1+Frhu6COwa9lc+8nayeZO3Oipv0FH9jXaVmV+xdupNUYveGirSXIEsuR3p4CDqevzwUsXzl+0V7J6ZNlgdG8fX5hgcJsY9ZqtiW9HdYxLSYJlqRpA2BdR0w3uMhhZsm+b6q+oRwKIaSj5ByBomu63hTbfN8AufPB0oGBIziwgLTlU05O1L1bWkAyiAMtbMe0Gzn4UZFFi3r/7DjqthdDdJEk4l7AvzMId+BYBOyKgvkJWJxfQaCS46JFiZwC7v1cganeedr155bVXYvpJ4gFQYJvWfKTNl+N2w1TxaBy7EHq7oc6uWdFmyrG2Mzo42IgFg9uFuenJwp1Ku1GdzbE0HOIylg8z/7ezaPsRWa4LD/AR6w/hl5mNWjP8yHNY42Y7nygQ2sLLQG8YcHdfg4zvqNAunpH+D8P0QW2QgoSPp174VEdRTzl+qUy/+V7tUMMJG5FLCyXRV/65DcSFh0few+AgXoTniEsBpXsR19UysHQBm8bdMEbkd/9Xfy99Z/YepzZVUeP9VSK/XTxsoKQULcxh0D6dSSS/xWhEnXEIYHJPm2wo6s04JO0o1/Y2+DQQ1cwq9cJviIaBu150kWve0BEET55Ul4K2mh4GJfGz/o8OV+oWG5WtfkUYrSmb6MMLu3p6pPMDfeD2YKd4RHDvePOJ7jZulhsBsl2WnPrOo/AFSXG1pnlkqs/h3zzUOFelOrUQKjBKx0XKIyBQ63MvJYScnnpMnSZKN8cjhHcG34qaGHJ9kAlrbsbnIk62w7bjDa01QjJiadxdziGeC1vLBN37EXd8qAAdKL+LMLF2l9dGipHaaUQTpc3luomY5M98S82I6e+h6KHAHAa1zGnDyX6efUffsjTVOmetsrkjTq5z7ttGz36sFvLf83LvFec5LH3b0IEb5vW0vCwWOsfMFzQWsY4kJttwQEMcdy+Z4vPkq2gFGKcn/jGbiJYA/ZFshi1/r+9c
 onqwn2D0
 fdmlpuCJdJNhnlgM6NBFRJEDgLSl+5e4euEZuTBluhyDhs0H2r+B8RK3eth4Hg2USfpORZ0nvOAXdQyxPBeor5DgY+U2I9JPTehRrjAHujPMM4aNFMdPlovGROLsr7AApTBq9oYB4kVuGU19hEjkFxeN0a6X5fmliAZkIxqmFwyghkZ3pzDek7A8KtVg9rFXXB1eo0to6qgFrn4MSPphURwQC4HIJj4vwKzkas5I8LR7A58f4TBlyf7kJEjgsnfMCw1JLbfjC4Wiu7rOA3IxDWztU7bewHmAWgplFBMS4SEMz5GU7PTQEdCZmfWMKS4fww5yJERow/Vx7XFup12HlmhHEVCNaBGaPlzAn2p2Os0RwnvBLI0rFODh2noJUBJ5oPh9yufP+YWxF2D0p5hyLt/iueelcC3xduB+WvsuvDwmSOwkZ3xwp8uvx7Kl1v976AhXjPFwLpMRmn4TE3cnD1YBBfXN88mVqw2u+qkJ7OVkRZ4JrKXoHnBEF34SlkPxp8Y+e4FspGOfTJMLZXuDVTz82pYL8eGNBngJyphtqQXzUlAxf3umqM/NAgeCraCaJ3MJWBwlabLD2cG4vGMXjgoSC6lZ09BWWnTbF3K5Qxjp3noFSJnPqXaBsiOnNkCaR2xgumB5bm6GIJn8gGOz1Uq7SNFs24IMAPiK22cXx+QP0boQiqMq/+epkAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 13, 2026 at 12:44=E2=80=AFAM Leno Hou <lenohou@gmail.com> wrote=
:
>
> On 3/12/26 2:02 PM, Barry Song wrote:
> [...]
> >> This effectively eliminates the race window that previously triggered =
OOMs
> >> under high memory pressure.
> >
> > I don't think this eliminates the race window, but it does reduce it.
> > There is nothing preventing the draining state from changing while
> > you are shrinking.
> >
> Hi Barry=EF=BC=8C
>
> You raise a valid point about the race window.
>
> While the window exists, I believe the impact is effectively mitigated by
> The reclaim retry mechanism: Even if the reclaimer makes a suboptimal pat=
h
>  decision due to the race,  the kernel's reclaim loop (in do_try_to_free_=
pages)
> provides multiple retries. If the first pass fails to reclaim  memory
> due to the
> race or an inconsistent state, the subsequent retry will observe the upda=
ted
> draining state and correctly direct the scan to the appropriate LRU lists=
.
>
> Anyway=EF=BC=8Cthanks correct me and i'll updating the commit message.

I=E2=80=99m fine with this race condition as long as it is clearly document=
ed
in the commit message.

>
> >>
> >> The issue was consistently reproduced on v6.1.157 and v6.18.3 using
> >> a high-pressure memory cgroup (v1) environment.
> >>
> >> To: Andrew Morton <akpm@linux-foundation.org>
> >> To: Axel Rasmussen <axelrasmussen@google.com>
> >> To: Yuanchu Xie <yuanchu@google.com>
> >> To: Wei Xu <weixugc@google.com>
> >> To: Barry Song <21cnbao@gmail.com>
> >> To: Jialing Wang <wjl.linux@gmail.com>
> >> To: Yafang Shao <laoar.shao@gmail.com>
> >> To: Yu Zhao <yuzhao@google.com>
> >> To: Kairui Song <ryncsn@gmail.com>
> >> To: Bingfang Guo <bfguo@icloud.com>
> >> Cc: linux-mm@kvack.org
> >> Cc: linux-kernel@vger.kernel.org
> >> Signed-off-by: Leno Hou <lenohou@gmail.com>
> >> ---
> >>   include/linux/mm_inline.h |  5 +++++
> >>   mm/rmap.c                 |  2 +-
> >>   mm/swap.c                 | 14 ++++++++------
> >>   mm/vmscan.c               | 49 +++++++++++++++++++++++++++++++++++++=
+---------
> >>   4 files changed, 54 insertions(+), 16 deletions(-)
> >>
> >> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> >> index fa2d6ba811b5..e6443e22bf67 100644
> >> --- a/include/linux/mm_inline.h
> >> +++ b/include/linux/mm_inline.h
> >> @@ -321,6 +321,11 @@ static inline bool lru_gen_in_fault(void)
> >>          return false;
> >>   }
> >>
> >> +static inline int folio_lru_gen(const struct folio *folio)
> >> +{
> >> +       return -1;
> >> +}
> >> +
> >>   static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct f=
olio *folio, bool reclaiming)
> >>   {
> >>          return false;
> >> diff --git a/mm/rmap.c b/mm/rmap.c
> >> index 0f00570d1b9e..488bcdca65ed 100644
> >> --- a/mm/rmap.c
> >> +++ b/mm/rmap.c
> >> @@ -958,7 +958,7 @@ static bool folio_referenced_one(struct folio *fol=
io,
> >>                          return false;
> >>                  }
> >>
> >> -               if (lru_gen_enabled() && pvmw.pte) {
> >> +               if ((folio_lru_gen(folio) !=3D -1) && pvmw.pte) {
> >
> > I am not quite sure if a folio's gen is set to -1 when it is isolated
> > from MGLRU for reclamation. If so, I don't think this would work.
> >
>
> Thanks for your feedback. You are absolutely right=E2=80=94relying solely=
 on
> folio_lru_gen(folio) !=3D -1 is insufficient because the generation tag
> is cleared during isolation in lru_gen_del_folio().
>
> In the current implementation, once a page is isolated, its generation
> information is lost, causing the logic to fall back to the traditional LR=
U
> path prematurely.
>
> To address this, I am changing the logic to:
> ```c
> @@ -966,7 +966,7 @@ static bool folio_referenced_one(struct folio *folio,
>                         nr =3D folio_pte_batch(folio, pvmw.pte, pteval, m=
ax_nr);
>                 }
>
> -               if (lru_gen_enabled() && pvmw.pte) {
> +               if (lru_gen_enabled() && !lru_gen_draining() && pvmw.pte)=
 {
>                         if (lru_gen_look_around(&pvmw, nr))
>                                 referenced++;
>                 } else if (pvmw.pte) {
> ```
> The rationale is that lru_gen_look_around() is an MGLRU-specific optimiza=
tion
> that promotes pages based on generation aging. During the draining
> transition, we should strictly rely on traditional RMAP-based reference
> auditing to ensure that pages are correctly migrated to traditional LRU
> lists without being spuriously promoted by MGLRU logic. This avoids
> mixing MGLRU's generation-based promotion with traditional LRU's 'active'
> status, preventing potential reclaim state inconsistencies during the
> transition period."

Right, using folio_lru_gen(folio) !=3D -1 is dangerous because it
implicitly depends on whether the folio is still on the LRU list.
Even if we never switch between MGLRU and the active/inactive LRU,
the check can become invalid once the folio is removed from the LRU
for various reasons=E2=80=94for example, during isolate_folio().

So if possible, we should identify the real issue that led us to rely
on folio_lru_gen(folio) !=3D -1 in the first place, and avoid inventing
this kind of unstable condition check.

Please DO NOT depend on folio_lru_gen(folio) !=3D -1. If it is
unavoidable, limit its use to the smallest scope possible.

Thanks
Barry

