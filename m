Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61CF4E6B26C
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 01:15:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC2386B0088; Mon, 22 Dec 2025 20:15:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9A376B0089; Mon, 22 Dec 2025 20:15:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC7406B008A; Mon, 22 Dec 2025 20:15:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ADAB36B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 20:15:42 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D3C9139064
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 01:15:42 +0000 (UTC)
X-FDA: 84248968524.01.3E804A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7617E4000E
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 01:15:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eIMP1Niw;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766452540; a=rsa-sha256;
	cv=none;
	b=DRGTrVtLaJCS9t3F35uJ45lG016wwBPTXgsrlXv80KOKNN2WJcID7HpaZUVgYXfvAoFcIa
	NcZo1njnR5rjfoMHxbY2hjDd+4zAPLjuatO/ysrnon4yep3b21dNDFYlXCVBREJXHsip6Y
	mZ5LY3EYHdTs6K+WkQStwmnA8TiL+ko=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eIMP1Niw;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766452540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oov3NwqGnpHVSUNRnyIocOkA4cmeBEsvUSQRmZZ6VH0=;
	b=6HM59QOv14i8PHDasrlV7zizdtAiRNJdOjwFx1HT843WuUD8Xchkl0owfTdZiNGxa+kGfc
	fgi+AI/wwF6EoTXZ1mlzg/L6qdEqHjElmpJUdDuIp6Bo2qyCQ/epLONcLgfiR/vZxNRalL
	J0d6zHCL9C3dRj37PiN145XclZrSXBY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9119643A0B;
	Tue, 23 Dec 2025 01:15:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30364C4CEF1;
	Tue, 23 Dec 2025 01:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766452539;
	bh=xDVmLTygEDhiUivyIEVQB/FzyuqXmblzyK85nkTwRVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eIMP1NiwC9ryyPf1z6tHgly0uHfm3PoW4m/GhpWAcCwrdntXNVMSXPNvisaOu9v/7
	 Auz9S0mEh93P80Y+eGSrKMIZca+awGDJP6fmOCsaIZ2IksmZmsYgTOw2jDfW3h8yRa
	 RX7ILazJO+5fcZMfT2enC02zasg4zm2FzRFPvdtu6fhZScvV5YQ6Tl08N0UYUXoIHQ
	 ucWpFMENOzvzdgGmDqL64lDDK6orJ8T8Y5jnFRum+C+yQ3Ck2GlJLc7LIQ8SgjFaU+
	 nCttUBa8ViMdgi30//u78/QEJbzWGDJzU+C8aa37CH7NdNUjeMMU2pAA4arCCTCBAe
	 vaumx7pOOcFxA==
From: SeongJae Park <sj@kernel.org>
To: Chunyu Hu <chuhu@redhat.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	Luiz Capitulino <luizcap@redhat.com>
Subject: Re: [PATCH v2 1/5] selftests/mm: fix va_high_addr_switch.sh return value
Date: Mon, 22 Dec 2025 17:15:31 -0800
Message-ID: <20251223011532.4337-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aUjJ0OKZajNNoQok@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7617E4000E
X-Rspamd-Server: rspam04
X-Stat-Signature: 8rwizda1wryx93sde7p5a7hi9c91atpp
X-HE-Tag: 1766452540-640757
X-HE-Meta: U2FsdGVkX18gfy5BN9bQ7E1gIkvZdCL4FrKhBXOsW5JYrEZ+LH5J570PF+Mdwv/mdGxwyrnmeAvXPlUqKdiF7Tg4M6Ii0+06b+4wOpF7v02dBTJ8YbVoDYoB9hZn5kiiKpz8FF5OPdGeZ/VNAqt+D7gc2XimFCUSIKMqqxW9nb0cICyZlcBhRUE1tcEvPOd2+e/iKV/6T9OBkqIg64QaeBTZ6+Tdv+vNdcfK0PhuBx9BwjbRpjMU454TwYaEy2+1OQnfGD+qrTzKZIE4cK3X0hMBWoo9HOGy1t3A7nY4uCmVKa39YhyNlz+j3kHh+Wn/rTiMk+fmzV1jDJG8jVc5NCRGHfFJ4NaK5meCRcthscOlEznOkt9s2FMItM3+nUHJ7kOu3HTOH3mEcpfXY1H1fYVYtWmPfy08vThMR4VMFD8VKzSEvskgcUy9BdFQf72Vk7yulQJucwR/XTrJBXudRgDdszUZEahTkh9bY0nw+bzkoxLpCJbLnnb80kebbD35CL4Xh2Tn6FlPl6K9kkB22Z9dDmXtrVloRMSv3fFzbB3eoJabgCPoP95i366IiBEJ9huxPtfqs9QFFilz+98OFEUrwyy+nHFhtnd+OTX+nWq3hiCrrcqWZjHv2KGJhztjo0s8WKABGHsqVA37/POGvrXl2GtBBjnZkHMJ+oqDB0Qf++NZ+93adNv5z4YFLGYUwnI5bZYQSoqR0iOmyZBZtpw3pxO/R9q71cbLzk3m+AKH6GErSq4GLwhyx+osyVWMmHYbitUKrchJRQzPkeYEGyxPEJd3x/MvlrmzEKij113fDl+dAHJGcERjWaRYxw3mUli0bC16gxwgzIrKLPtVmEm07FJgPH1gP6YXbYcMgASsJ+RpKKy8kICLe1NWYSDmkBeXpbC1BLvOMNKw3wtLRrRutyBHEsz2tSF8+DjBBlrNP5txc9sxVdB2KGkIBzI4rwl5Se93PecXhcxfK/r
 Tl6aYaOQ
 xuuiqY/7KRDdxTpgH0K3p97SRc3FPiHHbWVrTMxcKgj1e7L4Dmexm5ABJ15mCpegCkwvyIm7gztpCenEZk6Lzn9hVVt0yZJzBh/XazrzZ2e1ZE4hjXNYlHIkzbnFQhHP3qzN/ijGSSRf+bvCUEK4PuwqRi+SWX9O4Gd3SiCkVVgS8zicxpwoiA/Pwzd+5frqh5sw8uQELB99fE4eFV4HkztsoD8ss2rWK6bNDBq1hwdj94+NPin761CrbrLeDobJJb4V0A09SRJF4p4cYkKsd/krPEQOcpwMHAR4C0uUlXnbuS3nobsTJyGpja502zrSMoIfL2/9Mcu1YS/tzqTZIUMAhKTV+kj0h0mYbinwg3iUlbb4ojqqU8CrobCwGJMmnOznVg43tq0i0RDk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Dec 2025 12:32:16 +0800 Chunyu Hu <chuhu@redhat.com> wrote:

> On Sun, Dec 21, 2025 at 10:57:09AM -0800, Andrew Morton wrote:
> > On Sun, 21 Dec 2025 12:00:21 +0800 Chunyu Hu <chuhu@redhat.com> wrote:
[...]
> > > According to the doc below, I don't add the cover letter, not sure if cover
> > > letter is preferred, and if that's the case, the doc need an update.
> > 
> > Funnily enough, your series was in the exact format which I use when
> > committing patch series.  Usually people put the cover letter in a
> > separate [0/N] email and I move that into the [1/N] patch's changelog,
> > as you've done here.
> 
> yes, I see cover-letter is the actualy way people is using and looks
> like I did some of your work putting that cover letter into the first
> patch. I think I'll add cover-letter in the future.
> 
> 
> > 
> > > https://www.ozlabs.org/~akpm/stuff/tpp.txt
> > 
> > God does that still exist?  Pretty soon it will be able to legally
> > drink in bars.
> > 
> > I think its content got absorbed into a Documentation/ file a long time
> > ago!
> 
> I happened to open it before I submitting my patch, and wanted to know 
> what would happen if I follow that. And it looks like cover letter has
> become the actual convention.

I think you could use
Documentation/process/submitting-patches.rst instead.  The html version is also
available at
https://origin.kernel.org/doc/html/latest/process/submitting-patches.html


Thanks,
SJ

[...]

