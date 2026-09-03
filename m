Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0265EC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 16:48:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31F616B0096; Thu,  3 Sep 2026 12:48:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 282656B0095; Thu,  3 Sep 2026 12:48:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D4A26B0096; Thu,  3 Sep 2026 12:48:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB9FC6B0092
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:48:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E3BBC120531
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 16:41:45 +0000 (UTC)
X-FDA: 85173017370.12.451AD1B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0499E40004
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 16:41:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JRoxl9E+;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788453704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RYA4JnxbTf0JCzdYr9ZqvkjonlZytGF2uNItx0EAGxw=;
	b=6Vhz9tOny09BIEI8AV7RMlkxpNbNMLGvfF3edd2U4GtY3zwz8u13jjs3fVF7qihGVDA51Y
	zkBfipWrNJc2Hu34l+U+TjfOhishENw/4Z/CHKHQa4Yv9mglehq33VuK0r7Yei72K2p8QX
	b+aGo8fzUexbCMlNSodJsJioP8BYu4E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JRoxl9E+;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788453704;
	b=g6f5c90sB8e73NLizp8Zv7ii1HjcNkB5AyaaVQfWWjbZsv6VkFuO2moWRPX03JuJmMXgLW
	rc8pDmSV6OpYAIcLsvTy4FAcvrnz1eB9Hk8Wa+jp9bzkBGtPjnb2R2UiC++OvssvIk6wM8
	IBZNOqKBKcv+WXrJt3nkDyNMjsvCTl4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0F4E81596;
	Thu,  3 Sep 2026 09:41:39 -0700 (PDT)
Received: from [10.57.6.2] (unknown [10.57.6.2])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B9A193F673;
	Thu,  3 Sep 2026 09:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788453702; bh=fMTmPuGTue6HNbPKyeiunkqMe/FTnn9ZFj8qnYLsnh4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JRoxl9E+QrX+IO3atrSghjI9x/qg48SBeUoB1iHXHkCx7rak+q7DUoHyAtcB2PWYV
	 hmycgMaqDchkjeaR2c2OvTp7h462MRv11iGZ4k/gz8RFYH0JjEvEaYuMwxBYfLXZdP
	 a/vAsnGfvbfQ8np3IkFUOQE1xCeEA50NtIZsQ9qE=
Message-ID: <66270f42-931f-4043-b24c-edcc4cad74b8@arm.com>
Date: Thu, 3 Sep 2026 18:41:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v9 02/25] set_memory: Introduce set_memory_pkey() stub
To: Linu Cherian <linu.cherian@arm.com>
Cc: linux-hardening@vger.kernel.org, Andrew Morton
 <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
 <20260818-kpkeys-v9-2-743ad31b2c8f@arm.com>
 <apbiQtt-cAlLkDqV@a079125.arm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <apbiQtt-cAlLkDqV@a079125.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 44rz8nip7o1ccmpnnbxcprs5og81gipu
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0499E40004
X-Rspam-User: 
X-HE-Tag: 1788453703-88848
X-HE-Meta: U2FsdGVkX1+jqfB5y75+q2iGfWOra2O+1C0TKu6pkbI+2DjVOB2lxFSuozk+eAHcOrSnplwAHdHbiLf76UgFpOhUXCIQmXd3D5otrM27QDgiTaJmyHeKdQLy6vzGz+29reoX5R3mBNcOUBjB0Cn8rlNNJOZuKB/RVUx6cv4jXwgPt9Yq+S8W+WYMqAJzZpCyQ2l5C90UZMeZbvcmuYIIhkCVzjHCYRcNaWAKJQKQYk0vDhZPeRIQ+/T6XAurfcFGjZi7ZgV0ZtPDF8UAPs//3WmxDGsQy6f62chScFLLR1YukTckAFfoAqgmMzLZ9sEk1rMpj7poGFQ1FxDycn0JRFQ7C9oB0a+Lj5XOlBwUQoPtWRYu7txGAJwChycLuWCnpgrfRA/lk+Mo3NktYrZRfDBcxL776SwFqoHCGhpUB7kI/TSQNP7paI9gcjv+RCYU0l+nPGdS/jJzlgTCtYH6SYtcOmuBFheY8gv5sWF3O0qFN9/N6LC8EKOTAKpi08aHSPdzsypU7zsNvLjdnFhNUgqVwezYeKxc7J6d9aHjNIjBK2ZgHyzzaFo6Srs7OQzl7bmUnvPAxjTqtd8u6rak+vYCJmrI7hTI+Gogr8z5CRbnEmGGu1JVaXxbBxlKqOejYSgRXNeZGnI155hcs84muWdq22lHeX3UA7z2FvQxQXJPx99oLXcV906vl0U5Z+9Htoc5+JeMMVGMPp9pMMmbUEZe4QgWxePARvAukiPX4GxoKEjpz6+jKQSxOCB4VeyiGhgr/idRRP6BoYoLPMziAr+3k44JLO5woNAVYmqrgNiykyLBsQSvG/YL0ODzvnBm9oKrspSMlg0YZopsrGrieAYDdm0y4oLFrlNf1Qna8ANRHkfsxkP8CM5xwhzaNmAeSiPNq/71Z0zyJBkpdlQTIA3hJP8qDf9rI2VZCsdU9Snzc7ZVMVq+E+YnPhikzXsQy4+2EX3r1f2JFaBshuV
 P5hHe3/2
 /7nco76/JGPIDa9X7fpJhxU29kiqAWhzdY+BhdNDIJuc+nCG4+kg7B80W1VlvQXyA3K2rzUaLEvlwzQZi9oGb2KsH+LoAPGvgtASwi9X4lc3WQ84oOBGbVugLUhvWfSDaD55AQGL3bbFrt/j+HQAU/8dkSwMudejzzSpLXD8MTZpdE1j1lsXph1Y456oq/EpLbVuK+QoOqffmwbIMdg9CGHzr+2CIamlecbWGbDSpxwKFSXp1GOo6bxvDQTEu8YpjrrnhXekVQjrhr4DiM5dC01NPMOy8Up5YfFaWbFydahbZMkZMsvDsKibF/5+JvDwLbnm9ArSFD6sATGGVyy0SwTrSzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01/09/2026 16:33, Linu Cherian wrote:
> Kevin,
>
> On Tue, Aug 18, 2026 at 03:08:44PM +0100, Kevin Brodsky wrote:
>> Introduce a new function, set_memory_pkey(), which sets the
>> protection key (pkey) of pages in the specified linear mapping
>> range. Architectures implementing kernel pkeys (kpkeys) must
>> provide a suitable implementation; an empty stub is added as
> Could you make it explicit here why we are restricting this only
> to the linear mapping range ? Would be helpful to add the reasoning
> in the commit message and as comments.
>
> Essentially we are also making a assumption here that there are no
> aliases to the linear map ?

We're not assuming this, this function is called on pages that are also
mapped as part of the kernel image. But indeed it ignores aliases,
unlike e.g. set_memory_ro(). Really its name is wrong as discussed below.

>> fallback.
>>
>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> ---
>>  include/linux/set_memory.h | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
>> index 3030d9245f5a..7b3a8bfde3c6 100644
>> --- a/include/linux/set_memory.h
>> +++ b/include/linux/set_memory.h
>> @@ -84,4 +84,11 @@ static inline int set_memory_decrypted(unsigned long addr, int numpages)
>>  }
>>  #endif /* CONFIG_ARCH_HAS_MEM_ENCRYPT */
>>  
>> +#ifndef CONFIG_ARCH_HAS_KPKEYS
>> +static inline int set_memory_pkey(unsigned long addr, int numpages, int pkey)
>> +{
>> +	return 0;
>> +}
>> +#endif
> Would be better to make this (linar map range)constraint on the API name or that passed
> as a boolean flag ?

Indeed, in fact I've been thinking about renaming this function for a
while and I've already done it locally :) It'll be set_direct_map_pkey()
in the next version.

> Also, it would be better to have the __is_lm_address checks in this generic wrapper which
> then calls arch_set_memory_pkey ?

That's not unreasonable, but such pattern isn't used by other functions
in set_memory.h and I'd rather not deviate too much without a good reason.

- Kevin

