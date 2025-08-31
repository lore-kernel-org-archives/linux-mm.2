Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A89F3CA0FE8
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 15:55:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF6648E0003; Sun, 31 Aug 2025 11:55:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA7088E0001; Sun, 31 Aug 2025 11:55:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABE588E0003; Sun, 31 Aug 2025 11:55:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 92CDC8E0001
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 11:55:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 35F3F1A04FB
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 15:55:13 +0000 (UTC)
X-FDA: 83837501706.27.240EF99
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4FFE940008
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 15:55:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="cHSx/Y0y";
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756655711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vu7OB5WCFRiIsU5hPqmzDabAlwcJjVGYZr9cnnXb0ls=;
	b=McaK6RQ0QWP0ywZuaPZTBY0DzvvRfktry6jeMSsdV1iiLBym8yaBk3jOd9UCTUP1KfirMd
	kZQnxMr0S3AUCBlqazBgKvXsYhv0OsH+Z9edGBZ8rzlnOwn5GibpFjo+6x7jwLOt6JzZoK
	FtI+/HxdnLSnFevFkJCfNPSZ9K418cY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="cHSx/Y0y";
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756655711; a=rsa-sha256;
	cv=none;
	b=yUrMmYzjYwdSVmsZpm8YbBq/yJKDfmwzoFsnB7NSxXBI6GZf0OzkLlrIJ8PPSVxmSTqNd8
	yJtbBymx5Ktt+8TNuFAQKDGqnmoUUcJ1d+wg2YM8MSvvyGn7JDnST2uryAZbLToVcgKfXK
	TE1MDL3hBGzK+XJttaTEhprlnvm4b+8=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-aff0775410eso290695966b.0
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 08:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756655710; x=1757260510; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vu7OB5WCFRiIsU5hPqmzDabAlwcJjVGYZr9cnnXb0ls=;
        b=cHSx/Y0yilE/Gc5UOKAvslRgy9kHPGmWEDCwWdHfL0GTjLtqHmucoS5vzvUIOGrZ6i
         WppeixhTUC1m5MDDJPVOyJSYpuT05MpWQqwh9alV0OaDbyZNsQtS5LL0onj2kOoktqe8
         /NolDHmNGmYw1yBpzDhxe9oyRu1lmZRhcJNXPu+Q3EJBOcWfDvQqK+n6NsfLay+J1QHZ
         SrrpU1aronfLu0Eob6s1f5rTmM55U3GtGPS9cjMNuDdda47GTPQcDPL2tPpdzmvLkPia
         t/esY3g9sPRpCMtNT9ULDcNUgS6iW7QrMH4ZX/euWALK3dh5bqnwn/LTf1+HsT9ciXVn
         70kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756655710; x=1757260510;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vu7OB5WCFRiIsU5hPqmzDabAlwcJjVGYZr9cnnXb0ls=;
        b=LIDp5/JL0B0VpgkouruvzOS9+Im6dvHJ7BTEndHLi2ZZfLN+c2U1vKWHVkpyRnfAY/
         OJNPhMIdyK7oVygPfjXLZJiIx8RUJrfsWHfnBzVXS8M+sCFI32yiRKOrQoyJwdKJ05sA
         1P5bCNmh3r4hhEVC0cwl76grYCpnfxp/MiKQ7NeI7+EqlCRkoTmYzgxYh1F4RDLgpQRV
         XmaNIgcpRJZqVCzDAZv9mN6KwS4xQB0XmaI/ODWuTNbkQpIXXemRKrKNV4/LLxs15KMi
         QT08avNg++qKm/YajWybpVeDof3h1EwMvewgQSd/0/K8JprXM4qNAoni2268CD5PFhhd
         6XiQ==
X-Gm-Message-State: AOJu0YxIcraS2rIlfnA0boUHmkPXJ/9ucX9K/OBY0oDWhsjdm1M3XCuc
	GCqkUDLsRI/vYSWaxb6uBLD9jA7Dr09gvxMxlvKArZvPnXTER/2SYhOr5s9uRWoLigQgwFaG7Nd
	3u+9hOF8WYJCuJT0tvITt74V/RqRC8vE=
X-Gm-Gg: ASbGncsc4F6kNydKZep4ARmag4K0mYi7goS+3g79OJUpLMieGv5hcBYahsfn64L147F
	wnBHnOKx95yGulYkSXOa6MKVtAiMfdbKUqJvEWzgzREG537tulJpiUCyGdlbCLbPP99QVOpH8oG
	CpOmvquP5fi52P2Fg9FrfOiJozYFP9Uww3EJ+c+2rdMJbWwV8A3x2+GKcAh79il5ebL4kpRMWoP
	PdjFFA=
X-Google-Smtp-Source: AGHT+IGWU/wsTdjnZJPNKAQvWWzNnWEbPVDY8n7oO8LLEmzwufwLGHZVPqASiHpxwHCaSZENKL1K5d3MELtSENT5sCA=
X-Received: by 2002:a17:906:4fca:b0:afe:ac57:f0be with SMTP id
 a640c23a62f3a-b010832f5famr574635066b.31.1756655709313; Sun, 31 Aug 2025
 08:55:09 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-8-ryncsn@gmail.com>
 <CACePvbXB-G5vhoEt87BZcjDZ8kZWo3mZtAZ60YbR_gcjnPz29w@mail.gmail.com> <CAMgjq7Aznd7=m6JTNGM4EyFj+6pqHTRBCo2hsQL-cKi0LZggOg@mail.gmail.com>
In-Reply-To: <CAMgjq7Aznd7=m6JTNGM4EyFj+6pqHTRBCo2hsQL-cKi0LZggOg@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 31 Aug 2025 23:54:32 +0800
X-Gm-Features: Ac12FXxioZkcEglVFpgNmclPXqeabDsMMCPYtygfFc3dkhi9MFV7CelcKDtuJqM
Message-ID: <CAMgjq7AdauQ8=X0zeih2r21QoV=-WWj1hyBxLWRzq74n-C=-Ng@mail.gmail.com>
Subject: Re: [PATCH 7/9] mm, swap: remove contention workaround for swap cache
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org, kernel test robot <oliver.sang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: a75z8mugtte1gi3doxcasac9mxzsbyow
X-Rspam-User: 
X-Rspamd-Queue-Id: 4FFE940008
X-Rspamd-Server: rspam01
X-HE-Tag: 1756655711-504187
X-HE-Meta: U2FsdGVkX183FQ5eTGh8K5vegESOxLsySMSKuvSfBf/BQXAGWiBBOBS5rgCL6cd/B6h5VtlL4dgr5ABI9PRdSJpQ/ddGq7wD4F5U9vmz4/9ZsADTPSbMXKX2JYBhp6iGi4Ca1x90EsGhQvvXxfWCEb25s1sfTaXU/7HY/4qFKUfAZJCW9C9MBNZnHcxQw5XTZmmjJs3jlhGpKnMhLqPph0HA8j5/l0IegYswBJdSVXzRtpohOlZVSMld4ZLn793FG0bBvQdyC00l0uZ2LlGfbdcNOrpWnL2zvUyZjknu/ylVbT45hOBydS7v0dAiFtdSBgIfXGAMK2a9MNPVazg04UVaAlrfSdcHAhWtMyaaIwuyLo5UXJVGmKT5pwt1y21F2zKIZ732PwkTrfllc4uusb9X+ymYdrKvkp5y0fr8+ilwfeH4foIeDNf/S4SaNtsGXAVqGdIDJKQfqewPWQEWl6poIAcXsG2LRhDy6qkGgDeMsHrl2XHUUbTdHZ+J2JMFVJwsMSnrsArWGslngmKN0cVbVSsyqSkwsiAsh6xbS75ditZ125zIbQzwlToS5QfMLOCaZE1Rn1Oxz+PGTB2UgcAbVnGaCxP6/a3SwF4uuJ3SXM1hxukg3x6Yq3Fb1TkQpT+HG7FXfUPIMNRLl6A/nSCY+IB7Ck9v7mnciS4DwGU2/FDWQbBSGwTlMXo4dMUdv4mOc4BaglpR2I/K0RQGX/tLxGqNmB8jZ/mu1aw5XOJs45A0Bs250fwDPFowtFxgdD3151JqQh0cB+MZnPl2JHB2K7ASqa9+a3lIW1IKUgoyYeYrX82JNCuMas2LH/6TS5UGuhui8m7n3tEyP+EtY508aoE7X1BA3JGWGsrsitdQ4RyA7Yb4ksl59gM+CzqntNTausgstV63VYWsJ/q3u2ZHXZCDmCUW6TznyDlufWM2+1jQxjpiRH5Sda9IZXpufC0KRYW564soNkgeWtW
 bKk83zku
 wjl6BttViramzRCSM04hWmxKQJ1PdiGsMh/I44N6dT5R2qDIyuMF6ga4Dwt+4evKn0pQ3CGNzU+vNQuOBexTHx/xGfHgcy6TnBjEnJMiwnlipetpGXGP4moKWhGsCQlUjYjuJLj79jrmV8EnXnBweCGpAAL9McizJ7kTpe7F3iFZyPvyeI5f3aMLlf71iMHmOwZXV3UDtMLpQWOeXMo2/FiErhafkGwIqGo2CMKeIrazFvGfGgbBr53pIHf12mHwoUB/dY2h/OANyh1TayLp0FqmI6p1TuH6shbYee/+5H/19L/7A90kXyGdN3ey5pi1BtUjX3VrZJcppaYV+LjeNgyj+hEI9cpq338vkLM9U0Cglq3A/ljfj1uEJPN/FLBcQJLs1AcfNrE17mZmNhTb1E5eWHhYzzA2vloG+Y5n2kW3UvR5KYHsRbR9IN+DkNCCEvz5ZhXGfJ/gQ+tQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 30, 2025 at 11:24=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> On Sat, Aug 30, 2025 at 1:03=E2=80=AFPM Chris Li <chrisl@kernel.org> wrot=
e:
> >
> > Hi Kairui,
> >
> > It feels so good to remove that 64M swap cache space. Thank you for
> > making it happen.
> >
> > Some nitpick follows. I am fine as is as well.
> >
> > Acked-by: Chris Li <chrisl@kernel.org>
>
> Thanks.
>
> >
> > Chris
> >
> > On Fri, Aug 22, 2025 at 12:21=E2=80=AFPM Kairui Song <ryncsn@gmail.com>=
 wrote:
> > >
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > Swap cluster setup will try to shuffle the clusters on initialization=
.
> > > It was helpful to avoid contention for the swap cache space. The clus=
ter
> > > size (2M) was much smaller than each swap cache space (64M), so shuff=
ling
> > > the cluster means the allocator will try to allocate swap slots that =
are
> > > in different swap cache spaces for each CPU, reducing the chance of t=
wo
> > > CPUs using the same swap cache space, and hence reducing the contenti=
on.
> > >
> > > Now, swap cache is managed by swap clusters, this shuffle is pointles=
s.
> > > Just remove it, and clean up related macros.
> > >
> > > This should also improve the HDD swap performance as shuffling IO is =
a
> > > bad idea for HDD, and now the shuffling is gone.
> >
> > Did you have any numbers to prove that :-). Last time the swap
> > allocator stress testing has already destroyed two of my SAS drives
> > dedicated for testing. So I am not very keen on running the HDD swap
> > stress test. The HDD swap stress test are super slow to run, it takes
> > ages.
>
> I did some test months before, removing the cluster shuffle did help.
> I didn't test it again this time, only did some stress test. Doing
> performance test on HDD is really not a good experience as my HDD
> drives are too old so a long running test kills them easily.
>
> And I couldn't find any other factor that is causing a serial HDD IO
> regression, maybe the bot can help verify. If this doesn't help, we'll
> think of something else. But I don't think HDD based SWAP will ever
> have a practical good performance as they are terrible at rand read...
>
> Anyway, let me try again with HDD today, maybe I'll get some useful data.

So I tried to run some HDD test for many rounds, basically doing the
test in the URL below manually. Test is done using nr_task =3D 8. The
HDD swap partition size is 8G.

Do the preparation following:
https://github.com/intel/lkp-tests/blob/master/setup/swapin_setup
(Make usemem hold 8G memory and push them to swap)

And do the test with:
https://github.com/intel/lkp-tests/blob/master/programs/swapin/run
(Use SIGUSR1 to make usemem to read its memory and swapin)

Before this patch:
Test run 1:
1073741824 bytes / 878662493 usecs =3D 1193 KB/s
33019 usecs to free memory
1073741824 bytes / 891315681 usecs =3D 1176 KB/s
35144 usecs to free memory
1073741824 bytes / 898801090 usecs =3D 1166 KB/s
36305 usecs to free memory
1073741824 bytes / 925899753 usecs =3D 1132 KB/s
20498 usecs to free memory
1073741824 bytes / 927522592 usecs =3D 1130 KB/s
34397 usecs to free memory
1073741824 bytes / 928164994 usecs =3D 1129 KB/s
35908 usecs to free memory
1073741824 bytes / 929890294 usecs =3D 1127 KB/s
35014 usecs to free memory
1073741824 bytes / 929997808 usecs =3D 1127 KB/s
30491 usecs to free memory
test done

Test run 2:
1073741824 bytes / 771932432 usecs =3D 1358 KB/s
31194 usecs to free memory
1073741824 bytes / 788739551 usecs =3D 1329 KB/s
25714 usecs to free memory
1073741824 bytes / 795853979 usecs =3D 1317 KB/s
33809 usecs to free memory
1073741824 bytes / 798019211 usecs =3D 1313 KB/s
32019 usecs to free memory
1073741824 bytes / 798771141 usecs =3D 1312 KB/s
31689 usecs to free memory
1073741824 bytes / 800384757 usecs =3D 1310 KB/s
32622 usecs to free memory
1073741824 bytes / 800822764 usecs =3D 1309 KB/s
1073741824 bytes / 800882227 usecs =3D 1309 KB/s
32789 usecs to free memory
30577 usecs to free memory
test done

Test run 3:
1073741824 bytes / 775202370 usecs =3D 1352 KB/s
31832 usecs to free memory
1073741824 bytes / 777618372 usecs =3D 1348 KB/s
30172 usecs to free memory
1073741824 bytes / 778180006 usecs =3D 1347 KB/s
32482 usecs to free memory
1073741824 bytes / 778521023 usecs =3D 1346 KB/s
30188 usecs to free memory
1073741824 bytes / 779207791 usecs =3D 1345 KB/s
29364 usecs to free memory
1073741824 bytes / 780753200 usecs =3D 1343 KB/s
29860 usecs to free memory
1073741824 bytes / 781078362 usecs =3D 1342 KB/s
30449 usecs to free memory
1073741824 bytes / 781224993 usecs =3D 1342 KB/s
19557 usecs to free memory
test done


After this patch:
Test run 1:
1073741824 bytes / 569803736 usecs =3D 1840 KB/s
29032 usecs to free memory
1073741824 bytes / 573718349 usecs =3D 1827 KB/s
30399 usecs to free memory
1073741824 bytes / 592070142 usecs =3D 1771 KB/s
31896 usecs to free memory
1073741824 bytes / 593484694 usecs =3D 1766 KB/s
30650 usecs to free memory
1073741824 bytes / 596693866 usecs =3D 1757 KB/s
31582 usecs to free memory
1073741824 bytes / 597359263 usecs =3D 1755 KB/s
26436 usecs to free memory
1073741824 bytes / 598339187 usecs =3D 1752 KB/s
30697 usecs to free memory
1073741824 bytes / 598674138 usecs =3D 1751 KB/s
29791 usecs to free memory
test done

Test run 2:
1073741824 bytes / 578821803 usecs =3D 1811 KB/s
28433 usecs to free memory
1073741824 bytes / 584262760 usecs =3D 1794 KB/s
28565 usecs to free memory
1073741824 bytes / 586118970 usecs =3D 1789 KB/s
27365 usecs to free memory
1073741824 bytes / 589159154 usecs =3D 1779 KB/s
42645 usecs to free memory
1073741824 bytes / 593487980 usecs =3D 1766 KB/s
28684 usecs to free memory
1073741824 bytes / 606025290 usecs =3D 1730 KB/s
28974 usecs to free memory
1073741824 bytes / 607547362 usecs =3D 1725 KB/s
33221 usecs to free memory
1073741824 bytes / 607882511 usecs =3D 1724 KB/s
31393 usecs to free memory
test done

Test run 3:
1073741824 bytes / 487637856 usecs =3D 2150 KB/s
28022 usecs to free memory
1073741824 bytes / 491211037 usecs =3D 2134 KB/s
28229 usecs to free memory
1073741824 bytes / 527698561 usecs =3D 1987 KB/s
30265 usecs to free memory
1073741824 bytes / 531719920 usecs =3D 1972 KB/s
30373 usecs to free memory
1073741824 bytes / 532555758 usecs =3D 1968 KB/s
30019 usecs to free memory
1073741824 bytes / 532942789 usecs =3D 1967 KB/s
29354 usecs to free memory
1073741824 bytes / 540793872 usecs =3D 1938 KB/s
32703 usecs to free memory
1073741824 bytes / 541343777 usecs =3D 1936 KB/s
33428 usecs to free memory
test done

It seems to match the ~33% swapin.throughput regression reported by
the bot, it's about ~40% faster with this patch applied. I'll add this
test result to V2.

