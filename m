Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AB77CA1012
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 06:36:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74A018E0006; Sat,  6 Sep 2025 02:36:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 721A18E0003; Sat,  6 Sep 2025 02:36:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65E938E0006; Sat,  6 Sep 2025 02:36:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D2E18E0003
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 02:36:13 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 02AD7140232
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 06:36:12 +0000 (UTC)
X-FDA: 83857865826.05.50092EC
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9C78F180003
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 06:36:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MGbr7vuP;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757140571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hZI+7xxBYSUjf2DkYRpNjguP0eowa/Qcb8yf8x4bp6o=;
	b=jnwDO7Fwktj4SkTxq0cle2GgJOaCBtCfs4l9EIiYax5tu0KZdxdFVqX9n5czM9vaw//Jwj
	GKhtqnnqet08rf2P4ZewGQYl0+DvadnwBOWu6ElJR1u7ramBjLuri5eAYOQOh1jpRR/IfZ
	zyQuljbxY2nUKG6sydap1JF54bTzX7U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757140571; a=rsa-sha256;
	cv=none;
	b=fTTR6PkrBcATJyr1Cw+4xiiKHDu57j56btM2op11EpTIfOdfvzvegBkOtFCvlhlx6hy/tl
	2ZRwaBnLWpxBqBPS1Qo1Msjp2zs5axk3Xvm3LQ2jEQlujgtRaWXtuZNldIW8/v94YWHMMW
	qelca93SJVOwfYWwV3yh9vVNPj7ticA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MGbr7vuP;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Forwarded-Encrypted: i=1; AJvYcCXMPNKismehuD4MvPJs/rGd6MsfCKuKXnhINbPDIjW0Fl3fxw/ZbFVYuzQ63WzM5gXtQgTrvukS4g==@kvack.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757140568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hZI+7xxBYSUjf2DkYRpNjguP0eowa/Qcb8yf8x4bp6o=;
	b=MGbr7vuPvLbBEG7xfZrVys+nQblKZ+RbeJznQLP7LibZmJ+2DF4t9UA35xoA1dcla/NaB/
	aEU2y3HNYDPUv2aRQO5GlMmRpoKCUen8pl8VFSSjsxmL+TW6dmd9sW6oJSY0f6SYg1HFJ+
	mv6ESF5qQ95Q1Cgtr9PAYocX4kCzPgk=
X-Gm-Message-State: AOJu0Yy8zXZQD5iTg8412c6Ieo2viiea+JgS7lz7IzGdnT3fVfo9tOLF
	6EucxAguhhlrBdAu0t8ovsaOlsd/hRDcWqVbKZzARNtha92fUVZQThuEGw3IV3Yb3XjJ7XvLfXy
	VeZ0sP1N4XSlQa3OAWAcG9pdhE9PAboU=
X-Google-Smtp-Source: AGHT+IGNxstH+GnVHJBOvOkXVFQ94aleFh61ynH/0fgSb7qxhJXuopaMmAthk78PTShzywiIxlJt1lhTtSRXJ8mx3gI=
X-Received: by 2002:a05:6214:2302:b0:712:9051:c001 with SMTP id
 6a1803df08f44-73922f67c33mr15297266d6.12.1757140556079; Fri, 05 Sep 2025
 23:35:56 -0700 (PDT)
MIME-Version: 1.0
References: <20250905141137.3529867-1-david@redhat.com> <7B0B1E09-5083-449F-851D-FD63D32D2B3D@nvidia.com>
 <2f4141b3-bd66-415d-b2ff-00544b03b908@redhat.com>
In-Reply-To: <2f4141b3-bd66-415d-b2ff-00544b03b908@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
Date: Sat, 6 Sep 2025 14:35:18 +0800
X-Gmail-Original-Message-ID: <CABzRoyb7_WfO6GmTnoUdDtejvchvW=xtsTbrdYtuhXD_9=cBfw@mail.gmail.com>
X-Gm-Features: Ac12FXwZXUX6523e25WuhUjfg2Wk6VLSjA3TWPpSs5qJfKafZ8u7MZFwTj20LIg
Message-ID: <CABzRoyb7_WfO6GmTnoUdDtejvchvW=xtsTbrdYtuhXD_9=cBfw@mail.gmail.com>
Subject: Re: [PATCH v1] mm/huge_memory: fix shrinking of all-zero THPs with
 max_ptes_none default
To: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Usama Arif <usamaarif642@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9C78F180003
X-Stat-Signature: qwem7d58fcseezmxgqwuqoznhane4sws
X-Rspam-User: 
X-HE-Tag: 1757140570-66868
X-HE-Meta: U2FsdGVkX18H4ey+nDpjRl3ctfObQ4Ube3oabIMwufFJ3uOnSGhqa4dPdQFjkpdECyFTmqNHd+glA8q9c8RZWXp0RtsBNJb7cPvaVqWyFxCvKfZzaGaGqxRT1L2KKalduf1WQfbXVW1WkWt3m53XzCRR14svHM0VPvM+Fcppk3vvdW6QMDDD/VYmdADi3fAvcLEhz9pCzFZvew4WxIT2I7jS7x277jfuarcTacxCRAKKU+mpijwlrxUi0Byoo4Aqq+nkNw1kw4Sg/WLvh+SOjiojsDO7cOUHiFKKp5M+mQ1AIvlQ/t+ViHYC8J4RRbiQF81UyM23R4wPtpBt+cMNtXALLVFiv0Io9ECcDGyPEs6az/kMpWDHaoZqgMRIttP8T7XP/tzfaPwcAApxqFRuzhpDBuzTUcgCqzDAmAYG9vRzKydbHZKoavEKGvICUXs4ZUPc06P6nb/tSKnWw5QKHsJKMK3cD5D+ytqZc/Az3rSXpE2dJSLusUlRhiuApVa/67EzsjccJ/2ZDpXBto+ZcJg6JXSZgNMkwu3nZvkbqkzHyKweTO9K7hxDXVbqW+taOLLaUZG60iSyau3ARTrb2lMnQen4mTwx8RKncAkaebEzOGNS8zkDbsZG3vzT0QoMSXvCFSNhNkAN0k1w2Ad+SPOzHrbV3BxagpIsYO2zRzGo5RKrA9CMsxxnO1FW+Mk+/9Y3Q+paX76ymc3AH/20NlVoFuQ/OyurnzidsSWgmZLivx7dTvXWtWTCrBvkN8a5NGjr6ofG6uq7hQYzr4q/xaRDZMuQcjO1JFd8fwCpkHZniS1luYJfq03J72jEpq4Bp8DZKex3HSBD8iCLVREk2Cuo9eUhbbnnPbGH4AdVJ4jznwuF2dHrFpsPqZ/MbB/yZ+oX/D80XFYF7FWWW8589csR1NFp/jt0w5DC/v1PU5/n1cEDfyDaZIKB55YMS4VDxcEuUqPfB/IKu062Z4I
 TgxAXCTk
 8LLB3rJoQ5tnXpTi56mvdX0xjS9RssnOmIYiZTcG3eLCAa1Rj2XlsDtMoEwvJuu27N2aPIJgR1TfcsRb+9161xGQx/VjpnIi4CBuW9kgUMqOkK9G1M3g6eZOiab5bSi6EEqU6c7UgVBwoQ+laeI2F/mQvVeLLt0hILOBmHcahre5x8zfj7hjObTWSS3tXIrrTaUF/vTZKahRKcl4sMRM0FnruabTqAehycNfUFPIf8Yw7U+FgyE20c3K2iRp5hDA+ysHkPvYWPIWK4blwTYfwfSBi6+nRCk1DVIqCG2M1Az7ruFhO07af++4nJBVS2p2c1DkrE88IhE+t8Y2n4qtgYj6oCKI2J32RTJwvClBUW5sh+zfwPRzfWFoC63y8os5vQXBQc6HeF0VHadEYCU8yW7U6cDPCaLBDn+qi5L4CDfZnjf1iD7L8ScAY8bJzYHb50vtlthsFNS65TAjeB1vy8/YFJaFULtrxMtZZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 5, 2025 at 11:17=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 05.09.25 16:37, Zi Yan wrote:
> > On 5 Sep 2025, at 10:11, David Hildenbrand wrote:
> >
> >> We added an early exit in thp_underused(), probably to avoid scanning
> >> pages when there is no chance for success.
> >>
> >> However, assume we have max_ptes_none =3D 511 (default).
> >>
> >> Nothing should stop us from freeing all pages part of a THP that
> >> is completely zero (512) and khugepaged will for sure not try to
> >> instantiate a THP in that case (512 shared zeropages).
> >>
> >> This can just trivially happen if someone writes a single 0 byte into =
a
> >> PMD area, or of course, when data ends up being zero later.
> >>
> >> So let's remove that early exit.
> >>
> >> Do we want to CC stable? Hm, not sure. Probably not urgent.
> >>
> >> Note that, as default, the THP shrinker is active
> >> (/sys/kernel/mm/transparent_hugepage/shrink_underused =3D 1), and all
> >> THPs are added to the deferred split lists. However, with the
> >> max_ptes_none default we would never scan them. We would not do that. =
If
> >> that's not desirable, we should just disable the shrinker as default,
> >> also not adding all THPs to the deferred split lists.
> >>
> >> Easy to reproduce:
> >>
> >> 1) Allocate some THPs filled with 0s
> >>
> >> <prog.c>
> >>   #include <string.h>
> >>   #include <stdio.h>
> >>   #include <stdlib.h>
> >>   #include <unistd.h>
> >>   #include <sys/mman.h>
> >>
> >>   const size_t size =3D 1024*1024*1024;
> >>
> >>   int main(void)
> >>   {
> >>           size_t offs;
> >>           char *area;
> >>
> >>           area =3D mmap(0, size, PROT_READ | PROT_WRITE,
> >>                       MAP_ANON | MAP_PRIVATE, -1, 0);
> >>           if (area =3D=3D MAP_FAILED) {
> >>                   printf("mmap failed\n");
> >>                   exit(-1);
> >>           }
> >>           madvise(area, size, MADV_HUGEPAGE);
> >>
> >>           for (offs =3D 0; offs < size; offs +=3D getpagesize())
> >>                   area[offs] =3D 0;
> >>           pause();
> >>   }
> >> <\prog.c>
> >>
> >> 2) Trigger the shrinker
> >>
> >> E.g., memory pressure through memhog
> >>
> >> 3) Observe that THPs are not getting reclaimed
> >>
> >> $ cat /proc/`pgrep prog`/smaps_rollup
> >>
> >> Would list ~1GiB of AnonHugePages. With this fix, they would get
> >> reclaimed as expected.
> >>
> >> Fixes: dafff3f4c850 ("mm: split underused THPs")
> >> Cc: Andrew Morton <akpm@linux-foundation.org>
> >> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> >> Cc: Zi Yan <ziy@nvidia.com>
> >> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> >> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> >> Cc: Nico Pache <npache@redhat.com>
> >> Cc: Ryan Roberts <ryan.roberts@arm.com>
> >> Cc: Dev Jain <dev.jain@arm.com>
> >> Cc: Barry Song <baohua@kernel.org>
> >> Cc: Usama Arif <usamaarif642@gmail.com>
> >> Signed-off-by: David Hildenbrand <david@redhat.com>
> >> ---
> >>   mm/huge_memory.c | 3 ---
> >>   1 file changed, 3 deletions(-)
> >>
> > LGTM. Acked-by: Zi Yan <ziy@nvidia.com>
> >
> > I also notice that thp_underused() checks num_zero_pages directly
> > against khugepaged_max_ptes_none. This means mTHPs will never be regard=
ed
> > as underused. A similar issue you are discussing in Nico=E2=80=99s khug=
epaged
> > mTHP support. Maybe checks against these khugepaged_max* variables
> > should be calculated based on nr_pages of a large folio, like
> > making these variables a ratio in other discussion.
>
> Yeah, factoring that out and cleaning it up is my next step.
>
> But note that mTHPs are not a candidate for the shrinker right now. (see
> my explanation in reply to Nicos patch)

Right. IIUC, the logic in deferred_split_scan() is gated by
!folio_test_partially_mapped(folio). This creates two paths:

1) Splits for mTHPs that are partially mapped. These set the flag and
corectly bypass thp_underused().

2) Optional shrinker splits for new or collapsed THPs. These don't set the
flag and must go through thp_underused().

So, thp_underused() is only for whole, PMD-sized THPs right now. Please
correct me if my understanding is wrong here ;)

Cheers,
Lance

