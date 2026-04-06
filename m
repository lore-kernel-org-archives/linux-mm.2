Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C5D0EF4EA4
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 08:28:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CE776B0088; Mon,  6 Apr 2026 04:28:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27F256B0089; Mon,  6 Apr 2026 04:28:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16DB16B008A; Mon,  6 Apr 2026 04:28:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 08BA46B0088
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 04:28:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AA3211A0333
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 08:28:22 +0000 (UTC)
X-FDA: 84627454044.19.413EFE8
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 866691C0009
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 08:28:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Ub7t4q+6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=r+MergYi;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Ub7t4q+6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=r+MergYi;
	spf=pass (imf20.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775464100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v8Mt7rFXT5oAxL2iQ7KvzpaNx1Zy8Z1vBa8E6u9Iymo=;
	b=xKfa9Or4Y53t9djQKeC9N+mgsb//DepNG+537YjC6t+xaXL/KicIRAPqF8qrBOeGbYDFeq
	Py0d78YW3buNlDkBgTZA2t6WWv6MtfwgDRXiVM85CxLFLO1jzop7w+kYasIqPeREHcJ9VI
	XgGeXMmm5KcNUDBaVBpRUtbrT7iDjeA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775464100; a=rsa-sha256;
	cv=none;
	b=7Fs/7OjF2H82JVydfzOZzgRfHDdRVnQqcmH5c+hCIm3ziJ2EuFpzDGrEOgsiN+XkoOk+Ft
	jHXldxIDJEKKeSlMZy7mzenWQqUCfTfvSorr0Nj8OUxTTTlv/XIFUBwrkvXq0qd9CKKehS
	Dw2V8uBMsRfMpZRMZl1vV8gDh1zJDkk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Ub7t4q+6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=r+MergYi;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Ub7t4q+6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=r+MergYi;
	spf=pass (imf20.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8628D5BD43;
	Mon,  6 Apr 2026 08:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775464098; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v8Mt7rFXT5oAxL2iQ7KvzpaNx1Zy8Z1vBa8E6u9Iymo=;
	b=Ub7t4q+6zkXOd1Vw9OvvdWhI60A9ZbRpH6vVCONIrfq6jjwqMJNRJHu3huHvHifHAcLWwl
	AmaB5Vrhi0YJ8EjwXHzFIoR+vlU9iT142OQaf3nML3rkvsoNuMdXSb4/aKOcob8gR214wy
	W7fB5gx9H58T2OjpuIYPmLrjtTj+AGw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775464098;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v8Mt7rFXT5oAxL2iQ7KvzpaNx1Zy8Z1vBa8E6u9Iymo=;
	b=r+MergYirw+ndyC+oUZFBsMyCGe2NLnwl8vBcCQbHZTKlsKhz49ThuHFUelqgZY7Uf7vRj
	lEh3PzDBTDMdiHBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775464098; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v8Mt7rFXT5oAxL2iQ7KvzpaNx1Zy8Z1vBa8E6u9Iymo=;
	b=Ub7t4q+6zkXOd1Vw9OvvdWhI60A9ZbRpH6vVCONIrfq6jjwqMJNRJHu3huHvHifHAcLWwl
	AmaB5Vrhi0YJ8EjwXHzFIoR+vlU9iT142OQaf3nML3rkvsoNuMdXSb4/aKOcob8gR214wy
	W7fB5gx9H58T2OjpuIYPmLrjtTj+AGw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775464098;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v8Mt7rFXT5oAxL2iQ7KvzpaNx1Zy8Z1vBa8E6u9Iymo=;
	b=r+MergYirw+ndyC+oUZFBsMyCGe2NLnwl8vBcCQbHZTKlsKhz49ThuHFUelqgZY7Uf7vRj
	lEh3PzDBTDMdiHBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BCDBF4A0B0;
	Mon,  6 Apr 2026 08:28:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qiPBKqFu02lZGgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 06 Apr 2026 08:28:17 +0000
Date: Mon, 6 Apr 2026 09:28:15 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, David Hildenbrand <david@kernel.org>, 
	Dev Jain <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>, jhladky@redhat.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] mm/mprotect: special-case small folios when
 applying write permissions
Message-ID: <udewn6uzvw6rwohicw4bhgwyyymx6tqe3mgmmyih74e32n6kwr@6a5bp3q3eud4>
References: <20260402141628.3367596-1-pfalcato@suse.de>
 <20260402141628.3367596-3-pfalcato@suse.de>
 <3rmcbafb3pwq6endpfpgh3kzygolhvpal2xwg5sgq4pw3toikf@t3jx5uorfzxs>
 <20260402112959.e8f079444a8c15086f5f578c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260402112959.e8f079444a8c15086f5f578c@linux-foundation.org>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 866691C0009
X-Stat-Signature: 37d13ny4f9ftdho9wqtt9j88jzzony5t
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775464100-748128
X-HE-Meta: U2FsdGVkX1+LS49mIJDQDRlxojnEeuGAU6QpPeXV7LlxaQ0yVqS38UjPfh/FrOv8Q4UJWjWgK9dYMy9mKRm59hJhnmPuEFCrs+qm4ixnll6WZYbPR3xgZuW1Os0GfEcU1Wj7E5Ub481qhr9ZY1FiOoVosPLIPoscWdyE3/7spPfsCpniSoN3QVOuX+49Oa2uN7OuN8ZVqxvcbJuQFjiRGQVKRPVGEINfS9E4KJBt0PrtSlAvG2g/2g/472/1Ngpk3HK4oOaJVJzmJbFIMH4fHmxbUKUHDfAcDeV2kaiyqpEUAW9b7b9Pi8yH27TvYE9iubYN+YdjmHGE7nGbS1eVl0o1nSYLMuFiV8Lh7xPIWGw/vLS62ckad73BlIgDLiFkBuJaiwePmMelKYLhh7wrJNeSQTV96EvPI1iAHrWnKX6543i4LMH16NyjwDuOl/mpHtkpnOekPYJV1VYP8ktwXdDcAoCTJOMu9UChw85zsPxyvpbcfiIzF9NEZNmIf0ZnrIT4WOl3gRth7SsdwuHAQIFy37Wdw3vI0kGw2xweILeIBCamVkmEsmGr5f6IBrDWCJCUM2hJGQnol2hPpRqjgbKChi5QUGP2nBnfDHldW90uyrU/MAYaPJTJEdzZt2Ej9jyCDEIp2KHjPrW7wziFMnjbEjyUy19t9STu0nlWUkZH+TDL2DOBNV9a4CwtYpReiKWnxaDsLlG+4l0c746SpOsBRNjwcyShk40fGmwJdKCXSIX0wQ4nE/GZirxvbO8zjjhAN3zEgDVz8yP9WTMUKETrWpMCNpdcdBX2oKk6t8tMZZE9SKaS+DfhJyp7q4HlFuTDCtS9eI+IIF8G5ELBFm99MC7QCs1+sTmpK7LrIQV64vNlSPid9PWGe8k5L+vt3X76Iv+nLH1ClT1C7RknhWcbLfVebcf3zDvebOipiaeqPW4uy41K7zhHjWiKYWb0IIJmpeRJv2j+NAVBWfG
 ehCKEzx6
 Jt3DKd652mLolPFssMv9ZmoKqGXhLiX6dupdF2e3BHw3VnDS6d9cbS9Q2CIit7BH5/BOWx3JzBftT4fwTtay/GbmJ0C1OgrFe+74iP6QkF5Nf+uwneVwhsU8GL+vzz+YZWWU3whaB6TPYeicBwvkiUNqcuwkmbR3VQ74cWmaELkKYRt75RSAmF0KP1b4rD3NWduckJMysC1WdskT4FcKFk1OEZjclBekWIux/hnTyzvOGIURm0Pe2nEh+iHTE9QlbTFzH6rAWRO3oCMuYXHyRn6P8nOQQvVM4/hR2WyQWRCosxcE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02, 2026 at 11:29:59AM -0700, Andrew Morton wrote:
> On Thu, 2 Apr 2026 15:21:26 +0100 Pedro Falcato <pfalcato@suse.de> wrote:
> 
> > Ugh, of course right after sending I notice a small problem.
> > Andrew, can you patch up the commit title to something like:
> > "mm/mprotect: special-case small folios when applying permissions"
> > (or protections, whatever sounds best)
> 
> np.  After scratching my head over the difference and not being able to
> discern any, I went with "mm/mprotect: special-case small folios when
> applying permissions"

SGTM, thanks!

-- 
Pedro

