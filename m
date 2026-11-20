Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16B0D606A334
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 16:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BrJfPmsh
Received: by kanga.kvack.org (Postfix)
	id 3AEDA6B05B1; Fri, 20 Nov 2026 11:20:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 386846B05B2; Fri, 20 Nov 2026 11:20:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2778F6B05B8; Fri, 20 Nov 2026 11:20:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F01FF6B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:20:46 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 814B51C4B88
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 16:20:46 +0000 (UTC)
X-FDA: 85456010892.09.1F7B927
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf02.hostedemail.com (Postfix) with ESMTP id A3B4180002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 16:20:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=BrJfPmsh;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795191644;
	b=FWPl0cBKJu0MnPz6M27iijEKfwopgI1ojp1CoaDdF7FS61SFjiUdqy2NiNWWc+TuDow6Iz
	YfcOGZjBhJTjZ1waU142kko6+W+hR9Dw2iRABdjAbYqxIHvpZClHjDvbDYuRj3ByTKDUsl
	W75puZr9lIf6j07dVmi+8vWbuqqqHvM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795191644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nFviYrq5o1Aunl789XsU4c1vTFdvhxxqWOma4Om+z08=;
	b=LpV5Q1SZ3uXUcPQTyc63EL36iI1rQxlECidNXpigFq38RmE+rwtx9zMRmi3WlM/0sHpB2g
	itNJuM8W83YnIhFvo/BGndG996MGh7w+DU9UhteX+vtet1Bj/ZoY+hSA94XhXV0dFn9X1J
	lP1t1mVcfFPCFS325qEWlOHha/TrfUI=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=BrJfPmsh;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4bb77a462c6so17448195e9.1
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:20:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795191643; cv=none;
        d=google.com; s=arc-20260327;
        b=FuC001y4ArXU5MqonjnhK9rFWrM5qbaWq7QSb/O0kCJcj7Sd2eIBIPdLUFJ2ig6bZ5
         9pYBobB0HbM3lPeY9He9QxP/nz+hnrO/d8H+aUD/WJ880653XsAD+5UhE6Nf5DfoioXL
         Yz04THg1YpnPJdxI4P3le+pJ9O09ibZS0z76oMBfIb0C3prXFTHTL/pl8v17rh8RBBzi
         ZJweeJrdiINT3bvL6IgeUuYYjt+t83Y2mfufjCHny7WaSU7RsUWpqVmkVW8YOjQuowmF
         4l1KhEY3xuy5fUnDyAYUME9z1uH0txSM2tex1NCtOmvvnhjGdTkPUCVl3NW6hNBD2C8+
         A3KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nFviYrq5o1Aunl789XsU4c1vTFdvhxxqWOma4Om+z08=;
        fh=BreUFRwPfo8in1YgxdNM3CEmyWeZ42beJhCpvJu1Uhg=;
        b=TpnVKQtrM1ON5G0J3RgddlCGQaqxLlcMsCe4gnOPRD2qspVkIir4c1MnLiVz7W48i/
         znoeqf+KP7lOZwTrjgD+3yqP2G26ohkRAwmneZ2aQSssfddP/T6Kr/cvuNQ/MgMCKqX6
         Sb+gyNazdWmwebDK8cJEeDDJTr3Wy9u7NyzkbDBRgMnNiW0sViiRvgS9ooGyBlSD7PG1
         +mxna9bPVzz6Ts0tuCCWsUj9zECds2rLYFKP6a+h9s5WSEASQF4vxnJHvkM7BObpwK6a
         sNmQxmgIDSP+4hbJOWUYiSdHwXkcdlR5/9dp26yEBfoy4077rUb22nW4VZ857uoZDq6B
         HZGw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795191643; x=1795796443; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nFviYrq5o1Aunl789XsU4c1vTFdvhxxqWOma4Om+z08=;
        b=BrJfPmshx339h8tvSNu8MyJ+9+CvjpXfxCyGxsZ62ouj+dkRpJ//hlh/P1dtnARBeJ
         Y0A62zCCCKvTM4RFt6uivOaT+CQcmXanAN36UDrUWaK6KAvN5n1RotvnWJP52W3MAyPR
         LkPA2mYrZFijuB6wEnrGmTNISraJyfOcupY0kdsWpWSrs8wqaUQysgUCxHiyocBjqGvB
         m6UbWwQfcGjbZByICQjgyb6lPuW5Bo79GGRD43OxTiCQop8iPW0pME+zTNOh7wgUoVAb
         LelrmfSEXBt70uHEF8/huxWCl02UUVCmnrvmh0GBIO82pGlF47WVa8EWVsgcsC9Drw1Y
         JVVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795191643; x=1795796443;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nFviYrq5o1Aunl789XsU4c1vTFdvhxxqWOma4Om+z08=;
        b=XBBf3Gtq9pK3tR9pNaKMfsUmkbfYACwiv+md+ZewuSvoJX8JkBFZH7xRsTBGTVvOR3
         YgnrWkxGhh43MlOrCNHfe37IRUdhFTybLfmBzeBOPQtAKgjtRRtj9GXt38d0w2o9ESZJ
         atk4BML2EtAmYWqlJrv/2nnYM5GZgx+Ym1HjqFsTWYocEBgTQTG6U1QBYmVzC9EuFfYi
         BnizbM1ReZqIZ/KW4goqK2HBXAP2bGv7LtGAIGeW+2FS6c6LyGn+NHEE4/pC9ANzuqML
         DbZMeDoJOUtju+onKDPFha9FnHXBV3fuf0lt5kJeicBnFLN5iUv/YcwlM1nkUDUJF7F3
         7dQA==
X-Gm-Message-State: APuU4Z+qpVeWtwNk56Dl+pAc5u/IN37de08RY++na+X8kmZnW0upPzti
	ia12t7o6SlF26+TmV/h69DP5A12pWfNva+lvj45Dx+EAJuTGyKq02/VYWMWhkJ15xSkrwSzCt4s
	zaAjVnEn7iosXYyNj6KUrqQvEa5/+AAU=
X-Gm-Gg: AYBFou2ONWWRdDsxKr7Fk+khb0xE0cWGE80QNzlxBVYfelSV0023GOIX/cwU17QxOgu
	x3SR1NAM1wa6cqcYpqVL3+JdyTOFFKnjuIFFnS2Hc3NfpBT+Q/v7EiAwBLKRbDfxxA2Enl5p+iy
	agguBKmrsYjzmGyfbxHU7CvipDEeBQHmU8KTjbdrVqjrTrXMDqANPbhiVAbiIh2Pdo7qYq1yykS
	m8OvQKSDLNxksr0qo6akUGTVH1ozve9mL+8aTHOk88VSnzGrZOCz6xPU5424grebAjEDqYESAIf
	/PFOL6KkHJBBhIeVgClsulcTIxQy/VBh0TX8qz075j63n44HGovBIc3ftXjHJqHoA4V0FDXYUIS
	WgpMF2d8zvslHaocaZuyMSM7+0AGOQVHDMRNgFRQixd0w9A76MGqtvGLDdZme7VSnTWMVDlTcvw
	2eEZ3aoBKWBqIjpD6/LK4=
X-Received: by 2002:a05:600c:37c6:b0:4a1:88df:8a2a with SMTP id
 5b1f17b1804b1-4bb88812a84mr79631575e9.13.1795191642448; Fri, 20 Nov 2026
 08:20:42 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
 <20261119-mglru-fg-v5-6-9eee2fe97a2d@tencent.com> <CAN_Opa_jb1pN=-Z+4WRoXVDSe0YfppeY319iagMdQoMgtOQSSg@mail.gmail.com>
 <CAMgjq7DbK8sc7-0CTOj5iZBmkLmG7ggj75mdTxVkunGzmi=NWQ@mail.gmail.com>
In-Reply-To: <CAMgjq7DbK8sc7-0CTOj5iZBmkLmG7ggj75mdTxVkunGzmi=NWQ@mail.gmail.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Sat, 21 Nov 2026 00:20:30 +0800
X-Gm-Features: Aa3M54pZxa4hRHw0Lgws3rEOfSeNigcJ3vp4dRWPeqYAT3KKSQ-I1gkfiyUitiM
Message-ID: <CAN_Opa93a7Z0wmPxLGFeKF+BssvZeioFHU6tcnBioXTQKWKP-g@mail.gmail.com>
Subject: Re: [PATCH v5 06/17] mm/mglru: frequency guided workingset promotion (MGLRU-FG)
To: Kairui Song <ryncsn@gmail.com>
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
X-Rspam-User:
X-Rspamd-Queue-Id: A3B4180002
X-Stat-Signature: pc47997aw4p8mhfj73oqcyn3d3hb6d76
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-HE-Tag: 1795191644-27010
X-HE-Meta: U2FsdGVkX1+3BA29naH0E9mdKPIvnKofrjJq+TdwCGnh3InJGW53jrBDReA4Kx+XuLchr66M4VQ/ssEmbU5559NMUFbnL1ckoMwdwze/fpyGdHxQuISh0BpqUeaZoY1SQ56cr/LXoDS2ZlPPotQnNgqkTGr3rsmKSIObhXtnZnSjqqsWavNjm7RRNFd1B3qRauj89usJIcM8I2BoonM/MMzyhXr4JJWO3OdEKYhv6DqVQyLS01B58hMLfaPANHE8zNkfQMng03HdnCygNj8YM6Tz8N+74A4n4lzoN1h/k8QNVmMIA+rW/qPi4Hcxn6Pjm3k1k/6e/FXFNlybTjri+qG2vmUGfCYzObcecwsLsT8OvQszqU0kAOoIsXQF5ymhVwNIjQcvi29K3r0zrCKy+YSEurljp6qxbh/DD9JQTDMfiGo6fFxYjN4y9RZKSUvUGlenpGWcrljNGjQlj6u+lGY7Quh1xYshSN+Rrk48nqUJj9FmwvNiIFWTQe3mlQlvwWHCT2+/PaM1dFfouFxBoNxIQE/SlN0dNA1SvzdcrC9q/SCAiy5shalQnR1xZRbhjTBdJiCaECJcGjnfzmP1/ZTE9oh83UGv8p8GqYdWuoXTx/ZTKkwduIXaKelhimsYa3WRsAVHEYvKaBX1WxBy2lOtsKtGYVgGnNwwtygjbHlmSzEhkzzt6RvfpAU7vZ9pueyFGcgDZ1kkcMibjcTZKkuIwMvbiLRKzMRsUsuEzMlxQms2lL0lY/Y80FBEfHcEr2GgY105f/1R2AThlMo9YoSBd7Ox79wdHha6LXd8QCsmuVtj0FRans9J7CPRHQdTehbzbMGfpuvxUZ4fTFxWq/fVmsidok9gflg33l4ecAh/Cu8lzta5kM79m+uKX8yTttmvJTVXcwxrq7a2GzN1/TvO+pRplgV3nNVVCIue+D0e/ePgqhjlI73dMwxrLA5GQrBg+vDj19WRxki4zmo
 M34dP1vj
 094U9qXsdqlsQ4TCjHd1P/zX5W5kUoCesaxgEp14xNzXV4QY1Ltj1WX/CXGOsRQ7TdYKMh3MhM0IUxRYHJ2qnHssn5BPoYW7mGm6NSSij8CmvU4aDV3/c3FwsE9mJkiLu59DP5XZLdytCtc2SpqMbNM/nhzMPSGDLEFW6c6r79JMl0SxR0iwPnAtBvJgJ72pqYmnVWo3dbc3o6f6YemgtlPaRtxGXpR/kjM7PbN50Z2dkaFlpRSXCuqWBpOaPb9ZBwi26ycN/OvM2MF183kqiLXXmF/2UWgyIQdaMlUyvx0cYjUS7wtz0jHl0gvGricijtUIt4OqZDVMBFarigkxRRM38FueVO5/TfEIBWQb6Y2ONgylSwZNXZeW1jLIh63FKkecLIBUeb7mY/bgc9a/m6V+XhnJ9ClFfMQ31SMWoZ2q6Tk+WSFTeNcBg20kV8Tjb9L9nRXFQC+1//7fIU4GVRNVzlBaZ42mEmlm2sMEULhi9cxtIS1Efnjn5ZKbB5yws7998GKgZYk5S6EhjDbu6N3xRYURrsdVQl7frt/k/y+ZU/19OHR4qiBeiL8ejZkf4fEan8jafnD31ln8EgeFp7ZiLIUEBCcg03XNnKZzeP6IZZxFxY00lbeNEnz2FKw2aHdONFvAmYWzSk0Ba+ABIID1JY6pJNU57X+SYfSh1v/y9E3iKvxGDEpXNImN7ix7XvqUgLqWTPBDHLKzqcnrWGd1a5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 5:36=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Fri, Nov 20, 2026 at 4:09=E2=80=AFPM KunWu Chan <kunwu.chan@gmail.com>=
 wrote:
> > > +/**
> > > + * folio_inc_lru_refs - Update the folio's LRU refs and lazily promo=
te it.
> > > + * @folio: The folio being accessed.
> > > + * @flags: The type of ref: FD access, or mapped access optionally w=
ith
> > > + * executable access.
> > > + *
> > > + * Used by both cache access (flags =3D=3D 0) and page table access =
(flags =3D=3D
> > > + * LRU_REF_MAPPED, optionally with LRU_REF_EXEC).
> > > + * Context: The caller must keep the folio alive by a reference or t=
he page
> > > + * table lock of a mapped folio.
> > > + */
> > > +void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
> > > +{
> > > +       int max_gen;
> > > +       int type, refs, old_gen, gen;
> > > +       unsigned long new_flags, old_flags, max_seq;
> > > +       struct lru_gen_folio *lrugen;
> > > +       struct lruvec *lruvec =3D NULL;
> > > +
> > > +       type =3D folio_is_file_lru(folio);
> > > +       old_flags =3D READ_ONCE(*folio_flags(folio, 0));
> > > +       do {
> > > +               new_flags =3D old_flags;
> > > +               old_gen =3D lru_get_gen_flags(old_flags);
> > > +               refs =3D lru_get_refs_flags(old_flags) + 1;
> > > +               gen =3D old_gen;
> > > +               if (old_gen < 0)
> > > +                       goto out;
> > > +               /*
> > > +                * Lock the lruvec if the folio is on-list. We are al=
ready
> > > +                * doing lazy promotion so in theory we don't need th=
is,
> > > +                * but for now, concurrent aging would still corrupt =
the
> > > +                * size counters.  This is a temporary limitation and
> > > +                * will be lifted very soon, so the lock here is not =
a
> > > +                * performance concern.
> > > +                */
> > > +               if (!lruvec) {
> > > +                       lruvec =3D lruvec_live_lock_irq(folio_lruvec(=
folio));
> > > +                       lrugen =3D &lruvec->lrugen;
> > >                 }
> >
> > Can we do the lookup under RCU and preserve IRQ state here?
> > filemap_read() can reach folio_lruvec() without RCU held. On non-RT,
> > lruvec_unlock_irq() can re-enable IRQs while KVM's hva_to_pfn_retry()
> > still holds gpc->lock.
>
> Thanks for the careful review!
>
> We can, but not in this commit, and in a later patch we did convert to
> RCU convention, so this lock is just an intermediate state because it
> may race with aging hence race with the active / inactive number
> update. In a later commit we changed how inactive/active is reported
> for MGLRU so this is no longer needed. We are basically lockless after
> this whole series (I mean, RCU lock only).
>
> Perhaps I should add a TODO in the comment here so reviewers won't got co=
nfused.

Thanks, Kairui. Keeping the temporary lock for the accounting
makes sense to me.

Kunwu

