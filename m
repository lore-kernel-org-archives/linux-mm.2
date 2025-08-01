Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E19A0C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 00:59:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C7DA6B00C1; Thu, 31 Jul 2025 20:59:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 679466B00C2; Thu, 31 Jul 2025 20:59:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 567906B00C4; Thu, 31 Jul 2025 20:59:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 43AED6B00C1
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 20:59:29 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DCC9B13564E
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:59:28 +0000 (UTC)
X-FDA: 83726380416.20.9C86368
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 952F84000B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:59:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=a5+x+lWw;
	spf=pass (imf11.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754009967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HWGSRyHKDYyYoQd9gVbPetRMPdyqFOTxvd9o21Vtc74=;
	b=wMJ6pTGVthL15DbUryQapf1jkL/yd221+xRdHZNjr0svvwhGyUryX/JYArA2xIGhzDkdnC
	VD+6tGUZYVyiuwynGqKDhUzjzdcVuXwzfL6ipwsVb1N5koym1y9IebJGj1As+p/YPHk/dY
	fPaJJHhZ+vgZlri4gzx71wgX4Aq6otM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=a5+x+lWw;
	spf=pass (imf11.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754009967; a=rsa-sha256;
	cv=none;
	b=WqxdlCSD1VTcAeAXo1BEyOUSQSZH7ZXTB0B9MiPzb+O1qHesJJHEbHbbLlWvKKZgCxELHV
	vyjBaPoJZ2CVAlS3DqVwjHZbHW/gNvcR4+pa3TbopK+wGY+oT9GVucrhiHuK7o8G2wIiDL
	wCZu107DuZro7+YuCJxUkXMkk/YxP/c=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1754009962; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=HWGSRyHKDYyYoQd9gVbPetRMPdyqFOTxvd9o21Vtc74=;
	b=a5+x+lWwgh27jIIgY1Ng78/Lz3Pz7f0MCjDGF/k80oOcADfZ73HBgHEGauL+8WoAx6aSScIQu0CwFXX9F2ZyaODCgGbvpkLvYZQABIGtOGVFHzvRbOoE8EJs3ZbiFv3go7GwIpM4tc4iCGSIiAhdQhKPXv7KpN5zXQp2mSN9iHg=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WkZQUTh_1754009960 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 01 Aug 2025 08:59:21 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,  SeongJae Park
 <sj@kernel.org>,  David Hildenbrand <david@redhat.com>,  Zi Yan
 <ziy@nvidia.com>,  Johannes Weiner <hannes@cmpxchg.org>,  Matthew Brost
 <matthew.brost@intel.com>,  Rakie Kim <rakie.kim@sk.com>,  Byungchul Park
 <byungchul@sk.com>,  Gregory Price <gourry@gourry.net>,  Alistair Popple
 <apopple@nvidia.com>,  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  kernel-team@meta.com
Subject: Re: [PATCH v2] mempolicy: Clarify what zone reclaim means
In-Reply-To: <20250731210738.1451854-1-joshua.hahnjy@gmail.com> (Joshua Hahn's
	message of "Thu, 31 Jul 2025 14:07:37 -0700")
References: <20250731210738.1451854-1-joshua.hahnjy@gmail.com>
Date: Fri, 01 Aug 2025 08:59:20 +0800
Message-ID: <87ectvamc7.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Rspamd-Queue-Id: 952F84000B
X-Rspamd-Server: rspam06
X-Stat-Signature: zox9zgbsicuqfjauph67noss448f31jg
X-HE-Tag: 1754009965-237063
X-HE-Meta: U2FsdGVkX1/Wamotx0Lx770zFTk5zngffqOyCW24zlkfmoD6eUf9xHTmpaghgri8Zb6BYb8xElwmD5bh8d9Emkt4ArBZrJIppKEo8+zIR53xWz0Kp1GzC+OTISoTQHsHI5Wge9C2TFQPv/YQOKoXAUoeRjPYMQQssB4u7yD1ZAv389G93rAzD49i6PsCX3JsBu1+kD3PeK+X443sbt5VBLvd55WaerOoVHesj+sGG+zE0U6yFsmuA2M6PGiM4fS2SuK78uCWj/+ZkyFwoWDNlLPVewj8N56dAXAJe05DXr8sMs4EMJTfPT7IDybfaR4SlkEaJ5sEgDUekxWHZYZmMFmjtxm2CYBAeVgkoFfi9Qbm+85vTbFFCn+BYHzQJEtUpJUbj4EDjbreTclHL5x5l6T6cdHtxsSRFZhmUe2cBN6NMXgE6obV31z342TB4CoN3jCIQvjWFg+1Jr3y5z7fX2Ww0l+IhEgXyVj8NQ7dPL7y94dSfDpKPQ2Wupbx3cKaOEWvHyM7PDArzw5IpEGaU5Zdp2Ex1PZJwvdeTz2WF6mbNGp8jDjpbXPYtR7ZGKW4kW44to1+6F9P/6hG09MhmQye4Bkex/67+1laJgVoR9jyeDGmbDdetGLPe7j3PLRCaGdg0OOGFweaE5u8KTDF5u+Dg8BrfK4k7k1FokuTQwUYdLYMunoEXujxpQsoCQntOvBQWgwkn2b/stSxcCiftFtEN32jCo0gpDd6bs1MkShAfxCEQs9v5/XmiIWQstkYX8Hma3/lt2GNu07vnGIw6DCHlevXFl90k3VxqulVm+2rhYsrmyYDYjUtpsS1cLjoOgT74CHnMQLwdGn5iTXVgZUTpq25qgz21xLtBvYqXUbHkyAy+rBFLFH1peYZVYeG7/IYnCXFoqY6RfdPdrXLrHe2D5tFtJemMclOvPGFSGgsGImSNJH4dNzx39PnhQnSzwqvaseKtX9fzaOBxS7
 M/6Y5c9E
 QLlKaC7qWx3M+7vjLyu21TZyICjW2VH6kSBEmhvSXiPWNod7TlHQgdJrs64ryHU0MeuZVZNtzF3wjER92nlha0Vf7VXjFNgQ2OAxi5sx+I1TsbAoWF8CPAw+ux7hpsPP9EBIo23CtZzoxSKcfCI+SlF8I/OEfmyTPxtEKISInr5b3K70SWe4yqASzGfTWy8fXfMM0rVgu7t+B7JJNOoXhvAMH663joocyOPrK4NRSJhAxMfDoMx2l9QnxEKj621fAO9ygYcMdHkHKAebFngTjXF+M/144Y/OJOkTPLjLUx0ykI1jUZum1LSWGuiANTNEQWp3roPTk018lX/8oNCEcFZi1w92HFh9Br6l4kz1kO9ggJRy8lhDgfDXvmr2y1CYyT2ndFBIBtw/S2m3MP/yuHvBSPA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Joshua Hahn <joshua.hahnjy@gmail.com> writes:

> The zone_reclaim_mode API controls the reclaim behavior when a node runs out of
> memory. Contrary to its user-facing name, it is internally referred to as
> "node_reclaim_mode".
>
> This can be confusing. But because we cannot change the name of the API since
> it has been in place since at least 2.6, let's try to be more explicit about
> what the behavior of this API is. 
>
> Change the description to clarify what zone reclaim entails, and be explicit
> about the RECLAIM_ZONE bit, whose purpose has led to some confusion in the
> past already [1] [2].
>
> [1] https://lore.kernel.org/linux-mm/1579005573-58923-1-git-send-email-alex.shi@linux.alibaba.com/
> [2] https://lore.kernel.org/linux-mm/20200626003459.D8E015CA@viggo.jf.intel.com/
>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>  include/uapi/linux/mempolicy.h | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
> index 1f9bb10d1a47..6c9c9385ff89 100644
> --- a/include/uapi/linux/mempolicy.h
> +++ b/include/uapi/linux/mempolicy.h
> @@ -66,10 +66,16 @@ enum {
>  #define MPOL_F_MORON	(1 << 4) /* Migrate On protnone Reference On Node */
>  
>  /*
> + * Enabling zone reclaim means the page allocator will attempt to fulfill
> + * the allocation request on the current node by triggering reclaim and
> + * trying to shrink the current node.
> + * Fallback allocations on the next candidates in the zonelist are considered
> + * zone when reclaim fails to free up enough memory in the current node/zone.
> + *
>   * These bit locations are exposed in the vm.zone_reclaim_mode sysctl
>   * ABI.  New bits are OK, but existing bits can never change.

As far as I know, sysctl isn't considered kernel ABI now.  So, cghane
this line too?

>   */
> -#define RECLAIM_ZONE	(1<<0)	/* Run shrink_inactive_list on the zone */
> +#define RECLAIM_ZONE	(1<<0)	/* Enable zone reclaim */
>  #define RECLAIM_WRITE	(1<<1)	/* Writeout pages during reclaim */
>  #define RECLAIM_UNMAP	(1<<2)	/* Unmap pages during reclaim */
>  
>
> base-commit: 260f6f4fda93c8485c8037865c941b42b9cba5d2

---
Best Regards,
Huang, Ying

