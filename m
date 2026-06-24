Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DCBCCDB470
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 07:17:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C39266B0088; Wed, 24 Jun 2026 03:17:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEA5C6B008A; Wed, 24 Jun 2026 03:17:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADB766B008C; Wed, 24 Jun 2026 03:17:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 89ED96B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 03:17:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DBF2C1C19D7
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 07:17:00 +0000 (UTC)
X-FDA: 84913949400.09.6022C2E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4804CC000C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 07:16:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ExvJXB+v;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782285419;
	b=XCFHFM0RemDWDc/OjomYzL4nKqr0WxsZlCFaGD0lvtcKH0NzKq1ExhWNw94yl4G0ttDJoG
	sj1WzrRZz7owa7tAXJJQY6ikukBeK+Ugu2Clep8OqbxX7+aeZS8XseHeNdqD4jCQOC979l
	cZYRF7UjoVtaog9Zyoja93H1Lo6INoE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782285419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=usD2Zx500l7YjzZfp5/jLk/wMudEX2pn65qPpLZCvzs=;
	b=8Js1HM2fpkkzoFvGyT0kj/JRqcgUdVmYzrOxLudiR+Xde+QNLc4kO44/hRlTKIywhJT1GL
	IycDJ/38xWFyeQ91WoUBpEvxRPeq1oWndpeRu+Oltl2m+DQ4Uu5ltfZ/MHLlqt8m3ZFGkL
	dSkO7CLt7784Bsuo+8Hk0NN83zEWA9o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ExvJXB+v;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 96BC560138;
	Wed, 24 Jun 2026 07:16:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BFF1F000E9;
	Wed, 24 Jun 2026 07:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782285418;
	bh=usD2Zx500l7YjzZfp5/jLk/wMudEX2pn65qPpLZCvzs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ExvJXB+v5NznZQBp47/Q5VjnJbVvyitW4di3uIhPLvqvcUgc+0z2B60yf1qVsE0dS
	 BUv2KdmSEXT0OLlTb8OhsHIet/1JuqBI8oXmooSbHRQNWhRjf2s2inpLIvbr2ovr4c
	 nC2Yfyeld4wL1wfguV0GM/qXAkvtjYMGSZecdQJtU/WvWhxPt/WIGjttI1w4PNzPtu
	 KL08bQyeWdNhBNaEDoxBC4MtRoVJp6QDVd8JlSY2FdwtUrA6IoMb252Yi8f1etWfUz
	 uOwWVf3zAuLp4lXfFUnZ18xOrSAT6kc2KDIspAy2xg2jNzcmiAh0VPYoNQurIANxrm
	 6vXjIg42fhAJg==
Date: Wed, 24 Jun 2026 08:16:50 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: akpm@linux-foundation.org
Cc: Imran Khan <imran.f.khan@oracle.com>, david@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmstat: avoid taking zone lock in /proc/buddyinfo
 reads
Message-ID: <ajuED_MZRzDuE3tJ@lucifer>
References: <20260604134245.1580287-1-imran.f.khan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260604134245.1580287-1-imran.f.khan@oracle.com>
X-Stat-Signature: mesypjzp6jwi94mmwi8f3jikntsob8cu
X-Rspamd-Queue-Id: 4804CC000C
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782285419-831279
X-HE-Meta: U2FsdGVkX1/xpLhsuw41dN8tfRWJISRfsyFzYAulILi2GzNxcUSw0Xb3Tw5AtD/ZQC2sy+eMiT4Z2Yo/Lki0vbKx7siJkQ0U59oaGef7/VV+BQEINeNlapj/xpbjaYhsbnSzlf5AU/xmrKGQb6r5qxzkIeoPJrBCvu92AOmSXG1WK5tElVzyzisK7YwESH/UJ2C9n9Ndyj5/ccdGMlAsGKCk7dnN/hKdNbQNhL8nO/vNiP8sd7QSOTO5kEtQfGGrU8/6gj7s2BptVRF/mUzhcu27cC15fGsTCLTgEHOsWSrxb5646EuAx4yICt4xa7pfx7/VMGOGy1uzn9psDtiynzBMyCnnEsxBM7TZCCRtq47MOLcWgpG9BJzYyF1cITzskLsSgM0wdx9SmTKyVksMQt3qE3Ge2pniD6tClwK1/+JhxOAepFeg0IPXoJZx5hV5LuxvHQVWTH3OylSivxQqR36OQv5dHtCn5jNJMTSogt5ku4lqpbf9E8XMvTU8HUTehMlebHwU8CNhx6xVfsnSN3vEnq4c56+w0BHG29Yo0NByMLGXJh3JqVnswirGKTDMP1uGf/WQdEGLXLnab9C9fBGyzAkbgv9NGDwITdW5z6TmF8qAROB2jd4sFOEO3kU5ecuZUrqAY9pYVF1ErsMjTKlmUxiZ20eI+/7W9/Bam5GVH6bgm7tkO0pyjJKNs/HTH7nrnWxdj8UoJVZLXJ9bgV+ChbwI3tOWDEm28nVjWo+5Rry5Ok3LG2KBTRFFS6d/TPvvAnd2zvJprGYSk6pAk+/apArP+iuWatni52jC8a84uECQRHlcCAXzj6JstrUiOpxEkofXE4LsknKIl5UfPrZyoEgCEdcFp9EOlre7lA+Vp05WoiZ1EhMxGvZAuLYjFmyfABITzMTRXhRqB+2z8BZn15xIGd3HEAPD+U8rLleJML5G8lWMnaLbO7SJRhoaTQqQbqruG0ToatYHS9t
 c1wBMQQU
 9Cy05dkBOPs5+V6r1SqQRAxOxZtkfyf/hn8LbOmWFW+SZbH/bsU+0krfmSMcOoGkWzdFNPn3LRNXehzMPEiUHDGCjSlgJOu6yM4VnTYxqI6M44VYBTiLWh64bPimYxq4Gn0tET8tSLgTrSHFHstebNeOprz2lYBxU7v4KkEWIGl2yIUAsXCcJBfKUjXX84FK0VK8RDOhM4Ia6/k2rzPteoXmPh6FaKghPCpzJ4r9mUks5qvJpB+eyWdDdvJ/j+QrIj1+h5BiYIpWe4RX2sfNXHgDTYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

I think this one got missed last cycle? I don't see it in any mm- tree, and has
a bunch of tags.

I guess Imran will need to resend it at -rc1?

Cheers, Lorenzo

On Thu, Jun 04, 2026 at 09:42:45PM +0800, Imran Khan wrote:
> frag_show_print() just reads zone->free_area[order].nr_free, so
> it can safely do this without needing the zone->lock.
>
> Pass nolock=true from frag_show(), so that walk_zones_in_node()
> can skip the zone->lock acquisition.
>
> Signed-off-by: Imran Khan <imran.f.khan@oracle.com>
> ---
>  mm/vmstat.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index f534972f517de..7b93fbf9af092 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -1568,7 +1568,7 @@ static void frag_show_print(struct seq_file *m, pg_data_t *pgdat,
>  static int frag_show(struct seq_file *m, void *arg)
>  {
>  	pg_data_t *pgdat = (pg_data_t *)arg;
> -	walk_zones_in_node(m, pgdat, true, false, frag_show_print);
> +	walk_zones_in_node(m, pgdat, true, true, frag_show_print);
>  	return 0;
>  }
>
>
> base-commit: e43ffb69e0438cddd72aaa30898b4dc446f664f8
> --
> 2.34.1
>

