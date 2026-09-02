Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11A56C624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 12:26:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04B356B00D8; Wed,  2 Sep 2026 08:26:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3DEF6B00DA; Wed,  2 Sep 2026 08:26:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E54FB6B00DC; Wed,  2 Sep 2026 08:26:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C10026B00D8
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:26:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5B23F1C0A68
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:26:11 +0000 (UTC)
X-FDA: 85168744542.19.817D8CE
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2931A8000F
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:26:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=x1Q6Tggc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3durs7Te;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=15LelkYh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qXLs1ktp;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788351969;
	b=KPl3naRgY5BqpKDwFR5j91HOov1y93emstbOr0yRuo2k5369MibwUATph6lC40uAMTTe/V
	95kY1uSCDlSGjFhEUqU0CmQBwPSEyT5/VJ+lrQz1Vk0zEfpU+emYR7YV+FbLafj3dAqFDK
	YRZFXewmNxmaj0TQnkZCKviDH6hE+IA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=x1Q6Tggc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3durs7Te;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=15LelkYh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qXLs1ktp;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788351969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=72wmxbqaTQSd4Gp56E8IKCIL1P/wg2sKYEhljEbcwmk=;
	b=BIBbiX+LFHr9Rdjh6u0zJVkswyiF4kUbOuUquLThqjfSeQPZOQ4z1Z3Pu/Y4H2AQQBjeP/
	0j4E9bSTfEM6hEaZIAltBx1DGV0a6YabAVd20qykdyESpZpAFCQ3+f6ZEMkIrZx2PuLyji
	zcGAYLCLnnShu3DOUNp18V/h+dkb7t8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 72DD821BB8;
	Wed,  2 Sep 2026 12:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788351963; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=72wmxbqaTQSd4Gp56E8IKCIL1P/wg2sKYEhljEbcwmk=;
	b=x1Q6TggcPtez2lMc9t1LJxDfCFOroZzUPuE215pcy3bgD2jsC37ZpYg4P13H4o/f5wzFIm
	HSU5ScbS/XeyJffItdex38NWzGJSfwiTaPTS1lkieWvEBkUi86ccDJVBeURwNfahRw+mat
	D4BbQnth94hZLTU2EcHt4j3SpZ231sM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788351963;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=72wmxbqaTQSd4Gp56E8IKCIL1P/wg2sKYEhljEbcwmk=;
	b=3durs7Te3aKAet7Jjsj4xs6oNNc0jHuTtEvxdqihoOhy2u1nODy8wyWCScAUrE5Bmu1CmP
	6KKsFvsxjZYRG+Aw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788351959; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=72wmxbqaTQSd4Gp56E8IKCIL1P/wg2sKYEhljEbcwmk=;
	b=15LelkYhGFxoxKG40ubqTifGBsBkpTlf4Iiv0cN9eWMdXd314rrLcQCI+/tvWZGjcQsnDz
	dhZo2y66uqir3aNVJ3TImyFFgx40HUJls2F0ceilgYo2cktUai+lRm7FYo1WbmI5w25osC
	SjGOAaEEAW+amBQsHJP44d6mZGtDU5c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788351959;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=72wmxbqaTQSd4Gp56E8IKCIL1P/wg2sKYEhljEbcwmk=;
	b=qXLs1ktpcsphdNzSyYz5f2yVT3+2ck4Wc3VpSdApALk2BBvu2YFZw3GOiiKQCymwMYWS9c
	5mU9W8b/qTWn+TCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4F53D136E6;
	Wed,  2 Sep 2026 12:25:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uZYNENYVmGplFwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 02 Sep 2026 12:25:58 +0000
Date: Wed, 2 Sep 2026 13:25:56 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Eli Billauer <eli.billauer@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>, 
	David Laight <david.laight.linux@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Brad Warrum <bwarrum@linux.ibm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Michal Simek <michal.simek@amd.com>, Ritu Agarwal <rituagar@linux.ibm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 2/4] char: xillybus: replace __get_free_pages() with
 kmalloc()
Message-ID: <apgTKYKSBzbdDJZa@pedro-suse>
References: <20260830-char-misc-v1-0-05e2ce44f291@kernel.org>
 <20260830-char-misc-v1-2-05e2ce44f291@kernel.org>
 <f6001085-9234-4025-ff34-6cc4a66c293a@outbound.gmail.com>
 <20260831123937.32255a49@pumpkin>
 <apaF1HUtJnstuUN4@kernel.org>
 <1729fb06-6beb-f8ef-3e71-47fc3f00345d@outbound.gmail.com>
 <apcPg_y-HsMki7we@kernel.org>
 <9a3d6a08-339c-3315-cc81-46907d0836ad@outbound.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a3d6a08-339c-3315-cc81-46907d0836ad@outbound.gmail.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: wks7iia851k37w9x94unm1uz4gc533qd
X-Rspamd-Queue-Id: 2931A8000F
X-Rspamd-Server: rspam06
X-HE-Tag: 1788351969-717321
X-HE-Meta: U2FsdGVkX1+1BcsAnDzaR6DoF6pyddsDv2v+kFGLLlTC7/JPh6chi2tWs9xj0MMnYYoTigjZF3ndMHS10OxupvGLCRdRhge70FHuuTS9nCoW8O1PpuTRTchPi7UYDF429wa7ZQBRb/lcOfKorMixNW6h6bOU316FeFfz1T8T/jY/iRNBJ38LRG3qyd3j2x8Ni5VhLVw+386aYgb/wILSFtGgbGuvDrmkW+iNksCdWE2INK4KJmDpwDc1cF6fjKDGXHC3YwHu+c4f4/Uw+WO9JnXtr5khq4YUkkHg4UhP9AxEcoCMmwWQrVBDShyjrrTrubeAoVLJ8vaxLBKbZrZkzYoawqZUvvfES4HufEJT70PCGu6YaVv+wkBSIMlErlU0Aj2qwZ6Fo7Le+GJ+jxCADyprgscvZuVnERuvkdBJMUWfpN+d4JbQ+Jm5FV/MYR0opdy5nlpcFUj9OUdShPMzT9Ph06ifr+EfyKQEP2yZ2s2pgsk1XaL1qTITKzUdaZi4+9jrWz+XgVnbzHDBdE8XdOYSXJhg4aMY2B5NBS8xh1nNUZ9v5H0IgsUBgfb3z732g9IbJZleN//nlubunbtdnovJ/1Bk+20YE2CIsoCneYW/KH4mkLok2iNqXX2PgBY5sK/eGRT8Z1p8AUbC6CQ/UNCrxx8RhBZ9kDVWQnzUZHKRAXPnbiaoxUJN7j72Z2Vo5tv5Uhal4tVwlRGI/4XBV6AFCKg9NLlkLofeA7RM2ZH0p2ukAdSt9rlLRi5y7oCiq1UWpQCx4KWv5+PLoE7RMtHhYgxRO8zXHotVTbPkzZMmTVrsG0WdPpTy6WHiyZO/GMhINbFDz8mR0QByAwXbehICtjOlr/vB6V7r5G6faj6aNqEW2+OJwxRMcu6sPpjSEm44F8ZX0V47Dq56dpc8faDasmGBiu8cU2kskfwmsmZ3qsxpX693DP0/4a/ulLzM9numMjxIS0h7Ln/Q+UM
 8PPiIZZp
 dL+wFv64qbzKpx/P5acj9k9vnO8kk0UrP4m7/L+i0NxcGV3vCHF+hEdtiasoAlxwbLRDgXHxvtc2W0t15VSD5Zt9NeiTKycxa90HIAKkqRfkqiJ57sR0HgAfL9kN3jBnk/B+nJjF2bjtOR+daJ9mme/jN9M+CgXZCfZKqSIFo5IuLnmghzL1+ppSz9boavGHr+MzHJv/FeOOlFsyYPJJfDzcag6P6QM45w/gNTkuIE76gmw9mfdRGhj6UWnkiP+z0SdW8CbBgkD20lOO+3vMiH5T+cWhW9kbo+K3r+RTvnYco4e7R7unNklaps92kg7uvL6g49tnkybI37c6lnP2XUNi6wDwF+Buy3wotbOzni8ZC7KtoMQ/kYWgn5tOWQUvW1QxUIFkh3cQbuRXJ9QNMBooyeB7iVf7MaKzbRpOeEUTaJRE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 01:41:54PM +0200, Eli Billauer wrote:
> On 01/09/2026 19:46, Mike Rapoport wrote:
> > > * Does vmalloc() guarantee that non-pageable physical RAM is allocated when
> > > it returns?
> > It's not pageable in the sense of demand paging. Some architectures lazily
> > synchronize vmalloc page tables and this can cause page faults that will
> > take care of the page table synchronization.
> > 
> 
> Thanks for this clarification.
> 
> This sounds like a showstopper to me. Immediately after the allocation of
> these buffers, data from the USB device can arrive at 400 MB/s. If the data
> flow is throttled as a result of handling page faults while trying to write

Note that these page faults are supposed to be uncommon in nature. They will
only happen in architectures where the top-level page tables are not
pre-populated, and when they weren't populated before. On a 64-bit architecture
that would be something like every 512 GiB of address space :)

> the data to these buffers, this could lead to an overflow in the USB
> device's own RAM buffers. This is because the USB device is an FPGA, where
> RAM is an expensive resource.
> 
> So using vmalloc() may result in a malfunction in the data transport where
> the __get_free_pages() would have been successful. This outweighs the
> benefit of a somewhat higher probability of success in allocating very large
> buffers, and surely the improved aesthetics of the kernel code.
> 
> Regards,
>    Eli
> 

-- 
Pedro

