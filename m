Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE1C0606A321
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 11:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S0cw5gtW
Received: by kanga.kvack.org (Postfix)
	id AECF66B05B0; Sun,  8 Nov 2026 06:43:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A98A46B05B1; Sun,  8 Nov 2026 06:43:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B1476B05B2; Sun,  8 Nov 2026 06:43:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 74EF06B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 06:43:36 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 69E3E1A01F2
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 11:43:35 +0000 (UTC)
X-FDA: 85411766790.22.29D63B2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id DD42740003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 11:43:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=S0cw5gtW;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794138214;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VwQGFsaaCoMROSPE2Da/1tMfn7BcmAloMkj2bJskjEI=;
	b=GXnmTs3bHwVI9VvY3u4hHCRSoOZ2d7Qel6NsA2Z1Avby6BHDYmUMFhZKBrN9SEApU3maxq
	V6F0UOtDFy4fZR08M5a0yGyt34yH3bVqYbEzmkCfr1CLJw6FUwyBKTk0fF6T7hK3fLK9iv
	mUiiKlOCrq2wtYRcti81yM/hHyi2+po=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794138214;
	b=G1i38N4SjPvvOxDusSGn0eK1JWJeCSEvGcNJzLzVBLgTxFfwTia4oLx3Z9OLz4L+9azTEZ
	U86sRgThUfbrMI7y6Z4hFuOyq/TT65OIdzI7BzHLDfFGJO4EGpiQQy+B8Q7qydc+mDzeK1
	bTUI/8CLn94Op2h67PojqAmD1SQvpos=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=S0cw5gtW;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D41016133E;
	Sun,  8 Nov 2026 11:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8753C1F0089F;
	Sun,  8 Nov 2026 11:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794138212;
	bh=VwQGFsaaCoMROSPE2Da/1tMfn7BcmAloMkj2bJskjEI=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=S0cw5gtW/h9wOfpi24c0z4XXuiTegGbNkIAjQrt++QxS99ghrd3J8Kjn2UokX7how
	 K6pRsO6eavp4mb/tlvZYnEp+IavUbQOxbBMFR1UYa1Uk63F3i2fms+alNUOuGQ8ivO
	 HW2uA/5z3dYQUubfN7n29Gyff6QIpuWu6ad1gJr21bN7rBsmEJ9CrZw58xOnEn/fVo
	 l2P05CqSaYSPPGMGKhVDsHUGfGkYlahiE9mts6LvxG7V+G6w3RQi9ARq982fiiW34t
	 pG64Uy9lv9nvE7RJMq28VoRTIvRDFkGkmACgsabYqrxFbMHFHLhpVGtKikFiIGFGa1
	 uoONW16Tdyznw==
Message-ID: <sashiko-outbox-203699@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 1/3] riscv: implement this_cpu operations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yunhui Cui" <cuiyunhui@bytedance.com>, pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, dennis@kernel.org, tj@kernel.org, cl@gentwo.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev, eddyz87@gmail.com, memxor@gmail.com, song@kernel.org, yonghong.song@linux.dev, jolsa@kernel.org, bjorn@kernel.org, pulehui@huawei.com, puranjay@kernel.org, thuth@redhat.com, ajones@ventanamicro.com, ben.dooks@codethink.co.uk, rkrcmar@ventanamicro.com, samuel.holland@sifive.com, zong.li@sifive.com, conor.dooley@microchip.com, tglx@kernel.org, debug@rivosinc.com, seanwascoding@gmail.com, andybnac@gmail.com, menglong8.dong@gmail.com, cyrilbur@tenstorrent.com, wangruikang@iscas.ac.cn, atishp@rivosinc.com, apatel@ventanamicro.com, linux-mm@kvack.org, bpf@vger.kernel.org, arnd@arndb.de, nathan@kernel.org, nick.desaulniers+lkml@gmail.com, morbo@google.com, justinstitt@google.com, qingfang.deng@siflower.com.cn, dave@stgolabs.net, emil@etsalap
 atis.com
 , ihor.solodrai@linux.dev, broonie@kernel.org
In-Reply-To: <20261108110406.97495-2-cuiyunhui@bytedance.com>
References: <20261108110406.97495-1-cuiyunhui@bytedance.com>
 <20261108110406.97495-2-cuiyunhui@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 11:43:30 +0000
X-Stat-Signature: jw4htug4wpt6utxj1aj5boeghat3x7gu
X-Rspamd-Queue-Id: DD42740003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794138213-471475
X-HE-Meta: U2FsdGVkX1/Z8ZUrkSI0pro+nYR1F+88tf0jQj7bfc5SwPsUZ7MfiQl3oFPVQTidrN/zkbSsZzY++MYlsk6TWbkB/lyS0vSljXQ5fY75X4QMVSllyHXucmzGEGAr0QxlU3swrr0s/bD2pMgq/0rV48PbKqISINPNg3yrMgg9KsWrN1fUCLjfMBgIYlWRnqYtlfwGFPAqTi8e4RSxl3QgYHEAaFLiCZeaFQgxIKUqXI8zVxHk8/aY+m55nyNT7Ey+wIiCxf8vm/OboojdDOhbuQZ3S5F373mAsb3OIkMtSMgh+ki/CYvvRybqM3efo3C9cUFdyv4gYUVcGsNldlyBReFrek8MS3Mt2a71ey788yRcGDDNRdYKLiorfKp9i8Zp/imAB2oC8Ir/sAv3RGwp8H8fYFosoJIaDSXKdOF2d/yCEjw8UrPaPQK8ByOMq7XzDUVMAE2Q7jqmWSfyma1Y70OMPbbM03C5rCMOHUDDf661+WBEVc4x8E6zrxccoy6ocPvay6vdkEpSw3G+WQGNVK3iyB+w4BzFaV7mkF69ndjAV8WbXHrkuOLmx5P0fsIURZ3Wtn3AlVXjbMq30xyPzVGMO6J9HWvrMBWRyDZUt5JT2WPdncVuOI3ETL5FCQhsatnhZC9CQwpsYyBOVgmJwZtf5v5575aQNbsERwhYzivLGKY+sfuWkdEduU5PT5Z6l2V4RW4ENNQJ5buceJ1C7O+BJqY0qDFOnHldwqDFCTkEg5PjEFZZfLNWKPM0edZvrxYx1iopmlEeYKDyqXHT5dxEyhkXQgtD0VlE+j7UA6/i5b5lTxB+qm3ILld37GZfggpl5GgLH42vtgjWgiX3g40VR+St5fI8DO+Li95VCgoLJKKx3+g5XWWfAuDs0WDei/cJ5yWcvOp3LIStvli3dU3G9gCoJrySe0sTuBpNmgSOHyXW05jGvNaFxCN/hK8eVukcNvYhUxL52A851OC
 ki2QfBPL
 u03yCdJ2GJZz4L0MXONbqpSpLF5bZenvZk4HqPgeyk0XAFv2kvCY9g1NusKTGpUU7amR0kcYwNFijgMO+1uFIfipGHTGpCOK42dPt3XtqiY5G9rDOyPu6Keb+DBnC1zBitZPVNw019tokomEu//PwZ0F4gdh+4oZiJS2kp/GMXlU3BGzYgXOU648irA5hRAa6OVjS48Y6ZaGnhkjIHFuIaN4dew9zPA7q0UkoD7pBkXeu/TcsOwQv5pShOV5NwCBrgWHvCOw5TNw+rXZsYBjl2bKoPxfEAOxGF7h7LBC1l5bGpxfBUNTnYVYeo2ML2k5FHGnx303zX/7GVu9n8XdlL1EGAtvtv5o5dW02uQgrkkTcT7b9E44a6DxIPWR/n5AmnQLaaTWEHXNqRpQYt7lTT6meqQ5W/8NHpz9hvUtFLZ5zgQqYj03UoExhKf2iD4SxiLaBCnBOitfP0k6lWn8W442hFCn24Oj9exK7CErhdSM+SC65GSCflvNvF1XtIeAD3eaTUsHpATqun8OSca2C19TIdTHPpqH/lTpjp67jTc7LWB1DOwn8V1rEw6OWuA4JsttSZm5De1B4dy2aWgY9Rm631WPkeERaFsP23Q4Y6O7TowcOa7WirP3yMrTyKngGuap0oeN335tQ/vZtVpWtkFpvGQQ9oEi7oIg/4GmRkXhVFzGeg21oxnFjkt3wG2OT6IOB7WiCAlSc8Z+MEdPM+WpGcEeFpE1+IOJf47P0D9vFJSgz0+HvAR3XXVEd/UrPipZufCgiPZQxKYAwheW89alZ7w7ozru+LAPfQ0TVDaBmSBsop2oQ/pe2zIti9/mcee0D6LwKm3Ayw00=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] riscv: percpu: typeof(pcp) retains __percpu and const qualifiers
  in locals
--

commit 9753271dee3a084b7bff8ad7ad29d76cb64e49f4
Author: Yunhui Cui <cuiyunhui@bytedance.com>

riscv: implement this_cpu operations

This commit implements RISC-V-specific this_cpu operations using preemption
disablement and relaxed AMOs (or 32-bit LR/SC for 8-bit and 16-bit accesses
when Zabha is unavailable).

Link: https://lore.kernel.org/r/20260826010748.zphu3wh2hlm4t4o2@offworld

> diff --git a/arch/riscv/include/asm/percpu.h b/arch/riscv/include/asm/per=
cpu.h
> new file mode 100644
> index 0000000000000..280b122b9fe69
> --- /dev/null
> +++ b/arch/riscv/include/asm/percpu.h

[ ... ]

> +#define _pcp_protect_return(op, pcp, args...)				\
> +({									\
> +	typeof(pcp) __retval;						\
> +	preempt_disable_notrace();					\
> +	__retval =3D (typeof(pcp))op(raw_cpu_ptr(&(pcp)), ##args);	\
> +	preempt_enable_notrace();					\
> +	__retval;							\
> +})
> +
> +#define _pcp_protect_cmpxchg_return(op, pcp, old, new)			\
> +({									\
> +	typeof(pcp) __retval;						\
> +	typeof(pcp) *__pcp_ptr;						\
> +									\
> +	preempt_disable_notrace();					\
> +	__pcp_ptr =3D raw_cpu_ptr(&(pcp));				\
> +	instrument_atomic_read_write(__pcp_ptr, sizeof(*__pcp_ptr));	\
> +	__retval =3D (typeof(pcp))op(__pcp_ptr, (unsigned long)(old),	\
> +				     (unsigned long)(new));		\
> +	preempt_enable_notrace();					\
> +	__retval;							\
> +})

[ ... ]

> +#define this_cpu_cmpxchg128(pcp, o, n)					\
> +({									\
> +	u128 old__ =3D (o), new__ =3D (n), ret__;				\
> +	typeof(pcp) *ptr__;						\
> +									\
> +	preempt_disable_notrace();					\
> +	ptr__ =3D raw_cpu_ptr(&(pcp));					\
> +	if (system_has_cmpxchg128())					\
> +		ret__ =3D cmpxchg128_local(ptr__, old__, new__);		\
> +	else								\
> +		ret__ =3D __percpu_generic_cmpxchg128(ptr__, old__, new__); \
> +	preempt_enable_notrace();					\
> +	ret__;								\
> +})

[Severity: Low]
Should _pcp_protect_return(), _pcp_protect_cmpxchg_return(), and
this_cpu_cmpxchg128() use TYPEOF_UNQUAL(pcp) instead of typeof(pcp) for
their local variables and pointers?

typeof(pcp) retains the __percpu address-space and const qualifiers from
pcp.  Because raw_cpu_ptr() strips __percpu via PERCPU_PTR() (since commit
6a39fe05ecaa ("percpu: use TYPEOF_UNQUAL() in *_cpu_ptr() accessors")),
declaring __pcp_ptr and ptr__ with typeof(pcp) * leaves them in the
__percpu address space and triggers sparse address-space mismatch warnings
on assignment from raw_cpu_ptr() and when passing them to helpers taking
regular pointers.  Retaining const on __retval also causes a build error if
this_cpu_read() is used on a const per-CPU variable.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108110406.9749=
5-1-cuiyunhui@bytedance.com?part=3D1

