Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 475ACCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 14:32:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72ED38E0146; Tue,  4 Nov 2025 09:32:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 705FE8E0124; Tue,  4 Nov 2025 09:32:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6439C8E0146; Tue,  4 Nov 2025 09:32:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4FD4F8E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:32:52 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E575A598A0
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 14:32:51 +0000 (UTC)
X-FDA: 84073166142.08.A6206E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3E112C0005
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 14:32:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hu/DmIlA";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762266770; a=rsa-sha256;
	cv=none;
	b=mLgHI0vZWdeevxvrPBDOFYcUhr7WGLYRlHG4BszmL/90M3LJFIQLUKp4ec/YtgJ5LJ6cc3
	FhZxK/EKmle6h8acrYoDqvjeeMchccP3nBabtLndg/tsaqlHmwdu4iEZuuY4ctqSPPkhp/
	bRc2/eOMbJN7EetMfwW1G/oknxBhLPk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hu/DmIlA";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762266770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u8h3zkk6XvoyFPdG4z5IRHQ5HEXCtEyF3cXPVMqWwBU=;
	b=WyzFEQGnQhuEDgCUaI0SHnYCiuHzCzE0ub3ybVqOikSN2v5HW7YV5BCW41kc5LzlLSS7xv
	6gxXnB9uG0yGASHrlMwAnjhBbylhpMIMDZSnNyHYuhpO/m3PjfUg12Y2xXxi9XUAV/E5hb
	EM9uxFBYzdLQtJnlA5Or7ObNSN7lez0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 511E640481;
	Tue,  4 Nov 2025 14:32:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6212DC116B1;
	Tue,  4 Nov 2025 14:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762266769;
	bh=RORlDZODXaQvDU2xYSdqK34eg3g039xujjqxDT3MR80=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hu/DmIlAB5Kq9YX5KdYPEScDdxOcvtnhommT7pX+0QcphEpKxyk1bEZbEyk8V0NEk
	 a0wrz3MWKZhMkalsjp3HtpQS1Eym66KN0kQm2gCu6/zd8BkRtQ+Cff5zRUZ+JpyOnZ
	 hxM3eNqaBWAsZoCe6WoOlQhhLmxyWYo7WGWF64mUjG1Z0hOQRJg7xLa8RPmtRjsJst
	 gqyR5LibszsQsOEBd3iV9M5JM2WueL0l5P4Bc7Q86iT3hTijngXJIJu5oHWXNc49YV
	 GhBxMUrUvh7aeIABcXutqnbfg1UTsicDuZUCRD1X5Fm6R+IBQGxxVKU1xJhlrJMtDA
	 HWUJvljcoDm3A==
Date: Tue, 4 Nov 2025 16:32:42 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kho: warn and exit when unpreserved page wasn't
 preserved
Message-ID: <aQoOinskO4_BzzeQ@kernel.org>
References: <20251103180235.71409-1-pratyush@kernel.org>
 <20251103180235.71409-3-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103180235.71409-3-pratyush@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3E112C0005
X-Stat-Signature: enhhknao1ef463cray45yjhfijojo33x
X-HE-Tag: 1762266770-462305
X-HE-Meta: U2FsdGVkX1/oNohQsip6OhCJfzQiRFhyte5DV80wqVtAl5Vy9Q7Clw/9yjS96PIDJQOOL6MVlBFHhzefvvL3cOCEL1GDyv5FM6BsGvVfZKg8fanz1QroQlhK0QVeYZNIRkW+qlv4BGX3whzuNKI7L6AKFGT4yUi0F/mIIBtcyz0A/ioXREOp+t0FVt8LAxk7tn7pGDte9BxV3qGnJskmvm6dsH4GW69A2GVmeej8Q6JxKIw4fQtBMBTHK0jOvldZu6KHYvTXQApQA8WlH0LMzpCTXwlaTPdO2lwi7fqLJEe10t9IBUz53QZzCM8EO3A9c9dg5sjdZOyzZ8v5ws3exvxbjEiTgk8xzDayzEVRzSj4xkN2vU00R0tbzPQvTLDRNzMpIkS1zNCHxvdJX1WpUlPktDYvO8mbiwTaGSC7sORQayFCezrEev+BIIjcNk7Ie/pHyYcTR53unoHekvoTyXM5wD/0y/C9SjC0fvwbqWSyLrvzA8yS1/TVsG8b5/LYuBsOIaP511guEscmW27asueuBcRF8ZqSJ7QXF3gFjK2L8v8JqWTzT1KtAVLhgYGBRhHFdvu/F2dw0g/KeLIOAvFvOlY0uOFEpZ90IQ6xx53EdLOHbyLBcyJioDjyc3iNMBS/1HWiWiYvQCkngCIcMeqH0vZxiWW0W3y2l4vnpI+AvMfxH3zdg1i+lThHqEch1PZPV+Fr90+7JXtwd5Ga8mRRq9n/QSWO493BBQIhpv5gHJXHs3BWXslbhhmBGsyfT/TWztHaUOr8T8i2VfuWvp3oSKoRq8YD4k78hoAAwBUzVLlz+sCwXG8inI+n7TwSo7x/useXCXKkPPRj3UxkCIe5SMTAeNtyejCYGz3wE1yGm5ydahorkLJ05zTaOpoq4N11hTRL2URtdNDUSldSZScWwCEUF80G2F7yi2Hx+vHHKNWSbdFrJqBeZbjalPh6Zvh2AJOZ0dNotH9ke83
 RexZqjqv
 wWiwv1kMKjbnOgMv5woF6pljfjmzGLa4A08I8PSnfw15VaFtyM37X/gQCt/+LwF+0q8/hW+NxKutWpnkQvZCOxrvI6GJsMht/DNW/a1yHVwCl/TGxWYiFReeG6iQs1WTaDFkKPJeiL5NlXHPy86S+hZN8dE3vZWEx4NcpcoJ7QXxpsXbhoHZp1OPwmTp4O/itcW6mRTa/rMu7rL6q2w0XOiHTiSV5L9kluYi7NstXGL+8BKW5wL33xEMWsplYQ+RN8K5rHkEEKr26aiM+dd+bJPftRg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 07:02:32PM +0100, Pratyush Yadav wrote:
> Calling __kho_unpreserve() on a pair of (pfn, end_pfn) that wasn't
> preserved is a bug. Currently, if that is done, the physxa or bits can
> be NULL. This results in a soft lockup since a NULL physxa or bits
> results in redoing the loop without ever making any progress.
> 
> Return when physxa or bits are not found, but WARN first to loudly
> indicate invalid behaviour.
> 
> Fixes: fc33e4b44b271 ("kexec: enable KHO support for memory preservation")
> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  kernel/kexec_handover.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
> index c2bcbb10918ce..e5fd833726226 100644
> --- a/kernel/kexec_handover.c
> +++ b/kernel/kexec_handover.c
> @@ -167,12 +167,12 @@ static void __kho_unpreserve(struct kho_mem_track *track, unsigned long pfn,
>  		const unsigned long pfn_high = pfn >> order;
>  
>  		physxa = xa_load(&track->orders, order);
> -		if (!physxa)
> -			continue;
> +		if (WARN_ON_ONCE(!physxa))
> +			return;
>  
>  		bits = xa_load(&physxa->phys_bits, pfn_high / PRESERVE_BITS);
> -		if (!bits)
> -			continue;
> +		if (WARN_ON_ONCE(!bits))
> +			return;
>  
>  		clear_bit(pfn_high % PRESERVE_BITS, bits->preserve);
>  
> -- 
> 2.47.3
> 

-- 
Sincerely yours,
Mike.

