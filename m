Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BD81CAC5BB
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 19:57:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA9148E000E; Fri, 26 Sep 2025 15:57:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B81008E0001; Fri, 26 Sep 2025 15:57:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A963A8E000E; Fri, 26 Sep 2025 15:57:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9664B8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:57:47 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3C70811AC2A
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 19:57:47 +0000 (UTC)
X-FDA: 83932461774.20.E5A1CAA
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3DB8C1C0004
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 19:57:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=A6Qzr069;
	spf=pass (imf21.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758916665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zASiJDz4r3vYQO3vYDYkcyVx79ekhPk89WizJj5Iigg=;
	b=PJrm2rmoWmgvXISD+DZvAULTG+LvWRgbL0nDm1ulpzC7Zu7qSxji8mVxouVLKfAUjUozjL
	OYwEUh5GfJr11ipOXFsjiIaIF1rFqsymNcZ26Qvk4GPxvARCSija2Guv8azE1fKCAWTTgj
	KeP2A4UranaAFNe6wxfYpOqWrlXqCWI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758916665; a=rsa-sha256;
	cv=none;
	b=cajFPUH3RSEd9fXPPpQWZ4J/IIa2cW9Cn6oEpf6uQtaTe67tZNOpe5FLDOBqhf1XzcNUBD
	4j8PjNj4E7wUbvjHvGFUU/1KQwvCdYXD58tnzbH9w55mRGQQmERQ6heo+8N1rOMr+/fPXR
	EIHAcaOBUFcHwOkkCPSQ6U69L1k59CA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=A6Qzr069;
	spf=pass (imf21.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-27c369f898fso29094305ad.3
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 12:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1758916664; x=1759521464; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zASiJDz4r3vYQO3vYDYkcyVx79ekhPk89WizJj5Iigg=;
        b=A6Qzr0692vof7orptEazP5CycfcycYDU9kAjMOzY5YSZUC+RHBzJl+8uTkKfk/vgCK
         KHv4Mi0e8PdM2KB7h9R9WP/FcxtkYByF3N2QoJr6FJeOAX8AGNtJaUN8XpMK1CAhzoii
         lvMlnDsUS6lkIG1IUHEMCSEQmvufsp4weiHUxCmAGbJklgHUX+dazHIT/dI7D/JIxUjQ
         3FefBbzWN+vv/J7P7JFe05s+R0Y21LX2tGQVxluimrFUgRQOytx2dp5df1x4iMg3Ano3
         nTWtvXmyN2B5eVmJkD90Q6fBNNaoE0IuLy3Hc5Gri6E6f6Fimr0PScVmz9qkR+ROlAYa
         oTtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758916664; x=1759521464;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zASiJDz4r3vYQO3vYDYkcyVx79ekhPk89WizJj5Iigg=;
        b=YNBhRGmRuI7CqoWvx8uiHVtlcz2s43Olrvf6SutXlz2GPM44F9tAOZuIT9m1jYonKe
         3oiXoxIuDj4zatj/2qzvImkmRT/5x8vkr3chUo4V4MM32axfEtLrncp4IxBb6nv9mwBH
         9djZkPe/GloUe/L2IWZWbK61maIJLtFAxCLkeb0nTJ2HcUV5Z5Y+6XeKVqSPqWC6CVVI
         mzVnPJk3ReJbDIAexmtbAGjdAHtrxwyKZLwLUXqA6dG9Fl5xW1M4eYuHGOP/xTps1OjR
         6+wwsbWheocWvBPcE0aqfCo//XauphcidaSXkSvsGat+PKlaReuOaAIdVWeWxiSSzbnK
         pQeg==
X-Forwarded-Encrypted: i=1; AJvYcCVYkKSyqKm+yMa/7mAqqY4nNmO/oUWJIRJ/ydCBwqllTgFryb+47jGNs24RcGRZyAXs9JcVfU58PQ==@kvack.org
X-Gm-Message-State: AOJu0YztBod3sFdaEFlrWwpkcF7puRyMBYi+ezg7v/Q0qzTsH55SGlFb
	ui1RMb+k/uhPEzsxSZSHY7DBvQFWQ3V8v55SUDneIcv5DSyb8xKpKiBdlXxHCcnJwGU=
X-Gm-Gg: ASbGncuy5AQiBjLbdNljo7yY1o9q75QgYgKbJaBYOVOrs5kgts/amEKJVcQLIuamNQn
	ZfQ1t4EJB7DsGyBHexPyjck+x8L+R0/7OiRLTJ7v3g1l2yhlnI8NrfoSf0aiPFflpZ+9hUxw0BZ
	jlX9mAe2g+aAoqFauExJvqM1Z7hof4JUKifWqd2AQVIROHJv8LiBbS5AI5ib+I6X/Q0DCoCMxg3
	zNK1xkeRW9iKjib8GFAuAYGUSBsDJx4VjOwLZQ4dksjvMcIUP5fmBeWqKM5h9w0Tcta8EeJjOM8
	UMcg7ANT6rRu4JxCswf2Sc1n/sZuLobDn5sXbJTlyhqYSvQsrrXZYOvpHG3uydBKPvb8BWAucA/
	0idh7v0iZE8/qKpPriZFQrzqCxbl8jk6HHpuLiK8h3lADppvSsvztew==
X-Google-Smtp-Source: AGHT+IHlUtnIvbNYTp+NBwFL5kAnFfogcOgIaJtDWQxwNZ7YmExERR63uIq8FMCY+Zw0lEPHKpWKJg==
X-Received: by 2002:a17:903:28c:b0:26f:f489:bba6 with SMTP id d9443c01a7336-27ed4a5ec62mr76915745ad.50.1758916664000;
        Fri, 26 Sep 2025 12:57:44 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66d43ecsm62938985ad.24.2025.09.26.12.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Sep 2025 12:57:43 -0700 (PDT)
Date: Fri, 26 Sep 2025 12:57:40 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: Charles Mirabile <cmirabil@redhat.com>
Cc: pjw@kernel.org, Liam.Howlett@oracle.com, a.hindborg@kernel.org,
	akpm@linux-foundation.org, alex.gaynor@gmail.com,
	alexghiti@rivosinc.com, aliceryhl@google.com,
	alistair.francis@wdc.com, andybnac@gmail.com, aou@eecs.berkeley.edu,
	arnd@arndb.de, atishp@rivosinc.com, bjorn3_gh@protonmail.com,
	boqun.feng@gmail.com, bp@alien8.de, brauner@kernel.org,
	broonie@kernel.org, charlie@rivosinc.com, cleger@rivosinc.com,
	conor+dt@kernel.org, conor@kernel.org, corbet@lwn.net,
	dave.hansen@linux.intel.com, david@redhat.com,
	devicetree@vger.kernel.org, ebiederm@xmission.com,
	evan@rivosinc.com, gary@garyguo.net, hpa@zytor.com,
	jannh@google.com, jim.shu@sifive.com, kees@kernel.org,
	kito.cheng@sifive.com, krzk+dt@kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, lorenzo.stoakes@oracle.com,
	lossin@kernel.org, mingo@redhat.com, ojeda@kernel.org,
	oleg@redhat.com, palmer@dabbelt.com, paul.walmsley@sifive.com,
	peterz@infradead.org, richard.henderson@linaro.org,
	rick.p.edgecombe@intel.com, robh@kernel.org,
	rust-for-linux@vger.kernel.org, samitolvanen@google.com,
	shuah@kernel.org, tglx@linutronix.de, tmgross@umich.edu,
	vbabka@suse.cz, x86@kernel.org, zong.li@sifive.com
Subject: Re: [PATCH v19 00/27] riscv control-flow integrity for usermode
Message-ID: <aNbwNN_st4bxwdwx@debug.ba.rivosinc.com>
References: <f953ee7b-91b3-f6f5-6955-b4a138f16dbc@kernel.org>
 <20250926192919.349578-1-cmirabil@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250926192919.349578-1-cmirabil@redhat.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3DB8C1C0004
X-Stat-Signature: okajbcbmzzegeizwsnokfngmakkt1pz4
X-Rspam-User: 
X-HE-Tag: 1758916665-420205
X-HE-Meta: U2FsdGVkX185mGhBZ6RQ29+39fM9tkV0P92ZUV/nXctyvsdfcBSiNUeGNjDkBoVvx/zd5ReAog9ILotH03KrhoWCXXJPV365MTzYPZhBtPm1Zmc1I9wpg2qLkzszN/dhRjL/BrAnu6clohYafMmdxJA3nYgMII5LX0t7TAPSPmVsd7tK8DDRk9lwPqfKgu40gmC8+9us7ueZmuIRpLy5FSfoDE6WGPm6h7ZuTGb3DsCMJVqrlv8CnPzBp/sN3qsfMVuiSAzhMGcrxL9PgQA1BD33hpKN/StvaWXBfjZs/ZvmqBvJKV/zDOcVjFkEQVrUqwq2iBKWS2kM6XavphPEzcqCsCKVvGgFHS09GKYDEaTOhPxK1X+fyLkr8WqMer+9bb1tRhImFShnCl97Y3NPvvlMGDINXh4skXcNDed95+ZVJpCkokOMpWf78ZtXq1KWjtdtZ+dXAIHk5ssMapD37L+EnQDphEupnpCh/TUbTm5TY8nYBPr5npdgz50Z4c83AwRA7sZKMAnfP3DQH5oVB8sg/cF54KThLMlEj9VyAoOHi0QGuns+GcSSiiXpaGQYRXOBwiHLW6DTkCHE7cHLLVHEHc3YP+yt088qGNkb2vtFXTL1lZFAiUDVjTeqXQOq/1qXXRARAsvW33Oeu7S8x+WEed1Gvlc2YHp7lDg5BeqbvvKNDyUxG0LqEI7gVIpY5SzU+pKgIutuud6P156ogH3Qp30GHVjQFAmekBAUoNawu+WalDC5wfVEiTcwXdW8Ezyt3c6Z+KM2Ld62DxP6IpIck7yqqaXVgs8l/TBYD3exOO2bUx1pXggRer6AOuJYcgZGpoMvAZnQc1t1g+ARGNztK3PJs43XJyJ/0FnKTBMZRaycvP6tPHI+Y5AHmHrMmV4tECoaQRFUNMofjra16HcJ4wjJjw2movV+5IhaVV3tGJJF77qtksY11FAnqLkBk9k+7nmnxlAXpZvp+/X
 6VgJFHq/
 noDjHZVHDeUPjLav5JZxcZ/QQ5K5LxaTafJXUUHJV7c79x6uGYkqPslBaQgWGsbQlRwN4Jvb+WE079ySt6OsfmzcfhWq30z1S/ipYcrIbcnIsZifNMUzRPYr+ytHetohT+jLci0scsaLPuqBFCg2GVvr2/YsFjCxiWfbJW94/Nod05U7xIlHq1T/Fa6MWRXrsU/KKJy7+LUVP9SAb2i3CYwLfaRg3eGHunez42z4fNQLEECpiZULhq78+5l0TLE3M7I656gcOM5hPualBFykqmfjsC8qK6i5nk2bn3WXvqg1RegXxRCzW/RV/HVCAgHITRLY2pfdmA/8E2wWCVYgTLopw3GXGf7QqrQRdAMPgDFXTYe9ayhed7w63LwSMy9qzV6s+lsR4vmwWlzo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Charles,

Thanks for response. Rest inline

On Fri, Sep 26, 2025 at 03:29:19PM -0400, Charles Mirabile wrote:
>Hi -
>
>Hoping that I got everything right with git-send-email so that this is
>delivered alright...
>
>Wanted to jump in to head off a potential talking past one another /
>miscommunication situation I see here.
>
>On Wed, Sep 24, 2025 at 08:36:11AM -0600, Paul Walmsley wrote:
>> Hi,
>>
>> On Thu, 31 Jul 2025, Deepak Gupta wrote:
>>
>> [ ... ]
>>
>> > vDSO related Opens (in the flux)
>> > =================================
>> >
>> > I am listing these opens for laying out plan and what to expect in future
>> > patch sets. And of course for the sake of discussion.
>> >
>>
>> [ ... ]
>>
>> > How many vDSOs
>> > ---------------
>> > Shadow stack instructions are carved out of zimop (may be operations) and if CPU
>> > doesn't implement zimop, they're illegal instructions. Kernel could be running on
>> > a CPU which may or may not implement zimop. And thus kernel will have to carry 2
>> > different vDSOs and expose the appropriate one depending on whether CPU implements
>> > zimop or not.
>>
>> If we merge this series without this, then when CFI is enabled in the
>> Kconfig, we'll wind up with a non-portable kernel that won't run on older
>> hardware.  We go to great lengths to enable kernel binary portability
>> across the presence or absence of other RISC-V extensions, and I think
>> these CFI extensions should be no different.
>
>That is not true, this series does not contain the VDSO changes so it can
>be merged as is.

Look at patch 23/27. It does have vDSO change. Although shadow stack
instruction are inserted as compiled flag for vDSO only when cfi config is
selected by user. Right now default is "No". So it won't impact anyone unles
user explicitly says "Yes".

>
>>
>> So before considering this for merging, I'd like to see at least an
>> attempt to implement the dual-vDSO approach (or something equivalent)
>> where the same kernel binary with CFI enabled can run on both pre-Zimop
>> and post-Zimop hardware, with the existing userspaces that are common
>> today.
>
>I agree that when the VDSO patches are submitted for inclusion they should
>be written in a way that avoids limiting the entire kernel to either
>pre-Zimop or post-Zimop hardware based on the config, but I think it
>should be quite possible to perform e.g. runtime patching of the VDSO
>to replace the Zimop instructions with nops if the config is enabled but
>the hardware does not support Zimop.

Why kernel need to do this extra work of carry two binaries and patching it
runtime?

If for instance we do this, and then this allow this kernel to be taken to
pre-Zimop hardware, it is assumed that entire userspace for such hardware
was compiled without shadow stack (thus no zimop). In that case, kernel
should have been compiled without CFI option.

Just for sake of thought exercise, let's say Fedora 43 is first release with
RVA23 compatiblity (zimop and shadow stack), there is no way this and future
release will be able to run on pre-zimop hardware. Unless redhat is going to
start two different binary distribution. One for pre-zimop and one for
post-zimop. If that would be the case, then compiling two different kernel for
such two different hardware would be least of the worry.

Only other usecase is of a seasoned kernel developer or build your own stuff
in embedded environment, those users can anyways are advanced users. But it
forces complexity on rest of kernel. There will be more extensions taking zimop
encodings in future, we will end up patching vDSO and keep this complexity
while rest of the userspace will not be patched and will be separate binary
distribution (if OS distros endup distributing multiple binaries per release)

>
>However, that concern should not hold up this patch series. Raise it again
>when the VDSO patches are posted.

As I said earlier, these changes default cfi config to No. So whenever this
is selected "Yes" by a distro, they can drive such patches (if there is a real
need)

>
>>
>> thanks Deepak,
>>
>> - Paul
>
>Best - Charlie
>

