Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 713E5606A884
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 10:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=Eo1k6Fem
Received: by kanga.kvack.org (Postfix)
	id 95BFE6B05C7; Thu, 12 Nov 2026 05:43:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 932CD6B05C8; Thu, 12 Nov 2026 05:43:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 848436B05C9; Thu, 12 Nov 2026 05:43:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 648F96B05C7
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:43:31 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BEA5312054C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:43:30 +0000 (UTC)
X-FDA: 85426130580.18.E7E3563
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	by imf18.hostedemail.com (Postfix) with ESMTP id 85DE41C0004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:43:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Eo1k6Fem;
	spf=pass (imf18.hostedemail.com: domain of cuiyunhui@bytedance.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794480209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tKHbJSnTS/xgwwH8xY3FZeNU74t03Ua9SzHRVgCuNfk=;
	b=Rh+imFyoGa1Ae2DOwR+8E8VbJTs9uKM0aa/XnU8ZzCOLGiRQV7TRscwd9JsAYy2yoAwYBt
	KlducuGFTrjsVgfEQZABGajMyriiF0xfOQ3ZEEEmIgjWS8HT/gAiyPp9pWStNefrQuHFDM
	lMcJUcNr6gXQXVDYd+zmbpSeRd4M9RY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794480209;
	b=nlCkUrN+OxND0cxMVrbgizEmGPTls2VWZMlWrZ/dsO226h9GeSSpuiz/zhLFVG1hHYCFgu
	r7tiLCwLV7KmmlqGaXu0VmmCqLEeqQohZohG9dViYhqkC4iHJiWTyuGrj9w1kocPS372W7
	uEb4FzeQJJKBavac1n8F9a0/irxCZyg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Eo1k6Fem;
	spf=pass (imf18.hostedemail.com: domain of cuiyunhui@bytedance.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-3700ed8dbe3so7557070eec.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:43:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794480207; x=1795085007; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=tKHbJSnTS/xgwwH8xY3FZeNU74t03Ua9SzHRVgCuNfk=;
        b=Eo1k6FemUZbVWAOeQ0TTVnLdefEW6RnyhMusCbYI1xnCrwWoFY/1o/70S0cbdtr3KX
         oHyrDGa7Dkz5IJk10Hf6SnWIhOF5GQFwwr3PIHvXB/XzYSebb9+ouufmBI3mfXwIsmem
         mdziBTtTbJVgOoKr+qLS38j2+xA0YhhmsycpKW7Unm6KzkySuP/e8HcguNBm278WZ/ep
         mxGOe4G8uPsVYN5XQ4bOKoF3o/MHQTnSB0nqndYw11WnDfwbos9H+JoKzF4Li92S9Hno
         9Spz2zYVC6FC6YfQrtMM3F1kLyYlSMYypxdtpA35btT+3vjbEWtQYXdPg3FpFkNS/rPm
         Zk9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794480207; x=1795085007;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=tKHbJSnTS/xgwwH8xY3FZeNU74t03Ua9SzHRVgCuNfk=;
        b=14ZMMQbRQaQ0jjVBLteBbs7z6dwMhaEl6licC6o8VsOZvWpodtCoqUrmr0l5YHllce
         X24OH+9NMsC9U1Eiyn5ELur7SNqfvaH3BWltkVfrpf5b/AHZgjAzFYpuwv+2ROKqpeaK
         +eF5TrNrXorTZsEqNUcR28gHb4SzQ75mohTGPERzvrnJHANqdSpzfZ2vZ7A/hZGlwveD
         T1NtoL9k01QmVoqBYTUomLiImocFVwpFLdLiFx5a0TCOEY/0DONAaPQwq0dX76ctvDfi
         VwmraemfVPIVDAortZ0ffgDiKpOfWotiUelwxOE5Yp/6oExBr4e60JrjdOnQV18qMErY
         CejQ==
X-Forwarded-Encrypted: i=1; AL+hErHQbnW3AU125c1P1AqlI1Nf5fD3mQokc53CaWeEKTFZTuVfYyL6bsFvq1EySHZXMv/uXEF9vy3GLg==@kvack.org
X-Gm-Message-State: APuU4Z97ep3XmYRQDpCZVVwhUXvigSYZCWZ/LPt1hpVcpSjOSDZA9j47
	KmdTe7NbUcQ7JUZbXFtVy0pTAPp5hmn+zyGW5IVsbPnBhfLlbrSuF3G6wDY4iBN1hZo=
X-Gm-Gg: AYBFou29RDHcJtwmDzi5q8qHdpdAsZBoVDgnVAXqoiILvcKY0/Kpr9ST3yRTzu/oHhi
	E4LQvBw2KqoHdpdd2Dgp6GoLDmijnUOJ7z6gz+WZtUglyK0aXF/K5v8DzFsFF+uiXdirLWIOU7m
	euDkHpHEsrUfRWWwnq8oB193khqth2Xf9QQcc3cw8TooqDjJ/ING3q9tlPS47KwlJNOtfjh0tuo
	V9MO5y/yzcJdZHoSN+hJ2tCjiIEar9Tz8DtDsl/VchZwX9qy4Fyw680uBLAmkKBUabBs+BK2Dk+
	LTEFWiWx90MjeYFOT1uz8wNNBS9HVOmFx37/3u8uOeBm5B4+WGV/06nFQFd2v9SYt+BxDPw0P8W
	ye0Y2QAoDonmYOht5WDTkAjuNEVuaeevmrkl3m8azhUrkFEzPvnRAQaa8uytp9FtF9X4HEru3E6
	4vVYDc9qQp6ku5lKSiUziedordpbbpRFzqyTLSrDNax7e0CvA1FY5MXxqH9DLaRGHoEKvLj2YMh
	GP6BWyVsDyRPJej4TwAH9ChCbiF7ZmtjoVpBM63eyuzS/JNCDFVPK9kvmihuORZixhU3hWJHACz
	upbDk6dJ5NV5luJdEsJrcP1gPJTsExsTjLrZEwRu5XPJGwBlqHuu52g8Qu3W8CInSNs=
X-Received: by 2002:a05:7300:bf9c:b0:36e:1fbe:3571 with SMTP id 5a478bee46e88-3768366a461mr5368073eec.3.1794480207004;
        Thu, 12 Nov 2026 02:43:27 -0800 (PST)
Received: from FR9WL0RHKY.bytedance.net ([139.177.225.242])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3772121e654sm13228694eec.2.2026.11.12.02.43.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 02:43:26 -0800 (PST)
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
Subject: [PATCH v10 3/9] riscv: implement preemptible this_cpu read and write operations
Date: Thu, 12 Nov 2026 18:41:43 +0800
Message-Id: <20261112104149.38589-4-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20261112104149.38589-1-cuiyunhui@bytedance.com>
References: <20261112104149.38589-1-cuiyunhui@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zhyxx4guxfreftub1tkip8mp81qx4n57
X-Rspamd-Queue-Id: 85DE41C0004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794480208-208526
X-HE-Meta: U2FsdGVkX1/eAqCAMFWW+5UNVWnOvnvGklkpchpX2+XMaMVliu7zrkrT/qPLx1S75jnpP7OLzVq8PDw8ntXgQZJDime+Wp+WHzzkmu3XIdp4kdZfBsljlObdjUnM1x4M1mevX4pcgVeq81kbrmPwFCC13HN9m1rY82NIV4VROEATixRqwBNS5nuiX3JLEI1GBsXXAzKSRjpxl15e/KnoIS3vDq4l4bHT5cJYKIzXfdcqfYo/ofbSZxMxCSG4CzinD/j1NCdIiA7aiWx/OhNZXDhC9a7TWD7oOoz16Aeg1+l0zCMdhY29WIYmerZ576yrGGV06dB/cjpJ7kHaukq/IzmwKbEQ4GKv0AjfpBcJsyTDB7IDAlAKQipI+ESQnmbNnJfUDbP//rNwR6Sclcw7iFsEw2nvzSQdIXET9IvRTWIVpOphUcFntdVcHTUYjJFeySjQ1HkJkE8gytgo8pX36uRCQWrGWVyQFgoHRhO6HUzKzjvdG8CHCo9Hw9XVR8M36tCk5GL47ByB5RahxeCVOUQ6Bjp2DQvTPo6suKBI19zdhALe+X7LdHh69s22idFvfQynw3+d/HsWKJ0wVbXNrvZGWVzEiEBjROVbSxgnOmC+84OVc2ASP+oZ0n7MlzxiOcVXHEOLblH7wZYBmD4CiR403zFYKCwTtYGBpI6SbYU6vG7LnkUeJ+FAWPFSO2jHye+T5f1vi2h7Vl24gFGZgGOKYNPKlmvo3iJmYYZyc0WcyT4m2/SMPzuJAbmkBANdO95aV2VkjmpJMs+J8fhZI8SVsBl8E962i5WeDsFIcWrbg+4B3wQl2jdFQgZgHiyeOyO0XPh58pMYd0CLAzsePNeElqqZIBZiNiNZ39cWzA6lIyfGBvA6Tlwutd7dKyNh3Z7v+0zNBi6+tdYXoFeuUJ13Y4kyScL5X1YSMiJJLkNTRx0KhDt68p1M4MsnLniY76cX79iRKO++xBQJep6
 OElzsENe
 oIfh73iHCYeaSP9k90BeeGLpgBVYJeG8kzrFePRVzklJisfsfZv96MKxFbhACLjvzWjxnDd2mfWKx4ZSRIEox7d5h3ngwxp6g7tmhl2zjU43TUiiUAY94xfq2MTCUWp82K60Bpz9cfrRylJa9VkE5zyEjmV//jEHUolEoAQtKtRq1BYoQLWDnmEQeHf4FOwQRVg2s/+VLnY+tw1xvqcb6h/Hr59GQMwEpKzxGKAagRl1djFjHzob2qJguhyQAlSPeyerjB+CxcyMmR3YRLaadMsxT5JY9kxS6lkOOY8u+/57CtO3eJ9vKzvF7A/M+kWx6UPavDoa3CoFjD6Ls3r1fMMWSF3QdJGdj5PV6tKdvilK1lzGlbpETYKruvThwH7SF2O5SelC3mjO9ECS56D8I0czFBpYVD9h5bUh5B6iDv7XmFoIH5r3BPLPBTqal5k1YVcEjZy4huBMJq/QHEJx1rF8K0c7BDf+w39F2qYGIyH71HjgaOJIKklpPHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Apply the recoverable per-CPU address handling to read and write
operations.

Keep the address calculation and memory access in the same inline assembly
block, and use naturally sized loads and stores while preserving the type
semantics of the generic percpu API.

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/percpu.h | 85 +++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/arch/riscv/include/asm/percpu.h b/arch/riscv/include/asm/percpu.h
index 59f7d44f7d3fe..ae7c123a48093 100644
--- a/arch/riscv/include/asm/percpu.h
+++ b/arch/riscv/include/asm/percpu.h
@@ -4,6 +4,7 @@
 #define __ASM_PERCPU_H
 
 #include <linux/bits.h>
+#include <linux/compiler.h>
 #include <linux/stringify.h>
 #include <linux/thread_info.h>
 
@@ -52,6 +53,90 @@
 #define __PCPU_GPRS_END							\
 	"sh zero, %[gprs]\n"
 
+#define __PCPU_OP_CONTEXT()						\
+	struct thread_info *__ti = (struct thread_info *)current;	\
+	unsigned long __off, __addr
+
+#define PERCPU_RW_OPS(load, store, sz)					\
+static __always_inline unsigned long					\
+__percpu_read_##sz(const void __percpu *pcp)				\
+{									\
+	__PCPU_OP_CONTEXT();						\
+	unsigned long val;						\
+									\
+	asm volatile (__PCPU_GPRS_BEGIN					\
+		load " %[val], 0(%[addr])\n"				\
+		__PCPU_GPRS_END						\
+		: [gprs] "=m" (__ti->pcpu_gprs),			\
+		  [off] "=&r" (__off), [addr] "=&r" (__addr),		\
+		  [val] "=&r" (val)					\
+		: [pcpu_offset] "m" (__ti->pcpu_offset),		\
+		  [pcp] "r" (pcp)					\
+		: "memory");						\
+									\
+	return (u##sz)val;						\
+}									\
+									\
+static __always_inline void __percpu_write_##sz(void __percpu *pcp,	\
+				       unsigned long val)		\
+{									\
+	__PCPU_OP_CONTEXT();						\
+									\
+	asm volatile (__PCPU_GPRS_BEGIN					\
+		store " %[val], 0(%[addr])\n"				\
+		__PCPU_GPRS_END						\
+		: [gprs] "=m" (__ti->pcpu_gprs),			\
+		  [off] "=&r" (__off), [addr] "=&r" (__addr)		\
+		: [pcpu_offset] "m" (__ti->pcpu_offset),		\
+		  [pcp] "r" (pcp), [val] "r" ((u##sz)val)		\
+		: "memory");						\
+}
+
+PERCPU_RW_OPS("lbu", "sb", 8)
+PERCPU_RW_OPS("lhu", "sh", 16)
+
+#ifdef CONFIG_64BIT
+PERCPU_RW_OPS("lwu", "sw", 32)
+PERCPU_RW_OPS("ld", "sd", 64)
+#else
+PERCPU_RW_OPS("lw", "sw", 32)
+#endif
+
+#define _pcp_wrap(op, pcp, ...)						\
+({									\
+	op(&(pcp), __VA_ARGS__);					\
+})
+
+#define _pcp_wrap_return(op, pcp, args...)				\
+({									\
+	__auto_type __pcp_ptr = &(pcp);					\
+									\
+	(TYPEOF_UNQUAL(*__pcp_ptr))op(__pcp_ptr, ##args);		\
+})
+
+#define this_cpu_read_1(pcp)	_pcp_wrap_return(__percpu_read_8, pcp)
+#define this_cpu_read_2(pcp)	_pcp_wrap_return(__percpu_read_16, pcp)
+#define this_cpu_read_4(pcp)	_pcp_wrap_return(__percpu_read_32, pcp)
+
+#ifdef CONFIG_64BIT
+#define this_cpu_read_8(pcp)	_pcp_wrap_return(__percpu_read_64, pcp)
+#endif
+
+#define this_cpu_write_1(pcp, val)					\
+	_pcp_wrap(__percpu_write_8, pcp, (unsigned long)(val))
+#define this_cpu_write_2(pcp, val)					\
+	_pcp_wrap(__percpu_write_16, pcp, (unsigned long)(val))
+#define this_cpu_write_4(pcp, val)					\
+	_pcp_wrap(__percpu_write_32, pcp, (unsigned long)(val))
+
+#ifdef CONFIG_64BIT
+#define this_cpu_write_8(pcp, val)					\
+	_pcp_wrap(__percpu_write_64, pcp, (unsigned long)(val))
+#endif
+
+#undef PERCPU_RW_OPS
+#undef __PCPU_OP_CONTEXT
+
 #include <asm-generic/percpu.h>
 
 #endif /* __ASM_PERCPU_H */
-- 
2.39.5


