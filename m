Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64B7CF99C73
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 09:45:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B19B6B01F4; Sat, 18 Apr 2026 05:45:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6139E6B01F5; Sat, 18 Apr 2026 05:45:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B9076B01F6; Sat, 18 Apr 2026 05:45:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C9566B01F4
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 05:45:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A36348BA81
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 09:45:10 +0000 (UTC)
X-FDA: 84671193180.06.BB317A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 18EBC180004
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 09:45:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sOWJqKbV;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776505509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gSpbzrfTHfzy7iIidBCFRh7O/6Vu2Yr8aOxbFubOcc0=;
	b=KsABruO37mKlWddXbQIhDmlyxWpvuke2ljmhKD+t39kw6osHF75NC5c6NGrSq4S8DQwXSc
	N/ekJJS44mf7DtiHoIOC1kx0duW4CRAap/+h8RBUeNwuPHgtC9EfK6nh6rCGtyISDMeR2v
	I9mWRUMI5bLTDC7z0ftRbtq2rmB+4IA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776505509; a=rsa-sha256;
	cv=none;
	b=OyJcGcvAoWiilTFt6pXpRs23gqQFydk0wHBEX735iM2o24XaJXPdthYYivc0NXJZTd4C/k
	48Gd9EPz7kYOxPfN2Ce2g8KGShEBNHRZdkSPkLr423tPJPFDs290KlTkjD9uEmm6ue0ZO+
	7IPuBX9MS6g4V1Vh59Rc6gdRHiNz+E0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sOWJqKbV;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 681F360138;
	Sat, 18 Apr 2026 09:45:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA778C19424;
	Sat, 18 Apr 2026 09:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776505508;
	bh=uzWS94xGrvHvwUyZi+5wB0p/k9w1Rf8rLHrEI6/qQdw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sOWJqKbVh6LSgKpYBoov0WFLxknG+paIEGwdA7pp0XSgD97L3HDbCDW7WtyHnStJy
	 jock4K/DL8KClznF5A2k7PYCgn29x1QgOqI0joqrTr/6LuY9ZFgKo7uMCcGHqWTs4p
	 u7F5YVswlpFR5elcuH5nXqsjYHsvt5IBbqXxPmEUaqvYhOSYK6fU+EwbEXX48YnYm2
	 LVb1d4923isU8ZCfMTJqqAYdHfUlzShgamb3VGyO2DkPJRnlil50+CnorwT4WJ8wfr
	 xozMVKS0SMUPvaGN2uqOTHKqa2kUj5BNixJsXzupmG6xQyaWoJQWVwbAS1QmkeKZbf
	 vd42GlDMwPlhQ==
Date: Sat, 18 Apr 2026 10:45:02 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 1/2] mm: huge_memory: use sysfs_match_string() in
 defrag_store()
Message-ID: <aeNSeHKq2hr-u_na@lucifer>
References: <20260408-thp_defrag-v2-0-bc544c1bde4e@debian.org>
 <20260408-thp_defrag-v2-1-bc544c1bde4e@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408-thp_defrag-v2-1-bc544c1bde4e@debian.org>
X-Rspamd-Queue-Id: 18EBC180004
X-Rspamd-Server: rspam07
X-Stat-Signature: bwr8iftu6r99gfogyrc8hxmhe896imc9
X-Rspam-User: 
X-HE-Tag: 1776505508-794070
X-HE-Meta: U2FsdGVkX18SIs6DPeEmFJqs4Q0laPHlGM7GxWBA+v07ILyDont54Se5jeFZMDh+zw+/RKv8yClzFxQ0WAjg8UcMkLG9O28qud/3Ui4YtcgWUEKl498bl7Utj/Nan32svC5Z0IF0AytXqAiM1BGQnWjJrXUe3/E3im2eiuWsH/ExXLrx7uVskyaI3Xt8/W2OIyGomemQNNHsZUWyH2qyuo8ZZDgUTO+vmfdE2ZcU3haFEez4WhMMJL7/7psrnKMb7MUky2nt/9OGltcbWaYiVq8S3a631Wbbucil41+leatfGOtFrfZIBL81wIrZw3smAuIzBm97WPNWtDV5dGslOEbxoKj3cAo5F6gq36r8qW5YO1KHT64K8nlx3xoajESK5FxfUGGAYeabeh5dEU9cysdLIK6yABWw6ZO1RAiRNHXlmqORdMEqzYU46XnG47pjV5iG6qWXFsQD0QsDZHG8vOvnmWWq+JqbuHSZupjwN5caCMlWlZuRO+vsle8NtGh9cYGQ6qwECDEfVE9tCHY4ot8JR+lCEhw+i1x+pu8BTB+IaHbOUXyjrLNARuZQ1RTvRWMJ64XHnl/BYxbegibdl13jKTM8k3Z8ogyqV4m/N7nzv+hvOF6clkkCDieFrn0skYr0nZiiFZIg2RSWLNBua+OKL7K33HBYqt6h+kuv0OhzhhrxQ72EXJBbTXWgPMLWDBABBrO1jHmSIuXATsuFha2DbsbZ1HhRF67S/J3+3tUf6GXyiJvSCaYxzeiBnInb8GhVlaLcEqpanXft+kvd14CfJxAMJ1AhmQrfe9MM1Wp6TGALjTYit4ZGYSNM0zdrcRHe6P2S7mtdfbh6ANEi+ThOzV2aNlraOAbTuwH3N8sg+WEdOP6s8M01dTNxBiV0d54RDgNE0PMyhyFmnr0KsoEd34ivBoXOMSQ+F9xFoFDMIGkyJja65fOfhyxCCbPJDfKRR9+UuQ9awSrvZnh
 QPYM3jQr
 j5i/zJWY9BVsg/t1p3BjiJ5r1CXUcuHOI3GrVyfYttEgGq2kNbv7TSZJZo96ENEogqj/qt1Kk7eEcc/eyLD6jARnuDVqttMSN/jk5EJSMYmOcK5Z0ugGsCFkLYksZaWiMbliCx3W7mAT/fCzkW3rBE+38kzJRcUFu1nWokVshWtDdAbeyEy45Drwy4lnzVO7Ji9pFpJCoDoUm9T6MpRgRX33aSmt4PQMEQVhxk3YVAwTcVJ3qTtp5wdHBDowxTXKD/6wCFRb6Lx71+/kwtRARJ7pZwlInwaz2BERyBsp+uynUAfCoE/wkvMDI6KxIzPqVCqVMTBiYRz2pwSEv3qVXFxf8Sg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 08, 2026 at 08:47:00AM -0700, Breno Leitao wrote:
> Replace the if/else chain of sysfs_streq() calls in defrag_store()
> with sysfs_match_string() and a defrag_mode_strings[] table.
>
> Introduce enum defrag_mode and defrag_flags[] array mapping each mode
> to its corresponding transparent_hugepage_flag. The store function now
> loops over defrag_flags[], setting the bit for the selected mode and
> clearing the others. When mode is DEFRAG_NEVER (index 4), no index
> in the 4-element defrag_flags[] matches, so all flags are cleared.
>
> Note that the enum ordering (always, defer, defer+madvise, madvise,
> never) differs from the original if/else chain order in defrag_store()
> (always, defer+madvise, defer, madvise, never). This is intentional to
> match the display order used by defrag_show().
>
> This is a follow-up cleanup to commit 522dfb4ba71f ("mm: huge_memory:
> refactor anon_enabled_store() with change_anon_orders()") which applied
> the same sysfs_match_string() pattern to anon_enabled_store().
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Tested-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Thanks for doing this, big improvement! :)

LGTM, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  mm/huge_memory.c | 60 ++++++++++++++++++++++++++++++++------------------------
>  1 file changed, 34 insertions(+), 26 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 970e077019b75..76f2d32428c7f 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -429,6 +429,29 @@ ssize_t single_hugepage_flag_store(struct kobject *kobj,
>  	return count;
>  }
>
> +enum defrag_mode {
> +	DEFRAG_ALWAYS = 0,
> +	DEFRAG_DEFER,
> +	DEFRAG_DEFER_MADVISE,
> +	DEFRAG_MADVISE,
> +	DEFRAG_NEVER,
> +};
> +
> +static const char * const defrag_mode_strings[] = {
> +	[DEFRAG_ALWAYS]		= "always",
> +	[DEFRAG_DEFER]		= "defer",
> +	[DEFRAG_DEFER_MADVISE]	= "defer+madvise",
> +	[DEFRAG_MADVISE]	= "madvise",
> +	[DEFRAG_NEVER]		= "never",
> +};
> +
> +static const enum transparent_hugepage_flag defrag_flags[] = {
> +	[DEFRAG_ALWAYS]		= TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG,
> +	[DEFRAG_DEFER]		= TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG,
> +	[DEFRAG_DEFER_MADVISE]	= TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG,
> +	[DEFRAG_MADVISE]	= TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG,
> +};
> +
>  static ssize_t defrag_show(struct kobject *kobj,
>  			   struct kobj_attribute *attr, char *buf)
>  {
> @@ -456,34 +479,19 @@ static ssize_t defrag_store(struct kobject *kobj,
>  			    struct kobj_attribute *attr,
>  			    const char *buf, size_t count)
>  {
> -	if (sysfs_streq(buf, "always")) {
> -		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG, &transparent_hugepage_flags);
> -		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags);
> -		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags);
> -		set_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
> -	} else if (sysfs_streq(buf, "defer+madvise")) {
> -		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
> -		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG, &transparent_hugepage_flags);
> -		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags);
> -		set_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags);
> -	} else if (sysfs_streq(buf, "defer")) {
> -		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
> -		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags);
> -		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags);
> -		set_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG, &transparent_hugepage_flags);
> -	} else if (sysfs_streq(buf, "madvise")) {
> -		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
> -		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG, &transparent_hugepage_flags);
> -		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags);
> -		set_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags);
> -	} else if (sysfs_streq(buf, "never")) {
> -		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
> -		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG, &transparent_hugepage_flags);
> -		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags);
> -		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags);
> -	} else
> +	int mode, m;
> +
> +	mode = sysfs_match_string(defrag_mode_strings, buf);
> +	if (mode < 0)
>  		return -EINVAL;
>
> +	for (m = 0; m < ARRAY_SIZE(defrag_flags); m++) {
> +		if (m == mode)
> +			set_bit(defrag_flags[m], &transparent_hugepage_flags);
> +		else
> +			clear_bit(defrag_flags[m], &transparent_hugepage_flags);
> +	}
> +
>  	return count;
>  }
>  static struct kobj_attribute defrag_attr = __ATTR_RW(defrag);
>
> --
> 2.52.0
>

