Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EC75606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 08:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mie8jh39
Received: by kanga.kvack.org (Postfix)
	id 4378C6B05B0; Wed, 28 Oct 2026 04:39:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E8196B05B5; Wed, 28 Oct 2026 04:39:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B00F6B05B6; Wed, 28 Oct 2026 04:39:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E60BF6B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:39:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 390B9120B5B
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:39:57 +0000 (UTC)
X-FDA: 85371387234.06.00E2675
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 86AF180003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:39:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mie8jh39;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793176795;
	b=tpgigC/GFoMvVht9CeGaJ49/u2V7paip6QavTCJGEva4QvOtYWj8QJjXGr9LFBjPCIflHH
	7PbsWVb85DY57VMOXLeuxtNjTAeTOKb6Vl/s2exTA66/u3q2w3iT1Rhoz4Y7gFqMPRzr3a
	bVpCKjligJIGjK0Y8WDXLVqpp6BbLpA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mie8jh39;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793176795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EuSPBpfPiwDzYLE9j3bMQIok2xPGQVDesPuFSULAs28=;
	b=BSjNIVEGJYKoRhvN87fW8DESJ4EeNeCX87s0WrDf4jXcf7pMsAYt1/056hZdXUvnzAtjdL
	5ujJp3DUm4weMQlGsNBJLdUye7hOdRCQI61kI6X+vpOcP+cHFoKPD65og3/L0ohr0tEYkt
	fCmarWaDVI0sjA0z2UXnfJpZ9O36bSA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A46060120;
	Wed, 28 Oct 2026 08:39:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C5C1F01825;
	Wed, 28 Oct 2026 08:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793176794;
	bh=EuSPBpfPiwDzYLE9j3bMQIok2xPGQVDesPuFSULAs28=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mie8jh39y/BQE69uPA+3u6b6UyI8Nt1ralfAIWhFNNTRSMdv0XI1QmX/FC3Ny7Qhc
	 ZhQ9zZCJWtKIugv7K14H8T+1uM1GyTD2K+4besn4VLQgQkW0azexi8qFk91TF3cfTh
	 W9sNM5Dbkm4U6TAmERY2uj+6WxDmECEAcWSNnpza1ypv+e+bAHytezpfAPK4IflUL5
	 jgnR5HSXmZ7J/8+Y6XMGRBhEhR4u8Ie9eq1TsMurpfZOGG3BEhRgQYQuQy05WH3QLU
	 lsPjzcgAhHRLG8M9IZ0wwLs9qt3S+cNesJUmdjM1eCXsrG6MUKIAfMCaOzb4Q9OrCD
	 yVBzjZZdFzzVg==
Message-ID: <524ee7d9-790d-48b6-8613-841da042c32a@kernel.org>
Date: Wed, 28 Oct 2026 09:39:42 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/7] mm/memblock: add a reserved-region flag for
 poisoned frames
To: Mike Rapoport <rppt@kernel.org>, Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Oscar Salvador <osalvador@suse.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, kas@kernel.org,
 kexec@lists.infradead.org, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 shakeel.butt@linux.dev, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 rmikey@meta.com, riel@surriel.com, harry@kernel.org, kernel-team@meta.com
References: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
 <20261016-hwpoison-kho-v6-4-f304255147da@debian.org>
 <ato62palTbNjLwN7@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ato62palTbNjLwN7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wkxhn1fr81k4z36qo5iyeja4pst3pycw
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 86AF180003
X-Rspam-User: 
X-HE-Tag: 1793176795-232131
X-HE-Meta: U2FsdGVkX18lrhLVFhQOpEnyYkrY5PQ4hoe7OZPk0sEJo8m2DhTwBxv7bsuo38kilydhy+JjY8esE1Ye1wRI6l/E775Y/kZCNyEUh7Lu1ntiG6R1AVUozgWfYkHqyGKBKRKbO76p8sc4EXNRvlUHiXBp39OOcYgG6BdUDZXQzgVtZ4X4uwoYR/MRowGFn1pMOyrrFYywF1z6PnfUuPLcxfsHru+ZrqNHy+KJsCdpA1G65VwANOhWOIXaBa/H+stITV6GuB10RCVIZzl5Dx5vX2TU3KFuXSdX7p7CGRTWZQsBIAge3FBSf3yillh8TKqmIRPjLK2shQL5l2vOkHSOFfBhOB07nS0RH3owx9BaEjtyjTJIvDA7ebmNLyyjUMFZepNY0VARWSGS7fdZrOAx4EG3enB2SQ/C/sPGpeLP355DKWKht+QNN+PgKQNi9o1SY4dY9I7Diu37yYzx1msINYJnSoS4RCiPa4l8gjsu1eKr01mA79PEX6j8+FRY46opxVjPvy2iK6oGPW9XN9GrrWW15h+ijMBdRit+4yZrFY1CRy+kccODiWRDd36VimytpSEZCdNIudUFwK8eISJ0NofRcoMic2up5kJejsxW5Q4eNNCoR3UluPNNJzAlvUIHCrSEWvidnLbXlxPKj0qNIZ7hz2+bhueNJt7OfYcZG2VItDN1NNS3bjdNz6hqNlCWkA1Ri/s10D07nyaCpkdLlmg56jVBbC86x8/BFhaF8yNoSmp5Oclgh7RoobGinMKUawCIZJ+tX8Vkchx2FC94BySHerTN9cI234QxQJd/2MGbi1VRJI1ZQQ2/AG9juF3VjJeoyGkajKYWXqU+JZ9xrdFBtFGOnX1jwqE6Yo4VPC7uAQxZnAfo/CGKWcZ9R46jNOClQJ6TGHGVTaS4wcyvHrfbgJpglfXxclQYI7xeO8mbv7W+aamLVcLbFH0VdzAZXIR6aAZbEq+iSLdQuEQ
 7RFvYKoX
 WNS99KwNlIF159hT1yNxvzkPY99Ok58FbBI2AEFbiLFiIDpl+puQIhYc3CulPt+oruJAvtaQfCbIYmqhzEtCliJ9gUy4Qriy8sjthOC2/EB1yQDEVS1fBGCxnIa6prY+XZUDFQkwBFK0upwanLRhuhuNxsDZ0HtDSIJEYp3BAJnjzuvmS0VsbQT/KvNrLreOh3hjM4Ruul2cNScwLaxo+8odRB6UqjUaper6lsKV5CdcojtrhR6aFzrOuu5IicBcSkPp/uxxbZKmyihli7j9McdWh62owG4sTkw53+rQm6+lf/pmJjIE7vTuT4EkIxpnY5tZ+Jgrxl/H8F14=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/22/26 18:33, Mike Rapoport wrote:
> Hi Breno,
> 
> On Fri, Oct 16, 2026 at 05:15:44AM -0700, Breno Leitao wrote:
>> memblock allocates from and frees to buddy whatever is not reserved, and
>> knows nothing about frames an earlier kernel found hardware-poisoned.
>> Such a frame can back the memmap, a page table or a percpu area before
>> any hwpoison code runs, and otherwise reaches the buddy allocator like
>> any other free frame.
>>
>> Add MEMBLOCK_RSRV_HWPOISON for a reserved range holding those frames.
> 
> How much this would fragment memblock.reserved?
> 
> memblock is not very scalable, to say the least, and each new flag
> increases the size of memblock arrays which obviously hurts performance.

I assume that if you have too many regions there, you have different problems
than scalability problems.

We should cut out larger chunks, and if they are all over your address space you
should scrap that machine.

-- 
Cheers,

David

