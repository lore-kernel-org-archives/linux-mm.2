Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C97A6CD6E73
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 14:58:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 303648E0005; Thu, 13 Nov 2025 09:58:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28DC08E0002; Thu, 13 Nov 2025 09:58:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 155788E0005; Thu, 13 Nov 2025 09:58:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F1A378E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 09:58:26 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 862B6140A30
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:58:26 +0000 (UTC)
X-FDA: 84105889812.09.946042E
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7BECA12000F
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:58:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ZEC5LOOz;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763045904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h95S7y1O/AgiNG3Y8C5QHzJHwFzVPf+f5SdvEJl4g/c=;
	b=63i6Z2T+i/DaHumS8XTggHL64LJt66NZMBulvhM+1ho0AGkhwmxlnrZpZf8fWuHNQdrVzh
	NFUSts8FRMBElzMPPKxZtXZRqaFHstj586h/wwqhyvdUPuSDOpgv4h7oFNZlAV2sm33XXz
	yurZ8KjdgyXc2maXk79Wxepf8dDG45s=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ZEC5LOOz;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763045904; a=rsa-sha256;
	cv=none;
	b=lXIPt5HK+O7y2RR2ghY7mSKlwq9oXmA03q3uh0oUJgAKvd3aGZXRx++lm9VRAW+DIcvNKB
	lRUMQLeVkh9Hap3Dqb5FQLMVujE9JJ9RSlHHtlOwsXRHWORIHzpQxbFTJ+wFkBpDWYljkI
	x8RfVOzG4e5qkBc7ekBJwHsuGjUM6TQ=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8b25dd7ab33so64990285a.1
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 06:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1763045903; x=1763650703; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h95S7y1O/AgiNG3Y8C5QHzJHwFzVPf+f5SdvEJl4g/c=;
        b=ZEC5LOOzLfTkMLD/sH06Ta0BYqKsJ6aLbxCUtS2cXVS92u9oiMokX0qSkNmftf1ly+
         AcRooVd7w5lkGbmIQL96rWHljywIy5/x3p4tc6qUI2QoM8S4SmJLrSZ1KgCjMknT/ctK
         0WV0b4SdBYvgskbsh/r2t7o7NGfmIAmIGx3qXIcZMCjmBRkwBjVw1ywaiXnruZPuKqQR
         +bCVVW9zORJ6n/cP9WQofDQ6PQCtJYlDRAtMFwy4pJTo77xp9nJVPbAOCPTXabdcl1Fb
         1WT+mKgF7iNjX7rqgUSpaq3nUq46/9fZvU2ettU02nvDXBZ3JO+plh7E1lKxHjPoCNUf
         x5Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763045903; x=1763650703;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h95S7y1O/AgiNG3Y8C5QHzJHwFzVPf+f5SdvEJl4g/c=;
        b=ETtSSQoJ91D8Wq7F2U+8woNvYhbwx003n8nj7OUveYgI7YZij+OlFv0bPAmBkdxDSJ
         yGgBoemIF2LdWYwYwuwYXL8g+iFsfyuCnP7VIg0tYocVDNi5Sy18jWjPcnRNz8ZLDQsr
         h62TBJcYpCr4TPOH9dpmZmdt6MIqh4abovMbsqmn4bytnmzo0CEq2OWsGD5wL+QejRMM
         vME0V6l227f2gnbEBY1ZEtidPGlh1X84NNazokwUbBC2HTANKHtYhDxLNwK6NmE+MFsw
         +QGuIkgHP29hYrbvnwhvpSE/on5osdzM22dtcBNCy8mIe4oOT/ii5AL7OXfuZ4eAIuQF
         3m1A==
X-Gm-Message-State: AOJu0Ywb7eXQ8NxOeBG72zs1JasAK+7KtZDP6Jm1pvlTiDsdLM+s4vu6
	ARpUt1bmyaYB8u7u/3ErhDxeV6RW7ssWmaqE7xDu7GGVfd3RFzGCFUBJg/XMHzfOxuncCNx0MVf
	QqqU3
X-Gm-Gg: ASbGncsKkGVxix9YZOi3NLqxJH6ZDF4xbo/x+rgQ0pzW9yBig/ZMAcPxQq1v97Rxz5A
	HS5f9HqHqdGXbdCxib2C4zMvDRQf5/bK5G6rKYNdRujVSkZF2Y9z4G0hLFX49vpBY4Z5THhojX/
	EuQ+4owhn/YFZto5Ap/C2oPYujvyVaJUH6y3+AMu9ciohluxB3rTRZZwmoRnUFNrOy1Y4Bm7eWc
	oDUpEb7Cb/DnJsO3B6t4d0/RddSEkvcJK6+3npyZKUA1UwQRO9ajj8Q70zam9lwoZjGETcKxHJx
	xfNawAY0uqM2+XnUlC1JVlCHFj2qigzJl3JILIt9dsp//uydco9hWRynSyd6hzcSWNq4FavRsRc
	gcQ4KlmOHqjEfxwuOsc2SUDb3cGHhYP1kQeUBsu8ZapVXmX6X62Ri/ZVKZTTy4Ri1d33aEYByro
	rx4974LeMaDft8qvb4o9rG7f3xyCxfO0sQnZZdLPvms1YgLlFi+MowTopWRsStC3p2
X-Google-Smtp-Source: AGHT+IE+lDqnvQHUYkAu0XYrmRvZEAyVZPzTEt8PYEgvi5cL1INBsBSk48uifZE1GEdbSXO88lLstg==
X-Received: by 2002:a05:620a:3941:b0:8ad:3bc8:3cdf with SMTP id af79cd13be357-8b29b77a876mr945204285a.29.1763045903188;
        Thu, 13 Nov 2025 06:58:23 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2aef2fa3bsm141739185a.36.2025.11.13.06.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 06:58:22 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: kernel-team@meta.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH] memory-tiers: multi-definition fixup
Date: Thu, 13 Nov 2025 09:58:15 -0500
Message-ID: <20251113145815.2926823-1-gourry@gourry.net>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112192936.2574429-9-gourry@gourry.net>
References: <20251112192936.2574429-9-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7BECA12000F
X-Stat-Signature: 9mt6tyoj4rmwoq3gey6u6zpsaxk3846c
X-Rspam-User: 
X-HE-Tag: 1763045904-974799
X-HE-Meta: U2FsdGVkX1/hZLUGfMaCEaBYxlgr8gfVY7aC5K26oJWw6ki2O2d6JPXD5V0wvyRUHEHZCSKuORjoslNDNfP0/Yg7/fAyJ5queS0OQG1tayFFYw0HQAqo/3ONl6jT23jAa7CPm3UXNQ6pfCwL7V9vtBJa4VZcmOCgkAka+Im6HasE2dN8X8xOVnHdoFH8TcvFwjdMocW6oHYJNF72wVGk/ydXYw/CsNdnwfrTnFVcCApBENHGtkV6hshUJqM3XmFfpGgT3iBXVReXS7KfhRKWTT50b06ZjljgnnBU/EYumghdkMdQ8Bh76kE/Rf2WQ4Nevzm8koiJYBZF27MX4VfFh9xrt+EbeMnpiXLeT6qdoRnKsHPbzI1cD0mEgWLq2vDEaxUZCZCe7eWjI1oSOxI4B3ftd91P8xfCOo2c0aTAuVvLs36AHfZbDwLBPD5ZxqfJL2U+ppfIb48Qcej7fbtva68nQbOBl5CLPYTrzyGq/z4PP/7eyagBy51ar7j0kMDZC+w7zw72rxcHmYjlspi9AO3qY9tVWMl6N7NtoKummtDGh3S8okuaRN3uaQptSfFFKjbOtMkJ5xrNBgKLZLkjex8dyaQxiLuc5iAHp0Zj9pWXgTX+AznSIJGzgUNO4MKqdDt0u26u4QTN0t2oJ4n+FnmpHXtC/x7MXZ1vLy72x6xJwI045sF6Q18ygc+Bztm4d21Llk+u4+yy1SQ7RCA4ufIc41CkkgyfhL6vX1ytRJbEFG9cig92u2pZXrvwdo7XmDQv7SX1n7jq6A8a4fgUgze1Q/13RFhguJryKDDraMcsD/kIvibUVtuwHe2YadeEI0B3dCZNFo5CzlYoMdgEEIamajCW2QrdDVuw5OIPJAbig9k8juE4VnCaQGUOIyM3Ed1Gksvk22K/Hf1hdqseLd9OpIeKx/xLl8EbdzbAMYuW4ebZYUCqUI+UmSmjGCvkA/HM4ypmNfEaEkNpWF7
 1Xo3GVXX
 nEjqmxHKDfIxwUe64PqLv6JogsNO7AuU+U3sWdNe0Gbujf6HpAQ2NUeHAgM0auaJI3jg4OYLduKeRvo62uo4l+rqOCAJvcbsDt+MqXRsmatwKRtluhZ7FxnXVKheNk+QyfoySZkx2RzPZj+5oZzaGfzJv2lnk6xYrnUWILiHhCGytzRZOmvLw7QhDWdYLGNvrS3hor7BJ3XVlqjC94JaGQyBn2jafi4S9kvRM1uNoRrrd7eMoQaxgwaqL/DULzbnJI4BRPVyPMqJljpqJeckzY8b5Y3v2sWcHJ8MMuZplsyju+WwB0C5VvzVydAy5xVAboI9+CmD9nEVxrtBRK5683SAk/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mt_set_node_type should be static

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/memory-tiers.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
index 59443cbfaec3..aed9dc9e0c82 100644
--- a/include/linux/memory-tiers.h
+++ b/include/linux/memory-tiers.h
@@ -194,7 +194,7 @@ static inline void mt_put_memory_types(struct list_head *memory_types)
 {
 }
 
-int mt_set_node_type(int node, int type)
+static int mt_set_node_type(int node, int type)
 {
 	return 0;
 }
-- 
2.51.1


