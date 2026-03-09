Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F12A5F3C241
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 12:34:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A9C96B0088; Mon,  9 Mar 2026 08:34:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0578B6B0089; Mon,  9 Mar 2026 08:34:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E98C36B008A; Mon,  9 Mar 2026 08:34:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D8D616B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 08:34:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8AA22140174
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 12:34:57 +0000 (UTC)
X-FDA: 84526469034.28.FACCB05
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1DE6D40012
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 12:34:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aokPU8Bv;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773059696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=os8LJwgTVC15dJZoK2SNHppYxuMj/YeuyOkX7l1pAKs=;
	b=pCa1FdmrpMM/ticEtSITNmn70muz/QhlaT349isGFv2AdcVrHIa8Lxs6NKXeyE1KQ/zSHF
	8Io+42nFJNktkTJjtK+oHLubFRHaP9y2xlkIHSCRMy/4sLumleu4iZ1SYIjoe7Gohl+oQF
	bXFFBERsPzwPsAcwzUtPnj2kGIFVmQQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773059696; a=rsa-sha256;
	cv=none;
	b=udwpllJYpWlRlbcY1fWERByyG6FgT84lcftSxmWCEdX756hfAjsfholxr4YG8AMBXEQ1hO
	tLg0aoIsbNje3ImLLkGwTBLsT3OETYyOIr9qP7n3pyHiSiDNBbbeUkD05FZNSpa+jAuZ3a
	fM31MIeV4Qc7YE+TBsBHzVwOt2i2Z80=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aokPU8Bv;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 42CB5600B0;
	Mon,  9 Mar 2026 12:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF2DC4CEF7;
	Mon,  9 Mar 2026 12:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773059695;
	bh=gAZtsXuVCQZAaWSuJc+3R0a9ehVlq0Y70kTuOfLhCbE=;
	h=From:To:Cc:Subject:Date:From;
	b=aokPU8BvqTGchyuCzIuNeiQ8qP/hrE7iYZZdXhyaNuqAaFkiXwphl6BhDnLOZ7TRN
	 ZJkJlJngDQMyZRE85FpXe8HlO14vh0anff0e6Z++FkX/8o52bE9w8vbh5VCxvivppS
	 R9iSiQDviOzYYPPgDOBH1enVCr5/8v2mSc5c0XGoGoU+DmCxk5vKewHAOwmK/h7J0O
	 AGv7hwbxcMUk0FB1N9lZwaf0dj6kcOdLgv7O2l2fRx9CxwBfwWs9vjt8d/Zyf8NSsf
	 gYCJVnjOYxB/2Ydo3dIBfKFV9cIx0IauaTY8nUOPbg8wvDQVGt5nCYGY5yQag2I6xc
	 81jT83wv7xryQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] kho: make sure preservations do not span multiple NUMA nodes
Date: Mon,  9 Mar 2026 12:34:06 +0000
Message-ID: <20260309123410.382308-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: w4bww755ywfihr7kjehwzi6ppmbmpmbb
X-Rspamd-Queue-Id: 1DE6D40012
X-Rspamd-Server: rspam03
X-HE-Tag: 1773059695-287091
X-HE-Meta: U2FsdGVkX18IW0NmG8T+FzO98LroWQDDUEjDDIHRFqcUTo0mN4EcLhagjVDOk0/87jce6pXcbHac54sNm0MXdlPbOwrNp1pxLr0PK6ua7GSbsTJLykfZq8Vun8ixtSQOy3oxMl31n6mkOkWeqDYpJ1Dmy/sFLP1FVNP8FwcqN/ZCie+uHECkazsXAdYcDgUmTItaJVYsWerq2njY4U020Bd5JdwlZK3HDMoqt6j8w+sSqvEw6m5hTRPqPRADKJHH0FSb/TccR5ppKzwKMYouTk8ye/WTonR6HAIyvjOyTLsKBejayJIGH3BoaaUFo0XsRXiDC0QioViZDz/caCgSga3GcWD0X7XjhwOkVGyZk3Ygn0dx+jWQU9bCuqiwfmK3c0oxDBPYFsEYsDgSQ0lRK/LDCuz12edvVfxGBdIpmdmhiGaSYLpgWb5JRp1i/zip5JpUV97OC/RSFXi7vLcQcsFp/PnfSqAjWE44Wez0uM00UPqZ0r1CRIzXwNkvF02x1Z0JySB3H+HQa++vX8NlwU60vLOHbP/1+N1WhqpTKWG5T5zkR7cD2QKhksmMX6dv1jAwfgiiENC4oMrU9W6uPME8d6OKhdTB32Pgda33LWidkrCHCvAvVm84149kOlmleie3nN80dUiU5/xanN7njtajxpZocumLsJ7aGNbwInj/fWffSPu7rRcu6lNOgxSVH/gnpzXUGqjJZgr7lqjid7+xVADP0tfC9kn5sG+WynM0Rr5MhgMu1E6ltPAKnPp/S0nvsXjAmXZsxntiJbvkCKNywEsSMjNbRTPWznsj1X98bC4RjCS1Klv0htsCI5CVInKoWUjMFw+FwDQ2X7qOQ0tW+LkeL74YAn+qH+sx5HcL0L0lHYj7XEuiZkzLVoJXS31lxTV3EvNEjVxBaVYHUACUU/+a+kW4Se2EOEicLXCQ6voLYoETyt8o77L8tglsmkO5i3SV4MFL8B8ylHP
 c7/D+GIJ
 YqpE8XjjqWTYgGyAHt+IHLQtvtkBgH8XfJGmOFNTG5NbduZKgDfFn5pIzcQlvqB34Zs4q33IvkZyBjNWiZzrxah35a/fqJCj67IiSJsUsS4HN6c94MNrYB0dH48jrSqVXrZPx4j7dRFqMcGhDyL4Aw9B18A33PdXiAZpIPkI7n8E3iDGDblJu5YL0/b1X7C0U20Cfcd7X2oXTghlmVB+3seGIujFLZ51dhc5wlYfby9xBKujEZjmCGaONCOdUHPt/M55YadHwW2WAREyvPeXyTw9I0hH7gjRjZ3oFQe1Ejvnqna5pGTSlW1rfYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

The KHO restoration machinery is not capable of dealing with
preservations that span multiple NUMA nodes. kho_preserve_folio()
guarantees the preservation will only span one NUMA node since folios
can't span multiple nodes.

This leaves kho_preserve_pages(). While semantically
kho_preserve_pages() only deals with 0-order pages, so all preservations
should be single page only, in practice it combines preservations to
higher orders for efficiency. This can result in a preservation spanning
multiple nodes. Break up the preservations into a smaller order if that
happens.

Suggested-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---

Notes:
    Ref: https://lore.kernel.org/linux-mm/CA+CK2bDvaGmfkCPCMWM6gPcd4FfUyD6e5yWE+kNcma1vT3Jw3g@mail.gmail.com/

 kernel/liveupdate/kexec_handover.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index cc68a3692905..bc9bd18294ee 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -869,9 +869,17 @@ int kho_preserve_pages(struct page *page, unsigned long nr_pages)
 	}
 
 	while (pfn < end_pfn) {
-		const unsigned int order =
+		unsigned int order =
 			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
 
+		/*
+		 * Make sure all the pages in a single preservation are in the
+		 * same NUMA node. The restore machinery can not cope with a
+		 * preservation spanning multiple NUMA nodes.
+		 */
+		while (pfn_to_nid(pfn) != pfn_to_nid(pfn + (1UL << order) - 1))
+			order--;
+
 		err = __kho_preserve_order(track, pfn, order);
 		if (err) {
 			failed_pfn = pfn;
-- 
2.53.0.473.g4a7958ca14-goog


