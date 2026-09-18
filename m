Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9948AC982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:16:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE9266B009E; Fri, 18 Sep 2026 06:16:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABF886B009F; Fri, 18 Sep 2026 06:16:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D9136B00A0; Fri, 18 Sep 2026 06:16:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7C1256B009E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:16:56 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 083DD1C2C9A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:16:56 +0000 (UTC)
X-FDA: 85226479632.17.16B75C8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7D59780002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:16:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=i9JXfNnK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=i9JXfNnK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789726614;
	b=pywh+U2r9s28MUxNC0kJ13yApFXiHjugK36dwLRDXWfghKVqge6JQ0/JbF6x1Lbf01LhwQ
	beDGvIExWVvVo7yxF8iu61lmUFXhKfre/NtlAw6KZ3gEhJcVuFS0TzkHENCaQWogkVspr+
	a0kiKlMVbFVGtq9lSYNHyM2S14EeFMM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789726614;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VuJOT4kdOpRvZM5empbp0YF0BApQR/2NER1H6HyuVXU=;
	b=cmp6SdNI0rkxRUoJw9TbfSI9spCA/koixUsfmNwkZNJstoVLlIwKu7uXgnq0sGSMiYl7wa
	oCZHRAeIkP6iGnqP41CnM6dBCivQ1I3uFstaH+dQgFTgGqRtWHnZcp23E9XiCU3V5JGiBd
	TUfhFAryPb8aey/utxa8Dx2q73CpuEo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2DCF560A5F;
	Fri, 18 Sep 2026 10:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC741F000FF;
	Fri, 18 Sep 2026 10:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789726613;
	bh=VuJOT4kdOpRvZM5empbp0YF0BApQR/2NER1H6HyuVXU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=i9JXfNnKptQjjq63WxDdIuBBUCCL146Poh1RSC+XdoWWB0Fy9dhH0a6kLZUmX1w+W
	 qF3REZ2mxGCNIiOaSwVwjNNaV6NjoRH0sNjvZWq3XRPs6dKW4AZDk1Yede6r8fqzyx
	 o80qLR6AMuSO9xrYinfK9dWCY6zzP/z7rF1NstRvN9oRwP7A4igRkbL4/CMivPIyT9
	 wnnCcsZ+tEz1MqTHyJ+d9y56CfkfVre+2Dy56b5WhLwcyAKGultFUGWzcdJ07WiKeU
	 rZjGFcwvdwgNrDGSmopMB7dJJ/e/9den7VyfEVj7fDrOGtONqMyz83JtmkWwNL2swS
	 Lx0epawLg3Kpw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 05/17] arm64: kexec_file: Fix elf_headers memory leak
 in retry loop
Reply-To: sashiko-reviews@lists.linux.dev
To: maqianga@uniontech.com, dave.hansen@linux.intel.com,
	dakr@kernel.org, pratyush@kernel.org, vishal.l.verma@intel.com,
	mark.rutland@arm.com, hbathini@linux.ibm.com,
	linuxppc-dev@lists.ozlabs.org, kernel@xen0n.name, mpe@ellerman.id.au,
	sourabhjain@linux.ibm.com, eric.devolder@oracle.com,
	linux-fsdevel@vger.kernel.org, gshan@redhat.com, x86@kernel.org,
	hpa@zytor.com, lizhengyu3@huawei.com, kees@kernel.org,
	adityag@linux.ibm.com, ruirui.yang@linux.dev, yeoreum.yun@arm.com,
	chao.gao@intel.com, ardb@kernel.org, piliu@redhat.com,
	graf@amazon.com, james.morse@arm.com, zhangtianyang@loongson.cn,
	tglx@kernel.org, will@kernel.org, rppt@kernel.org, rafael@kernel.org,
	pasha.tatashin@soleen.com, thuth@redhat.com,
	akpm@linux-foundation.org, blum@kernel.org, palmer@rivosinc.com,
	coxu@redhat.com, linux-arm-kernel@lists.infradead.org,
	chenhuacai@kernel.org, robh@kernel.org, seanjc@google.com,
	linux-kernel@vger.kernel.org, bp@alien8.de,
	takahiro.akashi@linaro.org, bgwin@google.com, maddy@linux.ibm.c,
	om@kvack.org, linux-mm@kvack.org, liukexin@kylinos.cn,
	catalin.marinas@arm.com, chleroy@kernel.org, mingo@redhat.com,
	ruanjinjie@huawei.com, tangyouling@kylinos.cn, jbouron@amazon.com,
	ritesh.list@gmail.com, sshegde@linux.ibm.com,
	"Jinjie  Ruan" <ruanjinjie@huawei.com>, gregkh@linuxfoundation.org,
	leitao@debian.org, me@linux.beauty, baoquan.he@linux.dev,
	loongarch@lists.linux.dev, npiggin@gmail.com, kas@kernel.org,
	mclapinski@google.com, guodongtai@kylinos.cn,
	driver-core@lists.linux.dev
Cc: kexec@lists.infradead.org
In-Reply-To: <20260918100442.3841135-6-ruanjinjie@huawei.com>
References: <20260918100442.3841135-1-ruanjinjie@huawei.com>
 <20260918100442.3841135-6-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 10:16:50 +0000
Message-Id: <20260918101650.9FC741F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 7D59780002
X-Stat-Signature: a4xtc8gang1ixzo9e89qdfdwwc76pth8
X-Rspamd-Server: rspam01
X-HE-Tag: 1789726614-364446
X-HE-Meta: U2FsdGVkX19KPghcl8SRxIcYgbRrFTogV5c8usJBGtmSOgN2VWoWQU16AtO7svIbmGTEg7AIfiY64yLbM82lITpxQcgwjKKVPTDYbdu6Ian7FwhEWQcmYXO8QEIqsxpMm7q13GWw/scOBaPyfTydFRS+WuKcej9Ckavl5PaDHGN97bJIw4765RMmd+ShprJ3O7Iz39V2ADR0U5Fou8yBU7/dZa0bVdLJUBUk1bNcwy8K6ZM+PWaAc0Gznc2iMZTxFKpdHp382hY4iUB9CSbrCxVpyF5S4qhAxlr007brrakDwle5IP47dWNVdwgNeEbzRtHKMCqp6zq84MoI9bLhJRNB6IPrPp8eIb+nLGdX6zO8F/Rswl4jTbo5pOkTk6T40MdCLvLn6kAEzuZZS3cDusbnpjmx8Mcnmj9lA2onW/3wPO59UhBjyGgHpObIGWGMe0NicFDkKNlzfOCDK+URJNVBpn1H5+3OHJ3jf1ZrwOLBV5eT2mipGtNGXDmBS1bQe4+6JIJ77sqzFEGXXK+eLhR6iB7UnH46UNTHJv+cXM2ThZUHj0DwR6J22RxZMJOMBEVj5ki0AM8RoqXFukYzAxkXZ+pgyl3nYBBE7C92QSlNxaIGyeGf1Yt55e69CjGuwQfgw3Fxauk0OJB+GdRX/YdHXjD8Y1yVHTFh3IMjaG0daWMWpS8OB7YzAytI7ejJ3CWmf6vhzQcGF6lPJ1CScT3KwL3FpNvmT0DGL5cV4pk/f0pWme6ZEXx/RRwJaqAddzuSNoMzFNaabEpd1JYDRXXTp/3jS9pYrHqkv86YgZjB5s2MqyVoFej1yMuZ5JEgVuV0B84pOiL1Qs6Q4+9aGx5pU1ljvltrYxa6Os8N/Tv9nIy9LfA5luMwKPcmtqifl8lY8CrwHX96acQz9GDesEiWdWHCtJ6dhFeqUeWbBF7xmVl2iE2Noqj6p6pSbMewFnmhegPqmPd9ztzdXGm
 WZ9DcZ4B
 izLTUTtAdLLMQ+GgxObFvYYpQtikLP9IWJC69sZxgjtimpKDVoCqXAAwZxEDqBhBJbw7PzX8L0AlOFOVd5p8mh0taJaVHHOyEEtuEj9EwSUGoEthz9Hp1abKpHTBXz9VpYGMHu8semiS2PRrl4r4DeexJjuZmioQbsOUJ2CeOwhD65dUQBSf7dFk4EvXl9H+TH6TEdv+y1B/C4HGFu+S4xmSxGJIGG0zo1TM9eHt4yOR4/xgQm5BODWg0644LUGn+IIb2Hx3P+MskIVmnN5cMK1mxuUIaeXgLfrLUXZ0BThgK/d5W9VTg3++y7MsKcwWj1StTsGij3G6PFR9TwZoFyXPNns7pJp1uz4/x605bCP1Ee62f3Z+ZS9/vbBl2HW4zcqgZaKfLeZR++F6nC4H38Enkr8XcN5hYmXJBkcG9a/jnxnzVs5z+wcgNY33cH0oKE5dQPp6iJh7HOcAx2magU0QC7Xm2VT83o/OsIfO81TnLF4XGu7JbLZfaHUw1svZommd2rb5ORuN6I7H2ZCPBuC6sylUixlatvkip0LbmDc3U4viz1ghqVqsBYV1fYGExFG2BJXY0XY0G1XivOK1i9LVavn/zO4ydr4+86K50nzshjfYRiw0aJI0iZOfLoQR2tbifxqXInip94x/z232LFXxTBpUMJA9+k8wvqQkzZ+lEVK1IO60DzvLrF+k3zny/qYZl4wmh+qt+ujr9B+FWc/hWTa2++e5aLsNCrqYqyGDl3hQB0VOJlGP2ru2/TDyq1rAQJXDSYas/LGDNr99janXlivihd/QLfYOoiYtD1LUxHiqgpRI/MpdxcomwTsb3z9twiIZc8Ab2JFle7Xmtv3wu4LNE9Io4WlAT7hfWnBNHDaZr2cdDl27tga1cGJAaFAH2kTNVFTkIWcd06p3VfbG+ZJZ+UpW6HbQkxM4zTpZRreTroJPQ60cuH+/nK63OjHdlCs7/lWjFGkI=
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
> However, during a retry loop in image_load(), a subsequent iteration
> will allocate a new buffer and overwrite image->elf_headers. This
> permanently leaks the stale memory from the previous iteration before
> the global cleanup can track it.
>=20
> Fix this by explicitly freeing the stale `image->elf_headers` buffer
> before assigning the newly allocated headers.
>=20
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Thomas Huth <thuth@redhat.com>
> Cc: Breno Leitao <leitao@debian.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Yeoreum Yun <yeoreum.yun@arm.com>
> Cc: Baoquan He <bhe@redhat.com>
> Cc: stable@vger.kernel.org
> Fixes: 108aa503657e ("arm64: kexec_file: try more regions if loading segm=
ents fails")
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918100442.3841=
135-1-ruanjinjie@huawei.com?part=3D5


