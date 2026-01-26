Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACA81C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 06:36:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C70556B0088; Mon, 26 Jan 2026 01:36:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1E996B0089; Mon, 26 Jan 2026 01:36:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B47716B008A; Mon, 26 Jan 2026 01:36:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A38B66B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 01:36:26 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 54F8DBA93D
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 06:36:26 +0000 (UTC)
X-FDA: 84373155972.21.D823AF9
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7C9762000C
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 06:36:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B3DI4qlQ;
	spf=pass (imf13.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769409384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pma8RaoRhbP3xu701FMXEsOkee35ycUd5xowwnvWuMw=;
	b=THzmIghRgTt/V1o2D3Cs1L4kLCfTYxDvG/A8cdZkLC/csRah1vqRVFENB8lKDhhHFUftRO
	4UT7Porl1WlsfGLHjtCp3dDLtvVRCLkpVUqgEd90SY9tz35/w/71HjkgqGAjeBhkgh1G8q
	6zgp7oOk7NUqIhHHN2T6ctm5ImjxFr8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B3DI4qlQ;
	spf=pass (imf13.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769409384; a=rsa-sha256;
	cv=none;
	b=7psKmZDnx7UhqHsiDkAjx75444ntY0cO3X6kTF/NkkEL3P94ESegJxydodCoq/Sqitb89E
	aCHVuFNF8CzxfUs+jE8GN8EiCfsHRM5NSl249OW/CQhEayi51oGHC4KSpjgbku6eeIMCDe
	ntkO24dKqFZRf+iQPst9V1GwxuJDAKs=
Date: Mon, 26 Jan 2026 14:36:02 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769409382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Pma8RaoRhbP3xu701FMXEsOkee35ycUd5xowwnvWuMw=;
	b=B3DI4qlQnKai6ga7yb/idP0heE4lJ+3GD5sAaZd0I+cbvvalOW3DtYt24T8iijU84Rs/5j
	einKdb1SAWqpZrRCgbe8Efk05xJDUf+HAGnRpxvB4svbwL14OY0+CxWabKrSdG5KnfEGTx
	+5IqYTbZ4Iu5YtSxnJ6MorKla2Kqhzs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v4 06/22] slab: add sheaves to most caches
Message-ID: <7tds765fsicczreeqckiuwpny2tolotfrnbz6jhpjrch6x5pg3@5irfwnohvsli>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <20260123-sheaves-for-all-v4-6-041323d506f7@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123-sheaves-for-all-v4-6-041323d506f7@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7C9762000C
X-Stat-Signature: yzpy8nhbo48q3a9dt8p1n3hddfzsh4ix
X-Rspam-User: 
X-HE-Tag: 1769409384-339767
X-HE-Meta: U2FsdGVkX19uTb/oA/GBPPPFyjHj6qSI9/sxu5HuNlRUoZQA+JcS70IxpbzLWJ4DiPjZsXaTU+WOldTLTKAw/oGFEpsJA36/nCHvGjL7jmb+BFkoQSTy9nn1T6eElxNGaeanVoa6VAhk0cICyjRtyMG82psmNGFPzj2qQdVCnAbu0FeDMiF+6LktVGjU+SnT7QYlXrKGq/A7Q04+St32x27dIZkhhlpQPjoEdBj8D0O/vsPW16+pHyIGIwxcHqnz4EwfuG4VOtePs78AtViozqvlxlkfh+Ck8TW+oboLrR+9CY2zTK8LPNDfTTRJ7CM/kORqp5Qr7WxH48ghdMK+Ytk5WfMUIGy8q4Qn3nmifvLB0VHcPM+UhoJplCT/V2y19YhZOtKta/CPyPGBaIH/7MLUGIxo9Z0dDSowA7Hv8HYYh5ZnGbC87Mytex5uqhZ6nhFdPUiJLAuco0+4AhcD46TgzU7ob0dKKNT12XaHXk6tUDEFJETVb91nbJFS6UjX7C2n+RhE+nZSERRRO8tGB/UoxfRLm50SAwUPyq4FUV1upXexDYyobPr75Ke15ViztePW05GaSCTdWbGx/KTgGPnb5m7cNNfPT9ziFljCk7jTmZQcBYVzMNskubJ8jQTSRBLw+UFFwrKqqdXhlx6dKWY997IJSbO3vViIwP8udWTdSGtiYfZrPnQI++b8A2eIxw3WbsF9m3AcpIlL0Lxvwkc8N2rHg3CaczZnefl7H00m2H7hfdntj/MPaJRZjthhl/atXtPMUrZQZnep55REEQBhSsuEyoqlKQ5HohOIv9hkBF0w0dIBkdgfH8RMqWbFKzG4XYk+C1G+kV4xjdizJeiyuFCpI5p2gNsm/ZdwgpCd6nWLSEBlsvaxx2qdEri8N5TXgxQS/IxT31o8AO9TM/+g6QoZoOHI8rThMvlSksigBvQx9y1yDfBKERpkgYFFVEbG9gFAQtfV+QjuPCx
 rcCrtimv
 Aw8l3w1jb/wzwLYnwqdXYRfAGmRFAk0wKS3QUSKZDWcmA8JxQf+ulYKGrES4XIzi67iEUH94dX+dllNNTL3F7Q9yd+AICq4iW6ugPHrX3Lv+x2QMzkkbQGL8VoilCltenAaDesoUA0A5vMHxHOHTIaUF1zUxhZtnQ9HI779k00G/SChIfRzzdDJV3BIxlmKf4yeBXrsUUfEaYunuYFQa0WayMZvbNxbKO9lHteGzhVTRBkrjJhJUQoJTz3NXWK28SPzCAaNxevF1Jy1o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 07:52:44AM +0100, Vlastimil Babka wrote:
> In the first step to replace cpu (partial) slabs with sheaves, enable
> sheaves for almost all caches. Treat args->sheaf_capacity as a minimum,
> and calculate sheaf capacity with a formula that roughly follows the
> formula for number of objects in cpu partial slabs in set_cpu_partial().
> 
> This should achieve roughly similar contention on the barn spin lock as
> there's currently for node list_lock without sheaves, to make
> benchmarking results comparable. It can be further tuned later.
> 
> Don't enable sheaves for bootstrap caches as that wouldn't work. In
> order to recognize them by SLAB_NO_OBJ_EXT, make sure the flag exists
> even for !CONFIG_SLAB_OBJ_EXT.
> 
> This limitation will be lifted for kmalloc caches after the necessary
> bootstrapping changes.
> 
> Also do not enable sheaves for SLAB_NOLEAKTRACE caches to avoid
> recursion with kmemleak tracking (thanks to Breno Leitao).
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Also, looks good to me.

As a side node, while looking into the test results reported by Zhao Liu [1], I
ran a quick test of the current patchset with the will-it-scale mmap2 workload.
In my runs, tuning capacity up or down did indeed have a noticeable impact on
performance. Hopefully we can make this tuning even smarter in follow-up work.

[1] https://lore.kernel.org/linux-mm/aWi9nAbIkTfYFoMM@intel.com/

Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

