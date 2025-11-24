Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 394BACFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 15:18:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 935436B0028; Mon, 24 Nov 2025 10:18:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90CEF6B002A; Mon, 24 Nov 2025 10:18:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 849686B002B; Mon, 24 Nov 2025 10:18:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 71AF36B0028
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:18:46 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3207B1403E1
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:18:46 +0000 (UTC)
X-FDA: 84145857852.11.23C69E0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9E63F4000A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:18:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u2liEfUn;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763997524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PRPIXdih8k6b+GWhTjSlpe/wu57YRmAOXyA7GndW1VU=;
	b=Okcx6455/Uz4gIyB++a7csTYsx3MCwTO0r2RHiWVMosUJupCor4JpGE12wVle9Tv+l9GqO
	SgrHNYmnq0gZeU4hxQThWLJK+3zWrUXNXy6SjgL+EgdUh5U9hgOHWI6xH9QTujFqOnTEMr
	J+cdL7GT4BhP9ikpLgFszzYfcoeEaY4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u2liEfUn;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763997524; a=rsa-sha256;
	cv=none;
	b=lQAIMNAilMB5GIp8s8kIE2uYQ0j1uoR8E4so4TiRCQbQNDqqpP2sEVBg6hfkL/wUZITfM5
	4beK1pGu4CvH0FpCArcrCgKVzsmhrJYICxhs+b0m95bZ136lO+FV88PoXBIxGarrWRrh/k
	S3ymeTpvaUekN1SNzHB45xxd+yrrkCY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0208A60051;
	Mon, 24 Nov 2025 15:18:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACCFC4CEF1;
	Mon, 24 Nov 2025 15:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763997523;
	bh=vdaVyZMAiIluQBulvS0o8xmpluVa2GUlqU3Na3bO7RM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=u2liEfUnaoAHwjJ2YtNML+mD+vnHhy8eX+Pr8pZMLZwwnqMe2KGe36hyrljDmxttb
	 ekftnjQgkCblI1/2l/fw/F/M1Bs01N2Roen+57dPUoQIlseF46svsdt+BmoyjgTKfO
	 IKeFOzfpR4BT7NGIvmVhKQf6DtKYV5w/8Z8MG8tJLhGMGzOuUPS3vLNNvRDG/zxghZ
	 GtJVgrl+25KN4uKX9BfqaCnUogie2T522IK6RG/GWtDuhSNTmYBcGcQjyIjUtFS0/H
	 r8omuK+D/KcKRTpre8t9ovp3/owsEN1zmTzR++WEpxZGZzW+kVFAgfZYjPjCJMv4gX
	 grd/9IJVkNw8Q==
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
Subject: Re: [PATCH v7 09/22] MAINTAINERS: add liveupdate entry
In-Reply-To: <20251122222351.1059049-10-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Sat, 22 Nov 2025 17:23:36 -0500")
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
	<20251122222351.1059049-10-pasha.tatashin@soleen.com>
Date: Mon, 24 Nov 2025 16:18:33 +0100
Message-ID: <mafs0y0nvxxva.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 9E63F4000A
X-Stat-Signature: jeqnjquxgzzukepgqf6dniqbar8uctsw
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763997524-151928
X-HE-Meta: U2FsdGVkX19fOI56x6wLGitgiZ2Y3nCuUGLJaEoY7yZBysafugxP8WswJxjWZR1l71w29exzrR97dM5p3oNPL/smS2H69hVSJFnJ3XzgZ5VrfJRpx/Mi1FY2gvchwHOnQgZ7qQF9k5WI29b2utMx+lkMPhPCzXlEcEBwarCvHTVKd7NoCProlKN6S5pFLFbnSkv878bMHoBaQqaecIMy0BUBXrewPwAzkDsbOXCkTesPgqFEoPcWFfnet1+6/IUHv9YPhnBLjMNjZrPdNTvHbhNE9Ml5LoeUAQqnH3WAaSOiP7OW/j4tKp27RrUE3kxDF3hnG1WFLPVmU91aowb4K4bIy2phBSaHh+9Y5XizW9fV4WXhcY5zx1MqzjifFW1xNv1vz12UKSZlOPrwkVNduo9PLeELduPc1JcGAGumzL4FAjDEG8m4wMF04RNtgyvtsnHoqdFu1eyZksFq2bWnr4/vLbz2MhbKrnKvdHPa1EKBuQ6wEC5PReUPf5k5ewitonYnucci5ofeB+dxi6DHZkynasxrXooMkAZO2Y62TifkAcx0AEIDdMRwq3JDPYLVapNjEKtNBTJnOE/YzQAJ4ECbDJ3UueoU0Yu/MVssjWV35P6YV/yn6YQE6/qaoElQ5xUooXkZ6ylJpCyaaH5XyHy0czLwLMOVwzKWhy7PQUNOIWIgDwCiD6Ld2+nAvAUZB2Sn4+DKR0GAMOYjKdNV1DieSKZVGyjW4lSKlAP3KepYBhfMWYBK1Q8nrvakylU6u8yhIacB1Ucak9FROQ9Ht3t98HnprDC0o1KozERyB82tp1mLlU/pTZjdswwrP7Pwi2NKrka1URm7e3Z4ez4HS5NamMk/ItY1N5AGrVwYIP7nUMBwNsJghFIP5QHll5+MzN3ZtUpG/6QaqOtZ1wTF2+djB/wbBSvEJs26MC8JbX7VmQKE7/RZ+r8eI87+q/XduFeGBmLjmWbkoORVSo3
 +e+IESla
 zw9AoYaTh7hLX+LBzUYsncXrPFjMS5U1/qnnZYwyt9JM2NTyA5urjmCxjmQn4mFwGQy479SsEKDNhfP1s4VjyFNAv/bH3ZfajuhR5fqR1JDv/sxUIH+hL3HTwEmWh7xRxG66pPjILnCypBNmYhj7xREzhMR62sYckwqJ8vum36AGvSpWYJYEqjPTaeqO+ZmYxHQhTgMxPKWubQsV2K5aeF9AufNw1+cMkgn81sHkNmVwVtWk7fnvgvLIAkwkrZ7HXj5ZSkxiaxyRRq5JNxum+ZyojWHmX0VaoBOOMqjPSvfIuzuXS3vjR7cnE1Iu9A15WBaG7c/M5N73TXIcsy/jxL4RLKw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 22 2025, Pasha Tatashin wrote:

> Add a MAINTAINERS file entry for the new Live Update Orchestrator
> introduced in previous patches.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

