Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76E1C606A881
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 10:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=b7rTwYyW
Received: by kanga.kvack.org (Postfix)
	id 874AB6B05CE; Thu, 12 Nov 2026 05:45:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84C0B6B05CF; Thu, 12 Nov 2026 05:45:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7623C6B05D1; Thu, 12 Nov 2026 05:45:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F8DC6B05CE
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:45:26 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D3670A03C6
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:45:25 +0000 (UTC)
X-FDA: 85426135410.05.7BF9CB3
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1257B40012
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:45:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=b7rTwYyW;
	spf=pass (imf04.hostedemail.com: domain of cuiyunhui@bytedance.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794480324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XnCYVNofTC0C6ktldCAu6GTGzm+Q8FA6+tvEuphsY/w=;
	b=Yk9hn5K/rxdxG6b+ZWVDzhg2RNuESjtJyg8+4ZJvTcb9F+EDU5p2fTW8ku1GiXuJizaAfs
	txpWEEAvR64w3He39Elwr2JIGNW1f3Wsr/hhPSBe7CUESuqy9o4OnolG4SB05BSGa8cRUr
	BkgY5QpgYdxU24mXTZdV4MzSMxukQDc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794480324;
	b=iOzyTsdPzCRWO2WQD5x9GRBI8pXIzU6gvzUli/XMH+WM6YXTKtYvWwLnwEq21FR+sOiVFT
	lCGhj55iMzujAMkT0CD1C5j34M5nDAhkkWxIxrTJV6L30blFnwcE4iNLK/nMgJMLcMurWV
	vOO9ASdzsCYVj9+KVmph2bGKhaMGnuQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=b7rTwYyW;
	spf=pass (imf04.hostedemail.com: domain of cuiyunhui@bytedance.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-36dbde64409so8144303eec.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:45:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794480323; x=1795085123; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=XnCYVNofTC0C6ktldCAu6GTGzm+Q8FA6+tvEuphsY/w=;
        b=b7rTwYyWv2KkFMpmSIFb+LnXW/21ABg+QscAhGT5NUMmA7qF7qQUVrm5x24fCn5Ptb
         psfvP3je3B7HPT3Kz6sSB88qsEuiR/12pJZ2MyOxL1T9LMbgmYkDVnf7njrdDJZFt4HK
         HuCafa74sxBdhhCiVRqwBQeEgFIHYdO+7ozgY5noXEEW7JB2Utib7yKp7bvAQDvLxPC3
         YNpRZyt96pEFg6YEfbFMmdgocxM5ybTnBl++rpTvyyJMs02wYrK2X0lU/Q2Bu8t9rtbo
         o+UesazJ2BdmWGoReL7ktyGT0g/QWQhp0vuYvUNb8l+T80NA+u/gbmgJ8PP+7kXTwp6R
         l4lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794480323; x=1795085123;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=XnCYVNofTC0C6ktldCAu6GTGzm+Q8FA6+tvEuphsY/w=;
        b=W6JcXYP/s1kSFNh4kgNSdxk7NLVeh9t0Fqo84/zTYUEmq2qRbvTD51lFtlaAFOGlFy
         FhGmrT4snuNZgJNFhfY5zaA6jXi6Qzrn/Ib2AHOEL7BAHQuXTPmql0uvYVwWDAt+8rQU
         Tb+/xMuubkso2mtW47LDGoU59cKzwIrbaQd4dCxQlko3IMAM/WX5UMs411rbPwFC9SeH
         24VlPZ50DKg8TWojzwHyMN6HXmdOwmc9qI2pH6pBQHjqBPeoDPBLpJBc1u7RFtelEEMM
         Y3Ze8tTu9CrwO/a+4Fk19cbPRzkzWDXo3ZpnkDl/vGYmhZh523S7N2FO7BvEVXN+VSMx
         OVlw==
X-Forwarded-Encrypted: i=1; AL+hErGx9WWw8J1UmiXhtYlZmoKC811K75qAWiHcADX/0oOkLTKr82s51msBcztTXsr3Nqfgjl+ozR1nHQ==@kvack.org
X-Gm-Message-State: APuU4Z9GwYhJGjkFfWDNP07dSq+WVCBBSuicHes6KcUOSn/bmYE4z+hv
	iIkOIlEKcm7s/NkvW+TVN2tseOUR6z9Ioi88fyM+1GLM3PnmD+tHE2Z9cMkgdUA3OLU=
X-Gm-Gg: AYBFou0WjGGONmI/v+fHner0PNI4x+aHCeiht37nd1exl4ddXyoVcsU4PPcvdK9IpSu
	ywKBjV7KPD7A4E1zuGYqCNe40BXIRU2nZVUVkfS2ZMWzkc6w9SzYDoIXnxDVHjqTG77rua2yDnI
	YDZxlJBp7sEj8h/C++i6RLQco6s6NuTJj9tKQVds1rhTlUGpYjKQA0tfqc001DqyllegCQtGLbO
	ZvGwRxpjhlDOOtBkp4VONbMv/u9Jn+wnEq1iEo8m0dlt2KE8VrLbn5movZ2PpcY6ghOwE5/oO2z
	Jkl7B8rJl98w20O5uhn1Xi44qq8s9VOL7viDoW8MhCz+hPxUK/74fQoeMXONecqUzRzqdt9wxo7
	um0lv4qQJmgIqZRBvqB49O4TJg4ofpu6gZ/+2R3aVKDaOQNHmZU3caEI1imii4iuRh2opxBU6uO
	T3RNW/oIIEtT/fCKHmqD3EDI2RMyRgUT5y24mr2WNSFHjdlG67shNgMTiGu5lO+Wg+NZmEFdRPs
	dcWmLQWkY5e55dkDt6/aZUHP9LVovVAn3TGBHmsebkMa9NLOc9HorNPOjJG0FP6RjGqTi9hZADt
	TuJ5yfESmGJF6DHj1rbOu0i/w/q6FG4hjjpJGRWgAFcN+nfEjEh6SuZHmr7NFqUb/Vk=
X-Received: by 2002:a05:693c:69c8:b0:369:fe81:a575 with SMTP id 5a478bee46e88-37686756684mr5116143eec.35.1794480322588;
        Thu, 12 Nov 2026 02:45:22 -0800 (PST)
Received: from FR9WL0RHKY.bytedance.net ([139.177.225.242])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3772121e654sm13228694eec.2.2026.11.12.02.45.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 02:45:22 -0800 (PST)
From: Yunhui Cui <cuiyunhui@bytedance.com>
To: pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	dennis@kernel.org,
	tj@kernel.org,
	cl@gentwo.org,
	oleg@redhat.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	martin.lau@linux.dev,
	song@kernel.org,
	yonghong.song@linux.dev,
	jolsa@kernel.org,
	emil@etsalapatis.com,
	ihor.solodrai@linux.dev,
	bjorn@kernel.org,
	pulehui@huawei.com,
	puranjay@kernel.org,
	broonie@kernel.org,
	cuiyunhui@bytedance.com,
	dave@stgolabs.net,
	david.laight.linux@gmail.com,
	jszhang@kernel.org,
	tglx@kernel.org,
	conor.dooley@microchip.com,
	thuth@redhat.com,
	ajones@ventanamicro.com,
	ben.dooks@codethink.co.uk,
	rkrcmar@ventanamicro.com,
	samuel.holland@sifive.com,
	zong.li@sifive.com,
	debug@rivosinc.com,
	seanwascoding@gmail.com,
	andybnac@gmail.com,
	menglong8.dong@gmail.com,
	cyrilbur@tenstorrent.com,
	wangruikang@iscas.ac.cn,
	atishp@rivosinc.com,
	apatel@ventanamicro.com,
	arnd@arndb.de,
	nathan@kernel.org,
	nick.desaulniers+lkml@gmail.com,
	morbo@google.com,
	justinstitt@google.com,
	qingfang.deng@siflower.com.cn,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	linux-arch@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH v10 9/9] riscv: select HAVE_CMPXCHG_LOCAL
Date: Thu, 12 Nov 2026 18:41:49 +0800
Message-Id: <20261112104149.38589-10-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20261112104149.38589-1-cuiyunhui@bytedance.com>
References: <20261112104149.38589-1-cuiyunhui@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tem1hd6gikw8owyfjt7tp6kkib6fybei
X-Rspamd-Queue-Id: 1257B40012
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794480323-267483
X-HE-Meta: U2FsdGVkX1/qG/qiJcKgAV8gBHElVwiF4kp+5izSxdXwIF1zeJAi8SgHz4hdOMJhAbv/X1AFvo8rONWKlPj42wAwR+dHrOginoIohYK/7XQW1nilb0jY4KcuMOB97ICaAEWTXaRQRnre92FG6oDvmbTC+DI+gB6aj5oMddd1waE9IlyxBqSSn6UBySKTGg5qZ5DfpK0iWQvsF1tn3s09o7tzWX5lPl1u7x1FP6yoXwmJPa8SfSg4XTQG5AEh6aVxSmQhF4BUhmXIp++ReU2ayTnBrXQcoqf4puzya9F4trrZsxGQ/fhZoD8RJZLnXHAXcLkOoUPiU4nRImlwly6Y6SakCDQuoiXvqAFisgd7p99VVublG2HZ855OHOILH8s84AkMbhqJYYWTwPVe0abJZZ084f9ujSDOlC8Ii/v7OR5FBDhcDGW4Dmkw4Wj/iI6k8HyP9hGm89zM+Jx/jt4lV/MNERdcnEIk01mvv5EtPUXps70LdxW2LD/EK8mFuwAMi2MgjTJJsH48kkFkY5mBB+2B7269dE+NNWTp7zgj8NyMWtIZ9IDZlaWlHGrhepzH9zXkdbD+UCiugovI9TdVSRRLy5uPYIxw3PJfblK0KLvoNNuLu1TJzkZx8r3VRGWjix9spx4CRUG9O1Gqio5Av/D1sAXPDvzgouMTki6/qFGHw2R19K3q2tjeIco+fS2Ch+kAE+qbzx/h9yyX/P8YtdHtC0D8e8KcNLc9Eax89BBnwP8aTdnBpd+VgQKkFbIe92UHlv7KedQ7bBjwdmx+CwNDpMnfrPlVaxIoUgZxD9GGkyMOSKESrKCk5mJG/FbtHWl7By1Jk0I/q1tPzOA12Lj6lo5/w7DxWwVDNtzF0Q6dFvNjsVA1FnyTEYRL76QZodOcwA4IzYXxeICfeX2Xn4bzeliOs+hNWMIcsnWmAU1oKbRZ6Q8SsW0xIdQ2rvXYwhC9Wxhtxudhaal7ZOg
 IpDSKJ2c
 SLpXpl6+kyEctxsDzX9MEHaf+WXVTiGZcrfxFlnjVU7Y+gJ6+JpYTlvH76AsAK20cRn1VQu9wex2v+aM1JHy+2Qim6cp38cCUgdfHzSvhan98okEDCExEMsEoJxA9LSSJ3TJ7G3G+cFdvyIHhhqUD/EWHgI2wolseHw6kEWdn/+w3DRooPfciuCfT0HuDQwq5BojgJfmdDHOOuV4uTo8/cJ6xUJ2fYMLCJKzwkSYf2j2VrxRyqOcpKXVssWpTs/Pvhr6+8FYWAQtXQECR6twdQkeSuY9EYGkzWgvC3HmLim8g6/QrQDVqlmY3ZGD3sSoFZI/LFFaNeCNezLX2/UlOjYwjcPmxyIVpcTV/oJ2ZrSImVs5QUE5R8NkE9sViSfQFx9kfxv2EnoADjP7ZabWLc/6CWubRaCWgUFW4ayxd2L+doLC/LrWHHc0o+ayJmCDSj5/wFKp/2tn7scf32wFrR2pcSV0HoHOPsG4IYHNe7kTyJL9ILAi9MBBw6Ti6eOvY6QHWPkQbuCbKtdjJu4mjcVAE3Vgi3cHgfciT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Now that RISC-V provides this_cpu_cmpxchg(), select
HAVE_CMPXCHG_LOCAL so mm/vmstat.c and lib/percpu_counter.c can use
this_cpu_try_cmpxchg() instead of serializing per-CPU counter updates
with local_irq_save() and local_irq_restore().

Suggested-by: Davidlohr Bueso <dave@stgolabs.net>
Link: https://lore.kernel.org/r/20260826010748.zphu3wh2hlm4t4o2@offworld
Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index bde1f1885038f..458ef01e926a4 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -155,6 +155,7 @@ config RISCV
 	select HAVE_ARCH_VMAP_STACK if MMU && 64BIT
 	select HAVE_ASM_MODVERSIONS
 	select HAVE_BUILDTIME_MCOUNT_SORT
+	select HAVE_CMPXCHG_LOCAL
 	select HAVE_CONTEXT_TRACKING_USER
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DMA_CONTIGUOUS if MMU
-- 
2.39.5


