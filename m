Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC16C106ACFB
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 23:22:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CF376B00A6; Thu, 12 Mar 2026 19:22:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 073736B00A8; Thu, 12 Mar 2026 19:22:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA1576B00AE; Thu, 12 Mar 2026 19:22:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DA2756B00A6
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:22:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 707421C5C6
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 23:22:51 +0000 (UTC)
X-FDA: 84538988142.12.1D567EC
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5E75E4000A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 23:22:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="2ZmOV/Ft";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=j4+wcZMa;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="2ZmOV/Ft";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=j4+wcZMa;
	spf=pass (imf12.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773357769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fCsKOx8ILzNbGLkgMdAcnfyRXidUZJNgid2O7vonu+Q=;
	b=VFNDzTPASZbrmC9DKg2nAaoV/BvboTr57/Ngo3sD6MFEK2V1a2tyNgM7k93Qt10TcEB54u
	Usx3G5XgLsjX+kBwX66LsFgiZxQZdRpeXlxiD+PGlePX+qC5MDwnW8b2CXY9ZSTwnAQBRH
	2Vd8UW25/ssJdHrr4Dq3Ho/ayQVLE+E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="2ZmOV/Ft";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=j4+wcZMa;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="2ZmOV/Ft";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=j4+wcZMa;
	spf=pass (imf12.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773357769; a=rsa-sha256;
	cv=none;
	b=zky85/RtWalTTBgd7QGlJ9gHXXQAwWCGSd+9uvYC7VQ1RJFhfFRExWy7aEM2qOyX9E5Vpl
	+AxEK/t5Whqj9eTTZQ6kIe9vqx2Pnnb2fqLcn6i+OFi4hbLHSekj5qZ0+IPnMHSFVswKGA
	HQnfn4T7yyjUGRRl1t+QNT6FZ+qFJTU=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BD2B55C950;
	Thu, 12 Mar 2026 23:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773357767; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fCsKOx8ILzNbGLkgMdAcnfyRXidUZJNgid2O7vonu+Q=;
	b=2ZmOV/FtjgDxd4cAbv9oZdGXqgggkqIxPllRVrG3xn8RbFGcoBqLxNzpbySiUbRtqlTUt+
	0uMJN+41XORcm2udUywvhp/DzLE9ZXtWSaf+GmOdVBmYZJTGTJp9obtOugOR3w2TOptCDp
	Toj6Ird1QF7R/brqUvE1/UPtRFmaLhw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773357767;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fCsKOx8ILzNbGLkgMdAcnfyRXidUZJNgid2O7vonu+Q=;
	b=j4+wcZMa/q/eN96zYBwEzhrISET+YRMZ3Q3JZ/XYvMXWCDo8zM17gplpTTqNX7xWtsvQ1n
	WMgPzTYl6JBR7nAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773357767; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fCsKOx8ILzNbGLkgMdAcnfyRXidUZJNgid2O7vonu+Q=;
	b=2ZmOV/FtjgDxd4cAbv9oZdGXqgggkqIxPllRVrG3xn8RbFGcoBqLxNzpbySiUbRtqlTUt+
	0uMJN+41XORcm2udUywvhp/DzLE9ZXtWSaf+GmOdVBmYZJTGTJp9obtOugOR3w2TOptCDp
	Toj6Ird1QF7R/brqUvE1/UPtRFmaLhw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773357767;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fCsKOx8ILzNbGLkgMdAcnfyRXidUZJNgid2O7vonu+Q=;
	b=j4+wcZMa/q/eN96zYBwEzhrISET+YRMZ3Q3JZ/XYvMXWCDo8zM17gplpTTqNX7xWtsvQ1n
	WMgPzTYl6JBR7nAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0C71B4020D;
	Thu, 12 Mar 2026 23:22:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IcsrO8ZKs2k6HQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 12 Mar 2026 23:22:46 +0000
Date: Thu, 12 Mar 2026 23:22:45 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josh Law <hlcj1234567@gmail.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Ballance <andrewjballance@gmail.com>, Josh Law <objecting@objecting.org>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] lib/maple_tree: fix potential NULL dereference in
 mas_pop_node()
Message-ID: <i6tmfotangjjtzek5txtvoiav3xrfvwtw6cppooyja5mvywmz6@2c5rnyxqpgu6>
References: <20260312184054.23481-1-objecting@objecting.org>
 <20260312134531.49c1f9171b4b0bc8352e678d@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312134531.49c1f9171b4b0bc8352e678d@linux-foundation.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5E75E4000A
X-Stat-Signature: kzfcmxianootxi7r13uwgnb8cz9p4gj6
X-Rspam-User: 
X-HE-Tag: 1773357769-373735
X-HE-Meta: U2FsdGVkX1/pQoAkWl4+w83PvLpqciFov4s1rSS9f/k/xtx7FIPibZbQMDn55InkDrQKj/kXThhakNfFvHaeSeci/IqqjxQi0brKdeJGql4CpSR88gYxVHqgoPrJSTNm4tsbr/CltTBEqtECDUfxoybBoH1SQhWxZ3J7hZFQyPU4k45X2EZ1ueZkZLNULyN/DeseEum2XrosoM3t4Xu+UpXIoddffjSleewAcZ8HKaGuJxI2gWkfV86IUsi/GKRnaJwQmVrfgSLRk1mh7yrj5yOYXjhbyKyBYdMDI5tRv96fJaqQeLPDcSan59rp+viDS8/WraLoZAKn8TVoolHd9/D1OvcLNfbE0HoBQMGOoaUhak7LvKXM99IXZav8KPVDKo9B8bH1cFP17iDb77qJC6Jh/nDIjzV5WHpLZDv20hA/OLPL+yNcHskoNTcWAyDzNdS0aTSc9qwwkBjknMNYryNI6zqeuEb1WnzYNwyYSfobO82nRJxGDKhKupTy7F5xRkKBNucpOn3R2Mf/tAIi7KmcldwGP8QCVojO78c/kU71XEl/X1SCRcZ1MOl3fn9Zo0pLtQuyWMbLt2DkcEywyglz7Eu75uQv7mFY8Lwsvey+wi/MlVJJTbvJ5zplLKKvi0tXdfDmkt48T2j75plNh3bvED11DG4jnw6cQX5eOoKljZmAAzbodNbkhuEDKNxQo5T87V7LD3gtDX9ePOCQmlTD2/gw6Nrt2GI7zGmIC9c8LJ9GZwXPa+WqHxXjTDBPgk8N51N4bwuljag6EU7ydCmh8XpR7XihpYJ08ZrUvR7cFiTXek9Ud8bGlqOc3LRY5L+n4OKSjl5Wt4YLeCCvBXE58OqoUExoUEu5jKBKY40JWKkR872u90hIvwzS0iNTItm7b5XqwB8Cf7OelN8789o7pD8WXcaiMlSY9+jhITiccteeYKxjNvI5wvwapcRYbT/XVrlhFKAwZktN48U
 fWnCacBW
 4l4uXc+kt6kO8EM2t/o45fDm/5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 01:45:31PM -0700, Andrew Morton wrote:
> On Thu, 12 Mar 2026 18:40:53 +0000 Josh Law <hlcj1234567@gmail.com> wrote:
> 
> > If kmem_cache_alloc_from_sheaf() returns NULL (possible under
> > GFP_NOWAIT pressure), mas_pop_node() falls through to the out label
> > and dereferences the NULL pointer in memset(ret, 0, sizeof(*ret)).
> 
> This is such a glaring bug that I wonder if we're missing something.

According to my local copy of lib/maple_tree.c:

mas_pop_node() - Get a previously allocated maple node from the maple state.

Note the "previously" :) kmem_cache_alloc_from_sheaf() can only fail if you
run out of objects in the sheaf.

So yeah, this "bug" looks bogus.

-- 
Pedro

