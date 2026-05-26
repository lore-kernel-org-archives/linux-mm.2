Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06D34CD5BDE
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 23:56:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A4566B0005; Tue, 26 May 2026 19:56:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 155146B008A; Tue, 26 May 2026 19:56:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06BE16B008C; Tue, 26 May 2026 19:56:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA5336B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 19:56:56 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A37238CED5
	for <linux-mm@kvack.org>; Tue, 26 May 2026 23:56:56 +0000 (UTC)
X-FDA: 84811234032.11.D8EA722
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf28.hostedemail.com (Postfix) with ESMTP id C629AC0007
	for <linux-mm@kvack.org>; Tue, 26 May 2026 23:56:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nCtGHuvN;
	spf=pass (imf28.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779839815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tm9T6xdhcOXHEKQrNHqLca+zli/ELYHEK45n3ISnhH0=;
	b=8BC5pZxJFrHquAcbD/diZcwjAartzTBlhEQshkbqIK/kL/5GocJfFQI3oR5L9Yr1D1a1O3
	2F+1KCyeC4VirFNYkCB87TgwGL0DFwZhDGPyXZD5nPMfvQ59Y4eU+5812Rm0x6Togy23ec
	yL+igtYK1ahg9hbyGDLk5iLTECjhxKs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nCtGHuvN;
	spf=pass (imf28.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779839815; a=rsa-sha256;
	cv=none;
	b=QoepjP/WccZh4Hxwy1k0uaJFdyFRaR6hIySNxeokZNo9ErPKQr5pIBMLRwmCDmStFyanrh
	Qrww+33w0Xb3jLWGSylAVelTT2jeusYCFEzQ2Z8efRtwSvEF3xmxXLzwdqXQKjTdCC/S1i
	mlEH0wtDc/c0RoXG6nPu1aMqtTI5jvU=
Date: Wed, 27 May 2026 07:56:37 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779839812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tm9T6xdhcOXHEKQrNHqLca+zli/ELYHEK45n3ISnhH0=;
	b=nCtGHuvN7vc9jEp+LwRnttX4IG4GiV3KcsdQ/rP26chRrmjw2NFOU/sTcRblLH/k8IUhSX
	WCwBQ9DVacJHQGXx4xKs6I+lAXjTzSfG+NptrHCbwzXORZZkrwmgGCwS+3N9B6LPAx3SIp
	aGvXunDOj6uHTbSek5qgyfBc1TJ51mY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, gunho.lee@lge.com,
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com,
	baver.bae@lge.com, matia.kim@lge.com
Subject: Re: [PATCH v6 3/4] mm: memcontrol: add interfaces for swap tier
 selection
Message-ID: <ahYzNVQHnWlwYq8u@MiWiFi-R3L-srv>
References: <20260421055323.940344-1-youngjun.park@lge.com>
 <20260421055323.940344-4-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421055323.940344-4-youngjun.park@lge.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: pdp6j16qm8rek961f1jjiyqzfooirz6m
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C629AC0007
X-HE-Tag: 1779839814-698746
X-HE-Meta: U2FsdGVkX1+ZVPW+jhs0TtVU1uOs5O5lW7y4GPg1MNdVR+zh+RFyLrpLN40CYBrmbuOjuPqLmjvyeEOr7Qou2G/e6bwlgw13+lIFEJjbX4t/JTowFRw+VYvpd/ElCUKbmb41ONewyHA8FqaqJc2hoA2ePIcf9DfJt6cg41trJ0viH3vhoHb37PKNTBR2VJPQ9GikfFU0Nuw/6B3A2b16k3cUN6V41yCz1zcXr0g8pJnp0/0UNwV5GAixwP/eWtFxjv4CAibfgkKwaWU2v0JWKDq2hMbcb/BXvCxjnfGq8XBnLZiX+CGThtkFEeksY/g+DVWgrClGVqdvrR2uK//lMvdLXdTN13f/UzSrbbfCRdqM0H9Kt5aAdCjcOQ/ncs1EX+h8kGCuZmBXsuLgon3y0GWwhf0dJC9o4b6iYqGL7dpOMjlavc/BnAOOFwxF1O6YeWGfNqe3ZC+jiE9GuwwEEPk9RLwdSOSbZ8ZBIjy8SGJV23MoYn1t9Ky0iKUTfiCLtakwlke7R3h7HGfTWxmLfxDG9yRaVrmHff/O+QX7glcIDq2NpovjWcuVcX+EczwqBFrbwerDyiA+wnxsXKPrC5dRdAHf6GbILBVUToQr2DPkuxK6w8DaYKHQk4r32V/sJ6eRIMBMGYdZAcu1zPnZoiy2F0BDVy0TsGlRpI0LVurBRRRhmM64MFcIxjQ1p8ahQ/oj4R6ciHBEm5e98PQvjbOwAWY2hxbPWwwWmTs8yZKVjeCqbOVjTwd2059bvF84v1ESlLj3lURJpaDIi2RbYhPopntSzAZiKfGxo3UB9cyDmwmahe7x2JAtAjGugfPKkLJa8U9vWQ+P/Uho1P7uscGgeh7Xl5HEtqufbK5YMqXTYOuZSSJY02cD+/niAuHQhE91IMKNuaW0igy9ttPo4dKNqo8RXHYdit9Cm0PxBOEy3dglEGjf26+v1UvBwv3T6PDRVDjqMfD1kNcx9eL
 sS1scL6b
 0G31IK7jHVtlfPHk3NoLZ1Yo8tzjt3gRbpUILOVYsYyQb7LUF7WUWso7azZSPXb1NRz/v0+IykHQUnhNfsA2rpseEfsVgtbnCa7iDo3Kh0SSfhfVqWjVz93PkPUhS7CDqCkMaqflYZS76N0hsm9kauUNzjYSrIFikAhbY78PM9Mh1LbDYtQNA7SWn+z0oZUEYTSxOLga63rLOwOcNfvlzEDp8srsTBk/ZKtudhJmbmREos1qyDDY2d/E5sA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/21/26 at 02:53pm, Youngjun Park wrote:
...snip...
> diff --git a/mm/swap_tier.c b/mm/swap_tier.c
> index 9019b8978770..b53d6cc67d1e 100644
> --- a/mm/swap_tier.c
> +++ b/mm/swap_tier.c
...snip...
> @@ -374,6 +404,80 @@ bool swap_tiers_update(void)
>  			break;
>  		swap_tiers_assign_dev(swp);
>  	}
> +	/*
> +	 * XXX: Unused tiers default to ON, disabled after next tier added.
> +	 * Use removed tier mask to clear settings for removed/re-added tiers.
> +	 * (Could hold tier refs, but better to keep cgroup config independent)
> +	 */
> +	if (mask)
> +		swap_tier_memcg_propagate(mask);

Code is neat, and high efficiency, while it's not easy to understand. I
just sat in front of my computer the whole day yesterday to recall and
understand why it's done like this, even though I made it clear to my
self in the past. I think more words would be helpful to decrease the
difficulty for people to undersntand it. E.g below two paragraphes. Just
a suggestion and for your reference.

diff --git a/mm/swap_tier.c b/mm/swap_tier.c
index b53d6cc67d1e..0a6adf14ab91 100644
--- a/mm/swap_tier.c
+++ b/mm/swap_tier.c
@@ -405,9 +405,17 @@ bool swap_tiers_update(int mask)
 		swap_tiers_assign_dev(swp);
 	}
 	/*
-	 * XXX: Unused tiers default to ON, disabled after next tier added.
-	 * Use removed tier mask to clear settings for removed/re-added tiers.
-	 * (Could hold tier refs, but better to keep cgroup config independent)
+	 * When a tier is removed, its index (bit position in the mask) becomes
+	 * free for reassignment to a future tier.  If a memcg had previously
+	 * disabled this tier (cleared the bit in its swap.tiers file), the
+	 * effective mask would keep that bit clear -- meaning the new tier at
+	 * the same index would be silently unavailable, an invisible cgroup
+	 * constraint left behind by a tier that no longer exists.
+	 *
+	 * To prevent this, OR the removed tier's mask bit into every memcg's
+	 * tier_mask and tier_effective_mask.  This resets the bit so the new
+	 * tier is accessible by default; users who want to restrict it must
+	 * explicitly disable it after the tier is re-created.
 	 */
 	if (mask)
 		swap_tier_memcg_propagate(mask);

>  
>  	return true;
>  }
> +
...snip...

