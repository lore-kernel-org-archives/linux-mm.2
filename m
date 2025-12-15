Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0A60D5B843
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 15:47:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26D326B0022; Mon, 15 Dec 2025 10:47:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21D496B0023; Mon, 15 Dec 2025 10:47:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 159F06B0024; Mon, 15 Dec 2025 10:47:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 045676B0022
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 10:47:44 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8049FC01D4
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:47:43 +0000 (UTC)
X-FDA: 84222135606.23.E57A1A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 86F86C0007
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:47:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b78SMpZ5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of joel.granados@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=joel.granados@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765813661; a=rsa-sha256;
	cv=none;
	b=duv+ADPbPtkSGJFLbbEaL/NTK5gk2dlpLceJuHmUgDM8lfvm2p9ZrJE1zuwKB1GdG1Q92c
	y1ZR8TW9dEwwA74X9gttz58I7QzUm9WiUm64aBLbnc27RmApe7D7ygrMHVElGLWGU0lRKJ
	pXTws0Rci5rXZn9t0sCVioAh2yd16C0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b78SMpZ5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of joel.granados@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=joel.granados@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765813661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=a8sdJUuix2ldw+aEOBPJ/TMKSXMwF88AtPBQvODtyCk=;
	b=jjB1Xech4lwV6+WMHPBTpRp38gbIkFTlpeOgdF7SlEpZxPtO3uTZgBYOA1ndhypAh08Y5b
	I2yVAzS51VB0c4f54mo+7qbhiaSTnpO61PdP52BIlx/xn4k0RhBcIbr0GBiu/MMjenB6zK
	Swc1OrZFS0R/ns5iDM+QKQvc7xCWk/c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 97E004098C;
	Mon, 15 Dec 2025 15:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 73D41C4CEF5;
	Mon, 15 Dec 2025 15:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765813660;
	bh=LDUL2rRv2z6sqgcL/GxlNcgNQGncefAQrlvxFNU0nqA=;
	h=From:Date:Subject:To:Cc:From;
	b=b78SMpZ5eJSSU6aIEo06lB4Oe1T5SkgGjQYNhTwd8VBH0c4qdqlnWk8c4ae7beD32
	 qRl1FAZb7a6r19opiyHWSB8mHCSv8d4JFjMPC0rhNbR1XavzuCWf5PTsip2d0SmUD4
	 uktz3eertrjS6GZb9NfvURZbgqieJrofjxOiIwNm/LbnJgYQxWNlEgmcL7WgjNUq1X
	 ndpaSE63q2YRPRoZx0cUkyTBMFZ0IGJzAl3fwhj0a2wYKD3affmpuagDovCC38HyRX
	 iZoRjldO5OdJHDEoABn10O2fJ67bRRqSGvO9UXTVNkNldvJOZlFVM5qKB+H2s/I2GR
	 1pgxleArBod5A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B752D5B843;
	Mon, 15 Dec 2025 15:47:40 +0000 (UTC)
From: Joel Granados <joel.granados@kernel.org>
Date: Mon, 15 Dec 2025 16:47:37 +0100
Subject: [PATCH] alloc_tag: move memory_allocation_profiling_sysctls into
 .rodata
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251215-jag-alloc_tag_const-v1-1-35ea56a1ce13@kernel.org>
X-B4-Tracking: v=1; b=H4sIAJgtQGkC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1NDI0NT3azEdN3EnJz85PiSxPT45Py84hLdlGTLFPNk4zTzRIs0JaDOgqL
 UtMwKsKnRsbW1AMZQZlFlAAAA
X-Change-ID: 20251215-jag-alloc_tag_const-dc9d7c3f7a8f
To: Suren Baghdasaryan <surenb@google.com>, 
 Kent Overstreet <kent.overstreet@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Joel Granados <joel.granados@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1430;
 i=joel.granados@kernel.org; h=from:subject:message-id;
 bh=LDUL2rRv2z6sqgcL/GxlNcgNQGncefAQrlvxFNU0nqA=;
 b=owJ4nAHtARL+kA0DAAoBupfNUreWQU8ByyZiAGlALZrSh2JjzWixeXMWIrdctFPERl6yyv4NN
 LiieH5jSdOOe4kBswQAAQoAHRYhBK5HCVcl5jElzssnkLqXzVK3lkFPBQJpQC2aAAoJELqXzVK3
 lkFP/8UL/RsRUSRnehvvpzMWT0nhllOcXeF6+qvVoyOV8NZSqZkfmeCn4u9EIM6Ov8ThiHs8Yd9
 SVo+BaVYsRqD4XPadAYoX7BcjpzhkHzESWjwQo2vjJRMjsGfP8W4WPTv+59w/WE+3cY0yOSmSy4
 CO9VoV975iWwfysgWTmaTkNfOJZjwsVTPGWwgNrkX9wzBSXW15s1weqjWtx6MrA17T3BUEQsIiT
 Y6AtSyAe648ALEfaHeHnloxe+X5BcFNyjaYjr3hTk3myG5BoHdpemFobJzs8JUNSC5puAMRZA1c
 WL/lfm/sZDJjVxm8OpkOlY2VSrWj4R6QPNxMf1OrvKyqS38Z4mHg8yYmVmdjw616ZFooCy+7lTl
 rvUnfAMBAPN1Ry+6yDLMKfb7GGg0WdU/FTfzkqoc/AW8rfBoK+zHPPT31NOfGR9oQwkONpuSGw4
 9zsDqvQU8bZVGO5VA5ivmovnSPdQfe+IT5sk8vxWqzhjTpeRuOPa6tXbWwuO2QcFPs7ryixJta5
 Z4=
X-Developer-Key: i=joel.granados@kernel.org; a=openpgp;
 fpr=F1F8E46D30F0F6C4A45FF4465895FAAC338C6E77
X-Endpoint-Received: by B4 Relay for joel.granados@kernel.org/default with
 auth_id=239
X-Rspamd-Queue-Id: 86F86C0007
X-Stat-Signature: cuhmpijt7icoa4mbm7o7nuj64fo8kkgh
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765813661-422890
X-HE-Meta: U2FsdGVkX18zXAIqlkYj1A3b4ZTQ6aKhEekOlmHTOvvIlc+xnmPZvqwR0ArPQQz13Cich0SzzzIW+7W9z4HFj7tTyu1L0YOlQGILMZzlvDxQx3WANj5JDKLyS6m8GE557xInUcacXm+fxhuNkO1EGWmYXWUIr2q5tiFCfaxTXtHSne/GwofAb8I+G8rolSA7KoX0JHwDV+W5Mi3WSSUUCJyFlzDt1eIn1V1t/ThFS/SEk+cSjCkv8+oy4hYmDJ1U651x5nhvPUI4RlglxTDwRGqiQFl7cyoPyk7FpWz4iUub5fjsF2Ha5gkire4S2ZeVYfbuYbmm3KKbHPHnJ5q8BgKYhDDLU80GqYl70xwBFUqkavYvS5RXgTzgdW5Q1QSMlZc6wwvBQNxjna89fr46cfYK4369YJcU7X/nU+2SShZnuIgl7ys8b9RkGhrHaMHHUdADEqbiiz991yge9pJgVD+cV8Zd8gMElAiRQiafmQCImmx3KfEqni/IIqki9+1Wt2qs/fgVTkFZvFUN8Nug1jqVHa3te+GsAHBwliC8RR4kfEr+KoZWKJVgFzz4Q5HyKq2d2NqJx/+Gt9xXtuoFRqCnBegVeiTUB+1bpr+X+3cVxcs4DiaL2kgN/zLL6faYAEbTj/8LYO2haSCVUZ6eumK0ITl042njpuSwz/GHW+5ZwpCk2ZY9HUWNgnnEwhuf/cWbx42ucKn/DD9pjLoj6FG2e5YboinCCAib4wUdayXiI2NGPasPWKozch3Ik9829TBA2xqtWIrgxENp33wkiLJ3aSjflcn5oDXzO0fza4ZBY8Bl24lbSJOYX943Si+wvDgwFNQp21/w5kH/x6KAUQ/q955hJM9JbD44/jsV12tvS8dh/2zdJnXHMJXc9DIUmFdE16ZfeEYGJeWfeNX9jLn1PWm2Y/4ezOZq+Ipwfi/s9WJe/cG/32K/FSHK/LHJ6UeIxkwObaJt/5bvAW3
 q/cdyOd5
 Zd7sH8SD3CivLGXAOaHwNbMIIG5mvc7fRpkcD/0G1GxYRFqAmQ2cyt5b2tyOcPa4yoRXPFBkYFdziRMHFZR9LhomLnqt2od2ezGTJr31WSY+UZe7GNSsq5FSmLzZGD7Zvb/5Ep6xCZm8gM4II5OQyNteYFV0oRdjUHUEGDl6iM+/iprvjGjpIhfdcuGQAovedJJSHJVVhKx0dh+RWX5JSpVV1s01T4sWmrYktZAxJGr3BcwhdcODtD4cF4Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove the change in file mode permissions done before initializing the
sysctl. It is not necessary as the writing of the kernel variable will
be blocked by the proc_mem_profiling_handler when writing is disallowed
(also controlled by mem_profiling_support).

Signed-off-by: Joel Granados <joel.granados@kernel.org>
---
 lib/alloc_tag.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index 27fee57a5c91db8067c05bff974a9e801e0ef6a0..846a5b5b44a4e5f530605c97a200e03260e73d77 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -783,7 +783,7 @@ static int proc_mem_profiling_handler(const struct ctl_table *table, int write,
 }
 
 
-static struct ctl_table memory_allocation_profiling_sysctls[] = {
+static const struct ctl_table memory_allocation_profiling_sysctls[] = {
 	{
 		.procname	= "mem_profiling",
 		.data		= &mem_alloc_profiling_key,
@@ -798,9 +798,6 @@ static struct ctl_table memory_allocation_profiling_sysctls[] = {
 
 static void __init sysctl_init(void)
 {
-	if (!mem_profiling_support)
-		memory_allocation_profiling_sysctls[0].mode = 0444;
-
 	register_sysctl_init("vm", memory_allocation_profiling_sysctls);
 }
 #else /* CONFIG_SYSCTL */

---
base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
change-id: 20251215-jag-alloc_tag_const-dc9d7c3f7a8f

Best regards,
-- 
Joel Granados <joel.granados@kernel.org>



