Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EC1EC83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 00:36:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 538D56B0088; Mon, 28 Jul 2025 20:36:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E98F6B0089; Mon, 28 Jul 2025 20:36:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D8926B008A; Mon, 28 Jul 2025 20:36:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E5F16B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 20:36:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A5C941A040D
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 00:36:16 +0000 (UTC)
X-FDA: 83715435552.30.925272D
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf21.hostedemail.com (Postfix) with ESMTP id AEEC51C0003
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 00:36:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=frJQN9WE;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753749374; a=rsa-sha256;
	cv=none;
	b=2Zkz8icfmqs+MwgPTo5BKNmWH50J0FvgqVJA0e/twzqcClhFx7c7ULscygaHHwwY1jOFoF
	+e8wiXslaKOgSPZVoKxs330OcO6Flk2tlAF7/3cE9gwA7uipocPCtbqH2TNHGZ4n9Mj85h
	qs+/5fOy02miZeQEs1ybs0Df7/UGscM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=frJQN9WE;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753749374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ETbDJbyMnJcJth9NSQ1EqJE54cIcDMP4wIxlGlnYcw=;
	b=L3MSiSkv7lkw52jyyGdIoTnfVIz8yDqQDHnwREHIfsa5V+cxoYmgnUYfYZwRFT+8bz5ABh
	UiC9OYaJMSouhw6fuT1z9eSVRb+90meZI6P6xiNdBhYzJPuuZHC/zh/Az7Usp29q3Q7kJ6
	rcaxzwxEmHvOwPd/oOwIrbhRJxE/eGw=
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-879d2e419b9so3505465a12.2
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753749373; x=1754354173; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/ETbDJbyMnJcJth9NSQ1EqJE54cIcDMP4wIxlGlnYcw=;
        b=frJQN9WEYYvcgV9t2xQAO1m9IgZ6k1BMYXQIYmSHHfZPSjyh4dfCOHtSIfxrj4cL7w
         xPOu3kbgWceHE2IOsXU46wHilJufaKzxmI4Vc2qdLpqeVuhdt/dyLPqB7A2UQgIxbExW
         8KquSzCf8Vqpy5C/vPTUMFN5M39DpMxL9mJn4nNraKIw/b3hXdfWouvIG38NE5wsoGI+
         2xlduSWz0lsKKa36N6I/B40/66sGic5DzZVSGGR7qgT5sAVK7ygaFpBmTajaFXUFjtvX
         qBr4ZVb9AlsbPPEosNHKVGjNSJqUpqaMWxEaAl0AF2gGPn6O1LGNqKcWlks7RRyx5nfn
         OUDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753749373; x=1754354173;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/ETbDJbyMnJcJth9NSQ1EqJE54cIcDMP4wIxlGlnYcw=;
        b=LweywQzKnSW2BmG5ix1OqCCwbK8hCFPGbRah4neY/mZ3FHX7TQEnMJjn0fZTynrReE
         BJrK6dhRuuR9LtNA2/zDY8/qvNxOhcvqduLZggdwaIwG/EJnaQXKZFDnPPhp+ldXoivv
         ngEDLGFLgJOkYWxKAivM75qROUsP4r+gJ39vr7Xo33PgCdV0PaRl2KzVOSAHRuhq72KF
         XaxLFeSzZz9iQzhH2ICZKK2Eh7giCIaLfsevROnRnc3CWAfkIGvVnjRSCda32sGTr/+S
         RvCVcCyeQLJBSEOq3ZzXLXH4HVttETPAN+ZJkU9Q7PmUfsDx8Q/747SdgetOjMlV2pOz
         ONpA==
X-Forwarded-Encrypted: i=1; AJvYcCXVl6iWjtF9WiU/0JFqmqldwbpi9ElsLfyzZCgfV4vwaqw7HyZcxk+eqZoVjBBCMR2J5oM20foe3Q==@kvack.org
X-Gm-Message-State: AOJu0Yw620xSe8R3LBtvDlny6yj21WvvExFwsfyBBWKCop52jCBB4Uf5
	rco0A/vKmg6Gphw29vgoLvsRA75YB9u5EMHTehX08dnXE8LKQMW4hrfCE9RAzU+Q9dDl2mpRIXP
	S8MAV
X-Gm-Gg: ASbGncvCVClPLfvp2bkHgW+tJW97gfxbrmM0p1o28x4iJITddz3MinIjZ5/mc8de03J
	kePDlQeW3eg0Pf6i8p9QWFIMqXvBmuWu/0vugaAt1GdB2UbuPW3G9u+1MHDvd6fEZSEp6p8IvLR
	b2SjR3oh6QrAKeeLS0eb9dM4enc7qd0QmfTrORVmr2Ga3vLDbuOvJtFOM1Kh5kg1BTJ0SFTine5
	L5ZBPTCPeIw5sKtv/iiikm7zE8wBLc/MR0YWCZNIBn12qKjecoPv0KbtVW8xDoIo6iuu1Es8c5U
	fWMTz0uuqS81LPJHrOD7geAC06lBPKShN5GMGoRN8WasG6eQ79n/cRr1eZ0pi2sNMk/5J5RaWaL
	DLZIwOHJzCUlhM6vnAlN/7mRS4Z1ZB2/1
X-Google-Smtp-Source: AGHT+IEDJXqhf7DRrajAJZBJ8vJ6pYcfACWj1AXTIy+3dQeFkQYCW4S8o7ad1lMROev+GL8TvcTWBw==
X-Received: by 2002:a17:90b:1b45:b0:311:f30b:c18 with SMTP id 98e67ed59e1d1-31e7785ee72mr17793124a91.4.1753749373373;
        Mon, 28 Jul 2025 17:36:13 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31ecd1f0e80sm4264442a91.18.2025.07.28.17.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 17:36:12 -0700 (PDT)
Date: Mon, 28 Jul 2025 17:36:09 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Monk Chiang <monk.chiang@sifive.com>,
	Kito Cheng <kito.cheng@sifive.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
	llvm@lists.linux.dev, rick.p.edgecombe@intel.com,
	broonie@kernel.org, cleger@rivosinc.com, samitolvanen@google.com,
	apatel@ventanamicro.com, ajones@ventanamicro.com,
	conor.dooley@microchip.com, charlie@rivosinc.com,
	samuel.holland@sifive.com, bjorn@rivosinc.com, fweimer@redhat.com,
	jeffreyalaw@gmail.com, heinrich.schuchardt@canonical.com,
	andrew@sifive.com, ved@rivosinc.com
Subject: Re: [PATCH 06/11] mm: Introduce ARCH_HAS_KERNEL_SHADOW_STACK
Message-ID: <aIgXeRDXNmOozRWp@debug.ba.rivosinc.com>
References: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
 <20250724-riscv_kcfi-v1-6-04b8fa44c98c@rivosinc.com>
 <aISGypOAaDGaUZgd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aISGypOAaDGaUZgd@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AEEC51C0003
X-Stat-Signature: yzq4jeyur1h5dw1sz6qfxoeiib4jiyf6
X-Rspam-User: 
X-HE-Tag: 1753749374-315727
X-HE-Meta: U2FsdGVkX1/OxJ8SyztodM6bIANVdSotsvf5u/YM4ZVHT+fAa/2CiMg5712KK/A2FJrc2NXcxMcXFYGIfE0fCRH5gy97NvCtYKTXtpV1FrFMvuCJs5/s9365P/jpN9ZKlvr7dJB0yWAsVOJy2IQUGooXDW4rMvflqQkzCETG0y2hz68RZyQUBJf2a04sh0aFHX9ViU/P10U15Va0vvN0v3a7EyTg7aE28gPsa84SV2FbWUGJzTlkLZC5SFu5NtCOOVpebzBrdxnIJ1h6ZgBO3tKGTbFQC/Gv0fQXyCBXoB2m6deZtWDaIF1FnEBnmXmF2l5NmtmCPxDSBqN98qvrOxdm/Nxn1kvaBOfpP61u5YEQo8anuWpdeBuGeM0pom7UcWPZOO/6fJVzNRHWecl/WsIaLxDjLbFLDht/UfwAHJPlZTyYz8XJsFgmywJotfyOLBSGYFh8eOi19J41nm8m1xU9dZnzxeiMjtg+TFNEFUv2k4ezpUrOz/sZN4s0zNLEsk29yF7zNB0eIGPT3mCOBPyrV8crQRAP2fgKUUjsL9UnmvYj0rrxX2wwjJFnYOHErqgDt9edXQRDIUlL5ylGrVB9d8tUQx64zselWrYQhcKAJrjj8TNbTzFFuogS4NVZOcIa3RWLAV4hJrfjxZtDdPf9HUpFaRaqbv+8pmcQomNYXRr5gbdT5ArMyNTg9Sw8Ifg9wNFjway4DQlPCBJmSuvRDMjP/GzeGTBct0xj1q8rPvA52i2aACO1hNyRhH87LVb4kkOOeHAwtiIiPbba1sHY5l3aAe6YzKOih3WhUdqUxUFuugUVwpXw1X842OiMCbS+T25CYL/FGea3/w0pOINy3cMEs9urVqUE5iT0TddYxT/TFltl7oY7NlTEt06XEiav118vI1E25VvOk0sL3VUyRbkvJHJHafmWM817o+0bGtdlrOEbL7j7S+3dycFBqw+rxDPwJlpVDLrmiVt
 oMTHOpdT
 TqFAJ5m2cS4hw4aUnvrfAoEWeQPd3nRwPDW8jJ9lvmQ5osNqOhMxuNIhwWToeFqyASpA212rCuFeZufPFVHYJWqBNTTmn0tgYGPzDOTzPlUzMVnweGl05kdVAbJo1X9wmWNwxXRO06ndmJsLsqgnbbL3xBgQ+pfjHJx7aHS8UyG6gSv+L6lM3dJ1HFs/uks0pS/IcvY9h4zR/VLv4ifpDx6KjkkehBzi50mLcbwy0bc6EdZWm5o2iWDwp+8VMUeVx5Ew/3FKC25Wn/Z7HC470ifm2iScNFwOjq81G2BIeSzth3yQVIXZdhos0EczFebNViGo2AbsK3xLc4SjLEro/4CR/XesLJ8dVOKpKP6XRmDvRZdUSDy2yBUuMkqd7YRJp2moSUoZvLEA/lK/MR2hTGDW6xbkfzcCqxTcFeKLvHBHzQ+fgHqPZkjyazX1ixvRoLwtB79e8ZBW5T1Ue1W/EX+Oez4KXpcUeVJZpjfdVNxbi9Zp0sfpSFMLnNL1jqQE60lp++i2JXeu/sAYg5os3vWVSMy+j4mzQQrmyvWHp4oaGKHksU5/uYx46ftvGZ0XzIDyq5PqGHqxB7cg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 26, 2025 at 10:42:02AM +0300, Mike Rapoport wrote:
>On Thu, Jul 24, 2025 at 04:36:59PM -0700, Deepak Gupta wrote:
>> commit bcc9d04e74 ("mm: Introduce ARCH_HAS_USER_SHADOW_STACK") introduced
>> `ARCH_HAS_USER_SHADOW_STACK`. Introducing `ARCH_HAS_KERNEL_SHADOW_STACK`
>> so that arches can enable hardware assistance for kernel shadow stack.
>>
>> If `CONFIG_DYNAMIC_SCS` or `CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK` are
>> selected, skip compiler flag `-fsanitizer=shadow-call-stack`.
>>
>> Signed-off-by: Deepak Gupta <debug@rivosinc.com>
>> ---
>>  Makefile   | 2 +-
>>  mm/Kconfig | 6 ++++++
>>  2 files changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/Makefile b/Makefile
>> index 35e6e5240c61..7e3ecca9353d 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -987,7 +987,7 @@ LDFLAGS_vmlinux += --gc-sections
>>  endif
>>
>>  ifdef CONFIG_SHADOW_CALL_STACK
>> -ifndef CONFIG_DYNAMIC_SCS
>> +ifeq ($(or $(CONFIG_DYNAMIC_SCS),$(CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK)),false)
>>  CC_FLAGS_SCS	:= -fsanitize=shadow-call-stack
>>  KBUILD_CFLAGS	+= $(CC_FLAGS_SCS)
>>  KBUILD_RUSTFLAGS += -Zsanitizer=shadow-call-stack
>> diff --git a/mm/Kconfig b/mm/Kconfig
>> index 781be3240e21..f295ea611cdb 100644
>> --- a/mm/Kconfig
>> +++ b/mm/Kconfig
>> @@ -1367,6 +1367,12 @@ config ARCH_HAS_USER_SHADOW_STACK
>>  	  The architecture has hardware support for userspace shadow call
>>            stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
>>
>> +config ARCH_HAS_KERNEL_SHADOW_STACK
>> +	bool
>> +	help
>> +	  The architecture has hardware support for kernel shadow call
>> +          stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
>
>nit: tab and two space for indentation of the help text

Will fix it.

>
>> +
>
>I think both ARCH_HAS_USER_SHADOW_STACK and ARCH_HAS_KERNEL_SHADOW_STACK
>belong to arch/Kconfig rather than mm/Kconfig

Do you want me to move it?
This basically means that hardware shadow stack is supported or not.
It needs mm support. I think thats why user one landed here. I followed.

If it impacts mm, it should be here, right?

>
>>  config ARCH_SUPPORTS_PT_RECLAIM
>>  	def_bool n
>>
>>
>> --
>> 2.43.0
>>
>
>-- 
>Sincerely yours,
>Mike.

