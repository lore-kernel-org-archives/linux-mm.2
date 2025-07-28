Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10ACAC83F26
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 22:16:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C70B6B0088; Mon, 28 Jul 2025 18:16:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 877E06B0089; Mon, 28 Jul 2025 18:16:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78D9B6B008A; Mon, 28 Jul 2025 18:16:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 662AA6B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 18:16:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 00D5B80417
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 22:16:08 +0000 (UTC)
X-FDA: 83715082458.14.7C75B40
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1C7B1100005
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 22:16:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="ZfSKm3/E";
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753740967; a=rsa-sha256;
	cv=none;
	b=OlzG1hk1LOlZ1IlzuswyAGUXBHj/INNHq+THkB/Mvvy4LnZTDPq7Wh6CVugUxSLp/dTUaw
	m4OvWqkuFoXZpnXUfmdCp7q1Vm/AXP4FFSW/1oT7I5/2nBvzlcyVXjofiakcH8UsGGnEGS
	RFZ6ViFLUDiCUABfvsUvkgULdId31Lw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="ZfSKm3/E";
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753740967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bz8PEtKYk0ohQAKeqED4BbjFMZ9LOR7giB2xHH2Ec6c=;
	b=5xQ6y3PT2T8xIOmmdcWl/wE46cYi4Mm1kM5Qc/XqZJRs6Ghlb6+7IZw4w5/LPuu8J6UElj
	fdyJb3muILOQHzEa35EbnI7dweVrCtPu462aW7iLmXx4u9ORAh7eltmGBILr8to5FXPuk+
	3uF53SQ7SuFVvLuu9cgulP+bhzZblRY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C37A942BA4;
	Mon, 28 Jul 2025 22:16:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D4DC4CEE7;
	Mon, 28 Jul 2025 22:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753740965;
	bh=TzVWYT76rZE3j083ttedwRt/20yfxuDoW0mHV1B5gDs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZfSKm3/E6RiE/tCV6VIRZLG2thsq7KkBEVsP0etcc1LaZDPn8g9dwuta9RB+/3K3f
	 zk2BxycXTmSMfN160LDV3jpuZtb3shabZBxoAzOn7CHD25y8iWsbD2/9zDyaTQNUcr
	 RQvJuG3x3sqbV5xPJhWh9EHfUZw1Zww9rGuVrDzA=
Date: Mon, 28 Jul 2025 15:16:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Patryk Kowalczyk <patryk@kowalczyk.ws>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, hughd@google.com,
 ville.syrjala@linux.intel.com, david@redhat.com, willy@infradead.org,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, tzimmermann@suse.de,
 airlied@gmail.com, simona@ffwll.ch, jani.nikula@linux.intel.com,
 joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
 tursulin@ursulin.net, christian.koenig@amd.com, ray.huang@amd.com,
 matthew.auld@intel.com, matthew.brost@intel.com,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH] mm: shmem: fix the shmem large folio allocation for the
 i915 driver
Message-Id: <20250728151604.e834daa64e8c816aeffba975@linux-foundation.org>
In-Reply-To: <CAJCW39+AS5poKu3A4Y88pH2y6CWbE0WnGZfe3kL99W3sJZjreA@mail.gmail.com>
References: <0d734549d5ed073c80b11601da3abdd5223e1889.1753689802.git.baolin.wang@linux.alibaba.com>
	<20250728144424.208d58d5a95057ee7081ccd8@linux-foundation.org>
	<CAJCW39+AS5poKu3A4Y88pH2y6CWbE0WnGZfe3kL99W3sJZjreA@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1C7B1100005
X-Stat-Signature: dhcpadqk6x4set6x5pmruxbrgb9tjzf9
X-HE-Tag: 1753740966-899031
X-HE-Meta: U2FsdGVkX199fQ4jsr+tZXm9HePtNhMJ/6CBJ9Q5M2m3zUF4AwMC79QhOy9tQyvJciVsHW3khoVzuyODw4RuDYZAfz9c47PATYhp0L6jIjNSTxsZW0CCcEzRC19xmKvC/G47V6+fTzVU1ITVoWI9orEAWZPyFVL4b6Lrw9ZWnClhvy6GrORNihrWgV8Tb+niEBSCFXwy3LRXsuPGmZrl3IoWjvinCNl2VgpMxwz0GzBMx6p5/ANrrCmUedALE/XLPRZZb3N91p8tDYMeiSKn4JL5sWPGKc6gY+SqCIf2c8UI0ps2+jzTHYbnkiU2/1YFmOOBbeyBVeYdxHy/J+zv93l62mjrftY2S3/+IO1aB65n8OYx+kfVOt0e0vKw8PGEDBMLBFPzlpDxIka1KpL+OeiN5FXw/GSmvF9M4iu09HavGr4p/fkjVXHNlOmXdHuLjorj8JPWwHZC03rP5Va5d3Zxrwi2YnJIIIfNmrnXoHW7MWsl30cv/t02MHdhPPl2/OxOmpfLxDPrVKbiYW7cRegvoIatWTqO8lyiGmBBikdeameDUe/avQXlpvlPGGVCSM2CQRqPy9I2C3DIozh4TVXnZCLF7xCMmLpPe46IOUTHdIZ6+fEiqS3dxEQuCsqawvkurV0zYjlSl5a7WKXTg3ZYBa6xmnWo9ONduZSxgWhN6fZcJQuXhphjO63Mc2iTGBb7cP/u+kB8OwnQ0xtYbBUTDlmH6D7iLT+f9mzdUcWkxZNTvi0oahgZ/UmNDfT2p2R1dLB4rge36G17pujl2h/Cbi+vRfo86tK+kZkVZEeZe58XoIYy7DipOmSebah1aJaCTYWrrlZGVoYh+5j8HGeBL5qEf+Tv1a7c+n39JUB3rqOJtnqHabS9VtJ8rts8G3Pp/nWfhO9Z94hYZRZ1X96wIe8cllqaYDb84rLAoVrybSejcfOAzskMTvCycdSZDj3wDnUPUKsGNkYH9Fv
 bQFwIMDG
 7BNHBsh4T1OrOEI4XGN5EgYAfhCB5BWlTxMjzC8s1064DY+IxX6+5ziEKNErTMWeiFocyvRdXgK4Mbjd1sPh1qTe+xT5meI7x55kjTdaJ5E9R3l1H5YBv/vKjHmSgGGUHstw/E4folD/j25CJsdRsw/EdvRc1Y+v8ee4r0Q1XUg1o0GVVN40aNemS19/lco+TX7F7nyCYnsKLvHkJ5c6id526sUtN6G50eAAFqnyIVb7tYr2zmx1GBImMGga7syBnW7n0nbuHufGHB6vS08DteP/dhbXL/eIWvwZmvqMzyexnpNAyD+nmnsHFoPuBM6YRk0NUOURiUXQ4wm1gbCszHhmrAft1LxKagb2QFvjjzsT+KrKbJojUTjwJjA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 28 Jul 2025 23:59:22 +0200 Patryk Kowalczyk <patryk@kowalczyk.ws> wrote:

> In my tests, the performance drop ranges from a few percent up to 13% in
> Unigine Superposition
> under heavy memory usage on the CPU Core Ultra 155H with the Xe 128 EU GPU.
> Other users have reported performance impact up to 30% on certain workloads.
> Please find more  in the regressions reports:
> https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/14645
> https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/13845
> 
> I believe the change should be backported to all active kernel branches
> after version 6.12.

OK, thanks.  I added this (important!) info to the changelog and I
added a cc:stable, requesting a backport into everything which has
acd7ccb284b8.

I'll place this in mm.git's mm-hotfixes-unstable branch with a plan to
upstream it sometime during the 6.17-rcX cycle.


