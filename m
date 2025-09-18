Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 183B1CA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 17:45:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 101DB8E012D; Thu, 18 Sep 2025 13:45:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DA408E00F6; Thu, 18 Sep 2025 13:45:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F317B8E012D; Thu, 18 Sep 2025 13:45:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E1D0A8E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:45:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B277585962
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 17:45:48 +0000 (UTC)
X-FDA: 83903098776.13.6D8065F
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf11.hostedemail.com (Postfix) with ESMTP id 19E7D40003
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 17:45:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="P6TL/8pr";
	spf=pass (imf11.hostedemail.com: domain of manish1588@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=manish1588@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758217547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Cd8J6zc6d0XOboiy3w4ytNv/wLGIoS7FaedxQjksC+c=;
	b=hqeDBXBFUnXPaycQ1jJ1SCu5bKdnsWOy1uYq988gXUDdVNXgwTeYZSeBfB1AlD+TAwv94j
	cVS8r+y7lL4NFXX/ZrX/z2LIgC4CUqTlm25X1spVN6el5O0bRw4koAaU8fHXYypZnkuthZ
	nY6DTN0NQdiBj3/RKnSQhOpjM3etS1s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758217547; a=rsa-sha256;
	cv=none;
	b=kIidOii8pF0QSNHMKsASZDp8HjBu4Q82anhIufXWUd1MIIsWeW3vkDB9T8Z+saufpWqess
	n8kjD2lDyGiuPO1gf8uxcjZqiiwmAUBdCRAPZpMAVQ0DdpFACLjeEZNtPkES46QznXZQ3m
	xsfU8EzchHrD915UKQ5ECu02R4HhGSw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="P6TL/8pr";
	spf=pass (imf11.hostedemail.com: domain of manish1588@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=manish1588@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-777ea9fa8fdso1316134b3a.0
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758217546; x=1758822346; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Cd8J6zc6d0XOboiy3w4ytNv/wLGIoS7FaedxQjksC+c=;
        b=P6TL/8prU+2IkUU605qd8x9RE+0ie5+YvSe+Yq2Pn8TgCpdQS48e/Mcx1Hm4TnQTvp
         BbXxnY6N9U2a6wQbqjQK8i1eqbRlGW1du0h50eRKlA7cQpzja9w5vmaey/87Deac/k+Q
         aZK5J5bIW3VDg7XVIl7+4KzE1WZ5YTKVBpYZa88t3Zw4VFGDUG7yPtYIUhErO4ikhnme
         szvSmT53Gc6XsKD52/hlePTPpM11UASZXayZKoTgJ6jVX2Bxllzs4eR/TGPk5dJuSbo/
         x0RlHOYhFWozDqZc+3SBJr0LiW+QKw55+wS1qbG6oBV5uABBXasj02E+chIKIvRE0S13
         sKwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758217546; x=1758822346;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cd8J6zc6d0XOboiy3w4ytNv/wLGIoS7FaedxQjksC+c=;
        b=DvLIiu88XXCZ4bGFAA0gnHesj4lYPl1tpfSbpYkLDZOLca4PGmLSNTBHFyEZkLR9rK
         IEMIciNgD6zWSJh2IWEsjM5S6DYC/OKhIEFVKV/AK3PUKQ0ICsWjvD/RyYsz47Yj4Agt
         6TPn8IZ5ZSRMNaw7C7ifkWuZQOAQWVZLc4RutrO1w6F2PfEtT+eitCn6hGQfvgacWLxl
         1e5GBt1G383oRlqxKRDuzhxs24yLGdQU8gK+VaHZntonzLNZ9ecajr17WOZEEIjlkCmk
         AeDmGeS3MEmI/s88NhfQGyu88MP3UBj6FUN51BmvY05g7PR3tsyroG3KaK8YHQktjsv+
         NVgQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKG/n9mtsVB9zLcWtp1FHAv6b5APoS0vkLsW44A0GWgamTvnTP+ohPMOcfbYlM0eVHQMnbxPjcog==@kvack.org
X-Gm-Message-State: AOJu0YyZLj7Un14sq5S9vIh+BIN4Jp3mxu7Jccm5X2OVnhJdOcRDPGH+
	FBSS3pw4h7z3AZ2kYOx+1ihr9zkGRVVEAOsuUjNKYHTOK2e/z3bUJIzg
X-Gm-Gg: ASbGncuc/zKNSiOtjRkvId6nCgMl+DF83SGdcZ5NU5UoGfeWp215gMwhbLZ4dcf3Fxm
	H2Eulggx2Gk5FFqER68iDRPffV8I9ubKODDybAsiPjVlF5Fit0rLtr1bDMamKmtOQ/RyChWnupq
	CWytVHnK8O7nxVvj1RhwFtkugT3ZnsB3x2DolOBzxeAoF0nv+nffkMlwhtEG375SKT9xkFFcI4P
	KymlqfDb1QSd2d+8krlvR78iBdWdGt2oE3qPOFrNSkwa2f8UNajPmBd4IaDUrSWOiuMKnO/V4sJ
	ZXGuWt5X30yq6oTJJkcawdE+2FlKAuBvv24NZRRHAWlNhuGCMtxJPQz70re0nCC68/amQMGAKHy
	mdK7rzt19v9bnzPXWGVl65XRprIvVKl8277M637x29A==
X-Google-Smtp-Source: AGHT+IFh/ztgMpAqjwhJWgVmQzwD0/HLyiKJTGmOOzgeN3hRgqomZDAlgPXqicFibQjBvGoROi5d/Q==
X-Received: by 2002:a05:6a20:728f:b0:243:b92d:72c1 with SMTP id adf61e73a8af0-28429d8d70fmr7373610637.0.1758217545766;
        Thu, 18 Sep 2025 10:45:45 -0700 (PDT)
Received: from muxbit.. ([2401:4900:1cb8:2c41:4cd2:6b0b:66a7:bdd9])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b5517282443sm170727a12.33.2025.09.18.10.45.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 10:45:45 -0700 (PDT)
From: Manish Kumar <manish1588@gmail.com>
To: david@redhat.com
Cc: osalvador@suse.de,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Manish Kumar <manish1588@gmail.com>
Subject: [PATCH] mm/memory_hotplug: fix typo 'esecially' -> 'especially'
Date: Thu, 18 Sep 2025 23:15:28 +0530
Message-ID: <20250918174528.90879-1-manish1588@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 19E7D40003
X-Stat-Signature: dd5c9nr18ocijikfatf4xih7b43fthme
X-Rspam-User: 
X-HE-Tag: 1758217546-465254
X-HE-Meta: U2FsdGVkX1+zplumTyqhPVsaqV07ZroEyuMRVEl7BIJdo8+f0+LbHfnmXhDQIvcEaYRjLIJfEuCt+spw7Uwb5hbS3M9OO0l3zsOZr32Vb43uzgN05WCvG+9JjHHz38KnQ3xWiCvTH5KUn0ypoB828UtqohGf1FzbI9tLOZwNSGngjcQwbLApBm3BaJomJrA6eFCq+Hc5mVn2pSub9oUltv8o2aP3F9SHP++j0IQ0a0aR1TdW3TsI0z5oFpj0Hd/+D7D8428cbtlTE94/9jGcUh79EyQEBwPKt71BsvwGcOyK1Q/FbUzYr9LD2Nz1P+M02Iw4upKyP3+TtG6SStwhUk0obRecmvZlw1j37Hey4sUbxVLuIvDYWHre+h/UpqBzWfvCQ0CtnI0VgV2/PbmMh7B5n8DiztTeENhqbhi0DtlPiURhokYBh/5FbdbHPI6oQM7WqrXd5/tk3upubB15DAbflSU4oYUYm26GL9AUoiD76dyLNYMqGWNytxaAxqkXp0xKKkme9OMKCer+oWW61CWr9fC92FGWxSgQ1a7AWSMcbIhqBUIwE3ibW8w06wwlI8X3I2LwFJEEezTBouCCtHzCZHu1moJEf/bQwllOzuDxrphWtG8iVn16aiqrvHscElwI6UKP+7btpZcAjUbaQKrqKCJk2uh8tFkthTeZr8UZlY3+rsTe8T+qBQcWBhoRk3Zgvail7Ne7y3eSsUJJGSFy31qEALhQihlO8BS8F17WmZvvkLyH9UalJnTQN0hd1ljK8A7ol2hQdEH9aiVo8UP+3Ruu4bCQfggDgoVxdq6uLSH6ElQuQKwZ9LZbFjc+eAEW/lEt4OeQ8RIWsFjmtXXsNB/40g4vXjsX4ZSC1rsIzIa5JxOQGA/DJmSE07YU4OBr41W2oLYD0rxxsnbgGRtSuqRkwngVq0akNItIBFC+B1HkSfVj6SZ8dT/627dChuNIlasn/EreHtq2/dV
 jsJ9IRB8
 im83XEWETsZaBNwaZDsoNlSoKbUPv75StKXZYcOM1yecUS+qD7WUcHqy5t1QBr+SjUiJQf71JvvL204hTp2XGX3nOIeoJG4uJjtmi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Manish Kumar <manish1588@gmail.com>
---
 mm/memory_hotplug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index b1caedbade5b..c4436a247ab4 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -976,7 +976,7 @@ static struct zone *default_kernel_zone_for_pfn(int nid, unsigned long start_pfn
  *    effectively unused by the kernel, yet they account to "present pages".
  *    Fortunately, these allocations are comparatively small in relevant setups
  *    (e.g., fraction of system memory).
- * b) Some hotplugged memory blocks in virtualized environments, esecially
+ * b) Some hotplugged memory blocks in virtualized environments, especially
  *    hotplugged by virtio-mem, look like they are completely present, however,
  *    only parts of the memory block are actually currently usable.
  *    "present pages" is an upper limit that can get reached at runtime. As
-- 
2.43.0


