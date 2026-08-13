Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B993C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 13:58:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2006C6B04F8; Thu, 13 Aug 2026 09:58:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D6926B04F9; Thu, 13 Aug 2026 09:58:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1136C6B04FA; Thu, 13 Aug 2026 09:58:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E735A6B04F8
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:58:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 76AD914013D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:58:27 +0000 (UTC)
X-FDA: 85096401054.28.963E894
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id D54E840009
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:58:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bqS+hVh+;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786629505;
	b=fX3dPY18RbohWTSbXCI45edhrcFWjnWIZJWNowA050eLJLoxwc+Q+ffxubVCLD5IqamLDe
	CsqsFa7whlpIyly6NWbWdWgeNiAL/i8wd9ZxeQDKGbZy9vVyvbWoIblhPF7medkxbTzHib
	rKkwHKBZyUXb3Rk5P8MaQOutdVc83Xs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bqS+hVh+;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786629505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qzrHbaU5pAHvUqWsTPrxNR7GVWHprbyOEnCbtAT7AcU=;
	b=rOReWXaEcjkISEB3bdPiNMc3y9c7KxGo2JKxKv/ekyFVAoVU1ihZ2OERDWxGq5wH9yFlDv
	b/s51aJ4yUmsDm4Ye95IkMdJjW8de60MBPjDVwHq7UZyzcR3bt81L1rWhNzOJtZnLM2duk
	AyOMaGMDDaQOqbsFf1NlwuOpNzsGrSE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 60E7B61879;
	Thu, 13 Aug 2026 13:58:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35ED1F000E9;
	Thu, 13 Aug 2026 13:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786629505;
	bh=qzrHbaU5pAHvUqWsTPrxNR7GVWHprbyOEnCbtAT7AcU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bqS+hVh+zLMwWp5u1ZR2TMom7G8p8tYQMYln5CBx+YPB8NVeAG8/vpQxS5u3a2sZu
	 I9zOj0ZKASTYVR7o/NIEG7eT4gVD9GG//5lwE6wELMJ7lEhOpoX/ouxsuxUieyTeZM
	 M+CQSa6bQhjwlmyNYlZc+tFQj8IMypgRtozH9xq5NRZeoCeTv8BgWMZ0ei9JPeETYq
	 9J2hNlUH/5nMZbg3FRISem0dA25oNT9PLqI6p1eMMj9sbRXEp5eZWK6rgZgHjJcFGv
	 I0DfnV8+/1nrVlwhFQ3Nn6tK77ZPB+i85iBKB66WUxKHvATkVYH6j0TmZ0H218X4uU
	 LkxBcDn57Byug==
Date: Thu, 13 Aug 2026 14:58:05 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Daniel Palmer <daniel@thingy.jp>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Hajime Tazaki <thehajime@gmail.com>, linux-mm@kvack.org, geert@linux-m68k.org, 
	Arnd Bergmann <arnd@arndb.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 3/6] mm: nommu: fix an issue on map request to
 /dev/zero
Message-ID: <an3M0qmvzu2BS73y@lucifer>
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
X-Rspamd-Queue-Id: D54E840009
X-Stat-Signature: n8km6ai5pjt5m4tz65kt53mfwaxhmx9c
X-HE-Tag: 1786629505-149080
X-HE-Meta: U2FsdGVkX19TGqSI0WyyHjAZPj2KZHUVPnsPCG9mI3saZdFF+88JmGg9qaxDcubNC1berNtr2BY5yK4FkAMDmkspX6+s6dPJXIVdkTXJHxbiFzA7ykWCM6ZWp0ZHyf4QarilivQ43+/FZJa5/rzYy4agddN3RU0UzzyaCHuUVGPg6v1xwVKWjJMGdNs6Otr4NA+RHBwsI3CleTzMSgH03oX8dCnJSDMkdE69N0gKqZxYxHl1ZFclTwCVTSM6AskNai42FYY60NqJF4FhEfw39HouvKeka0tVPxx1e1CgCyVhJolO3H23hr5YaJlfa1gZGh2/E9JLQc+C7eXVIf+6MEZ8OSKTpqi1+AB8j3ECvtF1RXVq1KWpAi5W4o0FDSK/eHsVxDhuZGeX4R6LRUVS+h3HG58HGtcuZmHqMBcOJBv+FLnADwUJc5NCblI/kWgIQaKgxKzAjQ9B89bDThlsP0yj0c/VAPxwknvy1g8d98ouv5DqpM7bvUiPpDnfU+sW08Nx0utqbwP+pGI3GIvry9FPtd/1VToxIF8K92NxkUwndehC5YV7lPsmrw7xYC+VAdoLnvt64cnjSftluZnb1yjqOlhr3p+h15araW7EnSxJ/Tf/4zUd18m3VLR5qOhEDPJ3iX19D1TsiUHO56WEnTe6IbnmBlwN8yJj00Va3EdVZ1Es/qGnMmEjyiGO9ngsqt3peD1GxPmXvrqxF/qwTAJCZFMi0t0hdtLhUX79z2BxUwjdhgkAkhRuPHvTsZmbr1Lc57XpDgbOzwQanP79fd9FqQRrjpqnFuDaM26qWwQh0kvZCS7cWNXpEGgrxz+DWtDrO0syOVPbH907Tm1ZPqkmRNlxDspMy0y8n4iTvrV6+cCvWqqOMQ8b3lQqY37xNvgd38U8e9D04Q2n2gtT5x9Y3zCae/RGBlPmqvbWXN6I6mu6X20zEIbgtm2P1D43O8+7n28Xex2JaxAn0UG
 OVpBMr+S
 lr/yizEyTbODcoxBDhcOom8fOhyHyTtYfcWm1La9ly1cW6ptCm9FLQ+EHIlD7DCKcFXHZtjY1SkjWoo7Xl+QBaElXmFMlNlytqkm6M3MqOkH/EeTopc57JkvSP0UCRFyQfMAyms7Gj/lqpQ/NWBXR8hITNBm5hjcqTmDVBl6hKm5CV2sMZFeMKAlDfqDyPdG1xgHCewIv722D1J2Y2aLFbKx9kCkBQ3Ne++uoB3y5VJGGZ8R0PszIJKruGQdOMMucbJYbJanuQfN5gu4/Rke3860Ayw==
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

OK this is what I like to hear :) please report it on-list.

If you do:

$ scripts/get_maintainer.pl mm/nommu.c

And send reports to all people/lists listed it'd be appreciated!

The grumpiness is not the usual mm reception, and certainly not that to bug
reports/patches.

>
> > Well if it's important, test it. Test the tip kernel. Report bugs. Contribute
> > code. Any or all of it :)
>
> I rebase my 68000 tree on mainline regularly and make sure it still
> works. That's how I noticed and reported the above bug.
> I have a bunch of stuff that claude fable found, validated with QEMU
> and then I checked on real hardware but I'm not sure how to send that
> without it getting instantly marked as slop. :(

If you check on real hardware and confirm the bug that's not slop that's a
legitimate bug!

I'd ask that you do a human pass over anything produced and rewrite any of the
insane paragraphs it comes up with and then check to make sure it's all valid
first.

And if you can come up with a patch (please human-written though using AI to
help is absolutely fine - I do the same) all the more better.

>
> Cheers,
>
> Daniel

--
Cheers, Lorenzo

