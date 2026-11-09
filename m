Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AD8A606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 03:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=i49uv7Zm
Received: by kanga.kvack.org (Postfix)
	id 868BE6B05B3; Sun,  8 Nov 2026 22:48:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83FEF6B05B4; Sun,  8 Nov 2026 22:48:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 755CB6B05B5; Sun,  8 Nov 2026 22:48:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4A9CE6B05B3
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 22:48:00 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D1A0AC058A
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 03:47:59 +0000 (UTC)
X-FDA: 85414197078.28.EFD56C3
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2A2CEC0005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 03:47:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=i49uv7Zm;
	spf=pass (imf10.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794196077;
	b=Ho+SDNsbgvF6RcsuhTkzKwDS+u38qAUzs6Iw5yaQC3cKqMKCNvOgKcJJG4FeicOh6N9jgP
	faAZHeNSBcxMudW3Nuw6YfRnBSmixl+AkuAJEf1v3tDKJOxBPvr1wkJrbiSajLbjajh0/T
	zpaZqh+WeKvw4TeIoI+WSQJuBvepRzc=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=i49uv7Zm;
	spf=pass (imf10.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794196077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=02Xm4AXZtFCOeYUfXGvoHJuZWiU3qVVXajNv+02pe2I=;
	b=h/dWSodlraJW1j6TlApCpGtq5wLfxEMs47HwFYghwXl+n6KNqmkUVl9OCcIP1Z1W6zyWQm
	SHtOW4VxitU4k+O017yJNtde7ROI/9dXm6wzmNssA0VJ/cEzbwCi1JTfW6IcOQ4meSLML7
	h0Q6/6hiZX+rXNR2jEsTtSQhwD0CCs4=
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-85f34b20042so241321a34.0
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 19:47:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794196076; cv=none;
        d=google.com; s=arc-20260327;
        b=foCxPcGWARLfyELwP00qeTpzyMOe3SuB/7yplwySMK+LBjIl68Zmspzr9Lq+7r5noi
         wSD/AfPPERo3fHZUxMokI+sSOtFBfR3DkAXalrtO2MQo/FvFARlZxzVQ3nJFyU61Mnpr
         LBIIhHkTiMQifMXo+ek2vhUsF9dgzUjTB1QnsqVM2WTSD0+pwqKm/Yj4xRGwgxgDuQ2o
         gj2pzaMiaVsY2jBv+EAE4boAaEJ2+RntUtiTgjFCoc4HQk4CBxaREFGFskDZaO0HTpnG
         Tb+BlVb+AVQ34Uzk09UcWEL6FvxcHzk506SnfxygtjyWKv9tGhL0gEJvhCULoSGR38uF
         P1ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=02Xm4AXZtFCOeYUfXGvoHJuZWiU3qVVXajNv+02pe2I=;
        fh=jMPYvIDLTe/uPql5OZm/ankGxgFf+Kby4TKx9MYAPXk=;
        b=IEJPtOB4EjruCGBmayTWUI8m88KGaKMaCR47XVymY07RV/9LKF97u6Y++rsG76flbm
         D8J9zyMvlChPSqjFbW4WvUOlgf85se29vNbuWAbR9bMcjWAusgtr1SFXGDjHLEQYkN+M
         zRuudMI/hy5ykqajHK1I6d4ytSqyUeTPEtFXDQghIGa4iiZ7c1aEWHG7gZw9y01le2vm
         Nt/q+gi1rQ5BJcQdaHXnn/sgZhXGVf8CYvCatji9OJWkXCSfHcQofAIIvOEbKEtZbD+U
         pNq6yDLsqe3vdSD6ehLoSoQcXNlsc84e5PMH4j0/SZigwU7MUp6dgbdcA+p6iHjoKGd2
         UFlg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794196076; x=1794800876; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=02Xm4AXZtFCOeYUfXGvoHJuZWiU3qVVXajNv+02pe2I=;
        b=i49uv7Zm5rKJWWAXVXDGmpzkd7wzM/f7P9Ip6c2kKUY+mjr0s6vXZ+gVjwj/eqSrTq
         p/7DZK3AH0RI7T/IKAAXiQEw9HFuSmEWp7nOl0OMfbvBZmzGgHP469mciLa710HUYEtP
         26WK51dd52At4VUw1iQK/YaIGGTykXMMSlXAL3osNPqOfGPR9DNYcC1XgN/oxg7EwrzB
         pSHkJLE/v3DpvdAXIClUXjS75kCdQjpZ5sVr/AhU7Y6mpBlbq1iC8ocSau89T20+6zMa
         XBgJJPmud8BJjcuX9R9RQwWR4l+7redSRykNzEPO/qiEKf8OCgbLv6vNNk6fLnDP19iM
         PhWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794196076; x=1794800876;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=02Xm4AXZtFCOeYUfXGvoHJuZWiU3qVVXajNv+02pe2I=;
        b=N1h7+2SFYxvwO9KvJGTyyda4Zewap2eo0jNvBD++XYqkop7LVs/9GmKoHAeEF2j7uD
         HkiSg3ZPqI2N09JdpnQwqBPlgQH01rDLHndTDNglouhKJlW6o/Dtq7mDZg1iku4LYGiY
         ObeEQ9d+gYXYSE9VKYxXxkwqVwFdFz6gXnPEFwVIFACDo14G2BNrYEF1cCLPc8wg+6vk
         SrWaMUluOfYs3Eqfe0MCWlIUiMYQGHIjq7cgQy9JfGXIYa13jAWy+ovsI6TYosv2aoZG
         LsjmkiXVG7kRPkx/1GPiAqGRnpHbnH49ZpxMSoSr8zBNRSZixpi2dhGE5pc+ed17pcHN
         fXFw==
X-Forwarded-Encrypted: i=1; AL+hErFs6Q49MlFr2zWIpY7ZJUJvOoyWWZG/KoEWFQrZ70zUJnWqnMBUlJ4y5DEwEQ5ZATOPB8FdbRponA==@kvack.org
X-Gm-Message-State: APuU4Z/hNSy1LHscpoZcslHu6ETVb/VCd4vdC8p7yIcLM73A6AxhrOCU
	U7qN0dChNMht69gg4U4H0hNkRNwjEH/ZFA566sf+4Ou51OSAajsp9XpzzL6DA334KL0DJtXZ5th
	3i+jNOjW4uSKBzSJ2cfCnVafZpASLYxPBM88xTLS8ZA==
X-Gm-Gg: AYBFou1Zwr+Gz9xyvf4p3cp/r1AhXuTOlAOmRT4fOTPBUg3ixks5PzEOdL27iRA/Qov
	kCAnNpZbduH6Qwf8XC6dtBg3nYYEVdipGAYdePXkzbaujtTq/PbYn15iBXVanpjs7/g2W8SS51+
	oER/f6FGTnr6Z15TkTdSgZM6E1Bh499FvNCBLXRJEeZzs8r7zE/6UneJYg+et4yjBm8KMSD+qeh
	Q/AG5dko7md9bI8J8v7y/vKK5w+JhRUqU+SOuCWFZD/JtBbGvKFF21vpBvPUKuG+3j0cLbowgMv
	F9k4n5B9s9bg1uU0sYEizrzeby2URwTjQ9D5YWQhBrGSds2FV3mJ6vuFaogeub9gJNMM62eZzB3
	ZHc2okYoNMYg0JMZ8cC9TZhKBxyauLGdxWYd0iKnm7pc=
X-Received: by 2002:a05:6830:3115:b0:81e:abb6:7498 with SMTP id
 46e09a7af769-85f5082de7dmr2762199a34.23.1794196075840; Sun, 08 Nov 2026
 19:47:55 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261108110406.97495-1-cuiyunhui@bytedance.com>
 <20261108110406.97495-2-cuiyunhui@bytedance.com> <20261108213254.67805ef0@pumpkin>
In-Reply-To: <20261108213254.67805ef0@pumpkin>
From: yunhui cui <cuiyunhui@bytedance.com>
Date: Mon, 9 Nov 2026 11:47:43 +0800
X-Gm-Features: AclHuK9B61ylAVcWnUjeFJuyJwDuHE_2RuMPKX9QRnbJ_mu0Y53s1C9cYNJl2lY
Message-ID: <CAEEQ3w=5QwwvMJFJkpS51APoBjhed6oriCkvcieRdUFWrKtmSg@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v9 1/3] riscv: implement this_cpu operations
To: David Laight <david.laight.linux@gmail.com>
Cc: pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
	dennis@kernel.org, tj@kernel.org, cl@gentwo.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev, 
	eddyz87@gmail.com, memxor@gmail.com, song@kernel.org, yonghong.song@linux.dev, 
	jolsa@kernel.org, bjorn@kernel.org, pulehui@huawei.com, puranjay@kernel.org, 
	thuth@redhat.com, ajones@ventanamicro.com, ben.dooks@codethink.co.uk, 
	rkrcmar@ventanamicro.com, samuel.holland@sifive.com, zong.li@sifive.com, 
	conor.dooley@microchip.com, tglx@kernel.org, debug@rivosinc.com, 
	seanwascoding@gmail.com, andybnac@gmail.com, menglong8.dong@gmail.com, 
	cyrilbur@tenstorrent.com, wangruikang@iscas.ac.cn, atishp@rivosinc.com, 
	apatel@ventanamicro.com, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, 
	arnd@arndb.de, nathan@kernel.org, nick.desaulniers+lkml@gmail.com, 
	morbo@google.com, justinstitt@google.com, qingfang.deng@siflower.com.cn, 
	linux-arch@vger.kernel.org, llvm@lists.linux.dev, dave@stgolabs.net, 
	emil@etsalapatis.com, ihor.solodrai@linux.dev, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: rehc1gmscwjncdoxk4tn39zzaxw75477
X-Rspamd-Queue-Id: 2A2CEC0005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794196077-508900
X-HE-Meta: U2FsdGVkX1950AxU1+s3badlU+WgJoKPbzi+dry9RwN0eZZkQL34CWjAjRcrS6txzla7DpQCf7IdiI6UMhzVA1WmqjRkrQ2P/rAqYZH/0i/g40tAEKcvZ8ZpO12QU9NQJT5S3I0tR+QZe3IywUIlreYdoBqO20MamFXv796ngnLd/jgqzh8SK9iG3B9zg1DC9RRUUWjWVXC8HSkPCLOc72kaT9EVri5+X4WEdBxQiJXZ0XtQ5rjGDrLl3RHyTegmVr4WbfLWMF3zVVNF90lrjK6Cn7suq+p+n72uiX3kNsw3ZyxuuHf3g8XecuExbF85fMN/e2jrZKmCHiNaUEWG00LKzg9btjnPL13DLOYM9IDR2sqkrnjxTdBrONYuhFg25M+/UGPgkfXvWZ87cmG94omLZs+px4pATqfv3q+bNDHWWarRH8QeB/F8ylAmixNisguwOWWdhp+DIT5m4D2WiY0TOeTIfvmJKV1J+przJ9qv+fL6D/Om6MH7JcWujx/Pqm/2z3VpSBO52eq78sT34r8WZnUWJU/xJT+xZzBOevTsQsrldp7lsl3qB7PVp2a7Xzs3zVVRrMIWefGBT+lEh1LVjjPOa21bsilgbvvDetJ33VcvbzmTpIfApPLSrHNhmQevF2D/926vOsNPd7u5U0beXNE+lR4HbP0n5u27iDEtX9+6JszvM8sD3cTwVW38HKxixk8d7t5xbSRfhyGvegB/G/dvfUJvA14PnUzkkx40HCvqZ5gVSbBCWV44mADlGV6+X3Y6stMnowvm993xhkuQT+XYmqAcodC0V+ctThHQpix/MpDqG/VAK6kZIix4ByQIrbW1zuGSZdSCqegu6ob256MAgnIVpkkBiO25GtlqWi3v8V5nmnECPXloJ5FSLmYMQAPYy0ukoUp0kebZPSt9phAbTH+NniXybu2sK+pD6FX0HWZtIDEvlbdpdp7b53E1TRkt90F8puk+bYY
 yLTjOzzc
 oF7QJV+0VnmpIX51Gy3orE81tYveikVAzwChJN3gUCDCf3x8vVcND51AnjUy1mpas2isqiLePvCCzMam1mhIF+jilf9NhUwfBugXjIYWLehTxUz2xUMTPb7hDeGHK70S+4xFE2XZyArtlJ+BGAKWTLaxbqFSIlqiimPhZtJW/c5S52JlL2T6N0Tnb+ECpyKXfeHENjhugvCCCAfZSh6moCWOYb8MDqEBfwg2UgH1v1pctSpz3qFBmrqj9Aof1VqXDuAMiQLa8xR/I1xSPpF419LEAiT4uo4ZQ4nYj8Ir9JzFCmG9NPB96v54Hfpr5KiXW6s4UbXOVXdqefG4wD25usvtAb0YfOBSYyTxEF55iH9TxFNWhSCbI7ZaOpjKCvab+1T9AhHq7kTy1bCQvzN2WlayYysY1adbT8tLHbswzcK7I+UgggUFBRIrHneckTn69hgGsYK3hCmv4aL8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,

On Mon, Nov 9, 2026 at 5:33=E2=80=AFAM David Laight
<david.laight.linux@gmail.com> wrote:
>
> On Sun,  8 Nov 2026 19:04:04 +0800
> Yunhui Cui <cuiyunhui@bytedance.com> wrote:
>
> > RISC-V has no asm/percpu.h, so this_cpu_*() read-modify-write
> > operations use generic implementations that disable local interrupts.
> >
> > Implement RISC-V-specific this_cpu operations with preemption disabled
> > to keep accesses on the current CPU.
>
> Have you looked at some of the schemes (I think arm64 has the latest,
> but also s390) that do most per-cpu ops without disabling preemption.
> In particular they save the pre-emption check when pre-emption
> is enabled.
>
> Basically the code tells the scheduler which register contains the
> per-cpu data so that it can be 'magically' flipped during a context
> switch.

Many thanks for pointing this out and suggesting this optimization. This
is a very useful suggestion. In the common case no preemption or migration
occurs, so the preemption bookkeeping and reschedule check are unnecessary
overhead.

Implementing this scheme for RISC-V will require additional changes beyond
the current series. If this series is otherwise acceptable, I would like
to land the current this_cpu_* support first and then prepare a follow-up
series using this approach.

Thanks,
Yunhui

>
> David

