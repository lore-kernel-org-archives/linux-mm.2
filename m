Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B08BE83061
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 08:18:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 629806B0005; Tue,  3 Feb 2026 03:18:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D6D06B0088; Tue,  3 Feb 2026 03:18:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E2F46B0089; Tue,  3 Feb 2026 03:18:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3CD096B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 03:18:22 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CA0318B8AA
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 08:18:21 +0000 (UTC)
X-FDA: 84402443202.08.178B32A
Received: from sg-1-101.ptr.blmpb.com (sg-1-101.ptr.blmpb.com [118.26.132.101])
	by imf11.hostedemail.com (Postfix) with ESMTP id 510FA40006
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 08:18:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ppteeARE;
	spf=pass (imf11.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 118.26.132.101 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770106700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ro+94Aa/uxuiumnNVETAoZZO1z2xqW2bzXYXE12GuYc=;
	b=Fop9UDYYN6X2ix+uQD+bWHTomHhVp/oE0vFTLnkiqHRHGa08wFuzV+H4X1mINZb5eZ/Xup
	LLl66ojFKqOvFLwE2/8qlZbvtdnbPVrShUfTyk+9bDZp0DK38S9yEHJuX8PgDc0+tQzMy5
	MoXYu0cvjJYe3S5tTh7p6Lo3mVpawko=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ppteeARE;
	spf=pass (imf11.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 118.26.132.101 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770106700; a=rsa-sha256;
	cv=none;
	b=JBI3zua0fA3dBJvV0IBX86zXC4PzUmlpeM+61RURxAjJtvot7gYcnBBoXxGIndrbWLqKAs
	1yUP6aEvN/OQeQYC+24rf2KBiVzGjAv7hjv0JIRQbMJPTVS+PAs9E/J5u9BvohrA+HHggq
	GUSdwenUW0duf4aHDrreu68NjgPHd1I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1770106680; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=Ro+94Aa/uxuiumnNVETAoZZO1z2xqW2bzXYXE12GuYc=;
 b=ppteeARESmgocBniDzvZbTwAHoalFcsxXBjYBHExTDuo6WVq3azMcGj7QYE3zqFfv1QE3h
 wyJBaT9hHHVzBpx4LWDu52PwcDZ3Hoa3/8hISn+kMZS4/7Y3LHVpK16Wxm6fHevQ/eiQpU
 FSmEqFccAs6a6qBpAXU8mzUV+RxqKiKGV83PxGOZkQ7Ex6UhXTTfd0/Na/kCXHHoGQirl+
 /hOvMwvRuMVBnahEeO/4ePi0SDVipm6V4eo4dDjD5Y+ZO1gSyo5LOH1qdwJvV+uesqfI1G
 dDQko8OAy6KnnNc1QqsrjA4JBxoLOaxRP4n2nE6FCcF0ATqjO+Est0g+fhhRzg==
X-Lms-Return-Path: <lba+26981af36+8d4ff7+kvack.org+zhengqi.arch@bytedance.com>
In-Reply-To: <20260203073757.135088-1-ahacigu.linux@gmail.com>
To: "Altan Hacigumus" <ahacigu.linux@gmail.com>, <akpm@linux-foundation.org>, 
	<david@fromorbit.com>
Cc: <roman.gushchin@linux.dev>, <muchun.song@linux.dev>, 
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Message-Id: <3e59ca4e-2301-48a7-bb8e-d028f07b1446@bytedance.com>
Content-Transfer-Encoding: 7bit
User-Agent: Mozilla Thunderbird
X-Original-From: Qi Zheng <zhengqi.arch@bytedance.com>
From: "Qi Zheng" <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH] mm/shrinker: Fix refcount leak in shrink_slab_memcg()
Date: Tue, 3 Feb 2026 16:17:44 +0800
Mime-Version: 1.0
References: <20260203073757.135088-1-ahacigu.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 510FA40006
X-Stat-Signature: nhczb9pmcrcomn1infjitk5c71e87tii
X-Rspam-User: 
X-HE-Tag: 1770106696-861103
X-HE-Meta: U2FsdGVkX1/cxIHor6OwNgRqrGWc+wsrc6AeSZ0Db8TFkyOEwMWvt516tFDkW+9tCczqpnm8vxlRbmtAOD7/+g0kE+h1cNyVR5ywD9CyWRURmkVjZrRczEHLcROraTnBxNdsjUP5uiLjVmkJ2QerJhwf66waoojYZCyjWJ+5lG7/8cUPqvl/QUO6YiXTSQpoZyyXpOPz2zvfj6s5DJ5bktCXyC3HABmGQNMKMeQED0Lauqzmb+uo7zS+YlgqLU5TjNc9MECZALjj2Q07O26AtA8d5H4huQjiEKfTHy5MYAh1jeKSvtWzM5Z7kKt3s+wxfiaJh6UuD4vspfXVOSFwjnyzsEIMna/rX63u8rRZWITO1WZNTUSaGeMqVdLEsAcgEwWX3aF4e1mkrj7AN1H9JknDnyKpGFpNtaKQqnz4uGaPG0HLxph4/ri0pN233czm3ARjjhqTg3Llt/+8OiM/Ye1QVgSjos4Kax2vL6C3WhhxoWYJ+XMWcUPo8+vYka/2GNqDRtxUAU3yXIQe7Jr45t0eJKGFmAB106qQYw6rbSSOwbMDcwxr0iaomasbi67sz709UqAmBhBIqJxWC/ODkPMpHamurFs1MwPlDNHCZU31cf9egIrpUW+20OOdhGMVdcCvfYORCVjRm4Tn4wWzzyxipIR/Lvb7Av9TLEvXCbS+FDdNqjvIN2SJTZD2Sdicln5CmqU2f9cbkJa7J3dqA6YKucCS9kmWfbBujd7SiIw5JBnnz5bTDdbmEW+CkRQ0EFX9NxEmZMNuPPiHm2HBW+RD+b32kGQObNcoKIjQufx25+hU9p7q1B/AK7rsjM8676O/M8eTVzfhnszGs+D9MBa93ZNiQWhdDRIvlg1gO/0kuEM35RyfgVQAXvKRVrR2KdfWzb6Cg32DxBpEkOdvkh04UL89khZ3yuHbX4tFR3x5sMK5/8qJUCsAVl1dS23zEOF08QqcnrXxZL3Rvcq
 zYOB41L5
 o9dChSJjK4N8W6vzn5NZNOZb0ZUteltKbERxnGwHpC9rvt9+gaHfaeR/C9CAl1cv8Yf1ID+DtbCykheEwuSNkiCFqTKN9HEeyJ4JApf/Uqu1T+i8WdGngnNc/DV21mgGkp9p/nIXCpSVTuRSMnSwd3v82roBcgBAyCbLrvLFMFmJcXUwL33acgqGYw9cTq8VuZfxhIqePXRDwEFMfgcF/Qvv5ox9vVBA22sKo3qYyERAZhCtJ1JCimbBV72AmZBVR1bBM2bvpzXmpPlOD+yfZd6L13oK71QZ3+p5Ozy+iN4i8pHtD5uKOO22WzHC0GA/NqoQ1vZO+NNT/wnt5Z8wyPHLwBhmTK99ESx2Dw8bewbbtmyLHxGspSDFY01xiqIlkdXUH6wPAU+KLrDU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/3/26 3:37 PM, Altan Hacigumus wrote:
> When kmem is disabled for memcg, slab-backed shrinkers are skipped.
> However, shrink_slab_memcg() doesn't drop the reference acquired via
> shrinker_try_get() before continuing.

Good catch!

> 
> Add the missing shrinker_put().
> 
> Fixes: 50d09da8e119 ("mm: shrinker: make memcg slab shrink lockless")
> 
> Signed-off-by: Altan Hacigumus <ahacigu.linux@gmail.com>
> ---
>   mm/shrinker.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/shrinker.c b/mm/shrinker.c
> index 4a93fd433689..d0be120488b4 100644
> --- a/mm/shrinker.c
> +++ b/mm/shrinker.c
> @@ -544,8 +544,10 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
>   
>   			/* Call non-slab shrinkers even though kmem is disabled */
>   			if (!memcg_kmem_online() &&
> -			    !(shrinker->flags & SHRINKER_NONSLAB))
> +			    !(shrinker->flags & SHRINKER_NONSLAB)) {

Since memcg_kmem_online() and shrinker->flags cannot be changed
dynamically, it's best to remove this shrinker from the bitmap:

				clear_bit(offset, unit->map);

Otherwise LGTM.

Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>

Thanks!


> +				shrinker_put(shrinker);
>   				continue;
> +			}
>   
>   			ret = do_shrink_slab(&sc, shrinker, priority);
>   			if (ret == SHRINK_EMPTY) {

