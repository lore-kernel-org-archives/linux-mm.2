Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50514C61DCB
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 18:51:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 490156B0088; Sat, 29 Aug 2026 14:51:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4406A6B008A; Sat, 29 Aug 2026 14:51:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3599B6B008C; Sat, 29 Aug 2026 14:51:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 14BFA6B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 14:51:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 88A4B1C08E0
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 18:51:52 +0000 (UTC)
X-FDA: 85155201264.14.E1FAEA0
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf26.hostedemail.com (Postfix) with ESMTP id 64A7314000A
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 18:51:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=CLeTw5i5;
	spf=pass (imf26.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788029510;
	b=0H+bO9uJmpUE6XESdZfFmwjM2XU6+myJNNDdz+vqn4cPdGLxt0YgS9OX1ylfp4eI2O6PYV
	Cc4GNDc6SNM3y+m58dRjZwc5a6aE/FI5s6JUGyT8L1Ul6olzN4esDBMV3SycQVMcY2Tj0b
	DipL5Ygfp1zmqfaTVFDDcBqgbiWJUkE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=CLeTw5i5;
	spf=pass (imf26.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788029510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BjZBpwXh61Zg34YTjMfi+r2qrk6tlOIm/PzmccxuVvI=;
	b=1hNZPZDBq2Mj/bsJ38o0+faj2uKoKmy5b3v+J0hfwrafGbVuKrYUvt8qluve1EscITcRt1
	6j5IogiI/yV1Ng5l9wpRoVFsrnlwROrUqkz92cBI/e9MQrCCpYvyVYZBFtNQf2OcDNFtpH
	QLh4/T+TZys8+MHQrY3VzvjMCpAZqyM=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 539BE40E0377;
	Sat, 29 Aug 2026 18:51:47 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id aucMWHzsGWSk; Sat, 29 Aug 2026 18:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1788029497; bh=BjZBpwXh61Zg34YTjMfi+r2qrk6tlOIm/PzmccxuVvI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CLeTw5i5DTZMs08uq3JaXiURTG2XmSrvSZF0tWuOjRnWEmuQvcc6tEe4A/Yl7h+p7
	 +Wn3J01doWBgt7isRHYb82tbgFnK1mdRK9p6pUn/VYCYjdX9jRtePYamQmB+IYNrjK
	 ueM924sIyQbqNeGafH31Zd2FennB5QsAopwbWkcVszpa3Tc7NLNKb0+K5sKm/kjLUl
	 3ElY7kXK1sKInuladrrP/ndI+lUyRs9Gb/ZjhEaLyy9H7kw9B20LJLL7FXqVkNb/Xm
	 M+g3V94tXQqgBPuCHnveERi91TvejTQJIxuldh4I7UFVkmRz0qeQZx4yC9T0tnjy8E
	 AzADIzwYZ2gVgTbE0U2L4w669zAaEurD4Q/ew0VF1hqn781+HjQPgiIRo0y6SVzVOn
	 vk4Bn8Ed8QE5nhFoip0W4Hwm+ZzByQOh8P9R5NWV1ZDzqr/1y4GtmMSJv3KrCyCFik
	 4cS0cmjwkgGbjE5X/ZWCPqVk+xtfpTWqcO10pQKe/PgZHv3c/mRUq0IsdwIZJ3AE6Q
	 lb3TAfkFNIdUZun+kKXrEaaZSmEI63vv+KZYsHqAULYQfQ581PI9Kzi83dZ484S4Rh
	 FjDZM+CtVuhY+IbNzxsBe5qlgUO7SKJbrxOsTDEWWVFeHpwqFfMAF8Z8CbXHWbBDlL
	 fq6oJE4LSqgFFN34IogLwUYQ=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::3a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A2F3D40E014B;
	Sat, 29 Aug 2026 18:51:24 +0000 (UTC)
Date: Sat, 29 Aug 2026 11:51:20 -0700
From: Borislav Petkov <bp@alien8.de>
To: Laurent Wandrebeck <l.wandrebeck@quelquesmots.fr>
Cc: Dave Hansen <dave.hansen@intel.com>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86/mm: don't apply va_align to hugetlb mappings on AMD
 F15h
Message-ID: <20260829185120.GBapMqKFM35KtL0Mod@fat_crate.local>
References: <20260828135747.724789-1-l.wandrebeck@quelquesmots.fr>
 <3faecf65-7edb-4cec-be7a-e5266dd3a649@intel.com>
 <20260829174704.GAapMbGAZMwImcvIN7@fat_crate.local>
 <0B48BE2C-2E72-4961-91D9-35E215F537A9@quelquesmots.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0B48BE2C-2E72-4961-91D9-35E215F537A9@quelquesmots.fr>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 64A7314000A
X-Stat-Signature: 7cighq8pj7gy9czcn6tz15ku3561bbdj
X-Rspam-User: 
X-HE-Tag: 1788029510-368256
X-HE-Meta: U2FsdGVkX1/DvA5vP1cczU3ZV0KG1jZJc+AR3nTI11jmyDl1D8TCNDsRrLhbm7pi8+cjL6fXHXIFgEDhgL8a0LgMQg2hoFgJMGwKllHvyYj3pooKEcfl+HLjG9utFBVoHLGb5fWjIBq2I8K8ZP6RMkbT2g0Q33B4MajvWq4DBLKUTDKLUennymyzllv3dW35BiDmehAvj/lJIkJe2wJd3np5HZmtCBwT59PNE8Tu7J79og5+SLVnjUlSAOfTzxadW/Yw/kikDisUoBsJmDSDuGMtxc5yJ9lFbzQyiXCfMuZCNrrS9u3EyBx3GtPbwycKPI+cOtoVQtwgH8dY00ab5YjVzhppFr2aka+i74Fj45znhWLWf+XlOoJ1+10zEJ6gvTNuMxlYzAuBpKKgccEt6VhS4JJVdErpU3l/uGC1BmtOgNbNB4e/4457LjbMf/WK2nuGOEvjIhhy6ApsLUkD348kvyNAIh2iP3KjSUFCtp5hRb51tMSxnBYOCGSgFXAjeilonecp+Tz+I0XeXjCy4AcCh8UrsMlQPgSAvBfEovp1HUu0g/VzTmzCvgpKDWRQWFaPEERz7mXGDCZk5AcTzJE/O91jTa/KBMkL+PsPMPrOC671WGj+ONTGeXjZP8APSbHJ2mfkTz6nXstz8onlwv89FkO2QEUMaHczoIdqW0HYgSyRVwWEDFQAGSu0nKYhy4h8hR6OUU+eDGdjaNti1AytxOKlAc24z/gzsqbjoILdJaU67xFp14L5h9sCFceEA2vkAOQnZ8nGTkjK9U4l+noeXQJkNj7ZwVdvMKB1j+ZQ12zmd3lxOQ7mGRkB2fNbauQWVF0tywLqAJS7nHjP5ieKcFfQL0tu6k93+ezcdj9u0oyZ9p8CYDDi4EAVm4Tq7wJBCWRqN7DiTtXsmpPD88V1mkZHNbbh5XJm1cJeqZU0z+NCtR1NQgpdU8CM/5F7Hs9qVQNv3vdmPRmNZdp
 yBf1nLxc
 +Lxz1MudegJ1AVLp4Q168ebsVukzCeKAsdb5CyFq2W+Xs7oeF6qd48HH7Z3ZS9QeFc0uqkFYNhU0UCjI62dt5yk8s6vtg0DAMnpObp2FNsCE2LXEcFsk5sVqIP/FYz9+XZB7SYPldPoXABAVxr1Gj1478O4H1Uc9iBUT56/TZJvE2wJD13mDDmVl5V12iGMmS5NB548IDB1OuM80P7+8NNbbEyPHD4EsTYjAkXEXLmy5iSWmuKo+/2i7dKyT8bgws0lHaB2W9+RJ92E6+9kMBOHkF2MDLN9m1wgaB0W17fwhjctgUvhu+pM2t18ldpN9bdPAEnILzBoe/RevqNP9pkFAC01g3i6Fqb1k36WzRhX8ebonjjaQBlWmvFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 29, 2026 at 08:15:40PM +0200, Laurent Wandrebeck wrote:
> My homelab is indeed composed of 5 thinkcenter with a10-8770e, and
> desktop has fx-8370e. Actually I hit that bug running 26.04/7.0 and
> reproduced with 7.1, 7.2 so I dug a bit more and AI (I'm no kernel
> hacker) proposed this patch. I'll happily test and report on whatever
> you'll propose if that one does not fit. SSH+sudo access is possible too
> if you want.

Thanks, just please do not send HTML mails and put your reply under the text
you're referring to when you reply. Like I just did.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

