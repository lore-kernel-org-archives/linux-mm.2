Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2234ACDE000
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 19:35:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07D786B0088; Thu, 25 Jun 2026 15:34:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02E2F6B0092; Thu, 25 Jun 2026 15:34:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E60716B0099; Thu, 25 Jun 2026 15:34:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B49BD6B0088
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 15:34:58 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 41A9E1C5C55
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 19:34:58 +0000 (UTC)
X-FDA: 84919437876.29.D1FDA31
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	by imf24.hostedemail.com (Postfix) with ESMTP id 283CD18000D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 19:34:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=johnericson.me header.s=fm3 header.b=abF9ft4k;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="b Bu/Gwg";
	spf=pass (imf24.hostedemail.com: domain of mail@johnericson.me designates 103.168.172.154 as permitted sender) smtp.mailfrom=mail@johnericson.me;
	dmarc=pass (policy=none) header.from=johnericson.me
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782416096;
	b=bVY9FiBDQzPiV/plq5lDFMJT+0epamK5io9LAHj6aTbYRSxPnqH/q2Sg/qBnuhrzVS0OKk
	EB3yrqOdtnrsm9hmaQj0fa2qHzPa1rvV19HTBtC3ykjLLg+cEogxASSP+aYE8aN8n3p4yI
	LM8wC25BZ6B2mYMof/9FVeKQ22jf7Uw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782416096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h/VJcPO5ZLOadJ5wysEz6lTyDoIeInuqp7ujvz9zGfo=;
	b=6TOnWZyWKihhX8FxBjdJnSpy+quCvuJ42sTbFUVgnyZDP0MgN8Nt0teRpenVSXbBC5zbed
	IuSuHrEPD+ixwNH5tstL/FMUDhI0bbcKd3/l8i63GQL/eaZYrJgII5Y/mL+HnRfqhdt+bF
	qJIsMv8o9PH9pi9YATWkye9432dlkW0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=johnericson.me header.s=fm3 header.b=abF9ft4k;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="b Bu/Gwg";
	spf=pass (imf24.hostedemail.com: domain of mail@johnericson.me designates 103.168.172.154 as permitted sender) smtp.mailfrom=mail@johnericson.me;
	dmarc=pass (policy=none) header.from=johnericson.me
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 7DF511400089;
	Thu, 25 Jun 2026 15:34:55 -0400 (EDT)
Received: from phl-imap-16 ([10.202.2.88])
  by phl-compute-05.internal (MEProxy); Thu, 25 Jun 2026 15:34:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=johnericson.me;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm3;
	 t=1782416095; x=1782502495; bh=h/VJcPO5ZLOadJ5wysEz6lTyDoIeInuq
	p7ujvz9zGfo=; b=abF9ft4kvzbIc8aYNSRz0Uofgjh8YFqyA9/pM+bt5o/HBqMd
	4okZovNx0/iizQY8FKft+r2i8DryTUoRxIUAX8ds7Tdok2N24W8xkHwknJpPb1Vm
	x8r9jNjGCoQoBAfB74vDxL6J7vUTAajWwChf05c2JkGjsqCzPc6cKtq4fZnPVYf9
	kxzaVf1uT1Y+Koo+WChi2v+2Cmhhm5H5LI8evEH7BN/CvvQsf/JXn3vQ02Tg2qI0
	JULBVvaoZXoV1hrRj6OcadKW5WX5t/1qDyV4aSKfiKSSq/eLtZNL4e6l5X9fvC8b
	uzDpUJxuDPTGcT2BOJkKVncZL0xcF8XOGmqrxg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1782416095; x=
	1782502495; bh=h/VJcPO5ZLOadJ5wysEz6lTyDoIeInuqp7ujvz9zGfo=; b=b
	Bu/GwgzkIw4a0CO1b3uncymfOPA2SJFz7coLMCF7atUUPVfpyY8LP1Vo3w6PgLp0
	nyPr9wRRn3euyM1NCzW8eF5ndc6+7K0pjC5dFccSVpfSwmmcqybpbFtMxbJqfSbw
	0D6X7ul5btN1KzCrh9P/97HXMEn5UHb7WJN5GgHcoK10owrE9h4djD5PdpBt/N/4
	FU7qtgz0mZrZ0+ZxDqBB0X6VbL8HAH0GsHv2ftnNHDW6NnLncBGHtbhUILkF1kY6
	l7nRx+j+qOIjiS5EXVkTgs9NmS4wTOCNmhCtdUuU8xucAqb3caL+lX+xFV9w49QH
	M/VohyQemObsOsQeMH7cw==
X-ME-Sender: <xms:3oI9avA42e-F3q1SrOClqUqWIixerRxW2AEje3rRmqhlFGTUEDipPw>
    <xme:3oI9agWyc8FIZ_4x3nqthL_THvhl4f8xq3kMCVgtAcBgNHI67aMmTz7HbnzOe44qy
    CGicPCoVDQnkYVe4oh9jxozeaAfW_uTOtGWpfXQiBdNKU_hCgxYeOA>
X-ME-Proxy-Cause: dmFkZTGwWfvxyF8Yo/MGgzR2q6tZRih46h6eDc0VHDJ2pRBK5ZLZ7SSxh8USlawBG3Ionz
    nNzQIKNAseFIJbn9/qEnT2y+FMvZaCwCMcOwyKQPdpm1DZ+ASf5zJ4gKan2cNthkC2xyk1
    z1TxDOQgUv6eBgvjksuIm72egj4axJgylhP6P2ON/VLtgPckdlJrpTsTBACxLImbcXljbD
    D9cVHv/FqOWPuuevvbVEd5oUESfnpfVwHpgZXdOCR0WFPH9WnYY7VfQkinAZ2Bhe54I5Ca
    y+pUtTjBGYbkJzfE9oqtsml4iTEu0b0V45H62UxjgnAhDNxkmwiyntx/Z9GKOwrAfce/R3
    9mvE62nTjt5a9+aLLjK9LsmHeiMYmBBZW5urTSPEuQ7uuhdNU8RLF28NTmVKHV1C/cmudm
    BWJZC/FRy7hL4hmt4N/jFjvZlp0lWwRBIj4LnVvE3wwEYQCqfz8dBdZOf8dLYGqUvf/tr8
    B76qpzExCYCPJj9X0Kf1M+Jzqc0zKoudkh0D47IL4sSs/X1Wml/r+6emBi7OFWL3jLZeBX
    R4Z4vDfMl9PsBUvkImElwRgxPHSKdUYdrRXcSgLQjYkjV0q+EcuxbcXzkDxRnFAAHRB3Cb
    ewYDL8Pk/iPOnyjDpVyNatgBrpwZdV5K0lsqOQCfFafWvD6y8y/0tMsdtctw
X-ME-Proxy: <xmx:3oI9asmTe8ZpTmoKswMGIu_WJAHRQhsWnnlOIIcWJuNJ0-U58aM_7w>
    <xmx:3oI9antVlQs_UO-pk-WMpU2BhqzYnNWZ6MH4A5FVvhYHtGunFJKscA>
    <xmx:3oI9anoCkWCOtPaCWyIvQtlLfb9jZvwQzyvrsGIFl7JOkdS2aFc31A>
    <xmx:3oI9atcUoTee-0n0XVI2QpvkgIB0vJ5M7qGyeVgjjFGZmZP3rZUF5g>
    <xmx:34I9apnPMV_xMBFsfpM-LU_FXjKvoFWzbXbRiuMH-WAevtXFRzElSmMY>
Feedback-ID: ieb4144f1:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id BC6772CC0088; Thu, 25 Jun 2026 15:34:54 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: A1dANeNfTnWJ
Date: Thu, 25 Jun 2026 15:34:14 -0400
From: "John Ericson" <mail@johnericson.me>
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Farid Zakaria" <farid.m.zakaria@gmail.com>, "Jan Kara" <jack@suse.cz>,
 "Kees Cook" <kees@kernel.org>, "Al Viro" <viro@zeniv.linux.org.uk>,
 shuah@kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 linux-mm <linux-mm@kvack.org>,
 linux-kselftest <linux-kselftest@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>
Message-Id: <ea5dc2d9-9a90-450a-bbcc-8ae3429ae85c@app.fastmail.com>
In-Reply-To: <20260625-atomkraftgegner-hunger-kursbuch-b452ff2becab@brauner>
References: <20260622043934.179879-1-farid.m.zakaria@gmail.com>
 <sfv7zc6jboy2oxv7zuyofysas4ncbzenwsuzveiyduisfr6i7q@mx23er7uxdbg>
 <CACCo2jkDuwy5w_yhX8833m+s-rY736pk8xtKjxg3_y_7BCOHeg@mail.gmail.com>
 <24420045-a6eb-4999-ab19-1e344eaba8a4@app.fastmail.com>
 <20260625-atomkraftgegner-hunger-kursbuch-b452ff2becab@brauner>
Subject: Re: [PATCH 0/2] fs: support $ORIGIN in ELF interpreter paths
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 283CD18000D
X-Stat-Signature: amrjo47qcitdo8kqyfsmkn1fbm8q8ihi
X-HE-Tag: 1782416096-435952
X-HE-Meta: U2FsdGVkX18ISoHJDP1UBQzaidtXKYLKtQjdHEJNh/r3S06yAxRuD2tbjHT8ZgcjYQtAI0ddpEPfCWODF5kbTyJCFfrs6Rm+KVLqLVuBAxRawIHMJuZtr/UdumJyCArAFtWCpOhQR0svRMFFOX+j0t0RI4ZnOL43ZNTXh+SxLRgAwNMnK7AZS/HUaVs+af4s6dKA+5DsNXClcGbA090y4CZFl75KHfvHjJPpfRknAOwlPtR6hx08dT2PLjgB0C0pIEs9eyKLWvWsYqmaVffAsyLhM4UmZqSImElgm4Ly1XvbkbmMYMpVT17emuseGnznO1ZuRVq/68LXkTK2/EiJJA2nsH25Fv4Y80NpIiuTkYxnvy/ekiiE0rr0i1axoxw7C6xv5k3OLj4kbXYIbdM3kMS2lhLn8p5eJa27QP0EyoZl+J/CihVoDT821s3mIkriB7ULDEsXNGi+/EqG92qhAson8rrNe7Tvwe2yVEtjM2WlkSfVwJa03JPU2TLGwwiwjjWFF8qFhAW6WiKIjMzKUdxadyWy5ObtYeRLe3jDlPALLhb85knrowlrU8W6+QxTc08cOMCWTtmp0uTcLmfzrAKyKzGEqdCKLf3mT+dY0rCTjQ9EtjclrKag1Mo43rZ9VeVzk7qYwWm1Ud1ZPfprQheu0b708mJT4pm2faAMKfPy/Vfzq2iDvdHckmvgMRNe/jSo5PxP8QHCDNYRPTvk72Zlq2+xYC0Bk15s820xQW4ECdfvF8E+PvL20Nv+YHlowMbZvAhOPpq1wImLrjEuiRAr3HzcdKFPU7cz/XY2v5kMLj0KA22LMEL2O1n1hDuc0hHUxTBZaKOkMoxGm6YaMvqzjztOfJcsfigdWhQfhMRz13lCnB5kFEpi4drSYDtgoyHkEumoZfVRGrWkB85odpSD0qfX0uBv3blAc/PNII3UFaJB1kcazIXr172ekHlzKsKS+wiGfqBlDqU95RA
 yBSu3zzs
 qnlPw6Y/zm+S14HZSjuNT6NohfStO9BYWY23xxgkYIKP4cQ7Uc/iIll46cMzAS7WJkulC6oUh+PRnUFvebS+13ZX6E8InOUxpyVR103atXEVfb8Yld6Ga0MjoYgFej8whBivmQP8KYnayPvYn0jC11T8lD5lAFFQYCP8XwZa+/89LxxaV7JR1teGsdAdzMha1kEiX/u5Ry0kfVYoJChst0BZIgYIbBaQbNXamqy8omSYH3B/r/L8NtGjlyphDQxqRPNxVsFn032XgiI0UXauiP749A2LexF0sfoA8hlu23nrNsCBQUkQY1xRMMea1JZf9FDZ/I75Lq2CHGQS2t7iHxdbFiM6R42adXhncycDNEJ1hmUsrQ5U6cDULLkW+jgSMUp/sLEjYR8WzcgCsSAiY+bU+vQyg3lQ6oGVRCMqIOnWwkuRROsHHW6RjJr5SZw1PDzY1eYcF3Y52oCkcSJNhZLXKnuIC51j5RokowbGnBtxvgug=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026, at 4:50 AM, Christian Brauner wrote:
> Also, we change long-standing kernel behavior which will be very
> surprising for any userspace that might implicitly rely on the fact
> that the system loader is used. So even if we were to do something
> like this it would very likely have to be configurable in some way.

Yes that's definitely something that worried me.

> So I'm not enthusiastic about this. I want this to be consistent.

For what it's worth, I somewhat wish the `PT_INTERP` field didn't exist
at all. IMO the ELF spec is very weird for some parts of the same
headers being for the kernel, and the other parts being for userspace.
If there were separate data structures (think encapsulated packets) so
it was crystal clear who was responsible for what, we wouldn't be in
this situation.

While I earlier complained that our
<https://github.com/Mic92/wrap-buddy> work-around was likely to make
some security analyses/policies go haywire, arguably it implements this
behavior: from the kernel's perspective, everything is statically
linked, and the program, entirely in userspace, takes responsibility for
whatever loading it needs.

Put that way, this is less of an ugly work-around than the way I wish
things worked period in a world without `PT_INTERP`. Dynamic linking
would be entirely a userspace concern and the kernel would not know or
care.

----

What about shebangs? It's the same problem, with the same solutions and
pitfalls. We can also make wrapper executables around them that do the
right thing, but turning mere scripts into statically linked binaries is
a bit heavier. I assume the answer is the same, but just want to double
check before we close this off.

Cheers,

John

