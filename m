Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 491BC606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 17:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=FFx+HjPs
Received: by kanga.kvack.org (Postfix)
	id 658936B03CE; Fri, 23 Oct 2026 13:55:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 630A36B03CF; Fri, 23 Oct 2026 13:55:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56DF36B03D0; Fri, 23 Oct 2026 13:55:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 331FC6B03CE
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:55:34 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2330C80180
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:55:33 +0000 (UTC)
X-FDA: 85354643346.18.6A5EE3F
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3F756140006
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:55:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=FFx+HjPs;
	spf=pass (imf23.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792778131;
	b=r8IACHifGHrSuaHVvrTAYY8QwUWsUy6rP35TidjQKttkA9l6jl7jzJtgYTsJCSmJbtZ6Su
	weOffAR4iST8YUhjFwKAlGVgyPIEtih7bs1mhJVTqe2zUUxdaZv3h3EhT2eZ0A/U8y6b9u
	qSuXJJaz54ss29QeIwUKi1qrAz7+uhs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=FFx+HjPs;
	spf=pass (imf23.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792778131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uYTTF5jDNkxMCVJ9mrlfykfmfKah1Cd8hTMk87yFHBg=;
	b=QjABZhSdPuqcFDIVinhD6Epx0/2kdp8Qa3ZO73jK9jdqTZ0Rd3/4zIwbX6P382/D3a0D+m
	IltR8NWuDlQH5zp4IN3wqw1aOkNTEE92UHjHJFhYxwD20QZmhBIjdzTmjwqpE0Otl7AmCl
	58PLYNyeWyQoWvSaWlLFme7U49+M11k=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=uYTTF5jDNkxMCVJ9mrlfykfmfKah1Cd8hTMk87yFHBg=; b=FFx+HjPsKWG+EePtFOBKnIR9Hs
	GiPfrM6SAXY2vTtQro2pSZDw/MGSKa/4imbtPz8BzVcylikXV2VXIuNwXOoVNMkufpXfFQbD/4Ah3
	fSKZ0uUV8cUm7TXyZ7RLnpCVkY8tTajyQXzjilHkO4Y0EkuEzhAiaz+11DIDHgPbTuG3/fTtQRJVy
	s1T02id+dNFvi99iSrYWeRc8QXq+I+yf4Fnffy7Tck+NG1U+X5eq4MT9cyJDUvnkNOaZZy1lbqJTe
	rBnqniYL30xcHkkDHQElLV8g+PQYcUDj7+YrHkYhlz6nCrB4Kts94DwZ3Q1UdNPoLhS4aLmzYZN5K
	WmduT+gQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xKJUG-0000000Glen-1HOa;
	Fri, 23 Oct 2026 17:55:28 +0000
Message-ID: <26adbb3d-bbd8-442c-aed6-80cf091888b0@infradead.org>
Date: Fri, 23 Oct 2026 10:55:26 -0700
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] binfmt_misc: fix typo in "auxiliary vector"
To: atanaskunchev@proton.me, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Kees Cook <kees@kernel.org>
Cc: linux-doc@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261023-binfmt-typo-v1-1-459d4ae4c15f@proton.me>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20261023-binfmt-typo-v1-1-459d4ae4c15f@proton.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3F756140006
X-Stat-Signature: pcqqcfymxdxnaeq7kxm83x4ndterohz4
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792778130-473730
X-HE-Meta: U2FsdGVkX1+7JXWbyJKEhOXQylSKVFrd377QGc2y2lXdMoYW3CE1KOeUb3dWAXI+Dc9TfmmZrDcPPZYL6cx36jk/7Ojxhon/91b572TyXKWybLqcNDmnqNtU2yu2ey5GIaDJpGtMK6KHE5WkS92VoT9Er9InO35BqfZfvpY1GlwkZqXuLVNWTYvHk2s093kCLolFl17bRxFgeiL7vut4bAauuX/T6gKAWdfyi4idvEtFtAXAzfnO+smQR5xpN8TIoN/ChChl8AGC5Lz5jgl9JrxY0hBVsTXJ4bdC4TidIqVOsZ7N77DiNW56Xh3Hh4G1Z6Nd8pbm6RqzcLsk6nphbTGs/Kp73vlqlTt0f3KRb+itkF3QMlZx3hNxS9p/0TLTmUbp8F5fXhmfxwnFAqZRgkDi+BIqgkKd9bMssnU9dHC+GKC+E/jTxIDVNfScu14C+Od9BQlVWQnUrO2HqX4aS1VMFi7ixuCw9swQ0HzzpoMKUKeuhmBVh7FvQkCyZA6taaBE68W0L6Pyygu+qP9Q2GXGoqU3bPWzoH1s+5mYGcK0Je3VFhohZ1lsjxxd9LliVPckmISVQy4AExSwmCZqtZP+UffmeD8M3WeT5/p00ln8G9stp1RPMT3pg59LyXlzgSDDtxkqhMJ2UixNECB9VNvn0Tdtjksli/gjkrbwPBYrBSS8tYyFutYYXsxoh2H5RxAWREsuzYog91jvbsHriuORZt+cY8nN7+t0dXG0G2OT+tN0o1xg9MgAIXHfLlSggmbtj6oANpsoC5XsFN+suFL4Nb0VyvTVS8196Q5gklEb5WLGkruPYhbzr+7lc0WamLbQQVJyRLUFV06jUepnSTlEfyz7pz9oFF0yZTFbhnADVAoJayW5Wn4/6fSYUOkVy8XhKbp+l0Hs7AmInekADA6XwGOOKG4bu4S3T7qREHRiHDNvQeoWLCL1Bqn1eYszKl5l/Jke4M1r1EduHFF
 y9M8eVXg
 enOb+uXSkZ8PAqRLdL0EqxSF0AYFRlxUj0zd72PmshSl0iYBkBWpdbt6jNBjJu2+9ZFKpcw8DYotvSjOl8j8E5/7s+STw5iJF57G2ll4unBpGnhLcv9Z6m4kZBGSG4CuTDkt4ymkHhZfitdFR59uAXQ3ab74eVBhXy8L55Py2pf5BeJQmEzKvG4VHCvFetbb/qTacEmvZoKgtHY2lLjhWI616LUzAV6e0ApPTpeyKDOAR7RzBSuAqUSIswacWWO+3N2R/Guke73Mq3pLAlQokxgj4s8v8kQLmfB7T3RI6SVCcGct6qFeIK9CbTaDVEH1G9kGmugmVxASUAsk7OVgJe7xNnGjaOnlw4sqPS7bJfCzRlB6EhazHLvVNABPbo/3jAY4r+zj11Asj5aW4u+j0hy/A+6ZGQdHm4arM1fD6cecWmjo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On 10/23/26 10:50 AM, Atanas Kunchev via B4 Relay wrote:
> From: Atanas Kunchev <atanaskunchev@proton.me>
> 
> Fix "auxilary" -> "auxiliary".
> 
> Signed-off-by: Atanas Kunchev <atanaskunchev@proton.me>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

> ---
> Fix a spelling mistake in the binfmt_misc documentation.
> ---
>  Documentation/admin-guide/binfmt-misc.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/binfmt-misc.rst b/Documentation/admin-guide/binfmt-misc.rst
> index 9e84b877d06d..e37668371453 100644
> --- a/Documentation/admin-guide/binfmt-misc.rst
> +++ b/Documentation/admin-guide/binfmt-misc.rst
> @@ -73,7 +73,7 @@ Here is what the fields mean:
>  	    Legacy behavior of binfmt_misc is to pass the full path
>              of the binary to the interpreter as an argument. When this flag is
>              included, binfmt_misc will open the file for reading and pass its
> -            descriptor into the auxilary vector with the key "AT_EXECFD", thus
> +            descriptor into the auxiliary vector with the key "AT_EXECFD", thus
>              allowing the interpreter to execute non-readable binaries. This
>              feature should be used with care - the interpreter has to be trusted
>              not to emit the contents of the non-readable binary.
> 
> ---
> base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
> change-id: 20261023-binfmt-typo-bf80308e23a0
> 
> Best regards,

-- 
~Randy

