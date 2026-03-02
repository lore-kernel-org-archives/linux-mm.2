Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC2A5EB362E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 19:08:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 511606B0005; Mon,  2 Mar 2026 14:08:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BB9B6B0088; Mon,  2 Mar 2026 14:08:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C7C86B0089; Mon,  2 Mar 2026 14:08:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 294386B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:08:20 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CD0AA13A4C2
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:08:19 +0000 (UTC)
X-FDA: 84502058718.28.5D6D83B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id E3FAD40004
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:08:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jG3eTvVT;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772478498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=axQeEkte2SVtG8Zg9HRc+/PMzN1ZtyCc6FntzVb2mPE=;
	b=KQm0Fo9Q6iX6kz6sqi3KDWQ+YKIP0Etx2+Ja6NpV0XnGxzuTo+NnAOtweT1Mq14r4HYSNU
	x0cGePCvUGOglbM4+2MC09B0fXNwNfxlWbLffVIdrbXceZ5mn+3rIr/gSDvYk1fXoIZjB+
	izu6MMgOqlys5eV/eDeUcsro46b1s4U=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jG3eTvVT;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772478498; a=rsa-sha256;
	cv=none;
	b=L3xgLy7m/l+bIV3zqw50+5oWIvQ0+/pwCqzLMLFGqAwlGw9LCE8jbiwCMsF0IJJnfbhMQd
	Q+8OqDPdbBBqHPv9cvosQtoUrpKzlNgxxjri6qlY0eOjYoPuqUkEZqKPDNLM+7RkfdgGBD
	BjV4ykup/1kX52CvBmWE6Q+US62Fpjs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9804C4021A;
	Mon,  2 Mar 2026 19:08:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BADC19425;
	Mon,  2 Mar 2026 19:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772478496;
	bh=3JXvH4oSMURopXr7jJq1ghSNhKaWWIudYsUQYYkmulE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jG3eTvVT5YX9l2V2Cv/KhMbWoHg5K7BayaSKlflwZVrDtyzpOqmr798uMpffHaVkW
	 t+sGh8nF63T53/62Y3WwM5C0wCnJaCCWZK8uyzAedFiuCWpAKXg6CVNC7gJtKMKlqq
	 gdW74oN/TV1drOtNakxMLWHUUhlYkkb/Aex4KXHUwHZbpmmfbtam+qnn1JiFbNJpAg
	 YE1sZ+J7lckqrJfwKKxqhIbMhDX3Tbid0IpiRYfTHahXNzFFDImESMDGSVd2c/zd44
	 K2hgK9R1iDUCuxrt+OgHRkrOTE97G2DgpB3KSRTVXRr4o7d6JpI8p/UqAziMz69+Lw
	 +slj5QIb/aheA==
Message-ID: <d0caf165-8d07-4d20-840f-eadfd7e7c238@kernel.org>
Date: Mon, 2 Mar 2026 20:08:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm/huge_memory: Prevent huge zeropage refcount
 corruption in PMD move
To: Matthew Wilcox <willy@infradead.org>
Cc: Chris Down <chris@chrisdown.name>,
 Andrew Morton <akpm@linux-foundation.org>, kernel-team@fb.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <aaBVz7eb6-VBCvaz@chrisdown.name>
 <6147cf80-9d02-4c5c-ab81-8cb9b00044f0@kernel.org>
 <aaXL6oJamjnfhh5d@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aaXL6oJamjnfhh5d@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E3FAD40004
X-Rspamd-Server: rspam07
X-Stat-Signature: zx6ibjc8eg9ygr4ag9srh5u4h7xpwiwf
X-Rspam-User: 
X-HE-Tag: 1772478497-623733
X-HE-Meta: U2FsdGVkX18DEBQ63Yno7SSEStz2QshOcCtwaD3gsJ3LbhiFPgXI5t96/TWcbEyieGxWBpgTOEJH33HFKqJT5qrsULlCb7YmBmS3RAnnMFy+YtxDFsM/cwjMM/HRDeZQIuPR6cy684JSnaOM8gcLIzTDtlRJGzzE9qoYUTGl26BEB0aZzxfENWZZLSi+PF++I3RYmQKme4sEAB6H/ENvSJiC21Jpf0OxTy2ot7QiZjSxSVzEVTY8awOjq/uTfF/SZ7lYAvC+xGqqxhD/Dby+xgVetqyXl+oW59SbG96DHBgMvRGSB9jhVH5U/ehBYVPk4amxjf2gvWyC5M87/MtNOE9e3hwRXOr1P4+kdIwRl7k1Fp5ycCLKVQQDQzCrR5l56rZ3XIJHoPceNqX/6dZIgaoeXVaBT9UPnPbdd/JLKCk+eDNPKpL0fKXMLHfDE+p8GpWsE/6EJHszcRW3DZHKYJIx8vtQy9qEcgBWzjC0csSt1mt67iIjeMlUWv1UAm0GC+CsVlXU+JNMF6mjVLfEHBR6bjHFsDkw2jlb+R1ZDQZPFEKQdZy+Sh3BF37aMGxdFxm2cUI8AcDeIRZGBF54aZr84Ye/0bkzO+h1T2hQayE1ro1Nwg9xkwhOmBuffQYUTWiLaxwzzbl/K3lOOV0VbB3AxVHWuJ7aKyBAVEZejsPObs6kLAhR32/r0Vb/eyjbXc74a0EAqeAxwKCRamwfffYVhhVJZeGcdeawr5Nw3r37+yidO6s+xiMc64QWmxozoccRwqCn7aDfDX5KSosp09ErkAnJkU2uck9kdnsbMJFhYPReNJ5kFqctvs1p0K0TIgqoQAVNRIoUfpd5Ebl8O47R+6tT7FhhOF2OlvmL2Gfjhn2FcNNPm2fQWsV1p4gzjfljhE7Wxy4Vs/zjlMOez/H8OzF0BKO2JZV4+4LrlKQ3Uf4qZaIVwzn23q7JBXGlYjDVdyLYOnRiX6LuJFD
 qUo/bmsI
 xVhCbECxNrZhxW94jqFeRUuTK2bjvC73GswJp4qfeZqTZiaUoYy+48SMZSRkGywga6B7Wm3A8pBAgPAlcAWkDQWIm7QnpL6PzRkIq67oCUVNxPoT4uLtskTzK60acOOrq/xlCrELi3lAca0EV0L1LFsq7g5msXGCy4gIuZPRyAYqK5sYnWQN1YJizZwiYAhUvtBqIbssE+ocfM9ue/S/IMLKXKRWxF5T56iuoIfq3VIwfdzdfPLRVg5QO1if3uZUWcX9zo2gM/no46QVP83pANf1DTSZipCUKbutQsEe3IlZMZm0GWPll6yT8PQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/2/26 18:42, Matthew Wilcox wrote:
> On Thu, Feb 26, 2026 at 04:17:31PM +0100, David Hildenbrand (Arm) wrote:
>> It doesn't make sense to leave something partially fixed in #1. It's
>> been completely broken from the start. folio_mk_pmd() should never have
>> been used.
> 
> ... mk_huge_pmd() should never have been used ;-)

Heh, yes!

You made me grep for it and find some leftovers:

arch/powerpc/mm/book3s64/pgtable.c: * pmd_mkhuge() and mk_huge_pmd()
when we update all the

Anybody fancy sending a cleanup? :)

-- 
Cheers,

David

