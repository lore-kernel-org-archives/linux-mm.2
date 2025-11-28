Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B7F5D116F5
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 11:46:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FF2B6B0012; Fri, 28 Nov 2025 06:46:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B56A6B0022; Fri, 28 Nov 2025 06:46:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ECCC6B0023; Fri, 28 Nov 2025 06:46:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4FB346B0012
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 06:46:06 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EE735B91AF
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 11:46:05 +0000 (UTC)
X-FDA: 84159837090.20.6FCAC06
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 44EBC40011
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 11:46:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NCDlaJ1x;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764330364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cn1RtaIIs9ub2fLUkzR5Rx4Z7gztn8eAQ647vToUiNw=;
	b=sMzW8UfvOHyTfjHnDGmWnIx2HpNk2C2+jl3T5XN7NIb2AzNAbGzppN4A3/CKdaDDbaDcHI
	ZD6ZfGhQ1vFk/7g4UnhX1PLyTAcSAV5yjW93TV0QhJP35lirWlVta6k1hLSWwKo+0Lo1Rp
	vT2cBhss4IgWpWLI95vDWqEJJ3nuigw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764330364; a=rsa-sha256;
	cv=none;
	b=zngjo0/rj4K2Xg7t5DXPgQwmxEcIX+B1/10HXRoHpKU2oYjY3HZsvpGXSjTd1rdnUfq5uz
	dxsChnqiWlOEy9mhKRDX6wX0tN3GwdI4uyPPlq0CSQwzofRKXfRqC1OuoJOGhUpKQ7PanI
	/lLF36mV5iQED1FHfLllIpuR4BLLltU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NCDlaJ1x;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1BC4743F41;
	Fri, 28 Nov 2025 11:46:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC58BC4CEF1;
	Fri, 28 Nov 2025 11:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764330363;
	bh=vqplphJ1VoiCvxNWL1YV3ef/8TrqVxQk35wf0M+dKpE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NCDlaJ1xHq7jQKrG9HYERIFWL4+6bYQzSi84yWcrHIc+mJJJwfcJjCbahGIOCLGJk
	 N9MgQCYV0gXSUhrIFLGQlHDQ1U0Tex0R5nHiCBATbIIrAQMWe5E11T46cKFjg5O5V9
	 CG8+OGkEC9vfC8Ug9PP3vjliWkM2EKMR8SfSZ8g3P7TetdMKvCyR7Z0GM5i1ZvuPMC
	 /vToiwFKxj/lbcrcxoXnI0JWsQPq3bAAJpmfH86B5oCm/O8ZEGMIRSK6pQ/KOKuWZ+
	 65YuH9Bnu9x00I4PG7CLbXhODhUFczkS2h73y9msGtTGRSfiBfcv/4wf1e4K3UiZRg
	 ho3SwP6DLzF4w==
Message-ID: <89b5b9e7-d8c1-4402-9fe6-b312630b3d50@kernel.org>
Date: Fri, 28 Nov 2025 12:45:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/2] powerpc/pseries/cmm: two smaller fixes
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>
References: <20251021100606.148294-1-david@redhat.com>
 <557b5500-412a-4d26-8c4b-147c9a00d5fd@kernel.org>
 <87zf86n3vq.ritesh.list@gmail.com>
 <3cc7d401-c77c-4ac8-abb8-c264fbd9aaf0@kernel.org>
 <87y0nqmwaz.ritesh.list@gmail.com>
 <a3bb0e8e-72c9-4a9c-b347-e899ae29b289@kernel.org>
 <189ac734-b194-4b52-9752-18d8c0b71377@kernel.org>
 <87tsyemocw.ritesh.list@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <87tsyemocw.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 44EBC40011
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: u9aw9qdcbnex4ue15awe3qn8tgkacd87
X-HE-Tag: 1764330364-471739
X-HE-Meta: U2FsdGVkX1+od1HhTWu8Ia6pa6ZVnkUP6NsEsU5iPvZWDb1szQuMYenAmtiuk7i273F5b7FzRZ+BGmlVe8MpLLZ0Si5iDp/vheiDpLkfbB80TrtZNs64kHYnK495v/xZXB73YRJGJh+sdQg0EsxgtzDFib3MhI0CUicv7YgtO5PzLWy99QR80vKI+OGuYdBGdE24Yu6kGQNMF8Awird9jFv+LMUsAiPdf4j3ylAG0HawHuUHgJqbze+3z7F/Ftg5nW0vRKqtZLGypyMqd2q3Pw4MVd64jIcRpbeNqvIdMaxhrj94dqBOLzj9aaetCVRFnUdBWkbR0LRxTwYtKKdJZwUm+f6w8fiMNh3pyGaaTsSLjyET0f7MwumiYCAyP+/8BI17yqyGr0Cyf+kVJ4NZCZOR6EFUM1daHgmwzUD8S0TSuqmmItwu1X6RQnBI75N4LvWeq0DE0naP1y29mZ/eagNtOpfIxcrT6R4UvUbIfBYBVxF8aHlz6bd2DS3X70QcMiD7f56jgZGzRiNuXKucK9xgisztUt+Sg8mzhqAwmlsegjH3q/l9Fx6/GX1jhgkhoaz0T6AgoH+hVCRqpvhRH93jwbPufevKffYBM3amnQyeIluyf6SDeo61jri+dlbU+ZFHouBnTJeq1e04f8QZ6n7EUXRiGKkejpznVUjseAJUH75uQDn6DxbOtDPMBEN7Ek3xI6FZaVSMfWN7pRL9rMCj3SWHjbKDt47ei9g5ZVsnQ4XCzM4zta1XJ3d8m4VFyfqFG6tGFLC6husol8518+8q5j8MVxwzs7QlLwJDPofPyNOgywdJP/FDcf2TxW9g+CoSJi+W2s5WyAld8qVu0pIgDhuBggJ0sTXGG8ghGGgpVWk7guabd6WlIwE/u2eTD8cqIaMddweA8QWjfbKEZPsyHwolS73uDdsK7UK85LIR+MecJRZqTZXUDyHxSOd1dm+E2ZBfSKdZlY4Ys8g
 1PLuG3R7
 SHBxNTLVe4I2RTGcQoYM/se+fIw16p44HLLuQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/28/25 11:40, Ritesh Harjani (IBM) wrote:
> "David Hildenbrand (Red Hat)" <david@kernel.org> writes:
> 
>>>>
>>>> Right. Let me give it a try first with pseries Qemu. Otherwise I have an
>>>> access to pseries LPAR too. I can verify it there.
>>>
>>> Ah, now I realize my problem: I tried with Fedora 43 in a powerpc VM but
>>> the modprobe didn't do anything.
>>>
>>> Looking again:
>>>
>>> # grep CONFIG_CMM /boot/config-6.17.1-300.fc43.ppc64le
>>> CONFIG_CMM=y
>>>
>>> So modprob'ing won't do as the module is built in.
>>
>> Right, so doing "cmm.simulate=1" on the cmdline in a Fedora 43 VMs
>> properly creates the CMM device.
>>
> 
> Right verifying using simulate mode is very straightforward. Thanks for that!
> So.. using various random echo X > simulate_loan_target_kb on a VM...
> 
> ~# cat /proc/vmstat |grep balloon
> nr_balloon_pages 16
> balloon_inflate 1638
> balloon_deflate 1622
> balloon_migrate 4

Thanks a bunch for the review and testing!

-- 
Cheers

David

