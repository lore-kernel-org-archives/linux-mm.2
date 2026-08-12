Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E87BC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 15:43:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACE176B014C; Wed, 12 Aug 2026 11:43:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA6A16B014E; Wed, 12 Aug 2026 11:43:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BF026B0150; Wed, 12 Aug 2026 11:43:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 75FA06B014C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:43:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EAD63C03FB
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 15:43:10 +0000 (UTC)
X-FDA: 85093036140.22.AF86422
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5487FC000E
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 15:43:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fufXIEYc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786549389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SH2IG96p/hOxc9SLkk6aVEywXxuFDmbXLKwtNkWmoN8=;
	b=A4EeT2VTWxZMxnrAOETPj9arr/u1hmeBVADPU3CFLklXin4TFs4balH3Eess0t8EvcIvDS
	/QPhf9gFpQoTJXL97ODiiX2P7TStuGicALlk6C6NZtM+rweRcDXeWR22xLmovIaX0pmKCV
	CaPUYiwrA1gHFFOJkMnn/GRPgkz2juE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fufXIEYc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786549389;
	b=6aiSdE7kugkux1VmDb/eVc5GObHMVZqL+pfmpCqKIx64WGUmLzIu1C9N7ZQHEWAbpLPmYL
	86JTiSHO+I7CXVqUWWMJg10CjLBQDri3nj/5RATxS7U1hN6WWXda5km1RZinq9A51L+gRS
	L/WEYmGyxjGWSG1EwmLpkZTI+P4Yjlw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 49497405C0;
	Wed, 12 Aug 2026 15:43:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4931F000E9;
	Wed, 12 Aug 2026 15:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786549388;
	bh=SH2IG96p/hOxc9SLkk6aVEywXxuFDmbXLKwtNkWmoN8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fufXIEYcOCk7YFdVicoPopDzl8wzocwZ2EjRi2VL5jySYt2sM6bAvIkk2USQiGyv6
	 bFTWZAOZL6b1qLTF0oIgHVtJh9e0XefpYACXv2k3cAAoRAJyKj8xk+x5US3k52E+ic
	 Ht/dHNMv92t9saJSHSqLLjWksucgUSNjan04csD2GLBawVcFh+oAAJuXFVt/sKDPgE
	 JFAtBUCbiVIXTbRbm11cghXms3QnAAR3bEUNGgzdmX2Nd+X493/dXPqiIM0z5hRthE
	 nwDltJFtZKB9f0ermYAXl7IilzdxDjzxlWct+ohIVz0CLq/gdxq4dPqDcF0xCApos8
	 RkRzccYduCbOQ==
Date: Wed, 12 Aug 2026 16:42:45 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, 
	Steffen Dirkwinkel <lists@steffen.cc>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"Denis V. Lunev" <den@openvz.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	David CARLIER <devnexen@gmail.com>, David Hildenbrand <david@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Juergen Gross <jgross@suse.com>, 
	Kevin Tian <kevin.tian@intel.com>, Kiryl Shutsemau <kas@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Toshi Kani <toshi.kani@hpe.com>, 
	Vishal Moola <vishal.moola@gmail.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Will Deacon <will@kernel.org>, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org, 
	syzbot@syzkaller.appspotmail.com, Jiri Slaby <jirislaby@kernel.org>
Subject: Re: [PATCH 0/5] x86/mm/pat: CPA fixes
Message-ID: <anyUC6VgwL73aTm4@lucifer>
References: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
 <555ea1d43a12c30a8f1eaf10c899b3790d728f33.camel@dirkwinkel.cc>
 <anCK3eWFMwZqq5ka@pedro-suse>
 <anXvODEvV4f_Taj7@lucifer>
 <anxbSdxDlyq__-T1@pedro-suse.lan>
 <anyOHfbXJAAmbcdi@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anyOHfbXJAAmbcdi@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 5487FC000E
X-Rspamd-Server: rspam07
X-Stat-Signature: ggra3jwbrtz66iy1kj3umwepasdienjd
X-HE-Tag: 1786549389-386290
X-HE-Meta: U2FsdGVkX1903HjwBulrUfKdvK20ocGx0kqkSqHTyQpn3ip9W8rZZCv9T401ipK3UZugSY6OEN7kJAvUvih0GADp3BmIceUeu0ibN6ap0207EFD2CvkOuM9JHsHmSfFJhpeumoYfYsuxZp933Dq2BTDIPHswk5ncgu1CBIfshjlq0Pvm/zFFHyEcbHC78KSv5zuPd8NVzfAp0iXnRAF80nA9tke7T01aWi+2ZWZGwRmPFdMy2ySewZKUZ2QRcbJ7YKywGiM8i4fxKvig4zSVFJRvLKdeuZkDds+mL6LKr2Or3+t1opEbcG9kef3gjY7Rc9YJs45m7bmSBR3ZnAElSVIbpSmCIOiFEtnY1hEebqOILD8NLGnA1ssdkiE8F+J9L/Zgr0BoCB6VNtQs4P7wv8Qd8MUpeKFYMlT/ogtQoqyEGfXpCSU6Vfo6HhxRR4TgNdwGUOCDGIYEjXLEB+Kxf5SDO0bw6fIjr0uHPPyx6pMoEsLne2B6ceUFCIkAlraFg4Lfr2XebbrT6IuntadVEsAYFdaoefr19ah1xnWx9McGOGbiCcPRK3jFw/RoF6BJjIS14uzXu6byYxs0ScqavfYV99IKQAe3xhw6FW9YzGfuCNfctnOm7kmq+bo2Z+penblW8FyS4arokItu27ft/pgeuHoLWzRrZgvf7SMLNB9AwBs2kryu40kGTBtwr0a+pi1fAFts4R/kzVdTdZXJRRCXwh9pRiP4XQhNrn57HiovA+rvyC/mrTbpUqwm6E67zxnhaU7PVxGYdRIDSKPXXca7TwhRd4vytiAeudq9pcjoeOR6jS/UGdoXIlrJtEoETN9Kll+oAfcLhf6DEy9yQQIcxsg+mXOWQog+iz9pgF8OxnSFIpY6OfD9BiGq6y+NcIQy2h/aFFUWLsqYhzr9DRvjBl0CiRaBtJYFHQ9ASGFyxwygAEDwjXBqaaP9tM6IiyxFNKTYbM5u2qKecOk
 AtpfINKC
 4/n44q4m7beslaqMM5CmPjIdYr4OFk+bVEkkarj30Orkc2aKyejsZhbe7+vrIGi5yosJ2qHnEEtU4a0iYmVPNdCR9e5JlEohqW507Thbn6vyuVAZTl9NY3GUQ96/gupMoqvJde9I7SHRzUY3xfYwLQgwM3NlEoAHrV2RUgYkBOE3ql3dBGW13T6JyxxKnO3DpZi9mF7zL0rOWc8eOtvinf5pU2fpiSzxA4+V+qOPqZyeInefI/BCaYbcuPITN5X+M7p6T4KO30yUbl2WmKHa5jrvSoo40MC9S+yu1NYqqF+EtS7mCYwaeilgfKtZmfI5Y3YsEafZh/zDo4uGj1FYPTNF2S4A3Vuqs+qrJO0WPFQyBBXihw0gfKSYORA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 06:15:41PM +0300, Mike Rapoport wrote:
> On Wed, Aug 12, 2026 at 12:46:09PM +0100, Pedro Falcato wrote:
>  Just Hold the mmap lock on callers, but it becomes messy quite quickly)
> >
> > Mike, if you get to queue up my patch then please replace the diff with
> > Lorenzo's (with a Co-developed-by:, I guess, since he went to the trouble
> > of moving quite a few things around). Otherwise, I'll figure out how to
> > re-submit it after your series lands.
>
> I moved some things around as well and here's what I've got:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=cpa-fixes
>
> Build tested only for now.

Had a brief look, all LGTM, send it :>)

>
> > --
> > Pedro
>
> --
> Sincerely yours,
> Mike.

--
Cheers, Lorenzo

