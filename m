Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EA8DCDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 09:40:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8A0B6B0088; Tue, 23 Jun 2026 05:40:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3B1A6B008A; Tue, 23 Jun 2026 05:40:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2EFD6B008C; Tue, 23 Jun 2026 05:40:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA96A6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:40:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 40C001A0120
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:40:19 +0000 (UTC)
X-FDA: 84910681758.09.C9840C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id A4C54180006
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:40:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jq5fYvOU;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782207617;
	b=kMXZEJii/p3nTsPk5RQRBdRMUBQDOwe7dTmcbR+HC2KrsWxd/7gruG/s/6V1Q6j9n/c6v5
	L2PVF70n/PHEhTTvyAq1L7//yVjzAsmXRCSxa5Cvk4cbAvx9P+OZaGAiwM6iNPq7tVtZAS
	Whv0Tar88ZRT5pxEdY0QffdTzrvUji8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782207617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gU2OeON2khhag3065qJSEGqv0bC3o8YE/vL8VmgXF7U=;
	b=NyI/sYKQLOkuXSMAuc5yTh0Tr+hMhErnE9VEiAGvpUHKTTO21f6e+YKVYOrQC939TnXocU
	sSAhxQVu/8AN6hvZZZ9T1tfIWeJk4SG8BuvyogaIPipg4reOyYMoOlWSPRbHEd6EHF8ANS
	F7cMWj/nk/jCv8z03NKoZPPEW7ZqBno=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jq5fYvOU;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2AFD860052;
	Tue, 23 Jun 2026 09:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB981F000E9;
	Tue, 23 Jun 2026 09:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782207616;
	bh=gU2OeON2khhag3065qJSEGqv0bC3o8YE/vL8VmgXF7U=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=jq5fYvOUa492pEX6ZrP+8m/pQtS/HLI87O5dO+4NFW7Es7IskHhTma6OM4AjbIqGM
	 +T6YYH4SczvapEYQq8QgH4jngvElg2YTkxL211SypoBeoQtEW27rbn6gx1Qm3Gkfog
	 j2ekBqRcLZvr/COOckez9us/aQUUqadNRQOZK8NOovfoXks95UswH2FJU4oXPSVY9E
	 SSok1y+9PCXLqAYxY9W6jXBxxcR1jzvhlb/NTfj9eLLy79WNoxjsFzY5prKSM4r44k
	 1ZHmJgIs8XC/8nv3YEqCqslm1erYYUK1gkHUChSSwYVFly3Vn3lhctsYXZd/b41D43
	 4qC9q75HbMRog==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 1/2] kho: add KHOSER_COPY_TYPE(UN)SAFE for phys copy
From: Mike Rapoport <rppt@kernel.org>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, 
 Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
 linux-mm@kvack.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260622225736.2961438-2-tarunsahu@google.com>
References: <20260622225736.2961438-1-tarunsahu@google.com>
 <20260622225736.2961438-2-tarunsahu@google.com>
Date: Tue, 23 Jun 2026 12:40:11 +0300
Message-Id: <178220761161.162773.13771896658073176.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: A4C54180006
X-Stat-Signature: nh4eopjkq37kd1f3ko5zj37ts7zjpho1
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782207617-247609
X-HE-Meta: U2FsdGVkX19Tk/4QRwWoQ6FA0KxW+Yb+wrFSmIzoAj6o8LFHf2GUltPmtZLdz2a6pXAVo43puA26QwJL08mnYTIxcp0AGtYpcZyUiFD+aTVDbCrjLYAWfCqW8Rm/XYPUlntSEk3R+w7OfFoBvMHOA6/7+cUjmb2M4qiXA5HEjLxQzvbfCFHupvDemtqJEAK1/H2UVgZ+RKxQO03w6pseY1X9uw/hz9NGiRTG7eWpX5D76ZH93PxufzngMzrltm2+a5LahDZPy6v81NbDGAqf/e47AXS9J4jLv2Tc3ZPOg2PvY0Vp4LSnXBkJ/tjpl5LXHNInvIT9FdgvvY+w83JPFT7l+kL+BI989uOt6ApIkRnTbesTcyXUeW5QLiU5xnBGaKADPcp5Gh04zBKWJG7ytHLjHwmIRkXHZpDOjtaOsxyWYJ9Zd0DTe5tXdK8eFUULM1rvyXvgKPuwi8XAv4GotryqnqtBZZYomb0sHHvl2Bwsd7otFbGQhgdC9+nMaUkmxWQT5DMoct8A9ayif7AKzgXLMzZwdbQobwKiE7uuUCsXQJoJO0+ZG9P8JZLXPgJzMaxGqmaJRHbm2rIsM2LRCM0rx8GZo0ttY04ovrDSFHzTS/YXY/SdZd1Y+pQAQzM0LF/KO+1X2krfjnwx0Fm0quDqDmbktyUnT6iqeqBpTXQWzGvzTbTJTtn4FFJH1K+E51j735DdBkawy482VZedj7lLVxe+u+jBFfclXxpZH2GGrahLG64Xz0zfkgo4A5/JA8ayeIfjq553B21wZrOEl5YqQeIOk93iWOjCocuiuVj4FJ/umnAbTHSKxG0Xw5n35EmB3QwfLu9eK03sn/i8zexMarTgIL0kynXXrA3e1e+Pix3BYBwRl8o4sLjz8Xq5H+En2loDFi+9tusvi/fpwisHR5DiUzfZzW7s8Rhub1Y5K8SJGtqNCBJ6567PzWpeRMD72wfmt5FALHMpIn1
 K742QVjg
 5BH1yVqtZU8dLEDwcfkxJMu9i2xWtZc+ZJEI0vRsEY6+g1AC7ggdkXQGTco+QSXTb7bmZhcl6fhCZ9jtpG7E5WkEnD0gE1UY++HHuS7pz4tjdliBmgqSIvdhrii37OocJVlVp6PNKb+17IZ7W5bDyPhQuwn9ifWYN6YzSXc+6Kj8Nx0bDu0qkXaq1kgdWdY0+KHfBaVSTY0AzRkIg+pzOzIgO+i+UcClwL1CXYUDX5egZM1drpyWIYq06IU2Koal4/4+fYvVwt9K/1UDgelq+P7nC4SC8X4MAOHHG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Jun 2026 22:57:35 +0000, Tarun Sahu <tarunsahu@google.com> wrote:
> Adding KHOSER_COPY_TYPESAFE and KHOSER_COPY_TYPEUNSAFE to copy one
> serializeable pointer to another. It basically allows copy of phys val
> of the serializeable pointer.

Please update the commit message :)

>
>
> diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
> index 5e2eb8519bda..c1b61d875dcc 100644
> --- a/include/linux/kho/abi/kexec_handover.h
> +++ b/include/linux/kho/abi/kexec_handover.h
> @@ -139,6 +139,17 @@
>  		(typeof((s).ptr))((s).phys ? phys_to_virt((s).phys) : NULL); \
>  	})
>  
> +/* Copies one serializable pointer to another. */
> +#define KHOSER_COPY_PTR(dest, src) \
> +	({ \
> +		static_assert( \
> +			__builtin_types_compatible_p(typeof((dest).ptr), typeof((src).ptr)) || \
> +			__builtin_types_compatible_p(typeof((dest).ptr), void *) || \
> +			__builtin_types_compatible_p(typeof((src).ptr), void *), \
> +			"pointer type mismatch in KHOSER_COPY_PTR" \
> +		); \
> +		(dest).phys = (src).phys; \
> +	})

I'd suggest declaring local variables for the pointers and verifying
their compatibility. E.g.

	({								\
		typeof((dest).ptr) __dst;				\
		typeof((src).ptr) __src;				\
		static_assert(						\
			__builtin_types_compatible_p(__dst, __src)) ||	\
			__builtin_types_compatible_p(__dst, void *) ||	\
			__builtin_types_compatible_p(__src, void *),	\
			"pointer type mismatch in KHOSER_COPY_PTR"	\
		); \
		(dest).phys = (src).phys; \
	})

IMO it's easier to decipher this way.

-- 
Sincerely yours,
Mike.


