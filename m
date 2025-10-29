Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F324CCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 19:59:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A602D8E00E8; Wed, 29 Oct 2025 15:56:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C24A8E00B2; Wed, 29 Oct 2025 15:56:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72AB48E00E8; Wed, 29 Oct 2025 15:56:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 587598E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:56:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0A4125BB7A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:56:43 +0000 (UTC)
X-FDA: 84052209486.07.0222FA3
Received: from purple.birch.relay.mailchannels.net (purple.birch.relay.mailchannels.net [23.83.209.150])
	by imf19.hostedemail.com (Postfix) with ESMTP id 70E761A0007
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:56:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=israelbatista.dev.br header.s=hostingermail-a header.b=BtIQ9oLP;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of linux@israelbatista.dev.br designates 23.83.209.150 as permitted sender) smtp.mailfrom=linux@israelbatista.dev.br;
	arc=pass ("mailchannels.net:s=arc-2022:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761767800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WolUbWMYhTKtGWyaFGgWLL2fNJKOm0lY0CYaviwkYk8=;
	b=bIGlEUJ/5K2hEgi5XQgtH9WKHaCqSRDeNo+jzzEd7Y/3wVDJXjsx9D/h7N7d4gND66C9Vl
	Es0v0ejKBDIqPJkPz1BzWajFUdDTK6aPH5q3dUlSOe767YyOnCI/Mffx+Yw+FShs0qhCy6
	83TiBFrwXcKL4cUKNx5HFGAJn832kio=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=israelbatista.dev.br header.s=hostingermail-a header.b=BtIQ9oLP;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of linux@israelbatista.dev.br designates 23.83.209.150 as permitted sender) smtp.mailfrom=linux@israelbatista.dev.br;
	arc=pass ("mailchannels.net:s=arc-2022:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761767800; a=rsa-sha256;
	cv=pass;
	b=lB8vhw9Kwc4ZnADgkOq5nTwq0RAjiQERGa8wwzo9nYlRXC6u9HVK5XbGtMU1K5iPMzwddk
	qWqBuo1dm6PFdyWObnprB/kfYjntLegYZq8J/2xNrzchzYNvt5XJWlGNLcXA252UH3MugI
	JCCvXQ0i0Bl9u42xV7/kJ9lVwlNJuoo=
X-Sender-Id: hostingeremail|x-authuser|contato@israelbatista.dev.br
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 10EA68C21F0;
	Wed, 29 Oct 2025 19:56:39 +0000 (UTC)
Received: from fr-int-smtpout17.hostinger.io (trex-green-1.trex.outbound.svc.cluster.local [100.121.87.108])
	(Authenticated sender: hostingeremail)
	by relay.mailchannels.net (Postfix) with ESMTPA id 8DC438C1D5C;
	Wed, 29 Oct 2025 19:56:37 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761767798; a=rsa-sha256;
	cv=none;
	b=LD0/tOlrd5/2wZtAA84S/iugi6j8Z3jhVxibKSDgfSHSb0anzag2xZ4cEVgGXN3QAchfEV
	5AV50+BPVkIQfovk+55Hoh5qyL6P8V/NOx77qy7bvYcWnnT4ytv4cfWLxAoPt1Lbu832sw
	y2q1IejGPeu7gzfhaHSSgjwDWVP46HLmlZ7BYErpvDXzXZfqJt8ssn0ky2bgqY9OruXI27
	OMVJNtdw6Hnx5udPrG0il5GFdyplTyVSEc/QK+KwdvrD6A+0Ff30Y4IXxO3mGQqfWaN/+l
	NyujdabCkB3eFZwcGbKlq5vkyloVC6yQEG3K2dNuKAv3qfHKPuhCsiLMUOoNBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761767798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WolUbWMYhTKtGWyaFGgWLL2fNJKOm0lY0CYaviwkYk8=;
	b=zjGorpWpXKAhJQ/kB77E6L58byi9x8pCb9r/VHoPmZu8VjkPKXHpZc6g4CMCO0s6J5KfdG
	fBr8YTIMoHY/rfipqxNAUnWTQewB/+XeyY6jGyAZl1sOArydF5+rBCT+HM81dWdaKNilof
	3THXVBYSDstTShU2QlL0evpMqyb+25srygeV7sAVJqYl02I/9vXry8QSf8mHuo+rLfcns6
	ege4X5gYFm0CxEhwiMopEeB8vh3KICp/bgCw+GC2Wz5ewk55x9UCdTaIiGm1CPz/5XEB1T
	Gt2hHoVSOLlEhSIy1w7S4H1hqEzCBG2jdTd1Wa8+CMhGzHy3qjrq0qnVUq2TzA==
ARC-Authentication-Results: i=1;
	rspamd-77bb85d8d5-gc7jm;
	auth=pass smtp.auth=hostingeremail smtp.mailfrom=linux@israelbatista.dev.br
X-Sender-Id: hostingeremail|x-authuser|contato@israelbatista.dev.br
X-MC-Relay: Neutral
X-MailChannels-SenderId:
 hostingeremail|x-authuser|contato@israelbatista.dev.br
X-MailChannels-Auth-Id: hostingeremail
X-Ski-Tank: 63c1d51e1a5db1a2_1761767798943_4097797406
X-MC-Loop-Signature: 1761767798943:2569415482
X-MC-Ingress-Time: 1761767798942
Received: from fr-int-smtpout17.hostinger.io (fr-int-smtpout17.hostinger.io
 [148.222.54.37])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.121.87.108 (trex/7.1.3);
	Wed, 29 Oct 2025 19:56:38 +0000
Received: from fedora.tail0cc0bf.ts.net (unknown [IPv6:2804:d59:8970:3b00:5f26:e2da:68e6:2358])
	(Authenticated sender: contato@israelbatista.dev.br)
	by smtp.hostinger.com (smtp.hostinger.com) with ESMTPSA id 4cxdKr2GMCz1yFv;
	Wed, 29 Oct 2025 19:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=israelbatista.dev.br;
	s=hostingermail-a; t=1761767793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WolUbWMYhTKtGWyaFGgWLL2fNJKOm0lY0CYaviwkYk8=;
	b=BtIQ9oLPkSMCQUMn2Rasyp+Elzoia/7ILPsjLO1XJKaUm+6TgsLElJHY3ksH6oeHLaRyRE
	40OoGh3gXemrXGLDcWoUkUClds/zvFj4RwP61a369RkGSZ0MnkwHg6NYdLMuG8cPuPpyhJ
	O7OgKca5BYNaNXz80WZWMXUzYoIkHMgewEbyL8mCjRc80nKAmqwAksqPIRF3o1vYAFo4GE
	hkrQ06TorJCyuj2nK60EJIfWsV8/+kDDwNrrBhPgI1K9EEgm+LgcfKXWdXlhKxsNCkqg9E
	+D+r9v7m0PhxmybYIYH7gxgadJq5SCzAGExKp6gxNmPyypmdqeoViTL9m5eynw==
From: Israel Batista <linux@israelbatista.dev.br>
To: david@redhat.com,
	lorenzo.stoakes@oracle.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: osandov@osandov.com,
	linux-debuggers@vger.kernel.org
Subject: [PATCH v2 3/3] mm: change type of parameter for memory_notify
Message-ID: <20251029195617.2210700-4-linux@israelbatista.dev.br>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251029195617.2210700-1-linux@israelbatista.dev.br>
References: <20251029195617.2210700-1-linux@israelbatista.dev.br>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Date: Wed, 29 Oct 2025 19:56:32 +0000 (UTC)
X-CM-Analysis: v=2.4 cv=Lflu6Sfi c=1 sm=1 tr=0 ts=69027171 a=WIeu/gG1zxr2CnNbFFeIHA==:617 a=xqWC_Br6kY4A:10 a=3FHmPtoGU__ThbcyW-YA:9 a=TWtOS45hTxhqQf3p7L_t:22
X-CM-Envelope: MS4xfOr2t4fMGbO1cIbv2cvqJNLlyQEhTM+BFZcrKeoDHbHRbE+TTAeQFMMS+2KXyLL80hLnV+W5WR0jPz9UJKmC84B2p8uRTCytNPyHKLxSJLaNhlyesGo+ Fx6pnnWk9I7DRuEPBa1zAwLpFIlTsA9y+yh83SQT9egmbM7TuqCsU4GkataESsjIubNi7zhgbFBegwAKt8CMmsH8qxXozWyCXgsfZ6Uxe7r0BluX/Dl8TFWi FiXLxHf0cFAlvoe2SUHNGvFhb+bxDsPuml8AcQkdzX1qbMdS2l6olnw78E21xH3SxmWfj9K4St9ZDwBFPDdtbjbTbf+2xRiuE43ES5lmiMS+tQujkxRnNfcR huaWFY2RQSXjpUR5Mr1K9aIoKAxs7RkEuoIr1rqg6JOK7nRkrJbLvgY2NeGBwEedRfj6LMCwdWxSKiV4U5YQMJM3k8n6fNU1pGO62MdtvybT/rofLp0=
X-AuthUser: contato@israelbatista.dev.br
X-Rspam-User: 
X-Rspamd-Queue-Id: 70E761A0007
X-Rspamd-Server: rspam03
X-Stat-Signature: i1pznk8yp17jn74iwupu15ci98c4nmmj
X-HE-Tag: 1761767800-878258
X-HE-Meta: U2FsdGVkX1/C4F0dxPZy6Kd+iRAn4RTE5f9gpj8roayQUHFg2osQThHxe+USkH3ZmbqX/h0e1ag2SsJlFvNbIqwXXDK0yijYMViq5D4bcal5EuTYjU4AgvV8zvV7rZIZCu5VGmAyGDobqMjwIcRI7isJAkSVOVuP5kLp0kKPaUsxjp/wsrvWyKtuvp88Uyl+xbAHW30WjCM/Rg1xfptejXLfYwQVm4C89l/kshnFPfoGbdzdDpzxS81XxiT7NcW7HavxjXoHZBqp9YOQSZONGMB/Gn7rHVi0Bomf/LjgqqkUZ7jnslNro9reCIbgdgM4hXKrNy/dnxi9sr5DAMyCmkrAvQS0veSId9yJrgONhm6MD9fwbdPyghAQWkL+z3KgnU6y9lhM6XEFTWRLZEidpUECWS73GSoMtB7Qbf1xgH/fgUdSwju8QFR9DWAQ98BdJSUMnhAdPwr4jMIZpDmc/X320I0hNb9B/YO//4JAPspuO6Plb3wuIs7trgRI9dclphsCuHEl+XknMDeU7jsdYT1CsHYmU5x+bGKdtFrOJ7y32UUCsscnwXmSMyo134V6dmzr/PJgZVmL7emA1N1WQOXiEcemVc/DaFkp40bQCpmE8U2xzRkG6+3xVSNCqnpZyfQIaWf9e6NCwcGODx8BUwF1s3JtRn9G84DgJ0PMbLavyG4gC7/+ztKtLtCjER6mKhS8Zmwd+aDeq8t4o0ufjP+a4+eRcKq676D4eA45ttz6dkEPEahTUOOcMxRLiUGLW5y2st8v/phczKO0TexqhXu0F7eDH6MNiK9xZthDluXJ7rdwgxD6IWS7TPBXCtNU5FgLv0WcgbuuQAglf9WszU8dumwzS9/gqBKRSpAmgnGs9Tr2TOSLozhTD1nNZ3VFtNOqQ9/fmpazq0ihoxPq1Ut+TQ6t4VdtqSUMxigacHtL3mdQkjr3JIC1XCYK2iln9E/Q2jc714ziZfY9N0i
 msIWHq6S
 Kepmyl8kSkpdzXONFk2Mcukthx3s6nKDgQ8eoSsu8hFatG5dbqyn6kl+YBSsxmcDOxrD6ZMCVtMCaa1hsNj+gbFFZxexH19rZJ7XfdKE6UWg9H0ao/0XPHhQc45/dnIIszs4LR4P+DKiC5tmTXZ6qATE9VImLJSYlgPDjdEqv2b4JJKDkrqtEi3Nfb5lNNHaiJ/IpoBTZORI/qr3aiSo85Pc6NJzYfT7OYAuc1Yr2YbOKTvNvU4h28nBneqMxiivkyBJ0vsp04MjeukLauOwoHOcfFkfp7FGfwVP6cCitF5L7NqUEzn0cHlmsuCjWuLMSxs1dPWBb4gGY+xKrDytStLggD4PIx5dkyTslybykZYeu5lmwQcnfBAHwlXzO1qnq61Zd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000061, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The memory_notify function is responsible for sending events related to
memory hotplugging to a notification queue. Since all the events must
match one of the values from the enum memory_block_state, it is
appropriate to change the function parameter type to make this
condition explicit at compile time.

Signed-off-by: Israel Batista <linux@israelbatista.dev.br>
---
 drivers/base/memory.c  | 4 ++--
 include/linux/memory.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 3d17dd774947..c03f3b5e5e6f 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -204,9 +204,9 @@ static ssize_t state_show(struct device *dev, struct device_attribute *attr,
 	return sysfs_emit(buf, "%s\n", output);
 }
 
-int memory_notify(unsigned long val, void *v)
+int memory_notify(enum memory_block_state state, void *v)
 {
-	return blocking_notifier_call_chain(&memory_chain, val, v);
+	return blocking_notifier_call_chain(&memory_chain, state, v);
 }
 
 #if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_MEMORY_HOTPLUG)
diff --git a/include/linux/memory.h b/include/linux/memory.h
index 36d733283329..6a2456686bf4 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -141,7 +141,7 @@ static inline int register_memory_notifier(struct notifier_block *nb)
 static inline void unregister_memory_notifier(struct notifier_block *nb)
 {
 }
-static inline int memory_notify(unsigned long val, void *v)
+static inline int memory_notify(enum memory_block_state state, void *v)
 {
 	return 0;
 }
@@ -165,7 +165,7 @@ int create_memory_block_devices(unsigned long start, unsigned long size,
 				struct memory_group *group);
 void remove_memory_block_devices(unsigned long start, unsigned long size);
 extern void memory_dev_init(void);
-extern int memory_notify(unsigned long val, void *v);
+extern int memory_notify(enum memory_block_state state, void *v);
 extern struct memory_block *find_memory_block(unsigned long section_nr);
 typedef int (*walk_memory_blocks_func_t)(struct memory_block *, void *);
 extern int walk_memory_blocks(unsigned long start, unsigned long size,
-- 
2.51.0


