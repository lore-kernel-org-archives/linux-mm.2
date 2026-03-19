Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B4AF1090247
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 15:58:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6257D6B051C; Thu, 19 Mar 2026 11:58:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 593586B051E; Thu, 19 Mar 2026 11:58:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C5416B051F; Thu, 19 Mar 2026 11:58:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3FD196B051C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:58:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 09F5E1A05A0
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:58:01 +0000 (UTC)
X-FDA: 84563268762.29.9DCE60C
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf18.hostedemail.com (Postfix) with ESMTP id 09A691C0010
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:57:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=J0IrkYMM;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	spf=pass (imf18.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773935879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yqwjs8HCz1qaJbZTaGQP4LkV0ZgUX/+x9dm2bkSNu3k=;
	b=uyrEtM+amV2YScwcWXrCE4PjI4XzoFZiBEwDGJOXd/UIQaUftAluqqHN+Tk1CM/52Q8PTZ
	3e6tzIsHwcRoCfteubrTe6Xeym7BZn3nfX3WOULQTRjE9ypm8ibpqksOo/oIKbbpWPWoo6
	X5fwmMf5Sa8ILVwZGma21SCNZ18wiWM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773935879; a=rsa-sha256;
	cv=pass;
	b=sJAhPkGBMBKWLm8LiL6Gr9kvkar+LqeLF4aa4KFo82bosLuYpXGF+3AqntNh2bXRyWjKqM
	xTlRz4Ykjj2xUVYyLLloPrVTAr5QibUMovs7pBitQCFUdcFOYXyQSFUv/ZXLRF3V7V+opz
	AcqWW7keqA5Apswo8ob6bbGXxYRwjXE=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=J0IrkYMM;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	spf=pass (imf18.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=1; a=rsa-sha256; t=1773935868; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=CI9a1WdQDHNBO5LmDiXZ+zHg1T9l5jwDZAg9PiwfQxq60i/JHTriM5qT08U8oPIcxQD26D8OssOazDGQh8+5JiLTVu1Tyx6aEdtVVYlEJA+ja2bMOz6vlOKOzKYXwsDeJBi8e0oOlw6MT4bbE90irrgA3wW9+b1t0KMkGuLg/Ao=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1773935868; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=yqwjs8HCz1qaJbZTaGQP4LkV0ZgUX/+x9dm2bkSNu3k=; 
	b=WWwwFzjHBE33VKmmHAu1r8RiQU+XbxBxfobcBz34crIsg3KHmQGau1yDNyvcWPI6xTvJkBwPqKmN2rdJy9RW6ZfGhVFS0x0hRkxws3Z+gu2ypOzg66auQRUXUrI8nGmWqgNYTHTApj5kNEVrzXxnlgM4CSQm4KWC2OdL+kCeOaY=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1773935868;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=yqwjs8HCz1qaJbZTaGQP4LkV0ZgUX/+x9dm2bkSNu3k=;
	b=J0IrkYMMDk78IqYe33PNM3IEF1/Ei8kjFJj8ruD+Q6IEByNziVn+7nB6vKUwWBjS
	4ZJV6b9ItM3eFui+GVQDebf0Ry0MLpXpJM2PH1tR5sLIPfGP0DWtQ9kCYAU8xftu9BF
	u5FQxWjWJvZ8nSD7wt6LmItfc6hVnTBIzdV9eh/Y=
Received: by mx.zoho.eu with SMTPS id 1773935866558314.7705252149991;
	Thu, 19 Mar 2026 16:57:46 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH 4/4] mm/damon/sysfs: check contexts->nr in repeat_call_fn
Date: Thu, 19 Mar 2026 15:57:42 +0000
Message-Id: <20260319155742.186627-5-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260319155742.186627-1-objecting@objecting.org>
References: <20260319155742.186627-1-objecting@objecting.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 09A691C0010
X-Stat-Signature: 9nqkonfnxgertgbgnyugmatwc6e8rgmu
X-Rspam-User: 
X-HE-Tag: 1773935878-795973
X-HE-Meta: U2FsdGVkX196jMO7s6un/Di4mTs5GjjbemAfeFAAb1Q8R5RYl7JRX7/h8O1IYXblZ5ImMhfk1TGM1+1W1aGtx8QNyChZ5qVrw+nHO68hJQQ2bCGHk6DGmMwrh9+kimf6MuY2CnbUukgRgVvPLTHs3J/2uwgrzxh50nLeb+4bADIMopUnUzLVbJ3mmzCMB6DFaEYym9fh41YSpqTvi0vsu4f1iUiayCJXpfVlXjlFgsYUt0GOis85va1RBzF8N4WSAXaRkMkeLomuvhDXjxg7NuLDx3xkwjHmTrh/ceagrLeqjln0J3cBfO2Pf7AMKVHbeifCUEH6AlZHP2TUZ4nS+d8e2wi0kKULirt7IP3o7sUt5brdfXBqM3jV4S5MjX81S+BorSqDNBp/3bJnBC4AcV8uYrB3cidYq3QDd5eucL6QAIP9aIrmIe7InAquz8AwG6qYCvck8IiT48y6RIHj9pu25P8it/yRv1qf61qfxojxp2IpJBHZYZX6vVTv3ErvG4b4bZSJEkA1xrRNnVf3oKxTbpd1h/q7Uek0kRCqEpzaGraORL5OzZXfrUvsKY7PxbdPocrK8Wo5Un0hOIDufOW7qlBW+lWpQztH3K5B+qatomeMwhjDxSM1wt3PDhBWHEgpbyMFBECKd/KSNh66bAnbKHk2mhGDUpGPWScA6dmCwlfzS5huUPjSyv7NjeDx7o3SsS6NR5ViWWCKfXCEASO/Cu+Q4RMvX2TM83MthNhuCMmOmrWWt3ZYZr9G7eJSWK+xjTgohEXpiPL4G/YQmaXJAyqjGQLtCr7+oyZeWv8KSOYWId3UzjESI3dsuphD0JLVufHWhRhZMEmqn/q3UwUq571r2OScm3fQqL27tIeTNfr/Em+6yAUuciCgYKehwdK0s2o81EOf3i8zKBKBUgzp3hrdfZ3MOv4isLRNY0KMzw0iLybd4PXJ8xNIkZyuYwEQwGGdrnhCxEGw4tk
 CwKb1p5j
 xkq43H+tPyn4JAHE244TvCI7lZ1U2V+CqWutC8EOWUelIZW4JbOIwP5B+KQrflxZMAhkZcyiktBZ9jdnAf/bKGELbdoWu344my6FPF/LksE2q3s02PxaRe9kiH6t7w8ofuoJJ8yScnae6qTt3miKxrCMjEa0Y1/d+7SNcWBK9t2XgIhMQTmi/GU5SeDJpQckHxdOKyvumXhx95wAbpZ3tnyfSBLswPbBbvxv7kTSzYlzlANq6cbLeYpVNCEpw2hDJLRmo37+RWPZ1EnESW86CCJQxAyYOXwkZvxmclMKekjR4O5qYj/u65Mmhvj7vFUNPsNJpKJsBmmXCjWA7MQEBS5qj4QsgJ0nCPFj5QqXYll1gqRH0epELihMi3xQRLDgyJvLNIhUzXl9no/7/2M09XHZTej1STOl9Zv9iNYCJ/2dFJCw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_repeat_call_fn() accesses contexts_arr[0] in
upd_tuned_intervals, upd_schemes_stats, and upd_schemes_effective_quotas
without checking nr_contexts. A user can set nr_contexts to 0 via sysfs
while DAMON is running, causing a NULL pointer dereference in the
repeat callback. Add a guard under the lock.

Signed-off-by: Josh Law <objecting@objecting.org>
---
 mm/damon/sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index ddcdc4e35b27..d982f2dc7a2b 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1620,9 +1620,12 @@ static int damon_sysfs_repeat_call_fn(void *data)
 
 	if (!mutex_trylock(&damon_sysfs_lock))
 		return 0;
+	if (sysfs_kdamond->contexts->nr != 1)
+		goto out;
 	damon_sysfs_upd_tuned_intervals(sysfs_kdamond);
 	damon_sysfs_upd_schemes_stats(sysfs_kdamond);
 	damon_sysfs_upd_schemes_effective_quotas(sysfs_kdamond);
+out:
 	mutex_unlock(&damon_sysfs_lock);
 	return 0;
 }
-- 
2.34.1


