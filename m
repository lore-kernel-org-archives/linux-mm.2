Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CE9ED78771
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 13:20:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F5726B0088; Fri, 19 Dec 2025 08:20:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D6736B0089; Fri, 19 Dec 2025 08:20:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FF316B008A; Fri, 19 Dec 2025 08:20:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1D9726B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:20:56 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B7A7B135E3D
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 13:20:55 +0000 (UTC)
X-FDA: 84236280870.05.5D2EADC
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2E57F80006
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 13:20:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZWEFgbAc;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of ricardo.neri-calderon@linux.intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=ricardo.neri-calderon@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766150453; a=rsa-sha256;
	cv=none;
	b=ay3Xe1nHei0+YJw9RJs25XuMSmuiTSgez4SM8ssWBr+hSmrt+EN8b4hg7CSYvKQan6q7Zp
	4+PWBScDefCNVSeDSVRAz4kA3GywgNqAdTAyOipxnYzonK2qT0ugea9WOhqHS4Gvn9hNi1
	Z31JwrP+dcwFSXl7u0C1ogK+VE0TEzY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZWEFgbAc;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of ricardo.neri-calderon@linux.intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=ricardo.neri-calderon@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766150453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DNnsrT+xqjSs+eoJ714r3VZyZ8ePN/6D90yOcvKqJTo=;
	b=ifPUnEte9YV7RMdlXC5YWzsfA26SQ3exujL9fS35oXarGZoEBjdrV/cDyu+k7H3mipp+Ok
	unDqCVNqKl0QB9VxdwJH43LmSz1NZytML4S8X/OsezTIombT81Pgi8tHIOkm4R/gkUaC+H
	X49pRllRt3pS+75KaRdsIVbF3jKdCy4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766150453; x=1797686453;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=f0sb46hShgEmBn++3KKU6DlH/HUmKOnchsckBopK7AI=;
  b=ZWEFgbAc78a2/CND5/deA/CzwtqmHSqtYw5bobtnV7zN1q9mP2+HiiV1
   OzMLckf2MDL3d+xqrAHNtUHdzIkmnDs8Z+P7w4xHjo0IeSB9fpjtZOg00
   ytM2gkndU1USlGbVGaQpmyN9n55KAmBdLBcw6KquoAxBJN2uXuNOFcnLY
   sJRa8qxx26CsvUjkjkpuDDUGnHi7IuVx4CqkEWB701daysT91XnVMKAMa
   jsOzCpv5a8axKTbc0Or4aYjAC/VX1187tq6WCZo09dnw8s5hBoiwlqy2/
   vqTuLYM67FVV6+Bez8oa2w2DFTvkJ8OD6fr5HNZbWz652ZnIHJwiuWT4w
   A==;
X-CSE-ConnectionGUID: VGRQDvrlSVO8lLualFyxrQ==
X-CSE-MsgGUID: RT/NSiK5QfCi6d/vGKnxVQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11646"; a="68005917"
X-IronPort-AV: E=Sophos;i="6.21,161,1763452800"; 
   d="scan'208";a="68005917"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2025 05:20:51 -0800
X-CSE-ConnectionGUID: cgKRPYbxTeqSA8bqcKwKWw==
X-CSE-MsgGUID: jlI0wWT2TOeRGNdaDL8Png==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,161,1763452800"; 
   d="scan'208";a="229544196"
Received: from ranerica-svr.sc.intel.com ([172.25.110.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2025 05:20:51 -0800
Date: Fri, 19 Dec 2025 05:27:31 -0800
From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, rppt@kernel.org, graf@amazon.com,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org, pratyush@kernel.org
Subject: Re: [PATCH v3] kho: validate preserved memory map during population
Message-ID: <20251219132731.GA18378@ranerica-svr.sc.intel.com>
References: <20251219071209.3696755-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219071209.3696755-1-pasha.tatashin@soleen.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2E57F80006
X-Stat-Signature: p37bmg3rrzfs17bpwhxnfaknaem7at1j
X-HE-Tag: 1766150452-4303
X-HE-Meta: U2FsdGVkX1/Ndyo4bIR2ewVj6VmDTbAuBdf6q1kVDqg+ZKLAk7g5QKYvY6bfcFCInoWqPZjIBZpgzumNBsPKdl3l/xVRz3MeSBs0Qk/fNky8tt5PtNtnfYxcAHFSmElC/bg0Yg3lm4k9ToAMVHr3h8MfPfTjXUUOcanjfRZ7mVswcTjBmbLWaGc8c+7CtFGzVjRoswYcNUqoW4DS1lJW1kXMJfxcVq7IFKAibIpiga38i2iDfKDQIx12KqrcrlciYw9/yq+MMU5o6nx+2/LRoUqZoNhi8eqkcGLptZ2Ri64hxUn8a5bzL/bMdjmNDNBBQoa3OmUqF9Fx768gGbCwSdVteZE4VGp9ntkj7bhxTHbtE4v+YmCUwGGA6nQmsX3b82Lc1V4oswPtBMfsJ4U5JJspYJuE5Rh0M64dW0y9GcuAxpB3hIekWI/QiOIhEaCFH+esjGOrOBuhxl8Js04x2EVogKPQZ8v1WZ8zMrxB3rWkTvRCsybSNaty6/F4MWVC1Nqvz9WA7r70bi/Km796AAJXGnADfiqaGc27YIBRQk4OhA1eXJP0u7+ulBRqP3dDK+rMprFcHidwOgBSLv6nbUUpUGKFBb0GGCIXXuvi42X+ttKJZ/37KVQK3yg9uQEPeofLohqunMsH4Y4q/nTK+GlHC8wimypv1srfMpqDQuWatpFrS7JuKhyPstm3TRpfUcHjcW1wSAMBJ+G+fJDjurvV50X0KtdAN2LeMx2KeZTmeDcJpnV9SB54c/UEGXFWqTih6EcKKdwNeY3ID7PviB45BSQ5kVhBA61Bbh4UQIxdk64qh3K9Oa89acqZfH3Hs/EDX9ejj0dCwuw+QlYm7IB5tquDhsUmdkGbAbOYUHAIuExZSuJl7kOpl4kw+sxAlyHzPmfgh5JfSQUBjBtdlMrjg2hHhqSAURn0G9x4IkYyjn2ajTbDAbwimtd3UHAjP3pOR91zlrerL8JxCN3
 IZAYHfJ7
 W226DsnwlkwzyvO5m6VLvNaswyNsyoAgnB3WhJIAQFZN3dIpb9E7kkxupcunNWrdNFGkXXCfNir3d7MFtNZJyPhLcJXwXbRjYa/q0swwpX76Qro655Iq38IFwsmxmkiIVyib9y2FliJyV9dweZJVEZCOmJeH+P4AFvYj4VPIBW6X8HpKXI+K+p8eqB4eII17xOZti4GZjfGs8rpTNX3WpWRr0P5JhzE3D0J+21xlEAPwvBbZaRu0sav6sKgyNv64KK4Yx2OMVdKOC1xHeSauaqCTskA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 02:12:09AM -0500, Pasha Tatashin wrote:
> If the previous kernel enabled KHO but did not call kho_finalize()
> (e.g., CONFIG_LIVEUPDATE=n or userspace skipped the finalization step),
> the 'preserved-memory-map' property in the FDT remains empty/zero.
> 
> Previously, kho_populate() would succeed regardless of the memory map's
> state, reserving the incoming scratch regions in memblock. However,
> kho_memory_init() would later fail to deserialize the empty map. By that
> time, the scratch regions were already registered, leading to partial
> initialization and subsequent list corruption (double-free) during
> kho_init().
> 
> Move the validation of the preserved memory map earlier into
> kho_populate(). If the memory map is empty/NULL:
> 1. Abort kho_populate() immediately with -ENOENT.
> 2. Do not register or reserve the incoming scratch memory, allowing the new
>    kernel to reclaim those pages as standard free memory.
> 3. Leave the global 'kho_in' state uninitialized.
> 
> Consequently, kho_memory_init() sees no active KHO context
> (kho_in.mem_chunks_phys is 0) and falls back to kho_reserve_scratch(),
> allocating fresh scratch memory as if it were a standard cold boot.
> 
> Fixes: de51999e687c ("kho: allow memory preservation state updates after finalization")
> Reported-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
> Closes: https://lore.kernel.org/all/20251218215613.GA17304@ranerica-svr.sc.intel.com
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks for the patch (and fixing my e-mail ;)). This fixes the reported
issue and now I can kexec reboot correctly with an empty, unfinalized KHO
FDT.

Tested-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>

