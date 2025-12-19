Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09C48E6688C
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 20:52:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 569296B00A2; Fri, 19 Dec 2025 15:52:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 516FF6B00A4; Fri, 19 Dec 2025 15:52:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CDAB6B00A5; Fri, 19 Dec 2025 15:52:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2CEC96B00A2
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:52:28 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D391E8AB07
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:52:27 +0000 (UTC)
X-FDA: 84237418734.19.7828061
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf15.hostedemail.com (Postfix) with ESMTP id 72A88A0007
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:52:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gQMdzpOX;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766177545; a=rsa-sha256;
	cv=none;
	b=q6mtG0fNh1J/rMgiNPuAs+Ij0oQw2/1v7wx99Op4/7k16swYizymso+Bb1/n9Bbf4plq8v
	2BrTEVAAIBtlEFgCgdTEx/UloGp8EkP+hqtsCIsAKEGo6BGWikg2+PZei/UMePiRf2QLWM
	6TG5zX0B/PV/tuLB0KhOnwDX6WmLLs8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gQMdzpOX;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766177545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i1/SJXZ90FI5UUfT5V9hfmtsaDq+2j5bDl9O0wW8jvQ=;
	b=JF3T/MGT5E2sdxWeyDAntNtmX5qVHnp2aYdLTJYqwUVSeTHUm8dpARMw3JeqUvfwMTv3y+
	qErHIjrEDEz6JPwWd8fN0DYk7UIEKicUOlXQIyPcxN71YEvLsdEqR7xMNk1SxgJrFa7g8M
	ECm/ZF14TMvKeq9f6jwttpu8e0NG6OI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766177546; x=1797713546;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1UnP1phlC1N1TzoJ+erXdvhZj4LIIeRmGQfpPPyOIYU=;
  b=gQMdzpOXo83zFqm4zsYa5EyTMBEZRzxIKlU+QHbTMwjQwQG7xd7pxOpI
   w8xcNJwE3VHT5b7ufNQ81UWhialzhF5FIOcagpv1m4ukZRgGSu++gEq9d
   iA5DWLDJvQuallkU1XZAsYWejOK4CuNOvmPpH7qbqEUNq7Fibxx9/Efdl
   rmJCZaCgDFgmAgElHM1Z7wyF8jnuKjk90QgLDqAT2bTBxLqjiOMxJOpdJ
   Gjvo14+DiEi4QvlDODjl0ES9qtODq1GUbXM8o+N42NEzWPA8CQTdzQDWw
   PPjP04BcErxulsjc2I2yfqVURtbpcNtAFH/MCPq8AtznA2fJSHQxHSsen
   w==;
X-CSE-ConnectionGUID: CKqcjwqnSzWa03oPG7fnWA==
X-CSE-MsgGUID: NfAS+bKZQ7m20VO2FeWN8w==
X-IronPort-AV: E=McAfee;i="6800,10657,11647"; a="78856581"
X-IronPort-AV: E=Sophos;i="6.21,162,1763452800"; 
   d="scan'208";a="78856581"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2025 12:52:24 -0800
X-CSE-ConnectionGUID: 98Uh3zVhTE+23i7eXdgOKA==
X-CSE-MsgGUID: bx3AzxBJRcaevFLfuS8vuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,162,1763452800"; 
   d="scan'208";a="199196097"
Received: from schen9-mobl4.amr.corp.intel.com (HELO [10.125.111.100]) ([10.125.111.100])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2025 12:52:22 -0800
Message-ID: <a2ce2849-e572-404c-9713-9283a43c09fe@intel.com>
Date: Fri, 19 Dec 2025 12:52:21 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] arch/*: increase lowmem size to avoid highmem use
To: Arnd Bergmann <arnd@arndb.de>, Arnd Bergmann <arnd@kernel.org>,
 linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
 Michal Simek <monstr@monstr.eu>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nishanth Menon <nm@ti.com>, Lucas Stach <l.stach@pengutronix.de>
References: <20251219161559.556737-1-arnd@kernel.org>
 <20251219161559.556737-2-arnd@kernel.org>
 <a3f22579-13ee-4479-a5fd-81c29145c3f3@intel.com>
 <bad18ad8-93e8-4150-a85e-a2852e243363@app.fastmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <bad18ad8-93e8-4150-a85e-a2852e243363@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 72A88A0007
X-Rspamd-Server: rspam03
X-Stat-Signature: f7bsdpjh97ui9qnwxbp6ohr36e15had5
X-Rspam-User: 
X-HE-Tag: 1766177545-450097
X-HE-Meta: U2FsdGVkX1/pmmtm7XH4BJTkpt4qPgCA1bfYT54cncmSWKmbcGtImIqJt2VPMukhM8N0AOH9/LEYopChUPDLX6RbaNoFZ53SQ0fbYpdVN80arf2bo9VIEaR7JWeOQ8Nm9zg222LZpBu2V1PcEmd1uWFnWvm8JWC2Si3NlkvfywvxuJy6HVhQLGnlPJ0zYT9gk6CSqwfi+JGxYRjMkdvzfhgWb9o5iGEzyh3Tze9TIzAECNchWL7ESYyVBgumxl8Zc9xc83568rRO+oKmQ7doVcFrTuqNCFAOftYqfT4OpsOVyatlPJlwbQdKvS6/Dlt+QmjgO2mRjdDPUU0SNEsmSI+WGbOAhIAY1Z0QndIxVZm4MLVhOeYbs++dRb/0cI73dl+GBPFEIqLnigVNzwZ927/zPKIZqsXuZHmliX6jj9OVgTpX78/vmcJJ/taGRdye/0AmWUwiNmIrHSXv3C9huySw+arlvezneb+jEYfRddc9xV4bkGvCHeOQLSz8fV2mHzD6/gllYOBTtFmLoc3bMpniiqaIsKiWAsQYiqmKAt4HKvRmQYWrT5bfOz8q3QcdvsqeWkrBcOIe4Zzdznqx6kN8zJY0hgGvS0p7GqOOzT9m5GhBSBsI96I5kaLFMlHS9V4m6J0U9qj0HSHgjp8zVjphyY9GUdW9gj6B/Azk3QfeGCgutOkZntO6BtbcAz8eP8ZZrXURb6okf9hLn60D9vWJ5/3b/WMp3BRgSe+agPRVTTLckj95n56P3U5U3SfEctlMa7VH42rEtO2DvscUgyDTLV0bh7f/oW6hoCVHyKNT+6atxYG70MkszJ6ZBeEjNQN/J9Y3z2qDk6ELNgT1uujblowCWLltTnJPi5LxzqU0zyPmXTnZIo3xKk/f8DW8fT+so2SGxprgKRqI97pUrhy85RUknPkneNRAtN10EctzboXO/rJe4DeA9tvv5HsjrJvRKuEdLfClu6KO4mX
 gWzqlPps
 XgNp54YCJwTFqFLerHU77h7Nq08fEX/X5kjSvRK6XU2D6l/oncgJvyiE6CkxdU7MhFjEBc8oG0Aitmp58HylFYI6I67MOZDVN+yjdCvThNRmgDHwx5U+OhnxSVgvH5mqx/s+ADklOxS1Wu8eTVVSlO14urhlJ0S7D0WYMLKAy1co4+a3W9UxAuHs9LbsGxWgEx6Mt6rROLKvUq6w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 12:20, Arnd Bergmann wrote:
>> For simplicity, I think this can just be:
>>
>> -	default VMSPLIT_3G
>> +	default VMSPLIT_2G
>>
>> I doubt the 2G vs. 2G_OPT matters in very many cases. If it does, folks
>> can just set it in their config manually.
>>
>> But, in the end, I don't this this matters all that much. If you think
>> having x86 be consistent with ARM, for example, is more important and
>> ARM really wants this complexity, I can live with it.
> Yes, I think we do want the default of VMSPLIT_3G_OPT for
> configs that have neither highmem nor lpae, otherwise the most
> common embedded configs go from 3072 MiB to 1792 MiB of virtual
> addressing, and that is much more likely to cause regressions
> than the 2816 MiB default.
> 
> It would be nice to not need the VMSPLIT_2G default for PAE/LPAE,
> but that seems like a larger change.

The only thing we'd "regress" would be someone who is repeatedly
starting from scratch with a defconfig and expecting defconfig to be the
same all the time. I honestly think that's highly unlikely.

If folks are upgrading and _actually_ exposed to regressions, they've
got an existing config and won't be hit by these defaults at *all*. They
won't actually regress.

In other words, I think we can be a lot more aggressive about defaults
than with the feature set we support. I'd much rather add complexity in
here for solving a real problem, like if we have armies of 32-bit x86
users constantly starting new projects from scratch and using defconfigs.

I'd _really_ like to keep the defaults as simple as possible.

