Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ED41CD8CA4
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 17:00:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE3698E0010; Thu, 13 Nov 2025 12:00:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBACD8E0002; Thu, 13 Nov 2025 12:00:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFD848E0010; Thu, 13 Nov 2025 12:00:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC0238E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 12:00:05 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 601C4140AE4
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 17:00:05 +0000 (UTC)
X-FDA: 84106196370.18.9C64ACD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id A1AE61C000C
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 17:00:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GKpbgHVA;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763053203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2wFaJr+fYwPEZ0nwa+8p1GgzdG3z9ueL5OmkW1TZjQo=;
	b=yap6NIWgKJ7zLgTKciJyRv8vSEG/FAsKmoVBOKcL9EwepKAxGLzbO4xLS0QVLKNOMqFh9l
	lRkn9swf4XZQxw4rwp2aim2h73inPv5ulPSeoYqUWK8Nja5D21bfbTL3S7BhS/cSW1vB3U
	CSD2meHLTzpwc2+7JnN5lDsWDqwV5A0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GKpbgHVA;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763053203; a=rsa-sha256;
	cv=none;
	b=ckiwa5yDjV26gUGORqbQI3N+STsYepCh/Xs671vfajHOWrxbj3zfc0YfSzfqcJ/A7bc8/R
	SO9olrPLE5avP9tFdRD3T/n65bOVHHzwzEoCzC3Y1efFwoKHDmR5WjHzsvQKZ0GNn/Bk9t
	ITETf89v+4Q3GtYKzVDzFy30CxA7gag=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3544043CD6;
	Thu, 13 Nov 2025 17:00:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7DAC4CEF5;
	Thu, 13 Nov 2025 16:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763053202;
	bh=OBpr4OfEynmd3QPtz7HpqQa1JuoHzfmsOcTyDkjnDvg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=GKpbgHVAB96CTF2QAU6gGXB9xyAtOYn7EP9js0Mycon0OeXhF2jqHHtX89c5XmG3n
	 aI+GsuLi5aWWIqQuOeufUD4aA/2oqU4CL3hOKgWLJISLTlCDKD2fvEzTYvo+4axv1Y
	 RMC80Z36Upuv7S76Aj7akkAJYpehDBHHl02KtLD9+owbFDV5HjZtX2uU4oNhmImcTZ
	 TB6NozxahkQlkcbHdVJIiuprn3ewx0G92tYj/3ivDFDMjJkdV5nEmpt/dhUVJduyaG
	 M6PpSxx1REjCjMlgwB+uTMHEl+k2ror8Zzap/3OLPhR5zcZpm4wrMVCWSYXfzyE61t
	 +lyMXl3tACR7w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org,  jasonmiu@google.com,  graf@amazon.com,
  rppt@kernel.org,  dmatlack@google.com,  rientjes@google.com,
  corbet@lwn.net,  rdunlap@infradead.org,  ilpo.jarvinen@linux.intel.com,
  kanie@linux.alibaba.com,  ojeda@kernel.org,  aliceryhl@google.com,
  masahiroy@kernel.org,  akpm@linux-foundation.org,  tj@kernel.org,
  yoann.congal@smile.fr,  mmaurer@google.com,  roman.gushchin@linux.dev,
  chenridong@huawei.com,  axboe@kernel.dk,  mark.rutland@arm.com,
  jannh@google.com,  vincent.guittot@linaro.org,  hannes@cmpxchg.org,
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
  parav@nvidia.com,  leonro@nvidia.com,  witu@nvidia.com,
  hughd@google.com,  skhawaja@google.com,  chrisl@kernel.org
Subject: Re: [PATCH v5 18/22] docs: add documentation for memfd preservation
 via LUO
In-Reply-To: <CA+CK2bBmSD_YftJ-9w1zidLz2=a4NynnLz_gLPsScF145bu5dQ@mail.gmail.com>
	(Pasha Tatashin's message of "Thu, 13 Nov 2025 11:55:25 -0500")
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
	<20251107210526.257742-19-pasha.tatashin@soleen.com>
	<CA+CK2bBmSD_YftJ-9w1zidLz2=a4NynnLz_gLPsScF145bu5dQ@mail.gmail.com>
Date: Thu, 13 Nov 2025 17:59:51 +0100
Message-ID: <mafs01pm1amwo.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A1AE61C000C
X-Stat-Signature: ce78cnd7hx1ndt673oqwu6qemy4k6x5x
X-Rspam-User: 
X-HE-Tag: 1763053203-283707
X-HE-Meta: U2FsdGVkX193LxNoirmPExEEI4CMjdr/vH+2eISm/RlDprLNbNgSvBtPJoDlwh7dCb8+iuiws1LRtE+hn2sdEcFX9oRCGXsuuz/pgn5k0tdN/mzQxoBAFKGxk/UW73vKyRBng2G4+cgrtQVaDwxJMTXgmQR76rA3L6fm+GOdBR+lzHWuTEzD/MT3iaKLSwi2q0odvDCCSwREP9RHhsjAgooPWQFUzufpSMzABqKaQhNohde3Kf8Zzh5g4MTF6crbX+KMPHfjjHhg7zE9i3R994UbC7zhCBtfMM+QFtaGOGbHNqW2RLboMvz5Zf28y4pPb/D3kNYynuJK9zVGQADO42yMNK53T48wB/IvVY/gIpfm2ynsOLElWpX4ciuOZaCY7dDY4I6ypVCch4Aigj2sXnjpRWzu+w0Pt93f6kRv1Jr99xhKWUvbOpzCZKm4U9mSsuTDZTFALN35PorQiz0PMhRyS1rrsAdigqbJqo2BFXYrEcbt5yA9gkgCABeR87V4GuP4bnmCYC9G1f81rh9rqIjBPhJHX4v07oXTFuy+3jdcIcoSXIB+LwjAOlnertt7WAJJhNi5RGIVsnjK4kdStgQDYXOfAkS6KpYnbkpRSC0+6V9x0jU/azVi7/w1fyUYC0lUtjhj1ABRZsNr1Wymruj1/i4KGDpKsTErGqFrz6+cfFfKbR4waU6WcPI4mtCixRiTwTGeSBV3d7ycVg+munEkvWPoVublQGyt7W50Yu2sHB1bZCZ9rWmceMOl6a5KCD4CwEAxxoG8JBVtgyN6jrwbCgqwmWEFf6x7434YOoCRj6awanlPprnKFdZu1zz/UUc45vnHMItvOTeFgJ/ZiRY2xSM+uxNL3teOQgq1tlo0C5c/DO9IZmYbWe4wRVMyuOXkIJbmOPd0pl9WqW1ygFU1gpe0ygLo0LrDo+/t94GaLMaFSgZMbrY7k2BVoPM2uutWlN4YdI01aDcGD0Y
 into0hhB
 JsWD3t+aOmTx4fvHPITXsOPrcOwzp15shZEmJuzKwCNKMSjAHa8OjGL11xpbZ8mFwl+WX0wNbDchI33mAyaVxmVmLYC6UFjk9VplAUh+g2Y32lh6BggFd0SJcR9L34BWXhhw5gces/k/Qq5K8Wd0YfQ4Ch3avO0bpb4cZO7pd0MOomPHHNdaFwWAlDtvDDHQT/B+D/PddEzVH4ZZNCbFuAH2WYPkvPXCmLEuaAEkoIXC/rdY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13 2025, Pasha Tatashin wrote:

>> +Limitations
>> +===========
>> +
>> +The current implementation has the following limitations:
>> +
>> +Size
>> +  Currently the size of the file is limited by the size of the FDT. The FDT can
>> +  be at of most ``MAX_PAGE_ORDER`` order. By default this is 4 MiB with 4K
>> +  pages. Each page in the file is tracked using 16 bytes. This limits the
>> +  maximum size of the file to 1 GiB.
>
> The above should be removed, as we are using KHO vmalloc that resolves
> this limitation. Pratyush, I suggest for v6 let's move memfd
> documnetation right into the code: memfd_luo.c and
> liveupdate/abi/memfd.h, and source it from there.

ACK. I think the section on behavior in different phases is also out of
date now, and the serialization format too. The format is more
accurately defined in include/linux/liveupdate/abi/memfd.h. So this
documentation needs an overhaul.

I don't mind moving it to the code and including it in the HTML docs via
kernel-doc. Will do that for the next revision.

>
> Keeping documentation with the code helps reduce code/doc divergence.
>
> Pasha

-- 
Regards,
Pratyush Yadav

