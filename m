Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8B60FF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 16:48:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28F536B0088; Mon, 27 Apr 2026 12:48:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 266436B008A; Mon, 27 Apr 2026 12:48:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17BB56B008C; Mon, 27 Apr 2026 12:48:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 079156B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:48:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8B077A01C0
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:48:45 +0000 (UTC)
X-FDA: 84704919810.26.99B8804
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4A87114001E
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:48:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DV323+LO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of surenb@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777308523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bZP6CUDEt7N3kI4YkVp2qKdsX54A5o1g08c6mQbolGA=;
	b=l23+V8GPZz1RDO0sK14A9XBXmcPp8AgjlKBg8UoLp5sBpa/rZDZBrCYXU7PlpSQKfIYKXX
	MRawpyPvLqhOEn2pjXmQlMVohLcP/AFTd2OvoChd3LnIAqJmMxNFGYLEFC36CUUnEJO+Fm
	4+mz7zkmSeC+t5WEcx9Z2imCnzmKOQM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777308523; a=rsa-sha256;
	cv=pass;
	b=vVrpUtSEZSkH16r771EW2UW1qfsOKTClRuDwCbQb0kVgUmk5EhGwbS46qpGA6sAC2uAAdk
	tebJ516mjYde5Br/JxPCtI7qpLKDdxQ0iYTZ47tBUE6YrNucqQ92l093H/5zlFzYK3MBLW
	YDQNNULilxR7vpeMcN4n//B4LcyZIe4=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DV323+LO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of surenb@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-671588ab0cfso89370a12.1
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:48:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777308521; cv=none;
        d=google.com; s=arc-20240605;
        b=G3e/Qz1lzjgAqo2wzpgbydpRo/q9fb16bqdxQMipOZu9eHh5dZmqgA7eLVHbYOyGqo
         NcW5W5L0rkw/2L1O5ZLMLMxjfkSlgK7EOLjy2D8///TnQBSrGA54PU1Cn/PvV8DaloPS
         S0KeXjDqEz8aYLQVqtWkoF5T6Ecg1snIXSwo/LPhVwu0J1AkVKPGg+iFkAhu+fSgK/Gu
         uqtT6SKfB4yuqPfhwK/etnNCw4e/zmKz1zunsl87+uLBChsXJh8cVtk4rhtUviZwcbDt
         G4RJRtqJRz8aNZ11b8wt27fsHuYX9r3y6sITcNYjqZ2MdXB5jXvKqc1fBklOSE6iILUR
         0PnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bZP6CUDEt7N3kI4YkVp2qKdsX54A5o1g08c6mQbolGA=;
        fh=zYvVMkFH0uYQvH+n3a+/HPLqHTSdnHm/VM4ZuarcYa0=;
        b=JinpOKeqsoVSQp1Qn1e3gAecEtriPFzQpZnigZvafVIDMv8xYv7tbRYenToXv+KEX8
         TkIo1pHP/j9mESEBOwMEUA9NGtE1SQkrgq9weYObHyB4booHu7bsC2XPwlHtPs4HO2zf
         VdXYJcHVKhjdyhbvp9DOBU4g2RdNDUTkTE0gjaJS88jRWvU+rddUQfxI90rrK7tlArij
         jO1AgTRVZVQC+gcO6r8/164+PnWwCheas3efswvSHa8kw+/tLiXYQve3NE+k626xP9P1
         lXDXc0dF7RbdRj31le5PN8i5x1GcMfvERJvglDzF89lwiaiP2ijr+OUmZg1FNLQVX0n1
         heZg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777308521; x=1777913321; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bZP6CUDEt7N3kI4YkVp2qKdsX54A5o1g08c6mQbolGA=;
        b=DV323+LOPcvt8qSzKyAC6Xm8SyZYB9tvvP8+8x+2pNGKyhEsIJbQksyzdxtc8+gPWP
         g0sHYPlKClQrJCdrQGqepOuB5AarfOw+4KuPgu3AtpsBH+LhnI6zzURGLgqoEQvsSZdR
         DshbpRLF5qzkOtErwzGus2kxHDLnlNOKNgJZvDmwzZGifU+2IvUxM78PEIf84uef68OT
         9st+YkOP/JUdPdB14zVcb/6rC1P+VITBLJj+AM+BiZuJYw9lFq9iVMv/ZZO/slavz/m5
         sXviiMFOD7U/FBTa8x8GGnXG70vBng0FsjDBhbzz9RlnHzeJ1KHze5nItH10ZYV5b6V7
         WzXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777308521; x=1777913321;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bZP6CUDEt7N3kI4YkVp2qKdsX54A5o1g08c6mQbolGA=;
        b=C480/bwCTNxy4GvRXNhU6TkZcUjXKdWctjbFD+lLzwpLzTEM7Gj/dAvsdfSuNIsF1V
         KqC2WrhzyqCMsvo8owp2ju4ZimqV9m2dpaVPL/gPsXcnbU/58OXf0AKtGgpcfG7+cX3q
         ND0q6K88ysWy4d5LZ5V7RpB5OzIF0w/15bfTAFU9D4Xvh+mLEHTxxV/r7loI3yY7hb2N
         TwGxVhH828wv+9btCkBjw+5wKHbzM3eIbyTr70uDPO49Tem/mY2bNsC1alhAgvX2nNvR
         0KVwAkqFuGb5xQ3+md93xWuzq7oFnzJjkqAhhXXJa5htAjEKl5hSE0MkJB2F53qyUMXD
         +Ipw==
X-Forwarded-Encrypted: i=1; AFNElJ8ZjrH1XBoKR6hioYMzKjtVEXQtprHwKKMi9DqUj2K2wcws3gwIFb6dM/KDD2TSvY5/8fFTXnwn4g==@kvack.org
X-Gm-Message-State: AOJu0YzVmTjFW/LXFGvgsvctgoa3hhdRVPu1O1If1xXlQdgCajjEIZKU
	+8A26ohL3g4Xn1gLBF3XojqgjEtkthFY76USm6k0CIkEEnl6VB2lEt2QkIRwJmPxY3pAz8R3hwq
	WzWDzK7aMPBVost98viktmYDDd1X+dKsEjA37CKTh
X-Gm-Gg: AeBDievOc0jJme0WtPqoHZTn0z3N/6HB8Db6mhqG2LLL8K0ilSxWsfEsnfu14md73Vw
	H6JsqAkWpGZCzSxeQKxZV/s/3e7qDStJwDBsRdy3G8sQY+PqsV+vu1x2KHATLuKCGtquBAe4uVp
	vGczHYQAR7DYYbe5mssuiCbou2z+CqDzvyb7/MTdVfsZSG8lRa+GWLsnPqNVG1X1rMleUL1PXTl
	YLFMiUAlk/o7NXcpp5TI3+HFp7CUIKi0Tp5ggvYbJ3KVI6TlxYK9Z5F40bFiEx01065lhjsn69k
	49AH6HmuG5xOeIPi1nPqEGLLbfM=
X-Received: by 2002:a05:6402:5342:10b0:669:d537:de85 with SMTP id
 4fb4d7f45d1cf-679b62e5cccmr3086a12.11.1777308521116; Mon, 27 Apr 2026
 09:48:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260421230239.172582-1-minchan@kernel.org> <20260421230239.172582-3-minchan@kernel.org>
 <aesg-sj6_VmXyqxb@tiehlicka> <7c7da8ae-cd39-4edf-b94f-c79ab85df456@kernel.org>
 <aevBRh08X4UTMUj9@google.com> <ae8NT0tLt7eBmH6j@tiehlicka>
In-Reply-To: <ae8NT0tLt7eBmH6j@tiehlicka>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 27 Apr 2026 09:48:28 -0700
X-Gm-Features: AVHnY4L0O_dGJE6WV761t9MXwzX-HoKvv8kfO2fCRciCnWWjyse2vOAdVdr-N4A
Message-ID: <CAJuCfpHQdA7C50V2WjNrdYcp7feV5ukgxJf+vMNEcp0P1SGEow@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] mm: process_mrelease: skip LRU movement for
 exclusive file folios
To: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>, "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org, 
	hca@linux.ibm.com, linux-s390@vger.kernel.org, brauner@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, timmurray@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4A87114001E
X-Stat-Signature: 8szp1wpbx3dsiaiqi4nafesu9odjo478
X-Rspam-User: 
X-HE-Tag: 1777308522-599595
X-HE-Meta: U2FsdGVkX18hCH//WK4omy7X2BSD+WznoTxTdBohZoRoEW8LkDE5nRQLK0mIgTEFpcqh868U2fFVn2i2YBGexY5Hr7rDydm2x2PT6XZLQXgLXomZwkqDMnZsTX9PmVeHRlAbD/smWYU98ia2DMj16hGG+s6qppUwEFjx755A+piQo3vnt+GPFYWAQ+aVgg8WW/wgVzZJn6l9+doKYf9/1Ua/SZcalMVCmpKZkPyzojZ0ul4pBP1QZwgxzFfgj7Gz6eIbiBoVckWLTw0sqLU1Zdtl4powCw+IMEt6CDzvCX3kmQDLgsOpMx7Os03RF1iS1rQ4WVx7noVSX7nHroWhCJF6zpOzCGHJtDeH4rBM8Y24eq6qmhhuSgpY+MeWc/526kNCmFTF2iZMN0ckZTvFyZetGuV0il3+zTd+HNDdhHqIp2r4JBuBM028UruHczMbA6u+1qbPorqsi+S+QpCbqT9aB7QiOR61dVZfb68xk37S96PPC4Ic+B39LyHHvyaGUr8jMV624eX3t+ypaA5vmBz42jyChazN731TsqlfTdLGp4JVohiUywNoeDcixOzFk1FgcwvoTk4RGsya0iwN2wFP4GXuFlPOoIIUJZ3yLh2ajfqeoPyO30VsWfKUl1Btu3PobG+aSgFI+10bGZ/bzzT4062qskTGlOuALNx04y0JEj9lcUj07EFdzTGTOeQUEaqlhyZXKgfx5eRxd5QXUDG5v8r4VHORk/+02aEKXocHQSkLHLJaA1UI5vQ38j1+io9FZcLoRvHPKL/pSzPItUL6X+Bcb/Gla4hhOva5TX2l6JxOS6qY6PaCMQvd7eQ2K+twU+4HJ7j/oONsHE6rr+SFiWG9wN/x9CqXwBX/FEh3YLkIpgbSCmXL1QavXAIXTv80iJzXY3y1DSVGtip2DtzqNj7TMC4yp4bRmVru0buKg3TO0Zl+Y7N/QzcDJlDdZUGYjxpC1Ezt00X8OEZ
 b8UBkSeb
 X2NftuHPwJ+KV0Za9ztuLzLq2E9JRbTa/kS5qztBi83fhaz6UEY88Ffv4ueF0SDnLxYaoyokAMUqn2ofeyBduOLdmydGabhzpgg0RpQv8IQLntAw0HcwT+fE8YgcOyxA+Dv/jQZ9NPZSeGzVkm7vzatOgA7GkEROFPwOqj7RHFCvHG8N7r39i5ShaWZVtbY+WJ4VJcyujRa96KTY8Ssj0tuS0IyU5gSApka7/BHnY1SrfQfW474Lt9aDU868pNZCvMYXZ+diI9bxj9PoZV+shH7jkR2h4Hs3wQ/qYPra47CFBHeDYVCOyW6bgiYabuVgoMnLdAZ5QMfbIEF8A66223GmVe2vMFjxmftuWjWvarkaiCji483/5OUIth3pPell0J210b/meLzGnwGdWzZ+vrcKaXAA3yrC7adM61N+3/VmLE8uZVE1fZ5TMe+R3lbkBmjpY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 12:16=E2=80=AFAM Michal Hocko <mhocko@suse.com> wro=
te:
>
> On Fri 24-04-26 12:15:18, Minchan Kim wrote:
> > On Fri, Apr 24, 2026 at 09:57:16AM +0200, David Hildenbrand (Arm) wrote=
:
> > > On 4/24/26 09:51, Michal Hocko wrote:
> > > > On Tue 21-04-26 16:02:38, Minchan Kim wrote:
> > > >> For the process_mrelease reclaim, skip LRU handling for exclusive
> > > >> file-backed folios since they will be freed soon so pointless
> > > >> to move around in the LRU.
> > > >>
> > > >> This avoids costly LRU movement which accounts for a significant p=
ortion
> > > >> of the time during unmap_page_range.
> > > >>
> > > >> -   91.31%     0.00%  mmap_exit_test   [kernel.kallsyms]  [.] exit=
_mm
> > > >>      exit_mm
> > > >>      __mmput
> > > >>      exit_mmap
> > > >>      unmap_vmas
> > > >>    - unmap_page_range
> > > >>       - 55.75% folio_mark_accessed
> > > >>          + 48.79% __folio_batch_add_and_move
> > > >>            4.23% workingset_activation
> > > >>       + 12.94% folio_remove_rmap_ptes
> > > >>       + 9.86% page_table_check_clear
> > > >>       + 3.34% tlb_flush_mmu
> > > >>         1.06% __page_table_check_pte_clear
> > > >>
> > > >> Signed-off-by: Minchan Kim <minchan@kernel.org>
> > > >
> > > > As pointed out in the previous version of the patch. I really disli=
ke
> > > > this to be mrelease or OOM specific. Behavior. You do not explain w=
hy
> > > > this needs to be this way, except for the performance reasons. My m=
ain
> > > > question is still unanswered (and NAK before this is sorted out). W=
hy
> > > > this cannot be applied in general for _any_ exiting task. As you ar=
gue
> > > > the memory will just likely go away so why to bother?
> > >
> > > I think there was a lengthy discussion involving Johannes from a prev=
ious series.
> > >
> > > That should be linked here indeed.
> >
> > How about this?
> >
> >     mm: process_mrelease: skip LRU movement for exclusive file folios
> >
> >     During process_mrelease() or OOM reaping, unmapping file-backed fol=
ios
> >     spends a significant portion of CPU time in folio_mark_accessed() t=
o
> >     maintain accurate LRU state (~55% of unmap time as shown in the pro=
file
> >     below).
> >
> >     This patch skips LRU handling for exclusive file-backed folios duri=
ng
> >     such emergency memory reclaim.
> >
> >     One might ask why this optimization shouldn't be applied to any exi=
ting
> >     task in general. The reason is that for a normal, orderly exit or j=
ust
> >     pure kill, it is worth paying the CPU cost to preserve the active s=
tate
> >     of clean file folios in case they are reused soon. Preserving cache=
 hits
> >     is beneficial for overall system performance.
>
> This is a statement rather than an explanation. Why is it worth paying
> the cost? What is different here?
>
> >     However, process_mrelease() and OOM reaping are emergency operation=
s
> >     triggered under extreme memory pressure. In these scenarios, the hi=
ghest
> >     priority is to recover memory as quickly as possible to avoid furth=
er
> >     kills or system jank. Spending half of the unmap time on LRU mainte=
nance
> >     for pages belonging to a victim process is a bad trade-off. If spee=
ding up
> >     the victim's reclaim by avoiding LRU movement and evicting cache ne=
gatively
> >     affects the workflow (due to immediate restart), it implies a sub-o=
ptimal
> >     kill target selection by the userspace policy (e.g., LMKD), rather =
than
> >     a problem in this expedited APIs.
>
> Your change effectively boils down to break aging for exclusively mapped
> file pages when those pages should have been activated. All that because
> the activation has some (batched) overhead. You argue that the overhead
> is not a good trade-off for OOM path because those pages are exclusive
> to the process and therefore they will go away after the task exits.

I think Minchan's argument is that mm reaping occurs only in special
conditions (under high memory pressure) and for a very specific reason
(to free up memory and prevent system memory starvation). Therefore
priority in such conditions should shift towards more aggressive
memory reclaim instead of normal aging. I can see both his point and a
counter-argument that this might cause more refaults in some cases.
FWIW, in my personal experience working with Android, extra refaults
when we have free memory is better than inefficient reclaim during
memory pressure, but I'm not sure that's universally true.

> The same line of argument applies to task exiting normally too. Task
> exit it not the most hot path but certainly something noticeable,
> especially so for huge tasks.
>
> All that being said, you really need to focus why breaking the aging is
> a worth optimization. Keep in mind that while the page might be
> exlusively mapped it could still be actively consumed from the page
> cache and breaking the aging could lead to refaults.
> --
> Michal Hocko
> SUSE Labs

