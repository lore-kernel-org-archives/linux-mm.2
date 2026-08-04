Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07570C55838
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 04:21:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FA406B00BB; Tue,  4 Aug 2026 00:21:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 683A86B00BC; Tue,  4 Aug 2026 00:21:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C1236B00BD; Tue,  4 Aug 2026 00:21:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E4DE6B00BB
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:21:30 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C749DA2370
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:21:29 +0000 (UTC)
X-FDA: 85062287898.15.9F7B780
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2D314180009
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:21:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="tM/hYziT";
	spf=pass (imf24.hostedemail.com: domain of 3xmhxagcKCLctcbifmbdlldib.Zljifkru-jjhsXZh.lod@flex--wfelipe.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=3xmhxagcKCLctcbifmbdlldib.Zljifkru-jjhsXZh.lod@flex--wfelipe.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785817288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TR4qhJ/Sx3Yvhb5MktlPGJQjJ+lc6YwHU5a7NNiYmZs=;
	b=AszoMGTt9izxt0Gbjp+HQpkEK1gsRDrQ5GFdYApdLl47P6mIeKYeHVJeORJJzxr9j95UVX
	p1mw7hwFy6dCyUGuHsmNOX1703PbU7zAp1rH8xlvDbG8XqfVQ4Snuu5pm/qrfjacGvsOt1
	5N/oV7wXxY7JjHl5XzcTud+NI7sh7/s=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="tM/hYziT";
	spf=pass (imf24.hostedemail.com: domain of 3xmhxagcKCLctcbifmbdlldib.Zljifkru-jjhsXZh.lod@flex--wfelipe.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=3xmhxagcKCLctcbifmbdlldib.Zljifkru-jjhsXZh.lod@flex--wfelipe.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785817288;
	b=dUc4S1jETyzAcx32XulPHGywSkgK/mj4xdAPrRQq7vyB95woICrcrrzwpCnk8VtAbxL0eI
	QS2mbrZ0mIS/9kfmFz6JJXeFjDAG7WfdUkPwH4GYxLs+Nrr+PuasB1hrbpmum2wwmVJdgN
	/vABT9/L0bmVnz6DTe/b7x2CVqY1YwY=
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-84e048a801dso6227841b3a.3
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 21:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785817287; x=1786422087; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TR4qhJ/Sx3Yvhb5MktlPGJQjJ+lc6YwHU5a7NNiYmZs=;
        b=tM/hYziTtnI30AKOwaW3aXiPLfna6jq72PmM0KWN9etXnJ2tRbdtJ5FLEWgqAlWhBL
         ML//QIY3EXOBXqONSgtORSdexPssgEZyOmVgr0t+lbPTHWKr8c1FrOtMPIQ+gHTlfXot
         /eUZeaQjk3oEm2pG0L8W/hMJyvhrA5Q3Avk6+P15Q79QaIS3rP2aYTcglEHGqDuhlxaM
         3w1qHnpHTW1b3Hm2+tnyXQy1GW2M8/IlIB2KNaC0NLo1dg3pyfERGmsrdj816R2aXr59
         GwQja5UnmGZxTvPk5ob7rkUSXSjecxtWia40Qb/LT1NWp/nlV3zJoh3eA9Hk5GanVypz
         iYMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785817287; x=1786422087;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TR4qhJ/Sx3Yvhb5MktlPGJQjJ+lc6YwHU5a7NNiYmZs=;
        b=odAL+Fw2jQtb0X7wpZ2W9B2NCt5Ax7LRSexCOComnJcucubpix+8k4ZJp6vz3pS8q+
         ddWAiQy/8QWNNzKdPLxOsM2YEYja/1b3WgTQYN5sIuUOWTyIev/LP4CpIikN9c7GoZkK
         2/r5D9VSTNQxELUO1ME8ZASmiEcT3MI2DydCdAnTbrVf/PglUMFFR83uvwsa0xnO1w/2
         JrQZofFJKDzyNJ5xXIOudZcUvGgh2jBVboMiGvBxqkB6aAehYFQtZWSZb7EAWKycWyPt
         rUAo5m4UcTAfbQB2N2vnANtTyKMQnvlnZkIIgdQNAk1zMofEG4h7u33H4KaOfosVQZFg
         KxtQ==
X-Gm-Message-State: AOJu0YyWbny5QvlkW9jbvjVBqxtlSIgKVZJolQI/3pSr9elCEZf4QMQW
	6cvFyKpzVv+bo6eAnnrxOEHcDdXCO2NqYvQ3t1K5HQFOaMJu/V27G9tEIv6fK0DfesVmuhVsJly
	GimUOSVUMJA==
X-Received: from pfks7.prod.google.com ([2002:a05:6a00:1947:b0:848:4f56:7671])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:c82:b0:84a:6540:3389
 with SMTP id d2e1a72fcca58-84ee47f5779mr11550310b3a.10.1785817286673; Mon, 03
 Aug 2026 21:21:26 -0700 (PDT)
Date: Tue,  4 Aug 2026 04:20:45 +0000
In-Reply-To: <20260804042053.56940-1-wfelipe@google.com>
Mime-Version: 1.0
References: <20260804042053.56940-1-wfelipe@google.com>
X-Mailer: git-send-email 2.55.0.571.g244d577d93-goog
Message-ID: <20260804042053.56940-3-wfelipe@google.com>
Subject: [PATCH 2/2] selftests/cgroup: test_zswap: fix implicit unsigned
 promotion bug in test_no_kmem_bypass
From: Wilson Felipe Pereira <wfelipe@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Wilson Felipe Pereira <wfelipe@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 2D314180009
X-Stat-Signature: hn1urfhey1ek74w9fn7fd1mfnekyfotx
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1785817288-785044
X-HE-Meta: U2FsdGVkX1866FShhn+rrqFOHAJoVsLZIpIDoAoupLwbZDwjkQ9cX6QmRMoLFiwlHjAAQNIsqYyfp5yu4EE6ZIBP3BeL3pIJvEOfKDhPqFGi8AmkbLDo2JgNxEK17af1Smd1vyUZ3QFEW3P9D3VTEH/qARI45d2NUXOOxM64ax/mEI7VjAqkM7UXOsdFXG/pQfVL0rsMgY6llXte4jNWXsYUJqbswjjWuDJy6yY+b8y12DXqJ0xjpPPsSZ4aA3mbtpIbDuwClOeG5ANwYlinQ27uRohyf7u6NFG53uJCOvJSwQZZfuv58I7q6ruqC+0MtyhvnynLYsnAkej9Znb1cV9HBhal6+tsKMJqIEf0/SQFIAVKfdr5USVee/DOJI4VyawpEuHvTn27vp7jMSxMAYogog2ADu+MxJjZDCLyUwk/bT15vKVV2f4Dt1YkTJHj77SOJ/nYPGAtXXywC8M5sQiK1iVtHHPXBtnEwcmmjjSbPhQqeT2WS1qQ9wzWHkf2UG3B7US9d0ZTuQFwlpoPxrIjsl/qsVmTSqWUh2yv9gRf2CYbMzNq5b8I9QMPSsLzrhuSj11766dg9UAp9COly78pflEgboPhJoGoAK4UWoEpCvrrZjj2eIL9N7FiXSONewU5E+rLF+rRuXEioys57FKxvPObXIZLd3xYbl8m6iw2vNQAl92GMTm5iPG9LS1WULlXbFgV4vdyF0ea+kEpCkDHU/R3SMnh3dFVdtLM19Koxa27RLb0GIkWxQkspEj+abliXKTNJ8MlBYDFYhVlv7dIXBttkpYKRzInyQqRQdEXG9eIxNlSuRtLw6kTatKGlnTk4YdFD6+nl7rDmcHRg9x0Z/4OMOSHY4V29Pl6uyLCZWXvIcRbCPkypF9VkPkAsMFwaC3sY0htOq9Ol9KcmhFJz7rQuOk2niLRhl0DHuKmyDFNc2R0j9bawkfT7oxGrpevTpY0y6LxTn+L3Il
 tQ9Wc+2Y
 7V9W1/xsXtyT8ZHzNth8ITSShKDQLOHt1cFLq4UVGvByl5CRDDPUFsBKYfZAfmakOA9d2WpS8cPR5+ir0ElcxlJFi6jxq57r1pWuPxi2lP+hhqTIyxD1HuZmjEmpX8JVRkAeClS2djigmxQzQlqvYxvTh+FFhoioZxZP0HETY+qPsqQx1MmPmg9taFc3jlZUiUaaseI6QcfNYcYP5AsnA6S2C+GfPzJkbyKZuXwQCndRoox4/2SLoEZfy89p4iUPJR+JrwgSUXWoYf/OeuVzxkiCJ42AlLBHaWjPa/xWsHU9lqWRv9hnm04Ma8CcK/kQbiK7jB71G48Z5wr/zVn2m76ZlQPaMPG52Ba2T1BllT9CsLdAVj896LW48MUS11q6wU2CcUdds/r+P/T7uxEA+HfrakGfWNUizshrZi7ur9UAziT+uDpePBHbMNE1AolZOxUJmRnqv/aoGbgTlez1f1njV0Hod0vtfbNj+5xkLYVmFEvIlgR2uWWIoid8QQBVhsgIHp/LmZrRUQWFQp8+tGM9GgIioSawCMwGTf2A1x9uA7ccZUl+oiJ5BxlpUhQK8MG8v64M6g/tD0E7SolqePTFIifWvW07piePdOocvG1bSfZIfrhdrmnlBKfBParcK1iqA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In test_no_kmem_bypass(), delta (stored_pages * page_size - zswapped) is
checked against stored_pages * page_size / 4 to verify that the pages
pushed to zswap belong to the test memory cgroup.

Due to slight stat update timing differences, delta can evaluate to a small
negative number (e.g. -5MB out of 1GB). Because delta is declared as a
signed int and stored_pages is an unsigned size_t, C's usual arithmetic
conversions implicitly promote a negative delta to a large unsigned 64-bit
integer, causing `delta < stored_pages * page_size / 4` to falsely evaluate
to 0 and fail the test.

Fix this by checking abs(delta), ensuring the test correctly compares the
absolute difference between system zswap and cgroup zswapped bytes.

Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
---
 tools/testing/selftests/cgroup/test_zswap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 312d51887a1d8..7bc2519862f7e 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -624,7 +624,8 @@ static int test_no_kmem_bypass(const char *root)
 		if (stored_pages > stored_pages_threshold) {
 			int zswapped = cg_read_key_long(test_group, "memory.stat", "zswapped ");
 			int delta = stored_pages * page_size - zswapped;
-			int result_ok = delta < stored_pages * page_size / 4;
+			int result_ok = abs(delta) <
+					stored_pages * page_size / 4;
 
 			ret = result_ok ? KSFT_PASS : KSFT_FAIL;
 			break;
-- 
2.55.0.571.g244d577d93-goog


