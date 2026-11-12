Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1A47606A330
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 13:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Ir+GhsOF
Received: by kanga.kvack.org (Postfix)
	id 175606B05B1; Thu, 12 Nov 2026 08:14:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14CA06B05B2; Thu, 12 Nov 2026 08:14:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 062F16B05BB; Thu, 12 Nov 2026 08:14:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D713F6B05B1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:14:11 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6182D160518
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:14:11 +0000 (UTC)
X-FDA: 85426510302.20.EF34707
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6D68B40005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:14:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Ir+GhsOF;
	spf=pass (imf11.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794489249;
	b=wGu3cRK+uoo72vTl0XiuGeOMW8doQsDaeTl4+/7IKY3OCcWVRt7IgfDLHNQ3nfr6grXSe/
	MooGzTpWKKbLZhpH5SjBAdEAx3toI8VHylkdJLLLQ0bgvYA7y6qrKErQ3Yy8DEdm6O789S
	U6ineE+2s4alH/JEcE5eD6Yj+W+cwiE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Ir+GhsOF;
	spf=pass (imf11.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794489249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yRd8+Huvlp5plhQTndzEeeQ6oPa/Jct92yGvLHnpzEw=;
	b=oV9jcPskK+PbkdblOrAxG1zdGtn9MNy/U4bTN/ip/0clh4pi0hq7dD5Q9nyBq0wCaYUcuk
	tHxueZtDV94udmK4GfIienzQayl1jtfZ5lw5rtd1NG5gBP3QU/j7ECW1nPuh4eMnLII/y1
	DruHalmlaIXURAEv9dEKIvqatdSmILE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5389C1576;
	Thu, 12 Nov 2026 05:14:05 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 215A13F632;
	Thu, 12 Nov 2026 05:14:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794489248; bh=w1bnY+Ps4zITYTRUimdbVrN0cNHgFPf1y5ifSbYb950=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ir+GhsOFl4eXFwGT7DY570KXtbzdF31B+5y++WKx8y5Mt8D9PCavJtunWAPhq11FQ
	 3y9F+FQeN7oJYgE6McH1/9bBfmGxPdH3wzJzX2m8BupRfTjtvOMcJ34FftvP/WD6se
	 sCtXi4bJ4nt0qiwC4fHQYnZSriQiUhYjZrdlfgEs=
Date: Thu, 12 Nov 2026 13:14:01 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>, linux-hardening@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Ard Biesheuvel <ardb+git@google.com>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>, Kees Cook <kees@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	=?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
Subject: Re: [PATCH RFC v10 07/22] arm64: Initialize POR_EL1 register on
 cpu_resume()
Message-ID: <avW7mVh-s90SdUYN@e129823.arm.com>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
 <20261109-kpkeys-v10-7-aa6c4d9603bc@arm.com>
 <be361be8-c5ad-4ff7-a6db-7b0815bfe1d0@sirena.org.uk>
 <avNH_AdvK9AqvfF7@e129823.arm.com>
 <7b92f7c8-1543-447e-8ef3-aba608141699@arm.com>
 <6808f3a6-1c12-4cb2-a109-30704d812490@sirena.org.uk>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6808f3a6-1c12-4cb2-a109-30704d812490@sirena.org.uk>
X-Stat-Signature: rd4g76cceouj7gw74f6qo959kz7nu6tr
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6D68B40005
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794489249-159964
X-HE-Meta: U2FsdGVkX1+KnBra1M6ybCsKrv2oVo0yHMae89MomB03qD8LL3AuiY03UFtFgo6/3FUmyPa4L+Jwi94xfQQVVPGAjBmYB+XQ4YVAsbmIfGw3zQg/Hgqt4/8lOiX0WRQD4fpdiEhuASQL5gIY2RTkG89UeYFUMiL67zUR5GMHgUGUpOSByl/beCElefNZ/N7YUa7cbBKcfhrUzK2ernmGWj1tBMPyCASiSAAIUXGjXEP/9HxVAJ5ocMAWQzKVDdGcONF5BDkA0jBLzB6CSW8Uzl9ORtgfd463PGNyrvHaPWaGoDkS5tgPNBvkyU1iiF4BQKpTsifNbMap3efNwH8/rEIeI91R0h4xudkurWDYAygCNow5a2n3q28v6+bZaVPq53T1DHK2aJU/tsqRvztrDXpwW9M0s4h3Y8glB9StPJJ37kgW+V2uI0/gMjRRcrw8jVB85OTGADulTem23Ih9BsVISo+VAFDQPYOiKxp6eqxHt1S9wFWPaCHaMaBdZ0cg6iSpEGyh+KspgZKnC47WFAG9AIU71EmjmTKqYMgYS7oMSuaZ5GYIMXUB21slgQMXX3TFm69roYvfuWuFL60aRknUZiDloHzLZcmSyDKA10Hv4z+6oo1Z2cxWPOgSvj879KDOxF4rQdUC/sQX3y3iFx2NsBnVjqtxda4JlCw+A+O0ACYGw1ELaNpkZXoZ4epSO8AD0MNdKlMHdVNzoqLj5nYg4IfCdoFNTGlCC2CvxTmrMJpSlKxA+KT5sxeyueV3jcxQt3WaTkxelPP8ZZ4m3vBS1Bd03G7/y+o202h8M8g6zc9HzT0jK3C8iSzs68F4yPYDwVFgxp0w58owTY+Boki4y5gKSGhPJz2pvc7J42FImobgfyzqgjg4en27LkVYjxZUDTCo/ckb4p9orm931sMMDYGrgnDsCRRLjCe/eiHAtz64bZ6wVE3WBd5SlUMmmHZxd2EEExIYM1rjtp/
 AxEFlTX2
 CsWTyAbr6mFMaSBTTLb2PEwYjsU7Z8Tq2I3OIqCLhzUc8a+hSJ6Hpms039GB5fgzs6+tiLGM5s2lFBBgy1Nz4vyt1iqsKBPItrb5ydez4+hA+6lgLV2A6yKdChUId5qkfJZStuCsoJEhMd6lUUVtus+aDDI+ObqItiXyrA4MNkvpJQPEyVzCanCHY854uursp2HgVvXqBGMNUQhx2daZH1N5kajtPUO8Z5Ue6nhA6Bh5uRTki08ZHOdiU9BETBOXNLMWSh+0jrx0Ew0OZc3h3da/nfsw8IKXhSm1Ql2UW2fhW4Hf/TNAFSXuK98xyErec0JyLD6LAMJBaZBtBHomQwgVkMDsHqyalBBmQH6X3szNiiazIykQarYtkjRsvaptyGp0Q7DwQPg2gz5U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 01:02:16PM +0000, Mark Brown wrote:
> On Thu, Nov 12, 2026 at 01:38:13PM +0100, Kevin Brodsky wrote:
> > On 10/11/2026 17:36, Yeoreum Yun wrote:
> 
> > > Thanks. seems required to isb() after initialising SYS_POR_EL1.
> 
> > Agreed (as Sashiko reported as well). Presumably that means we also need
> > an ISB after writing to POR_EL1 in cpu_enable_poe(), as that's basically
> > the same situation.
> 
> Possibly just have one before writing TCR2_EL1 rather than for each of
> the indvididual features, that's harder to mess up?

I'm not sure that's necessarily better, as we'd end up executing an isb()
even when POE or other features aren't enabled.
Wouldn't it be better to execute an isb() only when needed?

-- 
Sincerely,
Yeoreum Yun

