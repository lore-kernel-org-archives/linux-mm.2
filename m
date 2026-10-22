Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3FFE606A339
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 09:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=wbSI6Tl0;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=v9AH22Wk;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=HiClQ7/t;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=mzH+91u8
Received: by kanga.kvack.org (Postfix)
	id C72596B08F2; Thu, 22 Oct 2026 05:58:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C494B6B08F4; Thu, 22 Oct 2026 05:58:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5F756B08F5; Thu, 22 Oct 2026 05:58:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C1126B08F2
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 05:58:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7DB0E14076E
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 09:58:25 +0000 (UTC)
X-FDA: 85349812170.29.391AEE2
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id 65C9F160002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 09:58:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wbSI6Tl0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=v9AH22Wk;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="HiClQ7/t";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=mzH+91u8;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792663103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mkeR2xN5aVTEbqa1hAMyTZXFJ5arxpgOVE21xANikHk=;
	b=1Mb8gtmCmvN5bk7zZquO+X7i94K7eZW3mFAbJHFpaQKztb7ohKr9zeqfnSYhPlH6/Bxcoy
	Wl5XUOcAIUklADnx+aoLCJQAk/h9hxSaswKnJVhS5x4rybjpm3py2yQDSXXUIuiNCxhsHz
	/MnDMW+u6qXXV/1y42qkTUznw9LlZtQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wbSI6Tl0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=v9AH22Wk;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="HiClQ7/t";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=mzH+91u8;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792663103;
	b=hZu3ltJcmEMjmGcvEb4dEuzW79rXhKVhVXvyw9Zy/6Rjo7uVftDGA8qIHK0Z7jpLvq4fVO
	XZIcian27OryUc96wb07uGZmMJ/v0p89sKJV4FWjjFZzDR7p0lrumlk9p9ajN5DXB6Zxqz
	WLDDp0NJHYqOuvQmNRcvnTn7IIWUzog=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E2B8322147;
	Thu, 22 Oct 2026 09:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792663101; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mkeR2xN5aVTEbqa1hAMyTZXFJ5arxpgOVE21xANikHk=;
	b=wbSI6Tl0AyurldiYwrJmxhw/KQ+BB2YZ4Zt/QfcpU6aSnCtwVs+J3qwt7plCl0zeNbuIe0
	D+IwOcthmkVubsDm/Q0Xfb62h+4NMlApFqXZ0wQfpe8wauFxFPPnUu5YiNZfkAkpJ0Gnyn
	hTdodRnOsJHo1NxCK6+yY70p53ZfLuM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792663101;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mkeR2xN5aVTEbqa1hAMyTZXFJ5arxpgOVE21xANikHk=;
	b=v9AH22WkVZqe2ykX+rkXnkr9JnXZjmG6XYJbfYzdnzwnGIbrOnS0z4l+bV6HlHdiC8tDSG
	RcgitqdNhI6fHUBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792663100; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mkeR2xN5aVTEbqa1hAMyTZXFJ5arxpgOVE21xANikHk=;
	b=HiClQ7/tkj+ZJ+Qsx10KHvkjAoPh3hM8x6gk6/+k4qj8YCckcLj55oUrg9GHs02aN/ooLS
	UhPKfd1fPwEr2JhLsVEwKjIYNdGs3rhjsoF1OjEPmeQhNauiCbYfSedYWtWkFY7UjLbmFF
	w1Pcy4hVhup88Uou/nOQ3YDnBk5fckI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792663100;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mkeR2xN5aVTEbqa1hAMyTZXFJ5arxpgOVE21xANikHk=;
	b=mzH+91u8khRcUsfzzJYOkCc0iol88VLfRkvBzx9cqOQs3jnvc5F+hWAobqOphk3oEQhhcS
	TfqaGDqz4o7tfOBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9F011134E6;
	Thu, 22 Oct 2026 09:58:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id raenGjve2WrlCQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 22 Oct 2026 09:58:19 +0000
Date: Thu, 22 Oct 2026 10:58:17 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Shivank Garg <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Ankur Arora <ankur.a.arora@oracle.com>, 
	Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Bharata B Rao <bharata@amd.com>, 
	Hrushikesh Salunke <hsalunke@amd.com>, K Prateek Nayak <kprateek.nayak@amd.com>, x86@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] mm/memory: drop PROCESS_PAGES_NON_PREEMPT_BATCH
Message-ID: <atndhWpGDvs4vHoN@pedro-suse.tail5790ac.ts.net>
References: <20261022-clear-pages-batch-v1-1-13d3bd0b876e@amd.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261022-clear-pages-batch-v1-1-13d3bd0b876e@amd.com>
X-Spam-Level: 
X-Spam-Score: -13.30
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 65C9F160002
X-Stat-Signature: ohy38pzq8yaucmmecyy4q6a37q4i9378
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792663103-554246
X-HE-Meta: U2FsdGVkX18KmWu+SMtAR3v5pmos+UKsT9yhhBMI5wuJvqtz0HGaOmz8cZgK9AMj65DxIzYaDv6GcVTO86uQz3j4Cqiov+kg/fA06V6Q8719Mi1AwCgcU07PTeRG3Uy0QT8/PJD0lBWJ8Zv3zCG7cXLUQiT8EKW3mGz7twjWArHNEnG02rPy+Du9zOzhXYCPIpCCq+nIoivzZFv3vSYfNG7fn7EIHzFVmJY7mWmowiWjeIcEwdZbgAH1CQfiLSljk8gVbe4TR9lyUxE8HnBK5nYffcsqn7lqIl2Vt2vRA8jRpIMUGaSdamWtG50ajFg6Fq+iCpj2MhCcct57TeDsvHoFtJc9Lml84U39x+HR+zT/fX4wxqL2Fk2F83/2OngijMLvrzF1lyAgeqTz8iIib73j3ZoCGNT2qneSDSHBXPQAMFGBFU5Ij6ZxWhIbBfA0xnQWCVSR2CLqYlAQrAp08QMXKL6S5IAAqNwRPFdfBY9+wN7z4RMzq+u7XMAMvJDRYNpCRx8ZLTk2olFQjKGLZgqY7tI/c1Wo+Hj9Kqf8Z/Cl2s9hcs1p4ZtXCQDVK/44OCkDRoAoXlRN7/eOoe5vF5/Z+yPPzLCTuAWZswE5MWZRxnFYYSS1GueLy/RIVrjKeSnqgp4fn04KO5vIvggVD9JFmOTJ92f+t+XgxTMijdu0F6gdXAQywbrbuloTWiswcMJtpc2PTWNAYR7a8uxvYuhRkS142AD3FlDLvCBHwxD4NRKaWMSxb0+5yCkXNJ+QRAj91N/5/X/qA++qbkpzD4u0o4s7YIuvPyxJx0+mggjWQm4QhRiTeyWsHFjEVYbAt97wl/FhsAbPmbcb5twLAALlsde3451nNzYkYMuTrEYiJrKWvlsXY7fBDpk1JT9hOnm3aHcB1p1u/3y7J9luS6KMV9CuecFO6gvRW8KZxJWvqB1/UDudFGlRIutEjbFXOdRRAKqRjirSuZg0hGa
 GuXJJ9XS
 8p6sAgMA0sfZQh6lGX05UlyOQS3/gAuxl6fCvuhuWfcy4cOeFiIZeOTzF0GHQAEBA5EBjRQjkBPXmY4ZpTZ9ENqCecUgJ7hV+HEQnLqTvl+dlY9dayIhnye0/H6TFUbg1HTBj11fDLs18lxZrSYobsTFJNLNq90Q5baPyOQPnOmvAHHwQvTaCkJYeNiCbB9wjt8trSk5FxuukVEKcoFQCIEjTKfwtiZDLYkuiwSaDBCO17TJzsmnXr257ztWseKlze/nyHfFScvCItBQat/FZBxWuK/qEOm6nIGUPxhnyIFhHAMQ+VBKtz6d5ueXFLgyvfp4YkYnB5zqfjgVQm4PwcGrHYDdcwg45XRL2uyCZtccdu2Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 08:14:30AM +0000, Shivank Garg wrote:
> clear_contig_highpages() clears the whole range at once under
> preemptible models. Otherwise it clears PROCESS_PAGES_NON_PREEMPT_BATCH
> pages at a time, with a cond_resched() in between. The batch is 32MB if
> the architecture defines clear_pages(), and one page otherwise.
> 
> Since commit 7dadeaa6e851 ("sched: Further restrict the preemption
> modes"), architectures that support lazy preemption only offer the
> full, lazy and RT preemption models, also with PREEMPT_DYNAMIC. x86 is
> one of them, and it is the only architecture that defines
> clear_pages(). So the 32MB batch is never used: whenever
> clear_contig_highpages() runs under a cooperative model, the batch is
> one page.
> 
> Make that explicit. Clear the whole range when CONFIG_PREEMPTION is
> set, and one page at a time with cond_resched() in between otherwise.
> Drop PROCESS_PAGES_NON_PREEMPT_BATCH, which has no other users.
> 
> PREEMPT_DYNAMIC kernels also have CONFIG_PREEMPTION set, and
> cond_resched() does nothing on any of these kernels. So a build-time
> CONFIG_PREEMPTION check is enough, and preempt_model_preemptible() is
> not needed.
> 
> No functional change intended.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
> This came up in review of the copy_mc_highpages() series [1]. Pedro
> pointed out that most architecture are full or lazy preempt, so mm does
> not need to check the preemption model at runtime or batch the copy for
> cond_resched(), and simple per-page fallback is enough for non-preemptible
> models. David suggested doing the same for the zeroing path, and
> this patch does that.
> 
> [1] https://lore.kernel.org/all/20261019-batpagecopy-v2-1-d75e7d0dfaae@amd.com 
> ---
>  include/linux/mm.h | 28 +---------------------------
>  mm/memory.c        | 29 ++++++++++++++++-------------
>  2 files changed, 17 insertions(+), 40 deletions(-)

Awesome!

> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 35f5fc43861a..1083d0645d63 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -5269,7 +5269,7 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
>   *
>   * When running under preemptible models this is not a problem. Under
>   * cooperatively scheduled models, however, the caller is expected to
> - * limit @npages to no more than PROCESS_PAGES_NON_PREEMPT_BATCH.
> + * clear one page at a time and call cond_resched() in between.

Why can't clear_pages() itself do cond_resched()? Same question for
clear_user_pages() and/or clear_user_highpages().

-- 
Pedro

