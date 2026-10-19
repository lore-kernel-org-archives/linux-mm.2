Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E91FF606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 18:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=alien8.de header.i=@alien8.de header.a=rsa-sha256 header.s=alien8 header.b=O8zf9CEj
Received: by kanga.kvack.org (Postfix)
	id E2F656B00F5; Mon, 19 Oct 2026 14:15:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E06D96B00F6; Mon, 19 Oct 2026 14:15:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1CAE6B00F8; Mon, 19 Oct 2026 14:15:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ADF0B6B00F5
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:15:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3D233A7880
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:15:47 +0000 (UTC)
X-FDA: 85340179134.14.CC5A335
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf22.hostedemail.com (Postfix) with ESMTP id 02C16C0012
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:15:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=O8zf9CEj;
	spf=pass (imf22.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792433745;
	b=QtFv9sHFVCYI1IYIzEX3W/fL3gIW45g77efR8DqPHZCiBvrDy8ru8Jz7yxmc6u7wbULhAa
	Gq92JDR2XJSZuchyG/tu3yVqq9YA1tEWh18H/tFuHSUdYul+g6mV6mlZyxdIQS4FHDQPpt
	3ZXWxdb2DM9Z4usDccMsHGB/9ziCsv4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=O8zf9CEj;
	spf=pass (imf22.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792433745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4w7YFTBtscoIjxgLMpx7cQ62ZcRL/yC92+hTKY2Gc7Q=;
	b=g0mkUM841bIzfPT6ZNh4fWrsE+yvaEcIoDPTHrhxgPPcsLnCrPytfz9arLkwGLVFVWQL7j
	YIyAigMwWIMqlb6p9jyhGSPI3ESZrTKynwZRagyhe9NUMOXSRu9g/Sa7GnodsAGgTmQ5eY
	ZT8/IurMl9PJ200Ie1hYAmE5Px3Dggg=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5A2FB40E029C;
	Mon, 19 Oct 2026 18:15:42 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 2vR_LGbI_aXz; Mon, 19 Oct 2026 18:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1792433735; bh=4w7YFTBtscoIjxgLMpx7cQ62ZcRL/yC92+hTKY2Gc7Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O8zf9CEjohQ3LUBYJVk4K44Xx8LNvFk/sIF0mu6AePh5AI6eobVCNOs7FEE4r2SbJ
	 c5UG6JaOdiR19Cnb8odfqiEUnkjOKIf0Ce2khTOpPwLVfv4icKB0811U21/szJttOE
	 NK3ex/bHxr9XZSKM0kOZBw4HXPBNR1DeD1LpjF4TV6pG03AI+eOvcCrqjFBLJsF1Ep
	 lNXcllkXMq7HmgiDT56MId8aZ0bRW/ocG+Jg7XuyKlZHcv4p0CTj49XwYAW6B9S42o
	 MvZOJRWPWlBHLFOd1fb4ouMv4rpNFy7p4ijHpeNujsFh5+tv23evVyenYy0P+rZIPT
	 fL+ZVZ5SyjQ/ZUsinA4qdHX/pQczzB14+xFlHSdl5KViBiMtztSYrALNuMteJtAJtC
	 9c58CzcXHZ8SuB2gJULlIn9wMK2A0baYz0O5KD3YEmYmxK09v2uMSJ3Fg5wrcGCYMp
	 XZWu00EW92jAoqikHBGwLp0MkdDnp5Gaf/v5c9Zgqgu5SAX5Bv+Wpa22/M+FIiG0yU
	 4sLaBAxm8dWvPdopS5uhadfeGS2Ld9IEAD9sPBpw4pDFQzmdJKD9bDsb5ypE+seeFB
	 egHsCag6kSSNTqeBb3RD6wVeEXnrhL4o3xHa9Ex7YiwNqtSyIQyS5dyBrx2sjullGb
	 MvXkaBiVi8hrhbKmjWOVSpok=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4EDAD40E015B;
	Mon, 19 Oct 2026 18:15:14 +0000 (UTC)
Date: Mon, 19 Oct 2026 11:15:10 -0700
From: Borislav Petkov <bp@alien8.de>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
	Sean Christopherson <seanjc@google.com>,
	David Laight <david.laight.linux@gmail.com>,
	Rik van Riel <riel@surriel.com>, ljs@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, david@kernel.org,
	Mike Rapoport <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Pedro Falcato <pfalcato@suse.de>, Kiryl Shutsemau <kas@kernel.org>,
	luizcap@redhat.com, pbonzini@redhat.com,
	Tal Zussman <tz2294@columbia.edu>,
	Matt Fleming <matt@readmodwrite.com>, gregkh@linuxfoundation.org,
	sashal@kernel.org
Subject: Re: hunting memory corruption bug in 6.18.x
Message-ID: <20261019181510.GAatZeLtUmU3Zy9VZt@fat_crate.local>
References: <20261016054954.GEatG7AgMNFRkiTo1H@fat_crate.local>
 <atI_yuCc4BiweBQP@google.com>
 <atT5TYyLapHO5ZoX@pcnci.linuxbox.cz>
 <20261018201538.d0957878f378a9821852836f@linux-foundation.org>
 <atXXma5NXxoSWJO0@pcnci.linuxbox.cz>
 <atY1vWRBRUwpISKb@pcnci.linuxbox.cz>
 <20261019083529.a81910ac0976c1a5687d4c6a@linux-foundation.org>
 <CAO9r8zO41EromgLGhKv8H0aKXjrffH+t4CFGU6cLo59JJ3CEuA@mail.gmail.com>
 <20261019105844.02d4623b7063fec25ebd34ad@linux-foundation.org>
 <CAO9r8zN1dTJmULsKCwNrNr_vKyrV+vMfD7wifQ05uAti7E-yDw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAO9r8zN1dTJmULsKCwNrNr_vKyrV+vMfD7wifQ05uAti7E-yDw@mail.gmail.com>
X-Stat-Signature: prkk4x38y1p11kixyr4n1xrzutjxgxx5
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 02C16C0012
X-Rspam-User: 
X-HE-Tag: 1792433744-832501
X-HE-Meta: U2FsdGVkX188vFM9nHhCm7bgEJeI1MxXFm21Mr+tu5+VWxhBP3HDPiS1aO1YSx8oYQb6XwjrWVdAvKNz89DUjPZvkuoeaZSpGFfoJMbERU0SuA+5owgeulREcknHytFuU9LDgMyNn2YbyvBAI+INIgLuAvScZl0oFDVx4Qmv5H5tutZ8Fpx22yTp9EPzka8WcydtI80smLFEd7VK4/AAs5uxHFjhSw4PHm8+M9cNE72k3wzJxcUcXJD9zdp/pcITGqgg0upgSxNADx1mQR/Y7zxLXYQ678mCASxFW6asgvoveHdm+mpqEgBIhuW57FVN3Ye169yiBx5z71yYU2hO5G5SSOke2TBkW2uv8CGPYPFTHOTg44LmPMNhpGOT2K8ZWnW1nIf+3qE2S3kuCuJpsqksGCALW9Jpl0F7owZ/6qNcNBrJOm9p9bQjq5AfaADgBfb6I7uUU9T5DiZkGLQqxB/Uxb1ZvIPIlyk6FJMZKCo8z2ngSr5EkTYCe5BLm7VKa5rXHPysdHQlsS/Rj/slOzggjMLVrCMepJmj0o3Xr7euGAyGum/8D+4QGq37Wf6deLV1EX8LB/HtXcYpGiiJYXq0UN8NoYHZnmPOAKXT9cHhBnmMI6aPmTUfDE0m2O5hDcrKxnXBcxcFWTo0D9Wp2vBkVAf/dPxCRO7GmLvakboC7qK60Bw0zNkjN9+yd2GnsfEfoI/e1YIknl3+AOX8nF0vZS5ZKp/iglkKlCHVgDWzUJlHeedTZQyJm4Nafs/pAXqWhQ/UGz/BnrWEIwWFXtuidba2qc1HovPP2YbGQArUzHKGiL471NJqaWxKFp0fVNSPP/midRGwk+/uIfJYEh0d2P1JdeLYA4/+isdx0lIHKvZydi6IwoT4LmngFd1/zR48BylRk2iCGsIcF7QRep9MwA9bfVxdMLMR1XFC3BLAbIQM+h8coVFY/WWS7dfp5jqvFTo56pogD3rlQQS
 gEdj26cj
 mg3IF3/jv+9t9AkaKfZCLh9C/zDRRKw12gds2ut9EUN2ku4YTTobvRykZw9i6WTefeCrbRYvw4kRtdXNi+KJBqBKEd1rC7kpL6Wp16y5lo00/bBwj46b9VXnkfZUL8ht36f0z04ow7rAhEYKPaeBKirrCI/fM+luDxXXrs37l8V4HsGglK+EL9UuST8YfMKXl9rIBqCwiqnwbx9338KBNPb1BFY80dvXee8rvMV/JUqO8bTDH5akwAJSrPTrFe+rczblwJl83Iq4EtXONptPz5TCcuffLWnf0z3lcLhbITvWlJMbzwyRCEplol9gW4OdDzFh25aTEvJqhoUpObjcc/W/9REmJkbFPuVT/ZwnyN60HmK0Eiy488o4bqME5mxn9JoRKGHidQ6HZAyCHL/EhbhM1vfNodYbkxoyh9SyRH0khhQQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 11:00:00AM -0700, Yosry Ahmed wrote:
> Right, but this is for new patches that get merged into Linus's tree,
> what about existing patches? Any way to retrigger that workflow?

You take your patch, apply it to the stable trees here:

https://www.kernel.org/category/releases.html

and send the applied and tested version it to <stable@kernel.org>.

I.e., you backport it yourself. :)

Do git-log on those branches to see how stable backports are annotated. It
needs to say:

"Commit <sha1> upstream."

at the top.

There's also Documentation/process/stable-kernel-rules.rst

HTH.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

