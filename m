Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A63EFF885A
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 06:05:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95B8D6B0005; Sat, 25 Apr 2026 02:05:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E4B46B008A; Sat, 25 Apr 2026 02:05:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7861E6B008C; Sat, 25 Apr 2026 02:05:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 612026B0005
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 02:05:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0DD3CC136A
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 06:05:28 +0000 (UTC)
X-FDA: 84696041136.20.AE80CA9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 25F5040007
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 06:05:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XaW2yCS2;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777097126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+sH8zZhyp0kpjNtyHs3QHMdsCqlwUlLft0+pZyKCqGU=;
	b=EG8vSBBOZGRysJiDi8uK0bxpUzW2Om1wzymEnTD0P0NaiCm3tI8fNbx9p4t64V8xEiso98
	bz12DZcvagPF7yUl0Ye9U7b5MNYg/rPlTssVn86QBzrYsFKEPaS24nT8bWqZ26eUfaTiMi
	IMsQzsH/aDv1DVU2cmu3SBbpXXoR+wI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XaW2yCS2;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777097126; a=rsa-sha256;
	cv=none;
	b=6DdhahDjwCYVNAVcSfjjVOt9M58kbp5W3aJ75Q/ejNK6c1vKdGxB+XM6nfCAi/s+GO707x
	vzmRTE8PsCrgu2cZV2w/12QKbkK6ptu78d27bWzKzot7RZnuO7Rkqo3cYwKXUXypW9Ozvc
	fySXtivL2Y3UoGQb7AJMUfOvbxu4vJM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E1A2643C66;
	Sat, 25 Apr 2026 06:05:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20932C2BCB0;
	Sat, 25 Apr 2026 06:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777097124;
	bh=fCn5CkE9SAvKIPG+1QSeNXcmbKoRK85ZM5U75VHX5pA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XaW2yCS2subdMaUlxpPlBvDvgFPt6XRix/Vipx7bAXFR79GRy5+gY88ihVJGTr4JA
	 DwB90CNgUSlyrNWLInV70jqwTVCnzO4xgZPKk182bnCJGFpjEGwenXcB5mHQmXIeKG
	 GvumtJwbBFSSrrR5IFwDr0V0RpqsY7Vjqc4/d+MRP7BeDD7nfDcCu20Wd06zcskmZ9
	 EQ92OFzv9q5tLLJNNNosWWF6NAj6LihNtf8JUHYhizq2RPBBJHh+2NTxD8JuOchddU
	 5h8QtuloPhsrfbhZ6EsqJH/a9jSXs9R+3ljsvwO2yizfzb9yIcDGayxEa7sAehhNZf
	 8T8jq2b+pw3VQ==
Message-ID: <652b4a01-2382-4faf-bc1c-f127ee0b2c75@kernel.org>
Date: Sat, 25 Apr 2026 08:05:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC, PATCH 00/12] userfaultfd: working set tracking for VM guest
 memory
To: Kiryl Shutsemau <kas@kernel.org>, Peter Xu <peterx@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 kvm@vger.kernel.org
References: <aeTnlQUOOh-dHG8z@thinkstation>
 <34f75083-29a3-4860-8a6e-94551d37ac6a@kernel.org>
 <aed6fHLrIdahbdY3@thinkstation>
 <b77d559b-215e-460a-a268-e63b8273ef42@kernel.org>
 <aeorZMvKwu8zKX5i@thinkstation> <aeoxnuGKO3uqS2kG@x1.local>
 <aeo5IPpQi7onyjTF@thinkstation> <aeprnnccJeyHB2rt@x1.local>
 <aes7b17nG0cXrtEd@thinkstation> <aetZUOINzfTXChLL@x1.local>
 <aetyhki-UD70dyRL@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aetyhki-UD70dyRL@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5e85fg5ir7gb4359ogqsu8am6yhnyznm
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 25F5040007
X-Rspam-User: 
X-HE-Tag: 1777097125-861517
X-HE-Meta: U2FsdGVkX1/JtwV14ez4cVqF3bfvRu6Z0uybFR4alNpSE26dCjkVWOBaXqSjeXMvHvNJLwFQWc8WwxJ6N1xM/Vb7X509HTOFNmwSfwAXtvnwmF7zL46p8GgrxzLTWmLkHaGNJ+dcMTNtOQuZyAqS33UnMqMuWIOBTKxTzTdCdT3bk+dRTacAS+cAuzPfqlX3XtWfMIOWvE9pye+c11mljzh5N0FTuaD8fjyeimk101nD5efiHQsvaathY+ZtpLZUggAF/UwIchG5gaKudrQ31/KNbhEdPY4DWVVTXcXL34RO01Vkjb6+fhjvhd9Id5JXr/g/+pK14T5I8HEPkk/j3L0cA3zhOmKc0eUvfmF6jUyUv23RHD14WlSVcTdpt8bwqd3cVtpyywR2k7eWVH7RafRF26SsDegrRzqlPnt/XOer3XyaYJ5DfPpYWIRYZ9JVCSsRWZfRNc6SbaRS8PE9TYdH1mW4jFza0Fu+o9QBSqaAuUb0cI35yqiRG5pBQjBGUdy/1ebAU4hp7tzbOrifJDVY7G/I9AHXi6Qy3/ikeqBcvUEUtCeM/2jvgil1t2mtjwMu/NkM4L1RBhxwEkWgsPx4bA5TaiKnH2TM+chqUgHXhCbA1EHdNGuwkHp+NOfZ4A1Aa6b736u926034qyYzWUMsBXtyqI0FP/4QhFdG7ZnWQzMMEu5XGwSXQvT/2/6s62qYhlznybW9i6gxg5uRYSK0tRJcKUbajLJBl5RF9z0+00j206/ZZYKi3RGWm+JR8IRmY35RtOVKUwJho4WT8yjqbEp8LTLATueVjZ1s7KeLG5mkb5y+zpNixhK0ZFgmwHV5VHRLTT5gk42LLLvO5q2gfw/Jbse/3+JWRUrsbEnNTG42EYLYTrptRdRuhOXuxUI/w6BO+ei9JWQjbtDAO4guUUA8gZRPdmBnN5js08ykm6BxRx8gHcRzAuNhrOdA/8qJ1kmwGpMVMC9lDJ
 R4KvJNo8
 7BHAEuzLugDYL4H/LTSK54a4PvKLctJguujdN/9IwieL1NmXTehhz7+X+E2hNCR4YMPygjrfz3fb45mwG65FmH+WvbXhN8rjtvbriwApEIAkX58RYnGjGuntC8eQq4M8VgsBvf/cj4fz6WkAQvmPM/wG1gOfy8mKl0kq0YWHPWNAU0Ow+lAMseRF5FeVa0z74oDrTqh98MsjXvWuPKo8LdsE1oKeFkNnFxVDAtF0S/A8tKOE4A9QkEBgEoWzIPbJjTGKH52Rmc8SHmovBjG4Z1XCPVNroNeIbIlRX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 15:49, Kiryl Shutsemau wrote:
> On Fri, Apr 24, 2026 at 07:51:44AM -0400, Peter Xu wrote:
>> On Fri, Apr 24, 2026 at 11:34:48AM +0100, Kiryl Shutsemau wrote:
>>> Both page_idle and the LRUs (legacy or MGLRU) track accesses on physical
>>> memory. We need visibility in the virtual address space domain.
>>
>> Yes they are, but ACCESS bit isn't.
> 
> A-bit is not a reliable signal for userspace working-set tracking
> because the kernel itself is a concurrent consumer. 
Right, I don't think we want to rely on either the A bit just like we don't want
to rely on the Dirty bit in other code. (and even SoftDirty bit is a flawed concept)

I do see some value in a reliable RWP mechanism based on uffd. The real question
is, how much benefit it would bring (which other use cases could benefit from it).

-- 
Cheers,

David

