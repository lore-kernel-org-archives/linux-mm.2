Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2E74EF4EC9
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 09:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E7C56B0088; Mon,  6 Apr 2026 05:41:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 698A46B0089; Mon,  6 Apr 2026 05:41:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AE996B008C; Mon,  6 Apr 2026 05:41:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D6106B0088
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 05:41:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E00EF140396
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:41:18 +0000 (UTC)
X-FDA: 84627637836.18.C97C81F
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf01.hostedemail.com (Postfix) with ESMTP id 135C040009
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:41:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=p0LERH7P;
	spf=pass (imf01.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775468477; a=rsa-sha256;
	cv=none;
	b=B2G0U0wJyvn4dhLcg3AB9yvPhVcJenbqga79AXDw+DtI+7sZ2SLfgX8PcCpXVEFSbad4Cb
	ML3gf1VEqVz7Gp7C4nLradubdYzpv5KxkmBTgZxZuDplUjcquAD6VgaJPAWUR+8yZZ0qWI
	9Y4DDSdjd8xRhcmzm2E6o1L1hVcV26I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775468477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=naM+8vOUYX4BBsuu2hLmww3vg6bSX9RuihKL6tlmdKo=;
	b=gTs+ufTc/JLpkV40qw8F5BQAJU0MkTUVRlLtWLpbNB/Aej++/FfeSo2Pa/quKxacI69e8F
	2rP/pxN3FoV3J/Sn3qdxVu+HT33gPgWav45C1W52zkBKDvA5qASw7YgdFTlsR9hLaGHokM
	/IAFwDJ4RX4epP+24xEawYyIZMK94Qo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=p0LERH7P;
	spf=pass (imf01.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2adff872068so16485565ad.1
        for <linux-mm@kvack.org>; Mon, 06 Apr 2026 02:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775468476; x=1776073276; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=naM+8vOUYX4BBsuu2hLmww3vg6bSX9RuihKL6tlmdKo=;
        b=p0LERH7PwgUkR/7K3W1XKVnqxfBvXnhpJm7ZI56xQkzhPnK3PPMVX/PVGdiA7eFYVK
         iohWsW19lOxZPOI9stsTCfG+r1nzYS1NwCUa6fgUlYRT5pGmyphsDvzYWDP191DMlec5
         M99wgvnYC83Tta1E3mCc8eQEBNoyGvp5/BwlIazs/BVv34tjCzr6Yp085gmzrmTLvwY+
         9uuEFYcQcra7Dci97E6NdWziGDArLw0t4yq9uVsvIDczsrnTXR1+K5zBGvSmCF3b/wxZ
         n7/q10pSYk0Zb7rwsnU/uOP5ndyfVbwE0PUVYPspvXrqKfP3+au6RsP0ASFR5JWJ1RkI
         5IIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775468476; x=1776073276;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=naM+8vOUYX4BBsuu2hLmww3vg6bSX9RuihKL6tlmdKo=;
        b=J/UjATSHI8bHd/FYR4xTdjUUHVdOronjGPP0oKcRY2SF//IxcGfJ0le2p9eudUA2HT
         pHLmosgtBEoVzawmSWNOGlhrccf3RcjmzFjECgdSEnCo9XRMa5GhEZPBrpjRak5OkJVZ
         VGSfPYJrr9JpwTy5oW8U+eNWoz8txcLMGslBIbgA0CYQt7/gtplyx4J8GCIYTB/3VQ2p
         vjd6B/EQWoisImQGMUmFudmHXpiw+OvUwrC/SD4w1+I9bLqaBOFXujkT6/Lwjb4IL1XI
         BnnkdHAxCG06qJqYK4OZ+Jmt+br3muJyfUBI89JYNj8TIMozvNmFocjrmascMvTRre7F
         8Hfg==
X-Forwarded-Encrypted: i=1; AJvYcCWwPLIEXqeVgWkRGfD8jLwKrbHpzI50BBIoxzVGOSl+IYSd6R4Bv2/VHe+f3AAr07aV3grzhupZbQ==@kvack.org
X-Gm-Message-State: AOJu0YyXxKnsy/inXKftHNJ7K8YOe1lxL81/3EQFpFiF/8BH2CogNXR1
	RYaPvcsWdebLs/H4CHQJVZKtgiM9C8NUVcGRKHczQgHOO+uytxWqODmM
X-Gm-Gg: AeBDiesYv6OXVreahmaQ1mnH0Pxj7V378wDqyMM2vVQ5Z0LaByiS/Gfn1I0M69FxUrK
	n9V1zbStCvfVqYEXLPZuf6i3sHdgay363D9nJdUzEsFjcuR3gqK7qsd9h26J7YiIC3zmN4u6n1u
	i55EwXET6K3d4CdYN/eqSh2DJk67IzekCFT23dijgvpUrRSjVTvKKCtMoWAM4NcThdX/rxm2C9/
	0RMa5NuVg7haaGUExf+iAaf/6Ini3+YbblSvlSgKxta+C+zxBbUtw4TgTJ6rY/YHThezAshrTGT
	bQ6T1sb8yN352HMBaK/qsi+Rfc/1swxW/96ZA0xsDir0J9wG+ONxI9waDlKUBn/AKrUYYAJn7hh
	RGjVy51NBVNFBA5E4WKrKMsODXTeMBxRZNkhsFXDMERcmGjT5U3iuuckFgGmQP4MofpQUuxg//S
	XcpuurEtFHLjVrjP+qXUocHKWB6GbmTPBS9+Hw0IFGpcWhGhPIplg=
X-Received: by 2002:a17:903:1ae5:b0:2b0:6ce3:8f7 with SMTP id d9443c01a7336-2b281927e08mr117023575ad.43.1775468475827;
        Mon, 06 Apr 2026 02:41:15 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b27477736dsm130327805ad.24.2026.04.06.02.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2026 02:41:15 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 1/2] mm/damon/lru_sort: validate min_region_size to be power of 2
Date: Mon,  6 Apr 2026 17:41:16 +0800
Message-ID: <20260406094116.13164-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260404203044.86655-1-sj@kernel.org>
References: <20260404203044.86655-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 135C040009
X-Stat-Signature: eegu3ozbhogxo3nzgzsafpeo78pshmmz
X-HE-Tag: 1775468476-525253
X-HE-Meta: U2FsdGVkX1+eJGRXkNm8Ac3e2jgUzd1TP6BwC8DvP9JFsrllOvGpPKvR2pDW6Zmb1O/+bJHygCasggKgBOl0PbMrrFjX0CIIctmgJybQMmVKvsXg+WrFZ0E6rwJqkidlFGuK+Ls3RiDVoXQTghaHsNqD3FAiRBoR6KWrsB5iJcOX2Mck3w25eBt4TMHVuITbHtoZzwUdO9GMRCLaiOFCfL7kBTYUq6BAdbx/9YcSVkPN/ugQMpbPw+UKC6p08SHFocmDDQNqbHkZF0niLcyORcQCvvQ9q5xSobmt79QNQLQTcvZrzRZsoE/6c1mmrsP/pmmdNzy7gQhuOuwBBGcWw1tjGqpgAhS5GPXa2RIn2ccrQv38rI+01chW1gIzha5rCvLBrJYaKIsLVjVZTKZDd89zixnt8wYoZqy3ePej9vNsKO679ljV5dGtGK76McmTwGLihnJzO8yv3jHULj3W84mYbCh73XzXEkBdF+uLEg7O94yKr9MZ6ssG5atiidalFWSfeXOcQ8ZyDAT2t/5k5XT03VXESjs2sn9B/ttTxfxcKsx3kLUAc0ii3HnAZoEx7ee+cCoCArvJ6PRJjALlFRnNmD8Q8JOs7bGp9r6KFdh71fMa1WQ6e/E9Hm2/Q+ywetbrRK0CD5KJBxtlUkBqyT3saMsi+diVdLTtIZGMXBiIGcI4AUZ7kaqncQovXHgVlbDRTw6py6n2NxuJLSz4CskhIBLVxDgCoC3HoEL0FY2HDBSmTNbmijwsF06jxOreVtezr+ZC0RX7w+eL9cVDwRC4EaafS8eOBq42VZ12pvOp8sYQ744PoFKfnXJTV+WfAgL8nEO5xtvXxSrK/4E64WJdkYJn+w8ZYVfPcuG/lHD+TTavbc1evBQZi1SVW3/gZ2ZqTgAryBCR285N7KNwGfy2KLnsxyLL8UOijksc3+kpCbsKV/OJc9wjQbr7Gt+Zdp/FyWRK9YgMSJTXTFh
 qcojq7NK
 mbSTjK8t2Wpzv15hUq1HybOwyMSQFz9GXi1OdzKqAuEefdOfnxTlUXvmWJrPhQ3Ze1MLyugJXBLtwaCUrFyfvn+wxpPiHEmPmD+v6CHW2kZ+/lJEnpcCLKlcxG3ouHkNPGfxoEy1NTbuzUPNFPAz2Rz8pFeP4dyc8JSRJ4IpCW+lBNVFE5U+LNGs6jFpZ4b6puzqGCMUOQ/tRonTtrsxd9APvmILWdeu2Sv6MWxynsTlDHfx5Nh4gu8Oaq/r+DaO7t0TqS5J04HEFSfaLoOZFb4kjanjR1na6tS2ZFh8dXOWRmPLOffqHNcodu+pDcTQrkFYFhhjT3Bd8cuPsvliBkm8ka3G46UqG7MXGmiyJ5SVUKTYi/FV35V6vjHKwsW9S0J6ikDgzJdzwPSp5Pn8o4DMeEJo6721PpiL62hJZ0slExFsaVLNJGjVuq4SI5hMgNMHSIkQErxCbb8ibuGQlEjnPd+3ow36aq2ebCueyH4jwg5w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  4 Apr 2026 13:30:43 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Sat,  4 Apr 2026 17:11:22 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > [...]
> > I think this deserves Cc stable@ because:
> > - The issue can be triggered by accidental user misconfiguration
> > - It causes kdamond termination and hard to recover/restart. Once
> >   triggered, kdamond remains in an unusable state, and I have not found
> >   a way to recover/restart it through the sysfs interface without a
> >   system reboot.
> > - The fix is small and low-risk
> > - It improves user experience on stable kernels
> 
> Thank you for elaborating this.  I now think this deserves Cc-ing stable@.

Thank you for agreeing to Cc stable@.

> Let's make sure the user impact is clearly documented on the commit message.
> Also, the code change itself and the current commit message is not clearly
> explaining how the real problem (DAMON cannot be restarted) can happen.  Please
> add the description in the next revision.

I will add an explanation of why DAMON cannot be restarted in the next
revision.

> [...]
> 
> > 
> > > For stable@ Cc-ing patches, more clearly describing the user impact would be
> > > nice, and helpful for judging if it deserves that.  Could you please elaborate?
> > 
> > I will add a "User Impact" section in v4's commit message:
> 
> Yes, please add this kind of message that make clear what is the user impact.
> 
> > 
> >     User Impact
> >     ===========
> >     Currently, if a user commit an invalid 'addr_unit', kdamond may
> >     terminate abruptly. Once terminated, it cannot be easily restarted
> >     via sysfs, pontentially requiring a system reboot to restore DAMON
> >     functionality. This patch prevent such termination by validating
> >     parameters (addr_unit and min_region_sz) early.
> 
> You mentioned it cannot be restarted above.  The above message sounds like
> there is a way to restart it via sysfs, though it is not easy.  Please make it
> clear and consistent.  As I also requested above, please add the internal
> mechanism of how that makes restart unable.  This itself doesn't explain it.

Thank you for your correction. I will make the description clear and
consistent, and also explain the internal mechanism 
(the 'maybe_corrupted' flag and why writing to 'enabled' cannot recover
it).

Note: 
Please excuse my slower responses in the coming weeks, as I have
upcoming exams. I will be most active and able to follow up during
weekend (Friday/Saturday).

Best regards,
Rui Yan

