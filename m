Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72321FF8867
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 21:46:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE4F26B0093; Mon, 27 Apr 2026 17:46:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBBEE6B0095; Mon, 27 Apr 2026 17:46:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAB2E6B0096; Mon, 27 Apr 2026 17:46:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B9ACB6B0093
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:46:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 666BF1A02DA
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:46:21 +0000 (UTC)
X-FDA: 84705669762.21.05143A0
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3BD0E40007
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:46:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=DT8KkATl;
	spf=pass (imf12.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.50 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777326379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DjF1Jdn4Kp6xFyaBmAP2391GfFF2q7kuOVlruTChM90=;
	b=uLQCFgejqUAkPLA37lRmFaBb8RjJ60O5XgP+zqdoyP5wI3S8LgKTV4NJfYIShnLMkKIvin
	G6sF2sZMMgdLeeAiz3RR4hDNreBJKKzZblFIeaPmjehylRUuSes1SRIctBvX/nRIpagCf4
	MTjC0TMqy+wosU4h0KuxhfYNMdzUwGU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=DT8KkATl;
	spf=pass (imf12.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.50 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777326379; a=rsa-sha256;
	cv=none;
	b=iXBhJac8CKMYaydC3Di901ShHxS1IF1Z6NVnpTuKYLLvUeZe+mfzd6c4/LWJIjD3AWKWEH
	vC8FjpXWAliwSYmcBxFNJNHob2mITVb4QnPScRcyDOW0y3WUFQd8YzV1sZAhKpfI2CsUU4
	oFCGGQvTvRX+2ik0TcIM3YsvnwxgKds=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-65c4152313fso14723557a12.1
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1777326377; x=1777931177; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DjF1Jdn4Kp6xFyaBmAP2391GfFF2q7kuOVlruTChM90=;
        b=DT8KkATlQHbQ1SfBDc8iAEftDwzawZ8LH+kLdpMGjMjSSHR9n4LqDzB0099AtPhXXV
         7HSMruQk1xeS3aUJDXKWRySMdQ6yCT5qlje15R/nk9BBDBbZvWBpn6Qxlly6Qz8cz7I+
         f1JDP6M0sVXheGmJVTmqazPp5SIItKXPo7GX0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777326377; x=1777931177;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DjF1Jdn4Kp6xFyaBmAP2391GfFF2q7kuOVlruTChM90=;
        b=sA0hMytnBkQPiz70uuukWf0gEdiLzDQYcRUOBvhL8/yRdmoYtt+CtVz82uPnKG3eDp
         gnq0BYGNfF+o9tppvzp+tbJBRFWLx/5rv3Lu2LQAhxB1h8U8ZHoXkGKlvZreRWktv/SY
         KCdsLM+vXnfdUMCdPlpKEm7H8pNYPLl7hIx8j1K5AfM99MHG7X1e8rUb6TemNiFWR0Ot
         QqIzctVJFX4LxHdDz+2JHB7dg35+pxpwTjBQMwrMku/5CcewH2SDRBlztjPSxtP3t8i+
         6NdBGzwDw2LDpXjKVHs2SwN1VEI68cauKXoJCacbH2pugkVv3GCn5MWH8ZBsgTp77xgK
         U/lw==
X-Forwarded-Encrypted: i=1; AFNElJ8P7ILmzUaSQvR85vGdeZ9ODhOUT7bhgpf/Z9hCsZ9fk8Lo2y2E8sMMI0aZAvc12P/Ka7zSZYrM7Q==@kvack.org
X-Gm-Message-State: AOJu0Yw8YrowIqNZIIx5AsOxJaznrlG0DAfwOS6ooX4Zk+XfgWxKnPfF
	JlEAxPVkWXN5Je7Py3p3wJWQsjuTXCJalsQA+5D1fzn7ElTSspg18onSkD0tEm71G5FcOQBEcxm
	P9wr7JnsGhQ==
X-Gm-Gg: AeBDievGcFJxwJr+iFfQkaBtlrIo3eHiesQYYwt3mJymKPXZ1m685Ew0U2TucHmqljD
	vdMKzZ8Qur5vw30xbBntQ4ME39Dxvw8EjvZf8OSOgj9WfKyM+JqMOrSUsfSzDyIbjYD6rp3o1B8
	0nffEaonnMRGNgL3VFwz61P+aN7VcvW1EYvQuhzZLYaJy73mcJ4lXz86v2/V+aLO0Q1twCtU5es
	d5BPsebmuHSDgrwWT08ckZgwRQgIEZQPqi06GBrCAda3loeHhXf7ms4ZYB3PQoQmhwAMfJsgNQ7
	8I3cbgdNfUilRIu28fVrHeKFA3SJA6I1+TBT/TlO3mHf6v35e/0J7vzHUm8Tb4OO0mAi0qXC9kB
	1MSxcJ5HCr5kRm8+TOof9XtvbCOj2O5Pam+CGEX7eRN9Cb0f37qwWQmhzr7Nlg/IABn733j/7Fe
	IxvxjEKTSvneVWQft3vb/58wWzvO6SFPjBXHb8si65Mn79Er0WaR6st9TtMhkhSuwdm5uXWePKs
	Cx3Uy0J1xQ=
X-Received: by 2002:a05:6402:2353:b0:670:7c64:c24d with SMTP id 4fb4d7f45d1cf-679bb04c0damr159899a12.6.1777326377622;
        Mon, 27 Apr 2026 14:46:17 -0700 (PDT)
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com. [209.85.218.48])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-679b686406asm142707a12.30.2026.04.27.14.46.17
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 14:46:17 -0700 (PDT)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b9c01854477so696686266b.0
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:46:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ99kYZ5wD72PZfw7vuUARBuCHYF4AI8TcmMfFF3HD+/gYV47Y7mXEWGLK2nT6Tyobd6Lb4BvaE2vA==@kvack.org
X-Received: by 2002:a05:6402:5216:b0:679:1f4f:9d30 with SMTP id
 4fb4d7f45d1cf-679bb04c1a2mr179970a12.4.1777325976937; Mon, 27 Apr 2026
 14:39:36 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1777306795.git.chleroy@kernel.org> <289b424e243ba2c4139ea04009cf8b9c448a87ff.1777306795.git.chleroy@kernel.org>
 <CAHk-=whC1DZojwdMB1=sJWG2=dsCdfyU8N6tDE1qx50HRZ-WJQ@mail.gmail.com> <20260427222914.1cb2dd3b@pumpkin>
In-Reply-To: <20260427222914.1cb2dd3b@pumpkin>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 27 Apr 2026 14:39:20 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg0SGbRYhdZ1kvJUTv1HEvmRJyQauFtBGV_fMcZVF8UpQ@mail.gmail.com>
X-Gm-Features: AVHnY4I-AxqvQRk42MegvhKMp_z4sSEpEzhzpgw2GyV2bV8dezSPoI0JTlwB18Y
Message-ID: <CAHk-=wg0SGbRYhdZ1kvJUTv1HEvmRJyQauFtBGV_fMcZVF8UpQ@mail.gmail.com>
Subject: Re: [RFC PATCH v1 5/9] uaccess: Switch to copy_{to/from}_user_partial()
 when relevant
To: David Laight <david.laight.linux@gmail.com>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Yury Norov <ynorov@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, 
	linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-um@lists.infradead.org, dmaengine@vger.kernel.org, 
	linux-efi@vger.kernel.org, linux-fsi@lists.ozlabs.org, 
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	intel-gfx@lists.freedesktop.org, linux-wpan@vger.kernel.org, 
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org, 
	linux-spi@vger.kernel.org, linux-media@vger.kernel.org, 
	linux-staging@lists.linux.dev, linux-serial@vger.kernel.org, 
	linux-usb@vger.kernel.org, xen-devel@lists.xenproject.org, 
	linux-fsdevel@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	bpf@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-x25@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-sound@vger.kernel.org, sound-open-firmware@alsa-project.org, 
	linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, 
	linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linux-sh@vger.kernel.org, linux-arch@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: uu8upaqdswacijzyrzbkz9rcnz6gjm13
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3BD0E40007
X-Rspam-User: 
X-HE-Tag: 1777326378-937445
X-HE-Meta: U2FsdGVkX1+PbhCTpvvO6IDterSWGbZejRIr/txidx872Jp61e6MOoVux7kWdXZYxiuKam6h/BA8S6j4Mf7Z4eaWpyBA0PzDdAX30C0696R5H7yYm/28sAPhzFZtE9C6B1oAf82hhesRtw72TU30NMSUKUMyqhucbGrnRZLYK06YeWfESKABpPtY6+stihyXloQbX/idL5PVPkDFauE78oGIOI9gFOXuPbB/wwUArjeSQPkpBHCP0WN0OjGXRU0wo/h6m6f+787vAhOjFAtWsMYFQ1LCo6rHU/bNefBFSuD2EZrskrueTYJys9YQ74es6+avsAOMiHlcxpN1FqtgrhNvTv1Kd67IydCBZyIXVZ6KSnXLjdKsy9gC7k+RvY2mbKwIb9QiST3f6j/3pXdj0eoy6E5a2IkGJz9SemARQfmKIccDUvjU1bHpYHqR98j4k9BSzbq7GA+4qIFqYQ2JGdhN4JC5kKMmwxLg70k7RlAjIu3aC2anlKiaYhuks1aP30UOTCYFxphWOU8IrscNJq5PIkQlLvfy9pg1U/QJSMMrlQlR6bbJf3R2PQpT8YNaYefHiv0/4i598h8MgPV/y/z2LDRkiZlfa+a5FEo6EnaMPLbsxwjXvGtjv4lYpgYeRH7CM1MLnNEHLKt8bWGaOVMd1Lbrdg1vyt1a4vrcMBT/g2DZ4XkyHwkefx74l/ods4dRBjm8L5rsJBw/35TgzT2ypg9zzy7RiDOWsGBI8rONgxyPbiikB3drQh2LGjw3qJriHJomi4qZ5Zgm0jXmgyouzuZV5cBVP9NTDfkdNwV3GU/SdFEt42/kO7Wi4Np/2vwwaLJ92GliDsfaHzMUcLFr5vKdmq7Poq9eBlU1xdlQQPKaZAlO2ltxzmAe40BfcNY8KCJRiwieRmKZevyoY10XpfRGCuX7oYCXSwDmxz428a2t94K3QzO7MS1NZWeCbuS6Gkdmo7VjlxwZhcV
 X5Su3uU3
 C6Q7lU2qwoVcUqptw53KzjiGVbj3+S12vFSxmYhqCSfR/h4TBUOdyNOBGDkba5heYSaLHAEraMPpXd3jMqBRqcpYprI4avHEQ5VCfRZ1ufbBr25e4DKKL9xm1vqfgQ60fB+xCfOfR6al6i7SROl0CS+6mI7dnznulTfT+/5IhtC9il5AwFQlJ6OqFBQvsjRqx0MlmCDUFHHXWMpT6lvkvf/llOa/JvXywv7tK4WqTQmtbkWfZw2p1Et3CfhDXgMIAt8N03LBS6/d276aYVh2hajyvDal18hb8G/WGpVNJo94hY85Gqbx5KXf6/3I3TWOfGVWyHQBiFpXtcWSUssTNzUVGjjrulNrgq4jczfhxNsDgRpr+bwlkEcJwoxPErpznbzLchAvo7Yyw0bWaXDeBmUw8L1KiF5HboaNEPgvDBLSi9/8yASMD8jHXcOi3xzjKd/H5y8cFznTJtMmG3W1hPLu+FwGfmV/ZlgzpX08Ue8lC+5ociWVbhEl2mCAXz4DNI+H93G1RKuBWtKrO8J6HX1a4mPZQ0N9a2XQCUDzMy7FIqnmOwwGkelF4gSgQ15wtV3yR/JuVloOGpHXxVL57YaJH+9z0ir3BwWwB16/ijRtEAKlGfLR0lpCVuEIJwskVW4mIttTAa3zg6bTdgLQLgpCnICPGcc2OMFkFeW1t6kLZ+PHlYEXWwCHTdvKr74/NQ3W3XZY4MVTO2WESLpvs4mBcuBxaWiys9XO6TobtRBfDuTkr/OZFDnXCi6er8dGnVZ44ylfoF5iHWbUuSkdQDMjIXirmqL2LSESdDhqlXtqtgnDy+4PauZlrfwINjzWMTOavNOxBj8zWJpy1tIP82spJTZb0HTnIVsIgYZhuA5osICk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Apr 2026 at 14:29, David Laight <david.laight.linux@gmail.com> wrote:
>
> I think there is a slight difference in that the normal copy_to_user()
> will determine the exact offset of the error by retrying with byte copies.

I have this dim memory that we decided that you can't reply on byte
exactness anyway, because not all architectures gave that guarantee
for the user copies.

But that thing came up many years ago, I might mis-remember.

            Linus

