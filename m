Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAEF6CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 09:38:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31A2C8E0003; Fri,  5 Sep 2025 05:38:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CA7D8E0001; Fri,  5 Sep 2025 05:38:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E0438E0003; Fri,  5 Sep 2025 05:38:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0AB3D8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 05:38:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 98209869F1
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:38:58 +0000 (UTC)
X-FDA: 83854697556.09.39DF47D
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9627920005
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:38:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=aisle.com header.s=google header.b=odKXiILQ;
	spf=pass (imf03.hostedemail.com: domain of stanislav.fort@aisle.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=stanislav.fort@aisle.com;
	dmarc=pass (policy=quarantine) header.from=aisle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757065136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i8Lga1GkOl1oDiE+1dVHrqOvB9vstlkU/NOIqsz7Q7A=;
	b=nCE+c6U7u4/oDjQcSdAxoRUbW1Hr2jA6wqHBoyxrAWSeJllffCUk/yJwjXoOzsQrUz3PjX
	L0qJqQxmOZ0Xa1v5EylSLJk5MGOpaME3Ag6QjAhO42n3A9qXLnoJkeTF+TdtjRZBmjXVnG
	svHbGSWXkKdWXKZxkpce30q3kiikHg0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=aisle.com header.s=google header.b=odKXiILQ;
	spf=pass (imf03.hostedemail.com: domain of stanislav.fort@aisle.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=stanislav.fort@aisle.com;
	dmarc=pass (policy=quarantine) header.from=aisle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757065136; a=rsa-sha256;
	cv=none;
	b=uz2co2dklPavG9NO0VbaNuZgKeyE/e4w86GG1Ss7zSCO8QjhcHS+jUYQW7NJebhfkDR7P4
	zoVob9uWGrtiVHQS0qu47kWHic+WqfL8Ot9AVqjABWsYernNtRBHwAGv6ce2qcz99gOptl
	0gIT3qXGXfXlk+Pvz0r0iv3I+Zc7dHk=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-619487c8865so5529761a12.1
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 02:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aisle.com; s=google; t=1757065135; x=1757669935; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i8Lga1GkOl1oDiE+1dVHrqOvB9vstlkU/NOIqsz7Q7A=;
        b=odKXiILQnmUIlOhiPqwYkFEmM/QBrFz8zZAfiM8LHklDT9wSTwBl7BDrhAOeqckkWq
         tAFi4tj4/ruKVRrhK42pgIwQvtd9F5zsSmLsawCNnOivYU1+tjQpKVe8576W0r8vGZgg
         s0HPB+vIqOUh0C6bwqQ4LqEGa89sNaUvVpj/elXJtqp2qIPNDC6UBgonpL7Ev/DKP6DQ
         1D6NGWnkRSx5JiWMTQ/qfaDk/+gl6hB42q9nyqZrslbXyi48iZNiZQpFpPP/85yHDFdg
         AVPTxSfB/Af+65bzecEGHNanAfVK611xB4mEQ3HTi0uXnNtM7uhHsobzAQwS/TG6qLE3
         svUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757065135; x=1757669935;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i8Lga1GkOl1oDiE+1dVHrqOvB9vstlkU/NOIqsz7Q7A=;
        b=oU3s/KvAwovtmCaUW1lOSq1dvi/UY9SGn1FR2orMCafXUFBTrNq7MvRIvtwQXrPSfq
         y0U6/GZZeBHIP7/WSg1jB0/z2hgw7h5QAamcltMLxh3C+N378OF7S3Hfvhcfgrix431+
         RqeAts4nN0pWFlsm7o2YoPflVPnExQyn4u2dfXcc5I9Ey5zMhlP2zyKC7B2zJHVf1yFf
         m0/C0LZbDbmwBuObVDuRF8mM3CeET0JAm6KldTSJXO7lfU/uchELqR9bKpwwSe9Iazhf
         vQBTgYr7FmQKIHfrayu2NsXLZyxvbOKoiUuEeTzEFFdj02julUW4JfIFQtyMYZgebHCN
         9Ujw==
X-Gm-Message-State: AOJu0Ywsy7wl+s5qIRnFWHLjdcPSW3oJXFzvOUq9O87lfWwv3cLnoaop
	Tft1OcEhvqpBSrriB7GAYMYcSBEB2i4i11WJtOvgws2wBhKM4MJ28TrM2tTqVJkeugg15og9g8k
	5EfT8liJKjUXl
X-Gm-Gg: ASbGncvHhEtI/lvAUxNeKPyuaaT9NMK3stjMo7iHhH2Q5BO+E7Uq9UgNnEAOQqMmb/R
	CpfXaALmQV+tziNME1EkXu2I7ik7AGVKNQJXYwMgoEaSHQMyHAD4ZsfFq7x15Vem2Wm3E96JRvs
	rSIE/3HbYaUY/mjxMd1mbsqoa400GASpmPmejHhTFp4aJVFFYxWlIcAbOXRbRSRddku21qo0iUw
	fMeDUHq96AkSOpPsRhDG40assWrutVd8yIBwVexmyIx4yx2eq7qRi7xW/Zk/kQ7xFR/DnfKtZO8
	YT2xgqB4dDHpiXnvlri0aFcOx48BzY9ug7MMgGVNTTSCjeuYxUUYJpMNmtGYX1i2UPOaofQhqct
	u4jYRKe0igmzG8l+XFNFSYu1NMQN/ltBwUJnEWUProJr+/go=
X-Google-Smtp-Source: AGHT+IGybuK6K/kujLTwnL+Fz49sav06Z8CCw7Z9351OYmVQ4LWXK44fzX23p7+KrdEaFzCMcOmACA==
X-Received: by 2002:a17:906:b24e:b0:afd:eb4f:d5d2 with SMTP id a640c23a62f3a-b04931b6715mr240740366b.31.1757065134805;
        Fri, 05 Sep 2025 02:38:54 -0700 (PDT)
Received: from localhost ([149.102.246.23])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b046df9a44dsm561055366b.70.2025.09.05.02.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 02:38:54 -0700 (PDT)
From: Stanislav Fort <stanislav.fort@aisle.com>
X-Google-Original-From: Stanislav Fort <disclosure@aisle.com>
To: linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	stable@vger.kernel.org,
	Stanislav Fort <disclosure@aisle.com>
Subject: [PATCH] mm/memcg: v1: account event registrations and drop world-writable cgroup.event_control
Date: Fri,  5 Sep 2025 12:38:51 +0300
Message-Id: <20250905093851.80596-1-disclosure@aisle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20250904181248.5527-1-disclosure@aisle.com>
References: <20250904181248.5527-1-disclosure@aisle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9627920005
X-Rspam-User: 
X-Stat-Signature: 8meaqeqf4gm3rr81njbwjf6udrr4oq6e
X-Rspamd-Server: rspam09
X-HE-Tag: 1757065136-152019
X-HE-Meta: U2FsdGVkX184MFerAoNTtBE+lh77yAgczlAeoKQ9g3QRcTGtFgZEj/gWJDigfilEXSKCnG6l/pidMMOWuOSZie+CUKpJMpYxgnmMsxl67vECldr0mZdKfhUQ8J6jwPVXWwXVyMG/nKrRF0w3pyW+V8L3xCwX/PVjvKyPi3Ml2Pv7ftTSyhlZiBVgmYaiMjO6jBIojn6T5fc75Kxb/grvEB03VxxoU3Lnl3rHRXRdp+mQQg8eMHAMjf4Zt4/bYctT6zAiHkrJfuUrrCoY8Jpd+U2zlL4QuyxzdJgRJCQjt4TwpKZFJUIRlwkOiUAF+TGWGC2h5SLjCrd3tQMVzHskl595O4ilODpXK8S4EuSc7y9WT50nbSMfOj7UKdHpm4jGmyH/hXZw6j7xfb/PNA3XpsVGVbgvLxlIFNwOLq/+Pnb9ese6aB3amrS9dztKDQzdWseW5UAtBaUYKB8w10AJ/8V5ggSh+PljmigKurybgkRqxbfunxsK4rET/l83euTjcj5I4PTrX4wMLOfShschecLYg0BsoOB3bTVXbODhqKpymy7q3UlpooSB0hNu4kSPQH34eIZiNeJgQF2MP0vyHSO6G+tXjA/ZG5Cgok+BM5ltggOg2+GOcxGmtDH0cE63oIg8/lr/UdEOn2HN+mKKZl7tYTpabis7OcI0kh67W7ekXUBGINL4O8E3hKNKkiAAE83N8ex0/4ys7pnDLx79Tt6uSbVrcz1chV9znwAhhKcIoCwIhZAHTrr/hKTYfZ7kuO6VX2XDoiIX8JzO1nu+faGAIjKlTFMN2S3Z+Vb22QuSGGR3EoniWSCU5zjMKkfMMC/fqY2TEdjQTO+2wq2dZwW8eZ8FvluzjSEMJGDH7RTezq/t5xa4kzI7Xr9m++3d6VWf7lKobou5WwN2n7sYwMvtBF7doL71fX09UeXL023gNAHharfBnyrzl+7pFBBcqZGTiEz4AzxkWmmQ1u8
 0np3b4mw
 oWLl8XjBRI8xV1IQ0ulHMTyem13NNyfcZjMcaeio5yXpxwKY6gAaW6WPxxUJBHORFn73HRuBw+be0/rVrhhw1K45LKPeRusgRi9vkJXyCDUWpXlmFmJ6iStoAWQU10N7zsgYbFfxXJ8Ib15iRIqSugpoJ+PYmXuuTL47WAPajDDB/lt2CIJ6HQZLaWm3PuwSQEuNBN0/7WGC63xMjJtZCAdBCOqTNwPsJgDFT0Sku3zRinWnagKRGZA4/bkkc8mNfDBYzwGuIGTBR3Vo17NtM1T5nvxx097Rf2ybHOEwXNwHJNsFBx/tZNhpG9NY8kcF70l6JvHPCbEIJ9ONjD5qGIP4bS8L6AEGPo3Ck7SmcdqemutfnsczZrXl0jQRBN3L7LUMb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Switch __GFP_ACCOUNT to GFP_KERNEL_ACCOUNT as suggested by Roman.

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Stanislav Fort <disclosure@aisle.com>
---
 mm/memcontrol-v1.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 4b94731305b9..6eed14bff742 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -761,7 +761,7 @@ static int __mem_cgroup_usage_register_event(struct mem_cgroup *memcg,
 	size = thresholds->primary ? thresholds->primary->size + 1 : 1;
 
 	/* Allocate memory for new array of thresholds */
-	new = kmalloc(struct_size(new, entries, size), GFP_KERNEL);
+	new = kmalloc(struct_size(new, entries, size), GFP_KERNEL_ACCOUNT);
 	if (!new) {
 		ret = -ENOMEM;
 		goto unlock;
@@ -924,7 +924,7 @@ static int mem_cgroup_oom_register_event(struct mem_cgroup *memcg,
 {
 	struct mem_cgroup_eventfd_list *event;
 
-	event = kmalloc(sizeof(*event),	GFP_KERNEL);
+	event = kmalloc(sizeof(*event),	GFP_KERNEL_ACCOUNT);
 	if (!event)
 		return -ENOMEM;
 
@@ -1087,7 +1087,7 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
 
 	CLASS(fd, cfile)(cfd);
 
-	event = kzalloc(sizeof(*event), GFP_KERNEL);
+	event = kzalloc(sizeof(*event), GFP_KERNEL_ACCOUNT);
 	if (!event)
 		return -ENOMEM;
 
@@ -2053,7 +2053,7 @@ struct cftype mem_cgroup_legacy_files[] = {
 	{
 		.name = "cgroup.event_control",		/* XXX: for compat */
 		.write = memcg_write_event_control,
-		.flags = CFTYPE_NO_PREFIX | CFTYPE_WORLD_WRITABLE,
+		.flags = CFTYPE_NO_PREFIX,
 	},
 	{
 		.name = "swappiness",
-- 
2.39.3 (Apple Git-146)


