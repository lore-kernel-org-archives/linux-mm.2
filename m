Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38CF4C61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 07:48:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E33646B009F; Sun, 30 Aug 2026 03:48:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE3DE6B00A0; Sun, 30 Aug 2026 03:48:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C857B6B00A1; Sun, 30 Aug 2026 03:48:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A18CE6B009F
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:48:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 254E516024C
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:48:19 +0000 (UTC)
X-FDA: 85157157918.23.2AF4044
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8A26540002
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:48:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zuz9PyXX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788076097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZDX3fFvUV30DfDlbIstSg54b9CSxecAVNcamfzhjDpc=;
	b=vpB+61FKhAKOgUvNjaB+ZdoUy4HVLx/JFlzjxBP4n+9RCcpipSWx7220dodlLq9jgE4IrP
	km5z1+IhRfiCR7Fio+BbOh1sltP6DnEYPO2yB807M8zO2u9Ob+Cy8H2/1+zLz+PMKWyiO7
	6V2K1z+pibL/EKlgs5ZFNBHe2QcMpkA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zuz9PyXX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788076097;
	b=JntrgFyUDx4DWZoliQZK+wlJjBLlQJHwtd/HswegiEGJAoZ3kF5U4Eut0cYPZe2s7Ql2eM
	5yRJK8L7xWt3N1vEUPTJBpeGnsgVA+cr9tQTkOxDmTu2G3WUiZ546+L6Qs6GehqCSwRWzH
	3hNV1UN5EMXQKPHpP9BKvaQR3b+Bc6E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 27A21600CB;
	Sun, 30 Aug 2026 07:48:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB531F00ACA;
	Sun, 30 Aug 2026 07:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788076096;
	bh=ZDX3fFvUV30DfDlbIstSg54b9CSxecAVNcamfzhjDpc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Zuz9PyXXns1bfaGYR4gnsnrxBWaqJ2cC2WXfTQgmLJc4cO8fXpb7QJjDQGAxLBweW
	 njwG435meYvdRMmFjpASihIDRb48QGdry5/qkaq2Bpim1xqKDzu8ooUUuChsnpepSP
	 vwwc+zKhQKjIpM6/A6egaO7hrri8bIIpI25tyjU+LNBYikCYM/LcMQ8l5NyZLdhcU9
	 vdGjSE/yZUQxVqKSKjyWrw7g1+SUglzOKT/WSg7/xZtlZTiuOvVQhG77nEky66RL01
	 NO0eHmrDCvn816QISofFodN4Czd051W+EhaiJHQdBF7SgUCHsDXasr9K2WYziDqI5+
	 JsK2PWt2PH0Tw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 30 Aug 2026 10:48:00 +0300
Subject: [PATCH 3/4] misc: ibmvmc: replace get_zeroed_page() with kzalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-char-misc-v1-3-05e2ce44f291@kernel.org>
References: <20260830-char-misc-v1-0-05e2ce44f291@kernel.org>
In-Reply-To: <20260830-char-misc-v1-0-05e2ce44f291@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>, Brad Warrum <bwarrum@linux.ibm.com>, 
 Eli Billauer <eli.billauer@gmail.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Michal Simek <michal.simek@amd.com>, Ritu Agarwal <rituagar@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 4jp4rnfjk4akog7fgcs6s5hm8yxecsxa
X-Rspamd-Queue-Id: 8A26540002
X-HE-Tag: 1788076097-725867
X-HE-Meta: U2FsdGVkX18z9RbKWF0yLgkjxnHdiu5UgrhWZwORJ3ec5WmV7OIOJ164VdhXeRjcpJq7QNi45DfnA804yv9QEbsbKksR5Ze2yGB/fyz/QYuop0O9YdH5g5G5SiZ3s2cRApa9f6t/OvXAh34J76AqhlYW12vjiRZqaFEpQcozsMmLPXPK48JklzoH5juUsDq+q7uYe48JFFLN08uBILH0r8vB5DAYIrxwphvn4GX4yifa36b9Rej2rpXOx0ikCBUF3fW5hSkv+Z8dhH2YxUYcahqb6CKOO8VT+w4uxBcMJulbsG8H1G6VzKOz04GHWKsLSjERdQ9rBoe9eCNcWL7kmFIGHYyb+zJWNgqX99ePdKhaphnY/7yuHMNrZxsyP5zmiX+UtgixI225GjmSBPAVF1gbqLoGynr5nTcTDA9IEXtqBVRYtMaNCBKKUHR0KbDsbPehmV8f/a1nBE7wAxQsKeIGI7CDCwrdqRZLsgB4LwQYydKeyVUos8JutPlWpzmlE01kb7+lzgKEGwK7COduyo/IiHkI1F0FSDKbCpGwvGVt1vH9YwleUGP4uPC+5RAmk0Lr8Iy9tWxWs1IWvoZqwQhkjw60yhsEA4WbCNfIiTkS0arpP1eo5lObTUEV0FzGdZDB4it6IYxVbllMNg7xqPFJOavqw6/qU6EIEJjOO475EsRTFCk5vt1V38yix3ky91hgjhjcaXKzyHwYHZDa2RyDEn2Tm99DCvkktcwq8vJfFBwO9FtYx/IJNeAgyrKjsQ6EfxhIY25Sw2mV/u3mmfGn5PFVjrNHk/GlxrluPS8BhXipy6k4HOhcrdGl5bSbaKKzoQsoEf8Boczz93uOUOpMhxzpL8kruHtzJouJlzpm0FNsxJmOjpl9eOsrxpN3NuZyeduPxUNKeq+z9DvkW7KFUNREkxU91/9bFORcyaDi9q7PaTvO+ZDa0khScCdrKS4MF71WceqZCOWu63+
 EnZym/S/
 yXAdTJhjR983RUvgTdsgEspp+LeSchVv1VTWEjiHD37pK0JG9DdU3coJ+GjfixIOPp1rS7OxQAEzJmiWhxrQzdOhc3tYBlYRgTmzKcqgUPuAaObjeqUFvnyFF3xQ2Y9p+cH7SEweCvhYh6fOkHdS9e6o2DyEFiIMyM1j7LAtodSmGMz5v+NLbxorukUp+tngpgQZGvvFZrPAy7jIBVhE5yXdyqaXZNE83EbjvL6sjmd8b3gbgBI49MN0pglCBirehSRghtNGxIdnTPiCeo5qxDlbOoJpuyZ/zqI/0/6MN0tTDPXrU/hMc6Ue71GJCCLUZHw8keoK3z5Hq271xN5+gD6llqqgEKWTiqSnLtfeXZMkN2mT0oLqqR3dx1UX43FCzM68Ti4b9XInSe3E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ibmvmc_init_crq_queue() allocates the CRQ message queue that is shared
with the hypervisor. The queue is mapped for DMA and registered with the
hypervisor by its DMA address.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of get_zeroed_page() with kzalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/misc/ibmvmc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/ibmvmc.c b/drivers/misc/ibmvmc.c
index da82b1edb7c9..7d503ebd9f3c 100644
--- a/drivers/misc/ibmvmc.c
+++ b/drivers/misc/ibmvmc.c
@@ -154,7 +154,7 @@ static void ibmvmc_release_crq_queue(struct crq_server_adapter *adapter)
 	dma_unmap_single(adapter->dev,
 			 queue->msg_token,
 			 queue->size * sizeof(*queue->msgs), DMA_BIDIRECTIONAL);
-	free_page((unsigned long)queue->msgs);
+	kfree(queue->msgs);
 }
 
 /**
@@ -2130,7 +2130,7 @@ static int ibmvmc_init_crq_queue(struct crq_server_adapter *adapter)
 	int rc = 0;
 	int retrc = 0;
 
-	queue->msgs = (struct ibmvmc_crq_msg *)get_zeroed_page(GFP_KERNEL);
+	queue->msgs = kzalloc(PAGE_SIZE, GFP_KERNEL);
 
 	if (!queue->msgs)
 		goto malloc_failed;
@@ -2192,7 +2192,7 @@ static int ibmvmc_init_crq_queue(struct crq_server_adapter *adapter)
 			 queue->msg_token,
 			 queue->size * sizeof(*queue->msgs), DMA_BIDIRECTIONAL);
 map_failed:
-	free_page((unsigned long)queue->msgs);
+	kfree(queue->msgs);
 malloc_failed:
 	return -ENOMEM;
 }

-- 
2.53.0


