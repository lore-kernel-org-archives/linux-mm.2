Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AD40C87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 11:47:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 481806B0089; Fri,  8 Aug 2025 07:47:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 432596B008A; Fri,  8 Aug 2025 07:47:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 320D16B008C; Fri,  8 Aug 2025 07:47:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1EA0F6B0089
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 07:47:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C6ED51353CF
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 11:47:38 +0000 (UTC)
X-FDA: 83753415396.04.2F83587
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf17.hostedemail.com (Postfix) with ESMTP id 26AFD40006
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 11:47:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IQU2DVcy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754653657; a=rsa-sha256;
	cv=none;
	b=zsWRuwWn3q/SW7kvURMbYuWV6tquMTXtG11oOjil6YFcnC9IHmb9/RrNyKWHrEBUN0CAHn
	L7Q8we0Z5UXA78bqXRrjHGCdyJ1vnKjPHNBIJ+nj/cgOzoOBgI4Hfu87W5kyAHgGMGHlFr
	HyOab2iv/9qd3ZiHPVzG0EO8lZfnPIM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IQU2DVcy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754653657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tObHyzo3ugVrq7mjBSStfLR9QybToYocVYUOe2rzWzI=;
	b=seGL2Z7GgqsUk+6K9bxrusp6A9zI9Fc/dGTaDovYIU+f7xD9zb/fj95tk78tTNuxQAK5oB
	kkFDaZ9q+JHRH4c2wZIQ68eWVTRkz1QUq89zJZ+DNpU6gv/VeU0pQ1imjaauj2R4QAwT05
	+wnTUxOcz6WzMrjSimQ0D073XutiRLQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id D18B75C5E78;
	Fri,  8 Aug 2025 11:47:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C61CC4CEED;
	Fri,  8 Aug 2025 11:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754653655;
	bh=/MZhv2xyt4AcUDBeXqBeLQjeF82okZjGlosKDRDZRRI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=IQU2DVcyJVd5B0+i0u+kVGVGSkAyEJgeoPLt83MBFTeukFmA767VSCfee9jo2kpJu
	 ewnqYzL6oFuM7V3YAHQKSYCZOsFySGH8wD9cKXnZ0GjvCQG0ofU/o3fp4iR99Vdn4N
	 6OxePJiGA9xHAIcPvRRE33aHWyPRNjMyeM8mnvmewljS376m/31icfgu4UnvrvGbjj
	 Bs+qwGRAP/jEDGNUL2NU1f2FiSa6GoHKoZZ+pLsWzn9OAgxbccK0jU1nVw7t+sZLje
	 K5KflUU+XXYFZxZAybDHl6gqr17n00q7l0EDS4/DJlhSWNViKSvh12nw55GJCFY56f
	 EOv0YpzVtF53Q==
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
Subject: Re: [PATCH v3 02/30] kho: mm: Don't allow deferred struct page with
 KHO
In-Reply-To: <20250807014442.3829950-3-pasha.tatashin@soleen.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
	<20250807014442.3829950-3-pasha.tatashin@soleen.com>
Date: Fri, 08 Aug 2025 13:47:25 +0200
Message-ID: <mafs0jz3eavci.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 26AFD40006
X-Stat-Signature: 5hpu89akgiogq5e9y6oyg3g37938npsy
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754653656-40130
X-HE-Meta: U2FsdGVkX1+t064T0nY5/raE4ibgUp5sldykVYEf7mCmn6TMlY8e1XZ3vOXeG7B5B5Rt6+G6A5dDkMjLs80sXtws1ZkH7XxqVqHjOGmH5eapDt3zuMHTIN0XErqvzdV/j62xcXHnA2lC358vszEzuNAt4dj0xlD7Sk96FkpQVpVYXf1Zw8TtMca3FLM1Vqe01NB9BuZzS7r/PGCyfhdqEniQcT2swZb55bwPZ0q0sb8cvWiRx0ibdnh03DvBGxJ8wnk5/C9C7fDk3N7SIAbb1nYOXF2H0/roDATGTWhgVJcvZaraJuE8CoAZmL5men5W85ueEUH9fyXX/rPnw5pyC3x8IQfxkpiCdx3Zb/MuQrFQQe0ZJEf7YQQrGnRythydMv8LiiaMNcU2W6Njj+Pu5nB7/XbfvP0i4mdlPveyCJHhJngdLIUfM0KvzhUOJlpgjfTFBmoTCjgf+j5pDJxj+zi9dQfDsR7Sc1Yd3CrWhnFrtOMv5S0rzggtoTfdeMStv2nTYZqD66vF2JNsfT33ra6NgQAX8Jf4y5JBKgh4c9F4ifU+AcCRmT+4xwdBAtqGxYZG3Yj5MQyQg1Mz0HTkKs3z0WD2gk7GJEVXOB4RvEs0ijPYQnd5DwI2hvNOIOS4SenM7ZePTFgdGNDZZuaPUBxKm6FZMSSkA/ZS6G8nNBTGmspQbhYNI8xLTaY5Y6ykDZj91R5n0FUvTtswWrC7d8hI0rrywwYSMtyeVCKjUWV6FShJKjxIQhpJOdPSEkLgtvd0QNr5x6KA4BmJ4mxUpFCfQYm+yXQh+oHtF1zHGQxpsTMPzoro4vzmM/XNieL0dZ2yr7YT2KOxuAf+T0JBofv1B2Sohdjtu1g9M4ojLcoGJiMkVVcBmvyyKdOFTsjQhg3YdPlKgEN32T7WkPlv3Da/k0mDLoVZ/cWz5MvRy9gsSemWrxV6BxetSj8X1Js3U4DSWJJ8s1nk+f8khrT
 kPfxPJfg
 vU7p/pon/fI6caS1bdxSA8IgeKADoWyPnVf+sb4Q3FEc58Q85ZqGT5jVyCKYJc3hsiVKzbCwUvX77CHG1oC/sXrijbdjOiJZigBtZPgD7S+gFPVlKYdu65UTnmVNRKVYeZhI2aWhjY9blRgvGa84v1LsSjUPluCKpJuzApI5UApUY0j8T0Fr9yH/V3xWWZBhpPWDkKSzcWjDPRBToMbD11a0Eb2qQSn1Z+hA9NvRaUVnPAO2uYFFe6slkMp9OIR1bdslwsHByH209RrWggP4fGPfXGn8eHSrLTKOa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07 2025, Pasha Tatashin wrote:

> KHO uses struct pages for the preserved memory early in boot, however,
> with deferred struct page initialization, only a small portion of
> memory has properly initialized struct pages.
>
> This problem was detected where vmemmap is poisoned, and illegal flag
> combinations are detected.
>
> Don't allow them to be enabled together, and later we will have to
> teach KHO to work properly with deferred struct page init kernel
> feature.
>
> Fixes: 990a950fe8fd ("kexec: add config option for KHO")
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Nit: Drop the blank line before fixes. git interpret-trailers doesn't
seem to recognize the fixes otherwise, so this may break some tooling.
Try it yourself:

    $ git interpret-trailers --parse commit_message.txt

Other than this,

Acked-by: Pratyush Yadav <pratyush@kernel.org>

> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  kernel/Kconfig.kexec | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
> index 2ee603a98813..1224dd937df0 100644
> --- a/kernel/Kconfig.kexec
> +++ b/kernel/Kconfig.kexec
> @@ -97,6 +97,7 @@ config KEXEC_JUMP
>  config KEXEC_HANDOVER
>  	bool "kexec handover"
>  	depends on ARCH_SUPPORTS_KEXEC_HANDOVER && ARCH_SUPPORTS_KEXEC_FILE
> +	depends on !DEFERRED_STRUCT_PAGE_INIT
>  	select MEMBLOCK_KHO_SCRATCH
>  	select KEXEC_FILE
>  	select DEBUG_FS

-- 
Regards,
Pratyush Yadav

