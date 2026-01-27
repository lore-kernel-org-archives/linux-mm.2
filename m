Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDE32D2D8EF
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 10:30:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCAF66B0088; Tue, 27 Jan 2026 05:30:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4EA36B0089; Tue, 27 Jan 2026 05:30:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A22FF6B008A; Tue, 27 Jan 2026 05:30:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B4566B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 05:30:09 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2A787160A9E
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:30:09 +0000 (UTC)
X-FDA: 84377373738.03.9FEE241
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6475C40013
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:30:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Ly53+/g7";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769509807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hp6Py6zEJOcSwaEzRfNKb+sjKjMwxS137ZT8kZQcaSY=;
	b=yDjX80bfb8uEc5CN3PJBL9d4ShPrDPWe5ycAi5kXeFACq3HEHD4ITSgsCbCiLJyQwyRG1m
	XfSX+eI3T7lNNqa6elTt3TEL8HboVDEUaQhhtQzV8TWXK1nbKb3/kINdOn5Ht9YPOtMH6n
	TTB8hr87O/WOM05RzotgMJpFzgxYnjM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Ly53+/g7";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769509807; a=rsa-sha256;
	cv=none;
	b=Vj8FKB49xIOh0tKF4yK8hMTMJoQ6WLk99PXAIl5Dsac2ARjhLY2cvApALKRgWYnno933Tv
	tdnSDrWSwNITzUQ3z8OFBK74uzT2z0NGlw+XVoQrhrkCdBMQvlq32S7vsO0yFCA4Fb4A8e
	1crW1fyetMwC2jIvgZrFMjITf+/rn+A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CA003600AD;
	Tue, 27 Jan 2026 10:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87EA7C116C6;
	Tue, 27 Jan 2026 10:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769509806;
	bh=dhHYsR9fUk6WUXJbc6tT1GAuFjFws3soA5OGepqX/5s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ly53+/g7GMKrioxrpvJKQ30gqvhpgJ/NdJQ7qcRscTsNHlxgdg4WEB2L9LgRliowd
	 w+NGXbw+kK3vzBPhrespO4uxHBuegqjslVshEnpEaPuYiatuUmgE4iZ4AIWo7PYn/x
	 uS5OSYJ0KJKkKvBK6Qnhfn1GZslHwCGR6/fzUvRb98D3xXlEFdfgK5BCEZOpnJI9X8
	 UYONAGVvGiKzO2T3b6A09yd1f81uRAKpSKqgXF+JocsuxmuW+zUcjFBEvUGz8YqB2r
	 o0OwySAR3zU6N8doTj/MqORWAa7sKhWS7myvc+ga7O7KgYBUaS8sL1Yz4tdr2HfJQB
	 T1K634E3AjC3A==
Message-ID: <b7549e2a-e5e3-4052-92d9-1e7361b52b78@kernel.org>
Date: Tue, 27 Jan 2026 11:29:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: folio_zero_user: open code range computation in
 folio_zero_user()
To: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
 raghavendra.kt@amd.com, chleroy@kernel.org, ioworker0@gmail.com,
 lizhe.67@bytedance.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
 kernel test robot <lkp@intel.com>
References: <20260107072009.1615991-9-ankur.a.arora@oracle.com>
 <20260126183212.2366596-1-ankur.a.arora@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260126183212.2366596-1-ankur.a.arora@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: ffx5n8dyr6tthcbiqc5w9g76ga8z7pwm
X-Rspam-User: 
X-Rspamd-Queue-Id: 6475C40013
X-HE-Tag: 1769509807-712145
X-HE-Meta: U2FsdGVkX1+qwZ3p6T5fiMihT2VR7LOw8SjHTM8RxlNAPMnmGSwXnHQJbfgE4ul8RTuWL8bHknTfBSQkJflmmRTuQl3I/cRG3Nn7yoY6oMxPXwK+AbmT44Rrvd3NplUSpOt13+yOjb4WVmv0DueSyJi2ZdwBEf9BHu6RchvayrWhtHeM72CTAxeqJ0CceHMQfFAJhlD4fObzWameLiUWW/IGLvwCc2lYzLQwq8YKiGox+fDl9uZ1h+KoyKa2psJRSiQ1+ea0a9MWHDUQgO1sg1g1uclObvlNljQ/Dk+0RR8V+d19owtjTxzx84TnLt5ycs50smfg23ZxbObZzG4MWy1IIlVVgVzsOLZ9I6OQbarORubLC0bueRcu9E/NrHQk4C7ce1saq1Jfb2ot7owZdzOFlvlnKxzK0viyxgH1cnC11yUopfv6giFHB0lDtLj3FHvXa/Q3Djz8fV5Ozbd/GXs/pIyuRfUuEFr4zfiePzxggHXcNbGXVc0VAm6HCX7WH9lAbYT4x8LAHtUgHBhfpKIzwGbDwOUodjC/d5aYUkyN6p8akEVry8XcASyY/TVapvnQ0DUz+a9uYSIYOMLMnJRAFoKFzVi1WZITSzxnJcAprbTYHfdiJlR5dOpoAF1soqm4rov8VrX2Zfl97kUkpF1K1yJmOql3UsggE99L6X/n7aObA8qy4ibyaRItTWe08QvWjq1CcOdh/xdnaDbdtKOcyEFu1+NiTWSdtfdm4lV7gIjb76iOe7SKtXIvYMrr3+qd+EMx2k8rZJYg3XlL46jFNy7LoyjsgxvrkIbyL1RF+3+/PbnXhmeyirq52+flL2F+GSBjtDDfSbHuKaSo+h1tpUMbg1j24q6HQLUAx0XQO7CBraV8Umkra47DTx/JvNzK4qPTJfEwD6pfbfCLcG/5aBhfqmXlyYzQ7tdkiGLRJ5ZO7npepEjmwOgJLrmVKjgC0s1Vqpmqk4LVl7Z
 Q774iZ29
 mnEBYpe3UaUSiiU/ta7Mk+C+BuE4L9RexMuySPo+5pMHbWmakJoPIrcjDn9zehpo1ZHVJBDlYKZf/lEeuqRrKRR3FiFpdSz95wVkxM1/CmkTM3ReaMgGqdGzswyGdTI5gFVEUKtsgmbh4FCrlZLcNwjo5DAQl9EXzE0IUzVr7z1LZcsJaqFJo5qUZ/dzNicxETfRQz5ZZy3DGvHAtf62Fo+5Adjlij8TVWgVGLSMq3OkRBCq3wBtFXHeVhiDeQ1Yv3xYfDYJvXYZY0l5ya4E447nTKb8f2iCwzYyflPEwMrs5OgHbFpf3XTwXrcodHQuqFCBLBqxBHHuDk/FVw1ieowhk5XLDH8zkttdMHHYh7PEUTJKDqoCTgJjP1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/26/26 19:32, Ankur Arora wrote:
> riscv64-gcc-linux-gnu (v8.5) reports a compile time assert in:
> 
>     r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - radius, pg.start, pg.end),
>   		       clamp_t(s64, fault_idx + radius, pg.start, pg.end));
> 
> where it decides that pg.start > pg.end in:
>    clamp_t(s64, fault_idx + radius, pg.start, pg.end));
> 
> where pg comes from:
>    const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);
> 
> That does not seem like it could be true. Even for pg.start == pg.end,
> we would need folio_test_large() to evaluate to false at compile time:
> 
>    static inline unsigned long folio_nr_pages(const struct folio *folio)
>    {
> 	if (!folio_test_large(folio))
> 		return 1;
> 	return folio_large_nr_pages(folio);
>    }
> 
> Workaround by open coding the range computation. Also, simplify the type
> declarations for the relevant variables.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202601240453.QCjgGdJa-lkp@intel.com/
> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
> ---
> 
> Hi Andrew
> 
> I'm not certain about linux-next rebasing protocol, but I'm guessing
> this patch will be squashed in patch-8 ("mm: folio_zero_user: cache
> neighbouring pages").
> 
> The commit message doesn't contain anything needing preserving if it is.
> 
> Thanks
> Ankur
> 
>   mm/memory.c | 23 +++++++++++------------
>   1 file changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index ce933ee4a3dd..e49340f51fa9 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -7282,30 +7282,29 @@ static void clear_contig_highpages(struct page *page, unsigned long addr,
>   void folio_zero_user(struct folio *folio, unsigned long addr_hint)
>   {
>   	const unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
> -	const long fault_idx = (addr_hint - base_addr) / PAGE_SIZE;
>   	const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);
> -	const int radius = FOLIO_ZERO_LOCALITY_RADIUS;
> +	const long fault_idx = (addr_hint - base_addr) / PAGE_SIZE;
> +	const long radius = FOLIO_ZERO_LOCALITY_RADIUS;
>   	struct range r[3];
>   	int i;
>   
>   	/*
> -	 * Faulting page and its immediate neighbourhood. Will be cleared at the
> -	 * end to keep its cachelines hot.
> +	 * Faulting page and its immediate neighbourhood. Cleared at the end to
> +	 * keep its cachelines hot.
>   	 */

Why are there rather unrelated changes in this patch? Like this comment 
change, or the movement of "fualt_idx" declaration above?

-- 
Cheers

David

