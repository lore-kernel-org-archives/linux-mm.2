Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14A03C43602
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 09:42:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9F406B00A9; Wed,  1 Jul 2026 05:42:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E28F66B00AB; Wed,  1 Jul 2026 05:42:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7BAA6B00AC; Wed,  1 Jul 2026 05:42:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9B3016B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:42:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0E2071202B2
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:42:04 +0000 (UTC)
X-FDA: 84939716568.13.74CAA36
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 75B6B80002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:42:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HAZHD6Ug;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782898922;
	b=hmjiCmJSj/05RbbNcZ1xts/kOKe/bpybAmTUkxWzO9cxtOFM88Frxl7CSdTPq2oIZ/lt4s
	+cpBfrBFHuQOPyHGZywgmBZ1SGNFCjh/BirhHNrq882f+uaOqHP5Lgqnaq2YQ/0YVdHcAU
	t7G4jXZbWa/OhBkNU6EvoZMwTNHOylE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782898922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bfrBSekSNIKWuBi4Run4vwyC5pfX+76l6DS1k9tedGc=;
	b=BDIqHtZ8sikA6L9Q0fLTDg29ttVOwfNmXw+1+zPTZN1YXFLG62Rp8MNxnXUWMY1kGku9CG
	3IQN8lEIzeZ8RvMrEtNyK9QDVIqebcEUjmZOB84A5/2TlSmGOGhMTLDJdw2azBlHHRKsoQ
	pMKsFVLVuMCTx/s+S6f0x1PQGYMg1TM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HAZHD6Ug;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 07D7560138;
	Wed,  1 Jul 2026 09:42:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC221F00A3A;
	Wed,  1 Jul 2026 09:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782898921;
	bh=bfrBSekSNIKWuBi4Run4vwyC5pfX+76l6DS1k9tedGc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HAZHD6UgoMHQNw28yxhRXLw3L4JiyHCrMUrVvx1hL+lAVQ9PsRsRikXwXmlZFIf3N
	 Ndo7fKU8cb/4m7EOZayRv+DOa/4Ra95cq7R4gOa4UmE2RcPBu7vLZ8CIHMQZx9M2Nx
	 3AtF3hmHm8Qq+Sq8NG1DdSmHb1FwirJtQXvFIegRMDNTsD+4GY9NNx0ZIQlFKIhmmG
	 m/6KocRgo9Yfh8u7Wd6jroGBwMHip7IlP1SWqS4YqfsiDkjtuy53+ttnYjwhjTeXVm
	 qIe3mNBce7mbq5dMwXG/n9Ni59jwnfpRc4qH4ZVwyQbJ2TxUuBtaqrO79/awlk4TCD
	 4dNbai4wedayQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 01 Jul 2026 12:41:50 +0300
Subject: [PATCH v2 1/2] usb: host: ohci-dbg: use kmalloc() for print buffer
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260701-b4-usb-v2-1-272807df4b64@kernel.org>
References: <20260701-b4-usb-v2-0-272807df4b64@kernel.org>
In-Reply-To: <20260701-b4-usb-v2-0-272807df4b64@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mike Rapoport <rpppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-usb@vger.kernel.org, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>
X-Mailer: b4 0.16-dev
X-Stat-Signature: jxk55mhtxsbwz6y5uk5w4r9jsak1ipo1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 75B6B80002
X-HE-Tag: 1782898922-79362
X-HE-Meta: U2FsdGVkX1864YHsojxJabVEDoio4L52T9PcLcPD3UC3BEowYy0JGTU8mafY0TrPo7Xf6ad9i14aG4/pv2i/zy00cZxXMM3rCrqkZjLqC51RP4jluAxxY5SXak+psQotjS8abSKJh/2xhySOci2ZtZ6PrNcfqH67lJ2sqYxVqDUNWpjvEPLDHkykSGui+wCCV9ByhFpe7HodG+kPWRAClfYNaF/0qI9pYZ5Df9txMWsUf6PeI0NIB0IpncXPQqPmW7NRGfvzixL01m4/3LvflFK832/UnzWW/cLSWWgLNhE0NINzeMuKuKgI+EpZiED8in8OEHHwI3LWpuHjTWPLIdOCazyXEGJ49olD0skv5ln1SQE6yhtwAXGKxAZb01C0cwYn4hsrgxsYwCQguLi141y4CqB5U96C8yLTjUKuqSG43EHdrSvGDbDgQQVY1/R/kbpleGpiBMQg5NrgEKHzh9gOFUVIyqHiojr7sr2f7/7jx2pK8ZYZJLevnU4LlEZyqjpa1wo6VmIsa/QXMv5sNF7JCR1WSRgcXxluei8rgP7cOL7tPi7EDepBgpXXVrGZA5Nvz5LI6p4soT8LGcPEBYy8dbTu9HiaxR/sf6yPdZ9gV75mh4fA6u8MPEvYpJbZnUtZHVoLSdgls1LBSBMuKwlx3D1q92OAv9Ptaw6651FIPWwv8RNnbmPlifAAkKul8Sz1TmVy3xu/uU2MVtexE12qBQsZ48l3On9liHWjM3pm4uCH1TgCSbM4sOPzbdpizyuqQkA2wRVnJt5zUTcO3lrx/0WabAuxiTz5YSgHtXxLKXN9cXowBtHjzdPkdtgtHJ26ttwA3ISSSbXKRIAsrRzrVzRg1YXRzQ86H904IvPNRfTvJjjw5GhMfM5J4Opa/VS8eTEHiWXjj4yOxHA+uEzNny1KZZnCAZWCGWtMcpwiFUWjaVNiqdo5aYGG3I5HNpWpN9PCw018T3jyZfM
 CTRvCK5y
 ZDp9FFEg2yRuJlJkgLYNV8C29Lmst8AOGstNHSdFAmmKRrrN+I8pPl5RokGWbxoBwuv6GFxMsM703A0nRJHB1CNPo3eJzvVuCp13WVqu8HQ8SfWv90MiwQiiazc/3EbyFR4kwVlMHzni7hiFqmerbEoJzoYoK0Clw1FkeBXYuUg23jkWEB8Mk8Z4c2NEU6JwirMtQxG+YrOtDgBMZKTxHDrc2byby6K/vvbCnZ+OPVGZqFEaQKTUK1n1+L2NQkDH/kr22XVJxKe7cz0w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ochi-dbg allocates buffers for formatting of various dump outputs.

These buffers can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of get_zeroed_page() with kzalloc() and free_page() with
kfree().

While on it, drop the NULL checks in debug_close(). buf is never NULL
here because all the open handlers return -ENOMEM when alloc_buffer()
fails, and kfree() can handle a NULL buf->page.

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/usb/host/ohci-dbg.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/host/ohci-dbg.c b/drivers/usb/host/ohci-dbg.c
index 9e0e06bbc570..23dc9eddc06c 100644
--- a/drivers/usb/host/ohci-dbg.c
+++ b/drivers/usb/host/ohci-dbg.c
@@ -683,7 +683,7 @@ static int fill_buffer(struct debug_buffer *buf)
 	int ret;
 
 	if (!buf->page)
-		buf->page = (char *)get_zeroed_page(GFP_KERNEL);
+		buf->page = kzalloc(PAGE_SIZE, GFP_KERNEL);
 
 	if (!buf->page) {
 		ret = -ENOMEM;
@@ -729,11 +729,8 @@ static int debug_close(struct inode *inode, struct file *file)
 {
 	struct debug_buffer *buf = file->private_data;
 
-	if (buf) {
-		if (buf->page)
-			free_page((unsigned long)buf->page);
-		kfree(buf);
-	}
+	kfree(buf->page);
+	kfree(buf);
 
 	return 0;
 }

-- 
2.53.0


