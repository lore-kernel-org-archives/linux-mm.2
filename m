Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 597FFFF8875
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:54:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABA496B010F; Tue, 28 Apr 2026 19:54:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A43DC6B0110; Tue, 28 Apr 2026 19:54:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90C5D6B0113; Tue, 28 Apr 2026 19:54:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7BF5F6B010F
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:54:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 46F4289791
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:54:09 +0000 (UTC)
X-FDA: 84709620618.18.78839BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 342A8100006
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:54:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ugdfpoNq;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777420447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=37JhNmJzLxzap3D9TGVaMRWJYU2uCyuE/O0k9zslYYg=;
	b=l60fUqkakU1q8O2XIx+avnRoLm7MP41ki/oyL29Rt+DADbiDVkWEnFIDLgsIhAriSRzfnq
	/94QY14rZmZuWWFAGmXBoTollAZzcVrTHoXJdJkPRPwF7s8fSrypYSZrjkoyp05gduJYaL
	uvQfpR7JW6yZeUEVowyBjQ1t62wdxqg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ugdfpoNq;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777420447; a=rsa-sha256;
	cv=none;
	b=6bSxwEXn8DyEpggbucRznkEvq3jG+ow5DURYwIhL2rseVgExAbCFKUX7dAdMbODT47SZOT
	hlivXbOPl2Jw5Cl9YGj9wZMU4J0dRouSXY2f0nJikk3tSTX3whi+q0EMzZPUTc1gP5q1Q6
	ZA6PPLPEeCw9cg3H5uuPPJ4cePxzBHA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C92D4446F
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C34C2BCC7
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777420445;
	bh=37JhNmJzLxzap3D9TGVaMRWJYU2uCyuE/O0k9zslYYg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ugdfpoNqOxbSflGH83HEj52AT2Fep+UNVIsD4PhSmXBQTbP3M/4uB6Go72MTQGv4h
	 j70Qn+P4YNeYQG/6+5HL8LpruMB6KwXegfRwRIf4d85rcmEHkPSy0EQRaKxjIRVszM
	 /r7Dkl+6AwjKsRvVUtb+hrTkzuGjH7hV8s9hOsiXt6Orrx17jyd9vA4f/WIqX4haCQ
	 81eC41EaeLSKBvDi/lfU8Tm+/ktz8b5eEq0amXD1f00vSgY7gRMO8JIlx1iThxcgFG
	 fUm8GM8l27nvmoYyFqxs9ZxN2qQvRj26t6IDlEFzFCYcmKCxRDosH3UWv8LR3pmtlo
	 ner8WLqIuIOVA==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6764e36dc88so527427a12.1
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:54:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+8iDAS+MXD4ziLucB/en5NP4Bq2Pfq0cKC4W+Jo5IrljICiTYCE0CBRkDnUiPKOA2kSUvPGD+TVA==@kvack.org
X-Gm-Message-State: AOJu0Yy0YTJTESmT6yM4NAT9Mx5/H8ZSVlnXLKWm5NXO7aoHLWKMYVSZ
	4S6ftPR++aJCw2vIaZ1OxVMgOQqDX7AKpZfeRNlBW9r9CtwMwzNuje5gwSavwPkUVDPSUy7kKPp
	/3HNSAgQ7tV264VxBK5FZ0rCP6EKoeZU=
X-Received: by 2002:a17:906:d54f:b0:bac:6585:b02b with SMTP id
 a640c23a62f3a-bb957dc60abmr42485366b.9.1777420443800; Tue, 28 Apr 2026
 16:54:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260320192735.748051-1-nphamcs@gmail.com> <aegUoOiUbjUAH5aT@google.com>
 <CAMgjq7C53WRS5oYxO157mX7JxhfoPoi34k+taiKLrMah-b-iRg@mail.gmail.com>
 <aektdlD4npMVThu3@google.com> <CAMgjq7DRrz4Hdy-s4y-C=3BmPt50LKOfdWjjf2mWmCybdRaJ4w@mail.gmail.com>
 <CAO9r8zPvApgxKiVy5NhiWup_m57huF3MTuPvo=iq5kAxjRZC8Q@mail.gmail.com>
 <CAMgjq7AGzBubCkmv7LubBjPLN1DzL472d4zUm+sGxo8ZptMgRw@mail.gmail.com>
 <CAO9r8zO+tm2J0FRC64VKCYOSuKPXX8cQG7C07SwMWKoLiwoV+w@mail.gmail.com>
 <CAMgjq7D1WXUHqAV1yuXvrUmEsE_m_+yx0mBq6teJhipx6mySbA@mail.gmail.com>
 <CAO9r8zMk7xTi-Txmj1+Z9=250fD8HuMQFyT1iwjTW9coLXgqoA@mail.gmail.com>
 <CAMgjq7A4+Sac9-CYkig1LFfEh5rq-4vLka8AXREei_m3svzJ7w@mail.gmail.com>
 <CAO9r8zMv6oYvqXti8dFfQd79Nd_Yge5g-EjjjhsEWj44gwJ-qQ@mail.gmail.com> <CAMgjq7BZpU5K1xHyFiqpsjeFe6CZUouGY_gOGMwbkM2Duq-vGg@mail.gmail.com>
In-Reply-To: <CAMgjq7BZpU5K1xHyFiqpsjeFe6CZUouGY_gOGMwbkM2Duq-vGg@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 28 Apr 2026 16:53:52 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPtPjzzrYh+SQXtuz4AMPU2p4UsUpJiH+zzfgtbJk_3Og@mail.gmail.com>
X-Gm-Features: AVHnY4J58WjJG7OMVYnI-DgVQj_F4MJqBKFiql4nFlYgXLXGGwlZGWPk6tWBkMc
Message-ID: <CAO9r8zPtPjzzrYh+SQXtuz4AMPU2p4UsUpJiH+zzfgtbJk_3Og@mail.gmail.com>
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
To: Kairui Song <ryncsn@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	akpm@linux-foundation.org, Alistair Popple <apopple@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Barry Song <baohua@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Baoquan He <bhe@redhat.com>, 
	Byungchul Park <byungchul@sk.com>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@kernel.org>, 
	Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Lance Yang <lance.yang@linux.dev>, lenb@kernel.org, 
	linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, "open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Matthew Brost <matthew.brost@intel.com>, 
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, 
	Mariano Pache <npache@redhat.com>, Pavel Machek <pavel@kernel.org>, Peter Xu <peterx@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Pedro Falcato <pfalcato@suse.de>, 
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>, Rakie Kim <rakie.kim@sk.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Suren Baghdasaryan <surenb@google.com>, tglx@kernel.org, 
	Vlastimil Babka <vbabka@suse.cz>, Wei Xu <weixugc@google.com>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Yuanchu Xie <yuanchu@google.com>, Qi Zheng <zhengqi.arch@bytedance.com>, Zi Yan <ziy@nvidia.com>, 
	Meta kernel team <kernel-team@meta.com>, Rik van Riel <riel@surriel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 342A8100006
X-Stat-Signature: hs8dsohy5nw4tgkqgtwxogjr84jxy79f
X-HE-Tag: 1777420447-631354
X-HE-Meta: U2FsdGVkX18MWnw0wmSzHL8rVJ/3jWvLikO4ifx6PgHj+2jTn8UZ/NFzVKTu0tg4RTKUUA/P+gqFGPi0TrvJFi/nIDiYCOxs+wR6Ud6OI5DuDkwRp4OPW0EUNBxhbAd2fni7WdtWDsp3EMGSUWLuo9A8B7c2XNoalP/cvGZXQuXtRw4+N+YvthEql+WaqTsYeWO49cRNdQeIRoOc13Cu+pI8KCOcnnwgT5jWC2gT1np2DZZxyAFA/iPGuN88OPmA6hm1ShYJ6OHSNIYYAF8+HfLvOX+GBpPAaMi3Le4S0nMKoaNX6aIC/LH9Po4j68Dlu64xJuCzIq9gsLnDRpxXOL2Y/gApnvxlA5oR4u0JIo/0RNSssBhziP8cgeZgB3Gi59kN74sv5W66KUc+s1nOpgCowJxXx6dmUKL6PZDNrQwm7UB9HnX7b3v/3+VrDY6KO63LG7BII2waVrSPA2OYT/AjDfHkBQAOOGnQ1s4F8ibu0oarl2MCu00hJ/ZgN+Xz2mKVPKjd2ZmZchec+z7scBpDeIB+m8vtAAuumlWE4CeyVIeYuRz70jmP+oIGd46Kx6zHDhNOuBb58TsAGQHN90K2S5ODFUQEp9GUHgR3INM2ad3zU4tLXjezNVlyaOxlVl2BFD/aPxn+03AwA0dTfX5VpXkaR+3QHu0UT/YYouNs+IsBAeLmkCo83QbVGGOkvWPmMCYqyCIwAh7EUiwzfePpUkg9a5ISVSrAkuEkXG5UaX0GtBdOTriUGZxxgdMojM98d1EZav5uNhGK70px7GZERUEgZ4NbSbPMks4r8c8eSmSCjIv9g7Ljhr85BkGiBPFAl50k+TQml1pjmjtir0d8fIi3AgvCFjlA0ZxmvR5aJcmJRdG0ufGZ9DlEpBdJ2hKfT2pttZ8qQxycKJVvDa7u2611WiXxc6efpAcX7xiPCbDoczYCBk5WloaaUNB8E/WOuT6TCzkBVyIah6U
 v4531Jf7
 heIjLwpTdT4rva7FPB9WmfskYGX6AysWdbDkBDoozRxVJO3G/7AwfvB9rz33/zwdQpT7Zh2VTm+ZxT2ZMTolkfMDg7k4JAmI+6XEfXSo1SB0H0QkXz/lJ0W+Q1vC1xfoxL6Esip0bUnqfT+uBJPg3IDF8967W4EdoLNwVCOc11kyIClK3HiQDk1Bm7nx6geNAWi93nuuev+q2gQfAgrgQ1Bbf4tYtH5czyAAETKXlRk4g6sT6pbygBk24lu2eFdjOguLCbzpmnRDRuAwllIs5xZKsfcCCUOneVTkgYp1nQJX1J7hzEbK82EwZj/LgXL5cbMfezbp1TIRlwos5MeunwmrUDBB/JMh7AuCSIni6q9Gv8UEF+I3cRe1nGS6GUHI3N5fpAXkHIC4WdVEOwLWUgjrRiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 11:46=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> On Tue, Apr 28, 2026 at 2:23=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > On Fri, Apr 24, 2026 at 12:52=E2=80=AFPM Kairui Song <ryncsn@gmail.com>=
 wrote:
> > >
> > > On Sat, Apr 25, 2026 at 3:12=E2=80=AFAM Yosry Ahmed <yosry@kernel.org=
> wrote
> > > > Why >16 bytes? Do we need anything extra other than the reverse
> > > > mapping? Also why do we need a double lookup?
> > >
> > > You will have to store at least the following info: memcg (2 bytes),
> > > shadow (8 bytes), count (at least 1 bytes), and revert mapping (8
> > > bytes, since you have to address a full virtual swap space). And some
> > > type info is also needed. Part of them can be shrinked but still,
> > > scientifically, merging two layers into one is considered a kind of
> > > optimization.
> > >
> > > You need lookup the virtual layer, then the lower layer for many
> > > decision making, is was discussed before to introduce more cache bit
> > > or things like that and I think that is getting over complex, reminds
> > > me of the slot cache or HAS_CACHE thing...:
> > > https://lore.kernel.org/linux-mm/CAMgjq7DJrtE-jARik849kCufd0qNnZQs7C8=
fcyzVOKE14-O+Dw@mail.gmail.com/
> >
> > I think that's where the disconnect is. You are considering these two
> > separate layers, each with its own metadata. The metadata should only
> > live in one place.
> >
> > If we only have swap tables in the virtual swap layer (with the
> > metadata), backends do not have to carry the metadata. In this case,
> > backends should only have a reverse mapping (if needed), and some
> > internal data structure (e.g. bitmaps) to track usage.
>
> Ah, you are right. This is currently an intermediate state, that
> problem might be gone if we unified everything.
>
> > This is difficult to achieve if the virtual swap layer is optional,
> > because then the metadata can live in different places. This is why I
>
> But that's not difficult to achieve at all with an optional layer, and
> actually will be achieved naturally without any design change with the
> RFC I posted. Swap count / cgroup / shadow all stay in the top layer,
> lower layer is "reverse map" only (the undone part though, it will
> require to move the cluster cache from global to device level, which
> is also required for YoungJun's tier or any functional tiering to
> work, we may run into more and more detail issue like this).

But then you have to deal with the swap entries in the page tables
potentially being virtual swap entries or physical swap slots, and
IIUC in your design, those physica swap slots could end up actually
having a redirection to another swap entry like virtual ones (e.g. if
we start with one tier then add another tier at runtime). Right?

>
> Might even be easier that way, it's pretty close to the unified states I =
think.
>

