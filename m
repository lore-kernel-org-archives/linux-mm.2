Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E670FCD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 13:27:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AD356B0088; Thu, 28 May 2026 09:27:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5840D6B008A; Thu, 28 May 2026 09:27:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C1796B008C; Thu, 28 May 2026 09:27:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3CF8C6B0088
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:27:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E21E1161AA0
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:27:31 +0000 (UTC)
X-FDA: 84816905502.28.3D317C8
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4515C14000A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:27:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=josbuxqj;
	spf=pass (imf26.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779974850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RIaFU2XJHtIVIU1Q+1dhMPDocgMYReg2MIrRHb6jNU8=;
	b=YhxazkAUZit5LSatl3HiydLmBQ2QBpYEGH8Q+Nd/fTMnv+Fm0/3fsaHRpFSFo4uTAQykMV
	qBXeR39/oKZLiG4SLYg7klMv/ORduBZF178hmbovWagwUzaYB5qVQN+mzX3JqGa5HoCzIV
	FOhSlx1vIlYGXD5l+yaKMSYYrhuDq6I=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=josbuxqj;
	spf=pass (imf26.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779974850; a=rsa-sha256;
	cv=none;
	b=Y+B5pKVyk5qq+KH7uTuD5y7EZpqCwIzIrAZO5yqnv4URaM/oOwCco2WGggQ3yWJFMjdjCj
	PYcH1cDFTCObqFdcwKjG4JFG1r/V4yMuAPVFEflmWRMeuMxejmeIiHG9xvW/eiQNXcq09c
	mqG34AiKhLwnEm/xsUOxzYlDsvMWxL4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779974848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RIaFU2XJHtIVIU1Q+1dhMPDocgMYReg2MIrRHb6jNU8=;
	b=josbuxqjhdehCdKhRzCAofaZT19xUuNwvPu4XI9pv5Rw6SamLbNKucKkEI4Wb1/H3gyJbI
	l80ijGXpaziRBx6DZ8+SUi2O0JTyy1IlEV17nK3TwuhmoFskCTLjgEw0Bx8H03v67+m9Mw
	tjAEe8Oa46o35M9DXOW9m13hw7z1f6c=
From: George Guo <dongtai.guo@linux.dev>
To: pratyush@kernel.org
Cc: chenhuacai@kernel.org,
	dongtai.guo@linux.dev,
	graf@amazon.com,
	guodongtai@kylinos.cn,
	kernel@xen0n.name,
	kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	liukexin@kylinos.cn,
	loongarch@lists.linux.dev,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	shuah@kernel.org
Subject: Re: [PATCH 1/7] LoongArch: Add KHO basic support
Date: Thu, 28 May 2026 21:26:53 +0800
Message-Id: <20260528132653.190981-1-dongtai.guo@linux.dev>
In-Reply-To: <2vxztsrv5r6y.fsf@kernel.org>
References: <2vxztsrv5r6y.fsf@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4515C14000A
X-Stat-Signature: xjkwaueqc16c5onphogu8nbppjibr97h
X-HE-Tag: 1779974850-579483
X-HE-Meta: U2FsdGVkX1+U1SbfDuvmehICzQzj0VbuuuKzgDTisbNhp6VLfn2pR2pxB7iqMXBhftuuGHOVmb9SXDdsYpBz+pwxPPl8+749aNvj6rWL8pJO8VHxokoSkQHGq021bvXDUgK/yHH4m0MZSUcFuMMjyGVrHfz5Zx+PzF40lnODmCAhxNH/bGv5KEzwiVkNT/xiUtFJMrQ7G5O+SbUx4XyIKsqQHdW5T8at3jhTlegiULI2C4zvsUxe8LRvw7iKgDJXo5bM3BbWSi+ygPZeaWAlR3QrfxWkWEJM+HpUJ7huG6tj2UDhBjMDH6frsQuSZnmB2tUGfsVeGFd8ZfHJ45Bz+wAMHhYye8puTQMxH3hTr4hzaADM7zcgD9T7pNfsPRR7Qcaed3c5OJQr9pK+43qBaD18volaxv0uQfM2cW157egSj+ljrJIJEuiSNEHvW3I/StDDZjpjSVPoobLqcwAqEMhn1texzQ4oCBEQkJhDhhPSPdH+hnmtg+IRT54USJfIPcE+S+zotl5U5rU/9houIFGmHuAQUlMCRPq2JvdTLqpABC1Shh4YcLCwXQk/7jBvAew3NM21/a+9urYtqnNjyyHyyIwkpPEo+bJolWVyLdl9l+LLDG8u46+J5aC3pJrpzc6p6ny4UaIBjsSt6/o4uWCPDzyipN472oUMOlBBHxSmD0mZGhbmaA4yxfeWFsab674xc3O/RrUssDVMxEzXQCvdVPopK4GupTkGwPNkNM7wY/53vwZC4u5wT0CFWm5B6v25EBh3i5EX1o42p2bjbWuMpDgPSaH3GLe5fP/RKU5frGMqLQ14SkCE5NTfRmNe2sNIobTFooWx46yVhclBySQ2Edmq+7ef2MIjn3zDQwYFlG2Zbl0askhAA0bUlbVrprHOONmbG5/Bst3JSGb1kzcCmu35EgXR546gvXnE/1beGeMxyFynWOWGVDa+kwRrz1Mw25yTuWgIrEfzgAC
 gZvEEvfW
 0UcS4Ed3n9qjQhWEOooCCqe9er7nLXxpsqWcF5au64kTmC5SRR8GeNc+r3gwoQ7MP2FQB+XkQy/JqhE2MZVvKgV7I5QcdZMmYgAPlGMPamxuLLMgl/n4vyoip/vcnoU3Il01gbRspysh5ZzTgw0KbWyJDYqK9rqziHtDTD3Da0/uyXtwHJGcff1iiCWLCgotewlL6IfPhM0OxieA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25 2026, Pratyush Yadav wrote:

Hi Pratyush,

> Do you have nothing else for a bootloader to pass data to the kernel?
> Passing this via the command line seems crazy... All these addresses are
> now available directly to unprivileged userspace. Can't you use the
> device tree like we do on ARM64?
>
> Also, this commandline parameter isn't documented anywhere.

I have tried the FDT /chosen approach, storing the KHO metadata as
linux,kho-fdt and linux,kho-scratch properties (the same properties
that drivers/of/kexec.c:kho_add_chosen() writes
and drivers/of/fdt.c:early_init_dt_check_kho() reads).

This passes the KHO selftest when the system boots with FDT.

I am currently debugging the ACPI boot case.

Thanks for your advice!

--
Regards,
George Guo

