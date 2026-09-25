Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31FFEC98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 11:02:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 409B16B0099; Fri, 25 Sep 2026 07:02:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BAAC6B009B; Fri, 25 Sep 2026 07:02:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A9FB6B009D; Fri, 25 Sep 2026 07:02:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0748C6B0099
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:02:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6C283805A8
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 11:02:05 +0000 (UTC)
X-FDA: 85251995010.01.1381CBC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9D3BF1C0011
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 11:02:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cs8M+KUt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790334123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i2MF8G53+2TJNwdh6H/2D4TjPKTBJGXEPFShL5//B+M=;
	b=6jaj9tTo6WKCdkdbovpMwnOx/FzeVXz+LfTdf1UuuNr/yZ6Q3+pzhV3FDLwHREtS2ZrlQI
	vQkJZ6or6+EMx89M5MoAcoMnwquKrGn5H3nSVOJErUXfJN86m6dJ/l4ImpFdfWderg5lRF
	FQRsYCtwBh1OHI8w0w52xiV57M4KRWM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cs8M+KUt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790334123;
	b=7pPyWyUHa7a04z1aoRRWky0729PpRyh49YZNziHtl5AumKd72+4bywdaBCRkZhgoJXKDoO
	nXNb32y95K1ftoOL8c7ErM076f/acircbUvz9xZnTTpf4z9qPqlgn6Xfyp3vv6LILsqsxq
	PYD9GMOpFgcQ9LEvHiOY2950iPR7t9w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9585E418A4;
	Fri, 25 Sep 2026 11:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE011F000FF;
	Fri, 25 Sep 2026 11:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790334122;
	bh=i2MF8G53+2TJNwdh6H/2D4TjPKTBJGXEPFShL5//B+M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Cs8M+KUt16tK/XUS4KBWNEBFZCG7qdya4X5Q0/m1DlAhuFxLfunQdq/oOm/3xLhmk
	 g+mz7RXSaCtI6rsDcJwgvAYI3OjRMNkZK0LcUbazzucK5JBDOKf5kvtv/2ePJtWUdN
	 ME7b6geBHQ5EcQiztnroB9GCESGBTwfj3BOFpkrCOl2QXW03KCgvW+wRt9Z6cGJwg/
	 16Pn9i25K6bLCw+K0mlmbRqTKkBOUUALnFf6h+RtaMbve0sYiz7bKXvmaAm6kK77s4
	 FXoRQNJDmxpHAXV4WVeHP31V50DVpThWrSf4TxjtqXa883PecK/QuYllTic1IK01px
	 H5q+PVXIZC3Rw==
Message-ID: <91d800d6-03f3-4068-8c12-618529a81528@kernel.org>
Date: Fri, 25 Sep 2026 13:01:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arch, mm: promote DEBUG_WX to CHECK_WX
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 Alexander Gordeev <agordeev@linux.ibm.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Mark Rutland <mark.rutland@arm.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Ritesh Harjani <ritesh.list@gmail.com>,
 Russell King <linux@armlinux.org.uk>, Shrikanth Hegde
 <sshegde@linux.ibm.com>, Suren Baghdasaryan <surenb@google.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>,
 Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org
References: <20260925-direct-map-verify-wx-v1-1-7fd2f7d6d23b@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260925-direct-map-verify-wx-v1-1-7fd2f7d6d23b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9D3BF1C0011
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: hde4dcd6638q1t5n8ngj8zdgnbsdxbem
X-HE-Tag: 1790334123-347490
X-HE-Meta: U2FsdGVkX194i/Y6LW25VVa9bdmYTYe26LJNhGNp/Vj72Jpfw2HnlZPVqLDGBccpvNPzMjTPiVclQMb1VzjBLNU3albaIfx4/0gloJmsd5NCMZvVoeVsbPY6CcwRTdkiELlGwmfJc9VVk4fDyEVovzbVQNkqXLMRHF5Z2fAQXpwkM8WnqHnjkQJupoKVxlyz6prkW368W5I85KMgTE5g9YLhLYHHGHyZoIKTdV7EU9J8BYtFafYDHVYBVuGSlLGsrwVTeA8S/D4l8xWucA3TJDxNBAQWr9Zf7TyzbQS9VLH9U9dNtc4ZSp5HEyOM+A0Bst0dazno5r8mGZyorM8Tfv8yCUyz0PF4QGEC0h3Oe1GTq1kSyQi0FJKUBUAV4ltLCRnabPxMsGmKgNx4t2Ooncumao7zUvo3aTungKtNWGuboXEPwzSmaOqIGXeSw62jAV526X7gyh8U2flIO47lCXCfa1uxAkiBVHLvF88k5oLl1dR4z9DtJ7+UELXB7QsUPGzz0f5vKcqwn3s/8nAdvTSrs8f4CnnNsMfIqfkaW6tVk1tGrW5GgkeUA1gfbSak0dQwTvBrCMgKzJYUXO3Mv5zLhY1ZgiCRPjQgNyEU58HZ+NR4G01WnSD/nR1ZMTuR/ySLryVyVBBR0sN6Nx0QYsNbovNBgFNHheKwXafb8T9z57NLEx+YFjBs/whnyfU1KhsepVA/cWwPtb8Ffo1Dn2USC8bTiq7FUlt5jVqdJp2DF48Kf3OSuudnWzoWF5KYdhV+SiGAwlhlSEU7GNG0mZXS/f2aFlB1KmeLSt8Va02+CCuUNfRGUQJIooxo7gKmHMFGI03gVSGeHiuIMBhTax56xAd9qCM+HtDBjs8HlC7ynD4ZNCdj6+GYAgeRDsPELMYu4eVyJb6qEpT0aW0didhJOPsJDaVhfYmjmSZEB9qpIxaxiRo2mZJo9KDXjOwzS/AO+VAs8lqNqGNmWBI
 NqHFRLhi
 jMVvUMdgab61ZvBQNwrkNBR5skFl1n82RhNiNhEvPOZbM2cbSjYewHIGo6giyZiSvwY0LgatnEsJ5uV9WOzBOr0kjsm8Y0HvADn1brQzfKCuz/1UQGaqO+8oBWvaOe1b1P2tfMMBUHdvi6VG7qSJCJ4QxKMVj3A/pL6IbKsEMNICqbl2PkYae7Y4pRplt8/modm1ALCLstVlLTo08juzAGdzX8g+6ToSQt9zGoD5pDXggHKxrrf/hC989Tp+vhI4BvUinwF2bUR+pGapaGEp0GaZCIqDqfPZQscfmT7e6eTX7B6+ZKIrmQDX5v9ZriOKGLJt5tslSgev/c5QXCpCMpCSyDxjmxOOeuFXk2zjbT58HAK5O6bOlc1wNJSD3LZLbcvo67UpVyTvavWOJ4l8A22AaWSKXWYswTsWfErZZVRP/5CM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/25/26 11:53, Mike Rapoport (Microsoft) wrote:
> Verification that the kernel does not have writable + executable
> mappings is about detecting security risks rather than a pure debug
> feature.
> 
> Major distribution configurations enable it in their kernels as well as
> defconfigs of most architectures that have ARCH_HAS_DEBUG_WX.
> 
> Rename relevant generic configuration options to use CHECK_WX and move
> their definitions from mm/Kconfig.debug to mm/Kconfig.
> 
> For arm that does not widely enable it, only rename its variants of the
> config options.
> 
> Enabling CHECK_WX adds a few kilobytes to the kernel binary and while
> the added size can be slightly reduced with churny updates of
> architecture implementations of ptdump, the core functionality takes
> most of the added size. It cannot be moved to .init.text because the
> verification has to happen after init sections are freed.
> 
> With this, make generic CHECK_WX default to STRICT_KERNEL_RWX while
> still leaving users targeting small kernels the possibility to opt-out.
> 
> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

Makes sense to me

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

