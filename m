Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AFC7C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 13:54:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BE256B00A2; Wed, 29 Jul 2026 09:54:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88C926B00A4; Wed, 29 Jul 2026 09:54:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C9DD6B00A5; Wed, 29 Jul 2026 09:54:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A9A26B00A2
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:54:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1D71D80452
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:26:37 +0000 (UTC)
X-FDA: 85041586434.19.17A0A28
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf07.hostedemail.com (Postfix) with ESMTP id 90E7840009
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:26:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=c0CyrNhC;
	spf=pass (imf07.hostedemail.com: domain of yujiacheng3@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=yujiacheng3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785324395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o/ioV+0lKVSCMKWDxyofqVQddDfBDoxkVm+507Wo/bY=;
	b=knm90aMaGU9K0TxGJNRgzt9VJm9sglwX8xIE85Laz1Od9NnnYG7hx0eQDzW9aIvonf5s+7
	JT7xhuAzEiK65bV025lbSXo6XG4rJL7+bRceHtS7Yyy/Bw4bMkGHaoZNVZotsTbT/0oMG6
	spVIOXeiLbO+QOGQ2JX3sv1ut6gT6RM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=c0CyrNhC;
	spf=pass (imf07.hostedemail.com: domain of yujiacheng3@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=yujiacheng3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785324395;
	b=UHPWcs2c+lu/th8GVpdUKdoKz4LKIjkFZRHQYl7xycd6LrG4He63bLJXP3w1VVC+72ktjt
	Uc3lFwsQ+8VoQlodQsnWtvYJO9F3DZJ4z931UUTDccY2hA+HUu5E3gCytjDWqpqG4VSgZQ
	83O9T/gKN7tW96JvVsiyvNbIhflcPOM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=o/ioV+0lKVSCMKWDxyofqVQddDfBDoxkVm+507Wo/bY=;
	b=c0CyrNhCnH+glw29g8WHcTRlHy5BaYXsl5JWDLdEYDXK/5Z19UzSW94hBI5cpJO91Gh5e4KNs
	oleiGi6k5Nl+VZ6SIlJwUnP/KFBOtQRBdgBxp2SlLl6pGOGjAQS9C/4FDo6RGga2/MaAEsV7lhQ
	Ue8a+MQ5z3o6FsNeEFyN/tM=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4h98tP20hhzRhVP;
	Wed, 29 Jul 2026 19:17:01 +0800 (CST)
Received: from whupemo500009.china.huawei.com (unknown [7.152.184.116])
	by mail.maildlp.com (Postfix) with ESMTPS id 1AA234057D;
	Wed, 29 Jul 2026 19:26:27 +0800 (CST)
Received: from localhost (10.50.87.202) by whupemo500009.china.huawei.com
 (7.152.184.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 29 Jul
 2026 19:26:25 +0800
From: Jiacheng Yu <yujiacheng3@huawei.com>
To: <petr.pavlu@suse.com>
CC: <samitolvanen@google.com>, <rusty@rustcorp.com.au>, <hannes@cmpxchg.org>,
	<yosry@kernel.org>, <nphamcs@gmail.com>, <liuyongqiang13@huawei.com>,
	<linux-modules@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>, Jiacheng Yu
	<yujiacheng3@huawei.com>
Subject: [PATCH v2] params: fix charp corruption on allocation failure
Date: Wed, 29 Jul 2026 12:32:43 +0000
Message-ID: <20260729123243.790023-1-yujiacheng3@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <ff0b7cdd-8fa7-4cb8-9e21-6a7204809766@suse.com>
References: <ff0b7cdd-8fa7-4cb8-9e21-6a7204809766@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.202]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 whupemo500009.china.huawei.com (7.152.184.116)
X-Rspamd-Queue-Id: 90E7840009
X-Rspam-User: 
X-Stat-Signature: c8gukoqqekdxixxqpcia4rzmsugxiscj
X-Rspamd-Server: rspam04
X-HE-Tag: 1785324394-504641
X-HE-Meta: U2FsdGVkX1/P+1cruMsLcSSVcIObZgOPEB6NX2HrUcxIV48urMvQrfmdt8u/79UdldbIImkwV7tjWwt8yBGkESVgH6N8X2+e/sT/MjyV51mE44bFs83zkZfR3qibQrEfCwxfMkbsxwrVpjS3uSQmoWAAFlZ2y/BC4itypui5fF3hi3yv9Z7lCv7ex6bqZ7yoi7Qn0hyTTiwyeCUXFFdq6q7ho5qr+X7mWxvblUhyEuEFhD1jKxFrqQED5evVCb4qn66fw+khgtldTB4wFFjgSFJshF8xwiVYvYuGWUL0J+dugjsWyBJ4Jhp7KJHZwo6MSSc5Z3xDyem/wtoTiZdfKN5EKL7Yz5KC6F2mHy4m64+USROuJWTv/I0kWzbb47m9RenzFA8LSVXFXEx3x+1EuLoH18H9I0M0aY555mebpEGuGtWBMykXzO8PSkNlyVmF5BOf+bdGlOP0zPGIVNOIYDMS8lY+rcuE1bFrn01AN/JxApSt6SX0T8YBM8uKqfXQAltJFuaSSLWbkpvAhPmGTXoD1tpfm6F18cf82FR+9RvTe/P7LGQle3yX7eytFHlfr20GwZ8EKzkyBbNbkLgmfqss0qmaKAl3qqSeng7McBMn7pxPLyRjG7y5S4VUsgMBFW6O8LC7v2XHr0EqMXWISmr70XkW4luuNsPpaP+arsIgbq0T1xlGBeHBi7U0wOJYwV+CT/xn+emgcjIKkp8nuzPyjTzIXqkHvaOQON6H1TTc9qElsc+OQrE8IvzYqTY8d/pbbO96rzsYXZLThFMsI2mWX7KrrWYfAF71JEQxgWLDfC1xYkAC7pfFf9zm07dKfgWJ71VZ740UJqeiaJwBNp4zrVONKTnaXxDrTTOVJV8akv/NveOq5DGZmy7mh2viSP1TUL6hvpQDi5NPWRlgOzjvjWcB4rwLKn20a4Z2i0ttbgxC3Fpads6JBv/9axZH100UZL6yQ4MCZyq9f0J
 TfKuVidB
 xRkIWo7L04MaJ/jG17hhYWRv2bcKWStW6HVwdxqdloqP5eMweLHZNhGLZH9kKLQ6t7uravrU0lHADqqLeeCEs6vBAczc8UzQfwAxr52sd0L0hBUDx8SGbvwhX51d65ycJG/x4yy1gNwzGQfzzjPWfgfDrAzYeF3UmQWYSfUOZNCmiL2kMwkoMujKi8pWsRAjD2XUuiAUK9oM3uuSIcgP7b5AmYbMhw3TYQIBgh5OJeIGa1RxoX3yRvH+NuSUz5D3jQsCl91E5QxPw+aefeWavmvTDhlGpME1GLFYqQ6HplCHZzsMpxr3ObkOkdIh5j7CcnqFud8wRl15KtdVTQI9n5W9yBwuR28jmrTHO8DXBgHCk9Xs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

param_set_charp() stores charp parameters in allocated memory after slab is
available, and releases the previous value when the parameter is updated.

The previous value is released before the replacement allocation succeeds.
If kmalloc_parameter() fails, the setter returns -ENOMEM with the parameter
left as NULL.

Failing zswap's compressor update before zswap is initialized can later
trigger:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  RIP: 0010:strcmp+0x10/0x30
  Call Trace:
    zswap_setup+0x3b1/0x490
    zswap_enabled_param_set+0x5b/0xa0
    param_attr_store+0x93/0xe0
    module_attr_store+0x1c/0x30
    kernfs_fop_write_iter+0x116/0x1f0

Allocate and copy the replacement first, then replace the parameter value
only after allocation succeeds.

Fixes: e180a6b7759a ("param: fix charp parameters set via sysfs")
Cc: stable@vger.kernel.org
Signed-off-by: Jiacheng Yu <yujiacheng3@huawei.com>
---

v1 -> v2:
- Use memcpy() instead of strscpy() as the length is already known.

 kernel/params.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index a668863a4bb6..939ef84a46ff 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -261,6 +261,7 @@ EXPORT_SYMBOL_GPL(param_set_uint_minmax);
 
 int param_set_charp(const char *val, const struct kernel_param *kp)
 {
+	char *tmp;
 	size_t len, maxlen = 1024;
 
 	len = strnlen(val, maxlen + 1);
@@ -269,19 +270,20 @@ int param_set_charp(const char *val, const struct kernel_param *kp)
 		return -ENOSPC;
 	}
 
-	maybe_kfree_parameter(*(char **)kp->arg);
-
 	/*
 	 * This is a hack. We can't kmalloc() in early boot, and we
 	 * don't need to; this mangled commandline is preserved.
 	 */
 	if (slab_is_available()) {
-		*(char **)kp->arg = kmalloc_parameter(len + 1);
-		if (!*(char **)kp->arg)
+		tmp = kmalloc_parameter(len + 1);
+		if (!tmp)
 			return -ENOMEM;
-		strcpy(*(char **)kp->arg, val);
+		memcpy(tmp, val, len + 1);
 	} else
-		*(const char **)kp->arg = val;
+		tmp = (char *)val;
+
+	maybe_kfree_parameter(*(char **)kp->arg);
+	*(char **)kp->arg = tmp;
 
 	return 0;
 }
-- 
2.34.1


