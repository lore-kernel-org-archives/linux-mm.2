Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8458CD5BB4
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 14:24:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 489026B00A6; Fri, 22 May 2026 10:24:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45B586B00A7; Fri, 22 May 2026 10:24:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3701B6B00A8; Fri, 22 May 2026 10:24:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 22D726B00A6
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:24:33 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C5D92C26CB
	for <linux-mm@kvack.org>; Fri, 22 May 2026 14:24:32 +0000 (UTC)
X-FDA: 84795276384.30.260A22A
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8892B140011
	for <linux-mm@kvack.org>; Fri, 22 May 2026 14:24:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="C/8LXluz";
	spf=pass (imf26.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.45 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779459870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=acKPfWIV0T2yO9gpmbaso6PA38iYfEEigSfflk/5+Bo=;
	b=TzQ4Q6Y08/Q1bBLwiuIN+4a6vkscqj1GKLYF3hODMP8MBfmKgTyuKWPpbO31+wW+SlAV12
	K9W/pbLoaVcfemAawhLxzGJc4BX3hO4TwuU+ioCPaRSBZAEFrqRUc1f292hdqu9Mr4Ji5b
	rN/ftfdaBT2aBGyFlZ4C6PBP/FAYB+A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="C/8LXluz";
	spf=pass (imf26.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.45 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779459870; a=rsa-sha256;
	cv=none;
	b=TDd4rRR21PkLKjBm5PYo5HWdKba4gdFgZP5D8LjowT2f2t85C9QSy2ZyhEzTxW2Xo+5FWU
	hMiVT6e74dC7Eew/w50dfE4sXcJU4fMwvsR266+BhphRmkALjpxdcQTm2UD/t7BKER2jk6
	8HluTABD1wsvMFnUhApWIM2RYzpI+AI=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-bd8faef2e18so793838866b.3
        for <linux-mm@kvack.org>; Fri, 22 May 2026 07:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1779459869; x=1780064669; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=acKPfWIV0T2yO9gpmbaso6PA38iYfEEigSfflk/5+Bo=;
        b=C/8LXluz6N7WKQHQ78qBYVhuhiSCteLHtvG7DHXwoVp/8h4h9CRvrLLE2B2TdbQXE9
         aSAnF+Pd7HS9EtOckl/L5ImoG7hQzij1zjLMkMMPZyBM57iG2wa8jo8WN4rVk6Aa/euE
         r/TgYpFekqcweF/g9ezQr7Df7PL0pPcAww83M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779459869; x=1780064669;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=acKPfWIV0T2yO9gpmbaso6PA38iYfEEigSfflk/5+Bo=;
        b=USAMccToSmr69P2ynXV72+O4ue/xQ2edud0k61xq+kltRIzMSI1VRRtR7krgiwYgZJ
         ctmW9fg3uEeps07yOaUhrT3jWpjahUVmb2XifkL5nnGGM389wo1P4mFourTQLjkrNuSJ
         gGSp8bGRLREdMrvQYr9WfWLXX233fORGUcZ2RtVQ4MyEKganlAKhbgIIuuvX963mjIun
         JZi3hSdBhHSBi0XPxDVW7nSE7ThncSR6QxlwWlip2/MLR4nwO4Bvu9+VYBsn58olxVE4
         ngTsnXC0kDGjCSd+Ys7frwXPyfDioKR2VTVhWeGrtYGNIE9uKwNnHirN2JUTEXUxtpqB
         fGAA==
X-Forwarded-Encrypted: i=1; AFNElJ9Xpm+NtMqh2IM4/gHdsl3qPbmKAyuHnpF2ePBViJgHGzrMsSyqEk4IseCx6jmFzjNxKs8i6DJxyg==@kvack.org
X-Gm-Message-State: AOJu0Yz9C1hOASZDlVVTs5AhZfVFiKTbg9tIIj6IZIrcYBRLrCxqmPId
	ca+u0ZhFthMrzdAAIoGkozqKoDEE9YmrWgjlxIUebuSlBchPBHCMHt3hBvq7y5ynNACrLfrWcPx
	aCsxU5ng=
X-Gm-Gg: Acq92OEhClIH4p0ih59t+uF4c/+1EZd4C5U/qats7XP0Y0hH+UqUomT1/yADOHKxf7J
	VYUCZuj6muiYD+RYxYbG9LqJ+PqkaTFo2J6oNw6OZ5vwsQOlLPTzW+h4osdB9shrSRPpiOTQ6lu
	ecyQZ8Pfk21/aDr7HN1GXdC9uwGfWgNAw1fbRlHWAh96tCpei9BYiFCRoGIx4kZMwX6AFT9fDFr
	NOx3RTEG8mO7l6vUMW2mjdm5z3JfA0N4CLHAp6gYDXYM6L1/ZyxIhPBIcLvj9mlRuLkwUf6okaU
	PuamQpwwM/4V+87+fQilINH4yLim0h27I3l13K2HiUa0gR+g9QFRuPwltkdoo18A04wyIt/ao8L
	ysXMWeeDutLHp7U3oU2mqz3HiZVrz3T+Vx2DmHyq7O/RCIeP1C3k5GYgCQzfYO27Z/G/cHKa1uK
	+KB2yaqbLILuoHUQgpEgWuXtL311CAFkUm0Dd0eRxjNqsp7CsN+gxC685mkFfpya6OWjG6t53hE
	ZW2HwpF3vE=
X-Received: by 2002:a17:907:75cd:b0:bda:e47:70c3 with SMTP id a640c23a62f3a-bdd25de2868mr185050566b.27.1779459868641;
        Fri, 22 May 2026 07:24:28 -0700 (PDT)
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com. [209.85.218.48])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-688baf1f0afsm710472a12.17.2026.05.22.07.24.27
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 07:24:27 -0700 (PDT)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-bd3eb594960so883846766b.0
        for <linux-mm@kvack.org>; Fri, 22 May 2026 07:24:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/eFw9W3y5jvExYYF3JrkZ+q1tcLDRu6Koe/RBWLjIKqfamDzam1rkSJMlkHiPYl2TByfw95w0XiQ==@kvack.org
X-Received: by 2002:a17:907:1dd2:b0:bd4:b787:cbc1 with SMTP id
 a640c23a62f3a-bdd22f2e809mr209060066b.12.1779459866766; Fri, 22 May 2026
 07:24:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260522-work-exit_mm-v1-1-bd32d5a560bb@kernel.org>
In-Reply-To: <20260522-work-exit_mm-v1-1-bd32d5a560bb@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 22 May 2026 07:24:09 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgJRmdjDQExRP67GprmG7VLopuuaWMyZr4YNp2NvdNbKw@mail.gmail.com>
X-Gm-Features: AVHnY4JUO31ZsoSOcxsaV2rnOfJ-ubFfSCdy30po45mtvYrluJ40tMteEvAEuLM
Message-ID: <CAHk-=wgJRmdjDQExRP67GprmG7VLopuuaWMyZr4YNp2NvdNbKw@mail.gmail.com>
Subject: Re: [PATCH] exec: free the old mm outside the exec locks
To: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8892B140011
X-Stat-Signature: t6fhwbhjdowk8a6ygzfbjn4zwshnuezw
X-HE-Tag: 1779459870-933169
X-HE-Meta: U2FsdGVkX19CIkN4vo+3hfoPvtf48TWZbZBuK1J7SELN9BNnelWox4QH1HooLvTXUbP/hgS5f5SzAdmpbLfJvY64w4yeDt6p9RAslNL/f08NNZ7DDsCKcjVQU1XhY9tiLEC045M6DP69NlbmnDJ6se6wc03r4tm/BaLNjTVUBlSPFX6tNFvBG8UobiQZWKPvG3aUtUfZfyVFyzlHN5NB0bNU66XDaweziBjCSkCD7NpiMEXgWHmgxmN73SZRshmqsTWvh2gVJretHvlsV16ElW4VGQprx1U6zsNY61fEtepclohyc00IktGwJl4BeA1ovHc7AkTjRA/3qp64XGx743WeFgOa1+3ZHNMhVDJbNk8m75K7XYwp2pLTyG0nhg/N3KPI5/1gUbaYKZ1UspKoGCt7dCAGfckkWU9/liYiZOzKJRwtd2WhvQN7uMPmukOOEUvNig9gnlCQMwJRt3oeze20lvogs6JJdNFcFugGiN445GAUpaNoHdD9Uwxk67A1OxXNSvDBzqsGKTP0Cv7iIsxtJ9pJ9j7URH//AChD3RaquAyUvfs+YJ2RVYHykKm/8a1TNzUsP9wclSiufJmYhMh6WhS0sLjEGQC3bFiEV7NPjFIzK35xdRsqilABZ+eJD+lIdPRQHobxcSqdafquC16za4B3WwUXumeHQtbcT/k1IS/qlpMPAy/V0UFWMUFG+QFCdlPyrqqx9tdAea2vB9n4P+FH7bCqhLaW9Nd14TrNDDVc6q+5fjL+1RPM9CGmB9zaWk7AZ4r/My7zr9SneC3GBfdNY1+f7HZLXtglfOil7Mw0E7chf1A+I2ilcjf1NfG3AX5m3LXwLoQlNZ0MlAVqUiKrk5gnclHYpKnwfYV20XcVfIn6jQ/FFt2c5DDJEbZyrQF7/Pdu5eLEkn35id7dQ2jUMl1gUYbBE+vbXYyBSjlbCJpEAvZ7UmVumJw1N0r6A/ejxPXEcZlQJxA
 YvMtAqnu
 2XcbSlyU4BHYvV3Ru0w0Pbocsw3qUJ6ugxSzeUrdihV1PAV7T+xoqLn00ts2DfvAJxgdV96z70IokByigeZc0iTV3VrMjwjR0TQtsUXWF2BEqZXO/HedVYEsBj1ThHd5y9XPUFsMfKOAvSKh0Ad7unnND6cMkbCTE3zwNrOatomqttM1nAy8S1yVUNro/5nx5n4lDVpDQxVCMhBiARPBHV8+dqIOvhL8RRiTXuzBINNlY5ixpbHwt9cGECGCuw9b8A3nEH8hg/jn0mMgyTg7qgva4UGd1/+NeSTSo61TaLwMRX0IU6knkcKvGe4WpJ3/CCYDonNKFFuGDDewapxIiSB/AUPMhPBEx3cDMVMcz31NffikhDPWr5Cf/HuYlootsK09RsaebRyrLR9z7ylV89pi/ADki4BsCyrIYWMinoINUn3qcTBn7kqJx2RAGG4XtdsawrySuXGq7QzqIX4MJqrGa0rwT4FroTByhGbNN3mZA5rwbqx0MjEXwWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 May 2026 at 07:03, Christian Brauner <brauner@kernel.org> wrote:
>
> If exec swaps the mm but fails before setup_new_exec() runs the old mm
> would leak, so add a backstop in free_bprm().

This looks odd.

Why is the free_brpm() the backstop? Why isn't it the *only* stop?

free_bprm() is already where we clean up the new mm if it wasn't used,
I feel like it should be where we clean up the old mm too.

IOW, why not remove that whole thing in setup_new_exec() entirely, and
let free_brpm() deal with it?

               Linus

