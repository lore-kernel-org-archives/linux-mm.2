Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AC0CC55173
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 21:34:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DB866B0088; Fri, 31 Jul 2026 17:34:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B3BB6B008A; Fri, 31 Jul 2026 17:34:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F32706B008C; Fri, 31 Jul 2026 17:34:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CEF196B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:34:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 56D701C0082
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:34:25 +0000 (UTC)
X-FDA: 85050375690.27.50E005A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 19ABD40008
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:34:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ifDOQ1SY;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785533663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xl5DXrdTRqnaEe2rqitpQGHYE6K74Xb0gMeSAYrZW/g=;
	b=mfyO/f+UuXVSL2m5U+BOexL2wugvqY4kr5wxz1dYNl9AySsQtbZ9PiFNpY9Rmwt5ayZGIJ
	nuT6sE2gnz/FcCf6ACEGp27KvmwFg0NiNTc1Yut/+ND/o2OY8+ZYUnMcRXkFMqr+JBSjA6
	ojYbcJwpOgEkWiyabQrF/PSO45PfF/Y=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ifDOQ1SY;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785533663;
	b=H+YdgD4wzk+VJLB5+MaRZ1WXhjVfBlWdutmDWxl2wZhdqmrFYzexmm4SuVrSFmQmEHMF0J
	nOX7OFQZtPWazr5XH9Vqv6q7zidu5a2A9XYZt0dnq4hgeEq27+deKXuesFblZRXLo1SveH
	YHktIQ4NcYBSk9dDyJ7Z+/D3OTp4bCc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B989C600C3;
	Fri, 31 Jul 2026 21:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1161F00AC4;
	Fri, 31 Jul 2026 21:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785533661;
	bh=xl5DXrdTRqnaEe2rqitpQGHYE6K74Xb0gMeSAYrZW/g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ifDOQ1SYRWQ+Jyaxb2r8QDbxDjNXQ5IKB+Fl0NDIzg6uuMdiSx7JFI8ove6rmqEOL
	 YnQQy3r/XW2OW+0bvyW+2jRbNH8lxFMROAZyEwnq4m9iSRiPkflC+4kPOHdbQQzFiA
	 4ojzOu7w0B5zjxYeiuKNF3pIA2ojGzQtSLbS7nc0=
Date: Fri, 31 Jul 2026 14:34:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: pratmal@google.com
Cc: vbabka@kernel.org, david@kernel.org, sj@kernel.org, corbet@lwn.net,
 ljs@kernel.org, skhan@linuxfoundation.org, anshuman.khandual@arm.com,
 gthelen@google.com, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 liam@infradead.org, rppt@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v4] mm/page_reporting: Add page_reporting_delay_ms
 module parameter
Message-Id: <20260731143420.0787387ce2ca120ecee15338@linux-foundation.org>
In-Reply-To: <20260731193705.2902728-1-pratmal@google.com>
References: <20260731193705.2902728-1-pratmal@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 19ABD40008
X-Rspam-User: 
X-Stat-Signature: ug6b5z5ipwe8az3sa3wgq13e99uso4to
X-HE-Tag: 1785533662-69369
X-HE-Meta: U2FsdGVkX1+lwGQBR19KTLGfE1yagYgvpM3vHzwsYECqpS6kMlwfQxUfXd0a4U9aYSl/ENN7dWCgDd//RSmOJ7AAwcDwJo5hYiSOurCpcorxoirQGnUOMsfxVOJkDXzhc1VlxFvcbJK4+pzTuIj7XyRy8FjNPokjAIs10dvvkGBb3OATw/v7aDSi6AakF891qVBInlG+TWSgIkc83m/Q16xV1ojPgPd058Q7LsmN+gmkxGQ4g4fbG4dXN+Lhd0WFh0eB7aJVWBv2MS7nUNTo+z1CLNiCBbTPD3qRh7lVXJnm0lqNpMLVsG0lYcXwytyXugwn0x45sUi5WVfJy4bZrwfftVuDCTP+DBgY7pffrmrV6aAziq9mSqmnbLx9onFKbkYT/KWn7gA9wPczwV71as23DtFQi1p62P8zmys3HLklLuZ6OFM4PWDogtLgLr7EVgI1nDiDkFYzMYSwXQPj5GLh49mLO8yYslybk71L6DPYcd7Mt7G4bRjTu0fslIVwVBzFll6I3P8lPYDyptxrjaU4gX9ew8QUNCSkJeL4iAWWpg+IooDoNrOs5oVAWH6g51uBIWomKcAt4ASmuVJKL+3YMioDXyyo6IQELHOpS1S0d0jp8RU32c3DEZQiIGMrMVUARlIHd8U/mU8qUWY3bIYeXljDn6vHdDnXXLepguy0Aciw/2QDGO18t/o+nOOXTwFqiXtM5M8VfCNL1zGvoEJQ3WPgtBboBIqxuSp4ap1MJZfUZpdNs1YP4Mq4d8Iwhsh/V1ZpSMhOfAaT419U6YYC0qMgCQRaHuyCkx3Gmbm8emBfhVH0oZkBuMHfzhkaUsB5wZjv89usXpSr3yoDWetMB+azWWmbuCEhWTIVUJGY99ieOYr3X/7E/vJLTMBVLIk8EWaULZ6zA9elWiFBoaacF2CtVk/cOXHXCdGv0mwGxk5vKi4UNJWdghoWBL+H+DEvnoQB4TUfuxHRSXZ
 rFhgYqpo
 SOfE4XDxwj5ovG43xl1denKz3GCEPTzlESCm1XWShIcTD0JE9HLxPodEJyK/Vg66GVWsHJAiOBiO7f9Y0V3b35NWJhr2tYpUFtlHm5mFu+l2VA1nJsYQI0uK8E5EuyYYDVwvuZkrf03uVxeFa6/+kLAHAshvr1jygjDB1vKWRlIUS6icnjRF/HZvw57osKCnIpHqt6DFTZpGdZdJARPNxcXUHfrOHc1KyqFWO1D1TXAkc1mA50frivNUSEsoOqWsy7UeZwNIsZYj9hbJAsedyl7CylotAWAJANSzkhOExhuIweQ5U/mWuieCAsCOq4fDiWUkUEbcDnDfiT7IJsZZI08VDrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 31 Jul 2026 19:37:05 +0000 pratmal@google.com wrote:

> Free page reporting currently hardcodes a 2-second interval between
> reports. This rigid delay cannot accommodate diverse guest workloads.
> 
> This patch introduces a module parameter, page_reporting_delay_ms
> (default: 2000), allowing users to tune the reporting rate:
>  - Lower values enable aggressive memory reclamation by returning unused
>    pages to the host immediately.
>  - Higher values help batch pages during spiky allocation/free churn,
>    reducing hypercalls and nested page fault overheads.
> 
> Setting the delay to 0 is safe and execution is strictly gated by:
>  - reporting is only triggered by high-order page frees.
>  - expensive hypercalls are bounded by a slot capacity watermark check
>    before proceeding.

This conflcits with the just-upstreamed 0b45f6927a1
("mm/page_reporting: use system_freezable_wq to fix UAF during
suspend")
(https://lore.kernel.org/20260721005603.1710551-1-linkl@google.com).

Please review my resolution:

--- a/mm/page_reporting.c~mm-page_reporting-add-page_reporting_delay_ms-module-parameter
+++ a/mm/page_reporting.c
@@ -48,7 +48,11 @@ MODULE_PARM_DESC(page_reporting_order, "
  */
 EXPORT_SYMBOL_GPL(page_reporting_order);
 
-#define PAGE_REPORTING_DELAY	(2 * HZ)
+static unsigned int page_reporting_delay_ms = 2 * MSEC_PER_SEC;
+module_param(page_reporting_delay_ms, uint, 0644);
+MODULE_PARM_DESC(page_reporting_delay_ms,
+		 "Set page reporting delay in milliseconds");
+
 static struct page_reporting_dev_info __rcu *pr_dev_info __read_mostly;
 
 enum {
@@ -57,6 +61,13 @@ enum {
 	PAGE_REPORTING_ACTIVE
 };
 
+/* schedule work for page reporting */
+static void page_reporting_schedule_work(struct page_reporting_dev_info *prdev)
+{
+	queue_delayed_work(system_freezable_wq, &prdev->work,
+			      msecs_to_jiffies(page_reporting_delay_ms));
+}
+
 /* request page reporting */
 static void
 __page_reporting_request(struct page_reporting_dev_info *prdev)
@@ -77,12 +88,10 @@ __page_reporting_request(struct page_rep
 		return;
 
 	/*
-	 * Delay the start of work to allow a sizable queue to build. For
-	 * now we are limiting this to running no more than once every
-	 * couple of seconds.
+	 * Delay the start of work to allow a sizable queue to build.
+	 * We limit this based on page_reporting_delay_ms.
 	 */
-	queue_delayed_work(system_freezable_wq, &prdev->work,
-			   PAGE_REPORTING_DELAY);
+	page_reporting_schedule_work(prdev);
 }
 
 /* notify prdev of free page reporting request */
@@ -337,13 +346,12 @@ static void page_reporting_process(struc
 err_out:
 	/*
 	 * If the state has reverted back to requested then there may be
-	 * additional pages to be processed. We will defer for 2s to allow
-	 * more pages to accumulate.
+	 * additional pages to be processed. We will defer by
+	 * page_reporting_delay_ms to allow more pages to accumulate.
 	 */
 	state = atomic_cmpxchg(&prdev->state, state, PAGE_REPORTING_IDLE);
 	if (state == PAGE_REPORTING_REQUESTED)
-		queue_delayed_work(system_freezable_wq, &prdev->work,
-				   PAGE_REPORTING_DELAY);
+		page_reporting_schedule_work(prdev);
 }
 
 static DEFINE_MUTEX(page_reporting_mutex);
_


