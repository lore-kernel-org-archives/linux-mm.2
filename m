Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17238CCA470
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 04:51:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F0D18E0003; Fri,  3 Oct 2025 00:51:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A1938E0001; Fri,  3 Oct 2025 00:51:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DEC78E0003; Fri,  3 Oct 2025 00:51:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0ABB08E0001
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 00:51:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6BB3813ADCA
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 04:51:07 +0000 (UTC)
X-FDA: 83955578574.28.46D6B33
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8EE4C100006
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 04:51:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IQ7VeX5z;
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759467065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kDZblzDIYs2H/7m2dfYraE1HUk3zYX/2myk5FlKZLTw=;
	b=u9Cyl1921mwcPrrSahoDhfZr8d2d+DSjqdHq2YiUP6o10UVbW/nHsHxdHvtZu/oZfAB+Mb
	6pjWyRGWodQY+wwnZ+40ZkR3qjelKoLthPEQJ1TrbHvRMKnAj0kuC85zz6GjR0JMnz+981
	0DDU1yTo4ga915afKex7CJr8xuScBIE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IQ7VeX5z;
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759467065; a=rsa-sha256;
	cv=none;
	b=GXPN4Bg9wcIp/W80+SuYfjgGUnaXTpoTkk2YIlVoXS00TS6o5hK88pPGmHsIrIfMg87Qoo
	//z46/rQbRlP8juZfj+nxmPZ0ICdHRyZ33UZonYFb595LC7zOClqv8Las5MDvyRDnkz11r
	CzC6ZrN6RIfbEJUVK2wBri11h+lI1nE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C44340624
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 04:51:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179ABC4CEF5
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 04:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759467064;
	bh=xI4A+WZDYpY4GIQc5MWU2VygJBtUXOCyseSfiGfjGzk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=IQ7VeX5zWran2MVd+kpebtN7Py/TZI3M0iL7JYWtoLajFPd70mnAkH75RlERzOhsU
	 QVZMYJAx0do7wrZKnkUKnXBUAYhASmJoWH8n1G+kIkbYlCI1eNHp9UfN0Wu9L6/4/k
	 XmZjqnedM7xVbAHbkEIDniH+5//yLlXnTI6M57UdBX359o6wQ2DmoR8h8erFwTur45
	 zAq8JJI8jEX873L6/S7bU5M7CTPFZSP1FPYIpbPB4haPd2NE9GlNfBLIwTOMDJRt/k
	 76R3KgFuH4potkFK4xxyFkIQ8Z8MfyWkAUA1d0plPlQ0YANdwh9+lAX8uzMN+nObZ1
	 f/9n2nLJacl9g==
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-633b45fad1aso2008570d50.3
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 21:51:04 -0700 (PDT)
X-Gm-Message-State: AOJu0YzkXHsxxhZZ2yxpBTCCVmPeaLGe7UIFk+A74tDXfOUxbByUenBN
	bp3IbbkLdKRkIqVWrvvZtLIw+YqvA7iIwcDeVtEt3veC7MaJt9KOw47+gyiGFnELsd7zKStk/jL
	EdHgTqro9ud/JmeTzEA9t8juyDNSEyrxhy5o8jG6Z6A==
X-Google-Smtp-Source: AGHT+IFFbvWpQp2aFfX+RE2sXmGqAC/t/eEeFDcgmc34xCjtJmy4+5qEoWRl3qQHuimbfN73Qn9qP6guaLmfyQaNDYw=
X-Received: by 2002:a53:c941:0:b0:612:891a:9ecc with SMTP id
 956f58d0204a3-63b9a0542admr1352594d50.9.1759467063289; Thu, 02 Oct 2025
 21:51:03 -0700 (PDT)
MIME-Version: 1.0
References: <20251001043436.41338-1-bhe@redhat.com> <20251001043436.41338-3-bhe@redhat.com>
 <CACePvbXeFxbtH3c0Wvn56m+wsK0wqxP86ge5Ud73OvqnfDOwMw@mail.gmail.com> <aN83NwGpMCFvrOEy@MiWiFi-R3L-srv>
In-Reply-To: <aN83NwGpMCFvrOEy@MiWiFi-R3L-srv>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 2 Oct 2025 21:50:51 -0700
X-Gmail-Original-Message-ID: <CACePvbWgKCjW0fHT03QUXWsj9sV0+1Co9_=t9OWQA5-ApEJyRg@mail.gmail.com>
X-Gm-Features: AS18NWCoxeholCiqXI4xjwqZlrcF-jyswW_-XhDc5DZfdQHreF1AZAXdtDlktlk
Message-ID: <CACePvbWgKCjW0fHT03QUXWsj9sV0+1Co9_=t9OWQA5-ApEJyRg@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm/swapfile.c: use swap_info[] to find the swap device
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	baohua@kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8EE4C100006
X-Stat-Signature: d8rgxizs8dxdxoaduprp4yoj4jrxrsmc
X-HE-Tag: 1759467065-697113
X-HE-Meta: U2FsdGVkX1875ZRIiNvuPygCQ8/DT8QflE/lngtUjvz9orMpQk3WBeUDvYXIsVmpry4WDkFsWMbbClXFw64EUWkRz8copSn/l4o6M696QUEgf38M0lSNxZOD8DYCDT1pq3tniYAzVSpZmwso9Mw4ATryf4oIYlKbZ/cAGZQPxuhaKY5I6qId/lptVVjy0cNtBttpmEjBZnv1fYZSyVNiZFEAIGqEStLY38jpCQDP2jAl9j9Nd2upeQDvxHm/OnMapnAe4lRe9UoFSSd+UGAZoxgAi0qHodZcGGO/rK32FONQj0xYhv5WiBMoxvcq2OBveaDvUDaQfkn6AK3lb6DD3nC0X59PQTkZollE5sYWZKPnjNmhIc6YAWnUrwHG+bvi24W02zug3dI02cnI77rN8NZxROuvWQC/l9ZKgSiNVVbd97fACZrJdJutEsF+PIr3COQj6Whwv/Ey+mafM360sKILJAF9+HnxoE0ABBDOvv2Zrf4oLGP6xb0IGJYEBqMiSe7U7ByHg1tQELOYen1Br9ODWv5DC7ib0PkSAOJJ061NN21MIx9MFIVeF9XyiM67lAUE4ONpEJmWYxecCc4V6D8W+sNUOGX56NRKF9rn8qbGG++/evz58H+V3wa5G4khE4By0/de/OYOksMMKn27zsLVABHniDlfBP+CJTslZIkbzPm6ycW3jvXgkEQoY3FrEiozKyJDrfZkOoqqr8yj2ww+Jntu7rm6wslljRZy3lWCrbcqUldyzZEJpuzFr+rNBqoBWdSqQOhjK4JrvBnydGavlZ9mdAmCK1eva8K+zHEJjBu1kfI+jchW061w1yS5+VE2zv5r95O6fe+GdqDEn6xSLi19RYF3WJYgBVb/O/FHNSs+p8LGJ/3sh9abS5a9vtfY43CdRACZbE+pOtZB6Wd/XJJI7eLDwhcMpEouIVdkyXY7kW8dtiZEqzxho5khNeJzX10dA6tj4eeElV1
 VNm3NLfT
 R7waTd+Ec7fBszOwmOeO9UllEXf/nhpaBYSvn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 2, 2025 at 7:39=E2=80=AFPM Baoquan He <bhe@redhat.com> wrote:
>
> On 10/02/25 at 08:59am, Chris Li wrote:
> > On Tue, Sep 30, 2025 at 9:35=E2=80=AFPM Baoquan He <bhe@redhat.com> wro=
te:
> > >
> > > Now, swap_active_head is only used to find a present swap device when
> > > trying to swapoff it. In fact, swap_info[] is a short array which is
> > > 32 at maximum, and usually the unused one can be reused, so the
> > > searching for target mostly only iterates the foremost several used
> > > slots. And swapoff is a rarely used operation, efficiency is not so
> > > important. Then it's unnecessary to get a plist to make it.
> > >
> > > Here go by iterating swap_info[] to find the swap device instead of
> > > iterating swap_active_head.
> > >
> > > Signed-off-by: Baoquan He <bhe@redhat.com>
> > > ---
> > >  mm/swapfile.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > > index 5d71c748a2fe..18b52cc20749 100644
> > > --- a/mm/swapfile.c
> > > +++ b/mm/swapfile.c
> > > @@ -2641,6 +2641,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, s=
pecialfile)
> > >         struct inode *inode;
> > >         struct filename *pathname;
> > >         int err, found =3D 0;
> > > +       unsigned int type;
> > >
> > >         if (!capable(CAP_SYS_ADMIN))
> > >                 return -EPERM;
> > > @@ -2658,7 +2659,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, s=
pecialfile)
> > >
> > >         mapping =3D victim->f_mapping;
> > >         spin_lock(&swap_lock);
> > > -       plist_for_each_entry(p, &swap_active_head, list) {
> > > +       for (type =3D 0; type < nr_swapfiles; type++) {
> > > +               p =3D swap_info[type];
> >
> > After some careful thinking of the swapoff behavior, I now consider
> > this patch buggy.
> >
> > On behavior change is that, previously the swapoff is dependent on the
> > swap_active_list and only swapon device is on that list.
> >
> > Now you change to enumerate every device at swap off and depend on the
> > p->flags & SWP_WRITEOK to filter out the device. Which will go through
> > all 32 swap devices regardless.
> >
> > >                 if (p->flags & SWP_WRITEOK) {
> > >                         if (p->swap_file->f_mapping =3D=3D mapping) {
> >
> > Considering the following race:
> >
> > CPU1:
> > swapoff( "/dev/sda1")
> > spin_lock(&swap_lock);
> >
> > for (type =3D 0; type < nr_swapfiles; type++) {
> >      if (p->flags & SWP_WRITEOK) {
> >          // found the device.
> > }
> > ....
> > spin_lock(&p->lock);
> > del_from_avail_list(p, true);
>   ~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > plist_del(&p->list, &swap_active_head);
> > atomic_long_sub(p->pages, &nr_swap_pages);
> > total_swap_pages -=3D p->pages;
> > spin_unlock(&p->lock);
> > spin_unlock(&swap_lock);
> >
> > // at this point the p->flags still have SWP_WRITEOK.
> > // swap_lock and p->lock are both unlocked.
>
> No, SWP_WRITEOK is cleared in del_from_avail_list(). At this point,
> there's no more SWP_WRITEOK in p->flags when both swap_lock and p->lock
> are lifted.

Ah, you are right. I am wrong. I missed the "si->flags &=3D
~SWP_WRITEOK;" inside the del_from_avail_list().

I read at the end of swapoff it set the si->flags =3D 0; thinking the
SWP_WRITEOK was clear there. It is cleared earlier.

That should be fine. Sorry about the misread.

>
> >
> > Now the second CPU swapoff race begins
> >
> >                                                        CPU2:
> >                                                        swapoff( "/dev/s=
da1")
> >
> > spin_lock(&swap_lock); // can take this lock
> >
> >                                                        for (type =3D 0;
> > type < nr_swapfiles; type++) {
> >                                                        if (p->flags &
> > SWP_WRITEOK) {
> >                                                               // also
> > found the device. because p->flags are not clear to 0 yet.
> >                                                        }
> >                                                        ....
> >
> > spin_lock(&p->lock); // can also take this lock
> >
> > del_from_avail_list(p, true);
> >
> > plist_del(&p->list, &swap_active_head); <=3D=3D=3D blow up here
> >                                                        // remove p not
> > the in list.
> >
> > atomic_long_sub(p->pages, &nr_swap_pages);
> >                                                        // double subtra=
cting ..
> >
> > total_swap_pages -=3D p->pages;
> >                                                        // double
> > subtracting as well.
> >                                                        spin_unlock(&p->=
lock);
> >                                                        spin_unlock(&swa=
p_lock);
> >
> > Please confirm or deny if that race is possible.
> > If it is, consider it a NACK to this patch.

I withdraw the NACK. Sorry about that.

Chris

