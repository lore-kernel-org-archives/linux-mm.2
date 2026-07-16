Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D916EC44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 18:06:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6A1D6B00F8; Thu, 16 Jul 2026 14:06:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B42896B00FA; Thu, 16 Jul 2026 14:06:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A802B6B00FC; Thu, 16 Jul 2026 14:06:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 865E76B00F8
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:06:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 057D51C020C
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 18:06:18 +0000 (UTC)
X-FDA: 84995419236.28.BE6D2A0
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id 43D21C000D
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 18:06:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hH6d6djr;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784225176;
	b=dArK/FK75HS5gtD1OZaM6pjTEoozK/0rqQtKfklBRr5jmOuYIsBsKftXxHKoMbe+SHHjQf
	Y/ouRLr1NXCSureo/k5bllCbIAAQQ2J/VddxS6VSMzQk5SMQ5rCy8egLsYnVfZx1nxfNjV
	1tQtyna3/tVFfalsKCVmUofCZPY/XzE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hH6d6djr;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784225176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wa6HtovuUo2/Dy2hy3Xy7z6a2LMOziGqXVtUFribJHU=;
	b=ar7ZyBrwK9C9koUR0Bync8mKPK+82zOYJNNXiX7AVJSdtw3LLRyNadTyNd/7YxjTz72O7o
	vmVA34SUAlYSPJjMMiMoH+lQ/gS+lVKTFUyj6OD8J/3mCNyaBNToRBCkneiF/HWLJ0ak9e
	Vg4LRhJvPkV/jsfbak6m3v0T8jiy+eY=
Date: Thu, 16 Jul 2026 11:05:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784225172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wa6HtovuUo2/Dy2hy3Xy7z6a2LMOziGqXVtUFribJHU=;
	b=hH6d6djrmw1ef58fFFFYFsvkVZ92ZppW59P9voPPHdc665uNYIzFhGLzMPZP2ZGdPi9sqq
	801Ygu1t4YD4auD8ZVD7TkAqfehlYdJe0XSS7uU6UgHBXHAT8g2wralfdLmSsdMKJQldbH
	QOhFCkXs1FrA2N7d3zviGEm+n3ZA6V0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Suren Baghdasaryan <surenb@google.com>, 
	Hao Ge <hao.ge@linux.dev>, Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	Danielle Constantino <dcostantino@meta.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH slab/for-next-fixes v3 0/4] mm/slab: fix unbounded
 recursion in free path with memalloc profiling
Message-ID: <alkdRqYW_Pg8r4sH@linux.dev>
References: <20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 43D21C000D
X-Stat-Signature: k4mog4ngu84gaibcrddnmm1chif4waqn
X-HE-Tag: 1784225175-461191
X-HE-Meta: U2FsdGVkX1+6E5WjZ/7kETIJ6KLB14V3g/lVk/QVJWXPunMc6lYb+/Lxgjdgk68yF0jY1Xk7ECsYm6hQSk5uIGg4nmTFBmiGZZHGBMeMrNGjSTLbC3WPGdpRh8VVnuUBmrhq/uv15QjAkK7IGUkl8sj92Pp08/dR0SN279UYkAjabgqGR00dUN7FIGERxCb+C76ptTQ/xW9V3519cXFZYXOgSgD9indYtj/XuxWFDooekIsVj57rNpdWsBkA/Kt7iTq3OrWsj/zCQvl6Z0EArnCirVlQNfF0Ea1HdFUS5/k0/s4YA+XosyxamT9OjpnJv7rSub/NIuRP50URamEmCTWYlcv629A/Pr+wqv3OXVRmYXnM6lZ4oh45eTPGghBI7DrU7X230HZXQbykkSudqhWIHtJkTXfE3FmRBqDdKRY1fAfEKIpJY7JnEDbSDAuKUUeEIicQ7yZ/4FEjC1mmLk2AmmgtyW3VL2YUFDYMvNtznFHozqFONEYgVCVsgUevqUqQWvLPbTOXlQs6ns16GcP3RaptrsNtIK9dKvbwEfMmG7ElX5iV5CW4HxcaE4JXAQA9PW5iTBt4SRr1vc5YKc30q2+GOvxy0zJPvF7Sfbogjg6sVSnF95qtBKo/XNK6kR8QK+9P6+5+HY7X/kBM1Z/OEYUqP8N6HmvX0A3YuMHUb10MKu3Ztwq2furxo8MG3wzXNwHLrMcEBDk3jVqsAVtnTOJp/mdB73mOTx+3J1aX7sMzhQG5N6q5K8yWaEzMHvCjaRDiuBEORaMZPzFhT+dUvkUywfjks/ktF2+LDzQKw1Z084cBTZ6VEDjjEE+RMM7fIyPppOFlK6bR/NcNRToWEUGQ3ZOEb8M5StmPt+ShATAFlhJNsYMScynwmaGSBorFatEbFo8LaoEdG1012lcp5N56ELn4tfHW71OoGEOMaP8VQHXxo9fdl8bVzGgEGkGlmB8JwVqK+OyewM9
 gzmHGiwG
 gf8il7miM7lDrlkVM7UffB5ktgW16iOqyavDdew6hpx6W0clWkHfrZ9KQ2PL4cGfgvCnMllf1uLXQT6Ck6d6enhHlK8s7Mn6sjzK+H5VOVQ4DUGujssda2InVZRnHBRXzNtz+B2iUZMiVAnqJ/mv/kmUhdW2c6CQmdw+KJjXnPKy2qXQzRPW09a6C/no56rgNSf7lWyWTwxPCtRRQ2mTl9QYX7FrCk3gg9222dQ7pwaD32wc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 11:28:48PM +0900, Harry Yoo (Oracle) wrote:
> This is a follow-up fix after the recent discussion [1].
> See patch 4 for the detailed description on the bug.
> 
> Based on slab/for-next-fixes (af9ea231c0b45) and is available at
> git.kernel.org [2].
> 
> Instead preventing cycles by bumping up the allocation size of obj_exts
> arrays, it introduces a new kmalloc type called KMALLOC_NO_OBJ_EXT and
> disallow formation of cycles between kmalloc types when allocating
> obj_exts arrays. obj_exts arrays of normal kmalloc caches are served
> from KMALLOC_NO_OBJ_EXT caches (that don't have obj_exts), and all other
> obj_exts arrays are served from normal kmalloc caches.
> 
> I tried to reuse SLAB_ALLOC_NO_RECURSE to make kmalloc_slab() select
> KMALLOC_NO_OBJ_EXT, but it was not great because it does not allow
> sheaves for those caches. So I introduced a new slab alloc flag
> SLAB_ALLOC_NO_OBJ_EXT.
> 
> To avoid huge confusion, I had to decouple "disallowing sheaves"
> semantics from SLAB_NO_OBJ_EXT and introduced SLAB_NO_SHEAVES.
> 
> While this cannot be directly backported to v6.18 and v6.12 due to lack
> of SLAB_ALLOC_* flags and kmalloc_flags(), I don't this will be
> particularily challenging to backport it. Instead of a new slab alloc
> flag, we can use __GFP_NO_OBJ_EXT to select KMALLOC_NO_OBJ_EXT as
> kmalloc caches don't have sheaves in v6.18 anyway.

Hi Harry, are you planning to send the backports to stable once this merges into
linus tree?


