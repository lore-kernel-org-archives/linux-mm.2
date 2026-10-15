Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D37B6CC6B39
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 15:17:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBA616B009D; Thu, 15 Oct 2026 11:17:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B92106B009E; Thu, 15 Oct 2026 11:17:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA7D86B009F; Thu, 15 Oct 2026 11:17:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 859566B009D
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:17:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 06C3AC0A41
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:17:11 +0000 (UTC)
X-FDA: 85325213862.06.CEEDD8C
Received: from mail-oi2-f7.google.com (mail-oi2-f7.google.com [74.125.231.199])
	by imf25.hostedemail.com (Postfix) with ESMTP id 05745A000A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:17:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e6sU3yIZ;
	spf=pass (imf25.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.231.199 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792077429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OeZR/JOPa/KrDeQOVwy6UcwSPvI8j2bKhcX8zNJ+XWU=;
	b=lbXu/KO/C5dz4RymhTCh2uIHkq5T2E3CjKsucD5na4AgkM/x0jrxbCPAnwg1Su75DSpTBC
	Wl4WWT2+6k1dlJAogXz6kiBfDOhDTHjRr+RY5T+ffnSEN+keagO7iwm43ZGmHP76HSHBbv
	jVhM6yFyxYqJ0qWg52PzhTkn/YwoPeM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792077429;
	b=u0RrnVTCV76X2KAH8GxVEaQjO9+UrSoYYBtoaEdCm50WzGsMYUCaI8iXRI+SsPShw8BGni
	DVwM55fTOgDOPeHsT8v4Odj3povGYij0G/GDtYP/jFbqSeXTR37LFw2s6qGc2CtpWAZDSN
	lFgQMD3cviwwwF4vPJz5QLMFWIwQjPM=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e6sU3yIZ;
	spf=pass (imf25.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.231.199 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-oi2-f7.google.com with SMTP id 5614622812f47-4b39374fab5so2147611b6e.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:17:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792077428; cv=none;
        d=google.com; s=arc-20260327;
        b=PFjGOlXVjGS7NwB+l76ErrL5SESwMsgwPR8jUWSnm1kQXr9SS+K7q7HSWvAh89xy48
         pLh5OJ2ReliR6fNuFLJdcGaInwXSIBbHFybjDNbKZs5v4Cvh4S7qeoldQXfxlI9ugeIj
         PXblTuBsKVi79RsKKR0wFWhVG0V2fMHFgNZNCGfY8uEYeihuPumW63VD3rQe0m4TSIOy
         f0VfYgQ+c+QZNC/0Z23i5HFWEgeDCJUaqhjyU7dYq3K0N7Es5DRO71kAItVAyOnUnp2n
         4NWcjc/lTHO2aNxhgfcIJWEt08XvEtX9N5CV8bQirGY0LHtxfAe3K0Lwt0jTcm4iSfGp
         azDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:references:in-reply-to:from
         :mime-version:dkim-signature;
        bh=OeZR/JOPa/KrDeQOVwy6UcwSPvI8j2bKhcX8zNJ+XWU=;
        fh=Spad8KXqLC+3tVBG9Ile2YXl3Fpyu83lKErqrvCZu9Q=;
        b=W70zncUfa+nmWvW9MpKdQ6lHk1kCCPxZXyG8AWT/eQSLYJeH/ZO38u5XKDVfzgJkIL
         5qmwz+JWUqhT7k17aQAaQMRDXVGqdpvWBrxUXh/xQJ54frpWM0mpYteq/8IZ94a/H6/K
         +BTjp+LDMAiVTK5ESIUHNMRnpA467hGuoksKb+mYqFNOTx6AoHgJUkvwXqlUShtMgZR2
         T4jbHcXJM34FipubWjoGNYhV8zcyohLwSex5NR44oNLih7I4tqPHT1hAV2yWOTKadD7X
         ZqAn8ysfhMW3hQ6kuPnv0Bo3mmPZ9hfuwgSyYEvWJNUsDXiS5+icY11yIemdyJcIHvt9
         OSIw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792077428; x=1792682228; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OeZR/JOPa/KrDeQOVwy6UcwSPvI8j2bKhcX8zNJ+XWU=;
        b=e6sU3yIZqpuX13GqlNd8k2xcuBh7SC53tK6xWuB/gjdgCKrDRDjiSXhhVrKdZbc5MP
         MAeuJoBDh1h8q88fr9eA97d4Wy1NpLLWroqw5OZIZ1mI6oh4U7S53d54bS+3RSB/GGqZ
         FZ7cArT4o5TOwxwiE3Y+4SOYiPenucoxDd59sNHp1y4nZMEKUDBKN6cGcbXzBjF9qqKf
         VePCmaGSZ1yZ0JsdPf/KRaDgzXunYMMHCBtYMnTxUHCqWcetpREsXfcDWdGRBd6unYvW
         mwQKyHKBBdIdFm7l+8YTMK79N6Mce2TZQJ6hkbh3XYhtYVq6ukyZiTUJA+xHXoQzqQxv
         cJRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792077428; x=1792682228;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OeZR/JOPa/KrDeQOVwy6UcwSPvI8j2bKhcX8zNJ+XWU=;
        b=Rxwlv/wHG2X9HQ1wdEziy8CVahTQ91WJk9vSGxk5uqlft7+9X0nI8lghDQld9mDCYn
         xvYvieua733kwIFXFq+IwMxlOSxTOtMoysIY48SS7n17eUrmaWdpwEcE55mIK8BQtHGA
         bhaRIvu6zpKUghlnCzycbs9GceaxZbiy5eyM32Vxi9Wce1gjGbS+DiHeKuOBBpNCw/g3
         bExJWXDCUQYIp9FLFBqbGBHcxqlsOE2sqZXdfOIHSD8lNqwZXaaphNvHilW0M+kDqnc+
         ipvE4Z9Vq5MveRR16Mfyhxc3bvjgXXN085BRe3Ck6LaKueA+fO4t918rMnbOgmNoatYC
         1QhA==
X-Forwarded-Encrypted: i=1; AKwUvBzbcHngSJocG9xcf3SGTNOrHX0zgE1do2CJDlliokwNJSHg90RVNCC3EM5QjY96wG7LcIVmieiiZw==@kvack.org
X-Gm-Message-State: AFq9FYLabTIy5hg5nbhV4I/8Tv4VLt//+CcU/LJmoKTzudMV/pp/r2gj
	et1mOslBXWExPtLR//+GUPA/K28kZFaHjS7NGFG8Dy6smOxfmkFZsiqzMBb2ePIifzRb+XU2cQL
	+WAU7DqFn3DdtlZQ79WOtM1BsIicHjkE=
X-Gm-Gg: AYBFou3P+0ju+O5ZamzK7UV+3ewxguu94LuEveCw2kY02TDocoSHNZe6fRwoId3fH8k
	pXHmKDuHtKdmVoJHZX91p6jqV6MWQk5fVzewQWtHfVepx/pLCOUBw6htCOvgrOQfpIadJFlMghh
	2zi+X4iOOn95wSJOc5i65oIkff+r/9mzK5h15K7OvTPiPGI1e+xjOiJrEZ0LDaFN9RfzuTCbzgn
	BtlITW2i+7QdcxeqFI3PB7XLpvg66+wvrUS9ihvphemNXZuWCuoSTZXYDDisT5CJLQZfN63rBx5
	8xZSfX4wqhwBT5pcgDkzTf69dSeJ0uCgfLQ5MmaLo4eHH0yi/Q79VhBUo2EXJ7VhDHLOIUVuvAD
	S8ixLMAo=
X-Received: by 2002:a05:6808:50a4:b0:4d3:6be7:c5e9 with SMTP id
 5614622812f47-50c4e67b316mr20247148b6e.24.1792077427501; Thu, 15 Oct 2026
 08:17:07 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 15 Oct 2026 10:17:05 -0500
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 15 Oct 2026 10:17:05 -0500
MIME-Version: 1.0
From: Aveline Noir <jm5905938@gmail.com>
In-Reply-To: <20261015140502.87975-1-sj@kernel.org>
References: <20261015140502.87975-1-sj@kernel.org>
Date: Thu, 15 Oct 2026 10:17:05 -0500
X-Gm-Features: AclHuK_GMaQKMIsKIixwyygc0aElEhr0PiYnJJZwMfa1CmbK4jR8xC8YVujhE6k
Message-ID: <CANOyQmHhCJEbHpHUZ2P0hui+We7wxWkEde-Vh4k2rRXWovRYrQ@mail.gmail.com>
Subject: Re: [BUG] DAMON sysfs: failed update clears tried_regions snapshot
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 05745A000A
X-Rspam-User: 
X-Stat-Signature: kabs46ds7biukaxg5jb3o1jxykkmef9g
X-HE-Tag: 1792077428-465629
X-HE-Meta: U2FsdGVkX19r7J57tVoVtdmkqR6nQwPEe4YWJPi3AroLtwStVRHyD/MpeKn1hqFqIUlWbI/RvPBfg8lck6v0SzwHMTtplFdQ0dPNn9AFTkNi80HrcW9nKXuztZNsIOXH+hyFfdZIQiniiGIq/f+wW62mqweSg35e5mniqxK2hKloe9KKcnoQp16JnCslKNX888JZ8pj9Oz0f96GdSkB4Fnt4vDJGR0Ed5wR15kN9WeNDTgMtdVu1U5154OWLfln4kkFABZfqRcSN+y0PrSNjJuVsBDcQXhwbm8wPl7sTRPDTs4wAmKQj6mgGUWeQ3J6/R6xcrPZnRDGWD3/JPHs7C7JtZTvDqmrz5+VavMaHjRBr5alkCtyYZ2IqHtVb/4Cru2L97Nc+6/KwePq1NG1VMq6qNzu0a6D9EEs4/OMw9jdvquuIeO0uH5V9zTEXA3R4U0+VlWT5rkb6gMh858oagdp16EjoTpmg7+JjAbe7Bu88+tEJW/lAdQv0xDv4z3HEHDoRMSyhARKO/yG4l4hCr3/NgyQWBEz4Jg5X+u+QtqdKAR9K6K9nOPqqgVfMu8Rl1jMhoTOIT/ss9OZlLygMUhUKwd7PqRUCRkb18EhWfCSsrTahVJ8YzoHHylFI1hnO6tQODUGMEl+JzEKUWLwks+8bG8deGLfloz4LIQxJMudf0MuQ+W0nbFM/ysVClZJga6O5eKIGoCotyljJOgGY/zinR8JK1zFkVd7c4mA1+1w9moxtUxM053BBkHPcRtBZ8HhHgAw1bK7FKhymT+NkE+83bg+J+hovKRZbLVt+VZDIcIHjmvdy3lgGcBiVlgvQogMgKngEq0HSkiz9VjHeV8J5IfLOPTN63P8dyABUtUsYRk0+j8DMSKMAJeXgiPz5Pj8bWm6eC987P/e+Oa5TYyvEkO8M9vClyrEk7OiZATsO6s1X2UC5LUIPnzB10oqJZbWS6W5/JletPYWMeoG
 hZz5oUY+
 6Z72ZkRF63nNMh6we0pSxxTn/WTnIGmbr8fEQbIGySVxNFYBnHbplbyhR+8Whv0n/J/l2bbBNNM0nlexUF3nWZJxryD0ekeu+1xX5+wOYq9J6BTcMimmgXQpPtZI5wd/EKnICmwxqCVBihOY9VhxN09cb/PKnrbIFK77J3lO9mJ4Lg35GB+JZCW68CUHplRJPK729WYL1lpSB5BZy6CKgpYYM7CTylnHaWqGzHMnE5TrdPTe/HrA2oXl/DWbMG4xjrEqJPtR7mqLZkgBLd53P6p3lt7Xs5dXshExhDn6H5/ggFeljxqelOV2PzYzHpzvxa6gtb7evogJ8bWrdxmlsa+72BilXlUYZi2RyEH9VqWJy0aSxfkVqeW1u5B+nxbDtZgx242zSFR+XLy6JXAaHmp4RgJ2eV/KtaFVYl6KnSlgYPK0QRIeQzs9umoYYveWBjeiNXanScUVNem/S47JoweiAMhTuJSX4NTikB70H7ShfjEyEklI/r1VJ76nk/7+W4KBiYYANPNiUdsE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

I haven't seen this affect a real workload. I found it while testing
the DAMON sysfs interface.

If a tool tries to refresh after monitoring stops, the failed request
can delete the last snapshot. The tool then has no previous result to
fall back to.

I built and tested 66178e4ec30a and its parent cce0b334c310 with the
same config and reproducer. In three runs each, the parent kept the
4 MiB snapshot after rejecting the refresh; 66178e4ec30a cleared it.
Both returned -EINVAL.

Thanks,
Aveline Noir


On Thu, 15 Oct 2026 07:05:01 -0700, SJ Park <sj@kernel.org> wrote:
> Hi Avelin,
>
> On Thu, 15 Oct 2026 07:22:38 -0400 Aveline Noir <jm5905938@gmail.com> wrote:
>
> > Hi,
> >
> > On mm-new commit ad9f2d463666, requesting
> > update_schemes_tried_regions after stopping a kdamond returns
> > -ECANCELED and clears the previous tried_regions snapshot.  The final
> > result collected before "off" is then lost.
>
> Could you further share your use case that this behavior becomes a real
> problem?  Also, have you tried bisecting this to find from when this behavior
> was introduced?  If so, could you share the commit that introduced this
> behavior?
>
>
> THanks,
> SJ
>
> [...]

