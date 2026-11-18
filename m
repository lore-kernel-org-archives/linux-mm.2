Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A594A60A260C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 13:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DGPTWsj1
Received: by kanga.kvack.org (Postfix)
	id A9A4A6B05B1; Wed, 18 Nov 2026 08:38:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A77E86B05B2; Wed, 18 Nov 2026 08:38:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 988186B05B3; Wed, 18 Nov 2026 08:38:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 767FC6B05B1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:38:46 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 12F8980780
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:38:46 +0000 (UTC)
X-FDA: 85448345052.28.5C674E4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id C605618000A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:38:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DGPTWsj1;
	spf=pass (imf16.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795009124;
	b=g4MYIWR/4rTMV8Zov8vh+NId11HiYkYkdVbt26I2apJc+Bw3FLwcRu/p/APqGm8RTXO9iu
	MKZKD4hra4idiutuEiN4UewAohDoNuQFmWq0tel83vhOLmNQ3+ZMELUguxdSAu15Vd8BeM
	HvQD/psbxIDV2k8jSjYxMK4cNxqmi1Y=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DGPTWsj1;
	spf=pass (imf16.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795009124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h50xYCZDbBstrT/18dKKndyJ3XtJH6sY5/J/QnXGpDQ=;
	b=NCoOMsY2E73iQDT/Mhc5Ia6tUqnn50cFnXcsWpHzyBkqs/Qorx3a2krYhw4MTgJepYfbT1
	Xig2FtwqUG+j/M8typwiCjsZODeyUvmyj8lD8MWLqD3iCJdsDEuiBTbdMbcgY9/sKfloGJ
	3VF2Opz6SC32FM8vqMJlnG2x2SHx8RE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795009123;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h50xYCZDbBstrT/18dKKndyJ3XtJH6sY5/J/QnXGpDQ=;
	b=DGPTWsj1tcK7BHakniQKRg5wXJb+lKnVxEXj7BGYIhDdMMYbwh2Wr4/0Q49v/m3qW/dsds
	PXzd7CI8GoGaxh0JFgxa6zOio0f0IZ5MVYE9tBbnaiArvxV89Y8rW+ZKtFnlw/19nIqn4Z
	OXySadyFXfPUeMnq2XHkraGwVLEvGSw=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-Sa3qIZ1jNhmAdZ7V7P6Pyg-1; Wed, 18 Nov 2026 08:38:41 -0500
X-MC-Unique: Sa3qIZ1jNhmAdZ7V7P6Pyg-1
X-Mimecast-MFC-AGG-ID: Sa3qIZ1jNhmAdZ7V7P6Pyg_1795009121
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-8b18c67095dso13268867b3.2
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:38:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795009121; x=1795613921;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h50xYCZDbBstrT/18dKKndyJ3XtJH6sY5/J/QnXGpDQ=;
        b=STRtgJiVA6mDTRWezY6yTvUYdE9zi3I4i6ZTzmJzBJMgVZOlEAbuL7ExS4fdu7Qjtg
         ArHiHqGFFzfMX82FotktshDALRJo+sVakXxC4FCpZ/iyYcmdVp8tVUfwgq5Sr4Mi7QUA
         /Ey+xUsoN84Za0olrxlIht6LvjVa/6HlqH4W1eY0g+aw7dTXN4nI0bXmiMv7/MXnj8MO
         aoL5MYv8MP0Qg67PWCDnP4AF7q58LecpkuYmv2fSJ5tR5HlzMU4HDWfi7XwnBoyCeVf7
         KkeFX5FrdG03qdNSHb2P8Kc2z0OlZuLlyBNGGERbsMpu4/qBAuC+W888rufiv2E5NgRt
         MuUg==
X-Forwarded-Encrypted: i=1; AL+hErFp1DZL7UcmXKhxQL/VvDSf/B+EECjzqMXLOiljneiEQtrbhLOCYIMsqBoge4rxNrf4t6MkSvvZOA==@kvack.org
X-Gm-Message-State: APuU4Z8vaxqp9PryHRqpz8Y0l9mifgF/6BLCmDVslY99u4WqwzrXP0U7
	F1ovajPdlOR8HOHinIBbtglYZr/m4wFV12aJONzlkuoGYLFmxIjs+m5GNnQ0Ppmy7ta1tkDUjn0
	nBX8TIP7H79iKm1CyN3ZAYmmu5RN5/xBwaXMg2jQ84VhSWOo8K51g2er09JUv/3f6SmYJTGYIgP
	bAB6yMznWJxpn1R6RSIe1tYke+CDA=
X-Gm-Gg: AZFdTZcje5tq1DhwvhJmBQf9gtMdccw8FP+bPHyrLAVRCY4+eE3lsEA+3Ykzcng4eiP
	/vkDiuAywvVqJ8LTae+nJbFQ7TCBIrVEw95Lx6ttJOu/mnSHBNJsLvMvzjhWe82zd2jfHeqJnDC
	oja5+tHuJQob08GpqxIQ7kkjIGxFwPfl3W/K49eIjibfqHAcrC/rqmHsSe
X-Received: by 2002:a05:690c:368a:b0:873:5bb2:6bfd with SMTP id 00721157ae682-8b4fed83351mr10018277b3.39.1795009120759;
        Wed, 18 Nov 2026 05:38:40 -0800 (PST)
X-Received: by 2002:a05:690c:368a:b0:873:5bb2:6bfd with SMTP id
 00721157ae682-8b4fed83351mr10017817b3.39.1795009119849; Wed, 18 Nov 2026
 05:38:39 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261117-v2_20230123_tjmercier_google_com-v5-0-1ce975f2a9ad@redhat.com>
 <4356992ac4fb7876fb5759189ba4b492@paul-moore.com>
In-Reply-To: <4356992ac4fb7876fb5759189ba4b492@paul-moore.com>
From: Albert Esteve <aesteve@redhat.com>
Date: Wed, 18 Nov 2026 14:38:28 +0100
X-Gm-Features: Aa3M54php6hihR6Ihi3l34Ri9nQdKaLYB3Ss2kJeRmi5f3v9ab0vBjDa0q2nnvI
Message-ID: <CADSE00JyTwrbNh4r8PZWLqOHWpepyHkaL+9fkc+AbVRmCc-f-g@mail.gmail.com>
Subject: Re: [PATCH v5 0/8] memcg: dma-buf cgroup accounting and charge transfer
To: Paul Moore <paul@paul-moore.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
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
	Philipp Stanner <phasta@kernel.org>, airlied@gmail.com, cgroups@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, op-tee@lists.trustedfirmware.org, 
	echanude@redhat.com, mripard@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UEvegdD0cRpXyO0zDaACPo-gBqcQzE0ODwjH59kK2FQ_1795009121
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C605618000A
X-Stat-Signature: bntqnw4dncjep3rb3diqfo9wyzec4tf6
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795009123-374880
X-HE-Meta: U2FsdGVkX18aOpQPNFABnGJ4c5IjdjmdNG+4WEVMr8MOCjb7/qlCkrsT1W3QU4g0gNYawIdAptX9nxhWjny7dUchmy56+BrTUVq9D/oi30ZtrT0clxBsj6neGzERnp+B400NuFD6jw9PFof1V5x6Ls/M5UwwjXgp2ylzHPcGplwjAGaWW2foNCBB9GtDer2IIfdGAJaHoHdyvf9Bg8PpeBZ5bxBP3dVIpPSosVjfngwN+YLwJVOLyhL8IiPM/3BBqV2ZotYKHtau799BAxoaWoedWVahYr8P3zhoucjqjMb4XWkmueGEKqvsV0opK/Kv/bAYjDJHTo0f6+Ui6qZt40lxbvX0IeFH7QKmf0KGm4xxmGN1gHLCN8jagXauXo4C55mZiooVyEwlWHiwrnVPnYP5sEi/4kfY5c4y8fp+ZvZ9OcSSyXNC9o1cw+mkFUdkOYOdWdrOtcLk69lSV9W5ENW2d9Qerjc0sxAkQ8MCOT2d4+hKvaQyZuzN1pDuh7CLcTQln1bIjiogw3c21UFg0oxlJPYpSCYOt1eztLLzKcWGWHbSmxsuUIMxhH9qpQU4NFEwgQnAaRM0gcL0W9QbG9tvl1lSMkrTY8vWJnBV0QIzn+0e6ILKyJCB5k1C2GNbPEDnxEIoiP/0l9HWXyLGNqHt7CasYII+YoUKMWJd+hR3UC4dbclqk3LtNUme28t1L5DxOzJrRuJ/DE5/ltnj1G3uwBu4w+0Ou+Lmu7CVqEa88hM9OmgveOqohPmx2T/UPquDhgqZO6pIcHLxqa61CuaIIA32fYRTvqLIsDmsvrxIG7Tbac2IkkJ7yG4NLKIX7SL1ydmXF51nuaRy7m3K1kBcC448mBh0a10ud3JZFym78nDL4MJib9qJKF3dZJSYtaxc+TfvtD9rHEJlbjBUnlqefkFL+vLzhyQz2LzJYZtkekuReW5aB3HAyVDvIH/I2CVA/adhYrbREKt2uQb
 t877zric
 rvWn51syWL5xkfb+tAt48Bj/3+qBsRFEfBZhRpjJEqx9r9+fHR7wNnZfBy2c/xgbfRZyzkUQtzjgj4Dadt+TaEg5zl/l8g521yZnap+QWE0PElpbptjcdAVQ2Rsn9Db91DMVSdJKKFToJFHg4GUWDgnoZE0APysVZChU63dqSHYYNIcmvEgWDBPKzsWpTdQk/7iSqqqW+c+RlxXgKg2vb7Be7nKHEBU5Gp7GiOZMJgjFs/1D1tH4bLAUCD+m5E4L3VZqHroqxUyBQ43awnIdFJ+dcJtFw66GCLvNp6NeTiY+EOj59yPx5IQdwMvHiJ7sXoIzodi45wkdfyEj+HRFIy9oE/YT6ymra2O/+QLMfywBYwGNGiFtRA5Gf+Dej1MvhNn10B+836Qc0r26Vo6cnjntquF2KKpjrt7mHDxLKO/132+81RO08y/JUkmd7bAplR/7lLH1sFEV3QBe6Jh9cS5w0R+OYOXtBxYNkK1VP0/SPUVfm2vJ7/D/3qM3K1lGTWy1a+ClKeN3sX6MZ0f8S27/gMTK6raqs9RR/gIcYl3Kh9DA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 11:54=E2=80=AFPM Paul Moore <paul@paul-moore.com> w=
rote:
>
> On Nov 17, 2026 Albert Esteve <aesteve@redhat.com> wrote:
> >
> > Shared-memory allocator services (e.g., Android's gralloc)
> > allocate dma-bufs on behalf of client processes in different
> > cgroups. Today those allocations are charged to the allocator's
> > own cgroup, leaving client cgroups with no visibility into their
> > actual memory consumption and defeating resource limits.
> >
> > This series adds memory cgroup accounting for dma-buf allocations,
> > building on T.J. Mercier's earlier series [1] and incorporating
> > feedback from previous versions and LPC discussions [2].
> >
> > Patch 1 introduces the MEMCG_DMABUF stat and the
> > obj_cgroup_reserve_dmabuf()/obj_cgroup_cancel_dmabuf() and
> > mem_cgroup_commit_dmabuf()/mem_cgroup_uncharge_dmabuf() helpers
> > in mm/memcontrol.c
> >
> > Patch 2 wires up the charging policy: dma_buf_export() stores
> > exp_info.objcg and updates the stat, a new charge_fd field in
> > DMA_HEAP_IOCTL_ALLOC accepts a pidfd or cgroupfd to identify
> > the target cgroup, and __GFP_ACCOUNT is removed from system-heap
> > allocations to avoid double counting.
> >
> > Patch 3 adds DMA_BUF_IOCTL_XFER_CHARGE, a general ioctl on any
> > dma-buf fd to transfer charges post-allocation. This covers the
> > double-hop allocator case (SurfaceFlinger -> gralloc -> kernel)
> > and works for buffers from any exporter that opts in. Charging
> > is gated by dmabuf->objcg being set at export time, ensuring that
> > transfer is only applied for buffers backed by system memory where
> > size reflects actual bytes. If the receiving cgroup lacks capacity
> > for the charge, the ioctl returns -ENOMEM and the original charge
> > is preserved.
> >
> > Patches 4-7 add access control for cross-cgroup charging. Letting
> > userspace decide who to charge needs to be a privileged operation
> > because it has material impact on OOM decision and resource limits.
> > Charging outside the caller's own memcg subtree requires
> > CAP_SYS_RESOURCE. On top of that, LSM hooks gate the two charge_fd
> > flavours: security_memcg_charge_task() gates the pidfd path (target
> > identified by task credentials) and security_memcg_charge_cgroup()
> > gates the cgroupfd path (target identified by cgroup directory label),
> > with SELinux implementations using process2:charge_to and
> > cgroup:charge_to permissions.
>
> I'm probably misunderstanding the description here, but in both cases
> (the pidfd or cgroupfd case), ultimately the cgroup is charged, yes?  In
> the cgroupfd case it is more direct, but in the pidfd case it is still
> the cgroup associated with the process identified by pidfd, yes?

Your understanding is correct here.

>
> If that's the case - and it very well may not be (!) - it probably makes
> more sense to combine the two SELinux access controls into one.  Yes, the
> LSM hooks and callbacks would likely need to be different due to the
> mechanics of it, but the permission check "cgroup/charge" could be the
> same.

Combining SELinux access controls makes sense to me. I kept them split
because I wanted to preserve granularity between the two flavours, and
process2 seemed like a natural fit for the pidfd path, but I guess it
can still be achieved with a single permission through the target
types.

I'll rework for v6. So, in the pidfd case the check target would
remain the process's domain:

   allow allocator_t client_t:cgroup charge_to;

where allocator_t is the domain requesting the charge (i.e., the
central allocator), and client_t is the domain of the process the
pidfd refers to. The groupfd path would check the cgroup directory
label like so:

  allow allocator_t cgroup_t:cgroup charge_to;

Would that be ok?

>
> > Patch 8 adds selftests. The tests and vmtest script were mostly
> > written by an LLM, closely following the style of the surrounding
> > tests and the virtme-ng setup. All code has been reviewed and tested.
>
> I think we need to have selinux-testsuite tests to go along with
> this, especially as this would be the first patchset to add cgroup
> controls.  Historically I've pushed back on piecemeal cgroup additions,
> pushing for some basic design of how to manage access controls for
> resource management first, but since evidently no one wants to do that,
> we really do need tests.
>
> https://github.com/SELinuxProject/selinux-testsuite

Agreed! I was already playing with it between the last version and
this one. I have some tests drafted, more or less. I was unfamiliar
with the testsuite, so instead of offloading the work to an LLM, I
tried to follow along and proceeded too slowly.

I will link a PR when sending the next version.

>
> > Known limitations:
> >
> > - Single-owner model: a dma-buf carries one memcg charge regardless
> >   of how many processes share it.
>
> Once again, I'm sure I'm misunderstanding things, but are you saying
> that multiple cgroups can end up sharing the same dma-buf despite
> only one of the cgroups taking the accounting hit?

Yes, you are correct. A dma-buf (its fd) can be shared by multiple
processes from multiple cgroups, but only one holds the charge. With
this series it can be transferred, but never shared.

Sharing could be a follow-up series. Perhaps splitting the charge
equally? But sharing is a big problem on its own, so I preferred to
keep it out of this series.

>
> Hopefully the charged cgroup is deterministic?

Yes, the charged cgroup is deterministic: it is set at allocation, and
only moves via an explicit ioctl.

>
> > - Only memcg accounting. CMA heaps would additionally need dmem
> >   controller integration.
>
> Do you have a rough idea of how that would work?  I ask only because I'm
> interested in seeing if that would require an additional LSM hook or if
> there is some way we could leverage the same hook(s) used here.

Rough idea, yes. Today, no dma-buf allocation charges dmem at all, and
of course no target charging either. The first goal for CMA is simply
getting those heaps accounted. In that regard, Eric Chanudet has a
series making CMA allocations memcg-accountable with per-area counter
[1], and is working on extending that approach to dmem. It's a bit on
hold waiting for the feedback on this series.

But afaik the cross-cgroup charging and central allocator problem is
mainly a system-memory one. Whether dmem ever needs the same
cross-cgroup attribution (e.g., DRM central allocator wanting to
charge clients' dmem budgets) is not clear to me.

Nonetheless, if it does, the internals should be mostly the same;
everything, including the permission checks is controller-agnostic.
Only the controller performing the charge changes. I expect no
additional hook is required.

[1] https://lore.kernel.org/all/20260821-cma-memcg-regions-v1-0-d21b165b844=
0@redhat.com/

>
> > - If a transfer of an uncharged buffer fails, the buffer remains
> >   charged to the original cgroup. The allocator (userspace) is
> >   expected to handle this (retry, free, ...).
> > - The LSM hooks are intentionally narrow. Broader cgroup access control=
s
> >   (e.g. for the memfd/kexec handover case [2]) could be a separate effo=
rt
> >   reusing the same pattern.
> > - Only system heap sets exp_info.objcg today. Other exporters
> >   (DRM, V4L2, etc.) can opt in by setting it, but are not
> >   covered by this series.
> > - Related to the above: lazy backing-store allocation is not supported.
> >   This can be extended later, e.g., by adding a flag on the dma-buf
> >   struct for explicitly marking when memory is committed.
>
> Similar to the CMA case, any rough ideas on what this would look like?

Yes, again I have a rough idea. We already separate reserve and commit
operations, so the idea is to delay when a charge is committed. For
that we can use a flag in the dma-buf struct to mark when the memory
is committed. The limit is still enforced up front (so a lazy exporter
cannot overcommit), and the stat reflects the actual allocation.

The permission model is also unchanged for this case. The flag only
affects when the stat will reflect the charge.

Thanks!
Albert.

>
> > Note on TTM/GPU accounting [3]: that effort charges system memory
> > allocated for GPU buffers per page, with its own stats (gpu_active
> > and gpu_reclaim). This series charges at the dma-buf level, for
> > memory with no memory.stat category of its own; exporters whose
> > memory is already charged by their allocator must not opt in, so
> > the two do not overlap.
> >
> > [1] https://lore.kernel.org/cgroups/20230109213809.418135-1-tjmercier@g=
oogle.com/
> > [2] https://lpc.events/event/20/contributions/2416/
> > [3] https://lore.kernel.org/all/20260706052330.1110909-1-airlied@gmail.=
com/
> >
> > Signed-off-by: Albert Esteve <aesteve@redhat.com>
>
> --
> paul-moore.com
>


