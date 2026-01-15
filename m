Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B03ED4117D
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 12:38:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A91E6B0088; Thu, 15 Jan 2026 07:38:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 056966B0089; Thu, 15 Jan 2026 07:38:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA4C66B008A; Thu, 15 Jan 2026 07:38:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D62AA6B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 07:38:18 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A0F8116032B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:38:18 +0000 (UTC)
X-FDA: 84334151076.05.9F9106F
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf17.hostedemail.com (Postfix) with ESMTP id E0D824000B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:38:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=DSgDibXP;
	spf=pass (imf17.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768480697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/X3PUJK8bO/rHUbOWXpMZonwXVf+p5xkBo4Y6OPvyC8=;
	b=ga/H6vXnn4iqP15bYdoi+L80qhztcZGNw+Q/m8y0dhNqtYpn29eF6aoFlZMPLYewwcBKSb
	/2CZuyk9v1J4GDiRaFJI6DtREb85eYn8zraCuPuM1oeeQMq2GwlSUjsNLueTAH+KpJ1Rlo
	zak42Qe89idCkiUeQ6YZB76XY7TJ9w8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=DSgDibXP;
	spf=pass (imf17.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768480697; a=rsa-sha256;
	cv=none;
	b=Nzpn6NEwNeZJW2+UBJAX9EA/SIbp/+Z/cvwmSI4pP/xynyL4+huTAYEcNSkiHjUR//hQoY
	XM38zWp+gAlNc5Gy279EwinZu9rqqBdkMUg+tiHY8PoooVldpa1chiUz0rAO7Ra05KibQ1
	rDUjrtA0rXhGQUgNVJAUlkXHF7n/DrM=
Received: from LAPTOP-U3CCR7C6.corp.microsoft.com (unknown [20.107.46.209])
	by linux.microsoft.com (Postfix) with ESMTPSA id 0C97E20B7165;
	Thu, 15 Jan 2026 04:38:13 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0C97E20B7165
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1768480695;
	bh=/X3PUJK8bO/rHUbOWXpMZonwXVf+p5xkBo4Y6OPvyC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DSgDibXP+0WR3RnuDrkkG/LV/dvpooHOvAbV1NZA4nu/UV98zXwQOyxl5I1RDdvDg
	 iA1eaaR7ZA81R8sJfYImspoLNBXLlDB7e4dCuwUkMgV43GOfW0VU/k6sqr0KaCrOuu
	 3rXtTdHl5dFwkuNHKwBenCeCf1W86oQ0OSB/1yGk=
From: Thomas Ballasi <tballasi@linux.microsoft.com>
To: tballasi@linux.microsoft.com
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	mhiramat@kernel.org,
	rostedt@goodmis.org
Subject: [PATCH v4 0/3] mm: vmscan: add PID and cgroup ID to vmscan tracepoints
Date: Thu, 15 Jan 2026 04:38:06 -0800
Message-Id: <20260115123809.2257-1-tballasi@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260105160423.23708-1-tballasi@linux.microsoft.com>
References: <20260105160423.23708-1-tballasi@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hdr9wupgemx41rfxpwgoudidcatnnyih
X-Rspam-User: 
X-Rspamd-Queue-Id: E0D824000B
X-Rspamd-Server: rspam08
X-HE-Tag: 1768480696-421931
X-HE-Meta: U2FsdGVkX18gbozJGP3QOfPMcaY+mbgOsGl6HqvYWnUMwjhi3V8atMaYlSoEiKECkZbLpWmZxd6uWKr60yYZATgXT8rmPBKLjw78OLQLJBUxR3u3R55M20lS3bW5/v2RMYR0Qas04MITgY7k3OZKyqTdePGw+n0yDTl8VR4Oc/E0mHsYp9yOuBqlHrEgq1rR4ZNDtdGMcoYzastCKp1ptP9CvBTLD7nXUU//GGuzQRHVLZJDjkUvxFotM6CIUYoVkA2vf5+TegLWXYujKNIYPugDOzf9Pv2kDU5gDYnu+fOJ5NhFk/rpkNb+CZkYRmlyL+gEeTyhFgNizHn8maVO8PRMqrCYIUVSSiThgKy3G7QtxGnRnFwshEfN/xS6+GpSN3qjUCHq1VdtXGEEiJwE4VuvIFPEtCis9O5JkxAN3jrSPTkKgdnmUuZKDjcNr7Rjtla+T+wX+x2/riVJ5AFlNqWOSmoHYlm/WGTCDO9jSSHj+ExHXZ9Qm0WWtSAGqjyx48D4PTqFB5YuHuuVbKouFgAtoKTnKpMLFFSdH16iswRifU9F83hGJmpWlHfk3/9eJXUsHxxHbXm3O9rbJJJy3CKRIb4FIwjc+v6PcfSRQBBLB8Nmvp7lslqWbuQHk6hDLYJvYdC28iVH8W/B5EXXmDsQaNE36o4vdyp45ZhppGyYjyK/oKsNBaEgyAw0l3RAF41MkwHvtJqAM2Xu73yOTCYjfexNv9i8hEv6rEX9IpYDz/neDHPGFHFZ0mb2MtlK0jB6JNJH/fl2h7taMLkuGlkiB68HypBXjlnK6ZOcjK6sRZ6MxYJTgrNp00meHKz2RLAwB6GBzw6g/PdNKa4S0QByEbTAp5qw4lmNcKLyjfMP5NrrKiJ4BiEVIOTSCmE6gwrmJGv47Se3c5+dj30JcoCfNrAMI4bfPoRACl5miapb+NctnyOLV481d0DpXy/sUGGKww9ayh7rPl596d8
 3+sxjHqj
 sibkeMwfPMwDPaK92DBjUqmYNGKxd8FpiBzTMnsj3CiX8SKzTJSK++dMw2YJ9ndrCa1veENoG8ZbIVOTPgf4LmKI7OB5sw/2uAnAuktOwfK19pn7ZW42IgsxxMDMJnyVHfbkjvQWsQopdX5d01KmZGhoRPTxp2y16LtHEtPuJmFHZtx+0UGXqsGS9ubyhHJLJSIQKwPrWHy1634KHv68K7lQEL6ZpaJf51ED8AuzO+mJcN+sDXoXkLzNylL/yeiWll8H0vrpyQ7rhT4fZj8lRCPis8VSRS3Yp0t26o+r8bP7SuJaIQoXoi3Q+wg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changes in v4:
- added Steven's patch for __even_in_*irq() calls
- moved back to mem_cgroup_id() following Shakeel's changes
- passed cgroup ID through trace calls for slab_* tracepoints
  instead of in vmscan.h directly
- changed memcg_id instances types from unsigned short to u64 and
  updated struct entries accordingly

Link to v3:
https://lore.kernel.org/linux-trace-kernel/20260105160423.23708-1-tballasi@linux.microsoft.com/

Signed-off-by: Thomas Ballasi <tballasi@linux.microsoft.com>

Steven Rostedt (1):
  tracing: Add __event_in_*irq() helpers

Thomas Ballasi (2):
  mm: vmscan: add cgroup IDs to vmscan tracepoints
  mm: vmscan: add PIDs to vmscan tracepoints

 include/trace/events/vmscan.h              | 104 +++++++++++++--------
 include/trace/stages/stage3_trace_output.h |   8 ++
 include/trace/stages/stage7_class_define.h |  19 ++++
 mm/shrinker.c                              |   6 +-
 mm/vmscan.c                                |  17 ++--
 5 files changed, 106 insertions(+), 48 deletions(-)

-- 
2.33.8


