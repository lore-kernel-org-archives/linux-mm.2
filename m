Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 481EE606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g73xGVzK
Received: by kanga.kvack.org (Postfix)
	id 541926B05B1; Mon,  9 Nov 2026 07:16:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F28A6B05B4; Mon,  9 Nov 2026 07:16:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 430096B05C4; Mon,  9 Nov 2026 07:16:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0FBE96B05B1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:16:56 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9CE80405DB
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:16:55 +0000 (UTC)
X-FDA: 85415479590.17.6AC520D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id DCCCF40005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:16:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g73xGVzK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of jszhang@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jszhang@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794226614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5EAH61NrdU977284xwlV7JSstKvYCuFCm0A7SE4qcvQ=;
	b=jLPD71C//0SyVBlANum9sHUeFuVi6sCfpFB+oeDnMwDR324F9k8eBYKsQfUo+aLxbT2BYR
	MRg7UL2i/2Kx5CRZS7NL4Rw+dj7PeEgLFW3WJ1sEaJqkNddS7lHaryFtFuKb+OVKwGUYVY
	zMi45I65GM68vX4ORqUGVOXvidV+DUI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g73xGVzK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of jszhang@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jszhang@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794226614;
	b=lNwKWZ9XmYkuOEM952ZBDoPc50eZg2BrcO9vag0rpzhvK7biQ1RFhCXlLGhVwk8iFpM7tj
	ING7Nluf8/DuhivvnhYRITowrTeit9kecwuX+mE31eRa8HHRv3/IicYyzhq9JhuV5/74uG
	o5XVAKq9eB8cldo+luroIRZNJccpUhg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 223E9413C1;
	Mon,  9 Nov 2026 12:16:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D681F0089F;
	Mon,  9 Nov 2026 12:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794226613;
	bh=5EAH61NrdU977284xwlV7JSstKvYCuFCm0A7SE4qcvQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=g73xGVzKCsDCS81GLV3KO4OFB+mRx9gp+NMwK6egST5kX7bwDxGGd2lnD7uWsxe38
	 R5NM6ziSg0LlEvaNIXKBbKwC00C4d7ldcVdjBJW9bkVxWdHlkdf7soUAAa3GwGjXLi
	 TmVjZjVVQoNt45UGIxXVQ35Pehm9piXaesD3pTL2MxmsWlr+JzGRhRafI4M2LZoa9a
	 1UvHyvSVIqq+XJt/TEhZOJ7ZL6SpNvGNR9TdWjxhXYEmmiwZDGAAbNYJmZ4iCjm+3U
	 lrnUwP/yqdHKHv6auYd8/eW/fhenAirqnZiMsL2RLxLbnP72L+aIR1eSDLrgwlB7E5
	 EdCDcA/rSJCLA==
Date: Mon, 9 Nov 2026 19:56:30 +0800
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
Message-ID: <avG07pmpcLGkq5i-@xhacker>
References: <20261108110406.97495-1-cuiyunhui@bytedance.com>
 <20261108110406.97495-2-cuiyunhui@bytedance.com>
 <20261108213254.67805ef0@pumpkin>
 <CAEEQ3w=5QwwvMJFJkpS51APoBjhed6oriCkvcieRdUFWrKtmSg@mail.gmail.com>
 <avFN7LbSK0q1gsB6@xhacker>
 <CAEEQ3wmViZNwxXr8q477yHjtABStEJecCHS8=5s_UAk1hYgyfw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEEQ3wmViZNwxXr8q477yHjtABStEJecCHS8=5s_UAk1hYgyfw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DCCCF40005
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: atu71knts9hncwxujxr4wz5tjtq7qrbp
X-HE-Tag: 1794226613-947264
X-HE-Meta: U2FsdGVkX1+LEnhK15MUcwAYyz087G3Be+o4BBJtPsIzA/8xfZPvQ0/22FFwlnR9m6m8s0PIk33GzR6EeR9xGbGKmbeHmMGGeunegzkUOssHQE6rVXjf2fOkE+btIca4ud86JQcvyhCGykjCKuTVjr0bgA9Tdl6efNrT9vgpdGsX3GVorTlcHt97dw3o6uCEKGKBp5D+6Xi3uMW1y1kFt6o7kwPzP15Ozu6e+IrcSqR6TROu+IqJE148/1x5kddk/J1ZK9OBCR55ajcKcBgYThkhmu94aaX3bMgvLqQzZ73xNh4oPIat6W/fQbPeRZkA9TqfmU8AH7ckVljXpeJxzAx5DuKx2Or/h2aiH3Tkc2O6UGBpMebFRZ8ldLELNRqYX4Z9qdsSIo8jqXLF613Fca1g1dymaWzL4E59KznG0TFZ2qYi0Ti4VXptUufBkoy7c2RICynlsa/PHGgJ84tWjf7eccVHwrn868if0OO4lsihMHRY5mu5cWXP7onidjS300uOPHdtuvNi3izIvdRduI3ct+GkpkXUdHIbscc5yQQIHzhP9Tp2GjJ1p2uIIpczaOgppJF8rAJk27Ui8eTwmlc+ZmCQXra4CQyVY3yYbatAeuXA4pnZ+yG4kzZILRI4TaEuz0o8FkS0OucMcxJtVj5wliFxfXPNNIbfQ+fi9mWnvDIjGgHrmw+ddRtRNcXSNbPU70J/0TMjpu3fjfM+2yDRCfDv4JmBSuYpaylSSZaMD2ktWHvsaMEC1MjfaVjb7C1lU6rj4fazZ4yWWEQ5/OoYWBD89ZhlcdPvhJY0TddS6tUE8uMiGXA0M9r4Pnwq5ieLgniamD5uNtstlHp8vkMJZWhjLxsaBkVO1h0A7xojIsV7+X4h+j0qiaUkW4eO9bHQB7KzFQhY4/sKkGyn9RkJUqAHGCP8ULYGWelJ0uxk6Q65w02an2cOjl/jyjQqNna/gY3dZW1LoQ+lEZH
 D3iJuChZ
 Mdj7vr/VBx9KHYOUQXHbavCWOM/ZjVZ+NjO5DzzDKssWibbafzvJ3FBC9t7kdtDHYFB5tNPlpEoaDQjm81uZLPEf7SOIP6p6L5KYBtq8UXV3iMVkEe8mP/D/wc0aPSJQnd7iaf4c66sLEUjidtM/oeyzbl9X8tc/ZncVIpObqYUpOunGVx3ANiHL8Cyk6xehdmbHH29nBdY08QrXgwirPGUa4v4iVroLFqSRwLN2/c64vPicquWC9c8WfiBFpbe5S/sEb8Uu3R4culi/Rc/L+3ClfboOwwTF0fM7UfycLlCG7Rwi9now8o3iwvUGKnfIlT6jo4yQ75pMlfIxiIfwhU16uyNaVmUrHx8V2sTw3Ylk0KFKSQRiXoYi7zKod9FjZ5d5ZD+1sAQc7DFLqlUfWWHKHaAQLFQPL3L4LjSf7H4gAFxNpoXT5Mb1Gw5hE9d9d5YAq4ergk/9Z2MpabWN0+1eYrCKwm1NIErtHoO7+kA0RrNj12UNn8n71f/FR1EBfyf5H1vr4iTUMrlZlOXKZLy4EmuqhNTLFPmbPOYNycqaTm53YgIEC4i8qXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 01:49:05PM +0800, yunhui cui wrote:
> Hi Jisheng,
> 
> On Mon, Nov 9, 2026 at 12:57 PM Jisheng Zhang <jszhang@kernel.org> wrote:
> >
> > On Mon, Nov 09, 2026 at 11:47:43AM +0800, yunhui cui wrote:
> > > Hi David,
> > >
> > > On Mon, Nov 9, 2026 at 5:33 AM David Laight
> > > <david.laight.linux@gmail.com> wrote:
> > > >
> > > > On Sun,  8 Nov 2026 19:04:04 +0800
> > > > Yunhui Cui <cuiyunhui@bytedance.com> wrote:
> > > >
> > > > > RISC-V has no asm/percpu.h, so this_cpu_*() read-modify-write
> > > > > operations use generic implementations that disable local interrupts.
> > > > >
> > > > > Implement RISC-V-specific this_cpu operations with preemption disabled
> > > > > to keep accesses on the current CPU.
> > > >
> > > > Have you looked at some of the schemes (I think arm64 has the latest,
> > > > but also s390) that do most per-cpu ops without disabling preemption.
> > > > In particular they save the pre-emption check when pre-emption
> > > > is enabled.
> > > >
> > > > Basically the code tells the scheduler which register contains the
> > > > per-cpu data so that it can be 'magically' flipped during a context
> > > > switch.
> > >
> > > Many thanks for pointing this out and suggesting this optimization. This
> > > is a very useful suggestion. In the common case no preemption or migration
> > > occurs, so the preemption bookkeeping and reschedule check are unnecessary
> > > overhead.
> > >
> > > Implementing this scheme for RISC-V will require additional changes beyond
> > > the current series. If this series is otherwise acceptable, I would like
> > > to land the current this_cpu_* support first and then prepare a follow-up
> > > series using this approach.
> >
> > Hi Yunhui and David,
> >
> > During the merge window but before rc1, I implemented a riscv POC
> > following arm64's preemptible this cpu scheme. Each operation records
> > its per-cpu pointer, offset and address registers. Exception entry saves
> > and clears this state, and a noinstr c helper repairs the saved offset
> > and address registers on exception return after any migration.
> >
> > However, my PoC is based on current percpu offset.
> >
> > I planed to sent it out last Sunday, but then I found Yunhui sent
> > his percpu series(which is up to v9, I didn't know this before) on Sat.
> > So I hold on the sending.
> >
> > Now would it make sense to rebase the PoC on Yunhui's series patch2 and
> > patch3, especially the percpu offset optimization? I can post an RFC
> > with this rebased implementation.
> >
> 
> Given the substantial effort already invested in bringing this series
> to v9, my original plan was to land the current implementation first
> and add the preemptible scheme as a follow-up.
> 
> However, if the consensus is to move directly to the preemptible scheme,
> I will implement this scheme in the next revision, building on the
> cached percpu offset introduced in patch 2.
> 
yes, I suggest go with the preemptible design from the beginning. It
avoids introducing preemption-disabled wrappers that would later be
removed. But your preemption-disabled version isn't dropped, it can
be used for performance comparison. We can do similar benchmark
as arm64 does:
https://lore.kernel.org/linux-arm-kernel/28978498-348e-4cfd-af72-1146a106e96b@arm.com/

