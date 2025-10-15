Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFB35CCD184
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 02:50:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B606D8E000A; Tue, 14 Oct 2025 22:50:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEA368E0005; Tue, 14 Oct 2025 22:50:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D8D98E000A; Tue, 14 Oct 2025 22:50:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 872838E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 22:50:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 499601A07CC
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:50:13 +0000 (UTC)
X-FDA: 83998819506.25.29E755A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id CD05B40003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:50:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0nlJ95+B;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760496611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Sw4y3gIxZ5+AmFWe+DM4l79O3rVkDzFgpmPEgCrMQU=;
	b=LCl7oBhOlFtAizR9nAZeSwAgnQCYyErDg/JD+dxkd2FOaleJCdsX6UnGuJJiNtPUz5wPR4
	Jt9+xi7h9FYvf1mGTNnVg8JhB8ScMXw6qAt2BTzBc4z5pIhahimN6mr1rxQ8EnbAV7dCNF
	2t90jO7Jeh7mUJj8x2juP14kw2cTWYg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760496611; a=rsa-sha256;
	cv=none;
	b=Hf8SQa58ucAQAgDGpWx66wwsk3HTP0MAV1uUam/pgvmNRJftTbMCHkJCxo++9dTnNaQU4l
	7H+B3R5Wha/icAhnjIBz3hMolU+Nmj8nDkoWYEI4s0ZTxKI26Hi1GJiB5hl/Cvex3lNtuW
	0L4l5wPnfojsBpKQU2J2iyiUehppedA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0nlJ95+B;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E116D62496;
	Wed, 15 Oct 2025 02:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4887CC4CEE7;
	Wed, 15 Oct 2025 02:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760496610;
	bh=uZ09AO8FUvS3PHoAN1UIg/EUNrO9xZYhQBj5B5JO7Dc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=0nlJ95+Bhw11gF5P6sHbaL3cDIndYHosNII1BXzisn4R0MTRea/CVyK4kVoIPqEaC
	 rSdFH7sBssAq0yh7mRrT041p8MIe7D6d5Fg+2s1zfBHsCznRIrVXYaWSwhv2gQwq/s
	 GYBJCOOVzs/IgvlK3xIdVO1FE74FGqRnXDFnMnxk=
Date: Tue, 14 Oct 2025 19:50:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: oe-kbuild@lists.linux.dev, Pasha Tatashin <pasha.tatashin@soleen.com>,
 lkp@intel.com, oe-kbuild-all@lists.linux.dev, Linux Memory Management List
 <linux-mm@kvack.org>, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [linux-next:master 13427/13588]
 kernel/liveupdate/kexec_handover.c:978 kho_preserve_vmalloc() warn: missing
 error code 'err'
Message-Id: <20251014195009.9505434cfdcc136503f08df1@linux-foundation.org>
In-Reply-To: <202510100941.GZGMq64U-lkp@intel.com>
References: <202510100941.GZGMq64U-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: zkqg87bxtkoyayp5o6j3sf4nxsp4tfbm
X-Rspam-User: 
X-Rspamd-Queue-Id: CD05B40003
X-HE-Tag: 1760496611-815519
X-HE-Meta: U2FsdGVkX1897/IBGaQtFLkwXSzDsVWE6Iy7hEsrLsfenO8Aduvw1AfCS0iApmo1++GNkAJ4aqIudzna8O+j9NrgQk7UAb272AHdd2C8JobCbGB0eHA0M+gdsXnz3uLI2BfWx/Yjx3NQIjnxjaCVSdW7zPhcVV+k9yXf1womnRv1KaYczwzj+Ab6wayn3ZW+TgW0UwCGpW6Khj0GTVQRnxtvfQoWLX1rlASZQiC5xFdnaELJFjg9p29jyD0HoEqmWzevHTjWvciC3vdYDPl93Pvm6/ew7QL93aE4rzsJbsq/guqd6JZXjX3IIYRuFc6/TZsP64FkV50/TE1V5WQ/eBuKzb2hDao9SwQE+sHIPmhTbNoO4kUPjmDeYReAXsVZdHoT1BWzeBiQdM1Wgk4flxFCwhS+2Xjjb8sKxT1h7PW/ePRbrQHkYANaqwI0ngLUk3ZRi4Njqr5QOBZEw58c2b278NM+tM166poJKCg9n7SE/bWq61NAOSTkMSfgiX5aMlNJ9vpgQ5yushypARLTpSdUK2OuzZ8nanL11WebY7JFlTbFk35VHHVrhQlqLZVXeaQABeJASK+S8L2gXv4lJxmO1zkvkQt7y02sje4wz8GpDKGmJn0ucwEGkKUeNAOKJ+oY4eakBkt1VDGQncT46JdGY8ta8HsSx+kqANO6goLMAytLLQZ+A5onRXEfT1SC+jGtKQSVeR6FmA6FyuqjA4HkH8e7iSe9Kso1lrwwzFILECFt7l8nWqZ036y6GDwU+zcyxY9nX6MQPHV/gKWSTNwtJLOHnd1YhKcU6Iaolo7aDJnIYycXpoMY8rtzeO1FCM1waZ2tBxnvNWA7VdjAYhnNnb4z0E/a8984yKxf5c115TA/aOCqoRQvEHVj750iIhty54Ul/w8yGBRpUew7ncux/LT4r6jTBcw9wJF9jM3CJIa0USoY4aWere3h0C7/CoiKSkURNHdEGzg+UFR
 odg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Oct 2025 11:15:56 +0300 Dan Carpenter <dan.carpenter@linaro.org> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   0b2f041c47acb45db82b4e847af6e17eb66cd32d
> commit: f13bb574707674d1113a40e0b6dc4d9a143d2ec1 [13427/13588] liveupdate: kho: move to kernel/liveupdate
> config: x86_64-randconfig-161-20251010 (https://download.01.org/0day-ci/archive/20251010/202510100941.GZGMq64U-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> | Closes: https://lore.kernel.org/r/202510100941.GZGMq64U-lkp@intel.com/
> 
> smatch warnings:
> kernel/liveupdate/kexec_handover.c:978 kho_preserve_vmalloc() warn: missing error code 'err'
> 
> vim +/err +978 kernel/liveupdate/kexec_handover.c
> 
> ...
>
> a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  975) 		if (idx == ARRAY_SIZE(chunk->phys)) {
> a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  976) 			chunk = new_vmalloc_chunk(chunk);
> a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  977) 			if (!chunk)
> a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21 @978) 				goto err_free;
> 
> err = -ENOMEM;
> 
> a667300bd53f27 kernel/kexec_handover.c Mike Rapoport (Microsoft  2025-09-21  979) 			idx = 0;

Thanks, I'll add this:

--- a/kernel/liveupdate/kexec_handover.c~liveupdate-kho-move-to-kernel-liveupdate-fix
+++ a/kernel/liveupdate/kexec_handover.c
@@ -974,8 +974,10 @@ int kho_preserve_vmalloc(void *ptr, stru
 		chunk->phys[idx++] = phys;
 		if (idx == ARRAY_SIZE(chunk->phys)) {
 			chunk = new_vmalloc_chunk(chunk);
-			if (!chunk)
+			if (!chunk) {
+				err = -ENOMEM;
 				goto err_free;
+			}
 			idx = 0;
 		}
 	}
_


