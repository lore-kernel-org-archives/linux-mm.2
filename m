Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10948606A323
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 05:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=ANxVLj8L
Received: by kanga.kvack.org (Postfix)
	id DE55A6B05B5; Mon,  9 Nov 2026 00:49:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D951D6B05B7; Mon,  9 Nov 2026 00:49:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5D9D6B05B8; Mon,  9 Nov 2026 00:49:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 86BB76B05B5
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:49:21 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D92EF405C9
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:49:20 +0000 (UTC)
X-FDA: 85414502880.01.689C0D0
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2C2771C0005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:49:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ANxVLj8L;
	spf=pass (imf21.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.161.43 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794203359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KffYBetHs8Ajm29Uu5eM47VHa8AaiRvO1sJNqwagpnE=;
	b=Gz1mKsSNHYuh0X/d1TswzNMX45k5tNesLPFGF2O5dvb6S2NgOO28Sc8L3I2Es0GL3XyeND
	Dhh8M6OFTHdNOhdkG9wTBCGedyOpttrII1Y0Clpa2WkXKFUV8FjjA1uxGUGkETDsyo7BJn
	Y7uLfjsUj2Tb4Z6M32uS9xRcrMD/WUg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794203359;
	b=cI4u6R6Hw1XeklIvB+DDbgxnMQrEb2DfC9jT5CzZIQhRwSIjSogbW0xgLzOuvTDtAp5ZME
	P7bW9p1Nxvr3fYbn88y/4lX4AVeEQsB0rDwg/x0y9iTFLyghvXXfqJx4Zos5/f4B7C562v
	3mm+IJ1ebJlC53UTIBWL7Pzj13HkDoo=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ANxVLj8L;
	spf=pass (imf21.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.161.43 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-6dd7070699eso288453eaf.3
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 21:49:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794203357; cv=none;
        d=google.com; s=arc-20260327;
        b=Z+qVkhBQ233BDcAYRpOZKvIHIBh12y3wJRHlqFU8h7n9gugQrxA29L2LCVYci0/bVh
         9KTfyWmd5zvBWyHDd+SPW3c88xjeCdC/QKe6qbq7/1/E3n8wdJ7tDc5sRSyhrolYFiZw
         JkluiWCJOGz/Nly5n61yqvEXNXYIb9U/NMDJx+XHdtYsZqzshFhMCXadvJyx/yZnq9lj
         aH5uMnIR7W7ARzFxrijdA/DEf3RuVlaTTnWgMXXFk46LIRMDjzdEIiu0b7Uag4kh/LFO
         QaW/WEkf7uBMfFpdYpyWSY8TbXp8+gaACwf2AYy2lukt3H24vVEWWUKTxAkA1ojxHqPC
         f33w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KffYBetHs8Ajm29Uu5eM47VHa8AaiRvO1sJNqwagpnE=;
        fh=RJlInBREwB5S687rbWuRPN/ex8TPyjyD/q1YMdncuTs=;
        b=hQSG8pGR6uvlfM1x1ieegYvYi0RmYLiyyrOFKBWeIuISS1LDUxs83cAbhTmCxhfpjR
         mULbqxY/zhmCq4NIGWED8MAxRoJmML/8fXdCtUwEwvZCXESsz/+/uGkRfcD09EwIfTUY
         FOQW7XflLSjUTFtQ1X7DI0/5u8Bb5IzaDZ/XvFyGOuoaggt1412B9IDumPhNsAOEX+n7
         55JTWyNd1p7ZvvyNlpWkdAwSHj6ylaF8M0uGmlaOss1YfrsqYsgEL8RxjXxGxfSjAKPQ
         yt7BFoPA8oUhxY0G5t5RKQDZY9pFSzjNj5VfvGO3LyfUPJ6P2jUd6F9buGRcSHzJthCA
         wjKg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794203357; x=1794808157; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KffYBetHs8Ajm29Uu5eM47VHa8AaiRvO1sJNqwagpnE=;
        b=ANxVLj8Lc7OPeY682HN/z0dXPC722jWFTXO9UWw5a4RNQ0YKtTfwqWvJ7pk7B+mbH9
         BrlcuzugtFdM3gruaJ1UploZcWuiryWsIqttRcbO82yzlZL6kDU/RvKrRcMGc+snGwk4
         atkBAixtAtXmh/jd1u0LCaJ3k1LTKScgvtnPuGZ1fAN2jBj5a7Q1jT44lXZ35u67WvEA
         uHWYVacq5oRZ3XWP2CwMjs/VSkwsAh5EJEo9JqxCPtDM49eJya0h9QSAb1fTlDte3O4O
         4Nc029rZftw9pfp/DmDeXHUPa/Kk51LvBIQbzXuxdFkPJkDEZVYYdnveV+g7RavtMVn9
         JxhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794203357; x=1794808157;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KffYBetHs8Ajm29Uu5eM47VHa8AaiRvO1sJNqwagpnE=;
        b=OYYtl165s+8RkXN1hrslozfK/s4zfuBX0tswQNIPIK4TMNpqm1Hyp+K79aIfh3Hlh4
         u8tEGVxy9qbclP0utVuS5M8iv2YmWvjfGYOYkY447Z6kXRUDEzfZRUxjm7YknxrR92Ow
         3AzL/mMh9TyniMYSuAlq7KDP3VknbQqDu58t/770U86748dZnYdTKYzABCdJfC/M5/RL
         1XbpTggDCp/0zWddw99kXqC6ULxgsUBR1jzPV/ag+OKPmfwvkqqS6VOLNM6w/L47OtAG
         Y0xmG4yQ2rzwHzpnBZJbNQMmL3hPARkduGtKPlI2i5XRl5f8VtZXrv+rQbbRjefJV/Uu
         5vKw==
X-Forwarded-Encrypted: i=1; AL+hErEretaJ3niaW+gi7ft1bSZpryEpPRH5SLcVQlCOl9exNCp7kxNNs8Xslmz1Iof64pVH/EbeFXtYkg==@kvack.org
X-Gm-Message-State: APuU4Z8jDBTN5zj+Lwp5yg7+faybmod/9zf17RgvZk9q15G3UeQHxvLB
	FpRt2P6hxGvT2d4AnNBz8EMW8DMw5K2kP/xSY9FllaCyl8wdyXRLZFcOoty/ki4OFeOrMGmzvJv
	Dl79I05f6B7J/lhUPV9UXoAEEIdgj6F9T568/1Zr8ZA==
X-Gm-Gg: AYBFou2Jqi+ldZoW1MsCwzJIqirbuhpdf19PDvkA/Y6SfgzCI84KdkrJFgAzzc7wV8f
	TjAufvi/ctlcrAGcqYqbVh9FN1tSb10vh0f3wgnZIPUUEMWGoOGSeak8kkBB2ZTeR8VNA14xrwu
	apcIdUMhRhDa1o0lmkGl0QLf85vpqrlhGoHZfdC2VKxHUC1Gq6T6sCSK2+DcLkyKaHPiRJfLLuI
	H/S5TAPWjZFcc6sPUY/bglsZBoLI3idTzSH7Mx+HGQtXASx25elhMdL3+pAbJWUNtncMUgZetbg
	TAis+zmV8/XQ6wMdx5PHDKkUg9Zm8BPCIfo4V4YHyDF/sE0PespS+3xIQEMUtz92ffXB8XlfKCr
	FrtOzmqEBy1r9HUj2fhAk5nIAXv/NMAW4oOZikdR19HM=
X-Received: by 2002:a05:6820:160b:b0:6d8:bba5:6589 with SMTP id
 006d021491bc7-7170f303df1mr1702563eaf.48.1794203356632; Sun, 08 Nov 2026
 21:49:16 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261108110406.97495-1-cuiyunhui@bytedance.com>
 <20261108110406.97495-2-cuiyunhui@bytedance.com> <20261108213254.67805ef0@pumpkin>
 <CAEEQ3w=5QwwvMJFJkpS51APoBjhed6oriCkvcieRdUFWrKtmSg@mail.gmail.com> <avFN7LbSK0q1gsB6@xhacker>
In-Reply-To: <avFN7LbSK0q1gsB6@xhacker>
From: yunhui cui <cuiyunhui@bytedance.com>
Date: Mon, 9 Nov 2026 13:49:05 +0800
X-Gm-Features: AclHuK-yA93Gg5bVt8kCNssew6sQnM_Z05Rmq56zAts1z3WwIhtyQX6D4YptSkY
Message-ID: <CAEEQ3wmViZNwxXr8q477yHjtABStEJecCHS8=5s_UAk1hYgyfw@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v9 1/3] riscv: implement this_cpu operations
To: Jisheng Zhang <jszhang@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>, pjw@kernel.org, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, alex@ghiti.fr, dennis@kernel.org, tj@kernel.org, 
	cl@gentwo.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	martin.lau@linux.dev, eddyz87@gmail.com, memxor@gmail.com, song@kernel.org, 
	yonghong.song@linux.dev, jolsa@kernel.org, bjorn@kernel.org, 
	pulehui@huawei.com, puranjay@kernel.org, thuth@redhat.com, 
	ajones@ventanamicro.com, ben.dooks@codethink.co.uk, rkrcmar@ventanamicro.com, 
	samuel.holland@sifive.com, zong.li@sifive.com, conor.dooley@microchip.com, 
	tglx@kernel.org, debug@rivosinc.com, seanwascoding@gmail.com, 
	andybnac@gmail.com, menglong8.dong@gmail.com, cyrilbur@tenstorrent.com, 
	wangruikang@iscas.ac.cn, atishp@rivosinc.com, apatel@ventanamicro.com, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, bpf@vger.kernel.org, arnd@arndb.de, nathan@kernel.org, 
	nick.desaulniers+lkml@gmail.com, morbo@google.com, justinstitt@google.com, 
	qingfang.deng@siflower.com.cn, linux-arch@vger.kernel.org, 
	llvm@lists.linux.dev, dave@stgolabs.net, emil@etsalapatis.com, 
	ihor.solodrai@linux.dev, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Stat-Signature: m8tjpg9ax57nab7mdro9wwhrem9y983w
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2C2771C0005
X-Rspam-User: 
X-HE-Tag: 1794203358-907420
X-HE-Meta: U2FsdGVkX1+CoJF8ruvuS5b2umwVs97bTrE9tJ1E3ls42VmRW8fcnmSbw1sLbom3c9AWiENdxBcPL+y9YLt4LOJpm7J85JVbYEd22Rx3drVvQd6/DaxwxZzRs6/CUtjFs1rTs1OCofh+xrCO5jllK34nQGtjrx0UlvV61dO7zQTA0EPLWLi0xpg2gwxiDj/eWlh9we86TgrIwyj9BXmN2NRJUnLVCyk+fC7/Gau0ftItU/s7nQK4KT9qc4L8ULE5T3eo8IUBY0hcZ5ldCVpdV5Akc6GbbHUfYU1TtAxTyqhPGkPSiDfuuPYpZIMCF3exGCSP3eXt6tG5bRb2KPA/zVCgBgyCnR7twsfD6yk07k5vxF3proi3K5VgwLv5d8I3ARC8jf7/VcA8wtIuZO4wRYVBVSvaXU+XsjxbZ0ZIoZGdEtquOJNjAO9/AKplDo4U/a0t4uEzApE+yRLYrM7ZtUVESbjEwnit4hW5bVCQ316qlX224XB1lbEc/v75EEwFXTRUxV/7n5jOygBZ35d995qBuH2LUyvsa1FJhuW1Xik9iohBGjUnA9ZF8XNZZyEKTGIjpA+qJodAQCDi+oy2UVOlT2xRV2qG2zvcSFb/TK49Pol/eI791pJDjmu20d/JJlSZi14uLV9iYsTY6Bq7G8QsXOBwQJ8016z5rQ6GaYFwhKFIq6G1aZf60sV0eJIltiiPU9rFVMbWnQhVVN/PhEj2UybtKaeIPujO5oTCGorUHikt61FbSQlcNKt+6dY/BcljAJ+fh92sf3CEP4q58/ORMtTBM9PvqYF+IuT+Uy4YTJC48sr1vX8qURVYdwSTZJhPEqLLjaYGmGDEJCwkn4aYXo01PxQIVa96vwrRY3vKlFYXcLM5bdEaMIRb4pS1F/bj7cw48gqePmlP9XblwrRmGPGlkbtGr3WDdqDU66ONYB4JDSbX2TpqUBpZFSUZ3NLgVAfQlRMhU12xOW4
 CEQV7ISY
 cPc54uEve+ZsdSwMNuPtq84+STayGolzUikgNhqFQeJp1w5ePFmebgdiH7NDNgGcDbHbtNbs5CcuQWKrluVYiYA5XKSw9KbNRV0FKBWNoMuxaqxCeF/ClEH6dLOB470oaYGt7ZTnU+hRFUw1oXEPEuvxonJz9CYKau5qRxLC3zlQJ5p3pKFm8p7R8c/ICirrsEfOfY0gHR79CX1jKZ4ZY/N6GNMDMwSxRnu0eTue0fuygyv6mwdOQIgwtEyxGq4s5Mi+vRJkIF03yo7FAb/4fArtTrmOaltJuiLLutty2CeeIze2YmV4GwUMJoXxItD+QW5qMtBBvX+9Z1JXbvV+ko5gM77ImWrpoLNjbhY5QwF1DU/oIFJXLZlyq7lziE/Swy1yGGdN2wKsA+0yL5QDwb1wBTdons6pytRgFzTRc61QWWPw6FnyNPvYuzlUOOmOUNV9L0kQYp2B3iWzLn8BWlWDk6K3gSn2DNAJIPPYYeKty7fraNjZDay4DFexbhSHqUY9YbvdQWn4gC9JEZlkTcAstcSUmeth7Dw4f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Jisheng,

On Mon, Nov 9, 2026 at 12:57=E2=80=AFPM Jisheng Zhang <jszhang@kernel.org> =
wrote:
>
> On Mon, Nov 09, 2026 at 11:47:43AM +0800, yunhui cui wrote:
> > Hi David,
> >
> > On Mon, Nov 9, 2026 at 5:33=E2=80=AFAM David Laight
> > <david.laight.linux@gmail.com> wrote:
> > >
> > > On Sun,  8 Nov 2026 19:04:04 +0800
> > > Yunhui Cui <cuiyunhui@bytedance.com> wrote:
> > >
> > > > RISC-V has no asm/percpu.h, so this_cpu_*() read-modify-write
> > > > operations use generic implementations that disable local interrupt=
s.
> > > >
> > > > Implement RISC-V-specific this_cpu operations with preemption disab=
led
> > > > to keep accesses on the current CPU.
> > >
> > > Have you looked at some of the schemes (I think arm64 has the latest,
> > > but also s390) that do most per-cpu ops without disabling preemption.
> > > In particular they save the pre-emption check when pre-emption
> > > is enabled.
> > >
> > > Basically the code tells the scheduler which register contains the
> > > per-cpu data so that it can be 'magically' flipped during a context
> > > switch.
> >
> > Many thanks for pointing this out and suggesting this optimization. Thi=
s
> > is a very useful suggestion. In the common case no preemption or migrat=
ion
> > occurs, so the preemption bookkeeping and reschedule check are unnecess=
ary
> > overhead.
> >
> > Implementing this scheme for RISC-V will require additional changes bey=
ond
> > the current series. If this series is otherwise acceptable, I would lik=
e
> > to land the current this_cpu_* support first and then prepare a follow-=
up
> > series using this approach.
>
> Hi Yunhui and David,
>
> During the merge window but before rc1, I implemented a riscv POC
> following arm64's preemptible this cpu scheme. Each operation records
> its per-cpu pointer, offset and address registers. Exception entry saves
> and clears this state, and a noinstr c helper repairs the saved offset
> and address registers on exception return after any migration.
>
> However, my PoC is based on current percpu offset.
>
> I planed to sent it out last Sunday, but then I found Yunhui sent
> his percpu series(which is up to v9, I didn't know this before) on Sat.
> So I hold on the sending.
>
> Now would it make sense to rebase the PoC on Yunhui's series patch2 and
> patch3, especially the percpu offset optimization? I can post an RFC
> with this rebased implementation.
>

Given the substantial effort already invested in bringing this series
to v9, my original plan was to land the current implementation first
and add the preemptible scheme as a follow-up.

However, if the consensus is to move directly to the preemptible scheme,
I will implement this scheme in the next revision, building on the
cached percpu offset introduced in patch 2.

Thanks,
Yunhui

> Thanks
> >
> >
> > _______________________________________________
> > linux-riscv mailing list
> > linux-riscv@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-riscv

