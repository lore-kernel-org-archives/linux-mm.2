Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00E5EF3C263
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 13:46:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B2C56B0098; Mon,  9 Mar 2026 09:46:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6697C6B00A5; Mon,  9 Mar 2026 09:46:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57FB06B00A6; Mon,  9 Mar 2026 09:46:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4975A6B0098
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:46:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E361F1B6EB0
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:46:12 +0000 (UTC)
X-FDA: 84526648584.25.31CF5BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 23B431C000A
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:46:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kAJgUG3X;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773063971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8/QncjDbqxrgKnQi1N2T/qIWgaAe6xRCgg0IrW1kdLk=;
	b=MP8iDiMlm5Jk6kPB+YT3RNHWO95rAfNluUrhGwNswM0ma0O08TOYsIQiF+3SL66XMBOLdU
	dEubML/usG0Z5WkqwJ6OZVn0Py3sQDKTjnv/wzDp8z+SIs1vooyZZ93diQqk/dBE3MdRhe
	UIEuGXMmJkv+Dg7D6eksn9OWR03PjAs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773063971; a=rsa-sha256;
	cv=none;
	b=UWbhPza4M0e1t6NAfckF9LNDl0X+XkKT8mliU0O+/WBSKrtaGszZhBJf/GPi4AHZQ9MV94
	rOH4ksUnglO2gc4O+bIXSenthVLXFc7A1RHEBxXfYTOVcFfhti1w3CTJ1tzt4iRSwoHKIJ
	L7PU1pPKQfJO35mvczqVZVBToo0FRC0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kAJgUG3X;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AA81D60131;
	Mon,  9 Mar 2026 13:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185D4C4CEF7;
	Mon,  9 Mar 2026 13:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773063970;
	bh=OM97bWXBnd0VBOqYFf1pVUaQvZcrYTh7q6Afau4wh/0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kAJgUG3XhSrmTrl/QlibTCR87GueAM6hZs8p0kFsSDo/3SCgHshDjV9CVhw/vRHkl
	 8hzM7nsFs/OPj3s7NjfQQkCgKfT4pOcp1neidbSKyVfjMe+H3/pHIEVLtbAMo6Hrau
	 tIxoMJOsLK3MD6yFDMwBLRAM0539H+biby1SIXdpSGOmXKM7XccxLPdzP5EFajDOsU
	 MWe4FbBjtMArCmFrYC81K3GGd8HiOtKcV0j6l24pJInWsL47ihrmvd86xz89twFdLY
	 NpIELSNrqYQfeQAzAJlysU5RYJ9D+Hoyypb/DUMBsVuY5Ha6FlUHz9A45n+0XKtnwn
	 /86LdWNH5X6IA==
Message-ID: <52a57e42-b07c-4630-83e1-86fd2a5ab99d@kernel.org>
Date: Mon, 9 Mar 2026 14:46:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/4] mm: ratelimit min_free_kbytes adjustment messages
To: Breno Leitao <leitao@debian.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, usamaarif642@gmail.com,
 kas@kernel.org, kernel-team@meta.com
References: <20260309-thp_logs-v4-0-926b9840083e@debian.org>
 <20260309-thp_logs-v4-4-926b9840083e@debian.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260309-thp_logs-v4-4-926b9840083e@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 23B431C000A
X-Stat-Signature: 76zernau9xoyc4hnsudewe5q1tdumfyp
X-HE-Tag: 1773063971-621507
X-HE-Meta: U2FsdGVkX19deYNt6d54Ijd4pmwfnuwtTJrlubO9DM6lQU+VreUsOIv5SKVZ4xf35WitOZy9L+gpP9gcKmle15mpC5bNpGRzjcARTxEcoRVULRIsl/M4NLaQTly1FOp6cZAnplIKKxZYR/S4Lb4Vtc8Gd3Y6JZRpBRd6NpiMlvT8k15UXbdzMmGu9HEzhs2UULUeezXFIL49v6qty/b8O/bCyIQh2SHm0HDtBEUzaMOTNnzcMTsETCzqRdhPUTfyQBGE4yNbfl9KanSP9hcMgkK1PgCF5v0VcBOZk3bG00HH2qWw1iS7Club1M0SIo6VdcgbhNe2IfzFEYGLsCp3HbIrrp3pAxfRAl1JqctiWzBdbK+oeZuM+IsgQAIBt4GV1sGl2pF/qnXUwxVdBABLADKTNXu8DG3+kTcHeIGsqY9z8vqr+zvy9gMpAX9OCRpUj6iHSCgrA7e+FcjFyBKVmK1OoEcXv6WTPyipZT+z5M5bqW72Z5AvoADO5ljZ6abNL7IIPOfCc2C+alpPRHpmmu8NrGdTCfu+UfuwsYoyYIeadzYld1yZHbBlwWbM2p3Bsw3I2ffgkyjBvq+XHwbr99JlmG07vy14UcHSzjYOfwPmkXVqPyzr66NGTPlJWzO2VlKPGt82mZi/xdSnHibv8muLKTL4mIVGCG6tJUtp0VExFSmXxwlHFzrYRHymckO4GGuzgfPgOmYi/0aIPwvJaGllfF9QyAi5XGwP0ZbGWEegeirjMaBPZmXV5MmlgnbxFHAk1gOpla6tv1w/4TtbU/wkc6cd60axHFPsIA4/zoFkx0r9nJ65mMQ843fkRdW8YKiZzW0fld0H22Kn8ivNRuPZAmOatcA5tIXbj+FWFFPU8iHYUK3qshqhfl7UMixJ6cDlzdeFjyp7KBuKzZfR5mX9Fo/PsdecG6gPZceezzRsbd5xEowOAL8A1WhX2lhgr4FbPiI9pc/PtUeI17u
 TTLvUMH3
 5Ri5qzlxQq8KZp1Tyl0RwcFkZfUIbvrOp4ceMuWvZuojwY6ImNAD8kySkGCANhiEY7ygNQWmxRTZ+jFQwUSsZNamJTRKKRlKfMYdVjH137rKXBBlFXsyzMN3HjnWwcRXYnSUWUL5ETlczR9Rj4dQBfLvrfv14v77SGr2aJeQ7jtzs7W4FFpqVUvFC0hMuWj8xFc9T03YhAq1zqyLte83Kgln/5fchFI6opE9IEgdKC4frtsOGDnznbMUiQrJnViRVbynaUCE93NvQvEo45IE6iQ/6wVu368L3WctmrnpMZgxuUBQRdq4PAE1P7BuYHni7Ke36soe01LIh75kpPategbL8x1m7Lcqsf02W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/9/26 12:07, Breno Leitao wrote:
> The "raising min_free_kbytes" pr_info message in
> set_recommended_min_free_kbytes() and the "min_free_kbytes is not
> updated to" pr_warn in calculate_min_free_kbytes() can spam the
> kernel log when called repeatedly.
> 
> Switch the pr_info in set_recommended_min_free_kbytes() and the
> pr_warn in calculate_min_free_kbytes() to their _ratelimited variants
> to prevent the log spam for this message.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

