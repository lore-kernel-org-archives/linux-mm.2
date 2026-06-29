Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93257C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 16:38:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 707336B0121; Mon, 29 Jun 2026 12:38:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DF616B0125; Mon, 29 Jun 2026 12:38:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F5276B0126; Mon, 29 Jun 2026 12:38:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32F636B0121
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:38:16 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A1B531401F8
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:38:15 +0000 (UTC)
X-FDA: 84933507750.03.B89018D
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf13.hostedemail.com (Postfix) with ESMTP id E4B5920002
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:38:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A9UAOTq1;
	spf=pass (imf13.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782751093;
	b=tY71zp/gX7tVrFkCU1RLqyQonSPwXOtOwUP0dAJdS0geH4C87t1Z0k2c1I3lp1+1xokExy
	gcgq+M5WbFCSwRQQPsiY/q9mCLBrKiu8kUpxIkOfDx3ik1QOpaT4/UM16K+zoXf5okFZrE
	JWoK+j3fwbHx7jt/dBl1qVoBu4OFs1M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782751093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OZ+KouBHR2A5cU5ulbS52ssZaf2NlH3yq/de1XOWkF8=;
	b=WnXQ33z+HcqLTvpSPc9ewC1y2/Dx4cilh21ZNKsi4m+xFLgqMj1l4+xFqUyWzCBelhSJpt
	z0gHafB1UQdrf0YyRZ2ZD1wFeiXYSpDXT0mHlzD6owt0V7RPpCrw3Udqu4uTh4C10RQUkS
	rn819ODeGatwXZBtCOvMXvqaPC1bGrw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A9UAOTq1;
	spf=pass (imf13.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-842338c18e0so2474688b3a.1
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782751093; x=1783355893; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OZ+KouBHR2A5cU5ulbS52ssZaf2NlH3yq/de1XOWkF8=;
        b=A9UAOTq1vx/tR1sRti5rS3JSj/tpVl9S6aPb06DcFZLFIP7jvNn96mOi/04WVq8Nsz
         j9lXiB5V7X9TUhc61GP/KrMwBEsc3WuHjOOHN6Y2oZAmcSglzHt236ZC+nlRfWyMKMSi
         Lujyr6nLSpZJVm61+euyHlPH538WEbmii23wbBLQW9Vix2yPNSHHygI4l8fSzY0W7CTS
         lBl9ABB/N+cHYz+8dOKuNWNCNBTEdcyA7zMBLhK3rP61xT1vnVo63fUiy30KX/AJZ69E
         kmwF+sJOBCsEYndzq9ulLiIKpyOd+CFWCY8+0DQCgGi4qr4sL+wSPU3PY5wBA65HN0LF
         UEsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782751093; x=1783355893;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OZ+KouBHR2A5cU5ulbS52ssZaf2NlH3yq/de1XOWkF8=;
        b=bkuTCSynR0XFjHYJEyqOVmYIwxBly2JXnz9qOsocSQg88wiXane46CixieQH6rP71M
         bt8GgpP9hccPAnteDeDHERkjTMDZrnIvkjxkH2PL0D1rEzErvidyHKoth559DromHzA0
         kbdlg9Ap2Z6jkiZd01C55Vw0EYi3R5UMDy7i2gC1ZZloKjUeaDmT/fKXi20Z/qyppRZP
         /b1zzQAVCbw50SnSRL33bpH3jPOolfpE7q+N5SNMrTs2BR9mYslTijJKknKodhv3HI/M
         sByYRwkuCRb4yxFqvE2fmmcz6KxgC5lNpGU+d6b9OecPyk0+cU9hzvmW+yp8j8AmsD4f
         +4sA==
X-Gm-Message-State: AOJu0YwYhN0rriVxUdIDUdeOHZis6r1d+XUmBMvFulJUzwur7B+55rnp
	3yCaSOGC9MGnOl2Kwt5vU+oMMn+IsNMSdtuEb9VK9NWW55ZoHCE/OB8B
X-Gm-Gg: AfdE7ckq1a2Xx7fKr6K+n/xsO/zEk+99v8v5YEzC6Tc7c6rnSBVOuMvps59ltbKlzC7
	kt8a7V2acpDt8/fUW6orz1NaCvt40jxwR8RIjMnlXPaeZGhHvjS13Isgzp7NJlpQCsA+YEb+LGh
	x8n0N/tcnjdwj+m7Wttf6LvlTIu5SOh+QcuZ8mwvCEkK35s8m1UwPDJ8gXtIIPI7U1dQcf+h8Iv
	egM9dr49qG6dlA2Vr/zaVLUlPuUdtgArwIliSCCy3i+CAA4d0PDaxGU280hvAeXMl3fFYG8o1+7
	wC4sYkytwoyFvPzvnMI8wj4nVW7ffWzpp5uWGE3DFTwNfsEUgxWPanxw9puh9ioE7iertrrp8DM
	WVY8k++JmHjvLCv7am5Y2ggkayTuNbRmE4v3HMeLHMI0pXhSdZ11ioFX5AzsZeLBP9mn1YbcSV0
	/vlnAUtXY=
X-Received: by 2002:a05:6a00:2c85:b0:845:d286:1fa2 with SMTP id d2e1a72fcca58-8479f294c12mr202789b3a.49.1782751092673;
        Mon, 29 Jun 2026 09:38:12 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847a02d41c0sm18474b3a.33.2026.06.29.09.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 09:38:12 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Charlie Jenkins <thecharlesjenkins@gmail.com>
Subject: [PATCH v2 4/8] riscv: remove unreachable invalid range check in kasan_init()
Date: Tue, 30 Jun 2026 01:37:32 +0900
Message-ID: <20260629163736.1606688-5-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260629163736.1606688-1-ekffu200098@gmail.com>
References: <20260629163736.1606688-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k999wa9yfwa557mo4f6hpgmaait9k74o
X-Rspamd-Queue-Id: E4B5920002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782751093-928987
X-HE-Meta: U2FsdGVkX1+Q1leM0DtQNDHF+Cl2h7nO+WAh8xxmLHgdAtsW3yynShCNMIh0Cyizz6P+mHu0YUTezs77xXpBSDYfgPZNcmfeQgHXRHmdvBzdgURTawBR7937bklQRm0ezjZUBsWF6rxp6kn1pW6VS0GA4xeBKPIgte8ItO97kklodE6qCpJoN//J6NFOMq4YzFsFM2t9kPY6Vs8uuPhbDliudJYskPdLPYxSEHuVC7rHejkHbAD8ZE+NDnkyHLgO4d6HsOvVsWUhs/O8Sx9e3Ek8TZBwQRKWE0ZivHKaVYqUS+OhxhDub5sC3fqJcN8iCfLGHnZnoxUxp0CfJEhH/oZfX2v6ybCezyIZRVZemX2VYnG1FkMb+BqQdd4s/yeI4aSjkKvtxaIekK9M5WqaFIzxVa+LJXqz/oe+7sxMUBDijL5iL+jWmS1ZLN0FeLNjDKRWwmEIosfthpz4qiOL2y1pZXlXxMcsopeOpgShU8zUfB6yb0yfR472f/KQyXIyl8fElFsvYGVNB+qlkuxUcPxli8diBFyqgYDQQCKvnAL43N6DuhzzgobXFGet8QdeTe94uoRjp5sL2PrnPttRqTOlcqQ0sa830BPKXgXbmY3gfb5sPYvmkB1l3TD5wvNzrzhyxloOMGAEomBR60X73dtW6wBzKV1MuJ8tn3Cd4CRQdgX6uL6iaOrI4Qad9ZMT0NxfGPQ6zrlgfzfU1HsPNEWbFL9qABx4R4G0J1En+D4rA8HY2LMLuSmGOsbvN1z6+ktfdEld7E0IYcfmJoct0HFLgcm2tyH4FVM9PjH5VeLfQFrrdzkEd8JG13WhJ+dJwZquL3dmRC3liRvaQFJDhEMoeSKmf/Y1MBjUTlKjqIslfn1JehjMq8sEvgxQ1bBmTxU7kqqwjv44zYiZ85wabnptRXG3ycGez9IYjKBBGBAzPzoNSHcXnqODQd9T/jQDsrIykHTCR12GdyzdyVf
 yDEplHy2
 XmnwRH902y/R/JwfFikEP/QhJk8wi0LFDS/avBdwci1Kg69MIC7Kkp08HsJWnkJpkUiPTTcC9qO0NbyD2RJLxshTFyAz9RgV9sUDEJik75m+K6UAi9LuuTprtqwdbkjO/zSi+YWpg/B6xH5iv2uS8lHPt5Lxs65MIArcVCOIj1jmwfg2ruLw3NG4/+WJfHg3zVp+WXNhxeAfnI4HvtFSW/PWOIHO27ns8l/K1pREtgnOOJVS+RFC9CVt6u4V40K70Uv5YV+VNWsrnHzv8chNM3+oGaPuAk0GDWQVO2luEY4pwQLcw0F4aAPEv/YQliI7FHJ1yefzozsPqDvKTw4O7jLrPNwO5xsQA0rOZ8q6mX3mQu/t0H/tzqgHO1LXTkonN/+YUs5QKysnp+GUtDhPAs1n+e+ji22OeXtHe3vbJ8XakEaT9e2ICW0hgfPKgjKMEUvGkNyFTUalm87GpLzDsa2u4fJogfetN32aK7eIHVgnyb+U2j6cJnb/GRlrjztEdd1S8deifXkAXd9Fg6/Kx/anUCKGiLHPktmMGPDw7590xE2Md73WVg9VBvTSU6gB14jjH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kasan_init() populates the linear mapping shadow with for_each_mem_range()
and breaks the loop when start >= end. for_each_mem_range() never returns
an invalid range, so start < end always.

Therefore the start >= end check is unreachable, so remove it.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
Tested-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
---
 arch/riscv/mm/kasan_init.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/riscv/mm/kasan_init.c b/arch/riscv/mm/kasan_init.c
index c4a2a9e5586e..1f3aa9611187 100644
--- a/arch/riscv/mm/kasan_init.c
+++ b/arch/riscv/mm/kasan_init.c
@@ -512,9 +512,6 @@ void __init kasan_init(void)
 		void *start = (void *)__va(p_start);
 		void *end = (void *)__va(p_end);
 
-		if (start >= end)
-			break;
-
 		kasan_populate(kasan_mem_to_shadow(start), kasan_mem_to_shadow(end));
 	}
 
-- 
2.43.0


