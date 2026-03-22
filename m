Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1BEDFC72BE
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 11:31:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A7A96B00A7; Sun, 22 Mar 2026 07:31:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 559066B00A8; Sun, 22 Mar 2026 07:31:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 495626B00A9; Sun, 22 Mar 2026 07:31:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3E47D6B00A7
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 07:31:36 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C1A721B89DC
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 11:31:35 +0000 (UTC)
X-FDA: 84573483750.18.FE48656
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id BED83C000A
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 11:31:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uQMlHXyh;
	spf=pass (imf28.hostedemail.com: domain of rafael@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rafael@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774179094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CZXIAphpEoAXPXJOqhiWoTDgIfpM0+mqwqQXnEDj07s=;
	b=eb1OMTwweWiPoS74GovjdoVy/kXkVCeYVZqxpM0FEnX5tMTwXdC+hEGLmG69IsgUBMLZm/
	T6vWFutCPsCceAyMLC5kIpYa3xYYnHreKjJPuzGdTOR6mGTl2x/l9hrEVLtbB41oPyhiTE
	lMPbPLBMcwTkba1x0pY5n3XEJpK13oc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uQMlHXyh;
	spf=pass (imf28.hostedemail.com: domain of rafael@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rafael@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774179094; a=rsa-sha256;
	cv=none;
	b=H2TQmgK/JsjJz5CWOvX6RBbeH+G/sOY/Lxrwpyp2jBXxzapqtCrH5FiQGsD5BtWw2hP07m
	TNr48XLjBc7BvnGgaQlh+HoVtAY6QZ58s/YtB5YvtQUtfLHML+acD9GJEWvDQx3bDgr24+
	370HhJbKgjAbMnev9kCA3KyxbO7UrW4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 887E044387
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 11:31:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5E7C2BCB3
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 11:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774179092;
	bh=CZXIAphpEoAXPXJOqhiWoTDgIfpM0+mqwqQXnEDj07s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=uQMlHXyhsJZG7NGkoYUAvBCrMwmMf+VXI+IvMR9O31GZpRJ0tT7vQTJW1xf7oRt0F
	 5KxNGyzPe1omNM40tbwWkHrbNriK/lJsipfqO7Vu28yQIA9P9Pli7N0N/EJL0w9h9m
	 Jq9bBsL8CqJ5jNQEv7k/w9MukfeNIjCZKilCFsMDLwr8A/eyhWdXmHnfr3m5d3FqJ5
	 sxh+ryUWv8ltmu+ThOsjeTcw9A0eF2nkdvZFukrOCv2CEopTUYF0QGiLFD5l/3WKBf
	 B/nKeFCdIfH5k0ouSbvR7Giop5mzdOz99k1OV6MT8/fy8R3yz9cyzhoD/D1kZMi331
	 cNw241Fz9RuDQ==
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-40f1ffba6a0so2085349fac.0
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 04:31:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWre+56OJM1cEhJPy/hWGrTxQUCLGB/+8JU3JxTI2Vw2pT4gMVG4m3zNcz6XoCTfZO9BkgJCOhAUQ==@kvack.org
X-Gm-Message-State: AOJu0Yz0VkJzzmM8P8W1br9V26VgCFK20B4v1u9kOXsk41zUQwMgnRC7
	ieSygCzpnueMiMYHQhUvtKdMhztIemIpcXk+WqNzfxVfqYmqZ+sBLoOpmqxrg4aZ0Y5xhSW2OXj
	vxaSmDZ/xzsK3Ctidbbb9bz9jKxlvjJ0=
X-Received: by 2002:a05:6870:812f:b0:417:6b32:f50 with SMTP id
 586e51a60fabf-41c114ad093mr5987793fac.50.1774179091364; Sun, 22 Mar 2026
 04:31:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260320170313.163386-1-youngjun.park@lge.com>
 <20260320170313.163386-4-youngjun.park@lge.com> <CAJZ5v0gHTPCkVySAuPBkPoV=SwmBRG_c-TtPbz0CNsUUPEkY8w@mail.gmail.com>
 <ab53krr0y981Qyk8@yjaykim-PowerEdge-T330> <CAJZ5v0gVbQQdpyWb72qDcsAoj7vg2v=pXOjdMuWzKHJsdJcHNw@mail.gmail.com>
 <CAJZ5v0ge3K4DOZHxJyWARZWu_N96_sAw2T-8nr54zSKH-hOfRA@mail.gmail.com>
In-Reply-To: <CAJZ5v0ge3K4DOZHxJyWARZWu_N96_sAw2T-8nr54zSKH-hOfRA@mail.gmail.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Sun, 22 Mar 2026 12:31:18 +0100
X-Gmail-Original-Message-ID: <CAJZ5v0gBHLz7T2qRJRjBfOWY6UXM6L6+Kw8UcsY4+OaB7+qQcg@mail.gmail.com>
X-Gm-Features: AaiRm53xYV_EZSYGQrEKmhLGtdzk7WdbJ8VpXBo1B9uzpzij2dzrLdLvtlNqx20
Message-ID: <CAJZ5v0gBHLz7T2qRJRjBfOWY6UXM6L6+Kw8UcsY4+OaB7+qQcg@mail.gmail.com>
Subject: Re: [PATCH v6 3/3] PM: hibernate: fix spurious GFP mask WARNING in
 uswsusp path
To: YoungJun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	pavel@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, baohua@kernel.org, usama.arif@linux.dev, 
	linux-pm@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BED83C000A
X-Stat-Signature: n6nga9ey8whd6zhk5dogwu6m1z7ae3r3
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774179093-400907
X-HE-Meta: U2FsdGVkX19BpUxYZDIZDCyU3K+CBqbFzz/G3327/3R5jYkFEpfgvSHV4X49W2DjjA/oIa2Zjf2dN8HECmEFkd/mhJZs1A4Q5iA6ZeFpSstt+h2TUVo5oP4H3EFTC1ysuSyQjpTATaXF4skLLJbBoJOmxXppa4fs6Ru41F6yowzUImc1caQAUTrjJoYb/s25hY/efv3yTSGUqEyZwPkT34YeKOqfo8g/ZMiOv/7be2iO+GPEQpAbnY8QJUrSs/9vNh6s8bz9CbDSRpIVqvxVvbX+4E5KDK+VAf2esMpodm0fSBVn2CZvpcSXITH14MXzGRCEtYYGLxFbAscKsSZ09hgoqmFJ3EYUAoeFXu69QsrxAfxeBigZl3ygq1HvmtAs8dyR0zSiQ9EBieUP13q2r+HQianUvIOhFy/Ao3npMzrBHCuYBGuNYyrvUsN52hc7BQjK40/o9MX2UK8ymXejBYvENfyPKH/wPocx4ZOF1+LTVbGftEpxnmf2MBfYbuaeP+TMvlm3WUrqDYBlNn5xqIV6YxQ3yzgHgay0ZzRzjIwOpQ+Xj7HYdAYWJBLmnoAZZc/07vgq0xAty505R3HWmQA6vT/VUUtg89GOfo/vwUDN+IRlPC18Fo4LaaPsBlCq30kAyCerDuJNdfCQplcLAdE9TELkoJhIVgFGO9OOoF9nxFR+05d9aSr2ffW/pr8Q5OzDiJydidVUrL/EpkpD746RugK4tai8Y8vSOEI4xUSHTZshXjqpCMz+QZfdhjsJvKV2TRUAgTi6EI/96OgJsbUSM57dhqUsmPOgAAZwNMNAsENO+a6+szwEYCFZ4turZt5MJjgp+mdP2d/6+aK4K4RUluqtKq9kTbTcU/p5QNL7DHld0dz3W7zw8rBoeuMfA3g/fwoLTrWVPosEP06GearZ2DE+rp3CIj4KRTH/F2qKtpq/uUFs8TaVESzZoteCXkkBoIr9dKyAhnT4h8J
 ppJgXrA/
 aCJhbvWMhbxf22UvswWl4P0BwyjnS0QgZztD6eSPTMyUNVopLLvssOG3KCf36CSjr4AvgxUt93/FPis1+inIl1jZBUdIbxiitSyFayHixZuI+qqpKRghOIikA548iWK7hUyLQZeYKa6x1ePlEnVo9fzC35Zy77Nyc7txR3bflzLcY8NuJibc9EE8u9N2R6MzzylLOmAqivk8vAXbDinlQbEh3BCaBiyCs7ACOMe/9rvsG0KCaaArQ1ubyZvNYnG0N2dW0daIt98zzYNdgjine/4tGhmE4tyBNA6/G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 21, 2026 at 12:45=E2=80=AFPM Rafael J. Wysocki <rafael@kernel.o=
rg> wrote:
>
> On Sat, Mar 21, 2026 at 12:32=E2=80=AFPM Rafael J. Wysocki <rafael@kernel=
.org> wrote:
> >
> > On Sat, Mar 21, 2026 at 11:48=E2=80=AFAM YoungJun Park <youngjun.park@l=
ge.com> wrote:
> > >
> > > On Fri, Mar 20, 2026 at 07:20:24PM +0100, Rafael J. Wysocki wrote:
> > > >...
> > >
> > > Hi Rafael,
> > >
> > > Thanks for the review. Sorry for the back and forth on this one.
> > > I'm preparing to send the uswsusp GFP mask fix separately as you
> > > requested (with _nowarn rename and lockdep_assert_held).
> > >
> > > Before sending, I wanted to check on the approach. I originally
> > > found this WARNING while testing uswsusp and thought it was a
> > > localized issue. But AI review has kept uncovering more cases =E2=80=
=94
> > > first SNAPSHOT_FREEZE + snapshot_release(), and now
> > > dpm_resume_end() when dpm_prepare() fails.
> >
> > dpm_resume_end() should not be called after a failing dpm_prepare().
> >
> > Which code path is that?
>
> OK, I see.
>
> Let me have a deeper look at this.

So I agree with you that the most straightforward way to address the
spurious warnings is to remove the WARN_ON() around the
!saved_gfp_count check in pm_restore_gfp_mask() while retaining the
check itself.

Please feel free to send a patch making that change.

Thanks!

