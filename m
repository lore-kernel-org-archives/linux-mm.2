Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C870C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 23:37:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 188AD8E00C5; Thu, 24 Jul 2025 19:37:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 111978E007C; Thu, 24 Jul 2025 19:37:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF23E8E00C5; Thu, 24 Jul 2025 19:37:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D95A98E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:37:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8570D14056E
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:37:24 +0000 (UTC)
X-FDA: 83700772008.14.DDEF024
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf02.hostedemail.com (Postfix) with ESMTP id A28B380012
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:37:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=UdzlGu6B;
	spf=pass (imf02.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753400242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yl+fpaUgVvAgmSBmN0Uf0wW/gDpMMKoNCvx2z4Q9Om8=;
	b=IluVlTOOytT0d90uep1HHf1p5PVzayWvHb+DfRzBPg0VaNFQ/hxygujDB37yvt4Sg1eAy4
	aFufgIuR6AcEecXdZ8vxZ7s+VYjAGZkZmWxx8lmUOw79To8rZwyzUKI3aiwF+YLCS+1acK
	62OexWz8XUd+XKLVIzmQ1//djevPB1Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753400242; a=rsa-sha256;
	cv=none;
	b=KSfozNolXDrDBUxO8GJitMpqZsLgCKAkevN/dFyVd7MvSiCCI5OF6qliqiAUEvS8fveohp
	AcuebzrnclegZ9Nj2f6X88GCVB/z01tSsf8tsYR4jRpOwei8RflKF/yE3Dj0UWfLfUDZPo
	tEAS/E1TPM/idXB/j7vbnsxXYyo3P/k=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=UdzlGu6B;
	spf=pass (imf02.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-23636167b30so14482285ad.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753400241; x=1754005041; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yl+fpaUgVvAgmSBmN0Uf0wW/gDpMMKoNCvx2z4Q9Om8=;
        b=UdzlGu6Bfb0GRnMIGd8dFocbYYChjLyjMyVEqEmK7OUDhz2jYBKWCLd9Tl3kyg0zIt
         lCjLWOa5o+vB2334KSET6J0lwoUvx40I+boaw1e5ouvzU6c4Dk0RzPV+NephhBikS060
         uoFsgNkhAEW76aPgUAoG6mxNbT/fR2t/PymrBh8/aq91O2G3cGfN/tJ2aWdIUswoajYX
         MIzFUFI+nG63bPzYeXJWRaLSA3h27Ku+BL+watfymiAYWS6pbfw/UPdVp6FY6pdYrycH
         Jta0PReldRR2KY1KhNAyQXnnf4CRPnhdAGpmDn+lPxJVK3ldWgF0wWH4v23Sv1ONLVgr
         3P6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753400241; x=1754005041;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yl+fpaUgVvAgmSBmN0Uf0wW/gDpMMKoNCvx2z4Q9Om8=;
        b=YpA3UmS7dxhR49gmtl/e68FcPLmeAzSuHl8N3ZhYwDphzFPPgAanCjRzs4HLiGoA7l
         ngX5DzhMdtbrEF2sxlZcS2gwHjchfJpVhsCN7uIDSXSImckbL3lI92s8QM8ML7TtU35e
         RqR07MvqtqLshjQYPUQeY2d0iy45Zur0IpyHqLJ2AWZ3x841Wwyih/tvipwHv8K617wi
         eyZ70K7Q7wknRKdABwj0Q0IZIM0eGVnJT1xmTGPxDj5vXPLOBacJhhjzNXbg3JckLP4S
         SJfi11kcUJFKHKipNWZJofzG3ZOXonLk392BgTVfYrbdMCQ9h8sg0XX4oPGLVfbYjjke
         p7ZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUGASysNi85HCtG6ctLEOsZmaytxQwt9Q+/rzCNA1Yp5/28/mws29sTWFVA61aB0qbDbwaIv93+kQ==@kvack.org
X-Gm-Message-State: AOJu0YwItk4uNUCvOYrIKX4HvYDmkFPNSld2m7BwMAYs+e2wdbsyUIAP
	NMLfDSBLW6Y/inxlNOWUuKiNBk+jlBUN/6iXGSKWq8OQpLJdNjzzJU5LgtX6laRnaWhlACzM/5u
	1YcD+
X-Gm-Gg: ASbGncvk54jLa9IbzxzqvU4MZZVaLzpUVfrDaL8pG8Svcnb6gNggKUYZH2lmICZvUtK
	dsURZxoj1U0MWLGSsnf0c3PzCzUl8I9ASHsOS6BTlRyd5rdzHbXzdFQXIBOFjf/LnqFIjS82iuz
	AIl7rYg9DHHAsjkuQdoiAEKZ0LihGx445N/Z52r9bQhcA8/xA6+RmqmPMtc6jOOY350xwDQOfKp
	Na3efeZSejabuPUdhUiU60ap2X4cyr3dZ1Ww1ZadOxXE8Sl1mnngAGhlaSykjzA5yxKrUn4JY+I
	k2AxDV9C0jV1ELMDFF5C/m2yTooWYAAJLucnz0oM43ytd15e6dISQoTul5WDC3RnMsD+9ewanYP
	Bv3W4DB4boPjS4RBlPGB97aouXphh0c6f
X-Google-Smtp-Source: AGHT+IEFvddaBDkybC2q7ob0zwYNRuGaOi2n4X57ciJYKI00Yd6EYfDqXnoJ8jUoGCKUz8NAesStww==
X-Received: by 2002:a17:902:fc48:b0:23f:8df8:e7b1 with SMTP id d9443c01a7336-23f9820d012mr133037965ad.32.1753400241217;
        Thu, 24 Jul 2025 16:37:21 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fa48bc706sm23598685ad.106.2025.07.24.16.37.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 16:37:20 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 24 Jul 2025 16:37:00 -0700
Subject: [PATCH 07/11] scs: place init shadow stack in .shadowstack section
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250724-riscv_kcfi-v1-7-04b8fa44c98c@rivosinc.com>
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A28B380012
X-Stat-Signature: wssh9fx4iqip44i99suob7ahipapfju7
X-Rspam-User: 
X-HE-Tag: 1753400242-892209
X-HE-Meta: U2FsdGVkX19JBpVSpnXw0RlqrxdhaD7qiSw6ve1G49+LTjrTnxYUGaVWpfyGFN1A78Q2YElvjFAAk4bO5H6pUPjnpOEBfO9vM9AQD5Ij+hgokRsEsxyzB5PN25KqVg184Nw33gOwrv/WeEIyWJErBzO6knpaulYd7AdnTXpd4rlUlbP4ftlysV2KFZmFFvadMr/LtEFrsilkHHJqhdXovnhDf5PvczXK1rEZYaK9r2B8sWDOiYS+2ULZP2T4JI2FUSgNs/DkIHxroK5HpL3VIocqT3GQdOF1Iwf/qxcPyuEq8C9efnOn2l7tga7Aqm2QT4m3C8GuA/oKS8Q8v11rBfBIoCBD2KfQjLXGueuB/nB0mTQXMFKEXwGuR+x9W3okBqCmQFbwsASBea896mbruLAiqzgTRoIV64Q834ROtaglNGwXhBWc5SwUYLrUSTh0NO6m/oga1AfNbX8yca44uWBuK2TKrIlbZFn5w9cu4lUOgg73EjkO9ElsZ720NUfXLDAWQLa+wt9mi9IeDI9paxqi35pORz0WymnhRluga0iC1WT2WDNx4dPBWpUnYK3AX8WQSJGJ5KsvPykgGbAOlYF9jQ+oBzrm8aY2Na1kEW2PUB2sJL9lIcS5QKiFLJH9jr624/l5A7APhdCcXnKaC2+iw0kLso+vAjCYYExlk/Ai72uqPN6pBadmwv7twvhoyfQcMLfIb9PUw9czNH7CxZAOYs5O915fQ3RzgSUt5I8lwQwm04kGofRLnZTZmmtpZ9mMeeIPLfH1sdT2u2/NH1iyv2XC8PlhXa43nF47vxIv4GnG20JznXFRo1aUMTSXu7mFfZIzyy7fHbKykydLOFBGln4ujbLRTaCVJcAaPL/xUoLKmYSNuyaPI5DIoM3fx9XpHssFMmsBSV0O83Qq2IHoMnGp8A0F1lceQf5jAKIioyWezOMvCPqjOQkGD1+7ekhujEEkCi0pftUQww5
 I4pdna13
 Ojf3B4FoOxGEkrLIQeW39EzLutvV9zmAiNT+WQ/D34XCUZeqpirCWwIjxF85Hrkm0mSlhhYBK5ACeksfU5lhPNgC45G56R6dSJIjlF6DGGyhtz3FqmVdgpgTHU8ycolTaCH9PLWL74dgf3h0+7al4bTmnzAcIgyo3LVFRx+Y8AhC48AKprFQDpKS7y900hS5AsHE4NrpILMkmXVA6zk91hoFswtUphRa8IzcuSS+xPF7DqWZl++Hz7b5bxkzoyXrW/+rIE0o4mNzTqmgqzPeBcpsjbZcRUO3jaBdpDaaJb2JOJVsq/kZCHjUF/M7zbNCnfinAxH8tgpcZAJeo/27H83g1FKtLYLWXpiOll3Z+LwPdryZ6P1i4+6yBdwIm472zLduNoFN+466bNYbfwF9LIvCCeQzIKyjlPTD3cXCuXrxf3ETJeewUF3ppxNq0Wm0czmz8qomiug6FccyvEA5EwbgIZeAo0jzMl6o3rYxvI/Agw0Ibm3xvW3svXu6gZ5KOtGIceB3vG+pxEQRVAm9dPNWK+g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If compiled scs and arch kernel shadow stack support, place shadow stack in
`.shadowstack` section.

Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 include/linux/init_task.h |  5 +++++
 init/init_task.c          | 12 ++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index bccb3f1f6262..a2569cc5a7ff 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -40,4 +40,9 @@ extern struct cred init_cred;
 /* Attach to the thread_info data structure for proper alignment */
 #define __init_thread_info __section(".data..init_thread_info")
 
+#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
+/* init shadow stack page */
+#define __init_shadow_stack __section(".shadowstack..init")
+#endif
+
 #endif
diff --git a/init/init_task.c b/init/init_task.c
index e557f622bd90..e21af9db5c09 100644
--- a/init/init_task.c
+++ b/init/init_task.c
@@ -54,10 +54,18 @@ static struct sighand_struct init_sighand = {
 };
 
 #ifdef CONFIG_SHADOW_CALL_STACK
-unsigned long init_shadow_call_stack[SCS_SIZE / sizeof(long)] = {
+unsigned long init_shadow_call_stack[SCS_SIZE / sizeof(long)]
+#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
+	/* shadow stack must go in special section */
+	__init_shadow_stack = {
+	[0] = SCS_END_MAGIC
+};
+#else
+	= {
 	[(SCS_SIZE / sizeof(long)) - 1] = SCS_END_MAGIC
 };
-#endif
+#endif /* CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK */
+#endif /* CONFIG_SHADOW_CALL_STACK */
 
 /*
  * Set up the first task table, touch at your own risk!. Base=0,

-- 
2.43.0


