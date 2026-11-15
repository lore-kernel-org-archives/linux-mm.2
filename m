Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E67B606A329
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 19:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zlr8cphp
Received: by kanga.kvack.org (Postfix)
	id ED89E6B05B1; Sun, 15 Nov 2026 14:14:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E89CC6B05B2; Sun, 15 Nov 2026 14:14:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D784A6B05B3; Sun, 15 Nov 2026 14:14:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B8E476B05B1
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:14:38 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2BBBF40802
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 19:14:38 +0000 (UTC)
X-FDA: 85438305036.09.67B2C6A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 887EAA000E
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 19:14:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zlr8cphp;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794770076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bTYAm4EWSRHx/ZHXwlhFob7m+xxSKwh0NNHvPVL+4a0=;
	b=pO6CEp+jDeZQN/O34K1Z6II16d6No8VkF3vssv/PmckAVsdnAawMnuILQWU3BAWoFsHw44
	dpttdfN9HD82bPapFOKd/jClcm/rVxZjflJtAHewCjqW3bwli5eEhtIaucaUAM0/pxpitF
	beBDtWWDCs9gDTKyJ7QxEmw4xS2w2Hk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794770076;
	b=BfyKOH9FCWfb20Kcdx/XKfqT2OANCKtZXzkCxavdIC24bgtbcw3FS/HoQOJrdur/7bMPkH
	3HvyOjDs650Im4Ns97jwbyAgD/Tk7FmRACvWI7PCpk8d00yDBKBNjyOaTNV/58fHaqjCO7
	UyQjoXP/duu9XPIABwXkHAP4zCUfwGA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zlr8cphp;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B2ABF41664;
	Sun, 15 Nov 2026 19:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2830B1F000C4;
	Sun, 15 Nov 2026 19:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794770075;
	bh=bTYAm4EWSRHx/ZHXwlhFob7m+xxSKwh0NNHvPVL+4a0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Zlr8cphpaQd3nqY4dD/M8LKmVfhEwBhg/RXnFS8Dbd42j21budIL80Fj83ujynYBi
	 xrkpXbt/vgXXJ3zbCIgd0vytWH9UFZRo+kWYg6+zk3Dgh5sXkP6sxBNtPVRWMc7kgU
	 7c0cXcpkCgnk34WxtxAQP15i7VF+f+o9Op3gqEYw8sVFIZUZZKKEE/DiCEBd5NJmBL
	 eqWix0PI/yHN1v1kle17XH0UgF/k5g+OojdNRy9zlUqHohW/kmiciG1CH3WaxOOynl
	 GtOjVUG+IaqnqKJMnuActvv+XKVHz8jIHWFruwvUHIhP9DWwGFEUc3P4bbqJVKIINp
	 h+RZkJC+eVaDQ==
Date: Sun, 15 Nov 2026 21:14:25 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
	m.szyprowski@samsung.com, jenswi@kernel.org, robh@kernel.org,
	krzk+dt@kernel.org, conor+dt@kernel.org, mark.rutland@arm.com,
	robin.murphy@arm.com, hch@lst.de, ryan.roberts@arm.com,
	sumit.garg@kernel.org, sudeep.holla@kernel.org, ardb@kernel.org,
	thierry.reding@kernel.org, david@kernel.org, danielmentz@google.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	iommu@lists.linux.dev, op-tee@lists.trustedfirmware.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/8] memblock: Introduce MEMBLOCK_PTEMAP
Message-ID: <avoEkRRM3iH70_Am@kernel.org>
References: <20261111110738.872947-1-vdonnefort@google.com>
 <20261111110738.872947-2-vdonnefort@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111110738.872947-2-vdonnefort@google.com>
X-Stat-Signature: 4qmjw7ezro6eyztgmrg74ygp3e599xey
X-Rspamd-Queue-Id: 887EAA000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794770076-511221
X-HE-Meta: U2FsdGVkX18MPpp29zmiMktwVaPrKpoiKCezaB28OJj5p2fND61L18OA1CNDuMJgRjf1QgTAcM0n30Kejz5nL1/FwtGSoDCgpyFg1ZTE0FOAuVWxv/cU8aWanuU05GDePoGoE0MAp0TDkdn73MEhp9O0ol1koCfYCQKiYhhQR29e/UazdGXyrh94f/NvMHN018V96YLYD8jviCYPrkD/UqPPFE6Lz8gv9Av0srfxWN4CAoTgc7fZPaXTT72AIMC21NE64LAoK8NeDw+aiyq/4uBCCQ+hxH4KsCI16Vx6ZMcon/ZG5V+MAeBN9BRRBtg3TH0ssjMXWs8lV3szyQUpT1Lo29GzM1Bqjp31IywAl0M/Zxpqt5HIWcIwOlHZOZ5aOq7o70s7O7+rUmzkqtSU6YvnrMEYwHZFGGlHIMOj22qUMpYZsmIJfyO2OAi3wLkbA29vO43tjF2BfpOD2wX8bnBWHKctAq7Hs7NVAaLmGhVT3IHOlZF27g5G8zao7y3MlM57e1SfdnWoC8rWXXgZ2dGmFpon9zG4uhKSlbmBpu9aLlyziIf+OxlIc7YShab75D385/IZqd+NEX/hCdESklDGz/XVhF3v9geJwu//ueLgO/vvYZiX5N+Wk6AW5TSM5FOIw2S4O1JOKGg9cII8ufQpg+lVY/g/M/q5cuseFf7Zj5DY6c+mXd0g3na6slSJ6SERCXiMPy1HRZWPVTfkIfgDjHc3fwcJ+QUOSvypXW09XrXVZqxt+CUwrgs3I0c98PofWUC3Z5cXYYJA7O44xHSIXSBX6CzDq8+5FDA8m+5TpBCrT4xct53YAoRK3PC8nnv1TfWNsknMJIbXXJNpur2ajRVXrqV7BYjU/GQvP9wrMfCRW55kCayFfuaaO8GR0RF48yLVXP9gGt/38H2WP56dMx4NoFZEvmSeVOApeWnWx4C19+ujXs+pSZWQtn8Ho+sa61tEpvdevz5QGU+
 TifNPWkX
 D4w+4pd32eV7aOSQXVJhmU4XQ0RAoS2iwgcS3KMRrNAdQngPARC//dkp2D+9qe2xdSA/CXlKwn9MszrtEv+5gP1CAEw0YuqTyWwUcpaVQ+sCmmMgM/qu7GK3+i1DDNjfvEIBqekDgsblG4CAlHTReJWA5EfYcnf5LrQeQAo4jW9Fd6RflCZRxSzWkpTRFQBmQx6PuZXd5G+KHvrQ/mHAm21PuejS1iH9qd8XKkMjXY0dAoNQqteLoJgdb/FlQgOy+OiEuKjzfr/nhR+odQTe0mbZnF8RtJ0Ih6SCpBpY5nc9/fRiDXi+IqTxFG2PB6128txH3FbgzU8/zITkUP+fYU7+C8Bc/PiY80NvUmrsGhLDC8r62zsc1BRSZixhDIVm5F09XEF2YNHEkhtfoFsa2UQRCGI9sBc7mgNZTIzqQJkZArNjIoBKUK6KydBOnvxOz/yrTlMMDa1btq7w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 11:07:31AM +0000, Vincent Donnefort wrote:
> Keeping PTE-level mappings is interesting for arm64 as it allows
> mapping/unmapping pages from the kernel direct map without the risk of
> splitting blocks which, under the break-before-make rule, may trigger
> page-faults the kernel can't handle.
> 
> However, mapping the entire direct map at PTE-level is costly. So
> instead, create a new memblock flag MEMBLOCK_PTEMAP to selectively apply
> a PTE-level mapping.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/memblock.h |  9 +++++++++
>  mm/memblock.c            | 39 +++++++++++++++++++++++++++++++++++++--
>  2 files changed, 46 insertions(+), 2 deletions(-)

-- 
Sincerely yours,
Mike.

