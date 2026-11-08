Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C77B2606A330
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 08:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MKFzGvSF
Received: by kanga.kvack.org (Postfix)
	id D581D6B05B2; Sun,  8 Nov 2026 03:14:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D31276B05B3; Sun,  8 Nov 2026 03:14:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6DD26B05B4; Sun,  8 Nov 2026 03:14:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A31046B05B2
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 03:14:59 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2D22112021F
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:14:59 +0000 (UTC)
X-FDA: 85411241118.01.7B9CA9F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 89B7840002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:14:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MKFzGvSF;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794125697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0W/6CqRYQKhRFQh0YmGByeLiEw+AYRdR3bmjVY7Mfnw=;
	b=HJzIzIA0zi9mJgkDZkLqhmKGc/tV6Q3CxTcqBDlVzGnhpZfnzA4PyX7IjM5YX9BXBgoUPV
	FAj7B8CngxbMo/CwpyCfDuZFNnRWqkSPnJro7J2uP4XYtrQAYmLcRtqxivkm0Qd6xoQC56
	FXRyVF39W5nsNxf/hZPXADR8VP45uqc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794125697;
	b=AnMV9gq0JkLyPgo/ri0rZKOGd0zz+8GLehILyJ8HAhjod5+e54R6QtDTQk00Z/skk2ZLOY
	nXMpMd/dMK5x5yScrWq8jKZwgbxeS1CrFFd5vbHR070foqR1wtFSYcEPFDuaoW2/+Vr0A3
	jtZr759u1Qjr8QRlDst14K4tOFtvtqs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MKFzGvSF;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AAC566146D;
	Sun,  8 Nov 2026 08:14:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F881F008A1;
	Sun,  8 Nov 2026 08:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794125696;
	bh=0W/6CqRYQKhRFQh0YmGByeLiEw+AYRdR3bmjVY7Mfnw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MKFzGvSFZwWIFFRA0ZXyvs16A8suXF5CnHj8Yu6DWVn1XNaXrMDEdixojJ9WmXEb7
	 B8HFMUjzOTvU6RwlNQjwdzjqPDvQCGA/4AJ0Em0zHhj4ypRhnI0mKxzYLZP1OV0ifL
	 eA9/fxW3Pxy16892wCazYquUCYCuIsm8XcchNAPA4t/tkQu4javpgOcU7RVq4A3nxo
	 k4uHK/8yLyZ3smraijDdggziz20OX07t14xfVyqW5GBbR1PgqbbVWyHXUI4Z32Xbrc
	 0iyAWtnR+xfX5UnU/tie3OAW89SLmVQEk/G3YHRAs2N39oS4qhXV1enxnkV6a1AaEm
	 jVNdWp25bMNnQ==
Date: Sun, 8 Nov 2026 10:14:46 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: George Guo <dongtai.guo@linux.dev>, pasha.tatashin@soleen.com,
	pratyush@kernel.org, ardb@kernel.org, shuah@kernel.org,
	ilias.apalodimas@linaro.org, akpm@linux-foundation.org,
	baoquan.he@linux.dev, ruirui.yang@linux.dev, guodongtai@kylinos.cn,
	kernel@xen0n.name, graf@amazon.com, liukexin@kylinos.cn,
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH v6 5/8] LoongArch: Allow memblock arrays to resize
Message-ID: <avAvdiYY7SJ_Gfwt@kernel.org>
References: <20261029172956.20791-1-dongtai.guo@linux.dev>
 <20261029172956.20791-6-dongtai.guo@linux.dev>
 <aux9Hm0QFJLUDPWv@kernel.org>
 <CAAhV-H7Dsnz03iXChzE6nYM2cs+D6fdDFiWrDxX5jM13kYL6HA@mail.gmail.com>
 <auypq8_7T-vml5_B@kernel.org>
 <CAAhV-H6aO_QNEzV-r6+FbNa=9EUQgv1vH0ET-ETXAH5x6oQGjA@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAhV-H6aO_QNEzV-r6+FbNa=9EUQgv1vH0ET-ETXAH5x6oQGjA@mail.gmail.com>
X-Stat-Signature: xy6ci5z6owh9xycqgsayore1fyqi1qje
X-Rspamd-Queue-Id: 89B7840002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794125697-31437
X-HE-Meta: U2FsdGVkX18EyKk+Pt3NXiKalLqiA7xbT33URkH9yupunXb60nzdfckEpiw8VdtcYQIpehH8QyuDALLbp9s3NrWifktW1mqVmwhUnBd8GA9GxFZt41K9nGe8hmeTmH8r5sH9JDIchRLNrmD+F2WgrKgmcHoyXJe15QhwOXiK1j/ul9JeEdi0oC4MrgxW1aIX+QVzrWd/JnH25uHd+o14Ap0mU3UFROEAfHU71oqqm7lqJpQp3NOQPCSK6UzPSYsj+sxvZdWl4ZBglDSctcchJUq4EvOHmmTLRaKaKQNMzZc1qu3CwDENBtTHvN564gjZQFCP5SkLRoWhS/LtF7MdfgPGKZAJrvl6kGP5VCRQOz1i/CleJ6O1wThB6E6fEaLyRncZ4UvYKzXMjP6S3BMAj2G5Arz209GP4v2IOWe9mrZjllkVjQt1CXu6z6gJjhXO89AFAsaJ7d06pPIsMDQKhi1iShGHjOvcIiZdeX0MokNwhr6JPVE+qKOLokBdgVEoYe9Y3sms5s1keP5lQ4KIcfNcxQJ9acfAuvhQ126Injks4Laq2TACjMwUSeBq8TITBz6j9oyfepQAzH5Tb3HVAOL8sjnIVf7kKqw75iWLpUrQiOPBoruKmsc+iGWucRRCyBHl5OzZds6/M4uu2rZITzK+pNgrpIotQkCH9awWh8muCShpFm3Bk9KiAURcoCz2mcDKQIeDbJi+3lPbe3uz4YTZNWl6M+j7nY2yupVJ0CGkkHmg9IJLlTkZWqQ8ERFSF4bmRq7gHLC4MtIprUPSCxr1UyzKmg7bvpIyI+BVZLSQDyRwc5kZylMWHbnSSIeM1NIqii9YcqgeOIJYxGfZoUmY7yry0MXQR2laGXMn8V1bNjOK96GEtvDrhQjo7efx38vudJYjAy4bOKueEj6W60KNaTmtQsdVx0trFS8WxhQem3c+aTY3PKJco7sKfrRD1bN3RZaYVTUIDY8O5DP
 uZNsTYIQ
 w6QAKX8t1crc+RiQxJXDi2eh95psUqLYi68Pfh6ROAhF141Gv0BPpcsRIUyxBfqEH90KLZte7ozezEb5Z2wijlWnxP+oVlCIaqn6vKa9Oc541Yce4jaZFvJ0JChWigDPHHwQG/AcJ6hh1S2SidryKfbEBZ+23/9LAODVp3k/2RYaD8jl2kDW3KR2ONb99PfLE7KniDrq061YaCDoyyo3L4HSuQaLDC1GioaKqofOVxkKmJJVHq84oYQgKsrAGR1k6tLJyf3b4EtoVQb0WHkWkjGVAQWBhCiGRh0I3u2kjuYVhNxM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 10:35:01PM +0800, Huacai Chen wrote:
> On Fri, Nov 6, 2026 at 12:07 AM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Thu, Nov 05, 2026 at 11:07:01PM +0800, Huacai Chen wrote:
> > > Hi, Mike,
> > >
> > > On Thu, Nov 5, 2026 at 8:57 PM Mike Rapoport <rppt@kernel.org> wrote:
> > > >
> > > > On Fri, Oct 30, 2026 at 02:29:52AM +0900, George Guo wrote:
> > > > > From: George Guo <guodongtai@kylinos.cn>
> > > > >
> > > > > LoongArch never calls memblock_allow_resize(), so the reserved region
> > > > > array cannot grow beyond INIT_MEMBLOCK_RESERVED_REGIONS entries
> > > > > (INIT_MEMBLOCK_REGIONS + NR_CPUS).
> > > >
> > > > This might be something to fix independent of KHO.
> > > >
> > > > Huacai,
> > > >
> > > > What's the reason LoongArch never enables memblock resizing and why it
> > > > defines INIT_MEMBLOCK_RESERVED_REGIONS to include NR_CPUS?
> > > At first we didn't define INIT_MEMBLOCK_RESERVED_REGIONS, then we got
> > > boot failures on a 128-cores machine, so define it, and the value is
> > > similar to arm64.
> >
> > AFAIR, arm64 had to reserve some per cpu data before they could enable
> > memblock resizing, so they had to make it static.
> LoongArch is similar, so below 64-cores machine has no problem.
> 
> >
> > > The reason LoongArch never enables memblock resizing is because the mm
> > > code is derived from MIPS, and MIPS never enables it.
> >
> > If that's the only reason, you might want to revisit that :)
> Yes, it seems we need memblock_allow_resize(), but maybe it is better
> to bring back paging_init()? Most other archs call
> memblock_allow_resize() in paging_init().

paging_init() is a historical relict that hugely misnamed everywhere :)

I think platform_init() should be fine.

As far as I can tell, by the time platform_init() calls init_numa_memory(),
all memory reservations that must happen before any memblock allocations
are done.
 
> Huacai

-- 
Sincerely yours,
Mike.

