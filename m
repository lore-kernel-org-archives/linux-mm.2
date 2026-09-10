Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEEF5C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:36:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF0AD6B0099; Thu, 10 Sep 2026 07:35:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA1546B00A2; Thu, 10 Sep 2026 07:35:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C73CB6B00A3; Thu, 10 Sep 2026 07:35:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A69C66B0099
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:35:59 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 43BAD1A04D9
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:35:59 +0000 (UTC)
X-FDA: 85197648438.17.28A8B9A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5BAF340005
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:35:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="CgX/mRT0";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789040157;
	b=MWUSMIZmUWAtTJC7XaJRQKEOS1wQuO7NsU/oKvd4chYq0QgdDERGzD3k6J0cshZK4HklBt
	JhAhN9Zj22/2hp6Z2jp95+g41S+nUU5lfobw+nGWmVPeCig1Nc0PvmzPQm3Zvn4DbA+Drf
	mnHTMhAGUit41WnQopXHMOeAEyM45/M=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="CgX/mRT0";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789040157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0yQR10rXGyLsWv+o0cxAuGH//hC3EjmuljRwX/a5Yjs=;
	b=QG0Wyrg2gH3aHx0d8b7PDyvukzC4w9uawdwZXuv3tq8c+QKHGFaGgcb/2rf7V1uJPdfcy3
	v02zDEQRHAMf/s4wA5KJ3xMhh2Ea/Psxj59fPtsq0SItSPter6nxe5cfHcbJz/i/dp7556
	rD4WofojM+eunVP7JVCmEgnlZpmoU/o=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BE4EF153B;
	Thu, 10 Sep 2026 04:35:52 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E863B3F528;
	Thu, 10 Sep 2026 04:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789040156; bh=aczfw/OR9qUx8B3t8k1OQ/240hod4So0X5+xLV4/xTA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CgX/mRT04r6IGfuQdDy64iV7rk9c3tmgqtkbP4fAHIXXQyY1qGDmqhzrIGyBV/x4d
	 6VCv3Ejrr5df0vlUe/MKPJyXEN0lFj6n7DXxd5v6HhF8nC2JCBMcBt1BitEZZ0JtGb
	 G6tL2+pAkuCeWX/2qbtSouG74LXKcFbRexY4TzWA=
Date: Thu, 10 Sep 2026 12:35:50 +0100
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
Subject: Re: [PATCH v5 0/3] kselftest: mm: fix some failure of
 split_huge_page_test
Message-ID: <aqKWFihYpLrLILcZ@e129823.arm.com>
References: <20260907-fix_split-v5-0-822b810458bc@arm.com>
 <b923f63c-db7c-4ecb-949d-368bc6311626@kernel.org>
 <aqKHHWKvOonYZPy0@e129823.arm.com>
 <21e0a933-63b6-42b4-8cd7-df05b0c9acfc@kernel.org>
 <aqKRdIjAYB2PEwRN@e129823.arm.com>
 <9750125c-49b4-48b1-adab-3a1cbec4255a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9750125c-49b4-48b1-adab-3a1cbec4255a@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5BAF340005
X-Stat-Signature: uef4uk6zpmujq41zm368qrfnf1ngxkp5
X-HE-Tag: 1789040157-396921
X-HE-Meta: U2FsdGVkX19QNCW+pkAbn/95oLjIVmcnmU5xNluN4RmhhTIKQFjK1ZTgB2eT/YjsXuUqAZdLCXgLN69oDtoJgJuCAuMH7oI8ZxRy7OIqoWk0E0E6nh9BW5moZEw8C7092PpVbr3INfZQYQJx2vPnoL2dbokTTgzD6cj2ISvP70l9ex5RWfmWYks5DXzg09FBLDE5XctGOrcIDeU79nTOBKdJoAU9Wnr8xH6TM1QThmL40GazK56nGWfhq80XYupfqgiIyOV041d/5mqEZcAGQ1wqqVRT11pGDEku4mpbQW3rd5HYO2i9Q5hdSfjQ11Es/VKqO/6aos3F8S9i5+GIljySWSOfk3ps+YkEGYjPGFWeP2IDrFjfZriGPpvXHLd797BvLa9GzuRV+Q2n9J8WCMlNmDkv83/Sz+6QFuoysRJWt4EAfO6h3537DTNR/S9pqp0wOjn1iev4oNiUuHhUb5scyEy3aYMqEGO91VQviBzECfCRy3lVzNu7qXSqL7P3glBZx5lMNa0lqZdBi5etxChK+0DaD2rQzLLFe4+cMlsZw6ATDG/tg2iwSA10VQfSts7+UwbAoxsRTi/DwgZG64DL/F83N1PKq/U8vVAAsC0dUffUooOhZusrzwR0d9RcBkh0UySUk4o5GMZi8IkW0K4323VO1LLRXRP+KtK5fc589YbMrbZOugvKz4eFDK0vGReNE18oGTTFozhXob48NEpp6kF/82UL7UQgcMf1MkAbfhfgz+AIRn6sRkKTrRfYk9tAj2VR8VvpnegK6NCnTmH0wh1bUT0ynpT76MZHLidc06XSpyDrx2HLGZC9KJ5/P/2siREvNSX25rYngGY7Y7M13yDRDkbuoUMkLl3E/so+YYx4Bt6soBGDhfuAuaBOtCy73/nq6NcnEJsJiXeLoWB5MwAYwV6P8TAZMhGDxuiftuANqC4BwDWXzL7axwdiIxVG6/p0T2ofTpRFAAG
 bOMT0Rf5
 BQOf9uwIZy5foRVVOW+jPbTeQ3s/xIsHK0Ey3/m347tU/PRc2Z2VkcE81G4qYSc55s3cyWhKOe74hf+Sz3gkDIQCoEO8oLhYCf6j7Q/uvQtd2VJOzc3XPJFZmi3YRlot8tD5UH3/HAehugnjlliCJlTVw/ON40k5CSL3oZxfs88nHIjQPO0ZPT8pfuQ0YJz3Xow1HgQp4yJkoMWLXoIvTOCQARbxJBdQ2Ox7yv7Qf/IJrlIFj4Q5RjU2QUyiELOQJU2iSIGMYXVjs+ZwxJi1fBoSgh36227j3n6VU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 01:23:15PM +0200, David Hildenbrand (Arm) wrote:
> On 9/10/26 13:16, Yeoreum Yun wrote:
> > On Thu, Sep 10, 2026 at 12:45:39PM +0200, David Hildenbrand (Arm) wrote:
> >> On 9/10/26 12:31, Yeoreum Yun wrote:
> >>>
> >>> Well, users currently for using /proc/self/smaps are for check vm-flags:
> >>>   - guard-regions where using check_vmflags_guard()
> >>>   - pfnmap test where uses check_vmflag_pfnmap()
> >>
> >> Most vm-flags should not be an issue when it comes to merging. The only
> >> exception are vmflags that do not prevent VMA merging.
> >>
> >> So it's VM_SOFTDIRTY and VM_MAYBE_GUARD. And I agree that for guard-regions.c we
> >> likely have to care such that we don't merge by accident with other VMAs (guard
> >> regions).
> >>
> >> But that's independent of memalign.
> >>
> >> ptr = mmap_(self, variant, NULL, 10 * page_size, PROT_READ | PROT_WRITE, 0, 0);
> >> ASSERT_FALSE(check_vmflag_guard(ptr));
> >>
> >> could be problematic on its own (unlikely but possible).
> > 
> > Yes. That's why I'm think it would be good to use alloc_isolated_mem()
> > in case of ANON mapping for this case.
> 
> It's really only guest-region code that needs this.
> 
> > 
> >>
> >> For other flags, you really only have to find the smaps area that covers the
> >> given address and look at the vm-flags.
> >>
> >> Or am I missing something important?
> >>
> >> (merging vnas with VM_PFNMAP is impossible right now IIRC)
> > 
> > No. what I want to say including the patch #3 is for the above case
> > where you point out -- ASSERT_FALSE(check_vmflag_guard(ptr)).
> > 
> > Since we don't have any interface to check vm_flags execpt smap
> > and for memory mmaped with anon would have a chance to merge,
> > We need something to replace memalign() with preventing unexpected VMA
> > merge. 
> Only for the cases that actually really needs this, which is in my understanding
> guard-regions.
> 
> And I repeat, this is not a memalign() problem.

Yes. I'm not claim memalign() is problem but want to prevent unwanted
VMA merge. That's all.

And as I mentioned in another reply, if we get rid of
ASSERT_FALSE(check_vmflag_guard(ptr)), this patch would be droppable.

-- 
Sincerely,
Yeoreum Yun

