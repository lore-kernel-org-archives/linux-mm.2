Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F85EF53D87
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 18:45:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87DB26B0349; Mon, 16 Mar 2026 14:45:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FDCA6B034A; Mon, 16 Mar 2026 14:45:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 660286B034B; Mon, 16 Mar 2026 14:45:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 487706B0349
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:45:28 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CF1881B7E58
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:45:27 +0000 (UTC)
X-FDA: 84552804294.28.B46E455
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0B0681C0012
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:45:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=lO6v6VNy;
	spf=none (imf21.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773686726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R/0Pmqo6gymewtsBJQ/y7Yj1oSkMScDskutIUZ+bJxU=;
	b=7vrVw5Hfo6Kk9dw5oRrkhfzCdJqOc2y8dcjEFfOZN/0BJdyXllZLsd99O6csxqAmABznW/
	9S+EnHzVeKJo1Clx/sZ/Upn23PcyJvKEttZ/v+x8VQs1wb4BaYmCVbT1G44m8y36GKx+CX
	VEl1b9o/zq+za1YiwQAqpCvAcDwppqg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=lO6v6VNy;
	spf=none (imf21.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773686726; a=rsa-sha256;
	cv=none;
	b=ejXmiBjpT4TL5aDfNqhAkZBtZnlgZlIPDRCvvSpPNAn4D5NLc4RQONGsfogIANffZW8Df1
	urtsNr81JuhdLo10xoim3O11u9GJus3GPLSh+se6cG5AjKChBvc5+zlNymeYxlz+QMTHl/
	Z5oqyjou1qcPNShNZX6WfB5qKNR+8Hg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=R/0Pmqo6gymewtsBJQ/y7Yj1oSkMScDskutIUZ+bJxU=; b=lO6v6VNygyX0u8SkoFE88YqNS2
	DOcufX8BC2HzoQxDZvtRSRtxxuAeuRuV8oJQqZzRYuVyQsg76jokBcpc5i5UxehPO+qFZRbMCl4R5
	ELo2t1dzKXtXna5XyYXUv1DnTAw1/8HdUMQgHzvhJlGWt88BsGX/pGggF1bAgFjHmYgETXj6UsRmb
	xevH1jNpkgVSdduvn5I0E/x0zJbNKfo3DpJQWqJkC/GRmVMBiXU/RBGiKK0BJ7pADTCvXynaAJAZh
	RINKCwp1Vp07Rquu8gs7whqnScuS52vnQi89O3c5L8sKRH22l19ouJAHFr+9vp+/QwtXYufw9Yyfg
	q7oJzgvA==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w2CwL-00000004hUc-3lEa;
	Mon, 16 Mar 2026 18:45:23 +0000
Message-ID: <81ef23ff-5042-4934-a227-2c6289b4f62b@infradead.org>
Date: Mon, 16 Mar 2026 11:45:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Docs: mmap_prepare: don't italicize structs
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org
References: <20260315224506.1973566-1-rdunlap@infradead.org>
 <2ae64217-ae32-4a4e-9c23-6809582ca7bc@lucifer.local>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <2ae64217-ae32-4a4e-9c23-6809582ca7bc@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 77pdaqu1kwtzt99ymh84bixcrsy4ttge
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B0681C0012
X-HE-Tag: 1773686724-937558
X-HE-Meta: U2FsdGVkX18mMV31CXnBH/99rRWQDHxtsmVkVqDI2wEEynYl9+GbgR0AIur9WxLzBs1zTKhf2O/e5ZiBTL+354EKJDfkAKsa9zUkGHFF7V0BZNkqhW2P4zwWanrsj9b20WczygGUMXgmPRd2pt4REmnW86uT2M4EQikne/vMEpw4CcQ68D6kKCqEArOUbRKzLaHaCOLXPpcoE/EfiPi24QbxMly+5n0oHgQMHbwXQ9bAewylDkOG5DTvrDryKhZ7KaY0JP5kZ9ISfQ6EfcxZCbPoTfDJ8QH7rdpmbXEkO/m6Pd9F2t6R1ylIJl+0I0O1j4x4J3hh5aTs/3QX7typzsI5fQT35eAi3KLsKQ3T1Y9WSNkurt9HWfib1CC5BwDxNguSWgUD10u0Et2PxnITHckCinPd4hHQb8I15R5Yoe1+DU93vfJmsinULWoq3XId2YOBZrYzTRZ5Rk/lOdLY8oMPfe27UdxCtA4Y96FL06uIDjiJh2MVOcQFKMDczV7owhsYOmh6OmZ/P1suya0NSh6PLFeLEYd/GJgDjBxpxsdt8JMcpn16xaHCK0mK4QXELVROsOwUwKuW3/sy2z3XBDeViQvfHT1Tbhi14BBD/sdV6QM9lYNtz7ECJ1DX4+KiWWA8b2BYqWQ/8sCXLQWFvyKW6oi/trGr8xphPs23FzWGiA4x8UKHDD5gMjyNEzPhpDRMFIhrdBeH+FQ630RcEzznULBLgFJd9XoQKtxnMy1JRZSjQLUpYZBHgIlTl4PLc/IFAuk52XQ2x02/qi6RjFBpkwJ8aY/VnbUGm0xiVXfzUgEmibPeWkxKVTikWXJhXo7E1iXj/CxpaGtXw3wd4SEFBCfOq2TB9fROGTrnMhPD3vPys0JMQ3WrIjtC2fUGQZsZVAtK8zVfeAFeV2Jv7rWw9sSonEz85m6ObhumiZHMU0npgZ2gBYwnmGBONtPtZ9PMigaD7lF/i902K3s
 0w8Ovb+E
 rd98UGLONwrhddlhk00QYYcFo/TX6Dh8/MJCxOmABFdY6kkEg1lB5I61jrYTAYYO2Nxkg/aUgSIBCS/6UwvffflUzmwXnsZKz0PEpp1xxwIQ2qW2ooQaEti8EJT328zviCimmHAgYv/EdOYWGV1ELsM8epcZQv3/MGhTfWVzsJ47z0qZQOVCURaWyPEFiCRm0bWfIV7eet82MM71au2dO5zgAmnozgYDomVJlIPovkvaiX8eebR5wJ2CKXzELTQYxZDCo7tP4wwz1PSbq821Mk3qGTNqu97WynyImLpfetphTAf2wcGVR1XNCLgWumS3ufcl+sa2PRLzGTpIzk+klqZze0ahdHHU0qXGYawYoU+krWJkG2a4kr9dNcW2oNgNHEv2vz78uaEuvOEhQ/nbPz9+LqngSJzl6eiMMXGm9g3NeRCxneUIc8uaTu3Wz+dn9193zqPsRiF+MpoOtbI1HsK+XoWpuJbLYdNJZz5ht/nppWjdfyibrA1Mrit1ekFsl96qZt/Rk8n8T95Kw5UD+Ww/GqDp6aOFkdZx3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/16/26 12:10 AM, Lorenzo Stoakes (Oracle) wrote:
> On Sun, Mar 15, 2026 at 03:45:06PM -0700, Randy Dunlap wrote:
>> Using a single quote mark `struct xyz` causes the html output to be
>> produced as italic. Omit the quote marks so that kernel-doc's automarkup
>> can make the "struct xyz" bold monospace ("code" style") in the
>> generated html.
>>
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> 
> This is fine, though given this series is still in-flight we should just
> fold this in no?

Sure, any/either way works for me.
Thanks.

> Anyway, LGTM so:
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> 
>> ---
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Lorenzo Stoakes <ljs@kernel.org>
>> Cc: linux-mm@kvack.org
>> Cc: linux-doc@vger.kernel.org
>>
>>  Documentation/filesystems/mmap_prepare.rst |    6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> --- linux-next.orig/Documentation/filesystems/mmap_prepare.rst
>> +++ linux-next/Documentation/filesystems/mmap_prepare.rst
>> @@ -129,11 +129,11 @@ pointer. These are:
>>  * mmap_action_simple_ioremap() - Sets up an I/O remap from a specified
>>    physical address and over a specified length.
>>
>> -* mmap_action_map_kernel_pages() - Maps a specified array of `struct page`
>> +* mmap_action_map_kernel_pages() - Maps a specified array of struct page
>>    pointers in the VMA from a specific offset.
>>
>> -* mmap_action_map_kernel_pages_full() - Maps a specified array of `struct
>> -  page` pointers over the entire VMA. The caller must ensure there are
>> +* mmap_action_map_kernel_pages_full() - Maps a specified array of struct
>> +  page pointers over the entire VMA. The caller must ensure there are
>>    sufficient entries in the page array to cover the entire range of the
>>    described VMA.
>>
> 
> Cheers, Lorenzo

-- 
~Randy


