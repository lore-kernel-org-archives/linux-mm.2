Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAD1CCD6E64
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 09:29:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E52606B008C; Wed,  3 Jun 2026 05:29:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2BD46B0092; Wed,  3 Jun 2026 05:29:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D67966B0093; Wed,  3 Jun 2026 05:29:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA5846B008C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 05:29:17 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6516F1A02E2
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:29:17 +0000 (UTC)
X-FDA: 84838077954.12.9EB719D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id CF32B40007
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:29:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aROTsNtP;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780478955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0YKYxaewRvA3lfBC/tETR3ZEPA7XYWmFAA/XZnPbico=;
	b=fV/beArJGT9d7aOtHmhpAJ0XXKBz5q9w52cVlQQRtz8rZLEwKTKt6lgUOQj3rUGrob4eXY
	/kg4LRnOuJ8bLSRCtpewZSB006ImEA5J+HSRUuqBaS3+vSzNjMrI5mjMKJVqFSK9LCqHkm
	eGgTziq0QWhhudmFL0f8tGnAMAvBiRM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aROTsNtP;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780478955;
	b=PJfrNWi5bdrbQz/C3rX/HFX1mVk6gcSYYZARCGCzItgVx0zICq2XgHGMccX96tWO3YElyr
	taqS3v32yWo16wo1lTg4zsWkEjwu0xqtNVqcXpEJrcAleDNUVYUCTkjAD7TKnIB53kkpn2
	SsvDFlplUD5KhcHiquNFTe7UQOfxd0U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E648D4430D;
	Wed,  3 Jun 2026 09:29:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B8A1F00893;
	Wed,  3 Jun 2026 09:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780478954;
	bh=0YKYxaewRvA3lfBC/tETR3ZEPA7XYWmFAA/XZnPbico=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aROTsNtP0NwcPyhOGg9EN7SaKgxWgmBik4nkTEgxduPxK5HRWw3N84c9Y+ACmVTN1
	 wgGQ5LmSO16hd/kW00Z44oqbucTBUZSCI5qkU4XBMgLuDQlQoPU5Q7drqrxWizzv3f
	 rrWFolACkQfVjWy8P7nyYRfKI3cGxZO78QELntbROjZh2g+LwBwdTl5Zzy83wMh8Ah
	 +jsOcKbtZk9aA7P96fnDV/449Ef6mxs1KgAP+RaMN8fr1epn59jCUIuT3pzqyXrl2/
	 Cty+iU235/fJlfaqEQKiPp5aeuN6LGB+fM5/HMK485/qyjL0EeNknVF9PU08lbGj8F
	 jYzXoc72/R2Ow==
Date: Wed, 3 Jun 2026 12:29:00 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jork Loeser <jloeser@linux.microsoft.com>
Cc: linux-hyperv@vger.kernel.org, linux-mm@kvack.org,
	kexec@lists.infradead.org, "K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>, Jason Miu <jasonmiu@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, Baoquan He <bhe@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Kees Cook <kees@kernel.org>,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>,
	Justinien Bouron <jbouron@amazon.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Pingfan Liu <piliu@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, Michael Kelley <mhklinux@outlook.com>
Subject: Re: [RFC PATCH 00/20] mshv: enable kexec with Hyper-V donated pages
 and partitions
Message-ID: <ah_z3GV55RY3ZnT-@kernel.org>
References: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
 <ahxrc4pTvVU20RTX@kernel.org>
 <f9d95fb1-ef3-d4a-19e4-afe7cdde5d1f@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9d95fb1-ef3-d4a-19e4-afe7cdde5d1f@linux.microsoft.com>
X-Rspamd-Queue-Id: CF32B40007
X-Stat-Signature: cwdh6be6hw8hha1uw3rrxdegrfyodxz4
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780478955-842627
X-HE-Meta: U2FsdGVkX1/YrIfDKHuEjgqt1rhZwmxUDSlJX7/vJ1Exfgf0TfFa2b9oZCtXlBOGv/6B7K7A4byKxfr02p1vRbZm9dVkdD4sEQsYo83LzbhqgmyqjlDt2CCYu5efp++vS2Tj25qx3RQklQve1Bitnmbsoy+KZzGdQt3IZIVLkWyDzaNNBVhYbbb+ZBwhzoJstCHuCKmwp4mrjqMg3yNXmpBFvdIwHl01afUxYiZAYbMC8antBJ9h6+Nd+kYNmQ/NVbq/eI5TLC9N5jBJ6J/VaST+jG/P5MqyrmE5aMKc8CZ5DKIPkMDrUiPin1PyR8QzgW47ibukLndelgEDEuBatIioUI02WQROieMV0saOhaWxHL4mD7AkmrXNBn5/CfgkeHAUKliJCojrpT+K5dUPz9cvJO5eFMVUZDVf3vrjh+koz6XB0iCm/24l7XxbohCQ0/JAI65xifnMo1SJuWdPJpt4jC9P13tLyDcrHSpVV4lBDaAP/BqzodV2p/TkBGYA6ssQTns31LR+q/0oD+bxLMR33dUehIAJhsJ2H9g9im6GDoVh2MQg851nPrRiXOSPdI1hfPMM+IF7vEcZSMYyeKicYuhKNN9T2OhoZ/Mmnw5Hojg7BHv7/qR+dqM5k1mw8yPPxYP+M1irGkgLHafO9UQHMBVjJOe3mjn03rXIZv4kpZTe8m/jXBZ6wgY3GPfgMLFzBKM2K2GuRm4mu5PRiicEn95O3+74GwLcGoYlT6vE939mnH6Bag06TwGBROjXCZ0YH8pAm2kEgFGhoCfnjxRSl7VfmjCls4+Pe1lmif2XZG19LPDxvQb4TBEETzkN8j7aeys7k3MYCUUx4DPoocBNZmRVv6q8gpuXPkNlISuidu83UEKNASSaK7o84s9tkwm3CPur78pghs7P/QW+RppZcpL2DvuqCV45uqcqREbBI3TVodd7MymLd1hKiph+IPI9Bqfp6dtnap4wc6k
 BxAbg5pe
 xF7Aba1+FSCkSZ+O27ceAK0Od8zAXMNa+isWEKWiA7Z6EApIyQoBfi+50PqndYrQ/UZ2sZTN0gexEUYy2MEFZuazxsBLFJgEfGj74R2xzl9JFW9EcDY024ssnMVUNpwoVMv3Q0bdwTSgYQmaRrBxqyMCHUQGF8DAkGEQKj6f/3aY6cpPr7NiM2qzqFc7QV/qLPEX6NqIx+uHsjo8/HVW2+l1TVp8mojXOGm6o1KR4lY54YZAXkeuoXjitfVvH8SZgbRvs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 01:09:41PM -0700, Jork Loeser wrote:
> On Sun, 31 May 2026, Mike Rapoport wrote:
> 
> > > Patch 19:      Export kexec_in_progress for modules
> > 
> > Isn't there another way to differentiate kexec reboot?

There's that "kexec reboot" string passed as the cmd to the reboot
notifier.
Maybe we can make it somehow more well defined API and use it?
 
> I could not find one, unfortunately.
> 
> > Sincerely yours,
> > Mike.
> 
> Best,
> Jork

-- 
Sincerely yours,
Mike.

