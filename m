Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 994F6ECD6FE
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 01:46:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 074056B0005; Wed, 11 Feb 2026 20:46:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 021E06B0089; Wed, 11 Feb 2026 20:46:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E45FD6B008A; Wed, 11 Feb 2026 20:46:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D520B6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 20:46:29 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8DE20C1C78
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 01:46:29 +0000 (UTC)
X-FDA: 84434114898.06.4AACDC0
Received: from dragonfly.birch.relay.mailchannels.net (dragonfly.birch.relay.mailchannels.net [23.83.209.51])
	by imf03.hostedemail.com (Postfix) with ESMTP id 54A4820003
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 01:46:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=iZzTKRFN;
	spf=softfail (imf03.hostedemail.com: 23.83.209.51 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net;
	dmarc=none;
	arc=pass ("mailchannels.net:s=arc-2022:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770860787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/9K90WU8TR/iWfaIbLxXjPDYWH2ZZ7WZQUnPCnjS1EA=;
	b=XvP5Uad+J4KBmV8cL/cJtIlbPmUM8lAH0lxIxUqyftewUylTlDyBqbTHcTQbhiLWn2Vev8
	9jLHHNGwFaYEeLUN93eeu4mo4uxr/vJ8OsD8agusbJrGkq8Byy8+ooj1VjJz5KrulhD+Qk
	vmYSCZ/WTdh4YYsfVbFofv48zV/RM08=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=iZzTKRFN;
	spf=softfail (imf03.hostedemail.com: 23.83.209.51 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net;
	dmarc=none;
	arc=pass ("mailchannels.net:s=arc-2022:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770860787; a=rsa-sha256;
	cv=pass;
	b=oHF5f8mVf3L7pXsvnM5dJ9MwxYxi+6WBlVQJHgpHHVmraSeBLfSDnMBgnIKrT28dlItLt0
	+gUV+x21qY3GpUKsju9XH42loWNG9AuMwf3LIE/aYdyGAy9zBxqR+wyLc+zKI16DPK62L7
	io1rGOKCP6lHdAtmzW71R7oT9BDlohA=
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id D2C55162E96;
	Thu, 12 Feb 2026 01:46:25 +0000 (UTC)
Received: from pdx1-sub0-mail-a204.dreamhost.com (100-101-116-111.trex-nlb.outbound.svc.cluster.local [100.101.116.111])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 6FF44162EC9;
	Thu, 12 Feb 2026 01:46:25 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=mailchannels.net; s=arc-2022; cv=none;
	t=1770860785;
	b=gVCsGeHWauv4Zl8OecWFskKL29wMskqLPhvqklCCcYR5otpLARkI9+1+ht2qm5iCGLJfoN
	CIDiA+KszCdmpgwnP/7cxCMUQ7ycG6gPIrS0RZGlyJjttkaOrnbAwkVZJSRjRDXbbEEaWO
	9W4Sin75V3S1hV2OzeGDOxQu9E/WjEANC1CN9ODV1ZQId3Y4LZak+HRGJaS4BtI3f55HII
	ZFqlI20WacuR7Jdi60O1hqBb0JMrerVZt8KhByo9Jb6ibu5zmUTBPRwmJI6n7V7bGuj0wb
	7P55iLQIe5xR/ByQbpoGKvfoVq+bgY+F09BWTNLbWTylFhY3SQ4zrOF28xPTNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1770860785;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:dkim-signature;
	bh=/9K90WU8TR/iWfaIbLxXjPDYWH2ZZ7WZQUnPCnjS1EA=;
	b=+O1t84VvtjPQXIBhGz0Wc7KKCxl/Aj+er8VzCGaUVwAbffOHMQFhsHxzyhfgcjrcbNuaYL
	otiRrXcnJt4G8nNaQYFDd7spejsRGrU3XM5ZMgqjidb9Rs05vKsKszaPlDI/VgELS/m+WY
	lpXxw7lLWBBd1hDxDstyHedzys816hudNBHBjVw+P4GEZNjO3kqE1SgsPFXvWoQdwd0ZlX
	s+jbzaOmCah4LZb4ewgqsXdi1RuJFcE7l0wPEahCmzQkURaPFsEfojsbIYHEVJlwe2GqMW
	LKAyB3fQXyuHbnQVDVmmu3xlT3sLQVE4P53iiw0JmNzEdadt5wC1KdJO95AKiQ==
ARC-Authentication-Results: i=1;
	rspamd-845545c4df-cstnz;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Shoe-Lettuce: 23c4b3ca50f17c19_1770860785714_2487753628
X-MC-Loop-Signature: 1770860785714:3950662288
X-MC-Ingress-Time: 1770860785714
Received: from pdx1-sub0-mail-a204.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.101.116.111 (trex/7.1.3);
	Thu, 12 Feb 2026 01:46:25 +0000
Received: from offworld.lan (unknown [76.167.199.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a204.dreamhost.com (Postfix) with ESMTPSA id 4fBJ745dstzPb;
	Wed, 11 Feb 2026 17:46:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1770860785;
	bh=/9K90WU8TR/iWfaIbLxXjPDYWH2ZZ7WZQUnPCnjS1EA=;
	h=From:To:Cc:Subject:Date:Content-Type:Content-Transfer-Encoding;
	b=iZzTKRFN/LSoaOjuZLlCEvm4K9PBgeS8BnTV2FDNozdgn0Fsl8l17tf2q5gZ7kUtJ
	 Yi6bHuudIwwdy5dqPXxwx+pcAUcc38pCH+w7uN8z7qNpbP6Fw9+m+8wlj2zg3b4SIP
	 Rl+kyApg/F4wtLbfcDC3avMa/fnER7pwvR9DI29npof92YDi+cVFKprdXcTDI93gKr
	 rFZ0GYoxiaq/TE8sa9hu4yEB2AoB802hPGx/FNfC6HYxiaKLaoKMocNaNpwthxNGxK
	 hmnM05i/PWcal8w5GsJ7YlIDeh4Y7t3XmZ36oBLt8oPehVm+RpyvIt9XNLwXCjmNR/
	 ijIIuyCWcXq4g==
From: Davidlohr Bueso <dave@stgolabs.net>
To: akpm@linux-foundation.org
Cc: balbirs@nvidia.com,
	matthew.brost@intel.com,
	apopple@nvidia.com,
	thomas.hellstrom@linux.intel.com,
	jhubbard@nvidia.com,
	jgg@ziepe.ca,
	linux-mm@kvack.org,
	Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH] mm/migrate_device: remove dead migration entry check in migrate_vma_collect_huge_pmd()
Date: Wed, 11 Feb 2026 17:46:11 -0800
Message-Id: <20260212014611.416695-1-dave@stgolabs.net>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: g5z3xqsqrem34fnoab77kb4mo18pqwab
X-Rspamd-Queue-Id: 54A4820003
X-Rspam-User: 
X-HE-Tag: 1770860787-153384
X-HE-Meta: U2FsdGVkX18g7BwbDWoVcVLc9f3SnrYQPWG/AyFNjHMrbijzQboHYwVWznKdl1p/icEiy8QVi8f8oRCgrQ9KMqMiRBEXDYzDSni+Gj5jIBAyIhIvy++HAfKpeL/ERR2t60cMhyZibYwx9vPZ9ctXi1PaFWCVb77xWz1q9CiooR4N8Wdv/Nvd5/wRGu23E1U1Pv5vuHNYyznp4pCto2flDs3R0vKn5plT3PlXCnFCsykVWbv8lSlTW6Fl5Xgqq3SQ4ITE4JCEoIcSpLLTQ7KBRrwj3HfhHMPBrO2G+yG9XncRKshQZlbaYYs56A5DHoWuVbztwRRl/xnb2lgwfy83a/ipwGv7MiSpQKKqZOzEg0Ilm7u9Cv8Umq1TNn0ea3yYn9j8RCQX3tRngE2E/kmsbYyODqQbvfbEvr4/+eT9YDp3eew+77CafUqHOok95iM5P9GU0hK/8SaNEQTn3EJxQL125KMJjrGLJSV9JAHHv/CwQ0gP8F+4fKL5Ct/rgigRCLjCClsIqy1XWxSAFJcCOX2ajW1V8NtGwlxd3Cp9PNl04AZweLXmQlq+bblU7j75shLfRS6cnjLbOy9dFSx7yNXPgZ03EJGvkp0T4kIAdFbfaW1YLrcLFB/B+vbz3NwusDGfXlx6P5HGW5sjvM1o+PBQNnjd5oZFycjEBfaQkd6bSPWh28KpP8d1mO061eMI4OOVwDgZqIN6bW3goMTsAgDnLEap6V9Xg/78ejabLYuC2X0mIR4B6L5McbPpmw0nrEykDLD99XgqRU/HQtvHILoExCvqZ6vBDNjt6oefQQ1yKcEbGZZgKaykFt2o9y4LLoiKIFXsQ7+3MjI6HCyMPlrCl9TVgO25hRpdyTmIMFph1+Yll6QH5+fkXLE0ELXCtnUM232gnIJpYpsqr5wAgmvsK6+7pXVnnpexEI+koub4s16N6LmdRCdPdoT+MH9a5UXWcZ4qspaT5bnT47T
 c7VcJ8jk
 JbmmlNKuY5emH7TpKSDCKfO5NA9PgSVchXh+88MCwGJ4+mMYVCTaaeVxSEw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The softleaf_is_migration() check is unreachable as entries that are not
device_private are filtered out. Similarly, the PTE-level equivalent in
migrate_vma_collect_pmd() skips migration entries.

This dead branch also contained a double spin_unlock(ptl) bug.

Suggested-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
---
 mm/migrate_device.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index c2855235fd9a..b40c1d49677d 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -175,13 +175,6 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
 			return migrate_vma_collect_skip(start, end, walk);
 		}
 
-		if (softleaf_is_migration(entry)) {
-			migration_entry_wait_on_locked(entry, ptl);
-			spin_unlock(ptl);
-			return -EAGAIN;
-		}
-
 		if (softleaf_is_device_private_write(entry))
 			write = MIGRATE_PFN_WRITE;
 	} else {
--
2.39.5


