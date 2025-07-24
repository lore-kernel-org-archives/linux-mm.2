Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DC93C87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 23:37:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1D1B6B035E; Thu, 24 Jul 2025 19:37:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCDBD6B035F; Thu, 24 Jul 2025 19:37:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B95086B0360; Thu, 24 Jul 2025 19:37:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A0D1C6B035E
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:37:08 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3E6E2C04CB
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:37:08 +0000 (UTC)
X-FDA: 83700771336.24.25580AF
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4E28AC0004
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:37:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=BdbI1Cnw;
	spf=pass (imf10.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753400226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=C+gXzIdU61xINYweA3A+NL6d5ZRp4vso9nWy72/uM8k=;
	b=dAXJ+lrG6ip25snLDNTtx2PpAi6DHau9OVkApesibZXjR4HCosnB+HRDxHndtJikDJdC5z
	LowLvAV/oiiiP/BclOTxEfvTAUvTbQHOHN1F9ydPw6hGfvEn4/wL3+8GtiRf1Q7pwZ1dsl
	wfbLpPSJovLeuqdMZliWtnpPy5eO4Yo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753400226; a=rsa-sha256;
	cv=none;
	b=ZMcovAl+Hlz02ZDqH1mwC1TGe/S5tIMzueCRXfgdruXcceEjJ14U7tEJrWpMRN+gj5ji0t
	FN9H01qvX2LhnQeATXI30fZUR6nvtftU44ikBMDAVhapYoPA0SMkBLYzBGwJTWVYlBnJZQ
	xbIbNpr89MViLq2AM3R50D+XBW6afVI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=BdbI1Cnw;
	spf=pass (imf10.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-23602481460so16012325ad.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753400225; x=1754005025; darn=kvack.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=C+gXzIdU61xINYweA3A+NL6d5ZRp4vso9nWy72/uM8k=;
        b=BdbI1Cnwe+IqoBMDpyv2XH1BRnxvEfivZ1gr52UxJ4XAwPDJF3WuufWjgLZpfokW/C
         ytTJd9jc/7/PALVVY8lTpQfVhJj8iz4qBxr7DiqriO1OBLjXqtVwQlvhicyLRz/cS6qS
         rMEde9AHjzbxSxQB31LZiNvhFPeoTvoXh3qKpz5mtfwbvK6UiaTDzu/Nf1u5Reu+z+GN
         bUT3s31WpKrgFjrX/abbI+GLzkNcpARlg/z+fkNN6BY2MhzyIIZxn8tiDzHYBRg/1Wp9
         0Iedyqkrb0xRPPhUuh2cYUytLS8IVScGMnJi8HBr7re6NUuldNm2vHMI6sqkBQSYllo5
         Cg7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753400225; x=1754005025;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C+gXzIdU61xINYweA3A+NL6d5ZRp4vso9nWy72/uM8k=;
        b=H3AR2Zsq0j8ZAkDnPE6ZIUHlql3Y7oGaW71CxwmEHSxHeFInmn/bHq9qLVL6QZx0yt
         YvwM+5WbCy5ixrBBRVQazwBHyFQV8SXUjMJ2e//K2rpLYMsEZWjiMq5+C299rEKr9IN/
         KQboR667smAnmqKDXYnRc59NKaTqwqqqBgyWrwJNYM5IArPQrWEOLyPNeNZd4nyD9VNl
         DTt/xE7mY/DiBejgr+umTR5atcSIWE20JOS7QTMGRhFpT7Rrng2amBe3TSIFNVWsWTZn
         exGmttlvBqDhp42+XriwbD8HqmGiqoJLezVjpDLRuAVShJE4bUB0gUy5HWTO1zOO8xq8
         R09w==
X-Forwarded-Encrypted: i=1; AJvYcCVUT1TLg4EJSJMzh9U1LuRur1jV+V0CX3XcaUDkAlTwzAxScoReMU9pyNDG5C6H7ncj5g+8ZvKFxQ==@kvack.org
X-Gm-Message-State: AOJu0YxRJ3jmSACEpYBxOrGvKloX8PqCEDLilN6etU5pFHus1Rtz8BMS
	laitP65CLPVzXOY2fUQ71dCPG1jZRj0HV+GLNn71wyGFy94GrA6mNYNvFhsWYJbbclA1pdlb7iG
	ifgoG
X-Gm-Gg: ASbGncv3n1QkwVUr9xUx0kPwpw1PUuqk9hog4xtDLTKQe5sOvTN4ankKQrYI6vrXuXA
	aRgR3OPhhZkl4MLyPv+oiZJB8YhMACaK68Gq9XAT6kbWo/QywXbYNMrVLMlECJ8IBHSGtW8beaF
	eYXxfsSB0wfdzzNB6MQpbAtYWgRiuwo1nXyhTJlQdfUsStvsvD3ngTfWtKD681y8y7ViEGWv6Kl
	2gW8U+fXXn3Xp+Nu80XsQQtw5fhRU8Ex5HUByoYRXZZbLJHobZsUXmlOxnslgICD6I6/t+U1SYV
	PcaSaeEdH4SHhzUOWQUHbc7CFQ9Bi8uKEgMMGgOMc6Yu7FGVA3ovn0bEel3gU6ZCAKJriQLMY5s
	DCtSSsZgwCMZ9dsc23orMS1bBWadS6yPg
X-Google-Smtp-Source: AGHT+IFr7l7kjkqrXt81vLsMKucPZmY9zD/JPe8FlvG5PsYFoAY8mYZhkhl/H2Tn5r65e1Axf3ZuZg==
X-Received: by 2002:a17:903:1b63:b0:223:653e:eb09 with SMTP id d9443c01a7336-23f98161f8dmr123171695ad.7.1753400224864;
        Thu, 24 Jul 2025 16:37:04 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fa48bc706sm23598685ad.106.2025.07.24.16.37.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 16:37:04 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Subject: [PATCH 00/11] riscv: fine grained hardware assisted kernel
 control-flow integrity
Date: Thu, 24 Jul 2025 16:36:53 -0700
Message-Id: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJXDgmgC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1MDM0Mz3aLM4uSy+OzktEzdNAtTw7QkI0Mji6Q0JaCGgqLUtMwKsGHRsbW
 1AHi6z7JcAAAA
To: Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Masahiro Yamada <masahiroy@kernel.org>, 
 Nathan Chancellor <nathan@kernel.org>, 
 Nicolas Schier <nicolas.schier@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@redhat.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Monk Chiang <monk.chiang@sifive.com>, 
 Kito Cheng <kito.cheng@sifive.com>, Justin Stitt <justinstitt@google.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, 
 rick.p.edgecombe@intel.com, broonie@kernel.org, cleger@rivosinc.com, 
 samitolvanen@google.com, apatel@ventanamicro.com, ajones@ventanamicro.com, 
 conor.dooley@microchip.com, charlie@rivosinc.com, samuel.holland@sifive.com, 
 bjorn@rivosinc.com, fweimer@redhat.com, jeffreyalaw@gmail.com, 
 heinrich.schuchardt@canonical.com, andrew@sifive.com, ved@rivosinc.com, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Rspamd-Queue-Id: 4E28AC0004
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: jxzsczz5sdxaizqmab6usnatkwasydwh
X-HE-Tag: 1753400226-611946
X-HE-Meta: U2FsdGVkX19a6bSU7UXIVJ9ZGcaaHCfBjmKpFwQsgF9QTm/RtBrQc9OuuAx161RSd6ERGZJd/I1lsFk6VtQIECN90JRG/esiYQHi/6xUf80DIuUD0kqntUui/6FkiRJvAv/q6mt3UXkHrEqcFOM4nQV/Uxzij67AfsHWIVN24nkSsNc398jg2jssLTmcNukPI5ZzVuzM8KCgPrudvDdc9M4pzuciQywLqh37/X9CIsHD34uJxEWpwha/LpMG1AwTNKncDbumMLFxwDNGN/KDM/cSZw5wJJxLnR1G1bXxS/PnlBbeeJ3kyEjJaRDeDHTv2m2hKUnyLujH1Xow3jedHlMXvprbu8sp98MTEMlwLTORcSPxCAzYDzQ14esB5o3jgKi7wWWZ/X9PHexPZpY5CVueaQCijN2dnKvxRqn5nEJoETpQbd3XQJoxnRsNgi7DYQZdcIKMGX5BaIJi5ZQ7Ro0H/1mm4nmTwyOomiA3OTsvs/7o7XFpeSDTtztTHDc5EoFyaYliLcWp74iwtW3WO/Y0ClsYt9OSJgzFSJaTo2HB5u+sQsx/4E+mayaG+M067K/y3/1rzIHIW4jDbk6Ow5/jiKaUj/sYzZs9/H/Be8+3SQ9TVXAZKmTahYVWNtoApWsOMJP/Pq61JD4pu/PjdUHCeUP72qtYQ01vE0WK0iof5eEb1J+9h3DmssOI2jzXRVcGaI6+nfEuIhrkvR8tOIrGWjeIuOo2Q6a/YCCQnGW9oDP8PRtwC6iMH77nJJyrq9C7kEFp55CGVJTt3b0jZw5A01oz5k+Fdj7c1dAzYd/nnsMfE8NLv2fMM4G9UFLRDpMtuR3WSI8ObPYiaNH4yob7KArgygsWwnGqH3RPBQ1wzYDrTSn50aesHbr1xfgWGc1M0WBzjH7+6AlXXRSlpGJO/AW1vB9biTA6Cocf91EX7Syxz4ob4UWqw2f8fYyWCZB7tStmQbsMlGdyDdX
 QAGvXJmK
 vV0N3m0zKEX2FBkvDfpzGUnmh41l+zZLeTWjm3ZeG22t+/ZlBt0HTypB5gX+870Ew6uzwAGvrCoVKpxCfr7Ze0aDvTZayw+WsXPfZ0IRpd69zF8fUmO1xLq0fDUFhTGrK+rkiU7COhh9V/5TXQVfuVC0nN+MtMh92ATXQCKRvsCipngvWQYV4Xq79GdgOlTeBZJI4GqsZ3xLCpDOueFPMpOOevf/j1B0SVrLJcnqaMQ21IYqD0cH/tOG6dM23BkEmVZNqpyJQrsUJTnY+JBzOdQTMKH21jYH5PGx8EcAptyW4cjkZK9ypS/FFwZJk7Sw5dDp2jG/sJ6kteTZufpqGOXa6pf/rasVagYbTjsSogV48taxzoejNYTWooYL0Sd6qcFv1lRK+uGJIO1QaiQkLHSsNk7M3/zZ2Q0InQipniRmevUB+4lu1oKNFCvHCmumorcT3XVlJYVgDExBx/T5Zcjoz7L4aK64Pl59xiGd2WAviyGppKjaWJ5Jq9Ewg86nwzM3AmQhXQT2FpPPzEYqNsevRK/QTlP6/SlQsuFCSusHMN6AKPmPSghtx8J7YAh+59cfJCwsN1TVTIWac8yA8cwsjIQcT+ZZIHquHckaouiL0wrg7fI+3nV0vb3JR2bG+yQgpZuLI2yyvhxi9zDgrtsTcUQ1rsD2NiBrZgcUVI39qGo4Tgkb7VwbE57co/AKzxpxLqwn2xWCWKG0F91IHLf+RacYwq3DNQRWv5LjADtnOQOJ5ZSIBQ3EhS/anFH6gl/C/RR2AwYRQJBJ2ALl7jqrMxrSL3p8h4svPrRHXo0533oJF7soVTpZmg2NATYYo+Te8MPm9A65Pnvla7d9ompB+FYRrSQjTmhnvrXzc1mS/S3zrkkfplBLa6PG3tjkPqpTySRo2avNOB+2GnHFsp/eCONbJsmginRw7itCfB4iYeAmKhoBwWe/ZUQpwp6dWJH0kAumPTdnXDUJi3YffAOPQRbpi
 6nt1LHHa
 Nk2+Wp5MwInbeeKCA7Ywmwa6T2KWr9+1TGCNsU42EpQ+dkMDTlYzQBSosjiR2v8pIqatwAQmivOvyRP3I7aHL8/g4WA3kv7dhBh89XkWKYXgVd4M8V6VaGXiipd23HixaDukahjYUCUEyuCwkOswpnlh+TrVazBcHgZ+kWYfeXQMwW6o3PypdRekFtQPc6roWY3yOpsxumJNN7vbF8Y0DA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series enables fine grained control-flow integrity for kernel
on riscv platform. I did send out a RFC patchset [1] more than an year ago.
Since it's been a while, I am resetting the versioning and calling it a RFC
due to following reasons

- This is first (in a while)  and I may have missed things.
- Earlier patchset were not fine-grained kcfi. This one is.
- Toolchain used to compile kernel is still in development.
- On asm indirect callsites, setting up label need toolchain support.

It is based on 6.16-rc1 with user cfi enabling patchset(v18)[2] applied on it.
Hardware guarantee on kernel's control flow integrity is enforced via zicfilp
and zicfiss riscv cpu extensions. Please take a look at user cfi enabling
patchset for more details and references on these cpu extensions.

Toolchain
----------
As mentioned earlier toolchain used to develop this patchset are still in
development. But you can grab them here [3]. This is how I configure and
compile toolchain.

$ ./riscv-gnu-toolchain/configure \
--prefix=/scratch/debug/open_src/sifive_cfi_toolchain/INSTALL_funcsig \
--with-arch=rv64gc_zicfilp_zicfiss_zicsr_zifencei_zimop_zcmop \
--enable-debug-info --enable-linux --disable-gdb  --with-abi=lp64d \
--with-label-scheme=func-sig \
--with-linux-headers-src=/scratch/debug/linux/kbuild/usr/include

$ make -j$(nproc)

If `-fcf-protection=full` is selected, toolchain is enabled to generate
labeled landing pad instruction at the start of the function. And
shadow stack push to save return address and sspopchk instruction in
the return path.

riscv kernel control-flow integrity
------------------------------------

As with normal user software, enabling kernel control flow integrity also
require forward control flow integrity and backward control flow integrity.
This patchset introduces CONFIG_RISCV_KERNEL_CFI config, hw assisted riscv
kernel cfi is enabled only when `CONFIG_RISCV_KERNEL_CFI=y`. Selecting
CONFIG_RISCV_KERNEL_CFI is dependent on CONFIG_RISCV_USER_CFI.

To compile kernel, please clone the toolchain (link provided above), build
it and use that toolchain bits to compile the kernel. When you do `menuconfig`
select `Kernel features` --> `riscv userspace control flow integrity`.
When you select `riscv userspace control flow integrity`, then `hw assisted
riscv kernel control flow integrity (kcfi)` will show up. Select both and
build.

I have tested kcfi enabled kernel with full userspace exercising (unlabeled
landing pads) cfi starting with init process. In my limited testing, this
boots. There are some wrinkles around what labeling scheme should be used
for vDSO object. This patchset is using labeled landing pads for vDSO.
We may end up using unlabeled landing pad for vDSO for maximum compatibility.
But that's a future discussion.

Qemu command line to launch:
/scratch/debug/open_src/qemu/build_zicfilp/qemu-system-riscv64 \
  -nographic \
  -monitor telnet:127.0.0.1:55555,server,nowait \
  -machine virt \
  -cpu rv64,zicond=true,zicfilp=true,zicfiss=true,zimop=true,zcmop=true,v=true,vlen=256,vext_spec=v1.0,zbb=true,zcb=true,zbkb=true,zacas=true \
  -smp 2 \
  -m 8G \
  -object rng-random,filename=/dev/urandom,id=rng0 \
  -device virtio-rng-device,rng=rng0 \
  -drive file=/scratch/debug/open_src/zisslpcfi-toolchain/buildroot/output/images/rootfs.ext2,format=raw,id=hd0 \
  -append "root=/dev/vda rw, no_hash_pointers, loglevel=8, crashkernel=256M, console=ttyS0, riscv_nousercfi=all" \
  -serial mon:stdio \
  -kernel /scratch/debug/linux/kbuild/arch/riscv/boot/Image \
  -device e1000,netdev=net0 \
  -netdev user,id=net0,hostfwd=tcp::10022-:22 \
  -virtfs local,path=/scratch/debug/sources/spectacles,mount_tag=host0,security_model=passthrough,id=host0\
  -bios /scratch/debug/open_src/opensbi/build/platform/generic/firmware/fw_jump.bin

Backward kernel control flow integrity
---------------------------------------
This patchset leverages on existing infrastructure of software based shadow
call stack support in kernel. Differences between software based shadow call
stack and riscv hardware shadow stack are:

- software shadow call stack is writeable while riscv hardware shadow stack
  is writeable only via specific shadow stack instructions.

- software shadow call stack grows from low memory to high memory while riscv
  hardware shadow stack grows from high memory to low memory (like a normal
  stack).

- software shadow call stack on riscv uses `gp` register to hold shadow stack
  pointer while riscv hardware shadow stack has dedicated `CSR_SSP` register.

Thus its ideal use existing shadow call stack plumbing and create hooks into
it to apply riscv hardware shadow stack mechanisms on it.

This patchset introduces `CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK` along the lines
of `CONFIG_ARCH_HAS_USER_SHADOW_STACK`.

Forward kernel control-flow integrity
--------------------------------------
Enabling forward kernel control-flow integrity is mostly toolchain work where
it emits a landing pad instruction at the start of address-taken function. 
zicfilp allows landing pads to be labeled with a 20-bit immediate value. 
Compiler used here is following the scheme of normalizing function prototype
to a string using C++ itanium rules (with some modifications). See more details
here [4]. Compiler generates a 128bit md5 hash over this string and uses
first non-zero (scanning from MSB) 20bit segment from the 128-bit hash as label
value.

This is still a work in progress and feedback/comments are welcome.

I would like to thank Monk Chiang and Kito Cheng for helping and continue to
support from the toolchain side.

[1] - https://lore.kernel.org/lkml/CABCJKuf5Jg5g3FVpU22vNUo4UituPEM7QwvcVP8YWrvSPK+onA@mail.gmail.com/T/#m7d342d8728f9a23daed5319dac66201cc680b640
[2] - https://lore.kernel.org/all/20250711-v5_user_cfi_series-v18-0-a8ee62f9f38e@rivosinc.com/
[3] - https://github.com/sifive/riscv-gnu-toolchain/tree/cfi-dev
[4] - https://github.com/riscv-non-isa/riscv-elf-psabi-doc/pull/434

To: Paul Walmsley <paul.walmsley@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>
To: Albert Ou <aou@eecs.berkeley.edu>
To: Alexandre Ghiti <alex@ghiti.fr>
To: Masahiro Yamada <masahiroy@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
To: Nicolas Schier <nicolas.schier@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@redhat.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Liam R. Howlett <Liam.Howlett@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
To: Mike Rapoport <rppt@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
To: Nick Desaulniers <nick.desaulniers+lkml@gmail.com>
To: Bill Wendling <morbo@google.com>
To: Monk Chiang <monk.chiang@sifive.com>
To: Kito Cheng <kito.cheng@sifive.com>
To: Justin Stitt <justinstitt@google.com>
Cc: linux-riscv@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: llvm@lists.linux.dev
Cc: rick.p.edgecombe@intel.com
Cc: broonie@kernel.org
Cc: cleger@rivosinc.com
Cc: samitolvanen@google.com
Cc: apatel@ventanamicro.com
Cc: ajones@ventanamicro.com
Cc: conor.dooley@microchip.com
Cc: charlie@rivosinc.com
Cc: samuel.holland@sifive.com
Cc: bjorn@rivosinc.com
Cc: fweimer@redhat.com
Cc: jeffreyalaw@gmail.com
Cc: heinrich.schuchardt@canonical.com
Cc: monk.chiang@sifive.com
Cc: andrew@sifive.com
Cc: ved@rivosinc.com

Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
Deepak Gupta (11):
      riscv: add landing pad for asm routines.
      riscv: update asm call site in `call_on_irq_stack` to setup correct label
      riscv: indirect jmp in asm that's static in nature to use sw guarded jump
      riscv: exception handlers can be software guarded transfers
      riscv: enable landing pad enforcement
      mm: Introduce ARCH_HAS_KERNEL_SHADOW_STACK
      scs: place init shadow stack in .shadowstack section
      riscv/mm: prepare shadow stack for init task
      riscv: scs: add hardware shadow stack support to scs
      scs: generic scs code updated to leverage hw assisted shadow stack
      riscv: Kconfig & Makefile for riscv kernel control flow integrity

 Makefile                               |  2 +-
 arch/riscv/Kconfig                     | 37 +++++++++++++++++++++++++-
 arch/riscv/Makefile                    |  8 ++++++
 arch/riscv/include/asm/asm.h           |  2 +-
 arch/riscv/include/asm/linkage.h       | 42 +++++++++++++++++++++++++++++
 arch/riscv/include/asm/pgtable.h       |  4 +++
 arch/riscv/include/asm/scs.h           | 48 +++++++++++++++++++++++++++-------
 arch/riscv/include/asm/sections.h      | 22 ++++++++++++++++
 arch/riscv/include/asm/thread_info.h   | 10 +++++--
 arch/riscv/kernel/asm-offsets.c        |  1 +
 arch/riscv/kernel/compat_vdso/Makefile |  2 +-
 arch/riscv/kernel/entry.S              | 21 ++++++++-------
 arch/riscv/kernel/head.S               | 23 ++++++++++++++--
 arch/riscv/kernel/vdso/Makefile        |  2 +-
 arch/riscv/kernel/vmlinux.lds.S        | 12 +++++++++
 arch/riscv/lib/memset.S                |  6 ++---
 arch/riscv/mm/init.c                   | 29 +++++++++++++++-----
 include/linux/init_task.h              |  5 ++++
 include/linux/scs.h                    | 26 +++++++++++++++++-
 init/init_task.c                       | 12 +++++++--
 kernel/scs.c                           | 38 ++++++++++++++++++++++++---
 mm/Kconfig                             |  6 +++++
 22 files changed, 314 insertions(+), 44 deletions(-)
---
base-commit: cc0fb5eb25ea00aefd49002b1dac796ea13fd2a0
change-id: 20250616-riscv_kcfi-f851fb2128bf
--
- debug


