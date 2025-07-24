Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5B53C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 23:37:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46C296B0361; Thu, 24 Jul 2025 19:37:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41DAC6B0363; Thu, 24 Jul 2025 19:37:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 270736B0364; Thu, 24 Jul 2025 19:37:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0F80D6B0361
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:37:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E46F1113721
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:37:12 +0000 (UTC)
X-FDA: 83700771504.22.58D243D
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf23.hostedemail.com (Postfix) with ESMTP id 00011140007
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:37:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=JkrWQg64;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753400231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CG5iG7HEmzaJkQJOJy5GwPyyfPnsO8eGyVBmIiBheIs=;
	b=NZTR+OG91tzNUAGdhCB/0ZVh4ueLckpswpT6HjetFvnIslIVTrXw1HBK9R8b1mrsyPrGD5
	yggAUGiQRXz7+LreAi2smjMdb/N9KDBRR988b7vfPXV/6pEaxWLItoEvKW/0rsTxkhopzS
	u+eHer5nUS2MOBFAK1TTcXB8hK87IsU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753400231; a=rsa-sha256;
	cv=none;
	b=la1IF9e7YR1x7WnvMV4S8mMYUOrJvHTrxzK5zix1oTrH8tCzqZet+8BJZJIr7qgo8h6R4L
	X+y/xuAIcItkA8UlP6r3X6OqAIFd2N6gkKtBKEJaRVIuno2Ljo1ju+NAw3dGC1+bBXfL7/
	PsMlfcLa50+4UN4HztKszz3s9TW+Rvk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=JkrWQg64;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=debug@rivosinc.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2353a2bc210so15112565ad.2
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753400230; x=1754005030; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CG5iG7HEmzaJkQJOJy5GwPyyfPnsO8eGyVBmIiBheIs=;
        b=JkrWQg64NmYvjFZclfe5CF/wTN646QehTsN+PKrpq4zYww4N++Ne8ZCeVoPkVIS1vR
         gSfxZ0KVUITBKd+gUpBO9YSClsKjC+0EpRHwAVl/J9zW89zd/tcvQYIWdA9WDQO4SJXG
         bt8ChVMjsL3+imxRczTKJ9knV30Ru2oFFrlX7kg2BMSi/exg3r51J19PFgYDbt3iX3M2
         9Ldzd0TzjWZUu7gOZkQaKQN8qnW9sE7Zyn9+06GMRy+KlW2emTsO27eepq0lc5m1L41Q
         aEKIVtcFMzap0P8BH3bQ82Za5FWtv81OFuPDRNWiSlNJmRxluWqDS3oSFTehRYpjnEJx
         YMlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753400230; x=1754005030;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CG5iG7HEmzaJkQJOJy5GwPyyfPnsO8eGyVBmIiBheIs=;
        b=MJqjwgiFFHrcjC7d5TnCohl82mTTwSURAWCcMEOy3EuqS6UPuSfwJUx41opS+NvBB4
         /kz430cYruFhlTfiRkUJKvhUOCmbYlaPzPy83fssImb0jNyU9qQJl8/aTyZPfDVyXdBQ
         uNYQbpxBabCU+I6Ap9dC/EcJsFuzPOx2K8iJNqmDwRB328UGadbtZcQsci+nfIiOtLjg
         pzB4eR2NczhL5SXiSbtIyMFKY6DGtO3OSZrBM7mBN/yAm4noe10HoyQoKlG3b/hZBK/l
         4jPQqO5JRQ9bBUDoCXI7edwwep9793WdB3erl68sXT3mN55PgyDaIcsUkbNT4i1aQ8IH
         QxpQ==
X-Forwarded-Encrypted: i=1; AJvYcCXd3KnQZyMMLUlndQaglT4PJniC9QqVmr+Y/KcClCHqa5TiqzLAyMI2o4pNvFujuPCn90JW3nAfNQ==@kvack.org
X-Gm-Message-State: AOJu0YyBaoWKBYrJ6gL/8YAbkXWTOQ8Yii9eeFk02FmyPkB/CEDg6md8
	P99q+R0B1CanHtWHzRQz7p6lx/sbtGMRKlcbJ/VsygSefddOeuqiJqXhIzrktG53ntjIfhv+HBq
	DU3n5
X-Gm-Gg: ASbGncuqA943eTd8KryOUScpkgUS7Iy9apaFVM5q006cgySzXEWw19FmamuYeAt37/S
	d2SAlcJ69+1pg+gjMBnSndLzatC2n1JCSXynClOwVwoNF7TpjzhH2EWea8tienWDsjLdy5+Tiwm
	GRGj9iiaT3FbA+87cX9mz3XGUqrEz0m3GATI6zCmtEzmYVTUeTHB9uuYCDuRHZCq0Yc/d2JGcUY
	whNk/ebXskPvNiNoA4wRUyG2A3B8j4mam3j+BW0hrjAbV2c4gMnjf/GWbmqt/yVbyx+6j3JmZZz
	bMrNRAXRnHQkokoHL/gOeX4BTIJ4SIfSaOnEt+QSu5DgKLeHlI6FvW6y+cLRoxGR4zDNY5F4vFC
	30UOjElQ/7Vb7ai/gIgc71Glx+gsUYsFS
X-Google-Smtp-Source: AGHT+IFimijtxboQ83ruW5Lf/Edn+u8E7CK8azktAcnwGUUTAe1++zEjf4xwnHFBVkfDbfBbAK27Uw==
X-Received: by 2002:a17:903:2a84:b0:238:2990:6382 with SMTP id d9443c01a7336-23f980de085mr106900615ad.0.1753400229626;
        Thu, 24 Jul 2025 16:37:09 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fa48bc706sm23598685ad.106.2025.07.24.16.37.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 16:37:09 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 24 Jul 2025 16:36:55 -0700
Subject: [PATCH 02/11] riscv: update asm call site in `call_on_irq_stack`
 to setup correct label
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250724-riscv_kcfi-v1-2-04b8fa44c98c@rivosinc.com>
References: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
In-Reply-To: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
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
X-Rspamd-Queue-Id: 00011140007
X-Stat-Signature: kzqxj1je6h634h6uxsdkxy1p45nsdaqb
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753400230-157438
X-HE-Meta: U2FsdGVkX1+HZ9D5G3MkD3D71e9r0rruCCsCCgNxAlA1lQcXtlnQnhPp3aWiZrCt1SrCmFeEw59zq23ygTVSBL2v0PU2jgOQH8QVHGoCXPf/m0A4krgShPCXbmzMfaQI/Dwwpa9+WwLWpdiz5cSWeNMvvAPnCwqAhLF2m2XC2m6kSUCwc1jO6brJSDU/Gi2i7Dq516mFVvsp0zsBZlJ++MuDuLLVd2CqT3m+smKg5eQB1wdgdDyawaIcXopy5su76ZauD3boakA02nAcLXxoyYKCL3PBKGKR6unYz7KIg0e1S/uVMgEczeRlntIt89MeYF1Ww3N5nhquhbFK2EZQrDndddEYqPuiS8qqDdhmdDpPl8RfQKqYd28UKNUTvs9YXxOMPK4RF4/PUqUF+4W4pcOhON0wVZNpf28GE0sQz6VOYoV8mLGlPHWtK3D/m9RucnMqopck8QY6qS6SmKVJWwWJU1uqj6H05ErPfvCQMs81W8cYtu0Eh9odjhpOeiXWKLVYCjtjpJkwC5/uH4cpHSLpiKHYUAMcu372y9T2KrtbM7dh0GaJ48uxmARXLOiGwizzToTWCDTHX4rIelmO9AAKb5oUp72Zm8OeCgzPXhMwHpjYj+BchnDLn2b2OsplIpmqwb0LBwiCRiEuBr3oVVxIKCoYaPgXxEQ3dghegGOAOeTCzK1MXLRr/o088JpcaiwxR2FE50PEn19DoJpTkv8wx3ROFngOZPaXgtpCBm4r7hQFfEeAACh/j1xmfVF1PZEAea/hEF4/dqTesrsIA5GVYAIjUnYr1L2IRKlap9MBjcVGNgdD0+B4g7ooKAaGH9limGntzT9FOoPQ7XCuyqVTiE7dna1zMk+/b5k5ZXIVVuW6l1Q5Sv9ht0VbY/ttdqgJeb9S2T6pPDePTU9Nytd74RWkn/lQrwhHE6U7FWjPzHGGPyKSEFDXas9o8OkQMZ9ZtGWa9v985VeCAc6
 iTE3z4GI
 0TZlxn7rsrQ4meGafdWfr91LAmAzrW341PIf7i4JfxWJXkQc/Atg2bgeyLNt6f34V1RqgN6fOcNTmkYiaD58O+05me2wKYK0fI5AJ07Tq3DB3vDdH4WsrVP3btSmNzunSFTsC/gR5+6RaqXvjPqpyueL085VnQ4MAbbT9Lx+Kf5PxahhsZ00mg0dW4Q/QQL0GaHB6aop//DxT5mLi/0ZlAwSPYeswXaEfnmlMdeigm2bDF81163uJ4JxJ9I16LIybyDxClOryuAEsNGLxEBPsxeq3fxKcGDdzH9hAeXIu4O0ClrtF3KMHHtAdwYk4vUoSLXqRDAm4fhebhkUiK2uVR7dfcsxmyKheLEpJw19qwqVJ1mrT5HcjwarHmBQfXxqNmr7vvaWJKhHxbtlvM2h9GNhd7iCUIRy1Ld506IK3SIVgUfAX0mB9BfenczJ7Tng6W7I76zJ+5wfW86R52E9vXvyMvOxfmFvGFYgS5imP1D0mtY4LLF+TD9bkIZh4giwk1ielMv2kHaUKLJUr/ogWLlGHq8sNnCgt9D3QXHPMtaWe6M8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Call sites written in asm performing indirect call, they need to setup
label register (t2/x7) with correct label.

Currently first kernel was compiled with `-save-temps` option and
normalized function signature string is captured and then placed at the
asm callsite.

TODO: to write a macro wrapper with toolchain support.

Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/kernel/entry.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index 2660faf52232..598e17e800ae 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -389,6 +389,7 @@ SYM_FUNC_START(call_on_irq_stack)
 	load_per_cpu t0, irq_stack_ptr, t1
 	li	t1, IRQ_STACK_SIZE
 	add	sp, t0, t1
+	lui t2, %lpad_hash("FvP7pt_regsE")
 	jalr	a1
 
 	/* Switch back to the thread shadow call stack */

-- 
2.43.0


