Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AC30C982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 09:05:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BF916B00AD; Tue, 22 Sep 2026 05:05:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 570386B00B1; Tue, 22 Sep 2026 05:05:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 461B36B00B2; Tue, 22 Sep 2026 05:05:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 175B36B00AD
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:05:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C34971A03CC
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:05:03 +0000 (UTC)
X-FDA: 85240813686.03.EB3F692
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 266E7180002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:05:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k9LHr2Wd;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790067902;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gVJZTypgXfKJStNVi3R0a2JQB/tvx6NLIBfpEAfH+Ko=;
	b=VpdlLmQNMGGSMVR4GQRmJr82G84lRQ6cfrXgv19v9zG1dWtJgaDRaPckuq3qOZPP7T/Tki
	X111c0X+eq6JIRahZ8d/qxR+NCuPIjWW3O32KzJaxvOjhXLytOXEEYlnLUcsRM+dJN3wha
	Sy6L4JPeJUSNOChcLu/uMAo25ePOOoQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k9LHr2Wd;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790067902;
	b=8XrA/X+iyGHfJ3qj7aFJJWuZb7ZA+iffm/iiBxyC73TI/jtyAZx+3bsqDtgSdH4JNqVKei
	V52u9KUnOkc8nFIM0nB63MPDgfMANeeHa1GgA2C3pXqwycMLSVpB+wFw0HkVsgcglD7Q7X
	BrjzONL1NslUfePj18FWJUocvEjv+J0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 589CE408F4;
	Tue, 22 Sep 2026 09:05:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5581F000FF;
	Tue, 22 Sep 2026 09:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790067901;
	bh=gVJZTypgXfKJStNVi3R0a2JQB/tvx6NLIBfpEAfH+Ko=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k9LHr2Wd4Rxx3+1boxWUT9I2oXWCmuvgxijo5nc6bPCgxtO998Rsh7NKemCZPMZ7q
	 jCqEgkFPjzxPK4mReOTTd/elY+ciGLQH0sdAs9Gj6meNVO4LfN2kzV+4LXR0oVx6SK
	 7ZH/T7Wv5A2AUNswlgh8q3cB2VzM3drCJ2lhSUow3TBR7t+5QqoSZi80Bp+U336otT
	 6+pWL7hrOojomJ2u753Enniueu6LZnlrBvU6X6vwp9prGtDnyfBK/IXM5CJdbxbR9Z
	 4Y6VvuOiSdy8+S0cHn5PGHelRvFyfDPZFS7siU3DaFG8DB1NQi0pi6gHzGpuQPP6oN
	 01swkhQ7UyoBw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 8/9] of: reserved_mem: mark /memreserve/ entries as
 MEMBLOCK_NODUMP
Reply-To: sashiko-reviews@lists.linux.dev
To: robh@kernel.org, baoquan.he@linux.dev, "Wandun Chen" <chenwandun1@gmail.com>, rppt@kernel.org, m.szyprowski@samsung.com
Cc: saravanak@kernel.org, pjw@kernel.org, conor+dt@kernel.org, iommu@lists.linux.dev, ruirui.yang@linux.dev, linux-kernel@vger.kernel.org, mark.rutland@arm.com, loongarch@lists.linux.dev, tglx@kernel.org, bp@alien8.de, x86@kernel.org, pratyush@kernel.org, kexec@lists.infradead.org, chenhuacai@kernel.org, hpa@zytor.com, pasha.tatashin@soleen.com, mingo@redhat.com, linux-mm@kvack.org, robin.murphy@arm.com, linux-riscv@lists.infradead.org, aou@eecs.berkeley.edu, linux-arm-kernel@lists.infradead.org, alex@ghiti.fr, catalin.marinas@arm.com, will@kernel.org, devicetree@vger.kernel.org, dave.hansen@linux.intel.com, akpm@linux-foundation.org, palmer@dabbelt.com, kernel@xen0n.name
In-Reply-To: <20260922084256.1515554-9-chenwandun1@gmail.com>
References: <20260922084256.1515554-1-chenwandun1@gmail.com>
 <20260922084256.1515554-9-chenwandun1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 09:04:58 +0000
Message-Id: <20260922090459.2B5581F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Stat-Signature: keyrp81zj86uuqe7rnenmpzj56zgot6n
X-Rspamd-Queue-Id: 266E7180002
X-Rspamd-Server: rspam07
X-HE-Tag: 1790067902-218712
X-HE-Meta: U2FsdGVkX1/g4DiJ/ErfUCg2lP1tY20pTIBCvcEcS9R6bHw7KAlsh/Zi7dxlEd2X4eyTlqQjoFWlCjx7eRyqNRl7M0zTHk3TQyf2yaYEL+dI4lqBlcobpwZvtWA2OCOvQpzbWLIyrvMRzN/jju3rXkBvykc4/A72cZRC6PKMKlEGg20NNoZogNE0NA8IFIOQ+SSUJtPW02sG/fG5xXBaTv9nBl7OGzYOFCZQwRv+VSRFPK1iOkxDp01CNAktVgh5+cZriZTvcloRAgSw3C9DB3R4bFdaClXj6zbyokEbZhZHq0N+6xakG7eOJS1q/QrujDUrR0XvYYreAOZ/OnoFecvZalXuXbGpB2nk9RVxdfkHInhG5Y4zFECxBS1sdvFR4c/Yfmp9bM1EIekGF0dHSlSjr47rbmw0GTebBWk5Qf2ZN/JQrtVzYTwGz0DARh+jVbAeCET7i2JVf7b6ihcs/ToSZLlc/uSoUfRUWUdzExUWliEyEBx1SUqKmAHTW0tmV7JfOPpxmfWk7vZa89f6bBiV1V25TivBE11oSqv4z64XaYnQnLYjjRldCXEFrsApakCxnBo/xoOPy0URbDQKB9eDmJrcnETaL8r/dWIDnHWNqeexItZSaXvSXXaRrOy2qlfccP8936uWnJKa68sF39cnzFdqUm70RNbX74nDGzoBal/Ojr5yAFTfi8Jvvm1kMdqFngNTLBGOrk8SiQM3+Gy++RF8QNN5heuYi2N+E55CM5coFrBbtEt8tu9fN5lKA7liTAMZZs66dOrlToQ1swFAKRX36CpqtVf6e3Lu5nvmIuDjOEmHZKQoIqdyHzTia73HufNTC8SfKkVUjaTypCorOb3DdhexIR8K1HRZVkxfHCndcVv/YYShYjTQ/Yc+kQaOeWCz+nMrKeUG5NORno1yYFLM9uk0rlTV9LwOhLTO4w6eSvQ2qd6VXXarxXf/4CYr1izoFQM2VEQ1v+L
 QIuXhVTu
 xA1ts4fhL2wQEDPjNmKQw0TUHZnAc8Nr4F7MK0C+SG5eqmxgLMVTL2PK1vnE8IY5Bar3yR68jyGj6Fj7rnCp9QxplIOIcMp79TRBUCYN0CIrwJsoEDdMfKPF1LGSWx+W0HB1U6nLEsYKSfnanT9by+z2M91GNhO/54qTbawcCobrHyy12F/5KSCvq86YbTuRb6TcfD6bfzfbczfxwd+dFqyrbJDJlAkyewC7iud+b7ZcdoQZpBVuxqcFcmAaB35UJcv3SOkmadUU9Hoiev45HEhG2RxblV8OZqRSdZ8gMC/rRwYawtkPghTJYaSXyntRaRn67I3GCYBNL1BVS4tTAGMEI65UYRm3gNTwmoSpzEHlAuFbqWR+RrGEWE4RWlHPokHgnVSjFzdzuYFv/m+LOc8JLRy6Pe6wiWEY0F5n8JEPQU/cZ7JiZ9jQrrj1RlBdNbSxAwAtqjEGTrzXLh8fv0Y8hqu2ByWTUzNY3ZXYX9/BZu3gVTRHWRJUHHkgXaj8u7+1kdo7Vda0psLy12PLLlvfb7aO8vbP7sfw7ucwwV+QzAQtgwwZAf9+kZ1cOqDYYKhIAZ6pizE7Bsr5hc4LKhiIJlqt1EIaOiNayhO8N0rd5LN05UrQ654AeAp3HsaobT5ovzfuWG97YXArFukBdSVHLfekcSgMLc2u1rLLuFKONB1OgLOUCq/umpBNI2+qzM0sGDgv27eYbXfxFA8DA6OZGV3STqbjxcUsIgEFCOHTzBE2mxjpnKAYx8fXEkfFBd1CzidIbRxkG+n5NBjxsc7GXQMfSDvvQUT/THsKIILnIHM/xh+fVXc+CpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] of/fdt: silent u64 truncation in fdt_mark_memreserve_nodump caus=
es nodump false positives
--

commit 070ed699ada4d456618a640c6ad541abbec98f95
Author: Wandun Chen <chenwandun@lixiang.com>

of: reserved_mem: mark /memreserve/ entries as MEMBLOCK_NODUMP

The /memreserve/ entries are memory reservations made by the bootloader
or firmware, their contents are not needed for kernel crash analysis. This
commit marks them MEMBLOCK_NODUMP to omit them from the vmcore, while leavi=
ng
overlapping dumpable regions unmarked.

> diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
> index f29a07e8fb23e..a42cf6eac55b5 100644
> --- a/drivers/of/of_reserved_mem.c
> +++ b/drivers/of/of_reserved_mem.c
[ ... ]
> @@ -251,6 +251,39 @@ static void __init __rmem_check_for_overlap(void)
>  	}
>  }
> =20
> +void __init fdt_mark_memreserve_nodump(void)
> +{
> +	u64 base, size;
> +	int n;
> +	const void *fdt =3D initial_boot_params;
[ ... ]
> +		for (i =3D 0; i < reserved_mem_count; i++) {
> +			struct reserved_mem *rmem =3D &reserved_mem[i];
> +
> +			if (rmem->dumpable &&
> +			    base < (u64)rmem->base + (u64)rmem->size &&
> +			    (u64)rmem->base < base + size)
> +				break;
> +		}
> +		if (i =3D=3D reserved_mem_count)
> +			memblock_mark_nodump(base, size);

[Severity: Medium]
Is there a risk of silent truncation here when passing u64 arguments to
memblock_mark_nodump() on 32-bit architectures?

The u64 base and size variables are passed directly to memblock_mark_nodump=
()
which takes phys_addr_t arguments. On a 32-bit architecture where phys_addr=
_t
is 32-bit, if the device tree contains a /memreserve/ entry with an address
greater than 4GB, fdt_mark_memreserve_nodump() reads it as a 64-bit value.

It performs a 64-bit overlap check against dumpable regions in reserved_mem.
Because the upper 32 bits differ, it concludes there is no overlap. It then
calls memblock_mark_nodump(), where the compiler silently truncates base to=
 32
bits.

Could this incorrectly mark the lower 32-bit address as MEMBLOCK_NODUMP,
mistakenly excluding any dumpable region located there that the overlap
check was intended to protect?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922084256.1515=
554-1-chenwandun1@gmail.com?part=3D8

