Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A03D3CC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 14:45:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A94EA6B0098; Thu, 15 Oct 2026 10:45:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A452C6B0099; Thu, 15 Oct 2026 10:45:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95B8D6B009B; Thu, 15 Oct 2026 10:45:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7086A6B0098
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 10:45:55 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DDB7C40A4E
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:45:54 +0000 (UTC)
X-FDA: 85325135028.22.6F715A6
Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	by imf10.hostedemail.com (Postfix) with ESMTP id A0AE1C0011
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:45:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=iNRZj3tC;
	spf=pass (imf10.hostedemail.com: domain of "prvs=741bae1ce=fparola@amazon.de" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=741bae1ce=fparola@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792075552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cKx/t/+TAF4YjXU23LNleHFcUmfPDixkfS6sn57a3s0=;
	b=XVr6JvDTokaLDhOZA0MWx1AcshtdRFYIM4+B765suGxnAjgtw3xGZFJxFNfr+Xo4IsFDjd
	+/XvWMPfvF4Z13Is2HsNqCnQgT+u4EC8FXx/0pPdqdrJ6rHAR7pxTC82AOJXMYT4V0SQVG
	yeQ29D+hWaiZsoWdVVbG8Sxg+i3KeKQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792075552;
	b=M/E3iziyK+BPxE0ZrFUfLX3VN3KqUg3YMR/tbXyrUbD3tz9dM8th0ANvh68VPzCoXPi+9j
	21yCt8yMueM/aVcOtNcDqTva572NXMSSl+MVutrE3KIedoU6u5SM9AivNtqVAUvNcFY4XA
	TzXWOEwczNTZfzSGqMX8Tef319tkOo8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=iNRZj3tC;
	spf=pass (imf10.hostedemail.com: domain of "prvs=741bae1ce=fparola@amazon.de" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=741bae1ce=fparola@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1792075552; x=1823611552;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cKx/t/+TAF4YjXU23LNleHFcUmfPDixkfS6sn57a3s0=;
  b=iNRZj3tCNHWOVYxDQ0QIPrcJItHvbNX4ubWM+H+ZLm17Jy3L0lOagby8
   d4exk3Lo1pa8ePYkuxUMOtsbSQ3+HXjQiCE7lfD8IDTk6jgG1LcuMYjRS
   EEJq1zKhPtm/SU+PJAhXRVY7RFNtPkyT9ZmLTIMhH4yEQneFhhF/koMnZ
   6mxzO0UVqpXUEdjhmc/ydVJjjd9JdBdzNrrglaIAZF4BV04ggxONzFqDe
   SvzMrm6GGf5FcuaF2q7Tow0ioBHmwa+uBLPOI9uTCaWhjd+iBXB7yJaMf
   6zFjnCOQY+mU0pzP30HXSImNX0ziCLoLwDnt6n+PHQXBQxekQcniCRVIn
   g==;
X-CSE-ConnectionGUID: Q2rGLVgxSuutHEjcu3mgnA==
X-CSE-MsgGUID: neHvo1RPTZ6dKD9HRCQEIw==
X-IronPort-AV: E=Sophos;i="6.27,160,1787011200"; 
   d="scan'208";a="31336690"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2026 14:45:47 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:1486]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.63.90:2525] with esmtp (Farcaster)
 id d05f5ffc-4038-4a23-9a53-19cce5f690fb; Thu, 15 Oct 2026 14:45:46 +0000 (UTC)
X-Farcaster-Flow-ID: d05f5ffc-4038-4a23-9a53-19cce5f690fb
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Thu, 15 Oct 2026 14:45:46 +0000
Received: from dev-dsk-fparola-1b-85ea2014.eu-west-1.amazon.com
 (10.13.236.104) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.53; Thu, 15 Oct 2026
 14:45:44 +0000
From: Federico Parola <fparola@amazon.de>
To: <stable@vger.kernel.org>
CC: Mike Rapoport <rppt@kernel.org>, Pasha Tatashin
	<pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, "Alexander
 Graf" <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>,
	<kexec@lists.infradead.org>, <linux-mm@kvack.org>,
	<nh-open-source@amazon.com>
Subject: [PATCH 6.18.y 2/2] kho: free phys_bits bitmaps using free_page() in __kho_abort()
Date: Thu, 15 Oct 2026 14:45:29 +0000
Message-ID: <20261015144529.76911-3-fparola@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261015144529.76911-1-fparola@amazon.de>
References: <20261015144529.76911-1-fparola@amazon.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.13.236.104]
X-ClientProxiedBy: EX19D031UWA002.ant.amazon.com (10.13.139.96) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Queue-Id: A0AE1C0011
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: btxo48pxjf36bmc5ri1e3d39ntnxezju
X-HE-Tag: 1792075552-164558
X-HE-Meta: U2FsdGVkX18mwBu+cF7RjjaKJcyuK1PLyN7RtlMERMYcnti+rG3Ol0uzf11tTzVkedr7E5oqr2IhjSGXSg4axqeudbI1CIbeLbhc9HPUQPVmfHHgqQtI3PVZIlw/hkxl5P5BvCyZzLUmXFErDjVL2cjq91JV6xZn2HUD48TnsYXYBlC+Pyl9fqIxtB1W8nEelbqnCPUqhywminPhPkBXzWZVoAOX2R7gWAOyXV40CMfoSzBfJJ1ys3puulO0pKUDckI61Uu/90ZItot8nzCrRdx4rgjwSXtd9kaKhTlaZBLojIGiwakg/VRI4ckHpVUEacYxgc+sZ8IStSOvKjDybIvQibL8wJhtGp19NlzmdkZQVrtVAcD3mgKnSkgVpXendsPL4IzYJSVwz+GcTIprJtTZ5FJiT65QwMw1Yri6Z4cNRPye+m+C8l5HkOEy44cFyBh0RePnN+cWuF/6VSwBLsTdMV7lfiT8G+WOl6AoGbtRRJ/s2n1YjJOKkoIV1o6EBFwC4AnuEeZOog4yZHvc0qJqmr8IsZxjNBeWrkrAVr/0FZc5DnR+mnJUR+LQPO7n/7E1uR5mOZg8/yGs+hIF2VAaca5uRjcetZDn0bVuH63KRVcWBldb0SYiGfg1eIm/UXfvmO/oiveKG43BvUlh5gZlUs4jpJHWUsoGFNTLTfAEK8L0l6L/laxUAcErsvyzliGdVCQGYGYlWoJwN6RGOdueYE5kjlB+ZiPKwmHPqIxC4ej1DTcIYdz4bQCo9b/0dG+FBBHfsoIlBg03IuQ+RDiGNWD4PfgJlsBBguw+DTc5L5evaUBQ8W2j1VHZ2X5wUBzYEIjxDYJbg8QcluYsoN5brtw49372k7NhBYf18dsNLBQeeUkxaCTlRIFet1bcHdvxIAxYFqWtJ19nkZ/gkqS16ov5C0AsF/4O9+Izuap7DesUb762TGS2arzBSiM/fKAYhZ6Kuf5KpWDPJM2
 aXFBa6pU
 wtMt4ZjdYw1D1I60vWJH9KX38oy2A+611wUcF557/dQjDCmhqKAwoTYjBVFrSfDpXekZpBNP8ZRcHGvgoKxL4XgENSlfnMhn4U1vCcXFx9gBeTNR+hlj6HvMmOhHkyzYTyB8D8/956l/w3I3vMfM2CV/uX8YhQy4jCw+rH+o6SSGIDpa3410yQjCgE0+uRiugW01f+9Qso7P6Qh5VxVQN8+Bpv+88j8V+XGTnUcNbNitemQ4aDzSwe5knB+FXIZG+k49LSsFeHQl1I1oZWvROVz5A4iiJEUg8fTpVriA2888C5a3X0dnsEtBHwua53l59jGHzpIHKeWkVRrm9d/eZ6mzBvXwYPKLkSEVPONonUQbtf2RPF5rH9B46CWM7QmfCmog81L4V/svZueZUGeROXuagDIhYNEEMgwXK42EwtU84qpTeodmamR5yUyjoQLSoZJv53VKonNRjFutLjLVYVyBfgiOaTfs/6AGLNXVYNErFx4W1zKVBEoEyrAIKaxOgJDmNX7nSLn/8tNvE6cjWjxTkbM35RvjYvit5OCY9qqbiaifIZFHdWfPel3ffePYfg+RnjLHjsItcEnQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit fa759cd75bce ("kho: allocate metadata directly from the buddy
allocator") switched the allocation of preserved memory bitmaps to
get_zeroed_page(), but __kho_abort() still releases them with kfree().
kfree() on a buddy page that is not a large kmalloc allocation hits the
WARN_ON_ONCE() in free_large_kmalloc() and returns without freeing it,
so every aborted finalization leaks all bitmap pages.

Free the bitmaps with free_page() instead.

This is a stable-only patch. Upstream fixed it as a side effect of
commit 99cd2ffac697 ("kho: don't unpreserve memory during abort"), which
removes the tracking teardown from __kho_abort() altogether. That change
builds on commit 36f8f7ef7fd2 ("kho: add interfaces to unpreserve
folios, page ranges, and vmalloc") and commit 70f9133096c8 ("kho: drop
notifiers"). In 6.18.y, KHO users still preserve memory from the
KEXEC_KHO_FINALIZE notifier and have no interface to unpreserve it, so
the teardown on abort is the only way their preservations get dropped.
Backporting that commit would make preservations outlive every abort,
so keep the teardown and fix only the mismatched free.

Fixes: fa759cd75bce ("kho: allocate metadata directly from the buddy allocator")
Signed-off-by: Federico Parola <fparola@amazon.de>
---
 kernel/kexec_handover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 9fe5d14f1ec54..9691f6bc2fba7 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -1054,7 +1054,7 @@ static int __kho_abort(void)
 		unsigned long phys;
 
 		xa_for_each(&physxa->phys_bits, phys, bits)
-			kfree(bits);
+			free_page((unsigned long)bits);
 
 		xa_destroy(&physxa->phys_bits);
 		kfree(physxa);
-- 
2.47.3


