Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B79F8606A323
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 11:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ItgUl6Pz
Received: by kanga.kvack.org (Postfix)
	id CDA916B05B0; Sun,  8 Nov 2026 06:58:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8B7F6B05B1; Sun,  8 Nov 2026 06:58:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA2206B05B2; Sun,  8 Nov 2026 06:58:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9A0736B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 06:58:49 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2ED50C0408
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 11:58:49 +0000 (UTC)
X-FDA: 85411805178.09.A2322D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 829F8C0002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 11:58:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=ItgUl6Pz;
	spf=pass (imf10.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794139127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=frdSBuiNZsaClAfWL1rszk93uoKIYFoT/2az2pnoHt4=;
	b=v0GHP5iU61d9OLJ3xxv3ZHV5iRPn7gR3Nm/CumHipB9iHa5+uoB7RpnNvo9sNNq5hMvz13
	UDyTv6CqT9k1ixAHrs1WqW33Yoftqq2sy8qt4bFPqUbNIgjiJXJL+S1tLM95kXEgzzgJRq
	JDUMyO51gypGROsQsHpgKL+NicLbYg0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=ItgUl6Pz;
	spf=pass (imf10.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794139127;
	b=e9kC7AB+sNYu03c47vQP9gEjZwrRHVD3pKR5B2KJ67++UyEFps35I/CT1Q8ZnMg0dStFp6
	pchIOanqjQMvXhjQUmogLiMHr5LAGEtC5j6z/YgbkrajBMWKob8u9giZu4048/Q5Y9HeeG
	z5fPeNZU1fetS/SgJUlonDo/V0kfNpI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B673B43349;
	Sun,  8 Nov 2026 11:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A932C1F0089F;
	Sun,  8 Nov 2026 11:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794139126;
	bh=frdSBuiNZsaClAfWL1rszk93uoKIYFoT/2az2pnoHt4=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=ItgUl6PztSGNn2uQTaSE+c6elZ9dMsyQ66yn/YThcn1L1YS4hJFN5IQlHvj/kF/z1
	 2d/R7zA2en/UUgYrH/8IyMFqGeJtvBopjb584BWfSR2dG/uCQvL8WWgq7iczslSCHW
	 g9jh31BAYYxunw1f8Ybd70aYzBl7tUwxFyf83fm2gqAAuXqBEIzgRMhXPK+sWrknzs
	 yMomCSE/ysWqphi5xPPltDnJvmfe7v1TaeNySdKNo6HydM3ejnHBPeHMRBnoylZmCQ
	 ut7bXtq2vbcTEu6vTCD0q452CzUGVIplVMci32BvaekxFaPtw37zCLVdnVlEtEhCt/
	 qcPGw/hRNSamQ==
Content-Type: multipart/mixed; boundary="===============7105721968340737727=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <61dfc5e627706ca6bd1b23fbc8e9e4af7196ac827d3089fcc038079536f848eb@mail.kernel.org>
In-Reply-To: <20261108110406.97495-2-cuiyunhui@bytedance.com>
References: <20261108110406.97495-2-cuiyunhui@bytedance.com>
Subject: Re: [PATCH v9 1/3] riscv: implement this_cpu operations
From: bot+bpf-ci@kernel.org
To: cuiyunhui@bytedance.com,pjw@kernel.org,palmer@dabbelt.com,aou@eecs.berkeley.edu,alex@ghiti.fr,dennis@kernel.org,tj@kernel.org,cl@gentwo.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,martin.lau@linux.dev,eddyz87@gmail.com,memxor@gmail.com,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,bjorn@kernel.org,pulehui@huawei.com,puranjay@kernel.org,thuth@redhat.com,ajones@ventanamicro.com,ben.dooks@codethink.co.uk,rkrcmar@ventanamicro.com,samuel.holland@sifive.com,zong.li@sifive.com,conor.dooley@microchip.com,tglx@kernel.org,debug@rivosinc.com,seanwascoding@gmail.com,andybnac@gmail.com,menglong8.dong@gmail.com,cyrilbur@tenstorrent.com,wangruikang@iscas.ac.cn,atishp@rivosinc.com,apatel@ventanamicro.com,linux-riscv@lists.infradead.org,linux-kernel@vger.kernel.org,linux-mm@kvack.org,bpf@vger.kernel.org,arnd@arndb.de,nathan@kernel.org,nick.desaulniers+lkml@gmail.com,morbo@google.com,justinstitt@google.com,qingfang.deng@siflower.com.cn,linux-arch@vger.kernel.org,ll
 vm@lists
 .linux.dev,dave@stgolabs.net,emil@etsalapatis.com,ihor.solodrai@linux.dev,broonie@kernel.org,cuiyunhui@bytedance.com
Cc: ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun,  8 Nov 2026 11:58:45 +0000 (UTC)
X-Stat-Signature: gr8zuousyrqyne7jhy49r1qb4y8i7w5d
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 829F8C0002
X-HE-Tag: 1794139127-165983
X-HE-Meta: U2FsdGVkX1+OS1zC7fEKx10XeVeIDX4rUCXtEcwji5oI0mI+y5NSTA7O1jbb3+nA6C9uwmQAWSU4kyZ5GEhnLdD9Q243I3ktCeAcSCSkaXZcbvAO2WT5xyVrGt8T8StSPqtDGKoGjwvRskjOZd1ULFMTj9y5u+bR+SfOoo84SFFB6dfRGkIVjWb+vtSi5af4XLKgNXdELuAf5iHu4hM+lR7KSE6Ong0v+qTwJls7bEEFZ9EJ5jiSBLKXenCyPXwNpKZYaiQ9zHGEY5Sv5okBQVdPtTlDrapg0Ic6LIMvuc3vmZzG+Wq8LAM3/m0En6G4zJ19timrjQw0Um0aFTEOefh+VUwvf/4HOm4W4rqYQn76kq2/ROM6Q6F1vXvTKOLIYA960bjh5ePCK5aQWBFIbJNuXEaIE7cKMqejFz7F6E4KCEbeSLoy+ki7sLKWGSXgZ1QBCtjzGil8TKmhYZt3KurmmN96M5FzeEjwQwrPI/gtVOEPNzRJkfGSfL+fSpFk8eOfWYUYAvtzc9poNJ8uLsojlloszuNZCO67GuwxK6+npl2chn3NMsKeDNWxIzwgvamaXpylh0uuH5nNiRHXNFDMeVHbVl2Od5hFfsfZ58cpbSk8RSVZoN0HDvQglFKlWnUURFeD79Vw800AS0RSYq63OPe10CsJ4bB+MbNU161jgd8GNeuM7zAas/O/ef0rpF0gj9um1gupEMxlDJaSDDu2L20SSgrlYn7GydezxHkYBVHmtacYFrs0Ee+zYcYlNos4hzxIxyKqbMgV2s34E8m8RYHRLAOnIoNgQeBqFvZHQX2gaJJYiN5zIY83WovRy5bYx38l/P8jNH/w/dFUInhxPQ1yu1pWRcovAOhWEzQ3lis69+AZqbedxs1RoBLasI4Pa7JVQJ/avxrfULxXAI+HC2gUdEJ0tSThPMPECTvJeahCqc6i4Xu/S2KjoBqnLREzxgkSItJAVTnNDAU
 7HgS5ExH
 fPbhf3pOZ+aaBHDaAdhi0ae5gxrndlwDoezihEV3zkuYHJRu5g1TJtYpx8LMpx9fczsRaqQOWkaQJgg3V6uuQhqWk0rgxgpl7/WgYmfNvUMYnBHwFJaTkhd4LBvmtTWSOVI7I4Hd58uCUe/N0GSEw48x1Bx3hLFnqRbzoqh/jM9BqTqS+8WE12um6oD9dxOB9EYE5l653TiTcFvqOYEVwq1fJJkT0c7fjOJ9H7LNcpynoghAzXT/oz6cS4YWKESL6TnLZLHxlut8pyXsHVId6Ryr2gGZtKtJFsnzKexcYOQzCiYC5hfNns5zIymYEhf9N4M5XLQz5Ip7dy1qrBMMD3yBCHubuzXIolST8bLDdwaghQJQMDacc/bu59eg4Blv475hL+cnL6igxpSImt/15eyB0tsbFjKPVy2GIwjsjNrI3XB2rOv9qxU9Wxz/NwZscxhktU5gaeQQ6krqFSZqJbxLWQpRMvhKpqhNUh3dtaCBR4SyX/zuHlaPoSTFI0PFpQkHXXXKotJbuLyjNRur28eeQZNTmwgJp6AiQNlNEV7IDwzVezOhhT5ssIAYlczqhn/1tpB9uebMsjdWwsf2UAzGjq4QIGuT+UqH2EWlTyTqcyiOhJdTMT/QygmDVXwfdWeSc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============7105721968340737727==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> riscv: implement this_cpu operations

TL;DR: this_cpu_write_N casts val without parentheses, so expressions like
"zero - 1" or "a < 0" may store different values than the generic code on
RISC-V; no in-tree caller found that triggers it.

> diff --git a/arch/riscv/include/asm/percpu.h b/arch/riscv/include/asm/percpu.h
> new file mode 100644
> --- /dev/null
> +++ b/arch/riscv/include/asm/percpu.h

[ ... ]

> +#define this_cpu_write_1(pcp, val)	_pcp_protect(__percpu_write_8, pcp, (unsigned long)val)
> +#define this_cpu_write_2(pcp, val)	_pcp_protect(__percpu_write_16, pcp, (unsigned long)val)
> +#define this_cpu_write_4(pcp, val)	_pcp_protect(__percpu_write_32, pcp, (unsigned long)val)
> +
> +#ifdef CONFIG_64BIT
> +#define this_cpu_write_8(pcp, val)	_pcp_protect(__percpu_write_64, pcp, (unsigned long)val)
> +#endif

Should these casts be (unsigned long)(val)?  this_cpu_write() passes val
through unparenthesized, so the cast binds only to the first operand of an
expression, which changes the stored value compared to the generic
implementation:

  u64 pcp; u32 zero = 0;
  this_cpu_write(pcp, zero - 1);
    generic:  0x00000000ffffffff
    here:     (unsigned long)zero - 1 = 0xffffffffffffffff

  int a = -1;
  this_cpu_write(int_pcp, a < 0);
    generic:  1
    here:     (unsigned long)a < 0, which is always 0

This is the same problem arm64 fixed in 885bff055a0f ("arm64: percpu: Fix
this_cpu_write() casting").  I did not find an in-tree caller that
currently triggers it, but a future caller passing a binary expression
would get a different value on RISC-V only.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/42475504268
--===============7105721968340737727==--

