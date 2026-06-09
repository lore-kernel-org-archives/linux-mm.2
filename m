Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB0B3CD8C9D
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 00:49:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 126776B0005; Mon,  8 Jun 2026 20:49:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D7366B0088; Mon,  8 Jun 2026 20:49:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2EF86B008A; Mon,  8 Jun 2026 20:49:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E1BC16B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:49:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8A76116427D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:49:37 +0000 (UTC)
X-FDA: 84858541194.04.AF8E44F
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9E6CD80006
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:49:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=trailofbits.com header.s=google header.b=dB5dgWJz;
	spf=pass (imf30.hostedemail.com: domain of sam.moelius@trailofbits.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=sam.moelius@trailofbits.com;
	dmarc=pass (policy=reject) header.from=trailofbits.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780966175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Y4KsfbPvhSMlGZi3sBd0gWqqCN3u7uRCcXc1rfpSpCY=;
	b=gTOErikF63lHLGjs2HtlLej/TSQ3Iw3DujUDAZUi1M1C7lkmuFI6UMcKngEAYvcnr8iVPQ
	JaoDlnsNl2rAFZ5fTDyD00oazWxdyvFOei/RJrObh6drB62jh9YtIT6+/f4L8C2B27MC3f
	UqEVEC4rYYI2qQUaE/50zPO0H3nq41c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780966175;
	b=bZy+uh5eJ6jaiq55I2vuqBC/iqWQNMxzX28wbP612+RQ1+ti+HtsucPbEWAnJIEMZR9xvA
	BrPCJ9lHmSjGziR9FVrJ3AVd9ogPnAHdg6ySNFaql+NH4PHdkDuqLULSinEWORq+Zz2nxd
	Q2HYCKFxP3pCD06ff+gP7/CyJFrPsKw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=trailofbits.com header.s=google header.b=dB5dgWJz;
	spf=pass (imf30.hostedemail.com: domain of sam.moelius@trailofbits.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=sam.moelius@trailofbits.com;
	dmarc=pass (policy=reject) header.from=trailofbits.com
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-9158643e538so446192985a.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 17:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1780966175; x=1781570975; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Y4KsfbPvhSMlGZi3sBd0gWqqCN3u7uRCcXc1rfpSpCY=;
        b=dB5dgWJzzG5IF0+rOhG9uQDfBO/TqPFyOYuNaJfJMlvFipZS7+wRGXJ5f79qe+xT2O
         ZrT6NtWIjRFSlROMigNk9pnlTslD+gCTikEPSHBIE6iQlLQFE8+4ep9E8Ci9oIBeUefh
         XI9entn92L1itzmqIpPhfk+Uvqv8hLOxuL7i1BaYT6Sg1OZvw70glIDXPCJ8Opa3HShi
         uuYkRtFb1G5SWQn3kFqXBWPZ4KKpdGm5LidQOKj3YapUt0nfrHynVBjE7VDK+H+GX01q
         iTSjnKQDQFrrUgdrZoopFGZeNBu+NsivftNxkvJy0n6GV+TZ3RC/rk40pXroQOckdOAr
         hBew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780966175; x=1781570975;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y4KsfbPvhSMlGZi3sBd0gWqqCN3u7uRCcXc1rfpSpCY=;
        b=GAAjZjRalxVn1v2msKKtFFHlTq2TkCAHYSHMzE2zQk9FJTMDN6v1piavAqjs9NpDUx
         xqiHj8VEA1aYa5zsKvVx4GnCEiNCDRZUzRQTmuJPRJD96s1o03YN7salj3EbLM3vbUan
         0dxQ6rxmL1NNxzYRNDrIz2KwoGSuREmLY8cIANq54zqYw7t4MEnwurJahJ1aJnZqO2CQ
         gXLtW0ztGAW8B0cNH0slfbrPFKYJeAEUtylqvC/qViEm6St1u+CRRhLPxdGveT8rlEPj
         +j62mIaiwbPbQt6Q7TYYuOLpAaVIfQrUQJsL2J+kYsZwnq1uGZyUywlUHctmSkVBwBkv
         rgdA==
X-Forwarded-Encrypted: i=1; AFNElJ9DrOn+/FDgSO++2zG8ikr6KIDIB7kIFRRw8gDz+urSa1PWa8G+/xg2+CFvufhHffDgLYGDIUJcAQ==@kvack.org
X-Gm-Message-State: AOJu0YzTof0+/D5juh0NFffOazPKI8EhklyXRhAz/k7A8lbHc2AWnbbb
	OFzxG87NGA4CjTWvmfgX+HDBIEzHM0zBxkxAkwyEIUjGF1aWZACNajTB29+PMeutdjg=
X-Gm-Gg: Acq92OGG8k2KVDwdNIUkB4rXoKz6EHxE/cFG7xbQbRxgCMKjaz+VlRlnXheHLGWxQ1J
	1LUJ6A6yf5V8MHuX0h6fqJtOCjMHbs1ORxhdfZfDt49XiR6DlcD/4xMkkGUtBICJOzXB2oTJfRP
	eOU4Q/xLSx5uLMr3Qhy7MMpTi8K4IcaCFzRJglbKmnxJf3Ny8dJY5YxL2ey6HLMKFrRqKqe36Sn
	oWrOjQHIVN7IQfbINmoNg378oVoOO2hM78VWJw8yfGYBy3OUCMP9I8uMmgfKZNalT2zGVqaHkBi
	Uyw8vBU3VYGciK8EYRRFoBLcdR544EIUryAlSRn5oxM8yfTeerRS2rMslfn2sAU3nTUGp5r6Sah
	5xohQom9IdJ/uXKkzdLYBG4XeyCQ6fNIZafdvzNghSTEVciBlTeOaHqnOlpHP1RKBxFz1YP5mup
	X2+mz0kQYYmUVGLMi2wp5tsuCONaNHhNoUQwGdsA==
X-Received: by 2002:a05:620a:4886:b0:915:9efe:6dd8 with SMTP id af79cd13be357-915a9db8256mr2803430885a.42.1780966174620;
        Mon, 08 Jun 2026 17:49:34 -0700 (PDT)
Received: from localhost ([161.35.96.86])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-9158a00840dsm2079594685a.1.2026.06.08.17.49.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 17:49:34 -0700 (PDT)
From: Samuel Moelius <sam.moelius@trailofbits.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Samuel Moelius <sam.moelius@trailofbits.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org (open list:MEMORY MANAGEMENT - GUP (GET USER PAGES)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] mm/gup_test: reject wrapped user ranges
Date: Tue,  9 Jun 2026 00:48:15 +0000
Message-ID: <20260609004814.1240586.6294d614ac80.gup-test-range-end-wrap@trailofbits.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9E6CD80006
X-Stat-Signature: q7s4oojamcagzuwhrpqpignc3ju8gy8j
X-HE-Tag: 1780966175-560346
X-HE-Meta: U2FsdGVkX1+ObbYI9vtQgiY7gs4hhsps3zqamLvilcRIJlJD5Eocj5FvT8vT1b0TttvmK3ZYneM6kvWtGS6JzVEtJgqIdeXQDrlfNSAMBXQdibDnUG6+uvf0+/w/qDBcnn8Iv4KGrHLCbezCBaG2fvKitrazPSIIhuXyurevpaUQ2Dy+Zf7sB9FprvwCQDtcKX/OOuTYY7FdanMbrLOEKVirFRP7/5ccULz4jCI9KvTrK+zAso42IZeDAKoqpqY6S0hceuI4NnydBlYtfCBJpE7MPnwd366fC72eAIHQ3HQz7n0o2fAtoA2NHO5OcQ6/L7Y5b7UebfZ+iw/pqA92lmtsBzCc8kN6/nLPUshuzxFWiBtbXk/fyI+U8XuIhawn1hYY4h1g5mcHZYA6Rs3AitWWvObYoax3QYmZ2meTtqgg1PFHQCkQjHkoUrOKDAiSLRxLLR/uKdTSzUPmv3HnRUeE9y/Bquccyt7TavTB39yQDCtps4GpMHT29ioiyIX2zCKh5SXyu5YEnB5dnljhfpy+fHOzFIvak7aOxeLF3Qnh9hrVe98zBcC4Ix+j6ysezJJ73fjv5kT0WUvfoDhnYa0NyMbV3Bc4HjdZ8Q+kay+AhCJtJA6Yx9Yldllt4oxgL2HgJIfqjFxCwQaq/CUUZqRAiCMmq7pnScJmoxh9qGuPRG3l5FCZFc0D1sUM46KB4vzfdovAaCruvEyiL/+sk03Mmlmr4NcGCiZ54/Bt/0e1/3VFSo0+qJHGt8ieRrpphKWMcS1jAWV2a7faM5xvG5CYPTXYuBSIpIQ+WFkI7wJcTbOL/gXeLEyOqVRvLPxBnW19RcUkRNPpXVaZsfDjH1QJYKrx2C0s9dEdRrzVD+2OfadhZTloE2d8tfoYrMvuBURsS4guCO84O0F9eVuy4FOJVe3kVQYbqSGiPSuDtXoThzoy6X1u8tsohgRltbWCKkEnzYSgDJCU2AsaiEQ
 /2c1XSoX
 wajL06yQcdckcctHkL1QxlUNnPQ//HlB/V58FkOLg6F2My/P/YWoK+EmTsTKOwqZYyov5loeCAK83GtXzgxA/om/G2Isyfdd/dBnTZf1NB6LMfgTzjzkal5p+XWOiqPib7QOP9C+uSuIQljlK4+WVVOrgO/Q+bv4J99Ql5LgjKRxVminJtcgVo2ydwkTaMVXoJ34qXj4oEkuVxwnuO7fn8TNe+1pRns5w5jDhMBWfzjlO9xdocheE8FrEBT3hbkGevAwHf8afU0rqt7DgUKVdh95LO9ixT72Ay998wrM0EsXMbsS1BJN3JQ1taY7opd8qQyVlYJDsq3oxCCsvUWrmJ2+Ee+ob1tlUuoZScj+FaE2SaZE0vh2jrrdkUYa7D2bIXsTx4OweDdUAjo4aJ7Tpn5mYKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

gup_test accepts an address and size from the debugfs ioctl and
repeatedly compares against addr + size. If that addition wraps, the
loop can be skipped and the ioctl returns success with size rewritten to
zero.

Compute the end address once with overflow checking and use that checked
end for the loop bounds.

Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
---
 mm/gup_test.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/mm/gup_test.c b/mm/gup_test.c
index 9dd48db897b9..eb4c9cda16ed 100644
--- a/mm/gup_test.c
+++ b/mm/gup_test.c
@@ -105,11 +105,15 @@ static int __gup_test_ioctl(unsigned int cmd,
 	unsigned long i, nr_pages, addr, next;
 	long nr;
 	struct page **pages;
+	unsigned long end;
 	int ret = 0;
 	bool needs_mmap_lock =
 		cmd != GUP_FAST_BENCHMARK && cmd != PIN_FAST_BENCHMARK;
 
-	if (gup->size > ULONG_MAX)
+	if (gup->addr > ULONG_MAX || gup->size > ULONG_MAX)
+		return -EINVAL;
+	if (check_add_overflow((unsigned long)gup->addr,
+			       (unsigned long)gup->size, &end))
 		return -EINVAL;
 
 	nr_pages = gup->size / PAGE_SIZE;
@@ -125,13 +129,13 @@ static int __gup_test_ioctl(unsigned int cmd,
 	i = 0;
 	nr = gup->nr_pages_per_call;
 	start_time = ktime_get();
-	for (addr = gup->addr; addr < gup->addr + gup->size; addr = next) {
+	for (addr = gup->addr; addr < end; addr = next) {
 		if (nr != gup->nr_pages_per_call)
 			break;
 
 		next = addr + nr * PAGE_SIZE;
-		if (next > gup->addr + gup->size) {
-			next = gup->addr + gup->size;
+		if (next > end) {
+			next = end;
 			nr = (next - addr) / PAGE_SIZE;
 		}
 
-- 
2.43.0


