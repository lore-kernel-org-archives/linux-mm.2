Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 262C1CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 13:46:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72E028E0006; Wed, 27 Aug 2025 09:46:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 705E98E0001; Wed, 27 Aug 2025 09:46:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 642A28E0006; Wed, 27 Aug 2025 09:46:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 544758E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 09:46:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D04D31A0672
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 13:46:17 +0000 (UTC)
X-FDA: 83822661594.30.773723F
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf22.hostedemail.com (Postfix) with ESMTP id CFEF7C000B
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 13:46:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K3PvJGyt;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756302375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LFRDMAfXrpTt084bQ+g9mSlAgJeODKNC5KadgSAUjYA=;
	b=NTKiGYe0lYJKZB0biW9wTgytZVtPDhbyrHN79fAPZCmcML0LiNI4M9LtWMxIx31icEmZqV
	OBViY01LAqIF+mMTn3aEBVKDUvDdLEU+GZ1Flw1hwWN4Tc8DMhxy0OCiSI6SG7avxTbYyD
	XY23w3q87M+ENsWEuV00yldiGgeElgo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K3PvJGyt;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756302376; a=rsa-sha256;
	cv=none;
	b=X8UUtGO+pZm0gVMyad8dI3OQp4+x5c//fR0hW6ynMdgo+sAMYRmEgumcFtTUgWtVxd/nB4
	CPu18xW/qZ2QHk3uoLxxxE9El8++mNMV1Q/GM9OyNGbU0jMpJpeRq09wehX8ZY+VdehnUf
	YCSxLU7zFKm0AlzaxTjF7lP/v4JWzWk=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-55f48d62057so3131875e87.1
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 06:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756302374; x=1756907174; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LFRDMAfXrpTt084bQ+g9mSlAgJeODKNC5KadgSAUjYA=;
        b=K3PvJGytk2iTnR45CBdrZHrZ8Vay4N6l8b1jgISQafIylFnOphQMZTjjG7RiTj8GZS
         Okzj4qlwThoPjW7qptlcb8q8GYLYIIK+wSkkSsD8Q9hLXf+YR74OBxeO0QqKFb6BNrjM
         MlGD2mmVUm/6mHNqMgmsntT9DNHPhfa3/uAC0kEJwAVYqAT/KG7ST6iHLYsZYZMmwGo5
         f8NjxM45es/hq9d6NzaPPmohkV3cJXSnuQJZgN3e0LzmMvgovhlCP7MrhsuoftmDmEGB
         eldkJifvKfuzpYRTAdBacNH0AMQmEY7aBJUf8rhX3ZQqzdfA+En3Arwifz0zjgVkRssp
         ul4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756302374; x=1756907174;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LFRDMAfXrpTt084bQ+g9mSlAgJeODKNC5KadgSAUjYA=;
        b=mieGGhp6okULdsyD0qruV4G/WG0hKc6G5GZSDR3ydGwKN1jDSkR8PGuITIEqG0EBTY
         GVyOO06ZKyiLVtRLm6xHHbqyREf8EAjuXCCXibkbzY6Z2w/p1Us5H3GoYAn2uAXYbpJW
         VQddPu5S1PsO+ZWFw06UKPdX+sb5S+CR9yufIlIPL+E9KpIkWt4ZyWt6NpKVXwbQhctB
         YGrUkAAWgYSvzm7JC+ZpvF0OLzx+snUe+Gov2Hv+1JTAl2eCqtx0zH/sr7BQn7NIY8Tt
         5fPUgntL7p9mCV+fPfJkuixPKmQHV9qTxBbmoXtvRVPsQrRoQcAvYhNqpO7Y8gLYPmPT
         VHug==
X-Gm-Message-State: AOJu0Yy3yPFrGuhHHHGT9ACyNrqG1K57Q6kxAJOgQ5AhOYNSoPfrcIM8
	ZuJILEWN70eSOR/b74pNghsERHG7ywBx3Tb9Ef82Ywr5nRAIJIQ2Dh8BeNaD83RVX1yqfdRRdjV
	1uop5SxY2IrsNBdZdLYgivFFYce0S2kk=
X-Gm-Gg: ASbGncsIZbvJ3yiQ5pghLIhlJSnF0/E+NskNlycw+2kIbV3pNsZuFxc1VThM+jywBuv
	+TVPSnAKrjiP32vR7kBwT/v+34GHHRCwA19OntkNix9KtAZpctypy0p98IynUEgkXFO8CqNmEmn
	nBNauLkIDGrtiBvcwpjo8L0SzfiK8P7liEcHejZ21G1CabvA70l7qAeVHDRTAZ4PxQZ6UYo7MYk
	acMx8U=
X-Google-Smtp-Source: AGHT+IEYHuR6gfJdiLBGSpeEswdu20gBKOMU0JDLMv1I7vqQePEP9QabRFd8h22nJHdGG91tT1kqE5UM8Ml1p9wi64w=
X-Received: by 2002:a05:6512:10c9:b0:55f:4255:36e6 with SMTP id
 2adb3069b0e04-55f425539d7mr4441999e87.38.1756302373904; Wed, 27 Aug 2025
 06:46:13 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-2-ryncsn@gmail.com>
 <CACePvbW_tkBAhj6-kQzyU2Jh-1dDy63Qc4K3RFyyA4=yt-_D5Q@mail.gmail.com>
In-Reply-To: <CACePvbW_tkBAhj6-kQzyU2Jh-1dDy63Qc4K3RFyyA4=yt-_D5Q@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 27 Aug 2025 21:45:37 +0800
X-Gm-Features: Ac12FXzqIeYmGaBF6gJppSKenyNXvWRYwIEsb0FwO90gJWmXpQVNRCnB-I1egIY
Message-ID: <CAMgjq7BYTmJ6rTod2KMHeVYZxJwQ3w7-pkarrGB+_c3a7wu7GQ@mail.gmail.com>
Subject: Re: [PATCH 1/9] mm, swap: use unified helper for swap cache look up
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: z35i68c4xdfqb4m35edtctw3ocprjtc4
X-Rspam-User: 
X-Rspamd-Queue-Id: CFEF7C000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1756302375-469556
X-HE-Meta: U2FsdGVkX19i3o2tCGEliERTMe+I9SZaJXlmhBaKpifgI1xGpS8yzOOTZa3Lj5HVM+kU9+Mu6shiOMxXuj3o1ecP7126XUcJRg+caSyLgEXUbhdFTEWOuUoKblre+JsFbu76ZDqOLwds63MCatUF8h9yIPOyLsqNiq+0REUWg3dFflvL72DFTmHBBauCjONO4LiV4GRAh4LGCN3MpAbF/X4PwPRPvJevCTXO3KaKFIs4dM02etEto9tzehrRgOugZFfW5704J6xxyhLKjFT7tyAb1A7xFeSArottu+3QgByluwTCs05xOuYWk+3si93VwVjomnkH6/zLk695XuPVxYOYyF6p15EJ4zQjCcecJSa+S3UNiSWo1kI/QVKeYPDIiAwYZigmdgrPC0zTWHDl0fjHpTjJRh1/jU3H/YJo208cTLXOLMYeq6foTjbeKpfqXA68JI002Lw41TqxclFh1ZplTtJ9z113RDfhVPrkj9JRoCpBRMHQama3as/Mi64+DHflLvn1+kZspntFk7sHbAq0MmYjZ7gIRLFuYdKb6uoexRfihvHTcDaE9FmpjSwItuP9gtQXnnm3wojAEUENOL2wejoK5WMjY4wKTmnC9Xox0pHS963i0C4Nz/nBmM0ZPOoA1q5N/ez3gAwZFPDynMvPMGD5jsyb5zauKbZ2HSUPHo6HmQFYzOMas0NKBBw2dVYqNlabPsmrqHnB58CI4nvzuA/0vXumNhxSUu1wksy6tYMj0EL7tmxcChaCbvh0RXUDy4spdDAWV5EYrBH2fJzdhehSSLEdLDYQXzcvz3AmSh//Nk5ubQDishU5towbyogrrOqLMVLNvp/Lckp67GKLunrq0euPLMXJt8G693q0+BCSFyQmXgXuzFWXKlZvXEEvYj5KDz08Usu5WqQAs8x0vQNmY4hsVxTaF5fgroSpZdLMzb4Q/jrTepmQ0S6+AP5qYEgDg4adlP1+tIT
 BorE13Ui
 q42YKIIObMbEgFb0/dpCLIBVRsO8Feu4H73PkpP5FRAhx6IDVEGeKiP54Ae+lC1iG7EJR9iIvRNo49WwWei50Nz3F3r0urQ4p2HI+E87sKXT4+DqFDR8fyBY1zaXCRQ6t8A4Xlylx+cIdnopc0Ax5fbChQ6FqmtCwv2/6dQkgN1Q29nfZl77l4WBk26Z4Qc5Z2G2epal9Jv77FF3YOCTM7FHWBs54JUBHKl2givQQSGtadU52YDtETK3HO2KEUov5TiBuirYa7TCAKzq3YX1oku/y6GNm2/EI7QsBtyJA9ezyP91x1oUhIsWr/JDSLIhZdC+pccoMZmlbIrMLW6w+/2zxxiuQ54yHff+pvv6OckJakq3Ag0FvLbYR8OU6W0204hDl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 10:59=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote=
:
>
> Hi Kairui,
>
> This commit message can use some improvement, I feel the part I am
> interested in, what changed is buried in a lot of detail.
>
> The background is that swap_cache_get_folio() used to do readahead
> update as well. It has VMA as part of the argument. However, the
> hibernation usage does not map swap entry to VMA. It was forced to
> call filemap_get_entry() on swap cache instead, due to no VMA.
>
> So the TL; DR; of what this patch does:
>
> Split the swap readahead outside of swap_cache_get_folio(), so that
> the hibernation non VMA usage can reuse swap_cache_get_folio()  as
> well. No more  calling filemap_get_entry() on swap cache due to lack
> of VMA.
>
> The code itself looks fine. It has gone through some rounds of
> feedback from me already. We can always update the commit message on
> the next iteration.
>
> Acked-by: Chris Li <chrisl@kernel.org>

Thanks for the review and suggestions. Sounds good to me, I'll update
this commit message accordingly in the next version.

