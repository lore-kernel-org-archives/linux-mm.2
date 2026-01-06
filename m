Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 475BECD043E
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 06:20:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92B586B008A; Tue,  6 Jan 2026 01:20:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C1486B0093; Tue,  6 Jan 2026 01:20:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D6F96B0095; Tue,  6 Jan 2026 01:20:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 68DF56B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 01:20:07 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0EA3E1A6BC3
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 06:20:07 +0000 (UTC)
X-FDA: 84300538854.28.E9E528B
Received: from out203-205-221-240.mail.qq.com (out203-205-221-240.mail.qq.com [203.205.221.240])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2E1F340005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 06:20:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=LUCDwfzl;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf07.hostedemail.com: domain of realwujing@qq.com designates 203.205.221.240 as permitted sender) smtp.mailfrom=realwujing@qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767680405; a=rsa-sha256;
	cv=none;
	b=02OpPbguJlKBOqYYQ2oe2g7m12e6Ke7FKRv2QHd6qF6cj67GlEw6HanToF90LAP+BBymK9
	Ibu4gPK0fzUJxLrihS9yXgFSlmP/CbUQzrhr8IuNCMNUXgmYi5fns7Yu9RINgmhvh8pvRc
	JBFv5A5dbh5ydCkZ3blIkLN7lNp3Phg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=LUCDwfzl;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf07.hostedemail.com: domain of realwujing@qq.com designates 203.205.221.240 as permitted sender) smtp.mailfrom=realwujing@qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767680405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oWeQ2kJjEGjK3YYXF0wMYljSTvgST0B5Lrw1NuuCIhI=;
	b=bLEPXzsQCYQaE4P+sgiCxVXhQB1Nw1JNos6mUYOlEAs1dy80wYZ2tPv6KWTEilyJ45bfpH
	X/cFP/HN8Q9eg+iLdaW6Yh8y0mQbmLdBryP7zhRY/6Y1/q+rxnj7tvf/Id6wrbSPF5RjsO
	sgy+81MzRSOpVZsw5aK5MoYq4hjSu2M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1767680399; bh=oWeQ2kJjEGjK3YYXF0wMYljSTvgST0B5Lrw1NuuCIhI=;
	h=From:To:Cc:Subject:Date;
	b=LUCDwfzlEF0iCImRcmtUELsHQUtSyaiNOVFRTqdrgKF0+vpzHlmnxEBirKVge0w4x
	 gw3CQp0UMGEy4JGbD2yMJGxy6E/3wNjOqfdNeUzikLcqyZIVyVYTzgWZC7MeKiY5cR
	 ueS60Cr6NJdNKOLKqfW0bYCrnjhh9o6fQ6EbqoTQ=
Received: from localhost.localdomain ([61.144.111.35])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id 4F7A747B; Tue, 06 Jan 2026 14:19:55 +0800
X-QQ-mid: xmsmtpt1767680395txvn5w2w5
Message-ID: <tencent_B8B6D067EF7417B3B0D3DCC1A01505453F05@qq.com>
X-QQ-XMAILINFO: MqswyhUqVe0Cvri/+gbwmiEf1SPmZO+uovLwR+3auWS2LMDQ/JvJVZ+Fp2i9WJ
	 VFkeB+X9PJICG0pUtfJ1N3oN9jK9f1EcrkKcNaSxHdWONZ7ffI5JE7SGomS8XbAhA2fbI55ATAkb
	 +AduTmMh/if6V1CIr+BLjL2HQjBhIcqOkimAt6+OBg9r4/ajGFFCs0bLY1ip3KobaBUws7RWcL5Z
	 Hgm6rRZ1g5zcCKEp73Rqsj2ifISu139Ro5+0smzr7FiZoi31gawc10CxtmHAOyM6byGs6vrlgKOD
	 vCJu6IXoKDsvuJRkHN9KhqlX4WsXGUGpfbEnhcSLJb3RbL49lwPYvVICxa6h8k2ZOS892wNVT1Rw
	 sLg+Mj20QmxdPTu//FswU8NqPc2gNlbLtv17qRbVpd+ZIw70oLqJIVEIkgDR9xyzlfOvYMqyAKit
	 VOqpnfLqEenZ+gla1q1HpW7+m86xoiJWN6h+TjqV6Tt8RmKpFW5hMT5yuFVfAybbyIttNny9+6Ej
	 qutWVYvW2C3hH+DWHg05s4Gv2I0/jL4Zrmywq3Lt/k1dOQtTEfc2dYJnzOTTudG3TPEmBeanr3FI
	 4XyezwoEkeN1Lw5EYT2TqbOioWGUDF3sdWgowY13LMA92Nz+4oWqSKSCGHsbJVFVEeTQTxMw5j0a
	 1nxQBC5l777/ulllfTxDszpwhFcXPJu1c9f6XoIScc9rGzMUU15ICLNWK9OT7SgGE+QKXosC3dAM
	 Ljes1MYr9Y3ClC8130PznLWxYnapGH8Yi4a+9w1+Mv9zv7tIO6egB1se9c6/ftqBplBFzkIjy/h4
	 8pQjtIf9OK2DIQOj4jV8ao5a8gFNMMfQirM9GQrRw4oRe0h4mx6hNzqERNm1+srlR6vlGnP18IaF
	 oK752lzUfg7fxu+xGK4mEB1k5ovjoSRiQ6IDeED3IuQDLPnvMD32XDN09ew7OXKWVCvlZwbfISll
	 OxCofWXZV6bSwXZ1QlMYkfWGA3cS73Xy42O4aiVyzb/G8aZaFGjL4s6pqBh0oC+Tn6wQf3IhFSms
	 pRKihYxr/iJmhJJQOIo0IXGXs3W54=
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
From: wujing <realwujing@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Lance Yang <lance.yang@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brendan Jackman <jackmanb@google.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	wujing <realwujing@qq.com>
Subject: [PATCH v4 0/1] mm/page_alloc: auto-tune watermarks on atomic allocation failure
Date: Tue,  6 Jan 2026 14:19:49 +0800
X-OQ-MSGID: <20260106061950.1498914-1-realwujing@qq.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2E1F340005
X-Stat-Signature: 7hoghnnccuuibiwjmm36cs31e6w941p6
X-Rspam-User: 
X-HE-Tag: 1767680403-819162
X-HE-Meta: U2FsdGVkX1+mjGjl3adF/51G5vIYZSK04ownWYRGRGyf1zeqfFwQTp2d2lg5wLdmIDj5RS/AP/xIkkaJ+sgO7s0HjimGMjFvoNcF2nsFKaYI3u5RP6purzqApCrww2xXQ+u4i0kDXG53brF4emPj2s0OXLIvZ3NLCI51P0GUsDxvyJwEvnmqMGln3u4x0Uvc/DKyDg6GjL2cfEFSP++nVzwGsufPTlJUAn03l9ao6Dnf54Hg+thrySNKCMNAQY97DStWZmIIUEtyCnHmdz/5StE1xR9TPVRt5LdMQ2sm41sI6bTCeDYjOr5jsRtE1AMPxUtdk9WCTyI560g+1D0dU7a2uQKjpFXA3ZutfqfV7SNMmiKUVFMc8Di09P/iaEXCmxA+ZZNjfO0lMF0ni0a7MKqTE7MQn3hzcSSMcQakbZc11gmGJz9Ra1G1b7ug+pniyKxBeq47ycymsxIO5cgdPTW8Vko8t+azuqXnbgrV0+mQGL8m2Qylt/xriX7Ftg8APqRCSHCVuV8bxBcg5LCztG5r1WxzFSD5SahB1FAzW78tn3rAehpGjaQhoSNwyK8OONhZI+SQpBOdBiJTJ5RqiUvMkZy2ImEvBV/9MrHludyGKHvIiwHWrtTtbU9R9w671yfHu9fcGWvwq+Rv8RlgVeL3lem4mSGSDZ3v32JFBZSNofd1Ho5KqZeq3QtYagmn2V1OkZHGXihHP7KDrGqxPdCBrjwawp/zJqawje15XNaV+HusYqwj2aDU28To4hF1YZimMP7Xtq2+wNhrpZ8t1yod1L+tIZnFTbizQuaSCyp7sKMD9O3+2EBLWjK4YuGkzR2N4/ck81hCLxIAbA7rz5np3uvjF3DOyDMTrTq5g28rv18pTXOclsRj9FkN1PU/uu3xvOKA0P/0DLo4litxdkl4q8ADJC8NVDh7HbdjpYBuKAOJP9pqkvbn5t5+piCjNh3xFMaq9rWpqbznkGW
 nvzi05+D
 y446CRIsCjm41y5JcDrphfE3DbqZx+AKA/7fybcAKOs625qyZ+pkDymUoqs0y9ty2PSUBcRbUr7mkksH25uOu8qRzsJhtZdLBhEzDWNDQxTHPquJvoO3UZ6i6uT0EyNvgcC6OR/Rz3ZzaS3SxtEi30AmNJglLce2krmSFdGByY8F0i/SkRmXgRoFZOI/JG05ZmtQqfO/o9IBCRILwSyqdTWaZToTB8VjzxXGYadZ13w9P12hDMTTwgR2Ueq9NmPlodgH+qYTasaUJOIOhF+V8xE1K9oObkfyZNv8i
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


wujing (1):
  mm/page_alloc: auto-tune watermarks on atomic allocation failure

 include/linux/mmzone.h |  2 ++
 mm/page_alloc.c        | 55 +++++++++++++++++++++++++++++++++++++++---
Hi Andrew, Vlastimil, Michal, and others,

This is v4 of the patch to introduce reactive auto-tuning for GFP_ATOMIC 
allocations. This version incorporates significant architectural 
refinements based on feedback from Michal Hocko and the community.

### Addressing Michal Hocko's Feedback (v3 -> v4):

1. "Reactive is too late":
   Michal correctly noted that boosting only after failure is 
   sub-optimal for non-sleepable contexts. 
   -> v4 introduces **Proactive Soft-Boosting**. When a GFP_ATOMIC request 
   enters the slowpath but has not yet failed, a lightweight boost is 
   triggered, replenishing reserves *before* exhaustion occurs.

2. "Use watermark_scale_factor instead of complex knobs":
   Michal suggested that scaling the reclaim aggressiveness is more 
   idiomatic than just boosting the watermarks.
   -> v4 implements **Hybrid Tuning**. We now introduce 
   `zone->watermark_scale_boost`. When pressure is detected, we not 
   only boost the base watermark (via boost_watermark) but also 
   temporarily increase the recovery aggressiveness (via scaling).

3. "Smooth transition":
   There were concerns about the "cliff-edge" effect of resetting tuning 
   parameters instantly.
   -> v4 implements **Gradual Decay** for the scale boost (-5 per 
   kswapd cycle), ensuring a stable fallback to the baseline.

### Core v4 Optimizations:

1. Per-Zone Debounce: Moved the 10s debounce timer to struct zone to 
   ensure independent pressure responses across NUMA nodes.

2. Scaled Boosting Intensity: Boost strength is now dynamically scaled 
   by ~0.1% of managed pages, ensuring TB-scale systems get a 
   meaningful response.

3. Precision Pathing: Both failure-path and proactive boosts now only 
   target the preferred zone (precision break) to prevent unnecessary 
   background reclaim overhead.

4. Strict Bitmask Verification: Tightened the tuning trigger to a 
   strict (gfp_mask & GFP_ATOMIC) == GFP_ATOMIC check to focus solely 
   on mission-critical allocations.

Testing in simulated burst environments shows that the combination of 
proactive boosting and hybird scaling provides a significantly 
more robust defense against packet drops than simple reactive boosting alone.

Special thanks to Vlastimil Babka, Andrew Morton, Matthew Wilcox, Lance Yang, 
and Michal Hocko for the foundational critiques that led to this design.

Thanks for the reviews!

---

wujing (1):
  mm/page_alloc: auto-tune watermarks on atomic allocation failure

 include/linux/mmzone.h |  2 ++
 mm/page_alloc.c        | 55 +++++++++++++++++++++++++++++++++++++++---
 mm/vmscan.c            | 10 ++++++++
 3 files changed, 64 insertions(+), 3 deletions(-)

-- 
2.39.5


