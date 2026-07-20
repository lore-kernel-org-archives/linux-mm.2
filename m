Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53ED4C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 11:00:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9F076B00AD; Mon, 20 Jul 2026 07:00:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E286E6B00AE; Mon, 20 Jul 2026 07:00:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF1546B00AF; Mon, 20 Jul 2026 07:00:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A2B906B00AD
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:00:14 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 28DB540106
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:00:14 +0000 (UTC)
X-FDA: 85008860748.02.61BA3E8
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id EE3B018000B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:00:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf16.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784545211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NLJhAikkeCguc+J74feU8lZligDrHcP9YVTEBH1qpGE=;
	b=alaVSe22oHCXMdfq/T1SBxXfRE+U8RgjV1Mj9566pbQSpBcaA9GRw4UFEtti0jgJ4VQhH4
	cC8rN9KTp8QTJ5LQhO5uZNMCF6JVvpY2x8xTQKK+bxGSmecGgaTYVAVtZtg9L2hHfdgm7c
	jxsr/HjDos254v98xuNyn+8ITIId01g=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf16.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784545211;
	b=xvaDRRPIlcpglYf42gPMqGgbMEDBlJ2MnBWp730u5X4rtQbhPKqibLDj69VRRdMchU8xzT
	2qqk8DzXAq0Gi9AMzow8VtnlVX/j63/8Vu+YkmiIKEpUbxZbTiAXidaZpWHWz8FUah8cJf
	+YvTkaMMwLsAcaDB9xgui4HEIYaKurQ=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4h3cx26VQBz5BNS0;
	Mon, 20 Jul 2026 19:00:06 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl2.zte.com.cn with SMTP id 66KAxt3X041987;
	Mon, 20 Jul 2026 18:59:55 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 20 Jul 2026 18:59:57 +0800 (CST)
X-Zmail-TransId: 2afa6a5dffadbb6-6dccf
X-Mailer: Zmail v1.0
Message-ID: <202607201859578472ibnQPUU1fHj7f_I-izfJ@zte.com.cn>
In-Reply-To: <33a1cb67-8d23-4b51-b4d8-9e95e8de00c7@kernel.org>
References: 20260720164108387NvWvBxxTPdY-K3EVodBZZ@zte.com.cn,33a1cb67-8d23-4b51-b4d8-9e95e8de00c7@kernel.org
Date: Mon, 20 Jul 2026 18:59:57 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <harry@kernel.org>
Cc: <hao.li@linux.dev>, <vbabka@kernel.org>, <akpm@linux-foundation.org>,
        <cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <zhang.run@zte.com.cn>, <cai.qu@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gbW0vc2x1YjogcHJldmVudCBwZm1lbWFsbG9jIG9iamVjdHMgZnJvbSBlbnRlcmluZyB0aGUgYmFybg==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 66KAxt3X041987
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Mon, 20 Jul 2026 19:00:06 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A5DFFB6.000/4h3cx26VQBz5BNS0
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EE3B018000B
X-Rspam-User: 
X-Stat-Signature: 5j4tcrug1z78ok56eaodk3srz85gehb8
X-HE-Tag: 1784545210-675546
X-HE-Meta: U2FsdGVkX19ulULvys4bYUf495FDYxQSPqBb7tNeL2Z9rtaCEg9dy/pMJRG0yNe745+TbT411I+rbOQrnqj/TkAaBvHVlPN8WuU7lvghUGdZAgExvj5osaLIsC5sYQpjZs/j1pLV2FbOtcInYr3TynsLS19Emcv0cOT8wS2cbSeB8ZmtNiEq3P32xsxToZ4V+GhJzw0getSMUdjwU6nJ27l1+e7hTQHkKgPjm3fpbgW7WsTLZJ4yZzoMO9dgfpgF7DTfw1vlXxicR8HQGogmfDJ0TeTKe9Rgo9pN1l41aQgOPJV73/s3bcUBf9dcDOW34GpBGg0okOzf36EjuCVMwo9amKYL/xA2P62Z3sdIeFAcNWGTpTkHZoj0Fk4r4jK4SRHwZPMqVOmBj5zl+1R0oXYyeRdruUWGisrh9AvB4cvkCDbC8+oj2FfZuiri22jUFIJirs8lm9QbnOb8zfEt6Bkt7ymqywmRJGMwf06rkllf5N2JUPnj9/1JivSopKF3Lg3iHDiI/XMeUq7F/qAMHqWOIy87GQfc368W7d25boql2FnTtQHyoK+Q61fjLASJHilG8B+lTPwFi5ZxiQBxAxvVcBUolggcmqUCuZlQyqjVTwp8OyVCz8+Ko6LP8b442kZp0D1TegJIvb0MQm0NJq1qNMl46JD7vjPMpnEwDrXWd18nzI2vlELN6TXMl2aNKPhk/yBymG07s59PwCwgV8UJe9LzgjGIB1hB7roU8rAYYPq024mndxInoVoA5w6s7/K5VM0UkVsN/J8qIH3rBGO6pM+uf7SPI2JSRjxNRYweJxijHe9Pc6UqUAlpJMzvaQecnLibjc+bU4T8TM9rlRNWuAq4CerNEPYVo/1GJkbJQVNYLfupP7nURiZOS4lNU3EWc+IIczaKyIIWuH3ZRUH2g2Rfa9d7WzdXdInPfMWwZsfR2Vih5SETWqTDkHy9boKfvhIRaEPD7nVyZFh
 LiJCZoRo
 vPDJ4nCiRpmV+yxfghHtRtosjVDQ8c87Ho1zrp2pbAzRaw4NisD6WxhGhh/0onWT9mC/Fp1dEMTB2pY7HB2o7zpCXJFczLxHVKBHdEhKV5P/wXMCyGVLSzwYOk6fZwcWNcSz5YV3QPrMFLqaytRj17KgMA+rnQjFCgrq+xetAKGLZxA6e5NHZk9jNT1iIuQ/p1cZxiHU9dzvKCaFQJXgfjgEfDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Harry wrote:
> On 7/20/26 5:41 PM, hu.shengming@zte.com.cn wrote:
> > Hao wrote:
> >> On Sun, Jul 19, 2026 at 11:37:01AM +0800, hu.shengming@zte.com.cn wrote:
> >>> From: Shengming Hu <hu.shengming@zte.com.cn>
> >>>
> >>> kmem_cache_return_sheaf() may refill a partially consumed sheaf before
> >>> placing it in the barn. Without an explicit restriction, this refill may
> >>> draw objects from pfmemalloc slabs and consume emergency reserves.
> >>>
> >>> Add __GFP_NOMEMALLOC so returned sheaves are refilled only from normal
> >>> memory. If that fails, flush and free the sheaf instead.
> >>>
> >>> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> >>> ---
> >>>  mm/slub.c | 2 +-
> >>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>
> >>> diff --git a/mm/slub.c b/mm/slub.c
> >>> index 53b4976d3831..34f17ecbde87 100644
> >>> --- a/mm/slub.c
> >>> +++ b/mm/slub.c
> >>> @@ -5123,7 +5123,7 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
> >>>       * simply flush and free it.
> >>>       */
> >>>      if (!barn || data_race(barn->nr_full) >= MAX_FULL_SHEAVES ||
> >>> -        refill_sheaf(s, sheaf, gfp)) {
> >>> +        refill_sheaf(s, sheaf, gfp | __GFP_NOMEMALLOC)) {
> >>
> >> maybe we can add __GFP_NOWARN as this is just an refilling attempt?
> >> refilling failure could be acceptable.
> 
> Adding __GFP_NOMEMALLOC | __GFP_NOWARN makes sense to me.
> Analogous to __pcs_replace_empty_main().
> 
> We don't really put pfmemalloc sheaves back to the barn but as you
> pointed out kmem_cache_return_sheaf() could fill the non-pfmemalloc
> sheaf with objects from pfmemalloc slabs.
> 

Thanks for confirming this.

> > Thanks for the review!
> > 
> > Good suggestion. Since refilling the sheaf is only a best-effort attempt
> > and failure is acceptable here, adding __GFP_NOWARN makes sense.
> >
> > After taking another look, maybe we should also clear __GFP_NOFAIL if
> > it is present in the caller-provided GFP flags? Otherwise, the allocation
> > could retry indefinitely, which may not be appropriate for this optional
> > refill path.
> 
> Hmm, you might argue that it's not worth trying to refill the whole
> sheaf w/ __GFP_NOFAIL in refill_sheaf() if e.g.) that end up reclaiming
> more than one page under high memory pressure. (Just like how we clear
> __GFP_NOFAIL when allocating high-order sheaves).
> 
> But that should not be part of this patch at least.

Agreed. I will keep this patch focused on preventing the refill from
using pfmemalloc reserves and update it to use:

gfp | __GFP_NOMEMALLOC | __GFP_NOWARN

The handling of __GFP_NOFAIL in refill_sheaf() is a broader issue and
can be considered separately.

Thanks for the clarification!

--
With Best Regards,
Shengming

