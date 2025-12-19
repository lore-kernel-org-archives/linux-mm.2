Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D548D78770
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 18:02:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 413CC6B00A5; Fri, 19 Dec 2025 13:02:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3656A6B00AA; Fri, 19 Dec 2025 13:02:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DF0E6B00A6; Fri, 19 Dec 2025 13:02:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 03E3F6B00A5
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 13:02:53 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3925DC062E
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 18:02:52 +0000 (UTC)
X-FDA: 84236991384.28.655BB27
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf10.hostedemail.com (Postfix) with ESMTP id B5B6CC0007
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 18:02:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mKihaSMk;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766167370; a=rsa-sha256;
	cv=none;
	b=7A+OmBAyw9+yiVSSVUC82HzTpU7OAv76lcSklO66I2ZB+Ujpl8Ksh/0VneAEyvg/0MWsVJ
	JK7xxcSu+LbDBwfDykWrh2H5M/FsA8p8fuPhHDtyDDdFwc6jorFsJh0ueGitcEpdy/jpO+
	p6lW3NvR5kXIw+OsrCanygWsShoaL1U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mKihaSMk;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766167370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iptTGl+1dG2vshTUeOsi9d9CUpec1GSylLykl5zE7Zw=;
	b=tBnfDZo4XOP/MBJLHMV4UxrNWMWhiQ91JukCa9ugFcnYPgohWxx7Tqh3J8pAxbvJM0dmVZ
	U03yqWyRAqet7axXI9rUNreoTsQvj6Wo8w1GctbqxwoPyapU5C6I+EGMCqja3/WxnWNxeI
	eFv6drmsJtR9+5MP0l8qHDSiDdZFZrs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766167369; x=1797703369;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pbi5j6wJLQ20G3/u3yyZEWII3BRtiMRs/1WHV4lV7B0=;
  b=mKihaSMkLajjjQpnYqCXYb5meUdjhr3UrUQawfCxEVBEHpfBGzRzuJZu
   m5zm0QPX7pNiqrcxako7Nz6HpaSb8VFDDDUgsfxdRjK8Sls9qLQ71z2No
   t2lr6r8lV4hPdKKL6okNPBtiXk4BRgtPM/aW2wzyaUo2wkoVUQ5mjcn2t
   QLMZADIi9Vjh0ZK9Loe9SBctp4Z9sg31YCvhxWNN0JVQqMg6oaPR+q3FT
   gB8Y4eAYDWWFKmXLEdEY8yo5mIl6hKOHiiOt9XLXcLGK0P0Qzt/TobD9j
   98qlLh60c7IWcCIPLmEZmO45tDxsoPPLf3qEvuBi2f9JCC5PbO4XbrxLs
   w==;
X-CSE-ConnectionGUID: 1MK9mJ74Si6UTE/0HfAYkQ==
X-CSE-MsgGUID: TAs1j6rFRaC6WbsbvjtslQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11647"; a="68176831"
X-IronPort-AV: E=Sophos;i="6.21,161,1763452800"; 
   d="scan'208";a="68176831"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2025 10:02:45 -0800
X-CSE-ConnectionGUID: +BWCN+9ETpCg/FgoJ2ROWQ==
X-CSE-MsgGUID: wvwL0k54RKWOsIx1nq3Kaw==
X-ExtLoop1: 1
Received: from schen9-mobl4.amr.corp.intel.com (HELO [10.125.111.100]) ([10.125.111.100])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2025 10:02:44 -0800
Message-ID: <a3f22579-13ee-4479-a5fd-81c29145c3f3@intel.com>
Date: Fri, 19 Dec 2025 10:02:43 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] arch/*: increase lowmem size to avoid highmem use
To: Arnd Bergmann <arnd@kernel.org>, linux-mm@kvack.org
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
 Andreas Larsson <andreas@gaisler.com>, Christophe Leroy
 <chleroy@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Linus Walleij <linus.walleij@linaro.org>,
 Matthew Wilcox <willy@infradead.org>, Richard Weinberger <richard@nod.at>,
 Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 "H. Peter Anvin" <hpa@zytor.com>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Michal Simek <monstr@monstr.eu>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nishanth Menon <nm@ti.com>, Lucas Stach <l.stach@pengutronix.de>
References: <20251219161559.556737-1-arnd@kernel.org>
 <20251219161559.556737-2-arnd@kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20251219161559.556737-2-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B5B6CC0007
X-Rspamd-Server: rspam03
X-Stat-Signature: 8khfgb1tqr9uo1m9ipam8qsyos6iogbs
X-Rspam-User: 
X-HE-Tag: 1766167368-937677
X-HE-Meta: U2FsdGVkX1/7FhaKJ/MV3G9PJ5Y2RvI0rsCFtEkKVsDlSgHIygNDe4E7f+f9dr8B/BnlOKpjljs9m9gjzeNwovx2airWmZ7QKFkS3udcxlTepz5SETmx50T1YbJ0aLf81ExUWaXZepZZEyx/09IoaWSd87bVy8lPk9JxyhKExIRDFtCjf587tILDn3A7lXqMpxfToQG3ETWCddBepuAm0qb1ibaoqhuCdssdFWyNIYtk/kC2wvY8S32W0aBonQGWrNtYUoF+kZb27ncAGz97Lk/R94tU/AmHQFa4C7MOJUvXbupH0LGYNnbMTBqJyK/nG0AP9qG2T14n3zNXOu89bBWD8O/CRiGYWvXNy+scMB8BlK4cfCKd9sJhU+yHYAnuydUY/Y1F33OrNyGCEMi7z+5ogI4S1HKzW6oWIdBk4d4jF0lNsqUt5U4HnLTCVZvouTlVIHRLMf/6DvUnV0GyWFWLC+Kbji0uh061XNfXyribyyDy3Fm6e3/Caatx6pIpBxR/rZRNPbyZRL0FbISRHOnX0OzaP4npcr/qPmP2Jbg/CV7vun7aZ7EwDawgd/Vu/992w1PBQ8BFEq00NaUxMw8cSHPry6c/cAtIC46Lwh4L+f63junIss3RDojH3h68RGc2AQVo+kcS5++Kf0XSp7+MXHxIIjnB7oemdw9WiZjQbSB3ggkHce0mvrrr6Gx0uxXjzqyCvHs5c5b3H/JX5P/tfDXvSDABohNCQyAbnVvvxA0YEkyzCNdMXJBN+oGY6GdvGifh29bN3EPjiGvCG6uL73rTifC4/BzOBw738rRRLjU2e+DYX0Kie/D/wBmvlr9Maul+2ENr+j5mrPC45d35sDNXkQywhVvseD+u4Xx5ay5ssCsmIT86pELonXGQQTKm3tDvL1A33jFz4mkK+Ob3UQLyfLW+KdKrxj7um9iAFgSiGqFU87OufqVBQ/mSCiukLuPlqtgkEGR7XzU
 hxok3Rlv
 nKD4SyEZVCoqusYs4NLVGHtOvhPmPUNN5IPgnzI2x3/bm1lD6bfAeQwNKJlhoKJ3oGwyVQJWrv23svY/SxeCK02B+LR4vzmqI61de1Etya5aRlttI3+PlWd1jCg5L5H7vMDuQnwz95/092BLxx8Woc3VCjFq21FJct3gbze13Iu77VOzaq4N27QtuBQH4eALObMUH/xXGC1eKxyt0haIn5oQDwRGDSUx8881u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 08:15, Arnd Bergmann wrote:
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1416,7 +1416,9 @@ config HIGHMEM4G
>  
>  choice
>  	prompt "Memory split" if EXPERT
> -	default VMSPLIT_3G
> +	default VMSPLIT_2G_OPT if HIGHMEM && !X86_PAE
> +	default VMSPLIT_2G if X86_PAE
> +	default VMSPLIT_3G_OPT
>  	depends on X86_32

For simplicity, I think this can just be:

-	default VMSPLIT_3G
+	default VMSPLIT_2G

I doubt the 2G vs. 2G_OPT matters in very many cases. If it does, folks
can just set it in their config manually.

But, in the end, I don't this this matters all that much. If you think
having x86 be consistent with ARM, for example, is more important and
ARM really wants this complexity, I can live with it.

Either way:

Acked-by: Dave Hansen <dave.hansen@linux.intel.com>

