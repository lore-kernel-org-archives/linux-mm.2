Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D555606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=re8ycFdO
Received: by kanga.kvack.org (Postfix)
	id 2F69B6B05B0; Tue, 17 Nov 2026 21:40:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CF576B05B3; Tue, 17 Nov 2026 21:40:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20D046B05B7; Tue, 17 Nov 2026 21:40:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E79436B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:40:18 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5941D1A063A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:40:18 +0000 (UTC)
X-FDA: 85446685716.08.6C94BFF
Received: from mta1.migadu.com (out-237.mta1.migadu.com [95.215.58.237])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2631F100005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:40:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=re8ycFdO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of luiz.capitulino@linux.dev designates 95.215.58.237 as permitted sender) smtp.mailfrom=luiz.capitulino@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794969616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pN+R8iE5mrilm1yEawpmQGcShEPtoVSRmY5LE/o+UqM=;
	b=cO0eu4IKC47oXv3ud7n2B5sPlnX79Eq5XFU2KAXicbnwqeb8fCbTkps9DWnarfJIgIe5OM
	0cevvP4CdZtlDAyytWyJ+Ub9bzSobQ+vx9pIlIm9cQmmhEQqx6WG3pwKzd9oe0ogAw9vpe
	2yyFBUkxLnlPRsaz8xvxV8R58vuz7FA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=re8ycFdO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of luiz.capitulino@linux.dev designates 95.215.58.237 as permitted sender) smtp.mailfrom=luiz.capitulino@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794969616;
	b=e61BDFIRbHmAAcK99m8bWTDWu6BxWX8+K5pGHJr346NkLim7WC3UF6q1H20UCqCbpgFcPr
	HSLU6eD0hqrk8ejf2fvUxzG+8vhF2HdmVrOdgOt3T8IvP+RJPfBJLul7V5YCkpo3bcq/zf
	XV7VXCgasndZxL7lUUTyDA6Y8JjfAfg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=0YmCdvKvcbyA+q3izi5xAhGTNdvmCrKT8RtQD9KuPwU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794969614; v=1; x=1795574414;
 b=re8ycFdOaNbBIiMScTaXBZ6twyyXjxZvbfz90jzS97241xxo6zZdTBKsC3y+khI9fI0CQwZZ
 3Uh0RQ2ASHh1yNf93MMMEDBtvj1up/+cwHi5zQtvwb0iIjCTwIEIqP0favDb7UP8kgENez/AfJf
 wq10XozYV0hLlgmuovDwiKXE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ab029116bda70b98;
	Wed, 18 Nov 2026 02:40:14 +0000
X-Mizu-Trace-ID: ab029116bda70b98
X-Migadu-Flow: FLOW_OUT
Message-ID: <2c65fe4b-bea8-45e3-b51e-352139769a59@linux.dev>
Date: Tue, 17 Nov 2026 21:40:11 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: shmem: limit forced anonymous shmem huge orders to
 MAX_PAGECACHE_ORDER
To: Jingyi Sun <1045704958@qq.com>, Hugh Dickins <hughd@google.com>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <tencent_1B8BBAF215484255F04168752D9BA778EE08@qq.com>
Content-Language: en-US
From: "Luiz Capitulino (Red Hat)" <luiz.capitulino@linux.dev>
In-Reply-To: <tencent_1B8BBAF215484255F04168752D9BA778EE08@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2631F100005
X-Stat-Signature: w9q5qai8cifszdaepj9hwx3ife49jcfj
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794969615-746455
X-HE-Meta: U2FsdGVkX182WoTOCr60JAPeoMLZt2bPcw0iF/B+rya9NCNGkViw02zyEmmzmZIghay/8lPTRTs+i4vvnJXsoBHcDIViKFYr5CXZAExANIOhUJLUWf7v4qs5dhjpcYgip6jffWEhAu49TBOBd5YY17DV3mrLm7aN7ntjsZt+7hp9U+zuu0F9vHBEnXZJcIHqWLbzSjyIWbCiXIY922pSUqZTrqYf+BBOdkfYXr+FT7ah0dxUeugqXTUuy+g2hHWUlsGY5aHG2WB+18A7potKbOSexA1EtIMcFVetrpmXhzP1guUtAlbqmV9BcB9VfUJUUalpeMlPE7LVrTVNWLzBrp4BQT5Qy4CwQo+KK0xJ281RkaVQyB85MyE9dVL/+Fyle4lfllu3h45qshCXqH38W40SmcsTRCQku1nSExfuuBzUhNTYYfhfPaLsmoM1Z7ik1Zef2LhjJoysU79NMZiD1D/f49RE4mkft17hqLEKqVvdYaLiyq7HCSRnsDOVM7vrypWUWzJCH5j8s6uKHJJIGeYxLRp/tqPE+ngya7LWgbOe8UjCruEFyz0Ama+aHj13ZIBiaCB4Cex2e+GYoiWpuyWe4ARuQBcWZ2n0+UXmCONDS8Tkv4rQ26Y1ED2YMWmidzmwkIfgGw75z08MKDSRqphVB7hu0t4ZTwPISKm0qZJBDdcvaoTTgi1inGxtmw/UqUYGGprkhSEr/+CLvpzCCn+O8NhOeEQIXDYJZaAqO50N7pp07isDVsuSahJsYA4fmsF7POSdhQFwgMQ5IxAraYCu5mRc20Bk0VyAw244jyDsT142QTHrIR4xR/zDNIbBHAXER15wZyXW8k6VijcoGbRraVahE0LJ0ey+MxiWIbbKkpGr+Cy5ykGOD1M4NeFF3wLItXxj/qa/j1CGDNbIM2nn5WEVoredfushpfltdprGOIbmLXhkDvppe+ma4hdhO58kbP9qv1WGowCb/bf
 6+k34apT
 hkbGzewFckAfBUEOacUD/0uXSPJkxu1aJ/vVbAows+e73whlrcrA8bTRxxp4RU4J7ZQf1KDP+mMP10WzRsLcBiZt7CMnVavnMnS80lQ2FweMk9jMoVI2hCzw5I2ls4PdYEUKFZpgjNXbLtx1TYfv7ZaPVJ2KPaJtNYDasVvOQ/qNM7JpYrSIVOJdjVLrpXLsyOLykWwwZUQFc5qFpMIExBwrTDOreQ+FEKIWkiBtDmK41s/uWylYuXDLAu1T2s+P2vI/Ky2W7/YiBh7coSD+CXfH3aCEQ5JWtZ5saPd1RTdu8CBeuYvnA0rY57/uA94/sw43f+OgQw8InVTVrus6jj7w41+F+tso0PPhBEk9I8Xfh4St6mMd9D2bWs8q6kv1VFrCu1UAjhlMun84=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/17/26 7:16 AM, Jingyi Sun wrote:
> When the top-level shmem_enabled knob is set to "force",
> shmem_allowable_huge_orders() returns huge_shmem_orders_inherit for
> anonymous shmem without masking it with THP_ORDERS_ALL_FILE_DEFAULT,
> unlike the other return path at the end of the same function.
> 
> huge_shmem_orders_inherit defaults to BIT(HPAGE_PMD_ORDER). On arm64
> with 64K base pages HPAGE_PMD_ORDER is 13, while MAX_PAGECACHE_ORDER
> is 11 because of the xarray split limit. With shmem_enabled=force, an
> anonymous MAP_SHARED mapping can therefore get a 512M (order-13) folio
> in the page cache. Splitting it later, e.g. on swap-out from
> shmem_writeout(), triggers
> 
>    WARNING: lib/xarray.c:1051 at xas_split_alloc
> 
> and the split fails, so the folio can never be swapped out.
> 
> This is the same problem that commit 9fd154ba926b ("mm/shmem: disable
> PMD-sized page cache if needed") and commit b66b1b71d7ff ("mm: shmem:
> avoid allocating huge pages larger than MAX_PAGECACHE_ORDER for shmem")
> fixed for the other paths; the force branch was left out. Mask it with
> THP_ORDERS_ALL_FILE_DEFAULT as well.
> 
> Reproduced on v7.3-rc2 in QEMU (arm64, 64K pages, -cpu cortex-a72,
> 4G RAM, zram swap): with shmem_enabled=force, a PMD-aligned
> MAP_SHARED|MAP_ANONYMOUS mapping of one PMD size got a single
> PMD-mapped folio (ShmemPmdMapped: 524288 kB) and MADV_PAGEOUT
> triggered the warning above in 3/3 runs. With this change: 0/3.
> shmem_enabled=always and 4K pages did not show the warning. The code is
> unchanged in v7.4-rc3 and in mm-unstable, but the test has not been
> re-run on those trees.
> 
> The issue was found with a research static analyzer for
> cross-architecture dependency bugs and confirmed with the QEMU
> reproducer described above.
> 
> Fixes: e7a2ab7b3bb5 ("mm: shmem: add mTHP support for anonymous shmem")
> Cc: stable@vger.kernel.org
> Cc: Luiz Capitulino <luizcap@redhat.com>
> Assisted-by: LLM
> Signed-off-by: Jingyi Sun <1045704958@qq.com>
> ---
> Note: this touches the same line as "mm: thp: always enable mTHP
> support" (Luiz Capitulino, v8 14/14), which is still under review. That
> change masks the force branch with ~disabled_orders but does not add
> THP_ORDERS_ALL_FILE_DEFAULT either, so it does not address this issue.
> Happy to rebase on top of that series if it lands first.

I'm late with v9 so no way my series will land before this patch, but
thanks for the consideration :)

> 
> Link: https://lore.kernel.org/all/752f528f0fed5cdc9de12b54260b0495d4e5a6cb.1789695931.git.luizcap@redhat.com/
> 
>   mm/shmem.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 10cef89b00b0..41bb3f2c6b63 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2114,7 +2114,8 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>   	 * means non-PMD sized THP can not override 'huge' mount option now.
>   	 */
>   	if (shmem_huge == SHMEM_HUGE_FORCE)
> -		return READ_ONCE(huge_shmem_orders_inherit);
> +		return THP_ORDERS_ALL_FILE_DEFAULT &
> +		       READ_ONCE(huge_shmem_orders_inherit);
>   
>   	/* Allow mTHP that will be fully within i_size. */
>   	mask |= shmem_get_orders_within_size(inode, within_size_orders, index, 0);
> 
> base-commit: 666539eecdf4db623f5e3c3e55cf9f2dfad24aa4

