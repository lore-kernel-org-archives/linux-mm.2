Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C50F6CD5BA0
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 09:06:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28CFB8E0012; Thu, 13 Nov 2025 04:06:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 265128E0007; Thu, 13 Nov 2025 04:06:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A16B8E0012; Thu, 13 Nov 2025 04:06:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 07BEF8E0007
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 04:06:52 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CCDABBBF2E
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 09:06:51 +0000 (UTC)
X-FDA: 84105003822.04.31EFA49
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 172BE40009
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 09:06:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rMMueHiG;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763024810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tQIM/gVT8bEh1AIFFJP7OHT0HrfQikPAID0lgXiSsVA=;
	b=wTiJUbXJAH5YuJMjLhmc77ulx4Un1sz8oIwRYRTQZkBCNjWMJRsk/xN+tqQTYz82Yk7wV9
	vKcXn8ZEoqkkGOjYch0yFsHbRcISsNHjDzP7Ng1A28EQofP2h7VrPZXUMOzLEr2b1ze2/R
	5VHGsFJAquvc803IjO01eA1avHCF070=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rMMueHiG;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763024810; a=rsa-sha256;
	cv=none;
	b=qlbwYh9uRbzGuyiX+C3+apmwEv42Px32gy/dsx1bxcdgjrxmvNKQkeZNSmgDFXNlB6aUkf
	XYWCZCKY7fJm4Sb5yhX/tasFJMHxTcjdMQGs+Q3eVQuAfFNCgweQ7gJBMoB4mdjlIoB105
	qZ0WmA3p1WY1wvpbg1CHkouyAptuuh4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 09EC44448F;
	Thu, 13 Nov 2025 09:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871ABC16AAE;
	Thu, 13 Nov 2025 09:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763024808;
	bh=kzjNmKxRv2HTgs2BLleVn+WPjcFHAp+Wpu1+B0RTMcg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rMMueHiGvlrNs0GOCrftUTNWmns+IBBzry02OQpjdL86fQD1Vt2a34qjLTyOMa6oO
	 q2CHwNgbCa4RZFauDEOSNlG6DdPb29aKc8eLeNgi88psiR5iehoQiw3AT5pafglAK0
	 lV8xWJNCMAzM4IFbXKq8i8lkO+PX4j0xY7uNPy2jrnFpSiV9/3SshWEfIR7tTWsB7H
	 ioy3iuygOXPiNUqvH1KssnH/7XuxzmU/j1CH+6xt7Nk0uuVQHLjjP1BV1kD7hMbrBv
	 MTlJDSM+sgcKd0ie3cIVt8OjXBQvoKl0cN7IQdtwUWx8bSlOAodKyl6EOH0A44NfOt
	 T5l6xJqgvIwgg==
Message-ID: <e0be6864-4260-4843-a432-d47437b5d43f@kernel.org>
Date: Thu, 13 Nov 2025 10:06:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: fix division-by-zero in uffd-unit-tests
To: Carlos Llamas <cmllamas@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Ujwal Kundur <ujwal.kundur@gmail.com>,
 Brendan Jackman <jackmanb@google.com>
Cc: kernel-team@android.com, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org,
 "open list:MEMORY MANAGEMENT - USERFAULTFD" <linux-mm@kvack.org>,
 "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>
References: <20251113034623.3127012-1-cmllamas@google.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251113034623.3127012-1-cmllamas@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 172BE40009
X-Stat-Signature: m58enwdh7w6z737g6b1ssxa1w9gkyitw
X-Rspam-User: 
X-HE-Tag: 1763024809-78482
X-HE-Meta: U2FsdGVkX1+uvGIBr1oTPupHVoQZG246FJzfzieRruG2PmzEsiZiEiRgEa1eyrts8rxO9L/MKGwso8uejWrrpB1/Qq6FY+i6oDIyUwk1ptoW8Z5SnhYNQ8v20+8ZTgYqY9twc0Sqpi8szyEsBAToOUOhQ/tAOq0FdS7eI92zJnAtpSymRbeU7AqFVEcjkmxLUUCAFxfaUL6asq7nx8UNFl1V6aj0t5OkgjVUNIGzwknvxehs6qrsUcnQ46ES+uFIuru1JJbD2TGhtmwIlZV+3ergT8gbNq3dxUk6PITg4fIJ6P6TynaCXQIdfIZLhmvNaZoksII/DQyRAlXTOQ6CtSa2hw9M5upi6PNUL9lk8a1g3wSyyScTAJdERIJ++vPXUaOMZeacczuvn9NSL9kR5mwxXrYla/a8qbiXxjsJxPrgumNtsN3Lg8/ITqYnNSWSiWTVelDqn0jBsAl1J1VCJZP41cBUqy88ebOKemppI6FgqM1UrFrydm6WsGr/rl4CGl812HOmAnPGvxEdbdyuDEImnGti4PJq3su2cke2YlDJgk32XBsT32Z6ICz5z2dpzSPOM1VHJVDR/bwu3ja5mrfIWaE4krEQAlm3E48SNBKKzTYV7RZK5++hWTqAxM3h2hWrQJpIy7o9rrWKm7JuRFrgsoslAIF+qPRdRGr5H/E764qCIAEMlez0LQZ4Hl4BzwvdFUzuwMohKDvOW8XSCbJQ9bwud9+7NnhKn23ouu/3pHBJeFBbsgGHHHi2KhQlMLb3SVya/F+AeTWQd0hs2J+uX8fMl4LU3CqOrSAJS8yg5AqfDbRgtS4EqMO66K7A6O/rFt7P9F7r1E/4HBgpy5fS44IHTJrqrQPk+qgZwgpt0i+q59vcSbuEBcFGaz3h7ZKaqpCDYh8DBJNO5OyKTnt3TgLDjIQhoAY+LXaaRluwurTC6CpTsHpGDPCkzQQtjIA9S8UJ4yhzeYsKxUj
 UvQ44P7r
 KJDzRIOhmBtoF9qZAnFXyn/YJQ3CKwicEM5p55thpN+kkGWU8rFuVcN9q/TkEVOv8zq44UyLkpnr/PpjQYXdbTlzm0/LnFcobHOOQCaeAOgxj+68bTVcIXk7s8nU2xLParYadTsOqhzNiPV4QgPHSvtBNy+n/ERBSilSu8r4ABQ8a8PygLc9R7uO7YnRaVn9VOqqqPyn4lZ5es3blv6Y3NZ6TjEBXpslSoI9vR7iXNQ8f/VMgGW2M6O0bognPdPPXjoeokQu/G2eOmm3gluHwTP/MV40dhzBMiwbB7P9lw6M1AgDUeCz89+f8WRCyaRzmaZw3jrhpVo63LQ4zpbJ8lfw2e8kwXM7ipkBJieIiW8GWOQzGGUVM8CKRhrqtbRL12sTSf3aZEgbvYWHQih/mSg6gTw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.11.25 04:46, Carlos Llamas wrote:
> Commit 4dfd4bba8578 ("selftests/mm/uffd: refactor non-composite global
> vars into struct") moved some of the operations previously implemented
> in uffd_setup_environment() earlier in the main test loop.
> 
> The calculation of nr_pages, which involves a division by page_size, now
> occurs before checking that default_huge_page_size() returns a non-zero
> This leads to a division-by-zero error on systems with !CONFIG_HUGETLB.
> 
> Fix this by relocating the non-zero page_size check before the nr_pages
> calculation, as it was originally implemented.
> 
> Cc: stable@vger.kernel.org

Do we CC stable on unit tests? From my recollection, no.

> Fixes: 4dfd4bba8578 ("selftests/mm/uffd: refactor non-composite global vars into struct")
> Signed-off-by: Carlos Llamas <cmllamas@google.com>
> ---

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

