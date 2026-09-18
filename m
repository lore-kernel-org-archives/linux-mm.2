Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C26A2C982D9
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:15:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95E2B6B0095; Fri, 18 Sep 2026 06:15:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9364F6B0096; Fri, 18 Sep 2026 06:15:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84EE86B0099; Fri, 18 Sep 2026 06:15:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6558E6B0095
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:15:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 228F7C05CC
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:15:26 +0000 (UTC)
X-FDA: 85226475852.07.F8E6FAE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7066D80002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:15:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CYMe2VxQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CYMe2VxQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789726524;
	b=ACJ6d5eBTkLodX+f7p6CHp4OK/xV66aBBX7gZdBOY9c2r6Ti9kpC/RQNKR6zCoqi+oRZZx
	JpPPFDndKodc0obKypf+Ii4DjJPdwrcNTK5Tmt6YKlRAduiRYpvJFNsN52RkeHkysksLVh
	efn9P2dgSce50T8CoTJ0ZbFNxDGkSV4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789726524;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iiUFRlHhVLGHO4P1JeUzTqnMBZGqjCg6ljFaVKDtmKU=;
	b=HbYpy05U8hh3gCkSK3l2fEddCdlkpaX6ipUJyG0PE4jCABCxaAVP+WsHab+9g3cyXvtcrl
	L0xuTw/Lr6SWbbpimoEz2tkIjpUhGRaCJU1twa2n0byPZW9Oc7Xg9KRgvaSMz2U9KgOQ5S
	eTlpANszx6xqF4HqkGLZt0gX8PYefuQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C2E2F41B02;
	Fri, 18 Sep 2026 10:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48821F000FF;
	Fri, 18 Sep 2026 10:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789726522;
	bh=iiUFRlHhVLGHO4P1JeUzTqnMBZGqjCg6ljFaVKDtmKU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CYMe2VxQKqjM48Qh1JiWT2P3UEJVuCac8ysLzJ+dZag32Ft9bAVcpGOMZ4HScYKSA
	 LrzLpuhoEMI3GtAYTsLW4jh/gRtnUoW+N9rRyYlYOyTXKJIrjz1QkFNSAmTri9KxtQ
	 YgAizPYMs6Pk+zAZ7x1uzNN3yUFr4LYNxPNrUJBDLylaSStamwvu6mgyHmTx6JLyky
	 SPUYmfalqSRbW2mY7QLXGTOAMq7KZrFu0mnGpoTqq6Cjx1Umnw5Hk54MIt5dBLGeyO
	 rCce++XRc1mltvKKrrut+TtgQ5n+bH85UTxblml2GEicEU8TJBSTEJtZaIOC4yTjcM
	 xr7wJo3WI5ZMg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 04/17] arm64: kexec_file: Fix CMA page leaks in
 segment placement retry loops
Reply-To: sashiko-reviews@lists.linux.dev
To: ruanjinjie@huawei.com, graf@amazon.com, gshan@redhat.com, pasha.tatashin@soleen.com, catalin.marinas@arm.com, tglx@kernel.org, pratyush@kernel.org, ruirui.yang@linux.dev, linux-arm-kernel@lists.infradead.org, bgwin@google.com, palmer@rivosinc.com, mpe@ellerman.id.au, hbathini@linux.ibm.com, hpa@zytor.com, sourabhjain@linux.ibm.com, robh@kernel.org, adityag@linux.ibm.com, zhangtianyang@loongson.cn, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, guodongtai@kylinos.cn, linux-kernel@vger.kernel.org, linux-mm@kvack.org, me@linux.beauty, x86@kernel.org, ritesh.list@gmail.com, eric.devolder@oracle.com, "Jinjie
 Ruan" <ruanjinjie@huawei.com>, blum@kernel.org, coxu@redhat.com, rafael@kernel.org, jbouron@amazon.com, rppt@kernel.org, tangyouling@kylinos.cn, maqianga@uniontech.com, sshegde@linux.ibm.com, kernel@xen0n.name, dakr@kernel.org, thuth@redhat.com, seanjc@google.com, npiggin@gmail.com, vishal.l.verma@intel.com, chao.gao@intel.com, liukexin@kylinos.cn, piliu@redhat.com, linuxppc-dev@lists.ozlabs.org, takahiro.akashi@linaro.org, kees@kernel.org, baoquan.he@linux.dev, james.morse@arm.com, yeoreum.yun@arm.com, dave.hansen@linux.intel.com, driver-core@lists.linux.dev, ardb@kernel.org, gregkh@linuxfoundation.org, leitao@debian.org, chenhuacai@kernel.org, kas@kernel.org, loongarch@lists.linux.dev, mclapinski@google.com, bp@alien8.de, lizhengyu3@huawei.com, mingo@redhat.com, will@kernel.org, mark.rutland@arm.com, maddy@linux.ibm.com, chleroy@kernel.org
Cc: kexec@lists.infradead.org
In-Reply-To: <20260918100442.3841135-5-ruanjinjie@huawei.com>
References: <20260918100442.3841135-1-ruanjinjie@huawei.com>
 <20260918100442.3841135-5-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 10:15:18 +0000
Message-Id: <20260918101518.D48821F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 7066D80002
X-Stat-Signature: k7xy9io8jd9rpyrwwy7w5ay6bkx4d3fi
X-Rspamd-Server: rspam01
X-HE-Tag: 1789726524-687069
X-HE-Meta: U2FsdGVkX18FG6YYjZkthbyukYIhBzjNfM/yQ2DLKEruYW7DcZVKi02bU/vb1D48uydEZHzmbJwNNuBnzVOGDdwuCfiNMkESUoVQyAB/gs2hSqfmIZNf/7DdFKFh7S7hgkjIsfj2HSfyWNst+Fb+auMJchssLn5Iu12YeT0TW+ymwoNDDvG2FZZJRUPYMiE/IAu1I8acQ8G/b43+UCwSHkedXD7P8i+ALLn1p6b3coiF9VTvgV0RQtxa8DX7ScAFCiZrWXNS6KZSZmLzOdY9XolOfCylMlJFwC68n22IWmnam3oVfC9a8g+hGj0SV0Hmk78vfcz9ab6qXKBFuVl/uo69GvdNL/MQpbN277eoxoJ2CqD7RPDAOO48oka3EB8U9+Hhk3e6nBMuaEysj8M8zmr0xO7l3Aw63gTS9TT+Jn9MOy21az4thuvX/X7NgsZXxywjeXQMUwkZR+TMHOZ6j+Wz0P9b801OdMYJ0YadaMkFbChP5N8KJ7vltwbJCZoaj7ywWdHOxQldV6BmeB2U8G0irLsouL4LIM3p/+6DJynAVgyJpWNWR1lkoqIpDQQ56tLt99M+XpjOBxELoSU0Vk8oo7AYiq3YVNAXWjqXIJarwQ1k8Z/SErTr7BWrIMZ//xLfeVy2D+JY//dOOlh8vehhmfI+W1v7h/VQ4ns/kK4BJe66LJRB34HNqNI4oJiZeQp4H8K3kfaUPfrSH5UHV/NhaYAwcD7dMTK3PHYFUEqNrOM1KVrZtXSxzBCVwSRLLQX5myVtF40gX2IANcYUxkQnDibb3Lkdu4U34Anceg1KTJOiuFw4nDbdEscKaU8yng99Fq42SXBdl7qUVlf4+x9MbS33tMXueyZ5knDn7LOcg80H+1+UB//0jkEqN2ztLLgtGgB9kKuLfMjS4birRJ37boxkvtkqK/sVY81nn34bJXyCch0aqUVMO/wMhip5enmjTKrwbPx0KQzc4h2
 nIAJ6tGJ
 8h52LE21aryZcgOj7M4FLleBIhpHxc3RY25K0bwB3u3KTRNaLCmvxMVrvHRUj4N+woW/HFdLJ74OSqP6wm+SWOEYJ8mj8AI57p98/re42XNbcyg6im8yUtCfHkNsiKh8fxljFFjP7D2i0JBW2q+EopX+vS2VXimIYcpuOL4hX8qnWe+UxnKcxXccTexFjL682YbhQd6LnLJhk+zF2SNV6EhI1Q1REfTAus5vUanLHGgS9gsEILpzXMvCbACfJS7l5omYMNKfBBXCLHmYe0GX5HRX7rFRxRFy+/vA2OngCQmds1akHuLIYO107IvWyX39NrmOq1IvFuYHT5taRTBUWuNE4kmUmdKQxwq5EK1BG+4mIC1hExb3EAxq69Ca6aAOrtaypLRPqvDD/R51VWNNhiauN0WkqNn/AeR3sOaQ2K7fIjkNhtJpewelbjHDtlVxjskL8d7IZUiASBcLxXZY8jdP8f5Be4kifn/dNJwOMICUXdJgm4exZd+/xNoHW7bUAs6B/LW5u91oSnREPScyHkI7b2nUI4osp5UDdrAPcxVY83FRuaviDRZNjeX8vcG1JCv+XxmdEbs7SbaO9FtbP46OISNHYBFIQqG5wrwpr1ITvLsb3AcioYEv4q4tVOjfsetSkQs67MsoXgTwepeu+SLxNhYvP+c9UNrBHdVuPv0HwmeP647+PG6JrDNV1ffiJo0BuTshxHXl8/ilNpJwlcFz8LvXt6FSHTkFCacQokYZXG3gyoBsQFrAPPe0BNa5YXKPyw+0ANf+EL2Mqn5e18Dh/Pn7a2lZjQYTGXUaStzCB8YiRWZYgnNugF604WZatb4GA6U63/y27D0aJvQEemadAQwuS2WsEs5GIRQwdfZ1VaqFL7YXaj9RasUVWgSzmaKWhEITUbPz4MIj4JZ53I8JQ6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> During kexec image placement retry loops, any midway failure causes
> the loader to truncate `image->nr_segments` back to its initial state
> to purge the failed segments.
>=20
> However, this truncation introduces a memory leak. The CMA pages
> allocated via kexec_add_buffer() during the failed attempt are tracked
> in the `image->segment_cma` array. Because the subsequent cleanup paths
> only iterate up to the truncated `nr_segments` boundary, these allocated
> CMA pages outside the new boundary are permanently leaked.
>=20
> Fix this by explicitly releasing the associated CMA buffers in
> the failure paths before `image->nr_segments` is reduced.
>=20
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Breno Leitao <leitao@debian.org>
> Cc: Pratyush Yadav <pratyush@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Yeoreum Yun <yeoreum.yun@arm.com>
> Cc: Baoquan He <bhe@redhat.com>
> Cc: stable@vger.kernel.org
> Fixes: 07d24902977e4 ("kexec: enable CMA based contiguous allocation")
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918100442.3841=
135-1-ruanjinjie@huawei.com?part=3D4


