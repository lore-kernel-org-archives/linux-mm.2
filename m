Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAC28606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 05:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YSlcPgUK
Received: by kanga.kvack.org (Postfix)
	id 041BC6B05B0; Mon, 23 Nov 2026 00:38:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F340A6B05B4; Mon, 23 Nov 2026 00:38:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4AF66B05C6; Mon, 23 Nov 2026 00:38:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BCCCD6B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:38:34 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 46054C07F3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:38:34 +0000 (UTC)
X-FDA: 85465278948.22.C43ED7E
Received: from mta1.migadu.com (out-141.mta1.migadu.com [95.215.58.141])
	by imf16.hostedemail.com (Postfix) with ESMTP id B2AF3180003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:38:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YSlcPgUK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.141 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795412312;
	b=xy5HJPXdw+lCpiru9qH/lyTu/8RtZr1OKHpegW7Cv4TitzQdLmvFJOAfLmaARUEVx603Gs
	R3vTQAeTXC5yIrCeQ9VQ7W9UIDuutSreqStKBcMRTbGDlnl66q/W1xZNhP7Pr/mwTpY3A7
	d+ogouW7AVFJ3bOJNcpwH0eigj7bDSQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795412312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kQBD5MbUBLOzHLbsNcCCef5FX4fxCpMbix7OBi6Syxg=;
	b=vy6wHdY2QL78GE2HRX4zK7nD9Y2zbhZaD+Y/T+bnitQmegvMzyFmAU6cjiEfjAkdFR/SHr
	nePVttRjFV9hcKIlSBUOLgRAtMmcP5WImYcPI35vZM1wx0zQaQqkRWkce+i3L9dhVhpJF9
	1M0BIshywal+9uCz3g8w7ZNd4NfBpKM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YSlcPgUK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.141 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7q3ikdoHrSkNyqihxAmPncUqiSkmfzTa1Q8iooQg3NU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795412309; v=1; x=1796017109;
 b=YSlcPgUKlK3xiA+2WQpTQp/QR3+4zrds/r0BT1CnPPIB7UQ/uA74SIGWUDn3oRutojM8X8s6
 vCiZ8eynwy+bmf7kRR0dx/7W9b50QdRaAYTpbR3wiu6t2Ch7lz2uTM6o4yrBKSG/BcrzJBJlowz
 QcHEHuJJRkTU1YqS9zrcs7Wo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 953e590f3ed05e65;
	Mon, 23 Nov 2026 05:38:28 +0000
X-Mizu-Trace-ID: 953e590f3ed05e65
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	nico.pache@linux.dev,
	jerrin.shaji-george@broadcom.com,
	bcm-kernel-feedback-list@broadcom.com,
	arnd@arndb.de,
	gregkh@linuxfoundation.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	shao.mingyin@zte.com.cn
Subject: Re: [PATCH 1/2] mm/balloon: fix NR_BALLOON_PAGES accounting during page migration
Date: Mon, 23 Nov 2026 13:38:19 +0800
Message-ID: <20261123053819.88374-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261120-b4-balloon_nr_pages-v1-1-d8944b587819@kernel.org>
References: <20261120-b4-balloon_nr_pages-v1-1-d8944b587819@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: emxzh4afjpbztwkbnx5nh8xfd4jo8z8s
X-Rspamd-Queue-Id: B2AF3180003
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795412310-216240
X-HE-Meta: U2FsdGVkX1+kafBrPblJXv9BlxACr4U1xxvcKfmrYU2f1dgOfwQmmgYgWRuBD0ODaYZm2TZCbiw2ljj6+lafvV7CkwFoRq3/y/uXxL41E3JqpwTXp/9z7kdqSD0W7BIjlHn9sswc5LHqExW5ahYmVa/V5MnHMeehQVBWl0ezfc7rX4k9iPl3lQBvoGNj8zZsO//xAn2naz4oZWzle7gtGkobBuDY12bSCkbeAI8ic8FCJ98UZ64wURoU3toBNW1+mA/31+vn4mwZiMBuoEwkl6tlByLgoN0/a1HyBOYAsSfiBUjPngQO1j3WCCsoQvzGMf//TR8ndb1T9FPUeTV98kL5UF63YgJL0X2R5rXIRh8agaVonR7Kf+9CjXKcdWjYYAUH/yPF6hWW32nQ+i7W9ibKWjl6/oUwLUtk3pC8enRUqotoA2iPQmNJGxZs3Yo5cSiSySNQbv3CeIEgQLALaSowiWwxcSspaON6tk1HtunN/pEikZ039CmSikHlv5EQMRzUEkFo0Qlrh+hzgDwj9aa0D5V9ytx93wQGUGFJuudtt8+rviV7r9EmSo0LjZxsiJW3dbF6vme92i08x4rzf3yBO1gyy0yTuVXsCapprIKpREeFOHbYdaX0LyTeFSTr/CReZ27LTzju6/Ge024bj55yfy4EQLLaHcmKqjevDN79gJ3l8aLC1u59jGraFIu6QWagMoCjKnOPOTV7S1VjKKRKvMwFwSNzsR9mrJ+FJPC+lErDT1Q9aGBlp6AzKc0dmrUJ2uqfJaT+gV3mCox7mqjupUc6NTBYk18dyLF7souCod24c/Ngw7skllMmCTZv8yY7pGhRK2hiBBMQBLZ4b8yYEpN97L/DDhhY4rlhHQmc+jm6+LSv/M6G/017DDMQDipc4sv+k9fUufLrRQuXEurOP+G8wAJfwAhNyh0eFWqt4JQue3rsoeCzEP6TG9o4La6ZRqEZ9h4nj3pzci5
 k1CBVcW4
 v0JptBDVsAG3jZqmmE0VeuglXsq4wY9nJFfTiMPzl7x10wqfSq0ep3I3gZ8N2oFq4GB2UoZmHK+vMNXNndgDihpaWYsQ4XqyWTICl2RuG7OtAd0Bi3dLw853su9pA/xJlpGOBReTQ7bdIN3gMRy3Xvc0dWGm015IfgLYaB0KTV7cyYFU7nsXawQXcEXTddXu3dGmH2089Gr1Woo+cPmaT+j9c5JKsTgNogSciQXOnNJQW0tNPQ7IItlae1SJSNZBdvY51IL7zz5/OmdL9jG5DgzahwfOh4OQrlJxz/dAid6qlwvGsYkr65D8whkViWTzt5QRdDlzBuJAC5Gc/f4bVLdVaq1TF4arNS45tzvbBhAm4+dUY9XbQZwtkr7TF/t1Enl3zQzUH/yqu9cIWyQDUaKjAdpRRvMZtXWCZWOGns6tF1bBmRPo42xlXHJ/gtAvdtzIfwn+On4ZZwU9ta6OXgYVFotwfRpODIouUB0UhMXeZr86VdYND8DxOmJ+CVgNmoHa0n5QyLpoy4aweqeHLPslph++MyEEMnzT4DeFIOOKV2BxUABoYGhUWRkt/BGih9L7fbwnJZmrnNJ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Fri, Nov 20, 2026 at 11:34:42AM +0100, David Hildenbrand (Arm) wrote:
>balloon_page_migrate() doesn't update NR_BALLOON_PAGES in two scenarios:
>
> (1) If the new page is on a different node than the old page.
>
> (2) If the old page was deflated but the new page could not be
>     inflated, effectively deflating the balloon.
>
>Consequently the "Balloon" values in /proc/meminfo, the per-node meminfo
>etc. will be wrong.
>
>Fix it by adjusting the "Balloon" counters accordingly just after
>conditionally adjusting the manage page counts.
>
>This has low urgency.
>
>Fixes: 4d689474e1b2 ("balloon_compaction: update the NR_BALLOON_PAGES state")
>Cc: stable@vger.kernel.org
>Reported-by: Shao Mingyin <shao.mingyin@zte.com.cn>
>Closes: https://lore.kernel.org/r/20261115004708909xx05JgB9nXnOCG0zL7h_K@zte.com.cn
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

