Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7587D0D177
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 22:08:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A6926B0005; Wed,  7 Jan 2026 17:08:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 355276B0093; Wed,  7 Jan 2026 17:08:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22C166B0095; Wed,  7 Jan 2026 17:08:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0CBC86B0005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 17:08:41 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AD0F01B827
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 22:08:40 +0000 (UTC)
X-FDA: 84306558000.11.84D6064
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id C9F42A0011
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 22:08:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tRhx72pB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767823719; a=rsa-sha256;
	cv=none;
	b=VbXlEpxaNE1ISNJ2c+uSXp/Maj99H3OC83boW2yfGcD2X9drcZiItQ9E8OUlfg2YM7/mnU
	32cRqX5zE4zG1xXhba/0zsHLlZeUS/kzMigwCykb7AAaKb1bxtVGq+dMuVBoS0lE6pyuNY
	Fl7vJaZtN7ybreBe8i0kfrahKawE5ls=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tRhx72pB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767823719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Leg1NekVj34gHkDnfNWZo69lYGmnkkGlrerd3elLd1w=;
	b=2koKbYC1mCW7/WsQyfubnthyh8IaqPcE6lhCP/gR0ZxJQwfQtbCS+7S6UpgW1NyNbXUjsz
	0lBTB6x0D1BS19+oBTyrPYALXaz93r/gqobsXpyQ5CoOaYeeyrzxHxIq6eUX37EZOa/UJu
	gsLqGdzwhyiYrzqG5rHRZ9Lazy6+dEQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8994B403D8;
	Wed,  7 Jan 2026 22:08:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF4CC4CEF1;
	Wed,  7 Jan 2026 22:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767823717;
	bh=EcHgfTbO7t8VeiVyN3BO6yckGe86xkojloHqHLnPFn0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tRhx72pBwsDHXcMyUxJK2Z+HZ4xif+ezAPWVZHdUB2P2EiXRZMNhsX7UgckOW3NJR
	 qkfrP7Gtie3R9wpWE6N78gEWzDCRsmMBlMEPSpDy6l2m5jxeCz/zgcTkK7Sazda6wv
	 G+chKPR3nFMgYWaixGJ4y8EeJigzRPclEQJXv06L5Ya2HZlthHqrrE0hDHESbChvWs
	 Xc/4ZPAJqfvO9dzLPKuqVfqlFjiFUlcW+xRFNEF3PnRSLrLfqwHV2ycSZEuRsdYLcR
	 YJmBB+Xx7vcnESVGzF2OZaLnmrXpMtFWc4doGhEHD5lyGbqdq2Qu4TsnAY7q50W1WI
	 +eBuwKBGxcdFw==
Message-ID: <38c0fbaf-cbb1-4f43-9d45-31ca642d1ed6@kernel.org>
Date: Wed, 7 Jan 2026 23:08:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 3/8] highmem: introduce clear_user_highpages()
To: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
 raghavendra.kt@amd.com, chleroy@kernel.org, ioworker0@gmail.com,
 lizhe.67@bytedance.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20260107072009.1615991-1-ankur.a.arora@oracle.com>
 <20260107072009.1615991-4-ankur.a.arora@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260107072009.1615991-4-ankur.a.arora@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C9F42A0011
X-Stat-Signature: wi4foz1rbsikh97z1eui8sgcdpe6yb9j
X-Rspam-User: 
X-HE-Tag: 1767823718-513747
X-HE-Meta: U2FsdGVkX1/+Ro3aksAkwYfhJMMJrcO1oal98ztEQoi0LNpgOD5RhjCxukbTgVIlOrcn1URpGD7ofsVcZ9pu6a6D7Lt2yCRV/ucf8ycPADF+6q3UoZKs0iafJ18UwWpHU9nUqEv9LtP0okodjO12BYSzoamf9zyxm3ANohGCiA6h85hlp8wW1I2aSYRcYtEHFk397zTESfbjy074BASChiVEItgEKtRpzxsgTucy1Gu2N8oxWWcxeDuuqbjfpWhcslxEldtxeMS9WBzYbGOrUbxP/hQfbnGWfnx3/ut5IYbWTm6e+db6EiiEk//iboantwkYlLwuE6/6dFTFge0gydqC8v37pVF34PVOUwn2PzZl8xFZF7AXP4jAOzIsncjnrKN1xbeZ1jWgi89V/lfWEWzCEPJF/upMVd/cWX4QjRXTcXMPsMC5HIfgQjxermbDc+7kCgu/jvbnwAx+CMFXhVTyIZdXIms8zyOcHzIDsi7skr9YZ8mv81VlqeCTFEbeJT8BS3cx6E/7EuYb91DunnHLhW4QgJA5HTE63MZz60JawR4+4eysYKHXFu+UugdGTrlWiaJsbZtcx8KiADwNi8R7mbov5GA0/88YOCd3EZtKu+hHv5li1ixwI1Js4pT/b5MEdtDSQTYtKtO5mELV7wkWd1ci8lhRh2T45OVAL4Waaa4Cnwc/1H/ZWg8HTPn0JnWuykyhqocsAreTr7cPTp9ErcUvgXliYzRf9MYB/OoXHUxonBiVg2bhXucGyULGE0kd+I+5ORCCpiw9k2p4jVqISTmJXc1SqRK7NRBJwlHD5Ahjys9qesWSn0a1JxC1338fRZSJDvzs2x6xSwMRHeqHp1wv1fZxxznTjMtUTKbfywvSsXOq8hBmtfVgUcwdrAvYfG8AlBiLT8gb69dTI1lgZyO+tg8s0TALVpatYc9KkDqQXtQaXMXqw90oCSsfbwEzWJyQvw/JJHwWtc8
 u4AxynM1
 iZLm9mUGQCgAdMcciI2HVNbSOHazIpbv+HNl6d2PYpnGBtbJkP8+VrWyUrOoVoFdiMAhKXe9uO5rWCBHDKq8LZch6CuQ8rDWnyxDEz9Dye1h2dMZVBdCpSuQfHIscSR//gnF6SSrJGQ7vqP4HMJj41bWvEdBTfzpRDfZZ8rl4FgdaiucW5Tq/6n5NDCbP5cb4xjJw+8TQXwqFO+ypWSRLe1KqiITCxR3zAoAwKgCKPBLWV5E3uZ6yfodewIAyBN5DdE0wv5V4lpqQov1OqJr0STWFUizyhePy9xeCk5qXIZek91aIkGj6mJCEkg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/7/26 08:20, Ankur Arora wrote:
> Define clear_user_highpages() which uses the range clearing primitive,
> clear_user_pages(). We can safely use this when CONFIG_HIGHMEM is
> disabled and if the architecture does not have clear_user_highpage.
> 
> The first is needed to ensure that contiguous page ranges stay
> contiguous which precludes intermediate maps via HIGMEM.
> The second, because if the architecture has clear_user_highpage(),
> it likely needs flushing magic when clearing the page, magic that
> we aren't privy to.
> 
> For both of those cases, just fallback to a loop around
> clear_user_highpage().
> 
> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
> ---
>   include/linux/highmem.h | 45 ++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 44 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> index 019ab7d8c841..af03db851a1d 100644
> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -251,7 +251,14 @@ static inline void clear_user_pages(void *addr, unsigned long vaddr,
>   #endif
>   }
>   
> -/* when CONFIG_HIGHMEM is not set these will be plain clear/copy_page */
> +/**
> + * clear_user_highpage() - clear a page to be mapped to user space

Just a minor comment as I am skimming the patches: I recall kerneldoc 
does not require the "()" here. But I also recall that it doesn't hurt :)

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

