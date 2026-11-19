Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 655AC606A32C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 04:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=RUHc4HPK
Received: by kanga.kvack.org (Postfix)
	id 5B1766B067E; Wed, 18 Nov 2026 23:36:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 562A96B067F; Wed, 18 Nov 2026 23:36:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 475E86B0680; Wed, 18 Nov 2026 23:36:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C69A6B067E
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:36:32 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0190F8096A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:36:29 +0000 (UTC)
X-FDA: 85450607340.19.3CE2DDE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3EF021A0005
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:36:28 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RUHc4HPK;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795062988;
	b=NmscnwSH/5n3cbc57pl0xT20M1AKjzP5I1v0DfC2RqGcpjxjbJyFO6W6nyML2/2jr8Xg3u
	sNBVMgMT2yCwm0uuzpR3/mGL4xjaK3DLhXBOrVioAbZxB74yh+f069VFYFxaYXXUBF6Z6j
	I6tRrpg/VU9Sq0GOpes8KBgm9SFucNc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795062988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3jfCZy6SiWS7DTdY9KnhR8HM774z4oPEC7pkYn58qRE=;
	b=FAYbLBPz+7hmxqv0YccejxQeB6VEosSp2v/RjHlsoc9Ud1UHHAy4QjL5mp8OJSxuVLE1fy
	c/6w6LaGBhY9A2kydgunlWYUzH6TKeESeWoCqMbR6YMXsQno+okM4thQGRMmnJ05RQdf0J
	17isPTV0yt0gQ1VSr31tQqKLYJlvigc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RUHc4HPK;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 42606152B;
	Wed, 18 Nov 2026 20:36:24 -0800 (PST)
Received: from [10.163.128.149] (unknown [10.163.128.149])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 70E083F882;
	Wed, 18 Nov 2026 20:36:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795062987; bh=neGOr0hP78TEIQZkJ7PN5DflwqzgDrJbonprN/ve+C4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RUHc4HPK8NvwYVieJPbxLpzyc1UPVo50Jc0n+9Tw4JPOVnao93AOPr86jHa7+9oub
	 OMY+sfwdMJaQ8hyFB2pbCWG+rp0l73PyE5X/BcrKuFGY/oefsSc8jxVKuqA60Vf3zo
	 TmdVPdA1ZDKOjr4GNkUdxNzloFxw8zQzuCcwaYtU=
Message-ID: <dd4aba07-f533-401a-a5a6-22356f09f868@arm.com>
Date: Thu, 19 Nov 2026 10:06:16 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v2 4/5] mm/zsmalloc: remove unused zpdesc_lock()
To: Shivank Garg <shivankg@amd.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Minchan Kim <minchan@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261117-unused-sym-mm-v2-0-2f845e94dd50@amd.com>
 <20261117-unused-sym-mm-v2-4-2f845e94dd50@amd.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261117-unused-sym-mm-v2-4-2f845e94dd50@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam07
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 3EF021A0005
X-Stat-Signature: 6o54nwr56c4kpincskft3maww4io6uu3
X-HE-Tag: 1795062988-954908
X-HE-Meta: U2FsdGVkX1/i+ZxYAIwES009W9EtQ8aZsO10lE4h52Gg2MUoigS5Yw9DOV8fX629adOltc/u5hgRZAdl4d+AAQy7Et6em3OtBmm2vdgCr75vYsm99O76wmxvWWbDfReAqKsLohlGO8rf/WgU1IE0b1pWtyZfBdX/h/dj/hJBvhwNOBjya9MgktV2go6gAkPHd9ojZG/W8CIVWLbTGDYxiuopOMkaEVBdoNIZnwlgK3GMt0zkYQ/W7X6LXIST8Vrwui+AToLyEC8EdrxdQVl9R7KTHKK9CvY5ZAFQW2zdHVWypP+/ptYUWwfhZEOym3a8XVN3Z0k3guv2/unWT8BsjMs39x0nv3lFAqB2KRU90ekPIfSP5/qVAfQ4ROLjk0HSdn/BurSvAe1cw01d0ZGWAn5qLmbyK1Ksf18NKZ08qNfpaSzo4rTqyVA2Glvm0G3lMGBRvvwkT2XpPcZi8Q0Tz8HOB0Rv7R2p8yog7nFTi62xB2wkWE4K4HeI7JLOXTgOzs4Imp+7mHEtOtBhbBUkkdPp6J4vz9CsGquZiNJ0rm7R54HnF+OyV2ciNFQFLkxXRh0kRQxcR0PsZFNTfQrB879KhgxsenDsPcGYgpwDDZLpFR1THT7x2uZfuLa33vnvOhHnWVMfMAdCNGUP1nSf8OGDmGSOWLw4XjwWV28E9VD0QT39FCoeco8EfYwMuSWVydQOxBvgBqM1+pJOf0tHTZakosjNYuNZRY+x4VTjFHWX2nwdHmFR4zRfk5JBzT3IgW9o508Gs2xNn7pjZfxmP/sC7FQ7ZC2nXto26DxuqZB6uDzzreO1qaXMKzmNKqRylMwNaxIeCaYpLGUS0nWAb5mVCF5NPY9hCJ2WglHSYV9KUlgVPy/mzCug52m5NrIvqo6fVzA5e8rVwCnrm9CkV4HkG9yS65dPKvfxm8Tb2+B9O+57Vj+MiLv/sH2v/8uUeFZ55GeRyV6DpqcboM1
 sH77T/3m
 /FLbkehZmd1E5d7mSGS0JTNftBxtOxKRXsNVQ5KN3RVMQrPUyw0ymAGkKR6MFAvTjhr2cRwWdKFuW42z49GqQXLzDKv2XwkPf1ygcwu7ggdxcayNRZZh6ytWd2WlDBsGEU8wcR5fG3SiaemqdN4Ku3rjg1FbDXgopkGIZX7ltB3G79atVOv9tu96KMjNKmCBr+YSC+8knqc061sroYGVyzHB6lu4NRmLqZ5IhGOgLPcIr2b+ROOR4jkoegxVvNdYoGM4sWHAzsnayzFuVZyqMaA8Lk8UiCib3sXMnbUIGSafZ1w+YdWWB1SnYrxLrcDgMEY74hhKIMxDO03wHIB8/aeQa1HKE7HVaR5qqpYnT9NDykcviqWHHvCXGeBQkBqtNRtqILe6uZTuGshE/vhaPwMLMdBJ4NT6cuk3y2oL7VUXYWrB9RCjWrdz8C6HSZyHdCvg6QeVQxtZpwqZ/TcSe5wr2wwnYDYyCAV78BUI2s00Wr1SoC8xcSx0vh/Kb7dCHey+u+QJIu9tCf3c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 17/11/26 12:46 pm, Shivank Garg wrote:
> It was added in commit c1b3bb73d55e ("mm/zsmalloc: use zpdesc in

This was in late 2024 so seems fine.


> trylock_zspage()/lock_zspage()") but has never had a caller.
> 
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>


>  mm/zpdesc.h | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/mm/zpdesc.h b/mm/zpdesc.h
> index 4fd81c2e8076..aaab5f1bfb52 100644
> --- a/mm/zpdesc.h
> +++ b/mm/zpdesc.h
> @@ -107,11 +107,6 @@ static_assert(sizeof(struct zpdesc) <= sizeof(struct page));
>  	const struct page *:		(const struct zpdesc *)(p),	\
>  	struct page *:			(struct zpdesc *)(p)))
>  
> -static inline void zpdesc_lock(struct zpdesc *zpdesc)
> -{
> -	folio_lock(zpdesc_folio(zpdesc));
> -}
> -
>  static inline bool zpdesc_trylock(struct zpdesc *zpdesc)
>  {
>  	return folio_trylock(zpdesc_folio(zpdesc));
> 


