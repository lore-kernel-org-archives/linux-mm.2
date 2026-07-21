Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80E8FC44520
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 00:33:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10C896B007B; Mon, 20 Jul 2026 20:33:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BD096B008A; Mon, 20 Jul 2026 20:33:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F17E36B008C; Mon, 20 Jul 2026 20:33:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C35C96B007B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 20:33:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1F722C0356
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 00:33:26 +0000 (UTC)
X-FDA: 85010910012.29.68F3802
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf15.hostedemail.com (Postfix) with ESMTP id 66BFEA0003
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 00:33:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of hu.shengming@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784594004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EPDPo1L192f9P/w0loxq2ykIdwJrk8qyXie6h3kBK8A=;
	b=LGHWUlhJgE3nDXu7vLF9XvM5gRWniXmflFQ7yfijQD+96Fsi/QlOzg/DKCxuIgCd3ITRP6
	LBVjiKgoXq/svjMOi12jBsj1Rnrk3HasUyBcON6UQZ+pIx5pFUbxaDwFBh++c3wJHr2gIH
	zBjwRVGbqr8spYvMcHfKywxXxXMgADY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784594004;
	b=x8P3TRzGn7anTKvD740P5Umk9TiN51wPlE1twrtmm0VVqMHDYY4vmLysHr+/S6TZ7tyYF2
	fB6SZoQr6cL/MIV1dePhw6h2bM4tPitd/1lo+5JpMoMIr/C3br+Y7MOO2hYPSzI7Er6a+s
	5UoAdTm8uOYn1WwrKLS511IwXM7RFRI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of hu.shengming@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4h3yzD6YYwz5B14p;
	Tue, 21 Jul 2026 08:33:12 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 66L0XBik020499;
	Tue, 21 Jul 2026 08:33:11 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 21 Jul 2026 08:33:12 +0800 (CST)
X-Zmail-TransId: 2afb6a5ebe48d09-73b1f
X-Mailer: Zmail v1.0
Message-ID: <20260721083312105DoEsp23e1aJM-hxh_CQ7s@zte.com.cn>
In-Reply-To: <32ffd484-6fb4-418e-b30a-7e2344dfe35f@kernel.org>
References: 20260720211127124sYtTNbvsxCXN9_pDh-pwt@zte.com.cn,32ffd484-6fb4-418e-b30a-7e2344dfe35f@kernel.org
Date: Tue, 21 Jul 2026 08:33:12 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <harry@kernel.org>
Cc: <vbabka@kernel.org>, <akpm@linux-foundation.org>, <hao.li@linux.dev>,
        <cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <zhang.run@zte.com.cn>, <cai.qu@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2Ml0gbW0vc2x1YjogcHJldmVudCBwZm1lbWFsbG9jIG9iamVjdHMgZnJvbSBlbnRlcmluZyB0aGUgYmFybg==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 66L0XBik020499
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Tue, 21 Jul 2026 08:33:12 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A5EBE48.001/4h3yzD6YYwz5B14p
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 66BFEA0003
X-Stat-Signature: hj1xjzopnn5x7ygkqckyt8gi4kymjik7
X-Rspam-User: 
X-HE-Tag: 1784594003-952442
X-HE-Meta: U2FsdGVkX18EOyMMZ0xxS5iSq3YpHkrrNVFAevjZuXk6sLkfaUHXOJ8iGVdeC/Gv+JQVAjI0RQhtVAb3X1qVRNKPYN5JmiTKjVi4BJotYV+p+QJjbrFITQvwHhDxzBxMlWajdastrGjh54EgAclnQr1WbNflF8cwI917AcwOU2mKo9VxqFb4vANtFOPkC0apal0IOtruUT+mdbwsHnBZKh/vwkA2BYAOi0/PdpfEmko/ONpurFJTGMUmEbxp2R0Xe6QliwJYxPhSyI2tLX3Tu9TugnPsHa+0mMSRSPTay94qUPks1gyPmpuFzn3Twiw6VrCeJcSIvzjf7EXywBkGKiwCTOwCpyOos1mn9EPHmpomOwKVkiDtzhyW8dk+zge3/fUQKbKIK24ECIws5qOkhFwm8m6JvxFtF/oWdIVLYr4V3UR3FMObxeYx37wX3R2kyz2mvDameWoVlUuKda8nDp71gmF1QM1k8lNuEJQj7y0eiKkDLMJcJ3D53hQ3GGjOV0chaiz6j3GUe9+mzXh8/jc36H6Y+3zg5tYJzqXuaR/7PUXq5AWclxlvWMOGKzb/NYxcbUIw9wRxsZTML4ais9Zk/bY7mxLFBNVRKqkTUxflR4QuN9gLdvgXuaFEayBx4/9QvOqR3Sb1mBRW12QNqPGLqReOXu6lT4pHYVzXcGGpsqIZPtqqQK3WqQdT8EYgfJSyVe29zztjxnVVjz8dTPhtqJKmS+jHVyH1oPJi+mk4dkZ56zWA/HpKsa2YcV8VQrDWyIC/B727T3GQK28D/WrlCCz/zkDaJU/RymJroVtZK+BooC7vtwXfQQauIXAuCMhlS3HGMJGPiKg+h4LZTm3tPOosEwRO6Mge+i1SbpXxksaFs5Qh9e680t3FBA8+YNxJBbqkJhANdM8pSfPCLTdcCmnV29FE6YTMNAKo/gFCKJWcHh82EvGwKdbcuhD9jXpIHAOfV6LoLL3A+iS
 Gp1VTgFz
 WmNAwPVM+RnTRxMQ1//PjZknS2Z1am+tLmRBJ+AdHlBRqn1TJbhODUEfeyyBipu2vCteY1o3CFab/kae586BR6cO89wfdUlYG8dKtLbJf90XBSyxBsb2j5KelK9KELLyy1uhGmY4yCf1VZfXd6VXGkLufRMvj/R6orqQOouwGA9htdfrFGfaBe5dbtJDPvVqECDr21Lh/pQ9gmpyWTAlwlg7623Za7Y6Az05QshQqkJCDvNIJdt/Cwz+miqPcPsYq5mWxb6L9y4w56Oq/I/4AJXCPAI2lu9LOr9QSZvgcIEqQkDo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Harry wrote:
> On 7/20/26 10:11 PM, hu.shengming@zte.com.cn wrote:
> > From: Shengming Hu <hu.shengming@zte.com.cn>
> > 
> > kmem_cache_return_sheaf() may refill a partially consumed sheaf before
> > placing it in the barn. Without an explicit restriction, this refill may
> > draw objects from pfmemalloc slabs and consume emergency reserves.
> > 
> > Add __GFP_NOMEMALLOC so that returned sheaves are refilled only from
> > normal memory. Also add __GFP_NOWARN, as suggested by Hao Li, because this
> 
> normal memory -> non-pfmemalloc slabs?
> 

Thanks, “non-pfmemalloc slabs” is indeed more precise. I’ll update it.

> > refill is a best-effort attempt and failure is acceptable. If the refill
> > fails, flush and free the sheaf instead.
> >
> > Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> > ---
> 
> Overall looks good to me.
> 
> Probably worth adding Fixes: and Cc: stable to make processes' life
> slightly easier under low memory situations?
> 
> Given that the API is not widely used yet I'm not sure how bad it would
> be in practice, but the fix is quite simple.
> 

I’ll also add the Fixes: tag and Cc: stable in v3.

--
With Best Regards,
Shengming

