Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 099CB606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 13:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=OGbIpYBL
Received: by kanga.kvack.org (Postfix)
	id BA04A6B05C6; Mon, 23 Nov 2026 08:52:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B782B6B05C7; Mon, 23 Nov 2026 08:52:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3F306B05C8; Mon, 23 Nov 2026 08:52:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7501E6B05C6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:52:12 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E74811408AC
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:52:11 +0000 (UTC)
X-FDA: 85466522862.08.63E2903
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1742C20004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:52:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=OGbIpYBL;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf03.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795441930;
	b=B0IYGsn3+eyctW+SbXbA35NPjTaw4pJ+PVTieloxn9yJ7wKDQxLSHXCWV3S7uivi2tJJFZ
	U1ptV1NYzZkf2xlDn0madtRwL9PCld48H+8n+HUsQHbhcGaWBnD+IVUCjaWO7GeN0xeUGO
	/FWAQ8+erVLUPU70KAXszrko+3WoGOA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795441930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EG/Oikx8PiqldF2Yo+sswkzJPWoRKLQTCOHC1uaRhQA=;
	b=16SVI4NtyVqbOCiXQF8fk4aNNx00eSOFypWiwubSCj39E64bDgWL48hmWb9QxsZ66AOrdo
	4BQTsoytLjpWBJCKSiA5pMu8EZkFiiQX8ZZxxhOLp+3maqEEEc6qPxXhfLXOfhVKXaSkF0
	18zUhmvLUTEIE5tgjKSiwHjKawS6Li4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=OGbIpYBL;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf03.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4bb70074ab2so34171175e9.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:52:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1795441929; x=1796046729; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EG/Oikx8PiqldF2Yo+sswkzJPWoRKLQTCOHC1uaRhQA=;
        b=OGbIpYBLTwOsxeLS5+INC/EfWyViN5uTwZuahTKQTpqDcgBPTgqkEJKaameBpOBK3y
         pDsCgp+pjhZdOmKki18HzQx4GG1khCxjj2ESBSmlalt8BtfOgGc2mWYrknRGmsAbDdpw
         VlpsYmQo9GonAhZzMiY1VuKslpauBMUxbsgIuyTFD1sTpq3g7/rg3ZQf2wSfp7Dm4Rnl
         WKxP1fzZpoLbtSvuC2NVtYQv3Lddv1fECUEYAu5ZoLo/kyICgQFN6YQXkURmMi1Pp464
         mcTxE7pp7To5U/8uQ77JZMc2GQXH8Q9E0jceI09cyaY++pfHihikjN4ZJn2t83YO/S8c
         o5CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795441929; x=1796046729;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EG/Oikx8PiqldF2Yo+sswkzJPWoRKLQTCOHC1uaRhQA=;
        b=LNPXHDgKho45e9UG9om4pcc5YNSUpf4HUBLrDNDji8G6iNJQk9D2+bp2TEoCQmnmXF
         sY+YYaBIMWho5qnx+H7YvpzvM7Y1Zh7xY5Hl5IfUsVFtB4TnkLsojYYzrc3pojxro1DK
         e0/0NRJqAcg1Bs5Z9EoFZIBIo++dYdl+lf0imhvp5CS8xmcIHh18hd2PBj4Z9ZhUOagl
         nvuO/obxx1rCMpN4mIzCS9dtVukJIg+9FkRLqV6sepU1bOYiEsx7XeQ40KnL1GovSJMn
         8iDr1GE02DvdNTTsJWOPTlZsrsPJh9yMTk6OVeVDdbSeM3prSNLgxstLUkmk9h4QHO6X
         N7YQ==
X-Forwarded-Encrypted: i=1; AL+hErGWEBgfydmpD+xBcl9Nk+nizcthZO9c7peyAMswMHUADPXzXk1g4lszQuwqj22BSLIKjk7XSTAiCQ==@kvack.org
X-Gm-Message-State: APuU4Z8K3I9AkIBDuW/eMm9gB7srbqipu8oQxVT5bM+lx9AsLj0M9EF5
	JUgU9BhNFvPSrlXcKqYpPsMA71rPwuPt/AX9vuqP4XTX4cb6oMgTt7Yk1z0ylgyE0yA=
X-Gm-Gg: AZFdTZdRxLULx90OgesJKpDjg7JxDSg/h2F59pW8BfFm7PxfZDp0UMXK+hWsBv1oVDW
	94RjX+NvLAJEALRHUUk1qnr29AfbSQ6j28xOfvxLw48jJfzKPzq0eUUmYmFXdnPdr4buaVc9+sj
	Nn27TDPD7eu2vjEvTizEYiR+6i8ZSlGabj0p8bMb4t2V0VO/D/7ODjukJxEtmtGxzm8G0ag/8mo
	2TNPP2HzZDpBcWNSrIBerhzuPnSFhjye0cHUk9RNTEy/LztAvrswXpOGhD1eoEqqiNuJE917dE8
	RWBXs+I+jO7uI1tBPwvFZlpa6tQFui6hJF8zLcBS1gARVQEK5K2epbTgfdAkVmtkDJq1L7mWjSD
	NHc2smIC+16gJToywAfCNI97dlJPuoHWJz2pqcfvzqTgYwUyMzLTAtENOxmZ67E2nGcKpEtkHQm
	U+31iXCqGxgPTAC0H03MQ9SZUB9aFQIEwZ0uXjqn4tZZRdRr8SCnkg1tKWlBUuZTtsDzD5JbTSu
	hZYRWInWdFGYspcHC+GtP7YGbkHAWyCz102tQbcgM36AAl9GcBjb8kYzBR710dbdNWcdTwTcqMt
	RqfvpOGYFiPi4vUOdacqqMpOQX1WJWivdQLH6rEBC3DDL86IlWovAiC0prHLb4rX+DInE3L5L42
	spbPzCz3vYlMAYIKcIGqlbL3HzS8htKs=
X-Received: by 2002:a05:600c:4e87:b0:4a3:59c9:a758 with SMTP id 5b1f17b1804b1-4bb88922c81mr242428605e9.32.1795441928731;
        Mon, 23 Nov 2026 05:52:08 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f1b7800023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1b:7800:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906817ccsm169279215e9.5.2026.11.23.05.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 05:52:08 -0800 (PST)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rcu@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v4 4/5] mm/mglru: avoid redundant rotations of young memcgs
Date: Mon, 23 Nov 2026 14:51:59 +0100
Message-ID: <20261123135200.4086519-5-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261123135200.4086519-1-max.kellermann@ionos.com>
References: <20261123135200.4086519-1-max.kellermann@ionos.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y4owsfhuekec6qppxw1aq8tbai9gdx5z
X-Rspamd-Queue-Id: 1742C20004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795441929-600230
X-HE-Meta: U2FsdGVkX193xMgNNT1OI2GcOpRXsZQ91/18UIJVhn2q/PqA8uDGImmDjS8Or9/0enGICVgrQZI0SA7KQETG01VtPTooQOyxtNgKiJ3umk6bdM+AnTpuo8J1JSGhrTuNzOzbDSf2ahVkucZtEB/IdPc/nPF2itJY31SFeP9gvUYlOj/8Qyaaw0CLceOYmlxLE38QbxQewVpOmnFjyKtprjF6Kf9wOQaBO4qgCw4Icar6gjSPZqMMpUC6i34q/KezCqXYmJtJbwZXzZo9IEgAvYqlSn0Z8PjePQsTXo+OMdEBhavf1OxZsIwhQsZO3qXgk5P5hO9tfWP3ITPpfIW7UUq1tj6QPCZF8DKUMcfPI/AYE+mHp6SNZwQx8lUlbR5tcYPgDB23gnPyT/RZ457ZJ3w7e3mkMkxyhM+IhI/jMD6XtXJVcfDsmvV+wnPFEYbA8yawGR4Cx0Zug/E8n1H7mD1J+ODlhhw0rWHICoOwpoG+X1jCJX6gQ+Y0xeYh7BNUGrNAffEGUpsQXV4RD/4XBVT/H7fwgv8joUXl8c+9FU6CJC+dU/3DwbDjV8xHuoZdZhPT5IcLWjpq3unCWKvDsq7BmtlpNVZB/a2JSDoW4W3Umd5d1cEXIKtRai6hKmfJGiDiKbzYUkjmJ6TGrBUyiY4ceRlzlhIq84UFtUCADXcuFrwxEbqlzQdaxRJs5Dc8ILQwMgtCPVK5kCcEeJejZr6GL6kUeLSoZ0fm+/wp2xVK/OTrviPY+b5GgmUf0lXU2hCuB5PQB5fBKuUspyGw45m+Q6X9+/2MXOBv5Ne4YVdxTbx3FnM+/OI/atEpO/WXbxcg0VYVeVuRQ2xMgPdy+qxqv6+PNNwvELNSjaAH77I97IYCYqpSScHE3Ss2gU8kIyZQNnGKoLm+5X1incLDBR3oZiRAxD//Ah9cnn05n0aKp1INZnmoQTinQAdck3fiWD/wVDrZq3Q+1qTsKJE
 Mv8hEKFG
 j9c8VdzCRr2Zv/yG+lQDkX/Q7fNcfm6UbarShG8xSZhN1qeh9BFajcxUbvLiKlh5LQHZS3TLst1Y5O9xskGc3XYuAEmEqQwegeLle9XvsHu5QOyH79x20ZY9X9IT2KnCANKPt2sAhVVrShUZSN/T7xgpzArLe9UOpBsQuSus7qrG+vYnb1P697c0yJn3Cc2J7KFuG7GFXNu2xI+BQ9wzCi5wnYV/Pz419UxNHu1VOj1UCPI8a/1ekwdANxnuV6ubFGfHThZJ+1ShAClaOLKNBHhOE6wPSB+iA44YsoPnP7p8TMYi1QKVEcaUGQUsT5iL3v4VTKwGrdmpOlRmzRbJ6iUByQ1UwFtw3GtxLMKvDjlnufcXA2JF9lV3s9Nc6MrElG9RjZ98wDzIwiAoi88zHEDrpi840g9fYYTF81NZmV8VDvkTijTXr0JhTp7nNqnzZbapGO1jPmbD2tddYImwqXSAmccJVGNyxx/C1R9+yoDB7s7IkYaSUiru3K0m6CzR3qD4KYLCpc6twlAl5eWQswyUbfgmWbLaMbzi/XRvKg+stT+jiY7vg30BDIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Concurrent reclaimers can request promotion after another reclaimer
has already moved a memcg into the young generation.  Requeueing it
into a random bin again adds list mutations without advancing the
old-generation scan.

Therefore, skip `MEMCG_LRU_YOUNG` when the memcg is already in the
default segment of the current young generation.

In my micro benchmark, this increases the request rate by 36% and
reduces the average duration of each write request by 27%.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 mm/vmscan.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 91f31b65f9f6..b9715acf2f22 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4492,6 +4492,14 @@ static void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
 	else
 		VM_WARN_ON_ONCE(true);
 
+	if (op == MEMCG_LRU_YOUNG && old == new && lruvec->lrugen.seg == seg)
+		/*
+		 * This memcg is already in the young generation and
+		 * reshuffling it again cannot help the scan of the
+		 * old generation.
+		 */
+		goto unlock;
+
 	WRITE_ONCE(lruvec->lrugen.seg, seg);
 	WRITE_ONCE(lruvec->lrugen.gen, new);
 
@@ -4504,6 +4512,7 @@ static void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
 	if (!pgdat->memcg_lru.nr_memcgs[old] && old == get_memcg_gen(pgdat->memcg_lru.seq))
 		WRITE_ONCE(pgdat->memcg_lru.seq, pgdat->memcg_lru.seq + 1);
 
+unlock:
 	spin_unlock_irqrestore(&pgdat->memcg_lru.lock, flags);
 }
 
-- 
2.53.0


