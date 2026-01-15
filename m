Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57F23D46601
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:10:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C04166B0089; Thu, 15 Jan 2026 12:10:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB2966B008A; Thu, 15 Jan 2026 12:10:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB03F6B008C; Thu, 15 Jan 2026 12:10:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9BE186B0089
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:10:21 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4D1A158C3D
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:10:21 +0000 (UTC)
X-FDA: 84334836642.06.89916EC
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	by imf25.hostedemail.com (Postfix) with ESMTP id 40886A0011
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:10:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=SyaPhGpa;
	spf=pass (imf25.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768497019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tia7F1V+yZWSVZsx8IjEn9IJb2Dvlx2/jJlMSpKCFRw=;
	b=g9+p3EC2clu5oMVet4AxQ0J0fu2tMh0ur2cgZxGMmMae1pP6QjVVFdElA9V+PQ2Vb1Oy5A
	v5+/EInbsQuHzxOfd5mv/rgDC+LzAgYt0NSXEaMd+unM0uB5MjXNLIGzvEfIz22KZE+Moy
	54HypvnfM+OFUaWMQPGVciz5pN0kGzw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=SyaPhGpa;
	spf=pass (imf25.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768497019; a=rsa-sha256;
	cv=none;
	b=BrAqQ4dY2DTtkGR+3kKaw8nypKbO9PbkZyKv1I+EuSNti8vMRr1U4+ZheOaFydrg6JUtjc
	fFPTxh/Qv0YTz6ooWAeu7gXvMYQknPLARwWYfV1nwc6xOKcuxDJhWlYbE5A8bASIxjCO0h
	Jm6fsL7uSyuHwBe7yTK0KpFB934vlUo=
Received: from macsyma.thunk.org ([37.140.223.84])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 60FHACgx001540
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Jan 2026 12:10:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1768497016; bh=tia7F1V+yZWSVZsx8IjEn9IJb2Dvlx2/jJlMSpKCFRw=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=SyaPhGpazNStFD4d5vYYHZcCZTA8n4DrcNdBBTcOMTl6T3w1VhPLTGXI5IRDWwqii
	 iOmVEI+hv/ST4K7kvuhV7VlLe4I5XtbTNfHQ2aZD4E64xQjH8YS0W08GLgyUAPVoeA
	 A//SE7cddGg17V9NoQ4FgK7DwIy5B4YoYv3LaKdw3XoOWD2bzYhkyGwsakcP9nCfvy
	 jzpjh6Sjopvq/ZHB7aXpVB1mKg1gkY3XU3OK2//D0AqUxoOuYs1wyQgm1VuoK7bLOP
	 sXX0A/QyBjmkCv9Gx4ySWQ5Kl5sYrtYvvRe6E8vrnZeUYSjFJq88Xkf7eXv8O30KBe
	 0/XRCM3pnEZIg==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id DAA7154C9085; Thu, 15 Jan 2026 06:15:59 -0900 (AKST)
Date: Thu, 15 Jan 2026 06:15:59 -0900
From: "Theodore Tso" <tytso@mit.edu>
To: Nathan Royce <nroycea+kernel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: TmpFs Incorporation Of FsCrypt?
Message-ID: <20260115151559.GC19200@macsyma.local>
References: <CALaQ_ho-dx9CTee_-R1VFreX=jB3Zbdjo68fdnnwC1cPoPcjVg@mail.gmail.com>
 <20260114204352.GA19200@macsyma.local>
 <CALaQ_hq==FY64FcLedWnpgOXf_aT9g2eNyM6BgWwvTv8r0FR7w@mail.gmail.com>
 <20260115025920.GB19200@macsyma.local>
 <CALaQ_hpNLkWBxKbFdCKyE88OZvydFN1Wg7-sbr-yZ3vK3Anazg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALaQ_hpNLkWBxKbFdCKyE88OZvydFN1Wg7-sbr-yZ3vK3Anazg@mail.gmail.com>
X-Rspamd-Queue-Id: 40886A0011
X-Stat-Signature: fawh6jabc8otwu3ztemo7e1sgic7jcug
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768497019-192015
X-HE-Meta: U2FsdGVkX1+kN4NsUVS1hiui4VsusPp6SPSQXVNMeOjTzynFkE4MDJP5jfT6NVkZ8BLCFuqL4i+n/Nb0JnYjXccbc4nyTCG9G+9RX00yqa22t3d/dbk975qRuZhPxoomQsF2TdMlSYZ8+/eFeGawHH3cE+PIxSyJhEjhtqbmA7V8x/AHQh+MVQC3wQ4ZWFrAXwzYiqK6fFFNDtct2MZqaLmz4kxNa88nKOULO8mTa6Ppx2vs12cC7ttNWXpHexTLfUbUXRqvLezj29LGvpA96B2CuGUWu5iXkAhrrpf97ea43+KHwLWuwk7s2kFbtHLuYFFsRaF15sS4WO8ZQcBFwzf0Fvwa+xwwTKzsOLZlIS+0SEffo/xOg/HM3TssE99qDZc80pnGdcBYuowhLS2Uh3qILI/nxFWhT1RW9cvxHuiz+rbPXdLyG3Gxsdfxpo4YAMHfhzhxC6A0J1R/qCIlqi5G4u8hw9eFT5sL13X0hngundwDe/mP4lhl2bK9e+gllZ7+x0CCrX3SND6OvCwVFaaM3X2dv4QwtAnR9nAt/sEEzLZG5YzmjVAMEnB5r6KzuclB83B+xD1+O3FFdY1LWU2QfgQrZ2IJVtOX61ycTTOTErtYG9zPMCtrAtla4r/cNaBeWmB8vMoSHwTQRiY2+7qutvYvj7QexVF0ikKZ9aom/bm2v9opmXP+SjTeA7CimOFJu34wmDdmre2MWLrAHhbaX0WphPT1+DvAy4DJKOfdKV5me8Sb/6MM1Erp0qYr+OXk3SCK8TdbYwhGveHsNd4GZPoRX2EfAcv7Lu84n6h1qhE1EibasGcALkXHE2M7Tu4HQiOxaNoHcGlcQ14Tbfdqt8rImJ6PZriXW3fHoAw8ta1SLB3myeapUm1RtrfsoLxw4P7wvgOQt17/GWvdE5MlGqydxorUDG1W+5xkhG4ymwW/5BKl47323PsNwQMDyBTB2zBlKo1VubiuEMM
 PNNOlkkW
 zLwyQsqEwoYFhYNsZkGpYoSjdYEgVcz+N4Dxen+mj+k43BAG7qUh3Aia1fNbsG3OXWqz4J8l2K65K+KdvI6h4BGk8SV+n0Gxi4mnKMNUlm2EHQ7Lp1td2wNjJgzZ0PG7ZBZ3Bt0Z3Az1yECREVqOfOsBYiI4SeoIX+cGOe+w3KC0C/nej71Ul8sbYeDsN4EkvWg0iIroogCp0uCvrFoOa5eopOdXN9gAk1HBicc40fZr+n24qaLYqVXQD18u42mYZoQAUofUiVwXEaJSJxqeH0mOmaw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.026596, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 01:04:48AM -0600, Nathan Royce wrote:
> This is the flip-flopping that I'm talking about for myself, because
> if it worked the way I was hoping, that was the real draw for me.
> I just figured the inode structure might/could also be session-based,
> or a mix of global/session.

The assumption is that these use cases (ChromeOS, Android) were ones
where only one user would be using the device at a time.  Adding
per-session keying would have been extra complexity and a performance
gain for not a whole lot of benefit.  It's much simpler to just wipe
the page cache and encryption keys when the user logs out, since the
primary goal was preventing off-line ("evil maid") attacks and
zero-day security vulnerabilities.  

> I was surprised when you mentioned the ability to reclaim space from
> encrypted cache, and went to look into it, and came across
> https://www.chromium.org/chromium-os/chromiumos-design-docs/protecting-cached-user-data/
> (even though it's ecryptfs).
> It makes sense, and is a valid good reason for keeping fscrypt into
> consideration over doing something like `homed` luks/btrfs loopback
> file.

fscrypt was designed as a solution to avoid the races that allowed
programs like fsstress to quickly and reliably cause system deadlocks,
as was the case with ecryptfs.

In the case where you don't need the multi-user keying, the ability to
share free space, and the ability for root to delete files when the
key is not loaded to manage the shared free spacee, LUKS is the
preferred solution because it encrypts the metadata.  fscrypt leaks
things like the timestamps and file size, and there are ways that an
attacker can use this to figure out things about how the system is
used.

For example, consider what might happen if the Chinese government
created a fake "free tibet" website, and embedded the web page a
half-dozen hidden image files of specific sizes.  Now when you cross
the border, and they seize your laptop, if encrypted files of those
specific sizes appear in your home directory, that might be a strong
signal that you had visited that particular web site.

Like many things, it's all about engineering tradeoffs, and there are
reasons why some solutions might be a better fit than others.  There
is rarely a one-size-fits-all solution.

Cheers,

							- Ted

