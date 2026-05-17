Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25998CD37AC
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 07:18:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DAFD6B0005; Sun, 17 May 2026 03:18:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28C196B0088; Sun, 17 May 2026 03:18:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A1856B008C; Sun, 17 May 2026 03:18:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0C68F6B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 03:18:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 925D51405CB
	for <linux-mm@kvack.org>; Sun, 17 May 2026 07:18:06 +0000 (UTC)
X-FDA: 84776057772.18.1CD1047
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf27.hostedemail.com (Postfix) with ESMTP id A2C8540003
	for <linux-mm@kvack.org>; Sun, 17 May 2026 07:18:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=gR6zu8kL;
	spf=pass (imf27.hostedemail.com: domain of wsw9603@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=wsw9603@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779002284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KeFpcfWF0zymbhfob3ZNZfwJPvNN+eeSUoX6Q9ONwSc=;
	b=vqg1WEtmvur18Kk6g4YmJ/m0ab+6Se3REAKJ2lPEUTcvy/O5mH/j3nrrNg5Cs+Y/4ZCT49
	RpeWgltbZeODWb3hddOm5RcAUMAIUOjhAzbvNDj31Xcn+srscTtxjnFrsLaVmJl5kAp3jg
	kl7enzYX2DfhOy/KGYNzZQsKsQmoPsk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779002284; a=rsa-sha256;
	cv=none;
	b=IoVafCGm57F2wM7TApc0jxmQDG21r+x+a8sDoV5K7HmN0S/c5IzXrrb8OE1SNkCI9RBH6/
	lWONJ+eLEuvtVCjzjFbNvb3XWpppFqFpELnULV7Ht9asEW0AXrYN/+yYk5ymMmz9UIfdNh
	2eqMQ1Fb0FzA2eEkwYQohPXiJBBE3hk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=gR6zu8kL;
	spf=pass (imf27.hostedemail.com: domain of wsw9603@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=wsw9603@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Ke
	FpcfWF0zymbhfob3ZNZfwJPvNN+eeSUoX6Q9ONwSc=; b=gR6zu8kL0SNWSeUYXF
	3BAU0fidYlonwnKE2vOauddqXkoCVQUPe8LS4nvMcAG+3abJsjXrnUvYdUnORsfa
	SRki3ux8ezwmmF57/LXMCot1mT8jB12whIBk7LRaSWdUDuexrwcLvfjjAvuGTRVB
	ggL6yWCrGkkCyyy9qU2/4MViE=
Received: from wang-MACHR-WX9.. (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgCXXiB5awlqZ2JfEA--.0S2;
	Sun, 17 May 2026 15:17:16 +0800 (CST)
From: Wang Wensheng <wsw9603@163.com>
To: ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	akpm@linux-foundation.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: wsw9603@163.com
Subject: [PATCH] kasan/test: only do kmalloc_double_kzfree for generic mode
Date: Sun, 17 May 2026 15:17:13 +0800
Message-ID: <20260517071713.353579-1-wsw9603@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgCXXiB5awlqZ2JfEA--.0S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7XF17ArWkZrWDZr48JF1DKFg_yoWfZrgEg3
	9rXrWDGrZrJFZavr17C34FqF42k3WkCws5ZFZxK343XryrtF4DXw1fWw13Cw4xGF43Cr1a
	ywnrXFy5tw17KjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRNzVb7UUUUU==
X-Originating-IP: [2409:8a20:5633:5b14:3979:fad0:2d28:598a]
X-CM-SenderInfo: pzvzmliqt6il2tof0z/xtbC+hzW3moJa3y8xAAA3i
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A2C8540003
X-Stat-Signature: bq35f9a7idwtmnpnuho4nu5t4yo19yeb
X-Rspam-User: 
X-HE-Tag: 1779002283-226679
X-HE-Meta: U2FsdGVkX1/3o/du5R2BG2z6fi84K+3Fdb04JLlZPGS9hjeP3J7LA1cr+KupH30WXyJYeJ1ZVFMpuSFAD+BaX28IMzShiayfuUmRpTUx9wJwK11j6bYf0M752GKRFkLtHMbMQ5ms0XgQFVGWEDqeyQ80F6OszM8CLBu4Iwy9GtwOFzHdbrpB1OxRNu+wtiY0+uCFGEUUDA7QjGaBijycXw0QVXTndT/9bqP1O8df+Zy0AbjMMwAwyQWY7p+SxXcfv3ysvqx6ZXaYliNprQFrcuDaP4pBm1JlWvWZ6pJ8GpOrqM0x+AeGsyQAsEFkyKsRWm8nKtvfOUMcMUuXkEOPPBcoWIgzcdpTEz0q2CcFtZKIZTn+TEdhNg/YADbXDuqJJW+H+YMLYXFZbysrZ7P+xhhm96TqRa96ZN6Rw6gPVSvywqWm4hJrZhkwI6YU8Q8YJ4dLz8thR7hsClkWc5E0OLlegLNb9eHb2yVjDv9djezJ9+eNLZ91y5PaCd9q7lEzgNSXF+KDeFzrEQ/dw8L01a8As2H1hLeTjSjF+OMJwJAuJ+oVsx2egEfosSVGdcg2h/C64eHy98ruWYcd6//IE+QiRtpU3nreOhVN6YBhlZnS/AL9NQLx1R79iEsF5n8dyvxkl2TvzVPWU9mV3om6lOufQAmZ0KyRZKS5KOkFhSVnQw9Rq4zFyfo6YYCayr2VEcbbKDN/SvUW628bmMipijAnPKxt+7m7R0ZkNoYBwfTDWhL7JvI1Vvnu/gAhnE6x//ceVjFF+WXpMKra6DsmfIgOKdmfXTf7aW6R9F+3Od4gSzezCu0s5v/ew0MkD+IAccl5368Xh7It61CwGA0brTuF1wNCcAT/WCoToyxQkKLF5BWFClKhiskFIdZ5hz7oAQeH2mlVhzHYJGYsG99nFqPq7pl5eaZnlnJOw3W33BQ+98CkONoaa5G9QnJa6RK7n95Ww0DLAM3cBxijtej
 iacjrvtF
 oKQrviNGmrznhMar5KANyJvZwqqe+JXk56GD5y9Y+ubrjVLmT863d0J8pyfodUkM9C4//iSr9tf/1stF7R++JB1lJIIfh+qSpkCD8DokjVXcD2bVzmTfVEQFJ6+/t6RmtsOVMlROJZkvUUGpwII0ZBF6x49DIXtrThwAkrlIYrUlweRqDuwn6pQXz5CVRMP4pNZiaOlkLYZAKsQK6Sw9ldKoqWWTO6oUkbO60GGb7llovzVMe5Mj5baKCk8fnJpOcLNDXKGbxI9c0nmpOygs2BpwQTa9w8bhZwXfgpWUbjJqzboGuYl4RvGnuoWREJ76qxbtVpVZq3kQLwzSgB0Uae5QgNSMT5f7X15svK/hv182JZnluHmccMzHY4r8NqWa+MQj3J0vGQQIGJXJBvpb/K0G8qbsgJ2kmejKl0tEFKOfp7Bhh9JFJchTQuPISJQJVQlZcuJeDI6PMZ4U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kmalloc_double_kzfree() would corrupt kernel memory when the just
freed memory were allocated by another thread before the second
call to kfree_sensitive().

This could not happen in GENERIC mode as it uses quarantine.

Signed-off-by: Wang Wensheng <wsw9603@163.com>
---
 mm/kasan/kasan_test_c.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
index 32d06cbf6a31..02e43ccc9f21 100644
--- a/mm/kasan/kasan_test_c.c
+++ b/mm/kasan/kasan_test_c.c
@@ -874,6 +874,12 @@ static void kmalloc_double_kzfree(struct kunit *test)
 	char *ptr;
 	size_t size = 16;
 
+	/*
+	 * Only generic KASAN uses quarantine, which could prevent the just freed
+	 * memory from being allocated soon.
+	 */
+	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
+
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
-- 
2.43.0


