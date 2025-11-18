Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D23A4CEE345
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 17:43:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 168536B00A5; Tue, 18 Nov 2025 12:43:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 119116B00A6; Tue, 18 Nov 2025 12:43:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F22A06B00A8; Tue, 18 Nov 2025 12:43:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF8736B00A5
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 12:43:30 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 72AA855EFD
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 17:43:30 +0000 (UTC)
X-FDA: 84124449780.10.35B0162
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id C089C1C0015
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 17:43:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RoZhDf71;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763487808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=khPJHfK5uipxqya76ZF76gttJvaXVYIxPf5ciYaNZSw=;
	b=0KRUo78f3MzVqpxPtB1xWpNxCugWFMOnykiREM68FMvgyn0cBEavc/ubQzvzvxnyfIYvN7
	F48oz4gLQbZKDJXmvAm9is3aSM+7IMLD4/YFFSn1epErGRL2NOZdIk4uspjXNq62RCWS4y
	YI/avONCbWlqZNcrE++XWui1K/ErTfQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RoZhDf71;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763487808; a=rsa-sha256;
	cv=none;
	b=WZHRZKe5NC+XSmKGboBXVLSm3sVHJIRfuoP32M+ytnC2Xn69bMDyob+rDPTV/8pzNukgHJ
	8CO7/v4WqFLXzoT8KPPcG9jL//KXZGJo25+HcPYBfjMw+xDF80tz1i8Q5y0lbYecuNhgzA
	VaGjVTDvN68ucPuH6Z62D1OUcdQIi8Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DF33A605F5;
	Tue, 18 Nov 2025 17:43:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95577C4CEF5;
	Tue, 18 Nov 2025 17:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763487807;
	bh=1palvEhA7lxPgWRw7JBg2nk+PwUYpMtYYMp2Y2Eh+EI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=RoZhDf71xqImZXulbvoIjZ7yAzxYD/AcTLI06tLkcrHJGhS3n1wuCOf9wx4CJeqaH
	 TcKaUflrQT4qrs3oIwoEEi619q9+Fi592cRC2H7+B2Yb6e3kiI9VcpxOawkpwyO3Yi
	 rbm4faU2dCL+7GC4WWBY8oG635z1gnunufw3vIiV0KuNvYm+cTKmQ9rhDHQgFR6dph
	 hdAL2UoAcdeSJmuaJqhSf898zpIbBTLwKGntsdMpz9Ugl4isTI1G9TJcUmowA2cd8U
	 zZPkIerB9kg8IBClw5+1dSHyURuVzrsqFmqfVuupgNrgHQBcyYcWg2FA+fH79majJ9
	 jDsELXhpb/0mw==
From: Pratyush Yadav <pratyush@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  pratyush@kernel.org,
  jasonmiu@google.com,  graf@amazon.com,  rppt@kernel.org,
  rientjes@google.com,  corbet@lwn.net,  rdunlap@infradead.org,
  ilpo.jarvinen@linux.intel.com,  kanie@linux.alibaba.com,
  ojeda@kernel.org,  aliceryhl@google.com,  masahiroy@kernel.org,
  akpm@linux-foundation.org,  tj@kernel.org,  yoann.congal@smile.fr,
  mmaurer@google.com,  roman.gushchin@linux.dev,  chenridong@huawei.com,
  axboe@kernel.dk,  mark.rutland@arm.com,  jannh@google.com,
  vincent.guittot@linaro.org,  hannes@cmpxchg.org,
  dan.j.williams@intel.com,  david@redhat.com,  joel.granados@kernel.org,
  rostedt@goodmis.org,  anna.schumaker@oracle.com,  song@kernel.org,
  linux@weissschuh.net,  linux-kernel@vger.kernel.org,
  linux-doc@vger.kernel.org,  linux-mm@kvack.org,
  gregkh@linuxfoundation.org,  tglx@linutronix.de,  mingo@redhat.com,
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
  saeedm@nvidia.com,  ajayachandra@nvidia.com,  jgg@nvidia.com,
  parav@nvidia.com,  leonro@nvidia.com,  witu@nvidia.com,
  hughd@google.com,  skhawaja@google.com,  chrisl@kernel.org
Subject: Re: [PATCH v6 06/20] liveupdate: luo_file: implement file systems
 callbacks
In-Reply-To: <aRyvG308oNRVzuN7@google.com> (David Matlack's message of "Tue,
	18 Nov 2025 17:38:35 +0000")
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
	<20251115233409.768044-7-pasha.tatashin@soleen.com>
	<aRyvG308oNRVzuN7@google.com>
Date: Tue, 18 Nov 2025 18:43:12 +0100
Message-ID: <mafs05xb744pb.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: C089C1C0015
X-Stat-Signature: xzxkayqowxrzqa8n4tqmg7yq4c7nji4r
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763487808-918634
X-HE-Meta: U2FsdGVkX19+Mc/7oN/jRGf/lMQpQ0D99fj1tmfOixkslfGZnnEgL9qvrE2gtDSHY61K+JsN9mYT0r+m/6N3bpSAgh9M6NkVl2e3UJ1JibrCPeoXGScGIR1ucrKBMjF3ZJRXd2/A4XdwW6EMQs121vEG1uH0dDwdORMM57gb6WI/OVY3cJ9cl8sgYa146rrSWEcDLxRF6F97xT+FzjPi/WXUdFmg1+94aTFuL+oxDr6vtFDfQMEJ1dSezgH2S5Ug4vEPGDPkKqAkoIZeD/iK5sbrTD3BL5qN0wsV1ObidsU7ekvf3ZqtAxAbPX4assRfkDJTgNZPUyHLLuhZwKquemq9UlJd5T4e/quokNmEz6Vx0bu9rQoPZTYrMimM3XtuQXFcdycyQDGHF/2htjUFZeYVaLRnjfisdL6EKHLt569vcwJldozCcX45pk/3UPRaiJBvQYQsMMCKgpsqdZw1/fZG04Or2TalFBvmmSNtnM3fepdI2WJjbsXy7nGJL68hF/+nKQc36bHcjd/grMUMk6A99lwBTqZO10LveJAJxBWW2QVw1c41vBA0uDnF/kZ7ErpaGmRfn6Kvd42+McKIAfoJcnZF7+mkrcQPFgxjAPwpwOSnK2NohNBn78a8bPojekMXehUEyAenYoiQuPDxzK1dxOIeztKAPHRa01zJ+V0v3n+vIecnA8P4X7fJFBKR8nRqDcMPyjvxV9fFUoa+BPtbJln3sYLmVOjp2Y+ZCeqcMVoQM+gWvTYX1BKWwkJJtDZ3YLbnWO1LKdW+5xVA3goVMuT4nq+XkzRQin6h/N1jfQujlQPQiS4FLf0pIsse4OuCXgH8uiTP//N9drm9YBIynLjC4jvz19AcxJRLbCFeb9DCt54mztO4gy20gOJh5iOf73PeOi+rL0ompKc1J2kk1CQNKixxjeBFPIhQIBHN6G7ATRJEMEA67k9v2H4T1WQh1Bw3/LGFafatoJx
 15W0I6Bm
 +Y1brwkCjFdsdY/a4YEX+MrzRbEReAi3GBwDuQHvt09lNRHpvQyeTvvS0Y94g6r4l6gLH+KifyOrlgS889KGWGo3EKPvDx4VmCm3PUqFytLyt2LsfFnhd3QbGmE1oKw+41sctLhge5nrqZR5f0bTq5xcRVBePtYG91VujVPdtgEDzGbEvzSwJfr/+Gh27CIY4JNS52rXF7ZdsFdQC/+lFlxuwUVW2kyPDRboBsVNujtl1/ktp4wKqjLThuSZoIlBsr1a/4+csbLbHVEn27/KERDQxqbyDd8QDgzJ6Xhi2xEe2Tt/K16AA4tAIVOJzTijU+ki381rgmc2ZQfmcpQxiK8EN0wg6s8BIw4UC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18 2025, David Matlack wrote:

> On 2025-11-15 06:33 PM, Pasha Tatashin wrote:
>> This patch implements the core mechanism for managing preserved
>> files throughout the live update lifecycle. It provides the logic to
>> invoke the file handler callbacks (preserve, unpreserve, freeze,
>> unfreeze, retrieve, and finish) at the appropriate stages.
>> 
>> During the reboot phase, luo_file_freeze() serializes the final
>> metadata for each file (handler compatible string, token, and data
>> handle) into a memory region preserved by KHO. In the new kernel,
>> luo_file_deserialize() reconstructs the in-memory file list from this
>> data, preparing the session for retrieval.
>> 
>> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>
>> +int liveupdate_register_file_handler(struct liveupdate_file_handler *h);
>
> Should there be a way to unregister a file handler?
>
> If VFIO is built as module then I think it  would need to be able to
> unregister its file handler when the module is unloaded to avoid leaking
> pointers to its text in LUO.

Good point. We also need when using FLB. You would first do
liveupdate_register_file_handler(), and then do
liveupdate_register_flb(). If the latter fails, you would want to
unregister the file handler too.

-- 
Regards,
Pratyush Yadav

