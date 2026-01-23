Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFB58D6CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 04:47:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7CD76B03A9; Thu, 22 Jan 2026 23:47:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2A2C6B03AA; Thu, 22 Jan 2026 23:47:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D56E56B03AB; Thu, 22 Jan 2026 23:47:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C386E6B03A9
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 23:47:06 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6B3751B0915
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:07:28 +0000 (UTC)
X-FDA: 84361440576.24.272D66E
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf13.hostedemail.com (Postfix) with ESMTP id 83C7020002
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:07:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JHWu2aJK;
	spf=pass (imf13.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769130446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rGyoSW/WPLql4+7CUc24ElsVpc6sE1CN7vPApzpWu84=;
	b=tCa3lPdzof7i/PpJK4MJr9g7T98x+7k3Tl1mCLv/2v7BCbU8H3qsiDIaoZiKUVhAbbinuO
	NlkTKQz1QtUVlUc1QCcywCqW9V3tDjLktzbldjJgELOamuzhW2EBsP6lMofxcdHRBf84CX
	NQJApusTVFK+TYE4Iwv20Ez6v9fOGtI=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JHWu2aJK;
	spf=pass (imf13.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769130446; a=rsa-sha256;
	cv=pass;
	b=k7/T7IGYUV+hbPB8m6sMt93CULuModRLtOzt1qbE5S9THX5ZC5I3jrmUeeZC/2ZWLaukK8
	wt4wS8fvdmj/TSXEIktCp/6QCiRJrwfvbeIW8SEMr/6AT3U1BVhTpW+nBd/2qb8O/kC16b
	L71DVICp3WfDWHCfvGCXTe6FOL/iE+g=
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-59b7be7496dso1748284e87.0
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:07:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769130445; cv=none;
        d=google.com; s=arc-20240605;
        b=Z/yNSQpdb2oXBdLcgyklKyYkQ6pR0szs2+NNy3xxThrpUGY4Tv7zO/ZvJGm+CLbzVw
         kUqTFAI5QG9DY5cgUyzv30/KxVGt27ZYlQIILDJpbtpk/Or6S0WDvlfdhFk/NJF1zSRZ
         TAh+gLDsubQSLL8DI7ZiCmMTmFgub76t/EUbIXS8Ltj/d+Rg9a25TqAcLqHTSXjtspOq
         xZxePomvp0V/5vhUyLW0e8fFceiNrSEuDyaqsE9vCGHYrLoR4PFYWlX5AEiQooILAFq9
         SCvrXsWQo3AQW2Ctxe5dcdE9l5rYXZrh0NtTppJ6/Ep3EHzH5l5xeSCrqIXfacvFyQ06
         qE/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rGyoSW/WPLql4+7CUc24ElsVpc6sE1CN7vPApzpWu84=;
        fh=ca28HEEznYg4rup064hJQFPqBCzWbcPJ7b8i1jXxfrM=;
        b=Xywu/h07USw7OJLR6g4SasaSlW4oPtQTwyWVhnHDTPZL77VMFLQuRHj7secFi25g0W
         QS4h+12Gb167+QTclWNkzpygEFPqiVLZ2M6ThmKB3eoOpsCeUPmwn3YdZ0z0ZG1GZTyY
         KQBC0dy/s/6dxz/b84+tjGq/sCM0mgawAyNfXZn16wHX0uOdxuLwg4b7rMMGmR4J13vx
         7JDTB2X/tt+adPj/F1HRUfQMUopUu05d1jUDD4BiwN/xX09IH2/gcSvdYXGQkB9tUjcZ
         +e60sVx6pgt/3i27j7hPbetBGNpRb4kGhMaAJlvdiTsHzm/P+4B7fco8lCQlOCMNZT9h
         z8og==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769130445; x=1769735245; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rGyoSW/WPLql4+7CUc24ElsVpc6sE1CN7vPApzpWu84=;
        b=JHWu2aJKnEL/tO4if+kwpmrEOyLudYX1Wx0zcMHqV45IhmpelJ8NdOHT2OlfGcxKv9
         pcrCFbFVFNFOsBvFKriCBSH55xkuSgZv4QssskUCmi3mhzyInwv9wa/tALreJBxnoeGi
         tUYgu6XoZCu1sG4XnxYbhfmpBxVROCp3u5CxUCey4XvxHsRQZRTIUfYPw+OQ7CsBYdsq
         mT4c4u+u3g0WGhl0IU9M3cctr3wA2kSGLS8R8CNlGhjGLw67DTsRrAORobRL9flB+4bF
         OFZPYiOFn2XR6AjlIA9zEnoHYa4naC1abDvFj6J3FWVkI1DD+U4zdOI9FySS7f40y/9O
         Gjbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769130445; x=1769735245;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rGyoSW/WPLql4+7CUc24ElsVpc6sE1CN7vPApzpWu84=;
        b=IRq2hV9L+NT3kgbsT2tv2WcJZ1qrHmro+foPl1II4CaUe9OvvrUL7cxwWp62J+FHEr
         0WPJvA1d1AmC/9eJj4Nc4VDhI8PtrphNKkkatU4TQmRJ2bWGFKeKufaUym0ATi1xNp5u
         Ged/0puJLt8cZ/Hepn68XfqZKamm5Wsi6lpfQYjjHEyxFt0Sg17OUpdTm5gOB+ggx0oQ
         mVITStpktqSBniWRJAu0j+5F4dt/LY7YCFd+Lj/GA9IMb5dwrGK2dRxl4Nj/y4DcgSOB
         QZn1U1FqxmrpbZZxuVNw6moIcaUi6pVAtf/aFvoKiD2mFOTgF8m18jBI+b03y6w2T1ae
         XOYQ==
X-Forwarded-Encrypted: i=1; AJvYcCWiEffcihM0I6ojij8Wiw29d9h07SesdDh4NLe8WBd2oQJEI/Ouh4ctEZjJ/s8xFYMhEfQLziXjYg==@kvack.org
X-Gm-Message-State: AOJu0YzvhVoHvScYRCyw5kbsWakgfJgiuglWByQh8QcQMJR3DGY91t19
	cLqYqAqpL8WIL6JgVA4OALxewwro05mRYq+USK/2MKYBPMorFyl1aXNFeruJkorwN4DOi6zSziy
	B1eqmidkVEZJD+G1KTVuxfa7nq4fRdn4=
X-Gm-Gg: AZuq6aLgr1Qj9gPudbgR/oEqIyCxYZU/X5XfM5pu3a0oe8tRGfmWF2datGmzQ91fPkG
	iFgA2HveyWOaSscvnVUJwLbpqox8DLzd9UN5cLcnTrALz4eqdr94kwcG2k/YPrm1Qha1Jhq7dPw
	Uvy0Gw6+G5aP8jnpMmqakVsSDFP0/KPHZ+gr3ksq2arDJIUCezEaaCnqEfiPir1ufjo5viHS3M7
	BR3rdb4DigZkC4exR4ys7RtRYWSA1ninTxCUXjG2YtG4eRuwFWI7CWV3JkcxJwB+HrQ
X-Received: by 2002:a05:6512:3408:b0:59b:7c03:f2f3 with SMTP id
 2adb3069b0e04-59de490d696mr399706e87.16.1769130444163; Thu, 22 Jan 2026
 17:07:24 -0800 (PST)
MIME-Version: 1.0
References: <20260110042249.31960-1-jianyuew@nvidia.com> <20260122114242.72139-1-wujianyue000@gmail.com>
 <20260122091351.0cc1afd5d419fafa1d98b32f@linux-foundation.org> <aXKRIOpDrZG37_wz@linux.dev>
In-Reply-To: <aXKRIOpDrZG37_wz@linux.dev>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Fri, 23 Jan 2026 09:07:13 +0800
X-Gm-Features: AZwV_Qgio7l1Tz4KXAornt7DlVb5tk0mkWvHJrP1iqEKzzaPj3CCOYauPVz9-7A
Message-ID: <CAJxJ_jgGCL8WcyAO1iyF5Eu+6JtcemAPGs-WMFAaHdaM8V3uDA@mail.gmail.com>
Subject: Re: [PATCH v3] mm: optimize stat output for 11% sys time reduce
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, inwardvessel@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 65ge4yso41in5kcs4xhji3ijhufx4yzw
X-Rspamd-Queue-Id: 83C7020002
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769130446-218125
X-HE-Meta: U2FsdGVkX1+5rJGqyhjq7QbFb0E9rgfdyle8OhKHID+aqRN3j5yc0KlBMwwOllGpO5gs6Yp+0wsqLgGCS1+jXOWvQll9DM26D5bZ5fECHNwbf7BhLpkPV/YoLvdVHSChy4dgwAr/PceMuKpoIiqfq7XH8H7k1SO29ZIxiAxh0aPBVfu+KlyRx47vBgZ0SVe0r0Axtks94DOSWC7vb4zvE1Xh1B8BcVBEfsmPnEB60vp/ExIcTDI5MppC2eacJzabeza0UbN3dcIQVKjrA9wXtaMQU6rYwlhpM9D9YxDixN53jf9YQ74eUv6G89gho+sZM6tiY8PcwzrwMR2K6S72GcWLcL9Mq4MU2HbKoP3+b5nNBamB/0HyexHlIcxKaVSnrMmaP4NU4yBdP4LqkjsZnn3MycYfAt2FRMA6u/dk59pQ2r2M2FfyZS7LxcRP6R7Iw5IvJqHH8pM7+BMybu31TEygKFut+dM9c8mgA5kfIKF3OPw97x/qzaON6X5GMmumWyKnxQugdTxlWI7uGMNb7bEaGcLSyAhRsC2lgQ2fSoiP+nl49p474G0YxdXeID4GqRdb8KE3L23C2KoKdf+T/oHWWeeSDYmdqIgIpRANzfvg3BjidpdraLAha0A2JJkDylxwpKPqmfOYVzNzO4th/I20vYqTvlm7UGHdCNDlDxDwekiGgbRWrSid7dFbIJuSY7E5fcZZMMt68IiDdKBrl6pNx3VDQ8BVf8fG3gJb5fRBfd9x+QGPAqich4RlFYPEGgUyK8DmbZWCe04rK5KGfcAORXrVISJUuhJML43y/AlZltXxCaAthtWMlURzxshl2nN5Bjk92LFD6p7rzrMatgBgPjRf604Tm1hCdon23Sj6w2+JEtx7EPpWeX1i+OtK2dvN7UG3LNOIrDR3quQbAPreRgIdWcTw03sZ/MoGnJjCbSUipX3MKzpptE4hzCB2JtkSvCT+Rs/U5QpZzo9
 uSAnVNM8
 m3RsAKB0xe8R9XuWL0rOiI1J/iIHF/rz1gDD6VDkCBfvRlwv2QvDObQFHxA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.004266, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 5:12=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Thu, Jan 22, 2026 at 09:13:51AM -0800, Andrew Morton wrote:
> > On Thu, 22 Jan 2026 19:42:42 +0800 Jianyue Wu <wujianyue000@gmail.com> =
wrote:
> > So the tl;dr here is "vfprintf() is slow".
> >
> > It's quite a large change, although not a complex one.
> >
> > Do we need to change so much?  Would some subset of these changes
> > provide most of the benefit?
> >
> > It does rather uglify things so there's a risk that helpful people will
> > send "cleanups" which switch back to using *printf*.  Explanatory code
> > comments would help prevent that but we'd need a lot of them.
> >
> > I dunno, what do people think?  Does the benefit justify the change?
>
> It does come with significant benefit but there is no urgency and we can
> definitely decrease the ugliness. JP told me he has some ideas to
> improve this.
>
> Andrew, let's skip this patch for the upcoming merge window and you can
> drop it from mm-tree if it is a burden.
>
Agree. This touches a lot of code and increases complexity, which is a
significant
downside. If there are ideas to improve it, that=E2=80=99d be great.
I=E2=80=99m OK with dropping it for the upcoming merge window, and drop it =
if
it is a burden.

