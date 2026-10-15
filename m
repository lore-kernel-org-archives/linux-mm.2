Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C08D1CC6B39
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 17:12:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9C706B008C; Thu, 15 Oct 2026 13:12:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4CAB6B0092; Thu, 15 Oct 2026 13:12:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93B0D6B0095; Thu, 15 Oct 2026 13:12:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5FE996B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 13:12:13 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D39A2120274
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 17:12:11 +0000 (UTC)
X-FDA: 85325503662.15.1934521
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf27.hostedemail.com (Postfix) with ESMTP id F215F4000A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 17:12:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gHzBIKhs;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792084330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E5wvLBgFqxSZGnqXC4JtAllV7DpqQrgFZ5hJ2YmKNEc=;
	b=gG4H+wO7Omyk8hNDK9/Jr9+rh+Iw4JCOaGnDWbaewee384nDpkQZJfTWKAe76rBEm4qubu
	zxB1Y4iOL7l4h1rUcQ61B41f7i/LWRFNTFbrJKrcGo2JqUHdG0TPWSEZWdK9hZGTe2VsKb
	VRiETstcz5thQzUX20yeKCSTIMhrN6A=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gHzBIKhs;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792084330;
	b=ZQRVQn7o2xgyUivr87YmBkqWwcMcMFbBNkVzDfOShBCs4zPCUmMJRxxKN35yY4Fqe/Nm2m
	5cxKGBJ5COVafafD4kt7ss245ouzsGPfEqcHUodYk8ZtGHXleJWktKVsnJmzUx3RsmZWCx
	9WaBeZrlWXAcUBimOpNCqZcF4TF81B0=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49e73611928so1292015e9.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 10:12:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792084328; cv=none;
        d=google.com; s=arc-20260327;
        b=UppGHwX3LWadxl2ZmXhT1qYkofYJVPCDfmsfOtAu+rDn1HvVEYslIwcY7B4294D9Sy
         NMNgXLhHl4WHflfZ24ZHhptguxG3NKDzlcZePHufV1SaVtC3DRcxvEbxuy9HodWG8YmG
         DqleQjRccAi+km2clJrgjqiWIHYlXdw/cSNvnBxkX52pfpfYMuj+S2F4BVUuir+wxw25
         SFHeToO4TgVysktF7E/mU/e7JqgNmKtX1ixMM4pjvknAe/cfX3vQCFoJ+ZAoW54q+9ox
         CjSsrAVW22v1FWue3LNYps3MEB5/ZoVZV+mWYVLMGBOjgTGoaDrO7maESx+7A12ZKVLg
         V5CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=E5wvLBgFqxSZGnqXC4JtAllV7DpqQrgFZ5hJ2YmKNEc=;
        fh=+kaU1iHIaW+ItaFemEuhUhQMHkfzuIXl0fJ+PPXhbxg=;
        b=HdgrZ7H6Q1cLvxiifbjuZ4bdCH3FO/EGL1ufgix02jh2HkqRKY8idcdgBtwzhSXxvU
         N+BjvDJlBU4/7wCZUhHY4PdIG46wEtbWx3cv+0/DjFLVs/MItqFDK5195mcJVdsDs1KY
         6RVOsygBNVbLlca8Sj6nVY8Zmh6tq9w+3U5hK6iYwSGhAb1aRr5m8LGJA6zl8tydJ+Ic
         gnlawyADovl+hrl/YgsS5PbWEHg5wsol19w+fTyHxmdKkox1tWZPsZ6g5fzAMUNoAqwq
         T2mUckMZwDKnlj2T9FXvUJlwfinhnA4Ua2eKbJWEIMT2KDECfhwTqNUb4wu1aMqR8s2O
         0j3Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792084328; x=1792689128; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=E5wvLBgFqxSZGnqXC4JtAllV7DpqQrgFZ5hJ2YmKNEc=;
        b=gHzBIKhs82DyR4KL618zk+QUFOxh+rldcFkG4WTR4fAJTG/K5pJdIz/PMUBesyO/h3
         wlW7YyOKoMfPkPY9Nv4+RXQ49ZNLwUDHLrrBWUyAjHWxwGoO57JeF6X59j3HnfM8M6Hl
         RqBHLXsLZO6rwJ/7DKCQ/U/GlFdakosc/6YVj4r03ALpoRPLMZiarUA0NVYwN6d31ZfR
         45uL/HTLD5YSEhmT/yvCffWMijceln+2p2wTlhyLcArQrL8YbV4Al3BZAhaAWpqCWAvZ
         5XqgYY8yxH0j7Fi1rFpcp2BZv4ziji7x5ayylYzEVSxPzC67sbRoYo5xs7785VZiYEeu
         tjlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792084328; x=1792689128;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E5wvLBgFqxSZGnqXC4JtAllV7DpqQrgFZ5hJ2YmKNEc=;
        b=lXWk5xuMD5IkoB9cxXT3nz0VXccNa++fpgq1aP9MGidbf/yz9/hUr/9ERHDSWqNrqL
         Yt5xOZhu0U+v3aBWTCxaVwo0kN3EJRmef3EyJImD5KFg5X8B3U8ktt4y0V+JivGaSQw9
         pjlLyTuEnESEI+RvzmFbzlU55bXqG2c8a6eUSOpdGfcwJVhPUawXcYwGxfD0KGDZsbip
         A/lY1lUmMvY/cVd3pFd3ty/z02Sba07ZX7or4Ma0xCpYdyab+hcmTYJZsCVgPXmD/Pyp
         zY7WHS2iEIuizOR7xKjbCbBEmZjXS1U+Hd5AryiLDwbNFmh7/oQMdiqVhFpbCavesCXw
         pfug==
X-Gm-Message-State: AFq9FYL0WErcjrBaLugxF2mDUtjiL8Ep/dMcQnbPWmTzeAhacshNwSy3
	0ZQFF1i2FNiVtAbwhz0nPYkOYfJlJMB30hieoFcOdhF1qL9aHIowfd3uXlwnSW8w/wwQkLmktiR
	FhDIKV3pe3JTGlVD0GXCK9C+QysYsKXw=
X-Gm-Gg: AYBFou2VDzoCawcx1hJe0eW3xJpvBAEjhvFNzr+d1kMBK6jPlNYK4/yisXt7vXxp435
	yinM5sxxLan+dpxQpw0qyd1cOAgVNbDvzQliaeho/Ag7e4oppxYz2hzc/MNEyJ0qb1eDwAjInfs
	KjRH+XW4EVA4hWcvRCw9l96NlvdQiU1SFy/pvmgQcwtZwlAkwhdYtG4XgQ2u5sTDLlkFe1MAXuZ
	ip5D38SWxgDimw5pbBgtgywmzGiuFiZJgd83yC0dN+QFJLxjLZZKk7P0BvGGBrbqunTGsyzZxtZ
	a6OyPhG7VhibO4NO2o4YC1uEeZFqGgvQKoYg4dlDhcUAr/aXb5QNdLtdK/YtdUATH+ax8PsAYZ9
	Zg+LQufMS08HSl75xwJCQb2ZeCXQiYe3t5d0BPzhd0gALBNUR3U9isMgev9Au9ZG3QJhV+cg=
X-Received: by 2002:a05:600c:6c42:b0:4a1:7f96:9b42 with SMTP id
 5b1f17b1804b1-4a1c6688027mr10170115e9.15.1792084328256; Thu, 15 Oct 2026
 10:12:08 -0700 (PDT)
MIME-Version: 1.0
References: <20261014090821.227366-1-jiayuan.chen@linux.dev>
In-Reply-To: <20261014090821.227366-1-jiayuan.chen@linux.dev>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 15 Oct 2026 10:11:56 -0700
X-Gm-Features: AclHuK-yQypDW08qkRMvF4aeQpLcp1NcljdYGmGua4TF6Gj8KnRRVGox3kNtLVs
Message-ID: <CAKEwX=NE51ko2U0-TCd9+sAm8NKeGeT61HFXTnnU_q2Tn75rCQ@mail.gmail.com>
Subject: Re: [PATCH mm-next] mm/swap: free swap cache folios the zap path gave
 up on
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: F215F4000A
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: xstsjr6cnuxif74g1iopnuda4cokzij6
X-HE-Tag: 1792084329-46534
X-HE-Meta: U2FsdGVkX18emclGYq5ELk7NyMtJdU1L+eRwOVi5Mfrjps9NmRuJCn3CR+zvfuW9cwCBias5pl+Ow6Jp3igSLN6r/hOrQdqsVyqqlE7AqxzyPapx7vMSsGt3l+BDqhIWOO7nsDAkiwdq1FCAjudfzSGNB+dJsboLynjmlXY1d2jpLUieC35KNbzZY52+OJvLASNvJ2alhIDMU9yRIKhusW2y0by1mXECtr90hYbjYp9pPxDsKGCPxuIXZtq8Zof4liQkny52uCBUUZSLxSXe3c9yb3SmWhVSKatwOSf7pm8MDWSzkpeGL2WTvUiChDP2ffgpebNPOckGjbFI666g12w5OfjrdG3yV8k2X425TrPPpSF21zsTbrEPzADN38H0d5hoBp4dHohtaXP8TgZg6Lfw2JA5O+YNpPpkTQSGr1MDdPMTL+mMJxb9EkIY09C4M/ghJ07ggrEUExNK/PxM26xN0HmtQMieaGYTejGyhkj5EDbQOGjYVOIm4P5IgGGWiFGiG5CCivl4z6apeCyyt1YXwdLseC4xJzlYMqDiy6IChDjiKRHnlB1PK7/LB4D40VASTzD/EvGlYZ18qEq8VHhRcNa/S9K8lmlZ1RqNhwZVlAMIbzK7gBEMuCUd5Sl/rYSUkhHqUu9FKLUqXmp9I842wSV1P2/x1Ijtebo0iYQzr7U1IS5MT9ja+Mo4GhDlC+DN74AC9mpQVrbziQuts9T5KekejLtpd0vmzWeRo9tPekAJTSXR3izgpYiR5BleV76ooGi5DUMp8F3OqWTV/0oDhNISaLE339GoNBmL1aix5CVMTgHlnf5MHQEVrNrFATz13Ny4n7SlEV/eCmFBiOtJSI1EY0aOuEYLPniSWh0C/oif+PiqohswbLR2dqez95uNrC7X4ystmeKOB314C10wKQfjpJ5V+ZxoyKLDJ2UAmXX2TqataCfYC4sYsPD0dokra+9UFFozbuS0sud
 xuqbdUtx
 5bf2M5G/j5/D46ZRFXchY5fS8Ld5LjIkZBJ20XkaJONRcq+qmJTfemSOMIo7wnGxp1WXm+AEsOfimNhynvLpKuX6Cgs4jv2PLtuD2k0bWXmq1zhu1Zj88YRo2iJH0x/vQbqxmLGEyoiHvJ7g7z3lfLTdQcnCOyJsYsv5SI9vLNbIC50kfSFC1JskJRilhsWSyjKEzPljs2m+tKInGTEU3NCUDcmEgTfJ/tcxym30hzevQ1C/boHJbCrlQJzJQE0m7fOKzsO9XWfCLde0kR943V7AIZvYvl/RgwArgDCM6BLV6y6Pk2CMFIa+/Y9Qog48GIBbxNvFbK3cxDrXX1RYpqOtb5RNoaG4VG8P86wakFPvh+AUtdiMAJ8weYneLYMCnCVhyhR/M9TCv6JUu7CkelWKQQMzJOiTglyxtfC7nmuYugScRwnyAUBmCxOxrXm8t+Iv+mXQ7mi4Hq0X3e9FCqNygVB/VdVBe5XrAyeGaruExfuxO73kLjAKJyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 2:08=E2=80=AFAM Jiayuan Chen <jiayuan.chen@linux.de=
v> wrote:
>
> From: Jiayuan Chen <jiayuan.chen@shopee.com>
>
> On our production hosts we saw swap cache only pages keep growing for day=
s:
> on a box with a 500 GiB swap partition, 250 GiB of RAM and 250 GiB of
> swap slots were held by folios that no process mapped any more, charged

That's a really nasty situation.

> to cgroups whose workloads had long exited. The only way to get them
> back was swapoff, and with other services actively swapping on the
> same host that is not an option.

Is it not similar to cold file caches?

The recommendation for these kind of scenarios (for both file and
anon) is to adopt a proactive reclaimer (in the same vein as senpai).
That's what we do internally.

>
> Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>

Code looks solid to me otherwise. Maybe include some numbers from your
testing in the cover letter to verify that the swap cache usage drop.

