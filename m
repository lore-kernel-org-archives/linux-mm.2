Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 838DE606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 08:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ORlPXPgS
Received: by kanga.kvack.org (Postfix)
	id A82796B05B6; Sat, 31 Oct 2026 04:43:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0C326B05B7; Sat, 31 Oct 2026 04:43:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D43A6B05B8; Sat, 31 Oct 2026 04:43:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E78F6B05B6
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 04:43:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E4BF18061D
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 08:43:08 +0000 (UTC)
X-FDA: 85382281656.27.5A57A69
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 39B2B180003
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 08:43:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ORlPXPgS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793436187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nXkkUyzWC+RTVIrTwIsDK9pB6UYriIk9MdsE6VCyJgY=;
	b=yHczV2gV/krvrcTBdT7i5ac38OFd9zGTdLe6BfnxFRTbaP1wAkWDjuee8fNoP0JfrS1yQC
	z6lixlkp8/MQz1dharoWtZR5PQ0/fnhwY5Dp3m/y7nPJfFZHCltqdGh7wfAZQU/+Rol7Hh
	PjwF5oLi3QN8fvsORU0VPYgigPyLOtY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ORlPXPgS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793436187;
	b=C14oHNferJB3I46fErN40eqik72MBTUclPBV0QbYPxS8hc7z61HE+LE2U/pKLorD35p5NM
	kLPRhSWFFc1k1PObReD/Ifs78cC0nCYZy9BtInwL812vUNnwbdZaO1kfUjfv3uwkH7ffo/
	us3Q7FxbAeCAL8xMqWjESz3PZB2HpxA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6DAA243987;
	Sat, 31 Oct 2026 08:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1F31F00919;
	Sat, 31 Oct 2026 08:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793436186;
	bh=nXkkUyzWC+RTVIrTwIsDK9pB6UYriIk9MdsE6VCyJgY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ORlPXPgS5XwD4OguPrHtmOsXivt5T92Q84WqGkbL/0pA7y0ygtOZdpnEZaz9Xq75S
	 US82CX/J14UW4oK6p/4nAFyjft/uU881oICIH9XwGhKGyBHazPWz6+sdwVMTgTHXDi
	 OeN4YpipRkgLoSH8ULA2Z/yZC+J60LcYLxJqnz32JMX3nCWhoFA9JLZ6UbgBL9rD9q
	 lmad44Lw8D7ovPNw2Mfe4qfZwt1gWdC0eCmj58arhxqRnpb9XG2txUBAshrChHctp2
	 Vgp7xVZWatKmrEFdxi+E/33RziYGHa60Cfxb2/ehfPZvSelsPlVrqsBf7jn7qJtT41
	 PW5YyYA6B/J6Q==
Date: Sat, 31 Oct 2026 08:42:50 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Byungchul Park <byungchul@sk.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Dave Chinner <david@fromorbit.com>, David Rientjes <rientjes@google.com>, 
	Dennis Zhou <dennis@kernel.org>, Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>, 
	Hao Li <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Jann Horn <jannh@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	John Hubbard <jhubbard@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Matthew Brost <matthew.brost@intel.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Nhat Pham <nphamcs@gmail.com>, Nick Piggin <npiggin@gmail.com>, 
	Nico Pache <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>, Rakie Kim <rakie.kim@sk.com>, 
	Rik van Riel <riel@surriel.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Will Deacon <will@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/7] MAINTAINERS: TMPFS (SHMEM FILESYSTEM) updates
Message-ID: <auWpV3BHsYVLaKLx@gremlin>
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
 <20261030-maintainers-v1-2-97278f8a5f54@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030-maintainers-v1-2-97278f8a5f54@kernel.org>
X-Rspamd-Queue-Id: 39B2B180003
X-Stat-Signature: 1t8s8zedrb3pk8hd1ox8441g43u9mhsd
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793436187-583496
X-HE-Meta: U2FsdGVkX19LtRaPjqk4/bE5/mmouQLpeNwcFzhZdskq1ixRCNo8w1NiniF0rrkIjWoGxong9xCah8FWOYSmxRcTgHGMbB27YvBofDc6eXxSQOwAcM9eX0l2xCz5b5Ca/RPeYuKxVJ71oSVuq6P/xzVuJsRsuVQui7saD2m/MJllpz7MwQU3mzjZOsv0Vh0tMj1Jp2Y7iOa0X4mUu8lWdhkbDlT0PKvLmN2aKUwyufV0c6wo92IbOucV6827RRA4b/J7qe+3Al7As6One1lU8AEyWD0Wsm/XjuGtgsyvbHthkQQt2DkSldaXNkuo+vhF68D1PfRiVEoLhFwg6ulT46mxL26AxcZamlI4IMk9lTV+G9pm49w8mRYpmKYezEK9SKctzR6lSpYuQs02ZA/7VAlVtBNZRZOx4HuuDLnxLVORx+MwKmuyGOb6V0L/H4ci9SYdHX0UEHkAJS6Y584AXqMNOWkguIdfMVqjuosOAie4uV/Epa4qbFVZ19MPT/PJAhhISNBxCiKxJVtLtrHpzoNSXk8wV12gLbl9H2TNOK8BUK2CVizHMFCEDNq6tKLQZFvl0CGxf1F+p83QvrSa5TlOTxYIgKRHvSDUN+LDm8NbBLQnScw22pEqgPVT2JetHbip7XZUiDoaFVqRgWEk2Ul8cgSvzTFHyAepBEkDSrpg8spuak2fro1Cq2jm4QVrLqNGCU8RGpzZsbhvQ/nZMrJv6hms4klNRvDvo0QvPFQ7yFguhPTD/VfspoKABMaosuGc0qIekc1lkWivS+1kEohVXjEGww0YUn6rDNRWnzpwRLDCKCFh7mC2k3JnSYFGMfb7g22dTSGJxkIblKyWr+iamQQIW82weIHzrcPz3ElGfmInPL9ilxFzSIAeFtm56eBVsAqMGfguiMHIyjPa+l54xenRD34ys18yFjJINoLzzdj1aovgQVJsL7BD5ucgiEbxeCyMFuAf+lW4vGD
 rsfPQOTQ
 FRPiW2DlUxqp2XIm8TLOh1LWhMr0Nt7S7wk4o4Lrzcow22xgWroPR39pB9vPRRhdfntS/bsN6kAP8U43E/kBct8IBdxPZl4+HxpRXlJ5ibx7Xah6/yim4Wk/fQHDMwjxs04zXuxZ7Y5QTAUqMQ+vda4U7XZu7GQ8sR0SfBGya0WJFLN/cuO5MWrbVTf0LQxdwcLEvZuBY+aaiRVVRmN1RX2VTJLyW2lAfx/Tju9Q7pr90wkRRoZH4AQ5BJP6kDrvGKVifVMd/P88p2EQhE8t+z/dFKqHSvLq3kFXXv+1BKrZCiVQlF3WPczsN/giV8gH5sB/haZEGQ2scjKIGTWNsjI2/esUJzdyAe33L7igxKpgDwKNkONkZTvP1Bw8Mb127U/MBMc/fo0Y31IBkmJ34YClu70tbPXWDuTiDTEMXjHqVNEnfR3hA9ItH0JpDs5dHaCA20LOMuX4P49bT4IRqDI29+P7GkuQf0I9I5f7iszYvr3IIUFVdqlXME9eSEQTmNBkeeygR2GfNzOE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 10:34:26PM +0100, David Hildenbrand (Arm) wrote:
> I am not really the best shmem/tmpfs/memfd expert around, but it should
> be good enough to judge when something is ready to be picked up, to then
> pick it up. I'll have to heavily rely on Hugh and Baolin on judgment
> for the more involved and more controversial bits.
>
> Rename "TMPFS (SHMEM FILESYSTEM)" to "MEMORY MANAGEMENT - SHARED MEMORY
> (SHMEM/TMPFS/MEMFD)" and move it accordingly. Add myself as a MAINTAINER
> so people know whom to CC.
>
> Add mm/core.git as the target git tree. Once shmem becomes a high volume
> component we can dedicate it a separate tree and have dedicated people
> pick it up.
>
> While at it, add some more shmem/tmpfs/memfd related files+directories
> we missed so far.
>
> There is also "kernel/pid_sysctl.h", which includes some of the pid
> namespaced sysctl vm.memfd_noexec. But that's really more of a proc/
> namespace thingy, so it's not a good fit here.

Maybe not for shmem, but there's definitely still some stuff in kernel/ that
should be ported over to mm/ (thinking particularly of fork stuff).

>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  MAINTAINERS | 30 +++++++++++++++++++-----------
>  1 file changed, 19 insertions(+), 11 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index dbb5582ec1c74..0baeb37b0dcdc 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17772,6 +17772,25 @@ S:	Maintained
>  F:	include/linux/secretmem.h
>  F:	mm/secretmem.c
>
> +MEMORY MANAGEMENT - SHARED MEMORY (SHMEM/TMPFS/MEMFD)
> +M:	Hugh Dickins <hughd@google.com>
> +M:	David Hildenbrand <david@kernel.org>
> +R:	Baolin Wang <baolin.wang@linux.alibaba.com>
> +L:	linux-mm@kvack.org
> +S:	Maintained
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
> +F:	Documentation/filesystems/tmpfs.rst
> +F:	Documentation/mm/shmfs.rst
> +F:	Documentation/userspace-api/mfd_noexec.rst
> +F:	include/linux/memfd.h
> +F:	include/linux/shmem_fs.h
> +F:	include/uapi/linux/memfd.h
> +F:	mm/memfd.c
> +F:	mm/shmem.c
> +F:	mm/shmem_quota.c
> +F:	tools/testing/selftests/memfd/
> +F:	tools/testing/selftests/tmpfs/
> +
>  MEMORY MANAGEMENT - SWAP
>  M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	Chris Li <chrisl@kernel.org>
> @@ -28202,17 +28221,6 @@ S:	Maintained
>  F:	Documentation/hwmon/tmp513.rst
>  F:	drivers/hwmon/tmp513.c
>
> -TMPFS (SHMEM FILESYSTEM)
> -M:	Hugh Dickins <hughd@google.com>
> -R:	Baolin Wang <baolin.wang@linux.alibaba.com>
> -L:	linux-mm@kvack.org
> -S:	Maintained
> -F:	include/linux/memfd.h
> -F:	include/linux/shmem_fs.h
> -F:	mm/memfd.c
> -F:	mm/shmem.c
> -F:	mm/shmem_quota.c
> -
>  TOMOYO SECURITY MODULE
>  M:	Kentaro Takeda <takedakn@nttdata.co.jp>
>  M:	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

