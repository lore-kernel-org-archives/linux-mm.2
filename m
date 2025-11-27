Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43A38CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 11:27:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C1126B0024; Thu, 27 Nov 2025 06:27:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 971836B0028; Thu, 27 Nov 2025 06:27:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85F7D6B002A; Thu, 27 Nov 2025 06:27:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 72DC36B0024
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 06:27:27 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 464C55075A
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 11:27:27 +0000 (UTC)
X-FDA: 84156161334.25.EFD9B5D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7FE94A0006
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 11:27:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b21RDsDx;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764242845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=18J2VzEQ/TtIsvCL5h5LyKaqROlUJUsFii4OfJuQZsI=;
	b=fM8KksDI+gliTR0Q2pmdQQXSvqxsCU8LGtjlpSuRVc7gzWgVQTb7jtn0Ulz28cfMxpG8hI
	mMfq9qGObWMuuU6n/BjsdvwO5bwzg7M3gHvQIAT4vxXj370emev/wlp04VPZOQd9ldZT4e
	r7XKq1IY4/OzG7QidYf5Qy0d7fkIg+A=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b21RDsDx;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764242845; a=rsa-sha256;
	cv=none;
	b=k07eNa8iapx2+/F63evnd5V7Oy9UqAcQPmuHaUO+bAxX6X1k9iSB66G5yeD+CL8iobgted
	zVP5232wBHUCd0VpV+xUCchJGoC6YqWN/q7rf5QEvuesqED4wjP9iBjO9XvHYeNDgFGpOZ
	UI3cFfkNtnTxtSpgmJYsA4cPyk7t6qs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F051142B15;
	Thu, 27 Nov 2025 11:27:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A317C4CEF8;
	Thu, 27 Nov 2025 11:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764242843;
	bh=muetvljUY3Nkik/PobN2fmNoxtVaO6scpEpns09bMHs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=b21RDsDxdy85ey8AfYrH0yNpETemOuc8/zJEIQrhlSIr1zrzEHVNWmb9xrVmYGYGA
	 umX8lU3bIw6mNbLZKK3YDmJPuIP/LArzTepOUMLLfqIS6TKKqu5RVtrzP4fqgtE6VH
	 YJlQlMLRoyR9Ly8y5VCfCu6iVe1CRYLZwqh3jvDsM6rGz0a70MuTDOIPtwJ0QM/UDz
	 TYvDohZpmz9VYMobH5ImBRZM7tZrMt7/n103jYmaupkbNrAEbhDzoTSKGbXaMd5ELB
	 9L6WSZDtSb3tBzCVGJwsiN5MtPG3rlRjraE1yQ+FGv6pocryFVju3v+p1o2zfCPU07
	 KgLYSETML2Cfw==
Message-ID: <35f8ca1b-b5ea-420d-af3a-ba9acc7b39c7@kernel.org>
Date: Thu, 27 Nov 2025 12:27:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] guest_memfd: add support for userfaultfd minor
 mode
To: Mike Rapoport <rppt@kernel.org>, Nikita Kalyazin <kalyazin@amazon.com>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins
 <hughd@google.com>, James Houghton <jthoughton@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Peter Xu <peterx@redhat.com>, Sean Christopherson <seanjc@google.com>,
 Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20251125183840.2368510-1-rppt@kernel.org>
 <20251125183840.2368510-5-rppt@kernel.org>
 <bafb0c9e-9ce6-4294-b1d6-e32c41635add@amazon.com>
 <aSgpo1_ZSmxf84-p@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <aSgpo1_ZSmxf84-p@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9n3hjsracmermh6ycjj35s4ybgajaicz
X-Rspam-User: 
X-Rspamd-Queue-Id: 7FE94A0006
X-Rspamd-Server: rspam09
X-HE-Tag: 1764242845-268270
X-HE-Meta: U2FsdGVkX1+pLuBr4xwhzmaBlJRlMm4xwH5gqtOiB/KNpTsv9S1cEYH4BIbnLxDxABgezolt3Bt8OTjeI2CymnVAv1tyHQaV1fGmHyT1Uizi26A8xp1QiTDfFbxecdjwzIjXyatVmtjz8JetYtANrGSsCoC6nC0KQ0A0L5ZEWaln6SX4T/qRq48vIxVCnf24mQ5bdeZI7hg27xP4aWOgimhHsIPUrzwxNa3FmSaJy+egAyo1Ae3Xd74iIko5xPqHzdDL9UD5oajgRhdFU0XzboOVtxLFdtJ4/3xjWo8qRP6zI74GmHreqxs4X8fZgesFQmyse4e6rJ65iK3xUsgVaD53fWISE5lsADXh5+ybW3Z4IgxKTS2RGg6kuZjPKbyhS16AVukA/jucaeMCDfn8Tzxsl+0sAyb8fJM3a+mgi+j/Gc0bZ62a23Vs6sFUuPquyNHkEQI59lgILhhdxiTIWAqxNJF/gszZT8L8TdnaLgOaMArXXBRR+k7OiaIfw+2JjnisQw4/IxH1cbhe8sILrQAJerF6TZzOFFmeJ2B4pSo92/yZ3av2tU7HfVnG7tzeHACLJC3x2IxqE9/T5rGcTfzZt2+DFFemaqCqUcgUOMc0bGfHluH9TOvECNNZ8VDs4H1C8qJIe77lSExobqoQ1/nMy441nUyUb5fvg83mBMaT5mrh66rQ9P68txxd4hNNoTpbWp3/e+G/dbYRZl8+JfxvqNYS1UGnhxj1S+RxP2BuK4o6qUONEjKxNKfK86+bxLBeAv+a6zTaYywj0eSg3zirFHVz44NuBuZolQPOYCHdrYG02dnwZzWF5rNpv/PRNS8wQqp05UPcUT3C/SjtBxmNi56+4XZq4bwx32Or5aE1Jxc7a/uLiyGBICjERTdZRzH00XBdtkW/hSxHr8rJL4kYb0zTkapMdbDDP3laQT4I+falfCuYpsetvHVIGdvE3e6QtJ96bLFlxItkYU+
 nmLLhHmS
 RKgG0AZiicPjNAIEGwOtg6d2fF1BVxkbMh508Pf/fHqwMfmIy0lilx/Ic2XvsDjyl04nFA03MDOEKpThYUtN1G6uAbVkFUY4FOx2lxveDDgHM8OlUVt0RX6DWzqe0zypWLfnXtVaXS2H1YJwmyEnvwWHCfLJG0Owbqg20R5t+cA1hrh7TAF3P6TSPbKyGs9XPSvdM9L9kIetARRceKMHA4ymYjysxfkH5ufG5xiSXt6C6rWX4jHU9WfjZVAzDw1Uqs0uJyJvYtIkC535aQwxhm2/gPPhwONDfK9JZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/27/25 11:36, Mike Rapoport wrote:
> On Wed, Nov 26, 2025 at 04:49:31PM +0000, Nikita Kalyazin wrote:
>> On 25/11/2025 18:38, Mike Rapoport wrote:
>>> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>>>
>>> +#ifdef CONFIG_USERFAULTFD
>>> +static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t pgoff)
>>
>> We have to name it differently, otherwise it clashes with the existing one
>> in this file.
> 
> It's all David's fault! ;-P

As usual :)

> How about kvm_gmem_get_prepared_folio() ?

Or maybe just spell out that it is for vm_ops

kvm_gmem_vm_ops_get_folio()

-- 
Cheers

David

