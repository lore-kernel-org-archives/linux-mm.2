Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E0D8606A326
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=iLvz2V8e
Received: by kanga.kvack.org (Postfix)
	id 9B48B6B05B4; Tue,  3 Nov 2026 03:27:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 965346B05B6; Tue,  3 Nov 2026 03:27:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82D616B05B7; Tue,  3 Nov 2026 03:27:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 54DC86B05B4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:27:44 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C4BCD120328
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:27:43 +0000 (UTC)
X-FDA: 85393129206.13.A13A2D5
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf02.hostedemail.com (Postfix) with ESMTP id 115E680004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:27:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=iLvz2V8e;
	spf=pass (imf02.hostedemail.com: domain of hughd@google.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793694462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B6CEN+98TLk95Pbz6PoJyknaTEGQ0gqo4V17h4hhV6k=;
	b=n+ad/qWN8yzfAlAh3LpL932KUuAQ71ZzoERmg63UvcYOz91Zq5eai/V217aZUV5CN/QhOm
	w8DOGgPRa+YR75fx2uhJvLOOFZkAKYeKnqu9esl8hQMVkIBxlvuBW1EwLI7v33WD77bMnQ
	ohyMtoZRjb7DWn5FG+rvqIqmwLXYggA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=iLvz2V8e;
	spf=pass (imf02.hostedemail.com: domain of hughd@google.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793694462;
	b=oDz4DlS3ipSUfLWdbuG+RAEuOdXMhr3SiQJT6KB4zS2PXp9Bf7KhJU/BH8J/7nB6N2akkR
	QJ5scph4Hyw528AFMUYjHDIiKle+0KQSezLpsVpu+DazrsGP+TfTJgBtROhXTfX9ItNHQZ
	e+dRtMdEas5zavcCbYvnxFdnQR05+zw=
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-8ab43af5e97so5053727b3.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 00:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793694461; x=1794299261; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B6CEN+98TLk95Pbz6PoJyknaTEGQ0gqo4V17h4hhV6k=;
        b=iLvz2V8et8BQjoK7m0dHoJh7wMILj5rE3VWCQauOXUM5eANCmb/p6cd+fzzSnY5sii
         zveQCyQSTUppeaXRrLizu98ZSBJ27pggZH75ruPNPg85t+me4TQ2vkNAC0hFL3QeprmG
         /1BOfHY2TTQ6J5kC6tOaC29btCwHJwkBQz0ZOBWlimcWuuyVpCDOamDEeXKKlSoFgCQZ
         oUSxZ/TmgdwA/2ugKmDmQ8dWUZTsLm6Y34pfOLpuzUYJeUOwX+JUR5xga16lVEOn6vbP
         HH7OLPIRGwiIjC88Mb5QgQOhV1da4Ozvf/ZIebZzHDxGKgRH5mJLENXpgRaxsJIYzCkA
         3G5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793694461; x=1794299261;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=B6CEN+98TLk95Pbz6PoJyknaTEGQ0gqo4V17h4hhV6k=;
        b=PZIHVO9e9FfYyqHvrEK5PZNYbtm20okgqnLk0TMr6CuoPlooOf/bgkwqjnZ7gsIftH
         G/THHBFYMtQBgyL039KP1Cv0ULurOIkKRq+p4GIABPkHXwQRL7pCpuGjNN3GMJm/y9Qi
         yBObi2KUWE8u9Ljb4zIQ3cwUIpKt8ij6E3X1hfIRozmCXU6xol+6UcQFaPZflooOLgVp
         FnIH3dRUx9rJfu5HEg3pK8Oxb1PBXo4BM+gtedFa6ZCPJDEPGadlGK7OMxdAQ74ylhvu
         M7mSr2afFKGmtvsILMBSZOxQZFKx38bv1iD0ukBjBs8Xwzre85ray1BL7gqsdwv9M+Lf
         Zkig==
X-Forwarded-Encrypted: i=1; AKwUvByDaazEWHkOLRhZNQysU/orfPL0QdwSZzNMEwxMjs1+myqYOQHOvqH+Tyo9X9+x8ru1YQRVLFxzlQ==@kvack.org
X-Gm-Message-State: APuU4Z+3h5VzY8zjxyWjYClCJTQfMkiXqtTzkGElqelQhvcx6cfJ3V1G
	NmI6uVio5WxvhvS5JmurkAmWks7D7vOGqo1HFeDoFvqk6h9Va2nC61k6s5XFrrf46Q==
X-Gm-Gg: AYBFou0BJAlz2VPh8bYbt7Mj/pt4PNo+mZQRfFa57FzKk+WyPltkZNtncv1hRe3De5/
	kQ9mzws1glmGAR6c0ZDtwOT0xw0GNzFoUOa3vWJ/g086Diq8ngRCBdeTkhDMcO6wVkvudbm+GHK
	r4SDDWQk/u7I2WEcuGe+Qd5/9Q+oAOt5n9pRLabX6ZgQUhFeqr40rRdQ8spUBg17y6Fh5wltN3O
	SW7LtZSAz8zmyzJgi79nuETqc3icdqDZJFaD5FC7OrNVjdzjxZnIpZn4rnOrkexO1LXIbMifLHu
	oUTXlnglq+ZraqiasTq93IZataXbS4KO4aFgxNJHfkiNzbdTBbPaXRtb2/hPKi0DXLJj4MG3EkY
	KA02brCXuEnxn3ds6SSDFeYEbm997hfC5eKEn8FQYZTRgaaW61cftlov/uVKyPNljLZA6Ex5q5Y
	iIgEAQ/JnIf7T3MJeUosvOdiADKCLR8yqk/HB4fgwmrGw2vLLz0oJ/dPzpEppVuEyvPVgzR4MMc
	woPmtuP005fwlYdrvSrZeCwyHRHflXn6wYmqrjsuWy2DCEBbUswvu3gbo3x/CtjGotNaBMp4MIv
	EPLLUwRfpgA87ruclHja51TNP6JZOMQ6Y+27ko/iukSmaylXHY8krM6GO9A72zwJ1qfjCc7d7fl
	drMsfV7sxR5M9fGKS9d/N/YrfvkOmsASm+sffPYb2KwT9
X-Received: by 2002:a05:690c:d89:b0:8b2:26d5:7878 with SMTP id 00721157ae682-8b2b676a47cmr96699227b3.25.1793694460567;
        Tue, 03 Nov 2026 00:27:40 -0800 (PST)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b2b714bdafsm67833187b3.19.2026.11.03.00.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 00:27:39 -0800 (PST)
Date: Tue, 3 Nov 2026 00:27:22 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
cc: Alistair Popple <apopple@nvidia.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
    Brendan Jackman <brendan.jackman@linux.dev>, 
    Byungchul Park <byungchul@sk.com>, 
    Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
    Christoph Lameter <cl@gentwo.org>, Dave Chinner <david@fromorbit.com>, 
    David Rientjes <rientjes@google.com>, Dennis Zhou <dennis@kernel.org>, 
    Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>, 
    Hao Li <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>, 
    Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>, 
    Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>, 
    Joshua Hahn <joshua.hahnjy@gmail.com>, Kairui Song <kasong@tencent.com>, 
    Kemeng Shi <shikemeng@huaweicloud.com>, Kiryl Shutsemau <kas@kernel.org>, 
    Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
    Lorenzo Stoakes <ljs@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, 
    Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Naoya Horiguchi <nao.horiguchi@gmail.com>, Nhat Pham <nphamcs@gmail.com>, 
    Nick Piggin <npiggin@gmail.com>, Nico Pache <nico.pache@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Pedro Falcato <pfalcato@suse.de>, 
    Peter Xu <peterx@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rakie Kim <rakie.kim@sk.com>, 
    Rik van Riel <riel@surriel.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
    Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, 
    Uladzislau Rezki <urezki@gmail.com>, Usama Arif <usama.arif@linux.dev>, 
    Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
    Xu Xin <xu.xin@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
    Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
    Jason Gunthorpe <jgg@ziepe.ca>, Manfred Spraul <manfred@colorfullife.com>, 
    Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/7] MAINTAINERS: TMPFS (SHMEM FILESYSTEM) updates
In-Reply-To: <20261030-maintainers-v1-2-97278f8a5f54@kernel.org>
Message-ID: <b04d8d01-b42d-d948-b7b8-c360f8ec6002@google.com>
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org> <20261030-maintainers-v1-2-97278f8a5f54@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: mdqcngyh8mg4kdxihx8burqs6fgj8rzr
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-28.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 115E680004
X-HE-Tag: 1793694461-947484
X-HE-Meta: U2FsdGVkX19dOeSSC+/MuKa7YsuJ2+zVBSewlWbl9r5T0tLBBLob7UMrnQGj7rO3cHfMQJFGvrXotXPEyF3fB+PMbXo4anAet9PYL1OV3dK4OFiJ+sf8A87lSmFDnTo+ZCZdb5KjTpc86zCki92SrEqKe8ydi9x8cqPubqKR8CVeA5szGN2uB55VS+Bw3Qmw0ARhPFF64FXd7haN3u8M8MD2K0X2zzaftNSScJ/OglfoDSivFM3mCzuY8lqUlzBpaOerQoXM4XMEqjTWc3Ngkqjxp0Vclz2BBZlt1njsYJb2h99k4lzppAUw1fGEZfBlhhAwgtjlMUToQBIW77S/8QhfFuQ3rBgXip4ESopzxg2+NIB+1wWrppIN/OJajl0dgS5oGa6ngeq+al8WvB4DkTKPq/5n2r1/cRzQ6XkeVnt0u6xuVpCodFCw6Lmx3uidV75y5LDept7TKINHnp4uXxXNNYgjfRe64oWloeAkoQvMq6A5KpXbOBvwaKY97RTVyRt19j6/H/LYTOYZf2ZHVMX8hAa0JlpWkt1aR1eQWx+Tsn/wUaq85L6g1iu2OzEGQUtmxS3HcksZ0ObRTriXakOgnnaUcOFkdmNkg+NZ97PzlbZu8BtUHbZ6CqML2LcCpOEN9m1xA9OA5y2J2gn2m1ZewShZ4DziWAPJGZc9VP0jAxTZZk5Q1mH7ZaGIDzhPsigZ2gndA/6oy0wQzahAxwAzH+kN+NWgKSBdQ9htx1D5PJ+QyHoCmbbNrj6V1q3MR+B5HV21d4VGWxOTGkZKFFvTT3jopbEyPs846xYUAjSbyNJlIkrhKEU6BQyFtpbtOnaJBm/O1M87/0K3NGYMjHQaA6f6A30D4oJVb5HJSuZaI/3oW08BDAcXrSfscwaCeUsv1u51a7ckmlKktZdTnh/1PKRnsN9cM8BkRTJ202KNmsOULYhKLJL9+8NRd7+XzxQsJphYaCBoMBDtv62
 Y2T5eTia
 QSqeEaAqUx6sm1hsfiHar/mhYCFMweVWuSIE+kl9Aa+Mdl0Xx3YbvEDuF1kRWTPOHrbIr07rCLkTu2yfDmJe/Zr3Fovwv6tbtWEVYTw07vFixAFFKZs2MBviWwk1N9llAaESZ4iiz3FMZ4lAGxcSpVHH4YD2vGX2SFa3vg4xu64Q4fN0gm0bW2uNJGaAM2EdDRHW2qYFqPvoeLXdjYBSSN7mokyczbiQsOo1sCmhdvZmY1kFjrGBGCvGr/OZEBmwS1coO0J4If5zkwIekYBnMKlff283UtgT1ZVaAIRb0MYtgraoJH5VHKSFx3zFpaPX3wB7afEx++/0PUhBIg5CC4SUlcf6oOCgw3E0RWB/1D8iv2wH6l6ExgS3lozTl+bjN3peIXK5Nupyg4AmqGK6yzMG4EE7MFkFvyq69ks9kOBcEMM1FfFfedjGSqJx/L+NhnN4S4+gha5t/2mUT+Q91zUsaRmgElSJxzzu7MjKzju1yjjsqE8OgTybcIDomGiUgbYl43Pn+CiHREY4OLhrWZUKE1evrrc0MSQETHiGgM9CJkJYdBoN3SjItF0wjpOMt3W5MOAU5D8QOGZG7i5f5eUYInA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 30 Oct 2026, David Hildenbrand (Arm) wrote:

> I am not really the best shmem/tmpfs/memfd expert around, but it should
> be good enough to judge when something is ready to be picked up, to then
> pick it up. I'll have to heavily rely on Hugh and Baolin on judgment
> for the more involved and more controversial bits.
> 
> Rename "TMPFS (SHMEM FILESYSTEM)" to "MEMORY MANAGEMENT - SHARED MEMORY
> (SHMEM/TMPFS/MEMFD)" and move it accordingly. Add myself as a MAINTAINER
> so people know whom to CC.

Thank you for taking this on, David. And thank you of course to the
unlisted Andrew Morton, who has been uncomplainingly filling in for
me year after year; and thank you to Baolin too.

"SHARED MEMORY": should ipc/shm.c be added to our list of files below,
as mm/memfd.c is? (Though both can also go off to hugetlbfs instead.)
Or do you prefer to regard ipc/shm.c more as a client of mm/shmem.c,
rather as drivers/gpu/drm is?

We don't often have to touch ipc/shm.c, and generally ipc/ is well cared
for by Manfred Spraul (but I couldn't see a block in MAINTAINERS for it).

> 
> Add mm/core.git as the target git tree. Once shmem becomes a high volume
> component we can dedicate it a separate tree and have dedicated people
> pick it up.

Okay: but do keep in mind that tmpfs is a filesystem, and often the
FS folks make small adjustments to it, which usually go unconflictingly
through Christian Brauner's tree. That generally works well, so please
let's keep on working in that way (just once I remember holding off
intended MM changes to shmem.c for a release, while FS were busy there).

> 
> While at it, add some more shmem/tmpfs/memfd related files+directories
> we missed so far.
> 
> There is also "kernel/pid_sysctl.h", which includes some of the pid
> namespaced sysctl vm.memfd_noexec. But that's really more of a proc/
> namespace thingy, so it's not a good fit here.

Agreed: if I ever heard of it, I soon forgot.

> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Hugh Dickins <hughd@google.com>

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

