Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1F17C624D6
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 08:40:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C93C66B008C; Sat,  5 Sep 2026 04:40:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C43D56B0092; Sat,  5 Sep 2026 04:40:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5CA96B0095; Sat,  5 Sep 2026 04:40:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 919006B008C
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 04:40:47 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 14F3D16029B
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 08:40:47 +0000 (UTC)
X-FDA: 85179062934.10.F562D44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5C474100003
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 08:40:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J84jmlQt;
	spf=pass (imf14.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788597645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PN4g8RPgZ7jX0xRFxJnWC4F4Ar+p2OrqSGzlc5rvdWw=;
	b=SzI7F3wyCpBhB3/lCMm2M2IkO5+LGvP3i1xcQjkCkJ0OjShKbLpvAlJ745z9Y/R3x9lZja
	CeoP8ezbrKyV5giZR+DA598sIdnxAJmTBHSksogh6bC9yIDj8bHQchDZ3U7urbLMTuF8K3
	sEECZ//mXjzjCc9JgMm8AEcVl6rfGXA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788597645;
	b=pZ32Uc+zLz2OWlcsmcERF6k6lg/MfgV7B3uWFJLrJs2CmYTbyy5UDOEQ5F/bZSat4gD2Y6
	9+BOnOKQQFjgRpHtVh3vPqqgNpHCPoybrOTzZ+BC5zgbKC7vIDBfxMnis6pZADhqM2KBNo
	6DRa9UqpiPm+NgG6RmHWIwVjT8+1IVA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J84jmlQt;
	spf=pass (imf14.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4956869750eso14280435e9.2
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 01:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788597644; x=1789202444; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PN4g8RPgZ7jX0xRFxJnWC4F4Ar+p2OrqSGzlc5rvdWw=;
        b=J84jmlQtp/19zD0+D4gnUPho0syQOShCcoiDT6GOVqFAi7WVNiebt9ekwMjz5sFg50
         x8OQZFMkfzF3cBrmkR2rowbl7cNn+JNfQmO9A4fjoA4uVcbC+I1qk9qXwpEmhMT3yybs
         lnxLlGHpfseKak3GBNb7XuI0V95RCYoMnA88SGkQMGat5slmkC+x7nYEPQIGwaNbHv4S
         o7kL1FcXULii4j0IMV2tWDoddyRKSKhMWxuWei+UAXJ2i+remhN+5pGuBrrop05GiXDT
         S6dabUGtapfiykJg2prjOuyAeI+aR7z2sI5/flMzp8psCKAeFN3R4+DLadMWqvYUsrM/
         6kEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788597644; x=1789202444;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PN4g8RPgZ7jX0xRFxJnWC4F4Ar+p2OrqSGzlc5rvdWw=;
        b=V1NRnha6IPVnHjMHj5f1wo6Yx/W8gxbPJ0Q7PFfnqulMevKvRktPkj2gr/fRh6lVMR
         oYiexGFLC9qIFz8l2FPNuandETglD6WO5YkV/vUkHG+vic8Iue2Z8pVcsmMnYJnF9vL/
         ViJyleY1/aCB7y+6Gxom+EMFypUommnv0TG6SeRuKyx0YYS9NnS1pJOQKP1T+QVJRScP
         TgbrlKn4DfPoJgzLMacOHsLeMQtBEgZIFAo1O3gitHmJbCTqXKxkZ2TyS+gXnJL4kIdK
         JZglc5qvWv2RzmXR5aGVPa18cxGgnb88zUTyz4u1DTdHiLojrPZH1epvwCEPEhkcwYs3
         jMFQ==
X-Forwarded-Encrypted: i=1; AKwUvBxhtmfUG3hrkBytfO0N6n2vw2AMZ7pnyFBlQwGb+QfMALSV7Piwq0Y5HvbGXtB1HcXa0WHnaqquOg==@kvack.org
X-Gm-Message-State: AFuF++lUX0UAsQXNCU786pGM/f29iktZKusqh7r626eSGbKwZ6TCghzD
	lEA1BemL6M5Pm+fYQeEeGm6ciMVV1IExFgj3PvTB+3mpQ2jax7++ymF7
X-Gm-Gg: AYBFou3xJZ48jeh8A6aHFSn9G5B9UNeA+KAoTXMQcv0HZfTPUmeS/LwBMFpt0iDBMgj
	NkNojst+joqvRYvnCWHZqyXvlejvoaHZe2cusWFV06EJzNv1QuQS0t/nv+m9vuZMqC4RcCqyCYJ
	L/YBPXT/la6+Oc7UhQLC1qcnUUiBfWp8VoMvTJweyoEBmq+Nbn3f0ALu543fORSp5+Kbe18aXAF
	a0wTTexUaRLBMuPsLjqTECwVFuJYH5kL1wTn7PJCs4UzY2TvMM4zpWbwhlAt8zSYU2x7ZYDQ0kU
	4B57sgkdwU3jfqfDjqtUfny7SjRowwJrKMxq5MaZRR4f6cv3noHHBDrNaesIUm+XglRqa3RTSWX
	EzFiKe+OS8XdlZhXRTl+gmVqzOwN6YaCkXgnagJXdf4i5t3sr6Ez6V95qPivwPf6kh0RitHG6QZ
	KnOBs71OAF0PhV0gASdBhhPX9ALjgQVMqn5ehNiGS/q8JgCbPQTs84dPLHPHF0antpjQ9rKCjiA
	L4YZaJW34TjQ+ELlair0vt/v6jomh305F14hBc6spIE2Z2faJ9inY/pIDNjWicp+elbPj3tos39
	1Sm52mvsAbvMQW/l7o01TNCP9B10oNthi6DLfhwWwgWngVyv19RNCRsUFAot0rNkcTo=
X-Received: by 2002:a05:600c:8b66:b0:49c:fa20:cbfe with SMTP id 5b1f17b1804b1-49cfa20cd6emr90941955e9.21.1788597643770;
        Sat, 05 Sep 2026 01:40:43 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a4eb-3001-c06d-af27-9fa2-ea53.310.pool.telefonica.de. [2a02:3100:a4eb:3001:c06d:af27:9fa2:ea53])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee6158e9sm215544755e9.12.2026.09.05.01.40.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 05 Sep 2026 01:40:43 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-mm@kvack.org,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH] docs/mm: ksm: Use the renamed ksm structure names
Date: Sat,  5 Sep 2026 10:40:34 +0200
Message-Id: <20260905084034.39521-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5C474100003
X-Stat-Signature: hedtjkzetqpqh9grafjsmexyr5gf3bf6
X-HE-Tag: 1788597645-282812
X-HE-Meta: U2FsdGVkX1/tvloqNvBmkB/PQVhNqldvq79Og8ojy45xgOHIsmaLu9N/7s08NZV6SchIOqGKxvBfynsbpz2Txgmh8bnFhBXD47pTLcV5K3+sB7sHKHkCzNBGjYp9vVHcjQgXG9q+RWaJY6ALnnrEuUyPvAHKlMIqZgIBtj5p5/GoupTiKjxfZ4RSQWBIRX1GtXk7Nt/s+UULPHPgYn5h/FW/bm3JP8RKz1RiGjuWkQWFWXEWdhcqrp8cWkpMxx5kSH6z3jM5LGbX0nUQ5wNNwUYxAB2jT6lC0zZsFGmGq+4bYaZHW2hx0iZ+xemCI/tvYaD0KNARu/Bwln9oaUJ/hfh5BJwo0T1o6/cwC8H8MXxpXQuhRGeP3ag05cMIFMz6f+PpiDWWLPfVfg5yMD+VNI9NblgMkQ4NaZW4LQ147dwvSU3BJ4PHCxJkSfcSxF3UcEDdygTz04Y5HV91kb5RRLTy+PGMwJx3QRy/lqEFIZOvQ2DuJQQSskRUS0ZVtiGxzGGV++ipZgjOYaOsUbnM10yLECn8RlkwgYonM5kFefLDGvJAxFelI+d0gkrrTBMWtucE63MGcFLJGwJrTwm2iYWRRcXgn/BhJysZbJgXl2P8hz9eL69y+c9PtQgyJpFrfkqvNIp/IgysKzkERgF/XQ046loCuNScZcPOBpL96M5EFHL6Teke7lia+Wx1oBxpfk+DkovBMJ7AOkkQToCpRAEifJQ8aWFsTZN0bEb80P4MmbQiCiW4t/oBC3a/wl8fqxppmXXYds6+pEproZIyKVFjis10zh69e60dMpvmTJ6/62ycXNmZsNDPOBZ7zfWUBC9yPn33lYWpUVSfJwOhqKLXaS5cK94UWHhirsy2yvYyRgoELm1h4YSRBbysluzHrv9J4pykpemPT7zTX5S584SXyjMhLwA5jcGIvgLcooYV8QwHFSaQ66Lb6Voc21nC+B5/4gyElTNsCoXP+ID
 5JZpk5ff
 gyze0Us2Opm5sOWoaQHgLNrZ+3PkwRwOlNkNCR/LSTxYel7rw0iuL6oa9Ly5oD/l9Xb3Ha5661haS6478dJYetCK/I6mK5JIhRdibgi50CR2nYMBg+ghoju8Q7bVdfLdM7BadmLdXBxSAZljUijc5hKuHgUhLunW3ehWJqXNt1hvURSI08N8c6gZqqwzI6GNr06RLGHyP/uEv0cgQ0pzC6HEbnnOTqxoDqv7h7b2XGkMch9wZ6RnyUtjKBOtvJr5Rswv44kNLuXlQ2YJL0ewbSS2sz/CDnWlo6UnpV7WLV0ev73zVkWiA0yYlgDwWrpzxWis7l+14vTWFG0G/WRV3PZO1/uD/XU88EDFJOFbqiQOs60n6xEHPujNjUTy61PHG9jPpdBoiapX9wb0+RMkbIoKVslpR36fyNnsk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The Reference section of ksm.rst asks mm/ksm.c for mm_slot, stable_node
and rmap_item. Commit 21fbd59136e0 ("ksm: add the ksm prefix to the
names of the ksm private structures") renamed them to ksm_mm_slot,
ksm_stable_node and ksm_rmap_item. Since then only ksm_scan is rendered
and the three structures are missing from the generated documentation.

Use the current names.

Fixes: 21fbd59136e0 ("ksm: add the ksm prefix to the names of the ksm private structures")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 Documentation/mm/ksm.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/mm/ksm.rst b/Documentation/mm/ksm.rst
index 2b4f72f1f953..5a80573162de 100644
--- a/Documentation/mm/ksm.rst
+++ b/Documentation/mm/ksm.rst
@@ -78,7 +78,7 @@ The frequency of such scans is defined by
 Reference
 ---------
 .. kernel-doc:: mm/ksm.c
-   :functions: mm_slot ksm_scan stable_node rmap_item
+   :functions: ksm_mm_slot ksm_scan ksm_stable_node ksm_rmap_item
 
 --
 Izik Eidus,
-- 
2.53.0


