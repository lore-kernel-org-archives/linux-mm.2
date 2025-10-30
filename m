Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86037CCF9EE
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 00:18:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D411C8E011E; Wed, 29 Oct 2025 20:18:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF1228E0106; Wed, 29 Oct 2025 20:18:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C082A8E011E; Wed, 29 Oct 2025 20:18:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B0C708E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:18:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7C1B0C03D8
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 00:18:35 +0000 (UTC)
X-FDA: 84052869390.08.8B3BE9F
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8EB4A180002
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 00:18:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=biKZ3Pik;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf24.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761783513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rJdGVM0fYYqCu8kyXIu2/exDMrXk9NdMp/cEW7NMUwk=;
	b=7H8X22ni7fu3Jmltd1kBZbt30cjbXsugV4zlzMcoeYze0GXY6Zbylxf45ojmThw7wvpoOA
	Yz33BXBcNmehrchk13BDS4/4S6C4MnOotHpxM68LXSfgWRDXBr++DJKoSza9flvlJNJuAN
	ZeFnbYDcCJWxBdhjIrC7NpdeXILioP4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761783513; a=rsa-sha256;
	cv=none;
	b=tiis4EG64O73TTbAMlVtdSTzhiERuEXZI9yml53zW17LsIoV5AWkWuUwK13Kw8X+9ip6Ai
	KKm3VKzqsnhLRghhkC5+NpXQ67Z+N6D7IAZgu2P13Q8BulsYPyyhd187fSIGQdJ/uViYr9
	pOTgoIq6CP/ehxnWhC3auCPF07GFXGs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=biKZ3Pik;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf24.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id B0CC840E021B;
	Thu, 30 Oct 2025 00:18:29 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id bnZK0vyu0ec0; Thu, 30 Oct 2025 00:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1761783506; bh=rJdGVM0fYYqCu8kyXIu2/exDMrXk9NdMp/cEW7NMUwk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=biKZ3PikxiXLQerqs7qYrIk+pNR93sJWyjuo6Vv35tOUOPkiLokFiljgpGyF9xu7n
	 Z4AobkdonPebY40hAQFwfqgap4wFewUVVy1hKv2h1MrUnhl2+xWQrVobjX/zqeaKb1
	 Bry2VjIC8bAumfInaRJeTcJKSMTrSRQ1DHcRn0LAitr6eKbwc/zHmoruPUcuWhp7MF
	 TSTMs6kibpbGsfZ8busx88FRdYV/HwJTynW+E4A6dEgka50joT0HvIMZvRj/cZGKC8
	 Y+yYVXxKLGCAGE3w+6vwbQR1fYlw1iwUQoJiRW6JTB0awQIhuh25Dly3+sHUkrIfd8
	 SNgLdpEVj8ABGjE3vtu9y/0JlNcPZ7NXtFn19v6MF81Gr1Mb78u5vTmOIIvs16oagQ
	 OoJEFlGiVBf7uZ7lEdCkX3gbGqMJdlGKTkLXFw3yoXTcAKR+MhaQLWuIT/Nc1M8vGE
	 WZJX8cWShuS7CSEt2W/Z6Yd7qEHx7QaAqOZvwbloKvVqlEJQuxAKy8w5mwGfHq1NzR
	 N46UzysEesoHgf7RpR04sJGu0yK7iycC+zhJ1HKeqjuySLgs97f+0JAyHbWpd21iDF
	 Ni+65uamXB+T6N6BwqQBINBm/pKbfrS8JHZS7RxGZ6SVlTW/u+UunZTcSXESPF/XDl
	 /wjz/fHhsAOmBLYy3mHCXk3w=
Received: from zn.tnic (pd9530da1.dip0.t-ipconnect.de [217.83.13.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id F1EE040E0200;
	Thu, 30 Oct 2025 00:18:06 +0000 (UTC)
Date: Thu, 30 Oct 2025 01:17:59 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	akpm@linux-foundation.org, david@redhat.com,
	dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
	mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
	acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
	willy@infradead.org, raghavendra.kt@amd.com,
	boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v8 4/7] x86/mm: Simplify clear_page_*
Message-ID: <20251030001759.GDaQKut2wDtopc0qn6@fat_crate.local>
References: <20251027202109.678022-1-ankur.a.arora@oracle.com>
 <20251027202109.678022-5-ankur.a.arora@oracle.com>
 <20251028133648.GAaQDG8PfOwrSiHYuk@fat_crate.local>
 <87ikfxguhd.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87ikfxguhd.fsf@oracle.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: jugtcqszym78yopjgtquz45t5ewffggz
X-Rspam-User: 
X-Rspamd-Queue-Id: 8EB4A180002
X-HE-Tag: 1761783513-241678
X-HE-Meta: U2FsdGVkX18LX225gUl+g+qQAH0xK5/5nixs9POODO3dSXQj4Ib5NZcUJ0RNDqQHi4jb3ZsxevAW9bVEFq90sNq35+hzqthwSFQymtbLzHif2MQwIsfmVSL/F94s+Bx2cytUNxarq7/q4Ap0hxuPZo+UD9wyQSNURLNOJ6rOy3W9//ElNgLCMPYKKIunCElfNornQ4fqRmg3y+qBKuLdjFsYVzs370M5enMCNZrnMFHbfC40uhPkmKDfK0qZcActa0AlN6GVTviAXa4lc9ImRctshCz2NAK5Xj5v3VA5WRuKTzWEyYka+YDduG5DeDbEXD/WukfnQPvRqkzFqy2zvuWJQ5lUbkz+m0NWg8ZpA9gOv2qaS1b7MdQYN18PKvSA5uiC7WnHBeRN04LibulSEfXaZL5pqnaCyK4woGPCEq34Wqr/fsW0WzzOh/SKuqoQlyI1eiqUQEVWjk78xbZ+J/rksCP36ON0ZoWHfyJu90VxQoAMcxaV+nZb8emSO1h00j+20AAgPOGGEGclGLAUWUBcIqKAdefYY4vsfR1Dql5HjDYTJTuG3Mgq12/G3iIBC43HM/umjex0Ep8U3POiQKnbS8dCQJhHEtXV0oGfvL1wKFUTWt3dQHD/p3mzDhJVy8nNJKma2o9wdm0IHij7Lll4InMDWbDQAu3vn/LBoq2Lbv7AN1LTtZ+5VTLhbR0BQ13NBF5ZAE/3HiVOWnzc7pCrsLm6GVEvuJq7kpvZlHqBvIE707hKQt6Ua9wz6VykPrc5Rb9SxiVsCbVG8/6D/C2kTkFRSpKW/+Wrt2SlU8KpCQdraijxHLn7XJqsL2HQMWQID04T4GKtmo6iz+ScDOL7t0CVadIrUplyBr2MTmACoOSSBf3bEbXPcCb6Bbp+rcUGNkYkKRowahtgdpOJEncf/uHQ60GC+cgsnhHbdA8SZBfXVzr0V/ulNrF70jedspIB1wJR1/9HpRWD/pH
 Lsav26oU
 gLs6oBN181Y4Lw+rY2lX9ggfB/cyRr8L2fDDXAVapapPbVPsS4wTVxufmYhRxv5P7F76abxfR3xyD9nWfbCngzqYThm6VqBuY5qNJRMNMbOKGdMBLqjdwStT0+b7UP4tSyDisEeR0ug8+POhc4Ba1kHFPoB3dBcS7LPtsQFmeOedsnyUtGD/RNpRkkpnIV9Z9eSnwrmA06v9LFWnuOd00xXccR2z8JYHeW4wVjwSBTAg7QrQxiI44hBtyJSUmHrU2NK5nX/e+e98+z2m9RpEGy35U+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 04:26:38PM -0700, Ankur Arora wrote:
> After this change the only remaining functions in x86/lib/clear_page_64.S are
> this one and rep_stos_alternative.
> 
> And so the _orig suffix seemed to be a little confusing. That's why the
> change to the more functional name.

No, as said,  having "clear_page" somewhere there in the name should stay. It
can be "__clear_page" or something along those lines but not something
completely different.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

