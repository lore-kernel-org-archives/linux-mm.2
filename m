Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B4E2F589DB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 14:27:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66C066B0005; Thu, 23 Apr 2026 10:27:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61C7D6B008A; Thu, 23 Apr 2026 10:27:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50B796B008C; Thu, 23 Apr 2026 10:27:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3FE446B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:27:19 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E4F9A1C00DC
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:27:18 +0000 (UTC)
X-FDA: 84690048156.19.78C91B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id C1A991C0012
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:27:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e6TbTKra;
	spf=pass (imf20.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776954437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a4QvpI4YCwccxBCFaw4KEflqvK5dlQNnQU/9NMl3BHA=;
	b=pm7gp0aTDFbV0EFOAgvt86/J8xzConKNHuF3ceXAmhhLt9JLa37Q4i3ZqVUOpknj16a6cB
	0AM4DqIgwpVdn9EP/QRLvPXThKfcO8ksCN5ExHA7++2AJ8OpGiFU6BlDAplln808XS4hHH
	sig/p/3DcMWOP3D+OS6kkNBK/NHzA4w=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e6TbTKra;
	spf=pass (imf20.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776954437; a=rsa-sha256;
	cv=none;
	b=cSsQ2JxXBd+yX8uhSbjPX3gLFKFbkXSH1zf/MuwUONlZmEtpXhkfnzagmIsL0IgTAQhysS
	NDPbGbCNf3Keb7v4ahwJDwAtr2SpHAqRTD14/iXMFIdQZqh2Un4D0vCrFPXIL130q2mHVH
	ps62vY/shTqRWcIJsIeUXBJWPHuYwO8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A67F9405B2;
	Thu, 23 Apr 2026 14:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6772C2BCB5;
	Thu, 23 Apr 2026 14:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776954435;
	bh=ZAmfY2GvQu1V+jZW4Q7JR569GmwjElVH8qZhAxn7gDY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e6TbTKraQPr2vhcn+/z0+5leztca56h0cv39qFusb+C5AJl8cN+xFr53pEzXrl7pO
	 FNmKh3LOG2clnXKHBI8F222Yio7XScD3a43RVx/n3tJ9XGzR4mjQ4TTD6iuaThzWtE
	 wpa5wS6kQJDL/h98SLKgFizRFTYVs7rKqLiAcNNRU2PO+NpiIZIVHYr6WkoFN2zom5
	 fsxXGaVcEQ74oL+gHP75vzCvYzR/5EBk9fTjttJBbr6aDmbe87Jl/CMXPDs9mGX8++
	 jswsFmZXl098tfmybnEoYEkIHe4RreFfzVUjH/4B+mLb9V37UOxx/5J2vC1g9Bt+/W
	 Tf/yzrurTzr1g==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id E0313F40069;
	Thu, 23 Apr 2026 10:27:13 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Thu, 23 Apr 2026 10:27:13 -0400
X-ME-Sender: <xms:QSzqaTPm8wdWHwg2j0DX5hhDMnOfiwy16200E9LcT2a7ngV41L6iKA>
    <xme:QSzqadN2q1OZDI4SZQ8lZ99xkTM8WvVWTyFq5CdRvHHab2n1uHXdI_G-dMBjghpeB
    hhmnZK464FHunZQ5pEnCb6KM_sOgA1LYnIzeeasj87DkJCffe4pEeQ>
X-ME-Received: <xmr:QSzqaee-p29QqJ5pFCrwyGPW8nAnHKMf6TwYv5WQJhLA-T_2pteoRNRTJaRtTA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeijeeflecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:QSzqaScL1Sq18Ji3k7GR_C3kYOIwTh1a0PFju3Qj78BeO_ZPzl8elg>
    <xmx:QSzqaed187upZan3EjNy-LSBhaiFnb-MTjyNu9LUKy0oKQbHpoCdFg>
    <xmx:QSzqaTncyeMNfJ5ALD2DgO1g9Z-J-RxHSdEobw-ymjklGofzD8KSKg>
    <xmx:QSzqaY4AC_jLQKdRVHNzF20QADvHSu1BYwjzDWXX1FfophAEYFJl9g>
    <xmx:QSzqaTsYgpmlo_KX0645hdFuasUQnZhIXzPDXmrnjsJXqvD9u2A14MHU>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Apr 2026 10:27:13 -0400 (EDT)
Date: Thu, 23 Apr 2026 15:27:11 +0100
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
Message-ID: <aeorZMvKwu8zKX5i@thinkstation>
References: <ad50rPOseVa-SP_s@thinkstation>
 <aeDoqFWPFxkkNB26@thinkstation>
 <1a499781-1115-44bc-adbf-2ac3769354ca@kernel.org>
 <aeFCuLJXT8VOkzH7@thinkstation>
 <4c635703-3d8d-4cfa-bb98-7f6f5fcbe547@kernel.org>
 <aeImfRrrvr3UoKtL@thinkstation>
 <aeTnlQUOOh-dHG8z@thinkstation>
 <34f75083-29a3-4860-8a6e-94551d37ac6a@kernel.org>
 <aed6fHLrIdahbdY3@thinkstation>
 <b77d559b-215e-460a-a268-e63b8273ef42@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b77d559b-215e-460a-a268-e63b8273ef42@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C1A991C0012
X-Stat-Signature: u8tac65ct4o4911op7fd9xp67hzoqx47
X-Rspam-User: 
X-HE-Tag: 1776954436-144497
X-HE-Meta: U2FsdGVkX18KgX8JAwRc7d1wr4WQe1LYIgRbS1bujBOEZKxN+iqY2FwxgpnzVr8ajVAjvCI8z1tWMyJ724h5TohWDUBplRBffVnkpTXTvuhVRM/uxuOWz5md1H4nJScxvcFMQN9iB68pwK6PYg6JGWClBjPPMiLBqMrNKMve1FB7QjZYJl1CwUNBEhtYQGG2ryV2mpXDZTut0VfPC8KIg5d2QTkGbdYHfAhUogzuODCDPNvvpQynP4Uk5+ydt1tdxetoOJ98OCVDIx5PzR1qSnJvANvOzcFlwJwr7tIHIPZCLWtgbMU/PqBjHpySd8duRMiXitEEjk0pRNzDvuoD3WD8xsCns1r/NOJRaetMpkB4Ao3gM5m7ajH0cvHxPq92f+DXR827960xT7UjyzB3Atv6YhE7ENIRQhkUHzrM7J6WujJFSW0FuXA6anv+z/M+JBWouEmeG5gVWF2drEk6cqCkelOzNR9UUEhPF8HzwguzvzQp+HBnKjTbOTIw03QjrJxCre6MyJwsOi4PknXEeuV/lDLkAffA4lkykWQUbNE/u0xquTPkw/itSPygkGfhvjhuy85Sra7A9pQ0r9jBDftAyYRIA7r8JHKWS0foslAApruIx5TxOfAIVr4ILQ6ubdFQklUgTkaXPFvrMqMrVXjDh647L30o8+JB5tqaBRsbWJs2lWvI7LNXdsAAZoI/9eIzRhj86ZBc8BgJ4hkWkhpMr3ZKIZIL5Ankgbd663j4P2O0QAeXw6XGBA85dlbnUUi7K/585iBFXbhjcR8UrD08NBwtKhXndJqIwTgTl2qOZBSmbFCH047SjbWF8MFonI5buHVuSQQBxoEPP8AZuFPN9mLXtvcDD3R8ASinErDP7lvwtaKNQH2fMKkL9dYZx/VfUsFzA9ZSq7ZRev2bBFZlOegd6UnJFVc3ZQ6MAruBBvz5iQm4H3LvIo4AFu6winNIMTDt06S6rQjr9va
 hCaLIHey
 INHuXWB+X4mU64Cgh4gBeGiVqRNLNFX/ubYEKQ9DhEcAqB7GyzkDLCI0L+6SPuIU2U0fdaHeGvcyHTly17anE6rLyqNpGO5lPZvf1FPxqKpucxV2wI4BpBGDpfrHLFPeGmlXECcshvKLk7wPMIgdmu5ujYoXzvkIqlTJDrvasCCAw4JQZsbLcHy2IfteImOpD43cPiyyVLok5CqQ8fkD21E8hoR6/PK6eSAj+JgPXX6CKvzP/Luf2I6vi5mXHdnWnmSVJ01pSYF9N4HV7P9rhpQOEJ1vddrSaSh8LAapehq78RmM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 08:39:50PM +0200, David Hildenbrand (Arm) wrote:
> On 4/21/26 16:33, Kiryl Shutsemau wrote:
> > On Tue, Apr 21, 2026 at 03:03:56PM +0200, David Hildenbrand (Arm) wrote:
> >> On 4/19/26 16:33, Kiryl Shutsemau wrote:
> >>>
> >>> See https://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git uffd/rfc-v3
> >>>

RFCv4 addresses all your feedback plus more :)

https://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git uffd/rfc-v4

Still plan to post it after v7.1-rc1 (unless you want it earlier).

The patchet is pretty good shape in my eyes and will probably drop RFC
tag.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

