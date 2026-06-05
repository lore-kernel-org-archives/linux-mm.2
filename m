Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECD1FCD6E5D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 11:38:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1925D6B0005; Fri,  5 Jun 2026 07:38:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16A886B0088; Fri,  5 Jun 2026 07:38:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 080C16B008C; Fri,  5 Jun 2026 07:38:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ECA906B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 07:38:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8EE791641B7
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:38:39 +0000 (UTC)
X-FDA: 84845661558.30.C02B48A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id CF4F018000E
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:38:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BNy6ftJA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780659517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hk6Cdaq1vDA1FKg7w+fi/63xjHZurL3yEZTMwESU0Ro=;
	b=PfM9E7UPrh+aj9ReSeTexR6z0TiRSECeW7dCUqX+F3TO7kG93uWpxi+cjuYj/7KPw2Sx/R
	nqjggufs8hYeTOh5AC5eIA8NuQCq3hd4f8v0+ydzKTLIv81JMFtJJvti8OVwQ6psL/wiR3
	Hl9eHJxY9UPeTqesLPHuGuRosxarqXA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BNy6ftJA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780659517;
	b=alE+wdxbhMKPq9YhrVCFRk9YI5sCTEYAiUxddCk8IGxlaGb+hvVqtI1rx7LGbDvBgCSJQv
	bs/jG6kPvcFWwVqJlVo/buiJ2WjY5QTEk+p4QsEvLAgX5u8+pjz8/nN7+7KeCs94NtnP/u
	Xp3IplpUUUZWgAHlyPCU/vVxJSHfKsQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 483B6601DD;
	Fri,  5 Jun 2026 11:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3098B1F00893;
	Fri,  5 Jun 2026 11:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780659517;
	bh=hk6Cdaq1vDA1FKg7w+fi/63xjHZurL3yEZTMwESU0Ro=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BNy6ftJAwVHg37IYpk5Rv//MNKo5MzbM0y/uXf+gMVfqipFvNqQqbMAmBZfdu1VoF
	 Iceg1pOY3uUfEjbQgLbNwQhVN9sZ/bRQ5CsvQC48QMRgE0pnhv+UFibDVg7KOSZOpm
	 GwD5jeLzDG0h8BYYGceo9CgjFE5booO4aeafj65eHlnXp2p6XENnXZrQmSzWaIxJtl
	 zpAL/OXvw86PTx8iWpOgzPXPqZpu9mjpiy1iTPS6BQ1g+UIgeLTMwKXziOTmzZjnI8
	 eHhsMne8cBeDpp75AJfSj/Mg3Q9szdQB+/lkJZxEcGeYqnm+JtjNEU/fO29nEV2bWQ
	 zX749eAX8p1mg==
Message-ID: <6963083d-6725-4081-b2a2-894a0510c6fb@kernel.org>
Date: Fri, 5 Jun 2026 13:38:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/7] mm: selftests: Add shmem into memory failure test
To: Lisa Wang <wyihan@google.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com,
 vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com,
 tabba@google.com, dave.hansen@linux.intel.com
References: <20260602-memory-failure-mf-delayed-fix-v4-0-a5bc7db5a9b2@google.com>
 <20260602-memory-failure-mf-delayed-fix-v4-5-a5bc7db5a9b2@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260602-memory-failure-mf-delayed-fix-v4-5-a5bc7db5a9b2@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: xp135rm135yw895k1y6o6jtkiddm63y7
X-Rspamd-Queue-Id: CF4F018000E
X-HE-Tag: 1780659517-62172
X-HE-Meta: U2FsdGVkX1+tR4RtqTr8PC4xpVgwdNqpVrj2KHLcNfjPB6wWdW+Mm9yK7Mn/7bQC5thdFoSNE4ZPfAS7dDW8VrhJTYCfLtC8j2vjUXEu2E20AYSSIiKAbxD9s+v1R0AIjbWawIdzpBlcZMLxHZp27ao8OTQF0DYNyg/KHsaJtX/u2cr3wfoS0XIYd2WFmOf6Obzyku71qGiBHDwpiCoBzvV/N87ZSULQRwlyerg7JHogde4f0+nYLvnd5JUZ3d0EQxzbEA3LARRXPrLdsDjsIyAgVnZlQojDQG6NBHtlX3Zmw1HEL2ZRqemGpMCHcf9eGexqdkygiLpq8Hfhmg4QlXr4o0fM+ahoXEHkMCJYMZ2tcdtKHDiYaxV3z9l8VbO+QG52skxroC0vZYBhpBa6S4yS6CWXaPL050ktKD2TTefb9b5WW81Wwa+MpA6xbpYLvr9Xb5KSGlbqSptqKPqZvTi/2C3aRYzjUHNSvH0a9E/FNFFwMVaLqvoBw+29JAihydort/s+FuNGuERFoST72PLQn+Z6gHQtyspjCesa96BK1tW+mzaibGWHNer6AuKAGlcUuI22UJpuJWCD0FXQfu6yZtXcfTNi+9rKRLQAmMg1cjyF8pmaczXA451g2H8uvYXw+aW7Yp3QFGsZ25UAFl3iMnAu/7neNfYNA+B0UoSlSVbFqVbNdRSIc6pSfQWRVMLfbkE+xol1wODK/tD3NnxkE1CXDXpoROqgJhEXnkOb/V/TYbGEbfsm3IlXKm9vZJnMSlnEO+OGKCO0kAbddOIjD3Sz2sfscllJ+8BDzrVxyupL0wxJwGA8vdcRuwuqC4javjOSijh0Wk0cYIExct9gf2zItTQR4UzKPAB48NQ3C03fDk7mB/N9SXXYzgl3TiwulbaWuSDBfJCue/qnHs5RIPT6ew5AUZSKbu1wzmL3o1GkTdQf+gag1MEwA2dAzt12kLMLdzlLEBlPf4t
 Oq/scXpr
 Ivo6bFIRpi8hKt8zBUg0V/Tb2kAiF0715jXoLzHoOATNO/1hvO0ksyduewCdk8GW5mBCZ6q58U+WDToGqK4lcxCeL+kgKLa9MogCXQcSvxKLgxrkR4KJWQ0PMNsM1amFXmbwCh96hW6oGBMcZWrjmeE2s9pnaOWcmscqd8vx8n5mL1LRJtBNU3SFKnDYg164dX/kjVG6OBMMUNhckM4FxF2ntx2FhPKxYH86EBu5GfNywXBOUUPgs551l7pSiw5rBFjFa1Y9oiW8FFAm7IWStpNiLy5ExqmlApuuNBxR1C+1mBOyVrwDSGPIF2OhpJ/TGLr3lncNeGW/HoH0nqEFTewSlxlAQ3MIS+YiFx2j1gnrUIq0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/2/26 23:55, Lisa Wang wrote:
> Add a shmem memory failure selftest to test the shmem memory failure is
> correct after modifying shmem return value.
> 
> Specifically, test the expected behavior under various scenarios
> combining page dirtiness (dirty vs clean) and failure types (hard vs
> soft):
> + Dirty + Hard: Trigger a SIGBUS on injection, and trigger another
>   SIGBUS when reading the page again.
> + Dirty + Soft: No SIGBUS is triggered, and the original value can be
>   read successfully.
> + Clean + Hard: No SIGBUS is triggered on injection, but trigger a
>   SIGBUS when trying to read the page again.
> + Clean + Soft: No SIGBUS is triggered, and the page can be read
>   successfully.
> 
> Signed-off-by: Lisa Wang <wyihan@google.com>
> ---
>  tools/testing/selftests/mm/memory-failure.c | 111 +++++++++++++++++++++++++++-
>  1 file changed, 108 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
> index 3d9e0b9ffb41..43949b3b3565 100644
> --- a/tools/testing/selftests/mm/memory-failure.c
> +++ b/tools/testing/selftests/mm/memory-failure.c
> @@ -30,9 +30,14 @@ enum result_type {
>  	MADV_HARD_ANON,
>  	MADV_HARD_CLEAN_PAGECACHE,
>  	MADV_HARD_DIRTY_PAGECACHE,
> +	MADV_HARD_CLEAN_SHMEM,
> +	MADV_HARD_DIRTY_SHMEM,
>  	MADV_SOFT_ANON,
>  	MADV_SOFT_CLEAN_PAGECACHE,
>  	MADV_SOFT_DIRTY_PAGECACHE,
> +	MADV_SOFT_CLEAN_SHMEM,
> +	MADV_SOFT_DIRTY_SHMEM,
> +	READ_ERROR,
>  };
>  
>  static jmp_buf signal_jmp_buf;
> @@ -165,17 +170,21 @@ static void check(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure
>  	case MADV_HARD_CLEAN_PAGECACHE:
>  	case MADV_SOFT_CLEAN_PAGECACHE:
>  	case MADV_SOFT_DIRTY_PAGECACHE:
> -		/* It is not expected to receive a SIGBUS signal. */
> -		ASSERT_EQ(setjmp, 0);
> -
> +	case MADV_SOFT_DIRTY_SHMEM:
>  		/* The page content should remain unchanged. */
>  		ASSERT_TRUE(check_memory(vaddr, self->page_size));

You should likely use "fallthrough;" ... unless you are missing a break; here.



-- 
Cheers,

David

