Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF0AACC6B38
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 17:54:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A2AB6B008C; Thu, 15 Oct 2026 13:54:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 853376B0092; Thu, 15 Oct 2026 13:54:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71B496B0095; Thu, 15 Oct 2026 13:54:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 350076B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 13:54:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A79A212040A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 17:54:39 +0000 (UTC)
X-FDA: 85325610678.02.62980C3
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id 96DD68000B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 17:54:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=eXpwTksI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=iTxD0LdA;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=eXpwTksI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=iTxD0LdA;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792086877;
	b=FcdPg8HVEo91JbqQgizGGdY1eKqDd9vrRETAlPkCtVn9bkjaNs7L35582r5AjKuAqYqZdn
	BACbFABoWJz2qafvujfwZqm/MYFyGLxX0p+u1GQHxH8rjA71C2EGCKchjTo+iSWRUVlu2V
	vyBABI0ypkQ6s0z/Lqo9mZ9VxgByWVA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=eXpwTksI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=iTxD0LdA;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=eXpwTksI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=iTxD0LdA;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792086877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UUX/20c9gzfr6HYGt27BVt9vlp/ySlxzUbbSfr+xZUI=;
	b=aBqZ+Sn3bgb09mjhUtodR6AYf58MDR88Qnf9zLvRlIroTxwLKMz6KgIisZrIpn0pPB5/Hy
	FmPJn1hopdHxn4vEcDz2yAHpZB9vPHPxwQJ3F5XBiafjhBgdpGGoZTT8yaCkoGHr7P5yPV
	h3SnqpnkOsYH+JcqcIRYZEvuZCWDa5A=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 02F50223AB;
	Thu, 15 Oct 2026 17:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792086876; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UUX/20c9gzfr6HYGt27BVt9vlp/ySlxzUbbSfr+xZUI=;
	b=eXpwTksIT9/Go1ofbOmdU0GZvbkw5AyX5pLHwi+2EKjRB6sOz9eGvgakUD8O5a7D5/19ut
	4nm4lk/n01AwoZscIQIgq0wHxQNi5kf0X7qhAhpzIZHgiY2Hw2yiLHg2d/EG4MV5CfmS46
	FvzsWCQrEs3nPP7g/iIOz1rWsSk8mo4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792086876;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UUX/20c9gzfr6HYGt27BVt9vlp/ySlxzUbbSfr+xZUI=;
	b=iTxD0LdA1j7nQ1dEwmMrePAU7KHf4w37NgNPespccr/3SWDTWNo2jSNk71iguUOzjHCTXZ
	2jnCQ36Nk+Cbh1Dg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792086876; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UUX/20c9gzfr6HYGt27BVt9vlp/ySlxzUbbSfr+xZUI=;
	b=eXpwTksIT9/Go1ofbOmdU0GZvbkw5AyX5pLHwi+2EKjRB6sOz9eGvgakUD8O5a7D5/19ut
	4nm4lk/n01AwoZscIQIgq0wHxQNi5kf0X7qhAhpzIZHgiY2Hw2yiLHg2d/EG4MV5CfmS46
	FvzsWCQrEs3nPP7g/iIOz1rWsSk8mo4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792086876;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UUX/20c9gzfr6HYGt27BVt9vlp/ySlxzUbbSfr+xZUI=;
	b=iTxD0LdA1j7nQ1dEwmMrePAU7KHf4w37NgNPespccr/3SWDTWNo2jSNk71iguUOzjHCTXZ
	2jnCQ36Nk+Cbh1Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 29F6413223;
	Thu, 15 Oct 2026 17:54:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id p1Q4L1kT0WqZYQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 15 Oct 2026 17:54:33 +0000
Date: Thu, 15 Oct 2026 18:54:32 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Adam Litke <agl@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@surriel.com>, 
	Peter Xu <peterx@redhat.com>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Josef Bacik <josef@toxicpanda.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 01/10] mm/vma: don't leak the commit charge on mmap
 failure
Message-ID: <atERwRzzAdCSXaPM@pedro-suse.lan>
References: <20261015-urgent_fixes-v1-0-42796911043b@kernel.org>
 <20261015-urgent_fixes-v1-1-42796911043b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015-urgent_fixes-v1-1-42796911043b@kernel.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 96DD68000B
X-Stat-Signature: fargg3t995bg68kpmzg99mhacg6azpdm
X-HE-Tag: 1792086877-43695
X-HE-Meta: U2FsdGVkX18nseB50+ZtyGhNX85w2m8loLoBwUoRkprt07fvo0dO7tU+xPltDbphKNNzR13vNeaNgYVlZjAALDMo2w5Pm+A8JBdlv7sO3SKFRVRuN9rUqJXmQ7TENdeWTwIch+2ugK+DKIuurEyf0pVWZp1cDw0jt3u2R6lxmpCFPrEm2q0+51ihl7qMTwkSOibJow2wT+6WztxMR+grrAjIAI58TbjSfnhFHhaAesL1tgqdkkrxPJFReysDr/bORZ4Rg1P12aSw/9GKrsv8yzjtb0IfFfS0s05QzSZmfNsqdiwfUJRx/WTVd9kOdDiKcn5YqVmTZYpYCEn844QTVo+cuq6DL3O2v1hvfjJ0PcHcmenUq6LIFkOCf74w6AG8I8LM9m2cTWOHFxJUKClvlzTaToPyrXEbnH4Pwy5qB3vxCKyT/R5CMgCIGjKqPKKxlU6KyOVmG57VtVecFddfUz64s1KqVeP/my7sPHe6GlLhhF3Mp5Vv7vsitMqcucFTgrbOaqUni+KKkKmtyT78IuSjkU9+l6jcKfk8bk6p0XsJjklB4hIxf291gPKMNPYcf2VIYjSvhHPm5O3cI/IuJi0FJKViVyZbUoINH8L3Wj0NA67FrTBhHmGare6YjSeBFbPNoH5UY6ymae9IXxEzRbB+D7X3IcmnH4Gsm7uTa36H0DiPKjzQa4lw3jspFiASKeY/qo339Aaif6V7yZpcZsNTjY4KXwJJIPn4plPhCWuBdZzPMnZEfCxl7Wbdv3ZIuZCbX7p9WzjBtnicIMI4fTZD2IUo3ayxCir3ZjXagt1OwiEs3b4LItEdoAw+ENkxSbJSIj1C2Oif557uh69tskBvPqN4SbEMaTWM0DzUJWyU8IIhCNBV86qmd024tsNr4h0xGYCzRoFzMioHELxwdGkrqbGEiz7PwWUtPsbcGMCXEQUivqC8u5BDC/CGdVr2xHLqN76sFQRePPZPBbZ
 2qC4xjuf
 F4xt0bL/5Lw/tRMw2gLsUXtV6xko3ES8m/gV3S1s7Y0x8N86AjccFlTVVzFCMqLOvHnX0diUtbiHP/8ZNVpOLzY0S934pi9p1amLZ3L65TLm1D0Z0m1i93v7dlMGrfCCNS0NVxiFK9VFfmk+cv8RHtbHCKWM4nUOr9qaKt0SeOfBPO2kC/omaGLrTVl98DsdByNnYal33a/avU+M2ilXi/U7aVazWZukPOv3vYeiwzCoIOzDOzJX0JBrNqUy3tyqhpWABTBBtBrFypre5fRVwC7jVD8xOFz0HtR/AZdMzKox2m+WdKCKjFh6dtXOFQ+7xdeSotttvQkXdptirGL/N7//0JZX7oyYGrNhsB+q+vOBpLeivjSaX2WsohfWryZJSMN9iABUvHAqJsnSI+yge0J2MhGVL4EYnrBfKh8jlF6utdtw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 06:07:07PM +0200, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> When an accountable mapping replaces existing mappings (MAP_FIXED),
> __mmap_setup() only charges the difference between the size of the new
> mapping and the VM_ACCOUNT pages it replaces. It then zeroes
> vms->nr_accounted so that unmapping the old VMAs does not return their
> charge, which now backs the new mapping.
> 
> If the operation fails after that point, the error path returns
> map->charged, i.e. only the difference. By then vms_clean_up_area() has
> zapped the page tables and closed the old VMAs, so
> vms_abort_munmap_vmas() cannot reattach them. It leaves a gap and
> finishes the unmap with vms_complete_munmap_vmas(), which uncharges
> vms->nr_accounted == 0 pages. The old VMAs are gone, the new one was
> never created, and the charge of the old ones is never returned, not
> even when the process exits.
> 
> No privilege is needed to hit this, only a file whose mmap hook fails,
> for example a socket (sock_no_mmap() returns -ENODEV):
> 
> 	p = mmap(NULL, len, PROT_READ | PROT_WRITE,
> 		 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> 	mmap(p, len, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_FIXED,
> 	     socket_fd, 0);
> 
> Every iteration adds len to Committed_AS for good. With
> vm.overcommit_memory=2 this lets any user make all further accountable
> allocations in the system fail with -ENOMEM.

I don't think is urgent nor does it have security implications. You can
already broadly screw up the system from any user when overcommit_memory=2.
This just goes around the single-process user_reserve_kbytes AFAICT.
Am I missing something?

Just looks like a good old bug to me.

> 
> Once the new mapping has taken over the charge of the mappings it
> replaces, it owns the charge for all of its pages. Record that in
> map->charged, so that the error path returns all of it.
> 
> A failure in __mmap_setup() itself is not affected: it happens before
> the charge is taken over and the old VMAs are reattached with their
> charge intact.
> 
> Original fix generated by an LLM and sent in private by Josef.
> 
> Fixes: 4f87153e82c4 ("mm: change failure of MAP_FIXED to restoring the gap on failure")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> [ david: call variable "uncharged" and make it const, adjust/simplify comments ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

