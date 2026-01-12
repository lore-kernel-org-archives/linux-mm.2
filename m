Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9376DC9EC63
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 10:25:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE38E6B0089; Mon, 12 Jan 2026 05:25:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D91426B008A; Mon, 12 Jan 2026 05:25:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9D276B008C; Mon, 12 Jan 2026 05:25:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B5C626B0089
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 05:25:44 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 69EDA5B8C9
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:25:44 +0000 (UTC)
X-FDA: 84322930608.18.BAF03AE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id C815014000D
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:25:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TB3TSWJy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768213542; a=rsa-sha256;
	cv=none;
	b=njAvMqH+gB8U53sn2RhBXjNvJKuxYBkurIU0fTiAdw4LEBsoBXpPIY0jBW64BcRb+nCLQw
	nXSx3iKLpksK6M9fowW1uHp8FMpFCbTtBt21ykUh9GvSgrGPvNmL9YdzvExinSOGBjaHD+
	Es2qES/4/iPfVxhCl68wZTh4IY0ZwIg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TB3TSWJy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768213542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oQ+uhczkBU6ZeuZtsKRxUa8pjHCFPyNvAqTeWv5HkrM=;
	b=VTwuEfY5+IDDhv41ROwS/MM1gkCliHzlgo6TksaCpswv9fKS00zYR1zAxKdjR6o+aErafs
	UFi5DHGvUPuJ0zH4PAquO5BZRa5NU5pxBZeNksQO2s8cLm5pevMUgaQjWG1Ol0jmu7ZZ90
	uIFL167Zi8oEmzZdmwNrwzWzJt3ZeAw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 345466013B;
	Mon, 12 Jan 2026 10:25:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8994C19422;
	Mon, 12 Jan 2026 10:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768213541;
	bh=iZB8w08zTJZOeuhUYutrmZtQ2wK2v16pDgwJWhcGpSU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TB3TSWJyHUhoynAjWb06w7GIhKYoQDVMDrLeaOT0MyjqtCXWmRvgze14tZD7P/Aij
	 oT7udaN4OUG/CI8sVA29DGFSF/v5h1VFOat9mN011g6JpkGPfSW50Kn/IqmKuckQGg
	 L4w6njj6XBbg9UFgkKL1gks7m4swycKWV21aYcdp2FPiTRJFv6a5g7hOrV9zU6Fytr
	 f6IqfCwKyzJ9fTSddo3Qk3g5INIYOh8v1UxrdwcElcfPv0PObPyj/klddRE3z7yxxH
	 nH1xlOn92G7FHq3eDu2acNAfKG49EI7MwWD0/ritUdvPLFui90LZUCPn9VPt1441t9
	 3/2xOo4VMXz1w==
Date: Mon, 12 Jan 2026 12:25:34 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Jason Miu <jasonmiu@google.com>
Cc: Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 2/2] kho: Remove finalize state and clients
Message-ID: <aWTMHgHXy9Z-cKeb@kernel.org>
References: <20260109001127.2596222-1-jasonmiu@google.com>
 <20260109001127.2596222-3-jasonmiu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109001127.2596222-3-jasonmiu@google.com>
X-Rspamd-Queue-Id: C815014000D
X-Rspamd-Server: rspam06
X-Stat-Signature: tk7k9tj3o3nokjr4nghhbpwxpp7st8rr
X-Rspam-User: 
X-HE-Tag: 1768213542-518359
X-HE-Meta: U2FsdGVkX1/qJDvXiDDq51gM9l8vbnby3rJvdIJNeqdzTBXWfARWqnA1BWq2JmcnRcr9YqPG44CaWzUqP1K/FclFWq9j5xKwYn59mWHK9KVjmGVXR1oxi04/pF2xw5MBu2F1bwDWfMw4drBEokxT4EhBD3gBd8oBz9FFpdzsLMPuUyGRCovpy25qUAyq6ww+9RqEm/XaS/Xmj0NYuF9AqYaYaAVldycyCwCwz2tmUOs3+MxPUbjDyGfabbnjfVDPrXnmhiKVRXLGrh9nOKJ5D8waXlnRunZtj3aJ9QXGzbC/sH564sZ1tIPswhq9NMAEGc8eNIEcUoNOAs24g8VBhFr0sTGaZnuLNFFd6vXNqEZWDo6oJEfzU1zTwHPjPidUOwa2wwAFqTFxJF95woHE0xgkpY8ziYh8vfpDrdtxSEHxf0B0Hbt3nuX9DMqClpIoqgvZnl2UpTF/AJ1C5qESVRZSlqfzotgwITFWUVnhXqn238lnvYj4iihUDrK4RfYfTzsZYbbdMhqi1kEEKqICXMMxvGVzWdXvqNkaiU+BKdYhiiuc2LgqbKJM9Cex2vS9XKQZMmtR2j9T4iUrF5oyA5jZqEdKgOC7evo7LDuioYf8A1k0hgMbFexlUAg2ekbjZURoye2M7co5upCuthnBxpiaw5OiA7+o/i6yuzipcpB36oewAi5PFfWKwaEUzWMz+sJRWzau0f85gsLvu9ZYqzWwmOlbSExIUVlWHEDAWpm0p1iV608hde6pN1tCuzBCT37AlHIEcmqxNW8xUqDUwosvLlsDs4BsvFHXHWwvM52EDSQ7fpdGpQ5egdwjf5pw1MgGeWrw6O+1foKfFPrhkp0PEEaVaJ61R8mAoX2Tje8XwyOHLxWB6M6iADvIlxPwFOd8JmAU5tswJE7tunk2z4CYpEEcaroBc610tWu4mY9VJ7T4UxQPsgRJqPa/d/2VuzPTqSZuUOtBu8UgjhL
 qhZks+A7
 /eQlfjflLu13ggsXyEpi0m6eCDSQ/atHY6HB09rbzkheYSqzo+yMPWu6GZ4FwXGfgT/semWmDkbg92DAFAInJtq1kLkqTkYirs01HRpSRIMi7KyJpUEa/ftF04Y66wPSqEj/ehY6RuAu2Wo4e+C02HWAIZFwo6x/3UGffZHoXP+951L/BWQaCYhGJwaUlSkspGzABnrtE97vUPRpi/bXMkQJrN5HZSAIdamExHCdjQdloeRHRMaoxIO8yt81bbH0XjSqwOOH4ppizk3lXYFODMVy1tg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 08, 2026 at 04:11:27PM -0800, Jason Miu wrote:
> Eliminate the `kho_finalize()` function and its associated state from
> the KHO subsystem. The transition to a radix tree for memory tracking
> makes the explicit "finalize" state and its serialization step
> obsolete.
> 
> Remove the `kho_finalize()` and `kho_finalized()` APIs and their stub
> implementations. Update KHO client code and the debugfs interface to
> no longer call or depend on the `kho_finalize()` mechanism.
> 
> Complete the move towards a stateless KHO, simplifying the overall
> design by removing unnecessary state management.
> 
> Signed-off-by: Jason Miu <jasonmiu@google.com>
> ---
>  Documentation/admin-guide/mm/kho.rst        | 52 ++++-----------------
>  Documentation/core-api/kho/index.rst        | 17 ++-----
>  kernel/liveupdate/kexec_handover.c          | 21 +--------
>  kernel/liveupdate/kexec_handover_debugfs.c  | 23 ---------
>  kernel/liveupdate/kexec_handover_internal.h |  3 --
>  kernel/liveupdate/luo_core.c                | 12 +----
>  kernel/liveupdate/luo_flb.c                 |  2 +-
>  tools/testing/selftests/kho/init.c          | 20 --------
>  8 files changed, 16 insertions(+), 134 deletions(-)
> 
> diff --git a/Documentation/admin-guide/mm/kho.rst b/Documentation/admin-guide/mm/kho.rst
> index 6dc18ed4b886..57d5690dce77 100644
> --- a/Documentation/admin-guide/mm/kho.rst
> +++ b/Documentation/admin-guide/mm/kho.rst
> @@ -28,20 +28,10 @@ per NUMA node scratch regions on boot.
>  Perform a KHO kexec
>  ===================
>  
> -First, before you perform a KHO kexec, you need to move the system into
> -the :ref:`KHO finalization phase <kho-finalization-phase>` ::
> -
> -  $ echo 1 > /sys/kernel/debug/kho/out/finalize
> -
> -After this command, the KHO FDT is available in
> -``/sys/kernel/debug/kho/out/fdt``. Other subsystems may also register
> -their own preserved sub FDTs under
> -``/sys/kernel/debug/kho/out/sub_fdts/``.
> -
> -Next, load the target payload and kexec into it. It is important that you
> -use the ``-s`` parameter to use the in-kernel kexec file loader, as user
> -space kexec tooling currently has no support for KHO with the user space
> -based file loader ::
> +To perform a KHO kexec, load the target payload and kexec into it. It
> +is important that you use the ``-s`` parameter to use the in-kernel
> +kexec file loader, as user space kexec tooling currently has no
> +support for KHO with the user space based file loader ::
>  
>    # kexec -l /path/to/bzImage --initrd /path/to/initrd -s
>    # kexec -e
> @@ -52,40 +42,19 @@ For example, if you used ``reserve_mem`` command line parameter to create
>  an early memory reservation, the new kernel will have that memory at the
>  same physical address as the old kernel.
>  
> -Abort a KHO exec
> -================
> -
> -You can move the system out of KHO finalization phase again by calling ::
> -
> -  $ echo 0 > /sys/kernel/debug/kho/out/active
> -
> -After this command, the KHO FDT is no longer available in
> -``/sys/kernel/debug/kho/out/fdt``.
> -
>  debugfs Interfaces
>  ==================
>  
> +These debugfs interfaces are available when the kernel is compiled with
> +``CONFIG_KEXEC_HANDOVER_DEBUGFS`` set to y.

s/set to y/enabled/

>  ``/sys/kernel/debug/kho/out/sub_fdts/``
> -    In the KHO finalization phase, KHO producers register their own
> -    FDT blob under this directory.
> +    KHO producers can register their own FDT blob under this directory.

"own FDT or another binary blob ..."

> diff --git a/Documentation/core-api/kho/index.rst b/Documentation/core-api/kho/index.rst
> index 7ddc4d3ecac5..286a6d0b9956 100644
> --- a/Documentation/core-api/kho/index.rst
> +++ b/Documentation/core-api/kho/index.rst
> @@ -9,8 +9,9 @@ Kexec Handover Subsystem
>  Overview
>  ========
>  
> -Kexec HandOver (KHO) is a mechanism that allows Linux to preserve memory
> -regions, which could contain serialized system states, across kexec.
> +Kexec HandOver (KHO) is a mechanism that allows Linux to preserve
> +memory regions, containing kernel data structures in their live,
> +in-memory format, across kexec.

I'm not sure about "live, in-memory format". memfd does preserve some
serialized state rather than "live memfd".
The existing phrasing is general enough and I'd leave it as is.
  
> diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
> index 4c437de5c0b0..ddc9110a2b45 100644
> --- a/kernel/liveupdate/luo_flb.c
> +++ b/kernel/liveupdate/luo_flb.c
> @@ -630,7 +630,7 @@ int __init luo_flb_setup_incoming(void *fdt_in)
>   * data handle, and the final reference count. This allows the new kernel to
>   * find the appropriate handler and reconstruct the FLB's state.
>   *
> - * Context: Called from liveupdate_reboot() just before kho_finalize().
> + * Context: Called from liveupdate_reboot() just before return.

Just

	Called from liveupdate_reboot()

is enough IMO.

>   */

-- 
Sincerely yours,
Mike.

