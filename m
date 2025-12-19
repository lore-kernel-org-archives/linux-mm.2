Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1109D711CC
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 01:58:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90A666B0092; Thu, 18 Dec 2025 20:58:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 881816B0095; Thu, 18 Dec 2025 20:58:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 609C86B0092; Thu, 18 Dec 2025 20:58:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3E67C6B0092
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 20:58:20 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EF43313AC5D
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:58:19 +0000 (UTC)
X-FDA: 84234560718.25.3860CC8
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf21.hostedemail.com (Postfix) with ESMTP id 34B981C000A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:58:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Vx+LcsBi;
	spf=pass (imf21.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766109498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JASHxfPfYQSKse+kuG4VzpZ0I42nYxaqH/nTGcRmQl0=;
	b=wEnjTFuRPYYlYC4ZYo2ekX0ukvC1kCrj8GitmSu0DhVj28vSAjAPD9TGta9vAp0Nt3SbX2
	z2rstx5KZYRav+hjN24s8LQSerYbm3RoGf49cRa44li1X0E623o6lN370+EojW9YO4uEXl
	c84xVtWGbaal+jIulqClUFDG3sL3558=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Vx+LcsBi;
	spf=pass (imf21.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766109498; a=rsa-sha256;
	cv=none;
	b=w/xQpTw/agFsMuTgZigYTPyoIqgpfY/4bAE+dl3/J9OFgJJ2KdNRiZpQjkR7UJvdC8+zWT
	K4BqAOgQtrgyNEEMSMajwN6SZ66G48BcoXn1AQ2+eWHUyUIB8BkcdN5h9FpmFdqii5OLax
	n3YGWb9uS5U/mThGw1Q1XXevBiNJkcc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766109486;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JASHxfPfYQSKse+kuG4VzpZ0I42nYxaqH/nTGcRmQl0=;
	b=Vx+LcsBiO5zz6pK4lcJRFPF7PiPvaUlUn8+m+9SY1YYu1VlqbSI5ITI5qOkoQN97xvQDms
	BOy0YtVljrr98vr95IkdI5So3ph/BnO2oSvOI6XvLabGJ1Q5g9J5UkldMw0WM2O9w80kQP
	upSUAMBTQVj2bNiOdyRla+htU7J+5/g=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: JP Kobryn <inwardvessel@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH bpf-next v1 1/6] mm: declare memcg_page_state_output() in memcontrol.h
Date: Thu, 18 Dec 2025 17:57:45 -0800
Message-ID: <20251219015750.23732-2-roman.gushchin@linux.dev>
In-Reply-To: <20251219015750.23732-1-roman.gushchin@linux.dev>
References: <20251219015750.23732-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Stat-Signature: d9ykoguk7tc9gkg3okp4d4pd8qkooc3d
X-Rspam-User: 
X-Rspamd-Queue-Id: 34B981C000A
X-HE-Tag: 1766109498-106862
X-HE-Meta: U2FsdGVkX1/S7UgMebJ1o0FiqFMB8yMMKWniiZhWaz0Yu5hlotBPuKfOxNZRAGuVvKXrJ3yMUlvjcrgIcMyqdr+ChRBTAgsgYIaoYU/uqccqEOi+eFPAv/YiSCIrFDuN7kwx0sNr6SGaaVMD22VgHsaCKaicI4R31a8fUs/wrgjr0ulfydZ5Iml0Md+4uffUtDRN4nGyj/4kuJlovNyV0XCJEXRybYmFshOe+j8gam8TEz4Ynlk0EcN/RTRXOzQDuxsJY/cz0VafN6VUAUWhyEeqGlLjqRv/nlw83hhV9NP0h1w+m9OUvg93EMSb7pcfBE2OYpv0H7cMBPmJ0DJ5m/x1kXdJ3BMpvemX1vK/sk2u088js2vhr5Gk+cu73bumASQcvPLe0fqPu2LVbcsDchFn/nHKIxZ712064+uTImaoBi85btF8Oa3s0y2BaBBrstt3M2/MJGJSPyKZ/VjbGiN/glZzcnvA0vB1JrR/dD4Ag/AaRjtrAHAAU61+0JogScoBdAmG0nb0W0b0sbB5IQdLDXAv977QVMSqxr3OeWjrnETc+e5+V0kxKud0tU4oKPd8vUN5e2cQmgSoubYKnum2I2ZogfPEXCSmfP4Zqi20sWFPSb7Xm2MWv0xB4loKWnrk09TuMK1B0qxXPu7HiIQqqI/ON/rESCWGWZroAxJS4oliQiyL3wY2R5S8QsUrP5jM+ZyugeaLhJYC8oM5meeYlMukP+WnYhAb9IX1txWh2DaqF/t7zkXgvgQx390DV+HR7BBHGEaxpuHmwzCtz5pnAgdNBaguYmhJnDOR3YKVBT1XxEJVXpZ4SUqaWjwkqfsZ+t+i6clLppUyY2TkY4Dzlkt28l+g/qtuhhUDgzIeAdHxVBD6Q7YjfD4ULTNl6lSj+jSb3aazeZ0Wks/LcjbjvmeFiClIXK6JVJjeakI3+j8q5y0wDIMc9F8Yp69rkVSV7tSQJDGMX99axKO
 Seo2xRRG
 HFAEOJNPX8qEBbUNl0U5wt6c130ejQbs2fVCtAywda5cQjdyQ0tH2hED6A1IQXBA2jbb8ns32zjWHxpgIfE3X4BAPVYjNV3TnMJ7hqoRVoRutDbbppqKni0534H1vgX5qYpEjj5uWpLvaZdnhU1/mqxqiQI5QLMbBS0imaBYF0AkS5e8qCz0iNwk2F8r5ugog2pZaV4QolVJ4LA0nBH5K0Avta62TKiUKw/4J13h0yVzz5JfEuuXhsD6BLPGuJkVsZ/CUcKkVRarVghRtc8TU6cDbT4xu4vFCqYT/1POaqd9V+Bb5X113X4K7w+AMg8IqIjwvNl1EFSSF0WwbmpcMUliRHg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To use memcg_page_state_output() in bpf_memcontrol.c move the
declaration from v1-specific memcontrol-v1.h to memcontrol.h.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
---
 include/linux/memcontrol.h | 1 +
 mm/memcontrol-v1.h         | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 6a48398a1f4e..b309d13110af 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -950,6 +950,7 @@ static inline void mod_memcg_page_state(struct page *page,
 }
 
 unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx);
+unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
 unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx);
 unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 				      enum node_stat_item idx);
diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index 6358464bb416..a304ad418cdf 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -27,7 +27,6 @@ unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap);
 void drain_all_stock(struct mem_cgroup *root_memcg);
 
 unsigned long memcg_events(struct mem_cgroup *memcg, int event);
-unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
 int memory_stat_show(struct seq_file *m, void *v);
 
 void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n);
-- 
2.52.0


