Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADA13D2F02A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 13:36:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 026EA6B0088; Tue, 27 Jan 2026 08:36:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFFA46B0098; Tue, 27 Jan 2026 08:36:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E16116B0099; Tue, 27 Jan 2026 08:36:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CF2C86B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 08:36:01 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 815E71377E0
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 13:36:01 +0000 (UTC)
X-FDA: 84377842122.30.FF18552
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4A436C0008
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 13:35:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PRSg+kr8;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=PCh5v4X2;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GOf1JvuU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gErQOfvd;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf10.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769520959; a=rsa-sha256;
	cv=none;
	b=Hs3glrtdpUe3ond40TZOKdvtpsO4QhEW6d14Q41UM/RVM+31BOfE2Q6SRc3pSrvkQ/g603
	05to3KqUAfViddvoheJf+Q9StfTQjIvV+1TjsxI/7QOEEz3eYxifTM7288ftMhnYNk3I+9
	mcXjwhk6ssNaWSB7b7GXSck0FX31NX8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PRSg+kr8;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=PCh5v4X2;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GOf1JvuU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gErQOfvd;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf10.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769520959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qGSkFsS5q5/IupBbK/Dkx87ZeTM99oZFQDwExaxRbT4=;
	b=c+l5WbVO0yxagyCfyUShHTrB9aK+5eDjAd6jDs+dJEPUUws5NYlUH1hEq3MT14WcNVphNz
	fM1onafxsL0EZ0h8wym8psWUnSbaM04e1vWRHXfuvZ68QB6iafTaTg7+9ozvCZn6nFJSLt
	b/OcTTSwjWeiujPwDXPSc/K6IYLIMog=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5A4A15BCF1;
	Tue, 27 Jan 2026 13:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769520957; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qGSkFsS5q5/IupBbK/Dkx87ZeTM99oZFQDwExaxRbT4=;
	b=PRSg+kr8tDobgqqofxkpf2pz5ngV66cFavvfUgwA6E70eBXxSf8Hy8YyMWnvn5LIIIfGyK
	QubXsEfyXcpCGds+J5lF27R5fqlEbp0eF+B+mrAsKAuu+ZGWCVigqFenBAWNJFrg9mOwW8
	k4BqiAdJGM+DNA/RGJh8FffG3YCANIg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769520957;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qGSkFsS5q5/IupBbK/Dkx87ZeTM99oZFQDwExaxRbT4=;
	b=PCh5v4X2tujchYfgzDlTWBsha+28mIRfHEhLKPfQ/oK9BLCPxuo++fJthlUOTEQdJ7EyW3
	5Y9txRSZ5ldev+CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769520956; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qGSkFsS5q5/IupBbK/Dkx87ZeTM99oZFQDwExaxRbT4=;
	b=GOf1JvuUCHT4XH2uV+Bw4qHhiZBu9msALMPz/W5gMsTlwzqokhRjEcilEE2NwYcXfxRp9F
	FSS+QO4EKu5Vg5/Wbj2Y9ySu/nmSlJ6eohbVoU5eKj7YvPi+i8kAN6unAfQRME7ho3Zg/G
	PwFE4d8+D6Lrg0tC+vlz9qAUtgtCKAw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769520956;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qGSkFsS5q5/IupBbK/Dkx87ZeTM99oZFQDwExaxRbT4=;
	b=gErQOfvdzgALl1KnFdrGnIKjfyOr+Lt+jOEMLpC/4du29A99B4V/dmeXG7zskbN8Q2p3Pq
	C9Zj4B3C9ng0pLAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E1F713EA61;
	Tue, 27 Jan 2026 13:35:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JIxxNDu/eGmREgAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 27 Jan 2026 13:35:55 +0000
Date: Tue, 27 Jan 2026 14:35:54 +0100
From: Oscar Salvador <osalvador@suse.de>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: muchun.song@linux.dev, david@kernel.org, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hugetlb: increase hugepage reservations when using
 node-specific "hugepages=" cmdline
Message-ID: <aXi_OhpzvSkoJK4R@localhost.localdomain>
References: <20260122035002.79958-1-lizhe.67@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122035002.79958-1-lizhe.67@bytedance.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4A436C0008
X-Stat-Signature: 7bm36rcxsgejgh5fhec9r8m9oabmh8sc
X-HE-Tag: 1769520959-680095
X-HE-Meta: U2FsdGVkX1+FsggFqSLCZc2E+ynJj53He1+LcxXv2iR+BNc97qeWPFyWnOtY6DbXQafBYiGrIrKbnJyxhe5vGr5e8zPXvjDaHahtBL4qPVv8cgzNnEso5gORNhpBGS6MUfw67WZwdvxGdsf9RiXH1FCojAMFRcEA4TVdOjLnZZlOgQYL3qnjskci0/UFQJgH4UtAtDP4oZc3B7nDFPSiVj8tzVV7o8flAMKwLfI0MRQkUhf3xkiN5w0kyANQMfYRHucibPnd6tdIcK3HEnorBXDnoC/Wm1l1dMuKYCYYnZJQ3XssiLldwSBgSbPt5ZXZL7yB7h3pxZksqpY3AacZu72r1+fR22h2432pbwWAbOnfJqVmidzD0qLIWTNNB2jwVYAdvSznYkDYBeU3IOpX34zp9nIj+9NJ0jxmazSskYs+eHraPnrQG6ozo8wKaRwy41sVlK+4k8+Z0p0BZTrV+QOsBc/1UY/RJCvgkBMby+ILKbOIOGLrLLdeVPPpp7Bzx+hymT/nA0e6h8xlbEpQdc2l+1ehP6jO2nAkXDXsKxz1BLnBVdHXJEPINVF63mndtE9ycVtDkXBkg63xvQXxXJZ+3TqHb9VbbJVbRP244dw48uPeqONSNeKLFdn08bVISaIgWjMIxSfr9vKEL0437gRvhpEINhvv+1BoTRqjAYOsGFlyQmGjbkypD9p/RcYuz1r4op2JVe21by9qYYQzV98WX6pl98+TIV9X3B3gZVeCJUlR+Jax0tDH5TgJylNNwDddLTCKeacdvRK/Sg5etScfOdJGxSmeL5UDoMbqzn7pelTMQuLvWRVV4EU296UbCHteXVJOOoewi3eyenN+3rwTTs4XO2Fj7v09R1C38uPMW6QRUcV3f6UrQh+Co53dEOSmP6HYneKbyk+sJy04t8K2lLJfjpvntcF5Uh7JZp2V6dOJRj3hoJya0Rh8+/PxEqK9dtrL8rJ/tXpP2CZ
 uqDS2/zl
 HG2z8tMK5UqK9X7v8YvD2+VgBkoRY9RzdO/5AwQ5G+KF8FQsobhASPumLd7gqZjTjuWlmJMw6qAfG0bPfdmF+PwVGqmOxMJsgfHkABQ2zMNhZhbuwDLDQ17Efn49H/BUwIVYp6bjh2PACZshKyBkRvkrFMb2N6uJWa5lG47dddkDvJD69RquqYwxTxA7GOsYAanrsDMHh95+2o/0M36KfelJ/QXCGJOiBzl0Lmrx9b+qZGgl350On1Nqxmsyn1z3L6Cgl9dh8BTERZsmnYfkdwFsG7U7fnrgxPJ/9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 11:50:02AM +0800, Li Zhe wrote:
> Commit 3dfd02c90037 ("hugetlb: increase number of reserving hugepages
> via cmdline") raised the number of hugepages that can be reserved
> through the boot-time "hugepages=" parameter for the non-node-specific
> case, but left the node-specific form of the same parameter unchanged.
> 
> This patch extends the same optimization to node-specific reservations.
> When HugeTLB vmemmap optimization (HVO) is enabled and a node cannot
> satisfy the requested hugepages, the code first releases ordinary
> struct-page memory of hugepages obtained from the buddy allocator,
> allowing their struct-page memory to be reclaimed and reused for
> additional hugepage reservations on that node.
> 
> This is particularly beneficial for configurations that require
> identical, large per-node hugepage reservations. On a four-node, 384 GB
> x86 VM, the patch raises the attainable 2 MiB hugepage reservation from
> under 374 GB to more than 379 GB.
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>

Acked-by: Oscar Salvador <osalvador@suse.de>


-- 
Oscar Salvador
SUSE Labs

