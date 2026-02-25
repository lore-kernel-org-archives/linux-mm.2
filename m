Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF780EFD206
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 08:12:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C72D6B0005; Wed, 25 Feb 2026 03:12:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 174916B0088; Wed, 25 Feb 2026 03:12:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 098236B008A; Wed, 25 Feb 2026 03:12:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E55246B0005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:12:36 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8EFC11A049F
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:12:36 +0000 (UTC)
X-FDA: 84482262312.02.76C2FF2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 00B374000A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:12:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772007155; a=rsa-sha256;
	cv=none;
	b=7SMMBayfW4ZV8XQX/+WzJ2UfvnFqs4pGLQH3eRrTUFXlZq+6lHWJCVVKDwiOxFxrMe/QIl
	k/NAmI56xV05kLUNAr7PemIuKXH9iyIJjFIkNLMhrk80NhqTdsFbsNHPYYZiIyodm9mi6m
	R3iG+jRpexeKVPmp23dqxS+h5aP1DiQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772007155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=26Heb3z8+JRGyYR/K9qQ4p1lo9b1s7t7d4idtz27MvU=;
	b=v9qrM+c5XjigMpdhI45i/zS48wqXP8E8LwGz2M9H+cU5vqMUtG/A2nkxY/pOkJkavFnYdZ
	vOA3m3zFTl2AJj96bLltdgEb0CGYnEvqc0+oWbSXpykruRZrztaMRt85vnBOLs+72U7weY
	rW0lt660005tz68F9l7BIP25Q2xzBrU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E79E6165C;
	Wed, 25 Feb 2026 00:12:27 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 40DC83F59E;
	Wed, 25 Feb 2026 00:12:31 -0800 (PST)
Date: Wed, 25 Feb 2026 08:12:28 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "david@kernel.org" <david@kernel.org>,
	"broonie@kernel.org" <broonie@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"debug@rivosinc.com" <debug@rivosinc.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	"bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"pjw@kernel.org" <pjw@kernel.org>, "alex@ghiti.fr" <alex@ghiti.fr>,
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>,
	"will@kernel.org" <will@kernel.org>,
	"tglx@kernel.org" <tglx@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 4/5] x86: shstk: Use the new common
 vm_mmap_shadow_stack() helper
Message-ID: <aZ6u7LMfGmExzhS4@arm.com>
References: <20260224175800.2500729-1-catalin.marinas@arm.com>
 <20260224175800.2500729-5-catalin.marinas@arm.com>
 <eac72941ab8d9520cadc1b98bdcfd7e5d2ef14ca.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eac72941ab8d9520cadc1b98bdcfd7e5d2ef14ca.camel@intel.com>
X-Stat-Signature: 3egsaghsiqkkaeh3hr15w1fkkbqtrksz
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 00B374000A
X-HE-Tag: 1772007154-535377
X-HE-Meta: U2FsdGVkX19pk3a4J6oZZkZeVI8fVGdbGHIJ4XCgZphxAxtt5zLjbPt2rgDgZjfUT8BLIL95nzLsoBdF+dZaJASF1Vnj0verMg19gpynonIeQXRK/t6epW72k48wAdwsjv6K+NefIWnDoqhFxeUx8Awgxvud32gnTAOoJLmOUP2ktPUMMe5gJUXNVcK5rcTXp0h6FlMhN8+ca60fclkdJI35ukQ7ppYnQaB9lud700rOQM4m+kpzoqjH+4fY9rjYDMQOCIe2zWY2jMCW+XndLlNyCYGrpnDWwJnwhMiD9roYozpD4JMIhXTq5PcdeneJtCbwNX4GnBL7T5P/mJzHH8CSH1MbRLR5xLfZXQHuSUpwPj9+fq92LiAjJN6fnulTHoypv/w9Ni5wrwgT4icmuIhAZkRH03Vb2+Jvy5km9DBzccfVCt/ok6+qLYuE+lZpZ6n/lhZjMUznFf8LekunXEXFjeQIxgt1J30SupM3kUfdpcbuAIVxZ0FB94JeGx/2SrJDX5eutSztIzxVoUVrLj9+jQzXOi9p48RsnrPZFuYUuyRqR6J/0UPKbC+doQe+trbM49PKYqrtg027YedftBvMAg09qxD5dfFZ47vSr9XxqDdWjlK6f7UXLsTrAdxL/wskRpqUlu69BSYXetWIXld49e9d4Ss4Vin/KYKP2tGG5fI8GuZy5lj9vDtfFyzcbG6mp0Nxxf18mL/K2FW4uwXw9QXv1tYyqeh5s6MICIH+zTyCD85w3tml5vbxGPGSRqxvk21xgOmg/fPpfQDl7z/cwAVi5LVlLqtH3wCh+rAf2xh6U/MgGRBUIr69Ok3IyPoXF+imDW4p8gsA/ty09EbABAy6GOFL80H1gUiahc1q1g+LyLojn7UK2M7KDLNHKqVvqqtXQB6emaEz/cVnMJLTkIfWIelsYiPBhO9RNDKzUoT1tAfRji0Cs9eThcPH0sRDYpyKHF/DoMDA96E
 vfTfpTKC
 p0ZD9WlXGbWlys4i8G1IDTfp5H7Wmoie6E0QANZ47CxPZGaHhEiJwUE+Adbi+qRf3IUOe6IvPV2icAoZA9VTkrrjBR9I1UhslTSUmoGg2YnyHF/3qFitqUaGb1mM6LZde9pcpTPRIXIso5wly0+32YK7IZwPYLshxY4yuoLdnnuiamv8zfSqIj9LDfKdVJHhxbbw3NjpFO5hjU8QzUcdcIGW1MdotKmqBh8WCrFtokv0xv34fd0vkPatVjAo2PfGYIo+d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 07:47:14PM +0000, Edgecombe, Rick P wrote:
> On Tue, 2026-02-24 at 17:57 +0000, Catalin Marinas wrote:
> > Replace part of the x86 alloc_shstk() content with a call to
> > vm_mmap_shadow_stack().
> 
> I ran it through the selftest. It would be nice to have a bit more information
> in the log, like that there is no functional change. Otherwise,

Good point, I'll add this to the other arch patches as well.

> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>

Thanks.

-- 
Catalin

