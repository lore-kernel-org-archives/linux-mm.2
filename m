Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB3EAEE3695
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 15:33:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26F286B0005; Thu, 12 Feb 2026 10:33:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2269A6B0089; Thu, 12 Feb 2026 10:33:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 129546B008A; Thu, 12 Feb 2026 10:33:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 02F656B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 10:33:21 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CBAAD56612
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 15:33:20 +0000 (UTC)
X-FDA: 84436198560.29.C68441C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7C6E510000C
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 15:33:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UitqLLvN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0dwlKLb9;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UitqLLvN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0dwlKLb9;
	spf=pass (imf05.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770910398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PUg7sic7nAeAhYqHBszncRRyNR8QsfJpR5EFy8Kcid4=;
	b=khZmscBdgopy0Zd6e/kjjZTH9HWnmyF1SL33nMHgeFas2EAUkmEGFgdvW7wO4WiucyuUBW
	HxbRi0HOHiIPjglNg0AWX9N1oKM+v+bANEvMpKMCalj1mrX/1udKux7Y+PyxiwF7D7tIH3
	WgGU00qys8XwvodmmLDPoLCY+QWDqCI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UitqLLvN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0dwlKLb9;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UitqLLvN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0dwlKLb9;
	spf=pass (imf05.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770910398; a=rsa-sha256;
	cv=none;
	b=UHHN09bl4XWG2NPFNczdkEZWtsji8BwnHudA0yHj/Tik+2c7TIIoQg0srGXqZrTcDzRY5Q
	Te3XHJF+IwG7YULpuNwmD/WssDPicOeluZ3DMuMngCw6LwcL315KeDS69mJl3CHS9nMAlO
	7N7Vsd3j4iDQ86sk2qlpNEipL4/iDqY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F2C5F3E6D6;
	Thu, 12 Feb 2026 15:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770910397; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PUg7sic7nAeAhYqHBszncRRyNR8QsfJpR5EFy8Kcid4=;
	b=UitqLLvNryNQMlt7bxM2zYi3P3kqrV+BzvzO5AG7hjkiFxn09+3p73oYxgNLysD2nY4rDV
	2B/0zd7z2/8OL8IQFsLMtdESmnYFmRKVJtY72iQO+Vt3zOHaSoFaP4jXgYVbMk+bHhs+sL
	ey0W8jtMEWayTCCfpWIMbi08cd/bP0A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770910397;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PUg7sic7nAeAhYqHBszncRRyNR8QsfJpR5EFy8Kcid4=;
	b=0dwlKLb99vNt6BhJ+52POykSkc/FzwLoTmnYK6soyGp6KHAnQTbGFuGRg1A7b1oNJjkr3n
	MnWVF6Cmqj+YXWBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770910397; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PUg7sic7nAeAhYqHBszncRRyNR8QsfJpR5EFy8Kcid4=;
	b=UitqLLvNryNQMlt7bxM2zYi3P3kqrV+BzvzO5AG7hjkiFxn09+3p73oYxgNLysD2nY4rDV
	2B/0zd7z2/8OL8IQFsLMtdESmnYFmRKVJtY72iQO+Vt3zOHaSoFaP4jXgYVbMk+bHhs+sL
	ey0W8jtMEWayTCCfpWIMbi08cd/bP0A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770910397;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PUg7sic7nAeAhYqHBszncRRyNR8QsfJpR5EFy8Kcid4=;
	b=0dwlKLb99vNt6BhJ+52POykSkc/FzwLoTmnYK6soyGp6KHAnQTbGFuGRg1A7b1oNJjkr3n
	MnWVF6Cmqj+YXWBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 77B3F3EA62;
	Thu, 12 Feb 2026 15:33:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8Z7fGbnyjWm/PgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 12 Feb 2026 15:33:13 +0000
Date: Thu, 12 Feb 2026 15:33:11 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com, 
	jack@suse.cz, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, 
	kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com, matthew.brost@intel.com, 
	mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, rakie.kim@sk.com, 
	raquini@redhat.com, rdunlap@infradead.org, richard.weiyang@gmail.com, 
	rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, 
	shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com, 
	thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, 
	vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v1 5/5] mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd()
Message-ID: <vopp7gkaijjdjjhzjri7is636ne2mr4v3fe3jnoytfm76xuhql@6nvubnk6hctw>
References: <20260212021835.17755-1-npache@redhat.com>
 <20260212022512.19076-1-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212022512.19076-1-npache@redhat.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 7C6E510000C
X-Rspamd-Server: rspam07
X-Stat-Signature: 4a7zxqsmb7zucgyyhyq3d9pufmhm9zra
X-HE-Tag: 1770910398-101380
X-HE-Meta: U2FsdGVkX1+//A54VdjAG4gD1yiAMjyCCcuMC8xjKfNu1yHy3lD4DQK224cVMx6p5TZsc4OvW6YHt87B/IBJrXnTRX1gAEOkiCYV0Cadieh6En+GRoD7mdgqGc4ndzkcyXTpCAPhAGJBDS6gziCfQytL9Fk0JdmmmB+MV54f9+VNAqnDPQWnSoAgE20NFdZgEbqdviXBAuWu+REL0Sm0NctFP/t4aoGve6pxveTyIb4cXWmCI/sIVm/QHYA/zUcWA6kzvyKl7XE1G7IGk7ZhDz/rru04pOp0PTjim5PrB652IRFuSy0RtF2yN90eQH9t56j2cTgWKLdQzfCCbKVsti19uIei7V8D3hdbuOtEcxVvE+6otkF76h3jaVwbQyg5tBtitqD9glf1ux+M4yvzEsOvVJ/0//mUOcUPLcmNE+LlxpDk3DiZ86pjlyv7J1t2q3OmuZPZv7p6DOWMusk7KmWLqh9vr23gMRfPKdCnJv0f42gKYcW5jQxWCoyefPr9JujF7qh3DOGKifCO0asZlGvushhDRCfaZLj/PYNyXDs97Ag5uXzJPWoMHdEFQXMk4e8IX2hWbbeYjDUViigeRuKhD1gtEpgEsY/P4k/hydIqc0pQQMznlrOU/rT9+R4DMiMryJZGQ8iIElizcaLKjk9Ys45ZIlwKhLElgVOjEnzZJfNNwHbtLwn51xwb6jgR0/obNPpaaU7rirtG/Gk7nqnFRUHuDQljLLMVcodfLFDV6N7JuwiewXviVOAYfpsz1TFqX02FYw+IiCMqHQmJCZdA0Jjpa4QzEYUFBMHFWf/8JwuNNnI3eqw9DpafHsn9A6PlyCz70krlV4j1AR3RAKqcxXHFt0mdzjd2dirTG6HmKdO7esVidJk+pJNBAhgq+EOqKpbj90IUHn3+p/A57xwZyGSxdq4aTKLrSG8rF/vowq0kOtqdYEHU0DOgazE/CGxdkI35uyH6ReR+Cg1
 O0osPVyo
 0G3nXg6svqZNo79nYVZw4o6pfcPgXcaLxNz7z6Y8Nn0dwoSU5wMUWY6+U9PdUmRxxvZKlCEnjYCMrHuxPbJ5wapeDbforvdaZbUngODIwD7xTlHMCXvNzLsbcEIgWwultSNUPFcbuL/5kBtxsyx6MF4wqrA0gWNs8VNnQjCXmFu8xC+v9F9TXMsc6mMRgVad85YeaIrAxuoB7dul9Cyi1oa/awTye1yHy0TtVUISkoHC+E9r/R42Lu/j1kUDl9NPUsDDXdFlT/e1WYcRHtoPtDyR97r3aH0hfcahn1rU/hFpVsyVr2TNXiPHRYfzhZiTWxLCs+Brnnd96/BBAh0gbPeKcj9nKDDgnUi7LmNhuO5WWRyFE4LuIVG4pU66IK1kZNghGdpV5lPw3LNNpWa2GVpTwjG3QTwSMIJ4Gh+3PCHvDcbG5ryNeyW8ccG/2xOwwqWr+hoxoT8pcCj1kWCsgtMyu2Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 07:25:12PM -0700, Nico Pache wrote:
> The khugepaged daemon and madvise_collapse have two different
> implementations that do almost the same thing.
> 
> Create collapse_single_pmd to increase code reuse and create an entry
> point to these two users.
> 
> Refactor madvise_collapse and collapse_scan_mm_slot to use the new
> collapse_single_pmd function. This introduces a minor behavioral change
> that is most likely an undiscovered bug. The current implementation of
> khugepaged tests collapse_test_exit_or_disable before calling
> collapse_pte_mapped_thp, but we weren't doing it in the madvise_collapse
> case. By unifying these two callers madvise_collapse now also performs
> this check. We also modify the return value to be SCAN_ANY_PROCESS which
> properly indicates that this process is no longer valid to operate on.
> 
> We also guard the khugepaged_pages_collapsed variable to ensure its only
> incremented for khugepaged.
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Nico Pache <npache@redhat.com>

Acked-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

