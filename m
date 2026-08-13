Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC7C1C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 18:39:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F127B6B0598; Thu, 13 Aug 2026 14:39:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECBB36B0599; Thu, 13 Aug 2026 14:39:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD98E6B059A; Thu, 13 Aug 2026 14:39:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B97B46B0598
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:39:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 48B42A0243
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 18:39:28 +0000 (UTC)
X-FDA: 85097109216.21.A9E0C88
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf15.hostedemail.com (Postfix) with ESMTP id 83DF4A0008
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 18:39:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=p7vqVOcV;
	spf=pass (imf15.hostedemail.com: domain of sercombe.joel.mark@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=sercombe.joel.mark@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786646366;
	b=w2G7jG1Ci2IxypqoeAElJExxA7bQo9dVW1g0TIl8/GwpzcTXpf+SBB/PFT5YC6IwluYQpK
	dX+Babxl1cT6CHHU6u3/WPijRt3VfE3Ot6BIF6xQ7jy/LL5CpU9Bko+YSn+lXW0PIQ6F62
	b3CcNGRNkSY0e8GqO5vTwy2iD9uUk/g=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=p7vqVOcV;
	spf=pass (imf15.hostedemail.com: domain of sercombe.joel.mark@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=sercombe.joel.mark@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786646366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SgK4DEd6BBg5X57BFCgUioT6ZPHEzqx624Ajbmn7ogQ=;
	b=In6jaH3KH1dxf/Hql6MZFM7g7Bxr2k2fO3yMYmonOyKtU8Gy6CH8AwFB77KkJfErhV2wTs
	l/iHvaD6M/mrgqxN6daPscv4CUdZoP9zfBnzYDAwGF+K4LLqLp825GU0Oy51BrgWJQFMKN
	PDqVR/ZJVCW4ueRi1GctCim3VkPEFS4=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c15cd3fd760so31396166b.2
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786646365; x=1787251165; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SgK4DEd6BBg5X57BFCgUioT6ZPHEzqx624Ajbmn7ogQ=;
        b=p7vqVOcVRuf1Q5hxxrFj3sO2Ql4HYKXRsgf/zByElYFpqD15/UYD6pXhG0Dnyy8kqf
         pyoUq5SDjnL9B4icAQANzohocJLlvaXDn06nHltyZnfe4r+Gkr0GRd6uWMRs2gQxf1wJ
         Z2wOIAakFY6XQz8yQ5DJliRVZBciohRVWGgLzOab+EE5u5nRt9EdkW7KOJ3dp7H1pwWu
         Tba8nNpTK/HyMd2DD5NnQMSjPzt3PtoLHhboIuxHFQnn/CbEhkb5B9GwU+W5dBIkPIuJ
         XKPBAE/W9k2cJFrLQBs2nPQvrhXKEamSl7o6bNat4ge+Knw7HBk0HwbT2x5rxjyOJmra
         iL+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786646365; x=1787251165;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SgK4DEd6BBg5X57BFCgUioT6ZPHEzqx624Ajbmn7ogQ=;
        b=svap7+q0G/eYH+Ofq494+lQJyLv0vjtKHYdD6j9cHgKJaD9BVwtRNefyJmVylRTN26
         xv5uGuweOdAh+/MPf/2tGz0mXtFrQEcbg6eaYKp5oVwmUacKouvh/RnRtB2mwkrZH5pQ
         DPcNcUAe5j+oSFLWpscvQ5/pybP9p1DZ2PiG7rYjeu7PuLeQj2RyWGyNUVDzyAIGLLE0
         XYlZ9YUUDk2g2YMTwqjPGHt4M7P2Cuv7xniWdGTPvJ+JGnCdW/9Z/zvrflb1hhKDSjbr
         H78H30gyPKFokB/wzcGUxQ5hUpmYKmZ42+WHRc4oaW9vWs81HLGTt1EEqfQL63P4QyXD
         ZS0A==
X-Forwarded-Encrypted: i=1; AHgh+Rrmddd3B9RVi5PLWA68uesLlN/ikcuPdEsqSK9Ix/T5owwBTq4n9bFSmS5ea7llW+IVmsNNjtzZBQ==@kvack.org
X-Gm-Message-State: AOJu0YyooIx+tieloBln9oKTTTsedwnsUxj9mu9cjzXvoXkW9oMOOJWQ
	+Oi36c72Kxbugfy4fNeLKIsOiJ6Ar56V++iu0joRT2vMrH1h8xThXFE=
X-Gm-Gg: AR+sD11bZB2TbwLrsVhvYapMgaS74XeamHTseBC74pozu2d9vnpwkPQ33sR1uGYzVOq
	IxVhVrKFkCTJ3uxhqbMOpVg93MByOVpfkXSmFnIGRd3GyM1PiqQt/N61VejmhYVyiD7ZMwPDCMb
	zU9OOlECzF6PIkRhP3xjwBWT/pnVgrDPgwkzEPOAocxROyiNbU/uxAznTM/YRyQ14lrL3gaIuTk
	znTS+dq/XcdsfH6nPNVSHaAIqwuQpyX9yTBWHVqAm9bM8k0C3yVoihZWIbFdtTxmCCow7vgwj6i
	OxygDAEVOEf+POYGvz+3AaGjsJoIT/IOyWPu3CJPVOlCC+rdqYApKszKJaq46gch8vzyPCLa4S4
	sNCFoTrec14NnQF7MDsqcE6493D6lg6Ugd+hO98rsi+InkEN2M2fCZbAFjOZ12GsgYvCvLVWZIt
	IeYcR/yzgOctqemf/DGbqWaIAp98pSXgj23fEDC0QKkBQQ93SwkfBqKZ3C4Vd8OBMeX1YFWk59N
	ywIO852I68QRA36748ZeINtxXXPIIF+DQf7zQ==
X-Received: by 2002:a17:907:3d0c:b0:c20:fda7:1856 with SMTP id a640c23a62f3a-c212a0a1c6dmr17816266b.8.1786646364840;
        Thu, 13 Aug 2026 11:39:24 -0700 (PDT)
Received: from arch.tail2fcf52.ts.net (223-143-146-85.ftth.glasoperator.nl. [85.146.143.223])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c212386cb53sm19206466b.62.2026.08.13.11.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 11:39:23 -0700 (PDT)
From: Mark Sercombe <sercombe.joel.mark@gmail.com>
To: liam@infradead.org,
	akpm@linux-foundation.org
Cc: aliceryhl@google.com,
	andrewjballance@gmail.com,
	maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Mark Sercombe <sercombe.joel.mark@gmail.com>
Subject: [PATCH] maple_tree: fix comment typo
Date: Thu, 13 Aug 2026 20:38:47 +0200
Message-ID: <20260813183847.474357-1-sercombe.joel.mark@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 83DF4A0008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 5mxtyi1k1hcqx39cpsi6oiu8x9ry4ecs
X-HE-Tag: 1786646366-760633
X-HE-Meta: U2FsdGVkX1+bdZs61MwBZFAk1kEL/LL+nIIAkDvJ3ZGWbJzq3H0GzmlDhrktaL54aWSDC+d4TGmfvYPRWfZl9vRZ7D1K5dHeb88UD6oYvbPfLCG+bWpHgvb6KPg5htISmt24j2wWOF4qQdqT2w563WjT3NLEsCekxO2kEQ2mS1X3U6blL6kQpGL9M/1d7mYxI9yZCQyMdvqy9KhdGNq6qEzXqINrtm3r5a/otCMd/2ISR4olhGVcsmQ7YoNoRawvSYT600iHGNuFLmY62vibnQftpuLPDSyC7QZEKmxekP/E/7XQcAz8h/xomIUces6xU12yzPdkqgjXpmMREn3/gjC7oY2DiZx5tEtUza2rb2OdEOb+VnYYWv1bu15KmE5U1b1jNWRzI0RM3flKq5oAo2qoWGagDq779f+Wr5bM5KixksVF2SpEwVr7axfUeJis8emPWAXcYoc5EK9ieTEJfwuYmPS93rprijQqkDPVXji3Os1RKLHSh2MHFNzrO5DJgGWthL4EsKAZ38AA9/xpRtrifWhSukkeZSnOvY16wLleFIe0HW3O04x6+0nla+LVItERYYKO/ISxjkoki9EvBlFSMvNVfpr8leuNgFxYftKSLk2ziY2SpfnST9PVB40eogsD5i5V1FadLo3EPSPnMZuhw923aFs22V2q1ne0gvf98LOhYI4sWaT9ceKST3ZjjgMe10qjnHf1DcNasUb95G++cBH4yKOTtF6lo8+Q2ngdQkNCYLz8RNpTDeCJvxjDB24K5nqCDDiDfufknN0YVzAqmf6zIbHLIRQCKj50lkrsuI/HcBE+3L7aZrr0+EPImL/OcWFCnRCzL4sEHQlJ9tFie1dzdMrtyUmfk+V+tOpoGRWoZ7Lt9SYeaGCh5dzdnSCazBGLWPiACo+RtHoOnHpqwTGZNCEkTtlFxzsollruMwnxsr/22kgNDYuW17pjrmYH8kx0iNGE1c8FX+I
 9kAocdNs
 3vJo1ueI1FSXKCnVI36YDfQyiCpYRcUaAigzni0US7KIg4ZqlAl7PX5ryc1QXVLhYcpPsl6/Rvb6wGv2Ex9FsU932gJoC5DMYuqM7NfjlTYA0/p0dcisTxky8tOkD65HLYdJbXw4v4H51YbfiJNk3vTmNQqmvRG1nmOOAWVbuZv/9KWFrVTiwlll8CYC37dWW8rZh3YgKZmS5uq4EVwIKCbVcS6VV1YR6gwGm689ypIPCb7yhBQkRT9ZrMemhqVlNA3gLbOOCv4OTey/9Hf0o9IP4LFR0GAe2jsiUxiNjKP5Cpl7reUrh3CmPQE8gDf3CYbgwp7hUVBz+w5cazYcoQDGA4svkXQv6cp2E86EH2izd6wdk8a43cabYcZtfGRG7gQkScvBxeoQNk+zq40R4IEQtt05zsflH9aEyVmwe836VI9SZvknO8l0LmtSxfMBmD/GgLeqns7CJ7d6+FIchN8UOi1di+qxLW65u0k05ilDTpOJh6NmXxoJ6j72m8yBtIzUHcB7vOxdfigVz9IVQPrL6uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix a spelling mistake n a code comment. This is a comment only
change with no functional impact.

Signed-off-by: Mark Sercombe <sercombe.joel.mark@gmail.com>
---
 lib/maple_tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index e52876435b77..9e47f21286b4 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3595,7 +3595,7 @@ static inline void mas_wr_prealloc_setup(struct ma_wr_state *wr_mas)
 
 /**
  * mas_prealloc_calc() - Calculate number of nodes needed for a
- * given store oepration
+ * given store operation
  * @wr_mas: The maple write state
  * @entry: The entry to store into the tree
  *
-- 
2.55.0


