Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3FF2C5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 15:23:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A854E6B02A8; Thu, 13 Aug 2026 11:23:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A35E16B02A9; Thu, 13 Aug 2026 11:23:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 925906B02AB; Thu, 13 Aug 2026 11:23:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6ACF26B02A8
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:23:32 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7D074A1B42
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:23:30 +0000 (UTC)
X-FDA: 85096615380.18.F51D457
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id 60646A0003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:23:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=omROdkW8;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xWXTOLPv;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UpzBWAkT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=vhUsTNwU;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786634607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r9c0W7+Qi65NnGMLOX7a+AOvxMLs7RmJF4HQmM9BUTA=;
	b=PwRJ4oxsXrnAlK6wVIDCCH6GUB2cTzkCfi/+xzGNCud6/3UUfih1pp3FuO/SlQSNCSA51N
	lPz/5sXs0OLf0pjEkNSlSY0Diy0jL+qgq6tLD+RHmnPW2UNUO87B+H4MeuKcsb6sJbnJPC
	LTF/An09s7eK1PyL7rarF5elqVXqCHs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=omROdkW8;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xWXTOLPv;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UpzBWAkT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=vhUsTNwU;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786634607;
	b=cbZD2nkFmfEQNMKYUXPoI8NSkHZ1SaTFQoxyReXetUEOCYoNz6AQ8XWGy14EkmTbUxBguG
	CNXvYIljNZsJdeR/XkF7iMCnZGi+AM/Cga/CYATS/ByKvbAikQN4DgPU1sj/OpxGiy++wR
	P9hRZRpRHPfJY3CV0j7hbjK3RK4wFPE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 91C01829B6;
	Thu, 13 Aug 2026 15:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786634601; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r9c0W7+Qi65NnGMLOX7a+AOvxMLs7RmJF4HQmM9BUTA=;
	b=omROdkW8VWOd/OPZEdiY6fNZwnrNb7QI47DuWZtZp/dpYvPfv4tWH7HtljbpyUhiT8gECf
	8hD1RCEhCs8ZqYmL3UWDvjA5xKl6IYcOcgumdoFTkka17Y8neDwEWcI1hzEKzYegv/DqSx
	Bc9DwoleVqbAk0EIi+P3kpfLE9MeJds=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786634601;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r9c0W7+Qi65NnGMLOX7a+AOvxMLs7RmJF4HQmM9BUTA=;
	b=xWXTOLPvet21H9ghPgTyel1CNUXlll+R7v++s/fG7T/32gSSTfXaXoQW1sUuUuUOC/oXik
	wBo8SE/t3u0MNnDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786634597; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r9c0W7+Qi65NnGMLOX7a+AOvxMLs7RmJF4HQmM9BUTA=;
	b=UpzBWAkTSakchOv1HBSKgOzMO4KuuUnuQ2MWxcIRgI6gWJDI3MViSiGXChMJX9nfgbo5//
	HWZ5JEK/ZOZQaiMZlPo8BjieQ3HqtUFgSaq918OZNR8nRMFhq7MkMZzOogKw2E0274ndF6
	PoOmqltFaNvZvWY/eOuNjJK6sY2qUk8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786634597;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r9c0W7+Qi65NnGMLOX7a+AOvxMLs7RmJF4HQmM9BUTA=;
	b=vhUsTNwUNneYjNPb7CuW23z17Eitwo3XIY8V40j7NH8ES7XdjYKGnQ3K4sla8K5tfCe34j
	qoWZNuRO1J9dlbCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9006277EAD;
	Thu, 13 Aug 2026 15:23:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bbjcH2PhfWoOeAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 13 Aug 2026 15:23:15 +0000
Date: Thu, 13 Aug 2026 16:23:13 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Nikunj A. Dadhania" <nikunj@amd.com>, Mike Rapoport <rppt@kernel.org>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	David CARLIER <devnexen@gmail.com>, David Hildenbrand <david@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Jiri Slaby <jirislaby@kernel.org>, Juergen Gross <jgross@suse.com>, 
	Kevin Tian <kevin.tian@intel.com>, Kiryl Shutsemau <kas@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Steffen Dirkwinkel <lists@steffen.cc>, 
	Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
	Toshi Kani <toshi.kani@hpe.com>, Vishal Moola <vishal.moola@gmail.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org, 
	syzbot@syzkaller.appspotmail.com, x86@kernel.org
Subject: Re: [PATCH v2 0/5] x86/mm/pat: CPA fixes
Message-ID: <an3hHhEgV2K8bVEE@pedro-suse>
References: <20260813-cpa-fixes-v2-0-39b4ff90f91d@kernel.org>
 <9cfaa5d1-83b4-4b88-bf3a-05d2e074cadf@amd.com>
 <an3dkOKWdajK09KN@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an3dkOKWdajK09KN@lucifer>
X-Rspamd-Action: no action
X-Stat-Signature: sezc5q1hrqu1j36nrtwjamjpiis9fy18
X-Rspamd-Queue-Id: 60646A0003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786634607-698653
X-HE-Meta: U2FsdGVkX18sNU+dVNP6QJ0xGqVxb77n1dUeO/awY5JGU0Krh/t7B1347JrnVzQOBqNTxWTC174ptVCkDucATK4czdeVK6R2495NboX5fG7HfaPaITifMxTjGVOJ6bnOg4MhVATYakm7kZQk2//2huVHN2nHR5SJLXVgf4rFiBgKDrihDDZvp/yxwmhoRLV1AQpYRC12skxWF5X1oRPL0KFtTBsQX4/OLC1sxmSau7fkk9h/UZWGw4msWxvbdxmsSgVBuVzTdwvRgcP/mrM6vQDaELCYkEAZF9sQHYd5qSaOuuFeGCuz09lm/yk0I8943O26uMDbwS2qSp03Lbv4sXfUUce+V29tMfGdhIdeDMVqB03UE8nj5R7IQL/vu+Hq8rg8xw2u+JHXatlStDt7M5lvc6OGqcAhLwiaCzmrL4+pJmRCfumGZF1NFp8VpppP6bkrcYH6ERe0XkcFAk7i5WudF+BfXmxuCgXvdvHFeIfBEzbuBAKi5hI3SfuVjzZWpB3FSiDvEtZHr0VQa1bYpRLaXlv5K0OEJN0ycrk1Mey/yg909muhorBX4bvik81EJnmBB88NULzmFvzs7VOxtGBfxHwRtlxbxEBbmpJTMG7CYq4c4utRsIUw82KFlUOONvFJqfXO/i9nu0ICqb4WEopxHrfKYpuGdiTJ2edFz1Y8aHolP8U1+Gsvi8pyPur85o2/I8br/GyJI1t7Vofp8vZHYgrEjzV7y6LDaun3Pmt17twIr3R6eN+IbP6EgPKn97mIYQBGLqYniPHPyV2VqTGov5lxJLl0bkdoWNcVwROei7nd2OhRE0cN5R9rV4yR5I2WiUZKidVpU81QuAGebEac4R58CfoOaUc1q2Fk5LK3Et/U6qZquXjLdn4e+dKGDPbn/F+8kjFLmhVSMUbLHYcKpimwavpHfQeupy8vKwQYO0cmgg6ypHZtXo0eEfO/yALSCuHctJM9HZJoslq
 WA2B9Ena
 dYnw4BjTI5tbbvGSc3LLZFtJRVl1QEE+0lqoX+7RmjieBkn5aDu7R7UuBn9g/UQcJRHo3RK2wFy6WKPPE10KFd+XgYpbcApdAn20+iblvp1X4im8wcqmO/TzE8mWqLEdzQiBlDleVujYMEGPFV3F4aNgSp8EZswdewpfSoqsrAncXCymeOgYsQ7pAi/nISAAtryaqad2Bov1KloN5PMr10F6QvaPNFC4IbZZrV0RtmEER3GOIGlElPWULxBLO6aigejpugGvuXAEGIl4eMtfChoYaI56G5wdWTidPHCyX3zObLix9yVXhGBy0jTGEFwmiByPDGy2lvRtCz9M9/V5tHTYcvtNK9UKKrSavYKS8D+W2Su97Ji+4TGyC556l+fcyVPLtidN2KlK1m/VFk8EzLzkQC3CZuBZe4pqQWGeG/39ydXs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 04:07:38PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Thu, Aug 13, 2026 at 08:35:21PM +0530, Nikunj A. Dadhania wrote:
> >
> > Tested v2 on a 512-guest concurrent boot harness across 200 iterations
> > with no splats. Both crash signatures reported in [1] are no longer seen.
> >
> > Tested-by: Nikunj A Dadhania <nikunj@amd.com>

Nice!

> 
> Thanks so much for the testing!
> 
> And all credit to Pedro for reporting and contributing the key commit that
> resolves this issue :)

And all credit to you for starting this flurry of fixes and patches that
solve Critical Kernel Issues(tm)! My fix would be nothing without yours!

-- 
Pedro

