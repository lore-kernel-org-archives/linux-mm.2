Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB801CFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 15:49:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 141966B000D; Mon, 24 Nov 2025 10:49:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 119526B002B; Mon, 24 Nov 2025 10:49:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 055B36B0088; Mon, 24 Nov 2025 10:49:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E81A06B000D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:49:57 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9E2A74F337
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:49:57 +0000 (UTC)
X-FDA: 84145936434.15.7C6C59A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 32159100002
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:49:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rX3IZj7Y;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763999396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RcVxAyAOUDBwgt8JvS57E2d/sTvRBD6sZKKXMUqtsIU=;
	b=64N3Rp3uN/ByUBG0ztBtCLwuFYW4bKN/SAKM7Q7gn76YRh4HjDJwju2OUk9SmjEYxjNf1F
	+8tLFekQdpErnLQFQWOT5FOSjraoFtf3g7qAoxHKfM54VZQiazqLgpI44NkxF3OFK8KyM1
	Us4FoC6PjAb3/g8yqRKxXWpbh7U1K30=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rX3IZj7Y;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763999396; a=rsa-sha256;
	cv=none;
	b=WZi4Cafy2kEoewJpwa5l+bRwB95tYMuAdo9PNQ8yGiXykHWBK81p/C5UlixGiVb3dwi+jH
	NWC+l6zlhAu1u0QJQXJ1+2a6SpPHUCzVuRcwh6m23Sf6Wf0NSJVatGGg+iKH0VWK4NEjKa
	sW4XgpIbEhgLXBn7Idbx97NWnpoPS2M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F2F460123;
	Mon, 24 Nov 2025 15:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E236C116C6;
	Mon, 24 Nov 2025 15:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763999395;
	bh=Fc7xoFZ935GiHhrQjcCq85XhwHgbVkMldMDphDsctag=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=rX3IZj7YWOEnIZo2QGOlGW/P/6jr+LOEA+NM/bQR4xyIb9enNc7yPs1zgJi/94oCj
	 oPC+fEun122uYfvq2PgA1Eafgycrd7W5JeHko6QGdZJcvE2qa6LhuzaLb4yBCgHbKJ
	 7vf6KFCZS9rfCXIxOIRZhEMqRd+LkUHWGpp5JqK7HNO+9V5clMZmvP7sb+Q891Kfzs
	 YVsy0jJqRp0q6tDV0Qrapq8AvlkqojX7XfH4auBq7+tyAvXLAU7kvfNw65rXpiKQ01
	 3wfKmg18V6Z1coXrOn32d/oik74h3gv5zjD+jxEFuKQYTxLErVPlToxoPwIJdtwWRU
	 cYaJap70lRwOw==
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
Subject: Re: [PATCH v7 08/22] docs: add luo documentation
In-Reply-To: <20251122222351.1059049-9-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Sat, 22 Nov 2025 17:23:35 -0500")
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
	<20251122222351.1059049-9-pasha.tatashin@soleen.com>
Date: Mon, 24 Nov 2025 16:49:45 +0100
Message-ID: <mafs0ldjvxwfa.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 32159100002
X-Stat-Signature: e44ktgt3kzikqpi8uampoxgbbjor1ezu
X-Rspam-User: 
X-HE-Tag: 1763999396-808353
X-HE-Meta: U2FsdGVkX1/1vMWN/TP6nYzNMCm1gpugCUbATwUC5rw06v7fW7Xs/mMqW1oow1bDz51s35Bavn8aL0sd8Pbu7uB0U1s/Yr4PnXMojtzu5jHRpJay+zpP5b3ODbVIxnz5qbMv3fNOJSPZL34DWA69rBzD/JcT5tk0YsLVIFPUDfR0yLQzIT4aZHBzI0A0ODkc2EWqGf+KJ7SHxee2qMZQ0OLGk64MHuk3dTP1dOJeYVLTN0Eru8K1qqHEtxyCYSr02K7nLn2PkBiSZFa2sE1HNpqXIcer6vulomihTZ4twm3KSM7PzbKASNl2ozRj3mTpJ1BuC4v0K5ME2FYZrt2YzedLJKx02qI3tIYZ9pAGV+xFmZPomK/j9gGWgFwFbUgj0pbiFOdSsiZaWsiUKLnrks5WPznW+nX35U+XYdUO7vFQ7ZkTtAf094ztJGhDfywGWCIEoKt3w5Li4ZarOCvy5w2syv8v0vlZf0JdbPD4CFyxUtarV/au2yfhWeF/Fwv53W++LsKcClJ2/2MhT4WYFU5Zs154ySBMZPF4hKupGalF52O+zgsRhduSx7aHB6N60vRSKku+V7Uorfm9kY02z9Ty90+Mie4yWXCv/Q+/So4Mk+lIkvqlk8Vq1LPq1wJrJ44oUapOv718q9MXRHioeahlvo2lkVPgIQXM0n+f8b9dQexAE85QVNFY2VDbCayaL0RLip7F8eh0Xw+ALY9n6PxLeEY/WCWFmg4oulP8gnDfGyITcRaiCkG42grcZCq/mVethrUjMD+zooV9AaqES1WMwOESEo1mTXCTwvEeIhTtAc7eATw7mK8+zxiFwW7zjfOCY6QcVO1N8bIXk/lylemyweEhmabzBYWnS1pQN3Cc61GacPChX7Wv8NCdf/Q3KOCIDarXFH9xaibegdaMOdGajPDdp7pOMf11pLmjoxLQPOGtK2/NLilqyyLPH6H+biQTa13yQy1HQcE7xST
 +jQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 22 2025, Pasha Tatashin wrote:

> Add the documentation files for the Live Update Orchestrator
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

