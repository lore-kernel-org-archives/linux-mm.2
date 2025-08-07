Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA64CC87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 20:04:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57BCE8E0002; Thu,  7 Aug 2025 16:04:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 553C08E0001; Thu,  7 Aug 2025 16:04:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 490A88E0002; Thu,  7 Aug 2025 16:04:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 37C608E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 16:04:25 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B183B1DE4BA
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 20:04:24 +0000 (UTC)
X-FDA: 83751038448.09.93FED8F
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf13.hostedemail.com (Postfix) with ESMTP id F086320003
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 20:04:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CRgItLz5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3xQaVaAYKCHIikhUdRWeeWbU.SecbYdkn-ccalQSa.ehW@flex--surenb.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3xQaVaAYKCHIikhUdRWeeWbU.SecbYdkn-ccalQSa.ehW@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754597063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=LopBZLPomTxRQOxqmq+ignoUy2OT7BDqSe/zG/uSirI=;
	b=CYIg3Wl8RP1AExB8uYNx8rhl2XEue9L5fFlxHuObca44OF/SvtpHrmJygyHkjtyqTZT6gh
	q6BPy5SrN69UoRnGNOS4VxhZx8VZm69gpG/SeqCRT9SUETSOzOkTSNIn1/ADwfSYD57QBr
	VXbpUY9ExFsmGMQCswQP6RZ7QLTg4+k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754597063; a=rsa-sha256;
	cv=none;
	b=fQNrly3F0HGhFF8FkTzmQqf71yeXC2adwTd+5lhSl1xvreHaWneMwBWl7iXifcCIqA+1kh
	e4eQHiqoqmkPRNCkuVMM6SvmlFK9RrZxoNVrCVpx4wOSY42Bfsa7ogCTYlvfT2hJu9thww
	NQpbJZvXEJAf6NqDL3m+SxqwSzxHpEM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CRgItLz5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3xQaVaAYKCHIikhUdRWeeWbU.SecbYdkn-ccalQSa.ehW@flex--surenb.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3xQaVaAYKCHIikhUdRWeeWbU.SecbYdkn-ccalQSa.ehW@flex--surenb.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b38d8ee46a5so1492881a12.1
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 13:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754597062; x=1755201862; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LopBZLPomTxRQOxqmq+ignoUy2OT7BDqSe/zG/uSirI=;
        b=CRgItLz5vzlRTsTcP/9yErWUW9wb+KFbEuBYl94BZOSG3pc4Hx82gbVDC5ZH3QcQwJ
         2/SzdRwlTq0Bf64MpTV/xBrUGRWpWT5Kxa2T3nGntQCy+Zwr5QDcrUhdXZxTmiJ/quea
         D7bYR0Em1YuN4uZXOQ7LQeuG5GvsCeuzPlTuP5feD7toq4Xl/V71UTihUBPAfqfRU8UQ
         +HE17D4Bg9CTOYHF1hHydafbK7qt7YXHugIIR8w3n6fShLKw+c1cnca8eYkhayhACLAV
         W0B9hsjbv/V/Ksip9YnPlJirBHrIWWyJ6n7SB2+FO61ijcQpZ/k44eYcc3MwwMDpw0oN
         snyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754597062; x=1755201862;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LopBZLPomTxRQOxqmq+ignoUy2OT7BDqSe/zG/uSirI=;
        b=Z1gtG4sQ13uDtJvmC3hUGuHAZGhJMnjf70xIJoyFq/jdHHdD7TZjuGmJZpUOdkEAAt
         xtmcjivXH69KVWw72kWYVCVnw9rouL93o/GJYsh+WyRqbX2MgQoDE3ULH4iddGWbINAF
         WzZgZRetpiBEp2ayKzSzyh8CzKPKGDihnl4WmSdY9EseP1rkkc+lwK5VpxTeM2X6+5kp
         9NzR6BV02pVOe0vXJjLSFnz0Zx9aMYyzXxDjsHidubAHcGIJFJeCLgy2/K2yDrtxqad0
         lzbQ2OweX9+Del8QmLFl860gN7Qq1JjSgCrWEfv615vl4bYjaXdeMu3+yBKWqwQJ946b
         Gjew==
X-Forwarded-Encrypted: i=1; AJvYcCXARE/o6v+3dEi98EC+LS2OeYVefP4bw8wLy/db7SZmj8ILl2HwWQ8sb8CfIE+L+v1hqPevgZmURg==@kvack.org
X-Gm-Message-State: AOJu0Yy0EuGaWx0OfyxFdqll74/WjuyR0hZln49LPlnh02AQtCCFX+JH
	y6OFIL1uzHgfKeJ9IpYU40SxXBTC6Pzr8Gce4QM/7Me7f6XgQI6kjBMSXjVk4O6Rp4gQEC2yd7e
	NzIgkkw==
X-Google-Smtp-Source: AGHT+IFfxdE58fnJSmEe7IBG3NEKzHhTu/Wj771qmKF+e/CxQGVaBBcd11vmFgPtdAqEdHyAx5FA9bsYdtI=
X-Received: from pfsy42.prod.google.com ([2002:a05:6a00:3aa:b0:76b:dec5:1cb3])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a128:b0:23d:e6ec:5410
 with SMTP id adf61e73a8af0-240556a77cemr188540637.17.1754597061631; Thu, 07
 Aug 2025 13:04:21 -0700 (PDT)
Date: Thu,  7 Aug 2025 13:04:18 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.703.g449372360f-goog
Message-ID: <20250807200418.1963585-1-surenb@google.com>
Subject: [PATCH v5 1/1] userfaultfd: fix a crash in UFFDIO_MOVE when PMD is a
 migration entry
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: peterx@redhat.com, david@redhat.com, aarcange@redhat.com, 
	lokeshgidra@google.com, surenb@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: F086320003
X-Stat-Signature: mcnbcie9ru77ysz4ry56oakcwezkfs37
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754597062-584087
X-HE-Meta: U2FsdGVkX1/0+y3+23TwLHrZk11Pkp2F4EyQwgpin++91eGSPFpkluISx1ePb6z+MSH4qGlZxIQKea01PgrBRMX9bHZ65msAMXN8chzM0DvpW96Ufu2DSjJWNh7KvCh67vGZhUth5ABaK2R8KhfOHUQGcaLJ3+8vQ5c5PZycOPuzLVHF8KA17uQDjbjr8FJUtuw3/7Y7lfZlF3sT8BEJs0BdbXe+gGh1G0PydsS+UNiA3h1ylkwAxw5hn1SuaHHqYNf8xFRHZwC7BUAIL+zC+RA9PXRieVpyUqfY8TtjZeFdR7Q6xaql7N752GvjkaLLEsUhrHWw/+PtPxz4CR6yIrfC1Klsqu4XJw1bq0ScAyReZTXHNz+Ey7xN+QikUeD+Q0jiMUnKirG3U67dGvZpg9cwEydrfA5EozNYUzGtMoXU9sy96HST2T9ShDy3+pXW3Pmb3k70na1HwxxR9VbIjyLFislU+/VlX5nSgEHc2jxE9lmUSDN0Kktt+w+Sr34IN70jGWSBgxkh0aCcQeacZBH2UsR6aflMRi5ULio9PGgFbDF8qRNB5eNvqeJ/wQsx5XfaO2jU1inIkVL+iT2tPaDf+CtmhztGFFkNDfW04Igxtjcmk8F9RTEhMG5cduILqAstkyg3YJhwe6w6raqSWddJFBAkLMvDWoRKqGHSv04vajX0ZDtZ5vFtubIvWlMBK4Cyf2ZJJPbW8Z7nV3PY1oZjYTL5FFu0H+4BzGrHdxJ9eC1nw6s93FU3RjRaplTo5Ewi4Dm+POag/IWkeconGXOow4E/tpCbEDLbUEyDBzY53dNdJM11CdpG4vNAah+3AF7+F5rxZQ8nGhH9VtxpWMY3kGKOSFxxAgq/JilWqaaE1xqGivkcCndsgD2knCdmoZmJPGQE7CImCGeNmqiFXGP/M3spCH2nFeNl/gmQPMjtTF//HRBZV2BtWYj88Nw0FRz3mv6w20NT0G3cV/m
 NpyJYuus
 yA+zrl1NO0djO33/XFifTcTQAlYvMoAvBXimYGb9qWf2m23gpgf+ggJFBZwuRgCon/9eaOUg6HDpQ1wSyqy66ZEQtJT6eGXbnwNgZQkDS5TxJTl3LAHEg1T3Hl2Uzhs5RzlUt1glopR88YTL5+SjrKbfp66PPnWSmW/oUdONsvB166WUuD2RvQNtcAxCLWFAPLFwZNh9iFSTa/MK3M/1dH7SO0Yeaod/Dn/brGa8Oktxgaw86o9R85R21yNP5a6wgsK8seLTIODWH7KVyYr/1O+F1JBGnMYWEmKlt3+BUGzikEcksDfzek5g/1psktp9w1Ns3kVFs7Z7IE9VotOBO3V0WjT6S0dE4qZcS+kV32+KoglMXu0o2odakznT2xv6j1K/lncbb+Cfpk6Bl4kogQMZ3Eq+tQleghrWHNnGSvP+s/bfpC063vTlPYe7asU3X2mEb8kwXfctGworBWjdOU6TrI5EcMKIYFmUlQpZt4B1Xvq9zoFM0cKduupWGSW2Eq8AYwWDEWf4KKNzRuuSx9Pl7Dxe/sXlgq1n9CcwqaryPxonUDkOarglrHzekZvjg2PVzduhq0HIfxBpVz3CkdZdgpQABD6Am6uhEf25r6ryBwzZRNmVQfckTYtabL/Cj5hSj85Z0uxwpxtuNLfQ4GnPSHbtvmbWCi5Km6xXn2ew5+EfLCeGTx5+xWSbMwy7ABRsxVn222sLPfsnaoW34hQRpZFSM35GR972aL8oiXLBX03eUpVIRFXediZOAwyXBIvlRckqAgZMB1/td7W52rTXayj6r3f+3FLYUL48pZhbqPUQK/3A79KoBtlL0i3oG3bYYz7cm9MUO+0CkkgddI6DaHpraMQGPslR8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When UFFDIO_MOVE encounters a migration PMD entry, it proceeds with
obtaining a folio and accessing it even though the entry is swp_entry_t.
Add the missing check and let split_huge_pmd() handle migration entries.
While at it also remove unnecessary folio check.

Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0050.GAE@google.com/
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: stable@vger.kernel.org
---
Applies to mm-unstable after reverting older v4 [1] version.

Changes since v4 [1]
- Removed extra folio check, per David Hildenbrand

[1] https://lore.kernel.org/all/20250806220022.926763-1-surenb@google.com/

 mm/userfaultfd.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 5431c9dd7fd7..aefdf3a812a1 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1826,13 +1826,16 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 			/* Check if we can move the pmd without splitting it. */
 			if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
 			    !pmd_none(dst_pmdval)) {
-				struct folio *folio = pmd_folio(*src_pmd);
-
-				if (!folio || (!is_huge_zero_folio(folio) &&
-					       !PageAnonExclusive(&folio->page))) {
-					spin_unlock(ptl);
-					err = -EBUSY;
-					break;
+				/* Can be a migration entry */
+				if (pmd_present(*src_pmd)) {
+					struct folio *folio = pmd_folio(*src_pmd);
+
+					if (!is_huge_zero_folio(folio) &&
+					    !PageAnonExclusive(&folio->page)) {
+						spin_unlock(ptl);
+						err = -EBUSY;
+						break;
+					}
 				}
 
 				spin_unlock(ptl);
-- 
2.50.1.703.g449372360f-goog


