Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66B4C606A331
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 21:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Volu/Qno
Received: by kanga.kvack.org (Postfix)
	id 803E06B00EF; Mon,  2 Nov 2026 16:24:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DBE26B05B1; Mon,  2 Nov 2026 16:24:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71B186B05B2; Mon,  2 Nov 2026 16:24:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DFDA6B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 16:24:44 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C4486160231
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:24:43 +0000 (UTC)
X-FDA: 85391458446.28.D41CA12
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id D53E020005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:24:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="Volu/Qno";
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793654682;
	b=AzOId9G9fljO2Z3u3zE1X5U8j77RpXVmy5j7f501egXYoITz1YuxjTUPbDOHT2CJZQATBD
	LhuCqF9CK5pSEvHH0gYlY4ei0ujSmz31RcB+qJVyn2J8pRPyUd0jWiTPdBB1eRn8JJW1el
	UUDqBN2/CdYEqyYTrmSK69EGCI288FA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="Volu/Qno";
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793654682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cY1t39+3gzTLNFhC7dxLkefRg/oZa/qkP6zoNcN6n2E=;
	b=cvA8Xww6LAE1p5SmVs5iDpR7S//CrC4PCp500qIxcusN9go3rqwIrULxRDrNnEARpteYW2
	58J+BgjSZj8zZK9sdLUJnSqxLdyM4hRAhtY0uy2GUYk/H5/aqWHmIryF2qCbyAX2IcRNMR
	NlRhBxVjDAKxGg7MMzKLfHFDCs1wITc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E4B3D43E4E;
	Mon,  2 Nov 2026 21:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C221F00A18;
	Mon,  2 Nov 2026 21:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793654680;
	bh=cY1t39+3gzTLNFhC7dxLkefRg/oZa/qkP6zoNcN6n2E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Volu/QnosDZUf/lm+UfDNb6h/cKNwjncmN6pmzGpGXsQSM9RGmoASwJJ7nelEgsm+
	 f+BA5KHkUa+dEIZzlyCLvVAsuHnl4iLwk+R2M0jXqnYUjA+raXzdeBHO7DyQ+s+ZVI
	 WQESqkxYsBqNz/Ve5ERhhqxEGDRG/OnlPHfnurOU=
Date: Mon, 2 Nov 2026 13:24:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Lance Yang
 <lance.yang@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzbot+10e72ea5747737bcd2ad@syzkaller.appspotmail.com, Songsen Yang
 <yangsongsen@insta360.com>
Subject: Re: [PATCH] mm/vma: read anon_vma carefully in validate_mm()
Message-Id: <20261102132440.92038293c42bca37768a541e@linux-foundation.org>
In-Reply-To: <auhrcEfT5v5MVcFj@gremlin>
References: <20261102-fix-validate_mm-v1-1-5c309614ef15@kernel.org>
	<auhn01dpDzK47igy@thinkstation>
	<auhrcEfT5v5MVcFj@gremlin>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D53E020005
X-Stat-Signature: crnouok43d5ew5s545jai4cyig61457k
X-Rspam-User: 
X-HE-Tag: 1793654681-369241
X-HE-Meta: U2FsdGVkX18I4tezxc/+XvZWwZwA1hYJW5uGESG02KTpzp/byf47iFhjK4Jdaj0fZ4I2v2dL3tFkgbI/Xlf9iNKKVEHblGwAOWwSEfVFZIicE1xzs5VE4KmiisHtfa7OtI0AhoTrpe+cBrkSpzTBk/O0J+bbX1hOK/eSNCuw/nWTjgjN/0PTMupbQGifCzNVpcqWI3mfpLY0NFlh0fJMnm50Uy6PAnZ4A9A4mtFqh5OdZDYBBDJwGtJDGvYkPI4nCCq2144wBGvjIopBJe+NInMh6qbi/PUNDEjEst9H6Zd3zekMbGsiX4wCHxKMGZHkAMZcn31cFH/EVvcn4o8J4UgWSMn6lNr3TrS8yH49+Z4lUGFanl8lv3JIxVNaW7BbB1o3me6mNyYJ9tiIHcaF9NTOGBVEmJS4jAWCtk4Of/eo7ZI9Aoz+racg+7ttBwRg419c/G7mDHdP30CfRu8yKeS/K2f0b7ZEchEMVzn7Kmwa6F7VAdI+WVrmZrePXWom8+EG9aG33hnENHM4+7UMTuznarv+QoTRrnaAuW8i3NiFMzKGl8K4rhg3XXeEqZiEqBcBOiKsNSX21ug01qui+KbcNMdpAUfxUsf3NG7s0l+aS4JXNnTtpOFwP1BC8s0+0NuOH8zCTd+ioSlCsJaUGkARjdksPr2/CHbIBDq2CrrUMseL2VoRSn2lVXas7ovSPnvNouXdxjaWrfCx5gM13l++LO5JVpn/uNqz0r81ly8dBXw4aNt3iOFdyb8AUr4T8FKTs1qutFsVjCMEmjBtpbg59+cx+KCRh76Z07YWmFIDdivdah5hW+FrtdSeAGNberYUiNGL4tV87RIBXxHOUNMxZDwFxRfEeGcqwX/F+JhOhOvLI/7PPH9mDlTigSJ3EVP7rzmxki+X3YQTglZ+wJxesfzua5f461D8RUWDvm1wuFFJCQw5BMlM/ixEEgW8L7eBFXMcn/MaVXAB1qw
 5c4Sejw2
 rxEntk6HlIawC8LjTZOte5fH3IzdlUmQIurRPMIy1/mZ6zb+ZOrO5jZVE21y0KyWr4zYQ/LaR922L2JvwJFrx4cKRHy9cRR7RnKz5abheTo/v5UiVEatB/y5zE5Z4GLBp+qB3p40UxK0p1/H/jMUXNnwZJJGzaiyr8vrjZ9+mDYAEANtRtQluAeW47yrApCP/yxj1IvTGzK3MAVQY8d7xpHeg8sJSCxMaS78Gj8jh8Y2OSdVTr/H32UOZY8WeNzruHVovk3KjhqeUH2VoX8R9hVx81+2P1QbMcA7MLmGC5JQ6sKEpGL/lb1DPO07uBOagFdmfoZrYziKvtVD2sMI0s86hJ514acFGfdIou2p44EyFcNeu90k48C+SLgOq4F0srKwa12mzfc5aMMKGckCsrbOZBVzaHrVfoFdrPcrjzDn1NGQ6xpyLLZzzraehML9nWutn/VXQ/mB6iTc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2 Nov 2026 11:02:56 +0000 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> > This ifdeffery seems unnecessary. What about this:
> 
> Yup, even better.
> 
> Andrew - could you update it in-place or do you need a v2?

I queued this update:

--- a/include/linux/mm.h~mm-vma-read-anon_vma-carefully-in-validate_mm-fix
+++ a/include/linux/mm.h
@@ -4370,9 +4370,7 @@ anon_rmap_tree_iter_first(struct anon_vm
 struct anon_vma_chain *
 anon_rmap_tree_iter_next(struct anon_vma_chain *avc,
 			 pgoff_t pgoff_start, pgoff_t pgoff_last);
-#ifdef CONFIG_DEBUG_VM_RB
 void anon_rmap_tree_verify(struct anon_vma_chain *avc);
-#endif
 
 #define anon_rmap_tree_foreach(avc, anon_vma, pgoff_start, pgoff_last)		 \
 	for (avc = anon_rmap_tree_iter_first(anon_vma, pgoff_start, pgoff_last); \
--- a/mm/vma.c~mm-vma-read-anon_vma-carefully-in-validate_mm-fix
+++ a/mm/vma.c
@@ -669,14 +669,17 @@ static int dup_anon_vma(struct vm_area_s
 }
 
 #ifdef CONFIG_DEBUG_VM_MAPLE_TREE
-#ifdef CONFIG_DEBUG_VM_RB
 static void validate_mm_anon_rmap(struct vm_area_struct *vma)
 {
-	struct anon_vma *anon_vma = READ_ONCE(vma->anon_vma);
+	struct anon_vma *anon_vma;
 	struct anon_vma_chain *avc;
 
+	if (!IS_ENABLED(CONFIG_DEBUG_VM_RB))
+		return;
+
 	vma_assert_stabilised(vma);
 
+	anon_vma = READ_ONCE(vma->anon_vma);
 	if (!anon_vma)
 		return;
 
@@ -685,11 +688,6 @@ static void validate_mm_anon_rmap(struct
 		anon_rmap_tree_verify(avc);
 	anon_vma_unlock_read(anon_vma);
 }
-#else
-static void validate_mm_anon_rmap(struct vm_area_struct *vma)
-{
-}
-#endif
 
 void validate_mm(struct mm_struct *mm)
 {
_


