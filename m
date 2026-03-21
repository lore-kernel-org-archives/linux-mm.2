Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 350211094478
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 15:04:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A52076B00C8; Sat, 21 Mar 2026 11:04:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BB6B6B00CA; Sat, 21 Mar 2026 11:04:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E0CA6B00CB; Sat, 21 Mar 2026 11:04:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 608E86B00C8
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 11:04:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 270271B836F
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 15:04:17 +0000 (UTC)
X-FDA: 84570390954.20.2670C32
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5BAD2180005
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 15:04:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=mgsPbUei;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.217.44 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774105455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=caGxMrakhd3CQmCyLFUIWJ+VIS649rYQrZPqpBwweHk=;
	b=eJBEc1cL2jfrIm2WYQ6fSy6Uns7VD8c7XMs+Rdqe43CeaE+0SwKhO0UHv7r7pjniRxwxud
	UOpzrV0lPdCHFjxL5NYN8dAygnV5/9zU0bkYg5H1kTQSDC9KCHnT2WfpKU00ZGB9WKxdhI
	b4XDR+sJ0h0TXEiyrDA8+j5ofPFjK1I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=mgsPbUei;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.217.44 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774105455; a=rsa-sha256;
	cv=none;
	b=wSkY2wJnQj95RxclGvlxARnHIeCS0ARo/CyTANuHG+2IHW2ti05GyKOsFdu0gcR3E9Utvv
	E1Jo4vB/VmioKQJykCs+3xOikeFwDJ23aMjg2afyHdXvjrHYljgLpf97SDXmTO3yWetTB6
	aM363S9YjWKwmZrsVcjoLWYek4680qc=
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-5fff52ab292so384769137.1
        for <linux-mm@kvack.org>; Sat, 21 Mar 2026 08:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1774105454; x=1774710254; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=caGxMrakhd3CQmCyLFUIWJ+VIS649rYQrZPqpBwweHk=;
        b=mgsPbUeipmX7yy1+oQhRV5qsaf1awmWbEHaZPzWm75Dgh2zp1qRvt/RfUY5wg518Ve
         GqzaNsZ22xwl6QMrKwSHo0Jz2B57J6Ba2iJ1i9+p45WAs7oCwwFLJHhVrGkSZmiqcvct
         68qWL3hGgC3lp+igga4ADR2gSF0TW/4QovmzwkMMrT4ScCnFe4Kv63JS1ZncR5l5GGDQ
         JHQ+qZTVnBvdH64klNtOtTKdgziqSmAsmWdDR+vKnCCPW2QbJu/C9sG0fNO1+203+Yth
         8/k8gKubXdkUeC6ni4UqKXLF9e8xeKX5bmk0OCri8oQ+iyn30nTmOilJXame6BrVdS4M
         xAyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774105454; x=1774710254;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=caGxMrakhd3CQmCyLFUIWJ+VIS649rYQrZPqpBwweHk=;
        b=n0fUVqjSRkbEIoC1/9CVKDjLiX2iJxTZm6jWZbXwof8DsWLv6rOa7z7+W6TgDGaclF
         KzbuGVybvZVT7UTlnHs5HTx7dAIavSWk24HI5mV/VAejj4vwZtqAcBIkgwYlZlEVTvVF
         g4EpLTX0czj+nDbIhyEa6PC6M2zfqlx5Nj31hJwJVsAMa2ADL0norWauNe+JJpMGjiwF
         rfjDVLt/IF0XmZ7sl5c9myj9aM9kiZYfjvJhtpAkfnUconUDZsRjIo/lmQZgVburqG1O
         hTC1RRFYabmsBLaez3DbUnT6VixP0DUCqf9095hCN7BSQKGMVWIBkSaby0lwH2z4RqPU
         M1Jg==
X-Gm-Message-State: AOJu0YxTV0GoG8zJEDz6dDymtlGjApr4AtlBXBRCLbtw/z+mcrGbTIO+
	QGtIIAOoTtlPXZA/qc0QlP1jNRm/Oz8Io7lk4IIbUsqaLwo++ae4SDCYjrHY2Z3HVJLZfKl0+E+
	Fp++e
X-Gm-Gg: ATEYQzzcx3zjEH8VxO++3gX29SE+AAWLvDCNHGoO6I8VA4seEtlrghrkV9bowlG2m9t
	K3gWMMwv/zl6V+O8gqTLrEB4yMt9m1ALF625oQr73V15h++uoXd5+wmFMreGY0+qdYVVQk64U+E
	kg7pP24P7AuTme/hsX5vkVfN4k5m9sMjpKBz68eWji1103y58h29bITZuTiCe+FFyEZLpioxzny
	cg8ZHiN3hQpSzFnQkI3r1nUd1ibleDxQwgkfcwavUKa+Tg/r4dgRwSBzBl2PXUY0SFit9uGw75f
	8ju3t6IFYQvCT+oLUDsAxDZBXRSG4njE3P3XRh+q1q7whHtJlmVdWT82TA8Qh05awbd5lxnBqzy
	lNBtoAVuUytoXs9Tkgwtr9502NqYyiW6uWn3ZFFWk55dMgg1BUpRjghcDPQ7d7a4g6tI/GR3wYE
	LF+/JuCdvspYs/ntm67qcO51nDMj6Jkd+zpof90M7SzyRdl4uGvgGLPbdHnw6iql3LUlwTu41Rk
	0yJ2ORqAjJnu+yorjw6MX2P1Q==
X-Received: by 2002:a05:6102:8089:b0:5ff:e39d:9f9b with SMTP id ada2fe7eead31-602aeb3a44amr3175883137.16.1774105454003;
        Sat, 21 Mar 2026 08:04:14 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc90ba89fsm391979885a.40.2026.03.21.08.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 08:04:13 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	osalvador@suse.de
Cc: dan.j.williams@intel.com,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 3/8] mm/memory_hotplug: pass online_type to online_memory_block() via arg
Date: Sat, 21 Mar 2026 11:03:59 -0400
Message-ID: <20260321150404.3288786-4-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260321150404.3288786-1-gourry@gourry.net>
References: <20260321150404.3288786-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5BAD2180005
X-Stat-Signature: 41unuotii1fkd5w7mj3fdtns1kecoie1
X-Rspam-User: 
X-HE-Tag: 1774105455-226832
X-HE-Meta: U2FsdGVkX1/FLt5QEND68/VQ2KFUNwIgV/4+IJmoUIGN0Snqcxbq/ki1w5hWlAVqu9DwSQ3Tus40hvdBqaoooMADYxbZvt6OU790hRX/ofGOnnJBN47kalZmzU4fIHMPtXKhDjiVzBKonTP7HbCpx4Aif3fHq83F3fjkFDUfb5rDGJjjAknuBizVd0JXJUNpqTNBE4evpS/RrimWTpwTveIBhzuXdBhG/gTjghDQltnXdDxUxJFc5BHOgHhSSE4VfttOWxcf7MgPMRc4hi5iRgpYZ4tpkmKZfYSGomuQHuV//NtMYojgyZeTopkMNHY76kPUsPCevnt2hCpJpRb1x6PU5U98IUNTBJTK83ot8452M/efKUMOw99OOnvOuw2xrsNOQviyF3b9Ay/F6CJ+c6MzuYNLdyvyN1J6qGonh+QjRwdrOKnDlJtB2aYnNgRQ2KRMpdTX/5uwLniY4uGZY6ovqdVYKuKIU3H7nqiotaBR+Iiv/sItOQRiqqLFS9XAZ3CbPU8pfmhlprczlzrC55YLseRlJVG+EEGM3VifjhSfaaawH9j1jfawB6uVTlJg6vWZiZQzmd/fx8hviwNlULg8cAMsFtotQDR00ZiZVobgV9DmLoJTCFrEi379XQnGezfanFvq/FE5ciq2Su28MnO4R2GDT2CiehbmS7dT6nstY/utndxLkKDnLRUeK4M5r8HVAIZG6QZIzuOOnk6IaYIPPwk4H09Ahnz/v9c5hw10M8Rf5Fe9bFPBmQc7fbcFzQ68rYPOzIASFB8BvVATszoJuA506hbpIMWnOAQOKaxRezA/AYEEzWNsI1DmqRuuKtaGyoUKzOlQnA1qmhxNASGlvbggez1Dy5i8k/zDEf+5MvjeHDr4pPM8jbLNsLLQd1S+p6GDCvU0/zr17a7jW8REMALD6hNDKyp2H6hlf/cEpYdI2H3X71d7Mie9Ym8gJ9MybIdb2YfOOBG8V67
 TRemaXMe
 7sM70AEQvJW63xcAUCberHiDTrQ1P6VzMklQz1Sj39wFKqqNhBHLoDJLRTXccBdSB28vnHWJhaOT1KMiUwmQtI1VvzY5YS/DTzUZ8xIyeDnAOy4CDErPfUW5iXN6r4usfDiXe6LXEE9oGLvBoiKgP+nKvZ1o701ltjifaY+p5XTb744/owWdWBP/PBi9n4TzxjmlwKo31FFSNAZR5faq6MB0qYkSNUAjEGE0moyHdmiOBbPYTEmLzxpxGwvFN846a1Gr+RIQ6STcaK8hK8jdyibfaasPjPftYFQBJmP/Vl+QVHvnBgKcVZhwJcXvi7iWOIdKUgnwp0w53Am9y4VF+4AyloTrJ7ZIiTs+1B3iUKEW3r+2guKJVJSzarqk6OIIDuahoPJoNkIJbv1rQJLpxnuLzs6dV+esU9iJ0TQC03Z2dVr/l8OswzEo53A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Modify online_memory_block() to accept the online type through its arg
parameter rather than calling mhp_get_default_online_type() internally.

This prepares for allowing callers to specify explicit online types.

Update the caller in add_memory_resource() to pass the default online
type via a local variable.

No functional change.

Cc: Oscar Salvador <osalvador@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/memory_hotplug.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 86d3faf50453..282bf3d89613 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1338,7 +1338,9 @@ static int check_hotplug_memory_range(u64 start, u64 size)
 
 static int online_memory_block(struct memory_block *mem, void *arg)
 {
-	mem->online_type = mhp_get_default_online_type();
+	enum mmop *online_type = arg;
+
+	mem->online_type = *online_type;
 	return device_online(&mem->dev);
 }
 
@@ -1492,6 +1494,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
 int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 {
 	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
+	enum mmop online_type = mhp_get_default_online_type();
 	enum memblock_flags memblock_flags = MEMBLOCK_NONE;
 	struct memory_group *group = NULL;
 	u64 start, size;
@@ -1580,7 +1583,8 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 
 	/* online pages if requested */
 	if (mhp_get_default_online_type() != MMOP_OFFLINE)
-		walk_memory_blocks(start, size, NULL, online_memory_block);
+		walk_memory_blocks(start, size, &online_type,
+				   online_memory_block);
 
 	return ret;
 error:
-- 
2.53.0


