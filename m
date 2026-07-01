Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8077DC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 11:34:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48D6E6B00A6; Wed,  1 Jul 2026 07:34:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43EC26B00A8; Wed,  1 Jul 2026 07:34:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E10F6B00A9; Wed,  1 Jul 2026 07:34:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E9B786B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:34:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7A6CB1C6F93
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:34:28 +0000 (UTC)
X-FDA: 84939999816.06.E14DEBC
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id 83DF0A0004
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:34:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=kbaiPlpU;
	spf=pass (imf25.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782905666;
	b=LQffNyjEiQHALbTbV8CJW6omOdfaKc+GrEKBLZeRq7wpk2CXYlCCT7ZK6ZEUF9jsM8GV/k
	QFoxBKs0HrPeQGwgAiftmKR/27L2soy5iy3qJt1DptvJ8+sBF2mVmxqYsg3tijUQiwRfbq
	7z6W+HT2E1zfTDYXkBzcAh7ULveH7fQ=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782905666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4faTMgKNiTFwecAROGzTjTqdDKLQ5/Ado1VdunwSeFg=;
	b=c9BLjzsJXCUe4dl4dChzIKA0179SEvvu/7e1xDmWUfIZ9rtV/wZ01gznMYtufTGdVZj4rs
	hnKAan3uyoLBmVGvAHxNtzWX4QcGE4uBGeZOO3Qpty5eb4CgbV5mrIGGYERDWr+ggfIm+t
	InG7usJMiiIRWe32+xadi2faZ+m7UvY=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=kbaiPlpU;
	spf=pass (imf25.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7e9ecb1e13bso220782a34.2
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 04:34:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782905664; cv=none;
        d=google.com; s=arc-20260327;
        b=ZMBOOOhwpQro6ZuSnkkTUJACnpstYZs3iFRnCvhQj8pWM+Pti+eZjlb9p0tmYDup1X
         JptTlPW+6aN0ZNwXYPhEAXBwH6oYS0szIFJoZhoVMEgsBCj9Q5i2/8wdsCPI+w+yYnRd
         WDcH/XZngnmVMvMczX2n/ySOneIX6WFaX6VUFz4Y/Gd1DmYNYU3m1sLFlMP7O5FWmPqF
         ucV6FaFWPsiNKUFqgioAIC4jPTltvoKp8FA5VuK36I1648Rb/S7u7yGlA3NHROVctg2i
         fXTKORBnAIESHrWajYScscdyIkJ+pIwHqotAyy2sY7EgOs7t2eV7ufgi/5chPYSMk2l2
         NkgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4faTMgKNiTFwecAROGzTjTqdDKLQ5/Ado1VdunwSeFg=;
        fh=0KJ2s2A6CMLjBZCoHIdso1A0J17PD/rC6YRxMmAJ5JA=;
        b=BAIOVpZ15ErhCLvdoPq9OaKQyttvlUbOhI8Uu34iGnLBnW8EX6wcKN4n/NyIZ8xpVJ
         sEaccEVGrBjLO5wqYZXRTidPU4tuTL2b9LtrChZLx9/QyOHrKhd7/M2sBxhDiWVl2+zO
         n3iJxkvBmV1ktVIJEhOTQr2MUxxdKII5OR98VuGmtXMFlaMvco5BsVSPEDy2BCYCeqjw
         78HKTZnTTJWevJcuZtYone8GXtPEvLt3S1E185nG2bqwm/RXZvDc0CuJFvxvXUy6zMoK
         AArI0/G1wg8kZozoTuBCekxBpYeiZXEv7tfkuDaw5LKQ+9xDAsznMP08SG2JNtLXulbK
         oRiQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1782905664; x=1783510464; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4faTMgKNiTFwecAROGzTjTqdDKLQ5/Ado1VdunwSeFg=;
        b=kbaiPlpUhmDxqyr9LYKjiP9YWzSDypeKYeYt/6tZE+0r7BNyw0neMOd7uXQQFTtJgW
         UQ6UPil0pPe6lyw4keB9HBU+S+9pSb3b7U5XQWGYis+XkMbGHQCx0QNqsH5f1iO7gI8c
         1fMUkbwa3vGrOn/RP6/380q5h2xu/tm8cOY5A/KbrrFXUHt17WNNPNtefCOq5Y2bwBv8
         3HboLhcaRL1/KXk3k7kkvUFlqfTDuAMA7wpz/BulSyRkUPE4CachtgYlGCRzsVLmEnAM
         fzxtQ/OoXwn6TPiVr2ixYTS4bAOhRJA2KkzhIybca7JZz7I3aZHh32KrXJRu3zMJ0dK1
         V3mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782905664; x=1783510464;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4faTMgKNiTFwecAROGzTjTqdDKLQ5/Ado1VdunwSeFg=;
        b=g4qhdvc2G85Ub3CI9Nr7GOhh47iSB3CMd1FaTs3MJGJr40FOFtuOJ1fIsRZO+tE6xy
         Y0mT2Wv3KDZ1ZtWcvC45A3IG5lYwSXLKVdHlH5p4njeZdyhdFgkTqA+dkaItX7xP7ArJ
         0xPO4LEXrXGEvGYgkNhcLkz1P5bTor2WB7ZXK4kb87Pwub0EUFZHLq/MiNNSZ0pLT7BT
         iONvtOdOz/dSJmsQnQ2beaaQ0jm/+dOWwUQOx0vXIokOqXSGuXMH2CkVpjRSr5z/PIuF
         7IFB9G4UwXgDY2h9LPtypG2PusGreeEM3E3FSpm1GiQvv8enMqRWoW60HLyE92gcqtSE
         AHcA==
X-Forwarded-Encrypted: i=1; AFNElJ8g+OrhPxKq6hwhMxrnbPeUy4nXdPkUhMpTbXRxwqm/4OlqyS50rNtwghSoUR/GKcImzWmrnImAGw==@kvack.org
X-Gm-Message-State: AOJu0Yz5uQFn/dxuF6RRKUMiRdk/LgjIYCH3EeehUj5FgeznFujLXb4P
	bFRC/V3ONbMFhV6yAN0TPbJIYihG/6UL9iHM3aquf8hBofXnGX63m1d2G5l64XQonPpjIIMBB1h
	PyH7ACOzLAcZSqhPlI2EudLSflotKD1AUPCAioKXqfg==
X-Gm-Gg: AfdE7cm/kSakGDZbLAAoVsNeQWAdjVOAk5DM/oroaebOku0COcAUU5X02/lkD+1tgEG
	1E2ZToMnMZfwmbwAxhcfhC4KPOdAMNTZxhAUIcvHVwGBJEoyE+ZLGSzE6Va/iRSIsvr9Dzj3lc+
	jbvIVMcSbZbPdhFPh0slgxwpZNf+P8gheXov0OddIL/Rk4AdDvDo22m5qJi8exr2a8Op2LCwsCR
	9v5grMudxgr2oERb5BF9wZoiOxzZT0mv24w3sG6r+GKwhxYJu6JYqSZPCR+9mwRnalZEjIAFC4=
X-Received: by 2002:a05:6830:268c:b0:7e9:eaf2:ee22 with SMTP id
 46e09a7af769-7eb4cc4c951mr544254a34.22.1782905664119; Wed, 01 Jul 2026
 04:34:24 -0700 (PDT)
MIME-Version: 1.0
References: <d6afed2c271de42efe2a3580ea30c7601cae9c0c.1782877663.git.cuiyunhui@bytedance.com>
 <bf03528b891e5f09ec46d075649474ce5f2228e80afe1d6fe5481789e9dca9d3@mail.kernel.org>
In-Reply-To: <bf03528b891e5f09ec46d075649474ce5f2228e80afe1d6fe5481789e9dca9d3@mail.kernel.org>
From: yunhui cui <cuiyunhui@bytedance.com>
Date: Wed, 1 Jul 2026 19:34:12 +0800
X-Gm-Features: AVVi8CdSDzogNfvB7WcojkNKIVGKoMGTBqHUYhLn3ECuyFSx3CWlfNAiYqksifk
Message-ID: <CAEEQ3w=d_t2WDAa7Zmemm9fk-guMmwdX11wUFG2odFaCwz6y8w@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v5 2/3] riscv: introduce percpu.h into include/asm
To: bot+bpf-ci@kernel.org
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
	llvm@lists.linux.dev, martin.lau@kernel.org, clm@meta.com, 
	ihor.solodrai@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 83DF0A0004
X-Rspam-User: 
X-Stat-Signature: r9qwot4b8966rz6ebmmd1praby6fj9j7
X-HE-Tag: 1782905665-214211
X-HE-Meta: U2FsdGVkX1/fakk63n2PYbiOhP1z5z4CKV1VbxQnPekG+eOOkk+ETyYTK5e2zu+YNo1sxhDv57iNUC0yQNVoCgUVPXp2vRF8NpywZHUv26hNFgVDeOKGHcnRlKx3YiuOBrlYJF5fQJIdtjRbHVfyK+UxMEfQhSq6bjy+YF8dOgHdA1O2m4a7Vfi5fc9wjzpawMBthLmKbbuutZDONxOEqySi5dBB3Jx8mj+NdTAsqpYLPTB6ma6P748v619cTPnE39JzdigETcF8dSB9/JR/90fPmNrZ+toFU8Hmap6yriWwYyY/GgWuy1RhW327LLkHI/QXDXpayx6SkjZWEcampPTSa7KJp3CbBzWb433QJDG0svES8s29kwmmWSEPEr3SNqhMrLc5kZVluKtl6c3LK61jeAhHHeDWK4xB07hWUyX3KYzLrXh7SwFkZoxepDby7jF7aitKNcgGadcOZ/I4v3DItM1SanNNKKztzGB3NQcdnW2oAUG1UHyOAt4w6oj2OHpaqkke5tGUBXkNcDQE8nBGKYUQ+xYZKvmrAkx3XI6xYioM2sc/0r3fVHYdmNUBFd/k8yo/Pysk9GmVextnDaXTutoVLZeV1LmEFxsfvqmDxwc28MTgv91LzLtfLXDuz6VieoS1Z8GSGkVZnLEotQX8qB6xCIGg22hdPjUKvwZ0lfT27QXYLS/82ReFbWCXRSssVlHogAn3vRHlwOgd5UeHJknuN5wBFwiP6LyiuOpN7LzOA3f/kuiXbNA485AH7bzK5zbePWtOogP1Loy+8BW+qf8+0josriXRZHFQr55K6fRsAbHMvO/wzzsf1nuYqedZOmcLoUHg0qmb6AnvRPdBvXtz5lMU8fz1HN3PcX4l6VY0K8/hzV2W58lXuX2gFiEqHCm46n5zysPTdWVO2v5fxr391iTUMDAT2mJjyWQl1qYi5XFJmKYh3qJaXFJMmk5aLuFljmslBbOVAuQ
 z6S2D/fg
 DiZ8m/jwWoYJKdggk3S17UcvTSMt0ZltBLN8M5XPiZkDSyNz4aYaQFliH4BE1CAx02paXaLrO869mQ5Czdbfsw+4l4/cyyJE4Eas1oICIKmizubNMjYVpyh2Q8NzkNipKoFtEdkdrjQqXM1/OCHyxKDuoqFKoWM/kjwvDspjeWFJ2WUCtKcFWjyKEwGEzl+tqalLFOjrkGgjr0AE1gp1rfu1rp6wuiS6j11U3naZnK6okmbdjGZqbbHUMaKDZHeJl6Oq83GSuT9ONnc7w3zgreCHQTF4fibY++QZ9UkKi7PFwYWJonWQwZwqZxWMg2lO3Es/N5Gj5E6ox0gx3m2I4eQncvqWxgFsG9FPdWCxjb2SQL/IJk/Fxktkgfm2BRyzEDsXjkqAmdqt8gtqdRWnrRQa87fyZF9M3ig/k5EWPhell8wpcCe5C38uV6e24jni9hbkWZybfQ0bkxMs+9zQD2G75zwuF0qQCfDH5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi bot+bpf-ci,

On Wed, Jul 1, 2026 at 1:06=E2=80=AFPM <bot+bpf-ci@kernel.org> wrote:
>
> > diff --git a/arch/riscv/include/asm/percpu.h b/arch/riscv/include/asm/p=
ercpu.h
> > new file mode 100644
> > index 000000000000..46f1901d3bb8
> > --- /dev/null
> > +++ b/arch/riscv/include/asm/percpu.h
> > @@ -0,0 +1,283 @@
>
> [ ... ]
>
> > +#define PERCPU_8_16_OP(name, amo_insn, sz, sfx, val_type, new_val_expr=
, asm_op)                      \
> > +static inline void __percpu_##name##_amo_case_##sz(void *ptr, unsigned=
 long val)             \
> > +{                                                                     =
                       \
> > +     if (IS_ENABLED(CONFIG_RISCV_ISA_ZABHA) &&                        =
                       \
> > +             riscv_has_extension_unlikely(RISCV_ISA_EXT_ZABHA)) {     =
                       \
> > +             asm volatile ("amo" #amo_insn #sfx " zero, %[val], %[ptr]=
"                      \
> > +                     : [ptr] "+A"(*(val_type *)ptr)                   =
                       \
> > +                     : [val] "r"((val_type)((new_val_expr) & PERCPU_8_=
16_GET_MASK(sz)))      \
> > +                     : "memory");                                     =
                       \
> > +     } else {                                                         =
                       \
> > +             u32 *ptr32 =3D PERCPU_8_16_GET_PTR32(ptr);               =
                         \
> > +             const unsigned long shift =3D PERCPU_8_16_GET_SHIFT(ptr);=
                         \
> > +             const u32 mask =3D PERCPU_8_16_GET_MASK(sz) << shift;    =
                         \
> > +             const val_type val_trunc =3D (val_type)((new_val_expr)   =
                         \
> > +                                        & PERCPU_8_16_GET_MASK(sz));  =
                       \
> > +             u32 retx, rc;                                            =
                       \
> > +             val_type new_val_type;                                   =
                       \
> > +                                                                      =
                       \

This does not impact functional correctness. I will rename LR/SC
fallback local variables to use consistent naming, and keep the return
helper separate since it only handles add operations for now.

> > +             asm volatile (                                           =
                       \
> > +                     "0: lr.w %0, %2\n"                               =
                       \
> > +                     "and %3, %0, %4\n"                               =
                       \
> > +                     "srl %3, %3, %5\n"                               =
                       \
> > +                     #asm_op " %3, %3, %6\n"                          =
                       \
> > +                     "and %3, %3, %8\n"                               =
               \
> > +                     "sll %3, %3, %5\n"                               =
                       \
> > +                     "and %1, %0, %7\n"                               =
                       \
> > +                     "or %1, %1, %3\n"                                =
                       \
> > +                     "sc.w %1, %1, %2\n"                              =
                       \
> > +                     "bnez %1, 0b\n"                                  =
                       \
> > +                     : "=3D&r"(retx), "=3D&r"(rc), "+A"(*ptr32), "=3D&=
r"(new_val_type)             \
> > +                     : "r"(mask), "r"(shift), "r"(val_trunc), "r"(~mas=
k),                    \
> > +                       "r"(PERCPU_8_16_GET_MASK(sz))                  =
                       \
> > +                     : "memory");                                     =
                       \
> > +             }                                                        =
                       \
> > +}
>
> [ ... ]
>
> > +#define PERCPU_8_16_RET_OP(name, amo_insn, sz, sfx, val_type, new_val_=
expr)                  \
> > +static inline val_type __percpu_##name##_return_amo_case_##sz(void *pt=
r, unsigned long val)  \
> > +{                                                                     =
                       \
> > +     if (IS_ENABLED(CONFIG_RISCV_ISA_ZABHA) &&                        =
                       \
> > +             riscv_has_extension_unlikely(RISCV_ISA_EXT_ZABHA)) {     =
                       \
> > +             register val_type ret;                                   =
                       \
> > +             asm volatile ("amo" #amo_insn #sfx " %[ret], %[val], %[pt=
r]"                    \
> > +                     : [ptr] "+A"(*(val_type *)ptr), [ret] "=3Dr"(ret)=
                         \
> > +                     : [val] "r"((val_type)((new_val_expr) & PERCPU_8_=
16_GET_MASK(sz)))      \
> > +                     : "memory");                                     =
                       \
> > +             return ret + (val_type)((new_val_expr) & PERCPU_8_16_GET_=
MASK(sz));             \
> > +     } else {                                                         =
                       \
> > +             u32 *ptr32 =3D PERCPU_8_16_GET_PTR32(ptr);               =
                         \
> > +             const unsigned long shift =3D PERCPU_8_16_GET_SHIFT(ptr);=
                         \
> > +             const u32 mask =3D (PERCPU_8_16_GET_MASK(sz) << shift);  =
                         \
> > +             const u32 inv_mask =3D ~mask;                            =
                         \
> > +             const val_type val_trunc =3D (val_type)((new_val_expr)   =
                         \
> > +                                        & PERCPU_8_16_GET_MASK(sz));  =
                       \
> > +             u32 old, new, tmp;                                       =
                       \
>
> This isn't a bug, but the two LR/SC fallback loops name the same roles
> differently.  The non-return loop uses:
>
>         u32 retx, rc;
>         val_type new_val_type;
>
> while the return loop above uses:
>
>         u32 old, new, tmp;
>
> The loaded word, the scratch/merge register and the computed field play t=
he
> same role in both loops.  Could they use one consistent set of names (e.g=
.
> old/new/tmp) so the two loops read as clearly parallel?  As a smaller poi=
nt,
> new_val_type reads like a type name rather than a value, and new shadows =
a
> common keyword.
>
> > +                                                                      =
                       \
> > +             asm volatile (                                           =
                       \
> > +                     "0: lr.w %0, %3\n"                               =
                       \
> > +                     "and %1, %0, %4\n"                               =
                       \
> > +                     "srl %1, %1, %5\n"                               =
                       \
> > +                     "add %1, %1, %6\n"                               =
                       \
> > +                     "and %1, %1, %7\n"                               =
                       \
> > +                     "sll %1, %1, %5\n"                               =
                       \
> > +                     "and %2, %0, %8\n"                               =
                       \
> > +                     "or %2, %2, %1\n"                                =
                       \
> > +                     "sc.w %2, %2, %3\n"                              =
                       \
> > +                     "bnez %2, 0b\n"                                  =
                       \
>
> This isn't a bug, but the read-modify-write LR/SC sequence here is nearly
> identical to the one in PERCPU_8_16_OP, differing only in operand numberi=
ng.
> The non-return loop parameterises the operation via #asm_op, but this loo=
p
> hardcodes add:
>
>         "add %1, %1, %6\n"
>
> Was the intent to keep the return path add-only, or could the two loops s=
hare
> one templated sequence?
>
> > +                     : "=3D&r"(old), "=3D&r"(tmp), "=3D&r"(new), "+A"(=
*ptr32)                      \
> > +                     : "r"(mask), "r"(shift), "r"(val_trunc), "r"(PERC=
PU_8_16_GET_MASK(sz)), \
> > +                     "r"(inv_mask)                                    =
                       \
> > +                     : "memory");                                     =
                       \
> > +             return (val_type)(tmp >> shift);                         =
                       \
> > +     }                                                                =
                       \
> > +}
>
> [ ... ]
>
>
> ---
> AI reviewed your patch. Please fix the bug or email reply why it's not a =
bug.
> See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/READM=
E.md
>
> CI run summary: https://github.com/kernel-patches/bpf/actions/runs/284940=
34360

Thanks,
Yunhui

