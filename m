Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 843D4FD5F8D
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 07:07:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1ED56B0089; Wed,  8 Apr 2026 03:07:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF6276B008A; Wed,  8 Apr 2026 03:07:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A33046B008C; Wed,  8 Apr 2026 03:07:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 93A326B0089
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 03:07:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 45F565BF47
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 07:07:01 +0000 (UTC)
X-FDA: 84634506642.16.741E0E9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0A6F316000D
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 07:06:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="sx6e6ko/";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775632019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sEbRJmtTAbKb5uUeBjuKng4EKS1QKaPwvjUnyCDqghE=;
	b=4PZa9ADKwSSSTWwALzyaPsGmO19ybBUO5BZQIUiL0OGPESKI+IDJEFhTad41HjP/f3rFb9
	kIWC0n+RiNqXIwIKLRASWKsymcaSpwi9jFba2Ka76SW/IaNnW+Hs+EJbNzLxh5QYNljFR9
	7Tzma9F/CaWHutDBwTO1nK0zhCPScuc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775632019; a=rsa-sha256;
	cv=none;
	b=wO3K5INqGzdUGOSKuoZS0aB1mcIpFbdReCuUr35jvMLxox8jbT7/D3MQyD/HM6dyYn87qB
	RZ5gS5SdDho38Wv0futxlMd5A70a5cizBosdaJX/HpeeyUO53zxc4py+LvhKH4Fa+a62CZ
	nNYBPd5W58bkG2kkeATsYdcAKJk59RQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="sx6e6ko/";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2AB043594;
	Wed,  8 Apr 2026 00:06:52 -0700 (PDT)
Received: from [10.57.32.84] (unknown [10.57.32.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AA7133F641;
	Wed,  8 Apr 2026 00:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775632017; bh=qqisiRUcKsMuNGTzUMZDCYf0m8fM5jcWRywKXvtz4n0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sx6e6ko/WUnzOYbXo1ZC0/5e5AA2IwgEuKQo3JEUYcjIEamA9ixSNn9Xfz/DBAyLw
	 vag9fx+ghULspg/VmqWSthCJHfB/gmxyEPG5nJquVQOpSn7WWZeFyM8FzjIDOpMqa9
	 MpVFyu/mW7VcEqY5b3rm+0Si6ukgOEcK+muUDH5I=
Message-ID: <c898363b-2b24-4fe7-a567-190946ee0490@arm.com>
Date: Wed, 8 Apr 2026 09:06:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs: proc: document ProtectionKey in smaps
To: Randy Dunlap <rdunlap@infradead.org>, Dave Hansen
 <dave.hansen@intel.com>, linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Yury Khrustalev <yury.khrustalev@arm.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260407125133.564182-1-kevin.brodsky@arm.com>
 <98880cc2-09be-4bd8-b8f4-f0f0845f939e@intel.com>
 <2d2aac86-2780-4a29-9eef-116c26485812@arm.com>
 <18e2042c-d414-40fb-8819-5e930d5b1584@infradead.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <18e2042c-d414-40fb-8819-5e930d5b1584@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0A6F316000D
X-Stat-Signature: s8xbpbwsnrsd8f6fe511urrah986syoh
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775632018-118490
X-HE-Meta: U2FsdGVkX19kCWI+WerZPAjj07E0/cV2DyuTpnDzcJt5+3oURciXFZoVeHLMXBRedNcMPZP8eQOk0ErUNrpbXCtknHGcead6sIQ6O4qDKOQzV9bh9xRdjPDq/o1RAW4p72fGpfm6RRCFgBxaK+KIqz+vSnBEwHJF8VkeMrIEPAaG5+3uerGaO4UZ8rLKyJoV7ElGDqM2mvrIWENxQ7evtQ8Z/s1YVZjg0FTav7zWc8+gB+cQ4o0UtUTQdxZ5scCLU8KXt/LwVD68FfK7RBIHQkIDPUEyngfA7DxqOyv5amp2cEOJgPF3Yhjcf7CIvU+StN5m4AneYZd1qrB4jFjyjNehGd7p0+MAln8n0VpLVpV3pTMCc168wkcCr9pL0odl4wocy88s0PT4TJgAG/qA4D6SaKsHYLtWtMIzMbPkOCz/XP+VxgRCyeG2hQqypsus47TgGLTlGWl3bFb3uB2lCce3O51k0Q0HlIuGjkO6aOF0e3UkP+RSaweZKoRipD0TLROc0eJxyVaKp30xUJREoSaO6Ro5nfOAGFNZUuK1Am/O5Zkg0KaXe/qtL8JvLrMgoLagQV6i8f8pXKbPmVZsb6VHyXj8MvXnWhwGKB/VWbXOHFhywYrP/frViviUUHLDCjbNeAhhSkbYjRKQj/Ocyaui5ud7AAyGYlfvGrPPnBmfZRveAtORUee9HzrQPOIJ2d5hoZzsynImGPLCM1ehYjN9jhOIpCw8obiYaissE0ztfJ+aFCC7xDn2aypMvT+S85Cr/oMNBAlGQ4XZkuLRelY0TDCI9QXYI92vvqqGqPm+44VYGQXQmn1LBb5FqPlyooS0oJlCl+B3AKQ0fs2oUSdPmJErut/LlKRdTBBskDl8O498gny6Sz9YXi2uBWbNCiQANm9DZbotfnWH31L+WgS8xn6QPrmrrERxYQDT6F64U9ZwEZdf/Fk2Iguy0/coIbflkcvx26eDPAu9BNL
 zveJKTjL
 R+HEPzUn+uofYhlA9ZL4cDnaGwC7NqkkDJxIAf40Kg0wOauznt1LouDEyRp7Rve/RrbTpDvue1oMtyvH0DKZqQJ/1F1tELBkQKwSsZRQcAqj2cS0svEACtCgCcyV+JgNw6ITh3sl4BcCSzN2Lk8RYohDRfQLkKFZbXudQkWFzwmwdO7+OxNA56KqWzPBnaoY8H8PFXk/h+NAFZDRnT011xRBS92rGS4airzUR/tkPzTcY5hmWiKhFh7R6z7pxTJ/Vj8JdTzSJ5Z5Uj4ww4mVD3/zORLVqbJLOoa3G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/04/2026 20:58, Randy Dunlap wrote:
>>> To me "system" is a bit ambiguous here but _can_ refer to the whole
>>> hardware/software system as a whole. To avoid redundancy, I'd say either:
>>>
>>> 	If both the kernel and the processor support protection keys...
>>>
>>> or
>>>
>>> 	If the system supports protection keys...
>> I see your point. By "system" I essentially mean the hardware (the SoC).
>> In general I would tend to avoid "processor" because not all CPUs in a
>> system necessarily have the same features, and some features require
>> hardware support beyond the CPU itself. Terminology is hard...
>>
>> Happy to replace "system" with "hardware" if that's clearer 🙂
> I think that "system" is too nebulous there, so I would prefer to see
> "hardware" instead.

Ack, will send a v2.

- Kevin

