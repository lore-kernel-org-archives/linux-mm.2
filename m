Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24CE0CA5FCC
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 11:54:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12AB76B0088; Thu,  1 Oct 2026 07:54:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 102096B008A; Thu,  1 Oct 2026 07:54:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F34986B008C; Thu,  1 Oct 2026 07:54:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D05806B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 07:54:50 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 59E631603CD
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:54:50 +0000 (UTC)
X-FDA: 85273900740.18.A27166D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id A36381A0007
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:54:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kuS+Aa6R;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790855688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4XiWQIb0DJcd5roPqLH2iaW6jTBbzH4eyhLmxNAjUkA=;
	b=z0sCqHdLGOi0ISOWsMAf6gEsADYrOLIbgcC1DmehG+elJ1GddwM2aV2kmKj+2omRJrgJZw
	zxxZ5+A+SFtJzPhowlm+jGf+rwEHoUrg2ARLTjri9EC7wluUuJIftykjbz4ZJ1E2MzNE/m
	FsSe40xLM+xy2QgPZFY5EEcpj4PiK14=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kuS+Aa6R;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790855688;
	b=lPoKAalQZM5+w/8flD0cfh7gm064fIMVo0jNGknf5QUolKR7D3fqTl0J35qS/QPpxk1RVI
	NQDM+sS90pPaUO9GyVxY1Mp2zC0/3NmThmWlStZct0Kigg3PIwvgq2UxA7BrbwvGWA4RhI
	8pLh4Kn82+lIOrzyVKLqdpBMu4TW3SQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F200B601E4;
	Thu,  1 Oct 2026 11:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B7B1F000FF;
	Thu,  1 Oct 2026 11:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790855687;
	bh=4XiWQIb0DJcd5roPqLH2iaW6jTBbzH4eyhLmxNAjUkA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kuS+Aa6RvZp9uiMlrv4r9B/FLkKGL0P7bmQMyLkYG/msM5BqyPmhZqtLD2F7gMPvA
	 4SXTiGXT/Bf13GqiT8uM9eghr1Zf7JMbuxRqNNxmDOqdVeQe32OD9NE2Fcpo8yLnId
	 hU1UVFbOIuWtvR0lddZcwAVHXjI6vF2aKQ1Cef0QaoKmGsT63dOL5ZYgv+l5gGyHqQ
	 WK2U4KXKwGkJWCL9F9EsSepaXx3lvlTa0oat2yYhnMKtUjyV8+pj3+Gzneu7j1vA7v
	 z9+gW+ERfcLzNWv7ZohmqhvC6vw9ar/ZgMa/K5857+kRqo+eAAbPMSSKYrVtcynSdv
	 RB8snvC3lA0Pw==
Message-ID: <3d13be9d-a4c9-4123-a047-67371fa4586e@kernel.org>
Date: Thu, 1 Oct 2026 13:54:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND 4/9] selftests/mm: mremap_test: correct multiple
 VMA range size
To: Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 John Hubbard <jhubbard@nvidia.com>, Kalesh Singh <kaleshsingh@google.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Park Tae-sun
 <ts930@dgu.ac.kr>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260924050009.19974-1-sarthak.sharma@arm.com>
 <20260924050009.19974-5-sarthak.sharma@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260924050009.19974-5-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A36381A0007
X-Stat-Signature: dchjngmpk5fmmgurzgyuairs6w9u9aak
X-HE-Tag: 1790855688-783875
X-HE-Meta: U2FsdGVkX1+QHx1AOhUPJLzdLW74GQsqDKnp7IqaGIJcNXp/sJb2MeeBFpQ9x1xKCEmGQcTr9DAl7JcACfq8sackci6pRgx72crqrjYNrT/7LtOBQKvwiFg0+q0M/80OH8tR836PKiaFrVkLOs7t1sdoi3v/4i86cu4Ql4LlVo/8b9RrmicpprO7SxJ9TrYev/VBgDr742c7nhrF7rPF2OG0cs4jDkSkvLm8Hz9etNDSMYFrLZ1VZx5tPhDj8VJkjWyMzqgCS7t0mzuvXPR35Hii9mu0bS2MQvU8fbPrvajUoLy6kkIQsY1vcY/nyh2Rr4Sz52nfVUof0wTJXyrDgNmh0XCSXWnhbWDaltNQzsqmgcFg8YCcshfl+g9UXdzUE90t6N116fkwFgbT/SU3xyXM98hiqd/asqNFROkeahG+xXe1WbKjktwGY7Vwz8kgPuSkl/4Iske+dtK02+xWTAkBbfCTkoXWmVqi+oE8sjzMq+x1eAJeW0JOlD69+hWikA+qnonVxE+w6rziC0GAx/ETGPZeKJQrZqoO2Po+/Qhuc7RXO64xXynVHBz4i9WR/utEGlHzpJHkj6+mbm0Tu3K96AoR6e01juoDib4jxSA8kqeLaniMhYxk4sLmrq2i2cQ820/OrdQ+mJSqp40o1/uYYB+kUvhWsV4Tiy7ex9a2Ss9WCnqO1sSzFdxcPXEdWGLnCamPoqGKUKWQSF3xOzbUK8B674ye66WQ9iFZ4Ohw+K838u1zT8zBW6XjzNvAA+tn40PgojWho240XR/DdJ6xmcmsddXGm9ujuEj0A2VQY8z1QivWBc6AI2wh5e2LLpdooNzdppeF6QuxqhNhLZ4lEXK46G4E+llBvXzk16Up6guetqOZPz/hLpXsW1Kd8fwnCHPvk/I0DhxROkZzpkx0+rKiKjUngeXsQcWgS6yrRu/evmYPZ6Rpgszeq2+R4KwP5eysiPVkQI1Jm9j
 0gG7v1Xj
 jKprnlD30ySJjKna8BO1jxMGMJVGb/v6LqeIYWz9BHoBREr+Wjd+Bc3UGAqfP5EVukFa/6DlmNdzMfnT5gYLcUT4FcbMDVvsJ+5FQrfS+VxRsXloToV7DUpMNWbRv4o/JRtWu8Dz4BbJevSWwgQeC0463c/wb5E61qsLw3ibHPPrhg+HM4NgT/AG2aHLLaYK/p+kpFtGDwrY+3H+xFr1x/1ZJEQW9NaM6VbMLm/5FYIxpAPgWvCE3X+8WfaNvVE0RQjsDMnb56b6MaLF6Wh8kao6YYX2CLY6MMRr2V70YbyQksWfm1y+sjHzYQmRnDvfM4STTJTwyhw2W9LtR3Xb+26ThpZAszxYUDsuH6ZMl89uiByg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/26 07:00, Sarthak Sharma wrote:
> In the test mremap_move_multiple_vmas(), pages 4
> to 6 form a single VMA. But the helper function
> is_multiple_vma_range_ok() checks pages 4 and 5 as
> one range and treats page 6 separately.
> 
> Check all three pages as a single range and skip
> the page 6 iteration to match the actual VMA layout.
> 
> Fixes: d53f248258e1 ("tools/testing/selftests: extend mremap_test to test multi-VMA mremap")
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
> ---
>  tools/testing/selftests/mm/mremap_test.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
> index ba9b7f7566d0..869df22d46db 100644
> --- a/tools/testing/selftests/mm/mremap_test.c
> +++ b/tools/testing/selftests/mm/mremap_test.c
> @@ -373,7 +373,10 @@ static bool is_multiple_vma_range_ok(unsigned int pattern_seed,
>  	for (i = 0; i <= 10; i += 2) {
>  		int j;
>  		char *buf = &ptr[i * page_size];
> -		size_t size = i == 4 ? 2 * page_size : page_size;
> +		size_t size = i == 4 ? 3 * page_size : page_size;
> +
> +		if (i == 6)
> +			continue;
>  
>  		for (j = 0; j < size; j++) {
>  			char chr = rand();

What is the impact of this that it warrants a Fixes? Will the test fail?

-- 
Cheers,

David

