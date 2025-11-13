Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7DEACD98E2
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 21:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 104918E0003; Thu, 13 Nov 2025 16:12:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B5468E0002; Thu, 13 Nov 2025 16:12:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE5DF8E0003; Thu, 13 Nov 2025 16:12:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D7C498E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:12:56 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 819A61DEF14
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 21:12:56 +0000 (UTC)
X-FDA: 84106833552.01.316C8BF
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf28.hostedemail.com (Postfix) with ESMTP id EC36FC000B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 21:12:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2025102301 header.b=uSzqUgIp;
	spf=pass (imf28.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763068374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OrDKRTzj3kKFdy7QAY80nNNT+tK9Pn5aomuJbe41Zn4=;
	b=KErVWitZGOiMe/3RDLfoQsGfJ+zCfqOR0RI8GnxgBOgylUduAfZA4IuipQx/sfc0RiirVs
	I/Xe46+SToH9kELXdmIJvrHu4HLimQOCOFq+5J/mAl5FSCgYZbYVroacRX7NYEuSo+1Z8T
	H7/apywmBhgQ3m5GnUSMmqAhJbFWCqo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2025102301 header.b=uSzqUgIp;
	spf=pass (imf28.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763068374; a=rsa-sha256;
	cv=none;
	b=jCiNRQcGHh+7mxE8J9zV/2T2WhVhhJqsem3KdIc6sNoPvaSZF9NXCdgq71tfoMfptHXljQ
	cQoMpZrK82wGyLGtf1Answk9mxMmU9cVbVHEIR5vANZU+Ffw3ZAAUt8xKDo8X2UE/vICna
	oJFFDzsj+EcyxsIUfCTrc72VAFqCY80=
Received: from [172.27.2.41] (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5ADLBtsW1690815
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Thu, 13 Nov 2025 13:11:56 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5ADLBtsW1690815
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1763068318;
	bh=OrDKRTzj3kKFdy7QAY80nNNT+tK9Pn5aomuJbe41Zn4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uSzqUgIpXEnb6A+cdUjoYeYdbD+FFTttRbCkD0M8E7Y8b1NlU2nwL/DM9qNpmcrgH
	 fjuV9eV9p0/z/aQE8c5yCzM6YxJgy64uWfY4tLppXr7A6TaR76HXZl9Ghfr0veduMj
	 IPKqtkzJMOe2M0wdP/a7FKbGKnzJwAjWT3SUBMXyjenkaSKP2QKbwLjiDJIQSFblzy
	 +cX02bwPDtVJOqViVQVCUbPaP0W4QVC9IbdCBfOjJ5r5kDQDmjuxK3iQ70Dpbddjfx
	 ldxg88EH40fza71x4Z8ua9NZFkrSfTzOgz1IZNyDkbaZullS2h94G2HS/vUrk14OKP
	 tscMl1fE0gpcg==
Message-ID: <1cd27f96-9f29-4607-90d8-c98593eacfbb@zytor.com>
Date: Thu, 13 Nov 2025 13:11:55 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/9] x86/entry/vdso: refactor the vdso build
To: Brian Gerst <brgerst@gmail.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
        Xin Li <xin@zytor.com>, Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
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
 <20251112202258.1310754-3-hpa@zytor.com>
 <CAMzpN2iwrzKzhif7WXsoQi=4OdBENZMV14Hm2a5ePukywNgh1w@mail.gmail.com>
Content-Language: en-US, sv-SE
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <CAMzpN2iwrzKzhif7WXsoQi=4OdBENZMV14Hm2a5ePukywNgh1w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EC36FC000B
X-Stat-Signature: pw79ppsta7a9s4ox5msrh7afpfw1g5kd
X-Rspam-User: 
X-HE-Tag: 1763068373-46290
X-HE-Meta: U2FsdGVkX18kMLTLDh+LAFjCXdBk7i+A3NzUpMxaCcosCNU7SrJSwUU+uAOyrDcf/73NQGXyic1a1NGAI6ZLARR3g9ctfEAinkv8ffFHCLGuEr5hmqzlgG0Tdgq/HYL3LdrQs9QiHjzxaNNBI/gMxmpLzRI14meHLNo3V/IQANCG2SPrP6J8TlFMKsQl4NxZJEqugpy6h0b7/rey1TNXTETQyAvDJfJMEuOe/sb3tlyMdwU6oxG+1BiRMmihaGti0KbbFwObhl4FnCy0LjbmHn720a6qucLnig6k33wOeJf73+hoqKrdbHtGUrUk+2kgmpopVAzSP5PlTTX/uCbBG3tFjBSz3ykGIuQnykyMhsw4fbwwdK+0vKeRDL63fEcqFU3LDCKpfh9kOywIhbiZbidzEa2bmcFDOyjuEpYIT7LUm6Fe+vPuN/eTJSEOemp5AkoPSIYcfrJaUbQahQeWCadFOpUhaGCQ8wGpUGU3gZf723diSgHG5Sph02U3CqnF35j5AXMqxgP3S5Xvy3E1C4IgQNOMwvUhCqBPL5yJ0EIPeYwG3YwufRM0QEucImIp6w8PlhOwdm1aQmq8+ChD3Q9fq3U1LBJ/wLiZkskbSEWLh5MFkoKjG7M++9kfai7A8/xTNjN3TAjBoQwtYkYdWHuknnWwzsKUplPzmrDfTFceT4XRdW2NF2lCnONe7D4JgyvhElhhyg3SKGBHM53k/GGUjsiWNUpmYcQAy/yYuMJB8I/CWmMdoadLCAAzTQCousFpI7p/uZ0l7TDN9D0v5au88E9WqVLMpUQjQX46mlV+kuQXZ/THhetzRgBLdRZpVHIMBWAN8h/WlUj52LwFLwhWfWeRyE4CcTjkgZtcaEluImnkovyIHejh6YzmlRN7nS8uJ8uge6gEnSNevLJUP8LkGKfQC9A5CyF09rCBE5pKAer9h0wRnEe0pdUisopxeZ1oJyFTv76JQM3O58m
 u/TS2hDk
 7I+BxXL1fzcv/NPb4gVTZTeX9xZoM2RS+7WGgw0p6bkgtIXEv4jKLWRmyEfuiZVW3yhcnUSx4uvHr+JdP4mWx/Ee8R+livqCUZKOTzz0KwqoF3eZyNqF/R9uiIOSvDtW51+CLuZAQYVnw/yyVwIOHtR2pNzoT/9qdMj9ejFjaNMrIOuNnDWYCwvHoHRV16aQpjomZCcdLfB7hm36sk9D8+NPWq41xP610RkZYbX5j3t+nkrbXrcAb9lGNXhF/dsIWPOjiWUlK4ugVGg4tEM7EO4H21I6EKQ0VxZlhpwcsgkF4PM5l+x5xZKmMPXxP4Sk9hAq5pQ/KdzLanXw59kfwFn4Nug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-13 10:38, Brian Gerst wrote:
> 
> Some of these changes (like moving vdso2c) can be split out into
> smaller patches.
> 

Sure, but is it worth the extra work?

	-hpa


