Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2314A109024D
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 16:35:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CFB96B053A; Thu, 19 Mar 2026 12:35:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 880196B0554; Thu, 19 Mar 2026 12:35:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 795AC6B0555; Thu, 19 Mar 2026 12:35:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 652F56B053A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:35:07 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 20C0D1A02D0
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:35:07 +0000 (UTC)
X-FDA: 84563362254.19.5D81AB2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6CF964000F
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:35:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GfS0Rd0n;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773938105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5CVrh99s9FwtEZcZ1RcSN1yvlImv7/343DDOAj4G9S4=;
	b=pdNP66HGKmMwQ6BHQfRYxLqvbNGuGi+Lu1DgVJevEwRSasvazgEenI1vxKfjyy4i5zWSHL
	1FlcOCcJi4YLPsxutdNg64eHuk4NnFQ6+MN+N1WIhT3U5dfvXsTNZoXLak0V45w4+IrArj
	k5Q9bESWOat+kEFZgCNruoTg9QjI84E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773938105; a=rsa-sha256;
	cv=none;
	b=nxZXFT/jAfeBHYyVVkOCPgm7PZu1eWaIv3PZccHUiiBfsJmJtASqK7tQcjzeF4GoAgtMu5
	CyuJm/H39TInR7CIZwjgxxDGD5hUKSpPfBq7mJudarG1CgfYsBLlRQw9x/JVFqwNWbuDY9
	9BqceQIkyKwHI4AEFHFZc8sHJBllkTQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GfS0Rd0n;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CD8DE60097;
	Thu, 19 Mar 2026 16:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C5E6C19424;
	Thu, 19 Mar 2026 16:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773938104;
	bh=gY6VMd+3RUM8XufPoMrgfnG5Ab4Wsx/0i1ZcgPhZzsE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GfS0Rd0n2wCBdublXIfYfreIcoZEP/sUdrvPbrb46baZ0K3kSc3pP7HNKBgs0/fHm
	 P7iZaQ8GMUyit38E9XYqTzeb0g7G2QQg5uvZIPuPFKs5hiK/0MGnjqYcqbYPTkpetv
	 7A21IrZhCbICFxrFfHU7mpapMcIU92DMDQl6nTh42mEscy3c/JjBsiDpc3ch3cNlZ3
	 rowHtKlBmp0MaUkSEMyh4W0Ckz072e6oMbe1/AAQaEkj2OQvYN5gvWmdHbdSvWiTKp
	 ivSG7IJmO6s4bjswIrdne8v5sdkDuNlT1z2jrGAfhgMWoH1mqzVftJ+NMccGk0aGTl
	 /yHJvccVHYlgA==
Date: Thu, 19 Mar 2026 18:34:57 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-dev@igalia.com,
	kernel@gpiccoli.net, Andrew Morton <akpm@linux-foundation.org>,
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH v3 2/2] mm/memblock: Add reserve_mem debugfs info
Message-ID: <abwlsdgNWtDeasLT@kernel.org>
References: <20260318190816.1811325-1-gpiccoli@igalia.com>
 <20260318190816.1811325-3-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318190816.1811325-3-gpiccoli@igalia.com>
X-Stat-Signature: ikcbxd8jg4xesm6mpba59c8y5sm4pd6b
X-Rspam-User: 
X-Rspamd-Queue-Id: 6CF964000F
X-Rspamd-Server: rspam12
X-HE-Tag: 1773938105-327156
X-HE-Meta: U2FsdGVkX1/HKx8Ldcyq+baZS3A4gI9Yeg4ZSqmLixVBywovjG1ShkIptzaIt2QUoV3GPTNJPp1fSfHih2Q9r4UT5ANRq4yTN43Fzy5vO7a3y74lVCSb6bZFii3H/RSkcczN2fOazVQj1kj03fuoENAHGlKlAkt5xj+nMJqpSsaArqIeGuCAdnPw6CHkoxjzTLw05UU5mmPH8bg55hPLiAZ34rzM75WzTZ8Xp4ECCtNH63Hqz+RgedXZfMHT10kuWnOU0LMYEOgr9RqaJRQtQi4nFT+/fI/gi0/xSws+bKnARcPWCJ5MhkUOnqtvCxGbo1x+XlOFc/b5OZDgcm8H2bxosCIm2/E7w1xRHouNCRMYJYL0AwRPfmgqy/KqYeX9np4nVq4bec7aewzXVRYyzzlqBs9KfmAOCpEKAYUuG4ob2L8Vet/6XRfOnAwvg6Iy4LtfINaq2GemYjYLbvFCi4FL5YqlDpa1TIBKzqX2S45u/tGHxu6AqGgMciwUZRfFnnSY+jholUj1+pw3SxiBfsbfifA63caNaKlEw6SxzB9VIP5FSIuN88Jw7jyETGGaphtOJqXIqp8Rq0GK8R5OiUzWr6+bgrByFlWJwGrLWtUDdlvP7PiI53T8FbYuW1D/N2hOqN49ff59AAVuiG5Sx4aMZrDyqiym6Seydxoggw+CFczlAZafQW9rm+DRdybzIxH3UmzlG9wyyw3lC6nv8dmv+bSg9mfSdT3ZQGOSE3yQmS2EUsxJYPZF7LcY+hfNd836F+wOpSfiBOu1ZNa2pu0cOAC+VOTmZcJ/fSxrFCTZ51EQBwUENvUT9C73QI+h02Kz7ksOQhQG0QZxxbVeNsSjKx5wbxRsdHue1nRoFHzTrrlOENDwO2105Zo5/i3dMXI3T+ByCZKLwtgzhkjQjOFJEGfwJtX+J0aWjk9Pfneb8ibBDvzTP/Q9Og4OFzQ6/B/bfEZIVFomZQe9lLs
 uDUosW8k
 f9SYVJ6vRh8x4rY7LVdTVtbkzBwzGlkZ1GaSI/t5msuq2+SyTF3hcYkAlRmG7yDcPP6bGmWJNK/iXOiqUkj46gSb76Vj34rGOlH8cW0TV6uDkGkfxDb6rSKFFvfTp4hU/IZ2zivUXDGAjd5c/1IgECOZRQRrfWomsnbdRwbsk6QJnPpzFlaVYCDd+a7yW3DHzBkEIOmSBDQ+zvj3x2eJqhvllrPWYqDKN+mUtllYwE87fiB52Rqrfqf+rqoLaDffLf4Y0Gk+s7fiofF3OO8NPTyOJrmLNjuSe8FYaemIhbg8u6Z4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 03:56:33PM -0300, Guilherme G. Piccoli wrote:
> When using the "reserve_mem" parameter, users aim at having an
> area that (hopefully) persists across boots, so pstore infrastructure
> (like ramoops module) can make use of that to save oops/ftrace logs,
> for example.
> 
> There is no easy way to determine if this kernel parameter is properly
> set though; the kernel doesn't show information about this memory in
> memblock debugfs, neither in /proc/iomem nor dmesg. This is a relevant
> information for tools like kdumpst[0], to determine if it's reliable
> to use the reserved area as ramoops persistent storage; checking only
> /proc/cmdline is not sufficient as it doesn't tell if the reservation
> effectively succeeded or not.
> 
> Add here a new file under memblock debugfs showing properly set memory
> reservations, with name and size as passed to "reserve_mem". Notice that
> if no "reserve_mem=" is passed on command-line or if the reservation
> attempts fail, the file is not created.

...

> -static int __init memblock_init_debugfs(void)
> +static inline void memblock_debugfs_make_dirs(struct dentry *root)

This does not make dirs but rather exposes files representing memblock
arrays.

How about calling this function 
memblock_debugfs_expose_arrays()?

>  {
> -	struct dentry *root = debugfs_create_dir("memblock", NULL);
> -
> -	debugfs_create_file("memory", 0444, root,
> -			    &memblock.memory, &memblock_debug_fops);
> -	debugfs_create_file("reserved", 0444, root,
> -			    &memblock.reserved, &memblock_debug_fops);
>  #ifdef CONFIG_HAVE_MEMBLOCK_PHYS_MAP
>  	debugfs_create_file("physmem", 0444, root, &physmem,
>  			    &memblock_debug_fops);
>  #endif
> +	debugfs_create_file("memory", 0444, root,
> +			    &memblock.memory, &memblock_debug_fops);
> +	debugfs_create_file("reserved", 0444, root,
> +			    &memblock.reserved, &memblock_debug_fops);

No need to move these after PHYS_MAP attribute

> +}

-- 
Sincerely yours,
Mike.

