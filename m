Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFC76C43602
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 08:35:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 944176B00A6; Wed,  1 Jul 2026 04:35:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91B596B00A8; Wed,  1 Jul 2026 04:35:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 832316B00AF; Wed,  1 Jul 2026 04:35:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 59FFF6B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:35:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D8BEFA029B
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:35:48 +0000 (UTC)
X-FDA: 84939549576.30.662F7A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1F4B020006
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:35:47 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CUbiQPlR;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782894947;
	b=DYU63tLb9y6r1u/EAkr56QAJhRhW8OxF9xnrSX4YxorRo4ziZrpScMnfE1rr5f/bZBnPdM
	wGLYyuozclo+97UZH5qtvmu9yOFhbbX62IUjWXMuXF1K3+EwuTlG4TmTnky4goVN8f7AwM
	c3BmpXIdGRrbg5DeN+/JBA2euRFfwJc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782894947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JrfIlvjinRp/Isc/2aqvA7fk3pmFV0oszkJp6lh7LfY=;
	b=WpTc4ej9kDDF1IOXgKUViExt3w3U7f6w23UPnZMcqL3BQC7/OoRdG+Jcq3meCpG2MkYvFv
	hf66pU3kXAN6/EkHMVFw78+x7lgqLtOEUdy3oeq9c2tn81+XhfS4IKa9/sYN+eL9kltiJV
	jQugx9IPJe3ZmouHwENcFkvi7q7BtIs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CUbiQPlR;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 50EDC41FE3;
	Wed,  1 Jul 2026 08:35:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6C21F00A3A;
	Wed,  1 Jul 2026 08:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782894946;
	bh=JrfIlvjinRp/Isc/2aqvA7fk3pmFV0oszkJp6lh7LfY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CUbiQPlRNLrGAaISfsMY2lKId+9XnZt02rpJWrZt0iiXTBPY5ps7EvIeCm49fjIVC
	 QTGVocVVcGV1jQbSkMvGtW692LfGFij4mHu5VN1jur1x+xpTGe4z7ZNYrUsR49ViUR
	 oTJfADXQm1srqI0ZrACTDBgaizDXw2H4x68GvqMOPa7GpXhf6dBxFUQVHYbSbS0Ocg
	 Kr2xS3Er8g52fpOCoxyesm6VGfy3j+i4inOa8JNrwyIvK8Yn6oBXcWw853SY+z+Q88
	 7eKpSTwmSHMy0+w/aTGBKIPE4lo+L2QC9aiKrHpMkBGPfccrQQP7niAIhFOWDwoztW
	 a7g0HvZ7xRLdQ==
Message-ID: <b8baae33-d551-40fe-abb5-287f3711dd80@kernel.org>
Date: Wed, 1 Jul 2026 10:35:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mm_init: handle alloc_percpu failure in
 free_area_init_core_hotplug
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 kernel-team@meta.com, osalvador@suse.de, akpm@linux-foundation.org,
 rppt@kernel.org, mgorman@techsingularity.net, hannes@cmpxchg.org,
 vbabka@kernel.org
References: <20260630214039.2263562-1-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260630214039.2263562-1-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1F4B020006
X-Rspam-User: 
X-Stat-Signature: hgp7ya6amuene9kpykskap8zasqqinab
X-HE-Tag: 1782894946-331028
X-HE-Meta: U2FsdGVkX19/OebwK7vqQ4w0/S/A+ekAY38fS9pcKb0zw8WBCVVEJL37WbSnlFkqhh36epY157qwUrmaL4rTj8XWmL9Dp+8cmMpaxYgelwFIpJjPw/uPZZyNOGqri++O+UMAWOc2OrQUJW0LzCPxGzVoSRYNtAsTizOAlWHEVuodFCneiMP7Yb/dbCcCfaXhUrfEaVIlCh3LJ0RWYzPOsMB3+4QGGxq62B45/rgympj3vJcamGroCPnxERy2e25bFleNSy/MrzePuRVBpnBYs5cA9L03ZazOWnVHS++3fTA5/T/p37OmIcvKJDnZdX2epil32JR1HS9zo4GusNPwrMC3Zzr3P4Z9P7jz2zThFb16ydWdRawZTjdFCVFy/3tMz2jir0uPHItUEKOLd7eoKqlOgip7MeUbUKcLGsyQ+Vbu9A3Y7KLRkTCp1DbsQ3YIWyIRHL5iXZhHuQYN0U4LjS91AJC3hyAxC3XwyzjUQcTSYxKYHgAAx4r8tb7uan33ROjWitQjNId+hUo7h27InKAhwwLHt81LsxcDZ64+g+BsG8Q5ZgtGlTuGF2T8LqKTe4vow5MdXPqppuUipOvQP4DJyO258gSedqU6QQap+SX5mWey9iIvJXCqZ9EsZ4P+MXKiQDkHrf5SCDaFZ6sJyzWiOoyAqtoKmJur83zpV4TVHwNGqEpGH797Ufn+ZPw3q+i25iuk47ZVVmUKGxPMNRS9xTVdsPTrCsyTt45aBRS1S0IqvU4weYZYY3NfpWdZV0klXjvEG47APTfYgH/9V8TAxFuzCq6rrZP572GitdkrPMhCQ10EWDJM82Up3/clwwRHalVVbuwr0DNffKg4/wszRlPYc/jtNG9+i3NEN0q8Hgfd52ZjVqxLW7fHR08i7HXYv7Vbk/G/1V5o468EfCtnHXrESDUEQpgr7Tq58kE1Cj725WkXdgomLS7ttJWvi57L/S2hdIKVy57vUd8
 I4R4LDMx
 865AMX3uKKzg1NPF6QFNCrR1JVw5hwg1gRzvSda+T+WDGTG+n6YZQv/NbmhQSk3Hr2ibn8aTNDxAG/ehRXRc7huRS9ZAVHFbAHCSZR7vDnIg0iNSJyqKGFnnTA2F4CFktpZW9WtoKcrnElG/3YWvEWYvXhkhMrsLmVgiNTv+DaqPVqXDRJclQHrUHvLWM3lvNtdRi5IFP7D7yXzamiB3RUlGGqcbS17wY8wTD8zi7CUmih+tNN3jFKbXogNZtCiTC2BcQVeNQyY7mGmNRaA8zLUP3iHJafM2unVPnioRnBQTPrzY4eln0l4V5Yw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>  	 * The node we allocated has no zone fallback lists. For avoiding
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 306ea5c13f54..37fd64ce144d 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1536,7 +1536,7 @@ void __init set_pageblock_order(void)
>   * NOTE: this function is only called during memory hotplug
>   */
>  #ifdef CONFIG_MEMORY_HOTPLUG
> -void __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
> +int __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
>  {
>  	int nid = pgdat->node_id;
>  	enum zone_type z;
> @@ -1544,8 +1544,14 @@ void __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
>  
>  	pgdat_init_internals(pgdat);
>  
> -	if (pgdat->per_cpu_nodestats == &boot_nodestats)
> -		pgdat->per_cpu_nodestats = alloc_percpu(struct per_cpu_nodestat);
> +	if (pgdat->per_cpu_nodestats == &boot_nodestats) {
> +		struct per_cpu_nodestat __percpu *p;
> +
> +		p = alloc_percpu(struct per_cpu_nodestat);
> +		if (!p)
> +			return -ENOMEM;
> +		pgdat->per_cpu_nodestats = p;

Is there a need for the temporary variable?

Also how to handle cleanup on error? Or why can we skip cleanup? (what happens
if we get another call to __try_online_node()  later?)

-- 
Cheers,

David

