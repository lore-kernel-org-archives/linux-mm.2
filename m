Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F801D6CFBE
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 04:20:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 913456B0393; Thu, 22 Jan 2026 23:20:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C0926B0394; Thu, 22 Jan 2026 23:20:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BF6B6B0395; Thu, 22 Jan 2026 23:20:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 69B126B0393
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 23:20:08 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D39B7140870
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 23:31:42 +0000 (UTC)
X-FDA: 84361199244.09.54BDF89
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 196CC1C000A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 23:31:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U+pzm2ze;
	spf=pass (imf21.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769124701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f2xfRaWuJSSu/H1wc5EyKSsx9LhshToIepSHREPP7ao=;
	b=leneo6Wd15Wlwt126XMRs956msEuhq8FB8uwR3zQR9J+48OqYy9pdLLAqCshdo8y9eRTM6
	n3tVNA2p4c+803KytSOD8wjJC1pUQFsC0gczFoaQrGC/oYrkwYNjjl330GPqSc9OotJR8s
	U8jP/GZ8xP62aJGYYU+fFy8/6erVNAI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U+pzm2ze;
	spf=pass (imf21.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769124701; a=rsa-sha256;
	cv=none;
	b=xBlFV8D1fwyxvHhhTqdyoDx0MxQFhk6LFLaQW2BeruO0D1R2NhckApguvPgNSFbKtNDUXD
	guNPgAJwkUmdHTAmLPc4/amZYzE4Hde3HaYWEOD0dxBPMafY3EZZjbwmjiQHL73z2QoJX0
	lelT0U1f2a3lK7S84WLBDoaXjmVgvJY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1E154402A4;
	Thu, 22 Jan 2026 23:31:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07474C116C6;
	Thu, 22 Jan 2026 23:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769124700;
	bh=BraoVxjqtM39ShAuBBrmxXx6clK6QpGFDz4TP8y9rVU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=U+pzm2zerVGXkyEmK/6NB+pBVJgsnVHTyAWZxcwfcdBplO6NXVD1MUCFxGUwxI7k5
	 6aB4Dj6YCvwXguGMt5YGR6KR1Itrl1enoPhaygPFZRS4OhAN+MNhi/GOxq5QZoSVo6
	 +XadsAO2f8K+x+WAhtcw/sXIdtTBqR13LLMw7lftDgMqvtsVQJEJfZGITGtJKn6y7C
	 9EiKdgbmxGC3WqTGzWrPATrht5NzP70AGBuMhymtN28Cx3Jj9itG1Fz1jPKghGdgMK
	 sQ0hfj6EhgPbVxkYrS+kddQMW30jLoMs5bLzgLxDxvdGd1T7bAZaUCvEMunwLeYuk4
	 HzIW5dUWSj8hQ==
Message-ID: <fdced796-3061-4717-bb7c-e579ed07f490@kernel.org>
Date: Fri, 23 Jan 2026 10:31:36 +1100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/13] mm: update all remaining mmap_prepare users to
 use vma_flags_t
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <cover.1769097829.git.lorenzo.stoakes@oracle.com>
 <fb1f55323799f09fe6a36865b31550c9ec67c225.1769097829.git.lorenzo.stoakes@oracle.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <fb1f55323799f09fe6a36865b31550c9ec67c225.1769097829.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: 6ar51wz3m7rcnwwpkqpwciqcjrxmxaob
X-Rspam-User: 
X-Rspamd-Queue-Id: 196CC1C000A
X-HE-Tag: 1769124700-499229
X-HE-Meta: U2FsdGVkX1+fvgYc2Tw7g84rbyvHVHIxJoKwHBsE//tpZx8isAyEEMbT25oEvWRnhReJwdz+kxfubCeroxeOz167gcCufgzCyg+7N9AQ5ldywEbOGtzNhm8Z8ac0HKPe3qGmrbqkh5FPi5fZHJJE45VLIP8QsMioAJssNAy7nRZoXBQj7SFrleAmfIlsjAhx52JJsl4iugmC3hL6rByjuXR536KRetn3yq7qzZTW/BKXHlAqT1Ff3u/6aefLQ/4f9aeymqUVfPCGwTMe4gTJpHEcmXqR+42t7VAcpAdxi6CZJoXlMZVVDfWNygVbxPdcPCDuHBcQfXuFcqZIhWtqgPx+K0+N7fupARhARm0jne+3I7D8cjC0eVGATOtwrkQnu5RXrcTPgjuHLsseehMBNe4EPq+p80t/sCeEadJ6M97vbbKZySgnlT5U7p86i4E7kr9p2c4uXoTYX6NvlEdDLxnyWo0uhRdhCIz5bCEJSbwgKyKXgyeiK8I5oV4JI+ZZRj7w/8InZDZlN1/ckST9yi7R3lZ2D/zaFYau8jPY1ctwFdqMv++vyd1JCTitcEtATn3Uxk5L19w5K0UfGp4hB+mCQw69Sb2cAgw8t1ju/jbWtLdp79rzQkN9oJjJckFBhgA5rt5TmR9Re/n9Dgg8RW8+n1k0WIyMDl0xnHYTEBvOG/Ykyl7wm2ssfB58lL7qBdwNoDz0I1+yU84Ku2CA4ogBe2KAACGK4wleBP6a2MW2KoR5rdGuN4ZjYo0vOMg1aF2F5RF1S8bSnu08EDYml42OAuBWXG2XgL70ql3CfUh6o6XTURlNVKvZV1+gsGWlUuEYxVhUixFN0ilf675b9Gn+iQttl+jrKmuUuYacdIiY7gxAlLyfoYPZVRtiuK1JiJkFtB/nT+OLrbJ3N1NzNx3E/tc4dWHwo8Ou7lRo4H+ke4kQbw8IVqF/U2SsawTbPWjVi1aXVCv4/W89tek
 es/Qp3f7
 qhx3tu5fJbl6rdGkbzrjr+wSvFG+gxqcWLx7sQj0QL453LfBV4LmM0ltz2gcBr/50laUVNaLfwKAgOImsce4DsyQ9iQHAO/Mpzr3zo/MpqwJjSaAc0S9XoU962FIEg11wonyO8W2+YKeMwTdTUa5NQfUOF2py3t0SF03Q32OzBOcxMkFZJIi21rKaXvza1T4mFNxWLN8XL7j4ihvwUPlsEYFJ8iErnrEBLrUKGK+HVNAt3P14kxYJ4E4lSBnjFkHrZHbv8QF2K1jK1xrrgx0Aei7E1oSC0JpEJDiNT97HQv9l7UkJ5W44xvKNlqZFAYEiZYbxBUICB6owMI18lwic/gEk7JhaHTwU0T/ebzdBjNe/RapcBzN0Mx9F0+UiWVVYow2ZlguRp485HWDgimxIH74zKIsREFcQIlS/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/01/23 3:06, Lorenzo Stoakes wrote:
> We will be shortly removing the vm_flags_t field from vm_area_desc so we
> need to update all mmap_prepare users to only use the dessc->vma_flags
> field.
> 
> This patch achieves that and makes all ancillary changes required to make
> this possible.
> 
> This lays the groundwork for future work to eliminate the use of vm_flags_t
> in vm_area_desc altogether and more broadly throughout the kernel.
> 
> While we're here, we take the opportunity to replace VM_REMAP_FLAGS with
> VMA_REMAP_FLAGS, the vma_flags_t equivalent.
> 
> No functional changes intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

(reduced distribution list)

For zonefs changes:

Acked-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

