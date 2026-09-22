Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AD54C982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 09:58:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70B596B009F; Tue, 22 Sep 2026 05:58:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BC8D6B00A1; Tue, 22 Sep 2026 05:58:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D44D6B00A2; Tue, 22 Sep 2026 05:58:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3B58E6B009F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:58:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AF27B1A03FD
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:58:45 +0000 (UTC)
X-FDA: 85240949010.15.1CCE38B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id A6DE420002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:58:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LiZEolQL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YTCIb160;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Dse2xfk9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=5ej2gdRk;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790071123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4URFwrM0sI0j5Ml44Xiz56jlMa8XLSjTXuYmxFnBgOw=;
	b=4FJtfKxwdiGAPWeV67Zpn/GEw5cJIgIzsOOf7ZI6nHVO2ldcvFn7ZfTjLMw1h43zgMZmSs
	HYpsCS9h2IL/rMrXPtj+o15RA88RSuEwcxU0n7rNcCLBUfFJmHb8rZ9yP+nwJLIkXk7xpR
	Uuu1rPWmWkSNgxjUSml81ymW0j3opF8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790071123;
	b=AaOdlURmT+M3vuzjkMKD3jRgGm50nZJknWXcxY1pXF4jY+B5QBykJzirWR6lEfHJ66EmxW
	khUbuEm/etAozc3UcLv4UALtts6NE0/BpRkoRYZ87dr986/wVLAd+W1fF8oQ3QWJ8ttbbC
	4+tSYXyt72ELVpo/oGOY2VEeGaNgG38=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LiZEolQL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YTCIb160;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Dse2xfk9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=5ej2gdRk;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E23F41F8B9;
	Tue, 22 Sep 2026 09:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790071118; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4URFwrM0sI0j5Ml44Xiz56jlMa8XLSjTXuYmxFnBgOw=;
	b=LiZEolQLtrOcnCpKNhtTGFVrWufQc0pBzKwAnq8xgsyHtt7FOTAXPaGMzM2B/JNZSCQTkP
	5qfTeqjvY5gtkYNBndsHUXbuVY2JO236TnFlQWs55eJ8IEw1eYvcqTq1xjKJBCZ4UX+YTA
	sJuczxH3Rovjnb6cpJGa0ZwWvfJOJxU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790071118;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4URFwrM0sI0j5Ml44Xiz56jlMa8XLSjTXuYmxFnBgOw=;
	b=YTCIb160AgoMyuaZDpwuiYTv1e3GB6uMNI3lb6iPSY56aTD87HB360Q467sPor9jhfSTSP
	XAq/xJqeWkRW0WAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790071113; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4URFwrM0sI0j5Ml44Xiz56jlMa8XLSjTXuYmxFnBgOw=;
	b=Dse2xfk9rYhsNzWipCoS1JcIReryX19OOYSEO/y6U6h2/Th6M27X1kd3BZhUtd0bGx7baP
	UP9EmCy/KL78BGJ5wf2ePGumoYg4w5Paa0AiWxasn1OWy8L39PUyEjwIptrg2VB5Vlwdh/
	xL4WP2Fe5+ktc2rbQdg+CmKsKBELHGo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790071113;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4URFwrM0sI0j5Ml44Xiz56jlMa8XLSjTXuYmxFnBgOw=;
	b=5ej2gdRkyDcZftLUT6SaJNLl6a+lu/u772HFMDHv4wdhUy35JgSfKA/2YzV4rMORb7JPRE
	NuaXw1RHmy24dMCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0640E136D9;
	Tue, 22 Sep 2026 09:58:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id knt0I0dRsmrVBwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 22 Sep 2026 09:58:31 +0000
Date: Tue, 22 Sep 2026 10:58:25 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	Kuniyuki Iwashima <kuniyu@google.com>, linux-hardening@vger.kernel.org, 
	Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jason Xing <kerneljasonxing@gmail.com>, =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>, 
	Jiayuan Chen <jiayuan.chen@linux.dev>, Willem de Bruijn <willemb@google.com>, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4 1/7] mm/slab: Mark the kmem_buckets_create() context
 as a Context: section
Message-ID: <arJRHFs-r8hkTLhx@pedro-suse.tail5790ac.ts.net>
References: <20260921075811.too.775-kees@kernel.org>
 <20260921075820.1718334-1-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921075820.1718334-1-kees@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A6DE420002
X-Stat-Signature: ghbrfpkjqtzdyqxq79uwk6rsmuxpcpe1
X-Rspam-User: 
X-HE-Tag: 1790071123-780592
X-HE-Meta: U2FsdGVkX1+tTx7Llxl26O/yGHs5XlN1yD9Orhg3UuzMimM1xHQ2XsmiIYZlSFEUCQr4TF7/hZkSBZfXvdLxyvAo9HSWsIuZYa/sLdtbBOHVvZUbJ//xiOny1IETBrkd71MRTcb+2ZH8FafmhjdtM6wW0cHzqHDsvLzdEN8MrswwEuZCgqmUXGQZLHiPQcUnZtkHL1uyK66TBpajU3oCATeX4pZRONyLdl4dO6Yc6mblTed0mNSxQeGtcrDIEfJIWgz0rA6fsZowx4pYgXTtn8jSgCmdYA8V2k0B8O4+0ajqHkOfaf/GwuS7fkEA/NI6tnschu8PBSkzatIUTQBbV+fZ2g4qxyeUQxVRGE8eCkWclfzsEueyRxPIMuEHBNGdYH14049kGG98oWnygz48Q+jGDyMkXPJChlWh2jaqx+hQEpCO2yWD7e7rPUg1rJk0maZKvBSQWxCk6fDskSw2IB9gI0X0WA6sqakQxXpekMRQTFMQE1DIoRm9z3u4u+djxe052ClT5P00Rlhv7mlY/kb6M44F4kHZmYMNmu0E1YpIy+GH8ZXS1dQi5qLEX0NbN8lNVoiEiPd+kRUHKAZoFAAIJpyX+ss4U7ZZMjazupVTNaDEpaZb7q9AVy1LWdb12Fz5m/IFmSH+S+i18mH429Y0fgz2zWoNr8iYiVRVRl0rGmybUUzlqRdQgN1gEvrtFIH0pc8W52fA2bIUP9J+yFZlY5FLD6LFLK26OEg5syVwcZFwtVsp/Dim/O0DrEF9K1muPhRenKzILGCof1fI+AEqI9OeEzO3ztzjHu1PzXbyXBOcOkfXrHUBJTZhuBVp1V+xuXxzgP583af4HlJAfPO27QpUzr4RkdxA+OBJ0exXQT6n1SFGbivIzzOdXyu97NzDtVZv2WQygdI6tX1S1Deuy9AqoeXqsRGtsEP0fayYa65o3zu+nFD0Dv/uZ06K0F+5Qipv4e0yU6ISnpd
 SDX78Zbr
 yMzQ1nDPXT9xx8rM4qr0+lojtdKEYtyc7SOcvFTfoUCzbX0oVHpNcs7mIsOpZDqi/+sERQuSbyCT9r8GuTW2AMKAueOpLIZwLPbRYMnq+KuSTYc3x7o4OJa9OuH5ey7hkoXeRFCEmisAMRJuP4lbMOtfrcYQQykpNM+O6ApjQXKxjMng1Pt326tCavIDX89WfpQ8idRK+f3g7v2QpkMZagxz8LsFLR32YP9aOtIJt8jQCsAm8CiOYsHCb1NI4oZNU9zg7pW3Gbp8dD+G7/CWOD8jQjeh4CQkaXxMf/mFnrtBQhSFRJhnt2q27yXnaIUDtZ8880qPsK1jmoL0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 12:58:12AM -0700, Kees Cook wrote:
> kmem_buckets_create() had the same sentence about calling context as
> kmem_cache_create(), but lacked the "Context:" prefix, so kernel-doc
> rendered in the body instead of as a "context" section.
> 
> Give it the missing prefix. Additionally fix the "a interrupt" typo
> __kmem_cache_create_args() had.
> 
> Fixes: b32801d1255be ("mm/slab: Introduce kmem_buckets_create() and family")
> Assisted-by: LLM
> Signed-off-by: Kees Cook <kees@kernel.org>

Acked-by: Pedro Falcato <pfalcato@suse.de> 

-- 
Pedro

