Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0FD7CFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 15:12:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04B116B002D; Mon, 24 Nov 2025 10:12:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3EC76B002E; Mon, 24 Nov 2025 10:12:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2CF16B002F; Mon, 24 Nov 2025 10:12:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CECC86B002D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:12:10 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 16A79C0430
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:12:08 +0000 (UTC)
X-FDA: 84145841136.23.5629383
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 89244A001A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:12:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LYHab02j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763997126; a=rsa-sha256;
	cv=none;
	b=hwohvULqerglyGwcpoSe00HHuozatdz5bSKy7Df+w0UiKIM7osa4b76X0QEOUZ1uuChtci
	zH3e+WjHu9qZOCdh4MqnmkqZhkDdPjCl9LB5CE1T/fXHVzcL1nmPKb19HsZCdbPSgj43mE
	GDlJD/GdgUxIEnmtVvfvfLoS5+w6UVQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LYHab02j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763997126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fNKCRgAEHSElzjkAHNWjlyGGDjoLmcmFMV1nWgX/dTg=;
	b=nIaUI/ww9zKWY5pS0u4tQQenHkRhAi6ABTBnBo9jJANXURejEGzXnzpLAU17sdq2+gVs1Z
	GhUKzdk7rmXS26qFaD9S0/MzT41YTVXBYjLd1CCRfSsEiulSCUwO1qitCkZ7fb283a+eF+
	r3uBFkAsoCTloPZIvwJ1NIcVDIox75g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8AEAD60167;
	Mon, 24 Nov 2025 15:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EDA2C4CEF1;
	Mon, 24 Nov 2025 15:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763997125;
	bh=IeGeiqgSNZBmNA7r9FO14ptYSSG5b2I6U6bwIOdQhRQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=LYHab02jO3E9C8XTjyTJMavYY4LBsZi6qyzM20Wi4d7mrU8V6BZSN/WuaSqJ9BzAn
	 2mesjmXJz4ydNtLQunjg4knJzBDGpH9KnaNFaDtPPFDnTP/x210xtODnOkuaprbdMd
	 VUf8ZFe5yqyjNQotKnMsxXYrQ6METe2Qnu0mk/zFqX45joHI7uOZCPFUD2wj36OgNc
	 ol0EpUZIEDDkP84JGiPVDjb2pvfFRrY0Q7iSc8f/XsZmX/xeu/QnW4BUvZ7ohn7G2c
	 N0nY8biVoUoQ+vykXPTf2lBWtVub7GMKPxoOA8gQgMthziSMkKJilfZWR8UeGauSuM
	 /uxCiRDR0qYnQ==
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
Subject: Re: [PATCH v7 05/22] liveupdate: luo_core: add user interface
In-Reply-To: <20251122222351.1059049-6-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Sat, 22 Nov 2025 17:23:32 -0500")
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
	<20251122222351.1059049-6-pasha.tatashin@soleen.com>
Date: Mon, 24 Nov 2025 16:11:54 +0100
Message-ID: <mafs03463zcqt.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 89244A001A
X-Stat-Signature: smwb9dkc3w6jyky5kpqzx4nd8ou81t8h
X-Rspam-User: 
X-HE-Tag: 1763997126-496810
X-HE-Meta: U2FsdGVkX1/ihklYXr4bDLi+lFqdKNa7WXK7REgP3ioXYXrvNMATLkIoQopJa4k/pXZqUP6uBTwdqHevr3ejfR/H6AMqH4pCIY5AJB0cMLm1M1PVUKcRhNwFrLxjFoFCm+Rer9NOibQrdyTTPsRB8NHDKp8sm4LtWj5IU/axpDBEeAefPEBgrUPDpDFlwP8ZRWaeaNdtvyMTFfUkVEKkwmYHuSrHIlxUpsuE2fEcJGiglMxxgJIEtrcxO1i/hvK4VxbF6MdHnLqG1wXU5gJmS60xaTaErBl9gy7mKvhDDCmSjiQbxej0jDDcGGNR1bHLOiH+vurKR6WSQcqu+YvLLst9o0avFqU6ReFog8RzUIeVKJWCPomx79yD6I+he3YpATKpfQ3HhDhQkTVaxiH8z711N+aKbfyaQAqfhc/fJ3coq8j49C/3LR80E0XXJ9Alss7Nn6T/H8KtAly+W4bBavcRIw9WkhZACzY0PdKF6UDEX0an3liVkYaJFCGmHApsmyQnkxHVHZPTr390S8OAi+6llATi760SzfTOIWNM8zw9r/XqZHds0wIQSfIBNFxXYtUpU/UDk3GabZU2tCTaXuifDnx2zflKxuCSFyR5DKIg1moxUvM71ydkw5ymCXfHLmhOLrLnv2CGtr+N3Yv8Ru3CPOY/Jo86NvqmE9Wu6WVH4CNNXDb8t216gOxNlI6J7H41GrO3udjK2qkMio/KRu+7+8Nv8uYnLBLUKvqS+5iSwOYOxAXnSjLrhSo27OG26aYtjqpCRjiinDGCwtpd865xVUnrV5e/SZwBCNHbwL3CxVGWU0kiDFboDwwgXABJOU9WFqtaBsdEgJLutVccM/DplJfKcXN1y7FpNQykyYP0aCxjoVYLpHlrZ3mPMd3gCG6H9I86h2u5rdfYLquj1UeOE43XA1hWJTAwo4yTWAQ4mIhUEcHIkLTbnUKeICyaNhzeThhNbty87U79GYC
 A795kFp0
 W8kINn+PQ82tsDOAVx5B6V0Rc2EhUTESQpWJ+JuxjyJsfPEVFoTfOii1a0skFwYbKSIE33KS1vLGJkG9PaC0vND6STNHPtgoDvXkoco6FV679fvh1fd3RBGqn1HqgcVTeZhfmCURuntvfEu+etGPNirEe9iOGpBtjMKvMceyoFvxz3UmxSWv9tJetLf2Q+N7QrvFLbxRFSNcIZNfuotnKctnXL/vP6zB0VjeSiLSzkKnkEtbhX3XxZIGIqbFaOHMCaKgW1vVsKEFZ9iZcLxVvlnnXEs1b4jbI8CPQVJQMHvskHhgXTZdg14mXYgPQypIN5eFCuhNLZKFrBz2Hw4Mpyhf+atgbnQfsF0XNSBlGxS6QYoQ/nNpuNnqlIA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 22 2025, Pasha Tatashin wrote:

> Introduce the user-space interface for the Live Update Orchestrator
> via ioctl commands, enabling external control over the live update
> process and management of preserved resources.
>
> The idea is that there is going to be a single userspace agent driving
> the live update, therefore, only a single process can ever hold this
> device opened at a time.
>
> The following ioctl commands are introduced:
>
> LIVEUPDATE_IOCTL_CREATE_SESSION
> Provides a way for userspace to create a named session for grouping file
> descriptors that need to be preserved. It returns a new file descriptor
> representing the session.
>
> LIVEUPDATE_IOCTL_RETRIEVE_SESSION
> Allows the userspace agent in the new kernel to reclaim a preserved
> session by its name, receiving a new file descriptor to manage the
> restored resources.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

