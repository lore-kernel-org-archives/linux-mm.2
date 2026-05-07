Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85450CD3436
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 03:24:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54D0B6B0088; Wed,  6 May 2026 23:24:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52B1C6B008A; Wed,  6 May 2026 23:24:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43B166B008C; Wed,  6 May 2026 23:24:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3517F6B0088
	for <linux-mm@kvack.org>; Wed,  6 May 2026 23:24:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8EA781C0E05
	for <linux-mm@kvack.org>; Thu,  7 May 2026 03:24:26 +0000 (UTC)
X-FDA: 84739180932.13.B453147
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf05.hostedemail.com (Postfix) with ESMTP id CAEDA100002
	for <linux-mm@kvack.org>; Thu,  7 May 2026 03:24:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=aNHs7Gpg;
	spf=none (imf05.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778124264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uosM+lXd9uy3S524rPCNXAcNFz9sYtM1V3K+35pNSWY=;
	b=UaY5W1SVoCt0FTKDYzAP8HaLeINHZIo0uoGVu1Qha4zLR2iC0hQUOkYfoHEz2RwP9S3yHa
	/kZeA3UhfC4K3RfrKSG/itnsVROLKOyBZT+P/mKWiZh1Ei9EhjpBxe5hXhI7pAr6uynx4m
	7w0rrB27biaicaoIZdB28frZ5QAeRL0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778124264; a=rsa-sha256;
	cv=none;
	b=v4Db2leQ+WBxzRCBkbphiyZphgt4joDuCE87jmtAkH78cCylNu/7SVaidsahLbn+XFtmun
	SXnTQaVDrTNmf7G3r4zM2rahnaQMT6e0RC3Mn9Sr0ZByOm9QZeSgCv/4iH7YuhCgU6Yvj2
	Hwr0dMPuxeQPwe4yLrQ4/MV0rij/5No=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=aNHs7Gpg;
	spf=none (imf05.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uosM+lXd9uy3S524rPCNXAcNFz9sYtM1V3K+35pNSWY=; b=aNHs7Gpg+8TMfkMF/G4/YKqYj9
	aJk6/6cy1rR91AC/Fu5mg1mR6A7idk6YunVP9Lw1zlSZMk6PZEHOjVU0UTFOyDZkaaLBOGdbulE3T
	sxNaX64fI2A1jVDCm6uHZdIT2c8C4mWUZ0KI4O5PPvtgnCOLqkVs4fpUDkxd64SXBDFLH8A6VATyz
	81aw8N76AIuEeWH1RMOVFOE4VohAdV8BpyTVmj9X+Jb5O8lkuXevnmRCKdTeR+AfWRz3IFNoysAEQ
	8/K9YcHmsJkmP1lBxj1OkeXFbtDPabeo+dBzNPEocSGuytEea8zPBCjVbHDLj/T/rIa6IBz+QqGzG
	YPAiknig==;
Received: from [213.147.98.98] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wKpLZ-00000002csG-1oyb;
	Thu, 07 May 2026 03:24:21 +0000
Date: Thu, 7 May 2026 05:24:11 +0200
From: "Liam R. Howlett" <liam@infradead.org>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Ballance <andrewjballance@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH 2/2] Documentation: maple_tree: Clarify behavior when
 using reserved values
Message-ID: <5qnwgdcxqat2zo5qe7qy63xm5awo5l4lkdkf4umbj3sl2ct5sj@v5c3szzdbbq3>
References: <20260504165746.1422057-1-weilin.chang@arm.com>
 <20260504165746.1422057-3-weilin.chang@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260504165746.1422057-3-weilin.chang@arm.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CAEDA100002
X-Stat-Signature: utdu9hfpabmt1uqtsrg4tumndd4ik4co
X-Rspam-User: 
X-HE-Tag: 1778124263-949415
X-HE-Meta: U2FsdGVkX1/GTYLzY6u+/m55EbO7LZ9IL5otHxJ/Wib3I/aP7dhswiQZr2TaPb/b5BHNAxAuNTVLusu5y8LoHnRo/Xj+tf8xM/AhRYkQXfbcINphU3um1gDgfOq/J8XfJT4kjglF8u0xkZJWjR6lCnVIrGZSEzG10Lyf26qdM7BSL/i39xGdtlSjSbHSRTl8m2TirtlcjLKHogcQbcbFRGRITdwKlcvOj0SIpRGOAqYyKNSZX+khtGQuRJrYkbu3Br7p+I74MnvrKu5PO8XuYJP5Pja9t0l1zC4924fedHpdJQoz4BJ56f/8E9bdp+aZHIXK5aKPk1AeZQB0QJvY2iSBqYs4IeUaQgHg+Nx/lPfd7NqShrqdb6+uvwX8kyRcnvNetHBaYhkNiNAGZqxK5PKfptaZXWMVXvXclFgWSawZ33CJQ9HQJJ35qSNJeOT4GvoEuL10iteVUFSkRRvGZzoygSWoKlqu1yXjF0p6KY+vjAiP5xKw00X4J3Jjj8s+9w6QcB74ks0SXoJUV1vPk2nP2RQFpY0CfmrFhny0vkaX1zEKlYVA3JIun2oVipUPGk+3IIebf4lNLms6K3ZPZ8d/SKujbWtR8OvdK6olgByYBugp/ra8A//PIG/jrQOjuiZ6OTKOMoBHcFmC10V1gp6hhRX2BSnanD5H2CS+FsOXrf7SHikz+ZL+anL4MeJOAeOzu9HyIqIHgEbJQffu7tP1UoHF4KvVawelAy++7B1vZILATRjui+Ha2Kg4u0AWm+sbruvw7jSca2TrwGwHsrv15GO94C6xYSVG6ADMaeGBKoeXnP5afzDVP38ehSrIDeWtZuBjcjmz+3uA27GMwjpfmxMmbymtxl81sR+9pCGMBqkfkVIZZmLIMeSdjy7ynfh5LwxoW6WdCmsE0F3KSJN4HLXkOw3aADVag6Fgc7MCR9WiO8mvAeuSmR6wBe6Qwuux/mOvUSzedMhOSjH
 tEKcQ75u
 GJBuSDs9MevYrsX9yUnNXZtOjf0KiYUM0jWaMPr54DJdt85UPTIXaPz8OGORsZMzuxtdUOgGw8Q1nfpocl2H+UZSzb3G+cDb7VnEeLDTZEfXKTsXFZkeQGN54QrKdJahx1fDHITfvvaDNKiQTm9+bS9Q0lUOgx/UCQON+Lt9FedT+HN/UypjAq9eMp+J63bOJpBnVXwA9afFY4/W8IqrxiwuHksCYqkQaZU9k5fwfdpdRj8wW23LUi0WA9IDvp5xlhdq7SbpmWWa60VoS2hrVw+02ZYZsPefdrkE4FPyDjMxl4RSHySZs3GAh4IS+T30C/8Ex63m2N8DU7yQLWUUpBfTz4/RIDDZJHrtmnF+s3spev5c9pZtWpK7G8sSzEy++68PStJv5mqRrE3FWanUlmXuAgeSOf6NPDhuxNyzS0lAX+nfRTytZX5bKRZjG8XNG1IWS9nMZtnf8+GQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/05/04 05:57PM, Wei-Lin Chang wrote:
> It doesn't matter whether the normal or the advanced API is used if the
> user uses xa_{mk, to}_value when storing and retrieving the values. Just
> specify that the normal API blocks usages of reserved values while the
> advanced API does not.

Your comment above is incorrect.

The normal API will filter out reserved values on return while the
advanced API will return whatever is stored there regardless of the
value.

Meaning, if you store a reserved value with the advanced API, it will
not be returned by the normal API.

> 
> Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
> ---
>  Documentation/core-api/maple_tree.rst | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/core-api/maple_tree.rst b/Documentation/core-api/maple_tree.rst
> index 87020a30ba69..e5ccafb84804 100644
> --- a/Documentation/core-api/maple_tree.rst
> +++ b/Documentation/core-api/maple_tree.rst
> @@ -30,9 +30,9 @@ Tree reserves values with the bottom two bits set to '10' which are below 4096
>  (ie 2, 6, 10 .. 4094) for internal use.  If the entries may use reserved
>  entries then the users can convert the entries using xa_mk_value() and convert
>  them back by calling xa_to_value().  Note that xa_{mk, to}_value() bit shifts
> -the given data, so the top bit will be lost.  If the user needs to use a
> -reserved value, then the user can convert the value when using the
> -:ref:`maple-tree-advanced-api`, but are blocked by the normal API.
> +the given data, so the top bit will be lost.  Usage of reserved values is
> +blocked by the normal API, and will cause undefined behavior if used with the
> +:ref:`maple-tree-advanced-api`.

Which behaviour is undefined?

>  
>  The Maple Tree can also be configured to support searching for a gap of a given
>  size (or larger).
> -- 
> 2.43.0
> 
> 
> -- 
> maple-tree mailing list
> maple-tree@lists.infradead.org
> https://lists.infradead.org/mailman/listinfo/maple-tree

