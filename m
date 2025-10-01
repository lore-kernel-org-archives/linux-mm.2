Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C0F4CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 00:13:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 495C48E0003; Tue, 30 Sep 2025 20:13:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 446948E0002; Tue, 30 Sep 2025 20:13:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30DF58E0003; Tue, 30 Sep 2025 20:13:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 197DE8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 20:13:29 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 74EA313BED8
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 00:13:28 +0000 (UTC)
X-FDA: 83947621296.20.4AB81EA
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9808B16000A
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 00:13:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=EdFazZr4;
	spf=pass (imf08.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759277606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CUsbmESiNHTapnE6rmxwHkpYC/VK0QzGDUHHcofE4qs=;
	b=ApSO/cQhmVEG9TbMBeFMGN5my6lJObpsgMLTGfIkSnNYqlHAW+EI0/rRaG6TmvKSVhftJK
	+sJIxqwCE/FHkiSpUYN18hNndiE86Bq45N6oszn7TQGN1MkIK1O5bq1dMxkOSpGUNVZtLe
	oVDTH70CJZG9p38MEbDG6LwFGGTe/DA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759277606; a=rsa-sha256;
	cv=none;
	b=dWmHaaWxJmQCq7Sw2h++rYzZgZB9GARoitlWthgbbNKrANnjdaVMcQSiCGEQcIYB2svqe3
	0zMCxo1bxEVsa1/DTYFKe3sFA6qxEiN2bESR+8C6HHWiCwjb9vAUkukl4P0dxvEn/AqzC2
	Kz+h+qTTcE/O2oOBj8aM/PIqxZcxmi4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=EdFazZr4;
	spf=pass (imf08.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-77f605f22easo6027877b3a.2
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 17:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1759277605; x=1759882405; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CUsbmESiNHTapnE6rmxwHkpYC/VK0QzGDUHHcofE4qs=;
        b=EdFazZr4AVqyGA5uuBuVNUpudV44Bn0mOf9XZrhCx2XdBNfOS85LcaywVHOa0LkGSw
         bTy/fG/fyY+2uLgsZ7Wvfwj59L7693A9QoGaCNyUT3g6/f3w/Wu3sSr3ku1SOjO2TRbe
         N/rxYQljdckqFJKqE+OKQh/ZgHzWmz1e1ahylO/vb9bpmCybTkxjVN6gtdXw0KIud82j
         JbCsYsMybBy5fuhxCLINttQkCyv1ZMwi7CGz+0xJtwBfMI6WJkLRQV+gcIsWvuj2ptDE
         ffAcb1FD7IOPI2Lvv4/BPb1eBpVlRrmTYUmfhntdMTkQibMHB6vrQ0V+rGbO9VPSMTIe
         4pIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759277605; x=1759882405;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CUsbmESiNHTapnE6rmxwHkpYC/VK0QzGDUHHcofE4qs=;
        b=g/iedn51daET5dyIaCfSM8V0szcPlVWLbdsoZARMs6KHTeri1s57fC2HW++RyOvmMV
         q5SAjO92hUW95k3mZRUwMpzwhyYG26f3AGd2GKi9UlokU8NNe32xwHhwrrsZ470HCt+7
         DOYWqHAhAN4bxUlIxpCmE2CStZQ0hCbQ2lxPMmJoXf7JFEtdHsR3I0YR5iT8YavpMcgO
         fJcWdXaf6sS5k2Ttk5E48KRmOGFA7jO9BetRuW+CQVC467THehb8919vKli8AUFv/umz
         JF3SGKq4AmSCKJacJLTLI4be3Wko318qYPJisBwgZZXFNB/nFPy1qsHWM7sgs+lVqbHU
         NlWA==
X-Forwarded-Encrypted: i=1; AJvYcCVWh8SvDRoiVNwzBNCRaOQfH7bKbbvNJ1kZd524+TTBm+3q2qkDSWCDMh8gQMRzeFnUFbItU5a/YA==@kvack.org
X-Gm-Message-State: AOJu0YxCpttkI7cj21ZyY1+MBKOcihFMPYr1jF1QhW+t3NjC2+HmO9m1
	ohcDXmNT3KfhtP4TKrfD7Y3OUI2p+DvRsaSvYITWsBAE5xkKJOtIrLY9n5EvToj0aI0=
X-Gm-Gg: ASbGnctKRYflxJimizAplC5aRxOXO+97FPBYi0eUbXFrFjf5zaFAGb4x/xHUICbx7k3
	ghhitjiMduzkbI/ZpfbYYQNqAJ5io8YXWb+mPo4niOuqaNOr9xoPS59EtWSWzSY8R9tsxzNicjj
	BORJOeARPgK7N7jNYnfi5NeGNdMucCtAX+/Yq9cEsV2O5fUhvZ1r2I1a8wavadx/638roxZJuOT
	vpNqizQ/GqxjtQhB/HDqll/puXWqH3eWsCQE7YMZaWK0J2qRSY6RRIJ03teNyvPMkdCx2S811ax
	wWoESq6QJDB2StOqwwhBaTeuot26vO9uwA8MD96fDxFHSmHT633vdm164NCQV7AznE8K/Kr18yl
	+oOUZ3YwvwYdaohgijbRGecQOu0TyzqwxUi2AExDXDDp1KwgT/454wgsQ
X-Google-Smtp-Source: AGHT+IH1ajiur2VZSdi3/i+zRO/0+860zWmY2Oc/Oh+OdPF2Hx4MVy9Glo++QmHnaPr2yVoYd0LYtw==
X-Received: by 2002:a05:6a00:3d51:b0:77f:2f7c:b709 with SMTP id d2e1a72fcca58-78af404c9c4mr1324097b3a.5.1759277605281;
        Tue, 30 Sep 2025 17:13:25 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-78102b64599sm14805168b3a.70.2025.09.30.17.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Sep 2025 17:13:24 -0700 (PDT)
Date: Tue, 30 Sep 2025 17:13:21 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: Florian Weimer <fweimer@redhat.com>
Cc: Paul Walmsley <pjw@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
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
	Zong Li <zong.li@sifive.com>, David Hildenbrand <david@redhat.com>,
	Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
	bharrington@redhat.com, Aurelien Jarno <aurel32@debian.org>,
	bergner@tenstorrent.com, jeffreyalaw@gmail.com
Subject: Re: [PATCH v19 00/27] riscv control-flow integrity for usermode
Message-ID: <aNxyIeVB8Rjsu6wW@debug.ba.rivosinc.com>
References: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
 <f953ee7b-91b3-f6f5-6955-b4a138f16dbc@kernel.org>
 <aNQ7D6_ZYMhCdkmL@debug.ba.rivosinc.com>
 <lhuldlwgpij.fsf@oldenburg.str.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <lhuldlwgpij.fsf@oldenburg.str.redhat.com>
X-Stat-Signature: dhemfm5scdhkto1ckz7qot7ock6a37se
X-Rspam-User: 
X-Rspamd-Queue-Id: 9808B16000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1759277606-490312
X-HE-Meta: U2FsdGVkX19SNuY+Qv07GXBLgqdimxY6eSS7efP9nsAPlr0j1bZc3MYkZ/utfzTrNLxWbegwMkyDMRXW1A6Gxt/X0o4hnHKQTM+7STbbHdyPNw7HhVoYbs+jttQmblNiW7MzayR8ng7hLgLBfAsCxmuJ650v9fYltgVQR/Tgn/Xom34hAsWOfsuKfJmK9gtVaJ0JsCJPnIyRn9BT/WCCfb4tvIapaamdDsyuH9fFEthiemR501T6UA4mQ5WZA2P2mrWkr8QRkMDODLDPlfn8VzmmzTmB5tK+fiDLVhovCwFwlW0x5WH/AqKWxw+UlIt2Jow4T1GSmC5vTTDxdZKtGfy/p6ImNYQTJdDZg9k1OEC4gj3bLaDnQD6G0avd9kghdfCzuT6ZACCkU3C56/ot8vO7/eKFB1Zjhe4APojWrUV5dUQ+Af16sr53EVb39NvXN/+FV3kyFdn1MPO6P0P4/tirz7v9m9yjZvLAJxzYxKX3lnREt0JJtL1AB2drZuZGy8OZgkkGu71XF+4okXrm+pFJzkxRjYYM4H4hPiyYwAqUo+BTxY0Jt22uWhn9v4/neVthk39voGx5MdV/Kwo2pPu5vcP4C7v173Z5XULUBZHVuc99/PG7iBMUxYlMqTTRjH3RWZZeVlQD0BJS/3HEnFUb171R07Tkwo/v9Uyqv7gIHqN9jBb10ZrAiOa63XsNY35SCCYnMARN6bY2NDHTnFj6zOoEx7dtxrwZ3rP7+1WxWtVX9qHcY4fdNZMWpsRMX4XXYncZzTcr6evepzA6JeWYawQH9GQpJduQ0kz4yiUR5pxARhLXREDS5OBLgqUtNFHCAoVeOH+ru3fMuiD3pYDJtCyFto2hlh5zcxVaqt9o67GwzD1SI7YZopxCBLsEZW8nwQSujbfo4Z2WtKhvqLgt0CspoLAUfXKdXjMO1+F5KyXDrBUNibp5nfczjXuqod31lZnvXsJO9wiKh1S
 QmUSQdvQ
 2TogjoOYVlWNLSvF6xVgykgQ0AJo2hgO+htEjzqvb4NctzCNqGUkYc95m5o86q2nTQZterxORIjVN9yq+VKhqrY+pXBzfginSVaDLZPFBqM5DRsAT1muyHKYksrJFTACGfMQBzSmbzwBWu1NwSIIrXokrrL5W4/0Ja+dgd61amZJgIl9t4H1fXF0+zNqCbL4SKpBXAdOovCVCHypnjl2/yCWnRcN7QA2S/gMJZPwWbNuJ3ZocEzIWoi1VF/mXZd8Xhh4chbS6yN2UsB7EQHvDGEHI5zgtNtgLJrfeHtntASEv6M81oEgNFFMI73AJtregBxyHvk7qEwpsh2zvl1drIfo26J/B2jPTtIDMKQ9u77kjxGLUmCO9EAWuGVj8V6YYtc9UgZduPAuQRt8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 30, 2025 at 01:15:32PM +0200, Florian Weimer wrote:
>* Deepak Gupta:
>
>> Any distro who is shipping userspace (which all of them are) along
>> with kernel will not be shipping two different userspaces (one with
>> shadow stack and one without them). If distro are shipping two
>> different userspaces, then they might as well ship two different
>> kernels. Tagging some distro folks here to get their take on shipping
>> different userspace depending on whether hardware is RVA23 or
>> not. @Heinrich, @Florian, @redbeard and @Aurelien.
>>
>> Major distro's have already drawn a distinction here that they will drop
>> support for hardware which isn't RVA23 for the sake of keeping binary
>> distribution simple.
>
>The following are just my personal thoughts.
>
>For commercial distributions, I just don't see how things work out if
>you have hardware that costs less than (say) $30 over its lifetime, and
>you want LTS support for 10+ years.  The existing distribution business
>models aren't really compatible with such low per-node costs.  So it
>makes absolute sense for distributions to target more powerful cores,
>and therefore require RVA23.  Nobody is suggesting that mainstream
>distributions should target soft-float, either.
>
>For community distributions, it is a much tougher call.  Obsoleting
>virtually all existing hardware sends a terrible signal to early
>supporters of the architecture.  But given how limited the RISC-V
>baseline ISA is, I'm not sure if there is much of a choice here.  Maybe
>it's possible to soften the blow by committing to (say) two more years
>of baseline ISA support, and then making the switch, assuming that RVA23
>hardware for local installation is widely available by then.

Yes that's totally fine. Distro (community or commercial) get to decide.
They aren't forced to make a decision of RVA23 switch. Question is about
"Once they switch to RVA23 on say release `A`, will they build release `A`
for non-RVA23 as well". 

Once they make a switch, I do not expect the userspace they're building
to be able to run on older hardware because it'll have zimop instruction
in them in epilogue and prologue.

Sure, they can keep supporting older releases, keep building userspace
without cfi/non-rva23 and thus they should be building kernel without
cfi config as well for those releases.

New release (RVA23) isn't expected to run on older hardware. If new userspace
is not going to be able to run on older hardware and new userspace isn't
making an effort to have runtime selection of binaries depending on which
hardware it is running, Is it worth the effort to have two vDSO in kernel
and expose the one depending on which hardware its running? It's just added
complexity for usecase which I don't really see a usecase.

Yes a savvy kernel hacker might have a need where they want to build a kernel
with RVA23 and transport it on all kind of hardware but that's a very corner
use-case. 

At the very least this corner use case shouldn't block these patches from
being taken in 6.18. Current patches don't block such future capability (if any
one feels like this is really needed).

>
>However, my real worry is that in the not-too-distant future, another
>ISA transition will be required after RVA23.  This is not entirely
>hypothetical because RVA23 is still an ISA designed mostly for C (at
>least in the scalar space, I don't know much about the vector side).
>Other architectures carry forward support for efficient overflow
>checking (as required by Ada and some other now less-popular languages,
>and as needed for efficiently implementing fixnums with arbitrary
>precision fallback).  Considering current industry trends, it is not
>inconceivable that these ISA features become important again in the near
>term.
>

I can only be optimistic here and hope that enough ecosystem adoption would
prevent such breaks in transition.

>You can see the effect of native overflow checking support if you look
>at Ada code examples with integer arithmetic.  For example, this:
>
>function Fib (N: Integer) return Integer is
>begin
>   if N <= 1 then
>      return N;
>   else
>      return Fib (N - 1) + Fib (N - 2);
>   end if;
>end;
>
>produces about 370 RISC-V instructions with -gnato, compared to 218
>instructions with -gnato0 and overflow checking disabled (using GCC
>trunk).  For GCC 15, the respective instruction counts are 301 and 258
>for x86-64, and 288 and 244 for AArch64.  RVA23 reduces the instruction
>count with overflow checking to 353.  A further reduction should be
>possible once GCC starts using xnor in its overflow checks, but I expect
>that the overhead from overflow checking will remain high.
>
>Thanks,
>Florian
>

