Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29047606A332
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 21:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h70sXyoh
Received: by kanga.kvack.org (Postfix)
	id 4352A6B00EF; Tue, 17 Nov 2026 16:32:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40DAA6B05B0; Tue, 17 Nov 2026 16:32:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 324156B05B1; Tue, 17 Nov 2026 16:32:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0FEFF6B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:32:43 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1D4C3C05C9
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:32:42 +0000 (UTC)
X-FDA: 85445910564.27.DAD80FA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 527A3180007
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:32:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h70sXyoh;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794951160;
	b=wne8d60UevEjqjP3gax+1nHXtv0DNqgH2stzSL8FxVDCbXyCyDSqrYRZ2j7byu5e30ThUo
	0AiTue4y5MOB0UegWWdthcReMk901jZYChxmJLDJrp+8GIGNLSLm22iXIdrHNwWuqSYteH
	/MtSxql+/HNBrFKGQcKdkCZANUw1HLg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h70sXyoh;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794951160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2NYtBZm0XInhRoJxa7FTY/jwtTSFkeJiyIlnwfaMdUw=;
	b=hXut12Dq+zno7xwCEzgD0EOlgYhhagzETRGSj00prnSlBqrAGS/tvPb5B2Z00G2yEKpYK7
	sJWXlLs25LlFvnYk9XA4grfoaR0zCXyDxLPoXVavREdmbx8ArGuBEWgPQDIHndAwtVkXUd
	7lPmsZp1RufU5cA3SL3L9+pCehaV7ao=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5824145C9B;
	Tue, 17 Nov 2026 21:32:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2DB01F000C5;
	Tue, 17 Nov 2026 21:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794951159;
	bh=2NYtBZm0XInhRoJxa7FTY/jwtTSFkeJiyIlnwfaMdUw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=h70sXyohBz9tlH4O2TwkxZDbGTPC86Wavmpegj94NPPusEGEuSfyRpi8XPL8G3eD5
	 nWqY0AXNEQus3YgGIY/G1poWUowRmDxDPrUKbTXau15xSGYw6FShm4N/TwlEVp/oJp
	 ugDHGjo+cRVfxklSfo12JXJtyxOZWZZWqqcSBsxtRZCov8l4JWXAjsfhS4YB0Vu/sa
	 bEmFvA+XSOsIH26sobkgCI1PH4Tw2uTROhRRI47TMHRmpAZAfUD62HEMCHHpyN/rO9
	 W4PAMjdn/gnvvk5lYIe8lxiRjAEBD1nmGzs9+EEBO3tqT54zj11XVLCSBBkaOMoZgT
	 L4l/4FP9cdyxQ==
Message-ID: <d38d9e09-08f1-4491-b202-f0ea0f799f64@kernel.org>
Date: Tue, 17 Nov 2026 22:32:31 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm: define generic pudp_invalidate()
 implementation
To: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org,
 ljs@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 mark.rutland@arm.com, ryan.roberts@arm.com, peterx@redhat.com,
 dave.jiang@intel.com, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org
Cc: wangkefeng.wang@huawei.com, sunnanyong@huawei.com
References: <20261117020237.4037980-1-tujinjiang@huawei.com>
 <20261117020237.4037980-2-tujinjiang@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261117020237.4037980-2-tujinjiang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 527A3180007
X-Stat-Signature: c1eyfup8io4jqyk9fdyzop5tomfbrgce
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794951160-360782
X-HE-Meta: U2FsdGVkX19Q84+ZUPRjLdENwG76qxGaO6m+HWiGTJ87nd1wmbdDEM7Pohs9uPIZI9tfTeZvJ1GwvR39xyzo1+/5HBDtv3pzNclJhD63HV3gxjI3q23AHSdwkw9CgrrhT2hfTaRsfa8u6/v+eGSzBhiyJ8Ut93AAnR9twzqWz+HbV99/WwGpJRT9hJfHWnt038yjRPEfiYzvcD5qGT7oyGHT38V44nRsFJmaZzqzHpIM2RPSh4xtPzd4AGTJiZYQBhJFAeJCe8JKaW2u1luyicEhtwXgbwMVDh2LiEKwZq5ive7FDABR2dd8LQSRzuPiVQOyXEePqV9oEqhjZ728eX5StPmf3mSkerwblFSEsQkH9eeyHiNQfUx80I+evEfzrUewVmq+PzIFrMreRjZiimMy4aA0NhuwL9xw1q003bCJ35Ms9WjMBImPix+CfNM0OTfa5IPfiJ9oC/nU9SllpRzpk/F9FvuH5PF1UG+hGmhtxIN7P76+JzofoMkWCHivAY1PlgE+gczam/IsX3L9Ye9y+eOyXkZVH+6mdk/vJ8moBONYASs5jymLw0wy/3zMdbKfQBDcpi5E/ARD6AOBYPqKarubgTLFcaOBVtdvmfu5BgLstOk8U0uB6O0UDZb34WxcQIwSjp91B/j/vslJDpQbm+iJdHNbHo2NvRAy92z3s0RgLq6qIaz69e2tMD7UYUUTjd1IInaB0hhmtAoA+1vu7IQFHUdxWcezx1dGaVsZmr6qZed78RjalY0wt3HbxcfMJG9TgnB+WwpORJvd1NGx8Ek6Jlra8MaCHD/L0R1/gxX/OznIuncl74Ap4S+RATHcYwkbBB0IM19UQFinduyKdM7FKIiZSAJh5J1XufaJuFKwj0emUmOmjPds3E5ZrFvZRofMdOkkNFojdWtRlVW4XzAYEMfOOI0ux73EulYgw0M9PyrG0SQOZjp/Y9FHiKBIgqvj2bfo6VT/Gjs
 zjgAySOK
 kglSXNC/gClAdvd2+gWw4HXfaJHEXh2tzn6wixPAA8EZsBkERs+/bsVfsXojO0xeKTJgBjmGap3M1VQwULpOtZa1y5fWheOPcFZtXov2FUVJLaWXsMXk2OvRoYxjMX+pjvjd6bo3ZrFGfA/+FlxvwozhooxwLfqeGiwG9oWgH862uBo88j89pEp0Z+qQ2PVSPRnIUP5Zwh8qXa8zQUNQBjMEE6LxOKjPznBN9vdG5HlgeCLeJ0zT3YVyQ1o1FDHUgTfEZSeSPVUZhVRf5IoK8pnYvxFhaH8qD2ofHJG3CVBoihvEjJxZkoVRgyYBe1gO3J118HIUfkevNymGXXuwTQPA4ZT76MILp8zcZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/17/26 03:02, Jinjiang Tu wrote:
> x86 and riscv have identical pudp_invalidate() implementations. Move it to
> mm/pgtable-generic.c with the __HAVE_ARCH_PUDP_INVALIDATE override guard.
> PowerPC keeps its own implementation. In the later patch, arm64 will use
> the generic implementation too.
> 
> No functional change intended.
> 
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

