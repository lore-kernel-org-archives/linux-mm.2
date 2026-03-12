Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E89C105A586
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 11:25:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D97F6B008A; Thu, 12 Mar 2026 07:25:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 860136B0093; Thu, 12 Mar 2026 07:25:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59E9F6B008C; Thu, 12 Mar 2026 07:25:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1FB926B008A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 07:25:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B425B1392C3
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:25:19 +0000 (UTC)
X-FDA: 84537179958.26.A9C6196
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9DEEA140010
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:25:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773314718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=7GPNlNSJdtR0FCYj29rhVZvDnzpGL+o4cM/ALmIlXVk=;
	b=MPYPgFxWqO9khOhenEcYVv1GroLeRibg+e/07yu2pNT865h5Bg/t+HlJStmnwPwQyMOBy2
	Fb+qmdtMT7i295Rwct3JP+tBiw/fZes5KW52svCJDFKlD7/0dpOUcThCD5GbsokHN0bZVL
	+xi/bbm33SOdnEZxT/0iiQh9eekHsN4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773314718; a=rsa-sha256;
	cv=none;
	b=vX3UDrkR7MO6NJnlZ8WQW53pasD/ID/1jWCJ2Yiibd0aAiLsyfqrw8bEa1nPHJ986JI0/B
	tetqPv8I0o22m98LQotC7P2j4oqafsiDcU5CFBgT2vcWlZVgk4UfRn76mTJdf1ldymFpgj
	uDwd3piH1tADU67eTojZEVqyBRylD+0=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 12 Mar 2026 20:25:13 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: rafael@kernel.org,
	akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	pavel@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	usama.arif@linux.dev,
	linux-pm@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RESEND RFC PATCH v3 0/2] mm/swap, PM: hibernate: fix swapoff race and optimize swap reference
Date: Thu, 12 Mar 2026 20:25:09 +0900
Message-Id: <20260312112511.3596781-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9DEEA140010
X-Stat-Signature: iq5g47iykfnkf99dbfsipw17zthuahou
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773314716-443699
X-HE-Meta: U2FsdGVkX192TsYnIodxNXd/Rrrt49MYuVWIN2kcnRcdjiFr2CQm07JmmYAQGMLdUjhLNfiML0X6Zs8M73OdVlhBnpDexsYaHO7G1MiFBojoEzOsUvUG2uT2mMPqeyqx++AowC0rCtGbGBXMITUmnLnMhHhRROFDDUWA64JZMgS7HrLTLVjQDGYAi09mQJEQAUpPN3gWbZ4L7xIJpqS1tqe0NL50qfhXqLcZtLPIcOEX7+TpYcH5QvAupxHphss0Vn8n1C5WmpLcl5GDLiU7a6RDWTLYI1nmab53jpvsydc5hEaf/UMt9j+dEb3rEBx4rg8EBN5UUmbEF2M5b4kOGK+RU4dgo9QGJGqYPrQSa3xXiiTTNVTw6RM6IyAsbc15a6s54/8zWim7CCzUemcYYS5+OGGPE4dwaTkIXa80l5lsy9R7pn2MysaH6RUrtNsmkpd32oTrQSaCSLYd4Hp+0miNqCEG/9q9r4/XP5LM3tAs+X7ptlUCGw0wUPw8SvQU78cRUxPvwdqSv7qYLpEzjxfXx6iWdUBobwSVwWehGUUlaK6jxjy+yGoMvOlxaUjrHg8P/nqhfndIDZeFLVXdOgADc8Y0PgDxOrsu/+H1iesdmIbr6ro5DXBY2+rIWPY0QyJ6okyzBYngihbDJ+Cr0WFB17KvZNGB8GrvdqCKDzzMOZ2Nigw/CzXCJPWBkT31tlI0Mm8WvrhHkskt8TQiGmjHTXofgnv8VuZaHvOA6cAokzVa7pYH9R2GcuQ1FjkdotJthl+Hda727AaBI7YlFjq/+94/FyQ55GOsHuvjBWd/on5VgEhgRNULrbfVHIc39Lxe1jOCU1hp1cheo708U5HogrW6LhSOuw76WoO2M+icnyt6q6KD5Wi+3ZgtwsFq6pw7EthZjxaYhmh5Lq4lMupstwDrtxWrnN4oQidqFCmHqwgG/VRtaI8C0wMrD2+zGOC4cdEvJMNXzHhNJqQ
 mmDifzhs
 TXrnaT7YjOfwmb3pekTj6aorPjOW0gFUS2egk5YmyTTHefv9l3y4zRBByaX/U2z1n06lnms+w7+nnPqFOvl/zv4faYycTKvID/6maVsifhcUmYV2+igMJDN5rWZNPRtlFa4swGfeN0BbP+fW8orXXDSKRguCHeqHMpmMQEtyd1zESEXySl8JUgn9ACQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, in the uswsusp path, only the swap type value is retrieved at         
lookup time without holding a reference. If swapoff races after the type         
is acquired, subsequent slot allocations operate on a stale swap device.         

Additionally, grabbing and releasing the swap device reference on every          
slot allocation is inefficient across the entire hibernation swap path.          

This patch series addresses these issues:                                        
- Patch 1: Fixes the swapoff race in uswsusp by holding the swap device          
  reference from the point the swap device is looked up.                         
- Patch 2: Removes the overhead of per-slot reference counting in alloc/free     
  paths and cleans up the redundant SWP_WRITEOK check.

While this approach seems reasonable and has passed basic testing, 
I am not entirely familiar with the snapshot codebase. 
Therefore, I am submitting this as an RFC to gather your feedback. 
I plan to update it to a formal patch series based on the comments received.
                                                                                
Changelog:                                                                       
rfc v2 -> rfc v3:
 - Split the single patch into 2 patches (Patch 1: race issue, Patch 2:
   reference optimization) per Chris Li's feedback.          
 - Addressed Chris Li's concern regarding the complexity of releasing
   references on error paths in normal hibernation. Since normal hibernation
   freezes processes (making swapoff impossible), it no longer holds the     
   reference at all. Instead, uswsusp explicitly acquires the reference,        
   simplifying the overall fix.         
 - Removed the SWP_WRITEOK check before allocation, as it is already
   handled during cluster allocation.             
 - Rebased the patch series onto f543926f9d0c3f6dfb354adfe7fbaeedd1277c6b.
 - Change the RFC title and modify commit.        

rfc v1 -> rfc v2:
 - Squashed previous commits into a single patch per Usama Arif's feedback
   regarding git bisectability.       

Links:                                                                           
RFC v1: https://lore.kernel.org/linux-mm/20260305202413.1888499-1-usama.arif@linux.dev/T/#m3693d45180f14f441b6951984f4b4bfd90ec0c9d
RFC v2: https://lore.kernel.org/linux-mm/20260306024608.1720991-1-youngjun.park@lge.com/

Thanks,                                                                          
Youngjun Park

Youngjun Park (2):
  mm/swap, PM: hibernate: fix swapoff race in uswsusp by getting swap
    reference
  mm/swap: remove redundant swap device reference in alloc/free

 include/linux/swap.h |  3 +-
 kernel/power/swap.c  |  2 +-
 kernel/power/user.c  | 11 +++++--
 mm/swapfile.c        | 78 +++++++++++++++++++++++---------------------
 4 files changed, 52 insertions(+), 42 deletions(-)

-- 
base-commit: f543926f9d0c3f6dfb354adfe7fbaeedd1277c6b (mm-new)

2.34.1


