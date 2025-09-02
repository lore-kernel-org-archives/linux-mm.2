Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3753DCA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 13:17:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 958BD8E0007; Tue,  2 Sep 2025 09:17:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 931198E0005; Tue,  2 Sep 2025 09:17:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8475E8E0007; Tue,  2 Sep 2025 09:17:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 715778E0005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:17:35 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3EB1D1D9303
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:17:35 +0000 (UTC)
X-FDA: 83844362070.22.9F9DEE1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 24DBC140008
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:17:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g0YHo9Ca;
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756819053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P4DRa5JyII0VmmjBaXPWBiaM6z9yrS48QrKnGh0SnUw=;
	b=ovDFiBkJJHjCT51G9uXldaVlSIyDhaxUKQ313DM4jxVT24Z+aeQ4LbvCCqCyoUJ1b0S0jp
	U5jTilGEnWC7MvUJ8fgMHbjnPcKTEaUkK8aKPKhQIPtJCDYbKnTRup5qCAgPeFkv6T5zG7
	0YxP7709puoNHPfJ1cFrd0TTuqOAElU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756819053; a=rsa-sha256;
	cv=none;
	b=ACjSgRRx6qIEy9rfViGEN9PfIf/pehQjYQ01hSUQ12ZJ9KVRfyeUraVyDAMd0fQSXbk/Qx
	cSV9lUjVz1Xf6JWy2oddfPrcXn4xrN/gixF8+wsuuHatVtKF29gnJMMu8rYZurJFTHtpa/
	kmThmhX1FSA8wDdXAKg8p4UJqAAje7c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g0YHo9Ca;
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B189144A3F
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872E4C4CEFD
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756819051;
	bh=P4DRa5JyII0VmmjBaXPWBiaM6z9yrS48QrKnGh0SnUw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=g0YHo9CasoNdIWBnC6ZWofH+6+jqufHWP1dOSTmjkDrgktqxjbx7FfSye145xBY8e
	 pE/N5HwOFiIwYrkaJTcy6Scp3N23RjmOUqQhp2n0JW1m5sqaAjOi//5ivjAxt3LdnF
	 bMaSRDh8LY53loUz3hBh28yEdX9viNdSxeYRd5X1U1Z6FSkQmGmU0gNbWcpIwmO6fg
	 5bSpDsAOnAdZ5q7jlK1NRGsWpRpWAn8WnnN2fe1PNpdP6l1D4hToGGvJPZmbuGwHsC
	 CVuh88KrE96N84P2Ul4Kutwqv49prfq28tLqn8hOS5VNeDyeuEr7cvnOCTbnDGEuO2
	 lI5euodoUpW0Q==
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-723ad237d1eso4355737b3.1
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 06:17:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVU7SwgFOozylMKa0wn8r9E1xhW1P/YR/MSkWgfT57UtVHB3zrZB7Etpy4uiPr6pktP03hO8flOng==@kvack.org
X-Gm-Message-State: AOJu0YyMyKlvvMxPtzNd4X83EpRk/CHW79ATIdxfioV3W4PZZ0QSyled
	w/FLUhvUMVKSN/QCwhNBxm8PSCbvNG2Npz/X6xtcm14lwZsQoAWQnGmWqU9lMZTWCoXAr2aGVrG
	2p4rjjuBBDRSAKSbEcT9nSkU3kH5HHc5tHsWNdLYfQg==
X-Google-Smtp-Source: AGHT+IFyG1TWkVu49fYJr3rP5UGefFT3fiTlrwpJwWSaLn5aykXeZnUeAYEc1mU7ovusljsHKcgHt7hBrhUYRP9VA5g=
X-Received: by 2002:a05:690c:6311:b0:721:5b31:54c4 with SMTP id
 00721157ae682-7227654f437mr124374017b3.46.1756819050786; Tue, 02 Sep 2025
 06:17:30 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-9-ryncsn@gmail.com>
 <CAGsJ_4xON7fYg1VvcjLOsgBb_Wp4ruC+vdA4Q496GH1jXunU1A@mail.gmail.com>
In-Reply-To: <CAGsJ_4xON7fYg1VvcjLOsgBb_Wp4ruC+vdA4Q496GH1jXunU1A@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 2 Sep 2025 06:17:19 -0700
X-Gmail-Original-Message-ID: <CACePvbUVK45uRPVoO3ubDfQHikebSHFNQOsMTMvJ91QQZH2HwQ@mail.gmail.com>
X-Gm-Features: Ac12FXxDy3IryjPOmDhEZr0Uxc_iBeLDxMwIVpiY5RAprHfkS2MuWTBmDS4qd2I
Message-ID: <CACePvbUVK45uRPVoO3ubDfQHikebSHFNQOsMTMvJ91QQZH2HwQ@mail.gmail.com>
Subject: Re: [PATCH 8/9] mm, swap: implement dynamic allocation of swap table
To: Barry Song <21cnbao@gmail.com>
Cc: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 24DBC140008
X-Stat-Signature: ibmxrusgzrn1bztmxf6rjcu198qsra8z
X-Rspam-User: 
X-HE-Tag: 1756819052-262213
X-HE-Meta: U2FsdGVkX1+b48Z6lG29+d6APfELoPcTwvnmScIZnwRVwCct0HvthB2tjY1bIruJrCq/5gzHImEOLCA2PMAFvRS9DCY6mQ2TPDP5aYSjTeQLs0TB7EHDc6OKAzaMBMttmlsj9t3L1Tbt34Flein9SiYCMA7dFF1eAny5W7Iv3T5PwGLmXp7uDx6YIxRs251ztgm2tqfhAxKZ9KXxfWLs24WKhzH3ajg1Tju8In+MLC/cxvs6PHk394uzUdeQTpzRS8vBUbi52xVz9ku5s8Ts3fvpjz9fT8wQiXxFYe71Gv/1W+s4Ixpfo5GY8hCBbPzBoB4YPECyn9Ju4P2kQRuESeCRaVph4S1enYcVKAS/GP6XvjPlLIEjRwZ2VicfBBkSEPFL85upSJUnyPAeEgzX+mXYB55zzQMW4hXs1e5AkIvfD3bAC4WvQ0Sn0o3AsXlxaLrwqcllSE4X+9wXVqR9Jy4vjNus6EA3TXvUyO7nmTvCK36gmZI+2hJU+7QQYGC22ls+99AtEgSrO4NsnmOPfe+SgwxOgvNuCgDKWiJGoRIm7JhumWrMR0AnU090yM0t40XZWxTLCn2I8wkTIxkLsPZnUhv3AKQYNzvOLjyjpZ51YAn48g19BmjZL6QxnJuB+CoddrkOQT/ujoCMwlVAfQjcMtPkkkDwMHgsj55O8izTFAMC7lYAKEFn2DQtWM+oEX95rt2o/ngGODAb999aq6ivGwOjd3gg47ytWC1RBnJHeqxvca1tvjYxd5Zx6gdj8ciePAEOz36b6oatGWvUwdWPMMZyXa746LnRoyMW3aPpScv9/RkogzKT8iFzgBpkLgSMEnXYMPgHI6R1B37ClfPUVOuJ9b4K/hLXmEi0G0UVSyU84ZA3dFJuRHdBuGtQZTo+gRXe5w8p7ICVkHsBbY8nEtNt7wZgW5J4Fh3dHxf+GU7+M5SODRTGbqM8NbH18bRxeLMFGmcjq7uEEPv
 gt6F4dJc
 OUld4mraarnnU6iVVulyINbtXRrByD2O7eO88CRwYMuSPBW/G3ae8iftTyfTh5DXdb2Ful5T/YW0QumOHpiUvklIQxxlZmoRKeDKTI7VnhEmJ3AOT+yxyVkfakRfY9KJuNzV3EneutBWI4xGAC8oCCqbRIry4nInf/yIXTpZG2Ci/UJ0+G/6BCPtYi5dI6R0zze8rPQDAJWWCY8L6V5wzyzpIw9LT7jDO6nfvktHoqMmkI45GL4ZjSaqaWz2tI8Vn045wxmhTOW/FL3Cw5Xq4pFb3VU8PlE37paddXtOSSVjFFyNA1ItgYFw1pJR/9KlKJ9MTsKec6c/x+X4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 2, 2025 at 4:15=E2=80=AFAM Barry Song <21cnbao@gmail.com> wrote=
:
>
> On Sat, Aug 23, 2025 at 3:21=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Now swap table is cluster based, which means free clusters can free its
> > table since no one should modify it.
> >
> > There could be speculative readers, like swap cache look up, protect
> > them by making them RCU safe. All swap table should be filled with null
> > entries before free, so such readers will either see a NULL pointer or
> > a null filled table being lazy freed.
> >
> > On allocation, allocate the table when a cluster is used by any order.
> >
>
> Might be a silly question.
>
> Just curious=E2=80=94what happens if the allocation fails? Does the swap-=
out
> operation also fail? We sometimes encounter strange issues when memory is
> very limited, especially if the reclamation path itself needs to allocate
> memory.
>
> Assume a case where we want to swap out a folio using clusterN. We then
> attempt to swap out the following folios with the same clusterN. But if
> the allocation of the swap_table keeps failing, what will happen?

I think this is the same behavior as the XArray allocation node with no mem=
ory.
The swap allocator will fail to isolate this cluster, it gets a NULL
ci pointer as return value. The swap allocator will try other cluster
lists, e.g. non_full, fragment etc.
If all of them fail, the folio_alloc_swap() will return -ENOMEM. Which
will propagate back to the try to swap out, then the shrink folio
list. It will put this page back to the LRU.

The shrink folio list either free enough memory (happy path) or not
able to free enough memory and it will cause an OOM kill.

I believe previously XArray will also return -ENOMEM at insert a
pointer and not be able to allocate a node to hold that ponter. It has
the same error poperation path. We did not change that.

Chris

