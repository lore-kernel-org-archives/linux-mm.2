Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44D82CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 12:56:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A71BD6B00C1; Tue, 26 May 2026 08:56:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A49B96B00C8; Tue, 26 May 2026 08:56:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 985D26B00C9; Tue, 26 May 2026 08:56:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 89A8A6B00C1
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:56:30 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 49C14161618
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:56:29 +0000 (UTC)
X-FDA: 84809569698.15.6EA0F33
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7044D20007
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:56:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xnnaurTS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779800187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JU7eq6I2jPDxDfe2T5IMnm9RAHvvxOtoBUIkCy5w30Q=;
	b=wPTGNqtF0TInSS9s0h/crLNd6bYgWuniDNB+ibEZerJLXpeRGCGdyBC8C7qT6K/kwPgEXC
	NxKSHzvnsePW8w3VdwTqpuR3kYApJ4Wt/at2ES02GlxIAtbvr+MLPl+lugDu5OFZCCqD+B
	IpXkdL192vyj8q7smwxoJgaesVSTri8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xnnaurTS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779800187; a=rsa-sha256;
	cv=none;
	b=5EnWbWN3FyN50vth2UyDEICKCIkZFRR4pq+JRK5VgfJKb6J8IdlXn+/2MExviqRsTn9yJj
	3/Q7bQcvhGtb52AEgt7fNfqEIZa6CfK08/StkCgsE5NrTAan9gl0/Ha3uWAm2f+lMr0fRc
	npoKAUxBxNV3WZ60lzMnwjBsYRCmTVk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779800185;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JU7eq6I2jPDxDfe2T5IMnm9RAHvvxOtoBUIkCy5w30Q=;
	b=xnnaurTSzTJdSa9ximYjZKUGfBzMu7x5E4F8xHgkpgw3dHa/cX/0fuMStpiTt/KQF8aHlp
	TkFu/1Jsv+559dKjTrbn8MvXHO3OXjtXwJlkGiCVgZFNZGkCMGihP5MYjhCYZquLdsjAFx
	EOoMl6/aP7XO3g1OCgH+NqURHp+4Oio=
From: Lance Yang <lance.yang@linux.dev>
To: yintirui@huawei.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	yang.shi@linux.alibaba.com,
	wangkefeng.wang@huawei.com,
	chenjun102@huawei.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: update file PMD counter before folio_put()
Date: Tue, 26 May 2026 20:56:08 +0800
Message-Id: <20260526125608.60396-1-lance.yang@linux.dev>
In-Reply-To: <20260526101337.1984081-1-yintirui@huawei.com>
References: <20260526101337.1984081-1-yintirui@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 98jaen3mehxumswftfdig9et9b78esfq
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7044D20007
X-Rspam-User: 
X-HE-Tag: 1779800187-935372
X-HE-Meta: U2FsdGVkX18nCE2BgHdO1BN1AirXE10xq6OEnckcQD/XaRwbyhIE7R8EBgGxeZruuSSHmA41CQp2pgD/W9tqFtjevBW2v4AQ+gQ1ViYpoWsGsyw9AEohErJc73I3vAiurwne1ufFroLrfOzwo3ZiERp07JD3xO5zPKxrlZCQAbC2ydN1D+xQFc+yYfnLDV80768AKFNYL8JbyLuZQCzetFIsA7mgfwFzG1gcEBwD/H+hCSF36R3Lg8YVP1RetimmpZPJCCu8BrN/7vfwplSKeUSs/5dfab0hv34cdkqE2tm+TiEP+Te/V0BjVvTk6h4eZfV0Tm8MNsKedSz0gy7JRVPuNgRSSf8Hiu8XtReWmzNJ9E0tSlyWOQZzvcYLNUL2VdX0kuT1WB0uhOdbKz43RQEtnNrk3EJOk79a2ExFaQeBQz2qo6wPA0MGF7ZOfAGCxDy75FL8D5eRmGl3UiJ33AudEME1My3iYpR7oV4gkkdKh9JfXTyGddP7U11jqKQbwQLwnQ2yVPysyku5y1Co6+J3sdL8FEQ15IhCodQ1jPbwps77BQHSxLMdSNWTDw0o6MIElL3Cv/b3EbcL6NbUPH9t/7VBI03r5QZP4ZQcrxgc1lDdJMh6PSDi4rnqhpDGyfsFCV+nVklxsX4zKp+kEkj/GLtdPY990ahdaAwfjgA39THDusSmzkeblfWQ4VPHc6DBPTnjCJWzw9pYEDTrcdORvPeWgRtPGB9GQW5VU8AH0MuZfchWaOCx4zieSY6xl/DTdNf7RcVc10ezxvGDML1hnaGVuic4KzNZWK+9p56KetervF7BwvvQER+KmwL+JLuG2T+I75wXlH3yCjAIL0WW5qwV9TBImgXzAamkrMLMHp6k+zxCMlf7YTWOr0YIrMIYFGZqZGHn3vavMxwbLvkAZyfST1/twVAVAHRwB9zlfBlpX0SP/4ByFQpAnPcXT+d7lkb5ZkjMZYRntY7
 3MRLN+MW
 LHu+EnzNbNN+wgqLhygqdxaC62xfonHWV03MIdmj+vPp5TE+DLEHU7MRiyyavi/SftxsdvtuL0TCl6WtZ4EOg4Ua0WWoKpAAZot42rEKe4752+QRQwOFNq8raDOx0XJjoYj2F5G6q03ggdd6vfbBuTRUF8CnNTPCk8NFyznDWgUYbYiI9S8r4x7/qY/u0fx/ubO987tpPlQwEc5SdlvtgzuyPlxTbATPsX63fSG5pvSonNMQ+zS2C3dWWvmqhLnqNVg6kZyIBzDYs/RobLwbnSe8JtMkRKK/oPEI43tWGI08wpRc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, May 26, 2026 at 06:13:37PM +0800, Yin Tirui wrote:
>__split_huge_pmd_locked() updates the file/shmem RSS counter after
>dropping the PMD mapping's folio reference. If folio_put() drops the
>last reference, mm_counter_file() can later read freed folio state via
>folio_test_swapbacked().
>
>Move the counter update before folio_put().
>
>Fixes: fadae2953072 ("thp: use mm_file_counter to determine update which rss counter")
>Cc: <stable@vger.kernel.org>
>Signed-off-by: Yin Tirui <yintirui@huawei.com>
>---

Thanks! Feel free to add:
Reviewed-by: Lance Yang <lance.yang@linux.dev>

