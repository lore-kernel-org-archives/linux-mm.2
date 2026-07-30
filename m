Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 720F4C5516D
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 21:04:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AB376B007B; Thu, 30 Jul 2026 17:04:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65C606B008A; Thu, 30 Jul 2026 17:04:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54B986B008C; Thu, 30 Jul 2026 17:04:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 26D1A6B007B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 17:04:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A27F71A0208
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 21:04:42 +0000 (UTC)
X-FDA: 85046672004.26.B237E9D
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf29.hostedemail.com (Postfix) with ESMTP id BCE3A120010
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 21:04:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="wKNv+/My";
	spf=pass (imf29.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785445480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DVc5Mxdn0Ce+KRqCagnbFXM3Idv5WP8P1kZ/ct4kSHA=;
	b=Q2LjaRPgZ82u3pFx2GBR19JV1Fa/Jg2aTx6KDKJ27QYBMKkYh3ouqY6X0XuEKt+zZiV8m7
	MNRSnyAgyF23OS4pRbdJvE1GZEXSPmMNheLDzsaxXEXGIbC9yNzXMpiMx8Rnfv60t40Weg
	2DdTA4oxwMBvqANZB9SV0NdxRx6xLhE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785445480;
	b=NrI+kM0K6STot9WaP6ckoGDY2qJFSBBzR7s64vgr1Inu8EgI2TMylqCR5k41wScFRF+aYq
	QHQ57RSPg3SyVERyy/16hL53dHNIGsAexb0hW9jL9Acgx2/2Ud9kPrG6PBmDozmZscsbpm
	IJ1qKWbAqFs1P/9Kt9fS+4wpI6zVqTI=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="wKNv+/My";
	spf=pass (imf29.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cede6375caso31815ad.0
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:04:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785445479; cv=none;
        d=google.com; s=arc-20260327;
        b=bYBocBoUFO2lqax7fCbpqY2zv+tUnpfue32jFvlMFJw9ssNS7btS+aH08EsAT1iHwC
         tuTbIA8eACJNnI/FGnBW+9vQQcP3rsZPucEHp+wA9xyPZJ/wdRRBcapheyjavBSRix0U
         RNL7xJY8XfhHwrIYA+hL8OcfiVbCjzWMXhN4Bxqr+HZ6Pia/D5rV8B3E2WnM0SGDghT/
         3Oi6KRnPwLvDTp/TUZ68p7RBXXipFQwaWJ0xCM0rtNOx3uZPTR2VNyCgx02ltBS56bs4
         Bcwfbo4A8fZEBP1ADI53YqOJ4BEpvBDt//qEZJXLpmb3/xzDNQHzjyxwpfMBNz8dwUZK
         1A2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DVc5Mxdn0Ce+KRqCagnbFXM3Idv5WP8P1kZ/ct4kSHA=;
        fh=mQwdPqvjBueA3ehlGgYopD1nI/CPPVFpz1SsDbBzpGQ=;
        b=QOK4Ia559rVBULZpfRpWfIB4JIiXvIzhzn3DeOfo5ey+NW/wG/+Pa0kRTsWDxapVBg
         Qc5Tx45WD7Q38I2dqsMBTzvtV2pN3U4sqpKHijG0wU4QHp+OnHlrqpgqGWxFqMYDyJLR
         Ydxe4fPUYPJQ0xK1ZgpUN8srMILXxFFKHzqEu/4y4r/GkaTDyOGc2Qb+p/MAJ26o5jDX
         oN8Cz4zESWrNzaWgZq2efM2BIzW2JVZ0V2EbZkCCJSmSE3cFwVkkdNSObQ8n7upyZZpQ
         75frGD41GmCkS1akbwz1X+W4xmHXLiBZY2daz9x23Ge3+fW2kU9xQhkZP6lLiW4yUAaz
         JPrg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785445479; x=1786050279; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DVc5Mxdn0Ce+KRqCagnbFXM3Idv5WP8P1kZ/ct4kSHA=;
        b=wKNv+/MyIh0H1AeADQ1XU6Xp8LEqszzd4tqTIGOzqoVAxLe46yPpMGhnwdS7Ypv/T5
         E6jHiVr+3C1MM5NmM6j7+gollzreiekWu85Vu5a6oQKDsvHfV8yGyWa1YsVhmAzx/gzP
         sUWrmxHGG8XYM8gdOjDJCjD9otvkh9hg1J4FE+Z8rhzhRIonolQW80DhvPlLuXyyfvWY
         ueaYUuaAD4JbgL6yo2c9t2jwm4KcElp1xax1Pp9rKyMRx89K6I+X/IUUxfNoK3e8LOnG
         B0sRdxp+zTPhlbnF3yxP6b/XvbrgnjBUXUh6ejm9ohldlXYDHSl2FASf1CUDu3G2+O9G
         wa2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785445479; x=1786050279;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DVc5Mxdn0Ce+KRqCagnbFXM3Idv5WP8P1kZ/ct4kSHA=;
        b=dCGMw/vm4qeSUQekKInxY0f5QCsv0lVirj77suQeJwRlD63nc+0VhhY+2+zoJDb84d
         SIti9IS4/Qg6Kfdy5ALtLSk5SsVCsw/LiJF81buCLuotwAlFpb7xRS95yS+BQeV4cenT
         jFmYrtBpLNjQKf7NO7q02/07Zqa7Ag3ozGXCY45dZGH1tHDuqcLUEuAzAT6LrWbuDBvT
         MBBFhFaZrOWqyrOeFyX8AitnSlz7jq57aG37WOFN7jwwzKaFEJrIrsBTsE3YFnN2TUpG
         /Vh9n66jiShwhkxk3spvAjFcdpU8F7XfzxcOV+k4V6Va5UHDFV5zh6Gy1K0JP0VbYny/
         pKQg==
X-Forwarded-Encrypted: i=1; AHgh+Rp7NxOVb2CyXcScfbf6GfawB/pIldX+8A10Jazp41b0B5xcO+jaW+9QUGPhIoa7Ugau9qr465eeJw==@kvack.org
X-Gm-Message-State: AOJu0YxgVd7jEPdJMYCJ1xvMBlS5WjciPE5blKyJ5uSWFlCrS9a3od7x
	LzZH/oWf+b7lnoKa0UCp5MBX6lXvs98gS5Cc1LKICC+Ub+gq8jSsz5ISw1ALEIYzYKRhYXNPbHS
	aSenCqvxvJbyGzmQUpvFhhsGIyVft5aWd49FKgaZO
X-Gm-Gg: AR+sD10uKRyHT2pHq7DQ4mbBH0h3M3g0z3y9/6Ofc7c2fOYymw2smNs+R4Od+hkdpkD
	ImXP4eS6kv6YPqyxh+xZey5hQ4pt8ZOHrO4xvM+OGc3f+Ne8mbg5MMf6eLMAU9tIzlg1wBumdXj
	mUJVGqEL5HESnNclks5Ya/Ihr3us3X9HVURjHgKBVkcLmmd3f5SNEfef9NKGSu88fnqNIvbNA0j
	u/MriKJfNg76ppy5hS60As+6O+Qih9SwoszcZcf7x7dg6B7ea2et31OWX8eNIzCf2sUgJTCyPTG
	8+ai52NBSdpJFMZHW1RP8Lo5MLOazSQUt7lDX5fEhCvMPM1d8xQ6dv0ziz1m+R6nHC8oonm/oz4
	StyYzvqffww==
X-Received: by 2002:a17:903:1a8d:b0:2c9:bd54:cf with SMTP id
 d9443c01a7336-2d041128e10mr3787595ad.4.1785445478755; Thu, 30 Jul 2026
 14:04:38 -0700 (PDT)
MIME-Version: 1.0
References: <2614a3a2f5cb11b63e3cacdcc8ab20a0fe7ae972.1785365110.git.abhishekbapat@google.com>
 <729c578c-e5a3-4351-b07b-469f79c26b0d@linux.dev> <CAL41Mv7_CjWTahWO9sfDZkVKZKEU56j9Sk+xMWN7zbJfRH5MSA@mail.gmail.com>
 <CAJuCfpH3W-gOa6r=2jyw6Ckh_HjAAtdF+0LA2Hu8FkwNe1TM+Q@mail.gmail.com>
In-Reply-To: <CAJuCfpH3W-gOa6r=2jyw6Ckh_HjAAtdF+0LA2Hu8FkwNe1TM+Q@mail.gmail.com>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Thu, 30 Jul 2026 14:04:25 -0700
X-Gm-Features: AUfX_mwbH53ZuHzeqCsp86EnpqerPYcLXlKZQ2UP6lVY6hiJ-tN8orw_M4epYjU
Message-ID: <CAL41Mv5iYn1Y7X+yb7dcUVTgMac044Ym-RHv93eun-9WXhye5A@mail.gmail.com>
Subject: Re: [PATCH] alloc_tag: expose profiling and compression states in /proc/allocinfo
To: Suren Baghdasaryan <surenb@google.com>
Cc: Hao Ge <hao.ge@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BCE3A120010
X-Stat-Signature: nk7eoy7y7q6kwgapw9eja5u1t9s31nfp
X-HE-Tag: 1785445480-436066
X-HE-Meta: U2FsdGVkX195Ojo3BAolR8Tg0X9vcUPU001uipztRPVwq/VQAzm2frBJD/p/HvtKpp4flgiOhLbP53LsMx1OO3W9l88LYfRYlw6XxwaXjWbESSHPjdUM2nUXOp4nV91LMwVEJVjkWRnfvR5HmKuzYN4JVsjeO08qFn/z+PdAlDqfgmAYkNG9bvyCknxVtuRkic3GGYkzWRWLwaOCvdP66k2rbcJf1xpOIMHtM3C2t7BrjvpRQo2t335ug8OPQJfHbUhiHYcYRyZ7kPLYtu03r4Zao8omRU6v3+e4h9XlLAhSvE7nnkCwaWV6zfhjHLRNdMQKDqPAEnkwrVnlhfFlqRqiYSGWUgEoR0epbjOH/Mz2D/mqwxbInUmKM8mt1PvDzBnIQ6uJA1EZXx0ZmGctDEaRo/sC0atTCSYRSiIUaljO6KXkw1gvdeW0uS0Vqb2y7ZeVBZvY2vCtWRaDP3mkdnhWSi9BQtc23sHxWJqEzw/qHM7oyw33mnJCvERqzIQdcwxQl2itrqwXZtJbaJ/qwLJVQnZuBwpFlYEoBBD7J01w4Ms9Z7aCcM7BK+Mfxyfz8j7vDQIC3q+ie+acrSMPH3XvbKrFv6gZUzF8s8YiYeethf5cLNEHGv+7hPAnqgbPtguZPeKGFTTzppIM44V+OvMjfrBq1ABVl5/LKNwrBi6swEllT93DNyxuqGUKwy/OEVI2Er6XJ/UJNzMbIVhUt8Urtl7RWttPtOcqHvAgHh2rVXIepmtOPSYteS+Mw0slxg+E7tlcDHxJ2MTWixEnWZVjeRK8nRG2tNNEsAkVmL5cj76AtfjFvtyJgwZpo3uyrnyM/ZC0w9+S/twjChwSKySVMNZdJxQYDDL97HP0ZYfC/el0v1zmc+PECXkBWrH1Ao3iD2A+8XGWahymbj+0lkJ9vUSdVy9pWNdbapZI0/NDbDcqiYvKcXclZblDjMCjy93gg43yVo5XiWvuagj
 AnS8wUMC
 Vd3dGu3M6MAJo5Q5RhofJ9G/m/VdDogiz2uK/RivhlstDwBlKnHO3W7KBtXLKyKgO0IUgN0niAPQ0jbGhVtNpeZtthfRV6n9UdukKm3xvN39a0onGfCCQZuUvfnIWRKRyzaB3s1UcSXR4VwduvZgR5mRrIW02jj/wrLNvR1poD4PIeKS3DDDACLX30TQfM/M8LtV2u92yp/WFeu5yIcyI7BxOIX85tJna/hVukrd8oxTrALhop4/eIZZN/Ufm/mIc984a3HJSI3KPlepFdLwvRZkMquvLdqYkkOOXnj9w0LOguqyqgCgRzZY26A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 12:49=E2=80=AFPM Suren Baghdasaryan <surenb@google.=
com> wrote:
>
> On Thu, Jul 30, 2026 at 10:57=E2=80=AFAM Abhishek Bapat
> <abhishekbapat@google.com> wrote:
> >
> > Hi Hao,
> >
> > Thanks for your review, however, I'd like to disagree with your
> > points. Replies in line:
> >
> > On Wed, Jul 29, 2026 at 7:23=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote=
:
> > >
> > > Hi Abhishek
> > >
> > >
> > > Thanks for your patch.
> > >
> > >
> > > On 2026/7/30 06:49, Abhishek Bapat wrote:
> > > > Currently, userspace has limited visibility into the exact active
> > > > runtime state of memory allocation profiling and its page extension
> > > > compression ('sysctl.vm.mem_profiling=3D{0|1|never}[,compressed]').
> > > >
> > > > While reading the sysctl provides basic on/off status, it is curren=
tly
> > > > impossible for userspace to natively determine whether page-tag
> > > > compression was successfully enabled without scraping dmesg boot lo=
gs.
> > > > Furthermore, since /proc/allocinfo remains in the procfs filesystem=
 even
> > > > after profiling is dynamically disabled at runtime, simply checking=
 for
> > > > the file's presence does not reliably indicate if the allocation
> > > > tracking hooks are actively running.
> > > >
> > > > Resolve this ambiguity by appending the active state directly into =
the
> > > > header of /proc/allocinfo.
> > >
> > >
> > > It's not obvious to me why userspace would need this state.
> > >
> > >
> > > Suppose userspace reads mem_alloc_profiling_enabled as disabled, then
> > > the profiling
> > >
> > > gets enabled later. All allocations generated during that intermediat=
e
> > > window are lost.
> > >
> > > When users later cat /proc/allocinfo and see the enabled state, will
> > > they mistakenly take
> > >
> > > the output as a complete, accurate record?
> > >
> >
> > Currently, userspace has no mechanism to determine the actual internal
> > state of mem_alloc_profiling, meaning users are forced to make
> > assumptions regardless.
> >
> > By exposing the explicit state, this patch allows userspace to query
> > and validate the state concretely rather than guessing. If the state
> > changes, userspace can immediately detect this and react accordingly
> > (for instance by invalidating and / or refreshing its view). Rather
> > than introducing unsafe assumptions, this brings a clear, testable and
> > net-positive improvement over the current opaque behaviour.
> >
> > >
> > > I'm also unclear what userspace would do with the compression state;
> > >
> > > this is just an internal implementation detail of memory profiling.
> > >
> > > Put another way, personally I'd prefer /proc/allocinfo to stay lean a=
nd
> > >
> > > avoid exposing too many internal implementation details to userspace.
> > >
> > > Unless users intend to dig deep into how memory profiling works, thes=
e
> > > extra details
> > >
> > > will likely only confuse them =E2=80=94 most don't care about interna=
ls at all.
> > >
> > > It's similar to how we use APIs: we only care about what an API achie=
ves,
> > >
> > > not its underlying implementation.
> > >
> > >
> > > Could you share the concrete use cases for exposing these states to
> > > userspace?
> > >
> > In large scale production environments (such as our deployments at
> > Google), we can only afford to run memory allocation profiling when
> > compression is enabled, as the overhead of running with compression
> > disabled is too high for production workloads.
> >
> > Currently, there is no way to write an automated regression test to
> > validate that compression is active. Exposing this configuration state
> > in /proc/allocinfo provides a clean, concrete interface to write
> > regression tests that verify and enforce this constraint in
> > production.
> >
> > Hope this helps clarify the intent behind these changes.
>
> Hi Folks,
> Thinking about these states, I tend to agree with Hao that compression
> state is somewhat internal information that most users should not care
> about. So, adding that state into /proc/allocinfo, which contains the
> data user cares about does not seem ideal. Maybe we can expose that
> via some other interface, like /proc/sys/vm/ or debugfs?
> I also just realized that profiling enabled state can be read from
> /proc/sys/vm/mem_profiling, so we don't really need anything extra for
> it. Would you agree?
> Thanks,
> Suren.
>
>
Hi Suren,

Sure, if there's consensus that /proc/allocinfo is not the right
place, I could share a v2 patch that instead exposes a read-only file
called something like /proc/sys/vm/mem_profiling_compressed to expose
the value of the compressed boolean. Does that work?

Thanks,
Abhishek.

>
>
> >
> > Thanks,
> > Abhishek.
> >
> > >
> > > Thanks
> > >
> > > Best Regards
> > >
> > > Hao
> > >
> > >
> > > > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > > > ---
> > > >   mm/alloc_tag.c | 6 +++++-
> > > >   1 file changed, 5 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> > > > index 52aece27b00e..89ec2c6ce57a 100644
> > > > --- a/mm/alloc_tag.c
> > > > +++ b/mm/alloc_tag.c
> > > > @@ -108,7 +108,11 @@ static void allocinfo_stop(struct seq_file *m,=
 void *arg)
> > > >   static void print_allocinfo_header(struct seq_buf *buf)
> > > >   {
> > > >       /* Output format version, so we can change it. */
> > > > -     seq_buf_printf(buf, "allocinfo - version: 2.0\n");
> > > > +     seq_buf_printf(buf, "allocinfo - version: 2.1\n");
> > > > +     seq_buf_printf(buf, "# Profiling: %s\n",
> > > > +                    mem_alloc_profiling_enabled() ? "Enabled" : "D=
isabled");
> > > > +     seq_buf_printf(buf, "# Compression: %s\n",
> > > > +                    static_key_enabled(&mem_profiling_compressed) =
? "Enabled" : "Disabled");
> > > >       seq_buf_printf(buf, "#     <size>  <calls> <tag info>\n");
> > > >   }
> > > >
> > > >
> > > > base-commit: c73b725a57f276a3702ca213bde78fca029bc619

