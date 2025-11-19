Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 454BECF58C9
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 19:22:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EB056B0093; Wed, 19 Nov 2025 14:22:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59A616B00BA; Wed, 19 Nov 2025 14:22:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 462BE6B00BD; Wed, 19 Nov 2025 14:22:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2D3C66B0093
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 14:22:13 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4DB34C05EB
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 19:22:09 +0000 (UTC)
X-FDA: 84128327178.23.1C5803B
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5751E18000B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 19:22:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=O1JJ+sqn;
	spf=pass (imf16.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763580127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=29aKy7Zpte2m3nxAAyvYo2cSpgE57NiENRIGV6SZof4=;
	b=NgpoPFeCfLqOyzznIqiZeUroEMe3DaOwMtODeCPlulJy34ovYuWgCgqj5Z0HxiBUBCNkhi
	5uAFT1UAv0So8I3Gwzze14l1CzaI4/IYCAYhVYyiJ2Nj9oSW+QuzzD0DhvJ4GCPcv6vmM1
	Qx80dSm0YJ1jKUSjTLbcvHacKbJ+jS8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=O1JJ+sqn;
	spf=pass (imf16.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763580127; a=rsa-sha256;
	cv=none;
	b=kqa8Xp+nPLfZKBjbt/MoAl0wJ/Ha/XWaJnWqXDP9XIOSZBNkPoghNivWBY8w8NZiEl0YlL
	3TJcEmiPyql9y+EU3TsPjSI9rHCXQRbCoAUlWnuLI2SvwY3RHCMs5nlcrk0QlgZtt5m7hk
	KiQycDGBn+WZYcAIRk8TCed+KQB6HdM=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4ee147baf7bso44441cf.1
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 11:22:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763580126; x=1764184926; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=29aKy7Zpte2m3nxAAyvYo2cSpgE57NiENRIGV6SZof4=;
        b=O1JJ+sqn6Ij0OhYOf9G8M8jR9uj2fm/ek6EDOzgUshg/2h6Tni6YPaSEqxhMmkndTx
         bW0CL0aULpa+2JUulDjusMlIMnMWuVF/bC/baFFHBBFGjIm70ic5CQP/coMWm9SwzpS2
         EfDz5hWUkSTKLcBgX9xGS4AGam/mnlXyXJadb4tKvV2dfVI2+1nOHb+0djL63SrNVssk
         +UpXT47GGz3ecZzgDtm6soCesijFWL065AIt+d/Y7mtvlL3vvk+OaGS4IxF/DpuY8SD3
         2knwyLGGVgXpeUPO/RedLtbt/G/8bcVgOhN4OPo2Ss2Vqd9TcR8daAJ9aKLhgsQi/8WF
         YC1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763580126; x=1764184926;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=29aKy7Zpte2m3nxAAyvYo2cSpgE57NiENRIGV6SZof4=;
        b=jpV25KesmIoLGRwWir6Y4JxoFm1YayP74qQ5MjyWRzWfTBQ5afkYvLNVE4gLB5Pd3C
         2SLS+1POi9ZfvobGt+ajQnUCPD3rpVLOmL83uohbGircTmRo/DIdsy4VMWSgBUN7LM4h
         NRdPPqarIKyqWrFwg0bFhDrBbmAIYU9uEyndQe2ZHURGTwosunqyjTQVy0T3fRFld+5/
         vLWZL4d0qhf219EUguqqSfe1pS91EjHDoLh5f8sggXcTtRFq4SwU6/2l8Maw90fHDkpR
         C5Ku+sP+QTtZug1DKYtgLIREaJor0OOo2siqeC20QN1pd3txHQEfWIWHwtaox8nbv9s3
         gv7Q==
X-Forwarded-Encrypted: i=1; AJvYcCUq+kjL0ONGwD4FqNH5T0J7OWBEdASAy10uWv32llV3098x64ZjyE3k+YUfePSudceIkfBbHsrh5Q==@kvack.org
X-Gm-Message-State: AOJu0YzFGycKwG8DkFPXRSz/vDt+wjfxbp6dmVJEJKtCSwo++sES3UUO
	bfnqZtdirZSps2vl6whj+d1+Wey0lCF4VTSrMAgzzXeGgszUVfs80S2DMHrm/wJl8lp/8KLbdKS
	fEUkr7/0018pC9oNG/1sZYCRiLxYD7CvtWATTnFJt
X-Gm-Gg: ASbGncspy/m8e/AqqG7yfyGdnvTxltX4QOAcmY97hVAg3JALlJuQO9WuQHCznV014MV
	bq9t7qG00d/sZ0d5UPpNQUdx/EDk4bCtuyuXrDXWpemA4t9PJgPHfOLWHAYEvFZ7mdNXs1Pu7sO
	kI7hgRtBQRBOAibSBQ4Q+0Kd4Zdps8JCIrP0CY56Pd52TT6Uv8RwcFbNHyGN0fWpw4YK0zQ50hU
	iu/gvIXJNVOPbRWpIHNrP5UXkNLT2M7Bki1Qex+PDpENpzeoEksb8ACoEQbJSzzyV8NaO6zZbmY
	y77ova5+Fod7tQpOTgNy7uA93oFA/FH8ENdvttM=
X-Google-Smtp-Source: AGHT+IGQFg/Mn0AwTx6uUfhJLAvIvZhv0JODOijUlxmdaIIq33TpSvbn/5A8w9CJAXsG+V1v7+5CpUv0MNn0aard99Q=
X-Received: by 2002:ac8:7d94:0:b0:4e6:eaee:a944 with SMTP id
 d75a77b69052e-4ee49b80621mr516821cf.4.1763580126001; Wed, 19 Nov 2025
 11:22:06 -0800 (PST)
MIME-Version: 1.0
References: <20251116014721.1561456-1-jiaqiyan@google.com> <20251116014721.1561456-2-jiaqiyan@google.com>
 <aRm6shtKizyrq_TA@casper.infradead.org> <aRqTLmJBuvBcLYMx@hyeyoo>
 <aRsmaIfCAGy-DRcx@casper.infradead.org> <CACw3F50E=AZtgfoExCA-nwS6=NYdFFWpf6+GBUYrWiJOz4xwaw@mail.gmail.com>
 <aRxIP7StvLCh-dc2@hyeyoo> <CACw3F53Rck2Bf_C45Uk=A1NJ4zB1B0R1+GqvkNxsz3h3mDx-pQ@mail.gmail.com>
 <5D76156D-A84F-493B-BD59-A57375C7A6AF@nvidia.com> <aR257PivQXpEGbKb@hyeyoo>
In-Reply-To: <aR257PivQXpEGbKb@hyeyoo>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Wed, 19 Nov 2025 11:21:51 -0800
X-Gm-Features: AWmQ_bnflews9k8QsmDjYEsLyhMJn14T6IKgw8Lhx7j6d_4tUtCoPhCKHosxQqs
Message-ID: <CACw3F50OzEuVco762kNS1ONyzFU1M6MQUjYd1ybtHCMcg6pmdA@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] mm/huge_memory: introduce uniform_split_unmapped_folio_to_zero_order
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Matthew Wilcox <willy@infradead.org>, david@redhat.com, 
	Vlastimil Babka <vbabka@suse.cz>, nao.horiguchi@gmail.com, linmiaohe@huawei.com, 
	lorenzo.stoakes@oracle.com, william.roche@oracle.com, tony.luck@intel.com, 
	wangkefeng.wang@huawei.com, jane.chu@oracle.com, akpm@linux-foundation.org, 
	osalvador@suse.de, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5751E18000B
X-Stat-Signature: 8zbahnje3awz8q4p9qmrr38tdr56p3b5
X-Rspam-User: 
X-HE-Tag: 1763580127-78885
X-HE-Meta: U2FsdGVkX18Q+iGOQzkMQh6KvQi7aOZLfGlJBxVXiHG1ggBPEpqTIE8xX79B8jvbSDpqsTK+Xo4Kv7iBaICMHvczTA88IRA/wmOGq2r68XBvVSH1iJp8XAlcrs081VnRuCJ0aeY2hN3fyP8Z6HU9IR5p4IbBPjk+ER+9f3cIPKDzrmc9LhRmBjWANw/PyE1ZIyq4keO3iPi/gui8ppoeTxC/ZvsQi+4OxcSKIJu0mi1vzhKBBmOCmz7HGoxIA3L/AJQkQmA90WJx+8qb4JNFkskRI3n9mSTe/r9z864EgIEznEYZhpVrZ87ygi2EoLdsTlWaAKPNxFnhvWBqtE9RFwV1sW7iYgZpnrHsCDyZEQzCSzYv+oSwIM0MpUpSdiUwxzLJiiIpw7sELv2ILLkYEyHE7iKdwqbUDItpIJjbuiX6N7dGmZe0u7Fvr7c0G4aXeIIOvnZ1tal4RKkBK6ZdZXA+LSqlG+EnGb+Ce7UeGZ127gGLzKjih+1mJe/czapC8R3J44eQo/Y2VuG+z8eyet+6g6Jsy1q1nI8rbDD4rJfliJNLgrE296YK78h4kRnqCttzV7rtO+spTgW5OUANQe91Rqq1AN1TtrmCoPhirPpzJEDPcM73dTZ9bRM3clkOX+15TWD3l6QjqKLLkURlVPfSOaATvImMDjDfGRQXLDeEzZpcqXxwnNy8UmvRjwyg3JV0iwnan1eAnDMf+Uv52Qde9xmHdWieeEGQn6lB9+0c/ObYMKnxJgryhGU09LQwxOKFR1Kitbop1UUQ1ZO3YeyRBAt9QiGiRO2rvLwpV+1Y4gKHIfxhLsCadwyHJQZChuKXepX5oujaEThgm2xkchBj+HEKcBGGYwGfo1YM0iuHwwrNWwsxqic+G45DgLHqi6uVDhYUAPgE0oEl4iS57cSojDwB8b4Th/PYuPYRy7TIUwuClm2wkxEz+UBk9SZ/uSpcgel+u6DPENeDLzv
 X6UuKlKo
 jAX9fJRf4eHUKFpWk/s4EVNGQLCKmq3QSuUXY14z2T4DbJ7porT2eXPlwmoEj+XjypGV2bGI2j2MMFx/r50J2flL9p1FE0VhDVPNCOfOMHsd3rZwAm7E19CJkNbQcN+KsQrFCCJsWN0IBnVGwF/IuLPW51Kdn2rbFvEWNTVaFqPPDozvNlv7cjUrOifv/FtpW0tufH/IrMrN0OuIIKkX55+hVzoREZcARE0l7DzBf7t/rcDZrTwBD+nB95bj2TjLS1EGi6S5OsLUsR+CMYN0nU5ObWt0reHLs+HKm/n5oxgpux/LeBX7ud5V8NMK5hlOHq3YLxUNXl03eCvUc6/Q7IMs6HdI6EtXxIiz57uK6YxcMnWn9cna+bZRhx6bn1OLSGTQM3MLcLXrJD+gPj88a6JayChO1iDNPjnDs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 4:37=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> On Tue, Nov 18, 2025 at 04:54:31PM -0500, Zi Yan wrote:
> > On 18 Nov 2025, at 14:26, Jiaqi Yan wrote:
> >
> > > On Tue, Nov 18, 2025 at 2:20=E2=80=AFAM Harry Yoo <harry.yoo@oracle.c=
om> wrote:
> > >>
> > >> On Mon, Nov 17, 2025 at 10:24:27PM -0800, Jiaqi Yan wrote:
> > >>> On Mon, Nov 17, 2025 at 5:43=E2=80=AFAM Matthew Wilcox <willy@infra=
dead.org> wrote:
> > >>>>
> > >>>> On Mon, Nov 17, 2025 at 12:15:23PM +0900, Harry Yoo wrote:
> > >>>>> On Sun, Nov 16, 2025 at 11:51:14AM +0000, Matthew Wilcox wrote:
> > >>>>>> But since we're only doing this on free, we won't need to do fol=
io
> > >>>>>> allocations at all; we'll just be able to release the good pages=
 to the
> > >>>>>> page allocator and sequester the hwpoison pages.
> > >>>>>
> > >>>>> [+Cc PAGE ALLOCATOR folks]
> > >>>>>
> > >>>>> So we need an interface to free only healthy portion of a hwpoiso=
n folio.
> > >>>
> > >>> +1, with some of my own thoughts below.
> > >>>
> > >>>>>
> > >>>>> I think a proper approach to this should be to "free a hwpoison f=
olio
> > >>>>> just like freeing a normal folio via folio_put() or free_frozen_p=
ages(),
> > >>>>> then the page allocator will add only healthy pages to the freeli=
st and
> > >>>>> isolate the hwpoison pages". Oherwise we'll end up open coding a =
lot,
> > >>>>> which is too fragile.
> > >>>>
> > >>>> Yes, I think it should be handled by the page allocator.  There ma=
y be
> > >>>
> > >>> I agree with Matthew, Harry, and David. The page allocator seems be=
st
> > >>> suited to handle HWPoison subpages without any new folio allocation=
s.
> > >>
> > >> Sorry I should have been clearer. I don't think adding an **explicit=
**
> > >> interface to free an hwpoison folio is worth; instead implicitly
> > >> handling during freeing of a folio seems more feasible.
> > >
> > > That's fine with me, just more to be taken care of by page allocator.
> > >
> > >>
> > >>>> some complexity to this that I've missed, eg if hugetlb wants to r=
etain
> > >>>> the good 2MB chunks of a 1GB allocation.  I'm not sure that's a us=
eful
> > >>>> thing to do or not.
> > >>>>
> > >>>>> In fact, that can be done by teaching free_pages_prepare() how to=
 handle
> > >>>>> the case where one or more subpages of a folio are hwpoison pages=
.
> > >>>>>
> > >>>>> How this should be implemented in the page allocator in memdescs =
world?
> > >>>>> Hmm, we'll want to do some kind of non-uniform split, without act=
ually
> > >>>>> splitting the folio but allocating struct buddy?
> > >>>>
> > >>>> Let me sketch that out, realising that it's subject to change.
> > >>>>
> > >>>> A page in buddy state can't need a memdesc allocated.  Otherwise w=
e're
> > >>>> allocating memory to free memory, and that way lies madness.  We c=
an't
> > >>>> do the hack of "embed struct buddy in the page that we're freeing"
> > >>>> because HIGHMEM.  So we'll never shrink struct page smaller than s=
truct
> > >>>> buddy (which is fine because I've laid out how to get to a 64 bit =
struct
> > >>>> buddy, and we're probably two years from getting there anyway).
> > >>>>
> > >>>> My design for handling hwpoison is that we do allocate a struct hw=
poison
> > >>>> for a page.  It looks like this (for now, in my head):
> > >>>>
> > >>>> struct hwpoison {
> > >>>>         memdesc_t original;
> > >>>>         ... other things ...
> > >>>> };
> > >>>>
> > >>>> So we can replace the memdesc in a page with a hwpoison memdesc wh=
en we
> > >>>> encounter the error.  We still need a folio flag to indicate that =
"this
> > >>>> folio contains a page with hwpoison".  I haven't put much thought =
yet
> > >>>> into interaction with HUGETLB_PAGE_OPTIMIZE_VMEMMAP; maybe "other =
things"
> > >>>> includes an index of where the actually poisoned page is in the fo=
lio,
> > >>>> so it doesn't matter if the pages alias with each other as we can =
recover
> > >>>> the information when it becomes useful to do so.
> > >>>>
> > >>>>> But... for now I think hiding this complexity inside the page all=
ocator
> > >>>>> is good enough. For now this would just mean splitting a frozen p=
age
> > >>>
> > >>> I want to add one more thing. For HugeTLB, kernel clears the HWPois=
on
> > >>> flag on the folio and move it to every raw pages in raw_hwp_page li=
st
> > >>> (see folio_clear_hugetlb_hwpoison). So page allocator has no hint t=
hat
> > >>> some pages passed into free_frozen_pages has HWPoison. It has to
> > >>> traverse 2^order pages to tell, if I am not mistaken, which goes
> > >>> against the past effort to reduce sanity checks. I believe this is =
one
> > >>> reason I choosed to handle the problem in hugetlb / memory-failure.
> > >>
> > >> I think we can skip calling folio_clear_hugetlb_hwpoison() and teach=
 the
> > >
> > > Nit: also skip folio_free_raw_hwp so the hugetlb-specific llist
> > > containing the raw pages and owned by memory-failure is preserved? An=
d
> > > expect the page allocator to use it for whatever purpose then free th=
e
> > > llist? Doesn't seem to follow the correct ownership rule.
> > >
> > >> buddy allocator to handle this. free_pages_prepare() already handles
> > >> (PageHWPoison(page) && !order) case, we just need to extend that to
> > >> support hugetlb folios as well.
> > >>
> > >>> For the new interface Harry requested, is it the caller's
> > >>> responsibility to ensure that the folio contains HWPoison pages (to=
 be
> > >>> even better, maybe point out the exact ones?), so that page allocat=
or
> > >>> at least doesn't waste cycles to search non-exist HWPoison in the s=
et
> > >>> of pages?
> > >>
> > >> With implicit handling it would be the page allocator's responsibili=
ty
> > >> to check and handle hwpoison hugetlb folios.
> > >
> > > Does this mean we must bake hugetlb-specific logic in the page
> > > allocator's freeing path? AFAICT today the contract in
> > > free_frozen_page doesn't contain much hugetlb info.
> > >
> > > I saw there is already some hugetlb-specific logic in page_alloc.c,
> > > but perhaps not valid for adding more.
> > >
> > >>
> > >>> Or caller and page allocator need to agree on some contract? Say
> > >>> caller has to set has_hwpoisoned flag in non-zero order folio to fr=
ee.
> > >>> This allows the old interface free_frozen_pages an easy way using t=
he
> > >>> has_hwpoison flag from the second page. I know has_hwpoison is "#if
> > >>> defined" on THP and using it for hugetlb probably is not very clean=
,
> > >>> but are there other concerns?
> > >>
> > >> As you mentioned has_hwpoisoned is used for THPs and for a hugetlb
> > >> folio. But for a hugetlb folio folio_test_hwpoison() returns true
> > >> if it has at least one hwpoison pages (assuming that we don't clear =
it
> > >> before freeing).
> > >>
> > >> So in free_pages_prepare():
> > >>
> > >> if (folio_test_hugetlb(folio) && folio_test_hwpoison(folio)) {
> > >>   /*
> > >>    * Handle hwpoison hugetlb folios; transfer the error information
> > >>    * to individual pages, clear hwpoison flag of the folio,
> > >>    * perform non-uniform split on the frozen folio.
> > >>    */
> > >> } else if (PageHWPoison(page) && !order) {
> > >>   /* We already handle this in the allocator. */
> > >> }
> > >>
> > >> This would be sufficient?
> > >
> > > Wouldn't this confuse the page allocator into thinking the healthy
> > > head page is HWPoison (when it actually isn't)? I thought that was on=
e
> > > of the reasons has_hwpoison exists.
>
> AFAICT in the current code we don't set PG_hwpoison on individual
> pages for hugetlb folios, so it won't confuse the page allocator.
>
> > Is there a reason why hugetlb does not use has_hwpoison flag?
>
> But yeah sounds like hugetlb is quite special here :)
>
> I don't see why we should not use has_hwpoisoned and I think it's fine
> to set has_hwpoisoned on hwpoison hugetlb folios in
> folio_clear_hugetlb_hwpoison() and check the flag in the page allocator!
>
> And since the split code has to scan base pages to check if there
> is an hwpoison page in the new folio created by split (as Zi Yan mentione=
d),
> I think it's fine to not skip calling folio_free_raw_hwp() in
> folio_clear_hugetlb_hwpoison() and set has_hwpoisoned instead, and then
> scan pages in free_pages_prepare() when we know has_hwpoisoned is set.
>
> That should address Jiaqi's concern on adding hugetlb-specific code
> in the page allocator.
>
> So summing up:
>
> 1. Transfer raw hwp list to individual pages by setting PG_hwpoison
>    (that's done in folio_clear_hugetlb_hwpoison()->folio_free_raw_hwp()!)
>
> 2. Set has_hwpoisoned in folio_clear_hugetlb_hwpoison()

IIUC, #1 and #2 are exactly what I considered: no change in
folio_clear_hugetlb_hwpoison, but set the has_hwpoisoned flag (instead
of HWPoison flag) to the folio as the hint to page allocator.

>
> 3. Check has_hwpoisoned in free_pages_prepare() and if it's set,
>    iterate over all base pages and do non-uniform split by calling
>    __split_unmapped_folio() at each hwpoisoned pages.

IIUC, directly re-use __split_unmapped_folio still need some memory
overhead. But I believe that's log(n) and much better than the current
uniform split version. So if that's acceptable, I can give this
solution a try.

>
>    I think it's fine to iterate over base pages and check hwpoison flag
>    as long as we do that only when we know there's an hwpoison page.
>
>    But maybe we need to dispatch the job to a workqueue as Zi Yan said,
>    because it'll take a while to iterate 512 * 512 pages when we're freei=
ng
>    1GB hugetlb folios.
>
> 4. Optimize __split_unmapped_folio() as suggested by Zi Yan below.
>
> BTW I think we have to discard folios that has hwpoison pages
> when we fail to split some parts? (we don't have to discard all of them,
> but we may have managed to split some parts while other parts failed)
>

Maybe we can fail in other places, but at least __split_unmapped_folio
can't fail when mapping is NULL, which is the case for us.

> --
> Cheers,
> Harry / Hyeonggon
>
> > BTW, __split_unmapped_folio() currently sets has_hwpoison to the after-=
split
> > folios by scanning every single page in the to-be-split folio.
> >
> > The related code is in __split_folio_to_order(). But the code is not
> > efficient for non-uniform split, since it calls __split_folio_to_order(=
)
> > multiple time, meaning when non-uniform split order-N to order-0,
> > 2^(N-1) pages are scanned once, 2^(N-2) pages are scanned twice,
> > 2^(N-3) pages are scanned 3 times, ..., 4 pages are scanned N-4 times.
> > It can be optimized with some additional code in __split_folio_to_order=
().
> >
> > Something like the patch below, it assumes PageHWPoison(split_at) =3D=
=3D true:
> >
> > From 219466f5d5edc4e8bf0e5402c5deffb584c6a2a0 Mon Sep 17 00:00:00 2001
> > From: Zi Yan <ziy@nvidia.com>
> > Date: Tue, 18 Nov 2025 14:55:36 -0500
> > Subject: [PATCH] mm/huge_memory: optimize hwpoison page scan
> >
> > Signed-off-by: Zi Yan <ziy@nvidia.com>
> > ---
> >  mm/huge_memory.c | 13 ++++++++-----
> >  1 file changed, 8 insertions(+), 5 deletions(-)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index d716c6965e27..54a933a20f1b 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -3233,8 +3233,11 @@ bool can_split_folio(struct folio *folio, int ca=
ller_pins, int *pextra_pins)
> >                                       caller_pins;
> >  }
> >
> > -static bool page_range_has_hwpoisoned(struct page *page, long nr_pages=
)
> > +static bool page_range_has_hwpoisoned(struct page *page, long nr_pages=
, struct page *donot_scan)
> >  {
> > +     if (donot_scan && donot_scan >=3D page && donot_scan < page + nr_=
pages)
> > +             return false;
> > +
> >       for (; nr_pages; page++, nr_pages--)
> >               if (PageHWPoison(page))
> >                       return true;
> > @@ -3246,7 +3249,7 @@ static bool page_range_has_hwpoisoned(struct page=
 *page, long nr_pages)
> >   * all the resulting folios.
> >   */
> >  static void __split_folio_to_order(struct folio *folio, int old_order,
> > -             int new_order)
> > +             int new_order, struct page *donot_scan)
> >  {
> >       /* Scan poisoned pages when split a poisoned folio to large folio=
s */
> >       const bool handle_hwpoison =3D folio_test_has_hwpoisoned(folio) &=
& new_order;
> > @@ -3258,7 +3261,7 @@ static void __split_folio_to_order(struct folio *=
folio, int old_order,
> >
> >       /* Check first new_nr_pages since the loop below skips them */
> >       if (handle_hwpoison &&
> > -         page_range_has_hwpoisoned(folio_page(folio, 0), new_nr_pages)=
)
> > +         page_range_has_hwpoisoned(folio_page(folio, 0), new_nr_pages,=
 donot_scan))
> >               folio_set_has_hwpoisoned(folio);
> >       /*
> >        * Skip the first new_nr_pages, since the new folio from them hav=
e all
> > @@ -3308,7 +3311,7 @@ static void __split_folio_to_order(struct folio *=
folio, int old_order,
> >                                LRU_GEN_MASK | LRU_REFS_MASK));
> >
> >               if (handle_hwpoison &&
> > -                 page_range_has_hwpoisoned(new_head, new_nr_pages))
> > +                 page_range_has_hwpoisoned(new_head, new_nr_pages, don=
ot_scan))
> >                       folio_set_has_hwpoisoned(new_folio);
> >
> >               new_folio->mapping =3D folio->mapping;
> > @@ -3438,7 +3441,7 @@ static int __split_unmapped_folio(struct folio *f=
olio, int new_order,
> >               folio_split_memcg_refs(folio, old_order, split_order);
> >               split_page_owner(&folio->page, old_order, split_order);
> >               pgalloc_tag_split(folio, old_order, split_order);
> > -             __split_folio_to_order(folio, old_order, split_order);
> > +             __split_folio_to_order(folio, old_order, split_order, uni=
form_split ? NULL : split_at);
> >
> >               if (is_anon) {
> >                       mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
> > --
> > 2.51.0
> >
> > >> Or do we want to handle THPs as well, in case of split failure in
> > >> memory_failure()? if so we need to handle folio_test_has_hwpoisoned(=
)
> > >> case as well...
> > >
> > > Yeah, I think this is another good use case for our request to page a=
llocator.
> > >
> > >>
> > >>>>> inside the page allocator (probably non-uniform?). We can later r=
e-implement
> > >>>>> this to provide better support for memdescs.
> > >>>>
> > >>>> Yes, I like this approach.  But then I'm not the page allocator
> > >>>> maintainer ;-)
> > >>>
> > >>> If page allocator maintainers can weigh in here, that will be very =
helpful!
> > >>
> > >> Yeah, I'm not a maintainer either ;) it'll be great to get opinions
> > >> from page allocator folks!
> >
> > I think this is a good approach as long as it does not add too much ove=
rhead
> > on the page freeing path. Otherwise dispatch the job to a workqueue?
> >
> > Best Regards,
> > Yan, Zi

