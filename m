Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 307B1C982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 12:38:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 482986B0088; Sun, 20 Sep 2026 08:37:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 459C56B0093; Sun, 20 Sep 2026 08:37:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36F7B6B0095; Sun, 20 Sep 2026 08:37:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1EA9F6B0088
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 08:37:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A1CABA5DC2
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:37:58 +0000 (UTC)
X-FDA: 85234092636.05.E682448
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2686D1C0002
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:37:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tfu41fTW;
	spf=pass (imf21.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789907877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=8TXSOAoauEDqUAiNkN8UacM8jNoYS5sAyxYgzMe9pLY=;
	b=2co8shEuzi69uzukS8oHHZJRjD4JhJh8j7RMBnnVCLyXS88jQtJwlcP3C/RfIAWhUuWhwg
	j1dhLcwC+N5Vz36HEOcuFpF38ndGTlUvJFxnR9u2YHZiKILEAWSVOpCKkJY7m8C3Ks66f1
	YDp1kv6UiYQlYaPbITt4+XklYS0Wk4o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tfu41fTW;
	spf=pass (imf21.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789907877;
	b=Qs/3id7JpjzLOGWmaPb7AEw3a7VatjpxkJChf1WUcP780+EdE8hQ7nwVXkzZvmTmyzcHVw
	Waa8x/sFeP4xrkZeYjIbbTIFqVmTRYfT2zkCwa/OQeKJQAjNJq7GOZzu6y1HJ6dnHXjxOF
	VV/Ulti5Gv10kTngtsa6OF/YLEpo6KU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 110FF43D13;
	Sun, 20 Sep 2026 12:37:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE64E1F000FF;
	Sun, 20 Sep 2026 12:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789907875;
	bh=8TXSOAoauEDqUAiNkN8UacM8jNoYS5sAyxYgzMe9pLY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Tfu41fTWM3gSmOu+hwWOtrDgVn/zpXFuQKqN4APJo9TJ6fTyPNi3LOPbntxjrJJSG
	 1bsh/nbFLU6vZMTNc5t0vf12EPKFsVn5AslSlAFmaH+xhFke54Wy5ooF6qf2xK3VPT
	 sFcKlcldYLJRlSTOvWtI35zrL3DZ/xECZ9uZYb51Ot2YNcZuQiM5aJZF7UEDj5ivHg
	 bSPgO0lbP0rQUuma110bhuBfcla6JnB4ssj1aETv/y3Y+hZij8loVdqYPyHFLyhrXE
	 dfxa2riyC4X6MD9eEti4MVRAo9+/pzs4G6i/gwsPLKnfUO45sbrXfg59ay4plIvA5x
	 L+umh4UtxqPrg==
Date: Sun, 20 Sep 2026 02:37:54 -1000
Message-ID: <b40622ed67f77f3ff88d5772e7ea8476@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	axboe@kernel.dk,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	willy@infradead.org,
	jack@suse.cz,
	tj@kernel.org,
	akpm@linux-foundation.org
Subject: Re: [PATCH v6 1/3] block: introduce bdev_flush_by_dev()
In-Reply-To: <20260917065759.2643940-2-sunjunchao@bytedance.com>
References: <20260917065759.2643940-1-sunjunchao@bytedance.com>
	<20260917065759.2643940-2-sunjunchao@bytedance.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2686D1C0002
X-Stat-Signature: 1qtdpctnbfmy1u8spnzzs3eu4qcgkuaa
X-Rspam-User: 
X-HE-Tag: 1789907876-524930
X-HE-Meta: U2FsdGVkX18niANHL+h1mfXsHzwzcOLRclY1dTgvtVubJKr0luBWD+ZZdIPyNzta20V+OQerHVcDGsNh3k1lOm98PW5QAr+KsLpohilOOsyZf3OEGVM0Y44uV4y6RbUILZid9SG2i96Spu4VQBGgng0PyvZM93UjH89uvfiSc2TEyxz/OgafXYeMtrBAiA41Si4HKdGyLgcUn1mn+mOryxvtyAU//R7pPW/8UOwmo+q3Uu2UENrKcw32gOC8x8YbHPeJGdZCBPX2VdyTwgYl6uuju3q5IkPJCjMKrziftbTemP2f3sfaFG0fpfHrt+0p17EFASq3UXCq58WASbW97pEZIQiSJhcOMH6xENXDDmZBv366mIo3673IOFZ/EINo42mT8ULhYEde9anJObk88qnDsS92CUG//OLQzyoykBf+pZ8qcSoBLTp602bAnncDr1rqJ0Ke2iDx2z9y1ES8OJV82KBL75hxX+uV0BfX+qsv0c8Xsa166vkhoP2mQ+YwgBPbQWIeE/WBOojiMCPdvPkjzXHnLdvWoMuHfUlRp8vu4JR7i5lBKyxUXvM8eWxfC+iGv0Nz/P46WdUJ71fhMtjwZXdzs+Bu/mbI5TDVNGBq1nIhBqzCgD///MoZaVFt28/2VtHAngsvxmut2G4azMUjnx3wq+tdW8ffGhTUcoTcT+S3rNBWKzPGFI4OxVgwDEf1z87B3B/QzWz7Kic6uZrmlxYH1zQUVDUH4DTWzkzST8ijDjkh8toomfJ1WwXQ/7VAt3KnT3uO1lxYqo+gwMjicV5UaaPK8YUxXBzTT297CUGKTVOOuFVVbqlvd4TSnBW2JUKtHaMIAQeIGtWW22aar26jOol8lq38xVpkfbJdqLdP8e7Uq1JkHEhi1lKfe+fjBmcnQXVfuMA5jp9f3TCG4LTEDgMaDVysfYsAXRg70S+5biwabt1XQbvCJW429j4+WQLyQ2bjPg9IP51
 oLrzp6xB
 rAFitGzz4L4BuiKIX/rLdqKx+lTZIVz10xUaFcRguobCPUATNR9Mi4kLXam2VpNgn+3t0sRIXLdJLxkNhNqSpm+QJfLYM7GZmfD1ivkzepW5Lavw9aFRSV9/dy8ZYxHQu0o51ZiCiCIdROo556Du3cvzZYbbg5poyFeL7cBwMn202D5YTQB5W6Jsp1RrSPg2N6VL8cz4Bo3jpVS29DGdgsHb7Jew7ZKJmUQMk04whL36aurHN6APYVTE1W3EyhAL+/9jipMOtRbb55Aw77xmYKtCUdnYZ12EmBiJ+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Julian.

On Thu, Sep 17, 2026 at 02:57:57PM +0800, Julian Sun wrote:
> +void bdev_flush_by_dev(dev_t dev)
> +{
> +	struct block_device *bdev;
> +
> +	bdev = blkdev_get_no_open(dev, false);
> +	if (!bdev)
> +		return;
> +
> +	/* Prevent the device from closing between the check and writeback. */
> +	if (mutex_trylock(&bdev->bd_disk->open_mutex)) {
> +		if (atomic_read(&bdev->bd_openers))
> +			sync_blockdev_nowait(bdev);
> +		mutex_unlock(&bdev->bd_disk->open_mutex);
> +	}
> +	blkdev_put_no_open(bdev);
> +}

This holds the disk's open_mutex across the whole writepages pass, so every
throttle-triggered flush blocks opens, closes and partition rescans on the
disk for as long as submission takes, which can be a while on a congested
device. bdev_release() syncs before taking the mutex for the same reason.

I don't think the mutex or the openers check is needed. If the device is
closed underneath, the last close syncs and truncates the mapping and
truncate waits for writeback, so a racing no-wait flush either finishes
first or finds nothing left. Holding just the reference from
blkdev_get_no_open() should be enough.

> +void bdev_flush_by_dev(dev_t dev);

The neighbors have !CONFIG_BLOCK stubs. The only caller is under
CGROUP_WRITEBACK so it builds either way, just noting for consistency.

Thanks.

--
tejun

