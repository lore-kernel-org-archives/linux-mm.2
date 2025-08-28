Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ACE4C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 10:01:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 581328E0019; Thu, 28 Aug 2025 06:01:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 558D48E0001; Thu, 28 Aug 2025 06:01:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4953E8E0019; Thu, 28 Aug 2025 06:01:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3A1178E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 06:01:12 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 137D0160AA4
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:01:12 +0000 (UTC)
X-FDA: 83825723184.24.4F332C8
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf18.hostedemail.com (Postfix) with ESMTP id A25C01C0007
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:01:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=rsbvXDcc;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=7ZdJTIn4
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756375270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zAFcuTOsjFedDbDPzSuDb7+jYLKRszwwA6XBeXDqbsE=;
	b=721anRU38ReJxMWsNj19CKSbPx+JErty6PRjWVek+Be+49DI8Va9DVt/IgmP6VBwQeYbel
	77Rk3lxHoysB5eOMrRSZgog4WOnvK95MggIHrCkyQqT3BNL9fVx1o1TdE0ki+FMnJBPYHA
	vDG55lkakbMGhELx9efd6t/Jz0B5bOE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=rsbvXDcc;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=7ZdJTIn4;
	dmarc=none;
	spf=none (imf18.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756375270; a=rsa-sha256;
	cv=none;
	b=rtDZuLkByjeWp8NXQadSEFUnItQOVbK2CxNj0xHUNSOUMAfZ+cQn0oRdjSAQvT0invCzTw
	dgllMXUlKp/9F6oNkCZawa6EocBZkr7akAY9o939ov8W/MR2s5dNGIbDyPmLpcS06glDOc
	I0WRsQhCJhnFRPRf9rJdt5jQH3iHSgI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1756375267; x=1756980067;
	d=konsulko.se; s=rsa2;
	h=content-transfer-encoding:content-type:in-reply-to:references:cc:to:from:
	 subject:mime-version:date:message-id:from;
	bh=zAFcuTOsjFedDbDPzSuDb7+jYLKRszwwA6XBeXDqbsE=;
	b=rsbvXDccnCmYC1ppx6HmqRRi10XQ8PdWuZPcWhPGeAHTpAyPV/GRb0pCgAOmM5Au2h2Cd6rdIcSMs
	 cgYZbUIZs3tkWMpMSjSeQRU7OFfYFZQ3YcUNN73zHgd5/v20LDVU4lvq/RiR/x0kKUDwISTf7XwgjI
	 hKiKemzPR5dRRRhKVeSYOpI+g0qad7eRIxLevkIXOioZzn7g6Z9c0G9eZhu0iALVtGVdPZcguP5wS5
	 uT2Iq3iuNg8pXZldwgtR1MRxwmYfV7glFe7fQIOJ2nkTk+tosRs+A+klzk/328seCwbb3pXldbpk3V
	 iAAwqxQ2qN6YWapnr+bdq5n33GkiUaw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1756375267; x=1756980067;
	d=konsulko.se; s=ed2;
	h=content-transfer-encoding:content-type:in-reply-to:references:cc:to:from:
	 subject:mime-version:date:message-id:from;
	bh=zAFcuTOsjFedDbDPzSuDb7+jYLKRszwwA6XBeXDqbsE=;
	b=7ZdJTIn4UbYjsUHr/FZLziU9VwkxS5MDmxWqoghzK8XHEFdoZScrBXEB4bsP08cuYJ3WxdRfbYuPn
	 TqLnRqhBg==
X-HalOne-ID: e94213e7-83f5-11f0-ad4c-f7376af24660
Received: from [192.168.10.245] (host-95-203-16-218.mobileonline.telia.com [95.203.16.218])
	by mailrelay6.pub.mailoutpod3-cph3.one.com (Halon) with ESMTPSA
	id e94213e7-83f5-11f0-ad4c-f7376af24660;
	Thu, 28 Aug 2025 10:01:06 +0000 (UTC)
Message-ID: <d91e6483-c5a6-468f-b40e-1acdd28a80cd@konsulko.se>
Date: Thu, 28 Aug 2025 12:01:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] rust: zpool: add abstraction for zpool drivers
From: Vitaly Wool <vitaly.wool@konsulko.se>
To: Danilo Krummrich <dakr@kernel.org>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 Uladzislau Rezki <urezki@gmail.com>, Alice Ryhl <aliceryhl@google.com>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Miguel Ojeda
 <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 Bjorn Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin
 <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Trevor Gross <tmgross@umich.edu>, Johannes Weiner <hannes@cmpxchg.org>,
 Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
 linux-mm@kvack.org
References: <20250823130420.867133-1-vitaly.wool@konsulko.se>
 <20250823130522.867263-1-vitaly.wool@konsulko.se>
 <DCCCRYEUVJWZ.2AUDA0DXK0XSF@kernel.org>
 <b1509e7f-4817-4466-bd2b-c083f024c0d4@konsulko.se>
Content-Language: en-US
In-Reply-To: <b1509e7f-4817-4466-bd2b-c083f024c0d4@konsulko.se>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A25C01C0007
X-Stat-Signature: a6hh8i4ufmyn8b97z7ug7wmznqpzza6i
X-Rspam-User: 
X-HE-Tag: 1756375269-852869
X-HE-Meta: U2FsdGVkX19iwj9tSnOm4iIvUBJBEPud+7+dwwEdOam0OnFFVmkKsSR4005ASD/j/lcTyV7hTEeqJ5UKKixPX4wWX3Iq/MGWafHJho9/NprWJazbUCDYMt0xalrWGIUd2O2scuJIZUhRU4QWD/Ib47jktHVj1i8+m28jnzs2X13vjVF0a3oXSLKDbr//s0qrBpfRdEXlPeMXWrGi/izL86K+DLtxAy3Qm4BkJ0apHJqU/nMCpa5FkRhWvvdk8MQMk3DurXNaYxD5O7ZAFG/TQnd1WaIJnIhRS67Q5ulfD1F1h1eHZOmcOx7Hi9ieunaNVYZiYgappPTAlxxitHZaG0Uk3eQDAGmrKs31RLVyqsI++ptoqUjpVOpqOEhLPgCFSClBS98Gkv2XnVNdkstvXZv6bBalAulBPw50E67bz3GHODfIvBKWGer4ldrdGxeezfnwHl+dUjA7n6J8DehspPdunfS0yJvqXfqbawM5k03n55WmfuWVG2rxAux1kpa6dPJkfUhjXpfIpu6pIHeMHCmerhrFwip0hbrIzvbCgrjwRL0jKDgTeJBbWb3wcGYZjqLyla8u2gIgiyqEl532NgzkKW5QJ6YJtKQfXBCqpUnKa1dJrSG1ZhkNUKOo26dFQ/XZrcP3tCl2fh2NL4weD6A+t6z4aZsdwIN6XqASXEBxxnlwgSfmxvjI1VZi/LBJ4/ndNaYZ/7Demts4cD/OFPe4xpTuPCqHllpksDx2JTxdva6mifnYYMRSMri16AbSIusK7+tyX7m4GRB9ZR5jXM+dFUBUjM7HgEZwkjV1fCWnfM39WPu/HVJfjSFeoLbFnH2MPqgghpoFqV1RPbTwnrfUAKYiyGRnZaFPjeDXzca8N9ajwAPp5shQg/j1JQ/TgwSSk5E8GB5tNQJJb+f6yKM8LpZtiSQSOloz6ZTCTDGE4yG3SaaFxh0cLTVUsrCAoGLJt2ftuu8YihA3iaH
 seScF4LH
 tYtCE3huKgTZmes72p4XGj3H7oGjeuWq2nTMZnzbx+o7KOOJ5WWe+vlCTwRKRo/CPMRofMk6A5h3PTE0r76Oo1X7tCLbaMijHERutkUFtqjtaoif15tM2lN2kykniN0zVxKS2GItf5OUnvXjQKaIsInZwDNM7s3oWZcWah+D/y1ZJB0Kfffds7N/KqjEgmL/Ptx51TvWGztz5udw4tQQtlkyhbVwPEDu7ZP8wKQnEPEludUKZjO5JiZsevI6ZmG1LlqMEYKuzWuxJl2FKdNm6GVTB0Eab3TzpArT2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

<snip>
>>> +    extern "C" fn destroy_(pool: *mut c_void) {
>>> +        // SAFETY: The pointer originates from an `into_foreign` call.
>>> +        T::destroy(unsafe { T::Pool::from_foreign(pool) })
>>> +    }
>>> +    extern "C" fn malloc_(
>>> +        pool: *mut c_void,
>>> +        size: usize,
>>> +        gfp: u32,
>>> +        handle: *mut usize,
>>> +        nid: c_int,
>>> +    ) -> c_int {
>>> +        // SAFETY: The pointer originates from an `into_foreign` 
>>> call. If `pool` is passed to
>>> +        // `from_foreign`, then that happens in `_destroy` which 
>>> will not be called during this
>>> +        // method.
>>> +        let pool = unsafe { T::Pool::borrow_mut(pool) };
>>
>> Wait, can't this happen concurrently to all the other functions that 
>> borrow the
>> pool? This would be undefined behavior, no?
> 
> Theoretically, yes, but since pool is actually Box<T>, it's only the 
> inner T that is mutable.
> 
> Anyway, the only reason for malloc() to require a mutable reference is 
> that the backend implementation *may* use RBTree::cursor_lower_bound() 
> which requires a mutable reference of the tree.
> 
> Would it be okay if I
> * change the Zpool API so that malloc takes an immutable reference
> * extend the RBTree API with a cursor_lower_bound analog which doesn't 
> require a mutable tree?

As a matter of fact, the RBTree change may be postponed and submitted 
together with zblock, it is not relevant until then.

~Vitaly

