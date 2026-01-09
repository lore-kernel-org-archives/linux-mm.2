Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA0D7D1A627
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 13:43:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60A9E6B0089; Fri,  9 Jan 2026 08:43:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B8526B008A; Fri,  9 Jan 2026 08:43:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E5E16B008C; Fri,  9 Jan 2026 08:43:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3E9576B0089
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 08:43:37 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 04DCD1BE27
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 13:43:36 +0000 (UTC)
X-FDA: 84312542874.10.4EC8929
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 49C39C0002
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 13:43:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jq8+HDoW;
	spf=pass (imf22.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767966215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FWIjlFv6jJqppx2LoyUbbHVPgKacvPuyCBOajXnJvKU=;
	b=lZAerN69bzupzcldWygKisruogGQMguKHwkeJwWoV/wrB4CohpB2mjUQJO52sfZFlWcFjN
	fyj0Mh+p0Fe7fEFhoPVE85aAK42MtvAT1nHXtyfqCvNOJIwYChLSvxeJRMVaA+B4hfqlb2
	/0OerLPv+iufdRNI0K3kJaOO18UPwco=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jq8+HDoW;
	spf=pass (imf22.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767966215; a=rsa-sha256;
	cv=none;
	b=c5rDtT59qqrzxkP7syji+vD3ukD7KgzAUli4ZEMgP7L7ogBasg1KvhsRv+IYIB6wmdt+Ts
	xc4Qs+ftBBL1VCAt5CSkgrbMj/Ax3bbYFNqt85SdNlS95Qmnabn9IxNWQPLTeZ7VIRNJl5
	wZvTmbbtiD1ypbr6Q/5R+jPNekMZGa4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A75D40539;
	Fri,  9 Jan 2026 13:43:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A0C6C4CEF1;
	Fri,  9 Jan 2026 13:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767966214;
	bh=ijLJjYW1cc6SO67EopKRqCC5IeK0M9dJP6RDnaTpVqU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jq8+HDoWfq+dnQNCjupi8t3wJr3s2gFU/PZ+Mw9p2emhpnvQ4wtgBty04uXbNk61D
	 pNNPamcF60pYnh283bb1GkqvMttXrjLp8u7mPUIvt9NWaV3fpMZbPRnkTuEPT0Llrj
	 8Yt3UjdNFby5p8HerssTXgGz6oX8DulSCX0Auw4wa5TWQHIbb7ZQlnH/wloeDJ6jtW
	 yant4tlpZ7jRtbPwfiDiCLKl1YaqQ1cVNNNBicAEjsz+Qb/Tj7rv3d3L591HucBl9T
	 j/jWJ/WBZe7w9ztoI5e6doC/wmtuASzCC/PVJHwCuzCs4X98ZeSZ/riOmzgPWfP7oR
	 CwUWQShgEQbxg==
Date: Fri, 9 Jan 2026 13:43:25 +0000
From: Will Deacon <will@kernel.org>
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v7 02/15] kasan: arm64: x86: Make special tags arch
 specific
Message-ID: <aWEF_eJ9Bnn5-8dZ@willie-the-truck>
References: <cover.1765386422.git.m.wieczorretman@pm.me>
 <0db7ec3b1a813b4d9e3aa8648b3c212166a248b7.1765386422.git.m.wieczorretman@pm.me>
 <aV_v18YWCHXMETVK@willie-the-truck>
 <aWEDDjQms8zbMgsB@wieczorr-mobl1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWEDDjQms8zbMgsB@wieczorr-mobl1.localdomain>
X-Stat-Signature: ez8ja9iq6nf87hsz4rpu7fhku45yz6ei
X-Rspam-User: 
X-Rspamd-Queue-Id: 49C39C0002
X-Rspamd-Server: rspam08
X-HE-Tag: 1767966215-626770
X-HE-Meta: U2FsdGVkX18j2m6JmXx35pQJbySd/amzHAgT14zocPvHlLzRH8nLAt16I2vHkYCcDW6VaJYfv/JDpsuqqjY9QnLHZUMfFJIvpvMLv64n4KjR/aBUhNwEdDmv90fmBRzLi/pnfzjjG8sK2GZMC0P2kRKYYujAVeRNR2xHoDvcmeh73j1wDbf8EnsrkB9W8nbKVi84ykn+CKvq/21ea0Xl/Az87IACBPdandestfsrA7pL3ddGJwPkXTQZYYPZcfhyx+OzlJCzE3tP7ktyud5d5F8pJznnc5UkpcaAvo4ye6ai9ha5RYg62oRCh9iVB+Jiwyx8xcMMKsLArepr9hIEzZ3W1J65EJuC2LnuJXmoPuAMwCftTFXFggMx6nc+lWKWfDv9KkVl52nseQECbCcVlnDNkUhJD5e1Svptkl4D6jr2D7qzmjA4n96ovqCL392UpFTRy2GM8FqXGH1a5Fya5nLDLXxIRMrGwzgBj9Ft1ASi2+yESKJyCEpPT5oW3JMGxJpm7wHAr04bqDYmsvAO5PD5RcSYj+3/Xp/7bo4sGJG1bWn2O0zicn9TpedlkYYABJ7o+J2tFo/1Kcx2BkaF0c4ZCRllD+xjKVITZsFdKL9fBBwRlumWs1DQJAv/SzQHHcqfr3CW+DlTg0uP1c5lgswAnGn6h84WQTMMl7uKzbk1rcI2YviQj8F8RSf4Q1jGDOvkM4f2NZkT+BZhUEQFwUTTk8LXG+dZUBX4oH/CaA3CzNrTK4zsdaFkq0QoaagbPNxJcXse18RdmceyKQ32utUwbtLB++YdzbLQk0G8cXZo6edqkJaqr82fapvNm8oVcrEvcetF8g2FQfPi8PaDNEXXXd+vme2XANxAsNrR3NR4MCpaiGCIXMeW+8Ba//ZXvwQa4GRMRqxo1o4eKyubEESR9QYk28hw5yoBMPmifcNhq/zX2Z/M1MWKdhtNp5K38NdbUUq2Ti1j7c8rJbh
 QyAJhHdp
 46g3ukKjNwg3m59+ZpGdzkYshg5rvdRPTNyrOPyYBas+3TPRdzYaxzWppWXIVMy6uc70UnLM8pQH2sO0jBoXlv67/0LelKAg1S3ZKSQL+8yaYSXuW0LhBhU8jGJXcRs+Iufk4z17svv2Z+HSVq8RLEj/vXcCMfLS4TXf4NWlW+MqCa8tsg7BUGJdDA1CmR9OVMenpRmvlIbaH5VwDhjUMDPuCQHzZD1FAANObv3P/QYPrVYaBJMK8K5JYqserQldVCwbnI5FYM6OW2fhEY+w9gqqJfxiI631P5z/qcLRJo8TaCjRYPuQBwhS0FKTzVbUX1+Ve2hS5vbMJ4GiFnFgDyO4fbmHUXplT81RVD8qLhfgKHaBmxb+vn8rZaVb5/MPihKopOuYuV5zoY6j/GdqNoSoUbA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 01:37:49PM +0000, Maciej Wieczor-Retman wrote:
> Hi, and thanks for looking at the patches!
> 
> On 2026-01-08 at 17:56:39 +0000, Will Deacon wrote:
> >On Wed, Dec 10, 2025 at 05:28:43PM +0000, Maciej Wieczor-Retman wrote:
> >> From: Samuel Holland <samuel.holland@sifive.com>
> ...
> >> +#ifdef CONFIG_KASAN_HW_TAGS
> >> +#define KASAN_TAG_MIN		0xF0 /* minimum value for random tags */
> >> +#define KASAN_TAG_WIDTH		4
> >> +#else
> >> +#define KASAN_TAG_WIDTH		8
> >> +#endif
> >
> >Shouldn't this be 0 when KASAN is not in use at all?
> >
> >Will
> 
> This file (as well as the x86 version) gets included in
> include/linux/kasan-tags.h:
> 
> 	#if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
> 	#include <asm/kasan-tags.h>
> 	#endif
> 
> 	#ifndef KASAN_TAG_WIDTH
> 	#define KASAN_TAG_WIDTH		0
> 	#endif
> 
> So the 8 or 4 value is only assigned if SW_TAGS or HW_TAGS are enabled.
> Otherwise it's set to zero.

Thanks for the explanation, I'd missed the conditional inclusion of the
arch header.

In which case, the arm64 side looks fine to me:

Acked-by: Will Deacon <will@kernel.org>

Cheers,

Will

