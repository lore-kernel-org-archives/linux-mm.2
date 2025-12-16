Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62667D5B87A
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 01:47:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 860946B0088; Mon, 15 Dec 2025 20:47:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80E496B0089; Mon, 15 Dec 2025 20:47:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70C996B008A; Mon, 15 Dec 2025 20:47:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5B33C6B0088
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:47:43 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E01AAC040A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 01:47:42 +0000 (UTC)
X-FDA: 84223647564.14.D14E748
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5D0192000A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 01:47:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=bB1Xyngl;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf03.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765849661; a=rsa-sha256;
	cv=none;
	b=iPifQxdER7uSXIqmpuc3W8xyEj24akrKAZ7gpm/tIZw7cFS9ydmSvv+yVKh/5+eBK89PdA
	ArKU5PETZYyjTtlan8kc6UVyGQ1BRuFJZuDZs/UGpdSDzSfe8XZMNjWLJwiCy3VbfC4zQ2
	0MtGfhX4JBq42fKxOsatATdIPJxDvKc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=bB1Xyngl;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf03.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765849661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jQOYML69oTsOQ75vYxPwSIyfraEydi6o2qTswuNZTTg=;
	b=JfnnX/427iZORkqK0q9rmRBSLZeqCua+gvJM49l+bFijipeKGcGpym65voP8VhTgIyE8de
	OCm4KtMijvAJmIBaI0EUj71CKtrAeSRVcHW6wWyaUmc44I+7Nd1YSTs0HIGl3pk2NQGmmO
	a86/oZePY9SZt5EbE04Wi8cK+uZNFtQ=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7aa9be9f03aso3307511b3a.2
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 17:47:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1765849659; x=1766454459; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=jQOYML69oTsOQ75vYxPwSIyfraEydi6o2qTswuNZTTg=;
        b=bB1Xyngld9QXqAmTFsd2GrF9YAnRriofTk+FZeSM72UkhAvmADf5LQ6gttQ3KBWH63
         DAkDfF01ZS4+E0kYet0WTXBpEw26QdNuK/A3a57UJim+/eGxrDenkvrcDMTtxt86OFjZ
         IosK0ry5dx29kkuW14iTyUn7N0bxH9/S58F6lFlTUOYqsJ71Sc92NEih3fIkzkny5JoC
         IhWklzFXzQhKqCGTS89Cf4hEwqwNbUBbujGVsyAd98VEJ3B1HrAXNoZycOGCywkiDNKW
         s7h7Sj9nLKWHFLMH+shGEmjMmcoBvtD5/wxrxhMqhvxfVqXEFLvQ+JtFeQkh+NYypNOE
         B5Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765849659; x=1766454459;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jQOYML69oTsOQ75vYxPwSIyfraEydi6o2qTswuNZTTg=;
        b=A4uQlgdqaALf2i6vn27c7sCr/mZDEb7FmHC4HPqJflbT0uWs4vqyCgWrfNxfnm1yhq
         Z9b9Da7GlUBudSbksap8egknRssUfn7wO8STbs4GofhS5oceiqnnMSCQ2HjG5nBglwCu
         gndoKemslm2DtMtppP4CFVkpgolSiy0dAwfaSATkUtUe6BafKiam7f9+/wJSmgknIDlU
         RQ/5OJW41qR/xl/q+rXSkHVaph8S8hO+93rWLGycov/e9Do1iDNrrvmlmBBrZgh+lxNf
         +VQkCay1E9fPYMGu0jz5aB+258bhS8iK8hWe4Ll5FTnueSUKReFnOIPnkaBQpWzTp1qp
         xjNA==
X-Forwarded-Encrypted: i=1; AJvYcCVaI1iNq8gjuRoJ/527JHscWThuFa7etUVBGZ9J/0HlWlfWl5k+PzJAfSz38IAE1wLmH4id62yPzA==@kvack.org
X-Gm-Message-State: AOJu0YzOXcAzsMj8xEh4XKvacWypFIDdVFyfV+h90S40ObvXfpOK0y8O
	pk1AQ/1PZZCfWkn1BISfMxXrUoIWKGEv6dUER7qrJnxvkhMeljLnMC2WwZvXpf7Zt8U=
X-Gm-Gg: AY/fxX4vLyI6JWbHBX1KfqHACbjSrg7k+U8K3Dtv3qyffX74cGfqEi9Xx5K4IEfcctn
	RJfMypeu1zLLQ0yHNMsfsqfrJLqNhQpMy1SQoroqWQCzVeW3WHoSyRcC+/68d0munv0Q2OKRgCa
	rW6M51g/VjIK0u7BjJfHra1KoyO6VN98iIbv00ycJHU8aH3eyFPBqrONAtf76NNwkmKpaOuwfbM
	DEi36taiyWxJ4GA7XRX60GIVx0uzqWtrx/MUzH/2mpx++QE/EyVNun8NSq5wWfYw/bqPkZbJK6O
	6T60XWPooHzr/QJx0XZFm0hjTQHiPRWErP3/jNE1sPqbSfpkBQrVouhbxwEB3RgSsX+leQJMspj
	jSCg7sCi4yh6cH1uF4mZTVkwfxYF8WFa9ppN0U/HK+n0/bXiCqRr8m1EwUYi1lZiqTPmSkJhzhQ
	b1GO3oquyXUqZf9IRkQdFjx03Whhp7OwBOfUQNf5D3Tb+3
X-Google-Smtp-Source: AGHT+IFb4p41Qgk4jrG7oAwM1kTzSPIz8GaGD809Q++LMxasrDyli3QXNwxda2W99S4WH1s8MPX1mQ==
X-Received: by 2002:a05:6a20:3945:b0:34f:b50e:e2e2 with SMTP id adf61e73a8af0-369afa01a2cmr11969729637.58.1765849658920;
        Mon, 15 Dec 2025 17:47:38 -0800 (PST)
Received: from L6YN4KR4K9.bytedance.net ([139.177.225.224])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c0c2c963b53sm13632790a12.36.2025.12.15.17.47.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 15 Dec 2025 17:47:38 -0800 (PST)
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
Subject: [PATCH v3 0/3] RISC-V: add percpu.h to include/asm
Date: Tue, 16 Dec 2025 09:47:18 +0800
Message-Id: <20251216014721.42262-1-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5D0192000A
X-Stat-Signature: 54dhgfq9quq4ydzgfif6aj3b7xzmcgej
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765849660-24011
X-HE-Meta: U2FsdGVkX1+cRQiOIFz5aIMkCev7LDtGwJb0pKfTHYxqzjLgjbkM9Iq0endhsos9HXqe2ZEanpylxqLpFz/2ptkSUwWaxZgiPsp+JYU5UrQxPLSsBJh57Z3AFtvN+m+7vhwmoegNTK+hkiAbO99znQQdkzzXp7TX5v1HgWOhUfTl9lsm5yBwF6XscHZ8XVQ5iTO5vKtIRRbHbPDAUjYOzKcPjCnc+ifAxJeP85OBtQeI69uoEU979xW5Nn4zbWKaVLdBSO3KVPJtat3Ca+d6R2jDSxoh6oClQgLGrvJpuqr/9H+oWqQjZhvKrktPV5JW2ra4EHgIYDVRll5VMQfytW88l4tqNXAMHZ78z6TJzth0qT5C0fhfXI1dC2Mrf2Z06SMsTxG3tKDtdX8RlQejn7iIsQq1sk/SUsah6VTVcMBA2i4++yR4M5ZOztLKb+FKWKUSMC7MPWVUL8r9X4G5Tj9uw9CruhJGQ06TkrEhQSSFm46Oq6/6iSaGoJ+AHjhGGDspGSnkLV3t1OEPvqB4Q336oI6mQZsgbW+eRAu3eL5QUc5Xfk3CCyo2VjS8RgyCzpZsukXwCF/jtNr+ZZF3CFn/OYThzuRNN+8zjyDxeXEMXbdwJfFAbfC8gEi3qMPsQkxlOfANFjAok6vk4gWoSvbK8X/l7OtAPNcbfowpuJqHKFqxH4PB/Rhu0QTdVnmTxEXCDQHfaBiImWLJQh8cnsSpl0AiSuyQSsyXYKXzqO44HtM9yaLiKwk3HOQeQpFBbPRRAWc6JUA8YJUqz6ZoHyk+QIFzPDTO2IiXRpq7OpA4cytN9kTCe/WGuO7/sVpAQuW24FPZcKM1ehZITjEag7veERbHW0GMzR0TJEuVDqY2COqKDQHpErAkq7hzZVcfEWqW2AYrc1SQ87ggA+jbpyhMc6BLAW78gHVIMlPVyyVsRiSmYPvZDXQjdDU9WIhhBaFm+qjzesA4+YzbyPU
 C8gfzxF4
 WRzdcudfq9ZDRLYdIJaiSyXy8OZ/H3sl1eQfmxjmBf5oKnRgvYDRvKfrSpOKlBrgFLjRX6N5lpzApsZm8xNwYYYMzf/vbIRbj70dKT0cv6Jhy9Uf2U9LpwbUmIWJNWRQEs06gX54s5JKZMZHIA/cIzvnUmCf/VyVDgz9NMJxCkzpuv9bzkzTlHOkLu01ummexv2wvy8fOiNAZubQr8vJ9aXLxcb64a0VlvcqnFLnzViNaowqLOXQASqJo6ZFDaRFel+ANIBVXMay0ppKojDkqpjcjgfOpd8D17aXt4CDohDX8Yb6iugf8+nEQyzuNPxBlORkRrK/I4/lMvi0+AxgUufX3N9oTjJPG6SjD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

v1->v2:
1. Support percpu add/and/or operations for non-ZABHA
2. Implement optimization: store percpu offset in thread_info

v2->v3:
1. Fix this_cpu_cmpxchg128() compilation issue when
system_has_cmpxchg128() is unsupported
2. Fix sparse warning issues

Yunhui Cui (3):
  riscv: remove irqflags.h inclusion in asm/bitops.h
  riscv: introduce percpu.h into include/asm
  riscv: store percpu offset into thread_info

 arch/riscv/include/asm/asm.h         |   6 +-
 arch/riscv/include/asm/bitops.h      |   1 -
 arch/riscv/include/asm/percpu.h      | 248 +++++++++++++++++++++++++++
 arch/riscv/include/asm/switch_to.h   |   8 +
 arch/riscv/include/asm/thread_info.h |   5 +-
 arch/riscv/kernel/asm-offsets.c      |   1 +
 arch/riscv/kernel/smpboot.c          |   7 +
 arch/riscv/net/bpf_jit_comp64.c      |   9 +-
 8 files changed, 269 insertions(+), 16 deletions(-)
 create mode 100644 arch/riscv/include/asm/percpu.h

-- 
2.39.5


