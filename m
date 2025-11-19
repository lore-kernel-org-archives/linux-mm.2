Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4007ECF318E
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 10:53:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE2966B009D; Wed, 19 Nov 2025 05:53:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E75146B00A9; Wed, 19 Nov 2025 05:53:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C975A6B00AA; Wed, 19 Nov 2025 05:53:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AE47C6B009D
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 05:53:25 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 70EEBB95F3
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:53:25 +0000 (UTC)
X-FDA: 84127045170.11.67A9627
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8248A140006
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:53:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Lpm+tBdg;
	spf=pass (imf09.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763549603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UbaTxM8K+qH7teMYwPR3OZKMippN4tClrwN1jvI0Nmk=;
	b=6j+hjYdS2VpyQJDvc705LnC1WG1ezmerqRj8+3UcgioHOSqg+fA3JfEqY5T63bUXmlEc84
	3yITR2a+L4OzWFWYF160dfWOSAdyICL4RmPDRiqI33/+i6T56YbhsloCOta74uHvc6QhzP
	ydFW48xvowhY0tDDdrElijBXtTm2Vmc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763549603; a=rsa-sha256;
	cv=none;
	b=LcWlSS5yCf2hRasSECyotPIK8LlZZBL0AfrTMq3CttNJBYjevdeGaiGt1Q92IebuE9Cxf5
	14nCYhfcPr/n5ufT1pl8wa6UVG0aOeVqzd8QNBl3eHLYq409S46MGnfhcFBL2/rjuqoqEa
	Ax8hzkJLrkyubpj+U/oqrB5oLMNXQdk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Lpm+tBdg;
	spf=pass (imf09.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1763549600;
	bh=OVN9x4WgQ9m7z3f5WptXRb3qzxmysTsrjNlqQXMZZZ8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Lpm+tBdgrzPU5GVCnn9ToOep2ZOC7SNAXx8S0f0YKrKlSbl4YBCjr+lMYe7GaojB6
	 ZkcK4eaU1fBUOeoy594HQdhTlsMki5Mo/y2fNCH2SGgwFATTNH2EeZhzfPZw7CnAGg
	 1Y9+DPF4MTdNWXKoh4nikx8Om04kgUA9wEENT05E/UlMHTCyheEFo3mmr8mCRxMstt
	 DC6bRItrznOyDYOPfDAKOGODMOViqIQgUb9mXRnf1pngIfnUU5RN4wxG2+1UIaXc8j
	 FTWzXXYmC8W6XcQsyfbY5b/C3eruf/BfZmpA5vKoGbH1HT5OGOOY0Pw/nkGlH1ztMw
	 ufS5/OZrHyExQ==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id E9EBC17E0364;
	Wed, 19 Nov 2025 11:53:19 +0100 (CET)
Date: Wed, 19 Nov 2025 11:53:16 +0100
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Daniel Almeida <daniel.almeida@collabora.com>
Cc: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>, Will
 Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo
 <gary@garyguo.net>, =?UTF-8?B?QmrDtnJu?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Andreas
 Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, Danilo
 Krummrich <dakr@kernel.org>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
 <robin.murphy@arm.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam
 R. Howlett" <Liam.Howlett@oracle.com>, Asahi Lina
 <lina+kernel@asahilina.net>, linux-kernel@vger.kernel.org,
 rust-for-linux@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH v3] io: add io_pgtable abstraction
Message-ID: <20251119115316.5de0239a@fedora>
In-Reply-To: <8A5C6836-992B-477A-A77C-EE0736166552@collabora.com>
References: <20251112-io-pgtable-v3-1-b00c2e6b951a@google.com>
	<8A5C6836-992B-477A-A77C-EE0736166552@collabora.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: it84mgzfcn6dgx563ibpgocw9bjro84r
X-Rspam-User: 
X-Rspamd-Queue-Id: 8248A140006
X-Rspamd-Server: rspam01
X-HE-Tag: 1763549603-693143
X-HE-Meta: U2FsdGVkX1/b8KMYvLkkbUx9EDmUn4PuoVFjth01TXjkqg98Q6T1MMX+SwcrvDvhsrF3c5SWg8mkSTY6R7UY57VhoPeaaM6ExDbAxOu4Yda1bZB99wA81do3DkMQySjt/dkLjlVk2SBEltQ4BLUAYsgEfF8QCao6hqwAHriHJJgRD+z10jmwdPv0kNSy6HajKE55fnXR0S4LT6uGvcdjMisBOc95QBTlNMUSz315iDJ6FIEGwq9hyYxKCOTVMYVJtEv3qNNXmQ1oTEzwqHcSQOzDldg/sadjZAXFb3ERZKeol2Bwpverbz1qLr/Y1C12ej+rMpckMl5/AkK0ITtbFiUuekXqlWpAR8FytzP41mddGj0yHL7hYA3SMNa/L/T0y5eRHiGzEaMO8rHsb+7Q2P2Kjb5cGynVPK3CHhjgLuvTao0aRbqApuwsq8fdwUa8fj2GSl8mHx48JSiMLvBn5z6XF4iB5aRh+zVavU+TSjhuOGS1xH3QNcWR5n4lqTZfu624FuQjmVZRAhdYy9OPHa98D+kwXGSPG577e/bZ1nYjyNOr1owB9ys8VefloE75Z3RS6H1xJ4sXoT06VqUKoihBZPlVRs2aCI5ZPbzvcvmIj3Dpi1hjrAUDrCtefDfHxpKgF135WjFHotUQgzV9QtUtF9DbLPEzpnR9nOtNUhymdjOFCD2/DtkyixXlJrRIjDe2CMJS4+bVkQVKfIz0F1R0tVdJ4AOEkTPCr23884j2HazJmb8UNCZjyWN31R3WQoDotAFY6rLpsqylnb9zEyPMtg+HFwBV+OyUDtsDkmRvre1S119aODjmZ7FdRy5PwFAm6ONXbDtqPhVKLyMWPMEqMLVQ9aWCm41SlV+ICqlcIAcFLeoHCeId+krhy5CcnjuCiF3wdCbIiSlRPCJC9w9WMGNxe92Pu/YBfPBQL8Exi6g41QMD0VG8E/zaHLb2c/B9SA8uWXwxh61bSnt
 Dz+x75FT
 D8OSJdymSduEJhi/UVOz/HVkBFTcIxHAZV4c8lpmSql/ngsgPAWIIFGtIc/GVz/jP0ujB4zbdAVEKXkJNt/Su4KczKdfOEa/GGv+1dswq+0/iEb4kuHz0LFxep5I+11kp+mHMPldFQNUEsMmvyDo4dfui4lYzEOVU6R4iHnLrp2ryVybnFwx8iyBYZXpNmhLtM0+3AcEGZCugA0HemX3oiFgooCXh1RvtdDqi+mm1xcW6cLH6SLet18QNb4UzSWMSrg72AVpPc4yreIVatMDIHoFChlvmb98hLYQefR/xoZ6XHCsJdscfUrN1fPQ9cqJHdPaDL8JF4CYGpJ5p4sLq6Q4/DBWg8QxhBRkG0k06qzpvHUyWUIFEpqU9N6BVrjhztpxcnxYXl6u4CEjxBfQOVxu0JPvKZYwRb9fEHa4D2wFRfIVRub0l1D9Sc0cHYUDTtBmDsrqrBIaNNoBSS+2286iIujAN8qVQIsMsSRFot5qWzoTCjtwhWtDsOw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 12 Nov 2025 09:57:09 -0300
Daniel Almeida <daniel.almeida@collabora.com> wrote:

> > +    /// Unmap a range of virtually contiguous pages of the same size.
> > +    ///
> > +    /// # Safety
> > +    ///
> > +    /// This page table must contain a mapping at `iova` that consists=
 of exactly `pgcount` pages
> > +    /// of size `pgsize`. =20
>=20
> Same here. I don=E2=80=99t think the above is necessarily a requirement.

It's not, indeed, the returned size will tell you how much was unmapped
if there's less to unmap, or the region has holes.

