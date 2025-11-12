Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54DD7CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 01:29:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 232908E0003; Tue, 11 Nov 2025 20:29:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BBC58E0002; Tue, 11 Nov 2025 20:29:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00DD98E0003; Tue, 11 Nov 2025 20:29:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D71F78E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 20:29:08 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 78DFDC029B
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 01:29:08 +0000 (UTC)
X-FDA: 84100221576.17.9E68765
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf19.hostedemail.com (Postfix) with ESMTP id 622001A0004
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 01:29:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DGoKcKkm;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762910946; a=rsa-sha256;
	cv=none;
	b=jjUJXxj/ZNccyGb0H5yvuhro3ibU2OraCZVB2+mcBijOxFUPUexxcB+kcG/3J5xCNJAmLS
	hAh+sPx73DTLe9NT3FRV0wIniAM2k1GOOJlxkW9zQrlOCOW8Ah08GbZWL9yZ7alKDUs9Tr
	5maOt9EhIv0KUNIMLEMVRUf3Pk8OVI4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DGoKcKkm;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762910946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=owZnNTvalHie3X3MWIReu1pb9Hpq5jejlIW0+p14dW4=;
	b=PVtX99YhiBoWfH/xOR3tXrJmMgziSSl96L3c05BXg9HiOpnGYI+hIE+xG06+Dw9Hdl1qiM
	gSJZtqjZ+5FqnUjDFvxn0LlYnAjlANc5x2dVtWkjmg/qUA1i35z/nfq63XQTXS11koo1mU
	EYFyD8yxEITUWz/qBsR/knyvvxrC3dc=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-47777136777so24585e9.1
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 17:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762910945; x=1763515745; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=owZnNTvalHie3X3MWIReu1pb9Hpq5jejlIW0+p14dW4=;
        b=DGoKcKkmYwUsPDX3xLnEDwt3vksnP7xm/XMuE7VTAPP898vXKyoWS6kcYW8tIO8cqY
         ODw9wznaSOzQeREzWC/wGUN3hPSrGZ9OvyRSw5xDSpskkxaAMG7lMf11S3dnxMUB8k3g
         gHpa3ELk7KjSyUXqS0HiN5E+1+Zno5hN4d6aAa65Dzo0t8P1/ROx7cm5udQBTCv7YfB+
         rSCwQ0jBS5UMX5z9xGUnVjz2yYnxjOP0uPQYVsj4RA5HO7l9G/brmoQVLFXrM7KsMBVn
         QEHqbhAQ11ctWPQ1tX/FAjMT5o2dEgD+htgm+SGEghUimfaotlc5MHbVS5BYYUlafB07
         fzPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762910945; x=1763515745;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=owZnNTvalHie3X3MWIReu1pb9Hpq5jejlIW0+p14dW4=;
        b=VXlIrg+NZndClbtJgYGs3+lVUOF9tfRy34rc4TSCm90idVIIg2gdWHviEGKvH19ALY
         OuAC1V9lP8K4O4EUwrK56OERIizdcd5v1HywzBHyhbKDklWNEaZrdLopBCJxfbisYOt4
         VeFjc9yQdfMLE5ZoFmMci4sW2VbWmb47yZFphE7HASoEQDdsKbewRqQuTcbqYCkAkbMD
         Vqak4VonmWaAfrjPj++RaM+hIuuD773KRoOb4PE1XBJ5XF5ZrkLxA6/FIG8AAvf9E3wo
         Q5Z0+Ebj8FsMeX0/XCs8zmilguEAWU6WTJGozgRd9CTajhdzHVFBehOS0ptmhC+UvinX
         09fQ==
X-Forwarded-Encrypted: i=1; AJvYcCXMoy9Q3MQf1U3o7/Oap5Dl1ZHjLqt8CjTXkz+zI/t9NN/IP5OTy9YHQ/M9jICbVyHyJA32aJKxJA==@kvack.org
X-Gm-Message-State: AOJu0YzBu54PEN8U4terwGVXOn7tt/+hHQ69R9EX4UsN+eVJuAwsLaws
	1ZRRpKZTWhc3664uFGFnFiUyY5JUsc7OY6ereBo8YgOczZz3jZz84DbqgjFQd+u2cS5xCmoHvN5
	ZRy29cd4PoCoyD7vLaV+Twv2KP83SdeXbiCm1icoO
X-Gm-Gg: ASbGncs//k7V1lwn74av6mJEofp/RtDl9xkPqjbj1X1cj8KzC1QqNotCNf5eLFcb0Fs
	1o1pN/bT3K1y9LvHS2l9ZKTzhjVgQWyLuS7AVQS+CTziEkwI0nKMmOMUeLv2IrK+umitaYeN4Pw
	iAdBLVu/OXaJp19xT5TqrlBVtXShrW7qc/1Y8H1fzqnIB4Xn1f68GWY6WiH9cSLZsMwcwMThT7M
	kNNRz5Ecz7iZxQG1oUHaTw/XFOaVHzzWw0eV78rUUDe3TNL1cC92wN+Vsep+csNQTQaIUwxV0lI
	CZdTaIm4UrwDcRgeJMaPAfdm2qdR08LQRHKn
X-Google-Smtp-Source: AGHT+IGL2v0R/DB2BbwNwRSpcSF4R0O2YrzUanoHsSJXw2R9hxcbLlm93iZS/VxCmjUZbKgpZIS1gj3Tl7G719NoJMY=
X-Received: by 2002:a05:600c:4f50:b0:477:73f4:26b with SMTP id
 5b1f17b1804b1-47787e10f86mr467035e9.3.1762910944363; Tue, 11 Nov 2025
 17:29:04 -0800 (PST)
MIME-Version: 1.0
References: <20250919155832.1084091-1-william.roche@oracle.com>
 <CACw3F521fi5HWhCKi_KrkNLXkw668HO4h8+DjkP2+vBuK-=org@mail.gmail.com>
 <aPjXdP63T1yYtvkq@hyeyoo> <CACw3F50As2jPzy1rRjzpm3uKOALjX_9WmKxMPGnQcok96OfQkA@mail.gmail.com>
 <aQBqGupCN_v8ysMX@hyeyoo> <d3d35586-c63f-c1be-c95e-fbd7aafd43f3@huawei.com>
 <CACw3F51qaug5aWFNcjB54dVEc8yH+_A7zrkGcQyKXKJs6uVvgA@mail.gmail.com>
 <aQhk4WtDSaQmFFFo@harry> <aQhti7Dt_34Yx2jO@harry> <CACw3F503FG01yQyA53hHAo7q0yE3qQtMuT9kOjNHpp8Q9qHKPQ@mail.gmail.com>
 <aQxSSjyPsI0MT8mp@harry>
In-Reply-To: <aQxSSjyPsI0MT8mp@harry>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Tue, 11 Nov 2025 17:28:52 -0800
X-Gm-Features: AWmQ_bnLyiOlms588iE7RxqqFJJc1I_V2hzoeqXEHn5hpQKGL1FRmzkW8zKex6I
Message-ID: <CACw3F51VGxg4q9nM_eQN7OXs7JaZo9K-nvDwxtZgtjFSNyjQaw@mail.gmail.com>
Subject: Re: [RFC PATCH v1 0/3] Userspace MFR Policy via memfd
To: Harry Yoo <harry.yoo@oracle.com>, =?UTF-8?Q?=E2=80=9CWilliam_Roche?= <william.roche@oracle.com>, 
	Miaohe Lin <linmiaohe@huawei.com>
Cc: Ackerley Tng <ackerleytng@google.com>, jgg@nvidia.com, akpm@linux-foundation.org, 
	ankita@nvidia.com, dave.hansen@linux.intel.com, david@redhat.com, 
	duenwen@google.com, jane.chu@oracle.com, jthoughton@google.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, muchun.song@linux.dev, nao.horiguchi@gmail.com, 
	osalvador@suse.de, peterx@redhat.com, rientjes@google.com, 
	sidhartha.kumar@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	willy@infradead.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 622001A0004
X-Stat-Signature: qyyqq9ost93ty86wd5bczga339asxung
X-HE-Tag: 1762910946-917969
X-HE-Meta: U2FsdGVkX19dZMFtmwwQnX9uelIjUQiViNHocna73PsKZQ2vX+lyfXjY0IEvkuXbhC63f6wUikpsKPFkHxjCPnyZolGVR/RZsOOrP6K6yimgXdUSqv3Ggc6caECLDZLSOR1QpTcvQYoyIRiA9lSOZVxMqHNDoTCeOVJ6RYE4lLbJc9hgktiF58RSyd2EO1rif4ltfSiXISziyAjuREZxxMF1EsD0X1TeK6a5ddmJH7omwHG+qlJISoEf6KcZ+PH6U4zwo/1/bKTS+LRytLmZBgWQ4Jb+7UHCyM0bDkwXRnmeiY5xOVj98mtmNO8oaWO9l8sr1HF8YUE4lct4f3HMBhl83C/JZlcGvlnCYBM8EzB9HDjvqr5Mbzz2JYBA258o/ulLpAKxz8nHTyvyJFB8ELqiNwCkoVCvqAVCmkVdZ16DtftvPKcNnTs29e/4QRY81JKPS3OSkN5UYMeStW24gC92HVF1bke7jxEL6nWbjZHAgaU3/3hfnwic+vQTYqQP3DGjjB0TIaBpYUdy9e1hFkqKvnblz7t21Y/QOLSDxNEmVNkLBHrS3V4YTOvRPxyIFadliw2LDfcYISvHx8GL5Yh2q/okZgkb1oAykeQaoewf6/emoPpD9BMwtGBVVH/X+FSXGx0VCqFdt1KgO1GKsB/3aG762K7WY+uqJQiqerRG0VVOnXBhMHkhda1bz5TrEyK51oElYCcxqQQjjUvdnt4inj+DojjL4wAkW+96VFhossYSwuKCENnVK1EVXPVHGqf4epXQquaSdsMQXa/4X9h2XBXK6Kap7skThsjUDwBcSCBWgPs72oQzg53B1gLTG1htWDQTD2kf5s/uXw1KUlZkDYz5Bw55z7jNH8kLzudfVS4lgdHzGAlcbHsGdCqLJNSE62k5I54Gml8wkA0CtfvF3FF1jmxWF/fMN6Pq2LrUxWaxqrX7kOoTt3de3blXwXcOSZ4fwG0k1Fvh4aC
 O5qz29W5
 QGl/uDRtVI0HVxh+nEXeQFuZ1sqvj7b7nZzTum9B2iZmw7HwSqhIfDATTtu4peSmy+BHkIMCZq1vQqEF69VUxzd/45u1rZENkVXUlZK0eTo75AeXa93++UWsZiqmSQU5vJ4auH1k2tEcbFuYG+HtcjG7hAxii6SjmOA31wLQ/rVq2IrKZT72I8HrcCgiceXVTPjMTXqHcAAkKJGP8AQ9kMo55kB133JQOo684YChdKTZAOEvs15pTUueMZglIzMUrSjrBlletJOZAzYrZQSd6l2S0zqTU94Ja+Lsj2g42xvBTQi7WZtg0FAtJVz9HRzpq6ziSRJXnsxa9fTSIVVJVKS5YnNGrylpGW2Fml9e+mLYzYQRqq50BD0UBfo/0qMG2Zcf4REHX0HwmT9nWCxm9ElNRKJJe2qSOjxeD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 5, 2025 at 11:54=E2=80=AFPM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> On Mon, Nov 03, 2025 at 08:57:08AM -0800, Jiaqi Yan wrote:
> > On Mon, Nov 3, 2025 at 12:53=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com=
> wrote:
> > >
> > > On Mon, Nov 03, 2025 at 05:16:33PM +0900, Harry Yoo wrote:
> > > > On Thu, Oct 30, 2025 at 10:28:48AM -0700, Jiaqi Yan wrote:
> > > > > On Thu, Oct 30, 2025 at 4:51=E2=80=AFAM Miaohe Lin <linmiaohe@hua=
wei.com> wrote:
> > > > > > On 2025/10/28 15:00, Harry Yoo wrote:
> > > > > > > On Mon, Oct 27, 2025 at 09:17:31PM -0700, Jiaqi Yan wrote:
> > > > > > >> On Wed, Oct 22, 2025 at 6:09=E2=80=AFAM Harry Yoo <harry.yoo=
@oracle.com> wrote:
> > > > > > >>> On Mon, Oct 13, 2025 at 03:14:32PM -0700, Jiaqi Yan wrote:
> > > > > > >>>> On Fri, Sep 19, 2025 at 8:58=E2=80=AFAM =E2=80=9CWilliam R=
oche <william.roche@oracle.com> wrote:
> > > > > > >>> But even after fixing that we need to fix the race conditio=
n.
> > > > > > >>
> > > > > > >> What exactly is the race condition you are referring to?
> > > > > > >
> > > > > > > When you free a high-order page, the buddy allocator doesn't =
not check
> > > > > > > PageHWPoison() on the page and its subpages. It checks PageHW=
Poison()
> > > > > > > only when you free a base (order-0) page, see free_pages_prep=
are().
> > > > > >
> > > > > > I think we might could check PageHWPoison() for subpages as wha=
t free_page_is_bad()
> > > > > > does. If any subpage has HWPoisoned flag set, simply drop the f=
olio. Even we could
> > > > >
> > > > > Agree, I think as a starter I could try to, for example, let
> > > > > free_pages_prepare scan HWPoison-ed subpages if the base page is =
high
> > > > > order. In the optimal case, HugeTLB does move PageHWPoison flag f=
rom
> > > > > head page to the raw error pages.
> > > >
> > > > [+Cc page allocator folks]
> > > >
> > > > AFAICT enabling page sanity check in page alloc/free path would be =
against
> > > > past efforts to reduce sanity check overhead.
> > > >
> > > > [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-em=
ail-mgorman@techsingularity.net/
> > > > [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-em=
ail-mgorman@techsingularity.net/
> > > > [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.=
cz
> > > >
> > > > I'd recommend to check hwpoison flag before freeing it to the buddy
> > > > when we know a memory error has occurred (I guess that's also what =
Miaohe
> > > > suggested).
> > > >
> > > > > > do it better -- Split the folio and let healthy subpages join t=
he buddy while reject
> > > > > > the hwpoisoned one.
> > > > > >
> > > > > > >
> > > > > > > AFAICT there is nothing that prevents the poisoned page to be
> > > > > > > allocated back to users because the buddy doesn't check PageH=
WPoison()
> > > > > > > on allocation as well (by default).
> > > > > > >
> > > > > > > So rather than freeing the high-order page as-is in
> > > > > > > dissolve_free_hugetlb_folio(), I think we have to split it to=
 base pages
> > > > > > > and then free them one by one.
> > > > > >
> > > > > > It might not be worth to do that as this would significantly in=
crease the overhead
> > > > > > of the function while memory failure event is really rare.
> > > > >
> > > > > IIUC, Harry's idea is to do the split in dissolve_free_hugetlb_fo=
lio
> > > > > only if folio is HWPoison-ed, similar to what Miaohe suggested
> > > > > earlier.
> > > >
> > > > Yes, and if we do the check before moving HWPoison flag to raw page=
s,
> > > > it'll be just a single folio_test_hwpoison() call.
> > > >
> > > > > BTW, I believe this race condition already exists today when
> > > > > memory_failure handles HWPoison-ed free hugetlb page; it is not
> > > > > something introduced via this patchset. I will fix or improve thi=
s in
> > > > > a separate patchset.
> > > >
> > > > That makes sense.
> > >
> > > Wait, without this patchset, do we even free the hugetlb folio when
> > > its subpage is hwpoisoned? I don't think we do, but I'm not expert at=
 MFR...
> >
> > Based on my reading of try_memory_failure_hugetlb, me_huge_page, and
> > __page_handle_poison, I think mainline kernel frees dissolved hugetlb
> > folio to buddy allocator in two cases:
> > 1. it was a free hugetlb page at the moment of try_memory_failure_huget=
lb
>
> Right.
>
> > 2. it was an anonomous hugetlb page
>
> Right.
>
> Thanks. I think you're right that poisoned hugetlb folios can be freed
> to the buddy even without this series (and poisoned pages allocated back =
to
> users instead of being isolated due to missing PageHWPoison() checks on
> alloc/free).

Fortunately today at maximum only 1 raw HWPoison-ed page, with the
high-order folio containing it, will get free to buddy allocator.

But with my memfd MFR series, raw HWPoison-ed pages can accumulate
while userspace still holds the hugetlb folio. So I would like a
solution to this.

>
> So the plan is to post RFC v2 of this series and the race condition fix
> as a separate series, right? (that sounds good to me!)

Yes, I am preparing RFC v2 in the meanwhile.

>
> I still think it'd be best to split the hugetlb folio to order-0 pages an=
d
> free them when we know the hugetlb folio is poisoned because:
>
> - We don't have to implement a special version of __free_pages() that
>   knows how to handle freeing of a high-order page where its one or more
>   sub-pages are poisoned.
>
> - We can avoid re-enabling page sanity checks (and introducing overhead)
>   all the time.

Agreed, after I tried a couple of alternative and unsuccessful
approaches, now I have a working prototype that works exactly the same
way as Harry suggested.

My code roughly work like this (if you can't tolerate the prototype
code attached at the end):

__update_and_free_hugetlb_folio()
   hugetlb_free_hwpoison_folio() (new code, instead of hugetlb_free_folio)
        folios =3D __split_unmapped_folio()
        for folio in folios
            free_frozen_pages if not HWPoison-ed

It took me some time to test my implementation with some test-only
code to check pcplist and freelist (i.e. check_zone_free_list and
page_count_in_pcplist), but I have validated with several tests that,
after freeing high-order folio containing multiple HWPoison-ed pages,
only healthy pages go to buddy allocator or per-cpu-pages lists:
1. some pages are still zone->per_cpu_pageset because pcp-count is not
high enough
2. all the others are, after merging, in some order's
zone->free_area[order].free_list

For example:
- when hugepagesize=3D2M, 512 - x 0-order pages (x=3Dnumber of HWPoison-ed
ones) are all placed in pcp list.
- when hugepagesize=3D1G, most pages are merged to buddy blocks of order
0 to 10, and some left over in pcp list.

I am in the middle of refining my working prototype (attached below),
and then send it out as separate patch.

Code below is just for illustrating my idea to see if it is correct in
general, not asking for code review :).

commit d54cc323608d383ee0136ca95932b535fed55def
Author: Jiaqi Yan <jiaqiyan@google.com>
Date:   Mon Nov 10 19:46:21 2025 +0000

    mm: memory_failure: avoid free HWPoison pages when dissolve free
hugetlb folio

    1. expose __split_unmapped_folio
    2. introduce hugetlb_free_hwpoison_folio
    3. simplify filemap_offline_hwpoison_folio_hugetlb
    4. introduce page_count_in_pcplist and check_zone_free_list for testing

    Tested with page_count_in_pcplist and check_zone_free_list.

    Change-Id: I7af5fc40851e3a26eaa37bb3191d319437202bc1

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index f327d62fc9852..5619d8931c4bf 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -367,6 +367,9 @@ unsigned long thp_get_unmapped_area_vmflags(struct
file *filp, unsigned long add
 bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pin=
s);
 int split_huge_page_to_list_to_order(struct page *page, struct list_head *=
list,
                unsigned int new_order);
+int __split_unmapped_folio(struct folio *folio, int new_order,
+                          struct page *split_at, struct xa_state *xas,
+                          struct address_space *mapping, bool uniform_spli=
t);
 int min_order_for_split(struct folio *folio);
 int split_folio_to_list(struct folio *folio, struct list_head *list);
 bool uniform_split_supported(struct folio *folio, unsigned int new_order,
@@ -591,6 +594,14 @@ split_huge_page_to_list_to_order(struct page
*page, struct list_head *list,
        VM_WARN_ON_ONCE_PAGE(1, page);
        return -EINVAL;
 }
+static inline int __split_unmapped_folio(struct folio *folio, int new_orde=
r,
+                                        struct page *split_at, struct
xa_state *xas,
+                                        struct address_space *mapping,
+                                        bool uniform_split)
+{
+       VM_WARN_ON_ONCE_FOLIO(1, folio);
+       return -EINVAL;
+}
 static inline int split_huge_page(struct page *page)
 {
        VM_WARN_ON_ONCE_PAGE(1, page);
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index b7733ef5ee917..fad53772c875c 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -873,6 +873,7 @@ int dissolve_free_hugetlb_folios(unsigned long start_pf=
n,
 extern void folio_clear_hugetlb_hwpoison(struct folio *folio);
 extern bool hugetlb_should_keep_hwpoison_mapped(struct folio *folio,
                                                struct address_space *mappi=
ng);
+extern void hugetlb_free_hwpoison_folio(struct folio *folio);
 #else
 static inline void folio_clear_hugetlb_hwpoison(struct folio *folio)
 {
@@ -882,6 +883,9 @@ static inline bool
hugetlb_should_keep_hwpoison_mapped(struct folio *folio
 {
        return false;
 }
+static inline void hugetlb_free_hwpoison_folio(struct folio *folio)
+{
+}
 #endif

 #ifdef CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1b81680b4225f..6ca70ec2fb7cd 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3408,9 +3408,9 @@ static void __split_folio_to_order(struct folio
*folio, int old_order,
  * For !uniform_split, when -ENOMEM is returned, the original folio might =
be
  * split. The caller needs to check the input folio.
  */
-static int __split_unmapped_folio(struct folio *folio, int new_order,
-               struct page *split_at, struct xa_state *xas,
-               struct address_space *mapping, bool uniform_split)
+int __split_unmapped_folio(struct folio *folio, int new_order,
+                          struct page *split_at, struct xa_state *xas,
+                          struct address_space *mapping, bool uniform_spli=
t)
 {
        int order =3D folio_order(folio);
        int start_order =3D uniform_split ? new_order : order - 1;
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d499574aafe52..7e408d6ce91d7 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1596,6 +1596,7 @@ static void
__update_and_free_hugetlb_folio(struct hstate *h,
                                                struct folio *folio)
 {
        bool clear_flag =3D folio_test_hugetlb_vmemmap_optimized(folio);
+       bool has_hwpoison =3D folio_test_hwpoison(folio);

        if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
                return;
@@ -1638,12 +1639,15 @@ static void
__update_and_free_hugetlb_folio(struct hstate *h,
         * Move PageHWPoison flag from head page to the raw error pages,
         * which makes any healthy subpages reusable.
         */
-       if (unlikely(folio_test_hwpoison(folio)))
+       if (unlikely(has_hwpoison))
                folio_clear_hugetlb_hwpoison(folio);

        folio_ref_unfreeze(folio, 1);

-       hugetlb_free_folio(folio);
+       if (has_hwpoison)
+               hugetlb_free_hwpoison_folio(folio);
+       else
+               hugetlb_free_folio(folio);
 }

 /*
diff --git a/mm/internal.h b/mm/internal.h
index 1561fc2ff5b83..6ee56aea01a91 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -829,6 +829,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t,
unsigned int order, int nid,
 #define __alloc_frozen_pages(...) \
        alloc_hooks(__alloc_frozen_pages_noprof(__VA_ARGS__))
 void free_frozen_pages(struct page *page, unsigned int order);
+int page_count_in_pcplist(struct zone *zone);
 void free_unref_folios(struct folio_batch *fbatch);

 #ifdef CONFIG_NUMA
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index fa281461f38a6..7dd82c787cea7 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2044,13 +2044,134 @@ int __get_huge_page_for_hwpoison(unsigned
long pfn, int flags,
        return ret;
 }

+static int calculate_overlap(int s1, int e1, int s2, int e2) {
+       /* Calculate the start and end of the potential overlap. */
+       unsigned long overlap_start =3D max(s1, s2);
+       unsigned long overlap_end =3D min(e1, e2);
+
+       if (overlap_start <=3D overlap_end)
+               return (overlap_end - overlap_start + 1);
+       else
+               return 0UL;
+}
+
+static void check_zone_free_list(struct zone *zone,
+                                enum migratetype migrate_type,
+                                unsigned long target_start_pfn,
+                                unsigned long target_end_pfn)
+{
+       int order;
+       struct list_head *list;
+       struct page *page;
+       unsigned long pages_in_block;
+       unsigned long nr_free;
+       unsigned long start_pfn, end_pfn;
+       unsigned long flags;
+       unsigned long nr_pages =3D target_end_pfn - target_start_pfn + 1;
+       unsigned long overlap;
+
+       pr_info("%s:%d: search 0~%d order free areas\n", __func__,
__LINE__, NR_PAGE_ORDERS);
+
+       spin_lock_irqsave(&zone->lock, flags);
+       for (order =3D 0; order < NR_PAGE_ORDERS; ++order) {
+               pages_in_block =3D 1UL << order;
+               nr_free =3D zone->free_area[order].nr_free;
+
+               if (nr_free =3D=3D 0) {
+                       pr_info("%s:%d: empty free area for order=3D%d\n",
+                               __func__, __LINE__, order);
+                       continue;
+               }
+
+               pr_info("%s:%d: free area order=3D%d, nr_free=3D%lu blocks
in total\n",
+                       __func__, __LINE__, order, nr_free);
+               list =3D &zone->free_area[order].free_list[migrate_type];
+               list_for_each_entry(page, list, buddy_list) {
+                       start_pfn =3D page_to_pfn(page);
+                       end_pfn =3D start_pfn + pages_in_block - 1;
+                       overlap =3D calculate_overlap(target_start_pfn,
+                                                   target_end_pfn,
+                                                   start_pfn,
+                                                   end_pfn);
+                       nr_pages -=3D overlap;
+                       if (overlap > 0)
+                               pr_warn("%s:%d: found [%#lx, %#lx]
overlap %lu pages with [%#lx, %#lx]\n",
+                                       __func__, __LINE__,
+                                       target_start_pfn, target_end_pfn,
+                                       overlap, start_pfn, end_pfn);
+               }
+       }
+       spin_unlock_irqrestore(&zone->lock, flags);
+       pr_err("%s:%d: %lu pages not found in free list\n", __func__,
__LINE__, nr_pages);
+}
+
+void hugetlb_free_hwpoison_folio(struct folio *folio)
+{
+       struct folio *curr, *next;
+       struct folio *end_folio =3D folio_next(folio);
+       int ret;
+       unsigned long start_pfn =3D folio_pfn(folio);
+       unsigned long end_pfn =3D start_pfn + folio_nr_pages(folio) - 1;
+       struct zone *zone =3D folio_zone(folio);
+       int migrate_type =3D folio_migratetype(folio);
+       int pcp_count_init, pcp_count;
+
+       pr_info("%s:%d: folio start_pfn=3D%#lx, end_pfn=3D%#lx\n",
__func__, __LINE__, start_pfn, end_pfn);
+       /* Expect folio's refcount=3D=3D1. */
+       drain_all_pages(folio_zone(folio));
+
+       pcp_count_init =3D page_count_in_pcplist(zone);
+
+       pr_warn("%#lx: %s:%d: split-to-zero folio: order=3D%d,
refcount=3D%d, nid=3D%d, zone=3D%d, migratetype=3D%d\n",
+               folio_pfn(folio), __func__, __LINE__,
folio_order(folio), folio_ref_count(folio),
+               folio_nid(folio), folio_zonenum(folio),
folio_migratetype(folio));
+
+       ret =3D __split_unmapped_folio(folio, /*new_order=3D*/0,
+                                    /*split_at=3D*/&folio->page,
+                                    /*xas=3D*/NULL, /*mapping=3D*/NULL,
+                                    /*uniform_split=3D*/true);
+       if (ret) {
+               pr_err("%#lx: failed to split free %d-order folio with
HWPoison-ed page(s): %d\n",
+                       folio_pfn(folio), folio_order(folio), ret);
+               return;
+       }
+
+       /* Expect 1st folio's refcount=3D=3D1, and other's refcount=3D=3D0.=
 */
+       for (curr =3D folio; curr !=3D end_folio; curr =3D next) {
+               next =3D folio_next(curr);
+
+               VM_WARN_ON_FOLIO(folio_order(curr), curr);
+
+               if (PageHWPoison(&curr->page)) {
+                       if (curr !=3D folio)
+                               folio_ref_inc(curr);
+
+                       VM_WARN_ON_FOLIO(folio_ref_count(curr) !=3D 1, curr=
);
+                       pr_warn("%#lx: prevented freeing HWPoison
page\n", folio_pfn(curr));
+                       continue;
+               }
+
+               if (curr =3D=3D folio)
+                       folio_ref_dec(curr);
+
+               VM_WARN_ON_FOLIO(folio_ref_count(curr), curr);
+               free_frozen_pages(&curr->page, folio_order(curr));
+       }
+
+       pcp_count =3D page_count_in_pcplist(zone);
+       pr_err("%s:%d: delta pcp_count: %d - %d =3D %d\n",
+              __func__, __LINE__, pcp_count, pcp_count_init,
+              pcp_count - pcp_count_init);
+
+       check_zone_free_list(zone, migrate_type, start_pfn, end_pfn);
+}
+
 static void filemap_offline_hwpoison_folio_hugetlb(struct folio *folio)
 {
        int ret;
        struct llist_node *head;
        struct raw_hwp_page *curr, *next;
        struct page *page;
-       unsigned long pfn;

        /*
         * Since folio is still in the folio_batch, drop the refcount
@@ -2063,38 +2184,20 @@ static void
filemap_offline_hwpoison_folio_hugetlb(struct folio *folio)
         * Release references hold by try_memory_failure_hugetlb, one per
         * HWPoison-ed page in the raw hwp list.
         */
-       llist_for_each_entry(curr, head, node)
-               folio_put(folio);
-
-       /* Refcount now should be zero and ready to dissolve folio. */
-       ret =3D dissolve_free_hugetlb_folio(folio);
-       if (ret) {
-               pr_err("failed to dissolve hugetlb folio: %d\n", ret);
-               llist_for_each_entry(curr, head, node) {
-                       page =3D curr->page;
-                       pfn =3D page_to_pfn(page);
-                       /*
-                        * Maybe we also need to roll back the count
-                        * incremented during inline handling, depending
-                        * on what me_huge_page returned.
-                        */
-                       update_per_node_mf_stats(pfn, MF_FAILED);
-               }
-               return;
-       }
-
        llist_for_each_entry_safe(curr, next, head, node) {
+               folio_put(folio);
                page =3D curr->page;
-               pfn =3D page_to_pfn(page);
-               drain_all_pages(page_zone(page));
-               if (!take_page_off_buddy(page))
-                       pr_warn("%#lx: unable to take off buddy
allocator\n", pfn);
-
                SetPageHWPoison(page);
-               page_ref_inc(page);
+               pr_info("%#lx: %s:%d moved HWPoison flag\n",
page_to_pfn(page), __func__, __LINE__);
                kfree(curr);
-               pr_info("%#lx: pending hard offline completed\n", pfn);
        }
+
+       pr_info("%#lx: %s:%d before dissolve refcount=3D%d\n",
+               page_to_pfn(&folio->page), __func__, __LINE__,
folio_ref_count(folio));
+       /* Refcount now should be zero and ready to dissolve folio. */
+       ret =3D dissolve_free_hugetlb_folio(folio);
+       if (ret)
+               pr_err("failed to dissolve HWPoison-ed hugetlb folio:
%d\n", ret);
 }

 void filemap_offline_hwpoison_folio(struct address_space *mapping,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 600d9e981c23d..0b3507a1880ec 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1333,6 +1333,7 @@ __always_inline bool free_pages_prepare(struct page *=
page,
        }

        if (unlikely(PageHWPoison(page)) && !order) {
+               VM_BUG_ON_PAGE(1, page);
                /* Do not let hwpoison pages hit pcplists/buddy */
                reset_page_owner(page, order);
                page_table_check_free(page, order);
@@ -2939,6 +2940,24 @@ static void __free_frozen_pages(struct page
*page, unsigned int order,
        pcp_trylock_finish(UP_flags);
 }

+int page_count_in_pcplist(struct zone *zone)
+{
+       unsigned long __maybe_unused UP_flags;
+       struct per_cpu_pages *pcp;
+       int page_count =3D 0;
+
+       pcp_trylock_prepare(UP_flags);
+       pcp =3D pcp_spin_trylock(zone->per_cpu_pageset);
+       if (pcp) {
+               page_count =3D pcp->count;
+               pcp_spin_unlock(pcp);
+       }
+       pcp_trylock_finish(UP_flags);
+
+       pr_info("%s:%d: #pages in pcp list=3D%d\n", __func__, __LINE__,
page_count);
+       return page_count;
+}
+
 void free_frozen_pages(struct page *page, unsigned int order)
 {
        __free_frozen_pages(page, order, FPI_NONE);


>
> --
> Cheers,
> Harry / Hyeonggon

