Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30CD4F89248
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 10:04:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11F566B0088; Tue, 21 Apr 2026 06:04:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CFC86B0089; Tue, 21 Apr 2026 06:04:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F006B6B008A; Tue, 21 Apr 2026 06:04:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC43B6B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:04:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8B43B160C7C
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:04:58 +0000 (UTC)
X-FDA: 84682129476.03.D785E81
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8DD0C100014
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:04:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZGWjTiK4;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776765896; a=rsa-sha256;
	cv=none;
	b=QkUKr/srgZgyFkxCho4LMbdGN3zBKRvBKPUUBMqcpTlOMPidanYq9EloQeD+0dffks4mZp
	lIkO4jdijG8ZtQKnPMSM7nnBQIRDOGzYHh7VBunZjiBnt0zGCvEO6QgweJYJh++Kq3nlLC
	aAeN71IsRqwVsSjb9aLxWqpcKmHbBZM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZGWjTiK4;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776765896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SFnxsD9Omh+IviSYG2P3yyyQS1oydW+cwQLHoXW7ymA=;
	b=H9CziLWvjjtd/YtFQrlU8H90a9Clg3R1N7VfLIImAFSDS9DoDNy1KUWjaLaMA2e305+xnO
	bpKXaTJ7OXYzS3et1mX0gN3j6+D5KUbfJnMvu4CSiz8zO87hrOV0C3fid/BcXLwPU8pI92
	wc9qWBnMgOuANFn0n+2dDnvGeNitxS0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4EAAF437CF;
	Tue, 21 Apr 2026 10:04:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E589C2BCB0;
	Tue, 21 Apr 2026 10:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776765895;
	bh=tsk+Ia61mwK7qUKPBPYK2EDdHO8W7BH6sPRHl6yyybE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZGWjTiK4NnVuO+SLiafw12sUEIauaIcOB2OEhCSJl/e6FH7+3Y4/ST0uc9EXSfd7C
	 h6BFQdy6GiwZsL48F0wy8+rQ5PWw74EmFtyBEKEGDqh0by/WlXT6kvAMLxBM5b2V9S
	 Rm3cg1U7aMfkE10xkWG9rcARlgwj/Dv8eiCN1Mutx7tz78wwQMwnZnWj3ydgpPbfwP
	 m1Ie+9estCHvL/lPKl1qK67cNnasyOWlSTH3i1UZ0JzJfyaVAEVlQggKHf1er5x8Pg
	 AnPIEd+7vYz2/IT67KYU4W/UGFnYpUJ7FXHXEBgKO/tB5z7AoNuxPxF2jrUU6Y17D2
	 OLGxJkeP9hPCQ==
Message-ID: <0bb2d565-4b3e-4b0b-8e81-57898d8a2a21@kernel.org>
Date: Tue, 21 Apr 2026 12:04:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 00/18] mm/virtio: skip redundant zeroing of
 host-zeroed reported pages
To: Gregory Price <gourry@gourry.net>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Jason Wang <jasowang@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
 linux-mm@kvack.org, virtualization@lists.linux.dev
References: <cover.1776689093.git.mst@redhat.com>
 <c199e47d-b2fd-42f3-9e50-c47c848dc72f@kernel.org>
 <20260420192037-mutt-send-email-mst@kernel.org>
 <aebjG-qMLr0joG61@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aebjG-qMLr0joG61@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8DD0C100014
X-Stat-Signature: utpg5xk1si3sm33afe1h7cug68yh5ixc
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776765896-284122
X-HE-Meta: U2FsdGVkX1/8xeNgNAuTea1zsrrolJw2bK54X0FsvtBESDQ6NF9V4dGxKszVlVfN7jh50LhQ0032L+n5Z/kb2Wd2czL6YW55kyS9TufJY5qhPxng5WUNlD9p7LMFi/wbWgPuv+pzG/SO3KRlC64r3QAB5ki4oc8sOtzBYY24P/+X+AR/CuoaK0n7GghdNeyCvUCtFRwTAHwQSkOwahxAIZvctPPo1Uanr6OjCLxqHgRfK6/oSz7Lqh7F9juWMj0Vn+U1DvWQNSaoPStqgYpMWf20tz9iMh9sTQarGEZtp7GdzxU2xF+w3jUFv2O7TodjIw0HuTSvYUQLKNRQ2268X/Y50YHRvGZL3LMTzempGC56KRYY5UWYEn7wwR/ZjyvbrFpzyd31d7nEeDZEELKsF263+N0JOUGMH7H1Det5Fo/OE8T8tQkZJHMLl9SzyTrPoGGHV+EsjFnu72LNl1zK2tHJhIgqkigUL4UGHw5Z7JTyyy5l1lKnDDjVg5Ebtx90NcPMBpuB928/9+B5ookKCGDGbUvPVfQdxUsfS4nx7KWfcfk6L0L3mhd5ap/JTuS7n9LqY/4bdgobIPzW4v5YqixfNrK+5c76W7YPx10qhTEA47n36+4dfeaXGmDj9f0BvNTVO8k7iAx/O0ocWhvQ09b4oghVkdWZwjYKR+RM9/MxuSfA6kLkCesgJ55PiWfZx1y33fKwZdrPpCfOj5ZP7DvU1fGkK7uzQ0QxzBueQjc0L7bQv84QChnlw1eCboVMZbJsweEMuWsMgzH3SRYI2B+mQOPGkOGRZLVZcjHozysRlpVHjgiuCg22uzsLCf5d3rGtzq9ZojkvG4xzGgn2is7+nE/CtUQxs6NMhWXk1XYA54vCYYgPiZLwPpQFp6UjScUNfyeo5uF68b0taSGZR4wJ/m4D2PodLN3/+uLy7lN94YM4i8FKIlxE80MnwTAdEdVDuoS61hBBCI1FcU0
 p5Oqq8pX
 t00dbVfdvZu1Q7bCqnMnN0Ex+rR1kaFMw5u0rxb4c9pVOVygEnHH5RYIZ7nkxI9XDSzU5llaDnkebXx7uu9JPxh4aeN/tCiXCnpX1Ddv67PCIyuw2MsMz5FEGIZU46UVaptjkJIEoJpdlOKLU07TwlK429/hIEFt9CVmmRuuka2lc5VySD4tAzPFw+pGKvuGGmwqstDmFubgjqMVM9FBYXRjyjBKgZDl7HHlMd7TvA30FJYFgaSDUHlR7XBNXdyj87t4u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/21/26 04:38, Gregory Price wrote:
> On Mon, Apr 20, 2026 at 07:33:38PM -0400, Michael S. Tsirkin wrote:
>> On Mon, Apr 20, 2026 at 08:20:57PM +0200, David Hildenbrand (Arm) wrote:
>>
>>>
>>> Which would *already* be the case of you use folio_alloc(GFP_ZERO)
>>> instead of magical vma_alloc_folio() + folio_zero_user().
>>>
>>> I don't really see how vma_alloc_folio_hints() -- that also consumes the
>>> address -- is any better in that regard?
>>
>> By itself, it is not. But the issue is propagating the address from
>> there all over mm. If we miss even one place - we get a subtle cache
>> corruption on non x86.
>>
> 
> Why does it need to propogate?
> 
> Can we leave folio_zero_user() callers the same, but add a PG_zeroed
> check in folio_zero_user() that skips the zeroing (but not the cache
> flush) and clear the PG_zeroed bit?

folio_zero_user() is just an abomination, really.

-- 
Cheers,

David

