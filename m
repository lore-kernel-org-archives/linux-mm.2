Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC8FDC5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 07:44:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BED716B009F; Wed, 12 Aug 2026 03:44:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC5916B00AA; Wed, 12 Aug 2026 03:44:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADB6D6B00AB; Wed, 12 Aug 2026 03:44:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C9C46B009F
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 03:44:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 207231402DC
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:44:01 +0000 (UTC)
X-FDA: 85091828682.07.5DC59B6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 604B9180005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:43:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CjN5FK0r;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786520639;
	b=cOEmaKnyXtytwOGJ4kYtjHSXQJvxWuUROjCcXP3uwMZGaSAeYjjp70fsuNZpg/8cYtFTvr
	DmwyD/svt3u6A9IHz4BKMVRBQhO+Hn7ugkFee7joL0keVuMl2Nj1x+n0D2JAyqj2IMUTYv
	Lb5+uN3yMkgZpKtDqfroRiuvvVMnLpc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CjN5FK0r;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786520639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9pSY0tJf8U6OX+aOr46oomP4FiiZ4map81yDZBrjHxc=;
	b=EHT5LR7cwKxaXpnAsdSOl5Pttd9h6/h8GbG09lZtBMcKrYn0IOy/nZsVYirA8zdfeZT2Hx
	Vw09MS9pWd+nszj7NFGpC7wNC4dC/0DgSDgIedN/vYDMUkiSBkGkZoPW2LFCAfaQpCLSDm
	qwnJJQrVuTxCO3uZcnkSvau8vCNdP1A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EB78160A7E;
	Wed, 12 Aug 2026 07:43:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28741F000E9;
	Wed, 12 Aug 2026 07:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786520638;
	bh=9pSY0tJf8U6OX+aOr46oomP4FiiZ4map81yDZBrjHxc=;
	h=From:Date:Subject:To:Cc;
	b=CjN5FK0rTOFIzo4ODUJxYEJUSjRH9MALXcDU38oxqNAX86B56bE5xN76I6K+wji4C
	 RXir87/+MEnvn2tOJ9gIDsra/gBEZrrj78Gn9Ztl21s3fm6CeRQyUOaJyY/7eOGRk7
	 aC1s8aSq1wKt2be5o8JoVGMsULJ4tGJstV+fZGPohd1D+scU3BIIxKtAjCeN2TMypP
	 b8YMYe3ZL7YqqSKrEIdzKxNXVbeHLjMpde37DlHqcASfy4TVtytfQMwOsOv/V8Gr3P
	 Teh3IB5V0EOihnco4UiUdM3hUjGWqpTdbjjRprkpSmjUpEbvKws2QlCiU9jzS4bYJ5
	 SBHza6KssC/PQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 12 Aug 2026 08:43:31 +0100
Subject: [PATCH] MAINTAINERS: add drivers/char/mem.c to mm misc, memory
 mapping sections
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260812-add-drivers-mem-to-mm-maintainers-v1-1-6218b861f4c8@kernel.org>
X-B4-Tracking: v=1; b=H4sIACIkfGoC/yWNQQrCMBBFr1Jm7UATpUSvIi5iZqojTCqZtAild
 zfVxV+8v3hvBeMibHDpVii8iMmUG7hDB+kZ84NRqDH43g99cB4jEVKRhYuhsmKdUBU1Sq5t+zs
 ew3CiFFJ0Z2ied+FRPr/G9fZnm+8vTnUXw7Z9AS9Z6CSFAAAA
X-Change-ID: 20260812-add-drivers-mem-to-mm-maintainers-f3864dc8ca19
To: Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ljs@kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1537; i=ljs@kernel.org;
 h=from:subject:message-id; bh=5FPUkWxhyFZqy4oqKvasLCDj58u8MXGFOyogOnBtw8A=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJqVLQPP1/y9599DMv7ENbauOhKyenH5movMWYvsdnzm
 3nZrennOkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRV9kMf2WVdSb90FY8n/Lz
 o/jOw7uUKw/2P8+QidaxvFh+v0Di2BFGhk9nZ99WWe5l+1VvjwBna+Aa1rgzW1xl+X/FnHn97s4
 LTw4A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: 604B9180005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 6dkfbxxipq69qk43nkzycaokmnh14pn7
X-HE-Tag: 1786520639-4554
X-HE-Meta: U2FsdGVkX18pURuOhws5oduHq9vYK1auDgsfFpAWoLlqOrlSUIkRijrwswim8S1ddfqawgFhMGq0zq5rF7Sb8phCwpSYoVQS8C+dUB9zedGM8la0KLJae+G9nzD5AS4h/CpuPo1omBGV7Ww4icV1U+knYwf/dp97BrDb6Tgmde+sRe/BOxJlCPallBn6SYhO/xeekU9fXeGt/AnTQYBnUI4jNtAGZ3FzJ/DGVSxeA/mp/l4eDboj30H2uoeBspdcTtacnKjcY2QMAKuvYOVRmIXUwspz2OeiNqEbKexjkYKvI/OJRnj4Pz4YjMd9nTVangmYZwaaCDKP+eKePHdBDy4fz9k9cig0kHBTOzXzel3bQgTFEh6JvktL+4N7DMTrGaaMvuJzytNAOq5nIqR6pfXJ/enOfYzLYOqxFmOt+Hms4RvHqik9lSLEr+6ADNjW2FCtlBFKsZ/gFEa2DtOVrv+4UrSs6mXyqDeSSn5ifkDDOTylYkLZSMtbQfEa1lIPsK+uj0YEPe0AVeFsgR8k8QlK6noKeC9e7M/x69kAHu3zSJx19DCJ5x3mg2r1Ut8F0K5vULGcB5QPGGaxBwlMDyG3z6rYpHk/DCoAsz4qqvznDuR5a2sqE5cc9ERIavsaKTVa0CZl8bYtAHVh/XC4/EIRoAv1JHrwbGpTxWeZfYhNMh2cgH29BHxwzxWVQBwGK6dNQMPt5wzpiS6QB0VZcrwDol/mCzAgvGlFKoGk2LxANkKRaLx407iKXM48uBXyd9AIOmVRWhLPM6dG7/L4mYcwQR276jhhOIwtKQikvflcOu4qXg4a+i6oYKjDvroxBNNcrpN6RuhkqBDSoLUE7V3HkBtVoca6foEEbGqtwKh62ApWH//2vJKemBljczdAJOVkNpgnoKOgUiWQefQKkDPqSR8NIQSZ4yOVro3wJmbSwv66bHSwtyGJ1jBYIcwI56IqV1EM7sJNi9gcJ6M
 SramUPtj
 rLW5Cgv7aczuu60pKya71eJfKwu5xs79DRcq5EY4ckDeb4O61B8U8ZpLjAx5pyL3cW6Ef32078kJCE9yLl1V34OEvkzq4cLGTXDvZ2tBa2oKNG/h1fMv9+LdAyYoTG7Gj7znuLXiZdCMidxe/dQ5q31Tu8Yssecbv68WjwH2CNFP7VXIAOtzBOGrE+x8To2CLxyy2OwnXIC7iSrbs8Q+YeiD+vJhrawkyKLVeU1YzuFbGbVyvRm44LvYJpSeOnPWfH7y+2TncnVtC/7go6dkYE2ueWL1g8JDsZnRsNaI/Tu3zfqeNScWzLFOPJ4JTsJsGls0wcEdJsrsXc8B1BHpBUEt02QP8am6TYBCD0+oITuBl3ag=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This file is a 'special' driver that implements /dev/zero and /dev/mem
among other things.

As such it makes sense for mm to be cc'd on mails and to have some say in
how things are changed there, so add it to the mm misc section.

Uniquely, it provides the 'old way' of obtaining an anonymous mapping -
MAP_PRIVATE of /dev/zero - so is directly tied to memory mapping, therefore
also add it to the memory mapping section.

scripts/get_maintainer.pl copes perfectly fine with files in multiple
sections so everything should work correctly.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8014b9f8253e..27160fbe21dc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17109,6 +17109,7 @@ F:	Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers
 F:	Documentation/ABI/testing/sysfs-kernel-mm-numa
 F:	Documentation/admin-guide/mm/
 F:	Documentation/mm/
+F:	drivers/char/mem.c
 F:	include/linux/cma.h
 F:	include/linux/dmapool.h
 F:	include/linux/ioremap.h
@@ -17311,6 +17312,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	drivers/char/mem.c
 F:	include/trace/events/mmap.h
 F:	fs/proc/task_mmu.c
 F:	fs/proc/task_nommu.c

---
base-commit: f5bbbfec59b4e2fb7520a91de3df8a6174325d6a
change-id: 20260812-add-drivers-mem-to-mm-maintainers-f3864dc8ca19

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


