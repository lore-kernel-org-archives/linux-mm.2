Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E187CD4F54
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 07:01:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6813F6B0092; Tue, 19 May 2026 03:01:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 633006B0093; Tue, 19 May 2026 03:01:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 548106B0095; Tue, 19 May 2026 03:01:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3FF326B0092
	for <linux-mm@kvack.org>; Tue, 19 May 2026 03:01:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BC324140246
	for <linux-mm@kvack.org>; Tue, 19 May 2026 07:01:15 +0000 (UTC)
X-FDA: 84783272910.29.9504B4C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id E0550140017
	for <linux-mm@kvack.org>; Tue, 19 May 2026 07:01:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q+Hl4ncX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779174074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XT3ZKvtwqPV2HX6g4ATqHs7emrxNjQTMKsjEOwwfW/Q=;
	b=tkjMLBkSoC1Sa+Ei2CRw7hSOBq18xJe4Y4wBKx8QC+lWUeLR8U8j02Xc0z4Mdd8QDkJhm6
	ZUhtI2J41NuzO4/4moQQF3v6rt/9KqZsDesiAcDMFCo8amQ5dyLBfNFKcL4LUeMUiunDSN
	01Obamz3fvNIm7phBLXmj+5rB4QqB9o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779174074; a=rsa-sha256;
	cv=none;
	b=HR191iDacZj8EwQvs/9hBVg9RoI+QdRy1nb7T4/hwbxNSrqh6rdJ0t0xD3sQe4MX9jjZNN
	wnbN+kmR89mRV0UOus9a8b4+mh31BHRa4JPCVo4y2MoW1YyAirHaLJA+4KzuJz4qRYvzK7
	tWmZY+q2R94mLGNYC6QOmKDi38D4EMI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q+Hl4ncX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 09AE24060B;
	Tue, 19 May 2026 07:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3B6C2BCC6;
	Tue, 19 May 2026 07:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779174072;
	bh=ydhiyI6PxW72PFtO7frRcKxo7c+s19WP4G/+SZBRhns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q+Hl4ncXv8KaiOJyG2laDlTRNidESgfQlOoqr0bCesfc3FGbaJXiA9wMBXzjTzoR9
	 1FepFODZeYfUG5ZRJJGVBaLa49G82a/UvaJwsbTBPN1AMIlhqRk5N35PaeZa64LQH6
	 7ofSx7ZyiIklWZqyKxSAXDX43+e7ZWfPK4TcUx9JFOpj/1Z94TRmxvg8rwb8+tzau7
	 Rm0ZyjN+fiN0g7Xt1ADZuWgcs14xkjOuX6ZfSeR+w6bVA97KA91pGlddGlhA/iBCr0
	 6bWgzN2iFBUCeLDQOsqmi7ndO8M5tMr4ulANx5haT1o2CQLo1Hf6CLLHEbdg3mfX0m
	 W2Po4OtH0oezA==
Date: Tue, 19 May 2026 16:01:10 +0900
From: Harry Yoo <harry@kernel.org>
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Pekka Enberg <penberg@kernel.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slub: Fix reference count leak in sysfs_slab_add
Message-ID: <gimwkjjpvwu2sg5625b3eeatw2vhv7rs6enm3vepdduhcefbf5@xen5iec7sn3z>
References: <20260519054720.1032616-1-lgs201920130244@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519054720.1032616-1-lgs201920130244@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: E0550140017
X-Rspamd-Server: rspam04
X-Stat-Signature: f79geb7u8x44631by1wuk9d71ou8qf6r
X-HE-Tag: 1779174073-946972
X-HE-Meta: U2FsdGVkX191TF3BdfiTuJrhPkYqUDgnzGXrnTmn1AwZCOmNLgRRGuvPOTlZ74oDFJDMTa8QPvTgaErzDfpvtA8EXvrN80YOgyKyoeQN7E0bXB+UxtqZkSFY5BQbgGHcWvCAP6YTQbnbMGJrbViPESMrZtqBvnyZc/xPlaJkG0dgIS0imtq44CI7Vq02NgxBgH9WhQrifX57HL9fNvFGJMtIe6BVgVT5KZWxTPs7KS1yqt5KLSQ8q60JF+gdI2eneZylSaJNwxUztSVw7PleC+DjuW7m3Dyo/zeo+jmOmJJD+SvsiS7xTuPD4hutgUMf7ZUpkgxZEwmU3H9cpugTr2xYE/sYpooiM3uajAM1Gskl4znXIsi/s9Y9NXvDfcRfzbfzpQ7s7UGT4dGpA0SIm+/imEc3SG+xilMEvkEVAoncnBAkpMvEvESypYp2YWV6xKo5B1Imti0H/W3D+gQlXsGSVPwgNOTPtkACD9xGCNbwoskPp5MDLtoIgiPdVziPC1kZcp46jFM7rxz4KGZ+NHxjo7zBs30EUT+siuAS0oJSVuRbjDomhMXS2GXZBuVcj45kn0QOg6DbiiXCprfC9g8BDt6OvDWRwcVV62gKV8uu9fChkdCzINBCBYEy0coRQad0ugyFx9bP9LEAK3sPzMvab55o5pn0nyfR0LzL/YK/TIopAwlHGZ3o69sXF3QVpa5m9jbk4CGGMuWIytFClMiA9V0NPqCxeYto90AzZkNxQBc/Np92H+oCI85EEnkrpMJumVEUmcv+hypnnz3Nr/wJNdiAr5CYA462LbzR0JcxXUcACPhPnroB2ys6pFmTEoCAzacMBpHJtnJHCRKMEcPNj2G6SWAxKUZTytVJ9fiOpzOBrfGcmVuO+LE2QfSutUR0W0JLHVQ2r4/RuiJSxaO04f8spy39KFogDNG1gJoQKNpFej4G22xKZRL5DHCaTDd3eb+o6iDPMGoq4ZA
 kXMy21wU
 b27q8lC+rl4rpCeczowW+ysZk4utWjiKButiAny+sMbg15XhcOhjbD/UkuOKFZ1fYTV/eA02A7EaUJ4JWccHpyoBhY7TpLPXfHzLunBVYn8J8fExqpMk+6QlG4sU9d2ajx5umdwg2V8FxcdL0YyFl4QsWA7W9AXnsyL/sr+/+PxbOeFXMlwKGcs1lZKnifhI9w6khjngugaVO3tLOwy1qbECfogBcGVVAlE4g0HxmjwMF8/XHoEcZ5xwAupmVVGh5E5AWNpDDIv5/QnUxyPUrx/fVhks0VklQTRqkvuDOJFvYMoc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 01:47:20PM +0800, Guangshuo Li wrote:
> kobject_init_and_add() takes reference even when it fails. If this
> function returns an error in sysfs_slab_add(), kobject_put() should be
> called to properly clean up the memory associated with the object.

This was done intentionally by commit 2420baa8e046 ("mm/slab: Allow
cache creation to proceed even if sysfs registration fails"):
>  mm/slab: Allow cache creation to proceed even if sysfs registration fails
> 
>     When kobject_init_and_add() fails during cache creation,
>     kobj->name can be leaked because SLUB does not call kobject_put(),
>     which should be invoked per the kobject API documentation.
>     This has a bit of historical context, though; SLUB does not call
>     kobject_put() to avoid double-free for struct kmem_cache because
>     1) simply calling it would free all resources related to the cache, and
>     2) struct kmem_cache descriptor is always freed by cache_cache()'s
>     error handling path, causing struct kmem_cache to be freed twice.
> 
>     This issue can be reproduced by creating new slab caches while applying
>     failslab for kernfs_node_cache. This makes kobject_add_varg() succeed,
>     but causes kobject_add_internal() to fail in kobject_init_and_add()
>     during cache creation.
> 
>     Historically, this issue has attracted developers' attention several times.
>     Each time a fix addressed either the leak or the double-free,
>     it caused the other issue. Let's summarize a bit of history here:
> 
>       The leak has existed since the early days of SLUB.
> 
>       Commit 54b6a731025f ("slub: fix leak of 'name' in sysfs_slab_add")
>       introduced a double-free bug while fixing the leak.
> 
>       Commit 80da026a8e5d ("mm/slub: fix slab double-free in case of duplicate
>       sysfs filename") re-introduced the leak while fixing the double-free
>       error.
> 
>       Commit dde3c6b72a16 ("mm/slub: fix a memory leak in sysfs_slab_add()")
>       fixed the memory leak, but it was later reverted by commit 757fed1d0898
>       ("Revert "mm/slub: fix a memory leak in sysfs_slab_add()"") to avoid
>       the double-free error.
> 
>       This is where we are now: we've chosen a memory leak over a double-free.
> 
>     To resolve this memory leak, skip creating sysfs files if it fails
>     and continue with cache creation regardless (as suggested by Christoph).
>     This resolves the memory leak because both the cache and the kobject
>     remain alive on kobject_init_and_add() failure.
> 
>     If SLUB tries to create an alias for a cache without sysfs files,
>     its symbolic link will not be generated.
> 
>     Since a slab cache might not have associated sysfs files, call kobject_del()
>     only if such files exist.

-- 
Cheers,
Harry / Hyeonggon

