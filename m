Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FBDCC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 13:41:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C64206B0093; Tue, 28 Jul 2026 09:41:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3C1E6B0095; Tue, 28 Jul 2026 09:41:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8E8F6B0098; Tue, 28 Jul 2026 09:41:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8117F6B0093
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 09:41:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE7F01403A1
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:41:10 +0000 (UTC)
X-FDA: 85038296700.12.DDC9010
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 58682140007
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:41:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UTxr3VNy;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785246069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=49vOlsz1vvSn3SCusf03wXkOOjUxUytKDLaGyr4qNYM=;
	b=Hn5S2uUPX+mYpb+/osdtNzIRhZJffU6j+4+HkjNCtj9bdlbIM7V6K+6su0oeCmFspv96wX
	EbpHvP423o6vIFmJExvh6jMvVTMxDH+epvbvWUSvX33asHOhI7+5/qyc244cPnFot01Q/V
	kbPUcTCPM9GhuHxOXYgVzFOzyKGeUZ0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UTxr3VNy;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785246069;
	b=uBMTg9HfkSDuXnQJnjKLzSvj3wPDLqRLFPHEq3vhlis/l8L7LIIKMRMxhrqI0Bx5gZTvxp
	wDNw6c4N1+8IEjieTsq/6aQRcSAioVDq5q8+8ClsD0PthpoB9PgGz+SlZLcgv4OQ2WpNqD
	l63DrdzhRvQzuVvXlPTAhHKxnvAKH8I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BDDA960AA1;
	Tue, 28 Jul 2026 13:41:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6EE51F00A3A;
	Tue, 28 Jul 2026 13:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785246068;
	bh=49vOlsz1vvSn3SCusf03wXkOOjUxUytKDLaGyr4qNYM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UTxr3VNy09n94NLv23qtAzTfJAA1tzEh2FT706IWQisOEW7UfErgqD9/+hBykrauR
	 8LBOQvvAl+S6cBuiTJXI4cSv0RFmgG345khRwwn5u4ZpChG1RhnYj3GltUYUqF1LJH
	 3HnK+A3hKFgBngyN92rXLeZUgJdJdzpvOCuWD6rrfsaK22so0qb8+TP+yDTgY1wg8i
	 KbI0HgyOU+osu7cywnY7Kke5ZYiNYxB6YK7n0ULro4YSy3CtRVPB+QZLnbJsOrSYF4
	 0iff+EZlgIBpjWai1w9efamVUYuLX+hMcBQrr9VHaY4dI/kEqOgJoihdcrBVHl48a6
	 Fh9JjZw36hSsg==
Date: Tue, 28 Jul 2026 22:41:05 +0900
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 06/13] mm/slab: abstract slabobj_ext.ref access
Message-ID: <amivCT7AaPux-GSK@thinkpad>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
 <20260727-b4-objext_split-v3-6-c29ef0f1f257@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727-b4-objext_split-v3-6-c29ef0f1f257@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 58682140007
X-Rspamd-Server: rspam01
X-Stat-Signature: psnxyz7rq3ppw59jbrfp8y9ng58djtj5
X-HE-Tag: 1785246069-617971
X-HE-Meta: U2FsdGVkX1/KvD7rT9lltJ/8H9uOtnh919x6n1tceRhNm1S72ubXxBDg66OZmVb24e7AwqiQR/Ef10YZQK+PR4BG9J354WY6ATkcOh3p1wRrW7e3OWAXfpOleneKCKTZhiZcVzdFgSDa8stMIRUNgdLyFtWSB8+SMyXLxijk6s9AYWXMkeXIjTpYHtKGsDCfJcReYRWr/SyhncoRyvT/cYTTOEfxBLJP8Twruf6DyFbCDqrkEN4hd/ctv4rFFcID9cxFeuoNwMBg/9nX7SnKr9ABgminryJvlVrfm8pDHvivAQ+PAs8g215Mo52ayu4CL/FH8pgpM7dJG+dXHlpDg4UllR15tZNJ2fAxfylUjLLiu0tbuDW9WhdvWS9sG5DNW5eza1ma+Cg+daBNwTqajvTHEIaEAO4yQZ8mu0ADWEutljzZCsCQt/bebtjqyjhbdbD9PGaeaHrz9bYBLGbnIEDsJ4EAtPxwqHeHCYalLtxzhg3WL1p9cCVl18ha9MHJLV2ysx/mdl1gns0vaCFkBFtnLwcNdmCJXU18yW5qg7LvunvGIvG8pbME0uAHx4ksP3SNgUeIjt+ExTnZ9tVxjHrpgOHS83ZEEU4ktBeOXmP09TyKWbuezEAB7HnCy0WZuw7qTy8T6SiysZFPLorqu5acljfRlW8Hh4iAh+6dv6EgrKtwcpkDAsow16vYIKTwyErZKO4YNf6GlhkCrSVnEIvPMMgaV0RTW/6r7XdqpEz4FHwWtAE4wfxXP1skBByt/yaivrSb/g6mUWAuL4PkyL2iWPITlT5d5QwV2c4pR9PoMI0Ecajp6I8wzT8U4bQHdqtDLZIs+4XQWAHEZ0hKS3wa22ZYbcILG3R0c4u9QaN3nIeT0DG2mtmWFI9+01SOC3m+Hy7gITkoshmO74tm7jJnDsSXHkqdAmW1aW1UtqrH34/kqoKMgxyRVOIH2iph6iWfrEnloL0YiMgEE93
 +pczTjF+
 9tZ1ClgXV3H+YsL0nBFeG1HomvvJdZ/Id0wyBGqM4ktOKoC89KIDIpG5ez751np8V5MN8LqGp3cgRfofMahEhqGFJC1oUvP7+k6m6b9i7kVQx7YmPHQqeHkczF+efQHIzAZCXaef7U2/dtPcS9/iuhsIMGlLAKGcudwdin0qIx0nYRBSkwCCPLZcZ+lctWOwfGG0nHHLF0C2PtzQOdhceqIzOGW3FsmHNfigd67174A3zSTxaP7FGbMfzD3LXf+8Nk1fwUIskoGuePXzBuP9mT2ItvSgCoME250Svn8CR1y486U+vpklTrdDh6dK4m2JEtjg79ZI4/hiGHFjhlbQnlL3RWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 02:54:00PM +0200, Vlastimil Babka (SUSE) wrote:
> In preparation for changes to the structure, abstract access to the ref
> field with a slab_obj_ext_codetag_ref() function. Rename the field to
> _ctref to make an unexpected direct access a compile error.
> 
> No functional change intended.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Hao Li <hao.li@linux.dev>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

With a suggestion: it would be nice to have debug warnings
that trigger when slab_obj_ext_codetag_ref() is compiled but
not supposed to be called.

e.g.) for kfence objects, or later in the series when we
reduce slabobj_ext memory (!slab_obj_ext_has_codetag()) 

Similarly, it would be nice (later in the series) to have a warning
in slab_obj_ext_objcg() when slab_needs_objcg() returns false.

>  mm/slab.h | 10 +++++++++-
>  mm/slub.c | 42 ++++++++++++++++++++++++++++--------------
>  2 files changed, 37 insertions(+), 15 deletions(-)

