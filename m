Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6279CA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 08:16:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B05B16B0088; Thu,  1 Oct 2026 04:16:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB6D36B008A; Thu,  1 Oct 2026 04:16:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 980DA6B0099; Thu,  1 Oct 2026 04:16:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 76ADF6B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 04:16:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E89A916033A
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:16:19 +0000 (UTC)
X-FDA: 85273350078.08.F190F5C
Received: from mta1.migadu.com (out-241.mta1.migadu.com [95.215.58.241])
	by imf24.hostedemail.com (Postfix) with ESMTP id 782F7180002
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:16:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=etmsx21B;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.241 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790842578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NVNH6PsV6AOle0z5p76anynNzDjhC7/VHU1ggyQ2WV0=;
	b=pf8O7xSk4jYA0lonbGVLYxG19r+up46K6z4/EFeHdF4mZYEBSmUB2Q3OjxR4lkuM3qjwoA
	B9idT3wZQVmWb8RgsHHZ+MAtM77Bbo9zGwFHri7/yAwApuHa2hy+zZU45CSV6xwXJxKiQk
	kjlk8wC0oCZCtSLapBRAnMdAGxqFZ1c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790842578;
	b=nUoUTpB6bnkcA5xDJqQsRwU9c2SwICvlowuxdHr18DeU3pqbdFcB6jyxRn0fQ2Xv3MwqDa
	b9SwK2BxnYtITTLtoFI/7R723E1q4qzIcWmGa4jm+q/hbnDc/BefNvMXu/jAn6QUAo5ZMd
	r45hRNMieEReJrnsKDqL8THnVQGbS5A=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=etmsx21B;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.241 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=c+DPVphSAp7/zj1M/w64+ydC3uV12W1BTIYcaSRdGYA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790842570; v=1; x=1791447370;
 b=etmsx21B3p9TDxz9Zs7sS1mQ0e8Q9g/SOC6YsJrQvtJpHECx2QiB4FjodfhWMjjyInSi+bzj
 XnoG1DQaE9RLslbz84HCTMxUJSVb1mItgSnaS1kRLOOKx8Hvm7c5sqJBRJDKMy/uZuv2ccWccmq
 LYmMnemxq/S7igFuXnFC1/f4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id de19fbd9b491b7ab;
	Thu, 01 Oct 2026 08:16:10 +0000
X-Mizu-Trace-ID: de19fbd9b491b7ab
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: dave.hansen@linux.intel.com
Cc: luto@kernel.org,
	peterz@infradead.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	muchun.song@linux.dev,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH 1/1] x86/mm: fix spurious warning on __add_pages() failure
Date: Thu,  1 Oct 2026 16:15:55 +0800
Message-ID: <20261001081555.35485-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 782F7180002
X-Stat-Signature: jnk38ph11edxci1qhb3nptbye7gmnbmc
X-HE-Tag: 1790842575-302235
X-HE-Meta: U2FsdGVkX18qB3TWo8lmLKukc4s/qJs4z/hV5u9hm/O8BrHul565ftAsAGmmC6mk0C8SHc6zw5XiP9Oo9F4fVTStMtWFXcFLUow5APtV/cUeeFJ86yIe03Ku6O11d5GVxfVPJQjBNfpO5XpHI00GjgiwbjFfseYqFtsCGuE5Plb2mLQSsrAZMrYaaPYW+LYhSYorqEenHdkueaE7A3bMN1fjB27Q8DY5rDKJw5eHGV+X1MD7xK6jE91LBC36BkDx6LIaDbilsmsA9ChUjyBSyvdXvzAvr3JNateXHYwwIZjdiz1zjkYSJCNj7f9cXdCrnQNYQ60CS4H4WKth/5E2EdDezePpWCD+z13lNFFqX8tph9XYsImpHj9iqac9Tw9xMLPMPKeU7H8eoyZVhmdFFcJ6UuzBTlr9/7XN3zgojPnYtzeu/YZ3rYGD1DVKWfjwEGD8drtTBJaCX2UtPiWeGWMeFLwmznDwTkenxig8ztuQfigb3fwifOg2HKDNm3grkMjt+cTiwx+8eg3c8GDHrATZgtLvcrMikAl+F8U/BI5kv4wR5W/lBqs8AiNfUEQBGP8jGnYPFZrgCrk8ehV47kXdnPbi6QW2IE3yD52yX2OUgko5wn+1VSmcVmraZFhbs1rd4iCW/umATEI8TyEWa8VG86KbEhomadYVGRqBKYwaO1F5Y+hBRAJjB8m0RpiTQsVnSZzhqdPvx7DL1YotYCKOuyjg32NYFg/jJnp37edrcMrBYXgpDl3qol4VVIHdwTuLx2OPFFhbCyq8gnlqa/rfo43Qh09My7cpRseDLM2OZSS0oFd6rTwshSaZBnUU9V2nEjfjdVAIRTZzAy4kDuHSlltv3H5MGkmmvEkj3B4aA5q6vnvn6hDL+ye4Aal/vdG4Et1wjDzp0MNAhOglzLG2QsiWPmt/g0i7XVa/BDB7SbbY8l2JaDBw+2PvJMlNAQT3E//q6vblf0Muov8
 k5ffPUKP
 mwDFlAJjHULXhrs5LPlqsWsZxKtIczR4BQ22v8ZbGOU4JEtVGR7oAsTA42C0C2uRhrXV1b/3V4QZaZbtoB0irAjn7Dc5r9Ezbku5pgXqOSo7L/P/eV9tBIYi/MJoMi6JFzV2wqVyMG4AVTwBGWWDwakJQkcZjKieXPSUKR/U3PdsFj+KAH+42VdwJzAfpNf9B5GIRoKD80WGnpgBmg7XBcFaVWoM9atNKneuyzT/Mcv7OtFHLqCW6SHrDjIcV7t/mTnZREVv2xt0xqXgl6yqqm2LjczC1pHj5Cw3ZOrt83fpuf1c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__add_pages() can fail if we run out of memory. The caller already
handles that, so we shouldn't WARN_ON_ONCE() just because an allocation
failed.

Let's return the error instead, and only update the end-of-memory
variables after __add_pages() succeeds.

Fixes: 10f22dde556d ("x86: arch/x86/mm/init_64.c printk fixes")
Reported-by: David Hildenbrand <david@kernel.org>
Link: https://lore.kernel.org/all/d4fac8af-fd71-47a2-bfe9-3c6559b92209@kernel.org/
Suggested-by: Muchun Song <muchun.song@linux.dev>
Link: https://lore.kernel.org/all/203892F4-B04A-4F69-A1B3-DC1619176C67@linux.dev/
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 arch/x86/mm/init_64.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 70e682180291a..8b6d86fb5a42e 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -970,7 +970,8 @@ int add_pages(int nid, unsigned long start_pfn, unsigned long nr_pages,
 		return -ERANGE;
 
 	ret = __add_pages(nid, start_pfn, nr_pages, params);
-	WARN_ON_ONCE(ret);
+	if (ret)
+		return ret;
 
 	/*
 	 * Special case: add_pages() is called by memremap_pages() for adding device
-- 
2.49.0


