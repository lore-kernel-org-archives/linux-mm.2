Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57069606A321
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 04:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N95gnPXL
Received: by kanga.kvack.org (Postfix)
	id 4584D6B05B1; Sun,  8 Nov 2026 23:57:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 409746B05B2; Sun,  8 Nov 2026 23:57:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31FFB6B05B3; Sun,  8 Nov 2026 23:57:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0A8636B05B1
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 23:57:23 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8C50EC0594
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:57:22 +0000 (UTC)
X-FDA: 85414371924.08.EF3FDE0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id E3E9CA0007
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:57:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N95gnPXL;
	spf=pass (imf25.hostedemail.com: domain of jszhang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jszhang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794200241;
	b=XBb56G1njmxJTv/6gM7jlPsGNHCHFEebWnjVkQBYj5fl2TDA77kDAchGE6ahFfQxEHuSXv
	FTmWYGM5ya6lz3/UhcRDScLfm87YMsoBysXiMNPCaq8QZmahsG+xxx3DoUJ3mK27mSc+2Z
	+6Pa7DdLWWOMQX+AfXIc2AYyWRYdZg4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N95gnPXL;
	spf=pass (imf25.hostedemail.com: domain of jszhang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jszhang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794200241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1zNWv97CstwBNheuwZjrwa0R2kSphitL/TC9zaG/Pkw=;
	b=E8SguK8WMe8DDeNPPiPeWwm9KaEESRDG3VhCf+0LhN2UCPOezNtKLmNldZvAKBT8QKoloC
	uSEv7eBFg2m43QqnRet0pGFDarLJ/NF8JCDrW4rzXi79MNjts40U0HNziiR2w3Y8GNByo8
	ccYdzwy9BwaI72UjzI9aCVdwWnBVoD8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 609B560D23;
	Mon,  9 Nov 2026 04:57:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1152D1F0089F;
	Mon,  9 Nov 2026 04:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794200240;
	bh=1zNWv97CstwBNheuwZjrwa0R2kSphitL/TC9zaG/Pkw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=N95gnPXLnpzv+UXjUpQJCQWPHnwlMCE3wfy8ChEdK4EBt37m07f/VDaAK11B2doNk
	 DpoWmXLnxhO33o2Rq+cqHz/6ZzWH2CI/Ab9KsOobE+JX3xVTT75wULQ2YLb5lYadTv
	 +fFW0HXQF2FStsCCbpdQMoIzPuinc28mvJ1Y1CAH9pGxmXXd/uDtWLoWkaXjWZicqs
	 mS9AeVlEqfs/uy+GFLoSw+lYuFZeng03TFRq82FCbwpVaVIMxga88hFuR1VVt/SdGJ
	 eiHwh7d2xs2CsPWvXC0GvHjOLiQhcO88/PK///+rvCTcwyZTUyTAhdgOWPFu3GN5ch
	 aDiNcK/jSWjDg==
Date: Mon, 9 Nov 2026 12:37:00 +0800
From: Jisheng Zhang <jszhang@kernel.org>
To: yunhui cui <cuiyunhui@bytedance.com>
Cc: David Laight <david.laight.linux@gmail.com>, pjw@kernel.org,
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
	dennis@kernel.org, tj@kernel.org, cl@gentwo.org, ast@kernel.org,
	daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
	eddyz87@gmail.com, memxor@gmail.com, song@kernel.org,
	yonghong.song@linux.dev, jolsa@kernel.org, bjorn@kernel.org,
	pulehui@huawei.com, puranjay@kernel.org, thuth@redhat.com,
	ajones@ventanamicro.com, ben.dooks@codethink.co.uk,
	rkrcmar@ventanamicro.com, samuel.holland@sifive.com,
	zong.li@sifive.com, conor.dooley@microchip.com, tglx@kernel.org,
	debug@rivosinc.com, seanwascoding@gmail.com, andybnac@gmail.com,
	menglong8.dong@gmail.com, cyrilbur@tenstorrent.com,
	wangruikang@iscas.ac.cn, atishp@rivosinc.com,
	apatel@ventanamicro.com, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	bpf@vger.kernel.org, arnd@arndb.de, nathan@kernel.org,
	nick.desaulniers+lkml@gmail.com, morbo@google.com,
	justinstitt@google.com, qingfang.deng@siflower.com.cn,
	linux-arch@vger.kernel.org, llvm@lists.linux.dev, dave@stgolabs.net,
	emil@etsalapatis.com, ihor.solodrai@linux.dev, broonie@kernel.org
Subject: Re: [External] Re: [PATCH v9 1/3] riscv: implement this_cpu
 operations
Message-ID: <avFN7LbSK0q1gsB6@xhacker>
References: <20261108110406.97495-1-cuiyunhui@bytedance.com>
 <20261108110406.97495-2-cuiyunhui@bytedance.com>
 <20261108213254.67805ef0@pumpkin>
 <CAEEQ3w=5QwwvMJFJkpS51APoBjhed6oriCkvcieRdUFWrKtmSg@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEEQ3w=5QwwvMJFJkpS51APoBjhed6oriCkvcieRdUFWrKtmSg@mail.gmail.com>
X-Stat-Signature: 8y6dgatb3epw1wqsjr63ruy69u59hzpr
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E3E9CA0007
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794200240-1852
X-HE-Meta: U2FsdGVkX1+XTJIvkq+5+e/btUph/+f4oyjIKI4VHDkCRf+1elvQkwJZ2bz0jklvTB+hv7PgiS1px+R2S0+1fMSg0vPpGe0kFaSBJsFRA5OP0uPnPvCBosZxIsbjzF9x8p4OPGqfDHN31vjdwHvvyOutwqRV9MrDA7J/DoFx5xMcXapnJXKJc87beH4MwkrFo04CI+1svGJvCcailVxj4olySbYNS+aPV8027G6VxTMRBeW0Y7AVA1q2wQy/JSpCyim7S2q522nahFWU7wK2Ap2QFDpPMH5j4s3FmkvLzh0KGCTdN1JJQj/Fwq8hI8lKzGe/1fL5kgu5TSH6bZq5LEKL3QTDP/SgQUv/I1ikMjcjFLKqoiCSAufd+0tDH6BpobgjrLLDYYSFihzY56AX71Ei1Xvk+PXgyhDRdZn+GZRpwaqb3QP5N8e9bTeSEU4w2ScNfeg53EmKK+k4pSTpKOien3HmAujj2PVTbLzvV45JqQ/X8noCJVgCIdIs4noRDMrr1+PLoHyycsQFvUA+JcVpWuMwZpdzotVNR3fIbd0Ct7X+WGfsqOLCmpgPlpwFawQreind5BLbhk/BHlFQj1+7j18l7/fOjMeZ8jAcQIbHjXqrMZfqJFmcoDC/96pysG2QMm3egrhhv3Bpl7XFgQLB5NzwLpJRHH8OtiwnRd65DE/l1A009SLbj+xsqzYEysNrWIo4H1MMbnYkhHCkSpSXsLEzwPpj5pvtIgGMjX3fGKo+B9XBErClQ+uRKpjd0LZsDrlPHX+7xiW+ltrjQ7sg+IepFKM07CsvtXQyQcRFG9BeQdHY/M+zz9LcEFqILX1Wz51CF05WZuiwH/2MIro9qyC7X9+DamrSFo5jnqjeg/RSS52ds1oXVAVZTai1G4L8qEt3Jfd4ZU8r9wqBZ0hq4nlmctzVjDh3Bd818bUhtpKjjmV6fPclmC4URxUG3pOeo1zhKEQyozSm3pN
 fEI24tk3
 766lAdf5etE1vMPTa5AlBIW4MYhMqP9wPt3KUwXY/r6IxRXr1RvLCZAghfXVHdaV0Os2QHLU9sdKH7+U15h7/ZPwTrAMsMvGrO1Byg3re5/VL07l4sFD0o+Q1fOuhtoe1LA67AUNN2V8ImYE2Zk3OsW/xfEMMDXKnEZY0Zan4NyftaZchx7TUgYQtjNVOKW12JXduxyABuBTTRVkVKDVHxv1joukdGmqSlMMXfq14UcpUBrzQ0HWqsRz0gFEaIk3cejF0QaYFaGEFNB9Ql4SOGWrYRk3ghtMiOI42REkJNEwWswcmFNvgW03O7t68GRls4kETHSoClZBpRWj1rki6cMkMC/L+6blAxPBn5Jn14E92mg2/YnobkYuRrQr/+vQuoBZq3zxmp/OhZjurbz/9ZrWRqDwkg9RJUZvk/muySsLHs5F5+Kojc9gm5/T26bOnvA8rsJEMqrrPAHUgpcbfjwt8Xnu2QbTS/6O2HQHcg/knMqtmbQ31ixC+hTN8Zpw4JhRqekwPHjrbeemyzTPnZLpx+AK2LlOlcZv3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 11:47:43AM +0800, yunhui cui wrote:
> Hi David,
> 
> On Mon, Nov 9, 2026 at 5:33 AM David Laight
> <david.laight.linux@gmail.com> wrote:
> >
> > On Sun,  8 Nov 2026 19:04:04 +0800
> > Yunhui Cui <cuiyunhui@bytedance.com> wrote:
> >
> > > RISC-V has no asm/percpu.h, so this_cpu_*() read-modify-write
> > > operations use generic implementations that disable local interrupts.
> > >
> > > Implement RISC-V-specific this_cpu operations with preemption disabled
> > > to keep accesses on the current CPU.
> >
> > Have you looked at some of the schemes (I think arm64 has the latest,
> > but also s390) that do most per-cpu ops without disabling preemption.
> > In particular they save the pre-emption check when pre-emption
> > is enabled.
> >
> > Basically the code tells the scheduler which register contains the
> > per-cpu data so that it can be 'magically' flipped during a context
> > switch.
> 
> Many thanks for pointing this out and suggesting this optimization. This
> is a very useful suggestion. In the common case no preemption or migration
> occurs, so the preemption bookkeeping and reschedule check are unnecessary
> overhead.
> 
> Implementing this scheme for RISC-V will require additional changes beyond
> the current series. If this series is otherwise acceptable, I would like
> to land the current this_cpu_* support first and then prepare a follow-up
> series using this approach.

Hi Yunhui and David,

During the merge window but before rc1, I implemented a riscv POC
following arm64's preemptible this cpu scheme. Each operation records
its per-cpu pointer, offset and address registers. Exception entry saves
and clears this state, and a noinstr c helper repairs the saved offset
and address registers on exception return after any migration.

However, my PoC is based on current percpu offset.

I planed to sent it out last Sunday, but then I found Yunhui sent
his percpu series(which is up to v9, I didn't know this before) on Sat.
So I hold on the sending.

Now would it make sense to rebase the PoC on Yunhui's series patch2 and
patch3, especially the percpu offset optimization? I can post an RFC
with this rebased implementation.

Thanks
> 
> 
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

