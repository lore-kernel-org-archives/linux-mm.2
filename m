Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17A9BCC6B03
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 07:08:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EE816B008A; Thu,  2 Apr 2026 03:08:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 498D76B0092; Thu,  2 Apr 2026 03:08:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AE976B0093; Thu,  2 Apr 2026 03:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2D5C06B008A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:08:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A61A013B0DF
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:08:57 +0000 (UTC)
X-FDA: 84612738714.02.1D43FD1
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf18.hostedemail.com (Postfix) with ESMTP id CB8A81C0005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:08:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BjReCUmX;
	spf=pass (imf18.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775113735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pXqVqKsO/44+sf0WqfVuWAIy8twwlZ1ww6xUKeKYgIs=;
	b=y7hNyKZurnH7qzLH9dt8Du2WXi15DhzxxD0z0QJez2CHMWu8ksZiZN4IEztYLcxnTATO+0
	txtiDpgeutYwheirSkQ9Hk76+vNVdDr5og5CtQ0BywhXcaqt1MVX4FujZuFSqnKNfK8NpD
	8pMnBxuyBLlShUpJFZzDkXg928NZv68=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775113735; a=rsa-sha256;
	cv=none;
	b=eUHpJUPo8cD/yHH0ZfGENGJOrcpmcVfsEH0O57WO5eBgO7Ujizwq5BcQNMYNjGn2aqNteh
	+zMWXsYijt+dTy9UbPugstQSeB37KOTqv2VP94u5/8yO3KeX3k5XvlbCwPUW6qYLp0AdEL
	KzVJaJSkaGicoSRW8nNPBR718gKIL0E=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BjReCUmX;
	spf=pass (imf18.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-c6e2355739dso208978a12.2
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 00:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775113734; x=1775718534; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pXqVqKsO/44+sf0WqfVuWAIy8twwlZ1ww6xUKeKYgIs=;
        b=BjReCUmXVyb/4XdOpkWYzUDqOd1hQTZZW94B/L5/xodHqw2NDV7/sr44W5ecLq946c
         DDxf811U2S2yG58SqZKLQ1JFusvzOyKnFfO09d23lkg9pAyLdVqD3u0oOw64ss7Sjumt
         U29cYc1tPj/W/rQK1EFT7kBtfUeBfqxdvuTRTnx2UzpU2hadt3pFemsC3GgFk33ZXNxB
         T6BHgu80uMoDG/IfokNadaZ/CWeGgCeNzG8OWNDQgA3xzq78XWgRsrrPp0fnC0C3syHp
         2cjMdM8PS9D9PkwSZ0ebM96bAiSkMglfzw80sqItva1UIPTQRWVX2U7wuiaxNKdLgKs/
         WENw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775113734; x=1775718534;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pXqVqKsO/44+sf0WqfVuWAIy8twwlZ1ww6xUKeKYgIs=;
        b=E7RSHfHsnPrXGX+MeJxN0ooa3/qzKOmI9XItA1te+ueXFsSDebsv+DzqJ+wB4I/P87
         XCtfgiOqXstqE9lN5iOnRRpDoPbdVWqHyVEZ5HwKvUkSPypplJlSnTzsOCO/U/3qsQYO
         C+QXEIq+hQ+0cGWfNJHT6O0KKOD9sknBaxCZ3+eKKczGqqbAMcXZIUoEmuviLmG50oUY
         7JEFUAO61oLN4QpmM1DNhUbQiApnAarBe/LYedlgQglO2PhGbvNY4c0Gc9dfckU/2Jqd
         nStT8Q6LeTRszATswzEOPf5HELcwysJE0kd0P8g4rhrxtuwT6XR5JdvhC7wIh64r8kT7
         A1vw==
X-Forwarded-Encrypted: i=1; AJvYcCWCjgNE66z+Lx+igokffbsZeF0uLCQpeirWT3DH0PPsOJU2Q/a0RKue1JDfYbNReKRmIiITzP4XIA==@kvack.org
X-Gm-Message-State: AOJu0YxHKMIzxeKeY+w/pUg/Xj6jiTWnJZFsQTcAyVVXr69g292ffopd
	4QmYT3mOYuZb5/FXgr0VvaJW+ZGCG/0E7jAXfQUn0HxDoExcncGIH5kE
X-Gm-Gg: AeBDiev0QvZRu7uTA5IhqGIPIXThXEItC6LUc8JgSw66qbrdJTvqIEL6yTJlSIHOIZ2
	Z4U26tmZpJCDnRMcOKtFk08v1c5PdEVr1tlRNPxe4jQdayFD3saSvmWnpA0z/2Fpkg5FQPwr78O
	DIBFtfhpz3JjkeL58jws+/VQwHQhiImz6l5SVatdVSPE3CBaaR9pjNwecHgybcOVZXxLGQpIJnq
	rmgjEYF5oCJ7iQlfIROa3hjTldu6Gf2Uy8IEGE/QxYcDXKdR4uqlhffLKkPrK2qr2g8Y9lewBC5
	PKEr/gseDSf0S6g47sP30hhBr5fxyWhCQj2+AeDaAS8Qx9nurYSJUhFE7LEFZ9AekhQlC7Y/Px7
	83TDIqfir6CPyGxRaVHsswtMHp1zSHqBZnPtdnlLvU/MqCFAuQCsLwXTspnfD62W0l25/F1kFOY
	4mmlfzP4d5+rB/yBGLKUvombHxSvxiU7g9r5Ffpd4GgIDVkW3G8Gw=
X-Received: by 2002:a17:903:2f03:b0:2b2:42f8:1a4b with SMTP id d9443c01a7336-2b269c3f6ffmr63223295ad.27.1775113734366;
        Thu, 02 Apr 2026 00:08:54 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b27478cb4fsm20173295ad.29.2026.04.02.00.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 00:08:54 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: aethernet65535@gmail.com,
	sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: (sashiko status) [PATCH v2] mm/damon: validate min_region_size to be power of 2
Date: Thu,  2 Apr 2026 15:08:51 +0800
Message-ID: <20260402070851.27382-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260402053756.26606-1-aethernet65535@gmail.com>
References: <20260402053756.26606-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 9babgdabuqxgy5cirprb8cqau7xqd337
X-Rspamd-Queue-Id: CB8A81C0005
X-Rspam-User: 
X-HE-Tag: 1775113735-997379
X-HE-Meta: U2FsdGVkX1+6k0WRSfNsI7HIMmNjyxJn42yR8QRg6xj3eM+ZL2Ptwf4viMT9btyRBesseO0AgU1IT92U2lWrQ9PlIC4XmMxtyyvMs91JvmpD+rlp3jveg6D2dmLYNlNuydD+5nyz05sTW5d6BNwTLl3U/WvYf4L1SPb5QVPHPvwtkXhH758SdX3+vnFLQT2oMNdam2gLYxTz2M281EOCjaUeXenRMjMVQZVxRzdzInaI12gwkCzfid2I1NgIYTZ4K5C+nDl1UEtCiV1JLHlnCAptHTpweMcjY+hwUmvOatIZhxhQlsv9A6fhork34LOvnkW50KiyV8YNFjnXI2xLHPDDmh2N5pj93xIsHVP1vUlLVTCfujwDB91BXBJ5Lfh/8DBeuOZBKHxvID8dqzkZ6y9l+8JHd1znuoxnFAmA6RO1nLDw171sfK13JGBCQO6Imvpmv5wvorK5GY9QAkYe3YFrHuQjAhCHMSZSTiSP1++XSED87hsHF7aZZZdS/P1HniKG+kulNUOt77YFlxJ9YfNgu1DD0WWoVkhNIoojUSZzqEjJEBcrT5sTvZRh1BPEDP3BEdBvBo6/NbtcglmeP5mm5Sbq2ilf16u0kPp2eZ4j3k6dCs0tVd29Zfzck6Slpof3nTGO9OqaeSWjG1149lgB9ckGnpOYPRbuyETzVPLWm0tnW8YvmZL81Hm4MBhF+HJDm9DiyofDK2vZ4l33N5f+uznbnUBagGj5bWlVDqfIuVQBJDFU9BAAY0HPO1g0BkNyNu/NJ20JG+p2GAFqlcQmn95XblRHNZfVac4KS5t7UJm5T2CsLM0mz+B8LQ2/RrCL7H7o6GtLgAH2SHGAaf8akOyxjxtmftFszDdVjMAT9zMSbkRi2dmycHvyA78duLc+sijM/b/+NUBqclGBc4J8F7bn3T3heVYW+ntvIwZ46O7pSfc9wvVv5p9y1iyG5RGMemqM3JliTgX7YkA
 I9RIRwIc
 rxB0q3CgmjWoKdVyXEE7jhoYObZZgpIL6z/xm+5jqDHzktSmxumidNaHeqOjbYNng6lwVYhtLgS4tPo8JhiHqys6kq2BbuXu9AO6m3Guq4On9pvFhoP5NWrgOZA4bzZHDfaDX9vAktgGaR/yit9cfahJSSFzZq7cjurKIOfzPXxGFMU8O5ba+vmiMKu8VGTkmR+PxRmkuM0GvNDV60Ijy+pV3Xe7JmeJj6RIfiYro0hzPYLucuE3IMa/GQcVtsYSBT90omVoos7ZCXF1GZS10yWNlGdCQQrTP/3rUcw6EMxYpm6KU2hRDmnIiF7SDxlH/meVFlL4BUSjp0m02aZ2xwDF+NUZ56wvtkTTJ6dFEEYwl/1BxWF3lGfppl6qMi7YOXoRKk+ZEAKl6HhnnC733ueG2i4HFafHxyRy/j2V8alK8Guh04sL9dLgOhhONdBTJlH7pcCWq2b6FA5mAlf735asjNqmYLZn4K0D80FTWUMWw7t2cPFjWLAHYO0RI4BuB6ZhRHt8OKwnCfOQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

- [PATCH v2] mm/damon: validate min_region_size to be power of 2
  - status: Reviewed
  - review: No issues found.

# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --thread_status --for_forwarding \
#             20260402053756.26606-1-aethernet65535@gmail.com
#
# [1] https://github.com/sjp38/hackermail

