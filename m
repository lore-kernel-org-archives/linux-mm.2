Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B3DFCD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 11:11:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECE096B0088; Fri, 19 Jun 2026 07:11:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA5A56B008A; Fri, 19 Jun 2026 07:11:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE3D56B008C; Fri, 19 Jun 2026 07:11:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B38196B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 07:11:40 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3AB421A03E2
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 11:11:40 +0000 (UTC)
X-FDA: 84896396760.21.1302981
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 915F140004
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 11:11:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i02R1fLG;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781867498;
	b=mtKJgYpahaw5XZYUjdNRsSWvFRVL+W9iyujykpK9nx+ADbhQQvlTyfZNid1vPeSosbBRXV
	NT+rzeFMNOvhGeWE9r6GKSjZHw2nBlzJmWySBWntVswa1CkJBlp0ppJ0wq/RhPRIEPE5wS
	xf11An1pgj7HUiYY2y5WkZasm/EtOcU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i02R1fLG;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781867498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iJOKcZvygsqgxm7muAKd+76uHoZFFY5TClZKa0FpZrc=;
	b=jK2i3l7BjOMjS5aYWratBoroS26OaaYsiv2ZmMLsDoG01UlwKBeJ4X+cNqt0hSw9zZdBhu
	1DoYb4wvMk0ZZX5WNILyDxONprkP0fNvdJNzfI3hsUeHszV1zb9NtqLUhmpa6nOocDHYl7
	wl8Gb3qudDrTp+t6f9646q94apkbxkI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 10DC6601E1;
	Fri, 19 Jun 2026 11:11:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08641F000E9;
	Fri, 19 Jun 2026 11:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781867497;
	bh=iJOKcZvygsqgxm7muAKd+76uHoZFFY5TClZKa0FpZrc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i02R1fLGWodVSipWVNcr/NHtzTLSPn4Vwoo5KZnlFsrozVruc5I1skirY/Hh6Yc9L
	 8R+b7OuoNsli3otBv8hqVAmkK/Df76UWA2/NwJ9UnxH77HoXlL2rx8gGZhzHsF38mZ
	 MirD6gCLvbH0teVyfEPwjZvLGN1q9I7kMqQC6MebmoI21QQSVKyAlHvx8JJ12KW0W0
	 Tx+Uo3E+Q/kLwCjBHoqk2IJ7f9vdtFfVFGcKRUNXhHJ7QcRnGz3gbukp8xjcoVKEte
	 MJegk+tCRGtXs1nfC9l0Mx3DQAcJnT14ZrOoVUzxT0FVbx11etk/prYlwB+dtlrhbU
	 47iIEXXmJfNJA==
Date: Fri, 19 Jun 2026 12:11:31 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>, Jan Kara <jack@suse.cz>, 
	kernel test robot <oliver.sang@intel.com>, Frederick Mayle <fmayle@google.com>, oe-lkp@lists.linux.dev, 
	lkp@intel.com, Andrew Morton <akpm@linux-foundation.org>, 
	Kalesh Singh <kaleshsingh@google.com>, David Hildenbrand <david@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [linux-next:master] [mm] 7b32f64bc5:
 pts.svt-av1.Preset13.Bosphorus4K.frames_per_second 45.8% regression
Message-ID: <ajUj2adtJakEG0ZO@lucifer>
References: <202606181547.617a6967-lkp@intel.com>
 <6z2rqmo7b6m2rdhqurspwya25ps4dj7lctdygnmq3rn4xt6h3i@57kiiy72epgd>
 <ajP_-zqVPtbzvc9j@lucifer>
 <CAJuCfpFed0GuMk+dE-Xn0w45Mn1Spds-pc2BE__FUoWm6+R7_w@mail.gmail.com>
 <ajQbXthzbr9xgUIM@pedro-suse>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ajQbXthzbr9xgUIM@pedro-suse>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 915F140004
X-Stat-Signature: bx9u48ffdkwoqm97nffoa1ssm7buy4tk
X-HE-Tag: 1781867498-108932
X-HE-Meta: U2FsdGVkX18LJOUoYJkjogsfOSMzMa7zxAYIFfZPXiY8XM+MRhQvlVvM68W+Jm1/yXZaUqAPHUf7sa7Vcg0WVvstEFwnB0L8Y/KG44t18y2uX37/MOsualRUKSPmvU3kIzgwtl1RSLeGy7tEzRY3AVLVc1rFYz4gNJ/L+ikSt2x4SM1Cw+f50DDc/DhiKUy1BknNeXHdQbTzxKnC/zhoMMEHbpR7ZhCurWSP4eQWuoLkBwT+xysH3JFyUiNG4k6rA8PqiRUsQdiHD2NmF4leBNxUfmecxvmqsVOtPcybUWobFAD8Kv5AYw8SFA0fjCQYzd+jzwZSYCwlAqESh0GwyUsyKeu4sCAyGEYcYSE5+x5nAgirhT0X3HEYGSLhbyXvfT6jI6iMmigAffdLmjaKm44ufZhouTBDmH3JKujFFVUWaCdOh078M7Y7zWYKTB2AziDWBZ2K4qMBlzxzzzKkhLkR54Q6AmawEoXbB1TwhEJGQzowsXlQW9z4aABR20sQh8SWd7EJ4cKjY50SjtbCmGNrwSPft9I4QR/X1mbTqiFKYILe6M/ke2Wct5Hp/7Nr/3dUYIYS6Cm+5uaUl8yFbc4WIxBQqd9i5wEX7al4YvaYizsBgnsF79/0WClrImBC0kIBiiauePThlPydh+kzempM7VdZ2QTvouG4VnpTHX+3D73n4IS/bFMFakPCHZwQaM9ioybP2jnngxsN2c+vxICzoXdghCkUyO8IJYat+dKllptkl8L2IstRyCffOcnle59rmd8lnLLAiY1UKJuKZqJ5/+d4tB+mAnXzJ5G4tsIxOK/BQvshF4t381vVzYfH+53HSZe5PVQogwSEQVEYgD0I1Vo/naL4IiOoi7rvNU6mM/BRf9ftI77DU+m/uGEJ5hHTc7UHRLIoFqvcbIle/pdRadvXQlhwmtyqEJ4w6dtxHV+YXOmRWqtPI5WMFxII8TVV55fGHk3YfTTeCWs
 0FwSymXK
 HtQRwbb8GdvfYifBd/KiNemcgPyHJTVcaQ7C2F7oZRL82Pi29vVEDsxXnF27zY8QRUmrmPZbOJyAXzhblRa0AdYAkJMIG9uZFSF3hxEFnv2qRfVZoOXxGJvQNkoq/ebEsRJluf+cbRcWB02Ef60UOqVdSQGBbp5eObLmCTciFNMyEIjpEoh1GzQdeEbEpGj7m32Ht4piy1mSol4qomz/438qPKU+enraFGNL+gIrn5I6Edr2CpDQZUriJoVdg6N1F5zxXgR3DKwxVYwetazeLwSoApb7Wk73fpaxG/YXv1INn6yrZ5fiZu8v5RHmfQcXH1T6eJUBXGJFEaNDc68L3ZYC/cchsVIHE/nTr+l9CDBgErtRd453Llf+HkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 05:32:31PM +0100, Pedro Falcato wrote:
> On Thu, Jun 18, 2026 at 04:03:43PM +0000, Suren Baghdasaryan wrote:
> > On Thu, Jun 18, 2026 at 2:30 PM Lorenzo Stoakes <ljs@kernel.org> wrote:
> > >
> > > On Thu, Jun 18, 2026 at 11:30:47AM +0200, Jan Kara wrote:
> > > > On Thu 18-06-26 16:00:42, kernel test robot wrote:
> > > > > Hello,
> > > > >
> > > > > kernel test robot noticed a 45.8% regression of pts.svt-av1.Preset13.Bosphorus4K.frames_per_second on:
> > > >
> > > > This one looks serious enough and real. It would be good to figure out what
> > > > happens in this benchmark that it benefits from the readahead across VMA
> > > > boundaries so much...
> > >
> > > I think a revert first no? This seems pretty huge for something that isn't key
> > > to the kernel, then a new attempt can be tried with this issue addressed
> > > perhaps?
> >
> > A quick search yields: "The
> > pts.svt-av1.Preset13.Bosphorus4K.frames_per_second is a benchmarking
> > metric from the Phoronix Test Suite that measures how many frames per
> > second a CPU can encode using the open-source SVT-AV1 video encoder."
> >
> > If this is a video encoding benchmark I would expect it to explicitly
> > prefetch the data from the disk before measuring the encoding speed.
> > If limiting readahead caused this regression, I suspect the benchmark
> > doesn't explicitly prefetch the data...
>
> Well, commonly video data doesn't actually fit in memory :)
>
> A quick look at the code (I think it's https://gitlab.com/AOMediaCodec/SVT-AV1/-/blob/master/Source/App/app_process_cmd.c#L821)
> suggests it is progressively mapping the file data for a given frame
> (or frames?). So the old behavior would result in page faults for a given
> frame starting readahead for the next few frames. This looks reasonable.
>
> FWIW I suspected this was a really weird case regarding mprotect or
> something, and I'm happy it isn't; but at least I had a suggestion for that -
> for this, maybe dropping the change (for now?) is the best course of action.

Am sending a revert.

>
> --
> Pedro

Thanks, Lorenzo

