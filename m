Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F90CD358F7
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 10:40:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8B726B0088; Thu, 29 Jan 2026 05:40:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C63816B0089; Thu, 29 Jan 2026 05:40:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6F5F6B008A; Thu, 29 Jan 2026 05:40:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A66F96B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 05:40:16 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 71E4FBC075
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 10:40:16 +0000 (UTC)
X-FDA: 84384656832.22.81653AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 60FD718000D
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 10:40:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GtCtSb3F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769683214; a=rsa-sha256;
	cv=none;
	b=TrvpG7PGI57I+mm6ZPVNz0fi+wuB2rsz0EqlfQ8COwXsbCSE+FHDfPw/q9MN5CYVdU0X1Y
	27emQh9sbTbCMp7lmGF83DalALsR4DWt0t5vEiwyEO6wbNZ0FXBiSgnIccmVb/GDNxHVLc
	KA/U78WfaXE4TMmiZkp4rGQ0SZarsso=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GtCtSb3F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769683214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YbFE5zm+nu3GWW5s24Ek6stX0OxhzY6GNJmEQg96Jmg=;
	b=aawDeriEGTCf0YObrmxvAVW9ljyMsaSPomSbKiBc8gRwb37RfL4Ef5hDoiDG6uEQFrZKwn
	5DwsLb8na1YGmASjRTaixgGFlPJrqAdLXIRgdoIvBs5LT66I451+5nq/fsDJVfOCJqJNjU
	aOrR32+o0Hno8tq1HLUHmR9mtYCz1MI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2AB7443AE3;
	Thu, 29 Jan 2026 10:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CAA5C116D0;
	Thu, 29 Jan 2026 10:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769683213;
	bh=ROiK4CJcKz2ERuSK3/5HMDVtSfo4l/Sj8AonTKI6eG8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GtCtSb3Fhv9MMWZybLqPaBrkMUrHMAs8bqLkZ00HygjH3mN5RFr/KFNUUrGGNm7GH
	 mT9CIvS1RX5uBn73PvZMRxeK6jNorIfWj7i6+mb4Nzy64y/XYQOOaIzSbzCREn9XaC
	 jbjDZ38Zw/FjVQKAtyo8bFXY6GFw+0dCXbjGye2DhxbsQrmlQ9RdRUOlAY0h9Rd+2V
	 2ieQjd/Ae7NQp8+PNAjXFCy/IY7ZSvzW343RbxPyJ3TZXgZHj+GsY+5UAVWToWIdyc
	 3CuJkctZMfgN07RKPvBT0xXQ7M+BUxfKOUKX5spSRsOy5nw0Q3eOKkdbe8SdFaXvdT
	 XRh+QHl5LYkLQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id C3C81F4007A;
	Thu, 29 Jan 2026 05:40:11 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Thu, 29 Jan 2026 05:40:11 -0500
X-ME-Sender: <xms:Czl7adizN3nfBdbdZZ7YTYb7wkpvs6dH-khtCd2eVQpWxrRXS2HXrg>
    <xme:Czl7aUVHZWDsKRTF0dvEjiHMASmN9QFc0vGfFnx4jlg_56R2WyTxQ_4vXkScY56Qc
    C_MTV-JzEgU1DWlxUO4A_XENZtWqj4sXLKcAOyP48wu8-44JDiK3Q>
X-ME-Received: <xmr:Czl7abyzlq_BB9vPdHoE6PEHW4sxCuLU7sg4lnP1WsgX87QDOJMQWOJbU8JhCg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduieehleekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfedvpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegurghvvgdrhhgrnhhsvghnsehinhhtvghlrdgtohhmpdhrtghpthhtohepphhrsh
    grmhhprghtsegrmhgurdgtohhmpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghk
    rdhorhhgpdhrtghpthhtoheplhhinhhugidqtghotghosehlihhsthhsrdhlihhnuhigrd
    guvghvpdhrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhi
    nhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepth
    hglhigsehlihhnuhhtrhhonhhigidruggvpdhrtghpthhtohepmhhinhhgohesrhgvughh
    rghtrdgtohhmpdhrtghpthhtohepsghpsegrlhhivghnkedruggv
X-ME-Proxy: <xmx:Czl7afOEIluNTssr6FgztnLEDYpyZz4XhBy6sylZN6QnoveYnhebwg>
    <xmx:Czl7aYYKurg10Z4bz8K7BC_2g3WekrT5H3wg3H2uU89odOYhupnYUg>
    <xmx:Czl7aQ6PAuT_uq9keXqSCqNwZXBhF6PLH_grgJovKe-M3WEOcwSYfQ>
    <xmx:Czl7afCS-nA8iM3BOHW9cweuItiS1UOIlu0GlrloiUVWBmVd_TxPpA>
    <xmx:Czl7af4XZW748jN_I5qNUdeZoIeHEUN5mGwCVLocYa6uSH7QPsiSI4cO>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 29 Jan 2026 05:40:09 -0500 (EST)
Date: Thu, 29 Jan 2026 10:40:04 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: "Pratik R. Sampat" <prsampat@amd.com>, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, x86@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, ardb@kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, osalvador@suse.de, thomas.lendacky@amd.com, 
	michael.roth@amd.com
Subject: Re: [PATCH v3 2/2] x86/sev: Add support to unaccept memory after
 hot-remove
Message-ID: <aXs4DTXCbI_c0JPO@thinkstation>
References: <20260128204105.508855-1-prsampat@amd.com>
 <20260128204105.508855-3-prsampat@amd.com>
 <16aa84a9-83ce-4748-bc73-ccf5cb6ce376@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16aa84a9-83ce-4748-bc73-ccf5cb6ce376@intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 60FD718000D
X-Stat-Signature: dm1i9rc9xh9ba3karx6mgzbsm6iy1poi
X-HE-Tag: 1769683214-863778
X-HE-Meta: U2FsdGVkX18mPqXzxsBNaMmyANkHQtFkzRAkiFuw1VQSNNnFimAn0pHep6ioV2SQ0+gNzmXdWavHpT6/T7FpvLms1jMBG49L8N7lWQl7xOPt0PWnqp5puMCk/Bc9Du38FjVHs9SYnO9/7lUvikPF1r92wSqxudMdRAf8lKtEbZFxR1Iii5mMAX+5AG4HTY2FEmF8LzRAzk2xqsTpDFlkadn8MjYGsbBkQGGk/I8xBDqkg07Vu/0DV/PcQl4URrI9qWOWzd4funP17WRT6CbUEoncp9aTjuKvowGX0CJswNuYbL7LaONVxRUCEf560T3XHupI86imwfibslc53ktUQMObS3GscBX2Yi+DTcj5PZPdkSlwqMsxGFUtCPO4YPt8VyqXpw1p1pCuEgEPoJhfbmyiGbtdIVSslx/CTSdnuDHE2WsJweKG+sIvs9N0IredElWhIqlmzKmqnJgo13ayjIaol3mymPY8We5j3IkYJoiR7UvSnxYmxcDVzdS7kURN0C9jdFHLbLxcBRtlu39Ht3OfpuverAaRepnDxnYmNbheiWCjw3I9nWS66r83N9GFWc+5fW7ePkDDco8NwWdvYBGatZstuonsTm7GXPihnKEyaX7mZ6KDexL/4+3GAQFVQ4lAwrh4S9huqz3Rx+QGUQtR87bNZJ3rLPrrvOdZErQzj6BT2U43wWiAVYzvnVMKVpML121MXKvDNYSRK7cI9s5fX/y+tfkSwZp1ka1+Epk1wVnvvfu8F7V3JpVNMQm955xhJQNfFUpap/eMLqPx7c36wsNIG2WDik6pJwuFhXDwoBKBTvQRU5xs24FWlbcN4Uc8nYl5SMeoriLG9PCT3JIQ2A6ETTO0ru96yjfveYd4slwCCPRycIJFOfdcivxXRyiTf4CvNM6gfuDZ1FjbHFFS8a6EaRBaC9ZRFjNXTNIGVcczT/RB07JUUVnOD3BV+0zRjCtHFbMvfG6jJHV
 vzKxY+/t
 CFzMUlly9k9fuU5i+YnPRRhu0GWb6emerOlA8+nTpO5E+yeM+9OAq5aRxqvhp8p1gu3wbrRdBdH/RKWqKeAK5fYSvkpGCuIC/0sj1QAbtFRTDebn7g+Jx/0GOBmDc+O7qdMgyEbO5QVkAX3yVOELxTPwenwDNHp8haYsqs7/OblnM1VxCW5sAiCnmwuyybrIRxMcUGN0ScSlcDZvbnG0FDcFwAL/0FTe/rx/3vYhEEj2dWAJAxdsYlQBsiTdx/t5RnWqIxv0Ovsx+aoay5sZTY5QcNQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 01:15:06PM -0800, Dave Hansen wrote:
> On 1/28/26 12:41, Pratik R. Sampat wrote:
> > +static inline void arch_unaccept_memory(phys_addr_t start, phys_addr_t end)
> > +{
> > +	if (cc_platform_has(CC_ATTR_GUEST_SEV_SNP)) {
> > +		snp_unaccept_memory(start, end);
> > +	} else {
> > +		panic("Cannot unaccept memory: unknown platform\n");
> > +	}
> > +}
> 
> This panic() is pretty nasty.
> 
> Can't we just disable memory hotplug up front if it's:
> 
> 	!cc_platform_has(CC_ATTR_GUEST_SEV_SNP)
> 
> ?

I don't understand SEV-SNP situation, but I don't think we need to do
anything on unplug for TDX. We should expect the unplugged memory to be
removed from SEPT. If VMM doesn't do this, it is effectively DoS and we
don't protect against DoS in CoCo.

Converting the memory to shared will do no good for us.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

