Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36540CA101F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 00:11:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F6F86B0010; Sun,  7 Sep 2025 20:11:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A75E6B0011; Sun,  7 Sep 2025 20:11:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 595EA6B0012; Sun,  7 Sep 2025 20:11:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 40ECF6B0010
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 20:11:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E7FA511B02E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 00:11:25 +0000 (UTC)
X-FDA: 83864153730.18.BEACA58
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id 22329180009
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 00:11:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="jjjwLO/F";
	spf=pass (imf16.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757290284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KIfXbnQ0TsLHys0+NJm5CN/Z6cOqD6HcADC6soVNg0k=;
	b=d9mUvbR15jvSt3aLlRkLrKAz73tLluJidpRhrdT68qRH2SRmNJPNPSDyBhYfuNVpEHG4tu
	n7UZZ4BjlSS3Tw8M1jjrLh3q0liKGYkZrBV6iGQMJuYeKE+5+R9kjCNSHVHEb15TNgeDRX
	DGN/kiCOhpAN30dmuKuYdTLpWit0vVE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="jjjwLO/F";
	spf=pass (imf16.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757290284; a=rsa-sha256;
	cv=none;
	b=p+8Zz9WBRtgpDBSxgCShAseQ50Tkz0T14iIjDCsrk4diFUIJIxVxOjZxwOTf60IVJVdKNl
	FWDcZL00TpOGoRLTQHwK7Xmcs7jhxDOgotlkAPXDon7VDjVkl46Xt25Twlh8YUqM6iTcM9
	yTydfDJi1qpt0i8mDfjkC5z8VEbizcs=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4b5f79aa443so14903071cf.1
        for <linux-mm@kvack.org>; Sun, 07 Sep 2025 17:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757290283; x=1757895083; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KIfXbnQ0TsLHys0+NJm5CN/Z6cOqD6HcADC6soVNg0k=;
        b=jjjwLO/Fxyw+4/7v+Qx4vR/w8LryGzMAVNLjsISCuL0W094kY/s3bHt4ZmoAXq/k0W
         6VoevJDXsDIWz1UBiMDthK3VJf1hW38Bo5zU3yYT/mkVZ12zxbBNiUCxPBrlV2RzbcFV
         uAVcmBY+YXUrhpI/Z8mgByOba28Oovz2pmoWe2WR8jVAVkEVIX8CJejV1m9OgPv+M1wp
         lY/l+bbg9JoDK0OfT/oZzph/DknYpLXEOQ52ckt8zdjr8wFHNg5TMdPImzJDtLs+ZK24
         O9NvyIB8OozP1KK3RBkTU1lHcxWfUUC+hOBRH26nl6uwsvtvUSKJL7Lpx7wt4wip6XVT
         Opew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757290283; x=1757895083;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KIfXbnQ0TsLHys0+NJm5CN/Z6cOqD6HcADC6soVNg0k=;
        b=R8AOvFH27KD/1QO3AUxc8gE4rh3KrEAkqb7JJoe+9EFRsslnSmeR/1gQsWNrqs+55E
         lp1UavS7q+gc7em53g4wcBnjjN1LVflDeHR4SKYhayei1LTYzj7nci/shpUbtpoG5Cs8
         BlMogT8I4D3zLC8k9flZG7lT4S2q8r17pJBjIUrmRf+gxFWvCq61WtzKe5NE7dfxWo+m
         JhdFi8IdQUUtTyGy+TsV1nWIc0qWaR20OL5jCKFLBtjzIK7wifgTfwMcx0GpJWpX/xzA
         r6EXflU/mCyxSLmmOQbpjMlvdS53dnrgLqrN9oK3YW7nGmrLHtgl61AhVsmSK1XIyFHi
         vNHQ==
X-Gm-Message-State: AOJu0YxMECE4dzLJs3c33/tDd0r4lSqkthVrhqY7QSVs8Zdqr1PvsFO8
	tKhrjrfb/Pib5QV25HlBeI4CX4N/6Ny8xQKna/MJWjlNZtnYWfgjA63pZ4AEtjID/rcVtBbG8qt
	BfKOr6GUl/g6WFqecKimmK5c7db2P9hc=
X-Gm-Gg: ASbGncvX1MZu7LVa2/ZIf8JiKG9p/iMp0uXTiHMmVHJWuWnu+lA4GUcI/T+KAtwSMeG
	NrSlkwlWWG75DZQtnZsbBqY+UlMAec+AYJwoNjmRBWOgCwntJ8R0xdmC1cKeBy2NrEZBJ+rWU68
	waqfwayenKd7B5Ppp56LeJmGmDF1FUbeyqEUlToW/PS8Ozz5Sm8mvytV+uM+WFhbDM3YEwUqH6T
	vxObwM=
X-Google-Smtp-Source: AGHT+IEAr77bv9E3qYMr72XCeV1rwW5bKa6o0t6CRiMM0ncBput0rzKkZKWmrEosGN5sE3HVuKUiS6Ux8tQayBIv6bU=
X-Received: by 2002:a05:622a:14cd:b0:4b5:dff1:89c6 with SMTP id
 d75a77b69052e-4b5f83b7676mr79765771cf.21.1757290283141; Sun, 07 Sep 2025
 17:11:23 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-10-ryncsn@gmail.com>
In-Reply-To: <20250905191357.78298-10-ryncsn@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 8 Sep 2025 08:11:11 +0800
X-Gm-Features: Ac12FXyeA-zFeeEjbGpyPLPg-FXJrLR_YT9eEqvLz_qkJCtcR4ZLOxLX4jBFvXA
Message-ID: <CAGsJ_4xG2y5fmWrdo7Y-ALx1cx8z-q0HxD5Y9CzQae-bJ9hPVw@mail.gmail.com>
Subject: Re: [PATCH v2 09/15] mm, swap: cleanup swap cache API and add kerneldoc
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: hs9cgqowwnsk9f7boz1ahg4k1jq5fia7
X-Rspam-User: 
X-Rspamd-Queue-Id: 22329180009
X-Rspamd-Server: rspam01
X-HE-Tag: 1757290284-840341
X-HE-Meta: U2FsdGVkX1/mUi7sPCfx41oIHhg794T0fMNSCXBrZZEN9Syv+hDRqweIJUtG5NlXekXfx+gneJBkM9/wfdnCJG5B5Ou6nmEEadHRK+2W6VhcxlhVOWLNR3N6Tllum+Ee45N7NW4lJPY9A/qHckzFG5B0qOyJBJ4WirsMVnb6vu5y80ne09Vqd1DbJ/FVnoQHktrn+hNpwvi+gGmUKpfk2nuJezTLkVxUuSopm6DHR4UPKHNI7Rpjz3Quf5HhMoNFjedmtWcXI98a3XkmV14h/L2LS187FmhoDl0afVEYosuP1juKiagJxOhTPV9uT9b6soGEYgVdovgIQkk3ltw8hgugvh18w2FGMDkrgw2Z17mRGi7KhRKpVM3Yv4Zy24QFVvFdCfjMRTu4Ton+VgqHIIbmQazGE2aUuep+vr3io0RsVOB+yJ+o2OiLGrAd1BBAh3PxNTIn1qgH83KS1ygsA4QScsSwnSLtzTQ9G9kaSlR+qq7tbVzsT3/OaTsS9RhEn3McXNPJqAHXazDJYlSXClGTE+Z4f8HB9BQk7sRIvbBibIre2L+90hh02aAO8Gsg773EFiCStVoebEMKZLXlEhvpEAoMXkznm2JkAQ5Z1ozu/XhvekGBTH0gO6eIb+DnJ9VHyAAJ2poFi57Xd69SpwdARz4Qnn8Px2/bz8yVBZKS4POhM0+FKWlZdPP86GeWK3yoMSPwJ7hRuzDlJHhJdDMGUhThUOxdtQzXKxQMcs4DOgSM0yZlNgyWwtNyYA1O25dO29oLRQIkdYTx3+MhLmApWH4L4m2uzO5FI1TJ8kfuZFV6fBA1nzTT6FWDpsh9AvDWKGPPWQ2bs1JIoImA2cKrO+2TV0ZZQwMl5a3D3Sfoz8XzFNmzE2MdyL+J2uHm9IPd63uAAZNXiUHaZNlpH5E3ch/fs9QeL10E2Xfx8kCle1XKJ+wexfiyZ6cp6JW9TBNq0+ODXtVGKwUCx0M
 6vSuJGiU
 PX0cTGL6DXhTNHveRcxoc4QXeOWncLqUwjJVd46NMjcB6ForiH8DpKruWWjX3BxHsi+lFeKQV1HzNNes/xAS8z8THyjnaQo9KEPLMIlTca3B26jPp8VGfGTepFO6qq59zeUgEfKnf3dDyLRwY8V0WLrE//Qvd75opX8aV5JNe1cIExpffHjO+/K5R9pnhEosENeY6uyXBcByP/3zXJ5PCci66G/BVIJ7RCpHTU8A3ztUXfQX0eL/Qg7cZZHWd687n8TO6mVVWauQorM7ztG8BuWO8fYBPmaWFc8YwkW5LbfzPLUNK14PtxinK+3Mrv31UwEHkhtGgPTq1Auv/Y5lCslEZVEQtE377uQl0JqnPsErz3dkdwdjWquav9wMAZC3bkAl1PSiDS44cGAwOJq392rwOjIeE7q/8YSpeFA0eKdpD4I8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 6, 2025 at 3:15=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> From: Kairui Song <kasong@tencent.com>
>
> In preparation for replacing the swap cache backend with the swap table,
> clean up and add proper kernel doc for all swap cache APIs. Now all swap
> cache APIs are well-defined with consistent names.
>
> No feature change, only renaming and documenting.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Barry Song <baohua@kernel.org>

