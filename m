Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEC5CC531EA
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 23:44:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F2F96B0005; Thu, 19 Feb 2026 18:44:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BC9C6B00AF; Thu, 19 Feb 2026 18:44:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C8FF6B00B0; Thu, 19 Feb 2026 18:44:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0B0576B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 18:44:43 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C94EB5AF4B
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:44:42 +0000 (UTC)
X-FDA: 84462838404.09.F81A997
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9E2951C0011
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:44:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=mssola.com header.s=MBO0001 header.b=o+5Q+56u;
	dmarc=pass (policy=none) header.from=mssola.com;
	spf=softfail (imf20.hostedemail.com: 80.241.56.171 is neither permitted nor denied by domain of mssola@mssola.com) smtp.mailfrom=mssola@mssola.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771544681; a=rsa-sha256;
	cv=none;
	b=Lv3XjQN1Zkte4ihstGE0Pgc9XNXM3MjsBjT9BDid1/xUH613IPGuEOWqMILguHmPSo8ofg
	twUjjcGH7Rx8Jj+wDClMx7GWIzbmnuyPbJvsQ8EumocTJ9R9cgPc/9hfmhMQvQ0PoiyTYw
	eXrBnbet7WNBKpo5kxxL4nFQn4+TTbc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=mssola.com header.s=MBO0001 header.b=o+5Q+56u;
	dmarc=pass (policy=none) header.from=mssola.com;
	spf=softfail (imf20.hostedemail.com: 80.241.56.171 is neither permitted nor denied by domain of mssola@mssola.com) smtp.mailfrom=mssola@mssola.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771544681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cWBvxnCm8c8qlcABF/W4RvtDjfPmFUG7UXfKTt4gQJs=;
	b=mA8SAb+QX3F+sxJqWmwd4k4x6ROG0CFj8ZnFP0V9vTPIMhvF7O+3HlyDXu8fW+mLfJqY76
	W4x1GyM0kqOmPd09ZDLoC5anOvErMt/c4sKDQD4gXqevwmJIG4c+rg5GMq2ZRC5CCzPzhA
	sR5EUvne1e19FCqTRPM6JYcLreZLVGk=
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4fH92q6B3yz9ttX;
	Fri, 20 Feb 2026 00:44:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mssola.com; s=MBO0001;
	t=1771544675;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=cWBvxnCm8c8qlcABF/W4RvtDjfPmFUG7UXfKTt4gQJs=;
	b=o+5Q+56uwoCko1Iq4A51scATGp6MKFOboyCEknSoyn88ysxD2UICbJ/qKQqqh8jqFW9xob
	wJha6RIIvjnL+fPT7JyOAdu6hKGhyNwFL4BWhaxIh4CdxeqxKV84aAOPfqlbPy7kFCqV62
	5eRoKYT+c+3NF0b2JHf9ypZVvIxOJq6toWYiEXacnN8p3baPLAfo4ygLMonzS2GhgLN+aC
	XslNPYIZdyTzxw16vfrsDgf6kjeXcRxiKltyNP8SaKk9TVEb9shyMJfaONcdVRgXnEglFE
	jBMIfdGZdsdsqvgJsaHZs++hObdawWoTOowZzf/wt/ifDVH7R5Fe7xgaQUKyGQ==
From: =?UTF-8?q?Miquel=20Sabat=C3=A9=20Sol=C3=A0?= <mssola@mssola.com>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Miquel=20Sabat=C3=A9=20Sol=C3=A0?= <mssola@mssola.com>
Subject: [PATCH] mm: fix typo in the comment of mod_zone_state()
Date: Fri, 20 Feb 2026 00:44:07 +0100
Message-ID: <20260219234407.3261196-1-mssola@mssola.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nt3mgai88aid614p9a4g5ed6h5m1c6ja
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9E2951C0011
X-HE-Tag: 1771544680-903838
X-HE-Meta: U2FsdGVkX18O2se9VG/AozfI0p9PgKwKLUewcSLQ+kA4Sr8YjAvGSqCaBcZyNbLwseWp9UsMoe64w4SkrqLudZkBUasMUR6Zwn7MfwX3oa5F4QgClcYRxaPDhZO8HjKrXluurPxoIXLL2Q8jw7QWzAnjU3Zmja/xKBLitNuNMaaFeDeyNGlAMrKliZmltH+os50MhEUJko448HmcBT3mdDzMnvUFhfmGdvKJqoGJKRrNpPO39fz+sD3q9j70R4LaSXtYWErkY2+GmuAbeTsdMQADNTj5cSQWP8xR9cCWJzJ4HxnmipAEeO2UxlGgH0nZSAsvzJct2AUFMRf16s1FgKQHFvwSc7Td76KWtNDOyt1xKbpW+xLnQrTANKdHADo4/RJURFSXLu/HZQBq9SNm8Wc4ars2FXTmH1RU1WWsztvvSlHG3bL+GeHySaxBBfhTeLBEZkQiT7Pc87JhciSfOH9z6FNAmRljVQ2aFAutBNUF+wx+A6TsFIeXSIMGznbG+kSI57aIu8/f8oUf/UFAj/v+b9YnU0nhJCKvwx2QzEHwQTeusUatRhCWlnd14Jj4gCKo41l1s6pNGuo7Ze6v7xWitpIJO923+nKUVIyeBfDInyfrY/AqYx3UvggX0CQ7VvfNSkBM0jx9eAo5v7lAn36Y37YmoF24+RZ0ZiQ0Al6XLo1X8+P8sV1wKaLc7Ir+iZDNC+FK5eK8PDm+3NeCEqHv/ioSYoHckivEXX7DF38lQ/N3KXDsP+TlKxMI6KVR7SQnzP+luAG8F4kNNpb0hBwn5QJiLWhNB4TjOUnxvHAiW/CwPgGQugtiVoMHGiWrvP0Z//JYBa12V3XxCtA49SG8n4/vMkuU7qxXmLS471vKswfcfoUPU8m9Gg0MfiGP7NtL0CaD99cSANQneK4rgodGiXjqduo8wdzXSr92qwQR+8Uocs/C11zLgLp03mCLxj4lPiHiRpafMvvFviv
 /Z97X4KA
 EEDuE/nwC/1P4LYTXancFxh3SPC1CZuTJO3MevL7K8ewwcK0mXx5JIAT7vFeiXhbH5K9xGs9KxncOYH433t2bpkarzGwoRDM6t5+XJfPDEQ25/M7U6/uWZQm065xQwSs8M84fdvf6kApzpvPbWZziOLRtnp2UOhTAXJ+WGDGBWQUNwYNHYjD40PaQxtXyS61/P06/j16dnX34BoPc/WmRkIcNAfmKHqez6nta6IT7Tvz/0xy+uiR0W9sVnNsktjbo9XFMbWneGS1Qh/vU46lmFuitmHLqkaw8a4zC3rdHIXbR8JmioZTU7r/cjgx1wcPKnA6FBC0bn5R5t0Y8rVKGeU8L3pgNCOVapX0tI7ofGRGAKPiiaBE4yEtRfRb/pGSAhzBXOaq8fUrkkj/5L05xQMoOJqRjqncCItqRhUY1Dzbl+R1swBb5DgFZAyVhL6NXPVIOA29cLN1f2tqeQD8vzpk7aeH7nWtqHFXkrNmnyv5J5x9E2hzVV2PCDElxj2s8uX5tx+ilT5u6kAtveDKrTJeYQeBrnpTBD21VTVfXTfo1QSJRq8h2o+HSTA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the proper function name, followed by parenthesis as usual.

Signed-off-by: Miquel Sabaté Solà <mssola@mssola.com>
---
 mm/vmstat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 65de88cdf40e..f69225122768 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -547,7 +547,7 @@ EXPORT_SYMBOL(__dec_node_page_state);
 #ifdef CONFIG_HAVE_CMPXCHG_LOCAL
 /*
  * If we have cmpxchg_local support then we do not need to incur the overhead
- * that comes with local_irq_save/restore if we use this_cpu_cmpxchg.
+ * that comes with local_irq_save/restore if we use this_cpu_try_cmpxchg().
  *
  * mod_state() modifies the zone counter state through atomic per cpu
  * operations.
--
2.53.0

