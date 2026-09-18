Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23D12C88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 08:17:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CEDE6B008A; Fri, 18 Sep 2026 04:17:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17FA96B008C; Fri, 18 Sep 2026 04:17:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06F186B0092; Fri, 18 Sep 2026 04:17:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DA8D76B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 04:17:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1A4E1A05B2
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:17:46 +0000 (UTC)
X-FDA: 85226179332.22.9B8453E
Received: from mta0.migadu.com (out-250.mta0.migadu.com [91.218.175.250])
	by imf24.hostedemail.com (Postfix) with ESMTP id 22CBE180005
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:17:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OiC8qhaW;
	spf=pass (imf24.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.250 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789719464;
	b=6Om9UnYcBPWuV8WfmAORwjMo/K9kqhFRrVhr5e2ywcvvrAkdwdX8olJLo/sdFVag6SxWet
	LuJEvgnf1G1uaSgyl1t+PNkkyhELUH6/DG66WoEGjCccagFDa0srkOKjJhXaheX0mb2Me8
	9oA7CMM3lIdYHNu8PgEnhEa3WngJqgM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OiC8qhaW;
	spf=pass (imf24.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.250 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789719464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZIXFX9rBIG9zQg5hvTNUaSYyxqeWifxp86PFRRFK6Cc=;
	b=q+lCldjW7cr+GJrCQswUxafh5/l/SL2aFBj2nGXUrwwdCvocW4frhokHKjWFpe3/qnIY1E
	gfjY2f8QYePeSNpFkWrkK3IQC3J6GwPhcskhoV7GuQIz61rgFaUVjdLcP7QGrbt4aTivEP
	nkOz4UcuMKu/JOxt8xeBVf0pi+zFO/k=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=j93Rw5e85f6pY7eCSjFAVhVix8y2aM8tStuN+RPXRkw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789719462; v=1; x=1790324262;
 b=OiC8qhaWNDJzjEhthmyQFnc4uzYwiPYNtFNPfXa9HpOYVFbaRC91p32pnH+cv2Jp3gpGwyAn
 xUyvX0qNGfK98lkix16baIzuwWun/ft2uEwgm+w7nRG88jPCcsqOb/szmglVZZ/h7WrXVJq6XWC
 vGpsrDM1EjJ+uAjhB6cNQIRI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id d0581680cb0ed85c;
	Fri, 18 Sep 2026 08:17:42 +0000
X-Mizu-Trace-ID: d0581680cb0ed85c
X-Migadu-Flow: FLOW_OUT
Date: Fri, 18 Sep 2026 16:17:32 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Wandun Chen <chenwandun1@gmail.com>
Cc: catalin.marinas@arm.com, will@kernel.org, chenhuacai@kernel.org,
	pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, robh@kernel.org,
	saravanak@kernel.org, akpm@linux-foundation.org, rppt@kernel.org,
	pasha.tatashin@soleen.com, pratyush@kernel.org,
	m.szyprowski@samsung.com, mark.rutland@arm.com, kernel@xen0n.name,
	alex@ghiti.fr, hpa@zytor.com, ruirui.yang@linux.dev,
	robin.murphy@arm.com, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: Re: [PATCH v6 00/10] kdump: reduce vmcore size and capture time
Message-ID: <aqzznOgILX2pZg7b@fedora>
References: <20260902073116.802752-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902073116.802752-1-chenwandun1@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 22CBE180005
X-Stat-Signature: x1kawmp4odfwan4tkudtynsjsm1hxzcy
X-HE-Tag: 1789719463-375605
X-HE-Meta: U2FsdGVkX18TUxgildBf3dPwUKuIkeXjZPu1XMQji6laBMbHuy/trPVfYz4SXnTa/RV5lP6ILaYto+K4xSwdxoqtqXwgDCQ3QKOQ+9IhgyItcsujj9D2UVuGXuSdOXQVtqWhkaVqqDE0HYhk9ybOGGDrjDSIT5a3aHbBunoofByMG1/orR98/saBViJDhmfu+dKCCKP40FMyIWxM4/hCXig5l4pNW0UCOQJRhhVptjzgvt6MsGFg0hy3ze9rao7R5G8f/U7DRm4cyWQNVLcfHPuBuNXAJL4vMmHFNtx7D1AZVQyL56n7ivw7lIQ8240O3nFDaToDfkyiBO/E8m1mPOyPRhJffSmZWFatb/XJuuYYKjI3Uq5pzz0rGLMPurxMRHnIsowEo4soKJqyQR2qHEi3+Uvm+CTYs1KfmmT3idoqLC8aDbF8K+wC2pMnRez2hykVTkinCe0nFqPtLpuzzQ4/RdSzPI+QcZVSURgfAtkd1lqRaXEArE57/hVFkcKTJXvRIbQPvwxpwruPs6gDjZOSAXBLf6WAyoDvv5HdcYhN1MFQsbHly7wy8p4bSTDVNyHvg5WTkRj0rylNPvEfnHkl2RxetVouHuYK82Gl1gre2DbDkididFdW5mQ403tt9zTF4nJEev9Y9iG/tAVXiFG5iotfMTnsFxV/hmM2PcLm88NL/fmJfuMLXuYkKkWNHOuzDIv+eU94DIgE/hM56CC6NIOC7oEshraaOT5BIMlZr3aLzMtHmtF7qx9CT2kMOQkUo3WeX7ESOjZsuCylLyQU3uY90qHNp6kpOcW/GUPJJ8eyvju+RAtBmzNoZ+Njrr5S3AyaQfMJJbyxolbM8DYY97h1LsD2+zXPRZJKZpKJ60dqvD3h8XAl4IHu1xotQ+TWYYpFSz/llpADbe29tUMV5M4buGfjSVYowquWj4t44OdxT6BSXRP2BrScSG2oRQColy8+gDpdbrHsZ/v
 Z4JD9Agq
 UIMuajvEhjz2K6kmGiIhkbkTo/wMbVFw29fITwiTQKC+iJDOMW8F9B41NT42sz4jpUupXSe8ygIpH4sWtPXAE8QQP+8jSt+m4wYwzVvESlUTUWylGZRY5x7Cxl6DUmbm+SWwue+V/YgRVGfPwIo/k5jjra3nevt+Mr7BNTizkZekTaoYsJI1BcraXfPNIaj2gEnZOY80wQYvPi6MmJVMeENa0i4u/oOKMElCsaknWXhhX79AggrYx9s4G3WT0hr73/nq+xnlaqu5jPCicbjFyunmpA0HT3wkbKl53AMJxQVhkjqzLQqyzgWlMc4xqJ9pzbXGSy2HaqYddH2s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/02/26 at 03:31pm, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
> 
...snip... 
> ACPI systems already filter reserved memory out of the vmcore through
> their existing path; only DT-based systems currently fail to filter these
> regions, which is what this series addresses. The flag lives in memblock
> itself rather than in a DT-only structure, so the mechanism is generic and
                                                                 ~~~
The patchset itself looks goot to me, while I am concerned if it's
really generic. I raised that in sub-thread talking with Wandun. Imagine
I tried to exclude many driver regions and split memblock regions into
hundreds, cma could yell out: cma_declare_contiguous_multi()?

IMHO, withdrawing the claim can fix the nit concern. If I am wrong,
please help point it out to let me learn more.

Thanks
Baoquan

> both ACPI and DT systems can benefit from it (suggested by Rob, thanks) [1].
> 
> Since the reserved memory regions are filtered out, the vmcore is
> smaller in size and faster to produce. 
> 
...snip...

