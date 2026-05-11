Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B5DDCD4842
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 11:00:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9C5D6B00B8; Mon, 11 May 2026 07:00:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A26656B00C7; Mon, 11 May 2026 07:00:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9152E6B00C8; Mon, 11 May 2026 07:00:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7D4946B00B8
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:00:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1502E8D98E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:00:27 +0000 (UTC)
X-FDA: 84754845294.30.60D1B58
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5E14240012
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:00:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EKgSxuzD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778497225; a=rsa-sha256;
	cv=none;
	b=rV8tlcyX9HUljgjlUs0YNDAdTLDnDlzvtWvfmIPc6WQ4DhxJpD9vDoImc9MwAkDhGPZY3T
	Slrh4rz1DiCQqfk4V6NuzjfUj1CwKaXI4rdoUcWs3vePMWcXUeVVK4u4byNhcJCNY5SFoB
	Yc+ltgSXoMa/H1yvQxmuf2dl2eEl/ds=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EKgSxuzD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778497225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ByIc7zIIWGLLI0p+nPyGQsuprNRGT/xo9ZNlU6v687k=;
	b=lK674xXEhWZiPGd2vsqoBBz50X2qu77Xl+7Juhin02x8xQEglRK+4uYoBwL/nl4oTlWc8V
	9KJ2t0/hppbWB44lmfnzCEPRppQpK800EnPHUrw+9cBCPSbI9BAu3cCOp5qcgn5h8kvhqD
	JcAZvUMDfjNfu0qwpqESrIpSy5Op3mU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C0F7B6001A;
	Mon, 11 May 2026 11:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02967C2BCB0;
	Mon, 11 May 2026 11:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778497224;
	bh=izvnagj9ZLJVxR+qNc7RMbvt9I2ey8INGl6X8JOMJbo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=EKgSxuzDb6hj8qW6BihC8pNQpuLkpsS/rpx3FJpEScZc4OBPrfWt/ibmj9igKBasG
	 SFrgdhQpEKGkgE7P+7isoCIrzDb6xjlhFz8R1QS5FGx062XzkqMqmmup+di9h16mCp
	 m6IijHxemds9GdkcSbj8GdRq9Re49Al/h86jRNbdBqsGV7AhmqdJw8mr73Si8CFNAD
	 I+MMOroM3IEeHiuzN7ErYkwMESlI79yRWU0TB6+/t7r1mHBjWHClN8I8OqKjMUEDda
	 nniyDISCueVN8cpTW/129Lv+ty0uhEJDy3XcPqu/9eUwEUGPA3K7foSNF599cCajlV
	 xOMnTylqpXrjA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: rppt@kernel.org,  sourabhjain@linux.ibm.com,  jbouron@amazon.com,
  akpm@linux-foundation.org,  linux-mm@kvack.org,  bhe@redhat.com,
  linux-kernel@vger.kernel.org,  dan.carpenter@linaro.org,
  rafael.j.wysocki@intel.com,  piliu@redhat.com,
  kexec@lists.infradead.org,  pratyush@kernel.org,  graf@amazon.com,
  changyuanl@google.com,  mario.limonciello@amd.com
Subject: Re: [PATCH v2 1/3] kho: skip KHO data for context-preserving kexec
In-Reply-To: <20260506182039.2623553-6-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Wed, 6 May 2026 14:20:41 -0400")
References: <20260506182039.2623553-5-pasha.tatashin@soleen.com>
	<20260506182039.2623553-6-pasha.tatashin@soleen.com>
Date: Mon, 11 May 2026 13:00:20 +0200
Message-ID: <2vxzzf26cit7.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: kp7cnic834w3oz7s1t43mwee5fyrh968
X-Rspam-User: 
X-Rspamd-Queue-Id: 5E14240012
X-Rspamd-Server: rspam07
X-HE-Tag: 1778497225-986310
X-HE-Meta: U2FsdGVkX19C+TlmhwiTctN9GkNvZlfYLODYyv5xOGywZyQZyyBVxfuEYv9r0CR8Er2JT7iln88K6F0kcv6OIx4yhacvG5ipq9fpLCavSG2ssAi7JZitHW0vBy+Wsa2ILCV4Ca9/p7Ez6k0qqvgiLelC+zlorN38g9N1YxbDBhiqGHgNZijRGIUhHaSZOX9VthzDXoher39wHgbaJlrrEKNPRuTt/v0dL1wkz7Yjqk/66csw7wmSwHE1sIOTuBGM17KUx/28MOn5BWIR6xrDr6ZAR63EVbx3H9J9KyGFIMljvswXtldpBsefG3afL68NQs9aSABVxzypINjVDSSAc5sF7d0P/4rCgK2YmD8tIZRdiW8B3nbnYXGysoVq+TbRoyCOQ01fGoi3KQm6O+qIcd+SEIVNnb2+luBmfNw0vKo3xjUoxQqVcx6/Dg9qc2WbHbbUr7jiGRIjuOkZCayCg04ZYLNbvCRSCMI5qjbcgelg/233P5vSEW5MVMTAdmt4jCU52hjHRjER3AtymK7zdJb5bHEs03sRZHR8SiCSZ+C0hLURr+TYEgllwLkDW2bjilo9HEc84fFvPk8LUoTsEtrzMbk5qNPGVsrGpgP+Mb5XmAyguk79e8IRJ6UHhAeeYnHWZ6AF/eswH00C8vRKon48zfJPQ2BTFO/QR00f/C9HQqvLJTiAl52qpqCTiGUKgjSrZPq5FqzIN9z5CKwfTeU/kkzmg11MeTFjQuM3m0/Cka4FI9XOR2HNxQLcRrzkN2yGd8BYl9rADAdPcL4xzKK5BPM3Mz4yiZKw9I4beV6AHrJsvzgbGDOzZApCKdSgTkka4mQUL7/wRr+kroQxvzV/wu9CjADMiHlBYzdmL1fXK/gLRILDYYGZkSF/NE8gkhurUaeg9eaNPm54/bmXEGkw0VCC2XxoKuozXK5vZDWBM5OY5+XQt2wpDN6I3IVqbd8mttzb7nptCtzmCle
 cN/AONIj
 qwGdAasrt1QWlNl8ZAiNWf/MMerHVsgR/y/4/G16fGhIDWE9cc2ziqWJDvehN4Xk7UBy5qbLfC4kX6qS/p+d4FA3Uidry1aMFFHcBXk/vkSjj1tTz5D2fgv6YopigB/Ebd05zeK50aJnYUQwFSz2i1cHK6SW6QCDHZEkb8SCAR0RYHuTJB/bloXoopUWQwKZt/jf71adlPIuzAyd643AM3+HTnEu6M8+IsguShyUbdwDjUUJcLDmI88yAGylO24wr499hk1JKUMNv0iOUAugGy9LjCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 06 2026, Pasha Tatashin wrote:

> A preserve_context kexec returns to the current kernel, which means the
> 2nd kernel does not use KHO data (and their memory spaces don't
> overlap). Passing KHO data to the 2nd kernel via setup_data or
> devicetree is unnecessary.
>
> Add a check in kho_fill_kimage() and return early if preserve_context is
> set, to avoid passing KHO state during context-preserving kexecs.
>
> Fixes: 3bdecc3c93f9 ("kexec: add KHO support to kexec file loads")
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

