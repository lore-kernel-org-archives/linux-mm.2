Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 420BDEA3C21
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 10:06:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DE9D6B0005; Thu,  9 Apr 2026 06:06:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68FC56B0088; Thu,  9 Apr 2026 06:06:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A5886B008A; Thu,  9 Apr 2026 06:06:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 470C16B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 06:06:15 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C7F138C28D
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:06:14 +0000 (UTC)
X-FDA: 84638587068.02.7E39425
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf03.hostedemail.com (Postfix) with ESMTP id 76BD82000F
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:06:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775729172; a=rsa-sha256;
	cv=none;
	b=uKcNE64jK7fVuspIfdea+ouGuPXfl90LrPKqkjgACb8Vt6POO9X1DzuysJd/2oC5wcj7XZ
	V7xgjaRP3iRkJzFkF/yHBNqNR16Gy389XAxuiq+8/HAZcUp08Fz65Aes+49D/ScGdIcUAo
	AtLvCMphPxVpScgIVnbSS/9cAI8lTT8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775729172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lL1pxQvXUSNVCturxSKaq1dzyxf6URgJ3w5RhlsPDKo=;
	b=wxTT8PTTBHy8e0eI9DNerK3t3jjUw6+6btgPJbvaFvpMQgjrgLIooUVP4vWFUNFGBKBupi
	LLZX5dQJ+NRsLODskk7QPfUjuwhgKcFq/PQXx9RIvqaS5ZAWtfOVRtZWmGApGFmNn20RVg
	WXMe7p4XuYFveHIqC/g+CBkHPnmmGhk=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4frwYq4zTgz8Xrkn;
	Thu, 09 Apr 2026 18:06:07 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl1.zte.com.cn with SMTP id 639A62Ho048259;
	Thu, 9 Apr 2026 18:06:02 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 9 Apr 2026 18:06:05 +0800 (CST)
X-Zmail-TransId: 2afb69d77a0d0b5-eda54
X-Mailer: Zmail v1.0
Message-ID: <202604091806051535BJWZ_FTtdIm3Snk24ei_@zte.com.cn>
In-Reply-To: <addoN3ur7GtiKOFf@lucifer>
References: 9950c6c1-f960-58c0-4312-e4f5ac122043@google.com,20260407142141059pWDasxUAknP5rqvAMl28K@zte.com.cn,adTPQSb-qSSHviJN@lucifer,8332aedb-e499-4789-8f46-832df8d60224@kernel.org,addoN3ur7GtiKOFf@lucifer
Date: Thu, 9 Apr 2026 18:06:05 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <ljs@kernel.org>, <david@kernel.org>
Cc: <hughd@google.com>, <akpm@linux-foundation.org>,
        <chengming.zhou@linux.dev>, <wang.yaxin@zte.com.cn>,
        <yang.yang29@zte.com.cn>, <michel@lespinasse.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2MyAyLzJdIGtzbTogT3B0aW1pemUgcm1hcF93YWxrX2tzbSBieSBwYXNzaW5nIGEgc3VpdGFibGUgYWRkcmVzcyByYW5nZQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 639A62Ho048259
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Thu, 09 Apr 2026 18:06:07 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69D77A0F.000/4frwYq4zTgz8Xrkn
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 76BD82000F
X-Stat-Signature: bn97ikzz1gx51dw3eapn8da9zkgj4fxb
X-Rspam-User: 
X-HE-Tag: 1775729171-502488
X-HE-Meta: U2FsdGVkX1/7w+651hZJuMR4QALCfZMVM8mMlZb2BJSmGNfCMp1jm0b2s6QziRYvdx1+8ZWZCeSycoItRpcFJkVnYvWxPltD/Ufb23YcNSqx2KXzHbVpNWlWWFuZW1Og6+3PGA8mWhNlAR74Y2QxsDxRhvF62QSeW0T7rDYWEBu5Ux4cAARpI6kgctnh0YGg4j7bABRYIknJ+lHBeuUy9oRrxGonLXi8E3UvUrPDV0O1UnJJf6iI+Gv5FkrsvLc6Z435rUHlR4aSytSXf2S9YN2CV7HF+uIP5h6FhStNv7fUeFcFixQp3r0yMusMzQ5yr+3DLj8S1LEZiURHNgwQws9jYXCSDfSoMsCrAtH6wJO2Sc6bnjBn2BooiSZcexYb+37XqeK1wECd1SK/ZJBGmgw7f+DvMSNLJTDA3VwP67DenN5aJv9qons98GgbsXcDbEQF0h7ue+MJOdSnQ/qKFb1SHky/oZ5VuZuBKXLiMky+Nl8JHb/ywShyZ/Cfv8cb7snxu69CIZR8Ck/8WcxLHQIDM2kboSt/T8Qf0aygEnh7ojE9dA9rZvplrH4el40ZHewU+Iiyr7zK6O1Gf/3gZOd+7n0U4jjPXpfkwrwe3eeVNTQD0oth+jDGE6iONyNxj9NnWprKTmmiRJGWUAFPmphNnweNa5EM4rFtu1HhzeM4ZCd7qplIZhh1xGZwY8h4S9MIHCfT8tRPf1+ED2GBPGOVXXQo+3bULoFb/HPkM+hn0Y9n1ka4xzAbeKZ/EKrtvrZPxrhsVLhSyhMFG3TyCwGKYx2BdP9ISXKW9FyDiJLWi1sxLzYKeWpr5pncRQ+TlxnPXhD+ysfOBB1dGXR5QrPDk4vYMLAowNIZxSH5TFQLCvvgXEUJh9csLxEwBboHYNrz8bzVzWSd32Vci6DxzhvY5qDNeenoUb/kFwy2Frhq9hxKYtvJhr2U8ZqvLq5sKGciDnovHEOw3RZvVUA
 +M43Dm6o
 OqzCV+WtHCTwZg0OM8zZBEJIoH4FEvYBKQL2WdMbkwj/bdMmE3plTngoAcCe4o8D42UjkeR+hBW5qEazClbkFpvDQ0GrVHnjIihRmeo0ICLtupDd0/HAfPMBaBymAtNgNsXa4KaVmqxtno5gdleIVfEUL3lTwfw5vK47ievdjdUXwn18/NDdgA9OKVDHXTgYIIBdbm5BmPIZa+kZsBrAqImcnZ+CYQe4GWNs/L8UhtSR/yvt2FbnkqeX77+dxBizkbll9RMkEbnYGp8UzWGXVjQC5+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > >>> I'd completely forgotten that patch by now!  But it's dealing with a
> > >>> different issue; and note how it's intentionally leaving MADV_MERGEABLE
> > >>> on the vma itself, just using MADV_UNMERGEABLE (with &dummy) as an
> > >>> interface to CoW the KSM pages at that time, letting them be remerged after.
> > >
> > > Hmm yeah, we mark them unmergeable but don't update the VMA flags (since using
> > > &dummy), so they can just be merged later right?
> > >
> > > And then the:
> > >
> > > void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
> > > {
> > > 	...
> > > 		const pgoff_t pgoff = rmap_item->address >> PAGE_SHIFT;
> > > 		...
> > > 		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
> > > 					       pgoff, pgoff) {
> > > 			...
> > > 		}
> > > 	...
> > > }
> > >
> > > Would _assume_ that folio->pgoff == addr >> PAGE_SHIFT, which will no longer be
> > > the case here?
> >
> > I'm wondering whether we could figure the pgoff out, somehow, so we
> > wouldn't have to store it elsewhere.
> >
> > What we need is essentially what __folio_set_anon() would have done for
> > the original folio we replaced.
> >
> > 	folio->index = linear_page_index(vma, address);
> >
> > Could we obtain that from the anon_vma assigned to our rmap_item?
> >
> > pgoff_t pgoff;
> >
> > pgoff = (rmap_item->address - anon_vma->vma->vm_start) >> PAGE_SHIFT;
> > pgoff += anon_vma->vma->vm_pgoff;
> 
> anon_vma doesn't have a vma field :) it has anon_vma->rb_root which maps to all
> 'related' VMAs.

Yes, we cannot rely solely on anon_vma to locate all PTEs mapping this page; we
must also have the original page's pgoff. In fact, I believe only the current
vma->vm_pgoff is just necessary. I've examined the implementation of
anon_vma_interval_tree_foreach — it essentially iterates to find a suitable
VMA such that the provided pgoff falls within the VMA's range
	[vm_pgoff, vm_pgoff + vma_pages(v) - 1].

The root cause of the issue Hugh points is that the pgoff calculated from
rmap_item->address (which derives from vma->vm_start) is not the pgoff of
the page prior to merging. Consequently, the anon_vma_interval_tree_foreach traversal
cannot match the correct VMA satisfying vma_start_pgoff <= pgoff <= vma_end_pgoff.
This origins from an existing fact: if a user invokes mremap(), the new vma->vm_start
may changes, while the mapped page's index remains unchanged, but vma->vm_pgoff is updated
synchronously to ensure that the vma_address() calculation remains valid, like
rmap_walk_anon() in mm/rmap.c.

Based on the above, I think a simpler approach which does not increase the size
of the ksm_rmap_item struct below.

> 
> And we're already looking at what might be covered by the anon_vma by
> invoking anon_vma_interval_tree_foreach() on anon_vma->rb_root in [0,
> ULONG_MAX).
> 
> >
> > It would be the same adjustment everywhere we look in child processes,
> > because the moment they would mremap() would be where we would have
> > unshared.
> >
> > Just a thought after reading avc_start_pgoff ...
> 
> One interesting thing here is in the anon_vma_interval_tree_foreach() loop
> we check:
> 
> if (addr < vma->vm_start || addr >= vma->vm_end)
> 	continue;
> 
> Which is the same as saying 'hey we are ignoring remaps'.
> 
> But... if _we_ got remapped previously (the unsharing is only temporary),
> then we'd _still_ have an anon_vma with an old index != addr >> PAGE_SHIFT,
> and would still not be able to figure out the correct pgoff after sharing.
> 
> I wonder if we could just store the pgoff in the rmap_item though?
> 
> Because we unshare on remap, so we'd expect a new share after remapping, at
> which point we could account for the remapping by just setting
> rmap_item->pgoff = vma->vm_pgoff I think?

Can we just replace the stored anon_vma of "ksm_rmap_item" with the orig_vma
when KSM merging? Then, from rmap_item->orig_vma, we can directly obtain both
the anon_vma and the vm_pgoff, thereby enabling the location of all PTEs mapping
this page without any ambiguity.

Cheers, Xu


> 
> Then we're back in business.
> 
> Another way around this issue is to do the rmap_walk_ksm() loop for (addr
> >> PAGE_SHIFT) _first_, but that'd only be useful for walkers that can exit
> early once they find the mapping they care about, and I worry about 'some
> how' missing remapped cases, so probably not actually all that useful.
> 
> >
> > --
> > Cheers,
> >
> > David
> 
> Cheers, Lorenzo

