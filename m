Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D0FBCA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 13:37:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AA6990006E; Wed, 13 Aug 2025 09:37:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25AD1900044; Wed, 13 Aug 2025 09:37:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 122AA90006E; Wed, 13 Aug 2025 09:37:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 026B6900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:37:17 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 81D34116F26
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:37:16 +0000 (UTC)
X-FDA: 83771835672.28.90C7C53
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf25.hostedemail.com (Postfix) with ESMTP id D8A8CA000E
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:37:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pm1jF1Lj;
	spf=pass (imf25.hostedemail.com: domain of pratyush@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755092234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9NMBaOBP8m6+GUpePeD0f+lJdO4gRXI0CxUK+W2rtKI=;
	b=Ul7FWrQlOIprPM3mqedMdi+zKzWMLrZDxgKEuEZfi7zgkegLsw0hkCegPQrYkEhpkz+8u+
	bEg5ZsaxzYkN7VUxX2NKrwBvmAY0kYPdiPsAzf+G4liipGiQx/rnq4Fb3FwOsq1IHwvQ/Y
	Mj3E0k87XLohfX+wPVC0DJWMT7AzHGI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755092234; a=rsa-sha256;
	cv=none;
	b=sOxZbaE551wK4O2DWu7RsTdxEHBmcgiRykUDEuk7o0gxay4wn5KbBLvmyGu3mPUxMcPjkf
	M2K4on43IQpydwNtj5zLkFv6DDrJ4IhB+6trD7e2PALC3p0QMd/JBB0Fxn+X72EexSGwWi
	7FbEZSQN6MWQ0ddLZVXv8G9uQ3f3aLo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pm1jF1Lj;
	spf=pass (imf25.hostedemail.com: domain of pratyush@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 05D57A57C80;
	Wed, 13 Aug 2025 13:37:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F89C4CEEB;
	Wed, 13 Aug 2025 13:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755092233;
	bh=gKvz2MC5wozp0txCtJXl7kNfS6x4R8q1KKyu7d5k0DY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Pm1jF1Ljm5T+6BOOZNpYAiyUBhA6jrJJ3DRvXghpATFhZq9GKA5j1j8Xl9om6Mvqd
	 pfb6YVvFxGbv9PYSjK3q5G96TXeo13NOsZZUcX4p7BOHPPWqewIaajNssSIIJq67Ir
	 xfAz6+V7B0aTsEcI3pSfGZBQt5DjXUcnHfEh22WdBQkwWMnVlBIrcbQjMhPFgaUYB6
	 +kXK07xwObo+yLiDzPd/6jG/pDA9bkPmsMRnuHEkIUSaR5V081dJnNqOCzoK22kD1K
	 S3FF/GtK8QX6tTieEmA3XosMZYGA78RfsgeODd3LX+itirXiSMrsG7A+4N9RcdACEg
	 oreSW4Z88W6PQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>,  Pratyush Yadav <pratyush@kernel.org>,
  Vipin Sharma <vipinsh@google.com>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  jasonmiu@google.com,  graf@amazon.com,
  changyuanl@google.com,  rppt@kernel.org,  dmatlack@google.com,
  rientjes@google.com,  corbet@lwn.net,  rdunlap@infradead.org,
  ilpo.jarvinen@linux.intel.com,  kanie@linux.alibaba.com,
  ojeda@kernel.org,  aliceryhl@google.com,  masahiroy@kernel.org,
  akpm@linux-foundation.org,  tj@kernel.org,  yoann.congal@smile.fr,
  mmaurer@google.com,  roman.gushchin@linux.dev,  chenridong@huawei.com,
  axboe@kernel.dk,  mark.rutland@arm.com,  jannh@google.com,
  vincent.guittot@linaro.org,  hannes@cmpxchg.org,
  dan.j.williams@intel.com,  david@redhat.com,  joel.granados@kernel.org,
  rostedt@goodmis.org,  anna.schumaker@oracle.com,  song@kernel.org,
  zhangguopeng@kylinos.cn,  linux@weissschuh.net,
  linux-kernel@vger.kernel.org,  linux-doc@vger.kernel.org,
  linux-mm@kvack.org,  tglx@linutronix.de,  mingo@redhat.com,
  bp@alien8.de,  dave.hansen@linux.intel.com,  x86@kernel.org,
  hpa@zytor.com,  rafael@kernel.org,  dakr@kernel.org,
  bartosz.golaszewski@linaro.org,  cw00.choi@samsung.com,
  myungjoo.ham@samsung.com,  yesanishhere@gmail.com,
  Jonathan.Cameron@huawei.com,  quic_zijuhu@quicinc.com,
  aleksander.lobakin@intel.com,  ira.weiny@intel.com,
  andriy.shevchenko@linux.intel.com,  leon@kernel.org,  lukas@wunner.de,
  bhelgaas@google.com,  wagi@kernel.org,  djeffery@redhat.com,
  stuart.w.hayes@gmail.com,  lennart@poettering.net,  brauner@kernel.org,
  linux-api@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  saeedm@nvidia.com,  ajayachandra@nvidia.com,  parav@nvidia.com,
  leonro@nvidia.com,  witu@nvidia.com
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
In-Reply-To: <2025081334-rotten-visible-517a@gregkh>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
	<20250807014442.3829950-30-pasha.tatashin@soleen.com>
	<20250813063407.GA3182745.vipinsh@google.com>
	<2025081310-custodian-ashamed-3104@gregkh> <mafs01ppfxwe8.fsf@kernel.org>
	<2025081351-tinsel-sprinkler-af77@gregkh>
	<20250813124140.GA699432@nvidia.com>
	<2025081334-rotten-visible-517a@gregkh>
Date: Wed, 13 Aug 2025 15:37:03 +0200
Message-ID: <mafs07bz7wdfk.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D8A8CA000E
X-Stat-Signature: mmajzhy9fwiaxjj5u5wwgrgmmoccq9zu
X-HE-Tag: 1755092234-649854
X-HE-Meta: U2FsdGVkX18IR24vaN7b475fJeG9INaDZWV/kqeFvg3Y90bhn78Uq7VftXKH2ngX8y+igvaIF3jx4AybVT1m8Wt3GQqMjjhulFBhFNk1nX+YS6ofnWm4qL0T6tzruJfSWxvQT5dagd+4QjXZBEWrNDWPdzNAanxwdKChkVQ/EBOfhbZaibqDjPZloIsRefxMbYrqauk+Yc0muEUOX0FTxvQm022uTywnRviRIYtTEtlJc+KOJ3F6e3S5B1gFPffwo2uaa3z39Tje12AXrynkEex7mifV0Knue5COXpUJp/+xFBKGKTf47VCx6AujoIDbXgqh+FHvg5ofv7ph1BIMZsmaowlHAnUY3cTrND+ORusRF4uD6JuioidYjwnD87nh9kKcoSBeRR2DFMdoo1HLo9VqT1RxGOF8XJrps+GO6E61eDR09d6YWQoqidCI4l3kjr7p6lYoAJXqJ+VUkdW0GFAsfcinuCQaeV/H19g6ro8s8a5l6M36U13aUGCUmqmGWX8AyXVen8qXs50fFsCntvCV8N6q1LSoj7pwbJhN4xv5bc3BjP+pQleksJEiNOTiZEI/tore3HpxBR/R9YnebA0C16N4/UGVkpDHZD5K5VaOZYt1LwLP0+tLXQu1RFjkGN7jNjUwjTarHvtB0kbAHkGXBkodpJvX9cTDGNVdfFLogJ+pbKLLLb7KSNWpyUElartPLD4m+7v1GrVBKD8KvX/uSDZsNrdGi0LaZ4Yp0Zu1oT4ujJKDeONjSEgV05VQfGscXhHiJUPbHIBcuE6sMq5xAZ8oDgTLVOmp32ZMWPJlBuShYRL4Ftoz8cgvGhJZTklgKYY67GtaGqhUGUCCnwSHwmDgataOArPQCdjdASaKJCzNnEAfbsWjAMyPUaiyPklo7lQpzGYRz91RmFzyMRC4EURNcarm1HwLqHB6D4msjACvgGgHPH4mWY4CpBtF9qg58fmU016Xr+Wuz1Q
 ToigS0o4
 uDT1ubeWYawLuRVP/uGMpG7obKjHTrv4P9u3siaXwHdoldbD9hlp5fo6nDkbY9hFLNZpoA7rl8w1l1o0G9B7vfqiG8FqY063iLFQN1iEnguTbJuGFHOJq41tlBwhgxV/0S3JoiYwLMpXT+erpo1VLx2YAtNJQSlazQmD79cRPy6p3kfRGo9bOLhqk56YNMo1PMnFe18Yo1fX4s54vEWvwC+16Mbo3ntuMjVkWnOD3tyOGfvI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13 2025, Greg KH wrote:

> On Wed, Aug 13, 2025 at 09:41:40AM -0300, Jason Gunthorpe wrote:
[...]
>> Use the warn ons. Make sure they can't be triggered by userspace. Use
>> them to detect corruption/malfunction in the kernel.
>> 
>> In this case if kho_unpreserve_folio() fails in this call chain it
>> means some error unwind is wrongly happening out of sequence, and we
>> are now forced to leak memory. Unwind is not something that userspace
>> should be controlling, so of course we want a WARN_ON here.
>
> "should be" is the key here.  And it's not obvious from this patch if
> that's true or not, which is why I mentioned it.
>
> I will keep bringing this up, given the HUGE number of CVEs I keep
> assigning each week for when userspace hits WARN_ON() calls until that
> flow starts to die out either because we don't keep adding new calls, OR
> we finally fix them all.  Both would be good...

Out of curiosity, why is hitting a WARN_ON() considered a vulnerability?
I'd guess one reason is overwhelming system console which can cause a
denial of service, but what about WARN_ON_ONCE() or WARN_RATELIMIT()?

-- 
Regards,
Pratyush Yadav

