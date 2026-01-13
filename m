Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 882E3D29DC7
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 03:23:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED9FD6B0005; Mon, 12 Jan 2026 22:23:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E87846B0088; Mon, 12 Jan 2026 22:23:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D86FC6B008A; Mon, 12 Jan 2026 22:23:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C65116B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 22:23:01 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 49A0F16164D
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 03:23:01 +0000 (UTC)
X-FDA: 84325494162.09.1702788
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8D5841C0006
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 03:22:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uZmzN8am;
	spf=pass (imf21.hostedemail.com: domain of devnull+cryolitia.uniontech.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+cryolitia.uniontech.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768274579; a=rsa-sha256;
	cv=none;
	b=Ow3a2VSl8/4XivrFPB6HpySe6P7LfFnU6beLoqIqr4yluMkSkHXCVp+Kgd6Zgj3SzIKgde
	TAWU/ONVVAdcB4q7FMsb27H4HXStgKxJMJ+voUmufqfQb1kAy6uPI3IY7V8GO8IO1oQsPZ
	t+p02ICN3mbe61yGWWUIYCmv/xpoVtA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uZmzN8am;
	spf=pass (imf21.hostedemail.com: domain of devnull+cryolitia.uniontech.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+cryolitia.uniontech.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768274579;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Ohu5KYi70nrrnVebeH+pPJSMMWiMo6Z4K7J9WYnr85c=;
	b=XAG2qqh5hc3DIZOrefMbsmXbruAVIQpDUS5PpF7uJzMl84nG5Wq3UgNwWNRUJOlZAz3gLg
	BkqwSFpag0auL3VwX1MfdZfFP1bsqFKSY7H6Htf6hxE2NLPEXYtjbJ6ra7cozzTMif9d7q
	fVJQ9CJB69IPMt8Q2tUpu1gbKmGtKz4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AFBB66000A;
	Tue, 13 Jan 2026 03:22:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6324CC116D0;
	Tue, 13 Jan 2026 03:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768274578;
	bh=qBpGhliMx0mgkoSIcLVrnkmna3UupRTRq4CYtRgHij4=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=uZmzN8am7TsNtjl1J8Tbisho/1vcJZo0S6VCCtTl6DjCIPsn2NZOYTQBUxc2JHgWg
	 t990mLwwkR8k5nzcBM+oUW7sFOBiRvQiAYtu1k6qZ6yFTylSm1vH3gkYjjD2Oct6Nj
	 WlVr4+e1oo6P2ORGSxAFUkQr49oMOIa70Ij4eHt0JD2dagek0Ue+XKD4BsG33ozVkQ
	 LeE96XU+ezVv+9k9w52uaDx56Ca3SwiQY1evybkPFfx5Xzo9ubhxY0K1Y15JXSdjoW
	 qGEN61Nwx15Tz30zmDOT8S5oHiEB/awMLRwOaxI269xqNG7z9ofidele9DK0+IYoLX
	 YLNUCNTHwZ1qw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D96ED29DC7;
	Tue, 13 Jan 2026 03:22:58 +0000 (UTC)
From: Cryolitia PukNgae via B4 Relay <devnull+cryolitia.uniontech.com@kernel.org>
Date: Tue, 13 Jan 2026 11:22:52 +0800
Subject: [PATCH RESEND v2] checkpatch: Suppress warnings when Reported-by:
 is followed by Link:
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260113-checkpatch-v2-1-5dfe8b9f4d90@uniontech.com>
X-B4-Tracking: v=1; b=H4sIAIu6ZWkC/3WOPQ+CMBiE/4rpbE0/sKVODrI66GgYSvvWNkYgg
 ERD+O8WRpHx7vLc3YBaaAK06LAZUAN9aENVRsG2G2S8Lu+Ag40aMcL2RFGFjQfzqHVnPCZMCpl
 KKFwBKAJ1Ay6857IbumTX7HxCefR9aLuq+cwbPZ3Tf3U9xRTbNFVKcsWZ08dXGd90YPzOVM9pY
 cIoIUus0I6AoEmhxCrG+AJzTnKwMZJWrGCUkuVJqUHZRGguf7F8HMcvDt71blUBAAA=
X-Change-ID: 20250919-checkpatch-0276787ebfbe
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>, 
 Dwaipayan Ray <dwaipayanray1@gmail.com>, 
 Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: workflows@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-doc@vger.kernel.org, ltp@lists.linux.it, 
 niecheng1@uniontech.com, zhanjun@uniontech.com, 
 Cryolitia PukNgae <cryolitia@uniontech.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1768274577; l=1809;
 i=cryolitia@uniontech.com; s=20250730; h=from:subject:message-id;
 bh=VE6TM5bOD2xrus3PUyCCcDFeowc5jbcfaHJXtjNJP6E=;
 b=H/KmEQriZzSu52B7ZrKMnqG2miNglsyHC9jPS9DFPtDDyHeRknjMSTjUw8oeg5JAuFoPIVG8m
 kMABb8g9rLOCjvhDqFxcPKtvNRnyqmmB3yJsoNFtH9tMhlOJovsCtNo
X-Developer-Key: i=cryolitia@uniontech.com; a=ed25519;
 pk=tZ+U+kQkT45GRGewbMSB4VPmvpD+KkHC/Wv3rMOn/PU=
X-Endpoint-Received: by B4 Relay for cryolitia@uniontech.com/20250730 with
 auth_id=474
X-Original-From: Cryolitia PukNgae <cryolitia@uniontech.com>
Reply-To: cryolitia@uniontech.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8D5841C0006
X-Stat-Signature: u8q8bqrcktoxnerzcmbwh5zwgmoeitie
X-Rspam-User: 
X-HE-Tag: 1768274579-654835
X-HE-Meta: U2FsdGVkX18EoUFZ8wA099pWyFJk0B5DzrqtZ+eZeOJc6U/Tdu82PsyQI3Hl3BwbdgnItoUqSck/SnD5AFJ1lBIZreLd8ov+zMgSeaEZAsPN/Bat7KkZLnCT0wCEWsHWPm/J5tpe+HqCB7WXw0XzxNNDbYAUGO/l+9G4Sq1ZZRmiyk/tnSU8mRN1FnRq07kD+ppbbbrChDeJwi44vXJG8aSicei2hOI88JahYx6CqGo+mIinWJziRYS8+zCRXNUIhtBSizmX4RDOfIla4J+Qjyw+0iATqwFE5liQRfe1CYA/jQ7i2QdekdUbF7vgeX0cy7I+Tjskye36rAnjKVw+f9z7Za2hUs5glaOaii9tY78WiwbmCUrGJwU/QyVQKD15FEZ0ivo4vxuPxu3+J/LgqoOhPELywP7PLpAOCWcOM0NBVDXvKEdeU1wg+0eMlqICRQLzjlRcy26tTYJLjGIVaVoeG9Gh8w3J5K/eo1ovRGfxUNYW8vy9AO1skJf2LnaILiYPemAPpZaZZ8kybgqZCV8Q2gPD4Kdpc//eoa9K7vjoje3Y2Hq2J5FPBQ0y6uxk05bfUn3CbNw01zFnnD9MFC7EH+fFe+tWPq99WAfUT0e+c4cnAoMqiGR617CkRQrZqmgaJk2Je9LSwzCQeNo3lbiG95ZvXJqKyTPJlO6hEr1Qx8JJK4KPmHh4Ky3I6MCbnI4Xo+795IjKD6eY1XieV9uxP92TaNwfWp0kluNaI3W5xtCei6a/PKEhaHnYb6giB/aU4EyvRkES2BT4/VvqUlcCaRtfu9OreeQauTp6JnCPvEXF/yNY47LK1Nx9de4/uVf/cBodN8vpfZ7taVEMBRJrt0maNrUPZ9EPcI5kvpMChwcsGy03335Iu6bf17ol1D2uSnDozBQoMJPsjmGMzUqJCz4xa3JG85RtDxv9h+l1DGP14IIVvYuSHLT3+Bq1C/Zy00/JH0Qxhhtxv3h
 yhnd+pW/
 NS4iLO8uO3RIthSjfab7nkXd3d2qzURMXffjsN7h2ady9VVw/GrHX/08QlvIa2tNqCIdXfyR/aZsjFYWNe068sQvLiWhNeVnQ83E3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
also acceptable to followed a Reported-by:

Signed-off-by: Cryolitia PukNgae <cryolitia@uniontech.com>
---
Link to previous: https://lore.kernel.org/r/20251023-checkpatch-v1-1-ff73ed1027d6@uniontech.com
---
 scripts/checkpatch.pl | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index c0250244cf7a..dac9d98133c6 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3209,10 +3209,10 @@ sub process {
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
base-commit: 9448598b22c50c8a5bb77a9103e2d49f134c9578
change-id: 20250919-checkpatch-0276787ebfbe

Best regards,
-- 
Cryolitia PukNgae <cryolitia@uniontech.com>



