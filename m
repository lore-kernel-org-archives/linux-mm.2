Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07B87F43699
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 12:26:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 378E06B00EC; Fri, 17 Apr 2026 08:26:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 329F96B00ED; Fri, 17 Apr 2026 08:26:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F17B6B00EE; Fri, 17 Apr 2026 08:26:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 09A0A6B00EC
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 08:26:39 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BAF8BB5C96
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 12:26:38 +0000 (UTC)
X-FDA: 84667971276.01.3E18E64
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id A0458140009
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 12:26:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vz7CRyk1;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776428796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bPSXhVxdBm3I6+x6yEzFDRC7WnugCEx30Co1vqOIzrQ=;
	b=lvwkTGx/jof1OK6/kkvpJSdv7/90Dwe81FU2t5mv4/T2UZCmBLQQbnVIqUVfB0C3MshWqj
	0QfrS1S4pbPtjLqdGLmq8gIDxDW9doD+4TGEcb8cGJhNYyoMfLytI0rh77qBQIcWtTiOfG
	xa9h6+ju56yplCVd2erSaFtdnwJrh68=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776428796; a=rsa-sha256;
	cv=none;
	b=3ctLbGu3WCKA5YDpjGgI3fLZg8PnqmBtgu6T1CFZOZ/eu7epg0/wLi2v+Le87tUCkyUxwk
	KGSOsmwfvJRkday9P4bVZx8IIHnFAuxJBcsdIaNDCQoUMb0HjdIS7VKlgCLIJEKYJQPqRZ
	CRb7eDu9TYL5sRMtEgfP5fZpW5w7R68=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vz7CRyk1;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5CA954072E;
	Fri, 17 Apr 2026 12:26:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3CDEC4AF0B;
	Fri, 17 Apr 2026 12:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776428795;
	bh=qx+8FJ8jA0NidxGCtpVyMEUiZNEXmPexoJxKiWGCiMA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Vz7CRyk10GE9Y73tyozR48+pEWlhyTxRJNmzGuwOCJIU0ALhdbG/0xIphC16F4qBi
	 oNvXvLxKGUSvCthYhOYcgTTgM44BCwhVYpDxXCult6wd7QVmrVTg1Q9qS3JM08i+UR
	 t4DxTL4IozATIHJEWSeyyjwmzG3PPeS5XVYpR9C+MK8uVVLffthgAOojT+B32BwMI/
	 mkSLqyfmDhdrreMbPB0x2ciWtkcSQcPZknPwYwRLS+ZlSgq6k24foxA9GupBuoBDPt
	 YTbnFyMxbphWdD5MF2JflguTTF5gNHe8DlU/7GiDQPx9O5b8zVou9+g0qaO9E2PdzF
	 rP+59js3C17/g==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id E3072F4006C;
	Fri, 17 Apr 2026 08:26:33 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 17 Apr 2026 08:26:33 -0400
X-ME-Sender: <xms:-SbiaR_NNX29Fol-5tVyTde8Xan6QF1Ql8exi2WW8gRE9IVJ65OtXQ>
    <xme:-SbiaUPFJt8aEHbBHPLSBJIqS7LkcEfBGX-8lGHKWRz7AXEZntyYOb0qWRrY62iPU
    -tz1eOj0dqZvXmuBBXYwsHydfPqB4rGDPFwpQkZNR2wnWx2CmqN8g>
X-ME-Received: <xmr:-SbiaVNocWi5hTKsgUmcf6e2hhxZtWBRl4gFRinEAU4EfM6UrrnMnQLATOyFJw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdegleekkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeffffekgeffjefgkedvjeeggedttdeljeekhffhudeiudfhiefgudeugffhheffuden
    ucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlodhmvghsmhhtphgruhhthhhpvghr
    shhonhgrlhhithihqdduieduudeivdeiheehqddvkeeggeegjedvkedqkhgrsheppehkvg
    hrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepfeei
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegurghvihgusehkvghrnhgvlhdroh
    hrghdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhg
    pdhrtghpthhtohepphgvthgvrhigsehrvgguhhgrthdrtghomhdprhgtphhtthhopehljh
    hssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhg
    pdhrtghpthhtohepshhurhgvnhgssehgohhoghhlvgdrtghomhdprhgtphhtthhopehvsg
    grsghkrgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhirghmrdhhohiflhgvthht
    sehorhgrtghlvgdrtghomhdprhgtphhtthhopeiiihihsehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:-SbiaaOpzH-hGXGD8Vnb7wDUjEyPZ2Yzd3P0SNl-CTUuebWkeO-rFw>
    <xmx:-SbiaUXLDyV9Dfmmz-EoGAYXiK572KSYrME9AJ_atGEPxDlDyLiBmQ>
    <xmx:-SbiaaqQpl4u3MiQQmUfZ5k6NA6ZhgCUTEF3_1g-aR1_ldmxlbWGjg>
    <xmx:-SbiaSecBy9UBAKEZg-YbcgBvEHjHQ4PBMISgK9pUxRGppKKv9YiGA>
    <xmx:-SbiaeBxJahyYoFrTpKPYVuki05v4yhgXwmld2lBZ-Pwdx3KjNYQq4Al>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 17 Apr 2026 08:26:32 -0400 (EDT)
Date: Fri, 17 Apr 2026 13:26:25 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC, PATCH 00/12] userfaultfd: working set tracking for VM
 guest memory
Message-ID: <aeImfRrrvr3UoKtL@thinkstation>
References: <20260414142354.1465950-1-kas@kernel.org>
 <55019037-4f1c-4d9c-83ee-3a844d8f3d5e@kernel.org>
 <ad50rPOseVa-SP_s@thinkstation>
 <aeDoqFWPFxkkNB26@thinkstation>
 <1a499781-1115-44bc-adbf-2ac3769354ca@kernel.org>
 <aeFCuLJXT8VOkzH7@thinkstation>
 <4c635703-3d8d-4cfa-bb98-7f6f5fcbe547@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c635703-3d8d-4cfa-bb98-7f6f5fcbe547@kernel.org>
X-Stat-Signature: 45k7ojo3wn4cftwnofucqj4odawbaeqy
X-Rspam-User: 
X-Rspamd-Queue-Id: A0458140009
X-Rspamd-Server: rspam05
X-HE-Tag: 1776428796-649540
X-HE-Meta: U2FsdGVkX1+iRWgKpGqiB4phBKYhkHktxqNai3kCVBkIR+q+relD7MnugNrmLrbjXKilstrzl3IHNkp3Y7qZ0LftO8FUjUVbY2SgEYtnOC8NrLEp7G2WWRSFzZrrPu0ZLtdxlcNbLZrHxj9280faLokYswD0DdjC8sksS3jEnPfy32a6jmRYFax2DT66Fob2p2nyKqGtHErGzkdSX7HrZkedF9dkrKOBvpCmYxs2KKELw6s8mdk3poyKTJhjwv12ld1Tsaj/hly3NAQrEKFS97EIQsB9IvBxDYFpMjmljK40BSxdlV52NFSTmz+MZiQucStttApzOlzBt63nvQF2ywftlJX6QXQFFRBV0POT/ILNNNSXOq8w4m0SrAzCF2Jgu1KojYKTDhJWD6sp5gXmLxGcFXIT4JASh8FmYw6ECG+gAxT1Cox2e0bnkpw/vAD04AoyYWBy5TL6tztKO+feItyAn1xTJ9zt6ZjtETIjUSs8wRTo/sxrvRIX6Z0s+OA0Kz0gFbr23frLQkBq7J3AbWZIqda1ARO0dy94RccpMKTjv2pSuEkKnyuhaVa7e+8z2t9r7184KqyBS82ZOj5AW6/rH/fLWxOAVAinIn49gBUMW8c1YftDZ9dx10rcFB3HwBLocumlczVKxFvBg5lbnmh3FCcDXDh2pIRZLALeVwUDp0CjVrRmrDvHNq5eds9Em6QV+GftV2j1ef3qW+HqMfAb+goAHieQc/GvslHecGO5+UDVGCzeCz7YgEmcnPWZjFQVczIVsQSZRl6TVae0uQBn1hr/8UqG1Bg6AWi3ILFI6Gmsp84BmywLoP4n8abOJVy9jA8ol8Aru0ISNFHM1XpfpdTycVvUoSDy1seTHUTEZYG0yqojaqRgsoKn/wtx8lFGwOreHadBrzKJjryrZlz1OxmjLBcXYfzRGyKbSlViMzlXWsfagEr8Q+cwX43j+z+WgyCsThPMiJoeJvg
 yE3lPkc3
 ZdtLVVP7yt5lkrH0bGM835jgXnAMwmIov/PntolF1uaYsWjyUgxmyD7tfuoa4FA65ZSWdT6vWXDwWRjgQ1anAHZptM/7j3TkjfJZKDP1OdeFE43fT72D0gmuYPCNb0ks2EyU0tUl9cNtc/+A4JG+f40ZNkZY8pyfWEamxE8aLcBUR+S+c0vDNyqtLi4ZU00Dvl02rGyHFtCqPgxr0PLv/4uMDwN4M7kVOiwtjR0BSjuxgrA/8BSb2hELtNAYMKMIk6ry3QpO0KhwJPioZFIVuyTcAp6kLxcFjlbW3IuI8swAF3CY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 17, 2026 at 01:43:36PM +0200, David Hildenbrand (Arm) wrote:
> On 4/16/26 22:25, Kiryl Shutsemau wrote:
> > On Thu, Apr 16, 2026 at 08:32:19PM +0200, David Hildenbrand (Arm) wrote:
> >> On 4/16/26 15:49, Kiryl Shutsemau wrote:
> >>>
> >>> Here is an updated version:
> >>>
> >>> https://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git/log/?h=uffd/rfc-v2
> >>>
> >>> will post after -rc1 is tagged.
> >>>
> >>> I like it more. It got substantially cleaner.
> >>
> >> I don't have time to look into the details just yet, but my thinking was
> >> that
> >>
> >> a) It would avoid the zap+refault
> > 
> > Yep.
> > 
> >> b) We could reuse the uffd-wp PTE bit + marker to indicate/remember the
> >>    protection, making it co-exist with NUMA hinting naturally.
> >>
> >> b) obviously means that we cannot use uffd-wp and uffd-rwp at the same
> >> time in the same uffd area. I guess that should be acceptable for the
> >> use cases we you should have in mind?
> > 
> > I took a different path: I still use PROT_NONE PTEs, so it cannot
> > co-exist with NUMA balancing [fully], but WP + RWP should be fine. I
> > need to add a test for this.
> > 
> > I didn't give up on NUMA balancing completely. task_numa_fault() is
> > called on RWP fault. So it should help scheduler decisions somewhat.
> > 
> > I think an RWP user might want to use WP too.
> > 
> > Do you see this trade-off as reasonable?
> 
> One reason why the PTE bit was added for the WP case was to distinguish
> it from other write faults.
> 
> I assume without a dedicated PTE bit your design will always suffer from
> false positive notifications.
> 
> Leaving NUMA-balancing aside, a simple
> mprotect(PROT_NONE)+mprotect(PROT_READ) would already be problematic to
> distinguish both cases.

Hm. I didn't consider this case (miss some uffd lore). Will rework to
reuse existing PTE bit.

Thanks for the feedback!

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

