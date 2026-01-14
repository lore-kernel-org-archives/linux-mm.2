Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42CBDD39005
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 18:24:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 640786B0088; Wed, 14 Jan 2026 13:24:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60E0E6B0089; Wed, 14 Jan 2026 13:24:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EFEA6B008A; Wed, 14 Jan 2026 13:24:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3D2BB6B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:24:18 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C58A0BA2DC
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 18:24:17 +0000 (UTC)
X-FDA: 84331394154.15.D8B2079
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id AFF901A0011
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 18:24:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CZD8MyUp;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of jannh@google.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768415055; a=rsa-sha256;
	cv=pass;
	b=phcGPDSe1sApYHyGbvE+KnOC9BxOEBAHETuiO8017hsoICFYueufUOI2swh+9ygygoY8CZ
	/PK8gqy0cUUWaIUknUMppHza+9qP4jJrn1FzgnMJXLvgBfKNJBkSYPQTVCHBwBJFsZpgVl
	lzOJpxtX+rf0RsdnKtBiMQVt/NWpBA4=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CZD8MyUp;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of jannh@google.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768415055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dfg4XYGk5XyeYtVfQ6Zn1brUb+xWMxA29+l07+I3qE4=;
	b=SBF2xeoIzTfhZyzrx+9MfWDXYJOQbeDw+rOYA1HJJmgwewWNtuZNnCuc+N74c2pSFyYoI7
	XEbP5rA3QhnjJsGq9cjuI3Mw9Ec8jWx6PQvqgncykKdhrDsVy+PoLjS+MTKvSo6ribohil
	ZLqx7jvG/6U61bnZL6yWieQG0fJ1O9U=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-652fe3bf65aso664a12.1
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 10:24:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768415054; cv=none;
        d=google.com; s=arc-20240605;
        b=NIJclmyh6nUV3f+P0VSvCakCZsgTstf4Ir7CgQOGcH6G0SQXPNPt2lflihMqOPI69k
         GCgpU/yquoviiBfXK6w/MFGRH+6kyCjVJKfi+NCEzv2C9uRQ3noCqOCBH4r6GoWbGKqG
         ycZ9HEHpyyAQflxFBlYT2U3HgfHHr1hOVaKrzv7j+lmjOVDuudZvDJH6pXJRiDWBvfZf
         OwjonivWaT3xA3yH8hgag4g9pn3BWsfh6fQ1Yp2tIJ6nLh/ZeOZOx3SKP+TV7MAtTcjg
         jVEsLpV1H81IaobpAru73vqIHS9SUlNDLdNb40R6I4sZeRI/zPCuXt0gGKzlW6jo1UCK
         j6zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Dfg4XYGk5XyeYtVfQ6Zn1brUb+xWMxA29+l07+I3qE4=;
        fh=b2UpycgwDA8592yl/RgqlVGgKaWqaLo4iLZ+XpjT59A=;
        b=LqXH4jDo1WfxhHeRS906C+i58RnzPuBExtFGrwoBcgatn6HF3y/3OiMzK5QP0GZtwk
         7duILGqCUGXSq3TvWFXDXJjHF9SIHk1dsT9wM3eOSupfRV+VH4+QOMGQJpnFcdduDhLq
         7O4CVWs7I16sPGfJIrnDpDVoV+HSiDJ7i9wFhjYyMIs0NvrSKEvB12CxLnwdmWXCfi3j
         TmpVizZj9hegfBoLk5MDURpwtZE3l0bYFEx73xipcNNYhls1P3RRs5LQwsdmv+5rGiKr
         9WpWL3MUsEv/lFH6ZETQGxRyYHs2P05niuu9g/G9p4vBXZfx8vrHsM+dZu+9SY3asy5F
         aJfA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768415054; x=1769019854; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dfg4XYGk5XyeYtVfQ6Zn1brUb+xWMxA29+l07+I3qE4=;
        b=CZD8MyUpfvm+4pXNHeoOkHuAHWNtdLHbaSXCu9PQe10jTKfAM6949NhgvP9JMANhKq
         08xjhRmIuoLv58hysS6ld3N41y+TDDqQiXjx1J/CU9DdWHvJDO7aQXWEeb7cNrJ6P/A8
         UqEVwkfeqQ+5VhB5UvZOra+XT79Coj8GZBJszF/h02P41/RqfWevOra6maV5DvzhqEAC
         6k06AYEFpcyvMvRYYdnEwHbTHeum1TnMrTs6p5jbITQ4Smg7LvR0MVhRrF10HTFuWsl1
         MKHd8j/OH4Xhf+0qtqLauIAm/5NQB5gxqgDStQR9P9tAuDY2yQHEDHMZgnRUcokYf7wJ
         fJ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768415054; x=1769019854;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Dfg4XYGk5XyeYtVfQ6Zn1brUb+xWMxA29+l07+I3qE4=;
        b=QFcThTT4MzOX957x2wa4rpGfxC3tEUBBJN9abLOjyut5rSlgksuPsHm6tSJ4pIxTmw
         6XmKvsbG3L06XYsaQ14Brzd+kY2a9nl3AWYDbNkOYJk/AnyPFhK691ylACUvePX4JMjC
         786tpFz6G7Cz94F9HW8JyFnYy7FXz3wepD7rETyJ9oWajR5hklK6STgrgx+O4TpLOp1e
         ba+OZ8mHFfebk0eeBu3SonhX4VF5nkItdry+f3wzG3Otc7moURBOKJIK2uVMfGPsWLbG
         RcdwZKItGSvwnZfdHu93yL8Bju9efKGgyuOyddllvO+oklM37jgRQF0YFMy0mYCi2hqQ
         glRA==
X-Forwarded-Encrypted: i=1; AJvYcCXqJ7dwvooGh+ysM8rEsWnCGf0j81gBIW5wkfQZggBCYilrvIj+sNNQQCmKfnrjFpypnM9BUxB+Ag==@kvack.org
X-Gm-Message-State: AOJu0YwYREtPGyUgSVhUTY2DF7CmGb4OIRE2Mt/cKpw+h8ghFO0De7S7
	ub54FtmmuXU2jYgfzjrw/VPOUJuJZWnosW627ctnMoPcHnkmTPer0DsTVnq0ypWBeXULohKKE1U
	2h/zBZFDv4XiZWR10Bds1fIkqgLKwGcjWq5Q9Yumc
X-Gm-Gg: AY/fxX4e+FH7Tp3f2nua3vCcwMceGgjkwpVsuxRBOiLmhuoXAAQ10mT/djxl5AHy3Pu
	f8d/y18MTftBh4YHd7X17X7GElSQR9RCDXHo2N0KIS4stvLExgAahyte5JXWr07iq5k5zEom921
	WvfMcr1E0jNCylwJpqaHA+IWZ/gJiw30ZHFVrNOORfPNCgoT/b+KcKUD8t2ZWpxoWT4CyIIkF2U
	mm13oylDoOP+F0TycwfCkf3nz+nGMD+m4mkzxGqHSLZiGdprzLzCi7L+x3J/ZhaxB7EHs1G6m9k
	yxc0tfHO08vSnld8nJI58a/O4w==
X-Received: by 2002:aa7:d408:0:b0:64f:fb8a:399 with SMTP id
 4fb4d7f45d1cf-65419faf909mr1864a12.3.1768415053711; Wed, 14 Jan 2026 10:24:13
 -0800 (PST)
MIME-Version: 1.0
References: <6967c517.050a0220.150504.0007.GAE@google.com> <CACT4Y+aFaijS_CvzTnHB+ecg5nzYW1-MWPSp-Ad_0ax85=DvCQ@mail.gmail.com>
 <CAG48ez0iyjjZn1U7LeG4SBXjRGo3PR-a0MWEhAJZ02vHOUA6BA@mail.gmail.com>
 <CACT4Y+Z24oSCssMnYwtCkGHpCKTOX2J4x+8HNoGovVxeZ5_TzQ@mail.gmail.com>
 <CAG48ez0q6ZXAk8D3frvXyeMsFDYfmY0sc=PkE6bRM8QP0gEVfg@mail.gmail.com>
 <CAG48ez3+t-uv88cUhG6=YfMyRVW5REi3-aaW3a_yXSZDK38_ow@mail.gmail.com> <96aec792-7d10-4dfa-bf35-cc94300f4d2b@lucifer.local>
In-Reply-To: <96aec792-7d10-4dfa-bf35-cc94300f4d2b@lucifer.local>
From: Jann Horn <jannh@google.com>
Date: Wed, 14 Jan 2026 19:23:37 +0100
X-Gm-Features: AZwV_QgRabxVZuILWEIFIySjqjbCby_iTvUdmzj0cwpmGC6K8SyEoosZBv36THA
Message-ID: <CAG48ez28kdkX1imCj3rDYNTi9PKQBx9Cqf+N2Rg92o9BEdo9QA@mail.gmail.com>
Subject: Re: [syzbot] [mm?] KCSAN: data-race in __anon_vma_prepare / __vmf_anon_prepare
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Dmitry Vyukov <dvyukov@google.com>, 
	syzbot <syzbot+f5d897f5194d92aa1769@syzkaller.appspotmail.com>, 
	Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org, 
	harry.yoo@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	riel@surriel.com, syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AFF901A0011
X-Stat-Signature: 17dfgcfpp7yoxirh4jzibsap45zgxyf1
X-Rspam-User: 
X-HE-Tag: 1768415055-783218
X-HE-Meta: U2FsdGVkX18s/3RPXPAK+wDzR503kBIdWZq0sLX6lF6/itEUe//7QvNk+0HrEAYpZj+A+gKHOFPwCFdc7lqP6zFJgpJSPZAoFfVkzVrEXKpXvzD2KCGuKv91WG3ZmepDmlHuhP9nNt/eh2fOu8qqf/+f90wizpeSi/qyC7CLhRLRkAid4OG2tnka7uVB9vZ5IlS0uXMEYeiNct0k8vIhX3JT6E790hIxxkyL+wP3tca+yplYxQ4ZE+YPfMKtpS3k6ApPjwPcxrLh2FiKt3Dg3/LhcQaExsMrrpVzY5MSgE1Lk8Y9fb6ZR2aKG/gt+zCeVx7THFYn+0Yu50dVAJAYYHsoF+RGD4xb7djdsKZDDgaH67EPh/ETa6mH6CHyVpJTxkZETPvW7G1HMZnBmOylplqj97tnwHB9axOQdlV2L+YZIgIBE27ea+rwlmkKxaEJU2xykboOO/PN7/lg2RJYlo8TGC1p+M/gg5pKgynGrcNaT8GIsVzhO7FurcJ3TSfDLBZPaa83TiLwdksonV2I7D/GSnD+lvRPt9YHJzq2kfykz8ANZx9DvU0D3jplfnzKmoEVNGInMsrHEe1ak0A8Y7bbgZkUHHNh4JAEAfc8VbB2NqKNrYRRXz4eBx5QkMBjdi+Bg/NJxCD4e8JnW1GEc9qVQ5GSClKBB/IdAD0MvfZ+jROH12/y6/CnHjkFXKV+RlG8wyWzGB/+llOWNLCduN9ccf0FBDz4hmx8Iboa3B1zffzrFxxIbZGOAu2bKJuLnVpogdPyvKxWR5OBAktpWAORQ45TqOO3QLxEooT389n7K4eBwINy/0SGuNexMT8Pn6KEa3j4yymfCles9MZEnCpfLRazuBlGIvqEQxDCO2dRvozzHQrJGVjsuWZhyUS0yLg+zaGjPk4eJL+ClAMkpCjzFMGWbu80M7FI/jT8XtvjP/k0rWTQm0smwAV8H+oZ1ic+A6iTPUgzi1HT7ew
 gs+HFqkn
 4vNAAyMIcr8zBXMF/WsWtMtTyZ5t0n0LOXSoVwE7cddbbmik7bFObuKIL0NDBg8mGU0XAlakEBnP/BWe2x7Q71CeB2ygFUP7atxQzxyFEHPUu7QBDQrlG56/SkmMSREpIrdGeMPwquXzQfB636eUHLRuPl9pqRBnoVZ8sFL1lTnrO052pJvpf2Ihg4ZjN31sbgLgxULj10PmovA0zOO76xd5AVbW4dJrXA17FnZNUBF076/PaJFI0bgQ1bY/HpxQJkL01t+uG0IqJtt4Af5QIojahPauPVRAnJyrQz/XQWYKqnXvYDaideM4UJgXrDxsiaLh3f7GPBKQJQCJ//oDKQ0f3l/KD8/eAFbHcg4LcMC+nsRqMjuufm8dcPAXL+Cm9No6TajtqoZ8SZy3Mg/7Q/d6O1wDTd8UOE6WDyHARx+HPju2oeIF9qqXfFAcWPndX9UCyjFTCFDRlRikwDX0FfMxTYS216pyscmzteVmHnsX44KRk1Z1LWSHw/6u+NsD/mQD7JMLpoFV486wGl9AEHawj+fg/or8mTyIIIrCkWhG2K9g1zTn/GZXSwMyBlySyCz8tYClxscGHuD6JTowEReFC4JoW9Zlp23zTmd5eQEB8K22Qw/aqPGChKe0qY0MH5sif2xbbdNPGbYqD/zKGNMcTq/RXrRy7LzRpu98QMaKUUBNj78ofKuVNq/qgnK7fVCc8dm6oQLzGg98ze+zeeZqe/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 7:02=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
> On Wed, Jan 14, 2026 at 06:48:37PM +0100, Jann Horn wrote:
> > On Wed, Jan 14, 2026 at 6:29=E2=80=AFPM Jann Horn <jannh@google.com> wr=
ote:
> > > On Wed, Jan 14, 2026 at 6:06=E2=80=AFPM Dmitry Vyukov <dvyukov@google=
.com> wrote:
> > > > On Wed, 14 Jan 2026 at 18:00, Jann Horn <jannh@google.com> wrote:
> > > > > On Wed, Jan 14, 2026 at 5:43=E2=80=AFPM Dmitry Vyukov <dvyukov@go=
ogle.com> wrote:
> > > > > > On Wed, 14 Jan 2026 at 17:32, syzbot
> > > > > > <syzbot+f5d897f5194d92aa1769@syzkaller.appspotmail.com> wrote:
> > > > > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > > > > BUG: KCSAN: data-race in __anon_vma_prepare / __vmf_anon_prep=
are
> > > > > > >
> > > > > > > write to 0xffff88811c751e80 of 8 bytes by task 13471 on cpu 1=
:
> > > > > > >  __anon_vma_prepare+0x172/0x2f0 mm/rmap.c:212
> > > > > > >  __vmf_anon_prepare+0x91/0x100 mm/memory.c:3673
> > > > > > >  hugetlb_no_page+0x1c4/0x10d0 mm/hugetlb.c:5782
> > > > > > >  hugetlb_fault+0x4cf/0xce0 mm/hugetlb.c:-1
> > > > > > >  handle_mm_fault+0x1894/0x2c60 mm/memory.c:6578
> > > > > [...]
> > > > > > > read to 0xffff88811c751e80 of 8 bytes by task 13473 on cpu 0:
> > > > > > >  __vmf_anon_prepare+0x26/0x100 mm/memory.c:3667
> > > > > > >  hugetlb_no_page+0x1c4/0x10d0 mm/hugetlb.c:5782
> > > > > > >  hugetlb_fault+0x4cf/0xce0 mm/hugetlb.c:-1
> > > > > > >  handle_mm_fault+0x1894/0x2c60 mm/memory.c:6578
> > > > > [...]
> > > > > > >
> > > > > > > value changed: 0x0000000000000000 -> 0xffff888104ecca28
> > > > > > >
> > > > > > > Reported by Kernel Concurrency Sanitizer on:
> > > > > > > CPU: 0 UID: 0 PID: 13473 Comm: syz.2.3219 Tainted: G        W=
           syzkaller #0 PREEMPT(voluntary)
> > > > > > > Tainted: [W]=3DWARN
> > > > > > > Hardware name: Google Google Compute Engine/Google Compute En=
gine, BIOS Google 10/25/2025
> > > > > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > > >
> > > > > > Hi Harry,
> > > > > >
> > > > > > I see you've been debugging:
> > > > > > KASAN: slab-use-after-free Read in folio_remove_rmap_ptes
> > > > > > https://lore.kernel.org/all/694e3dc6.050a0220.35954c.0066.GAE@g=
oogle.com/T/
> > > > > >
> > > > > > Can that bug be caused by this data race?
> > > > > > Below is an explanation by Gemini LLM as to why this race is ha=
rmful.
> > > > > > Obviously take it with a grain of salt, but with my limited mm
> > > > > > knowledge it does not look immediately wrong (re rmap invariant=
).
> > > > > >
> > > > > > However, now digging into details I see that this Lorenzo's pat=
ch
> > > > > > also marked as fixing "KASAN: slab-use-after-free Read in
> > > > > > folio_remove_rmap_ptes":
> > > > > >
> > > > > > mm/vma: fix anon_vma UAF on mremap() faulted, unfaulted merge
> > > > > > https://lore.kernel.org/all/b7930ad2b1503a657e29fe928eb33061d7e=
adf5b.1767638272.git.lorenzo.stoakes@oracle.com/T/
> > > > > >
> > > > > > So perhaps the race is still benign (or points to another issue=
?)
> > > > > >
> > > > > > Here is what LLM said about the race:
> > > > > > -----
> > > > > >
> > > > > > The bug report is actionable and points to a harmful data race =
in the Linux
> > > > > > kernel's memory management subsystem, specifically in the handl=
ing of
> > > > > > anonymous `hugetlb` mappings.
> > > > >
> > > > > This data race is not specific to hugetlb at all, and it isn't ca=
used
> > > > > by any recent changes. It's a longstanding thing in core MM, but =
it's
> > > > > pretty benign as far as I know.
> > > > >
> > > > > Fundamentally, the field vma->anon_vma can be read while only hol=
ding
> > > > > the mmap lock in read mode; and it can concurrently be changed fr=
om
> > > > > NULL to non-NULL.
>
> Well isn't that what the page_table_lock is for...?

The page_table_lock prevents writer-writer data races, but not
reader-writer data races. (It is only held by writers, not by
readers.)

> > > > >
> > > > > One scenario to cause such a data race is to create a new anonymo=
us
> > > > > VMA, then trigger two concurrent page faults inside this VMA. Ass=
ume a
> > > > > configuration with VMA locking disabled for simplicity, so that b=
oth
> > > > > faults happen under the mmap lock in read mode. This will lead to=
 two
> > > > > concurrent calls to __vmf_anon_prepare()
> > > > > (https://elixir.bootlin.com/linux/v6.18.5/source/mm/memory.c#L362=
3),
> > > > > both threads only holding the mmap_lock in read mode.
> > > > > __vmf_anon_prepare() is essentially this (from
> > > > > https://elixir.bootlin.com/linux/v6.18.5/source/mm/memory.c#L3623=
,
> > > > > with VMA locking code removed):
> > > > >
> > > > > vm_fault_t __vmf_anon_prepare(struct vm_fault *vmf)
> > > > > {
> > > > >         struct vm_area_struct *vma =3D vmf->vma;
> > > > >         vm_fault_t ret =3D 0;
> > > > >
> > > > >         if (likely(vma->anon_vma))
> > > > >                 return 0;
> > > > >         [...]
> > > > >         if (__anon_vma_prepare(vma))
> > > > >                 ret =3D VM_FAULT_OOM;
> > > > >         [...]
> > > > >         return ret;
> > > > > }
> > > > >
> > > > > int __anon_vma_prepare(struct vm_area_struct *vma)
> > > > > {
> > > > >         struct mm_struct *mm =3D vma->vm_mm;
> > > > >         struct anon_vma *anon_vma, *allocated;
> > > > >         struct anon_vma_chain *avc;
> > > > >
> > > > >         [...]
> > > > >
> > > > >         [... allocate stuff ...]
> > > > >
> > > > >         anon_vma_lock_write(anon_vma);
> > > > >         /* page_table_lock to protect against threads */
> > > > >         spin_lock(&mm->page_table_lock);
> > > > >         if (likely(!vma->anon_vma)) {
> > > > >                 vma->anon_vma =3D anon_vma;
> > > > >                 [...]
> > > > >         }
> > > > >         spin_unlock(&mm->page_table_lock);
> > > > >         anon_vma_unlock_write(anon_vma);
> > > > >
> > > > >         [... cleanup ...]
> > > > >
> > > > >         return 0;
> > > > >
> > > > >         [... error handling ...]
> > > > > }
> > > > >
> > > > > So if one thread reaches the "vma->anon_vma =3D anon_vma" assignm=
ent
> > > > > while the other thread is running the "if (likely(vma->anon_vma))=
"
> > > > > check, you get a (AFAIK benign) data race.
> > > >
> > > > Thanks for checking, Jann.
> > > >
> > > > To double check"
> > > >
> > > > "vma->anon_vma =3D anon_vma" is done w/o store-release, so the lock=
less
> > > > readers can't read anon_vma contents, is it correct? So none of the=
m
> > > > really reading anon_vma, right?
> > >
> > > I think you are right that this should be using store-release;
> > > searching around, I also mentioned this in
> > > <https://lore.kernel.org/all/CAG48ez0qsAM-dkOUDetmNBSK4typ5t_FvMvtGiB=
7wQsP-G1jVg@mail.gmail.com/>:
> > >
> > > | > +Note that there are some exceptions to this - the `anon_vma`
> > > field is permitted
> > > | > +to be written to under mmap read lock and is instead serialised
> > > by the `struct
> > > | > +mm_struct` field `page_table_lock`. In addition the `vm_mm` and =
all
> > > |
> > > | Hm, we really ought to add some smp_store_release() and READ_ONCE()=
,
> > > | or something along those lines, around our ->anon_vma accesses...
> > > | especially the "vma->anon_vma =3D anon_vma" assignment in
> > > | __anon_vma_prepare() looks to me like, on architectures like arm64
> > > | with write-write reordering, we could theoretically end up making a
> > > | new anon_vma pointer visible to a concurrent page fault before the
> > > | anon_vma has been initialized? Though I have no idea if that is
> > > | practically possible, stuff would have to be reordered quite a bit =
for
> > > | that to happen...
>
> As far as the page fault is concerned it only really cares about whether =
it
> exists or not, not whether it's initialised.

Hmm, yeah, I'm not sure if anything in the page fault path actually
directly accesses the anon_vma. The page fault path does eventually
re-publish the anon_vma pointer with `WRITE_ONCE(folio->mapping,
(struct address_space *) anon_vma)` in __folio_set_anon() though,
which could then potentially allow a third thread to walk through
folio->mapping and observe the uninitialized anon_vma...

Looking at the situation on latest stable (v6.18.5), two racing faults
on _adjacent_ anonymous VMAs could also end up with one thread writing
->anon_vma while the other thread executes reusable_anon_vma(),
loading the pointer to that anon_vma and accessing its
->anon_vma_chain.

> The operations that check/modify fields within the anon_vma are protected=
 by the
> anon rmap lock (my recent series takes advantage of this to avoid holding=
 that
> lock during AVC allocation for instance).
>
> This lock also protects the interval tree.

