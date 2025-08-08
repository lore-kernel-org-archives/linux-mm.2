Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A6B2C87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 11:48:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD2246B008C; Fri,  8 Aug 2025 07:48:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D82936B0093; Fri,  8 Aug 2025 07:48:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C71916B0095; Fri,  8 Aug 2025 07:48:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B742E6B008C
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 07:48:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 78E7F56612
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 11:48:17 +0000 (UTC)
X-FDA: 83753417034.23.B413831
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf13.hostedemail.com (Postfix) with ESMTP id EA08420010
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 11:48:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kwuuhoIs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754653696; a=rsa-sha256;
	cv=none;
	b=Lb/odOAFKQ8NzdkEh2njR4Fvj0NYVzGP6MXuI7WgbdZr2sfnSESuYug2ukd7Tv2APuJYrt
	E76sf6wsj92t5V/JTsvU7/SKkmqlkH/6fuF1sBtnzJmmK2d9QliniycPvbmcQr5Rpg8r+c
	DoVtC/FtcqyW5tjZDJsS8f1WW0eJSgE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kwuuhoIs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754653696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=is4G27V5j83+vEcZiSx++2lixck9qSApbZwMfbXwkEg=;
	b=VHoT1BWxp67AT02uyhObsEEtiKUrgqaehZsPv6jFO3cby4rgslzuToWPqZW544jL3LDAgf
	jd1zhvnbsXsu9Rz6JgKyPkj5tLRVwtoVmDz92vGv/vOaQ9AwfWiGI+GsIHmYRKNfmq/vRh
	ghoVJVZBJDC6ZIl8q8kclOGEuko2KdI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 1F6DC5C6601;
	Fri,  8 Aug 2025 11:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E4FC4CEED;
	Fri,  8 Aug 2025 11:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754653694;
	bh=aUwwLEPyMUejn/6j3TbLyJ9dkoIcB9PsgLXsaIIn2ck=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=kwuuhoIsntxmMvjULGKR+fbMO5OmUIAC8z6hh0qq/hfqifRrQZ9ZNp0VHDryFvo3p
	 Qaq986CkXgUCTmb1mavmiVcYwmoccQ/gwYcU1D09Uo6dbHfBeYqfdFknzMyllRlIyG
	 q45GYr0i5+IW5iitggvfthDfgHoTwFBdodG55fDOdLOqkYNY1Gytqv/e9rQF2H1KUC
	 rmMQwedbpyQydNhu7AkKxqo+WmXcl3I1f3h2q1q+jkqE4YewtLwtymcRJbJr541aBA
	 +FNFurbzmb74Oe74otpLpOPjfDt0vgmbUznCo99XBgeVLrDa4og84ZtpljqbzEm/bi
	 66xOz7BE/D+ZA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org,  jasonmiu@google.com,  graf@amazon.com,
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
  linux-mm@kvack.org,  gregkh@linuxfoundation.org,  tglx@linutronix.de,
  mingo@redhat.com,  bp@alien8.de,  dave.hansen@linux.intel.com,
  x86@kernel.org,  hpa@zytor.com,  rafael@kernel.org,  dakr@kernel.org,
  bartosz.golaszewski@linaro.org,  cw00.choi@samsung.com,
  myungjoo.ham@samsung.com,  yesanishhere@gmail.com,
  Jonathan.Cameron@huawei.com,  quic_zijuhu@quicinc.com,
  aleksander.lobakin@intel.com,  ira.weiny@intel.com,
  andriy.shevchenko@linux.intel.com,  leon@kernel.org,  lukas@wunner.de,
  bhelgaas@google.com,  wagi@kernel.org,  djeffery@redhat.com,
  stuart.w.hayes@gmail.com,  lennart@poettering.net,  brauner@kernel.org,
  linux-api@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  saeedm@nvidia.com,  ajayachandra@nvidia.com,  jgg@nvidia.com,
  parav@nvidia.com,  leonro@nvidia.com,  witu@nvidia.com
Subject: Re: [PATCH v3 03/30] kho: warn if KHO is disabled due to an error
In-Reply-To: <20250807014442.3829950-4-pasha.tatashin@soleen.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
	<20250807014442.3829950-4-pasha.tatashin@soleen.com>
Date: Fri, 08 Aug 2025 13:48:04 +0200
Message-ID: <mafs0fre2avbf.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: EA08420010
X-Stat-Signature: 3wanrsrmk8g15exzd1gdeocfcf9mq4yk
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754653695-679899
X-HE-Meta: U2FsdGVkX18gn/GaqyaqVLRJ+aIrBDMRZmk2aA9VflHEiIHWCOuCSHq6SFsKB5Eo4/KmmMQcUMTOE/LhUR7agMdP2JLoPy5JCYBH/iRawqSzpT7T2yHkg2hHlqKm95D/KOOLh7iXJ6yjABkU/XeDNVLMZ8AP4BuB0fyxBATg1wkP7MgigqAW4TlFH6I6lt2ostpadKauBG0cHDu6mFChuZvX+Rr7wjl5sNJIXfIzkBk5YJenvhqxtXsD+9aXki54tWyQwXnuykuj62T7PuSEoCC6/EMCswz3lNE22sbDr8TF0wCzEIMipMb/9aCsYZwNEmo76Wn37Ybs6qfjKTJLvQJzrD3TJjnYtzb7pkb/Hg1fcrqVHXaIh6CUYQ1Pysiq00ocz12eNBNs9j7///qPbXIXAcHcVINLR5+75NKRaBiRSjxrlan0OctgY1BnE17/XFZg6fCWh36i8YTZTTv4YkcUAx+bXl2SvmhG89nrv/zwwJ3GPeYDN659pWWdCfGZBUwAxzEDdNnFM2/A81cEa9wnzWL9TMmJkOkdeP2k2T12jFxE71ufImL9s+lrmgXbfA7+5bdnLbUctkWo2kT3LY3ijm47ZExynsgXLz5MSoTp8cIL4P80J2j3mjwpufUKwlNV2LNUJMklzugXuuVTKxBnaSj6wQBeYgSoYmqfFvHtq3CHAPDTgAedhTQzivsK2BqQs364L3KL4BvO7g6NKFqcbMVU8Zs+4Rm23y7fabMl/fjgmEd1DLWDGHPH0SXea+jiDnV5gf9NUnzOo/oFvq8w6ecGkr8uLy+rkok/5qiGGYvztUnkSnEKYgQYYxJ2NGUHbRpZmkHz28dgPcB99J8dg4qTaojuqJNMebl+RuwNGH3GimGNFz3eLntwbO91aC+jmMs+VsQqpmxXWDyL062GkqDHmPoKnnJz64ECAxahU/iq0zHixGf+tfPaGtWGXSYUMbSDMSYU+S9bRMb
 0vA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07 2025, Pasha Tatashin wrote:

> During boot scratch area is allocated based on command line
> parameters or auto calculated. However, scratch area may fail
> to allocate, and in that case KHO is disabled. Currently,
> no warning is printed that KHO is disabled, which makes it
> confusing for the end user to figure out why KHO is not
> available. Add the missing warning message.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: Pratyush Yadav <pratyush@kernel.org>

-- 
Regards,
Pratyush Yadav

