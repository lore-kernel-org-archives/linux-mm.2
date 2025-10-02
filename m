Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0703CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 08:41:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 083BB8E0016; Thu,  2 Oct 2025 04:41:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05C1C8E0003; Thu,  2 Oct 2025 04:41:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8C1C8E0016; Thu,  2 Oct 2025 04:41:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D7DBF8E0003
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:41:09 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5F5AA869DC
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:41:09 +0000 (UTC)
X-FDA: 83952529458.30.D5A48E6
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf22.hostedemail.com (Postfix) with ESMTP id 253B7C000C
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:41:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Lc/6wD/n";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tcHAxREc;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Lc/6wD/n";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tcHAxREc;
	spf=pass (imf22.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759394467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eH9XbwduDIGri+NeNAU5ni9kwX6UbbeLjDQ6VnltoGs=;
	b=rq3vrjYFd9Cg2IQuNdznxsRhiH1MQUiCB43RniwHQPcLZvkaIXbep1careydB26mdNCeAi
	AqzpaPzOR/vtNGCE6QplQCpO5vp1ssDZJHqqUpONqy/3b5gSycOjj/AKXsUyG/h1StHRVq
	x4Q3ayLN2iMEv0Aq5TxY04yKR6rSXpQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Lc/6wD/n";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tcHAxREc;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Lc/6wD/n";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tcHAxREc;
	spf=pass (imf22.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759394467; a=rsa-sha256;
	cv=none;
	b=FD/AWXhSydcGn1Al5jHOCgsWgTS5bnQ9i1EiibzdT/CU4Fe5dqXz9DKUjjxVVR34tfqqWu
	nEzYocFhDtebsbkq4LF+kd9TE9KTZLfVwXYxypE1/wXZfel0BnW1AuvUOqSAdUS6QNKl/B
	vd58+L2bfz6GYbj7EABsabrIX83Fx+g=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B25A5337E3;
	Thu,  2 Oct 2025 08:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759394464; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eH9XbwduDIGri+NeNAU5ni9kwX6UbbeLjDQ6VnltoGs=;
	b=Lc/6wD/ntXWlBNi5/ZRhd/7YAZ8sznPJBX5RHRHKfwGfFA7B1tTT3QywcSDV1sOk0siYjH
	R6hTmmAXBQb5d50njznYKxwYtXyLHanI1MbzPdd8LE2n2yQwo3SWXoEcpG3z9stQ7qfbpm
	x4wQvipkO62kRiyy+xPyT3Whtjqjc5U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759394464;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eH9XbwduDIGri+NeNAU5ni9kwX6UbbeLjDQ6VnltoGs=;
	b=tcHAxREcGQBo6JX8Gtg5ds/wKcoNyYsuRu/FipYhTxV6aRrGhQF7GO85yTn7yHDEWd2ZQa
	dfY0rdGFcBMCunAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759394464; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eH9XbwduDIGri+NeNAU5ni9kwX6UbbeLjDQ6VnltoGs=;
	b=Lc/6wD/ntXWlBNi5/ZRhd/7YAZ8sznPJBX5RHRHKfwGfFA7B1tTT3QywcSDV1sOk0siYjH
	R6hTmmAXBQb5d50njznYKxwYtXyLHanI1MbzPdd8LE2n2yQwo3SWXoEcpG3z9stQ7qfbpm
	x4wQvipkO62kRiyy+xPyT3Whtjqjc5U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759394464;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eH9XbwduDIGri+NeNAU5ni9kwX6UbbeLjDQ6VnltoGs=;
	b=tcHAxREcGQBo6JX8Gtg5ds/wKcoNyYsuRu/FipYhTxV6aRrGhQF7GO85yTn7yHDEWd2ZQa
	dfY0rdGFcBMCunAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9C73013AA1;
	Thu,  2 Oct 2025 08:41:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1AMsJqA63mjaWgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 02 Oct 2025 08:41:04 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 15965A0A56; Thu,  2 Oct 2025 10:40:56 +0200 (CEST)
Date: Thu, 2 Oct 2025 10:40:56 +0200
From: Jan Kara <jack@suse.cz>
To: Byungchul Park <byungchul@sk.com>
Cc: linux-kernel@vger.kernel.org, kernel_team@skhynix.com, 
	torvalds@linux-foundation.org, damien.lemoal@opensource.wdc.com, linux-ide@vger.kernel.org, 
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, mingo@redhat.com, 
	peterz@infradead.org, will@kernel.org, tglx@linutronix.de, rostedt@goodmis.org, 
	joel@joelfernandes.org, sashal@kernel.org, daniel.vetter@ffwll.ch, duyuyang@gmail.com, 
	johannes.berg@intel.com, tj@kernel.org, tytso@mit.edu, willy@infradead.org, 
	david@fromorbit.com, amir73il@gmail.com, gregkh@linuxfoundation.org, 
	kernel-team@lge.com, linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@kernel.org, 
	minchan@kernel.org, hannes@cmpxchg.org, vdavydov.dev@gmail.com, sj@kernel.org, 
	jglisse@redhat.com, dennis@kernel.org, cl@linux.com, penberg@kernel.org, 
	rientjes@google.com, vbabka@suse.cz, ngupta@vflare.org, linux-block@vger.kernel.org, 
	josef@toxicpanda.com, linux-fsdevel@vger.kernel.org, jack@suse.cz, jlayton@kernel.org, 
	dan.j.williams@intel.com, hch@infradead.org, djwong@kernel.org, 
	dri-devel@lists.freedesktop.org, rodrigosiqueiramelo@gmail.com, melissa.srw@gmail.com, 
	hamohammed.sa@gmail.com, harry.yoo@oracle.com, chris.p.wilson@intel.com, 
	gwan-gyeong.mun@intel.com, max.byungchul.park@gmail.com, boqun.feng@gmail.com, 
	longman@redhat.com, yunseong.kim@ericsson.com, ysk@kzalloc.com, yeoreum.yun@arm.com, 
	netdev@vger.kernel.org, matthew.brost@intel.com, her0gyugyu@gmail.com, corbet@lwn.net, 
	catalin.marinas@arm.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, luto@kernel.org, sumit.semwal@linaro.org, gustavo@padovan.org, 
	christian.koenig@amd.com, andi.shyti@kernel.org, arnd@arndb.de, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com, mcgrof@kernel.org, 
	petr.pavlu@suse.com, da.gomez@kernel.org, samitolvanen@google.com, paulmck@kernel.org, 
	frederic@kernel.org, neeraj.upadhyay@kernel.org, joelagnelf@nvidia.com, 
	josh@joshtriplett.org, urezki@gmail.com, mathieu.desnoyers@efficios.com, 
	jiangshanlai@gmail.com, qiang.zhang@linux.dev, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com, bsegall@google.com, mgorman@suse.de, 
	vschneid@redhat.com, chuck.lever@oracle.com, neil@brown.name, okorniev@redhat.com, 
	Dai.Ngo@oracle.com, tom@talpey.com, trondmy@kernel.org, anna@kernel.org, 
	kees@kernel.org, bigeasy@linutronix.de, clrkwllms@kernel.org, 
	mark.rutland@arm.com, ada.coupriediaz@arm.com, kristina.martsenko@arm.com, 
	wangkefeng.wang@huawei.com, broonie@kernel.org, kevin.brodsky@arm.com, dwmw@amazon.co.uk, 
	shakeel.butt@linux.dev, ast@kernel.org, ziy@nvidia.com, yuzhao@google.com, 
	baolin.wang@linux.alibaba.com, usamaarif642@gmail.com, joel.granados@kernel.org, 
	richard.weiyang@gmail.com, geert+renesas@glider.be, tim.c.chen@linux.intel.com, 
	linux@treblig.org, alexander.shishkin@linux.intel.com, lillian@star-ark.net, 
	chenhuacai@kernel.org, francesco@valla.it, guoweikang.kernel@gmail.com, link@vivo.com, 
	jpoimboe@kernel.org, masahiroy@kernel.org, brauner@kernel.org, 
	thomas.weissschuh@linutronix.de, oleg@redhat.com, mjguzik@gmail.com, andrii@kernel.org, 
	wangfushuai@baidu.com, linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org, linux-i2c@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-modules@vger.kernel.org, rcu@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v17 30/47] fs/jbd2: use a weaker annotation in journal
 handling
Message-ID: <bmthlv2tsd76mgzaoy5gspzdkved6le5xv23xjsc3yafkhrsgh@vvmjdwygm7gn>
References: <20251002081247.51255-1-byungchul@sk.com>
 <20251002081247.51255-31-byungchul@sk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251002081247.51255-31-byungchul@sk.com>
X-Rspamd-Queue-Id: 253B7C000C
X-Stat-Signature: 4b1j6fxzxxaxym3x99bbhycrznfbudkp
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759394466-102019
X-HE-Meta: U2FsdGVkX1883jDTj/kt0lv3mH0qBWm219J/iXL3eKy4IhkcL4W/26XSIc4cqX7cxyP1Io0vRgWQVZr1bEqugAR4LnOk5otRHihhR02PoDnlGvV58CuM1oqaUx9/aHjbG5iiAVvaU2AJWsu+a/w+AFM7DmRZE6MU4iMNYUVWIvasNxctQMGevt2cm2m7oj3dIEfpE5WiT1U5riUKzNbXStCxhd4QKUcP0VlWJssggWhU/PLCaAuyvVqBuWc5+r3P4ft+pBg8k3AfIRSmdm2VYC7gs8yHgve1NnDYZuuS5q0Q0ZT368+EIEOQiPq/4L6Iv5LA/kTpX8amqXrOOixCLjYcGlKP5z8gEaL7RMXKkrLn0UYg7s4PsJJGWGYjpMBKPj6Yh2mCTd8RunWXfbQ4d4RKfGtb1hYmklFSPW48kS1uFgvmINMM4gVVUpNdrI+0mejkQZ+SD2z2s78c6OvGI55TvssjskbCg95RlSrQUxqJp8xh4ByPlQZUyQILy4IIwlYW1syndiKUOIZM6HlPESLHLhWMTb2iSE+1NHT75MJvs3jbVoTruOHEMjuWexwdwLmf0A6JeyJ1NS/UCDtLc++IYdUa/sIklP2xLsqO7K9/gF6+bPuYEUV+P33YmQXlVSW/GZr1KwtbQY5vx0pttIeSkw8xpCgpaVotVHiS4hq2WQhxUAE33en1bu6ZY3RzBnAQsgLOliAumySP6+ynt2T3sYtgNpRyx3731DKh6a2S+7XLRKyrJgE6Dwatmcahd2tIBhA0bYa4ljA56V7O1TEU+YVMe4xvH0VN19vbwpRx00i+0+SeIQah8Ckgf+8XExYQj4o73xq+tGY83sP6M67WhuQX95c2MyMlFxK6ggPeSfkYyir8t3qPk2ZGP/KElbaGT6pwvOE7TZFAhXSv2jQFumgZ8cpKckUQseGhz3WxRH3P98XJbM2GjyCQCPfTJkEPyQg/HH4E8Wz0ned
 epU9opw0
 kkR4b0t622EwlB+4X0KNwyN1KGyMiwXzW4KClYpsTHQrMCVJ+cFVP8tBHUL/OVNFNSdxXpPHmLeYkAPZRt/nkMh4VzdbRtzzoo8VBD/2UiUzHV1SqnFX2jUcjmxuPjNXca8EscunSOZuXTFs23I5p30/ayCcvxZrDxNWjyB/hycnv9bpT+On3BvhYDazawOO6vJXmj4QRzpSFor7/lr5bjSIngMkd8WL2FJutCWFAaeoJsPqcnQB+JJhkLvasz7dJ1zu03F1sjNC1x2RE4ZD+Nbxk4RUEYuGWsvn5trRiW1Z/fgbla8KSOgIgq7fc0dUqKrMwqRX3NQRtj7Rj5gvfaCj2E4a1Hueef/wWO2auI2+XE6qs1KxESxbqWlKdOAPdKatUXG9REatEO1VSw4eAbmdqJ0Jn2xuXZ54OQ+xu7Mg4FDjQun6ObZETfN2/qIc9vHRb5aFQWcIpMoOIrQcvqnALuRja6qXthYAN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 02-10-25 17:12:30, Byungchul Park wrote:
> jbd2 journal handling code doesn't want jbd2_might_wait_for_commit()
> to be placed between start_this_handle() and stop_this_handle().  So it
> marks the region with rwsem_acquire_read() and rwsem_release().
> 
> However, the annotation is too strong for that purpose.  We don't have
> to use more than try lock annotation for that.
> 
> rwsem_acquire_read() implies:
> 
>    1. might be a waiter on contention of the lock.
>    2. enter to the critical section of the lock.
> 
> All we need in here is to act 2, not 1.  So trylock version of
> annotation is sufficient for that purpose.  Now that dept partially
> relies on lockdep annotaions, dept interpets rwsem_acquire_read() as a
> potential wait and might report a deadlock by the wait.
> 
> Replace it with trylock version of annotation.
> 
> Signed-off-by: Byungchul Park <byungchul@sk.com>

Indeed. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/jbd2/transaction.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index c7867139af69..b4e65f51bf5e 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -441,7 +441,7 @@ static int start_this_handle(journal_t *journal, handle_t *handle,
>  	read_unlock(&journal->j_state_lock);
>  	current->journal_info = handle;
>  
> -	rwsem_acquire_read(&journal->j_trans_commit_map, 0, 0, _THIS_IP_);
> +	rwsem_acquire_read(&journal->j_trans_commit_map, 0, 1, _THIS_IP_);
>  	jbd2_journal_free_transaction(new_transaction);
>  	/*
>  	 * Ensure that no allocations done while the transaction is open are
> -- 
> 2.17.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

