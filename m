Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4011C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 14:35:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD2996B008C; Fri, 28 Aug 2026 10:35:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B82896B0092; Fri, 28 Aug 2026 10:35:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A99B86B0098; Fri, 28 Aug 2026 10:35:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 888516B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 10:35:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 00ACD1203DB
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:35:12 +0000 (UTC)
X-FDA: 85150925664.30.6273D29
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 032E71C0006
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:35:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ttw3JWgq;
	spf=pass (imf20.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787927711;
	b=2DVG1pGmWSbmlJmfsgHn3vhilEFMdvFI4de3XR4D7Ie37AJL9CTkzTPG6jcnLMdcS+uCfx
	WKmhiq4S4och67jG5tht6gsL87hBb6cZ8DmAQ2+jIwO5NxczTnvEA7se75yj0nwMTbkA3A
	U+uKahEofpVBt6muAHYVya9SuWRmWfk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ttw3JWgq;
	spf=pass (imf20.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787927711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X98NIGQPKg+8BL1yOqDNFmiYvUCnib2Cgl3Keq8DNq8=;
	b=VdWqxxUu4/2bOAOJ87h46/mvIbPhb6Cssecqli4xD7SBjlLjAOrxcsLDGnJdod0dtfafON
	4PqqlAUNYdINRj03thyaxzZ/tOovFdlsej+mmbOa31HTQ6dgQDhepUuJZBC0BFB55udqut
	3O3mGXQCS02UBr5Zw0TgQ16uQW0gZ+8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2AB8F431CA;
	Fri, 28 Aug 2026 14:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50901F00A3A;
	Fri, 28 Aug 2026 14:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787927710;
	bh=X98NIGQPKg+8BL1yOqDNFmiYvUCnib2Cgl3Keq8DNq8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ttw3JWgqNYV5trlA+T4J+dIMw+PPccTmFDjHPtV5ldhV352Ou+iRwpxOzR/YnVN2n
	 PZrQkRwOzfU8qQcXj/0pJkyLp09ydZFYrDCgaPhl+W7Twuz4qVnBqnmIFVEfb11ghg
	 UcIOreweXmta4MnUHvisAL6p3gRuw3M8yAHK+qWsCwNkZaPmcDVtZvyJvFTPwPWjmS
	 umL7X2ZOXGi8oZsKB4keyN+jztq0Qy6/FKsy6xUyyf4z5e6qP7N+Nwtq3ZBQS8Zj91
	 SNCZo1oft6Ret6h/p7cdcV5Apubb1yBX8gbIxOxL0cAIPQH2N4CXEN1s1+tJVcfXa3
	 oEMGw4VX292yw==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id 52C35198008C;
	Fri, 28 Aug 2026 10:35:04 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 28 Aug 2026 10:35:07 -0400
X-ME-Sender: <xms:l5yRarcPRM80BNt_5aHC1xO0r_gvBz4bDVyiZHDXrDOiNDgIzur_hg>
    <xme:l5yRakUd8Wc6NL_qZ5h8G6qBbE30XTs-Jt7ReT9ovn-mkInkh7AURYX8am8VDxAl8
    ZDfPV6aC7zhs2ZP4ismfFfJUf037nclNuqiOOskXlVyROGnx0ocNAci>
X-ME-Received: <xmr:l5yRah8G0tfniwzDLxB8WVU8F3Jgy7vppsnErh2NSXLdQXRf-L5DUyKDUSE>
X-ME-Proxy-Cause: dmFkZTFr1ErFwYp/sqUKdif/sqW6Wb/VLBv2jg+httKCJi0/AiJZkNFzvc+y4ea1xp/ZET
    2BvSs8QnzsnCXfGgp2ktatqoulkesBfNz9bNdfY+uqmeKUm8+9HL7ZW9s56lkxowNkQHlS
    AjzdH/bRfIsBF/KnwpBnDG36NrdV3UW7HS6CG5RjSJMhSI4bpm8wI9kR6EVyq816yX8vGf
    mRUeK7k3IA6El8JHfKpYwDBMH4psiZovq5zMI+LxcFqzE9+a0akPdGqZRuIJ7dGqwZ5MQT
    +9kkWrZXPfiDaAA8/1kCqtOBnBva6b1YGyBkk9gQTnzIMyRZEGeSRoa5mI+ZJTmrtyq3dC
    /nUCEZPuQ2cFYPEkbhCQN9LmCZisqrhzK1YHzoItQBRLyPB6dljqFRiGftTCfOXdrevsNL
    H0bBBZUB01hFRlOT4YV67+KOI1zTNOR+HuxbIbNLC40+7/gUg9TU4jihypkbo6PjhwQgwJ
    DfLZcSVXiNu/PpssEtSApwapZhxvgFGbop+tHpV7Md0Q5kViZBZxlKAahyhRpEfPEP74Fz
    83Le96qvmhI69sQIroizEz1uSe/5KwR/x+dml0NZFHXTBMwGCbvSVOJpRktkFUUtp0EpBk
    yVnh1glRHSqB+gOxq4DTr+wtKmcZNouvSfDPqte9/hIi/8Ifqb0rO/pcQAEQ
X-ME-Proxy: <xmx:l5yRahj0oiv-fevYFaXsx6GjkNiVTBgYAQT8083bvNLeZRlJ8nwY0Q>
    <xmx:l5yRamWsrAxPFiBPUGrV0oMHaTPO5PyClkuGdJUCYV2qoX9nSwnG5g>
    <xmx:l5yRaosIDwkm7IkEIS2Qd8I-3tdOeCQ-wyHH6czifFXyMseGWt9fpA>
    <xmx:l5yRag43aZFdWKQ_Ki5udhyfQo96KqOf14aWRhL9ZC-sWkfos0KWwQ>
    <xmx:l5yRanWawyaciE_RzQ8QiinNDbBWtMHmM3KINcLCwMwmX3zAXRQIdG-T>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 28 Aug 2026 10:35:02 -0400 (EDT)
Date: Fri, 28 Aug 2026 15:35:01 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-efi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, 
	kernel-team@meta.com
Subject: Re: [PATCH v3 5/5] mm/memory-failure: efi: replay the poisioned page
 in the next kernel
Message-ID: <apGbDOnPm5VXP5ez@thinkstation>
References: <20260826-hwpoison-kho-v3-0-6f79c4b605bc@debian.org>
 <20260826-hwpoison-kho-v3-5-6f79c4b605bc@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826-hwpoison-kho-v3-5-6f79c4b605bc@debian.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 032E71C0006
X-Stat-Signature: rurqxamwu1uzragg3ebkpmuayn87g8di
X-HE-Tag: 1787927710-880843
X-HE-Meta: U2FsdGVkX18NyraMfXeVnuoCoaFi9vaDSvkxBIqO4eAYPzwhbYRVz4U9LoWQ8mAZDUiWBF2r+1nPvQ/GZ5JkusdDjwgYjI2WNWjOpPAicEJkvJBXETRrUtymRFAZPqry7bnTZkK0kwBlsdT7EpEcLoQzUeu2BZLbO9TrvgIbH2WrcacoRGbivBTxhDs8PKjXVEjzxoYqCQNYO5xg+KcpIhhFMzsX7OYLju6rT0gzjf0fmgyFHgBIzwZIYXde4ccHiz9H8bKLCcJsLQl8pAR8wZKiWiTQ2uvDYX16gMEZVGUiel7qC6vAViznmhRfoOCcgjMl/gOHb482uoQofBHXiv1s5O/hVqCKW6qrJeWIkOK2Cm7H4/qrDK72Le6zGunwNJnSfL4t48eBWZEgVAbpa4x40DJslc0j5h9HZ/U2EvRLOsuLi0bf9GKsJD2JpWPhpKckoZei7tR2fnE5ZctxJx3nxe+LPTspv4W0wPx8GVPifr7JzPgcUCgJqSIJ1MiqGkJXBWF0XpTW4Zoebd6wsg4rJr4c8KD3CZdJZTa1ewB+gFsKalJXlbKboiPYKnwndiadiTH0DvOIt6qqKr3l/Ja8wDNWlrZfrZyMk59WIzu7d7glG1JfU0vYv0vpGQEtUp9+kyMEk3Hpr73/HJjxRXP6gEJaPzOLxPXZ/H/+6oFDZGnCiQNdjDjRhYjo7lO1SykRX7GCHk8GLua+CJ8SYhXcT3DJiAvBnrLlTrHJQ7CwkkWErSc+aO50aLTHeUKG2ghGVxtbtN0+woXVt1maxx31+PdP8bz6I08mVt9LZQQCjwdqYnJLx2sWS61xh3LTuUSBLTJg/cdSYB0Y4LUoyzj2SJ856LcZK56AERt24gMGETqp9iMqibYuQ5Y1SfjS57dzCuNtD+M/q+a6RnzxVZH/+19LHvpjc91QcdjNcvPqdTHAdnvoC8VcqqArDoUT6arFV9wRXgn6CqRz3uA
 pudMgikE
 omfD7ueHUIacth7XTcRwTtw9VHlLES/1lJP8lKB/uTbSfCRegC9J93vr5UZb6uJDu4PxuIOLbpf5M9IDq2FC/6/KPBjNEBn3foqZv0gridh4l2y08aIOtLp0D2a7Q2kOxHzQmDPdwxH35mvyOmp6f9ny9bGlOAE6YR+fKD5H2SdamALnCKcFys3b5w+AdaNPhaaIgQkj2bFs+AGl/VD2SVyl6200zEHt9P9rCWKasZ1TjsOgUX0zfOBH0IEhPTo8pNyleFuKSUMcuY8Eldls6MiIp9mWVJ4Ze5NsTM1ASBBsfExf0iTRcKLiZIGFyIgpKPLhI9aVR1e9BwhLzfpZllOFDl3RmWH+uH0ap
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 05:03:56AM -0700, Breno Leitao wrote:
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index ddda9d6837f32..f94fa221da0b8 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -2667,6 +2667,7 @@ void __init mm_core_init(void)
>  	kho_memory_init();
>  
>  	memblock_free_all();
> +	hwpoison_init_boot();
>  	mem_init();
>  	kmem_cache_init();
>  	/*

I don't think it works with deferred page init.

With CONFIG_DEFERRED_STRUCT_PAGE_INIT the struct pages above
first_deferred_pfn are not initialized here. memmap_init_range() breaks
out at defer_init() and the rest is done by page_alloc_init_late(), way
past this point.

But I think the shape is wrong here, not just the placement. We should
flag poisoned pages on the first add to buddy, not after the buddy is
initialized.

__free_pages_core() already consults the unaccepted table. Adding youre
case there seems logical. And all three paths -- memblock_free_pages(),
deferred_free_pages() and generic_online_page() -- gets there.
No need in special-casing for deferred page init.

It also closes the window where the page allocator is live before the
frames are taken out of it.

And patch 4 seems to be redundant in such shape.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

