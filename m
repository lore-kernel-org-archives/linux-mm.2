Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65642C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 08:04:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 305696B00A5; Tue,  7 Jul 2026 04:04:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DDD16B00A6; Tue,  7 Jul 2026 04:04:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C0D76B00A7; Tue,  7 Jul 2026 04:04:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD4366B00A5
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:04:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 415CA8D266
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:04:28 +0000 (UTC)
X-FDA: 84961243416.12.AC97571
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf09.hostedemail.com (Postfix) with ESMTP id 51D76140005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:04:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HN5W3c7i;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of richardycc@google.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=richardycc@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783411466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jcshjXzmTNix66Rnsp83Q9/O2EduZ4DDKI5sE+8Z5ZQ=;
	b=Btm57j7rZk69lihNloMFA1mhz9RhaJbzxRgTaKucWiztFJ1GX3CgZ4PuUWnzTfw9N+Htgr
	Q6uv0JOV3MmgWEJxCEwPvX/jVPy0csP5MU+EIAMCm6r9okjuHAzCnK/uTA81+beGxk08IE
	SnmEFNqqLnfsKEAoKfAO56Qo1tdr4Bg=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HN5W3c7i;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of richardycc@google.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=richardycc@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783411466;
	b=slaI0LXBRHRB3Pa3pscTMW5hQK1OBy4AczUbB1W6fE5cWdhYpF+BcT7BcUY7mLGEq2gC5A
	lAxZJ8zA4ev/mxIyzYfcuo/PKqtIPtZijDtiaMSU7QLOj3qEhhMvAucNcZsqem4xcIDKtb
	fb0kp+t5agVwgUebMBokOIX1DQU/LOY=
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5b0077d7053so2296e87.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 01:04:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783411465; cv=none;
        d=google.com; s=arc-20260327;
        b=UOm5Q9Nk+4+vCPVmIbJ35mTu1BL05vdwVWLZkg25slsclfql/VlRS2OYfycZhtmWhs
         rTEisxN3NxPIXgbD9/+61NMScdSQR/R5OROuxPiDedS2AyDH9JTzIHh5QoLouJuNoW3E
         //nY4RkrqhnflcgGXSxV/B3eTOQyNsq/OxKSDhfAema+Ufx9LOWIZBbPr9Ir/qkj3F/D
         CnedodMk8vXbr6r+PHLv9mi7+4xBF8qle/oW550NzlQtGn4Wr0awdhruZUQVn9r1uKIV
         bKQxdYTxT2PlM96n9q/v+iN1WjSP7zZ4Iyq8J/BnQlpNa1g7KrJCG8Ff1v4FCKfoNRsz
         od5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jcshjXzmTNix66Rnsp83Q9/O2EduZ4DDKI5sE+8Z5ZQ=;
        fh=oBkG4/SgeH9uWf15kF90HQEdJc8ZTBzVTz24DgjOxok=;
        b=Gn7SI4ZTF0ugR2qJF1wrGUxcZsnlzHS06l1NAoYo6D3FNZWpFFyiZPOijOgeOmyiu7
         pJ14kSDxBCbFs+OToVZc/ZFIhfQTkhrflQoTnZ95Ji9+C+Y0SQTUKVc00GhdWAcdFs4Z
         5wcPfJs4rL0F1RfjI7wObx5rpanzSnwZl1lBvsAQPZC9qjL3ll1taMgqk+UisoTat+5k
         +rXtV4qDlR+F5iCtKbErx/DD5Ge5esGM2b6+/nlBD4nn5cWn7wnZy35rNjp+m8VVQ2gq
         G4Y/g9cyHRQD4rgceNViqtUi35Ej35rajBGaYVQskWo+RquNz2BUQkBk4l0wYyYx0OxQ
         uU+g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783411465; x=1784016265; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jcshjXzmTNix66Rnsp83Q9/O2EduZ4DDKI5sE+8Z5ZQ=;
        b=HN5W3c7iXx+4AeLqgPDHVeT6pbH2QRBRIER83g/VyRdQuqnfr3DXl5jI+TBxjs8e90
         Wwg4T70pimF870UT2ITxWmauEz+YAHsF9oeX/u9QIOB32vX2PecBb5hcMvyMVbmC3U1z
         LjaLJFjbsoCfrdFf++lhwNs3A77wLVIiSJiWhqGDKw9dJAF6oXI2qKg5vCCPXspHT0Hc
         9jKOJYubiBRqOexFmSRmc3V+8AwJP5r4i/Lot7Mun39RH+Mc82Vj3OrOU9jjw1E/XZY3
         QONB/p8UYCiCcLI/ASALW2HjEmGRgh+PdRk5qJg2Hf8Zw9FDTnlkFnSr5UbEPN6F6D0Z
         actA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783411465; x=1784016265;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jcshjXzmTNix66Rnsp83Q9/O2EduZ4DDKI5sE+8Z5ZQ=;
        b=VW+HFaSVCGo6VZmF8O7SJ2a1WemEjAhXZfuwo3tXqFxAb1h7sLAa0Py4EyIQVFopK5
         HZp8CnQ7pkO+DJJu7FZBOop8DQJIwSwSOa04rqmA99NX9DJH9FiUYhUbjkpSRtGnPZOn
         8+q3l3GJqqiHNWrGlY+Hyb7Ma86uvR/sMjElPPzge7XM19YsWNSMTT/r50hVBixN9GAU
         aa+WPl1+YoYH6Gu+nvfXq+RuXzN0v2crWC9FpTuaL5OaCQgHv28g9V+4MWTPjgRnLgen
         +EDT8YJbA5oeqvudq1aEyh3oxC/l238n4ASKOW0BI0nLIYrkeCEyFa8XiDl+9NLvYsts
         MyEg==
X-Forwarded-Encrypted: i=1; AHgh+Rqi9QCU7mLX82TzFRfpLLgfsGE+EfQ06bp2R3VPaw7ejS0hCoV/SKvJuWpysO1luM9Fv0NUqdfXkw==@kvack.org
X-Gm-Message-State: AOJu0YxAJz1Qhqp9PRIxb5+1shgeF13+lXJCaNrGzBexp+bx/IAhH9q+
	cIjFK2o0X4gWn0vD1/IdWIm4k0ane8qWuzZ5JfbV+KrWZ9HfTS2D3SKRRIiPiwsv3qN6KPe5OzW
	hVdMJKSKCqJBTiiYAL9qmavPrAoEB4T6jxKTvaHU=
X-Gm-Gg: AfdE7cntbi3y4n89LY35PNiqorw47f+tXjIosuVzkeP7D0YwgjveO457DYt20vWX78m
	U1DUqUZwC0BGtnns7S6iSEKhN2SxXMvU37l/WTtl9yv00g4sijMa0+MC19H2jca+qjarrJDR65n
	/ZZ1ubujc8w54Bvh3jpM5ViXBi4px5vkm21AJKZl5ou1vcbv3aHpf0HXwtofLuOZG3Ev3Me8396
	xuFLt59GBOqDJ05dEzkFuQ6+7WN+i9XU1FepBsIsKgZAc8YDs6iSk4hFPsoBckP8m9ifNQ=
X-Received: by 2002:a05:6512:3da8:b0:5ae:bfe1:737b with SMTP id
 2adb3069b0e04-5b00ad0be3emr127447e87.10.1783411462118; Tue, 07 Jul 2026
 01:04:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260706081218.3438762-1-richardycc@google.com> <akxiZryteM-mwlyz@google.com>
In-Reply-To: <akxiZryteM-mwlyz@google.com>
From: Richard Chang <richardycc@google.com>
Date: Tue, 7 Jul 2026 16:04:10 +0800
X-Gm-Features: AVVi8CcT4APE5Lopda5ALe3CUB6--NPm8zfKmFrx4h6gT_quiOILmNB52Mig3aI
Message-ID: <CALC_0q-9JEbSH8dc0ecMzZU34rjVKzqaFYuoqjP2x8cE3UDo7A@mail.gmail.com>
Subject: Re: [PATCH] mm: vmscan: abort proactive reclaim early when freezing
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	"T . J . Mercier" <tjmercier@google.com>, Martin Liu <liumartin@google.com>, 
	Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: oe7zyuo5bpwk6j4xjazf7pb8mqzhj1aw
X-Rspamd-Queue-Id: 51D76140005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783411466-85529
X-HE-Meta: U2FsdGVkX19IxEOJyr4el3iuu5FbVX+V8o0+XLWmeiKWwnwIzks7TvHF50XjV72JtRNX5eC2iD84SCV2gO+vpV4rg98nqFKgVLm0IM+8k1ow31mqg6uRsqZajNp+ZOc7D/NvHonOaK6Rg+WIvQkgnJ1QOQxE6vjOwgqdAf9Pp43SuQeEZiHnT8hgPeXUw3YO8Lto8YiNrG1QCIqU/DQShd0fbYqvxQYquQ6jWjqAAkN14210RpovfvMpaAuNLVnrMn14zUYNraegIBOU+tgufAmotM6Ep4xSarrgDQmc5N2VVGx+KAZu1qadmihlkev6JY/1o8eYym7blrZVqvplDQ8WXxdRm7PN5gAhXTF/BWvcnGP3NM7J2FgaBMj2yuSt/5MeStmS6y6UIHGYfITDO8+cYkvdPiF5/KdGsF0EY/HxbzRhejVVdlRyvwJw4a7mrt8jwqofftWmrJEunJ5BgN+0Q84dOSaLy5Dlq/Y/OYrdqrqdBoaWjsBvspdcNFmfYfsKHZzaACTHnFDimFkOiC9sFpZ3dqLDtbY0+9GR3h7rS9/Lp/9HkSjAH6yxoJ7bcopErrqS6bCJjxYuskNaue1rZwQ2mqslF6w3l8HnCnFJs5Pk75vEl7Uay4jLzfntxdcd1EKuJt6DRW+g9fbHD2k7v3CHe8m/4xqPsg40zjMIFxOaim8/ULozf9C2RHU+JPcvjNZ0zbnz1XtqafFfW7/XmuhdEzMbLiBTsDGF02hdFiXwwgBFcmENKkLKBVi//uaVzaviH1TFRVsm7DuoHDUHTdZo4+6dZoTxWM3Z0ADj1nOCk9oIzP5hAsj6hWCbW3nP8BXtSqQAyN/wTP5DSVwZ3Nwmg+fqNKoCbhxt5YaqNoDKW2ue6WdDP02fSlFKUtofutQ1wr7ud8olZO/qCSTDEohZItNFVYTFQ0/5XpZwAgVuSdX/LP2PAZey08eBE0LOpYNIx81W49M4nge
 SJ7CTZlr
 JCeY9ZRwsvgNuzHDoQpyQrg/4wgmtZLrXKrC7wokvYQtDGdgAVEIdb1v9WBPvN7+R4/iimQ5nEAC9L9nS2tiH9/LDqFEBaaeEDey2jx0Yn4D5PLVRg4SeSttuMHOaJmar+lc5bjxWrgcdUBIANeiiPPuGVI5xTtV/I5C7KnnVoZLW3urBk9O/JLkE95FNZZl7xoVs3K6eK2gSFtZa3R4lCSWK3/Q5qXNzxPsBuFNOp3t4zuKTVtJZjl9Jb9Po0Rz/WyuAZgHewbgNy6hzr4WVArn6oKAp/VpJw51E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yosry,

I believe we still need the outer loop check. Otherwise, we will waste
CPU cycles entering the inner loop only to bail out.

On Tue, Jul 7, 2026 at 10:20=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Mon, Jul 06, 2026 at 08:12:18AM +0000, Richard Chang wrote:
> > Proactive reclaim (via memory.reclaim or node reclaim) checks for pendi=
ng
> > signals in its outer loop in user_proactive_reclaim(). However, the inn=
er
> > reclaim loops=E2=80=94scanning cgroups in shrink_many() and evicting fo=
lios in
> > try_to_shrink_lruvec() can run for a long time before returning to the
> > outer loop, especially on systems with many cgroups or large memory siz=
es.
> >
> > This latency in responding to signals can block the freezer (both cgrou=
p
> > freezer and system suspend), leading to freezer timeouts. This issue wa=
s
> > specifically observed on Android when attempting to freeze background
> > cgroups while proactive reclaim was active.
> >
> > Add a signal_pending() check to should_abort_scan() for proactive recla=
im
> > paths. Since should_abort_scan() is called within the inner scanning an=
d
> > eviction loops, this allows proactive reclaim to abort early and return=
 to
> > the outer loop, ensuring the task can enter the refrigerator in a timel=
y
> > manner.
>
> Do we still need the check in the outer loop?
>
> >
> > This check is limited to proactive reclaim (sc->proactive) to avoid
> > affecting reactive reclaim paths, and wrapped in unlikely() as it is a
> > slow path.
> >
> > Signed-off-by: Richard Chang <richardycc@google.com>
> > ---
> >  mm/vmscan.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 35c3bb15ae96..fb472e924fc7 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4929,6 +4929,9 @@ static bool should_abort_scan(struct lruvec *lruv=
ec, struct scan_control *sc)
> >       int i;
> >       enum zone_watermarks mark;
> >
> > +     if (unlikely(sc->proactive && signal_pending(current)))
> > +             return true;
> > +
> >       if (sc->nr_reclaimed >=3D max(sc->nr_to_reclaim, compact_gap(sc->=
order)))
> >               return true;
> >
> > --
> > 2.55.0.rc2.803.g1fd1e6609c-goog
> >
> >

