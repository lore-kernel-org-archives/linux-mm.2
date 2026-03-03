Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 769CFEDA68D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 16:09:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B68066B0096; Tue,  3 Mar 2026 11:09:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3FD96B009B; Tue,  3 Mar 2026 11:09:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4C8A6B009F; Tue,  3 Mar 2026 11:09:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9367B6B0096
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:09:45 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3C2E3C1097
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 16:09:45 +0000 (UTC)
X-FDA: 84505237530.10.EF9B106
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 600D71A0012
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 16:09:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="JJ0/DWLU";
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772554183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rmZ9hb/OI5m+YRFZ+phh4M809avB9EyD90j7d37zUuQ=;
	b=pUu/F897TZqV6MKBshOjR9Z/MyyqH88M8vWX/0+yIUtt5Hd/XrnbgPu4dkAVwXma9AE5KL
	HSs0zHEWhq8MWfU1v7TB3L7z2p4WBoqLM0xLExa4kMhr2cUw6TWuNQzIUhtihjq+QW6hgW
	6RVIOAT7/mE+/TCkmsaVGYShnFKO5mc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772554183; a=rsa-sha256;
	cv=none;
	b=YA76z0qrOFM+MdMPGzdaVY1JO94INRMQZ1Co8ihXXShVJ2/SihP+3m+LGTVhzDh7aQFwGf
	L0q5CU3RGTAr+pVI5UnKnbUzCnXq4/3X5LhQUtYMLJ4QDiIDmA8h2qjyVhPxzla3qdNzEx
	zj/a6rSYpBmnge3nSH+DazWeOWTwP24=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="JJ0/DWLU";
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 368264424F;
	Tue,  3 Mar 2026 16:09:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79DDC116C6;
	Tue,  3 Mar 2026 16:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772554182;
	bh=K1bc7mmdzM74OPN6+jxMyb/QOLgNNXn12JcN0jtJBaE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JJ0/DWLUwAEuOos3ZH/hdzAkaQwWjOkGNubivUSyO5qjtT3774n2rGmRXY+WHx0rU
	 35jV1kH1ZhOMCajEhQXKlg4acmSsY/2z6iZlwY50/zsz7R3OhQG866taVG1vfLzGbe
	 Exl6o9y6n0Aujr4B1X3GdBk6LQ0smpZh78w5zGbf/STTG2JuoaTa7WIZhkXOL3OZOT
	 B1hAV5DsVSPohf5gGmiVUFfhMkpL4DnZlIAv/ONP6VizN5b7U6rf+MoC5XeSsU9Sws
	 45Dt3q1gnwVv+VBA8bihoIX45UO8UJeTIrGbfj4tJB7vgEz94fUszlM/OivFehm2qe
	 by3+easJVMVpg==
Message-ID: <5d5c8927-95ad-47c4-ae8c-9b56f5534e27@kernel.org>
Date: Tue, 3 Mar 2026 17:09:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm/page_alloc: effectively disable pcp with
 CONFIG_SMP=n
To: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>
Cc: Mel Gorman <mgorman@techsingularity.net>,
 Matthew Wilcox <willy@infradead.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
References: <20260227-b4-pcp-locking-cleanup-v1-0-f7e22e603447@kernel.org>
 <20260227-b4-pcp-locking-cleanup-v1-1-f7e22e603447@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260227-b4-pcp-locking-cleanup-v1-1-f7e22e603447@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 600D71A0012
X-Stat-Signature: f93nfx3kcpz5efgo1t7ejs9pu4fzenzf
X-Rspam-User: 
X-HE-Tag: 1772554183-402936
X-HE-Meta: U2FsdGVkX19tFXZZuieYeZuPnBdZ1V5XRXLIiB1bEFvlz+Henu3s51Z4O8oYpQHGQqIw1Iqt+zmDZcYFNPTM6DCYq/AUU7tddPj1O0Bdjt4LbDAqdm2/SFMIwj9yM8HwpPavz2rdUgosA6SV3L07mDmO71+nSt3rtINJpHpmSmuAiOtPTE6dTjWrHr0pmtOgFhZsZWbhSM9LgYt9Tu6uQ6qWLvvHucXTDgIrMKV4RgubwTuIFjgcTM/jvaYtztJvTjlj10TavAUHfARc5HiL8baCCKcKy2hQ1L9mY15H9Z8ErJCh6R7qzBjVTWuEFJ5LlXnn7WORhu3F0pWaF3ConCOs0NYQ7L4npY4Ue8a7xViPZPRzAQUWVpHfgAxzOLXuj7ATmF5i878JvneCiq7eq8Im/2lJKTGO1jazWyq06yUu/3oX5sDPmfa8fOHrW0+zFtEI1RMsT8XARz2GssUuQpST+vnTIQNOsDOYUSd+tArEYZvnnvt3ezxAEDb7DNbm8853+1Nz7SWXoTp7VSiYdUEvqTBmE0MqJiv6rgsb+6eibnRqmW6+rUwL/KEC6MGj15xeea/YI19I1+rneO3HBtpTUfv6uow32Vhifi9cwLfNFUH16BFwYnP1TYIJzIPTyRUHJvtsDPCJPjf9N/HcExX25YPaTO/hmzbwtnhBabp4vTtUa7ht7w5T21q4rJxNrEBRryR0ScObDEyq7Qtnfo9DVHJkX5gIcO8vwrosPv3KKsPaAqEXUqgZcnWAdjsS1s0Doc7UoxuQvkzcXNOYZ5gsrvyTZzrm2u5GZ6MtEkxghalDF6uKLd4FWfgJtxckw2xt2U5ADD4UAouL+wo/jSMEhyF9FRN0eUvCLlnHvky2iogA7/lwSzgdIWaGYwjEdoX4Ymqf+EUbm55UUaEs0jGrjV9jCtQHyxehrtt6S4/FpybwBUst8Xrnej2ha8qG5c41qi+BFpu82L9k81u
 PaZDWNlE
 vbf7ExmzPu6qD0NcMcA/nypD21QkS56ey7YVBL0EucC2kAsG7P73JEiQ/sarEL+YMgzBSZ4GN1TtQ+gGiosqK3AsU/ixqAEV6sUS5MhB8PtaG1liQwtrUTbSAtUh96nlv06aV4AuEmwY89RCS90doTrEG7dooeoDLGbM7ZS0amKHSieEPq32w2YmCVr5Zj6RRc9lcS8l2y5wPaSv6TvAVj0NOAxd7Jz6Cs2B/Si40LjEjZ/8L330TC66EijrmlShL6a76oXvn252Qqi3+O1EBn0wfCl8O9l9Ac75dZe8kX1WloSRfNPy95lwUXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> - * With the UP spinlock implementation, when we spin_lock(&pcp->lock) (for i.e.
> - * a potentially remote cpu drain) and get interrupted by an operation that
> - * attempts pcp_spin_trylock(), we can't rely on the trylock failure due to UP
> - * spinlock assumptions making the trylock a no-op. So we have to turn that
> - * spin_lock() to a spin_lock_irqsave(). This works because on UP there are no
> - * remote cpu's so we can only be locking the only existing local one.
> + * On CONFIG_SMP=n the UP implementation of spin_trylock() never fails and thus
> + * is not compatible with our locking scheme. However we do not need pcp for
> + * scalability in the first place, so just make all the trylocks fail and take
> + * the slow path unconditionally.
>   */
> +#else
> +#define pcp_spin_trylock(ptr)		\
> +		NULL
> +
> +#define pcp_spin_unlock(ptr)		\
> +		BUG_ON(1)

Did you try turning this into a BUILD_BUG() ?
I'd assume that the compiler would optimize-out all dead code and
consequently not trigger the BUILD_BUG.

if (pcp_spin_trylock()) {
	/* dead code */
	pcp_spin_unlock()
}

IIUC, the trylock+unlock is not really split over multiple functions.

-- 
Cheers,

David

