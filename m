Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B50C9C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 01:06:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 514026B009D; Mon,  6 Jul 2026 21:06:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C4866B009E; Mon,  6 Jul 2026 21:06:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B64F6B009F; Mon,  6 Jul 2026 21:06:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F3A646B009D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 21:06:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 69FD5C17C4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 01:06:40 +0000 (UTC)
X-FDA: 84960190560.08.1B0B032
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7DF21140003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 01:06:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X0QNkxG+;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783386398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5sDU6oQ6P7TaizYKEXdG1qDnlUHlJmtfi/CCzE0Zp38=;
	b=vntTnMLFoDGk+qFGSnOQa2bb+tNDaRMFfWLFQ24rJilc2tH80obPCK2vmJK7XNwmOV4ZCX
	yU+DyrEItVx49Vrww5StzCjP6yrgiWrr0SU08abM+RhHirOHhXORAbzPH5VldWstrz2prs
	zzrWo7iHd2elGrZtx5KLha5EJf8ojkg=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X0QNkxG+;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783386398;
	b=bwNLqQNZGqBZwXTPxBi8w9oVKffiwmH+QIFRFv89sKHwm8VIpOm+Pq0vG9afdg7ZhY7j0a
	QY70yuC+HAQsDI8K16Jsnfmo1efoymFHlCtpAoMdF7S3+50FF/QGF60+PwalrMbrec+xaG
	68e2TFdoyu/TYwSl5V6N4vyNQYt+XbQ=
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-3997a448ecbso36204131fa.0
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 18:06:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783386397; cv=none;
        d=google.com; s=arc-20260327;
        b=FoLWQ77kfME0p48OCmBf8CATbCo78si/NCaSGD+kwam+77wqrwyBQtkkBl2h+FQ8Ri
         j212Yzw3UJjKCtu8Oa2gvIfAB6SzMzGAUb0LphnvAmitdzAZ03d3C6WxxlOSaC1GHOXN
         0F2NP3CdrsAAK9xJzzMXBPzbg1SaDeQSQ0sVVIWjhFtBt2IkJ7O4c3zP4wTyEHs5x/+1
         UCehGCUyRSBS9BJIdvxafz1x9kLrk7Xg6q7YDf6rjb2ZXd8hjgWrOgYFLS42BoTT41ek
         T4WRi0Hmdo2zncDTkVM/ss14nkFIv4G80xNvaXGlHdrDDbADAEECBHWja74aUHjHORSP
         ThbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5sDU6oQ6P7TaizYKEXdG1qDnlUHlJmtfi/CCzE0Zp38=;
        fh=kdohmtKbKPep8whBjvLKnjoldNimJrhkyLy/WNLtsFU=;
        b=ife3+G8scQJqh0kk25e7stEL2KqD7yK+ijJN1/ZUKZccY61G0Lta5S0nd7kRoGsuxO
         GwPF3UGX7vZh2B3HgNXQR/lRsJg1h9UkxXpmDWGRCtAAJRt/sTlFDIcyAqkWZQuDu5ZP
         lnKy4VnVxiHQ3Q30ddxBlcIVE/etBBJ7rMak3zY6FyZyorWEd4R6lrInQJIZ8nEzpQPN
         RVqteBi9mzgliNcXAC3PkkWnXF+8ujDhinHLVH+8ioS3A7l415xwXVf8QUvkP+hhLLTB
         PRfbrMenrM56FNP987R6CkO1r+/YEWj2mdG+uduxdg5/iY3kS8sPO4o/QRqwOM4hNA0Y
         +vpQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783386397; x=1783991197; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5sDU6oQ6P7TaizYKEXdG1qDnlUHlJmtfi/CCzE0Zp38=;
        b=X0QNkxG+Q4u1yj+2SrWKw+cE7DJ3b3LSIg5pFICTYLuFJn9bXdzZortAfpT4NCtS6k
         7EUw/84+nS23YOwVFYMWu0UFIV75N5tK3AmKCSqdfdZcdiEya0LzgqktY8mGM8y4Gsn2
         RQkWKuBqAAJvjqYQxnKOiDkNIfFjtdS2XzUGvVfv28TioMz+TiVhr24Zd8btgK9t1aHR
         qEhsXVzw59CPgqpXGCLPz+b0P/9Dc6ihcr8SYcXHD7bVrK6f9psBhJUYQyHis4uTGfGP
         B5btf8fBrwPapSDFpJtEsE8qicBmOPQkzOrxfqeuUB1/B5PP4Wj7IhbgGroFhrmQtiA4
         IElg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783386397; x=1783991197;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5sDU6oQ6P7TaizYKEXdG1qDnlUHlJmtfi/CCzE0Zp38=;
        b=gfWm0qY9cAJoPdrsLYyeScd40g/nmYoeooeLgjZpwpe/fla9onzJ6PoDauOb2ich6m
         dGMZ2DrXysepcUT1kWmFNkc1MwlE0RDm560XGVJBtzZtQ7iH/1wJzG9Lpr9abU54nQmF
         efnSKZOxlnA9EHpe2sqr4LeVXwJMKHsoxoxS500Zd++cj5WbjmiURI8vt6gH5+ReJsHP
         9kIhZh+N4vadvz5BfCLinU4Ct/tatHdHN0ix3MMFyYYGyeXePv+NdKwAk8KJZJwsIHQO
         LMVQUONRnNQRTqnT6MdpAX/LzrtKTUDSdbL6oUm8WEwu3E+amMVznv6CcUN/7glRgvbk
         /F7A==
X-Forwarded-Encrypted: i=1; AHgh+Rq0YCzoQ4M2iMsdUKvLB7SlScSNdFvVOK08k5O/3Wocc1mCVn/KTZyaCxHTPfvKxjGgN4gxBBD2iw==@kvack.org
X-Gm-Message-State: AOJu0YzUb/4hzJq9IPhO6qUklUKSxga/mXMX63rAai7QjiVe3z3SqMr9
	dzOXZ7Gif+pVvMBAsNFH82yFznc9JbuvUDMjwIuwloh2AK7sgvLtZU2JPYHooWNOwcY/vOgdYtO
	sog+Saku3eoVCT4FwRpOmvHx/X+GLKn8=
X-Gm-Gg: AfdE7ckI2CLIbbW/fCNu9mpP4aPFcZtDeVxVuF49UEJXXrepQ4wo5oGVlgVD/n9oip6
	t3i0eQK1XSyXH61ock1IDVmw7BIfhe4D0nyrk0A7qmXv2tJjXCnlRg8dwT0bvYU4a53uPIZHd09
	FF6Zkl9pXctUxDvFYOefoDnPEoxHw2g0I/EUql7FISWaXa5ar2tC2VoXw2u2qBBQ526mROeu54O
	aa18nnYbyVJeroab/z+l0/CjgYON/z4ZFfdGpHN/a7djs9SeqI0Yrx8f5D6DaQbpi1UiN6OgBCz
	GNVZj9bAgiD6siQdYVh/gZuHUg==
X-Received: by 2002:a05:6512:8356:b0:5ae:bb31:4baf with SMTP id
 2adb3069b0e04-5b007b9443cmr423003e87.14.1783386396730; Mon, 06 Jul 2026
 18:06:36 -0700 (PDT)
MIME-Version: 1.0
References: <20260705-ch-swap-series-plus-folio-lru-cleanup-v7-0-a028e8b5fc3d@gmail.com>
 <20260705-ch-swap-series-plus-folio-lru-cleanup-v7-3-a028e8b5fc3d@gmail.com> <69f71507-0a42-4fdf-af33-2c596657aca1@kernel.org>
In-Reply-To: <69f71507-0a42-4fdf-af33-2c596657aca1@kernel.org>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Tue, 7 Jul 2026 09:06:24 +0800
X-Gm-Features: AVVi8CebtW6uoSCTWHkq_dhSGPCkx7ytVnMkZimrVF-yiTWug6bdP8Jdl7_sNB0
Message-ID: <CAJxJ_jj_gLOR2gSEzg869CP5XHpVTjty=-y7n=PbJZrTFZU-rQ@mail.gmail.com>
Subject: Re: [PATCH v7 3/3] mm: move reclaim-internal declarations out of swap.h
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 76iz8y93ewjfk7kadefb3bx5r89w11ps
X-Rspamd-Queue-Id: 7DF21140003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783386398-839558
X-HE-Meta: U2FsdGVkX18TzfiV8o/hDKoGa7XcP/vu5aA8/ljY7UBCZh12eg4S7Nttsm49MK2jox20HzikvpnIcx1Zox89zSZhgcJZ42HjqwsPiWO7GLGQoggdN+kMru9g8iMRv2UcuGJ/ZHgjoeDuHYB2t94awU5aIKVO1gZDsmM7ga/gGXcvXZ8Al5yg6ECHmIalvojof/UymElk+ernxJGtybWMNNWpxQrCgSq8yyxUSELvzF24rY3f2Av+R931V9HKmAYdgjpO84udsBAaMTdX5AwHKgS03F0lQqDOdgoSSObQpP8FcZF/42eutDo8gQr9lmcFvH66PkVLByiwq1sBpAE917dTYZhBtY8qJfmTXqg6XieBt4kBsHhNCjd6tclnuNyYEgYOy7ngsmuRL55KO2ST58IA8cqyzwtCzGTMsN3wR/gKC7cOatVrZxrdh+LVkRn3ltuPtCKKDWWyL56B8c7hM82CllkS47Ap1UhKRgvuxPFaFY0O0bQ5f+1tjmvwznkfcXXDQUz5ibvSquDDHCauuhomGMd+aQ+oLOnyvi/pC8cfLoJ4chkSeZUy9bxx/ZKN2dCmQ2paDE2ZX5TMBlHob0SZR5T25EHF8C8RFn1Af29iKDwnG9fJ09Vbpc78RV/IRl2MZhHnMGjRLEOd7L84W008uLY2zI1jI34IaDYkVjjmgJ1vJFdsiSQW3cg/lt47XOfFQJ2eZiBkP53YgG3u4d9EtnC4QtK6HbkIjck9jW5ULDHNNzmXCxA2q/TvGx9qwN3/1b4d3U56m5vYvVoxA0LEkvapvccRjoVn4SrR15Sr1IggrdWSPMGcjqdroRGgIB2tfNt57YML94K+efK4NT7eGJrHOWub/Jhm6bHvpwTxBi+cUM4R2QSPlbYKr+CFEmF/JJO9CJMaExIbsJegxaAI/Ymb5aVQkE5uG/hmZ5j536rUKE6hpbyftaejeaBlDei9fJ6VFNjlbt9sFYm
 GgnmDcwK
 yZaJ0sr0mMM7Wmkpm4pwJf9lbDXvJA+Tn4cGCgtXIb9JV97PLhAPV7fiQM2QiTxVhpwq4reOxvStFY09Y79m+d2LqnqNWQl53nePDpSgU1Z7FNjSh48shW36YOlbrGAgeKitLO7iWdsijZ3zg1h8XIg7xmTcJVdOByyfXgxyELcA5Lju/rcZtdHBFsMRIItbBcN+XNmSiZBrBtWtixZSTVuLmKS8nsa8Jo8l0JFr4sSKRpBUi+M1ZMdNPl80P639hs6gU7V0QSBr3hoW1XvYhyGYqZf7XssYyPs+Dz4e6/zMGN9g/EoGa977mjtY3DEs1bMODAnhFO8hNAj/u0Pdurrt/nXrmLEahsvIEerlXoEeAU6TQibUxAiXqqNZyg7yvKYvDWbLSXuXpsVHnL5haXtAz09UEtlBHsyxTgpXnTvUeMpRYl/1sawMQtflw3MN/Uw98XqaWS1HI3mE8ldIEtiwtz9Qan5ymHIAe/eURXnwHpoEPr21KbbjcHqhKwQePJEUh6/IXsMKxnZJiEdcxnCMbL9AWUDspUiNgioqS1Lowt/IOFLSerrJYMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 6, 2026 at 4:51=E2=80=AFPM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 7/5/26 16:12, Jianyue Wu wrote:
> > Keep include/linux/swap.h focused on swap-facing interfaces by moving
> > MM-internal reclaim and workingset declarations into mm/internal.h.
> >
> > Leave the small set of LRU helper declarations that are used outside mm=
/
> > in swap.h so this cleanup does not need a new public header under
> > include/linux/.
> >
> > Suggested-by: Barry Song <baohua@kernel.org>
> > Suggested-by: Baoquan He <bhe@redhat.com>
> > Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> > Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
> > ---
> >  include/linux/swap.h | 75 +++++---------------------------------------=
--------
> >  mm/internal.h        | 67 ++++++++++++++++++++++++++++++++++++++++++++=
++
>
> We likely want to split that up soon, but let's do that separately.
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>
> --
> Cheers,
>
> David

Thanks David. Agreed, that can be handled separately.

