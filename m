Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74293CD6E6B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 06:57:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 858616B0005; Fri,  5 Jun 2026 02:57:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8093D6B0088; Fri,  5 Jun 2026 02:57:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71F076B008A; Fri,  5 Jun 2026 02:57:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B7896B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 02:57:18 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0244D93081
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 06:57:17 +0000 (UTC)
X-FDA: 84844952556.04.996E823
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 85C2D4000C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 06:57:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=korg header.b=vT2fhohF;
	spf=pass (imf07.hostedemail.com: domain of cryolitia.pukngae@linux.dev designates 172.234.252.31 as permitted sender) smtp.mailfrom=cryolitia.pukngae@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780642636;
	b=z+KhbvBlpyl9vjNOzRpjtz7COIOHISy21Zp0seNpoyfcwe00Trcrpouv61OWh6YygpnD8O
	nzmqaRRbXR0FRGYUsm/eMGygXTibumaluv3SycLWeikaxyfGd6KSKyYFAb9rJPXHqo6q5U
	BGJFlbi3LXbjHM5PyMYQLUVlXALRl2c=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=korg header.b=vT2fhohF;
	spf=pass (imf07.hostedemail.com: domain of cryolitia.pukngae@linux.dev designates 172.234.252.31 as permitted sender) smtp.mailfrom=cryolitia.pukngae@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780642636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jYWJOnlyygTlEBobdMl6/aMt270x3xPYNVbHwWdReV0=;
	b=oiuWq4lBRnELAl6kmcbOcTwXJSuWOGmj1f08Kbdfeg5TBbJSucgSDNj5H8SmcovOJfT2jD
	elYuLKHSsdYb2FxrYm+I1hZUEKRM/EYUbnUx7oYbhFXNaAFy0BTfBjQhASGubqyt7oGeBO
	H1jiAGUd8nW8cf4KWfhusm7txWpmUXY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BFF7E43D84;
	Fri,  5 Jun 2026 06:57:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9EAE1C2BCF4;
	Fri,  5 Jun 2026 06:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux.dev; s=korg;
	t=1780642634; bh=+19Zsk5vOXZMyuMg7RMcM29ulngnILx4+uZ4DNkfhqg=;
	h=From:Date:Subject:To:Cc:From;
	b=vT2fhohFphNNPru2XOOUvCyDL1p5NKcSO42ZRUJ2m+qZVdA+pKSaKJj54t+AGYBEr
	 WHqkm78f+KzD3FQa1DKcm1u1IrLtN4Tp3gUomPpUO0BusNCx9W+owBNG1fexFLjvoe
	 +xISEKsmEEyPv9WkQMbUUF4AqsFOJ59hx6x8Xvfo=
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84022CD6E6B;
	Fri,  5 Jun 2026 06:57:14 +0000 (UTC)
From: Cryolitia PukNgae <cryolitia.pukngae@linux.dev>
Date: Fri, 05 Jun 2026 14:57:04 +0800
Subject: [PATCH RESEND] checkpatch: Suppress warnings when Reported-by: is
 followed by Link:
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260605-checkpatch-v1-1-8c68ae618513@linux.dev>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/22OOw+CMBSF/wq5szUtPhqcHGR10NEwtJerLUZK2
 kI0hP9uwdXxnHznMUIgbynAIRvB02CDdW0SYpUBGtU+iNk6ach5vudbLhgawmenIhqmC1lz1CS
 JCkiBztPdvpeyG1zKa3k+QfXzQ68bwjg3zaSxITr/WVYHsfD/BgbBBNvJWnGUivSGH/s2/YuEZ
 o3uBdU0TV89BkK0wgAAAA==
X-Change-ID: 20260401-checkpatch-b97d0cbe7ee9
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>, 
 Dwaipayan Ray <dwaipayanray1@gmail.com>, 
 Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, zhanjun@uniontech.com, 
 niecheng1@uniontech.com, kernel@uniontech.com, 
 Cryolitia PukNgae <cryolitia@uniontech.com>, Petr Vorel <pvorel@suse.cz>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1780642625; l=1814;
 i=cryolitia.pukngae@linux.dev; s=20260401; h=from:subject:message-id;
 bh=c9WOjIkf6PqQcC+UWyqhsH7Lp0mHPos984XKOAN5Tdo=;
 b=wmZomkal1ceAYLxYqsR55LBmE95VujryRzX7m4nZXkxbncAL+HlNFyns9W1vugQF9VpuvsNUC
 tdG5nZGkDf6Dw3/lubNoHtBG5fuOHAJhPQlmNOcAaM9Hs2hBtq7nwCj
X-Developer-Key: i=cryolitia.pukngae@linux.dev; a=ed25519;
 pk=kF6wBkp7j9167keuk8Q9RvPgMRPuHlJztbLy0vbJ3K0=
X-Endpoint-Received: by B4 Relay for cryolitia.pukngae@linux.dev/20260401
 with auth_id=712
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 85C2D4000C
X-Rspam-User: 
X-Stat-Signature: u179qcpxa8eokgebpibsctwmhot6q6ob
X-HE-Tag: 1780642635-651679
X-HE-Meta: U2FsdGVkX18f62muzMHj+xCcYQ2tD6h/uZOy6mKUCg/ITbuSz/4EO7l3/t8lty+DLmOCqyClgN/MyZWpE+yPI4x6b4L5El45IWcNpkG/ChTNuIJElXpHQ4214RXKTvxEZNW+4MiFyjFsR9aDerhhjv/r66bd37AaNm+MZiqiarqZzsXHBWsIa6OPpIeKSVIgj/o3ayyeABwmUpZXDICDO6vQHG9fLcCAKGPy5JNHuKrzThTV2qWbDS6O4Quq8YUGxmyzVKT1a8KCjAunwduFtDmv5WeI8dO2ef9H+nYjclDLV8HV0KRymSKHpVF07AgXKRC7Zhq5nHg/spqTlMGGEx6yufWeZMphyOJBpVIPMwXjW1CMZMBtWOAFyPVwvWr5pTqB/xncoLqB7WCSywNXBFUPUgxWzGxWJYug/03kFDqIc76JOuLgvKBHxBe9gWmJ5Uq6m/tnbBdO9u91ncXCWTDzxzAaDWy6P5lRoTM7kBME4+vuZGpXjE+YVWAHQAx9pskn6aUUSaCIQrnNQnPzWRobAnv4ZkVGs4HpGg1AyLVF6XGJacvDiIxYicN8RnJmCuuXivyj18jPwLphNC492E1IvSYFubbrJaGK/namefiGyjTDc12xYISg9jctIV0vQWJXVa8voRdihrG4rs4s9lJW/X1vJZbQOfek82WGU4lfiy8ilxwya+K71r8QVWodoQUDCTf/BXfrmKjTZLb58c3DfUE4RWHG3/t2W993a1FXCy5QidFKPDV/8vjkkvrv1DJtAgT5qIObc9/J/ygmTo5x7sOhqr7SNASbu+OnklRs1eS/nDBta8o7/vFIS9YxTSNPDHXH6gFNfux7iCUU/zB6yd/ON/tj283bHREyFjqoqm7HLvGOEIuT425eHCFfyMpr0dkvg2EuNRC3gjbnqHC2j9ZAQXeGIjdUfQLffGNuO+ihsTWsPrfOm+gYHdllouv8/+87t5A0C1fhpvZ
 +bx3Uqfr
 AEWpEZ4xeeVRotglOuhEghRWTK+j/kDxNCXPOFnJv1K/1f78LYJf0sM93/qozj+HlO/uykGeoNiOkaMCqi4pT6+IxYyD7gfFFsOowVuVYiZG2fVknzEpsbz4ClIrvharSDs0K7XxIsH26ViA1/yolPK9E/iAl+ULPTvu1BaBSlEpPblZJQJZa7sy48H67onNS8CgaJ8uOu2H1vqnYffi2LEg0InAvH9LLAnYxh4Grt7Xwiza9bvT3mb3WobXbdhdlETDH7E2/CoF/fnVEZkrYraXRJyhquQO4qzkpdCd78wq/pBrVStMzzBLJuuU5n4L/Zzz1XWv59c7VPFlqoQY65sRRKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cryolitia PukNgae <cryolitia@uniontech.com>

> The tag should be followed by a Closes: tag pointing to the report,
> unless the report is not available on the web. The Link: tag can be
> used instead of Closes: if the patch fixes a part of the issue(s)
> being reported.

Accroding to Documentation/process/submitting-patches.rst , Link: is
also acceptable to followed a Reported-by:, if the patch fixes a part
of the issue(s) being reported.

Reviewed-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Cryolitia PukNgae <cryolitia@uniontech.com>
---
 scripts/checkpatch.pl | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 0492d6afc9a1..bb452f5313b6 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3233,10 +3233,10 @@ sub process {
 			if ($sign_off =~ /^reported(?:|-and-tested)-by:$/i) {
 				if (!defined $lines[$linenr]) {
 					WARN("BAD_REPORTED_BY_LINK",
-					     "Reported-by: should be immediately followed by Closes: with a URL to the report\n" . $herecurr . "\n");
-				} elsif ($rawlines[$linenr] !~ /^closes:\s*/i) {
+					     "Reported-by: should be immediately followed by Closes: or Link: with a URL to the report\n" . $herecurr . "\n");
+				} elsif ($rawlines[$linenr] !~ /^(closes|link):\s*/i) {
 					WARN("BAD_REPORTED_BY_LINK",
-					     "Reported-by: should be immediately followed by Closes: with a URL to the report\n" . $herecurr . $rawlines[$linenr] . "\n");
+					     "Reported-by: should be immediately followed by Closes: or Link: with a URL to the report\n" . $herecurr . $rawlines[$linenr] . "\n");
 				}
 			}
 		}

---
base-commit: ddd664bbff63e09e7a7f9acae9c43605d4cf185f
change-id: 20260401-checkpatch-b97d0cbe7ee9

Best regards,
--  
Cryolitia PukNgae <cryolitia.pukngae@linux.dev>



