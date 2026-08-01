Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 565FEC54FCD
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 09:25:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 555FC6B007B; Sat,  1 Aug 2026 05:25:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5077F6B0088; Sat,  1 Aug 2026 05:25:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41BD56B008A; Sat,  1 Aug 2026 05:25:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 199E06B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 05:25:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8F9DC120279
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 09:25:47 +0000 (UTC)
X-FDA: 85052168334.07.52EA3CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id DC250180003
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 09:25:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MWOrIDhk;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785576346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dnH8kMzvuedz5XR8h84XFqr31pF3AJSMqise3dLXv94=;
	b=BXWi7HtKLtrv73y497bs1ESczuo/10fZXz07lSuIt+26KiLo/ShkT54sPWV8khBqqrVur3
	PErmxW3UH7uIu5ylpYEe4aCMejjxuP+D3TsNcQ1H3wXLHVsVacONVkr6Dtj8QAt7rbq+OO
	gIiFubCGw021Q74BDNtZ4HTq4LqKZDw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785576346;
	b=iHeNjtqiA4EcGvZrq1Xr8qxFDJ178s0Wkm0G7ADapJckBE87T5skHWfVpnLGy2kAGuVghM
	s4XXeswfqkdASE9mwmfYOY4U17RHz3DYZ6TPK0CFJ7bEv6FQDRL3GlzwGoFHJpJpXjnhk+
	Qe0fUgshKZqUwRcJi0uM9PvmZ3PKBMU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MWOrIDhk;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E89942ABA;
	Sat,  1 Aug 2026 09:25:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC0F1F00AC4;
	Sat,  1 Aug 2026 09:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785576340;
	bh=dnH8kMzvuedz5XR8h84XFqr31pF3AJSMqise3dLXv94=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MWOrIDhk7NpRd710mAh9X31XwxvhTvYZO67pcOs5p4384DYr18f6yJ2dMsHnrL7U6
	 oqr2JLYspbFKTp695RDOwABAwGtkT4W46Whhzc/EyvIHxZO6jOcpVJ6dVlbkcSMETp
	 qLyeaMZKLdl2h2zUzXedcxjFCIftmYVifVM4K2D47iVGgZ6jiU6jYOq/XVDbMCUHq4
	 4MGJnAYhvegUBckzxfHOdHXMrF1L/T7Bfynw0dyBPMeoz2KkRIeTeNRUSrtfBosWA6
	 EHRowDuVeHERq7mfdVmgrziTxmd8C/AulssOsb5KYw0dI/TmxZ50cIU6X54tEUJvrw
	 a5dr/5n+1waEA==
Date: Sat, 1 Aug 2026 10:25:20 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: pratmal@google.com
Cc: akpm@linux-foundation.org, vbabka@kernel.org, david@kernel.org, 
	sj@kernel.org, corbet@lwn.net, skhan@linuxfoundation.org, 
	anshuman.khandual@arm.com, gthelen@google.com, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, liam@infradead.org, 
	rppt@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v4] mm/page_reporting: Add page_reporting_delay_ms module
 parameter
Message-ID: <am20uLFuMrJH9wfN@lucifer>
References: <20260731193705.2902728-1-pratmal@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731193705.2902728-1-pratmal@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DC250180003
X-Stat-Signature: wb9z3fgc5o6m3o6omoe9ya7pkwobipag
X-HE-Tag: 1785576345-261803
X-HE-Meta: U2FsdGVkX1/+IavxbdHJRlaVxAPiS86OxtpOodPEdDRUuj5f28SQFVBoTJvTJg8VyFG7gg+PI+Utd/L+1sTVT0zPRCiL/5iKuosXwSEkX/zUkcEWwHOUaXIs3PUC6i09cH1tQv3oCOlnKBGk273xWsBQd9j0ds6uVHCeafK6ECo9/F6Q1bFYyXjri4d/k4jJsLiNmXC1JYnA1mUD0B9jG9XQHL8OXJr/o5Z1N7YvxnTp9I68wzCCzMjqJKAvRrSr2UqY+3vUPFKJvIIh4VMDiy8D94Le2E3HFT2SmO4BHXfczsPaqVmWtzcvRCSnPtds7oaem9Xz35DHXtnSph+5xekKJY2NKJ1N1JSmpQqDio9gdd5D+JuhYa4aipKXVSaRd2l5eqOXi+EISwb5yOTxKrlrpi1nupzCA4jNRmFOt/t57ebSUfyefmt9lIPRsWVDMUoR46qFAA5QtHK2Cey9P9v4BxF43KV2OjF/VxEY2K8HWAMVGf82bPCoAM0vK8XkAogoM8ILXC8KnymBKVTFNYXurwcI8ubAmJM9G7hEs6+U2tvmUfYPoFTzJctA4KbTIDe74LhBhi2YfPiHakydMDx6d/kTQ/LytTQ3vHhQT9mXYWsJ1burqqlPnz7P/u/vmjCNISPdyfe7+JqnWwfKqrT9BonXr8/agW38BgnD6y54t7fUv8m6LFSXmMRAl2FO580bs6d54HH+ZtiLpNiOv4jEg+vT3WQOA0Ym3z96HUJmel/EqQF33GMM3vzMSyt4OQZtM+Kze2hdmGpe7Cxn00ht6n2MfOmy+S4+idNYl8eozywm69NumzDMHyy2qdRj8h42vLWGE7pxP9sLoa5w6/4y82OUx1PvYFQIGKDVDos/OWM6zCsBl2zKNiH/SgRAT0XFiTUkHw+viH8f8uKRfBDWOh6daGRhVVgAgit74wXGN2l2c1T4+IsKwWqefGADMn2b+PEdKn6BHNat7fh
 bQalpddy
 jZZZ3SqflMrsB8wbVLMyUSI+KaJQTF0tQT0nYemcnv9VbaajaCN0h+m07ahBkJaLTf1DJ/x+F5n+EaMyQ1lvaD7DXeURVMag15FKpCRKAnOIWHiTkeweeIdQR32e1AKFVsciqqY7LKt5L2DLMzvgA1yPlGUBi1aRuJqWKybRk4WnosmMSR4OJdQsQoO+odk0Ln+LPsG0Dy33gES0plWKbBbEZc0Y4pMc19U3FwrErkLQwGairnyOP1FE2nDvTRwORGaNQ1tMlBp5KT1uuV1fvhiSVosgYryS/0qB4ZiTySvowcpBod/o+ccE+gj3rSgiEgWJBZn3gqq6DY6NamaWPwrfbAm22RdpH7kKw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 07:37:05PM +0000, pratmal@google.com wrote:
> From: Pratyush Mallick <pratmal@google.com>
>
> Free page reporting currently hardcodes a 2-second interval between
> reports. This rigid delay cannot accommodate diverse guest workloads.
>
> This patch introduces a module parameter, page_reporting_delay_ms
> (default: 2000), allowing users to tune the reporting rate:
>  - Lower values enable aggressive memory reclamation by returning unused
>    pages to the host immediately.
>  - Higher values help batch pages during spiky allocation/free churn,
>    reducing hypercalls and nested page fault overheads.
>
> Setting the delay to 0 is safe and execution is strictly gated by:
>  - reporting is only triggered by high-order page frees.
>  - expensive hypercalls are bounded by a slot capacity watermark check
>    before proceeding.

Thanks!

>
> Signed-off-by: Pratyush Mallick <pratmal@google.com>

LGTM so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> v4:
>  - Added a helper function for schedule_delayed_work().
>  - Updated the commit message.
>  - v3: https://lore.kernel.org/linux-mm/amiPTPKfTOEpgetH@lucifer/T/#t
> v3:
>  - Converted page_reporting_delay_ms from a sysctl to a module parameter.
>  - Dropped the max value cap (PAGE_REPORTING_DELAY_MS_MAX).
>  - Documented page_reporting.page_reporting_delay_ms in Documentation/admin-guide/kernel-parameters.txt.
>  - Updated code comments in mm/page_reporting.c to reflect dynamic parameterization.
>  - v2: https://lore.kernel.org/linux-mm/3da27fde-25dc-4cb8-8e05-74cd26fc2f7c@kernel.org/T/#t
> v2:
>  - Documented page_reporting_delay_ms in Documentation/admin-guide/sysctl/vm.rst.
>  - v1: https://lore.kernel.org/linux-mm/20260722192935.1646848-1-pratmal@google.com/T/#u
> v1: Fixed feedback from RFC.
>  - Added lower and upper cap to sysctl value.
>  - Reverted the reordering on page_reporting_delay_ms.
>  - Dropped the mod_delayed_work() change.
>  - RFC: https://lore.kernel.org/linux-mm/20260714171456.2350037-1-pratmal@google.com/T/#u
>  .../admin-guide/kernel-parameters.txt         |  6 +++++
>  mm/page_reporting.c                           | 26 +++++++++++++------
>  2 files changed, 24 insertions(+), 8 deletions(-)
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
> index 942e84b6908a..c01aa3af80f3 100644
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
> @@ -56,6 +60,13 @@ enum {
>  	PAGE_REPORTING_ACTIVE
>  };
>
> +/* schedule work for page reporting */
> +static void page_reporting_schedule_work(struct page_reporting_dev_info *prdev)
> +{
> +	schedule_delayed_work(&prdev->work,
> +			      msecs_to_jiffies(page_reporting_delay_ms));
> +}
> +
>  /* request page reporting */
>  static void
>  __page_reporting_request(struct page_reporting_dev_info *prdev)
> @@ -76,11 +87,10 @@ __page_reporting_request(struct page_reporting_dev_info *prdev)
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
> +	page_reporting_schedule_work(prdev);
>  }
>
>  /* notify prdev of free page reporting request */
> @@ -335,12 +345,12 @@ static void page_reporting_process(struct work_struct *work)
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
> +		page_reporting_schedule_work(prdev);
>  }
>
>  static DEFINE_MUTEX(page_reporting_mutex);
> --
> 2.55.0.508.g3f0d502094-goog
>

--
Cheers, Lorenzo

