Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33922CAC5BB
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 19:59:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C85B8E000D; Fri, 26 Sep 2025 15:59:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 878E48E0001; Fri, 26 Sep 2025 15:59:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B5438E000D; Fri, 26 Sep 2025 15:59:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6E6908E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:59:57 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2B1115B33A
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 19:59:57 +0000 (UTC)
X-FDA: 83932467234.20.E51683B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7FCE62000C
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 19:59:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G2ll9FLT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758916795; a=rsa-sha256;
	cv=none;
	b=2HOjlyHD0KMLQRozkhvUAAwois8UVvJ3pFs/P9f7JfHfpjhzevMcdPKhZgluZzhUPWacyf
	oCc+j/YbWSlVE2AJtsOqaY6dGJgR0G2qIIufdy9LZnl4kIDYBBIgznDPy1mS/l7eu7WrXh
	wXgqTfhtQj5P3Y8XZ4tQnSAgmICsEv0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G2ll9FLT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758916795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6XVE6gI3s4h2oqN+5H0JXhrI5CVcopWxOnIrfKbY8Q8=;
	b=LZdyP2KZvSUT4tvby4yBEj68YtsoHjaadvP+OwrFWRxl3DJ/P3U3A9g/uzXbwsSBgrncUr
	2ZMJ8t+gzC7oOEjTeS8JDgYuL03SAAIghQ1ziTWdSO0DfCt2Qqv9+Q+Homctixv8AaS/VF
	rOaknjitHdBMChHUMrKkRvHOMVxzSKY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5C64840AE6;
	Fri, 26 Sep 2025 19:59:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE47C4CEF7;
	Fri, 26 Sep 2025 19:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758916794;
	bh=G7QcvnfTWYRxp/GmM+pso0f4vUGZFkPkild8qrlkqqk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G2ll9FLTLWRE92u88UmONdWrCOlNV+McWooNhWW7eQtfGIXiGeFKrFHrQQchxfF+a
	 khte4Ekq1ZoiqfHaYsS5KaWfJxwrRi4EoxyrdMMy4Y3LnCgXMSnwcGEKYFpNMOdJ0m
	 zWeLMu9GonIhmFG48uzbN/5Po8p7tarc+XluYZWbxRJhw5MqcLJv0NgHxApXeWnn4n
	 emyLkCr8LczOsX4cTgjdgQJULlQg9hQfWIoC9+1TKp2wvfhDeZaVsKXhoDZE54mDs6
	 XVULY0fDtAGYf/81Z56GkpMzrlSZhMElMs/c4sSZn9+tbp9NBNLxV2plFmPRicPHrK
	 rR0OfqEOUCMWA==
Date: Fri, 26 Sep 2025 09:59:53 -1000
From: Tejun Heo <tj@kernel.org>
To: Chenglong Tang <chenglongtang@google.com>
Cc: stable@vger.kernel.org, regressions@lists.linux.dev,
	roman.gushchin@linux.dev, linux-mm@kvack.org, lakitu-dev@google.com,
	Jan Kara <jack@suse.cz>
Subject: Re: [REGRESSION] workqueue/writeback: Severe CPU hang due to kworker
 proliferation during I/O flush and cgroup cleanup
Message-ID: <aNbwuc_Efg-Bj2Yu@slm.duckdns.org>
References: <CAOdxtTYQye1Rtp-sG48Re+_ihD637NDXTG_V_uLkerg=m1Nbtw@mail.gmail.com>
 <CAOdxtTYKrMhjW9JiOCDBia+s=2tob1HF6yfAytYnajYsSoX5Kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOdxtTYKrMhjW9JiOCDBia+s=2tob1HF6yfAytYnajYsSoX5Kg@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7FCE62000C
X-Stat-Signature: haeyxokfcoihidkxdhpuu33d56w3jf3h
X-Rspam-User: 
X-HE-Tag: 1758916795-731886
X-HE-Meta: U2FsdGVkX1+Jb5HAoGMvInxrMWVKRN1REphOTPXP7ME/6QhWgp+HGoiPq9ggf7m+xICFwtA31TbGmi863Cxe+tdUxgEv8etIm0OMIsQRBv76SuYk+eUCxxX3pBKregAPkB2PFPX7aHUj3MNyEeGrzMp9bAibZzhFACFMi1jXB0RfNFCIZ2DSdHCAKhkCqZJVy6v6NcjCOsbh1NT0EBoaIOhFgVmf/qaEjLaIjsrypPjg2l+ew7rXFxDIOIudxalO5Gx1LQ1IECKgC6ZzxuABLxRhnGAGzOQpCZQFPaBhy5sdtM75Wme7EIyDM8f5bwdQ3wPpmH3qw1vqkyY4ZShn/DHEFkp8i4RLqWNYCynOL3JyaOZS4IV6+XnktOzy2EQrybO2YxrWqmN5KfyHrCkNiQ7waM462u/FWZz9NPmDc5Uihip7nKQNLXLZo3alb3G0Soh+ySia7/I1Sdmth7x9QFCdWZJAxCf9cmPwakBXMlijtK+Nponlw0LeRpsde95TIbOGPVk09GCyP28WfTbIknm2zbYlj4iaCaUN55YMLBEWvQZHa1q/STPCh6F3YyCnoqxkcPcs3vU1paQHxo3+rzRTZ4zUv2ysAYd0rf7HZJfqjqINctoILQGyIOEcIsgj3TrWnx5ee6swt9cFXbzZRZyNvh1eieB1kjhb4ehfxtpAeOMVbqSxKSotz+226Oemty4qJzSPDsZignhan6m0MjLpaOMZQLK6JxZRiQaPgVDw1u2yrpdHfALxiVFB0D+fR/FZKP27MTepXtSOh+Hl6XyA1UKIBBUisBkjSvLB1u7/6GJsFznz5FS13JbmdA4LGAO5/iCQPLYsf6Hm9O+x4MulXwEu8hEkb+5co4u5jTpLoCFdzuaG7MSwsjU97Hc8XstcFQjClD6LzGIqsmthUwg4EALz08dEMQvrFsIwynXDS7wDqDWyFiaHoFVMx8FvETl2Zppb5UGHQeV8rtT
 nHl9Ik4f
 bIBg8NsnWM/3w33KvKNVjEgBG5fFKFwUwhyky/K+wFVhyajR0zG1jcTicg6HJ8Ny4IbRjg4D2umaregTC7tavNfhet5odPoMfrwK3hrwm+CTPsBSo87bxfa2/DaVPmWd6+O73aAQFf2vEb332gzEE8qWahJfEirZ29sMPpVTasJJa993ymX2gbFpVkfLDq9OqC48G7sjiN1+YhZaoWRuIOreUezQCzwa3PoA/LzoxETkm9Ns=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

cc'ing Jan.

On Fri, Sep 26, 2025 at 12:54:29PM -0700, Chenglong Tang wrote:
> Just did more testing here. Confirmed that the system hang's still
> there but less frequently(6/40) with the patches
> http://lkml.kernel.org/r/20250912103522.2935-1-jack@suse.cz appied to
> v6.17-rc7. In the bad instances, the kworker count climbed to over
> 600+ and caused the hang over 80+ seconds.
> 
> So I think the patches didn't fully solve the issue.

I wonder how the number of workers still exploded to 600+. Are there that
many cgroups being shut down? Does clamping down @max_active resolve the
problem? There's no reason to have really high concurrency for this.

Thanks.

-- 
tejun

