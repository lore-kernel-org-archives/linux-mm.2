Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4B27C5DF67
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 07:16:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D3306B0155; Tue, 18 Aug 2026 03:16:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7837A6B0157; Tue, 18 Aug 2026 03:16:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64C456B0158; Tue, 18 Aug 2026 03:16:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2AF0B6B0155
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:16:46 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7731740AFD
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:16:45 +0000 (UTC)
X-FDA: 85113532770.17.18CE568
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 06FDE100003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:16:42 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TUWDgzud;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787037403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YSi68YQ1b6ket9ADghC9xT0rrZLBKS9r3cQe8y6Lwd4=;
	b=sUlq4qz/7iq9rOvqzhk+KuBR+rs+5ln1mjL7mhpV4pBs1oGPKKxTcpH3NC9Jpdprq2awUt
	npptifJ+7uYxNQizwjKZqiz05/sKUPOBpj3zhZJFz8FpkHXyRfCfo7tnqYctdtuCuioOLO
	eTajQlhEamXdFBpCqOC8bHDIhqJkbV4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TUWDgzud;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787037403;
	b=15zqKXNwcr3E1PViSzGpvtfkvD977A1+Ozt2WUsYcHg+68b4rari5/Lg7A1oO37Mu5f5sW
	E5OdaFLGKCR4Vc0JdLlTvhpLNu/o2sBQ0R/Xm8FW337c6sX4Dn36eT3mV/fUksgOkAJl8d
	j/RWI+JT3dpPNhHIZ7T3v5Rr1rWOnqA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 581AA40136;
	Tue, 18 Aug 2026 07:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94FE1F000E9;
	Tue, 18 Aug 2026 07:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787037401;
	bh=YSi68YQ1b6ket9ADghC9xT0rrZLBKS9r3cQe8y6Lwd4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TUWDgzudrlRbaLYizQ/L+Yv9HhJoPISIWkvwrqqXHkXYQ/P+Mjucy07z+SVpZ1Hp6
	 1+9KTXdMY5MK6Bl5U6yE7HQU8SyMx5aAVVcmET66QYcsaIErLO2M4LjTbbDfSSVEg9
	 KUfSLXuY3hio4aRh64O1hzuJa78MJ9tKa9NXlhtwOZBgiSAxwk/PdTOPXEXERacTOZ
	 X89WCmwnRA0sc/SCIGgfkZ4fabn+PEY5vw5/yoDnAjl8sJI6PJHRsDjRb6sEKuE0Tx
	 vLnZB2AJKTRiMH004WUuwyMr/+YxPjxsHhQhdd4C+CpFVTAIHsLSJ91VhJ9qR8sORX
	 rwwRXiAHWZjNQ==
Date: Tue, 18 Aug 2026 08:16:19 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, 
	Stanislav Fomichev <sdf@fomichev.me>, James Bottomley <James.Bottomley@hansenpartnership.com>, 
	Hagen Paul Pfeifer <hagen@jauu.net>, Pedro Falcato <pfalcato@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, 
	Daehyeon Ko <4ncienth@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/secretmem: properly account locked pages
Message-ID: <aoQFsk9GwrZvb7rM@lucifer>
References: <20260814-secretmem-accounting-v1-1-d2f8c677980b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260814-secretmem-accounting-v1-1-d2f8c677980b@kernel.org>
X-Rspam-User: 
X-Stat-Signature: ei8xgobp7u8dmudhxdazx6yhkx6nf8a8
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 06FDE100003
X-HE-Tag: 1787037402-15876
X-HE-Meta: U2FsdGVkX195HrgMhQlW36ke/Z8sAKcvx5AXxlx9SM9fEPWR7LekR7ZvOttRBUysz7FJadplJjegGht1BdW4HfiaUrwe9iaUPWAsCR0IpD3nPpf0FIaEhb2wiBpmbq0W20JdkgvIoUaJhQBLGZtvkWPNnxWipavwhzUsbdhsqMDpTW+kxeMbcvM9doarWNCIwUTCzWXB8tLLzsmR43E40QB7/CShdmSijhiAEvUSyHrkQn/zgZWL3T2KbVoEKKDaOW0ibUKaJ68gbxo0r5z1mBv0u5jlK+5fyMne7QqTn/NwIQX88FbpzzmCZhJBJM2qwwfPDM/hVlo+/vy7c0pcVlsOaRii4RzhARla1l+oNJaH2yg2oJ5D2fJlxT1mVD4GdRgrmTmm4Js5KlulA62zWN6c0UBkl+eo0yGXxzCMmKhGC9FeUwFDKrzuiCCAV+MOI4SHOsgs1qwNvBd32TyWaQqHS6hk/xNzq/D0SYyTZYVq7GZwHXurCdFvAGCBfeaE0CDQ9pNEcrXRRKnqElmKZVaRc35q0oeF0xAx2t3tVHHC+P14KgSsIY72HppHiIBtlQrLHZPZWXVi6/GO2Il3wgWkxSSP61UpMj/WQ/rRfyZB4ve9V6NWEiQ1lFYAkaDg6+DzG4NfmIGWHQfQMF6KmBqHOnSVrCrNzSYxT/Yz+dfPGOADDKpNtjA4pcBSEt4WjGGQG7LY0mLzGSnghJjfALI50STKzcWZ7Lo6B2KQRHNO2yXc8mmIVYPvj5lHoLNd8TBsYInC/ES4WaSLZOFECsb8blQnwsVqTnfgJRZbpx/6qR/z2Xwccgxqtm8WEC2TZkyYqE/xnkivmuiWi9F/98SOibyCN9hAegnnkQdim3XRQVwl0GXL5/9YxZImlk0Ln8i1gmSMYXZHoIZcsXU40utOuibt4qtdSFUJk5W6S0DC0Fpccsd44PZMaPgiAiIEUmqsJD/i0zX+SYjLnSy
 CNHApVWR
 elwDbZwk+NK+SbAWunJi1/X0udsHBVWscJ4UFOKrAo/8y0ZqLcKv0FbdOlFCv0vpn35biGIx0Mv2hYvAAzVtwhOD5Iyc9saMbwttsjQwE+y/rkurJZoGSgXtPLIbewwa8Hn8S1kZ++dM8hWorkumjiw/hpYQVcpamT2gzQHc/HLOVloq/CXLZrO08lMmedAec80yNQ4r5nkq0yGclJwiHsNIR+pNwr79l/+u8Vt1R7zRk1UBsi+ANveO1GSEZlmBlDo4TVYSG8K1K+UjMSZebMzpzstiUDQ91VpEeCmeNGLijZiivOpQAXjg2Uco1kqkl7fym6ERpzXb/Pvn8OUZOOZKDSA5WbOp+s5x3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To preempt the sashiko stuff, both are false positives:

1. The per-process RLIMIT_MEMLOCK limit is on purpose, it's what you'd expect,
   it matches what io_uring and every other use of the pattern does, and it's
   strictly _more_ limiting as it's per-process limit vs. total inode usage.

2. It doesn't support fallocate so hole-punching isn't an issue. Pseudo-inodes
   are used so you can't drop_caches (which is a privileged operation anyway)
   and secretmem_release() will be called eventually regardless of how things
   are discarded so there's no possibility of an imbalance.

--
Cheers, Lorenzo

