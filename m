Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FE29CAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 14:30:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D7B88E0016; Mon,  6 Oct 2025 10:30:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AFF08E0002; Mon,  6 Oct 2025 10:30:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EC4C8E0016; Mon,  6 Oct 2025 10:30:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E92D8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 10:30:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 18C3213B69C
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 14:30:26 +0000 (UTC)
X-FDA: 83967924852.12.F9E6B17
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 64DB5120008
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 14:30:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CyayRvWM;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759761024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vFbyxnKYqd+JJ8jgEoUY4oJ3zSm8ilFrq2d5S0srgro=;
	b=8eeJcPq4s4RcC2jzT316L0RYo4U6xDeOSSun3MA//6eQp6E00t0QbW2Sl3x9O2aXwuc4H4
	rz0wa3ZWIVckg4O9GeF5esJpEGaIAmB1Zvs2qSaiAiefr8uAyVJuGSwyE3AIWYwKggrSOZ
	MMGiVwmJmPLliKUbSc4UIF89Hl72x64=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759761024; a=rsa-sha256;
	cv=none;
	b=A7g2RISrT1Mu5TmCDoL+/jbBqlWuUnR7rtueeg+wED5HZGoK5RMR2aGDMXuhVsoYzkrOkT
	F1NF77hCSSUbnolEK8mYh1k3YoTKqkwJxq+HEcC/4V6QFBjK2qrJyUC+9cuzI363PlpZxg
	gThHyMVDCNcovZO8GNxfjg08YRf/1Q0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CyayRvWM;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EA7C54059E;
	Mon,  6 Oct 2025 14:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E25C4CEF5;
	Mon,  6 Oct 2025 14:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759761022;
	bh=Z0Xk1zutYNK5fdV7Q90ItmYTFXFrXh0MnKPjPEQpcec=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=CyayRvWM7fCrhPL8SVjOSeWTov06Ps1dORhh0sl9klxAwOkyK7ONJ6lZE2eVvrvFl
	 mgInnab3z3wKW99UU9pD8ZuQf2Bw0/9ib8mfYNQzjTW3DmCxEx1RFB6nGo4lOu7CzF
	 hMtJn3RZ+OrtUP8mFaUi86/tZi35QjBlQuR8RYrgWneX3WVmBbg7jndHayNovJMUuC
	 uWpOU/jICq82izj2NxgEyPAjvZkgJ46SG/GvvA3u4cxkkQStzdUHi0wkPwMa6lcX/i
	 BRde4WsDzdeDSTTrafTTHcRA7U22BRlDcJusZ5J9SnjMbh+SfAH3bGkkt4WKFEKf5i
	 HSZ5diknL9v6g==
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
  parav@nvidia.com,  leonro@nvidia.com,  witu@nvidia.com,
  hughd@google.com,  skhawaja@google.com,  chrisl@kernel.org,
  steven.sistare@oracle.com
Subject: Re: [PATCH v4 03/30] kho: drop notifiers
In-Reply-To: <20250929010321.3462457-4-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Mon, 29 Sep 2025 01:02:54 +0000")
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
	<20250929010321.3462457-4-pasha.tatashin@soleen.com>
Date: Mon, 06 Oct 2025 16:30:12 +0200
Message-ID: <mafs0bjmkp0gb.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: e6u4huwjptrmcrkj8mozgppomnogh5m1
X-Rspam-User: 
X-Rspamd-Queue-Id: 64DB5120008
X-HE-Tag: 1759761024-658893
X-HE-Meta: U2FsdGVkX18OTpZpN2mC8zq2U5SqUzodDl1D29Jn+5zVfQTr9cpH8XJ0f+aA1YJs8BWMPoRliGjL/cq47ktyODDTbrxoND08z/OMluJvbVwGZyWtwdj2Y2dVTESWKqoU1s25oWops1S+XEiID8ZWeG1z0/oYtFSpfUbQRnDd7/L2V79RpJGgNUBKK5W4zHkh7wEIJWYqzKL3w978EaaLHg/pqaBumUQH8wfJXWdVbYQGlUKasa4DqsH1Wqm6ILdN2hL2Soxy1xmh8HFvbuv49MFml/O/dT6vcqzkk/dgcl5J9c/V7KaDoZb1sCaqxSa4+FJ7NZ+EOWw0OAs/rnhz9FlVqhZQ4vY4gvFJK0QXa63ZPOX7IWoNVU2WjFyz7nXc+QX/w62SlaCoiQPcaPHe77ICYtz3kCFfyqxtfp5Zvm8ljgtrgJ29IPb4tbWjd692WoPIZNbIcc0Ht2V7I0ZgBj767W1rRqhUxxHvsKJj/RHvgQ4amhy0jB0oSkQwE2kUCPbsUq3BRoyOm495m4pkuF54TP/mm4wAulvF8BouvEitlm8Kg3Y8WpmRYuoxpWo01bi6dfL+CjOA359jsNSaToNrGmVuJL5I7B9F2AlVcT9ox7uaeYt4VPbUzK6tzWgbztoXLKy+0Onkgx5/9UvPJgpbPJ94oqYNzYu7z5fjkK/JnhmGjIB3w/Y1BpAe+3/YC/2D+q5SoFchRAmcBwBJPVTlc7NPGQRCF81d3Ei/WmLeYvUJ8xAC1fICIVvAhq/PvKfGAKu+BqjKONe2Vw378bAbduCY74PHpYOG8fC3WElre8XFC/Lth/3q18L/XZu7bihPL3AzSCgvbLOg4Oeel/PGGedOyAIDqPXA5bfoYhPK6aUVrtP1HK9Jvgt1wXDOraRFD9x3UAYAervDQ2KJP41dAch+5Y6LY2MNZVNKSIK/LnRZLdmswDzpCFo8Qj/qypJaI+oqoCz6lh8fI7N
 eIw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pasha,

On Mon, Sep 29 2025, Pasha Tatashin wrote:

> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> The KHO framework uses a notifier chain as the mechanism for clients to
> participate in the finalization process. While this works for a single,
> central state machine, it is too restrictive for kernel-internal
> components like pstore/reserve_mem or IMA. These components need a
> simpler, direct way to register their state for preservation (e.g.,
> during their initcall) without being part of a complex,
> shutdown-time notifier sequence. The notifier model forces all
> participants into a single finalization flow and makes direct
> preservation from an arbitrary context difficult.
> This patch refactors the client participation model by removing the
> notifier chain and introducing a direct API for managing FDT subtrees.
>
> The core kho_finalize() and kho_abort() state machine remains, but
> clients now register their data with KHO beforehand.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

This patch breaks build of test_kho.c (under CONFIG_TEST_KEXEC_HANDOVER):

	lib/test_kho.c:49:14: error: =E2=80=98KEXEC_KHO_ABORT=E2=80=99 undeclared =
(first use in this function)
	   49 |         case KEXEC_KHO_ABORT:
	      |              ^~~~~~~~~~~~~~~
	[...]
	lib/test_kho.c:51:14: error: =E2=80=98KEXEC_KHO_FINALIZE=E2=80=99 undeclar=
ed (first use in this function)
	   51 |         case KEXEC_KHO_FINALIZE:
	      |              ^~~~~~~~~~~~~~~~~~
	[...]

I think you need to update it as well to drop notifier usage.

[...]

--=20
Regards,
Pratyush Yadav

