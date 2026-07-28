Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BF4FC54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 07:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14F336B0088; Tue, 28 Jul 2026 03:50:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1003B6B008A; Tue, 28 Jul 2026 03:50:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0C926B008C; Tue, 28 Jul 2026 03:50:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C64616B0088
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 03:50:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 46C5C402E8
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 07:50:03 +0000 (UTC)
X-FDA: 85037411886.16.B12898B
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6FEAF180003
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 07:49:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=qQQEKvZH;
	spf=pass (imf16.hostedemail.com: domain of yujiacheng3@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=yujiacheng3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785225001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dVbEMkAH4oQeLM+2qQKORoOzs7wAWPFGJUizPSN6T/o=;
	b=hbDC7y/ujTruXIcF+3S84sH1HGd8E5DHgEteyTbTIZfJUoLxLhhAZj3xGZOTmO6dvabNAb
	RjHa4NUoEWFxAxUXX6plp9qYH6sLPUppTWxMuCQ1CyEY9E4+leHNpo32OuzznwbB6Lhlbw
	vYxDYS2t0T2taHjEiEMtvYAvwi6U3I8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=qQQEKvZH;
	spf=pass (imf16.hostedemail.com: domain of yujiacheng3@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=yujiacheng3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785225001;
	b=Jo5nr66nypB3Xqc5d9LHoQKWCU7WvRf091NmqUWueXf1iQ80DGjwOreXJwMhsHbDy6eBkM
	9LKBMEZrabsRX84NkFrDLeSUMdvXCLviJyfBvtppgnTT7tkPIRoGZqlst8/Ficodzy9LgT
	U0dhcwjJuLFXWoAaOzg646lsTP3J/t4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=dVbEMkAH4oQeLM+2qQKORoOzs7wAWPFGJUizPSN6T/o=;
	b=qQQEKvZHLWWqDDOyJSQZV4u8a2fga2Y2dfFmfzcl/ChI5LAbYXn/sAqt467hI+xhhHf6oniXl
	aiUhuQy12/ciqRrA0UcsKDQIAYZ3TxLIZn7CtI1yFg0bxU4Ld8oOLjSHbObTX+WZOSRC6wIdUbM
	0uIHXOFVvirdQSfGacfbtNQ=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4h8S6v6WFxz1T4JN;
	Tue, 28 Jul 2026 15:40:23 +0800 (CST)
Received: from whupemo500009.china.huawei.com (unknown [7.152.184.116])
	by mail.maildlp.com (Postfix) with ESMTPS id DD1C740575;
	Tue, 28 Jul 2026 15:49:52 +0800 (CST)
Received: from localhost (10.50.87.202) by whupemo500009.china.huawei.com
 (7.152.184.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 28 Jul
 2026 15:49:51 +0800
From: Jiacheng Yu <yujiacheng3@huawei.com>
To: <petr.pavlu@suse.com>
CC: <samitolvanen@google.com>, <rusty@rustcorp.com.au>, <hannes@cmpxchg.org>,
	<yosry@kernel.org>, <nphamcs@gmail.com>, <liuyongqiang13@huawei.com>,
	<linux-modules@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Jiacheng Yu <yujiacheng3@huawei.com>,
	<stable@vger.kernel.org>
Subject: [PATCH] params: fix charp corruption on allocation failure
Date: Tue, 28 Jul 2026 08:55:18 +0000
Message-ID: <20260728085518.3865621-1-yujiacheng3@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.202]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 whupemo500009.china.huawei.com (7.152.184.116)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6FEAF180003
X-Stat-Signature: wqrkrzjbpdfo7kjn186f6g8zih3ma7qm
X-HE-Tag: 1785224999-183426
X-HE-Meta: U2FsdGVkX19i7kqMPfOmNy1SCvm/8rpgQjBQTbRnLx3nqcI8A1uxh+TQDd0bQ6M4BOxTh4iKGQZUpA/hFuvO6Frq+AkyieA3SkGQDBBsJ1mGS8dhhgKmDBJmpLwQICkqv3Dt62T16bU5DL+G3OLnIcZGF5KGjNtEsufcxceU5I6oj5qMO56D9gVGzacmA1xoXEVEhT6r7y6UtAw/Op4V56GaEqOo5VGh3RrW0VV/UslciLtYKI2WG57bsn7lHXwepYGfl+vIlotYWqmX2XWfL8l/oMmIUCFifnpUUoJz9R+uRdNIBewCbSFrG298HGt3PrfrT03DW7q+ICa5UDa0xNq6t2TnFCLLNndUQ25Bx40nwxXLUryIiRQGVF0pnpK3MuvKDTlWbadaoZ+lFM8boUVS6NYkBAP5f2BSxxunFjqixqxWixemNMHdq5FxpmeiouRvVguDriwzG90aHGBCirvN2gJD0GobC4aaYAo1C1hwrdU8hfvlL3gwAilZ9cCsShUZDsnze5u0D+vS/Sc4zjVz7gqhJIR2ZA1KNOcMhgAxTWKbl1+1YvP40hI2/tKZFqF8bmEnUyyC1DdG4li+i6hqhW1qfTGbxPqL7B7TPp/gzrgCK+DZaVYJG6LaFa/7490OWIQrR9MIXw+evr/osrL5JWYvPesYAoU0Lx2pkgtmfYJ+vBTdZEU2WYUYYPzzsKB6gkmCwRuNM8F3s3zsGc+fMyahR0GWtt1ztSsL14hV9WbHFdmyPe3IrnbXwXE2FV91VX+4lKIxsP//0ZnbaBGNUMEQUkGO3qhpFe4ILbbaApwRXj1VIznUo8zOldyJPbjflZIlqwD6YLaGu0VQc35hpovNNjog7ipjV2idzbox0fEwSmIE/kESLhtKqxA9t06G1A9dscCAS84Km02rgi85jqupOB7lUhWF0gZVsN60lgLKKgTWh9QWvKVYWQ1L37vOMD5H7lKc2qYxcYy
 UJhkWsA/
 feKNAXUDxR+6GZ+u63rc4k+QqcaHMDenPWmBlwAlUOZD49VqoaXgtYfFkQkbg1aU/qd99USB5OZ+l0q2Ix6iMV8IDogeEWAfWIkfIW6jPpvZIDBWhwTvdkQh4l8+oz6LsMwwGerRYCIOT766NLdXJZUHpThAuKG/93cPh6k0eaxAtt/XL+k3hF0uaqVAzwAZTCy0kOFUNsF0BRGQL9hK91uvaQs6U3ZUx+ZwhsN7MRcAVFDPwvaaWF9dpK0hQybVVTKv6EJi3InsVy5THvN5Qe9E4NVB0CAuubGuTzMRLlsKKH9w8xSIDOumYqPM93DOoVgPlY/ii8nELnibvuwVLDY81EQmaLjVpiFNbIjZ/Iti68Os=
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
 kernel/params.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index a668863a4bb6..e4f2b71dde1e 100644
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
+		strscpy(tmp, val, len + 1);
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


