Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 007D7C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 18:15:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1D3D6B0098; Thu, 17 Sep 2026 14:15:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCDDC6B0099; Thu, 17 Sep 2026 14:15:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A962D6B009B; Thu, 17 Sep 2026 14:15:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 808C86B0098
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:15:43 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 27D11A5A87
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 18:15:43 +0000 (UTC)
X-FDA: 85224057366.21.A2EF99E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2EC75100007
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 18:15:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=roYFaSY2;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789668941;
	b=1VHh9IZrAAb4z50VqxOSMSACDyvCG3D5wnefnOdgz6FXKnyTnLTxXEN//4PuRRW7QNVPoM
	RULB4VL7aoWwe1dUqhK/X4aguX9dZjiQyzoPlLbXatwXpFkj7IzTUo3xFXQRgKrL9+836q
	HY6DFNrFbHviLBTetnIZydCwZGrdG3k=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=roYFaSY2;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789668941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H8Wh7N4cq/t88nKN8ZqZ4f+oRUbvezWnn3f++63qp34=;
	b=tHF9VU3yFmzGuMJZ4zydqp+YL8C65ozaj+VeOcOh8d5OWdQg04Z4ZvWeBHFzCTCi9viUHa
	BM8lvQU6BrpzxotM634TDba2T69aOfZAzNevxahgd+W77KSviwsbna23rOnr8YMTZ5kQTV
	1CqNd5gybSULjc76WVjQVtl4e37ZoM0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B37601F91;
	Thu, 17 Sep 2026 11:15:36 -0700 (PDT)
Received: from [10.57.7.135] (unknown [10.57.7.135])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7C76C3F86F;
	Thu, 17 Sep 2026 11:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789668940; bh=H8Wh7N4cq/t88nKN8ZqZ4f+oRUbvezWnn3f++63qp34=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=roYFaSY285gwN/8IzsFOtN0+e8Iltix2FpDfvQ3utTYL+K/fJKmz1KXzTmdsXwN+S
	 WAMAddn6lBMF4PqxGiGTEo0pOprPlbr/cZxNj8ql3o575Mymat7lIXSIibWHw+fpmU
	 bkqsEF4P/sS5BnYk4WQFSwVQavKpnE4kImkX3gsQ=
Message-ID: <258a124e-bdc5-4c25-b649-b4ed0a1415ac@arm.com>
Date: Thu, 17 Sep 2026 20:15:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/6] Revert "arch: introduce
 set_direct_map_valid_noflush()"
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: =?UTF-8?Q?Adrian_Barna=C5=9B?= <abarnas@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@kernel.org>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Len Brown <lenb@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 Pavel Machek <pavel@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Sven Schnelle <svens@linux.ibm.com>,
 Thomas Gleixner <tglx@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
 Vasily Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>,
 Will Deacon <will@kernel.org>, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 loongarch@lists.linux.dev
References: <20260903-execmem-set-vm-perms-v0-2-v3-0-949b64a9f755@kernel.org>
 <20260903-execmem-set-vm-perms-v0-2-v3-6-949b64a9f755@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260903-execmem-set-vm-perms-v0-2-v3-6-949b64a9f755@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2EC75100007
X-Stat-Signature: ixfrxc95jgdrzhcg1rwb9g3f9j6s8yxi
X-HE-Tag: 1789668941-253836
X-HE-Meta: U2FsdGVkX1/Nuu2FvFfanrnvqGwdAEYPI7JKdUMn/ULf16lR6O7GwjPQTdpYdi2CRO6l2LdbkaR5FE8sTzEYmYzlLbwepj60YXLJfgN1cVYA2jzGHb9cCGK1cgy+amvP0x8XXxSZNKDpXnjlj35dYrn/G2UEQ++r/8F6532cMhtLBd0om8m8vmQHUWalm44Lj5syHWhRTpoWRZjr3kIYh1kv9BgHToCdUO66vCLCJ+y1rmkxXrMzOc6jDfSwZeKLcaRdeYfXIuPfRfGTXnrA43FQOEnlntVEOJdZ9ZQffaSyWpGgcAJI+oDumGX5fOp3ihzO4FYmFJ2cr0LvO2/O8dbJkA2U/NgWE0oThm6ZbyT/Ubo3TEBTLhrJSGm0+ONls5Pl2aw1uLR/Qj3pk+bt9kBuso2DC0USFHZITn/6FbDLnUCOErfQuU2vKfuJQZdgRdS1tqLA7uxsu2aSW743HhSpTr2sExkM72fkIaW/Y+2QoXPK8mnZKljTKIskk2FtIH95Dg3BOxWQGiDvFByP34jH2dpFrRXofiRTlJo+7l9otd/6Z6ZGiUhqH3KicrOKhlBjMxHQT2iLYNfmMYUElQWs1SjHlvnkQLqeB10KYA0iUslhxMxhpvkX+FktPhpVraPyTpGDIDnquHtzGjEGQLGWfEavNy2xS6+WWsGO6DyGbybhSpomiynwgh5RWcm1i+utAKJM0JboPCCbGtdN2nnm91QsKMha0il+smPPpVkCpZC6iOpPJuAKdYTw8Glhn478gllsIvmzA7PuVDC0IcmhrNqYYG+qAGHGJL4R3yl+gZMP1/u+h9IzYAQCx8zsbURgKbq/FA1dlLDhyJvD7zgpaYdjA20dI0ngPzbdL24gpVRZKlGo/eTEB8kQDGVza6GMdjRaUO0uEsYv6pwTHDylWUP6yEm8YMQW0gTJCMTvfpTAjEe51iXRJqCCNozoO/C4n2fchQN7DUdusOO
 UAQFetm4
 3t5rjfm//sCoTVjO1ji04PKzHPt8w1mx6EhppOLGlwob1sx0+6VtLgGurt9tkaJuQ0IoviPd7HMIprzvqxARvKBeFAvidzKWoYAqrhVGMry7AeBlNrImZiVTaoZwYdA5jfdj7UmIoCP1dX2BzCJKyuqnQ6cjQpKD8viMHZo52R39vp1wktFfpenxVDAuSHq7wPIpzP1IEGn6YOO1mk/ZPnceesE5jyME9OhVdzRakCW5AG43nVDPrgRAUm8cy0Ov3/+HseQpn0bLofPfs9y8EmQTIF+eMM+/vU1kVCLNGDyBe+1YRIt+aPuVOpnY5AMBQ/WL2DWN/RYsTYZ4QF5FHGOTjiGLYuNmg/pSJox1V4MeIJfs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/09/2026 11:28, Mike Rapoport (Microsoft) wrote:
> Commit 0c6378a71574 ("arch: introduce set_direct_map_valid_noflush()")
> added set_direct_map_valid_noflush() to allow updating the direct map
> for a physically contiguous range in execmem.
>
> As Brendan recently pointed out [1], this API is confusing because on
> arm64 it means that is sets VALID bit in ptes, while on other
> architectures it is an analog of set_direct_map_default_noflush().
>
> The only user of set_direct_map_valid_noflush() was execmem's ROX cache
> freeing path and it was switched to utilize VM_FLUSH_RESET_PERMS for
> resetting permissions of the direct map alias.
>
> With the last user gone and with set_direct_map_{invalid,default}_noflush()
> accepting number of pages as a parameter, set_direct_map_valid_noflush()
> become a copy of set_memory_valid() on arm64 and a duplicate of
> set_direct_map_{invalid,default}_noflush() on other architecture, it is
> safe to remove set_direct_map_valid_noflush().
>
> Also drop a stale comment in arm64::__kernel_map_pages() that Linus
> bothered to add when merging changes containing set_direct_map_valid_noflush()
> to his tree.
>
> This reverts commit 0c6378a71574daa6cd1534ad42a956e3262756c7.
>
> [1] https://lore.kernel.org/all/DJ69RCVRBO0Y.3JCYSW50IC4RC@linux.dev
>
> Reviewed-by: Brendan Jackman <brendan.jackman@linux.dev>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

It's a great feeling to see the set_direct_map API get a little
streamlined :D

Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>

