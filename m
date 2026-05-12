Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D92CCD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 10:33:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D36E6B0088; Tue, 12 May 2026 06:33:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 885496B008A; Tue, 12 May 2026 06:33:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7737B6B008C; Tue, 12 May 2026 06:33:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6561B6B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:33:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1394BA0434
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:33:30 +0000 (UTC)
X-FDA: 84758406180.08.A53443D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2A4E418000A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:33:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Y/Vxo3C+";
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778582008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1/AkQn6aNTWbDIKAEgRpzV1nAVab/rVrIMaz9o14Mac=;
	b=iYMK/ob1VE0ysAFMfZME6EF1Sg/cmSoP17mPLrpoAgYdRR/B6nQ+lQ8a+1Cn5fRdds7mir
	MEXlTqtXMJvBKT8dMrOthi9ZV7jv7rVbNgc3YHOv20nA9gSbImujEX1eCvm+LlVWgUJBXC
	3x5ffd4sTEbf05Pqtco0z1DDh+bQoks=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778582008; a=rsa-sha256;
	cv=none;
	b=7SIAjs589k5vcPrvMxCaJYrloEN0IepLjX4pN6F4H0CQ3UK+GKGG+/tb2/8Yf//9vCRgLi
	kOSiC+hpNW/tqipa/FHbPK/IziMREb1c03bSvBiagKLi8dZ/02FSd7wcCb1lVa/Td3Kq9r
	OSTarjS/4wR0ElvIlxwIqpVTQTqn4wc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Y/Vxo3C+";
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E4B4A40AC7;
	Tue, 12 May 2026 10:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9B4C2BCB0;
	Tue, 12 May 2026 10:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778582006;
	bh=zPN79Sp5tkE3A4QCi7z/wN174n4BH16kLNOdDeZXevQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Y/Vxo3C+RibZcF3/vWqMPrv1YM6BRa7y2b3fXs7jxvjoPz6rlm3z0HYfXuHZW/Skb
	 Y7p85Dhn6jtjtgTr4ZToMXXE/pF/megwQ9L5kvINbyJi8z3afNQeCz4N4b5s+/ryhx
	 220NyB3Cd3EeZZ8ebZpXKVxocytbn7AnEOL8yoL0NttY7NQEbrXCBWhJ6BzvIyeCcU
	 ujNBgIEiSMX7ksP/k2jHl4dM/rAvnfdpcz6i4ubcgLaAtiqZwS0RGma99im0e62nbn
	 5rHk7AYNxRplE007JV/AarmwIyCt/9M4wjkjkPRKA864GA4Cqlr39N+zUSSANM/xaQ
	 KrQM26XaTZwAw==
Message-ID: <ca19839f-d7cc-4a4e-884d-272509c38d8e@kernel.org>
Date: Tue, 12 May 2026 12:33:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: Fix mmap() return value check in
 run_migration_benchmark
To: Hongfu Li <lihongfu@kylinos.cn>, jgg@ziepe.ca, leon@kernel.org,
 akpm@linux-foundation.org, ljs@kernel.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260512101305.139509-1-lihongfu@kylinos.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260512101305.139509-1-lihongfu@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2A4E418000A
X-Stat-Signature: 958kji88r91w36tcgsy8crem7pz3zuch
X-Rspam-User: 
X-HE-Tag: 1778582007-818966
X-HE-Meta: U2FsdGVkX19TWZx4OW8vezb46/MFIAEJ0uHrtD2qUttVO4lI0IkBKvBa7WLJPfTnXTRd1Wsw8xtJFFxTqpvhE4Izaj2MQQuVcd51Quck4ZEWi9Om1sh+pHHu2NdQM7SEgO/trtuqyxZI6ZFssLReqlAi5IbK4rn5KMtx3JL1pYgJJ6X1hgkzIhGduSahgX99pQlQXQl47n5G9sJqiYIKZA0W2c63DMgh3G7anIwB+DyLFwFPHUl6dwNC3bOkOuZt90KTH4xwxR4ul9Mfns6ysOXPa9Ra+5R/vSOskRQPGECgCzxmfYSyQC7BS9PU82OFBnSVe4u3CcmYJmEW0yEbW3VF/Xrmbi5TUMvwuklvexF9QH6LmrAhaLUcLevKyLii55qAdizGzUhGJe2hAhGuzZXJU10oKPUR2edZlC+TagdPI9CzyExMNVpDRLISBU3JtsMGm9KqQV0/EIwRsS43AyMHTx7a5fynqZIGw23fTMol375cRsoN0GnDIyhdoOgMpc6apN93NSrEE42sOOafmM1QG73ooA7dV4RC/ALBCH2JLKE+9WEYJa33mAWXZ6dIqniuqLO7KLTBG4/+rIBENEtCp13XKotKZ6qW+7JtgS2gdWllfZdI0Y8HaHejS10mbTu3yC5zl/t3IZWjp0UInuNuUB7Ga41u2hdSllvXQE81SxoDMHTrdAkx1yG/Gl2XXCEJ8X+Ay+4if6skBxFA8DuBzWiLKIPLoPFa6qGoXS53l0tFgqAUZSrbDmrBakFSjX3C2kxd617pGzcduGB0QXmi0FyfIMoyyx05dZh1dbq5UykOzMujw+xPGFIimxHAZZNMJFOK/wmJO0ybzjc//tar9xg3Y66e9ub37PpCwNE2kOfxWDOP/2k9wayDPDMmrICkJqY2IKKR0YGfDtXOSjk/0UAvpxoVWVYzxZitnGjJZ8gl9PbfW1ntfOOjkbxvlnx0KGGD2Y6vWUaO6Zg
 UcWik/dD
 T8rkUlZ4Gh9O2DfwMFY8R9PfUG/CvxuZGU9/hFL7Z0oQqoBmizIl0utIdNrzoE1JkDSagwWzCUSIpvFQfWxUjlTdDrmmxKfUNLu8afAJhf4or8AmP90J2otICvsxv2UYZ+tZZ5+X8Hag9sMQFTUNimTAi3NNo+P2rD4W9jT5mAqGk3htrVwIEd0J2my1kM7Hn+iG5LV0qEh7PY6d270K7dOIfleawFLVEKf2QPcU4ASq8101pRIZKspiZshrdmxJBGalTkBXbf65GXxXSJPLxqMgmLbTxIjpgIoO1HytyB63EPUntEX0zPUoBbQMfv5Kr7YfQpUWsT8fDe3Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 12:13, Hongfu Li wrote:
> mmap() returns MAP_FAILED on error, not NULL.  The current check uses
> !buffer->ptr, which evaluates to false when mmap() fails (since
> MAP_FAILED is (void *)-1, not 0), so the error path is never taken.
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> ---
>  tools/testing/selftests/mm/hmm-tests.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
> index 788689497e92..d72adba5c74e 100644
> --- a/tools/testing/selftests/mm/hmm-tests.c
> +++ b/tools/testing/selftests/mm/hmm-tests.c
> @@ -2688,7 +2688,7 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
>  	buffer->ptr = mmap(NULL, buffer_size, PROT_READ | PROT_WRITE,
>  			  MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>  
> -	if (!buffer->ptr)
> +	if (buffer->ptr == MAP_FAILED)
>  		return -1;
>  
>  	/* Apply THP hint if requested */


Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

