Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94BC7CA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 09:32:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC3438E0012; Wed, 17 Sep 2025 05:32:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D73568E0001; Wed, 17 Sep 2025 05:32:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C624A8E0012; Wed, 17 Sep 2025 05:32:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AB35C8E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 05:32:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 47F591403EE
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 09:32:33 +0000 (UTC)
X-FDA: 83898226986.08.AFE86D7
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5043840008
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 09:32:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SGeajjwZ;
	spf=pass (imf17.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758101551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E6Y38ok0A2SbvnTsYmSUxqDrhx49IHHabOYZyBDsP60=;
	b=WiRgdPDDKSswrdkhuVEdn2L+SzeivUsBiGNVU9P/gePp4bFDy/a2SDHYqVz6KmZRJ0t1Je
	vlUqE4wKJYtsvmp13unPJi02igN/Kl9Qzlhwt9iUiJ/VYLxSPs468CiInhcbb5GICXzb3G
	lOU0gCMCWDd1VCoMsfMO/OqDKfANwt4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SGeajjwZ;
	spf=pass (imf17.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758101551; a=rsa-sha256;
	cv=none;
	b=2BE0RYqRZ49mK+f9J7eL89p4WF2WIXit95T/I/TYOuYg6SUOp83JaJElk5DfMlYWHdvwEN
	kby6OePsMRbvHR/fpL2jrFtR9wB4tMk1oxhdlLyZ07enZKtOdVK1tqONURMNLriowwjH+9
	hwJMwqCTXCFsQrJZ8di1vGrqq974ELI=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-62f1987d547so4560693a12.2
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 02:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758101550; x=1758706350; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E6Y38ok0A2SbvnTsYmSUxqDrhx49IHHabOYZyBDsP60=;
        b=SGeajjwZ6rXYHT2BSAOtvXVf+kCmswxamQNQnT4sENAEuDc56zYTkwNOpeNTpkKcWK
         SdU/YJTcPXvYuYGsm/K4GMGN75eWkvEH5eF6w17YCKhxDDXWQ8HRQzMS2ie/a59DXzuP
         J++fJ+x836HocqEsW42HqZU/HmJgK2/Btf9B9FEbPLkHlpKRzUHAhxADrDPHKt1o0vZa
         gbhmLOhW9r/Gw0teotZSljl8jiAFicyQWM6v2PPLMvjFnvnYz1Vuz2Qqn/oXerdI5mlt
         Gt8bQ0rX408ch15oqBSc39XkPSPJG110JkZX6ZoU4zkzSCqNww+BG2V08glzdjHBzWQg
         z7pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758101550; x=1758706350;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E6Y38ok0A2SbvnTsYmSUxqDrhx49IHHabOYZyBDsP60=;
        b=Z6p1d8wnDEIYrFfd5MnQuGzTkQaDzKloPkkUGLmOejIsFob3xoYi2r5eQ6PP8cMZdm
         45L1dXOoFEULE3OZloRcYJiboGaIAGK8NTxiXI1uXUVy+Y040cttRNxz/7H+IBfrFeXS
         GXwpJD//5VpVzJiM2Awi3Q49N0UtD7g1l/ZYkf5baM5pGbNUtOKiFeJH1ALGNCfMxHIB
         ChZpLBEq9BNu7WdzNGsYlyzlMwut69wofitS/oAf4xKlhWgzWnPSgeyzdEgTumhc9ff2
         2b292MQS/iPe6s0Zd13z2lvjdtusEJUjOsDIsmCWzKh4YLMZ3n0BSATnlRrfYL9/EnCG
         SC8g==
X-Forwarded-Encrypted: i=1; AJvYcCV+jsrDoZXXf1z3d1Eo6ju9IjJX5HrDz8cwRCfQS/5F45ysDomHJswmyjnfagyLoAAm2Cvc3+ZdxA==@kvack.org
X-Gm-Message-State: AOJu0Yyj7W7coS2BJJYfKr7kKy1RV/X/wSt4HZndgE0mMw5ohBnMNL26
	hrJgWDRKBr2ka7v0QtJxVkSgwAvSF+nkgJYrg72BVXbvxpmTXFoHSeKJJgQ1tl+AZVtpGNBODov
	QbgscNS/S/IlAdjqy+p4rJddqgiG3YBk=
X-Gm-Gg: ASbGnctk7pkgioahuDD0B/h5Niz7EWtTjGTHmzT2+foKS5yOpZyzyLHIaFxdy8gR8ei
	vsl65DdGUDlRUXfGmdl16WoiSVOgZQ17Zed7Z2n7S3CpXU3et29rqipm3MqzI3AyBtqAr/GQzUv
	b2Hn1C52Kw1dWOD3BeKWSOVcF5rnYg6DF+ZvGmym+NAI53oTFRvKWOOzNTE3pxOMlhA520ym566
	qD6llb50SzhVBzyEYexSBJBXgYMcJliJHsveGM=
X-Google-Smtp-Source: AGHT+IHZ61/20jk8xhbdyrEPlURkGzCcG7PoE5PC5oyd/JsxSNese3df+9o8L4SYyy0q9/Yanutk8Dmi6yRoW8WpYyg=
X-Received: by 2002:a17:907:2d1f:b0:b07:653d:56a8 with SMTP id
 a640c23a62f3a-b1bb086da5amr172521666b.5.1758101549373; Wed, 17 Sep 2025
 02:32:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
 <4z3imll6zbzwqcyfl225xn3rc4mev6ppjnx5itmvznj2yormug@utk6twdablj3>
 <CAKPOu+--m8eppmF5+fofG=AKAMu5K_meF44UH4XiL8V3_X_rJg@mail.gmail.com>
 <CAGudoHEqNYWMqDiogc9Q_s9QMQHB6Rm_1dUzcC7B0GFBrqS=1g@mail.gmail.com> <CAKPOu+_B=0G-csXEw2OshD6ZJm0+Ex9dRNf6bHpVuQFgBB7-Zw@mail.gmail.com>
In-Reply-To: <CAKPOu+_B=0G-csXEw2OshD6ZJm0+Ex9dRNf6bHpVuQFgBB7-Zw@mail.gmail.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 17 Sep 2025 11:32:16 +0200
X-Gm-Features: AS18NWChZehX_GB5YyUMrAb6NwperYSiuZ6bfFJLrhovC7_ZskfwcSsI8-Tvro0
Message-ID: <CAGudoHFNKkjjqR=JYQdFZ2cBgSnBsSnzX6njwDtmj40ZDxJ+jg@mail.gmail.com>
Subject: Re: Need advice with iput() deadlock during writeback
To: Max Kellermann <max.kellermann@ionos.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5043840008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 45mifo9x3g9kprbwsbptdtxbjf1po4kx
X-HE-Tag: 1758101551-44668
X-HE-Meta: U2FsdGVkX1/v8zwVbG4EzTKVGeIkWTKxdGJih2PG1gYOcTNkYxIx7lqkfwcYo/8L91kqM5Ur+psaNE+NIBVFw6gHPyYOfKtkq1WU07XGV8zEKih+lL5OnqtErUeePGVtQJP2g5sGfQrDVcrHMZugcgS3+S3wwhUG0npcOSzbv2f/jWxJrKQvxl5UUJnEO7FKeQkplZG0g79EmYu//HxXwk5qw5fvAQ11g3HHBINzCfnrAHKg2DgPh8Wypu3hJsTnTYWVnV9anpcNPxLrg9Mog3I19dI5gtSx94za+yv+htS94A7W4SRb9b4mi7UvxIVN1MEUM07P/IZ7R0PjXZRKHo3CidHoorWQcTpMhayHEKV4nEDFzcIQYLjpEFRBKRMsWs5rH54rsJvHMCgxTfIPAtcMp52iYRuwycnNcXzi2BrYSsIg4pxMWnUn6/ul0swh3BoLfunI8LRsYiwtcTYhUEegAVaF7t7YjCgESzAA4xXo/vKMUSVNLp8y187UgH9hI0MKEadMJuWFchr2hy54KemAXFvIDQ+NSPQv5o8kNauL8menNRrBVZ/TSMyOmWi4oeZrnDwmXYBpBm9GoB/QBVMATFKTsxhvLaCuCzGodPz9lipXwoAcjc5vg1f3WJlpUtSUnrKUu6acuuY+cz/oP/bEC5F2v0C55Bg3azcVYRXey3ZTJW26AB4NBMDz1y/KhSxhGncl7sirLEd1ZH+6wiOSrg/S11vNiGvqrlXIUogRrpgaeyGEaMWja8K1dzmRnY9/Gsb1NsEEffHI+6G0e5mM02pdw1IUNHUFqfNBTKWGiNca+RpOstdzGpEkaFA3scCzfkthYUgZo6dMFto4g6uaQ/V0ZgcRXz0WHBmYW/OwltvCW4dS0w5VKWN3M0O0vOfmm7cwxkHi4J5YP4KOXJnAYI7KVhBRV6Hr2BpihGl/5t0Dhr0dzOwFtzp9GHS6bbqvo6c9axAODFMwXzg
 XpBeya6H
 wcdgH/VCxixEarLNKMA8nenKCaysJbCmcSAT52UiKIDQQXkW4IMTuxJXdglvideVgtdpx0n0EsofIpiHIb3kqETjCD1FUgOlUpd9cMjfCxIj86pxscL0KxsgpkIjKrDtMTmitiVBgg6ec6rE30Y7v+glzzDcI5FZ8kEK2lv2bI0GPy5hYSle0zpvVO/DdceaOSdueLWzubS9CQvdGqCumNe75PBvOkAdR14wq/END7Ufo3bmbzsFHqOFJ9qC+t6vlRzDtFB2NjvPLFdWlthR8TKFBdJ6g30oOfB9ZUkc4oIJMZwTfzxsCpUFaKsK68KeCeJQYul5Jo1UER2lAlv7vwp4bef7hRheTQ16qMwy8Qa6dh+jcAw74/tcl3M2NjfXlqBqwL7/wJL7ajVqGxxKUd41Fcg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 11:20=E2=80=AFAM Max Kellermann
<max.kellermann@ionos.com> wrote:
>
> On Wed, Sep 17, 2025 at 10:59=E2=80=AFAM Mateusz Guzik <mjguzik@gmail.com=
> wrote:
> > > My idea was something like iput_safe() and that function would defer
> > > the actual iput() call if the reference counter is 1 (i.e. the caller
> > > is holding the last reference).
> > >
> >
> > That's the same as my proposal.
>
> The real difference (aside from naming) is that I wanted to change
> only callers in unsafe contexts to the new function. But I guess most
> people calling iput() are not aware of its dangers and if we look
> closer, more existing bugs may be revealed.
>

I noted iput() handling this is a possibility, but also that it would
be best avoided.

We are in agreement here mate.

> > Note  that vast majority of real-world calls to iput already come with
> > a count of 1, but it may be this is not true for ceph.
>
> Not my experience - I traced iput() and found that this was very rare
> - because the dcache is almost always holding a reference and inodes
> are only ever evicted if the dcache decides to drop them.
>

Most of the calls I had seen are from dcache. ;-)

> > I suspect the best short-term fix is to implement ceph-private async
> > iput with linkage coming from struct ceph_inode_info or whatever other
> > struct applicable.
>
> I had already started writing exactly this, very similar to your
> sketch. That's what I'm going to finish now - and it will produce a
> patch that will hopefully be appropriate for a stable backport. This
> Ceph deadlock bug appears to affect all Linux versions.
>

Sounds like a plan. After the inode_state_ accessor thing is sorted
out I'll add the diagnostics to catch unsafe iput() use.

So I had a look at inode layout with pahole and there is a pluggable
8-byte hole in it.

llist takes 8 bytes, so it can just fit right in without growing the
struct above what it is now.

Unfortunately task_work is 16 bytes, so embedding that sucker would
grow the struct but that's perhaps tolerable. Not my call.

If making sure to postpone the last unref there is no way to union
this with anything that I can see as the inode must remain safe to use
-- someone could have picked it up.

Maybe something could be figured out if iput_async already unrefs, but
this would require fuckery with flags to make sure nobody messes with
the inode.

> >         if (likely(!in_interrupt() && !(task->flags & PF_KTHREAD))) {
> >                 init_task_work(&ci->async_task_work, __ceph_iput_async)=
;
> >                 if (!task_work_add(task, &ci->async_task_work, TWA_RESU=
ME))
> >                         return;
> >         }
>
> This part isn't useful for inodes, is it? I suppose this code exists
> in fput() only to guarantee that all file handles are really closed
> before returning to userspace, right? And we don't need that for
> inodes?
>

No, the fput thing is to avoid a problem of a similar nature. As
*final* fput can start taking arbitrary locks, go to sleep or use a
lot of stack, it is woefully unsafe to be called from arbitrary
places. The current machinery guarantees anything other than an atomic
decrement is postponed to syscall boundary or a task queue if the
former is not possible so that these are not a factor.

Postponing to syscall boundary as opposed to blindly queueing up makes
the "right" thread do the work.

