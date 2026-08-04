Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F5F7C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 13:52:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C9A26B00E6; Tue,  4 Aug 2026 09:52:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07A0A6B00E7; Tue,  4 Aug 2026 09:52:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAADE6B00E8; Tue,  4 Aug 2026 09:52:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA99E6B00E6
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 09:52:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A6F581A013C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:34:47 +0000 (UTC)
X-FDA: 85063531014.15.C5E09B1
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id A3A0A140004
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:34:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf26.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785846885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1VZyWV/sBNXUleHaYHmmW4Y4u5KeXX8J+jfaO5wklAA=;
	b=HJsTX5xiv1y0rIZf1jpyW7NxYrc4Cz4DBzh0eGqoVd9pXQfeHb17QQr2bbtlvgtYs3A9Mk
	+lUZsHYrbP0tOah0o0unOxi3Fu5zEUA5u+upZEtdqgtTcsTK2z4RF6lez01DFGetYCycyX
	wRk8INaDwSejsBPO81VFM+uows2LwTM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf26.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785846885;
	b=pDF23+0ZAP/hhh1x4jqfnfl4/fVYhs/qLpPWlNkmcsheJ3C7INjV7DyWXB3bh1bTQz0IhR
	Rlgmy/8FV7btcaCcpePvqyrlPXyUcxLJtIKsZqQ/htvc9Nq5C7D+RQDc1C0nGmfSlZTiGE
	/8YuAPIYX56L1pikAXM1m6eQ8l3PL+c=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8E7923FA1;
	Tue,  4 Aug 2026 12:34:44 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AB46A779C4;
	Tue,  4 Aug 2026 12:34:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tKeyJmLccWoTUgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 04 Aug 2026 12:34:42 +0000
Date: Tue, 4 Aug 2026 13:34:41 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kevin Brodsky <kevin.brodsky@arm.com>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	John David Anglin <dave.anglin@bell.net>
Subject: Re: [PATCH v2 2/6] parisc: Drop own implementations for ptep_get()
 and ptep_test_and_clear_young()
Message-ID: <anHcJZYyz9Zrshdm@pedro-suse>
References: <20260803164400.531199-1-pfalcato@suse.de>
 <20260803164400.531199-3-pfalcato@suse.de>
 <anHHyiHqYf3yLf2K@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anHHyiHqYf3yLf2K@lucifer>
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Stat-Signature: mqkuyu8qw5b13dmj31f1piyr85ibphbn
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A3A0A140004
X-Rspam-User: 
X-HE-Tag: 1785846885-596340
X-HE-Meta: U2FsdGVkX1/FQqF25ysovC0S9acTX0xKR53yhl6cYvZMT93IkUfvkLCUSP1QzUqtpFJWYhWiWRCcQthvF4yRy6Az6Q9pM3Z7W2aNoC95Qd2cYw4y70I4X/VDAAMmtw1Fpn66u7XtrY6easDTl6Q3l1WmQM9qYn4hWuxYyO4/4uDDCwR9viJu9+Pee3qiPbve/THrQof+4LtcQzu11nBXVh6ymSpj6UrKsHsSrBnJozwB1kRos+Bg5NElqt2ChJaOPnwjLqfOodui4ZJOaaBF6r4yiPM8pWH+5hP9Asi2pwZ+aTUWvvhnnD8x8E+FIeSe7fNOO7diRIm2KOJv2SYPjyBcmvEIflPizoobVcbHBzUwC0rM6UbnLr5oanbFkHs6V4Z2nFd0Y4syMHfnRQFFfEd38E820TXDVbpyUNouh1cgwArEKRR6Z1N74fKIYeS+kULQzHI1haal+C5UuSfkWnaeu9613AKQAYu+HupGzeMeOFrusOF4HWl4eLpzGsBYv5Pbnhcxj6b06Ryo/Y9YRUlral030shK+A/MsNZAJlCVa43uvcyPnZjZKqtdbpub0Ty0BuIWQvWdn5m2X4/UG26j6u+D7YxuSXX5bPIoVhCSMvhpviu3TXwEG0BNi4XEvrWYXSSQmpg1vBbFaI86MaxIkYGHqpt9MeQrm3mWUk5KS8XsvscGLkQ25rW3zcHlrR9z/W6y7Maf5ymTKb97qFlu88UvzvmH859Jc7ZKhXo/OYy+IPvQqRpPpQUPTNq2hLxTb38taUWwJtte8uttDUouhqugDG3nfC8v+d07VFsrrpxCjuSqVbK32p29Vbg79BSzSeHVXQgmYP/eRMzxawKZ/uID+q7Ks7NVSiDyUlKH/YmvjWPAYgy61axM1xfYBUAfylhzoM1mcJEbwg7G/jnf+ESPgx7QhLIoJnpwRDW+naU7QaRPGESGrLWIM4GQ2cpyI+0AlU4gKQ8xiFg
 2AuN62Ge
 E0LyCFoAqcYNGWg2dx/CJ9gbYjaSPAEtfN/FPPCRmdCF1Ie48mxDa+EjCIFbNQi/OtZRV+xWBfeyPOBNWPZWvaaOhmc++ei6eLyxh6GRkd4OSyhp+5bJomhiEyO/3zD+EVG7bv3u4rraGGzdk+BfR61rZBXeaFb1d2Qzf9AKqhvF5NrCEFyPXo/GLKFavfb2zVGjD0QMAOKY/8HFdym/x+7rqO7FzaQwU4M4FTXqAYGAzrmiZYiHoqdkPNYiOqoXbaDsaqnT6IaUBPY7QQjajs0BJm8ilZEOshIZoM/pfz1qIZACQg8TXc2Tw8rEWkUsorAJ/L4noG9uMjhcbQ5MAt8ChwJvZUHEDfE4ToHUs8+UNXY/jNy1xZfVc0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 12:11:08PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Mon, Aug 03, 2026 at 05:43:56PM +0100, Pedro Falcato wrote:
> > From: Helge Deller <deller@gmx.de>
> >
> > Switch to the generic implementations, which are identical.
> 
> You sure do like succinct commit messages :)

I didn't even write this one! See the From: :))

> 
> Maybe worth saying by dropping the __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG and
> ptep_get defines you get the generic versions from include/pgtable.h which are
> functionally identical.
> 

I can touch it up though, if you insist.

> (Being pedantic, they're not quite strictly identical as the
> ptep_test_and_clear_young() generic function does some weird unnecessary
> indirection with a local variable and the single {} is dropped etc.)
> 
> >
> > Suggested-by: Usama Arif <usama.arif@linux.dev>
> > Suggested-by: John David Anglin <dave.anglin@bell.net>
> > Signed-off-by: Helge Deller <deller@gmx.de>
> > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> 
> Nits above notwithstanding, LGTM so:
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Thanks!

-- 
Pedro

