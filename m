Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 199ECC5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 23:44:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B7BE6B033E; Wed, 12 Aug 2026 19:44:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 190116B033F; Wed, 12 Aug 2026 19:44:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 057A16B0340; Wed, 12 Aug 2026 19:44:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CD5286B033E
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 19:44:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 58A261204C4
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:44:29 +0000 (UTC)
X-FDA: 85094249058.25.52D36E1
Received: from mta1.migadu.com (out-109.mta1.migadu.com [95.215.58.109])
	by imf29.hostedemail.com (Postfix) with ESMTP id 264FE120003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:44:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V7Au1q1M;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.109 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786578267;
	b=ftej2n0H1+ApuBP0xS0cRXGzR15aaE0OqL2aPLQq5BbaXHu4/3vEoQdWQbpj9ALZGiclyA
	Vz4XL43if94x87LFVB7Tr5A36plaVWeOiK4kCsvW2LXZH0dmHPrOT+GU5AHe/2UwCHmanU
	H0b7P/pHEhYLInQ4qx3pxiAv90vRD80=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V7Au1q1M;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.109 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786578267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/MfDVEZOMEZxR4bNh/b4vpiJYHJ3uTy5PgVi02+bH7U=;
	b=v9y/1qAH0F9a7bTpbM2XlmwA3PcfAv1GxkUaB1hHR684jaAcI3ulk8vtvpJlp/r9OVzytr
	8YKCO5QnXU08zazIV6xx+oeFnV25H4K6B9gdRivSq1wHgeINdiRGyxvHIiVrXeHxyd6qIg
	c6nD8UU6MA/ZPnMlnJ9UuYoTfsVq0cM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=GRGPu0x1sRERIuQs56PTW8nQYd9NgZlk3OlXceQWbKE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786578265; v=1; x=1787183065;
 b=V7Au1q1M522y8KIDAXqAu3KtyfWzd2A2IYxgxXkZPwVPEnBlOOFlRiy2BRPHLE6WeS/cJkgO
 smiZye2sltUNYM69JXanNC58hwcca1b+HXG21ihDSu5ecs5SRDDJf8S76gg919S5ej7BlVE+wHK
 jfKBlhCtrZcR9868IexsKYZU=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff::)
	by smtp.migadu.com with ESMTPS id d0345f5f1396112a;
	Wed, 12 Aug 2026 23:44:25 +0000
X-Migadu-Flow: FLOW_OUT
Date: Wed, 12 Aug 2026 16:44:19 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Harry Yoo <harry@kernel.org>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Guopeng Zhang <zhangguopeng@kylinos.cn>, Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: Re: [PATCH] mm: memcg: fix slab over-accounting for in-object objcg
 metadata
Message-ID: <an0E_lt2_53GBWjt@linux.dev>
References: <20260812124858.73487-1-guopeng.zhang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812124858.73487-1-guopeng.zhang@linux.dev>
X-Rspamd-Queue-Id: 264FE120003
X-Rspam-User: 
X-Stat-Signature: phm9bbnphoqocno38shbo6bq8obreago
X-Rspamd-Server: rspam06
X-HE-Tag: 1786578266-446421
X-HE-Meta: U2FsdGVkX19At0WeHajMZFYq1a8+d410cVHrIFT4KPen6PGSlcNHCcwPkz4bUEPQ1hp8+tYhBXnBUANFwTTXiDVaMwoO/9Y5o0WcqbokwRJUhmALnTRGhgh3CdCSEWIWsc/KfkXS6uzKvE0lf+LgO1rIaOA0tEzFuiI87VavNsolp7YOaa4n5ZpFXeAOI4J1/Uu8jgJR7C1J77aZ3a3RVStZunRZCzMoXqakdaLtwMpIK3agzBCJPRKvKKnuxVPjyFXsJ6+dvoLgvIFy69575XOpP76vCCvf5lBUyjkXzlfbhS+cP7q12zKVbI7ni4ymqXupfvX9HMaHbFJS6jMs1afK440ImTbDJ9AIUuUlH1iHwR+Ccns9zsQLcEcHfivLptJwptKiWaT4IfkB5cCOgx2UH3pb5eVN1gDVf19W+TtnJNZB/b7e6f2zr/8Y24MYkV3KtFcQ0RFeu1t9UqI9lJh+TQF3oiCQOW2Lry6NDePaAYBETWiwgqTogtvTPh1ZmQNwWvRsYh6+D4XlHy/Hhv+j8f0fQrp8ebF34i8Ksa8fhgJEya3NTytmWFlwgW2/zTFVyg+bpERF3GtrMJlcsKiTmjkI4rqtLFuKrJ3V1KCnEg6LUFOzktm5a7seoZpAdiDZ/zmomN3vFxxGlkWjCLQRy7W2sNptavgApEpQ9CnZgPvOMVtR5NHsjgvmFCz2uU8ieEldbr7ksksYHqxBhF8BqECuc2Iqi1dkvbiQxw5k8MnMqUmK8vSH2b+balhaGMW0+JodjZxwp04rYUiuK8n6uMpcRraPLOOtYopB63ddaiyqCZyDSLvrB81UWtrn1tlY8UzG+fDKqZuFyf+C4fbHlL34HJv3Urc2NXyvyqDy8cYrdd2iKpkIUz4mo8BFtVjpDw8TjFvZjfOpOVTuoKqDwelbF7kDZRI7mpOmZqTowvgK8qjuQgOYRuI0V9aMqR12kFPPDNJ71CSk5Tp
 5Og7rfdJ
 pXm7ZHwC/9Q6WgSLo2QRWWJ4ZRpndTR+z4mQ4U5ZAxvGDlogYcDDUaaFIxtRcxNHhhGOjUMZBZh9nXN2//KBh11DVvhhOdfmg5ngRnUI2ebyFLH2WdRMPVksm426R30jPJdSdxo6q/AympDq1nld9rfCqERD94H48OnYgtQdtw3RXzLcWARrCQU8DAfin5N931MHdZvnlSkZMK0BQGyi382Qf32rpJcv8DLMMmXwiT5++YjT6PgTHaGcQCzPAwl8nkt+SpxYZr34OZCeTFqaE9zwqmGTlM8CKKE6sbVv994CHSEtpYazq5DjsM3KasMcU61ovKv+EZqKVRnYoJhaCTEO57XkeaZNH+lSCL3QOxIzvBbY4ZoF4z2xrnYdHR0lUpWf2lDLvOHqeNjT0cz0NJbcFtwuMaRRu/LbGbTvoVPKRW/g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 08:48:58PM +0800, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> obj_full_size() adds the size of an obj_cgroup pointer to s->size to
> account for slabobj_ext storage, which normally resides outside the
> object.
> 
> Since commit a77d6d338685 ("mm/slab: place slabobj_ext metadata in
> unused space within s->size"), slabobj_ext can reside in object padding
> already covered by s->size. The extra charge then accounts for the same
> memory twice.
> 
> The per-slab obj_exts_in_object bit introduced by commit b5bc35ace2c5
> ("mm/slab: replace slab.stride with obj_exts_in_object") identifies this
> layout. Use it to omit the extra charge only for in-object metadata.
> Unlike in-object metadata, slab-leftover and separately allocated metadata
> are not covered by the per-object s->size charge, so retain the existing
> charge for those cases.
> 
> Reported-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> Link: https://lore.kernel.org/all/20260310113804.245647-1-ranxiaokai627@163.com/
> Fixes: a77d6d338685 ("mm/slab: place slabobj_ext metadata in unused space within s->size")
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

This looks good to me but would love to have Harry's comment on it.


