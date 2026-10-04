Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31EAACA5FCE
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 19:35:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B11C16B0088; Sun,  4 Oct 2026 15:35:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC27A6B008C; Sun,  4 Oct 2026 15:35:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D90B6B0092; Sun,  4 Oct 2026 15:35:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7AD646B0088
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 15:35:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DDB841A0BC3
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 19:35:56 +0000 (UTC)
X-FDA: 85285949112.27.12E1F36
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 54F48180003
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 19:35:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UEGLs4Y/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791142555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bVzs3nKi3STeEpl2UyULOorVsImcNQe0xcTlZn/ds2A=;
	b=oOOXcosCI3ah7WBkYkgVoWr9FCBitp1QlppfrOhH1B9qhF2GyL7aZ0wX8O5CSdCXfgqk99
	1/TXXLx/d3/RfSHdX6rEGCGn+tS12/UW180nKc5SXdZrOWSrxbfbXczmRec3zw00gFC8ZS
	szBYwcc1i3Krw65H5+MjmuOyYudw+WM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UEGLs4Y/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791142555;
	b=3q5dxnCwU/ezf68Yilwu2Z+q0HQzNy7m+z6vwkNDSTHCIOyutmE9gvOkfTVDnssTozlCTe
	ssMWQiqVNcv21ghJW1yQrmkYD5dNIbUM0HT4uSDUPQmeHoL+k/3LMyrQrTm5CjNXe0rllm
	3QOf4Jy+7bcpzHQdHxb7pqfXMkxvV8w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 30521433EE;
	Sun,  4 Oct 2026 19:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740C71F000FF;
	Sun,  4 Oct 2026 19:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791142554;
	bh=bVzs3nKi3STeEpl2UyULOorVsImcNQe0xcTlZn/ds2A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UEGLs4Y/E+ufn6rjORVJC4qBwgayQk201Ab5LdI8A/H7kAObN2X4rwybWoGYOlAWn
	 LBFThAKr195RP5Ck1itiVbU4NaQfSVJXpD9eWcyhjrbUqsu0x7xZ/jqkZ6Rrfy+8iC
	 XY5u/vO197mG/W9DHiQnps2O8KPAOKyYUHhZ4jzAbChKXRhthIlKDCnBx7jrrI7h0f
	 FbqfrInglgzFvLYf103tXFSztmxkW3vvJp6wgmvarLpcqfi8LnFJ3yyiM+G4/xXnxC
	 aSW3xwivPyy21guZRkVkIeXFzIXsA6Yu6PoTuwyb5fGwR4jNqy2x2jqcccHmb96IMS
	 2dt7+vLU7bbnA==
Date: Sun, 4 Oct 2026 21:35:49 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] docs: kernel-parameters: adjust reserve_mem build option
Message-ID: <asKqlZFS_A42w2hb@kernel.org>
References: <20261003213457.96408-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261003213457.96408-1-rdunlap@infradead.org>
X-Stat-Signature: j5cad8fih84hsi8gx9yz4t9sehbq5qh9
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 54F48180003
X-HE-Tag: 1791142555-834530
X-HE-Meta: U2FsdGVkX19A5zQwyXw3BnC8MR1FuwKRMl4TSoWlhIzevQyFd4OfT3gQDD2H8nwKNFAczDAXW6uZt2Su/RJpJMuSYDUvWWOlYjfX5XofCBrxRhuIzOqAVMIHNgFvQzoX67BDmnQPTe3nYahfxzdWexQUP0d147fLtN6Bh9BtUPtMCH6iKP8EsZNzL1KHzcxGBE/BXCbGhM0ocONsieAHt5pt6NWz8JPdkSNZnNa4Oa6S7WePLJ24RKgeDMYhW+R6RV2sSpLChKkbZiyxYT5q1/oF1Feew0UJUkm4nhtWZA2HHRR7L+zIOkaaZ8p6QRHPgP6CF9wKF6vHoOkIGN60mo0uFI1nAM6crJfU6Zczx69vZpix3jX2O+fXI6KjxHbVI7tZZYX884YlhMN54cELToueftR3egqRlmnGYGCPR/HfeitfHlp6qx0kbIwcnM+6axx5d0nHpdOLTBWf49fZXYxZyQQRgSLxvviqNtpJSzuaZLIQhiKONOQB4HVb2qANpqrQQCH2O/fRX1BlwW06ORTurP33zBMU2jL593H7Z2/RPFMhiKbvSBw69ahA51VzBEVgGqDw5qSKIAO2Dhtl/0LQr4mtJd31pnMHyzG/dCQoQ/sp71X/4rX+9unJHDp6ApBKurpgPNFtXrgMAtQuAl8rdtJOTlcLByFBOlLFPce+IFkaOCdQ/7TYqOPrktUM8d8syXbz1FgkzQCEYZHFjtUoL8dxd3tRiCKvRtl6o8GbRpmquLtxPqmyibPh4L/lzxdYi9Zs7PXUGofO0lKX1fXKbPZPmPqkFoDuF/3WRs1CUvl3fi1NTIDsHvwBQpYWPIL1SFBp/POps9RYB8uhKba2LlwYPmMjwwnO8K2mZOUou4eU1cCxj6PlwonWZhlkLvY5FKVYoeID9cMx78nT/2EyoitZaB2LikpzXPcuAESS3j0gATJoNoVmzRvZV2Wg0BRvtXdipdybbPyu5t1
 8xJFZsvi
 8BErJhFB8ytXQ1lJGUPrOT7rTRm/X1VDa4mRRYPlFJ+xu9H+sEyp8uUPBZ9UehZ2JPfY4D9fZIP8mBlf6d75q22/oDqNMhKjT+lT6JrcErJ6Xk9LqyzkHLDNPGcdTWXasoxYzVi+UxK5mKCSEpUieE+7pRjNlAInunq7WAeIp0d3ziQGYl6SMHjbtvErkV45idqIynq2OXJ98Iyx20RUyQQEIJhpPArlWqbWrDp3hDlRJT67bKjADj3cDucHXIM3RRh6h+CKZL+sO2M3F7oKneQnkXnZdUz16riH3eWHrBPsvPVe1rYhnPCN/n5AOYmM1w5Ei3ZtYoIt5i82KyQdOkjr9YWTaLPCZQWPwlDdHUJeVFpy0Pru0vKiQiLK+F5KvW7KgmqNvuqgGMqCNkLFbb3UHtNfnQ/SpQw3P9oNOvybb4sYpn3TAe+MBmrfN7t6260wP3ymtrtmWKufAY5QqH5Hnttf67EJM4yhD2INKR8dsAfTj3QGSUZjqwC4I/Sty31w3lk2+XJrW3m+Uo73HsRksAF98+DcP7NuplSx7vAJ2q/CCfDx6O8oYbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 03, 2026 at 02:34:57PM -0700, Randy Dunlap wrote:
> "[RAM]" means that the command line option is applicable when
> "RAM disk support is enabled." However, the reserve_mem command line
> option is not related to RAM disk support, so modify its build option
> relevance to "[MM]" instead.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: linux-doc@vger.kernel.org
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: linux-mm@kvack.org
> 
>  Documentation/admin-guide/kernel-parameters.txt |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next-20261002.orig/Documentation/admin-guide/kernel-parameters.txt
> +++ linux-next-20261002/Documentation/admin-guide/kernel-parameters.txt
> @@ -6693,7 +6693,7 @@ Kernel parameters
>  			them.  If <base> is less than 0x10000, the region
>  			is assumed to be I/O ports; otherwise it is memory.
>  
> -	reserve_mem=	[RAM]
> +	reserve_mem=	[MM]
>  			Format: nn[KMG]:<align>:<label>
>  			Reserve physical memory and label it with a name that
>  			other subsystems can use to access it. This is typically

-- 
Sincerely yours,
Mike.

