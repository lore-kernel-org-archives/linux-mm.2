Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B564C982CF
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 13:02:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C37F6B008A; Thu, 17 Sep 2026 09:02:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44CD56B008C; Thu, 17 Sep 2026 09:02:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 315B56B0092; Thu, 17 Sep 2026 09:02:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 026116B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:02:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 339801A034D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:02:36 +0000 (UTC)
X-FDA: 85223268312.10.AE80705
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf27.hostedemail.com (Postfix) with ESMTP id 82AC84000E
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:02:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=HUfpaOBv;
	spf=pass (imf27.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789650154;
	b=ZOVdt77q5locO8po7YlK5xwJUa1jyEKQ8GMFoR50uNnPDruFotp/Eqf3TqsVfXQMJg32La
	hFM9RTkl3KPToUj2q9lYBXnha4fIaugRN1LCLnpXqr4hLUegAN6dmfOiLpbpvKKa1+p219
	mRUjMNgCg7QUeOKnMBmy+rJee28SemU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=HUfpaOBv;
	spf=pass (imf27.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789650154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gi8aEfK6gCS22vyEarpUsr6Hihppu2IQ4JZrnnv3f+s=;
	b=5B1R8Q9VJ1wmTK7x8Qh1RAptq3Twq/1DD2ECZ7GKobCPH4QHr5ktALLOxpJkPUXqnTD1ix
	1tP9M8JGy1kU2sHb0ifRieAlVzuAWiXkdNbbFv8Xn7dNrQmfD49/AXZmTWxvWcvFYg5HRf
	e6Q/DMSRPY0MdKoQ/ukieIYTH76hon8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Gi8aEfK6gCS22vyEarpUsr6Hihppu2IQ4JZrnnv3f+s=; b=HUfpaOBvlUMAHPSpVKl1cg93qz
	KXOCSwlbHp33fQy1tODtoNm+wK/hLhdGOwAgob1rF80at4PG1Ji1WR8d09odLnChaiMXjXCUW+VOh
	X90aUzssScG4E9JI58m+o0bf6rqdWsfzxJSj+KpqKT2SqIRMfEPGaLsY5k60aOreSFUM/YZAflK85
	xVmpSKS/iKEmymgRe+ILwgtooc2C2OydulTjF00WkTf5B5TQM4GBBNjgpTMPld4pv6C0ALjKjlnS7
	q1Ul0HRgXganFdkmVBZ+9XQIrMfYt9PPN9nQ4g3ITWymsEhjro60qagJfPugcTL1vSK20kxPpOcno
	Sz5WaqNA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x7BkC-005xUi-27;
	Thu, 17 Sep 2026 13:01:40 +0000
Date: Thu, 17 Sep 2026 06:01:32 -0700
From: Breno Leitao <leitao@debian.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org, 
	kexec@lists.infradead.org, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Oscar Salvador <osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, hannes@cmpxchg.or, 
	shakeel.butt@linux.dev, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, harry@kernel.org, 
	linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, kernel-team@meta.com
Subject: Re: [PATCH v5 7/9] drivers/base/memory: count inherited poisoned
 frames into the block
Message-ID: <aqvHHHuWJ-y4WRJZ@gmail.com>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-7-3bc7a57bd503@debian.org>
 <de41b78a-8471-4832-be0c-35d410a4499a@kernel.org>
 <aqpczrtIwSG948iv@gmail.com>
 <b8ad366a-a019-4462-9dce-f687f60ee7f2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8ad366a-a019-4462-9dce-f687f60ee7f2@kernel.org>
X-Debian-User: leitao
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 82AC84000E
X-Rspam-User: 
X-Stat-Signature: 7bx416hbknq6zyby3bd1m6378t8w7ei6
X-HE-Tag: 1789650154-998201
X-HE-Meta: U2FsdGVkX1+OhkK4isnv9vwJlDz0VWnUFy3BxY1GZr1qL5IDRduBx1nYUxf+5v3FUUQarj0X7qbDtzlbnxa2ic4KQbk/+ZvwzoEpNEKEU+YCjjXXxnjzKFCjcnnpKYkia55JEiqig9HbXrkDhGBUsbwdM1A2m/oPCJxBxRdDwR2TSjBufHnK7lyv6HOEbYE5ItwCRGDYqjNA0xKCSZWkyHFhbqs/DJuBK/Qj6idN2IWduvGgywGzzE3M1D86UUOW4jSKIUzIdGPm9pWpL5E9Ia6tFWCifiDuurvWXm4lrDDMmlo1VgjazDI+xs6TDzkdFBxg6SJwr29CXE0LKcNgToADN3p+X/kJYa5CbponhvfYR20pLIqo86xd3ZPNBQqpWjifS6H2X2emDU9M1/f9UCsnBx2O6j2gPohMe1/MG3n/f4/PUDhgEV1wd1wt0s1l5glibmcl1LzKBcc8FnLrAY+5jSFRor0PMaVmZSdlindSv9lsPh2KBX3MGVIOJN19n6DibFxNbaoiDLCfp7fTCHWvorj3pxSr1nwRKz8U3e/cz32MgCCqf14UynYD6stHc99XIoRf3E6NeCI3iju7NqrhdbSXVo0uITcVXuHucC41xFvg7ne4zXVYyWrIrQTo4VMg8jZzmNrwB5Bc/ydlXWWXM1L5+6cGLGdg0u8j5HghsoaXLPACrrAAmfnWwZ3musjvi1Kgy1SKBjhYApJQqCr16DKIqVWs+XFktcoXvIrwrOlBNq4IMk5nCXskuWDDSNx5ux6PH4PKhsFSNhIDLYyNGVYTysVCXbSXNFcZ+Eim/38D4wvcU9nRKjHOrqc0+fzRpzyB1VtpTT20+jDCW/19Uuyei5MFbED4dwIku8UHtKmVGeHBIAJ8kidxHUJScl3wanEH+0eroMCp3lFnZy2GxurFE6o9BUywTXQ+XGshrUw4QcAl0Pt7orVHQAPgathU6mS6S0joAonefgx
 n7U2g5Fh
 tu+u9x8xddGWJB9EWRUrW6oxAcM7epdIlN+gR7LMxX/50xMCXW6CWnVFRBNYvcuALsrU0jv14h6Vjm7Ubxe+cZYxjR1XfN+ekldlZEhonOTqlCs5tHR8eJIk7j9Ad0ZY0mZRVOIWGe8UoeP+u9al6mwy3xVC7rdse1cLaYN+H838gtdn+DkpFPB/IcFoh4Oddp9prHM3M4RedEHtR7n3KG4psPl4wO/oRE7IbaE87yF3XQsFQQt8B+S4ttnjwenCtN01Jr29rsv4Tb7Nxuc+PXUD8vOixmSx3KW1odf9/axaDmej29cy5Ho1m5hwzGnnP+441UOKnKXeQSq3twN54dwOqN1VDo/bJ4keV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 04:51:40PM +0200, David Hildenbrand (Arm) wrote:
> On 9/16/26 11:35, Breno Leitao wrote:
> >> That just slows down boot unnecessarily on 99.9999999999999999999% of all
> >> systems out there.
> >
> > hmmm, I am not sure I see it that way.
> >
> > The loop only runs for a block the bitmap marks. On a machine with nothing
> > recorded the bitmap is all zeros, the range_contains_poisoned_memory() check
> > right above it returns false, and the loop never executes.
> >
> > What every boot does pay is that check, once per block. The stub installs
> > the table whether or not anything was ever recorded in it, so this is not a
> > NULL test: it is two 64-bit divisions by the unit size plus a
> > find_next_bit() over the single word a 128M block covers at one bit per 2M.
> >
> > The real cost (that "for loop above"), comes when you kexec (not on cold
> > boot -- given the bitmap is empty), and you are trying to init
> > a memory block that has poisoned pages into it. Which seems the right
> > trade-off, no?
> >
> > That said, can we do better? Yes. The silly win is to let the table say
> > whether anything was ever recorded in it, something like a
> > linux_efi_poisoned_memory->empty that the first recorded frame clears,
> > and return on that before the bitmap is reached at all.
> >
> > Is this what you are looking for, or something more drastic?
>
> Ah, that magical "range_contains_poisoned_memory" does a bitmap scan?
>
> I'm sorry, but that is absolutely confusing.
>
> There is no way someone will figure out that range_contains_poisoned_memory()
> queries some efi specific bitmap that won't even be able to represent any memory
> outside of it's range.
>
> I don't really have time to give a better solution, but starting with the
> naming, range_contains_poisoned_memory() is just absolutely misleading.

Fair point, I'll clean up the naming in the next revision.

I'll also add that ->empty field, which should help locate this bit
faster and may let us skip the bitmap query entirely on the happy path.

Anything else you'd like addressed?

Good to know this moved the needle from "David hates this feature" to
"David only hates the naming" -- I'll take that as progress.  :-P

