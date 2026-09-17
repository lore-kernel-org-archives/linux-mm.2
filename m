Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA6A6C982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 04:09:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6B1A6B00A5; Thu, 17 Sep 2026 00:09:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1C646B00A6; Thu, 17 Sep 2026 00:09:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B333D6B00A7; Thu, 17 Sep 2026 00:09:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 934B46B00A5
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:09:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 25B8C1401F2
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:09:10 +0000 (UTC)
X-FDA: 85221924060.03.138E860
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1B313180002
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:09:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HAHadbtU;
	spf=pass (imf24.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789618148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MaOGTKqs4zCtYD2EtLkk0CPkV3ZOn17wZw1VeEEVBTA=;
	b=hzuI8l60E0kyzfvMbE8yP3SIiRfyOjy0mjJX89KQ350aKpeA8AsWjhIpHYAFdUIcW13v2m
	bZ8dgghdO15A4nVjvLM0GkOuVTjMwVOrD2cSnnNmEVsxVrXfhRZu9isIh1SxRE0R7AdImF
	SxY4bWSOrpgWjqLbaoS4A3aaBzMQ5Mo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789618148;
	b=FKMTWUqhadvEox+S5VmNzDTAGnucw6rFq1Q+6Onko5i2wEXiS/IU4hunmaA2bjdLNUR+q4
	d1buNHhxr5qJFYCMGooYonqp4M8mmd8YoJx4HCoo4K1TryZfs2Oo1QvQ0G5OLqULv7mTKF
	jIKRGgkjTFApnlyYySpxRHbM4R1Gt0U=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HAHadbtU;
	spf=pass (imf24.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BDD791476;
	Wed, 16 Sep 2026 21:09:03 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 912E13F882;
	Wed, 16 Sep 2026 21:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789618147; bh=5GXteUxX4b4RFIQjbUzEzoICCQe6hAeor7DxccEGQU4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HAHadbtUWor+UPPD2El1Ab1cLvu9Izc8++N5S4s7CeE7KFBgmGEZXWsnXfIuWP4Mv
	 HAc+BNzsQF5s88XfpBnGVobDPR0JDXHHP72RfKJDuZ8wxOXfQO4WHUOU6lXIN9UU+Y
	 +Bi0DzCzabD1DvTrF3pC9rUTS22Ux+BhRv3HIZDc=
Date: Thu, 17 Sep 2026 09:39:03 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V2 05/14] arm64/mm: Override read-write accessors for
 vm_page_prot
Message-ID: <gyb53u42u6klaqvkqdzsqjp6tzjrywnfi6ceg4a2p7nxftbll2@wi7i7sytr46a>
References: <20260907035030.2839978-1-anshuman.khandual@arm.com>
 <20260907035030.2839978-6-anshuman.khandual@arm.com>
 <51993407-083f-45b7-990b-105a0c08a5a0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51993407-083f-45b7-990b-105a0c08a5a0@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1B313180002
X-Stat-Signature: 9eiyg4fqrffr16sxg13srkwgw9jf8p83
X-Rspam-User: 
X-HE-Tag: 1789618147-690836
X-HE-Meta: U2FsdGVkX1+yLED2Xhi95vCzPSsgfmwBbTMWPy1ZBwRxtbpo3aXPsE1j3RArQhqIEX0cTk6ukKHquP7XrAOTW787t/PFUrG6bTcZhV7LeCbVaFiHF5DKHuBi2cT8q82kNakc7aZu87N4OcKeBmIGafmGPwr1tVSAkp+gVdIsULxmtb67/wcDGIRUET8DITzkSHly0zcDa+FqPXTWiCmlKrrwyUa9mj9WXMSByia+75M1ypfZVY0J61169KIZ0Kw8hIycF+aTnxnAZllQ19WUCpjmFd8WLv7K3jw+Tc+IcKAeFV83T4A7dv7FCPuG2m0aC82kA0prULmJ2QVcNP66n/ZMk+Hf3TY0xgqj417lE9+IvTTE121tmp1b8mdRcqNScjBzaYlAgvvRsG0McBr9USmWsTxg8TAOhWneZZ2DfDVXyz935rnDwgwSxMtYWuEg2oMDDha7RjBhwnJh7fuwFf669aUNOrK15nw5PJzb0RY5lepTviKP8B1gtNaV2e7z0D+Dp6CRhZSOuqeDGSaL09aOoonOSnb4KGB89vc+UZ04tXWknGFx7j6BcP4P3SYVjTRJKoCV9ijDKnJ88fwiGMxR+oYGtRDAofPdcKGmIBZB+Wqu0f6wriTgQwQmkrPPBG0E9WFZaDXZDvThfxcjsFULcN/hjPJhhN6DB2f4oQqGYumy3lLb3fKrgx16GG82Ptt3QFO02UQkB0P8qa+fAAW5JvIpZ7N2+/oCql8qLF0VcFkNGbe2bF6nSCZyJJyCr6N6kW1AvQ/FE2QqlTu0cLfdiam0XWbIAisOTSXHRfrM+Wc6SMrCgoEjKqjQwp2eLXTELJEbcqNqVt97qy07XKQiwNPHPka3ppCXYBdwh58tr+vIIpGu43srqKE2O8iF30jw6a+TUu7lNlq1yeV7QeO4QmrJ41OpG3p/5E0Yb1xI83xvlklZNSPekSkdowZVzbu0TuJQefSZmToAI3r
 E5+KbGNV
 ISaWMUEiyEado1SH0jC2Xbpx6zfmmdJnqvvpL9QG9FsV1tH7N2z5volNaPAx8YoCv8t9R0OlN4s7m+XzFvl+jEr8Fvo1ImWRngCM8H11juS7MguayR30CWJe0eGHSgmD5H3csgN/SsRJ58bYxN8Q3eDntb5XpfJbcI6W4xgH3ZBsc0Kx08L7QTGVhbrEXFZDhy7YEQiYno93gzrqChLbWcdT0Y801n8b21lVXQcyAmZnKS+j78S/AYunogySvzm65wYwCCfR2/Vc/ij26iNW3j8dCkh1fI4xp+VBzJeAqQOUyFIvQum8cekPnkK3kEnbUBl/AUntpe8dkgHyhyc/UZW1CGXrrQRUWKCEVvm5RspMtZ9uY3Eli057loscmnduq2v2yXbfpEun/EvQ8DQcCaoOewIDD0BdaVgFNb32uUp+fwak/7slV9yRpeAlNyC6jMgCW6rTwUANxnBtPGAyTKcWT2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 03:39:31PM +0200, David Hildenbrand (Arm) wrote:
> On 9/7/26 05:50, Anshuman Khandual wrote:
> > Override pgprot_[read|write]() accessors using ptval_[get|set]() providing
> > required single copy atomic operation for vma->vm_page_prot.
> > 
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Will Deacon <will@kernel.org>
> > Cc: Ryan Roberts <ryan.roberts@arm.com>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > ---
> >  arch/arm64/include/asm/pgtable.h | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> > 
> > diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> > index 66bf5bbe484e..2b457db19be0 100644
> > --- a/arch/arm64/include/asm/pgtable.h
> > +++ b/arch/arm64/include/asm/pgtable.h
> > @@ -122,6 +122,18 @@ static inline pgd_t pgdp_get(pgd_t *pgdp)
> >  	return ptval_get(*pgdp);
> >  }
> >  
> > +#define pgprot_read pgprot_read
> > +static inline pgprot_t pgprot_read(pgprot_t *prot)
> > +{
> > +	return ptval_get(*prot);
> > +}
> 
> Similarly a const pointer here.

OK - will change.

> 
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> -- 
> Cheers,
> 
> David

