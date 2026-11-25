Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2A35606A332
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 12:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KBjFVf6D
Received: by kanga.kvack.org (Postfix)
	id A02816B09E9; Wed, 25 Nov 2026 07:32:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B3EF6B09EC; Wed, 25 Nov 2026 07:32:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C98E6B09EE; Wed, 25 Nov 2026 07:32:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5EF326B09E9
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 07:32:56 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DAB2440ECF
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:32:55 +0000 (UTC)
X-FDA: 85473580710.01.0FB6406
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf26.hostedemail.com (Postfix) with ESMTP id EC61914000D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:32:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=KBjFVf6D;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795609974;
	b=8OrS2bIHs3XzCV10ZUtIfYWr06kBeJZw4k0N45iyPshMIDaSaSFWpSmdxx2ucPRuG06CJj
	xU5s7ixDOgqtVM+m+fnyF3bu2GRc8Bi++7yeov2KvGLrtihwnXR0sO2qXhhnaZTYaG+qt8
	M0bqyX7YjpjtSSKGsYiuLRO6cwUWpbw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795609974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zRIgVqfWg+QEl68a/JHuBJi2X/pJTjAcVfLhgF2ZyDM=;
	b=wcubIZO4gEM9p7j0kDoc54QNMmRZ4WsLd9/qrAdUjqV/hapgQQLrIsfCZ05pwNKN7+sQ5K
	wCspRRhHCE6auiYoFi/+vJCmJLd7nm33Vx0I67q+wnsRNMURV7xd2RYAj2UiyARfxahdOj
	g5A0QekVA+dmv0zTRi5seBpvCSRVJbI=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=KBjFVf6D;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c4d581da0aaso793965866b.2
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 04:32:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795609972; cv=none;
        d=google.com; s=arc-20260327;
        b=WL1PuVQCXLu3Qg8Y2rcrChJ/3NFY8Vy1MKkBsCNAiQXuB3qonC9vgLUrtNZ4aNj3bM
         pmTWW1CZjmjz2czNF3yKhRzftm1j2hBHwiQfCM84TOCjMY8ism8Z6hCamkoeTFIXW+62
         NLmKKYEkQ2PxOUNG1Kfn5sidqc17ChZAZHcmcPrOdICwiY9+77j2UW1EmX49pSdM3dPE
         58lehud6oXJgXhimVVIhOZqFzyIyz2aN3MEqL+wS1m6gHeaotvgDigauOd2VVd+NnEqI
         SJlmpcCOwVBdaczSHQdmKXOm3cUBzSl/OYjajnng35g3L3TtyBV1Y0K0y+rxVXU9+Bck
         QwEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zRIgVqfWg+QEl68a/JHuBJi2X/pJTjAcVfLhgF2ZyDM=;
        fh=aeUgo5tO26BOvI+dB15Jx68m9yedj9daZTDU0EM+G5k=;
        b=mbZB1kFjn20S9hiiptQYBKfK+6c7OwkquJRyWz3Yh/BxsT/sJm0le1QwH/L6ozK1FK
         16iFUBE26gkHWmBtNcMPjkQ/Nv8XpQ9FVmtnX0flVpkEKKJrDISO5l66apar9fP7DGgm
         pDg1IMIzIBP0zFjrJb+pd/AgxGES7Zyk/JReT13o4Lqn85P5jMQ9uEjx7BOR0rRNw/KG
         Xfy7adRenjdcvWEHSzcCezbd1CEg8ejRUvVDbajtG/1TL2NsyUggGfdIikQUewfdkwon
         zbJprN8IntWZAE0rvJBlo1CmdAS893frscr7QO8Kyzb0xtypsLlHPzh1uzZMkWmjscWv
         z/hw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795609972; x=1796214772; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zRIgVqfWg+QEl68a/JHuBJi2X/pJTjAcVfLhgF2ZyDM=;
        b=KBjFVf6DYHpu8KGJBjUCaotW/K6Ega7RSWwvRXrCn5KwxcdvLdelkuOyXqceZITlde
         ZsWmlrBEOVPSIOPdcYzFi6aizj1zrngQeWhXqjWdg4uJE5qTBBw1ODMJw/T36CcF/Y5v
         atvz+F53SeiK/3KVE58uBrL5fKsI9lg6R7Nkveq5ZXjJ8oHgfmAGVSFRDATbx6eWHqO1
         Jg0XMuiDKg6citLNxMMP+cN7T+Irxgsq+twErnwbtFyz54ryx0u6C5SOVPb6X49ZHBZl
         l7e93aOMEICFErhqYJw1eqI6FTbBKzo385f0bDMQma/ZmdFqCtNxl5ygikTl3A0kHsNE
         DrXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795609972; x=1796214772;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zRIgVqfWg+QEl68a/JHuBJi2X/pJTjAcVfLhgF2ZyDM=;
        b=DXFwuyxj5/WoyLbM57MVxO4iJsMAc5ldvDexCqgDyJXYXSoOxeh1ghn8u81xa5F2zJ
         Gxg/13wetdRoWyKxbS1LZGmav36JC00m4S2ZZHE7oYoTwYIPK50aBILx0sJeA/kWpV1M
         fhvRKaMWjkvi5rGhoCRB+dZ6PVMYUFaag1+xICCDNNMxK+vDG23lACPAJjtLgVRjKBBr
         GVHwl8BJC3nJD3CBS2jn1JdtnaLZFbQSr2XVJ7xU/ArrqeA2fAE6a97Mx5m7XWFwiYFs
         UEsaR4clarkx5n2Kt172rOpt44xZEy2/PIJ+8FACBr9HEOBl/5AQpHrWVUTZeyJImIsT
         6WbQ==
X-Gm-Message-State: APuU4Z99MuB1zu1LATqwqqKrZqRGdUHFQu7i9dY5B+bX8PwjOmqGoFeE
	cV+rYEPcXj8yrD7OvKLTx8bCJnhix+ngGTRU3/cLj6C6oIDRHtqZbg/azSMgVcMJE/gWw80n6aN
	nddj54h3S8+SHNseNid0xEd3+MwNonYY=
X-Gm-Gg: AZFdTZdNFgutiZgaFf2yNWudovXUUkarvdGm/r2snnCJE6M8DFkBLH72iIeIL6MUDRt
	iwZA/hxdfY08k+DtZkMKl7SFgFgIIRSdOevYsFaOYh1Rhqe2yFsXJ+LcRsI+Tvi0LMrtDlGYxfT
	OktMBfoWqHW0yb7QCCX3ObI1J050O/ZM1S+XA6iRAngEvGI6CdKGWIggYCyUkp//nNWInN0EvIm
	VcewabZ5lxp38JrQdk/8LXxOR7HBZuRCd+gFygNOnD2r7UTuIRF+0hGXxwQ+/un0apbiyS/sKIi
	3lBOn6URi+7bLJIkNsw3tqNsncihSoFBa0DFpb3bjTGoDOzEDzEd6yaMzH2pVrJliMjxBSZFWv/
	mFQV8TEQF8QynbkvdBRWwucBN44ZS0+tPksnKrC0jIGu6pVxoDCZWhoNoXsNQQDvbwZsfIg==
X-Received: by 2002:a17:907:7f91:b0:c50:c747:a4ce with SMTP id
 a640c23a62f3a-c513a4b083bmr1510819666b.4.1795609972048; Wed, 25 Nov 2026
 04:32:52 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-10-8ffea39934a6@tencent.com> <ce7c1974-2524-4d49-91f1-508acf2e33d8@kernel.org>
In-Reply-To: <ce7c1974-2524-4d49-91f1-508acf2e33d8@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 25 Nov 2026 20:32:15 +0800
X-Gm-Features: Aa3M54pyChceg9ROmZV659afdcgKNDI5RisCi7hnLxG16VuSebxmazytrDQ-wFs
Message-ID: <CAMgjq7B7dsT4xOfcpnC8XdXZSPd0OOw1br64M+HA_3E+ZeZ-5A@mail.gmail.com>
Subject: Re: [PATCH v6 10/18] mm/mglru, gup: mark folios referenced via a fast helper
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Tal Zussman <tz2294@columbia.edu>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
	Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org, Tianyi Chen <hi@tychen.cc>, 
	Ridong Chen <ridong.chen@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EC61914000D
X-Stat-Signature: uoc416cshgjo3bgqmz9ur14hkf8zyj9i
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795609973-374616
X-HE-Meta: U2FsdGVkX18YIXRWPv+ZOjtI9cECLSZ+Fg3LnpsqizFQRM4L8tSXevAjl/pBQbNZGBetGUvbcBaOuvC0mgFTNhDyK+NfqN2WsFEE9pxrCHm3geKL27dQdqZ1EpgX/Q5puqP1qBnZ/bBAsEYmsrMDxzKVm9UK4vsKWse79Ou1NsiSKQbr/s0V+So9z12FVrh1f/qhRwqi5GfIYgvmDdMnc3JarUNL3ewukZDQRu3hhQPoTVOA7uo0PB9OQD3FnDsqfxDQ/bT9jduIcSP8o6ENTyjT/vIJIo+lmzkXrri2v050sGydvMfjlzlw/DtLXNsHqIBCwzB8hn8FozJuOwUMybY9Cljk6QGxUXJPTqP37fdoIKkGBjFhnOZYTGMGnn6XYvm1IFXGm0v5TAqoeXD6JzQuHegbZ3c96Ruc0OniNqBCQj44KYPeEDU/iODlIyUidRCITeXDIjvDLRMdBNq2e4UwVWiS4H9pco9B54crR/QqwUkNnCkcWWQzQ1u/CToLhvNyM1Lm1wLjVvfAPySzbxDVqmy26CvNLVXlh2IIdVpxytfl7twfcQwPLatptWDMIecDeF77uKWjTmbtg6JQagJKgjKiownnSXuZ6LEZ3jdfsJgaaMlY/wyZDvZ11OOgifaTm+0Fi65xkM1aEbCiTcHRkMGO7hywbLy7TEvSq1DBlHIEgGJk49qGH3vRlzFms47BKiPzjU85mVMe/bbdfkSYI7JciK/ZmPcWA1+xYqYE4pAr5D0yz+2EbIk+PAtO5SzBCmHtAQKQMUlxwuCn1Ae36xGKJrgSvVh8CB8cni20y021PbHY1kbqxHV5/1riZD9ax0nlRaPSRVpIDmJBUs7ywhu8+m27TG/LJ9ZfwBw17Rr2YPsoYu769cHz2mPq5RwFRO8P/y9lLSCyOTQoW3Be/1FtOQlsJDj1d/ocN8naV5CVI8Fk8EsVnjnBWU6mn2Tu81KjLC0PGn2GEGj
 wskgO/1B
 LrBp2rrgSz7C2kL1RduqbDzWTV3dr5kIr6KrXXGIWSp84XFPLxwauloCkEbZauq1q5T8QfOP7boPKryL0K/smOLai2rP8sYWJNU7ndAhSLnQomUhx1wzjgpXAYMODC1DEkxSVK2bHfRs1ijeUSQeMTaPJ96aEthpu9hvzi7NS5Efo+cvE4LHbatosUTCBaVS1r52tL0S4R0h+TfEdjbzmtPXCQetKzsUw5dSA6ojX+OfYO8iAHkidzqJqP7qNkSwpvW3PehES4qXpFFek4cPRpxL87jmNG3jt9fyFdKveS+v/qhC8MaEr69IaGObLfC4FfAOcKCfs6C2I5f71EFI2uD1q7iUyK3Z2D2JWtkjTHP9g+ZpCxD1DcGa2+CYtH9wwA2R8QUBfpqyDmFEg31UWcB58RYjCiVceyy6yExK0vv9oqdIrdVP5ACLk30s0rH8KVjM/J8J0uQ5dVgZc+5qFRylGuen7Y4NDNpsph1nyfxDBbq0CNXbx2zPrhBzdGW3Utm90kSWxuF2SWjrk8GKsloVGbVx21y0NRYU0pm1o4MmA1PCiVbNi0F2NokWcyuaFDw0epuZe1veAJCMb2BPNVb1s0tTbCgOAfs/iCIOuZhHan+eDfTsNY0kz/LT18JmkjlhAwILtXbPa4ART/J2ohL0wRX+gvsTNa2Y24toCGaLbTZT84K8NS3fNIZ0WbXJJIymgmhoIMn0Ja++q/+qlODPt6/u7daM8I+qIw8icnN7p5Xn31kcpSReAYtgiCM5OyiIvRFPxepYb0NnDY57DVF+maXcem2ZnAK5b5MlaV0UjtCN4ZlP1syS/LSR493zKydVO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 6:14=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 11/23/26 19:53, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > Introduce folio_inc_lru_refs_fast(): raise refs from 0 to
> > LRU_REFS_REFERENCED via cmpxchg, or just set PG_referenced for the
> > classical LRU as before. No counter update or promotion is needed,
> > nonzero MGLRU refs are left unchanged.
> >
> > The classical path is taken for a folio that is off the gen lists while
> > MGLRU is off, not on lru_gen_enabled() alone: while MGLRU is being
> > turned off, a folio can still be on a gen list after the static key
> > flips, and setting PG_referenced there would bump its refs count.
> >
> > That check uses lru_get_gen_flags(), so move the helper out of the
> > CONFIG_LRU_GEN block, it is now built with the option off, where
> > LRU_GEN_WIDTH is 0 and LRU_GEN_MASK is zero. Keep the decoded value in
> > an int so the subtraction of the offset-by-one encoding cannot fold to
> > ULONG_MAX before it happens to avoid -Woverflow error with CONFIG_WERRO=
R.
> >
> > This helper only aims to be fast, it exists so the gup fast path can
> > stay a fast path. The new helper doesn't account for refs above
> > LRU_REFS_REFERENCED but that's fine for now as GUP never used that
> > or anything similar for CLRU either.
> >
> > Convert the gup fast-path sites. No behavior change for classical LRU,
> > no regression for MGLRU either. Just prepare for the following changes
> > by providing a helper that follows the new convention.
> >
> > Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> > Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  include/linux/mm_inline.h | 62 +++++++++++++++++++++++++++++++++++----=
--------
> >  mm/gup.c                  |  6 ++---
> >  2 files changed, 49 insertions(+), 19 deletions(-)
> >
> > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > index b15c3618a1f2..13c8b6bce349 100644
> > --- a/include/linux/mm_inline.h
> > +++ b/include/linux/mm_inline.h
> > @@ -105,6 +105,22 @@ static __always_inline enum lru_list folio_lru_lis=
t(const struct folio *folio)
> >       return lru;
> >  }
> >
> > +/**
> > + * lru_get_gen_flags - Return the LRU generation number from folio fla=
gs.
> > + * @flags: folio flags
> > + *
> > + * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Retur=
ns
> > + * -1 if the flags indicate the folio is off the list (e.g., isolated)=
.
> > + */
> > +static inline int lru_get_gen_flags(unsigned long flags)
> > +{
> > +     int gen =3D (int)((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF);
> > +
> > +     /* The gen is stored offset by one, so zero means off-list */
> > +     VM_WARN_ON_ONCE(gen > MAX_NR_GENS);
> > +     return gen - 1;
> > +}
> > +
> >  #ifdef CONFIG_LRU_GEN
> >
> >  static inline bool lru_gen_switching(void)
> > @@ -168,22 +184,6 @@ static inline void lru_set_gen_flags(unsigned long=
 *flags, int gen)
> >       *flags |=3D (gen + 1UL) << LRU_GEN_PGOFF;
> >  }
> >
> > -/**
> > - * lru_get_gen_flags - Return the LRU generation number from folio fla=
gs.
> > - * @flags: folio flags
> > - *
> > - * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Retur=
ns
> > - * -1 if the flags indicate the folio is off the list (e.g., isolated)=
.
> > - */
> > -static inline int lru_get_gen_flags(unsigned long flags)
> > -{
> > -     int gen =3D ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
> > -
> > -     /* Exclude the legal -1 from the unsigned MAX_NR_GENS comparison =
*/
> > -     VM_WARN_ON_ONCE(gen !=3D -1 && gen >=3D MAX_NR_GENS);
> > -     return gen;
> > -}
> > -
> >  static inline int folio_lru_gen(const struct folio *folio)
> >  {
> >       return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, 0)))=
;
> > @@ -483,6 +483,36 @@ static inline bool lru_gen_del_folio(struct lruvec=
 *lruvec, struct folio *folio,
> >  }
> >  #endif /* CONFIG_LRU_GEN */
> >
> > +/**
> > + * folio_inc_lru_refs_fast - Bump folio refs count without promotion.
> > + * @folio: the folio
>
> It's unclear when this function should be used and why it should be used.
>
> For someone reading/writing GUP code it's completely unclear why this mag=
ic is
> required.

Right I think I can add the context here in commit message and kdoc,
MGLRU requires the user to avoid calling folio_set_referenced(), so
folio_set_referenced() callers should use folio_inc_lru_refs* instead,
and folio_inc_lru_refs_fast is a variant of that aim to be much
faster, avoiding RCU / CAS / Memcg Counter update.

CLRU still uses folio_set_referenced() though. We can get rid of
PG_referenced and helpers later to make it much cleaner (co-exist of
two LRU is making this looks ugly indeed, I we can fix this step by
step):
https://lore.kernel.org/linux-mm/20260502-mglru-fg-v1-32-913619b014d9@tence=
nt.com/

