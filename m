Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFF53606A320
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 08:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n9uz2qBx
Received: by kanga.kvack.org (Postfix)
	id E6F1B6B05B1; Wed, 28 Oct 2026 04:59:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1EB26B05B3; Wed, 28 Oct 2026 04:59:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE5C56B05B4; Wed, 28 Oct 2026 04:59:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A16926B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:59:13 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EF49AA0C58
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:59:12 +0000 (UTC)
X-FDA: 85371435744.16.F7EC198
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2618680003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:59:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n9uz2qBx;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793177951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i9qOtY7a0khzZp+2JUyiQcNdwBewsSehqHZrdYTNXPA=;
	b=1mnaBtBQDzibHfnfiuv5viKSv3IuIzDrB8y5Q2lM9aPBwZx5Kq98iuqX4MaFRSvhmhChv9
	LOMNWwarM52g4goHlx0CfUZb1mD4pQQI7x7w9V8q7Nwqfwbj+Yt70mdlYsx6YKHhBWaC+P
	jebQ3HUh+0xbMuGBKoRK+GTLwhYBKus=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n9uz2qBx;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793177951;
	b=AdorhchrQsu/ITQePCWb1b9L7yX0/TPWEFm+sU4UDWyY3PeNIXZ0Wn7uSUNZVlO/D+ldRo
	K5xnKUCZ65RQAonTNAGx45XaeAPvVciQpO8zJ/fpMU9p0vhesbR+nAJACMIuKwGWFOR6kN
	x5gn/5LRSEvV/1zFlrr8j7Oq9IpeBMo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E01443AD0;
	Wed, 28 Oct 2026 08:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95DD01F01825;
	Wed, 28 Oct 2026 08:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793177950;
	bh=i9qOtY7a0khzZp+2JUyiQcNdwBewsSehqHZrdYTNXPA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=n9uz2qBxwkdOt+BBYDqcRYBsL0H4V2Ug9Ow5tu7fLk3/xzx2mxzf+HMTVGUiIJnbu
	 UHfvtxmIjhY+xQ766vsmgwePsLiGx8kAmPZPlD4WCnC+4rJaxzKpjDf8l/PxSRuS7U
	 ixLAvMeOxeiUvefXEFI/jfC9xp7ljf7OTppVYZjzY1dNcHcmh1NZWDF2vGHdc49hWv
	 uTT0NSrtYNOYOcDppWH6dHgfZpTd171QUNIp7WpPs8lDGkcfpOKXPATlxU3qiH1ANx
	 V+qfMdLsle8HqlqWD8gAGSfEwjudq/PMbS1R0zs9PPUAGsrYy40er4yK4lQU4aDgLA
	 HllBmwshL59LQ==
Message-ID: <2976bc2d-2642-4448-9c1f-ec13e67e45d5@kernel.org>
Date: Wed, 28 Oct 2026 09:58:59 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/13] virtio_balloon: add higher-order page inflation
To: Kevin Loughlin <kevinloughlin@google.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowangio@gmail.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Ard Biesheuvel <ardb@kernel.org>,
 Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>,
 Ashish Kalra <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Alexander Duyck <alexanderduyck@fb.com>
Cc: virtualization@lists.linux.dev, linux-coco@lists.linux.dev,
 linux-efi@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Sidharth Telang <sidtelang@google.com>, Punit Salian <psalian@google.com>,
 Peter Gonda <pgonda@google.com>, Ackerley Tng <ackerleytng@google.com>,
 Jacky Li <jackyli@google.com>, Steve Rutherford <srutherford@google.com>,
 David Skidmore <davidskidmore@google.com>
References: <20261027025616.1632690-1-kevinloughlin@google.com>
 <20261027025616.1632690-11-kevinloughlin@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261027025616.1632690-11-kevinloughlin@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2618680003
X-Stat-Signature: 3bu5dr5qgdskqog5kaycgpo4arrkn93y
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793177950-428094
X-HE-Meta: U2FsdGVkX18t4JyPoY++oa1JErkoGL5HIXpXkOP6lN2GVZ1lq9ueROTh8TD3NFOTwumRDrodEyJ83LA63CjcWvrUFl2i6cqgGrp/NVYIZOyDHBsUSvQK0S4BGjBEXvUALhLvRvp1uBjzJ/UshVQxBrwdkFmhLrSp/wdVozGQvO7/w7kpmjvbRCpES2bN4RKLsNg3TsV82voT3DpPpaNb4m3ebz/hvHqFGSIDxnXbwssj0VcVTWmq/qRsdyIVUIXkNZ3xrMYuz6R3OFgZTvR5p0xz2qEeawBkcsR6JgBNjwkSN3c+4tW5pqFHKwtQvXW9Aaf10Jou3YnFpG/rOXag2urZ5Oi8mV3IKznwxM/nq/qEIve+XG2JNttFQRgOJz0b27SDcGROeeTkw0PlsfQUh8Jb9CPS5jwJuMx12Fm2mktZjKnZz3/E0fTMEORWTxe3RNfo2VvrzSTVoCHXoz8xkZzwghvupKA57UjIyP6beN2oV7194dvdZivI03x391ALcqJSFP2fuGecmU9kDBAdV6aiUde8+ztaCQodwiIhiynyopSQ+HOq9cZe8NQHM6lwmMPGY+e8RFTtE79tYHV5rMhitPUCbghMchsnt29L9wbNnswn0THQ66r1zWwLy9kiU/tGa14DAHcSQuofddlMPSEsIxEC3Wmaw9DEDBH6niZSOM3J6A/pseWg0A2ha66DMU3jFXJtA2GDItDPa9aVAuWYZZ1zhi7sFZ+oxCCj/ttaGo/2Pmq2RN7Oxg1UVhtB24lhUR1qJu2buXVID6EKa+YL2EGn0oJDbR3DHEiKpuDdS9zIDZitjQSUCGmbmg3rYaGOfwaJrXfxztmc8IWJAMBiFxxNwY1Rs5p1geK33wpuSyuMUzXuSlC/jXgHvmqL+qov/fPDFvjOeHwsUDh5fAQfRmU/fZP0Dq83K4OeeUPKGApJWDWeGMtZ2KN8hEOMDztvMhHnuphN0KGA6hV
 qlZHwPZW
 5Q1DsAbisNMtCz3WIHANsA/cG6hiOSjX1lFgA2anE2NSt4Awm81p8nttqHwEBy03heG5Ls7CgQGlBxDMShPJJODFB6nUA66Uu6h+tq9utM0JppRbjCrnl0LFLW/1Nm6M8M8UxThXj6rj+4duZXKUT+lD+wUQTtW0xzrwa0qucT+KbzFbn1/PUDinhUs06kkp5yXDr1Uiv4onS5mLxscWt1oG/U0t6emfxQ0AUt6FSNW2XMOyGfSZXk5k187x9ySNpux4UVX9MGyghqxYOVlMvQX+phHFpF8rGjgbK+61OjfiM6G7xQMlHYN2W+3Dd8kt0f7S0kZT6pR0SlF8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 03:56, Kevin Loughlin wrote:
> In confidential computing guests requiring page state transitions,
> unaccepted memory tracking operates at the EFI unaccepted memory unit
> granularity (typically 2MB / order 9 on x86). Inflating the balloon
> with 4KB pages would prevent unaccepting the backing 2MB unit.
> 
> Inflate balloon pages at unaccepted_memory_order() when
> virtballoon_cc_needs_state_transition() is true, while retaining
> order-0 allocations for non-CoCo guests and CoCo guests that do not
> use unaccepted memory transitions. When a higher-order balloon page
> spans more 4KB balloon PFNs than VIRTIO_BALLOON_ARRAY_PFNS_MAX (256),
> transmit its PFNs to the host in VIRTIO_BALLOON_ARRAY_PFNS_MAX chunks.
> 
> Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>

Sorry, not happening. There is no migration support for these (large) things,
and there likely won't be any time soon.

NAK

-- 
Cheers,

David

