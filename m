Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B689C982D9
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:31:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 202266B008C; Fri, 18 Sep 2026 06:31:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DA5A6B0098; Fri, 18 Sep 2026 06:31:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 117876B0099; Fri, 18 Sep 2026 06:31:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E12B16B008C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:31:23 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4E5A580641
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:31:23 +0000 (UTC)
X-FDA: 85226516046.18.D7D9277
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id A205240008
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:31:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a4IsE2dE;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789727481;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WohlUBKAOnI1ycYrmAz9a4uYAu2BUt+wB1nDP7KO/ug=;
	b=VtQ25LVjg3AyX+pdt3OTEbuV92DS74xj9L6XHAcnGl3YFExemAyp4tA97Oc3qRhPNtf1/5
	1xiGyws8eLq+HcLbmEUG+n2fUBhu05+hH4yTasutfVPvg2xXA4/+7HC0loXqPtyxYD45WY
	qMvp1pk2xwLkGm2AV5GSug0cqEwux6U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789727481;
	b=szV2eKggsyNcaBY6ye+e7UE4pLe9JSLGfWLN2mhx77QuGMhCdaPTvGxdX/ov6k5UhshEJc
	HIu/r/KTVnterM7Mf07WglfJCwEjo9ie+TkUB86RDqjgqwXvT1EZBsl/5f8iR+Ni7g7uY+
	O9Bhuxml5EkkFIOVCSnPCCRyCuJZFe4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a4IsE2dE;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C568542B79;
	Fri, 18 Sep 2026 10:31:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741621F000FF;
	Fri, 18 Sep 2026 10:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789727480;
	bh=WohlUBKAOnI1ycYrmAz9a4uYAu2BUt+wB1nDP7KO/ug=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a4IsE2dENzW5204Qi8D7Aq+qhe6TkI4pWZ4xDgTIhfw9ed/XtIK5tfxl8+yCcICC4
	 Dymcq8txAd0AjT2q3l8IwlI8B563zHCLB5HMuAOnTzfCQwWuCfkN9buTwRaFNBwk6J
	 wIlawl87RShg2Qmf/1CfzSShnRYNoMz7czRzo6x2/vHe6XlthNlrzUQIGAB8olUV6V
	 q4OjPaCfD4y0E/Hg+Tkq/aCRCfI4ubLfdpHPFhkUF9Z5NsCCbEGKRRutdxEoTkrrCa
	 9xFhLj4ygDBWKboxOoR1+RkSeIIqSN3RTLAchc9X/WWqsc7PKxOpDuDrnt7bmhriSG
	 McaM840XqhQ4g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 15/17] crash: Introduce crash_extra_elfcorehdr_size()
 helper
Reply-To: sashiko-reviews@lists.linux.dev
To: hpa@zytor.com, robh@kernel.org, leitao@debian.org, linuxppc-dev@lists.ozlabs.org, tglx@kernel.org, rafael@kernel.org, thuth@redhat.com, dakr@kernel.org, driver-core@lists.linux.dev, kas@kernel.org, coxu@redhat.com, linux-fsdevel@vger.kernel.org, ruirui.yang@linux.dev, dave.hansen@linux.intel.com, kees@kernel.org, tangyouling@kylinos.cn, yeoreum.yun@arm.com, linux-mm@kvack.org, rppt@kernel.org, will@kernel.org, eric.devolder@oracle.com, ardb@kernel.org, linux-kernel@vger.kernel.org, chao.gao@intel.com, sshegde@linux.ibm.com, x86@kernel.org, hbathini@linux.ibm.com, liukexin@kylinos.cn, mingo@redhat.com, mclapinski@google.com, bgwin@google.com, james.morse@arm.com, pratyush@kernel.org, pasha.tatashin@soleen.com, loongarch@lists.linux.dev, kernel@xen0n.name, adityag@linux.ibm.com, npiggin@gmail.com, vishal.l.verma@intel.com, akpm@linux-foundation.org, ruanjinjie@huawei.com, lizhengyu3@huawei.com, linux-arm-kernel@lists.infradead.org, "Jinjie
 Ruan" <ruanjinjie@huawei.com>, blum@kernel.org, takahiro.akashi@linaro.org, palmer@rivosinc.com, gshan@redhat.com, maqianga@uniontech.com, mark.rutland@arm.com, baoquan.he@linux.dev, jbouron@amazon.com, zhangtianyang@loongson.cn, ritesh.list@gmail.com, me@linux.beauty, mpe@ellerman.id.au, chleroy@kernel.org, piliu@redhat.com, catalin.marinas@arm.com, gregkh@linuxfoundation.org, graf@amazon.com, bp@alien8.de, chenhuacai@kernel.org, sourabhjain@linux.ibm.com, seanjc@google.com, guodongtai@kylinos.cn, maddy@linux.ibm.com
Cc: kexec@lists.infradead.org
In-Reply-To: <20260918100442.3841135-16-ruanjinjie@huawei.com>
References: <20260918100442.3841135-1-ruanjinjie@huawei.com>
 <20260918100442.3841135-16-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 10:31:16 +0000
Message-Id: <20260918103117.741621F000FF@smtp.kernel.org>
X-Stat-Signature: 731he3mjbksbjx4ecw516wcepw9uw7i7
X-Rspam-User: 
X-Rspamd-Queue-Id: A205240008
X-Rspamd-Server: rspam03
X-HE-Tag: 1789727481-446085
X-HE-Meta: U2FsdGVkX18qHpIjjdjJ80XWh9h4oTxgyapAL7FA4wAO5LOhejBbCoyKIYAYuPB0h+fb1Os9/8UHc7KCsel3H+iQK9eOEwNFPpa4dLtbdMrAPznAgKCe8MGWygaXptmkx5gHPN5emRbrugtv0ctQJacNPvio+PZ8ZrHrJ/p/neRHrZYx5zsRZ7EppgrnUQqU6pLnbyQTET+Kvwr3UScFSNuUKxPBSZwsqAnVS3NIE9aMbKQXaVsm/J72WbOFqZcvN4QpjTEHaiqiSvOnnE+Nk8jMpK9MT86JzJmQNMJE4rJOwNYUZuNVhmBwzJjLKWft/WmsZ2tLCgZ3fCbYW0viftHWg8+nz2Qd9Lw5stgseIFfnmmFIB7XZPZVyfqiL56oEka+nFLkCiwQYQ6csgHhdQSQJkvvX1DZfdLzOz8VrLyzCM2YUtElz3grtlZBSIcNoSRagywqW6GIBQheK2GHtA9Et4aWmO6hbu9tsmFo18ZqdfJt5SmsHOC4ivWLYlXAU/su42fZfXRy3pkxEjH3KgNO8yDnx48nGgso1R31+NvZd8j7SoiQhoAXmKjo8+2PKaZ6t2iTHQdxEgS3QmLDkTCQzvGDNESWUW85zHlkf2/PSdC8Wlwh0rBYYYr+YFi4YTiKOfyoJMmmL9qw2D8aIMbgEmNPeGODfRE2wbwLzvORYF13q/VrwTmnBjppHfexDdYk6lHWiNsxCVUFqwzQczOe5q7gGDtNr+GJmD6jaSRV4KApP7ONPqdO0jpbfOzcex39oOzYypDLes9yme6qKVrMMPF3bmgNcZM+h0iHaURlkFHH2WRzDziky1XpRnN9BJCoAAopbv1KebDYZOGCzBzV7BbfMfddUmDZEZSLQESSN27H10sh+WJW1Q0WCxpjXzFSuZmax1wlMSDvbmuuHlNVnLHgdDXYPCpV6nWqRCFrFlKCzxdMLafu34ZgNsCp6dE3JnMvTIbFQvLnHko
 HqIOsW8S
 BuEpqS48mxvrVrjKgD9pJNox7PgxH/SLpHjziH3+kjDANNHijUHaRH1+0IrX7AB/QJ+jUWuSMIkRcP0mLnJ7MHPSqEmrbaVv/UXd8WJaITobXFWm97FeBzUC1gMMvX4TStY4c/uaNTF8wD4nv91yKf5v6MD9buXzhheYB1t7S1K5sZ47FtjWlQx0SKeDZRNzK3E356HljbbNB0rTdRQ1BKf1zfqXKK1kaIUZx8psg9tCJEAxNJu5932RugTfsRxculbUMyaw72YPH/tnLuDVUyJzi+jXMuFauOd4k6suoJs2zWiANTK4zWmB/DNlk1IBKwcxpbHsYQO062gnZYzIrm0+VkswE+FVtO9PjaVFzgDU8PKGFpepPqh18f7tSyvBVrhSNSzkGvRAIp8nD/hM5n4zDRV1ZZwBR2TIRahTkIGnYZZz/sSUHux9jE+Op2MsP2p4hik/wWDsNRg8dMvTB0+Vmv6xHT6VpSKkmSukGKwsLnG62KJY5EHHUInTjiAaqvsN90xPNPUFwvoNOH9ZB/8GCZoP2ZbJIGUvH20oqWMOlwFej3QdVf9fvJjmwsXkt/WWnEKLFDozAlTQ2nkKfqL0WxQAgKTNyCl7P0zZTJ7CrJtHC1/HGJSCYh7YsIrTZnBGgVDdNb5pAJVb9VT2iV3wRAB4rmMuN71eaB9XmO/xQUY4a5tNHfdiONOita3zs7W4HlrKSDLLNXaMAynNZ7LXNiyWorw4b0vx4gtpegK8UEFx44VQbjGYTTfaCkWi3dl4s6erGH3AWCnLvFUhN0/06My6Oi0LtNp3d7VFJn+MjbbfkmL8QXraoonaZx4U9RowY+bfS5fAxbK4cDvWkUmcIYx2Z3sTmqncs8vDaRzNhPVZc4T05gfiGGE515ZaG0YH6c82xahYHddGaDss39fZ4Qg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Extract the elfcorehdr extra space calculation from powerpc into a
> generic helper crash_extra_elfcorehdr_size() for use by other
> architectures like arm64.
>=20
> Strengthen the original powerpc check: instead of only checking
> the loose CONFIG_CRASH_MAX_MEMORY_RANGES, the new helper enforces
> a strict compile-time BUILD_BUG_ON() to guarantee that the absolute
> maximum theoretical number of ELF Program Headers will never exceed
> the ELF physical limit of PN_XNUM. This ensures absolute safety across
> all architectures with zero runtime overhead.
>=20
> The helper also provides a zero-size stub when crash memory hotplug
> is disabled.
>=20
> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Baoquan He <baoquan.he@linux.dev>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
> Cc: Pratyush Yadav <pratyush@kernel.org>
> Cc: Dave Young <ruirui.yang@linux.dev>
> Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918100442.3841=
135-1-ruanjinjie@huawei.com?part=3D15


