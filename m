Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACA47C531F9
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 11:14:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C3206B007B; Tue, 28 Jul 2026 07:14:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A0A46B0088; Tue, 28 Jul 2026 07:14:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D90F6B008A; Tue, 28 Jul 2026 07:14:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1403A6B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 07:14:10 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7B9BF12034D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 11:14:09 +0000 (UTC)
X-FDA: 85037926218.27.B16C6A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id E74D41C0007
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 11:14:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LPe50sZM;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785237247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/BnA39edsDXhZakbSq/F6cdj+/HFBLubHdNOwS7e3lc=;
	b=OGOc8qBtdHLMcAzcqYQa6kAMw3gYaMad6cZUqI/b+Dmls9VGJKInpD+PnRrT/ExldtklDN
	Lz0bcGKNwAYaTnJUG2wS83rsadw/4qmqepNFY8Zpr3YSjhrNFUuAXcSM+n0ACxYzSW8jLo
	2lrPpGlz4aZDSltGruLqZGKfhUjZZNA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LPe50sZM;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785237247;
	b=RI/HszbVPmPzrYUUHAxBWsEw2H5iR6CDRPBOu+h0HLXNd7KyVU5SiIUsOnbj9lwZcCdQNE
	Jl8+GOJZSIEdQP3oqn85wrZiGIg96u8Lx8znH6IRxKh0CifAACIwcDK457BkOKrl0T4ra1
	ZDn8hSvSXbm42Wve9LPrLN6vyKYovZo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 64C3A60AA1;
	Tue, 28 Jul 2026 11:14:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C511F000E9;
	Tue, 28 Jul 2026 11:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785237247;
	bh=/BnA39edsDXhZakbSq/F6cdj+/HFBLubHdNOwS7e3lc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LPe50sZMCYDr5ixko7ra5gKEwb0+j0gXOXX4CM3QC+CiJqhJak1d1WcSv+sPYIEVD
	 p8++6py3y9YXp7doinEsW4t9gBYPbK7bNtqpyoFnrJ2sJigaKT4NjX/eHUuEYh2oP1
	 az+wML4CXB6vuSXAD/2INNsO0nbBSuDp/HWdb9UFN+Ue2ojnObeZZt7lC6EPXzSHhs
	 FKEDMcQNIsuiMJ8PxDUQRjHDJon013BoUoyNMGC56Je43OPRz4K0j/Z/O2bQ2Hhb+G
	 1QsVycOSnT4mVfeiITd2NizLtkcCU9sIBcPxofjqYqjkEeuR0C3HeiDnW54V64RDVH
	 Pwl0mKsPWpAdg==
Date: Tue, 28 Jul 2026 12:13:47 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: pratmal@google.com
Cc: akpm@linux-foundation.org, vbabka@kernel.org, david@kernel.org, 
	sj@kernel.org, corbet@lwn.net, skhan@linuxfoundation.org, 
	anshuman.khandual@arm.com, gthelen@google.com, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, liam@infradead.org, 
	rppt@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v3] mm/page_reporting: Add page_reporting_delay_ms module
 parameter
Message-ID: <amiN82J8p5z9l_Rm@lucifer>
References: <20260727230545.262579-1-pratmal@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727230545.262579-1-pratmal@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E74D41C0007
X-Stat-Signature: rqakoepujtw8qmsecf9kgtkt8mqp5iya
X-HE-Tag: 1785237247-75946
X-HE-Meta: U2FsdGVkX1/872fynDF9sKJO9gu+ObnoVP5LrNSE2jBeRJXq0qacU8e8IvjzIq3WkTY+I4/5v9wEmqKDgM2PxR2AlhdItYsDPIarO0drionMLuUcc8gCpCMEbICk8HXr8Ym6ewTmLAWj+z2lw/+ZYbsAAkRGxD/YFfMIS8eTAnSLGkxBFH/LrfEWZjN5J2bOAhWaacRI1KnGfnIno+TW2YCp1ZXMlxELyKnekOEEOVZA223J+Cp5fhi5iDDfQR+OZBPMMktOK/5VEq6wFBoASRt+BwJgHChoSctBo+CfQ4PxLQqG1VzqmHtF8aHd1Ujth6q0wRmG8CJKh4e88lzPax7GfjU3oeFtXdO1JifR7WYCzoym3OWssdEwonyg5nWm4J78ZCAj9ipvda7ty3A9Lfh9af4K1Yfbv50ZceSzbsJ+4G6uQeIcKiQhx1A7U6crql4U2FK2H+i2ae3v/YKOl4NMxgi1xLitm43wUDLU2Tu09pNevdqO0Ds2f5WLSXs2BvbAeUCLyYCJfQ5nuqRT7odNbXSQk5iJVR59r0JLfs6obtN3W7sfwhPISN4Ji7HCRFLtXr7TmBV5/o8qV/aSPB+WflOu3nJAWbViWW//VmLNcetoEuSg++QsimEfe4FL59EqtLd4LCoLFjv+NfJZg7og6hWd+1Q9tjGWLp6Wp6h7caZ8odRpbC329Au5rhtmdteKU04BWrgMqX63kEkCGlRGUPQuNw9HaxMosLPsAQWvZiS7uhHwaRj4QFvXR9vFt1IvJ3zvtMFhplZ/JOZyv+BuwvL44xHpZTl40f9GJf/0uGc1JhyHdpj+plkJX3xg3/Vv+elIQyhlAaFnRpF0QGT2rBrVFR6k+hweUrhHS2n3P3adCjPTm0jSC1p6PFKHtYbMqQuRnfMcBJd8M1kLMjEdsH0wmdv2AwylkK08OB9rCREY1kKc2C6lSsuhp/CSji4qZ5B5N7b15THBgiT
 1zCoLuyt
 /7vS8iiYW/wzfDhifk56c+JApsoAR7nMllCjtUgFWUk043gciRTECg+3AEwiPUDenjGn1Q0a8nhVphPyIa9KikqvxWuvC7cjFs6lsTjutL76jEtX9Wl4tu9Ycqy7qKE195Gbtgfj3TizIMaAoKtyQgSk4GIfRGtfNSY+yCPZYFsmO8oX/n6QDtYaCz//IbCQw2SfJsdB4aAzVCh2ui923t+0A0JMGVLg0GleyUKG687HmYrFTlsq4x6CXf8wkh8j6VXTSXUFFmcgNzvWTAwVhO4Xaefagq6rLonlhoiw5hwvm9JkbcngQk4NaRKOwN8Vth2zjp85/3Cmzid8Tq4MChSiwH1r8+35pcDXH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 11:05:45PM +0000, pratmal@google.com wrote:
> From: Pratyush Mallick <pratmal@google.com>
>
> Currently, the free page reporting uses a hardcoded delay of
> (2 HZ) between reporting intervals. While this is a reasonable
> default, it lacks the flexibility to adapt to varying guest workloads.
>
> A low delay allows aggressive memory reclamation, returning unused
> pages to the host as quickly as possible. However, during spiky
> allocation/free churn, this immediate reporting can lead to a severe
> performance penalty (nested page faults) as the guest re-allocates memory
> that the host has just unmapped. In these scenarios, there is benefit
> from increasing the delay to batch free pages over a longer window,
> absorbing the churn without hypercall and re-fault overhead.

Since you're talking about increasing it, maybe set the floor at the current
value of 2s?

>
> This patch exposes the delay as a module parameter:
> /sys/module/page_reporting/parameters/page_reporting_delay_ms, measured
> in milliseconds and defaults to 2000ms.

I'm not sure this is great as it means we now have a parameter we have to
support forever and autotuning becomes harder to implement, also if later the
implementation is changed, this might prevent a reimplementation.

Have you considered actually adding logic to detect the problem you're having
and delay in that case?

It seems like this is the "easy" solution but it has a price too.

>
> Signed-off-by: Pratyush Mallick <pratmal@google.com>
> ---
> v3:
>  - Converted page_reporting_delay_ms from a sysctl to a module parameter.
>  - Dropped the max value cap (PAGE_REPORTING_DELAY_MS_MAX).
>  - Documented page_reporting_delay_ms in kernel-parameters.txt.
>  - Updated code comments in mm/page_reporting.c.
>  - v2: https://lore.kernel.org/linux-mm/3da27fde-25dc-4cb8-8e05-74cd26fc2f7c@kernel.org/T/#t
>
> v2:
>  - Documented page_reporting_delay_ms in Documentation/admin-guide/sysctl/vm.rst.
>  - v1: https://lore.kernel.org/linux-mm/20260722192935.1646848-1-pratmal@google.com/T/#u
>
> v1: Fixed feedback from RFC.
>  - Added lower and upper cap to sysctl value.
>  - Reverted the reordering on page_reporting_delay_ms.
>  - Dropped the mod_delayed_work() change.
>  - RFC: https://lore.kernel.org/linux-mm/20260714171456.2350037-1-pratmal@google.com/T/#u
>  .../admin-guide/kernel-parameters.txt         |  6 ++++++
>  mm/page_reporting.c                           | 21 ++++++++++++-------
>  2 files changed, 19 insertions(+), 8 deletions(-)
>
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index b5493a7f8f22..364c2dce8e70 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -4810,6 +4810,12 @@ Kernel parameters
>  			Adjust the minimal page reporting order. The page
>  			reporting is disabled when it exceeds MAX_PAGE_ORDER.
>
> +	page_reporting.page_reporting_delay_ms=
> +			[KNL] Free page reporting delay in milliseconds
> +			Format: <unsigned integer>
> +			Adjust the delay in milliseconds between free page
> +			reporting intervals. Default is 2000 (2 seconds).
> +
>  	panic=		[KNL] Kernel behaviour on panic: delay <timeout>
>  			timeout > 0: seconds before rebooting
>  			timeout = 0: wait forever
> diff --git a/mm/page_reporting.c b/mm/page_reporting.c
> index 942e84b6908a..a67311468204 100644
> --- a/mm/page_reporting.c
> +++ b/mm/page_reporting.c
> @@ -47,7 +47,11 @@ MODULE_PARM_DESC(page_reporting_order, "Set page reporting order");
>   */
>  EXPORT_SYMBOL_GPL(page_reporting_order);
>
> -#define PAGE_REPORTING_DELAY	(2 * HZ)
> +static unsigned int page_reporting_delay_ms = 2 * MSEC_PER_SEC;
> +module_param(page_reporting_delay_ms, uint, 0644);
> +MODULE_PARM_DESC(page_reporting_delay_ms,
> +		 "Set page reporting delay in milliseconds");
> +
>  static struct page_reporting_dev_info __rcu *pr_dev_info __read_mostly;
>
>  enum {
> @@ -76,11 +80,11 @@ __page_reporting_request(struct page_reporting_dev_info *prdev)
>  		return;
>
>  	/*
> -	 * Delay the start of work to allow a sizable queue to build. For
> -	 * now we are limiting this to running no more than once every
> -	 * couple of seconds.
> +	 * Delay the start of work to allow a sizable queue to build.
> +	 * We limit this based on page_reporting_delay_ms.
>  	 */
> -	schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY);
> +	schedule_delayed_work(&prdev->work,
> +			      msecs_to_jiffies(page_reporting_delay_ms));

Err, do we not want to limit this to something sensible? What if the user
specifies 0 does it just hammer the system at that stage?

>  }
>
>  /* notify prdev of free page reporting request */
> @@ -335,12 +339,13 @@ static void page_reporting_process(struct work_struct *work)
>  err_out:
>  	/*
>  	 * If the state has reverted back to requested then there may be
> -	 * additional pages to be processed. We will defer for 2s to allow
> -	 * more pages to accumulate.
> +	 * additional pages to be processed. We will defer by
> +	 * page_reporting_delay_ms to allow more pages to accumulate.
>  	 */
>  	state = atomic_cmpxchg(&prdev->state, state, PAGE_REPORTING_IDLE);
>  	if (state == PAGE_REPORTING_REQUESTED)
> -		schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY);
> +		schedule_delayed_work(&prdev->work,
> +				      msecs_to_jiffies(page_reporting_delay_ms));

This code is duplicated, while you've making this change maybe pull this into
its own function?

>  }
>
>  static DEFINE_MUTEX(page_reporting_mutex);
> --
> 2.55.0.229.g6434b31f56-goog
>

Thanks, Lorenzo

