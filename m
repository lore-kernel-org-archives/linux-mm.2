Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B4DBD7788E
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 17:10:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57BFC6B0519; Fri, 23 Jan 2026 12:10:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 529616B051A; Fri, 23 Jan 2026 12:10:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40B2E6B051B; Fri, 23 Jan 2026 12:10:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 301F96B0519
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 12:10:34 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ECEE2D3089
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 17:10:33 +0000 (UTC)
X-FDA: 84363867546.01.3A469FB
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id 63E6D20015
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 17:10:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WIrHq9eo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=wnqTS+Ch;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WIrHq9eo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=wnqTS+Ch;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769188231; a=rsa-sha256;
	cv=none;
	b=W+cHPCIzzgdMeHUSkT9KQ0ry2029XrqduXLUhLxF8oIMPNqbx+h1BCicEm351ZWf4wG1Zn
	k3YDkcdhRpLQ9vAFX4/A+um8G7VYtyNp8L1f5ZZ30jbPGlwCV9ue9mBA5/LNTa03Nnf5l6
	d0lcAMGukGXXywLNtaJl5sIpow0HYYI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WIrHq9eo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=wnqTS+Ch;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WIrHq9eo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=wnqTS+Ch;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769188231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=COefnxKrthohmEAmzNOBJXQqeahkGFDrqejxR9Xv1ac=;
	b=Gul7FiGfCFhp5/K76ZG21PKHhWCz1+5U7EBkpVl8NMWrQdKjSDcKPONnRy8V5lROTFAzrQ
	pgX+ED1a1EeiF1QIs+5LGrDDSEqpwKCUsT6ET/KkIm+u14Wpvcr+APTxrhMN1CxCW46CUU
	mhrUYEvnYq/EmRKyY6Qn29R3Sl55/qc=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C0E2F3383C;
	Fri, 23 Jan 2026 17:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769188229; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=COefnxKrthohmEAmzNOBJXQqeahkGFDrqejxR9Xv1ac=;
	b=WIrHq9eoSsNBhN3IWvKpy/BymPPmxdc5xDRQg13JZy1JjsT+c+uEr9DnARSt75qTR4fzyF
	Czzaw14wY0u0stDjQTvCmKcvlO1YQDYt4jmY9n/Mnw/oc4a3QkkUo1Hlpme1ynLhl+NmP+
	qyPlYOOfBcvrgrSqoemVQBh3cRCaLRM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769188229;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=COefnxKrthohmEAmzNOBJXQqeahkGFDrqejxR9Xv1ac=;
	b=wnqTS+ChDelGyOzA0Eyf2RFAwSt/rw+3JjFcYWv4YH1qVr+AoLxeGhGxv5Mauh6bakc1BZ
	eRwIMEP3Y6Vit2CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769188229; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=COefnxKrthohmEAmzNOBJXQqeahkGFDrqejxR9Xv1ac=;
	b=WIrHq9eoSsNBhN3IWvKpy/BymPPmxdc5xDRQg13JZy1JjsT+c+uEr9DnARSt75qTR4fzyF
	Czzaw14wY0u0stDjQTvCmKcvlO1YQDYt4jmY9n/Mnw/oc4a3QkkUo1Hlpme1ynLhl+NmP+
	qyPlYOOfBcvrgrSqoemVQBh3cRCaLRM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769188229;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=COefnxKrthohmEAmzNOBJXQqeahkGFDrqejxR9Xv1ac=;
	b=wnqTS+ChDelGyOzA0Eyf2RFAwSt/rw+3JjFcYWv4YH1qVr+AoLxeGhGxv5Mauh6bakc1BZ
	eRwIMEP3Y6Vit2CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 90040136AA;
	Fri, 23 Jan 2026 17:10:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7PvPIoWrc2lJSwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 23 Jan 2026 17:10:29 +0000
Message-ID: <fefa442e-1ca2-4f56-95d7-db135ec3eb1b@suse.cz>
Date: Fri, 23 Jan 2026 18:10:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v3 10/10] mm/vma: add and use
 vma_assert_stabilised()
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Jann Horn <jannh@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
 Waiman Long <longman@redhat.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <43c90424ba0874a71bb7ab9d6423b3a2bf616f8e.1769086312.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <43c90424ba0874a71bb7ab9d6423b3a2bf616f8e.1769086312.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 63E6D20015
X-Stat-Signature: wycozgnk8pw4oisn6hd44mjundfx7go5
X-HE-Tag: 1769188231-513561
X-HE-Meta: U2FsdGVkX18K7H5yQUkQKQqN+Ka4xaOo946BlH92wGIsoS7cQOOZVGwb5xith43Qwm6X/oKwcpAzk0ttWFUrvLe1Ziqxyl+UVj238nRWGkDno85Q++Vo1AfMxudPBEfsS+4OfDfGxm2lBp1vRic+wLVP84ieKapt/lVYq9QZG+R2Mg4Ettgo91XtwlXqIpJGHNZ9723ycdYRLTaSdftrb9BWr2epNAbpsXVk08C4FAWxzEQlJeKojCRmmB4hrrEBqXjxo4vChDBom7C4JpruBGFR3hLif7w7erULV/KRdrRpnKHYzeV76KTunsjkr5Ng0aOYvvdQFGVe5WPwTqMa9/SPOXdB6LIpJGh/wsLfJSZMi/6MO3XZfkB8dbCKOH0Yq83Tok9Mt+YI4tSp1EKvJdI1w8HBAnVzAHNHHM/o6lVcQRnXCRRZEhGd1OUqLAGY9n4YQ9MeRpqGrnCtKXP1BbeNKpoI9eUKbT7cnEFjT3N0nfTPSN9BO9FlO4R8da/zx0DcgnUoopdZzZ/kyxvDgyGdkz4NQ0PKfhOoy+WIx3mepThCgCxgfTHXPakgrugvFYaZ+bWlwq7c9c5nUdiFRFTyxiyaVn2zW7B73KtfK9Quy6SvtDsYKDVLTBuDwaGEM4YrW7tr3DjdvKAYLJXzbkfN/ZalOB8jy9JXWBE8SKCypCmcRPp8vm47BFMqrQvGFQn0lGKqNmQS/2dgAdJ8tJk+pmxlkhnfainNxvkKUMlRD9sikKHs1y7/04SFvJfnHiuALjzFfivxvx7pyRBuRYV5dVJpz0kFVjlk4jN/AHySK36mNBDRsdaLcGBDPqpYiY8z2ynaspqP3/NzmWh2SOPWWuOfSfzdWoQFkf49wEkji0gi6Sq93ciyMNyTnT2664KMI68sWfpUEsUhcm86+2yRPtvtvD6tr1BlI0XUTRSccQwY5kEaGsLzcI6DMuDV91l09LL+te/IkZIuW/n
 s/Rkjf06
 2rmgfruQAXdRfZFnTX5U8moa1/F0vbNn8Co/8hCjNYa53R3ZH6D9F4UTnKJtfsOqo5snexbG+lpMiVrMPo1e8dos7VSbAKizuuzjFCvq59DujrM9XKsUhFyFqKFWdfSrvGL1fwpMU+MmD3v1rr+cozCB5Zy5DzJ8yzMD1Ott/Qg9BCuQ2z0vPUF7InvQ/NyCrOE6yLHa1U8MiOktFE9OxMa1c2QuCw71Cg/Fw9mFw+U0WKsY00OeZ4ZsJApWnAt9ewoVO33QBeQFIBbWRAZPM++cwCaKPFoq+4Qfutrdwmv8AlEcFBqOuBVfhOR5sQ3wxlrdFp7abVFfi+Wt8QyzHJPfqyzc74nE+KNb8B+EoGpGIodpxREjwW5syymjjl/9zkd3cjpg33XStjz/r+G2jNe5rRLig60vqLAhwWAevMwZlavA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/22/26 14:02, Lorenzo Stoakes wrote:
> Sometimes we wish to assert that a VMA is stable, that is - the VMA cannot
> be changed underneath us. This will be the case if EITHER the VMA lock or
> the mmap lock is held.
> 
> In order to do so, we introduce a new assert vma_assert_stablised() - this
> will make a lockdep assert if lockdep is enabled AND the VMA is
> read-locked.
> 
> Currently lockdep tracking for VMA write locks is not implemented, so it
> suffices to check in this case that we have either an mmap read or write
> semaphore held.
> 
> Note that because the VMA lock uses the non-standard vmlock_dep_map naming
> convention, we cannot use lockdep_assert_is_write_held() so have to open
> code this ourselves via lockdep-asserting that
> lock_is_held_type(&vma->vmlock_dep_map, 0).
> 
> We have to be careful here - for instance when merging a VMA, we use the
> mmap write lock to stabilise the examination of adjacent VMAs which might
> be simultaneously VMA read-locked whilst being faulted in.
> 
> If we were to assert VMA read lock using lockdep we would encounter an
> incorrect lockdep assert.
> 
> Also, we have to be careful about asserting mmap locks are held - if we try
> to address the above issue by first checking whether mmap lock is held and
> if so asserting it via lockdep, we may find that we were raced by another
> thread acquiring an mmap read lock simultaneously that either we don't
> own (and thus can be released any time - so we are not stable) or was
> indeed released since we last checked.
> 
> So to deal with these complexities we end up with either a precise (if
> lockdep is enabled) or imprecise (if not) approach - in the first instance
> we assert the lock is held using lockdep and thus whether we own it.
> 
> If we do own it, then the check is complete, otherwise we must check for
> the VMA read lock being held (VMA write lock implies mmap write lock so the
> mmap lock suffices for this).
> 
> If lockdep is not enabled we simply check if the mmap lock is held and risk
> a false negative (i.e. not asserting when we should do).
> 
> There are a couple places in the kernel where we already do this
> stabliisation check - the anon_vma_name() helper in mm/madvise.c and
> vma_flag_set_atomic() in include/linux/mm.h, which we update to use
> vma_assert_stabilised().
> 
> This change abstracts these into vma_assert_stabilised(), uses lockdep if
> possible, and avoids a duplicate check of whether the mmap lock is held.
> 
> This is also self-documenting and lays the foundations for further VMA
> stability checks in the code.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

LGTM, thanks!

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>


