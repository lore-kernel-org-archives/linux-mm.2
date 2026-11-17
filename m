Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73B47606A323
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 10:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oNDMH4Tm
Received: by kanga.kvack.org (Postfix)
	id 99E086B05B7; Tue, 17 Nov 2026 05:05:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94E446B05BF; Tue, 17 Nov 2026 05:05:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83DB96B05C0; Tue, 17 Nov 2026 05:05:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 647F66B05B7
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:05:50 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ECC19A039E
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:05:49 +0000 (UTC)
X-FDA: 85444179618.02.AE80756
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3596C4000D
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:05:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oNDMH4Tm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794909948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dRMO7AVxU78TL/hFGS5+5s8CEx6RVxQFpxwZICKhvPQ=;
	b=8bYzSLTMpJ0CUuRHJiGezm75Z71a1ze/MR/fy5CEJ4HJt1gDKcZRKANfb6XRq9tOX2nucS
	PiBRyE48yjTySH92N69842AFz2VT+4OM8oQkKQAqb8aCj0HOZfZttmCtd+lAPT/+BAF9fz
	UfSVHC1RSmHeMlhb06oucEZ5OgdVZfQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oNDMH4Tm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794909948;
	b=ht6b/l0hWyyUSSAbyzKVOjutGZi00+XXZ2Bnl8Xi7XYahpr6GPrSaR0Bj+yByYIPh8wn2v
	HTRmM4b6QdWHiCjsq6+sHK18vaD1/vCtqnInlbyEfFHnAEjkVOwgjvMCaQ80zIsHa32FGh
	TCGw1RvN//eJp73RmbAOicNnDarvqF0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 71B96601D9;
	Tue, 17 Nov 2026 10:05:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093F61F000C4;
	Tue, 17 Nov 2026 10:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794909947;
	bh=dRMO7AVxU78TL/hFGS5+5s8CEx6RVxQFpxwZICKhvPQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oNDMH4TmBulofP5Si/Uaeg1+OPM+geuBUKSAVlftKp2sFz5H2QJw2jvYyAfrtj/fC
	 /ESvEyb74aVmCRiz3VVOJa+GYivcIjlwHzyAWL04HSQ/HIClD/V59yGhHcHQpUYez/
	 DyuuViW8U9p6qfAE++9uvjRv2azJj3kU5ePGLBljM/9105rhdxD7Hmsgmox9eQZeOW
	 ADNTqjpo3FPkzI+WWllKvcD+srJ9KMPAcp72h/nLlqF0nATO0hNjIfiY0DnDAWA0ZE
	 C+FBidiySrY7ShF/ne3O59d1WxCeAIdH9/Q2Ybcl+Knifz4YgRT2andtldWGnxH3YT
	 wU+sPRw6diunQ==
Message-ID: <495c0d13-1fc3-44a4-905a-0968d64f15b2@kernel.org>
Date: Tue, 17 Nov 2026 11:05:37 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/10] mm: remove ARCH_NEEDS_KMAP_HIGH_GET
To: Arnd Bergmann <arnd@kernel.org>, linux-mm@kvack.org
Cc: Arnd Bergmann <arnd@arndb.de>, Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Linus Walleij <linusw@kernel.org>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Lucas Stach <l.stach@pengutronix.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Malin Jonsson <malin.jonsson@est.tech>, Matthew Wilcox
 <willy@infradead.org>, Michael Ellerman <mpe@ellerman.id.au>,
 Michal Simek <monstr@monstr.eu>, Mike Rapoport <rppt@kernel.org>,
 Nicholas Piggin <npiggin@gmail.com>, Nishanth Menon <nm@ti.com>,
 Richard Weinberger <richard@nod.at>, Russell King <linux@armlinux.org.uk>,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org
References: <20261116124832.662455-1-arnd@kernel.org>
 <20261116124832.662455-9-arnd@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261116124832.662455-9-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pa8a3s7br4yb8oq4s8wa4bo96s4z68t5
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3596C4000D
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794909947-385996
X-HE-Meta: U2FsdGVkX1/RtaNvbOuKDBa6EhEpqA/gBXy7df2Ith4YU4bN4HvnH+8GJgKRcNSpVZRigZ4J9xXHCoXDMcxBtifEhMJ6LmiBQMz0VF5t6Ij4EvF/YSafY+AEIshcDcmmfjIDiiXQmYzZuX//zqVChaP4LyYeCeMFaMZbF1MRmJbSX1Z9kOAI7o4WqmDWaKF85rM6ebKiuOHvOFWd/5dQE7Yu8uGTtErZEa7015HTQuyDEtoc5fj9IPdE8HqQVH+tQkpSmoqogSb0YQTiS/AVqL78Kmcpf+59va6kb7Xqe0B/J2+BcnxevOtUzY+i8cij2YiSDiUMXpNBv9slHnI7NepAd33fP8JzfpjBsiPJ2/tU5n/RKxVQjibLcUjjxhHHUnu+x8L48YERZD3iaYArWuPnRf+wtmlSxRQQAiaatFGjYpFPHhuph3O/BC3BgPf9HJ44+Zed4DfaFVBUGJy7n3mfkBPjely3K6Ooebz1typsU/1slS3+wY6KshRLF27pFBttY9eVIKYMK07alyCA3Cr7r7mnDeW7dbMlhLrG+scgk5mx8g8jpZE7qBWwhPTXYefcwrX1HWVnRux0/jYTlvkzD5hdWwUZGmuVSJmBA+PcYRSq2YyUqhi/DFUH894cz8xxY6waT86qIWKOreePQnzXEzxEGQXh8V5RqWQXBqY9IAyFq1tuod7VJ2nHOhkzMa1y7Jo6m45knLy7n3ZN3eo60qmow0lXtLO3KR3QeNrLt/DNK2J+UGXWE+vb+haTd+C8UYlMG4NKbRCmq6A7KzUrVcv674b6KvjAf8zIYDZ204H22AjJ0NswlAwBv2jF/35w78qj9BaqhuxF7iMli9DRA5BU61ULGOcyaL2VbweNzTbNDK1Ta1ggyWImFVoyE2CAR82cs70qIfvkFbMS7m9hNtcRjTPfIspM0CYyevFoKTQlmE5hVFqeVuD/ALX0IfratbOPj5/+ipm7CDJ
 PU8wLzZM
 kRdq6I2JbH0rHGahVKWLSvFOmB0XED4r5KiGawoXJQMLKw8kzO+0yacMshfKXkyq18trwIJ/Pk9C0dEz1N19AGrKoV3Ipsg84wB9vVLSbol0Ui2XCfs3tJ9ghLzVyQiyHmfBcvVVuV3JHgG7HnlyXtwIuimtFXO2zDJqIBA1T/2LUD5wQ/tzZXi2kocUgl3YS0WUcblZDKviFmECx9YNivNkrZNFgpxO3OePTdFg86jzi+7D5zQWEQqONISPp63jdLqYwQBJ21tENu3bprb/C9u3DxRay3+YjBCwAsFKpI4fxDYT94Or9ltDtOXr8vl/rT+NM+MQcXsys6flTZWF2woOlMYlBYolrGy5o1c6oZtvzc6Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 13:48, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Arm has stopped setting ARCH_NEEDS_KMAP_HIGH_GET, so this
> is handled using the same wrappers across all architectures
> now, which leaves room for simplification.
> 
> Replace lock_kmap()/unlock_kmap() with open-coded spinlocks
> and drop the now empty arch_kmap_local_high_get() and
> kmap_high_unmap_local() helpers.
> 
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

