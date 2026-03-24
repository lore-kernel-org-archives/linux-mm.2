Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B59BCF54ACF
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 15:27:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 238DD6B0088; Tue, 24 Mar 2026 11:27:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2107D6B0089; Tue, 24 Mar 2026 11:27:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14DBE6B0096; Tue, 24 Mar 2026 11:27:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 03FA86B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:27:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B9300140236
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:27:45 +0000 (UTC)
X-FDA: 84581336490.26.29D0E9E
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf16.hostedemail.com (Postfix) with ESMTP id 63915180004
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:27:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=temperror ("DNS error when getting key") header.d=alien8.de header.s=alien8 header.b="L/Wc8hjz";
	spf=temperror (imf16.hostedemail.com: error in processing during lookup of bp@alien8.de: DNS error) smtp.mailfrom=bp@alien8.de;
	dmarc=temperror reason="server fail" header.from=alien8.de (policy=temperror)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774366064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vbFh0E0FSh8S2XvdC2/tmA6giRJv0hj0tcBin2Ta14A=;
	b=E/PSBX3HGMX5vmEQgi2QZ+nmyLwnV4NwKmgK9XWy8+XlxLCf1coutlNSetaZsvjRvOk5gz
	Vw36V+jzzs+zk4Gml/986xNJpFZ3d9ESvO84pE3xMknW/qk8NZ8AxOZEugdhPP+CZ9OMAx
	exFacwQZgK7I9tYJ3z63oEL8+g4SIfk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=temperror ("DNS error when getting key") header.d=alien8.de header.s=alien8 header.b="L/Wc8hjz";
	spf=temperror (imf16.hostedemail.com: error in processing during lookup of bp@alien8.de: DNS error) smtp.mailfrom=bp@alien8.de;
	dmarc=temperror reason="server fail" header.from=alien8.de (policy=temperror)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774366064; a=rsa-sha256;
	cv=none;
	b=7fQNuTllpku8fNlZAWWIrT0BgyNUZgWfElmF6VDAbmKyD6JeCNcgcHrK5l9nRWX6TkVfxk
	t4WNLKHirqcVhR/uq3+tp0IcC13V5sJ+diwUKNpHm2WfvMsBFNVp7FzSz33ECL7IDw2cpy
	nNn53vMKf9GyN5uXF1fv51xe+a3JOOE=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 1C59140E0222;
	Tue, 24 Mar 2026 15:27:40 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 3jOQi4MILGUo; Tue, 24 Mar 2026 15:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1774366056; bh=woigxbJtD5j6gM29aZB5V0scgECkZgH7JUCDsxKZ5ss=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L/Wc8hjzK0WBM0c64iNEr9eZfAmWYoS9F4lg+u5DvdMzdJa0NXJmJeO7nKaUniN1x
	 hnkOlrmfRZZyXBR4CJ5SPzOyKtOlMjWBFGX373mBtrKujarheaqDJiocPG7sZZR6Fy
	 vGO8lCpswDWMiX0K25z1LtzpmUxDiYf4Iw3O0Mmk0OjEB+v+wluUh988WUG++XGDTg
	 bsjv03lXWtyZvXzzKmLuetG3ZgdtPV7Y3QMzRP89Zc9dngmwA7CHYtY/Y0AskiyJl7
	 6JfT8sTOb6e+XKlulZlmz73ROWxwtuXfV36QFROjTNPG3bfdQs5mfmFr8YXDOLB4eH
	 dq/pT8TxcJeLIvIqN9/3jUjWXWPRTdP9eFSfQYsNPEF5o805CMvfrZ/lt2G5GU49Ng
	 zBFqpIqRspKCLp23HlDjN6rbt9TnBnyyRKv5ZcbPwvOKS/HBuDGpodCoZDWTyEq/4i
	 6n0z8lBWe6ho3d2WfqE+hRFvkQcJSxKvdJoor1kJri7gn062HmqM3kzO3JWXz9jtwk
	 hRCrji4RY0lxVQhBrD9YAXZ877RoDPLbUN15aDHoJ/sNYMI/SAik7d5b5h8re1FtK0
	 CBS6gYjvpi7e6G+AeXpSwzu26QdCuW3psOBT/3BVyw/Wd/3JPFrWGTqKp7GWRM0fHA
	 0aRq3JkMOZMIbtqoAVH9Gjtk=
Received: from zn.tnic (p5de8e020.dip0.t-ipconnect.de [93.232.224.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 49D8640E0031;
	Tue, 24 Mar 2026 15:27:10 +0000 (UTC)
Date: Tue, 24 Mar 2026 16:27:02 +0100
From: Borislav Petkov <bp@alien8.de>
To: Brendan Jackman <jackmanb@google.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, x86@kernel.org, rppt@kernel.org,
	Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com,
	reijiw@google.com, Will Deacon <will@kernel.org>,
	rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
	Andy Lutomirski <luto@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
Subject: Re: [PATCH v2 01/22] x86/mm: split out preallocate_sub_pgd()
Message-ID: <20260324152702.GLacKtRrAGFea3FGqH@fat_crate.local>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-1-28bf1bd54f41@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260320-page_alloc-unmapped-v2-1-28bf1bd54f41@google.com>
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 63915180004
X-Stat-Signature: iykxkany7kidwuc5cnimmnhecnpfpgxd
X-Rspam-User: 
X-HE-Tag: 1774366063-123755
X-HE-Meta: U2FsdGVkX18qt7FQEzU1+KPfRThYN/XW0DHzyxh/RAYZQ0LHXmv0gFYaMz2z8JkrMzttMgR5acr/hj+DXHZgziD0lywi3U6oEXDZHJV2CExWg1cvz3Zf7O2pdyNJGeYknOrxShRRfg+UbXPmjCyiMFUBg78vVyPDbX7KP3kyer1CNwhDg5xC2vDXTpA9T3atDh5LRtz6Uvgha7fFaeXwsEs+qwdmkfJzjKmDkagR3mkNFtloq+Va9NFBQl8NXoiO0dKkF/gsYNiaM6eaMYCZIQs7ENpueVwV8/6e31MbgvrWAaGA9NS72GsxEm8RHQsplMITU9vV/TbwMtbFiTH5/Gg8T8qBfEPT6PllJkf7FZPTDAIliY9YIH3cSpgp1lNqKWo8Ov/WxhOpFsPBWC74r+rMAuY2plTbf3Xy8ammFag7IVbwQDBnKRLAzqB5IAsnx2w35vzJqDo8aIQNMW2ZaYIzvpri71C92K01bfk6wANYr+dZJ3AWnFa7S56qA1N8nKJHbnn3xGD3dKBQMkwy0SyWoQ8lwheAhmZ7IWge7PkNYXS1OOMPc7p5qUwLDJzhBfNIBHDdaDmzaEGJWXdBiI2SxlAxSAUGjszI8pQjluQaWtR2G3rWiamfRjuy63zeGKJMCFAsM0T0EeIB1f8hN8kgmsK8KcXb3fttYyzKLA+zlbz4e3jb+YIo37BHDw8MMUUVXRSkPDiVbG1TiD/JDlZLH/g8eiaK0dcavdYpfAHug2Ut3xcZxAMl+IFeBG9erPY3SJS+AsekDQGIzj7IIafEeRLq4pVFor9MWIsIxoOi37htboinJdVlFsvthQ11BOkBtWNGsNhKmCcPGSC3SbuSOVaD/9nbWriXOBvzXlfCtcJhFdV2R05uJeIsigs1Xpa2Ek7W0cpCdhq3NNhMlupKXI1XfohVSNFSd2Ls7tuMuyG1jMrMMedLAaCyQ7m5SETgruOXHeOhN7T0Nmn
 Dozuh1p+
 XtNxex1CvCEb+nG2uQt7XE8rh61eZNntmwxK5nY5g1tvx29AL9xPL1m/ww7JkG4rgPWHxTtuqnjbbRagvnvsluWt7sDdKN6qEh8MQFsvoP2auWr93iC8RMEeM+sbFl5XbGX3VNle9flR2TTcZUdM0bH78AR5+Nb9RXfoCimM7qzVp9sZRWLKz6y1YqQfRYO5P+CMnCQNYL1cTXF/CtRaz6trws3ar0j6ctbddrJBfYQBCBRpMzZ7lpOk3EjQZf7i3pQkkWOnAtfVEWXQHPTaSMaRleIPC5YrLFVuoTVahI0ogbTuvTAbKmTkGzyKBMLe77ypxQG1YUIlQJLKtmy0Pc+iBfUn59Xq+0drhXzyZUdJ/lSz3ZYW1ZcQCheb7QmVkM9rSMDtsCmpmS64uR8xuDA6pll/v7eiNp6YnV3mj/nBIwlluIqHIp/tzfpbaEQgX8bWer16hlm5HTIWqmdb/D8CEqzzzCjfoHMRhUaZS/p1Io9QHP5vM7HvX25AOjcTQWval
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 06:23:25PM +0000, Brendan Jackman wrote:
> This code will be needed elsewhere in a following patch. Split out the
> trivial code move for easy review.
>=20
> This changes the logging slightly: instead of panic() directly reportin=
g
> the level of the failure, there is now a generic panic message which
> will be preceded by a separate warn that reports the level of the
> failure. This is a simple way to have this helper suit the needs of its
> new user as well as the existing one.

"Describe your changes in imperative mood, e.g. =E2=80=9Cmake xyzzy do fr=
otz=E2=80=9D instead
of =E2=80=9C[This patch] makes xyzzy do frotz=E2=80=9D or =E2=80=9C[I] ch=
anged xyzzy to do frotz=E2=80=9D, as
if you are giving orders to the codebase to change its behaviour."

> Other than logging, no functional change intended.
>=20
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  arch/x86/include/asm/pgalloc.h | 33 +++++++++++++++++++++++++++++++
>  arch/x86/mm/init_64.c          | 44 +++++++---------------------------=
--------
>  2 files changed, 40 insertions(+), 37 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/pgalloc.h b/arch/x86/include/asm/pgal=
loc.h
> index c88691b15f3c6..3541b86c9c6b0 100644
> --- a/arch/x86/include/asm/pgalloc.h
> +++ b/arch/x86/include/asm/pgalloc.h

Why in a header?

That function is kinda bigger than the rest of the oneliners there...

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

