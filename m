Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC9F9CD343B
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 14:21:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EB676B0088; Wed,  6 May 2026 10:21:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39CF36B008C; Wed,  6 May 2026 10:21:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28B2C6B0092; Wed,  6 May 2026 10:21:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1275F6B0088
	for <linux-mm@kvack.org>; Wed,  6 May 2026 10:21:08 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7C93F88033
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:21:07 +0000 (UTC)
X-FDA: 84737206974.03.968C582
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf25.hostedemail.com (Postfix) with ESMTP id C7A47A000A
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:21:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aLG+vnCq;
	spf=pass (imf25.hostedemail.com: domain of 3UE77aQsKCDEWbbajbaXNaTTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--joonwonkang.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3UE77aQsKCDEWbbajbaXNaTTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778077265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=q9XrFDn9RlM9E9i0+tEuXQjIVQWHXE0StqNRpBmRS5s=;
	b=6365BMNpHLGVCcmlKA6UWq6CNOr5yJYCFgLRMit0fzAJRRnXNmkanYlmrYjBETWB1IVFyG
	KxpTGqEpfdlP2OEEWLiy23w3R3c1qnJL7IiRM9nsdmLC6sMnOfvDeDVVa2CEzt+OacMa8M
	w3atD+YFl4Di+1e8HsI3BoVfBqEmVdI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aLG+vnCq;
	spf=pass (imf25.hostedemail.com: domain of 3UE77aQsKCDEWbbajbaXNaTTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--joonwonkang.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3UE77aQsKCDEWbbajbaXNaTTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778077265; a=rsa-sha256;
	cv=none;
	b=Y8Clk5E9gmbuyVfvO049/O/2zQW1fU7qAIcR+faDrhKjx2NyUMZ/BR7f3GbOd1hYXCqX2j
	20lLP59ArTPf9ZSMJM514w1QBjS4NG1273hYnL/DhrYuR7t6odEcI1euXwz5DDgFDsHKDC
	kYtwQPWy5bFMkwdRGRnMQ7gm7vlL17s=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c7ba03ecdc6so6343745a12.2
        for <linux-mm@kvack.org>; Wed, 06 May 2026 07:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778077264; x=1778682064; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=q9XrFDn9RlM9E9i0+tEuXQjIVQWHXE0StqNRpBmRS5s=;
        b=aLG+vnCqTneYzlLd6umLahMwaTccSy1TiZd/a7PhjTOpg8HP2LWpg62L3pXQTFuBfX
         B4T2XuP+Zh8ADOHKLGRgzeLYHMaL197cwJm0Rgu6xEk+c006l4N4h+ufl7DPwnYAS94o
         QA98Tl6XxJfp85YEw/gdKmysys8oqWVErAOl9qbwOzHERFZ6qKU249e+gG8ESp2RdRMo
         4LQn4TgYMUPtryFLNudrmwmMQHqauY3/zUfRWVUKrL/lmvA+YAK6lLNWKxuo2pXw/2Yq
         VEB7b2hg1atsx9hycVIC3pHip+Mmgxffd1IJTsuUpMbOw2whV0qmPdYcU6QTZShe97Tk
         IuWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778077264; x=1778682064;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q9XrFDn9RlM9E9i0+tEuXQjIVQWHXE0StqNRpBmRS5s=;
        b=bQCsAzz8rizK+MCAx0m1vE5g2jnQ+OCQobtoDK6I3Xx+P67uLJnfEcPaMFddoc8PkX
         0RIjvsZBts+MSJToaoOZLec5eeRKnRtjKUM0M/3YtHHhpcj1Hp4mNA3rc0LgiSMJ9Mhc
         VD/N6xcl4xJ1PJGQSyOjWBT5ltkVrcLx9S4yELIgPzFvIJzgGO/4mO8rm4gQu2wYZxeR
         9q+A6VfYVr+ZzdDsVmL6Ajuy7qFr53w1SGVkBFJ0P9xJTpEQbTUUklkMNT5jkJpm7zzj
         HOZhkP6QiNnbibO3okTcEfNbNJuSChQe9SR4JjeqCWsNajG7Kc+Ls5nu46cxjPo3L4gy
         8QWQ==
X-Forwarded-Encrypted: i=1; AFNElJ+F3ZlTufOeauGDoNa004KXpdtJEmTTv0/ipZPbs5V7W/+g8GYNU0zdI4ZOCIwT27p/ym9W3wI5Ag==@kvack.org
X-Gm-Message-State: AOJu0YzUJD8DIuLHD5YKWIsJK3upUzjMXApe1nGLsBV352fY+H3TgDkh
	8GyjDJB2HbF+a6gJDT5GSOFbk4sAHstt76VQiGT7vv5bYh9MkBMozpKJCt54m1diZ0xvYsxdyYC
	xCBAcesXiOObCNDNMLZNU1OOxTQ==
X-Received: from pgbda10.prod.google.com ([2002:a05:6a02:238a:b0:c73:9a1a:387d])
 (user=joonwonkang job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:6d8b:b0:3a2:c685:f9af with SMTP id adf61e73a8af0-3aa5ac432aemr3760559637.50.1778077264177;
 Wed, 06 May 2026 07:21:04 -0700 (PDT)
Date: Wed,  6 May 2026 14:20:56 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260506142100.1289509-1-joonwonkang@google.com>
Subject: [PATCH v4 1/4] percpu: Fix wrong chunk hints update
From: Joonwon Kang <joonwonkang@google.com>
To: dennis@kernel.org, tj@kernel.org, cl@gentwo.org
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dodam@google.com, joonwonkang@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C7A47A000A
X-Rspam-User: 
X-Stat-Signature: oscsmqgjz7k1qt3gyy4cntciok3mcfmc
X-HE-Tag: 1778077265-451996
X-HE-Meta: U2FsdGVkX1/2yW0AxFkg8/bImEDKKwuqrFK2WCPaZxUIJJ5bovLz7UwShUu0lYeEihuz5PJ+WysCf/izrmtChq1eeIq3MDxuykoQ+cJBgLCn9PsJS1tyvSEV+Xb7s4YcCKYk3yS8auWc6XvgVEhlHEPrEQM+hQbdHoND2a8mLMvWbJx7kXx/VDUnOzUOvhh/toIo8QlkbE9DyeYu8258OCGPPDg9op9r3JqfRmDflTjk4V/XZIltzd+GcSP690DPkwVrjSOOf3kNwO1bIMEHgyA1OHxrMWqiMf0oZ1sQI04tGIzfobjUC61Y0bdFuE/i+Vn1xUaen2elHUolF8hofHBRFHiiXkGR6JJznH1nsUEQoEfIBP4VW5YQpzUNmxz4Xut72iuhmaIzsrHzeo37nEMDLbMm3IzrQypgG1nkXGXslMHvAQkcBRgmaZCiwsOwtSzmK4ACLB8ncTa6cVXEdvCWo4HAqGAhQDCCIsBLjyWjgAhbmXMS15Co9cow2sFK97ImEKT9OROMGXh6G2vxpM51ruY3RIcSIgnwu2FgJQFw68Bfk4hcb8pOmyME2apjkuRGpOaP1E0uoxrKq3DKJs/6VPzcSCDjY240zqVre0neDL5SiZCoLqEXxvkI8o0ZLYpP45k+ncI3KlDjzSKDyaoNu/MGPDxCk35N/Eug8Q9rx20qqTsgYw65WT03ckWmkKpPcxtSoL1jXTr7SlO/cDqG1L1DDJq4+MvfIYlrUf9Vh5POmkt20q8KQWO99S0PTbBNRyQOk9Y8yJZXCcOwmjjAhK18KXbSSNz0HltNXQE+0tgEnNY2NxRRc5sSKt5arLSmAmqy1G2ADO3cNBi4Mhz5Vmlziu7U3QQ3d43OT0qeo1XA2QL6NsiekleM6qxV26bi3guzE5bmYSiV4N/1crgFaAqVghUSnUStTaj1UdTr29wEtB3mX4qUBhooskV69jzXXWt9SCWIs2F9vMj
 5TZ3nDCQ
 D5Klgo9+b0Q38pxQhC9anegtBVYwdyu+cU+O9S2tWB5ndXnR+cwREaAtDBN5GpWHjVoAnEhrmXQw1Qk7rMAe2fe220XB+YbmTiX7TtGZh61B1xQyQnTgEvn2wWv4fPOqHP4NcdGe585rQBeFkS7PENw/u8mQca15PO1OyxqF51s3ADdSCiufDvx6liGsULeJPBnV2xlVFnoUF7YPkx4NEe4cOxZiwXGkbpj4vMn5JeuQbjpOXFDOLnk42ELPiWepBtJJCjVEQl4ZErdMia/Ba5bNZtvRrt2T9aI+m0mQrLjsmpw7Ue7SduCj3MCRPw8aj1AGtnK2iVRlagRek1e5D9DRootp0qrUw5jTzIA3kY9W6BZXFWR6mriNLGNkdU74j+wtCgBBC5YVQ5dFfhV9qMDwjJGILwDPtpspZF4Plwri/g4Dx5XzddGXgk2Esq3OXbM2RMDHmpd1AuemzDNgcPSnlx+VdLQ88auFjYQzTlna7XCZbt6ZPOes5svFOHapu6qKhoFHaqTlWM+eWjhM/wbu2w3Kkbv8GXWZ2XrMTKI8H7h4fFIDlbhBTGnxkC8T6iyvZVdk41sAMFIMMeOth08unXCgO2rC9TaVWvqvSy9/enfWLUE1wxulvaeniBm9jljxGzds7cpZZc0+r58QKPHoYik1huMgjvsTGH+P5fQJGvs37+A6PY12bXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Chunk end offset was set to a block end offset, which could prevent
chunk hints from being updated correctly. It was observed that the chunk
free size gets minus or shorter than the actual free size due to this.
This commit fixes it.

Fixes: 92c14cab4326 ("percpu: convert chunk hints to be based on pcpu_block_md")
Signed-off-by: Joonwon Kang <joonwonkang@google.com>
Reviewed-by: Dennis Zhou <dennis@kernel.org>
---
v4: Add Fixes tag.
v3: Initial version.

 mm/percpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 81462ce5866e..3ecd86096641 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1054,7 +1054,7 @@ static void pcpu_block_update_hint_free(struct pcpu_chunk *chunk, int bit_off,
 	else
 		pcpu_block_update(&chunk->chunk_md,
 				  pcpu_block_off_to_off(s_index, start),
-				  end);
+				  pcpu_block_off_to_off(e_index, end));
 }
 
 /**
-- 
2.54.0.545.g6539524ca2-goog


