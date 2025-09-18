Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96ADBCAC5A8
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 11:31:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF3B68E00F6; Thu, 18 Sep 2025 07:31:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA3EF8E0093; Thu, 18 Sep 2025 07:31:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D99C68E00F6; Thu, 18 Sep 2025 07:31:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C5D728E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:31:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9237CB5FCC
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:31:43 +0000 (UTC)
X-FDA: 83902156086.18.4C5834C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4DA7D180005
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:31:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lhdT2L1t;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=RiyRI2no;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="mZ/uXFCm";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=F4mpeiMA;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf06.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758195101; a=rsa-sha256;
	cv=none;
	b=Za156kNKbqfgiyhPjgkWk+qUBgoRD8Uf/V3ep40eFCwasCXZFsIofNiFGoJatRLlC5lxvj
	UJHhE9W/2VHpMNZFwxaki5vG45z0XG9s5m6wQOsMOv/u9iKAIedBgsrOTenBQI/QmaltUq
	80dDksxv4yip4PcE/8oRIEDaZHf4Pck=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lhdT2L1t;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=RiyRI2no;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="mZ/uXFCm";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=F4mpeiMA;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf06.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758195101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F0jk5pHWcSpilbLxJaV/z4FUuxkpZfccsNZuNA2Q9Bo=;
	b=oAt5UUyIbT2YwdI8CcpS+OW/YjoVrqdOJ/919ClYRkQ5orDJ/vjTEKpz4HkjIQDUyLYGGL
	zXbAy7+rfuTXHUOEFzSD55HnQwQQuiny6TVDjfwEpOJzwv6yq0FWK5cp9Rg9vyZ+0mTkl5
	X7ndX8AIvWD2ACnUwG3g4A2unryEUhw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8AE0233791;
	Thu, 18 Sep 2025 11:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758195099; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F0jk5pHWcSpilbLxJaV/z4FUuxkpZfccsNZuNA2Q9Bo=;
	b=lhdT2L1tZ/eU01dAvv55m+bCEsqSXn9IA/5PI3U3FxpNs0aIVG5VXdU/1hy0iSeEN7Pw79
	Bofhd8h+Lu/NUDQgTx+DFJ2rfruf0Ez7PC6X5J22of1d6Wb9cAQUAzeg5iFC2cXxYAzxBy
	JAGOlD4SlPjr6tEiifhJG8ab/O4KClw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758195099;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F0jk5pHWcSpilbLxJaV/z4FUuxkpZfccsNZuNA2Q9Bo=;
	b=RiyRI2nob+MF0STXidJ4xVHvz+Hvs6a7btnXjChpqptOZmH1OMRuQau6ztX6QilOsI19tM
	mWjgrlV4vqR3/4AQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758195098; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F0jk5pHWcSpilbLxJaV/z4FUuxkpZfccsNZuNA2Q9Bo=;
	b=mZ/uXFCm/LcB68G+Pulz+vmUd3OkOcAShB69OktBNN3CDzNOUlingOy/CvYD7qdUPgI1pD
	SIT86IppWhAFXzD3Adv0o6HXgCYSPrRAOiK85uI5+GizLBu7dT+PSMZDf/D257u/Ah4LNl
	j2rcNCxlLRaGLIFjVQ9W0ZkBFdbN/vw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758195098;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F0jk5pHWcSpilbLxJaV/z4FUuxkpZfccsNZuNA2Q9Bo=;
	b=F4mpeiMAiFwgKtIBR86KL8f7OjWr7aG5rnz8aOXCA4LWMC1X5SXu1uiugKiTYOreT33gH6
	4P4VfZBx5MQ+j7Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 80F0C13A51;
	Thu, 18 Sep 2025 11:31:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id r3swHJjty2gJBQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 18 Sep 2025 11:31:36 +0000
Date: Thu, 18 Sep 2025 12:31:30 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Kalesh Singh <kaleshsingh@google.com>
Cc: akpm@linux-foundation.org, minchan@kernel.org, 
	lorenzo.stoakes@oracle.com, david@redhat.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	kernel-team@android.com, android-mm@google.com, stable@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 1/7] mm: fix off-by-one error in VMA count limit checks
Message-ID: <zol3d77dnwgrkbwc7lui3qm2mkwqftzifr6gn7smtbg4jo4bte@y4dzwfvt2xtj>
References: <20250915163838.631445-1-kaleshsingh@google.com>
 <20250915163838.631445-2-kaleshsingh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915163838.631445-2-kaleshsingh@google.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4DA7D180005
X-Stat-Signature: agiaco99z5ijeua8nq5pudh9mo7ronu3
X-Rspam-User: 
X-HE-Tag: 1758195101-276696
X-HE-Meta: U2FsdGVkX1/y1GAxQ+MwvSr6auh/qg6H1tkgW9i7clHEj7qKVXu/FixK6Qme1jWUZzWtXxKriZzAKecUw7zLnACsP41twUiBxYYP1mzHjXwgl+XxCV0IcGw9Xyx+CsgfAS63JxdNTSPf7Ku+an9NzE8Q8hECy+YgZ0FZj6aSQaBvEtRabrzrLZJVmy06glbPJyswB7mUVuk4EpRKqhgtCxnf3GvL0Z9DU5mMnNWotoK4iBmW+e0iYsIW66Evkoe8txIXL5ZNwTk+davBaj8/GcN8NAptmE26VxuFZZhXfgChgL3lY+XeWsxBqPkQkb+9aVgKhuIkf7p6WzrmeiASMZi4l2PifXdyv6gcGgGMySEUHjhgGjm2gdQaeV8ws3YZ/CSv2FXO1OQc2O0bAU8k+SzhtSdc9WXtTzqKifNKpEB8OUOpqt0yxtOa4+HHj9fpkA/hHSUQr/M4eJcdAh4VbLCo0DZySX47cpUAUEkmHaNN2pOdUe3L30t8103uwDEjJli2TeW0E/xhMxppyEsxWtWMioIVa87LRv6CZWtFTqzu2zqCkPdNnW3O4RbEpycjsuAUyGvYERgG2fGJCpXDuIXqylYuwWo9sheyOrH/QJUMUZU5zZREf4AutduatZbGxG7n13cNA9b4p/smjtOrq3QYE3yBIY5ChVFEp9i/BxM2ZofNzny2JtSGAEqe13Bcwn0+LIAuVXN49c8Xue5DOCKKhMQgkrylmAzlFFPbHmQaq8bzjmwDBIfuFlazMmpD5tstFn850c1hP5/ALXaXp/p7+hwdRtnLtjlWr0v8EybScrt/vip77fuYLGSGl7QZ7a4W2BC99erGe2V3ZkwTffdEoI1zmwhFpH0q/5KjAxUuIHjJUS6hI8Q473mQ830LdtzqI+oOFm9Ved0yiAynH+GAHHTqGn3Sir+1DjDAObrktUiI3w+8CGYzdAthkfih2Zet1x2uaQHVpG/hKUx
 JIxlaYgK
 50NMPciyRAcpdx2qL6vFsD/Dbexng1j4/P/k8v0iH9JrecS09odS9dHnsNAngJjeZdVEuTymoYLmQiBkh1GJ6NOvkKiNYK0gFyN7E1yC91Bd4svo6Pu4MISjjQyCvcyoU4Cbzlze86w0oUe0xxceDwl19K7cdU+PHStJvOvcm2YzujVpNsoCpSX9plH69Z0nAXQIB7DR/Al0aU6s0XdhMCyLdD2fhJCi5yBVRr9b/+hKAr6qqUC1dTV38nslJr1A0w+do2hWuCTF2LxwsuKfn9ezZLK0Z72qyJfKB93RaVtZviJamp6NBRFH+nB/Z138kBrHLmNYFf/vLyp7PR4goTK73R34ic1LlaCD9WJAavsUq0IHAg2oo2CBAeuDRz7XKQAKxggQ84CQVPuKEtPGKSTQ/EKGiU+RdIt2zPb0MbFDsT9O+/Q1TNf2IXHRBfo8oSLMQnf2qm5pWxuA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 09:36:32AM -0700, Kalesh Singh wrote:
> The VMA count limit check in do_mmap() and do_brk_flags() uses a
> strict inequality (>), which allows a process's VMA count to exceed
> the configured sysctl_max_map_count limit by one.
> 
> A process with mm->map_count == sysctl_max_map_count will incorrectly
> pass this check and then exceed the limit upon allocation of a new VMA
> when its map_count is incremented.
> 
> Other VMA allocation paths, such as split_vma(), already use the
> correct, inclusive (>=) comparison.
> 
> Fix this bug by changing the comparison to be inclusive in do_mmap()
> and do_brk_flags(), bringing them in line with the correct behavior
> of other allocation paths.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: <stable@vger.kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>


Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

