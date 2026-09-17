Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 190EEC982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 06:18:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1268E6B008A; Thu, 17 Sep 2026 02:18:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D8246B0092; Thu, 17 Sep 2026 02:18:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0AFA6B0093; Thu, 17 Sep 2026 02:18:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C6D516B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 02:18:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 875EC120241
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:18:42 +0000 (UTC)
X-FDA: 85222250484.02.5AD0FFB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 98F841A0006
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:18:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kJtvYv00;
	spf=pass (imf19.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789625921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SiRMaoY3cRTa9MhpKbPocPbsr/YaGM7PATKxMZxjze4=;
	b=bI53WndKMNL3iCRGJI894LbaXehafICUmL9+egbjzkOWXyfOcGW8QEQmc9o326a9Tq2HTx
	aQUb5JkBnCfsm7RIvWQ3w8MZjjt/4iGurDu74U4UZ+KnfCGsCUu3wpkw12PV5uRlNMWqrE
	Vxf5Ar73b+qlo8jbjD0tCVvt+UOOuCo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kJtvYv00;
	spf=pass (imf19.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789625921;
	b=H8abHMB6d8qMVbgxJSQ+wtC5NvK68fHORrhTlZCTQMF/5Q/7sOI7tJ0D7zl36Io52Q6d78
	9Gt8Ooy/LMZONLGPJT07IqfXF6oWT/bHVmT1vmsuRrH8dlhPPwxONG6Pb+bITi6hLzbuvz
	b8x28Vx0mBeeFyTpnf+LqCoPZmLn/M8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA7F41476;
	Wed, 16 Sep 2026 23:18:35 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C32C13F882;
	Wed, 16 Sep 2026 23:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789625919; bh=5r38bdBPwTF0dKcq39wGt84GgYIEr0WGkYnRDt6n+mU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kJtvYv00iOOtQNWrUiPJgkunbZExZ9AoaM+TawX53wEJeFEfHYJnbH9aeFZT81Y91
	 MEMhDAFakHNbfdim7oqxayZbv5pf5JaGb0mBpGx/dtTNOhjzCgL1ulUdTWkr/Caupb
	 +d4+lEau/tWsjjqSA5GLJiGG/qd1lBQYl0PSilro=
Date: Thu, 17 Sep 2026 11:48:36 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V2 06/14] arm64/mm: Enable fixmap with 5 level page table
Message-ID: <pi6o4hjdaz2tndzlx64qvzbgxhuyh3kyewpfetiqnnetbtpzpa@prrxusgc3lpm>
References: <20260907035030.2839978-1-anshuman.khandual@arm.com>
 <20260907035030.2839978-7-anshuman.khandual@arm.com>
 <be1c0a62-4589-4fe4-a500-d3fe16a6e610@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be1c0a62-4589-4fe4-a500-d3fe16a6e610@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 98F841A0006
X-Stat-Signature: 5xigw6rfhknq1rii5a34jidkdyf96ghh
X-Rspam-User: 
X-HE-Tag: 1789625920-516020
X-HE-Meta: U2FsdGVkX19Je4T0eIh+kTsdZMRLQN/OUCp5v/io+uzyjxyk5b+DzEIlDO5+y1FnWtdz7ywZv2ZMeonPiuJPtCK9HBCFywIAwKWfOCGDaYlX0Fym2yc497RlioRoXS05chAkzB7AWH9qOSFMuUouhG63dEwf1SwSPkd78VcJKmePPYTkhk+fESFS+TuI13isZTIq0hwI6FhuJuOyDrtqFlJV/oiUBZ4g+EU14+2KYfUBF+8jl9RS7UcZD38QEdaP+3kWu+L9IEw0AWoI+TmiVO40qxbN2WDhrAuxXxFLsi+xlVZiCtznko+VNnbP+/0cfaVxDRIGWmQC+vjK29pTDBX/dMp0qhCmKpva4f+DCqGB/hQukTQqBtI/3Os4BHC6VHh6f+HPccVbZyiEkGWAXILmWHdT7nIdPfvppQMmZ85/onCbKg3Ja8grfebmHgm9hD11PfBfYD7tpToi/PdH7EUjq64Mp58YMhsm/dWvj4hMLImFUq50TE4xMKMZFnkZz9HTl1rq8rmSqVQvy02cFLj0vbu9WN8H1NzlblDeNQCD4hDgZlJUTaBuAHPJ9EhKBh8C003TJzmclz/gAqfbSYkglWgh5qG1Vi3LbLG7v4/1tzA6xa8RK1dS1hdaXDLIbVGYUnxSg3TUeXw1sB2uxMqL3iush9G3zbMs0ajB8UsamSim/4mQrKVulOZzOWCPi/TuQNRgF+AG+il7EDP4B6X5Ta9Q086RUierS+oFU1nUpmXwPfCwQbrh7TAzcpBZhtDf3pBA2qCZ0QKL2Wzv9tP8rc6ToN4IfCS8iO7rXZARG3jMSlbJVKKO6HYf4votufFZlXEMnbJBsqczj8i0Yj0bSjotrw9JuxOglvdYK1z31h02zHMaPv531EIjMrXAW+VRWziidlaqOyFEqqzovg+iQzxtGDwC61mdwiQuVC14mRsNVDa+N+MTdDJQcacxucObtNp7gMpCj5p61DF
 BQSFM1W5
 0MxnQjpZQWUMU3eKJuLT51vUQFwFxlW98qlsQMFHMJA36hxEdbmwJ2Ajd4E5cz/OyjCYoW2m+7eXxW1Px/R2MZlqGSAeXvUxR+NoFHoRHo8kUYA2B10gIz6np2xfFjhtBMMuWry3XcnX2E2Bw4ogV5PnLqPQl2/1DJgOvs4BTZHa/5ltRO8iJPZWOy250GvOlXv25ZQjVzGcszZN1nC0ye17VQ5aB5HhaeRahsy/M2poJ/dz4rAK10TndYNyfVq3gexif9ZJ2kiZSypn4qdDKR1DceA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 04:30:05PM +0200, David Hildenbrand (Arm) wrote:
> On 9/7/26 05:50, Anshuman Khandual wrote:
> > FEAT_D128 halves PTRS_PER_PXX thus shrinking the VA range coverage
> > for each page table level. Hence in order to preserve all existing
> > VA range configurations, some geometry now need to become 5-level.
> > 
> 
> Hmm, wasn't this 5-levels before, but other code allocated+initialized the p4d
> table for us?

But fixmap was never 5 level earlier.

> 
> I mean, I see how we are filling in another level, but I don't see how we would
> reconfigure something to use 5 page table levels?

IIUC existing configurations which never required 5 levels would not need
this reconfiguration even now.

> 
> > Since fixmap is used to build and manipulate page tables early on
> > during boot the mapping must also gain that additional level which
> > was not required earlier.
> 
> I am no expert ... but I am confused :)
> 
> We do have a loop only in early_fixmap_init_pmd(). So we cannot possibly span
> more than a single ... PTE table?
> 
> > 
> > Enable fixmap with 5 level page table when required. This creates table
> > entries at the PGD level. Add a fallback stub for pgd_page_paddr() when
> > (PGTBALE_LEVELS <= 4) which helps in intercepting any unintended usage.
> 
> 
> Again, I am very confused. Is it really just "As the page table layout changes,
> we might no longer have a p4d table pre-populated for the range our fixmap falls
> into. So if there is no p4d table yet, populate a static one just like we do for
> the other levels."

Right.

> 
> -- 
> Cheers,
> 
> David

