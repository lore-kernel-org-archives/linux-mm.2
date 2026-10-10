Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCCB3CA6017
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 19:45:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70F5E6B0088; Sat, 10 Oct 2026 15:45:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BFAF6B008A; Sat, 10 Oct 2026 15:45:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 589126B008C; Sat, 10 Oct 2026 15:45:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 26C366B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 15:45:53 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 98C03406E7
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 19:45:52 +0000 (UTC)
X-FDA: 85307746944.25.687725D
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf24.hostedemail.com (Postfix) with ESMTP id 646F3180003
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 19:45:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=NtlXGB2z;
	spf=pass (imf24.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791661551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mXRiDOsjBGT9aPzVeIlvnBf2bqdjcsKrL2pwp5FX8u4=;
	b=uQ1O4+WPchXUDqst6qIw2hVqPPBo5jXe52/EuikxOA1YD9GOdkgIuB/aHJ97fFXhmtQlWp
	6VtRVkgmNqGJJ0LHDgzk7s/u8sGa/Uuyso3Rvc+w8Nmu/6qYbOKv8SthMcBye5nc7W/y2C
	XpWA3ArxuqpPv59ldqa+ROLKaDeQnkc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791661551;
	b=iQFr9/0S3Ui3dJN7KP+jpXjFuX1rH6L5z8GIcoxPdxcC+uhyI1fLF2p0CPVCruQ2prb/E7
	1a3j1eNjyU3YFftAVJrMkZ4y9tuKJfGjSWhKpQ3aHcqgRyrbwGmtXje4HfdYCf8QJnaXIp
	/ZQOwmNm5faqR2IMgvm7cWKDIhIhIR0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=NtlXGB2z;
	spf=pass (imf24.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 3156440E03BE;
	Sat, 10 Oct 2026 19:45:47 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id w-LaY5QRolKJ; Sat, 10 Oct 2026 19:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1791661537; bh=mXRiDOsjBGT9aPzVeIlvnBf2bqdjcsKrL2pwp5FX8u4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NtlXGB2zI1Tp8ML/9s+L4WmD4SskcKXDb7xA2UEOSjQhjmuiplx2ne1+UzlvSK3NT
	 4TQRjxp5fbh1Qu4P3EQmjqwgAEYaimfZKz9YN4dbIXJUxrOBAZ+6ye6oC8l2Ro6ae7
	 5v62SYa0b+RDzkQ6m3cfh8ytEDUSmdPAPTBcTyqug/9+d067qSWxGFIcVynen6r+oy
	 zM3qJPr0wV/w16kor8jJXnTD16rhuMRbr4vbYDkbe23/A/ywspbqOjytbUzti9Yj/N
	 dAVDNiQcrGWr5/LPJM+EFeyrGgv8jxbyXm4zkA7hYOUra98b3oDIMmCwG1PmyNdGir
	 YkodN1DzAbJFSkIlJ5wFNc0EENcGH1/hi/GHFHPWBiC+BbGtB3n6jPyx9+yuPazdAu
	 0aajcH1abQqiX9wcgIDl6d9e8FRWwFE5qdCqq2jpwHRTUVLAGlA8LwaVaaxcH8Alog
	 vP/mriUp+86o5fLsVLlpVcUR1Fq5DveHk1slS6Q+MSUhntUtqn1VhC7jbyARFK4oGt
	 ER0hAa29b4Xa7PETteud0bL4bVdoWnSoBxcSDZZV5sD6gRKGEOEPQ4ePSKhF2o6Rty
	 AobwbsvH9QoigkOB5gWmO3O+Im+8/yNBbK2IuFI/FZ2m04nqGUoeou3cAbbG11bexR
	 G94QgDodOyZJg6LVhnX5NUvo=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::3a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 87D0C40E0488;
	Sat, 10 Oct 2026 19:45:23 +0000 (UTC)
Date: Sat, 10 Oct 2026 12:45:19 -0700
From: Borislav Petkov <bp@alien8.de>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: x86@kernel.org, tglx@kernel.org, mingo@redhat.com,
	dave.hansen@linux.intel.com, hpa@zytor.com,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	corbet@lwn.net, rppt@kernel.org, blum@kernel.org, david@kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3] x86/corruption-check: Remove the BIOS memory
 corruption check feature
Message-ID: <20261010194519.GAasqVz2brXiOLegQi@fat_crate.local>
References: <20261010153604.1885381-1-luizcap@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261010153604.1885381-1-luizcap@redhat.com>
X-Rspamd-Queue-Id: 646F3180003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: re795wegazrkzhh8xzhafw981g678ybt
X-HE-Tag: 1791661550-463393
X-HE-Meta: U2FsdGVkX1/DPe7joOfHq7nWAvuJ4kQHN8UjNyL4O7npEzlFyyTGa1cYRqzqA9/iPhAHzuy6N342VjPNvd9Ss28s47VnN/1OmYpankieqCsITL93caquAFloYUxTqrEb5j7KCaYGU99XRiC1tbSlWAMmkhdJxiPll4cVAZCINTMfBqRNkGtpeIz9zglMM9dL42eTcmd/IUTIAiULvf0rWR3CsbXk0O9ywGUEN/FGf9qRFGCJ8d7XoNspkIuy7cDgAwOy4/7/5xa4rIQsB3G7jD66bYJuvGqtUL6yWGARIWfXMWvzVL3ZW3sbEhXSNBZji9p+ZIoSq+AU9qtqaKKXhOSy26Yh6trdsBLxN5xHg5A41pRZkh91kWY9ooK1/32gXEuWmzQpiocmq71u+h5AVPZKk2N7wwTqkf/aH3PFZ8uGgeDNRSRKw6wOzMkAx6Rnqk6D5107v5OTzf3PHxzot/OcW4EKn55IyeCO4690+fO/A704++TIJBuTxWCwP9slVIVXv5RnkaJh9SvkU7EERvpesnFy7N1MOE0/QLAy76edcNr98m962OiJayqNislAh3ptyPVmT1yLkCMpRyfnFkgv+wF8bzlTv/kdVkGrW6wvqOOUCGSHSZVliU5en6/SpF6OuHnwfcNJApKYsqe+vPvbWrLkKbkl8j8by0cvBlXHu4VXhcYJmPZHPDJyWGy+I2MCFo1u4fSyPrVgZN8ctCPU+BDIvdUXRgpcZ29UQ8TttoztykQywl8xlTGeEdq46t9MxJQQzQcewToIrxkB0IeDe1qKy7yw1f3OH32Z+VMyiq3hh6WDwSiQdHdjqCUv1Eh3PX91b0YbrGZp/JfotKxwXqqQZEcaB7zqN4yAcFFEvTbpPs6T9sEJp3RiEsvNBb/ghomHeuI34EyNXa7nAMcPHm0XzyHzkvRW+0hibJnP5tBHGgh02JhuGo/+MNwKlsKRQIBgnbMhYM2G1Yx
 sKBb6ypJ
 T27013BneOwlV7IYt4GPCDNvvw95VMNPwRi/HHu+BHwadLZrUGdVq17/GbUQb8PWRXDCR5pROUVVX6UNdXMbnjWmSQVczxrydnPV/1N0XPMsOnx1bDTDDi19vSw5aA0y7y1KLG9G5U3KwT/nhB4O6OBnpz783uBso+G0OcoWCXrn0AuhZJC4wnRF9AYwemdA8iytwq97mDynFwq+BQJnDCT3N47mC4sL0OgbiRIBZLr9T2TEgEriiA+MVr4lOf0t1MAt8ou39IW27NOdqL/7yjE2Qkvrme9HNF7JyH49bPP0aaNg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 10, 2026 at 11:36:04AM -0400, Luiz Capitulino wrote:
> By default, the BIOS memory corruption check works by reserving the
> first 64 KiB physical area from memblock, zeroing it and then scanning it
> periodically.
> 
> However, this functionality has been broken in its default configuration
> since v5.13 by two commits:
> 
> - Commit a799c2bd29d1 ("x86/setup: Consolidate early memory reservations").
>   Moved trim_low_memory_range() into early_reserve_memory(), which runs
>   earlier in setup_arch(), causing the first 64 KiB to be reserved (when
>   CONFIG_X86_RESERVE_LOW=64) before setup_bios_corruption_check() runs
> 
> - Commit f1d4d47c5851 ("x86/setup: Always reserve the first 1M of RAM").
>   Hardcodes the reservation of the first 64 KiB early in
>   early_reserve_memory()
> 
> It might be possible to get the default case to work by allowing
> setup_bios_corruption_check() to run first, but it's just not worth it
> given that the kernel will never access the first 64 KiB area anyway.
> 
> Lastly, note that it's possible to get the corruption check to work with
> a different region by passing memory_corruption_check_size=. However,
> the main goal of the feature was to check the first 64 KiB. Besides,
> the region picked will be almost random as setup_bios_corruption_check()
> will pick a region by size.

And?

Do I want this or should it be fixed or the first 64K are not worth it to
check or...?

That whole "rationale" is not really clear to me. Yes, it is broken,
apparently. So let's remove it but we might get it work still... So which is
it and why?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

