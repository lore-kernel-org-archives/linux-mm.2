Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E335FC5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 04:57:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B478C6B008C; Thu, 20 Aug 2026 00:57:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD2836B0092; Thu, 20 Aug 2026 00:57:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 999646B0095; Thu, 20 Aug 2026 00:57:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 745F86B008C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 00:57:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DFD20C0235
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 04:57:01 +0000 (UTC)
X-FDA: 85120438242.02.C7960B4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6E0CB120003
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 04:57:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NFUgWOys;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787201820;
	b=082J5cyUPl4UAZGEGsYfhOwf7H3qTyJNH1SGEWZ1t5CVGlvznk+aYZ4ZWfddsC9ySzDuXH
	dBNs4qiPFK2sMYVlBOMorFO2ICkY59erzK1MDb/gbQ+kBago0HseyqmCd5HifDywdR65by
	vW8e8usftdA4qSwPQIit9yMrij6/ATw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NFUgWOys;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787201820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4L3tCYfMcprThTLF8cGSPkkXsWoPgAHAwOsqwT0J3EQ=;
	b=0+XpN0AB2JE4LDKL+XlKc/vF5P2v1ecCekhByr5m681NgsvnVUQ+kkzvlknO80oFmbN4fs
	xB6PrlDouRSGki1OEQi2LrR3QuY39OMducwl1CjWkUy2qrJuJ/Fz5COVV9fxZv6h7me/fM
	S8uRvxbrKw3BYrImRd/89+AdcxBLnoM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DAAFF6187F;
	Thu, 20 Aug 2026 04:56:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A071F000E9;
	Thu, 20 Aug 2026 04:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787201819;
	bh=4L3tCYfMcprThTLF8cGSPkkXsWoPgAHAwOsqwT0J3EQ=;
	h=From:To:Cc:Subject:Date;
	b=NFUgWOysqFkevH2ZIEaDAd+BW0UQ3QQY/W3BpLgPgTDV1UDTLHVkss0hbYQUFJAWW
	 OBilIRV7RMcezR+VXGnXMioPtkQ7ip7cYTIoqKypvllfQ/j3YZxFbcJwDroHU0whhC
	 3XD0PvU6Z5ebQ7HHkzGGbzlmwiIkjgisePXr0YqMGyQVBPr1AATdoHZU7Tq4peUafi
	 sXIG9CGn417LTehvsMMq5kQnyxecVJk4VOUJ7K24CyCjNfndD/DPTfqCON+Ee1sHXD
	 nxPrR5A4hs4l+VBQD1baPY2ddDntsquS7SOspxq9b+OOpVwY/S5ZxGo5OAN8CIILyo
	 BNuTJYCYocpiw==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH 0/3] mm/mglru: clean up isolate_folios and scan_folios for readability and clarity
Date: Thu, 20 Aug 2026 12:56:00 +0800
Message-Id: <20260820045603.68809-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6E0CB120003
X-Rspam-User: 
X-Stat-Signature: zj1ynxrg9azuehnzfp11g14r5no8ig8t
X-Rspamd-Server: rspam06
X-HE-Tag: 1787201820-121131
X-HE-Meta: U2FsdGVkX19ENrAKtPWxVL1AtHN7C9HQiIyClZcdxrI28xaaH8WS2dHEYWSTXf+3EM70Uc94kFQNSiD31g+9Mbq0kNPCA8Puzt2YN2C4rp2ueyq9UrV30GGf1nEbd9LI0Ey0uOzrwlXMP3KHJGyYktXiXBQokdiVJ3z9sozwztwupcVweGmdmbylMv6qdj94eHnPWujkc6sUuIUiaPOtpjpGKNziOvK9X9lGLcUMDqM0mlOc3AfeKb/VFoCywNJgtiojWZQBunxeUf27U6sTSIs/aMVBFeJ3YF+2E+xpU1r2jTDc6yArlKO8Atjc042Inqq+ec0cbUR77MJIjQEmIVoTJyfeev2BxiCUs4aM+sXgsxHRWkKzVeyuqIl6WsMblZuSB3xecWPEDFpH7vLLi6rZGILXrsmG2SLv1/t3lEWZb+lufnFj6pa988xWWnUegSPoQXlBcfFXSeAlpDjP8Ie3WZU48FbmmA3ghmRtYrlO+xtSjiyhdMrfEpTBboE3koRIydp742Y6kw1BTY3t0g2Vcen6pXYBVLZL1IdiB/Gg6hEGVinzDWcS86KwgMCh3qeJP9k2Lj4AsFyfyaPwCFdtL8xmCjZeEvy7KLgCUHAO12a2TBzx94vowjV6ia+I2wkVFy1OgYldCxijBVVIHUQLGsQ3cH5Zgm51V+30A7ee3cJlnvIbj7ume/qmRzDKZ2X9Ip0SxCftpCgr5EQQwdN2A0ylgj3h2R7sKCVu0HU9NOm2gqI28b7ircasnzROsk8uN1FM24sG0iHrrnaIIBKUz+zmV46jZwkyiyp+1YXu0FXWh60L8hhd1ovwrCvzcHHR97h7npyOoGBmIG23dyZwltSeajd1wxpS3U0luoMHQ9iGgO2/ccM4Yb0noHfPentandEdsaCy+kp1jM5TM6h19PMtKbWht5YNDR1FK9+fJkVMOD8vuW0MdZX9+3AbZNgB7ol4vQ2crWr5mq7
 uQapHmq5
 bc/ljONRrZsXWTDGCDS3+0wR/EGnL7h3hKhVwld9cWT8RhiKgM/6Kv5r+LWFLr/Ab2zC4TtfJfznI6jKMnO/XRRWcPnoe0Gvn0uoCW+EVv7ntPE6tk9ogqYM80ESr21nCKnEHxxUvmY7RVGeJEIcSbwKToZ4B4lGDT93T16LkcbRNEcle+FZQqsCH0J238C9gA/D+A6ZuTgDZ4wapL82dkUtbYSENZItL6WCKeRupAYP9VxtXxY2T4PBE8d2eanNtE1fipN2xZ7IkV781rXDSBP2Urx1eDgpWp9XaAEtZw2ERXEZ2NMdFr5MCHxSkFmVAffVgspQw/exy6pAy4nnP+hlrlwXE0gDHx9mw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a cleanup series split out from the MGLRU swappiness series [1],
with the cleanup changes separated to make them easier to review.

Right now, isolate_folios() is quite difficult to follow:

1. It uses for_each_evictable_type(i, swappiness) to iterate over the
types, but i is not actually used as the type within the loop body.

2. It uses scanned == 0 to detect whether the current reclaim type is
exhausted, but this is not an accurate indication.

3. It has an internal retry when no folios can be isolated after scanning
some folios, but the retry is implemented in a way nobody can understand.

This patchset makes these behaviors explicit and much easier to follow.

Run kernel builds for several rounds in a 1 GB memcg and take the
average build time. The patchset shows almost no performance impact,
with a very small improvement that could simply be noise:

                w/o patch   w/patch      Delta

real             109.149    108.990     -0.15%
sys              223.213    222.592     -0.28%

pgscan_file      498,208    486,994     -2.25%
refault_file     262,696    254,688     -3.05%

Thanks very much to Baolin and Lian for their previous reviews of the
original RFC patchset for this part.

[1] https://lore.kernel.org/linux-mm/20260812121658.69965-1-baohua@kernel.org/

Barry Song (Xiaomi) (2):
  mm/mglru: improve scan_folios() exhaustion detection
  mm/mglru: retry the same type once if isolation fails due to races

Ridong Chen (1):
  mm/mglru: improve readability of isolate_folios()

 mm/vmscan.c | 78 ++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 54 insertions(+), 24 deletions(-)

-- 
2.34.1


