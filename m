Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA07EFC6171
	for <linux-mm@archiver.kernel.org>; Sat,  3 Jan 2026 08:48:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C4576B008C; Sat,  3 Jan 2026 03:48:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A1C46B0098; Sat,  3 Jan 2026 03:48:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B86F6B0096; Sat,  3 Jan 2026 03:48:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F09356B00A6
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 03:48:00 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9376EB6B50
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 08:48:00 +0000 (UTC)
X-FDA: 84290025120.05.BE28003
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf21.hostedemail.com (Postfix) with ESMTP id B20601C0006
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 08:47:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NhKCdfq7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of ming.jvle@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=ming.jvle@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767430078; a=rsa-sha256;
	cv=none;
	b=3dObIOt73GLIT491oYItoPoYJfGr4jdR4mJXCXwp9Ra0IxklfSjDSaDdMv5hbDXQZFEKst
	RnUObi3GJb1ZzMX/4IoGlYYnj9V/fx6h0cC7UE1FkaXozodmcmCgNJggQwqcKsjwWLA0TN
	mceN/dgNdo3czWXtmbDX5OZO7MBmNTc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NhKCdfq7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of ming.jvle@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=ming.jvle@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767430078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XqmOWnbBqbw0qz0iwR261elwKrPwnP+8eo7jB++6bUk=;
	b=sO4G86z80xCcOugiRlE+gsstVZV8hLOWbwlmdNjFMHssrWs295XnPTeDeSmBzh2HMMeUAB
	mV717hLF9+0s8BnMoYWSkt9j6z33MdXIu/AW+9k3hv1V9CfCnXGXF/3HXi0sJC54ihzAGA
	noWe229uPR0KdzvsAPcw3lEK9QXx7Ow=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-34c71f462d2so13397449a91.0
        for <linux-mm@kvack.org>; Sat, 03 Jan 2026 00:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767430077; x=1768034877; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XqmOWnbBqbw0qz0iwR261elwKrPwnP+8eo7jB++6bUk=;
        b=NhKCdfq7nkgWpTzNq+Byd/tCXPSRi5yMd9OiBFH4VTm8SsH4q1byyM4pcB9ezo/MP4
         n7ExsLvkfs2O58CYNeGqO00SdGE5KajePbJrMAkj56PSFsOjaLpawfdrdel4Xdj9tNlG
         VQolrvqVLh2CdyKVarEfzk5aSjKa98n9qpLMMntVC+eX1c+7hKH6h0aT1PThgdJqdoLH
         g65VU6fYbYKZ0tqpskcrxttE7g6C6Kih5j6PRxLMl4ETc1ColxbZj4ggV1DcPtBg3XZ8
         3hy2u+888623MKWbgoqtCRbv1TV5J0qFRa5tVXL1ILhSHEETpnFIadhAkotJnsTDiyFe
         0dgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767430077; x=1768034877;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XqmOWnbBqbw0qz0iwR261elwKrPwnP+8eo7jB++6bUk=;
        b=mv3yzPOwE3CRuY/IkIVgCA1F6d7rbAAphsFU1QCgRqdWH3BFSvgAdtIQZoMaUN3UUN
         3JeMTEs1RY3OZX+HPuaLFYeE2p8oZfCpIXQno8MQqYPy+sK7Ktuet8kn4Y2p1UlpUYpp
         /G0zASf/+2pfhx4GY8fhhbDub5ol3WxjfpHuNgYUIFCGIX521WfCIYcuIcvGdZaJmU74
         kJzeAEt+UyOPCu2bffWdeMDedW7wqvyacCx1NC8eN8jWxrMy4fN1EhJvOvwD3qqgWX/w
         Hwxh1eGofUgvQdLBXV28TktNbJnM762dZGx7Ec6BXWMo/giuK5ToWS5qSJkHzCdMii1p
         pgJQ==
X-Forwarded-Encrypted: i=1; AJvYcCWGcwg0+4Ja0DcTAP8kLRpGMcdqG4yYidOEI13NalJjrNatl15Vv/hheN65i3i8sgbifgbRdQLh9A==@kvack.org
X-Gm-Message-State: AOJu0Yz56xPnZA4gh070o7apoWBdyNHVGeBHUtvVBv762Yr+z88KHmJC
	JYTNYykYTIfYtHuMdLPZkzxBqgrj0XZh9scc38FMXBtdQPS+0HuURfnX
X-Gm-Gg: AY/fxX7blfLJm1bh/k1kB7kQ7ouYdao3B6HodiLyf7oFarabWfwQ4SKHZ1tcbwWqBo1
	6XpqjIXj/dzHzxBz4NS+2reNjh7vDwH8sHvkr3lBispkTmlUdycUO9XMVohuI+h6K35p7wJ/hg/
	9G0bgUjHAwO86bszik9qeZe5vjIZtA+ZBOsRrHpZwI1ybFz/YpK1qd0i6LofMbvs8XpuMLQngJg
	q5LjwuGAKmU9wwVG2Gh1Sfv7bVWICDl8CDwuR/+UzMcHUZKaWfhRqehc8ar8ntX+BIpeH90fe0J
	4RSZvvn9QM2fcScMmGBoMVw7YF33k+5CkNNfdDX9HNVKImWDxJ3SphJvi4H9Paz9Vfc1AWFHFCB
	LspHZAzSrJA+Tg1e9AMofYXFzkdTBK9srJrIAukoK2NSyX7xL1gITOgm3X7egQJQJfN6SWG9UV+
	56lzAKo85anQKIGFBI6QX+5bQZEq5hmvzRY2M=
X-Google-Smtp-Source: AGHT+IH4FDI6MNb+jt4Z9VqoK4GzC1dQlMhMQECNsnvlTczu/ydbQzhhClMmRjiO1aySaBttAjLuTQ==
X-Received: by 2002:a17:90b:548c:b0:330:a454:c31a with SMTP id 98e67ed59e1d1-34e921e90e0mr31635393a91.32.1767430077312;
        Sat, 03 Jan 2026 00:47:57 -0800 (PST)
Received: from jvle-ThinkPad-X1-Carbon-Gen-8.. ([210.73.43.101])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e197983sm42704939b3a.33.2026.01.03.00.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jan 2026 00:47:56 -0800 (PST)
From: Keke Ming <ming.jvle@gmail.com>
To: mhiramat@kernel.org,
	oleg@redhat.com,
	peterz@infradead.org
Cc: linux@armlinux.org.uk,
	catalin.marinas@arm.com,
	will@kernel.org,
	tsbogend@alpha.franken.de,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mips@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Keke Ming <ming.jvle@gmail.com>
Subject: [PATCH 2/5] arm64/uprobes: use kmap_local_page() in arch_uprobe_copy_ixol()
Date: Sat,  3 Jan 2026 16:42:40 +0800
Message-ID: <20260103084243.195125-3-ming.jvle@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260103084243.195125-1-ming.jvle@gmail.com>
References: <20260103084243.195125-1-ming.jvle@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B20601C0006
X-Stat-Signature: ybud45rmw7ikb9n39oczqjg8bxtqxk8q
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767430078-404112
X-HE-Meta: U2FsdGVkX19LQooBF3qkd0mVeDmkag0lEe+ECKNgDh+8fmF2IG2QIHt5twD0pWnujbF9cU/tCS8/eJVx/btTgTCZ3wokyEdd2Ow+dzm01qnGTsq3sdSrPhxcW8nW0GDCQCc7XWZ7ho3r+J9H6KxDhl8b9MaRHIXNM57XkY/5hBEPuFns9VjGl7E86nwgjhov/0mkou3/jdQCXEsq10a9100hkk4Tat6tT9Tc7TT+NPDRAZ2KuX4GagHVcLs8BbWefY9KBLiSXyxUpUH9liOwjQuHHj0WEbiwDovk2FsSxVqJ9uuN5v22UoAlTy6ot/IcXSHIGDCJOueB8tvacQAxvpTMWtzSwfASFLEYTTqTaMS+Tz+9P2okiLeD0NZps8BhoIFBcmn1aJQglYDqrhDfOyU2zjUYnxy+B3f/aAA0997OWCYsYHtzNTvFr0zLp0a3Wrn99VV8CIixMoIbYDBtODdq1PT8OOD55oXHl748szjyOo4NUr02/ANgX1iIfGbPw494gjGT9R1ia/ej57Xtm5+NcR5CssAtB6cuEqKRuXzkptFaV44dG9DAPIUVtQUiltlRrN/3m6FeicPWTjw4iv+cOGu4jdgkUFl4aMisAlWizHwE0u3+LrivkchcmTtCYxsva0JRM9SxVCzOQhaDnGlUfeuQrXexlmAgXe9WQf5BjMPQJ7nDVNWCXnPiPUEHLBwJFxDSCGwm8Dv33HdZmoIA7RBqB61iy2YhYkSiErCyfjopm6zmGSDVhmT/wBhhRtUu4EvxFn2BDRAhmd/5H+5yaEP6hx08hXgru23RAmBcPylpGqqx5GUtcj7a4PCL+1VJ2NirHB5w4SRI8+CtMgGzMxole/Gh8Iq6nJPHVbK8vDeQ2ESKyh3f9Eu+axRDmmYaK79sko8gmMVzTCZQz9jEh04ya66LL32bTBVvyR1L94RzFngbr0x3yI+SFoeeN8LM5Y1IT3jwUlldTVP
 K4jkrMHv
 dm6aFcje14MWqyUrKjbuxZ6KVDBFrUwjDGnV5WUNjrjsetrwitYbWLRnugB1FXYd4VcUTmBc7Cah9aZWH5oBXTJa0LeJ4+zE+7Gj/6e0NEG4TXsLy99/J4b9E67g92EBchGP5EIKcobspkCyp6BMmTCEutd9vbMIOsNfYcmD+Spy4FgLdppJMw5Ix5k1ioq67AswgCPIHGdV/JrZatek/inzDkkNSRDNftv3SOpwHF8bDJKEkEnd7vl2HxlvS526q1jFsx4l70C1rXGFReaBO9oVxbFYfwwp1J2UjY+ciPwFJc7yWlZj2SeWv8VnP5RIbHYMiEqGe3V1wwfe56Vw7ShsXtuEp6ceb1fysDvdZ7RJLHhc+oz9GzpMlpw6BaXXd38MiVGh1HlxdoICJ4PF7TMlt07zu8+qFbXg23JCo58Rg8QQQr7y6/4SrSyjtkyT701HhPI2ph0K3aVOeZNVp7dYzZT7wIls7pfUmh/cim17Rxgxnfi+yhVXlijiqrAB7t6ZAif1HVrZ4VZw17jjeh22++KfY8JLt8ms/i+kNoKFcH1qbaltuGvcyAg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace deprecated kmap_atomic() with kmap_local_page().

Signed-off-by: Keke Ming <ming.jvle@gmail.com>
---
 arch/arm64/kernel/probes/uprobes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/probes/uprobes.c b/arch/arm64/kernel/probes/uprobes.c
index 941668800aea..4c55bf832ec3 100644
--- a/arch/arm64/kernel/probes/uprobes.c
+++ b/arch/arm64/kernel/probes/uprobes.c
@@ -15,7 +15,7 @@
 void arch_uprobe_copy_ixol(struct page *page, unsigned long vaddr,
 		void *src, unsigned long len)
 {
-	void *xol_page_kaddr = kmap_atomic(page);
+	void *xol_page_kaddr = kmap_local_page(page);
 	void *dst = xol_page_kaddr + (vaddr & ~PAGE_MASK);
 
 	/*
@@ -32,7 +32,7 @@ void arch_uprobe_copy_ixol(struct page *page, unsigned long vaddr,
 	sync_icache_aliases((unsigned long)dst, (unsigned long)dst + len);
 
 done:
-	kunmap_atomic(xol_page_kaddr);
+	kunmap_local(xol_page_kaddr);
 }
 
 unsigned long uprobe_get_swbp_addr(struct pt_regs *regs)
-- 
2.43.0


