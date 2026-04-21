Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A90BF327B6
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 07:47:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DCF96B008C; Tue, 21 Apr 2026 03:47:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B5006B0092; Tue, 21 Apr 2026 03:47:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F2BC6B0093; Tue, 21 Apr 2026 03:47:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E83D6B008C
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 03:47:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0C62613C1AD
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 07:47:04 +0000 (UTC)
X-FDA: 84681781968.01.072CB6E
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id 285A710000C
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 07:47:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qBtAk1+n;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776757622; a=rsa-sha256;
	cv=none;
	b=8OIEApC9Mwp8EG8coXbAvPltYWVYDqpr5tJQPpIlg5U3SuHufVEySVcd3dLK7roJg7GOkc
	rEMSAHb25lgf1i52Q+j14+04poF/rxWWyLgUMWDZ7JZpHFROYttPyir+jrFn4VRsosweUk
	Geamsjim5RKRt5J1BVTMdk5YPar5fok=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qBtAk1+n;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776757622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tf1/Nczyer/GJCIPDHmGkMVMbW3+J8WCh6h++SMiyOA=;
	b=mE+Xe+3NRx+xPjK5GstSvhi6To0XajQDcoOrH6trWojww2eEHtTyXPF5oBfc18MMO/3HMl
	Lw3s/MemCFWsOrZAQSEzQ60QfDdKWcha809vsT0+Lx4noczuLD7y0wfba3opFfF8MBskG0
	mXWw81DHxPdTAxBVFpScGHJaY8uE6c4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776757619;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tf1/Nczyer/GJCIPDHmGkMVMbW3+J8WCh6h++SMiyOA=;
	b=qBtAk1+nNzp4Kl8q08RFuv48IsTFWM+xt/tlv/kUr3tpqfe5xYPcqNG/NSCwj3GwEDrPKS
	Tjr5tT3APq2SB/EiN7Ju/Bzjfsc+cB8DPKdlY5NB+DfHxzv1EkzgASI+y8IFrTqVl8uJdT
	d269iHpA5/QvNdycBlZjGdhfBEdJHB0=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	lance.yang@linux.dev,
	ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: fix initialization of tags of the huge zero folio with init_on_free
Date: Tue, 21 Apr 2026 15:46:30 +0800
Message-Id: <20260421074630.72451-1-lance.yang@linux.dev>
In-Reply-To: <20260420-zerotags-v1-1-3edc93e95bb4@kernel.org>
References: <20260420-zerotags-v1-1-3edc93e95bb4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Stat-Signature: gmw3yxk8xuq37md6k7p67s4xg9odhugk
X-Rspam-User: 
X-Rspamd-Queue-Id: 285A710000C
X-HE-Tag: 1776757621-802674
X-HE-Meta: U2FsdGVkX19meRjvcqeGikH1riX7RT3J0KKR5MZLhl8x2CAGbp7D/U9X/DnmWMdbqqCcR5dqnnToyRztRg/ajuzZNhcXQu4YDx0to44Qlc2VJrSJiwIJWEFGPBYQt+podqmKGF6lNN3GURXLsTf/NJhBaCXfNEbuxjERq1WZlWErgkLC8JePB/yYikzv4sxIhK/u60ZeTIggmS9Cm7mWelp+7Txi+K/bFRv5okRVVOuT/Lu1J40cU6X7k22MiAlzkyVkMuTNDufxDphJO+rG37DHlcT0lSS5HAdOw2jnaBd6qiXs3127Uu51m+bvoAlvIbe2CczzVgfLZqcsyW2MvAh67e12xhxErZlPqbnE4kA7XN/wGOMKEErv8nznqlj24z3raV7PAhgEbrTfVmDk27jaZsX9IOdJ3Eg/OeaeZoT7kYPjWYY8Uc6pcoeUsA/OoJpvloprymcYERuq7u1DnkeYktED1c3uVACcJc2RwKUv4N8uwoHOkmKl/bkNWUFBzChgA9WPNSCWz7fr2Iz7ErVaUX524XbhVthlnL9sjXeTw4LvJxiMfuwP01UYm3LVenpmu61lvkm6kU9xMOgl48NdCe9l9XoKuSGVS4/nJdvi2UPv/kt790h/b1ipIAvwTEYWB7lR/Nz3Mg8h51XSa1nlEEXo4ajLTpF4Ub8b+NaQHspshVYWPSlFqKVNqSSeqUpW4DPQ2AZJNRl9PjLwfTKnpkcDQbVmcyfBxZyM1ubMFFRG6sd/XkzARdFqkfLcbOLog3dk6jzNqtWXeJ8lv01vDOOH3wOX63Vm7tgn/rWJrBHv/LAJ0++j+p27dz6F06ufSXPZlxhi4Q6n4Dm2xlbJBcgw2ois8JFJZkGReQo9+henWQnxBVK0l1UixrEpwzXPHWjufZVY/7atj30xFQSh35aUjICOR94LkMe4AL/WhWVcHGrjq7HYstXGJvaUMCNg2ouJHhjkRoW8qKQ
 fd0bnmiD
 12pAl/I6jMvxR8BeeE2wPlSV/8U2TfGRs+pLBOFH60wpBJCBUOkGb7eGhJoLwTwG2uyfgTw1676P9+t//Z/1gdMVOkwZXQt7i/GVsNlQIn3bX1fEQQpkjqzCx7fViJj8xD1UXFWntSGwyNTp9XSQvZfhEeKdLKtux+IOn0AX1ynqyLvohBanWAvmZRvkEUnJ8oIudi2O5IHHkdydjsFqDiT+YJqZpHMtWFbDBfHYZuSfUVibVm5oAnOMUCEPxP5iDrFcW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, Apr 20, 2026 at 11:16:46PM +0200, David Hildenbrand (Arm) wrote:
>__GFP_ZEROTAGS semantics are currently a bit weird, but effectively this
>flag is only ever set alongside __GFP_ZERO and __GFP_SKIP_KASAN.
>
>If we run with init_on_free, we will zero out pages during
>__free_pages_prepare(), to skip zeroing on the allocation path.
>
>However, when allocating with __GFP_ZEROTAG set, post_alloc_hook() will
>consequently not only skip clearing page content, but also skip
>clearing tag memory.
>
>Not clearing tags through __GFP_ZEROTAGS is irrelevant for most pages that
>will get mapped to user space through set_pte_at() later: set_pte_at() and
>friends will detect that the tags have not been initialized yet
>(PG_mte_tagged not set), and initialize them.
>
>However, for the huge zero folio, which will be mapped through a PMD
>marked as special, this initialization will not be performed, ending up
>exposing whatever tags were still set for the pages.
>
>The docs (Documentation/arch/arm64/memory-tagging-extension.rst) state
>that allocation tags are set to 0 when a page is first mapped to user
>space. That no longer holds with the huge zero folio when init_on_free
>is enabled.
>
>Fix it by decoupling __GFP_ZEROTAGS from __GFP_ZERO, passing to
>tag_clear_highpages() whether we want to also clear page content.
>
>As we are touching the interface either way, just clean it up by
>only calling it when HW tags are enabled, dropping the return value, and
>dropping the common code stub.
>
>Reproduced with the huge zero folio by modifying the check_buffer_fill
>arm64/mte selftest to use a 2 MiB area, after making sure that pages have
>a non-0 tag set when freeing (note that, during boot, we will not
>actually initialize tags, but only set KASAN_TAG_KERNEL in the page
>flags).

Good catch!

I can reproduce it reliably with this small debug change:

---8<---
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 970e077019b7..d5b6e2474f47 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -225,8 +225,7 @@ static bool get_huge_zero_folio(void)
        if (likely(atomic_inc_not_zero(&huge_zero_refcount)))
                return true;

-       zero_folio = folio_alloc((GFP_TRANSHUGE | __GFP_ZERO | __GFP_ZEROTAGS) &
-                                ~__GFP_MOVABLE,
+       zero_folio = folio_alloc(GFP_TRANSHUGE | __GFP_ZERO | __GFP_ZEROTAGS,
                        HPAGE_PMD_ORDER);
        if (!zero_folio) {
                count_vm_event(THP_ZERO_PAGE_ALLOC_FAILED);
---

That makes it much easier to hit. Userspace can seed tagged 2 MB folios,
but only as __GFP_MOVABLE.

The original huge zero folio allocation uses "& ~__GFP_MOVABLE", so it
will only reach these folios through fallback, which is hard to force
reliably from userspace :(

Will get back once testing is done :P

Cheers,
Lance

