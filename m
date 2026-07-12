Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86711C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 08:01:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76C476B008A; Sun, 12 Jul 2026 04:01:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71C786B008C; Sun, 12 Jul 2026 04:01:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60FC16B0092; Sun, 12 Jul 2026 04:01:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 380D26B008A
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 04:01:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ABD901208C8
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 08:01:44 +0000 (UTC)
X-FDA: 84979380528.03.2DF3091
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 13A8412000C
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 08:01:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="SnCux/Zc";
	spf=pass (imf29.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783843303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JDe2roBwGlbGNLfIylYtCXE90pGvdrMhNrHyux+rp2c=;
	b=BwhB8vVBifTBxExIfv0Aa85HB5k38FOYmn7R59JcnX/PS3S5uK5+/yw5G5Sxhjq7UElcl8
	KRXFbfWzLmcq5xwEc5aVwoMxH0oU6tdYLgvUv3xrlWBTBAyynOuj9jmLJ8l/qZX34jLKmB
	dUBcbIh8EmB9S43l0klW1sjYVf37phA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783843303;
	b=W1XRBiKiwqhGKL3YtjAUyeqdCJQ3sV7ApWZjsLNQJpc/CaCvwkD3c6peT4NB04052+Yekh
	sxkPRptJdWlnCnPWHBpdeY8HkV4udHNqcxUm/S/pitWVbhuLOH3YkGNgNjtO4v1zE0NrNj
	JyaSmaL0/tkf235/P2YC065I0Y29vmk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="SnCux/Zc";
	spf=pass (imf29.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 63ABA6004E;
	Sun, 12 Jul 2026 08:01:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706E51F000E9;
	Sun, 12 Jul 2026 08:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783843302;
	bh=JDe2roBwGlbGNLfIylYtCXE90pGvdrMhNrHyux+rp2c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SnCux/Zc5Sz6wi+JbQXUqQ08OdE2kieVNBoY0ZP2rJjIyDGi+Mwh+J925gW6WEXAD
	 ObL+XgBuml2lhR9Pro5gioOUQsXo8yR9KccFsZiRYaA6Sc4obLsxN350uxi89mjIYd
	 zrGI85qqVm6Sxw+V38cHDlaKVAvXBULd2Teh72jk=
Date: Sun, 12 Jul 2026 10:01:37 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Toshi Kani <toshi.kani@hpe.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, David Carlier <devnexen@gmail.com>,
	Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	stable@vger.kernel.org,
	syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/2] mm/vmalloc: acquire init_mm read lock on huge vmap
 promotion
Message-ID: <2026071252-sweep-quirk-a068@gregkh>
References: <20260710-series-vmap-race-fix-v1-0-5b3794c113fe@kernel.org>
 <20260710-series-vmap-race-fix-v1-1-5b3794c113fe@kernel.org>
 <d47ac961-4767-4ce4-9c75-f281beb24e42@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d47ac961-4767-4ce4-9c75-f281beb24e42@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 13A8412000C
X-Stat-Signature: yhguqr3ecqyosd4ty4kruhpx7uq6zhgi
X-HE-Tag: 1783843302-738308
X-HE-Meta: U2FsdGVkX19Q4Oz7fN90SmCN9EinwJq2T41WA19nkVcCS2MeCRSfIeYMGamShEKqsJpzmxU4jK9ihE0M3b5i13h0ONXGgOhIOmZf/sA/CBSOe/YfsHQbKIdYGQRql9h07Ko1kcc3guQXhIN0beTW9zKpVCX7HQpHTZBivG2q4PS6rw94SgrIetYBBwKDW6MhD487hLfLAVSIWto+F/7TPvuDapK86yv5lPvlsxFTnrd9G1brqZEwb/MD3pvdfPrqSPAiMxLRbyMN3jVTgVDZ3hicao331VgzbJ/nPP2ovzq7SOl+cCWRx7Okb41B2dAYhhyWnl9vY47Q4RlVXg4vLTF1f6DcfFey4FB6xXXu+jYFDushfTorfu8ssGjqLHBHwSMT32sQbp3wcE6ziTZTgRWDbS/TK9/0l6BY1gH0YEEurriyAyrCav2U79gHEqkw7Z8KIqLPCiHqJvdn6CRU5dOyfMch74uMuDKU2SoCerqoTVPX/GNnALTM2PJjogoOsya3CZXpmwt+WkbjeTW77mI8ymYN+LbInWaEpuic7sn/c+PWyfqycju+XD9DQTTjdHftBPD8pQkBRc4sHyMDf7TjuNnUxsgZqpTz7Of3/Y0J5UzzSr51IgKpsSeZdhOFTSlns9FDFhnbNIxNU/63cJ9x+pXyc+0iRDMZSsimmjrw1d7auTOs4YpM0/kQhuiOyRUM8M2W2wvhHrSYRJqQQLDCMX2F/yVKlhG/K63L2ZApayjnbC6uiMkGaNe+T3TW7Vhvfmko+dujSgxpE2SfkCFvoL1rROzM8n12gTP8cbIv6FauBJPhlUUNAwmqCNTpNGnJrKtl/y2fbLiJBZQqSLe5qwwFG2/+GzroPA2eaNIPhgSw3XM6/Fk4l1nsBSG/jjRXOo2RyHBxGr5r8zaiBk5PopIV4c/417mT6FjRUZUwaxdLPqv1qHF3lTg+tvGR4eVEJQcFWAR3MWuaHju
 cz+GfZZl
 vROgcvDas38PBK2pz6cfFyjpgr49CXVRczWIl2UhnPe8UgsceAZXm9Rg46lh9cY+k69s2odA+2ZDVB0VBcjvlx/PQSy0PDqcmgGSU4b1FYQINi2Fd0Ghe6mgqrRoPCuQ1mOHkT9SEecI5uCUqbrT/979550qtcOvdN/YgWAvAdcCLvDqwxYMr0cdhuo6bzxSkieY6Eugdhzx/JrrXtYxn29R+a1g0qMnblyTlz7Xx7rZ6cR98SIEClC5lEP/hxgAjgzTzNp/5M4cy0eqwEob3xU8YD7gm18csFu32F4tlPYGyTqUq79nRZlMLTel+2QqKvAs6I5p7S2YDM1Tc8x3DjeCGZuzXCJEe2WE/PeFpe3AwqmQYZmIsYpP3JSMvU7EPg94efP/7ElgZ5IIPl1CfNqPXEn3a+czmfaHGNoZIcWNfYafkdioeH8Arm/gIBb9MvBYxxOsn8ov4/UL33KSCVhSmxesypXhMPrDd7AkGrdCP050wNGj0H3PBAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 12, 2026 at 01:13:12PM +0530, Dev Jain wrote:
> 
> 
> [-----]
> 
> > We also define a guard class for mmap_read_trylock() so we can use
> > cleanup.h to make the scope handling cleaner in the implementation.
> > 
> 
> Will this cause backport problems, I think this scoped guard thingy is
> not that old?

Don't worry about stable issues until after the fact.  Fix things
properly in Linus's tree first.

And scoped guard has been backported to many of the LTS branches
already.

thanks,

greg k-h

