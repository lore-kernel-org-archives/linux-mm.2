Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51061EA4E07
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 14:02:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95DB46B008C; Mon,  2 Mar 2026 09:02:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90B706B0095; Mon,  2 Mar 2026 09:02:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80D1C6B0096; Mon,  2 Mar 2026 09:02:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6801F6B008C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:02:49 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BC438C01A5
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:02:48 +0000 (UTC)
X-FDA: 84501288816.22.9E9EFDE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id C80584000B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:02:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J3sPEAkp;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772460166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j+mNuEanuIJuWUW9u6JUIrvpUs84AxWQyhsJBb0bVjQ=;
	b=VTiO8GcRRoxWG/7gEKPmfJNoLi50Vir8+gnXXX8LQpyqPxAiOZHkAHNSRaoQqSunnMSwiq
	zJBMDKfOg+YuX4c7fRAZ9S+aqj3XP1qm/PvmwpA5Azo8odEj2k15cGPVWySm5dh+BlpSeL
	W2aHaaeHdUZgs06Z45fgK3pOPOkWIWY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J3sPEAkp;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772460166; a=rsa-sha256;
	cv=none;
	b=G7nfLHxIUMLR7UQux8MzTc9c2w0MR5jpXUtKL9LggZN2OnGpzeMzAeHSB7+BC43feVfY49
	xSAMW47GBtfAsHUCkPoS7EHQBgoTEzHZgJAfnQE1ZXAi3BFxvTwTC3RPqDrDinDHOfxtoY
	D+kbWDVShszXgOKzJSzBQK81PHxLbgU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C67F243EE0;
	Mon,  2 Mar 2026 14:02:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4835AC19423;
	Mon,  2 Mar 2026 14:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772460165;
	bh=sziW4pOUkxTp9O8LXGHmN/0KGKu2HZcxR9I6yaCXqP0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=J3sPEAkp7ZXe2WdNJfY0wlkY+4gPNTR4C2pJ1PdyTfXB4N+0vvY4E583r8pFrOTd6
	 2fcEoG7epPt1Jr32IIY9UlFEt7QtPxpW0ADSrLZZVXVqE2Ac1Lej86lq9gfkrIj4kZ
	 ojjYIPYUX2o0kCs2MEfhBq1HIe5aI3LgGR+rUTtyNvdskd/j2xtKi40ILxobWdcnKx
	 VpORqxQ4YXNmiVwZqzkAOAhoMvtb72XzRfk+IYI88iHnEqU8HbTl3V7WBWSfuC/DKx
	 PqLL2ESytNeNAe9u0Y52x+9ZxNdqX4L94I6LC+SFQGc0T8ntIHIrBa6E5Sj+Om5xLd
	 t4iYJo49n6tFg==
Message-ID: <7cacd42c-642d-421a-9180-ecf044eda00e@kernel.org>
Date: Mon, 2 Mar 2026 15:02:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/5] mm: convert compaction to zone lock wrappers
Content-Language: en-US
To: Dmitry Ilvokhin <d@ilvokhin.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>,
 Len Brown <lenb@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Oscar Salvador <osalvador@suse.de>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
 "linux-cxl@vger.kernel.orgkernel-team"@meta.com
References: <cover.1772206930.git.d@ilvokhin.com>
 <3a09e46f52cf9f709b0725bc2b648cc5212843b2.1772206930.git.d@ilvokhin.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <3a09e46f52cf9f709b0725bc2b648cc5212843b2.1772206930.git.d@ilvokhin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C80584000B
X-Stat-Signature: pethpbsajt3wz1163bdkazyyboyknoeu
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772460166-386923
X-HE-Meta: U2FsdGVkX19N3hSqK/QDJJqU4hk0DWal0TlBrSC+DrdPUBRMzYwF8caIa00ZvoPkSQaKCVqErcKnK29wMmu3D6Vt7Pv88zG3qkAG2zN2v39Ro/R7130w+0CxosFmSXynQoikbcpWuBwsElWkYQ8TiYkZpAc3rML4i5eesa5eS6soJdIuHyGkWTAd0y6Kg6UJzMke3bclFuwKtDvrwncC9kAG6+Pi/cu5Bc6uSj7v+5IVR7dirmb9PJrip2mTD0Y6fMbd/02nyqmv/+saZ6+DQKFxDkaPNONZEsVwhf317TjkmGTkgZhjob1C6N2cMkS60wHSUtVYYoqAsNsZ0UvqU/jy+h2gRqXqdRlkhC0duW+i3PAKC2oNkkLP1EnwWz7eFWlf3XhzLmasULuIqP8HVsymBXUyUXNWSaRurUXGdJYUgVPklxk6NJ6Q5DQ3sw3KGnVMnCDNHHWKJF5PkbCvTOGYSdU4t1K2NX62BAlHjOb3CwFl+bx7XBUfNZhvwm60L11FaFLkIWAbXvzk+E5/aeNNiEwy/i48bQ3dPoBOWtl5qciXmmiyLx9kzPF8YrUg19TV8HZJd7UebuOrYKKcHUQj0fuS3tvmackgQ/owGYJ2whHumOkXsYgnLRb1PItmWSw3ncvj8aJVH+e9fcbzJbPgY7YZ4l9Y0cf0V/lFWzo3lrdCMusd/xwB8EfbggC9LpSKy/u9rbbHbCTlRfvm8eCfNESS2wdL1ThhZvBgKrCKZ+MtWga6tJAP2tKmfvrxUxbsglkc/hSR7qDVFXYx9HaFAecR8CvObkSmhWKL055szmebQSf0SDtqrSdqiK7ow+uttEYlUVmkujMlD1XopHc4PNZnNdTXyGi7UPJ8BYEn1oqMI8I8nAnFmKaFJtv4YmYjTkGbnOkJ90SfptGZkgSpB8VsUr/qMTv8T8m9OaX1tWrEu3TTk2abcMFSvvYSicvfov64eYgGk2KTYoQ
 EoS5BIf6
 /mghMa/Vos78uVbOMurvMDJb5AdvccqIO5qHsrPV4R6A8CKWE9m6i75n0rmKMbD0R8CfcfzzlTDmhhN6ablfip0MM1gd+YGFVvsdJuWsgCUmoDjJj6615P6rq1aYQ5hLjj9flZPeHNIA08bGgS4WFXDF2bMdk4PFiG1ZzWVsven2O7X7/23FI3w5DPZWBNSDHtgu7pa4dAuxepQQpmHAezsMCdjFOjxgjKj2EdKVvwOX3Auhi4UAZ1/lnGhBNENxiYctDzRUvuaWVTRIpvjF1/1DaBjvDoBuvQYjyNb/Jq3zjPlyWtL6g+VU6aa5jIokuRyMdg0Yxnx3qZwz+2zfQ2av+pA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 17:00, Dmitry Ilvokhin wrote:
> Compaction uses compact_lock_irqsave(), which currently operates
> on a raw spinlock_t pointer so it can be used for both zone->lock
> and lruvec->lru_lock. Since zone lock operations are now wrapped,
> compact_lock_irqsave() can no longer directly operate on a
> spinlock_t when the lock belongs to a zone.
> 
> Split the helper into compact_zone_lock_irqsave() and
> compact_lruvec_lock_irqsave(), duplicating the small amount of
> shared logic. As there are only two call sites and both statically
> know the lock type, this avoids introducing additional abstraction
> or runtime dispatch in the compaction path.
> 
> No functional change intended.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


