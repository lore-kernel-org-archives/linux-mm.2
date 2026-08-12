Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A468C5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 11:02:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C6366B0144; Wed, 12 Aug 2026 07:02:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04F676B0145; Wed, 12 Aug 2026 07:02:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7FDE6B0146; Wed, 12 Aug 2026 07:02:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C71766B0144
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:02:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5CAAFA25D9
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:02:27 +0000 (UTC)
X-FDA: 85092328734.24.9C48A88
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf07.hostedemail.com (Postfix) with ESMTP id 47E5E4000D
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:02:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=H1JzWXKL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="poLI3x/t";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fV6me2Yo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CyVqWLWZ;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786532545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HXMJf/rtkN5D9V2wByXeXTPbkMFZmsjZxH0GM1aTCuw=;
	b=N379rUJFVucArfOWHUxquuiZzEeEQAXGVgXfvDgpia45WOuf+alisx44C3tpAWLT+8cyo2
	G2mpCa3+Qp0yR7zp6M11XZ0eLxj7g3RzAQHTFpcqDfh+Sxzb6Z3081ApIeKPk8mlk6Qi82
	lwsQ/mzRY2D/BFKi032qtwZY/8HZFzs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=H1JzWXKL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="poLI3x/t";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fV6me2Yo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CyVqWLWZ;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786532545;
	b=Xt/h36fp6UOzQdgBZfTdpAv9wFFl2N9D+ut+dqTOonil2JMHw2kbpAp9UcSmIo+cW5xZ8s
	Fv4Nx3HxrUGrVU3u6BRl5SO2kcQjMc9CbfgBW+pBzjOBnXQzU07PqGgDoa2KnwdFFItY00
	gWlYck7DD8DJgp8GD2QUfuKvpeGUZNo=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F06518222B;
	Wed, 12 Aug 2026 11:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786532540; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HXMJf/rtkN5D9V2wByXeXTPbkMFZmsjZxH0GM1aTCuw=;
	b=H1JzWXKL/ONpTLM08OtA0Vz7IVhqGSFS0bMs+kCcnoIWV5QrFmsVZnWZvgfEgOwiNfZeAs
	hT4qYuPHDo+KAp/wkscibRimguZYXup9roYuWUgaeAK838YFHpiyM5oK34GsqAxQVnbgpy
	9llJlnH70Fsl8eR0VP6ch5q8dQFMjfg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786532540;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HXMJf/rtkN5D9V2wByXeXTPbkMFZmsjZxH0GM1aTCuw=;
	b=poLI3x/t9XFPw2AKM8C7XATPchZBXv521jGBjNoeIEGya4U4LD3hL8+f0cGsJ9TuHQ+yDc
	/IImpbWPzRG6O7DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786532535; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HXMJf/rtkN5D9V2wByXeXTPbkMFZmsjZxH0GM1aTCuw=;
	b=fV6me2YoS46y0WhL8LHI/+xY0QanZ1MgQqj0V59lONnpH497IJubkCf3lAmQCZDqzHV/I4
	XCB19yfstm98RAhXKv4DDbGzsuuM80o0AmaQkVu5w3egb3Sih9VKnHR+9qSxLQRiDnjbS9
	tPn9CmFPCsarTf4c7V/iv2nVsGd3GuE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786532535;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HXMJf/rtkN5D9V2wByXeXTPbkMFZmsjZxH0GM1aTCuw=;
	b=CyVqWLWZDYn4xeqYqs3uOYbuvtbBROnZ5VTkM6ZE0hFPB+JBCVSYv7j6WEpBcdVrWq/Iox
	xzLbY7n9NUCSKjAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5AD1A779B1;
	Wed, 12 Aug 2026 11:02:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QYzoErZSfGp1VQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 12 Aug 2026 11:02:14 +0000
Date: Wed, 12 Aug 2026 12:02:12 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Breno Leitao <leitao@debian.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry@kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 2/3] mm, swap: distinguish a malformed swap entry from a
 dying device
Message-ID: <anxSXZ65lveAuGib@pedro-suse>
References: <20260810-swap-v1-0-375ef0767206@debian.org>
 <20260810-swap-v1-2-375ef0767206@debian.org>
 <da69545e-4b80-4cd0-8d70-a73023445e9f@kernel.org>
 <anxOqNmL24Cj9A7K@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anxOqNmL24Cj9A7K@gmail.com>
X-Rspamd-Action: no action
X-Stat-Signature: z15bozb9wh4cwyyirw6xer1h57yc93qs
X-Rspamd-Queue-Id: 47E5E4000D
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786532545-289020
X-HE-Meta: U2FsdGVkX18GilvJEzlRe6AaADVZC8OhQoKG4EgL52rdjIRtiKyaGxph0CTfW5HGY6LHpyK1EgAZ2177898ZHAuxjFKbT3a0ifVkrdqbmr2IsbVTdC4gXswDcDls/NFe+xcahBC1tJ11CO/nkQSRprlp47Vzfs98tp0ySFRbb4Dwmko0a8bg0tbY7jVx6GkJeDk8iotVwA4BczE8B3Nzu/hBaaV5mwAXZNsA653WokqNL7RDY7mgchudKUtfN6BeIjBdxU7qtAaLLBq7MwUTBxmxCDKNXq8ILNLyjmIy9qdxJOYKuiWnzFTAehJdJH7wOZ7GumCP6zqCHOIzS3oXqv2MQG7UYenVODuJIgP8RDqSAJIrW/KnkGkxy1ZkGwa12SnguJlo4zHZXroIexb3LtKtXNpyDns1ext71zozN0+t2A3B3aygNJgvj4TkOzwX2aNpzOrf2WWGusmlX83CIvNJLYYhOqIgSI1qddCNDIXMWO9UhxaTck3LWYAIGo4ODiOxE37w8lXgwBzXXdLfDFyRk8qHSm5/OvnwGoMK7huQAIVI4TjMN5CmcTegN1MBpZ7JtXvg1BPRdzJIRAyb7cLbnl5WoaPuRUAVqbiD8tWBcEwp4hBiddmg8FjugOSJSXO3M7M6vqMnQg1MWaoX+j2uagtxVS65Z5QQFQ6kUH7kpJMyEdyqWwjW5x8wriheiUfyHxXreGCWzSS4Kui/7xmt6AsvVxc4BSaaDErxoHNYCr2pHSgkB8hcFxa4aMEVgLS9/sixd0UBXKEO0zMvSqWqak8rSCE4t2oAo+8fpxGSxxYUwP1sVHsJaPCuppbQY6YZgczYYlldCeUH4NGcUtjhbh1Ib47Q9e7JmuJWpIPVZeMlDde7RSscQXJaSeoMyDoneXGqQghss6J1RnchGFsX376SqQlA9yPtfk7/GBN+jhdxn6fCo9O7SRkHnDcx+z0ogyKNOmCJG1Nf3Mh
 Am6h/RS+
 U6FjG8uIEauldPOtlRit9clqfCsFd6fllp1HjLLUdHqMF9iHCbMBeeKzBxoBx8sQ1r8O/3q8mPq68NhAIQDlWa8xggt9I/V3CwLIVlNe/VfXfLpRE+haHSZtb5i3PQxOZ5I82oCFGL3HSiftiWLHuW/vx4uDUQvZG4MD28aHFwAxz4h7vTt1rvj0aEuUqwEIN4A8d9Lo080iKxwrkG7EmB+ySWVThSkOEOhSivb/rMlVEi8Cx4Sn7/Lp18xf0FY9boTOU0WjWE5y+cWtQ5TUwG5K64rroaKj+gxDJ4rxv/pP2qfA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 03:48:56AM -0700, Breno Leitao wrote:
> Hello David,
> 
> On Tue, Aug 11, 2026 at 05:36:31PM +0200, David Hildenbrand (Arm) wrote:
> > On 8/10/26 18:26, Breno Leitao wrote:
> > > +	return ERR_PTR(-EINVAL);
> > >  }
> >
> > Is -EINVAL really the logical right return value? Running into bad swap entries
> > sounds more serious to me than "-EINVAL" :)
> 
> Good point, maybe we need a strong drug here, what about -EIO?
> 
> I picked -EINVAL because it is what the swap code already returns for
> this exact condition. 
> 
> 
> 	* Returns -EINVAL if the swap entry is invalid, which might
> 	* occur if a page table entry has got corrupted.
> 	*/
> 	int swap_dup_entry_direct(swp_entry_t entry)
> 	{
> 		si = swap_entry_to_info(entry);
> 		if (WARN_ON_ONCE(!si)) {
> 			pr_err("%s%08lx\n", Bad_file, entry.val);
> 			return -EINVAL;
> 
> But, I do agree -EINVAL is too soft given the situation we are in.
> 
> I will return -EIO in the next version, if I don't hear any concern.

Perhaps -EUCLEAN would be a more fitting error. It's generally what
filesystems use, at least (EFSCORRUPTED = EUCLEAN). 

-- 
Pedro

