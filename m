Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73D04C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 10:24:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AB436B00A4; Mon,  7 Sep 2026 06:24:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82E5E6B00A6; Mon,  7 Sep 2026 06:24:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F5EC6B00A7; Mon,  7 Sep 2026 06:24:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 368286B00A4
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:24:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B8731A4CB7
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:24:14 +0000 (UTC)
X-FDA: 85186581228.08.BC68A37
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 18DCD40003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:24:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OEYhKzO9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788776653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y/TW8KJTz/sa6Ud6LR0Wgj8IHB3N+btY5TCgJ/dBLmI=;
	b=1vbvntMrbQLA+kikor7LpW8t+HfabPv+Rffk6CL5Wc/qO3VBNlACUyJ3foYTW1gM9qFMBa
	oZE8ramPXbDMsPY7G2Y5b/x+RjGJbmuc6Crbqp0wzDWbnxDcLGMaDQt3IQP1hYSrolZgHL
	Fnw3ZpLxG22oN+arDSxlKGbMCpMmbLM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OEYhKzO9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788776653;
	b=VGPnNBDSbemCFkukaH8R4Qwf+SU+VXsM3NoLW8UIyioc7IFcYQWmz4xEeWM5y8arEyJKiZ
	49NO3l7e8/TfCOebT3wzVrONul3kX8y0EmGnYsCf56ocpKs1P4pM5DJ2jQ93/gJWti7Xf9
	vZtIsGIHWLq0HZT6M3aAMEtujWxHNdw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AFF3860D8E;
	Mon,  7 Sep 2026 10:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D74F1F00A3A;
	Mon,  7 Sep 2026 10:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788776652;
	bh=y/TW8KJTz/sa6Ud6LR0Wgj8IHB3N+btY5TCgJ/dBLmI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OEYhKzO9+sk1gMdKkphyEDFcX2mlBenng2D7KchSJuCA/ESqNbfTZvZN/KL3GBeZx
	 c0XGEyzO8EI49L6GSX1No0XvyFgmdikTGEXiSn+GhrNNQRaZ4J9EU7WMFNovP09hDT
	 zv/Lwe6IXGB1oaPx1EpALYwBuHk/Mt6HAKlxKPTGbHOPdu/PYqD8CWAx9O1vGQv38T
	 9g1T2RSM8Ani2MntBskgISidwlgl+vQkmFRCDMIfcJTxL0g1pnkZnY+1srZbM8W27Y
	 Vt4G3iFCBa8mSAkFtiEkAxWB4dqHFuvCUmaQUzdXWb6y8TL2vAYlo03wj7UkvUmNCL
	 ngXncbEY02Sww==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Mon, 07 Sep 2026 13:23:47 +0300
Subject: [PATCH 06/13] s390/cmf: Use kmalloc() for the CMB area
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-s390-cio-ready-v1-6-ca7f39806234@kernel.org>
References: <20260907-s390-cio-ready-v1-0-ca7f39806234@kernel.org>
In-Reply-To: <20260907-s390-cio-ready-v1-0-ca7f39806234@kernel.org>
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
X-Rspam-User: 
X-Stat-Signature: 51p7dzjr8j4kwucwaaa6uk5oxb1xrk8r
X-Rspamd-Queue-Id: 18DCD40003
X-HE-Tag: 1788776652-17586
X-HE-Meta: U2FsdGVkX182mZl7vS/J3bH6J/p5lG2agvIs1sXDSRP6yFppAxq2ZVo1XVwvUIiuSZEbMgM3gph73xn2c7makx/6wtU5XhxYuiiHcT2+s5SKw/ikJukzzrAq0PRw9cJ9a7x5D5dE2PRTqNRwtaLuI1KznfLllxODIYxpSUtWG+hFCr98VJhI6O3apBM4XECWye52xwEx86O2fj+EKCLhpsKuEBVQ49vuEp6Y+I/HUmoGDDEPQmNNVW/S0AbDBaxhwzxXZ6ecvLzBe1pPxWnW9DFb2Xo6WrRFfPzt5A3RBpCHCWk0gcRo1YtyLXZETmzh71TJW6c3ed1rbCUU0nt+GOcD7d1qV6pQD70MmNduBOhwiZhuItzwcTq8OMYoZin5HTJccQwYE94MKMGdzFKhiZ2GkIdubcKCsifnIZ/veVDL5gAlIkgOWmKnpowFqhJ9Pl8+zKdsDmvI/ZbXoTuImC/MeOMdyOBUhCf/esGlnuAnyYav3BBtriyjcv1ygKftCn5tb8mUZvHTfmtVZPZ8QstuOB6FZ6UB9iihsyLp0uYepD8nrZwGXVz+HhmYH5gPTV7JkN5aogAfF+S7SeZzooeFrlKQA0r/uJ0902AEk1A/qMrMV+JlVARBYJOLV/K5SgPrfVfZCqVRM/qB3sJ+/fGVzF206cabQh2yH9IxAhE+VPBBE+pm+CwP0HAShoMvptBUhdnlwGUwHDj8+It7Gj0bvEwRqcBqdh/NbtukLCGexxeprtcXAJ328LBZoC5JggmE6Nm2oagh8Boq6NjDZqFd/t5XIq86867vGE4RWESrwiXxyTAfOJEVCVt4rwPOvIAWsiXmsBJlr+sFtTMxEN0twIgnLCAU6lmWn2TghLxxwYC2S6Mn63BYMBKPijo4TKvTX7YGXxXaw91eCPMi7WwLEarqm2rJSfvIeD956t0wrPae0qDNFMDxeIloZWKuDUyRmllOmtiUFhgtO+l
 aGDDUxKS
 VXwIuZgACWMydI1lELnd+7/qLDZQ/ATp1ZxdZ/P2VD4oh4mE8+nmjZzllxy63QSpCE9FR19INi58Rrcs+RKbdC++l9EHfyQ9i0dwQh/t4Kf53NgWHVlWOrz+Fz3A8vcgy1jaxWOm5AgmAasmqN+/wMEK1icfSaLECjprngY5l7eKaXDceh/J/V4wxcsuH2H0Z9IKdkyYTjrv/+AQzV5ceFEMLSEROW+BfHVl2SDFYlN7EZF7M8v/JRygZW0lctcVWwfvJWw5i0QZoR3s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

alloc_cmb() allocates the channel measurement block area shared by
devices using the basic channel measurement format.

This memory can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

The measurement block origin must be page aligned and kmalloc()
guarantees that a power of two sized allocation is aligned to its size.

Replace use of __get_free_pages() with kmalloc() and free_pages() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/cio/cmf.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/cio/cmf.c b/drivers/s390/cio/cmf.c
index 92ab3d546fe47..6c46b0d0b3da4 100644
--- a/drivers/s390/cio/cmf.c
+++ b/drivers/s390/cio/cmf.c
@@ -501,12 +501,12 @@ static int alloc_cmb(struct ccw_device *cdev)
 		WARN_ON(!list_empty(&cmb_area.list));
 
 		spin_unlock(&cmb_area.lock);
-		mem = (void *)__get_free_pages(GFP_KERNEL, get_order(size));
+		mem = kmalloc(PAGE_SIZE << get_order(size), GFP_KERNEL);
 		spin_lock(&cmb_area.lock);
 
 		if (cmb_area.mem) {
 			/* ok, another thread was faster */
-			free_pages((unsigned long)mem, get_order(size));
+			kfree(mem);
 		} else if (!mem) {
 			/* no luck */
 			ret = -ENOMEM;
@@ -547,10 +547,8 @@ static void free_cmb(struct ccw_device *cdev)
 	list_del_init(&priv->cmb_list);
 
 	if (list_empty(&cmb_area.list)) {
-		ssize_t size;
-		size = sizeof(struct cmb) * cmb_area.num_channels;
 		cmf_activate(NULL, CMF_OFF);
-		free_pages((unsigned long)cmb_area.mem, get_order(size));
+		kfree(cmb_area.mem);
 		cmb_area.mem = NULL;
 	}
 	spin_unlock_irq(cdev->ccwlock);

-- 
2.53.0


