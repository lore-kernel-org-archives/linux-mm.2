Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54423D58E48
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 16:46:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8719D6B0005; Mon,  2 Mar 2026 11:46:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81E466B0088; Mon,  2 Mar 2026 11:46:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72A596B0089; Mon,  2 Mar 2026 11:46:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5EE8B6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:46:06 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 08491139983
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:46:05 +0000 (UTC)
X-FDA: 84501700332.20.88FDB84
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id 62E1D80015
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:46:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=owS2QK6j;
	spf=none (imf30.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772469964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Vg7gqMeiyzPknt3qyMKgO+85Gcdawf8YPVMOwCXhuA=;
	b=YcCx03HfWTh+WSZaSWqRK1n84pkc4IObIG3E7A3OpTv0gXVDhOU/auPNMQwxRJhVXuhisD
	CuB7tlmUIzqbDIeZDTlW3uza68pZv20wmqgIVL43oRWsJV9Jjg1nXOWWkhb2L0vyVuA24v
	OmBSEnQ6NSkmSZoPJU2bac/QGVKD4IQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=owS2QK6j;
	spf=none (imf30.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772469964; a=rsa-sha256;
	cv=none;
	b=3i5H3WpnxYRyBq2AHr75oBuuWg9GsLTwlS/4YFLyieKKYKzaOH7nk7EpiLotTGWp2Qvm5C
	aA1ZLdtj5E7rJ7nAwqXe3pXLYfNgZMYwepo6mjw5JzXt9BghM5BPoXEMM16c9Gpf66c2tO
	aXTDtZIWpZcc5+9GyOxCcnO+r1iBz/k=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8Vg7gqMeiyzPknt3qyMKgO+85Gcdawf8YPVMOwCXhuA=; b=owS2QK6jKnt+GVdLtj0zS8Wvnv
	omE+YRDnz15+BbCFScMK0nqhIE+g2d1g9cWeoRay+sPdP9qOR67XZZ1Hop8ALT8uO1s65oRagWMn7
	lzM58aSkEa9MJwJf4RWxmXXbN+r17MR/kwfI4iE1z7i3nMP8Y322XYS90pMvSu2lHiW2rSQzNulb5
	mPoNFIW2Tm0GTGn4inHkp5LiBPSQCt9Tgd0wv8Vqpp+TMEmesZYqJ0D/ZYz/5KIwR0IlwiQG48LPn
	IDG7qFF/nIVP5yO/j+/qmADSO53CG+iTe/CdnxFa1UKEnuYum7FRAsPRpjHitiNuFMWbjxGK9E4pC
	vNDIxDjw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vx6P9-00000009mbi-1QvE;
	Mon, 02 Mar 2026 16:45:59 +0000
Date: Mon, 2 Mar 2026 16:45:59 +0000
From: Matthew Wilcox <willy@infradead.org>
To: WANG Rui <r@hev.cc>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Kees Cook <kees@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] binfmt_elf: Align eligible read-only PT_LOAD
 segments to PMD_SIZE for THP
Message-ID: <aaW-x-HVQpSuPRA1@casper.infradead.org>
References: <20260302155046.286650-1-r@hev.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302155046.286650-1-r@hev.cc>
X-Rspamd-Queue-Id: 62E1D80015
X-Stat-Signature: 7fayee5apakem6cx3qiyremzspehs6b7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772469963-828789
X-HE-Meta: U2FsdGVkX1+EM7G18WwlXs1VNnIMRK5+Km/zu43OribWd/ER9zVvFIJlF3iQDugPXqWBlOD95fiUtDQggLTqMUfUjWyrxfINHOV7YrHyzA6HHPBQVok/E2mlIG6pPlVhoQRViB8LAdNYtJhLVjMHpifroj1B+6UOjXYFVlFUYDmJ/MS7+I2wh5dk7OQ1lzIIx3CiSYWUgapuMblz5Y66fMawTYaqRBgDjHYJQzdLW+y9YWoUsPFZ7DGNCs26hPW6HcSZMN+mHY3QgzFe2wxHmv21CFrA86B+9oTIqK30bw/SbIIrz1TY7hALK4+3EMquD3kCeIKalWQc084JJtrLxt7wsI3lxRJoPk8gnD60JEBx7SrbgvSeCdY1u7/jWjeQmOfNtEwkbd2KvlBx8TrGUaOetsQf+lLjhsC4JkvagsyF5tFsscxatc3eIbjfjodEkgUCbC+bBbnadEcdpYlljGTYzFSR2cXKSuCF+QvGDHkKmWB8ewd6Zhtwu0iIFh7ayck7b7sPW/rlkLwl317J8TXq1g/p04jpI0iqu/7y3kWh4FUniEOtMAvHwVU++QZlPUB3zGt+8vUZSYp3vnvK+Cv41B6Zmj1LBKLFa9bb6uHy8epuOFUE5p103JBiHJpEPb6GSdq2pBDC/gVtKV/Zh8zy4Vo1z0EuitPWv3Qf4K29fvXsHZpoZ8Mm7S4bTTsiwx15XzUDNhTRvcxxGIvcNDCoS9Bogr+4SkcbyS9BzP8tFbuUQda1KuhcOH887dCrhxRfmKHF9sB5dsd1YE/x48174+X9WaNR+m2+4BLGVZlynFieI7lA5WsTDdwkTVs3cr2+iQEDxAw0nUqpE+R2p//36PF/mGP4xKf2Se/wQqL+WAicAS61u1wWpZT4e51gi/FL71bTY1EO7ljqZjR9KLzGL0EuknvbmfEwnzyS4UKHkvPSvssSQeBZO5bv4NzauzQ1bva10baxdogmtXA
 uME8O6M3
 Q6kvi0YHR4pKeDf1LP0s/iuGlQANZKIP4DRrfQt8ol7KXQ1pbQ0/fmlSpvLAlaIQWwxetBQem6rRjXdadcUWHNpq1pAhlCk4eTUb3R9gd2JBvgzpPze2xstH1r7TpiqAGoJDY8BS1A6BKM8wW3Qt5Vzrf29l86xD9sshg95sgM6JI8miJuVcFEr1BqI9EkOzw3zht1pbIZo3nHeOxkrW2ssU0CqqvkWf62PS8qzjsqJ38Ft4xesFHfSg5CsDsWsKVcxWDuSbRfBk51dOnzvCuZft43Q6d38X7O6/9SIvHIMtRIqE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 11:50:46PM +0800, WANG Rui wrote:
> +config ELF_RO_LOAD_THP_ALIGNMENT
> +	bool "Align read-only ELF load segments for THP (EXPERIMENTAL)"
> +	depends on READ_ONLY_THP_FOR_FS

This doesn't deserve a config option.

> +#if defined(CONFIG_ELF_RO_LOAD_THP_ALIGNMENT) && PMD_SIZE <= SZ_32M

Why 32MB?  This is weird and not justified anywhere.

> +			if (hugepage_global_always() && !(cmds[i].p_flags & PF_W)
> +				&& IS_ALIGNED(cmds[i].p_vaddr | cmds[i].p_offset, PMD_SIZE)
> +				&& cmds[i].p_filesz >= PMD_SIZE && p_align < PMD_SIZE)
> +				p_align = PMD_SIZE;

Normal style is to put the '&&' at the end of the line:

			if (!(cmds[i].p_flags & PF_W) &&
			    IS_ALIGNED(cmds[i].p_vaddr | cmds[i].p_offset, PMD_SIZE) &&
			    cmds[i].p_filesz >= PMD_SIZE && p_align < PMD_SIZE))
				p_align = PMD_SIZE;

But this conditional is too complex to be at this level of indentation.
Factor it out into a helper:

			if (align_to_pmd(cmds) && p_align < PMD_SIZE)
				p_align = PMD_SIZE;


