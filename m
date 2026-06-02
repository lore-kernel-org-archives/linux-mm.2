Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65FDCCD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 18:41:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2D2F6B0088; Tue,  2 Jun 2026 14:41:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DDDB6B008A; Tue,  2 Jun 2026 14:41:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CCBC6B008C; Tue,  2 Jun 2026 14:41:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 786AF6B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 14:41:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1BA091C21D3
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 18:41:41 +0000 (UTC)
X-FDA: 84835841202.02.DBE4B6E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3A230100014
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 18:41:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C3ZnBHTX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780425699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xXiBW5xQOsfkzdcluSMoQ8ytXfHcSUFrzKtpg2fnDgA=;
	b=T4Mmy6+jV3/Yzab8dkiHVeoDR0vYFZxSRgHD05qcEfrIZsq7W78uMsBfzdE04ag/Khb9nD
	JnV0t0p4z2tK/W8A/G8ji6HVgopDEfyWZ8x5TLMZGloKdqR5cyY3BWS+J0kn0H0jFTPyOW
	mjWgIQ9n+NmzDZSRN3XWOTlMmX5U22w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C3ZnBHTX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780425699;
	b=bYz0pyPjNWszQwkM33x56VVlS7/eLycSe04z1cHPeS0YSUBZOP4gGzl+GU8QvnQ1N0dTlW
	h/ehJNWTfi1TKeHTCh5TS4L1MCgwRPwyWiOBHSM0tbxSt7bNkm5QMUXm8Uwomsf3ySUmfW
	Ns3T9G3STj7zMOWTfLgMT87cpF8/v5c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 291CA41744;
	Tue,  2 Jun 2026 18:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6E31F00893;
	Tue,  2 Jun 2026 18:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780425698;
	bh=xXiBW5xQOsfkzdcluSMoQ8ytXfHcSUFrzKtpg2fnDgA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=C3ZnBHTXPrC7cVPF12arQ+1RukkHPjvtMw23fYGndvGFmcbo5L8zLImNa76rxGK7R
	 T0rwpTW/BRZxSpP7snT/sV9b9+sfK9lZiekPQbaGb/IrVynLCM9OtuN4IlrGo+3gQD
	 nD/Rexc7HiXhdNqgVo+XFs4JNl7zD2VVEPAwWreuS2ZqpN2cQQ43jZHbTbkaG3v9w+
	 PdHZ8e6aT3M7wYk0bTFxGc/jKbq9Y1Q+LPU2BJofyuZjPPy65zv/9eIb0ffz80tMMA
	 ZcmrMz2bYfzrD7rncHq7lyjdQwgEHhrzSXzuvOQ+pZy9F7/NwptYxRVvA2aU5jIWRL
	 gpQyJ4uIhfUyg==
Message-ID: <fba91f44-34c6-444b-b049-50f72e059d39@kernel.org>
Date: Tue, 2 Jun 2026 20:41:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/6] vdso/datastore: Allow prefaulting by mlockall()
To: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>, Andy Lutomirski
 <luto@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Thomas Gleixner <tglx@kernel.org>
Cc: Nam Cao <namcao@linutronix.de>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
References: <20260518-vdso-mlockall-v3-0-bf4f2af2b41f@linutronix.de>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260518-vdso-mlockall-v3-0-bf4f2af2b41f@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3A230100014
X-Rspam-User: 
X-Stat-Signature: x4opxcrkuf8tq3azxnd6ddgksnoezsz9
X-Rspamd-Server: rspam09
X-HE-Tag: 1780425699-870027
X-HE-Meta: U2FsdGVkX1+FB7O+htyn8GLdNuroOtOnnF6OhXsv2YhkUk3guKTrCQOYHl3HCIznsMqNi5ZAn9AtC42YdEhVtjU7hu8fO2sNRT5LqqdgZvPhOl22lXXLm+oln+zeOdrpimrNf+Xbanp1Mzz06S92zgiF2g0y6hIVE0uavJu2O57hAD99YPvpPNdaxtZBy7mspzaL2n6h8fpIAaMhH7ZVzMjqhtP1uTMSYFSabET9xnNuQ/X63ossbrYaefXL8Yp+b/wGpkLY/lyJQqi+ssRvNScPoSYn5Ypomc92TkHJu4RdqeOA8eGzuvcTLxqoXD2hloX4szU2QZj9aPxpZOkfP+des+SQG2Vo05/d+AuRLSnTsIvB2W4ZFVITaSMut8yZlRyMnDZnMZ4byRRR/q2Mvc2AYIIn7PCFQZqGgjePNjKRKzNrbKoiPp3O6eTqSMgGcJzmkBiniXVOhdlUhiF9hXHBE1N8s4KNXobI+wkK2uyHPoaWC0squ198+AP5kiY5aJqC1hqAl7pruo6m24fYfUlYJM+YJipuOU0qxcaqghodSuVo7TXir85kq+EZqFtnPTDDVDatPFjC4xMwfqwMZlv6cMcrqIcx7OX/S4TlZ3FSiNssVJJ9vV/BMRQ1Ho/DnUSiHULFe3i8iVISJzQHGZpjQP+wQZo6cehbq6mBi197TkRM5fzj1gLHIuRCIAfArLTx+fAT9OJqQjKYI1HKD2+Jedlc9h6IxUlR46eoTHIaSI88tTqNOwbbBJrSBTwObzFGyK3siOZwO46/7a4rGBs4xiqqVRYvQvzJQzq7DZCKcvgyfCZwIANpPLuSB6eNNzmnrplCf6g4FnvvpgLzsyIgH8dYiLYHAnQdoPii9Ovwv4udWIGyy86KiUxIG9pZlOYKuheMiDlvAoSACCJDF5A8Up5Q6g1UuDIbH8eSEPtkhrAg/krmMjYX+e2OK6UU4o46qfwmPThE4OHBt0t
 JVnXbJRm
 qOZy2uS79JOnaPO3+wFYZGatV334r7Z25DmEE/oRJFFgbWzwMcHSy/s/aegwaJoJ7gA/D/CTgJsiZQ6pfQbBuFSXSMhUebsvqpLD8tA7ae9apZLg79kubi55ihvSgBj3+z9p7xyNr/mmyotdHhSYiBBFINcrjqFasnugIEmPbaTKYaVwVXOKbzDIvU8jxKesGHyj0MgKvIFZ+4cF1J/+mF39v513Rb9EC93EIdQQj4MK5hR1XrfBQEzGtpVmmycQPgdCI3OIfLX6IpOszdH8O3zJVLvYXK2Kn/4yJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/18/26 11:49, Thomas Weißschuh wrote:
> While mlockall() is meant to lock page *memory*, effectively it will
> also create and lock the corresponding page table entries.
> Latency-sensitive applications expect not to experience any pagefaults
> after calling mlockall(). However mlockall() ignores VM_IO mappings,
> which is used by the generic vDSO datastore.
> While the fault handler itself is very fast, going through the full
> pagefault exception handling is much slower, on the order of 20us in a
> test machine.
> 
> Since the memory behind the datastore mappings is always present and
> accessible it is not necessary to use VM_IO for them.

GUP also refuses VM_IO, so this change unlocks GUP'ing these pages and using
them for DIRECT_IO etc.

Well, I assume that GUP-fast (no VMA available) would be able to GUP them
already. But mechanisms that don't use GUP-fast would get reliably blocked for now.

I've been wondering for a while, whether the VM_IO for GUP is still required.

IIRC, we want to disallow read/write access that could have side effects through
ptrace, including process_vm_*(). For memory-mapped I/O that might certainly the
case.

With your change, you'd also unlock get_dump_page() on vdso pages.

Is that all ok and desired?

-- 
Cheers,

David

