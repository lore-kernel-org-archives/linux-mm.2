Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D993C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:00:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 941306B00A0; Thu, 10 Sep 2026 07:00:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A5676B00A1; Thu, 10 Sep 2026 07:00:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E1FC6B00A2; Thu, 10 Sep 2026 07:00:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 54EBF6B00A0
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:00:19 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E51311204A2
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:00:18 +0000 (UTC)
X-FDA: 85197558516.20.9D4F9C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 24FF540017
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:00:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ACpqjS/n";
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789038017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BvSsEcfuxj9lC5YTGUuAUBtK1T4naFDW4wq12j/K7Zg=;
	b=uYmI94LeY6UpBbQorMXf9MLzP8P+N2oBRoB5GL7/pHfGefXjOLJfHKjxlj4+MQWjhkljXk
	aIxPzVtfgfkbem5mXcu1emlRic07Dpe3MB3HaAXsCPvsUsQLGUeLCkU07niASCVuCGqYT0
	08gebxQ0JHt+fwtIC2gWFM22kAB/J+8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ACpqjS/n";
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789038017;
	b=ukApovi9At1fOUGX0bgwRKLA9qK/UswKnjl3ldyM0Rb/+GrScYda2rA2wToN4KD/hD4EN/
	USQwxztuROXXeDJ+EudO3C1vuEG/IdthU4H3o+NNq3PSqtrtlBVXfo24L+A72hFl49QRQ1
	nKpEG1PEXRLsMrE0YM2FnuTRDsOoXWk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BFE33601F1;
	Thu, 10 Sep 2026 11:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEDB61F000FF;
	Thu, 10 Sep 2026 11:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789038016;
	bh=BvSsEcfuxj9lC5YTGUuAUBtK1T4naFDW4wq12j/K7Zg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ACpqjS/n8i5Rs0K/trhMuPDITZaEeJ/fcxuD+p9zdAxP4W31/1XfwhlzCkzXJHkGG
	 gzO0oUz75n7IE+L9bMVIrHzXtaBHmckwqlWsdZEWxsgMVvLTEWTuWdwxjEbXcPPS2t
	 TtbO1dScBxocTHTkOfGoo5xfBf75f9UUT4/myO+Fcq1ZvssPeEoSr/XYDnHb954LTf
	 +/MTUN+XqKUIFzLgV7PazYA4RtDklB2APxgfddYW2dtoiYUiVu8+sI+ZRy2ktSHEE3
	 FXkuwFw5LkR8z0RpvHIMVKHBUfaHtbQFnjvtjmiqslNylxMe4oDnWLEDKHb5bMzSLK
	 oGWFhyhBT3hAQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 10 Sep 2026 14:00:04 +0300
Subject: [PATCH v2 02/13] s390/chsc: Use kzalloc() for the SEI work area
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-s390-cio-ready-v2-2-e931086fdde1@kernel.org>
References: <20260910-s390-cio-ready-v2-0-e931086fdde1@kernel.org>
In-Reply-To: <20260910-s390-cio-ready-v2-0-e931086fdde1@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Mike Rapoport <rppt@kernel.org>, 
 Peter Oberparleiter <oberpar@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Vineeth Vijayan <vneethv@linux.ibm.com>, 
 Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 24FF540017
X-Stat-Signature: f475h15wxfzfsj14swdgk9sxwa4eee5n
X-Rspam-User: 
X-HE-Tag: 1789038017-32277
X-HE-Meta: U2FsdGVkX19CU8vm1Dwu/xoybN0vZreOnDN006e2UjpLks0p5JcqyuLki5UZc78We2zJMtQPaCTsPLC2kucGGbab499YmU+/wxypPqkqu+0v/n2GKtEbVn7AFBt/ayEj55GY1EHMOXKZgZ7vhen5L/JqznMQ5NkxWptRzWkbJKB5lFd4lXgTge0mDlMa+64Wqty99Ro2vJnGsZRWdU8TdHSbOEuLlYkftQcGSx+/JSfuhIRBbE0T5LyJvCofYMMlieZxQFQuLpne179SMUt+WQ2U+rXs6I8+2/vEWjy6n/r/RvF4nShVr25rQeJ04oWWXKBdytHQe7yqjFnUXG++HqkJuGKSWMNVTAUTx708OCGNnUHFx8OiSGzIxc8XS3Be87IpLoIVEssK9XpsoiVmEs5N+7nhB6Vw6rFvg58xAjZlnbpRBzvo2bpnCAGOVCwIxUgICTgyu1mXCfKzNAzAz3S3FJpkIoCsdNF8e0V1qI/N5eL3MWLydVSqNw6/CVxe3n43zKBizO3w6M2CRJuXHVCiChScEJ9qL7kdBB/0GGWUl4iput4lKAuukaNhkxkDgrgYKjxBaOwddAcL2LjEbZMWAhzwxbNSmV9E5gebzH5YKSOggwtymY2bX7BInx/3LKWrDH8facKuWu6Bw74TfmNXvtqTEYtoe37AiCztGZdkH87rnGWFkpAGlsVLJqnlLqYW42iJYhRwjkQnZzKiigBYNc2BlFPEjvAnYPueDj+5NZt83bRVowpFn8mrFXwZz82ALUG63pv8qPk9ycTDLm7BuMtfmvBqybdqUl0aLbmtJaHtZQfAjNgKXggdlfk7DM1lzXcDlVlAwj0aSnKj4ct/NjjOGNVMPU8OBKHP3t0BUuTOVIVoq81aC454npSBLQAphJUXT5AoSKBo8Nk+GpVhWoHsRh8MbJkA6l04tUFnUl9fbEUup4zPuKICdaLWaqYoJPcDJ3INgiqhX4R
 bK3BBsTn
 3YxCj2l9A3LfmcoHcx0AGzaEV8W49wPjOuMMM9qL5UH4AMoR9fK2bJZ2uy1+KzxUsk7pahOH51ua+0DKc5SLmUHIiP4pmbvlsc6bcfTNuxU08w6Gupd908issl5T6WDedqDTdTa/Ir/jaSAQ6N8hGBW4WgotqVCSJFj8uhxElx5s/j9VpK1cvB1HWO5KYmkwBAQ0B4rp3PZMKNYvDrk8op17DVlGIQ41qMPNGvbx2z/QbheOE1W8sj/N2ZdzXw0X6VwlamQS5qaXuJNE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

chsc_init() allocates the work area for store event information data.

This memory can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of get_zeroed_page() with kzalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/cio/chsc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/cio/chsc.c b/drivers/s390/cio/chsc.c
index 60a4a7e6086ce..c3186c0a372b4 100644
--- a/drivers/s390/cio/chsc.c
+++ b/drivers/s390/cio/chsc.c
@@ -1142,7 +1142,7 @@ int __init chsc_init(void)
 {
 	int ret;
 
-	sei_page = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sei_page = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	chsc_page = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!sei_page || !chsc_page) {
 		ret = -ENOMEM;
@@ -1154,7 +1154,7 @@ int __init chsc_init(void)
 	return ret;
 out_err:
 	free_page((unsigned long)chsc_page);
-	free_page((unsigned long)sei_page);
+	kfree(sei_page);
 	return ret;
 }
 
@@ -1162,7 +1162,7 @@ void __init chsc_init_cleanup(void)
 {
 	crw_unregister_handler(CRW_RSC_CSS);
 	free_page((unsigned long)chsc_page);
-	free_page((unsigned long)sei_page);
+	kfree(sei_page);
 }
 
 int __chsc_enable_facility(struct chsc_sda_area *sda_area, int operation_code)

-- 
2.53.0


