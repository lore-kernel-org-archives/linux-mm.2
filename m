Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFCAFC98311
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 08:57:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF5D56B0093; Thu, 24 Sep 2026 04:57:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA6516B0095; Thu, 24 Sep 2026 04:57:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C952A6B0099; Thu, 24 Sep 2026 04:57:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A7F2F6B0093
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:57:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1AF2E16029A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:57:18 +0000 (UTC)
X-FDA: 85248051756.13.DA4BD3C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1771F80003
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:57:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HlhClT23;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZKYLHW+p;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FETLO7NL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JlLUxnWv;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790240236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uwqlBSJIrX1buXrXAy/VoI2OzAsvIjnMs2/fkp1HnME=;
	b=QvtMdr/13+CST2k/fZKgZfwukjjdJoiKcHR8h8mFuIj+B1UnNrb3whU1XGcPBa37KHCpGV
	wNC1smGIStmieNm8VW2xVIRQ31TfQsAlSuy9GWt94Ayp4o2wV39maDlwqxMX96qoTDwDgs
	jlIkbWFSqbgpk7St2UY6Sf/nLosh2SQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HlhClT23;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZKYLHW+p;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FETLO7NL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JlLUxnWv;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790240236;
	b=K7drX/7K/IkIwCybbJhK2WBXY+SfVq8q7OPvfsW9ccbS7zRpGvtVRmFsRwyNzEqMmr3xEk
	/5pUS0vBFfDrs4EN76vF5nwAFQeS1ahpZhBXpgdH0gMJ+DhVCWz1tw8Xlyt2SIER4Mm5B3
	tQ4QpgqA8tr6olouxvQSpgiW1kAh+WI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7B81321D08;
	Thu, 24 Sep 2026 08:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790240230; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uwqlBSJIrX1buXrXAy/VoI2OzAsvIjnMs2/fkp1HnME=;
	b=HlhClT23ZavCRLFWj7jjtBgc+z2Wech+ksQ6hAJbVkeL0wqY+uva/SFPT+smyDZCJD2psW
	c2ZFKU35XamxM5niO5Q9Yoe5b7pNgM//76UwRM6uPC/el2ErIK6p8F/4S+wkVVyog46ZgE
	btYdw+bY4K5zgSq94TnyUm2GIl3jJCM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790240230;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uwqlBSJIrX1buXrXAy/VoI2OzAsvIjnMs2/fkp1HnME=;
	b=ZKYLHW+pOWPcCToahvJKPP9/ilvcCQGt5OAALUW+4meVPHxFaTBYQSb9EG/jTNROw5u6yR
	40qDbnr6nUWExSAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790240226; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uwqlBSJIrX1buXrXAy/VoI2OzAsvIjnMs2/fkp1HnME=;
	b=FETLO7NL1G4FjFORzNv086gVvuv7CBmUbS2OWQkV/dZOmULSdSwZKybGRi1Lwp5VsEFk+B
	8pnkFrxXpgVAUsGo+zc260rMIAFJ9l+9wDsFNtSyoHWiI/1csE3YMSDmtm9LiwJj0fxZPh
	IzzPjHF8OXciPKoe1JDQHVQQOIUka5M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790240226;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uwqlBSJIrX1buXrXAy/VoI2OzAsvIjnMs2/fkp1HnME=;
	b=JlLUxnWvL3KuPPZ854fEJamunTZ0e96FZoibRt6kQgOVZZxLbiRpczvSG31E3EoZzNk72o
	jBBFFYzITJ3YDFCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 87B4313668;
	Thu, 24 Sep 2026 08:57:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cC7UE+HltGo7eQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 24 Sep 2026 08:57:05 +0000
Date: Thu, 24 Sep 2026 09:57:03 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/vma: predicate setting mmap_prepare VMA fields on new
 vma alloc
Message-ID: <arTlHBgXSP64U7ky@pedro-suse.tail5790ac.ts.net>
References: <20260923-fix-mmap-prepare-overwrite-v1-1-3b3f1bfcdf5e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923-fix-mmap-prepare-overwrite-v1-1-3b3f1bfcdf5e@kernel.org>
X-Rspamd-Action: no action
X-Stat-Signature: brs7ycgfdn1hprowmc876zx4nqxdte9t
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1771F80003
X-HE-Tag: 1790240235-364672
X-HE-Meta: U2FsdGVkX1+Salb/9LoM3R+XYiH1CNsknRpCnPubONgD/7lrjHz6Sf55j/2BnukCiAflzWLqWKUyWCNQs8KNCUOqlkJQ/L8VIXC97n2Ykz9JBBHV04HcxjDOGiCaTJmtgcmbKdlJVOHFGAxvyA47xNcUDv69kC/PwI4MuSzWf4W8P++3XNUQCuzkRytwUpTTgHptdHpea4hSZyMRxlOh8C3RYpB4mY9wNqSytQn20AN+wdALbAe+feLP+uah4Ozd+bBv1KlnCQIBcsVyK93qHjU2ESK3r+IObyutDwgtDKUXLcRz4FhAmqPcLt29sLbH0Q6JAbyRip8S6B1nwJnyFfntlp52QaGa42xymmZ08epBVyh/zgh+mc9nmohPpEoPWBEBZz7CmLvkMTlbCr5I2CytDfECbUKrV9Pw/MPu6IxLylVjIjqkdOpsVNzi7KthE07q9By6NFZQAsQQo8Jwm1Xg//vhG6XysPhRWb8xwkxEaTXs+R7CH3V/+zxJFUYBq1b12M0jOEbkr8OtHVle42/cVrF7hav20TlJM9rm2BSo8O5uaYNDo88hoRUPM9U3hkdTMBCI8GIqirurShETRUurEa6Xdj6Ibz47Vo4TEFBuYbD79qJr+cV+8IYaI1pEkPspDYu45mR0yUwOU/cOxINp1BxQBwNplMU19DlCnZ9A6+QIM5X+7eCAPJUDEm+dnBmOInfytyJcDli9byFLsCBFniySlQ3x0tj0LvISoyAXPGw6pV4LIXWaWbSZ+KCrrPmP2Q62TaijAOx4tJnwbRmHjZzoXXRZFQtCwshQFpdLZHwlRsbZgpN6aMQj3s6enCYj3jOvF6zuWvCmNyepBZ+GPz0DN4aEWbwuh6+HHOIgYPs5QkdRm/33BXqzZh9uc9wEgDjLtc2Tckc8jnQb//wdlGzjzdJY5oB7q5LEQofLGabZEFRbTNSYkSxUQVvtAcOxFQFqpleQUHx8Rpw
 FRnIfNA9
 61m9K9jif8fhPuQX2onoBy3iuS17Z2B5yKZyxFKMQKk5SVib1epPU/XuvwLkrw6/MwyIUeFrvV9oV9ZaQWA2sqjgMmW7UyZTb6Y0jxIJqaiVcPRRhNC/IvFWC/FCDFLNGImpgem2X01jbvfs8/CMOQ6MO3B4k+qy0ft3tXcNz1pWNHhkV8HTEz4c3hxR9WkkVTTjstTVrwWAuOGaZJ65scvdPS7+maagVS9wZydXztwvtb/vp7mEuHVBSlGDhK++gfuD7lIy+gDlykj2hksSJtHhFxbkcflr+WwfrV/gWHbC7MH/OmmOjkFZocw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 06:45:41PM +0100, Lorenzo Stoakes (ARM) wrote:
> It only makes sense to manipulate VMA fields if a new VMA was allocated,
> rather than merged.
> 
> VMA merging does not compare vm_ops or vm_private_data, so a merged VMA
> keeps its own, which is also what the legacy f_op->mmap path does since it
> never touches an existing VMA.
> 
> Currently, these fields will get overwritten by whatever state is
> established in the mmap_prepare hook, and if the VMA was merged,
> vm_ops->mapped will not have been called, so this could destructively clear
> existing state without replacing it with anything valid.
> 
> There is an implicit requirement that vm_private_data and vm_ops are
> fungible across VMAs which means that losing the 'new' state is
> fine.

Hmm, can you explain how this is safe? I was wondering if _any_ kind of
mismatch should be a WARN_ON (sounds like something odd is happening if
they don't match). But if the new state is practically discardable, that
doesn't make sense.

-- 
Pedro

