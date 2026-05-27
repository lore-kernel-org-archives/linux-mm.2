Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96A5ECD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 09:38:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CC7F6B0092; Wed, 27 May 2026 05:38:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07DC66B0093; Wed, 27 May 2026 05:38:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFC776B0095; Wed, 27 May 2026 05:38:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E02836B0092
	for <linux-mm@kvack.org>; Wed, 27 May 2026 05:38:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8CB951C0429
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:38:52 +0000 (UTC)
X-FDA: 84812700504.09.FDC06A4
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7977D140002
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:38:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779874730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1jh4B5AC2q6XDT+EhwYr9A0M1dYuh/w8VgN+zze6pNI=;
	b=GOfcY2k6VxuaXHLaxC2Z0M+GR8yt8jtFYM3lwkFLgfqFP33dkMHVT7Vm+wt1SgKaA3ImxR
	o+69kEkf+e6f0VdkN6zhRReDcrPpUXhiOK38A02x6Vjil48JUC4BIFnymwQFRte7q0hAtN
	D0XEp0SWSekzM0YKwLJ6QRVmT8HBH5s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779874730; a=rsa-sha256;
	cv=none;
	b=VPnuiaqAOUN9ydfr8zIYUyurgcls2PXh1ukPgRQUJG7bd0HU+PUwmFRsDdiuBuIEPayWWu
	3Iy4UYzZyu3OkKTv7dIb2osD6MYVV8D6bD+lMj0sFSITXoHR6bL5imq3z7nyboR1AsxVUH
	OD3/4DJR3DDc26U2LjxCVyVPcZOZMwU=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-9106ea78cd8so1779416085a.3
        for <linux-mm@kvack.org>; Wed, 27 May 2026 02:38:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779874729; x=1780479529;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1jh4B5AC2q6XDT+EhwYr9A0M1dYuh/w8VgN+zze6pNI=;
        b=moFA33TgSriDRFu/wzak76lfrPTrJ6fDC5I9Vsbv+2sFaVYnJsfe/vuuNKe/31H1SL
         d45w4+xr2TapnTk+2g+b0yLl83B1WLfWHafSrWgITLjIThs0RKFM6ViY4QP1hfXXanmq
         RigS85yqM7SxqrKijyVH7Ymgylwk8XBAt6e95Wo9y0so25qJvRA7OP9hNv/gbDN9MLNS
         iGsNhJgM9UV1XML59gn3dVds0FF7UoynVDXTBShoad2jaQH4XzZzHerHuP0xpuz3Uje4
         1OfEh2ERrCDAWjHQvn1L3Zd93GR/QJHLlMYqn3Qk5haqVTAM0qgCQeA9PbqVDLDp09pi
         vehA==
X-Forwarded-Encrypted: i=1; AFNElJ9YBup5MsSqWMOasFQZzIfpaTz469A7J0x6sWm+Z4836KeH7NBtkCSwOSs5fTHX/fBLHvHnEDp30w==@kvack.org
X-Gm-Message-State: AOJu0YyBVMkCibBk4eJtlj9/qsSF90CB6gC/X5xjErS0fppaR2semiMn
	07aNew5fvu7GLEXqbe3c/puhBhBOYIAbbCr+ASII00Ra5TzOhpwRZnxsYV1irK6FiAo=
X-Gm-Gg: Acq92OEfHTp+5H5F7kHxA4dmRHmANX3y0dbMeV3Jz3WOEO9jtCeBbqBnGz6wV2jJRtV
	Q1bCcI0EFGA6qO245MJdagQPlVDbBxMg+KkzMoLNS0Zvmse/ujxzaFd40yHG8EBLODbd0NKo7DJ
	XKcCDF/rjY+a8kIRbS5HuMlCTZKhQX5w/1xeZHUIXSr/doCwUJ9E8OvI5Xp5g1XyRVVheabH8De
	+hxxnhOQGyl58Hlt4BqHo1FF2pS3rt41+OEb5+zY8IS4qC8lK91l69SE5WJCpJcbAc9xGEDr83k
	uEp2px3dfPVq6hxSRyFM5oextr5+mK93DB5DaAFIWTV0J7RwLyWU2Fb8rCvlQb6gYv71Fsi4JFI
	wUkmQIUlP677tcgb/YE5GomYC0NrFEeg9zfK39kXZdSIz39jVsUb5Hd/7XG+Tnt1CmCMZe8bNIy
	GGfmNuJWutMV8MmoGjoUTxuxGHUTM7xPKJvxZsV7TpMGN4hlYgIu7J0HTJW6gU59ocarQUT3s=
X-Received: by 2002:a05:620a:4081:b0:90f:d004:5471 with SMTP id af79cd13be357-914b48b6c0amr3161673685a.1.1779874729558;
        Wed, 27 May 2026 02:38:49 -0700 (PDT)
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com. [209.85.219.41])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-914f86fffddsm416197385a.12.2026.05.27.02.38.49
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 02:38:49 -0700 (PDT)
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8b6dd874471so170141446d6.0
        for <linux-mm@kvack.org>; Wed, 27 May 2026 02:38:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/ms2V9ChW5nVddLkvSproJQXAsXGpcRfW6JMH86GIMK+7UxAKOwlQOq7w+g8iJJDC7dBojdGURCQ==@kvack.org
X-Received: by 2002:a05:6102:54aa:b0:633:75d3:3545 with SMTP id
 ada2fe7eead31-67c84ad8af0mr10485506137.30.1779874287601; Wed, 27 May 2026
 02:31:27 -0700 (PDT)
MIME-Version: 1.0
References: <20260526175846.2694125-17-ardb+git@google.com> <20260526175846.2694125-30-ardb+git@google.com>
In-Reply-To: <20260526175846.2694125-30-ardb+git@google.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 27 May 2026 11:31:16 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWBcpw8NTg+EVBmwiRWY1001EN94J9XstHG9o_hyUg8yA@mail.gmail.com>
X-Gm-Features: AVHnY4LA7PW8Q0XMk7lUiX1q-1VC5_AKr651tENC3X6CCFiZsD9Tq-B3NK3PBjs
Message-ID: <CAMuHMdWBcpw8NTg+EVBmwiRWY1001EN94J9XstHG9o_hyUg8yA@mail.gmail.com>
Subject: Re: [PATCH v6 13/15] sh: cast away constness from the zero page when
 flushing it from the cache
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, 
	Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-sh@vger.kernel.org, Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Rich Felker <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ps397tkhuqp1544raro6rnitztqpi3gc
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7977D140002
X-Rspam-User: 
X-HE-Tag: 1779874730-940639
X-HE-Meta: U2FsdGVkX19kmt+bVFL7MYjOkX+vFzbwNaDjSmNwik9Je3EGHQ2US7tYwlPoe00tug3Y0gBRLMsPjSSwJhnI9smMGcFxTTNFqJrXWmc8TKm3imgVPK7310iL0S24/4dLiLi45fiAlS3jbnO2iRjRdLIyuG4UpwC46yaRCiRoPdPeY/fm9UfFYYkZmDEEuH9Eb6tkSQnfi10Jk0I4nyfS48sAGUXJyR4W3fwbszcRLl5gP3umpk+dQGCFwCS2NigqZIgRa/n6WLDb8UJqxPz681aS4O0ycItx0QtMD85pDrQuGKQMCResVGxQS0yrEUmpTu0Z9rI3h0PW7M0G2oKioRnrCjb1qdikYPYi+k5AGIr/aIANpKggFFmwZL2iic859OafjWtd/1yNItLmcKf9Wj+2n+VMdEFkY8oGX4CMTxZjogDcvUx5PP6tiIDF3sgsP4fzxZgYk5UCadWM9/xFuVBLRUzT/iVvtwWNlf27Fqk5nE++7FlBbGxaQ0kthWXqJDk60EZnIpDF+CIow0KKbNYy+w1evGIpCWc8+wMS/uOvJxpSG0pNGhUC6Lgo2LvDIAr7mzQYkoiBW7hvXBbPsHfCkLuMHLQj8qRqPfC8+BUzjBFqZ4GZNW35VzpdVBqlLKdlnFdQMfA69a54AY9HaO9OjRGipj/ziwpZRnxNop7RFRXEptdgufG2JRgoEULCj894pAhAgXkc26KQcYqlb35lQ5loL32Mjy4xf3L+5rNslr1j9vmu+C2/LzS2yAVzU6N3C0BbejRX3xJidnohEBsxhwKnAuvlz9V+pBLaBtVRD6QJJj9B2RPnc1Cb8cP4/0juQiaYMUY0df+0hZPV1gk4gn5uQq8ngmun5qNd6dFtjqjcbzn5+1dwheyb33mHmVwqEw7bFeRTORq+nIRUsxp+Fvl01ibfXO79kb/+zs3ZzzY+tq7Gw0ypfnkYqNrOMwwYXiE9yo8hSjdf6N9
 3iHzLR2Q
 5/tqASPK7hqK41efwFIvghAE28+CGGWW/zol8UOwPQY/BBzERAUjInW4uFHYrhNe34PuASu7Kb9fwtYFQCL7tMdT9nGewzWos2G6dpMs3HOdmWRdo7SH6sJssR80c5ILJ81FeySQyGe+YDN5iZbMBjRS9SeF3rjD1xtw8BrdG/lx0x1448FZP+k/M2tWB8+hwKc57lYfQ7LctVi6P/OHC/xOQERQoNG3mFIP/1Wleo0X4c7uozHK3XGi4VqTvMsIsiG4hFd9tkHRhy00YA1ex9gWFyTRikTNZxLdqmi5ZEWBgvFgsId8Dc785U9inutcar8gyNbY+wU+lB/f73xGtnJrFwjgNlE/SGRjPx5xC0jFwTj2olDBmFVxI5ATbls1vv6PJ3B4b8go7dU3sKZ3i1y6mTk4PiZITWUUbsPrPq8h1POfnC/qJVa54q7gjLhujtAjxQTkXCGyrp/JNFE5VjmFtAEyVoPVJYAm/VuQHo/O7b1B2/GTRmoWCnIJxqJxp7eOuEzdXy2eNbJ7SeIAKW4qfCa5F07cWgxNDX7WSrIaDe926UHThr+k9sicLWpzJCN+3JXP4nV5czPEv030Bm7ymlTQaGgjiscgI479kn7eTKczSyF1JtHzQT4RtPhTmh1T3mM/87iOQBI8diJ6RmBr6CzUWeEp4ewEa1hHyt5ZcbzU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 26 May 2026 at 20:05, Ard Biesheuvel <ardb+git@google.com> wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
>
> SH performs cache maintenance on the zero page during boot, presumably
> to ensure that any clearing of BSS that has occurred at startup is
> visible to other CPUs and DMA devices.
>
> The __flush_wback_region() function takes a void* argument, which is
> conceptually sound, but given that empty_zero_page[] must never be
> modified, it is being repainted as const, making it incompatible with a
> void* formal parameter.
>
> Given the above, and the fact that __flush_wback_region() is in fact a
> function pointer variable with multiple implementations, take the easy
> way out, and cast away the constness in this particular invocation.
>
> Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> Cc: Rich Felker <dalias@libc.org>
> Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

