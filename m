Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3385C87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 10:03:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87CF88E0005; Wed, 30 Jul 2025 06:03:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 806718E0001; Wed, 30 Jul 2025 06:03:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F61E8E0005; Wed, 30 Jul 2025 06:03:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5931E8E0001
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 06:03:39 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1185813427A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 10:03:39 +0000 (UTC)
X-FDA: 83720494158.13.6B26416
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1968C140003
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 10:03:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753869817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ctT8usOnPn1H+DSFTdQJ9TYQorT4/UWN2MxuxAh+pYM=;
	b=AzzB6wHU/f8oM/R/OGkci10t6evAxh+eQLJyMVHZh93D771j3N/HUJvPVTYMqiefDmLTcn
	oaXiK9qzyUlaMohEYYKNQgsPhI0KHlJ2keyXis6ngw69oxE4ZITdS3USPmwG+SDvQsQW8P
	uOi2UmN1l26lmdYgjOnmPQn5/ub15ME=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753869817; a=rsa-sha256;
	cv=none;
	b=Q9fAtzwKybOnnV861oevyU1WI+6Y82mwUcwQvaA/mzAPgzkhalMG5u9RJJpQxCz3MR8oCY
	8MwDRUPBMiUE90tjIaRIhrMjJcXlhJYu16htpR83AVJNjN5fcfvU/M4xbmHlWiIftlUtyp
	DyteOGqjnfAhrd/E1+K9ri8+iXG1knc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 11DE91BC0;
	Wed, 30 Jul 2025 03:03:28 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5F38E3F673;
	Wed, 30 Jul 2025 03:03:35 -0700 (PDT)
Date: Wed, 30 Jul 2025 11:03:24 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Waiman Long <longman@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/kmemleak: Avoid soft lockup in __kmemleak_do_cleanup()
Message-ID: <aInt7Fa6N7Y3zW_K@arm.com>
References: <20250728190248.605750-1-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250728190248.605750-1-longman@redhat.com>
X-Rspamd-Queue-Id: 1968C140003
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 61q4bitsdd71sya7x7qkjdextr481e7d
X-HE-Tag: 1753869816-664567
X-HE-Meta: U2FsdGVkX1/kKA2bLZG7XOqLFwtgkrA2/WKFjBhxbgrYyqHzLAz2W7eH+bTcrcRq6FlZzqt9FGeIVvgCVfz9WYpzmR14CLidtYFl6nlU8AKmtJE+qgNShJ5jUm/k0DU3tAVdrgBJteuCeib1uVICH85bUhTnjqK55bmA1S78WBeoBtuFj22h29wi4i3EdaC6FAzU+oaV+3Z8Nje0vyZJriK6aLcTmslvtBeSdiXjfxmGveyqah8ccW965trEAOtDcP1C/+13ryEaNoiWV0JvqZGd87Ro44oRu/gHq9E9suEtap+ffL2XWRysIfSmsgt7HYgE9HG331FFm0fcbRsahUrJXNhGLOkQwbYShPa2sejOodQv921SjEqpjlcE1SdlzID0iP1rZ17SsJZrf8OIdfyS37I4WXD3y95xcS/yEZ31opiBVQrG9gc5dt8jBgc6EEmTh8vuevOOUSTJ+P2dlpHtaWJdOMUfWQYFLO5szbc4HmaY5H4Z1qRN86/Mfj/0Qp8Xzi+aRdsS3NQ2kV87gfO02ropSJzmQMBAw+gEXmbhFdObjiU4ZMxtUL/FYyZKCpSB6S6WRrzoY72avTusmZOig6tp4wvohnpMcGvUMhPDwZ85VTicSln+HfaI+yfAL0wXD1Qrv3vZSupm4mcPuPXr6C5lRxiM4omSpo8pxro3nfak1WeGGSmQI0FuJJbVg7lr1qp412H+ifs/hP3kFJEGUJQ2PE6V6dJP0NvodjqWjVPOHTKWjX+/7nFDwHC+hXoLSKlD55I1T9SnqRYu3KCf9pDFPhDwEfgwzZjekHi/sGvev8C1EhdymSHWAHSwdejEx+8qo7hjJQRvuGigJeXJ9yCnaPk/lU0Yplo4dUv6ja6xGbew+0y7NVryAVIMr5lWlX0nlnPjBS3p7vxAJ2GUOCZynTzDGW3tNBWqNGope/dSMnhiKBCvC0BcVLVAdHPvQpR0r3ZAvk1wD0G
 zd79MzN4
 QIrJMUgChaUEmwScQAEw9d7dOXmZY4ibFsbfeyiunA4Dx+2qf7Vxja2qV4be2DHB/ZlCHNhTecmOCYWkw5b1fOWB5IdGfRN415GWHpdsiPYhHWGqs5w6d8uQta66mKiMzIs5mb/FQEoeSCRgw4A1aDGXMaj9hyUWTCNSjOdxfoffxgS1JvsD5MDVMnxi21rgIR9RGWxXTPcdRZdnPr75V2n2V1k883vd7MNxCtgYti/xZ2Tn4aflMx3S21k+6csbn2t0EH/Mc8vwzKZw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 28, 2025 at 03:02:48PM -0400, Waiman Long wrote:
> A soft lockup warning was observed on a relative small system x86-64
> system with 16 GB of memory when running a debug kernel with kmemleak
> enabled.
> 
>   watchdog: BUG: soft lockup - CPU#8 stuck for 33s! [kworker/8:1:134]
> 
> The test system was running a workload with hot unplug happening
> in parallel. Then kemleak decided to disable itself due to its
> inability to allocate more kmemleak objects. The debug kernel has its
> CONFIG_DEBUG_KMEMLEAK_MEM_POOL_SIZE set to 40,000.
> 
> The soft lockup happened in kmemleak_do_cleanup() when the existing
> kmemleak objects were being removed and deleted one-by-one in a loop
> via a workqueue. In this particular case, there are at least 40,000
> objects that need to be processed and given the slowness of a debug
> kernel and the fact that a raw_spinlock has to be acquired and released
> in __delete_object(), it could take a while to properly handle all
> these objects.
> 
> As kmemleak has been disabled in this case, the object removal and
> deletion process can be further optimized as locking isn't really
> needed. However, it is probably not worth the effort to optimize for
> such an edge case that should rarely happen. So the simple solution is
> to call cond_resched() at periodic interval in the iteration loop to
> avoid soft lockup.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>

I agree, it's not worth rewriting this path for an unlikely event. So
I'm fine with this approach. Thanks.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

