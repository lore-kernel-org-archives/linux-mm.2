Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D794CCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 16:16:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B957C28000E; Thu, 30 Oct 2025 12:16:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6D01280003; Thu, 30 Oct 2025 12:16:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A835928000E; Thu, 30 Oct 2025 12:16:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 99FAE280003
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:16:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 49A8586864
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 16:16:28 +0000 (UTC)
X-FDA: 84055283256.05.F764D8B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id D87D440011
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 16:16:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IUpkgIJe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MZUpz6qf;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ooYG3jLR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=40mu6gCN;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761840986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ws2IvvSmb3F8a9GRXxvscM3N9dgSAoNfYV/0ReFtdwE=;
	b=FziM/TP5WxobJjezHVnw3V17zdF096kLtrb7SAjb7Ad6whXBQFgu2CeqAfV2IP+7hmYAKo
	/5Jwctb/GyoX8jieQQJLKz1h2JEkUEDHOF4YYaGnY0rMDNXjehjSrZh48Rk1fK+velpnCD
	2CBJXp2Q5Af1ZoZ7fEDjinfTvdJACPM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IUpkgIJe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MZUpz6qf;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ooYG3jLR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=40mu6gCN;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761840986; a=rsa-sha256;
	cv=none;
	b=5KNwI5XK0n9NEXYXZpXjMlBiyervVXwOtt2aQ/Vbuhkv20vkEQDL1wmoRfXxpE5F8mJxi1
	2Folhf/xKjnjDc+5s2mMuXpjHacgsqTnKoHYFLkBaKqp6HgApBUrUpSNhkwfdmDcibhX8F
	dBC+DV3/WHUAqkGb0k/ElpiNlAlXKT0=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EBB591FBB4;
	Thu, 30 Oct 2025 16:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761840984; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ws2IvvSmb3F8a9GRXxvscM3N9dgSAoNfYV/0ReFtdwE=;
	b=IUpkgIJev8v3zO2amlJkGs+PpsdjZJ0dw0DYHtfVKeeH95JvKqQjTP/tPpPvqp9UJqxVnG
	liAPoJH7yFh8jWOGS63mW76eLNsk2D16i92YHghTy/UlXhWqlOirj9WrOsUzgW5R1QavOZ
	chi5tqueUhw8JzVm1zPCWWJZcY/uU8c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761840984;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ws2IvvSmb3F8a9GRXxvscM3N9dgSAoNfYV/0ReFtdwE=;
	b=MZUpz6qfpTzlkFOwusQLGuFFnp1LFib8qcFoerV5LwFQ7EX4rt5pAA8WhvoEc1zsFCJ4Gp
	EjNzL7OnoKaTMnCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761840983; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ws2IvvSmb3F8a9GRXxvscM3N9dgSAoNfYV/0ReFtdwE=;
	b=ooYG3jLRrNbV3eNsyUdEkT5PDDatPtyDKZmFfTMNozZ1Zhc8JHXjOTx+nUHGlWA48UfPG+
	UTx9XmUK9Xm4fhQpPYIf6YxNxoXyyViPorxL4VSvMqNfelOGF45ZcNH7VOoIOuMaByAfcL
	6pLXqMcu8Vo6mv8CVm6Y1QZwtUEcmOE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761840983;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ws2IvvSmb3F8a9GRXxvscM3N9dgSAoNfYV/0ReFtdwE=;
	b=40mu6gCN8AasVH7KDnpbe/VhfVmMfvxa23JAiN1+iiBYWANWgDtt7kXiyrbB/26anEKMOW
	8OVBJjVROr1qK9BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 984B51396A;
	Thu, 30 Oct 2025 16:16:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JEnYIVaPA2kRDQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 30 Oct 2025 16:16:22 +0000
Date: Thu, 30 Oct 2025 16:16:20 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@redhat.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jann Horn <jannh@google.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Andrei Vagin <avagin@gmail.com>
Subject: Re: [PATCH 1/3] mm: introduce VM_MAYBE_GUARD and make visible for
 guard regions
Message-ID: <xnsn5rfqigbm5ryjtbf2rtfotneiwygzesvyfdxiqrzlyzljdr@tmbht4ggnjcv>
References: <cover.1761756437.git.lorenzo.stoakes@oracle.com>
 <7de40603015dee82970f5d37332a6d5af7532063.1761756437.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7de40603015dee82970f5d37332a6d5af7532063.1761756437.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: D87D440011
X-Rspamd-Server: rspam03
X-Stat-Signature: tot95oq3r1pbnjoq816k996sdzussu9e
X-HE-Tag: 1761840985-407446
X-HE-Meta: U2FsdGVkX18Tsa12B+WT7OuOpLmKj4CefaZl3srjYcERhXnXywIFkLFDXRW5GLXS/YEDWiVDPcygs8b/1ichsf++xPKaiSYFiECYHKQXTnNRFkpd9TLv9TAP2ltOwE/Hb2SvbhuY03ageMjr5OSaGIcn/x3I/LDRJJkYR4CmTSPQHpEG6KlVWCjg6WXAhoNxRbulMkTdb9gNt9/S6YW1NOqsKyinPj3r2csh9iRLcWhFnGUCfz/yhzx7l1xQYYjAeOJ6Uwqb/l8hysebMdzP4jMFh5VPn0kufrpbmZZ4pmZDEN+PClNnfeTC4v4AurxEbN+i3qCb5k/HCRIrXSS+r6VwiHD7JY675D/E9WzhUJk++FnSj3NtIriZDn5lGlCdjGm0bJQYWnPSbBVWceIC1/6vW4jVL1yqfAnn9Jaqok4Z3C6EWjoeQxa0jTzb97UA1xRezpQqPOT+l11TyPi0ZfWm08PbWj5JP0H7GKaFYMT+dLFbCfqomIVsZSho8z5lCTnnAaU1S2TOnkuTk/d13pX4pYLpgt1n/LdO43whiPH7INHUlkoxUZmyj2ZK4DtDMu2uFHmVvT9lcJQ+5C+c3kXmZlMBEI7rZMzN4w1JTI82jpysFJfN5pwwuxea3mJcUCb/9+3c497PLdTWj3Jk6TxYKLZxx09VeUn0sBS8h/aWuc8jUtAEe1gzkmtIZnebDFvdt0D0YvpG5I4Q6Kyg4078lpgmCIcsyVQC9rQHRvB18Erw9QlvUeZvKyo4NSPmSOfDB/+Owcd4nqoWebf2i107zMsUjVXPFoiwpaB8JGjOtemJtRe64XEyBJMeK7nEJPahV4dLeooiE9xqj/LNTbnjaZAVroURi7YBvjTgYlL/zkQUAqac2KVejNVfNx129PPFZrPTkaDvWLPHUy5e9q4xvmoRMVw+1dRcfrgCd3H4VuaQMZlXWWLOMjP0w+6nV+tcalRfaovR4zoesre
 kK60ozQw
 Ub/NBqtH8U8xvFWREDa5SRpYXEZMGbvYwprx3g+k0hvkkVf1TrQV2b/h9TA+NmVzHG15OFtGx+kNgVER52IGNndr9NQEne2OD2IPmjtcwKJK11PQ4d5D2VR3pygEZuMhKAaH9jntdfUnCzRvODW2KEH1ms6DPJIhm/35xZowDP9wO/GHjDxvgwwleVafFVWBbN1kUpHW4+co1TZjy6beUuyiyHwU2hAa9d9QGZaEEWXiJSygoGiydsymiNT3sf9TemnSOufx9v0DivXipLpUIIjnJz0ppO0/JWuReYcNP9kRjM3JD8knd/Cjp98D5nJlMDMPAjYyE+q/L3pwoCVH4XKX1NN0MjRZpJpld
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 04:50:31PM +0000, Lorenzo Stoakes wrote:
> Currently, if a user needs to determine if guard regions are present in a
> range, they have to scan all VMAs (or have knowledge of which ones might
> have guard regions).
> 
> Since commit 8e2f2aeb8b48 ("fs/proc/task_mmu: add guard region bit to
> pagemap") and the related commit a516403787e0 ("fs/proc: extend the
> PAGEMAP_SCAN ioctl to report guard regions"), users can use either
> /proc/$pid/pagemap or the PAGEMAP_SCAN functionality to perform this
> operation at a virtual address level.
> 
> This is not ideal, and it gives no visibility at a /proc/$pid/smaps level
> that guard regions exist in ranges.
> 
> This patch remedies the situation by establishing a new VMA flag,
> VM_MAYBE_GUARD, to indicate that a VMA may contain guard regions (it is
> uncertain because we cannot reasonably determine whether a
> MADV_GUARD_REMOVE call has removed all of the guard regions in a VMA, and
> additionally VMAs may change across merge/split).
> 
> We utilise 0x800 for this flag which makes it available to 32-bit
> architectures also, a flag that was previously used by VM_DENYWRITE, which
> was removed in commit 8d0920bde5eb ("mm: remove VM_DENYWRITE") and hasn't
> bee reused yet.
> 
> The MADV_GUARD_INSTALL madvise() operation now must take an mmap write
> lock (and also VMA write lock) whereas previously it did not, but this
> seems a reasonable overhead.

Do you though? Could it be possible to simply atomically set the flag with
the read lock held? This would make it so we can't split the VMA (and tightly
define what "may have a guard page"), but it sounds much better than introducing
lock contention. I don't think it is reasonable to add a write lock to a feature
that may be used by such things as thread stack allocation, malloc, etc.

-- 
Pedro

