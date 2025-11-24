Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 710C9CFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 14:21:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8B7A6B0026; Mon, 24 Nov 2025 09:21:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C63466B002C; Mon, 24 Nov 2025 09:21:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B78B66B002D; Mon, 24 Nov 2025 09:21:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A1E7F6B0026
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 09:21:36 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 57B0758D1E
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:21:36 +0000 (UTC)
X-FDA: 84145713792.05.B73D4B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 96F4140017
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:21:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KM8+cPAk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763994094; a=rsa-sha256;
	cv=none;
	b=XE4jJl9Xr5SCG4oBz1pilJZ8yZY9NqLI+Uf3h3SU7nQ7+fgm9UFbxfleObDh10lU/XMNpi
	YEjJ+0+hU9ppxpPzMHS5lBvibxVq1YLBpRsX30ZTWpG6fpRk5Sw1DL4qLIUzjbcNHRToDR
	b18ILNjHpE70L6j5c8b+qE4xQHhLeQA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KM8+cPAk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763994094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GDZD6IYDyihfE+zlLyZL0OoL2fVwHwVzSuWrp4YCUOs=;
	b=sXxXERltOs2Ouc2JeRoc9CheLiLjY1H+3gGYFb6STnqwp93qA8BRYHAIF6ZlDessVHmCf4
	s9wjEDve2K7zSurOLJ9PAQNywANJRgFOTzR3WSzQp1VhkPxlK7klwDqaCA6/BW1XtkDWpQ
	UVrjKb7qsX59KerhfP58ASyFflvyCAU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ABEB1415F4;
	Mon, 24 Nov 2025 14:21:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5459FC4CEF1;
	Mon, 24 Nov 2025 14:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763994093;
	bh=8J349+aqYU/8MBNS87ks0zT1OFB1tcYyBFGPMvm8Xjo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=KM8+cPAktUopUOxkR02UWCqLycl011KWke1x0XedfVZAK1Mh8Hku572UAnEKLEEts
	 GNF3d7mEFWDSG3b/00eRzormizV3GDXiaEG2zWpYaQrlq6yhfuK/dHJ96EtLq0nTBh
	 xYWTgLkMi/Lgth3dTS72A1BJO9hDEyoIvpR2rFZiqQDuUyl5LaIBfy+ILj6p4INLRl
	 CU6OT8lx+RanesPhsYtm64JkkjU6LAGXQLUb95D5ChSRBnX95AinNsQ3zUMcsyS3Nv
	 a1EdbI30rD7x7xmYn9H1ut+8bOqDqCPTQTmlbteX9u3AcHaiFqXyvIm7FhjFReiHVI
	 uBuRKSoRIDv+g==
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
Subject: Re: [PATCH v7 02/22] liveupdate: luo_core: integrate with KHO
In-Reply-To: <20251122222351.1059049-3-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Sat, 22 Nov 2025 17:23:29 -0500")
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
	<20251122222351.1059049-3-pasha.tatashin@soleen.com>
Date: Mon, 24 Nov 2025 15:21:23 +0100
Message-ID: <mafs0ikezzf30.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 96F4140017
X-Stat-Signature: 53brejyhs9cmgajk1bim151azjm63fgg
X-HE-Tag: 1763994094-822623
X-HE-Meta: U2FsdGVkX184Hyco0qnXJ2F3IYkaTPity1d/8NMb5Nyjuj45KTIoQqBEdiS9JbdC6couBlZ/5I4BS1mgyoncLRnsUwej61LGbP+zTWcsIQEhrPtPBDZeC/CFcBzuxgrUnM0y3FPKCEQ0nOB3koR9O/oehVHgA5xfN2cTvb+7JWMwNlKFbmbcdyMYVSXiGbS2ncMbu/mFVZntiu6IYAqWKwx4p0ZSta3iznDdvZSDlyUkuB5BI1gZD5yBbjz8CtfZDLauSil4KMdZwJWtBK9RqQW+LhcZp2Ktt8GmVfhnhd9nhjY4b4XafvQ46MktkGdDbUswSHPNPsz/XRY1Z8XG7k6k2JEZ9cKnWinZnOjetnh8cjFsOsPJSdKe4FRox0dT8A5Kz7VXSCKCOnYjehXU//mYEfIMG3BQNKQvkPkjhonleLbUlMS5VakDYFj4WTYXbwRnii3S38qIb+ji3innFAcwXNp5eOptvdNgtaQ1ASYSXeQZjTaji2Ydwit2GssTU5gZIm7s6r5K174J2O1pByehASH6myMKypXmc5ZslaXChc18CKB65U3OzkKo5ACZETHrPk7O2RtOGjGng5Vfv56oD+7Epsoqi4qBku+KO3WlcOzowb30aXQgSF0Jy4iIeCvaWpuBJXMSy/yiQM6urgl7NQLa4ICbFatgVEutVlZ4j4T6qpox8FfL9lC8Ie0YIGiUX5UV5Ix0Sx57SSuHpeOt9Ofy29Fxv6LhtXighiOeSzIlmAcUUVdkkbjWhoDknQdnqohFaVEnSuRbXUjzYA0NcfoCGRoL6rvfrNjzcYEIFzyige3oGUihWSghVJRHMc7yVRyCJqFF073HuIYuvzEc8a0fZ6n5KPELGu+ea+u9QL80ebkjvcJxJTdijzPJcqJODZf9/NxTh14WiAnEklKHk7NJEFcGjv1b51qslQDuky3fpZMlU4l+wJPEiJtWtqnK9L6YvPh94Dmv+Nb
 1mNVSuW5
 /wJK+2ORxJqj4ctRXn1OpdI1I/IwP2TLLGEqPiH9nBfw5lJ/51XWKumd1V/aBW3VbTk1pYDdzoulYRfFX5POvW2RC4MwefUjAmRxr2Ay02CKDzd6IetpSViYZxSE2eWkdPIBZmPogDR5PF9wmWMuUr82YqADR9qJ4NHoDWD5UKOzbzxP5LBFILKrkrry2EEbzdjzQAn4ixilRE3lOUjP4INrwr4bbX7rGRxj8onINqCenYlSWKZTI9bh1o/w/kSlXVnXZAvHcAVEQpv5OiDfd30Pc1/69yKxC6+ayIHC8RXutkhWQhyieAGg8UA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 22 2025, Pasha Tatashin wrote:

> Integrate the LUO with the KHO framework to enable passing LUO state
> across a kexec reboot.
>
> This patch implements the lifecycle integration with KHO:
>
> 1. Incoming State: During early boot (`early_initcall`), LUO checks if
>    KHO is active. If so, it retrieves the "LUO" subtree, verifies the
>    "luo-v1" compatibility string, and reads the `liveupdate-number` to
>    track the update count.
>
> 2. Outgoing State: During late initialization (`late_initcall`), LUO
>    allocates a new FDT for the next kernel, populates it with the basic
>    header (compatible string and incremented update number), and
>    registers it with KHO (`kho_add_subtree`).
>
> 3. Finalization: The `liveupdate_reboot()` notifier is updated to invoke
>    `kho_finalize()`. This ensures that all memory segments marked for
>    preservation are properly serialized before the kexec jump.
>
> LUO now depends on `CONFIG_KEXEC_HANDOVER`.

Nit: This patch does not add the dependency. That is done by patch 1. I
guess that change needs to be moved here or the comment removed?

Other than this,

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

