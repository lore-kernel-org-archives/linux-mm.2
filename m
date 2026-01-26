Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40942D19519
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 20:43:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D4F26B0088; Mon, 26 Jan 2026 15:43:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 958DF6B0089; Mon, 26 Jan 2026 15:43:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 830CB6B008A; Mon, 26 Jan 2026 15:43:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 736446B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 15:43:30 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 21E65BB9FF
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 20:43:30 +0000 (UTC)
X-FDA: 84375290580.05.CA0E025
Received: from mail-dy1-f196.google.com (mail-dy1-f196.google.com [74.125.82.196])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5A65F4000F
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 20:43:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=gflIu1Fn;
	spf=pass (imf17.hostedemail.com: domain of debug@rivosinc.com designates 74.125.82.196 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769460208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s0UipC5QHyJnTmDWXctjUpxhkNyTA6jh9RjXD3Q3T9M=;
	b=77/LWEyAbUrcu68m0rDbLk/Z2yf5zDCYEeA8OXWCBy5rQpXe095EBj4MOECiHih9sbRtso
	VEvWYvipkoxYO3hfJ0sL91jX6s00CtAjzNJyrkKpbemAOtR9UodK1cH62kHbCJ034FPNiE
	5a0x1sTiw2pZW4yGs9exzOxFrKM6NZw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=gflIu1Fn;
	spf=pass (imf17.hostedemail.com: domain of debug@rivosinc.com designates 74.125.82.196 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769460208; a=rsa-sha256;
	cv=none;
	b=gbHJ0bAkuWqeTcqfc6Y8rgyeCxtAlR1kJJlZ8HzxAPVOV0b79jl97smJ9bjBhmpcLkRwFO
	0OFYbCG7daY/rg0YJ+mqKfLO7I8VY/swy++kLg94ZR8a2y7RmxCSVHA60Ikd0gSvK4Si+m
	UaKaIwdG7Z14ldtYTiJRffA0KC3qYrY=
Received: by mail-dy1-f196.google.com with SMTP id 5a478bee46e88-2b6fd5bec41so595073eec.1
        for <linux-mm@kvack.org>; Mon, 26 Jan 2026 12:43:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1769460207; x=1770065007; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=s0UipC5QHyJnTmDWXctjUpxhkNyTA6jh9RjXD3Q3T9M=;
        b=gflIu1FnnP8IWuVAkIvKoxl6BlF2gqkv4rRdTJrKFBiT/wvhPgucmKH645gopSxoNf
         B9DCdSpCo+LU/WDWlyxrFo2yKORSXIBdCqDJteSp+G1dyxRi4oVVLZEpEes4HmnXDSYs
         oiJOoNHTbn4GRO7NtRVXetKYgZdel34ICBpFAKnrlfWL/WfjSJSjlPMDVouttIMAfaxX
         ChvrhPq0mFEJbKGfILvrCe0G41BjJmuiVMbHw0gyebAYN1rfXt8jSp0AYN6/lhkLzeNw
         /zzxgAoRJHEgdK6hZWqo6k7FD9C/XVmBPXh6Nm2HuU8IlCj+1X2CX4xwvyQn8XDDRFMc
         ucRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769460207; x=1770065007;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s0UipC5QHyJnTmDWXctjUpxhkNyTA6jh9RjXD3Q3T9M=;
        b=DzNLYRGX4rr6/IAMD/Awv6vsPdRfE1IOoxhfbopwe/xWOBSll45sY7IQtShkcv1VYq
         tVYyNiBRJlACB6jTXW5v1KMVHRM9WTsuIOjWl20A7WHVHQ01hotGOwMnrHRGI6Y3SPp8
         PYvvBUGACDko+YVSLF8bydXu/Mh5igzdEsj/2/mKYy6fnyuVSmPZGRa4nUq3ahjv2ky0
         8bFp8V5lsVgQwXCEuF2j0oX+h8Yj6SfDjcEDQzY+1fT22aA6wipIKx0z4pCDzCC2E/KV
         q/foNQpXt8BEExQlXm7OJhVnx7/iQirmHR6kiGozgKnpPAVZ2CLre0O012oKYjtN1aDg
         Daug==
X-Forwarded-Encrypted: i=1; AJvYcCWSijjPgC1fbsYi6roVC5w5/Btsspvw5PPK+rUmDoTUpMwFj2azpeBK7H2phRfU6js7bueyePEd6A==@kvack.org
X-Gm-Message-State: AOJu0Yw9fb/WIfLQlmaLKS5G7V15FUmu9hjGV7jbTmw+0EyhSYsPO/Yh
	j2Zelt28mBqtGWiDqpC7np5Fd4mctNP5aK3ayjvIYC3Xvk2htPA2D+QAyEZYEgwzi4c=
X-Gm-Gg: AZuq6aJIBjiZy8Tauqi1Xs4Z/Ww+yXsUztFA1dI87L4LV7e1HAHkHu5/LF+6ntMioLJ
	tHD9BoJ9kBkvPsx/yaF9uWGFt459wKujOgD/3NrqVHwesxbBpVX1HKDZNgh5UksBVPjV5iduXH+
	wFS1LZJWMUMdt8SqRpUQYveiEDlDoY7zwJ4KFHSiXL4zIntWkvvMGK+Sw7AF8gR3Iw2J/liYci4
	J5QEy5CPvNbgESa2WuQNrsOu2OetwNfokAh2pDUStiliTJDzx9MTYp3TTXiVA9zaoMjb5by6Z50
	XumAFl8f1te0bwECN6wtJ3VmQk5s9S+mvq2Wqr+4wlEhBiH7nVWk1SEJSAg09GW//OXipIS/nFJ
	oMrB20Ejpp7yO09g2LNIbieEmcyPXapP8LbggdaSUT9LmscwFsZDFYIJi8stMMmo6p0IVzBVN21
	1lvErmV3sHmJx0hRYgwxBE
X-Received: by 2002:a05:7301:d16:b0:2af:7ee:5300 with SMTP id 5a478bee46e88-2b7643466e8mr2954218eec.14.1769460207055;
        Mon, 26 Jan 2026 12:43:27 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b73aa08964sm14741354eec.28.2026.01.26.12.43.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 12:43:26 -0800 (PST)
Date: Mon, 26 Jan 2026 12:43:24 -0800
From: Deepak Gupta <debug@rivosinc.com>
To: Zong Li <zong.li@sifive.com>
Cc: Paul Walmsley <pjw@kernel.org>, x86@kernel.org,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Conor Dooley <conor@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Jann Horn <jannh@google.com>, Conor Dooley <conor+dt@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Benno Lossin <lossin@kernel.org>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, alistair.francis@wdc.com,
	richard.henderson@linaro.org, jim.shu@sifive.com,
	Andy Chiu <andybnac@gmail.com>, kito.cheng@sifive.com,
	charlie@rivosinc.com, atishp@rivosinc.com, evan@rivosinc.com,
	cleger@rivosinc.com, alexghiti@rivosinc.com,
	samitolvanen@google.com, broonie@kernel.org,
	rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org,
	Andreas Korb <andreas.korb@aisec.fraunhofer.de>,
	Valentin Haudiquet <valentin.haudiquet@canonical.com>,
	Charles Mirabile <cmirabil@redhat.com>,
	Jesse Huang <jesse.huang@sifive.com>
Subject: Re: [PATCH v26 00/28] riscv control-flow integrity for usermode
Message-ID: <aXfR7NhAxHlND3z9@debug.ba.rivosinc.com>
References: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com>
 <e052745b-6bf0-c2a3-21b2-5ecd8b04ec70@kernel.org>
 <aTxf7IGlkGLgHgI2@debug.ba.rivosinc.com>
 <CAKC1njQ-hS+kUJ0C_v0oqZW1EZw2zAXMp-SnnA-ZXh_H-SoVdQ@mail.gmail.com>
 <CANXhq0rpjSvOThACrB6_MMc8S34--xJsUYZ+HtMu1GUNyk8zOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANXhq0rpjSvOThACrB6_MMc8S34--xJsUYZ+HtMu1GUNyk8zOg@mail.gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5A65F4000F
X-Stat-Signature: jex4twe7pfr55gf5rgkrs8by4g1s6nzd
X-Rspam-User: 
X-HE-Tag: 1769460208-483017
X-HE-Meta: U2FsdGVkX18xkmCoJnNutl0uormPWWrHpgWewchlvGk9bnUO/3SAvmvlyVPWN9Btm+caE0EuQE5YLWsoWY7L/gI/PMLxzC3tABFGHsn4Sm8mBrGKEaXrk+dLnVV/f54hWIIrXj0ICqoL+AQ8RnIywvDP2OuC1sdx6ii/l87sJVdpKJ3tYKMYPEUzQzG7y/FGGzhjuon+GVFUMnyef2XGD0go6MkJBW3fODGqO080xzyfMUoYg/txy+WooA4J939jLLR/PP+uo3LFCoqJl8UPtZQ87lzdQGGvkngOdZo3Cs30u+OcvCbbouNQyS1WN9KikyIFBnd74VgErKhrqGqQ2nblD5Wt7MXe7xjeT4mmscG5nB/79EV2Cz5kuBxd1b3XVgvNCkMXzpgTF/E0cy8tlZK1wNoYLal07Ypr5980n+YE5CZmpBHYdn/ydl1OFlYmMqgitenEZVkiDR9jQztwm7NE8Wk4CkWYDBEabAPC3aX8fGzqeMrHBhXQ+HIevn7swlnmoloL3ZKPCxSwHDnmc0leV7rJr9Xyy4KyCPfEO+XDjkyGsxkw7Jk2WEbWuzwgBpBgr1sdBu79aw3SoOZDkmM0G8muDZ9/s7vVYIw1VkxyOdf8q/9tmYNT6LlB6QBWJbSSODAB7h8fQhvJS0pSvK8O3kLcVpcBD6aj1v82n1wmrGWeBeaHrtGJ7VDYzuaQVgU1c1l0sXei0O2RvpeXmT7qlflqmq+parsbGdi1ER1QLlbbxSJFKLFKSri2G45ElUHuriA27oLV+bmKeEqBu8ejc88uaQ/CyOGC7irvNi+vrl74cdNCrtIKm9c/OilhKYVIY9Vf5QaVXTIv8mF2VbVm5WXffWKlo7+W+HixIyl7fG/iLINfe3P/0H+Nmuw0pM3pFPmghJAOvjqwhKLG7JgHsqEZrdCjq4pQ33OdN75W/uVDV3pHNyv7cYzh4GqJiyD7X6AmoMg50yqBCRf
 f4wBtgfV
 olbGkbuUo7nOi/hXAxMXOueXqI82/AKv8W6V5o2SiumasrUP4Qvy6RgRhJ+vAGnwGYxYBQtTEjMZUYPq9Kf/7WRHWvU1qTlGFNcku1Vw8LVxxdcd34/T+mg4Igt4DZ/W/IjxnufZ0cyYBrKOSwiz/K+ElHAEPFRpPKPLgtLCWb2bIL/R0XY0s08MNXQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 09:32:20AM +0800, Zong Li wrote:
>On Thu, Jan 8, 2026 at 11:10 PM Deepak Gupta <debug@rivosinc.com> wrote:
>>
>> Hi Paul,
>>
>> I have a bugfix for a bug reported by Jesse Huang (thanks Jesse) in riscv
>> implementation of `map_shadow_stack`.
>>
>> Should I send a new series or only the bugfix-patch for implementation
>> of `map_shadow_stack`
>>
>
>Hi Deepak,
>Not sure if I missed the bugfix patch, I couldn't find it on the
>mailing list. Could I know have you submitted it? If so, could you
>please point me where the patch is?
>Thanks

No you didn't miss anything. I had been busy with job change and even though
change was small. I wanted to do some basic testing before sending fix. I just
sent the fix on this v26 series, patch #10/28.

Sorry about the delay here.

>
>> Let me know. Thanks.
>>
>> -Deepak
>>
>> -Deepak
>>
>>
>>
>> On Fri, Dec 12, 2025 at 10:33 AM Deepak Gupta <debug@rivosinc.com> wrote:
>> >
>> > On Fri, Dec 12, 2025 at 01:30:29AM -0700, Paul Walmsley wrote:
>> > >On Thu, 11 Dec 2025, Deepak Gupta via B4 Relay wrote:
>> > >
>> > >> v26: CONFIG_RISCV_USER_CFI depends on CONFIG_MMU (dependency of shadow stack
>> > >> on MMU). Used b4 to pick tags, apparantly it messed up some tag picks. Fixing it
>> > >
>> > >Deepak: I'm now (at least) the third person to tell you to stop resending
>> > >this entire series over and over again.
>> >
>> > To be very honest I also feel very bad doing and DOSing the lists. Sorry to you
>> > and everyone else.
>> >
>> > But I have been sitting on this patch series for last 3-4 merge windows with
>> > patches being exactly same/similar. So I have been a little more than desperate
>> > to get it in.
>> >
>> > I really haven't had any meaningful feedback on patch series except stalling
>> > just before each merge window for reasons which really shouldn't stall its
>> > merge. Sure that's the nature of open source development and it's maintainer's
>> > call at the end of the day. And I am new to this. I'll improve.
>> >
>> > >
>> > >First, a modified version of the CFI v23 series was ALREADY SITTING IN
>> > >LINUX-NEXT.  So there's no reason you should be resending the entire
>> > >series, UNLESS your intention for me is to drop the entire existing series
>> > >and wait for another merge window.
>> > >
>> > >Second: when someone asks you questions about an individual patch, and you
>> > >want to answer those questions, it's NOT GOOD for you to resend the entire
>> > >28 series as the response!  You are DDOSing a bunch of lists and E-mail
>> > >inboxes.  Just answer the question in a single E-mail.  If you want to
>> > >update a single patch, just send that one patch.
>> >
>> > Noted. I wasn't sure about it. I'll explicitly ask next time if you want me to
>> > send another one.
>> >
>> > >
>> > >If you don't start paying attention to these rules then people are going
>> > >to start ignoring you -- at best! -- and it's going to give the entire
>> > >community a bad reputation.
>> >
>> > Even before this, this patch series has been ignored largely. I don't know
>> > how to get attention. All I wanted was either feedback or get it in. And as I
>> > said I've been desparate to get it in. Also as I said, I'll improve.
>> >
>> > >
>> > >Please acknowledge that you understand this,
>> >
>> > ACKed.
>> >
>> > >
>> > >
>> > >- Paul

