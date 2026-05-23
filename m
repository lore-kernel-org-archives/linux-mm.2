Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B25F6CD5BB1
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 10:37:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC6856B0092; Sat, 23 May 2026 06:37:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9DB66B0095; Sat, 23 May 2026 06:37:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADA926B0096; Sat, 23 May 2026 06:37:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9B33F6B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 06:37:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 33F21C2D8A
	for <linux-mm@kvack.org>; Sat, 23 May 2026 10:37:46 +0000 (UTC)
X-FDA: 84798333732.03.5D4F1CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9EB2218000B
	for <linux-mm@kvack.org>; Sat, 23 May 2026 10:37:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h0DTuPMg;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779532664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=snoJupCrLvennL6uXOgnTKfm9IRgKoBXu8jeUzQitF4=;
	b=HJbioVGfhbH3eH2IGGaDBc1ch4HRVyFhpHzTH6ElwOER/3htYzgtq/i8P0eqIzNRT5pGji
	gK0XeOA66pHBgZ+IQICbGh7YyrBB5B2k+Z8aRnP1Gn1Qn8NqEMeoiCNtbFGKLujbBgVN0g
	lx73urb8o+Dquoq+qKCIVVLiMa5qFks=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779532664; a=rsa-sha256;
	cv=none;
	b=rmCLYjQmu3S+07jmPmPbwTEXXs9XrS3glUf9hCG7ZJv1dyX2nr01XZafQaBNcs4JAAYAwF
	rlx5taTcypsJYU1zzUXmnEmNqy9RRYftYXbJdPKDpuwwX0K756dYwpFjXpr9GuvuRFk8jO
	rlql0xB+7lF4YuLZV969j0gzVfYFuUo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h0DTuPMg;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1355B60136;
	Sat, 23 May 2026 10:37:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528391F000E9;
	Sat, 23 May 2026 10:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779532663;
	bh=snoJupCrLvennL6uXOgnTKfm9IRgKoBXu8jeUzQitF4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h0DTuPMgVw6ksHlRqsKdtZnAHmn75iWnceRWOcNotrmKw4hDEFmI2/KnVEeRPdQ6c
	 KcKkk6IvsHktG1+/3vB3xCzYnAD7ZWefqvPi+fdJQwylvxcvYJVzyhKNEPTnNqSxcc
	 uvTNe4fRermhbk1PE1RFRFEsDZi7BhO2RJS0gxhvKtaUo5Mu/ePY5INY860CkxoD1I
	 TBz6tBohMupfZFlw2TiQ5cWvD2hLGUrdc/2aj7PfKm3glTII1Mgq3X0jdw+fKnfHF9
	 NwXKA8cPubvWH38wPXJmN4IBhYFriKrmq+PWseVlMhu7GWnwTdbqpjMpx/opGXhcYB
	 xir9qwzGvHf1Q==
Date: Sat, 23 May 2026 13:37:32 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, peterx@redhat.com, david@kernel.org,
	ljs@kernel.org, surenb@google.com, vbabka@kernel.org,
	Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net,
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com,
	jthoughton@google.com, aarcange@redhat.com, sj@kernel.org,
	usama.arif@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
	kernel-team@meta.com, linux-man@vger.kernel.org, alx@kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: Re: [PATCH v3 15/16] userfaultfd.2: Add read-write protect mode
Message-ID: <ahGDbKr2u6sqoc3f@kernel.org>
References: <20260522133857.552279-1-kirill@shutemov.name>
 <20260522133857.552279-16-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522133857.552279-16-kirill@shutemov.name>
X-Rspamd-Server: rspam11
X-Stat-Signature: o9g4ck1t97q1ryq7yn37symz6w7qbp3a
X-Rspamd-Queue-Id: 9EB2218000B
X-Rspam-User: 
X-HE-Tag: 1779532664-9686
X-HE-Meta: U2FsdGVkX18RPLI3kiA9XXQpV/rL3LnMmyl5jKXOH1q//Ji72aV0VYeCmK/JuITt2oM+Nq/q0lP6qrRdEJLkgTJHYxxvGthbINP+cl536BExQoGGiyb2AUdms2914l/I3CDYQus+6Gf/CXGol2JE28MPl/W3FOU9OrJ+eCfQwe8sbxPGMAcgw/f5r/X/yPJ79SGHSziNp+gBAgIReVwmusA2qYSCPf2ffLRhS0vEyis+4azKb3R3iJpxRZ5DjNxiXVWgKK/X9TjVJxTbhwms9C+2OTruOqf8a4Ukywx6mjxXzp+hqwADUKxvhJVWqb5CcRtm3pNwn713thN3MQqPHBB21MPMeni3z6oHDtZT+uR5d+t4ysyJv+8Vl4apOHe3EPEitasIPkWwxZhQl48pphCt2N3F8d4tplSth20RoXhUtXZ21GQC7EkEdCsHIX0haVkEBQ6UsiyksKPWLRSeDQlIoxzPRjX9e1wsx2N0x4dOZjUfh3sEmp3d++AUfzHRt+/34x5tppj2Nsrj9AgjdoUAhghI9hYS3LGrVQ9y9vbc/Vzos6GQf7cE8wq9C077SWU4ZZHoYKmVGIlcWTvHKaXFC/LC6LZWxdH7CYsYFiDjfDiQsQfp2xGuZJ5H7HwlsK0NujfmzkBPpON+XqBKdCQledM4jnyyrHB2i9k9fwhkTIqFIPZl2Bcs6V/ZV5Gs18wJBzQAeTpM3hbjjdxc9QP35BbEAAcTKnVp7WgXN70eS4aWI2f/E9r8H89+xyahzeq9zjDWoZ7Ck+8qOpiSk9j1T0le6EfG6VMUvzlEa/jGRMcTfb+0wdwfL0Ul2yBemVG5VTpU+ogC6YJDlSrgQJ9EcLbzUEt8Y8+vplax5OZfr+9LGD4dH4mzl0qngqpr0k6Vh/xL9ls2DIBGrrB0bW6WIH8TP/kIzcZnoZPyuiYs67WzvYihbnCb3Df+9Gicj+GBw++FDb+g2ziWmcN
 4Cn1qtjP
 Ucc2/z3tC8ddxbRIro7y47KfqPOTlfxDBhu20qKdK4JMHDmVBjmJUSiR4OMK1adsGrUy1H3QTfrbByNLTysSTZoZ+QnVrknRXXp8PMtnjTXqjzEJ70z1sOf4ZpMgJa606HP3i94XRMuHW5S5T0Zpr/9Os1X/4fIqrxBVn/XG2GyDooUDldqjtjZO9LG84ZZ5GGyV5SLlp5f7VIvl0adl2hpSYCf/8gQb8cTaIiSMiXW+ibdaBOMsgQzVVpjlzcFw+Z+pzyb1KtjIl0Y1pQh7yK1AB5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 02:38:56PM +0100, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> Read-write protect mode (UFFDIO_REGISTER_MODE_RWP) is supported starting
> from Linux 7.2. It traps every access -- read or write -- to a present
> page within a registered range. The matching UAPI consists of:
> 
>   - UFFDIO_REGISTER_MODE_RWP   registration-mode bit
>   - UFFD_FEATURE_RWP           capability bit
>   - UFFD_FEATURE_RWP_ASYNC     async (in-kernel) fault resolution
>   - UFFDIO_RWPROTECT           install / remove RWP on a range
>   - UFFDIO_SET_MODE            runtime sync/async toggle
>   - UFFD_PAGEFAULT_FLAG_RWP    new pagefault.flags bit
> 
> Document the new registration-mode entry, the "Userfaultfd read-write
> protect mode" section, the new pagefault flag, and a VERSIONS line.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---
>  man2/userfaultfd.2 | 147 ++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 146 insertions(+), 1 deletion(-)

This doesn't apply to the current man-pages tree
https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git

and reading raw groff hurts eyes too much.

What linux-man tree did you use to generate those?

-- 
Sincerely yours,
Mike.

