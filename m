Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84AE2606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NiDyh9CS
Received: by kanga.kvack.org (Postfix)
	id 6C8436B05CF; Thu, 12 Nov 2026 06:49:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69FCB6B05D2; Thu, 12 Nov 2026 06:49:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 568F96B05D3; Thu, 12 Nov 2026 06:49:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 352496B05CF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:49:10 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B880080537
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:49:09 +0000 (UTC)
X-FDA: 85426296018.23.F36AD98
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2CFA71A0005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:49:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NiDyh9CS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794484148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MKcG3X7dsKXAw4NNVjEt7ZV1vzPfMBBW0q4ysZTtxpk=;
	b=RFd6x9h5Oumnfh8yY2ZwlAMOpZAu9XZmMDX31ExnVe8rcQJqdgJ6lYGlw2IE88YR+C4Xyw
	uPo896AnzNEbZgV0MJaUiYU637WRicBMqxVfWeKKZef0zJyOPuh8YzzYJ/9eHAn8YRwvhT
	CWk+/hVCVgB8lyGfiL/E3k2TIyGQ1rQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794484148;
	b=Zd2C+1AQrh7n3rMVqXmtvurEpsMESssuYgz5bUgjf9KibvPYnugrUqaKTZvUOcjQxY1Ieb
	LherCtIh//0TAbsNS1ltSK2cOjK89m6hQQicDxBjkn0GQq/R7YBtBnOXYVzAxGYBu/x3pX
	lQAz5080YfyWfW8deZs3ceuf/+eafdI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NiDyh9CS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A11E66186E;
	Thu, 12 Nov 2026 11:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F07851F00A05;
	Thu, 12 Nov 2026 11:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794484147;
	bh=MKcG3X7dsKXAw4NNVjEt7ZV1vzPfMBBW0q4ysZTtxpk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NiDyh9CSMf4fnMa1aXCvHZxu1XNPZLF0/Dl9XempRO4DnG2Rnv4Cg3GohFO4EBFz5
	 81EpjF4nYwMtW7DcmV9HhlhPBEuZxpj9uyD4iv4l+EKqjYt1CyiVf+ASqrTv29jCn3
	 vw7Cq+OEghXqj50p1/echU8vAtiEFP2pHx3+Q4f2zoGs8RITGhiQpBM9qNWaKvF/t9
	 ziJmXqbPJb/qA9zZhB4bk4YCtqBFzsbaLaPIXeFmU1UPyBqijY4Klvc2TZ7W6n9eeT
	 xG4p1Q4rF39lKl8yaiQimmWpvUVrLuHhJOiY8tpsIULS66Q4FRARKhqorLxL8+DzQm
	 tq7vXZ+PENnMA==
Date: Thu, 12 Nov 2026 13:48:58 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: linux-mm@kvack.org, Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Larsson <andreas@gaisler.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Malin Jonsson <malin.jonsson@est.tech>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, x86@kernel.org
Subject: Re: [PATCH v2 2/6] mm: remove ARCH_NEEDS_KMAP_HIGH_GET
Message-ID: <avWnqt1E9ssKQDWt@kernel.org>
References: <20261112112528.1116405-1-arnd@kernel.org>
 <20261112112528.1116405-3-arnd@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112112528.1116405-3-arnd@kernel.org>
X-Stat-Signature: 7pcf69m4rsk31fspwmkk8k86eoghskxe
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2CFA71A0005
X-HE-Tag: 1794484148-842875
X-HE-Meta: U2FsdGVkX19eFDhmKmsygAyMQu0XYORU2gYOct93fxZ9Ogk1lsfs4PE5JMqFI8re+PUt4VDj2dN/0QqEJOb9EVZPuFzftbwxZIhxbX5chqXXqgIe1Un3IpwJcCqLhM7zTg4kwRlzUxMQW1x6TqivHWn7arweYp2u4KrgMnr9lGFcruWJL8LueTH6Qs30NbXvA2AEyste8LMIwN0o/8ZVBOh4JX8gUxsZXAa74S2m3YkzSK4brI3p+4rKwS0t0x6V3u3E2wM7q29LFWzPtzhuiJEhtaNlVdKHa9NSeJIP8ze+ji5FJ7H+frYSrP8MO2eZkqYjUE8qjzB5M5t9wVxzWcEKjWiEPtdREUzt1uhpfjBQmcggOkckC5s0PQIUfL1CoqX+w4VB3CHgt/Piaq4j6WQC8imkHXvhosqzsBH76vxLzQCjelyGpPPr/Q6OgIgFlsF/WyzRJwe4blyRQ5x2pNckembHoi4JysxPGmn43KaI3z7sCrijX2FEiXIQAX6HNfYj9/Gh2TTa9la3mvttquE4ZvpNTolj1+t6J9VYVZ42USTk6IY1I/g5RbonkqCCGi94VAYvcFJuSYUBWx43OWWFG7JGvuSzA0lVW+VlCWXGs2IWWKEvexNJ4NC7CDYRopex7c2sgOosdwx21+8W+Dp+TZOOlW1E3psGmEvjXHAhThsg8GbkLI3fh7Ss5CegB/nIbwa04v/hpaClDN2QDv9DEKmBFAT3us93zBchQMx4InhzVVgucGL33j3hma7Wq2JlsOOBh7m1kz8vPf5WnqYh5pLAuZmnJp4kFgc+nS2jR/eMFMTEM8AUN4Q3FwnzQbIfVL22JJ6SgZPXgAbOmsP6UI7XqpaJhkCdHM+JTixf4ByL7LvkJM4knvk1fXszaxGLYeWha8lpaGFYjYSHLv+OZAxmDoYjlmqjU/St10wWp5AA8izJuM1Qt55MpwMpQKyAWkjZFiL1vpqsBwp
 9L6eL/Rl
 +cYSYXfbYia2ybRew0HR/g0N5jMGSBVwQmTnMjZp07dd45XZOsn03Ru9xxygSo7YntPk3Dpt9AiqAMijI4nehNajlpnCtq2FfrE+po1xZHOMrt/g11KgwIhEFZysebQFMfjPePxvUosflmx3L6w8LDLccFUPxTlT72L5J0TfAsguvVuoNXYhLbmyKsIAmCfja/pwp/J//7Mj9ExzS/JVOxz8iER5x3mKInjwEFq8enrfNeCyt/czAHkp0+xqVd9ZDekp73kqvddGc4ZmTMgpPU8J8BLt/8v2o+wJLCwxKRHVroXfPHiKL3S56E1G5ZuefbTyU29CKyZiO8Hs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 12:25:24PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Arm has stopped setting ARCH_NEEDS_KMAP_HIGH_GET, so this
> is handled using the same wrappers across all architectures
> now, which leaves room for simplification.
> 
> Replace lock_kmap()/unlock_kmap() with open-coded spinlocks
> and drop the now empty arch_kmap_local_high_get() and
> kmap_high_unmap_local() helpers.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  mm/highmem.c | 100 ++++++---------------------------------------------
>  1 file changed, 10 insertions(+), 90 deletions(-)

Nice :)

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>


-- 
Sincerely yours,
Mike.

