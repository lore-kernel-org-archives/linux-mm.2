Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E135CFF8864
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 01:59:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DF3F6B0088; Mon, 27 Apr 2026 21:59:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B5DB6B008A; Mon, 27 Apr 2026 21:59:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F2806B008C; Mon, 27 Apr 2026 21:59:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2FA8A6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:59:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DD8C41A02AA
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:59:54 +0000 (UTC)
X-FDA: 84706308708.12.BCE3AE2
Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	by imf13.hostedemail.com (Postfix) with ESMTP id 400282000A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:59:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=RMg52mZD;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf13.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.210 as permitted sender) smtp.mailfrom=fujunjie1@qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777341593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JXx+eQhSmtI3VwbwtA92nRqKi+lavmKmgwnzr37qcAM=;
	b=ZrFe+EsLwI/jf+RdyIiG6b91RmiXwNKti3mLxS4jNfqUbqnE2eV0Ajz2zBYlyUJsF5JYni
	i3VRlzPRCXCb1a316G4rfypSsQEnwzg9vuFmsLjEIxp8IFqx8baAq9dWiGz9kqHcYqed5w
	RWKeFMZL3chQ4dtl7YXMHAqiZ4zp81Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777341593; a=rsa-sha256;
	cv=none;
	b=lAzSTVPXUsZ6WB2DwVrUanqEzLdnNvs+3yDdbhVHWVWutFHLbIn8rkgXngC9HuFiiYBqnS
	aolBF0SdBwIIXAtBO4mTEhr/scGX7PrHe5N3RlWbhwY0EoJcVGIcx52KLvsi4z5AVi32G7
	mYVmoEyhz3gyaQHUaB7y+hzONbPN5q8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=RMg52mZD;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf13.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.210 as permitted sender) smtp.mailfrom=fujunjie1@qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1777341588; bh=JXx+eQhSmtI3VwbwtA92nRqKi+lavmKmgwnzr37qcAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RMg52mZDghBUiec5s9b8Aq5PDX0cvhS+GmVd6TjpDIQPRyN3K43aAbCYRQKRckN8I
	 X9yD87CkUb5CzvDhohWAxAAUshNzth609bIJgMr3XNG5xW6yrFOQLmqygM4vlseTt7
	 C7UTV2IH4sEO7Myw08nAj4dy9yoMvhPoXQa8aEOo=
Received: from node68.. ([166.111.236.25])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id EEC31E8E; Tue, 28 Apr 2026 09:59:44 +0800
X-QQ-mid: xmsmtpt1777341586tdqr1jlqd
Message-ID: <tencent_22E6B8849EC1141FE7773C64467E6F1E2C09@qq.com>
X-QQ-XMAILINFO: OVFdYp27KdlJM3vnzFDT87lrJUZP4DrBnGP/EagY50ufGw3T2popJz76ikK1Qw
	 JmQwsjnStBYE1oayqJOEd9rR0jnBfSgcDX+4065xYKj8kBZs0J6vUcxH1GnB9i9V7K1ULvZbhL18
	 8l/LAmraXDrwEfpH3+nN7ulzRL2dFPq8t0VlS1F6RnP7M6cBMoZNVeAiO/hvvahtlWu+m8o6nHZo
	 ztL8La85/coGi+TZKcEb/BANdRgd4/gNQpSB8zAd5fqi9zzxTpnxRdJ4bqaqu/KciIhlXGmb+s7b
	 jUJVseYZ/24duoJsU0iAMtcfMSbNHv8LpIBmwqaab+gOHh3Ote5j+1HIQSw9MxRFWQGhxd0zaKBm
	 Od6PtvqedpRIp0XFB761xnU9Jsk9mpJeW+DLCPgt+8jv+XWb9PlyApYlNpgkEWBC5eay9qZB1cvm
	 bk6FDv55QZm6onRayl1/j+AppWNDsG9UM6QZiS4O0WKKZd8qCW04NAbvlEXhgz+FKoRLi1kp+GDd
	 O/PfWV5bnCom+tTlNMpXcn0/tfqj98fh7g7KCT2gTOFx4pxIy2r1/Gk3SMVmSrID6i22qN/Gl6wf
	 Yh2Pc9mwm6uig2qXJEChP9EebBJMTPjBF54/sqLEsiklqlDqnG7NB7jiqouyMhHpOSYWj3MR8fvP
	 a9Mk2HuOweT7QTuBl0Qo7bgCEAHs13IMajLyiwMRFlUNvnaPk1ReKSFkIpy0Q6GEPLqPHQO/lRtT
	 AtPx/VZIKc2R2eRsOPq9tlpjjmTtRos5yTaceWTaUuN21JK8rnj86vG3rRZrC+3BKgWPMJNvch8T
	 hI9+2tgW5iAZ3/YbRWJWopnEhQDQH1lEr6dakI0U2oeswFiWa6VGVizGu4MCxdGcppQqvcYRsAiv
	 a2ML0LeKO1nUU7QGNB2QntW/Prk7vJUMnmWX4ZbKhC1LCHO1xu/RPNSska/36IY3fX/HPAUBaCj6
	 7T36iLqaqSa5Idsmt/+D7aUrnBGAPeYijvmRzhoK4xwTwgzOKzarX9XZtAPXUcno5rQCrLmwTKPW
	 7uwUHkKcSppAprLRG+LGUP1QIXcQ8mgi6PvyVDqVaDWwD0EmBSDRBsF0s56neH8ezlMTztkYUKOE
	 1S1BRC
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
From: fujunjie <fujunjie1@qq.com>
To: Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Haoran Zhu <zhr1502@sjtu.edu.cn>
Subject: [PATCH v3 2/2] mm/filemap: do not count FAULT_FLAG_TRIED retries as mmap hits
Date: Tue, 28 Apr 2026 01:59:44 +0000
X-OQ-MSGID: <20260428015944.2601099-2-fujunjie1@qq.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <tencent_AA501E9A238337BD167E5C2ACF948A1AF308@qq.com>
References: <tencent_AA501E9A238337BD167E5C2ACF948A1AF308@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 400282000A
X-Stat-Signature: xyk4meap3hep9typnfuti4bkq8qrdagk
X-Rspam-User: 
X-HE-Tag: 1777341591-812941
X-HE-Meta: U2FsdGVkX1+k7920W3joe2/z3TKQOwG5YdpfOeEG0jnoTA/X9wgacKEWA02spUR7rfHbgg0L0X/ODSXKbjXUvX/8QXIbwm+Exuez3pxMV+J4qH2rjIYd3AcUBSDi2jm/Q3PfsfaaZfSTb3aUA6/kcJIa26m0ECD35XsghbNVdpwC4bKbWfXhDpSL+jpxPmKZau8b8OyURRfqEiJT+veaMkdFmL97CKXpMkWpMQjq/sihR036K+B1FISc3Ofm3l1YMmC8SDn15ZoHXV3apGDGgr2wcfF1CyshI1ZqHRN0Bd848RXvSfQK0lSb6/+EaCi5yQBC2/biXzD2orwuY4UOpiV48JiPa2BwnMPQJ7MqcoVLtlyAVcTnBtkUL8BTD4xJ1zqUnC3wedmAw2QIrrsjBPE3WeN1+sjtL/fys+wutA1vlKFaGx2eDg+kk+0LFo/T4F7VEAe9disTZZDkLjbgS6Kg1gWqsGpP3vsAp3P6+pOybj4cLaPsUc+nqW6KGb0x3WNViN8TTZW/07Idf8tvgAzvBeoMMuquZg+e8FCT7C28CFr6zzSK9Hepkm1AuBq7QDE8auuDBvRMf+mQrPGfrEdFZyI4KS21wi8ghVnvyTDdWYUwnD1j79ep8t1rVhNQm+VxJdiBLmNuySD5H1LdkqfdaxzTlObKPf1OcBQ/VuP1MLj3RAF1SbUp6bebfb2rpCkPEurJD7xcJeZn5WD4kjbNCTyVfqag/C2ltyzpN3YlfoIxtuPANOOfrNb7vKAfAFohcdXsKmltC0JR2BPpqlkN3KSHNxubL8e1QEQnnMdQE+glcZzKBKM+aHpjJF8ZNtss0w6Y2Cb/4nTLpqiIftz5muhk8BvL6ixDAAzn4tTbvxeKsoHMnNQ2+x+QCXGgAGfGtCpxVfnu3DFXdKmr7BzbbK2IiTFdizUILgSw/dRuuSj0vPwBpdbLDknUz5Qx34LfqjzdtKRTKUA6+rM
 jMQXtwWd
 aGycJvKKdQdNJ5xUh6qRTJBOoTP4/D5iA23v66CsD9zx1Je3X7upAszwHztt+Xo69aXLdv4d2u1jCXxb9ss495euiYF4yQyITpoJnk/mdhckQvWsh1nLIuRthBTC8sCLYxBaBV5/10xfalj9V92xNQkAtT8Tv87X0ugNXltWtiETfyCScRApPLl5udCnOuPSjkHTo86meKmiDl9nc1gDSRfUR2WeJXmJsa1IIhecswEVF7NBjHbrJYYcTUvWc6GYmnnHQNAizkaheHrijdwErfZphA6CnJfAc5YCn4cMNXkcnSLo3+8y1+EDTlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A fault that starts synchronous mmap readahead can return VM_FAULT_RETRY
after dropping mmap_lock.  The retry may then map the folio brought in
by that same miss.

Do not let this retry decrement mmap_miss.  The retry still maps the
folio from the page cache; it just does not count as a useful mmap
readahead hit.

Signed-off-by: fujunjie <fujunjie1@qq.com>
---
 mm/filemap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index 543e51c32397..86a46a61eac8 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3933,6 +3933,7 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 		 * we can stop read-ahead.
 		 */
 		if ((map_ret & VM_FAULT_NOPAGE) &&
+		    !(vmf->flags & FAULT_FLAG_TRIED) &&
 		    !folio_test_workingset(folio)) {
 			unsigned short mmap_miss;
 
-- 
2.34.1


