Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A157CCA471
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 16:31:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABFBC8E0013; Mon,  6 Oct 2025 12:31:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A70788E0002; Mon,  6 Oct 2025 12:31:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95E9A8E0013; Mon,  6 Oct 2025 12:31:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7DC0A8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 12:31:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2A525C0644
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 16:31:03 +0000 (UTC)
X-FDA: 83968228806.01.45200F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 82BA7180008
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 16:31:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nmOzWz2S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759768261; a=rsa-sha256;
	cv=none;
	b=K8KWLmnrd61itKumRTPEK+HEJnVDJbjoyW4W5NGT52RaXyJeXwqiX8vb0uh7KjeOntwOKN
	gaTUBiOqayTODeP7nl3ulMvL9vb73HL9A6IZ826dndK7gTdFjeZmjS8+npK2kIspmrP82a
	l3io5qLKiNI76L6M1rmUYV0/B+Y8ox8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nmOzWz2S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759768261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q9hSnvNFZE1xK6AW4SD9CaWkTyj3oQL+ScFRJVEMjsw=;
	b=d3GBGrC9xJTI8I7Ifm6JztssH+B1953ggsrj7HpugPoq/mrkxjfeNAYaaPkDJSceQcH6x2
	DXAvIgTq+bFjF5NYbohNpEzT+BRxdcaIv/0u3H3vTjWlWp0WuVLZktSaLjMjVwjCo8V4rb
	4EnUmEBkv3Wsb+6ybtaz54PF2Z8Hwms=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6551760591;
	Mon,  6 Oct 2025 16:31:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E435C4CEF5;
	Mon,  6 Oct 2025 16:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759768260;
	bh=yD0PjDQlf46RiJVrF/Aszb7CVdshcKm/wDonN3zBFKU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=nmOzWz2SnthepQu0FPGRBR+aVkqF9ApmQ+zx91kTdSjpax06w+O1ocikxZUxhTvEl
	 BkiQ/OdKVfDKPNQf3b8Cv0Vuv74aRdbYVmxzDhgVhHTLZyqhQenmnJj1HZ5JZctahT
	 j3vRK2ho7EZrufPIHz0BSk+yB3W5zeHAxAMPQ9ODza2WiQAMGpi87FP23eg3+eWSU7
	 xAwJMgbFq6blAZze7hA6lAChs0wcA40LSeN6YRe/c6r6npA76+nE84OWCU3cHivFdm
	 /LXzBroGswAo/PYUtcx8R9abLLGBwJ9guZ+FWOq2tKSpMydDSnFGR03gTDNMfHe2Sb
	 TGHeqGQZhy+0A==
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
Subject: Re: [PATCH v4 02/30] kho: make debugfs interface optional
In-Reply-To: <20250929010321.3462457-3-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Mon, 29 Sep 2025 01:02:53 +0000")
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
	<20250929010321.3462457-3-pasha.tatashin@soleen.com>
Date: Mon, 06 Oct 2025 18:30:49 +0200
Message-ID: <mafs07bx8ouva.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 82BA7180008
X-Stat-Signature: mwskw7i34hmhddyokufy1hruhzi9sji9
X-HE-Tag: 1759768261-110478
X-HE-Meta: U2FsdGVkX1/FVaxj/7FBj1EZXqvgGGpUUjKnCsXZFRQ3iqMqyTLEst0t/bEMi08LglTcDqvyYwrj1gXWiDVsoN/6+thztaZTK3rK7BTfol7XEVJRQGRtPpx31q6gUaBPySKvlrSsLW5tsxKTQI9LNTr9dJgUoHxqlusvPeBjq+/tcxYYtUHvP+AwWb0447MzUl+qh6fTZgviLc7mlrzqG6TXdSJWGyA53SZTq5h1W4Y6G1himCpi8jFWhNUHPGYz1Or6fhrAmWZ8F6ip3Df0ir5PsrJQgIAZeT6ZLXGd02WyN0xE4truUabh3yMOnxikOV4UB64kQPwIAHag3fjZjksLkOcGxl1XT8mZKHrrhBToIGNJxywuRpz9wtedTinhciQyrnAts/vrlCD++r4Uui3EG4RQnfafhL6Vv+/Yv8tcAqGDXYpa7Qd88UK9hTVltZ4LY6M6aB4yt/uVxM7iwisYUZ5YmIVnp9fPfSReQllhzXJEAXuWFkuCjwuz62tjQ52vq9+3DDoZZcMCO1KZg4XQoML/bdme4rGZcpgLJzS6yQnGbH/cx+CATMC+mMI716yY868CvS49Axg6KB5qQrYXXt7gfZDeCIkYsMMf9H+e00NgyoA/i2syqY+3CGV6YrilUnWh9Z6spDGIe4eqJq010+MsuD1PYt+DK7rJh3bii1O/kANLxwps0EPzdKzE4gt9SAxa897jAerCXxx+agFpL2VUcy7iarA7BY9M1sJh8+V/hE6UsfzvW70q6pyHQeK0V4HcpWqla3hAcUConKSWiyEslfe+ESAE127kpeIpuVrmqrpHmhflJfg8lmCXPp4pDNQjxIDZoYYgHeAznsws2ZlBeE6P8Ru9kv2Cwtt7DDmGBOR++CVg1M3+1jFIHweQMCeq9BdeFKqTDen85XTMf9xKsWVoFVDlOKelpt3PoY0PrY4rW4F7NgRFdJKY4gCsJ+w/z948yvz32+Z
 x5u7VVPs
 i1eCBzL0fWIBgQrg6BWPntFiPe89b+66blz2TUZs2RRIFVl/Lvl15EwbLuPTlAJGFioHlAuo9CiBrPp3w7qwIUBcyXKqhIhkWon/g5N/8xe/5i9WYmAy1dEqVW7KaUZat4Josbf/uze41vHs3TRM1XHZ+Us6G9rQuARsym2nv/S0WUFlzq1LTRQptJOnTp2C2N+D4YN2IwrdsvMFMtPYgsJEC11HBTS2S9Oyqo0l8JUMWVBdVboVIQ+o3gSWaHLZdo5azASULL8YcLZn/1RXz6kpdZZO57S0q3t4UrVt8Z8TdEQshThYir7OdLxKRJX4TLs75
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 29 2025, Pasha Tatashin wrote:

> Currently, KHO is controlled via debugfs interface, but once LUO is
> introduced, it can control KHO, and the debug interface becomes
> optional.
>
> Add a separate config CONFIG_KEXEC_HANDOVER_DEBUG that enables
> the debugfs interface, and allows to inspect the tree.
>
> Move all debugfs related code to a new file to keep the .c files
> clear of ifdefs.
>
> Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  MAINTAINERS                      |   3 +-
>  kernel/Kconfig.kexec             |  10 ++
>  kernel/Makefile                  |   1 +
>  kernel/kexec_handover.c          | 255 +++++--------------------------
>  kernel/kexec_handover_debug.c    | 218 ++++++++++++++++++++++++++
>  kernel/kexec_handover_internal.h |  44 ++++++
>  6 files changed, 311 insertions(+), 220 deletions(-)
>  create mode 100644 kernel/kexec_handover_debug.c
>  create mode 100644 kernel/kexec_handover_internal.h
>
[...]
> --- a/kernel/Kconfig.kexec
> +++ b/kernel/Kconfig.kexec
> @@ -109,6 +109,16 @@ config KEXEC_HANDOVER
>  	  to keep data or state alive across the kexec. For this to work,
>  	  both source and target kernels need to have this option enabled.
>  
> +config KEXEC_HANDOVER_DEBUG

Nit: can we call it KEXEC_HANDOVER_DEBUGFS instead? I think we would
like to add a KEXEC_HANDOVER_DEBUG at some point to control debug
asserts for KHO, and the naming would get confusing. And renaming config
symbols is kind of a pain.

> +	bool "kexec handover debug interface"
> +	depends on KEXEC_HANDOVER
> +	depends on DEBUG_FS
> +	help
> +	  Allow to control kexec handover device tree via debugfs
> +	  interface, i.e. finalize the state or aborting the finalization.
> +	  Also, enables inspecting the KHO fdt trees with the debugfs binary
> +	  blobs.
> +
[...]

-- 
Regards,
Pratyush Yadav

