Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4485ED6ACDC
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 12:08:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 486436B0088; Thu, 18 Dec 2025 07:08:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 409586B0089; Thu, 18 Dec 2025 07:08:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30B556B008A; Thu, 18 Dec 2025 07:08:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 225F66B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:08:11 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BCFBA5D787
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:08:10 +0000 (UTC)
X-FDA: 84232468740.28.01ECE74
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id F3D0380016
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:08:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766059689; a=rsa-sha256;
	cv=none;
	b=R++O/oXQ5urhz0Lp6wDmzxcjVMUzY8dYjw533UlZ65IU1TcTuQYWcWsfRlx4VAdRKAZP14
	RVyKGQZQdJULEM8gUnVx27yCcPTARjgPrEgP+fDyactFYTdJCe3etrNtS/tG5G6fKkM/iW
	R4O1k4lNoMWVyta5VRlnEPXWKobfEic=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766059689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RfTnXPfQhUsErotz7Q75pjApwiZhopPstmmgc52ak6Y=;
	b=5JwK0wihP5B85HBKqU60rT0zY6aEA16tQwIsEm6usG7P98dHDQOPsMFHIkfnhPAZUN292w
	a5bPZl8f1vVhZ74eSTMJMoifVbnoudXbOtKcAN6wHEISpx52KtWTLln1pNwRj2Pkcyc6Kk
	Q350OMAqnJc4eJOTvXlDoZfb2Tg4FIc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CC3CBFEC;
	Thu, 18 Dec 2025 04:08:00 -0800 (PST)
Received: from [10.1.39.180] (unknown [10.1.39.180])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 418C33F762;
	Thu, 18 Dec 2025 04:08:05 -0800 (PST)
Message-ID: <0caffb55-f242-4b01-b60a-c8749aadf661@arm.com>
Date: Thu, 18 Dec 2025 12:08:03 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm: rmap: support batched checks of the references
 for large folios
Content-Language: en-GB
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 david@kernel.org, catalin.marinas@arm.com, will@kernel.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 baohua@kernel.org, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1765439380.git.baolin.wang@linux.alibaba.com>
 <545dba5e899634bc6c8ca782417d16fef3bd049f.1765439381.git.baolin.wang@linux.alibaba.com>
 <cb4d7243-d8c6-4706-a254-6f5afc148910@arm.com>
 <89cdd927-fc88-42cf-b8a1-2fbd736d5f7c@linux.alibaba.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <89cdd927-fc88-42cf-b8a1-2fbd736d5f7c@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F3D0380016
X-Rspamd-Server: rspam03
X-Stat-Signature: ch1wu98ztgyhusqgfqdocc11yowrgx3a
X-Rspam-User: 
X-HE-Tag: 1766059688-955017
X-HE-Meta: U2FsdGVkX1+2YV3lo/eGxTrCEtl4+W3bbC6KMExKHg56jpREp4qhq4Wus5f0I/HobBfR+V28cI7kfusg8PfI4HlAu/ZBQU8wPLj/HDO4axtPH9Qu100Yu21ZfsPsl59T/kPS8OkS0vLrtsmEpr3SfS9oZOiaxVgKhOC2N2dOpM9h6IFCTe5LZaoyGI8OgqxlPq+zg5gSxto4dL5HaqEDNEr45xfG0xCDgHnlg9diMhho2d4yDyfMZrjB9BFw7Rr2lEOPGr3wibR1/3GJoIp+Ykk2WtUu6uPt4dKz29f3q22rMOXehhyWE0B89sUw0eSzaNYoLr2gbSJ9jobzPBGC0YXeSy7fG+22l+vINsmpDMPxCqqsSe0lqRllTqLgkbQ3FLyETqW/mmqx67EyWqHArnY9qTUvpAuEeaqhK4K39CqaYZsrs0vZQVTUY+oYH3CM148jE1AW9CKdE+RXFPKt/xceAeQz704BdKGcC35UcvwQf2jzxCXQm0PZ1+420/Pb8Rmj8pErGcZqBSe/2WK/4oO1qMMAsP6ydPfU7sZa/qxjWQrf5JHJRFsp4VUm9Xn82SFpPAGewCnz5MhbNsO7enyqjmnZb7FEdrFfBLwLLYtpzF8HyFDQWvAVz3ce4mdA0L+k+6ABcGGH+ULAvdr7xrdnr+61ThOf4/PP+6gqVwY5fh9hIDa5jPTUvuSdd/PdnKvFY8IeHTIfnqPmd9o4EoHlRu8Mw2fH8Hm8Npo2DLdEbR9O9JuvwYiq6P1SFFPVf4e21Z4elg1RLtR4XXR/oxHTmVxjwaUnwpSu3PEywstPpMAH3C8Ac81B+cuemItDF2PrxyxHgK6Ny6023jJsAXGJ+YZobphMeXrGTWLkKCzqyU/OXmoot3ddQnrOrJm8Wxq8nDERj9NeVsvHntqj/cztZIRNYC4HSR4e3VGZ48SrN5sZSxHNYzkGp6TUDGTA5AIM17z5p8evmfGoN4L
 kVoVjqLQ
 /Q+Bud8Y6Sg/z2/aQknslrr9BmiMjfr1oraBZS1Kl8HmdgX9JFmTdlPyoy8i6pKxJ6yFYOh6vj3ZQvlx4W9mMsYDUYxlXlRyZ8+LaB0/lgAtDJ2d7URGVqyNaJGe/O/sYIaXM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>>   +#define clear_flush_young_ptes clear_flush_young_ptes
>>> +static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
>>> +                    unsigned long addr, pte_t *ptep,
>>> +                    unsigned int nr)
>>> +{
>>> +    if (likely(nr == 1))
>>> +        return __ptep_clear_flush_young(vma, addr, ptep);
>>
>> Bug: This is broken if core-mm tries to call this for nr=1 on a pte that is part
>> of a contpte mapping.
>>
>> The similar fastpaths are here to prevent regressing the common small folio case.
> 
> Thanks for catching this. I had considered this before, but I still missed it.
> 
>> I guess here the best approach is (note no leading underscores):
>>
>>     if (likely(nr == 1))
>>         return ptep_clear_flush_young(vma, addr, ptep);
> 
> However, I prefer to use pte_cont() to check it. Later, I plan to clean up the
> ptep_clear_flush_young().
> 
>     if (nr == 1 && !pte_cont(__ptep_get(ptep))
>         return __ptep_clear_flush_young(vma, addr, ptep);

Sure. That would follow the pattern in clear_young_dirty_ptes(). Please use the
likely() hint as is done everywhere else:

	if (likely(nr == 1 && !pte_cont(__ptep_get(ptep))))

I notice that ptep_test_and_clear_young() and ptep_clear_flush_young() are both
testing aginst pte_valid_cont(). These could probably be relaxed to pte_cont()
since it is implicit the the pte must be valid?


