Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0706AD232C3
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 23:11:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 438A86B0089; Thu,  8 Jan 2026 18:11:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E5276B008A; Thu,  8 Jan 2026 18:11:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31B666B0092; Thu,  8 Jan 2026 18:11:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 220586B0089
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 18:11:31 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8BCC51401BE
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 23:11:30 +0000 (UTC)
X-FDA: 84310345140.30.086F011
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id B126BC000C
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 23:11:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b59YoDqI;
	spf=pass (imf28.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767913888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XNHiapC99AUmMCJCO2j2w3ESAywZ8Y8Tno7kRjFgTko=;
	b=cLtxDRhRjdB/YCowv6I4t1WXHQpJPyHB1HMhKxdN7D9w48VmURcgYA85hy9TPsLmFqDCbD
	b86I14FgI8IKtKKsDPbrLSC5GoS0lowC7KMtUvQ50BzJbn8eiE9fYQjczJh9u+LyCbsdrr
	QUtiwm9fOy7GPJ+ybJQRcGGtiUJeiy0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b59YoDqI;
	spf=pass (imf28.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767913888; a=rsa-sha256;
	cv=none;
	b=eDqoKfwsj/wPTnfRtCwGo+o5iVPM0wHIzcpOkIYxkcLgIfVSHkUFazHldmX60r0glWvJoi
	e+05kDLZGvE3kvvMSb7nWL+xnIrOUJj2PjXulrJPkXAjeED5OwZGOcW9NN5R7GsQCbFnIU
	3xt+HaSkYR4kgazn6fB2KsnRqoLEjno=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8c0f15e8247so500822785a.3
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 15:11:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767913888; x=1768518688; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XNHiapC99AUmMCJCO2j2w3ESAywZ8Y8Tno7kRjFgTko=;
        b=b59YoDqIHztz/h1IRC7kkJ+/JgixQ7ArWkc/MfRbEIfGO5QJMFKQVuTlF56gz7GYt4
         scz0Q3y93sbN0wSVIfuouPfUCSEOGj1qzqNsYnyrCwj7fhFRsD98LM+y5yVK9ttWOEPM
         KRgkzRmiU37m49ElNx8XupAT57Q6VIQGDjqdQkVI7Ryj6OMSCW+BfMv+BiiY351Q3pq7
         3lR8H+qIbo5OJFh57MruPTEr+b4pa4vjlCKDdl8j2Jln9o784UvT3/0JIgMQCsWCxyzC
         Wog8pgznhe6MBV9JUuHS4yZf7pzqE8qk9qKeYq1KgZmkuE5tqWgdkvCn5/EpAI/An2xb
         zhbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767913888; x=1768518688;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XNHiapC99AUmMCJCO2j2w3ESAywZ8Y8Tno7kRjFgTko=;
        b=ndw4PvN9yGVmTauvUcjV8APXbhEL3xum6x1NdFyVcaJ5WCLnSQ1LVzaO2JOssiRKRo
         AqC+Sw8TyW0w/weGL43UtkMjHiDz4xooGA6fFIMwPtlKbzqknBce+mLugeh0k6uQTMkb
         HAGLJLLIWo5ZhD0lUxLz9mBmPRvbLi589e6dzy6T/4VhsoXixaWnL8ZN5n1ykdX4RS2c
         Tu4pqfaSrFBAJdpAVc6dLkth+aCS91QA7sXZ85IAyQBpHpkUhtbUT5PK+hRqxr0tKazh
         Ic0SrdpKeGomOpjYWRK21/vwnQTXUi2uP6oVbFGrPvOsKuRQX6Ga4StmSOgseaW3pgCk
         TbIQ==
X-Forwarded-Encrypted: i=1; AJvYcCX2kQem1Vv9hwYy0GuI+Wlh1nM4mjI6rYso9hD9NDbaACUM6aImdwi4GH6uLCDEBg8wEa2vhw0dsQ==@kvack.org
X-Gm-Message-State: AOJu0YzWbjDhUC60Xc3Rd+0LgBl3JgojVIbcc18e7sdcsvZBeiQJhDOz
	zJd92mcweAgu5F0J+6SQGIVtmq4xkH9KVe4QLNKYmSeUOLnOjnJ4zcFv9wUv/yQ4AmOp0x9CT42
	x5dWPbPuN6pPMcj70HsC6bRshTZVPeqI=
X-Gm-Gg: AY/fxX5NOBNbW3ZIgKXvLnxNV1tIb6Vnj+T0XNV6tlT0/mo0l3gE0rl6qGDXZprxkgs
	A8mlhaEv3AbQ295H94B21kt1IVc/udlqDa9U5Elri8p81o+S4CrAwp5YdATkzvs+8+ygNA+BQer
	nbnknBwW4dSneQDtyUmtVk07YXExygWcR7k3b11xnTeFC5pyMoCMkiiZFXWRouptHBi2KiUhUrP
	y+YDBzBHbB38+eSB4qI1tDYoSBGphGS6e7xs+O890arg0Psv1acPRaTpVXpnltrBqqsSw==
X-Google-Smtp-Source: AGHT+IHEQByyNRJTAQUFNu5ThEW5eQaRzASnOQJZkGVdn8HLtXQvJ7O3wifM7bk81elrzagRfPQdaGca+MGBg/P0j8c=
X-Received: by 2002:a05:6214:daf:b0:880:51b9:e8b2 with SMTP id
 6a1803df08f44-89084275dc7mr119405186d6.48.1767913887593; Thu, 08 Jan 2026
 15:11:27 -0800 (PST)
MIME-Version: 1.0
References: <20251226063759.4020782-2-tongweilin@linux.alibaba.com>
 <CAGsJ_4zd+SMa4Mj23tjF5OwsP3LQyvYTrwN4y81=k8FSFgbH3Q@mail.gmail.com> <aV_3fxlzwOSz8B0t@willie-the-truck>
In-Reply-To: <aV_3fxlzwOSz8B0t@willie-the-truck>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 9 Jan 2026 12:11:16 +1300
X-Gm-Features: AQt7F2oHOKrzfSL2LssjsEfQPu4bcd9R3NUhDfSnV_B8eZokCpQo4dn2s21CDqQ
Message-ID: <CAGsJ_4waQsxPKTcGvtpTAF4kVbYQXeH_iHaQX3aAYDNo-8oDLQ@mail.gmail.com>
Subject: Re: [RFC PATCH] arm64: Kconfig: enable ARCH_WANTS_THP_SWAP for all pagesizes
To: Will Deacon <will@kernel.org>
Cc: Weilin Tong <tongweilin@linux.alibaba.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	baolin.wang@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: hyqy3kexfb5ywman6qeqezm9eekg5y38
X-Rspam-User: 
X-Rspamd-Queue-Id: B126BC000C
X-Rspamd-Server: rspam08
X-HE-Tag: 1767913888-96959
X-HE-Meta: U2FsdGVkX1/nHZtpCCnGxzcCOMJbfunCkgpZlaDQBgn/HlfvY1GZHNvNtN219h2kzpOr2F4rAq55Pj0SPLyfGz+DnSh6cc4YevvtgkV09Hho+AqG0YNtHiZmZxgjqHXo78VeF1byrQUHGlL0lN27xJ0nJ6n0Pz4K7rtUIlSzCrPoMjqaTmFiN31qA5b2ERJ8tqumHgrwMr0bq06+uSj9PBLmln0U8OzwqPkCyb5G2ag5Mr1r+g5UucUadqzEjnlKGI7QAIziFZbP3EclhBUuYwgGWTs/13ftb/iGXEiCn9eMpCovtmuUhoadu5zxrit08wQVFVLvlNbkVpMX4H3ekkIB7X4yUrPtGkWdpz2L2d5m2t4KrM1J7DBewhoES46dRPVCc+kazGe/x6r1/Q+/TjUsG9TulofqsWiinGD4mkq2oSlYnAmqdLRMOK1L27yANUJztz43FEx+LkkEpBEIhi5ZVss1WuQV0pO5nLIQ1ii0Wdmhk8Du7zQF7JmSTExbT3eAfcclpRvorujGvg63+DRQ/0PatJ/avYmWYQ+YX4DyosMJcE8B7WkKV5/k0ZnrNOcdLviJYpsOxn7dBKLazG54thxqHWeJaBH69ONJKlA78UoBQY8/D67rLZZeY3NKtjngSuizWC7Cdkm4S/qJ5F+Yi++j5guqZLNbr8ChYwzAEF+8n+763azi3hQnTtt9YESVIpI8gIhv1825pjJQB2EE5w6/4JBXXItKAbZa+TEJ1477PaYHO3s3xLZD7Ff9ACjYJRqZRTGIkLmVfz0JjLZLNc4eoUQ9jZJogpcQIGtdg/SAkASj0bBTLrhLunpLSX6M6mNLQ1Rx+yTigyiaaDXMrA/ZMxQInCpcdzRt6xLhMzNQGFXoj6hdWdXQ2pTNP6hAWqUKMfN3zdygrzM6gOrzGFEwPukYMjSZegyJg4k6HnTPowRRNKreUyerg1jqX1HnJVXrrpRn5u8OTUx
 7Ts0FAQM
 pia4uS8R8a9bOu7VEC85v1yb2DdmAtoGlzeKyMCd68IKyJDL+VOVNFaGkvbNoXPJEl1iNu1t3v5BegVcY51zwCLFw38ii93t78YynCwvQJaPvqNljk2XFZRGWdcjn23n6SuoXHs/a7NaROui5rdtHFHIoliOI4AsPmlWFU9AJOK3fEqkJO46qt4g0vew/gyZRy/p1CBlC9fIbdh34ZFVdEz0ptsQVA9ac/zVDMrLZXGMKXjhuXDgLvR3KBeVan43qG1l4XIxph8euTXo1KwEyg1peZb/T6FEBLsrO0X/JYhJuBAtEy7My/tXtLqbCQp8new7v4z3UWJDXr7hImMjaVlX1ifJYELb7/hjqqgWwyLzg4JVD80aYQKEJh8Xt0dgeohXlFIW1q19pAJI10lDF/x/t6/e+sZrPzQoAP7J7yB2LrBfOAnuS8bCFqeW7BnTNlmvEeUvD0q+Y4/HZModw5stFtV8Qf3nZ9J3u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 9, 2026 at 7:29=E2=80=AFAM Will Deacon <will@kernel.org> wrote:
>
> On Fri, Dec 26, 2025 at 07:52:44PM +1300, Barry Song wrote:
> > On Fri, Dec 26, 2025 at 7:39=E2=80=AFPM Weilin Tong
> > <tongweilin@linux.alibaba.com> wrote:
> > >
> > > Currently, ARCH_WANTS_THP_SWAP was limited to 4K page size ARM64 kern=
els, but
> > > large folios requiring swapping also exist in other page size configu=
rations
> > > (e.g. 64K). Without this config, large folios in these kernels cannot=
 be swapped
> > > out.
> > >
> > > Here we enable ARCH_WANTS_THP_SWAP for all ARM64 page sizes.
> >
> > I no longer recall why this was not enabled for sizes other than
> > 4 KB in commit d0637c505f8a ("arm64: enable THP_SWAP for arm64"), but
> > it appears to be fine, and the swap cluster size should also be
> > more friendly to PMD alignment.
>
> You seemed to be worried about I/O latency in your original post:
>
> https://lore.kernel.org/all/20220524071403.128644-1-21cnbao@gmail.com/

Will, thanks for pointing this out! With a 16KB page size, a PMD
covers 32MB; with 64KB pages, a PMD covers 512MB. So, Weilin, are
we ready to wait for 32MB or 512MB to be written out before
memory can be reclaimed? By splitting, we can reclaim memory
earlier while only part of it has been swapped out.

While splitting down to order-0 is not ideal, splitting to a
relatively larger order appears to strike a balance between I/O
latency and swap performance. Anyway, I don't know :-)

Thanks
Barry

