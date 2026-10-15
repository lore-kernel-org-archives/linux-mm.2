Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85AF0CC6B3A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 11:27:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A35666B0099; Thu, 15 Oct 2026 07:27:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E76D6B009B; Thu, 15 Oct 2026 07:27:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FA606B009D; Thu, 15 Oct 2026 07:27:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FF676B0099
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:27:27 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DE9A0140963
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:27:26 +0000 (UTC)
X-FDA: 85324634892.19.8F978E2
Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	by imf30.hostedemail.com (Postfix) with ESMTP id A2A6780006
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:27:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=UyEzZ14q;
	spf=pass (imf30.hostedemail.com: domain of "prvs=7417f4196=gyokhan@amazon.de" designates 35.83.148.184 as permitted sender) smtp.mailfrom="prvs=7417f4196=gyokhan@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792063644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=c5MSEChHFaHzH315sZEHyXYQRaA4uc8oyDI0uBMz9mE=;
	b=HlMspBrVb15oapfnlXJZVykznz+k5vTiUW5pLkIIYe90uUloyxr8RXe+9BDJIfnAkTRYbS
	6qYYZpm2+FG62neAjz1KPd5I2HEwfjs2vgcyxftFCXK9l8AEtRlJTOYkuyCtm3YuLUo8dO
	irq3AYWdBn50Kbg6m89frohpF8nrDi8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792063645;
	b=h4Bf1HyQJYr2iiBgVb+ye4uqn3RzO59HgjI5VEOK/GSrKBwgM8Y3zQa4ymi4iSb/vHG6Tl
	q3v/b0mmm1mfLluF3UaMPNawVZMO+18+U79ZgZvxCfoSdxo64okWpE28H9eA3prv6SWtTZ
	DChzmro981mn4jX8VN1IHxyyeIU5bj4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=UyEzZ14q;
	spf=pass (imf30.hostedemail.com: domain of "prvs=7417f4196=gyokhan@amazon.de" designates 35.83.148.184 as permitted sender) smtp.mailfrom="prvs=7417f4196=gyokhan@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1792063644; x=1823599644;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=c5MSEChHFaHzH315sZEHyXYQRaA4uc8oyDI0uBMz9mE=;
  b=UyEzZ14q+OGeJewnsSQwIB6t0cXtmNzOo6IJJFQeBY+H67lqBjkjaICi
   ZuHLspAimdSLZ2LtXqB/vZAOxJic4mXIdMwlI2QBYlXFwShf47Ae64DcE
   ZTPcXkQyJoAh00DVRI1toiTmbn4DbqyWX5v8eLYB/vx7/FHgYYuY5r5Fs
   Z2VY80RKKe9IX0uNlSb/Oas3fnM/neFv9oLDxMjMm/6DaUTZ/dnXFAaOZ
   Fs4cMtd5tNwQImyLD6D/m0YD+p3mllRYP1ZUYWba4q9tq2ungOOaxmpS5
   Rpc1KehZ+fCwMbGq52JG3ykD5mTPgbvSrQ9BR2SmgfUTLrl74UpeHg5En
   Q==;
X-CSE-ConnectionGUID: /CqkO7PGTDSwI0pbMZ0JVg==
X-CSE-MsgGUID: PrJRhyXRTlWUO7N3MLHdxg==
X-IronPort-AV: E=Sophos;i="6.27,159,1787011200"; 
   d="scan'208";a="31126226"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2026 11:27:20 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:25661]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.40.190:2525] with esmtp (Farcaster)
 id 334e4de1-04d9-46d7-b7b2-49929fc3d3bb; Thu, 15 Oct 2026 11:27:20 +0000 (UTC)
X-Farcaster-Flow-ID: 334e4de1-04d9-46d7-b7b2-49929fc3d3bb
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Thu, 15 Oct 2026 11:27:20 +0000
Received: from dev-dsk-gyokhan-1a-87ab81cc.eu-west-1.amazon.com
 (10.253.85.128) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.53; Thu, 15 Oct 2026
 11:27:17 +0000
From: Gyokhan Kochmarla <gyokhan@amazon.de>
To: <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>
CC: Matthew Wilcox <willy@infradead.org>, Andrew Morton
	<akpm@linux-foundation.org>, Ira Weiny <ira.weiny@intel.com>, Helge Deller
	<deller@gmx.de>, Thomas Gleixner <tglx@linutronix.de>, Sasha Levin
	<sashal@kernel.org>, <linux-mm@kvack.org>, <linux-parisc@vger.kernel.org>,
	"Fabio M. De Francesco" <fmdefrancesco@gmail.com>, Al Viro
	<viro@zeniv.linux.org.uk>, Alexander Potapenko <glider@google.com>, "Andrey
 Konovalov" <andreyknvl@gmail.com>, Bagas Sanjaya <bagasdotme@gmail.com>,
	"David Sterba" <dsterba@suse.com>, Kees Cook <keescook@chromium.org>,
	"Sebastian Andrzej Siewior" <bigeasy@linutronix.de>, Tony Luck
	<tony.luck@intel.com>, Gyokhan Kochmarla <gyokhan@amazon.de>
Subject: [PATCH 5.10] highmem: round down the address passed to kunmap_flush_on_unmap()
Date: Thu, 15 Oct 2026 11:27:01 +0000
Message-ID: <20261015112701.650511-1-gyokhan@amazon.de>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.253.85.128]
X-ClientProxiedBy: EX19D031UWA001.ant.amazon.com (10.13.139.88) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A2A6780006
X-Stat-Signature: 76yi7e1w33azd5ixqa8hx667qu1bt9m7
X-HE-Tag: 1792063644-781121
X-HE-Meta: U2FsdGVkX18ERN9E1e13elIO45TmZx5aVkblC5GR26PyRfCVH/dH6PL+Ohyqp9UCsrLn62oGsqcFt67ZWmXr7rcL1S29bItzJPMemBbkpAQCWIWiQc0e0Fx4/zyfpeY1Uh7qaah7zuHcpJ0Oh/iAmj7UN2qiaxsyZhuiRjU5W5Drwq8eza7QJPogvom3fiRTJCPmYgq7/X57E2n4PNlcMtFup1foBDdpvJaiq43MBd89LQ9ONYXJ+wOlr8q4g6eAVy5P+Kqt+3IOTU8uQReheS4zeWlev9Jm1T6lgn+JDbwu0VGLPH04bizDs20gHFTpeueFtx+h7xdxZP49UR4LMhIp7ursoKEQdEfOwAgfJhDrWkzfGT+gtto62deEKwBracrwUYOi9J4iGNXckcwtGxneirce4+z4HKNtCfM750N3j3I7fo9I97/Gm05wmZcwL451ZeqIKOK6uapNQ7KSKzJxwVdj6Llxlh1a72gNh0ZarAvkqKmOPieQLaytXduhuPvb4YqlCfhtsXs+6UKZp5NS8yd9OO6Ez6f5hvaedw3tMHIjkxXn2d6WbBTd9dgfNRMVdDJ6AckIUtY+Qv03HOd0MPW7awKO5j+fM0kswqZiShuedVFZ0ayaVaN7lXrpH2QTjKEDBYbxQJ47PpugD3QMhJjDsHMoMomBSad5r7QF4uNi1YnVXAJiFxgAVW+XjVGZu9V7JCc9QaORuPrgQE6Ybs0ndxay4QHEVvTAGn6+5YtVC7l3A2boWM2kr3p1jWngqnPioIFIQ6Ujua5+E7IIaotChJgcXA3FXS6seoQ/ASMR6InqJYddyEKgFO2Dcs7O0X/PparEzTJ/+TGT+ylzyqzQh2gSYv9wTnYGBTm2sYWi5opmoVW1EPeNt2BW0oSTkjR41DyUBTPTT5x9fwyAnAPJ5i6OX5yeGRIDkjZPHM0Au8OrtbmX0OE3a5knAL0qaE06zjxSRU9OJR9
 E3vUwOkc
 1lUpYTt4yxfimrT3awTAORCjUsnOYVsOrAfyUQ/BigedPm0qXXOvQ3XbOs70yVjd+mrgWQX53IKivUWqpkMrqF24sUdre0m1xPLa6ObFJGePq5pxiKo/0KmUMA2XeLEOPyIiuqNI2pTUl140XzO4jm4fY4YlER/AvrqVp6TqMX7NSne83PjuzTdRsOqrZHhEmHZ6pGklNxEY5vmFs2M6BXBeQVne+hWecNz0l2GlTBxiTv2tlH5S+u+uQnz9DNxfLPee4BZ+e6/1FYmuLMIajxZCNt53Xkj4r8I4qJ+OKo0k8TzDbWcn8XOg6ZENCl6SwYntgb9jZB+SP99PcgvXoI3rMovK8jHzwF4S7EkKlg5tR6hqwJB0g3lHJfEoS8wYr6JgPKYycWQ7bi9KksuXpeRFXb/2Fv3cvn+YJOO3hJsPMa0tx0Bebnf5up74E7QTwDdw7zlKOE2Sk9csnBMQ0NZxqC+Wb4CUJTX3oSUWJvQig9whdJpCkgZGSSJRH0zZgDazxYPUCGV+jKvW0utEezmYYKoEw9Gr7EUCNTH+f1eBDulZ21/m3gkfw4oqZw1RYLbQYqQ/FdgXDQuuVAFJUxhJXUNptZQ+UOCF/2iHt6V7Aahwmc0SOFMH68pEjiMYW9mva3yaNbJbLK/HyOwngB0SYqNnetEchPdNzoocI81WLvX/Ppy+e86myDkjP6TA2AHSJ1GZEHud7zail/NQdhOPMDp4VmgVEJnmqp0kUkmtGY8R0/F6H9e7XZ01tsNtqON14w7g+YoyQwjzeHLUHkzha3C4pVIB9gCVEX1yxTARNDcsWud8i88JDMuXrbjdroxl3Y+8BsmbUvZbzVAepmzDUM0I92Hlh2CIVXHoFJW5mWXKng6jpywzrbpL0HGsgxBGqM9vrNkELsD+DjaHteAWjv8ukrJP6ya7njEcdZhEJgkBiz5eCxwaF5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

commit 88d7b12068b95731c280af8ce88e8ee9561f96de upstream.

We already round down the address in kunmap_local_indexed() which is the
other implementation of __kunmap_local().  The only implementation of
kunmap_flush_on_unmap() is PA-RISC which is expecting a page-aligned
address.  This may be causing PA-RISC to be flushing the wrong addresses
currently.

Link: https://lkml.kernel.org/r/20230126200727.1680362-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Fixes: 298fa1ad5571 ("highmem: Provide generic variant of kmap_atomic*")
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Cc: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Helge Deller <deller@gmx.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ 5.10 has no include/linux/highmem-internal.h and no
  kmap_local API, so __kunmap_local() does not exist. Therefore,
  I applied the __kunmap_atomic() hunk to include/linux/highmem.h ]
Signed-off-by: Gyokhan Kochmarla <gyokhan@amazon.de>
---

298fa1ad5571 ("highmem: Provide generic variant of kmap_atomic*") came
into 5.10.y in 5.10.270 (c1824fac30fa) as a Stable-dep-of 68d4d3e78150
("isofs: fix out-of-bounds page array access on empty zisofs block"),
but its follow-up 88d7b12068b9 did not. 5.15.y and 6.1.y already have
it (5.15.93 and 6.1.11).

 include/linux/highmem.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 5f7cd58db478..a2a252a93d76 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -218,7 +218,7 @@ static inline void __kunmap_atomic(void *addr)
 	 * handles re-enabling faults and preemption
 	 */
 #ifdef ARCH_HAS_FLUSH_ON_KUNMAP
-	kunmap_flush_on_unmap(addr);
+	kunmap_flush_on_unmap(PTR_ALIGN_DOWN(addr, PAGE_SIZE));
 #endif
 }
 
-- 
2.50.1


