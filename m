Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10330CCF9EE
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 06:59:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 554B08E00B6; Fri, 31 Oct 2025 02:59:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52C448E00A9; Fri, 31 Oct 2025 02:59:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41B3B8E00B6; Fri, 31 Oct 2025 02:59:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 305CA8E00A9
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 02:59:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 49DEB12AB53
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 06:59:38 +0000 (UTC)
X-FDA: 84057508836.27.64D0884
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf29.hostedemail.com (Postfix) with ESMTP id 67A5F120004
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 06:59:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D3J4remr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761893976; a=rsa-sha256;
	cv=none;
	b=LyZrJqfeVHFKG/8GL7eCn04j+ZOgwv0gchfwGK2xd3Wo9ZKy3/md6ybTQfz0nOfjVv7EBm
	tYitYajtN1gTrPaxWmYx17l7oHpJ4oNrFvzxCyK10r+9YzS1igOyJ9Iw6oMEVzt/5Q+2E9
	CNjhqUC7ItEEIk0uaEsQt/ixyFGj4hg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D3J4remr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761893976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bonxoFN411G1mtJ9G7HJf6xneNKoAlfM/6PZsK2PYNc=;
	b=5QbrlQx4o8H96Eviz194B39haNcCUMPCRoUtFlvKwzRPSSEIuBzE5KEuqCzjucWVFzmQz/
	ti0g/Xj8VUT2jkznVPd88c6Fmspv079UxEFWUJQ9Re+FMDg/9G6U4ekG6hYh51ed1qlEFQ
	AvlXGbqCK+6nC3Oc7OBTn8WsM0m1tn4=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-63c4b5a1b70so4098616a12.1
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 23:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761893975; x=1762498775; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bonxoFN411G1mtJ9G7HJf6xneNKoAlfM/6PZsK2PYNc=;
        b=D3J4remrXdvFh8TtA30id+gCDJ/mA3Ye5xFL8ggWlnn/y5QxqrKZTHazrwVxNroZZg
         ItZ7zu3pHb95lBSDkhD+9HhO8qjJEmN5QxLtn2k/KB05IE/A3v3jk1kUDvH1Em4EUFHs
         fbO6UAfy3Ri9ynDAQIPqmGSaHHrJdlHAaBEzok3NBssqxhVGgM+CMVvwHGnx16wtnldx
         iysEC5gann1smbgw8B5Pk82f5ytzpC4RmkIzrs96UO07tQ8qJkk+/fjEZSZ73Z6cqSMa
         ebzJrIDtMHKYhhxOcwg0vxoS/2fd0ExJSqNvWerDmw33lgUo5Cv1kJGneyxHqqqvDkfN
         nBOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761893975; x=1762498775;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bonxoFN411G1mtJ9G7HJf6xneNKoAlfM/6PZsK2PYNc=;
        b=dSns6ZT5HgTZTrsbftmCQNtnezBj3SAYiN1SJIIZEAm222hmxcrTeUh+ome/XgqfzA
         BV35nGnQ+mZZl4c3KunQQXeVj4fK4kb3kWZTfdKTw/TsX2g9cfpJy62CtOJUo7fXY6Fk
         +jGzC0YVbRxSTOldVT1GTqqL9cfYEU34fCXuVVHFMQYAcwb3Tg1akjC94MlYaYYFZHVt
         mzBnuaYtvKU1igfAJFqyp4/JoLW64tfOrg7U7wU2SWTpyLCa+8/1QIjiSS7dofl89EOM
         a7ExM00VtzeWYOPVuL1Ts9eT4TuRYFn5ctwM6MRE3Tp8CR2gRE6V/nTOpalDJtfjC6oa
         uQ7g==
X-Gm-Message-State: AOJu0YxQI45XfiCTBO6+0Qq3qEYJQ7ybXXnm7Is4tZCquYSANngk4DMN
	GnEOqnQXcs6pqUo1X2m3CDuysbal6c2BoNUVO4Zbsh/18k7J8P2XV+EwM+nzlf8sCwzTJbteGNG
	fzSk5wO6K9T4AvH5TSFhnPVYYHQBTr5o=
X-Gm-Gg: ASbGncssYjnx6TZe2aNRY3sHOeEsKxHX44/t7jt+U0AeDY1ch04rXi28p188fO4Xlsg
	gDjxQgl8vnbG2Wr1bpYkJAhAg6CP46REEXWTexFLDK2SwuFZRFHsOdxyWptWv+vSbafA5QjCt9k
	R443W3RM9PvjLR5/J8Y+O0OEd+vxW/1PLkPAIJFqBih2bq9pC+Lrx0yvm6hJzLm47lMruiHzqle
	ycY0run5tVylklcTVrLNeczuWaKI91NY1Gj8fG1wx+ipxn4mPXmPZogXiTE
X-Google-Smtp-Source: AGHT+IHGr1hi2b+pfVxXmRcZv7A2p33ANK3bqTjSjN3kzwzBVtrMI2IKzUdQ/4oNe6YhVGFoplORFbICYJmdH9bYSvE=
X-Received: by 2002:a05:6402:3494:b0:634:a8fb:b91d with SMTP id
 4fb4d7f45d1cf-64076de1816mr1872200a12.0.1761893974392; Thu, 30 Oct 2025
 23:59:34 -0700 (PDT)
MIME-Version: 1.0
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com> <bvavihwrtkbnsqgjbotwihckxzmnhdd4e6jre4j7xdiyyeyv5o@dnnuyacthvms>
In-Reply-To: <bvavihwrtkbnsqgjbotwihckxzmnhdd4e6jre4j7xdiyyeyv5o@dnnuyacthvms>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 31 Oct 2025 14:58:58 +0800
X-Gm-Features: AWmQ_bngUH51OPE8Nr1L_1C4UgHIWE6Hp2m_74eI1jG787uNXrEWhtGWTucSHxA
Message-ID: <CAMgjq7AC9D6nOcU46ceWcLxCcPp=dezeOeaoMwsdHdSsLp85Ew@mail.gmail.com>
Subject: Re: [PATCH 00/19] mm, swap: never bypass swap cache and cleanup flags
 (swap table phase II)
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 67A5F120004
X-Stat-Signature: mj9837k3ttfx8qbtzn446gextxgekkx8
X-HE-Tag: 1761893976-554756
X-HE-Meta: U2FsdGVkX19J82cDj6O6+AelcswhaWBoRUM6mE5zkcvjd1SiH5X5tEjktKKuS+jn8XEVAv++5Ozd4QYPMX/XzrHxiXvlEV4HYZ+by94Bd2x++Xoy0xA5Ncd2z0rVFehAUmpmGVwJyHK6aL04zY9wSdyoyu/czeXPTawxPxNfd4mO2NOnQ+BFxf6zyireadoa5p1xlGceIlMz7w9CjOxE6Yl4vvtz4u/X9NvKnMGVZmUDUIUPDW/6n1/hDQeEJEF6Hr4rLy5dS3HtYNKGbTn+Ii0Eegy3siOmnX2YA9HFb6ftsLGlW4qaSvkLAbVAmiA5UGA8HxLbUNxhfNrnIClae8M0eB2RjbADCvEWwqX2iObmve0gq+dSaj1sUu7pyiC5kRXd7/pi4c1+B/ZXinQ64Ng7ezUKxSdCvAc4SJ2BD9JIf1VhacULL0v2Mm7V0ajVK+SzVWj8PWU16aLqBUWXfwqMW0gvsehCSVrz2htmv1QjLvV8A31bPIdKK/GoGiZhdGypLuvnf8engy+nckBKur+l73MZQF0VtWfc/vf8C9PO1vM06PmugnmzxcSAh+FkClM20gfuo8CnWW2iscWvXrE2p81JNy7cQOnRJJAZaAClY76hCIUSQmXW0+sadU+/XjDNZ+dXgcPg6fYrvYauzxrvE90aB6vTe3DqaFN/k0u8umqaspUL4+zTrRbsGzD2bPse5wUm9JodHgTM4awIvLnjnt/Nzk3LzaHJGuzoa63ZT0KiIFpUhT9/IPefwig9r9r3xopWUxQ2vK3/n+HEr/rD2OKpriejcJEcOXHGPN3zTHEO2j73R5RGx7RPpNtKijQhvZQ5bKOjWQLyCxpA62IM+uQtNV+qRuZp1f1+omu1z+plnKWRPyYPEFBXy4u18eP3mRj0u+9jvsjJ4fFZvTgK4N5hDNNNPRKExqaJf6GkOiINNXw9lQW1wfvIAtiz8wcDkj6F8DRfpFYvENh
 EDMnop+o
 WmB2bNxE6IPJ6BqSfdZhlszy1f9CVZsdavEXfH5dKNuGw73zzw8bT77S88GmDJ3Z2qefQCxmxuGTtz8EDjEkd0HR0l/ZDSYs+EfSSc/l/E6zw6+R0guxlAJ4PM0Gza10DeqaqmidmqEl4K+fqTwheTzkVeScIJCxJk5prynGCpuiL3eSTmXmXphLFGmD48Obb+9XhsRyUM/MDm0xVmDL4h+YMHG5I1zcZ4+aZIPt3FLWjFeplldYoObvE35XtVJOfW6miNBDC72QcHFRghRSYeBlLRS8W+dNZ6Lnhjay4c5mrLLwTkaKAdSyENJsVpAaV8TcyXujaFvc08JBcQBSCUbudblR7p/ACC/67fEWfXzm6Pfl+PM+fxCO4T7+GGmmIzBoJtVd3HsNh4/9nc67vT4XeYdNCh4IXEg/Xt7zpsq+Cdm0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 31, 2025 at 7:05=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux.dev>=
 wrote:
>
> On Wed, Oct 29, 2025 at 11:58:26PM +0800, Kairui Song wrote:
> > This series removes the SWP_SYNCHRONOUS_IO swap cache bypass code and
> > special swap bits including SWAP_HAS_CACHE, along with many historical
> > issues. The performance is about ~20% better for some workloads, like
> > Redis with persistence. This also cleans up the code to prepare for
> > later phases, some patches are from a previously posted series.
> >
> > Swap cache bypassing and swap synchronization in general had many
> > issues. Some are solved as workarounds, and some are still there [1]. T=
o
> > resolve them in a clean way, one good solution is to always use swap
> > cache as the synchronization layer [2]. So we have to remove the swap
> > cache bypass swap-in path first. It wasn't very doable due to
> > performance issues, but now combined with the swap table, removing
> > the swap cache bypass path will instead improve the performance,
> > there is no reason to keep it.
> >
> > Now we can rework the swap entry and cache synchronization following
> > the new design. Swap cache synchronization was heavily relying on
> > SWAP_HAS_CACHE, which is the cause of many issues. By dropping the usag=
e
> > of special swap map bits and related workarounds, we get a cleaner code
> > base and prepare for merging the swap count into the swap table in the
> > next step.
> >
> > Test results:
> >
> > Redis / Valkey bench:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > Testing on a ARM64 VM 1.5G memory:
> > Server: valkey-server --maxmemory 2560M
> > Client: redis-benchmark -r 3000000 -n 3000000 -d 1024 -c 12 -P 32 -t ge=
t
> >
> >         no persistence              with BGSAVE
> > Before: 460475.84 RPS               311591.19 RPS
> > After:  451943.34 RPS (-1.9%)       371379.06 RPS (+19.2%)
> >
> > Testing on a x86_64 VM with 4G memory (system components takes about 2G=
):
> > Server:
> > Client: redis-benchmark -r 3000000 -n 3000000 -d 1024 -c 12 -P 32 -t ge=
t
> >
> >         no persistence              with BGSAVE
> > Before: 306044.38 RPS               102745.88 RPS
> > After:  309645.44 RPS (+1.2%)       125313.28 RPS (+22.0%)
> >
> > The performance is a lot better when persistence is applied. This shoul=
d
> > apply to many other workloads that involve sharing memory and COW. A
> > slight performance drop was observed for the ARM64 Redis test: We are
> > still using swap_map to track the swap count, which is causing redundan=
t
> > cache and CPU overhead and is not very performance-friendly for some
> > arches. This will be improved once we merge the swap map into the swap
> > table (as already demonstrated previously [3]).
> >
> > vm-scabiity
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > usemem --init-time -O -y -x -n 32 1536M (16G memory, global pressure,
> > simulated PMEM as swap), average result of 6 test run:
> >
> >                            Before:         After:
> > System time:               282.22s         283.47s
> > Sum Throughput:            5677.35 MB/s    5688.78 MB/s
> > Single process Throughput: 176.41 MB/s     176.23 MB/s
> > Free latency:              518477.96 us    521488.06 us
> >
> > Which is almost identical.
> >
> > Build kernel test:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > Test using ZRAM as SWAP, make -j48, defconfig, on a x86_64 VM
> > with 4G RAM, under global pressure, avg of 32 test run:
> >
> >                 Before            After:
> > System time:    1379.91s          1364.22s (-0.11%)
> >
> > Test using ZSWAP with NVME SWAP, make -j48, defconfig, on a x86_64 VM
> > with 4G RAM, under global pressure, avg of 32 test run:
> >
> >                 Before            After:
> > System time:    1822.52s          1803.33s (-0.11%)
> >
> > Which is almost identical.
> >
> > MySQL:
> > =3D=3D=3D=3D=3D=3D
> > sysbench /usr/share/sysbench/oltp_read_only.lua --tables=3D16
> > --table-size=3D1000000 --threads=3D96 --time=3D600 (using ZRAM as SWAP,=
 in a
> > 512M memory cgroup, buffer pool set to 3G, 3 test run and 180s warm up)=
.
> >
> > Before: 318162.18 qps
> > After:  318512.01 qps (+0.01%)
> >
> > In conclusion, the result is looking better or identical for most cases=
,
> > and it's especially better for workloads with swap count > 1 on SYNC_IO
> > devices, about ~20% gain in above test. Next phases will start to merge
> > swap count into swap table and reduce memory usage.
> >
> > One more gain here is that we now have better support for THP swapin.
> > Previously, the THP swapin was bound with swap cache bypassing, which
> > only works for single-mapped folios. Removing the bypassing path also
> > enabled THP swapin for all folios. It's still limited to SYNC_IO
> > devices, though, this limitation can will be removed later. This may
> > cause more serious thrashing for certain workloads, but that's not an
> > issue caused by this series, it's a common THP issue we should resolve
> > separately.
> >
> > Link: https://lore.kernel.org/linux-mm/CAMgjq7D5qoFEK9Omvd5_Zqs6M+TEoG0=
3+2i_mhuP5CQPSOPrmQ@mail.gmail.com/ [1]
> > Link: https://lore.kernel.org/linux-mm/20240326185032.72159-1-ryncsn@gm=
ail.com/ [2]
> > Link: https://lore.kernel.org/linux-mm/20250514201729.48420-1-ryncsn@gm=
ail.com/ [3]
> >
> > Suggested-by: Chris Li <chrisl@kernel.org>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
>
> Unfortunately I don't have time to go through the series and review it,
> but I wanted to just say awesome work here. The special cases in the
> swap code to avoid using the swapcache have always been a pain.
>
> In fact, there's one more special case that we can probably remove in
> zswap_load() now, the one introduced by commit 25cd241408a2 ("mm: zswap:
> fix data loss on SWP_SYNCHRONOUS_IO devices").

Thanks! Oh, now I remember that one, it can be removed indeed. There
are several more cleanup and optimizations that can be done after this
series, it's getting too long already so I didn't include everything.

But removing 25cd241408a2 is easy to do and easy to review, I can
include it in the next update.

