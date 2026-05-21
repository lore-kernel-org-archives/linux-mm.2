Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C1ADCD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:59:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98E406B008A; Thu, 21 May 2026 10:59:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 965A46B00B4; Thu, 21 May 2026 10:59:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A2696B00B5; Thu, 21 May 2026 10:59:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 793166B008A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:59:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 29B8A160BB4
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:59:18 +0000 (UTC)
X-FDA: 84791735196.10.F3D4A49
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 695FDC0017
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:59:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QFt9uYJs;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779375556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UwTJUQEEjEAuGD/38EJAyyJEhAp/6WUIT8s9od8d5cI=;
	b=HPcE5EaNNYrVLUHZKKDt3za1T5XDCUa0exY2jjjoo99gInoRnWUm8dUfZjlRT1BZ5xHDk8
	9Tiu8a4OJxWW3eNIPdxR7wbGcygxfLLnoohFz4sSahHUUhdW4rNS8ETj6kmmWjVvTThZgh
	DgdXNrDzGOBzxM9WErMd8nM7PA6hyGU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QFt9uYJs;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779375556; a=rsa-sha256;
	cv=none;
	b=gkw5pXtUV9Ngokj8JTDrX5jOne3FL90pVLg2aGWhIuRlusvKLsMzlJhoqRKDlk5LuTqkFC
	2kxOvsSSIkbvzeZcTbWuHq6XqDO/JrDSaSbOZQsqXGsJoDqxrF4ZhzYT5brK2v5FpyYF2i
	+kE3FEviWhWSLvhNHDsNo4vahXM7LR0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8346D4055A;
	Thu, 21 May 2026 14:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8D71F00A3E;
	Thu, 21 May 2026 14:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779375555;
	bh=UwTJUQEEjEAuGD/38EJAyyJEhAp/6WUIT8s9od8d5cI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QFt9uYJslrjF5lm8zndfOP6s3oryviFzIwtzSew9cvovaEBxxtGMYXzbP6YEwm/FA
	 DzwtNNflGNX7N+8nu1hbd+NJ+jQqOdI3nxhHtvXbWBMjHkTOHLFDSj8QWJTT6IDJYo
	 uFIkB32kYEKxA5/AmPw1FtVZVCuVanyJYv+S67+Bcai0gRX6t533uIfV0YiMDM+DHD
	 mNdELy52vF5rXrxE86yG3e1LrKQK/Q3gpbuAbTkFtthFGJNf334t+hKR6Aw/r/LV6c
	 Q6A7crs20ItQBG5wza5dSlsdlUStwigXBDmsg/3T1ejlnsR3mnSwlXFztAe2aWPAjN
	 9B/gYwXbsHDkA==
Date: Thu, 21 May 2026 15:59:02 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Wei Yang <richard.weiyang@gmail.com>, Lance Yang <lance.yang@linux.dev>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	aarcange@redhat.com, akpm@linux-foundation.org, anshuman.khandual@arm.com, 
	apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, 
	hughd@google.com, jack@suse.cz, jackmanb@google.com, jannh@google.com, 
	jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, liam@infradead.org, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com, 
	thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, 
	vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v17 04/14] mm/khugepaged: generalize
 __collapse_huge_page_* for mTHP support
Message-ID: <ag8dnKjkJgLgNkDv@lucifer>
References: <20260511185817.686831-5-npache@redhat.com>
 <20260512074202.10253-1-lance.yang@linux.dev>
 <20260514031009.f66cgop3ctgiqxz3@master>
 <9b33339e-157a-45b7-942e-3be3418a5142@kernel.org>
 <agtpK1x27B-E7mMo@lucifer>
 <CAA1CXcCNT51jeXh6Kwg1QN9e+AJB-1hg21kmeY6fTTKr2GACug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA1CXcCNT51jeXh6Kwg1QN9e+AJB-1hg21kmeY6fTTKr2GACug@mail.gmail.com>
X-Rspamd-Queue-Id: 695FDC0017
X-Stat-Signature: n5mzwdwh6x4drqh1usishkec6xcf7k86
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779375556-75460
X-HE-Meta: U2FsdGVkX1+Q6erBBN0Xtl9veIyCk/KU69sWCD8jRsMHSGFSEBeNGGdK1RMgTikl53OFhX0Vrgk126+hRXihg80ur7fEj+KKyeVpzWx94yitOSuSP/t8zYKM35FP8KTEepydEAmxTxDE4p6lx8XTPm5H8bayDiHzxxh+gyM3hHf/t4/Ytzc/HEJ3wjrmV6WPOPSn5cfAgox9Nc+7MyEdHB4A7wqZOxryS46seKBj/ULLfDoluN7bU1pUJoQdBjuVXmYE6O9zx2xlc9tUWUTjXpJWx/kIMKTt5r037cgPwL45MvpVaV9F0AOQLg2mDOVY5kJFCHWP8Su5Vu0dv4SJpnnOe8+Oyt2eZsj/ZzXRAm9yW9iSqeZiCNI0ikeFcIiSLUIwT74zoAOWoGc3BnPg3qzuoxIOXc1M5SOL538cTRuWFnGFLE8w3awX/Hg5ULCo/DY8RhTGwiiPw0qqbw0mhJ1yqI+ckxXKLDiqrVWxPibCBDCbbA++aIU1toTnVOJH04bQ8APPoaL6aThi3xJr7i4K6hfg0k3vldbGqYtaQ+x1DssVuXydrAYFCkCLSklA+9jYNqboFk9OYoDog4ujekjJDgY/kX4ACpniMgXSw6oswRctsALQjTBnopnI3Onc5I2n1BaAnXtXMD8Z8H2Ykb9aIOxaP0NdTrESIWXxYkMpPYozq4m4QvELR3BTZOYaKmU2XPJy+pLYpIROruKuieEoVmXMlW7jYygkTVvdsu7zdTj7NNyYyZm7u75VpKnOYdJQEEZW/cNHz2qNbBABic3FNXTjQqMuURoTa5MnkNMTVVGiawhkdOrQWYUwYUyo2WeXd9Y5aKrnHYf2wnLEGejjq+MUueLK6Tp5EGWlpSJfpgCAXqHVwpIvwi8gLyW3q/f8U2fjx0WMBfsI8dX8fP5kL/FeNjWY/Hs0K4dw+2I1FeSiD0lwW4woHQb1QudSsDGHdhaZoqElVgEY+HM
 oBq/qyFK
 v6RrDLeYivgU5g7QiuoQB10TujPtTD9/7aE6XR7a73eulNDZDa8c0wyoD77K4ElfuVncOTvAOWWO6FkIoTIo/0f4khhZ/Pf+leLLILCwhEaKkJkmOiqE333GDgKUspZXdTC1ZVamI4xwnhB2PKmexkgHj/cliFvmNPp3BNBawQiB5t+FHnJns42EaQgzg3lHoA/Y510mCJscAhBF7jQhHFOiFS0mqk8t3AHJgyunqKeBbCSHYTfW4mx0bpm/jcI+ejXLnPVLR3KEuv4j8uc330/rfKWY2gq3LAn0k0oKJKBftedUotp/mwZJtXeVa2KfJMJOLa6sP2Q9k0eFdO4GJT7X1YpKxWTv5rM2eInYRtoef66oQzFtaMfjZofu/UWQ/57L++OJX7iN4cHxp+AfolnqFPnUcF/P6X3KH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 01:05:13PM -0600, Nico Pache wrote:
> On Mon, May 18, 2026 at 1:33 PM Lorenzo Stoakes <ljs@kernel.org> wrote:
> >
> > On Mon, May 18, 2026 at 03:16:11PM +0200, David Hildenbrand (Arm) wrote:
> > > > For me, I would vote for fallback to 0.
> > >
> > > At this point I'll prefer to not return errors from collapse_max_ptes_none().
> > > It's just rather awkward to return an error deep down in collapse code for a
> > > configuration problem.
> > >
> > > For mthp collapse, we only support max_ptes_none==0 and
> > > max_ptes_none=="HPAGE_PMD_NR - 1" (default).
> > >
> > > If another value is specified while collapsing mTHP, print a warning and treat
> > > it as 0 (save value, no creep, no memory waste).
> > >
> > > In a sense, this is similar to how we handle max_ptes_shared + max_ptes_swap:
> > > for mTHP: we always treat them as being 0 for mTHP collapse (and don't issue a
> > > warning, because we would issue a warning with the default settings).
> > >
> > > @Lorenzo, fine with you?
> >
> > Yes 100%, this sounds sensible both in terms of the error and the default. Let's
> > keep our lives simple(-ish) please :)
>
> Ok thank you im glad we finally came to consensus on this! phew!
>

It happens sometimes ;)

Cheers, Lorenzo

