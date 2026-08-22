Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28FAAC5DF97
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 18:55:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C90346B008C; Sat, 22 Aug 2026 14:55:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C67D46B0092; Sat, 22 Aug 2026 14:55:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA50F6B009D; Sat, 22 Aug 2026 14:55:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9338C6B008C
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 14:55:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 06355C01C4
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 18:55:51 +0000 (UTC)
X-FDA: 85129809702.30.0BA94C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7820E20002
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 18:55:49 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DnUgW/OE";
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787424949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=78SBByw6W5epz7cVxeuu6l+8VUwUHF/hNkVnqoTyScQ=;
	b=xYj91m6Hycz0HNOKA/r+Sm7SsP4sY9FOfiGHnVnusz0p+herxz8kc1FWyT+Ae6YYWkD5dc
	b11gq7xPEbCzhAblF/WF2iPAylsYr7GsCSTQOjujtoM6n/tNFc0SxSQCF2vz+H+QqBJskc
	uG7PA2XN/qTWtXcowltFtJeQpEiHomU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787424949;
	b=wpuWTn3zkfZ6s7My71c6wMx95ziDfmPJRIWUZh/PU0vRRlthvxtFNP87vkMa1w5tlRYWoM
	JUTW6GXlYAGwRhCV4X9Zr7oPqMRDUWCefFdslClwQ1jIKT5Kt0I+0M4tVT0vwDaMN+WZVR
	Z8CF0/UuQWJ33d7D1rHbeKrZSr0/QVc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DnUgW/OE";
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 76F4460008;
	Sat, 22 Aug 2026 18:55:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485601F000E9;
	Sat, 22 Aug 2026 18:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787424948;
	bh=78SBByw6W5epz7cVxeuu6l+8VUwUHF/hNkVnqoTyScQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DnUgW/OEk1K5xfMoFU0brDWSz2iUuUROqMrQbohZNa6W65TeH+nyrXq5F9vu3mmZz
	 JbIGV8v7KWb7Tl8EfnNa98qitCYoWyHVBEsTnlC5gNY8khyp82h9G98GdIooq173Gp
	 uWa8f31tYwduZ4uKGZY6z/gsP1YvqPNbHFt+NMiMnaTvRjkdvJv/f+KcJ1MHjOaeJY
	 0JGLgT3MuzUy03AEYH291WJP+YcCIaLhlz2Er+rtuHC6V10HlS0jg0LME7nXknFCLo
	 2vkHT27XAbrnBrr7ARz3E9a8LS6acqWqlL5ulsvzt8RN9lFDQyqwUBFEknCkcGyA/J
	 2PgDnnn6barQg==
Date: Sat, 22 Aug 2026 19:55:28 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>, Stanislav Fomichev <sdf@fomichev.me>, 
	James Bottomley <James.Bottomley@hansenpartnership.com>, Hagen Paul Pfeifer <hagen@jauu.net>, 
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, 
	Daehyeon Ko <4ncienth@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/secretmem: properly account locked pages
Message-ID: <aonwNh4vsmyp5o1K@lucifer>
References: <20260814-secretmem-accounting-v1-1-d2f8c677980b@kernel.org>
 <178706447572.2799959.13846195033539124794.b4-review@b4>
 <aoRx-VLojNCSBPUj@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoRx-VLojNCSBPUj@lucifer>
X-Rspam-User: 
X-Stat-Signature: 1fbhqnmcohp9whac5jm79jq68cqqdzjt
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7820E20002
X-HE-Tag: 1787424949-109325
X-HE-Meta: U2FsdGVkX1+CYQCW9IOOiNec24Kk5bK88IeKamxNvr46te6cTUQakgdsa22n8id2r1gNcSJ/INMqw5+dLF0WX8daaT6kBlCIjS//XZVPorxdYZj8LuXvJuHmCb63EtkYxlIV39uAUC2c+19+fMsE5mh3mGuQcWKLVLcOXFpzfFjcHDe8MjB5ewMbAJ0Bw2WfBeaRgRTTBt1TVnY/rRtXPvlHpmPeC4rgwTSHU+kEoG63yImUV8xsY3nImFnBB1P3ySPW6zAUxitByk5ZjfrpC63kDtySHVUuCggjOd+FtE3Bc85tuMzbN33bZZZqvmVhCkQjORU8oziaRe5G2Tvs//1D5fBXXJUsGZA7sCFr2qqoRKgbby1k2uYVrejPHDV9FrgiEKTTKbCRcq1Rvt1HqxC5vA5OhvmUlJtUQ4Elao1c5rjLuNHYSbiowh5baBiS1c70MENNuXbh0uwa4RZouXO2rVoE/AlUesON4IsbB2hfDrZJCfi5qKGKPKrddAvtJl/vMCuIu45BrdKhvigZ9FOpslnTYuqGTWog+g4T9KKo95lr60o+9/ga8EoOsQ0sljYSoBYoquseXoxLKqb1V8/k+eSJAr0nRmA39L9Yq8GEgYtVNZ+nGZxeIeKqF75k33MpB+3AYo6CiX73ySBsm+Z/bY38A3Q32ouzGJe6Z8isXd2UtFkiS9s4Nn8mfuVmqYGndQqt/5ygEAYuaxWnGuFZqAFgQmaIJRJ/vo0yPMj+B0ch/FqnUzblWabG3YSm6ofwoi5esqUxOpxASh9l0Eg09OEq5dz+EX5+bhAoJLiKeLWOeTewapw72bfKSsQZaQ/ywFM2jEZEPNyYb5qWInnlRJ2c0QhC5HeE5mF3kTvf5VMh1ONqEqfreWYj1lgBDGlw4c2RucAJzzVue5181ZYAkqPyZDylEzMZ4PplM10RwQzyw4cVpnBFlk4oO5e1CWY3d0fFggi9YhO61SR
 NomUIS95
 5gC7QJhKPKomoviM4pPlQ20k7v0pSTxsC0cizOdsd7yDlKJ5On7g2NhcQ/y5oOcAHPXjgjoMKf1ZugR4asWKIGp6JuBibkEp5f51H1J/wV3D2xaf1+D2dBvqhdCqOa3k3hqTjkCOxlMninr9KEaiAVwMAyJdmQCM8+lnPHdystIS+zReE/VlXEg7ti5S2HLXrKA11hoGrZ2cX/g+qVdDPh93iFl00nzjmKlNPIxczTLr78biSYBS0NuL7KZa7XXm5yABrbhQ94AVgL/wIUIC1U516oa+T+xw5YJId3oF2lBD+J4OJUDCJ5UztL9vC1hMq/bLS/EXyweKCt+BFIQQsFcMnywM05qfPdRme
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 04:27:48PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Tue, Aug 18, 2026 at 05:47:55PM +0300, Mike Rapoport wrote:
> > > diff --git a/tools/testing/selftests/mm/memfd_secret.c b/tools/testing/selftests/mm/memfd_secret.c
> > > index aac4f795c327..626e7033b72f 100644
> > > --- a/tools/testing/selftests/mm/memfd_secret.c
> > > +++ b/tools/testing/selftests/mm/memfd_secret.c
...
> > > +static void test_mlock_limit(void)
> > >  {
> > >  	size_t len;
> > >  	char *mem;
> > > +	int fd;
> > > +
> > > +	/* Locked pages have an inode lifetime, so need a new fd. */
> > > +	fd = memfd_secret(0);
> > > +	if (fd < 0) {
> > > +		fail("memfd_secret failed: %s\n", strerror(errno));
> > > +		return;
> > > +	}
> > > +
> > > +	if (ftruncate(fd, mlock_limit_max * 2)) {
> > > +		fail("ftruncate failed: %s\n", strerror(errno));
> > > +		goto out_close;
> > > +	}
> >
> > Can't we ftruncate to this size in main and be done?
>
> I think we should be able to, will change unless it's somehow a problem.

OK no, I have to do it here as there needs to be a new fd since keeping the same
fd would mean all future tests would have secretmem that exceeded the rlimit
quota (since it's per inode now), so have to set up new fd, configure it, tear
it down just for this test :)

--
Cheers, Lorenzo

