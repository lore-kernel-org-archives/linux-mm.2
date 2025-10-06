Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA84ACCA471
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 12:30:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 236488E000B; Mon,  6 Oct 2025 08:30:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E6A68E0002; Mon,  6 Oct 2025 08:30:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D58C8E000B; Mon,  6 Oct 2025 08:30:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EAE518E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 08:29:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 94B9B87960
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 12:29:59 +0000 (UTC)
X-FDA: 83967621318.28.FF25C4D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id 546DF18000C
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 12:29:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BVO08Xak;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FQBKHr63;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FOaW6HcY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=c0UbS7nI;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf24.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759753797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vyqW8nLiPWPAJiRXQpuxsOwKZY0xb3ZGoJOwx1jSOEc=;
	b=l8SDsn33ys1VYR+tMThqvrI42wibh+bAlAafzrQmZfNjpckpemaI9VdVkB5g7CXlsR2w7M
	JLysMe2QgxiNI4nkRwGmE4RCqEa7aojDCQUMkFSvcR4qJmoTl6PlNxQvnlE1RMIoJaZl+c
	waEwG6rXReqWCpt6gILJosgBdG3HtjM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BVO08Xak;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FQBKHr63;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FOaW6HcY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=c0UbS7nI;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf24.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759753797; a=rsa-sha256;
	cv=none;
	b=gVPslCBP3b7Sy+ECyKZ9S8Nt6VOCaNx5+/+7RhFHJ+C/O56YXXseE32AEBSRLuL4ku35xQ
	uXfSUuWdfbhnaG+0vgudI/JToEx9KiCetGvyLGjGGlFQ4WnQvio9G+vtRtTfPLIXMLTVEn
	HHA61t4b11MQAGVzCZtiVGZRagQ8CDs=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D3559336CB;
	Mon,  6 Oct 2025 12:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759753796; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vyqW8nLiPWPAJiRXQpuxsOwKZY0xb3ZGoJOwx1jSOEc=;
	b=BVO08XakPjP8ynKlZGbGmlAnXcsax7UXmUWkJSs8ggIpvrhElXSNsopOyvSOS7aiv/2c19
	NugUKam6hQ/yxBP/f5fuQCX8o74wSr6yz+tld3uDqmMaMAijTBBLJX5inRwJwhO1sGKgSN
	FKjUS2FhVvhHA/mIZU4d40fRsV8xwc4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759753796;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vyqW8nLiPWPAJiRXQpuxsOwKZY0xb3ZGoJOwx1jSOEc=;
	b=FQBKHr63ktNeqRo3Bqv302IpiLoTCtI9tp7iXRuml8GcnAtNnFEkdbvoCi2WzScv+bnqp/
	hnuKAUlWdkk80qBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759753795; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vyqW8nLiPWPAJiRXQpuxsOwKZY0xb3ZGoJOwx1jSOEc=;
	b=FOaW6HcY9xIY65f1Sm98M98UVJNzuuVaGnpt6GhleB/mOJAnD50sqwOYurJiq7q7vVfYiO
	yphHOF8mqYWwoRXAG4Gk3j0qPn/xMsOed6+qe/3Hp9rcNlH6S2uE5P4a3RTMy1IpIKDphM
	naCP5llUSuZkr2GHd7aZQL8aaORwWGw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759753795;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vyqW8nLiPWPAJiRXQpuxsOwKZY0xb3ZGoJOwx1jSOEc=;
	b=c0UbS7nItRm4ET6nFbYZ+yAvL3DFRpSNNV3quxBgsEc806Kp4U9NdlfJ4DSKlYFAxXkdON
	W5TkGQmtPE/QXbBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3132113995;
	Mon,  6 Oct 2025 12:29:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xwdACUO242gfdwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 06 Oct 2025 12:29:55 +0000
Date: Mon, 6 Oct 2025 14:29:53 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm: Consistently use current->mm in
 mm_get_unmapped_area()
Message-ID: <aOO2QbLSTYXL2dMb@localhost.localdomain>
References: <20251003155306.2147572-1-ryan.roberts@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251003155306.2147572-1-ryan.roberts@arm.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 546DF18000C
X-Rspamd-Server: rspam03
X-Stat-Signature: y8tbtf1jgzbt1zaqwp418i6cn86jx8pt
X-HE-Tag: 1759753797-836184
X-HE-Meta: U2FsdGVkX18zehvRtBocwM2shUk86zYyTWVFfSzCFYULmPX+RK24TP81LH53oaC2bptSLqMSbEpbKFb0ZON3wvjA054FkPxZK3zjDgbnOuejTJyEMboijFXzydMEuiLphDkA51q5WzUex1G5HgBCs5VUJiwShdJaLd21IHs/v0A5UGO/3nMRrNP8UCmn2AzE+l9Dpqj/rzxqRNxYf8s68GrJIXGdkN/9MG0VsPlZfRfBscUFZknfBVlraiRF9viut3kTz1zst6YI49H9yVLVAPic7t6URX51B5JI6G7hd+SSaaSm6mFUpg2nRhbzd5b9wHWW8PzPUJpaSM2W7shO/cjoRNGbF0gQriKYqLwPI1XhW8WEl7xFyNsDsg342BX8CJYp+WzHeb95knO62H/54NohO9GWIePstzziN4i4Uae01Ov3dpHZeAKb70eblC/sEBwGLK2ks1ga/e3+SIKWdCTU0XzsTDawfLwWRXDefX/fIXx6bQjznDBAMEvGSFcd5VZHuy/S2RJUdHQwrM+bXq1IVqb08xgmx6NK75rm9tdcaieeY+B590QiwaeZIV43pKB8172OtL8rskGzyrqAfLMmqXRJSOdlEH/6O/5OBjkHqERAM/JBvvot04bIXvNoX9iQwzgWbFhfHPMbC72VaUoOxTVa5Txa/cfcEXWBfPMN4cVFuOVXSAcq5Iabn+WNjlZ5zGQ0qDnVe96kjjI/Q0yn2BNSi+M4CEBhT0J/Iu2ZBpckzV6ruXnEjTm7dqJTW4Yr5T9WQagcifThYQMx0Kuhm/IpO4R5uxAqq4vguI0I26okDqZyP7xUh8MNc6TztSXwEJNi/ayYSTM7wkLE8N2J8HH2wdkLDtG/slAir32a4cjC92KIIhgQbCcBLNKbei/io6SKwbrTJ3Hq79PDLLpuc3Xcx1h6De25zPHqr/xiv9irg6iGny7Oo1WO5j4l48zmNi/ByrIsmMOESFC
 j+PlmoFv
 Q5sqHKBaWMy5a/cgITG2C7UAOoRxJFr7l+8og572dZsQIAvxzBiALWyGeBNJRYeyEjor6VSGu7L/j7jlKElPYQKEa4QzIOpAA+7gQLMW+2874dHiYhQAFWAHQejVbbWfGB7apKr16PlhyxVEg8bARHQpMxsqg3FueHWxSS9HCiEeRCirFgT/8E1z4VLhVVWdN550ZYO4r7Lnu1SoUA5o++FTT33U1g9QECSyS2j9mmgZvPgm/7c6fr/nu3OQR+EPXM1Ic/mfUSrkl7gsBnQJ49e16ehkp6DG1MXlpjO7iNCrUQJ+XqzroDFfhPXXz7RQEaks/2RM1PVWYxNk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 03, 2025 at 04:53:04PM +0100, Ryan Roberts wrote:
> mm_get_unmapped_area() is a wrapper around arch_get_unmapped_area() /
> arch_get_unmapped_area_topdown(), both of which search current->mm for
> some free space. Neither take an mm_struct - they implicitly operate on
> current->mm.
> 
> But the wrapper takes an mm_struct and uses it to decide whether to
> search bottom up or top down. All callers pass in current->mm for this,
> so everything is working consistently. But it feels like an accident
> waiting to happen; eventually someone will call that function with a
> different mm, expecting to find free space in it, but what gets returned
> is free space in the current mm.
> 
> So let's simplify by removing the parameter and have the wrapper use
> current->mm to decide which end to start at. Now everything is
> consistent and self-documenting.
> 
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>

I think it looks cleaner:

Reviewed-by: Oscar Salvador <osalvador@suse.de>


-- 
Oscar Salvador
SUSE Labs

