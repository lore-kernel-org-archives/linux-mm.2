Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A079CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 16:57:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5C8B8E009E; Mon,  3 Nov 2025 11:57:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B33948E0057; Mon,  3 Nov 2025 11:57:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A492E8E009E; Mon,  3 Nov 2025 11:57:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 901698E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 11:57:24 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 35EFC138E6D
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:57:24 +0000 (UTC)
X-FDA: 84069901608.19.E91C168
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf06.hostedemail.com (Postfix) with ESMTP id 47A4518001C
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:57:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UcM40CqZ;
	spf=pass (imf06.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762189042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gXSUHmcaUphZGHWjr/dbElnyU/fHkGguUYmUjOgo1eQ=;
	b=T27cFlCdpGFuie7hlFcyhkdEDmzd5RaqZ8X4Pxz3Fd+oVl8mbDzdtmZ8Z9eJpi1Ao4SKrr
	wBQ2ktNIGXxve2vjBY+f0yaCS18yxBVcwaaQfgBD72x30rwhxN5lgWbHFi5vLfP04raLht
	QVCcqLlrasko/jo57VaQYZRZwC5GUzQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UcM40CqZ;
	spf=pass (imf06.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762189042; a=rsa-sha256;
	cv=none;
	b=xiT9CThViW9pDqwNqWy/iXVGyZWy5uHVeo6GyKopUbJvDAB3UzgywOPcVuStkuRZfFEN2c
	bIHsk5398RPRsH/QgDYmf0SITaXfdboBGT0W7N7ZPurEcEjisghwZBd91yJpnkkDdxgZak
	qu6s8j/z2b4cFXJSuw41OcTrmYfMtvc=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-475df55f484so112685e9.0
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 08:57:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762189040; x=1762793840; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gXSUHmcaUphZGHWjr/dbElnyU/fHkGguUYmUjOgo1eQ=;
        b=UcM40CqZXB40CxvFPWxyZMdttDXOgGXefmoLCY53zqT7f5pfnvJoHsrBYKpIAK2ogn
         ZyRfoTgd3Fgc+2dAYOn6RA8Wb1yYPO2FsMtQxHMmRtp4I5VMSbF9DaKHFAACGkJjd5ob
         DpwK/LLNOtW3G3xRKueF9ES6wtGsnUcMjWIK3tiTw4UAz+i+gcnHNPTbJX4uyhOGpyJe
         rk1kWMpCdbT21CZOdKlhwDBF1ktBcn4fZkXQ8MivjtyhGOdhZKrNRAsD+BG5J6cg9pwc
         EIbaXZzyscffOuHw0sATr2ZczIbfKa2bosycHApF/7XzZ79tepDt+0CUtHUANov6qjMq
         FpZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762189040; x=1762793840;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gXSUHmcaUphZGHWjr/dbElnyU/fHkGguUYmUjOgo1eQ=;
        b=uSd6rQLNNel3Zdj0Ec/4/UrojtkezGQDbp/kgKlMWcUn/Pm6DP4RJcuCXaIR7pnBOJ
         eW1otHwOYLEG/NPCtFHgp1PTaZcEhYvaAsi29OTbPFxY7Y9vVkUOArCpeViJ3tYkAPir
         zA8WSd6RLHbP4TgSinj5P04tL52S9a4xil03EOsV8nIV2L4y3NQUHvizZmYiNfnsnTn9
         oVs6MWg52tsA/LkX5BVGjNCL/68y0Y51ITl/j38JI5EQ56NTt1FOhao1b8XxmpcBI9LO
         LiY8SJJOd7kwrxQsQtHHAlwvsGQZGbSw/YGRo6kt/0V7Pc4yOf1qwO61+oeVR11kLOAz
         a2qA==
X-Forwarded-Encrypted: i=1; AJvYcCViCAM/goaG0pollrkNijxZzFwQ3/90WTLwUpAt+ckCBvtskKgpK0ciFFCl65PumwO6XPl/Fqm3zw==@kvack.org
X-Gm-Message-State: AOJu0YzT6LTDYdWsVXVE25+SunV5zLgXBhGkb+G9rjSf26dJdGWw+zv9
	E8iWO8d2IelFzQjcUP901yR7E2vKNhvYmb0Mc7aqSnGk6h4qw2fhc63pR7eQq3WU85e3hha2QTt
	0xAMnBmxLHwM70UzZ49DODgof34lfqIbvr4mkSUx2
X-Gm-Gg: ASbGncu2FRW9jPJqZpAsbT+NjeyKnA76yPxgTb68Si9AmC/ZKRnKkQczYnQaJWILDMX
	L6ICaQmfjvfkPZ1dVIYZOqjcxAgVxa+7NLaQDgLtxQ2g3lL9qBkFd3gbDvfFVWNYXHKohGd7xZ1
	zjdUqSpdiD7wRUawhsd4ku+rCoON04bTLdMH2saNYqEis9nnpCZReXx8ohntTxzcSc2yxY/88RV
	ebLpPuEdEreUeMGcbhmLkDP7Yr/X+coLdWbz+oAX149QZw9eRjJbYyR2KUZX6RI5GOgrxnAR8eQ
	FFmiyGQGVUgwpWNkqA==
X-Google-Smtp-Source: AGHT+IHltJD7aAfzyanPskcCGEW/r71vqTVXp8jRpi/mhU0n51LF+Ree9stW3JVC96zs2RiHGJB+80eotHc/1zCN5ok=
X-Received: by 2002:a05:600c:a103:b0:477:1afe:b962 with SMTP id
 5b1f17b1804b1-4775494bf56mr266115e9.1.1762189040413; Mon, 03 Nov 2025
 08:57:20 -0800 (PST)
MIME-Version: 1.0
References: <20250118231549.1652825-1-jiaqiyan@google.com> <20250919155832.1084091-1-william.roche@oracle.com>
 <CACw3F521fi5HWhCKi_KrkNLXkw668HO4h8+DjkP2+vBuK-=org@mail.gmail.com>
 <aPjXdP63T1yYtvkq@hyeyoo> <CACw3F50As2jPzy1rRjzpm3uKOALjX_9WmKxMPGnQcok96OfQkA@mail.gmail.com>
 <aQBqGupCN_v8ysMX@hyeyoo> <d3d35586-c63f-c1be-c95e-fbd7aafd43f3@huawei.com>
 <CACw3F51qaug5aWFNcjB54dVEc8yH+_A7zrkGcQyKXKJs6uVvgA@mail.gmail.com>
 <aQhk4WtDSaQmFFFo@harry> <aQhti7Dt_34Yx2jO@harry>
In-Reply-To: <aQhti7Dt_34Yx2jO@harry>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Mon, 3 Nov 2025 08:57:08 -0800
X-Gm-Features: AWmQ_bkTLA46lp2jCX_gE30BD7c00kSfXnsdnOyhAycwpjTYtFfHvFxWpgPbyHk
Message-ID: <CACw3F503FG01yQyA53hHAo7q0yE3qQtMuT9kOjNHpp8Q9qHKPQ@mail.gmail.com>
Subject: Re: [RFC PATCH v1 0/3] Userspace MFR Policy via memfd
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>, =?UTF-8?Q?=E2=80=9CWilliam_Roche?= <william.roche@oracle.com>, 
	Ackerley Tng <ackerleytng@google.com>, jgg@nvidia.com, akpm@linux-foundation.org, 
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
X-Rspamd-Queue-Id: 47A4518001C
X-Stat-Signature: yym1bmb4qgd9zmnnof4hq7k5cm585t9d
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762189042-892780
X-HE-Meta: U2FsdGVkX1+hlxlrS4MZzHBwGFcEJ9iD/dzIwE4QBbvojltgA+jVNZtsFsH2prYs04Ar+TWPTAmmwFEXHa4qGsBfH2VW9oiYZpOaAjGxcc2GnO75Z/09FO5dgMcSivkTwLX/qV7Sn/cMGrQ5ru3OoA5j6ICvU2QgWu3QPonz2Sv8coapk+rBx/xj32hP3ILE8WNrikT1uG+AvxqBOZwXWiXqysILxRsVIIMvsHm2GV1mtR4xEXwE+NmXu1wJSlGWsOw9dGGV2l3eURSpbJD4xnT/aeTLcixAPyJIBYGpSuusnUOsVz0P1jSdlTF4Z+AZVsv7lPbDPqmK3IK+ySA9Oif7ednUzE1HvUD/ylVsei0kA1TTViZ7z8wYpKp8EZfcC1RTc4cYKQ8fsybein8ED6kxCnbTZUVq530HLQliUEWY2r2sSXkUW6SP0p+llgeXnT7uVWOixls7bzLRZxety8xiokdP8Xkf/9wiBG98m4PQO7DFW///gSb8mzoZz9JtxQEuidb7SZ5+dMiKJUETcg3RbwiyQgQjekg5fAnbX2C5j9MLr2hwtcDX3jL8Uq1LvRnZa3G1smN6sZdgdDEnUUraHc1B6kPYkZnz0U/7xL9aE561Fs9Ss2dmxEAC9vgRKhp/HoX7u+NDTKUwGMGmrCl/cNnsoG3Epshx4hd9mfow1hKs014ehbldqDmPPhKjRY5NsmxkmOBk7jj06xKns8Sl4xP+BSbWllZeYq51+iXJs5NsXjd5Ly7LxbLyE/YptQV+jEXZaGvI/wJfqK1p9+0cbV8lcfVIj0cV7Bt0dMRUo7FitvsJ577K7WLvcCzsb9EtJzEwf5giPgQ5D8twYmR7QokOHcccGZbH+weiRhUhBYfyMwPUWd6nPjImJHGoKCLVQbG6r+gfGESe+O3U+R/0wRdnhgMhRCPIiGfmKFEfEYaaNCAi3XX4ANR4IV5WNjKo52nooCPa1CdGSf6
 1rQPb2cq
 TW7wM7AV//gyCvspR8Sbwqr/dGoPkhdeur5WPK7Mg58BFnQ4ZgTat9Ga+ybCiTZbFmAAbpRHEwXQSeZWr/GKD9C2ZrgXvh5ci1YJ4Hi2r0QC18EvY0Fzif9sX9DE3pONaAUkijBc0I/TGgPNrIPaPl/KNQQ5nd36gkeYVaFC5TGpOq+/yehpqFSN7JlnO5lFsA0k691dQG+OxipbOKJaj8jkZ7GmwvaquwAhMAHqxRcPI2rB4nnEe1pTctMfryTvIBRiVxnzU1vnKOjKb4p0qv27hOxwwaihHgOHLEipzjUfSnNjeScaoVqi04buoYuFIPHFQ9MGridB6CHPwNeyxe9AaUAqdmUhfFDymVbkVhDyM+WP08rOcJ1HjofMGGbG8MUiO6wTDH1UIDBQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 3, 2025 at 12:53=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> On Mon, Nov 03, 2025 at 05:16:33PM +0900, Harry Yoo wrote:
> > On Thu, Oct 30, 2025 at 10:28:48AM -0700, Jiaqi Yan wrote:
> > > On Thu, Oct 30, 2025 at 4:51=E2=80=AFAM Miaohe Lin <linmiaohe@huawei.=
com> wrote:
> > > > On 2025/10/28 15:00, Harry Yoo wrote:
> > > > > On Mon, Oct 27, 2025 at 09:17:31PM -0700, Jiaqi Yan wrote:
> > > > >> On Wed, Oct 22, 2025 at 6:09=E2=80=AFAM Harry Yoo <harry.yoo@ora=
cle.com> wrote:
> > > > >>> On Mon, Oct 13, 2025 at 03:14:32PM -0700, Jiaqi Yan wrote:
> > > > >>>> On Fri, Sep 19, 2025 at 8:58=E2=80=AFAM =E2=80=9CWilliam Roche=
 <william.roche@oracle.com> wrote:
> > > > >>> But even after fixing that we need to fix the race condition.
> > > > >>
> > > > >> What exactly is the race condition you are referring to?
> > > > >
> > > > > When you free a high-order page, the buddy allocator doesn't not =
check
> > > > > PageHWPoison() on the page and its subpages. It checks PageHWPois=
on()
> > > > > only when you free a base (order-0) page, see free_pages_prepare(=
).
> > > >
> > > > I think we might could check PageHWPoison() for subpages as what fr=
ee_page_is_bad()
> > > > does. If any subpage has HWPoisoned flag set, simply drop the folio=
. Even we could
> > >
> > > Agree, I think as a starter I could try to, for example, let
> > > free_pages_prepare scan HWPoison-ed subpages if the base page is high
> > > order. In the optimal case, HugeTLB does move PageHWPoison flag from
> > > head page to the raw error pages.
> >
> > [+Cc page allocator folks]
> >
> > AFAICT enabling page sanity check in page alloc/free path would be agai=
nst
> > past efforts to reduce sanity check overhead.
> >
> > [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-=
mgorman@techsingularity.net/
> > [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-=
mgorman@techsingularity.net/
> > [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
> >
> > I'd recommend to check hwpoison flag before freeing it to the buddy
> > when we know a memory error has occurred (I guess that's also what Miao=
he
> > suggested).
> >
> > > > do it better -- Split the folio and let healthy subpages join the b=
uddy while reject
> > > > the hwpoisoned one.
> > > >
> > > > >
> > > > > AFAICT there is nothing that prevents the poisoned page to be
> > > > > allocated back to users because the buddy doesn't check PageHWPoi=
son()
> > > > > on allocation as well (by default).
> > > > >
> > > > > So rather than freeing the high-order page as-is in
> > > > > dissolve_free_hugetlb_folio(), I think we have to split it to bas=
e pages
> > > > > and then free them one by one.
> > > >
> > > > It might not be worth to do that as this would significantly increa=
se the overhead
> > > > of the function while memory failure event is really rare.
> > >
> > > IIUC, Harry's idea is to do the split in dissolve_free_hugetlb_folio
> > > only if folio is HWPoison-ed, similar to what Miaohe suggested
> > > earlier.
> >
> > Yes, and if we do the check before moving HWPoison flag to raw pages,
> > it'll be just a single folio_test_hwpoison() call.
> >
> > > BTW, I believe this race condition already exists today when
> > > memory_failure handles HWPoison-ed free hugetlb page; it is not
> > > something introduced via this patchset. I will fix or improve this in
> > > a separate patchset.
> >
> > That makes sense.
>
> Wait, without this patchset, do we even free the hugetlb folio when
> its subpage is hwpoisoned? I don't think we do, but I'm not expert at MFR=
...

Based on my reading of try_memory_failure_hugetlb, me_huge_page, and
__page_handle_poison, I think mainline kernel frees dissolved hugetlb
folio to buddy allocator in two cases:
1. it was a free hugetlb page at the moment of try_memory_failure_hugetlb
2. it was an anonomous hugetlb page

Let me know if my understanding is wrong.

>
> If we don't, the mainline kernel should not be affected by this yet?
>
> > Thanks for working on this!
> >
> > > > > That way, free_pages_prepare() will catch that it's poisoned and =
won't
> > > > > add it back to the freelist. Otherwise there will always be a win=
dow
> > > > > where the poisoned page can be allocated to users - before it's t=
aken
> > > > > off from the buddy.
>
> --
> Cheers,
> Harry / Hyeonggon

