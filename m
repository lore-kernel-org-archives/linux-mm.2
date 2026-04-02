Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86158CC6B01
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 04:02:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A88446B0088; Thu,  2 Apr 2026 00:02:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A39306B0089; Thu,  2 Apr 2026 00:02:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94EDB6B008A; Thu,  2 Apr 2026 00:02:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 811CA6B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:02:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 39A371A0398
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:02:49 +0000 (UTC)
X-FDA: 84612269658.05.3A53E55
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id D283E140007
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:02:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eiA0a3IG;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eiA0a3IG;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775102567; a=rsa-sha256;
	cv=none;
	b=0gW7kZNgAiKJEsWE2x26X8D8k3HAV9ryxfV/5V8XJAoHPnngyicrznltb03Y240dDhyCPX
	NpjxngMCCUyP6GB8Glf+izxkWLXVXl6a9SJUu+ad05+VYYL/qcz2w9z5zZp/a6xAxU3K2R
	jkb0DORlKscwnp6UICSEHJXYSGUv7sk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775102567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lm90Qq9Cm5RCcVEpvAMpruorcfH9KoxwoU7piv7WLz4=;
	b=CfjMKWcMD8AsF/F5nypqvXXFkKwbBiEl10/720zXu2Ou0jMY5XK3AGpUGxaW6ajS/Xt3xF
	i16v+kbZPnrxUsKsoAuqY4KQB39P1JLBcr3NyWXXCRk9b10yQ74HNiCXvagFIcdzC37P/n
	frFhpOlsvbwNoW6WysH3PkVelz2xKpY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 43ED861855;
	Thu,  2 Apr 2026 04:02:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10346C19423;
	Thu,  2 Apr 2026 04:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775102567;
	bh=9+/dwINtJN/cpLno+AS/FdsNHwehhVrZYUkBkuZRdV0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eiA0a3IGgNwJ4HH3TnA6dyjb9dEiE9csmalxo3g235EFn4BNVs1OVmMMFeA7ns8Y6
	 6B5y4hj47Lgh0IVXGvpD7kIqbLP0/cclM1/3/8lXLq9PAaAOL+dBoMsUMZ3Iuc1frV
	 2VZhWJrO/voB3qaPoleaiUt38LLLJNw+Md1flLGM7wtGyNKYxKqBBsK6ea3zn+lrce
	 +b3HT6pWP6ffo5oBbPB0VRsnxc0OYfj8XXm9GcGKoCn2ztxOKLry7K4s43bdVd9TZK
	 G+Aq430kB4cIf+ZFWQGpUVSNGwEb3CALBTyXu/xpmzv3z1TPHD1R1JpO0xdoi8CAT3
	 AS7Vs94KysHaQ==
Date: Thu, 2 Apr 2026 07:02:40 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Peter Xu <peterx@redhat.com>
Cc: David CARLIER <devnexen@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v4] mm/userfaultfd: detect VMA replacement after copy
 retry in mfill_copy_folio_retry()
Message-ID: <ac3qYA40OW29ibbq@kernel.org>
References: <20260331134158.622084-1-devnexen@gmail.com>
 <20260331200148.cc0c95deaf070579a68af041@linux-foundation.org>
 <aczOCqrCx7Xd5HIF@kernel.org>
 <CA+XhMqzdQLZD4YWzyZfTwd_+sDnLqj24APqBRgum97_=8EcM2Q@mail.gmail.com>
 <ac04ZeFdz7yvByRp@x1.local>
 <CA+XhMqz083g8D5xQ5bWNrWguwdBhFv9miMooDhDf1+862ggzNg@mail.gmail.com>
 <ac1wW6LHzzkXBeSl@x1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac1wW6LHzzkXBeSl@x1.local>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D283E140007
X-Stat-Signature: qh9p6snnf4316ic9zu9faqnzh3ftgfdk
X-Rspam-User: 
X-HE-Tag: 1775102567-7916
X-HE-Meta: U2FsdGVkX18AhmrOcOTuWUh9FgzKEBqOT/P4Hln0zgb3XAzsSEveHMY2OjUFASf1JkuZSgYeYgNK9NPWNYOsNR3FyupTB5fqeUuaJ4i7HPqQDlHErhQzFvaVXNVZtYc+r0fpokaeN8C2AU246/MZZPy4//05pNTb5c3w/RdYylPtkOysu0W7SfEsKe+rC/VPKv7YxOJBkcfDyyHiW5Xnrfr4hU7hTb8oOHfX2S3dWqgaBQqPRDEjysjSL21VVb3POATMr1opKxQGHbAM+sG9D2CBRpgb0tQn34jF0M2HYTQRGbBDYFgDRhGPtS6tkh41/tIe4o/agNOD7yIaRiph2MJJG3z9oqCHnkn53xClRdYltoEgthSJPKim36minfYzcgRiJOYmPYHMn5pIJ2khGL6EhPi7UfACvUYT1h3DGhpjE2mgEXtaTi2BcrFWsKl6BXRvDau/IXbMG269PaEQ3ldWAjzWxN6HMq/rfhf/42WUpF07OqWPzm8GTOaVxH2AOu7oq6C01qtuY+3jZI6YfflVT++MiiQDVdLp4zvjh1fnpe9rpK3hJRbnWZXcL4Xs5UvRTZAy8rdl0R10C+79l+FudZKvGIZDh6u2i0Pgd5V760zI51qD/SCoVNaNmzKRGPUSEhAbXkZdBq8UWisPrSmh650Wzh50fKRK6f2s0HF4W918RnzRP+H/i7SLBotGgjdIYBsLRhzyCxEg+R3INSOqHKc6Ffn5xpRo841QDAEw99Heah4v3IoclY6IL+KwEjKUbDi0yCHYAqBTypc6K02pV+Lt+gG38sHUzI9HyZvzaGdGDdzekkryYmYHD9IAKKiovxnLrWuFnujkwsjDEvImVUoyfiKPy7L9qzPX2HJQ+0XihdbXGi743/HHo0tB9w7niD9VLe/ww8GFbh+alGpenHah9zGp8uEK/hcAnyKhV1VOBCMU7YZpxw25dhXVagPUOTvhCerLXUfuMvn
 pLaxQxyV
 DpPP2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 03:22:03PM -0400, Peter Xu wrote:
>
> The other thing is I just noticed the err code was changed to -EINVAL for
> snapshot changed cases, sorry I didn't follow previously as closely on the
> discussion.  I think it should be -EAGAIN.  It's because the userapp can't
> resolve -EINVAL failures and app will crash.  In a VMA change use case, we
> should return -EAGAIN to imply the app to retry, rather than crashing.

No. The return value should express that the VMA is invalid. -EINVAL could
work, but looking now at the manual -ENOENT would be even better:

       ENOENT (since Linux 4.11)
              The faulting process has changed its virtual memory layout
              simultaneously with an outstanding UFFDIO_COPY operation.

> Thanks,
> -- 
> Peter Xu

-- 
Sincerely yours,
Mike.

