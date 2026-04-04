Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3833E88D8B
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 12:21:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 290776B0095; Sat,  4 Apr 2026 08:21:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 267D36B0096; Sat,  4 Apr 2026 08:21:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A4B76B0098; Sat,  4 Apr 2026 08:21:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0BD8E6B0095
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 08:21:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 87CD35A12F
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 12:21:49 +0000 (UTC)
X-FDA: 84620784738.04.F9BA240
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9E871140005
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 12:21:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=k0n1JSjT;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775305307; a=rsa-sha256;
	cv=none;
	b=WwobTm63GrO4AlA0HsMB8THEBYNwSPITuvrSRhY8Ps1NwFUBcET6hjJ7f5iexZRlnopTr2
	R0rQ7xMyIxPO4f0+XqElNWLLbky/zuGtzpj9Mx8NBoNaFKEwVbdKKD/v2Pw2DikbxkjVZv
	rzlftidO5pMRr9Xn6V+rs6ulq+OGPgQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=k0n1JSjT;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775305307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Y4Zwv844O5BRtbiO3p0keEYr5wdjmq4nDT8xkCMxlw=;
	b=tnp5IOX+c6xH6nmZBYSEqgCmk8QG/+42gB9nfTaqm2wIls9zD56wY7vEX7ExymK/SBXMhP
	u0lvScbRINu3CN/3vsEEcLVE2yWKKGilGUWJGYRhMnEoxMqUO4GMRYmbIdm1r74ksXkHXg
	OfeW9xRDJMJHHUEk1ZkHs3lRJnF3QaU=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c76864f4e58so1027339a12.1
        for <linux-mm@kvack.org>; Sat, 04 Apr 2026 05:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775305306; x=1775910106; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Y4Zwv844O5BRtbiO3p0keEYr5wdjmq4nDT8xkCMxlw=;
        b=k0n1JSjTrvpES/XNW8FOtb0JykiHuJrLSvESelCoPOgnlGPndUfb52lDcSpiDJFvgL
         NjtqPeqGHO4liRgUf+ngjahtijDNcOWZOy4+kLo2afqzCh2trPwjQ/F8VpqLKBJ/iEDy
         C7PagkqKfpHPAxOOMTZcxURzuVVCnMwfxbWgqvemJb/+zXoaITnbSAfPUYDmPZm6M2/8
         NT/S2O/W1uUnigYD5KJ+jsXaBjLL1PsfdYV814LcElduD/Tw7XlW7WxRbtHM3C2cq2j7
         NMyZFjLuS2XxJAQmkyWucFP3KvnrS5PbOyJgfSyjF28ZGY8GKZPDxgCmfx5VmYyd20DQ
         tosg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775305306; x=1775910106;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8Y4Zwv844O5BRtbiO3p0keEYr5wdjmq4nDT8xkCMxlw=;
        b=k4pUEiDYrKm6OKyYFzgXhuc76dADZwNDusLJI3T/4I3e0IOYHsnpDZ/mjap77Rnjez
         na7VmDSovqpg6nIg6cAEmo3fAADgM69LfmHXGTJ5YJerQKt7QecdKeoeATthx7qoEigw
         4HJXu4VHpj4v93XWlV3bBdSf/GqGZ29NK6NsBbVIM6P4L69TXMPfR6Lv/KVE5VfH1QhS
         ZuFfjUZV6QXVdxH61mabhDkMJNZ/8yUWLt9S/1ft+R2/pI7HRk6SgPzUhbXcGC+/tYax
         cdT+jY3YQvrcI/27C2zWPxoH1RGzQqOtTty55SUVCKl3iapxXoy7Y21MwjmCOULSnpfj
         g7Pg==
X-Gm-Message-State: AOJu0YxupdT4QWOAzaNd/UPhKUb4PWo+1tTqO75ZCNpZXDNoocii/8Fa
	EbXz1POAUDOT1NGPU1iCtQcuuzEdBY6Z+B+uFTvCkTCF7i6k86YeteMZi7+gMYVDwBo=
X-Gm-Gg: AeBDievsxQ4X0IX72Nlvg/VkhM2uWXToLXuRwFrlkCk8L197UFSE2poX4YqGESHaedM
	aZys+10JNhyaPC//ijY2LEG7dkYIR7PheO5x2HC29xuVhL3oT/xUfi/A5LGxlYZnVqk1HORiljT
	C7YAqsc6mwCmcwzBHYXpbQPQ45wZ+2H7z20kT67AcyCx6ZV+F6qLA1Oq4C+tJx9YipTtEGlDNTi
	ztOuE3eGd/8NPGf7Vg0UorlYjL+qSMplYwPmLVbWPKGs0IUBXd797Fo5fEUxAsr7S8WdFur+Htv
	3/6O5+jgXT1du+aRUQl54TrqzZ56GbVgr79WqweO62ts5FEo5ac044ZvH8wNApfWtH3VHz4CFgU
	LnMHRWolHPKgzRnZ4mAZHdzQhUVR+UH9o9PFloXR3YIX6K290+Dt0XhVa8PqhOO+3atjzezyig8
	Dlk9ogD/EuLg+n60beM47hp/IwauxtP5qew/jm4PSN9VM=
X-Received: by 2002:a05:6300:2109:b0:39c:c07:1450 with SMTP id adf61e73a8af0-39f2f20dfd2mr5649641637.42.1775305306320;
        Sat, 04 Apr 2026 05:21:46 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.98])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cfebe5b23sm8327063b3a.59.2026.04.04.05.21.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Apr 2026 05:21:45 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: "David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Kees Cook <kees@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Chengkaitao <chengkaitao@kylinos.cn>,
	Alex Shi <alexs@kernel.org>,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/5] sparc/mm: drop vmemmap_check_pmd helper and use generic code
Date: Sat,  4 Apr 2026 20:20:58 +0800
Message-Id: <20260404122105.3989557-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260404122105.3989557-1-songmuchun@bytedance.com>
References: <20260404122105.3989557-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1zff5c5mu8c1zgfy953jnegt3u8wiyyi
X-Rspamd-Queue-Id: 9E871140005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775305307-633945
X-HE-Meta: U2FsdGVkX1+aM5e6KypzewmTjRRXOxV1FKCWxrT4DjNzvwnGE/cXABZ18hYZfnfax1bqzMBitO02ST3F/uGXGwQulh2aYlgJDno9Kj4vq0T2ubZlINCmJpLXQfTuTyALEnFUz5/XRd+4Mk1XX/MpfFoIqt2YMZOmGJrxFT+LcBtGEwei4na75UkKM60Mmt+Ekxc2qx5kI/iZ5noIKOF1Io52T1JUTZPreiWwR8SpXYitgh+w9EO59O6DIxtxBqLXFTlCpebQlvaoaaCPdqZwXG4jpkM23WpP8HRBQSljZJRJOAbLJq9QDb14gBlyDwctY3JkObxjOQMuRCfl0qO63ksOtRVA9idli2Fa9d0++nLRi/zwnqSRuIcwcfYJbUoXlGjMNXDLycWD2S5/JtJMvEjfdhNckdDpa6kiuEQSXKjBgOKO4MJqIybaCeH0mw7DqArvZs1DXba03dnejLQWdUaiIForE5HLXy6vKq+9Icb4uzj1ddLZ9i46gIffW5DYJWlRFA+CtpAgta4hVwOQsycluK5zMBKkgZzofil3Uq8OJ+MS6RkmLut9/G+uJepzzjqFstp/WZA3fecrzq9YOt/p6qiw8OZjAbUTKnc8ZIUZUUGvhxJN83g6rlmRXXR1zP85u4bT17HUYF1vvn7Yj8ZWxDfEi4TLL3nnOFqQZYc1TlliMGKgvX5/FgdishHb904iUO1iWYrVySkuGggCqhTEFkUdIjbMpSrb2w6Pu4snj2O+8JLOUOMmHzAH933lftQMnD9Q3UtVGG49cGA1FKxUwdqpFEsYVHmr98Jj6D7zoRsb0FciFCK6Z3C1Q5guU7FqlF4FHxzBZLQ8U26UsewX2AAGgrFgv2rVezjiisbfpqxd87LFNoTX8yLxj6Iq3AoBIhOuQXIAWtRHjK7EFbgm/3z+2j008ir53ccZxmvMKHHwlYKZN1wA6udjxmx4bEvXUBYdjPulXsoxZhz
 QAETIIpB
 DKvxoztHYYCMuaSNTIU/lFZeTFCJrhs0SAQt9mkwFkiHSuTtwTKkALytMAbTMoc//MnOsLtpcuFgpHuQ1gjpxCL5aU5C03+YKT4HMCn8NBtjNm53pzD5ml9OQxORJ/vYLTqPo/PlDNeWjTEctSy/Nu544HPmIfXSry3fZp39HANCAtMdZOqsrvUpjUno6PCtd/CsAL7ToQLQcYh0IvUmhW2/I1+sg2ncFtIj7wMuOlf7nuHFXLWfXAAVL33vDo/3LajjK1lVxOtmq5RB7ybItfDLsIIWGTq8qSdJTGkBrud3yPOVYdRs7AarV0zzPPJHqyDki2K2CSf7XAxhEFpf+j8qi33ldJ8CV9qdEbWEPOShP5bc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The generic implementations now suffice; remove the sparc copies.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/sparc/mm/init_64.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 367c269305e5..4a089da0a490 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -2579,17 +2579,6 @@ void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
 	pmd_val(*pmd) = pte_base | __pa(p);
 }
 
-int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
-				unsigned long addr, unsigned long next)
-{
-	int large = pmd_leaf(*pmdp);
-
-	if (large)
-		vmemmap_verify((pte_t *)pmdp, node, addr, next);
-
-	return large;
-}
-
 int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
 			       int node, struct vmem_altmap *altmap)
 {
-- 
2.20.1


