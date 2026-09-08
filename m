Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2807C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 16:57:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F32CF6B008C; Tue,  8 Sep 2026 12:57:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBC7C6B0092; Tue,  8 Sep 2026 12:57:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D869B6B0093; Tue,  8 Sep 2026 12:57:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B25206B008C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:57:45 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 405A4A5153
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:57:45 +0000 (UTC)
X-FDA: 85191201690.08.278498C
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8107B1C0003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:57:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QP6bPYw5;
	spf=pass (imf18.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788886663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Kalg6jePaskKvwy+jYIT7hhTBRs7E2WNyizz32+45+4=;
	b=ax4PYUlRKDtYthteq6NWBbmivHZzj8lNPHwpW1lpdWS+vtDp8TrmSOGQ4Krvt58kk62+lS
	92QVnG6tXUQv0F7uVweoDUkg9mF0CvKntxAYwAnd0VJLaWXu3jGAgobsfSOUJe61SEVNxk
	8tT+Zs6/8604W8DOdjf3NjHzJ3iTPAs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QP6bPYw5;
	spf=pass (imf18.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788886663;
	b=Kted8x52m8Kg0Xu5J43vZXvyvhiDR/Su40apIElsWwslb9VUJNb1enfEkEtCbfFXUtu1Zb
	3pgFcseF0spI9mjjRnMjYiwJ/Dypuz4/3URYOHWv5c/WEjDd2d40H136Y6X72YpdRBxGPV
	DqULzQ3aBh+xcswp4x0geoDhSVppIVk=
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-859e0bc7dd9so136494b3a.3
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 09:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788886662; x=1789491462; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Kalg6jePaskKvwy+jYIT7hhTBRs7E2WNyizz32+45+4=;
        b=QP6bPYw5X9cKv6plJY+qfVzvHWISjFezmsQaPUDfqt8Zav6BtlJY57N2Ddr2Y5I4ig
         aSvEoH9klGYrBpHzY5ylnXCvYR39FICov2eXRi9+kUN6sJ3qTyfSFo/IUA+xfUs0UNR+
         b2B3aYr/5Pyl1O4Kbmji4W0d1tn6anWwJyWefHL1yp1svQUjwknUkr1HHux5Wx8pxXj2
         Ht/QtVfbyWv/snDQISxV74csF1h/z4GPgYPWxpn9JjVak6lapyPWvJpIbF7CWyaC2Mrj
         1hDzIdwVyhpErXkgWXK2lTGvutDltFsp5QGEE9WAhf1xMy3J6Pe3yNX26DNyL79xNGZ4
         6YLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788886662; x=1789491462;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Kalg6jePaskKvwy+jYIT7hhTBRs7E2WNyizz32+45+4=;
        b=GWAj0lSUprmnYF7voukOoa6jg99rlUJvXTo7GIv+vmYlmOHWfdgzbdydN79do/uBL3
         UYe2vV8gK5I0IWXrNf6N9KpLts1UP1zBzzX9s4AFE/FesxguoPA4xZpZOrOu/ARx1E0G
         4B0qFThpVs6+Ro095b1ocgDYVKtcE8Wh884fZaelcfkZ5BhRzBIiltqNIkPIZCWwkRMh
         iq/A+6yIP1IbTGfbPzck0iio9zFnUwc/NdiNwT2dJQ8iRQPhukVV27uc92YzIuWzHoeV
         DejZlYxRpBl/ixQ1myO5wir9FYRxtwWedS3S3zPNWlOHaIHmeBRato8ibJ//oCwpRaWz
         3OyQ==
X-Gm-Message-State: AFuF++kBXxiDTSWtcNeFzTiLbD+T8wijM8eNOJPKZiuk5fCamBS7oIb9
	+bupWek/qbLn2O8eAerakcYSB1f6TkndhtpNm7i5Vyy39Ri6uyle83xjcmcwj+0v
X-Gm-Gg: AYBFou2Mniw6LWXw+DYwM2Po989QCfemXhvbaP8HxdRtjlwggZI8TlB5g6jFlbl2XAZ
	fXvLg4+xf+v6hYnMdEMfHbLh+u1EB8PzCiwPYhTHBVGQ7uESrITkMyfMZe+2Fy3cVTQTlQsfhFh
	Jj44zmS2mjn1EM9Axl875Atru6BrWymER/C8/5AryhrXb3QFIU6DhMH5pubfpEUZuKyHhkuyS04
	Zg3+19PyAZ3N2nNhDUs5/YlXE5O+9a3a8m3jnFYfD4T8cHDv1apqbBJo6Es6ENAnO0NkiWkPTTP
	E2yNZCXzFlXdrfcQTUH+8zlYADVB5A7jkBUDVjAvA/EacmmPQF5mrVNOhvxvQDGJM1rEzUNtCQF
	N42aUD1Y/U4Za/uME4b5CyAwOkqRL2RpYUppnqkEEVgcG9masVJWN+CMu1C2k+hzqnOj2BPLbla
	DFA1sVUsFtQskcE6qWtd+M1migqQnTYAfvSLiq4aTYnnROmgg05qL1XHk=
X-Received: by 2002:a05:6a00:330a:b0:855:a211:6679 with SMTP id d2e1a72fcca58-8684037d0ccmr834961b3a.5.1788886662189;
        Tue, 08 Sep 2026 09:57:42 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-864782f0be1sm3243704b3a.41.2026.09.08.09.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 09:57:41 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [PATCH] memblock: use for_each_zone() in reset_all_zones_managed_pages()
Date: Wed,  9 Sep 2026 01:57:32 +0900
Message-ID: <20260908165733.1703766-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8107B1C0003
X-Stat-Signature: usbj4qmn93nuwnm48gutok3xfana9ihc
X-Rspam-User: 
X-HE-Tag: 1788886663-196249
X-HE-Meta: U2FsdGVkX18qMtBAefgw6Sw2m0dILhtcCJW3rYv+KxIRiaqLRjz0eqzVgGDs0yUYEi1KD73Lyh18j2A0vCdrifCpfYcHYv1aEQJELmw7RNd2Mx+peZP3piVrth9pAGo+7aOifr8sUFhuwd11L7ojr3dTgaRmVwA+pklsfYjSgXBI+/Gp+xrzmI6HJLVBih3hUmCfx6Z+dbPCiTD8LlJdL0jVkZr0JyTWYp+tqdgtN352MQNXm0Cw37PLGwG5hX1LOhT1bdHlGbQxjfyyF5oaTm2RMXgiR3s0FbL549hbh7ugonNsGlB+hZEHiuZoFQHJe1pycZ/FZzDxB3HdCEcFJ+TjSyjYVRGmuA6f3yhqZeks4zdlV2CEU5Z0fOkyfJPZOuv4PuVXYzQVakSnNjLeR9WcNl8/t/ohxeBwSGFH3/77+r4EjV1Euq1xKfVS4k5OVYfQgVj9XwMvNXibEp3IffgPWxGnyPh3gpnnQYbjEBlfc7xjOGiu04ynwxixVae5DPRnIrwSEOGb1TrRa4mLZf3kz0cab1rqdu8/Klonaw+5kTjLHnAUOwa/A+qEODpzO31Ko9LVr5ywibrIir8mLC10PzAqg0Zq4DXHUlSwmfHvzsy1lMZHG0I6nXwgN2TOupYpDwq+VZirAbDWutx6bt777q8Semq3PyBssgZA+vTxPi8mKCasoUoZWcy498Qf9wzC/2Hv1L3L+6ap0Dd1JOgUS526s4tVhfQGuVLKkiWsunUI/2H50KlgXfBodRe8D3i+l/GJAT9hEP5Gi75aDmOipSKCprABKf9OTPTfKHFmPCzEWBsiGfwTKNwePT5BPTt8rUJuyKK0DyBJ0SfU/Kj5ollyaHg63dCeRdC+3cd9QAQkHSoD+efeL2fMwJMDogMGU2o/YQ342RTLP06Myr3AryaD5vbooAQOtFr7yhUfQHPz4MOrCYfSJhoG6JXl/0v23IR6Nh/8wi8TZuk
 6BvQ+crX
 53EDvfj3hPDOKtdUT9WXXqhqy8ctRAy4cOLBBSGUQJL62oyuiEqOmi7e9d0R0Bfs0qrQZZgIUXxtk2raqeVo8fNiMpj3dEjYsnUQrinkhug/8ziZ68khN1RFUxc1DOaq3GzZpElYBKbjRGxpZpihPLnB5lSYb1ocyCDoAjr2WQ9aHv37t0lpIG+4ONPsi4bzi4iYCN+mva2Ab5mMtiwoel/1Gh41KOXVZ5V0zDqb/8wvHjfoD2RSLl2I+VKDf3wcFuwnzesIyIcCeGdfwBvS7I/HgtJGQ1dZfvSG/z0Fqtt02amAxH1VxP+G0UuWRzxsDJ+1U4XJmXbbVU4EfO47V4z0zw/F4fpBkG2WbbNZROBwSXKNywhMCzDrwsz3F0sbbOeVP1eCSQdFcPeg6FDO/TisW8NbDZIXMuHte8nvWFqvAS0rjruebyqmYAgsT6PXKJENGw87JPUNahto=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

reset_all_zones_managed_pages() iterates over the zones of every
online node with a nested loop. for_each_zone() iterates over the same
zones in the same order.

So use for_each_zone() instead and remove reset_node_managed_pages().

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/memblock.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 4302fb4ab85c..ed6937be8d9f 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2465,22 +2465,14 @@ static unsigned long __init free_low_memory_core_early(void)
 	return count;
 }
 
-static void __init reset_node_managed_pages(pg_data_t *pgdat)
+static void __init reset_all_zones_managed_pages(void)
 {
 	struct zone *z;
 
-	for (z = pgdat->node_zones; z < pgdat->node_zones + MAX_NR_ZONES; z++)
+	for_each_zone(z)
 		atomic_long_set(&z->managed_pages, 0);
 }
 
-static void __init reset_all_zones_managed_pages(void)
-{
-	struct pglist_data *pgdat;
-
-	for_each_online_pgdat(pgdat)
-		reset_node_managed_pages(pgdat);
-}
-
 /**
  * memblock_free_all - release free pages to the buddy allocator
  */

base-commit: dbffc67777cd752ef3f77818109e1d2ef13e2949
-- 
2.43.0


