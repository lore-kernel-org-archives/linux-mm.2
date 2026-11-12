Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C256606A8A2
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iKZ/K1iq
Received: by kanga.kvack.org (Postfix)
	id 28C5A6B05B6; Thu, 12 Nov 2026 06:54:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23CED6B05B7; Thu, 12 Nov 2026 06:54:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12C7B6B05B8; Thu, 12 Nov 2026 06:54:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E33156B05B6
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:54:23 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F03E612057A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:54:22 +0000 (UTC)
X-FDA: 85426309164.01.7E82D0E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 59E3A2000A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:54:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iKZ/K1iq";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794484461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JdYD/YdMuJulWiGGAlT2Rpi62/Bld2oVWED5RC6QjGA=;
	b=dcYIeSNlzwn5mZUeMa3qhNUnvQp7SrvSUBBE+LQao48ii2ZT5RMu71IDIuzxn5CjKG86Td
	MAVdYf4id5a67yZrWtLxy+dt+1DVyVM+yq6t9rgno5eZXlZ4pwbWy19VoT7QwWw0KCqSUr
	NZhEIOEkzTYDFiFMSmJ9ZDZsO1IHjHQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794484461;
	b=s1u28QysO9H2qS/0Oh/WVJd+hoZClfXUleXyiPNguykrl5CFDSPChvDo58HWn4YcoQ+XY1
	RXD0d/hAe6lAZiia7ziNk05h54XhZg8ds4m8tLitGHHO0rkzSrDnYFc5YFhf5CgewAYXAJ
	XxBMp7L70Nfm3B74A2U96MzvBoOWs3Q=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iKZ/K1iq";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8213143442;
	Thu, 12 Nov 2026 11:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9ED21F00A06;
	Thu, 12 Nov 2026 11:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794484460;
	bh=JdYD/YdMuJulWiGGAlT2Rpi62/Bld2oVWED5RC6QjGA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iKZ/K1iqB0cnLxYHoQ9uVxCv0b+d4WthJcUEBANL3iO8xDOAY1zdbGmaFlcNBFdFj
	 m6kn2rPrgmUhvS4mRguW4tD9m7jcen5dda5WSkkV0cHEmXhfHUv6eYU3k1xSaNa79Z
	 IXJyky1bTv0gT41CyD7OAkAEUA3rOtRlpcdlcDL/b5LdjB5gyB+HGCMaBWwoyV6fCI
	 +9qQ5vZO5otJptN/vHoJckJUwGwf50A6JCcE9bUOcBSptoHJqtBiMqPxOEHbIUi/X8
	 vDJsTTqEMZPUFfr7/nUpNevSmO3bP7v9Onm5l/L9O5C8eglRGnAo3D8xeluHKe2ev5
	 30/GJP2YZRZKg==
Date: Thu, 12 Nov 2026 11:54:11 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com, byungchul@sk.com, gourry@gourry.net, 
	jannh@google.com, joshua.hahnjy@gmail.com, liam@infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	matthew.brost@intel.com, mhocko@suse.com, pfalcato@suse.de, rppt@kernel.org, 
	surenb@google.com, vbabka@kernel.org, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	kas@kernel.org, hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev, 
	kernel-team@meta.com, baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	stable@vger.kernel.org
Subject: Re: [PATCH 1/3] mm: don't PTE-batch a swap-in over a
 hardware-poisoned subpage
Message-ID: <avWouX4hCmAz9F4p@gremlin>
References: <20261111113904.650722-1-usama.arif@linux.dev>
 <20261111113904.650722-2-usama.arif@linux.dev>
 <avRqaatdOUunxrcZ@gremlin>
 <d74a277f-f14c-436d-868f-2566d90bc144@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d74a277f-f14c-436d-868f-2566d90bc144@kernel.org>
X-Stat-Signature: cm38aj3f1sb159t8563do7u6nmgwbpbc
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 59E3A2000A
X-HE-Tag: 1794484461-375366
X-HE-Meta: U2FsdGVkX18wKGqqXLsRT9iwOHQao24f7ZwvSGmZZGDfJ0MYRnQPNtC5kjkjeYeZYDOtqI1VqjpGnx0vnF9jDvpwqRAwqJcjj7s1db865S3+VD5ir/iHQtq9Z5N+VlRCihkhezhLtbN+TRYFskaW2I/sETmFzNsXC8sDv7GjMa/BgH7mhvkno9pckGSavmRIcq7eIFvY5pE9qBKprJtIUOeYWRtzjvj53O8xrmHhp9j46cgfEUmUQCt/hTaDLg3oUJpZv4ndeehcFZh9cZQz8ht1PQBE7k7Vlkw254GKIeyUFnAOSVFdZP2ZHFUN/cvjTg/Mpch4Sxc1+y/NQqKrwschpT910oErhjB2NHRp1DT4dTB6CxJFFFMys+8MwSnuEUE16AR5Wvh7FzFnLnLn2qxoQt5FnQzp3GeX4Ebcw3ieyz/jAl4td1AWsLzMhFCcePM4XoAegfDAiosn+T4pVhSiwMpH8cRrggTDwICy3y1uki7wz7r2kK2acUSOYm9y8FADXUGKz/ifVUxHLZ7siKHldkIxAOQusGgY7HwUwRkYRETwNmCP3xuG4844mERglppa/crrVtq/H5Ay/84esRG1uishjdMdVov2ZdxL1CYHKd8TJ1Gon7CO8324gvnYkPGyYd4h1PYrn4gyX3ce6k/3CaJFt+I4Q8oeSqi+o+/2XVbNp6drXj0r/mdmKBOsZJ1VIqycvWZtnO+UWaVcsoSNR3KepVVA37JIl8Uc0EaBnbpqrm7gkCLuO0jzZ3W7QHTgmquF3wStivGuLh7i5zoQMZfh0GgFUoO+3MOrENt9p0Nj4IZE4KU+wHzzpwJGG9iklmadvksDiHiM7tSpftn8JwIruAgo2sczIFGC/7T2l5+zIVOW10JoUrc7ztxjqZUgvfqXIC7yS5YY1CHMKH1j4Jlgw7yyX0zvO6ztLCR7isw8+Mz8AxK3wyHYMsNg2vGaragNRQQhbaJPiWt
 vg6O9ciA
 darSNk6jNnaalAKrprZD9fDlxs/xnyokK3TEC8GcUAmTOGyoGRbRBIk1xA2BxxnhDhcD5Vq5nui7w+YMY+ao+Q8nNVdbN9oCbhiV1vZziujMLuVgahYyvyadR6WcKbKVLo0Mv5J7PDmVS0u97vcVTMBPi42ZMwFy+9wiqLBw5ugF/chrcsc8k/mw8ilxE/eckCkceBX1B6L4pBrQDy9EAgtazv3Xae6qkZDGFvKg9PT2mTh/47vuCESoHnoFeBOIuubjBGQDLkf7mwSNiJraEpKFvrLjoMVe0hhoNOtN17Z6Azt6uqzOONN3WtBccL726esm4tOFBdvp1nuQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 09:56:39AM +0100, David Hildenbrand (Arm) wrote:
> On 11/11/26 14:18, Lorenzo Stoakes (ARM) wrote:
> > Hm, isn't scanning every single page in the folio potentially quite costly
> > here?  I thought the point of batching was to improve performance overall?
>
> Yeah, we don't really want another helper to check for hwpoison.
>
> If we race with concurrent hwpoison, bad luck. The slapped on memory-failure
> code is full of races. That needs a proper long-term solution, not more pain to
> core-mm.

Yeah exactly. See Usama's reply - it really does narrow into a weird edge
case. Scan there if you want to scan at all.

Otherwise tough luck yes.

>
> So let's please try reusing existing helpers that test the large-folio bit.

Yes please!

--
Cheers, Lorenzo

