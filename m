Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EAC6C5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 14:08:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7685D6B027C; Thu, 13 Aug 2026 10:08:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 718E86B0285; Thu, 13 Aug 2026 10:08:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62F236B0292; Thu, 13 Aug 2026 10:08:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 380206B027C
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:08:10 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AA9FAA01AC
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:08:09 +0000 (UTC)
X-FDA: 85096425498.11.A421A1B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id DE4FB1C0019
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:08:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=Jo4EJJT7;
	spf=pass (imf21.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786630088;
	b=F3jMfpqCjaJBVV8AZO4OBjAS9LiYvUu5eUwopo4kZHtNRHl3MFGwOmO7XJfzEjfLbtIyw4
	vvZXJs8cp+iWStlRslKuTnkuyGlqT3hUgjZzL2JxC8zCbdDYESR41g9jLh0xTjP/EyU0cp
	ORb/JrexlLcmTeR61CLIDZkYOXGK7ZE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=Jo4EJJT7;
	spf=pass (imf21.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786630088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ILJpY2zOeVhfdUYo8J0UMIm0dyJAM7pQkJ2oTlpZAH0=;
	b=7DOnxH3Bj2fEIUACVDoMMLfN7R+QyNvQ/VjeYvcuL1cXaFwZv1ejUNAptgv5uVu8MsScBR
	zNmxixcH0tl/XaTTvTJim9SEVy0zlYQbcSbWBiwB+V1LY607Wy1ovjoAoHoFcXopgYouAt
	onv9w0xAfTUPOwxjFiXy4fINvZBFTIk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 58D3461895;
	Thu, 13 Aug 2026 14:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4F61F000E9;
	Thu, 13 Aug 2026 14:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786630087;
	bh=ILJpY2zOeVhfdUYo8J0UMIm0dyJAM7pQkJ2oTlpZAH0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Jo4EJJT7ekasvk1jXDjxSIOfXcu2sd8vYPAdDUba8IOdeWRPVJ3DS1M7aJFDnpvIi
	 VRNE57tRh+FU7UU+Ga7XtJ8diU/77qaBeR0atIA56y2YZhgczBuDXh6sUdM3LXB+qq
	 p/JFPbe9ULhEk3nsdx4C7Sr5/JsXFLZeWBiSFqv8=
Date: Thu, 13 Aug 2026 23:06:33 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel Palmer <daniel@thingy.jp>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Hajime Tazaki <thehajime@gmail.com>, linux-mm@kvack.org,
	geert@linux-m68k.org, Arnd Bergmann <arnd@arndb.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 3/6] mm: nommu: fix an issue on map request to
 /dev/zero
Message-ID: <2026081357-shifty-magnetism-aad9@gregkh>
References: <20260813063401.1786548-1-thehajime@gmail.com>
 <20260813063401.1786548-4-thehajime@gmail.com>
 <2026081355-remold-sterility-84f9@gregkh>
 <CAFr9PX=zC8GnxwrR=wTwA4xQq89cHYpxZWooS+-=Q-WuNbjanQ@mail.gmail.com>
 <an3COKVbgQKdY52d@lucifer>
 <CAFr9PX=dkFhD5Q7JWaR+rXt_Ah5n2hxi2W3biqQsUC77dAaZgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFr9PX=dkFhD5Q7JWaR+rXt_Ah5n2hxi2W3biqQsUC77dAaZgQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DE4FB1C0019
X-Stat-Signature: 6shnk8sq4eydcrgyiys65fiswefmboxx
X-HE-Tag: 1786630087-254752
X-HE-Meta: U2FsdGVkX1/fl5GYOPD2xApMURQWJvBfT44MAA6BoOAMciI7Rd1Ol1gINITyzyZPmccTU4F8GlrjBQJD/OmXl/Cw1P2U/OPRFnKM5g9wiLkBw6ng07Rv7xUSXP3bHTT+dtecCArvNhR28bue6CQiB9osjpRj//3gXDaJCagT6H/5h01sKdYk1SJ7Stzva8aLEwbrBseJsA7B+0DSRa3RT8Ot+Pl4ccx11GqH+vEAetVrwTlz1HVAlJr93ZIufrvdXqvauso5sbJfPg0RY6+J8ZDVBrdxuBuc2xCUHVqmGlqbGihN+fYVku5ZR2QPEsstGOcV7SQ2cmz2ovSXN9pj9G5gpSZdRGd7/vvJs36fKmdg+Xm64Fw/+k02SNPXkEXC5XzPM+k8jH1jv4b9uHSGKkPBXKlXvg46T/uB9dUfXh2UI9p/PsqhOgM2DRx9uJPS+XGCOIBrDJBBfFtpmEndOWDmEhsv6yHMrSAit7sYEZVIj0xZa1bPV4Fh59FdsRIJbSeFfj3xPnvyZx4JWedQNN6DfSslrM5ZEZ943Z2zGnu1wwR1Q/hiU1wzBi2CXHxZTox6hIliLEiCUQLc7zGjjtz0NTnLQUHXyCGUqZFucn3fZQjrYHaZVUEZpPBQ7bk+5n7bkNfCM78Y6LhJxT5LbbN6O3vsgnarg4xVRBocbOwb3Nn02quEP7Lv41nl4Sa8CPOITle2OmniuQ7Go2qGt26HAtdnm7YGPAhWdSC81rNRbpvCRp1yzcuiHr4TeROkEzujvoVyTnJRaVv/Hg7ETjH2UkhYLgh/tGO/Ogrit2PCBTSOR+gR0yP3+QrmTw3Y1S1ek84Vfhe4cwIy1NzFuZG6AhQID+SxVoE0BSh/3fiefD2C+/+RsNYMVeK9uqCIsi48U4aXNS+hcZsiT+HslB4nXra1NdB0p8AjyUU9aeYCO0omLrUcu2PUZzgTkwUd3sd57EVlr0NERwxl8Nv
 lMxSEJkF
 huJDJa4tOMDlyL9bLjEhQcNwGO0oMfUnEBmZc3rHJtzJkqZnikhqFm4JDSSAN+n4UFDg34hedsupC8IdKcL2BfUhFWyAWAKvPtdzD2u8VzTlCnWSHo0bgOZmdw2MjNu5mWgJJeSWQwszDktvK3qGBwFPufsvwX9oUJcPSxxK+8y3sqQAMxv4HqYi3EgG2vFWgubgEr5pWMyTZkep/3vaTm+7+/FxWPYuxjgPazZbbs4tMdu5q44jeS9JZPsxiHxK5/L7Z+oAEMKu0dW6g3fbz9VWHorILTMDyEozjbFrJNwTf7SUowbsugcfqjDv3uHgeFwfqKIUPGVfWau7NfBun2SqHxoJjpViOi20W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 10:51:39PM +0900, Daniel Palmer wrote:
> HI Lorenzo,
> 
> On Thu, 13 Aug 2026 at 22:30, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> > > One of the big problems for nommu seems to be that everyone is
> > > convinced it is completely unused and totally broken. :)
> >
> > No, the issue is that nobody seems to do any testing or contribute any code
> > aside from at least Hajime (thanks Haijme :), and possibly others (forgive me if
> > I am missing people's names here!)
> 
> > There's been situtions where nommu has been broken for a year and _nobody
> > noticed_.
> >
> > And yet whenever nommu comes up people always seem to pop up and say how
> > important it is, then mention a talk etc.
> 
> It also broke sometime around LPC 2025, I spotted it, reported it..
> and told the people in the room at LPC for the nommu talk that it was
> borken and maybe they should take a look. :)
> I think I maybe even told Tazaki-san in person that it was currently
> broken in the hall outside of the session.
> 
> > Well if it's important, test it. Test the tip kernel. Report bugs. Contribute
> > code. Any or all of it :)
> 
> I rebase my 68000 tree on mainline regularly and make sure it still
> works. That's how I noticed and reported the above bug.
> I have a bunch of stuff that claude fable found, validated with QEMU
> and then I checked on real hardware but I'm not sure how to send that
> without it getting instantly marked as slop. :(

I didn't say anything about slop here, and in fact, _I_ have fixed up an
io_uring nommu bug in the past, using LLM tooling.  I am not objecting
to the use of that tool here at all, I am only commenting on the fact
that this bug has been present since 2020 without anyone noticing before
now, which implies a severe lack of users.

Heck, the out-of-tree ia64 developers report things faster than this :)

thanks,

greg k-h

