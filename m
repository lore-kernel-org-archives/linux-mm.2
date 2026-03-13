Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8C61106FD7A
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 04:36:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 152316B0096; Fri, 13 Mar 2026 00:36:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 112D66B0098; Fri, 13 Mar 2026 00:36:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F23086B0099; Fri, 13 Mar 2026 00:36:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E054F6B0096
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:36:32 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A4A31BB3F4
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 04:36:32 +0000 (UTC)
X-FDA: 84539778624.21.231F31B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id BAB7DC000E
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 04:36:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="hXApX/p7";
	spf=pass (imf10.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773376590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a11DWC4Nbs8vhuB0T8h/BbKreRPzDD33p5rwkRoyECU=;
	b=a73K8EgGhhu7B8Xo0lt4O/oUKOs6BJ6oUsW9+Cg+5x2QhuhA973tfUfHIuVor4BynJ8mw3
	VdzHnuv/OgPwAGG91e/0djl+RnAYFJCETFprETzd8hUUUmuD4R7M90MLFvct+0hfttBpmM
	dhnMTsm3PXj4gPgzUfoahucN+wRMcLA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773376590; a=rsa-sha256;
	cv=none;
	b=Dnn4Tv3Alya0eqvWoMxG31VBUfshBU1KfKwCIJ6XDPsLTskekPXmRx2i4Rz/NJ82Vw+sYx
	nL6MO5Vu6+B65rQwSoOJk1BllLN0scnmAfc6t/TxU9x5I0FdbXj7j04wi29zmUW/aPyg1g
	EqRrC+R9PO/BTh4GMhYbXz6QakbJi2c=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="hXApX/p7";
	spf=pass (imf10.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773376590;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a11DWC4Nbs8vhuB0T8h/BbKreRPzDD33p5rwkRoyECU=;
	b=hXApX/p7qqd3esyRsa/Zwtgpoy8uGkNvkRez8FrURk8EUhZGNMYMKCUZATlCtDm1m/nLIB
	fkYgM0/o4igI8tAAmzUB4A3/U3VH1oFQmwHaWI/2cso1OYg6ZLQpykIjopfjpWMS43FLcT
	J+/sbxvfory8Vq79r0OFS8wb9yM2f9M=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-269-vGbx0mCMOMKZ5wwKmg4RuQ-1; Fri,
 13 Mar 2026 00:36:23 -0400
X-MC-Unique: vGbx0mCMOMKZ5wwKmg4RuQ-1
X-Mimecast-MFC-AGG-ID: vGbx0mCMOMKZ5wwKmg4RuQ_1773376582
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A53721955E7B;
	Fri, 13 Mar 2026 04:36:21 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.18])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E680B19540C2;
	Fri, 13 Mar 2026 04:36:15 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: yosryahmed@google.com,
	nphamcs@gmail.com
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v3 7/7] selftest/cgroup: fix zswap attempt_writeback() on 64K pagesize system
Date: Fri, 13 Mar 2026 12:35:32 +0800
Message-ID: <20260313043532.103987-7-liwang@redhat.com>
In-Reply-To: <20260313043532.103987-1-liwang@redhat.com>
References: <20260313043532.103987-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: B8gmUMWIZRDPdXPESm4zp79kZp1EKD1zYIn2lg8cqVU_1773376582
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: zfn5tckdc4ozyxia4xuwi6cwhw35d6ba
X-Rspamd-Queue-Id: BAB7DC000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1773376590-978175
X-HE-Meta: U2FsdGVkX1/2415zAZjvvq4IXx6ug/hvxdUZnGBSW+9xnp1tkV0Zvfyw4Qe2SPcYnBtHHO02kf2aSqj+y3+oycdbdBkvvx6gkrMBdnMegu8mqne3Nq/nvnIdw20Fg72/jzrhvf5rx2W3tjpbP3/6Ax0JYqT7dUuXbFL/t6cKu7sdLZG8KVTpgoczc9dWToMtuIIVIJqUZ1ZNssTO0d0kWxNNrO0FcU748ljvMSob/17jAuI1oGfJ8BuHsjS9HUF/uVaokpqO0Vit1IvUygOeeP0PhOCDDe1/7DxA1TqSTxh4uTG55+gmHwTlI7ttM3VWrWKzPiskkRZTqY0FfFqpgo5kOOvZCxxDzcrJ8XHwatEwHQlGutX0BG2PlAaKm8/gItBT/YXeSPghdXfTHfSpkTvjP0YsrvEQQMA2z4jngzX407aT9KOTzUZGbcAwwN6atcq9qpac+NTZrRzzrNIcN4iFSk3bFBjPumxBO//IzkaDauxI6aCLqVJ92XkCdkF+ZRglbTszcxTf/5Gr7R+PAMLcfqOQYfaC9QJy9T2JwkPkbXWzKTmnKaI2HTRpxLwMxxe8pkg7jlSjX8ySBKabeq7M5g/S2HBuYHPIW0qjrj/JgJuSow/o1+IkMQ2u/J9IErWHwss/IZpO80wU/2mCtHg69q/LgZNpK6rVq30pn9AEIGu7Q6KBUNYOngkTwVI5/ADTxq5EqhkBDgtneJ6xjF0ShmlGiP5s/pyqPaNiTkGIT0loWTI9SB6tu0qriYNx+9a+JDWTWnKwCUXV0Xe3vq9nwGorWMbNL4HtsR2yhiO9/pBKUhn4+7P3REQb4w57+sTvrSP266ybUAspI5i6BJH0RRyvAMRx+KTjbzIrCnteOuxLO7FZYRCh76HgfK3m2t5o9o9fnM5/lsqudpFZcUlZ95KgUlkJ0qsX5EXBhSX1L9NaCJfU0nqp2FoxhpGXj2xs6gh4035D5P5A+jQ
 tFcbgNeR
 37Ktw6Z7es+Rxo3/GAu3SzsSb6J2Z5YbpzY4uZ1ze3kik1Ag0/A7UWFWoAZxc3Cii8F7xEQxgyWzDjE7NdOjPJURFDtmjVCb5Ja0I0vcaJ5nqA3M8EBXxsjgON8h0QlmK0kWTJ/NAkVYX36fOfP9jY79A3bXhgpKcDgv/7Kq8zWbB6yqtYcz+6dJBxmejXz8Y0STnxctpo9nXknojkb/1YmInzpOxOFg0MQcWx4s0L1bk2IYhUANbFZ+skKhISzEn9h4NRkSbMTkPeW9tXS9B5pShKiozgivfZumw8mTR9ndUDvvtoPpMNXKcB9P7MrIjVnKFJEo7tK0fB/o9GEzKf/yMaEA4D7Ya3EiW4xw5wwkiP7nE2aNBdi/XmNWAlqx1IkA31hm9ejHAeunlyyz58xwwsbEKdm2pT/i0ubwzc5WnS6aJlKeZCKGytJmevlQaRturgG1pKDiHAWLgvJThiFv1eEs9Wdeiad623478SR36JyzrV0GYnhx3m5q+VELxdwJq9jbHuSpR1lYBqt28hnpJQhB2XQR63aWZ5T/4Ek72Pck2dpTalIsTHP8FbgVLrCDoMHldYXOvG+I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In attempt_writeback(), a memsize of 4M only covers 64 pages on 64K
page size systems. When memory.reclaim is called, the kernel prefers
reclaiming clean file pages (binary, libc, linker, etc.) over swapping
anonymous pages. With only 64 pages of anonymous memory, the reclaim
target can be largely or entirely satisfied by dropping file pages,
resulting in very few or zero anonymous pages being pushed into zswap.

This causes zswap_usage to be extremely small or zero, making
zswap_usage/2 insufficient to create meaningful writeback pressure.
The test then fails because no writeback is triggered.

On 4K page size systems this is not an issue because 4M covers 1024
pages, and file pages are a small fraction of the reclaim target.

Fix this by always allocating 1024 pages regardless of page size.
This ensures enough anonymous pages to reliably populate zswap and
trigger writeback, while keeping the original 4M allocation on 4K
page size systems.

=== Error Log ===
  # uname -rm
  6.12.0-211.el10.ppc64le ppc64le

  # getconf PAGESIZE
  65536

  # ./test_zswap
  TAP version 13
  1..7
  ok 1 test_zswap_usage
  ok 2 test_swapin_nozswap
  ok 3 test_zswapin
  not ok 4 test_zswap_writeback_enabled
  ...

Signed-off-by: Li Wang <liwang@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Yosry Ahmed <yosry@kernel.org>
---

Notes:
    v3:
    	- No changes.
    v2:
    	- use pagesize * 1024 which clearly shows the page numbers.

 tools/testing/selftests/cgroup/test_zswap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index f84e84c3e7c8..d7a862a414e5 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -269,7 +269,7 @@ static int test_zswapin(const char *root)
  */
 static int attempt_writeback(const char *cgroup, void *arg)
 {
-	size_t memsize = MB(4);
+	size_t memsize = pagesize * 1024;
 	char buf[pagesize];
 	long zswap_usage;
 	bool wb_enabled = *(bool *) arg;
-- 
2.53.0


