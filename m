Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92705C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 06:16:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 153176B0104; Fri,  3 Jul 2026 02:16:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DD776B0106; Fri,  3 Jul 2026 02:16:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F34666B0107; Fri,  3 Jul 2026 02:16:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C6CD96B0104
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 02:16:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 597E31C33BB
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 06:16:48 +0000 (UTC)
X-FDA: 84946456896.07.7707E9F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id BE68F40002
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 06:16:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eikfK/WR";
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783059406;
	b=4zOy2kDTHRSxunN5LY983Ck20pL3Jd7oVDWxTE1ht8NN93uL7Pi1xjP7WvDyFo6Z0Mtgl3
	VPPlZABlvA6OQb40j3GsHgkAf/LoSmsdIdE1v/wQ0aafG567uWLdTXoyUYS9IIjlv0TCZ9
	CcV1aI81OciBTKyJw3ufOdeFgJ/S2mg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783059406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i1VdzkvxjcNef3On+ZEjzz2EDquI+okMGLXMK9XiBFI=;
	b=SCrwoQM2AN8wzoSB+UJu0iSGRhOHwJ2wvEZuB7xK7w00tHayAMELAr2Aw5sorNcFGkNM8p
	ByHM8cJR2SKkEUVTjaOSC+/VeViA15JU5ukPo2+E1EjGD7wM6DkMaPKXHFKlzBXvNLQ9Ln
	2O2nUxHVg5VSnQix/PK6AfPtjcMVoDU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eikfK/WR";
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A504D404C4;
	Fri,  3 Jul 2026 06:16:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49BE1F000E9;
	Fri,  3 Jul 2026 06:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783059405;
	bh=i1VdzkvxjcNef3On+ZEjzz2EDquI+okMGLXMK9XiBFI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eikfK/WRMW1shSu7Vfe5dev3QsRjEOBjj0z1KEjlVI2LphWAt7BZWWJ/AcUy0/Htz
	 vb+BU8hD2fihc/CDag80L3VoXn2ci/MB+k9ec96BWtTsOy2EOM6zbpCP7x1wlAO2WQ
	 CmPDUXNI+vO8nnRYBX7Lp3jVO2elXZ1isI4uIc0yXSaRT/QojByRyO06itkZawo0mm
	 pdGEj5T3d55tZQAbssqygdzyzCg3uDhIKP3BAJXlMhXCe3m3rl/dbGkl1L0kkAeFwO
	 qSzQ+G0TzzKLoA1MWaljllceMdQ9uKMz4JGn4U3Cz4WERn4qhRcCDdd9lL2mWLB4FX
	 2dbGLzK/YIivA==
Date: Fri, 3 Jul 2026 09:16:38 +0300
From: Mike Rapoport <rppt@kernel.org>
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>, Rich Felker <dalias@libc.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 00/10] sh: remove NUMA and SPARSEMEM support
Message-ID: <akdTxsulVwWP0jgF@kernel.org>
References: <20260702-sh-numa-v2-v3-0-57e2435603de@kernel.org>
 <fe0e2ca854db64b1bb169ce47aaa2ce1e796b023.camel@physik.fu-berlin.de>
 <akY7VSgIhorP54vh@kernel.org>
 <eab1aaff6f37089d46401059ad7ff056aa5195c1.camel@physik.fu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eab1aaff6f37089d46401059ad7ff056aa5195c1.camel@physik.fu-berlin.de>
X-Rspamd-Queue-Id: BE68F40002
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: xhemtpjur51z9eafhncffa6jb4pk1wr3
X-HE-Tag: 1783059406-325820
X-HE-Meta: U2FsdGVkX1/u0z5pNgMgbvpnpvWV0WyLIi0eNWzvpG4TApmT2z3iGeJVvvy7kwEJakOMAd/jQX1eGvF4fwhHlcaXVc834oUkXwSinzRjXDlLvzZGTsBb9hcf5CvFa9YetWRMAPVfi9cqz0x5GxuF67qrp26SF8WAjAeZjgNBpRWwPZmsjvCWT4wTjVhwPcc3e8cY5PfX1b8P3dckPpp5M53Dusoa8wS6V+S5eS8VeEYcmoCn29wmV6V1ocgT5HxoZQayx6I7kjoA3vMoFOhw9K1y1K1gFvIqoBYy7tkFn7hvlOAtfPcPfi7GhUaftPg+7Ho8vqaANUGJazgHlBgFdzABBivuzdBd5/EoZuiYdovNicFPgXLapVshmFJFrF226OCsLDp9v5PfsPeHrZfG6bDp9KHAAULASHr8zLD0ga9YxvZRBs1DisfDYYS5Md2cofbkYwkOnUZ8CfyngaDc/7vpS+Yw0LzmW7Vu7i1F2iU2FC2TvmewANusEJUj4ezhxkKikkic7Bu33UQOyImevb8UhJ3+fsS8i5ub5IgZUMbbbEPLBfHHOa9G7Smskf9/+2lYP8HSt7OuDIWCcpJo5uGlEUmoUE+D1zDbvXBI0+cm9IBStEgW4SduD5fkj71GZTrkBW+BfawTSkMUInPbaVogtvpps3lSb5sxIAwhHmbPDQSrBo3U2p+fzxTUD0eMQ7aXGA9JLC8vXH6qZ17Dz/jkA/Iq2yX33a0cVrrRU0gvT8Yfh1y2UARZCikPUwo19Opgq/w2ZeIGj/Qq2jUKEBqOTieHng5tdkESfRuX1dsDm2SL4ViS+WBFB8vONpf7PhwtqdQP+nmnXG0BSWbSCkVxQfkWdtjtHoEOAVY0vRe7Jne6uyEzBhevImf4fY2LgU4FiGxrZPDNQMjV2Wwvh0eHaIv8J605SaLUn3Xq47CafkoNkgVbB+rQjTuZPX9DLUA+vqVbarYzIuO+t1z
 c9nSLVgx
 LgNSCbqm+OrmFH/AFQ9wZrCmPwregudIvhCo/bPSLCJcr2Znk2UCnDeo98LZ/eesbuhPa54M8iHIBmGe4rPMjlyQynSUgOLoxDL3bboUMXpWPwAvolxThqfQCN645qcdUPWIrYIAgzEyBv2uYgU20V42cFaRlir9qTurPPv7I+Bjcgbh0jBbjx7lxYKARMXmh0LRRg+X+eXkuKJXUDzVN7QjDYlYhI4JOHHGogew2FPP9iZlMIhcx3bc8eadiICilS3C7zGeuT3HVsM7Nmp7VjTBBQlUDMxCRwXRsT62w+IlpomXyaKPuCkdEcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Adrian,

On Thu, Jul 02, 2026 at 12:25:47PM +0200, John Paul Adrian Glaubitz wrote:
> Hello Mike,
> 
> On Thu, 2026-07-02 at 13:20 +0300, Mike Rapoport wrote:
> > > I feel like this is an attempt to force me to give up as a maintainer.
> > 
> > This isn't an attempt to force you to give up, this is an attempt to merge
> > patches that have been out there for long time.
> 
> You posted these patches the first time in April. This isn't a long time.

It is by mm standards.
 
> > This isn't about sh, this is about reducing NUMA and SPARSEMEM_STATIC
> > footprint to ease the maintenance.
> 
> Yes, and I will eventually pick up those patches to rectify this.

Why do you insist that these patches must go via sh-linux tree?

If you don't have time right now because of other commitments, Andrew is
here to help in exactly these cases: let patches move upstream when a
subsystem maintainer is too overloaded.
 
> Adrian

-- 
Sincerely yours,
Mike.

