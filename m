Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4A3CCAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 17:51:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DDF88E000F; Wed, 24 Sep 2025 13:51:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 061268E0001; Wed, 24 Sep 2025 13:51:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB94B8E000F; Wed, 24 Sep 2025 13:51:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D3FA48E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 13:51:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7D1AE139D20
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 17:51:31 +0000 (UTC)
X-FDA: 83924885982.05.049912B
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf18.hostedemail.com (Postfix) with ESMTP id D59041C0007
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 17:51:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=DqbVTkca;
	spf=pass (imf18.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758736290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1v/KwM/huxtHbwJvg0b1BdepVHxNprsmpQM5BGSeRcE=;
	b=SAJZsb3Vdhm0MFwI46MQHwYm3SjGyQorXov/mV6td8xlhYNvOlY49NZ/bB4J18s+WZezeo
	pkKPag9b8TA3+VQmSSiDn2mLyiZ6v1nm3EHAZZkqNldfdS/Md6u1kbkIi8vno0S87LYF7k
	R1mPgDw5913RyLp8hvdtddF9Vb0QDYs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758736290; a=rsa-sha256;
	cv=none;
	b=keXlQJ/ZOxtUuDOwk4FaTN7vQT7lAGt6516mAyrXWMoU7I0vh/Ufyq5Muut2/z4PZKq3JU
	tvpwarbAuEz/hamdtb1VgFshksoH5enJ6srW9fxkafF+2phYimvdsiFFkOIo6Eg+c1WHkQ
	AWEPLZyc0HkEDOlnMNuQHDk8SbzaE/U=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=DqbVTkca;
	spf=pass (imf18.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1758736288;
	bh=1v/KwM/huxtHbwJvg0b1BdepVHxNprsmpQM5BGSeRcE=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=DqbVTkcaY2mxqjDwK32gR+OKB5UHJGJ6fYvY5/hFtLnO0BYvabDseryR6j9qIhGV/
	 +1Epf9QOiWySiyNWVUOqqJRMqddF0uNRtewcmXp4wzVAZTbX3dAn7xFUai3uyXUXVl
	 XszpToJbf2Y9Bl4p1xU8GtFtlG9b1+YsGNq5UgVU=
Received: by gentwo.org (Postfix, from userid 1003)
	id 8B0C540293; Wed, 24 Sep 2025 10:51:28 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 88C414028E;
	Wed, 24 Sep 2025 10:51:28 -0700 (PDT)
Date: Wed, 24 Sep 2025 10:51:28 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Cong Wang <xiyou.wangcong@gmail.com>
cc: linux-kernel@vger.kernel.org, pasha.tatashin@soleen.com, 
    Cong Wang <cwang@multikernel.io>, 
    Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
    Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
    Changyuan Lyu <changyuanl@google.com>, kexec@lists.infradead.org, 
    linux-mm@kvack.org
Subject: Re: [RFC Patch 0/7] kernel: Introduce multikernel architecture
 support
In-Reply-To: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
Message-ID: <78127855-104f-46e2-e5d2-52c622243b08@gentwo.org>
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D59041C0007
X-Stat-Signature: nf5ufbn6z8o54khxogqt9o11748hjkqx
X-Rspam-User: 
X-HE-Tag: 1758736289-95992
X-HE-Meta: U2FsdGVkX1/uLnsgdBiWOBV/CXE7uRTJTSUArTJ/lr85M/KeBj7Tp71PzVp6m5ZCrs9A7XUwn3AYfqghDnGNhSPbtmOzqySEVltZVMTDF7FO9CKDuq5+2myIwwoQ8m0hWT36c1i9/M7i0d1PlMNfIF1NC8SA4QJZQS7KPW55lzv1O6tOP4F9P/kk8fISfcCYphYOlZv7zIee7uFuDIGSyg3yStQJTviKa4VMElIgCKcs+MTG6MX+V79+0F6AcxVMKIlSkvy1YEf7SnhoETKj9i/flljHk5cjjq1tWuRsh4k5MPJOK0krXfa5I8OkURNKAeyb/iRK+aaEaP3A/piJKE9TLk/BIHMaMWbWPLXRLLR4EkYyY6CkAaw/DXx95FrCDOYmR7dQr2ZF16H04hkC2Xs2SO+VH3orIl/Q0CZxbsTzXZNhw1uAnGaG4gqUmds4pmMQ6R5LShc89GwDbUZ4RBnBokIqZUMeokmuoXGYTZrZpAa5faVGGnHUvaXDbC163kRWKqejgF5bMk0WH0n92lfXI18c7qEINBfd9Evn/5y+XfzKEKDJtrncraM/0vMPOF0tyj1PpBAEczk33rsj2i5yvJzY857Au5OF/OrbfegDPEusgEbTeDjfxRpT0iA21Nz3aJKMiycLBLiEUVhepdezyhtwNefvOHw/B4bhixKIcP5qrEKlu7PwpqR+TlYiJ0Tm5V6m3v42YKGq9UOkjjeR0efHe2xlLHHEB/u3c7Wm+5Uz++1wZxuWvhmSQ+K8h+eZgOehccjXx56OdNPkXpIX4gdyQPu2AEtbT29rS+ZRBuuafyJNklqdGbbW5vvjSsIrWf2XbsTuD1J6tyeJDNGKWAm6bpgNKiRIzVPF4pGTz0YjFCIiXXIz4/SqmXGgoT/OZTqMq2C41elvAiwAy2hjk78EP4FDDdmoJ+mw/ueNa5YHjP0IXFQwIpjboPSkBB5aoJCxysDJekaiwB+
 noUN3fot
 mb4vr4SizPgqBqL+w+TbOB1Wernys0dtbIRlQh+iqmK1mGWk2VRcPhaMxppZMgXUolJnZWRtcMX9UdLnbz5W8kKqGLEiVoyveLNwZRxo7il0Piou3u7bPEkgEMpP0JMfQf7A3gFSvAsSqbeYApVAhAtiG0P//+lUrBZIK9i8Pv5t0pbSg1BJRHU9vMnCfKeRlV/nvRnovZXT6uNyplYxCO8yzC/aKIGmhZq2RK6iyMLDg1jFWfSdI5gsr93Yq6/ecZvZ2vQLpXHSNg6eecesgp9m0Yg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

You dont really need any kernel support to run multiple kernels on an SMP
system. Multiple kernels can operate without a hypervisor or anything
complicated like that.

The firmware can prep the kernel boot so that the kernels operate
on distinct address spaces, processors and I/O resources. Whereupon you
have the challenge to communicate betweeen the kernels which led to
various forms of "ethernet" drives communicating via shard memory.

This has been done for decades. I have stuff run stuff like this on
SGI hardware and Sparc/Neon back in 2003. ARM should also do this without
too much fuss.

There is even a device driver to share memory between those kernels called
XPMEM (which was developed on SGI machines decades ago for exactly this
purpose). Its ancient.

There is nothing new under the sun as already expressed over 2000 years
ago in Ecclesiastes 1:9. ;-)

The improvement here is that the burden of implementation away from
firmware and we can then have a memory based "ethernet" shared memory
implementation indepedent of the architecture.

The reason this was done by SGI is to avoid scaling issues. Machines with
high numbers of cores can slow down because of serialization overhead in
the kernel.

The segmentation of the cores into various kernel images reduces the
scaling problem (but then lead to a communication bottleneck).


The rationale for Sparc/Neon were hardware limitations that resulted
in broken cache coherency between cores from multiple sockets. A kernel
expected coherent memory and thus one kernel for each coherency domain was
a solution. ;-)

AFAICT various contemporary Android deployments do the multiple kernel
approach in one way or another already for security purposes and for
specialized controllers. However, the multi kernel approaches are often
depending on specialized and dedicated hardware. It may be difficult to
support with a generic approach developed here.

