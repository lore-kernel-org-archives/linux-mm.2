Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7617FCFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 15:56:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFCC06B000D; Mon, 24 Nov 2025 10:56:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD4346B0026; Mon, 24 Nov 2025 10:56:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B11386B0062; Mon, 24 Nov 2025 10:56:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2C2F6B000D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:56:55 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 59F651604AF
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:56:55 +0000 (UTC)
X-FDA: 84145953990.09.E0875A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9E7B214000B
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:56:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t3MFTO6o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763999813; a=rsa-sha256;
	cv=none;
	b=Xu/iEVsKVrPmBbr2rHCFP94xNouigitRpd1CExgDe4nyAZlUzku/EjqIUpxmC5TMlkNvDf
	Se6IKqsiDcrsWraOPHZQDyE6rFBHvmk6tp6VNwABC1tEOA7LuYCQe6RE8GlltQb6iE47lt
	veUt0Rvfq/cFYeN+A1JaYod3qB3L8t8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t3MFTO6o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763999813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A9dQgHo9WXOkwvV5gdsdbkF1GTNPWRSftecT9vNE7BA=;
	b=WXS2qvoThDiLGh0q6eANuFZ3/bghYItANyTy4vnQokwCRaODaDPk/dRl/7xUvBySyUlouo
	u0ooNhVH9yWiNcDbTeyDIA/nqCKTpMzIGIa899CFV/MiWNSKxyzJNsET+GOWf45SQDgHSx
	xvrNdJfJl11k6XUgWJw1U047PMComPQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 98D84409C9;
	Mon, 24 Nov 2025 15:56:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C15C4CEF1;
	Mon, 24 Nov 2025 15:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763999812;
	bh=y63yvMXGRSUR5hsa5yj3y5bNOs9e+r2tXeZwg4ggXb8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=t3MFTO6oJzw4eL7xPmfLcDdWjwmXfWH6/xWxMWM8CQnbFA3+M27qnQlQZEZEAFSsb
	 bnal+s2Ox/0TWQ+7JFrfNqo34Dw0GnW4t7NbtnrXlDY0iyhvWMyxTGaMY5dlgNNCvG
	 m+5ZOBamHjaWXtD6w3VOKIoicFlyHYBpgotrFC7Gslxa+QyKvdsO8sN+QqXK+OnRnN
	 eTjVY7JVQnmZDKBIRT7UZrg7yiMjHJ7jIvotIB1E8raHNQsV8TDSYDToYVJVepxr+e
	 WOjOo05vwhIEe9IZm5LQY0wvYx9GNlvSYWINRBBU+gCmdDHmxrTfdS7cjDxaucLWS/
	 bJEKQS66cC2Og==
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
Subject: Re: [PATCH v7 16/22] selftests/liveupdate: Add userspace API selftests
In-Reply-To: <20251122222351.1059049-17-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Sat, 22 Nov 2025 17:23:43 -0500")
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
	<20251122222351.1059049-17-pasha.tatashin@soleen.com>
Date: Mon, 24 Nov 2025 16:56:42 +0100
Message-ID: <mafs0ecpnxw3p.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9E7B214000B
X-Stat-Signature: tjxpo3izh3xubtf9ekb7uxntgnkkfztf
X-HE-Tag: 1763999813-438442
X-HE-Meta: U2FsdGVkX18SaP04WSn+yqV43jPLaDJM5M9WyUoxQhNjqAww9hoHrTAFy2rZ7bOSTJh9BVArQ7ryjd2ZcCWylxrk4+nnIvGVaIZ0NOwUw3aA4sXxfG/So8MFADMrQ2NoeILWa1GDrHKVcbiYpDptphYxceshpakO94/wcrTXskGwlzdBIanNGeFZ4Kbb38jp89P5cFzJJo+TXWAoZ0fyydrPng3ycd+K3FGCTdO3RMAF96B3Tr6EP1r/lBQZGIcN23VIGklKSFz0sC2P3wK9dxZyRELMzXbshpEphJOP4sn07qXvgXFiCXa6F3GWmt//pFjTv08ibdiDuLoYBmIalYsl36COUtTRGoEmOP1Gpq0GMUfdjHwsoUc3RJuE+vYkrexENZbUAIeg5uuyoftB3MsA7iphCgaYUwQ0CxMMpltr+zvwe+deDpmS7IdtOyKLlaGDx+1+6dz0hdaX1Gx7e7d8p0Ni0VTB+H/iR0yA2oPqNTBi2JbtCQSFVCZNAMZ/SvGBNaKDr3Vhh2F0BgTO28iWbk35gt8hHiIKBIaUIXcj066kGW7a66yVKPLpI0OBrcgsdxWhfGpYwhSA+UEjIMYrk+PArbaeZwx9rDE3IdDxf2W9tbl89b0buPSPPeOAuZTzMco+YL62CE4tMjrH9Jq47fcEY7S+F14NU+Ioe7JRIp9TM0zPbAem585HkkuAKGRzYn+0I01OLO09UTd8HSNWDRiEzyFTVrp/oX3N1mDuBGnOGv7ikjp9TiEZD93Wmp7JORofRTVwpTyzKWSdHPTvoOW+nw5bcRx6C84AFA5l/drsJ9yx8C4TCIC+WreXvSW5Zm05ZoRQujnLffKZy9zqhmZ2XTIlGwM6tPC3SpI9u8gzdE9Ia7m5tLQjJUccU/yRQYxs8TnJEPG4pFafyeUIEr4GCQ2ccnDYB81tJOSXCofPo3dCE4TSDZHVlkpQrrDt9QFwQKRCCee3H3e
 1kPmcyqO
 ozEB1tMeBUKRU5Kw3E6GMIZt1bAi2eoOH803epy7uInDKudKoWxPnVQyJP7UjSWEPdGQ+qTyjn3X62yV17a3lW906GKqYapmKgguEYpXsJEqquwahwZzgr3Rkq5RctHnesy3IfmorIvt1k2hifZqssgGw+leLGUxXRhmVSXQ75gqsVM39BwPG4AXb1hoeiaqvKPiZQYJ7qfCQG0nYlQRpesNBx6CJ3zo38xLCyNSSHtQ8o/Vlg4Ml1OWa3oBxV3JYz/RXFEtF2JW44SuIJUtVfkHgJmRr1Qh5702fLM+KI5uCywRn3vIE3Wp2C1pRmMPU4IeA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 22 2025, Pasha Tatashin wrote:

> Introduce a selftest suite for LUO. These tests validate the core
> userspace-facing API provided by the /dev/liveupdate device and its
> associated ioctls.
>
> The suite covers fundamental device behavior, session management, and
> the file preservation mechanism using memfd as a test case. This
> provides regression testing for the LUO uAPI.
>
> The following functionality is verified:
>
> Device Access:
>     Basic open and close operations on /dev/liveupdate.
>     Enforcement of exclusive device access (verifying EBUSY on a
>     second open).
>
> Session Management:
>     Successful creation of sessions with unique names.
>     Failure to create sessions with duplicate names.
>
> File Preservation:
>     Preserving a single memfd and verifying its content remains
>     intact post-preservation.
>     Preserving multiple memfds within a single session, each with
>     unique data.
>     A complex scenario involving multiple sessions, each containing
>     a mix of empty and data-filled memfds.
>
> Note: This test suite is limited to verifying the pre-kexec
> functionality of LUO (e.g., session creation, file preservation).
> The post-kexec restoration of resources is not covered, as the kselftest
> framework does not currently support orchestrating a reboot and
> continuing execution in the new kernel.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

