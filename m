Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E59D8CCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 07:53:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48BA48E002F; Mon,  3 Nov 2025 02:53:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43C188E002A; Mon,  3 Nov 2025 02:53:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 305068E002F; Mon,  3 Nov 2025 02:53:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1C1B68E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 02:53:17 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D688F4AEAA
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:53:16 +0000 (UTC)
X-FDA: 84068530392.12.3C46062
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf09.hostedemail.com (Postfix) with ESMTP id D207A140004
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:53:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=TnWZxnGd;
	dmarc=pass (policy=reject) header.from=shopee.com;
	spf=pass (imf09.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762156394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6yMtctYgS2rV+P47tm9bNW95kd+lcuzHA0J2B8KxNkI=;
	b=l1U2r6KubpH5jPO7C3W+D3EKoFoG6zCum94H0HqP1WmkwTahGBpwcozdgxOy7wnCeIKIN3
	OrAo/IO62KV1awHeZOTIIUR49l7P8kuj8xkp6pe4ojDuLwFwWkz8xOepk8H55IGKq77mHl
	rSwWLrO2RLBRumckI46YvRcsS/Fu4k4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=TnWZxnGd;
	dmarc=pass (policy=reject) header.from=shopee.com;
	spf=pass (imf09.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762156394; a=rsa-sha256;
	cv=none;
	b=vYyZ5vrp7EQfzA/q3+2kgMNcVfnP6Ov9cPd3qUTG+xYZJcwIFBbCXyaBDwE8Ew8123tqDP
	JRoKNzYYR/qQO8FpiYTAGfTnLI2Ptkhc1DlxIZh24itl0LDQLvxgdzUgtq+chOrGAfe5jR
	J+d3Qzt9IVhK7yH1oZvvQ+AjY7+Gljc=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-339d7c403b6so3732165a91.2
        for <linux-mm@kvack.org>; Sun, 02 Nov 2025 23:53:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1762156394; x=1762761194; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6yMtctYgS2rV+P47tm9bNW95kd+lcuzHA0J2B8KxNkI=;
        b=TnWZxnGdnhmSEEc7kxpFf/ZLBMgFLgzLoLWmZgg+LorLc9HTF1kJEgFi/3ZPgRBE6r
         6GZOOe/AtiUulC9e6zVq7jrVtB+EviBFKPBM3yMcxaeoctXK4C2/oeGAAGZheJx08+VM
         QUdcOx9SwvciPnnMOCPvrP2HaR4iMmAq10MNMWVRKJgg1qYfyZNasY5eJBARckz2jkck
         xmenCwG7YlADu8lT/9FNPeR/9XwVc4UNll4g5SMUMz41Gr5+0SFOGaqhj9aCNygijNWU
         iCksJu6QRvbFFFCLhs1rR0JXSOP8ic5iuPBQ2KKw66/LoYtISkZeSpJ+6Eql4DKPh/YE
         XX5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762156394; x=1762761194;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6yMtctYgS2rV+P47tm9bNW95kd+lcuzHA0J2B8KxNkI=;
        b=ibMoU040wex2A94bd+ySsixXl5sAQ8BfYmtKbfcpjuEV/ekKD9TclqqHjeXzGxTxSK
         BvRzerO1C9DvaXcRXKVH2VpzZLgxAaIoIy0vxbjgzsVNeRr1bpUlKtoJg/u+faInB5IH
         mOMvxW9mSAUFtTZtlmoIrjLShShGmNUd3E/8GbBxSzf3wAkl07j0hGESRCE7Qh0QU6vW
         mLW5hg3RMbzObgQ7I8oyixLjHSAc32gEesu8saetROcHhpBhqnH5uI5ZSBnhFNo+sUsl
         uobCjACIRbhKR5he+/qmLOw/U9xAWJ0DKXWUXPPfk6Pai7p1u6wHMMkcC2mY5Uq/NXgI
         hN1A==
X-Forwarded-Encrypted: i=1; AJvYcCWvlgVThFeS2zkhcyYKZyXU58Vl2WfsCx9+DLFgkWErWwenDYu/PBDeFi3wACxv3H0Z7m415fbPQw==@kvack.org
X-Gm-Message-State: AOJu0YyK7fGsHjY5t+fZwk8ajW8R+p5zcu6d8re6jPIFR+HT7xge85DD
	2F/gePJY0/XGBile4m11RLD4XhbRpPc0hl6YLcdJhpO6xdATyiP5difl896FbX5VGk0=
X-Gm-Gg: ASbGncvwA2G3PsZLR9HAjhXjBrUERdaJy/oz98lvnrOVO89PZWrNZTnGJUDCbe1Jxod
	Lsi76jfHrmufn23afInILST2SKn7PawlCrGH110Xqab5UghiRBIhvosvqoQ88y7wpLfmh632ito
	E0pgZugqY+B8AgAeKBtJDpZ+Prc3USrOLe5LGV+SzfMYxcx98kyR+AaZzBS2dV8VdqMaw4C8600
	8KNJ/wBL0bnVPls52Xfxx9vr3K86i/qnZDokgWTt2SmJWnUJxr4zc3uYsHHVGuou/oc1KfytqGG
	uI9IVhCQIVLyoJCKRXKzEAN2oavNnotXitEqZPuuS+loctOSNW+rbPzDKT/IIJAzhhUz+6DuoHE
	5lnixMp2nQo+FMEpU3SMArdwCJw0gvyngxPfkY3IFbbohhH3BlV7CJCGVW0CgHBC7F0fALY6Z23
	HP9zIaF/DELwcZ3qZ4oPQAuEtw
X-Google-Smtp-Source: AGHT+IELQOgDx8D/eQP4ToiYJS7h+qaVvXs4UNrgHqqZp+hj5K9vMTs1s/xhbdYPxDl7zK1DXp+1dQ==
X-Received: by 2002:a17:90b:53c7:b0:339:eff5:ef26 with SMTP id 98e67ed59e1d1-3408307e71amr13784912a91.30.1762156393719;
        Sun, 02 Nov 2025 23:53:13 -0800 (PST)
Received: from .shopee.com ([122.11.166.8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34159a16652sm34552a91.20.2025.11.02.23.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 23:53:13 -0800 (PST)
From: Leon Huang Fu <leon.huangfu@shopee.com>
To: stable@vger.kernel.org,
	greg@kroah.com
Cc: tj@kernel.org,
	lizefan.x@bytedance.com,
	hannes@cmpxchg.org,
	corbet@lwn.net,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeelb@google.com,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	sjenning@redhat.com,
	ddstreet@ieee.org,
	vitaly.wool@konsulko.com,
	lance.yang@linux.dev,
	leon.huangfu@shopee.com,
	shy828301@gmail.com,
	yosryahmed@google.com,
	sashal@kernel.org,
	vishal.moola@gmail.com,
	cerasuolodomenico@gmail.com,
	nphamcs@gmail.com,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Chris Li <chrisl@kernel.org>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Greg Thelen <gthelen@google.com>,
	Ivan Babrou <ivan@cloudflare.com>,
	Michal Koutny <mkoutny@suse.com>,
	Waiman Long <longman@redhat.com>,
	Wei Xu <weixugc@google.com>
Subject: [PATCH 6.6.y 3/7] mm: memcg: change flush_next_time to flush_last_time
Date: Mon,  3 Nov 2025 15:51:31 +0800
Message-ID: <20251103075135.20254-4-leon.huangfu@shopee.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251103075135.20254-1-leon.huangfu@shopee.com>
References: <20251103075135.20254-1-leon.huangfu@shopee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D207A140004
X-Rspamd-Server: rspam03
X-Stat-Signature: 4pcxst66yx8t67ye3jijezixj4o6xo87
X-HE-Tag: 1762156394-355989
X-HE-Meta: U2FsdGVkX1+gSNamlr8OD4nYfya15SIRoCb6fcD0SKjDmk4wtoniskCE0WFyZ9E7vjBoTkQ/ynG0Uj5O9jjNUwj2F9iAGKuk3IQNydtiUDxkATv3qusbKbZTvQfLTq9UCnf9Lw130RvDFVzgh5n+I+rtJXKXkS8426U3z7vvKgV41tTrKG9S/SO9AXQkP3GAPsRgVsxnKrPK28Zcg01y/IYSTWBYK76AyGedWSDqdKi4tYuZc63Io00NScWEefJ9Osx1g/bUBT8Qovd6Ud0e1dPh/7naAs/Rp/sCh83g+7f09dT9fyu9oqNLoPMdsLPYriD1XxuWfjb/hI0tFM5g8nLJ+4UaEeFFk+vZ4DlOJ6E3J0WhZitN4hv04urgqEqUupXvPZqa6imv5mseXUjaFe3WvoQFwOpgyfvRlqfQQDAJQR7m5ZDy1U3oa373nkBME8bvVeFBj0XbQhhOM1m4VMuZO/SWkRlIH4gLCvItjPL5TMUfnmprq7Fc0fLswGw3zpSbGKwDbG6lNJX8AZut7YBuq8o7smns7LqxAKVaTHQv2y8+Ok4S+i2YnlAFomCfoKkWndgQB3veDwAcdESoEyKzvV0Wtfhw9d+uTDBPNoc7QiP2MsuFgHO5g6eqVIr4hFtP3iWFW1l+onHtvfuKGepfWwlqbD8Hm4TpeT4oeso+Fsj4NRHzK0pxtlYox7T6jqFYMVaCpwhC8bIBi8nvXpS1IFOWcb7U7lkU/a81j8Mmf760SZdkJzjIVD6JZQOlhI7bJWn/+I2iQxWIZvwmcg1Yk9B9wTO+LvEv8IIm6bRStfaUWuF8fW87d7uedu9IAOZ+FytL6LvHxwf4VmBjIuH86qBsN38JqaU7XQXDjP94jZy36ECfkwHYJL33KLZbGeuT043qyrnwWHfYZ+DOonWm7OHIkj6NsWa1Yuy8tnXEWBUjIudgsA+vY3fx7+KSB8F+OiWlGpkB1pcxeQd
 f2E+lRD/
 N4kf9qxYutwjlgrVaX7uP8jcO/kt6eiyi6tp0/tEmRGZQhVp9u2yikfmUXevUJG584StTmn7reqc7fMB6dB4siEqpgBNb5q/8wPlYagd3Grm5ObT9E20wH+7UjflKdZl3HBNvz0ZjOT8wg7R1Y5PCEnxlDj6z7uZc64oM0bnDN/5sg+4knPcvUDddo/IlTrpbbHPgcIjoOCwnW5wm0SL/OyRUq446hTfHq/tNyCccE1Dd6xhPTErxEi+hTzAbf/tTVoaLJzcjKyG28RIOQB7uSdp7cQ5wM2A+UZPATd7MKH5qQCHlva6FgPaW0xZDIlI6wCw+p2p+zJJdvyQZycTuSPHEh0uXrnYdAyBzK3v8tgZBCfoYL5LYatQ7q6Zs32XLVVY8DvNgc85XHhrAhF9AT9kmFs2idFkWyvVJqFVjjBP50B0ZMx8KivGDaUdqdrJoFze4Y/x/gokf2JqTd9IlB211wvwiJyt3ULgl/Wuf5PlahekB6cVJSeSy9SRHw4eFgxAhAVzhpxxCPMkzvgla/mGt980NDH3hfyUEvcJS2GcL5P5P3GKRGJR8gFQ+OBMxkA5pF5nV3C/pI2EcJysMl5gOmNzgwNBEBnU5uxNYoNLmPdRfn2jERu2PRDNTFp+HJpy8H5hAsOvLLbcpRy0nidJJAf+zdNMinsgdDQCtWOqM7i3DJ4gCNrMV2xWF9a9o5MkZpu9to2d4Xf21HtV2C4pAwEd9miDa0PTMCEKmJP1VWTQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yosry Ahmed <yosryahmed@google.com>

[ Upstream commit 508bed884767a8eb394640bae9edcdf082816c43 ]

Patch series "mm: memcg: subtree stats flushing and thresholds", v4.

This series attempts to address shortages in today's approach for memcg
stats flushing, namely occasionally stale or expensive stat reads.  The
series does so by changing the threshold that we use to decide whether to
trigger a flush to be per memcg instead of global (patch 3), and then
changing flushing to be per memcg (i.e.  subtree flushes) instead of
global (patch 5).

This patch (of 5):

flush_next_time is an inaccurate name.  It's not the next time that
periodic flushing will happen, it's rather the next time that ratelimited
flushing can happen if the periodic flusher is late.

Simplify its semantics by just storing the timestamp of the last flush
instead, flush_last_time.  Move the 2*FLUSH_TIME addition to
mem_cgroup_flush_stats_ratelimited(), and add a comment explaining it.
This way, all the ratelimiting semantics live in one place.

No functional change intended.

Link: https://lkml.kernel.org/r/20231129032154.3710765-1-yosryahmed@google.com
Link: https://lkml.kernel.org/r/20231129032154.3710765-2-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Tested-by: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Chris Li <chrisl@kernel.org> (Google)
Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Ivan Babrou <ivan@cloudflare.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutny <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Wei Xu <weixugc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Leon Huang Fu <leon.huangfu@shopee.com>
---
 mm/memcontrol.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 03a984287e5b..433cd273006d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -590,7 +590,7 @@ static DECLARE_DEFERRABLE_WORK(stats_flush_dwork, flush_memcg_stats_dwork);
 static DEFINE_PER_CPU(unsigned int, stats_updates);
 static atomic_t stats_flush_ongoing = ATOMIC_INIT(0);
 static atomic_t stats_flush_threshold = ATOMIC_INIT(0);
-static u64 flush_next_time;
+static u64 flush_last_time;

 #define FLUSH_TIME (2UL*HZ)

@@ -650,7 +650,7 @@ static void do_flush_stats(void)
 	    atomic_xchg(&stats_flush_ongoing, 1))
 		return;

-	WRITE_ONCE(flush_next_time, jiffies_64 + 2*FLUSH_TIME);
+	WRITE_ONCE(flush_last_time, jiffies_64);

 	cgroup_rstat_flush(root_mem_cgroup->css.cgroup);

@@ -666,7 +666,8 @@ void mem_cgroup_flush_stats(void)

 void mem_cgroup_flush_stats_ratelimited(void)
 {
-	if (time_after64(jiffies_64, READ_ONCE(flush_next_time)))
+	/* Only flush if the periodic flusher is one full cycle late */
+	if (time_after64(jiffies_64, READ_ONCE(flush_last_time) + 2*FLUSH_TIME))
 		mem_cgroup_flush_stats();
 }

--
2.50.1

