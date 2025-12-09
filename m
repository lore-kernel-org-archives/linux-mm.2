Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28EF7D3B7E2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 03:20:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7124E6B0005; Mon,  8 Dec 2025 22:20:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C3146B0007; Mon,  8 Dec 2025 22:20:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D8956B0008; Mon,  8 Dec 2025 22:20:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4EE876B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 22:20:19 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C8CF71A03BB
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 03:20:18 +0000 (UTC)
X-FDA: 84198479316.26.5AA929F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf07.hostedemail.com (Postfix) with ESMTP id C873D4000B
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 03:20:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="bZ4eus/c";
	spf=pass (imf07.hostedemail.com: domain of kaushlendra.kumar@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=kaushlendra.kumar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765250416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/KoGkKUCh14Ubb+Afm2HFfrZJsm2eLANUhZPTCWHeyc=;
	b=mcBXhOfyfNJSmfc0BDBbML4ALvGzpO1fvXrI1cmc4Yas8Lgck6FAyKwen+1y+W/CQ5fdif
	v0ryDEzVgu2pp5B8+PsCc1x7Z3gi3TJNPsOPKwOtOvTm5dbzm19NoVINCvM9AZKXRa3ZBk
	kf784uos6+jWmNliOYKwS2Sw4xg+UMc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="bZ4eus/c";
	spf=pass (imf07.hostedemail.com: domain of kaushlendra.kumar@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=kaushlendra.kumar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765250416; a=rsa-sha256;
	cv=none;
	b=CIjk+He7Ou3l8HQjIBfm8t1xGzZWLMPPlM0ZLc0VpN5i/DMY64mi5jQikJd4vWFA2ZFS1t
	8Y8xXaDX52ADTaT/oYTV1ZD7SjSHHhrG9r/Ozbw1MCALVq2BE3JGmFZ6zZjf4BLcHMmz/v
	tseve8G/ssYEeXqi6Wdwf04Q3rdKC08=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765250416; x=1796786416;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fJOyc3Mh809YGg40gB80NDlSidpomT6SFQov/lglPY4=;
  b=bZ4eus/cEb5KL4N2mY3hcdU9Dezm4AY0A6m+rrQtFbub0uKv8R1QkHAV
   lSl5c18sxkO2tkvfSGydXCFcLZU/iTUCkuqXzhIq2Wc022BvFYZTYt9Of
   sxvLg3tEO2+HTnQmmVU4TK39NTYOIh+JoiWXKM7u57xwppKevGR+UZoVA
   0nZIEZe7i1Ov8zgcP1waWQkQ8d84Za2cnuu8s5LZvqvk+gA1R2watwy6d
   1rOn5MlmqWp/2JaowrjeHzUU8faXyyrEkEV/laJsBJuZKEtQOaTkGgjxI
   G6Lx48Xvm6mRGnJn9FKNrSJQ7mBxV9/jrHsdswim+oz/q8ntKau/FOT3b
   g==;
X-CSE-ConnectionGUID: VjsOl8AuT66dqbDta7zGBg==
X-CSE-MsgGUID: cYuqa4+PSYaxNLua35abGw==
X-IronPort-AV: E=McAfee;i="6800,10657,11636"; a="70824127"
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="70824127"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 19:20:14 -0800
X-CSE-ConnectionGUID: mkDVDGkpRq+lMN/qFGdpQA==
X-CSE-MsgGUID: p7HjAKnkQpqedZwjsd/YEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="219459779"
Received: from baandr0id001.iind.intel.com ([10.66.253.151])
  by fmviesa002.fm.intel.com with ESMTP; 08 Dec 2025 19:20:12 -0800
From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Subject: [PATCH] tools/mm/thp_swap_allocator_test: Fix small folio alignment
Date: Tue,  9 Dec 2025 08:47:45 +0530
Message-Id: <20251209031745.2723120-1-kaushlendra.kumar@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 46yfcn3cftqhfg7oy3nxsk7zpp7e446b
X-Rspamd-Queue-Id: C873D4000B
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765250415-64547
X-HE-Meta: U2FsdGVkX1+vCDDBr2oV4Qal+9Iw5J3fccPKNcpqSNYcKUYoRwlf99xBwIxFI0DMkxXbctFtXLCMvZfLww/MZm8G73HNzD/wr6wyh11LrBJYFtav/3aEjn+mYW/oT4FYEikTJ4mw73+rp9t3v9QLODPndeGICFbClwdA6ki/iUW1MXs+WuktKe9QqnKA4r2b6kN39SByRSZPoApGnFOYWWtWFwofQfIrAI1LWS2LWya6irhCs0JlcgQ2n5Bqm3f6w5yapl1xu1UHNMvCl1tSbZWmvB5ValSZSxi208yBIwaXj7UtEBi2Gcxe5ZvWuAyulh5IL+cSidYvVfQeTAL/D2k5ZUTecD2wNajf8Yt5ZV6DKSFudv7Q8RKLR526Ti2cItncOq3lLZeCW490iBLcNhbXSWYmSz/MERkBciPg8GUnvGkBGBZL7CpvZzWQRL3fdHj1u+9fHewvhxAi37P3iWeig358Q8oHYI6gMTB+vQ7RalTvtCZ3zb+Mbd/v/N3d9LuKgKeUg/0aVyVGQT3MyP8OHpZWMavDA4W34ryZhQbWaOWpBfd9NKbYa2Bw5rCMM6ZFfu1agvQQyoziQLeSLLqguO9HTHR0veUNu80Zk4AsolR7tSjA86Mbb1CEmh1RRJpfLvj9qiF8DJ+b2RLr1vDnx9icD/m9r6waaJDChcOJb+aSnVB527kB8hl4WlkKyDI/dJVTaQuNYAn7ftt4D2AgtMzdF2BBOn0p3JlZ60RWdtRrtvyTAGNavXSEs6JiGyzduWhJtGTtmGxo66u0spiKSX91Mc6aLWLmcUaoxFzVfO23Ax340LXsb0iBWB2YeyS3f4a8Cr5QuKShkhnmXtSCvCHHxzFUeQaSRz3EzriQpQbDVPG81xC9v5zDk+2b/obJjNQ0vNtuaYl0qS3lSQrlmrPknc6OaxkrU7o+Xzx++6j32VtUdhT1zVGXeTyl6Jo8Zo9hRa1ugxxWwFe
 7GdCPKV7
 octk38uF9rqU2CMDrHpz5jORESaaBz5vluOvJD/l5jC6+IZTBLzutjVPADZjD4w/Mtb8v639KGz/CetI4l0DRJ/9kKN2JpAE2XW+5vw4JeTsiSDU4QgcHtl0KQuJjg+/hQRBx7sLL756svjBHdqi8CkO+NPWKIZ+JQGmvimJSznLGNvKnAMOEmKOOt145LcNjISroIHvbC0u6CWVplbM7oLs+DF+Ssyqw40n5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use ALIGNMENT_SMALLFOLIO instead of ALIGNMENT_MTHP when allocating
small folios to ensure correct memory alignment for the test case.

Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
---
 tools/mm/thp_swap_allocator_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/mm/thp_swap_allocator_test.c b/tools/mm/thp_swap_allocator_test.c
index 83afc52275a5..d4434df3dcff 100644
--- a/tools/mm/thp_swap_allocator_test.c
+++ b/tools/mm/thp_swap_allocator_test.c
@@ -142,7 +142,7 @@ int main(int argc, char *argv[])
 	}
 
 	if (use_small_folio) {
-		mem2 = aligned_alloc_mem(MEMSIZE_SMALLFOLIO, ALIGNMENT_MTHP);
+		mem2 = aligned_alloc_mem(MEMSIZE_SMALLFOLIO, ALIGNMENT_SMALLFOLIO);
 		if (mem2 == NULL) {
 			fprintf(stderr, "Failed to allocate small folios memory\n");
 			free(mem1);
-- 
2.34.1


