Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 032C6C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:40:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 694776B00B8; Wed, 23 Jul 2025 10:40:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6446F6B00B9; Wed, 23 Jul 2025 10:40:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50CA86B00BA; Wed, 23 Jul 2025 10:40:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3AA036B00B8
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:40:06 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 91F2F140730
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:40:05 +0000 (UTC)
X-FDA: 83695789170.10.F341000
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf18.hostedemail.com (Postfix) with ESMTP id 970621C0015
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:40:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=FpCmXgGE;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753281603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E4VW1A7ZGjSXpn0g5zEan91Zyknv45cf516fxn6sXo4=;
	b=WPd0WeIeDFduyNpu/5Hf67GpKZLEyskYO8jJ9xQ6gnrT2AAaUr+BadpiDGLehHE+PwHKuF
	MFCPYcD4D/dlnjn30Q9Ps0nPlvWqb0qVBGwzgJ69yIxbdj9+M9ZEcOEsecM1gP6IHrUuMZ
	a4/XnhtIX3Bgd5R4BsPAYHcqUhqpXA8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=FpCmXgGE;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753281603; a=rsa-sha256;
	cv=none;
	b=ZSWHI4Jb0EUAT/4ZrZoAQZNIfoDeCEhwPOlMr+Z/OPF8QZjKTR4KMCPeWyt7OUiCU27eYM
	W+JlZLCkNAc/T9psL4E6qp4UlBSsxmvuwu4G5/xB7XjM/QwdxboT930aWzE1jgsU3bbuST
	UPI0rMbTxqPu9WK/4JX1uFH1muR1Cwc=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4aba19f4398so84668011cf.1
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1753281602; x=1753886402; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E4VW1A7ZGjSXpn0g5zEan91Zyknv45cf516fxn6sXo4=;
        b=FpCmXgGECMgyhS0yvgqYgWjaKtcBKCKpMr8fQVRWHXD9XC4EPvqBUfmZ287aH1qkFN
         HiU4fCG1KgxVUdGRsHvbxkc9ex3yQRN6R+E+381aRBiSs/Iq/VvCDr5FYaur7gFlMQ34
         Rgr0k/3YRRhHN3CNppZi//9H9i9o7jZXtUlWDgspshZUdu8T2hs2473LgllpQ+zmuENy
         +C+mJclvoHXOtBzcye8b14KIXydg7hijmoWg9BpLORdVPCgTM7bWdxGdN4ct+7sAjfTl
         ZGtFCI9tT6Mav22qT6NjfTdV+NeTaAN0KHIyGx/z7lal/ocqymSBfzOCayTUdSCCU4a+
         Kjgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753281602; x=1753886402;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E4VW1A7ZGjSXpn0g5zEan91Zyknv45cf516fxn6sXo4=;
        b=YV7RH203nYKKAunWe1qwtTRoRKWEg9JTv7/CT4kc8mhSSL+d5rQsE8tj7ErrXstr57
         IeXAptVa/4Tv8apNYA/FFtsxY2KwbA7RHM2aeRpfVFY1utQeNusSm3jSgZSBjnrl4XqR
         gmJgWdUzZ4dxx4YQE89Vyal7onxjqsRNT+1Sm7YF4eGd1ZwfUhgwM7K0pfKOXxOX740b
         Da2aq5zKSgbr3wxNqnpnK2pvEJUe8eto4qsuYjfN1JOZn+PaVVN23IlWsTaRQ8YWYIun
         WycbY+YwU1/SLP9BMym4EAWirggRnSBOaGkxp1/45Or1719jEz1GUt8GPZz0kX63Q+r9
         ZKsQ==
X-Forwarded-Encrypted: i=1; AJvYcCW7YC6nTH1DdHravsVD5M2hwMKUd/Nyuwpz/jIeP7oCwItg5Cks/tE2ogsD08us5r0ed98I2pBu6Q==@kvack.org
X-Gm-Message-State: AOJu0YyIFpdPxreWARyfkpSZXE5VmvwKHPhYLX4oMLrOPfGw4laeity5
	OQkDSSvLYQGi7BFXGQ3fRQLqrTs3TVaDVLeAwNmBktjWIhPqAOqYvDykwcVooZSEK4GZZg0lg7M
	DA0JxbfdxtU5T0GKERMA1M+Bs3kIgzVyX0ItWcvFvyQ==
X-Gm-Gg: ASbGnctyr3RrwIgg4bFWlREGn9A1AKfdGlU0fYbTwWGZflJCxzpdJEDl0kvWs34wv1f
	awbVsCdXBEFyoh3QdoQRydH9NhPlOGUSLX0Mzc0kMU1/83w++YGeMA8WsVkzUN50Ei/PONP9M+Q
	uRBpPegcHaBh2pBP7bvDoF1qUWplSTk2rgC1J1eSpuZ3It+80pA/9ZNBKKjAhK+8TqosSIf1MHr
	er/
X-Google-Smtp-Source: AGHT+IHFS+sl5UqmRZOH4YC8rrY1lTn2lhJNlt9MYCWZB3088lrRvjxl69LEe5to8g07iNSRAqNDE0qYJCcj4SAzgKY=
X-Received: by 2002:ac8:5d14:0:b0:4ab:41a7:852 with SMTP id
 d75a77b69052e-4ae6df7e0f7mr46630481cf.26.1753281602021; Wed, 23 Jul 2025
 07:40:02 -0700 (PDT)
MIME-Version: 1.0
References: <20250625231838.1897085-1-pasha.tatashin@soleen.com>
 <20250625231838.1897085-4-pasha.tatashin@soleen.com> <ac8efa08-3f85-4532-8762-573ebd258ca7@infradead.org>
In-Reply-To: <ac8efa08-3f85-4532-8762-573ebd258ca7@infradead.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 23 Jul 2025 14:39:25 +0000
X-Gm-Features: Ac12FXw5a0SPc2DZ1qffEKM0_QNNJkpaMIdscCC70ESios9nqZeZ3FVsbikeuDw
Message-ID: <CA+CK2bCChNVmGXPN52La1zECBBSRf5SffHFEHwMcJCDaqA+YUQ@mail.gmail.com>
Subject: Re: [PATCH v1 03/32] kho: warn if KHO is disabled due to an error
To: Randy Dunlap <rdunlap@infradead.org>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	changyuanl@google.com, rppt@kernel.org, dmatlack@google.com, 
	rientjes@google.com, corbet@lwn.net, ilpo.jarvinen@linux.intel.com, 
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com, 
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org, 
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev, 
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com, 
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org, 
	dan.j.williams@intel.com, david@redhat.com, joel.granados@kernel.org, 
	rostedt@goodmis.org, anna.schumaker@oracle.com, song@kernel.org, 
	zhangguopeng@kylinos.cn, linux@weissschuh.net, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, gregkh@linuxfoundation.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, rafael@kernel.org, 
	dakr@kernel.org, bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 970621C0015
X-Rspamd-Server: rspam06
X-Stat-Signature: wjphz618h6eikpatewzxsi58m8zq9ypq
X-HE-Tag: 1753281603-386975
X-HE-Meta: U2FsdGVkX18goOXRqlh3CPyd4CicX6HzLnlHvJbhjsLD5W5MckayA2Qro+uLeZsYyaH+m1eiAwVtIW6od25HI01YrPZt8TfoFLZNx+U0atsxFk2HDqcqcj4O2Ziu0Z/vY4GarNUU4DZiNIZK3vA8bDU35naUkHk6MYXw9NtsHNLr7hqG0L9agA7lCjSbKmKfnvS2lXqnxMBWlwGZDaHNEpM9GP+6IiW7gCIyJK+rdccxvhYkvYu88K56bQcva2om23S+/FELcji+xoHRdsoUn2bOBPsw7h6NlEiHtqEkY2/Or04diyt/WZX8MPhEwZW70S5EozZcDzZVGuGAb8gs86xtf8y5MIIOxazF9tGrnoKWH+w0xkf05MNkPX5T372GoUvd3Guv9woCE6qnUFKp+05dIXswH3Fi4hYmBV6PSf7cAh25qkfAn3uQUiE9yeIY+u0f8+2vH5+t/pAZNpj+B6ShQx5TZDIENd0ChUIqKVdpp7/kw6h0+0MeBRsHw3t3KDaJPenpNp/mMLnejckRJi4eoLimwqJvxQE5zYyNRenTpmg6eV7aq2U+W706DQ2wP+5ha6kulaHmqMUpQi4fbwsfV/wgL30mXWsHYAfbbAYSQGZAx5603iS9MwIzcrU3ZVeIYbGQQJpXmiDaNsA0hSY2OK1n98dqGAAzQnREJ1z1NYnohRs8/FozJLIl4Xgo2Y6iKhq5l7WJ+dYTGAv/NjYR+SDY9SRSr/lZ6R3MJk8WFClrQoerT2vEMUd4cqHzGjyf5hUjGZ05ecNgbQYuc4yzMttBA3j/1wHXlCWNeb4y8WXZxQgnX72GP0ZpnWA+liFgXGQW7Qap0SVWXxK8nV1AKRl2+0u5rPRHWmAmRpaYd3CLjM16FZkYC68rbxCsCFYmVoBdqqlX3QFAs+6NGobXZitHMvFptlPhrfJwbUUQBvRYIs+GAdomf30ehfhdqMsEwC11FO0IGsnA/mF
 G+pebZEv
 e4ecuOu3C2R6yYFEoMXgHN3VmDvPGQ0rtG6gsahuaQyoICDvT8k33Ge8IIZoZZjRKfo4Y5LMkR+2qi4fCZUKNUuqP6OruHloBGsduC+/ZzM5bIJBa2C0MG9sEXwpvQUZVEzPzfFDFeea2+dU3yO1IErC/hg2GpxJHXU6ptqkVHxkG5h6Ue7xvF3In6x2Fkag84z1tyjdM/1aTMziaVRJOAD+So6QBBzLeW0e9WRTqUKmI2119Bf6z+nZsfRWzK66Vn3EfqcEAj+zrKqmx/zfMVX7EVogyk+H28mfLA2/cEQcOvjbUMoPfyFNg5WwgEGzTv87eE6pOcMNKdhUQ7jbO38rYdzqbhemmynOpER9+DIroqeASEneX24KfqT5QjyraTQdrXhzRrqZdzXK0Tbqjd3dnEv926QAYFAI9Fskr96xjptBvdbwIrw9ecL1NeWrIhV1FGh0LAecTpJ/Ldc7D5Es6OlECRUnVAQM4cLl5Uc/GAemVSQDVacpeU4cbUjNQhuuq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 25, 2025 at 11:57=E2=80=AFPM Randy Dunlap <rdunlap@infradead.or=
g> wrote:
>
>
>
> On 6/25/25 4:17 PM, Pasha Tatashin wrote:
> > During boot scratch area is allocated based on command line
> > parameters or auto calculated. However, scratch area may fail
> > to allocate, and in that case KHO is disabled. Currently,
> > no warning is printed that KHO is disabled, which makes it
> > confusing for the end user to figure out why KHO is not
> > available. Add the missing warning message.
>
> Are users even going to know what "KHO" means in the warning message?

Changed warning to: Failed to reserve scratch area, disabling kexec handove=
r

>
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  kernel/kexec_handover.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
> > index 1ff6b242f98c..069d5890841c 100644
> > --- a/kernel/kexec_handover.c
> > +++ b/kernel/kexec_handover.c
> > @@ -565,6 +565,7 @@ static void __init kho_reserve_scratch(void)
> >  err_free_scratch_desc:
> >       memblock_free(kho_scratch, kho_scratch_cnt * sizeof(*kho_scratch)=
);
> >  err_disable_kho:
> > +     pr_warn("Failed to reserve scratch area, disabling KHO\n");
> >       kho_enable =3D false;
> >  }
> >
>
> --
> ~Randy
>

