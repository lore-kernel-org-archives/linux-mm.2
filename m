Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6211A606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 02:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=N+C+9XYN
Received: by kanga.kvack.org (Postfix)
	id 4E6596B08CA; Tue, 24 Nov 2026 21:04:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 470116B08CB; Tue, 24 Nov 2026 21:04:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35F3E6B08CC; Tue, 24 Nov 2026 21:04:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1618E6B08CA
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 21:04:28 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 96733120CFC
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 02:04:27 +0000 (UTC)
X-FDA: 85471996974.11.4F612BD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id C12E2160007
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 02:04:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=N+C+9XYN;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795572266;
	b=yTmyGDjaEUCpgna6eUp6eWxY8tnER+If49SQT+BN+U1bk0sLrI7GgqGYUjdQo+knhGKsbI
	HFVy/2Mz7WUMQkwutjFyfyNggzUQ3p4qM6pF/ksDHWA7UX1f6jK5n7c453vxTGqFj/OohX
	ANfPY6OAfzeEG40uIx7foCjP7mc2v7Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795572266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kyF1PQF9lcGtzWfkqaX6DIkCAl/BRZ3Sz/aZMWmRKEQ=;
	b=lO26e7zph+UXpdFnYGKRkwpUYj/1Jk+y35vfPTeS9QS2DQwgzvg2RQF6PvG+fdJv6iMVoy
	UIz4gKi9keK9uEUPiNJpykGySaD8ono0X2q99Bt9bk6ZADUW4uJ7SyMPlhlQESvQ0NutKE
	AJEWh04bVW0ylRpBgtEwZU0Oa/X+QVs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=N+C+9XYN;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3B05B60181;
	Wed, 25 Nov 2026 02:04:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C0BA1F000D0;
	Wed, 25 Nov 2026 02:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795572264;
	bh=kyF1PQF9lcGtzWfkqaX6DIkCAl/BRZ3Sz/aZMWmRKEQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=N+C+9XYNDsK8OPxn7bHuTkGnIaM8u7AHB/CRuF0HFDTqWbeOGVeCnvG8wXsb47p95
	 vLU19bFc6DjP0LeR2iJuyJXIdJk/Lejrgs6XsizYAKtxSCIjeXw5hr9eFQB+hLZDzG
	 tkNG1Or8ngRIPc7i5u52qoIOizwBLB4slNSwqF2k=
Date: Tue, 24 Nov 2026 18:04:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Wiseman <chriswiseman@google.com>
Cc: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph
 Lameter <cl@gentwo.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH] percpu: skip sidelined slot in pcpu_balance_populated()
Message-Id: <20261124180423.ca36e90d4cabaab8b2dc4721@linux-foundation.org>
In-Reply-To: <18e88cd2a725491b.3137322e32332e3235332e313736.c1dd7.0000sendgmr@google.com>
References: <18e88cd2a725491b.3137322e32332e3235332e313736.c1dd7.0000sendgmr@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C12E2160007
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 3daye7od5drfdjba8krban3p9px3ds1i
X-HE-Tag: 1795572265-379252
X-HE-Meta: U2FsdGVkX1+h5YqlAhFu+Sy+ig6IaXyD92SMYxFrVENSbaRaAStVYM8TDqImdtRqHTreTV5NhUmAwurm9hDZODTf6xtzzTGT0Acu5a1/HQM5OxNzjlXlJQ58RICQABx4WW3FKZt7VO+7bY7mZ8Rie6R3YBc9JMwnpQCl8HG4hS890UJ70C4HfLcjMFK+wfhBPUFgK69pWgvTr4K3ErtZuMaVwyLJazFc9QPFapTpnHJXav8HcQj22jq4PKhcpRQpCmf3LM6Tw9bxAkbpnFjQliOP/IKQKEFRF021ihAojRUHd8u03inRuMHSyL7x4MvkNOBxe2GujmfXQQKaH4MVGCUpEbkvixYKpS9eKdCZYmS7/CIRGrhFEmOQE1Xhvz4hL/ScWjeMCXUJFgCQvOxlutPe2TehaoJReESKdDMuRzByb3NS1Y6vgBB5GB4ktXkgsF/8iTuPnBH3qOIccajPcCKm/rkg8ETgYAmN/Q6P8eh3gE04mMKxWj+siByQQ253lO5fMezjHu+SBhh9L4lKXrZ0bBYVOnGq0nP0YKt6W7SxLtoqU2th0wmiz4f4kM/gNIGgHPXqJmQKszgNYajcZ45JGlrsJOSANHhpBK0RHQXDh7VF9HVm+Zh/+zSg+r7tkl0KKfYMNd8QLw0KLOZbS/VBf2tbUcqKXzMAPEJZQgNFe8Q6cA82PGDkxljX0sgNw14nJfyYSepLylXIYA2IrHYqOhlnXUMosocaHFftoSok+4xG5vDsWkzfy7yM9ZBinEAO26lUVDQRbbAbHmRDlqkKAyHM6IKJgHs8HrI42/jsW68wJnICq8Z826nEob1DAQQz4twieuYQwxe71sUwqxRKyI9/3/CHqpVASaBc4By6sbPHVdtDC/v6G2vaJ/TvziaA3GmE4c2S1GSsO4sg0f1veBY+4Hnv+AIuTlPQsuce17Zj5aHkV6rWgk/cgmJGqdrZXbaR4SzZCYQ9OLl
 /jK28GOZ
 I4J/o1z1mVUTWxWS8TA2rp2PnWX9gGy/o+f96s5u5t+L1FXw7BUEBWXa8+SPIDyCBLGLio4IrjDukvPGgSyH64MKodb6nMj3vmuOHN6vu1QO0YIAY3BZJvcATb7QEl5uzoS6TK3h96YzMRC40fgphfAD7WTIgclbmO9grLiXeGJ1oFu+bOkcIWpy25AT0dSU4XNkxlU+L4uK8Wnf1qK7qmC+bpi/B4UgK1NbRoKCL/pyi2Bv1BT31Jmp/t07Acxb38x59MR5f1wXkrhZSHmI4IQCTQwA1ABwpwqqX0Q24cx2Fj/QZ1FItc4PzApisVD8fhkZtPedJtUg158q9M7TB/qi5Ra8DG788RBYaFk9AaLYcL2aCWx78nN11CM6dISfmAFl/3fo2sBjPuIPR+zTMQ4rrmItxiBoKfYEvkpKi9nDvdqtNtnhnFPFUzNk0LBvGKKLXUWXlwv/OoYIqdfPCdFa4cGi8pHrqT7b6hYpnr3XB4zkl2N0NTy9OLuy+G6wGFlMolluU5kUXzBw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 16 Nov 2026 14:28:07 +0000 Chris Wiseman <chriswiseman@google.com> wrote:

> Commit f183324133ea ("percpu: implement partial chunk depopulation")
> placed pcpu_sidelined_slot at __pcpu_size_to_slot(pcpu_unit_size) + 1
> and moved pcpu_free_slot to pcpu_sidelined_slot + 1 so pcpu_alloc()
> checks sidelined chunks before free chunks. pcpu_balance_populated()
> also loops from pcpu_size_to_slot(PAGE_SIZE) through pcpu_free_slot,
> but was not updated to skip pcpu_sidelined_slot.
> 
> When pcpu_nr_empty_pop_pages drops below PCPU_EMPTY_POP_PAGES_HIGH and
> active chunks have no unpopulated pages, pcpu_balance_populated() walks
> into pcpu_sidelined_slot and repopulates chunks that were just sidelined
> to save memory. Because chunk->isolated is still true on sidelined
> chunks, pcpu_update_empty_pages() does not count those newly populated
> pages toward pcpu_nr_empty_pop_pages. That leaves the global empty page
> count below the threshold, so subsequent balance passes keep refilling
> every sidelined chunk back to 100% before reaching pcpu_free_slot.
> 
> Skip pcpu_sidelined_slot in pcpu_balance_populated() so sidelined chunks
> stay depopulated until pcpu_alloc() actually needs them.

Seems right, thanks.

> Benchmark results (4-CPU arm64, 4 sidelined chunks with 60 reclaimed
> pages after triggering pcpu_balance_populated()):
> 
>    Metric                                    Before     After     Delta
>    --------------------------------------------------------------------
>    Sidelined pages repopulated                   60         0    -100%
>    Sidelined backing pages (kB)                 960         0  -960 kB
> 
> Fixes: f183324133ea ("percpu: implement partial chunk depopulation")

Added in 2021.

> Cc: stable@vger.kernel.org

Why the cc:stable?  The changelog doesn't clearly describe the
userspace-visible runtime effects of this flaw (please always include
this!) so I'm struggling to understand this decision?

> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -2045,6 +2045,9 @@ static void pcpu_balance_populated(void)
>   		if (!nr_to_pop)
>   			break;
> 
> +		if (slot == pcpu_sidelined_slot)
> +			continue;
> +
>   		list_for_each_entry(chunk, &pcpu_chunk_lists[slot], list) {
>   			nr_unpop = chunk->nr_pages - chunk->nr_populated;
>   			if (nr_unpop)
> -- 
> 2.47.0

