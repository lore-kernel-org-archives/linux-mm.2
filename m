Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2234D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 21:01:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1541A6B000D; Mon,  1 Dec 2025 16:01:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12BD06B0029; Mon,  1 Dec 2025 16:01:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 069436B0030; Mon,  1 Dec 2025 16:01:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EA3E36B000D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 16:01:58 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9DA641403FF
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:01:58 +0000 (UTC)
X-FDA: 84172124316.27.103AC66
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 42E0D100002
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:01:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k8H1Knt2;
	spf=pass (imf14.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764622917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dpXRiJBKjKItXddkwA9Bd5l2LFW+rFBJnSXqMQbB6qA=;
	b=OElxoNn0OFGyUDAST5kQpfgLWNsENI18GOrI33MZKNdvtzOGhM/WEWW5Xlcfk9xqUVl3JV
	P+nJx4V7gFsW750uZ3z7yokl92arYLaNdSEA+gufaV+Ue/pUIX+RGPKG6aOsZHsdVC4Qdy
	1ZbHIeXXlGRSr5Tx2owzh9I4EsqChoE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764622917; a=rsa-sha256;
	cv=none;
	b=vJghP8L6ch+KBMV0tZWbCk/mtmbzaYi453bOTIXk+J/OiEsgXTewaEwj5QNn1+Qa5Q0b1l
	kSFlsou6Z9oGj0LabvdCnw2+0vpVDojVNiNm2nwpXwCLAFTwyHDKci1v+uNX2dFJ4e+lOT
	jBoPWUwBK/XkRRRt/fDlqf6+rBcOC6s=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k8H1Knt2;
	spf=pass (imf14.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A0DD16014A;
	Mon,  1 Dec 2025 21:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442F3C4CEF1;
	Mon,  1 Dec 2025 21:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764622916;
	bh=kDg4UlKqtx2kxAbBrTrmlrpB3BG8XZudH7azKRu6UuM=;
	h=From:To:Cc:Subject:Date:From;
	b=k8H1Knt2YGtIAfZejDTzedxkXfpLumivEUzblkUViaRS8Zr9XR83xn08hJBwuJciC
	 CJljm6uG7ICFM9yue1j5ek4AHEaQhO8/sMgZI772ARV4Y7abtB0o+HRQBAJ0ZLT08R
	 8BesBi2Y9w/L7tlPzUSSP2l++fHSq5zgB4v5DnSBpllLrG3MjbbAJCLsyCEGtssDjs
	 ZlRIizMsoBwfqNdulGXSzh+/S5oJmi/GmMscqFM8IDQopW5N6nd61VATl/KY6WrMuD
	 xm8UuHDjKQPG5Wyhqh+kAIBzfXjDSdab6QMtoPmQyCZaIvxYVKhmfzDVcfJq9B+qpg
	 LHe/XjYOOtSLw==
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH RESEND 0/4] improve fadvise(POSIX_FADV_WILLNEED) with large folio
Date: Mon,  1 Dec 2025 21:01:23 +0000
Message-ID: <20251201210152.909339-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.52.0.107.ga0afd4fd5b-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 42E0D100002
X-Stat-Signature: ez1ag77zrm8xzemwks95dk3ez1z4wcmu
X-Rspam-User: 
X-HE-Tag: 1764622917-172881
X-HE-Meta: U2FsdGVkX19CxV/lKg4UxFQv4zUrED6IgUMj+I36dfDHOly4K4CMgeA72qdSJ7fz6yCXBfzBgympvlzuFSJOESxPbnZkHW7VzPikifA0yyYZ+U07Vg6w9pKWQTH/Mw3aj0sR3vGAgXZYhnkWtbRAMFxFPpPrRMDwv74GYfGmTGJeZlViauxq1CJm9mmkSZN1mdMYgbhsZnCN9714zohVVqeamEuElf7E4DpucDJUUifFvFHt18C7fV+XnSgTm1KtNKnvts+WSWMLTT8RtoFm9giPoGrZvEfwJd1CldT4n6J8gXI9Son9oKBx1YflmA5qpBgmuSHeeMaVrLEswBe94pt03cNbnTh2rTgt2lV3lpDjzwVNjx4xLV1rAUwioldPwTRklJiknGKqslq6GkQEIaRuB5gTmVepusfmxtUzHk6sbREn8uDZ5IQfwMcda88YAg5+QdnAn2WatcOjHXYEmKcJ61e4k5VWcFGHC0aJMiVBiSSu9xL4vgDufW1iSAnWcCHv7MbHPjah1FNGNMCaPiz6CRunh/9xmu3bhm6qI7tOPRJr98HmeDKe8O/rkoYOZVLqTo4tywtTeIFmlUY2HpDhXlPIUCgHJpOTTy76BJFSIq+4I73+qvozjKNs98x1LlzgMtHhqFt8XGYLN8i+HbQOWY5W61HxEzRpUUk5Jff9Tyjenng17TPYzqMrKK1GAYVH21V+oYUDtRkQGkn5N+kXu5RMyTnLcKvOvVMwXLoCPEt3Wn3ehaej+qSVW+t2xCbeKudG4a20o+HEIMhPH9mtIC+jPQYT/a0hVeku/Gmi0QVTcpvleNpBpilHUFSDgK6qu3DZnI5gmSrv4z+uVINF2HYDxACQo7IT6czPWmkDMdiAQ9iwWu+UhbimhnV46HXPcZlWa49TwYdN7ziBS851Autr50aQO3ebkHVq+OH7Zc601WUUKiYA6ZGN9X7A2KrXE5PSk84eCGtqSiS
 h6vo/15n
 bK2cJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series aims to improve fadvise(POSIX_FADV_WILLNEED). The first patch
fixes the broken logic which was not reading the entire range ahead, and two
patches were converting the logic to adopt large folio supported by filesystem.
The last one is one example of how filesystem can set a desired folio order to
boost the readahead speed.

Jaegeuk Kim (4):
  mm/readahead: fix the broken readahead for POSIX_FADV_WILLNEED
  mm/readahead: use page_cache_sync_ra for FADVISE_FAV_WILLNEED
  mm/readahead: add a_ops->ra_folio_order to get a desired folio order
  f2fs: attach a_ops->ra_folio_order to allocate large folios for
    readahead

 fs/f2fs/data.c          |  9 +++++++++
 fs/f2fs/f2fs.h          |  3 +++
 fs/f2fs/super.c         |  1 +
 fs/f2fs/sysfs.c         |  9 +++++++++
 include/linux/fs.h      |  4 ++++
 include/linux/pagemap.h | 12 +++++++++++
 mm/readahead.c          | 44 ++++++++++++++++++++++++-----------------
 7 files changed, 64 insertions(+), 18 deletions(-)

-- 
2.52.0.107.ga0afd4fd5b-goog


