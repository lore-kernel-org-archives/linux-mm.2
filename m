Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61B25606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 05:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RxVNadAq
Received: by kanga.kvack.org (Postfix)
	id 857A96B05B1; Tue,  3 Nov 2026 00:42:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8087F6B05B2; Tue,  3 Nov 2026 00:42:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 745A56B05B3; Tue,  3 Nov 2026 00:42:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4CCE06B05B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:42:32 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 51DCA80287
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:42:31 +0000 (UTC)
X-FDA: 85392712902.01.965F2E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id C025614000E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:42:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RxVNadAq;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793684549;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Cc3lUsEZk3MtA6YpJGPw70qiv6UnPpXc1c/VsAmgHc=;
	b=XyA8H/3P4U0CQ9ZPXEjIli9Wn6Oaq38VyTRvExgIbOWwVSC3BQC5z3Gn+ivB0f959pVcyE
	GjppHaKBUb/d7huqUrd8Hk3qAh9USgTqTt5a8lsB8SjviF+4GwQpFZIrBOnTu7kQwCNFzZ
	KOyjuJ34GIH8mulNtQuMilB32kCiSbA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793684549;
	b=TAzEwUzFN/0VIaun2HNydMmO2pYF6Je1kl0t/HhEk/Vwrjy2xiDhUZFefiM5J754P1V06K
	kWwnXvF7yRmYswJGIH2AASGk6EqGkPp6i7qCJdfBVnUSX5rhQyfj6MnK1SKc/lG9BFb6g2
	zfFzGpeaA1O18LdhvlIQadpUjRq3iGg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RxVNadAq;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 05F3F60098;
	Tue,  3 Nov 2026 05:42:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C7C1F000C1;
	Tue,  3 Nov 2026 05:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793684548;
	bh=2Cc3lUsEZk3MtA6YpJGPw70qiv6UnPpXc1c/VsAmgHc=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=RxVNadAqou4AbPg/M1k93b4cm41GnUUU5xjfbHkWjY3Qc1CKMoXqhdo0z3NYRjum+
	 V2Rsk9WGOgaH84uUJwcDrYeT394X8dGDvjp6a87b59h4wXs1Q+EXg6rgMK0ypyPmOw
	 g+zsJPZHF3vdDCcH5HO3m2l0aMKiCQF4ZToIJjf4MdZwhCK/XRHcSHxT5vSwm6QWMK
	 kanrBuvgYpIHv7X2IuIlEbtzeLHv4Ictn8rLFKJ6zS04izr4ayUa6E0yK81h8hfp6l
	 vrlLWlmuvGQlJuSseootw46gFM3JLxKNQssA8SxhEqwCgZunUZxE8iRNVA9SEhAWlt
	 nOg0/jYZ25PUw==
Message-ID: <sashiko-outbox-194595@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 1/1] mm: zswap: Move the crypto_acomp to be per pool,
 instead of per-CPU.
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>, hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org
In-Reply-To: <20261103000313.13677-1-kanchanapsridhar2026@gmail.com>
References: <20261103000313.13677-1-kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 05:42:27 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C025614000E
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 58h6ima9w63motrq5dcqqe1pf91pw4hb
X-Rspam-User: 
X-HE-Tag: 1793684549-415744
X-HE-Meta: U2FsdGVkX18Gl/UT4XPcPN3ztbQO3iDF67k6jc8Cl2oMOsVb8eJKeRu1Un/pM8jsPCM3oMXDN9a7UkoFHbKDR+9vRx5t8bXpP4zUgyoWBJIdbU0CKdDmwEtDSah4jwrjSbkLkVeegnnbVNin1PF/pjSg9fL8SBE808YrwEt29FQW682VYkusxoLRdWYP5Wxb0m93J1uA+FOlmvgmXY1nGT7LAiTkxs16ivGIvAv2CI/6chj8/j7mtV/GBb/FFDh0gQR6TM6rTiSGHN78LbFNcfrz5cQvyhbfZMXAvwyRpzIEzcd60llfwcsvP2A44/6lHY/GipF6+9J3uRL5VrrZl/boN36FPFhzRVrhtJDF9OQmeYz00Nq4q8qy9GjUebFJKl1es9RJdmif8r6oh933QDXeqtIbSUFxqgbtRb5UI5y29lR1Et4oXp2QUM+pXd/NsbpmjNAhusm+HfUwHa3Q72DVFqyQVJ9VegZMIOWlruvquVRjQr5kRj1EwyzRGw1JxPq87d48JMwEoUVrN/6B2IzQsls43+WV29/LwZUnaVURBU7XZim6KmyUJatWtWng6exfDSEgcCOm5Ry69LEY2eVvlV3mnEkrPHUUkGoYCaszCvGl8mmt9JiTUyORWaBhHm3zxlr3LBuTb5R8LJzqfFZrei6BDDIfKDm/n2ntqHmlEHnE8ya05xG3soSAJhagX19te1/FEIIl3HuGNgYOV0q85PxJe28l54SmErCOm6mUfpTVO7e6st6YtDMCj0zCsM4vGfmRqM1HXvzAqpLcPQczMYvDSkW8Rv4XG4DwuVX5Z1sIObl+FmvqVSWd61uqRBS5zoKxvUe4S1+mty32Oen8JhyXUjFjsLnGXdDEG99lqKx4hlKkQTJmlX8mCaFo6sh7KfqtDFKCNpYmANKLKUWKeZsD+mTJf56TJ5u9/p9rTUcLYOaUdAAG55chJU4Wdgar16ML60FXh/sBJCe
 5u7prhq6
 wqanEcQEM9EbE2dgpmTAgOq0ys3e4+XqS/h/Lxzg82Ev+gOCpY47BySNZyqlqa7p8yE94Aq1egoAGlIa9OowYJ/aoH3F9K/uHGtnQlD51BtkXDqnc/JAqxuZafex9efHjlIZlLHxxexjfpahrGI2gT0u4PPXNDflHGDNoFbXB3LikReQUn9xTQQMX5XKr4HKJgnO6LgNwzKT4oXO3fHV7riHZc+7h2raUsU6bkeep9lBMKaVlwncbbM4MKhLXgSgRsT/AcQmojphgscJSbs9OazSlMzhfuRG9QXKjf9SXxA8Bmcryr6EpmjXshfyhR85J3tnZGZlicPOQCZOlJ7yDBPFEu7FozSCVXhMzud6iNEQ3vCs8Y/WHDrYGTBkt1O9dZfwQ2374RMJNAdGEnYHu4xnDdiX+9a35oXoP6pI4IbAb+dRhqo8PlT+iujamvXHaw7JcjzTRpz5raQIkT1NLIF7uOJ9s0raI7gunsadYyJLZnCchqGNhr7seGA+i1rjj44MhfDdSJZ+FJSwMMliZ9jzp32J8VdB7D59v/19h0nXtNuKNoWp0kTF13wfNyaAmkSAZdqneYWWq2lBmhL4u5NcMi0nMZXJ/rgN8qlY6eFrRkrXtcqlapPi0SjEiMJ9X4Wwg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm: zswap: per-pool crypto_alloc_acomp() breaks NUMA and HW queu=
e scaling
--

commit 0abfb2c1c527ffcd5ca8df2224cd1c4533f5face
Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>

mm: zswap: Move the crypto_acomp to be per pool, instead of per-CPU.

This commit moves the struct crypto_acomp instance from the per-CPU struct
crypto_acomp_ctx into the global struct zswap_pool, allocating a single
transform per pool in zswap_pool_create() instead of allocating one per CPU
in zswap_cpu_comp_prepare().

> diff --git a/mm/zswap.c b/mm/zswap.c
> index 37d217860a6b2..a958b74d4425d 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c

[ ... ]

> @@ -323,6 +313,17 @@ static struct zswap_pool *zswap_pool_create(char *co=
mpressor)
> =20
>  	strscpy(pool->tfm_name, compressor, sizeof(pool->tfm_name));
> =20
> +	/*
> +	 * In case of an error, crypto_alloc_acomp() returns an
> +	 * error pointer, never NULL.
> +	 */
> +	pool->acomp =3D crypto_alloc_acomp(pool->tfm_name, 0, 0);
> +	if (IS_ERR(pool->acomp)) {
> +		pr_err("could not alloc crypto acomp %s : %pe\n",
> +			pool->tfm_name, pool->acomp);
> +		goto error;
> +	}

[ ... ]

> @@ -841,34 +857,20 @@ static int zswap_cpu_comp_prepare(unsigned int cpu,=
 struct hlist_node *node)
>  	 * To handle cases where the CPU goes through online-offline-online
>  	 * transitions, we return if the acomp_ctx has already been initialized.
>  	 */
> -	if (acomp_ctx->acomp) {
> -		WARN_ON_ONCE(IS_ERR(acomp_ctx->acomp));
> +	if (acomp_ctx->comp.areq.req)
>  		return 0;
> -	}
> =20
>  	acomp_ctx->comp.buffer =3D kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_n=
ode(cpu));
>  	if (!acomp_ctx->comp.buffer)
>  		return ret;
> =20
> -	/*
> -	 * In case of an error, crypto_alloc_acomp_node() returns an
> -	 * error pointer, never NULL.
> -	 */
> -	acomp_ctx->acomp =3D crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_=
to_node(cpu));
> -	if (IS_ERR(acomp_ctx->acomp)) {
> -		pr_err("could not alloc crypto acomp %s : %pe\n",
> -				pool->tfm_name, acomp_ctx->acomp);
> -		ret =3D PTR_ERR(acomp_ctx->acomp);
> -		goto fail;
> -	}
> -
> -	ret =3D zswap_acomp_req_init(&acomp_ctx->comp.areq, acomp_ctx->acomp);
> +	ret =3D zswap_acomp_req_init(&acomp_ctx->comp.areq, pool->acomp);

[Severity: Medium]
Does replacing the per-CPU crypto_alloc_acomp_node() call in
zswap_cpu_comp_prepare() with a single non-NUMA-aware crypto_alloc_acomp()
call in zswap_pool_create() cause a NUMA locality and hardware queue scaling
regression for hardware compression accelerators?

Previously, commits 7bc13b5b60e9 and 1ec3b5fe6eec allocated a dedicated
struct crypto_acomp per CPU on cpu_to_node(cpu) so that hardware compression
drivers would allocate per-CPU, NUMA-local hardware queues.

While software scomp backends and Intel IAA select per-CPU streams or
workqueues at request submission time, other hardware acomp drivers bind
hardware queues, rings, and NUMA-local accelerator devices to the struct
crypto_acomp transform during initialization based on the transform's node.

For example, in drivers/crypto/hisilicon/zip/zip_crypto.c,
hisi_zip_acomp_init() allocates one compression queue pair, one
decompression queue pair, and a per-transform request queue and spinlock on
tfm->base.node:

drivers/crypto/hisilicon/zip/zip_crypto.c:hisi_zip_acomp_init() {
	...
	ret =3D hisi_zip_ctx_init(ctx, COMP_NAME_TO_TYPE(alg_name), tfm->base.node=
);
	...
	ret =3D hisi_zip_create_req_q(ctx);
	...
}

Similarly, in drivers/crypto/intel/qat/qat_common/qat_comp_algs.c,
qat_comp_alg_init_tfm() binds the transform to a single hardware compression
ring pair on tfm->node:

drivers/crypto/intel/qat/qat_common/qat_comp_algs.c:qat_comp_alg_init_tfm()=
 {
	...
	inst =3D qat_compression_get_instance_node(node, alg);
	if (!inst)
		return -EINVAL;
	ctx->inst =3D inst;
	...
}

With a single pool->acomp allocated via crypto_alloc_acomp() (passing
NUMA_NO_NODE), won't all CPUs across all NUMA nodes share and contend on a
single hardware queue or ring pair on one accelerator device while leaving
all other hardware queues and NUMA-local devices unused?

Also, if pool->acomp is shared across all CPUs, should the comment in
zswap_compress() be updated as well? It currently still states:

mm/zswap.c:zswap_compress() {
	...
	 * but in different threads running on different cpu, we have different
	 * acomp instance, and compression and decompression use separate
	 * requests, so multiple threads can do (de)compression in parallel.
	 */
}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103000313.1367=
7-1-kanchanapsridhar2026@gmail.com?part=3D1

