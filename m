Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A492BFD7F91
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 10:36:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C77F36B0005; Fri, 27 Feb 2026 05:36:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C260B6B0088; Fri, 27 Feb 2026 05:36:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B31B06B0089; Fri, 27 Feb 2026 05:36:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9CDA96B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 05:36:38 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3DC571A0573
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:36:38 +0000 (UTC)
X-FDA: 84489882876.06.6F8CADC
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0F479A000C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:36:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vdNFoKns;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=t0LIudNu;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vdNFoKns;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=t0LIudNu;
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772188596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ye5dB3xbiUcpBLpOExWzZfrfWkSn07LKr5AIbjCsXnw=;
	b=oKQywJ/4ulx84KapDugXEwJuPsxavCzH+V0yCk/zzZt5bgYoqDnaTNYeDCQaoa2xFBTHgo
	3C1+2D1kwqFzrMbNSrGgjMJ/R5uIeNSk41qc4UlO9d3m6AzMVYKB93ae4IS871v80I27nF
	pmxP9kdkZohSmmdIqDHe7zczPL61T/s=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vdNFoKns;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=t0LIudNu;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vdNFoKns;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=t0LIudNu;
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772188596; a=rsa-sha256;
	cv=none;
	b=pAJYc7Rks59oYAF6tW37/GxLZ303gxPtV8wp0siJe0b2y2ppTq8TegUgyBbmU1UmErsGUw
	yCg7DohvytPrCpGzr+1Lhg2D7Qb++mLwgO7dLvc8VHxlo+qbowa2YSob4E433YgR09Z6VG
	t5LstYpVP5+HgiaDjD5xjdpuGT/ckUs=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5943F5BD5E;
	Fri, 27 Feb 2026 10:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772188594; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ye5dB3xbiUcpBLpOExWzZfrfWkSn07LKr5AIbjCsXnw=;
	b=vdNFoKnsTaVcrzMdQDm+RY90nrfm24FuddLYvphYaDef86nphturJxN+eh6g21WonyV/1g
	fzEKksrj/7VRN0LTxI5V7tnhktoGVAc+mp3227K0Qo+YPVQg/uv8l7wbpF9r+VrD1BrDNV
	JIYyvtpnLov9Sc916u1j2q0L73AAKR4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772188594;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ye5dB3xbiUcpBLpOExWzZfrfWkSn07LKr5AIbjCsXnw=;
	b=t0LIudNuRG+RwbL+1J4CeRUwrGR2bJ+0LnitsXQBLTsDNnQn20lF77lixnbqhRbLHpF1aW
	MG9L6TiwH9c5pWDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772188594; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ye5dB3xbiUcpBLpOExWzZfrfWkSn07LKr5AIbjCsXnw=;
	b=vdNFoKnsTaVcrzMdQDm+RY90nrfm24FuddLYvphYaDef86nphturJxN+eh6g21WonyV/1g
	fzEKksrj/7VRN0LTxI5V7tnhktoGVAc+mp3227K0Qo+YPVQg/uv8l7wbpF9r+VrD1BrDNV
	JIYyvtpnLov9Sc916u1j2q0L73AAKR4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772188594;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ye5dB3xbiUcpBLpOExWzZfrfWkSn07LKr5AIbjCsXnw=;
	b=t0LIudNuRG+RwbL+1J4CeRUwrGR2bJ+0LnitsXQBLTsDNnQn20lF77lixnbqhRbLHpF1aW
	MG9L6TiwH9c5pWDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0E4AB3EA69;
	Fri, 27 Feb 2026 10:36:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id awcFALJzoWnFbwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 27 Feb 2026 10:36:33 +0000
Date: Fri, 27 Feb 2026 10:36:32 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: anthony.yznaga@oracle.com
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org
Subject: Re: [LSF/MM/BPF TOPIC] mshare - sharing page tables across processes
Message-ID: <6dfb6mndousbfpsaa5ndcytjcpdnixo6yczjduogs6f7kb4ewr@zx23tvriuj2z>
References: <ea6c914d-44a4-4958-adb6-642e86488045@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea6c914d-44a4-4958-adb6-642e86488045@oracle.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0F479A000C
X-Stat-Signature: r6ir7nogepxrcjrkxi4nhs17xhzz76dw
X-HE-Tag: 1772188595-332391
X-HE-Meta: U2FsdGVkX19bMu73ZqLrfWpdhCnYcZTcDh9DUnP4TJjuMJobQ5dxyUv9g9qzE/VEUBFvSXQvR6XQi/cC563Z23qCZnGC4BpFp65XpVqr9UaRKIFG6/ls5zQZpBfnil4kP+1524CUDM6nQyWKEHgRIh6stQjnlaAjbcOL+zzfU5ykqh0ifWVHJ+Q3zHDb4ekFuQd5FghlOogE4B17+Pq9TAsZprAsIx6laUxo3j3G2IK4wztLC1N8tdVOdOrd0ogQG+w+k7XCFrAX3prs3Z1GSHZV3g2sDeCpFx9tc5MSRC1mUIYl38Gd9iQKGWLRMPTfGCJymeANsHb113wXwiXUJYVmerE2QnpJW8Golj0e95AYvPUrZUsi7umsS6FpWJS2YKKMzP77iW9AhRSTe+OsCi4Uu5OSgCZqBUWA4DPZkopk9VRUNQb+S7x7vm5Dx8bSoWRaVIoTd3dbT+Pae9JkzdMrKqe4ZGyvPU6phIuk4xUsu5j3mCUE5aa9piKGc9GzZLHB4/Fpfr2ynCZllyRlaWCtBqTrnxzI5p5rgClgyQVN4EAy8wEojhbmdURrjM7gyV9b1MCFYHRgDedQ7o8tFgOQ6nM/HP5hxdaNeVc/DsUrBA+eKiza9Obijx/L05+F9p3QaEtxzb21ZDXp9ayVLezIHDt3hQiQeEpdUWtVCLMHGkILkC5OXo6lTFTl2EJlPuhWjePEwHudIFrZ93V4fVH3MANtVC14RULIopU7nZycgfz90yAiPXj+53yOaDbPMNo+mal4GWKvVZMPHsIXxxKsyjKG+qhXsfZ1ITmmQkZh2UveowoTPqU3AAx8dgXieCiWulG5p71/0QT74Fqf88XI0QJysAj+Lhax1QuN/dRnxm7nh/mdPD3kK9z/QcKUxr4XK6qILzXRcua6h6S0NQi+VSJIT4mvtvkYg62FKIDmJ0Bhnxj65A5EM8YpjUC5zfC8/NzeZHdWPYlGsL/
 cQ1BLxUP
 n6HuQuMkyUFx00v3Oj0jeb440AbB+WCpYqNA/fEYgeXQWkvB9hnAnbYuv36tsxrzSM+kr/luQpwQ6mN7iG8OaRvoC31MHPJWpXkSk4ZSK4xlx77Bb3o//NdIeZ6QUlf2pGwdrAwFH6FUpJuMVek48ApIiwKKenuujjsHVJnn91ihyIzGTVd5Cbnc3gcrwfmYpBGK4BPLnaXC6a6J/IbH4DeE/tvwCEKn5qaUmhHUmX6+cftYIQE1U90Q3MpQ8gYF0yaRWQ/2GUgsJmzT73UAISbM9tD1H4iGM0DyUb7/07sFBVkghV/NFIIBz5Y1w2CYE2XvP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 06:11:49PM -0800, anthony.yznaga@oracle.com wrote:
> mshare is a new form of shared memory that shares resources between
> processes, namely the page tables entries and VMAs of the shared objects.
> Advantages include reduced memory consumption through eliminating the need
> for duplicated PTEs in each process, reduced overhead needed to fault shared
> pages into multiple processes, and the ability for updates to the memory
> such as protection changes to be immdediately visible to all sharing
> processes.
> 
> For some time now the proposed API has continued to evolve. With feedback
> from mm maintainers, a new approach using syscalls is being taken to create,
> attach, and deattach mshare regions and to map and manipulate the memory
> objects within a region.
> 
> Let's discuss the current state of the API and technical challenges of
> managing and accomodating shared page tables in the kernel.
>

Hi Anthony,

As always, would love to talk about this in person :) 

-- 
Pedro

