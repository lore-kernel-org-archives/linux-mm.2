Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92C31CD98E3
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 21:14:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4F188E000C; Thu, 13 Nov 2025 16:14:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E26708E0002; Thu, 13 Nov 2025 16:14:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3C6F8E000C; Thu, 13 Nov 2025 16:14:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C15E58E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:14:30 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 81FDE12C604
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 21:14:30 +0000 (UTC)
X-FDA: 84106837500.26.5475D57
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf28.hostedemail.com (Postfix) with ESMTP id B426AC0015
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 21:14:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2025102301 header.b=pBkKChWS;
	spf=pass (imf28.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763068468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tXNla8kRg5U9BgGDpPsw8RPi94o0olG3pxIf2ldSmU8=;
	b=5PGmnKWvUjbHDgI3T5a+mGIxkLA22AT7enm8GCVFoUmEkf+TjYmowp48RgNONkT+nd585h
	am/VJdMzumqF0ccL6/5DxlkS/rE06sDKuL55ul2yYZGrjqubYjy7MYczTppDhYjjc5q+kE
	vOVG1VvxCrb085BW4hgkCDrlcHsWy5Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2025102301 header.b=pBkKChWS;
	spf=pass (imf28.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763068468; a=rsa-sha256;
	cv=none;
	b=nvqou9pJu4tT82TLYyiFzUUb3Or1CdHPWeUmGKwcOLObDbtzIYik6D4TaUrhujAG4Ep42G
	H/TGPVMOkIb2G91s01h3SPR0ulFjwE1/Uh5xf+2wpVeus68G6OgZ6Djz1nSksP+rWLdbW8
	xNPLWqqTSXvrjUlGVzcyL4qu9bbLxK4=
Received: from [172.27.2.41] (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5ADLDpwL1691494
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Thu, 13 Nov 2025 13:13:53 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5ADLDpwL1691494
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1763068435;
	bh=tXNla8kRg5U9BgGDpPsw8RPi94o0olG3pxIf2ldSmU8=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=pBkKChWSgNJMKR+i/pkxDjqmbIVJOygmGugU+3jfoNeDoTJ3qFSJzeZpMPu0jMRoQ
	 IWaU9Y6Ai9Uk4swArRd+AgCW+5VVdZA1dyR2fHn70aEDTBq7Uz8Fbkw2Zb32kNwaxX
	 MM12m8nVM+RZFpMajqzofPuwCVB9Jlvb1dAY1N9FO+0StBEeX5T/S8BY50kHfCyCUb
	 JLAEqK20Lp5Vey5KIO7oCiQlJxVaLEf56OchxTA7qFeqAVvB/3WNONi1nRBrqUyKOk
	 VlnTdVXRwEHLGWxXjLHvfL8lAe7fHgiiR3CxvhQIK0dE5XTKT7l03VpeBQEMwYzH5e
	 eWxewkfUZVoTA==
Message-ID: <b2d39a78-a66c-4846-b07a-b7cd5a85d00b@zytor.com>
Date: Thu, 13 Nov 2025 13:13:50 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/9] x86/entry/vdso: include GNU_PROPERTY and GNU_STACK
 PHDRs
To: Andrew Cooper <andrew.cooper3@citrix.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
        Xin Li <xin@zytor.com>, Andy Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Brian Gerst <brgerst@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, James Morse <james.morse@arm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>,
        Nam Cao <namcao@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Perry Yuan <perry.yuan@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth <thuth@redhat.com>, Uros Bizjak <ubizjak@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-sgx@vger.kernel.org, x86@kernel.org
References: <20251112202258.1310754-1-hpa@zytor.com>
 <20251112202258.1310754-7-hpa@zytor.com>
 <55128481-71e2-489e-a669-25b60dabb407@citrix.com>
Content-Language: en-US, sv-SE
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <55128481-71e2-489e-a669-25b60dabb407@citrix.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B426AC0015
X-Stat-Signature: zbpx4498amysdr6ubkfnk9h7nb49qqyn
X-Rspam-User: 
X-HE-Tag: 1763068468-587003
X-HE-Meta: U2FsdGVkX1+eU6o42G2VSH9EEI5LHPdnqBnZkCmAuHh8gh9SyCC3U1tShPzM3QS8DP/N4bpuudBeAH+cqU60r0isqU9TREuyWARMA2KxKB8yIIzz6UlVTiYI6vV63uNLOvuFveDJmH//ld9NGyljTJU1PNiAevmFNLNW4rpYL9+E+TDJZbcZo43otfMlevks0TxdQPO/ws0LGjv1oaU3wUT+DB44cmka9TYCapWHAthQpBnTPcfmr7MO6Br4FfMHX7D86/6N3/x39kncBmZgu6O8Vg1sf6mdTaTlXRZDFZJoHUhjRHyp7EYiqKnmFTy/PbqcvqQBJnXmHBl1tDdhlnBFe0QusL60e3hPfk4Ca3tWak2DSJE2j9bstYPHw/77+fQY0V4QfJc5HzvWgMcFzNmTShXKaEej0ZlPNMZ5QUnhaYJC9ZpQUO+fPcaByycU5BtzEyu2mhvWenXkZd/fIUiO8XxjaTdrIB3J3pG9W4uD47+BHRFUKsFOgHXNyYlIpmb5IMsWsI+KoYeyEpTvWSfjm08RPii/W9EMWboiqvOgSh0UDaCkBkVzx8s4EqP7gx5xEh/Vq6egvucyEUGu24fYP5tiZ92oKVJFp/NUf2Ktxrt/v+Ph1qwE042WelPAlUUzbtibHgLl2GrRgI6z6pSRkvMC+tmegO0wB/mL5fUDhNW6wYjJMijT45bRYhjBAUeftpOKciEZ/aDKkb5bWknhNQBNvSH0dZWm9OVvJ2wczOywcM579hSO1/cDKYy+GrAxW8t55JeutOncvFX/enV5VF7Uw39nV0hGPAclb30I5mPUt3xLm8mLDvbhe6RwuLiJ8CJOdRxG9LL9OAGMD/ieoh7kFrPjLJvuBoaaK5nF8gorQKtfel0ydwPYlTCsMZW7+qdJnCmgkPLTWKkcS1L7MUSVj682Ama+V1XMvHXhCtPyzBm1P1P9cBV38PbhOFIz6ZBepHU+vMEXC3A
 EJw2bfhy
 qrl5zItBDNH228tnjGUvBFn2Ba0RlgMiwKUMJbNnBilrttofFUKGiPdAc/SRI08WB5XuxeqXuYXr8WxnEcQPQ6TI0F3O9OgQdWSbqouYOhhTOJAhdJaJ9x3iYQbOfvoAtqPvb6GtypnYU8/lU0HoK9dV1/8ksHzqGlSIKb8rvkRrthLPEZGNHDaLs9ji5nNts3tGvtx3NjDUFk6k+4jOR2twZtoyVZHnFiLnWGEgDUtB4oiOlJW4H7TJJTQEtyyDA+6b4bU5xeOUq/5ZrCLayVC5IrLdvLxnTWr42cI4ISWuinn3GeUa3+7GQGyvVP6U5F7wwfoUPmippjN0jakWKYneHAjkUwoA992zjNez1P37lmY18GjMaFQLh1NkZw+qfACHHnzYJl6WK5W4CzsjTqERz9irOWycjLhpa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-13 11:09, Andrew Cooper wrote:
> 
> Almost all of these hunks look to be whitespace changes only.  Was that
> intentional?  It certainly makes it harder to read.
> 

It is intentional; although it adds to the patch it tidies up the file itself.

>>  	.altinstructions	: { *(.altinstructions) }	:text
>>  	.altinstr_replacement	: { *(.altinstr_replacement) }	:text
>> @@ -87,15 +84,23 @@ SECTIONS
>>   * Very old versions of ld do not recognize this name token; use the constant.
>>   */
>>  #define PT_GNU_EH_FRAME	0x6474e550
>> +#define PT_GNU_STACK	0x6474e551
>> +#define PT_GNU_PROPERTY	0x6474e553
>>  
>>  /*
>>   * We must supply the ELF program headers explicitly to get just one
>>   * PT_LOAD segment, and set the flags explicitly to make segments read-only.
>> - */
>> +*/
> 
> This looks like it wants undoing too.

OK, fair.

> That said, I do strongly agree with the reasoning behind this patch.

Thanks.

	-hpa


