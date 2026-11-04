Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 598B5606A332
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=M1Dvvfjm;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=hJ+fAk3O;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=M1Dvvfjm;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=hJ+fAk3O
Received: by kanga.kvack.org (Postfix)
	id 793B66B05B8; Wed,  4 Nov 2026 08:41:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76BB26B05B9; Wed,  4 Nov 2026 08:41:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 681926B05BA; Wed,  4 Nov 2026 08:41:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 460A86B05B8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:41:17 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DD159C0753
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:41:16 +0000 (UTC)
X-FDA: 85397548152.13.B115810
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id D1427180006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:41:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=M1Dvvfjm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hJ+fAk3O;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=M1Dvvfjm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hJ+fAk3O;
	spf=pass (imf06.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793799675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d0fx3jue6yBdKZwD4p5LcxlMdLny64B3v9Q+ZGMsubA=;
	b=OlQsbzIEFoLdw3TUbRrinkdkMbymc3NpX9PEKdXKgulPejGlG3dqvsapNrS1RZHVFqRbMU
	1MIzQfqZ7XvvPyTx2dpH/QqgX8yzX5nYn1MXZZADQGlvq7h+bHoXGAU5U2coFbfdxQIgZx
	/QNa1eY8QFedblg4TxBxUB4fKrvkvi4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793799675;
	b=hil8rz3ByotfAq6ARb3pJEm0cfkoJOEVNjTIliIsWvFaBvbab9IWj5jaLjcsXVgK6ytl9B
	9aHvQnMTCrrDzeNLjPAioe8jvxptEg7f7jF/RP5EWENnw03fiNoyAFibd99KcJPacfSwGT
	cjBEOqQQefkG04ujsYwvY1ll29R0CME=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=M1Dvvfjm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hJ+fAk3O;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=M1Dvvfjm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hJ+fAk3O;
	spf=pass (imf06.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 64F091F795;
	Wed,  4 Nov 2026 13:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793799673; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d0fx3jue6yBdKZwD4p5LcxlMdLny64B3v9Q+ZGMsubA=;
	b=M1DvvfjmuOl6MeDPykrHeEITAQNrJbxTmMnti13XKWSzJysAKC/6g0Bz71SUbYPC6zrqLW
	1gf2frwtAvxm99smHRiskyxL1chC7OclWFaFZlgBIjvlA+zKkcJNICW3LFBKO4ClGtLnlY
	R7zaPHsJtd1MCowUCA/we7gL+8XKkJ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793799673;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d0fx3jue6yBdKZwD4p5LcxlMdLny64B3v9Q+ZGMsubA=;
	b=hJ+fAk3O0waErwrATsWzqvdGxQn4P02zc0ezttMXg1V/DtCfNTP7PLYZmBWnN6UAiVKk6s
	WWLHsT0wIb554nCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793799673; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d0fx3jue6yBdKZwD4p5LcxlMdLny64B3v9Q+ZGMsubA=;
	b=M1DvvfjmuOl6MeDPykrHeEITAQNrJbxTmMnti13XKWSzJysAKC/6g0Bz71SUbYPC6zrqLW
	1gf2frwtAvxm99smHRiskyxL1chC7OclWFaFZlgBIjvlA+zKkcJNICW3LFBKO4ClGtLnlY
	R7zaPHsJtd1MCowUCA/we7gL+8XKkJ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793799673;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d0fx3jue6yBdKZwD4p5LcxlMdLny64B3v9Q+ZGMsubA=;
	b=hJ+fAk3O0waErwrATsWzqvdGxQn4P02zc0ezttMXg1V/DtCfNTP7PLYZmBWnN6UAiVKk6s
	WWLHsT0wIb554nCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 29E34134A5;
	Wed,  4 Nov 2026 13:41:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +ybCOPc162reOwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 04 Nov 2026 13:41:12 +0000
Date: Wed, 4 Nov 2026 13:41:10 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Imre Kaloz <kaloz@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, sparclinux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] sparc64: replace move_pte() with a D-cache flush in
 flush_cache_range()
Message-ID: <aus13nY84jxvzOHF@pedro-suse.tail5790ac.ts.net>
References: <20261104105300.16260-1-kaloz@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104105300.16260-1-kaloz@kernel.org>
X-Rspamd-Action: no action
X-Spam-Score: -13.51
X-Spam-Level: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D1427180006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 5u94j9ynmiskkrjk1f8913y4tp6eed1q
X-Rspam-User: 
X-HE-Tag: 1793799674-835701
X-HE-Meta: U2FsdGVkX1+SDrQYcpLZV4A3Caoo8G6qgYlePLK2jSC8LXRNZu37e3rHYLgjtYULQXqAKbivyHnozfzh2YgzlIxUhyc0/0p64GAeOAImAudNSPzF049U3jWwOC577b6rJCEHfNrgsAGhlGAdcZMjOgb4Cda4970GSAKzfCpmWsRhtl8Fqzg8DD2y2rkuBWReHBjIFhwkD5bvcc/hpVYFMpcVtxhi/V62aZG/gMrcq07MHa3P7wBlwO1TrXEL72wkCNF6VXwSQjqvcezA75cqArsG73wz/xAAgx9ETVM/K/sZtNb8RNqgjbjtpjhToneCPUpmwTC0fys+rIHwPimSi4VgrIhgxbGQS9jDxL29Y4o6V4bLXTlCA52uiFoSdg/BxM1t7KqeoxazDQ6mC2kgj5AlmobQllxpykhnrVQSD3UBQc/kt/8AkiRVh028SuZbUOHIWHtANnuAjgTKv2RcSTtKDc4eD0V0SRBBrbzO7drlI0QYZmtsQ57omCEIrgXzw8r3ARKhWQGe+NohKJgj6FJxuWitCoT9oCjOWyVqyrkTsp9R6kTEtkGodYhdaFFgiJlSrUhzFarUaq/kkvjqmEcpA7uEl2xHkTr4R0oNQvO7Hq1PrM3wdCOLzdRokUTw8UZqXSiKybesYPllav/cnJB86jIgJFbXoPeoHFd8amY1jiOS5MZe7pkLO3XkvNrrUFVrdm7EMqnar914yg23f6gIqfeEN+vWaFU47JOACNqasj/M8il6e438LcyAO3bGrL9J3NNxUzG8W4aqFcjyIpm+mFP7e8QES2QZrDMS3YG4htkHAx+uATciuClLbSCDv1AHu3IwUva3Cf6TfTmKDMew+qbE2B3DxKMSW4QOn6cltSsCdUguH0Cfu+LK0l6xDZ6vZRgXIBXaW3/2HBZOOZkrUm4vUqlWVL3SFMWDrOri8vmJdtZzX+TSrkcC6L7e7tvcgSsf76NakCXhBUd
 9tnhuwWH
 HshCraGpuOH+WFsNGScDFpRN0++l3fqqGfd5VB0SXSgbko0fEpsoLAxEx9XMSrEPDlg70TxFIDnQsdEcIJZxipNyVAYXpqmAb8cJUxbARQH0CAjDRpdHOTkK/oqlR51CxhDcleSpzo6v5xbG6rcbb54ZvTV4Lnfp0BxeDxYs3crklnYyCuuERvi4NI+N4ykM9ZSwSSQFfo5AY5UU4eUVCiKcOLnRUjFpuTqN6iWd1zCE2uRsdNxrskGCCdYvRiziMPj4jOAKJoeunQc8yf021svFEPP7B/LQ/nYXgCSiI4gMCFj1ymWwtF6v+G4IBlwQODnKIJdZqS5wXn3g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 11:52:58AM +0100, Imre Kaloz wrote:
> mremap() can move a page to an address of the other D-cache color,
> leaving lines of the old color in the virtually indexed D-cache of
> Spitfire and Cheetah CPUs.  move_pte() flushed the page for each PTE
> moved, which is only correct while move_ptes() handles one PTE at a
> time.
> 
> Drop move_pte(), which no other architecture defines, and flush the
> whole D-cache in flush_cache_range(), which mremap() calls on the old
> range before moving the PTEs.  This keeps the fix in sparc64 without
> a page table walk.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Link: https://lore.kernel.org/all/409079fe-ab52-4389-9fe0-d7246eb27bad@kernel.org/
> Signed-off-by: Imre Kaloz <kaloz@kernel.org>

yay!

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

