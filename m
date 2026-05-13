Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 167F6CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 14:03:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE7F56B00F1; Wed, 13 May 2026 10:03:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D98596B00F2; Wed, 13 May 2026 10:03:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CADF16B00F3; Wed, 13 May 2026 10:03:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BD96B6B00F1
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:03:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3E6C3140134
	for <linux-mm@kvack.org>; Wed, 13 May 2026 14:03:25 +0000 (UTC)
X-FDA: 84762563970.04.930F1F9
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf13.hostedemail.com (Postfix) with ESMTP id 746FC20027
	for <linux-mm@kvack.org>; Wed, 13 May 2026 14:03:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=JWcMztLE;
	spf=pass (imf13.hostedemail.com: domain of a929244872@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=a929244872@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778681003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/lwiOPTnvlBpog3cv49D12gfGRsm5qJ0BLZQamnSSg0=;
	b=t53Xg4kqzDA6oNK9T8xXxVKCVgdgP2TqiAa7/zskt/CkVI456qBzWO5sgmVNOHc8gxaEAl
	eaq+9B37nV4u1weBnY3O8WN4BAuiL7E6jA2LHNUMxL3LLepUbFHiWn9RRhj9oWtHaluAD0
	A/Si0E4SJEm45XZ6TKyjTi+UUBYpUug=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778681003; a=rsa-sha256;
	cv=none;
	b=7tdxcwJ/50cg7u2DFFvBZpkN3QwU0vYkcKVEGS2H6za2i6Xl9ciiqeOtjspJROlFHJADD6
	4isjqF9o8o/mOYW+aPM7xxSCum8LWJF4XBDc6S3HJJYW5el37cOe0KNZ2eMSARynABshME
	wHjzWBjCoVlzv/A3jth/SCqazIEhPJ0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=JWcMztLE;
	spf=pass (imf13.hostedemail.com: domain of a929244872@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=a929244872@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=/l
	wiOPTnvlBpog3cv49D12gfGRsm5qJ0BLZQamnSSg0=; b=JWcMztLEhA7kS0JHqg
	EmpAqZK9WQoqCxXZzTk5weZVCoW5P+6gMt9FWbXLePTUj99/RmkKih2od4xB9KkN
	mMIcTzWJKPsUHJUCMa6ZdpHsRESXVyZfJOgRyWkT3SCfLP+WuD+23QBggiJUOYhm
	e1kSjxxpLh3U6zFEF4St6CCIc=
Received: from localhost.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgDXniBxhARqrEiHDg--.29S2;
	Wed, 13 May 2026 22:02:27 +0800 (CST)
From: wang wei <a929244872@163.com>
To: richardycc@google.com
Cc: akpm@linux-foundation.org,
	axboe@kernel.dk,
	bgeffon@google.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	liumartin@google.com,
	minchan@kernel.org,
	senozhatsky@chromium.org,
	stable@vger.kernel.org,
	wang wei <a929244872@163.com>
Subject: [PATCH] Re:[PATCH v3] zram: fix use-after-free in zram_writeback_endio
Date: Wed, 13 May 2026 22:02:18 +0800
Message-Id: <20260513140218.7425-1-a929244872@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260512074918.2606208-1-richardycc@google.com>
References: <20260512074918.2606208-1-richardycc@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgDXniBxhARqrEiHDg--.29S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjTRPrcfUUUUU
X-Originating-IP: [240e:390:c93:1a01:40fd:cd93:6bc:1818]
X-CM-SenderInfo: jdzsmjiuuylji6rwjhhfrp/xtbC6hTZgGoEhHRf4wAA3F
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 746FC20027
X-Rspam-User: 
X-Stat-Signature: jsp84rqz3e4wkunujqic54nctsh1qgoz
X-HE-Tag: 1778681001-282632
X-HE-Meta: U2FsdGVkX1/UQeLrzjdCVCAMndSbCoNKczwtU2iP0CSyYTATgXmZqGlV1ZSGuFS5/zySkUtOTeFZEeW5qpkAmu5ySrQmX2+mUZ5R9hWnXe4f4cEN8AkNraG33qzlyHwl8qKL7x3GeBcqkIoXF3dCl7SEHn4XmoS4JL7gbMPr1GsVb6L9JvhBuoycMA+GVfQyQUk0Lyg4oLxOmPIvkZk7hcaIwRL8LvrpPJkinOkzcXf4MIAfooG0U3UOmXfmDm+ge6TTPVHnZMlDUP/jMp6OE3SIncPdhyZzELQoADoQeD5iFBF434OqRPzgV7kbmhLQa6i+hkjCV0fZJmBd5XBvuLic0B4yrJ7ulUV4oZ4e2Y5C2RvmEQ+8RrvJFuK7UiLvZ9Jou1vWr8IJuLehTTcklLRMXBXWt5jPOlZeFgGSQdTXBr9WXKdg3zWQizCKVO41FzXrMBQB6QQ1MhEnLmK2UDzvJ4asyaS2oHEjkhzLp/vgrOaNdFWKUUZOpOwBndtUYjb/QzYv7QAaRIUShc2v5Gki0rQLB1W6Tk0KwxXfuliPBFkW28RxDGaOvfwm2XUOjictT3geJf4ki5FkCFWhZG1BrfrTQHr4ZK8h+G8pQouS6+CCR8cHqB7Cpv3P2JImeDEAimwNyGci01IWg3fUohGaAu6t9fWRG2QNIzA6iKxfdgCQzpnf4kM7wJapE2ET1TOvoEyoAo6pU6L4t8j34cbWm33eKbRk1FGA2VcpHSwyp06yTWGC9KdTQtFaHMOzwDmcvf9dFKDt87k0QicNQw/nha6+DAeRWeLbVPTxsjFamZCv5NNrd5bg5pCpcuchbBm9D44yAg0rJwLVfi5aFSMVdSLeEG7Avf/8KgsMlwnmep3mskFQC2PCNyAp+rEgGyCwMzoRvyaoWhbeoD2HQKoYuyeFq2jYVKZNMvBL7wGF8liYoj8pgBL4X8qpstlSdsYYLrZiRjtrvSwXKZ1
 D6zNf3hV
 Snwv6ZbecrSS6nAA0WuHynosmhPsj1gMM+nXN9Qqxf0GA4ccOgH5QcqdWXxAzSfwnP8vqJTn4R9yXsHCZaOVznk5zS50Ma3FQtmFh1AVllkCY6bnLj6tVT0ww/P4ugdvyAkFWLSM8XcjBvHX3gHjKcfMvF5+YSKvAjOgDxs/lv0I59aZowRrmyKml1o9QZTo4UNh6J6gtZmLumaRd5E5LFGjx7cfuuwJMuzjnYow4oJoXp5DjAKrcV1yj3PZIe+BRRXIb1I2jYfU2Gxk+zMCegGdh4k5qrO0c+qO8lPmnkt0ntwX9soaFFOXMZqEdhoINqI0Cbzc4V1Ri0RJ1gA0Y08ZBLjwR8relu48T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>@@ -847,7 +849,7 @@ static void release_wb_ctl(struct zram_wb_ctl *wb_ctl)
> 		release_wb_req(req);
> 	}
>
>-	kfree(wb_ctl);
>+	kfree_rcu(wb_ctl, rcu);
> }

Do we need to add a 'rcu_assign_pointer(wb_ctl, NULL);' before 'kfree_rcu(wb_ctl, rcu)'?

Signed-off-by: wang wei <a929244872@163.com>

-- 
2.25.1


