Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0632C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 01:03:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A97126B008A; Thu,  6 Aug 2026 21:03:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A48016B0092; Thu,  6 Aug 2026 21:03:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95D596B0093; Thu,  6 Aug 2026 21:03:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 673C36B008A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 21:03:32 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4F0AA1C0DAA
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 01:03:31 +0000 (UTC)
X-FDA: 85072675422.26.24592F9
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5D0C2140005
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 01:03:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="DK/v3Y56";
	spf=pass (imf26.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786064609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4NPMPfYvs8YO3COzwGcfWMaaWC300S3yD9dfuIoNJs4=;
	b=sRPWgJ3axK+MikEsXfaIm+DtKAhknDKsgQS/kJRFf1nKU2yLBOK5kix2oW+N2cFZR6o/kS
	/hroxoM2dBsOtb+M2lc5OMB3wWHMUUfNV4Z2QVZq/mBqM4QDW3LPaYB2tWBNu95upsPUXO
	bcA9wWALWLgFNXO3hRqUyhiu7fOPlLA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786064609;
	b=F3gt4pP5aXoXI2fWQyPXTjvFYzhdo7jI418GHk8OyTeaWUwUoJV6V2Ct21b81CAShAQ3uC
	U+8i63s656kEZP4TodNoa5HNBsIf1MT7OfmW9uheeaS0rZLY1ShJNQ/OXUMGZ7Qj/KYZLt
	WxqUBC9HsjMDDNRNLfhtSwvca7nImYM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="DK/v3Y56";
	spf=pass (imf26.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786064606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4NPMPfYvs8YO3COzwGcfWMaaWC300S3yD9dfuIoNJs4=;
	b=DK/v3Y56xjFrF2K8N+nAgaSF6Xik8ghGF389/1ErJLjR7yxWtsXOwDMdmUoFnpVVF7J2yI
	HuntldO0cCJJ9DkY+kOrjYj+AJ8k4Gljl28gvoJ/18Vw6jlYIawDeHx3kqyxOLXjs7LJyL
	wxVaRnlWpAOnlipMDPvrR4M4jFO/Nv8=
From: JP Kobryn <jp.kobryn@linux.dev>
To: shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS, mailmap: update email address for JP Kobryn
Date: Thu,  6 Aug 2026 18:02:26 -0700
Message-ID: <20260807010226.8995-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5D0C2140005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 6niw65f5qk76woahjydnkgibhiwppboh
X-HE-Tag: 1786064609-345708
X-HE-Meta: U2FsdGVkX1/3EYBuvnDfObIO92/3ZnzjtYtoPmiBvJBNZh93fzXZ664rqKDrQF0qwrnkpOzXP607OdxfUwlHgIWsdI207p9cILEOl3LM8t5YsJgozTrHjYNRj4bMud/592q2ZnmczIvlrBpNkW0kn5htDECN1tosd/xVQ16cJIUd78a1rDdkXuErYuB5maYFspw9b5MuqJFrtzQ/bfvEoCDaJHHJxK0D4Z6NPmrMNuXLbVjUS8NIBJ7EJ+1lJwuu/UuIls5Y/Br3WzKH0NRQ5T4AQ7eXi5+T9WSl1A80mwvesgv64io6siDT7VZP7QEAn182GpD5/7nNr0A5U5ev/gvGTlcIbg+rFWcemq8qdxr2F0pVVDUZU4M9oe7qJW25/XjXyIKHFxvoBLRCfESy8aoqNJT0OJ2ySIO+DHzt5MC06pxXSsKII0T8tuLUuT6VHOw44XKi76tqtPiutOR8EC4qIkE79FiX66LQUU0wBc4caaiQb02ENJzDND086+8HNvK91ALunFveE0Bc9uf6V9dhW/1lQr8vYmxjAt5ttCcRiOeauJtnSi7RoAyMxyxesxZR7lh1+PD6PycCd7J1P1+QZ0G+h8mdxFl27BJUPlgHEF0/JepmCFTcipfgWaP1QAjO/FVI2/yR2w+09353t4Cr2PpGD6YdFRziFYiCr7rAhS91kmOgo+YjTeCSJOyXw1aJW9YfJI1zEqyJCBYZpDdnvQpGD1JQV5+zY0uGqCSwOZRkmN9aEq9TxSXsKb3ESPaFinJi3wLXksxpG851QknlQi8NxyuyRLbPHAAmnxKj9T2VBW+EXjmr7k73QbuXNG7N1pZXv8EbJJvquPTmqRlKRmfuwmkR0DW6J61gFMl7EHxMBcoydrXUcYnADiSLZyRPd7hoOC6dwKVqTs6ccst+0Eihf/v2QCqiTCAvnHyE2Tx+L1X8j+GPOygR9+YoUwjsIjAKZY1fBYfGZVS
 jzd2Vtrn
 m1lfi46g2n6OBX2MT4iRpbNqxtmhJypZfSgG4p5Ykc3M11r9FT5rY2nhk645kub0ua6EZsfNfcAUNIgfQi9PT0PbC8Hf+CNI5PpjFIEIbLGFbDO11aEjYoDAgU4XikHrDsoXoRUDWlgdj5qCnJJdnmmPRROyr3AkojiI7M9gJvjggL8H58gpRgfmFTwdN/3o1gj1r5KYaacZjKlgME+2Aj/NVB9MSoTKHnImnA1XU2iruAYtO4eZh98c6JBXEJuOhLEEmdcJYC53lspUQS3zL0WLWUH79jP2veoTBc4G1Vu+cNmDhtaFWDWVkW0i8HyWHmZrJQJqAy37CTSjVuEP3Om1y6VJYwRp+TOjMWcLcCcKDoluffVzJP1atNBGaS+hyTU4zt9CkW+79Sl1bKWELsMpdruUUOMpNNWSIxFK5jTKMRevTvR8m6GsYIxZi97HIMiwLMYfUDy1b8Z96tcz20b+3WZYQxQAOPOrANRm11K+cXMebRXggWc+el+qTg6gOWxUrEDOQ7kasWT/UIlQTVpOiDxXwY4Wk9wRO/A4rE2Ezv/vnA188l7fUNrZelldld8iZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Switch to my linux.dev address and add previous one to mailmap.

Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
---
 .mailmap    | 1 +
 MAINTAINERS | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/.mailmap b/.mailmap
index 01453c5e1ab4..52cde9c10c28 100644
--- a/.mailmap
+++ b/.mailmap
@@ -458,6 +458,7 @@ Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com> <jorge.ramirez-ortiz@linaro
 Josh Poimboeuf <jpoimboe@kernel.org> <jpoimboe@redhat.com>
 Josh Poimboeuf <jpoimboe@kernel.org> <jpoimboe@us.ibm.com>
 Jouni Malinen <quic_jouni@quicinc.com> <jouni@codeaurora.org>
+JP Kobryn <jp.kobryn@linux.dev> <inwardvessel@gmail.com>
 Juha Yrjola <at solidboot.com>
 Juha Yrjola <juha.yrjola@nokia.com>
 Juha Yrjola <juha.yrjola@solidboot.com>
diff --git a/MAINTAINERS b/MAINTAINERS
index cfee5d47b214..2fd28489c4c0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4973,7 +4973,7 @@ F:	tools/lib/bpf/
 
 BPF [MEMORY MANAGEMENT EXTENSIONS]
 M:	Roman Gushchin <roman.gushchin@linux.dev>
-M:	JP Kobryn <inwardvessel@gmail.com>
+M:	JP Kobryn <jp.kobryn@linux.dev>
 M:	Shakeel Butt <shakeel.butt@linux.dev>
 L:	bpf@vger.kernel.org
 L:	linux-mm@kvack.org
-- 
2.55.0


