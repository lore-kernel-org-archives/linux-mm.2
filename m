Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86D31CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 05:33:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A58408E0014; Mon, 10 Nov 2025 00:33:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A08CC8E0002; Mon, 10 Nov 2025 00:33:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F8578E0014; Mon, 10 Nov 2025 00:33:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7CDBE8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 00:33:32 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 345684C91C
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:33:32 +0000 (UTC)
X-FDA: 84093579864.10.6005E61
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf29.hostedemail.com (Postfix) with ESMTP id 758C812000D
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:33:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cInbbBrA;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762752810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qR/MbGcnUq0EBQz4ehwdMha/tCfwYBiuvbwmX0gSrQU=;
	b=y3WqHIM6QQ18HXI1MiG3IHsUcXzlLfX4yEYFhWYUIu803FxeV06q2iqfKFg+yqBdjMZ2R8
	0vK+6NhGlxPHzvHnCCV4DyhtcHFtjR4TdKbLoZ5IpJsUVsi3c8HOsObIimbzeCsQERKhGJ
	faZR+QjEFvHJyhIsp9gibk3bA8TtkEQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cInbbBrA;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762752810; a=rsa-sha256;
	cv=none;
	b=Zl890WERB6Hj+/JehLObcO+w+KWZkRfiTv4xqoGq5c9NXJ/zte0qUOr3ngzl8RLK7akdrx
	mMKZZm1BF2AkLAFYTwq75Xj3GjioZwc8W0VPXFzdQU0gXIc95BcJweyvvHUkKXbOYmCt1W
	1IsuXkxAzssYSq8lhOmQOIbxaHp1S/0=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b3c2c748bc8so327155466b.2
        for <linux-mm@kvack.org>; Sun, 09 Nov 2025 21:33:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762752809; x=1763357609; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qR/MbGcnUq0EBQz4ehwdMha/tCfwYBiuvbwmX0gSrQU=;
        b=cInbbBrA3HwiLtmrxdyLLmXtmaWsI7TR1T0K5UI9b/PoLkEjUAhvbvZ/4El9C4iO+U
         155L3aSo7/ycXjbeDr8NJ0LitOjOFMtnujXVOWDIgNBAvCSKgz3DkhtQMzagAwmnvivg
         FC1BMeZ/pR2ejeu2GouRIMh8aiUpQ+o53q5OxucSJGU/Z4vYHHnEXU2rojHWFS5j97vo
         S9z7bEoEaKFoTzdZ7CnLoKZtYhmw3DLQ2veo4mciDMpBgiGDvYIKscXESnjj2xnGwkgo
         nHjZkobwyd+u+30mHCwgfShK5UgS/cm724OFSmPHeB5lgtEhDwnuxO93xINFR3bQTY/Z
         XC2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762752809; x=1763357609;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qR/MbGcnUq0EBQz4ehwdMha/tCfwYBiuvbwmX0gSrQU=;
        b=OK3E3BBFNqDP30S0MF9my1hLewDxysM4IGel8rd86r9l+iKP0rBve9d1UzvMKJ4iZL
         eF5hMIWT6cxI4k5APXePu6vUEORgEbSHkzVMCcjRTAqJJBDN+Zdz3kMCJEAe8M82ultg
         9k1pv0HlTRrRnCH4+MWL2cz+YHprH8NCP13klf6LVOWFuqLPzbOxxZy+48LVSohPx/Vq
         qLvfkR9SEvVnqrjGg5+21vvMI0Z2Z1gpx6IM0SeniLdfcQlB/i00BP7owUpGZ63U3ogz
         ADPkZus/vEa5q0hjEZFnwpAuBHTZMJNKirAAATg4U0LaSsz2igTtrnpKvRfGmb/8gM9/
         Zfjg==
X-Forwarded-Encrypted: i=1; AJvYcCWhHFCnYC/GZzEng6dvtwjHikniVsAIT+VGWbFcc7q8Ga5jt6jxUkoJ25YUCEMcv7dhtAnG26VRHA==@kvack.org
X-Gm-Message-State: AOJu0YwRd48Up1bMUZ05kgB0gOigWM0O/gD2y1MOKA/jGebIJ3nAQ9MW
	azcxpnafFaeSZ9HLCyLxjLmlQXAKhqgSwOmXyg7h29+XsIectYUYh+jZsMoOD+lTLFY942wWH85
	fx99BajqKeZWGSKM0SFWMCC4A5zsQKf4=
X-Gm-Gg: ASbGncuz1TbpDxcOKWfpWDxoCJlSko5sNWkLIgzhCnwbum9pE0g90GQHSuGz5eAaU4B
	jToku7TFRI/LvGm/NZOPbnZvWN885c1o9kc8M1pLJuOqgz3Qj5gNAXYraF/tgkKqs31v09yjmsd
	N1DTHdGLc+NUkLBgYjjZ5/Frfg4Bv1Q5DASuFfgforWf+JW4G44S75AwFrmCm9WF7U7WsxneEj2
	NQEoVEKOe16bdbvLJL6Xzdddmoiz407FeF2baW4BdV6xgxw8i8qRTLrg0GL
X-Google-Smtp-Source: AGHT+IEQaTF+1TfzvP4FKyKjl0iE5Fs96BjILlbZ5Ppxh1pUUmMmsbNSxF6n9/ltcRRgD+ILMiYpD6RIg1jm5j9TO5c=
X-Received: by 2002:a17:907:3fa4:b0:b57:2c65:116e with SMTP id
 a640c23a62f3a-b72e02b3515mr749481466b.12.1762752808595; Sun, 09 Nov 2025
 21:33:28 -0800 (PST)
MIME-Version: 1.0
References: <20251110-revert-78524b05f1a3-v1-1-88313f2b9b20@tencent.com> <875xbiodl2.fsf@DESKTOP-5N7EMDA>
In-Reply-To: <875xbiodl2.fsf@DESKTOP-5N7EMDA>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 10 Nov 2025 13:32:52 +0800
X-Gm-Features: AWmQ_bk0J22Vk5bVsirS-BlCYuVlPSn2kEJtIWp5JuDlLDq9qg3-goJo61eNTfo
Message-ID: <CAMgjq7CTdtjMUUk2YvanL_PMZxS_7+pQhHDP-DjkhDaUhDRjDw@mail.gmail.com>
Subject: Re: [PATCH] Revert "mm, swap: avoid redundant swap device pinning"
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 758C812000D
X-Stat-Signature: tojh1wcfwrftkoxhqt6odj55uzwccuyf
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762752810-929937
X-HE-Meta: U2FsdGVkX1+beXVsPZG5w5PQeKHTDB0gZ3F+ISRIbvh+yHyiK58nRi6/ndeiyJmJJMSLWRR04FEx/rIp1OwwWqaWvOhLRBCitz1qfpom1g05FpKpTVZMr80X5zizzVBVqi5TUMuFnNe1wA3ebHepGwtqtEUsRS8sCwI03CR+5WXvArKEwLaQsTaueEsNiKHcL6UcUsgnr8LShEM+zmRhS5aveQAFhoyJns3dJFp8zKIBceGM78qMhROL55WOFrG/0Z6wTopChaYJuAuWppO1exhkZMB6FmOT/ipb9tQhZm4EwQYoPnqmxeNqs3OIZjA9v0l/D4Q1xDnDic0L9aD0iVrjfVh5hqVBHlGy/88WsQViVhpjFe1C+Zg6XUsia74RFP6y13Oor2gNPsFsB7o1QtnNkWPB2k1DLPuHmODtcDqNolz5hnEX2rZ1k6C9Hik37Hq4ClqkvOI8qlFGQ22viAw14Rd/tb0EWZFhL23Y8vw1hamQbLkuqvSNz075t6zF9S5wOWQxAThQciqQ+iqBch2jLbSQo1UftnLHd02dq4rw0ZR6RZRMjzCeGjNJoLz76CDAFXVbYHjWcGn6vKbeTPSfQjK/rm2b7Z3QhA6UUTawtAUEx6+bFTCInrH7yjNSikGvdFGEMKsWNTiF0ZUF9wcf29WL7o70rhGgRsnhmr7UyDnSEQRVc0YxUZOhc6smP+gM/lE+eZa2A7o7oCxMRRjM+EaF2kK3XKhJa34gsV3OZEElRYdddl3PaNGFUJuDvW5F3BwFNxntyQZj2YMlvIwil00g/U6Uf/8uafvzu3PXINpr40H08cci/Dk5lJyY2mkZdUxu29I+pC99w/icvKG1Qwn8C9j9ty2gU5Rpwf0JyyxoJhrWjsPHeDAszE/WONzH2MfngHVFS10bCxeB9iT+vX5MTWdUh/DlRokucPozWXZSXAaO9ZScifx/PiadMzVf9XdVGIeAacsmnf/
 spti00oF
 cc5ZL+w8maKaQ7Jefsa0X4kCni4iU1yZdHPjh3o9tz3Yu4qoRV5Rt21i6V+TAz2oYQp6CotB6Rv2YZYQTw5gmVe74p8+HraF0rgtgfVbQGcuLO7c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 9:56=E2=80=AFAM Huang, Ying
<ying.huang@linux.alibaba.com> wrote:
>
> Hi, Kairui,
>
> Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org> writes:
>
> > From: Kairui Song <kasong@tencent.com>
> >
> > This reverts commit 78524b05f1a3e16a5d00cc9c6259c41a9d6003ce.
> >
> > While reviewing recent leaf entry changes, I noticed that commit
> > 78524b05f1a3 ("mm, swap: avoid redundant swap device pinning") isn't
> > correct. It's true that most all callers of __read_swap_cache_async are
> > already holding a swap entry reference, so the repeated swap device
> > pinning isn't needed on the same swap device, but it is possible that
> > VMA readahead (swap_vma_readahead()) may encounter swap entries from a
> > different swap device when there are multiple swap devices, and call
> > __read_swap_cache_async without holding a reference to that swap device=
.
> >
> > So it is possible to cause a UAF if swapoff of device A raced with
> > swapin on device B, and VMA readahead tries to read swap entries from
> > device A. It's not easy to trigger but in theory possible to cause real
> > issues. And besides, that commit made swap more vulnerable to issues
> > like corrupted page tables.
> >
> > Just revert it. __read_swap_cache_async isn't that sensitive to
> > performance after all, as it's mostly used for SSD/HDD swap devices wit=
h
> > readahead. SYNCHRONOUS_IO devices may fallback onto it for swap count >
> > 1 entries, but very soon we will have a new helper and routine for
> > such devices, so they will never touch this helper or have redundant
> > swap device reference overhead.
>
> Is it better to add get_swap_device() in swap_vma_readahead()?  Whenever
> we get a swap entry, the first thing we need to do is call
> get_swap_device() to check the validity of the swap entry and prevent
> the backing swap device from going under us.  This helps us to avoid
> checking the validity of the swap entry in every swap function.  Does
> this sound reasonable?

Hi Ying, thanks for the suggestion!

Yes, that's also a feasible approach.

What I was thinking is that, currently except the readahead path, all
swapin entry goes through the get_swap_device() helper, that helper
also helps to mitigate swap entry corruption that may causes OOB or
NULL deref. Although I think it's really not that helpful at all to
mitigate page table corruption from the kernel side, but seems not a
really bad idea to have.

And the code is simpler this way, and seems more suitable for a stable
& mainline fix. If we want  to add get_swap_device() in
swap_vma_readahead(), we need to do that for every entry that doesn't
match the target entry's swap device. The reference overhead is
trivial compared to readhead and bio layer, and only non
SYNCHRONOUS_IO devices use this helper (madvise is a special case, we
may optimize that later). ZRAM may fallback to the readahead path but
this fallback will be eliminated very soon in swap table p2.

Another approach I thought about is that we might want readahead to
stop when it sees entries from a different swap device. That swap
device might be ZRAM where VMA readahead is not helpful.

How do you think?

