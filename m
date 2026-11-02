Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FE28606A911
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 16:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=lwn.net header.i=@lwn.net header.a=rsa-sha256 header.s=20201203 header.b=hLSFEKNp
Received: by kanga.kvack.org (Postfix)
	id 747366B05C0; Mon,  2 Nov 2026 11:13:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71E786B05C5; Mon,  2 Nov 2026 11:13:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65BCD6B05C8; Mon,  2 Nov 2026 11:13:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 42B256B05C0
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:13:06 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D2B974016B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 16:13:05 +0000 (UTC)
X-FDA: 85390673130.12.8FD62BB
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1CF0A40003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 16:13:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=hLSFEKNp;
	spf=pass (imf12.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793635984;
	b=JHplWLN0UeyfOTNYaQyQ2yoCPt30qCJoQOTAQS1rzxfMh5fI/dYqaz8ENA2n7gfP73XeCl
	vBGbx4ZHUEiQPS1JVbMBzXHd/Oc7/4MtlaDl3HeGTE7zUC7lZYZFrnB7OZ0X3u+mCRkOI/
	O/mPBGJ2n5lgKfSk80o955+OfHmPiL8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793635984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AkkqOJ23j/1w9aDcgkUObIGtTrhMiGUiSVpJap6HkIo=;
	b=33PIUUpyEqTiwUQqqy7uYXoJB7m0BFhFhxojb0MsTz7FXZa2buCVuj+xr7hZAqADcb+ZlG
	1oiXBzO2B5GKL95KK0bDZuGz/9ACZIBXO2/G8mucxIW8dlAlw8ACzpGHeAbseI6oKRqSjt
	wyfuy0Llva7l7YW+VTYdCT0uhf5L8a0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=hLSFEKNp;
	spf=pass (imf12.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net EC7A640430
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1793635982; bh=AkkqOJ23j/1w9aDcgkUObIGtTrhMiGUiSVpJap6HkIo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=hLSFEKNpfg/XZfeCCVabwTQY4KLKJZpZnQMd0k8s0ZmJXqkulDhzQsOZN1r3zsA/h
	 BZjjkR3F/UmzE4Bl4RiJANXHV95ZYme5S8CgBOVhj6VUXJ18evdyi8aB1XiE9IMZIn
	 3TXB2h2GpYVuV/05iNUnthJNjOIox8kINMUWHcEXnvjsc74cycEBTxf8ZcvwfWF3MU
	 VD1guXy43nB978u4gj3/5tgHG8YljzYIBeXrMwp8hAFBUNsoOboggIg21W5T242RK3
	 4e/sG9XhaA+2dDyGxshco46r9512ysh8V1aHE1J3hx18PKfmqPEARjSRIzBjmkDE00
	 MK8wcjKlDBUFw==
Received: from localhost (mdns.lwn.net [45.79.72.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id EC7A640430;
	Mon,  2 Nov 2026 16:13:01 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Atanas Kunchev via B4 Relay
 <devnull+atanaskunchev.proton.me@kernel.org>, Shuah Khan
 <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, Kees
 Cook <kees@kernel.org>
Cc: linux-doc@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Atanas Kunchev <atanaskunchev@proton.me>
Subject: Re: [PATCH] binfmt_misc: fix typo in "auxiliary vector"
In-Reply-To: <20261023-binfmt-typo-v1-1-459d4ae4c15f@proton.me>
References: <20261023-binfmt-typo-v1-1-459d4ae4c15f@proton.me>
Date: Mon, 02 Nov 2026 09:13:01 -0700
Message-ID: <87y0bbciuq.fsf@trenco.lwn.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 349dhcucgc47d4i9wbd5ynh6jit6j95m
X-Rspamd-Queue-Id: 1CF0A40003
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793635983-649975
X-HE-Meta: U2FsdGVkX19bcrLxY1VYlNdgQHDB15e0f6khY+TI+BzRXrZGIDxS+FVodJWU0ZLcUV5cSYPM5xE3qw39HHBPZHy9DQcsJ5XzhI1DJaFPTk9dCIdKAzyF3nCgh6SV9aFXX6NCuebLH7aYGTNRiUvNBvcuwcPOaq1R5p8Uq14+Q69dyU9plDIqQrtvHLvdVzcbrICkzAqsD3j4jtx1ND+vSW6z/wo/nJDTn7xHkvY6LADfPHOOBkcYvS1cA33blDRi/KVLDmV18ZJdE9Pod2cbmxT4raZKV7gkFo9Ov9q1GQecGBzzq17FYBtuQdUlHf2RjexuJWUcFUgBpltGXY9MbfMsbaCgeSDeemAhEqKV3Wid+U0o9MMp6tE4LpzGQngBmU3B762ZhqxMI+Xc4U4oZK1TwX493VUv8hoit9bVtbGex78qUWxUgVt3kN9IB10rCdmBi55tXbAEBL4pI6s1MPCSjLNNiIgl9MSYkHga4+27dMnwdI0Z2+gh2SUKsGPs50j7Hy8hAPNY1Fk7a0K/VI2t+smeIN/t7smLx+jkSSlYxU54t6I3fOC/Ksjn9I0lU/lpkp5R4qbvMI4pVvAxHaIsot5WKogSXBS5OpwrBLtod1d+709ZyAXa4SImeWzmOGOzVGDr4FYdd7DQ2vGwQ097gB+VjoESeU/849fNUFGRiBtZGbKJWuiykyNIWMqPGGgCif9fnVfxiuOcVEThqSdQxTnO5ngIO1mIQk9xuUzL/JT5eiFf2U9Q407jWmBMEaA0hdSNzHdrKUR9Vho8o+VE2sBFdhgcaVE451PGZT3w3KW71iuXYIkp2VQUqiCVYCf/qd3/GimzD6znOwJOGdlowfrn578lTV7BM/jP/uREyc+ujxS0UX5MoQQ9uljjgy0ouPElVnjuk67pHVhx9XcK63NNFGrSjYXzrkIVXxLZjPxffPN/HYuDU5v8/Eejmupj2BMK1iZlrWFR+Qk
 Zp917T/H
 6jzxhw45Se/xwwPneDgjm8E+5FBgNmLCtV5+y4D9qpalDncIt1bh1zPxIiBlVhzp77a4J4e/ByA6oitrLD0uEonZiiK2ETrLvlNNnKrORxifIEWBRWf3PC2N/xv+roz/GvKf38L9L+i6RYJ/VlTg2V1SbaewjovmHoW/LWMLM2S0BGhKQmJ6h2btlzB0HFOb/N2usnGIg/rGDjUKV/vg34GI2iAZ9eN6h4aXXWD83O8u1f7GGQjOCJZo6oXQcgWDPsweswQ3lhRwEP6UPzeRhcWMY6RWIwvQ+dbY+vDT1AgXhsK+zq4bReKufpYxXe6KDsLXkSNwsO5Go79upu6HFTFpnHJqLQJiGToKNw096G7lmUfxcI3Hb7X1IE0kSBiFeygeTeTgAVACEIMihLJoyZD8pIMR2ezAG8Il1HxgFi+7Nz3wduPh09+Zef24LHCtlQ6bd5Z8zl+jgeUbttwn/5iemCUkl6z0d0ycaTTt7jSmTtIJJVypyYBNYaBj62469RMKaN5Klwz2xnJT6yZ6dq4bVvtXzDCHVJ6zaflva4Xy1Pmp7/CoBJ73tGg55FivjHT7vZzYT7A4Ekhos727exirwMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Atanas Kunchev via B4 Relay <devnull+atanaskunchev.proton.me@kernel.org>
writes:

> From: Atanas Kunchev <atanaskunchev@proton.me>
>
> Fix "auxilary" -> "auxiliary".
>
> Signed-off-by: Atanas Kunchev <atanaskunchev@proton.me>
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

Applied, thanks.

jon

