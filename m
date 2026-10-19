Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 538FA606A33E
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 18:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=Qe6xbUfQ
Received: by kanga.kvack.org (Postfix)
	id 150926B00F9; Mon, 19 Oct 2026 14:50:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1023E6B00FA; Mon, 19 Oct 2026 14:50:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 042EE6B00FB; Mon, 19 Oct 2026 14:50:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB3766B00F9
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:50:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 703541A0827
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:50:09 +0000 (UTC)
X-FDA: 85340265738.08.F2A0631
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf03.hostedemail.com (Postfix) with ESMTP id C06CF20006
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:50:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Qe6xbUfQ;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792435807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qQajsp9ObyIZH1W2JtDu/mB6mPActDF2v9UueTjQ/T8=;
	b=FXZ5WNG3ETDT4P084ioBN9FO5GVWlQ0kVGzUmLYk3ThY1YOniRIUff8S63GMVzsRxCaOxJ
	eS3V7e+7/ax0hCBsePks3SuI04JOvvcYMlNxEuwOJYe0x2rpt+enPy4PWr/z4Qo6ZieyMO
	Hm13B7qWDBGbf+OtPzBIgR8JswQPLUs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Qe6xbUfQ;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792435807;
	b=wmPDA5hwhCZUew1HHL6egn1kFMKkoZjv8cGgTr8oI3paR/u96FpGdIbEfj5X8LbTZLtT9E
	gh93J1Xrqkullg4Ms37YUU8lJjOeHx/slJUQeUzeQ6M7VjuLnV2UQ4iVv6zMLi4ZVfFc2T
	o4wRLtTRpXICcXD8/27DHVgSa1Gbz90=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-917a707f37eso25260656d6.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792435807; x=1793040607; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qQajsp9ObyIZH1W2JtDu/mB6mPActDF2v9UueTjQ/T8=;
        b=Qe6xbUfQokjLEsv76+uyrc9OQeCkVUzEFc2IDr2K6Y+IujU0unOy/RgRet166bnYd6
         OudVaIeaHeFAIvQykcAznuhMqe98CWTsbJ7WoD/1CCpc3QU3yJPMhYx/9sFbgRHyCSUR
         8NDEItXVkkQQpjLP/bvCUlVuRu6LrGM/MJ/apJrPV1x61dawcP3tCxZon20ii9y3cKPF
         aEeLVTnfKtLHLMGGYdPA0IyPnMIvMxiBlvsqqVg5b8Ho9XooaaGRVVt7ftz7+KFXt+K+
         OQq05SVjKb95XYN42rOGJJmTLzJ0ESEzM8ZRQsW24lZizs05h/kh3rrPegP18AEp1xFS
         X1nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792435807; x=1793040607;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qQajsp9ObyIZH1W2JtDu/mB6mPActDF2v9UueTjQ/T8=;
        b=m5CcUMuDWD+PRcZwge7tXJ6XZzC54HhpKsWICZAspIsq+J8Sun3iaPAS6Lmi7IsZPU
         5Zl8hIhMw3Pgbl6/+OYIIJHXdd/v0k2EZyDHCbuSH5lZDtJzwCesH1hXwuRTuXUC2xUQ
         9wSUyjwqbs3+gFzbJVryqwmyGyXt5KwUD5+4ADDSXYG/T0bvcKI9iCv2hqiLFy4WibEv
         lZVXjuDSs7q3Bc5ITytx5bRxT0zPXgo4ig4paf4npGS+jI+L3osraK3vk21+SsmPyOTT
         OdUG32fKHp1+E8sVTJYvap8XsrjKPazjpCXOpedzH91Yjw1TusqxZEZ60Qd6Bq71u63M
         E6qw==
X-Gm-Message-State: AFq9FYLFEHXonmUMotvlm0Nx2ZB2p72wp1EbLM/ToEKMeLSJxWZVflxD
	cBbKxAv44MjVkMN3X9kqyHkuN6S5XGXuplX/kzfLSoDmrLaDlzY+woGe0fzIXbxpNQS8pfAwXQQ
	VJ/V3uVA=
X-Gm-Gg: AYBFou3WzBS39xYCIPin6n16xRAqFqgkHF+0if/RcRm6PRKO7zE0hbIJqAqlcW+vjcA
	JWmyXw4f8IR4z65zTL/m6CWgJvvnf7+wsUaJjJcYV7OnaJxcOXf+MhSOdwWxzCgRXeddcYqNJk6
	4K3v+mCaGOP5+aSvuoHkEYLQX2ozojn33WFjyCfBI9j15kuAsUgWIZE/3QkrEDiDazQGG2TJiZK
	AcBGHI8ghE+37lxeJrxKwReGA2nazIkNc9HvYZA3oaUxGJrWyPo67v1tsTanaiFuzFvx3Woo66m
	RIF11Vg9vHPBV9RU1eJDbxzqxaCU6vZN0QHvbSZr+iuB4reYtM97WK1hjBOHMryMkMyKBco4dif
	pTo9e7vyPdj+YRBCbUqyjyQtglMn/SDYGuzmSH66lEs3Knx8x2Azie3huC/eXiiRhA8f6lWvP3I
	wBBR2RI1mYQURFqO2ZIYT+VwJghajXzKA4jj66Wl6Y6zz+xlNzzhdU17epOy2r24x/QyeOTflRf
	SudDEkPBN51ROsZVBVND/4JTGs46OlNmtQ++MBPEdiMXyNj9GrKMswlEzTaMwp46v2GeykvPTBa
	rxuPCqiGSEssn2JXL9cMDx16zszHHwp8a7pvK8PQqw==
X-Received: by 2002:a05:6214:5d02:b0:917:a2ba:e478 with SMTP id 6a1803df08f44-91bdf01992dmr155941286d6.23.1792435806990;
        Mon, 19 Oct 2026 11:50:06 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c0411586csm3122706d6.44.2026.10.19.11.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 11:50:06 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	ljs@kernel.org,
	dave@stgolabs.net,
	roman.gushchin@linux.dev,
	stable@vger.kernel.org
Subject: [PATCH] mm/vmscan: reclaim every zone in per-node proactive reclaim
Date: Mon, 19 Oct 2026 14:50:02 -0400
Message-ID: <20261019185002.3428594-1-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C06CF20006
X-Stat-Signature: k9jh7hh8opsbtcjxsc5iyrnm6igym4ni
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792435807-919055
X-HE-Meta: U2FsdGVkX18sj/skyun7XSpI4U4CgO9KyzJZcfhaLHrxzdNjlxVKDOsRyUbdG/83qaWmsJ5h4ZioV2SCeY1tWLpaHyQwKjNh/W0r7IYfc2RWUX96h7/bWCmBBltpwmCt549ORGjeIjqb8SHOhl8gqkgoMGcE6teR55PirdAJ7buMrg6kwmWh8XYw4d/MV6apU5AzR0OHyRCsYJjjGNzh0/JhtFagehdnc0Hu9fxn7fIrDUQEXx/f5Vq676Ul6jyzws+Spl4titp0vdbVeE7qqBtEpDc88HuNEIMTYBQsSRkG8Naq+AGSbc0YNL9niCcakBiwbK7Gz7boanFA5GEy8vlNhBJYvz2ruMbawNgjOmmyzX5SReKWa1guC76XbqFqakYugdvGv7Sh2Axhx7um1aNGN+cd0j0MwhcaJl0IRmyZ1U58YBvEkW65fk+Zgacv9mSvJf9851OHxZ12MI6yhSHmxCy/zo7Y6GZPuKm6tMU423CCnQjWSavZXLYI7pS51/8reE/WhQfSwQeYe9mkdXU/DcZrWFig0kxHjl+iaq3Kd2KWBqZcrPR2MYxg5VnOcg/fYZuP+lE6wlFU9PrGmiOoVTJMIK+hM+oe0g4QNi9er2XSfSimNGPOKz1kMN/O96dk1FBx2rl8HuYQuPIDMdIUQKRBxmCiOohgEjiP/CjKTVudMsVwIXzyiJsuEpZy5MYRQcdfjayBmC2NuBRZMtsRPbOuYfQoCTqw0260SxqILxZTCfDoORIwMfYIXEy9pSM/mIn1soWv7JNMiJm9FIgcuPJMvUgpofirUsLcCr6gwGJa27sYFlqBtM2+lM3At9Nvct6gLJBG892gxIUkq++WIky+U7Bf7Qfl0ABPyZB9ml7fyxuoC9aOXw5+tsIHrpHNvkuHSw/Rvx+p4Pk++TocLg2rt5dw9q/FbLWOiu3YjoA6wVWSrbqUN1CY6TwGw1tAi/pizozRB9YqxCR
 Ns0JMKXZ
 aRJsO3eGYpZRpMN81wGRzk9zPDUMG1D+KXBhFF5XqkZ8PUqy1kzk4uXU7rILiBAwR/U0q8D9IruW0aG8C2E1RmnfpkFviQLeTWhT06S8HpupNZIxIz05oc6t/TeAcuFEfYzZZFhYUtUYcGL2NZaoxzJxRMlImUM7rFbBsOhpJbE1G7+VtkQhV7R1hBfcyUG9k5ZI2lBwm6QCP4UQdl1P+TAH0d0vbn1HHToz0yS51KBOwd9rW/NsBRgsF6oam4Y073RzMhncJedUTBGZq4rF4ZhYQNT8qBCupc60E0AMo7LUxiemz68AG9QqIwia4ihgzcS1Gcbpre7fAGbY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

user_proactive_reclaim() limits per-node reclaim to
gfp_zone(GFP_KERNEL), which is ZONE_NORMAL. Proactive reclaim serves no
allocation, but that limit makes shrink_node() skip every ZONE_MOVABLE
folio, so writing to /sys/devices/system/node/nodeN/reclaim never
reclaims a node's movable memory. A movable-only node, such as dax/kmem
or hotplugged memory onlined movable, reclaims nothing and fails with
-EAGAIN.

To reproduce, fill a movable-only node with clean page cache and write
200M to its nodeN/reclaim: the write fails with -EAGAIN and the page
cache stays. The same write to a ZONE_NORMAL node frees 200MB.

Scan every zone, as memory.reclaim does.

Fixes: b980077899ea4 ("mm: introduce per-node proactive reclaim interface")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index e82ba737c028d..90f7a7bf4e426 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -8180,7 +8180,7 @@ int user_proactive_reclaim(char *buf,
 		} else {
 			struct scan_control sc = {
 				.gfp_mask = current_gfp_context(gfp_mask),
-				.reclaim_idx = gfp_zone(gfp_mask),
+				.reclaim_idx = MAX_NR_ZONES - 1,
 				.proactive_swappiness = swappiness == -1 ? NULL : &swappiness,
 				.priority = DEF_PRIORITY,
 				.may_writepage = 1,
-- 
2.53.0-Meta


