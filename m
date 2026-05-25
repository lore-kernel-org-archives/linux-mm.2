Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 254E7CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 19:05:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A947C6B008C; Mon, 25 May 2026 15:05:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6B196B0093; Mon, 25 May 2026 15:05:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9814E6B0095; Mon, 25 May 2026 15:05:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 89FB06B008C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:05:06 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 554C8160B6E
	for <linux-mm@kvack.org>; Mon, 25 May 2026 19:05:06 +0000 (UTC)
X-FDA: 84806869812.08.357E041
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	by imf24.hostedemail.com (Postfix) with ESMTP id 84E74180005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 19:05:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="s+jCGv/y";
	spf=pass (imf24.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779735904; a=rsa-sha256;
	cv=none;
	b=vVTXGyaOELVA0Ysuw6YOucQO/j/uQG0ox4kG39syYSfQyHSEaFx2X/xjKwAiJMYNDf4oUv
	l1F8dtxUVRHNVjBQgHfuGg5H+548Hbo/DaA1FcwGaQy5TpUjQC2btlQJbTDdHaQNr3PNVX
	u4yyFCVea5pccmF7mPVbyR94ilZ9yek=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="s+jCGv/y";
	spf=pass (imf24.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779735904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SMrn8GveLC1NdRQvZAymrZa6CvaW/GKC3sRoShkKmw8=;
	b=y/YKhZeptCYhmKzliX+2Q7brjKdpAmhpFB3PKisfJucU+OMpuWfr/TPLk6t/deqrNE3phR
	5hempUGJpz/zNt3snbYQLFZ9r+AOXo2lKhtvG2HiCUPrrjwvsMK0HKL4eBguGj68z2pPdM
	lZoZ2uI++KZeYjF9/Fuu3i/6EDMZ1Pk=
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7e636d1bedbso1202773a34.0
        for <linux-mm@kvack.org>; Mon, 25 May 2026 12:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779735903; x=1780340703; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SMrn8GveLC1NdRQvZAymrZa6CvaW/GKC3sRoShkKmw8=;
        b=s+jCGv/yoaAaa1y6D9NX7WsxchgV8LAbq70Eb6Di9UWlrs594Uz277ws0qEhjD4PcV
         YiRNk7Dn6ett7O2Xp+Wp7rlFbVkDl5n7IEUFfQo1tVmDcC84pFHKMy0hshpeteESZYRc
         k/vdJ00AZc2mCJkm/4ewq+LwG2WraFJdGC53FTI1dzeui9j16TjwXi343vhb0Yfk0ywV
         E8GRwQ8ULujJwV1b/8yQsQKQ88gjFyDefLTmdE0hQhKHkSQq3/Ujh9mx9v2Ajj7s2Nmr
         51hCDt7ljdZvNnf0+0TBFsduj4CZUqbxOAkV9ctiKPGEZawAyZSn8yEcGuayS8ZUxvRd
         DHCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779735903; x=1780340703;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SMrn8GveLC1NdRQvZAymrZa6CvaW/GKC3sRoShkKmw8=;
        b=Rb+tKHjpLsG0VrC6FFBEjuKYU5i8SdV1NcyvpEUWwdwrUxEyc0HLZayvhYGMHjCIHl
         SxGiwFJ3PviyUyrYdpNDnuthUcd76hTStrihyeDAJp5fC9T7eK7xEUR0ZMSSqltWGOzY
         KFqT58AQ3pD9qrGbai1N7FPDcBTNY1DHF+sWLJzia6Fm4jRvNpwv/UOz8w+dNdE5axmr
         Ir9AwwbEPql3B3MLwUIhjNAAT94dixWRm7SRP5Apcm3d89SXXD/7kyBViiCwZg71nL3Z
         UExGl8sGibpnBiysxY3PaBMDWI1ikAnIZvXMD0V/gyCWU55h0zk/JLsZNB0ruVsgB8zr
         QHLQ==
X-Forwarded-Encrypted: i=1; AFNElJ8qZmRYhzaOJo3/CP8dlkN8/jelPzjs3aUYRHTBHcblWw+GA7pK/Hr7ZCT1TxK7OYD1WcrlGHuaJg==@kvack.org
X-Gm-Message-State: AOJu0YzK0Fx2QbqBPq8EswAArZdenyhnre70Qv/XVpRqFNBrTfjEWan7
	h46ae0ZeAZ+grwS61Mb7LV6ZQnualDMNS1zCmzM9L5IfZ4SpeSO87nlg
X-Gm-Gg: Acq92OFOHS1HfawiGhAc9QNaN/rNZrNxdtdnXXckKteHAWMDZPsgHGEH3yy4p+MTYV1
	ANZSkemnkzB/uxEsaNm9T1YNFVW9UYycFGx8xA6Qn0Tg4rogLUC5LiBWNscRrTM2094Do5e7E8I
	PeOe2jTRXCXHQcUM21/f3oLd9GI65kSEJvvhLvcEyzmhlaIsJ5U1qufeWv1nDOXXHum8PC4knzK
	7OV0w1RWll2/bFBhbCcJq3CjUew07FoIQ6nt8r2g7kJEB5kfuDHoJ43tHaqI+n1q/VtI06NDKt1
	5mU7yhbhVfwK16uVJuOCb0+4OC4EG0r4Ql19aU+HasW2tOxMJWUr+j56aZUhCv/FGGy0x+THUQf
	jaZ9gnEVmyaOQjXi4c76IRhmqnhz+EnWStYPbfJgdOaz/hALIJK2oe9YbMowbgIexvL5XDyzycx
	Gwy9/8U33iqCm29O/+yQlmQPeYFYyVwYGRQudT2K5UiyBh319Bzh0iFg==
X-Received: by 2002:a05:6830:610d:b0:7d7:c985:3a30 with SMTP id 46e09a7af769-7e5fee82ab6mr9298026a34.11.1779735903615;
        Mon, 25 May 2026 12:05:03 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:70::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e6065e6aabsm7915197a34.13.2026.05.25.12.05.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 12:05:03 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 3/7 v3] mm/page_counter: introduce stock drain APIs
Date: Mon, 25 May 2026 12:04:50 -0700
Message-ID: <20260525190455.2843786-4-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260525190455.2843786-1-joshua.hahnjy@gmail.com>
References: <20260525190455.2843786-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 84E74180005
X-Stat-Signature: ewq4wuo3ap9yf3gx14e5xdocxgda33s5
X-HE-Tag: 1779735904-942208
X-HE-Meta: U2FsdGVkX19raMLBgOyWKG3noFLxDPtfBgMK6IF1H1As0meuoT8b1sUfgQUy0C9qqzW1ItKD/jskQzo8o2KvmWxxPRfaPXi1Z9zlIigO2ycDZBmBTnwjRjN4DmqwPizABUR+jcqZzewLObw5bz1vhLX/Tr0iTd4cnkMSwv1A+1rAMmbxXYSYVoA1QNNSU4Wt4WFU3/Unlb63TypFw1Nx6DzPd8U/FP9KsUkih3clHWfL40hCkq2i84Tn6Y7Inwy3Uhyfdts6Cns9V88YC6PHM7Ku1Dpx1Uj19XuLyK2T817yPr8OSTnqozyTkQrP+F1IU+eDnV/xbXK7Fi6bjpzTjT5cyEwUnNK8KZ2kmC8MNeN7xtrjFOpJ3Rf3UhnAoYvjl4ExrB0OHheFcuJV+vHf/oeZg4zzKhtAC9v6UKvNdkZpi/GUtV1FLb9orgKERdiR7sZWtmxJoko1r/wxoh9GmeYlBJogu4GmqeYx9nYa7d4nwI3o12zNd9Hx4L72o5WUvaH6NrFQPcoUeQg7vhbcJ/9MclxQayl+EOdz2L1LonYP1DdxE5I2nI+/eaEJQ4FpuAqS36kggYqcbyB7OJy/J6E8uFDp6aD/su1Pso04utm1QtuiLhIrAzPPx+ZS47e/wfX1znsjZbGYNshmqls1GLWVmL2FNfP9zgFg23RYDVHjAOwR8c0ibHa3cBwvSIHxLi//eOKX8slzCDmwLJw8hcSkrRPBAlxORknVQYQnn+pYhhpy3ucEjOcHrwK3ukt3gJ7dPrtd27v/sKwRw9N3SU5ZE7tfW/GL/j4ajAinWgNzMLTzRrAHS2GFU4WxbdrDuRRp4Dies0PGccAti9C+qfBKYUGSLSchIF0SYDuRbctJiSIA5RWifrCR5vfaSHkN1KZRQheowcw4OxbmhaEXxjPPsW5M2KC7jRKMkbuZmzL0O1AdJjGeugmPaBdjdvG1z88hbm/bhrlxMSeM0LS
 fUFwP0lP
 tuRylDDAozgkREkEeuq9ztbNjef1VPCkty4/wBXQTjNdR+RLVFRMDX1Zaqr1OYBlrThYxvvXJZgc9B1Hl3AUzloj+VlD+guh2IBJHq+0N6HVK+z2LD/Nisyq3MNWqq5Mop/l7QAINuBwii3n0GR8U2URwGmbdWmH3Ffrv6P2mXZNBiDaNz6dKN0bkaGXiq+xzKMzmLvzMtOF0d/DRqb+aE15pKNVSkCnoIQTjlcMqAq4+Z7I+XsWNTok/BXFW2I0lBdFiMb8xJWugKhiKVwzK8wctL2A0ldVMsdzo/ZaMuQT+ZO0J5jP27z2MqzEgZPyBnaOL466z2vqaNttI6aubR/CRY5Gr8T1pOHpgkteLvh8bCpkXpWod/K3/kNTTVemfb1Poad13q3tZG+M5YvFrabSXJK6CfktVDkjXImftLQyuOC55/D/UtEX80bAXfI9cYNCdr6YtVjjirPp4vX7nRIi732sFok3g5eUneulWGFUwmDxEoUG+ap6kXOhBt4rLhZiONZgs+1AYGv0eri/Z/PGpsk6B4DNlRgLPCZaq118HwZpFx3Et/IJFGM5wslhpnk8w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce page_counter variants to replace memcg stock draining
functions.

page_counter_drain_stock_local() drains the stock of the local CPU,
taking a local stock lock to serialize against concurrent charges.

page_counter_drain_stock_cpu() does the same, but without taking a local
lock. This is possible because it will only be called from the CPU
hotplug path, where the CPU is dead and there cannot be any more charges.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/page_counter.h |  3 +++
 mm/page_counter.c            | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index c7e3ab3356d20..ffe13224213c9 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -111,6 +111,9 @@ static inline void page_counter_reset_watermark(struct page_counter *counter)
 int page_counter_enable_stock(struct page_counter *counter, unsigned int batch);
 void page_counter_disable_stock(struct page_counter *counter);
 void page_counter_free_stock(struct page_counter *counter);
+void page_counter_drain_stock_local(struct page_counter *counter);
+void page_counter_drain_stock_cpu(struct page_counter *counter,
+				  unsigned int cpu);
 
 #if IS_ENABLED(CONFIG_MEMCG) || IS_ENABLED(CONFIG_CGROUP_DMEM)
 void page_counter_calculate_protection(struct page_counter *root,
diff --git a/mm/page_counter.c b/mm/page_counter.c
index e002688bf7f1a..fbfe9a1b29d2e 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -389,6 +389,40 @@ void page_counter_free_stock(struct page_counter *counter)
 	counter->stock = NULL;
 }
 
+void page_counter_drain_stock_local(struct page_counter *counter)
+{
+	struct page_counter_stock *stock;
+	unsigned long nr_pages;
+
+	if (!counter->stock)
+		return;
+
+	local_lock(&counter->stock->lock);
+	stock = this_cpu_ptr(counter->stock);
+	nr_pages = stock->nr_pages;
+	stock->nr_pages = 0;
+	local_unlock(&counter->stock->lock);
+
+	if (nr_pages)
+		page_counter_uncharge(counter, nr_pages);
+}
+
+void page_counter_drain_stock_cpu(struct page_counter *counter,
+				  unsigned int cpu)
+{
+	struct page_counter_stock *stock;
+	unsigned long nr_pages;
+
+	if (!counter->stock)
+		return;
+
+	stock = per_cpu_ptr(counter->stock, cpu);
+	nr_pages = stock->nr_pages;
+	if (nr_pages) {
+		stock->nr_pages = 0;
+		page_counter_uncharge(counter, nr_pages);
+	}
+}
 
 #if IS_ENABLED(CONFIG_MEMCG) || IS_ENABLED(CONFIG_CGROUP_DMEM)
 /*
-- 
2.53.0-Meta


