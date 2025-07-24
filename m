Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DDCDC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 23:38:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EBB78E00CB; Thu, 24 Jul 2025 19:38:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 975878E007C; Thu, 24 Jul 2025 19:38:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83D708E00CB; Thu, 24 Jul 2025 19:38:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 66A2E8E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:38:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 325D71A0560
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:38:31 +0000 (UTC)
X-FDA: 83700774822.25.351C6F2
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4CF88A0002
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:38:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=WjePQRum;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753400309; a=rsa-sha256;
	cv=none;
	b=k9Ig01wvdGQ3o8rLwgn4Md8IDzr+BOrLKbBtu8zj2OMtyxUTpK7oqNBEUh8KObaUk+A+TJ
	QJ2zHskb4Te86kp5zaIddPVU2vkjKbqNFBJ1ne7jWOXJDcy4owceHfWui7fHiaJnFFtipa
	Q31DXl059JFrM4PDx3XN3ZvbZm11OZY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=WjePQRum;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753400309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ahgvr94dH2dhBsqXaRkVzEMYNkCZUV1gRwiq2yUA2cU=;
	b=Wb+sQphbQE5R+MxHAH/YgAAK+r4N+AhQtILhoE/OaJDR6hamquVCYVDeetfcsZmZGq0fOs
	Ufs9uYSDIyjU1iUJ2fO4avom149j0z9N2jvirkUkM2ocO2/uJGtK5SkMHTfLnQzpAr5uq3
	8GaAKNqUAR5nRgbUk16Lt3qRpXITvgA=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-235f9ea8d08so13634545ad.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753400308; x=1754005108; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ahgvr94dH2dhBsqXaRkVzEMYNkCZUV1gRwiq2yUA2cU=;
        b=WjePQRumoi/DePdFHQeh0oWlpIIXbLtF6WHLSATdjO0D6uE994QNz7BBnG/MTwfNGQ
         FZ1Nxt/kEq60/iUYD7ZgCQunv77ZOXRxMnD48bxhuJxya/iyHw/a2OskBJhkAn6lBYYv
         KtTHMB2474vxUvLmL3lCEQOS/rdoVBj6lyCjwoG2e4hoUFxScYNdhveZMwn2S1cXDcxt
         iCW/6rpiDMNC0nfOQaW9T+p9Vcgny48exkhJbSPxL9+jE842k/kWQkrHCwUBhO6uPFIK
         9c3NkEuVaUl7ywvVVtafloJAX3f4Ddye0O0PyfAYpzFRt0tchsHjxBYDZ1BtOcscSepd
         Iw1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753400308; x=1754005108;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ahgvr94dH2dhBsqXaRkVzEMYNkCZUV1gRwiq2yUA2cU=;
        b=i4/v7Rc0cgatuh6wq7OdelVCGNpHQHesxi3J8VS6Bv8z4D1QKSzYKRigqizrYwM6b7
         ck4fY8IL4hAob8stjcOF/efivP9LXIh+ylPBtiXuN78l2fc628QJNPeeXFhvr0SmxpZQ
         AC0I9f02I9+ky9f9QFCyFURlB72XzV8jQsvG/eeeA5Uqe3aSXU51XOGKMcg5KB2/LNeI
         Rxd1aKXFP8FOK6MFaoHOWFcJ+Sd3ptCDjTYEJrZ6WzCOn7+vUPCOS1qL2z4PWDP1JVwv
         gS4pS1oHRYdz9nJiaocJlN4Cp28wjA76yQYnIbGglU3+xPH9MIT9UNx9v7JuDpVHmrTh
         fk4A==
X-Forwarded-Encrypted: i=1; AJvYcCXtw9iItPgvxFtknHDcKqr6ehlqqoDCEUfdrrpsQwoszgEFZZs5DW4t5cI5AxdpWVWG9DjUQ1Kp4Q==@kvack.org
X-Gm-Message-State: AOJu0YyGxH4o7FfwiSDiXRfE2laX1SbqoYZ1OBuVkqdVSVGxRsKiOefq
	krVeZzR/zoBaBkzX176qyaQ7HvCvcrWkOSnyMDIb/vU9OIR7usOeg8/EYxjtUuTrtLg=
X-Gm-Gg: ASbGnctVdoooTAzCVdN/S1k/kP4Wdofhjs/RlXzL8e555HrUY2rvA8pUEl8ub6UI6zF
	HWPS7HsLUwPvGXcFlJLRZZeqk2IbCCfIdV2/WR040xfHhjkJX8RJn0EOEN0dDpDXp5Jmdvmnr2o
	3KCeSUydO6anjhFTWyHe68UkMAAmNnNdpsmNAKrNlnbdgrlwrH+b+rhWaZdotBPHONi3moQwy2v
	MLdbDg7cJzbCSPDx7o8tc5ZUh3tEtZv6TDPtpSgS2y2rDEz6u8O2kc7/lhVhp+heGDXjrx5j8xF
	r6JVodxUkmx8wy+UjgEddGyhlG41ZtY49CWQVcQNPZERjOHbCe/x7QXJVDpFbyanq1T1LCc2Ffr
	wxN3o6ykDmwZD9FzRniZNo0uxbnQzW8SY
X-Google-Smtp-Source: AGHT+IHh57JQMjYQf6z5v8YtVS4etBElbIsePwBBM2zn5y0zWRQdQdP1YcFar+ZP2TEVlhG5eL2aKg==
X-Received: by 2002:a17:903:8c8:b0:23f:6fa4:1567 with SMTP id d9443c01a7336-23f98146861mr104261895ad.8.1753400308145;
        Thu, 24 Jul 2025 16:38:28 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fa48dc9a2sm23532065ad.126.2025.07.24.16.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 16:38:27 -0700 (PDT)
Date: Thu, 24 Jul 2025 16:38:24 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Monk Chiang <monk.chiang@sifive.com>,
	Kito Cheng <kito.cheng@sifive.com>,
	Justin Stitt <justinstitt@google.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
	llvm@lists.linux.dev, rick.p.edgecombe@intel.com,
	broonie@kernel.org, cleger@rivosinc.com, samitolvanen@google.com,
	apatel@ventanamicro.com, ajones@ventanamicro.com,
	conor.dooley@microchip.com, charlie@rivosinc.com,
	samuel.holland@sifive.com, bjorn@rivosinc.com, fweimer@redhat.com,
	jeffreyalaw@gmail.com, heinrich.schuchardt@canonical.com,
	andrew@sifive.com, ved@rivosinc.com
Subject: Re: [PATCH 00/11] riscv: fine grained hardware assisted kernel
 control-flow integrity
Message-ID: <aILD8LeUypdAKc8a@debug.ba.rivosinc.com>
References: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4CF88A0002
X-Stat-Signature: gryeu6z6iqze1hdmnxxquibb5f9sgp56
X-Rspam-User: 
X-HE-Tag: 1753400309-533134
X-HE-Meta: U2FsdGVkX19xgMmbzFoXowkFzzFLgDhBk5qoUu2N8o47kN8XINZvVelAGe2nkjlLYAVIPU0pna3secOHrMQ4ep+bUACvC2fwHpqAvvLcM+JE5bRNT0L8Fz+2JH6h355lpfOUpMx0ZrBnNy2VUZuqA68hQZTDuJg1F7T5OT1UYHafzyFoXADCCfhJpHSoY2zFovB+3JKqXZMOq/W6PFKdndwNGdURYA/4ZYeqFs/OL1LqQHv7pC6wLTkZ2sNEJyXsMoVn1jshTT5AuzYbGsgbcWsmjModFASv8Mri/tWKRApkAVjIkE+g4b80lLUf7BoDQx/J2NC+k/3zGchc4jlx0ccXQltkxFPhq92LxhV3f9WlG90v8SP9iNVtlkYcEOYr9YGHH0Azf2BDIjGYkxFUvH1RcGyYIM45WJLv2+LrcHdbOaJVxRx0cAbQ7abbADIBsid8v0qeKdBzTFTXKInAQU5OsNv/VUnZ3B5DgLx/lpnMpvERqzJTLmCzs2n/IU56p0+2uEnNbdWMK55FaNcuUJ2negBsoOmRLbFBueLI8KVgcTJolmFzmHNt3do78kqa8Sp8qJSQlYWQiLQTG2LxrJUPbxPPFFKpQvNKSPIiL3r7WhGU6qcknBwYnemUCQWXZSv/nt/UKj0EK9Fw1aQrFRHZocnsbp7WpR7L+OUy9p6RatAPnKVeZvKgWZby6Rq+v6HiWGCRJ6YJ7K8PIGYLZ5OFYeuXo7SpF+c/6l+AnUsE9TghmkQnXl2AqfkSEdqMq1N0kR8+pCRanJXLDX/Q+FOousvzSMh6A5HIbjXRTSQBOW3bSzkwskAYyerv8pl+kxlnUWyYkyaaPd+MOwuc3jDbaJZuW4IIEXc6ox1MZCC1menvlai/O5cPfKvBdswPkEwe2XDdCnm850uy12zCbf1tpdigPPkaWx0j7pMAM/5reurUb4h0uT+afDO+RnAzDjqGETfTDiQ2h6qULlY
 vv1LRhjV
 CK4tae5253pdc8MEBH4AnpQ/9RRUiWpCbp0NQfO8xJ3vbhsUARwPD21VFSOvGKxsudpWO1SNEfE5OrqKAInOoRQWG1CW5vTf69WJdYH1VO0NWNaOh540rMiLcZRQZiXvJLFBKeNlZnEIHE14efegTKLm4Tgx1YEbGJrt5Kp5Rf+aJBs8RUdcxerys5ZIruXuJmSj+dVBmSgyJRW5i8K3JRtgXSjOImg8sp2n/+uZRDy9tVU54obsGruP5papYkmS4ypFyN0p+c+QaH2TLrJIVWcqh1xIFiarCtvSh8p8w0QjaNE+IiBhZq+en87wMytJOjhGHN+mcdIB2lCaEZQMC5hZph+FziLYFxZUTW4fbzF68R4Hei3x4zlIr+6VLEqL36L/U1ofMxw7AEDkGhtpm16toRVs09KtLpT04J+ry2PwmbFm3LLIlwdrfJB9ToRt2UsoT/xiUJM5rh+f707A2nJxUROTz+9CswtXPb3RRK7pjx2awPW6mzsXwOP/HhAQ+QmfTJao13t661MshkI2BNPHemYXRfzMvGE4iLzyJETpBHBHMqWJyzGTmY0VxA9WeDyd1+HmBfUP7ttSydwT8BKCCqSUuVjdPtdHxi5HyKN+eKPCuGbi1OvQnLJhhwifCY+w7DjTv7PzVfi5unRWpxuV921zX3CUCJnWrQMQ5IT2kLwlR9UCJk2VxcTBBjOGOGp9YKk/J6W+Zv5Bhv+kZ22rljrv9SO/sBN49kl/N0ZKbLbd7KJhIYDU0h3kMhAM3cgaMNLtFbexVdeh/QoKF9BwMr9Wm20jqV+5jUcbBHGSqdlheMI99LBytZB1w2Tjn3fd3ZK5j3Q5Gm5CQLYwIBPW/f5dHttT0+y8ayyB1bGF/KuMEwwNIbNC/q595ybkcvv3oFEYL6opKJ0R/z4mutWe+Fo8E0BAtDy4x2xRLnXYunPcBbbnzqDLcm0ph9yycL4BqG0p9WQRM7NvzMsBCj3qEApKa
 GJh+tScF
 GT1b3QWSBOwQX2rVUzKe9BpbgvegBeu50Q9PA1KWEY6envzxFsWcQ4W+9wOK1LHJrH4x0h5gbHfguyYWUGQCJTQRXx9qjj6Uiw6VBURgXbbrxqj3S2Y0UJn2TT/vwLEuPY4hT+erSAiQs/TINXO1ICcv+Vuw51iEzCHVEGSaZh2+E6Mg3ioMFss5W/llpkKAjqAglbip3RhW53QRET2/3lct0QWx0hAIo21ngMJwLoPjVCSsC17FCkNGmCy1GTQG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Well I forgot to apply "RFC" prefix in subject. Sorry about that.

-Deepak

On Thu, Jul 24, 2025 at 04:36:53PM -0700, Deepak Gupta wrote:
>This patch series enables fine grained control-flow integrity for kernel
>on riscv platform. I did send out a RFC patchset [1] more than an year ago.
>Since it's been a while, I am resetting the versioning and calling it a RFC
>due to following reasons
>
>- This is first (in a while)  and I may have missed things.
>- Earlier patchset were not fine-grained kcfi. This one is.
>- Toolchain used to compile kernel is still in development.
>- On asm indirect callsites, setting up label need toolchain support.
>
>It is based on 6.16-rc1 with user cfi enabling patchset(v18)[2] applied on it.
>Hardware guarantee on kernel's control flow integrity is enforced via zicfilp
>and zicfiss riscv cpu extensions. Please take a look at user cfi enabling
>patchset for more details and references on these cpu extensions.
>
>Toolchain
>----------
>As mentioned earlier toolchain used to develop this patchset are still in
>development. But you can grab them here [3]. This is how I configure and
>compile toolchain.
>
>$ ./riscv-gnu-toolchain/configure \
>--prefix=/scratch/debug/open_src/sifive_cfi_toolchain/INSTALL_funcsig \
>--with-arch=rv64gc_zicfilp_zicfiss_zicsr_zifencei_zimop_zcmop \
>--enable-debug-info --enable-linux --disable-gdb  --with-abi=lp64d \
>--with-label-scheme=func-sig \
>--with-linux-headers-src=/scratch/debug/linux/kbuild/usr/include
>
>$ make -j$(nproc)
>
>If `-fcf-protection=full` is selected, toolchain is enabled to generate
>labeled landing pad instruction at the start of the function. And
>shadow stack push to save return address and sspopchk instruction in
>the return path.
>
>riscv kernel control-flow integrity
>------------------------------------
>
>As with normal user software, enabling kernel control flow integrity also
>require forward control flow integrity and backward control flow integrity.
>This patchset introduces CONFIG_RISCV_KERNEL_CFI config, hw assisted riscv
>kernel cfi is enabled only when `CONFIG_RISCV_KERNEL_CFI=y`. Selecting
>CONFIG_RISCV_KERNEL_CFI is dependent on CONFIG_RISCV_USER_CFI.
>
>To compile kernel, please clone the toolchain (link provided above), build
>it and use that toolchain bits to compile the kernel. When you do `menuconfig`
>select `Kernel features` --> `riscv userspace control flow integrity`.
>When you select `riscv userspace control flow integrity`, then `hw assisted
>riscv kernel control flow integrity (kcfi)` will show up. Select both and
>build.
>
>I have tested kcfi enabled kernel with full userspace exercising (unlabeled
>landing pads) cfi starting with init process. In my limited testing, this
>boots. There are some wrinkles around what labeling scheme should be used
>for vDSO object. This patchset is using labeled landing pads for vDSO.
>We may end up using unlabeled landing pad for vDSO for maximum compatibility.
>But that's a future discussion.
>
>Qemu command line to launch:
>/scratch/debug/open_src/qemu/build_zicfilp/qemu-system-riscv64 \
>  -nographic \
>  -monitor telnet:127.0.0.1:55555,server,nowait \
>  -machine virt \
>  -cpu rv64,zicond=true,zicfilp=true,zicfiss=true,zimop=true,zcmop=true,v=true,vlen=256,vext_spec=v1.0,zbb=true,zcb=true,zbkb=true,zacas=true \
>  -smp 2 \
>  -m 8G \
>  -object rng-random,filename=/dev/urandom,id=rng0 \
>  -device virtio-rng-device,rng=rng0 \
>  -drive file=/scratch/debug/open_src/zisslpcfi-toolchain/buildroot/output/images/rootfs.ext2,format=raw,id=hd0 \
>  -append "root=/dev/vda rw, no_hash_pointers, loglevel=8, crashkernel=256M, console=ttyS0, riscv_nousercfi=all" \
>  -serial mon:stdio \
>  -kernel /scratch/debug/linux/kbuild/arch/riscv/boot/Image \
>  -device e1000,netdev=net0 \
>  -netdev user,id=net0,hostfwd=tcp::10022-:22 \
>  -virtfs local,path=/scratch/debug/sources/spectacles,mount_tag=host0,security_model=passthrough,id=host0\
>  -bios /scratch/debug/open_src/opensbi/build/platform/generic/firmware/fw_jump.bin
>
>Backward kernel control flow integrity
>---------------------------------------
>This patchset leverages on existing infrastructure of software based shadow
>call stack support in kernel. Differences between software based shadow call
>stack and riscv hardware shadow stack are:
>
>- software shadow call stack is writeable while riscv hardware shadow stack
>  is writeable only via specific shadow stack instructions.
>
>- software shadow call stack grows from low memory to high memory while riscv
>  hardware shadow stack grows from high memory to low memory (like a normal
>  stack).
>
>- software shadow call stack on riscv uses `gp` register to hold shadow stack
>  pointer while riscv hardware shadow stack has dedicated `CSR_SSP` register.
>
>Thus its ideal use existing shadow call stack plumbing and create hooks into
>it to apply riscv hardware shadow stack mechanisms on it.
>
>This patchset introduces `CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK` along the lines
>of `CONFIG_ARCH_HAS_USER_SHADOW_STACK`.
>
>Forward kernel control-flow integrity
>--------------------------------------
>Enabling forward kernel control-flow integrity is mostly toolchain work where
>it emits a landing pad instruction at the start of address-taken function.
>zicfilp allows landing pads to be labeled with a 20-bit immediate value.
>Compiler used here is following the scheme of normalizing function prototype
>to a string using C++ itanium rules (with some modifications). See more details
>here [4]. Compiler generates a 128bit md5 hash over this string and uses
>first non-zero (scanning from MSB) 20bit segment from the 128-bit hash as label
>value.
>
>This is still a work in progress and feedback/comments are welcome.
>
>I would like to thank Monk Chiang and Kito Cheng for helping and continue to
>support from the toolchain side.
>
>[1] - https://lore.kernel.org/lkml/CABCJKuf5Jg5g3FVpU22vNUo4UituPEM7QwvcVP8YWrvSPK+onA@mail.gmail.com/T/#m7d342d8728f9a23daed5319dac66201cc680b640
>[2] - https://lore.kernel.org/all/20250711-v5_user_cfi_series-v18-0-a8ee62f9f38e@rivosinc.com/
>[3] - https://github.com/sifive/riscv-gnu-toolchain/tree/cfi-dev
>[4] - https://github.com/riscv-non-isa/riscv-elf-psabi-doc/pull/434
>
>To: Paul Walmsley <paul.walmsley@sifive.com>
>To: Palmer Dabbelt <palmer@dabbelt.com>
>To: Albert Ou <aou@eecs.berkeley.edu>
>To: Alexandre Ghiti <alex@ghiti.fr>
>To: Masahiro Yamada <masahiroy@kernel.org>
>To: Nathan Chancellor <nathan@kernel.org>
>To: Nicolas Schier <nicolas.schier@linux.dev>
>To: Andrew Morton <akpm@linux-foundation.org>
>To: David Hildenbrand <david@redhat.com>
>To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>To: Liam R. Howlett <Liam.Howlett@oracle.com>
>To: Vlastimil Babka <vbabka@suse.cz>
>To: Mike Rapoport <rppt@kernel.org>
>To: Suren Baghdasaryan <surenb@google.com>
>To: Michal Hocko <mhocko@suse.com>
>To: Nick Desaulniers <nick.desaulniers+lkml@gmail.com>
>To: Bill Wendling <morbo@google.com>
>To: Monk Chiang <monk.chiang@sifive.com>
>To: Kito Cheng <kito.cheng@sifive.com>
>To: Justin Stitt <justinstitt@google.com>
>Cc: linux-riscv@lists.infradead.org
>Cc: linux-kernel@vger.kernel.org
>Cc: linux-kbuild@vger.kernel.org
>Cc: linux-mm@kvack.org
>Cc: llvm@lists.linux.dev
>Cc: rick.p.edgecombe@intel.com
>Cc: broonie@kernel.org
>Cc: cleger@rivosinc.com
>Cc: samitolvanen@google.com
>Cc: apatel@ventanamicro.com
>Cc: ajones@ventanamicro.com
>Cc: conor.dooley@microchip.com
>Cc: charlie@rivosinc.com
>Cc: samuel.holland@sifive.com
>Cc: bjorn@rivosinc.com
>Cc: fweimer@redhat.com
>Cc: jeffreyalaw@gmail.com
>Cc: heinrich.schuchardt@canonical.com
>Cc: monk.chiang@sifive.com
>Cc: andrew@sifive.com
>Cc: ved@rivosinc.com
>
>Signed-off-by: Deepak Gupta <debug@rivosinc.com>
>---
>Deepak Gupta (11):
>      riscv: add landing pad for asm routines.
>      riscv: update asm call site in `call_on_irq_stack` to setup correct label
>      riscv: indirect jmp in asm that's static in nature to use sw guarded jump
>      riscv: exception handlers can be software guarded transfers
>      riscv: enable landing pad enforcement
>      mm: Introduce ARCH_HAS_KERNEL_SHADOW_STACK
>      scs: place init shadow stack in .shadowstack section
>      riscv/mm: prepare shadow stack for init task
>      riscv: scs: add hardware shadow stack support to scs
>      scs: generic scs code updated to leverage hw assisted shadow stack
>      riscv: Kconfig & Makefile for riscv kernel control flow integrity
>
> Makefile                               |  2 +-
> arch/riscv/Kconfig                     | 37 +++++++++++++++++++++++++-
> arch/riscv/Makefile                    |  8 ++++++
> arch/riscv/include/asm/asm.h           |  2 +-
> arch/riscv/include/asm/linkage.h       | 42 +++++++++++++++++++++++++++++
> arch/riscv/include/asm/pgtable.h       |  4 +++
> arch/riscv/include/asm/scs.h           | 48 +++++++++++++++++++++++++++-------
> arch/riscv/include/asm/sections.h      | 22 ++++++++++++++++
> arch/riscv/include/asm/thread_info.h   | 10 +++++--
> arch/riscv/kernel/asm-offsets.c        |  1 +
> arch/riscv/kernel/compat_vdso/Makefile |  2 +-
> arch/riscv/kernel/entry.S              | 21 ++++++++-------
> arch/riscv/kernel/head.S               | 23 ++++++++++++++--
> arch/riscv/kernel/vdso/Makefile        |  2 +-
> arch/riscv/kernel/vmlinux.lds.S        | 12 +++++++++
> arch/riscv/lib/memset.S                |  6 ++---
> arch/riscv/mm/init.c                   | 29 +++++++++++++++-----
> include/linux/init_task.h              |  5 ++++
> include/linux/scs.h                    | 26 +++++++++++++++++-
> init/init_task.c                       | 12 +++++++--
> kernel/scs.c                           | 38 ++++++++++++++++++++++++---
> mm/Kconfig                             |  6 +++++
> 22 files changed, 314 insertions(+), 44 deletions(-)
>---
>base-commit: cc0fb5eb25ea00aefd49002b1dac796ea13fd2a0
>change-id: 20250616-riscv_kcfi-f851fb2128bf
>--
>- debug
>

