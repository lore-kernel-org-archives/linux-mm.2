Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53A99606A31B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 15:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D3i4qVmA
Received: by kanga.kvack.org (Postfix)
	id F1F666B097F; Thu, 22 Oct 2026 11:44:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAAB16B0981; Thu, 22 Oct 2026 11:44:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBFDF6B0982; Thu, 22 Oct 2026 11:44:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A75436B097F
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:44:22 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 18C911C0D0D
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:44:22 +0000 (UTC)
X-FDA: 85350683964.04.1131634
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 75C411A0006
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:44:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D3i4qVmA;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792683860;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FQNoDGzEIRA1SKlEsB0k8OEtsPm86udTUByyB+9XNMk=;
	b=qcMJXBDiHxsxgeofOMCTV/TYZZSiZAwdkgYLUkU8WaQDy/19f2jufDqeVOLsiSQ0s+Bo5M
	+maFwg8Ev5RfhHXN8RWCrWC1Bcj8jSijLuUvVz0ND8/GPXkpk4u3ibhv/U7Ak/FOR/s6w5
	mN8CVnJe5lfbDx19rok6M/qEKYJDNiQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D3i4qVmA;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792683860;
	b=KPt4R6xSWH54lIveL6LBhvx/dZEE9YgRM4kt3qwr80fm/6K3L8fwSPTStm3IXfvaVlu5Fa
	71GGYS2Tqj3Ock7R9x1A0yVQazoOm3uwwsV6bPkBqQBM53xg1vc2gtD5dL161GDD/p82OF
	x2Ti9+16lSpxwUeBNWkuHV5V0SdCtcg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C37A043D42;
	Thu, 22 Oct 2026 15:44:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8E31F031E1;
	Thu, 22 Oct 2026 15:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792683859;
	bh=FQNoDGzEIRA1SKlEsB0k8OEtsPm86udTUByyB+9XNMk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D3i4qVmAKJMU1NOTSbYoqzcCWpAmDrHWsUE0/fqlfQIbyHJve9e5H7Qa7wFAr9Ixp
	 seu/Q5PVFm93fPjSZZ3NOUZYEmmLyQEZjOKaBfWl8M3RH4gWw0gxd/EG5QGKuxSyHI
	 NVfsh2ce2tEoFgxZQDPHJufxQLgXbpSo5z/4V4frVQ+aGcVYBoOp0bZU1WkLkHA/Ha
	 LYcZaJg9Hcwmst8WGDnnCniWa9DIOB7cN5QutcAtmJe9PSxllVmVdAPSyRr7V09wax
	 adC2VeJ+ceHt9D/uo0DZb42BKeR7xQxAscUKcC8jicNx2hfSIadNfp9fYiAu6Ibb8U
	 9sjFTcmGonjug==
Message-ID: <sashiko-outbox-181720@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 4/8] security: dma-buf: Add dma_buf_charge_cgroup
 LSM hook
Reply-To: sashiko-reviews@lists.linux.dev
To: "Albert Esteve" <aesteve@redhat.com>, "Tejun Heo" <tj@kernel.org>, "Johannes
 Weiner" <hannes@cmpxchg.org>, =?utf-8?b?TWljaGFsIEtvdXRuw70=?= <mkoutny@suse.com>, "Jonathan
 Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Sumit
 Semwal" <sumit.semwal@linaro.org>, =?utf-8?b?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>, "Michal
 Hocko" <mhocko@kernel.org>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Muchun Song" <muchun.song@linux.dev>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Benjamin Gaignard" <benjamin.gaignard@collabora.com>, "Brian
 Starkey" <Brian.Starkey@arm.com>, "John Stultz" <jstultz@google.com>, "T.J.
 Mercier" <tjmercier@google.com>, "Christian Brauner" <brauner@kernel.org>, "Paul
 Moore" <paul@paul-moore.com>, "James Morris" <jmorris@namei.org>, "Serge E.
 Hallyn" <serge@hallyn.com>, "Stephen Smalley" <stephen.smalley.work@gmail.com>, "Shuah
 Khan" <shuah@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>,
 =?utf-8?b?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, mripard@kernel.org, echanude@redhat.com, media-ci@linuxtv.org
In-Reply-To: <20261021-v2_20230123_tjmercier_google_com-v2-4-ef6ee2dd8c5c@redhat.com>
References: <20261021-v2_20230123_tjmercier_google_com-v2-0-ef6ee2dd8c5c@redhat.com>
 <20261021-v2_20230123_tjmercier_google_com-v2-4-ef6ee2dd8c5c@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 15:44:17 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 75C411A0006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: hrnj1qasw35je6md9h6j8qxdz8416d6f
X-HE-Tag: 1792683860-315561
X-HE-Meta: U2FsdGVkX1/mLJA6p/bBAC2s9SDJTMuyswpGvGUaAgpxCppnfIfIhJKZpufwg4GhZLneEdXGl/UtNF9BQPsiyaCHZjj0sPE3kItMSAwm5VKVMgZM/Z5J4ayfN9Z+IQMtf40UJJJvugGHz5vzidbQKlS40+23w6ERS2a2NIT0xgcfceUY099H4BNlYHdtFdAsPI8nfEGZuAawIWBd10r4LqKJchRYLDl5M4fY8I1dA+qs5auBJEAwa5CnzmiiHVORcUsOB4d7cn2EPOjRYVMOlPrLNc9OTcuXfONMbDEdKG8IM7OjWr2wlf2CSFhtnHT9vaNEvabyzady/akvrqaFrfbxQxy+IyK4vTBvzjsZg9vkT2vjdr7nmzVTVbFhMEJPft2PE9ROGpYO9Mh908i9wdrJSjbKKyrifri+kOphDKr1Nwy4e8S78E7UDi09PYGKHSnJAJfTFfp1YLEx+Ax2HNmLJbJUdzodADM6j6vlNeIn2Dh/wI0SSYsJEZ0VGDggeBC3eYA6uBg9AeXHBavJCA6UYvGAMPm1mHxHGZVU5VarBySxI1SWyYhWr0SnlWsj7Xxr2uSHebAweV7KiW80pvX1LQCSH7QWiPxArydTdRAJzqnKueVp2Wk1Yg8c51Oq4spfCUtxV+cu5nU2Fifyk9B/4DK1IM8bdRO9Wib0ElOnehNv4FJeFvxTLCL9MlRdjtNDXQidvnudbr3BddR4wxrLZkIjL92aDL0Tgmn3HVdMhjyk5FkXrzct8JAEUswm29uxiUTIC82KU2sO7uSpSvtpL8G3BeeeBBg55jv/uu/tFAgzt9jJpTKglyP2RND6CnF7TCZGaJKpz3tyjCMNDmhxgaXWYd7xDdl1hxN550uM87KvkcQmTZ2Kcr1y1BummrvqeSEZGzY/rMYrddPOW8ujbzWxr3Mqy6+YwY940ETov0ByoIqEe72I43xjfEhqx+lAt4WdXyr8fpVzEnf
 h82FdylJ
 7jwG8blEp66skXnOjWpYQuDTQmpDH6TixNzO1THP+35VaWvPduSzML4i67O1L8WALDeRZ6VaWy4/EwrpauXFi9O0x2uWMCDmITV9Jzz3Q8vteo98zryiDXP5GRMuPfhYGM4+Q2Y4MR7t5eOHozNYF+jckwYeXYBheOhU7nxX0UHNOdLcLuF0QHf35O8KaN1LPCxB/ZzSF5hQexSKKF4PnP7aUQnNpOZMl9gvNmP14ZHn5bshgEgXK6QAR8hIAxExP7rH1ab9KgkLy35F0wJfmA1yS8ha0/amPFLC8K6+8VUS3mT2s2jIc9ydUMp/Tf8+Yk74HQlV0C98v5phv4Is20J9qWvYx8mRhvK/pHmYBuOcCVsnOmQs3Ixbwq8rqyt9m+BpTDT+O0AH5144473QINKHvv65FqxW1liI3Q+t7lVw6A2IUaYKSH6t7/KiB6beKMSEQk49M1DcKBMR0XxR1u3jQnMzU4i7FWoq3QfVVQbGbegiwsIvpTi4nilWSUqWvkI+9NbTuWY/oeMqBipi4jnUTi7xgvFG+z2qyZB13w1H0ORNo//PSkDNcr4W3JlaQm2A15jr7roHFt8gMYzP2wqwJ6vkkJ9Y+jVWdgHg22CuJU8y7d6BOQJrVSbxwMnguyC7KI7Vk59tEsI1YgRkIcaHmdH7fcI9JgF+Ih5G/1s+OOEWvnIVfrhYEH9PCbIZvPLr54E0r9d1mf2Hzi8R5JoeqVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] dma-buf: heaps: build failure in dma_heap_ioctl_allocate() when =
CONFIG_MEMCG=3Dn
- [Medium] dma-heap: missing __padding zero check in dma_heap_ioctl_allocat=
e()
--

commit c7d9f1c9769a263b2541e4535f61a1da114ca74b
Author: Albert Esteve <aesteve@redhat.com>

security: dma-buf: Add dma_buf_charge_cgroup LSM hook

This patch adds the security_dma_buf_charge_cgroup() LSM hook and calls it
in dma_heap_ioctl_allocate() when charge_fd refers to a cgroupfd. When
CONFIG_SECURITY is disabled, the hook compiles to a no-op inline returning =
0.

> diff --git a/drivers/dma-buf/dma-heap.c b/drivers/dma-buf/dma-heap.c
> index c315739178867..e06131f4655d8 100644
> --- a/drivers/dma-buf/dma-heap.c
> +++ b/drivers/dma-buf/dma-heap.c
> @@ -115,7 +115,13 @@ static struct dma_buf *dma_heap_ioctl_allocate(struc=
t file *file, void *data)
> =20
>  			memcg =3D mem_cgroup_from_css(css);
>  			rcu_read_unlock();
> +
> +			ret =3D security_dma_buf_charge_cgroup(current_cred(), cgrp);
>  			cgroup_put(cgrp);
> +			if (ret) {
> +				mem_cgroup_put(memcg);
> +				return ERR_PTR(ret);
> +			}

[Severity: Medium]
Will drivers/dma-buf/dma-heap.c fail to build when CONFIG_DMABUF_HEAPS=3Dy =
and
CONFIG_MEMCG=3Dn (or CONFIG_CGROUPS=3Dn)?

In drivers/dma-buf/Kconfig, DMABUF_HEAPS only selects DMA_SHARED_BUFFER and
does not depend on CONFIG_MEMCG or CONFIG_CGROUPS:

    menuconfig DMABUF_HEAPS
    	bool "DMA-BUF Userland Memory Heaps"
    	select DMA_SHARED_BUFFER

In dma_heap_ioctl_allocate(), the cgroupfd path introduced earlier in this
series ("dma-heap: charge dma-buf memory via explicit memcg") and updated
here unconditionally references cgroup_get_from_fd(), cgroup_css(),
memory_cgrp_subsys, css_tryget_online(), and cgroup_put():

		cgrp =3D cgroup_get_from_fd(heap_allocation->charge_fd);
		if (!IS_ERR(cgrp)) {
			/* charge_fd is a cgroupfd */
			rcu_read_lock();
			css =3D cgroup_css(cgrp, &memory_cgrp_subsys);
			if (!css || !css_tryget_online(css)) {
				rcu_read_unlock();
				cgroup_put(cgrp);
				return ERR_PTR(-ENOENT);
			}

In include/linux/cgroup_subsys.h, SUBSYS(memory) (which declares
memory_cgrp_subsys in include/linux/cgroup.h) is only emitted when
CONFIG_MEMCG is enabled:

    #if IS_ENABLED(CONFIG_MEMCG)
    SUBSYS(memory)
    #endif

Additionally, in include/linux/cgroup.h, cgroup_get_from_fd(),
css_tryget_online(), cgroup_css(), and cgroup_put() are only declared inside
#ifdef CONFIG_CGROUPS and have no stubs when CONFIG_CGROUPS=3Dn, unlike the
helpers in include/linux/memcontrol.h.

Should the cgroupfd resolution block in dma_heap_ioctl_allocate() be guarded
with #ifdef CONFIG_MEMCG?

>  		} else {
>  			/* charge_fd is a pidfd  */
>  			task =3D pidfd_get_task(heap_allocation->charge_fd, &pidfd_flags);

[Severity: Medium]
Also in dma_heap_ioctl_allocate(), should non-zero values in
heap_allocation->__padding be rejected with ERR_PTR(-EINVAL)?

Earlier in this series ("dma-heap: charge dma-buf memory via explicit
memcg"), struct dma_heap_allocation_data in include/uapi/linux/dma-heap.h w=
as
extended with charge_fd and __padding:

     * @__padding:		reserved, must be zero
     *
     * Provided by userspace as an argument to the ioctl
     */
    struct dma_heap_allocation_data {
    	__u64 len;
    	__u32 fd;
    	__u32 fd_flags;
    	__u64 heap_flags;
    	__u32 charge_fd;
    	__u32 __padding;
    };

When a userspace process issues ioctl(heap_fd, DMA_HEAP_IOCTL_ALLOC, &alloc)
with a 32-byte struct dma_heap_allocation_data where alloc.__padding !=3D 0,
dma_heap_ioctl() copies all 32 bytes into kdata and calls
dma_heap_ioctl_allocate(file, kdata). However, dma_heap_ioctl_allocate() on=
ly
checks fd, fd_flags, and heap_flags before processing charge_fd:

	if (heap_allocation->fd)
		return ERR_PTR(-EINVAL);

	if (heap_allocation->fd_flags & ~DMA_HEAP_VALID_FD_FLAGS)
		return ERR_PTR(-EINVAL);

	if (heap_allocation->heap_flags & ~DMA_HEAP_VALID_HEAP_FLAGS)
		return ERR_PTR(-EINVAL);

Because dma_heap_ioctl() zeroes trailing bytes when ksize > in_size:

	if (ksize > in_size)
		memset(kdata + in_size, 0, ksize - in_size);

legacy 24-byte ioctl callers already have __padding zeroed, whereas 32-byte
callers can currently pass arbitrary non-zero values in __padding without
receiving -EINVAL, preventing __padding from being safely repurposed in the
future.

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021-v2_2023012=
3_tjmercier_google_com-v2-0-ef6ee2dd8c5c@redhat.com?part=3D4

