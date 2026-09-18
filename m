Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6874EC982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:11:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 537FF6B008A; Fri, 18 Sep 2026 06:11:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E8C16B008C; Fri, 18 Sep 2026 06:11:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D8986B0092; Fri, 18 Sep 2026 06:11:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1ADA36B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:11:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4867A120624
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:11:20 +0000 (UTC)
X-FDA: 85226465520.15.0477EFC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id A22D1C0008
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:11:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b="llH/FkFI";
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789726278;
	b=I2vA6RbWWuiVzEQBGQ/T/+eYU/59jY9gpXpZFVGw5fbs1FEkUT4o9t91KZ840FUt185h+m
	/8ZZYq7TyUK+4UgOGIBPjtlcBH1IWm/sJYUJG21czG+jQXXU7+3/ezdCXYL4eLStIHQMQ1
	W5cN1+pv/LdgBKq2xNfD5C1GkUzCgjg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b="llH/FkFI";
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789726278;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EbvgUlDhMfv5xqDyq41yarwe4vF9IcejR9w9IshiD48=;
	b=zaHJzx8BgmxR4fk+pGjvzkm9XxXp8w6w9imrhPPLmGNdHhDi1jWbVzqNYD4xH2wWs1FKuX
	W37QE34FcefQa6vCx5QurMhtPVK1AIXKX56dXT5onvu/Rv3tfk+q1nsFj+XmpPRja2twMe
	m0xa6D76G7pcBqXMkK2v1vuIeRDS5BM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D1BD860A5E;
	Fri, 18 Sep 2026 10:11:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FCD41F000FF;
	Fri, 18 Sep 2026 10:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789726277;
	bh=EbvgUlDhMfv5xqDyq41yarwe4vF9IcejR9w9IshiD48=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=llH/FkFITAB5xWYHwFUPLbdE2EaF3GC1eSoCiDjrZavq4ujmqfQALeKu52aFVVMuR
	 pBuHSv80cKI3j9Mho4y3xdPug+GfNG/zgAkh8wZ7OoahnhoGS7E5dhRdqhsQ+I51pr
	 f7NWcn+fOKRoo9iweVcxsXDWvRhgpceUNC6h8Ptlkps8SWZs2CmTh5980BC6sEHNlB
	 0CM2Rk/czy1YuvNhpd/QUpJNpu47BkJRGDZBlBtd4x1ODrJ76w2qvFvIEJ442SLha5
	 zUwFARxcYBBM4yGx2Endjllgko7Mxt/Jea4yXamZO8XPgdLllRtjg2f1JDx3w8mdGp
	 uPU0nMOTpRphQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 10/17] crash: Extract crash_get_memory_ranges()
 helper
Reply-To: sashiko-reviews@lists.linux.dev
To: maddy@linux.ibm.com, tglx@kernel.org, loongarch@lists.linux.dev,
	hbathini@linux.ibm.com, linux-kernel@vger.kernel.org,
	catalin.marinas@arm.com, guodongtai@kylinos.cn, jbouron@amazon.com,
	thuth@redhat.com, mark.rutland@arm.com,
	"Jinjie  Ruan" <ruanjinjie@huawei.com>, gshan@redhat.com,
	sourabhjain@linux.ibm.com, chao.gao@intel.com, piliu@redhat.com,
	eric.devolder@oracle.com, baoquan.he@linux.dev, pratyush@kernel.org,
	ruirui.yang@linux.dev, bgwin@google.com, chenhuacai@kernel.org,
	linux-arm-kernel@lists.infradead.org, maqianga@uniontech.com,
	bp@alien8.de, tangyouling@kylinos.cn, mingo@redhat.com,
	driver-core@lists.linux.dev, blum@kernel.org,
	takahiro.akashi@linaro.org, coxu@redhat.com, linux-mm@kvack.org,
	palmer@rivosinc.com, akpm@linux-foundation.org,
	ruanjinjie@huawei.com, vishal.l.verma@intel.com, npiggin@gmail.com,
	dave.hansen@linux.intel.com, liukexin@kylinos.cn, hpa@zytor.com,
	chleroy@kernel.org, sshegde@linux.ibm.com,
	linuxppc-dev@lists.ozlabs.org, robh@kernel.org,
	lizhengyu3@huawei.com, leitao@debian.org, yeoreum.yun@arm.com,
	kees@kernel.org, linux-fsdevel@vger.kernel.org,
	mclapinski@google.com, james.morse@arm.com,
	pasha.tatashin@soleen.com, dakr@kernel.org, will@kernel.org,
	zhangtianyang@loongson.cn, me@lin.kvack.org, ux.beauty@kvack.org,
	ritesh.list@gmail.com, gregkh@linuxfoundation.org, kernel@xen0n.name,
	seanjc@google.com, x86@kernel.org, rppt@kernel.org,
	rafael@kernel.org, graf@amazon.com, adityag@linux.ibm.com,
	mpe@ellerman.id.au, ardb@kernel.org, kas@kernel.org
Cc: kexec@lists.infradead.org
In-Reply-To: <20260918100442.3841135-11-ruanjinjie@huawei.com>
References: <20260918100442.3841135-1-ruanjinjie@huawei.com>
 <20260918100442.3841135-11-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 10:11:14 +0000
Message-Id: <20260918101115.1FCD41F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A22D1C0008
X-Stat-Signature: os8mb89fcnhizq1b6adsxewykkzg83a6
X-HE-Tag: 1789726278-602244
X-HE-Meta: U2FsdGVkX1+zO7AIDt8cdF1X2Vv+ea+HVhf04Efs6yoRkrTC/vhoaLpzqrGjAgOPyUz6seiSMD47QYVMi2zmCPhXkPIx44RJL0QVlc44IULo4Tr+pqe2cpdOxWGcJI8o0BPf7WYii8X/rue9fbrmjCUwj/Qi1cCMTp7S4jVeaXw+lamATbU1Z28l8Dcb5ZJsuHd1UGR1h9zCqVdELWnBTU+gB/ATsyWSTj8SuEg7f7h5cgCqtKEAnW4ir4EdE1EXRx3aEAZbxB4RuXPq2/PDZl9miOeh2Imq1tVZUSFUpbyBMUT8Fn6Vl3MfKFqnU2Cedm7bWpDIVpNA2ww1Gfu5tfY8QgWKM7Yxx5MGW0cXAtQjlCpCRHVxpEB7JtGDL0yIHl6cH/3/AlmPDbwWaiNgnb84+OCvwsomQROb44Qe1uAUWo6a9PakoZM4qD8r3TDa7I6OtLcIwztHkcmY6C8UVuQCoyozs5AvUbQ3RO7dCFNMk/9xpub/+gat4mxiiy1VTApsvoMpNKmQlavWoEw2wpRrCQ6kawLjBoNvamUAsqFjF5rnsKhcgrshdPeWWU5XOuCHyir731+h6YZCjiOa/30bV+FjipM3guETm/Vo1v27OF6OOYCZDuYcBjZsGPL0ugMXEc23bs4YIOzVGVlfxYXYSXdgawdvX2S0OVF3O0rrewNlBQ44R4yVD1FQVgk5ieRRYoN62VhhrLtQRRnnfhGn5kkwDSj8wR7g+9Fq36CuihmpTX3q+Dmrfd82+y0fvg9JujQatEYq0HpAiVfDaj4USnYzrd7l1HBulP0In+bLWUMTyw6bZE9HETm1J0XlA4LyAQ+AoyG4aLPV5VZwW156bYNShS0OFKahgOed/H6oM6sIV4SIbPqvDT7dNI1FpcnD11dvkL19KTvDrIDK/XW4OAqHm9Gek0SfJHvUPVEVbbpbHanc7GGemF4uqfRJwd+fyNYsnPFudjI0Iwc
 Sh29eGAV
 z9olK/A3bkFSLd5SoC68IM2ORZYFROKPYSep4rVd3CjlZxUjRBS7sr/7IODyKi+cxa0pyIzbrlYUn5mWhVsPXOo/b42UwVhl4DsDq3OSstRSaZ1thFbm+Frn/jiqhQUadMNBk3Z+Ff8YNSi4MXKT64X5Zl8lm9vQNXC9wemd7YMSAxMoCG9FN9jHr6vGYpeK/ff4z0A/Hdnn1SuvSrAXobbO8wvuYbQryhl92KqttA25nSXU7OJdxY+x11YI+aqR9haUKVJvqyIN/YKPPl1UTZ/sX/J9giphQ7F9mKR+QTDPxWdZfrNf+nD8jXPlCQDQtn5OFrw0g3mv4pgBkBpB5KX28w0Ueh9HtooNd4IdB9fLeUl9yjmxXSeeGrG76I/n5UOql+U+y8ejMrUWoBs2SGc6JyKMedn2biSRCxPYbWCdazDFy1CFVbNJ0/4lrQN6W/VRWkHKhgSMxUeSc9F2o1KVH4VRe4ML3ZtU5/Wcjp3d660v0rb5lruRCtHphMKabT/dpgFc6XvIwPYsXR2iSaJUMddQhS++M24mIHZUP3WdrTQ7m22q2QVyNQCZGfS1USXmM6xeIPCRNEROEQFkFYViu6i0Fn9Q9PJFeCgXKMC9XPQVc+lV27+Izo/wqMffL4MLJOpZtd7aLW2erCzRXit8wVKPP+jKMY74lX1k7mVo7DI+PDT3pCSp/FlmuisDTcRJSn5mg6++f252YHcHLEwP843QESdyMmNuZce3Kc/7RPn3NhQaEq9NhT4qSuZgkgaoKqQ14p8iSZN2uFdpau6mPWSTv79HHrbh/11ThkR/cfFJtARKh2l9ihgj3Yu+eAGx0JduXeTCFIwX4vKl0ejm0Ucr9FJA/hbuzvyGKoGVWLVIvoHkmTU8QpWNuv0hvLxOwWkLEc3NetA2ezTVazxDVwU0pVBH8MjF6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Factor out the crash memory range collection logic from
> crash_prepare_headers() into a separate function. This allows
> the memory hotplug path to obtain and modify the range list
> (e.g. remove offlined memory) before generating the elfcorehdr.
>=20
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Baoquan He <baoquan.he@linux.dev>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
> Cc: Pratyush Yadav <pratyush@kernel.org>
> Cc: Dave Young <ruirui.yang@linux.dev>
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918100442.3841=
135-1-ruanjinjie@huawei.com?part=3D10


