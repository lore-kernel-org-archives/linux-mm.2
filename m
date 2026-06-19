Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B768DCD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 11:09:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBC4E6B008C; Fri, 19 Jun 2026 07:09:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6D006B0092; Fri, 19 Jun 2026 07:09:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5B696B0093; Fri, 19 Jun 2026 07:09:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E4DE6B008C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 07:09:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C36CB403DF
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 11:09:20 +0000 (UTC)
X-FDA: 84896390880.15.97B97D2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id F379D40005
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 11:09:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V7H57MqP;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781867359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Q/qwAquxpbKLtCHLnyb47Q3k75l47d1my1GdA2k/Qk=;
	b=Z+1N9nMfL4QQuYoJa0EtweyJX/pncYJgpAiWNX3HFao5ldlBSRGgoX20FFTuB3yYw7ci3F
	YPixAWFb63zAx8nVuoHVpgrkPRvBwV00G+FQEtBQqWG7dw7+hd8FQ41uwK+tv+dXkA2Yun
	Xtp77Z4PgyM2Mb21heBuiyFsxxgasfU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781867359;
	b=e8FxohAsAOrrH3RdwhPVvosaGwiG/6Df4Rc+lcJZgxgobrztoG8sgjRuNn+qGkJTj7PF5c
	kw7RukNcxmegSWyvoKS5PeoT46+/y43MLlFKv3GvTJh5cS03fAmJdb8uD9msrIDHnUzSfn
	pG+N/fRcXI6lmhlCd04x2rrfAyhxzyQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V7H57MqP;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 529A0601E1;
	Fri, 19 Jun 2026 11:09:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D611F000E9;
	Fri, 19 Jun 2026 11:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781867358;
	bh=1Q/qwAquxpbKLtCHLnyb47Q3k75l47d1my1GdA2k/Qk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=V7H57MqPiRK07WRpuk61WJMDO1K3Rp4f7+L6YDzJ11J38aG0GqD3Af0XJwNQCEP2D
	 Nmulu89ZObRsODv3lW3/zKxIbl2tSLzSYsr0XsZiUQxpZiNkSNiQGByWkGMnQc3zwz
	 tANAXBCIcRDhJg77kAG3epLL1OxYtgvDdBY88kEoUxhUd6YVRymuBDB9jyOClheQHY
	 Ps7P9rRmBnum+lYJSLjz+BER+uTypXkZhcLbVuGFoVSWp1CMUBZIBDj98+VHVlsWrZ
	 r6rIUGdiOlWGE0+pVR0gOPKFdNfuQw7CvoOuEKV7k67zvPbYqifgfed/rRZKyJJ4Fq
	 cUw3KDN/P3lJQ==
Message-ID: <f679fc68-5ff6-4715-9a07-9eb3074b2d1e@kernel.org>
Date: Fri, 19 Jun 2026 13:09:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 1/3] mm/huge_memory: make persistent huge zero
 folio read-only
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: dave.hansen@intel.com, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 luto@kernel.org, peterz@infradead.org, hpa@zytor.com, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, yang@os.amperecomputing.com,
 jannh@google.com
References: <0e5b23a6-4895-454a-9dfa-6dc21adc2991@kernel.org>
 <20260619025553.226940-1-xueyuan.chen21@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260619025553.226940-1-xueyuan.chen21@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F379D40005
X-Stat-Signature: p7ifj3j1151dz1f1xgewfzsfjfewygij
X-HE-Tag: 1781867358-562787
X-HE-Meta: U2FsdGVkX19q8qUkYXrGllGsG+vPnfpEfvmv87y12Av4Qx0mM+kg+G9eaYG692iLH+8NDEBSckfBPCOPRMK6YAeOMAl16mXv5rBfHJPV3kbPLTwdNab4YbseAoUk539fCWNxLGbLqZmCevmCy/uCNl0N3q7bNfy12KQXWjwZ4SUPKqkeZy4Yca8d3fmT99Dbn6mtgqOnHYTt2p4d5ymBmuysoyKhg1PYKPRqPr8B9nf+qANqdz2C+ivcXjPOXSo0lKT1KmAfM+ARvHdbz4apddlVpsnsZjrqjrgeEmGIydj9a302hC+B2mAISejWrihklXWYMOvKBDmrUyuQKZ1Nq4iaqCuBWAr6EzYOuIbLksIyo1I62UMnmDFbqSsJvaCQcnpKTVuIPaomfZdWkHHP5+fLCF4Y94m1dh++agLNz9j9iov2jdBS0oS18whKjBZ5f12htGCaVdnAHyKBnEqpnvWpzkWSxj5KmFUri5GH1GjWyUto6nQ5+VYlEyYiBsQlMLElXMBOP/p8jhpl/egvEuDm6iIamiDn8X3VJ7c4xxSChPuS+bAM+yxeUW2srd3CNLBUVzGMYyDT//9uQsT+2u11qinTm+QpKPh8u+Vh0UKxw5WjyM12N4iRxRDp6Scn2+OdM398sS06J0cdLBbriKxXd1f7SWR0/Z4XJSinCduHbkobC3okkO2reu0huwduwuAuY73UQ9s1MpEFWFO+MHIvunxg2W4uj7cXATFWYneii3JsFDPm8OUue7dHtnxL6q9fHn7SH/0pk4kkfQDPLucTVP8JmxY57of5QeHi3+Ze54QifMTb4803IYRAYcklvWTyw7N4kbOwa+pN1ScPxkA2NrkdpC0dmtm8MxQL1/iDpDiGxSgs9+4eznvyVlKqTk0oA9m+cqy2bjuP9hPoeQSEpFKR7n5yr+Yq6Mq1hkBkCAZ5eqdOIsyPBAmYSD5mxcx3oBmwi1fXO78ScMw
 A7fzLLWg
 w3BqZgTLT6JO1RkVkMtNjEi8zJdYloeI5UxAzDiKc2HoYj6IxMHqXMhTYhOp8E/Z7Xdh/XCf2u+ZW/Whjv90uVYR7WPzuJ8leXPCptp/264DBybA7+fmr6/o/ovx83iTwoc3tf1ENPKkRRm+eEu7Hs1NVqPHbYQsEvgMVNC1pJrmnLKWj8ngRUp85x3mtvC3BEbkBvJ9VAUq530EDx9R4oQ+kt7H6yVRXzx6xi2A2/OgzielELieklQlzJGd/tdWWQiIfE64esQAell2qvYYnlW+7JLnGHDRZa97Ygkj7bCVOuhf65LVt+0RHyxMHSf1SFZ2qAnKJulbhIvCs4E5OVBPptoSEVUwyfea3Z8fCg9CjF9HC4A2cBAe2GKdjxYxSwUfZvEHJTQFk2ZZ8ziDfJjKYq9+XmLIs1VuZisfloXGe8lM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/26 04:55, Xueyuan Chen wrote:
> On Thu, Jun 18, 2026 at 02:36:25PM +0200, David Hildenbrand (Arm) wrote:
> 
> Hi, David
> 
> [...]
> 
>> Best to wait for some feedback.
> 
> Sure.
> 
>> I do wonder whether we want to pass an address instead of a page.
>>
>> https://lore.kernel.org/r/20260410151746.61150-2-kalyazin@amazon.com
>>
>> Wants to convert existing ones as well.
>>
>> That would imply that the caller must check for highmem.
>>
>> But then, we could just use existing set_memory_ro(), right?
>>
> 
> Agreed. Passing an address and reusing the existing set_memory_ro() 
> definitely makes things simpler.
> 
> However, there is an arm64 specific limitation:
> currently, the set_memory_r* api on arm64 only support the vmap
> region and do not handle linear map addresses.
> 
> If we go this route, should I extend the arm64 set_memory_r*
> implementation in the next version? The plan would be to make it check 
> for the bblm2 feature and modify the linear map PTEs accordingly.
> What do you think?

Good point! It's not really clear on which ranges set_memory*() is supposed to
work ...

arm64 only works on vmalloc/vmap, x86 and riscv on ordinary directmap ... what a
mess.

Having a new direct-map specific function with clear semantics might indeed
avoid even messing with that.

So, yeah, given that we have

	set_direct_map_invalid_noflush
	set_direct_map_default_noflush
	set_direct_map_valid_noflush

Let's add a

	set_direct_map_ro()

Or (my preference)

	change_direct_map_ro()

But given the existing naming scheme ... maybe just set_direct_map_ro() and
we'll clean this up another day.


Now, should there also be a "_noflush" in there, or who is supposed to flush the
TLB (or don't we flush at all, because it's used early during boot so far)?

In any case, for this function we should add excessive documentation and define
clear semantics.

-- 
Cheers,

David

