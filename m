Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7944D5B177
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 14:54:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AF8A6B0007; Mon, 15 Dec 2025 09:54:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 487106B0008; Mon, 15 Dec 2025 09:54:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C4676B000A; Mon, 15 Dec 2025 09:54:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2D6B76B0007
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 09:54:30 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DDA05C0281
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 14:54:29 +0000 (UTC)
X-FDA: 84222001458.07.89C75A9
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1826640013
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 14:54:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jgFrLIrj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of kdipendra88@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=kdipendra88@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765810468; a=rsa-sha256;
	cv=none;
	b=U5DhTCjNxLyNcVMlMFR+bHKRlgbxibmiAk4RyyfSRWuaJC7LmHCQGPmmf+fpptOipEZFhw
	LmYp1ur3g+MaF4TlRv/v/fNLLiSYHGN5d864pxpNOpoADx/yb/r0eoPmj6q/0dODIOBfwQ
	lC90tf0BUg4OH5FGhvTZc5cIxtFzuYA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jgFrLIrj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of kdipendra88@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=kdipendra88@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765810468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=S3roWa5MIiHY+542QEKCeiaGQ6v+8CYrzauDwIOyQfU=;
	b=SblvaSgcgUFvFFdn1NhMSf58im95l0FlWnJUgnJPdLHJ9advVHDq/EMTNqKGKVuOrRQNGY
	ejFUsLSVov6C5JcdTrMnJaN9H2PX7N5QkcO0zYK0GpJkQAzyw03NfCkSnLWsmHacBTf/iz
	0SvY3VytwIpaH7YsA52KLRCsXiZdVAE=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2a0d5c365ceso18086755ad.3
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 06:54:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765810467; x=1766415267; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=S3roWa5MIiHY+542QEKCeiaGQ6v+8CYrzauDwIOyQfU=;
        b=jgFrLIrjNs3TJmuHn3I4r3nPMnUZRxcro6E/2iWzII83aLFk85ZUM2Cg9mSY1JR/IY
         2pJdx5Bug2wPNAwpP7t8n7uY0Wiafm7p2r/ZQsrjdgrmOV2riSG/hN6XCwsedHdE9zf+
         2fZmE00YOKOpZKxRrlS6Pu101jhzVvZL+2Oo1SgsaCJeQ62SBNx9aFcPM4Fh9Pmq4uPQ
         hGD9EtdjXzFPW2z5JYr9N7AwUlmde+dHejoib3ib/0BzDgFwKk+wlfuPwFS/F3mg3SzH
         fiaLEe4IF7I2ci1iTx1uyTJElwj/6LSNgKu9iYGqOPGZWr+w5hCCBRscsF6u7VXwjCwE
         DdSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765810467; x=1766415267;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S3roWa5MIiHY+542QEKCeiaGQ6v+8CYrzauDwIOyQfU=;
        b=mkNce70EzQ4BGD+3oCBfZrMr/xFMwWXP0aRWhiHKPny1rJWHh0xnjkzOFKi5yjgDNY
         URnZT5sRnwbbNLHURJieqLCzVXcPJI5n9acT7rJq3StB4J10onMAKwUOhKeDU1UdMTm3
         b0Wuprm7tyCpIXQTNEP1VcQHhrVTaRnNsMXHWJjkJcBpt1CcsCWmGgg9b6S5Uq3QESnC
         uMEtNMEBKQQg0cjtoR5/9WBoS1x3ldCERZLs36CacrvIEthLr1osx+CLTzRsgh94S4xG
         CaG320uWwGLADJL4gQgN3qSlf49vOlQ4eY3rOEkLIMDTCl3JdHaW83hpWwyVXpK2ZYey
         SRZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUDrAQy1y3h0f7pp1Fm3XCAFU9U10s189VgzGMyAYdtfwI+Zmlp2mfv8okM/S2FMs6kG1OHsWroBw==@kvack.org
X-Gm-Message-State: AOJu0YzwGw1gzZykjTH8tvUPQZyJW9OR6s0QAV9L4C5R5kBXC5vwGpw+
	2FEr7M5DMPL3WzpOA5GmAHyExETeUwnc4oPdHCfLeNnIXMb7QrFpCsAV
X-Gm-Gg: AY/fxX43b2VPrKc3MJd88gHPntC5GbcXcUurEhwrRYKhsXIllgLaQODW3FnGsl/4DNi
	txgPgglLAeAsOIz/yiWxhZngv8EGRt+yBKsSOoLZ39WLTGj0HoWRLGo48550SACTooG9qISLiXg
	PcQNnPumgSji8ZoaijYpe6CmwNbHorXLNRtptFZCsX4ihtibpYwmXCGAk2yKC+/GujGEFELVCKG
	KqoR5WHxpEjLQd84pagIydKf9JaVY8ib1UfeABCPSiYtLCrwWK887WkyB6rw6lu+Q9mI9rYTcYE
	6b3kPvO1ycrVCetfgN0u6xkxJaPhadOd6VAKozb//at+wOTIdL5W+EQfrNbkDVmySxe3MGEeyPg
	hx6ZGyWE33objRBIL4Gio7o6MS9pm16Prh+C86oWseQvgG0Oc4IpDyLuF0kXx1LUFdAUbQBKQ46
	0tOTpCfzvTbg==
X-Google-Smtp-Source: AGHT+IG4GmC2JCSdgqBSfS3P0q9Pr3chOIKBF667RgIXXqBS4dAzymKUM3pzhVWLtqecRCwmu+IP3Q==
X-Received: by 2002:a17:90a:d407:b0:343:c3d1:8b9b with SMTP id 98e67ed59e1d1-34abd768603mr9052686a91.19.1765810466731;
        Mon, 15 Dec 2025 06:54:26 -0800 (PST)
Received: from ubuntu.. ([49.207.232.133])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34abe41237csm9396651a91.17.2025.12.15.06.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 06:54:26 -0800 (PST)
From: Dipendra Khadka <kdipendra88@gmail.com>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/memcg: reorder retry checks for clarity in try_charge_memcg
Date: Mon, 15 Dec 2025 14:54:19 +0000
Message-ID: <20251215145419.3097-1-kdipendra88@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1826640013
X-Stat-Signature: 446qxu8bnb11m8n336nbceo7iro5ccfp
X-Rspam-User: 
X-HE-Tag: 1765810467-758688
X-HE-Meta: U2FsdGVkX197RGR6owyfg595iAZYsLuFW0GC60ywRh6blTQ4wxdsA44t3oApwajQsTux2Zks29i3Lv5Wgd43ewpr4ODA+nSFsvsprni6iJxU4q5JPFagtSLxD6GRzWHaRjnbR8H1FHHeiolbdltjxOpGJuyq2RUhSPN2ZyBdNCnwf0L3/N96DzJGi8PCnZfyzx1CH21lLCP5AOgenk7ejhAmhcCKJfnssqaJ4Hx7j97KSK/HMIIfvgacJxVMjNAe0gdn7jyQOFuYECS8/iEQAqbzhUh+JIAAdaQE0IsOyrlMT8T2AmwPvm2MXOe/HGj+pbNeUjb86FMNKp+vMMkgyy0hNdeXb4SvvGWHigdO6uS3sdsj2wOIGjYOc7WyEBgxZgSRBpQ752MM6tlwCTG5yZn1/YlUM2oTgZsB3aVVsmszHEwyIvXprqtoEnJu+G+bwOVI6L5Emmud3Cw2ZYkaU1zWzeEL+HoCWMtPDQpO1+5PgdZOWeGaOO/0EyPNV+IZXbQ+znTnMBvi454G8/ZUci9gtdVE/g5Nt1aXbT9Kq68y8h6dkgcIiFNMqavGdOYanI5edMovNCzpvBw33xccKbNdJihLtdorwRLScNjEn39cPRkr/1psXPGHMrajHXI3cwkKxp3Lai5v/548icISseGzHTjSor5zdFYFH0IW7CnCTjPRmM3CM9SCFBOQl+gH01NunplKk1Cp7yvGr0B2fEMD/RGCCJxBPZn0sv8lSxp6aOdAuUDYpFqFUjyQDpjNY11PEFGfZaQpErlbypxiCUhUTVTRrZkurtA0eefuL64igdLUCXpVxna3xhmKK1ITrdZtIXKUhDQrKsAnX7dSF0EPBpcyZWUuOU/k0JBt29HKznRT6iGbGuezj4y7Y4qSC40oZyGfT+edhxlKO7SvRwj2BGuhuum9jt/rrJjP8cdyys5fDdt0oxzU+4lj4nDDK8GV6YD+WjNJYxc18LU
 i4yoKxRy
 TQ1ftCuADpnGlOHLlJB98Y9MVtK8bNl5U/4yMHlXUhfivaCrBuiwD0ARjJI5lYNfzJHf5BE21jFq54JTTCkaZO2FXLw5Aku7mDGKTkDS3ixfNzc+j+BgLGMb2xuMagQdsyyFG33pJ7BueQSW0BNl1dkzhOIRUOhGcLEaQ5E6AFxPk7yH67LwG7T53VemfBdLknmwCl95MrYBO3WsmXM77WHhMlzyeCJ28Cax9bB3530iDA7Ed1vdRi0GFrtmwab4L+OU35f/1AFZT5EoiEmDkXSuFcb+BH8HHtiza6V3lKUTKqOvzoUf2hI/XEtW0lu1TLX+s1dq/hMIXmiG2EMrlABtjyvIWsFxHYh7vIZ8kzCZCwKli+cIIiOS/zPseA4XJC0rHEsXtEMEzojM/V5+Jqx951V/8kyTgnD25zZEDeiT+vYOEiByBZkVC/GBE854Gi59W+OLRIO86mv0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In try_charge_memcg(), reorder the retry logic checks to follow the
early-exit pattern by testing for dying task before decrementing the
retry counter:

Before:
    if (nr_retries--)
        goto retry;
    
    if (passed_oom && task_is_dying())
        goto nomem;

After:
    if (passed_oom && task_is_dying())
        goto nomem;
    
    if (nr_retries--)
        goto retry;

This makes the control flow more obvious: check exit conditions first,
then decide whether to retry. When current task is dying (e.g., has
received SIGKILL or is exiting), we should exit immediately rather than
consuming a retry count first.

No functional change for the common case where task is not dying.

Signed-off-by: Dipendra Khadka <kdipendra88@gmail.com>
---
 mm/memcontrol.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index be810c1fbfc3..7c9145538683 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2412,16 +2412,16 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (nr_reclaimed && nr_pages <= (1 << PAGE_ALLOC_COSTLY_ORDER))
 		goto retry;

+	/* Avoid endless loop for tasks bypassed by the oom killer */
+	if (passed_oom && task_is_dying())
+		goto nomem;
+
 	if (nr_retries--)
 		goto retry;
 
 	if (gfp_mask & __GFP_RETRY_MAYFAIL)
 		goto nomem;
 
-	/* Avoid endless loop for tasks bypassed by the oom killer */
-	if (passed_oom && task_is_dying())
-		goto nomem;
-
 	/*
 	 * keep retrying as long as the memcg oom killer is able to make
 	 * a forward progress or bypass the charge if the oom killer
-- 
2.43.0


