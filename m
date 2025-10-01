Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E603CCCA474
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 09:04:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E7FC8E001C; Wed,  1 Oct 2025 05:04:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 576018E0002; Wed,  1 Oct 2025 05:04:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 438D98E001C; Wed,  1 Oct 2025 05:04:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 312038E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 05:04:26 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CEC3B16099B
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 09:04:25 +0000 (UTC)
X-FDA: 83948959290.30.FA64779
Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	by imf06.hostedemail.com (Postfix) with ESMTP id C3DB518000A
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 09:04:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=iJLHFNhD;
	spf=pass (imf06.hostedemail.com: domain of "prvs=3627e3e53=acsjakub@amazon.de" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=3627e3e53=acsjakub@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759309464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QqoQLhr9jNRrUPLIQa00/14EdjpK1aaOEozoKOWSRQI=;
	b=M9SNf2g8seSsLailwFq/uaA2LDiBf/bhuotPvcl8WK+7Uo0w86gT7KkJTJMBBMtl4e+Clr
	ZkBsUoV/+DDsotLoPj+t4xGG/f5oBQEIX7c73SxyUXmdxHwCNfVyta2B8NuWhG0StH9OKJ
	xpT0EC+AydH5eXJmaFYLGTO7hhwyuWI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759309464; a=rsa-sha256;
	cv=none;
	b=np9Dn2sSYpBMrT3AUonSqdEdyQ+a0HZjohMlXxx98PzqvY1iSKdSBOx0B8sq6PaIfIH0tQ
	rdqnK/s7hr7OHGiu0ZiIS1U8kqp8sytdtxTndiPywZ17rkjTFDNQ4/rVccxZ3hPX3S73W3
	rnsPmrw+50j55/DETQM9ley5Ck9WUOw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=iJLHFNhD;
	spf=pass (imf06.hostedemail.com: domain of "prvs=3627e3e53=acsjakub@amazon.de" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=3627e3e53=acsjakub@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1759309463; x=1790845463;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QqoQLhr9jNRrUPLIQa00/14EdjpK1aaOEozoKOWSRQI=;
  b=iJLHFNhDnLQuH1l+iya6e/0k6K0D5UGfxGBlRdsCcOLLY2JW33HD9Y4K
   CyKpbbcyaOZJ7NG41ednYVEKo3fvANWAFbFHPGsKaRWYDff2dUGXOY6Zd
   RGf6IQys6rs8XDXEpNq9hHHvRu8CpR4La56zg+qFqIq4vvr3t+nhcq5/V
   evVCNT8pyOUxaF8Bevh0V58DTouoprANSZi/jPnO+VBsQF36zzI0LmPK3
   OvFn0mdZNPelaElgT4Xa+pxG1mHV7FxJp4669y4ewJzJrPNquBRdXeLjQ
   WkJ6961wzKR8YnfMRYR75++YUH2jGRegqYvt30vM4Km3gXGg10LADJ2Yf
   Q==;
X-CSE-ConnectionGUID: sQ89hXaHSTWejetMyBy6tw==
X-CSE-MsgGUID: B0di+aZYRuaz6VBPjSRaFw==
X-IronPort-AV: E=Sophos;i="6.18,306,1751241600"; 
   d="scan'208";a="4058002"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 09:04:20 +0000
Received: from EX19MTAUWB001.ant.amazon.com [10.0.38.20:41709]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.31.86:2525] with esmtp (Farcaster)
 id fde31b50-4b6d-49ae-a02b-d77c58a4ea9c; Wed, 1 Oct 2025 09:04:20 +0000 (UTC)
X-Farcaster-Flow-ID: fde31b50-4b6d-49ae-a02b-d77c58a4ea9c
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 1 Oct 2025 09:04:20 +0000
Received: from dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com
 (172.19.75.107) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 1 Oct 2025
 09:04:18 +0000
From: Jakub Acs <acsjakub@amazon.de>
To: <linux-mm@kvack.org>
CC: <acsjakub@amazon.de>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<xu.xin16@zte.com.cn>, <chengming.zhou@linux.dev>, <peterx@redhat.com>,
	<axelrasmussen@google.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 0/2] mm, ksm: fix flag-dropping behavior
Date: Wed, 1 Oct 2025 09:03:51 +0000
Message-ID: <20251001090353.57523-1-acsjakub@amazon.de>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
X-Originating-IP: [172.19.75.107]
X-ClientProxiedBy: EX19D038UWC002.ant.amazon.com (10.13.139.238) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C3DB518000A
X-Stat-Signature: zhfixe71b83qfw19qxracccz3w1zg5nj
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759309463-41287
X-HE-Meta: U2FsdGVkX1/WR6d+9qPgEdQcCtlCk9yVAOOhB2Bfv5eL/eulYTPK/FHV9w+M1TY35aGQVp3GySmk1afJSyjQ9ebcldrBLeXnyFvX1pty0EhLDsK0fE9FHKAaDKEeWzG7xM4cO+OOfWAsZyVqnXyadJA/r3aHp3ESVWLa3hZgDwx32tuHYcFkAtNqCrWPU3Y2GHh+oBIzpRUTZsI98FJDVS5y7FKiIzxqAQWLXs6Ejgm9H4qK2YhlHfoWNUJheqqMVZW9CHgMw+OIWo4w7ISfvHwhqL7Pd3jPg+A+1YEzN4DDEvbehQ/ys5NKrZjx6a92++KL7ZA7CRz/LB0VRnFMYrkRrxQaY94N+nIROL0BzGhBhagJ/LFikXPotUeotmFFzCMq5jawPN+jtUT2J7Zq8+u/vbFKP3yzUvBcpHWXYUcAgBTGLR4sDmOv1pkFKjcGO7TiTH2Jcfdn23Yn4Si+Frycw+ajmv04BFGf2DXkYrgmoheh7hgYJIt6kqiN67JmKUxsp3wBnQTMJVBErzL3dXDQlCKrG9WiJUTxrlBYjq7o5Bs9+guCH6Tj2eY+wIc+gjHqTDEu5q40Yo6WaFJDLUJpJa7U8Vw8HyxjCx6dnXd5sgRR27jByvxJOrv0KGEMmhqD5rQ1lPXaLS6MDZSAkceZeXKRQzNc2rSW1jkJv6anZLXN39yybZbj0FrTBWeam5Q+rZ0s1a/b9m+CPfKiYKsuo5YqZQ5jA5S93+IoP7MdjZIlww91e0gYxipgDl5lgAP6pQpi6zYEji50n8FgWRMBY8SeUMP9mwCgEEq0vRWgjV3ExwhTq2inW+p98cr8l3GxkOJxPEcDNu7chOinhvrxRY+SdwZtoUWKZ1aFkdCTa0N15LmAbgEV9kFO+IYRO9Et5lP2irlKBevWR+t19fNlD60BUJFNLkCXoKcaX2x2Spg0tTmonTvV7m6IBw89gNmyUJrR8R4nDAxRkQe
 mZ7BkVJo
 v7orEg0KedybfUK2dMlSOvhU6WnXtrWkgRFel5yukahYFdOieKH+HLWmlGSUJR+QvyPLjknwLRe2YAMwsiaGCdI9EgJztU9XHedqbZbyfzfpCMMaMRE0L0u8ucwc4G2RxLcUSp+uYQb2RQBZE/UurJW27c1FbJC1BSgpLcOCOca23qXdc5XsNoF/8sG4P9XYBgNslVbGkNmgt0ERBzElNYegpH2gBoEGIpcPGazNqM+KxH7oBckD55jshz5j9OKMewCm0FKR+xIX0FPCrxIHW3gi2ARtJ+fk27Uf9h3Z5V/VIURzbbaxUaaYF3JtffCJOhCue79esow6cozJ9QHpE95NBltwBc1i6OGEMFdj1LUtSlLKQffD+nl+6Mz+Ph/71C0WV9xAEjeMIyi1D+YNzVMC1BZSNPKJldhR3xhixRjVOh/m12EJE+2XgZzTzu8Y82D79UOsYBVmoFGC2hsjvBBPOMfcekEz1rj0Af8eCSyOk3yOx3nodjJIMZJ2ivRjTueRf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

This series fixes a bug in ksm_madvise described in [1/2].
As asked by David in the reply to v2, I separated the change into two
commits:
- first contains minimal fix for the bug to make it
  individually-backportable
- second makes the VM_* flag definitions consistent

v1: https://lore.kernel.org/all/20250930063921.62354-1-acsjakub@amazon.de/
v2: https://lore.kernel.org/all/20250930130023.60106-1-acsjakub@amazon.de/

Jakub Acs (2):
  mm/ksm: fix flag-dropping behavior in ksm_madvise
  mm: redefine VM_* flag constants with BIT()

 include/linux/mm.h | 68 +++++++++++++++++++++++-----------------------
 1 file changed, 34 insertions(+), 34 deletions(-)

-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


