Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F953C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 07:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BA316B009F; Wed,  5 Aug 2026 03:05:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56B176B00A6; Wed,  5 Aug 2026 03:05:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40D566B00A7; Wed,  5 Aug 2026 03:05:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 15A3F6B009F
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 03:05:47 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A55C4C03BA
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:05:41 +0000 (UTC)
X-FDA: 85066330482.15.001012C
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf03.hostedemail.com (Postfix) with ESMTP id DE2962000C
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:05:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EqCxDivg;
	spf=pass (imf03.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785913539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RC72twCjx7gm0pkHFHXzddlSN7aVUk8AJDJN7UXJhYI=;
	b=J1j4F5Wfng/xKuLl7JTo48cwOzPeoHw8SkubQsvL7a4e5+cZdEWhI7fIjSKhUC+eGN2f3D
	vE0+i/+WHifpZ1bBchvDj2RG1OsHEvzMSNieLJQpvuqO8KoU4j2c5vjxM25Qcqri8t/HoR
	pBJyj/47WUDiwZe2BMgCQdg4RNsyg8w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785913539;
	b=5k1Sr+zyKuZUSu8E0+tJQIVnPBh5RkNf2mGpnRI7hPdOQYSdTn3gP83MlcjL5EELuo9k5o
	B1WTrFamfKlFFeWnWUQsBIYUXJA7HMjO3z2KTWLWAykIsIfSllThH5jGPzSAlUwRxs8Orx
	zs1TLXfAI1cXpwIKeiDY/EM5jDBucCY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EqCxDivg;
	spf=pass (imf03.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3811f512167so721913a91.3
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 00:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785913539; x=1786518339; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RC72twCjx7gm0pkHFHXzddlSN7aVUk8AJDJN7UXJhYI=;
        b=EqCxDivgHXXlywzGyAa7a2/H+lFdxwnBMzw4/gotuxhkwJhobduNSgvx0YbgSTTQIU
         cZG2VuVPNCKcf47JRosHFKTcTOwI6eNY3lHKIv2NMh/mH0WbmbLv/r8OtZuvRLVWZf7g
         3Q2A7NekRyMSvbE6Cw9LuCvZjEN8nQfWcmddD7PtYtEdSqyQqmEnQ6goT/Y+HxFgxtjB
         HJH0gO3MBDBg1+dD71uRDRaivPVtzbl2VZXLLargpAUMF8R5YFI1vCChg0UXat9UOpiI
         zU/hz0D86ifA5MaNTTlCTppUYcpEIHvZJwMK0uhKmNhOOQ7Stcj6Nykk0/E66SEIK/Bf
         HXRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785913539; x=1786518339;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RC72twCjx7gm0pkHFHXzddlSN7aVUk8AJDJN7UXJhYI=;
        b=Frclg9pWiHnW+t11Bn6HWCepKO19jRv6dklASKrSxSFy/1dMWXSJTrqIrXAbarlHVT
         7DN+OWP6tC9Iun04CT/cDHJZMq6rSe5PDe4zYqLzzfrPCvi15N4Iu8pBV9/6pQRFd6Iy
         24y5OoO9ZBk2MwU+D8aHsn/sZUOtAgVfYeM9n/7mNiTLINgWM8SI4ly4nnp93xeRewfO
         b5BRX7bZRm5PuOP5T17z5CuaUCH+OE3JaJrG5XzRAHzVsPZ6WNMIt3TfN3Jzh9lYdKx/
         wXa0lNSXq6m3Zs+cQ07Kqk8uab0j1UfR6X2mQrh/8dNkGj8F+RvrtnzfHXVvBJhXDA/B
         QWHQ==
X-Forwarded-Encrypted: i=1; AHgh+RqUStCNpdbT9Usl3yCsyufIQRGzZllBkztDf04JEXSpz1tD8bEKdGfn8vPR7Cz83fzkcYqfL8A1Dw==@kvack.org
X-Gm-Message-State: AOJu0YyxE0cFQNxvXNmrwE73t7Xm7kJw2K+PAHN4Z85myNcy17ce/P8a
	zUbAOULlElCbHVwrfnp8z/H2i6TBcRt4igH82vU9XUxkw6KvM1EATw27
X-Gm-Gg: AR+sD11oQkRsnjSvGYxVNuTytAlZoPzdATWE1B60pf/Z1FCuWqFIH+w4HJXzlRb7eK+
	B1IiXZl8DSwvzPX2cqg94sVOFaYiJMxSAtRzjNPp+kT9PLcF+sAs015L5aRX1x7wJI9tSStnMTt
	11D7vEUmO+FBj8mT+Csp9iLaFTEwdSv17zrEi38C0CUo1ac5AZQdhA5rTF1mYDfDUpbKMGYnai2
	Gm11MyWjfDZC0yjm9EfZiZpXmfyKd5sLWH+tBc55yR7C4qZa2o6E46gV2K/LnihH5mckqm4UcEa
	uFj0yivMzNPaKITwZtKWadoYNVnN3DQ4lDY0YfzghUMH+nONIQw8UD51eoDWgRxBiA3vnu5lmjS
	3KdF7uisC5HrWJQG04w9gid2qYHzk/kh6gLvW70vmkI4qR7A5ezWMguGHVJ0/BqPIHpSOHcAoit
	U/G/Wl9+X6laL3yNRKzdbugB0ah7x+2IoM1W5n86FIV6XegjnYYlt2VASa70COldO11DsUTgIp
X-Received: by 2002:a17:90b:3889:b0:38f:57f0:1f5d with SMTP id 98e67ed59e1d1-3903c5c4491mr4424905a91.15.1785913538547;
        Wed, 05 Aug 2026 00:05:38 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3903f5d9b91sm1106309a91.3.2026.08.05.00.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 00:05:37 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
X-Google-Original-From: Zhan Xusheng <zhanxusheng@xiaomi.com>
To: "Liam R . Howlett" <liam@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com
Subject: [PATCH] maple_tree: Remove unused mas_is_root_limits()
Date: Wed,  5 Aug 2026 15:05:29 +0800
Message-ID: <20260805070529.4118794-1-zhanxusheng@xiaomi.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DE2962000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: i9j53ujhc65zgsjzygqgto9wizw5d943
X-HE-Tag: 1785913539-177502
X-HE-Meta: U2FsdGVkX18P9rZ9H72ryNZMaIPvJk/80PHHOqLQLqw5Ne3plMRvmEM3Nnkx3sI+MkTuCu/6kSaYxSY+yOUD2s1C+g06mmAXFGjm1oiiLxTxYeNAkzGNMq6Xep/yEPi4aSnbom0ic/ZNHX8RcN/fNQ1feyRpvhoZGbQDzIhY2LOc5HLXHsTA7fE+62INapp9XPVZBpEaXLTHYp/tnNuOOBjjWtwzcVc+jPYWdfkoIhGIH7yNdJgAXa3lFcnMYjaQCavuhhZuDDwO0AIdb/uKGVFQq2HjJLqFKUmX8ZbMQC1zgMP92/p90rD++d86wGvaj9mKFTl80EkiwvU2Vj6ukBlmbWDCV8Fb7oefXXuXxTocIGsQ+blVpThAs1DoHIEghMQQoAe9Xr+KrUkhn2177g/EjHt/Uc3S32nfgoaGxlnSZejbOFBIqjpVGHgWahK0QPC3qOlCYI5dDeoKsmL1tpYzQCbFNuBPMhVNJmKYGYEBALk4dws8Hk3DOk2qbPQU2hsgtyzp+AVEkrOMB4tZKg9bxLKEFCm+5DaLnEFsu7m3k5kgiH5KL+D0dsmELOXHNryT1ZoQYM/XWq/KKIXKy6p9y/Mbh17v2r3+2AUXw7CaU+dIBStzNNuydWDDVr6R+ZezJu+2Ef5+yKxUkoUBEQGwsGNUOzUYYBlGOkbnGUCi34w29l8X8bOidv1ncTkscI3X8N+81E1omxAefWlBL7uxntIjSoiz93Hd1iI0xoOuZ89ApUSrkx/jz88hX9NXUpiqINi23XDPOLqDkeUXzCwfOVNvEUmdcJCORsFlXlwc5dLzs89vIWyX/LZBjJNz4lKqaOi1tYeaD9wGSSosAxd8kFt5hUQ9gCo1xr66s/DAoTdl7fKbTC2naR9V0EmvH7lLS/yu/LkSdtoU0FrHtUVZHplLE/BUQ17IQrkwsJvZ6+xtzSkhK4q3ZF/D7QRw0mbKnpybRKuJZ2GU3Uw
 xDUmnf+3
 Iqv9bbl5mVM4CkPkzLmAChv4onTZ81YEg9Wrv6HWn8b5Gw7geWzR4MkYVSvg2BWalukT6ooA4q88i07A1g0ZbJhf6MFZ7OdlyuwC2dpX9JIptqjhi21F4QXIHIKwOMgqhrUDGjWSZMhmeTgLj9TLvSrSiazeyY1CCnErlNP6g8wTDKbHWzax1GtCn/aP/M0tNtq0UkkfohXnbkZq+OAu8FwdjXOdzbpgll6K8pZgquosDN1m8WZz7SyixWAjOVgq6ddvQBbAHvvoxub2bGPuN4APNmYd07UiPmbxl3F3rZ6WVL62UG1Da/92jCInnBDujHAxvvdy/yd9HpDhMVN3ZIkgJe5vKKKT+G3cvyLAuKZzhW/Gg0dUgfcRCQPXmSATPsN39AIQbxcYypPsWGxJleYzcnCI96dWmPFoD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The last callers of mas_is_root_limits() were removed by commit
b8852ef30c67 ("maple_tree: remove maple big node and subtree structs"),
together with the maple subtree state (mast_*) code that used it. As a
static inline it does not trigger -Wunused-function, so it went
unnoticed.

Remove it. No functional change.

Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
 lib/maple_tree.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index e52876435b77..1bed455bdb9b 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -356,11 +356,6 @@ static __always_inline bool mte_is_root(const struct maple_enode *node)
 	return ma_is_root(mte_to_node(node));
 }
 
-static inline bool mas_is_root_limits(const struct ma_state *mas)
-{
-	return !mas->min && mas->max == ULONG_MAX;
-}
-
 static __always_inline bool mt_is_alloc(struct maple_tree *mt)
 {
 	return (mt->ma_flags & MT_FLAGS_ALLOC_RANGE);
-- 
2.43.0


