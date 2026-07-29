Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 333EFC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 22:50:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E51CC6B0088; Wed, 29 Jul 2026 18:49:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E01B06B008A; Wed, 29 Jul 2026 18:49:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF23E6B008C; Wed, 29 Jul 2026 18:49:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9BDAC6B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 18:49:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 11512807F7
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 22:49:58 +0000 (UTC)
X-FDA: 85043308476.02.356FCF8
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6AC481C0007
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 22:49:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PBUCLa2u;
	spf=pass (imf21.hostedemail.com: domain of 3k4Nqag0KCJ489FGQFCI98N8REMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--abhishekbapat.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3k4Nqag0KCJ489FGQFCI98N8REMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785365396;
	b=AJR2A/qEn4t6YX8c15CviLrodggQlxTl0IRVJYE32t00FfPK7cgCgmwSo8JF2ASzd4pRwg
	BRQFCQZU8hvdgxqVD4uHJE50tkVv3K83y7vFJybP4RcnX4+TsPYqcoct4N7dxVSmkUHbgA
	KUic4cundI9Z9Dg8Ruib8KyXaKQzlbQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PBUCLa2u;
	spf=pass (imf21.hostedemail.com: domain of 3k4Nqag0KCJ489FGQFCI98N8REMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--abhishekbapat.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3k4Nqag0KCJ489FGQFCI98N8REMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785365396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=XA4rwawrli+94tpkczW+40qb86Gz6+GTpUDA09FX8N0=;
	b=2V52ra0oUigsOyAluvQGj32CkVNw4er0oU8FTy4gad4npupWPky02zuJK7ykQX0wDqzbhd
	kUmqWtSm8ILqqI1XI/TQTHZkA0mD79+M3p3Z+2+KBoGCtEl5RgIa2Z34a7P7PMYWQwqdoU
	YKOTu09I4GENyCXwmpKqyNMOMjah8Rk=
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38f97b3f853so357587a91.3
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 15:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785365395; x=1785970195; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XA4rwawrli+94tpkczW+40qb86Gz6+GTpUDA09FX8N0=;
        b=PBUCLa2uNHEY118pYD10R1VfrB75OWfWD8FYSIb+rv3x/lpgq9PfT8HeiLTan6+tjF
         0X4iS1W8YpNAvt/zRClSqq2qMLWbavnCoEFuWfdIkQZDYuTO+xlyZMPlSMz8OpxHoEfS
         5x1dqebgkSWA0kwhxM3QyrcWR34r/3wFa0huUKMxA7lIDpdePlK1QmmmzA/7l68VIo/8
         kJ+i/0OqOyUMKh70riCA3ZDnOLogT4KOQmWtuestF/Ygopl/Eva29lbdDCEwpiE1GU/Q
         X/56NhDO37Grpz0ORfwi43HKUy/g0dvqrgqRTcBfPULcPozrmvi26y/EQ3mLq5gc50Nh
         9wIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785365395; x=1785970195;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XA4rwawrli+94tpkczW+40qb86Gz6+GTpUDA09FX8N0=;
        b=Fl+QPzL6Q1xDGgIKbYnJWx67zpp8CHySKpTRWpa0oG1j8npVhgO5UwZPPzlsnskrYy
         BQLcMVicbHDwZjF2m+T0M7mqHMWW8lVhJMUdyRCvykXy3E3Z4ae25M+T0I9QDFzJdf+L
         yO7zYcGM93sG5v8H+OGbvP1Enq7XcA9upBlikebuvKikGe8lJqq3Ub0LEafh+Qxb0Dre
         MZDD5pkwmPE5luta7VzAzGLoHucHUfIDvQpynjHv02Lktvr4wL2oZOHZsBi+oE/JBRbT
         b46wpiY7VO3lnndbW51cfDdIn06pu6aDSGu0ytJQw75J3TclAkkmO8ckkO46dCRb7S8J
         7lVw==
X-Forwarded-Encrypted: i=1; AHgh+Rr06b4Whn4f3VZ6jn60SZ+iYaordZYX2zwASjVEoTSflrGt1DwkSu0iG8joRczwf4iNCSsDJ9CzCw==@kvack.org
X-Gm-Message-State: AOJu0YyiefPYPbJdcdg4gAjjJOr09bv7UlZKUF4VA3uarIwfSFShH+wx
	VHAhWmSVFiZsM0vG+md/7ziZfVrCdSFdDt3g41cm0jIhIlQL3y0VyldtbhieBejo2tZNCjWnb93
	2geXL2ODjIxJ233lKtJI60lfPULV2nlyD2A==
X-Received: from dybkb41.prod.google.com ([2002:a05:7301:38a9:b0:314:f46f:997e])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:e18d:b0:38e:4482:ab15 with SMTP id 98e67ed59e1d1-38f9bece336mr158826a91.22.1785365395013;
 Wed, 29 Jul 2026 15:49:55 -0700 (PDT)
Date: Wed, 29 Jul 2026 22:49:52 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <2614a3a2f5cb11b63e3cacdcc8ab20a0fe7ae972.1785365110.git.abhishekbapat@google.com>
Subject: [PATCH] alloc_tag: expose profiling and compression states in /proc/allocinfo
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Hao Ge <hao.ge@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6AC481C0007
X-Stat-Signature: bxazknbkd5a6guez1g8ii8rdoq748mrs
X-Rspam-User: 
X-HE-Tag: 1785365396-90968
X-HE-Meta: U2FsdGVkX1/vM2p11XoRSk/TcVQRZMiVR6LrVZdbf+RZPowz91VWQUDZo1CKW3ADpulEyfv1kg7yWbUcQJWsKb8GZG3h7Fpxy1gYZJTz0anpHN98Sy3e0qKAtEfl5tZSMF1NsLwQJT1HqjBh5YEXScpT601iTrNLCBXBbOmAkGpbWQLz/gJpjv3sJ946w8uPuyegUvkCNP2+IOSjl5UI/veIXfULQN2AUTRkj2+KuphR5NU3xsS+Bf/aqLibKzir1LbLmzl886bCESALkluc9BjRY7ZkMsk1S9eo2usDwIbOTgtosCYwgTbnLVikHJoMV6LhRF033Pm17KI/NoRQGEciRMrVEFVfVO5yyUL/7mOKPyodEUCxtcBgMMZvsDAozMZrCyhfnv1nGHGuUliKLejJttOIO0Co9StugepPIg4cpHi1y0BxeEm/REo0ghI6h73khBejocG8k3wockdGmV2Bxr5It+xnhZHCgtTwmY5OwWWSVkvaBbOZVXmEmYH1AJo4HFh0LBWMP7ya//FIHuXPmnM6i0q1k1OYoKFyfANVRj74d4Z6N6K6b67K3kaUS1gq8B6ktI/N2elw+bWojGfNKyaihfGEJbEWlrv2WUCoYvboOh5uVl+RAsV+j+ybCaKaLBS22npRSoHvybH9kiDC14n4Fa81RY+Zx6D4O5UVn5X56aZGRn359/GVB7DuXQDYocQsBJXLtxePG3wy27JTpul2zvvKYlsCF61bQv6NVvjSRns1hIFvHZe/WSUqRUcolWu1boowfsOhIufTNJwHKvUDFtp2v+DwqXMmOK/zflT0XUXWjp9OIBIbhNf1N6KEGRAWsnlbKZChLsS99vMLt2wmNLsLfNh4nZXpSkfoyK4/Vn6YAq+8I8MyiWyC+uQ6NivxxT6DGsUl+YDumVqzUPquUYW/NZ9rnm1blZEyboe0WqMtzUpVu3rSSLoEV1XxQt4HMy872KlS+bL
 cu8DcNqe
 EmHJ+uBDyDHJN+8wpu6Kxkvy+Z2mbbU1piykQfzfLmA18cYUzUsm5v4R5AU7tEujL3DcDDZfAj7jMF/Ali9z5sq2+z7xrZ5VVCs61aMfkpiyIRujKSp+uVIo/ZBsHCx7jVLi28Ofp0LF8uxtCcO686rzJq07iwe2Sj8p9h3HmbLkpcqqolChPD2rxHvejJFq16Yumi5f4N/LI29rlC+6WoIpmyTH98kZNKMijRApuwPpaCqC/RizfA3biGEXX1x+oNQ/pm5b/wspHKzrw6u7RlAzvk9xw1C1WQw85nYkJISCsGKLfNlztLiRur9LOfg/JE1gbG2XqSaWMVDTqywbZS3nJfr4HegzASOXT/rNUu/5bo/0OfgI1Pl1rhRNOLm3E1zWsarl1HJe9TtgbxI0x1cizy4ADm340CbzU6396J4cnXlO+H9gL5SMHkoCEvCpLM0e7E0Y1Ev9xjPWHG2TLNapqMabYk4LVMQ/WkHoPxmAQGZHhvwKAhM/JZ/LUs7MOTfd3+DyRdoucUBfu8UxAojjxRqCso1RwtzX0i2VFWa7ebtvXiTPRKq0kb7BqLQheXYU6ULfZkfJgOgpiixwLfq157kT/evo+qfwXEdXAkND7Q/rskZ9Th9w+c0L2vippWGZ2tmaODyM91rUoQ6OygDbJBWcDTIG74GMEPUztEXSmUuY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, userspace has limited visibility into the exact active
runtime state of memory allocation profiling and its page extension
compression ('sysctl.vm.mem_profiling={0|1|never}[,compressed]').

While reading the sysctl provides basic on/off status, it is currently
impossible for userspace to natively determine whether page-tag
compression was successfully enabled without scraping dmesg boot logs.
Furthermore, since /proc/allocinfo remains in the procfs filesystem even
after profiling is dynamically disabled at runtime, simply checking for
the file's presence does not reliably indicate if the allocation
tracking hooks are actively running.

Resolve this ambiguity by appending the active state directly into the
header of /proc/allocinfo.

Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
---
 mm/alloc_tag.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index 52aece27b00e..89ec2c6ce57a 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -108,7 +108,11 @@ static void allocinfo_stop(struct seq_file *m, void *arg)
 static void print_allocinfo_header(struct seq_buf *buf)
 {
 	/* Output format version, so we can change it. */
-	seq_buf_printf(buf, "allocinfo - version: 2.0\n");
+	seq_buf_printf(buf, "allocinfo - version: 2.1\n");
+	seq_buf_printf(buf, "# Profiling: %s\n",
+		       mem_alloc_profiling_enabled() ? "Enabled" : "Disabled");
+	seq_buf_printf(buf, "# Compression: %s\n",
+		       static_key_enabled(&mem_profiling_compressed) ? "Enabled" : "Disabled");
 	seq_buf_printf(buf, "#     <size>  <calls> <tag info>\n");
 }
 

base-commit: c73b725a57f276a3702ca213bde78fca029bc619
-- 
2.55.0.508.g3f0d502094-goog


