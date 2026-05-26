Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F324ECD5BD1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 09:12:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C62B6B0096; Tue, 26 May 2026 05:12:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 350256B0098; Tue, 26 May 2026 05:12:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23F836B0099; Tue, 26 May 2026 05:12:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0EE726B0096
	for <linux-mm@kvack.org>; Tue, 26 May 2026 05:12:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BC542402FA
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:12:58 +0000 (UTC)
X-FDA: 84809006436.19.FEFDA93
Received: from out162-62-58-216.mail.qq.com (out162-62-58-216.mail.qq.com [162.62.58.216])
	by imf08.hostedemail.com (Postfix) with ESMTP id 29A4616000C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:12:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=ENKysW2J;
	spf=pass (imf08.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.58.216 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779786776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kYC95vynjnM4IGsQJlQlT8YNYAk5IDR0cnGcY3STF3s=;
	b=vdbNzdixkcg3mvUlmQOabdNdbWMGjv7vWfu2cYwsQt8ZZVQULMEDtPAG4RKBQBv3noI+e4
	QNs2yA/bItz9TK/SnOkBCMlToaP1yWDwKHlzGeVK7sfZfVaPv0deAZdL4ZRhXO5xSBQLck
	Q6zGe5SGR8/5q3aHPaLpuRpU4S6Ain4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=ENKysW2J;
	spf=pass (imf08.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.58.216 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779786776; a=rsa-sha256;
	cv=none;
	b=TdC3QPb5ajR7NE6IfqXnFn3lI0z6n4x4MzNm11YSQ9o5RDwJRvcIVkshzhpINCXKE8tm6P
	HjrNaKDsGgGzP33C1lZhCVedYclVF7fJk5HmWWeBaE3jJ+00nIaw28+h1I9EPYZaZY1NWl
	YJS0d63VvJKo3wgs2+SDR1ZVrrcgHj4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1779786771; bh=kYC95vynjnM4IGsQJlQlT8YNYAk5IDR0cnGcY3STF3s=;
	h=From:To:Cc:Subject:Date;
	b=ENKysW2JJGd3Rf1Xm+yAVhKd/PUkuBsW6onSUHsJ2tWDeosArl0mBLF3qyHwvDRZW
	 NW3rmOQkwEgnThKpzGZ3cv3bX9lwJ7DteusJo+35t9JnPakOhKawFxqa9PQyHc1qqs
	 bp3944eNA8wDJ8dnDUX0ms5bwk3NMvFUuk9X3t2U=
Received: from node68.. ([166.111.236.25])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id 330274DE; Tue, 26 May 2026 17:12:48 +0800
X-QQ-mid: xmsmtpt1779786768tgr36cims
Message-ID: <tencent_368AF1F3821E46232637BE16D65C45CF3308@qq.com>
X-QQ-XMAILINFO: OVFdYp27KdlJK1iwt3u4zCdnQFp6L5DnIot0YJZzUnTd/f6c9+Yddu0C2sFSdo
	 6dpOMm21GqnRqJETGIlqV0gp5Nhd4Q/UwsSdI999UIy1tDuE3ph0xz9CZmADx+3tjwEC1EU9Cot5
	 IC11RZ2dOlkOJuygoxrmJAiN97Y0RhXkuI2lZ4N7f9vWJPGC4poNFAi6+F/HHEg716pjyq7GOKRR
	 dxF1g89yDh70CAgS9kz7BYa9jRmnQOxNYegvsbowCH6rS1nf5oS2dkTq1oHFM0mCgrMeNGHSTPcS
	 Pq5IRGGpU0022E4eSf5Y3/9S0rfFu9oEYYSIoGrNgnJ5U4QqrbsJljRTEeO6gWeAG1EiwEFJVSRJ
	 uUhe/WRoN4YzEahsoJuornUYVkazlITffIMOh/tqvJ0kqFI5MQpWNw2Xw4JTmkdMYe+Ewu8dWC9T
	 O0L9jtT6BcO5I/HZuwqAW47/B4ixtmiN6Wfc6zbNBLXIHmkTOzhiMZr+KwtYm2t598SROuvNjQoX
	 jszXjpWRmATseHZnMwlGmZf3Cw+af9ch3aZ7/VgJErAC8NK2dQiYJpXLZ8WKC4Q0NjykBceMUkBp
	 nRf0bkMp5OXXRGETlttz06twGG+nZTzW/vXygDdaclFN528WDmkU9wd6QYYOD1mj1STzme9swin9
	 6glTzOFYNqjEKBlc3+nNOici5KXP2NxL+6DNrI/6VW2BROyM1pbJlUpugc8MIPXN0tQlf0JUqYQU
	 mqwGwfovKYB1pwIdx9RpkPvb3cHGiM6Cj8mS7FH6yux8oY8blxTe/5gclxdRhQEbNvQey8JqaBZS
	 JIxbfh4OT9RAa3Gxb7ePvs6yQbr0/Mz9+DRS5zNit4Tq1/XXBOFJKwytA3gexZhn/WsHePwolitu
	 EQ1KI80LbsflcwJGHnc43UrNAXQAN/0McHM2F/SCo+X/mR4Qc7ZdKjUR1qY2WDW3ryI3+d3mbgqm
	 wUSfCaPZse4oPD4d89Fl1X0n2z5EZyv3xYjtUb8faP1223Y0MqptYoGoJKd1z1LyhrMNscMDdnH3
	 bIFnZWZ/uwuh36L/ID
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
From: fujunjie <fujunjie1@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/page_alloc: fix deferred compaction accounting
Date: Tue, 26 May 2026 09:12:48 +0000
X-OQ-MSGID: <20260526091248.251711-1-fujunjie1@qq.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 29A4616000C
X-Stat-Signature: j6gck7wis5ywuzbbutqr36e3xq5whbm5
X-HE-Tag: 1779786775-732846
X-HE-Meta: U2FsdGVkX18A22kwoAvZ2UwL4pLI+UxVllWsDlkqP+PwPGKI5KTL/+dGPTX/Y0tMkPI3MDdYnZQDZJI+dYXhA8HfOo+HUNP9762SxOSKmW8A1vB+7PKr8nf+ifiYAt3lTP7wX1Viri+PxTE5prOxCfDPfrxMNxSMKxA0jBmp8KO43tLRqKYDIEwTXCpQ5sG1mEqIWQGSa6BfMsmeC0OkFlJljoHbX32J07dx8wo+Oyjy117K0Mb245kQZFlCiDu7Ru60EJvWZDzGzT6fmz3HjvTZALiN1pHp0n4NpToPm4Pxc2IA+bd3Az60szoABaTXv+zJ8BlUgsF+pMZSdB+4BurkkwMvTvXzPjFe/MJ9Y21Rxf+WEvqAM/wE6wbV9yY0jFjKHm3an8Lzt28wE94bag2xFW9SqU4/JORjvogX4/oM7w6LHPn/shKOQS/qOLDj1R53Bdwyo+/FLGzzKWXQ50bFOb3WtO9MvE0xYT87wtAHmkF3OopAO92JqRZ+4EEItyC3l3Wqrio2/4ryhvS9fQCdKhRml7HCToY1IjafSHbVbGYuJflANZ6lZTzmuCYhwUrvCV8uh0I8kNKzQrTcY20X4C/11AZTDcM+6PttNeNMbrpKn8dAPCXRYByh2uqLuSswfALNHUCppMhGGoQLjGmKsvRyQCD9+url9rXRjeOYETSsrT0ZPVOqvVUA3A0CxfCcprTOKT9QKpeOKGWUq3InT/XTbXkjQL384kMvjTnm37to1BSyvYZAgxhl1nECZeFXZK0TMuzJeT8PqstuqW2NUh2K24dTRfGGgIwv0yOQ0JGNo4xFp91N56FZ0txa3Jm/tlLvt8L0yLy0otCbC3dllmVjcyX46bidMuBXJ5kynBqUt1DNhSmZMiTgs16aulmBtgRfOnnWuIyGQI8+ITL/97MOndVoxh0p2Aj9fpXJawL3ARqPRwVbRH3kjGTqlpduTDJWTBSyQxfmOiM
 1QtQo/Wj
 h2kgrenQwbJczqgtSVT4amxCxZjiOFDmeqVZ660sZoU/W4qSbeHm5ge+4XyJc4sRrHUr2osuT4ZTG4Tn9HqUVPqPpTK0PyKUHKulIHBRdcfWqfHpxTJxHxLFhsbr9OEcxodkB3wSS2TGi4268UxiuvkXhE1Gbeyl0H1atZ5sifJsrrAIgTnNwt3DvgkfHgeo+RDMfPefOiE/+SiQxz/0LoPwt+TM7i9ADBY+OdndWuKDJS4VIM+fLZmDi1MM2LyOPJ+iUPDbKlUDhZQ5WzB9UmyvleHtIY8/srGf36fPJPenVyaiBAX4EPoUtxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

COMPACT_DEFERRED means compaction did not start because past failures
caused the zone to be deferred. try_to_compact_pages() returns the
maximum result seen while walking the zonelist, so a final
COMPACT_DEFERRED result means no later zone reported that compaction
actually ran.

__alloc_pages_direct_compact() skips COMPACTSTALL and COMPACTFAIL
accounting when try_to_compact_pages() returns COMPACT_SKIPPED, but not
when it returns COMPACT_DEFERRED. A deferred-only direct compaction
attempt can therefore look like a stall, and then a failure if the
allocation still cannot be satisfied.

Treat COMPACT_DEFERRED like COMPACT_SKIPPED in this accounting path. If
a later zone runs compaction and returns a result above COMPACT_DEFERRED,
or compact_zone_order() reports COMPACT_SUCCESS for a captured page, the
final result is not COMPACT_DEFERRED and the existing accounting still
runs.

Signed-off-by: fujunjie <fujunjie1@qq.com>
---
 mm/page_alloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 23c7298d3be2..ddeb79fa12db 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4161,7 +4161,8 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	psi_memstall_leave(&pflags);
 	delayacct_compact_end();
 
-	if (*compact_result == COMPACT_SKIPPED)
+	if (*compact_result == COMPACT_SKIPPED ||
+	    *compact_result == COMPACT_DEFERRED)
 		return NULL;
 	/*
 	 * At least in one zone compaction wasn't deferred or skipped, so let's

base-commit: e8c2f9fdadee7cbc75134dc463c1e0d856d6e5c7
-- 
2.34.1


