Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91226EB5976
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 07:46:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 793C86B0005; Wed, 11 Feb 2026 02:46:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74AD66B0089; Wed, 11 Feb 2026 02:46:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 677596B008A; Wed, 11 Feb 2026 02:46:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5A06B6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 02:46:04 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 122111A0287
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 07:46:04 +0000 (UTC)
X-FDA: 84431392248.05.1DC47F6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8D4E9A000A
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 07:46:02 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WjoXhLin;
	spf=pass (imf15.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770795962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TXJeQmJooF7lpDMCyPkjYa2bR8jfGqyQvIQ04fS75uI=;
	b=DfNHNBFtAn8aFf3rHlLTgoRKU/TG99KEDYFBfF1UYLLISiwVs9XgZztNfk93U/cqv8b0nt
	I9KnOMIvQNdRm8a4tNjAMSRKmqTN7x+psygkj0TxO+tfjPyjWs69qGXSXHl48/tG4EGejP
	49rmuuhSflJTjwGh62ToQF4sS9LANoU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WjoXhLin;
	spf=pass (imf15.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770795962; a=rsa-sha256;
	cv=none;
	b=dprL10ENMxOWF345K2YKfqR3aeWacLK49oOXFNhOQGvXTpfvWG/rmv6rcpw8OWJUtF/9GN
	gho2+gmSK03rByhip0CW2ctytrDGZSvmxBKIrfhseDz534VCUr5Q3+oJ2+F84b291Zc35h
	NtWyjpC4m+KoZSVxVsFv44kFfobSa3U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E1F5160018;
	Wed, 11 Feb 2026 07:46:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358C9C16AAE;
	Wed, 11 Feb 2026 07:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770795961;
	bh=hau6d3ZhCXyylwP7O8OXnAGlNr0yKooB+0BVaN+WS84=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=WjoXhLinl3f1PL5VSdMkEFx7huQUHpF/rhUM44BTvCN82ViE3apyK8REuLM9j/DZ/
	 e8GNF9PyhxwXU8PfxztL1juUg/eYmbdAeUPvSETxtxhc7dLQOs+k4/8daYlOnUVKxv
	 e9ee+fqB7o01kNZ3+6h8bSkqp3k3iveXaqCxjQ16w8spJA6jz5zy2npWbbVFPgj2up
	 q9G5gnVVo0RczCvDFRaOU1Cxe43loYU4HJDWiso8DOJgySlYXQmy+P5K73dalB61mr
	 NEYpfidta5sUar5G1LDYJuC2u8Nbnwnb2rJUxoqs/ked56KpiUdeTYKR5pFJv3uHp+
	 6D9cGFXqV6ljA==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Daniel Gomez <da.gomez@kernel.org>
Cc: Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Andrew Morton
 <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, David
 Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Harry Yoo <harry.yoo@oracle.com>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, "Matthew Wilcox
 (Oracle)" <willy@infradead.org>
Subject: Re: [PATCH v3 11/12] xarray, radix-tree: enable sheaf support for
 kmem_cache
In-Reply-To: <aYrsR5VYH9JHeIoZ@macos>
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-11-f777c65b8ae2@kernel.org>
 <aYrsR5VYH9JHeIoZ@macos>
Date: Wed, 11 Feb 2026 08:45:52 +0100
Message-ID: <87a4xfvi33.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8D4E9A000A
X-Stat-Signature: kkh9w69g4ba7f9gdjuq8nfnjoz1ginb4
X-Rspam-User: 
X-HE-Tag: 1770795962-604207
X-HE-Meta: U2FsdGVkX18cQYxPw6EPI6pTiCGDMUCpfahvvUoxqTRSvQTobRhwZZ/FmUy51tbkLmNL8r1n+cebWZ7WNbJqWznoYpWnmhkoCqAQceI5LuwY1xdPgmkdVQxo1NKdlQIqwBbCDOmBxJ6pl9T6TEI6J8W82m9o/ct69a2bNIe+B0bOXp+4NS7pRN6si6pY1zXX5hwK4IshqmbhDVWXAsuZQGirBbNgqKPBcRvthZ/Jv9WQo0sNWMVAUioxZIGd687MQYd3pKDpoBpdlKjyYtXR2H1awTfG+s1F4M4JUesKnMJJlSLILDyw/sAB+21e05PBWI+IruUMBOXEi189og/AFEDVfAveU3t0L6UEU8h/t4kn8v90OaCYRHTfBaTkpnwacmSyhr5Q3RQVSaXOpk1h4h2tDQTdBATK9mpVtahjE1R4eRUV91ABnb8RfROh0efvfCF3s5xExzcBLe38/P3B3UMDUs6HMWx8Z1MpnBPhpZn96WLrxuNf3E/1qBIShwggiboKy9QekLWHSYDCaY+sKpe4MoN1KKCV6VwyhS/W1xawgS2ukjyZFz6H5LTIC0HukI39Iqijoh+wRjm5aZUAHwWp79l5ro9JcAd2u4deB55Nd3ObRb41XXGG/bpgrSNh75u4A3k4SaDF1JCbjC2r+J8qgvk4Af1plal5okVNXDPLpdf5voMKVA100onNrrMi4ZQ6xKzBnfTD/HG/kYj875PSRrYfWfQEqSe208fqB3Q34janKHqKulaRSh9f1E9oNjMIuCGHiu710DLUdYGNYv4iOxfgkLfd6aVUno4OPwzvrgUA15XNqht56iGG1cHn20Levp3x+dGHVb+AbiedU9E5CFetQQRa/40lh+AU1M6ntzIUmRhbHkcByXFmO9q436B8ggSVxIqDUrhrK6fBpcna0Y9wKhJr4+RGL0mCeXJVoDG8t2Vvyqk58aFlX4pBctyXZ242FGu2TRHC9f5
 ZFvZxOmV
 2hveO1k2MU7Oo8hrj2nYU41gE8KJqJNqy5yv0wTfbXJcq+jOucTjEYwrVkZUvj2Igg921d5V2cbGANfW0XCwv2JUNprBKbZgwII99EY+SYc2tgaED/18NGxUrejS4rWOeqqrIYioJAT8NLEABtqLyEaPsLxSSOdqKODW4ITH8sqJmrJV5S0iW7JzGaGR88YloulONGKF3D0o3f+w0EWgxyPZxB5cFLqlYiCskMXJHIfMsHuFs8Ocx2fD5tTT6KyMkygtNv9Gdc+sATmoAk5Ti+o1Fs0alRe7WJrFGlC4xAZLbbsc7ZvvplwmKSoBnqmO90tZJ00xyv/N2T3VJokFEKgUkIMeBTaT3G6RN1LLgVa3rfXM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Daniel Gomez <da.gomez@kernel.org> writes:

> On 2026-02-09 15:38, Andreas Hindborg wrote:
>> The rust null block driver plans to rely on preloading xarray nodes from
>> the radix_tree_node_cachep kmem_cache.
>> 
>> Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>> ---
>>  lib/radix-tree.c | 14 ++++++++++----
>>  1 file changed, 10 insertions(+), 4 deletions(-)
>> 
>> diff --git a/lib/radix-tree.c b/lib/radix-tree.c
>> index 976b9bd02a1b5..1cf0012b15ade 100644
>> --- a/lib/radix-tree.c
>> +++ b/lib/radix-tree.c
>> @@ -1598,10 +1598,16 @@ void __init radix_tree_init(void)
>>  	BUILD_BUG_ON(RADIX_TREE_MAX_TAGS + __GFP_BITS_SHIFT > 32);
>>  	BUILD_BUG_ON(ROOT_IS_IDR & ~GFP_ZONEMASK);
>>  	BUILD_BUG_ON(XA_CHUNK_SIZE > 255);
>> -	radix_tree_node_cachep = kmem_cache_create("radix_tree_node",
>> -			sizeof(struct radix_tree_node), 0,
>> -			SLAB_PANIC | SLAB_RECLAIM_ACCOUNT,
>> -			radix_tree_node_ctor);
>> +
>> +	struct kmem_cache_args args = {
>> +		.ctor = radix_tree_node_ctor,
>> +		.sheaf_capacity = 64,
>> +	};
>
> Is the sheaf_capacity matching the number of slots in an XArray node? If so,
> this should be bindings::XA_CHUNK_SIZE.

It is not, it is arbitrarily chosen to large enough to gain an advantage
but small enough to not waste too much memory.

For rust null block, it needs to be at least large enough to insert two
leaf nodes.


Best regards,
Andreas Hindborg



