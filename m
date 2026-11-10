Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B62F606A330
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H6h6dNkH
Received: by kanga.kvack.org (Postfix)
	id 983A86B05B0; Tue, 10 Nov 2026 09:19:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9347D6B05B1; Tue, 10 Nov 2026 09:19:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 829396B05B3; Tue, 10 Nov 2026 09:19:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 62D2B6B05B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:19:20 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 010EAA7F67
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:19:19 +0000 (UTC)
X-FDA: 85419416880.22.C0F671F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6749840002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:19:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H6h6dNkH;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794320358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NswPdYD+4dmbwkzDe2um0c4vj/yM8sDWJj139ef1Kl8=;
	b=2rb8aqPuejjtmRkIyrO+ACPgUeSJKao7eJIcap3XyWBxMlQsmhFWB6fuDW/F9Rwyuaei+V
	B6KofpoLwta7xVT9UMwV9JRPvYK9mRNvlSYivEBjlldz9iyzuAjxAExHaQL+ZDVsJMa3NX
	HT46I1qSh8fD49lPFK+F9fhQXubftT4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794320358;
	b=em8P2jS6ZqukBnMIuuUUUUi6CWBvf03it2L6g1wLHIemz+IP6YmA8vchrCWtFBl4vv9pTq
	gumaIGinsdQV9l6dbn8WZyiv2A4FZa2qqcukqnnqqVn2lMYB9cGx5kxd5LfKYsDVHOPtuu
	OVUo0MlRb+bvGFKPl62vJ72oPHrh4y0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H6h6dNkH;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A654B42E3F;
	Tue, 10 Nov 2026 14:19:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A661F008A4;
	Tue, 10 Nov 2026 14:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794320357;
	bh=NswPdYD+4dmbwkzDe2um0c4vj/yM8sDWJj139ef1Kl8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=H6h6dNkHfWawjmJeLOrTrBqKVCIjAE15bg6/SHpyCmk/j88xtvRteVi8bf4il1gZY
	 bZsIE5MekScVaw9uVsxTA5JBppNVKBuEEgUStb8DM4Y9SVPY04nITL58cs90uLnx1U
	 xbW1OJ5YwYKS9T8NmL58RLRoaFnklglpoYR7UuSFAzZjDb4tv4tZBmzA/zXdDu/XNw
	 R5CefROFZMzj9bIiMKlrZMFTRdYwegXbq6id6pZJ7aqt1UtNFWoNg2yq6QFNT/lNra
	 ftv1oeNQZO+LwXtRjT4jognUa8U98x1bKxIo66noOm/9Nlr4/jd0TI3yG96WKJGrIE
	 1MIUOVan+sgFQ==
Date: Tue, 10 Nov 2026 15:19:15 +0100
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Conor Dooley <conor@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 08/10] mm, slab: remove remaining compile-time checks
 for CONFIG_SLUB_TINY
Message-ID: <avMmmt4_pkknitPX@thinkstation>
References: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
 <20261105-slub_tiny_rework-v3-8-0484ce59eabb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105-slub_tiny_rework-v3-8-0484ce59eabb@kernel.org>
X-Stat-Signature: oqh9wuydgd8dyaaf3hqigj4i1ayuzs9b
X-Rspamd-Queue-Id: 6749840002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794320358-374284
X-HE-Meta: U2FsdGVkX18VTwCkzbH7B8/qVo5Bf4JVhGhX+MzHzSBBk5wJmv/JFHeUpfmYSbqcfrffVwR9F1W3/Pq0KSpCuoLq91AoSCy9/y8c6PPY3MheLZOQVQcQjYJNFjJ3Vj8oXrNL8EamWqsGqWFsFQZik8YBMKMElB3m5zOyw6eHnS7G1BSAfpSHBSROUDXdFoLItYLRmngut/qb+zswCPxwRtt0tvciA7SJuqEwZ25MTZ2TH6aY3jhaWqOKv5e/BLWrUayauYOL3CXgqJYI4FhCDhyGW7IUcHf5sfsDmvKYUKWQoD7/2+UBvSmrSDXB6SbzehBKeStmfKITwM3jipHmOTBtlM+7l8dDKJ9nGcEYdKh+59R79H9wRNvUXQ0s32yiHl8kbTuqBx+2iDv829+IC5jyG9FxVcxaHCnq7h93xFfRhfWoG7a5fONQdNVknPkdGhpN0CsvApKuS5OF7tCabbpWlEhEqBT6w8PIATajwo6Qba3FbzcbZp6t1u9cUrswg8i4WrlMR+Kr6JH8W0FZ/dEsKPeQBWZiaT3olof/f2Lq1YlgmFvii4k8uvJVquMMaD3vekStDVnuFU3yzdsYWg5Anqp/KDT7BUPGZMKYOjmIgq2BygsyoSBaJ9JD3tMJZunmQN3kyBzUpGfjoeZRKx/sOx0Y1cRUj9460dHwjG8syyrlFWfsc6E2WLyn6G2VKHggqSVw2e3aafW8pzOaEMcKSBeSeOp8d/9JVr9uFlnQfAzblYSpC9xqF3OAnVbdfcc6iU+rCPR+mjERYDHqS7y+eqRkBxH60JAcYMsXMvlD9l4a/vQKPVIOYFGoYJMA75BJlCcZJUmlR62fK5IcjhqkeDV+Re4ly+fMdf7RVPWMfXb9lY0QEU0xYYzMjWI/1vHPC+I3SDdmej1q8wCW1CiSpOELgA64QX8p6Hm1C3KCi4msnUAWQ/uAFzthLajbdBokQ6hZbB9RxVSJLDp
 40qO7q9u
 f+bk8wD76TrrZY+JtUH6k05FxPeaDkeICJIrEKuDUNf21ADDAypnR5KszhY28BOTcAdYUJ2ZjoWCSAx8MYNDcgtoLao0MUd96AdFUaQSbq5a/N/2qT6fm9WjB/TT8Z01gX4NGB6fABTmwirgKFJpKLxnfFd/8FfitvSyiwagoe3P/b5VT2vdK0B8IbmBUzReBFNfSfLJt3PNtW4gVkbxcFvXPnyvHsNYWTpppFKiXdgt/lcULMgIcqTLnEz1Qu4r3pUasePixoVI0Frc9Uu50V35qHfrDrBCDfIt+4mvyoIHkyIEBogqvW8FUPo5Sv8R/kBTc5vpergXjx6WsL2hiDUVqPVbSis0yDkxK2jlYOz204zkYCx5WcrewzLQFEEa+qfcCRmUHQCvtty/FWrEU25FCWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 09:43:57AM +0100, Vlastimil Babka (SUSE) wrote:
> Remove several minor aspect of CONFIG_SLUB_TINY to allow it to be fully
> a boot-time decision:
> 
> - remove check in cache_has_sheaves(), with no change to functionality
>   but only on code elimination
> 
> - remove SLAB_SUPPORTS_SYSFS dependency on !CONFIG_SLUB_TINY, thus
>   /sys/kernel/slab will exist as long as CONFIG_SYSFS is enabled
>   (for now leave SLAB_SUPPORTS_SYSFS around, can be cleaned up later)
> 
> - remove the control of __fastpath_inline so it's just a wrapper of
>   __always_inline. Leave it also around for documenting the intent, can
>   be revisited later.
> 
> - remove a comment for SLAB_NO_MERGE as we don't want new checks for
>   CONFIG_SLUB_TINY
> 
> This leaves the only usage of CONFIG_SLUB_TINY in slab code to set the
> value of slab_tiny_enabled around.
> 
> net/core/skbuff.c keeps using it to control SLAB_NO_MERGE but that can
> be dealt with independently after the config is deprecated.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

