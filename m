Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1175AC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 00:56:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5E326B008A; Tue,  5 Aug 2025 20:56:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A360E6B008C; Tue,  5 Aug 2025 20:56:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 972F16B0092; Tue,  5 Aug 2025 20:56:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 883B56B008A
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 20:56:02 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 35B22160303
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 00:56:02 +0000 (UTC)
X-FDA: 83744515764.06.B5A559A
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf14.hostedemail.com (Postfix) with ESMTP id B894D100005
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 00:55:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=lxma2KTC;
	spf=pass (imf14.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754441760; a=rsa-sha256;
	cv=none;
	b=UW47P4sHdCEDHaGdPK65FV1PpGs4hKqN1kYYGS2B4VDU+THGzKjvCr8QGXheQDhZdZuKt1
	t/KkL5SaM+njw2EcniMtKKBPqEJVyfWh9E+jS58Qj+8Ru2Kp5gxvxnqbV9NoZyr6OhxZpi
	/TD0sHu8cLRz0wmW1MWQ+Kjc0hsha/I=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=lxma2KTC;
	spf=pass (imf14.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754441760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Nv+Vg9VFAs7UldZj1lghwRAambUUpMnmtp1eMFhsOw=;
	b=WboJDNSXlBVm0KCme7yW+JwUfJz2Ab+8axpWFG4iDx/PWbTkSxhGJNL2QttZslhwf9dyZO
	wF4TZ2XJICKTJwp+Sfr7+JSRCglygAYrQ3g4ls9ZYFjgihLhX8MgqBrwid8w/3/U42UMSD
	fgHKPfEXbeyjZDpVyXN42uCC1oPWOKo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1754441756; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=4Nv+Vg9VFAs7UldZj1lghwRAambUUpMnmtp1eMFhsOw=;
	b=lxma2KTCEn7aB06q5MgZxVIR1/+pu5BcNr9IPJItLwSpPl32sAoA5Ok7aqvcqms3mkM6IqVrHfYXB/cx3zLB1R/VXaIl59Ye8qU3KqAbvV3lenazPxZA+rSbGrkgYfl+KvcyqtuYfb6/fPQ++Q4bjOJlb6DNoW9JjqWZuO0+a3s=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0Wl7gM-I_1754441743 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 06 Aug 2025 08:55:55 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,  David Hildenbrand
 <david@redhat.com>,  SeongJae Park <sj@kernel.org>,  Alistair Popple
 <apopple@nvidia.com>,  Byungchul Park <byungchul@sk.com>,  Gregory Price
 <gourry@gourry.net>,  Matthew Brost <matthew.brost@intel.com>,  Rakie Kim
 <rakie.kim@sk.com>,  Zi Yan <ziy@nvidia.com>,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,  kernel-team@meta.com
Subject: Re: [PATCH v3] mempolicy: Clarify what zone reclaim means
In-Reply-To: <20250805205048.1518453-1-joshua.hahnjy@gmail.com> (Joshua Hahn's
	message of "Tue, 5 Aug 2025 13:50:47 -0700")
References: <20250805205048.1518453-1-joshua.hahnjy@gmail.com>
Date: Wed, 06 Aug 2025 08:55:42 +0800
Message-ID: <87zfcduv3l.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B894D100005
X-Stat-Signature: a1petyxpzyxnu44ski6babkikzct4sgy
X-HE-Tag: 1754441759-777045
X-HE-Meta: U2FsdGVkX19/XH7AB4ioBUbUqewtJpE4qLIy78xtTBI32ujRixCSPWb1QTg4CmSWsAvRuYhRTfLgTdu+mX2glcG4yrm9/T43GBVHIX/aI6A/Q0pK3VY3Sa6Tp56UT1dIeRURBveRReUEr4NR5w6EAsO2X/Bcvj0uRmdV/kzPbM3CdNUtw++BP5qmLhrWdxGSA52Sn8rhRb50jFwBpk01MtubnSo4O5vlgTiXrxif73KJ/3zxLrVyKU6IMeBPEPw+k6Tvx6UBOaAs/V9cLQRS63XetrbQ7YKXEEM6IuLXVW1iaFp5/ijKr6LSaZM0eHpNDNOAFraOSf3lgJH8WF3B/1anW/8oGboYujtg35Ukv9y+VoCeE9UqaCJMUfcnUCS3XAT8NuGeNgX7thGKk++zPuG01EvOzouGTtVkIPBUKnaGOIDIxFJpsO42lvZxlLme0uIceamE0bTAtSxTyT2dnFxw9olcFlk+ZTHcbNRoqxQwpATP1I5jtBIy5lJickL5bc3v2+zblI7Hb7VCKydi4iaMfOvhCfqn+U80+P4e0QBqndKOrg9LjdsJBs+RwOVC9eQMN9fxbuyrzYuBn0tkcP65KXedP7hftFApJET6RHUxa8Aoquo4z0PJHziWPtnVOPULvI3cOSiaRSjSv6vdwijmZnCnKoVIYn1e7D7/Rw/HzyckC8CwRx0/uhLojbjsAhINtc+YKDyXNCSRzkF4ad3hREIxN/EVBflbi7prZRNZpV0S6BpWNrbEvvkaTDSLI34LG+5ybnG4v2BcdylfvoQznXNgIYVZO+xBj0naH+pripDn8FUNN0Y3E1ieBnzpEorDyVoa9OPfo6Qss5RsU7phJav4SVrin4jYSDQp3RNcFdq9dIeMc2tMhg/+qHnnQahzoBscO5t6ckzckwqgRCNJwKzX24yY8uI0tIo/pAQ0MMQSqfEDNjjtHeR6951ZP0Iwi/2yis2zTLYUvII
 GVTXk9+p
 BzTWdAJ2P1vXFR92fvrVAx6DkEaeGSj0GiNEYIx+LKrQCKvGUxjK5Rq7aB2xgK/83AT9NjTHPkSlKpVD49HYCNNFtsoANl0RQdt1+Ye4wl4vGgjL9FV0yIi1aKQDsNM3EGK9BvCib3DGEzYKNM7bqBulhF+ioYqsfrxVKPTem5uHwacxbCCv3BHvch+RwW+LrYKAjKumtjZhVQHBO8/6VL3KRV7oM6XIICrp4Ytw7cnechU7bIVAKvSoRandjZKQ/qqivIIdvQfpPeIgzQDkH3NalrwN4V7MdhRIFfq39M3a/tUoYvAeCU3ZEEz9n6rwQBqHzHINNyhATSA8saotNHsSuk3r5Fb5v5w5ABnQOpx/M3f7BV/Q7Rygs1yCq3Aa1bkN+rsT8m/R/7Ueex2buRRodru6Zw5N45nHy7HTa+D2L5hw=
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
> While at it, also soften the warning about changing these bits.
>
> [1] https://lore.kernel.org/linux-mm/1579005573-58923-1-git-send-email-alex.shi@linux.alibaba.com/
> [2] https://lore.kernel.org/linux-mm/20200626003459.D8E015CA@viggo.jf.intel.com/
>
> Acked-by: SeongJae Park <sj@kernel.org>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
> v2 --> v3:
> - Fixed typos
> - Softend wording from "never" --> "should not"
>
>  include/uapi/linux/mempolicy.h | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
> index 1f9bb10d1a47..683c130782f0 100644
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
> + * when reclaim fails to free up enough memory in the current node/zone.
> + *
>   * These bit locations are exposed in the vm.zone_reclaim_mode sysctl
> - * ABI.  New bits are OK, but existing bits can never change.
> + * ABI.  New bits are OK, but existing bits should not be changed.

Should we avoid to call sysctl ABI here?

>   */
> -#define RECLAIM_ZONE	(1<<0)	/* Run shrink_inactive_list on the zone */
> +#define RECLAIM_ZONE	(1<<0)	/* Enable zone reclaim */
>  #define RECLAIM_WRITE	(1<<1)	/* Writeout pages during reclaim */
>  #define RECLAIM_UNMAP	(1<<2)	/* Unmap pages during reclaim */
>  
>
> base-commit: 6bcdbd62bd56e6d7383f9e06d9d148935b3c9b73

---
Best Regards,
Huang, Ying

