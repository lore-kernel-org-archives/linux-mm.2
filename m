Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56039FC981D
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 09:00:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98C916B0092; Mon, 30 Mar 2026 05:00:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 963F56B0095; Mon, 30 Mar 2026 05:00:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87A3A6B0096; Mon, 30 Mar 2026 05:00:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 784F36B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 05:00:51 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 97A87140576
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:00:50 +0000 (UTC)
X-FDA: 84602134260.03.178E886
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id E3D8D1A001D
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:00:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WyVV6yho;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774861248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tNRac5Q0bdyEoztagZPdambBGiK73kwsfN5Tdvc35C8=;
	b=2pZnNT2UAxl1T1677uEdimlmnrLlsbuR3XeCeVbLxzlNZhNQi3k11aNrBeJD2QkTgwgaH/
	2kHAODXuISTHw2VVTjUf7dmpe3SYmI/BxbC3AKkJYEy/4IExx0IXPMPS9Y+8SLqzZg2y0e
	JiGnVyUTRS8s6GieLYfCx0v26m8vdgc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WyVV6yho;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774861248; a=rsa-sha256;
	cv=none;
	b=s/Wm+snIXFjz2onviC3eF9i9KgKK+z1D2IcMPBahhH68RJBw+ZjW1+7csBdEzp2lunzmdH
	8oKN8BRU8MBPqoBTE50ImEDG4fAKKYYbnkhtpHy4T6uHtYmLZ60iYgiBG1rgafSm+gtoCa
	tEIPa37LECHGTVzuY0oON3+Xxb6xoPU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 42169600AC;
	Mon, 30 Mar 2026 09:00:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29BC8C4CEF7;
	Mon, 30 Mar 2026 09:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774861247;
	bh=kryiSL0c5gWoP5Xn33RlQGuB1fDy2r29C8AZwGGNizM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WyVV6yhoGLHl2DGlMtLNk2PLvv1LoFNZHT4upzyLknoqI3XroAjHB9I1ha+vU4mPX
	 jqLByu7cdkfcSBvwjAbgeSA7t1FnsQjdZlrHnf9SNnPEyV8aXCVfzuhI/9ayog85j2
	 ZCfecMUhBhB9NayIQbTF+29vTra1H0L8yHpOy9Fwzj1WruGul10WlXsrznGUH8EUO4
	 yAVoSQA1pK/w43OyYruiDlv+uPCsaxYtmh6p3C7asR9EeKI1wjuzkpsIcL4izJJluW
	 H7vlwohlhoQLLz7U0ZJ9f5WNsHXklzmi3Z/jx+6T/BWbr7v0B1OnwuC2GYBfZcweMT
	 Fa1JpYbf/eG2w==
Message-ID: <b1c93301-c12a-46a6-ba92-53e8f9a28022@kernel.org>
Date: Mon, 30 Mar 2026 11:00:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/9] mm: move free_reserved_area() to mm/memblock.c
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Andreas Larsson <andreas@gaisler.com>, Ard Biesheuvel <ardb@kernel.org>,
 Borislav Petkov <bp@alien8.de>, Brendan Jackman <jackmanb@google.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Christian Brauner <brauner@kernel.org>, "David S. Miller"
 <davem@davemloft.net>, Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>,
 Johannes Weiner <hannes@cmpxchg.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Marco Elver <elver@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Masami Hiramatsu <mhiramat@kernel.org>, Michael Ellerman
 <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Rob Herring <robh@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Saravana Kannan <saravanak@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Will Deacon <will@kernel.org>, Zi Yan <ziy@nvidia.com>,
 devicetree@vger.kernel.org, iommu@lists.linux.dev,
 kasan-dev@googlegroups.com, linux-arm-kernel@lists.infradead.org,
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, x86@kernel.org
References: <20260323074836.3653702-1-rppt@kernel.org>
 <20260323074836.3653702-5-rppt@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <20260323074836.3653702-5-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 8giwn7d5ijwmreaqwz64txhjo6n9xph5
X-Rspamd-Queue-Id: E3D8D1A001D
X-Rspamd-Server: rspam09
X-HE-Tag: 1774861248-866512
X-HE-Meta: U2FsdGVkX19vQTbDuxBZw7lhZ+aot9GJ8iOmbATlud+Iz5jHlNctxbj9Vkt5FtVPagwxzu70qae3C2KAH4YR/CvMIaWL8CC8IyRt5cuJETHMpehybji1RgpKcyOBTvsognPdmoT3KtcwwBCTBStqJc1oC8F9AAAmlJebwZVcQbIjzoC19oaivHq4tyeatl9kwVrbvGiGGwrD1l0kFSPHWd7fLstZf72VoL0PU0c30dyQKDXw3aHGUur7jpy1wmHHJTaMTrzpbvOlBOacd3hpe+uyiszTpYw2PFs9xf/vKiL85G4viht5mLewuHZ5y0IZEXO26lHDAZZWpt33Ve6DhfniO40/lDco64s/ZdjKeX3ovzIaH3D37pCcrVC1HcZBgNdWDEGNVYROtIMde2rVWWwFsZja4pinU3IWrAAOXkhbf7OBkb7FSnVuutNi/2NiBarxoqeOCSIQP/Bww74kF9bZxz9dk6z2+FPUCeWpmlrfKapghGxhOyute2GTTgk9+Beh0TrWazYl8KLHyUz3Jg/BYUPo1zArMmmKM7I4Pt0hzr5uBtWVt8V0IRGLEmW/fvi9w+nTdYOE8GjiKYh43DHf0GIvQzU0AhbD4f5SKdzX1eupfufV7ssPbHA1uWTIWM0KYFWl9s5hrSLnMzjjjGpzlk/Ii9CZkXx3UAeDBWH7XbOLqR/sDl1GPzuVQ2aHIIk9iD/8JGRl1yynBN8dRBIEYbvCJBTOWkrz8B5Hi/KE5pJZqGcsZBxQcckaq1jkCyssfUlG6O1oHMiqfgaCh02Q7lA0qTUsKWxlQnJLFK7ySpBJIMCciwkpnh87H7usyA939o2aZATpfE75ZexjpsVQlwW0UjhINViZtw8D7B1B/rwG7XxAnl2B1XZYoHvbXI1RMuq+dj04ADw0mbeVoyKBUmmLzEzcnD4ZKArT6dp2Igr0DKEurG/nQ8Sib5VkbmvsUzNyjv/Y4MdxVQu
 qRJMuqKJ
 pL7kAPbxbxcrXsSGjQcQKRFB+sk5wBjafO+twaEPev3pmqFMG5p1/2fRdBZXgVGwlqyriDzWhF0FJrzHBAVflBIAW/s4/HlwnUChtl6QUgzoOUWWcq0vtiWX3q9QqKFfRqUO9VqCgTxv5fqWU2UxmQKwJrw3ejvhm9rb5AF25Qc9KjLDrzfHEGPxYiPzclgEtwHxVgnfrV6I0v7OniFAJVroE9pRGJAYSBkol4H8hYrTiGJGupWpIujP02UP6NK2OoZyFYLE8bd8r/kmjeu48qu21hcLI67Hj7OlGitBIpN2SFLk5OKYM1g38j1iN3FU38sXXmyAMUG5pMIA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/23/26 08:48, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> free_reserved_area() is related to memblock as it frees reserved memory
> back to the buddy allocator, similar to what memblock_free_late() does.
> 
> Move free_reserved_area() to mm/memblock.c to prepare for further
> consolidation of the functions that free reserved memory.
> 
> No functional changes.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


