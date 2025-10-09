Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB9B2CCA470
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 07:44:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E3BB8E0068; Thu,  9 Oct 2025 03:44:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BBB38E0002; Thu,  9 Oct 2025 03:44:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F13108E0068; Thu,  9 Oct 2025 03:44:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0DFD8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 03:44:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 627771A0A95
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 07:44:37 +0000 (UTC)
X-FDA: 83977788594.15.A8D6B32
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by imf20.hostedemail.com (Postfix) with ESMTP id 324601C000F
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 07:44:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu;
	spf=pass (imf20.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759995875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s+XtmwdKc8QKMPTZ9xcrxbfmEnkdKPymPLn6kJMJIBg=;
	b=Fp7HG+/hhWtw77Zf1YiTTEvqa1EdL1AwtScx3XH9LE1ejz9VdM6vNQgemhPw5XzTFwzncR
	x9HiizBP0JTLGxZNv9g0HGG/MYutOrtvqaTR+MkRmKCTXhpjI/26z/CRjbV3v9Iw0TPkyN
	3HwEccp9l4Q4VQIYOtrVLlxHNhiTIxI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759995875; a=rsa-sha256;
	cv=none;
	b=BmraJvo+bA5daoV5QSKXBf8ZYrjiRe0kyhgkxNBE9FUHvlZVdbd895AqjIz0Di0MCzqmwA
	aih6sP+ny7Ztsyh45dZOPSld+kscAZX9VYWqLQuNgY1uEa1IXctCgY7MMUhFhusWRrbwiy
	WN4fWtlGe3nZmBWkc7yF0N73EK4c+Tw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu;
	spf=pass (imf20.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4cj22T4GVLz9sSy;
	Thu,  9 Oct 2025 09:44:33 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e-hrpkSiMM5A; Thu,  9 Oct 2025 09:44:33 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4cj22T2bCVz9sSq;
	Thu,  9 Oct 2025 09:44:33 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 3E1858B768;
	Thu,  9 Oct 2025 09:44:33 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id iEsvyTlwygx4; Thu,  9 Oct 2025 09:44:33 +0200 (CEST)
Received: from [192.168.235.99] (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 4940A8B767;
	Thu,  9 Oct 2025 09:44:31 +0200 (CEST)
Message-ID: <1fb2259f-65e1-4cd0-ae70-b355843970e4@csgroup.eu>
Date: Thu, 9 Oct 2025 09:44:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (bisected) [PATCH v2 08/37] mm/hugetlb: check for unreasonable
 folio sizes when registering hstate
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org,
 "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
References: <20250901150359.867252-1-david@redhat.com>
 <20250901150359.867252-9-david@redhat.com>
 <3e043453-3f27-48ad-b987-cc39f523060a@csgroup.eu>
 <d3fc12d4-0b59-4b1f-bb5c-13189a01e13d@redhat.com>
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Language: fr-FR
In-Reply-To: <d3fc12d4-0b59-4b1f-bb5c-13189a01e13d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 324601C000F
X-Rspamd-Server: rspam02
X-Stat-Signature: xhcm8jp88c1478xzqxbeeh34dr5567d1
X-HE-Tag: 1759995874-264736
X-HE-Meta: U2FsdGVkX1/P5Y57C5CGCAYMmqadvwUKMNsPP1pMST0V7csHc34d4W2XO7u0GXg+a0659I0x+fAKkYcT/ACzyAdkFeRnQa7AKixFcIMI3PCee9grBbv2sDsQ5iPcnfjaJ/BmcCqlBE86uMxsYoEQJrQodgto7fbBQaa3pH2VB53Floo4lgi8dzyQVf9zoimd6g++sjrLfn8cWqnhSjU9DKt1IZSvhTGzvuAze8+gCbfLnDwcnHR/NV4+KQyYi85TNmUUOJ39JO6t2ESP2CmyGPGz0XXvo40VmCJuJvttH11w7UU1N3uqI0UaXbpaFTikTH7qacqLOtgxEhcJqxa219DwgDmilqM4lbEvxNy3cMPbjWAJmUZu7wctouh+WWltl0i6LSxVSGbvbH8k4fsi0lwxbWE96WCWyaTsJ0nr7aTCMwvvV0O21al/GXGY24EpJNiYPVg4mm6I8M4UTFdxTcHkTxVybYF+kE8HARxQ0uPwHVgS77tq9dpYlAoOdkb6GvGKF+Jyh7De6otXJSeyVgNHL0UHdMv5vXupYe3FK64smyFEt2mtWEIXHDR36gh/iqIw92xxVpMhg3AITBUoi7VuLKV4PS+UhiDUBQC4U4yUe/wNtBxZMK7NqxDQsh9LhUgF+EU8L6Lp21/ZVkaosyWHG9ga+clko7k5t/EHRZjUPah4GLjNrVXf1ZMcacHBMnl/ywvGV7VkvX1EnHe3HaOMDnZuqMgFvHhDY9QHuyvD18pgKym4zgzyqtJncWgUUgpmRm3wxtiYmSjxuhZCFljMnltF2YtOz34/AQRj5P9lI1MZU4D3G0A/aluFgFX7oIl5bkS3vhg1qVvWfbZQyUQmxAi1rZeI4iua6MPocCtx70fqZLCcm5GXTFadZZJbmZtcgYNUMSsc2Zim9C2/c3P7jk+yuRT0Fia2jO4tbBb0YzrE/JP7PsGRIG6kG/w0jkv+c+0JrTepgzcNxpV
 ZpGWhf2Y
 Lpbj/MLTLKDTegJS8v/mQeQi+nnH6vIXXu2tmAlAb/0V0OBmR1PIBANSxza6j8jFxUoSTjg18dZDbSUKqx73qqc3sdZ+7hkAOeC4St/U7QDHpYL97XwdEbjc1OKDLkPlq5z7SOR5XlV0PPXE0/boQ5SA0DxQ0FIkklatAzlUZ2XlDytE9kJZ3ol1mroTVfSwQVB+3vQ+76Hc4rTac2EFrwF0X9XcmVa/bLjN1JmVYbEpaw6Lt8iZVP1Dqew1e6Bne+zXcaeIL8h9lIObb9f7F1TQgwcJPgAtB3Y49WiCuhqb3FQ8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 09/10/2025 à 09:22, David Hildenbrand a écrit :
> On 09.10.25 09:14, Christophe Leroy wrote:
>> Hi David,
>>
>> Le 01/09/2025 à 17:03, David Hildenbrand a écrit :
>>> Let's check that no hstate that corresponds to an unreasonable folio 
>>> size
>>> is registered by an architecture. If we were to succeed registering, we
>>> could later try allocating an unsupported gigantic folio size.
>>>
>>> Further, let's add a BUILD_BUG_ON() for checking that HUGETLB_PAGE_ORDER
>>> is sane at build time. As HUGETLB_PAGE_ORDER is dynamic on powerpc, 
>>> we have
>>> to use a BUILD_BUG_ON_INVALID() to make it compile.
>>>
>>> No existing kernel configuration should be able to trigger this check:
>>> either SPARSEMEM without SPARSEMEM_VMEMMAP cannot be configured or
>>> gigantic folios will not exceed a memory section (the case on sparse).
>>>
>>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>>> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>
>> I get following warning on powerpc with linus tree, bisected to commit
>> 7b4f21f5e038 ("mm/hugetlb: check for unreasonable folio sizes when
>> registering hstate")
> 
> Do you have the kernel config around? Is it 32bit?
> 
> That would be helpful.

That's corenet64_smp_defconfig

Boot on QEMU with:

	qemu-system-ppc64 -smp 2 -nographic -M ppce500 -cpu e5500 -m 1G



Christophe

