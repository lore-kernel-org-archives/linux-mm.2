Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B984F606A337
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Lv0uE8rD
Received: by kanga.kvack.org (Postfix)
	id DF8E86B05BE; Thu, 12 Nov 2026 06:30:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D82506B05C0; Thu, 12 Nov 2026 06:30:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C71EA6B05C2; Thu, 12 Nov 2026 06:30:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A67DC6B05BE
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:30:52 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2A3CA14055E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:30:52 +0000 (UTC)
X-FDA: 85426249944.25.C6B8103
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 702521C0002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:30:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=Lv0uE8rD;
	spf=pass (imf18.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794483050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4VQE+wCw+63cnThzXfE5m3Wkr677M0OSU+v7x8jQn64=;
	b=q9ymkithQJ4iPSrTLykIJs55GYlckyQcxLbQvQ1Zzo0877NmVOIh+NrEbBIU7Xc5aT2CU4
	HKYSZOjUQqYzyU17l+nLKpm2zJcpJrqTAQXE5STJspanHsR/SkaGzJaJs5MlpQJOPS7WRx
	3HDC6kihCQgtZsow9JFVTy7voL6MfuI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794483050;
	b=ArqQFibAM+lJX9dn+oTC2U3qAUZofiq8Pt2Y/sxErRffR4c3jeecwla0wYukLLLtFJOFvY
	bPp6pqJIuq5uKR9YYDHNqrSxqmXDYzHKGXKRTqxVhVoJi2iyr+q8I317atjJFh3gp9djlz
	jcE6PQomoUGokzEyooJ6bM4OR0YZ0Ao=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=Lv0uE8rD;
	spf=pass (imf18.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B6BEA40AE9;
	Thu, 12 Nov 2026 11:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758841F00A09;
	Thu, 12 Nov 2026 11:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794483049;
	bh=4VQE+wCw+63cnThzXfE5m3Wkr677M0OSU+v7x8jQn64=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=Lv0uE8rD32wyRfV5sPXfxmly+/H4WSct6DgNgB+borGLOHQHrPLIX+nDFWq8WIR5a
	 6AtC7CnbNeLwvde/cSjhKEvSpenf4t0Wu4NTtXot75V8BVGl2rFunUOcGyNsN4UI68
	 wNERe8a2KaEWMchf+DBb8Bs1DvhulbUFaoAuvnrKGZEac6tb6LCixMCO2ciI45WqCn
	 5rzApcOojjQxqR7Be5XjATEt71gD58xH7QXIWmI8trxikOKPyX7zLM0t/f/t7TwpTp
	 molNGWnrHSHxcdMFd0azahw83gPRaA1oGx6MU/a7XQjmmEtHkAo1P+T8dMYcy21pbm
	 BNy/IJvPTGAsw==
Content-Type: multipart/mixed; boundary="===============8011434571142281874=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <9c88485e232da5a503d56c83b14b7765e672fd0c4ccc92686c342cec03c8e350@mail.kernel.org>
In-Reply-To: <20261112104149.38589-10-cuiyunhui@bytedance.com>
References: <20261112104149.38589-10-cuiyunhui@bytedance.com>
Subject: Re: [PATCH v10 9/9] riscv: select HAVE_CMPXCHG_LOCAL
From: bot+bpf-ci@kernel.org
To: cuiyunhui@bytedance.com, pjw@kernel.org, palmer@dabbelt.com,
	aou@eecs.berkeley.edu, alex@ghiti.fr, dennis@kernel.org,
	tj@kernel.org, cl@gentwo.org, oleg@redhat.com, ast@kernel.org,
	daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com,
	memxor@gmail.com, martin.lau@linux.dev, song@kernel.org,
	yonghong.song@linux.dev, jolsa@kernel.org, emil@etsalapatis.com,
	ihor.solodrai@linux.dev, bjorn@kernel.org, pulehui@huawei.com,
	puranjay@kernel.org, broonie@kernel.org, cuiyunhui@bytedance.com,
	dave@stgolabs.net, david.laight.linux@gmail.com, jszhang@kernel.org,
	tglx@kernel.org, conor.dooley@microchip.com, thuth@redhat.com,
	ajones@ventanamicro.com, ben.dooks@codethink.co.uk,
	rkrcmar@ventanamicro.com, samuel.holland@sifive.com,
	zong.li@sifive.com, debug@rivosinc.com, seanwascoding@gmail.com,
	andybnac@gmail.com, menglong8.dong@gmail.com,
	cyrilbur@tenstorrent.com, wangruikang@iscas.ac.cn,
	atishp@rivosinc.com, apatel@ventanamicro.com, arnd@arndb.de,
	nathan@kernel.org, nick.desaulniers+lkml@gmail.com, morbo@google.com,
	justinstitt@google.c, om@kvack.org, qingfang.deng@siflower.com.cn,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, bpf@vger.kernel.org, linux-arch@vger.kernel.org,
	llvm@lists.linux.dev
Cc: ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Thu, 12 Nov 2026 11:30:44 +0000 (UTC)
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: oyag699msbpgncpo8dwumoxkwxf5h9x9
X-Rspamd-Queue-Id: 702521C0002
X-Rspam-User: 
X-HE-Tag: 1794483050-843714
X-HE-Meta: U2FsdGVkX18gg8+Ub7ZX/hdtI25sKYUSVS+zFpGZT5nmzdTJGeBLsscSYbqubzSSb9UouWMmSzFsLa2Hx8RxBIXKf0sr9fgQI7Ae6qYlfTUbykzyPFlnotZaK16VeJaflK3hp0jP2n5+8h2bLBbj3xHa99FlpIlGT+yP+vNzyT79hbaJCe+mx/9EkSWpzmywPC0L4a7FCzMtnxhs+Vzhnk82fa4gY4zoO0oJ1P6/SreupwuZCwGwGmsORw4hvV32UyXGB/ZxALV3qW+3rZkSMazOwPuTDPAb9w/IzXOcTyxCdUgKQLtYHSM11WOrA9rp0KeyMeAIxk/kLImmxlnBcycmlC0kLE7rCkBGsjmbGLg7eHzNUW4NzwR6Tiv+F2jZg3T0VgE6EyLCmIEP18VdDpUnHgRMxu5rxR6xnGjDEZ19l4hZhi0Bgt73q/G65emS8/cGylawYp3tYCaRlLwIwxxiD60XvDHXekcvuda2R5algVL5NckQGssNlRVGpnFXC4+VOxTrUgNqjaysme0W6QcV/OMddiiVSfSUTKKtX9om/d9pdQd0Wk3peWo+6T5XznthF93X1Kup4Gh0Rad5BdxEWR101fQGwyQqA7Rh2V1KxdPXwk1ONmKIsgXTv8WlEeWRlUVl5nGXSW9vcSFtn8hqLDBj/WybpKmRHjTUrO5B4W+b3R0qhacKqMlAThyrghde/OmhSgUT1ydx2pQE3g4Wy0e4lxAtd29isaOgVu+Iuxyexnz54Y+qVdBgbbL+AYqPAOPiulUcj+lNO2ZCoPyMHWUW/2iCvgcYhkWonrEePrv5XtdZuNocIYwcxqRIVoImNoK29PMrJFyh19MwyTdDxOxdEYmu5T0Tcdq4CcjMkE6MQryxA/DnwX1Xh4Mgms4zNsP7vYPSeFOO7GEum+BSkuU88pr7XAGbGzSSgy0tiwP3VWiVXiH/l8kNVRCVm7YBglxnHhyY4F+F7uQ
 dFgcnkHh
 w2rkQC/wE5uZqICYs7lmlVZBQCwDmc0E2Oj0vgJiOyUq14Gv4c/hfNblU6jaZl9ad8byC02RH4HePJ25C95wja1l7T+eUpLHb27Pa5FhwRD1vTVnLBCApNoEEoR9DhSEWL+T5yerrhkwS9wFIkUuF/O48DHJ4zRm1HdSU7Cf5J76OA2thrwSrLLhV4MxEoMAHH0YCHPY58yjkeVCSETZeiatNNg0YhFWI0v2AmI/jdfqBqeBBaIz3672Q8Ojz1wS/0adUKDU8Et4NSFK4pQCG1u044Do5b6zQr+daVFksAEZgyLZWtvxH++qUP02vC/tkqOMUUrJ7XOUFBxwYryvxxsl36KCUK3bYRFmgSY3JpztbPnNi9w4iOmOSiSOF9LYmTKH+lvf+X85N2gLR2jhWedkNCrKTIxICuTyeB4tuskx/KTeYUOo8CPiuAis1ZH1YuWcuVo/Is6QvGVNac/ZMoEW2BvKShrhuiqm6jBjQV5yXMKLDsW6voB1GyW+ONEvYCVFHKMq6rRAnhpEdjKee6JRt4rXDfFLyMgXZZdYRvL8YLRiGGmwbjF8RX/1juFHGyQw/G879f+j86JidQG2uc1VOXURrfwSf002yUF/gcdI5J8WLlRruTJJgOZl+ZIyNvDK8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============8011434571142281874==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> riscv: select HAVE_CMPXCHG_LOCAL

TL;DR: Nit only, no runtime problem: selecting HAVE_CMPXCHG_LOCAL on riscv may
need the cmpxchg-local arch-support.txt feature table updated from TODO to ok
in the same patch.

> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -155,6 +155,7 @@ config RISCV
>  	select HAVE_ARCH_VMAP_STACK if MMU && 64BIT
>  	select HAVE_ASM_MODVERSIONS
>  	select HAVE_BUILDTIME_MCOUNT_SORT
> +	select HAVE_CMPXCHG_LOCAL
>  	select HAVE_CONTEXT_TRACKING_USER

This isn't a runtime problem, but should the feature table be updated in
this patch as well?

Documentation/features/locking/cmpxchg-local/arch-support.txt is keyed on
this Kconfig symbol and still lists riscv as TODO:

    |       riscv: | TODO |

Nothing later in the series changes it.  Other riscv patches that select a
feature symbol update the matching arch-support.txt in the same commit, for
example d1f014012571 ("riscv: enable HAVE_IOREMAP_PROT").  LoongArch
selected the same symbol without updating the table, and it needed a
follow-up in 0c4c9abbf68b ("Documentation/features: Mark cmpxchg-local as
supported on loongarch").  Would changing the riscv row to "ok" here keep
the table accurate?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/43205409812
--===============8011434571142281874==--

