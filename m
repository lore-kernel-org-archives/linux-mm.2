Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5589BCD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 12:51:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA1736B00C6; Tue, 26 May 2026 08:51:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B79396B00C9; Tue, 26 May 2026 08:51:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8EEB6B00CB; Tue, 26 May 2026 08:51:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 975DA6B00C6
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:51:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 500D6140286
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:51:31 +0000 (UTC)
X-FDA: 84809557182.27.39180BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 76C9E80002
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:51:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gqzL3yK6;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779799889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mRVClqEGdgJg24ivDtsHCorPKJNQTLUXQk2/xrpkuBk=;
	b=oQfXrZLjJDEh8DuYvncx3grV3dDUnvAKH1z1WcIDrZWOza9/DDTGSR5LMs5QfFoODbLFiF
	vH908eLTJOJgEnMaRYtKzwbCBM3TwepX7QLnLA6a8OFw3pEKejGxlIz/UXBBjaWNMon4+r
	bOAEtvCdwsqvvvObSlmLIhA9SahnsKI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gqzL3yK6;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779799889; a=rsa-sha256;
	cv=none;
	b=6H7214hu0n/AfXA+i1qDjIN+khj3/Z5lQN0pRafeeooP8htengYerqhfLJEL8iMtPoygM3
	Qh4C8KOWwR4tX97rrlWfPvif7aRzRY0X/2ZkTjjull2Qu/yw9Rust9x3zRxQeeeUSmD3Jf
	y4aA/GbtSj67R7DXYK6v0FSEd3JlzZo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A23C3407B2;
	Tue, 26 May 2026 12:51:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2361F000E9;
	Tue, 26 May 2026 12:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779799888;
	bh=mRVClqEGdgJg24ivDtsHCorPKJNQTLUXQk2/xrpkuBk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gqzL3yK6+Ra/K0etBeSd29DQrIpDSQ/0BmoGwIQGs9RL42bzeMNMfd8aCaPfGFRCP
	 151v0puWAJiL5q7nimPqPcFu3y15YI8r8vNrsj1vPkOwhiWqrCXEFkDSuIS24Y9VlL
	 VYlK04G6G8TQYBfGn7d7RhrSrcr1CU6lHf/DpOE4mAnIV+TJBRRCgf5k8WxI+z1RPx
	 K08e1Y3RhLgmdOjajchBNzWZ95WS9jJWGwm+/HU63ebx75ozwPpv6b3qlXY0aqPCYR
	 cbZzdNy6iUxymjpRQ+dkdCugCxI6YBmD+oWfWQBO/kREZf17Y1wEmVLReqXOtB3MXT
	 bZRcNoNguujXg==
Message-ID: <c2f9ccf5-9c1d-40f6-85f1-443169865a88@kernel.org>
Date: Tue, 26 May 2026 14:51:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: update file PUD counter before
 folio_put()
To: Yin Tirui <yintirui@huawei.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Dan Williams <djbw@kernel.org>, Alistair Popple <apopple@nvidia.com>,
 wangkefeng.wang@huawei.com, chenjun102@huawei.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260526101355.1984244-1-yintirui@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260526101355.1984244-1-yintirui@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 76C9E80002
X-Stat-Signature: fji43da6t4sajxtwu87bpwcij7991f7p
X-HE-Tag: 1779799889-505657
X-HE-Meta: U2FsdGVkX1/fwPH6No142ZlIRfw51+MMU/xMT5DMBLQTw9wEqi9M8qFVKo/QRTzw+lAZVJ62c3b6nrBNz9dwJkIv1rNyJOw2S7nuqezUD1BzrqKlK1aR11gkQl/M5/btocIS2VxQXAv5lY6V8VBgA/FFHLopCMWJ0cbj7HZ8ls9GXLgKVgjzqSC5TSkKRfDOb4Nwm652zAPnYpUUgGpmqcvdvs9p2Rvqsn0wCoIS+KSTiBGhgadaUD3l7PmrwuXmtO5eSa0pU+vGCc8sUgCOw9ecdIW4zyEbZp15RtB71eE2GLvsWNTRDAXxBxGn3k67NNpSaMVeA3seARtdIgiB50x1vRfHMTnjlpbhS3Rr+uPhFdHmztRLbfJ5xpmq/+XzH2WPSwTiBYR3T+XEIf+MekYinNCTZvE6hKLH1TuZP6vqtzXQhixm8QNyMGYUZ5kWetnBQktoCZxBgqeb6RXLT1XgGNVv7fEfwIu+E65bF59/o192UpogRHWxNTq0h50FfGWvvn44zsxORffT9sWvrogYluxpSxZ4M4w/GyhklFbF+QY9FW5Ew+EzmQHSxN5G1ytcRlrOa1WLNF+LhHDgVpoYXFwUUj4ugufcP+W/S0p14v6QUjd47hhIum3U/dHqLSGw4z5JKk3OZEFVe+w70q7eV2On3iLMNiwoLQwao8ufUU2b3ePU3ITJMqUN12an7s8TR8yJKq/HgrmgV6TY91VVC7tmhfGQnUeGGIY5EXYFB80UxUcIpwIeVW6LAykxaknSxsSIso1Gx+5eM8khD4MP7gsjss67C1aomhjIGKrO3dremphGP7hSygXDnfvX7uaWfkQa96w1pWP8hMRAxk19cFbWZ8nwaAPo7sN0ERvB1bpQW4U9HjEH0WHW8vJE+vl879ZMvQ++FUfkmuDhDW47AZqfRMZtyU6Hl6svT8peIj+g9+KkC4CsMcalsTWTJG3g/2Rszbwydm5KiNj
 1ttxfmXn
 ab/3O3kszZSgizVQqD7OlmCMM2/L83z7f0RIPs0jTqbStUMVhWQi+jeN9j4DSIqLQjqcAUmD0hQNOq8YSzqEoy0/GNBDQ8w3en0vloPDtUbWo3Esgw17Tg7d/maI7wyV9teJ4NjjWyv2EJfoLRDTxandp+WoKlWbcvAkytSxW/Y6wsuD37n4QJO5A/jhEBij+6FRLFYnSnwPFYNDuYmHMSfReHF3FBfdODy3htz8oIbEZJXCo9iCqYgPJ+XgVCY86jH22Ei/KxjpWQxgeD2jcXbGk2GMRuiL2XHTG2SWORR37x70ceEwDlipKnjJSER9b3/qJ7pN+n+zvxSdFQoVX4VdgbTFNHzzeugym
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 12:13, Yin Tirui wrote:
> __split_huge_pud_locked() updates the file/shmem RSS counter after
> dropping the PUD mapping's folio reference. If folio_put() drops the
> last reference, mm_counter_file() can later read freed folio state via
> folio_test_swapbacked().
> 
> Move the counter update before folio_put().
> 
> Fixes: dbe54153296d ("mm/huge_memory: add vmf_insert_folio_pud()")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Yin Tirui <yintirui@huawei.com>
> ---

Acked-by: David Hildenbrand (arm) <david@kernel.org>

-- 
Cheers,

David

