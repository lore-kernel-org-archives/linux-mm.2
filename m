Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DF38CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 02:30:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8150890002F; Tue, 12 Aug 2025 22:30:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C5348E019E; Tue, 12 Aug 2025 22:30:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68D1390002F; Tue, 12 Aug 2025 22:30:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5134B8E019E
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 22:30:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1CB001167E6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 02:30:10 +0000 (UTC)
X-FDA: 83770154580.26.91ABF52
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2B4602000A
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 02:30:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U0focZSp;
	spf=pass (imf03.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.161.46 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755052208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1iJ3fy26qNpnuJDocl05IX/Jr0WaaCnqMDH+qK1cFXY=;
	b=sCv5mCqj09aeJq6FhxD7qlC6ZjLVrNUnYgOsw68X3IX5QfyXmCz2mwIJ63et1W01W08M0p
	tTWrwrY334gKncPKb4Bsn3ER7vVlig4qWWawWaWju3vnqXBdtHcbwpg4s2X5BYTzXAg1ZP
	3FvAvtPOIoEv93h/Jz5GfVULBujay04=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U0focZSp;
	spf=pass (imf03.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.161.46 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755052208; a=rsa-sha256;
	cv=none;
	b=UF7jfyzEvcwD16MEK+wE+2mem0nG21huhbCY0pcOzk2BBiUq4uh5XvYVmtiRuOUA2ZddLK
	7MmB/B0OMxkefKvlg6RBJj/PbkeKioEgO9ONIe2LmgvfiHO9/mG58IrgoWFzYyizn/VmL3
	WBuiI+nmsLqKLGq/rZJBxsVGv6c8fcU=
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-61bc52fd7a4so285735eaf.0
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 19:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755052207; x=1755657007; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1iJ3fy26qNpnuJDocl05IX/Jr0WaaCnqMDH+qK1cFXY=;
        b=U0focZSpvI5FlW8hoAbpA44aJSc3V3c9CFLLZJj/7NWCP96XiuZw3UNo59qUEXO98x
         +WcGY3C0M4AhXE9JS5ZT0Zg+Ec//ZVb6KWrqlXRTRLxC1TvpQ5QFYMC0uJAesCp2NhzP
         KnozJE10AYp41VeTI+Wk5d2P9OMPDxrVCdX8zsXC+l1+VC1u8larBiwVGCoi68zyfm8s
         Rq9Suc6i+pO33d7PFc1lGE6B0A4eeG8BR13jj2y2hNI/bj93z54I/nTwPIQE/8VgNaCl
         3wjJvOEjXVsXldzh6g3vr5EC+62gWIO+m0rNr1KsQ0Rxky+zkB2OzpBPGAzlIPl7EIpl
         7M4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755052207; x=1755657007;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1iJ3fy26qNpnuJDocl05IX/Jr0WaaCnqMDH+qK1cFXY=;
        b=EtxlMrgdYJKFwUxUNw2uh1Qh6uyCL8d2VUYHvBauZjPD8fH5GPIL+ZCIdAWNZh7vPe
         TM4d0FtnEBejS22GYCpw3FYt4ACzOxtQvK03bQsA7Vep/7R48srLRDVBaYhyb9HPymyn
         vOuLYlkZnBcvG4zK+fz4ePXL1Qe4I9MQ4mWTHYGM94YWjK9EyPOp05V/YLbnwTO9hPXM
         e9dTrW43OwLZEYYelTUNqQPZKzlJGkgvRL4PxUaetIK4I7MVQet4sievPmAf4rY9ZhQ3
         TKJgMt8TjhUuFdjVkyUo1IXOLV8Tk4o+fy1nE7I1S3GGyk+BYsO+VtR/tmpIAkbWK790
         feOw==
X-Forwarded-Encrypted: i=1; AJvYcCXyWOA2dLyxuHmAxXWK20xtzc8KrAXJhiV+wt/nYL/OvMzn6JlfrYDuTwj6h+8toAptt8D3SwrR7Q==@kvack.org
X-Gm-Message-State: AOJu0Yww01AuzwbAUWdTcRtVTEWrKh56ZFjjj6lHXnW4ozSgTUODoYK6
	/lv+aWh1TphjryqUxeixFDMvO5LzotchMDMZaKH7iDPY6PlVYjF4JbsqRMuCwpdIPv52B6BkkMW
	8xfZowVEfE2XLig5xw9AbMVpoqXowdhY=
X-Gm-Gg: ASbGncvbujEfAftGLsEm2+Niuk24bmw3yfo2WarXQpbamALJwr11Zqh6jaVDr3py29B
	vyDZIm7l2HCRL/WQAfeY8hYxSQrsAXkQgFkgNFPTx3QpEoejiQ+Es/4oCFPTor6hQjO5hw/vySt
	dUs9AdMdRj4uVpr6gyp/c1O+Fhz1aLwwLvU0tBB2Sxr8SjxPwvb9K6Zi73s0vINIr1NGcl3la1Q
	YVo
X-Google-Smtp-Source: AGHT+IFu8/eVv3h25CS+PDVey9SJ862VPhA2HFsoEUFWCqaq9DWpbBe2Iai0s6TSEjG8fKnzDi1yuAperEC0PQIv3po=
X-Received: by 2002:a05:6808:1687:b0:434:b72:de0b with SMTP id
 5614622812f47-435d6293de1mr474390b6e.8.1755052207201; Tue, 12 Aug 2025
 19:30:07 -0700 (PDT)
MIME-Version: 1.0
References: <20250812140046.660486-1-ekffu200098@gmail.com>
 <20250812175939.57506-1-sj@kernel.org> <20250812151743.570bde54f31007cf986a2f52@linux-foundation.org>
In-Reply-To: <20250812151743.570bde54f31007cf986a2f52@linux-foundation.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Wed, 13 Aug 2025 11:29:56 +0900
X-Gm-Features: Ac12FXyjyCmdy5Tzo6RVFntUUEEiKnyDu9n0yq3bW9uFdCcLkf7VKBGRRSLMU9c
Message-ID: <CABFDxMHpXJS30nD8-Jp6u00yLqZ2pfgzM-rUqKtoMF1spM0GaQ@mail.gmail.com>
Subject: Re: [PATCH] selftests/damon: fix selftests by installing drgn related script
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>, honggyu.kim@sk.com, damon@lists.linux.dev, 
	linux-mm@kvack.org, Alexandre Ghiti <alexghiti@rivosinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B4602000A
X-Rspamd-Server: rspam06
X-Stat-Signature: 41k7tjn5r66d5qg8k4rg6i49uqn8ep9b
X-HE-Tag: 1755052208-809522
X-HE-Meta: U2FsdGVkX18KLlO16Wgve3sqV2jMkiDbLmfMA5jzqP7mfT4HKsBizT9hAYLO8PKHQaiuYG73niO9R3pSaM6zqQhnUaesVNei5v8i8MMs5wtbbEoPwXdtZKzQjlLRpxNoxiJYTT523Ylmbmel/qKPMwkafYa+FHWqBIO0mypFcGlBVn0xqETNZ2vFTVYtdV5aE8Sp0tPGbdK/ABCu2OW3U66sWMJXZDVlQ0Up2e9vUnZzI6pG0gdyZ6gL3Nw9o/3WJcqtUrUvBrM2D3IcZWBikK4UJ+zYEsczdkvCHpD/En+GWF41m3/EkrQY6ZeWoRmUQz71v6Sjt9zo6R5h4ZoprtX5sfHs/EPN1pbpTDP+zVSQ0CQQd0dR7Sj0+OqNLOalSfTAUtnxnEl8Q1BdbQBXLLndNOMQ/7KmwcRWZxhQN/cYFwHw8L4WJUrncBcVl1eYZB+2j8zcWDzT3ej0PE22fObStqv04q7gswME903p3573+dQqkOIIJMp8uB77hFWHha0yU5BaHda2AJ6kLGff0m1TDLO76xSVPaWScpO12e1lmHdD1n2DmfES86QAQLnI2RSXzGuvPL0azUmTHd48xdaj2J+AMhJfJtwZxIOs1OsgBrY03Y2/g2MjyV5mpOM0IOR0m1QW5+KI8tBXFTbPknnvVgrDCgD0jWbtULBt5WvnAFbjpeZLhZM9tmAihYt1qzEiyNAR921xxnDGFUkJWOlimjBRX73X58rHt8dQz6ZEIStmAIZYaCUJI7T+r+frQFsgS8NPbWrbj0DyRWXhDwOh4LWq95GFo5/jU62DxVv/l8MFCXM1OelzaaYMfrWTE1ODvWrhFFWquMLEgaR3bTu6UPAa1iM+eS6uTWPI6E4mC8O6y91UdXQjBwVZzbVMtMg+MO66MH6zShzZDHRXLFsWapiG4LdvtQL9F/FGdVzDAW2mLRPAWMrlYZjbDn5grhrJUIAEJI891jN/CZd
 bwSQ/CNe
 ZQ8pnkFlNgw+rJLDMTirlFb5LJuXPC6XTdKQmr6oAROkqAuwg2DOtawkSyOgynLi5gN7v+yKmhlhQBllV99QRxGcSpSHssy8g7ff1fK7lXQeBeVnyt+/tZDOqBOQ5Ae/tbV6KFC7AIl5xFQLqWS+oNAAm86Q/kJBt264l3h1r6gU4QzSrcP0L2WJqHZSgpfAJ0fD3k8WVjP9YAc1MlPgdhEJwZDJU8lDXKRYtRzEj1ShkxpG5VBDltSsLPrQ3XaHbZ+LCZaXYBwhhTvTnQLsrMZ8ZQmNXjlcozLXbRFOY7OtqnyLRhF7tsyt/PYC6HNQDmaCkJpoVT5wIr0W63IC6/muaTwHx2obA7k/G5VTiEoft9EBsz3JHUcLM0clQ5J+QtFEfgdx7cXZHXEkqsM6rUIyPaskDWNF1R+XGIEuFUSG1LBWHyyrLOEmzjcOpOxuHKRyjUZb9zdxC/SwRFuW5Igi1DMAtxykDbnDAJDvbG91doTj3LQjCXfU8m7x5zfjhcFVvQral7Bglcl4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Andrew

On Wed, Aug 13, 2025 at 7:17=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Tue, 12 Aug 2025 10:59:39 -0700 SeongJae Park <sj@kernel.org> wrote:
>
> > On Tue, 12 Aug 2025 23:00:46 +0900 Sang-Heon Jeon <ekffu200098@gmail.co=
m> wrote:
> >
> > > drgn_dump_damon_status is not installed while kselftest setup.
> > > It can breaks other tests which depend on drgn_dump_damon_status.
> > > Install drgn_dump_damon_status files to fix broken test.
> >
> > This patch conflicts with the similar one from Alexandre Ghiti.  Could =
you
> > please rebase yours on top of Alexandre's one (and mention the dependen=
cy on
> > the comment section under '---' line), unless Andrew resolves the confl=
ict on
> > his own?
> >
> > >
> > > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > > Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
> >
> > Reviewed-by: SeongJae Park <sj@kernel.org>
>
> I'll add
> Fixes: f3e8e1e51362 ("selftests/damon: add drgn script for extracting dam=
on status")

Thank you for your help. I'll do better next time :)

Best Regards.
Sang-Heon Jeon

