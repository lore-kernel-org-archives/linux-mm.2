Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F871CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 12:02:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D3B8900062; Wed, 13 Aug 2025 08:02:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1847A900044; Wed, 13 Aug 2025 08:02:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C1BD900062; Wed, 13 Aug 2025 08:02:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F22DF900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 08:02:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A2E3416031B
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 12:02:20 +0000 (UTC)
X-FDA: 83771596440.25.ABE0DE7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1794D18000D
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 12:02:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dnfY5pRA;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755086539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xFVPxHfjxAgq9rfid4BWIQCkPmvWp6TVtox/+4BSMB0=;
	b=NCPjsIRmqvvVBae0cDSJfsplslPezuVabY+HBmJaoeJqIFRVV+aF5Vz5KoLdwhUdq27RrI
	JEwIDr6CkNeHC+wPuOBf/38RGgFb6EwR4jq3QQnX821WY/TSFqT9Sqt5zU2Zql6t2cuDbf
	afDf/x/QRWdYKdRzZvwSyZZ/oDI+RXI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dnfY5pRA;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755086539; a=rsa-sha256;
	cv=none;
	b=RRAl6iDuV6QbHZukeQJndmenNc/Ppcr/2KlH/g9DL1aZD/BVrsIuE/9aHAvM27Q7fiCvSn
	FLbYOK22BcUNQTX+RQ+jjkZaFhuyEJj2SduhAu/fu5+7uHd216T13+k6ryhHuvl+bfNWo+
	/4K4EJXPUuou0Lhe+AjVG6VUObQlP/Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 20307601DB;
	Wed, 13 Aug 2025 12:02:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC76EC4CEF7;
	Wed, 13 Aug 2025 12:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755086537;
	bh=2xrd0/GoUYp9e9PgBchb2nv0RPDgefUTlMhBngu3vas=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=dnfY5pRAIGrV1WNGoDYcWXmuVbKeJ+WGHuyKJSOYb0WR11KrcWMswcDa6njQ1BRXL
	 s7/bqbGvvZZRBV1zjeK2PNoR4QLlBDZpWjwMk2TSqqcxt05s82Hge6O51FtWov3Y0i
	 0pIabEjTiX0LpHmntrSA+leDJCveu03POPi2MdkewQIKlTV66P1ftiaNbfRstdbPz1
	 xlOnAwnBw6cy5PMhQryQAJiJ9vbEugKl1sCeF2QckqZRZ6JJF3GgNXvMbr7eP0yND8
	 9G5FstSlZHqd+f/eI6QaOVmB3tcLaRQwBCB1ikBMh5xdbz9ygUZoyZAnA8WulqYY3X
	 NGGCfKkcLxUng==
From: Pratyush Yadav <pratyush@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Vipin Sharma <vipinsh@google.com>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  pratyush@kernel.org,  jasonmiu@google.com,
  graf@amazon.com,  changyuanl@google.com,  rppt@kernel.org,
  dmatlack@google.com,  rientjes@google.com,  corbet@lwn.net,
  rdunlap@infradead.org,  ilpo.jarvinen@linux.intel.com,
  kanie@linux.alibaba.com,  ojeda@kernel.org,  aliceryhl@google.com,
  masahiroy@kernel.org,  akpm@linux-foundation.org,  tj@kernel.org,
  yoann.congal@smile.fr,  mmaurer@google.com,  roman.gushchin@linux.dev,
  chenridong@huawei.com,  axboe@kernel.dk,  mark.rutland@arm.com,
  jannh@google.com,  vincent.guittot@linaro.org,  hannes@cmpxchg.org,
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
  saeedm@nvidia.com,  ajayachandra@nvidia.com,  jgg@nvidia.com,
  parav@nvidia.com,  leonro@nvidia.com,  witu@nvidia.com
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
In-Reply-To: <2025081310-custodian-ashamed-3104@gregkh>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
	<20250807014442.3829950-30-pasha.tatashin@soleen.com>
	<20250813063407.GA3182745.vipinsh@google.com>
	<2025081310-custodian-ashamed-3104@gregkh>
Date: Wed, 13 Aug 2025 14:02:07 +0200
Message-ID: <mafs01ppfxwe8.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 1794D18000D
X-Rspam-User: 
X-Stat-Signature: 3ymxkqsa1m19ir5u9q7nykrjd1nr7amn
X-Rspamd-Server: rspam09
X-HE-Tag: 1755086538-819964
X-HE-Meta: U2FsdGVkX1988NdAdZ0Wgsts9KFiA73ijEJm1FQ3H6qYC06ZDE9+zt04nI7m0PbDuqyeDjA4O1d5ItGj4rESrLOuk9QHoGEowR0ow3A23VbXqFoxjXFVHf5yRsuBashHazHCeDzL6i+nFwE8M5UVACl0vdueQcj023Tvomm2ob4jsTQMOembJwR188529krUMDi6CVX0Rwoi9Gt0bHQ7NjEoEP0W+vdXq3CaF3zxCpzMgMKXVaboc9KSWvRBUXwuT9GT8UrFLRGT3zUbmwaQXJYQr0Rog3DO6vrr4bP56jA1Gazgs/qk/d4B1sKTzHwkMzCkuErmOP/FY+R3Zcx7tFwYwIMxLl3Ob2+9aJ1sYe+mDXYrOw0x8o2lMZrgonz68aCZvji+9z/tFzPN712DhKF43UiFrQ8ZUr/RXO8POKToqnD6nOjXRxjTgyKI8w7Dd4MOyu/GCZWyssQ2qGyovGgoMoCJmclC7jH3LTuP6emqFKYjGxMfek7FYJV23mRqp34NEDJ4+QH9i4JgTuEuLamOc7r0eQyJ7wiD8UXlFy5qV3tPHhA+Z9QaYVuFRt6jtiQStAMkwBuwGLySJFyfL/M00Xc91zBbWvN/ErXiddppvO3d45XJCNU7RdXu5j9wynPze5KcFbfol9lt5gSjQGjIaFsmaXvXM4UeOJXLjnPVvL7bdsoXVyzucs6Hle0nf5v80xjvKh4Qcgh6kC6blZ5J9eUyprW3aU17T4jgLzID5U1gIGhGWPRAWy6THwzNIDNKNXlePofkOUnZRxmumOuLlplMW4FuwT5GQsIwV0FUwG1f7kFc2zM8mzj3nBacaz5YhEOdOpWnOBjkYR2c/vrmxlrwJqP50x3sUcHKl9ozx/ZHHTQAIrOAiMVpHKFtHtMFCpOobUnD7DrmCzkv7homdCUNcfm15jtYgnoRiOATTc6800rSx6ezsRflnvhKGtblb/bE28OrkjzwbPq
 ePJXOlXh
 fcalulQI1BA/nFMS8NzM3f15ZZHsRVODgw9gFIA8QQCHe5yNcoTGKhQ8KGtwtrWaxIh6vAuEiwfewn3Oiq681vdJHdUMPn63dcLNhRJhBI3kj5qZbA/pEif/O7YsufEbgPzN2gDF6G6OR5GgusrIiEfL7eYzPHN68FrqK99hMJVhFejiRmCmUpHJhuBOqtKNHhkJpORnaNbxLfRqP1PV5m3wF+F1+ppT11iyBFKp1OmIAz58=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13 2025, Greg KH wrote:

> On Tue, Aug 12, 2025 at 11:34:37PM -0700, Vipin Sharma wrote:
>> On 2025-08-07 01:44:35, Pasha Tatashin wrote:
>> > From: Pratyush Yadav <ptyadav@amazon.de>
>> > +static void memfd_luo_unpreserve_folios(const struct memfd_luo_preserved_folio *pfolios,
>> > +					unsigned int nr_folios)
>> > +{
>> > +	unsigned int i;
>> > +
>> > +	for (i = 0; i < nr_folios; i++) {
>> > +		const struct memfd_luo_preserved_folio *pfolio = &pfolios[i];
>> > +		struct folio *folio;
>> > +
>> > +		if (!pfolio->foliodesc)
>> > +			continue;
>> > +
>> > +		folio = pfn_folio(PRESERVED_FOLIO_PFN(pfolio->foliodesc));
>> > +
>> > +		kho_unpreserve_folio(folio);
>> 
>> This one is missing WARN_ON_ONCE() similar to the one in
>> memfd_luo_preserve_folios().
>
> So you really want to cause a machine to reboot and get a CVE issued for
> this, if it could be triggered?  That's bold :)
>
> Please don't.  If that can happen, handle the issue and move on, don't
> crash boxes.

Why would a WARN() crash the machine? That is what BUG() does, not
WARN().

-- 
Regards,
Pratyush Yadav

