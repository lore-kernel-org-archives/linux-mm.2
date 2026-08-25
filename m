Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21946C5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 09:36:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD9E76B0088; Tue, 25 Aug 2026 05:36:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8A6A6B008A; Tue, 25 Aug 2026 05:36:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA0436B009E; Tue, 25 Aug 2026 05:36:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A978F6B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 05:36:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 96E8B1C18D6
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:36:01 +0000 (UTC)
X-FDA: 85139285322.09.41C6995
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 040C780006
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:35:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CIjPpooc;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787650560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4jNx1gJfEgzXmkghh2FSeff6tzhWpWsHsfiEs8SThuY=;
	b=kLUW0anlV0OpnwevChGRqdzwRRcqLaLbuEkikDeCvS1LovWsH7MCPomoJToc2BEU26YIaM
	4fLitzs7kAFr0dIy/WUoFjW0Y4qywRpoBdSIpC2q/4zAENSCA+Hme493sTwdPuanksnUV2
	k9TSvm0UL/1BNBn8cVBlAKyUVGT9XeM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787650560;
	b=vu643CKXUTjJM8VoxCT+jzdCY315aVK2+qtSTPzSl3k/f/EKWzqTuqXc6eIEl7+W2jTq5f
	11zWm+wspuHeXbcAtTDaPWe3pq1O31xT78HCvv2ANEu01jf4c1o3mbM4jbELmrHWrQ4POO
	Ii0daGmGFyiP5f+igEvKxtGA9d3PCcA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CIjPpooc;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F8B443CAE;
	Tue, 25 Aug 2026 09:35:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024351F000E9;
	Tue, 25 Aug 2026 09:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787650559;
	bh=4jNx1gJfEgzXmkghh2FSeff6tzhWpWsHsfiEs8SThuY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CIjPpooc2Xah/nDriAfbFpP3Q84yeu3cwQdifVSKgCJWQfQPOz1TPxEX/KsFtTSo8
	 NUJk3GV5+czQRWM/srwmKU3KOqZj6mvuAqP9UFu3bycSQgLrlkhKRuV/oB9LFHjTfe
	 /WFja8R751+b4m8S3aPE7UzrxbqvxogZr7QNMHtkd2KMny3h0p6kOwsUA/dI95stF8
	 RQ+rP/MlSzQ+IH+35c8l5lhJ6B4VW+TL3Hbgqq0mguQy6ldnwRr8qXa8UHY2ZBFSlh
	 3oVokJLPQ2TbJJsR9Fh35bVkzO+nIz0Ed9ldrda7GOYPRBF2CgDYx9VHs/aVhQeQzg
	 MpUjUM1GbLmIw==
Date: Tue, 25 Aug 2026 12:35:53 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Meijing Zhao <zhaomeijing100@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Wandun Chen <chenwandun@lixiang.com>,
	Meijing Zhao <zhaomeijing@lixiang.com>
Subject: Re: [PATCH v2 RESEND 3/3] mm: memblock: synchronize debugfs reads
 with memory hotplug
Message-ID: <ao1h-Vxca7yPCin2@kernel.org>
References: <20260821020910.3428585-1-zhaomeijing100@gmail.com>
 <20260821020910.3428585-4-zhaomeijing100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821020910.3428585-4-zhaomeijing100@gmail.com>
X-Rspam-User: 
X-Stat-Signature: nt98amo583pt68s6cfgzpcpik4c9gnpn
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 040C780006
X-HE-Tag: 1787650559-605825
X-HE-Meta: U2FsdGVkX1+tr8/8BH3PiDZm8eLj0BZG96Sey959L0LCerqWYIP73BtzLXoNAGWRhObkwTKcoT3mK6A6KO0FUi6+ledZS5w/NWp+rnI/sHYu5JJfOVFpTvr7YxQT5ELBFhjZbAIu+TsoFKxvDD2HUyMAwPQtdIEJnAiqfslnB05tGQuACvtWb1vJcNrl3mN4LxXmJ9AEvVshKxvYPQTdmCVfgNtE48N6vYXr6LL+31YRvU4BaxgxKtY7QY3tkZ/jKMOk9bjy5DAWGgy1cTX24IHLE3gmf1dleQSoDciQHf/mrSvk0e2dELIcS6yHFG6MK/sxYg74QZuzc8oWwFrWOKq8cRCP7EkT0uW6Fu7ELJpRp5IrhLqi3xaHLuiiMY3lEIl89YM4ws85OXE5NulaIIArtDPsbuFSquRN0aCtD0MfaTiSlXesNbSj6UhzK+V2FTs89a3hINwX8nYttoHbLTUoQnUn/qDG+aCsChj4VSk/WKj7HZHmWteu4y/4K9myiOrbGLhiZYE31SxowHVZDanRl2dYrCFll9IEn6zf/D7kBwTH9VmkONnmBsNOoW6SNcgOgTUpfeY8TwY9HcB2LdcC+imrhezW0Mcio7oudfQQHmAJ485Jnrcb0LuH55w62+6wVEZfrD4raBbST2GpQEccmMO+yULtWzlwV3jCam9W9707HFy+PyjcR2jztQQIbqrBn3fl8OJMVlfp4hIU3lSQ/S1MObFxtUWwuxLNyQB6gWV++G8XScOiOMQSK6h8qFQVVm/ixrOXysDwR2balWXi0VM0+Id/A7Q0pIWSV4/IwB0004swUM+Doj5riRTw2Yy8ZVQe1ITiarY/RKpoYSw+L3IK4RlL4Sirsg2MIBk7z/9MllaqiJoNLA3JlB9ZKTDKylhUhDlmYmjXziBXEOxayKW7s+knTprunL4jZjL8/377Cx3Lrlxue/1KkdvHa8B8XjgPhllZpDWGjcQ
 rZ5Kojob
 EUPQbUwGB8QSlEg2gvavqVDy05uwzpxTzYwcBBD/R3z8PckxVBEa7+Aeo1qGjIKCMmFDLfqT4jrek7360scfhdsYds+rPQDf0CHnZbAXNzdH8sPCHP2vCgjKsnCBF1YpHvhTeA+/Dj1JhwtoY3pmAtzpMFRtECRqbDTmGfEVwXcxQZc5Shpyv0A3axi6ddfwAAZsyFeU/6tAhaJBaKabeg7y/zpefwaBwkM17Fi7TJvJS5ixat7XFIphskSytuDPf90iSBmXMRtwC2C6BrbtXMioamqaLKjOCCQt6wzjFvkMIaK/ioG9ProRNooo1CqgU5dX2hf0dqkJyHS153NrDMaHQGnTWykz7y1Ni
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Fri, Aug 21, 2026 at 10:09:10AM +0800, Meijing Zhao wrote:
> From: Meijing Zhao <zhaomeijing@lixiang.com>
> 
> memblock_debug_show() walks a memblock region array without
> synchronization. With CONFIG_ARCH_KEEP_MEMBLOCK, memory hotplug can
> concurrently add a region. If the array has to grow,
> memblock_double_array() replaces type->regions and frees the old
> allocation while the debugfs reader may still be using it.
> 
> Hold mem_hotplug_lock in read mode while producing the debugfs output.
> Memory hotplug updates already hold the write side of this lock, so the
> region array remains stable throughout the walk. The helpers are no-ops
> when CONFIG_MEMORY_HOTPLUG is disabled.

Hmm, I'm not sure it's the right lock to take here. With MEMORY_HOTPLUG and
ARCH_KEEP_MEMBLOCK there potentially other races in memblock and we'd
better to design proper locking for them.
 
> Fixes: f9126ab9241f ("memory-hotplug: fix wrong edge when hot add a new node")
> Signed-off-by: Meijing Zhao <zhaomeijing@lixiang.com>
> ---
>  mm/memblock.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 36a8d2a9378d..f1ddbcce47ac 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -14,6 +14,7 @@
>  #include <linux/pfn.h>
>  #include <linux/debugfs.h>
>  #include <linux/kmemleak.h>
> +#include <linux/memory_hotplug.h>
>  #include <linux/seq_file.h>
>  #include <linux/memblock.h>
>  #include <linux/mutex.h>
> @@ -2899,6 +2900,7 @@ static int memblock_debug_show(struct seq_file *m, void *private)
>  	phys_addr_t end;
>  	bool first;
>  
> +	get_online_mems();
>  	for (i = 0; i < type->cnt; i++) {
>  		reg = &type->regions[i];
>  		end = reg->base + reg->size - 1;
> @@ -2927,6 +2929,7 @@ static int memblock_debug_show(struct seq_file *m, void *private)
>  			seq_puts(m, "NONE\n");
>  		}
>  	}
> +	put_online_mems();
>  	return 0;
>  }
>  DEFINE_SHOW_ATTRIBUTE(memblock_debug);
> -- 
> 2.25.1
> 

-- 
Sincerely yours,
Mike.

