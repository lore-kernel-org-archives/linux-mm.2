Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA546CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 09:19:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 060488E001B; Tue, 11 Nov 2025 04:19:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 037AE8E0002; Tue, 11 Nov 2025 04:19:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8FD68E001B; Tue, 11 Nov 2025 04:19:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D0A3E8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:19:55 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 753E9C0494
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:19:55 +0000 (UTC)
X-FDA: 84097779150.08.65E7E0E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 934B14000A
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:19:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vGClO8NE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762852793; a=rsa-sha256;
	cv=none;
	b=q9hmxpFpYOMAMt1TQTGxJ2RaWNH7vtRFqpQsoDrLTO1SVm3XbTwKh5mm0ygTEy2Njc4BPS
	xO+cpafojQEmNkkwTzK9U9luvK3njNguR6RRliRqVxkPbUocwEnng/VN4oQSsJnHS9D0rI
	neTEGbUMsGnOAXknM/AzXLk+7CDa4ZQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vGClO8NE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762852793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RXZ2/EXzi6r7HrFOiKQfxybykgs0x88PVJCYtHof4Hg=;
	b=aYnUwUnJSMHoUVDKOBb88gVnWR6h+q2qZkPpGebP3A1gWVbLblAhSyGaIWVin7QOAn/6g/
	xe3LvmvZoQvm1Dqa2Ie1AEjBzw39gX3PFAjEmvZJ7LSjaPzUPVHeB1cqPJg1++KkiLKa4c
	IiSUGuOpEoyx2xuQIoxHahwPtljVIhA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1EE8C61923
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:19:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D2EC116D0
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762852791;
	bh=dVuTtHvnVZEobITrk9FyDHPMZXl5yRe3omNS/JcWa64=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=vGClO8NE0KorCNpVq7YjjPoJy4vppAc1exbgNg08YFojL+dCZUmXYan4Wftv6Gmgv
	 GEa5Cfno24p5jxvYB/qDkaZk9C5q5w3kRLHUbzXznZ6oolxTsaWOZHMZ30eLed0sXX
	 Egq/iKpmX81Z2Ojm2N/HTq94Olgee+8BMC8ZQeiiffDB8QDkji4mseoLtGvE7ZrhYn
	 dP6Lyes8MmmyzNcHmC8Tv8TlcJnJCoZxEs+Jh5/+z/VVpJKPEC43Am3km0NAnjA2Au
	 zZAMssPqCgroICwsfk9a9tSlMA452D+MVB2qo029A00ncGyiyFIJrvq/hmj6vDJQzp
	 +9zlwlmMK1NvQ==
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-78802ac2296so9966987b3.3
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:19:51 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW0sOS8diYPvsuy66RSxu4EjuYRWrIEZXU3+Sgg+NwrrUHcpmbRTJhQX/pyibxhrs91zldyTg2NBw==@kvack.org
X-Gm-Message-State: AOJu0Yyq8EYs/a+KEN8BwgfJs2HQOLa3rb6IM9q+IoeQoM5iavBYc9i3
	HQaSHHCoDYBZBn2XNxAki9QiHjs1vJg1g3uJeB63G8Nd51Zjjp6BHmyd3VS+yR2lIqDNnKgGm6u
	1wg4VgalAnlEWs5pF68mHCUL3HjRW4N64esAv9enf+g==
X-Google-Smtp-Source: AGHT+IE7U/hfMH//RfLupvft/VoqtwYRbFfH+avnkA19gWihvYeZ3A5/gr7GLzY5y0EQ9dDLUE90MgX0MeQiFlzqDkk=
X-Received: by 2002:a05:690c:3341:b0:786:6b92:b1f5 with SMTP id
 00721157ae682-787d5439064mr100470067b3.47.1762852790107; Tue, 11 Nov 2025
 01:19:50 -0800 (PST)
MIME-Version: 1.0
References: <cover.1762621567.git.lorenzo.stoakes@oracle.com>
 <CACePvbVq3kFtrue2smXRSZ86+EuNVf6q+awQnU-n7=Q4x7U9Lw@mail.gmail.com>
 <5b60f6e8-7eab-4518-808a-b34331662da5@lucifer.local> <CACePvbUvQu+So7OoUbJTMLODz8YDAOgWaM8A-RXFj2U_Qc-dng@mail.gmail.com>
 <3c0e9dd0-70ac-4588-813b-ffb24d40f067@lucifer.local>
In-Reply-To: <3c0e9dd0-70ac-4588-813b-ffb24d40f067@lucifer.local>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 11 Nov 2025 01:19:37 -0800
X-Gmail-Original-Message-ID: <CACePvbUHCrNNy38G4fZP92sdMY7k5pRQkcfo=iPp0=10T5oCEw@mail.gmail.com>
X-Gm-Features: AWmQ_bkffqW5YvxjFtC7ucCTeEYe-oG-VIvciMpKUSHdG9LRrce-7fJweHmox0c
Message-ID: <CACePvbUHCrNNy38G4fZP92sdMY7k5pRQkcfo=iPp0=10T5oCEw@mail.gmail.com>
Subject: Re: [PATCH v2 00/16] mm: remove is_swap_[pte, pmd]() + non-swap
 entries, introduce leaf entries
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	SeongJae Park <sj@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Pedro Falcato <pfalcato@suse.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, Hugh Dickins <hughd@google.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-s390@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, 
	damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 934B14000A
X-Stat-Signature: moxhhy8snxa6wwoo9redxk71bwwgh397
X-HE-Tag: 1762852792-103736
X-HE-Meta: U2FsdGVkX1+3KOW/GPGt+Ys4H8iPCa8rNIqvMszt0LpNwnRxUh6V/FtYDRbbKSYHbfz8TDQCjGnyrmiSUA4Iv+G/4drQFjF9QuASL9ceKCPCWz7SsqetQ3pvkxxtIcvrw6Bb+b2IGucB4+pMpwGA2+5CG7bHR2b5SHVGtjU9RMliTVktqfJGSStLEKlriTxKtLyq+UzTKufuxkxei5OMjlabbh96x+mhVxIf4PJQcY6MnEmgkd0y23y1gej5qVeRYDLhFh47pMTD2sj5uJSB5Rf1RJnpPlHZyBBlGduhf+IS9JzmEZ2sJ8GfPGNsX0PtfJTQvCispopaO+RDbOtWB7d89xFIYJaHYFtpcEu8C1rZXdtGtSLG8tBMIyFgvtvf1eFv5TfpF9rnClpP5xfZAIJPpwyxMLTuWwZIq/0slpZ7SGsUC/f1LJnmnRl0peYxJldTBz+ljzUIzqk5tzF6Opjs7pfSnp3ZLO3xm05aPIuYsJGA5H5pB161ZFXJ26gkIfKnvqb2Sq3vK+9MpKHFGj1pPqmsYX0KNPR4ZubEw1APtwwOCfPkCMqsAueHKB/AarIF/TitDWADxxifKYyYgj7jqv5kCWj41Nt06m7QPM/dr1Gl4omEy8dvFMOn4e/KgnMOYDA7oymUY8PQibgOGvJs4QveZkPNkIWvjyQWPWH4q1WuaasODrJEXxaNn01+3kMabN3qo3Yo8hhmHA+1wrCE06zn6puraIwDViqx2eJ02fERQmwUIoAziTT1Uj1r8L0ZFNxqkjUyYdlhLVPG8vC0ftTtOwTx3b4Ok/1LxNEiYHhxYLOsvfr3ghtsZzcVWfxzcdSDkkm3t3Ql7YfR2P7rayop/C9tGYXEMrq7sBIka4qZep7Xl8CYfo5Q40gELIvU5moIlWQfLBnh8oY5SmXe2bbjF8/P4CVghou90mPqeXv4irn3ZqLifOi1/2GywsnQ+jVsFIL/x6Vik4x
 QNjL88Fo
 HjP8esGjeHvPnkwaeAwtABV39Y11+pFr068cAmSZ5hcAO/n0yfJKKr0OZsfZGWO1fktum9GL8sEScv62toO+K4zuw9OXxk68cI4GbobWVYll3oVB8Q6xChXDAoxutG6R+Ni6sqG9Dxpnx64ojXoOUCkwhsBufZNBuITAxxXFQWDd+HjG2VhlxdGLPELXW3PGMB97GMx6bOjyFJ6egQ/JPApoOHuJys64HPp1W8Kovq9s6YmayNIFhbD0dtyQuA3HVbsOrIxva32lZRNO2160xRMsJXcJB18KlR7etmh/B2NsQeEf60jJEVCozFzIkk63W3K701n9FDqUbS+fPV6pnLzMUP+wRLYCfiGsQ2QQAjRw01ZFK3oARzNRnMPyj2PCPOlC82EqqIqRgjwjK03ix0MQcIn510EVJVIc1Mnl/Q7tOm6g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 3:28=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
> > > > I kind of wish the swap system could still use swp_entry_t. At leas=
t I
> > > > don't see any complete reason to massively rename all the swap syst=
em
> > > > code if we already know the entry is the limited meaning of swap en=
try
> > > > (device + offset).
> > >
> > > Well the reason would be because we are trying to keep things consist=
ent
> > > and viewing a swap entry as merely being one of the modes of a softle=
af.
> >
> > Your reason applies to the multi-personality non-present pte entries.
> > I am fine with those as softleaf. However the reasoning does not apply
> > to the swap entry where we already know it is for actual swap. The
> > multi-personality does not apply there. I see no conflict with the
> > swp_entry type there. I argue that it is even cleaner that the swap
> > codes only refer to those as swp_entry rather than softleaf because
> > there is no possibility that the swap entry has multi-personality.
>
> Swap is one of the 'personalities', very explicitly. Having it this way h=
ugely
> cleans up the code.
>
> I'm not sure I really understand your objection given the type will be
> bit-by-bit compatible.

Just to clarify. I only object to the blanket replacing all the
swp_entry_t to softleaf_t.
It seems you are not going to change the swp_entry_t for actual swap
usage, we are in alignment then.

BTW, about the name "softleaf_t", it does not reflect the nature of
this type is a not presented pte. If you have someone new to guess
what does  "softleaf_t" mean, I bet none of them would have guessed it
is a PTE  related value. I have considered  "idlepte_t", something
given to the reader by the idea that it is not a valid PTE entry. Just
some food for thought.

> I'll deal with this when I come to this follow-up series.
>
> As I said before I'm empathetic to conflicts, but also - this is somethin=
g we
> all have to live with. I have had to deal with numerous conflict fixups. =
They're
> really not all that bad to fix up.
>
> And again I'm happy to do it for you if it's too egregious.
>
> BUT I'm pretty sure we can just keep using swp_entry_t. In fact unless th=
ere's
> an absolutely compelling reason not to - this is exactly what I"ll do :)

Good.

> > > So this series will proceed as it is.
> >
> > Please clarify the "proceed as it is" regarding the actual swap code.
> > I hope you mean you are continuing your series, maybe with
> > modifications also consider my feedback. After all, you just say " But
> > I did think perhaps we could maintain this type explicitly for the
> > _actual_ swap code."
>
> I mean keeping this series as-is, of course modulo changes in response to=
 review
> feedback.
>
> To be clear - I have no plans whatsoever to change the actual swap code _=
in this
> series_ beyond what is already here.
>
> And in the follow-up that will do more on this - I will most likely keep =
the
> swp_entry_t as-is in core swap code or at least absolutely minimal change=
s
> there.

Ack

> And that series you will be cc'd on and welcome of course to push back on
> anything you have an issue with :)
>
> >
> > > However I'm more than happy to help resolve conflicts - if you want t=
o send
> > > me any of these series off list etc. I can rebase to mm-new myself if
> > > that'd be helpful?
> >
> > As I said above, leaving the actual swap code alone is more helpful
> > and I consider it cleaner as well. We can also look into incremental
> > change on your V2 to crave out the swap code.
>
> Well I welcome review feedback.
>
> I don't think I really touched anything particularly swap-specific that i=
s
> problematic, but obviously feel free to review and will absolutely try to
> accommodate any reasonable requests!
>
> >
> > >
> > > >
> > > > Does this renaming have any behavior change in the produced machine=
 code?
> > >
> > > It shouldn't result in any meaningful change no.
> >
> > That is actually the reason to give the swap table change more
> > priority. Just saying.
>
> I'm sorry but this is not a reasonable request. I am being as empathetic =
and
> kind as I can be here, but this series is proceeding without arbitrary de=
lay.
>
> I will do everything I can to accommodate any concerns or issues you may =
have
> here _within reason_ :)

I did not expect you to delay this. It is just expressing the
viewpoint that this is internal clean up for benefit the developers
rather than the end users.

Keep the existing swp_entry_t for the actual core swap usage is within
reasonable request. We already align on that.

Chris

