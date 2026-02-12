Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53DC8EEA84A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 18:55:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 716056B0088; Thu, 12 Feb 2026 13:55:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E7326B0089; Thu, 12 Feb 2026 13:55:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F3696B008A; Thu, 12 Feb 2026 13:55:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 509086B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 13:55:07 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EBC5614025D
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 18:55:06 +0000 (UTC)
X-FDA: 84436707012.06.9F4E85A
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf05.hostedemail.com (Postfix) with ESMTP id 29EE410000B
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 18:55:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=kpqMKdOr;
	dmarc=pass (policy=reject) header.from=gentwo.org;
	spf=pass (imf05.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770922505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5AlMI9FDFa1Mx735h5DZZmNxGuErgiT7cfvMhR6xKVY=;
	b=IQkk+RYtxqXIxboOMqRqLKKFozJUMlpJ352FZYeU8H4sgibTEBe84b/c1EMCsokgijLp2c
	3UilAPhONwULnAHWr6K3OdogEu0dLjRyoIe6veQZQHVBmBeD597tjaKkbFdP32htQQcCbc
	rAiUkpyrQF94Ojh56DwRIYfTQJ/b3wM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770922505; a=rsa-sha256;
	cv=none;
	b=dt1VDWRmFbkt86VKWChQ2tJGIAHXuW6KcQOV/aAeOtmGOyu5z4exKAbcgRXxRQlfBtNcHu
	1RNEYbj+nl8ebYQpURtiIIhJBw9PR1wpvUXcoyUfrAOM9/bGCtZcAFOkUOGChUUtroTNLU
	EDaBbHMaiMs/wioJKJk7RWoJA2FuOVQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=kpqMKdOr;
	dmarc=pass (policy=reject) header.from=gentwo.org;
	spf=pass (imf05.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1770922503;
	bh=5AlMI9FDFa1Mx735h5DZZmNxGuErgiT7cfvMhR6xKVY=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=kpqMKdOrzne4eUL1R69ofY95dvUA5Z6ZMIhA2bkdQjtgZv9xPZqkWC930PFqeOKid
	 RHevioeq25PWRvRvuqUQfFqsKf03A/eoOMmu+xVLU6TA5H0bpa/X3Mz6gfh+KNE0KK
	 JCgdkgm5CSdpELoYz1qAs4/57yj1Vr0qALr1lSiE=
Received: by gentwo.org (Postfix, from userid 1003)
	id 8CC04401AF; Thu, 12 Feb 2026 10:55:03 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 89FA640078;
	Thu, 12 Feb 2026 10:55:03 -0800 (PST)
Date: Thu, 12 Feb 2026 10:55:03 -0800 (PST)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Ryan Roberts <ryan.roberts@arm.com>
cc: Yang Shi <shy828301@gmail.com>, lsf-pc@lists.linux-foundation.org, 
    Linux MM <linux-mm@kvack.org>, dennis@kernel.org, 
    Tejun Heo <tj@kernel.org>, urezki@gmail.com, 
    Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>
Subject: Re: [LSF/MM/BPF TOPIC] Improve this_cpu_ops performance for ARM64
 (and potentially other architectures)
In-Reply-To: <5a648f49-97b1-4195-a825-47f3261225eb@arm.com>
Message-ID: <32969518-9106-363f-8a89-479b8246e4b1@gentwo.org>
References: <CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com> <5a648f49-97b1-4195-a825-47f3261225eb@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 29EE410000B
X-Stat-Signature: xafayi866nrqtk8n9opf4jch117sg5y7
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770922504-936730
X-HE-Meta: U2FsdGVkX1+Y6DvwvwwPw8ygBooz8pPfBLAuiHd+su2GRMli5q+1qEg9kyLaBa9QIZ1OLZpQeSKcoIvd3jmpi+R6HI40L5McK9BYZtvKluSjzXy77aMBgBCwdzqfJoS0x38f6VTAxSyZsqG/MCPKtNltg3F0LeBk9CncGJZdmDxyOIfJpKlGOKURYG02ziTFvEG1Ry5/2KscF3Iro6NNnrHrFtjGRfhPzlrPy2n7jhyLYBVZvJSK+V2Hm5Zg74JqT+7r2E/rtOEkXRIQ55DE1QdAq5moQs3r8cjjUx1tRq04RJsArsMiJonkURzMILAhbgeYhbxENFNh1+bYQAhg5EE6NyeiCmUUZML7MNI70qroxC0NAqQdPhQXtr25Fes73VlhGB5W2NM16mGP5nBbNEwVtyCDv5KoFrT3/T3EP1BJLryXrD0zgJuppzVWMRF8MApOkT6+IkNX4fu0/hjcC8mB5Wzc8WVfUeb2QiWWzninp6hFP88DooWv/EgMIJMyCujxZDyQIWK33SYJj5IPRBrDgHwTQVm2Wy++2afYdCFX/HoBwS+NYdYwdVTOMn2QqRjj4sy4uhgmJ7EiurAMFskS6ETsBmuANBEkc21Ud+TMo4ZI3RyLE9p1EX2z7FhGnQRO5KzbkjT8a3BnZTOJ4TjVITDiiIHygd1YHURuByn4kTXaiH2SkhcjoxcWjjOPOUoFD5RkXNevnDokqQXzpqL75iCMV1Fa7BtSM4IwXlBPn6gEWPhxFun9rw1lYZVpy8wCSYI7Yf3FJpz5mt2QCx0Tc+rvYnBPMo4ZU2Ee5f0gTZK4QUjO+Xob5zjwKfnMDbpHXm93QNIzyokcHYgVX3rMQcPDD/omm9DiY+qPrtJ2TdVNByEDvDGGIAj56aEvUjs0DyJBFEPjqL3z12Sm6FyCpHr5KcmdBbHnvfA7cL03m5uiPWG7X6x0fr1Kuox2ukhEueTz8MOK8KwxTok
 g6G9+0Jg
 KpOd6/OMPTk1+g9EmCyCmWpX9zqeqjaA6dJd56OGpVbho8HLN3B0Y0oTXRQ7v9Wod7I8Iv2MsETRaUtrsbxpSuJHEkR3RawjUJZl+oPCgc4iZf4AsDPWRE62tPG04949nf9oA0SgqCtiZwfEg42l4SQT7krwHgUtIlNyIr4z87i+h4Xq+4MlorU04CRpVjso5LdJi+1wcPGjJsnnafzwVss6dlPyT6Bc2nWvegsaxtcUur/G+6p8rhUbPkc5ZIuYbGhhr/BfG3sOlv8S0H0y/UCAo5MbEfJGKgoJBqRNy6dItd1vhDTRCXoq8bH49tEmu/sC6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 12 Feb 2026, Ryan Roberts wrote:

> This is an interesting idea. I'm keen to be involved in discussions.

Note also that the percpu kernel page tables that are used in this
proposal will also enable additional performance optimizations in the
future

- Kernel text / readonly / readmostly replication for NUMA configurations
to limit the volume of cacheline transfers across an interconnect.

- Per node memory allocator to optimize access paths and RMV operations
for data that is NUMA node specific.

We think that these optimizations are especially relevant for high core
count and high NUMA setups. These may be inefficient right now. With these
additional scaling improvements more distributed SOC designs become
possible.



