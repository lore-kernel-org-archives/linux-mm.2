Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B8A4E9904A
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 08:06:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEE2E6B0095; Fri, 10 Apr 2026 04:06:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC5716B0096; Fri, 10 Apr 2026 04:06:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C02096B0098; Fri, 10 Apr 2026 04:06:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B1A336B0095
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 04:06:18 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5BB2058DB3
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:06:18 +0000 (UTC)
X-FDA: 84641913636.01.FC2581F
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf01.hostedemail.com (Postfix) with ESMTP id A4B5F40012
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:06:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775808376; a=rsa-sha256;
	cv=none;
	b=sX+uc9jN/RjyUMiDPs8lXAiVnS/B538/psHyiMYAVLi+JehvZwZY/4q0Jji1qZbTUSwFiV
	9sBtHt5cFJUettYdG9V1+d0SgxESwH7C0+c66ZVS+Naga8BIwNPtZcLGEhQ5qeKor4I+Kf
	p+vgleJbte6n7LkpY9hv2djF4nisfoY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775808376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YzVtlWCcNTzwPS/bPanybBB6HXFKzbQfsYjvWYFgV6k=;
	b=F4wMQicX/M8OVVzV0m2/nkgrp6gjuUSeB1p00HnsjXoAxpVaT63eeEwqdiwzFNGJ5LsATK
	xgiRTuSLhXNXESJoT7uuQ61IDyQOyXUIEJtMK2CIPlcRRKrTJYml/nQ7NaL+9qlFBQsFqx
	CVd3KGcNkQpmHQeoozeLMR1nFI5cxy8=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4fsTs00bqsz7Qxs1;
	Fri, 10 Apr 2026 16:06:12 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 63A85wU2099436;
	Fri, 10 Apr 2026 16:05:58 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 10 Apr 2026 16:06:00 +0800 (CST)
X-Zmail-TransId: 2afb69d8af68969-d4d27
X-Mailer: Zmail v1.0
Message-ID: <20260410160600883wV0ynx9z59eSt4_lOUFfK@zte.com.cn>
In-Reply-To: <a2d43c08-984e-4ccf-9faf-abefe0f931b0@kernel.org>
References: 20260409185610930gKQqJsFs5KoTU4S8MrflI@zte.com.cn,d473917c-468b-46d0-adfd-b8a1d075f8b2@kernel.org,a2d43c08-984e-4ccf-9faf-abefe0f931b0@kernel.org
Date: Fri, 10 Apr 2026 16:06:00 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <david@kernel.org>
Cc: <shr@devkernel.io>, <ljs@kernel.org>, <hughd@google.com>,
        <akpm@linux-foundation.org>, <chengming.zhou@linux.dev>,
        <wang.yaxin@zte.com.cn>, <michel@lespinasse.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2MyAyLzJdIGtzbTogT3B0aW1pemUgcm1hcF93YWxrX2tzbSBieSBwYXNzaW5nIGEgc3VpdGFibGUgYWRkcmVzcyByYW5nZQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 63A85wU2099436
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Fri, 10 Apr 2026 16:06:12 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69D8AF74.000/4fsTs00bqsz7Qxs1
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A4B5F40012
X-Stat-Signature: 4f6uc4bjz8oyqj7z68j6sawnuodp9mef
X-Rspam-User: 
X-HE-Tag: 1775808375-496533
X-HE-Meta: U2FsdGVkX19J1TqkVQDAw+Wgvqwt7qhy8TYqfBwJYT6wYChOUhweQedKIdjLI90zB+vQQsC0mtPip7IjtlWhd0kx/z+duZePCdA0/+T18D2RqDxt/AKjvGew1Duq4Qw6QpGaGs/2hk6hhjJsjU2xnpgDcUcTLG+iqjOYmqz4BHU3N81addJ0fWrSru/IzRZLy7vnS+qwkNBwj6x43P56i4zHlpqQVFSLMRjYA9YQbX0jNrYPOp/ml7jZEbVw2PABgKw0sf1TO4cwTW9EMrxzLOFLa/7vvuf4sY2Rs/48/qGZYm+xP+L6kZw9XyPOGTw/0hSPsmK6tlDXl/MKbGPmnvoKgOJhLHYMl8zXGZzorLMdmpeVexaTQfWKzs5n8piOiOGR5xzmjA1URg2CHxOrLx2MbeT/ag5krtO0Xy4zPI6FB5XO++fnbB6Y+bkye5IXmtlUX7tpfvWGqsZ3J2ToqOQGkZDAYquqR6DXvdJP+skjzR3zU2Jx0CtqrEceARWOaCEqQjdQ0DInzmZFNNHAxD8kDyJBk2hKexdihDWaIKwiCkp41AfNPg1H4ldATBKtJVokVFN8IM/L/ZJUyUQTRhsSvrQl6THQ5XHy13GvR34dzfE+a5a8OCoZ15ZkPEC11HiBszOCUxV3S+8CUv1XPZTrr4GE62oQ6aNDgEtCtCTfC1z6MMPPPM2XYi5JeOmVX5+3jJ6RXSFtiDBLhIuBqw+V75mIapfPnZmRp+b+/d6SfLDXxCm1JfjyWDVOxc0MF77ZlD8eFNKIIEkRRoYkaHMjOu76Q/6T2MffNcIf5mqzkxCz4wBkHUx8wPNpH/NuS/z/NVaKgcLDoabsvNzgc5NjTlj+UArsgz/VDvRzXmlOtSz5QcR4hWG0rTImDGlR8oDwBNfYn77Y9yj+LiU2yFk88YUc4DGs/G2Ctk9AJzGXCM5Ry8YU+Hl9rDR8dk7aK1lJ2UgslW3PrtRfDqk
 JGLnssq9
 3TL/BxlQBcr5IVRD7i0oBXgK7gZDmU3V8rtyygw72P29fzOckWvl3DcBZ1FBasulL6rmSCBUxyMfEQzkn8hFiiNFePyR5bcrAY8/Skjqwsgjo2s95zkAdSVhJgWZJGh1/Pk8uAtGxKfusp5G5B2QY7dZmYvbvAsJad5FA9wOG53Bx4BER8JvQb67Zj/mZklNBIdKTXPMMeM0zS04GrnmHW26PgGELDQ83njIm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On 4/9/26 13:59, David Hildenbrand (Arm) wrote:
> > On 4/9/26 12:56, xu.xin16@zte.com.cn wrote:
> >>>
> >>> Hmm, maybe we could do the following. I think the other members are only
> >>> relevant for the unstable tree.
> >>
> >> Well, I suspect that "SmartScan-Related" members might be also needed and used even when
> >>
> >> it's a stable rmap_item. In should_skip_rmap_item(), if its page is KSM, it can't be skip.
> > 
> > Yes, needs some more thought on details. We might have to ignore/skip
> > the fields for stable tree entries that have not a KSM page.
> > 
> >>
> >> What if the rmap_item is stable, but its page is not KSM?
> > 
> > I guess that would happen if we had a rmap_item at that address, and
> > then changed the page (e.g., COW).
> > 
> > ksm_do_scan() would call cmp_and_merge_page() after obtaining such an
> > rmap item from scan_get_next_rmap_item().
> > 
> > In cmp_and_merge_page() we'd call remove_rmap_item_from_tree() and
> > recalculate the checksum.
> > 
> > In remove_rmap_item_from_tree() we remove the item from the stable tree.
> > 
> > So we'd want to ignore the entries in STABLE_FLAG in
> > scan_get_next_rmap_item() to then reinitialize the fields in
> > cmp_and_merge_page() after remove_rmap_item_from_tree() I guess.
> > 
> 

Yes

> Something like this on top:
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 0c6bfed280f7..51fd37ee24d6 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -905,6 +905,8 @@ static void remove_node_from_stable_tree(struct ksm_stable_node *stable_node)
>                 VM_BUG_ON(stable_node->rmap_hlist_len <= 0);
>                 stable_node->rmap_hlist_len--;
>                 put_anon_vma(rmap_item->anon_vma);
> +               /* Reset pgoff that overlays age-related information. */
> +               rmap_item->pgoff = 0;
>                 rmap_item->address &= PAGE_MASK;
>                 cond_resched();
>         }
> @@ -1058,9 +1060,10 @@ static void remove_rmap_item_from_tree(struct ksm_rmap_item *rmap_item)
>                 stable_node->rmap_hlist_len--;
>  
>                 put_anon_vma(rmap_item->anon_vma);
> +               /* Reset pgoff that overlays age-related information. */
> +               rmap_item->pgoff = 0;
>                 rmap_item->head = NULL;
>                 rmap_item->address &= PAGE_MASK;
> -
>         } else if (rmap_item->address & UNSTABLE_FLAG) {
>                 unsigned char age;
>                 /*
> @@ -2465,6 +2468,10 @@ static bool should_skip_rmap_item(struct folio *folio,
>         if (folio_test_ksm(folio))
>                 return false;
>  
> +       /* There is no age information in stable-tree nodes. */
> +       if (rmap_item->address & STABLE_FLAG)
> +               return false;
> +
>         age = rmap_item->age;
>         if (age != U8_MAX)
>                 rmap_item->age++;
> 
> 
> But it's all confusing. Because we might temporarily have rmap_item->anon_vma
> set on an rmap_entry that does not yet have the STABLE_FLAG flag set through
> stable_tree_append().
> 
> And then we magically call break_cow() which does a magical
> 
> 	put_anon_vma(rmap_item->anon_vma);
> 
> (this doesn't look correct in once case) ... anyhow.
> 

It looks confusing indeed, but it does break_cow because when merging two pages into
one KSM, the first one succeeds but the second one fails, so it's necessary to
restore the state of the first successful rmap_item.

> So we might want to reset the pgoff there as well, OR only store
> the pgoff in stable_tree_append() where we actually set STABLE_FLAG.
> 

Yes, I agree. Please allow me to reorganize all the key points we've discussed, and
update and optimize the patch along with the test program.

I will try to release v4 for review as soon as possible

