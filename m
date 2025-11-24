Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F079ACFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 10:59:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 566946B0010; Mon, 24 Nov 2025 05:59:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53DD76B0029; Mon, 24 Nov 2025 05:59:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47A3B6B0032; Mon, 24 Nov 2025 05:59:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3768D6B0010
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:59:37 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DACE388981
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:59:36 +0000 (UTC)
X-FDA: 84145204752.11.5987F2F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1CF3EA0006
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:59:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bC85DyZS;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763981975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zjggqgS6kvfR3IMkDE/JrfsimRbEDQDt883sxE2uIAA=;
	b=KB9rfPN+M3bgNFBLDN+F82Jk/nf8Vo9Cczr9i11yBw2+JoFfGGenHnz52a/xySiUEAxdqD
	4Xs1lCHIn5Pv9I8yr2HhOtu6DcKoNZcto+HEKxGq6Fm5U/1d4yPrxjAIqYoDHJiRv06p0u
	q2H1vIfQ8MRA8EJg0EjzISxJZF2lgEo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bC85DyZS;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763981975; a=rsa-sha256;
	cv=none;
	b=K16tjk/JtxJb/+RvMBA7JIq5O2podWI7F28CpUF1/daP5oiHsWUk1FLpMQqfm9ClYhdPPz
	dOND553QicQgEsXjdN+EC5NoIhhPDNhv4k93WHYz/i8QI0RTVuUxJpgpskLwKZyZRfhsX2
	6T+gC7B0+vt3ZQj8iVG6F3cSlR1a1Ek=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B4A6E4342E;
	Mon, 24 Nov 2025 10:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D929C116D0;
	Mon, 24 Nov 2025 10:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763981973;
	bh=qLtkeaNDsB2tmDLOENGtmBtmZgPrR5Q1pBKk7Jh7MKs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bC85DyZShd95NPEK1pyA4HmcKPMgnE1eCpXYyMlFo/LrZmCPIMkjzXbCdHdVPNdYh
	 40H+oOIzaTi26eBYT1hEmJlWXVgjFgoElkXRbOm0zxZIG9UqC+fJp7831F82iQ066G
	 oexWubXGLmQJgIrTh16XpTfaeLl3w6jghcRQsNJ/gqhRjKCxYB2AuFkYzK33YqUkRi
	 KL3z1vi6DiEIyGofW7iQbZbl6BaD+QJw9CdpqlpRgBcUN+1lkfaAgX2H3Bj0p786hi
	 AYvifNMxW6DHHqK2IVvwvqz2w09NQBaP3jLc49a5VasABGT8CKU3TWhp4DbEpLbwi3
	 cpuLjbyR12lLA==
Message-ID: <6d2d4b0a-a1dc-48a4-83c1-1fe02f294181@kernel.org>
Date: Mon, 24 Nov 2025 11:59:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] mm, kvm: add guest_memfd support for uffd minor
 faults
To: Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins
 <hughd@google.com>, James Houghton <jthoughton@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Nikita Kalyazin <kalyazin@amazon.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20251123102707.559422-1-rppt@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251123102707.559422-1-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1CF3EA0006
X-Stat-Signature: bfzfj6s91qnkxu9a6jimizxk3wictox4
X-Rspam-User: 
X-HE-Tag: 1763981974-356852
X-HE-Meta: U2FsdGVkX18bFkl6A04+VrCQExP63M09tH+YhK75+NoUQfFgOvnUIiV1a4bBCGiaKzUGjaDnh/bpAdzF9zfLB3rMJMIHrks6MDEMJ4tSqRVFllySoqYnDC8KYKcyODA7KxJQnoGyTFAk6ITs24rZRYvbHrr8QrxNN4e2Y9qwODyTqFBihJ+ddPotxYfFwXLouHnsv0J/DBNG2mvK9q5kYO5IVztt+ozrbQkGTrSJFujvyYFHJD+Yo7YsjATfWudxxjaTEwHtJ17li4gds1hXuQ24IVMvtw7YSW5z2VoTcJje2oIul/2W7so8IW11G53+oQRBjwLBX/EeRT4tgSbRpyMLyuh/8Fs0hjCFIkaQhr5FuSexLxuHrYNhbIceHvwPg7sFxWyl6q1tb5d/rK0wsC8jG42CScGxS8yIrB5P1/WvINcVhpir+ATpMXHEmmBBAIdxbYsnTTYbjoz90TIem6yW/0AFgSuNOYoDIUsbe9DlxuTIlqhx/L8+X3yE8T371eTJFlkpxlnq/JFeswN/5fiHkqJBhs/q0OHL4kf2JTNZhwrcILdz84Ev434CBM7pdfB39ChOUnH6qaPXqIdKLN5HYlyZdz3rG7tgRngmTuDoje2TXuPYWEzlXHSxam7bDo2PEjCpJUBpq6BZH109XT+pA4aeQcqw/SbvgX+2yL0L89VBp8cYfui/r0pYVj1wJfIaeqK7IqMgGT4EO/DdvM5fNnqsGmjWr0CH8nq0URdYVLzfOEzEHQxpTlq2ejyXH43+rSaXbiIJeUBRlGqOKzmj0gkS4mrzgbZM8e2N78OGA/HRyc0RpRBPEjVLnxS4FGkPL4E/Un56CpR3+IfMFIhi6Ej2sP0CQNQ0T65GljpDv2OCSaalVjP3JX7Ucm1+DLwrAC8yQnlKwuhGqJt1uZEMk9u/mX5CxGPgh58SZ9xsNT9FM8CSisMNOvWl8UBsQqk2Toum5jJajml0cBL
 Ozuydm1/
 sQbGukhgm7i6BbaS2dL4diY4t6eZnED/3aqMhY9OFJ/eBwZwGE8cQthzk3H+L23C2BLUlDkfiZ72pZeVzyaqz7xCB9T/fk38AkrsSbib1MGQ9D1tucLInFTuwf14iIeiZdxkbQFQgm2Fvj6KqQpTNAKHJ4JSkZVkT4canT96n5eS4F2df9yIsY8d6fnz6RvpErPHsvGCqGi1P4JpULl9s7DSdQf/IzCZZdb6yc5cxct8HR59iqEWJzJtXUcygH8O8idler+Uhw+BUHVtldte5lsc05JKpgrOFUOGiPrAjyDtfC434AbrUPJdRl6PC4OcIb1JIyYiiPFAAuSI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/23/25 11:27, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Hi,
> 
> These patches allow guest_memfd to notify userspace about minor page
> faults using userfaultfd and let userspace to resolve these page faults
> using UFFDIO_CONTINUE.
> 
> To allow UFFDIO_CONTINUE outside of the core mm I added a get_shmem_folio()

get_shared_folio() I assume :)

-- 
Cheers

David

