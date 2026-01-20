Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B865ED262AD
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 22:20:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB7406B0005; Tue, 20 Jan 2026 17:20:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3AB96B0088; Tue, 20 Jan 2026 17:20:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B399D6B0089; Tue, 20 Jan 2026 17:20:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A46716B0005
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 17:20:35 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DF291BAF59
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 22:20:34 +0000 (UTC)
X-FDA: 84353762388.22.FF3A938
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf10.hostedemail.com (Postfix) with ESMTP id E938CC0002
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 22:20:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LpKW17+B;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768947633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=27qEqXjIKzAxOtj3W7bsDUaYZJOkqZmMfwcX7lLHET0=;
	b=KltvouaR6QR2onvL2yWua8o59PWTLETY2gd5PHQcheG+eM9/blAPaZefjR3R5SQrbfG/yf
	M0T1q3p96jj31+g/1/75RDazPPkBXHxAnjrFolvxgV8nd144Lk3XS+ext/ElIgNwWFBvqh
	6LdUSjcqTDG9RUepaeyUHaCV3hkYSPI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LpKW17+B;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768947633; a=rsa-sha256;
	cv=none;
	b=37RHv/j117A8+2CEUs9Ph6wHhMB3srtw35iM/mG6e4gj45sd4xWYnwDDrk7AyBuhcRuMVi
	bACAq2zbxgScXcQXotLp7r26ggR5TNJ8jdttIymqSDBQ99O0YUZYWfskr3l4t8qqFoFLzB
	1HI8d5/wTUNn0mqiH5OmYzQkGvlA3w0=
Date: Tue, 20 Jan 2026 14:20:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768947629;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=27qEqXjIKzAxOtj3W7bsDUaYZJOkqZmMfwcX7lLHET0=;
	b=LpKW17+BMp7pRqcLmA8Y1uunY6pichpMlyLZ5W08ReCkxrj9rzUBpwbDbWA7fJNi0bw6dI
	VjRYxh4oHO7XBKtyqfBWCtF3poqFnJHzn0ObnZJnHOJ9cbZpy3+VvBkPKGqZiMWp8iS3LN
	NKt3kV6fV90h5vcgOmY93G6Ac+EEqbY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Xin Zhao <jackzxcui1989@163.com>
Cc: akpm@linux-foundation.org, david@kernel.org, 
	lorenzo.stoakes@oracle.com, riel@surriel.com, Liam.Howlett@oracle.com, vbabka@suse.cz, 
	harry.yoo@oracle.com, jannh@google.com, willy@infradead.org, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	zhengqi.arch@bytedance.com, kuba@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] mm: vmscan: add skipexec mode not to reclaim pages with
 VM_EXEC vma flag
Message-ID: <aW__D24ZrpeSPKZN@linux.dev>
References: <20260116042817.3790405-1-jackzxcui1989@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116042817.3790405-1-jackzxcui1989@163.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E938CC0002
X-Stat-Signature: gqe5sq4915apcrcae86rgsejnk4ernyc
X-HE-Tag: 1768947632-114229
X-HE-Meta: U2FsdGVkX1/QMCsrrKR59k582gTUzmZAhKtLBlJ/VLu4enDrdaKWjWMS4vfPrPQl6TB5BaYqKcWxj8hQxIwXA0lX9m4EoUM9BPIciH1UgcTObojGMbKJymaNHCp0gkIf9Qej0ZT3a0/32JL6oUrGOIjxPT1Ajw77OIdPHjSVyBR4fPShww8dGWp4PzieFBBvD1xr3XSzPt4/C38+G0AaWJmcawkLR9u64sNiN+gX0GaFxbRIMOMbTE9iQcnTsRAGbi3UjfEUPV6q6JpRAsd5M8q/xxBLAQKr8kp5Z0HgSksvjC9PebFuSQhoBmvaeglXWr31DiD03CZKrL8A4/Sv5KrmDpXsceET7R2CwjlOjZKnfd+Z7+F8ZrGTwGhu0QcuitcFQ45JwfADW+pe0CBzIZRH0Imuz3IAw2/cUbtkxeP+Vrlzs9kCGkaneAGn1s3xK7wnAsm6hBdv0PV89WnwpiBk/NunasiKOf6MtBFjUY+3v2NXxBQ8w9NLuslGbqL66/FOjEK/fZiObK9dTjbIjfvAdggAMbUi80pP9bIpeRenELCLntajKVnvxZCcjqNu31VaGGffclZrYQcdSu25+ZPFxbkfZ1ku1wqCq9i0iE6ZtFnIG1DgS4wFHK/zN9vTedeYMKx9BzRMYrHJBkjaM7X+wq3muUvV8SMFWxSMXs79pGDInoNhpm8zMdr7RKnIIQ2NcJW+JKKJecO2h6bZCLpmvH28m6Ixsst1/qMiOqp+dmjfV417XGL+UHPwHD5P+MojfmBoquT9F+BIVMtJ0Qov/SZ4CIaPFLRXNgiD1+AdgC3jAiOmgp+V1uH8FWW7pSMD72eBCHQ+mefxzW8abPd74KcI+Cvf7QD1S/b7vi1On6HbKEw2Jfvgt1oVy5ITk1ss8U/XuKZ4pHDxEUzEfaDkex2b6hR5oXCgSmCtZbFpuG3sXQ1ho12YIShoEg3J1ewcG72OYi17pNeDsn0
 JOhi8u0F
 TRna79XdcZ66Ia6KHgM+oaok1oLW2ayxN+ML37uMa9IAGoUgx+o16xzZBfNd7ztg25pIWNV+z90Kq9PyT+oRt2NBBQZoNL4HRJqViiqTJ+1QoJAniEf5knYCPD5VxUP6ROUJkpvh9YR20nBxbEQW/lkB7iPrNseDEILbH1ERgmpj7PtVj9MOEkGxE5E9yAjlyKBXG8dLG5K90LDk2Uv5eajFMz/8zs13338EP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 12:28:17PM +0800, Xin Zhao wrote:
> For some embedded systems, .text segments are often fixed. In situations
> of high memory pressure, these fixed segments may be reclaimed by the
> system, leading to iowait when these segments will be used again.
> The iowait problem becomes even more severe due to the following reasons:
> 
> 1. The reclaimed code segments are often those that handle exceptional
> scenarios, which are not frequently executed. When memory pressure
> increases, the entire system can become sluggish, leading to execution of
> these seldom-used exception-handling code segments. Since these segments
> are more likely to be reclaimed from memory, this exacerbates system
> sluggishness.
> 
> 2. The reclaimed code segments used for exception handling are often
> shared by multiple tasks, causing these tasks to wait on the folio's
> PG_locked bit, further increasing I/O wait.
> 
> 3. Under memory pressure, the reclamation of code segments is often
> scattered and randomly distributed, slowing down the efficiency of block
> device reads and further exacerbating I/O wait.
> 
> While this issue could be addressed by preloading a library mlock all
> executable segments, it would lead to many code segments that are never
> used being locked, resulting in memory waste.
> 
> In systems where code execution is relatively fixed, preventing currently
> in-use code segments from being reclaimed makes sense. This acts as a
> self-adaptive way for the system to lock the necessary portions, which
> saves memory compared to locking all code segments with mlock.

Have you tried mlock2(MLOCK_ONFAULT) for your application? It will not
bring in unaccessed segments into memory and only mlocks which is
already in memory or accessed in future?


