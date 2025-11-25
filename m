Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BF12D0EE0D
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 17:39:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0E976B00A7; Tue, 25 Nov 2025 12:39:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE5F16B00A9; Tue, 25 Nov 2025 12:39:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFC066B00AA; Tue, 25 Nov 2025 12:39:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AA2B46B00A7
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 12:39:17 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 70A02C029F
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 17:39:17 +0000 (UTC)
X-FDA: 84149840754.23.89FFDED
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8238C4001C
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 17:39:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SvI2kSmt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764092355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PLo5aywFjTXSQv3nvb08ro0yKuqd+UtJdtebi0hWe6g=;
	b=7DcuMUHfcNTUVKTPkHs0ENN6pnFIf9bcfd4f8gb5TOpPySIvt0+KoPUI+UbiZbUQoAMzuS
	6bdEz8Uowy8jd3RDgRxjOnBzNTqrY7nSpenVMC5Bdohpbomc0v7wafRqB9xcPjpnxm1GIK
	PlZ5SbHrVFt0yt/h2lEiSiXPOpmwTEs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SvI2kSmt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764092355; a=rsa-sha256;
	cv=none;
	b=pPcLkcTJ4WtTnk2Z4OXePlEYXNAGKd6XuO3ohv2D5TCGQtCUuWRQSciYzJ2pnYJzjf50V8
	opu2W7zuqm7mN+3Qk9vL505Sxc6LSg8biAIszBwqfc4YKaBRlGJtpkC6Qh6XJWlwQqIYil
	0XtN/qR1vDTrFFfF/uHCkx4KHjWHS8s=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-64088c6b309so9444506a12.0
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 09:39:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764092354; x=1764697154; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PLo5aywFjTXSQv3nvb08ro0yKuqd+UtJdtebi0hWe6g=;
        b=SvI2kSmteVQmlPLFcXXHzeWkm4DY7Lmwjp4Cwoy/Xs8pLNmdj/TnigSSO25htCw4kF
         z2CgPdtWYKTMsi8dsVBAfLkVJBsB8qEXf+wxnQZx0DbOYS0EGl2Di8VKtZcK+yGj1yUf
         XBjQN7NEGuyoADpH2Fp6nUJLSqVt0cD9yYFdvWoJleahNj3iT8NeFPGY4VPF+qNqvDNs
         sUakQKfYMDxsHTjwFH0V8mjApmvbwbE47J632/bkIpl2dWghfRhFl1Q9WmQ7Zbbq/xn4
         4I/I8/uB3EMMpTGdZ6QXg7rKeRXIHDIEEqpNhRiOW5D1BJJo/qDjknmPGTy70FMRh18p
         EJ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764092354; x=1764697154;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PLo5aywFjTXSQv3nvb08ro0yKuqd+UtJdtebi0hWe6g=;
        b=vlXhILBBOnbch9CuT6J5Oal6RnsAj6MhRXAJmYPWDX7Y6NC5qSn/S0nYga/4FwtTOH
         UXDb0IJC73nkQuyEHGi8qcfSnoHihfoRh9R+hyJK05R6kGs35srGFenqP9xxd5ty5O0X
         +wg42jzQ0YAQtV2qU/R1owlXfx1aZxtkAq8H8NJ8SCoC1Bonc9l3B6LW4gAed2vAMclS
         7yhwGgCL5ks1N6bfPINjbU9VYEk3Y6SsLoGdmOh1HcoV1Ft789GLFKNMRa8RaU/6xA3u
         5pfJJPSvwAyHRn7sUpTBjajo9e0PBGWrqeo84cc/tv/oO+D8I46wOdDSd8mSzSkTx3cC
         3l8w==
X-Forwarded-Encrypted: i=1; AJvYcCXTp6kLndCZjTppRwR+FuScgMCPaydLAdssJjPvT9+UdDSACkCrmE//PQMNSYHh6WFaOJb/fHC2Aw==@kvack.org
X-Gm-Message-State: AOJu0Yyyl5ArfO4MrX4Zi9hHGWvzdtmZPHy+rR36E9TLH+YP2UIaTSWv
	SP12o9cyDHe7HXj36vzaWezJU1lIbwKQsbGKCkoy22TWQBwTMrv/O1glROpw/G9nV6oaw7dawp8
	uu1DZzrDRurlhK1lcgCev/WDtUV54BPw=
X-Gm-Gg: ASbGncvSDAqTlY0W6LJXq+wTjFZYhr1Q+H3T1D6L8oI6fDJ4/FCJMPVg5a7ZRkhzz2u
	gSk8Tl2CcgT18JOE36C9Jv/q0uAuFEKNQvfC1vnYk1jFepXYlb0tigUisSy9CwkvzL1CRoYSSpL
	I5nFI5mEAA1dubt8C+GrF1qhuJFyKJ/7Fw93aWwoNdBm30dqfHgqnBE1EHM9O46T62kuvbBW3/g
	iRWEv9Byw+lXXYlD+HJ57rIiYm1dyFbVuqLHgljk1oG+RsAlkS6tt7w+wkq/ULrQ3L5A6xtRjJH
	rOyuGRI5oTp/vAB/A/H4lBOQESk=
X-Google-Smtp-Source: AGHT+IGl0uAb18fsjV78ScdhdmsexuDhZTVBMIVIE0mSYI1A/3YBXhMw4U/QXxd3ivuAoH0mgxxoss3lhAwCNVVGKy4=
X-Received: by 2002:a05:6402:5213:b0:643:8183:7912 with SMTP id
 4fb4d7f45d1cf-64555b9a93emr12808906a12.9.1764092353665; Tue, 25 Nov 2025
 09:39:13 -0800 (PST)
MIME-Version: 1.0
References: <cover.1763976541.git.baolin.wang@linux.alibaba.com> <CAGsJ_4wNiKfKpTPKUNim6-X=KiMxhp_9sPh+hkh8gB8AR2ue7g@mail.gmail.com>
In-Reply-To: <CAGsJ_4wNiKfKpTPKUNim6-X=KiMxhp_9sPh+hkh8gB8AR2ue7g@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 26 Nov 2025 01:38:37 +0800
X-Gm-Features: AWmQ_bkX3LENYgmlshIWTNXHI_rEPkBbJuc2ZxmMYxnOrxDwU11PVyntCGgYSDM
Message-ID: <CAMgjq7BJ0uHCWoZgum+19dk=_tgkT1vLu0Qs=4dFEe0go1UTRA@mail.gmail.com>
Subject: Re: [PATCH 0/2] support batched checks of the references for large folios
To: Barry Song <21cnbao@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org, 
	david@kernel.org, catalin.marinas@arm.com, will@kernel.org, 
	lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	riel@surriel.com, harry.yoo@oracle.com, jannh@google.com, willy@infradead.org, 
	Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 8238C4001C
X-Rspamd-Server: rspam11
X-Stat-Signature: ib9hpi8pfsaikatc9sse4dxwbqau7d9s
X-HE-Tag: 1764092355-630852
X-HE-Meta: U2FsdGVkX1/airjntuRhM6Av3SRYVYyszdsG/Lz6dUD4fek50Br8U88wKPa7N+6HRIa5K1mwl1htcOr3LNGUgT8WUv7ZlIwwsKuNHAgwUoJ3A6BoKFtplVq4JIHRSij3RK0KStVON/Z7lnEr/TSusY2xuD26EOV/dSDCxHRk/oj6FN5s3L5yLVToPDstgc81TzQ5U2VtUlpItgLUSlh2I6w3anQo67caPwdAuboSDgNhEz1IsS/+hmuizhoZTSFOZycWjNDBTdDTXlSTXZYeV9Ix9Hsx/B6DCPHgVa7idp2V4wjRnI3TI7I0itIhk8E3WUNAgvsIarq7UQ/Krh4QUEJtzI64yUrI26tzndi8b3grVWdyuAVP54H6jVBdNdkDjiyaZjkrEzezgv/H4yM+UyiA428ioyudBVel/KfqHpWEh7PzxQ6/4qAlqw2cH9TEorYX7UJ6FNey3rT9Kta2rBNt/EdsGubx6F6iefi/lhvbfGN1k+KW+5D8csebgCN5KH4nOZPaajNPC0GxEVt/o7W2OIinI1h+9VBzWKRjQrF07og6L10JnK1MQ5P+kRK/Wqd1Dx9OxZws79d6A77dACkGoayCVWbeVUUfG0TrhtEsVDK1lfNVuMInUnsLkbmMk7v1CAfjbRgHsJr7QMwNcsPBT0yf9iUrbyjBi98Wlbs3NpoiNe7L76otdNrH30U7rgqxE2op3bAwTI4LaTaI+S5h3cVgNdSbTTVDFHsm3QFDnoiu5SoZPto/xllsMndy88caIp1/7F0UVr/ONT121DoSOtyeoCYdehOCq+PqyRzQKM6pT6Pi5lo+dzSJXMKQ37V3wI2PQf2tNqhxEmPRkWQG4UlP4gQl9RSZRnq65UcRqKoBOqvrDxG3Ai0mm3c3bMhJ02C+sXG1/I6g7/S7YC4i94yHO0Q6WsE0sesrG7Jz1YmSoFAoKTCzmdkW29qRs9oJtyKUorYN00s6xEJ
 LqnZmK5c
 tpggB/yToxe+fYOFpFX1YJttRfRd5D7qnRHCtWOmC34cKrENiAYw7ehrxi77vXa6TB90pFJXwtuTsh2dDCPNq0a2L7fU+talVYXfemWDzx9ZR27z0ScrlsNo7DWuGFPHGN874c2/GGQYRR1MtTO6HaAq0LzaadvJ14UWGu6cXgq4giT6j/tdbN4eY+qnh5C9zCCW0qdnIWkIkw9ONlNeepFWnHFoizG7HaLXIK4pxxWCDlZqWHxs8y5C3eTFy0TPTUcCh8jl0LdUHPgyazsVO0+h3OaAt/CQz6DOnBMOigyGVnk5Q/f6bZk1pUJD7w90Ktxfq8OQRmjdUVJcZjw1lgKMyS5LIpoq/7SNrZuNP7h/rsX48mTgT+e9s/JfSvee6mld/Krh1R75sZDbsajzZRsCYZEnmHTj47dTPG0u0ERhqbL0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 6:15=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> Hi Baolin,
>
> On Tue, Nov 25, 2025 at 8:57=E2=80=AFAM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
> >
> > Currently, folio_referenced_one() always checks the young flag for each=
 PTE
> > sequentially, which is inefficient for large folios. This inefficiency =
is
> > especially noticeable when reclaiming clean file-backed large folios, w=
here
> > folio_referenced() is observed as a significant performance hotspot.
> >
> > Moreover, on Arm architecture, which supports contiguous PTEs, there is=
 already
> > an optimization to clear the young flags for PTEs within a contiguous r=
ange.
> > However, this is not sufficient. We can extend this to perform batched =
operations
> > for the entire large folio (which might exceed the contiguous range: CO=
NT_PTE_SIZE).
> >
> > By supporting batched checking of the young flags and flushing TLB entr=
ies,
> > I observed a 33% performance improvement in my file-backed folios recla=
im tests.
>
> nice!
>
> >
> > BTW, I still noticed a hotspot in try_to_unmap() in my test. Hope Barry=
 can
> > resend the optimization patch for try_to_unmap() [1].
>
> Thanks for waking me up. Yes, it's still on my list=E2=80=94I've just had=
 a lot of
> non-technical issues come up that seriously slowed my progress. Sorry for
> the delay.
>
> And I suppose we also need that for try_to_migrate().
>
> >
> > [1] https://lore.kernel.org/all/20250513084620.58231-1-21cnbao@gmail.co=
m/

Hi Barry, Baolin.

About the try_to_unmap part, I also noticed that patch and the comment
issue "We only support batched swap_duplicate() for unmapping" in that
patch. I guess one reason is add_swap_count_continuation right? That
limitation will be killed by swap table phase 3:

It can be previewed here:
https://lore.kernel.org/linux-mm/20250514201729.48420-28-ryncsn@gmail.com/

And I think we will be able to handle that much easier by then. Sorry
that it is taking a while to land upstream though.

