Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7DB1606A329
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 16:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=bXa/NaSc
Received: by kanga.kvack.org (Postfix)
	id EDF796B052A; Tue, 20 Oct 2026 12:56:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8FF96B052B; Tue, 20 Oct 2026 12:56:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA5DA6B052C; Tue, 20 Oct 2026 12:56:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B0F316B052A
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 12:56:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3E36C1C28D7
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 16:56:31 +0000 (UTC)
X-FDA: 85343608182.08.6A4E0C5
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf25.hostedemail.com (Postfix) with ESMTP id 81AE4A0005
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 16:56:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="bXa/NaSc";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792515389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lJA6tKVLSd/rks8VATU4AwzUzgulNjgUJQKYEzoQbI0=;
	b=g0fHYDfT1OhYyrNS+EXHr+TBEt0tUhaZ2lP7A8QKrFTP7RuBvnZXcO7fUBwmUSnaAi+5RK
	8b/BWO4B+CA5dHG5krtEanuu2E/MOTe6R8gN3by6HKbaQtJQYtPjBoTAn4WGuI90cvRkuD
	ShM0hOIFbA1nY46ChheG+uc4KsTiLFg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="bXa/NaSc";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792515389;
	b=ytyDmL4QNCai8djBiAb5q5yM4x5hSenc3XspOqm/0HXWSj06/ECCM2WtpHnUsD/RUWeZPW
	ivzPxA3B1qmODHNTD4igGUnDHX3fhssGvUpPrS/fSCIOMFQUXJ8m+znajqAaxMtIF9BlWs
	iQvWrNcKvnfGzH7zQhwHALo0KbAsop0=
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-8b10ac6ab7bso17490187b3.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792515388; x=1793120188; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lJA6tKVLSd/rks8VATU4AwzUzgulNjgUJQKYEzoQbI0=;
        b=bXa/NaSc3b6YSNeDIy374iGYXSPz3mf63LYdV25vpTHQuaQIVY6iynOzq8X0NZo4OU
         1FCK6AICtYMrbWbC5MKpgTbXVn7XEMALAPBqnTYLKgr/2xYN2fcOEdXfuMmMx8tCQ/I2
         94ncBfMhAZKUNCsRrJJE1mfGWZX7LDNOO9zyOznGW0g5qpgtz+R/qwBPkWTuw2vzTMDE
         hfeMHYmbkd0OvqL4YiCFL9R8PnGvPezlHrReOO/hizD5Oos7Hn0WS7mbAW/HtHE6lse9
         skY1c+s9iVLv1EMTteIIN1zujMX3aAFiCIcWfNqY+pjIUJN4ku7mlkPJtkZJ3IX6CCcA
         6qDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792515388; x=1793120188;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lJA6tKVLSd/rks8VATU4AwzUzgulNjgUJQKYEzoQbI0=;
        b=kSup2KjPofs5ue7T5q32aoeEwOtO717sj82bGlHMf5qquDdcUFBXorKHgBVJpBAArL
         oSh5O3GAQX6QX/sVb61SxVAIiQKOxdjpwhsCbKuHz5XqDZNKKODlWleU6YTs8HrzBWfM
         lcOhzGy2E6wnlIP9H3y5adRVCa+mmqfH83UDIYgrLoT1iJdSPvnnbf/WTTWb/ay4toy9
         XwiC3T/k95gRKwqUL8q/yVskutWJD5jlfnZ/j9H+goE03N7eYCeV6yIXskIWkS8z3Omo
         8O3/nUcP5nW86WDTjlo4GHX4iOE5cWDa+dzXX9VgoejiKwLD+6qGYVv0h5DARVnjjrku
         nxsw==
X-Forwarded-Encrypted: i=1; AKwUvByMSU9VcFMAzDu4Dn3sVcDxawNpZUiiJrmcXFbq+LwM9x6U4vmaX8CnDxOGPhHAUhpY2A0uybiOng==@kvack.org
X-Gm-Message-State: AFq9FYKu0qsJz7reYFUIAbEufHUNReubbZ3aW5xX5LTnL4mQPu93B9r6
	DwrgY2yPbgYmW5PzkHH8yPp0iiHQJ6Xxf18n2Zv/ft2mrJxbaV++Zd1X
X-Gm-Gg: AYBFou157mS29B5d08I58zxWC1DOd6mxnexR9NmuC+rvIBuqWcMpW/u/C82YlyDGbBJ
	twwQo76G2pvp/ctVLczGWKDczbesY6FMTj8e86jFcxlvxYiTvd2RniO7tozbZo5T7O+YPmI1kWF
	3RYM+OjSAKvKdmrpifHF3FZ4Qj0T1GSzknsqTSaPFwQsB1nk0JDr9bCR9t5wCIDwSxTHj0u0zpU
	80nlX7MBVNLHzWtmAX4c5jpFLJTflwWpsOMbMbDiID2tM6rY6FB/avThUvv7fm2SCRV6lPgX8wx
	lWkRDuCL00xaXtSrqAKDxVWQLqXSy6AoUtA2rb6edyFOVa38/ieAkPipjAVMmZCZqpnBxykQ1VO
	WLOYFdzFSKKeLKrXVMT4rE8bQOZ1Lg3gpGk7cmYy8K4F+8APD9ItfhPU885mWTecXwmwPeEZrWs
	Q9wkYTyok2DNsj7lmi9MV1ZEeybWpkzxrziRxeB+n7sPGQ5UnjA0MZYxAIIFTXouzkw9VBt5VyH
	DIX3s+TQlxOaRdyUsrxGRIkGfug
X-Received: by 2002:a05:690c:888:b0:873:17c9:b054 with SMTP id 00721157ae682-8b0f21690aemr36925147b3.21.1792515388537;
        Tue, 20 Oct 2026 09:56:28 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:8::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b1300715cfsm549777b3.14.2026.10.20.09.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 09:56:28 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH] mm/memcontrol: publish null pointer before dropping css reference
Date: Tue, 20 Oct 2026 09:56:26 -0700
Message-ID: <20261020165627.1599959-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 81AE4A0005
X-Stat-Signature: bb33ktyg5udzwwq7wqy8mth49dcrnk6w
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792515389-919127
X-HE-Meta: U2FsdGVkX18gEvVGWoQzrYiBXBOLqf0fIQIZGGJ4nukCfAQYMRlLJURHtDwhoFNtLylTp1G8GmAUgnLn2iVrSGfJKJJKuqjcoYrrZnRckB3qa5EirxXLpD5QaksbCFxeWEYjW+FEgvcuk0kdj9mNetC7F7XWm6tS2TaeQp3tpf8Iuvp57bHevYofB/VusEk3PVt2ufzoCr8Wo8RkPmjxaJ5dQ1ETffHrGwWz4O1WbDCvyBpwMERRVWqP2R+AX8TW4cNX8HiRmdk+VLAYpmgTJGTDZwV0QTlmVp3oZ4rXvZZTvCl1C0lwxlKg1kNKvSsIsFuC5iyzFTMV/AgkVgF2Eg+svUWmmWGktwAB2TFxHSgazzQevuhiMLbcgWFM3/JF9iQvj6fy5QgbJnCPSwVuTPeemncA/b2VfMnn0nUGpNWOFvldQkJgup3QSRSzycmewI7JzYzdyHeRC9diWie8zS58AfJ17hmyjY7CHIdPD9/OGOXEqn+aXxeKlX/fFdNaxvogut9r71PCKSbbvJ2j2NTx1iQuBJh2osDWTBkYFZ5MPWtoqBLQFCM1vFOxQz1MKP6hwLbvEtTk0FI/05n1Xgvcp1sQQTbua/itvPlKFjuvDJrIgz/bcnH7aymbwV2qWRcyFL2DZoqEp2aeqIU+XcN7IIZWqnfCblAFCH/jGZoj/MkmiMkVOl8w48bBq8c5CxWXD6sgYJv4MaZ1+13GVlATnEmOGPyhPxg/WIsxlKdq5NlKqT3QAm9DXshw18kSPZZRZAIlbho59wNl4zv0/9xPwCSBySBoanf6kLT4VCEtNd5Zmtqkbz50knj6MIBDN5U4wOh3Ex7YRMYUXWgr20V7OWNW9IbMM5oSw6ogrr2MnhGj9zotoyDpMaOmReQ69WHMxh0xvMbsi80Vs5oWle3GsWfX4MenyiT29pUre7h+hVRq5fCAwMqUOWcIheYqt6u1L4vaCmPmmuRmKoB
 8JVkXg2Z
 V4BDKUQUn6i3Pr7zFCXBsBTJwCy0IPtz/WkB/+cq5MZWCA6a7EPvf3HFgB14j3Wq5xLzcIa6ZtzyF969LE88A96KuEvUWQZ87LWpYfjudJzl4qKHIvjgA+qCDZ0gpw+SxmC4oZY0utNamAMEj9wvA9ttqG+4sSqxelv1a79r2Y8NZzIyIRqjtQSdffEXcY8eRAZ5f0m8no7exdeMX8MApG1F9j7n0nhjbeLZYNw+r28J99KERoVjVVP9kBZ+lAGx75Js6eDO7iAzL4BjoqSFk+07SmZHtWm9V0VogVBRbtLIhpV0/N9ubZwdF7FULq1pdTnR/5i3k0PCBE9fOP6BmsJtfWYgLdlaUHvRznodm5Tj0IDS+JEFl0X1DDZytWoYx8nvKAhlBIl1nm12TQjRx6tTlmYOrBi4MRa5qTYybxGAccozywRILvA7x3AyLVgvaPZ6KSpy7kp16U8QFwm4CarWfV0uv9hVbMeKTo+Q6Q/edDA5sGU1mroqxOC3P32xi5iEJQqnm8V+zytPTwUnrbhYC+GAdJ+MAUNbe9MNxI0Mqsz6y0G60/GrQhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

struct memcg_stock_pcp hold references to cgroups that it tracks to make
sure that the memcg never gets freed with unaccounted charges still
living in the stock. The cached stock can be cleared either via
drain_stock() or consume_stock(), which drop the reference if the
stock goes to 0, and then clears the pointer from the stock.

If that was the last reference, the memcg is freed after an RCU grace
period, but this can happen while the pointer still points to the
to-be-freed memcg. Then a reader that enters its read-side critical
section after the grace period has started is not waited for, and then
can dereference it after the memcg gets freed.

In practice, this is very rare and I have not been able to reproduce
the issue in my own testing.

Switch the order of the reference drop and the publishing so that
we first publish the NULL pointer, then drop the reference.

This is based on a report from Sashiko, who found this pre-existing
issue in my page_counter_stock series [1].

[1] https://sashiko.dev/#/patchset/20260928192349.3432886-1-joshua.hahnjy%40gmail.com

Fixes: e1a366be5cb4 ("mm: memcontrol: switch to rcu protection in drain_all_stock()")
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e7d7db5718f9a..a05d9a8baa1b6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2172,8 +2172,8 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 			stock_pages -= nr_pages;
 			WRITE_ONCE(stock->nr_pages[i], stock_pages);
 			if (!stock_pages) {
-				css_put(&memcg->css);
 				WRITE_ONCE(stock->cached[i], NULL);
+				css_put(&memcg->css);
 			}
 			ret = true;
 		}
@@ -2209,8 +2209,8 @@ static void drain_stock(struct memcg_stock_pcp *stock, int i)
 		WRITE_ONCE(stock->nr_pages[i], 0);
 	}
 
-	css_put(&old->css);
 	WRITE_ONCE(stock->cached[i], NULL);
+	css_put(&old->css);
 }
 
 static void drain_stock_fully(struct memcg_stock_pcp *stock)
-- 
2.53.0-Meta


