Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDCBFFD3758
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 13:34:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 294E76B00A2; Wed, 25 Feb 2026 08:34:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 235406B00A4; Wed, 25 Feb 2026 08:34:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14B656B00A5; Wed, 25 Feb 2026 08:34:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 008EF6B00A2
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:34:56 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9D6981C5DA
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:34:56 +0000 (UTC)
X-FDA: 84483074592.28.E23C8AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id BD3E4100004
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:34:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P52K68ix;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772026494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ANyhmJ6aewq4DbfTbeK0S0AZqXu7HsmNHKjdTl0Y+ho=;
	b=RLdeePKQ71N0qMo0UD6DcE6B6CGq4OJ1gaiIoGN4vjX7a3HfdDcugeMbNxDWqnWdf1ks3e
	8qF0CGl9NNJCyG10eXIoDmyo8EPc3ILitNz7UlYAul06onFV0v3EMrEgAuCaepOSaw9qEq
	NVqhSVJiyWQDXjKbWBYhKl8z0trLaR4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P52K68ix;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772026494; a=rsa-sha256;
	cv=none;
	b=0VGDGW80IEaFQyxyJvYEWx+Z/L7FcRRABh5fagcYd+YCM8w8hW93k9GdV7eZLMyLUxwuf/
	g3ci7R6azwin7jQUNsU9eMkqeRZV0weI2rkk5+jhAnbNJPRTCumVFGccGN1jG9HW4vHfGU
	7PWSWFYTIfnzCOsLIoodY4tDTGlGeMI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EE4B643294;
	Wed, 25 Feb 2026 13:34:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4EEC2BCAF;
	Wed, 25 Feb 2026 13:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772026493;
	bh=oz6PkwWT72KoTYXI1dSUbmwT9Xn+9gUZ1Yrp8upYEqo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=P52K68ixQOfuix63rwPzWY9perX2PhXSjGQbvXfYzzb7nWjbSNrdhQEp0cVS9znnQ
	 1KLOAgOWAL14CjcqtSFIkP+o8IS9gijY2ZRWz2+2K0jBR30VfhREbl6ubKRUVLXdKZ
	 QHkg+nJt8M7WcJ2VD66vs8d7WX4Rjg54gAtqh8XnGenvMoYGH6eQktDZVWFWWFU/46
	 ftMNXCoM5uEC4OFOzEv9y5qy9cWGBV3b2ypRLSnlZdKQihcYhX7qEr7MUxFhVbxNHd
	 P9XA1VfqI/il6mMq56KwFqnnOf4gx1OfmtdIicESEDsZ5MlqKc8XWtlYzs8B49d8m6
	 OZvvIgsMw4XGQ==
Message-ID: <3198ab73-3690-4dfc-80e3-dd2b29b78658@kernel.org>
Date: Wed, 25 Feb 2026 14:34:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] mm: Do not map the shadow stack as THP
To: Catalin Marinas <catalin.marinas@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mark Brown <broonie@kernel.org>,
 Deepak Gupta <debug@rivosinc.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Will Deacon <will@kernel.org>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-mm@kvack.org
References: <20260224175800.2500729-1-catalin.marinas@arm.com>
 <20260224175800.2500729-6-catalin.marinas@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260224175800.2500729-6-catalin.marinas@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BD3E4100004
X-Stat-Signature: iq3cxgin1be7gbef63fuwcrqqyg46tke
X-HE-Tag: 1772026494-872587
X-HE-Meta: U2FsdGVkX1/99eLOl50usiEZjsWgFsFw3SL0luRdzB36TcAXwUAiQtYi1jctneroPhDyXfg343c+vMwxJa0v0d+2z9fiNZWJvHdrFxVOWJvVaCTIRSj6fvAmfZblj5js0sJoH9ZAhSGfu8r5u3pRzrIBOdJCI7G+CuUCmJJPJyCl31N0gspb9yzO63SDNSmS/bX8MgwPSIGY90qqPp33eP+MiilLEQok4k/HbZKWheJnid0tpD/P318L7zz1m0uqtSBA/U8egtTeMyjKUfAXYT+u7htijjUGFBx7ghevk8QWV9oXKfi6WVuOfVxgJGWBVo9j6/Afjoor4LhHw10MZE1AM8ZcCUHY92ezW74RDCibgZUdlejh5QD+p0a6Yno6wHuOhY8vkNn9Fmuy1nX3gM26P0G/0aeeUpJpPYlZr+tmaUGXDxDIDpD9waGRpzhk9kEsVJrnpMBAEazWcOsL+jPwJiCjapZ8QxBuHTpHphVbEUBPbbUIqs4gIZYEEPm6tEbiqOFfUduCMpx1kmQW9YfoqzUc6Fu8PJO3zpgWcbt1UTx3blMf9nji4Kd4IlTqQwhYtqb35XVHf29TJ+DL+enFZ+gbaM6vQ9Zj1PgHBCBpipy4qe50nC8m4RF1UN8I+nOyc3QQu+q0vMsyv+Jw+MDM0qhVjbPV4WvGTZ6UT4HPtRnVxBqFclrFVIP4p5eM1Bwb1s3GfCKHFS/kUUD4cXZAKNfqKlRH8UTVOVkCmARZsvKAW0jCYq3YeQiKvMAau6O5Qg1npcjkhiM+3HEo7q8pCMN/u5gPwfAmj58H57vagN/nHoh9jYDMNNtquSripkLB/E7ucsqz1lTl/tWQY688nCtfHio7FMkkVw+xsOECBFQYLa+dTi7yd6gK5s7N5uQ4esFNu7TcMNw9vXS5EEAkKFipJWtxTtxOx+cvEEAwbDhfEdSfxbJQSSJ0RiAu2uKmQN4jKEEUAkQ4fY8
 WVBw2U2U
 AUi/8BYIbe1RTCM4jg6iyE9WLzS4NaiyrhNl6VCAYZSspaeIjR2/MsJHd4sxGjgIGsTr1HK4rSP1bU7NV+EmEuqELvxHYSNKKM/oDE96Wy/5xs1DbnRiayFA3lZ7Rdcckf9SCVr8d+TEYOVd36vb1Ub9Rub6/ELn83+ugixeOET955JwyRUO6efnDFxtKvbgGEGRvZUUmyf+ysN+U3wo/VECvlX6o9Eacdw8wl9bdmYUtWUUXCWMCNwYMgSdknAUOvvTuseGLvLST9Ws7dIc4r0qJ3d4Mxwp6V62fOv0OTU0Tfc7zwgIlzRSAD0bqPh1q1LNvxqT5pJ1+OQCjRXAvYtBPuwEEhc+Ej9cgMnCWAlgECWLOqN4v0WXrLopi+GiHr3mhQe+NoRQxEgEGHghTuUK2iQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/24/26 18:57, Catalin Marinas wrote:
> The default shadow stack size allocated on first prctl() for the main
> thread or subsequently on clone() is either half of RLIMIT_STACK or half
> of a thread's stack size (for arm64). Both of these are likely to be
> suitable for a THP allocation and the kernel is more aggressive in
> creating such mappings. However, it does not make much sense to use a
> huge page. It didn't make sense for the normal stacks either, see commit
> c4608d1bf7c6 ("mm: mmap: map MAP_STACK to VM_NOHUGEPAGE").
> 
> Force VM_NOHUGEPAGE when allocating/mapping the shadow stack. As per
> commit 7190b3c8bd2b ("mm: mmap: map MAP_STACK to VM_NOHUGEPAGE only if
> THP is enabled"), only pass this flag if TRANSPARENT_HUGEPAGE is enabled
> as not to confuse CRIU tools.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

