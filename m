Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD1B1606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 17:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QyO2K7lf
Received: by kanga.kvack.org (Postfix)
	id B6C4E6B05B9; Sat, 14 Nov 2026 12:45:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B444D6B05BE; Sat, 14 Nov 2026 12:45:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A807F6B05BF; Sat, 14 Nov 2026 12:45:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 849806B05B9
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:45:36 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0639480482
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:45:36 +0000 (UTC)
X-FDA: 85434451872.14.AC047AE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 142571C0002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:45:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QyO2K7lf;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794678334;
	b=mwrQvI/lkQOdYUpU3RF5TtQiSz+VtojbBb7wAi4Rk3EaIW/PKe8XTphzlUj+PottG5tIho
	cUjWbIV1PoMwyQxeCSrhz9lM5qMekf1+ffM2qGuR0k7BbU8O9PTHFgZ72i2HkDl8o6fW8t
	L+gVl1Cpy2bcemRIhkVkFTq4HV+pazs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QyO2K7lf;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794678334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xB2Ll/hE6fCRL1qkpv+uhy1y1+Wgnd2n6ZmeDTOra9U=;
	b=spIaWk6wW2fpLKKx9Bg/+UbLiQ7SfE5JCMYcid1wXEKK0S112uHiyhS/8Z2TeayH23iZii
	KgTfbZV2DUWvOmAmmBqyb3h4zeU8ZqijbslYb2EpSzc+o7jS0EWn6F50HwFG0ZwHCHWX2g
	9ZQyi6EWOA2rZn3FtJIde7rrLJKN0+E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9353260A86;
	Sat, 14 Nov 2026 17:45:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A281F000C4;
	Sat, 14 Nov 2026 17:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794678333;
	bh=xB2Ll/hE6fCRL1qkpv+uhy1y1+Wgnd2n6ZmeDTOra9U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QyO2K7lf1ccEKQG1VMjR3+Rwahnau24XY+kx4XPVNNGQEeMmOOut7N90cZW4mLteO
	 qjjCohp3Qs5gB9pctDHPTSXmSCdiISZagmNAN6RoKNrpZ6GXgX7UYPq+VI2/OG/wYI
	 FGqML+O0QatMY9194eGPdqOzRz4KFNY2xC+OGDidmocLeYAiBqZDjpOSBonm9HnXRr
	 TUaCkhO95FRm6FsEUwjE23wZ9CkrQjAuqu5ZYJDzmR4DfRitGiiBnJCeX1cBhJawQq
	 dnN4e6j97peIUuVQ4Oq0YyCX9qrqPa2yINYLRIG98eFspiKDABiKdSg5CGW6ueBiQo
	 Qsz6Eh5rehgsQ==
Date: Sat, 14 Nov 2026 17:45:25 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: SJ Park <sj@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
	gregkh@linuxfoundation.org, 4ncienth@gmail.com, akpm@linux-foundation.org, azpijr@gmail.com, 
	corbet@lwn.net, david@kernel.org, jannh@google.com, liam@infradead.org, 
	mhocko@suse.com, patches@lists.linux.dev, pfalcato@suse.de, rdunlap@infradead.org, 
	rppt@kernel.org, shakeel.butt@linux.dev, stable@vger.kernel.org, 
	surenb@google.com, vbabka@kernel.org, linux-mm@kvack.org, 
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH 7.3 463/507] mm/vma: avoid spurious write locks when
 mm->mm_lock_seq overflows
Message-ID: <avieGNg0Z0WsD17N@gremlin>
References: <20261113153812.408825269@linuxfoundation.org>
 <20261114003912.82206-1-ojeda@kernel.org>
 <20261114031943.192867-1-sj@kernel.org>
 <20261114154112.3718615-1-sashal@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261114154112.3718615-1-sashal@kernel.org>
X-Stat-Signature: xq15d61hn377ztpzpoztw3q359jjzu6r
X-Rspamd-Queue-Id: 142571C0002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794678333-33706
X-HE-Meta: U2FsdGVkX1/0dnAmA9xTiVOKh0YVXJtZnyN7LqKwa37iY4kvAP8Ebk4ensNa9jIVJsNqz22Dvn8ZPXxt2u/K9UkuGnY5areiyEQh6Uy4JGoS+KNX6TLXoogPYgmKghtmj8L0SGS14W9at112eDW0preG49PgRvTeekr5eitdEqH+yyYODMn0ixbSuXoGxm2YbDyCjcM+F+4N8fEWad0Ov8uzg328gBEFNskLfVanr5+sy3HXRCPwbv0pRg4fI8Yt6clNPkkiV2uO6O+w1P1gXMTFB1D5Jx17zcvW7diWa+F8boKcna/jDRiG+Xdv6W3LwUNGEdhQjAcXubBSo9lEb3xrQrqZPNRcCUgMnz2cGM4pmHjdNXU7R0xWu5Ozeid0U8K97mFm2ZPxHpfve7dFxX/eWr/xrjzCRto/DeSr93fdDc2oPD+v2lJ2fyNuyB5Bjp8WNp+wSVAL3a5mUVFMBBc/utBWn1Tmwb8oJ8w9XMxZIcPaEvySK2iXWwFNeo+B/eGwxcwPgKn8N3uy8Qh+ewfXB5wo8pgueWyvN7xf776ilGtnRz6V98wQiTsMFozw/erFNW8LJ4/EGJUS0GM7IkInfmN7WO6Zl1FQi6hvx3DyI5blxugas10XRwBYoXIKqklsDueASX4nbAltjxOrjZhs+UY6zDBIuw0bZEsEaLqMZxMtIoLCDf85mYHoL3d8c3WmIRMcYSmLoJexV08Lc9BUJ72a0cMb3p+MWXuBEQjWERCntd2s3RdZnnphimWDtxwDLfzQ25wqCvtSfeq6e8JvoQ5imyuTRzyCUCXHLkAbvnrbhX1CXmPjbg3uK2GYBqMasnqTvbaFm1wzpXc0f/GNT+Mk/U+exJAlJax0oZQCHaWJ85kBv7OTXuulBmEVOqJztj8eNhxyVvUW5VBcEWWHrU1hVqX9/3DBFp7jtLrHqF3bMAEnEHLJQeiVCl8h8zlap2OrCrHj3Ha0a+0
 8JsqsWQU
 6jwDyE93i2dfwOVC2CoXRZFmVRmsKRQ9ncZ0W/k9B1EhdYATaQew/hVVkjbbSVG8nN4rKaXrBBR8riFmrNi4to6QAVM53IZEZp5Q6MRFsNWDOft3L7xp3Vle8iFChJlwLGEIMQgQXGqDlb/qJLbwAbcYckNU4cn/BtZBEiakAhIM5OLgyo49PEjzIYRYJvx7FSn4KXrQg2gQQXtJgS89UaEWFVRdZ9znMuIfF0TTNa75lSdQQdcE7L/ULhe6fLdOhz2DCOd/DJx7JHErVx2tOKdOaOgKJniAcuyYp9CFxY0x2q7kV7gwiIbfcaO/tSZaxuKep
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 14, 2026 at 10:41:11AM -0500, Sasha Levin wrote:
> On Fri, Nov 13, 2026 at 07:19:42PM -0800, SJ Park wrote:
> > On Sat, 14 Nov 2026 01:39:12 +0100 Miguel Ojeda <ojeda@kernel.org> wrote:
> >> ./include/linux/mmap_lock.h:604:20: error: no member named 'mm_lock_seq' in 'struct mm_struct'
> >
> > I found same thing while running kunit.  I also confirmed both applying commit
> > 47e725702b0b from Dave and reverting this patch fix the problem on my setup.
>
> Dropped from the 7.3 queue, together with the prerequisite it pulled in.
>
> Thanks to both of you for the report and the confirmation.

I'll send a fixup.

--
Cheers, Lorenzo

