Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07AADC87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 19:14:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C89D8E0005; Thu,  7 Aug 2025 15:14:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 977F88E0001; Thu,  7 Aug 2025 15:14:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8468C8E0005; Thu,  7 Aug 2025 15:14:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 71B638E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 15:14:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1C06F1A0AD0
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 19:14:14 +0000 (UTC)
X-FDA: 83750912028.19.A2EF9E9
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id E08ACC0002
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 19:14:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="LId+bL/F";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=i4iZDg0n;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=o6MzfGBc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tdtb7sUM;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754594052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L/gfEkfDLpTTAagakFGe8yIgKtQIh/Q1iMY2XUDy4Fo=;
	b=XwZndi1Dh7pFpUm/juPSYTT3aV/2ZYOn3MXDsjiH1emVVKHeKMij6NZznnQm3nUXrrWjOK
	GRStgUGMl59PXVPq4bdtpy07zJ1PG19CuQMfCly55EOGLeBwGPEQjZM/R7/kshKHXyhwks
	kvPqvFQdh9qrAdU/qO5z8KXzdTfecHw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754594052; a=rsa-sha256;
	cv=none;
	b=k0626aVbMeGccLXm5e1UE5q6uli3NIDrqwbA6DE5OsrLi5KAi6S3H4WS5oFC/by1w1m+SO
	zvdYJ4ptgHG4ZCYzIPVFONED0DYTtm/I7+mYr/Yxl0g1rP9grmbwCPM8Zm+ZlP/Mmfa9rp
	ckDdvPs5bxnizTxLNBZB7zvhAdr8VDg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="LId+bL/F";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=i4iZDg0n;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=o6MzfGBc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tdtb7sUM;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 17BBC1F855;
	Thu,  7 Aug 2025 19:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1754594050; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L/gfEkfDLpTTAagakFGe8yIgKtQIh/Q1iMY2XUDy4Fo=;
	b=LId+bL/FjOVqyYx5UQow/lX2psBGdXMJGlip1Q2PfFPaE1qMtjSr9+EYmXrCHVRTIgg9Eo
	YQugun8SrPQ3iIblustN3rZ4nM3qvQpcuMBA4dLmxbfzonq/MZlWAfU8OIZ0IU9U8K3N5W
	uB8m09oTSxORGFIvkSXUFzeTjQdH1JM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1754594050;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L/gfEkfDLpTTAagakFGe8yIgKtQIh/Q1iMY2XUDy4Fo=;
	b=i4iZDg0nVy2YdWjJ42cZz00wcAt+EtjVfw3W+lg+miz5K/OoiqkJAP9epUeXYexn07p2Pa
	KMZqgxIkcjE35yBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1754594049; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L/gfEkfDLpTTAagakFGe8yIgKtQIh/Q1iMY2XUDy4Fo=;
	b=o6MzfGBcHeLQwPEkO7A5Py8is8IobReja9NrGDS3EnwCenhsaDz4wei5hD+1JEYn4sGxg3
	u0NHUxAHDqaFyeKI8FuKzf6f11QdH9epZV7zLZtg3j5NyIv0YXd2UKVkdOvhwjE0W5abvT
	Kwtb98L/fdydn28/EH/gfIaG5jnEJGs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1754594049;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L/gfEkfDLpTTAagakFGe8yIgKtQIh/Q1iMY2XUDy4Fo=;
	b=tdtb7sUM6JS1bFcW0dL30pGJDLPdVDojpVLkRk9RIyaQjr8DFgJ4Pzcm8cEKKGIsjS/xvI
	pXSyrl+/jH1mCwBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6554713969;
	Thu,  7 Aug 2025 19:14:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +k4vFQD7lGg0cAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 07 Aug 2025 19:14:08 +0000
Date: Thu, 7 Aug 2025 20:14:09 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH HOTFIX 6.17] mm/mremap: avoid expensive folio lookup on
 mremap folio pte batch
Message-ID: <ujfeyn2awquoc4pc7qxcnavgqcu57kvmdb66x2hyaeoiasq3w4@u5qlyyklfrld>
References: <20250807185819.199865-1-lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250807185819.199865-1-lorenzo.stoakes@oracle.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: E08ACC0002
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: yb9r57onz9ydss7768ojzpesq3w75phw
X-HE-Tag: 1754594051-985363
X-HE-Meta: U2FsdGVkX1+YCt2uPZqt/+DJWVz/MDXgp7md8Rr4WeLj/WSfokgCwhEzEBQF19PRmTo2bbaKVMiYyjP0ACQRd6y6QVicaO9ONLlV6fd68UpkwPhFY7+HWvEReqesO8c1pjETNyNnUcKtgIhyonrHiU8C3wk9ZYzEyw73v975PlVgBqFyYIg8Prf00QxzEHY81KLIkBfk4nqGvpzTKOBeOHXWVGo8aXiuAyS07J15AAIJ69kLp7X6XdMX6jTjdcn+851BlIyaFIBntlpa5YvwQCeFbkHxgCyhOyFK8g+V30v+vthFrTOjLa1DPJH4vHUYypyXyfhH0f8sDZlCFk6QO14K3GasK35Bag3CLBDNme+UKkmxsNllGvOyRaQ3vpzWarETruVPrhq1pecI9W6S1HfkYgTg9VJ9aSvHFOIgkM2G20Tjv/DwD6fHYt7EEwkSftEgY4oo2a0pn9hfH5nvjmhAYcu2oJQlTX45uo4o3ufNyRYdiPBs0WDwa5OwGrsOOq0kR855mRIAaTVGf2Iac1DHfwzNTCmw1Bn02zPm/5HbqLdXaAfW5vG2mKK/IbO7VrrlKKpbKPHMy36S/CgErd46OOVsk2l8nJas74xhah9baP9LvZ/ms7NyfFsZv3oV+NSk6RBxq0jAt1Cgh58JZKfrDC5TcISYLEq3S10t9kIRJf2tZ8iwpHau3KPI+ZV4RvrTTV3kVTgPfcOPGOGqzAo2i6y+tCEGpAiCNMDbuBV61NxhM4gmQ9rSMk0P53wZBQYHjlahRBUJ1+XILXsdBHGpSGYAUr8cC+7gwxTVz1O5C182zTigwRmIN3gKBifhEtdfuWagiHfvwl7Fhw0rszY2nSzkRtA3vBIIcPrnuCUrf02UaWkZgdFVZYMn+ZRNHF8Ad9hdOScuYwsf72yN1P+TOtLcTuoYbqsnMsUgeEIoMK4y7qeX3j3F3iURgK3ncUyvZ4q+mshfgtB4Fgl
 eygxIfOQ
 y1Co1wAyZkJoMfYGbquNGHFPRzMLUIzFT/6h0R+2umOnX8oYlQLoSajgPSEQYsUnZUz4lSDcEV77mNNNbqv78+SIq/zdZ8yQjvMKDj1qhUp7Bb5kdu3dg4TIx2N0ziHiw6nVtFP3KPA8Cyat6u8C1NAJ/HBEXmiYqjEhlsgycSnVGxftNQn5ZcAdea0yZWoiff72WuG7UE3Tmr+ECJ/6Q2KzG+6xWznFj8FRdK2k0ZBusurEVLtydxGNc7Z/J4w9B9jDHSyiqCmQ9Tx9+UluqPbOnAVUXGCn903w9zw19Y1mqxqCrPXvs8mMjeTnAoPNJn/CL9bSLHKoGH75PVTEcrdqXqR4dqMCawMx7Md9BHNlGH2tETwdAZGs+RQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 07:58:19PM +0100, Lorenzo Stoakes wrote:
> It was discovered in the attached report that commit f822a9a81a31 ("mm:
> optimize mremap() by PTE batching") introduced a significant performance
> regression on a number of metrics on x86-64, most notably
> stress-ng.bigheap.realloc_calls_per_sec - indicating a 37.3% regression in
> number of mremap() calls per second.
> 
> I was able to reproduce this locally on an intel x86-64 raptor lake system,
> noting an average of 143,857 realloc calls/sec (with a stddev of 4,531 or
> 3.1%) prior to this patch being applied, and 81,503 afterwards (stddev of
> 2,131 or 2.6%) - a 43.3% regression.
> 
> During testing I was able to determine that there was no meaningful
> difference in efforts to optimise the folio_pte_batch() operation, nor
> checking folio_test_large().
> 
> This is within expectation, as a regression this large is likely to
> indicate we are accessing memory that is not yet in a cache line (and
> perhaps may even cause a main memory fetch).
> 
> The expectation by those discussing this from the start was that
> vm_normal_folio() (invoked by mremap_folio_pte_batch()) would likely be the
> culprit due to having to retrieve memory from the vmemmap (which mremap()
> page table moves does not otherwise do, meaning this is inevitably cold
> memory).
> 
> I was able to definitively determine that this theory is indeed correct and
> the cause of the issue.
> 
> The solution is to restore part of an approach previously discarded on
> review, that is to invoke pte_batch_hint() which explicitly determines,
> through reference to the PTE alone (thus no vmemmap lookup), what the PTE
> batch size may be.
> 
> On platforms other than arm64 this is currently hardcoded to return 1, so
> this naturally resolves the issue for x86-64, and for arm64 introduces
> little to no overhead as the pte cache line will be hot.
> 
> With this patch applied, we move from 81,503 realloc calls/sec to
> 138,701 (stddev of 496.1 or 0.4%), which is a -3.6% regression, however
> accounting for the variance in the original result, this is broadly
> restoring performance to its prior state.
>

So, do we still have a regression then? If so, do we have any idea why?

> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202508071609.4e743d7c-lkp@intel.com
> Fixes: f822a9a81a31 ("mm: optimize mremap() by PTE batching")
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Fix looks great, thanks!

Acked-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

