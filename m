Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 701E5CCD1B9
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 19:08:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 994128E000C; Tue, 21 Oct 2025 15:08:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96B1D8E0002; Tue, 21 Oct 2025 15:08:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 881328E000C; Tue, 21 Oct 2025 15:08:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 781C18E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:08:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EBCDFC0501
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 19:08:05 +0000 (UTC)
X-FDA: 84023056530.28.35AEF1F
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	by imf29.hostedemail.com (Postfix) with ESMTP id 17D59120014
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 19:08:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=if4Z4kQ5;
	spf=pass (imf29.hostedemail.com: domain of shy828301@gmail.com designates 209.85.217.43 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761073684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ih1Ch3iw7RIxA9JcjZCICBR9PPRDjzjVXI5AMkESEI0=;
	b=yZFZ/Sg+PyhL5yqhCuTl1mObxWGPYl6Cw317DNjXFVb/d4O73iOdQX74zfQUrY5fHGxpIb
	kGlg3nf4/HWwn2cen8BebDZ5I6Kj/BhCpRfvKmvsYZY0ZjZzEle7c/VlueshNr+bCtiwsM
	KRtlCgYrlJvq25ArFk9eUsb+NSGzin8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=if4Z4kQ5;
	spf=pass (imf29.hostedemail.com: domain of shy828301@gmail.com designates 209.85.217.43 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761073684; a=rsa-sha256;
	cv=none;
	b=YCIaRMFTbPbm5fVyFtyJlERlJfXIHoUwTh3pLRy0uD3nhIsNhg0gFSQw6xjainN509MzjS
	7DtucL9g4kCGEp8QPwYqo8+ws6GmYg9bKBqx8ujp8oPF/3oEImEfcABAJajn29ezG2odzX
	dG8pOeQVJHNPFVpf56iJ8KdF9wljPVs=
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-5a3511312d6so3011791137.3
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761073683; x=1761678483; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ih1Ch3iw7RIxA9JcjZCICBR9PPRDjzjVXI5AMkESEI0=;
        b=if4Z4kQ5a5ZB/7dROUKX91qkcw87HvEQn7P4o1ktdjZpyqp+Q0F/lBzrIyviGIFriz
         AYbq4oFKLdOLaU2O96l/vNcwjS5Y06IwwrDWz1Voszrq1Ug0iOoiUAdEFWhzel4IUwJ6
         9UzG6BQ/2pyExEEC57e6OsJxKLdlNWLd2H1AwS6aEWAHb4V/0U5o6ioXYRyYCZyuWUSI
         gX2RGLBOB08bPCkK63ZUIhQdhQbxHbaQ6v1t7zjX6WK69E+INSukJdCDWO13VHt44XzD
         5klmrK2VYeggmEOeaIwFbDAwQ/ZpKOVkGPEI57nIGdXXPKsWO016WNSHYQ/fhx8my63G
         VPsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761073683; x=1761678483;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ih1Ch3iw7RIxA9JcjZCICBR9PPRDjzjVXI5AMkESEI0=;
        b=i4tEgzXwceZrtUYeSJHN7Mdr9Z7dFY/lPr6OwlCCgoGVke97vJnz+26ffwJcdM5BxI
         ggenSot2e7CKQ1+WlYqvFH+RgGgywFDViTMFwZtRmGMBCdHGBEyskeXWGVN11Nc4rCIj
         I3vbbZr8H8Wa8dmlaRFFwA9nXn/qS2FAlalYLXjHLfaePEoQ+6FMMDHAo4hZSMuMsR7c
         1V8R4pfCUhxtM7CI9xrL7ri3T1F0ZvHUutK6qeuZbLhWp43iEFPN0RUPcJCUMZ1cetGb
         kDxupWnJfZcyw5o0M2jM0tzXbT9405DkmZjEhaRk3mbLYRP1Zm0Wc4KZY0jfszDfNckn
         ywMA==
X-Forwarded-Encrypted: i=1; AJvYcCWho3l8/d03RYpMKypWdkzmbIymX0gIl9fxpUNOKbzTkj/Dh06ltMZ2KqchaxKPDEpQ0yURqXjCpg==@kvack.org
X-Gm-Message-State: AOJu0Yw2p78fotce3jIxsWt7CMxFgwf0kKKJorR7eGpC0YmKlqflxPyc
	wYL5tf0R/dKfYTNwwzopQQJZFwzgRZFYS2v8rXO+Tuia1++yEpqR6lzNuX18rQVJ6cIIA+4GBy9
	RIC+C6kbpzJumeHWVqs2zdGkT4Rgmo+c=
X-Gm-Gg: ASbGncvx8xXIy4czIJ7+pEYNtb00Xw3kna1VsNWoAiG63p7XUzSON6YF8vC1Ig6FRe3
	AGJGXg0JTcUlJv0NyAKySzTEGWsMIgYkRJCoLqif2XXhAbFI83LHCnW3+w5isZ2P/MeuHC2Nv3H
	gpcg6xoz51eAro1R90DdJNEXPtreoFdWJUTR/eODHX0lCaBKZ2L/Kml4yOzxhAMTCASEWXlnqK4
	u47QzcwSmAh+2LSFb3fZPcHt8WYHSOnw/4HC3/mJX5oXw+KnmE19ZPA+w2jEQa0Dmsl5fQRFg==
X-Google-Smtp-Source: AGHT+IFlj4r2CIdxYmWU/Zi9ZOv/Fra2dbdRQSIRCL+DLRP4lrjPe1dkhMd8vBIZJF7+BrBOdoskf6mJVBs9ZM2ndC0=
X-Received: by 2002:a05:6102:512b:b0:5d7:bc22:f9af with SMTP id
 ada2fe7eead31-5d7dd6a5227mr4503063137.25.1761073682915; Tue, 21 Oct 2025
 12:08:02 -0700 (PDT)
MIME-Version: 1.0
References: <20251016033452.125479-1-ziy@nvidia.com> <20251016033452.125479-3-ziy@nvidia.com>
 <CAHbLzkoOZm0PXxE9qwtF4gKR=cpRXrSrJ9V9Pm2DJexs985q4g@mail.gmail.com>
 <5EE26793-2CD4-4776-B13C-AA5984D53C04@nvidia.com> <CAHbLzkp8ob1_pxczeQnwinSL=DS=kByyL+yuTRFuQ0O=Eio0oA@mail.gmail.com>
 <A4D35134-A031-4B15-B7A0-1592B3AE6D78@nvidia.com> <b353587b-ef50-41ab-8dd2-93330098053e@redhat.com>
 <893332F4-7FE8-4027-8FCC-0972C208E928@nvidia.com> <595b41b0-428a-4184-9abc-6875309d8cbd@redhat.com>
 <6ACA0358-4C83-430A-892C-F0A6CC1DC8EA@nvidia.com>
In-Reply-To: <6ACA0358-4C83-430A-892C-F0A6CC1DC8EA@nvidia.com>
From: Yang Shi <shy828301@gmail.com>
Date: Tue, 21 Oct 2025 12:07:49 -0700
X-Gm-Features: AS18NWBQm40401R-3eSStXerP5YpXnZxigPk8j1z8V14Yb_RrXNCxRz1tuxoYTs
Message-ID: <CAHbLzkqDt0FfNaG7-rxqz4y=3Wu8yiL38FQiH6hVEsAfRBRvuw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mm/memory-failure: improve large block size folio handling.
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>, linmiaohe@huawei.com, jane.chu@oracle.com, 
	kernel@pankajraghav.com, 
	syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com, akpm@linux-foundation.org, mcgrof@kernel.org, 
	nao.horiguchi@gmail.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Wei Yang <richard.weiyang@gmail.com>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: tewkhyubsn6yoisco1z7dgtgzxtg9xfw
X-Rspamd-Queue-Id: 17D59120014
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761073683-312971
X-HE-Meta: U2FsdGVkX18FdmJvTQbBc/NirkmprpPv4wxo+y8/ADOPPpQ92RpUXG7ijax7TYMIM3HYQNJCqbV3T08SRCcKpiaaRdhzlLkSbPQ898UwVLCR/ZZTWEu9nQobk+c4fFg7RbnmKB+nM3pBt6XodgyRAX5cZJBV/ydYWnWo7HmL5oDzaz+WhxRyB59YUNyv0+BQghAcXh2moYB+vg+NRbacw9jE+NT70DY91WyNAEGM/SDh+5A9LeT9S+WqEJWeoQ1v3Ky+e/fHjGglnkZBo9Z5tJ+2KRHap4vSrQb/WK2/fftkCKPv0HjFZwBgLYFvnsx/g1AbVfg4AcYi6J+VJH5tbsICYUnwokdfBx+1kxjoNVqJrVnyoyT/qGWGCY1vWtFxqnuZJx1T4xsKYFytMZY+l192QrLy2vsvlwtSHREermAq9iLc5cvL6Hhmci+eXSyAlocAnBmS6p7BPt4NhxODfIChizBTcLOn+/9R4s47WVmBIvdIvHsiFIHtr/b/ywrIR0Da9TOyvlyH1bbraFGvnvFpCHhA5WjSrbxs5p7/yki/ZCkr+MMMU1pV3YNid26TA3WMPon67oGHl9oDmQmJqOEhVT80fg39cxtLZsgy9vAB/8/qc4NtfuFvEYTLVXh8GOJdIVowzIhUXuh2XCA8271PaJdYJUwa/1+7SX9D3hbTfv35AuwNkd4yulQsqF/7CpSulD2BRMmNuummxrDRe0HooM4EN/3gubEvLnTCl2CuYWx+oduKOJtoxq70Egr5jNjaffjrm0JfikUDAhUY5wk5t40EiiQ83UOEmv+M3fQfDrXLuM4Dc5+XtZeimfpJ2VWjrovQmiNwB7SJquCmkwW3JrLTCJ83BI5jyaVyXToeiDAgUETjt5iBOpITAqdl4KPcbWh6pOIwcP15Bw/SAFokAn+ZKwfFVJHUkaspuw+85o2y/ifNGXvkLA5aal0RwrqHQicubxwCk77O2GQ
 ZKWaL19k
 4OCkv6RoFUBfrkSC9vRIklxa3LTIrqW+U2JBBqFmyA03EBm0+woFzY0JieCcMIplf3bjinD45YYClWfXYlUEq4VZODuYEah2x/dxsdbtxmfxkr0WG08FcYEF86C5JLi1umfR/nJ3Xph58EdkjPDTo6uqAqNy6oSdVG9MvtpLZo+/atyUIrWT2e4rSp74he1Xb7W91q6WkA16NwLH+V5z9Df79sLKl5PYwSMQeqCczcXpu3aUQpKVL8uZ68Dy6H21rSOGRlC10W3FMhE64eSiNFfqpLRpaew5KKE+GTksUb+xX7lfJ6NEGVCLMfVvNnBKc/ccucC5Iu5Z2GY8SleAkirez6ZIhpa5aiHgdAWE0EvhWJGh2yRwEZ2b4E57AqPfvr9/+v0qkflsshghthXVPjDRJDaFjSmvgBWfVU/qToPXKWlDSEph7+Ub6MDmU18wsxLxI06KMySu5vQ8QTPyE7iKwyeVEuaSsaLVd/Lw/DOter6Qh9lS3B47KGNevQsv8UFnpWd8PYHBED2MyrYvatGfTIg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 11:58=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> On 21 Oct 2025, at 14:28, David Hildenbrand wrote:
>
> > On 21.10.25 17:55, Zi Yan wrote:
> >> On 21 Oct 2025, at 11:44, David Hildenbrand wrote:
> >>
> >>> On 21.10.25 03:23, Zi Yan wrote:
> >>>> On 20 Oct 2025, at 19:41, Yang Shi wrote:
> >>>>
> >>>>> On Mon, Oct 20, 2025 at 12:46=E2=80=AFPM Zi Yan <ziy@nvidia.com> wr=
ote:
> >>>>>>
> >>>>>> On 17 Oct 2025, at 15:11, Yang Shi wrote:
> >>>>>>
> >>>>>>> On Wed, Oct 15, 2025 at 8:38=E2=80=AFPM Zi Yan <ziy@nvidia.com> w=
rote:
> >>>>>>>>
> >>>>>>>> Large block size (LBS) folios cannot be split to order-0 folios =
but
> >>>>>>>> min_order_for_folio(). Current split fails directly, but that is=
 not
> >>>>>>>> optimal. Split the folio to min_order_for_folio(), so that, afte=
r split,
> >>>>>>>> only the folio containing the poisoned page becomes unusable ins=
tead.
> >>>>>>>>
> >>>>>>>> For soft offline, do not split the large folio if it cannot be s=
plit to
> >>>>>>>> order-0. Since the folio is still accessible from userspace and =
premature
> >>>>>>>> split might lead to potential performance loss.
> >>>>>>>>
> >>>>>>>> Suggested-by: Jane Chu <jane.chu@oracle.com>
> >>>>>>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
> >>>>>>>> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> >>>>>>>> ---
> >>>>>>>>    mm/memory-failure.c | 25 +++++++++++++++++++++----
> >>>>>>>>    1 file changed, 21 insertions(+), 4 deletions(-)
> >>>>>>>>
> >>>>>>>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> >>>>>>>> index f698df156bf8..443df9581c24 100644
> >>>>>>>> --- a/mm/memory-failure.c
> >>>>>>>> +++ b/mm/memory-failure.c
> >>>>>>>> @@ -1656,12 +1656,13 @@ static int identify_page_state(unsigned =
long pfn, struct page *p,
> >>>>>>>>     * there is still more to do, hence the page refcount we took=
 earlier
> >>>>>>>>     * is still needed.
> >>>>>>>>     */
> >>>>>>>> -static int try_to_split_thp_page(struct page *page, bool releas=
e)
> >>>>>>>> +static int try_to_split_thp_page(struct page *page, unsigned in=
t new_order,
> >>>>>>>> +               bool release)
> >>>>>>>>    {
> >>>>>>>>           int ret;
> >>>>>>>>
> >>>>>>>>           lock_page(page);
> >>>>>>>> -       ret =3D split_huge_page(page);
> >>>>>>>> +       ret =3D split_huge_page_to_list_to_order(page, NULL, new=
_order);
> >>>>>>>>           unlock_page(page);
> >>>>>>>>
> >>>>>>>>           if (ret && release)
> >>>>>>>> @@ -2280,6 +2281,7 @@ int memory_failure(unsigned long pfn, int =
flags)
> >>>>>>>>           folio_unlock(folio);
> >>>>>>>>
> >>>>>>>>           if (folio_test_large(folio)) {
> >>>>>>>> +               int new_order =3D min_order_for_split(folio);
> >>>>>>>>                   /*
> >>>>>>>>                    * The flag must be set after the refcount is =
bumped
> >>>>>>>>                    * otherwise it may race with THP split.
> >>>>>>>> @@ -2294,7 +2296,14 @@ int memory_failure(unsigned long pfn, int=
 flags)
> >>>>>>>>                    * page is a valid handlable page.
> >>>>>>>>                    */
> >>>>>>>>                   folio_set_has_hwpoisoned(folio);
> >>>>>>>> -               if (try_to_split_thp_page(p, false) < 0) {
> >>>>>>>> +               /*
> >>>>>>>> +                * If the folio cannot be split to order-0, kill=
 the process,
> >>>>>>>> +                * but split the folio anyway to minimize the am=
ount of unusable
> >>>>>>>> +                * pages.
> >>>>>>>> +                */
> >>>>>>>> +               if (try_to_split_thp_page(p, new_order, false) |=
| new_order) {
> >>>>>>>
> >>>>>>> folio split will clear PG_has_hwpoisoned flag. It is ok for split=
ting
> >>>>>>> to order-0 folios because the PG_hwpoisoned flag is set on the
> >>>>>>> poisoned page. But if you split the folio to some smaller order l=
arge
> >>>>>>> folios, it seems you need to keep PG_has_hwpoisoned flag on the
> >>>>>>> poisoned folio.
> >>>>>>
> >>>>>> OK, this means all pages in a folio with folio_test_has_hwpoisoned=
() should be
> >>>>>> checked to be able to set after-split folio's flag properly. Curre=
nt folio
> >>>>>> split code does not do that. I am thinking about whether that caus=
es any
> >>>>>> issue. Probably not, because:
> >>>>>>
> >>>>>> 1. before Patch 1 is applied, large after-split folios are already=
 causing
> >>>>>> a warning in memory_failure(). That kinda masks this issue.
> >>>>>> 2. after Patch 1 is applied, no large after-split folios will appe=
ar,
> >>>>>> since the split will fail.
> >>>>>
> >>>>> I'm a little bit confused. Didn't this patch split large folio to
> >>>>> new-order-large-folio (new order is min order)? So this patch had
> >>>>> code:
> >>>>> if (try_to_split_thp_page(p, new_order, false) || new_order) {
> >>>>
> >>>> Yes, but this is Patch 2 in this series. Patch 1 is
> >>>> "mm/huge_memory: do not change split_huge_page*() target order silen=
tly."
> >>>> and sent separately as a hotfix[1].
> >>>
> >>> I'm confused now as well. I'd like to review, will there be a v3 that=
 only contains patch #2+#3?
> >>
> >> Yes. The new V3 will have 3 patches:
> >> 1. a new patch addresses Yang=E2=80=99s concern on setting has_hwpoiso=
ned on after-split
> >> large folios.
> >> 2. patch#2,
> >> 3. patch#3.
> >
> > Okay, I'll wait with the review until you resend :)
> >
> >>
> >> The plan is to send them out once patch 1 is upstreamed. Let me know i=
f you think
> >> it is OK to send them out earlier as Andrew already picked up patch 1.
> >
> > It's in mm/mm-new + mm/mm-unstable, AFAIKT. So sure, send it against on=
e of the tress (I prefer mm-unstable but usually we should target mm-new).
>
> Sure.
> >
> >>
> >> I also would like to get some feedback on my approach to setting has_h=
wpoisoned:
> >>
> >> folio's has_hwpoisoned flag needs to be preserved
> >> like what Yang described above. My current plan is to move
> >> folio_clear_has_hwpoisoned(folio) into __split_folio_to_order() and
> >> scan every page in the folio if the folio's has_hwpoisoned is set.
> >
> > Oh, that's nasty indeed ... will have to think about that a bit.
> >
> > Maybe we can keep it simple and always set folio_set_has_hwpoisoned() o=
n all split folios? Essentially turning it into a "maybe_has" semantics.
> >
> > IIUC, the existing folio_stest_has_hwpoisoned users can deal with that?
>
> folio_test_has_hwpoisoned() direct users are fine. They are shmem.c
> and memory.c, where the former would copy data in PAGE_SIZE instead of fo=
lio size
> and the latter would not install PMD entry for the folio (impossible to h=
it
> this until we have > PMD mTHPs and split them to PMD THPs).
>
> The caller of folio_contain_hwpoisoned_page(), which calls
> folio_test_has_hwpoisoned(), would have issues:
>
> 1. shmem_write_begin() in shmem.c: it returns -EIO for shmem writes.
> 2. thp_underused() in huge_memory.c: it does not scan the folio.
> 3. shrink_folio_list() in vmscan.c: it does not reclaim large hwpoisoned =
folios.
> 4. do_migrate_range() in memory_hotplug.c: it skips the large hwpoisoned =
folios.
>
> These behaviors are fine for folios truly containing hwpoisoned pages,
> but might not be desirable for false positive cases. A scan to make sure
> hwpoisoned pages are indeed present is inevitable. Rather than making
> all callers to do the scan, scanning at split time might be better, IMHO.

Yeah, I was trying to figure out a simpler way too. For example, we
can defer to set this flag to page fault time when page fault sees the
poisoned page when installing PTEs. But it can't cover most of the
cases mentioned by Zi Yan above. We may run into them before any page
fault happens.

Thanks,
Yang

>
> Let me send a patchset with scanning at split time. Hopefully, more peopl=
e
> can chime in to provide feedbacks.
>
>
> --
> Best Regards,
> Yan, Zi

