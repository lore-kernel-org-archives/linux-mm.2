Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A8DACA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 16:58:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 928858E0023; Tue,  2 Sep 2025 12:58:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AAD78E0001; Tue,  2 Sep 2025 12:58:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 773008E0023; Tue,  2 Sep 2025 12:58:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 683138E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:58:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1145F851A5
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:58:18 +0000 (UTC)
X-FDA: 83844918276.08.B38F039
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2EC3C40008
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:58:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Cr2P8Ov9;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756832296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1DqzUf+rokfxWS7zx8j4EhXH84SFLtCBUyk6VBoprNQ=;
	b=E22B7isCFIHxw1vuQd9DbNbOSKX4T4eZxVznHbUU5FTfaDXl9fpqYCgmzN+ZW+zN4Ehskc
	Jd6q2FvDdKog1SaAJWdzrcy1SWdr+rHh+69q8yxOvpeFUktdCOJV2FO991h6yZzt72z/Ve
	xQ90gAShj7i5L3t3CG0ZcMECQXx0MeE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Cr2P8Ov9;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756832296; a=rsa-sha256;
	cv=none;
	b=TIezjf9tz2ELAH0Gsyyp/UoBiT0mPJ4CMnviDlBULbOsC0/RZanvIrSUmCMH9XT+/P2btr
	ctFWpnVKo8DClFfp+WA4Pf1EmiiGSpdjhIPfVdg4iMfMLn9YFzSnYNvAUQPer2UzWCE7Lr
	YYICccPDftis9CpjdUbrUq4BOK9Ha54=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-afec56519c8so939733266b.2
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 09:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756832294; x=1757437094; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1DqzUf+rokfxWS7zx8j4EhXH84SFLtCBUyk6VBoprNQ=;
        b=Cr2P8Ov93cYlDj+QNp/G7h5HulWYcKe1qVzgV+b14zk43cGlREwZrVNJNkINQKN+6x
         S7+0UNylOUXvNtRkL5iDjxZ1podoqNgLno/JeSt8v4yZixQWoAhe5lU9HGTKZ/jn13cc
         zn+hMv3nX5CyIJsK6hPulU/aqL8xpTlSLMdlXCVdEysgyOQoTS/Jh5Ljl9/YZOiQOBkM
         APZHWOsIec92hxNfdwL1Mz6Vo5fLHkgI6RBykS1LLWaqn+iHoY//hWu5l6qLDT2ZrKZs
         /g09XvivDXyzM8/F5+ANhfmM4g+DWZ7eudUMmdFAPNFB5nvssBhEaQy+6fM/10zh63W7
         Pa6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756832294; x=1757437094;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1DqzUf+rokfxWS7zx8j4EhXH84SFLtCBUyk6VBoprNQ=;
        b=bgzJgDGdjE0gTOOLoTCEgBWGWaIJTn0T2pGqYI3+1xY2JNiPcAwRe4zabmCAqkw2M5
         Fb+Liv0KyZGt76qOTHzxnGEsY05iACyzYPc1XMEhW3uw7tq9BFVcy2zzXFoXQwKd9Ie9
         6dvoKkRylAq0FKeTPyrZf8fqPeJQwmKr++ONOd/yEb2n225J1D4aJMBPs8YA+UDKhA/y
         cn924/aH6F+EF6la1SKPSq4Hjz+cif1WsVLRUq40BQXyYuw2WDcjbJ4ayUvnSTJoC/7r
         oXs5fcewPMPvKBqv4zdPZK9jCuvOBeRBC+f75+hTn4p68tdPVHQhqm6ZM8YyZFkY6r2v
         4oHg==
X-Forwarded-Encrypted: i=1; AJvYcCVJwYRy0mhdCZ3DTVK59Y2LxSiiLGTnIJcEGQXY9yFyecU/Fn8wx26sm8yxJfLakgB2ImjalVl86w==@kvack.org
X-Gm-Message-State: AOJu0YxEH6C4rP0jGW670dWiyKzolkSClUVtopG7KWFqU5vjEn6jcnPW
	XgppUMal1l1HaGDb4mebdjaEjpB5rUQ/aAljtwRzF/hdZM0GnQP9R74tjMPQf6Oi0H9yVZbitGP
	JinFHDHt77Qc21qjxVAFf54iM0d8//qI=
X-Gm-Gg: ASbGncvjyi7AMIla8vw83kWYaAY8v8z0jWSkjUE3vEz07X2vINFBDmSNT5UzqkHFCfO
	+UIqDRJZ1XnnaFBC4e4wOA02v0ApVAOcavZMwl9ymoIXGMyEUi4tMwvBAwOzqs2qZT+o8yGhESP
	2NSnoBNAVvPryxrEdCtk87XDLk9r/mHGkagOgpXotkOjjfR/CvWXPNDub7Ttw9sSGoIlrkZJWXZ
	ocTfszFv5kwrwb3KiB+UQ==
X-Google-Smtp-Source: AGHT+IFV2QlvgK4ES5Q5hipIJ0HYZ3QNaHslPIamKNny8rmThkrXzpfyiRWIDhc6Daw5bFI/xzPGYCZrlcgOio94HgA=
X-Received: by 2002:a17:906:9fcf:b0:b04:4928:7e33 with SMTP id
 a640c23a62f3a-b0449289c65mr377879866b.37.1756832294200; Tue, 02 Sep 2025
 09:58:14 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-9-ryncsn@gmail.com>
 <CAGsJ_4xON7fYg1VvcjLOsgBb_Wp4ruC+vdA4Q496GH1jXunU1A@mail.gmail.com> <CACePvbUVK45uRPVoO3ubDfQHikebSHFNQOsMTMvJ91QQZH2HwQ@mail.gmail.com>
In-Reply-To: <CACePvbUVK45uRPVoO3ubDfQHikebSHFNQOsMTMvJ91QQZH2HwQ@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 3 Sep 2025 00:57:37 +0800
X-Gm-Features: Ac12FXz176VVDB--mL2c8AYi8BveQ5DyAiz8PB-sBrX27q13GWBnbT3NtZeBoEg
Message-ID: <CAMgjq7CADKhU8r0xg+=xKJ20JybFbXc8mkBNYxaHsp3ZvYfV7g@mail.gmail.com>
Subject: Re: [PATCH 8/9] mm, swap: implement dynamic allocation of swap table
To: Chris Li <chrisl@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2EC3C40008
X-Stat-Signature: qebnmpib41mc7hakd51bqah7ptqcrcfn
X-Rspam-User: 
X-HE-Tag: 1756832295-348635
X-HE-Meta: U2FsdGVkX19bcOGFAObeQgGTFbMdZKWtcZaz1g0I3xA9uZi/eVT/L9DRvGHLJyYkOiPHxz8gceE9MAQSQBmmWIHbgSJ38aN6SdNYgVozyPPleqOzUIC+3Y2IyOn5ByQOYc5mE1y0uzG8uLGJ3FyMzyrfC/gaG7jMjlDez+nJ+nxOS3mI/3fDhQouFrNSXPd1OqpQrtTdLiiRF1k7j3Wz2UfiZvnqYBTWhOZdpUrv0KsvtlfCSCvo2KAhsEg7yHwq4Gjzh0Z4575+oWzhFhibjiTNhyUl7evSz8irQYqcbgbHPRw3EmC7gE7kAf53GKc/qcoujAqfUUY/29dulurv5OtXvxnesUb1XPo3mb8VPao4CQGFaMH2E9hODgOSUbkSiU2sK8F7I6UTde+hUiNvBvZ+IaiBZwdePD+TmZhIvniTgwb55UMzPNnEAOu/KKY+P3uL0DLiYGondKLW0dRTkETvOKbxJjs5rtrFpTPEiPJ6vEd3QaYmmHLK5ObCvR7z9vSBXfp2cVn7SHUzpoZ2t+UzTULpZNaeiOr80iky3s75NYejhliYBoZqhBvAawK0PAmICsXvoQ/F9KJDXMb2sf10qFDde/s5LjZewNEFH+KG6tAYgbPp+mGT5f1UQoai23N/5KTxx0bmNqyFX8VkuA5dNMuYUuOwPzIWNQo1B0puzKk2U0dsLA3fN3tYtccWX/nZIqX89dzJKRLGA1LEhFCdVSS6j4NsYZd/4WSSwerlhpbfC/G3r4IpvWNRXFpGvQXLoMNb7ZrqylM8V5yO9Rif4U6B8RBZmVfj5cdHqpivqLKfqH48CG3yWm9NVwa2nqyfrKmSriMAn8mRraAdi+LACgSnFJAT05qlzK8HML5zfJXaT/I1SN1A4Z7ZLd3krE+pGVD59BIDEgykeiIjTJxQllsF67dX6+m4lyRYCz5uTrhTAxeS6Jf3lo+LloGMfE9Uaj+d/TtDQ7YU3nz
 anvaj0XO
 7E1VXqphmgBME8HEtTGU8BTYTQk+LNA9h1lOPQVVsXp1/yA2Ikm5ihsiQ4lp8JSAfcX3+4C+UKzopgd9S6QLceuX/bBV6qmf0lVJBtmuO/hAWI5WPnIHA87q94xgaPASbFv8BOf2VNmBTah5KT82SHBeemFc1NpIL2Ko1zsYTEADx/5r3pP7OjgBtJtUDNn2/qD9Rl0rghSZnbO47SbLZea1qHeGExIq85rNBzz0VzRWtXQxgZ5m1heQ0lUtuoZKaICOkjDV96EfMDSRiLmaWjKL6JtNdDX+RA7qU1wM2uJg0Ti+KOC40YZZhxvoS/EUV61F7fS788J2GACuRkisCwSM3pJRVfr3R6CevnQNrrgeh7JW4TEmbH8e31KCf+OAvBw3iEdJ2H4demFMx9ZMKKRkLY/OxVz2ns42b3NWW1Ydis24=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 2, 2025 at 9:20=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> On Tue, Sep 2, 2025 at 4:15=E2=80=AFAM Barry Song <21cnbao@gmail.com> wro=
te:
> >
> > On Sat, Aug 23, 2025 at 3:21=E2=80=AFAM Kairui Song <ryncsn@gmail.com> =
wrote:
> > >
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > Now swap table is cluster based, which means free clusters can free i=
ts
> > > table since no one should modify it.
> > >
> > > There could be speculative readers, like swap cache look up, protect
> > > them by making them RCU safe. All swap table should be filled with nu=
ll
> > > entries before free, so such readers will either see a NULL pointer o=
r
> > > a null filled table being lazy freed.
> > >
> > > On allocation, allocate the table when a cluster is used by any order=
.
> > >
> >
> > Might be a silly question.
> >
> > Just curious=E2=80=94what happens if the allocation fails? Does the swa=
p-out
> > operation also fail? We sometimes encounter strange issues when memory =
is
> > very limited, especially if the reclamation path itself needs to alloca=
te
> > memory.
> >
> > Assume a case where we want to swap out a folio using clusterN. We then
> > attempt to swap out the following folios with the same clusterN. But if
> > the allocation of the swap_table keeps failing, what will happen?
>
> I think this is the same behavior as the XArray allocation node with no m=
emory.
> The swap allocator will fail to isolate this cluster, it gets a NULL
> ci pointer as return value. The swap allocator will try other cluster
> lists, e.g. non_full, fragment etc.
> If all of them fail, the folio_alloc_swap() will return -ENOMEM. Which
> will propagate back to the try to swap out, then the shrink folio
> list. It will put this page back to the LRU.
>
> The shrink folio list either free enough memory (happy path) or not
> able to free enough memory and it will cause an OOM kill.
>
> I believe previously XArray will also return -ENOMEM at insert a
> pointer and not be able to allocate a node to hold that ponter. It has
> the same error poperation path. We did not change that.

Yes, exactly. The overall behaviour is the same.

The allocation is only needed when a CPU's local swap cluster is
drained and swap allocator needs a new cluster. But after the previous
patch [1], many swap devices will prefer nonfull list. So the chance
that we need a swap table allocation is lower.

If it failed to allocate a swap table for a new cluster, it will try
fallback to frag / reclaim full. Only if all lists are drained,
folio_alloc_swap may fail with -ENOMEM and the caller (lru shink)
either try reclaim some other page or fail with OOM.

I think the fallback of nonfull / free / frag / reclaim-full might
even be helpful to avoid swapout failure when under heavy pressure. I
don't have data for that though, but I did run many test with heavy
pressure and didn't seen any issue.

Link: https://lore.kernel.org/linux-mm/20250812-swap-scan-list-v3-0-6d73504=
d267b@kernel.org/
[1]
>
> Chris
>

