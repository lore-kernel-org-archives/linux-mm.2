Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0534FD3B7EA
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 18:14:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 596B86B0005; Mon,  8 Dec 2025 13:14:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5478D6B0007; Mon,  8 Dec 2025 13:14:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45D656B0008; Mon,  8 Dec 2025 13:14:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 30A646B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 13:14:28 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9EDD41DDC17
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 18:14:27 +0000 (UTC)
X-FDA: 84197103774.19.30AAD16
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf15.hostedemail.com (Postfix) with ESMTP id 033B5A000A
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 18:14:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=i9+iKU6c;
	spf=pass (imf15.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765217666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/mcwk57ne9/7uAszSiZB6wrrm5ildKtYBE6w8IXAufY=;
	b=VnQ7GuVpphvLr/TERWjvuILyrDEJdbKL871dT5SawSWp/EpiAdD+qQkuFpTPdnfF9UQCXQ
	MPcAIWKUYdSoEb2qds/yfbbmkHV2RDZ4vjNnHiwJgzEhe/4LHT5q9Ga6RbEs/0wiTu7qTc
	dJhEaanU+4e+YuPLQTZYDFjKrimtL/8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765217666; a=rsa-sha256;
	cv=none;
	b=upzXhkKEurVt6VyM2cNcm9jNk5H1A/2UYC5WpBGAZpbjlM0BSWc+BiJ8IHepzLmuu6ozi3
	x8mP2Bvzl7jv6NVlUbBTep7L+oNgcH4/kdIK6dZ9knhBOZy5I8R8IpY9JeY3uAuzU9wYna
	3cgtgzSKDbVKMNi+P3cifJ4zcCmSGUA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=i9+iKU6c;
	spf=pass (imf15.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
Received: from LAPTOP-U3CCR7C6.lan (unknown [52.148.138.235])
	by linux.microsoft.com (Postfix) with ESMTPSA id 7680C2116040;
	Mon,  8 Dec 2025 10:14:24 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7680C2116040
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1765217664;
	bh=/mcwk57ne9/7uAszSiZB6wrrm5ildKtYBE6w8IXAufY=;
	h=From:To:Cc:Subject:Date:From;
	b=i9+iKU6cHJjd6p2aBNDXdIRN/EIuJOBu0JRmx2yOj0KmZcru0yu0x32gtWs2gMQBY
	 aX0Dx41D93OM56Q1VNzeg1vtn9laLwYJzHWt9Pbqq6UZX9EouqSJAh/KTaORSsHyzK
	 ZdVDtiaCxWvO/953AmlK+aHFnPQDVEOAYXa2AXjI=
From: Thomas Ballasi <tballasi@linux.microsoft.com>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH 0/2] mm: vmscan: add PID and cgroup ID to vmscan tracepoints
Date: Mon,  8 Dec 2025 10:14:11 -0800
Message-Id: <20251208181413.4722-1-tballasi@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 033B5A000A
X-Stat-Signature: njcws4k7u4jx53uy9px3pr41cu17otzg
X-Rspam-User: 
X-HE-Tag: 1765217665-428722
X-HE-Meta: U2FsdGVkX19JI/Lu0PbqCQw5hCiOkNCTxUfk+3iNxu3StU4Ha7JkTRE9UnCHiokbyRo15Gdd63vSW7YZrj/zLNEH33WZwTJyW+Mn6p27z6/c/PXtPIYGBhshlfuvYZG0e+4VNWN1lS52LB4Yrqq7Q/zDlxhLcMpP9f8mPCzShnRpSsjDPL6Wu6i3jOt/Si9hc+eMH+CYZ0hGnk6tqu5yFbH3UcMVRmp6+AHKLUHlWdjhIad+iPGQhAn00ph8Q0WGobl5ZbCc8obDOpUKdeXh4NiR9gULaqRhxoUTkzGzVqsZ9N5Sy/2KAmM12Buhb5pD2L7sWu5U4nRDaLwBCiiiqTgHjv8saPzeTQNPJYUKfSpKEB/EISeK5WVlmD97RXP34h8DGKxMRL3OO98oRzE0u8cdbvfhTPpZ0WjA8wwNefPbbG++hNwgj44OOQaG9PzntPfq0mP56CYirVo7R7c4hx76Bl8IZZ2jZuKX+jP5bIGEiaRvR9nUC90+L1lGFQL5tvfrfUMGCR73pFrUlLbBUNX8E+kGw6pk7YZ0MI6J1F4PiD8j9UpqFjIPPRO/ToproeG0tISeyFraVKoWVmowNuhHt1asv2T89/+s1TMcBsdoAFk81Wv0p6xGOQKb7zJeHON1PE7nC6Uqy1DXgyEbcyAHlueVKKJJZ4TYJvZ0SUN8cSbJX6haHVm561KlCv0H+WD0tyMsU6ac7EOjBLHAbefhlfg7O2afcEGqahZ2oyosDgmFZt/vY4wBEXVp1fE/qtyn4Dd2uRSrrAlBT7dvRuIPxKgG1FqO3dZSaWQn4Z3ccuJbkgyvfu1hJcPX1LrSTd0YXLOd/OCq8zUV6voL2muFw5Sd1U2lqGx7RrrCIxdnUSh3ffXNcj/lUeWUXKRJ/aqfCqidH8vsO04NOE49ZxM5/Bwyju1Ehm1sLg7yE2NWIMx4a4cSFZz0hAw1V1m27vLX2DEYBitRHCjH2nu
 0Mkgf1r+
 eRFl+LkpR+KSNgWljTM3JhxaUz63gOUcH/CZtX+RS1nvx1k0y8ZNWXZR1iAvAOwAQhOuU0wduUPcux2B1NvS+T12xRjhc/leT8vJVqOWvy+m56Me1f/WjoOOtw13u6+pt0ZMia34c7zu4QfWEYSCh67sRifDG7i4/6dcJJHSDJ6KjA4226967PS8wItK+xihDoBO+KEQk/IrudY86kh35OR9uMolTcv+uSB8rbN+IDELLqqCEEfLYnDIIVi/FKqpZe1J2GWIT8hZRR/H8yLK4MwHLKEdyM78B2Z7Q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Attributing tracepoints to specific processes or cgroups might happen
to be challenging in some scenarios.  Implementing additional context
to these tracepoints with PIDs and cgroup IDs will help improve
analysis.

Signed-off-by: Thomas Ballasi <tballasi@linux.microsoft.com>

Thomas Ballasi (2):
  mm: vmscan: add cgroup IDs to vmscan tracepoints
  mm: vmscan: add PIDs to vmscan tracepoints

 include/trace/events/vmscan.h | 77 +++++++++++++++++++++++------------
 mm/vmscan.c                   | 17 ++++----
 2 files changed, 60 insertions(+), 34 deletions(-)

-- 
2.33.8


