Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C14D4CD37AC
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 10:18:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD46C6B0005; Sun, 17 May 2026 06:18:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D854B6B0088; Sun, 17 May 2026 06:18:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4DFE6B008C; Sun, 17 May 2026 06:18:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AFBF56B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 06:18:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4BFA31204A9
	for <linux-mm@kvack.org>; Sun, 17 May 2026 10:18:00 +0000 (UTC)
X-FDA: 84776511120.01.86A25FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9B485140005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 10:17:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BrB+T16n;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779013078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZCkN3CP7OdEUHRCKYw7qa8nK+EbFRHVG/U6scz8hx0I=;
	b=OMh39H8X5HYF7FJTGp/WcVZmSLX/iDMOZ5To5o44fA2pZIcSeSx1ulca2vqx/g5qNRkOtT
	1KdCWHVdbywNTD1fi01TRoEL4iUPBGnU3tt88rUkbeEZqggK8Bjy4KuxdSmOftjLyWq6YT
	GxH7XM2nO01J04I6RLydFwz1k8x/gYo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BrB+T16n;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779013078; a=rsa-sha256;
	cv=none;
	b=aktDjkh0aegoeq7eCs7BoaMLCd8TLQvWhOe0py3q8IlXAMz0Iyt+UgxcpzzLex5Qwwi/dO
	UP2+qhvp2Y5OuvfCkhBSPbouYFC8HnpRBaffHH+NQFVB1aqPAz3D1wyHr9UZ7RTa06t74u
	qOskjnTdvk89hP6eudexgjj2zufDuGc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6CDEF4173A;
	Sun, 17 May 2026 10:17:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A241C2BCB0;
	Sun, 17 May 2026 10:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779013077;
	bh=I0qBvfgj53Jp++THC/CCO/kmcft0x3HCmB3+tnF/LrU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BrB+T16nkVTMYt7xlK0QT3nNBbBQ+u+K50tCW25pJhVN7Tk8vwPMUY6PohUVHQirK
	 Jo8KYGxg5BGZCUOkJA3Bl1g6m4lKrOEK99Z4tKh2Aah2YmetX8SZZ90yEkmLkD65Z4
	 K8JC/2KDCJwfgxlPArmvmM3oyufCLsftE/evV74sNDUN4gytbYFqRQtbvxO71Xxhgg
	 bda/SQC65qNuJOutl7qu6rWZcHGKXV5WutSxCYxd649o/XUrgEEmUllL/DlriJDShh
	 VsoGofQGL1PgRdBPxkmIdkR2y+Nau7KHQwsMr3VTaSUFbF/1hYlIPlV0q/A4TAGJaQ
	 zGyVf7Hno9FGQ==
Date: Sun, 17 May 2026 13:17:50 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/12] kho: extended scratch
Message-ID: <agmVzhvF8cxFu1PK@kernel.org>
References: <20260429133928.850721-1-pratyush@kernel.org>
 <20260429133928.850721-11-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429133928.850721-11-pratyush@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9B485140005
X-Rspam-User: 
X-Stat-Signature: 76f5od8o8pytm8qbp498ryh38duhkzzg
X-HE-Tag: 1779013078-864757
X-HE-Meta: U2FsdGVkX1/io0LUEOes2pfYdZdn9Koud4QT2sC0WS2LOvbH00WohaKQe8DDcNODfOZ1yXHBXFGj3U0U6lfbecIwZYSBe+QpwuJpW9lv7Kw0WK59lbL7zMgojC/XhOyROJS01Ya6Y+AUFUfiTHowxN7vEi9anHOweiyt3dZhTfgIrWp2he1DN689G152h1JmiC+v0AszE+3KSJqDCw5BlrsNYAT103sCH8s7mTAQ09dSSo7QMS51AyF03mgvgGqiRkRxFDiRnhwMZhY3F/D9Ao8IFB0xibrWDVyEARoVL57KTUkZDevP8i03EeQl+RKf8Cl0M9TIGblO2xNPnEOHbGtYjzHAJ+dBujSF+CPQAgMSFOUe0od+Vk/sv7DcP6UoHiemTVDu/JF/+deegqwy5V4X9d4PKRvzdjxBgcwL/fn1bH2yW+WJbz1IPOQLkh57FPzujfbQaLtFlwN7GBgGn1rVn6Dun8+FO9ZoKocXYpyWlFnWD9ffFHizc4CzKRJEmYXrc4pt4EpR3E5UB3V9Sm3GwSneiJ13eJU8Pa4EMkmcwnQmGNRAvCVHawe+dJ6sBEg6gU+bSBNEPHUG+BQmznR2Mh+/23YXLrYKB0vvHYM66fu8vuVtKO2+6iCP4NI7v5M/le5wV/bp3Eggc7k0KGU8vJP8YMVP26lgp2FKLo9cjI6nlIlzEwfjjsBkutVf1xbFjyvV51kGNXsIVmmPYSgpAlhjSCyfbue+nqX3hrX1oRrQaBcJFhBeqdcOz3Ugj0cgs+imalU02QgnK8Wg5acXdRzV2HPaE93ipBP5ZmPApqER4kgFCYlCeLiOGLzN7UsPcDQvY6sAO090VzRGJRjmyNsLUsrieBfBsetqoSUAHTntxRD5dxGU1fBUrFvkuIi4ciqr0yjOK/8Y58YbYezOuBGJN3Kat5zR3uSjeLoL7OcX4ncLOHSD7VFoHBjSrjojDwIZEBRRF6pKl2j
 FDWfBVK/
 +SLV/fidDJPWKqF1rYS5uZBG4bIZAWmiXgdJFiK7Y1oABi6tESA4T+UObATEvCr1VpAA1KGocklnt1bTch1VdU2kYgQ9W+qsimVmoEezk5egpqZZWrbMHRej+TUpu2mmfL+w+xsj4QoV+63IyZ5Kyc3r72BYrigoSDYLM4Xer8WUvmlNk1rkl06qAPlP8BwMNw6HqyS09Mi//I/x07mpEa1G9NTP/yVe/rLFcU45jRiaUWuQGVxfG5kFk+BTOw9EhG3e0T3TvY6DfNtvXr6xQPPBkMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 03:39:12PM +0200, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>
> Methodology
> ===========
> 
> Introduce extended scratch areas. These areas are discovered at boot by
> walking the preserved memory radix tree and looking for free blocks of
> memory. They then marked as scratch to allow allocations from them. This
> makes KHO more resilient to memory pressure and allows supporting huge
> page preservation.
> 
> Since the preserved memory radix tree mixes both physical address and
> order into a single key, and does not track table pages, it is difficult
> to identify free areas from it directly. Walk the tree and digest it
> down into another radix tree. The latter tracks blocks of
> KHO_EXT_SHIFT (1 GiB as of now) granularity. Then walk the digested tree
> and mark the areas between the present keys as scratch.
>
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>  include/linux/kexec_handover.h     |   1 +
>  kernel/liveupdate/kexec_handover.c | 148 +++++++++++++++++++++++++----
>  mm/mm_init.c                       |   1 +
>  3 files changed, 133 insertions(+), 17 deletions(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 1a04e089f779..c2b843a5fb28 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -840,6 +857,120 @@ static void __init kho_reserve_scratch(void)
>  	kho_enable = false;
>  }
>  
> +#define KHO_EXT_SHIFT 30 /* 1 GiB */

arm64 does not necessarily use 1G gigantic pages and worse, it can have 2
gigantic hstates.

I think this should take into account what actual gigantic page sizes are
in use for the general case.

-- 
Sincerely yours,
Mike.

