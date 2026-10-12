Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D03ACA9ED2
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 20:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B90116B0095; Mon, 12 Oct 2026 16:55:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B670C6B0096; Mon, 12 Oct 2026 16:55:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A55DC6B0098; Mon, 12 Oct 2026 16:55:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B5AE6B0095
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 16:55:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 91C0B1C48BE
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:55:13 +0000 (UTC)
X-FDA: 85315179306.05.9109E43
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf07.hostedemail.com (Postfix) with ESMTP id AA74340006
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:55:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=I1aQKKrr;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf07.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791838511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zoshf0ayjIN/zktQbCOgmhPRix1kYVIFgS6hIX67uLk=;
	b=zKeILFCxWHWFeDCdTdjeTkMNC8EF4aLpjg3m9xhLI87PJzCX/lb+0K/fPk52IPoOP7VMbk
	yzyn4PhxRc0hO0a944Szp3aiCbQF/jVACuK/nIsAymniBSSabzlEvqI8TjuhrdZLBBfu3D
	T2cytcp7FqZeqUu7UMcqAv7H8AaD82M=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=I1aQKKrr;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf07.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791838511;
	b=HlwIVXCN9PPENz3K/1f10BPhHHRciMMLiIOasIZ9Y/ueoBx+MEUVJwi+Yq8ciExK8NFsoq
	i9WIfV+kB9mlBEnjEmMpSApXPslVvq+Abu/u7BYjRcB8ZcWi7MOqPPfLwtwS8g2PQGQ0R8
	wSgQibsErAiGibTvCYAJhLngAC01+qU=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48b042c0759so1713986f8f.2
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1791838510; x=1792443310; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zoshf0ayjIN/zktQbCOgmhPRix1kYVIFgS6hIX67uLk=;
        b=I1aQKKrrAsbUp+O5ltVLRQ+m9Ai35i3EKuoOSZ3tiFA3Lw9nuWuv0YEvvhnTovuIhI
         bc0fKcsFyZs9LkPfcFrgj4ChhN9dRCF3DW2MvlQvAh1Rke1GPyMQbnmlKwPMPlbBxWCA
         Iq+WkJVOEKcZILj3NTAAz+jDJad8E/a51W4boNIOTRoRAKti+xM++OIZ1PRjiGMdcB/L
         XTPKfNlTh0HWImw57Hs2dfHkJA8go0iz2PuYIOojV0KpvXtHfgPHDGV5cpxR20x2dpND
         3o05gFBV51jnt1bRFTKWIMIxQwzpTMgVLvH9h7TAnfZ7fyW9HosSyjgG0bfzo8IcPDtK
         EDCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791838510; x=1792443310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zoshf0ayjIN/zktQbCOgmhPRix1kYVIFgS6hIX67uLk=;
        b=wNWdtsNTN+7F+a1TTwH+rkXD4VEg9W0i3a3v9PUyPF90gBP7yHZi9oHc90+nUYNCPf
         l/+ejGKPniFR1u07porldT+jc/eJNN80bo4Xx7neinDd+tOTzP7HEdVPX0MtNj++5Gru
         m3BPb8CVgKntiMGmlX38MlW3DINI1zCi29Kt0AEn9b5dM25kS/d1qeU8mj/86Hln0o+6
         JolTnf5SxmY9sEwmncG6anFZ9SZ/fYAnb3E3VFFYAmuTjKZS8/5uyXnaFS4Z85Qh8ycR
         WTi0UKB6jgDgtvC76LmhZuDHektjnJnrqbpN8sOhfS5SvThRlSE1YUiITKH2k962FFLK
         VQ2A==
X-Forwarded-Encrypted: i=1; AKwUvBwp7F8nM+uyihGBH+AmW7c7V+GqOEonD4MBIhiXb6aBvrpqyJ8ybaHa/l/jva6YqdavWg1plg8dDg==@kvack.org
X-Gm-Message-State: AFq9FYIA1UiSnhzqRyS8Zy4NxjHIdDcuYzTzB/mfgWVKNMdLXUbC50Ch
	2Dzm+1d1sclWrxBBdHQP9h/uMRe0sb5eSyxEu2I7PnDlMW3uFTDiiknXG7UVi/fuwiljAH4R8kP
	maKtgkXU=
X-Gm-Gg: AYBFou0HYvWd91kemZsNTDpUzE7UOikTS8wtXSGxS+pw9mpTOlEp3TUfCM5mo1/PNlc
	/FpBkU7E9d+Z1bZQkYKLSC15/HptDGr/NFi4dfDjjbIWbEg9TcNxYOEchJouQRhmRlNQI+tiSqj
	TOL29VDFRESJv7AhWgzR7Di2WZHbdu7tJBTyg/6+iLA89vy9B0rM8KDchocGJM/8H8dtytychns
	uh3zDJMWfCbbtZZDIxlR4NwGE14ZoVtD4aCSWjXV5Vh5z17oEDHnBatK9lQmEocmUhMTFbTpQhL
	WoMtLYR5F/GBJelbEdj36lCqEg1uFA42cfpOJo1tf+t319FukGwlhx5vRTLeJI7mVL9RXyylZxw
	IdWU1jHR9i1wmZDTXkfvDTmJCec/UBivUia6580ikdVkj/xts2ilchhDSdsGC3jgBFbprRMOvOi
	3WfHrNJk2lpldOowTaS+aeCoKBgu9PC9PQA4HhvjN9YJMsnTHfT1+GMx1HI6XUBGruRb7gaV6YY
	rEVE5UN3NHmkl+KIAYNMjD+kdG5SKmaTlem2fls+bMaNr8ysFvkCEBs0nNiLaIc4KpBV7a0GHk=
X-Received: by 2002:adf:ed50:0:b0:48c:7caa:12cd with SMTP id ffacd0b85a97d-48dbaae379dmr12995250f8f.22.1791838510474;
        Mon, 12 Oct 2026 13:55:10 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f04b700023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f04:b700:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0514ab1sm1895744f8f.0.2026.10.12.13.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 13:55:10 -0700 (PDT)
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
Subject: [PATCH 4/5] mm/mglru: avoid redundant rotations of young memcgs
Date: Mon, 12 Oct 2026 22:54:46 +0200
Message-ID: <20261012205447.2717801-5-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261012205447.2717801-1-max.kellermann@ionos.com>
References: <20261012205447.2717801-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AA74340006
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: koqn9k7wfaomrwsiho1dmeewdcc63gxk
X-HE-Tag: 1791838511-828760
X-HE-Meta: U2FsdGVkX19pGwJbXv+vVVV4b9O/e129h5HS8Lp13+H/xb3d2AeoSg07iM9FEIoiiCvIc14ocOah5Lv3del9GXIXapy46sZ05lDrOLTrN60HE1czhrwI6HDOx8mtO1sSgPg5iHB5WaEHUIVaWV3FaTdj1vp9In3IYldXRfxdmeXfnoXOGUxu6MbsUvt4wwF1dv58Zzq37mUrHLnG1WHY3DazJX2kfAOlEOsjH02pxrbPNQiQY+twmXECyEfMKBMgCxHaFkqPjD20vsWpeZ76A61M1YhBK3s/bdW3rowpYfjVpm//iNvcOmX6AAMGDKjGbSpRIMp0hyKKi/9LVTgmC2cPZoYwl1W4ivPh0GIwQczkYPjJr8NtrAhcIHtY4s2t4m/EpdNQ38aqO0gfvHXg/nlh9pZudqjSjz82aihWBHbb0VKeKTpdWmOvV/WxhY9oDov7X6hSnU77ZjzlpXkMSX5bYJWlBan0NdeVa6thCRNGX3fh0IxnOlKYjZhTtWJ4ThvCLdX9zZuFFYCRwdkVVHCZOB8Tv11dV5muVpbCyORZa5NvN4tRQEkbfBwjDn8kqt3dxZMT5YsE3YI7GgVTMts1ZTg50b5c2URctzW3TGS4sXjbBvYAonz5P/U4IJJA9PP6kyL0mke/iles/Ov7ylX47F8k8M1YqRKmcIBGqaImtLHnqn0dZfW40S5KSQ1lf+MkKrGb4SXIyjpM/W0Og+x83bWE4hSHL3fyCvXRc0O79H1JD8IbdXPeW9ElUcxNZC76P5InREptO8r5Jb7RXRHyeObpdlNjcYgNtPxLkDjuLQbVj/XiPTZ2PYyFu2EHCBlL8izxOofUMYLEQY5pm32mBZYbvKbIzkpvBalwZljRwiaz7Db5PNKTb1lu9CG36gUIpmT6oYsAW+wGEjMdILJvkV/FOu/L4X1SevQst4yJ/vHJRbn3SsB30IeHrUvuF4/yL+qlwI3zHVnQ54s
 CdstSDDe
 3OejoQIseiGb8doJZZewabXXT6jvSSsMep+PpTYTHETzteTEUFds8Tpnep5pW4PWY7pKhbJq11/MjLFdBrm7+Xji6e7SQocUCywT89dOW3VDxoZS2kAeDJie/MigXB1SZphAZ/zUV9wANrl4bqQN/kQD+rEWVfpWWsm4rxHzDkfPxnQa2bTndB2TPmESvcM0QZEh1+4HTtZV2wdM/dnatb29CjEApO+pDDCgegL9sZyFUjBSBGdKcnuBioKC+WcKHWTgdJYnCSXcjYcxFlOTGvo7DFJWbKqsapO71wG1nqQ15oMy0dC275T5ry+Y8ys2W0eYB1xmy49vC8OU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
index 69976df5d537..922c59eb9629 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4445,6 +4445,14 @@ static void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
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
 
@@ -4458,6 +4466,7 @@ static void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
 	if (!pgdat->memcg_lru.nr_memcgs[old] && old == get_memcg_gen(pgdat->memcg_lru.seq))
 		WRITE_ONCE(pgdat->memcg_lru.seq, pgdat->memcg_lru.seq + 1);
 
+unlock:
 	spin_unlock_irqrestore(&pgdat->memcg_lru.lock, flags);
 }
 
-- 
2.47.3


