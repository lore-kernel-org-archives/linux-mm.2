Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7F36C43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 06:11:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB5C66B00AF; Wed,  1 Jul 2026 02:11:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D66D06B00B0; Wed,  1 Jul 2026 02:11:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C55F66B00B1; Wed,  1 Jul 2026 02:11:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A55116B00AF
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 02:11:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 292318C8C6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:11:52 +0000 (UTC)
X-FDA: 84939186864.24.CFE4955
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1E1AEC0004
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:11:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dRy6Fv69;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782886310;
	b=8ek+D6Oslyf3mBYTJEOoZt/EIupaftQUHkiy7rd2GCHvgxmGCXbQ1FEe+Rrck7+GQUDWoO
	f2bMbahnmWWx19ALE6gxuVtEp0XBnt35H7anPJ32EjsogZxzcORXmicntjMsUuE6vAsGQd
	nZCw1jIuX1IcIQ0sgZ2c2mN4xLJfXpI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782886310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hMPk4xo0goYwl32b+O7Fi24CGRO5SYSFgHPQLi10p/I=;
	b=nAO0JGWbUTCqWUlWbI3Ms3Jo5Cu01M7xGVasBV/2ql2DBJeh7uzYLK6sksbibLnG/BfH0Y
	TkDqzEtWfrNYKYOqJ1PP+9smCMLjBTO0BXb+WSMpd8H79SkIGn9GR4/n35aBOi52eeJB+a
	aG2PtXPU8+oRNzGaTtBsYX92aqiGsVQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dRy6Fv69;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782886308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hMPk4xo0goYwl32b+O7Fi24CGRO5SYSFgHPQLi10p/I=;
	b=dRy6Fv69wFY6/TS8kxLq8V17UqY5UqwiNnjxmqBc98kZZYGtZusJyPaE5zaXfTr83VVPV7
	lgChebnU1/F5pA/mV3qvqvAFyLHQK9XWZYlBh87qOn9Igf4EK0QeKUzUwV4nY2smGTjVqW
	Os8P27TOgYPMbiXjQk3DZRE1HZHa+v0=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <ye.liu@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 5/9] mm/page_owner: add missing newline to count_threshold format string
Date: Wed,  1 Jul 2026 14:10:48 +0800
Message-ID: <20260701061101.344679-6-ye.liu@linux.dev>
In-Reply-To: <20260701061101.344679-1-ye.liu@linux.dev>
References: <20260701061101.344679-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1E1AEC0004
X-Rspam-User: 
X-Stat-Signature: rqy4ew6sxxtaxiso1ckpbko5kqbz5taf
X-HE-Tag: 1782886309-381657
X-HE-Meta: U2FsdGVkX18jUr3L5wnYMlkqeXmCvYJ1SH9yADQluVBuRLFPNjk57Jn477dCLjh3nkxBJHXUgLtccXE6r9nf+0GDf2bJGJ9Rpt06UHAXa2Van3sIKpR+ml1rJUMg6SanFNiIDgusZbfwjYQf+cq+16bhsLzOGR+ZBrg4wq8+yy/chiO2hgDPV17XWSJTBcYqPRhs4rQto3fsISWEqL/mXbckvma1fhs5C0N1rCOtP5Wt2hVh+xfKmzoXxbujeFm3tMz4clkPFcblXZwyj+kAQn+QqZ0B3Wlmk8vftJctOZOJknq/IHuL0Fx/eGK3DpF7xTfpNBmsJrAIv5Db16SWNRBnH9eMIT52rv+Bo/DW8A0u4EyvMz3WC9AGTNXjJqhPAp+HxmROR1I0nFFgGLW1T8xi0UJHCOnRae0v0IVzaOt742xLYjcmIXNFixeUAbJ/vxC3cvKub3BfXeOdVbVpxpuyR0HTsUHM0KG/6oJleDxl+mBoMLiUKNtRZCIgDfMQi1f065Ko8gSaFDoce5gbMBdDQbAiCIZikczYAlw+OwjljEuVxrMDhKD/GOZiLIgJvjY8HtLJpBiJICiaRDiIYf3o0bbBX6MLl7c3Mp0nTYIqGcBK7RpBUZcAK5WnBbrKARskrldGPXk2kHKXnBGoj5cX2kOYdBmdEa+H4xM7FbDYTrs6TOVbADWncUD3Tku+ySSApXIS03HhQj4NSlbyHft/6PJfJAWH6f/wLqHu4Eodo7I4i2y3RIaZ90l5Bu/lD8tgZO/Xw4nBndRA0vFbSOrCzOj/sKIqXS8r52wIeP9rBKpQBuCvBrqhgukl5ABxzSCb9RrZkP2WKLD16GV3m4+D4fKssXh4f5ZfGNia6t471C2+t67bZkV6awdNnrghGUfTNlr5sz1eU1QdM15dTNi4FEsOr9J+R/MDbArYV3y04I3o2kBcsTuI6jHAdJf9vWPC+7tA4crilLAL+7w
 9I+yDal3
 01Y8Fe2IYdYRhGLtHapYmcUvG84jbs5GgK5oR21M0OTDAzg/Q7o4BxeVdkjZNmSFJSRAbB0cxVMOFhTmSchv/cpfspucf+k81jgXVZsh3cSBFZ1c7nq95HicaqIccaAHBHJXizbwVS53hju1KaDz2ZlJu3WvUaVYO1HwFVizWNXoMFEQ3Xjk5j4OdblCxMF6yJc1daUxvyCcvyUL8yRoNfP7OlYmw0LrbG93ODS+zbgu5btd0jRas8llaW8GUIzgkX+4qG3lebhsVfeCVR8ZrJPxJhEb0Cyn54nAnEjE99Fmw4hE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The DEFINE_SIMPLE_ATTRIBUTE format string for page_owner_threshold_fops
is missing a trailing \n.  simple_attr_read() uses scnprintf() with the
format string, which does not append a newline, so reading
/sys/kernel/debug/page_owner_stacks/count_threshold produces output
without a terminating newline.  Add the missing \n to match the
standard debugfs attribute convention.

Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/page_owner.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index fe2bf2274d8a..7520718f63f1 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -974,7 +974,7 @@ static int page_owner_threshold_set(void *data, u64 val)
 }
 
 DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_threshold_get,
-			&page_owner_threshold_set, "%llu");
+			&page_owner_threshold_set, "%llu\n");
 
 
 static int __init pageowner_init(void)
-- 
2.43.0


