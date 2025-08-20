Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DDDACA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 05:08:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B90588E001E; Wed, 20 Aug 2025 01:08:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1A518E0011; Wed, 20 Aug 2025 01:08:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A09038E001E; Wed, 20 Aug 2025 01:08:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8CD4C8E0011
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:08:14 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 40709B904A
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:08:14 +0000 (UTC)
X-FDA: 83795954508.26.4A94760
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3D718C0008
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:08:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RVYveFQL;
	spf=pass (imf28.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755666492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZM8ldhgHC1AWYuki6RpRSPMhAxKUWkvsFBvWhrtvLkE=;
	b=h3gG8yPJq64eS18WHGi3f4WlXOimRZXT3aBwviKWWWXayTQ3qCQqeGt6Lnbcv6VSZy7P+Y
	5AgeWVwO82tJnO3Cj0R+jTxjuWR0yO2Wyrl7lxaY7mXrGxoFBcupSI0pYEbGQZ2op9chm8
	iyRreAPbt67OiJMCvpguxNOSaVKLjak=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RVYveFQL;
	spf=pass (imf28.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755666492; a=rsa-sha256;
	cv=none;
	b=BHxEJT0g4zMzLl9kwYMWnEq54WBRo7hdggzWLbTt6VxKwMyPSQUEhoWhjv3kcOjqQunVH4
	YGtXTD+31jdwHtmZF/2JLqzep/6Oyi8Sj27q1XlBM5wvfaZKfpmw6J+ii2ar2pt7XpbWbL
	MnuhMm8bcmFxBrLGZ1Hj8pS13kVh43s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DE654465AB
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:08:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34BFC2BC87
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755666490;
	bh=y99OgHX40on6ADXNSxmxvGOSw8+Z8/8ThnthTGcVsk4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=RVYveFQLWmdxMXHFyjaRUQB2b9ZtrBS0jNDneYYIG/CtPVVs5+oxY1aykM5aBjJq3
	 FwKaqkJwBHN0XxxUQ130snihfdZpAqx/vmwB0urAEvsA5V8LqGu9fxrwA0x/AIJG+U
	 DDevRROUyyfp1x08mu7BQ/yaq/20pE8PdBy9Xcbgq4y/nDpKY9/KAfKFSrPlqTvKBG
	 A6Y7Ln9gDa773KcxL9G6iR+1BYbps75sckrutnqCoI+KIpxhfzYgsv0FJ6/pT9dn6f
	 SnV82a1kXqVxbwzPjszLbWMZ7Ls9BlrejmxQg3pQwKazhGf3VeApGRLDyJusbppcn+
	 7J3ah1MdBuaYQ==
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-459fc675d11so28945e9.1
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 22:08:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUD1qfcki6pVT0gpKMh9024AMKUnAmA6hwVy7kjm8cXbejf0guiEWsHeupmnmru4bURxSPT5dMLVg==@kvack.org
X-Gm-Message-State: AOJu0YyYrlUXGBdb0SlTbZkUTLuG2tpt9tLjX9pusNl7IliNGXNDuY7H
	Lop8immvfbmFyZVwBK4uZruDoNmoZjUSTZjYLSNABBlhacaFh+kZH4vHjhfjoF8SXJqVYyCrE+c
	6U0Fw5tAm+FgrQc/eTyMJDNS1DmEfuoOUiNJrFjaX
X-Google-Smtp-Source: AGHT+IFhIzuv03luG+BoMe6O4xCkFDBZpYYxSUt5s/dQ0dX18xb062MZ8DznmZ+Nwe+PubE77wGdn8A9FVeSk9fJBwE=
X-Received: by 2002:a05:600c:64cc:b0:453:5ffb:e007 with SMTP id
 5b1f17b1804b1-45b4777c033mr929375e9.4.1755666489205; Tue, 19 Aug 2025
 22:08:09 -0700 (PDT)
MIME-Version: 1.0
References: <20250819193404.46680-1-sj@kernel.org> <CAGsJ_4ygTv1tCJeuF43NhRR4E0kiMLpk6i8c+UHoUMt6LXykww@mail.gmail.com>
 <aKUi7hvcaK0h0oMg@gondor.apana.org.au> <CAGsJ_4z6YvQULrEmNjFjLNrJ4RK6w0+d9uF2-7v06gOYirrYRw@mail.gmail.com>
In-Reply-To: <CAGsJ_4z6YvQULrEmNjFjLNrJ4RK6w0+d9uF2-7v06gOYirrYRw@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 19 Aug 2025 22:07:57 -0700
X-Gmail-Original-Message-ID: <CAF8kJuNJ8s2D9NBdXDQ4vpBP0a-5k7r_=DdFuJJ95nMKmm6LBg@mail.gmail.com>
X-Gm-Features: Ac12FXzkxJ66YMlu3CzfHeCyeefFGrtiCzJsZOH8GdN7VhIacH_Aq7toBgk6y9U
Message-ID: <CAF8kJuNJ8s2D9NBdXDQ4vpBP0a-5k7r_=DdFuJJ95nMKmm6LBg@mail.gmail.com>
Subject: Re: [PATCH v4] mm/zswap: store <PAGE_SIZE compression failed page as-is
To: Barry Song <21cnbao@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, SeongJae Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Takero Funaki <flintglass@gmail.com>, 
	David Hildenbrand <david@redhat.com>, Baoquan He <bhe@redhat.com>, Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3D718C0008
X-Stat-Signature: sfsccfn9b9ydtbx5amns7h854x4psi5u
X-Rspam-User: 
X-HE-Tag: 1755666492-566868
X-HE-Meta: U2FsdGVkX1/nWsXd6iK4QzMVIgoBgAbtczVQPOb4u8XIxbIkX8cAwLzQ2u9lBQiF5LC18aCP38KCdlGEIfPMzAMGs+gta9pUoY0HRyeOb7pzfgxipWz6G1B7jbTw3uIab3i3ZT9l9Gq372UqiFvTwH9NG6QSzB0U3iXcpa1epe2zyyd7rJe+TI9tOwPqrvMTF6Le2L/V3qGZbuuNY9a2fzxKjSf9g6eji938RXvWq8AMCjqilOxeDR59MUy5hazyv2Dk5neiVaOGhNpsOzd0jvOZlIhhhV5ZrQFkUva7J684MZDDPyszRvz+4zDkTGz8AI6PeFBBNN3bLZO5/Cvcm9svFlRPaH9bHWPGo1KQTVXAhrm4+ldDGercJZcz8VuIs5miLaLYm5fI2BFBfu2Iewq9fPet19S/KhTDH7hEyqk3j9L1jlDgwgurmjNvkb56kjlBU/Jjv8Lgoe5QcBHlBewc7BJkwsMeIsZGjRTPIa8MPh0P77wdDyHAZdf8f6KUK6AkuKOZobtY+/P3xXXtR8tyWYwnaeaAdPTrv8Mzrx86W/A4f2D2dblavO9pExhWRo//K93Bliue+D/ZMhLlcxhPjXi0LuiW+PEiXEEU/ELbFKy7Ifmsk+WLaotJk9HFr/tricgHCW17/2IinBBdgqcjWeBW4MbizHnqyyTlYAQAu7v/U3F3INPduy67K0/2TvsiYfGUinO4ZZJqNMBojPpqdMWFhMjzO3BWLayQavjPNyyO2Hp9IzxneotYUnNqo2U/Zj6jNH/qvNJUg7w1G7C3r0ZUXmTGZS7vsuVr95AjjbtDpRxt+9QF3NpO9uR9A4KQFMj9YAA6J9Ncep/UT1So/W/Ab2zhsCgJzyNWl7fg1TUQbW/x7EbqlW3aq+Mot2z3M9t7QC7h26oEHQ3o2zkaUwWKNf33qAqyqhAnnZgr8osg99RqM/FTlVWbbowOoP43uYK6/RYt0vyRqxs
 cFo1Ae4h
 Mf9EGmMTjZP/ttxDCBk60YaC5WUrZ+U7TKU9i+hv/sTCvEvJpnIXO9m9A5sRTuO0U22Yq9UesMOmhT2+rAViSPpj1Mj+sm6/8UTXuhzLZxcUIAHGtL6jEzzVZLx7cC/wH35JJbW80XOdL+02wtUdu5Pn5nvXvQHevc9KlAiu6OBgePmNUcVw9EKeMjetpiUI7X5tXcl6JJ1fw0q5w9sXgZaW0QQWBxNLLuUb0TjmbD7PVnuBRyFWKHzXfJDNvK6PDI/BcPoilRyRGJwJkt4DuLLOyl4LjCxeiYOvD/C576DhrwgkBqUnpJvxWEQn05uBW3tiglsjTcqoGkKIg47MUU8FKY9XLrTjyfBlM9Svyant3hZ0EOW6HOwVotmYu679yHGKLDuWDfs9rKUa31DV+z9Kttq8bFVhI6fSM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 6:34=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Wed, Aug 20, 2025 at 1:21=E2=80=AFPM Herbert Xu <herbert@gondor.apana.=
org.au> wrote:
> >
> > On Wed, Aug 20, 2025 at 01:13:13PM +1200, Barry Song wrote:
> > >
> > > Let=E2=80=99s sync with Herbert: have we reached the stage where all =
drivers
> > > reliably return -ENOSPC when dst_buf is PAGE_SIZE but the compressed
> > > size would exceed it?
> >
> > It doesn't matter.  Software compression should never fail, and
> > if it does fail due to a bug, that's not something that the user
> > of the API should worry about.
> >
> > Hardware compression should always fall back to software compression
> > in case of failure.
> >
> > IOW all compression errors should be treated as incompressible
> > data.
>
> That is why I think it makes little sense to add a counter
> zswap_crypto_compress_fail, since zswap already passes 2*PAGE_SIZE as
> dst_buf, which is large enough to hold even incompressible data. Adding
> a counter that will always stay at zero seems meaningless.

I was thinking the crypto might be able to return errors other than
the destination buffer being too small, here we give 2x the dst buffer
already, shouldn't see a buffer to small error. In that case, having a
counter mostly stay zero, only an exceptional error case is none zero
is fine.

But if that error case can never happen, we should convert the crypto
compression from returning error number to bool instead. It does not
make sense to return a free form error code and also demand the caller
does not check on it. If you insist that the caller should check
return value like a boolean, just let the API return a boolean.

Chris

