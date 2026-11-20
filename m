Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E60AE606A32C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 09:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RgLtLHwI
Received: by kanga.kvack.org (Postfix)
	id 126FC6B05B5; Fri, 20 Nov 2026 04:36:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D84B6B05B8; Fri, 20 Nov 2026 04:36:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F07F26B05B9; Fri, 20 Nov 2026 04:36:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE7276B05B5
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:36:16 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D56F140DEB
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:36:16 +0000 (UTC)
X-FDA: 85454991552.26.6EF46A0
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5D60BA000B
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:36:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=RgLtLHwI;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795167374;
	b=m3dE49ORK7UCyeJpJ34d6lnE30dW/TRZh1vuEN2C6DIASFrHcy+yVdF9vcEqqfxjX18um6
	SrTBe+XXbIbKMIyk/+KaxzwDwuQqF6Xyc5FXKyWK6Wt3kyrz+S6328OGLrl1Aorq02O/iF
	Ns+afKUgphZFriIbKpah7pWvUOIwRpI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795167374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wSiOMe0tD0Y2SxFczJlUDeasF0l1x/LWEx9aDUyyir8=;
	b=7SGj77yiEbApvqgAYEunfghlqrzvlg6LhBXx6DUG9ZSUO1PQjkj0+93k29SNd+MpzzTNAE
	3bg3TbWgq2KxeCVP08m+SKVohA0/yJaXQjCTYYetqnzSpSZVcWsOWmdnRr8e1nlZQR+qFt
	QPV+yK3eSN4SY/iHLO7eRatQIVC1j9s=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=RgLtLHwI;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c5133831027so101558166b.2
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:36:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795167373; cv=none;
        d=google.com; s=arc-20260327;
        b=RwOOjsmNwEhjIhippDo4vTMt0a87JDnV2xOYXNAtx7juNHlU6RXScQxZb51BPYvRcI
         +HiUShUDmqkkNeTZLhTuJ9e0kqxih7tJREhq1YjBAWEacfAPXxdPyTvGLvFqwqCSqzF5
         TAYjfw1YoY82ZGXDKgCCbbXSsqq0/qua9EsEs7UYobpDlmdNrk7DL24reknhWTON02ed
         EMtEngTeEZ4vZrO2MbUb+lbKhSVA199DNNxpJ58EGeQF5UVplOB2qyGGMhoHfg1aGABu
         3a9fFQMjjOI3aaQRKJgsetw7IaN6F//9gxdH0TfkuQjYUeOneOthAidsRMXCloMIxlpj
         /m1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wSiOMe0tD0Y2SxFczJlUDeasF0l1x/LWEx9aDUyyir8=;
        fh=T8CZMS7v8hqzytLXYnmzITZSwL7GsHFkUt82dnSnzkQ=;
        b=WyA2eejxkcIn6udoNxCFVAdsDPck2QFFK+1Qgin0En9jfP3ysR9TZNNhx6wntlDFvs
         LWPbGLXjQr8n6IsXOMaczV9j+PTfWwfqY70GeoXswn2beDNIy8C2XQJYGMQtBmQjSoh2
         zuLXcGwOy1azEpGmjU8YymjFyhGg2tXyggxfnouk0iPdi97DM2aaZmFE/CCq5LNfgQ0Q
         tfXzGfFQjrI+uxYJcz5hnMeK9BxC6oz1xa3e/MqMwFn8OESO+fy3acyzSwRXoKY07Xqv
         LiKalbrhK7WsoT8vvTtDJxfm30NOqNbj/6EUkyFNd5SH++Wxgg/gQ08LVNxT7YA1RPJb
         C+Gg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795167373; x=1795772173; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wSiOMe0tD0Y2SxFczJlUDeasF0l1x/LWEx9aDUyyir8=;
        b=RgLtLHwIt6GEjey4N3LDMLxqFopMKwWLoEAg2NkIGARzKywWWy+Vs4PhPNjlFOs4tG
         B+nR0g1bWyv98YwGSMytu7gq+YM1c8dROzmGE7pEGm5cyJuSRBWsQCdlxNXv/QiDfxfj
         STFtcoF6H/4T/RSlgZFQ3aNB0Mc90gJ1V1MtvjpHM2UF2D4DpvIsZ+2y9iyq+3gqbR0G
         dR0aWX8+Wv111DTeqWfveFLAzkqwYtRG5kuGhkgVJOioEfHqLcDRWFojaPQhZHWR/Aj8
         U4oAqutgiyGzxKXvLkWTApm1UhZEBZeHcTuM7BBJJ3CaqO5SsH0SbTG+pj+cycAFEKjk
         xCWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795167373; x=1795772173;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wSiOMe0tD0Y2SxFczJlUDeasF0l1x/LWEx9aDUyyir8=;
        b=sPRvGmCNRY74CT5s0AnidHzv1zKcLJZwvzbKlVfkoCnf6LcBW9yDWWb8IobeXbPcLH
         ExQBHFI0Fh9BrZUbE8MraRUmARr+IkzXzfJX3qsvc/U0iJ6aezRY6yFAZ2tH61z/Fop6
         f1Bkjp/gapazFzGNoBRkzzzaZ5g3peHTpjc2XzeEKAJan8mt2oPOa0Idqp+DsrQLoiFB
         kIeaH6GQySga5DbDtm8O4YS1d+mEkde5CFkniXGYyslbTDic0WouwgMgNi1If5tr8z8H
         VbFXrDCMPZsIvlO9IJUwhsYoxu70oRFNbpNHumlX9BlGl5jHCCVHrm9PBPypfe8ZclAG
         SSUQ==
X-Gm-Message-State: APuU4Z/SZwyA/93GP6Pm46BdjNUrg6P5+uxb0YEPa3o8yY2jqiLgmEGm
	WFwpOic5JkM3VvbnHA2v7V2wrjizRx5ARpGPZTOk5wtetAucapInCNWaXWRnSYhr9e6KfKkDN0Y
	19gFQ/Pve2vlI5BiXLwXczaWngf9xrQQ=
X-Gm-Gg: AYBFou0SErr/3O2YyuudJrKIrmLLE/6GR4V3DzBnt6eS0WyaKv8M1uuTGXiwUTLdaFi
	Et3GKFWq01PsCxPXOid1OtaNu4luK2W6+u8FG7dzTLq2g5hTDQ8ldkRDW9vjkg9D00te26DkDyO
	qqVJ9eIB8Ey/K3Rp98zMZ3dlU/xVP5ho8usfOMG/2Ndq2aU6BnfhR+MqbBOu3ImRFwlkXXdOnwN
	/CwlBEYN5iucjIjtb96QNSElkpV0dEfgr5ThzgyplAeK5XnB8K36DgXIdtE67WYnP2kZW+EHvx5
	6ZQ6XQVlf4kOQI5hD3JZc/po/+SLwFy6A1vLwzxpedHo6Oi4ezd5zvJ+ji1SVFWVXtXRGN478yA
	dcr9lshCTBhahtTQavT3Fc2dvF6ksPQf+S45dTcxCldb4odQWzBHwhs8=
X-Received: by 2002:a17:907:6c17:b0:c51:3cb6:5b11 with SMTP id
 a640c23a62f3a-c513cb65d73mr206830066b.49.1795167372628; Fri, 20 Nov 2026
 01:36:12 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
 <20261119-mglru-fg-v5-6-9eee2fe97a2d@tencent.com> <CAN_Opa_jb1pN=-Z+4WRoXVDSe0YfppeY319iagMdQoMgtOQSSg@mail.gmail.com>
In-Reply-To: <CAN_Opa_jb1pN=-Z+4WRoXVDSe0YfppeY319iagMdQoMgtOQSSg@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 20 Nov 2026 17:35:35 +0800
X-Gm-Features: Aa3M54pbohOCQbswSkwv-YDHDqEuETdr2HZyOy_eh_9wY3LvfDu8zJdBWDbyUx8
Message-ID: <CAMgjq7DbK8sc7-0CTOj5iZBmkLmG7ggj75mdTxVkunGzmi=NWQ@mail.gmail.com>
Subject: Re: [PATCH v5 06/17] mm/mglru: frequency guided workingset promotion (MGLRU-FG)
To: KunWu Chan <kunwu.chan@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5D60BA000B
X-Stat-Signature: yba364g64w978aw7u8umbkktc7azdop6
X-Rspam-User:
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam08
X-HE-Tag: 1795167374-789836
X-HE-Meta: U2FsdGVkX1+kAtoa9E5ihY+4zwPapycLbJTOUKPOdkBOK3z2eqLRjdqw9Tni2+pWhmlA0955c1/J0c9mX37nw4ZZUshNtQDFB0NH3LUY3R1diXc4NO0XbTFFZXqOf3bI+3H7dCB9EtaxCPA1yIjopoeNIU61mKw01vmUm/sKGVWZkAFhK5wIR2njY0/cbw1P4ttUlec3sUMblWIX8euSLdo+BWIQsQRXWtx+KxGBAsJfLCTNsl5eepRLmkVvgC7rkYGD614A1d3ddKK8uGageANfZSsrS1C/683SSgHmo81TBRgkbsyrLuLNanHHm0Pvm9HoUmh/FFxIOF9U6Ddv0XJq+vjQGuraFxm+/d42xdfkwky2lLOgkedgx07ekSsPJpQySwIBvGYfmJ3vIXiLqVhq9cYAMJ+qmtm1SyI+cb1osSL7AapPPE5WkfMpYU0tV47vaOgIFV2DTdQgJIGf8LY2H+r247hYeaz7Cnb7QZAwifmHNYDwyHHmGpQgCqW17oIGF6sl5Toyaf6/JIOR59WxBYWt6t1BMkiB8HMj7I5/0vXQ4Z3iZPM1u0JOPUpqMiUl3zwI6cYU8itB17w5XGH0Zo6AELFMiaG6Vg7wLBaMfReuewapx/D4sZMCJEUJ6OgBe/l35nWPVaujk6YeK7z8xNkdaIe4aY8m6fUQnAd7VbCPpLG23tkY3fjOXvuyx5KmKlnA9GTHe5NHJ7o7WDQ07U32QPL0nxLfCY0d9S4jIZF8IyaVQUrOoDMFBlmPUEMRENw5Ox3w45tiOjMCIwPZY1wp7VifLBIYOhf4q5+6VKXXVuqaYIKlg3SJJ7XcQcekq6upFJGAIp2NDW0w54KdfB47mlt4lHp4OTAbz2+xNLeBcDmJUuriIAtZQm0AEDsLffl6nx+qSgm1wboghMvBc9An29jRjEwYKfvMcOu5JhskaHYEe01vW5uuD3RtqBEJGvL60z1MSPSyCI7
 ks5xfFCE
 VpBsHigT6L09GK5BVWetnEtUVoWdvB8EtR6GwSC/dTXFjUbtU7d6vYrypSu+QUWKnrDuZLBgixQ296ooopccG5DeVQh1fMWL89QeIqcI0yaxn9ukxxdqXNKutzynhbCu1/0OlX1coLRfwf3Or4LwluQ2ne1wDQYVc1Totmm2PFZBKy8kRe4/hdwS2A5ZyhyMUPAaU6cnf4kdpc1AxlyOKZHIMmgzJIhubLV8kp7aSZ0VTDC8ptbUd38sDTe3iFPlAEhP2xp5OH0QR8FjUgNQjIBti2suDY3sMA2PC+b0kRNg+TCQ2vRbVIXYEWuY4i10UsLvqi4aaVwIafPYzvPFm59QVVAotcG4X8OF5D6OzF1cJ9v6EL0vMEBKorC05D5jI7gi4RZZWhina2AZd6jPFbLYh7fT1j0uuvT0ufLg9s/7uo00Xyk9/Vc/6BmoLOt4TBsjbvarbIyXxaR9BtS8+FN81QnKFsC8CO/2p7hCLS4hYhFehxja1zYfDZwsNbAmfXLPaudvDLc8+9rVecF4iJR4zhTAYm/WUVmxsYM8t2Xn/I72rGX/CA3f5g/e3ysx5M2gmgG6WbvuaFZugUOXw+VBOR8Cl+JFEiSC5qP5nEOt2QTaMzxlILG5dJh/LocZMsZSLbJ0MPLgfCpHYUFttFYH6fmQ/niCMqgWoemTmnUijs7sGHr+9UbVZW7ajfqi9u62PMr24TGMn84nvl4lVtaCAGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 4:09=E2=80=AFPM KunWu Chan <kunwu.chan@gmail.com> w=
rote:
> > +/**
> > + * folio_inc_lru_refs - Update the folio's LRU refs and lazily promote=
 it.
> > + * @folio: The folio being accessed.
> > + * @flags: The type of ref: FD access, or mapped access optionally wit=
h
> > + * executable access.
> > + *
> > + * Used by both cache access (flags =3D=3D 0) and page table access (f=
lags =3D=3D
> > + * LRU_REF_MAPPED, optionally with LRU_REF_EXEC).
> > + * Context: The caller must keep the folio alive by a reference or the=
 page
> > + * table lock of a mapped folio.
> > + */
> > +void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
> > +{
> > +       int max_gen;
> > +       int type, refs, old_gen, gen;
> > +       unsigned long new_flags, old_flags, max_seq;
> > +       struct lru_gen_folio *lrugen;
> > +       struct lruvec *lruvec =3D NULL;
> > +
> > +       type =3D folio_is_file_lru(folio);
> > +       old_flags =3D READ_ONCE(*folio_flags(folio, 0));
> > +       do {
> > +               new_flags =3D old_flags;
> > +               old_gen =3D lru_get_gen_flags(old_flags);
> > +               refs =3D lru_get_refs_flags(old_flags) + 1;
> > +               gen =3D old_gen;
> > +               if (old_gen < 0)
> > +                       goto out;
> > +               /*
> > +                * Lock the lruvec if the folio is on-list. We are alre=
ady
> > +                * doing lazy promotion so in theory we don't need this=
,
> > +                * but for now, concurrent aging would still corrupt th=
e
> > +                * size counters.  This is a temporary limitation and
> > +                * will be lifted very soon, so the lock here is not a
> > +                * performance concern.
> > +                */
> > +               if (!lruvec) {
> > +                       lruvec =3D lruvec_live_lock_irq(folio_lruvec(fo=
lio));
> > +                       lrugen =3D &lruvec->lrugen;
> >                 }
>
> Can we do the lookup under RCU and preserve IRQ state here?
> filemap_read() can reach folio_lruvec() without RCU held. On non-RT,
> lruvec_unlock_irq() can re-enable IRQs while KVM's hva_to_pfn_retry()
> still holds gpc->lock.

Thanks for the careful review!

We can, but not in this commit, and in a later patch we did convert to
RCU convention, so this lock is just an intermediate state because it
may race with aging hence race with the active / inactive number
update. In a later commit we changed how inactive/active is reported
for MGLRU so this is no longer needed. We are basically lockless after
this whole series (I mean, RCU lock only).

Perhaps I should add a TODO in the comment here so reviewers won't got conf=
used.

