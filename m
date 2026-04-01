Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C95C10F9310
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 00:21:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81CC76B008C; Tue, 31 Mar 2026 20:21:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CE7E6B0095; Tue, 31 Mar 2026 20:21:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70BB66B0096; Tue, 31 Mar 2026 20:21:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 60B346B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:21:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08A7EC47EE
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 00:21:37 +0000 (UTC)
X-FDA: 84608083434.03.C774B12
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 34E2A8000F
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 00:21:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ETHqZQyq;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775002895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sOb68kJvcUacLOxXSrfTRsz72cBNPTiVtwop89pvIo8=;
	b=x9cyAffAzkcnpktUxD7peaehowtpMjp+fKkxU1L62fhNmbe0w18BefnvVrMsOSfMEgxfUl
	zj+1YuX+MLed6tmplxw54FOlvxSTZgEXHZmYcLKCMB9CvbuLgu0ukRJX7ekrOGbGYp17iU
	/SDgNxlBcomdBnV5/lW+MKq5Ke9jzZk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ETHqZQyq;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775002895; a=rsa-sha256;
	cv=none;
	b=u3jVS3IUMR4tRAs7tAqY1XgMNUQvtBIr4qm2w1mVvoH1DDSeCWUXm7bt8OLS7YIZVZB+oJ
	4qKfklUQEI839oQcNA9ZeZX/YC/UK5/iKuJOI0c/No7JjSf25k6Xw5tpps5ZqwBgmTzsA1
	MEHZa/SWmcWRu4JCUHKaFtEvCJyPsXQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 45A1F60121
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 00:21:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E0BC2BCB7
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 00:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775002893;
	bh=HWg9XttP7+4RO3nXmvQxZ9d12CkwvE7Wu6+PmR+eG/k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ETHqZQyqSjS2mJpKzx+qMYSa5MZOMMinH0wNrRGPQ2mamMMdB5Kx6REB5cPYc+TbR
	 pT5B+h6FeXJk6rD7Y6TqL4BaPXg8ZzXJ5P6zbhjtsVwcrF7wSni5SyMrHYxpiU0ZT0
	 wj5JlVzQkfcPLG1BHh5WGVcePJgeSNGOuNU43dIvSsnBI3E443Mswg5ALWyb+WyqnB
	 GuLkSt97lTnRAWVC2hgFPS2UsuyYM+c2ClESphZ55GBdg3Y9YOkmP47PA+vuya2JLJ
	 oCW4ruWBFmfRDXRvqDwFSUtMms5JQWWjyI6Q9N1GLSm3RdGHUPoRfJt7M5BH2YCLKf
	 h9lKuY5S2coXA==
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8a3970f1a0eso13142436d6.2
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 17:21:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXPC3WeuosVOPzc6njhlZvpJx9vjdPGUhrkZcP0/y3G9bSrhmeisUe8wPEm7QJCzJ7++gbe6BbqEg==@kvack.org
X-Gm-Message-State: AOJu0YzBjdmI1sXA3wkR68BKT3p067VFI88oPYlsSo0VIOVP9WChkkyJ
	DFquAHQ6U8XDVVEh+ZbS1Q3zarl8rqGbqQpUIq1QhTmxGMBJZI+AyQr4d2KGQVoDSWiEvP23r92
	aeYzMOoBWBdax7e8+U2Kxw/9rOQIXlgM=
X-Received: by 2002:a05:6214:434a:b0:89c:8687:5947 with SMTP id
 6a1803df08f44-8a43a270908mr24053566d6.37.1775002893109; Tue, 31 Mar 2026
 17:21:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
 <20260329-mglru-reclaim-v2-3-b53a3678513c@tencent.com> <8150afe4-53ee-49ff-adfc-e29a483fd1f7@linux.alibaba.com>
In-Reply-To: <8150afe4-53ee-49ff-adfc-e29a483fd1f7@linux.alibaba.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 1 Apr 2026 08:20:49 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y1GsHAYr4XOkGJ0L6SiNDatheNdYdsouuurW4bSPsauA@mail.gmail.com>
X-Gm-Features: AQROBzBWZx-g8YyZ4AeuGEhPuMgSJS0hZKfgc5d2rm2B_4Axss72OH5heNU1kks
Message-ID: <CAGsJ_4y1GsHAYr4XOkGJ0L6SiNDatheNdYdsouuurW4bSPsauA@mail.gmail.com>
Subject: Re: [PATCH v2 03/12] mm/mglru: relocate the LRU scan batch limit to callers
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, David Stevens <stevensd@google.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
	Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 34E2A8000F
X-Stat-Signature: roa9xpmdecath9cpcnzwx4x3q33wk7xn
X-Rspam-User: 
X-HE-Tag: 1775002895-675911
X-HE-Meta: U2FsdGVkX19+45sHOVhKM0chcBNdYcvLQ1lbSyl9KccxwmstTBQ7yijQizArVkPN/ORUJ+PUICkQb/aJcYgWFNF/R0Qc5MvnKfwlvZgHTXcQSLiWPQcDhG4q5u+maDkY8Nq+NkIMX0li0EPJgnFCj6La2TV3XWlTVCbW1F4ywUKlRsr0yCQpPQ4zug0d58Nv6IXaT3d5DSOTUtpmRu6peXqO4+AcuoS5O96e2piLGMKusRpWq67X0d1qqrB/xMlEPfZDNbI6H8Jmh/EY6zc4lhSB4FaDR9yJYyDQy+wIdoY1btrIJSZtqmQqYtyiTkbeFKtR6WsXt6uos58grKNM4hYo+roeJ7Q6mF109aQAoFKUJpQRB19j+LRWZZ4MmsbybXs14g1LRfCG0NU02kmITXp0fyGlB1LUWnc/qcM+1WnCcY+T7TyOA0KPhLfq/YBtsOmcqIIVHpp1WmCyV56Ud1A9oYWx+b5IOuWovJLta9fvegMINF76ML5exwcBzqwgwS7Yi+QySga3KmYxbs1MllKgXs6YZCRZPOwnQRDYXjsERRP6H7PdB0yhn3t3m5htVYDiUQPQzgrkaMnVe6CFB3UtrzkZsMiu76eV0FF49kM7QjafyTVgk5YtMClEXg/TbfsHJx+/4q5TeoXqRXht9QOp8ugGYN9khD706CXh+0mUJA/49dSzbR7XiEWdCmVDn08u2ZNl4Cjcq0qEn70E9a3QG60Vz/JoL7PIZ4eR6PXteGBKfOmo64dODwrNLDwXrVXG9tU9gWyeQLRkNw95Ui4dS+o6pKzxMAgPcKoe5T+5m/mFbOgWNM5+SWG1MTpkWZiiXLBscLCzOI9NZDngY0qIY6Ni+mvGu1SA/Ir5BePsKVv7q8B0Zkx5p53CIycU04m7VrYiaqPdt2gl2wXkqQ0Q+dKvlivFqlD/g931OI1OVoPfPxzLJh0rBoW9ZJbRhKjIW5siEkJq09OH2gp
 6lActf3w
 xTXbuJ/05Ki6PiNLfbY5Ey7StzOklvv91Babay7qnnpESKj6Q7vkdJaUqW7c5xwCMfH8E1LROFZ3GndyU/2IVObsBLZrs+3KrgudiZDw3FJgrvI2PFxsb1V6jffpY9cW/pgEp1FWr6va3/dAIh9sG8UyFhwqEnzySSzftEQLiSRmCjmxnrFYQkIQra2wmat6C2pMRgMOIjziVxjWncFR1UAia8jiLlZ0OI9zjvQg5f2WCPRf2KeUgevz90t7i0PemY5vOLJbHT/ZrH6VHgE98JuBDHLByzvloM+Nsm+wUqf8ey6i4+sBYSce0yGtZRYkG/Yvnyb9JugysudyK3bmwwVnAcK7f/HRhZWwxvIJZc4yujCCDg4MDRHRuYcQ+XGI0P+N3FK0jmSW1M9ON4NDf2sJlkQeGQJV0V0q10I13F8WJgzc5fyxFtCy7VdPhJ7hvowkv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 4:15=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 3/29/26 3:52 AM, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > Same as active / inactive LRU, MGLRU isolates and scans folios in
> > batches.  The batch split is done hidden deep in the helper, which
> > makes the code harder to follow.  The helper's arguments are also
> > confusing since callers usually request more folios than the batch
> > size, so the helper almost never processes the full requested amount.
> >
> > Move the batch splitting into the top loop to make it cleaner, there
> > should be no behavior change.
> >
> > Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
>
> Some nits as follows, otherwise LGTM.
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

With the same nits addressed,

Reviewed-by: Barry Song <baohua@kernel.org>

>
> >   mm/vmscan.c | 16 +++++++++-------
> >   1 file changed, 9 insertions(+), 7 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index f336f89a2de6..963362523782 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4695,10 +4695,10 @@ static int scan_folios(unsigned long nr_to_scan=
, struct lruvec *lruvec,
> >       int scanned =3D 0;
> >       int isolated =3D 0;
> >       int skipped =3D 0;
> > -     int scan_batch =3D min(nr_to_scan, MAX_LRU_BATCH);
> > -     int remaining =3D scan_batch;
> > +     unsigned long remaining =3D nr_to_scan;
> >       struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> >
> > +     VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
> >       VM_WARN_ON_ONCE(!list_empty(list));
> >
> >       if (get_nr_gens(lruvec, type) =3D=3D MIN_NR_GENS)
> > @@ -4751,7 +4751,7 @@ static int scan_folios(unsigned long nr_to_scan, =
struct lruvec *lruvec,
> >       mod_lruvec_state(lruvec, item, isolated);
> >       mod_lruvec_state(lruvec, PGREFILL, sorted);
> >       mod_lruvec_state(lruvec, PGSCAN_ANON + type, isolated);
> > -     trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, scan_batc=
h,
> > +     trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_sca=
n,
> >                               scanned, skipped, isolated,
> >                               type ? LRU_INACTIVE_FILE : LRU_INACTIVE_A=
NON);
> >       if (type =3D=3D LRU_GEN_FILE)
> > @@ -4987,7 +4987,7 @@ static bool should_abort_scan(struct lruvec *lruv=
ec, struct scan_control *sc)
> >
> >   static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_c=
ontrol *sc)
> >   {
> > -     long nr_to_scan;
> > +     long nr_batch, nr_to_scan;
>
> Nit: Since evict_folios() expects an unsgined long, why not define
> 'unsigned long nr_batch'?

I guess the confusion comes from nr_to_scan being a long
rather than an unsigned long. This is the only place where
nr_to_scan is defined as a long.

I think we should clean up get_nr_to_scan(). Right now, it
clearly returns more than it should, uses -1 to indicate
something else, and also calls try_to_inc_max_seq(), which
is not part of nr_to_scan.

That might be better addressed in a separate patch.

Thanks
Barry

