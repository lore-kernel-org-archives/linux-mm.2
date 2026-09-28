Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63C8ECA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 11:47:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65CC06B0093; Mon, 28 Sep 2026 07:47:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 634936B0095; Mon, 28 Sep 2026 07:47:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 571F26B0096; Mon, 28 Sep 2026 07:47:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3388A6B0093
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:47:07 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B8E2D80147
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:47:06 +0000 (UTC)
X-FDA: 85262994852.03.55DAC07
Received: from mta0.migadu.com (out-215.mta0.migadu.com [91.218.175.215])
	by imf07.hostedemail.com (Postfix) with ESMTP id C3FB940004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:47:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="bBOOvOA/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.215 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790596025;
	b=0myR+VKVxRr+HTppSZ+GrF0nWfT42G/dRriM7TZRLb1jl9WYTbYOJEACi8pCjolQmjE2Cw
	P2enswRY6dreo9gfJFMFNRvu4/pZY83tm6mK0DnRbBVQ1a9XO659FQW06oPP6okCsXGJiW
	VhVRAJ2vWESWmKO9a3r5ze9DskXhB3A=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="bBOOvOA/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.215 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790596025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xAuKvJUNe+8zunX/GYOFGUl60AEQ7Snh8/NW+ftIy8w=;
	b=EjW5Pp2K4kwtiO513N48A2f3k5n8+A3X/mzA+wvwcjqNqGsdHv9q0l/WGJuyU26a3ovCD5
	6QhQetLEKp2fuI983hHdUTKcMEXYMwQvFpmsZgaK53VFpJe5CfBcp35LjWw+6cIsS+mz0E
	bKVXyNibAv3lP+ySJPe5jWznd5xIiJQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tBnHeT9n3h9R80j6UKN1h8POd16BKYoh4+WiZYGwAFw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790596023; v=1; x=1791200823;
 b=bBOOvOA/IKxbFuxTxyt0UBslh0/lUFF/+VXJiuNGb8cyZvzmr5+3mFeD7jBVpOAuK2SM0LE4
 uyyYVmJ7LC3vCrVWfpSRlUfboSPbrQuLH64smldybAUZKA8OIDWklbYCTFaqaF2BtakejxzkPIa
 qGFPmrF/r4jRyZ7vzST2j1IQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b48613931d2c734c;
	Mon, 28 Sep 2026 11:47:02 +0000
X-Mizu-Trace-ID: b48613931d2c734c
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH RFC v2 1/7] mm/memcontrol: drop unused vmscan tracepoint include
Date: Mon, 28 Sep 2026 19:46:18 +0800
Message-Id: <20260928114625.3609130-2-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260928114625.3609130-1-ridong.chen@linux.dev>
References: <20260928114625.3609130-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 45anf33ubg1jxktsdyepuja6yzagbfs7
X-Rspam-User: 
X-Rspamd-Queue-Id: C3FB940004
X-HE-Tag: 1790596024-523286
X-HE-Meta: U2FsdGVkX1+B1dCMD3/AipkfTCnUZDGbWl+4Uop8zDHviclM0T8tjfxVW1YhHez6VHohdCFKkfXNk18DlyD//+tsVA7XLBAneD9eb0m+ax4/tVCtvxQ4K3QhDi+IOzc+mGHOu5OlFdJrSxLGlxls+77//P3IWVs0v21grCXDvMQZz7ihnv+UQ5z34odGj39W5yl/mvVYdSXPnUqB6X8E9jztEcTuz9DsqKNdmdiTYnYuWdqrcXHNzdDI6O1dI6lTmGoOCIe+9hBRO55FeerTNP0xMLeuGD+wSMzt2bUbfpbU1KCVyMsQ3A3rgxrTjDs9C41s8auRnaH5oa34HF9h3SqUODWLNwhoUoSasa8D5KHL6e8Lkm5oze3hHj7QzY6UER7L6LJBq+/9pgDxpHYTKbC6rHOdT6klSCG8R1t8wwYA9Vk5tVKuknfKf3JvWwZxUvcbpBQV+IdQHkqbo//edv/5HAuhZEVPtODSpDsbFr6u+1zpsR722yvpbnWOxbrp9rrmWkF/D3wq82EKgc4Lt5fjgReY7XnaGDXGVEN9LiWSoX5g3RIAxKMyuCkGxSwj9ZfIAkDfGJJF2Vm7vaMj7KIz45DjDfTiEf+MlHbUqB/yACUIYluYFdI7E6FBRV/kmbG38/JnqvH1e+H8v1gs9OH7ns6vGXeziOs1mFYmpik/8C1Il7VjP4UnL9VHB0XSLnUzZ8wIqIhGACKtJ80jgJFFg1zoXwTmVt6PWQvH7l24dCQMMPf+vhokAZwiGeie2gHIHBRg6pKRUC/7y0lTXIc/FHWj5ak16T+dta1KrB/r5D8r7auA+rywWTT1+t+ju09WTmHKn8wY8EsrrJOOxvNoK0c4DgW+1In+prJk9cwPgKWKRjwvmGNs8vk1Kj16zrGv6Kfis5guTyPthtvDSQ6MtEEcJhExKK92/1SRsrxOmyamt0pd2qu8RfmqMK5NbspEmclctw9NK3icb0E
 xBREZoox
 tfJbbqvGIfUwOAwI45BiFDUnus66nGST1bMgq0CimdCTCEi1/e7dXGtEwiwwbWs9PlyGVwOu29Vo8+S7EAgmQmQMJm31kAiSY20WAf+Rpogw2f2xN8K70VEx45g17xCmmIhLnjd1KrtPiYsV6RrJd9v0xAtU8ZULpQWI3Ac7QiuYWMNx8v7kPuEbrx/0je7Nle9ylQ9Tfm2LkGvcOpw7OfEqY1BdFuQFkaiNy0SQCMe9Jnt/aao5bSnmcpeihNuTCDEb8QgUDlSF2ggory8iT/d3XXiXI2+MNZw10cYEEFbKU1hOKn9OKXCXJtr1ixVz1bXxz1FZdobuP2s7y8ddbRRAVnCup8xNLuRwh+yFD4gGczVQDSZH6w6uZW2krZr6+db23ObyPjD6WwRHVHZEDe5zbOu+xbjGCLakxEzc/iQJfO+RGrE5CadWA8VtMtxYTKGY7MToaWeXDcq6k8qjC+1GkOo+SgWXMIa2UABZZcYPyPjt/IJP5CVDWFQOJouPtLxOAfQIErQw1tvy/Ff0Oc50++cHC2VxSrX2qZZAsjjXDsBwKtJ4AVKqaL6QUxNYHOnR6i7lk6FO7IE19jeNzi6nSWj3FfWAFXxmDRNaIrN/LCkp4/jWdlpZWbRkkBk282cDbzlgH0B2H+VvDyiHXl6xo07l5wo/Vfy076vSfTzsBTlR8/BDU1r3Tw53/+D6IdrCGBGRuP5cIvoNLSpfK/AQbTtVBVUVQrCK7qAFFbjJFzjx6h+Jljikcd6I7guF+DKtdGTZ4yPHJBaMz8zR0JifKPALBm7HCUslECY8Jc6+ctXxDrbaA8ARRs0+R+cmXRvVQzT2c8nqLgyC3LpIyia9LoNl8HYrGcjzrNV0mPZHT6lWpEeB3O0F9PWtLJh2tcyjNu1CKEXxmy8DPZCzBXZHqGoqErTEWrIIR6XK/3UYIz1EKJ7hWKZR9tmJZUTcM9wSYRK2qqpvy9KDGEdfGOTsVK38s
 OlX5HlKj
 HEXXkxi5Opnm7gEpdlxrsMTAaPjukBz0oVmOfTrSq2ROp324ZA3KY00yZR16KzOL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

memcontrol.c includes <trace/events/vmscan.h> but does not use any of
the tracepoints or macros it defines: all tracepoints invoked here come
from memcg.h and writeback.h.  Removing the include still compiles
cleanly.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/memcontrol.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index aad0498a7bd6..95c2322d4a6f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -77,8 +77,6 @@
 #include <trace/events/memcg.h>
 #undef CREATE_TRACE_POINTS
 
-#include <trace/events/vmscan.h>
-
 struct cgroup_subsys memory_cgrp_subsys __read_mostly;
 EXPORT_SYMBOL(memory_cgrp_subsys);
 
-- 
2.34.1


