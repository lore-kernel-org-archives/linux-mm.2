Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 695F0CD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 11:28:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F0BB6B00B3; Tue,  2 Jun 2026 07:28:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A17B6B00B7; Tue,  2 Jun 2026 07:28:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DE5B6B00B9; Tue,  2 Jun 2026 07:28:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C7AD6B00B3
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:28:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 14C201408E2
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:28:20 +0000 (UTC)
X-FDA: 84834749160.19.C861E58
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8679240002
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:28:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oqNsQmyI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780399698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PFBa7I002E7Bsn/QoIoCaI6J5pVRf1daPAJ7sgM4cYg=;
	b=Ao7Iz2yT9YqXtypl4mI+xgVCO1aoC4QUg+UIPyMKPc2dpZ6Gi0JT6vfS2mYTTW0IKEiv/N
	k4Z9mIqdif25hia5hJeY4jjCor6BapI0HfXiTAFikb3z9iIN0HfgyjZaKRMkt0Yx5yd4dD
	3EgC/AmudQdfuyrrR9/ahsJWOrOyUG0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oqNsQmyI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780399698;
	b=k3/0LYUM9NqtujCdnSweNIxFnqs9uqkskC/bVQMkyl3RyO6SIQDXg/a+iCWEVTHQcyVb+2
	e0R1/qmYDX32VXPNSde74ec3gaM15wSgI8F28IB6Zs/Zpuzx7Nngmuhrv3GXjWrnS7QRbX
	ojgJM/1wAM8AsyWc8aacoy09n0qXmuQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F101960123;
	Tue,  2 Jun 2026 11:28:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96631F00893;
	Tue,  2 Jun 2026 11:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780399697;
	bh=PFBa7I002E7Bsn/QoIoCaI6J5pVRf1daPAJ7sgM4cYg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oqNsQmyI73NfO9W8dbNQ2uK2uFKw8EpA8DdRJqXJ8++Cves56kPyohjLfWVdk52q5
	 7VTubZplBq6Irw0vrt/lZTDDW2htCYfYMh1S1s2wcgBaMKiQVtwUFcI5N8uffNcGy6
	 FgvasCsMBTrfBTT/eum2q+4qPCrAsCKiqCDCGJh1gmP4Mrdz/mW16wFF5m4vi3XeOh
	 smWA9hVsUHBp9vr0nbgwL5wZERp5qCVntKW94rV80iF3vTZQGfthCS9yRReQ5W0yxC
	 G6RWmSW4tXYi5Dy9feBL09u+897AEjnOZTnf6Qe3BtClzv+vL7GYSd3vkBrX7sZz9Q
	 Lw1RWwGiZr2ow==
Date: Tue, 2 Jun 2026 12:28:12 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 3/3] mm/vma: eliminate mmap_action->error_hook,
 introduce error_filter
Message-ID: <ah6-Nd5d8371sPRd@lucifer>
References: <cover.1779462249.git.ljs@kernel.org>
 <e770b28427937057fa953ac380a134b24acd8bb4.1779462249.git.ljs@kernel.org>
 <88aa89e7-aa7e-4abf-babb-a2855bcb3fee@kernel.org>
 <ah2oasz6oz4TgEiD@lucifer>
 <192ad271-13f0-4e8d-b5c2-feb65392bc6b@kernel.org>
 <ah6qt-JQaSPwGTfi@lucifer>
 <b8891a38-7bcd-4258-816d-d397499842e5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8891a38-7bcd-4258-816d-d397499842e5@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8679240002
X-Stat-Signature: zchxigays3ow8su5c4fk5fwafo88wtx1
X-Rspam-User: 
X-HE-Tag: 1780399698-181469
X-HE-Meta: U2FsdGVkX1+uCwWtwthmUs1mvigcRW5yaL+K7w/mJhP5mRi71l35/nGSjRtxpkZ7LS6PYmk1uwprXbCqHuIAqvS/W1Rpqt7qt0rmppTxcreQa8EL1oNwv7M6OFZdHRDOx54pPMgeb6sf7wJuH4wXbGNDHWBvp7yOHIFJYHtovnme45gctdT54084DxfGSC6U1udd9U3UtuRf1WgIG5Bk89A/lNtttB2aoz/tnRRx36RiTB2JJvtqAIZON7O3mnDflSTds7PzjUAT9Le8wKtF3X8T80v17qBwPvIJWQ820zftTrx/8WgG31ibiJYu1duW5JijCD9hPPP1+MRgd9zlV2+vryFSDdaBC6pXdm0a25Nvvyq1wiyUDmIOSUq3iAsX3CLm5al+DXYj1xH1iG8lUuBR+3DWX3W/gd4OKpVy+q91wKLmXuLTRDRYVrJIrvUZ8XBzW45nfT18uzuwP/Yiqc8GDkohov0EaYEHWJuKT6aOkweYOC50zv9cp8rYeYqnSTVrfYoKJFwIZpwnVxkO+EuUen07vc9eHWvd1aNVfIAvncc28ovktwPygAyvEASIkbkJreZWcc5kDJvIdnMh56wCVjl2lSPWS5kSD5jIpHGF0AZMzzVKK86mGor7w7i6os2SOI5KJpUT2yxY4J6akLRhSlOvArFFwD95LWzTmeK3OgzefcZhFILsccMAuty30uBFRJ8TO2QabWrqpCJmtZH2crj2SWf670LNAYbcOY7hGBra82iAbVpGO98/HPPR2JDkAq7Kld/EPIqqEesxyHDLxpdUAp5jzkGz4Okq+iuoj++nRbTA8x6CNjaxeXB/yucO+GSVA/2FtNzJMuaOye697jjgQ0OQJcfYPxDGJtzcshWrCi1VfPJW2CkD0K323DSQ8ITZ2r1pksRpLGI2Kmb5muKSTLn3CZBTPfC2mdceRfzC4cRnHCZNv9jUWqtuLXuabDEN4Ln1GHs+0cm
 5ee5ey3p
 CuX4BA+CXYbK0FAm88q2CBl68g89Lt9fbjw9AQUmHvg3YsNVNWL58FncxnaSc8xsFvh+uzf7Qxj3vJ1lffO9g+DdRWFPzfCHRD6B8cdy30GBHuqUbkiQr8jYGdUoajwfhkILJLi6MwWBFqI5qMqGldCq2AcXftqoMqHnj+t4lkcrnTw0gqf79Xq9Ej0fNAiAgVF4xRsEax5FuPcagZH4VkZoEEBO73og8AJSNgIkX9ct8smjUb/sUI3oKQD2Kpx63N/7I8d7Lxn5y87pOHxMmBpyvZX9bLNQgBv3djGrFGjN+oBY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 01:23:11PM +0200, David Hildenbrand (Arm) wrote:
> On 6/2/26 12:07, Lorenzo Stoakes wrote:
> > On Tue, Jun 02, 2026 at 11:16:03AM +0200, David Hildenbrand (Arm) wrote:
> >>
> >>>
> >>> I thik it's what people tend to call this, it's what I've seen it called anyway!
> >>
> >> You mean for this monstrosity or for a mechanism that translates one value to
> >> another one?
> >
> > In general, but a quick search on lore suggests this might not be as common as I
> > thought.
> >
> >>
> >>> I mean your German brain is being logical :) but by convention going with this
> >>> terminology.
> >>
> >> Sorry, but which convention?
> >
> > Of calling this error 'filtering'.
> >
> > I'll send a quick respin and rename this to error_override then!
>
> Thanks! I was primarily trying to understand what my German brain messes up :)

I think honestly on reflection you're right and it's unclear :P so better to use
a more obvious term for this like override! :)

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

