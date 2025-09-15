Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1693ACAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 12:13:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FC388E000C; Mon, 15 Sep 2025 08:13:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D27D8E0001; Mon, 15 Sep 2025 08:13:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40F7A8E000C; Mon, 15 Sep 2025 08:13:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B6DD8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:13:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E92A6C063D
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:13:27 +0000 (UTC)
X-FDA: 83891374854.14.9017E20
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 20838C0008
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:13:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DSR2ZDJl;
	spf=pass (imf22.hostedemail.com: domain of "SRS0=PlEG=32=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=PlEG=32=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757938406;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1/Ynn5K83pq/rCejK3Ggq1eP+IahhjysoFQfO5bQyUY=;
	b=wugmxXCE5yaeSxJySe6tlPI3UunRKurHY2nl9nGkElD+RL+WavtYUHfvSnQttTWlwgtJ4A
	TC5w5+KdBunz7IcuSfFHgPMp83x85Euq4XpaoZRdOpUGI2/c1o/Lv6/ScoaF/eDBDt3bZH
	FHTPhSMRJCjcVw/mpj0fP4IZwrNUB08=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DSR2ZDJl;
	spf=pass (imf22.hostedemail.com: domain of "SRS0=PlEG=32=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=PlEG=32=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757938406; a=rsa-sha256;
	cv=none;
	b=iDY5wSynMYK8YaWxqIl2DhfkgR7ydaTIWEXS0SzY+VnMKPysycnUbdBRbeLtCmwFwmhmA9
	dGKFsaZfr8CiOEDxQcQavwIUjTedz77sZ85ZfWhAytZIOoLuVuu8/Bu5V1ZxAxcodCCVkS
	OXkntfLKlVGcNVQUnKWMhCTylbla1HA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AE3D143C98;
	Mon, 15 Sep 2025 12:13:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE01C4CEF1;
	Mon, 15 Sep 2025 12:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757938404;
	bh=N+eJ0gU44hVx/MW9LCq46yXd5OHmuJCxQYNhv441Ql8=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=DSR2ZDJlBr3Wz4wRY+2/aAxWZSLSTpc8cbCBn919mwyiZSGq1+6EYpGqVA0cI+Kil
	 TqjE5KE/mMgstLFFBbXddlGj4l6x0jJHRyg7M1GG3aIJRnoFBIhCV+nlrbeNcU+v5H
	 WJA3Vxp4AgCNsADMhg5o0p3u0JmoXzKaC6NGkjJoj2nx5eBd5Vmc3Y8kRVw9DBEg5+
	 FXC/nHThtqA0WnchXGu1Nh4DWBTgIfu07n1mJBahrb5OVDx499jSGkLvm27bV03WcV
	 TXciRp9D5W24P+w8Ecf/7m3/ImM/yiJbBKA35s/3Xj+Qom7LlmXT4X3NWdfqvQJc5i
	 I5C8tnFC0At2w==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id C3D2ECE1105; Mon, 15 Sep 2025 05:13:23 -0700 (PDT)
Date: Mon, 15 Sep 2025 05:13:23 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Jan Engelhardt <ej@inai.de>
Cc: Sudarsan Mahendran <sudarsanm@google.com>, vbabka@suse.cz,
	Liam.Howlett@oracle.com, cl@gentwo.org, harry.yoo@oracle.com,
	howlett@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	maple-tree@lists.infradead.org, rcu@vger.kernel.org,
	rientjes@google.com, roman.gushchin@linux.dev, surenb@google.com,
	urezki@gmail.com
Subject: Re: Benchmarking [PATCH v5 00/14] SLUB percpu sheaves
Message-ID: <f5792407-d2b9-42b3-bc85-ed14eac945ec@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
 <20250913000935.1021068-1-sudarsanm@google.com>
 <qs3967pq-4nq7-67pq-2025-r7259o0s52p4@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <qs3967pq-4nq7-67pq-2025-r7259o0s52p4@vanv.qr>
X-Rspamd-Queue-Id: 20838C0008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: t557dtfzq3oi4ib5y4eropfyypmcwg74
X-HE-Tag: 1757938405-393292
X-HE-Meta: U2FsdGVkX19O/QwF1+pxFbtiLZxX3uASkmYbI1MF6CW0R7IujZen2q4xpHpJrWVv5Y/qFIRt/6faZeEknSSNJUrunZQcnqGhPpryF18q34KtXjsOqYHj8L2MdplQS3ChHhq0qwJfpTYwgCusg1Ph/as9vv8SdaViXNE5xKHx4th0JwKZeqQGTjZkfC1io7A0jIyn+gXC1zc/t1e24beEmgamWOtO6juORTMZaX3OGkBo/4/MzU+Bng86bnHm95MSrg2BCCUs+dgt6MkLKv5KnQgltkkYGG/TIGPylLXO/wjEP7xtzSW4ajS+lQ6sfCi/cL6OrgkqlGurLcuA+RRFISths+8DSqxf3d65DQG0biK+iT1Ych6jj7FXzs9bh2O1GOoVqsVIhArGBm3Yi++xyewT9iTdEFZEoJPTcuVAHrzhkl09rjO0VsUUYkR+vk0ITdvlFUcoUD8WGincXiq+4DoOzaZP2OhwkqThBAU/nDZPJu0K0uUPR42F8o3FhvePS/EWVKTb2wlP/WQVp3XTn3l3YuxUG+e3PmMt9e6CLnL2YKYqkbN/qSvHcihARfciUw983yOOM3V3hkNlGAAEhTYJc5MOALO8FpHTrE+Z2hravSpHsid3Fwupa0sceaohv77X87glUYcFegtNCPEeOqtLoKJYSd7V/rTDDBwfF6luVeh6CmiO9pfYmrfDSuEBc5VtliVea2EHSRhP8bgg76ykljPID6/kSwQwppl/QE/be4ziyu6NWW8k9IOm88+5GuVjmtmBHdZgE1KQPWT8EC+M/yoAO5IVhhV+kyBMBHadY5bYNq1dUkSiD/PIeqF1yKvm655goiUZIrM3mRAA4D7EnUIwfK9XCoAGxZ32sglLXcq0/WN5k0fKiHwtifzqbCoHMSsyz8LvabgcJ5pTf1oBFB67sAn99R/sc2dfDJrInfNZmRKG2pnfWi3fpC2F3nYT68wEDKc7w8SuKX4
 uSEFQllo
 xTlC4nkGyNoi3Ags7ifyrXqZSKrBi+tzYCXF1gZxRS2X9nJ8ov0YjKjGcAzPsDTLA+dZ4lAKcc5KmXFdD4h0QzFvl/LIHrCjQLhtZ+j6LgxI6IhwCRlNTX3IWuDq+ranFlqepDqs5v9EAzDRpJp88GQw9rkknCndHbtuFWkWg1aKPhkHNbeTC6BHMBCy7fO+AVE6lFJiIPtLiai/WO2lZub2WHPMdJyAQ08IhNQIQjCiAmgb7oLN++XmDnk2tKfEZoXhmxzEL+x5rhGVwGu5FOWB7SwR/ju/DtD8U9rGBneIOdHpuYKfWGKLCJh+uUe22M3OiOZoHNkOgVepjfLGOh1nnLIZu/lnIH3C4Z0U7uqQyLgpwvrNBpmL3V6at9Be8wmVXyJHdwm2ej76uSB2Os/xSnRK7Rf+Bb5W1aeLd6ux1DjKaqCaoCGyYe8W8UoPqXJjHXEu5+Q2harwVT7/ff3yYBAXiYmlrQ9LhqnkXuOCzvLwM6wPtk5x7KOT/7QPa+Gms4+sdEHbyzAxzoNUTv6+84TNf7n8XmLxlNliRI4jJ4gvymykpQnOgtK26gElAjt9PCnT5fHaPCHJs/R4q34FUMSjpJAGlTxLfXKCLRclViLLpCKwrMygV1yn39QO9BBBpt4std/8TUIjyR2BVhSTB2w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 09:51:25AM +0200, Jan Engelhardt wrote:
> 
> On Saturday 2025-09-13 02:09, Sudarsan Mahendran wrote:
> >
> >Summary of the results:
> >
> >- Significant change (meaning >10% difference
> >  between base and experiment) on will-it-scale
> >  tests in AMD.
> >
> >Summary of AMD will-it-scale test changes:
> >
> >Number of runs : 15
> >Direction      : + is good
> 
> If STDDEV grows more than mean, there is more jitter,
> which is not "good".

This is true.  On the other hand, the mean grew way more in absolute
terms than did STDDEV.  So might this be a reasonable tradeoff?

Of course, if adjustments can be made to keep the increase in mean while
keeping STDDEV low, that would of course be even better.

							Thanx, Paul

> >|            | MIN        | MAX        | MEAN       | MEDIAN     | STDDEV     |
> >|:-----------|:-----------|:-----------|:-----------|:-----------|:-----------|
> >| brk1_8_processes
> >| BASE       | 7,667,220  | 7,705,767  | 7,682,782  | 7,676,211  | 12,733     |
> >| TEST       | 9,477,395  | 10,053,058 | 9,878,753  | 9,959,360  | 182,014    |
> >| %          | +23.61%    | +30.46%    | +28.58%    | +29.74%    | +1,329.46% |
> >
> >| mmap2_256_processes
> >| BASE       | 7,483,929  | 7,532,461  | 7,491,876  | 7,489,398  | 11,134     |
> >| TEST       | 11,580,023 | 16,508,551 | 15,337,145 | 15,943,608 | 1,489,489  |
> >| %          | +54.73%    | +119.17%   | +104.72%   | +112.88%   | +13,276.75%|
> 

