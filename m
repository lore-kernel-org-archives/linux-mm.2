Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29B8ECD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 22:13:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E4526B0005; Wed, 27 May 2026 18:13:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4954C6B0088; Wed, 27 May 2026 18:13:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AB3C6B008A; Wed, 27 May 2026 18:13:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2C8446B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 18:13:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BAB07A073C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 22:13:37 +0000 (UTC)
X-FDA: 84814602474.25.3BCF32F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id 19C8380008
	for <linux-mm@kvack.org>; Wed, 27 May 2026 22:13:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vnMPwzyX;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779920016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dodOOnd1Ef+RhYMklOu6YQdcoDL3YHcV/9uS/rD7CTY=;
	b=CJAaNnEP6paLrM+BxTW+QMG4Kjj46eJ1y7Ca633K+1uK8LUWllqjqpCTXfMWnywwy9t3cx
	yvm4EVIIDJTNqdp9RejYsYSmpq2zrjzlNtRN+korS+fIo8EIaRSNRClBHSgI+OqUySToUh
	MiIoFXV/Q7jMhxHjyOpbU1bIk+INZOs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vnMPwzyX;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779920016; a=rsa-sha256;
	cv=none;
	b=L3Sy4+bByeRClKrfI1nUhw9UmpTFG/aVHIKvSWrW9QTHgbNHOEJexjspISHjMsY6ZnEh9V
	xnmpBCcT3i7SGwtiChNk4rifndHKy9SudkyxZpWW0doG1bAui1c9aB8soM4YS/dMPSgVkn
	/bjIgyvv7reSu5mudos5c3FK7/xGry0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dodOOnd1Ef+RhYMklOu6YQdcoDL3YHcV/9uS/rD7CTY=; b=vnMPwzyXnO+XywybwKb5KuliVo
	5ehX6LavM9xNXUc8+Uq8M0WIEYnduf7HuuJ0hPd/oAjAOU5Lx8Kq3pq4McOVaGwlrkV6ZxI1PQ9Tb
	3iaBA9kdNaKme+vzOOAat43Uy93oxPXEAdc3EPavWlDRQ99+iSmvZIl6Eb3rCA/U8S3Ci90dJI666
	WxI5xctNB1UnWl2Lzw7KaOWB62Q5TI/HvXzmX7BGqOW5lj03Z8RNfCgoP1Jzbo0BPSVM5uBrJTVwv
	bKDttAhwEqwX6OvyS8QdghV5FI7eODY2VXJx3icD+zbh9ot9Zm1+Eo+pXPbyzMw8mW/p6ljC/l/MO
	E+MWIwMQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSMV9-00000003PNc-3SNN;
	Wed, 27 May 2026 22:13:23 +0000
Date: Wed, 27 May 2026 23:13:23 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: lirongqing <lirongqing@baidu.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/mempool: use static key for boot-time debug enablement
Message-ID: <ahdsgyYYDn6juR_R@casper.infradead.org>
References: <20260527104634.2434-1-lirongqing@baidu.com>
 <4da5d090-8272-7f26-9e83-ea4ab489f1f4@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4da5d090-8272-7f26-9e83-ea4ab489f1f4@gentwo.org>
X-Stat-Signature: njjje7ncpxbeu1myf3w4fmin86or1pdj
X-Rspamd-Queue-Id: 19C8380008
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779920014-963695
X-HE-Meta: U2FsdGVkX19BvDzdsI8kD3rWYM9C/fsiSUjKQTRv6fxL7zRHHK+JzAPHdPwDdmM5PBGRk/wK+5bpQCkdIHlWhdqoj2lkq9KO6Ix+MNoSW/2zOOqzVgINTSjXAQDmv2pK9cfs5FUSGK309cuvsGOxUQHG7cTja6nvtv0B2AuPwsXKcSLy7i1PZjETJxinm/gy7hl1+YyIx4VsZqRZ0hDPB/w74xH7NtR3pXKe/HaCxSVsm/tQ8ryT08Y7U42xhjYvmireVsAwXU5U/3r8/ovBC5QslJSbOMUNlQkvMQGCyuBXH5lCiDwZs5Hwu6veJU5LOWyNygM0ygO+WVYWtnqPC9B48h8q3JEGIyGJJR3nHxUjqCdZYeN5RLM/XYqcwTvlNj+hyBFCZZhEhjN+gQ6YBrFGLb5knQKf5zo9BsCBOFLnGB0XPWUJHeiNHijstskNf39iwEF/M2cSHISaQR0hySob2KkLj9R91EtYpZAgZ/6l7jYrVdwiIUGPnpckh+fP1Mu1T54TgiOPqOs7BYW2hS+cAUy3nGFMPqIMR16xFIPDYuZt1tDk4gp9UZWE3c91eNSc6GB1OjObMlPaFVWsYiGwJuWfN9gsmPv/4lgmTFNfwjGA1xKvXHz2zc57RIEUYmHYDO+AnsqJ3pmdGdsjAd1aLMCvAZfygd9p/ayqYewqftMZJwyExrDyRihppTcztg38DrF/8NYoQseod3XDWpuhgMJYiJUuM/PjPheMhhsxTczX7JgsL7unRJ2aQPrcRYynXALpP6fZbbjSpZc+0CKt7J0PvHJuzvEHLzzObMxSsi8/PfM8tYKeIKnuXTqYjow77TutUkWxUJ2HHTTU9jDIuJN1JauSO9QzJiqUdQs5rdThaYEun+001YaYaXbE75EeuXJgxGE6tn1MKuHn9XrBH5He0mDwibgFZF5Q/TEoL+dYjAR9uPc1I890rXEAeWBLScit+ABW5ZAs9Mo
 Z2iFgEXN
 ba3+glmibGUyxiPR3fynsukZVrI+NuuhudR7loev2E66V1IqBUpsBHCYqE5M7p/yvhJsHHpeaeAHr23+lTclvfQ3KlQZgpMGNFoIDO9vGhh2zoUIHocVTo0RuIVBlYEUIAZ7mqA1OtJ3F5rqlQ0+TYkVJX1QEAWz240tDQBC8nEnbkyBAKwmsbB653hcwOVWA7GZQDIf7XQwzMKl7H0cRPUzvM7a4MHgjB4cxPmhOdVo7/0y50K+F4zG20034XQeHbd1d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 02:29:22PM -0700, Christoph Lameter (Ampere) wrote:
> Oh someone put an #ifdef CONFIG_SLUB_DEBUG_ON in mempool.c. Overloading
> the meaning of SLUB_DEBUG_ON as it is used in slub.c with something else.
> 
> Someone was assuming that SLUB_DEBUG_ON means the same as SLUB_DEBUG?
> 
> Please clean this mess up.

Isn't that what this patch does?

