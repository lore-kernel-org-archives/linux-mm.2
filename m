Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E466BCD5BD2
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 02:08:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 302D06B0005; Tue, 26 May 2026 22:08:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 265656B008A; Tue, 26 May 2026 22:08:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1545E6B008C; Tue, 26 May 2026 22:08:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 003D16B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 22:08:12 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A26E21C1ACA
	for <linux-mm@kvack.org>; Wed, 27 May 2026 02:08:12 +0000 (UTC)
X-FDA: 84811564824.06.74953B8
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf16.hostedemail.com (Postfix) with ESMTP id 53CA7180003
	for <linux-mm@kvack.org>; Wed, 27 May 2026 02:08:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf16.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779847690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dRSBpoqT+EhAHTpyP/2rXo4Z8bmlP/XmIY1D23kf+C4=;
	b=Nv8zyO9GSjhR9JK/DRYQgWqUOmpg7GMGubBxysyuV/a7kyCLkk3zmVC05esEcWKEcvy/wK
	WmEA7dvmBq6rmEu6MkW8llWJcWbar9MlC1u7gLanIHYNu3l+ZaUjfVENVR4hVAnMIptYyt
	C3UQBtqmfzrPP0LjVodnXYpXGbutjPU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf16.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779847690; a=rsa-sha256;
	cv=none;
	b=VmeRjJDtCLdWaUxT0nfIUS/jtlIrTh9/6Q/L5DfNNdvI/rhBL6GBFWUGWIHCVajzJPX9LZ
	RFDA1nJiRQx2EiRKElWbAAl8Fr5OI+luRZlYLdJC8Iq7VKJ/F4TSAkCnv1+bxO+0TLoc6e
	xUo6obtnhRzkzy2+F8DsTEukDcROpu8=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 27 May 2026 11:08:07 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Wed, 27 May 2026 11:08:06 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Baoquan He <baoquan.he@linux.dev>
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
Message-ID: <ahZSBsSiSeQnJZrn@yjaykim-PowerEdge-T330>
References: <20260421055323.940344-1-youngjun.park@lge.com>
 <20260421055323.940344-4-youngjun.park@lge.com>
 <ahYzNVQHnWlwYq8u@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahYzNVQHnWlwYq8u@MiWiFi-R3L-srv>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 53CA7180003
X-Stat-Signature: en5fsub7zmcc1e17cgk8ix957sm8ch8a
X-HE-Tag: 1779847690-670467
X-HE-Meta: U2FsdGVkX18H57Q/TtkISVHWtzgqJa81Ly1gR6G1bYbjdWiHR+hSoiAQUYiimqllQ/eZ8WZvPrBnuV9PJcB6K1P6FgubVLIPUBS9SBnfMxQfjBD1sns7JbMNi6dYi0tZyMevsGfTsvYv4r9OBskhmHeLs/nZhK51jHQSyvdRFQdF/PrXKrJgia7ZgzMt0Qr94EafrdE37yO3J8E57DZ3JqZe31xkt0Tatiy4AcIlx/4tYQDMsehBn+h4JGIVpbetMBKsHGfgvJMfk72fTHcA7Z3yvUJTq9wxMCO+f3fFqQ6rb9f/u4aXqUeSgSwTc24MRdHUCsSqrp8gZuD+V1LSt+STD3RS9INVEkW2oAFs+LOMWr7a5WRgJO0Q3LlwWWPYviSzM3YyQgaOom5HQamJrAUa87z4JaSPTI2pZrVoTnIwI39shQzNmtCZCmdP3UEmAD+55hmONamWciFMYIHQ3dO9ws7mCCoL5Z335mJjimtEFsIYxysDjviuTX38VhrbPhWV4dLceQogCLBcGWvUVQZ/e4TU3y2G8twN0Y/r7egWK+6Qut63KubvzBUcly2VFqouVLseNtOYJh2fr51eXguuJZ5yZi+B9J4jbQxirVyb69r2++/IbboKjtx3+9e9h9Slf/koBVQj02XPx+NajQBPGvq61USfYL5YYU6NqjXrV7OoElYWf+cIE2ZQIGUC7lcGBurjkcMK3j3W1/sKfGYBTU0n/WapNRCQJIh5skONEjfpnqTJDaTzAz98kVJiSPbXRg+ck5wtsQ8L8IDijB5xYqOfoDhESeCcOfDYS0TS6im3N2SPDzjGHZ/8/utn76QkdjSPiQ7jBMnaI9iT7Oe3v9U/mH24Y7cCFQ31gbsYo074xnN3RlU41Hwnopg7lt+HQ6kz4kH4jetyJQDzHpfY7FbyLs7xJcZ5ODHVN4u6Nks+ayJbroE15ptLhNogrRaSaZQCQdGh0EsvYNO
 MK+bwdWJ
 F5WdtCP5LA2llwTUvWR+Mmdnk6I2bc/EzMeLiMQ9apcKfWr+gdaRkqLXhO3auX0SS5vhUw/xKEQjCwaJFl+c54gaT7gWnrAHVoQn3Vs42enDGmMEfmAnWjskeu/vap20A/NNz09xdjBNWD6F8TB9gSz4gNRoUnQ4WMIhNK7CKvEN1wMEU5xmZx4b4eTsGmkxPwHijvF8ixPfO9y0GPSyQi9govg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 07:56:37AM +0800, Baoquan He wrote:
> On 04/21/26 at 02:53pm, Youngjun Park wrote:
> ...snip...
> > diff --git a/mm/swap_tier.c b/mm/swap_tier.c
> > index 9019b8978770..b53d6cc67d1e 100644
> > --- a/mm/swap_tier.c
> > +++ b/mm/swap_tier.c
> ...snip...
> > @@ -374,6 +404,80 @@ bool swap_tiers_update(void)
> >  			break;
> >  		swap_tiers_assign_dev(swp);
> >  	}
> > +	/*
> > +	 * XXX: Unused tiers default to ON, disabled after next tier added.
> > +	 * Use removed tier mask to clear settings for removed/re-added tiers.
> > +	 * (Could hold tier refs, but better to keep cgroup config independent)
> > +	 */
> > +	if (mask)
> > +		swap_tier_memcg_propagate(mask);
> 
> Code is neat, and high efficiency, while it's not easy to understand. I
> just sat in front of my computer the whole day yesterday to recall and
> understand why it's done like this, even though I made it clear to my
> self in the past. I think more words would be helpful to decrease the
> difficulty for people to undersntand it. E.g below two paragraphes. Just
> a suggestion and for your reference.

Thanks for the review again :)

Okay I see.
This explanation seems heavily abbreviated.

> diff --git a/mm/swap_tier.c b/mm/swap_tier.c
> index b53d6cc67d1e..0a6adf14ab91 100644
> --- a/mm/swap_tier.c
> +++ b/mm/swap_tier.c
> @@ -405,9 +405,17 @@ bool swap_tiers_update(int mask)
>  		swap_tiers_assign_dev(swp);
>  	}
>  	/*
> -	 * XXX: Unused tiers default to ON, disabled after next tier added.
> -	 * Use removed tier mask to clear settings for removed/re-added tiers.
> -	 * (Could hold tier refs, but better to keep cgroup config independent)
> +	 * When a tier is removed, its index (bit position in the mask) becomes
> +	 * free for reassignment to a future tier.  If a memcg had previously
> +	 * disabled this tier (cleared the bit in its swap.tiers file), the
> +	 * effective mask would keep that bit clear -- meaning the new tier at
> +	 * the same index would be silently unavailable, an invisible cgroup
> +	 * constraint left behind by a tier that no longer exists.
> +	 *
> +	 * To prevent this, OR the removed tier's mask bit into every memcg's
> +	 * tier_mask and tier_effective_mask.  This resets the bit so the new
> +	 * tier is accessible by default; users who want to restrict it must
> +	 * explicitly disable it after the tier is re-created.
>  	 */

The explanation seems good.

it explains why we must clear the "disabled bit",
when a new tier comes and we don't automatically diable,
it can implicitly disable "new tier" which user might not want.

This comes from that fact we don't have a cgroup refecounting on the tier land.
it is the corner case, we must sync for correct behavior.

I will change the comments as like it is.

