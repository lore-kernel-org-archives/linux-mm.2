Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 951F9C5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 07:13:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E5B86B009B; Wed, 19 Aug 2026 03:13:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BC6D6B009E; Wed, 19 Aug 2026 03:13:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D2FC6B009F; Wed, 19 Aug 2026 03:13:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 564F26B009B
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:13:57 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DF42CA2EC5
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:13:56 +0000 (UTC)
X-FDA: 85117154472.02.8016BBB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3319E1C0009
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:13:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jJV0OzwV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787123635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MEh93umEkAdwM7W7h5DMLx7l0jri6Tex4Ey3QmOKRt0=;
	b=ya3MsAA4QiBFJ0Pfw7Jy72jKdihsLP+4dijAiCf4K1Gue/nRc+aPO4yy0MQfyGBo8fa/iy
	Ri88z7jJY0swCNuTn1650C3Nak8MVxSMiTdMiRQG99zNBvT4VOhFPuAOgm6nq9Ri7YWp6N
	NlDsWgquiIEGw/x9j0e5MjrVd6cHREg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jJV0OzwV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787123635;
	b=KTzU1ePVZVlcreejprJd8UOyExYyCShlOGJuBC/HOn0j+E99t7QoHA1ejZ+HYmjcQxkUy+
	X7ixB//lUruvmf/tngBiv9c5TwL3o3MCfzoM92ayVp8Tivd6J0QdvM9V1KiQXh5apUcA5W
	6Z3ONQhjC8gn4gYADobZPckaUdA9Loo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B0871601FB;
	Wed, 19 Aug 2026 07:13:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FCAB1F000E9;
	Wed, 19 Aug 2026 07:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787123634;
	bh=MEh93umEkAdwM7W7h5DMLx7l0jri6Tex4Ey3QmOKRt0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jJV0OzwVbpNuL1O7IKYFMOfkJNn5jUunHF3YbR6s3DRCL2TlLVhLPBotWdiGtRokA
	 tmvHyqyp+imK+t1Fq3nxpk977s16W+HIjEKyInWVUV1oA//lPAb6rPWocpZquA5Ccm
	 bgwCf3DzoBtBiJCPGwlFz9HjCr/lq2MMwhpgdxHoSsupRhmU3NSJ07HL6c5BUc2jmQ
	 uN/InEQopdQkSXzswZqrN8YxkDoenas2ccCQodY70U8cWRig2OBGou4vh1U4PakYtX
	 vAKsses0e/ZiFmKxHArYa8yhDZVE4w8x5VBUX22681OzmQsFslwRWWGAKw1WggWAbV
	 zsPrgq11T43eA==
Date: Wed, 19 Aug 2026 10:13:38 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Adrian =?utf-8?Q?Barna=C5=9B?= <abarnas@google.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexandre Ghiti <alex@ghiti.fr>, Andy Lutomirski <luto@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Len Brown <lenb@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>, Pavel Machek <pavel@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Vasily Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>,
	Will Deacon <will@kernel.org>, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-pm@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	loongarch@lists.linux.dev, yosry@kernel.org
Subject: Re: [PATCH 6/6] Revert "arch: introduce
 set_direct_map_valid_noflush()"
Message-ID: <aoVXolZ1pEJBZNjF@kernel.org>
References: <20260816-execmem-set-vm-perms-v0-2-v1-0-90944a3ad43f@kernel.org>
 <20260816-execmem-set-vm-perms-v0-2-v1-6-90944a3ad43f@kernel.org>
 <DKRBF6LQY1L7.13CIBHAU0A87D@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DKRBF6LQY1L7.13CIBHAU0A87D@linux.dev>
X-Rspamd-Queue-Id: 3319E1C0009
X-Stat-Signature: kwhm8k7kg3anfdibidbtwceabqzmf3nt
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787123635-139526
X-HE-Meta: U2FsdGVkX1+8lnWtqx3UGrWTFp98c9VKCmCDjPuOTI1o4tB3BCtALpjg6NTrVA7qVdl7GU/0Hbo04KvNnmrWkpEmSxDQJ64zekNJPSX/jXsFo4173dmZuQrlrU3NZw7OmPo8NEgle4hik+rxoJhqZ0hiROnZMOCsTA27miBEUqiI7x4Fuhqq2Shn/5YFYIWKWZUuJ4E3963yM+Q2BZ7tMGs8+Te9QNjQGOXTwMokJCF0Rg9ctjGFla00vdNeMm2KapXz0/HMKiEbSPrXMeJA2n+2YksyRio5rtiJYnSvYd4pfQ89uHKUis8ExnMIkPbaWGw42tiUOJfkexkkxkan6TgUMkVX4Fy9K6iILIJNDh7qIfPhuMOqdzDyye6cVWNdHzMJ1XoLbYn+NDyzXDx4npoAv4KxxcIafoCQUBg2T2rZ0cfGB3j4Y7UizWJtEJtzR6+G0w5twiASDtGfKrQnwwupmEIYVlNzELigHKgn9knyz55Uu+jK1TTIkfGdyJdJdxKPJJ51W/RGNeTnCWa2D5UcICaPfQrpXg0kQJgKxl3RvGU8DxUREoNW/e9BaqzNQ24rx4k16BNI1rexRT5uBiEWT2BT4rMfUME5wgPw6uNbsYD646PBXSnytvfmlETB4dIzQbuXep6Z+FLypJUt/1MW5y2J7taNPY4d1oTs9r1P4SrXZB/7QkG9T69ax5rnkhULZydR6jVDeO+AA57a8AYzG2m7hh4u2irjiLPh0iRMBy/iz9/DSzWr5pmVIF4mmSbfZhVAHvpCAdapDTV2IqXiGPSZWV0AacotA6QW4MmWToKrOxJFrHoM6F6/LsTzJDBT22HYfRYT0QWFbLCopX2MdfMjfF56TmjtS39VHOVobw3wOUGfh67I1+A3rMteOPQRT1K/SFVxBWNmD0WJOoBFI0eZPoPINQJ7fJQ5vuAdaFJAh5wRGlINSV7CMrgpzRoDqIu/TEoxLjokN2h
 87sS5pRt
 Hl20KTToOh9VAUQyRfZhO0LedEKZpJx0Aao2KMAPEtv8m8SY+eEQwptaRNPOo8PCXGIk6vN2DyJIS4oMUQWGM2jmJ81diyp7AROYxwGChX+zScCsHsmiaiDjojNyf2njZnFl5O7do/lTz9fsBN1Qoh9GmJ/Rsgu0ZpeRZumMWvCIx2aqC55G5W7ky9BvXhhd1LyOdEQLYXb5rCA0FKnT0x38ogiYpCQKN4nY7ctSSciIAc2acdb7rimHB/XfgcfkOFBQPXcPphMPYsuRh1w4/JmwSdyMlnFlRJG4/szdGwQ60d+VgINLs6YzQP6qxTHtvMrCNZCaTU4LSTUY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 05:14:19PM +0200, Brendan Jackman wrote:
> On Sun Aug 16, 2026 at 12:59 PM CEST, Mike Rapoport (Microsoft) wrote:
> > Commit 0c6378a71574 ("arch: introduce set_direct_map_valid_noflush()")
> > added set_direct_map_valid_noflush() to allow updating the direct map
> > for a physically contiguous range in execmem.
> >
> > As Brendan recently pointed out [1], this API is confusing because on
> > arm64 it means that is sets VALID bit in ptes, while on other
> > architectures it is an analog of set_direct_map_default_noflush().
> >
> > The only user of set_direct_map_valid_noflush() was execmem's ROX cache
> > freeing path and it was switched to utilize VM_FLUSH_RESET_PERMS for
> > resetting permissions of the direct map alias.
> >
> > With the last user gone and with set_direct_map_{invalid,default}_noflush()
> > accepting number of pages as a parameter, set_direct_map_valid_noflush()
> > become a copy of set_memory_valid() on arm64 and a duplicate of
> > set_direct_map_{invalid,default}_noflush() on other architecture, it is
> > safe to remove set_direct_map_valid_noflush().
> >
> > Also drop a stale comment in arm64::__kernel_map_pages() that Linus
> > bothered to add when merging changes containing set_direct_map_valid_noflush()
> > to his tree.
> >
> > This reverts commit 0c6378a71574daa6cd1534ad42a956e3262756c7.
> >
> > [1] https://lore.kernel.org/all/DJ69RCVRBO0Y.3JCYSW50IC4RC@linux.dev
> >
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> So basically the big issue here is specifically that
> set_direct_map_valid_noflush(..., true) is special on arm64 and not x86.

More precisely arm64 differers from all the rest.
 
> And we fix that by jut deleting the API. SGTM!
> 
> The other issue I can see here is that set_direct_map_invalid_noflush()
> clears RW on x86 but doesn't set RDONLY on arm64. So if you unmap
> something using set_direct_map_invalid_noflush(), then map it again
> using something other than set_direct_map_default_noflush(), you get
> different behaviour between the archs.
> 
> I think the answer to that is probably: doing that is a bug, i.e.
> _invalid_noflush() and _default_noflush() are a pair that you have to
> use together. But I haven't checked if this is currently the case. Maybe
> it would still make sense to just align these fully?

All set_memory + set_direct_map functions very much rely on caller to know
how to use them right. There were only handful of users outside of arch/ so
it was kinda sustainable. With the increased demand for those, security and
whatnot, the whole bunch of set_memory functions needs some love.
 
> Anyway, aside from all this yapping, getting rid of _valid_noflush()
> seems like an unambiguous win here so thanks for the cleanup!
> 
> Reviewed-by: Brendan Jackman <brendan.jackman@linux.dev>

-- 
Sincerely yours,
Mike.

