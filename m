Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85589CA0FEB
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 14:07:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE8408E00E4; Tue, 26 Aug 2025 10:07:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A971F8E00DC; Tue, 26 Aug 2025 10:07:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 938648E00E4; Tue, 26 Aug 2025 10:07:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7D1888E00DC
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 10:07:04 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4CE54160143
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:07:04 +0000 (UTC)
X-FDA: 83819085168.15.AF36E7B
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6E44280014
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:07:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="kK/mGweh";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3hb-taAgKCAgriksuivjowwotm.kwutqv25-uus3iks.wzo@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3hb-taAgKCAgriksuivjowwotm.kwutqv25-uus3iks.wzo@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756217222; a=rsa-sha256;
	cv=none;
	b=DM6bTLp1akqtN8gTJ4cLrrFj47hvY/VMx3f9XNo5UrfX9S24FjtimJOd5ht5xUcD8T4HDe
	PDISAuWm2wx7mSP/NYfZG6nQAMJChd1C4pcEAsim4lpfzx/+tLZRYIjPGywPx9/x1QGmOf
	SZWNKtxtbY/zxbS4majrPbypVph4dK8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="kK/mGweh";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3hb-taAgKCAgriksuivjowwotm.kwutqv25-uus3iks.wzo@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3hb-taAgKCAgriksuivjowwotm.kwutqv25-uus3iks.wzo@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756217222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=MIM/U1loAWy1WHGaIaxXWm/mISmivdeS4MOXtnSHfXI=;
	b=o39gPzMKNx0ex4OyOfL5xzBg/Tb5i3xsXqiY1chTN97j3qOND2oIqP6+y+W4+f/OmvPCDo
	cyGP2mClRUWqcZoFZfuhxoUFtlYQrtdmqcwYALO3woDtheay8+T01aSnGXCmpIGSLHkwC3
	rgxYwW5bX4/WnHvfD189OY1hDCL+a+o=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3cbd6cd78efso345461f8f.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756217221; x=1756822021; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MIM/U1loAWy1WHGaIaxXWm/mISmivdeS4MOXtnSHfXI=;
        b=kK/mGwehELinqURuaZjaH2HphC1r7pgdvEMHB4OGO293n427twjEY8vXjBJfdM6uJq
         nJ9voFco0K+wmzKfGTkF/T6vv45bOTuxfTNvK/pcEy0mMpmT6fBWtcyk7fNCvpqk10b+
         5lm2DHeN3Yr++c6TF7H57xHdbpXdC5NKn/QxOPmCmcgqoj0QokaccwNJeJcAhPjRYVq5
         oQWvhEc6ZFvUZPLYYsqmKxkhKV+IjDIj/LTiIRyDRvhAo1otvGI5TxM20ro4VFWla817
         sEej7Cqoz0l65oBfC3z3yUdV7tMsBf+vJZ5yK5X4PQXnk9vM7VSROhxXG0KGMCQ3HCgp
         7mOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756217221; x=1756822021;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MIM/U1loAWy1WHGaIaxXWm/mISmivdeS4MOXtnSHfXI=;
        b=UccWntiDjPySbWN5ZmPD4q1rBfRiOkKwuzw+0uC8qCZcA1nXin+rhLUwT/aYWm51OZ
         Dg0eEmf6xQtXPbzBqI8b2J2vFkwcIVqsz4AF+qg3Rb1cRFKEGUncXI6F7Fl3HFyUhfHf
         NZPPMkQMFm+9peviJKneA8VYca7V7nkU0VBZLLN5Yr7bIbiNIUjtiuI1OPnagFQLV25+
         +bHWEOBfc25sqGoLjVgsw2UPPc/FgzOp9QJMu16xNveKhh2XtNbj2Tu0q+NU1alN6l4k
         pcL9yPrfAb7zQI3sBoxSnK7TQ3BmJ9NMYZ4FjaIygSkQkwoRaETwSEem4utXZMXqNyws
         zeyQ==
X-Gm-Message-State: AOJu0Yxz7IqlBavRWu83Y/HSBzagWTXA8Rs+PndylTSJRqVvxu/KGF+Q
	gAqQ+JUdvXUlImlPlagMHwenM/dBS205DnNoOZ5FwvVDKyBp5KlrjJzlvhI5NJ0GVP+xHLPMbTp
	pxoNtQiJxCJscRw==
X-Google-Smtp-Source: AGHT+IE5PDrKa9lrBaPKlhqfT8IBKuaqTzSTLSoAm/eLHLIugHPgVuptHw9Og68GQkPrK5CfjMfI5EsdL9bWgQ==
X-Received: from wmsr15.prod.google.com ([2002:a05:600c:8b0f:b0:45b:5f83:6ae4])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:652:b0:3cb:a9e4:5a56 with SMTP id ffacd0b85a97d-3cba9e47299mr1276970f8f.30.1756217221050;
 Tue, 26 Aug 2025 07:07:01 -0700 (PDT)
Date: Tue, 26 Aug 2025 14:06:54 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAH2/rWgC/x3MSwqEMAwA0KtI1ha04Ge8iojUNI4BbUuqMoN4d
 4vLt3kXRBKmCF12gdDJkb1LKPMMcDHuS4ptMuhCV0Wra4UrGXcEFRd/rHZEvwWD+yi0y199sJ4 qtHNrdQOpCEIz/96+H+77ATQ84N1uAAAA
X-Change-Id: 20250826-cleanup-should_compact_retry-9c6b5cdf8d27
X-Mailer: b4 0.14.2
Message-ID: <20250826-cleanup-should_compact_retry-v1-1-d2ca89727fcf@google.com>
Subject: [PATCH] mm/page_alloc: Harmonize should_compact_retry() type
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E44280014
X-Stat-Signature: fxzyw5bme71afokxpwzfz6sbd5c59s8n
X-HE-Tag: 1756217222-934353
X-HE-Meta: U2FsdGVkX1/lylRYzH6MgB15xm6uOgiEu7fm0tRWQ2YX/bq4+iuUf8gUtQFSvLfXGT2/hcXqLFcC5W5AWSAr1qXX6f09/qCl4mFzsDJUX5iMtUin1Sy9yA1KzTsDhz0XVgvrMG3fO3D0DzpC7mWZEbHFpNMjr5j2F05JZSrxgoGOVF8chhE+X/dSbemHY3gg42KMES9Z891g/SdhmBGAzbFGPRJkDmWbMLurV0Q7kocWawTUayhFQ2vtuy2kcL1agFoTzllJHrWxWWJ7JOpJ9qALvIBy8xZGx6pT9eD99TixKwfcQaP4TOnVCUckwxvwoGWnH6Wlic43NEW3RJV7Ct75Z5eanO3Dr0nw3QTClCNdArE7kUWkXKUtV6KXKS8i4ehb+QZXJcyOQ+tdDdVeAij3vX9L4zD8rFQxreFCj0B/jMs1HUnAr7iNg+IGqFP0x3O1xoFfsWYK/1ATvZfh9PuUSyEDU5ArTbUuFlBdfLqA60mack/iCBw48lUduVdJYq+SnH4hv0bw12zqiTrYVawLQAQlx5iilwJrgEnPt6ESPUJ7odQpoTv0I2Rud8KF/ejSoBcR6Tv6UOTzeCuSCgH+Y6FQlyVcYtqZJHqtU8wbghTPMVIkbDlRgOK0FFp18hG+rXLyad5mcRFoIKvDvtAIBxpwO9D6Vcb2ygFFWHFCyLxtYmLYFxsCC+pgl5JKX1qWkzOpf+dOKl2W9SeAM9VTYFrbs4ptyZlmmoT7rB3S4ruqKZuHiZs95WSvnb8/IUzpqPvTTh4QkljeWjX+YgyBC4Qr3bMm0UypBYI5yKXosTywV34ROAtIFkc/NOGA8fiyH/XT5qdkkdgd8lAuexqDgIK+/CnOlNYQ8C23dcTaFxCM2Khemx/CJuXAQfiSyDC6AgXSa2dDev1ym1wAClH4CHHAIjZr39UshF+5kXgqOVAFh0+QMcfpPM7Rv9ooaN85raXBO3VfRvaOFLJ
 881UXx+X
 LjYGuxPC2TtkQNhgGVYtqiiMc1AL1BmuSLEUH2DIO51NvRYZ8c+ci/xmsg/lUiv8Q3WqRLsJ1oxat09cTzaV6fOKSu/T3VTxieyYvuIlG0hBr8YilnRlQKVK6lVE1mMZQ8NT8zFat0/d2NpEog5Plzp1b1RvuGyc84ztyXTbKqeLJEOdUSrdRKm5XeuYi2JrarW3zk7OF5W8g9jbTsiaGNG1+PUNb00T8i6XgUD0hFPn3VXnQ3zpptBnEArILU1Wqyw4yiL6hcs6Lhf33FmL4OEaI9B5cwS1HBOEn+XItV6wXwgCA1eV5f4wEhdP0oASOBnRU+y58fM7KUHL9O5hlSkfVx4cbQ4pnJOdlP3YOboU3fNXvdAZSUZZyJG+WXpz1jIR6EbCF+MhmvNjxPW+uTcf3W2j9IU0e56C6qT0joE5e/JCRIZ8DLvbTqlaRr5Q1HHUdp97LkS+Brq1YwC7mJzLsmWDt4tRafny1beFSreHv/XLH12kFuV8ePP90WBaYjv56RER6WDfRZjBINTww2ZWqV4D66jAxVF/vvROXXHeYj++FJE405Rbif3f4Ie5N5JWUf6gS56SDcRaRt03bYxVEmqRWZ461wnBFj6LR1OiS1dozlzGK0I/BhKmnj39wAjD7gAJTH1Oc6eM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently order is signed in one version of the function and unsigned in
the other. Tidy that up.

In page_alloc.c, order is unsigned in the vast majority of cases. But,
there is a cluster of exceptions in compaction-related code (probably
stemming from the fact that compact_control.order is signed). So, prefer
local consistency and make this one signed too.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d1d037f97c5fc76f8a7739e8515d7593e0ad44f9..8faa0ad9f461fbe151ec347e331d83c2fdc8cad2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4182,7 +4182,7 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 }
 
 static inline bool
-should_compact_retry(struct alloc_context *ac, unsigned int order, int alloc_flags,
+should_compact_retry(struct alloc_context *ac, int order, int alloc_flags,
 		     enum compact_result compact_result,
 		     enum compact_priority *compact_priority,
 		     int *compaction_retries)

---
base-commit: fab1beda7597fac1cecc01707d55eadb6bbe773c
change-id: 20250826-cleanup-should_compact_retry-9c6b5cdf8d27

Best regards,
-- 
Brendan Jackman <jackmanb@google.com>


