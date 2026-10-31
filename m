Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB0EA606A324
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 12:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YHf+blp/
Received: by kanga.kvack.org (Postfix)
	id F05F16B00EF; Sat, 31 Oct 2026 08:40:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDD386B05B3; Sat, 31 Oct 2026 08:40:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF3DF6B05B4; Sat, 31 Oct 2026 08:40:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B78C86B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 08:40:44 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2E405A86C3
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 12:40:44 +0000 (UTC)
X-FDA: 85382880408.22.6308996
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf28.hostedemail.com (Postfix) with ESMTP id 40559C0005
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 12:40:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="YHf+blp/";
	spf=pass (imf28.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793450442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cxqf9Bqorso0fGl5m6PKE59KMlkjDZ4/kjDJmjbnK7Y=;
	b=WnqsLyBXYtT3KJ3RPNz+b4bbt8MXMB9sCNFG7oBIvwx3IpEZdpUNE15vZU+4j+ipDCrFTb
	GhBl5MqEGX/R0KeNOyjkqFav74cPI6EfD/hu4MMNUaU/dwmXO3NFbsANGMymKELcz+J3z4
	osFym+IW75Kt6cY20kcqcIDkFbOm09o=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="YHf+blp/";
	spf=pass (imf28.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793450442;
	b=OMyDgnxU8bnCZVEjddqMyThEqEbl+ZdlYGBW1RNwB479wkHbmwXJITWZsonW7LZE7RsKUK
	KioIcK3n1U4nzHEZe6oNLSiPk1uHdRyasmpL/XSnDbr280Vf8qwW/GjN7FfCS7bFhw3qx4
	Ko5jeVwwb32uHJ3GbTof5re8KKqX/0o=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-48c5358fc28so1251655f8f.0
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793450441; x=1794055241; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Cxqf9Bqorso0fGl5m6PKE59KMlkjDZ4/kjDJmjbnK7Y=;
        b=YHf+blp/v8R1Fg0Jz4wzukLig+tdMHMPTkEClleJExeSg8893ki/m8FvA3D3Sw9aGe
         OGRu1MtMNvi93G+rWwcvOI0tGycWDKWaRtoE5riSmFpkn3Ld/sQGX/HYkCwM009ekV7n
         K+ncKtXRDAKEQ6za+Mh3ysM9oYdyqh8HlYCTMUOVZHKfApBSHjSj3lEVa+ELpFPqPNls
         5GBd6HunStmDsDs9ZC6/sbmgCeAjcP7F8N1p2wD3fkAokTPBy6rXu+A13CNUuO3DBn3p
         KVmvgPZVz6Kxy8Ed2PMAz7UUH4OENeWfPg2ByehUUs82bgPv6LUGh1u6T4msjx0N7c8x
         +/GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793450441; x=1794055241;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Cxqf9Bqorso0fGl5m6PKE59KMlkjDZ4/kjDJmjbnK7Y=;
        b=fzMqZy2+eAGoVXpT/jeftlm+0mFCu2nAV54SpwelfsaG02qmGjdsRfZSum7nY7qZqT
         QIqNBMfgblZQRAMt778A91zUf5uBdEjrIldRwjt/NxpooIgK7dI38AwsciF99bIS1GTB
         nGJ1f/KiAw9aLRWePrk6DHaMHFKyFiX/kQSzUAI8FKbLEwMTIIrEmCzu3/1twDHD7OgX
         K7gJLt97OZHG6HIGLT4NjQqWFEdBB58kKC629IFu0VIhkmdn4P3vVmKizWZNo2krWlkW
         x5g8Fiz3OJcruBXPUNkoxGTzH2/xkTC0PAhgV+dncwchYqtyTZ+q8968yQR1gyUxaTc1
         lUag==
X-Forwarded-Encrypted: i=1; AKwUvBy9QDkIN3CkMvo4NxCwntYYFIZN5eSHlcAaecWtAciRPMAAApALCBxYA5XkMmcxt43pXBqmBstb8A==@kvack.org
X-Gm-Message-State: AFq9FYJsb8ZFO3G5ujO6kpKbv8gkCnHz1CR5TW9N8sw6qbslcwJHKeWz
	1tumraMIRh/zXL/q6NCYfpSQwd3QHkGsmAQ4AdAJsaPlEtoS87tAEuRC
X-Gm-Gg: AYBFou0cfTwoGWMF+p4Sc0PWvo+BpeQuecF1zA+Jt2xGRuLCq6FUB0WozZHrucj8SBk
	+irNhynB/QjvUa5WA64F+NQBwD2Sj6GDHKskg1unvv2YaPiFJmBQ8daz6pWamrjFRgtpplKHSRF
	G/VaEjzhxMYP1ZgxtrLSvzlGx9iSu1QHVfFk7CytmCRzpXBOzRRMyYgJc+GQueXLaYy3p6Uws/N
	D2PaollDpZXXuC8gWhGQdTPTzMmNym9nkmwo5QRFG3IT8qw3By41PAvGoSErmXaENEywNuMZYYF
	o4oQg/aB/EwtxkSgypmNxY9SV0yvNuh1ARdNL3gK/GORafeSnflcLs9GzJHq5ZyAst3d4AtJF/w
	TXUzrh2hq7GCOYK5I3HW4Kq3WGZpLxq4sKIEKrlH5Ln6XXOu31pW1Un89Cj9/mKvEkwGhDEzmmS
	4+/e7v8IGoKJo4lXvcN6au/dei3hly+uXKxbdkUwyLqg8bBEMlanRHfd8r5/lZ9xsnhkEogB7IB
	MThglZFNMhfexjyC5EJP6spKsUeHT7PzHrV1apa6mSJakFWy/lfzQKbRzbigZXfoGNt8VoDF88l
	8rFsMpoaJqE5A4og4KxWBROhirrYA2GGfLtB9rJ7u490+A==
X-Received: by 2002:a05:6000:2c0f:b0:48b:68:594a with SMTP id ffacd0b85a97d-48e6e2e7798mr11167496f8f.12.1793450440315;
        Sat, 31 Oct 2026 05:40:40 -0700 (PDT)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b789c6sm9294444f8f.26.2026.10.31.05.40.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2026 05:40:38 -0700 (PDT)
Message-ID: <57717da3-d309-47c5-8c1d-d4686e8fd8a2@gmail.com>
Date: Sat, 31 Oct 2026 13:40:37 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/userfaultfd: recheck WP registration in the
 hugetlb UFFDIO_COPY retry
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, stable@vger.kernel.org
References: <20261029221129.89068-1-azpijr@gmail.com>
 <20261029221129.89068-2-azpijr@gmail.com> <auWz5tAzi0p6NMou@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <auWz5tAzi0p6NMou@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 40559C0005
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 6sjcbjn941bxkoukfes87speqpsnwka7
X-HE-Tag: 1793450442-402654
X-HE-Meta: U2FsdGVkX1/PhdVnBiyQg5VTUq5H/RZviu2/UdX8/29TWmnCdOCZLa0wsesT1AK34Puj3KGaU8Q0exgWurISUuuJooBV07ADIjTew2mQX2NEuykVmbceYnqga3x2/GcxgPBsKWI0WSWktkXzzdmW++Vl7xc5ddDaNuAikXID6eCpOyg04eqgF6O/2cfkPYPx+3qLSZJF86zURgASNq5d8MuBzcROUa91zgbvy6HYVtmdciGwIY9ETQlcUe686ZJ3Seg9KMHUORLcg71SnMYeehhgWTZeHM6756ouKepr2KW9E6ET4bJYXKPx8klP0PzOLNjgUHe+hLI8F7P0c54bC4s6gkyCxZySk+VQim1Oq8jwb/ilvC376UylV3vR8/wKfMmNQPi4I+eA69yLNJcOIhnV1/ch+0+0imfE2MhGAscCxFDUx/9VUGzH7gQaYBYcpqRUfRTPIZmqusX7lbelp+Nxwp4EaoKT+aRAGk4enG2EXCuX+stqeHtb0Pn6b6BvHgWRKHxJyAbPYDFqG13Lb+CoqDCi5jqBfhVH5ZmZX0WasXncduHjhcfNVfmqgsQ/f+Nf9icYXKAc+cGjmXOzx/bPW65fFXSe+gSEUr7aQ+nrziQsfuGxhVQvzTTWQPithm338ElcYtuEkyDKPBQ/w+jooQBbPdFgcrseWCqOaJiaEn7Kbd779xV6G8O8+3jvr5h2f1/eXoCMZUSjYz/lZNytUKpJDWyvkBimbBmpQdNiviAg3Q9Lq8/6TL/7aCsfy67CosSmHMwF6TtTxOn+/F9cf5rAUeaR2p8NH8UA3e7aD78fRoc29Kk8OMEp35RsQ7NJRo6f6gTthLwph3nWHxHSmzu/SWBNRj+XZiWoTJwv0RRYzmQSkWtOyBVkxRafmyFQd7AoDXXMpzcap+MkP+DXGNx0Q+Rnp+Y2d+R4K97K6G+wqesIvp/JRVQJVTqZTlaFCUakaFzij4v7GLF
 xcdpYkFs
 Pqp86uMIFYr0p/6y6DSOYCb9vNKHFkqXBCU8ipmGWpOi3CL0AKefEHmpZK+M/dRYL1r2aXn41HaPnoi/qKsbc9MuI7wbz4QJNOftVneVABJcb4Q5eXj1ExrcgMtwjN44tgNGl0hvLog2b18PnAWFNfIqgfqyW7EQxmqvt0g67ZM/swJDHsi6ERmUhmiNAwnoIyKiwFmVKwZZaMCrUu0Hx86J1f7AwPbL7XpRahP5evmC2pQOdZUrRRhwQ9rkEpQW/oaftYgRrCvilTQ7h0XAvGAU9/wRtA1hLzAZPRLYlk9OgsXOjEhqW6wClTpeiD05HJ7JEeMMUlDRtW6cW/wON5syvHwl53Fo/S1/jCfWZfCh+dMtNHxxxeu7MFrtxcWO1o0+KmZxCmlXJTMagUpRZUuRoYoiUeEuSAq5woOoEOh1xp9SQaLkOwafypgdPYbW1Ql+eG/TCIQGm/yHHU7fC1B7gLFD6lviWm6ypIxYIDCohvI5daMpCLiTAFHxGYSkq6uid3mCbLZEAvUYgW4akt7A1xA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/31/26 10:24 AM, Mike Rapoport wrote:
> Hi Jose,
> 
> On Thu, Oct 29, 2026 at 11:11:01PM +0100, Jose A. Perez de Azpillaga wrote:
>> mfill_atomic_hugetlb() drops its locks to copy the source page with page
>> faults enabled and then looks the VMA up again. The retry doesn't check
>> that the VMA is still registered for WP, so if the range is re-registered
>> without WP in that window, a UFFDIO_COPY_MODE_WP copy installs a uffd-wp
>> PTE in a VMA without VM_UFFD_WP. That is one of the leftover uffd bits
>> hugetlb_fault() has to tolerate.
> 
> The "leftover" sentence will be confusing for future readers

sure, will drop it.

>  
>> The non-hugetlb retry goes through mfill_get_vma() again and fails with
>> -EINVAL. Do the same check in the hugetlb retry.
> 
> No need to reference non-hugetlb path, just describe the added check.

okay, will do in v2.

>  
>> Fixes: 6041c6917903 ("mm/hugetlb: take care of UFFDIO_COPY_MODE_WP")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> 
> With those fixed:
> 
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

thanks for the review :)

> 
>> ---
>>  mm/userfaultfd.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
>> index 3b71712edab4..a70ecfc8a998 100644
>> --- a/mm/userfaultfd.c
>> +++ b/mm/userfaultfd.c
>> @@ -810,6 +810,10 @@ static __always_inline ssize_t mfill_atomic_hugetlb(
>>  		if (vma_hpagesize != vma_kernel_pagesize(dst_vma))
>>  			goto out_unlock_vma;
>>  
>> +		/* The range may have been re-registered without WP meanwhile. */
>> +		if ((flags & MFILL_ATOMIC_WP) && !(dst_vma->vm_flags & VM_UFFD_WP))
>> +			goto out_unlock_vma;
>> +
>>  		/*
>>  		 * If memory mappings are changing because of non-cooperative
>>  		 * operation (e.g. mremap) running in parallel, bail out and
>> -- 
>> 2.55.0
>>
> 


-- 
cheers,
jose a. p-a

