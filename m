Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72CECFF886F
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 16:37:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 927876B0005; Sun,  3 May 2026 12:37:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FE4F6B008A; Sun,  3 May 2026 12:37:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83BEF6B008C; Sun,  3 May 2026 12:37:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74FBE6B0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 12:37:10 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0A8DE1C12E9
	for <linux-mm@kvack.org>; Sun,  3 May 2026 16:37:10 +0000 (UTC)
X-FDA: 84726663420.06.0AF6C31
Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4A982140008
	for <linux-mm@kvack.org>; Sun,  3 May 2026 16:37:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=j0NXBBie;
	spf=pass (imf26.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.210 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777826227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qxSFsuPFQC/VGeg6rx/w7eQe0UU5hBkr5mLg7VC6mLM=;
	b=BhHp//OnVdbCuo9qfvvuhjJOKYQvEPWkyaB/OS+ur9LK/UJts12fPVI5eTjpp3vBD1uhU1
	yikm1pOM9MniZV78eObr7TIt4HzWW15sM6cP8GP3Q7Izj2kxbvscBiNKQqhESuhCLiCwZV
	77Yi6hYgI/XNkkTJ7E2ccRds9PGeeV4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=j0NXBBie;
	spf=pass (imf26.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.210 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777826227; a=rsa-sha256;
	cv=none;
	b=Y7Te45Bvm9B2Jvye8ZTUjMsZIAWiwI/9BVCp5XFlx1ZF9CCaYxkVVYoNx7t8UxRbzn0xwb
	mvz0y1ltJsg9DFuYBjtXNL4qwvMsvFA1Mp+uOYkb/i9+HAJyAxhNHOLcI8Cizn9FXPf0gw
	edcOcVYfSO8nB7O0ucqNhUayOfmAqdo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1777826219; bh=qxSFsuPFQC/VGeg6rx/w7eQe0UU5hBkr5mLg7VC6mLM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=j0NXBBiemWEuBHvxlZiwCHiffW0HtoJqAeBUZQbWjFJmDigrGGtLHaNjUG75orqwq
	 SSqRfUfqWLE+3oRtHaI8sXF77xYJGoPQRVnnfNXU4+PSgrsuv0wmxIFx+rLtcwWaxj
	 /9KEi9EPBESeYnp3lo1OLlUKmmzLo+399s1tY10Q=
Received: from [10.46.141.45] ([36.112.3.68])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 938BA0D7; Mon, 04 May 2026 00:36:56 +0800
X-QQ-mid: xmsmtpt1777826216tdk21x7yo
Message-ID: <tencent_03736D3E0B2A0ACC8F78E08FB0DE3C59C00A@qq.com>
X-QQ-XMAILINFO: M7W7QqjC7ykd6I1CN44wqQVuKhP+FK46w/k+7KdSzcbZjLgs+6eaOFD2SvdA9K
	 +o88Td5/o5xc5vWvmSL0ZA2SqtDvPT1Ei/MX6MUjrnxc0GqdKTb+GoF4pVpZgv285sSl7+s+8cey
	 vL98shZ4uOUclo3/z9qwRjfLt2sAZX8l4ylhu/MEm4zAy1GLfCAY4gdpO3V8fCnRJTnF7IrH/4Xp
	 81KBWPDRDHfbzFh6J1NUNpV9kQ45j7BgIQoZV0W6y8XANN0H4AJTWu6Kx45sT5bS47Qehcjv5RXM
	 ssQ80p1PZSbvZMVMhpGlGW6z+YtE1RRSLxwI4AZwbbGlcgxAIrAs39yI7wPdubXWTJfPNLT4bMBa
	 76bDVQRZVcGWnrlA1r2b8ZWBOTXQxbBcrDgclhxAm3m0ehc8BOgw9kD53pv9PjzBr4jWGuDv6iH7
	 fJXFmgj1MCqXTDz459S7L2TlmBOC8OgI2mxzSnzoVtReRy0bYeOYqmXESr0/BiYJShL4fS3FXYFU
	 xl065CsTTw1rViRGPJzm8UjU00NfwvHVJ5Bpl0jALKOXlUgVMfK7yaLnbAGs1teEMOFA8KP8Gi6R
	 8iLvjzjzAokxX83N+3o04nJ2htj2DZFQKis8ef3v1LvoMznMijD2Zcpp70IVFHDjThmoi08cgaic
	 H7BG7WUD44TuOqk+Aad1tWGiqHRRO6YucmzEm01U7gl0F4Ts0Mbnkf7rL+h6SGR8Zkn7fwCgyy9A
	 vBTiqu/CsF00I2aWfCtIQNWAAJhNL5VUad9sIJDjyDejfT2sKcxsa3bT0sCZDKhee4SMsszrLPSi
	 AUcnFt/5/ZMfG7/pT9xN4vXe5iGxy7dvrchFX3rDwRlTp1IzBbAgnTPXxhtJDEUNgB7rK8GZHA+O
	 C2Xc9+0ldB33ljNgKZWsMEA5HmEgS0/sIUFIDdlPUTf+euNBIVTWP4m3fa92BZka5XS3A63zOMcm
	 kzjGpIj1oHxemJpNoURUGVV4QX1ONAHjm9hSJP1kUwgSsEcDewqmcbd/c3bhvzwWNvaXMKcN9m7i
	 NNfq0pRPiK6ArH0hfic9nsu8ffRmP50UAHJ5jHOXUM73T8TwNB6AnYayUQuTw=
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-OQ-MSGID: <23c1d65e-257d-4b77-a345-47bbe4bfeec7@qq.com>
Date: Mon, 4 May 2026 00:36:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/madvise: reject invalid process_madvise() advice
 for zero-length vectors
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <tencent_98F3571EF9236437E5165F5C08CF258A9E08@qq.com>
 <tencent_BB588C2CDED859A873093DAF28B2CC1F7B0A@qq.com>
 <637208e9-9d1c-4e7c-8428-9c3d36e2b7da@kernel.org>
From: Fujunjie <fujunjie1@qq.com>
In-Reply-To: <637208e9-9d1c-4e7c-8428-9c3d36e2b7da@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4A982140008
X-Stat-Signature: 33cxjpn7zrbcptsafqztqdkmshjudo59
X-HE-Tag: 1777826225-17448
X-HE-Meta: U2FsdGVkX1+xV5XlkXqq1F/csFURYEYW4UdrQPENoSCeAevK7Q0K300/8I5Fk3PUYXZp72JjUhK32d92RW8FYTFzOfiP4FxRWe1LoQUmt2nvwp5Q78yKGWEOYCBiGjF20eueUYF4JY3lT70GKwfF/kpWx7bgAsFtqNNqRjkt/nYxXUl5ttsBjiDNsxb/zaQ+xJvjimjlcVfayqTINVnKBa574vvGU7U7yTCR4pEvVEauvbfV9Ml1OzcSnuHGTstYNUlIyMG/Xp5+R7mUlEQbgYFLy9azcaQmLs9s5GDy0GvNKvGWxpgJVZLmb/sLlB8mf/VaI/MY9vpwEZ/rAobyekxB7RPdkhJBAdudjyFbCG7xglLECnL2Ax80J1EfsVhscFXFhAFGeYBT+NohA1Kp7S45V5Q4rlmqpjisi4PntWgnrOILrV5exqOohwCCDFSd8i/e7TSZfqk4xA0nwElhCm0VxZR5O7BWa0f9Kd1F9UGQuSqEI1kpYadGb1707LFISxeYhykzuP58LrGL1k5ZQI11ETDVL1BhQ5DENKELhrOvsgvQtQf8c+751F8DxPMsU22DWHOZDPyF4wQhIhzrp4/CNkK682yO3cpMRYSdSUfBJxMsyoGmhdmH48VP5lu/+Zk9qTCOr0WDtmyffeP1B0zuPRuuXj2V6zoVH3rbNtJvQ19qhWJMUUSgf1UHnxkSSP/20OhLBM098mZRulJm0VhY8laREUoI6p0nfwvrDgsoIAydmZ5cd4Zky4I39aeTejfXfSAeKoJamMUeVh/eIzpZDBg/EIBfKKUbFWQG9ZOxFDaVVljKjttSw1+cpRKIRjkwi4U7ySTqO5m/+6jsJ0TgDkth2zVcRVlUzD73ewspcKawMsX1zF7aIofhCs9xADoqcBYrmfmiU5upBaIKkFP9KKZNwcbGYiSatX+Qw1vhBUnr1LHBDHo6CtgIhG3yovnCgTESHDZL8XEWhM/
 kSjXVXGQ
 Z9ibHEHGZ6ISp9VPRbbsYDh9IexG5SEVut5Q0A/1JAWQ/1QDUF50prSe3PQSJOgbFJB9EZVgdZNEA4VN2SIefF2m6extOn2vstqPODrrgX5v1b71ZJHpRWKB8ZnJFcgowKt+P5PXgXU61RWZ8/qzzhtYmrluSI/pa3MmmWlIEc4uI4E9BrAzRcczERnPFtjTACxH2yhDImpYlEyjjiZdZcy8jrZSd7r/0VMPpYCfdKz/SF/iPg1EE8PamPYPNE1b0ijYJaRwlMU5eZVp6YXLXXBbHesuc7ToNYVOty9pW1q8BIRnmd/if4J18wYPUuMjmF5tNUbKhRosmyN+d7a4qq3htgiaNNusg64TOFJI5YLC801Ko+GaBtQ8lpaCA9MmokH/BEJMbBblCWvpyMcVQr6IKjHqer///UnccGGNDZQ04ePpkwONwDNXMT79Dj87Cv5WZ/LrsZdrXsu2v9WjAvIVLjjjbEKN/HTqb81yOyP9oygKpcCxubS0KAV9EXtUQVBPffCK/BuJzZS+oWgy9WIZLCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/27/2026 7:49 PM, David Hildenbrand (Arm) wrote:
> On 4/27/26 11:43, fujunjie wrote:
>> process_madvise() used to validate the advice while walking each
>> imported iovec. If the vector has zero total length, vector_madvise()
>> does not enter the loop and can return success without checking whether
>> the advice value is valid.
>>
>> For a local mm, such as process_madvise(PIDFD_SELF, ...), the remote-only
>> process_madvise_remote_valid() check is skipped. As a result, an invalid
>> advice can be reported as success when the vector has zero total length.
>> This differs from madvise(), which rejects an invalid advice before
>> returning success for a zero-length range.
>>
>> Validate the generic madvise behavior at the syscall-facing entry points
>> before any vector walk. In process_madvise(), do this before the
>> remote-only advice restriction so unsupported advice is rejected with the
>> same priority for local and remote mm. Then keep the per-range helper
>> focused on address/length validation, avoiding repeated behavior checks
>> for every iovec.
>>
>> Valid zero-length requests remain no-ops and continue to return 0. Add a
>> selftest that covers invalid advice with a zero-length iovec and an empty
>> vector, while also checking that a valid zero-length request still
>> succeeds.
>>
>> Fixes: 021781b01275 ("mm/madvise: unrestrict process_madvise() for current process")
>> Signed-off-by: fujunjie <fujunjie1@qq.com>
>> ---
> 
> 
> Next time, please don't send new revisions as reply to previous submissions.
> 
> Thanks!
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 

Thanks, David. I'll send future revisions as a new thread.

Best regards,
fujunjie


