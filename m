Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94151606A8A8
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 22:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.a=rsa-sha256 header.s=google header.b=A2y7TeVy
Received: by kanga.kvack.org (Postfix)
	id 914616B00EF; Tue, 17 Nov 2026 17:54:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C5196B05B0; Tue, 17 Nov 2026 17:54:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78E106B05B1; Tue, 17 Nov 2026 17:54:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4633E6B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 17:54:52 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BCF43405EE
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 22:54:51 +0000 (UTC)
X-FDA: 85446117582.09.F0F550D
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf03.hostedemail.com (Postfix) with ESMTP id DB4CB20004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 22:54:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=A2y7TeVy;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	spf=pass (imf03.hostedemail.com: domain of paul@paul-moore.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=paul@paul-moore.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794956090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k7/QLUvYDzH8xZxy3OOm+8SYpFBmpzd+eC/ISXSLxiA=;
	b=lKK1mWN2tDuZQna2H5i+pUbkKITol8wFw2VvK8+FV/JdPYa5Hi4O2ZsAJ0yV4D2rzBNMKn
	mzL/eFoOtEA5L2S6ZfcyZASYlr7MC90qAac0XZH43E558GxFc/dCmn0VYwp4gax3ru5Jd4
	2eczaKzilXKopzC+0XRGRAiqHloJlac=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=A2y7TeVy;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	spf=pass (imf03.hostedemail.com: domain of paul@paul-moore.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=paul@paul-moore.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794956090;
	b=1pS+DlnN8mU/zFG+kKzC9kRggBWwWAKJNBD+yYvXfFftxIk3pbaUZ2bsqVNRkCjmrsiPJV
	ppuw/wywS30nMPQDtGXtmmH+XVWLHRMd/h4aPf4XQxjIgTRST/7sS//uREAAnrJ7YoIrVV
	iGzbkcqRoTF9osIM7Th5rmHA0612vgg=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-91e7af9a67fso1361376d6.2
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 14:54:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1794956089; x=1795560889; darn=kvack.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k7/QLUvYDzH8xZxy3OOm+8SYpFBmpzd+eC/ISXSLxiA=;
        b=A2y7TeVyWe4PThPzXFlHTqVKa+iAArhGH3yrzNOrfBr+1sZiz/zYfV4XlaJmZh7lQi
         nw1HMbF0NuAMVDA1IPLkYHz/WF53ruYxC847qsIFqToMLB+hlizHRwGXlNF/RrvjFtb0
         jLkSgFSV0nBHNalX2VBxgJUYcBGGEDbeG/sv9KMTVb3T7z2lnBLS4+O3IUfHAoq4yzRN
         fnwoREGsBnroFN1s0Q1Nt7tY1aIYopabPSMKyfeKAetyKWG+b4hji6IFr02Ze7NXcnVC
         2GOiCu+fnllb/UHUVBYZ5S0YXCR9sj513lZfdayRNt2yP/URlhUCPQlCU8v9WFQCfxqK
         suWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794956089; x=1795560889;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k7/QLUvYDzH8xZxy3OOm+8SYpFBmpzd+eC/ISXSLxiA=;
        b=Yq4YVxlWNYIUl066BR1GpAjuIhWvrLt4Fzt6tUnBupFr1sQoBGce0KudJbmwjgT607
         8CF7HK3RKaoaqyeOGvJqK8w4OnNOcOMZVKzsP3X16ldaTmIj6/Vf3RKLETjkQA8IQylM
         WeV0bRDD0dZMlvUjFcUUJwryFpwngtJNxUgg6nn5Oh23jJ3hNXTrApFVudCW+4QnDo5j
         qO0AN3QqCuYtBpQK9KEIolc6z1vxiiYNxHAzZ9C+EgrJQmgXczMQJntmIOf2s52pzFI5
         IiCYQK1LgjTRHysEu/ALrbgJmcAjtxkS9HxaDTJqVuUwTV4H87oPt9LaEPKCp3aM9ZpI
         i4Bw==
X-Forwarded-Encrypted: i=1; AL+hErFLkZBwz9GcceBOorfSDbQTirvxSoM//pCSHmRweEhdzhjOKptWExwV9J/gmWJD0u4XAHvrf9ujLg==@kvack.org
X-Gm-Message-State: APuU4Z/G5h62m3drJt9TF4VXC5n5vvLV0PQhnrhuuqMmjgvlXqAGSu1/
	etpvdxoOT9xmOIMqUODdI6Rk90QZRZyA+yg+Hr/MA3u+VBE50w10D1Sum2kOyXLZ+g==
X-Gm-Gg: AZFdTZcxkTOM8IgOhbvD++mwqjd+7M0FZr10EHZgYsn25F4VmAHyc0K1aLHJoKyzGB0
	vXgVMOzveLHWekTN8rufioXjOUisIALjJLGTg/CI1XLAUGVVV2M8V/BrPT9vBZEthsVBuXdU3Ia
	P++vjGsMphYQPWrmDj7mbFzJk8FJtdDqWe3IuWnAEp6jJuayOfWwk+ykNjgv8o3ggVMWU8AHcRS
	S3DYvdcg/6CPV9ItNNSdubFVZ8+UkKWo7xwXpfbjFDUT8b4bxfA6NWeYPnZYFX4AueYXmEtDflz
	pfn3xq1WRtsMQeJLKlt9zHq5eVbRdfvh82/gWP4bP4dOnlBiqwHgB9daulLkLvuC+R36eydeulR
	IbsDQ4L1iFWSlLP2clA4/9B+XV9SEtj0rKbVCLHcJlVRZ10pz8Zhs9YenRFIKsxaG9wpOxPO3RX
	OEC0Y0pGdaK6oFpBbit8zQ7h5Npw9jCoibaveLCEp3k27FAMupWtwiyN1kRUkoQ0V2o6OVM4Dtt
	xrnGxIG7nyMa/ih0YFEXp5A6tp1aQDhDMIPbko7TW8y0puw+j3Gz+mU951K9MYL/imX3oUZWgJG
	fPQGyqH8HVXfwSAHMxEH+3pKrWHlgU4zXdivIvPiZoUMafxKihsxUoelPeLg1aUxfiJZe6Ae8Lr
	3Lw1gcGTT6P4ktM7Wc65Ddmc2rU67cg==
X-Received: by 2002:a05:6214:4981:b0:921:9ed:ee6 with SMTP id 6a1803df08f44-92114dd0d06mr10225486d6.20.1794956088668;
        Tue, 17 Nov 2026 14:54:48 -0800 (PST)
Received: from localhost (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-92114d53b7fsm5495766d6.26.2026.11.17.14.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 14:54:48 -0800 (PST)
Date: Tue, 17 Nov 2026 17:54:47 -0500
Message-ID: <4356992ac4fb7876fb5759189ba4b492@paul-moore.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0 
Content-Type: text/plain; charset=UTF-8 
Content-Transfer-Encoding: 8bit 
X-Mailer: pstg-pwork:20261117_1552/pstg-lib:20261117_1552/pstg-pwork:20261117_1552
From: Paul Moore <paul@paul-moore.com>
To: Albert Esteve <aesteve@redhat.com>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	Christian Brauner <brauner@kernel.org>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Shuah Khan <shuah@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	=?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>, 
	Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>, 
	Philipp Stanner <phasta@kernel.org>
Cc: airlied@gmail.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, op-tee@lists.trustedfirmware.org, Albert Esteve <aesteve@redhat.com>, echanude@redhat.com, mripard@kernel.org
Subject: Re: [PATCH v5 0/8] memcg: dma-buf cgroup accounting and charge
 transfer
References: <20261117-v2_20230123_tjmercier_google_com-v5-0-1ce975f2a9ad@redhat.com>
In-Reply-To: <20261117-v2_20230123_tjmercier_google_com-v5-0-1ce975f2a9ad@redhat.com>
X-Rspamd-Queue-Id: DB4CB20004
X-Rspam-User: 
X-Stat-Signature: 8d3uu4rd4mbtjxgtk815mk9y94bqji8e
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794956089-589981
X-HE-Meta: U2FsdGVkX1/mpC5Sc8qgZ09/2LCJ1JxDzlzraROHqlZex8zf1Y9j082RQXFEss3R3wHr/efqYgBabto2UdFI/qHrAJT5i5kozzfjubCEJ7JKmAin0cGAgDMK2HxwgtPNKTLasOsuE6X1tS52daiF89Kxv6xMjVsE3disVX5nMe8vOEuS4Z8WWY/6gt4Sw9vdotYcY/sYtzeohWniVxCu4vMkIsdfHvUZUqzg5uSuVPGFEkoNTMLUPrfWjxwPPa+wumH22xL0ZFq2OUrpPJ1gjQdvUPyC4jO3Vw6PxccH/9CWBKB5AUNtNkHsYO8EGcw51kT4DDptrHE0xgfB7WXwhH39eFAEcndWMkr0DIKoMjfv251A3tqQQ77yHlFgFlURj850kTImSa9fU2LWpfhev6is6qaTRqgvAlW212k+kx4dMLK+iOS0djqR+aeLvOhbnjKXyIrCdezAMEcMp/HzzHjYowRRggH4z0M1EqgUVMUou66C1n/YCudak89vJFY4YKbd+xHn7mHyGD87+2Yim+O0Srn/wGkJIfzxQbCDctywEu7fcRu7/2BMEvsMtZk1eIhziFlyVD6DED/WbDFmQHXa2QtNDkMxDKoont7VcxE/e8u2jmcQCAEaBp5v47lNUrnFf1solyPA/DEVnnVGZ0HTELS0FjiGGl/D0NY5Sk95oA1ZmLRMnI+cH0+ZxV3yStedyrIfA7z9mS1EpHrEMcS5xeqncnZK0BbfIYzvwecvVEKFrySaUVG+uhxisAoFFVgesFq/7anQ9YoIHSIyshEksZBpQ5oo+OcxldHKG3+wiefZ3BvIwP+oDq9MEgMmZLdNZ2X+++nnqwaG5MtsC9meB11g4mUDj2eDXtKoRV5Nggshh+414BjEP5BGXjAUcj1Th7sSfkHcoozS4b1xE498lTbAUc8Az6YjaJ5bWU4yU+Z/nVs56SuwtlsCilAozjnxnmJXgqmJlCgds2P
 pfM3oudl
 nm6v1ou4ZOAlF0vfvO7fhTfypSvBcmm2GIWx5A03URUZFPoOKTWZ1AbDW+a11f6WXeRMfj7FMVo1Htt+DV8Gvb00tXuqlEe4yJBFpqqorl+UUJztflS0IsW2P5Oio2LqOoSCyB0E8ke0i55JEbTlA47/nlkK7S/cLx1aEmiJhdxbuOrIzVZVS0og/ZjZwEjjbgXhxG3x6royqMh/xrk4Ylb2eepq4Ivc6QQQP6j+krqJxfH2DvMNa3QEQuAm3ZG7hV5eSY/l8KpAcmyit5iCh2x5RrFLs1meV7X0aXV61uQaUdZ5WUpntyzRWqgWXRijbtio3ASKDJcy8512vhqtuk3jPWKjdgs5+M6KLlWpCI1qcy550SgC3vTm1MlyE8teFXNglz3OGT1D361AI7S4d+VRyxyRubgE1gcWIyraXrbYW/jwgmTpRTARZxOubbuD9wDJlvHhb7aps6iSCw5mMYEuNrZzpTLrSiMeNKvWEuIqjorvDQnftvjo3tS3yp8MsB/QuECGhgCX2JMa8zg8H11DEuNKB3NQLIDV4q9PVQDhkfMZoJKcZV8FoZFUuF6j3WqwUfL0hc32RtIhCVojURBQWNXbtg4LCwzJij9Yjm2LOKo0Eh0zXxrY1osquyEvb85OI3knBsm2q4LswJNSbe3xgyoU077AekzMeYhrAtK13CRZoNT4ITmsiqRsjMY4G1Ng5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Nov 17, 2026 Albert Esteve <aesteve@redhat.com> wrote:
> 
> Shared-memory allocator services (e.g., Android's gralloc)
> allocate dma-bufs on behalf of client processes in different
> cgroups. Today those allocations are charged to the allocator's
> own cgroup, leaving client cgroups with no visibility into their
> actual memory consumption and defeating resource limits.
> 
> This series adds memory cgroup accounting for dma-buf allocations,
> building on T.J. Mercier's earlier series [1] and incorporating
> feedback from previous versions and LPC discussions [2].
> 
> Patch 1 introduces the MEMCG_DMABUF stat and the
> obj_cgroup_reserve_dmabuf()/obj_cgroup_cancel_dmabuf() and
> mem_cgroup_commit_dmabuf()/mem_cgroup_uncharge_dmabuf() helpers
> in mm/memcontrol.c
> 
> Patch 2 wires up the charging policy: dma_buf_export() stores
> exp_info.objcg and updates the stat, a new charge_fd field in
> DMA_HEAP_IOCTL_ALLOC accepts a pidfd or cgroupfd to identify
> the target cgroup, and __GFP_ACCOUNT is removed from system-heap
> allocations to avoid double counting.
> 
> Patch 3 adds DMA_BUF_IOCTL_XFER_CHARGE, a general ioctl on any
> dma-buf fd to transfer charges post-allocation. This covers the
> double-hop allocator case (SurfaceFlinger -> gralloc -> kernel)
> and works for buffers from any exporter that opts in. Charging
> is gated by dmabuf->objcg being set at export time, ensuring that
> transfer is only applied for buffers backed by system memory where
> size reflects actual bytes. If the receiving cgroup lacks capacity
> for the charge, the ioctl returns -ENOMEM and the original charge
> is preserved.
> 
> Patches 4-7 add access control for cross-cgroup charging. Letting
> userspace decide who to charge needs to be a privileged operation
> because it has material impact on OOM decision and resource limits.
> Charging outside the caller's own memcg subtree requires
> CAP_SYS_RESOURCE. On top of that, LSM hooks gate the two charge_fd
> flavours: security_memcg_charge_task() gates the pidfd path (target
> identified by task credentials) and security_memcg_charge_cgroup()
> gates the cgroupfd path (target identified by cgroup directory label),
> with SELinux implementations using process2:charge_to and
> cgroup:charge_to permissions.

I'm probably misunderstanding the description here, but in both cases
(the pidfd or cgroupfd case), ultimately the cgroup is charged, yes?  In
the cgroupfd case it is more direct, but in the pidfd case it is still
the cgroup associated with the process identified by pidfd, yes?

If that's the case - and it very well may not be (!) - it probably makes
more sense to combine the two SELinux access controls into one.  Yes, the
LSM hooks and callbacks would likely need to be different due to the
mechanics of it, but the permission check "cgroup/charge" could be the
same.

> Patch 8 adds selftests. The tests and vmtest script were mostly
> written by an LLM, closely following the style of the surrounding
> tests and the virtme-ng setup. All code has been reviewed and tested.

I think we need to have selinux-testsuite tests to go along with
this, especially as this would be the first patchset to add cgroup
controls.  Historically I've pushed back on piecemeal cgroup additions,
pushing for some basic design of how to manage access controls for
resource management first, but since evidently no one wants to do that,
we really do need tests.

https://github.com/SELinuxProject/selinux-testsuite

> Known limitations:
> 
> - Single-owner model: a dma-buf carries one memcg charge regardless
>   of how many processes share it.

Once again, I'm sure I'm misunderstanding things, but are you saying
that multiple cgroups can end up sharing the same dma-buf despite
only one of the cgroups taking the accounting hit?

Hopefully the charged cgroup is deterministic?

> - Only memcg accounting. CMA heaps would additionally need dmem
>   controller integration.

Do you have a rough idea of how that would work?  I ask only because I'm
interested in seeing if that would require an additional LSM hook or if
there is some way we could leverage the same hook(s) used here.

> - If a transfer of an uncharged buffer fails, the buffer remains
>   charged to the original cgroup. The allocator (userspace) is
>   expected to handle this (retry, free, ...).
> - The LSM hooks are intentionally narrow. Broader cgroup access controls
>   (e.g. for the memfd/kexec handover case [2]) could be a separate effort
>   reusing the same pattern.
> - Only system heap sets exp_info.objcg today. Other exporters
>   (DRM, V4L2, etc.) can opt in by setting it, but are not
>   covered by this series.
> - Related to the above: lazy backing-store allocation is not supported.
>   This can be extended later, e.g., by adding a flag on the dma-buf
>   struct for explicitly marking when memory is committed.

Similar to the CMA case, any rough ideas on what this would look like?

> Note on TTM/GPU accounting [3]: that effort charges system memory
> allocated for GPU buffers per page, with its own stats (gpu_active
> and gpu_reclaim). This series charges at the dma-buf level, for
> memory with no memory.stat category of its own; exporters whose
> memory is already charged by their allocator must not opt in, so
> the two do not overlap.
> 
> [1] https://lore.kernel.org/cgroups/20230109213809.418135-1-tjmercier@google.com/
> [2] https://lpc.events/event/20/contributions/2416/
> [3] https://lore.kernel.org/all/20260706052330.1110909-1-airlied@gmail.com/
> 
> Signed-off-by: Albert Esteve <aesteve@redhat.com>

--
paul-moore.com

