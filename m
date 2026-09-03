Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 703F7C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 07:05:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FFCA6B00D0; Thu,  3 Sep 2026 03:05:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B05A6B00D2; Thu,  3 Sep 2026 03:05:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C5D26B00D3; Thu,  3 Sep 2026 03:05:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1FB4B6B00D0
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:05:11 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B03EA14045B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:05:10 +0000 (UTC)
X-FDA: 85171564380.01.7EE341B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1E9594000E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:05:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iO5LnTTW;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788419109;
	b=Djc43WeU/pUO2F5N5RaB+45h5WAB0YDy8rOW7T+8zKRdwYruexW8bypwa0gc6oM7zclm+6
	fHeuMPOEMy2q/oHX1aAvzM+iyEI/vvzjc6DWeQEu26NzEfm1J0bMN8pgb6f9mpqdHKoFUF
	5Zhma+mP1n3RD6nRfZ8MRs34CUh2dcI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iO5LnTTW;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788419109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FR6L9I2AxH4isrQSTF3YV+9BlpxJIn0nFUvL/QzRmog=;
	b=ykKwqLao3VnVGangJufr42o3MkX6CT3G5lPAW5jMfnMMb15YWgbgJwcIsikb7gvkDrDTFN
	svNySq0Z+OrCsrmjdMIfIV/B3IjOUMYlkEIGLGpNp6a7LOomxaJbpsU7uIISbDFXnl0UPP
	uN/CqjPby5LuWVVWclwUnJb7VhxzGZA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 93468600C8;
	Thu,  3 Sep 2026 07:05:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3DA1F000E9;
	Thu,  3 Sep 2026 07:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788419108;
	bh=FR6L9I2AxH4isrQSTF3YV+9BlpxJIn0nFUvL/QzRmog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iO5LnTTWLL7eHjkE5kGyYlcZY7NmTUlyPScbdDsgjxLfHAbUIfO8Rn+0hUFKzmdhk
	 czMaBalQ4XAoQcPqae6ZcnqUzdSBgGq7KYh1rtVMMpXcwZ+7nCQV/ywMLr0Se/fPEm
	 ZIYC/cWKv0trq+ZBhfZ6KKrlIbHqVGFyUuV+UVTbCN2xFZWYp+jS3lxXWTAQnLs91l
	 TWrW6UxpXEnsa3weGzn7fPUPJs2ck+ezX5h3Rs/uLsyhh4lpGV/dlegboRUcYo7SL4
	 rv9DeV/IbTB9mI6XuGnPlg1pgV4wdA8bktSiHRUqaUYSYOlFKNs0+eRm0ufFVC5LDs
	 m2wC6E5Myhi4Q==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: baoquan.he@linux.dev
Cc: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com
Subject: Re: [PATCH v2 2/2] mm/mglru: make retry logic explicit in isolate_folios()
Date: Thu,  3 Sep 2026 15:05:00 +0800
Message-Id: <20260903070500.76379-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <apjM5ZBOJrdGQM_g@fedora>
References: <apjM5ZBOJrdGQM_g@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ojedts4wm51bh3xg9dnwk4wjdwnmpskj
X-Rspamd-Queue-Id: 1E9594000E
X-Rspamd-Server: rspam06
X-HE-Tag: 1788419108-985926
X-HE-Meta: U2FsdGVkX1+5QPYhRA68DnWOpL7SQWBK4kvXHzAn+O3VngfIr7NTsVznGrD3PGnvo8lJbbPB7qsEAEbuhF7JrdfDbMseUIlrDtrA6c6/kE59NVG6ORh7CJwiYRB5nxM0uWkueT0SnkYqC2ZUGzvlZbzpKU9tH3A+uCWcd1tBiKN1tgCqMA5rla1KQtZRcVIW1rlGMpf7wNlKKER94grbgbkTEaYW9nRzkvSrCyBOrBD6doNm1Q9AMKaBLXAL8ttgTYhRlMV6SDML1/Y1+dfIEXpkeKVUaKVO8uLTiPi3oZQ/9ybNWEAWiDWKIxFLG5K4SthzkeKFd3KJP8Qd5zBRCoO6SK3F93/Fs5QJ1qsqoNiCkS54gCx9S79hmsxrX3qhtiN2U6sbBVZmofcSyp0U/LpAHb4apqJFtj6knhL+d6cimtdZdIGFbxcUg25HsUhGlcqOyQ8HRFkXo/EJ6sXrViywCjo4DC6xkUL3TVgllIPRkEeHVt6gztm+mK2rT+xQasRK4XQ0BVdT4BAiZLUJWTaBlk6d7yY2j+M+knLXgOrMmzlmBgRwI5/PPAFo/tlpS8bIhslcPTv3WgzZcWVSBZolfV8DcNs5AmLDct8ktgXgS7DYouaAvOIq+2XeTxH5OvHlYsZHSxbo7l2R5mRl+VVkzWpYn2/tMMz1QrGN3FQ9r4+2Tie/+/9BbvAoxhJBt8Mp1GX2jr7AYy/VZBFUU2h1mONcJmQ5IMpksNxV70AvZuuAU5uTyTxAmi9/bcJ5GaGtnP5330g6T16VQWec6Ku4Mvk7fOJPgfv6WTrVSllpu2eHPdv3plnC8gUKnjKrfOgV7lm0/DLqiH4/M7v/Bl2f6dCeYhtwuwxAsZe+3/Rop+RgnC/EJ2F9sow2mMDccsIJj251zY56fpH7sWPknC6w5XVvNA7ffL41Afzi9zyAAsx16G9Oju7IEkimus7KClGBVd1SvWndmFbzAqw
 gFObTlHu
 +eQK1BgamX9LDq/bU8o9qoP43/FGyNihQiO0++tYzjuzFuBMYzWGJcGenYyHde+rGzkfDM9xZexVOU66umKazcAgnVPWXUXEJ1d5XaGADXZYrDOctTvsNWpUIwT/cIbLDyCWAFZFG1EsX5MelQKaD+EERJpEyyj5NX2dwuCZwnKFnk4UF3jnGsEdY2FLjilvheml7PL4sA8KQ7R6K39IHI7kOu6uLDku0QxRXdwEd894x5TPFKDqZLKYc3hcyFzrNHEGe4Ae6zlh/WA5eo93vl3qz4YGQbUyUN6rPA8fDAd5PJox7X4LvFUTIjPPMmbg0+Bsg88gn6BVD2xMCIwmdzLqTKSa7PyY8oRURsOg/E71cY+BusHFgP1LZFRgQCUI2L2dX84MWjgtPafWu32EBAxesPU7wjdajSFf4vC2mV9i3CD0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 3, 2026 at 9:27 AM Baoquan He <baoquan.he@linux.dev> wrote:
>
[...]
>
> Thanks, Barry. These number is very convincing. The retry for swappiness
> 0 is worthy. Then the patchset feels like doing two things: refactoring
> the for() loop; improving the eviction for swappiness 0/201 by adding a
> retry and this also makes them be consistent with (1, 200). While the
> cover letter subject, patch 1 and patch 2 feels like it's not easy to
> match them to the corresponding part. Maybe merging them to one patch,
> or rearranging them? Just personal opinion.
>

Hi Baoquan,

Thanks very much for your suggestions and review.
We have two patches:

1. `mm/mglru: make type fallback logic explicit in isolate_folios()`
2. `mm/mglru: make retry logic explicit in isolate_folios()`

One handles fallback, while the other handles retry. I think this
separation makes the logic clearer. Could we keep the current
separation?

But we may really need Andrew's kind help to squash the change
you found below:


From 1fb8046662a8b23be1b87a21cc9964e9ff9e1eb0 Mon Sep 17 00:00:00 2001
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Date: Thu, 3 Sep 2026 14:48:52 +0800
Subject: [PATCH] mm: revert slight behavior change for swappiness 1-200

Baoquan's review found that we unexpectedly introduced a slight behavior
change for swappiness 1-200. We could now have a case like:

1. First scan -> `scanned != 0`
2. Second scan -> `scanned = 0`
3. Type fallback

Step 3 was impossible before. Let's remove this possibility.

Reported-by: Baoquan He <baoquan.he@linux.dev>
Closes: https://lore.kernel.org/linux-mm/apfZQE1X6zGAsBb_@fedora/
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index bf2786c7247d..ba7adf36e69f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4939,7 +4939,7 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	 * We are running out of the current reclaim type. Fall back to
 	 * the other type if allowed.
 	 */
-	if (!scanned && type_fallback_allowed) {
+	if (!scanned && !tried && type_fallback_allowed) {
 		type = !type;
 		tried = true;
 		type_fallback_allowed = false;
-- 
2.39.3 (Apple Git-146)


