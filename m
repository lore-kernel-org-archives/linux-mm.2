Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4EF3CCD195
	for <linux-mm@archiver.kernel.org>; Sun, 19 Oct 2025 22:07:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41FFD8E0003; Sun, 19 Oct 2025 18:07:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F7128E0002; Sun, 19 Oct 2025 18:07:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 333A48E0003; Sun, 19 Oct 2025 18:07:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1D8CF8E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 18:07:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8316D887E7
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 22:07:42 +0000 (UTC)
X-FDA: 84016251564.23.8799098
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id D72DC180006
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 22:07:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i5fijdxQ;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760911661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M5DapGrAaCNGf6LLoanaoZsxCAVz28W7/q/W8VqdtyA=;
	b=kosDuJlBC7/nS34xWs80XvoIsBErXgHVu4tOudGDqGGXqs2HDHCz8oBT58AUa+j+cc2Tve
	Lk+IPQWlaBAP5RLC1J0ZEBo3I42yldHvcK79WBuXxp45YoYweiIAjHdm0ASLP114pqoVHP
	sykGhJIEiZPUXY05O7UXQQzYnZsmliQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i5fijdxQ;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760911661; a=rsa-sha256;
	cv=none;
	b=0ye/E0TkVWJ82W8VymUydzpnNrSS5isust6nOTa0ytJL3piRtv4HNWffUk0AqhMd0x8hma
	K++9WGjNzNY/rpgf7u8jeWhR+3/0PGhzQcNkzHvSSTAlvOthMwL0/YAhsykskpWyB+3ind
	4/9qp4INti6Cdx1H4k3+VrqlLboWKwE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 976CB4379C;
	Sun, 19 Oct 2025 22:07:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD315C113D0;
	Sun, 19 Oct 2025 22:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760911659;
	bh=q8rdMG5Zx3wbo2+omTrQi7lo6HmvSS3vFv0SSyGOh5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i5fijdxQxJWa4Z4S6uAlI+goHtVQwWYiV/gMTeqhPrREzKkDAugvFj94DtKxOMenz
	 5Qqspw3m5AiNpvn1qiuZLgIdbTBF/34H1C2QOPIc+hxaOBO7W6uswdqC4QZ+/GmoVE
	 f+KPkvzUmjSQSX/9qTwFZhLKWDwzAifDVYq7AG09nSk8ZEReiotEF1g/rZMQXQX6uu
	 t/Lg1GuAiTxqNgUip5XLo2VfiU3myQik+HxLH4+Ke2NdyWF//IN1oWyr55bBhPIAFP
	 zb6at/CiCI6SPqj4XfRi2dop3s6QFQHVA4VlSkkPpMmKx2qGzUVbk8J8Fep4dUkunb
	 et3ngdOdt9inQ==
From: SeongJae Park <sj@kernel.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org
Subject: Re: [PATCH V1 1/2] MAINTAINERS: add include/linux/pgalloc.h to MM CORE section
Date: Sun, 19 Oct 2025 15:07:36 -0700
Message-ID: <20251019220737.1431-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251019072509.9488-2-harry.yoo@oracle.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: o671kgefrh5x9nq3h9wrkgd5dtuhn6mi
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D72DC180006
X-HE-Tag: 1760911660-74668
X-HE-Meta: U2FsdGVkX19xV26kXdb2ncTqXouu4p4Uce1Sm1NKsmSCZXB+d61IwgkYWgvrYUEQVEhJs5SoPjgYVkXcy7pAcCRN3gVy/ouKn+DzBC+MqVX/z1ZaRcFrPNqCGhOTW82rdku/NXQ7D48HLEGBkxAFx3RVqaBgF8BtCRKe0a2rZs170zfuEljhID+Upa0lsJ4/IvTMlESQuweqlfSqrkHLRs5Z229NofIMP+PrICNrZaQ/w84LtxJhjW30jwB1UEub7IL9QLCMmv9iArQBZhhbmOHCXw8QlzxtpQHhEg65dvtc9CLACr9dv8UUb52v1poLisnouPC7qYgoTC1RPngKC6cQb/v/wEBzeLSIhXSlTj2TDSLWco1Q2bE6V4u6tQHKgCRRQt1V51VTVAW5JFxuwGXwnXPCmKU9yxOMaaKP90Gl4Syt5no4dLp/Z5+9oJRf9OjcpmEpdo08tv5Dzit6j6qFXsVT70rnS1fWXFWacaPuQCRnKnjnZeuOg+UfsIOntJej7RcaexU7p0c3A0J4z6y03YTOQ+MAa7LcFUK3PYcIAXWNd+4Clr3s06W4VW3U47dUcRhdjDnnGcf3RTtTqdN+B6qofgakivDkMCbAWe6fXBIR8iaah0nNU7PMw648Z+VBUkca8SzNi4DeqZm8/FzYTOIokzngJQDsNVTaeXmgQPFKGfD9o44wA5I3JdwLVVmiSu6aDSrsQhuOHAqv3+qkZ46JfBsNpOykuiOshbJc/F16adKDBjayVgJRvijBUDusgdB2wZqWegTdwFQveib93gbNmj+ClsQZHX8+uu/sb6Xv1EcSlC0JkIKy8RVgS2FTfIC9baw5/xqwi4wbAHsKhHkJ8YiTphmoKy5SS+Z0G0y3A2lksjrk4VweveWylnLH+m61KcBDE/EvHoLBKpuY2NQ5kKPzVG6OkFdBVeGB1S9C4rkzfKi6gl5yI2wq6F8eI87m1z/3RXxCLqD
 xv4Jtkkj
 bpG6/Q6wZiqyoNKOQNYMKY75lZ5Xq6srMA493nb++77SBqm0z2+e7rP3TgFC1yYgFKPq04GJA5jaXj2prxtmIsj/OOBa2lSSx1MNR7s0z5RuAU65WdSKPZBsZAcHcmyZL8BE6NmW1+md0T7nQ2IClGA/jnZYF5ZEooMN3wcYeA640jhge90r/qkCsRVzfQVZGV3bTPr3TxWdeBwTjtH6TTFdsyPa3KkTcT0M7sswHWZflAzUtbZ52oRnuKbpp7+mfi01Fi8vapvpCON9Yw2TckHHJ0rF94B0c8Mbh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 19 Oct 2025 16:25:08 +0900 Harry Yoo <harry.yoo@oracle.com> wrote:

> Since include/linux/pgtable.h is already listed in the MM CORE section,
> add it to the section as well to keep it maintained by the appropriate
> maintainers.
> 
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>

Acked-by: SeongJae Park <sj@kernel.org>

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 46126ce2f968..dedb9525c2bc 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16249,6 +16249,7 @@ F:	include/linux/mmdebug.h
>  F:	include/linux/mmu_notifier.h
>  F:	include/linux/pagewalk.h
>  F:	include/linux/pgtable.h
> +F:	include/linux/pgalloc.h

Nit.  Should we alphabetically sort?


Thanks,
SJ

[...]

