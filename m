Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9653560705EE
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=P+DJK3K8
Received: by kanga.kvack.org (Postfix)
	id B0AE96B02E0; Mon, 19 Oct 2026 11:57:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABCB66B02E2; Mon, 19 Oct 2026 11:57:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F8616B02E3; Mon, 19 Oct 2026 11:57:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7EFC76B02E0
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:57:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0E813120770
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:57:01 +0000 (UTC)
X-FDA: 85339829442.30.CDB1229
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0ED7340006
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:56:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=P+DJK3K8;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792425419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BCPGdn08In8hsRvJ/xlYMeYzGiSxsIAjqufejJHxudc=;
	b=G1B8wuHQVlV8/Xre2VcmU7cD5hyfxSXUqp4PVnPMQ8ry5/DN8lPxHhgTXoc4J0EwnO9gcA
	avdeSA6dCMH5SWrahXJJMZvPr3a0Yfd5ft/A4rjeVLmrJv/06DXV/GQGtPT7L2650j6z8t
	ttS7CfnzcSzTbffi4mkCMmdwXXpps0w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=P+DJK3K8;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792425419;
	b=QSk3ZhLMx2cX1o3frYP1SsiPRIigRccAWr/WhfcyfjzTNe7rhzg7Y3i+AdQVycxWt5ZNlw
	2ErNAxkmxnM7/jCC40lEGs7K6ObvRbXU5HWi4JBUOK6GIW0JY9PAbEc4WGObTcPx5EUdXZ
	10ruoxzJtWxMRL7jcN+wMj/g6GyOJXM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D726F169E;
	Mon, 19 Oct 2026 08:56:54 -0700 (PDT)
Received: from arm.com (RQ4T19M611-7.cambridge.arm.com [10.0.144.35])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B8CDA3F7D8;
	Mon, 19 Oct 2026 08:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792425418; bh=FTlPPvQLOuIgddMm6UeqHnpF/oK8sW3b5I0vLFpaGFE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P+DJK3K8pwaa4+8Yow2pf7Q0ivZ/XICojej4Co7OwLdOEl/oiSOF78MWnDUe5feSf
	 A+MbMP79i/mjXUxVink/0N+U5DW2PWeRHiY4hgCU/GP7hquFH/fQFV3vE/JmrFRhIk
	 YKu2+5HD7FY6MGesOjj8rVwgxvdkoIPH6vztddYE=
Date: Mon, 19 Oct 2026 16:56:53 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm: kmemleak: scan modified objects as soon as they are
 grayed
Message-ID: <atY9xT4MfPL7R8fo@arm.com>
References: <20261016-kmemleak-gray-drain-v1-1-3270256fdc8e@debian.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016-kmemleak-gray-drain-v1-1-3270256fdc8e@debian.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0ED7340006
X-Stat-Signature: ya1isccxc9jntahyxcb97p45asbwo739
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792425418-204178
X-HE-Meta: U2FsdGVkX182amYxNg9ZuL07D+KbDDuK3nF5ji3hZnvzszZj2t/zeMvNHbugOI8AbUWXHwmT9saB4c+9B0AgZBuO5ASxCahq9Wj+nFGN3XIiEZKthoWlcj//5FHpWidO8njLD0AgpGFx7mI1FYu+eG9f8Fke56v1msW7Vs3Kwa2P0plZvM1GTb+NX4UGZ8OpAdxu2mnwYpoRwISCgck1E3g8/I835unwH1CGas54kfPba18wV7SSW37rqv4plnEDpGfR4aLmNM/UvJrM8DLVTTzAqLbhS9/T0fFIqI3f7VTgqj/LWCy0NkTzhrQzbLj3ZJz9whcKbCEOL08cbC4UH599mR9wnK6kutibLafbpcWp6opnmAKAWjYW33GxWE64J9ESrc9KhnNQ+Mvzk/xrmssLGj+uLSaC8uoAHa4qrh5dYWRRqpfzydW9HfX8M3MpcsctwSJEAMKNaeAoRBBAcgF7SHE/xsUJxLokCti2hGfY23GZUH7IWxEOUO9oMtGDc60IgYmtIB2PvciHvv16Tl74MwmDJJzw8RzD+ze7doDvlZPxJm2Zew8deu3KSxTlcPz3ZMdPiPWPOquSeyChesRhx8abbDSmOuXF9ZL5LFH2cmm73BwJhPdRlWbZbgO50OJz8vP33pQDxUJA2MHhYPo2jT44ztfNgkI+9RjUcO8fHCNrhyRfFNVRtEiNBJUTWX90Sx7omClULn0Eu9xG62CyEVCl25Py/iAQxCt5ngOzxP8CJ0iiUDs2SpLj0++F+SSF0yJR17D/ejjCoDXPDSJZeu7jezjbfMoseff6baB1mosvfWkX2p+pwk46mEZrij9Lf6ie/gPKfaAPYO8e6kocRIqCCfSXeQWreoRghLzI74w258qdnPyHD/YCV1PpUuPy5iB9Ndri9QAWbxt6jOaoMZx70ilCjjjgGpq63EP9/soruE1YJd+8e18FNFaw9QzSUpyeBzsXypNYIZV
 KMFjn+qO
 Hhrh3hQ8Z9uicLzrscBwGjZAP9co8hmZPqK85mHYW2dDGgMvVXQO4RFx+MbxNKUqUPeINcJXJeRxQcNAQgX8dBmSfgPr5z80b38b1hS26QGg9dtTu/czd+yQlFxHCGH+w6Poxt4j7zQZ4PmxR2u3ITAmqeEDcH2fA7Llyob8yur+Bx/jse56AtOHUKPbaVuqHocdHVTLuQXm+EvBSaY8zpXPRjjTPSku+OtTNoh/SZWOXttyIEQquuoOxKp+BY/XoQBihNc4/rjakKH8BSRNFrfmvsvwOr4MT7sOW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 16, 2026 at 09:07:24AM -0700, Breno Leitao wrote:
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index 8fa409a4f9fb26..6e12bcd95312d2 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -1696,8 +1696,10 @@ static void scan_gray_list(void)
>   * Conditionally call resched() in an object iteration loop while making sure
>   * that the given object won't go away without RCU read lock by performing a
>   * get_object() if necessaary.
> + * If @scan_gray is set, also scan the gray list while the RCU lock is dropped.
>   */
> -static void kmemleak_cond_resched(struct kmemleak_object *object)
> +static void kmemleak_cond_resched(struct kmemleak_object *object,
> +				  bool scan_gray)
>  {
>  	if (!get_object(object))
>  		return;	/* Try next object */
> @@ -1709,6 +1711,8 @@ static void kmemleak_cond_resched(struct kmemleak_object *object)
>  	raw_spin_unlock_irq(&kmemleak_lock);
>  
>  	rcu_read_unlock();
> +	if (scan_gray)
> +		scan_gray_list();
>  	cond_resched_tasks_rcu_qs();
>  	rcu_read_lock();
>  
> @@ -1910,7 +1914,7 @@ static int __kmemleak_scan(bool full)
>  		raw_spin_unlock_irq(&object->lock);
>  
>  		if (need_resched())
> -			kmemleak_cond_resched(object);
> +			kmemleak_cond_resched(object, false);
>  	}
>  	rcu_read_unlock();
>  
> @@ -1981,8 +1985,13 @@ static int __kmemleak_scan(bool full)
>  	 */
>  	rcu_read_lock();
>  	list_for_each_entry_rcu(object, &object_list, object_list) {
> -		if (need_resched())
> -			kmemleak_cond_resched(object);
> +		/*
> +		 * Scan newly grayed objects now, not after the walk: one may
> +		 * hold the only reference to another and be freed by then,
> +		 * like a maple tree node that keeps being replaced.
> +		 */
> +		if (need_resched() || !list_empty(&gray_list))
> +			kmemleak_cond_resched(object, true);

I think that's a good way to reduce the false positives for such maple
tree scenario. Do you have any numbers on how much this extends the scan
time by? If it's too expensive, we could rate-limit it, say every jiffy.

>  
>  		/*
>  		 * This is racy but we can save the overhead of lock/unlock
> @@ -2082,7 +2091,7 @@ static void kmemleak_scan(void)
>  		bool dedup_print;
>  
>  		if (need_resched())
> -			kmemleak_cond_resched(object);
> +			kmemleak_cond_resched(object, false);

Nitpick: instead of passing 'false' in a few places, rename
kmemleak_cond_resched() to kmemleak_resched_drain() (well, some better
name) call get kmemleak_cond_resched() to call that with 'false'. We
could also move need_resched() in such function, being a small wrapper
the compiler should inline it.

Either way,

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

