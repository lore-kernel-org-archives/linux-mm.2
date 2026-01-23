Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 329EFD74ED9
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 14:49:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CE016B04DE; Fri, 23 Jan 2026 09:49:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 451136B04E0; Fri, 23 Jan 2026 09:49:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37A6D6B04E1; Fri, 23 Jan 2026 09:49:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 207E16B04DE
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:49:26 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AC69E8B44A
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 14:49:25 +0000 (UTC)
X-FDA: 84363511890.06.D3C93C2
Received: from harvie.cz (harvie.cz [77.87.242.242])
	by imf06.hostedemail.com (Postfix) with ESMTP id CEB8B180005
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 14:49:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=softfail (imf06.hostedemail.com: 77.87.242.242 is neither permitted nor denied by domain of tomas.mudrunka@gmail.com) smtp.mailfrom=tomas.mudrunka@gmail.com;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=gmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769179764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=okvjiXFxIvEJF44yF5M/RTgPG9Iu1WgX3Cu+34b2nMM=;
	b=zeOWU8MPy+yoy/qpWhV3kKdwK3wnOdnyp9KYOsKIE3LkAfcBhcEDEvgmnFoZWy7BK1RTgH
	6OE3nORBD19HGfV36/GGTp+Zkl0/MvlgYbJ9Pr2lsSYqw28T1pOQ+cLAdEboid40drK4XG
	tO2iuuYea9uIWbp7vx+U4KSVMirbJJI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=softfail (imf06.hostedemail.com: 77.87.242.242 is neither permitted nor denied by domain of tomas.mudrunka@gmail.com) smtp.mailfrom=tomas.mudrunka@gmail.com;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=gmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769179764; a=rsa-sha256;
	cv=none;
	b=qPT9KPrAnljjeziB8T5eP+g2BitmXCGPrexOAVa0pNPRrqDXo/clAH30Tr3RLSnQeHYp7h
	NwoBIBaM88zuJPe/9gpketvm+TxAeGtp+aFgclyaWIkotTPdM2AvgJ3uKbIZhJMgMCOqBI
	HB2zKsU67VULYod9I+Ea2JVMF64G0Cc=
Received: from anemophobia.amit.cz (unknown [31.30.84.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by harvie.cz (Postfix) with ESMTPSA id 5A551180102;
	Fri, 23 Jan 2026 15:49:21 +0100 (CET)
From: Tomas Mudrunka <tomas.mudrunka@gmail.com>
To: tomas.mudrunka@gmail.com
Cc: akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rppt@kernel.org
Subject: CPU Cache in Linux MemTest
Date: Fri, 23 Jan 2026 15:49:08 +0100
Message-ID: <20260123144908.65146-1-tomas.mudrunka@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260122150116.3409572-1-tomas.mudrunka@gmail.com>
References: <20260122150116.3409572-1-tomas.mudrunka@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CEB8B180005
X-Stat-Signature: 5teb18k86bwnjw6554yq6yscrgwb53aw
X-Rspam-User: 
X-HE-Tag: 1769179763-965418
X-HE-Meta: U2FsdGVkX1+XDiNT7yeP9YFQJ/2j65Ne8WZJ92+2bAIeuG95WHSPPUXZnCGn7noNZJHQmwoEDmUvwwAGQctJwSTQzsmSLegTdBnpTBv7JBv+9OwCprTjCC3G7ordRkh+eFS/vxvKGZzm1u6BphU1EqPhH7N7PY0eM5oz+wNMjcex4h0+E+xT4GKGIxYZgTgaT1PCIVgvhiK/MmMp/I3DP4551qFkgxNdliWOjujnQzBUm0YDOmlcwZnvgFwKMtUYKYja3XaOeujH9TG0ryAzGSgeF6ANunX+FYzhXoqxvCC8NRXNWpGWLg2bAkZ4VusfE/WMh3BvjC7PoCOx+1JV8KzvB6qkt/ZsO5OXIB277y1gRzsKsBxyxhbqFqhPiZd7EWpAXjfn9vWR/XbDMOIaDzUExTCbqkUFb5oglT1ju0GZta3gAowqPtNVqtbs+cA7PfTbv+dxVnUPqILPfvHh07cWVgNIrK1+/3enISBprLvKi6fmrW9Vek6iqVnxNA6wVXAWTuZj2rVt4V11vjD9ZIyY5UlW7oX4Z4VCKxbi2V+Qu+/dS1DkoBtPcMaCre41ve2q/ObywVBH7zfTfR7WOCyHIn089iwuglilkRK3iE3rsGBHuJXRMDq8/oF72JVEwInP2CpsplUNBTzt9ceMADcCWcaCtSRemNCoJ+43vV/+IeekxbeyOFeWmTQghtaQcTddc5p+33Qe99KH+8V0rys6tG2xKCzMptw/2uP+isKlqw5WV9O0bV8u8mN3nbiwqSNMnleaRkziJGQFPAoiJ1ACiBX0zIEhAju2e2q+kWreY6I6DjNJe4FKkMR7UOS+GNKILB7Hnn5LiNS0EiyaFSS0ivYwJztr9bhdCEaLpkltA5+NuKctsT2GlQx05bXf0Sz54xIPFCNRLdnn+Y2GJ0Y91u0V4xOJi4pPY5GInzrFwpVGmixoti8ZzdphHh8OvmW1ffvHEwEKGTjX2MG
 jyoTmnf1
 nI5sGw1jc14bP6Vc0TkS7a8FEtrFnO2t7JmjpwZxNhvt6Gfq55qFrBl3cxpmaT9rqRf+ivm2o1MeYC/5/4uequ2PmC78+WgTnHkpnHWf37p0R8XmQvqQfZz4JZw5lo9Mfv6QA9rSQs9v5yOwxGxdlvHAd0RZ5BvbiGt7hl1dQJZUlAct+NE8INgJOA6yYxb6Smo3b37RmaqTmHI8lxpnI2WVk+vxcn3nEA4TC+xP+oIeDg04Rx39IMp1ZNAxG5ZKjrpTNhYKKDGpWTBDPGihALI8+CDvmRHhwaKydpYIiHnREzHXfTID9T7nKs1mr9NqV5S7KpaMGzaZAHlJwVQKk+zzA0M2haXWXFMPeCfByouPdxXvNuksJ+8RFsz/JlFbQsHANTw58vrJFNWQgyRaCOHUjP69iES0P3ULGpyWfa85RH8g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Also it seems that CPU cache is not disabled during early_memtest()
and there is no easy way to disable it globally at this stage of boot.
However it can be invalidated using macros like clflush() and mb().
Unfortunately those are very x86 architecture-specific.

This probably means we can use ifdefs to call the correct cache flush
macro for given architecture and disable the test altogether for
unsupported architectures.

Alternatively it might be possible to do large write somewhere else
to flush the cache. After all current memtest seems to heavily rely
solely on the fact the test pattern is written in large regions at time.

It might be possible to do opportunistic cache flush based on the same
ifdef logic when flush instruction is available on given architecture
for use in existing memtest code.
Hopefully even implementing some simple abstraction layer for this.

Can you please give me some feedback on this approach?

Thanks
Tom

