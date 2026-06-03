Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3AB5CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 12:57:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 131A46B009B; Wed,  3 Jun 2026 08:57:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 109096B009D; Wed,  3 Jun 2026 08:57:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01F556B009E; Wed,  3 Jun 2026 08:57:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E441B6B009B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:57:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AA5EF1C173B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:57:41 +0000 (UTC)
X-FDA: 84838603122.21.328F5EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id D5F4C40006
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:57:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=drlJsdlG;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780491460;
	b=LkpyJy/GNAfr2pQdsSoHv6ucnBg9kONw47FDqI97/b0LHSlqRYU9+wdLFGEWOwf1eRHKJl
	rZCNDLVeYyXAwAi1h5zBCiVFBuMMSOd7+1c7s2Ukgy7x4Svjm9GHJaLIEjHcmCwIsYFnRL
	nLb5ax2fGU9xaMxDuuwcUXkxyBqvyNw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=drlJsdlG;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780491460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tB9KFZyKGivu9y0ZSjyzH4PI8sXw6rr3+vVBPE25XBk=;
	b=oywqzmgjN3ZaGY4oZ7We8Q69a8ukzdR5N6epUXBn5svkCjGKIuZU0bNsuH4Xt1j4mIH/ko
	fInTIdEvCNSxJvJh+udzZF9PtP9I9q3tC9Asoas59Lta6jYg0YntgyZn8kD5UFn6nq813g
	e6g3fKC9EZtE0h1UpR81cf08UzW/WzI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0182C417C1;
	Wed,  3 Jun 2026 12:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AED51F00899;
	Wed,  3 Jun 2026 12:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780491458;
	bh=tB9KFZyKGivu9y0ZSjyzH4PI8sXw6rr3+vVBPE25XBk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=drlJsdlGCSMj/+oyDfiRvJS0YysFfAXETHzXQ0Ksqii7P14lSCNqVBOUvRKqsg3b4
	 3zj4sKsRf2VixRyqBcQdxFv91zZkktF0Z63kVjVG35qO0T130UZKx2uYIgLJEQnnTI
	 I5YssawGR90C2H+ob7Y01/Pdgnk8sRKToKLouh1u8akvTcrMONN3+vxBcKg4YstvB0
	 j9H0//Du/BSCwDJbPnR71kkkpy5Mj0VcEJ2LrGsyHdo+KXg+wOnHgsampRbyVedAPG
	 4sRQ9JoOyM3VHZB7lJxLvBhLl4fOIU4KKK14V+8Z9ygYzjL88wPkMiEKyE58+k8+o9
	 +gI4McTSWYT+A==
Message-ID: <3df7ca5a-1812-4840-b7ed-a143ad7c307d@kernel.org>
Date: Wed, 3 Jun 2026 14:57:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/6] vdso/datastore: Allow prefaulting by mlockall()
To: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>, Andy Lutomirski
 <luto@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Thomas Gleixner <tglx@kernel.org>, Nam Cao <namcao@linutronix.de>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
References: <20260518-vdso-mlockall-v3-0-bf4f2af2b41f@linutronix.de>
 <fba91f44-34c6-444b-b049-50f72e059d39@kernel.org>
 <20260603114217-9eaaa386-a766-4336-8930-250c2ff91d19@linutronix.de>
 <10274d6e-0af2-4f9c-9788-2896065ec16a@kernel.org>
 <20260603144357-464a54b4-4569-4b49-b7ea-77dc0af730e5@linutronix.de>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260603144357-464a54b4-4569-4b49-b7ea-77dc0af730e5@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D5F4C40006
X-Rspam-User: 
X-Stat-Signature: u5mmahwpjqgd15koo4wbq9nxmbhfwd9o
X-HE-Tag: 1780491459-864102
X-HE-Meta: U2FsdGVkX18+c0+OzoNMfiklPZaXMmg9CZwd5h1kQqra1bM3bOUbL+v8U1hN454LR8mu9g2Vpp5D3URZOqtCDRSASTNCwLiT4nHg+6zpMNO8LcZV3hYCKLsotfRNGUW97kieItkQiOweLpfEYjtF6cmj7evM2lujCMSsJm3bkU71qJjpngMLoSfPwbV4Drn0hJ6V2eKxywdkAV6Hojul8bEtgdIWgQrpp4qR/7it+fEfodJschuxM3Ycvy/zFEk8YcRsNpTNb7GAL3r9uT2e6eb+MiEChBqdLlOYuV6GO520QfNUmnNpLeMgHI5fdW0WtTaWP4v8upxxEhxxysbcJRs/aUHR1NztbixatKmh2KnHfPOmE7ZRGnerY85XX8jGsig6RHzHjA7iYaB1nq9a+RSHKS52CzrgrEoELK/4oZzSVxXhba8d+obh+14lhBJCBgC/1P5y9LhSHqGnV4M2GNReKHrPIWe1HaKurEwPt8FnWnyR+Pu4AYZ/quUCiPl//45jNXYS9o3RCtZxLX58PzMSGkT39sD4VhkWzB5E7pwK5VriSa+zkoEJnrIWlyzGTryXcKzCZulfbtWW2h+1N5q/P6AbiBI5OnV+T+GWRb7gAOEMIV+3FvTsSE9H8aI5iVrxzm9Qu3X6xr3/PAy9H/H7lKxb1ZantzW33ENfWyleCZRUxLEknCIUjknOcOaJ+BX2kFvSh8M+0hkuHyvtjhSptjDqebqYNtM0GKo0GsBVINdGiSjaURsk/9QUuyfB81hp8diR+6BiOSlmtpzSjGf0SDovwxI82e5Q6rmVl9FMgvED4NvI8yNUKKFBXeJj2DgsaMeM/J3xFmFMAfPReRQdiXAs5VaxsIQt1PQdbFr3ty4Z7WfmH+E00g61HbIxh1C+Ki8ZE/qANNyXga+4O/yRzvpBwz/B/tBjAQY3wugkgDDvT6l51xFAVcwlaONamEKeMokDRAOoTQzA3rk
 vo53dPcI
 BHd1XY1xCiX9gJdwRMY4CXKXjr36eoPKbFFILEusPBGnJcTGmM85pLo6RdxgXM/fRW+bbFSnNVLenakhA61jypakZ7l+Xa2jST7KfVRt5py51iZ8rA+qh+a2TxdqsGYpAC25WdOD1gW53rnM5LvY925woG0NBaGkisZliu6RVHCoLjeacAxhadPzNt7hhQNSsgSUd9xb2NRdMaeX4qQySOzKTKWe1Ax1BVM0fUh2R8d/vI9MQrtyfZCVOjuyPi7RTP2NNQqJHkrmFfDVVys7wTONNNAWxniYay56U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/3/26 14:47, Thomas Weißschuh wrote:
> On Wed, Jun 03, 2026 at 01:35:19PM +0200, David Hildenbrand (Arm) wrote:
>> On 6/3/26 12:10, Thomas Weißschuh wrote:
> 
> (...)
> 
>>>
>>> There are no side-effects, this is just global shared memory.
>>> (But as mentioned before, writes can not be allowed)
>>> Accesses from other tasks need to be prevented, which is what
>>> patch 4 tries to do based on FAULT_FLAG_REMOTE.
>>>
>>> The only data in these pages which is not globally shared and accessible
>>> are the time namespace offsets. But /proc/$PID/timens_offsets is
>>> world-readable anyways.
>>>
>>>
>>> We use VM_DONTDUMP on the VMA, shouldn't that prevent dumping?
>>> Dumping these pages is not a (security) issue, just pointless.
>>
>> Ah, right.
>>
>> So we still have
>>
>> VM_READ | VM_MAYREAD | VM_DONTDUMP | VM_MIXEDMAP ...
>>
>> So even FOLL_FORCE cannot write to it.
>>
>> It might be good to document the change (pages can not be GUP'ed, including
>> being read by ptrace etc). But I agree that it should likely be fine.
> 
> Should this "not" have been a "now"?

Yes! :)

-- 
Cheers,

David

