Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 890C6CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 21:27:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E41A18E000A; Fri, 19 Sep 2025 17:27:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF1CF8E0001; Fri, 19 Sep 2025 17:27:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE0288E000A; Fri, 19 Sep 2025 17:27:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B69BD8E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 17:27:02 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E538F877CA
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 21:27:01 +0000 (UTC)
X-FDA: 83907285042.04.AE6CB60
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 37DE61C0009
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 21:27:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OR7bCl9B;
	spf=pass (imf21.hostedemail.com: domain of stefanha@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=stefanha@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758317220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/kUNBbkgUP7UkdLkjt7gNAUDoEAUE2pfBTAUAT+0Q90=;
	b=ykUs9meqNDmuLaJrG6QkN5kKN7PuF0cHjgibuXeA8tl4SpdBXtQ5NASSXtn6L3dgyarBRi
	3vE+1iMCUEv90pfWSNWswHF/kRtqJTVcvGJmvRv2MKpVYyMPVukAYXrD4jdmCNApuhgRCq
	XAnJkVxnoZIE0GT/PoSgzlTLJyWgghY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OR7bCl9B;
	spf=pass (imf21.hostedemail.com: domain of stefanha@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=stefanha@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758317220; a=rsa-sha256;
	cv=none;
	b=MYPHqhaQ3q0fYbrJ1gmAc5froPsvjWme/LQUJ8VxMhzV/ebJ2fNbsSOttBfz4ZlKc2xruB
	vbbZpvo77qDVMCy7CY705RC76h9GQtkqyv+kSWC9P+AR5niiE1H+hSvDTTcq8p1+7eegek
	WZoIwgD1o4nhjd8fTtd3tmJM1sOBg8E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758317219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/kUNBbkgUP7UkdLkjt7gNAUDoEAUE2pfBTAUAT+0Q90=;
	b=OR7bCl9BxF27TcnWXm348zmnilEZJ2ifKBlJqApsbzHxD3ZUo2r3X3pERYfyr62Y8xby2+
	hALphsx5WOfvSMZti4QG2wHxKHilZQc3mS1iabTZE+AafTC3NkFA2Pw6i1FZWT9I+okyLz
	PEEwkgrEw4i6uMI/GC9HQJD10IJN21E=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-660-Z8c109b3MmeDkNukUh-YgA-1; Fri,
 19 Sep 2025 17:26:55 -0400
X-MC-Unique: Z8c109b3MmeDkNukUh-YgA-1
X-Mimecast-MFC-AGG-ID: Z8c109b3MmeDkNukUh-YgA_1758317214
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7256919560B5;
	Fri, 19 Sep 2025 21:26:53 +0000 (UTC)
Received: from localhost (unknown [10.2.16.43])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DB9B7180035E;
	Fri, 19 Sep 2025 21:26:51 +0000 (UTC)
Date: Fri, 19 Sep 2025 17:26:50 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, pasha.tatashin@soleen.com,
	Cong Wang <cwang@multikernel.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [RFC Patch 0/7] kernel: Introduce multikernel architecture
 support
Message-ID: <20250919212650.GA275426@fedora>
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wJMNkTvE9gcHAHlx"
Content-Disposition: inline
In-Reply-To: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 37DE61C0009
X-Stat-Signature: sft93enwyui569kmzunijuowf479xqj7
X-HE-Tag: 1758317220-237606
X-HE-Meta: U2FsdGVkX19vBKE/dED7E+3vbvUpGCfeyVt9KHMpCoNZqkc1A/+sb5Oajuw/cNmlwsmYraa/CQbaF+elKsuk+v02Ki+yeKuc75L1WXi3osGbg0wSVCvoMSX7yuDQvz3UJoJFm9YuLCzUrsRtwsdXeWH0Ekp60TjHKtpYFoa5l3iAZ1tPWd9hZeUVNQXqTB8+3Az4UW40RBnAUqx4fT94LQUbL1Y9z6mVCmbHFLeJogpYPEN4CyLRkmKsJCjzoXSZTjqnweHO3DxX4f+2nzHGfXKg9PV//CLw1FfNcKFsY2JLy+jAlvBAebcM70F5HOoxYejTy1XwS+5ldNqjwEDVXTbeAiOAWYZ8d4TxxOW/jlpOxmyRslrRXvLy4AImxl9N7OSPzLZIJbsHj3mxhN4Eir5IhgyS6oiqkLVy68sFot3RHufhTVN68e8MJeLrQ96UaurHt64uX99oBsoFu3jNXkPgKK0Vm4toJaXVOcy7jND1nApmBquffgIQppjGPp4FOZ/JzVyY+bMGXF6AmkxJms9qqlD6UzgilTEuIgx3gQzftJP6Gq8FaBAETO3XpN2rdFEFasL7vU2OI0gPxcH+BCj80Wn/DTgqmTjeDw2uErgmQi+iEm5mXP6ESBzmwkYdUn3+1Ta9cx8VzWPNrFQ9iVBhBY6y/mzfyBRh/+qZh+/emgU9h6pSIk2hHEnGmNZWRckox4jcKQ/A8511yKQvgqh1FBRN3KfeQo8VUyf/wmqbezs2uCNvIY014637otNf4Fai8/vs+6LPT1V+/53g+Ef1dyRKibfQrit58Nhlq2X7lPmwG9uA+vAIfuZvB97hgKkSDSiTjMlnyWmXxbnVNYVlrPZokCcrOF1SfKtbv+SV2/h/sGKXG1MydBrFTLP7La0Spkb8/a+BK5rCLXIkNIVUiR+b/iZhy22ATPXVTy713g4TdTv/DdqsCeiJR/lvqyiQcqczMjmIX6gIDMg
 DKkPiuha
 cOQ4ScXS1NO6vbpk3N5ARUR4ZN6z5sU9c5iUkAT4jiU3ulPzelORC5xwxwKhzpueTbUYCzdWyQ2YYLr1uPxRSuKMfby478fKhSDLYsiRsupnbO6DtrABOfXfS2mDIVuzYnTQ+JIqZmhaGpjfjzhZJN3CCxk2ckrwYemjXiSMPEdpCaQoeIFKiRRkr1QRUTIJoP3MOnfC9iL2uEI0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--wJMNkTvE9gcHAHlx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 18, 2025 at 03:25:59PM -0700, Cong Wang wrote:
> This patch series introduces multikernel architecture support, enabling
> multiple independent kernel instances to coexist and communicate on a
> single physical machine. Each kernel instance can run on dedicated CPU
> cores while sharing the underlying hardware resources.
>=20
> The multikernel architecture provides several key benefits:
> - Improved fault isolation between different workloads
> - Enhanced security through kernel-level separation

What level of isolation does this patch series provide? What stops
kernel A from accessing kernel B's memory pages, sending interrupts to
its CPUs, etc?

> - Better resource utilization than traditional VM (KVM, Xen etc.)
> - Potential zero-down kernel update with KHO (Kernel Hand Over)
>=20
> Architecture Overview:
> The implementation leverages kexec infrastructure to load and manage
> multiple kernel images, with each kernel instance assigned to specific
> CPU cores. Inter-kernel communication is facilitated through a dedicated
> IPI framework that allows kernels to coordinate and share information
> when necessary.
>=20
> Key Components:
> 1. Enhanced kexec subsystem with dynamic kimage tracking
> 2. Generic IPI communication framework for inter-kernel messaging
> 3. Architecture-specific CPU bootstrap mechanisms (only x86 so far)
> 4. Proc interface for monitoring loaded kernel instances
>=20
> Patch Summary:
>=20
> Patch 1/7: Introduces basic multikernel support via kexec, allowing
>            multiple kernel images to be loaded simultaneously.
>=20
> Patch 2/7: Adds x86-specific SMP INIT trampoline for bootstrapping
>            CPUs with different kernel instances.
>=20
> Patch 3/7: Introduces dedicated MULTIKERNEL_VECTOR for x86 inter-kernel
>            communication.
>=20
> Patch 4/7: Implements generic multikernel IPI communication framework
>            for cross-kernel messaging and coordination.
>=20
> Patch 5/7: Adds arch_cpu_physical_id() function to obtain physical CPU
>            identifiers for proper CPU management.
>=20
> Patch 6/7: Replaces static kimage globals with dynamic linked list
>            infrastructure to support multiple kernel images.
>=20
> Patch 7/7: Adds /proc/multikernel interface for monitoring and debugging
>            loaded kernel instances.
>=20
> The implementation maintains full backward compatibility with existing
> kexec functionality while adding the new multikernel capabilities.
>=20
> IMPORTANT NOTES:
>=20
> 1) This is a Request for Comments (RFC) submission. While the core
>    architecture is functional, there are numerous implementation details
>    that need improvement. The primary goal is to gather feedback on the
>    high-level design and overall approach rather than focus on specific
>    coding details at this stage.
>=20
> 2) This patch series represents only the foundational framework for
>    multikernel support. It establishes the basic infrastructure and
>    communication mechanisms. We welcome the community to build upon
>    this foundation and develop their own solutions based on this
>    framework.
>=20
> 3) Testing has been limited to the author's development machine using
>    hard-coded boot parameters and specific hardware configurations.
>    Community testing across different hardware platforms, configurations,
>    and use cases would be greatly appreciated to identify potential
>    issues and improve robustness. Obviously, don't use this code beyond
>    testing.
>=20
> This work enables new use cases such as running real-time kernels
> alongside general-purpose kernels, isolating security-critical
> applications, and providing dedicated kernel instances for specific
> workloads etc..

This reminds me of Jailhouse, a partitioning hypervisor for Linux.
Jailhouse uses virtualization and other techniques to isolate CPUs,
allowing real-time workloads to run alongside Linux:
https://github.com/siemens/jailhouse

It would be interesting to hear your thoughts about where you want to go
with this series and how it compares with a partitioning hypervisor like
Jailhouse.

Thanks,
Stefan

>=20
> Signed-off-by: Cong Wang <cwang@multikernel.io>
>=20
> ---
>=20
> Cong Wang (7):
>   kexec: Introduce multikernel support via kexec
>   x86: Introduce SMP INIT trampoline for multikernel CPU bootstrap
>   x86: Introduce MULTIKERNEL_VECTOR for inter-kernel communication
>   kernel: Introduce generic multikernel IPI communication framework
>   x86: Introduce arch_cpu_physical_id() to obtain physical CPU ID
>   kexec: Implement dynamic kimage tracking
>   kexec: Add /proc/multikernel interface for kimage tracking
>=20
>  arch/powerpc/kexec/crash.c          |   8 +-
>  arch/x86/include/asm/idtentry.h     |   1 +
>  arch/x86/include/asm/irq_vectors.h  |   1 +
>  arch/x86/include/asm/smp.h          |   7 +
>  arch/x86/kernel/Makefile            |   1 +
>  arch/x86/kernel/crash.c             |   4 +-
>  arch/x86/kernel/head64.c            |   5 +
>  arch/x86/kernel/idt.c               |   1 +
>  arch/x86/kernel/setup.c             |   3 +
>  arch/x86/kernel/smp.c               |  15 ++
>  arch/x86/kernel/smpboot.c           | 161 +++++++++++++
>  arch/x86/kernel/trampoline_64_bsp.S | 288 ++++++++++++++++++++++
>  arch/x86/kernel/vmlinux.lds.S       |   6 +
>  include/linux/kexec.h               |  22 +-
>  include/linux/multikernel.h         |  81 +++++++
>  include/uapi/linux/kexec.h          |   1 +
>  include/uapi/linux/reboot.h         |   2 +-
>  init/main.c                         |   2 +
>  kernel/Makefile                     |   2 +-
>  kernel/kexec.c                      | 103 +++++++-
>  kernel/kexec_core.c                 | 359 ++++++++++++++++++++++++++++
>  kernel/kexec_file.c                 |  33 ++-
>  kernel/multikernel.c                | 314 ++++++++++++++++++++++++
>  kernel/reboot.c                     |  10 +
>  24 files changed, 1411 insertions(+), 19 deletions(-)
>  create mode 100644 arch/x86/kernel/trampoline_64_bsp.S
>  create mode 100644 include/linux/multikernel.h
>  create mode 100644 kernel/multikernel.c
>=20
> --=20
> 2.34.1
>=20

--wJMNkTvE9gcHAHlx
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmjNypoACgkQnKSrs4Gr
c8jDiAgAg+cJ1RtnT6VtPZ4iFMdU8taG28VItTHeoGu8v+SDyVctvyYYKUHpmW1x
YZGWILjIz9LhjSqbVktIdavzMa/cGZBkWz6oWEdeEu0+uIUarlX3xQnSxSaHP9Js
anZypzajok9Byzw7uQBHs2piynVAUEo34cMwq0jEGFXj817RLsx5mObptUJEFpgE
mo3h4uzt6Pn8ASWpYve3zdr1TgpafXg1ljHoYpSR3CXjaUWfD1ycpFFag/k9l9Qv
XPpGN8iviPGt5BwMvIvlMRKlc3vVg+l7wFwiunZpJ8ehsVh+Sj23ji0HKVNS94X5
0kD3uiFZX97QuMHLzUX6QlNNzFyQNQ==
=3ZjT
-----END PGP SIGNATURE-----

--wJMNkTvE9gcHAHlx--


