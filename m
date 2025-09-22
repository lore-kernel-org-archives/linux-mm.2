Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD6F9CAC5AA
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 13:01:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09C188E000B; Mon, 22 Sep 2025 09:01:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04C6A8E0001; Mon, 22 Sep 2025 09:01:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECB798E000B; Mon, 22 Sep 2025 09:01:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D70388E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 09:01:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 85E051DFACE
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 13:01:38 +0000 (UTC)
X-FDA: 83916897876.16.C077A08
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 992BA40037
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 13:01:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rP88G1FG;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758546096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N9M/oBeoYqWJWCf3PFCSa60guGij2HMSUN3yaGFP9vc=;
	b=ru60xcsaL4qu6opnxOIOAnKiCbT+McD6A+4KfRzYHAqTX+9KMKK8MjjroyV2e9XGsjhRrx
	BPZh2IZ/jMDQYDjX4EhlHkeywy3xAcLAc9Grk3WWGXwjLNlOd7pHBhou0n4zp1wNUpI2lV
	wlTe5XZLPyJ8Z4tTyAICzqlqL8Fve90=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rP88G1FG;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758546096; a=rsa-sha256;
	cv=none;
	b=QYRhlv2ShstDRbpvIh1m57n5afAaKrNK4PItTnjSrnyZpP4/8srBxCn5A/d1zblw0SQPmX
	mPyh72hmd8AMMWBzWgkOqOIfXIE0y9Qx747dRs83AVT5mM1meuLo2G2Kn0tC353tiVuV/S
	hns+UjFLvuM4Y1xyWnErxeeFwIeCOBg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8721F44CD3;
	Mon, 22 Sep 2025 13:01:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0335CC4CEF7;
	Mon, 22 Sep 2025 13:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758546095;
	bh=2CAnXG1qkWNikidwFhEXx27Lsfxn0xi7bL5FS8cZuG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rP88G1FGh9eIvjgLwQ9ozeQhogSfb7c0c3rIE0FEHjSH8ac7T6zO+XW9tMpfX0URe
	 EowI/udzGp+XOMFj+KRuFwL/tzpiXcQCOiU7qh/8Oa9luR+2m9zmB0ZEO+H6XoK8YM
	 EVGgC7LXAYWA7qLPWkUpf4v93WKncWRiWwmGWwq5kueVU9dSf3/tJMPF46SkpyrIyP
	 Z6yljbBKz+CXWeKq4Qd47/HPK0UQGXpOlAm3NpFzNl5fvgwamDpKN1l1UMaM4n33rm
	 xSSllXWC1RKwpQzRPiYlRZa20ofyoggMllBUm64lP6nW0IOANmIGsISbCzuZYSY2cn
	 QWJaRyjzi2D2g==
From: SeongJae Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com
Subject: Re: [RFC PATCH 0/2] DAMON: add priority-based scheme application control
Date: Mon, 22 Sep 2025 06:01:32 -0700
Message-Id: <20250922130132.59955-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250922101022.362822-1-lienze@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 992BA40037
X-Stat-Signature: phczpoczubnnu9duxe3c84gkmfki3cr5
X-HE-Tag: 1758546096-67927
X-HE-Meta: U2FsdGVkX19IXukm00sqCtU0ofdZAWLaAmn+K0rcNANPYIMmJmF46egKqjMShWh/rOG6n9vhFzYK6iFMV/UZK39m6sH2RNG+PPCy6vm+sMVg5dfcHqn8nHzyt7T64AzrXXRPTcHdQqUfsC14Yw1G4YzMUtunNGlTu2xqKkzeO42NJdAN68lUuIq9p8DYO5DGKvYVDw+l8okyae44VNOYKH9eVXPS/FjfKUZ0bw332YF9h4+DhOzfCSBKQ0k5VQdoXndOSMxN9uCyRw/+ATQb+lhMBHuSL1Lyd+SguYF7nbGHsduXsPrPiHeXJ3+4WtgJe7nfeyv1aCSewx341rjJWJYWtscCrOsNpu+Fjt8N9Ps75UV2YkDrRKG4IOGj2bD3XO7SlLfQn4slTTReD+zJuqlUR+aSzRGKbjzOHbe+0HoXnpKnYgN66aJShumoUolfrnON8I27RcUd4UcECK7kZcve+rVTTiEyU/l9u6N+8bUrEsMMaQ4Hdzy9L1NVdjjVKAoNNvL+k2e+krtsHoRFCy1M/kcCc8o2c4fmg12qGurjEPMFCEnvsU1S2+uihw8TfT/Bc8Tp2Zs4JSHdkbWLimOoYyFA36be1XTNMv5OFKb7el/rsQ4Clbi+WygXPl/QNbYWWRhUBPCtT5egZSq7XTUjBjfg3LRHTYWh+X4iXMy+s/20ZHfIqsxcKCMrEbJIhR3TiDgmR2pkeAHU7tzzRS9SJRnzeMdtmktInz8SvEayrteGaOCGbcz+5Jz+qViaLcHmDJkmYf6EpmBNgOnI38k1WekLhlJuUFNnkdTsYeQ9zjMnetyZaLhnoKE3fcqju+S8DTrTgec34x+ROtq+P/6zm5c3aFI3ZILWvHeZ6Upe9NMI7njDinJ6aoH/+4xR4o6SQ0iVaR/AxpE1RWUuBJm6+I761bltHLEhXjoZIsLX8+NFiqQ574fmG1CKSeJAMl7r3CdEScbwzOByWW6
 DfiPeYax
 hRd7EXclufGioSvuO7EVZVe7VuFBILlEFLQORZI3s8Iw0M8tFHBqPPEkYqGigGgqMgfS5kB2KRUEymnUQ5QARIfFECEmShmV9ZhEdDsJBmpWTNLoJxZt+gF1v48lPbFcb1QkwcY2rqZUdLFJekGwsMOaWac1dh14O5CcsWHNe5dsaUp5NnV/xYl3puESVUABF14Asy54iEw2dLfsfEP5P2svudzhhmKEjaXgz+4tr1HvDpig=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Enze,

On Mon, 22 Sep 2025 18:10:20 +0800 Enze Li <lienze@kylinos.cn> wrote:

> This patchset introduces a priority mechanism for DAMON's scheme
> application, allowing users to specify the relative importance of
> monitored processes.  The changes ensure that higher-priority targets
> receive more frequent memory management operations while maintaining
> fairness across all monitored processes.

Thank you for this patchset.

There are features for monitoring target-based DAMOS filtering
(DAMOS_FILTER_TYPE_TARGET) and per-scheme applying time interval
(apply_interval_us).  Couldn't those be used for your purpose?

> 
> The first patch modifies kdamond_apply_schemes to implement
> priority-based scheduling, where targets are processed in proportion to
> their assigned priority values.  For example, a target with priority 50
> will be serviced 50 times for every 30 times a target with priority 30
> is processed.
> 
> The second patch adds a sysfs interface (priority under each target's
> directory) to dynamically configure these priorities at runtime. This
> enables fine-grained control over DAMON's behavior, making it more
> adaptable to performance-sensitive workloads.
> 
> Together, these changes provide better flexibility for users who need
> differentiated memory management policies across different processes
> while maintaining backward compatibility with existing setups.
> 
> You may want to verify this feature using the following testing
> procedure:
> 
>  # git clone -b v2 https://github.com/lienze/damo.git
>  # cd damo
>  # ./damo start --target_pid $(pidof <target1>) --priority 50 \
>  --target_pid $(pidof <target2>) --priority 30 --damos_action \
>  pageout --damos_age 5s 5s

So I'm wondering a command like below could be used instead.

$ sudo ./damo args damon \
	--target_pid 123 \
		--damos_action pageout --damos_age 5s 5s \
		--damos_filter allow target 0 --damos_apply_interval 3s \
	--target_pid 456 \
		--damos_action pageout --damos_age 5s 5s \
		--damos_filter allow target 1 --damos_apply_interval 5s \
	--damos_nr_filters 1 1


Thanks,
SJ

[...]

