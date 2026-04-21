Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E41ECF5A8DF
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 04:00:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BB4D6B0088; Tue, 21 Apr 2026 00:00:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36C306B0089; Tue, 21 Apr 2026 00:00:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25AC66B008A; Tue, 21 Apr 2026 00:00:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 132C46B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 00:00:34 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 95CBA5C6E4
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 04:00:33 +0000 (UTC)
X-FDA: 84681211146.29.74A6DC5
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id 69333A0011
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 04:00:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="l/rWzc7W";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qkBNhF1f;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="l/rWzc7W";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qkBNhF1f;
	spf=pass (imf15.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776744031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4A0ljlz7kc/WriQ+M/v/RuPawRjA5LvJ8/tA1kiAeS0=;
	b=ZfNAYhp3YA8bW2aYjFJz0XSQTyeSYnRsjq5OogXDgIFyE/f4A5YidO+98RLX8l8MJzC9Fk
	wC9j/VOFByD0GwJ5Z6/TV3W9T/2TEz4ty0Z1FyoHKYebv+g1/2dkoo2YT5TtFLsAJMlqEY
	y3VMSt+VsaLg9ORdqV9qcDeTyP30xwE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="l/rWzc7W";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qkBNhF1f;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="l/rWzc7W";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qkBNhF1f;
	spf=pass (imf15.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776744031; a=rsa-sha256;
	cv=none;
	b=UODT1FM1UmBvaMRj0iWfFpM3mEAFODuO04XwbKTzVN0xcnaf2cxvrflQQIRyjjHT7YxVEn
	3+SwWgrIUi5gQAjT08Cikjy8iDX0GToUOR7gWHn+AsNUjc6FkTWKD/V2u+p18dHv6gXP0t
	qxMZyObIftVP0YabXlMug6I3hcjyrWg=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F05785BCDB;
	Tue, 21 Apr 2026 04:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776744030; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4A0ljlz7kc/WriQ+M/v/RuPawRjA5LvJ8/tA1kiAeS0=;
	b=l/rWzc7WXlG1ul7xO38sOUa9Pgk1j890efsw9F/Rih7jfUqvFT7L7nTXY3ZWZA+jmp0C2r
	dBUr61YekC/8vZQR31aqOPcgWTO2+xJhDf4A5Qr0ZTSZxy/UAguM2PH0P5ivfSBvxWJjHF
	CWxvRGDpMuS2nfweEHs4sK/nYABxexs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776744030;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4A0ljlz7kc/WriQ+M/v/RuPawRjA5LvJ8/tA1kiAeS0=;
	b=qkBNhF1fpYtHAmCt1yloAGLz1VUrShhp9DtGMDvaI/6hb/adOboe+fZLsHz1I9RCe4JdVg
	snuwQAq3XP92dLAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776744030; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4A0ljlz7kc/WriQ+M/v/RuPawRjA5LvJ8/tA1kiAeS0=;
	b=l/rWzc7WXlG1ul7xO38sOUa9Pgk1j890efsw9F/Rih7jfUqvFT7L7nTXY3ZWZA+jmp0C2r
	dBUr61YekC/8vZQR31aqOPcgWTO2+xJhDf4A5Qr0ZTSZxy/UAguM2PH0P5ivfSBvxWJjHF
	CWxvRGDpMuS2nfweEHs4sK/nYABxexs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776744030;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4A0ljlz7kc/WriQ+M/v/RuPawRjA5LvJ8/tA1kiAeS0=;
	b=qkBNhF1fpYtHAmCt1yloAGLz1VUrShhp9DtGMDvaI/6hb/adOboe+fZLsHz1I9RCe4JdVg
	snuwQAq3XP92dLAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EB57A593AF;
	Tue, 21 Apr 2026 04:00:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CS6oNlz25mnwYwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 21 Apr 2026 04:00:28 +0000
Date: Tue, 21 Apr 2026 06:00:19 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/4] mm/sparse-vmemmap: Fix DAX vmemmap accounting
 with optimization
Message-ID: <aeb2U5tUQQe1YzJY@localhost.localdomain>
References: <20260421022044.1217503-1-songmuchun@bytedance.com>
 <20260421022044.1217503-4-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421022044.1217503-4-songmuchun@bytedance.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 69333A0011
X-Stat-Signature: c9rdsjnyseeeh5zuccatn6cd83ktg4mf
X-Rspam-User: 
X-HE-Tag: 1776744031-12498
X-HE-Meta: U2FsdGVkX1+IdT0EijKrVAfNmMLxgW17WNv2F5FU+RCqgvHt/IFaIgyFu36jem/aBGZidomlhniACfCniqFUANqMFtelUcO24imKIJGy40T0u/7gHolNXXC8ii9S5dXnmkxh9RLFw5gO+PGvmmT8p7nlQdYGhiijezcxNb8Z4Y4G2x6d17adB3XzMgDAaMU5lhR7I02tk48AgUNYNABjy/STXrPDxCtvCL8iip93xRvpfcQXuLp51GE0uZP8cXoJUkPvmxHfnmqHJHXp9exnFDfvy7U4MU/9284R4XjmkiQX1Cx7usP8AoPOf0vCbBoa+eaIClZT/1IR/BL1ZZrhNBAxHLiUec4SnqlLq+IdTV45ih59ru4evrs66ufMpVRabwpN7oZ5TJklJShcOcl6IQiVGejCM+swoDI7ARqkqAET1BmNn5RShhoHyeyti1N1Rx+/HNe8JbLxr9PM6Axi/qP4i/8VckJDwiDmMQGaN6PGrsXFtBH+57mv4ajqdwub9QvhTg+O4IbLKAL+Sn6kxw7W3EFiWq57bkjLhljAQwn9u0Ejqjr1dVKxSfXzn4eWWtLnLF081TPeS05fMbXG5pL1zwd61u6e8/EE/MvMDYmlsCrjgw0wvHDix4sk6xywMmN74INsDh3wpSZQLdyg1r3IJuOgA/+Z/mhiPOJ871MY7GmqpPoWXRDm/qWXwAwzCmBaLmNSOhrlOkIPh42tIPhIpbKBhp8ABSm8NqRo8/vArxHXSrBCfgzV8Oc7FSA/bEp+xT5weFxOAwkGW+FfQEe1h+PZp7eoYZNoKADIL39ZnOQ22GYqTIOFRxWQCN3m95paSo9G8qPV21u1gs/a3MTj56cOupxnxkwqDS/oN+lDQdYEdKmmcO8sm3lJT++CaiOJqNyTYtuV97/5iUgExafAAAM0cOnXAYeKqGDFKcpEm3LgwCWuFmk9IGyZ/VL8D7wRNjLrudCcbvqj3QL
 LjMZy24v
 R9S5ggctAn6uTtEM26XfG3Rvf9mhsSkucHb5R/D8ow9g9i02mZbA2dqQy3kLED8306sWLt6c23ohPgXSdM36mJ2vxE6ORFOxSkE02vsXVsa2QPtSLvXBlDnoDhjr/IC7ZcInpkyhHCAApLkEKrawidOs4QfrW6srO1Ewsm+44U/e0ZcxndiBlwWB0a5SYHX3sZqlfc4uXSQS3oHC4XkTR/Vi37tNMfCdkfuQyAJy/kSygFcDKIIkmD9Gg10JT1W5XZT+WQWiHglnkPyYcYWQrSpBi0MJRN6EDmD9Jxz5f+gUXFdhNcoQVqRgGjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 10:20:43AM +0800, Muchun Song wrote:
> When vmemmap optimization is enabled for DAX, the nr_memmap_pages
> counter in /proc/vmstat is incorrect. The current code always accounts
> for the full, non-optimized vmemmap size, but vmemmap optimization
> reduces the actual number of vmemmap pages by reusing tail pages. This
> causes the system to overcount vmemmap usage, leading to inaccurate
> page statistics in /proc/vmstat.
> 
> Fix this by introducing section_vmemmap_pages(), which returns the exact
> vmemmap page count for a given pfn range based on whether optimization
> is in effect.
> 
> Fixes: 15995a352474 ("mm: report per-page metadata information")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

