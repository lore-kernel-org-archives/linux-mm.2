Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2012606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 19:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=Avl+JJgH
Received: by kanga.kvack.org (Postfix)
	id D2B5A6B05BD; Wed, 11 Nov 2026 14:49:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDC706B05BE; Wed, 11 Nov 2026 14:49:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C19456B05BF; Wed, 11 Nov 2026 14:49:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9DF616B05BD
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:49:51 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2D23880190
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:49:51 +0000 (UTC)
X-FDA: 85423878582.10.DF334BF
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf29.hostedemail.com (Postfix) with ESMTP id 016A712000C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:49:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Avl+JJgH;
	spf=pass (imf29.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794426589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zrvPkJULyEyiiTV7s5r2ZxB5yrxXRBtYdQX97+mN3Qw=;
	b=Es4mkMXHmtTQ/tcWT9XxkWlaK1YUSpRPHFqT2N5kRcWip3JU7WCDLPA3XjjcgImZLDW1tz
	wjA6Qfi3iUKsDQerJjocZfMfhQCvZOvM2nv50LhgdSdj6Hi3X0jrSWCrTieE3msTv9Mea1
	N/HIc0sybxN1q/peup5zgFzOf3hfWVg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794426589;
	b=xCvMMxNVjnXYUwt7uKa8WXGP/PdbUgtV3ctVTGnxdIbLF2xoSYzyqfZy5aGX7D0XOalYpS
	xjDLho6qfy2bWYsD+zdwZGvsl8Qw8JUgQL3d/OqU2lEF5eZqpBTCSEKo8Fq3ZkR+re1a4R
	vB+BxvTeBJRxygdSpj3d55qejWKLOak=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Avl+JJgH;
	spf=pass (imf29.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zrvPkJULyEyiiTV7s5r2ZxB5yrxXRBtYdQX97+mN3Qw=; b=Avl+JJgHnfZt5VxJgZOf12120G
	P1BzDPzgqQruxE1dTjcEezmt45xaOjJNw/FXIl94c6SOcW+WFg2gXY8/SSm6BY3jQckDwyVcwbGSy
	/5Vk85yvw93AjywByPWi8S05ojcDoGBj1Sx7Y+NdRdW6uuNXeCGMA7ltQVNjSyKoLpEqoD7gtxqFv
	y+DkEDepySNk9YjNdBPwxmlP7KRwfsx6TrrcqVtQDO9urYOHNRyhfNxJDtJDGRH1ZDC0g6qaBUGQn
	riwWO/ZaZpWqn79A327n5cHZEtTwEdYDB4aFcaBGyRdR+6BeXKInaY6qSD2HGVmxLJBMxyyVnTAsL
	LkqDOFtg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xREKJ-00000007ZIj-0Mya;
	Wed, 11 Nov 2026 19:49:47 +0000
Date: Wed, 11 Nov 2026 14:49:44 -0500
From: "Liam R. Howlett" <liam@infradead.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] selftests/mm: mlock2-tests: fix fclose(NULL) in
 is_vmflag_set()
Message-ID: <t4vjvdkdvmqcagvhw7z3p2x67p3iopcjqllrapwrzd7qyothb4@un6bq6otzb7w>
References: <20261104-for-mlock2-v1-1-57e6dd74c2bd@kylinos.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104-for-mlock2-v1-1-57e6dd74c2bd@kylinos.cn>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 016A712000C
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: dpt6porxeupzpdrbdufor7unaxispbtr
X-Rspam-User: 
X-HE-Tag: 1794426588-148287
X-HE-Meta: U2FsdGVkX183gi5U1iWS0ZG7jv8wCKu9Rf0IxUdOE2jpD72xmcVET4LMuvTd7Q9UCU2VRqBX7n9aUL1Cy4C9+Zw4y+uxIOvimvXdkRf6O1oynUJz7hFQVG7WKnYV1xQOLZpPs1d/cViiPifyRsunnOfGLCrJh0AsHmxjZUdPimwbnX2JWSKvolb6was1UBze7qBKrAbE/tn6CTKqOhu4BY/Q3bhgavQ59ycEdlNUfrGHsU+IR1tQEAy1v4Pn0KSWK5fQC8x8yOZzlF4g2lFZ3mOasSvGO68QDUHBjDM6RI97hpxInK4L97HRdHcas9iZvdR221C8FUbdQKy157C2ciJoYGtOP/du3amndtjzO3kWoPhYCV9GaINbns/diQ50eUNVZzNqtkNB5Mji3QH+/mo5dWdXlCf+TtrLhed7jdGLGSQPa4+4NgaHorEvxvLg4/u5HAbGhTzZx8TdwQqKK+Snoc1+YttOWVusF5Xnt+ZHmD0/3Sf/Z/KGqq9qwTxCyRk7Ae8sVcpKdY6PiC+LWk/41VaUswg/30qTN1OtEWcdIJOu18GXb+nkFWiM7QTdDFfaBtQjnnGvQlDQRFvB77T9IfiEGXl3gRnPWs8iukbY1JziHhYwiMTFgepci95jquR4cSZ7phR3cRFTFb4e+COrayd/edaDT8NSqeciEBWJ8Czllm2QfjlePMw+9prXEGAQBY9dtCSazlUJWvny7fWsU0XCkTLjMNXvUPSAs/WOolaQ9/mNKcHocf68xj2gESE1vvJVkOSvOtSVqy1psuDqcfz4hp09WEg6vzIcEFbUq2qyJPlXwDWzULDXMF/+29g7Vqs4np9F0ttYmluusGs2Ik2m6SqgvT4quR0DjNsNRKkPTKRWg8Y7U13bAv1m4kTVdtHg6d+vzNlplNe8+qu+zkgnH1H3ujl0n0MXYzfrpVHIbLjN6Iy/B8koLOd8dNrm3zB5CtDv/+a7eZT
 UQppXK3I
 6FVavaissXYgHi+lXsGoC6BeQK6qaafr8SxG2GXTrROwYtaDu3ZM/mt2mECsKz6saw7eGJeGW22RdJPk6Zm9djYmYNpydTN+Orn1+OWFqmjofGwSPsbB5R0Io1Ug82oqQb1LuYt3Bx35o/jDsQqB+QJ27sA78AHWHpu2ntIQnSpL0/gPLFHshnz6qvprseUxLNxfzsTqbasYcI8CKGNAqf/SdxG4mF0gEw2b1cQ3Uabt4rTKDQweWbkHhS50gJauA9CQVGn9onvD62kiOvob/7wPe5FwNgWILv2JYTIIP6YAofdSYcSyTvZByKwsoVPmr7XNoIshFrBsKHCQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 26/11/04 04:49PM, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> is_vmflag_set() jumps to the shared 'out' label when
> seek_to_smaps_entry() fails. smaps is NULL on that path, and the
> code at the 'out' label calls fclose(smaps) unconditionally.
> fclose(NULL) is undefined behaviour, so the test crashes before
> it can report a test result.
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

The sending address should match the sign off.


> ---
>  tools/testing/selftests/mm/mlock2-tests.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/mlock2-tests.c b/tools/testing/selftests/mm/mlock2-tests.c
> index 144b550813a6..85e6cd24515a 100644
> --- a/tools/testing/selftests/mm/mlock2-tests.c
> +++ b/tools/testing/selftests/mm/mlock2-tests.c
> @@ -66,7 +66,7 @@ static bool is_vmflag_set(unsigned long addr, const char *vmflag)
>  	smaps = seek_to_smaps_entry(addr);
>  	if (!smaps) {
>  		ksft_print_msg("Unable to parse /proc/self/smaps\n");
> -		goto out;
> +		return false;
>  	}

This looks better.

The next function is also messy with the goto usage/ordering of
unrolling and should probably be changed in the same way.

>  
>  	while (getline(&line, &size, smaps) > 0) {
> 
> ---
> base-commit: 74d73ffcffe03804f97e9fb82301dadf75671282
> change-id: 20261104-for-mlock2-a67f86dad498
> 
> Best regards,
> --  
> Hongfu Li <lihongfu@kylinos.cn>
> 

