Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 305D2C88E6A
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 09:13:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E72B6B0088; Mon, 14 Sep 2026 05:13:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29A216B008C; Mon, 14 Sep 2026 05:13:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1889C6B0092; Mon, 14 Sep 2026 05:13:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E338D6B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 05:13:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0C12C4015C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:13:30 +0000 (UTC)
X-FDA: 85211804580.02.B7BFFF3
Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	by imf27.hostedemail.com (Postfix) with ESMTP id E36664000D
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:13:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="D xrsduI";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=a0GDeqx6;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789377208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G/i01ADfODxC2kd+l0U6xVisdaWaodGmtaRBn1bby/0=;
	b=0wXGHjdMg5b28+d93pCG6/coBoImd1ngKDGa2DrCseqfuFE5DIOL8rDoFXNQq2ZmLl+G3O
	tZOg6JBme/mVlrG7xbCBoFxXYVopesfgj3e07DK1UpZ+c56RJXXmmXkLvXhPZEKZQ+FWIo
	4vVrh5ZliN61uKRgO7sYscyy16PkuTI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="D xrsduI";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=a0GDeqx6;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789377208;
	b=mH8dM6NwCWnEj4jVs3UafjBiQTxP3KctOdS5RKidZ0dPo/hfYONW8acTQl0LRP5LD29ODu
	52hyKYifqWDU64bmu1ZUwp96xDlC61czwhNQAF4qd+WBACeePHnrQNVw5SEsmR138RGJU6
	fQQ0LGmASOOra2lBleR0ZKp2pG/KoVA=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.phl.internal (Postfix) with ESMTP id C7F991380076;
	Mon, 14 Sep 2026 05:13:26 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Mon, 14 Sep 2026 05:13:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789377206; x=
	1789384406; bh=G/i01ADfODxC2kd+l0U6xVisdaWaodGmtaRBn1bby/0=; b=D
	xrsduIDC2uLs47AsMJivwLERYIQsQYdY41fdfz1eSLQA/eLPTGORpfMW3tSEE8MZ
	bzId7jBWaFIOWXdH09xs6c2GvwJzOQlb9EMyKskvHOgYjDpGkhMWu5Ih27m/E3AX
	/Fz4ZWsAfqbaqvnUMRXu5eKLw0KXat0IF43CFnAzs2/NhqZWGP8s/nca6vVzEubH
	WlK0AWX0SX1yq4hqAxFbXPIWfJgD1gYlElrtHZLczzGxVAVB6Sa0f2iVjCrpSPt6
	PJxZzstPJYmPecljRKgWW7dlNOWsAUc/+hbBS57b0z7kbj5znzLvuB4dLxwKdWXy
	r/FrD9hrjlctjIx/QEuZA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789377206; x=1789384406; bh=G/i01ADfODxC2kd+l0U6xVisdaWaodGmtaR
	Bn1bby/0=; b=a0GDeqx6xYb+hI+I6ycy7eUP2nBBQZeUqeoUNTNpRQ6jE82bvPp
	2CAI0YbEgqe8XVF47rGDhRIVquH7h83FGgafUd5leREox/bdgPvpu8MZSYmUrXtD
	WzOBcVoIiyvEtImOJzLCPfNZGQ1hDdkMPuKkEM4gLgvzjzCvuOK5+YdiEDKX4JD+
	e0cf5iDNnuxRf5ez7/SeQRYyuLQuESRWfn3u5nIwLWP/tU/fA4DH7qN/mkwY10DE
	V2HN01xHhjep2WAqdxEIwNB56rqRMAxF/8EU86z5eCqkYTIT8L72G+/+Do9Poj8r
	+ZrM2IVhf//sdvHZ2j/0tYQzb37oxdi2FjA==
X-ME-Sender: <xms:tLqnah55VrhZ7mE-aFuAkkHCoktgS4DwnB6a2qVo8Kp0crXjTK4Kfw>
    <xme:tLqnag4Nt9gHB7OVBcyL6ZPusPRyM4PHkKfHGlPrDlY52nyoSAAIMqWrUetmyvtu5
    vKyeASrtWyTC7ByNZBphmgKZX4ZRyUmhHzhfPx9NbspgI1j2vuLjsw>
X-ME-Received: <xmr:tLqnaszXzZqainiWuYAlfzCPd9-jl-QABn0GGGdf136l8jb5v-KxNOAHCVk>
X-ME-Proxy-Cause: dmFkZTFzR4LAYmIM2NQif9GHp7AATCGw2ycwgB/jsE3Ge52LB7yeSPM+kaaMxAG5k+INxO
    mkdSJB9LNZJ4uNEFFarGvES1kvmspfNRg0fMpXztUQ9dFiTikbLwRtVGdYljrf3YGubmMR
    YW3b3mHdxQDfzd7KRT82MI1xOCXec+5qzPmJM2kCDR8COFuIcsV9WF+YuU1oClUm+NFDfq
    ggPjT/85CkzwdjMXaR4CVSQowihbVpp0MWerXeDQcVshNIcZQDghYxJFqeF4kKkC5sPBTo
    fCRe3a3IqQ2MiJ5lAGE5s46cPhNz9CxKFKWkUJ8EdqNxfyupi7Qgh4SAkdi80IUhoH26oT
    Q6qkL7CzuGiK+5wtBtCIRdsQcVv1mE1yo+QxTcAkVKApWCo5FXD5KPG+OCwH6khsK/fHgg
    weQq5i89P27RLF9exdAJFZZzgPxWEb20lxzMn9zh0S9JhDsR9DrhedmIfo81KLvPpV8/Js
    tbpLV4JUY+/FEZkeGLQmJv4/yGMShv8NkwzkdjeAQ/kb43VPE/LN2dqr1cqaQX+iYaHgdz
    b9MCZQtF9aEBVdLnpJGPhDrsEfwrHAZpxwrkwPs2nDUNwrR6EU0YTUgJ+HCNyD9Ojkyord
    dezo7mqpQPp0g25497aQHNyph12VRFbansywApuc5EpFTLss6Tkz2Z3isp5Q
X-ME-Proxy: <xmx:tLqnaiVGetMH1_-gjmU83UVn_X_nOChxcRcOz41itpgpSZxN3YPqvQ>
    <xmx:tLqnau3Q0nC3mtu7azDLqsG_XI59J-1dq5LC1rA9LeayhxMl6YDmcA>
    <xmx:tLqnavSVIgzcLBFN_4gt_JsL15XU_AXNXMnt-m9lsxw8iFt0tAJHLw>
    <xmx:tLqnatP10ESy0rXhuI7ajY_StP8t5mvGczkFxTwFoxTZZKYV5XFO3A>
    <xmx:trqnartTIzyZGCIEZ8y7HYItxLEWlyBkor1myDtJtUXcQq0Lsj9jQYAd>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 14 Sep 2026 05:13:23 -0400 (EDT)
Date: Mon, 14 Sep 2026 10:13:22 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Ilya Gladyshev <ilya.gladyshev@linux.dev>
Cc: akpm@linux-foundation.org, andrew+netdev@lunn.ch, apopple@nvidia.com, 
	artem.kuzin@huawei.com, baolin.wang@linux.alibaba.com, david@kernel.org, 
	Liam.Howlett@oracle.com, edumazet@google.com, harry.yoo@oracle.com, 
	hramamurthy@google.com, ivgorbunov@me.com, joshwash@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com, 
	muchun.song@linux.dev, pfalcato@suse.de, rppt@kernel.org, surenb@google.com, 
	torvalds@linuxfoundation.org, vbabka@suse.cz, willy@infradead.org, yuzhao@google.com, 
	ziy@nvidia.com
Subject: Re: [PATCH v6 2/3] mm: drop page refcount zero state semantics
Message-ID: <aqey_fQ6RtfWBWPx@thinkstation>
References: <cover.1789239015.git.ilya.gladyshev@linux.dev>
 <b3e54254a0ba7113700cd12ff673c98f1ba00390.1789239015.git.ilya.gladyshev@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3e54254a0ba7113700cd12ff673c98f1ba00390.1789239015.git.ilya.gladyshev@linux.dev>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E36664000D
X-Stat-Signature: tqud6kmz9tdp7jgrk67ad5uga1tqd4zr
X-Rspam-User: 
X-HE-Tag: 1789377207-337431
X-HE-Meta: U2FsdGVkX1+Qp7YyRZ8Z9QERRq1074niB0R2H12GWdvLeisQ5+ZVUWZL69l+jfjz1B5AqpvhqHx43Co+dT0T1jFwDw5MHpeUPc7id3nWF3wqDWCNWFmbae9wq1znRjqN2wcCAqJDjqZ0mwswmwZj2RNOSNHaUpcXQNw4pXKT9fs0BUqi3b2hCvNW1e1/GVVEnTqekJOf+nDUKg34AkAuKr58UmuyFvjD/Y6SrgSlr8L4tbKnD5T6HALZqix1UEry3QFRdMAQjfD7a6aceAVY6IVmlGVJccZBGdelQdk8Hrx/f3QZ/Oq7nET92q63/ssoceL/8hm/AQHhvqx8IW2bdDQorF8vKAtjFmqTeLnNbbQ/iqiMlzNi/URsBD9b5uo84PBnFrW1kkiqLFW235yIagak/+t/wFwMon3Li+R0laX/tr9TSJtfhZPvYEb/9GXQ+3eUYNOBJe/OdHWEzVRCxSbMuLDXP/F5wdfBgey/SuH2q+29VbAtX8LRQvo+rdaBP3I1bMqkAa3aIYw6383u9FtTVH9j7418Unvlba8jWyhhrvj84N5C94P9qxpGpTOHVc/rGtISDTdZ1oUI/sqpGTfC1TEsPHuap225kjq7khB0vXv5lKJ7gsora3MW+N4Dupu7LiHP27cILTlHz+i6uBwZJPJOg69HX1iAdQOkSc4KxI4Opxg4Xc8p2MCGJ9iqCGXH6gJyBNK7OscomXPEYFgKmhFvgMtzu1UqStKSRo9FU75j9l+KIOgmph2jJ6/3XymfLw8jzruwAzid/VObwl4UKNyO1UjnbmG/uJ0wiFtDoyIggmqzbGn6qzzawM0EPYViRKvbiX1u405EyJMg9qHa7eDmLYGyRNNcpfnqNCnG3be6JorTz48zroJ45e4Nma8ebFGyKb4rpJ7ppm55C3I4RllsVuqa+3P7Jc9uQkQ1ub074VWhiLrZ5hd35b5lbA0CABrLamDEduPhoeY
 PKCnYRoW
 GtazZRhaeqMiKrxEiA1E+LSCVmAb9uRbcm1KWOWThOqWCt//B9bcwDojMRrOsD0frHpqTl7eoVxz08w7VWIzvllibztYQYIWnSVq/GrEsM8AzOLU092wN+RBVMntt2Nl2g1hytdpR9U/QLFd7f/cRTh84SsDqu8J/C5vAICW6gHeg9JA4PHhIxuuNN0A3JWyzXgBr84JzHnP6wQHfHuEwmhf6S1uOSxijB8B4rTt6f/0eYhQ6e1BusHz4Hy0G5tQp13afSTBrE7y8v25Qd7fQPQlL474ZNhjWaz5XYyWqkt1E743ZwChNaR1ZZNvN9RE0x+iwTthApKO7RBnXgAKhBZLaeFNKTcgzYPJWUPkyAUt/I5VbF6fr8wo8xFXAzZDohmc0U5/dcUVYlhiMhVfCvqFz/C2r7MF0uiJkFZQJOsIIvGAnWKFqyPVg0doIPvTToli335GtUoc4PCeHKGssp+Lw/R1N00/G+I1NIG6mr6FwPhgLcaKi+eDuYF+/0zeNgXz+ZqWG1NlD6cS+SIXCITbCCFsKwHZJijW4r6xBeiG6s4yc/N0UzkBmQCgcsrlF04f/+4VR3M43Z+eJSmXgNosF2Nxwi9ZawIsrA9AgztJaDabaQejR/51TBHr0carjeHC8xy0Y4Qwdr3WHIzQka/HgGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 12, 2026 at 10:50:09PM +0300, Ilya Gladyshev wrote:
> Some call sites manipulate page refcount directly based on its own
> assumptions of the refcount int value. Instead of making such
> assumptions these call sites should use high-level API like set_frozen()
> or init_refcount().
> 
> This patch tries to consolidate all page refcount implementation details
> inside mm headers. The main reason for this is the following patch that
> will stop using zero value for frozen refcounts.
> 
> Refactor external refcount API:
> - Introduce init/init_as_frozen functions and replace low-level
>   refcount manipulations with them where applicable.
> - Introduce page/folio_is_frozen().
>    While page_ref_count() will always return zero for frozen pages,
>    those functions allow more efficient (later) and more obvious code
>    [1].
> - Rename _unless_zero() into _unless_frozen() to deprecate zero value
>   assumption.
> 
> Introduce debug asserts:
> - VM_WARN_ON_ONCE() to prevent following scenarios:
> 
> page = alloc_frozen_page() /* page is frozen */
> page_ref_inc(page, 1) /* BUG: Increment on frozen page instead of init */

page_ref_inc() takes one argument.

> [1]: https://lore.kernel.org/all/aqAIFV4nOGPbWiDS@thinkstation/
> 
> Reviewed-by: Artem Kuzin <artem.kuzin@huawei.com>
> Co-developed-by: Ivan Gorbunov <ivgorbunov@me.com>
> Signed-off-by: Ivan Gorbunov <ivgorbunov@me.com>
> Signed-off-by: Ilya Gladyshev <ilya.gladyshev@linux.dev>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com> # p2pdma.c
> ---
>  drivers/pci/p2pdma.c               |  4 +--
>  drivers/virtio/virtio_mem.c        |  2 +-
>  include/linux/mm.h                 |  2 +-
>  include/linux/page_ref.h           | 43 +++++++++++++++++++++++++-----
>  kernel/liveupdate/kexec_handover.c |  6 ++---
>  lib/test_hmm.c                     |  4 +--
>  mm/hugetlb.c                       |  2 +-
>  mm/internal.h                      |  2 +-
>  mm/memory-failure.c                |  8 +++---
>  mm/memremap.c                      |  4 +--
>  mm/mm_init.c                       |  6 ++---
>  mm/page_alloc.c                    | 10 +++----
>  mm/page_frag_cache.c               |  2 +-
>  13 files changed, 62 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index 9334eb314663..2213214daa89 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
> @@ -148,7 +148,7 @@ static int p2pmem_alloc_mmap(struct file *filp, struct kobject *kobj,
>  		 * using it.
>  		 */
>  		VM_WARN_ON_ONCE_PAGE(page_ref_count(page), page);
> -		set_page_count(page, 1);
> +		init_page_count(page);
>  		ret = vm_insert_page(vma, vaddr, page);
>  		if (ret) {
>  			gen_pool_free(p2pdma->pool, (uintptr_t)kaddr, len);
> @@ -158,7 +158,7 @@ static int p2pmem_alloc_mmap(struct file *filp, struct kobject *kobj,
>  			 * because we don't want to trigger the
>  			 * p2pdma_folio_free() path.
>  			 */
> -			set_page_count(page, 0);
> +			set_page_count_frozen(page);
>  			percpu_ref_put(ref);
>  			return ret;
>  		}
> diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
> index e18dd736f2ec..e282f5e048b9 100644
> --- a/drivers/virtio/virtio_mem.c
> +++ b/drivers/virtio/virtio_mem.c
> @@ -1293,7 +1293,7 @@ static void virtio_mem_fake_offline_cancel_offline(unsigned long pfn,
>  	 * when going offline.
>  	 */
>  	for (i = 0; i < nr_pages; i++)
> -		page_ref_inc(pfn_to_page(pfn + i));
> +		init_page_count(pfn_to_page(pfn + i));
>  }
>  
>  static void virtio_mem_online_page(struct virtio_mem *vm,
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index dd09c438fa23..dab5621ad8f7 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1860,7 +1860,7 @@ static inline int folio_put_testzero(struct folio *folio)
>   */
>  static inline bool get_page_unless_zero(struct page *page)
>  {
> -	return page_ref_add_unless_zero(page, 1);
> +	return page_ref_add_unless_frozen(page, 1);
>  }
>  
>  static inline struct folio *folio_get_nontail_page(struct page *page)
> diff --git a/include/linux/page_ref.h b/include/linux/page_ref.h
> index 9f5c75d06f76..82ff3a99297a 100644
> --- a/include/linux/page_ref.h
> +++ b/include/linux/page_ref.h
> @@ -62,6 +62,21 @@ static inline void __page_ref_unfreeze(struct page *page, int v)
>  
>  #endif
>  
> +static inline bool __page_count_is_frozen(int count)
> +{
> +	return count == 0;
> +}
> +
> +static inline bool page_is_frozen(const struct page *page)
> +{
> +	return __page_count_is_frozen(atomic_read(&page->_refcount));
> +}
> +
> +static inline bool folio_is_frozen(const struct folio *folio)
> +{
> +	return page_is_frozen(&folio->page);
> +}
> +
>  static inline int page_ref_count(const struct page *page)
>  {
>  	return atomic_read(&page->_refcount);
> @@ -119,9 +134,9 @@ static inline void set_page_count(struct page *page, int v)
>  		__page_ref_set(page, v);
>  }
>  
> -static inline void folio_set_count(struct folio *folio, int v)
> +static inline void folio_init_count(struct folio *folio)
>  {
> -	set_page_count(&folio->page, v);
> +	set_page_count(&folio->page, 1);
>  }
>  
>  /*
> @@ -133,8 +148,14 @@ static inline void init_page_count(struct page *page)
>  	set_page_count(page, 1);
>  }
>  
> +static inline void set_page_count_frozen(struct page *page)
> +{
> +	set_page_count(page, 0);
> +}
> +
>  static inline void page_ref_add(struct page *page, int nr)
>  {
> +	VM_WARN_ON_ONCE_PAGE(page_is_frozen(page), page);
>  	atomic_add(nr, &page->_refcount);
>  	if (page_ref_tracepoint_active(page_ref_mod))
>  		__page_ref_mod(page, nr);
> @@ -147,6 +168,7 @@ static inline void folio_ref_add(struct folio *folio, int nr)
>  
>  static inline void page_ref_sub(struct page *page, int nr)
>  {
> +	VM_WARN_ON_ONCE_PAGE(page_is_frozen(page), page);
>  	atomic_sub(nr, &page->_refcount);
>  	if (page_ref_tracepoint_active(page_ref_mod))
>  		__page_ref_mod(page, -nr);
> @@ -160,6 +182,7 @@ static inline void folio_ref_sub(struct folio *folio, int nr)
>  static inline int folio_ref_sub_return(struct folio *folio, int nr)
>  {
>  	int ret = atomic_sub_return(nr, &folio->_refcount);
> +	VM_WARN_ON_ONCE_FOLIO(__page_count_is_frozen(ret + nr), folio);
>  
>  	if (page_ref_tracepoint_active(page_ref_mod_and_return))
>  		__page_ref_mod_and_return(&folio->page, -nr, ret);

Empty line has to be above VM_WARN_ON_ONCE_FOLIO(), not below.

The same applies to all functions below.

> @@ -168,6 +191,7 @@ static inline int folio_ref_sub_return(struct folio *folio, int nr)
>  
>  static inline void page_ref_inc(struct page *page)
>  {
> +	VM_WARN_ON_ONCE_PAGE(page_is_frozen(page), page);
>  	atomic_inc(&page->_refcount);
>  	if (page_ref_tracepoint_active(page_ref_mod))
>  		__page_ref_mod(page, 1);
> @@ -180,6 +204,7 @@ static inline void folio_ref_inc(struct folio *folio)
>  
>  static inline void page_ref_dec(struct page *page)
>  {
> +	VM_WARN_ON_ONCE_PAGE(page_is_frozen(page), page);
>  	atomic_dec(&page->_refcount);
>  	if (page_ref_tracepoint_active(page_ref_mod))
>  		__page_ref_mod(page, -1);
> @@ -192,6 +217,7 @@ static inline void folio_ref_dec(struct folio *folio)
>  
>  static inline int page_ref_sub_and_test(struct page *page, int nr)
>  {
> +	VM_WARN_ON_ONCE_PAGE(page_is_frozen(page), page);
>  	int ret = atomic_sub_and_test(nr, &page->_refcount);
>  
>  	if (page_ref_tracepoint_active(page_ref_mod_and_test))

Declaration block has to be first in the function:

	int ret;

	VM_WARN_ON_ONCE_PAGE(page_is_frozen(page), page);
 	ret = atomic_sub_and_test(nr, &page->_refcount);

> @@ -207,6 +233,7 @@ static inline int folio_ref_sub_and_test(struct folio *folio, int nr)
>  static inline int page_ref_inc_return(struct page *page)
>  {
>  	int ret = atomic_inc_return(&page->_refcount);
> +	VM_WARN_ON_ONCE_PAGE(__page_count_is_frozen(ret - 1), page);
>  
>  	if (page_ref_tracepoint_active(page_ref_mod_and_return))
>  		__page_ref_mod_and_return(page, 1, ret);
> @@ -220,6 +247,7 @@ static inline int folio_ref_inc_return(struct folio *folio)
>  
>  static inline int page_ref_dec_and_test(struct page *page)
>  {
> +	VM_WARN_ON_ONCE_PAGE(page_is_frozen(page), page);
>  	int ret = atomic_dec_and_test(&page->_refcount);
>  

The same as page_ref_sub_and_test().

>  	if (page_ref_tracepoint_active(page_ref_mod_and_test))
> @@ -235,6 +263,7 @@ static inline int folio_ref_dec_and_test(struct folio *folio)
>  static inline int page_ref_dec_return(struct page *page)
>  {
>  	int ret = atomic_dec_return(&page->_refcount);
> +	VM_WARN_ON_ONCE_PAGE(__page_count_is_frozen(ret + 1), page);
>  
>  	if (page_ref_tracepoint_active(page_ref_mod_and_return))
>  		__page_ref_mod_and_return(page, -1, ret);
> @@ -246,7 +275,7 @@ static inline int folio_ref_dec_return(struct folio *folio)
>  	return page_ref_dec_return(&folio->page);
>  }
>  
> -static inline bool page_ref_add_unless_zero(struct page *page, int nr)
> +static inline bool page_ref_add_unless_frozen(struct page *page, int nr)
>  {
>  	bool ret = atomic_add_unless(&page->_refcount, nr, 0);
>  
> @@ -255,9 +284,9 @@ static inline bool page_ref_add_unless_zero(struct page *page, int nr)
>  	return ret;
>  }
>  
> -static inline bool folio_ref_add_unless_zero(struct folio *folio, int nr)
> +static inline bool folio_ref_add_unless_frozen(struct folio *folio, int nr)
>  {
> -	return page_ref_add_unless_zero(&folio->page, nr);
> +	return page_ref_add_unless_frozen(&folio->page, nr);
>  }
>  
>  /**
> @@ -273,12 +302,12 @@ static inline bool folio_ref_add_unless_zero(struct folio *folio, int nr)
>   */
>  static inline bool folio_try_get(struct folio *folio)
>  {
> -	return folio_ref_add_unless_zero(folio, 1);
> +	return folio_ref_add_unless_frozen(folio, 1);
>  }
>  
>  static inline bool folio_ref_try_add(struct folio *folio, int count)
>  {
> -	return folio_ref_add_unless_zero(folio, count);
> +	return folio_ref_add_unless_frozen(folio, count);
>  }
>  
>  static inline int page_ref_freeze(struct page *page, int count)
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 7c4d86daf86d..b5966715bd95 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -487,7 +487,7 @@ EXPORT_SYMBOL_GPL(kho_radix_walk_tree);
>  static void kho_init_pages(struct page *page, unsigned long nr_pages)
>  {
>  	for (unsigned long i = 0; i < nr_pages; i++) {
> -		set_page_count(page + i, 1);
> +		init_page_count(page + i);
>  		/* Clear each page's codetag to avoid accounting mismatch. */
>  		clear_page_tag_ref(page + i);
>  	}
> @@ -498,13 +498,13 @@ static void kho_init_folio(struct page *page, unsigned int order)
>  	unsigned long nr_pages = (1 << order);
>  
>  	/* Head page gets refcount of 1. */
> -	set_page_count(page, 1);
> +	init_page_count(page);
>  	/* Clear head page's codetag to avoid accounting mismatch. */
>  	clear_page_tag_ref(page);
>  
>  	/* For higher order folios, tail pages get a page count of zero. */
>  	for (unsigned long i = 1; i < nr_pages; i++)
> -		set_page_count(page + i, 0);
> +		set_page_count_frozen(page + i);
>  
>  	if (order > 0)
>  		prep_compound_page(page, order);
> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
> index 6911daa9f854..8171711e3e7a 100644
> --- a/lib/test_hmm.c
> +++ b/lib/test_hmm.c
> @@ -1844,7 +1844,7 @@ static void dmirror_devmem_folio_split(struct folio *head, struct folio *tail)
>  	if (tail == NULL) {
>  		folio_reset_order(rfolio);
>  		rfolio->mapping = NULL;
> -		folio_set_count(rfolio, 1);
> +		folio_init_count(rfolio);
>  		return;
>  	}
>  
> @@ -1858,7 +1858,7 @@ static void dmirror_devmem_folio_split(struct folio *head, struct folio *tail)
>  
>  	folio_page(tail, 0)->mapping = folio_page(head, 0)->mapping;
>  	tail->pgmap = head->pgmap;
> -	folio_set_count(page_folio(rpage_tail), 1);
> +	folio_init_count(page_folio(rpage_tail));
>  }
>  
>  static const struct dev_pagemap_ops dmirror_devmem_ops = {
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 4f6f58bf3db6..ec620e0440d3 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3173,7 +3173,7 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
>  	for (pfn = head_pfn + start_page_number; pfn < end_pfn; page++, pfn++) {
>  		__init_single_page(page, pfn, zone, nid);
>  		prep_compound_tail(page, &folio->page, order);
> -		set_page_count(page, 0);
> +		set_page_count_frozen(page);
>  	}
>  }
>  
> diff --git a/mm/internal.h b/mm/internal.h
> index 38b1165212c9..3ed6d747b4e4 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -661,7 +661,7 @@ static inline void set_page_refcounted(struct page *page)
>  {
>  	VM_BUG_ON_PAGE(PageTail(page), page);
>  	VM_BUG_ON_PAGE(page_ref_count(page), page);
> -	set_page_count(page, 1);
> +	init_page_count(page);
>  }
>  
>  static inline void set_pages_refcounted(struct page *page, unsigned long nr_pages)
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index a8b03e2920ba..8d89e01ba105 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -214,7 +214,7 @@ static bool page_handle_poison(struct page *page, bool hugepage_or_freepage, boo
>  	SetPageHWPoison(page);
>  	if (release)
>  		put_page(page);
> -	page_ref_inc(page);
> +	init_page_count(page);
>  	num_poisoned_pages_inc(page_to_pfn(page));
>  
>  	return true;

I don't think it is safe. Speculative folio_try_get() can bump refcount
just before init_page_count() here. When speculative scanner gives the
pin back, it will drop to 0.

> @@ -1166,7 +1166,7 @@ static int me_huge_page(struct page_state *ps, struct page *p)
>  		 */
>  		folio_put(folio);
>  		if (__page_handle_poison(p) > 0) {
> -			page_ref_inc(p);
> +			init_page_count(p);
>  			res = MF_RECOVERED;
>  		} else {
>  			res = MF_FAILED;
> @@ -2132,7 +2132,7 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags)
>  	if (res == MF_HUGETLB_FREED) {
>  		folio_unlock(folio);
>  		if (__page_handle_poison(p) > 0) {
> -			page_ref_inc(p);
> +			init_page_count(p);
>  			res = MF_RECOVERED;
>  		} else {
>  			res = MF_FAILED;
> @@ -2462,7 +2462,7 @@ int memory_failure(unsigned long pfn, int flags)
>  	case 0:
>  		if (is_free_buddy_page(p)) {
>  			if (take_page_off_buddy(p)) {
> -				page_ref_inc(p);
> +				init_page_count(p);
>  				res = MF_RECOVERED;
>  			} else {
>  				/* We lost the race, try again */
> diff --git a/mm/memremap.c b/mm/memremap.c
> index accba23aef28..e1188122ba80 100644
> --- a/mm/memremap.c
> +++ b/mm/memremap.c
> @@ -463,7 +463,7 @@ void free_zone_device_folio(struct folio *folio)
>  		 * Reset the refcount to 1 to prepare for handing out the page
>  		 * again.
>  		 */
> -		folio_set_count(folio, 1);
> +		folio_init_count(folio);
>  		break;
>  
>  	case MEMORY_DEVICE_FS_DAX:
> @@ -520,7 +520,7 @@ void zone_device_page_init(struct page *page, struct dev_pagemap *pgmap,
>  	 * memunmap_pages().
>  	 */
>  	WARN_ON_ONCE(!percpu_ref_tryget_many(&page_pgmap(page)->ref, 1 << order));
> -	set_page_count(page, 1);
> +	init_page_count(page);
>  	lock_page(page);
>  
>  	if (order)
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 1533aebafb68..51d29ebe2074 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1013,7 +1013,7 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
>  	case MEMORY_DEVICE_PRIVATE:
>  	case MEMORY_DEVICE_COHERENT:
>  	case MEMORY_DEVICE_PCI_P2PDMA:
> -		set_page_count(page, 0);
> +		set_page_count_frozen(page);
>  		break;
>  
>  	case MEMORY_DEVICE_GENERIC:
> @@ -1066,7 +1066,7 @@ static void __ref memmap_init_compound(struct page *head,
>  
>  		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
>  		prep_compound_tail(page, head, order);
> -		set_page_count(page, 0);
> +		set_page_count_frozen(page);
>  	}
>  	prep_compound_head(head, order);
>  }
> @@ -2165,7 +2165,7 @@ void __init init_cma_reserved_pageblock(struct page *page)
>  
>  	do {
>  		__ClearPageReserved(p);
> -		set_page_count(p, 0);
> +		set_page_count_frozen(p);
>  	} while (++p, --i);
>  
>  	init_pageblock_migratetype(page, MIGRATE_CMA, false);
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 12fac9084c48..2744e069862f 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1606,8 +1606,8 @@ void __meminit __free_pages_core(struct page *page, unsigned int order,
>  
>  	/*
>  	 * When initializing the memmap, __init_single_page() sets the refcount
> -	 * of all pages to 1 ("allocated"/"not free"). We have to set the
> -	 * refcount of all involved pages to 0.
> +	 * of all pages to 1 ("allocated"/"not free"). We have to freeze the
> +	 * refcount of all involved pages.
>  	 *
>  	 * Note that hotplugged memory pages are initialized to PageOffline().
>  	 * Pages freed from memblock might be marked as reserved.
> @@ -1617,14 +1617,14 @@ void __meminit __free_pages_core(struct page *page, unsigned int order,
>  		for (loop = 0; loop < nr_pages; loop++, p++) {
>  			VM_WARN_ON_ONCE(PageReserved(p));
>  			__ClearPageOffline(p);
> -			set_page_count(p, 0);
> +			set_page_count_frozen(p);
>  		}
>  
>  		adjust_managed_page_count(page, nr_pages);
>  	} else {
>  		for (loop = 0; loop < nr_pages; loop++, p++) {
>  			__ClearPageReserved(p);
> -			set_page_count(p, 0);
> +			set_page_count_frozen(p);
>  		}
>  
>  		/* memblock adjusts totalram_pages() manually. */
> @@ -6452,7 +6452,7 @@ void free_reserved_pages(struct page *page, unsigned int order)
>  
>  	for (i = 0; i < nr_pages; i++) {
>  		clear_page_tag_ref(page + i);
> -		set_page_count(page + i, 0);
> +		set_page_count_frozen(page + i);
>  		ClearPageReserved(page + i);
>  	}
>  	adjust_managed_page_count(page, nr_pages);
> diff --git a/mm/page_frag_cache.c b/mm/page_frag_cache.c
> index e63efe78b7d4..56d19b2dea06 100644
> --- a/mm/page_frag_cache.c
> +++ b/mm/page_frag_cache.c
> @@ -143,7 +143,7 @@ void *__page_frag_alloc_align(struct page_frag_cache *nc,
>  			goto refill;
>  		}
>  
> -		/* OK, page count is 0, we can safely set it */
> +		/* OK, page is frozen, we can safely set count */
>  		set_page_count(page, PAGE_FRAG_CACHE_MAX_SIZE + 1);
>  
>  		/* reset page count bias and offset to start of new frag */
> -- 
> 2.55.0
> 

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

