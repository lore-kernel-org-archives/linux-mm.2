Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04970D35163
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 09:47:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30AE06B0005; Wed,  1 Apr 2026 05:47:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BBCC6B0088; Wed,  1 Apr 2026 05:47:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D1516B0089; Wed,  1 Apr 2026 05:47:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0BB726B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 05:47:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A69A3C730D
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:47:51 +0000 (UTC)
X-FDA: 84609510342.01.6532A18
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id AA0FB40013
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:47:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W3jaSwZE;
	spf=pass (imf07.hostedemail.com: domain of devnull+cryolitia.uniontech.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+cryolitia.uniontech.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775036869; a=rsa-sha256;
	cv=none;
	b=Ur2Ke/vC6ydRuGSmd8cuTMypZwMvXHo1PqNYkur6T/4CvREUK0W9aiE9CmPXgznCI2Tq8T
	Oo6cDG6esF/DS/2yT8peXigdIwsFmfAIMa/W9fD/vjspzCqDD72ne0JTkoNoJE96JdWT/Z
	VDFvEphVAuZSA18IK6Vi9RtabEeWsjo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775036869;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=afI2Lc+3MK5obFT9IQwgHT0dqRdC6lyakBvhQaF9U+A=;
	b=bOtYwJrQ4JuH/8S8sTgR66paXpp0scv1TH67mTHhxt6IM/dZPe8rSX5qIqR2TO/GDW43IU
	LUQVBV1fKnPMY0ZZExXhZvfTlvXnQq8Xy5HL269QD0ucmdhOtMTSEJ/+548kJ7LQZD3G/6
	RcWRv5jEIM7wWDn0sM6euZVm36aNaWM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W3jaSwZE;
	spf=pass (imf07.hostedemail.com: domain of devnull+cryolitia.uniontech.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+cryolitia.uniontech.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 88DDA40763;
	Wed,  1 Apr 2026 09:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 681D6C4CEF7;
	Wed,  1 Apr 2026 09:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775036868;
	bh=oHACDhC+fZQ3tsbDQTIB2DTSoCEJP78r6wVQx/nRDIY=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=W3jaSwZE0aXIN5yI/C4LR42EXdnDXP7M5k1CHLUupp7SpMKSheIoQwDHVqiaqc6z+
	 HrDnZZrqQGa8kMjQzIpvxOsIrW1gNka2MBGRhg5yAPPCT9G6FgstcjifE1zVls88Xv
	 Zy6h8qmoZ5O7sy5VFH9nDcmmot/DQIuGebhMIZfCHBzRr2JpGY8bQQGx41FWyOf6Ib
	 ZOqC6UBkSdfJ8QhBwjKToVoJhInlBXnZIGRA2yU5qQdlxDJCOtA+FLM5CSJN4i81Ib
	 1Jc/s92rNCLokaGmFD3rDpRMEYCfLf6w8vJ6YijnjJiCnKjIwBXjSoxjxzixwmyAl/
	 MvPn5AUyAJ3aQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55919D3515C;
	Wed,  1 Apr 2026 09:47:48 +0000 (UTC)
From: Cryolitia PukNgae via B4 Relay <devnull+cryolitia.uniontech.com@kernel.org>
Date: Wed, 01 Apr 2026 17:47:47 +0800
Subject: [PATCH RESEND] checkpatch: Suppress warnings when Reported-by: is
 followed by Link:
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260401-checkpatch-v1-1-57da0c7aeb30@uniontech.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDEwND3eSM1OTsgsSS5AzdJEvzFIPkpFTz1FRLJaCGgqLUtMwKsGHRSkG
 uwa5+LkqxEPHi0qSs1OQSkElKtbUAvrdnm3YAAAA=
X-Change-ID: 20260401-checkpatch-b97d0cbe7ee9
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>, 
 Dwaipayan Ray <dwaipayanray1@gmail.com>, 
 Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, zhanjun@uniontech.com, 
 niecheng1@uniontech.com, kernel@uniontech.com, Petr Vorel <pvorel@suse.cz>, 
 Cryolitia PukNgae <cryolitia@uniontech.com>
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775036867; l=1810;
 i=cryolitia@uniontech.com; s=20260401; h=from:subject:message-id;
 bh=YxanUXAo1zZz/4EvE63HKWNGGvJyrkveItkRihtZCV4=;
 b=D766Pb878qsWoWtRl0Y0dX3lM14ATdLtp1TaIGcCCH6ilanTBA4wKyOB419peRrrBVysnR6RU
 kqnOeWaKfSZCzh3anOpxpDemFvfIqvkNOvBuErAtYFvPCTQzK05soEm
X-Developer-Key: i=cryolitia@uniontech.com; a=ed25519;
 pk=kF6wBkp7j9167keuk8Q9RvPgMRPuHlJztbLy0vbJ3K0=
X-Endpoint-Received: by B4 Relay for cryolitia@uniontech.com/20260401 with
 auth_id=710
X-Original-From: Cryolitia PukNgae <cryolitia@uniontech.com>
Reply-To: cryolitia@uniontech.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AA0FB40013
X-Stat-Signature: ikd738178mkn6sof1p6jeogeu5bn8phq
X-HE-Tag: 1775036869-62836
X-HE-Meta: U2FsdGVkX18V99RmGVknP+nMNRcRketD0v6M+X5K8oWAUHeKUFb4suOw89ehAPxMtjOYMcfi74JJ5IjjacWFxMX1ds48yr0c+2JQ641JHwYgD8KcWIa3qZWvx9Ozup6glFRybMpnL/jtp54pad0qpwvoCxrZiY1c/bbcMIle7PCBYDbPo7oW7CEGMMYdY06/pmC3vuHWVF96clAbgT2E6LlmjZD9KsVSQXGJiH/3+xru8ne/4tGleE4STxUcflHuBaUXQAVw2WjczcnfHCYAJTSgipu6s6tkCW72GBG/nzSbN+Pnt6oRuam/ZCqpL6FryJP2U/GagZKdXDHrLGjlJMpJ/OIy3PAHLq9UFa5LKaEEQNvlT431xeibzyya3YtI4qaS0nOvWNupvEQS3uzr6zbgcLMRyvc6umTdvvi8hDqsZ+pshdM8MrgV02peQ3A2jtcuvudW5msJ1LQvL0G3582f4MvZBGX86vuSCEVy1BW9+R7/DHNM/DiaVBokwTPfg6ZQcpeRNMP0yoPtUPsAkYCj2TZjSywRq9S60f26UTxxR2YCE8k1ZMcUygkraDcuNCkIHhXmgkGYjGdvJ4toBRzzElpm65NVzAJXbsD97CXwTHh0+FtDR5jmE4LL4qylH6tx5dnTPjo8pgSlDOOL8f8qKV7T+a35zmnGh+e3Fe4nEnhDmf0aRsJHqFDi+9eevFtwoVleA1yLkUZaiDZ+vztixH7SGC9r+cHk/45/7fXJ0oY9kg47Rg3bEus+FOdrM7iHK1AY24xlCwwQog8o/+tmE9m8BjYhhtfS2Yi28s3odIVS1/MF2VO1E1JJQodxDvPo9XqzEwjAbse8cOEr3q4cNZOxfNFk22Xy7P0nCpz6LCf/n0VSr7izrnbHLK14VACV3O1XZUsWn5apsRYvWfIVBIh4OdOF1tuIEhDSumMlBe6B+Ort6QGTILCpu6Y1Y7XG5ieMMh9f8L+1d+Z
 PfemMkmo
 c4Jq292xmXaCHIk9hRYDNZaUMz3oSK8/vCgLVgVuaJiV5t+0EQWxljeYBQOi6lHapcZmld9g0qiT9DyOB1HG/UY4Y93b3+NVwj7OX7rTMKptIysEuggNr1CZHB48Iq8MPIbNMvUU4m8ufRkVWB6N5ZibVha+OE3hSyYADSkNh6goHYGWcrXH1CnwO8X339+pre1xzfRVDC07KpNJz0s5lpPXu4X9apllKvpZvPvHseYVlBPxctzUim+F6oe9IArBSC1ZM2Jcwajz1euCNQpvcvai7ZcHQv5QlhACeg5hG+q4TxL8FnCCQ57mzcxpqqpdD8oLiFSD6xP9bXQURWZtFpJl7DyS4sCDK2MsFAYPcIs84U1zmcw37wQctYBUuqy8ADK9HJvkeyY48WM4lKW4H/qc6/ySu/YW9o395MtslUodZl/+lPJ+7mIzLA8isnY87gE1VbZ7nzm4ozScizJk18FPjw60oLgVzmBH7J5QJRnAnwF8=
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
index e56374662ff7..b8a098061181 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3223,10 +3223,10 @@ sub process {
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
base-commit: 9147566d801602c9e7fc7f85e989735735bf38ba
change-id: 20260401-checkpatch-b97d0cbe7ee9

Best regards,
--  
Cryolitia PukNgae <cryolitia@uniontech.com>



