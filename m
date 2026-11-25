Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B1E3606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 13:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A1CAmMQG
Received: by kanga.kvack.org (Postfix)
	id 91D156B0A1B; Wed, 25 Nov 2026 08:43:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CDDB6B0A1D; Wed, 25 Nov 2026 08:43:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BBF46B0A1E; Wed, 25 Nov 2026 08:43:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 515276B0A1B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:43:44 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D13BD120E40
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:43:43 +0000 (UTC)
X-FDA: 85473759126.02.E3F6355
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id EC64940004
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:43:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A1CAmMQG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795614222;
	b=vqnkg8mR5ieCniS1kJJhNeejqh/boaMbuKxdc7FzvlV1L+1kitqVGM1c0HV5rEsWgiRUOA
	tdxKJgvjEHvUk3SirDzvRUYL6byJDPSo36SMvXtVgw5aZR3lJt8BKJoTY2drY0XGtrk44w
	NhphpY1u7LYYJhy2DEEuHIHqpUaKqqY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795614222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZkneC5LQ+6dBKeyQZYnqczFByIf9fYmbADKKT3AxPBo=;
	b=TjS5xKDOasGwSgDTquCvnH2pb0FG/G2ThdZCemAP9EUiC3FRiT4KkilhN6scaL3QQYstfZ
	ilEzjVFQ2NaJVBaik0rMJ5Kz3nVDuCNCFBrs9pZSBogep2scP3Aydbrn9G8nHDl+pCQaGv
	1F2jcsyPail8+B5luW+MfvGDATt5aVE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A1CAmMQG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 21FFB413E0;
	Wed, 25 Nov 2026 13:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852EC1F000C4;
	Wed, 25 Nov 2026 13:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795614220;
	bh=ZkneC5LQ+6dBKeyQZYnqczFByIf9fYmbADKKT3AxPBo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=A1CAmMQGn06htVNrv9uK8g49thsvEyl+UNBOI8al4+iamso8CaWyJNjAQlw7pfmyo
	 2CI6C0cXb32Rsy5Lw1hdQGnPVPuXUetAr33hLpMqILdoOF1LCdtxhvyFhh7+oypC5z
	 KArsc5KLwuSkA/5dRdXzS9iyC5P/KrdVPm34LxNQ/PaXfcv8FWRq8LGFvjMzkIvxop
	 2Qbd2jRRwsatbu88CyGRIhb/qeAsFtNEAYc3GXwhCmmn8bCT+PbCAfji6p4M/YCXXQ
	 yElBp1vME52YVi9akcbpzMFJ9v5Ix7eZlXAZa4xJx/j3r4pFYI7zQjpPDLsonWqBYr
	 h8sY1aCmLsnAA==
Message-ID: <380e029a-2d9a-43ee-9048-c4b490c11f41@kernel.org>
Date: Wed, 25 Nov 2026 14:43:29 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm: fix soft-dirty false positives in mprotect() of
 large folios
To: Shivank Garg <shivankg@amd.com>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Dev Jain <dev.jain@arm.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Peter Xu <peterx@redhat.com>, Shuah Khan <shuah@kernel.org>,
 =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <emmir@google.com>,
 Andrei Vagin <avagin@gmail.com>, Paul Gofman <pgofman@codeweavers.com>,
 Bharata B Rao <bharata@amd.com>, Daniel Wade <danjwade95@gmail.com>,
 Yin Tirui <yintirui@gmail.com>, Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261125-b4-mm-soft-dirty-fixes-v1-0-538e3cdb618c@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261125-b4-mm-soft-dirty-fixes-v1-0-538e3cdb618c@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EC64940004
X-Stat-Signature: efmiu5x3584gs5ss34gjyr7qe51ae116
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795614221-981285
X-HE-Meta: U2FsdGVkX18AN3u33xjrEJEEcHY5VxuBzjJuE9ez5Ero8H5OxlKX7pU5s4bf4lbXGu2dBVNsSMBHXhtW8INmecbCxDZTtw8RY0Pi281bYcA4+lXCVcdSvv8qUf7dtJmXMrkPV76knV0DtNjT+ygfzo8iy29NNoUbaQjkA3VqDxeTnZ80USsDwC5QsQCahhKfnljczESrhnSh4UhmxkrGcwNj2z67WtbSH+Cr6kIijaRdQOZT1H89yCZBZfkG1P317U3eXl93n1J40sYmpp6OOTWWTXSPx466hvHwd93+c66puFEJOSREILNfBm+tQrripTJXMhHyiRdXB9rQpKL0bd5s5Tjwok38pAo9jaH4UHliQcMMIq8nTdvxEJ0NHmLtA8Ea0mCg9jSm8K+g01hmXSami6H7KM/MYOMONT7wEjQjDMezPvY2hjgG8H0ZxM824Kr6xAPVGlw2AC15Ywvf7xZc5VHoGhjtiUQc1dEjN241oH+TDtbh/kaPtPVqaBsneiLMq+mfb9B0mLY90RsC3i/s05G+6QezfPMHFPJsqPKhkqJuZOdoJe1ijp4/6gx0QPdU+mGB3Rik6tLSi5nV/t+n+H5BtBcmcpTUQkCxegxFvVh8Qg36EXo5MBtUe5b+G2WUnTQGARI0wEVBPSLNuLqLytpaQEXai+STOcjHfOKAHYSHgbZouwRjw/2RNbtuVzpqT4l5IfNZbjtH7BzlrgWFGeqQ9ByXwnXSjJfJCI6R4d9GHUGMTI9+01AyEtlXqkl40SWXqeCHn8FhZR0WyGm/+e3LFrQ0Et8hKRGAMtyuqZ1EUsLng+baDsC+a3ocZ5+Lr/YdnJNcV0lJ1otaReISGwzjvuNbi0p1ULDk5xc3PitVTMMdWfEuO47LKKbzDyeFB2Ht34kya310n+krVcBLAqAUZgQ/dfz9qCn8JMb5J7ED5j6zPhxJq51EmhlFFJg/GLEl721oR/sqL8v
 BF6eIRwo
 HZDlGRaSN+QI1jXvXwLb9bzOvRKItT6qu3Hjk9jZgMtzgGBQFkvFYig0Cbxr9TDduSK6a8vdGe5NzRfN13gpVlvI2nORpvn9ZBTZOwOTnp8KsxmqxeFLAtKstuvh9sjOBOHGsVjp2QNgLrUqD7Mx9PpC3K6WKfyYbmzMQJOzdhA9gSomPMK+qpyLv8z+Tp2D/tdx3fqO1RzZN86nLZ+HLAFBuvspKNrD4s21MP7MwDgRoU4gVQKodnYEX5tg7iiECP0AEuL9qdiMArl0cXTlsN8LKkDk9ar16nudJc3BsN34UzB/K6lXVm5o35a9CBkFC+gJhSD8XPlhJYg7FppKUrh36IPxU7cuWNbDPl+EyNa0oV2IAjaJ9K+7W35MZXIE4b9QQrjRUDRVT6dieG+J5DZnDCA+/nsCXRMDGwFRFTGW3PqEWrE/njKqqMnH1mOIb5QphyC0hJtwc9rMzTEcReiMjY6QHk3jIlDOx2dwnW7VZo/8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/25/26 14:32, Shivank Garg wrote:
> mprotect() handles the PTEs of a large folio as one batch, and marks the
> whole batch dirty with pte_mkdirty() if any of its PTEs is dirty.  On
> x86, powerpc, riscv and s390, pte_mkdirty() also sets the soft-dirty
> bit, so after clear_refs, mprotect() marks unwritten pages soft-dirty.
> With 64K mTHP on x86-64, all 240 unwritten pages of a 1MiB region are
> reported soft-dirty; with my fix, none are.

Why do we care? Just over-indicate soft-dirty. It's valid, and the whole feature
is full of holes and buggy as hell.

-- 
Cheers,

David

