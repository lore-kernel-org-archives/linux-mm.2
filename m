Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36E66CAC5A8
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 14:14:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 902DB8E0008; Mon, 22 Sep 2025 10:14:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DA5A8E0001; Mon, 22 Sep 2025 10:14:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F05B8E0008; Mon, 22 Sep 2025 10:14:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6DEF98E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:14:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3C7E413A1C7
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 14:14:05 +0000 (UTC)
X-FDA: 83917080450.29.B9BC3AD
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id E4A081C0009
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 14:14:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="1Y/8OmdF";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Yv+buhMB;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="1Y/8OmdF";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Yv+buhMB;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758550443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nqze0B+Wfhv4khPHkPPqKTRdC9H6pPOcQqJgG67yCPs=;
	b=t9AuMnhkxsMgN3ytMOtfyyNp3rKzzVVjkku/uaVPpyVDB3nTuyIcseMSajRyIU4rlt0ANE
	/LFP6fE1KGc9M6YAeXkXk2npPoHTQZEZAC5xBuxbRnhhbKm8iIfgaPl1ovbVFax+1uFYXu
	utwzP1im+WhqgSMUTMehi2mu3sBzjxo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758550443; a=rsa-sha256;
	cv=none;
	b=wjLGAvlBcy4tgPheKZTlpeALwsGUb1rmobOebJ+Xuh34JDTbirOxhDEcpbynvwhKfTQRxc
	Z5Z9pEZk63EGz3VnXKbMFeskw64bP9iuV7bfRsOlyMzGjtlOk+J6B2WWg/DTkKL9eFWcqa
	sM5RciZIQPqwdHashUdo4OJ4qnb+xdA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="1Y/8OmdF";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Yv+buhMB;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="1Y/8OmdF";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Yv+buhMB;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3932333693;
	Mon, 22 Sep 2025 14:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758550441; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nqze0B+Wfhv4khPHkPPqKTRdC9H6pPOcQqJgG67yCPs=;
	b=1Y/8OmdFV9o10Zv3dUTSbAACmzVx3AUH6zIFA7zvBm6SxobixO2EAsdAcISnFeyyOz3ffS
	W4Z7jWhTQCmUtcM3myfJ+n5bjLukoMfCJO2vvYNG/8AhG+KtkfLD4Yvh633EEdl5fVQC1V
	98fLMhwtSNwP9WZFJsu1EMnRgTXjnIs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758550441;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nqze0B+Wfhv4khPHkPPqKTRdC9H6pPOcQqJgG67yCPs=;
	b=Yv+buhMBsc96onlwWVevmMcaySXurmRXG2h3faLdSwitoBZiIb003bnV4SrWs2Ab79woMN
	uTsAjef4iXsd7dDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758550441; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nqze0B+Wfhv4khPHkPPqKTRdC9H6pPOcQqJgG67yCPs=;
	b=1Y/8OmdFV9o10Zv3dUTSbAACmzVx3AUH6zIFA7zvBm6SxobixO2EAsdAcISnFeyyOz3ffS
	W4Z7jWhTQCmUtcM3myfJ+n5bjLukoMfCJO2vvYNG/8AhG+KtkfLD4Yvh633EEdl5fVQC1V
	98fLMhwtSNwP9WZFJsu1EMnRgTXjnIs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758550441;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nqze0B+Wfhv4khPHkPPqKTRdC9H6pPOcQqJgG67yCPs=;
	b=Yv+buhMBsc96onlwWVevmMcaySXurmRXG2h3faLdSwitoBZiIb003bnV4SrWs2Ab79woMN
	uTsAjef4iXsd7dDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D861813A63;
	Mon, 22 Sep 2025 14:13:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id C4YsOKJZ0Wg3CwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 22 Sep 2025 14:13:54 +0000
Date: Mon, 22 Sep 2025 15:13:45 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: David Hildenbrand <david@redhat.com>
Cc: "wuyifeng (C)" <wuyifeng10@huawei.com>, akpm@linux-foundation.org, 
	linux-mm@kvack.org
Subject: Re: [RFC] mm: MAP_POPULATE on writable anonymous mappings marks pte
 dirty is necessarily?
Message-ID: <o5f47zn6wamjfuda67acm27aonhtmm2gbbwztgqvskkzjjn2d7@s4etlkckypuy>
References: <17ad24e5-9ee0-4d94-be5f-3c28bd57460a@huawei.com>
 <oypwdcx6j726iffszfayd66xizaw5tfv2lnkk7bx7ibzn37x3m@ulkgb6x6geef>
 <adab9c31-c281-4bf7-93ae-89ed9f303d7b@redhat.com>
 <hgbxlsaxe3p6npj3tyrd6u64qel6monttjaadzcnzpcpgi7arp@ztzuvbq55vuz>
 <8e8b4aa4-18b7-4928-a9f0-cd47a59258fc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e8b4aa4-18b7-4928-a9f0-cd47a59258fc@redhat.com>
X-Rspamd-Action: no action
X-Stat-Signature: mjeeto9a8xow1ja6e794ea8eqxu5jt1q
X-Rspamd-Queue-Id: E4A081C0009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758550442-968158
X-HE-Meta: U2FsdGVkX1/PujLcoqqGdp9tY/GRwGsvWx9hQyJ5CkTjnoQeLbDDPbj4B3qC1fjAMjhqTq5zyZ5GWUy3k7U9yznNBZD4uQYj5oo2zgz+kXH+DUdEJ3s4NkNC2JdE2nl25v62HRJq9gUJseKz5BSWQ0ZpqTz8qD87Z2rzP2hlK1Zf4K26MR1Nn11pCWikZfZQOQGtBS1/HMKytidOFrPanPtFDyYvBzmXpFQO0w0+ffmYiqBkzTVcexkWtJOl5hZN4HpdcdD7315bWwEMbYFHcf/5JwjFtHi+etWGiM+AaBtSrPghhatL/60C1lmV9MhfFXoU+inesJYUWHXZCMK2IZNUAJNa1eGImMM4vUNavTbrF+CZU87v4+vDsTB4RpPPztspCywsYFD6jPhhQv35nxbouf9WL2sXgycmM9K2KcEbk6qQaa+z4Ma2hNcHRVep/kuXTpU3x9Jv58W4IpLIKDbP9EOCqCUkVMvlJaInmPH0e6Seh3JPDcxqcEW0308SuBbeTRpn4KKzUYqPool+NSqlwDZMWam/DbrX3lJ9atNWun2DsOglycrTI74Reuw6mUTmLRYmJGd6Akb4hlSJJhs8FZyfOlt4b0BQ2Go2Cw5sb19B9TFEpxCz7fVqEdFOdV0gxnUlJAI2Y5bHHG5SHxm5GpqXCXmCI0rr5Tq3XsJfXOIQ53em+AqiYVMIVHhmJt1QuAr2i9+YtMYNk4VmxVfEm0x2HembN4D7GI1o00tXh0oVroHrSkpGmABedMABvpG4lQWV3iAJoRKoxXrhgxYi3y3zdZ0DrMnohcMuHOSXfKgKjPpsTlVvHhRqherc2SCMiG6Zd5p6tgQCgxR4NZARHeVIkrYYeAl9aEVVDaB8M32QspEueJVkNPMzTW8+HMoUuunE8uwX+IOPZztqlwPK+q2bQWFBroRoMtsguVOzCuLuhj6+Mokvwl88EAMv67jvu+yRQOIrhrUI66G
 ALqnwUNm
 38Gz2a2nIx0cYvwFL72yndlL1Oq772+MSX4ndcYGJcgDr6nwFu/LXFHlaT7FbIVg2yxNBcUzLA8lgqb6DdC3WtSc4cTyDtVfhIY56jneVq4p5eH0/FBB0KNUQ4gHelmRAP2Y22yBxQWJsiNSYXGqe0JTqzJpn4rvrV9P/GRFclrc3MWqn32vbrC1n52euKfH0ta2i2vVYUNDmVcKVTOXUcbpu7B8pdF0BxOxfDAXrcpzp0AZ2hPQ1OW48a1E9H0Tf+85On7ysTNGSZocuCo7uMgXA2FOtTq7zHHWuNPWshBIHF+8P1kfBgEcs37RVChTM7KhFPnAW5D3U6wBnalH+EoZ+nzhvSb8Vb9ykS3gvQORZpswxAmBxbUBiki7TryHNopk0dfaoSu8RaIE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 22, 2025 at 02:46:44PM +0200, David Hildenbrand wrote:
> On 22.09.25 11:37, Pedro Falcato wrote:
snip
> > 
> > > What happens on architectures where the HW doesn't support setting the dirty
> > > bit is that performing a pte_mkwrite() checks whether the pte is dirty. If
> > > it's not dirty the HW write bit will not be set and instead the next
> > > pte_mkdirty() will set the actual HW write bit.
> > > 
> > > See pte_mkwrite() handling in arch/sparc/include/asm/pgtable_64.h or
> > > arch/s390/include/asm/pgtable.h
> > > 
> > > Of course, setting the dirty bit either way on later access comes with a
> > > price.
> > 
> > Ah, yes, the details were a little fuzzy in my head, thanks.
> > I'm trying to swap in (ha!) the details again. We still proactively mark anon
> > folios dirty anyway for $reasons, so optimizing it might be difficult? Not sure
> > if it is _worth_ optimizing for anyway.
> 
> I remembered the same thing (proactively mark anon folios dirty) but I
> didn't easily spot it in the code. Did you spot it?
> 
> I only found the folio_mark_dirty() calls when unmapping anon pages and we
> stumble over a dirty pte.
> 

In shrink_folio_list():
		if (folio_test_anon(folio) && folio_test_swapbacked(folio)) {
			if (!folio_test_swapcache(folio)) {
			/* ... */
				/*
				 * Normally the folio will be dirtied in unmap because its
				 * pte should be dirty. A special case is MADV_FREE page. The
				 * page's pte could have dirty bit cleared but the folio's
				 * SwapBacked flag is still set because clearing the dirty bit
				 * and SwapBacked flag has no lock protected. For such folio,
				 * unmap will not set dirty bit for it, so folio reclaim will
				 * not write the folio out. This can cause data corruption when
				 * the folio is swapped in later. Always setting the dirty flag
				 * for the folio solves the problem.
				*/
				folio_mark_dirty(folio);
			}
		}

So we assume the folio is dirty due to races with MADV_FREE. Seems like a
somewhat heavy handed solution, but I guess it works nicely for 99.9% of cases.

-- 
Pedro

