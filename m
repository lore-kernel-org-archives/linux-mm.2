Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92876CF2564
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 02:19:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C05CE6B000D; Tue, 18 Nov 2025 21:19:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDCC66B0023; Tue, 18 Nov 2025 21:19:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B40796B009D; Tue, 18 Nov 2025 21:19:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A562E6B000D
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 21:19:40 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 94C3A12E6BD
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 02:19:37 +0000 (UTC)
X-FDA: 84125750394.06.B091ACC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0FC9B140008
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 02:19:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ui7GpCR2;
	spf=pass (imf09.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763518776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ftNNGOCf2jr255B4pOQIO3jWHYSLMZKjUp5Nbe9mAt0=;
	b=2PUhEi8GYzWIv9SzTmb2jmdv9qUCX7fxmWjxWuGOBFm5+z2Mrxx16n9yIuAjnzkKqV4ivt
	ETWTWphMb0cUNUbP03oVML5BIIdIV2JmpXRFylAXv38Odih2z/xObXu08UhVZzPGv6eZBj
	CqltDbN28cGNHQzvrS9E6Yh+nibS2uo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ui7GpCR2;
	spf=pass (imf09.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763518776; a=rsa-sha256;
	cv=none;
	b=aJzaMJ7Hy4xGcXSbet8tlkOsN0IkjH3FOjLwXCjhUpRDPB27C8wypjQ4P1pAJYlf9DN8M0
	WgQ3ql3lcyVzKbxNum8lso/i7W3feTH2rA+RSwspM2OfcoHEHm2R6tTu39o1FgTA/uvkWU
	Kz/e7+EvvRuSptXvOEXMXSW8o2u8CbU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7CFEC60132;
	Wed, 19 Nov 2025 02:19:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E38EC2BCB6;
	Wed, 19 Nov 2025 02:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763518774;
	bh=zFT1wKMUonwvnujQpKQ9C7jGYAhkyYfIkOuaAqgQWBg=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=ui7GpCR2qAi7IvNhX22dV6lmhwHRxEqV6rPUTSXuMvn/iqOm0gZu4Rj9VwwGxBPm8
	 E2tFrRz+cyNZt89cOeyasE9e5IMOA15otuOf0IldGB13dZewupGM88QIEkpYUotGoU
	 hmxFtd+wcE9oj0SxakiLbMfS/QDJO4tzwd79CaBTqlt3+IF0+t63Bs7BaVgk7oDy8S
	 RAzsQekpND5yx3RP8oNfKUVTrITWs05sgLoGaGvjwMekK45EkzhiX8Sqkmun4iUHzx
	 Ak58tlOSlpTMXEx/bLVz6mA6IEDFMiIedNYd6X4LgHAwJTPTV9Sum3RUVIJsOZHPhB
	 OLALci/K3cZJw==
Content-Type: multipart/mixed; boundary="===============5091828915502704464=="
MIME-Version: 1.0
Message-Id: <694cd72d2f4697ed5ed8abb0721820b25c228916ce225b4524174f9af0f8cd6f@mail.kernel.org>
In-Reply-To: <b470e1e2e3c1baa97a7bc6637863b3f52336ebb1.1763457705.git.zhuhui@kylinos.cn>
References: <b470e1e2e3c1baa97a7bc6637863b3f52336ebb1.1763457705.git.zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH 3/3] samples/bpf: add example memcg eBPF program
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev,akpm@linux-foundation.org,hannes@cmpxchg.org,mhocko@kernel.org,roman.gushchin@linux.dev,shakeel.butt@linux.dev,muchun.song@linux.dev,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,martin.lau@linux.dev,eddyz87@gmail.com,song@kernel.org,yonghong.song@linux.dev,john.fastabend@gmail.com,kpsingh@kernel.org,sdf@fomichev.me,haoluo@google.com,jolsa@kernel.org,shuah@kernel.org,peterz@infradead.org,ojeda@kernel.org,nathan@kernel.org,kees@kernel.org,tj@kernel.org,jeffxu@chromium.org,mkoutny@suse.com,kernel@jfarr.cc,brauner@kernel.org,rdunlap@infradead.org,brgerst@gmail.com,masahiroy@kernel.org,linux-kernel@vger.kernel.org,linux-mm@kvack.org,cgroups@vger.kernel.org,bpf@vger.kernel.org,linux-kselftest@vger.kernel.org
Cc: zhuhui@kylinos.cn,geliang@kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Wed, 19 Nov 2025 02:19:32 +0000 (UTC)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0FC9B140008
X-Stat-Signature: q1935qjqif99w6wxtdn1r6bcb8izxbcq
X-Rspam-User: 
X-HE-Tag: 1763518775-260885
X-HE-Meta: U2FsdGVkX1/GfFepKiVJU2hWZHnjlnj+YAh2Fs4e6moemqxR+tIKlZQeF7k4Qn00ZFtzuuZunioqdjWIFlXd30tBQS3isi5LgTVnQbKqwHeerdbmrCHwxyl/FWTi/uw5MLleTCayHl++mddTrXfoWNVOwPONJdKV6e/LLrX0GawNfprb7UP5XOWJz4YP434LDJJmyZhCZY+58cumYGYuMQsH7cmc3iH5MjFqrM0WnJ59vq+COPnW/d1DU3FJ9VVubdaZ3sy2gND93Gqp5WlHkgr2tnEHMF0qQqe/4+rFeLUsTzESOnzplFWD+FISSN+2AAgELjwvxoosCtqqCOPEcxGnjWk2XMDIAdoU99OdU+VKTaOpmoEz1PIBqbFBIkHgpepm4fXoLpU41VERzgbjX3zd1g0kcptHKcVgTjIdl8OiqjLD5ljCls9mLMD/ufw5rAF4KlAphR1cWb8Y4HTEJBo6yOku9+tGb74ebSHuwf9rpv8UTAPn0MSFgf3u1Pja7RxBOjUmj6rMPxIc1k/8/38O8tJHFA6KO9ZEqnlDlHyp2ixzjIRIHornoN5lDXLGvIyu/MnGOQvp6En+ryBk6KG2VtdIG2dJuOiuCfmpHQyAOrro2WDMU/iYsyFJNELx9I0z9z+KIPEQfwUwe7jmtyr7Adx4p9vK4XUrE7LvFlxF5kSZYoY8DsYsp53d9RYUWKW6xjTiIS9mt5Ah2JlQpwFJ0BXe9krA85lDDXR5lvGB45KTPhj0gTja20vIldknkzRGFuuPQoHOnaSJHono8LJLPg75qNWyia2ciFbpofoWamuzhcfDsVvBl+0QrElChIvWr9ibpyXMEytxhFGwOTgWqGkTGruc4lTKpaktG84Q4ZJdrLyYW3iSWxJP1R95ikN4Yel296c0qaIirGfKm38LKtLFBSoxFI6rByO5QQ/HAEuGxjYco/DHzTeOOY4qrLPKr7TX74LRrcogvLn
 dYK0WrFD
 FPeBb83IZX4KTqkcvE/3MjCj83/1MLTaLmFn59UhEZ1hBY+5w/DJrBZxcDX8UAALfVrnlG4cItmTPXsR8glLkM27H5Djv/jjCB7In6KX/L4dfV6Q8274Ud7oiBZB42bOekXe6Nb28a3ftvW0muqIEI3bgbBZYTRBpgJZuF16fuzr4azkL7YslWqSPaXvloKBGAHNK74F8QWiyPhA/M6zUygFP89djjjAuXSEwhim/fehjoo5LY0Wv8yieAvw5mhBZwOUXcMji2yqy4kPYm6VGHScdp/tE9F1YqqDI1LJ5tmEsREw2x8fhV2pzAc/rakBfqQmY5gJYiYtQFJqYK3clVnwgIOIKFx0PzsyiBzwu2E/FIBECKU1ILDs+Yhlt+O9g3fHlsRbRdylyI44HUNVbjboxD+91j8Sk7fAqZoCaoqzBViP8X6eBlaax+AOrdkx+8oQyDP85gae+t0DqlunjzzoATh5adM0zHkUVDX5MyVtwv0A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============5091828915502704464==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/MAINTAINERS b/MAINTAINERS
> index 78b414902..3a70521cf 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6357,6 +6357,8 @@ F:	mm/memcontrol_bpf.h
>  F:	mm/page_counter.c
>  F:	mm/swap_cgroup.c
>  F:	samples/cgroup/*
> +F:	samples/memcg_printk.bpf.c
> +F:	samples/memcg_printk.c
                     ^^^^

The paths here are missing the bpf/ directory component. The actual
files are located at samples/bpf/memcg_printk.bpf.c and
samples/bpf/memcg_printk.c. Should these paths include the bpf/
directory to match where the files are actually created?

>  F:	tools/testing/selftests/bpf/*/memcg_ops.c
>  F:	tools/testing/selftests/cgroup/memcg_protection.m
>  F:	tools/testing/selftests/cgroup/test_hugetlb_memcg.c

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/19486904708

--===============5091828915502704464==--

