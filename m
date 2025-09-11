Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2199CAC58D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 08:45:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28AE28E0009; Thu, 11 Sep 2025 04:45:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 262B68E0001; Thu, 11 Sep 2025 04:45:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1510A8E0009; Thu, 11 Sep 2025 04:45:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 044B38E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 04:45:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AFDB81603EE
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:45:17 +0000 (UTC)
X-FDA: 83876335074.27.38B984D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6EEE240006
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:45:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kKiVFuVz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=frCjNW5L;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kKiVFuVz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=frCjNW5L;
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757580315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ry8cOkx2zIlc+wzBeJkoq6Du2FeV1h0pV2EEvMd6IT0=;
	b=ELT5wl+EBNsnFOvOo4gxYUg0q7xKHnH4GOuJBLeIG8gOgjkhSnIT39gH2KJ3+QSpwOLre2
	GfEWdOoFcoZRpa4Wx5PK+tfJilsEYVkLs7mrS1O8R8IOXFidV9bxfmC8/T1ijyfRzt0+Jm
	N92d+8XACOnBXJk9fIIAYaUpoiiFQZ0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757580315; a=rsa-sha256;
	cv=none;
	b=oyBWFAX6NOOxiwNfRclSkHPzXLlFGQAMMhiBYlxv+vIUfcRUR+bPVPnabmcVmo6+Pr1fkE
	GoBqirEmJdgKNSnBWrN3VvZ3E6cKxBQE9Ru8R/Tm1CFiUZvZSAh8U+kr/K9pLW45Zy7oS1
	6wOKvmbJffXQQLn0GUstgCTnNcag3HE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kKiVFuVz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=frCjNW5L;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kKiVFuVz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=frCjNW5L;
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2223268672;
	Thu, 11 Sep 2025 08:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757580312; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ry8cOkx2zIlc+wzBeJkoq6Du2FeV1h0pV2EEvMd6IT0=;
	b=kKiVFuVzB2MFbKNbBxuMO/vdrJXFFEgaNcBH2B46AGhSVHk2/ZnKWIf69HLa5IGMUjp69C
	XEzZMfv70JELhdn6BT1bCtpqEEqfjlrkexP5uj/eBTJgM+bersPdjPeF2eswgeGUcXVMZl
	Ie0QRoLgf3jfIRXx4chmQ17+PtMfwqM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757580312;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ry8cOkx2zIlc+wzBeJkoq6Du2FeV1h0pV2EEvMd6IT0=;
	b=frCjNW5LAXoegNDf3SQAYBIHJxfHVfoJlpDY7dN+SbqS0SRxmsSTxM2NmRgK+Nwmdf3EdP
	pwXBRCcvu4VqKIDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757580312; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ry8cOkx2zIlc+wzBeJkoq6Du2FeV1h0pV2EEvMd6IT0=;
	b=kKiVFuVzB2MFbKNbBxuMO/vdrJXFFEgaNcBH2B46AGhSVHk2/ZnKWIf69HLa5IGMUjp69C
	XEzZMfv70JELhdn6BT1bCtpqEEqfjlrkexP5uj/eBTJgM+bersPdjPeF2eswgeGUcXVMZl
	Ie0QRoLgf3jfIRXx4chmQ17+PtMfwqM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757580312;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ry8cOkx2zIlc+wzBeJkoq6Du2FeV1h0pV2EEvMd6IT0=;
	b=frCjNW5LAXoegNDf3SQAYBIHJxfHVfoJlpDY7dN+SbqS0SRxmsSTxM2NmRgK+Nwmdf3EdP
	pwXBRCcvu4VqKIDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ECA5C1372E;
	Thu, 11 Sep 2025 08:45:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /wxjOReMwmiedQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 11 Sep 2025 08:45:11 +0000
Message-ID: <fa727f7b-92d5-4fd2-b9cf-a19b27303a22@suse.cz>
Date: Thu, 11 Sep 2025 10:45:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: next-20250911: mm/slub.c:3960:27: error: a function declaration
 without a prototype is deprecated in all versions of C void
 flush_all_rcu_sheaves()
Content-Language: en-US
To: Naresh Kamboju <naresh.kamboju@linaro.org>,
 open list <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org,
 Linux Regressions <regressions@lists.linux.dev>,
 clang-built-linux <llvm@lists.linux.dev>, linux-mm <linux-mm@kvack.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Nathan Chancellor <nathan@kernel.org>,
 Ben Copeland <benjamin.copeland@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
 Dan Carpenter <dan.carpenter@linaro.org>,
 Anders Roxell <anders.roxell@linaro.org>
References: <CA+G9fYtUi3bnZ2zycCot6KGeZcn67JAvz=wZm=6f2w9ZnL=0Uw@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <CA+G9fYtUi3bnZ2zycCot6KGeZcn67JAvz=wZm=6f2w9ZnL=0Uw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6EEE240006
X-Stat-Signature: qzcrz36fn6i9fq8aqbjm7mi6gpbsqdmq
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757580315-782186
X-HE-Meta: U2FsdGVkX1+jJqjs3rT5IhSsZ3UGRuOgrLQdkY1DFLgtwY32VTkq6d2PvVb4OIbSRzEqJ249LcGiQvbIGb0CY4Pl0RBj68AFdwk1VLVN1gJWb0OmmdzRexEO3Wi9d8o3w1faASeBwm8PRAokRftAjJ34QI/1WeFGVaY2NQOBGpDpZ95RR+KVJle3XSR76bJJkeYiEMqrRV2OhQGrSbXJ2wa6Rp1yc23Zk5Rv3zzaoCINETO08nGGWO7zzZCtxBPvexgUU5DX9QklvTOt+0Q+abVK/nJCC2RXa1FFxODbUm038FClq1b5xOQYiYbCAX1sFi14QV6WmDCnFl4x2gD/AMTR8oe2nrgAMHuk5HjbamYzNDPPutMxZRzQb3G2574DJoU8WqEAJn8lTk2kVDKTjb3/QH8UvFZzqv2zzvKd0A+b23N6EfFvQGFgEOjiDTG3zMqfIx5yHuZOc2XcDBUNSr7WgXPVAM3wp6il202Rs1UFXcjn0z5a4ZoLv7XiqaEUWPRhiTayqJ7+eMP3WR5qPk1RWZk8P/+IvtNAxp3pUw2+lZfRYWVMQxEUNxWmA0AgIAH0Q3zjLyTw6AeH0mRhJdnKuJgB3OcWyInXypjsAHNG3fLqj+Oz2echQiKpu/kDwwKlPo+23+/fTkK5yyR8WL6HsUPxVziuEnf44faJio1HGIdSnWSVv5hTCa1v+/F2X13RJ7vCuE5/meweFMcMrzuLSJCkydI1QKm6Dy2SzCdV1hUjBCwAUB8EPcY/obCFkrQylr/4w5q1GI3G8D3GUml0zPSlhXz6MF3d2RCTdK13jNby7aIbsW7V4Upf4lVBTqPN+W/eGDCEkPag8xM2c6MgLXuSymw6JcZVdnIREfEEbmxhF4gkhc82a9yUY015L5xL6M8m8cxNdFj9CGvZUZ6n1EowqIxU46mqkvBP4w58veGdOWWPznqQCP0LYTYFvL+TFTYtxr3Bllc8BW4
 LiZv2Al+
 x1GWNzzhgwJrJ2yw57CUqd7Y98ernmqg9KVduZ1mnW7jdQJt1DHAeZatOjs0fhQODSTROdzrByyJPjNY4WBb8xrgpNhxajRazZoVi+MXh6C//lpiMqaPd42jthD/tcirZJIXuJ7HCjqpCQM/9jHqwYrFANLYVEPXs3mUS0MlF7qZ1aOrW0Wl8qWh4vIT7bFrMbsgQXjGaHNhkDxHqFoBu8hnvEYoc4+Ha863BHn/yKkshL4D+RwnaCrnnp8UTHev2j/XoIPE6WHhbGC/MWh5rThAE3kpkSK4EmVgCcfq3vbs0WLNtvlpSRMms8GWyABV6/LTeSTttnALlMMPGIW46ztuG8JtWjHyspTMu2bEtajyWVh47GKHyw2PGGdDrl2ZXFqT1GTtDn8+Q4okThReihPcVY3YeHeklM6UTQyjjXpnJ/gUQsRpQJESAydgsDfo6MO1wO+NdQvF8jCCBM02/U8s1VDDfTcI10eA6oUl6/dg0wz/sVn20AI5cyzcT3jdtTiWhMIY5SS1v7QKo6Nb76kh+FfElPTuc67ea
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/11/25 10:37, Naresh Kamboju wrote:
> The following build warnings / errors noticed on aram arm64 defconfig
> with clang-20 and clang-nightly toolchains on the Linux next-20250911 tag.
> 
> Regression Analysis:
> - New regression? yes
> - Reproducibility? yes
> 
> Build regression: next-20250911: mm/slub.c:3960:27: error: a function
> declaration without a prototype is deprecated in all versions of C
> void flush_all_rcu_sheaves()
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> ## Build log
> mm/slub.c:3960:27: error: a function declaration without a prototype
> is deprecated in all versions of C [-Werror,-Wstrict-prototypes]
>  3960 | void flush_all_rcu_sheaves()
>       |                           ^
>       |                            void
> 1 error generated.

Thanks, fixed already for tomorrow's -next
> ## Source
> * Kernel version: 6.17.0-rc5
> * Git tree: https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next.git
> * Git describe: 6.17.0-rc5-next-20250911
> * Git commit: 8f21d9da46702c4d6951ba60ca8a05f42870fe8f
> * Architectures: arm, arm64, i386,  mips, powerpc, riscv, s390
> * Toolchains: clang-20 and clang-nightly
> * clang: Debian clang version 20.1.8
> (++20250809043815+87f0227cb601-1~exp1~20250809163919.3)
> * Kconfigs: defconfig+lkftconfigs
> 
> ## Build
> * Build log: https://qa-reports.linaro.org/api/testruns/29853978/log_file/
> * Build details:
> https://regressions.linaro.org/lkft/linux-next-master/next-20250911/build/clang-20-defconfig/
> * Build plan: https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/builds/32XlFDtH7RdddaA6FHskupLDDSO
> * Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/32XlFDtH7RdddaA6FHskupLDDSO/
> * Kernel config:
> https://storage.tuxsuite.com/public/linaro/lkft/builds/32XlFDtH7RdddaA6FHskupLDDSO/config
> * Build log details:
> https://regressions.linaro.org/lkft/linux-next-master/next-20250911/log-parser-build-clang/clang-compiler-mm_slub_c-error-a-function-declaration-without-a-prototype-is-deprecated-in-all-versions-of-c/
> 
> --
> Linaro LKFT
> 


