Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86D03C79F81
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 12:00:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06EC16B00A7; Mon,  5 Jan 2026 07:00:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00A0C6B012E; Mon,  5 Jan 2026 07:00:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E79296B012F; Mon,  5 Jan 2026 07:00:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D46756B012B
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 07:00:03 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 899971ACF66
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 12:00:03 +0000 (UTC)
X-FDA: 84297766686.27.9BB59A1
Received: from out162-62-58-216.mail.qq.com (out162-62-58-216.mail.qq.com [162.62.58.216])
	by imf25.hostedemail.com (Postfix) with ESMTP id 03FA5A000A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 12:00:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=JTz5j2Pn;
	spf=pass (imf25.hostedemail.com: domain of realwujing@qq.com designates 162.62.58.216 as permitted sender) smtp.mailfrom=realwujing@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767614401; a=rsa-sha256;
	cv=none;
	b=a/frUWQkGMqxtYzvOIm/UE6asPfWR83Xiosx9m0mvVOWW/20Izm8oybjvzdTLylqo0H1tz
	2gAkvXeyi9XERl5XqKxASFc+sKBWanw9CDePzhrx2cZy/HUPCV4UDmdt/ilJB/fhIONUyg
	HYuMX+VWoXl6C/1WObHzzYmfb5NHfko=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=JTz5j2Pn;
	spf=pass (imf25.hostedemail.com: domain of realwujing@qq.com designates 162.62.58.216 as permitted sender) smtp.mailfrom=realwujing@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767614401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HsQN+LjsQ7x+jgQekkX3zGf1yUPhzeVvR7BJTXKig0M=;
	b=w5psq4vtKdOqsqkoI+c5WfEfpP4apRwBYthac2eT3XYjgva/FmDq+K6nILNsCJvEaLZXVT
	LV9kpjdfXRc5khgh+S4xktCIof+iMsRto0z7MHANAeS2dn3RerUf9x21H8au2wpJT1SuCX
	CTwC3AuPXx3fQpy39WLFx44K8QHtIV0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1767614397; bh=HsQN+LjsQ7x+jgQekkX3zGf1yUPhzeVvR7BJTXKig0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JTz5j2PnQn5GPlSchiputctKmGa+YRZ0bnXO1S+QmZIICH35QE4fe/DZOIxL7WWEB
	 NJ46VaXKky56914mMLw0SQplpL91XNXWyX16Q4s4CFFAoNbeCblHE8Cz5sAKf3bxYk
	 VNA7zLdRnH08RFRQ/SX8bNeqYtveCnBValyDUz4g=
Received: from localhost.localdomain ([61.144.111.35])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id EF714E12; Mon, 05 Jan 2026 19:59:55 +0800
X-QQ-mid: xmsmtpt1767614395t10ab52fo
Message-ID: <tencent_44B556221480D8371FBC534ACCF3CE2C8707@qq.com>
X-QQ-XMAILINFO: OKKHiI6c9SH3ipsCvfcnKCvyjqv8ekmf+ebMWrVPiBuv6RLMOQg5RL/RofiVd/
	 Q/z8tsTMMuxCqfp1mNxK0B08WagzH9XhTgD1B9WV1hvlj+Lzg8foGl+qLGjy03r0jv+9XRU+5Ms5
	 /6OvCfvdsB8TRaFJPIO0yr+c0fhtyLqZf8Zxcb2EZCxUh0b6e+Af33TuzTx91bDYYOsVBHILtzLr
	 pYnVQtVz0WvJB9vd50Ty3jgyBD0PPzq2CxEljCGGB7Y4l+ZKjJ1U1JOY82W+BmkQfdagH3bWnOgs
	 NRhcJS1wlIAffD6EtP/UfmY4o/VMwXJxa4rPGv0GWkfgqKy9nT75xlpIwRi5dOpCUI8yAO3evEKw
	 +iYS2/F4Jcysrxif1i9rlSGRekiMlxJyt/lWbzwXz3kaWXBaMv0t42cpg3UrDAaeOUr1u7aCUuww
	 ZdhBXLMvkXPY4m2kvs4bwU5WB/bXo8GonwHb2dEwLQhqdLJ4NIbXdfTAqJFaomRMtT4IthprlGBj
	 qBpKnOZKWE8FKkd6CB32o1O3JQDVEZaeRfdyips3Sp4p/JKLx6ZQ+RV8Un67a1jFWdZfwicDD4+S
	 UbbprhBuUISqDbkEdcQNr+zCoTN9kBVLxKZfNqUIEQYQtvISq0iOY2U6PvJJZHnehrFF+fURZdkD
	 0kLRsIn2yzbK0RlNkJA1apzeP6B9dyYaUKvgm2ejyA2d/JsCsblIbXMyhVEGmDbkq0EqwuBX34ZX
	 oCKi2MD5fUgIzKL3dGbOxyn7qhAUElkZX4wkWeRcUhpyisyTwI55IWfAL7iHOUg1kiv71YWn2x4a
	 7j6XVxUJagzDVY98UYARJlJvfrVLX+6Xq2CN0EtiFg6r7ugWTUIt/Iq5kJnX8LrtLeJoSAtCo/PO
	 w1N9KS6nQZxF3WQypLCBHllfpIn1sTkJdLRdLUbzlk27P/qtZtgIvvQmLNhua0W3puXU/1+6waCt
	 U14GRXvhIwqjDzYcxI7CApZ/Lc3jVZvh/rzoydt7XRh7ew6zGgKdHiXUdoT146a6t2wqol3VID3Y
	 wzWqFRXTB88MyvZgXPmSLRxfUs5XWgmYSO5sr8Wf6vJMEQ2FBhBPAF6vYhktga2MoBo1pVi1I0zr
	 oihXCzGJqucmWVAGBsMb2A5qLzpg==
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
From: wujing <realwujing@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>,
	Lance Yang <lance.yang@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	Qiliang Yuan <yuanql9@chinatelecom.cn>,
	wujing <realwujing@qq.com>
Subject: [PATCH v3 1/1] mm/page_alloc: auto-tune watermarks on atomic allocation failure
Date: Mon,  5 Jan 2026 19:59:43 +0800
X-OQ-MSGID: <20260105115943.1361645-2-realwujing@qq.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260105115943.1361645-1-realwujing@qq.com>
References: <tencent_C5AD9528AAB1853E24A7DC98A19D700E3808@qq.com>
 <20260105115943.1361645-1-realwujing@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 03FA5A000A
X-Rspamd-Server: rspam04
X-Stat-Signature: qt5b5np4a6tteuwn39no8ioaa7h3519d
X-HE-Tag: 1767614400-883698
X-HE-Meta: U2FsdGVkX18JEivkoQ9Uy3rTEY/awq+rp/jYJfZhoDLSsYGEQ2kdJo+wlJxhsR0pMQIpXhoijSs1h0Efm8Wja5WF2+0sbqrYB6aD7wGvX0FISionxT9OlFeWm+BFUXvAd2v3ha5DXMzEzLqMryqBCq6ceiBNKi1yswt8lDlVEH61d8T9HSvqRgpfEJhqW9Kw+9Hh03Xx7ILhL2Vq0qpyWpo2j+VZQIY/gGZrlgQMsm6e5OPmtwOzeXdUIgBIJlrKZIAgffI2gECBnjczxeHwn4FkvblWlGBiU47igmlr1A6CZoXtHuV1KZAkaEggzNsDDHSGENUhr8Ks+bUjZraQWmo2qYkR5/oBAfjO3ghOVOKjrgCqBtJb1Kl71Od+7ioDSw7RUfWQZ20LnVn6OWD830PdZsaNZJVLGGStqj6eiWM/dmE5QpXbjkKPuMdL+hL3Hk2/qSahk07/zUVhypGFQKrEEbtrP0fFOEJkqF0mN8h+KBCGgStBPAHJd77s3GQqflYdXieglAKupLBjyjsdLr1rbCIPlPm6Hq49e2ilQH8OvpLTZdNuqYWWc/z2Kot+8ilXy/D1vY1+UzcrQQptfoNghpxT9vtkmd5ADNuj8GP4uEwzAl8Wk7cRjqTi5axBYLNc0vdycPjPrmK4cHhhKKgriGRVuf6oqwIfZGwdHxp34lH2DxOpXaroLjoRLGd7E4lwAO60meMSfoqznb3DzHiSD4S8FB5N88oxHj/0LN6H+O9AroxrqGGi6/XYI65Lh95n6suLY92U6xY7+zKORw23I4lfy+VjIJsQXQkAHaDSLnlI6KVdvxUlR1aESY7oFe6l26z0WO6X03kBg4H0SYHQ37gBsbaVJSILRVzFBjdA2XrH6cKXbU7EULuEEhx/aEvf5PCsshU1dpkqDEDqvSW9iZTNGbuufOKytTSs4xqrFdIJLi8TM9N6TLEuShElgR0rWzo60mW72rxeS3G
 fUHKpG+i
 ne09XeATm95C80Qe7c9Vk5LfqaYi0CfpNuBXjkKLxaH/wEu8XAG265LiIsg0if0EYwCZ/X8XRc+qFGFk+bS7NfB4gSk4Q7XF61oq2BQhRJmYLFSFKcaV8X+qT4psoIIYJKfIQNYLwLMgo7Mh7fwbMgfH3YoCiAOR7WnTwjkuq5WTzJlA+O9tOO8zf894+P5g0YeFHxBcVRhFA0shsjb/+C9CLeJl/P2o0IRcg3Vt81GW5uBfphdc5FeTVGzlVskHXPe+lryh2EeTgswZwToGk8SSLfaFuKKHGI0jX8BfzIRgSrwlOOE/+p5ySsQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a mechanism to dynamically boost watermarks when critical
atomic allocations (GFP_ATOMIC, order-0) fail. This prevents recurring
network packet drops or other atomic failures by proactively triggering
kswapd to reclaim memory for future atomic requests.

The mechanism utilizes the existing watermark_boost infrastructure. When
an order-0 atomic allocation fails, watermarks are boosted in the
relevant zones, which encourages kswapd to reclaim pages more
aggressively. Boosting is debounced to once every 10 seconds to prevent
adjustment storms during burst traffic.

Testing has shown that this allows the system to recover quickly from
sudden spikes in network traffic that otherwise would cause persistent
allocation failures.

Observed failure logs:
[38535641.026406] node 0: slabs: 941, objs: 54656, free: 0
[38535641.037711] node 1: slabs: 349, objs: 22096, free: 272
[38535641.049025] node 1: slabs: 349, objs: 22096, free: 272
[38535642.795972] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
[38535642.805017] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
[38535642.816311] node 0: slabs: 854, objs: 42320, free: 0
[38535642.823066] node 1: slabs: 400, objs: 25360, free: 294
[38535643.070199] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
[38535643.078861] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
[38535643.089719] node 0: slabs: 841, objs: 41824, free: 0
[38535643.096513] node 1: slabs: 393, objs: 24480, free: 272
[38535643.484149] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
[38535643.492831] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
[38535643.503666] node 0: slabs: 898, objs: 43120, free: 159
[38535643.510140] node 1: slabs: 404, objs: 25424, free: 319
[38535644.699224] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
[38535644.707911] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
[38535644.718700] node 0: slabs: 1031, objs: 43328, free: 0
[38535644.725059] node 1: slabs: 339, objs: 17616, free: 317
[38535645.428345] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
[38535645.436888] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
[38535645.447664] node 0: slabs: 940, objs: 40864, free: 144
[38535645.454026] node 1: slabs: 322, objs: 19168, free: 383
[38535645.556122] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
[38535645.564576] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
[38535649.655523] warn_alloc: 59 callbacks suppressed
[38535649.655527] swapper/100: page allocation failure: order:0, mode:0x480020(GFP_ATOMIC), nodemask=(null)
[38535649.671692] swapper/100 cpuset=/ mems_allowed=0-1

Signed-off-by: wujing <realwujing@qq.com>
Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
---
 mm/page_alloc.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c380f063e8b7..a2959fee28d9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3975,6 +3975,10 @@ static void warn_alloc_show_mem(gfp_t gfp_mask, nodemask_t *nodemask)
 	mem_cgroup_show_protected_memory(NULL);
 }
 
+/* Auto-tuning watermarks on atomic allocation failures */
+static unsigned long last_boost_jiffies = 0;
+#define BOOST_DEBOUNCE_MS 10000  /* 10 seconds debounce */
+
 void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...)
 {
 	struct va_format vaf;
@@ -4947,6 +4951,22 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 		goto retry;
 	}
 fail:
+	/* Auto-tuning: boost watermarks if atomic allocation fails */
+	if ((gfp_mask & GFP_ATOMIC) && order == 0) {
+		unsigned long now = jiffies;
+
+		if (time_after(now, last_boost_jiffies + msecs_to_jiffies(BOOST_DEBOUNCE_MS))) {
+			struct zoneref *z;
+			struct zone *zone;
+
+			last_boost_jiffies = now;
+			for_each_zone_zonelist(zone, z, ac->zonelist, ac->highest_zoneidx) {
+				if (boost_watermark(zone))
+					wakeup_kswapd(zone, gfp_mask, 0, ac->highest_zoneidx);
+			}
+		}
+	}
+
 	warn_alloc(gfp_mask, ac->nodemask,
 			"page allocation failure: order:%u", order);
 got_pg:
-- 
2.39.5


