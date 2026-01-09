Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D78B4D26D6A
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 15:31:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 474316B0088; Fri,  9 Jan 2026 10:31:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 421A86B0089; Fri,  9 Jan 2026 10:31:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 357FD6B008A; Fri,  9 Jan 2026 10:31:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 257136B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 10:31:14 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CAB4F1A01E4
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 15:31:13 +0000 (UTC)
X-FDA: 84312814026.10.A70BC7A
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf11.hostedemail.com (Postfix) with ESMTP id B11374001C
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 15:31:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xOPnIlh5;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767972672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4FEO03nU3lunGBMTB9f9/hv+IjcT/lwasWMosM27ke0=;
	b=F8afoOxLOu6owraaYQXF+wKuBx/qVxkGqcSzokGTbEyWPrLAIfhxqCn9njOd/vFqu/KESG
	KXokCdv+SmdqU0JqRzpADF2XdsRVH5da5w8tJeBApmqvOJuX1xMHrzTPi/8cbvuYo6gP7s
	BpiGlxrHEKu4iNoD+TOLEJzY9JoBYBs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xOPnIlh5;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767972672; a=rsa-sha256;
	cv=none;
	b=PbWjDHW+tXvVoWFFZmKF3cMSm/UsJAIv2+bLqxPBhNoeCHZyb6zmPw7KeHoeVDrSTk8ATW
	7jOtUt/33H01lGU1s98xECB0OGs/KbSRyhJFSaTaWmQRC2JYm2JUuzpdE6bsHCMIiapmKa
	Q3cbAfOZ8NdENMDTFOfj5qpzDo7IX/o=
Message-ID: <f45a1760-7fa6-4e2c-ba5a-90e250a5792a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767972669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4FEO03nU3lunGBMTB9f9/hv+IjcT/lwasWMosM27ke0=;
	b=xOPnIlh5FqZsn91jKIxYC3Z9+oplXNrgqQGMxNCC3FOU27HuGA1Z2ZkeHqpwes8Ix0X83b
	1Cc8jM7UiW2qVphjJvQ/sLfoFRJuCx8uRcnzejAuOkdZkfP00BzrlsMX/fY4ropVVhslz+
	E7HqBxXQUW6higVM/BLRB9wyeIn1DY0=
Date: Fri, 9 Jan 2026 23:30:51 +0800
MIME-Version: 1.0
Subject: Re: [PATCH RESEND v3 1/2] mm/tlb: skip redundant IPI when TLB flush
 already synchronized
Content-Language: en-US
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, dave.hansen@intel.com
Cc: dave.hansen@linux.intel.com, will@kernel.org, aneesh.kumar@kernel.org,
 npiggin@gmail.com, peterz@infradead.org, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
 arnd@arndb.de, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, shy828301@gmail.com, riel@surriel.com, jannh@google.com,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com
References: <20260106120303.38124-1-lance.yang@linux.dev>
 <20260106120303.38124-2-lance.yang@linux.dev>
 <da1e8a00-99fe-46d9-b425-c307ea933036@kernel.org>
 <7472056a-3919-429a-845d-c2076496d537@linux.dev>
 <4d94363b-5b3b-4401-a9d8-da136d71f8c3@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <4d94363b-5b3b-4401-a9d8-da136d71f8c3@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 1genu4aatubkqp7jjzeosygrwrpssz3z
X-Rspam-User: 
X-Rspamd-Queue-Id: B11374001C
X-Rspamd-Server: rspam08
X-HE-Tag: 1767972671-310256
X-HE-Meta: U2FsdGVkX1/8LziEWfs0vychdnJKdLhb6nJAtLchldEgotZkcmluWlsRdSm9ydIDdTgzxZ9lKY1N2kSKGqYsNg15VN9B/hSPlfL7d33IH/hACXxPuQQmhUNKMwtwTPObvcyJTYGabLJ1vHSPn616/zEiSNnsoDZk5OSkp/De7VkbQUodV8LwHC6fjKwcRlEqW1Co79R2LfheRw8ydh5ApJ0mxc/Hk+6NAzTRSKRaG1rpXt3EydtB6n8661rBBbeUasUE5OIUQ0MsRVrmLz5K2cmweDf/AaSTj5YnhgA1xc9ErTY9RZ1Te+R6QGXA2yHX26A2ttnmnQ40aBkVysgsVkWJVEHCQ8OTBrmYD+KNfeOxwM8A2PVJfok7NOof/FaGNwsGY86e7tLPefZIJckB+EqsLtXQJB6IfqZLptvfRa1F2mDyeAiOQZ/uWIITKdzpjEZ6mV0KoTd//0PwWiTqvJPLq7qCG6HXSvhpB8+29vuSAMNR5gcNhgsiKtLYkWcdHrHHd4UdCl8WcGRavyjJruDjxlvNVYh1NJRiZy4YFWIKrVwxmcYUJWT7RqfVXfa6bgn2tYlv23+TgMH3MEeC8YhvA4OdImIsos7oiJ7HdRYc/r2b+uVaiEVJB2FSYziAo+kjJhNsF9V90igr4BXhTSxAeTYsOSuFGmlz4X7Ynxe5+eRZ4L/ULDnRz2NZCkNxtFBIPkgkalq1OCYBtwGpqQaM4Jog8wzaK0dLfwzcow4pvaXqAwPXTqNcWQ0l0fTcPRPuIsf8mjkMj5ZprrWGT3OWjd0rZrLjkafbk2yM/rXChygLIN/kp/Ti+GJP41rVeuLWPc7cad5BJaQqCZ8TWDfCHl51QyNWLyj8PU/deBdT6B6Qu4YCVRohtB3u3iaQxyMEdqEXDanmssdCb/vVYAa/BiYYT7QBPQsz9y+Ih2hmXWvEfxU0kWjs4SgBZm+NJtaC/4Op8FWq7Tkpn1s
 E4O0d21R
 CqVmUh6s5mHXmJoxzHJ+n9w151qW5F11YE1HFe87K9UNhnEhxma+JQ/CSWjBbgsw79OWYxSEIN5m71Sy0TfGaHF0fY8nbc+RBtQiIycVOV1yCTAhZItCRUlPkpVQ5BxwZ3wkc9eoKhpFY+LRf3LMZL3t3sLd/C5lhZNZodPs3SkXXStq5clljgAKpql4i3N9EHeyL6sdNYWS7r3K+qlgi/4HzlA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/9 22:13, David Hildenbrand (Red Hat) wrote:
> 
>>> What could work is tracking "tlb_table_flush_sent_ipi" really when we
>>> are flushing the TLB for removed/unshared tables, and maybe resetting
>>> it ... I don't know when from the top of my head.
>>
>> Not sure what's the best way forward here :(
>>
>>>
>>> v2 was simpler IMHO.
>>
>> The main concern Dave raised was that with PV hypercalls or when
>> INVLPGB is available, we can't tell from a static check whether IPIs
>> were actually sent.
> 
> Why can't we set the boolean at runtime when initializing the pv_ops 
> structure, when we are sure that it is allowed?

Yes, thanks, that sounds like a reasonable trade-off :)

As you mentioned:

"this lifetime stuff in core-mm ends up getting more complicated than
v2 without a clear benefit".

I totally agree that v3 is too complicated :(

But Dave's concern about v2 was that we can't accurately tell whether
IPIs were actually sent in PV environments or with INVLPGB, which
misses optimization opportunities. The INVLPGB+no_global_asid case
also sends IPIs during TLB flush.

Anyway, yeah, I'd rather start with a simple approach, even if it's
not perfect. We can always improve it later ;)

Any ideas on how to move forward?

