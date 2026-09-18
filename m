Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD1E8C982D9
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:21:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01A796B0098; Fri, 18 Sep 2026 06:21:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F33E66B00A7; Fri, 18 Sep 2026 06:21:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E70D46B00A9; Fri, 18 Sep 2026 06:21:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB0F46B0098
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:21:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3A468A5E38
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:21:08 +0000 (UTC)
X-FDA: 85226490216.12.962F794
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7926080002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:21:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=VbhnGqJb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789726866;
	b=jIFh//8ZQSRoLJcwbNvpijXMa9qPz7E9CpxMxe+GMpwbeBtoN3yzKU0vMg4859665PzuGf
	+M947iNrBFBd3YtAQmGnz3HMp8jdSuwAvzemHtxYvUigXLhCxPzWDgn20FXSF+tQ184Qmk
	TMk/Vu5ZtQodcPW70xDpjjHc93W3x1U=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=VbhnGqJb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789726866;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ojRb2OtGZV+lNR54MP8W9kUbXEoKZ+Rzr9bvDWAKmSI=;
	b=oEikrVaVqrNFJ4bknGYzJUkjOl5YIei62nqVQ12s7MriJvseTkgvZ5/r92CDWc1jKQd5Ck
	SE66HKsuDTP3yauoldf3D9scbHyEKTQbwGC+7Jr6QuRVLrQg88c2V4/dS3azp584mpsyvc
	16whqv3GEK7UG+BS4ND+VykwghmWUYA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AB4B043BDD;
	Fri, 18 Sep 2026 10:21:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482D31F00893;
	Fri, 18 Sep 2026 10:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789726865;
	bh=ojRb2OtGZV+lNR54MP8W9kUbXEoKZ+Rzr9bvDWAKmSI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VbhnGqJbr+ybtK3Fnwjub4nxRMAkKMpEzatb5UyqR56xMFB6wzCkyGzg4dZWPmT3+
	 X+snAKFCSsw9hS3uDDtXyaV+a120iBx6doKN2SXy7kWsE6Ghr43NePclsslWz3X5jO
	 umM+Y1oZRe63NELb54DdiEkz9d+zMmZueH0FDcyiLWVV9cdWUYTG7WaCOZvG2X/7g/
	 a9oPJYB+Dy64zxGyUYebphSZ5ylo5LJpeevfZI8VBPaG8K99ZpvTAK5Kx+JWQnO/hy
	 0N1qcxBpGbuzeUsqKEcZ7LzQMrQi37y/VFurlQHxRKvV4Yc12NiNYAuI+ZMxmxdW8s
	 JCL5q8jJo+Sfg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 07/17] LoongArch: kexec_file: Fix elf_headers memory
 leak in retry loop
Reply-To: sashiko-reviews@lists.linux.dev
To: leitao@debian.org, seanjc@google.com, kees@kernel.org,
	thuth@redhat.com, tglx@kernel.org, loongarch@lists.linux.dev,
	will@kernel.org, hbathini@linux.ibm.com, rppt@kernel.org,
	akpm@linux-foundation.org, chao.gao@intel.com, hpa@zytor.com,
	guodongtai@kylinos.cn, takahiro.akashi@linaro.org,
	maddy@linux.ibm.com, pratyush@kernel.org,
	"Jinjie  Ruan" <ruanjinjie@huawei.com>, zhangtianyang@loongson.cn,
	lizhengyu3@huawei.com, blum@kernel.org, x86@kernel.org,
	eric.devolder@oracle.com, catalin.marinas@arm.com,
	ruirui.yang@linux.dev, me@linux.beauty, adityag@linux.ibm.com,
	ruanjinjie@huawei.com, vishal.l.verma@intel.com,
	mark.rutland@arm.com, sourabhjain@linux.ibm.com,
	linux-kernel@vger.kernel.org, rafael@kernel.org,
	chenhuacai@kernel.org, pasha.tatashin@soleen.com,
	palmer@rivosinc.com, ritesh.list@gmail.com, kernel@xen0n.name,
	robh@kernel.org, dakr@kernel.org, james.morse@arm.com,
	mingo@redhat.com, tangyouling@kylinos.cn, mclapinski@google.com,
	linuxppc-dev@lists.ozlabs.org, linux-fsdevel@vger.kernel.org,
	jbouron@amazon.com, sshegde@linux.ibm.com, graf@amazon.com,
	bgwin@google.com, bp@alien8.de, linux-mm@kvack.org,
	chleroy@kernel.org, piliu@redhat.com, maqianga@uniontech.com,
	gshan@redhat.com, yeoreum.yun@arm.com, coxu@redhat.com,
	mpe@ellerman.id.au, dave.hansen@linux.intel.com, npiggin@gmail.com,
	baoquan.he@linux.dev, kas@ker.kvack.org, nel.org@kvack.org,
	liukexin@kylinos.cn, ardb@kernel.org, driver-core@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org
Cc: kexec@lists.infradead.org
In-Reply-To: <20260918100442.3841135-8-ruanjinjie@huawei.com>
References: <20260918100442.3841135-1-ruanjinjie@huawei.com>
 <20260918100442.3841135-8-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 10:21:01 +0000
Message-Id: <20260918102102.482D31F00893@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7926080002
X-Stat-Signature: wjgkz3p511eb5exaqskuh5gret9p9rxs
X-HE-Tag: 1789726866-146826
X-HE-Meta: U2FsdGVkX18c3B2NyqclW6bFMjbMCk5LUlGeXAV9zaJKrxT6y/9f8y7bvtTkPLK41ZyJCJU52gkfjgFKpwZTqhh5MYgw4kA6UsruMcObMtGUSJxe2HqXX5TW4tLS6XdodUrRRFhUGgXnFcy6J93iwiIjgV3FST8iBCelPjF4zv2d0tPdkDcAVdcJRU9mS5H7JQU6Tgft9KZYdEU91o+vCEC6GjjtmM4DT/xYZKXD/QaNWI2EaU3fHoPNPqItHo0L/DTdYZe4rpcXGn2y2NumqflD6dQnDYr4u0jyrrckMGrgnWHVzV0R2vi8aBdPbW5wZCCHi1T1sVJxOJhpTotYsnqdp9lJlW9GkFdz093hcmTTIqt0Q00t3cnZzAlFTtEWjHA3qqwBplAdtj/ggjKF/PltLNcJ1AYCA3ZnbBsppu644XQ1/dSmvShDxMCTtB10A55VvvptvRmyh/bwot8mV8NW7Ag7uOP/dMXs3Ts93tEt2g2I9SiyDd/9rtpzOg6ml+8gYkb/4ebGs/PTEzaNoLwOXwEQ/dJhgg7IW6vJ5aMH6SZSp9Z9ZR1NX4HRiZj3f4fqph96U/EdcpQL/onne7nQZzTvA6JhQWU5N4hMczZSN1a6ZHrr1oOOzXRp+OSfcdYcYtEoA7h3iSfX6cvegC3gW7uSuQFYED598PhbganDlXnLkI0qv9PeJ41PBCzSUnnlq+JRVaZBqmYN5rpVXiaX0qlUTwrXTu4SoEwYS/a3VZUpdxsc7UMB1ytfAGIzrbiNMRyAjMp6JC3r5jCcx48XWQaZk2TSYOnrUZjCW+anTEHGCR+vNbTWdg4DCilg96+5s4cjjGyDvntGtCfNIfAiWOLk3RGiEBaZCRvWeK0jBtVSzSZTIrsLELaMCLdn5TjDxzZqR+wcC91rKIHxPm+ayGetvjDXMRFPo9fuGxaNIgbeKQKQnv+vmai9LKWJ63U0p850A/EYd5lGjA9
 9BekS2nV
 HfWqdlsC/WPiVETVCAItuUVKlb/JgeOKxk21e0/Y9IAazohu1cHSVBbq2RlpPnvKlUHdM6y0s9hWao5xJ48mXLxAvMe6xWh8W8IaFGLFTaR7Gq2c97r2Wt7qWQNaihNI7wFKQs0S8bNWKNNg58EEAOkrXtGGcmyfY1KhNF5qH/gNk+TCuCouJK1kqlp1VifrbFp1O7Jc/c6jfwYgpSNq4Gp5dPNbFBG05d6PINZ07EyHocXRT7KNQmeiLnU6eoQQJkwyDCgh1L1TWyVPQMV/GjL3i0+RD0aHf83Fh4cItSSXQy2/H5Ak9bz6EhiQxYOLK93N2HJhgzMWF7fEN8V7vugRDcPt1MGKnZdzKa40OULvNCOpXlR4OF1NKZAKXbtjm9He4LPiZH1IAraeahwMGm/DC6iNKVp1jQRUHGKMgCppivX2Vysw3ALfBGdSimLHXH7yhHGesKAAQAnHIgtWJU7rBM8FRFKqE3T7yguF7tOX3AGWuRoFH+35ZqIboAsmiyQpSiTvInHGC/v+EwkOkU3giyfVxN3AxuY2rGxlqOBfJZLVfjItravFNTRKDjR9BBSpFrzPAD+59uHKktTThsrfsEp+RlneHmGmleMhk65xaBvkLk/B2xlvT0nr0AQIXIn4pF858btFzXkkKvWcFrKlNEVmICAPgQI7ts1oQswg2TOANpsukuYCFaZ8TN5gTwsr6RnPlY4L/8OyYOU4DgtehrSfNZT8/KZtmD25KTteVQhGpNPlUYKS1p5PGVCjTQlUGettLn7pEB/XlBxPdPENIfnLtfg7mI71CMk5/MufZrPGcY4fca2FveAv9Zx13Xm5W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> If load_other_segments() fails after image->elf_headers is assigned,
> the memory lifecycle is safely managed by the global kimage object
> and will be freed in arch_kimage_file_post_load_cleanup().
>=20
> However, during a retry loop in efi_kexec_load(), a subsequent iteration
> will allocate a new buffer and overwrite image->elf_headers. This
> permanently leaks the stale memory from the previous iteration before
> the global cleanup can track it.
>=20
> Fix this by explicitly freeing the stale `image->elf_headers` buffer
> before assigning the newly allocated headers.
>=20
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: WANG Xuerui <kernel@xen0n.name>
> Cc: Youling Tang <tangyouling@kylinos.cn>
> Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
> Cc: Kees Cook <kees@kernel.org>
> Cc: stable@vger.kernel.org
> Link: https://sashiko.dev/#/patchset/20260729031235.2840255-1-ruanjinjie%=
40huawei.com
> Fixes: 55d990f0084c ("LoongArch: Add EFI binary support for kexec_file")
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918100442.3841=
135-1-ruanjinjie@huawei.com?part=3D7


