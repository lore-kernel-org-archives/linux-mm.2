Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9278606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 20:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=A+ppHjTj
Received: by kanga.kvack.org (Postfix)
	id 89A126B05B2; Fri, 30 Oct 2026 16:03:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84B376B05B3; Fri, 30 Oct 2026 16:03:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 715606B05B4; Fri, 30 Oct 2026 16:03:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C44E6B05B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:03:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 25552A84AB
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 20:03:13 +0000 (UTC)
X-FDA: 85380366666.19.F7B1BA3
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2DE2214000C
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 20:03:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=A+ppHjTj;
	spf=pass (imf09.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793390591;
	b=siQLmbShfoGGJUoq5vkyWKDktMCagOXkcynfTSwAghV4Zv1CWPPZ1c4GXrRUlrAIJZko4n
	fZvs1l9c5H25qYAtUnhOtT2x8CNAPl/kOvtcSgF0vlUlyK/WVWsPGGSsJMXL+kS+wxMnbb
	ul3F73PJH+yz8hRgs9FFzhU5hF0hKzU=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=A+ppHjTj;
	spf=pass (imf09.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793390591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hU9U9g2KEC0K+AQ9Kz8ZKPoilLXWoWScRD9pz7n1lhY=;
	b=D4+Oq1R/njyybwHcj5bgHKTykGytbLiq9AnOmtDi0WULkKaisbPx1/w9jXYK6NHaH4AVgj
	RQngxGzgpdxK2/gO85mC6ozTpehlnq/2VZdQ+iqRd1npfY8PlKrVofOckO/lEyRsPjEvmI
	wnmI7c8g8FCjjqN9hsBmqu/s6+CHw/0=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48c5358fc28so879721f8f.0
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 13:03:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793390590; cv=none;
        d=google.com; s=arc-20260327;
        b=CvE0S7kPzJVtbUNTDDKrJyr7Q3o8/qq2Iv6F7gL9D56M/ih6Nu+8dDoEgTH+8SWad0
         fq7VF0fh+sV9Ehfa7Jhvo4HHdgr4tLfPF1shxLS+dZAUeEH+Yr13dhDLqNzrdB/duQtc
         a/T61sl9AqP/3kN5b+TdDNG0HeJx9kcWDoOeiAN4G4DqT9FUfZ4JwBiyRSBldBTlWa0k
         zYbrPJIs1x7gh53VIZrYxWHldI88FbMDPPdZVM3r3qk+YAlXJM2QH2AXy+YZQq/gVVxB
         ZQLUmqWB/et/kxfp6hveRlEU9NlLgSiUh+3doSEQJm7mSKdfxMfJjizUTIboNquXo5/o
         EfJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hU9U9g2KEC0K+AQ9Kz8ZKPoilLXWoWScRD9pz7n1lhY=;
        fh=zc/OOIXOQpuCDnCawZ572rJ1ufqdBUiMZLWQY8Sq4Dk=;
        b=NW72Y6Mu2VE24KVaETX6lw8sRGJVSGGZhmmDygVvlO/LQv/gvFDeGAao9G4ZZWaF61
         O7t9otNNjlRCAquk2K4eb3SyIsMvhg5YjQlZ59HHfZpLutcSh66eG/OILIGrTyg5oKiH
         9gs3UAONXdOTsMLAx5E7LeA23W1BBdkky0ELKv31G5VFujptRx1r4lAxUcPaxp7SpTrX
         eJKlW4g9k3U/WcDzqcFd/qeJ5iQtS2W7RTY3IR97MQQZRdf3tFdErOHqkBP/R5cHzDFl
         bmo0luzpPaIKk8eYsGjr1v1LrKDuTqjasaDBNjXT6LF35UIeICEpLmmRmW33mChT/zQJ
         KfWQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793390590; x=1793995390; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hU9U9g2KEC0K+AQ9Kz8ZKPoilLXWoWScRD9pz7n1lhY=;
        b=A+ppHjTjcgP1fiWSlLIjxCbzc8hub7qVSeXhNJgUwfzoSKOm0BkLfcqwbIcD6ZodDp
         QPj7sPu5wgpzsrSrpjDdnkGy2NZkrNv9lf7btcPq9Inq7ELmSBKLl1g2df+hhkJ+ZXPv
         OyMTtbK+q921hnzaucWD6aI/xZBVwjJBTF43vbMLfWxw1GcU8kXu5E5LqebB3BADcNdd
         sgElHriMnVRGfoC75zDpGhNRP2phV6gWTMPSPl6yvXu7vxrh/7lkvfgsv3CCqtxPpTNu
         H5olb0GtplwEBiKQKMep7rC1Vouqu0cHSHAVR/m8LzpQ0qQCKfrflXCt1wPhpDa6Dv24
         ddYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793390590; x=1793995390;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hU9U9g2KEC0K+AQ9Kz8ZKPoilLXWoWScRD9pz7n1lhY=;
        b=QMtCHJvhbOO6CkecJa3d1/eEteBSeMN9QoDmBDnW1hhD++l+Wj14BchTGfQDAlJHwc
         +tc5nSvBmEwi4rd6GnXCg+1XvmxFhrbSTK9NjEY3elAYPuLLRINAqBWe1YIFHx8Yg3ch
         mQVzdDiwIVtjQGjEgl7vFhbFyZDkuocS88g4cCYK7GNtClXvohSK0+zw5RjFsq+re1by
         0R75X8TEzYAw9FeaCfH0v2toys4t/wHmUxd5+ezoSoJWHazVlzjUGF2MU+1B+6M7oFu4
         N30r+E2TCdoFL+fCueIwh4B6vsr44DbL8yfEB9A8FF0gdv9ev2FiP9y9Akbu2gP8WEdC
         PuGQ==
X-Forwarded-Encrypted: i=1; AKwUvBwp5PNHZRvHoaP0GZ3st6gqqBH9YRUM3/Q9Oh8LuwfRrknCg07XUKORn8gpfKOhQfYerpLkr6Tn+Q==@kvack.org
X-Gm-Message-State: AFq9FYLqQWGQQtvZdBdErH97jZvpoxPpySGR1H4bTKVPVPahp0zvDKdP
	MtZP3jKlRrXWl/9VdKkJ0DgyXGmWlbUtlp0A4xNU9YFxQdplEoHC0RN8Ph1S9Bwnho74IzO0vzj
	ecIY2AAf6YfHSWERBp08o2kmQCX3nQWE=
X-Gm-Gg: AYBFou0aQZf3mqNqXVk2AA1vcf+zbcSmD5gduSiCQV9hFTnRI9wPourJL32pc59R2bV
	FeXKlxLVApZPmCS6mXAeHJRkojRsO+OrvVvLPZU9yWWVkdkkNS3leMgQ4pgv/96P5UdGu0aP4ki
	4QsAjPgJ4D5UzG42Vk1F8xeVefK+qsFv/Qk6XNY1+avx1XtgJojWTGJWyOWRyUU5ek7yG1ITACc
	3xlN+vfvu+YnjWAhr9qX2HcLBXPqbludYrLunTKkrxynrFNAdCS1SSZ73Ek+1xTSC+j9UABfvVP
	9amsAfvdXn9PDy03qeqAVLf8yMI4o5ITlUEhf1Xey3S1+Q0e1i7VxkWCsco5Tc+AiUrvT4S9f3s
	djAb/uM6sUP2C+RlH87yU/T3fBwA4s+ZOAnzafQQdAfT+J7PBiRrRtlQHyJvWXAHB6Eur0TJikg
	B1pZhMJ8xNW5tMmU3dqg==
X-Received: by 2002:a05:6000:2889:b0:48e:f10:ceb8 with SMTP id
 ffacd0b85a97d-48e6e2e769amr7083674f8f.11.1793390589698; Fri, 30 Oct 2026
 13:03:09 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <sashiko-outbox-183933@kernel.org> <20261027020028.46469-1-lance.yang@linux.dev>
In-Reply-To: <20261027020028.46469-1-lance.yang@linux.dev>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 30 Oct 2026 13:02:57 -0700
X-Gm-Features: AclHuK_7IYKLpIDctVlag5Cj_OywTtUkgo4U983VqV13bhHI3MkyW6t772-gCtM
Message-ID: <CAJnrk1ao-GiMpXbFQcySEpX_XxAuKXPOEqgbq0Oji7Gp1Q8ZnA@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] mm/huge_memory: scale thp_underused() to the folio size
To: Lance Yang <lance.yang@linux.dev>
Cc: sashiko-bot@kernel.org, akpm@linux-foundation.org, david@kernel.org, 
	ljs@kernel.org, baohua@kernel.org, usama.arif@linux.dev, hannes@cmpxchg.org, 
	kas@kernel.org, alex@ghiti.fr, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	willy@infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: pesz5bmurqh1escibkxj1pk9b6w4d3oj
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2DE2214000C
X-Rspam-User: 
X-HE-Tag: 1793390591-625805
X-HE-Meta: U2FsdGVkX19weksV/KJD5chGNm+aFhmQH9xLylQuSrdmHFTJfOxSc1ehMXeJ9FkUyfHf8QnbNlFIlnWGfhX6hC5HMau6MnHGellvxNpYbUhsn71TbBEzHu+GJ6OvKiC6kFmdlaZLDWWIkePIRZp46PvHAZs5r28fVsqgvntpRUGeF8aTsuGsyfXc8n15nyVkt6d15DGZE+/p6hKLMFJnM3doU+KLEgXt5bU6UOvZSdKgbfyuCef2W6DC70MYjicAT8eE3gWXO3RpX7e6+a3N4TTOAsvfF7Pk5P4npPV/TaeuknhJGuYtJuMHojwFWF897srSpN7s7AmO/qADLSfY12U++DA4yqNiPCbO5U6Hz8GC9nTQf086bK8xaNRGaObcgcBGAZM6IZEiSbMjfJsvrCpecnBBfZVBu6CxFn4Vo/Ac2M3JzYtl9REb5FRNeZ251fwBph5ukAD39SB9bG7iRd/C5a983pWRPS6gitfi6fTJt+CfI/gN/DoQNkxABY0mdv8TWAVzk/be/Ahq3wiSLb/EIpFqhX6lEJGUkYTSmIY4KG+FvGbfJ0NIATmMwpqEwYkG6XFhiJOeOvdSfBO3Dcd1QWAKLSbuN7W3KbFPTM4wnqrofqZNJqTficcBwDTZVYzFaZ77tFUdUql6EN2nTC8B3EZmAGvYnECDYbdODjHcavv5L9TR3YP5a7r0BhQoe1I0okUJ6+3jEhXa7EcSh2jH+5nFE+J880Nf4gtCc2dOB4jwcJSwdDWAf6RNzs4jImICELCiiQQlYRHx346FUYTbcUrUSxBLEW9Ygl24HdsNxyD0C/elViQt/XwK+mbeu5IQ/AKMRk70ns8m+NaL5/6JmMGs7uWkrL4ke3ggwtpTPT9+87bjB25xMOlR3l9ry9HMM8GrUL1DVdU5gcEHTEjv5kHFJoRq/P6n9rBckAPpio+NaASGMhsRIiSntivI4G1oYsV/lBdsSfykry0
 VGrPGzNL
 uR1Gcv0bTKeIh0KYSOGDk/e8M1SsAmjfVxgbxYtrpT5bTRFDo5L0pQzuxBwPJLTQtzSBu/ZStVk8d7M7RmxszBvU77I9NCmieWvWU0OltnY03y8d5+YR+ZDmFuQ7TV0fLciilVMtzYWMlmcvBx4TmHe0bE9x28mhDu5w67Aeez6QtNbIsqHk6f77ZDj9yIdAzmYVO2YuPRD+ZdiJOXesAFZKNOfPZ0Bw9qH5HX5LplBzpK3wt44eXyPbUPm5wOiW1YdyY0rqo93WDUKrxSZezONDgQM4BxTful07P6I/QbYJOLwy5Lp9/HLWJK+Z5pEVnZDSrDk//5Wn7N1rQNM14pmykwtzyKSOSMTSVh7JJk5uebwd7TnxOnzCNqYtbK4zQgHsWxKoFONA1o2g8nVpgqcewHDBmDJQfGnI89ZUgu/JBQVK44mXr3+jZ7IZI9KJ2aKS+PSH9nURhYoW7J1TiVmC6Bd7nJqc7d/imy918T0veKqWv0ON2eBQFXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 7:00=E2=80=AFPM Lance Yang <lance.yang@linux.dev> w=
rote:
>
>
> On Sat, Oct 24, 2026 at 11:01:50PM +0000, sashiko-bot@kernel.org wrote:
> >Thank you for your contribution! Sashiko AI review found 1 potential iss=
ue(s) to consider:
> >- [Medium] mm/huge_memory: wrong rounding in thp_underused() max_ptes_no=
ne scaling
> >--
> >
> >commit 56eb0cfccba9e5e4276f2a8250815399987bc848
> >Author: Joanne Koong <joannelkoong@gmail.com>
> >
> >mm/huge_memory: scale thp_underused() to the folio size
> >
> >This commit updates thp_underused() to scale khugepaged_max_ptes_none
> >proportionally to the number of pages in the folio rather than assuming
> >the folio has HPAGE_PMD_NR pages.
> >
> >> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> >> index bd44d58e86845..218259940f24d 100644
> >> --- a/mm/huge_memory.c
> >> +++ b/mm/huge_memory.c
> >> @@ -4613,25 +4613,35 @@ static unsigned long deferred_split_count(stru=
ct shrinker *shrink,
> >>
> >>  static bool thp_underused(struct folio *folio)
> >>  {
> >> -    int num_zero_pages =3D 0, num_filled_pages =3D 0;
> >> -    int i;
> >> +    const unsigned long nr_pages =3D folio_nr_pages(folio);
> >> +    unsigned long num_zero_pages =3D 0, num_filled_pages =3D 0;
> >> +    unsigned long max_ptes_none =3D khugepaged_max_ptes_none;
> >> +    unsigned long i;
> >>
> >> -    if (khugepaged_max_ptes_none =3D=3D HPAGE_PMD_NR - 1)
> >> +    if (max_ptes_none =3D=3D HPAGE_PMD_NR - 1)
> >>              return false;
> >>
> >>      if (folio_contain_hwpoisoned_page(folio))
> >>              return false;
> >>
> >> -    for (i =3D 0; i < folio_nr_pages(folio); i++) {
> >> +    /*
> >> +     * khugepaged_max_ptes_none is a number of pages out of HPAGE_PMD=
_NR.
> >> +     * Scale it to this folio's size (rounding up so that the folio i=
s never
> >> +     * split when fewer than the configured fraction of its pages are
> >> +     * zero-filled).
> >> +     */
> >> +    max_ptes_none =3D DIV_ROUND_UP(max_ptes_none * nr_pages, HPAGE_PM=
D_NR);
> >> +
> >> +    for (i =3D 0; i < nr_pages; i++) {
> >>              if (pages_identical(folio_page(folio, i), ZERO_PAGE(0))) =
{
> >> -                    if (++num_zero_pages > khugepaged_max_ptes_none)
> >> +                    if (++num_zero_pages > max_ptes_none)
> >>                              return true;
> >
> >[Severity: Medium]
> >Should max_ptes_none in thp_underused() be scaled with truncating intege=
r
> >division rather than DIV_ROUND_UP()?
>
> Agreed, we already use a strict > comparison, so truncating division
> is enough here.
>

Agreed, thanks. I'll switch back to truncating division in v4.

Thanks,
Joanne

