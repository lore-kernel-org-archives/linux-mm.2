Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08620CC6B24
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 07:04:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9895D6B008C; Wed, 14 Oct 2026 03:04:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ECE26B0092; Wed, 14 Oct 2026 03:04:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 765DB6B0095; Wed, 14 Oct 2026 03:04:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 427466B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:04:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AAA6116042A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 07:04:46 +0000 (UTC)
X-FDA: 85320344172.01.95EDC95
Received: from mta1.migadu.com (out-196.mta1.migadu.com [95.215.58.196])
	by imf06.hostedemail.com (Postfix) with ESMTP id BBCFC180002
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 07:04:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WnbSFYgY;
	spf=pass (imf06.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.196 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791961484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pox9Q58bD4MFlzKt7YA4RAjiAN6Vd450dr1Oiv1NoM8=;
	b=fjHcRuOzz7EOlFL5qG1p1OoTX2bpPFHimy6Kk/BBIvY/bwrOswWoYqHm6lFu7M+1MJk8fK
	ndyyNTLOX1huoA3puLIoMgz6XHZlYpasTufv2lJAPYTt0Ot8TydKIhRFUR/8hMhi5WEt9e
	sizIY6hc5mg7gMLcmp3gK/8cd74T8Mc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WnbSFYgY;
	spf=pass (imf06.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.196 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791961484;
	b=hPAy2trl6xQl3JBqleVPv2v4lTKusqjDhQAEZQRGnx7uLtVELxe+i/EjTm4auoRUeeoLvx
	K9y4zRzsdtr93SLK7nJEXJBdkhhu+MUh8rL28qwytV2ntZG0FXMMPCSfJv5nAgVc9XZhR+
	STL4OgvlgY+anokPW68cwn29umzgQXc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=8GDWX4gLrjHiDtzRdrpL1LzQZH2vrwI26JE157EUf8Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791961483; v=1; x=1792566283;
 b=WnbSFYgYiG2mqhvHzKfWbcRePYVHFagBon+kwcs+YRoZZp6QfdvK9Xm3i6LMyWXlD/QRucb0
 dI9lFLLyvJZAG/Kg9VdjIZ7DMur5S/6+wNSkzBqLOj5t+OO7jgtqIP+FGTfG0yccVMz3OHq19K6
 3vjGwux0oJzqNwshoKtnJmCI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1af0e71b0a06effa;
	Wed, 14 Oct 2026 07:04:43 +0000
X-Mizu-Trace-ID: 1af0e71b0a06effa
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Date: Wed, 14 Oct 2026 15:04:29 +0800
Subject: [PATCH 2/3] tools/mm: remove Page Index field from show_page_info
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-show_page_info-v1-2-7a68aee0114a@linux.dev>
References: <20261014-show_page_info-v1-0-7a68aee0114a@linux.dev>
In-Reply-To: <20261014-show_page_info-v1-0-7a68aee0114a@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ye Liu <liuye@kylinos.cn>
X-Mailer: b4 0.17-dev-39d60
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BBCFC180002
X-Rspam-User: 
X-Stat-Signature: 11yo3hx8zhk6agau18b5zhqspx3a8sef
X-HE-Tag: 1791961484-735147
X-HE-Meta: U2FsdGVkX18KEQBR1bIGE9gBfF8wRYfwxTB0Fx0MC4kwIcq45KnA5vnAHyh9DcyGTYVNYw74BQK/4v7QtVRPpTIyNaYAZXKNNPT4hSCNXLWSzyQ6HJFPTod34ja687H+zpS/Og4fpAqFcahW5z5APS8VSEyvQ8FySfob6PksyOizCKvRJDR3GoPiCNIDTXZAlLZelA+q5nScttzX6AMm6NDJsSYCnlkbYcRWOSkpyohNGuKLQLiX7zg3IikS8EmIc7ztyFtVJZTKP0vdNkDktWO2rJvbFmX37/aCaZC77i9FP/GDwfstnYuG/NtbKCRbc4xD9317lehh3PBPLRysHT0lEf96l+hSZUQnr60Lj9hPuLyyc9gXnAyYyIiL1Cphk3WoHIC8eTiw61mZ/uXIv2MUnYZBpnbjarbYEjEBMM8RHEpDJmIVe7nla//XHK15xsTXHTcnEJmR/wIJKuy8cTtHmjjkDrMDdsjjTErDA1sD5/zd6L/uLiG83XlLX0rA3oyPTqj42DXEv6pAXZZgK+9UJrsUHKwWGp6dbz66d/DQTthdzp3SM3OLnd2x065tCaGGkeLcpn3LLNpaLX0MTYfBAOnbWelmCPWByqU8jTJaxhUossDgJDxBS6F2+Oa7hdmZcbThj9RQUXF60c1c3ooeR+lASGlpGRDn/wYT2fbrAsLmYrOY7TB5LfTUpa3ABG1tcpR3iy44RDYxB53dXQEQnvCWmw1/biH17g86IRSVrbaN9fMStDTh1VvpoP52/AzNTcbcfwIsA8B9Te0I8ZjEnvVt7C8gYcGw29FefTUeTsgpCHOD0qF7171aJkVMd5N4jvfH7ArFEnkfkCHL+zkniM3gqBXt4H7pnSZ//hyYmtqfbZsmen/EnbAJ/jfjRJmpzwHDkTqoBLMj2N6w38eQUYKUrHHGEjhhdBz339HQlLQjjBKsv9nBb2ElfWzIWkjy+BhMt77WDioAZ1C
 ibbagtkt
 EtztUJoxLZ3g9wb7SHvFXzAKd3dws//59opILX/VCHMCY6hYDHXy5Wh46ng7wqn12awonhLBxZeGWo9Z06K1ZqsEAZt/ahaSbXwj1AeXIBeidqZ5jEbXoXWwGxHBo4NOAOH+/lFzsLToLJ16n/h8oOQOhXMl00pkNcqoeh9DF5olWapWx81UYgh8ZwHFG3N9axG0LV8LO/KHW3Fj6bOW5ltbEiawIQKP3FGDFlKRJfJrZVhdJFRxz0077lsJ/+FyGx3MF3hFA+b6scFwNwHUeOtKDuK8cZskyVk5ayqQMLOb76+eLS8jD7BIrNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pages don't have indexes, folios have indexes. Remove the
__folio_index field access.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 tools/mm/show_page_info.py | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/mm/show_page_info.py b/tools/mm/show_page_info.py
index 9cfb5cac05a3..1fbef3889e91 100644
--- a/tools/mm/show_page_info.py
+++ b/tools/mm/show_page_info.py
@@ -92,7 +92,6 @@ def show_page_state(page, addr, mm, pid, task):
             "Page Virtual": hex(page_to_virt(page).value_()),
             "Page Refcount": page._refcount.counter.value_(),
             "Page Mapcount": page._mapcount.counter.value_(),
-            "Page Index": hex(page.__folio_index.value_()),
             "Page Memcg Data": hex(page.memcg_data.value_()),
         }
 

-- 
2.43.0


