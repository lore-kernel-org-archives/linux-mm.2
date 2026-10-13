Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49B16CC6B1C
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:46:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA5206B00AE; Tue, 13 Oct 2026 11:46:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7D446B00AF; Tue, 13 Oct 2026 11:46:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D93246B00B0; Tue, 13 Oct 2026 11:46:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B062E6B00AE
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:46:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 31B88C0C8D
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:46:39 +0000 (UTC)
X-FDA: 85318030518.29.5CB9CE7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 587DF4000F
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:46:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lRhpxucs;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791906397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0+SkemdQ5RdIVSDhFwk1CDFjL1ey9nZZXcddJZzDyn0=;
	b=0HCozjBH5EIGt+G1Aj54S+w9vDPNrUMBz6waRXLz3JUPe87B7zsC9JWZcjll5zX0Mfatnx
	Vd0uQNNbs4GMQ4E2p5DgxaIAoDGw9br4AVFK5udvlfE3ecEblAJnWs3eNSTeTlPPYPwTXf
	vyakw0eigogzfOLb/k2BsB+W9f/Dgdc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791906397;
	b=pBZ22GU9KBZWDVZBt5tbdSuXjUncfKs88p3p7thvOP7ZSExE5bCoLeZMgXig5+svAnQTY2
	sD4+Ez4/M2J4CkGA9r51udSKUU9ezI0zLlnCIFW0VBWhhYNINpLStVlNiPUxQxe/vowQYu
	7nlCgQMdrxRINAant5WAHIuRJPLWN/c=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lRhpxucs;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 210DA1650;
	Tue, 13 Oct 2026 08:46:33 -0700 (PDT)
Received: from [10.57.13.106] (unknown [10.57.13.106])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9C3783FA32;
	Tue, 13 Oct 2026 08:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791906396; bh=0+SkemdQ5RdIVSDhFwk1CDFjL1ey9nZZXcddJZzDyn0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lRhpxucs9r1hSijFNWdvNkrzvM+4YX3s8AQOkMMLTKiDkd8+VFpyiYfcSLMqt9IMJ
	 3VFIrdHZ8R6/NSTrS86UQbde7kSX4GQddPWf1kMf8bMHsbMZ5DaO09ya3CYUSyLmIN
	 qQRasCGUPcCGBWQSeFCJyxvTeA2ok7m6/IW+K14s=
Message-ID: <3eb77f76-1558-4b1d-a8ad-d25da8b0b68c@arm.com>
Date: Tue, 13 Oct 2026 17:46:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] riscv/mm: fix missing destructor for hotplug PUD
 tables
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Dave Hansen <dave.hansen@intel.com>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?=
 <bjorn@rivosinc.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>
References: <20261010112457.49485-1-songmuchun@bytedance.com>
 <20261010112457.49485-4-songmuchun@bytedance.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20261010112457.49485-4-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 587DF4000F
X-Rspam-User: 
X-Stat-Signature: 96eia7mawf8axyou6gozf6sbp9n6nmef
X-HE-Tag: 1791906397-327978
X-HE-Meta: U2FsdGVkX19dclKS1Q9ob6+Uf9UZxBnicfAlxP3w1fFYgJj8/C1xxiRl0p67X7yXJkYrjjh5aCNHvdsDTkjVmYgbHPHh4o09C+sta8gDCVgMKXiiU+GFkkTOe4n4Orswuohq0X0IubfQkLgOfh/6yLOqcoTq9NgSDL3sDeDpM0n350PdzFSU4Bk59K+lENjdoOERkAH2uYejWNmViCPvTI1F2GP7kTyuNrcd8WG2TGZ02DMIlu1Cz53eIjFwUhaHSlJD01WZtihNVBEoMJV7hMhzmlGYIp3hLn9KhNLXo9DgS/wPiCWJKEtoqQl6vWMNbFO5HK2/XKWU6BV3pFZ+qOj2cPVHQv4nbxJzs+ksBtrhvKmxiIg5/cKK7H1auTeYqDSQnb0YhUEfBp3DepxRs75w+1yj9v/8dhyYf9RGFuBBlctofSIecehKk0CuRuX6OtsV//VHk1koenklzjkOqINTKY5Ly6tag0FfBB71iowYQbVGCsIlSBoNv09s2e1FUtbkJWjq4ifiGWUs6Q/49VPuHIyp0H5wZAazqcFRW7/MOVtIxuFzUIZbqhiYwIXr5bHf7RUxIcphJTzm1F2frwJqQRdkHplA4GXbwBBEBqH4D/Nbo4virfsJd2OomRa31iuf6duSM/gYEYz4SQPeZQeaOMYyDiEgmjXdce8Mv7sMTL/xBA823kHUk0SfSruen325+LMihtfOpQ1tgqe9Yp4kMe2mN0H6yIF6JfZKaNY1trh6Ekn78cxAAJ6scoZ4OnJmlaZ3yJm7zQWTPnZvvGpxDY5gw3qjeaJ85oEEbVWOH2LgSP1KZ5sIjTbwGFRH5gfV3CnJcmA2v8I6OwGPOEsuSAqk9VL8H967SFOQHGfZH/8eXzmuoWzlLgeEGwApdpReRFx+C7c4DoiZH9/1nGpoEt37D6ltLtZ5K3AnwjDe+8IVharELISvzbxVP95BNLzfhEhxSKuG+dv9grN
 X/ioFSfy
 0h8KAXGQZqzCm4EeShPlkz6LxWzzMTw/eG0kS2XPO/Fb/qF3dKcoSIKDIgNBhYFt4Cj+CcZ7X7bCMLi7z43JCMj8tExa4sUdR+tQ71LPyB6NjqIjOJof0BVW5INAgUw7+OS+1fNpMfX3oW3R8d1MQ1Yp/VKHxrifFnXslvH31G50OSeseWfym3f/oz0URFu3SNn6pMK99bS378TsgHIqRxAS7CDC33q/x2jBpvr/G57ocoez+rNEEJIc83iH8CEEMaCRlmOfwk3Tppd3lUy9GUt7OzEUoyRxK6iR1th0/htmcGRQy+UtUkOF3DpIY881fwRcxcyTBClYvb4J6CtasenjQ8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/10/2026 13:24, Muchun Song wrote:
> Commit 8472cc4503eb ("riscv: mm: call PUD/P4D ctor in special kernel
> pgtable alloc") made alloc_pud_late() run the PUD page-table
> constructor. However, free_pud_table() still frees non-reserved PUD
> tables directly without decrementing NR_PAGETABLE. Free PUD tables
> through the common free_pgtable_page() helper so that
> constructor-backed tables run the matching destructor before being
> freed. Fixes: 8472cc4503eb ("riscv: mm: call PUD/P4D ctor in special
> kernel pgtable alloc") Cc: stable@vger.kernel.orgAssisted-by: LLM
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>Acked-by: David
> Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>

