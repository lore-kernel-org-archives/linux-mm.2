Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60623C5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 16:34:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 706816B029C; Tue, 18 Aug 2026 12:34:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DDC36B0336; Tue, 18 Aug 2026 12:34:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61B466B06D8; Tue, 18 Aug 2026 12:34:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 178F36B0336
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:34:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A2CA7A011C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:34:08 +0000 (UTC)
X-FDA: 85114937376.20.E0D3DF0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id BFA80C0009
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:34:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QJ1erU2E;
	spf=pass (imf22.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787070847;
	b=SIm6N2pFWKqp9w/yhAxRkHT7zuY1Q/2uOfYY2U6lmMxD/csm9k4mXT0TnatkDzB1c6+dmv
	Sa5nxS4pOo4qsbfhNaZ7zZaQ0YF4XmyUAicC2P58sOuQkdfh1xueiT940ayd3VGJnBhON1
	rWP7HoUQwkN4lIY32h9iWXZyA+pPK2Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QJ1erU2E;
	spf=pass (imf22.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787070847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=owzmUkDB0UZwHfh/mp1W0vc+6IvE+QEuLxbybZAQPWY=;
	b=LJCOCjB8ZIm8iJq/LHzkNySZnewn3TxOwqyz7K1AluNF5zoHn1qQi6uAwJ6HR3rq2im7pD
	BGaEqtNsykdSO5BzbS3CvPdKrSRslKWUDWo3+Xm/ZMXAV4jRd/kAERK2VsjiCRPYr1yHSu
	ie6U7TpMzPfY0q0vKpnIXTjOIhy3XNo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C893D1A00;
	Tue, 18 Aug 2026 09:34:01 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9EC663F85F;
	Tue, 18 Aug 2026 09:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787070845; bh=roFDoKpIkkJ7bFHN1815WLEntXi/XSfb52O3DVWoU5Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QJ1erU2EjXBce91TN7aGMwTzVUyboExPz7I9asApP1cBlfCRqrlh4mDRXGFUKQbVC
	 2xmOvd1kc1becHOtol6vpq529+9g5Szv+t9bVESsXstMxjCUL1zvyrvEKnT5055PFk
	 4EkA0pbBQHw2CWShtLCigBmizYAWquRBMybh2qQc=
Date: Tue, 18 Aug 2026 17:33:52 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: James Houghton <jthoughton@google.com>
Cc: Will Deacon <will@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Linu Cherian <linu.cherian@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>,
	Frank van der Linden <fvdl@google.com>,
	David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 12/18] arm64: Implement try_populate_vmemmap_pmd using AF
 trick
Message-ID: <aoSJcAFMNJ1nPl2H@arm.com>
References: <20260708031129.3503195-1-jthoughton@google.com>
 <20260708031129.3503195-13-jthoughton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708031129.3503195-13-jthoughton@google.com>
X-Rspamd-Queue-Id: BFA80C0009
X-Rspam-User: 
X-Stat-Signature: inq179dezn7i3fhousf7cwgtbteukp4k
X-Rspamd-Server: rspam06
X-HE-Tag: 1787070846-837205
X-HE-Meta: U2FsdGVkX19rNoTLQE00M1Xo5gyaODQqHeOvcTKwuXX7nt3YS3DwTg6v3cGQ+dn883oyJuGO1oVzE5gOBfIOo9PyudIWHKZoU6c7fWILOEFpn9N74tDZntVBkab4QlMcCvSYsJq5qJVAs/TV8PXnu9s8GtxhxpTZijI2YigivFVIIpwQ0mjkY9MRgGvZu9Kis+gkokCn9XaVQlmX+JOpsW959sZeGGjFZunkm/d4JmC0zWBZueZtn5caykEo9uVREIGMPXLlPpVHGw8gxkHUtQBmtDY+CVW9kqlWX/XHWWp9dg62c2+fq6IIYwgNYd7q5k0abr14TfEtbNpE0KpJUxcbbH0qaqGT+vkzeOE28Q2h5rJhXGSsNORmkVDD3XmyOOJOWZLBCV9YzrmDnVHetrOSpWcg5sQFauaBlP3qsjYQa8jvJBogLQ/VsKM9NUib6R5ErEZRcdSsHUyume2rV2gB5mWbtTDEMM/BRYxOLV0xB6+VZ1laS/RcxNPUaVqlqmlkLId0eHh8sUJppNR1AA5lC+QDzS0kp6FlFMbTg2TtCNl6Ie+yeEHBZq6laOQTz69ARDlYkPK8xVwcHAP53wykQ1kBSRdfb4DtoS3VM+IV6DJjbqT4vZ/FLYSKzH0Xnxqjsv6E+5BO/s+n0QqDD7YsspOrkx08/AJdP8a2pC8GQru1BHdVJggfhvG4BARnlWPdOpiso8sFHWIePZcetdQNO7/zDPqPYjRyiv723pG0hEBlXPsOB/baA0HCDt/K93H5eTEEbzB5M0cTli/OM5pXTF1X+J491+sZ+f0TVcX93TuCgSwI6GKDwGufJIrqNOt1BhLMuFKEYGWg0yuPMU8s4pqR6+hM/BHUZRoRLHd+JbcsjoMZ5brJv8nZdGbcVPeDGmcnJ/3gSMkN/5av9QmKkCTbRcsjYfyHxYypUhuDT1yUr53DQpJvr9tRTVLZHzctt8RWFczelarWJSu
 +HbzstQz
 s79rFdqksNyVBlU9F2dTpkkR9K2/Tg1D06e9+MJbVZPVWUkw0tM9s4N6xzs1s+8nN/oAcgNT8QNvU7/No+JaDBjBUI9cI14SRkwweo6UerocKhWztZNwChGQ0grOhbi0LHnNtoUig8FdyJ3HGVy4YFGIpZAbWJKl6KJwoClQ25mf3D4atRn0IVXJAWZgnIVFZblZUkx2vBBalmF7pKf7BEpR0Y456RQtlKSWRjucXI/GYhk3qs6YocowxPaVpdxG+EKS7tZQf2X2kN4qbd677Yt19Gw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 03:11:22AM +0000, James Houghton wrote:
> This routine is to be used for updating in-use, leaf-level PMDs in the
> vmemmap without introducing a window where vmemmap accesses might fault.
> 
> Implementing this on arm64 requires some care: use the same access flag
> trick that is used for vmemmap PTE updates. HAFT is not needed and the
> TLB flushing routine remains identical, as we are not overwriting a
> non-leaf PMD.
> 
> For systems that support BBML2_NOABORT, there is no need to use the AF
> trick.

This part needs even more text in the Arm ARM. With dropping of the
BBML2_NOABORT requirement in patch 13, we are left with the D8.17.2
rules in the Arm ARM (M.c) requiring BBM. I'm not sure we can infer much
from the AF=0 caching rules as here we talk about the walk caches. For
example, a walk cache memorises the VA to block descriptor translation
and that's irrespective of the leaf entry AF bit. If AF=0 and you skip
the TLBI, nothing flushes the walk cache which may confuse the CPU when
it suddenly sees a table entry where it expected a block one.

If it's not critical to the series, I suggest we leave this patch and
the next one out for now.

-- 
Catalin

