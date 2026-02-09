Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12438E7E0D5
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 19:37:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 794FB6B00A3; Mon,  9 Feb 2026 14:37:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 776436B00A4; Mon,  9 Feb 2026 14:37:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 675746B00A6; Mon,  9 Feb 2026 14:37:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 57B606B00A3
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:37:14 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F3D61C15AD
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 19:37:13 +0000 (UTC)
X-FDA: 84425926746.05.E17542E
Received: from mail-qv1-f98.google.com (mail-qv1-f98.google.com [209.85.219.98])
	by imf15.hostedemail.com (Postfix) with ESMTP id 32245A0003
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 19:37:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=windowsforum.com header.s=google header.b=j2eQSFZr;
	spf=pass (imf15.hostedemail.com: domain of admin@windowsforum.com designates 209.85.219.98 as permitted sender) smtp.mailfrom=admin@windowsforum.com;
	dmarc=pass (policy=reject) header.from=windowsforum.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770665832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0sq/5z8N2ft1xcm3cuopTwCMdowyLeWdG7JWXwBlvJo=;
	b=ilrOoBnCDiAxhbFoq0ySYZKOBsLuY7x5QMRJdKWYvMZ8gtx/c1QAP3gTEXiSyqu7fcI+Ge
	6sRUyTf9XvRErU+GqUOprV7febc3PYu7070SL+F9lwa1uJmkpjOI202xff578H8MhdhTBJ
	BGbcUm2lEowQ+4x7LNOe2dgodmhJYdo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=windowsforum.com header.s=google header.b=j2eQSFZr;
	spf=pass (imf15.hostedemail.com: domain of admin@windowsforum.com designates 209.85.219.98 as permitted sender) smtp.mailfrom=admin@windowsforum.com;
	dmarc=pass (policy=reject) header.from=windowsforum.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770665832; a=rsa-sha256;
	cv=none;
	b=Fl86zTNDPh5apdEHTXwND4UFjvnq05QKQTkRNQVpptFvu4AznhuUrJKkhMTHgQ0yJSdyM0
	OSXlvfCpSfnWvpS3JnnlNnIhnCNKq7yNhzwlyqhAsQXhj/qnHMxID2PMrm02dYFfO9D+AY
	OdlB7ukQclXs4jFzXDBxTCIZtuFexZQ=
Received: by mail-qv1-f98.google.com with SMTP id 6a1803df08f44-89545bd3324so40033706d6.1
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 11:37:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=windowsforum.com; s=google; t=1770665831; x=1771270631; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0sq/5z8N2ft1xcm3cuopTwCMdowyLeWdG7JWXwBlvJo=;
        b=j2eQSFZrcZfuA5Js1XA5grGyzg1HW4mmqOs5ScO3q5DfYvIPzQ3RWDH6E/wItqomJn
         aaDKSPZmr49kaYPfx1ql8VhgkIxJ+LrJXoqS/5Qs1Uq9TaW3pY2yJWmmSUR4IA1PHYx8
         0Nb5RrZ0ZwUDNn9IUDCwbtwIAgFMqdiFq2p04=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770665831; x=1771270631;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0sq/5z8N2ft1xcm3cuopTwCMdowyLeWdG7JWXwBlvJo=;
        b=skrkWP6qltDR5v30ymh3WKfgau8BV+C6sfOHtUFtgbuZ2xJu3YevDOi5j5S+RJ7kG+
         zI4Ok+5Jzp3pIpAS537qEWzVRypA3G3u2yyE6ClH8lm1zkBfvS2T3mBnFWOLFZE4XAO1
         UTgZ+OFdmumhKziTAIBiA7Ffvxo3pCsZ/CxVTfTNbmZ/p2uFo5I894ilApYXyuVOMIgS
         w7nGH9/GYeVDQlI0EO8GDjdVdmzsWJFFvfHzH6qEmSPi65/cMbPSn2zQN6JByUfToPox
         h+WgDrPdP9XCSAZsucG03EnXf5j4lFZrLZIQ6LHJsgqGqAd1A4mo6FUF/lmZVBZBs/xJ
         EjCA==
X-Gm-Message-State: AOJu0YwjDyFGbwGBxgkj95fPSVkROmxMMEj49dzNQ5eiga023D1oCHxA
	tnXruvfm6PCz1FnNkhrkbCnpi/QwZzFHSx8vBgJxSozberIUzuIDTUPlBJpM6O15uWXK0InPbf9
	aiQsPCWLCdYuQXTO2cjFMR4pCw8sBQofAIxz4
X-Gm-Gg: AZuq6aKRbtHMNzHoeu8wl4OXKy2jLAxINCnPtp7RW6QUp2nFbyEgkufmQrvJV04bF5e
	jdaiYslu5dr0ZrIP3W0ap2vnTR9VVMMCIoY7CRLJOnPH17nCwayjVCdkHiFF43jAg1EnI1zj9ZP
	TZyKEOxt70ncewf7CIjdr3yTh4dKoqbkE3vjq6ojlCtvECpZJEHNlBN/rFwsJ4hhmUFPWFZlmEr
	A8Y9GcSftntEmLsSzbIwdfYZy9dibTfTZFlPm3jJWD325xZlPAPDcm6vso5tGUnjQZXAZexrAHz
	rjUHS6NJh2RDutu/Ohn4r5c8YAmmOV/miCHuI1VxGM+vWWat+48ZXo+jLOPd1FCHYQ7C4pSNQ2g
	n/wtXt2VX3WSelubIE32vEOtvm11TqnM/1PAlILFpX6Celw7W69fYvtANCuKH
X-Received: by 2002:a05:6214:487:b0:894:7051:2681 with SMTP id 6a1803df08f44-8953cb8126emr197913306d6.51.1770665831084;
        Mon, 09 Feb 2026 11:37:11 -0800 (PST)
Received: from windowsforum.com (116.9.196.104.bc.googleusercontent.com. [104.196.9.116])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-8953bf38308sm18101146d6.8.2026.02.09.11.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 11:37:11 -0800 (PST)
X-Relaying-Domain: windowsforum.com
Received: by windowsforum.com (Postfix, from userid 0)
	id E30A82A1C20; Mon, 09 Feb 2026 19:37:08 +0000 (UTC)
From: Michael Fara <admin@windowsforum.com>
To: senozhatsky@chromium.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	mjfara@gmail.com
Subject: [PATCH] mm/zsmalloc: fix NULL pointer dereference in get_next_zpdesc
Date: Mon,  9 Feb 2026 19:37:08 +0000
Message-ID: <20260209193708.69454-1-mjfara@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pjjnod15z3er4hj9rk3cw1tro47xkt17
X-Rspamd-Queue-Id: 32245A0003
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770665832-749852
X-HE-Meta: U2FsdGVkX1+HNhf7+vxwopuT6rItpwK7Jk+s7uEKCO3TGbjeyWNPRsZv1aPcyGBOLVz9irV6hvEYdIPUZeev1cHAHXbc/On9wXbxcTabTCrUm6L2f2jy6WQUWQiPU05LrLBK/sSCsafWW8yoUESAz5zZ3eBYdIZCirq1LXEUxj109zCZXmtFaaVWA/SDZqBlvYOa2zToPo00lA93D95e6D5Bvk7D9ebiwrJNATiblNyoJMDEoW6zlH1EMsO+iZ05kk9x7LyggAxBQCWhkdCLv3HUUGVQUtX+A66XzNnzeHKk65Dc5eOL/1b+/WrZ5UALgyfWIPRo9i4a/mAEePS55as5DZqNSEcYxZsuuczAJXaxM8tlD3PSIbiTO5eoVG6q0iSCP+JgGzAJPb0V1RY36u4B9REj8wLfbEqaJnDIwH6wmHf1hA46ScHq/kqKqgI9D1UrikxEByORvrQTkhgxOy9pOCM3XUC19Va4lXxg0oNwotrPcYFUrtNuA1tDGdSA1SNEu08EwcHnTOptwmVaqifzoFVHZxqcNHror5uDHxYER4guYrM3lxCMEABOXFIHaG8IiWuBBH0/D4jtba6n2pZtXEf/9CTuVT0cVH9/Tvh6ys3FkY4WoCQDmDl7HQZfEFBV6lS6nqVkwoWdOos0iK17ICalAXvh3qOdfjDiTHbgyd1q412cC7Or2ZiKhsC/J40ZJExAz0Jt/LzIiosP3vem6YjbyvOLq1U8Rvs4fbQ22zsLfqjpLL9DP22JdzuhQFzdQNmavodMt4gXtHhjr3n0AGTrD70fVEBh/7W6/upud/BWFo7ucSyVT7vTs7uVaY9xDS9Sc7yD32RJu4P4NPmfhX+Ro4DRr16p6I0F3lEQap4aJOYhvEXzGcIOcrF5c0CWjiEKf6dkH1Nng3oupvvivDcZN5cXW/QqB0Uz6u1jLV6sV8STNh3aIcYrcSt4R9tNdTBxPB/lU3ticKG
 Oy7eSiSr
 e2WcC58mva7FkFg3XbvVK+0uxnJJ1c06rODJweuRRl94gn2URM9xCjNFGM5EpgztWCasIVJR73iz5CqbGsJkZ3UuCs4M7+oa9fESrQ4q+cgPv6NOQfeO/7wSoSBViNx63XDNxh3uyq/IDsjn8XcEZh0P0wwUm0vopJZ97FvPUk7SEGXXUVKLY32WkkSg2+jwtAZWLKVzSZ+k9DRjt4sthEDNaLNUI2S5Rme9wS/cjFDoItPIXvqAIwijv7a5bE1/lLuHb3vFZCtGb1hVg8t6KwDa48cjDhURxEPWz9wNDqbLVD7/vYuSygL3Q73gfJyp234VASnZL0wjMCb4xF9aZAMaAyfAv6stw+pskc3IRAaHvhXzOH23mdXpLme3d3pWC2tpL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

get_next_zpdesc() calls get_zspage() which unconditionally dereferences
zpdesc->zspage without a NULL check. This causes a kernel oops when
zpdesc->zspage has been set to NULL by reset_zpdesc() during a race
between zspage destruction and page compaction/migration.

The race window is documented in a TODO comment in zs_page_migrate():

    "nothing prevents a zspage from getting destroyed while it is
    isolated for migration, as the page lock is temporarily dropped
    after zs_page_isolate() succeeded"

The sequence is:
  1. Compaction calls zs_page_isolate() on a zpdesc, then drops its
     page lock.
  2. Concurrently, async_free_zspage() or free_zspage() destroys the
     zspage, calling reset_zpdesc() which sets zpdesc->zspage = NULL.
  3. A subsequent zs_free() path calls trylock_zspage(), which iterates
     zpdescs via get_next_zpdesc(). get_zspage() dereferences the now-
     NULL backpointer, causing:

       BUG: kernel NULL pointer dereference, address: 0000000000000000
       RIP: 0010:free_zspage+0x26/0x100
       Call Trace:
        zs_free+0xf4/0x110
        zswap_entry_free+0x7e/0x160

The migration side already has a NULL guard (zs_page_migrate line 1675:
"if (!zpdesc->zspage) return 0;"), but get_next_zpdesc() lacks the same
protection.

Fix this by reading zpdesc->zspage directly in get_next_zpdesc()
instead of going through get_zspage(), and returning NULL when the
backpointer is NULL. This stops iteration safely — the caller treats
it as the end of the page chain.

Signed-off-by: Michael Fara <mjfara@gmail.com>
---
 mm/zsmalloc.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -735,7 +735,19 @@ static struct zspage *get_zspage(struct zpdesc *zpdesc)

 static struct zpdesc *get_next_zpdesc(struct zpdesc *zpdesc)
 {
-	struct zspage *zspage = get_zspage(zpdesc);
+	struct zspage *zspage = zpdesc->zspage;
+
+	/*
+	 * If the backpointer is NULL, this zpdesc was already freed via
+	 * reset_zpdesc() by a racing async_free_zspage() while isolated
+	 * for compaction. See the TODO comment in zs_page_migrate().
+	 */
+	if (unlikely(!zspage)) {
+		WARN_ON_ONCE(1);
+		return NULL;
+	}
+
+	BUG_ON(zspage->magic != ZSPAGE_MAGIC);

 	if (unlikely(ZsHugePage(zspage)))
 		return NULL;
--
2.39.0

