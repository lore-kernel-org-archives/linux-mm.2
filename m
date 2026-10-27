Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4D2F60A2601
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=CWV+pd7v;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=dH0yVuWP;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=CWV+pd7v;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=dH0yVuWP
Received: by kanga.kvack.org (Postfix)
	id DE7F76B081B; Tue, 27 Oct 2026 12:11:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D986A6B081D; Tue, 27 Oct 2026 12:11:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C610B6B081E; Tue, 27 Oct 2026 12:11:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A2E906B081B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:11:07 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EB26D4035C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:11:06 +0000 (UTC)
X-FDA: 85368895332.19.0A24A32
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id C6B78180002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:11:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CWV+pd7v;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dH0yVuWP;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CWV+pd7v;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dH0yVuWP;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793117465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YfHrAfI9Raij9s83r70SYcL5s7BnI9+K8vQC+GWWGI8=;
	b=TA0w/xzFJAlpQG1CMxUMnqdx0BOs1MQCTcX1yduB2bbAUhfQXUzZ/seDoA+R6ymvwmzEgm
	8kDFSfl2Zv+RlGksvPbBWb1FJeQjAY/8QyRNwOYqtqpU+iKNvloOooz2zmf0dAtrXhxD9r
	1mCn3VrmFkbaVAZQAict/vlIyDSkYUk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CWV+pd7v;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dH0yVuWP;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CWV+pd7v;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dH0yVuWP;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793117465;
	b=oGuJ0fABDS56EOTouMZoVQ6ZeY0OmUr+AQtb//i7TF2ZKXtCurOhwXCQfkwa58+48SY7Hs
	8Pleo38E0XVs8bUCz0B154uH3SDvelgCfgiNpSWW618UqYl7FtT/4uLXvJexGy/ArKBPrP
	lPkFlJrkRgGHzUZC/e1JOccRMma5yLc=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7C9131F456;
	Tue, 27 Oct 2026 16:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793117463; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YfHrAfI9Raij9s83r70SYcL5s7BnI9+K8vQC+GWWGI8=;
	b=CWV+pd7vX6TrUdMXNaxESYJ1slGQOcP06ic+g4xxjnPvWnvKsCWHc5jQdxIPIQbRLzO9R/
	diRP0hoJuL/mI0KQkpa3xxmXRWeSg74DGGEU77lFzSpCYYlDj7PdkWYefoW4nkJgVCUPf3
	QaNpFGuQxCzB3SqNtBvKB0BxwcTkqYc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793117463;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YfHrAfI9Raij9s83r70SYcL5s7BnI9+K8vQC+GWWGI8=;
	b=dH0yVuWPJUPJUjY+esjPpF+hgG8gt8lOiUDib4DBNfyZ2FqTmjKurTJ9mNNDDjXKRirJJN
	V99f8i/6XejizRBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793117463; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YfHrAfI9Raij9s83r70SYcL5s7BnI9+K8vQC+GWWGI8=;
	b=CWV+pd7vX6TrUdMXNaxESYJ1slGQOcP06ic+g4xxjnPvWnvKsCWHc5jQdxIPIQbRLzO9R/
	diRP0hoJuL/mI0KQkpa3xxmXRWeSg74DGGEU77lFzSpCYYlDj7PdkWYefoW4nkJgVCUPf3
	QaNpFGuQxCzB3SqNtBvKB0BxwcTkqYc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793117463;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YfHrAfI9Raij9s83r70SYcL5s7BnI9+K8vQC+GWWGI8=;
	b=dH0yVuWPJUPJUjY+esjPpF+hgG8gt8lOiUDib4DBNfyZ2FqTmjKurTJ9mNNDDjXKRirJJN
	V99f8i/6XejizRBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7B83C1321C;
	Tue, 27 Oct 2026 16:10:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qrX6BxPN4GrwdAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 27 Oct 2026 16:10:59 +0000
Date: Tue, 27 Oct 2026 16:10:57 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Hugh Dickins <hughd@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Lance Yang <lance.yang@linux.dev>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Minchan Kim <minchan@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH 07/46] mm/filemap: don't lose a folio lock wakeup to a
 signal
Message-ID: <auDM5mvsb5ilIdsg@pedro-suse.lan>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-7-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-7-6f74bec9a5bb@kernel.org>
X-Spam-Score: -11.80
X-Spam-Level: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C6B78180002
X-Stat-Signature: jfdytiymihh9t6a8ftm8osf5zgsuoiik
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793117464-978416
X-HE-Meta: U2FsdGVkX19f6Xys5KbS9lzo5BbI0eP09Cw2Mgyac42xxKt8b3FM4B62mC9ak33gfTizs6pNg2daJ6Hb4OsQ2oI6AEHBGmd9Z+1gLi6yrMy3ABbZIA6im784CdEeRlTyn1D6bITvltdA9SrZn/rAJJ5Lg6Z3pzxl5BXR2nifeOBa40icbKMQqf6FxvMcXtJ/MCCZ8RUTbXo09pPKpYpwRh2KzNETAKQbOqmybujLUWLdkpLU0N8yUteQvSiVWZD/H4OS3CTTX6TMLXqkC14c0A+b77VQtrqG9jSusZ7+E4H0rZu8/Pdp2FJlv6ylwOMdsHMh6wue5h8rCbOpQyoV2SjIb9+/GPb6WHLCYjmRyKfKW3zd6qSazNHT7cD06E/fLsGxHeGe8Q2mwVZR7gWR6ikVDNV9sjB28L20XRZ9NywQDIZ93sdy7wYr2JTHSzhn/Jf1U+29TN45FUsO+SjZCAjGN+ggxC088AobEQ2wa7wH6vdccHCxBNrSYDXCnlOIXnqPHDB0An3XI4IxnDaSZKGUjKm/sc79Ils8TFi8G86cELy/ekVasverygZbgr6P8YxXXpGCmBLtt2VdwnmQrixWiZa4ohOLTSFxDVHe1Vw/B/CnjOYrlWhiPMvDyNU69QGg4g8DgHK8INrOAAyslHO7L6Nw5vhH+G1USBP5rs224riR7aZcCI7ad2pvJXnqmDlBwe6sMrhKe7g9h2FlGBHfeW+iyFCMDjS+WKk6edfOFAF2UagkW3Ol6WqImwZhfyajE4szDbUc9Pa1gxhNAMRPZJXdyThmtmGxGNzWUHiHsdLGHMEOu1ynXzI3C8i9BXmTng6jFThJbiKAJMXd25S062WImLzk6RmujEidR80P/BtiPnohzq9bAhHOV/EDpR9DDDB7Btxuaz2YutL2XxFRqMVHz1cdnJ2Ioqpwi8ghR23vlsuDpHR4KBPxDI0xLOLnrSeztf55hb7xyRB
 c6vegJmq
 +3NCueoPRy/XA8SMRaLKuEqV29H+wEp8emUORAgkyzH751iCOYbFrlXRN6Eg5YI7tZ4TEgMMbSOJUsKjYzz3p0YN/IYO8luVgajx7aH0WVZBH0XsNKl08eD03qPuFHQ48QsLFjn3YndbBZxYKXPROrE9Igm8o8z5iZqIPCE4jDwFDh9zk/NxtgSsJ8CHqe09d4FDGZWNfl9cljCmuK3bFD920tYk3/5SmBNztSPMUrA9YyoA0FLf8UT+rqcSSbt4FncMqWbU0skb/ZEV8vc6USYBPpewJz3x91nr9cPA0YGSYWL/xmMWgbEic1Zff6ehwQ0K09TjCOAAfYrYTXqxXyx2GncFDEvli1qUjGcDvfGjpuJ7uMBd4XT5GJ7lvQMW+cJxG/a5DuYnciQxYFNsaUCslxMRW/H6AkpIOab8JysWYmJk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:27AM +0100, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> An exclusive waiter in folio_wait_bit_common() can leave the wait loop
> because of a fatal signal, then be woken by folio_unlock() before
> finish_wait(). If the waker did not hand over the lock, the waiter returns
> -EINTR without trying to acquire it.
> 
> folio_wake_bit() stops after waking the first exclusive waiter, so this
> loses the wakeup and can leave other waiters asleep indefinitely on an
> unlocked folio.
> 
> After finish_wait(), let a waiter woken without a lock handoff try once
> more to acquire the lock. If successful, return success so the caller's
> eventual unlock wakes the next waiter. Otherwise, the current lock owner
> will do so.

Has this been reproduced? I feel like this would've been found out by now?

> 
> Fix generated by an LLM and sent by Josef Bacik in private.
> 
> Fixes: 5ef64cc8987a ("mm: allow a controlled amount of unfairness in the page lock")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: clarify and simplify comment + description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

