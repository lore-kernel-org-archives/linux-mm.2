Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44220108B91E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 01:49:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A1E96B0088; Tue, 24 Mar 2026 21:49:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 825136B0089; Tue, 24 Mar 2026 21:49:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ECC36B008A; Tue, 24 Mar 2026 21:49:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5899A6B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 21:49:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E80BB13B56B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 01:49:30 +0000 (UTC)
X-FDA: 84582903300.07.E03091F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 17A70C0008
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 01:49:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sL6zLVcp;
	spf=pass (imf28.hostedemail.com: domain of robh@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774403369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D1ZCRVk47y847KqNNtC0QUA4rsUv0DqPW1+C2s8HFvs=;
	b=s8MioAQLCRqn9l/8q2LF0c0lvRhZG0x6v6aZRPqlFa+MjQXyVxdYl9GQIDOJ0Sw1+jH2pI
	nzGxZR2o2gEnzsJaVga1fAVbQi6T/JwUsO8KLnXu/wRY+X63mVnIoiPizIt1OgAoxgbwgL
	gkyEZtFKvMqalrKiRkVDcxxAmDs+4Zg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sL6zLVcp;
	spf=pass (imf28.hostedemail.com: domain of robh@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774403369; a=rsa-sha256;
	cv=none;
	b=y/XjLuD80eGEiAgTlbDzgAZZZV5DLqqXUjJMBaWEB6CwafmAOuRqvVIx2tIph8h9xv9y7/
	f/O2YgkLaKmxjlcUgTCQ2ASZfSHswRnE6xOLdxfrU2Ue0kaZcjZinKK0GUBGaRJ5VvDB5H
	elgvTNw5Bkm6E7pIjUj6ty8/MnhD0Z0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 72D0D600C4
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 01:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5E9C4AF0B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 01:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774403368;
	bh=hNt8MNWtIP/O1R1/zHYxmr7W+C0wrYNqiVbk9jzLSGg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=sL6zLVcpGTSZfNDfpAz0wCOaJmueeAU2MJ+vHx1qo1j1obYbd4lj7vbZa8udsQBbu
	 fCP3NBxESjVOZKO70dK5pocz6izZxeox5ijRpR9jHYbGvdwlJ7kTnlTgzVXYirRY2L
	 pffG8zWlVlocXuH0AyuXcCDDSshjIC2NM4V5iQvtsUJdOgxppKZUkidd1gRDJ/pekP
	 aC4nEovcIjKDukcvG/DsUW4vqi8iVWYkom4HRR6Kl+FNhxZBQ1+GzjngPa9xG5l5wi
	 wQMHfrfIde4z0reQ/0WlRhiO1XaznM/wCDd9JKNyZdNwpRmSGQxFwJIrGf83Et59Pe
	 2dPnjkUPSyTMg==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-660a58841d4so2759870a12.0
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 18:49:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWXe5xcq/XoO8hBiXbgEpGl/oa0HDX1N4Dd61Tko//G/iBl4k9GvAD8QU5qk6s2gNMFB2jVRvG32A==@kvack.org
X-Gm-Message-State: AOJu0Yxx+EZcZH9oxR2sQEG5QgCuJ5bvkH/Q/UzH36XYbrN/lJ8jc8CW
	XiY1c0MNfizX1lvPzfgGzmQCKap3xyl9L0qLak4H0/qdd7uBDL+9OVnJ4/Um/QvwseIuH3JYrMX
	KYXt1stiFQQv0/S8Qf36pN82/lqaJig==
X-Received: by 2002:a05:6402:40d5:b0:665:20dc:a900 with SMTP id
 4fb4d7f45d1cf-66a82593876mr1081696a12.0.1774403366593; Tue, 24 Mar 2026
 18:49:26 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20260323100908eucas1p2f471760fe1b26181c9b0cb90dd0739a6@eucas1p2.samsung.com>
 <20260323100901.4079171-1-m.szyprowski@samsung.com> <20260323131822.abae01e95817011f24bb8237@linux-foundation.org>
In-Reply-To: <20260323131822.abae01e95817011f24bb8237@linux-foundation.org>
From: Rob Herring <robh@kernel.org>
Date: Tue, 24 Mar 2026 20:49:14 -0500
X-Gmail-Original-Message-ID: <CAL_JsqKbfFfWOzDL_KJLg7Gu-wCqE1Ch+yZ6-g-cNJD-rMzxXQ@mail.gmail.com>
X-Gm-Features: AQROBzA9GVjXMZUCOkFS1ntzOZ2El9XjWSyU4NWT9q2kTbAcGrqDhysUX0MSxz0
Message-ID: <CAL_JsqKbfFfWOzDL_KJLg7Gu-wCqE1Ch+yZ6-g-cNJD-rMzxXQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] Refactor reserved memory regions handling code
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-mm@kvack.org, iommu@lists.linux.dev, 
	Krzysztof Kozlowski <krzk@kernel.org>, Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>, 
	Saravana Kannan <saravanak@kernel.org>, Robin Murphy <robin.murphy@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: issbbrxthakwodpi4icur7ac8iqpyr5o
X-Rspamd-Queue-Id: 17A70C0008
X-Rspamd-Server: rspam09
X-HE-Tag: 1774403368-92787
X-HE-Meta: U2FsdGVkX1+NJTmdK4Ehkk5ZWFeWPTD//+5/upQP+AGYxT7OWzsr3rF6wIe42T5cGOXTyJLnGxAlE16/eKkXdqxwmcHSq8YyCb8FEWVKCIBz62lhbdQt1DP/fCFBkC4O0vTEkaFEoq2/nw3B7N3ixtu2un8DpD9wCfu/dhi0mCWKdj+trdhPYgzxdu158H+lWlIoNEqw/uqpt+aiYsdOhkBJSr3HgmnggQg1Bedn6Y6T3ruPdfvEVILIugdF9wTFIMEdoCAvX8CYVIc2i9NICqKFu7XGABg+B9rEkTlP9E++BxkXiwxC8pY9rB/JudWU54tWZ3gVpoM7Xd4+Ia3YpLQSO0PjdEXdzLlzmFGf1ub8MlZdPWY17PdcDet9xlY6WPbrz5VibkkI0cjxamHoZckZpvx1Srj1zffHvil7/QhGcUKgwk96Q4YY0goxJUNpoOFnRTProxPqYd8zxdVyveirc4qlzkI+vepmJ0bs1WFr/xirzwE9wsNSjf/FeYko6W5qQQz+CQj5+i2QS3GX/wtKj1heAgG59P5JPVbAQWxPdKHgMx7BZRfeljbtCrQXSnXVB4zLOVbdYH6XNBb7gyI3GCFzYf27gGLhZ/HkmOaOSBQhRHwe/IMSJdfsvexbH9rZlr5sD17ynmD9oA+ooHu4EP9l2HwcFqqOFbX6/YoNtxo3u9z1Qu9AX4/nDIGaaxx/BeK5FFPTLOhDNcnLEvRzavwT0ibftBihqLm13GEfcCyRaJMbihc7PivA4VEIQViinwphuJnHy/PDxPORcaDf6YX5tG15ZoALALrplg+ckMFt/fZNPsrJZJJsbmEYvlMo6jk9qcFi3ygUSa6kKUrCpo2GBKErgUq/czxlWCjcv2q5h4oXBe/AFP+NX6eEabWRBbvdu+rSqP4tFV6iir2YTBF2QsYklEkyijsrpQiTKJns9bRx/NE9C5gmDj1wkMyM/6uw2Gx4Z+iKRHr
 u/GVdXTg
 UgjnuLInbXmQL6/QN3U1suJ0giY2wuf3HkWx89nDphT5dk8P08YibrGA6gW6lYFHsjGnEsaB6byN+cCR0CjeE/V11XeCeDfJtqLvehlpDTfOY8oF1QeGxX2iQz2uwXn/CBSxPG8qJA0cTI4K0wx/wDZJnd3dt9wI9tAtXdEoNk+Bzfn6xb4/5/DQ3Fya/vblEcqxOlvHbrT8l8SFonEC4XPN/aZzT9BJp0Uu96RNRNIQEOnCwPlY2TvNJikwkUUsbdr1vUJGeritSyny8IyoRNF0SaAeCKU7PBMUrYWr7872frWWVgUPMuLc2iF0H0kqwDLkjFgXwd7gLilpxT0xRIOyRXlmMePeYAzmOigVHsART1duPf3iFATmNHeZnl0nDqKMHgW48S99ednKzD2JWB66xf+01VfgKzRwY6iNGgAn57R4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 3:18=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Mon, 23 Mar 2026 11:08:54 +0100 Marek Szyprowski <m.szyprowski@samsung=
.com> wrote:
>
> > The reserved memory regions handling code was reworked to handle
> > unlimited so called "static" memory nodes in commit 00c9a452a235 ("of:
> > reserved_mem: Add code to dynamically allocate reserved_mem array").
> >
> > The side effect of this rework was a set of bugs fixed later by commits
> > 0fd17e598333 ("of: reserved_mem: Allow reserved_mem framework detect
> > "cma=3D" kernel param") and 2c223f7239f3 ("of: reserved_mem: Restructur=
e
> > call site for dma_contiguous_early_fixup()"). As a result, the code in
> > drivers/of/of_reserved_mem.c became a mix of generic code and CMA
> > specific fixups.
> >
> > In this patchset I try to untangle this spaghetti and perform some code
> > cleanup. I hope nothing breaks this time.
>
> AI review wasn't able to get all the patches to apply, but it asked a
> few questions:
>
>         https://sashiko.dev/#/patchset/20260323100901.4079171-1-m.szyprow=
ski@samsung.com

Now I get these in several reviews. Just posting links here really
doesn't flow with the review process. How are we supposed to answer
when AI is wrong? Manually quote everything? No thanks.

To answer this one, I think 1 comment is wrong, 1 is right, and 1 I'm
not sure about.

Don't get me wrong, I think this all looks promising. I know email
support is planned, but please get that in place before sending
reports. Really, I'd rather just get the emails or mbox to review
first and then decide what to send for things I maintain. At least
initially.

Rob

