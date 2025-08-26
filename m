Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C299CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 13:16:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 961FE8E00D7; Tue, 26 Aug 2025 09:16:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9122B8E00A8; Tue, 26 Aug 2025 09:16:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 801518E00D7; Tue, 26 Aug 2025 09:16:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6AB208E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:16:35 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 22E37849AF
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:16:35 +0000 (UTC)
X-FDA: 83818957950.26.10DDE3D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 919BF180006
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:16:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jpp3MwAe;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756214193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+kGhSNFQTru8XfFFPxWqu/LToYmrlIHfiD8s6F55dA0=;
	b=hO/dMDD1r1c6i6KJEYsdDKSQogJOqvJKhHkAjAuz54a79xi5AO2+uCLkhFAPASNIUszE7h
	fEbclI126yh6rR6bODuuACsz1TI53f2qyt1EIbNd973cIa1mAuX+BqjlUBQF8G2Omqnoww
	19BbxE5Q1IPtkr6quSa//f/wpOzmq4k=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jpp3MwAe;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756214193; a=rsa-sha256;
	cv=none;
	b=g6r+yE3VQltA+4g/aGuVjq9+EQCm1CBer9JfzXobXWj8IunrSWXRoVrPrn59e4ejLPAbZk
	K+/0IvzXFOfXW4IU+tqDznjs9Ky3tcg564SRbuQrqVnKOsAzdstf0EKIJun9KDZD64W2wv
	NandOh8Oy50jawy4/1m4JEX0oRXPHSE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CC7E8602A7;
	Tue, 26 Aug 2025 13:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E44C4CEF1;
	Tue, 26 Aug 2025 13:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756214192;
	bh=tFb+Ondpv3Ccm4cT7YJIvIxpPOa3gBZBu7W+KGbSHs4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=jpp3MwAeRCmcs1UuVWPLSMUBFxGBC6oylqYB3I9Uzi2zxr21OZ6UbVQud/RwJFL5A
	 JtdjMnl+UTMcT4Vgdm/+7BIHD4iduxJtj78yK3VPvpmhMG8nsPX30DSSTgLWTl+7Ku
	 BOieUo7gY9Iyv9Bh/2rSCb931n/kxnD0i7kIOvV62Lt7fUpCQnmQtb1TmMedYESuYs
	 Db2KWn2LhMbIvO2UWMg9WFZqHSbo4onE/E0K417i3qgQHY8Y8da+WdKX2Cy0Mz7GAQ
	 2eL4A+0PFwJa7uFynssXDVxGSTDsF74paRhslvfyRZw2VMr9oJmDa7gkTB0CBX5fry
	 ZXrM1hz5JJqzQ==
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
Subject: Re: [PATCH v3 00/30] Live Update Orchestrator
In-Reply-To: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
Date: Tue, 26 Aug 2025 15:16:22 +0200
Message-ID: <mafs0ms7mxly1.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 919BF180006
X-Stat-Signature: 8hr9xjmew967npojku8khyfietkg84z5
X-Rspam-User: 
X-HE-Tag: 1756214193-712444
X-HE-Meta: U2FsdGVkX1/LhSs3fG/yn79tEzKr/iM9Rw300V3GZrGJUgSEUhBh9WfnqK3zP6+cWtEozaJ7F5dGP7t7zk8cCg2cIVrXNFC6jOj+T9hzcOjj2BrGKD3K1BQA4QfPl5cGbM0hAFd7uzYkNJyJYjXOTwk6ZmyDsrtSCMYlXIR7LIcY0x15NT0zJVNrQ04ILDeO2lTb1B23g+iHEIhQ5semUTn7F/uqmRxgcha9PQfdkDb9RARC+bHN6FXiYGXJKvnyxNHRPgOvebKpTAssIlVZcRMJ7qgjPP1gppBH7CnJLIHoyr4Eo3jUpVd6b74pQp/lzYE2oyj8HfVSUtb3TDUt/FIddzuL4ZS6KR0vzQOd6IdOd9Rm9eFQ1+pmbof+/JqH5PPEosHV+Me/r5JUwwFE3FN9DxWsBREiihnLxsStonuD1o8Pc+W0TBjlBtuwmWD31v3n1fCypmeRFxTp1DYky8saHyNgIHklLae5haA+59Xn3wNjST6+UwTJsHH3muCz/LdXn0BhZM3kz4sP64vYOiveacyKRdBnI3iHoNAoNYYwcl6ZTVvUqYF4R2irdbZ2Lw9DrNT9Dim5z9F4pt3HxuaLAMYX1ltHe0AC9cLTPaQjtAKgr0M6zX9ypa9Tbfl/U5120p6T17ekleeGz9A3kLVdqvv5R/tNA0g2sHAYrqbrQBCAR1HlxvBi7b7s5bnE4NoAGElFeXzPt92Q6Ukat3JY6E4Vu8sS4M+8CjIgk+wlZw/D1mx+8GeoyYSIGmztrDyU4vHPJIVLPCtVh32OC39C7CQeYwArppvY7nydjKv9+Gyyid4PIWJdIs/DTXSGEgwKQ33Sno6RbQ3ZYedRTfmXFLrCRzj8w3//t8ITjcI6sDzVN1oTbcISodgGWYimalb6mEOYSqSH5NRlFBhwr9C22PZgovImevN7ahe4Y5d0GCxM2lQ2KKXFyeX9zH9VkhllogtDA0MuWeLGPuZ
 E7QIw33u
 w0CLjFXv2MbW/Hcz50bVUaeOV+Ok7kBPWhui2RC3bOHpCV/b59bKsz/5PlADClvZjG66ydzueIWzO+CYK4o1aLijNvgNldauZDxNyhHpxOciMxL1ep4lVEqrsj/KkwEgG78+wKnbKzlDdYCGNoqCf1hcLxT8u0AGpouP9smPYaSn/DFPMaZSIsMAVBOR4iPvNY1WS1TlxmltgMbNxuWFI9G6AkZlrCBKPZXXYxBJiEX0MVGBiAzZJHq6BXEENO5IXQTNUkw6L72EQgFM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pasha,

On Thu, Aug 07 2025, Pasha Tatashin wrote:

> This series introduces the LUO, a kernel subsystem designed to
> facilitate live kernel updates with minimal downtime,
> particularly in cloud delplyoments aiming to update without fully
> disrupting running virtual machines.
>
> This series builds upon KHO framework by adding programmatic
> control over KHO's lifecycle and leveraging KHO for persisting LUO's
> own metadata across the kexec boundary. The git branch for this series
> can be found at:
>
> https://github.com/googleprodkernel/linux-liveupdate/tree/luo/v3
>
> Changelog from v2:
> - Addressed comments from Mike Rapoport and Jason Gunthorpe
> - Only one user agent (LiveupdateD) can open /dev/liveupdate
> - With the above changes, sessions are not needed, and should be
>   maintained by the user-agent itself, so removed support for
>   sessions.

If all the FDs are restored in the agent's context, this assigns all the
resources to the agent. For example, if the agent restores a memfd, all
the memory gets charged to the agent's cgroup, and the client gets none
of it. This makes it impossible to do any kind of resource limits.

This was one of the advantages of being able to pass around sessions
instead of FDs. The agent can pass on the right session to the right
client, and then the client does the restore, getting all the resources
charged to it.

If we don't allow this, I think we will make LUO/LiveupdateD unsuitable
for many kinds of workloads. Do you have any ideas on how to do proper
resource attribution with the current patches? If not, then perhaps we
should reconsider this change?

[...]

-- 
Regards,
Pratyush Yadav

