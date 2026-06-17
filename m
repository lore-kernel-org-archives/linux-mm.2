Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F591CD98E1
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 02:53:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54AC86B00A2; Tue, 16 Jun 2026 22:53:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F4FE6B00A3; Tue, 16 Jun 2026 22:53:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40C936B00A4; Tue, 16 Jun 2026 22:53:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 186616B00A2
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 22:53:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8F0FA1A01D5
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 02:53:47 +0000 (UTC)
X-FDA: 84887884494.07.AA6C3E3
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 424FE140007
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 02:53:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EE4gYESy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781664826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=41Mx9FoeSF64UfuXJhcRsL5/0BftSoOC6T056MV8iVQ=;
	b=seePZC2s0ELx4/KHjPala49mgZi6WnRDx8VZXZkfyVX9yoKXoMwJgaHqBFY0Ix6mutknlA
	Ni+ZOi44rdRWXpKtOjZ4NiJWhe3XA3bXSU3e1HHvGdiXr5Gwvbr9quLiJr1KQDsjyuNhyP
	Sx6fKYWEiu6C0tuj687KF+HurS7FRMM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EE4gYESy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781664826;
	b=tcRy+O9B/btq/awi3xaqUU3wgu+euDLhXdGl8VDPw+PX6j/zfaLN4fz7zf/hHpp2NPaClJ
	XHF1mSmVFFsvj3L7ZishlFWarXmDmVBNNHQdgFtvZVxg/2WLaWaRQBiQFRJmmpJeokqT6p
	U1zIu9HO0dDIF/HejbfxgPimP7RHiug=
Date: Wed, 17 Jun 2026 10:52:59 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781664820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=41Mx9FoeSF64UfuXJhcRsL5/0BftSoOC6T056MV8iVQ=;
	b=EE4gYESyRB8TTGNIHYb4kgt24rizl6mFUDeVfxlZAjknr2uChkOftYLs53KZJNpJ2O9VCL
	ZxFUoBYIik/KhfRsNPH/gecYRlraV/RNq9WlMP72xeDGGP7aZAjVBz9hslnD+ebgiI2MsR
	ZxHmxyl8QFzu8IhJHod2M8NrWUMvSFc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v3 03/15] mm/slab: introduce slab_alloc_context
Message-ID: <ajIKP4pQRnPHsB6k@fedora>
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
 <20260615-slab_alloc_flags-v3-3-ce1146d140fb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260615-slab_alloc_flags-v3-3-ce1146d140fb@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 424FE140007
X-Stat-Signature: fedqp9ot8aiu1f5gihn8hdzges8mi8kr
X-HE-Tag: 1781664824-406749
X-HE-Meta: U2FsdGVkX1+bCGdisbPAJ/bImfv41SbzsxV3NLgL0T3bWtbVzt+/5llxTtDhwTzsv8wdvUARTmSXdD78xBT/Sfrb0dEmehgTMd5DhhyA9Gri+Cnb9/yzdxKBWI2y/jPXmXIPoY0UlMudlFTYNgUxAiNyHVfYGeuSOZ4cH2oUrXq6lMpv/u7Dq5L1eZZ/OAmw31Mi+d4V8gPocpFYyXCAQTzaJGc47fMqZc0z9YRsFw99pab90MQ+8a3QqSrIs9DGsxEcUqG/ii+IIy8aFmE8osPdThP9g/vLltpts+QYYE4e114V01sfLUb1Wy2V6ELjcOFzjnmmbXuTKAXi0vm1rIenoE/qDsou36AVCa5gEIQaJclCha2/O1gdqHolMgBbd5qmIjAMet54B8w7k3swxzkB/YZdHyFd56n6ehBL2N70l9iE6XL+aNe2QGRmZFuzx5yPgLgXM5bb139Umg0qXPaqJKKDrjot4URRjRYu6Rab8cqqUufbf+fHtu+Vfnyiu5UkJ2dtdI8BDD8tJ7sKEjL08i5FbXdi/kF9s2qHV2UByA9lbo0T+NEXXZrxedvYIwC/RqMokrynh/UbJhZoNvI0FhzzC6IPpBEJkunzuO0N26EI/AoHcYbeIwlF4rj3rz27RekQmQaVtDVGddHj3mcMoLwtCrYs1UKSexN/q8STwGkoaKrMS6nvvqqzuUOh9ZiHT5jHqiiWla6l6YKTWMLLHeSN/64uNZ86BTNlInxLacYB0KoyXJSBmOpvHFmFAvlhK04kJayutIpt39MclZ29jMkp9gRzPsFwjj9DwxDEThOPic5Hg+MjvTSGhImyRWLVVws3nXic+1BcWjDNsVB4dftdPu3ds83mnrTI9EvJkAVX544suhCoSe554ni4DFl1uPm0i6rPLWDvEhP/lt5Y43v5TbiISJjadfNUI9OqDuLXHOOkXUGX5o/CO/mi4ucKRqnw41ciB1couVZ
 vpjatFLt
 tQUrVn1z7t9i/snfqR5dG7vnv9DanmrI5YlTn5bRL79A6rrsDLYfaGFkkcjW3DRyPeeYdhiqv1v8WnyoMuKy/w/D3YcUuOnmBw8XYpLBkvYxMYGDKh3eppNYuq76XQyuwOM1J+QoKvN1o+H6XJvoCb0DW8Ud6+N0Rd9z8+XP+bxM3EKu7jd9mDNdPGASVIuWed0tFkQwdyneDQEnWSyTdwcG/zv4QrRym7jIgQtj+uIW/UiKBGaVLB7Am8gSxMRWx7muhrAaeWHsuOF+gvJOHHyt7GICa+hU+s+q0ZvcPUNMMwtNmlQ5dnHglPAW5GcPNAWhrNPzX4w2M52X2Z2SGjrduC78tqAfZAN5nj9ESp9kFVU4RW0sVavFKDJ+kyVshv43sdd0ib/K20yXRnPY98CJmDSjeykVEgmY1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 15, 2026 at 01:54:36PM +0200, Vlastimil Babka (SUSE) wrote:
> Similarly to page allocator's struct alloc_context, introduce a helper
> struct to hold a part of the allocation arguments. This will allow
> reducing the number of parameters in many functions of the
> implementation, and extend them easily if needed.
> 
> For now, make it hold the caller address and the originally requested
> allocation size.
> 
> Convert alloc_single_from_new_slab(), __slab_alloc_node() and
> ___slab_alloc(). No functional change intended.
> 
> Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-4-7190909db118@kernel.org
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

