Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57B65606A31C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 11:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=WNxhtPWt
Received: by kanga.kvack.org (Postfix)
	id 7E0506B05B7; Sun,  8 Nov 2026 06:06:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B8166B05B8; Sun,  8 Nov 2026 06:06:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CDD06B05B9; Sun,  8 Nov 2026 06:06:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 49D796B05B7
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 06:06:03 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CF79EC045E
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 11:06:02 +0000 (UTC)
X-FDA: 85411672164.23.F6C1BB3
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf23.hostedemail.com (Postfix) with ESMTP id 981AC14000B
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 11:06:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=WNxhtPWt;
	spf=pass (imf23.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794135961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XnCYVNofTC0C6ktldCAu6GTGzm+Q8FA6+tvEuphsY/w=;
	b=hEpSOexzeMzh43N5gRRU4W9V3OCSwYWGXZaheM1D4tprX1bqRkvZtl4a/3xrg3NbHxqSc4
	ap+xnge4qPWQH3c6JF3MkyHrFOpgBKQ+dXl5dV0WI0s5x/5pIg6KbC/4l0lLCnjcq+/u4/
	ytR1iWrBFRKAsqfOe7XGD0gJ6A4AASg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794135961;
	b=4fxB+Zv3I8SUgWzgSnO/ChcGpk2+Wu0QPGfZFZFil7+Qg7+a8c9oI9gCYJ2ensbPHaj19i
	00SDQTv0e3FA/TwKiBtAU2suuUv5/LyKSxhr2K8+uhnyUPZ2Yc4xfsHXS2BoREfIUZaqdg
	ppPltv8PnFvEvmCBo13M0b/LICUEQWA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=WNxhtPWt;
	spf=pass (imf23.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cd60c5da24cso5962a12.0
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 03:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794135959; x=1794740759; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=XnCYVNofTC0C6ktldCAu6GTGzm+Q8FA6+tvEuphsY/w=;
        b=WNxhtPWtN59RMMVVR3a0ww3h3DocGSyYIwM8L+9C4U73aAUnBJpo9BEabc8ivOlbwW
         as46GjBkuIKCq6NbcziJCLasi9isl8g0+LXKjq+C4L18jxCQ5uWhXYoBpVXXN1StIZIY
         meEc9GAnZtivm6mCj3GWw4m8uXY6l9FXUyEpkGZm4h8t5ttHDynGvFbsGyobXtHc135d
         PaAqel6CVtxhtBtOU8F3iNOn1CjITrJdI6dIumcswlGseKvM21HCZ6t16IvrxWlAfLt8
         L+sKjigP1gGITynVOLtg6qzTg3gakUxMYWIdr4+mWRNfuozb4KwKSdjzDTmNUIKK4mfx
         rLhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794135959; x=1794740759;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=XnCYVNofTC0C6ktldCAu6GTGzm+Q8FA6+tvEuphsY/w=;
        b=c1hv9vD/+yMGHQvGcXWTWSkPmUOp4kZtD0GWr8OIRCmuCNCNgikvKjdCZckfvQxmCr
         OU8CJe7HgWogsYs8K0++cF/AvI/M36S40Sb0L5yhvJi0Nm9EbLiUetB76RVOlVFXnCKB
         UTtKFcRCUUO/aEADyD5nv/h7yLDSpTXsfbzZPaXxT8b2z1lvcqY4xdGRtfyHBmZa2xdV
         VgVexp8Cslkbc0m2HatnDx8DJrAjQ6DCC+sxiSp8H/qJEgxo33thx6yd+lTvzNlN23An
         JtXs6hdsITRGtPstLC1qliPJxNyfo+wjOGw9wPxj011Zvk3qpzy954EFi/IEvZeTPC7y
         Id0g==
X-Forwarded-Encrypted: i=1; AL+hErFKeLosZ5Nd4RSsx8kC1Fp6LgdkD4hNgsERv9ZmAgzljrYrrM7NEbGnjFjwrv4TzDAYlXRELQWHoQ==@kvack.org
X-Gm-Message-State: APuU4Z9JFZTCVyHi7P2T86T9j4xGvNRanG7QX56scUvsK0mcHg3yH6kD
	dQXOu9RDkOiKNcjm1LW5TIj/BA1s0YFTvLjk3UskoqjJQNGpkEZmLgrEybbY69w7x/8=
X-Gm-Gg: AYBFou3EYNVpKqsRGj6i8SH6r+WA3C3XAYVPrRjGJJg2FxX3+H6MGMW/ANmPzWrvJ1d
	WAL3/jh4Rq11VsK70annWiAoVhKx2VVXDb3SmGc9y/rSKo4BOLqMZcgKYELm92TwH9gHa0AY2xu
	gMqK3DmOAok387r/YWRg2kcoVv0fj2k9g8+CK/tOWIfeNk7SaoNe7gHzQ4YuHyGyQ0HQaNPhedx
	llw6rwiLbeg2qvJ3sBAsbq0cqaGrwPc7JDn2xSTOmryUNecBEvJRKCNeZadJCcbYAvqkKKEEH7n
	rYxPHR6hPxRkGWW/nEoOhR7ufBjAA1WFng19grA2yM6wCHyuhCdfWFqFx1Wux2W+nI1lkdFeuqi
	I/apgesMzJrxvanjk63hKylXOEMk7nj88eVrrsF9d+DvtyWDad3DYKn+HecXr5laxxQDXD9ibcd
	MLPxjh+HzzwSMSp6XAOtnSOPD1Dli0hSZYDH8ZUUOi/ohWTuhkOX5vcbsdnJ/8V6ykY6IaP7ZEU
	zaWyTq/yCtw5Xr6Rl5vssZRR33Ka0h/E4c4zEiGRraF5QyavojX/eIffqK2c/kf/T/dniUy5jMp
	wUY3uTQZOWRBYkxS5EocbV0nyUNpUipI09hjHweewK+42jOtzH26+OYs8N+a6SE=
X-Received: by 2002:a17:90b:3b8b:b0:3b0:9317:5842 with SMTP id 98e67ed59e1d1-3b12d43f8c0mr1076560a91.48.1794135959430;
        Sun, 08 Nov 2026 03:05:59 -0800 (PST)
Received: from localhost.localdomain ([139.177.225.233])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1278918f4sm2609818a91.6.2026.11.08.03.05.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 08 Nov 2026 03:05:57 -0800 (PST)
From: Yunhui Cui <cuiyunhui@bytedance.com>
To: pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	dennis@kernel.org,
	tj@kernel.org,
	cl@gentwo.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	eddyz87@gmail.com,
	memxor@gmail.com,
	song@kernel.org,
	yonghong.song@linux.dev,
	jolsa@kernel.org,
	bjorn@kernel.org,
	pulehui@huawei.com,
	puranjay@kernel.org,
	thuth@redhat.com,
	ajones@ventanamicro.com,
	ben.dooks@codethink.co.uk,
	rkrcmar@ventanamicro.com,
	samuel.holland@sifive.com,
	zong.li@sifive.com,
	conor.dooley@microchip.com,
	tglx@kernel.org,
	debug@rivosinc.com,
	seanwascoding@gmail.com,
	andybnac@gmail.com,
	menglong8.dong@gmail.com,
	cyrilbur@tenstorrent.com,
	wangruikang@iscas.ac.cn,
	atishp@rivosinc.com,
	apatel@ventanamicro.com,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	arnd@arndb.de,
	nathan@kernel.org,
	nick.desaulniers+lkml@gmail.com,
	morbo@google.com,
	justinstitt@google.com,
	qingfang.deng@siflower.com.cn,
	linux-arch@vger.kernel.org,
	llvm@lists.linux.dev,
	dave@stgolabs.net,
	emil@etsalapatis.com,
	ihor.solodrai@linux.dev,
	broonie@kernel.org,
	cuiyunhui@bytedance.com
Subject: [PATCH v9 3/3] riscv: select HAVE_CMPXCHG_LOCAL
Date: Sun,  8 Nov 2026 19:04:06 +0800
Message-Id: <20261108110406.97495-4-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20261108110406.97495-1-cuiyunhui@bytedance.com>
References: <20261108110406.97495-1-cuiyunhui@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: ne1r9nz1etc15n83g5ymztco4rcui19b
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 981AC14000B
X-Rspam-User: 
X-HE-Tag: 1794135960-846576
X-HE-Meta: U2FsdGVkX195gMYZ50o/EQNFPhe6GhKa6XrOnyo0pkyW9xr0lf+2DDOit3gYjpUSVsvdTgLtw7uv46jCTnQMm+WROKZveHXbRoA3NiQZxeT96yHuuzXv/dJsVLfn64n79A1gKh5fYEVcOF7SdYww371qnlDUT8aAObTon2RXUyxjK9JkAdXXBoGd6vtuen0WjHYng7mzyHPb4z9CjF0UHEDxWmIJ4q8bw0qSoAHOQjmJwVRowF4QizHMhBUhuDgRiAHnR3I/E/J43d4CB2aiezDybXFjKjO+X82oTE5rkDCbknOuhPqrjVh6u9eLYShldMR81tIVKSMJZ/GpdV89SKWDxu6uS2Wg9R879ceIAZeTUbvBtUP1xW/qxuLtPreeURJW0Tu/oq0O3Mnw3sQm1sC+lm6JwFnkfcjpJftmnAOQuXsAGPzptpiM+jyvvLLdRLr9XMJiBW7wNXpGQ+90u1xwjaK/RRIiIQOmxnnE2rJ3+99jHPwkaDvR79BcdfWlZTSHoScZnLaTA7cxkVrh2Lg89CFsNSSXwSts53iQz5uoZWOA0PPDf8TpL+diIDkTOZu0Oq6xw0RRqFYd53ADxuthRbRDY3kjWiLNiWSFUm2P8LJU3xxWx3azSKZNC+/lpSfrBbqpl+BypLJYJ/mJO1gFJmlndnGEJUBTBudMZJ/n4nyw0XXI9ealiDC66BnJSZkopZM/39aLJsqYoHgFeqP8xTaDlL6mefJrNwb3YtDtGRmXnzgMShU5pSPq6U8xC6A7kcaKfgxZRq+LFQBy57CiMyvPl2ajGnyAA2TBfjyaZ7BbzrVAU1XO0hhlUd/OmF7b4LpduwMQ/6c+kY/8+o3eJ2PV7bV5uC9eNkgAdgh+HWMXH3hF7BP8JvvzqKjpsO76K7uu1kYL+cHDLGkT7KHBlpd48XMwYrkRZLMhRNLv8t/O1XPDL2hThTBTzMcpPZrfUku7G1Z15ceSFTl
 NW07lyBG
 yWpTBx7XZ8ILYCkkhk4hSOf1K77d6aMjfJKMuBwYxx1DcQQr5UdGi9Xwx2lAQ1bM8q8WcbbNA5RLbygUP27SSqZhWoKuG60Pl/eCVWCXoWcnWli+xcg/PNQwR7vx4tCX0zObnwOf/IndVi04i/y4CJr4xd6lErVuu/UYlRrb/wJHfK3aexvwkf4EtB8NypMFZs5zWDa8meinnVKIYkdnPJJbfM3F1yaKqZTdRkkAHlNZhG2ezAL7+uXyxkjsfUnwA53Y+b6ACbCqsU57jgguNMqBfumaKQ+NpsaxY+rYQYisYybGmcZabc/cIF27Qfz5cNhibRvC8TLvvN7fPdB5RVEGGWaR0ZCQQ/Iuv47yk1qpHa8h+4nDFlRk1kMwjKUnA/RzXmlU340YFPkppfCQxkdiqNzSi4YIh1bGUhCzBdeVIRQKQyZ0uZ1cDvo7QLYTd/YfXEU+tJWLAl9uBDNUdJWmhtJ/VHy/u5M3QLGtx9/TldPAMpWS4XNUB7fLZsG4Zuu+eqACfEbEP0DucCIf3TfFz6L9c6dGWDssMCsakvKFyVU4=
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


