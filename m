Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5F08C79FAA
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 08:11:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A78876B009E; Wed,  9 Sep 2026 04:11:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A50586B009F; Wed,  9 Sep 2026 04:11:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98E7E6B00A0; Wed,  9 Sep 2026 04:11:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 787736B009E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 04:11:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ED8D2C0139
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:11:15 +0000 (UTC)
X-FDA: 85193503710.08.A5F05B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6BBA91C0003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:11:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=arj3Ow3k;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788941474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OiTso1d5a58Y1BMzX2FIHCu1q6PNmdvVbYfzdRKL608=;
	b=4iIk1Pht5PBz16ucAb8PeKGX8CiTa6ArPijyXPpSHeO0TtBh1e436bJ2+Ym6FKYL6zQ9Pg
	6xK7DP3yQep32V0TPPP5sh7evvUrwe5bHvFcWty1s7+FMmLI1VU5AEhdzWbbXi/oIN0nPh
	FSdv2cEdqC/C5ZaT+b6frDQCGtGDsaA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=arj3Ow3k;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788941474;
	b=FOXnpTnPsOBGy91sNngJzB/kcJgo2/jOR87yiMv+khUORRe5wXP03VFkwnXOw8AISnlK0e
	T0zmFDq8f9Cvqgm9VU317enoN2v1KIGJYDNcVOMWyqCVUJq9r0kuwsHMKgizaw1konqFh3
	vcE0LdQc8h35xoaipv+CCnBpjPOdis8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4D653601FF;
	Wed,  9 Sep 2026 08:11:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E5A11F00A3A;
	Wed,  9 Sep 2026 08:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788941473;
	bh=OiTso1d5a58Y1BMzX2FIHCu1q6PNmdvVbYfzdRKL608=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=arj3Ow3kAty1BqGMjvTpCkbTDvgUeGMT4KF2b5tAhLBgV6EPSUv8VJjzEj9fZKQMw
	 iKMBHZgK7Dzpr+AdlIksnK2gHT0A5TQzoKFx4kKg4pTt67IZR9vbKAHZiD2yJ8oVQa
	 i0XBkxVaZAdepPbV3N24LR/9QgXbQHK2YH+3n6dHOCbaTr1B6GHD9/JTVpgUZmXOZ/
	 3osGpDunTaX+CB9aeIQ0CfUHm/Hbis+ZsasOIKv7xowuA/LwI8R+WrImnhlrdzSoLI
	 PEVR/4sHIpcLAV2Vu/0EMlclGNO9WQyN/mR0dpPZV827ii+i9L1Ln12GuMn9n6TTgz
	 OKi6/+j1RyVSw==
Date: Wed, 9 Sep 2026 09:11:04 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zi Yan <ziy@nvidia.com>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Nimrod Oren <noren@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Hugh Dickins <hughd@google.com>, Nirmoy Das <nirmoyd@nvidia.com>, 
	Dragos Tatulea <dtatulea@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: remove min_free_kbytes adjustment for THP
Message-ID: <aqEUdmYnnQQRC8yl@gremlin>
References: <20260901190123.3511535-1-noren@nvidia.com>
 <d202dcc3-d7d7-4e98-a9a5-3137cfbfd041@kernel.org>
 <DL9XL8T6UG93.1T1NSJMI8PISK@nvidia.com>
 <aqBiVp405v2srvSa@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqBiVp405v2srvSa@cmpxchg.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6BBA91C0003
X-Stat-Signature: y5ek73bznkjumgj979rohdoyz5if5q9h
X-Rspam-User: 
X-HE-Tag: 1788941474-31469
X-HE-Meta: U2FsdGVkX187na8BMIaRbJ7EMqzWFmImTNGMEwIC4z2xEfuLYuxpFupVjuFM2vk1lmx+NUTMsB4oY5DT03S7br1sQlVBbsu40GlIgoYoFv8vhd5oxO0fecnpRRrWhoSCQWfaGMUMnJkeItzPNb11OD6NiaEkywCiDhycEhSXfL63mG8cMSpEuW3BrTVJ0AiqmGZ5h5sOt9+a8snAaU0VyGIfsl6CKV/TrDKKqH8V5Lv39SPhG7TW324Rl2sphwR/HPrOi5iUUnmxMf408Ufty92rSlWxm6cTxz9lG8jOwQXNXgpUvaEFdDmH/rij4P5CZxtZbKHhIvyKlGpnNVDz4nLeTHElbgMeyFk9lOiTwC1n9MtX8ZnskjwEwgSxJq6FxXMkCDKdkP74Qq0DUGjhKQHeQxN5LLkWYmx/TZE1zZSZhSlZjV+rHS69QfmFpjrsOH1/V94jTaos9niPYzWMUsJNDgUapJADPUexjKwlEBWuYTnOZDPt73Qb/RcnmnEltJMARUOsM3vAMUOXo2ji0iVzZnqW55I3bLqFsGljbw+KoF6kKUunqZmdr1cNTZlKJEYxhvlcZQ9SvESkBh7TSSqIf6FIBIt6tW5M2WYBfCBwzBo44er6YjEQC6p5QMeZXolVjtxjrBTjGE9BXRlUQ4Of/ZCaYZVkOZeBKevb4Qhvg1rv+nrn2PSO7h03tyfNKYTWS/rieFQDJpihKwJA9RfxI0Y86D49ulkL863EtFXA3K0SqCN843q/+1RXrWHGHlm1JhvdTPAs8qBB0vVHNzaRZr8OgyzvQpTmmJ+uVsKZeFCWRE5lqOgCizHcbkvNSdmuf0BLGUnWDq2jGKXwaUHlfVB173n/2c+4Ij82mmED5/LMHHDkxiLt29ehm6rxvnQzxQ1Yvh3WVPcl7b9UOBMGNAXjQT6r4xjgG2MO8H9IFFfJD/Y29L6gp9gTKEyJ2KI79eP3a5u3arLciSY
 7ajhFQCc
 lOU6CoVJNGpO+277GjBL/WvA5oI95Sj7VW6BNOM4SDLe/40lOHn15oB6SLQnhoJWTSj2B7JLKH3iTW+SM9YbMPfcYmv52IPjEtIMTmnea4/G/h/zl6+9XRU1mNS7Fsqf+5Ts7es14bAlSElNJ/3MipnmYRu9/8V8W6zfEX/W4NU0bbVk4soONVnuEv4S4wEDQaxbntYNcesalYIBIW1LPS/0Ej7lfvuka79E+JMlHjaM004yxmU+5WSeOcWC0dWmNwotLu7yXrMrp84iXfjvqp5b4BoR5fufrvC6Y4ew9vB3GIWA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 03:30:30PM -0400, Johannes Weiner wrote:
> On Tue, Sep 08, 2026 at 08:24:38AM -0400, Zi Yan wrote:
> > On Tue Sep 8, 2026 at 7:54 AM EDT, Vlastimil Babka (SUSE) wrote:
> > > Given neither of the patchset versions achieved universal acceptance, could
> > > we try just disabling all the automatic (re)calculations of min_free_kbytes
> > > the first moment the sysctl gets adjusted from userspace?
> >
> > Sounds good to me. Johannes, WDYT?
>
> +1 That sounds good to me as well.

Me also! :>)

--
Cheers, Lorenzo

