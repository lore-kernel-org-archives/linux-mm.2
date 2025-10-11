Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02E1CCCD187
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 02:26:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 368B48E001F; Fri, 10 Oct 2025 22:26:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3195A8E0011; Fri, 10 Oct 2025 22:26:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 208768E001F; Fri, 10 Oct 2025 22:26:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0E4648E0011
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 22:26:11 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5E0451A04DE
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 02:26:10 +0000 (UTC)
X-FDA: 83984243700.14.59E6166
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8D2C316000A
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 02:26:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vB0mJX1W;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760149568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=glw7LqX8YIF4goQyas3LH1XhAoGCNP4CDVbcxVzULlQ=;
	b=Ha3pxCxWqbK2vEf0LxpLLrgTtI3gXuVs8RrJK+Y1v1+WOb1R/uOAT9zYKiQNxI3E9R97jT
	rS0U3JK86LSw7srsi20zwyu3Tb52YvXeModFYGGYlE2TnUAcjILsdm/iIZbSZFBXTe7QJJ
	WaHXstlm2nrOw2ZV3i1uvIQJV924vyo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760149568; a=rsa-sha256;
	cv=none;
	b=Y5sKfC4xD0TEZj0Fw6jvANXWE2o6lEnVBFZdeESgwzUla4/v0jptw4Em2ctILn+T136iaj
	48E8/wjhCtbVt6xiOWKP6Ebxe+iSHaZq9Zj27p4F8REVZ1R2QEk3aEcSdkjaMFzaVm/G1F
	sEzNT68No93TrnV0LQWhbgoYEU1YNSc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vB0mJX1W;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <11b98453-560d-4c55-8ac9-43d1cf7b3543@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760149565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=glw7LqX8YIF4goQyas3LH1XhAoGCNP4CDVbcxVzULlQ=;
	b=vB0mJX1WVLm7p2+PYMb4d3Gf9q72xxjJYKQXYBSlGMDS4/eVHrskJn/asTnChLcoJ0RmpH
	mJ7bDtyRWQqx4L7XV0wU9hikly6seWylvUH4KKCX0+/tnHQsTKs/tAQdCEoB5zA13MZOwN
	EBdJA7KzGc6Yh8OqTjb42OHX926M5D0=
Date: Sat, 11 Oct 2025 10:25:57 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] mm/huge_memory: do not change split_huge_page*()
 target order silently.
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>
Cc: akpm@linux-foundation.org, syzkaller-bugs@googlegroups.com,
 mcgrof@kernel.org, nao.horiguchi@gmail.com,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, kernel@pankajraghav.com,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, jane.chu@oracle.com,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-fsdevel@vger.kernel.org, david@redhat.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linmiaohe@huawei.com,
 syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com
References: <20251010173906.3128789-1-ziy@nvidia.com>
 <20251010173906.3128789-2-ziy@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251010173906.3128789-2-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Stat-Signature: 5qn13ybxiw7kdtiqex3sbtuyzqca7d7i
X-Rspam-User: 
X-Rspamd-Queue-Id: 8D2C316000A
X-HE-Tag: 1760149568-704954
X-HE-Meta: U2FsdGVkX19NHosetFqcWvk4hs+jJrkXRISw0ttMf/6xPPPEzalwVoYW0ohIfNRp/x+/NLthXMSAHiJcqtSxtFORNT1Cu+Wte/IGP/gzZyJdY9kayY3Ci95Flsxhb9oBezsPB7GIs0dhlC4meYmlqQ5kktThZhRIaJ/SKnrpj8jkbOjSkz0QTwkVZUhLb7udCPR41RfZ38Ot+09A3yhNHocWqJ4Ug4Qq4WDQGxI7WhrTzANHAdBh2wSUGIzTxLUy20lJxbP+V3aGgOzVIC4CPjk6OwRLF02BUZ1Hjp2K5yLcJtJrG9X4R0ywi1Qs/Yz64dm0jPmfqWQCW5EJeiO2hjBXoJd7Vxqh7vMoKEU8nRm6tLPfRtlYeBdClDC0OHve2TdBCjHzQfXpef48c/Adr1eD8ICiJ1GzndKpvvc1ak0F9AU8589XPjOyCayh5OTRiGdlPHo8EJfz0MncJdUaFH0o0uso+vZk8TtoAinzm/Pm0aZRmv6Nz2mqDgZ6Ri0rTx2Qi4b8bZPtzYZknFk1WZHHQbpwiVb9d/iTLi1ng7M/o8EZX8OF37zhqwUIhujqfV8LYHDnqgENuUjgUChY96dcjZG90qRGsLteu1GdWCiKI/I7vFVUaJcahP3TiH6mc5tc2QVWoTA1squ4M92ZGh9V0xRZGn5A4ZR8inQU7YNy3iQMgLP29U34f5TBC636/VdwXWCtG7jj11lOSx0f34mTtFQiL2ychUU39Z/7tticI06xbdvrjtx7wGRIHj3k9gHtCwxRDfg+ae4w6VDDcC/ttsAClMkbLo12KFo2IJJq+9BI2V2WHMoL9gGh+3C70eNb0M7rpua97GM4OsdneTOOEEZMR/OlnEL/4mrOIcbafnYt5jmBPMpQFTCnqVWKBRV4cijtJxRJMDyIEFsbmvFyeBXkbVZwcu+ar0PwQdt7g7o6zN9I5nxHOtk4bVDbbi6Ud8Gup9SeyLckPYa
 puRFc4HY
 crfkY1a7ZOT1EYG+dk06shaG8qj2nL/wgcXn8EHdVj9sjN5I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/11 01:39, Zi Yan wrote:
> Page cache folios from a file system that support large block size (LBS)
> can have minimal folio order greater than 0, thus a high order folio might
> not be able to be split down to order-0. Commit e220917fa507 ("mm: split a
> folio in minimum folio order chunks") bumps the target order of
> split_huge_page*() to the minimum allowed order when splitting a LBS folio.
> This causes confusion for some split_huge_page*() callers like memory
> failure handling code, since they expect after-split folios all have
> order-0 when split succeeds but in really get min_order_for_split() order
> folios.
> 
> Fix it by failing a split if the folio cannot be split to the target order.
> 
> Fixes: e220917fa507 ("mm: split a folio in minimum folio order chunks")
> [The test poisons LBS folios, which cannot be split to order-0 folios, and
> also tries to poison all memory. The non split LBS folios take more memory
> than the test anticipated, leading to OOM. The patch fixed the kernel
> warning and the test needs some change to avoid OOM.]
> Reported-by: syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/68d2c943.a70a0220.1b52b.02b3.GAE@google.com/
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   include/linux/huge_mm.h | 28 +++++-----------------------
>   mm/huge_memory.c        |  9 +--------
>   mm/truncate.c           |  6 ++++--
>   3 files changed, 10 insertions(+), 33 deletions(-)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 8eec7a2a977b..9950cda1526a 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -394,34 +394,16 @@ static inline int split_huge_page_to_list_to_order(struct page *page, struct lis
>    * Return: 0: split is successful, otherwise split failed.
>    */
>   static inline int try_folio_split(struct folio *folio, struct page *page,
> -		struct list_head *list)
> +		struct list_head *list, unsigned int order)

Seems like we need to add the order parameter to the stub for 
try_folio_split() as well?

#ifdef CONFIG_TRANSPARENT_HUGEPAGE

...

#else /* CONFIG_TRANSPARENT_HUGEPAGE */

static inline int try_folio_split(struct folio *folio, struct page *page,
		struct list_head *list)
{
	VM_WARN_ON_ONCE_FOLIO(1, folio);
	return -EINVAL;
}

#endif /* CONFIG_TRANSPARENT_HUGEPAGE */

Cheers,
Lance

