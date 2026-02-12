Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCB4EEB48EC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 09:01:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 500436B0089; Thu, 12 Feb 2026 04:01:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D83E6B008A; Thu, 12 Feb 2026 04:01:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BA696B008C; Thu, 12 Feb 2026 04:01:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2CA116B0089
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 04:01:50 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 09DD11A03E5
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:01:50 +0000 (UTC)
X-FDA: 84435211980.13.18BA7E1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3BEA380002
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:01:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EzC7pZZ3;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770886908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ztokAIoCYpkBlx7T8Bsk0Xjj5MaU1sWiBBOC3dSH5QU=;
	b=d+dTOUdZO+zDLxdHHGUm8f6LrRpXUpnPCBZtahKkrmieqqdMxVwEG3jFS9vOFLPDKsipAi
	Adr21CulmyGc6+1YdDRNPEUNdWnsD9ry0TQEyOaqxwW/pIbNOco6XEMB59w/TXeU/hxrlg
	2NbxMGBdoeLQNulzMTmHnxA4v7f0gzo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770886908; a=rsa-sha256;
	cv=none;
	b=tdFsLKSTbz816Zstr2mmv69hqx4lpiRYg9tvYLeg91NfmfmUNKb2pEHlv2Cv89mcE07j7M
	tlvtobIG+4ezJSe8EigB1KsfVegXjYofU61edivBq9ZQSsRe/54t5a5G8BvtHR9u7f4zTj
	8IW7xM3Ja2vqDBE5ST9rYMQxOgVFmvA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EzC7pZZ3;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A70941980;
	Thu, 12 Feb 2026 09:01:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B128C4CEF7;
	Thu, 12 Feb 2026 09:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770886907;
	bh=mbeyKAvym1Evnd03SXCqu1tAKf52BxUCYkSrs6de9OY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EzC7pZZ31+AvqkeNbZ+v1uBdrrQu/Ug8+evZxdKrZiDdRxVQ9FJ6YzrNMAOjK6l1l
	 lmA2Vqe7Yd2Y1fOK/Gf/bHij4F99vPL/NoVeb/p4w5i3b0ZJOx0+iUhnJYpQoDl79S
	 vvU8wl5F2oYQ0e22bB7hT79dtpzdPxIQO89tikEAnB0VTGRwU2yhWdh4sD6hFlZMj8
	 HpUICv7+9ultjVQRagyYsoL6VB2fxPVVT5hFfxy0PlrOl41v9xEYNuIAuSVc1vAmlJ
	 JDfwSZ+HNeo4rjkOTyrcFsmfy2SUffMK2Adtr7i2FrD0mIutj8T5KgIQM6xp8QRIZa
	 Mu5waAMtsSfSw==
Message-ID: <74103a51-cada-4645-91d3-e0807b32c2a7@kernel.org>
Date: Thu, 12 Feb 2026 10:01:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/4] mm: rename my_zero_pfn() to zero_pfn()
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Larsson <andreas@gaisler.com>, Borislav Petkov <bp@alien8.de>,
 Brian Cain <bcain@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "David S. Miller" <davem@davemloft.net>,
 Dave Hansen <dave.hansen@linux.intel.com>, Dinh Nguyen
 <dinguyen@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>,
 Guo Ren <guoren@kernel.org>, Helge Deller <deller@gmx.de>,
 Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Magnus Lindholm <linmag7@gmail.com>, Matt Turner <mattst88@gmail.com>,
 Max Filippov <jcmvbkbc@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>,
 Palmer Dabbelt <palmer@dabbelt.com>, Richard Weinberger <richard@nod.at>,
 Russell King <linux@armlinux.org.uk>, Stafford Horne <shorne@gmail.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Vineet Gupta <vgupta@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, linux-alpha@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-snps-arc@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
 linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev,
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-sh@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org
References: <20260211103141.3215197-1-rppt@kernel.org>
 <20260211103141.3215197-3-rppt@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260211103141.3215197-3-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3BEA380002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 3btktzyb1445cuk49s33w8zpf41uixon
X-HE-Tag: 1770886908-674449
X-HE-Meta: U2FsdGVkX1/k72Gw27VXPDBgJ84/R0t1xTCOtpSUALe9KmFV1GD6EdSH8b8CQw0P10m3tlWYm4VvZSl9YAX58F8xIMFJ2GL72tGEO68l1gK0nkSaXwB81RZ4Aea5QtlSExpq9Uof33cLNk8ZNnMehfpHKkQ/lDeiSkHidtBmrdIH/VfQRHpRbUC4twRsrrNaXd0QDrS2UA/Fwfmz8BNSqdULypp1JbR8TyeS2mCFA/JweXXqXzaCxHHQGrXNxjLQZI7uHiSP44UERaIdkuqnNPsHB/IsWEOgnqxV4OcP70IDKd8CBcGgVbgIE3Y3xVryzKzCOTmxBYGqzQVa8tM/t9X28jw9fDXnG55ApHIJIyhhQucxTCjv41u+CCnBQXCmnNDAbrJDwJz85DO82qZp3PTia0LMoS2q22B9imXu682k1TGNkpf7LFgKXfIU40+49ZJxU1us/jGbRAWoFhtYYv/6gmzcJmN5jYTuzQmv3CCah+IwmuG4wfEwPq4gQ8HP74WWmQkT3ba5MiRamxH5aJLu1IsHv4pKChiq0ybwG9vEgrnR/qXvDAz7zF7ZTpU+nBLx2E2RcMz89K/jxlu136Hl5KtknnwvCB7c01N6GAi1jHtWBm7/oYD5YHd7fxKHdJg65siaSAgQb6OTzoZNnus9N3TOepeFTM0tyXqyRA33aaihKbgTxxUkwDjfkBKyhbFsGNTKrlKkjNvdsIU80YwNIvhIj/KTr2RS8qdhHRRsAIxvgjgXPyth3e0Qc9ldgCIViQ0YboiWlp5imUU5vmdR86tCg4EkQQNzTJsZUXJLqN6oBvVdfXOoV8wOdDnsByU6Fxprfs44Y1Bowt6KZYBCDeLH0aNqiuAm2iy5+sUZr8bTWi+454YBB8HQvy1yKxFdp3wTKCGt5QjY7n4FOOUISkmrofeUs/uQ3h15+BHfGvG9kgGDRyWHmf0UaSpAPJHqZeBI491TR2bFLtU
 vU1pW1OF
 +nWBect0nSKODrGALIN8dXm+SbKpnTjTYHoLCYGYMrwUY9ENM7XScOyFd87Cyzrdiv6EXHULtuAdjnwwKSu++LWg+JNiTEo+gi0RN4snagJWb1mFhZa0yNWrlnKwSEBG+OUa+SkLZR4y2odvcKdmLp0ODF88JoNRHRZJUf+w3Q6FxKZvEAaTJT49uiK10XnSUkRwzTsthTNBovDzSyMxEnwIlrJ6mRj3XcGrXzeSroffDuwqGjJcdAf31CGz0Ri3CtX7ix8xRdOgd1bIFTQMkIP4aVoANvji/sl5/e4Ii0uM5BWHwfUH0CBO1+TctVOq5506EXuJJSL1PFgw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/11/26 11:31, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> my_zero_pfn() is a silly name.
> 
> Rename zero_pfn variable to zero_page_pfn and my_zero_pfn() function to
> zero_pfn().
> 
> While on it, move extern declarations of zero_page_pfn outside the
> functions that use it and add a comment about what ZERO_PAGE is.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

