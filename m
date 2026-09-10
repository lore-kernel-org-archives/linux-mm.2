Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B5F0C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 12:22:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B6D96B0096; Thu, 10 Sep 2026 08:22:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78E5A6B009B; Thu, 10 Sep 2026 08:22:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A4846B009D; Thu, 10 Sep 2026 08:22:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E1286B0096
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:22:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AB5941404C6
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:22:36 +0000 (UTC)
X-FDA: 85197765912.13.9680B81
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id C13878000B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:22:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TcmdY77q;
	spf=pass (imf02.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789042955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lzMMHQ4qcqE99IyLrBWHnnkc3ugPmX7+krsDlFEK9I0=;
	b=42yLn/OzGHFZmxE3+RGvM7ix/HF+bRoqaY4XkDFZSzTzmFoyYQMzrrnvY7TN4/SF1i4tOU
	TxsTk540fUDiMGzjk9FIPBnNn67U8faVnjArTjneD4VB0nCoqV2dnbX2r5D3OrI/1XSims
	hTRSDRjgMjDnIIEZwL6F9TP4bPULqF4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789042955;
	b=6SfpfvUNFXuECJmABk1BkekaflC74PuWirlWnb3F6gl1Hs7Uefs4cnnhWECgM9BC2ya7Zu
	r6fmjG0cObIt9b0liPF4TdzFkMbdHPNmfa7Zz5UnBVx7qpjK8RmSvIe3xuVZI6xyrLJLjj
	7Izh8DZ7fRIHu0WTUFry1eC3CsrRo5Q=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TcmdY77q;
	spf=pass (imf02.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2299E153B;
	Thu, 10 Sep 2026 05:22:30 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 519173F7B4;
	Thu, 10 Sep 2026 05:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789042953; bh=JsIchIKXRllzeVMf7NMQL6z5JkaoAhygZYJxaYnc4fY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TcmdY77qKzttqFzvwR9mi7wmJrNmBStuLbFRP54QqAswfd/Gt3ZeYxC9qk3E4uBj9
	 HHhqUy/zotOyuh+VCkxwxmEa94gj4LCCZo6ymg1E3zNgS5CEmzZXzEd2rzwsY401vX
	 UiUf6wU+bGZjCZzqV572xQ6383np7n6UldxEIKjY=
Date: Thu, 10 Sep 2026 13:22:29 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/3] kselftest: mm: introduce alloc_isolated_mem()
Message-ID: <aqKhBZorLSGmqDr5@e129823.arm.com>
References: <20260907-fix_split-v5-0-822b810458bc@arm.com>
 <20260907-fix_split-v5-3-822b810458bc@arm.com>
 <5c05b620-7a2f-453d-9725-fed4f536a019@kernel.org>
 <aqKOVGECsCNtSMIV@e129823.arm.com>
 <d0b3ea99-e20b-4883-8fa3-67fdbf5b1ee4@kernel.org>
 <aqKS7CP67X4h6NiM@e129823.arm.com>
 <31418d0e-9745-4e8d-bc02-dbbd5cb9e193@kernel.org>
 <aqKU0-Gm4yh78F3V@e129823.arm.com>
 <d6f2e6b2-9dc9-4f02-be37-14329c1a6798@kernel.org>
 <aqKfjqa6ye2AOU5k@e129823.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aqKfjqa6ye2AOU5k@e129823.arm.com>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 3yqoum3nb6aszfhw665krfjxc6nh1wc3
X-Rspamd-Queue-Id: C13878000B
X-HE-Tag: 1789042954-233077
X-HE-Meta: U2FsdGVkX194AibdONJnUbj0C5PC2T8PnNhlSPA+QoifbO32E3NgNAMxwtdnScMJkxKie52WfPJULd9v0EhfU/FYt0mCB8BVi98ls/mtLqVrBxFMK4sXlOTuV5S1CiBBZ62/CAPOt+9j1Pc6UhxZyidruzodkJv6iAf7r98zsrcmUfUSxDejgaxQxRRzEX/e/zYp6veu5yvS3SJN/ztNac8SqtQnTHcnI9b08tdP+vTT3zGLqIjjWqRMWGAOPApdtM3Mk03Ip8kPnLnR0sZ8wmV/OPkI/wa97CuY0I2/Wh+6wq6j7gfPE15tjmArdc4ewXCuyZUfMklH5j+DtkWpZ95LYTCcBIu8oOZvKpK+XiJkRq5KCf+3Mu6VC1ELA1+aMZpxNRGqe8TUM4OY1URpU47HU2y9NiAMeQtwgotJa1jCtV0qfAv8Jm5vbhHuABop6Z9umEgWDxEI/bqC4HpD1An/G14Cc6u3mRZtyHpChrkAYvCLYsBFvQQSEF1t191uFsruUfSC9CjAW61H6iytbD7Ta/U+IIdBdahHFRxCX8AJNDyWthIT4uklnNcgGuQISARPM4v73mqSxea6tdwHpAuLtdXafJDg3zW2rrmPxSdXGd7RwJZraTXE8X/XVXzs/AG4oMOGcEUEZ/lmraItUsJYJZ6aBkYRoJ01C5FArjqCgPgKKH/ZAIuH6eqCeewkkb0DXk2RtGgBhgLUWp9VMnnLJI2GifztzpU0AETCQHDwegecgaAMhImgSnkxf/3PHYeZAgAcEoRMD50MWDv0igLnplbGj3plW1qMeX76e2hBdTG9fl2DZ1QokCZLORO57QxUsp90KoVsFHklsVZcnZ19MAMMclqqM62hT9pUp1Eu/FHxWT97p38JqSNvXCqIy6Y77OH48SVo9bmsP3Pp33FxznHMcTIie8xWWFWZbTGOQraPdsaqiMj1Idl1wigI3kHIK/zVdW+qeHsBtzx
 jonR7qL0
 Anbf9EunK4/vIc5PGPmGCn2NUceDl4ntvBLo/EBndj7u/CtHBa915xbF9R/S6P6DBXQJU9WXYRm2bApeL575t8lIaMMUVpPwQ7P6XcIM9njpXpivLk1W3ssvHQmD+vruBUIaVi5dl2yUhtx61E5O1o9S/3Bj+omxpVSakqdbQjBX7wYe1fao66RFYrMrUfu8dNAQJac7yhvzz2NziIwHowdC7RampESkr5UPB674TpoSMJp3K/PZf9ALBfRMHUUzxaQcPDK63vyBDfpoS0gWzuBpDELbPBp7Cjwgp473dr0wK+CkqiPnKqmVl/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > On 9/10/26 13:30, Yeoreum Yun wrote:
> > >> On 9/10/26 13:22, Yeoreum Yun wrote:
> > >>>
> > >>> As I mentioned in my previous reply, what I’m trying to prevent here is
> > >>> a failure when checking, immediately after memory allocation,
> > >>> that a specific vm_flag is not set.
> > >>>
> > >>> Yes, I agree that this could have been a problem even before
> > >>> the internal changes to memalign(). An unwanted VMA merge could already
> > >>> occur at the time of memory allocation.
> > >>>
> > >>> So what I’m trying to avoid is a test failure where, due to such an
> > >>> unexpected VMA merge during allocation, the subsequent check that
> > >>> a specific vm_flag is not present fails.
> > >> Which is only a guard-region marker problem?
> > > 
> > > Yes. so if we remove ASSERT_FALSE(check_vmflag_guard(ptr)), TBH
> > > we don't need this patch unless other usage comes up to prevent unwanted
> > > VMA merge.
> > > 
> > > Would it be better to drop ASSERT_FALSE(check_vmflag_guard(ptr)) in
> > > guard test?
> > 
> > I guess there is value in asserting that not all VMAs by accident start
> > with an over-indication of maybe having guard pages, which is why Lorenzo
> > added that check :)
> > 
> > But I think even alloc_isolated_mem() is wrong in that regard: if the
> > original VMA gets merged, we could inherit the guard-marker, no?
> 
> True. I overlooked guard bit is sticky.
> 
> > 
> > Maybe the following would be good enough?
> > 
> > diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
> > index 5c8ec3ca75d7d..791bf6a68b9e6 100644
> > --- a/tools/testing/selftests/mm/guard-regions.c
> > +++ b/tools/testing/selftests/mm/guard-regions.c
> > @@ -2257,10 +2257,20 @@ TEST_F(guard_regions, smaps)
> >         char *ptr, *ptr2;
> >         int i;
> > 
> > -       /* Map a region. */
> > -       ptr = mmap_(self, variant, NULL, 10 * page_size, PROT_READ | PROT_WRITE, 0, 0);
> > +       /* Reserve a 10 page region with 1 page space to both sides. */
> > +       ptr = mmap_(self, variant, NULL, 12 * page_size, PROT_NONE, 0, 0);
> >         ASSERT_NE(ptr, MAP_FAILED);
> > 
> > +       /* Map a new region that is guaranteed to not get merged in any way. */
> > +       ptr = mmap_(self, variant | MAP_FIXED, ptr + pagesize, 10 * page_size,
> > +                   PROT_READ | PROT_WRITE, 0, 0);
> > +       ASSERT_EQ(ptr, ptr + pagesize);
> > +
> > +       /* Clean up the excess pages left and right. */
> > +       munmap(ptr, pagesize);
> > +       munmap(ptr + 11, pagesize);
> > +       ptr + = pagesize;
> > +
> >         /* We shouldn't yet see a guard flag. */
> >         ASSERT_FALSE(check_vmflag_guard(ptr));
> > 
> > -- 
> > Cheers,
> 
> It's enough but alloc_isolated_mem() could be modified to allocate with
> PROT_NONE first and then change the prot.

Ah, but if merged with PROT_NONE | GURAD still problem...
Hmm.. might above enough.

-- 
Sincerely,
Yeoreum Yun

