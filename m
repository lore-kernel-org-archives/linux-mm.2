Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6772CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 17:14:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F9B08E0026; Tue,  2 Sep 2025 13:14:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A3E88E0001; Tue,  2 Sep 2025 13:14:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B9318E0026; Tue,  2 Sep 2025 13:14:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EC3548E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:14:37 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 94ED81A02B7
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 17:14:37 +0000 (UTC)
X-FDA: 83844959394.23.7D51300
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf04.hostedemail.com (Postfix) with ESMTP id B801B40008
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 17:14:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FdTOElaN;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756833275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KzqnghrN1r+1VEkAjN5obE3DlhAu8tPALVKnOpzq7AE=;
	b=GGD2kmQW8M1PerPUnhdbfGA55hVvkCgU+0sHUvEYGSYS3Itzhh7DxF/AgZcecQoKpE668k
	a/Jj4ZRvESkW1uYxQxGuGWiJv7M53fnjPqCG2rPVAK076mMBhCkK2PJ3WbrA3JfEEY8XB9
	0oCi8Vrk38uuVPSU443bqBzboqSqA9Q=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FdTOElaN;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756833275; a=rsa-sha256;
	cv=none;
	b=xXNfbhjL95/Cl5tPjyzcMhUqG34KT1R5lnclSTWvFcDCYRmHM6YrND7jxHh8zM8cy3yQs+
	0nlK56o240OK5f5+m62dR05xRp0t6hGuhHs7rSibxj/Scw261E92B00t3anPyvZ5UXVoeQ
	Y80d7xqeQfjlw/r/MZxoraaQhSE+lm4=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-61cb9e039d9so11256873a12.1
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 10:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756833274; x=1757438074; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KzqnghrN1r+1VEkAjN5obE3DlhAu8tPALVKnOpzq7AE=;
        b=FdTOElaNYCq29KkWJTH76LdhE8U92MC60WMOsOsIGp97OqsuiSIXEPWp3I/MiE0oKt
         6QTI9m1f2jWSVBp0Znb8G2sUx1RcSe2WczvcHuyRNmxX4jspOdwi+9VXvLGAjkPJ6VzW
         8YXn90B15IpNKQ+OZa0eS98qISBtk7xlSeqBiiQp/ayPjHQyX5NFHQirZzPqIsO4n6M8
         T18njI0MmXTdGBWxaVR9XkLwI/aaAPQqgURQ9+9Wb4iQdm0VU2xm4/feRl38YEMikGam
         kCdgjp6hlZvTfdCylL9ShfAtuHs3osm6JRDSpBGJ6J8udibpTcr6MJXXEalhbrJ/CTzx
         TLYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756833274; x=1757438074;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KzqnghrN1r+1VEkAjN5obE3DlhAu8tPALVKnOpzq7AE=;
        b=dy/zNJNtSXvlAKZdGmcxuqxB8IEih5zrNVy2rw6lrNmmqbdYB20XMMRIV6l9xGj2/7
         f7e7cH3xcCxTmooEPpYpJA0HTxnzbcpoYDyB2lap9k7Z2OvnLZZAiyvfYACknugim2n7
         HHf5IcbFUQnTAKTZidUIREAowWDM6YNnLn4CEAcU6tk6G+NmIGuFYa7KuFacu2gk2Rc6
         VvuzLLQ/+KZEVHrDbQmzKAJB0ardfFtvFDODeYgtBtreB1JfAI//7G5R5qo/DnRuHLr0
         B5SpjGOxRGIEeJmVa163ok6wqKy2xaBFFblldTUhFV6Nr1MP3E4AXDIKFnmA/1ckmmGk
         uh+w==
X-Gm-Message-State: AOJu0YxASkct3lbiPOphN+vStme3ieoGnbHTP7AKke4ubLMBpGkdljPe
	8emmJnrFvLNK8k/Be3dNn0iYTi9UHkNlNv33PLbuBOw1C4UCyhU/B9y8mnF3q+HI+Hv2ddbsQyq
	tWQPstGuMBStAEd5yofai385aC4dbgDg=
X-Gm-Gg: ASbGncsjtc2pgnmZAP1sfpPaOlqhnrgb8uu6A34kgw1ksl9GnBVTC4ukZtGNL+f3dQE
	Ah0M1Un2pc1UTzhaYw/B2PB7i1ZqG24jKOos1fvH9fSJhyIa02k2B4k29L9CnW3267Fpy+K+h1V
	9DJFFGRjtcZpOldGrKmpwNiQmiqTUxj8Ifyt5CDJfilcKQpnTVrjM2h9a7D0Wl33OGlf5NxL/fY
	YdLq9cBnQvzU0TjMJgf1A==
X-Google-Smtp-Source: AGHT+IF0NGx8oVy2iJNx4drE5tFtZCJfWO9mL7z2enJS2tyiDJa5XKFbAOkTOsRGoBMQnxLhsnZ5IN1yxy9vDuIMZ0M=
X-Received: by 2002:a05:6402:2742:b0:61d:1d16:19b4 with SMTP id
 4fb4d7f45d1cf-61d26997586mr10620645a12.2.1756833273971; Tue, 02 Sep 2025
 10:14:33 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-2-ryncsn@gmail.com>
 <e22b8472-6d20-49b4-b49b-78f79f126294@redhat.com>
In-Reply-To: <e22b8472-6d20-49b4-b49b-78f79f126294@redhat.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 3 Sep 2025 01:13:57 +0800
X-Gm-Features: Ac12FXwxkC-P5aYCZJOxQozwt63VrhkLO_QpMo-3Ez5Wlog8Xkv16zhs2hfV23I
Message-ID: <CAMgjq7Bqffjm3dTZ+bHALisCkw7ASao_1h4ZZVM6kd14YdKzmA@mail.gmail.com>
Subject: Re: [PATCH 1/9] mm, swap: use unified helper for swap cache look up
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosryahmed@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 1dy31156q7wwirdi8gyy8cftc6jxkp7x
X-Rspam-User: 
X-Rspamd-Queue-Id: B801B40008
X-Rspamd-Server: rspam01
X-HE-Tag: 1756833275-106897
X-HE-Meta: U2FsdGVkX1+6ni9hy9EfU1Pkicf3vRRcNToH75hzumq//XVv2l0RsSNumGYOg34DzYIdCMW0Ig+bNq+0lD7oxlDHxpSmTyueU7yEaec0Jlb3H9c5fs8Oef1zSe9rWRW9LQ+hc2BrsCa0woyRec1+3gOXGX+VSFPbDhV3tL+j/cPXl9vRP+owgXugEdDFbzq/1xtm4lWcI5DL3dxHu2UAkUcIjrx8LenNh1IZJPntkx9QnaMYOBvAbarHtDTB3s/V4JzHWgpOP2LIAG/if1Mkze9wkjcFoDg9HTZObLam/HO+SFOB0DoDCRK8mpDz4iXeYVVXbEzLg//lWeNTY3+D5VkeEX5UcE5pOXynVDQUGlS/NuFLKwcsTzkHGmtx9mO7PXszK0GqypG+cDkZ7/hj9dTkV7yqeykni33Oyqv+EnyCJBaKFbvitSZpHwW/FmzKS+pl6M+lxUnuJmYhVh1WN5c1hMpPvPxFcBIIzNm+VTgeJiWM7typ06n752IHKqrX3hkfdLTSaMBqAPrWwd1ooSf4bvjI+bwTmLafuZ+GnxRIAcSLQXM50oi17bFJ3g1WbPHn+gAwaIZxwB29YFBnxi4h+MQqKnDvbdVc3oWLWBxA/1BkwCu5S8Dp8/aDk2TTuktf8IqT9o6xNqTPBp6hJHHb1XIWa1OpNFQXWrQsnGsFH8OM5rqMD4/WIBET5M3EBsflx94JMzesHLv74H/BhIZhe3txG2iEzaYd217cfM64HkPWunARnB08v8QdQT49W65biMT+Fixbxsp0HQUCpXYskfK4Wt7/tClDumbuvitqJvdv2k+hd3IjHifFTmGRORLBfqCBL0z4mMH/z/6qZr0eBAVbdq3857E+AX/ocBICayQlcuJFHhkELNIoXPxT+F93Zd3d2HodxTKesd9v/j6fcTG1mJSFr+V584h5SlgxZ3IGCS5qm06BHgE4wcK9shidYO9hn74+dRwYIds
 GkGu+xqg
 6e7igso3Y5hsrDm0XEfEtZUqY1LNAmKlDotIKJHEL1uojAQB9HJvRp0FnnB3rZhMihpECGrkPbsNtHqk0sg1tgjziUHn3x6ZQRBtitdMKMmZox2nb6kvfBtgcrpmBmpErH9tv2+VxT+OD+6tEH6HHm36ysEsM2KrFoNgs1QhDZh/idw7TJawe4wVLCYNcEqEMcwkomo7cGqDUh7OIReSIX3Tg3/yk0VzSIHk4THj1GoeesbseM+pNb9c2A04Kusnqc6B59m8u+nLdMe8vvx3/x/m2zyeKioAdv6qvPNEm/6krcVWiO0z+qnL2N5DpdwtxvMTyWe2W401WPJLt3D9HKlzEMAnKHQMiaJpxq7ZDRN3yhxb8XiCH8GJd0T9TrT89NMhdZVTKb2PctQkJiJpBRc7o5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 2, 2025 at 6:13=E2=80=AFPM David Hildenbrand <david@redhat.com>=
 wrote:
>
> On 22.08.25 21:20, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > Always use swap_cache_get_folio for swap cache folio look up. The reaso=
n
> > we are not using it in all places is that it also updates the readahead
> > info, and some callsites want to avoid that.
> >
> > So decouple readahead update with swap cache lookup into a standalone
> > helper, let the caller call the readahead update helper if that's
> > needed. And convert all swap cache lookups to use swap_cache_get_folio.
> >
> > After this commit, there are only three special cases for accessing swa=
p
> > cache space now: huge memory splitting, migration and shmem replacing,
> > because they need to lock the Xarray. Following commits will wrap their
> > accesses to the swap cache too with special helpers.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
>
>
>
> > +void swap_update_readahead(struct folio *folio,
> > +                        struct vm_area_struct *vma,
> > +                        unsigned long addr)
> >   {
>
> Oh, one thing. Regarding recent const-correctness discussions, "folio"
> should probably be const here.
>

Not here, swap_update_readahead does folio_test_clear_readahead so...

I'll try add const to other places where I see the folio is const,
thanks for the info!

> --
> Cheers
>
> David / dhildenb
>
>

