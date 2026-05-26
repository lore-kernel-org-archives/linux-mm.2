Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62F73CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 17:34:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5A396B00A3; Tue, 26 May 2026 13:34:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0B666B00A5; Tue, 26 May 2026 13:34:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B208B6B00A7; Tue, 26 May 2026 13:34:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A265E6B00A3
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:34:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 32F8D1C037E
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:34:28 +0000 (UTC)
X-FDA: 84810270216.01.1846467
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7F67F120009
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:34:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KzZJJvMW;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779816866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vqxs1I5bdTAYH0V+dlG6/NnYH/vhR2cqVACl9PGhZ/k=;
	b=fC20cWOZV+YVduV1ZfGI2QT2mK9jegaNV7hW60IwJzMKlmyLxLPT1K73LgWUguNHWlm0jG
	zMk3anvSjGbAXRoNvNe+AP5sa1r1T+7T0g1MEriWoLeve++yk6wqGUNe22TlmcjDHK9LrT
	EtaBA5u88leBNURm+XIlCvra3Ez8dSE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KzZJJvMW;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779816866; a=rsa-sha256;
	cv=none;
	b=Due8MmkLU+HOEkuvUUb8xN8E3J3TPJTs/MBwHXcL+xkp8YnwzSJXafIOxTpnEUXV5h1z/J
	lVd1q5g9t45mz+J97GOD1glvvOQDIoO/R1branaMXNERCfYKDMyCH2fTXHP4e/qDItfeye
	vvuA/+kLSq2zqTtrK8bcgUguLzF9S8Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E97BF60018;
	Tue, 26 May 2026 17:34:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6661F000E9;
	Tue, 26 May 2026 17:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779816865;
	bh=Vqxs1I5bdTAYH0V+dlG6/NnYH/vhR2cqVACl9PGhZ/k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=KzZJJvMWPr5/qGRanYp6AyRxaSY6hs+mRVemb7s5u6BuaI84G91vRRoUA50a+ohct
	 a2aHo91a7jMToNT7aeZL0kWz3x78nIZxrSs2EQhHai4fDdaZ6Qy7WEedc6yy8gy6ch
	 tzohsl5Uqxi9Qq9Uc8dwprEFu19U0WtcsjZH1yag=
Date: Tue, 26 May 2026 10:34:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>, Li Nan
 <linan122@huawei.com>, Xiao Ni <xiao@kernel.org>, David Laight
 <david.laight.linux@gmail.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-raid@vger.kernel.org, Christoph Hellwig
 <hch@lst.de>
Subject: Re: [PATCH v2 2/2] lib/raid6: use kvmalloc() in raid6_select_algo()
Message-Id: <20260526103424.0d884374dee8cbc4f9f17c3a@linux-foundation.org>
In-Reply-To: <20260526-lib-v2-2-ca3f0fc24b14@kernel.org>
References: <20260526-lib-v2-0-ca3f0fc24b14@kernel.org>
	<20260526-lib-v2-2-ca3f0fc24b14@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7F67F120009
X-Stat-Signature: whgt9idwtuymgzhuustaaob3744j1ner
X-Rspam-User: 
X-HE-Tag: 1779816866-558784
X-HE-Meta: U2FsdGVkX18xJkXH6KFtAzWnXkcQDzgWeYlc5u4b9n5EWm/60fRl7c3JP08niqPMmVffKA2jrakdhaHvP2BmtBrnfQAuhXBTxD+EA50MwjUPyPKR1TOrHkyky1D2MWouMMdbvhqxzTJIY2mmgx8DHGxAMkE0SskfRM7EratpVb9ktzHbYE8Sc1YhjPBSU8D5y2fz2aNi5xPiYgO8eg0Pnhs4OS2FhNyTlKOkNf77/OI1bZf4TGndI/rq4+cUZpHSyf15fdk0DfZqSRhuDLYbTQDpR+DaKWCgXuM7YXE5QKJr9BSaVDQa5D/5rQd1xuE1zgK/TbksqIzb65wS8/1VldjWAwloSkeBEUE/RCiEVJwTPa1wUWMsSjWY2ln1bV+eLnV1yqQlmlr+k+Y0mgJgjK3SJstz2nPCIYPxqAhfVuK/MEm+QVD/wYDbHRyqthc/xXITrCNOv5sjFBYqjs0LgUOqelStSoJ3SNF2Z2ULt6y7k6ydWt5QTGA1retV2WNAQMOAU5x+6Rhei+8gh65zXNYEu8fmzhtx+truhiMq27ic2nk1TAGf6cdKNK78W9f41cvDnnrC0LsiBYHZrXNSgkihZ0OxkTBSJ4ga/Rc0wVg2zLrTH9BtFN8k9uxX9etSOLO/VJiMFRdxIeLSIXY+zeIsg9XbsaO5jLQ2AHlA55OxuAvE6BiSowK3GjGex73UEYrQRQgikZxHRUXNUIhgVeeXGmQotHwU4w89QNJDn150cQAbqw5fRahAtIsMmRbFnR29we35+1UIfXzcaW7h7oVO4wXVkC/LOLLGBmyorA7LO4qbj3ePviNJrZ//pwFlUQKAOdmL4693DTK2hon/ZPGaOLz1aTvdfrkoyMQLFbIcZGxet9qbmx0MZrHKrtfX5f+U9Yo3SGkvKvlRNYiGRogvdpeAQ21hJo5UpqMBbWH2FWZgG4VeZeviEUBo7pnDe7gzIUgt40qPRi/olem
 M47IbD85
 7ofHjXq6lmt7TXMqlanJpTumH/OyELn/p63FOVqV4If5Smdhyd6ZCIISP8M4DiAgNa3a1UdhRVuokTMQywSGzYf4M8hIBR8e1wL9CtW9MWPP2CYfE2iD1j+AaT3VGdD2lDfcvdP0On2d+O0pIVXWYey5DP5eaBXLT/u6lt/em5A5p2DGvHKrFG0LcA81l6FGUR1l3zKg1+7/8FsiS81A4BsPZJz830gdtI43+Y/kKfkFHUjClWmsTVhDxbxECcM2MPKhHZ/MuLyWIYE8mEjHbBV6gstsaJ1FGvMmgDcD6goHXBANChCVDjXr1p9lrSACGiPAWW9j9mNYgxePyxZrMoWWfbjhzc3+xAs+e9KLObutjLAM/ttW6MAh++Qr8Lr19y75A/Iupx99EbC8Mja/OubNvs+B9xC+asBSo7dB7tj5wYT12tMMClgtnVXHwp0QDrrt8HialSQjSG+Qkw7Vh9HR3uF0An//fZMSH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 26 May 2026 15:50:39 +0300 "Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:

> raid6_select_algo() allocates an order 3 (8 pages) buffer that is used
> as a scratch area for selection of the best algorithm.
> 
> This buffer does not need to be physically contiguous and can be
> allocated with kvmalloc().
> 
> Replace __get_free_pages() call with kvmalloc().

This one needed some massaging due to hch's "cleanup the RAID6 P/Q
library" in mm-nonmm-unstable
(https://lore.kernel.org/20260518051804.462141-1-hch@lst.de)


From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: lib/raid6: use kvmalloc() in raid6_select_algo()
Date: Tue, 26 May 2026 15:50:39 +0300

raid6_select_algo() allocates an order 3 (8 pages) buffer that is used
as a scratch area for selection of the best algorithm.

This buffer does not need to be physically contiguous and can be
allocated with kvmalloc().

Replace __get_free_pages() call with kvmalloc().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Link: https://lore.kernel.org/20260526-lib-v2-2-ca3f0fc24b14@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/raid/raid6/algos.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/raid/raid6/algos.c~lib-raid6-use-kvmalloc-in-raid6_select_algo
+++ a/lib/raid/raid6/algos.c
@@ -7,6 +7,7 @@
 
 #include <linux/module.h>
 #include <linux/gfp.h>
+#include <linux/slab.h>
 #include <linux/raid/pq.h>
 #include <linux/static_call.h>
 #include <kunit/visibility.h>
@@ -153,7 +154,6 @@ EXPORT_SYMBOL_GPL(raid6_recov_datap);
 
 #define RAID6_TIME_JIFFIES_LG2	4
 #define RAID6_TEST_DISKS	8
-#define RAID6_TEST_DISKS_ORDER	3
 
 static int raid6_choose_gen(void *(*const dptrs)[RAID6_TEST_DISKS],
 		const int disks)
@@ -247,7 +247,7 @@ static int __init raid6_select_algo(void
 	}
 
 	/* prepare the buffer and fill it circularly with gfmul table */
-	disk_ptr = (char *)__get_free_pages(GFP_KERNEL, RAID6_TEST_DISKS_ORDER);
+	disk_ptr = kvmalloc(PAGE_SIZE * RAID6_TEST_DISKS, GFP_KERNEL);
 	if (!disk_ptr) {
 		pr_err("raid6: Yikes!  No memory available.\n");
 		return -ENOMEM;
@@ -269,7 +269,7 @@ static int __init raid6_select_algo(void
 	/* select raid gen_syndrome function */
 	error = raid6_choose_gen(&dptrs, disks);
 
-	free_pages((unsigned long)disk_ptr, RAID6_TEST_DISKS_ORDER);
+	kvfree(disk_ptr);
 
 	return error;
 }
_


