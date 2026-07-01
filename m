Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C5B7C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 12:34:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45B1F6B00A9; Wed,  1 Jul 2026 08:34:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 434EA6B00AD; Wed,  1 Jul 2026 08:34:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 322436B00AE; Wed,  1 Jul 2026 08:34:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 00BCA6B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:34:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 821801681A5
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:34:42 +0000 (UTC)
X-FDA: 84940151604.30.2242AD0
Received: from mx-2023-1.gwdg.de (mx-2023-1.gwdg.de [134.76.10.21])
	by imf09.hostedemail.com (Postfix) with ESMTP id 424CE140007
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:34:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=cispa.de header.s=2023-rsa header.b=ZhbIw9fq;
	spf=pass (imf09.hostedemail.com: domain of lukas.gerlach@cispa.de designates 134.76.10.21 as permitted sender) smtp.mailfrom=lukas.gerlach@cispa.de;
	dmarc=pass (policy=none) header.from=cispa.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782909280;
	b=1CI8cKZfAq4csT1ipaRu9MyfaUMnXXLFYN8ltWUu+HvsmYWPPFz7yzJsCzprLvDk6kTMYq
	rcFcJn7wZicrGTUt379rJu6USZkWcE1gA5qBxv4ZDLBdET8+P3p1I71gTuwHcxCsj+mG9B
	pQzBmnGApVkiiNdPwdGFwjC4bRBZYfk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782909280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=igSAA+qbMyAUJ/ctuYxX5vMbJh38ICoyVxEkz3kxQlY=;
	b=0T+dMPAJK+FC23PkuXLUn23GsflY0Dj4cwpmnmW6xuDeOfqa5VnBIg37RKrn2V3IKdQSWz
	TPjO5JLzMBbrLvZMV54VPdiTYZ02MDvO4izI7Y40uT7LqNOH8paXJnuTlRGfqiVLeUwkx4
	4UBVgoKBuPXjv1s7Mt7eamxXPiZH2m8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=cispa.de header.s=2023-rsa header.b=ZhbIw9fq;
	spf=pass (imf09.hostedemail.com: domain of lukas.gerlach@cispa.de designates 134.76.10.21 as permitted sender) smtp.mailfrom=lukas.gerlach@cispa.de;
	dmarc=pass (policy=none) header.from=cispa.de
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cispa.de;
	s=2023-rsa; h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:CC:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=igSAA+qbMyAUJ/ctuYxX5vMbJh38ICoyVxEkz3kxQlY=; b=ZhbIw9fqquLvP+NzDA2txtXZ8+
	WImhoVahtRvkNl83N1vvPN7gfIsZtm1VHNI87ooxtvhKVdig9marOfxvLCjjCFSenNpXc1lHYKEXl
	C/P21mvQFxB1nigyI0O0+HsfPR/ZFZDHamKY6DAm9B1cEyWMqgNPsJYJBVuhtBfLOsBmPrgvQqzH4
	FZQvsA6Qb2tmtzDhDklGgCJGqkkE0bU66O29EaMenvbONl5kOsRtpAc65zansqIaMUv7uKq9DEIzJ
	+9JqTP4CkAWWlvkUnhTnUWgVORWdV7IvOlmwemw5hQ0O2wPcv1i1Fhx3HpYoPepzz96TF4F0Fw/fx
	o4m4vdLg==;
Received: from mailer.gwdg.de ([134.76.10.26]:52023)
	by mailer.gwdg.de with esmtp (GWDG Mailer)
	(envelope-from <lukas.gerlach@cispa.de>)
	id 1weu9E-004V6p-1q;
	Wed, 01 Jul 2026 14:34:36 +0200
Received: from mbx19-sub-05.um.gwdg.de ([10.108.142.70] helo=email.gwdg.de)
	by mailer.gwdg.de with esmtps (TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
	(GWDG Mailer)
	(envelope-from <lukas.gerlach@cispa.de>)
	id 1weu9E-0001cN-1g;
	Wed, 01 Jul 2026 14:34:36 +0200
Received: from Mac (10.250.9.200) by MBX19-SUB-05.um.gwdg.de (10.108.142.70)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.43; Wed, 1 Jul
 2026 14:34:35 +0200
From: Lukas Gerlach <lukas.gerlach@cispa.de>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <corbet@lwn.net>,
	<linux-mm@kvack.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <xu.xin16@zte.com.cn>, <chengming.zhou@linux.dev>,
	<skhan@linuxfoundation.org>, Lukas Gerlach <lukas.gerlach@cispa.de>, Jo Van
 Bulck <jo.vanbulck@cs.kuleuven.be>, Tristan Hornetz
	<tristan.hornetz@cispa.de>, Michael Schwarz <michael.schwarz@cispa.de>,
	Shukai Ni <shukai.ni@kuleuven.be>
Subject: [PATCH] mm/ksm: document side-channel security considerations
Date: Wed, 1 Jul 2026 14:34:30 +0200
Message-ID: <20260701123430.20699-1-lukas.gerlach@cispa.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <f75d286c-4d9e-4b64-8a9e-03e1afcb509f@kernel.org>
References: <f75d286c-4d9e-4b64-8a9e-03e1afcb509f@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.250.9.200]
X-ClientProxiedBy: MBX19-GWD-07.um.gwdg.de (10.108.142.60) To
 MBX19-SUB-05.um.gwdg.de (10.108.142.70)
X-Virus-Scanned: (clean) by clamav
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 424CE140007
X-Stat-Signature: aa7cedyke73swzx711wps9rkns94k1q4
X-HE-Tag: 1782909280-788016
X-HE-Meta: U2FsdGVkX19iEwL4qIQxWu4OUrbgjToXGje0nQTlTU+J3980xT1wsDF7WABpY/XzlGRSwNW/7ctFHo8DpExGLjktiHvyVi1W2qZyFexKEPn7yNu2bGI6vm/F2opMjoLIbLOMip46OzfDkJJqyCC5WtdOimfv+ZhQZLHEjh6MNE3cFKhhYyv1LTnOUgnBWeBxqBxMLvsXlA7pxNdtVeIZ/fAuYEj3cmqF5Oqf2Wz7+WlWlIcoksS9KvYJop9VbvJ2ZmdVYfuX/mY0VnoFSONJxrqNhJHHHlyYuZ5lT2Fh0D6StKsgVgrO3jrDXjTS/C+xxwdkmVs4LmglfHlwVv+HZqHFJkfDjeqeGxBIiUfdEZa1YsmDmX1652S/zpIQSZxCumSosBsmG9dgPO9HxEd3vyVZrE1LskgqtLXWWkGtah0NMi742XCsA8UTHXAmXMWJJAUuFd5xKphb/ialHYy9zT35ytc5UZZrNjC5sfdrhM2Xhq0rvjnGVctMNlu/b5NDx3ePmO6VZVZUFL24UYEJhc5b7OZ9vFdh3MfMJSQ7IjQV6AwhKyCc5m6nIC2h3FawdC3bjTV5UwQ3cZvdI+du6NyYhIu8clAlQmIhx0IzQQ5JSadADe5rnYvGbYMx02MJf4CMvOw2/rXk9xWNujlConz93uXkItHSbwsfd0+G6RyPcgd+Ym6hxsFad0l+iwQWvvz1US8Y+V9yCjM5joxHeu8Chey1cU+a7mlj02grNSzNdqtagTGLoh5Ual7TXaqdxKFHLN/CNgWQLd5LGMVnWvlcSms0hAZHlP1eCFbQE26aPSNmfSxGCsjLIMUYMZ7DqJoArblf6MKnJx4iLibdf9F+3AV7zZekWROpNG1BxzXMgCJHLVQL3gt9T9gx2sxHpkfeg583H7hNLhMwAvjDTH6l8p+AlFBYYczqHdKs3jBFSJIQIhLOcdHIDl2hWyzBSZjhY2lBslfn85tHH4z
 SL5Zaw4p
 jvNFWj3qI40l0hue9u8p5fpjS5hkKlZFc2zJ6MfG6p54M5DEKhPA12/aXH4P/uurQdB0k4Rv/76XB4MRbb6gMHWzC7pCQuwix3FIUNL6/8LSRpf7j3c7bklOxIp2uyazE8Zkv8xSZFYIcqam3ZvPN3vxxGZvkkoIL/dvME4f7vmnTesVnvaZU3rDgtD5EhBxz6Zs3Dz8o1aGUWbXaHxQ3Lr7J2VyxHF+iZ7dNRRYqpLSNUgYzI9ax804hOW42uTeVkYbR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KSM is known to enable side channels, but the admin guide does not
currently spell out the security implications of enabling page merging.
Because KSM merges pages by content across all processes with mergeable
memory, it forms a side channel that can be used to infer the contents
of that memory across security domains, regardless of the user,
container, or virtual machine the pages belong to.

Add a "Security considerations" section making this explicit, so that
operators can make an informed decision: KSM should only be enabled for
mutually trusting workloads, and any memory marked mergeable should be
assumed readable by every other process using KSM.

Co-developed-by: Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
Signed-off-by: Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
Signed-off-by: Lukas Gerlach <lukas.gerlach@cispa.de>
Cc: Tristan Hornetz <tristan.hornetz@cispa.de>
Cc: Michael Schwarz <michael.schwarz@cispa.de>
Cc: Shukai Ni <shukai.ni@kuleuven.be>
---
Hi David,

Thanks for the quick response.

I generally agree. The issue I see is that the current documentation
understates the risk. The RHEL documentation ("could be potentially
used to leak information across guests") does not read like enabling
KSM is an arbitrary read across VMs, which the side channel we
disclosed (in contrast to previous works) is. So the documentation
should really state that KSM is only an option for mutually trusted
workloads. A clean model for this would be to assume that memory
marked as mergeable is readable by everyone else using KSM.

Patch below to clarify this in the admin guide. We would, in the
future, publish a paper on this to further raise awareness of the
risks involved with KSM.

Greetings,
Lukas

 Documentation/admin-guide/mm/ksm.rst | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/admin-guide/mm/ksm.rst b/Documentation/admin-guide/mm/ksm.rst
index ad8e7a41f3b5..cbd5f2fdcfcb 100644
--- a/Documentation/admin-guide/mm/ksm.rst
+++ b/Documentation/admin-guide/mm/ksm.rst
@@ -27,6 +27,23 @@ KSM's merged pages were originally locked into kernel memory, but can now
 be swapped out just like other user pages (but sharing is broken when they
 are swapped back in: ksmd must rediscover their identity and merge again).

+Security considerations
+=======================
+
+Because KSM merges pages based on their content, across all processes
+with mergeable memory regardless of which user, container, or virtual
+machine they belong to, it exposes a side channel that can be used to
+infer the contents of mergeable memory across security domains.  Users
+should assume that any memory marked mergeable is readable by every
+other process using KSM.
+
+KSM should therefore only be enabled for mutually trusted workloads, or
+where the merged data is not sensitive; in particular, merging pages
+across mutually untrusted virtual machines or tenants is not secure.
+KSM is disabled by default (``run`` is 0).  Applications and VMMs that
+use ``MADV_MERGEABLE`` should limit it to regions that do not hold
+secrets.
+
 Controlling KSM with madvise
 ============================

--
2.51.0

