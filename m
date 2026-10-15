Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D938CC6B2F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 04:41:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F9D66B0098; Thu, 15 Oct 2026 00:41:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AA986B0099; Thu, 15 Oct 2026 00:41:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 398F66B009B; Thu, 15 Oct 2026 00:41:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 151886B0098
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 00:41:14 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 973E71A0724
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:41:13 +0000 (UTC)
X-FDA: 85323611226.04.515B033
Received: from mta0.migadu.com (out-112.mta0.migadu.com [91.218.175.112])
	by imf07.hostedemail.com (Postfix) with ESMTP id 87C5B40006
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:41:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BwTQQyZX;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.112 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792039271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5F7qXKPpT0jOO0pyoU6gPST7HO5hs/P5WbN4q383QP8=;
	b=px3Rvy6lWkR8YWE6xO5e5yEZINqsa1qA7jmsQCQeUopWgL6Z/K6z0yu6PLGyM1y2n4Aevi
	wQC69DGEOPCkBkjDjWIxcav/zLkv/FrSy8p9s6bw8+es0Qb/eTuDKN5JVFO7CzJ+5V54dp
	DiVGdBV7HYd9ZkFgEcQyirfLiMeaeKw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BwTQQyZX;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.112 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792039271;
	b=t77MGJ8Fr0B5Lf5xG4YTpH+M17y9NApQjWVmKXilWBKsjPv0XkIEyqnbpRAo9m5zWT9uYQ
	CVvpR47gw+xaw1FFErploRh/f8Py2Z3YFQ7sQejFOKKCQNhFI+XxYyB327tjeM2q6pE9Dw
	X5rqnwG9m9+RGdGYSGX6LZkeC93DXtk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=De6T00S6SFjuGflCzumt+OiPmeOo2NzkgabFnl2bQHU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792039270; v=1; x=1792644070;
 b=BwTQQyZXZ8RQp0gWPWl52UyG+lD9ACYJ/lJm8mKEuKlvqXhyYjUSVySjANZi8awPEWi8wcM5
 fG0alXIzusjaOFAFk0BRrIprmLRAvCvxVQfN+6ik9NWvYVjhkYuWYIb7xk6X68LMFZ0tV9Rxap2
 It3uel6dIOo80G71HO2rhkWA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 786eab450f251e7c;
	Thu, 15 Oct 2026 04:41:10 +0000
X-Mizu-Trace-ID: 786eab450f251e7c
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: kas@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	jannh@google.com
Subject: Re: [PATCH v5 4/9] mm/collapse: add collapse.h for the collapse interface
Date: Thu, 15 Oct 2026 12:41:03 +0800
Message-ID: <20261015044103.58141-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261014171145.3292736-5-kas@kernel.org>
References: <20261014171145.3292736-5-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 87C5B40006
X-Rspam-User: 
X-Stat-Signature: jzhy4p4ojjch1xj17w3kd7fbpmwc8dq6
X-HE-Tag: 1792039271-244210
X-HE-Meta: U2FsdGVkX1+KLX2HXQdgmHcsklh+P2mF7zZvLJctvARyHKYMOgaUuIWB7PBMVs448ogAoq4oKVpLqVyrmlJ2iTKr6zDAOvuYAQpl1K75N4+CUcGsCS3kwe/QD41INSrWk9BSBWmMFvGyvjjQ1dwrHe1atBTX6ZXQka6LOkrfz5mGeh1HOS54INsB+ZT679hSnNrZOtCnQoN5IZjz7uZuzDPTHb/BXD13ERblS09lKQkc1rtBwu3Cei7EMDJ8e5slWCFaZUntOidEt2srTpMF2WR3tyUHgtJuVc1Ae08FeeKeJ+LvB5Ekl9APwzhe+Vso8rDhHDdTtPKLIwbzMAuhjxwd2nE8vwcEE8usTBcAMynK1Z8bHmxUEhZl6/Sgy2NQAljHfVubEk0+ogc/z8qdHUhLisBKebFw0zY6ohXkSLysbEPDqTudlKuE/yb76EWvy1WoNC2Fnhn7d+ElfqAJDBCCIKbZnSRaWuCM5/UDC8B8xgYcw3GbjP7vAUo2OeOac87fHhzKI6+0sRz40xGXFAsxQNRlKvgEwPlkGCdZjzlyMueTTWYCa1MOTmKShpSX/8Bbt/0MFjadpe5YZ70wyWrHU6VWxcfiImC2i4bqfat4xZcgGh/qpRXLnySFSS1bHsYwjdBLaTazKHbKiVRQxm73lvMKPetfEAAOW98kICr9uBYJ2BXz947Z3i70CEa1K129nAgQdB8FLzv34vsDW8fdTOkZJJA/iSXFWAGt9DuvqdS9Pp54lR37deLyiwk4hcjxwPOLP1Oe35MQxmR8XaFoc2sZyjlO38A/7NfRxtAVnkGkMdodbcjepo/0IaMBQJT5q8X3FkgVuXpPRNr7iH5hDc8AXiEuFYxpexAU6AU0d7u2KQXSJ4N5sLJqWvm5js/fle8JGcWDXw+8cRMDoO2nyccxrsRwP9T1ydWrxvdPovH8jD5NxyZGZJo9TzvW7XEzzjDlLdrMV9SRTCg
 gKgU/v2y
 Kbh6wI0U015sXo90v8VOcWdZiRWBioMk8K1Zp9WsJhSt7SWpYtnXUMP5Up/JxLP/gYuxqmPZIHJlUHhzQZ668TnwmDeAJcXAJEbielT2B6AOP6XvpsQMsmfz3Itc93nBW5g89puPEmjxfv9L1cHku7kPXDMRERbBfAxwv5ire+XzQOdX9MPxaqesm2ZxUfMZF1N8+i9pLPhFLQc5q5GzTmY6RWL7yxuXPj+amMfod367flYVeVE0i9t9N+b+HLCXTfukxgQVAG+/terv4g1tU8J5RXtnfS0xLZp2J6MIh7jz4g4xpAc+sQCxBaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Oct 14, 2026 at 06:11:37PM +0100, Kiryl Shutsemau (Meta) wrote:
>khugepaged.c holds both the users of collapse and the machinery that
>performs it.  The daemon's scan loop, the sysfs tunables, MADV_COLLAPSE's
>entry point and the collapse itself all sit in one file and reach into
>each other freely.  Nothing marks where a user ends and the engine
>begins.
>
>Start drawing that line.
>
>Add mm/collapse.h for what the two sides have to agree on:
>
>  - enum scan_result - what the engine hands back;
>  - struct collapse_control - the state a request carries.
>
>And two constants move with them:
>
>  - KHUGEPAGED_MAX_PTES_LIMIT -> COLLAPSE_MAX_PTES_LIMIT;
>  - KHUGEPAGED_MIN_MTHP_ORDER -> COLLAPSE_MIN_MTHP_ORDER.
>
>Neither is a fact about the daemon, so both lose the KHUGEPAGED_ prefix.
>
>No functional change.
>
>Assisted-by: LLM
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>Reviewed-by: Zi Yan <ziy@nvidia.com>
>Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

