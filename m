Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87EDBD5B87A
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 01:47:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 001FE6B0089; Mon, 15 Dec 2025 20:47:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2D106B008A; Mon, 15 Dec 2025 20:47:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E43D16B008C; Mon, 15 Dec 2025 20:47:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D0B7D6B0089
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:47:54 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 78BC958C82
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 01:47:54 +0000 (UTC)
X-FDA: 84223648068.05.5F32664
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9D24AA000E
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 01:47:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Hiwo3G+M;
	spf=pass (imf25.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765849672; a=rsa-sha256;
	cv=none;
	b=lzRMMkEbntahnPcKKPbCCuWGFBeRrOcg3kY2mspRtwRCoIEtM47mkLu/9cFSoeffeaXyfo
	wnaP9h2lDZDubI2yQQutZBD0tjV2P7fplNfhElHUJgibu3N35t87v2+e7C+iuxvLVTyhtl
	XtZ5tTvFr6Eo3rSUAjdYLsyoyau80NM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Hiwo3G+M;
	spf=pass (imf25.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765849672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HQt8uoJWMBYj/YlVtM/kz+RuiqvE92xrlYMKIfu5C3o=;
	b=dzcESsgPEM3OcU7jK+RnKYF+wOt2+hYDnWGQO00J1BAYYcOvbXo42AEBNKB2SvGNhASuL/
	LCoe9H7nP1ApBaBYoRBiEnVIZq6gDeY5J/5tUD/ddd+iXGU9l1HAqPwz5nAx6rymZZPTVF
	75Rog5BzwKxDybE2QpY9r75zPrWg9oM=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7aa2170adf9so3237563b3a.0
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 17:47:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1765849671; x=1766454471; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HQt8uoJWMBYj/YlVtM/kz+RuiqvE92xrlYMKIfu5C3o=;
        b=Hiwo3G+MKJxAtI0QtPOzl1GGjtfVah98/udhmL/fnC21DC1UYEQdn24UuZz2gaYeYj
         7KY7OxhCg5tZy0H8Exlv1GrkdSQnuB+Dxm6mSsvBNWm6GiVngZYF6mo0wx3jZy5zoxNt
         AQiGZDsQ5fBIaYgTT3wutDP/3aF0iwJIS/xq1XD/1PnpK1I4d1ABPdpywjwT0ezB7MzB
         fd9yJRNQ1Val4SKiXejOKhHD1VpyzsX7o1o2q/+P7S/KGvV3vRWe+kxcpUULUNVtcgol
         JGkig4JTLKv3y9w9ZkEBDyG2dBhCRenIH9GMYqP+INSs3A6qSJhZa2RxD9l+A6G2tl+g
         Dk3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765849671; x=1766454471;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HQt8uoJWMBYj/YlVtM/kz+RuiqvE92xrlYMKIfu5C3o=;
        b=u1uiHDEy2/9XX4WYWPQ5fS3x/NGbIFuEgzccm5rBcJDmF2CGssfeDDPF3A6DMJsbLi
         rKstyzV9mjY5ka/6n284VziAQTia/QKMTDhfe2qvMEeea4e7x0RwMS2fBAFv5UkSkvu9
         ukcN9p1jAd6/4iMb+kZOyn65Gxgks+EUPGT7AkZB9WuntlOG86wLLS1zhzjBNEh1z4UD
         azY5pBpptF0sn9Bsp4tiuGzkU+HeW/abGHPdnXQK8tK5w97Ar9AtX8P+4n38SIz6ms9m
         RNmk18+x9QRZy1piMps7rAwRHY96P+erf4ZRZD6C502lGt5u70xkuHVjZ89kHqXeKAKY
         UetA==
X-Forwarded-Encrypted: i=1; AJvYcCXVtd/TtdV6dLPqBV2W0z1fPMK62DXaOqO+1W91+epSNlnr5EtJTTSinNf6fnDs5YqedTmsTYvqug==@kvack.org
X-Gm-Message-State: AOJu0Yx0CExRBd8lGfHQU9gbY08l7Ouetvy5OfyBFmrszhqMAGJ1KWU8
	2ar+b2dlGFsJN+YbeMXG65Ak4Fapu+7tKnXXe/CBr3sI14GQAg30DgL87YfKCd62XeY=
X-Gm-Gg: AY/fxX7bE6d+IcwSeAVxIk2g52DhcfFr9xqprXnQsHpK1fLo4XzqlubX0BzsCbB7fxm
	lSYDqLLr/+AEyNypDqQ3RPkRkf/zZR56PY3vnx7yODjlamEYu7iiGHhXp0O7iLNdWdbzyq5iE0B
	ZnyK3N6GMOICsfPC8IZXGt6w71B1+Qz2aIq6v8uqA0BR/H7mc4WWYMqRdNLuCx0xZBE99IfasCf
	kJWSXQaOHjP+qNI2GHc/zyuRe7Emk+xTMD61Vij28YrL/U+4ip0dQi3GHEQH0DIFoILI1S2Ed4P
	KgAYoD5IyWsvuaRyyqHma4gfp84CF1xu8a/kG0NVxAYRQVageI9AtVuHj3stfslpEFmfGn93F1c
	ddLNZqZ8S8nYE8aFmi0Mrvkk1e6wafdbwHmv25BiFbzD6k+byxwJP53VoqNU8m4X94bo642sIPu
	PKh53zUZdvbnbcEd/5B+90zkhjTMi8DdXQ7hbb2pCAzvXO
X-Google-Smtp-Source: AGHT+IE5/ROoI003OCaxm/0k3SuDfxUIEDBUTPu0GmjjWMBKr4s+4vh/dmnl09LKvowuDGy06jqmLQ==
X-Received: by 2002:a05:6a20:4320:b0:366:14af:9bcc with SMTP id adf61e73a8af0-369afdf778bmr12452247637.66.1765849671148;
        Mon, 15 Dec 2025 17:47:51 -0800 (PST)
Received: from L6YN4KR4K9.bytedance.net ([139.177.225.224])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c0c2c963b53sm13632790a12.36.2025.12.15.17.47.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 15 Dec 2025 17:47:50 -0800 (PST)
From: Yunhui Cui <cuiyunhui@bytedance.com>
To: aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	andii@kernel.org,
	andybnac@gmail.com,
	apatel@ventanamicro.com,
	ast@kernel.org,
	ben.dooks@codethink.co.uk,
	bjorn@kernel.org,
	bpf@vger.kernel.org,
	charlie@rivosinc.com,
	cl@gentwo.org,
	conor.dooley@microchip.com,
	cuiyunhui@bytedance.com,
	cyrilbur@tenstorrent.com,
	daniel@iogearbox.net,
	debug@rivosinc.com,
	dennis@kernel.org,
	eddyz87@gmail.com,
	haoluo@google.com,
	john.fastabend@gmail.com,
	jolsa@kernel.org,
	kpsingh@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux@rasmusvillemoes.dk,
	martin.lau@linux.dev,
	palmer@dabbelt.com,
	pjw@kernel.org,
	puranjay@kernel.org,
	pulehui@huawei.com,
	ruanjinjie@huawei.com,
	rkrcmar@ventanamicro.com,
	samuel.holland@sifive.com,
	sdf@fomichev.me,
	song@kernel.org,
	tglx@linutronix.de,
	tj@kernel.org,
	thuth@redhat.com,
	yonghong.song@linux.dev,
	yury.norov@gmail.com,
	zong.li@sifive.com
Subject: [PATCH v3 1/3] riscv: remove irqflags.h inclusion in asm/bitops.h
Date: Tue, 16 Dec 2025 09:47:19 +0800
Message-Id: <20251216014721.42262-2-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20251216014721.42262-1-cuiyunhui@bytedance.com>
References: <20251216014721.42262-1-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9D24AA000E
X-Rspamd-Server: rspam04
X-Stat-Signature: osumoioftz8kgxmc8szytnbjhb8hgn1e
X-HE-Tag: 1765849672-458319
X-HE-Meta: U2FsdGVkX1+SIiMVCcApJQvwFDl6G2JVU/tNECw6EW09B7j0PKJww4kmJpvAKQ7oVQDHC+hRhwGOj9MWQi+DurR9s/K/k/ekIW8fMhdCULPTYy6B6zMxtW95+ZjKWx3LoSCYCGQp9XwByBDqnOQ+ngNH7gXfh6z0o+Rnw6HtTeVbbyIpjrWwu4v27M0Os8IuLWH/TPJzVFntuIg3gmzyKWeE5IKBhznhj9qHNptq5A0AtlnjejAPanj/pNglsprO3llOI/M7QSK8vgwawMLDGX/Ay69qLin/IqcRpLCEAuyVFHeMCLvwgfXfFmltZeafMreRinKZ5Afqa1kexJ9vUmxT874Br+CvYWtE91LyAqaX9K4878mKsKRbybvfyGzvl1iomSIl/SOR1eCTv8QQt5F/rm4ls+hDwkjY+unvCiVmEKCwIc9Seb8vS9L5cwvYLu97vkJZnARLRw12JOyc47rOnCpTvcJ8uDZUX4Yu/qv7XkTWn2pBahm+E6n/wUBpc0dIxgWPPUcIaKUlb9xgudxInTTnPSagrb5GLoXAXn71w31Q4+kE+oy+3NW1w0FXXUiF02SMQxbUbBdtzmyegAvGqgUK/lkIL6qyxKpL9aC/Z2G0ZRJR+0hx7CK5z+BjaHU7NuAQbSq4hok3Szf+6ilXElQVaC1sHq7n9rUKT959r/U24F2MrJjiHNy9jWAlbkr1ax8yAlEvxrm4vECLapvz4qiEpIU5d1SQV/96B0ASnTF0S2JFB0ueh97Akv8RlGxl+5QkO1nqeAKdW+Qg5Y9YwWgfa3HnA2fmV4Adg3em56lLfeuA/B/IaffU87D2hBSRIxCJBNOa6coDqf1hBS7XhLOZDQbVGkS53MFzopcEQfvrWYlu7wsbKhRT06XMG5doPxkSyVJEZ+D4CsnKZzP7PBC5+wGWJYxSkSIlqmTgm6aA/iEF5x1vW6x9CbWIAXX86Gg/IPULModRz/D
 NUZ9bNgK
 081VOVcWjQiNqz+MEqpfUVLyHCbN/gG27N1ObI+RMsXZtiGm/aNaTLVmy3AeG9X1qSYOlhO92yiRZ6ilvbxiLqgxmNsKm/hOO2DZXixPujowyMxI7GFAtpQUTCHm2UOEDk3AbOXiz0QZI2tv0HhTmL3ud/3B2bJukpL0HGH5GUlpkjVOggwrSkaSJInKR+BOpLbsf/gkzoDKwV0Dlu1yYOLkoVHsJd7TdAnmk9b0/cHEfKCzrcYDgXmEHN7tEexLkGUXEq1u3KjAsqiWswdeg8+Sec6h5cIhsEPyaOJlEE8tt1AAtFsKpAq1s4J4MGnBCCavF2PAzH+CfdJlly9ldG0jbj4NLADvNibbzZtHq4U00VrS6zwfKqrcJeveypWzJkSPhiriZ5cELiGgwyYn21Txv5sReyLVGssj07/Y50yAiSvi0bz9Z8AdsFDF96P1fqWg7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The arch/riscv/include/asm/bitops.h does not functionally require
including /linux/irqflags.h. Additionally, adding
arch/riscv/include/asm/percpu.h causes a circular inclusion:
kernel/bounds.c
->include/linux/log2.h
->include/linux/bitops.h
->arch/riscv/include/asm/bitops.h
->include/linux/irqflags.h
->include/linux/find.h
->return val ? __ffs(val) : size;
->arch/riscv/include/asm/bitops.h

The compilation log is as follows:
CC      kernel/bounds.s
In file included from ./include/linux/bitmap.h:11,
               from ./include/linux/cpumask.h:12,
               from ./arch/riscv/include/asm/processor.h:55,
               from ./arch/riscv/include/asm/thread_info.h:42,
               from ./include/linux/thread_info.h:60,
               from ./include/asm-generic/preempt.h:5,
               from ./arch/riscv/include/generated/asm/preempt.h:1,
               from ./include/linux/preempt.h:79,
               from ./arch/riscv/include/asm/percpu.h:8,
               from ./include/linux/irqflags.h:19,
               from ./arch/riscv/include/asm/bitops.h:14,
               from ./include/linux/bitops.h:68,
               from ./include/linux/log2.h:12,
               from kernel/bounds.c:13:
./include/linux/find.h: In function 'find_next_bit':
./include/linux/find.h:66:30: error: implicit declaration of function '__ffs' [-Wimplicit-function-declaration]
   66 |                 return val ? __ffs(val) : size;
      |                              ^~~~~

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/bitops.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/riscv/include/asm/bitops.h b/arch/riscv/include/asm/bitops.h
index 238092125c118..3c1a15be54d80 100644
--- a/arch/riscv/include/asm/bitops.h
+++ b/arch/riscv/include/asm/bitops.h
@@ -11,7 +11,6 @@
 #endif /* _LINUX_BITOPS_H */
 
 #include <linux/compiler.h>
-#include <linux/irqflags.h>
 #include <asm/barrier.h>
 #include <asm/bitsperlong.h>
 
-- 
2.39.5


