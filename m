Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1510BC87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 14:10:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 273996B0088; Fri, 25 Jul 2025 10:10:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21DB36B0089; Fri, 25 Jul 2025 10:10:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10C9B6B008A; Fri, 25 Jul 2025 10:10:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 006076B0088
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 10:10:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 836791A077B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:10:28 +0000 (UTC)
X-FDA: 83702972136.18.9ED4694
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9DA45160017
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:10:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=qOxp7Nv0;
	spf=pass (imf08.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753452626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jf/mOhm/oVbqNLjepUkvAGKUCLK5QqEVSdfRhcGCSHg=;
	b=d6eSa1VLYdn/UOKzBkEm+vD1JoIgqLVIxHoUcR7wcjC0LLfVMWEA+r4sPagKeCRg5h9c6z
	DZ9uy8FcfO785sbxlEzaPk/dNFQNxb8eiUJkvfMiphns6dXTikdx1rA5vPunjAl1GwyypZ
	cKyU16HWE1a5zSv8m0D9P8Aq+wp0Li8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=qOxp7Nv0;
	spf=pass (imf08.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753452626; a=rsa-sha256;
	cv=none;
	b=3bycd/yyIY6OSr/pxPVJXRwX2FVSdBxPQ39gsFb035hPK2yzjJQx1Kq9WQSLHUyVnaExq3
	oe/qEc+cg/CxRvVYuOPO5Y+8J117bnGteat1UlaR7yuWFMVjcfiyy5Fzp08HE3S4gVnD6C
	piqLJCQ8Dzb7q6U39itev3B0HNkOLjc=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-74b52bf417cso1561675b3a.0
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 07:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753452625; x=1754057425; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Jf/mOhm/oVbqNLjepUkvAGKUCLK5QqEVSdfRhcGCSHg=;
        b=qOxp7Nv0iDXQEM4XSCWagHU5Oj/6DmBPBpfNUfgswm4TVFYhBNQzwAvD6xReJT4LcO
         nc0SsS0bbOKedYICIPsiVkulfynTBt8atYKSlIG0ICRK61v01lhksSV7Hzz9/ygYY6i4
         x6MF0f6GbksxlFrmTLJt7dsKIusONjYoz+8gzOIcpLPQM6HNYv9ZsY5ztFu+mFlrQxgk
         5KXaazAC455otRd4rmVO2nJKNx3opVpnq66RKsBNa8KdWliXgpnhQTKqC2CWyK67q33/
         klWHpqBai6dVXPQQh6caL64HGjH1CgQgFAWLff7nI7YSoJaT5H4QvXNHJ/iONxKhn6Lq
         6jRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753452625; x=1754057425;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jf/mOhm/oVbqNLjepUkvAGKUCLK5QqEVSdfRhcGCSHg=;
        b=ZVk9N+TVeGgZyw6otpeuYo4BuT3XPfH/rraJ8sYW9nEjetzr2gvDbQ0xJDwDpzTmPs
         z2pqr9H+Uu5wMUv5agBaB92sxiLJaEq5hxhgk/Xe5hXxNtv8NwEykHSnAbTEQyR7az0x
         rggQK0ZFUf9vqhLlL40/zavIk4uaX83Fbb9Frgx+qU15vUKJkRVyDhXM/odiy5JIbzWl
         29Gyyl+wmG1QqgXdSKl5R+XICZcOeqJiE928D7q6URWxYkXiDF1k7oWmLfKBRChK5Msp
         RN6Wbj4IwTFVyz9HbLpwBmS0QlTGJ1qvlPMwEPSroyUqEWqclWL2SQRrKQOEu1NMZUok
         q1sA==
X-Forwarded-Encrypted: i=1; AJvYcCVsnAYOV/5RzDdDIk15Gs9YUstr8oMfWVGiaKFlOu2QkuRliBoXTWHmH0I/OXYVVCnNY/UBfj7iNg==@kvack.org
X-Gm-Message-State: AOJu0YxbeihxR0j0YoVR5B0lH4Hc4LsEhyrr1Gjzd2Rik2X5RxB4hMNI
	tojJ3wGvpVbCJqKaqWV4TX0HOIjV7TKZR7OOYOqlZvbzKqsP6leuhHPASIOdqyn54So=
X-Gm-Gg: ASbGncsVKN0NONTQw9+jxzQMbWu9Y/Pjpq/+7b/gEw1nc07igjeFgRoxksqqIDPeyxs
	J7dYpfge2KmxLX6wpoNtzdXvpNyW0PlrHUtv8niHObO1kWRux/C1BX2eTBxqjYqLJrCruD80Iwl
	UvHMMuh+E1uGz5T2b0TEAG8Acx4MfCuoVkNkjDVu/Drpq5ERzMDxxOSBi375cXlRtZiUTprhJvT
	xlF94AePHUmRYURP7ZKUxU0bGWSlFOBdJmqnJkJYLQIA4TTPhwOCt9zgckbRLdF7pPgJICJOekY
	+q68mQE+UIZjjo+GCHfNDkeUaD/0xH7wcTsjOCFedCpuRk6DXz7jMUmuDScXYHt7+t9SZRhpcIu
	a+wA1ZB5iPF+dqpsZuBqFHZKvmLkmTh6vpYy343ij9F8=
X-Google-Smtp-Source: AGHT+IHNN/h9IcORot4a3xhdjrHaAp7ln5/qPNI4g6XxmpxQs89n8kgWy8jMRw30pgwpyInfWpB5eg==
X-Received: by 2002:a05:6a00:1142:b0:749:456:4082 with SMTP id d2e1a72fcca58-76335849218mr3090044b3a.1.1753452625116;
        Fri, 25 Jul 2025 07:10:25 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-761b0615d7fsm3945846b3a.105.2025.07.25.07.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 07:10:24 -0700 (PDT)
Date: Fri, 25 Jul 2025 07:10:21 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
	llvm@lists.linux.dev, rick.p.edgecombe@intel.com,
	broonie@kernel.org, cleger@rivosinc.com, samitolvanen@google.com,
	apatel@ventanamicro.com, ajones@ventanamicro.com,
	conor.dooley@microchip.com, charlie@rivosinc.com,
	samuel.holland@sifive.com, bjorn@rivosinc.com, fweimer@redhat.com,
	jeffreyalaw@gmail.com, andrew@sifive.com, ved@rivosinc.com,
	Paul Walmsley <paul.walmsley@sifive.com>,
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
Subject: Re: [PATCH 01/11] riscv: add landing pad for asm routines.
Message-ID: <aIOQTSVNkC1RztDW@debug.ba.rivosinc.com>
References: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
 <20250724-riscv_kcfi-v1-1-04b8fa44c98c@rivosinc.com>
 <2ba0c09d-2783-4dce-a889-06e16abbde61@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <2ba0c09d-2783-4dce-a889-06e16abbde61@canonical.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 9DA45160017
X-Rspamd-Server: rspam06
X-Stat-Signature: bqgfex8fm314iwore6sg1bmz75zqsjed
X-HE-Tag: 1753452626-313567
X-HE-Meta: U2FsdGVkX1++5OdOqXrG0NixrkvQtLg6v0aUDVVxsFdzRPfrcnY1ZYKouxwm8zMqLTBjA/RuBddC0+X6t4l0P99ipREbwr6iBfLo7f9o281jT2bTHKAhLxN28EXOVWyB+8KCWCOpX3vsZdqUzEZGPnXb4t28s9abeLL+63/tutH/PDHiL/Et2xma1xTcqsS1CKolcRBj4ykaP2MNj6rpuN4pbphWZa254QH3tG1db/f3dUiF7Nv6u8FTKVmeVLJsWgRhzh6MrrQ3dwYdMNilxX1AjT712GFOiCbMcp7p3tiBE9YN2Zw9wuBFWwFBHt/Ch10u8rhrIaAmjGWhyvOUjunGhPcPMLv1Hb8XnGszzqc63Y+A0G+glI0QTCwXTh9DbLb7oZ9cnOVhwyoWtrRY3QsN0Rh9578ndDI4eJjnyU4JwbUWGWkLqQJjxgnUT9jaf3GLjmu6OOISTswmJZSpC0Vssp5Jhl6T7oVlOyFMBqvW7kHNexyNy84R3uRFkQG27buBSZKi0ze1dtVmjN+neefRnk+pinaqURv/CpcMoC7bXFOBGaqp3Y3fhY7TjkXFTe3QDE/NOeEDj/DDyHZttz/JOZuA71ZjoZGCCUl7D1FtIVzqijYsYRD7D4FBfX/eiB8y3ocEZBsOFfC/uEORX79eRfBMnu5WJCY2nXnlvlcpeyGc6HB6ynIO4feq9/WzVLBGDH6Yc3KIOkwLbtzTY7HxU8pDQ0WstV+vgLYiEA3I3Zs9jy3HbhFrc4Kact/4+V6PenjkfcQ+PrPR7jHLN6pY4HvJQig8FHz8cS02OpowrZLq6HrZCs40m+4ippA8Z0/NNI+sP57IynL7K8+lMgr2HGayf45ZND1sDFlD6Vdv3KGHlpB3RgxEMwOBCwAht3do5URoCOM12O1T0Q7t/TDl1WSg97WBp1RrMP3b6SJVeSbj0iT8kjMzDrJ3Iw2ZFvZ9mIglWoHvi+Rk9ix
 djMeK0ea
 VEPv0R0T28AB/3hvoY3BXa+sgqMbpZOFEFLLvG54XZVb5ROsupKQAmU+b79lj19b+1ccJkkio1kF+sAqG23vT1ZK1TZoDXUhB/NZQBogtGKG/iofiSIcJxHI/hx6UOr2JIZnQmm/LiObDfzmRTimQwcl0E9OPCXNDNIkCXtbIDvMlcZJI6QqWkxLh5I8q7x5m4Z3KkynxoVpznXArKbFsTHC6RQfNZYSLY3YnaIujwbo0xs2Wz0thUxU3ZKtXDxmg1gmzeFEEgiygqDMHqLwCA7XNr/1AWRZL0m7F5EMUpjbVxhhdCyPlGxrtAjxv7cG2Rl7E+uRt7I7lJBjPeO0NgA20q/CmArwG458SZy0g3LjePrGZCR2OdX3d15hLGQSIOQj7N3CjYo2bYhWfBXC7AONesMerzbt24KZXnM+yxCpNxOb1QbRPOJwVwhYvi+YAQPADaL7gNM1o8DnN22V9bcvxk7JXM6Gjf7DMwgNRpZSlF+YqScnlezHqAvunO1l0/HVDBqWuEDdgxfElUGu2qUVzjfSglAL6252x
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 08:13:29AM +0200, Heinrich Schuchardt wrote:
>On 25.07.25 01:36, Deepak Gupta wrote:
>>SYM_* macros are used to define assembly routines. In this patch series,
>>re-define those macros in risc-v arch specific include file to include
>>a landing pad instruction at the beginning. This is done only when the
>>compiler flag for landing pad is enabled (i.e. __riscv_zicfilp).
>>
>>TODO: Update `lpad 0` with `lpad %lpad_hash(name)` after toolchain
>>support.
>>
>>Signed-off-by: Deepak Gupta <debug@rivosinc.com>
>>---
>>  arch/riscv/include/asm/linkage.h | 42 ++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 42 insertions(+)
>>
>>diff --git a/arch/riscv/include/asm/linkage.h b/arch/riscv/include/asm/linkage.h
>>index 9e88ba23cd2b..162774b81158 100644
>>--- a/arch/riscv/include/asm/linkage.h
>>+++ b/arch/riscv/include/asm/linkage.h
>>@@ -6,7 +6,49 @@
>>  #ifndef _ASM_RISCV_LINKAGE_H
>>  #define _ASM_RISCV_LINKAGE_H
>>+#ifdef __ASSEMBLY__
>>+#include <asm/assembler.h>
>>+#endif
>>+
>>  #define __ALIGN		.balign 4
>>  #define __ALIGN_STR	".balign 4"
>>+#ifdef __riscv_zicfilp
>>+/*
>>+ * A landing pad instruction is needed at start of asm routines
>>+ * re-define macros for asm routines to have a landing pad at
>>+ * the beginning of function. Currently use label value of 0x1.
>
>Your code below uses label value 0 which disables tag checking. As 
>long as we don't have tool support for calculating function hashes 
>that is an appropriate approach.
>

Yes I made the fix at other place where function prototype was determined
to be static (see `call_on_irq_stack` in entry.S)

In this patch, it wasn't possible.

>%s/Currently use label value of 0x1./Label value 0x0 disables tag checking./
>

Thanks its lingering from earlier. Will fix it.

>Best regards
>
>Heinrich
>
>>+ * Eventually, label should be calculated as a hash over function
>>+ * signature.
>>+ */
>>+#define SYM_FUNC_START(name)				\
>>+	SYM_START(name, SYM_L_GLOBAL, SYM_A_ALIGN)	\
>>+	lpad 0;
>>+
>>+#define SYM_FUNC_START_NOALIGN(name)			\
>>+	SYM_START(name, SYM_L_GLOBAL, SYM_A_NONE)	\
>>+	lpad 0;
>>+
>>+#define SYM_FUNC_START_LOCAL(name)			\
>>+	SYM_START(name, SYM_L_LOCAL, SYM_A_ALIGN)	\
>>+	lpad 0;
>>+
>>+#define SYM_FUNC_START_LOCAL_NOALIGN(name)		\
>>+	SYM_START(name, SYM_L_LOCAL, SYM_A_NONE)	\
>>+	lpad 0;
>>+
>>+#define SYM_FUNC_START_WEAK(name)			\
>>+	SYM_START(name, SYM_L_WEAK, SYM_A_ALIGN)	\
>>+	lpad 0;
>>+
>>+#define SYM_FUNC_START_WEAK_NOALIGN(name)		\
>>+	SYM_START(name, SYM_L_WEAK, SYM_A_NONE)		\
>>+	lpad 0;
>>+
>>+#define SYM_TYPED_FUNC_START(name)				\
>>+	SYM_TYPED_START(name, SYM_L_GLOBAL, SYM_A_ALIGN)	\
>>+	lpad 0;
>>+
>>+#endif
>>+
>>  #endif /* _ASM_RISCV_LINKAGE_H */
>>
>

