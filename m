Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ED69CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 05:51:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71F388E0003; Thu, 23 Oct 2025 01:51:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F6EF8E0002; Thu, 23 Oct 2025 01:51:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60C238E0003; Thu, 23 Oct 2025 01:51:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4EDCD8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:51:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BF46F5C24B
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 05:51:34 +0000 (UTC)
X-FDA: 84028306908.24.093309F
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf07.hostedemail.com (Postfix) with ESMTP id 08D6B40008
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 05:51:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gxARgeDH;
	spf=pass (imf07.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761198693; a=rsa-sha256;
	cv=none;
	b=wfVc/4IuzcLfWXw1Fet6jcOrc7s8XCYGGm98pclx5etLJwS3TF4Yx9OOKMpgrQVLxvK1/T
	OzOXtg9Zem6gRETkWleIGK2wNM6fIfwedAvSYY8XXJsKACmPSCZfdk0IsjKK1kuzb69g2D
	y5qjomj7jGLuymmQG5Qf7T8SM36r4VA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gxARgeDH;
	spf=pass (imf07.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761198693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+c+NbgHrZN7bWRSFiex5X5KJePzhxA+ZHYyLdwSqtl4=;
	b=4Z+AzrmLbRsHcVAzCFpZEUT6ZnmrciFNNVilgVbF8HyGj4S7rjb4OluTEzezR3A74oKhhG
	Wpf1n6BPDRt43n97Xi47J6oN3TC9PiGvsRCCp0nKMAjHsIi70BEqJ/fFVttUBDIXiVwlrw
	0gEOVny1aeHuLoe/l0RhaKtfW1MxupI=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4e89183fe47so4101461cf.2
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 22:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761198692; x=1761803492; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+c+NbgHrZN7bWRSFiex5X5KJePzhxA+ZHYyLdwSqtl4=;
        b=gxARgeDHlyGDIcGpMLZEO9F/+buCy5nVMZzTapW3UlipLknkNw/LlfO0Lb2po2qmGl
         Xd86s5VQmNRDTl6CkxnZLSCzGNL+19qU8IBiFi7MD9JrMe08VMSgLF+1omI4wJaPFn0z
         i3KkXGx7QW8M83PnILiHlMKcbnsKp/qqmnP9+htUCqdlrNwD6aJxYZQzuaIzpvQv/wBE
         xohlE39KJvXQW1R/cH6VK01sSDRaSnF59+IUvdZ5sL2D+udr0jwrK5mh65gG+1kQ9T6M
         oc+MizUuaF8XMzao9uAUweGuemMCXRs1+N1A+ZzfbrrsThyqLwZa3uBacQDtmImG0zwi
         Kg2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761198692; x=1761803492;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+c+NbgHrZN7bWRSFiex5X5KJePzhxA+ZHYyLdwSqtl4=;
        b=BWs3Dz+Z71aTtsUVqYZsT7JPkWGKm3eU2zrpZ8vbeKowl/3nNJ+O3hCU4Mxnu27H62
         YpPf5R+mCO+KRoSwwHR3WM/FOrpmfigs6uvy/9EoczouMFd54asHSqTW+35Sis7daOBp
         SyngITHsn3v2GQ/jd0/AXzby8LxaCNs3eMrrx46qzbKTp+gIgPGJZA36MyOor+0e7Ckw
         1KvX+/kVv8h/B2NsMlCnwLf/sP4sVfrtBJYngqrPnkAyo7gtPpsvj+JLJlEkfaax7lrU
         FmMl2pkR3B7QUJXYP4ErpcYpRdfLan18xMfj11wBPU0nrX0t4wm1Pc3ZDzGVa7lIIx3b
         tjog==
X-Gm-Message-State: AOJu0YxGxMSBmGzLVEpjnYiUkJRssufLr3V+A2cY5odDwNqXQ8krQU2s
	9UTE/hg/ZscQD3pBUP7dwukrhlYaGu5svMkQ4nJKtco7PMakYq3aygBGjMOuaBsRTlMsyrCfFMb
	fU4z4MNTna0I96cmym9mkYst8MGEcU7I=
X-Gm-Gg: ASbGncu0Pc6zsR6Hwl6KzrKuKo66OTv1YKAOGEbHxLWGBJWYi/MzPGVFYquNa2RGwGX
	gnKsDK/YiFjymRsdcSScueM7cMWAf4YXkqPGQmpbOgOZZDLI/NC7Oy20sdaBnVgKrJAb5RIu4RK
	Hq5vjwVq6Pqb1mfv5rjsMoWKATAxGXlPIyDsFRsxSomN0BNLRuBHfg9vzK81UbL+l37QygZzTEd
	IlzWyXoi9Ah1O1VQCelhdBmIenuxRSgznaf+14Mh/exiFs4OmOl1WAv3D5r6CP2fxZWHCxuqeVY
	sndRZa/yLqehpoLG
X-Google-Smtp-Source: AGHT+IG2Mi7vqdQCnyt6kuAmhI1WiYtd9JowlwNahGI5Sn/aHmlC3Vnbemadnf9/Q0GK32HOEsS1UsxfrANhNicTuQg=
X-Received: by 2002:a05:622a:8d:b0:4e8:a621:7912 with SMTP id
 d75a77b69052e-4e8a6217a5fmr273669031cf.84.1761198691860; Wed, 22 Oct 2025
 22:51:31 -0700 (PDT)
MIME-Version: 1.0
References: <20251022105719.18321-1-ryncsn@gmail.com>
In-Reply-To: <20251022105719.18321-1-ryncsn@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 23 Oct 2025 18:51:20 +1300
X-Gm-Features: AS18NWB1yQIOT_rwx8pqsyu31KsQcKncmHw5kIG8Uc-XrpaBEO8kE7dzlBnI0ZI
Message-ID: <CAGsJ_4zKcxO-Tacy0jCZSs83+fGsgqQYNib9nCXoLTuL+hdLxQ@mail.gmail.com>
Subject: Re: [PATCH v2] mm/shmem: fix THP allocation and fallback loop
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, 
	Dev Jain <dev.jain@arm.com>, David Hildenbrand <david@redhat.com>, 
	Liam Howlett <liam.howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Mariano Pache <npache@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: gmo4x15kjzkb6xt9gqzjd4chykcyh7b3
X-Rspamd-Queue-Id: 08D6B40008
X-Rspamd-Server: rspam09
X-HE-Tag: 1761198692-944819
X-HE-Meta: U2FsdGVkX19ULiD+o7Si4nN94ni63NnPS9wUD1aX402E/Q21Hy63MYCTiSJxUNRkePzSqe5ViEjNZi080pNNF+b9kJoiJMoDdr+VcVFwsNFNjq9Gmuo3gpU7JrPV640ADUU1oqsaxh4x7Z0xh7s2vcszkp2EqbJfC+Dh5cBXE4Qcqp2a7+m2KUhRG9Fp9lptblyMeuWg/V7e857RBhXt0uj11xmFtyZEQKnbelqxUtuDiuxTcWSspZq/HSpMgC8IBAjij/WJz2IfzWKn2SVInQ0oNfwREkVYM5j+yjLEKyM465T1Nrg9MPyBJ9q7oJdIcz0CC7OAq7Iz9hNdXkGCXRjI5wlstxs/lD6yqc/v9jhiH8nqi+V+Fc8paxhBYBVjrlXOPNeyy1y8eLm0GnzIxjGQMInavcWL22bHqF4+7WqcK6XnZN86wTSXA84Dd1ZxRFD+lbhN8lI4fvtGV/E5sQdFLnqfI65JQ88XcTRVOtHL3/b7+Bslwnc1HUjMD1SDXaXtaorLtcjKudUAQkEQKDS/FD/ZwemZrGJCeVjk3lhzjbiSsd/D//wQN1Ue87OSn43+Lag8LqbQeUa6o9W484NoQ08zRSiqgEo6ckpIfboFI/7209UDAzixB4UQd8hIkdjW2SnLUCI5bBrZvWfCr4kxGFN6UoRSRe7M0nBlucD2qJyFA7l1HCBA/47FeAXu9aDT6G5wwrZudGkmIxQs7OtqMQCkjugKgPzWoidURCBdZJoLgbbBUFDQVnILZrNwJk+3CdEs1DITZaB0/i/vI8d2QFlz/ubw1wvc10x7aeI3LCUjqdVkQM3wtPqfLZaiBnQpHUQ/kCpwYxwvyotc+ryc9oFYGRl+yTfqNTw1K/nW/IzXx+gDQtr7kXE8QrIr6vkW/o5Hx+lHv5W/5wW1Bnt3sVzE39l9dsn5yDlddI2eCz5M/GPgbq+AnDMu1iZd7x3AvZrstuLTbUUKb6y
 R9I3Hs+K
 EVvRuG+CGpVZBUa8C39KB6UqLZLSX06HnesPkffECs3+KEiI0H9QltRUCRT3qcZTJSJAAhgWfP1DnO2cbdgkk8eRsBHRoIUojlKDtJIX2G4H3kI64eZFrZUOgC+MKEOdQzlJIpN53L0wWjGO8/2sWTuodHv/jn4iI0BNLRi1jaM4o50mOSKBp51yyDgvk/G94cyK194yRgeyK1WkEwXVlOowrqMIwayMShK/MgyLaH5bHPicAyMmSa8rPyfYS26rbhwszsnH53saCWWTxuggmkqdv/doWILevGxBUz9VSUB9qenZI5aS74ED4gjaJqqOM0KssIi9tg4dmo17bzdPMdodbNeFxyHUhWkBtaT9hQ2mrqF6DKa/rIFJ7p9hdrAnJnwHPEWTKMD5TBTk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index b50ce7dbc84a..7559773ebb30 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1895,10 +1895,11 @@ static struct folio *shmem_alloc_and_add_folio(struct vm_fault *vmf,
>                 order = highest_order(suitable_orders);
>                 while (suitable_orders) {
>                         pages = 1UL << order;
> -                       index = round_down(index, pages);
> -                       folio = shmem_alloc_folio(gfp, order, info, index);
> -                       if (folio)
> +                       folio = shmem_alloc_folio(gfp, order, info, round_down(index, pages));
> +                       if (folio) {
> +                               index = round_down(index, pages);
>                                 goto allocated;
> +                       }

Could this be a temporary variable to store round_down(index, pages)?

>
>                         if (pages == HPAGE_PMD_NR)
>                                 count_vm_event(THP_FILE_FALLBACK);
> --

Thanks
Barry

