Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4491DD3517A
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 12:09:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 788D66B0005; Wed,  1 Apr 2026 08:08:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 739F26B0088; Wed,  1 Apr 2026 08:08:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 676C56B0089; Wed,  1 Apr 2026 08:08:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5621C6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 08:08:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B7AEBBB736
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 12:08:58 +0000 (UTC)
X-FDA: 84609865956.21.A8C2E64
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	by imf29.hostedemail.com (Postfix) with ESMTP id C4EF812000A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 12:08:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=qVhrNEMw;
	spf=pass (imf29.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775045337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=//7XitCZDuL8U313dQu90sWodjmALOrjLUhCd5TQrMI=;
	b=r2jDNPznz0t8tTZ4MSlXHwbXEXg8Mhc2iq4T5wbiXSwg+Bk3hJfHaoNG0XmgLzaGVVDDH9
	bonA4lyY9mpqm+ZtjZu+iGFjkpYzT9+4oLzXzVicloPBSxbZmh+6TgxC32ocs41Tyc0eBp
	DE1kvTslPoVlB1oa7oALFNJp3fWOBWQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=qVhrNEMw;
	spf=pass (imf29.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775045337; a=rsa-sha256;
	cv=none;
	b=KVnz11GnhT0JiDwkNsPidg9Mr9XoV9DOqaL0YLPGinQNBEdoQsmRt+TL+jHk4EZmXR0x60
	cqS9QY/AnaQ74nACiJdjH+gfnXwx/LLm2vzWs0QcwrtWDkMa2T0lTkYF4Ib7px9BgIB44S
	ybXWcI7ETeP1FfqwKhn9nAS+lTVdZYo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1775045333;
	bh=Zsz1KWW88aqJcvMBUIOh0Ys1zgAR7pErU1ze+icLZtI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qVhrNEMwQvEty5OInor3o7jjNTKDrf5eYOiqax+m5k49pdAI5GZ6b1wJkU7mc33Fa
	 fO2ZARKw/2fimxKOoitqgAPMASC6pyrF9j8Ta1FEZxMHbhTIXY83YPeG1dLmxVissW
	 rmmPtGiPAv26FsohpFsoWNZ5ZcCQFWPBPJ3rvl54=
Date: Wed, 1 Apr 2026 14:08:53 +0200
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
To: Mark Brown <broonie@kernel.org>
Cc: Chunyu Hu <chuhu@redhat.com>, akpm@linux-foundation.org, 
	david@kernel.org, shuah@kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH v7 4/7] selftests: ksft_exit_fail_perror: support printf
 style arguments
Message-ID: <c6976e34-54b7-42a8-968e-9ae967c52968@t-8ch.de>
References: <20260330151503.670415-1-chuhu@redhat.com>
 <20260330151503.670415-5-chuhu@redhat.com>
 <efbad6c5-8d5e-4774-8d0a-d455e6e2c182@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <efbad6c5-8d5e-4774-8d0a-d455e6e2c182@sirena.org.uk>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C4EF812000A
X-Stat-Signature: wt4cjqzaq19yet1cqwqb1u4m65pgre7u
X-Rspam-User: 
X-HE-Tag: 1775045336-697091
X-HE-Meta: U2FsdGVkX1+s84QWt6T1kmyTCO9F0xZy9Lu/XlslpMKjJ8o9tOGzpTVV/+U0toRdJ8jp1UqWngnSx004KbzEM4drA4RFgHL37T9YWD6PWwSGlaH8BQECOzt+rlyM8HtzjMlY66VY47eIS4VlLjwvbNb/1xAJhKQuSVvFv7uPxFG8vJrOKJv3aEfQsDEUf/fzgEWGuhTgt6A+jN6pAPnTVeejKRaEmSFbBx6HhwLgcIJ3d9z7OP8JA4vUj+noH2/r1fygbry9Hh+CRHzsqcpsNMEy1VY+WlkopE6Hhc9s2LSs6ON2fzTrnrixYqTxqFU4KLzcTQdi7IW/hpqwYZ1s/YpPNv1f8fmCkst24i8OjbmwMiQr0x1k6FVu5t01bh9Ej3y/KCXtHAOcVce4+Fy7R7oR7INnmtbEHrrfYmyXTPd8OwPtE/C383BHILPKaX0NM7G7GXocA6woHo14Igv5a6ADIMSardP3hFLwHnwpojlpvr41xWmWB4z4JEIZ20eo64qWktR5wg3bOrasTsaItUKpF5fxJSq5acz/x0DT5ILyyGHR6K0svRH8f2Nr7qcOTo9a/MvNREAIMXybYtHmbB/9GbdymorGuwi4AKGOCQTmRozWp8o3pnTadKjAxmR6VRkzBMoORpK/b6YteobJbFBJ0/x95PddrPzKCKdcviA7hBSsCMYOR88prDUW5T6GdmtThTaBkbRNnwjHvPQkJUfnD7406Ko8ALidoA3MzCWmwPR800q1RFK1lDLb6UoF6l5DH7BE3bfpdMcf4vSBT63eJCmZsfnAdsz+yHtfauV9YvpBx4hEHeTORMh9EWp2SEQL3EgCGMXynDDvg35WoUmRmrSnVDsZfW+66gaSay/iFd5o+R4wGGyCshX6BTaf0KMHYlb317Oa/lWT8Yr6UtaBoML/WfOJ2sG6Gr9smuaYqxISVxnyXGiQtzVNkXuQy/uWlOWLsJVa2vp0vNS
 NbZkgHQN
 2/xIwfOtOdiX7chI/8miOvPUwOSykL9Lko4XM/FN1xusmHmlTQ0SYqeju2+n7rgyfhRA1zgIkdRra65sQoVzHrPgqKEH/PkdniNptB/PGwPPCmvXHfRTmyK4q85IAke3bXkOrXI1K2qtwYqPaV3nC0jEVzZSs+6fLzwx/O8l09zIeKyogomfV3LcjqvqeYVS+eTjZ8F2GtbsSRnd4NNVHA99UzwHXu+nUW3F4E8dRJeKbARY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-01 12:03:09+0100, Mark Brown wrote:
> On Mon, Mar 30, 2026 at 11:15:00PM +0800, Chunyu Hu wrote:
> 
> > The ksft_exit_fail_perror function previously only accepted a single string
> > argument, which limited its flexibility for providing specific context to
> > failure messages.
> 
> > This change updates ksft_exit_fail_perror to support variable arguments,
> > similar to ksft_exit_fail_msg.  Adding the __printf(1, 2) attribute enables
> > compile-time checking for format string correctness.
> 
> This is causing build regressions on the arm64 selftests:
> 
> /arm64/fp/za-fork-asm.o -o /build/stage/build-work/kselftest/arm64/fp/za-fork
> In file included from za-fork.c:12:
> ../../kselftest.h: In function ‘ksft_exit_fail_perror’:
> ../../kselftest.h:427:13: error: implicit declaration of function ‘vasprintf’; d
> id you mean ‘vsprintf’? [-Wimplicit-function-declaration]
>   427 |         if (vasprintf(&buf, msg, args) == -1) {
>       |             ^~~~~~~~~
>       |             vsprintf
> 
> This is because za-fork uses nolibc which does not implement
> vasprintf().

We can add vasprintf() to nolibc, I'll send a patch later today.
But it will be fairly inefficient, as our malloc() implementation
is *very* simple. Not that it would matter here.

That said, I am not a fan of the new ksft_exit_fail_perror().
What about this:

#define ksft_exit_fail_perror(msg, ...)	\
	ksft_exit_fail_msg(msg ": %s (%d)\n" __VA_OPT__(,) __VA_ARGS__, strerror(errno), errno);

A similar treatment might be done to ksft_exit_fail_msg().

> I need to look at why this managed to pass the build testing I do in
> -next...


Thomas

