Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7D35C61DB6
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 10:47:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC4AE6B00BA; Tue, 25 Aug 2026 06:47:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B75D86B00C7; Tue, 25 Aug 2026 06:47:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD94E6B00C8; Tue, 25 Aug 2026 06:47:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9027C6B00BA
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 06:47:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 248041A03A4
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:47:21 +0000 (UTC)
X-FDA: 85139465082.08.2A96EF7
Received: from mx1.zhaoxin.com (MX1.ZHAOXIN.COM [210.0.225.12])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0059880002
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:47:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of jonaszhou-oc@zhaoxin.com designates 210.0.225.12 as permitted sender) smtp.mailfrom=jonaszhou-oc@zhaoxin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787654838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=tJcAL6xNUu/GJZAHhDxKU6CoPgP/2NwCREl4ICsPgLk=;
	b=55zVpvJ2iXHScWlnZ0WSd8+oUIO4TXiMr3EQJMP5CD9PKe3ONTza5Gn1T/gnovnucw8UGZ
	LAucBAN8n/tRygGLwdHKiLzWnem+P4hGcoJMbgs0exjwwdZ+D/0hlvk41TlY25mRMAohqQ
	7a1djfJDVFTzWGW5ujCuAr97hvtKwxc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787654838;
	b=4STqj+OeYpnUrO3ffAR/qM5GjXUDaVA1P16cx4Dw3fdkruEcm/MgLjj+EK6WZRPp3/aUXr
	8cc0FvcbYzrNn+u5FYXCF8xQ/Ziht9M4ehJMKCPAjX33OhsxD+nR0ddmCCaOSmIKwtGqlY
	yqm0cIPMP9SrF3PbYq88rmTtDBIpjrM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of jonaszhou-oc@zhaoxin.com designates 210.0.225.12 as permitted sender) smtp.mailfrom=jonaszhou-oc@zhaoxin.com;
	dmarc=none
Received: from zhaoxin.com (unknown [127.0.0.1])
	by mx1.zhaoxin.com (MTA) with ESMTP id 4hTkxX3mRrzb0tjv;
	Tue, 25 Aug 2026 18:47:12 +0800 (CST)
Received: from zhaoxin.com (unknown [10.28.208.166])
	by mx1.zhaoxin.com (MTA) with ESMTP id 4hTkxT6xn3zb0tjv;
	Tue, 25 Aug 2026 18:47:09 +0800 (CST)
Received: from zjh-os.zhaoxin.com (zjh-os.zhaoxin.com [10.28.24.13])
	by zhaoxin.com (8.30) with ESMTP0dcdd9a0ab20575ea6a786a0762250d2
	Tue, 25 Aug 2026 18:47:08 +0800
X-Eyou-Smtpauth: jonaszhou-oc@zhaoxin.com
X-Eyou-EnvelopeSender: jonaszhou-oc@zhaoxin.com
X-Eyou-From: JonasZhou <jonaszhou-oc@zhaoxin.com>
From: "=?UTF-8?B?Sm9uYXNaaG91LW9j?=" <jonaszhou-oc@zhaoxin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	jianhuizzzzz@gmail.com
Subject: [PATCH] mm/vmalloc: avoid false sharing with drain_vmap_work
Date: Tue, 25 Aug 2026 18:46:59 +0800
Message-ID: <20260825104659.100134-1-jonaszhou-oc@zhaoxin.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Eyou-Sender: <jonaszhou-oc@zhaoxin.com>
X-Rspam-User: 
X-Stat-Signature: oxuoaqspg377chtdqrj7wpsnhtr5xwue
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0059880002
X-HE-Tag: 1787654837-952678
X-HE-Meta: U2FsdGVkX18hcTSWQruOqagqyCZ+OEsHMechTPDbEcyejAvG6nLr37qrswhiS6P+roPGQ43SKx7HJ0t/tUrp4eSEWiyy2rgs/hoshUgkElhV/c8gRW2ZdUWd9scJSzSTBceQ6gHNW2nF6sfrpgZhEGjFrE3vmmGZV0dcRakIcbgeRoAm6VRvz5QekXM8/whrDlhesW1Tz9SPh5SsWM3q2PYhYyT4hoZZp+yTs4M+o5Oq+vXk40+X1epCTNRYhQuTQTgBO3p+4ZlmKP5WQat8AxpCoBIPzTBtrtIffrXrtsSkaf/ZO5nkOeFNDIUW3gHrCmhnC9u0R1P0iYgaazW9bBONJPvwr8xefyp1FpYeomF1r+zJp1EViwNEwIindc8REjJYJyUBzzJf+RH3YCg0ywHpAG250UTa0D9P+JFFBytYfAwQcSOisk0sHl4mcAXszBdvQLZPnZ0DNnq/9zNJbxFtF7JDKY/7gUwiK4WYtoEJN+v5oTpAOfAZLz2jJ097xlmG7C6deDZyflDSed4wSjao8y0DZlUfSjwYYLO/zfF4gpZ+SERXGMjJMIVgqoQw7OQxafDwDARqW89s0qsU3rUJcXGT57JzevoIecT4Pprr/gdvpkApvvt/Q1gw8QEYLuCOKpo+M0nu/wAgI6mPh8jNX7tmPdK0aqGpVWTSicXP4WxSLzztZMVyOeVQcee7CpZ3xDb3V62UWsdYw9gaxdDoWEzh8leRR0+aHEOzESV4+yVHa7EF2dBPj11e+10pmYh1C1DEVpPhPtLFQCVxT/o/3LJbhDFN230kRB5nWmmucLTRqqJTD24KK5vq/ok4ZlIIRD7GLwA01Yndb2DfqTF10HsQpuuC5/X6wiiu+x+TRYSAsBllZEGema5oC/l5M6prycueUlVlvTUpgCpuKPXC+yrgAtKGDd0y4pMHihCcCxw0J49zousp+e5EbweVUCgUYWTpUg/fSD0iBat
 XwmIQgUg
 /s2HoGX76UuVjxgeHusc3iKPbWoOVb1Mpbcx39fvW/piwHIy/7PJPNFHwwjZs9BPf72rGDQMPAMmGa30wnV33LTSJg0RSnwl7zix2dkfcLymgK2On2HTxzRXAZ+4a85GkAV5ENi1O1kalneOrj1xdxr8Zg6ExDI4dj4ZZ1AUWzroPgWU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

free_vmap_area_noflush() queues drain_vmap_work after the number of
lazily freed pages exceeds lazy_max_pages(). Until the worker purges
those pages, concurrent frees keep calling schedule_work(). Even if
the work is already pending, queue_work_on() performs a locked
test_and_set_bit() on the pending bit in the work item.

On the tested x86-64 build, drain_vmap_work and vmap_nodes occupy the
same 64-byte cache line. The work item starts at offset 0 and the
vmap_nodes pointer at offset 32. The latter is read by vmap allocation
and free paths, so updates to the work item invalidate a cache line
read by all CPUs.

Put drain_vmap_work in the cacheline-aligned data section. Tests were
run on Linux 7.2.

On a two-socket Intel Xeon Silver 4208 system using 16 workers, the
runtimes of vmalloc.fix_align, vmalloc.fix_size, and
vmalloc.no_block_alloc decreased by 12.61%, 5.78%, and 6.87%,
respectively. HITM samples for the affected cache line and total HITM
samples decreased by 96.55% and 13.36%, respectively.

Signed-off-by: JonasZhou <jonaszhou-oc@zhaoxin.com>
---
 mm/vmalloc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index f4fa227a8d7f..6b4b287e91f6 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1088,7 +1088,12 @@ RB_DECLARE_CALLBACKS_MAX(static, free_vmap_area_rb_augment_cb,
 static void reclaim_and_purge_vmap_areas(void);
 static BLOCKING_NOTIFIER_HEAD(vmap_notify_list);
 static void drain_vmap_area_work(struct work_struct *work);
-static DECLARE_WORK(drain_vmap_work, drain_vmap_area_work);
+/*
+ * Keep the work item, whose pending bit is updated by freeing CPUs,
+ * away from vmap metadata read by allocation and free paths.
+ */
+static __cacheline_aligned_in_smp
+DECLARE_WORK(drain_vmap_work, drain_vmap_area_work);
 
 static __cacheline_aligned_in_smp atomic_long_t vmap_lazy_nr;
 
-- 
2.43.0



