Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 314E1C982D9
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:19:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 483766B00A5; Fri, 18 Sep 2026 06:19:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45A6D6B00A6; Fri, 18 Sep 2026 06:19:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 370486B00A7; Fri, 18 Sep 2026 06:19:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1633D6B00A5
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:19:01 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 290A01A05F0
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:19:00 +0000 (UTC)
X-FDA: 85226484840.02.EC2F31F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8114F1C0004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:18:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nih+Cgdh;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789726738;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NK4q4bMTc4NtuqUZq2p2ouZ93CvhS6B9qDA0XHB+AQs=;
	b=hlIxl2BD4/EBCaQ5pUOW3PPCJ/gpeD5z730D8Lv/IKU+OrfK+/YKs1bxUwg2V2g3S6j7pH
	NFni8yjzEDqyrlwGIG3ZBSVw1Kqi5PG+VSClBLwWFQ7rLNLj6sl9lGpEflq/74f8vzvNbv
	jHjfyNyorI2aPLQOMnAGHdpJqpQkRQ4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789726738;
	b=eEceqA2hg9thn9hOAZPQiiINE/g7mXR4+Rw+gvZF07NVbBInqPh1B2Sr/XgLILMIEVBDA/
	ajb5y3V702wKZM70UgBwtPvWxMU8ClbH7nGC5HiSZq7TIjkuqmscabvMwHmM7r2b/Y/JhR
	/s5oXIdMq53dG62nqeXlatccxy050lI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nih+Cgdh;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 196A860A64;
	Fri, 18 Sep 2026 10:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A10E1F00898;
	Fri, 18 Sep 2026 10:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789726737;
	bh=NK4q4bMTc4NtuqUZq2p2ouZ93CvhS6B9qDA0XHB+AQs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Nih+CgdhGnLO8TOeDlPBdKPirdBoHe0i3bMXikC3kG5yEMeDAdT/7gzT4yWuBpvZx
	 W7cUWDlxizNzUCQLwfXs94uynL6mjAM7ePcKxhgXkPT+1qBU4XiAVkZUxCID7DY2Jb
	 +goXUKIBVWZDUgSR4iPriXVvwYXN8d8X9H82/VSmmMSLI/OoaAUWelD4FsQaZZammh
	 eYyGUgPR2fj74PNv1XQ3/oKvNKleNUqhIx12OPwpZiHqNhqR9DXO1fQvv8HQ/XlO0M
	 vmZ3I07NIFGVT6o1Dcu0cuUd02YdMq7cV0HFTHOA46CJjQwBsUjh8NbSWls+LhVb5U
	 tjgTt00+qSZbw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 08/17] LoongArch: kexec_file: Fix a modified_cmdline
 leak
Reply-To: sashiko-reviews@lists.linux.dev
To: rafael@kernel.org, mingo@redhat.com, leitao@debian.org, graf@amazon.com, ritesh.list@gmail.com, coxu@redhat.com, sshegde@linux.ibm.com, catalin.marinas@arm.com, bp@alien8.de, blum@kernel.org, chao.gao@intel.com, linuxppc-dev@lists.ozlabs.org, chenhuacai@kernel.org, jbouron@amazon.com, eric.devolder@oracle.com, palmer@rivosinc.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hbathini@linux.ibm.com, rppt@kernel.org, james.morse@arm.com, will@kernel.org, maddy@linux.ibm.com, chleroy@kernel.org, dave.hansen@linux.intel.com, sourabhjain@linux.ibm.com, mpe@ellerman.id.au, baoquan.he@linux.dev, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, gshan@redhat.com, gregkh@linuxfoundation.org, lizhengyu3@huawei.com, adityag@linux.ibm.com, tglx@kernel.org, guodongtai@kylinos.cn, "Jinjie
 Ruan" <ruanjinjie@huawei.com>, me@linux.beauty, hpa@zytor.com, x86@kernel.org, piliu@redhat.com, ardb@kernel.org, takahiro.akashi@linaro.org, npiggin@gmail.com, maqianga@uniontech.com, mclapinski@google.com, yeoreum.yun@arm.com, kernel@xen0n.name, vishal.l.verma@intel.com, bgwin@google.com, driver-core@lists.linux.dev, seanjc@google.com, kas@kernel.org, tangyouling@kylinos.cn, pasha.tatashin@soleen.com, zhangtianyang@loongson.cn, ruanjinjie@huawei.com, ruirui.yang@linux.dev, kees@kernel.org, thuth@redhat.com, linux-arm-kernel@lists.infradead.org, liukexin@kylinos.cn, dakr@kernel.org, pratyush@kernel.org, robh@kernel.org, mark.rutland@arm.com, loongarch@lists.linux.dev
Cc: kexec@lists.infradead.org
In-Reply-To: <20260918100442.3841135-9-ruanjinjie@huawei.com>
References: <20260918100442.3841135-1-ruanjinjie@huawei.com>
 <20260918100442.3841135-9-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 10:18:54 +0000
Message-Id: <20260918101854.7A10E1F00898@smtp.kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8114F1C0004
X-Stat-Signature: gmu8q7uaxdtked5amup5apd87uwqzjwe
X-Rspam-User: 
X-HE-Tag: 1789726738-306856
X-HE-Meta: U2FsdGVkX1/yyo2jwalRR3Ws9GBUL/+M8rClpWViAs/uNvWzhaGv68STltn5lkLxWXkWqyNaC37uVsLNZ6nlXHXRpd45FQFn/v5leFSjeY9d110dbdzfpWh7LuVQqXUVKpxIEhN8dDEvdQTXSkGKZLEXDe/rNC9x1rBWUZL7NEnHgf3fvoRKQyDmE2Md8DA8lsDXRwkfY4NU4MWsIio8A9E35WJL18uMJ+hzAQ2yrbZQKzQE1UMscZbn+4iGSF5joyg2u+Ot0YgILptYJsKwXy+unuCQiLDPMDxUWhYAjTKjQh+213Yp+md64InWYJEDA6GjwgX6He0sD3EMCa+jcFm4Y8m/2rjLFLMFhxmnlPIKtniwEuFJb/HViONDmh4IitbQIG6xlvdORgI47NkVNrG//ss9WLFXEBkyMxwiG58PFUBT1NtjN1QYkF7IVOMD+Yc9z3YViLlDzHxy7XLj/ta1hRkcHDIf9/iNgtEL5OtBkIPeL88nDY4mJFY9eCsy4v9otKpV2XRDGp5Q438FJgqJyLZvZWJZD7+5B/CKU0tNY07KAefGeWzWsq1JvV0PrKFg87jtfPoj71YVmPkdMSzsdb+VKbzWtSAkMrx2zjuTE9sCDmrpQbzRMsiF5ieKDn+tEL5mgfOVDA+mS1gyhuiIgR7rhAuFwFqBEFXw9yh2YJDeAVC3nLg+ytTDixKkv1/cS/HdBx2q7iNF5znasMfNdwlhQGLRHt5F7t4YtMSz1WB6rPdvKHZYgzonFwR7vpxnp8EraK0GQJSckmr2MezbiHoWqKhqrNJLM98VMfeJnMFq8yvLHHOzLYYjDRGkXJNoHPx/+PbQnBXx4K5Rd1t5DYpITWPBw/avC9sr18DlNUeRgLUFTlHG0R2JdOr+ajUoHJj3ZrOD4dIzHGJ0gxLTtuEuMJ4rmW2twc6EZiBZ3pyJ0uyuAK/H+6x9/yxIK1g0h6EqlCHYacHdDkv
 UUcB9wJf
 NEJi9vEVgYEFNTNS7DkoqilfZZqTm/PXjgg63tAC+VvDEib+M49SH/uYuKZjnFxC7Mplp+icTaWgfZ3X6RsEp/+W1x+OqBoNkAp17bfBUnftaWHQWIDKyRJEDUTAUEzi1bf8ivTNrFMDtJYOhZb/SQRnQTQDllUgnt0S+Mc2kRB1HOVnj2ukxFZTjltyyrlWVGEOcpBoqMNYSqVvn2ct8VQb+Lc7hzLYwexCzjZJk3PNeFRrW/Gpi3xWP0F1HwBRwI5TudQFf2Bku3gzAY+4j5gOJvg3enZEJOVngTNW/7+03D95kPmpJ9kuSMlb3PVN2J6lpAGeXP4CPKWTemO5p9v9NuhTL0ZpciqtPPigKwCcP3TFUg31EsCznh2uPfxIZkJiIBzhHaCEMUoeGItp4zG6ofOOOVGoNcBOfn/k7vvVwvWf6LUfhLmkkGxGpMgNWiXcZlVYlpbLLHab3j64ZFo/0Y2vLSI7/UcFzd4hcIlUBid/xWPUC9X+1gHFg8L7J0xvotlai/gSH2qT4btEdxm7CcBurTZinwrlzfgLmUMVOZKTYurZdIgY2R1Z9IZesJmNimEuWkuFVRZL94R24OepfmRdSr4+SpO4zalvM+z/zQzhP9j5kpKW2GYiRNUMeRrfUJoJyKhi0YPBAH9numdzz48pPhzinntzUcIkZivJLJLYRhUcBfAfCF9A8Rs0bWxp17tabKYBHw+IPX9tg3QNmMoMhQsaL0nxzvElsVp82SLmmMxabPD+iATOhVi6yrWr4WhEP2Fz5qkCY02BTJ4osua/UvLspKBNT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> load_other_segments() allocates modified_cmdline and stores it in
> image->arch.cmdline_ptr.  machine_kexec_prepare() then copies it to
> KEXEC_CMDLINE_ADDR and overwrites the pointer, so the heap buffer is
> leaked on every successful kexec_file_load().
>=20
> Free the buffer after the copy.
>=20
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: WANG Xuerui <kernel@xen0n.name>
> Cc: Kexin Liu <liukexin@kylinos.cn>
> Cc: Youling Tang <tangyouling@kylinos.cn>
> Cc: Qiang Ma <maqianga@uniontech.com>
> Cc: Tianyang Zhang <zhangtianyang@loongson.cn>
> Cc: George Guo <guodongtai@kylinos.cn>
> Cc: stable@vger.kernel.org
> Fixes: d162feec6b6e ("LoongArch: Add preparatory infrastructure for kexec=
_file")
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918100442.3841=
135-1-ruanjinjie@huawei.com?part=3D8


