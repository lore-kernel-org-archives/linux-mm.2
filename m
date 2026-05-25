Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0879ECD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 18:09:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44CAE6B0005; Mon, 25 May 2026 14:09:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FDE46B0088; Mon, 25 May 2026 14:09:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 313F06B008A; Mon, 25 May 2026 14:09:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 202256B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:09:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DB7F28C2E0
	for <linux-mm@kvack.org>; Mon, 25 May 2026 18:09:51 +0000 (UTC)
X-FDA: 84806730582.16.398BF59
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4C37D4000B
	for <linux-mm@kvack.org>; Mon, 25 May 2026 18:09:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JtJJOZN2;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779732590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PpMthd8gTUDZyL33DeH4wJrwmtOZsOaKvCtxKkVZwgQ=;
	b=IYzzM8jdc12C5OVW0Ve3SwRY0cD0VG54RSlWzrB/AVfumWdJL20mdNAjA5xqJresXJpKWt
	g4xE2BQ4u3a+VTNbA8oIzeDTkoHwKivYyG6ukUnD8nF94WYUxROvXayDhCoKqm+gpB0g2P
	DO7BouHCfaoFvcYLTqtZl/HI6+pGZkA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779732590; a=rsa-sha256;
	cv=none;
	b=iBpZ3zVt76VA4ka8TiXULJpQmLPUJePtco9BDVBXM/L8/lvznSeZNWYKa+sRXGbHhnMy9c
	4V4OlgKlB7EFP486bo+5lnJoEFOzbvk7vB7ErKzVJMyoqwiemJbrzM4CLc4QrlFIrNk3HK
	O0Cnn1o8QHm3S58QhqCJcDqMm+Sa7vg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JtJJOZN2;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 65AA94325F;
	Mon, 25 May 2026 18:09:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08271F000E9;
	Mon, 25 May 2026 18:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779732589;
	bh=PpMthd8gTUDZyL33DeH4wJrwmtOZsOaKvCtxKkVZwgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JtJJOZN21trFlyq8L/nh0RkHh+g7D2zvCrH4m6uyKH139J9rarXu9blBbaH5A/9+Y
	 wIJnmliuSeONQ8GV1ICI6So+DdbU15bvinzEIKba4W0saTXOkwiRTD30V2V/6MzwdW
	 ncZATkoODUQ+nOQlDAfeNWwZ9TawOr6lwOewuCHA8TgsHicJxVYZqvGc8TiArE8mHk
	 yfaOYyHKCDtV5bIJucCYtGcSHqxWb5XnIOFX1d3fzUeUXHdxeu7+oripqx8sCl/yor
	 6K6prawrG48tG1eeuP3vikfF+PI56El+LSJGjfRRzwQsKZmMveshdgd8A41cOwfuAA
	 jV/fBrTR8rD1Q==
From: SeongJae Park <sj@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org
Subject: Re: [PATCH slab] MAINTAINERS: add slab-related scripts and tools to SLAB ALLOCATOR
Date: Mon, 25 May 2026 11:09:40 -0700
Message-ID: <20260525180940.10383-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260525-maint-slab-tools-v1-1-d66b69f1412a@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: ysqp8wdm3s4bmi7woc4mncngs8ux5obs
X-Rspamd-Queue-Id: 4C37D4000B
X-Rspam-User: 
X-HE-Tag: 1779732590-838868
X-HE-Meta: U2FsdGVkX1/iB0aOlcKRJQrcT+mprgw6Mbd+jdRRsNIlH77F4L3Rxc5NaonDWUabBAvhu+VbIjwkx4T8ceSURyqmBc+T6qnNDnZ6C7yeqJs4SDr3oKXlFUpddEPi7Q64ScWxlVLfVM1luPASlzy6kl9gTMZ28MFI/+K6fClZea05q3zEn0uKRg+300Yfz13ld/fXfXTNNyxdMCkiQ+9jYB+DaDHjg4+D3XadAEPrvr9pug4I/4wEUfAAsp/VijkvQxkt9uAoH0Gs7WDTePnQoPgj8r+J+B3iTHVOwvzzfV0118rL3Toe3yAQKNQ36T3BQXDMcPvnip7+jqSbRAzcNMhWI5sB8SvOel1/DBDYtA8sX9yUMpYJdpNuAKKJKAITtxoqj1hePnAh4qbV8jgVOheOQrBAfoUT/UNodgxdSlHiZcIWRLq/aZRNjHa7T2XAiqEz3l71nI2YDQ8Wi5zWilYCAG8GV4yS+ghJoGN8D+1EJb1Nyw1E9e+P2F1e3TsF2uZNZJBqFQkamSdr2gFDeh4tB2wJdmRQxmeotk8q9RGgafdDUyfrKABPoTcO+njlZ56pyBbwQzW0/rtiZrtWsF1UoS/R232UutS0TUIlUD4Xr6txZ6cJ6PAAseTq3Bl2uoZdayt7/Cgnaoxa1DAyremMF0yokxlYjt0mKtzqAKv93/Xzu8VUwhZYrvw3f9CsmI5L9w93gn+DpfX0sk+HhcKyts7ytEP8H7UdxPTTdR6KrX5au5tItj6Xt7HYT72P6SNb3t6dY/PKzjHt2JsHuBEtWR0KSc8XXRHpCO4IBJHgy+6vV/AFdCHZ5Mx2QGGy6bocrazeGok7rjhceQTUhe4J9ZMehGXMkoKkBaH2vkJj5v52ySW+ql5XuWPS2fl1mZ3U7s1EDfWXxKmt3eQLwSYUfo0UzA3VUZYAykwhxI5ldM75P33oCmPrQ5Bf/WHhLqYgwcMASkipsH7VzHF
 uznqb1xt
 Tsie86j6FROmaPgYiP6YhwWEAIFxoRt6Z0+cc4WaajAQVua71sCvusiPbPqZZEKnF00D2J8hBnyfOAImgR0PTdarwjby9QFJuHXbvDQ60fC1TUUIucBzWPGZx2jEGTsW9Qeqp83K64X5bWRYvJlHpKs/nP4XOmjPzII+VeumYXUUh5H1wFvX5fujp7zTUtbvRFvCu5afcXmvvX/31IBsRFAdrfMz3D6hRWY/Tvqil9cPJUxY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 25 May 2026 09:26:39 +0200 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:

> Make sure the maintainers and reviewers are CC'd on changes to the
> scripts and tools that depend on slab internals.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Acked-by: SeongJae Park <sj@kernel.org>

> ---
>  MAINTAINERS | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 288866c32ade..9ee06cd35793 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -24555,6 +24555,12 @@ F:	mm/mempool.c
>  F:	mm/slab.h
>  F:	mm/slab_common.c
>  F:	mm/slub.c
> +F:	scripts/gdb/linux/slab.py
> +F:	tools/cgroup/memcg_slabinfo.py
> +F:	tools/include/linux/slab.h
> +F:	tools/lib/slab.c
> +F:	tools/mm/slabinfo-gnuplot.sh
> +F:	tools/mm/slabinfo.c
>  

I found there is rust/helpers/slab.c file and it is not in this section.  Is it
intentional?  I found commits for the file doesn't have Vlastimil's R-b or A-b
tags, so it might be intentional for rust code, but I'm just curious if that's
correct.


Thanks,
SJ

[...]

