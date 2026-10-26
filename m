Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1794606A323
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 21:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CQuxmZUJ
Received: by kanga.kvack.org (Postfix)
	id A0D9A6B05B1; Mon, 26 Oct 2026 17:08:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BE5A6B05B2; Mon, 26 Oct 2026 17:08:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AC7E6B05B4; Mon, 26 Oct 2026 17:08:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5C9356B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:08:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 97B314088B
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:08:28 +0000 (UTC)
X-FDA: 85366015896.03.CCE06E1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id AFE1B160006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:08:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CQuxmZUJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793048906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PC1CXbiHzhQLku5W1cl0FjvjhWJ5KEZGUIcph1ecHwY=;
	b=knNyujXyG2gufH3Cbu4w35Zh7jLiA5Rl3vOk7nBVFaIX8TBZ3n0fwVqcLpOoeTPCwCKhrK
	6lDIMexxvjseHYNNeLKQhYhxQZyrJC2dfHuc9FLedLGqTDvsqve8wCmGpdZsnOaAuCXmjx
	qtTPuXzyeNyt6DAwGS8+gMNZJTrTbYE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CQuxmZUJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793048906;
	b=2gTC+h4zyNkUSx/uq0W7nLkVymMGZT3rIbrGXsSVOXBd06X6I0NwW/FMmRFz6Ke95Rytu3
	4m10iGAXHRGT8fdQwoXa/TBWbjlZ5RxzqcGfusKv3+v9aCSquR3PthmP4gJhkC5ay8K5TE
	150kJNaYP5eMT+vKAUDJX3ZCNKAt/BE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BBA36405FB;
	Mon, 26 Oct 2026 21:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCCDF1F01825;
	Mon, 26 Oct 2026 21:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793048905;
	bh=PC1CXbiHzhQLku5W1cl0FjvjhWJ5KEZGUIcph1ecHwY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CQuxmZUJFoHe/jVdB/Td1vVaISzkT31yz4kuoP+9Yf6XgCaMbl6F5B4zTdm8amOx6
	 Z2zDvTa7sws8ye+cXb9w90RQJ1xrpGccTMU/inaNNbT9EOS+7YKzBDHxrl8TVHJpKi
	 jQVOUH5FOREAqLhZHRorelHQKb4HpsMDpXypnX13JNXddnVaAyripGFIM3k/BAYi3t
	 qhee9qBa0Muu2zQtovUANgP48Gz45LaFAzSypGrjypZDV75SDXJOWSKQO9cLhgq8IV
	 aahuPEKJro72FUipgua8rXcW+Tz43i0i+D+bXeiJ5dnHRDltvwZPwpMrkGuVDew2YA
	 VT7p4t6xKB7Qw==
Message-ID: <ebc7bde1-f52e-4da8-b16f-822d6c0a4d74@kernel.org>
Date: Mon, 26 Oct 2026 18:45:48 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv7 13/18] mm: Drop fake head checks
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260227194302.274384-1-kas@kernel.org>
 <20260227194302.274384-14-kas@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260227194302.274384-14-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AFE1B160006
X-Stat-Signature: n9c6xge79gimoz4muguynxp4ad59pprp
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DATE_IN_PAST_03_06,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793048906-856729
X-HE-Meta: U2FsdGVkX1+09dn0eZSf4ft8GLkUMBvZIGbcmZAcm/xzC4VasWw0VuNQqdNxAiAUuJcq674cxHgbTzIe2EwGeDTrqMX1dBaRrgLm3uJ3E5h9WBt8u5zBg9F7EyiZXE2v9o41cTqsEBTgYS2ZDiBfz13MhVppvQL5iFO8qD4sBauOV/Fn7Xj0T4aZVhfHqjv2quOb+9HxW5uPy4c+yOuzlSZYMO2Q/6gNBtXfDw7N2JlHFCDL8ulrlvC0SIEaTi/e0lGqoJx+/bhg77be+HE3HNq/rr7lgbknYvytB0PMkk6O/PYFhCuUruiHxagQqmZqsLPRM0knyt6I0jnTvIHOUcrJ42jQ6SLLjNgDCC+vlRNFyFDvxO7xyTe5xbar5lvSWpaln104x8QhrYfMVbX4vTMm6bsM+M37vuRosFzgpAqDTlhbzrOgSerB9MgQ6KZDTLYdlofyqP9pCrTjsw1UtFRfG3PO/yVjVxIAmgHKStM0AUGskIHHMhx99LZgmjvvk4IHOlb/6PlYywENvAC9P5vf/2F1Lew7aIf267dsTNer4swsC9rNY9HSq2c14eVSne+1YyEC1jkwzWvuyYOg59tGRBouit/Cbe3CrPQKH+ftQpwFk38CNg1ToX3dvNT+kpN35Hox05KW3L3h39OSRXJGGUo6FfZ93fn32Jv32s+NibU1y/vlq28NTmeEC7SmDtJTA0hrmncIQnQpy4Ukis7DzccwVN4n/1b2/WeFBEFkdHk2mVDaUPvsNWcsCSLZv5wrnfIh4nFQqoUEkLzlzNwbbus4hSnvTMpUi0jIJ33JRNAvfcJKTvk920OceJJmBQEy7oLmBtYy+qw5kbuCsgJ0y0qYgAW+jFDq9LR1Be/5r92z8CQvzIJgfpUBonmideZTtRI9GGRr9Coozv1luAxLCrkIpivea0nVNF4MlxSUZUStpW2RlbxP+iyO4y+vHsOydYpdh0kSC1swuHy
 cvmnn8qV
 M6B+DZ6oz/uB/RRLQxHq+Qkp7vowqj0xm8Fo1GkzIAL8NV4NhLneughNrABSd06nMxUuFQv4GT6YLJOXFHIyDAm6y4RPIvp4/cUNiIwnOUhson85Xln5QuEe5VFGsjG6ifCO90061NnKiJGk4pGN38X8Z7RG+Vl2N0GE6aEOgCIUTG9MBJYI6BnUBVchnxVuOyvvrFPdW0OMAx3qN3iXgxG4G+B4b3hmoZO7clkjnftkidgx5UOb1AvmwUPYSjp+KsCZ05wJRQe7iIDrIq+IORw8F53WuFBzBMKw1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2/27/26 20:42, Kiryl Shutsemau (Meta) wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> With fake head pages eliminated in the previous commit, remove the
> supporting infrastructure:
> 
>   - page_fixed_fake_head(): no longer needed to detect fake heads;
>   - page_is_fake_head(): no longer needed;
>   - page_count_writable(): no longer needed for RCU protection;
>   - RCU read_lock in page_ref_add_unless(): no longer needed;

I have an AI report that removing RCU read-lock was wrong.

The sequence is trivial:

1) read() -> .... page_ref_add_unless_zero() -> atomic_add_unless()

	int c = raw_atomic_read(v);

	do {
		if (unlikely(c == u))
			break;

We pass that check. Then we sleep (rescheduled, vcpu rescheduled etc)

2) Page gets freed

3) Huge page gets allocated and HVO makes the struct page read-only.

4) 1) continues

	} while (!raw_atomic_try_cmpxchg(v, &c, c + a));


Then we try to write to a memmap that has been optimized by HVO and is read-only.

Apparently easy to reproduce by adding a delay before the cmpxchg().


The AI fix I received alongside the report is obviously complete garbage (as it
causes severe overhead on all fronts) and I am going to spare you from it.

Can you look into it?

-- 
Cheers,

David

