Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C939BCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 04:17:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29C488E0009; Mon, 10 Nov 2025 23:17:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24D308E0002; Mon, 10 Nov 2025 23:17:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13BCD8E0009; Mon, 10 Nov 2025 23:17:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0460C8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 23:17:32 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8D8F28870D
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:17:31 +0000 (UTC)
X-FDA: 84097017102.25.F8A0573
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf29.hostedemail.com (Postfix) with ESMTP id A2A8912000A
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:17:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NuK+Hub4;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762834649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+HDPvzmDF4pSMrTj/Ew9l4F35FfJ+clQaJCnh0ZMShI=;
	b=PzyZpT/RGlC6G2uSIFOEJh2VXup9e77kGjFEXlFAmDjVKrrT8owEH8ITXOcjGguj8Hk6Lj
	+NNSCuIfM0My23aInDDZ8szI4v1soKP8qVI8JuR99T+XTdaZ4DqB28rQjbG77/2KzmlGwf
	to2nEM5QrSxf9UAbT1+ovvU3w+MH4yY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NuK+Hub4;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762834649; a=rsa-sha256;
	cv=none;
	b=A6h5yBik4t3fSYYk8LV8bqcCreP/VYSXuuqFFL39X4coFvQgINB+DxalFp84RRgfZn8qAB
	OzUznl2ICw5EPZ8xRVkySdE2sSSgJDQW6p3U4C5dIN0wWlzSKmWRmYWND3uJ99Rih0vTCe
	IjusRu1Yjchv3oP0okP2G4bR651Ti9s=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-64074f01a6eso6932700a12.2
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 20:17:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762834648; x=1763439448; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+HDPvzmDF4pSMrTj/Ew9l4F35FfJ+clQaJCnh0ZMShI=;
        b=NuK+Hub4yeYbFblTcKjFnHK7A18nicbsyh0YBKEf5ReooKvMKcX8CktfCoRTgaFp7P
         IqrJYMFXf48mDjlQVZLalC3qTZVx2DXyI7BWyCUn1VHuMqYzu7xkHL4gHmVNRY2/YG93
         hAzZx3GjHewRCk++H49eTQ81ynDUgOp0fFMoEB7v11vGTObYOg+5BX9Nf58v38u1DQ07
         624ETyTCZ9fHyL5X7pz685wlpnuA1TJHSz5puYOYqDCjs4/DXC6+NX5BbHYvHpw95Fdd
         F6bCd132lX0//622pRdBwzEgN1KgPwBmMr++tG389qPj3GAslRrWrk+bigX5W6k8TIjp
         ZIng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762834648; x=1763439448;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+HDPvzmDF4pSMrTj/Ew9l4F35FfJ+clQaJCnh0ZMShI=;
        b=nYIH+9cFyhwQUGpO7enT5HM93RWs4a8F5wFNJuS6T3SRzvCX8zyuNN+4f8aKcGahUF
         5LCKifuKzhT9GUWBE6guaEQGcr5M5Lq8ySfjv+OcIVRIoNdr6rd852RKid5Io7arpdJi
         9HFp0RVNAnJHHsDm1c8T3gf2kIhnn1vbwjhSCG6yXCU4cCy30gSmBJSQgdr+qaGlrEAa
         KFkqN1+FqfG+8Y7lPvq6s/up/5CX0h0yFU5ntkSZCmgLN53EtMSNRP35S3EIWpHe69Vt
         GC2sl261SCHfIvzubrrHebBf9btykai7BIDVcS7TQq8gsDv3BUXYUDVdd6vG699kbDnW
         Cgfw==
X-Forwarded-Encrypted: i=1; AJvYcCWPV2HR1MZvsF/LQwTKx71yweWlE20898D0g1oarpie1ZIn2ReoOvgzltQb/8KClVEgWr4qqOElyQ==@kvack.org
X-Gm-Message-State: AOJu0YzRA3nLYa7WUPvyPw+0aTLmTi+4gA3hMcwv3w+NOdG5HJB2GCAk
	tCuziRRMZKGtxXAxyOhFZW/J/PwrHLUK8odJ/H+7EwVQa4dj8b0kDmnrzbn+83PLdgCh/QuAf9s
	0P+/he2COOiNnkHVbpayw7R2pNr8dKpM=
X-Gm-Gg: ASbGncvCUauz0ZA43mNrEZCYboqNM4v+gdyamsyfQ/gndvHMMv1xtm/sqT3JJ8/CDEa
	xtGsaurb1ETC4XOudMXSFs/47gTtLE08ufhoBd3XT71algHPTXw8VTiHFAufAiOOBz7/StEV5Gb
	ataEDDApyvXwx94TdjOrW6HM87J1imtKeT9XFj3zLVvArLnPNhE0DT/ocyGbL131Je3th8VnLKJ
	inT3uWRMlBE8KaGsDWPec1nA1lZQ6YWxBm600Nk+Lr5Q9fdU//ayr3liZoO36ZYn+wJ5F11SZM4
	PXmppvL7X2As/xpnk0qgwE7qCLICB9VUG5QXcw==
X-Google-Smtp-Source: AGHT+IFxtJ5LUfVYMfACvoc6qLigR2M037K7mxtxeAfO+UoGi5MaKsWG6FcjLFJ3BqqcytYnHVwzOPfWzu221I34nu0=
X-Received: by 2002:a05:6402:510e:b0:63b:f22d:9254 with SMTP id
 4fb4d7f45d1cf-6415e6edc1cmr8920410a12.23.1762834647589; Mon, 10 Nov 2025
 20:17:27 -0800 (PST)
MIME-Version: 1.0
References: <cover.1762621567.git.lorenzo.stoakes@oracle.com>
 <CACePvbVq3kFtrue2smXRSZ86+EuNVf6q+awQnU-n7=Q4x7U9Lw@mail.gmail.com>
 <5b60f6e8-7eab-4518-808a-b34331662da5@lucifer.local> <CACePvbUvQu+So7OoUbJTMLODz8YDAOgWaM8A-RXFj2U_Qc-dng@mail.gmail.com>
 <3c0e9dd0-70ac-4588-813b-ffb24d40f067@lucifer.local> <c9e3ad0e-02ef-077c-c12c-f72057eb7817@google.com>
In-Reply-To: <c9e3ad0e-02ef-077c-c12c-f72057eb7817@google.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 11 Nov 2025 12:16:51 +0800
X-Gm-Features: AWmQ_bmvt7re6_XRmXvUlAJCOhI6cJA0pVFvbyH2-3YOeH3XrYzunQCqAT7qyRY
Message-ID: <CAMgjq7BT8+Vs+7=G5PUS5wsxAhWVzDTGLX5g3mXMpTJ8PFSbxA@mail.gmail.com>
Subject: Re: [PATCH v2 00/16] mm: remove is_swap_[pte, pmd]() + non-swap
 entries, introduce leaf entries
To: Hugh Dickins <hughd@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Chris Li <chrisl@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, SeongJae Park <sj@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Jann Horn <jannh@google.com>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Pedro Falcato <pfalcato@suse.de>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-arch@vger.kernel.org, damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A2A8912000A
X-Stat-Signature: mhxznu3hoohz79oyfnnemiom43w7dsjz
X-Rspam-User: 
X-HE-Tag: 1762834649-82170
X-HE-Meta: U2FsdGVkX19YuxJE+YptTuF9YzgmeEgNB6Z/nyGAxOwNTgFFRwHuEBZxkBDWnajAe2WCfs0sTKrwawSZAEpFtW2l3Fo+UzTmeQu+4ZkADQuBsXfsk3ufTZ1d8AUwWNIex+zh4nZ0btM/2CseNrZgm+FlEqXbjE50vNLD23s7NMVjymh2+jLpzhrZO/+CKexOCQD+degFCuFAL8fjPB2vEnEx7fQ0+BpFgBF3WqXJWInIZ96vbk0ZFawJTZEMNA1cwwk22UeJeS+Tnc6x/t2MdSEc/I9/rHMtE2ZyacjErlsz5B8kx1p1aekV0VD6eZvXHREt108rKecjW6M1hKR4VySTTVcbqDvf4cp5AefOAXVPrOxTKn8np95tbqKwB1dcm8vBiwOnEWdjGvry6x+x908M900CEK95F5Je/aXz+BuhKsDvkOOdkMjTeXFbKjsWcNqt4KJjrQDY93tCPGftV6DCs9SIHcBkczNCmJwuz0wWiYZUGhJophuDVDk7YBz5Gt66u0ggEJUTL0Y13q7NAdWzzLuyqltDgDyL6AmDIotRWXw2Gm3xd+zZZ3wFZoKVgIfndRNld90KBdXbyHjMh6Wl6K9OvQP9HViAEe0j2p/EEfCzc+AjvsHQxzuSENchQL3I5N6dLYSAz/8ElVM4BLgIb1pr8Ib20iWs103pxtBOOFRhyasSLRfsDSQEjh+XQyyIQCahP34mtMj7/HmrJHsP/g2myMi64CfB188WRED3E1DYHCXZpmeqHSDkOlJmud6E7Ecv2c/Fr7OWR+fmOOY3ylMDIlxHTVhCsnkxM2n+qqq0fPc0uDNXvAlXbnRUFFt7DnABla/Jugta/eezznMuNaELgyfEFUCeDVQR76a1kCDbr+U+koQeIdY8Z6hN+IxzW7HykCPM4f+qqRHYTQnZTo6trXgGIKxwu9sySw6XxoDSx9yQpKsgEGekY1xxTkblzp8veJeAGHbbSZk
 koQCNQVw
 8lusIgGmxj81WZRQuc1LvhK9NMfJSmiaAiJV8Ej8WWS/4w/zZNQ+pXCB3/Iz8eOvdQM7ptUoVHAAgRHiSYLMOzdL+j1o7S908ec7zyGji5sDGghm3VLMSqBjbAyJHsOvXHe5MiT38S9ow9CVdoA9yIwxd+inX+zVJnSZrkCUXOL4zsQcjx92PLusUnAxkIYW3UyOOWg+rAM9+O2DqnJuCzwoYlL2XKm6wzhRMCGAMZ6/f/JJE5g7ltaKY6IWC2ybhs5PWjo3hBkV3jsIXXmYVrWSpuAqSkIfaUFoh1SVfw/TdtCVQNQGZWlQP3wHsLrdphy//7QTTuNAzYWDdm04XjN20cz8M+2WN6hTAmqhWqKYhN8UD6i5eWyevCnnGQZ34BuM9ZoVIVFvJDCaEwaDHsK9O6AUjl/yTnwcUhhlyC79Z9qKmH6LWYwGFjvTvCdfke0qG8YMYrIXNU9mTAZnDPVCoDILJ7mtfolk1zDJsMBsGjgJz+vg8Jw96f174Viq3oy05h36uudOyKFP4d25ZZNL9F80qLB/6qgJb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 8:09=E2=80=AFAM Hugh Dickins <hughd@google.com> wro=
te:
> On Mon, 10 Nov 2025, Lorenzo Stoakes wrote:
> > On Mon, Nov 10, 2025 at 03:04:48AM -0800, Chris Li wrote:
> > >
> > > That is actually the reason to give the swap table change more
> > > priority. Just saying.
> >
> > I'm sorry but this is not a reasonable request. I am being as empatheti=
c and
> > kind as I can be here, but this series is proceeding without arbitrary =
delay.
> >
> > I will do everything I can to accommodate any concerns or issues you ma=
y have
> > here _within reason_ :)
>
> But Lorenzo, have you even tested your series properly yet, with
> swapping and folio migration and huge pages and tmpfs under load?
> Please do.
>
> I haven't had time to bisect yet, maybe there's nothing more needed
> than a one-liner fix somewhere; but from my experience it is not yet
> ready for inclusion in mm and next - it stops testing other folks' work.
>
> I haven't tried today's v3, but from the cover letter of differences,
> it didn't look like much of importance is fixed since v2: which
> (after a profusion of "Bad swap offet entry 3ffffffffffff" messages,

I also noticed the 0x3fff... issue in V2:
https://lore.kernel.org/all/CAMgjq7AP383YfU3L5ZxJ9U3x-vRPnEkEUtmnPdXD29HiNC=
8OrA@mail.gmail.com/

The issue is caused by removing the pte_none check, that could result
in issues like this, so that check has to stay I think, at least for
the swap part.

It seems V3 has fixed it, I can have a try later.

I also hope we can keep the swap entry part untouched, Overloading
swap entry for things like migration looks odd indeed, but setting and
getting a PTE as swap entry seems clean and easy to understand.
Existing usage of swap entries is quite logically consistent and
stable, we might need to do some cleanup for swap but having a
standalone type and define is very helpful.

