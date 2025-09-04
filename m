Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D52ACA1015
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 12:48:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCBF78E000A; Thu,  4 Sep 2025 08:48:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA3348E0001; Thu,  4 Sep 2025 08:48:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDFD98E000A; Thu,  4 Sep 2025 08:48:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF6D48E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 08:48:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 422C71D9F60
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:48:10 +0000 (UTC)
X-FDA: 83851545540.12.CE82BDF
Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	by imf20.hostedemail.com (Postfix) with ESMTP id B77311C0007
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:48:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=khXUWC3B;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf20.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756990088; a=rsa-sha256;
	cv=none;
	b=PuspjIGnHXEChgu6852R4m0x3DyGvALC1HStkSnjcXsLcqh3JcSEzx5agNyyWnq25W2J3e
	Uwta6+MpQLOkpiqHfxBWfaaZjPh5udfr3LTVHAFmLtddZMtuEMONV2zE20unGCv1SG/JZ3
	3T5u49H9qxamLvm/MfoK/a6ekt8auBg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=khXUWC3B;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf20.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756990088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j81zL68CeneemT/sC0l2QYkupmOTxKcm9kYLz1nNSb0=;
	b=TxM0pYWucZgc28URY/+UelefAf2iSEEDuRRQM9xN+UQB/G+DwKXxbAUs1G7XLtXi/PijnW
	7Kcz3Xjej/nXjaH5mHtpu25S4v1naSJTmnJUApmOwIKvBkRipboAwWGSu+9vNiVjrZudVP
	NLvVBmYfceJ7Hr8RVp8HMXW5KDGPxSg=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=j81zL68CeneemT/sC0l2QYkupmOTxKcm9kYLz1nNSb0=;
	b=khXUWC3BcJ0rkgdIQiz1Wqctm9sksKmBBOwPRmraXsN33GnhIHejbyW/W2jV92MUCkvW/VF0b
	FNSlkJR/KGGcPNUS/M8TwMDRfUqZ46Be9Oh4tFDh48U9niz3tzNcL8vpQkNK6EEXiN0iIs+Y32A
	pGR5rBPUmuq96D9Qe8/s3RQ=
Received: from w002.hihonor.com (unknown [10.68.28.120])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4cHfQW2GLHzYlSv1;
	Thu,  4 Sep 2025 20:47:47 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w002.hihonor.com
 (10.68.28.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 4 Sep
 2025 20:48:02 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 4 Sep
 2025 20:48:01 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <liam.howlett@oracle.com>
CC: <akpm@linux-foundation.org>, <feng.han@honor.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <liulu.liu@honor.com>,
	<lorenzo.stoakes@oracle.com>, <mhocko@suse.com>, <rientjes@google.com>,
	<shakeel.butt@linux.dev>, <surenb@google.com>, <tglx@linutronix.de>,
	<zhongjinji@honor.com>
Subject: Re: [PATCH v7 2/2] mm/oom_kill: The OOM reaper traverses the VMA maple tree in reverse order
Date: Thu, 4 Sep 2025 20:47:57 +0800
Message-ID: <20250904124757.25732-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <7rvwvuifkav5oz4ftfuziq23wek2bn6ygvrfotpaweypuy7obv@hjuf3eknscii>
References: <7rvwvuifkav5oz4ftfuziq23wek2bn6ygvrfotpaweypuy7obv@hjuf3eknscii>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w011.hihonor.com (10.68.20.122) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: B77311C0007
X-Stat-Signature: 4tubpt9wayqetrdyjx1tmg93tah4dp3y
X-HE-Tag: 1756990087-299689
X-HE-Meta: U2FsdGVkX1+/nI6K1Z3YNysZkz6CwsGr+Kikr3t8jnYIVFf5x4iJwZz1l5zQuc2MRsvhQ+J/kpxRyXHoZFlC63ZtqxdIGMLVCREar9HbdII9IllFWIa7R/4R1+zuUhW0zvL52IP4AbQ9GksUYF/SaGfq8vE6EHmOT0e9tohaJRpuyrFyrgUmYgmP5ol1yQbdR54J+0Rena/cl7u2eKpjWdOsPwChvwqoHaec+7DZutI200q/l55IcIHBsGJZ9Fyg86/26WS142bu+dd5LrRFaie1N1Ti6gSR01jQqEZtU/nMMS1nnV/OVMiQB7HRfiJsRR3wL/+QW/fIoXW74i2Ggt/9JJiEarC3SkqvFlkSJCWzbNINKBAcRU46gMvao31KoYk6gIK8LRah9JTsOKQ/+R6BwLLuQUlzi5ThFN+nQ4P97JCtdZgdaB8dOxKCGpt6eRCCcrDnaNCfgoQSGPVS4/m48cj7+Bs5TTSLS1XuwszJBWTSU2sxdAOHR6V1jweRqouWDGxWIhUM3j0Q5qtRCiTTCVppJTmNPVi+gfem8osQ+sNvFRwbGijULk/O5z5Hf+YIeQwu+oPn1rJbDFmNEmf997Ct06ymZ+ODc4Zq6vKTb2T40qec06Dseo0vIVBE6jB1ff3vw8ha1vmZlCx6OcbO5/bXpfXhnpDtmtWk29z28i6uUE7/MBNQ0QRrWRn79MVvtuNNODt518bElZerneKp08GEVUntj9fHDF9lMWl3RyxykxEJOny1p46zBsBwSkvcdTjzeY8A57Y/maxmoY+ymSmPsSe4bndL4xR5oJpE5jFxl+VUEbrtdfdyCyDoisMkhZnPzewEhyTk9JmhlH/BSHgZk5FdPpocrRL7thU0uZRMufEl+F2USjmr8YQ1h1jEZbJsNLq5NfXWEWJXAEbnTCdr/xiyv0lxywiWq5qfhAIbt/BOds6skYBzkUdyzMH3v1z+0Rz1+eJ74ix
 CrXVtRT8
 aqUAgZqKSYi0n7JGSDbFapzRNao5CeYmtHcA7UbX69E0o4aKTPPQv4hVg5HeAWipGKolPnia3ZjouwhaEXCIv21AJ0JPbAPEGpcBE2UgWk6sOtWP2GgmegaMc+xTWJLeQlsFAkD4S/Baxdv+5GskfUPa+Py1KSdGjiJTm1LbzJuHDE+jnAXtRvXFkyz20hVagTfBm45o1UGQEXKcMQ+c1Ix5HlBREERbedEeYDrJFczSLdAMpGRFZo7nNAHSZcdCi8r2nuivjugTttRWFkdAiE4d2jMEcZe0gDe1vZQAWKHyBtMCUXcnl5pPVLzKLi7WpYRYOEtoUkaQQbVJSkfAsSHBZzqdOFiNn1p1w9LNZ6mXNY0uUPJa8J/L1NeIZbaiaNlwJcSK8vZ2lWYGJCcDQDfDMVOHEDnqzKOSffFqVlICJbndJ0rRSevXkzw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > On Wed 03-09-25 17:27:29, zhongjinji wrote:
> > > Although the oom_reaper is delayed and it gives the oom victim chance to
> > > clean up its address space this might take a while especially for
> > > processes with a large address space footprint. In those cases
> > > oom_reaper might start racing with the dying task and compete for shared
> > > resources - e.g. page table lock contention has been observed.
> > > 
> > > Reduce those races by reaping the oom victim from the other end of the
> > > address space.
> > > 
> > > It is also a significant improvement for process_mrelease(). When a process
> > > is killed, process_mrelease is used to reap the killed process and often
> > > runs concurrently with the dying task. The test data shows that after
> > > applying the patch, lock contention is greatly reduced during the procedure
> > > of reaping the killed process.
> > 
> > Thank you this is much better!
> > 
> > > Without the patch:
> > > |--99.74%-- oom_reaper
> > > |  |--76.67%-- unmap_page_range
> > > |  |  |--33.70%-- __pte_offset_map_lock
> > > |  |  |  |--98.46%-- _raw_spin_lock
> > > |  |  |--27.61%-- free_swap_and_cache_nr
> > > |  |  |--16.40%-- folio_remove_rmap_ptes
> > > |  |  |--12.25%-- tlb_flush_mmu
> > > |  |--12.61%-- tlb_finish_mmu
> > > 
> > > With the patch:
> > > |--98.84%-- oom_reaper
> > > |  |--53.45%-- unmap_page_range
> > > |  |  |--24.29%-- [hit in function]
> > > |  |  |--48.06%-- folio_remove_rmap_ptes
> > > |  |  |--17.99%-- tlb_flush_mmu
> > > |  |  |--1.72%-- __pte_offset_map_lock
> > > |  |--30.43%-- tlb_finish_mmu
> > 
> > Just curious. Do I read this correctly that the overall speedup is
> > mostly eaten by contention over tlb_finish_mmu?
> 
> The tlb_finish_mmu() taking less time indicates that it's probably not
> doing much work, afaict.  These numbers would be better if exit_mmap()
> was also added to show a more complete view of how the system is
> affected - I suspect the tlb_finish_mmu time will have disappeared from
> that side of things.

Yes, it would indeed be better to have exit_mmap data, but simpleperf 
does not support capturing perf data from multiple processes. I'll try to
find a solution.

> Comments in the code of this stuff has many arch specific statements,
> which makes me wonder if this is safe (probably?) and beneficial for
> everyone?  At the least, it would be worth mentioning which arch was
> used for the benchmark - I am guessing arm64 considering the talk of
> android, coincidently arm64 would benefit the most fwiu.

Yes, it's on arm64. Thank you, I will memtion it.

> mmu_notifier_release(mm) is called early in the exit_mmap() path should
> cause the mmu notifiers to be non-blocking (according to the comment in
> v6.0 source of exit_mmap [1].
> 
> > 
> > > Signed-off-by: zhongjinji <zhongjinji@honor.com>
> > 
> > Anyway, the change on its own makes sense to me
> > Acked-by: Michal Hocko <mhocko@suse.com>
> > 
> > Thanks for working on the changelog improvements.
> 
> [1]. https://elixir.bootlin.com/linux/v6.0.19/source/mm/mmap.c#L3089
> 
> ...
> 
> Thanks,
> Liam

