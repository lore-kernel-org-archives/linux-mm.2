Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19AE2FED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:12:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D66C6B0005; Fri, 24 Apr 2026 15:12:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AE3E6B008A; Fri, 24 Apr 2026 15:12:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EB0E6B008C; Fri, 24 Apr 2026 15:12:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3D3546B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:12:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CCACC8AD5E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:12:35 +0000 (UTC)
X-FDA: 84694395870.16.1246EC3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id C4CBB8000E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:12:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F4+4pap+;
	spf=pass (imf30.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777057954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KmheunmqoD7qmRe40GYg7//W4Bdndm96gaU0yeszTyU=;
	b=hPS7jRpOhTwAn8O/nnxA091WtZlldpl0xNnpFdpIHNx46bLtau5onvUYyTzVKw4bYqxABW
	9a0e/mpRF1AomEiCf9D+7f7EPK7f4uCo4ypLuWDJIgsjjdZPXEfOv/7nnvV7nx6UcV7BZu
	WdcdMrFY2zA7CvI2pZeANr7rw4g9eP0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F4+4pap+;
	spf=pass (imf30.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777057954; a=rsa-sha256;
	cv=none;
	b=OZJbQ1YHNvRSqnb7IU8RP2GnlpOrY5EFRTmejH4ut6ktV25nbUAKqh3NSyevko83NcR5lN
	kPhuvquRSWGxQ+4Ell6h0TUz2oJUEujkScx0u+qo/CFWVgJQfJTR8hHjSk6l12yME32E4A
	wMb14Bl/EsapjRMrHH0HdFw0kGN0mCc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F69F445A6
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:12:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA03C2BCFD
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777057952;
	bh=KmheunmqoD7qmRe40GYg7//W4Bdndm96gaU0yeszTyU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=F4+4pap+k3NIvaz6hOcr8KAuk8o0/EVvhqo4GgLnYt4BOdbudhQeKo+DhA3LVYZ0U
	 53CelfISuIniJTrTNv6cNQ5ZXr/Wp77zjcX7b5+kyn++e6zEqJGtFh3sCIg5Py/Qsi
	 u71Pg+hSzpYFk8vz8xSTB3Vf6ldBJ7g2tupkcswSnTvRQKE2FrZQxaICyR99vnSKz8
	 bQZaUnsOJo+OXUKq4PfUOMrhjGspdLlVNQQV9S1bTEAorfLN40qh8td6gnbBdFGcpj
	 D+0pICd++/uLneWVDqspEPTbB34/6nBZrQTmj1pUqtAXbTLjlunKGB9FjbcgECLZ8q
	 lQ22mh7HzmjeQ==
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6746d0b2b4aso10281684a12.3
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:12:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+AuKw8Xv47SbwN/occOC0ptfI79VeKDkIbFX8JNtKBLQioTicRyTbKKGVpYCZ2T+enDcwJSLM/IA==@kvack.org
X-Gm-Message-State: AOJu0YwtXR/Xi3BVNEf5OKn66uKSIp/wn2Hk4qi0OuRL7eCWQo888Uhk
	11LXryAL42Tk78pGRp65XgiD4n95B7xKpVP2rlYRvdUU2PPvu+D+R7y/XkY3qCoCUmXPV2SJXt2
	lyGed2Gp75adDsafHwkawvoXtd8U6BOs=
X-Received: by 2002:a17:907:61a5:b0:b8e:796a:fd5d with SMTP id
 a640c23a62f3a-ba41b3dee51mr1299551766b.39.1777057950683; Fri, 24 Apr 2026
 12:12:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260320192735.748051-1-nphamcs@gmail.com> <aegUoOiUbjUAH5aT@google.com>
 <CAMgjq7C53WRS5oYxO157mX7JxhfoPoi34k+taiKLrMah-b-iRg@mail.gmail.com>
 <aektdlD4npMVThu3@google.com> <CAMgjq7DRrz4Hdy-s4y-C=3BmPt50LKOfdWjjf2mWmCybdRaJ4w@mail.gmail.com>
 <CAO9r8zPvApgxKiVy5NhiWup_m57huF3MTuPvo=iq5kAxjRZC8Q@mail.gmail.com>
 <CAMgjq7AGzBubCkmv7LubBjPLN1DzL472d4zUm+sGxo8ZptMgRw@mail.gmail.com>
 <CAO9r8zO+tm2J0FRC64VKCYOSuKPXX8cQG7C07SwMWKoLiwoV+w@mail.gmail.com> <CAMgjq7D1WXUHqAV1yuXvrUmEsE_m_+yx0mBq6teJhipx6mySbA@mail.gmail.com>
In-Reply-To: <CAMgjq7D1WXUHqAV1yuXvrUmEsE_m_+yx0mBq6teJhipx6mySbA@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 24 Apr 2026 12:12:17 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMk7xTi-Txmj1+Z9=250fD8HuMQFyT1iwjTW9coLXgqoA@mail.gmail.com>
X-Gm-Features: AQROBzC1SEAi52wg78oFj6rZAsnu9X4A0he_tCTRosEu2pR3Wwk9OtpK8VSGi4U
Message-ID: <CAO9r8zMk7xTi-Txmj1+Z9=250fD8HuMQFyT1iwjTW9coLXgqoA@mail.gmail.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C4CBB8000E
X-Stat-Signature: opm7ncc38sqkwycimjs11e6zrtby9k36
X-HE-Tag: 1777057953-132193
X-HE-Meta: U2FsdGVkX1+pyyS1tNW7hJndYWFYfg+F8WLY2NmGUf8OiNY3IVJzZRE/DmcINfm7zrb3fd3CfIxQTrG4DORJ1fYSIdzHzlLUXiHS2lIZ7NB1TQguIcCwOLTiAS8n3zjfE0XlvbeuU7zfioNCigPenedyOO+fuAoAnzL+te48qh4ngkPHtHLpK5ly39p1Owab9je8P7eA0Q4BaoJrr3JMyDnEc6Xwupytja7SABnjAg1DZvdYYrpukbDahyC9mUGI7O5IIFRWo6ggS4LrjqxqMGr/QF8LgPLJGowCedlwS3wX9v1qwFXHbNnMlVISB3nk8L1Y5niqAAHfrNTwq9WVo4XgNNVbwGLCZvcRUVR7k1rBjyXtHasmKP+s/5Mc77a4I5zDIfwM6rbqgqCOZZmZL4KiCSIjyRgP3pJhnPEPYKU9v6dvq7uppgaMOXE4RO8Qj6yg+vL9sXVMVcbgjzg7dvZ6e0nIeerfBfPY3wNMhOLCWVj/U1didmWY1G+BpJIwSNXxeXUvONSrsx5WIteGg92ZC/QbhJ2pMa40UGAba7SR7huj5jjslF6AiiRBAiZQw+c1FWirxWK+HHtzAbnlLTL5C52oT6oiMkFTxUkeUspt0F3w4cU5wkyWPx2KNTqTRaL8pEU7IJ044Vf8VmVT+bvtNkYIuz0FjpnVvxzDWNvYJv9ySILhFGKuV/I3ZHDUdyTyTl1gsxFyOY+2N0U2RJh7AMF8eWEIPNxXeN8sDpWD1bNrYIQSeO+mdBagUKcHTQJ7AojfYOz1enX91UPYxgzsaMFDpGj5m9x9nLtdxgV4CD+fDWaOfqU6z106d8pZ5k78GVQw8fZ+ooJtaMqGtOfqI7Io3MI3y9VuZRZg19uQtrDZ2XB9ZS0zQ1YPL+/hnMrpRur+f/h/NGCnmv1rDT9YuXkx4C2PnsUXpYELRh1crJY/GfOmLZNBhBMuOpO0+Kox4DwVlFEIOAnjivb
 az9FrfBo
 /fMxWM1W6EPx3j19yf6V4zopAtdSz8nzvQM5qUkjO6MRLPBUccIsXzm2SAnkHKYOhYgh17shvwToP5lCdCwFPi+SiaIXAhxcMDoY+9rmYaWaDDAahcGRBt0IER8OQR9fAarP1CNAe4WtHKoLYc0OXhKI6pHhm+8v+Ff+vqrdYZdv75IykOoxMCnC1+m9/jf78TVfK1nMoeow/7NVhhvDEVaS1SxL+Ne97YbSuy5W331VbV4oOdQItM+xwREPPIa0dJbx2zsnSJLyoANlBQUxrbu7jJcxRp+WRyD/H7KtDoQ1T8WT8csH/gr3sPwvOPRarLnOawsU/rHnuxCUHfoZERB+JaVfKuUCthccUv8td1qlQTw9j/4gMOknupD7IxEBzkQuqRGxpkw7MX6z5L8HrV2QhPfWDBRIIDGHFbR5wWga7YFIoYfNprcTYG5PBxEikb+N4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > > IOW, I think the whole reason we want a virtual layer is to separate
> > > > the backends, which would facilitate tiering. If the virtual layer is
> > > > itself a swapfile, wouldn't it become one of the tiers?
> > >
> > > That's exactly what I hoped, virtual layer being part of the tier.
> > > Tier could be set up per task / cgroup. So is the virtual tier.
> >
> > Just to clarify. I don't think virtual swap should be one of the
> > tiers. I think it should be the mechanism through which we implement
> > tiering (see above). I am not sure if that's what you meant.
>
> YoungJun's swap tier have been working pretty well without the virtual part:
> https://lore.kernel.org/linux-mm/20260421055323.940344-1-youngjun.park@lge.com/

Does this do promotion/demotion of swap entries?

> > > A standalone implementation of the virtual layer is more heavy than
> > > being a swapfile. Actually I think at this point, it is the word
> > > "swapfile" is misleading now. We may rename it to "swap mapping" or
> > > something. A swap mapping could be physical or virtual. Virtual
> > > mapping can realloc from physical ones (redirect), and swapoff of
> > > physical ones just read its data into virtual mapping's swap cache.
> >
> > I don't understand this part, please clarify. In my mind, all
> > references to swap entries from outside backend code should refer to a
> > virtual swap ID, which could be pointing to physical swap or zswap or
> > something else.
>
> For example just reserve a type (e.g. type 0) as the virtual type?
> (type is really a bad naming though).
>
> The that swap file (or swap mapping) will be
>
> I was trying that based on this:
> https://lore.kernel.org/linux-mm/20260220-swap-table-p4-v1-15-104795d19815@tencent.com/
>
> It seems to work and the only thing we need is actually just something
> like this one in VSS:
> https://lore.kernel.org/linux-mm/20260320192735.748051-15-nphamcs@gmail.com/
>
> This part:
> + /* fall back to physical swap device */
> + if (!vswap_alloc_swap_slot(folio)) {
>
> We do a folio_realloc_swap if folio->swap have type 0.
>
> Which means, if there is no virtual device / mapping / file / space
> (I'm not sure how to name it at this point :) ), the ordinary swap
> routine is just still there untouched.
>
> If there is one, and it's being used, then, it is still the ordinary
> swap routine, just do an extra allocation (and the extra allocation
> strictly follows YoungJun's tier rule), which is same with VSS, but
> everything is reused. From a user or high level interface perspective,
> this can be designed with no difference as VSS. Just with a few
> bonuses: being per memcg / task / runtime optional, zero overhead if
> not enabled, and reusing all the infra.
>
> BTW this deferred allocation (in VSS or dynamic swap mapping, similar
> thing) is actually a bit concerning to me as well. It changes the
> common swapout routine and maybe worth reconsideration (e.g.
> activate_locked_split and mTHP stats is now ignored?), being optional
> for now also seems safer.

I am not sure if I understand you correctly. I think what you're proposing is:

- Page tables either point directly to a swap slot, or to a virtual swap entry.
- By default, page tables just point to swap slots maintaining current behavior.
- If we have multiple backends (e.g. zswap or tiering), we use virtual
swap entry instead.
- The physical swapfile has clusters and swap tables (status quo).
- Virtual swap is implemented with clusters and swap tables in a
virtual space, and each table entry points to an underlying swap slot
or zswap entry.
- If a page table has a physical swap slot, and we need to do tiering,
we basically "make it virtual" by making the swap table of the
physical swapfile point at a virtual swap entry? or another physical
swapfile? Not sure.

In this design we have swap tables in both the virtual swap space as
well as the physical swapfile, right? How does this work? Where does
the metadata/swapcache live?

I am not sure if I got it right, I am a bit confused.

>
> > I *think* what you're saying is that we should make that optional, but
> > I don't see how this would work. If a page table is pointing at a swap
> > slot in a swapfile, we cannot do tiering or zswap writeback or
> > anything dynamic without updating page tables. So even if the system
> > starts off with one swapfile, we cannot assume we won't add more and
> > set up tiering (or enable zswap) after that, right?
> >
> > I guess we'll keep the swap table in the swapfile and then we'll have
> > it point to a different backend, but I really don't like this design.
> > It's unnecessarily complicated in my opinion. Page tables will either
> > refer to a virtual swap ID or a physical swap slot.
>
> Or in another word, they are all just swap entries, and the swap layer
> handles things internally.
>
> > I think we can simply have swap tables representing the virtual swap
> > space and pointing at the backend directly, whether or not we have
> > zswap or tiering set up or not. Is the overhead really that bad?
>
> Right... I mean with two layers you will likely have >16 bytes
> overhead, and double lookup.

Why >16 bytes? Do we need anything extra other than the reverse
mapping? Also why do we need a double lookup?

> And I have been thinking about cutting
> down the memory usage to 3 bytes. And you can't make the lower /
> physical layer just a bitmap if you want a reverse mapping, and so far
> many things do require that. If we make the reverse mapping optional
> it might be more complicated than the thing we discussed.
>
> I don't think the thing I described above is that complicated reading
> all the code and solutions so far. Maybe some better abstraction can
> help?

I don't think I quite understand it yet, maybe I am the problem :)

>
> I've seen some vendors doing swap using UFFD just to cut down the
> overhead or having a highly customized backend solution for swap, so I
> was hoping the kernel part could be as minimal as possible.

Interesting.

