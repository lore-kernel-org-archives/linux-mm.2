Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1258ACA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 06:23:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E1856B0088; Mon,  5 Oct 2026 02:23:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 192276B008C; Mon,  5 Oct 2026 02:23:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A99F6B0092; Mon,  5 Oct 2026 02:23:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D8DEE6B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 02:23:03 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5464EC0155
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:23:03 +0000 (UTC)
X-FDA: 85287579846.23.B63B591
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id 423FE120007
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:23:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QkWeSL6h;
	spf=pass (imf29.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791181380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sK5flBSyUz9JPc2AauHO028it+gKWcI0pXP1AO189cA=;
	b=on3vzylH43v/3zctDyWxL4g1zV3jxtsI/y5VRG+IbWJYuV32ETlUjsuAzXtKdZ0r7jVwo1
	4hfePwUf75QJkAnNwuR6PXr7XPgsRG4nT7bla6qiX5DEXeoBEDzSB/VAPkvnwk3CimnaSA
	6z+P3oMNg4pH6gnZmlIm1JdjYcFDQP0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791181380;
	b=IYZ5Ky/YOQRpQy/fOs5nmksu6U1kbLi6C1vFk1I7hqTeyBv2kXjmsKp0eCHmbgXu3UarrD
	IpIMZA7F6eRNKvaIliCGlvIO9/024B9Hx4fTWaftKd3eWXGYtrzJ8P9K1YUD/Kx09oQYPP
	iCkwo3as4u6SMGQsz/9AVyb5a4mxkw8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QkWeSL6h;
	spf=pass (imf29.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cbee846deecso1020153a12.1
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 23:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791181379; x=1791786179; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sK5flBSyUz9JPc2AauHO028it+gKWcI0pXP1AO189cA=;
        b=QkWeSL6hy6yY83caq+7frqHFDarPv06OMcyurw0wu+65NT1kQSm9K53TDTXcrFyxIl
         vVdQa4phM5SipcYQPb/SNALQVNyDLqafBIfrGZFCjOUKYADQOZXG771BOxKLawJ/0uhM
         4FTi/B++8DkIA/PR7miPFO0Oq0BzeVQUi1hYjPDKNlto9TOOz9rrx5S8C+GvUToyshAd
         YXmkn/tVuR6sFp++DyNODTwnBFCbSOwG8NbCzpGyxGm3MqaOz73+kE8DUYHc9U9IJQyJ
         9mo9kk7BKfKYXF5ASm/GphEtoZKSKXVDdxziJp4M/Yz41zqB2cxDpqpodhVzoaiGLYf0
         S1gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791181379; x=1791786179;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sK5flBSyUz9JPc2AauHO028it+gKWcI0pXP1AO189cA=;
        b=WigO+xCxPOooutzj5X8EvkkIZorGjCzMY35EE9IGi4nxtHN9bx2Yy/7PVyvaQvEqTm
         2ca3gi0xPgl0A5+cxsruJkAm7e+kQa5niSRV8Oox8ofkIl3urdVB4zZev9P+euxYjKvd
         qQ1uqFoEcyUJ6ppzyiw1a+mblf8ZG3Lu4VcCB7C9bevSediDdK5ui6GvA1+KHuGB3oIP
         M+3pJNITBYpPhziW3QozlxdUj2qmk70wCv3Ak09jT5B+hbHWP6Vpm5PQSWD3Ca8yk15f
         GFozOoQ4zu6cVkmJUDNc8frc3riJymyFqFx9XdkfP0nFN0k+an4lVAvuj+tYUVbemNBY
         l9fQ==
X-Gm-Message-State: AFq9FYJImlXZKF/78eV05+4THhPXeuwDTLLLIQxemVWuAy2YTBUe6dJm
	UvHgOExH7k0xbWb7kdnAtlMZbg32Lcoe8EWk+7kHcPYPzuODY1tMupO7
X-Gm-Gg: AYBFou16zmQde0ySbsrduYdiDoCqwIcXRgvkQ+rmh+LwrzgdMfX8Ppwh9suTLu4rW9R
	vMPZrvO0eaPEqTSH88LfRaZVhwW3FttNQfXreng5V+gl4vqa/spA37HyyB6aQ+GKDQyov2dXrZd
	APZ0M2i4dXdo7dRZIw4Ntidmta5t3LZymw5orLp2yNo3Cvh5cReB1DQ5IqjgPUW4babkQEa+ZDQ
	2ae3tOK6RaAKskeec4inbfTQq404oxtOHTGwD4j/wVauOdwsAW+AvBPHOOTcUML6wqWLKkKfnBp
	uAEPK0XrztxN0EQP8P9NOeA+459w59t4V31Kf/FZyerhh1JMUJ4qoRJpJdaUG4AgdAnsnM3VQOq
	yCS6VjNxf/ngH526byeIxolmOGdJpmqiQWLsWqvjBiCpoA6JdpRZt72/DrNTtfvvv0IF73ICNNl
	MwXZg/FxavWbGO0NJBQkYHptm582lRLyflJlVLcrjwUNkQyYA4JNwsimCMj//AsLnjBKXwGXYFC
	jeDhkmOF9mR3g==
X-Received: by 2002:a17:90b:2f0e:b0:3a8:1cc6:c8e0 with SMTP id 98e67ed59e1d1-3a81cc6c99amr788163a91.6.1791181379004;
        Sun, 04 Oct 2026 23:22:59 -0700 (PDT)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a78e4a1bfesm10661197a91.12.2026.10.04.23.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 23:22:58 -0700 (PDT)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	ljs@kernel.org,
	roman.gushchin@linux.dev,
	dave@stgolabs.net
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH] mm: vmscan: don't count per-node proactive reclaim as memory pressure
Date: Mon,  5 Oct 2026 14:22:36 +0800
Message-ID: <20261005062236.564210-1-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 423FE120007
X-Stat-Signature: iwenahstrsejyc3z6fz5qzfezdnfroum
X-Rspam-User: 
X-HE-Tag: 1791181380-686734
X-HE-Meta: U2FsdGVkX1+1p2OyVec7Hi0emeJGAe7p5zYyQFeu6AldH3Esx4oF/6huVupCuLz6dt8kZR8i+LbVuED3bujUkSLSemrkAuVGf2eYOk7FOmOP5I+5KPp2RAh1l+1nJAMna9P1Pfc6sWRTNy0jCeJgW1CyUpJsMO0nBEgrEr/qWa7OI7vOl5+UPLsAV5AYftn7H4FyfOTMI0Sn+AVKfDSXTN1MH7olr6GChNW8s/Ld5MYXr72RAliy8fGdIIbT7RGlgAX6n1DievzZExhR/kMGHM9SrJeL68xnjLFv4Gel9I0kL5sSiYEXahDrZtt4SZqRa+dmXD5XSQHMsYWumuZ/ATFMmslGkU5ZpudKh/jY+uuPCElMoJ+ZpVrjteJKRESd/nTPFxvRiFrURYpFu4ixpGOd3JkFMtHxaSfZng7Wx+kE5FD5+WfMyY6kf0cLaFEDS7OWM+GYvktixHpQD06Kv+34grBoc7RW5B5jf1cO751o9J0fJYt1OD6/YWng+4E7jXRJhhSRmm1T23hhPOaEYw6ycj1bZdC38eYBN78SG71BPDmvZaPzc9WLJ9tk3im+wv9JEQrA6OL+BSeWBae7v46VtLFhoj0K4UZicCrohoWq69MUn8kqzf9kE2HSeJGhTGNhijJ39RzB7c015ATIPyyZXX6rFNY9vTYd11vDwUxDYU+tqEco27mjVMs9TLGopa81RfHi/corlMj26B+M9OJZ6rxja8Zum7PWYux70f8NGKJo2D+K/383oKCGmX2JMjKt8XfMhx6GiNVYlEdMrsiST7Ecayc7t7Fin9sBGeNr+NQvfw+cJaCE8E9wcaf+mhIvpS6kDD20KHGEJ72pmcGsxm0vRwXKPKqJI/fwPub/yvS0lWH5GpD+jvVhmrXzRnEXw8i3zXgoOQnTAFfYQyn2NuvAIfoFEUZOvfWeth95xiBsyETMWDbrDi+qnqXhDR3vmYeBadcF6NV+eZa
 cQxHHX2M
 2da33OBN9hLMFCLxmcnvsklGHSPVatao/PSl8aBnFpHS4BmDIEjc0+6GjJAh2OaKvrylauFSd2Lgv/qkROBQKRiuIJdYN8oTGdGpCIAZNpUsPFGwC47CXShB65o5b9p+ivBZJD1tkx9Ydc3Rs3ewFV99ddSdgoYjhVP/BobrTq18dgXRJWLq9CdNmz2l5T9vR8DkI4VJeTF7lfnmWabRh5kYn3fh7mf7XCcGPfmNxpx2PZ8KZgaQhLCaB45tWRRmEZkx8xRnSG1Vl8qMg/jEvkDgTVpBsBq+KC43OLaPL9FC0ZqRdyzU8R/ljkpkJjIknHt4dhRnJGPioRTAB8V6MC6lN4BXn0ebVl8bWJm/32d5WnyIdkPsoMqHKmDGEQLP1P/apEU6FFWKP63h4AvmlEtXf9ftd2dTLzYogRt0ecVH5Qv780z1Uqh77yCqAbDXLLZ9D53ZDgIIuH2DIZh66ACv8Oniq2V+vUoL2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

When the cgroup has no memory pressure at all, writing to
/sys/devices/system/nodeX/reclaim triggers proactive reclaim on
NUMA node, causing increase in the writer cgroup's memory PSI.

Due to this reclaim is performed in the context of the write(),
accounted as memory pressure on the writer, like
commit e22c6ed90aa9 ("mm: memcontrol: don't count limit-setting reclaim
as memory pressure"). This is unexpected, the phenomenon resembling
senpai will appear again.

The Documentation/ABI/stable/sysfs-devices-node documentation also
notes that "This interface is equivalent to the memcg variant."

This patch unifies the semantics of the memcg and node interfaces:
per-node proactive reclaim is no longer counted as memory pressure,
and the per-node proactive reclaim interface no longer produces
phantom pressure.

I ran demo[1] that performs per-node proactive reclaim 10000 times
in qemu, writer cgroup memory.pressure as follows:

without patch:

some avg10=31.53 avg60=13.42 avg300=3.31 total=10602985
full avg10=31.53 avg60=13.42 avg300=3.31 total=10602985

with patch:

some avg10=9.59 avg60=3.41 avg300=0.81 total=2686221
full avg10=9.59 avg60=3.41 avg300=0.81 total=2686221

[1] https://github.com/vernon2gh/app_and_module/tree/main/reclaim_node_psi

Fixes: b980077899ea ("mm: introduce per-node proactive reclaim interface")
Cc: stable@vger.kernel.org
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 mm/vmscan.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 91295070ca33..8e22b8a6038b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7988,13 +7988,10 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat,
 {
 	struct task_struct *p = current;
 	unsigned int noreclaim_flag;
-	unsigned long pflags;
 
 	trace_mm_vmscan_node_reclaim_begin(pgdat->node_id, sc->order,
 					   sc->gfp_mask);
 
-	cond_resched();
-	psi_memstall_enter(&pflags);
 	delayacct_freepages_start();
 	fs_reclaim_acquire(sc->gfp_mask);
 	/*
@@ -8011,7 +8008,6 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat,
 	memalloc_noreclaim_restore(noreclaim_flag);
 	fs_reclaim_release(sc->gfp_mask);
 	delayacct_freepages_end();
-	psi_memstall_leave(&pflags);
 
 	trace_mm_vmscan_node_reclaim_end(sc->nr_reclaimed, NULL);
 
@@ -8021,6 +8017,7 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat,
 unsigned long node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
 {
 	unsigned long ret;
+	unsigned long pflags;
 	/* Minimum pages needed in order to stay on node */
 	const unsigned long nr_pages = 1 << order;
 	struct scan_control sc = {
@@ -8067,7 +8064,10 @@ unsigned long node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned i
 	if (test_and_set_bit_lock(PGDAT_RECLAIM_LOCKED, &pgdat->flags))
 		return 0;
 
+	cond_resched();
+	psi_memstall_enter(&pflags);
 	ret = __node_reclaim(pgdat, nr_pages, &sc);
+	psi_memstall_leave(&pflags);
 	clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
 
 	if (ret >= nr_pages)
@@ -8193,6 +8193,7 @@ int user_proactive_reclaim(char *buf,
 						  &pgdat->flags))
 				return -EBUSY;
 
+			cond_resched();
 			reclaimed = __node_reclaim(pgdat, batch_size, &sc);
 			clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
 		}
-- 
2.53.0


