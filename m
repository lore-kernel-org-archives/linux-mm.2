Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DE8D606A323
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 20:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=EdhwE9XU
Received: by kanga.kvack.org (Postfix)
	id 794586B05B2; Mon, 26 Oct 2026 16:23:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71E246B05B3; Mon, 26 Oct 2026 16:23:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E5BE6B05B4; Mon, 26 Oct 2026 16:23:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 304866B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:23:49 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 565118085F
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:23:48 +0000 (UTC)
X-FDA: 85365903336.28.AC63529
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7B86E140007
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:23:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EdhwE9XU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of sidchintamaneni@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=sidchintamaneni@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793046226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4SfCadshulzmWwMSEHX3O0JUS5+ZbgbXXvQmUot4Mpc=;
	b=V4Jo0dLvw/QuuFnIBrr9yVAIEKmcE4lWjM4zo8YhafuH19/aJj+QuEyGaQytRL5+LWeoMg
	TPQMGp2E4Pl3wgjYqrdL7o0Md2TEX4meeYK3tTx8XRFOJVOhnkEDtUhobANLcVjG8jb8Ci
	o9nSac2RNH+2KWnxkPjySA3bqEYzVSs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EdhwE9XU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of sidchintamaneni@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=sidchintamaneni@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793046226;
	b=ePNus+taY2Zkyl9Xspy4yhFs+GHakK1fro/fBzWKdn52jonw449lZMwovSZVeZFr7mM6dW
	X8OiR45UW1CfZKvPrmsSY3LFrkvmrywJzAPcGJXDa2PCQFLHcXdZFhXkEECIAAkTdVWI1N
	4wKSbZSSRo3omuD7a/Ye6gaZ/MYvcbE=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8a052aff9e9so2408090b3a.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793046225; x=1793651025; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4SfCadshulzmWwMSEHX3O0JUS5+ZbgbXXvQmUot4Mpc=;
        b=EdhwE9XUwDBjwmN6g5+dyJWAlcdZQAGh9isphHI5Pgt0KHfgN6gSqFFZ9bTvOQVYP+
         tDY6zGXqtcjSyq4/iMm4nRyg7wwDjYzb3M0pQvCxVVjHLmOe3OKWmm5LyI3YTTd6Eqy2
         1DRCBELoYNO8bPlnPn5HpSfo5mYu5jem4OyhhKqdMEq3jWu7UwR1ccOIT2O0jIBI3s2X
         oll8pNwWb5Y7mmYYP+tLvF9MDkMaH9mvWcZUv5a1zxQwl69fftv1qDA7B4IjSe9EqWlk
         64YRDhiE1CYjkIyJMyWWDjlPEeJF+TugyvMCt9Zf/gdW0g3w/vehFRacGk49c1YvrHcq
         Vtjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793046225; x=1793651025;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4SfCadshulzmWwMSEHX3O0JUS5+ZbgbXXvQmUot4Mpc=;
        b=MM1rvIxtxYj8WWXrciPhGb961XotXYGiZJHnbseb1iijc2oPdg2OebPfzPZoqlgEFE
         QyRwbwePMA63xPEweEJzQzWBtJOqRSiqx2vdmD/c2yiDDfx+RZMdaX3O3UbzC/O3Y3ln
         KYMvno84jPG/xexZX4sE4aTtoLx9V8CRktcDqW31x8rmUx6GM/VCRSnapmxiOhTvs3/H
         ShO3zuDJRH/nt71/f4Qo3turo9B3XfgQCbTDCsXtgsenibezy0PhgIWbBxvKt2hGRcHK
         Oh+Wnm/OnenXBJMe4eKz+XPz2QlQpCccnHtoj++ukaXfi5C/6kiaBFiOH0aEdzekZ1AU
         UTbA==
X-Forwarded-Encrypted: i=1; AKwUvBzkRlR9CpxzaK9oBKpUoBqNsNmR6kt2t/DIK8iUs4QhYqYg6+Lhd3KiyHtPn82ZcgCPOIPZHNot4w==@kvack.org
X-Gm-Message-State: AFq9FYJeQmHsl7TMqZ/W8KUdUnKUKacgY7s2Xz1hrM/UXT7BAPMF2E0q
	XGI4uwYxFhyzHv+JfJb7KRDSaxr4Cdx10SHppyUn2BVOdUQt7slUZ/m2
X-Gm-Gg: AYBFou0wvZ52esfpQ1pYdTIeyzlFISHSDosz8lfSEYbQGHI713Im3mPk77aBITo/BLE
	uL1MG4ZYPFJsR1BW/QLTJRNP314YnlvNHJUZi7yRBCvBOCI13z20EzZScS7xo+MN7gf1Qt61M0r
	KOLQHgguh9sgy+rF9IqUDENX6uDg0jd+U5gT/6tr6eHNVyaGOj/pnyoLPZ2cbTNvLQVOtm61vdV
	aAu2tPsoTAAs2IZ5JlgefAJxQYI+u2kWNFO70AIttRlIPMJw+x0q0qR2DTQznajXiIVuyGi5KOD
	2xTP5PHKBCIDFmfuhtbvJJR1NHdh/F2+nHS6xhmRWULh46KSEFaNNFO0ld/RdrvEamgE22+LoTv
	wTkEW3dD/BCvfyBtIgVSNt6ZHwIYz5gQHgE/ZyMppWtwAIIdZot7Hm3a8Pzy9opE7c6Y9e/HTJH
	kU5y00T1ZQv0qsdcJv63KGfOqOtXtKZju5itivshvOhkuId61ly29zTqymoocSzgXDH3/HGKa5+
	Lbac7InRLEU4NxQNrm+QpJojFznutiANALe+WFLPLC7diP16jM2yGMIGXuPQDRAZ6L+NfK6J9N/
	WUXdbGNoGdF9RUVT5gIXi9SjbbvZYn7at0hqF4CIk2WUWi5f6bHI5wZnMtL9YiMMskUJSw/Htw3
	7xMk7sDXEcXftKLCztWStGu52+8pXZ/sl3DXD7EiTobsnRmX6gEYFPZVt/wIkiigakqk/96hLvF
	3io6/f9h3NK5OVtctLEjc180CwfN0L2BYV6Y3dyY2W
X-Received: by 2002:a05:6a00:4b0b:b0:880:ee58:2768 with SMTP id d2e1a72fcca58-8a367a39859mr6737619b3a.56.1793046225106;
        Mon, 26 Oct 2026 13:23:45 -0700 (PDT)
Received: from sid-dev-env.cgrhrlrrq2nuffriizdlnb1x4b.xx.internal.cloudapp.net ([4.155.54.158])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a36bb29546sm1627846b3a.33.2026.10.26.13.23.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 13:23:43 -0700 (PDT)
From: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org
Cc: david@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	yuzhao@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	apais@microsoft.com,
	rlmenge@gmail.com,
	Siddharth Chintamaneni <sidchintamaneni@gmail.com>,
	Hardik Garg <hargar@linux.microsoft.com>
Subject: [PATCH v2 1/2] mm: multi-gen LRU: use mem_cgroup_lruvec() in get_lruvec()
Date: Mon, 26 Oct 2026 20:23:12 +0000
Message-ID: <20261026202313.63122-2-sidchintamaneni@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261026202313.63122-1-sidchintamaneni@gmail.com>
References: <20261026202313.63122-1-sidchintamaneni@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7B86E140007
X-Stat-Signature: wsy99xtzckwanr4j7zn439wth8bqt4g4
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793046226-830870
X-HE-Meta: U2FsdGVkX1/3CBTslxYoqojTifGP7FjU1wyM2lIUagF9AxvWftS4R7menRhWOw1kztfeoCSfnphcE9a4l8AL4ps+RTI1CbFeD+lJNlWx6Qc2CtUinuFRdUNFjkyoqCnj6pFWm11KWEiVbx9FclCFl+HEmQyDeRiNnAD9tFyRreYQLk3yWO0us5Ys7zNbJfPpkvL09TmtlOWCKIlkuPqcLgUJwuGgalVTkmWJq287PWkBuDyWF+BEmVWsCGi/pg7n9M3nog79QUoY50zq0VYFSl87FeIYclqoXFFyuyfbKawNabXFQe3pk3iCg/8reIwx6+PFBuu8+C89eG1wmXZOLvrqvAWYbKIr+hfT9sSggIajsouvfTWmYWAZY/KQYJHst4D+tkZuTFjRz7fr5xPQ7yg3GyNxDMJp5XTL3ka1uof3kV5gcZM2/cIT711udNp2VrWJP7A1xokVuybFNbkjapxweKYCDKGW+i1TGIKLG+YPQc4xcw0O7Rcd37RwqStonPc+wSujJJN4Ww9DRQ3i4GROlg6d7mDMJjitZKjL+ABjbkeSh+Ylf/aAB1zUzK3MovFbgEuO49F4QFFHNSzsgUQgdHkcurUo8cWvPb8bBoMHm/Xr18H6xfR6nYLCQK1c66wLV1aBRhfRqLwlPtQmaV03IsuZY9G2y/rmSsxj0ZBmWJ3PH1kbxnLOGyYx5xxPdTflzIBHNBeqZauaVNMumur3ZCT6Z94JtjDZIzL8PhlV+DamMcQSwHnxM6e3TUq5uKxZKqxzc/xyXceM7Rdrc1ssNbGvf7thB8j3nDGPiXOH7MVqyeE7Eu1wLLJs6WekzlvU8lzR13T0OWtfFCUzB0M5LHInzGC3rdjZYRWTcf2kUBEqUjdS7Y6l4jawDn1NzHd7CiOwEgTjqovhYONPqWdl1nqgfAAAeI23qsI2MPbndVNYnuo4qnXICPZxIfLoXwDfbUwZ7qwiZPaWJ2E
 a60P+fvz
 2qWp6O0nxwvyxc+WJ4WGF6LjI5gP6I7UzMKFZzdjblPjWEgxpbU7g24Q+lvYWNzaQeBbf/LA4KB6O6wqx+piPA99e1g/IlsyDGRn/FsMe8K4wh8PcoqB0QFdVfMsefXk1EN661TxafIfEkyjkYmuTYrn7b7A1329Y1uKDV2EA92G13qed7BeCPcKwY1v85iqUdfsARWgJ4TJGWb3ac9xckSUNu4tMQIa0TbtM4oXuFqMupuim5eOrx6NnXOsQZPJC7VuemDu2JJmXI0fY9LGS3D4PEM86zhfQWr4JrsobRvGh+9J/vTncIdG91w2Cr0fuury9FSFlp/1cdVB6ZzjToyC65zviDN4heS5ZUU7hGn4WBO/hmL0jqxE8ye1ftydX6m8hRj5sw1t7SCPmhyDnRXpPdrWFEWoKEQFQjKFOE/SDDfOHELIIvEbQTJ2mQAK0xUwDJg21O4G+Kf+z0gFIieLK9G4oJbjdu7YMOQTkWbdKK3OJj9MXeacRmbXPi308y4Mg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Andrew Morton noted that get_lruvec() has the same pattern as
lru_gen_shrink_node(): when memcg is disabled on the command line
(cgroup_disable=memory), it returns &pgdat->__lruvec directly instead of
going through mem_cgroup_lruvec(), which initializes lruvec->pgdat.

In practice all callers of get_lruvec() run after kswapd_init() has
already initialized pgdat->__lruvec.pgdat on every N_MEMORY node, so
this is not a runtime bug. Have get_lruvec() delegate to
mem_cgroup_lruvec() directly.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Signed-off-by: Hardik Garg <hargar@linux.microsoft.com>
---
 mm/vmscan.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0c57e4f1eb15..99e9f07fa2e1 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2745,20 +2745,9 @@ static struct lruvec *get_lruvec(struct mem_cgroup *memcg, int nid)
 {
 	struct pglist_data *pgdat = NODE_DATA(nid);
 
-#ifdef CONFIG_MEMCG
-	if (memcg) {
-		struct lruvec *lruvec = &memcg->nodeinfo[nid]->lruvec;
-
-		/* see the comment in mem_cgroup_lruvec() */
-		if (!lruvec->pgdat)
-			lruvec->pgdat = pgdat;
-
-		return lruvec;
-	}
-#endif
-	VM_WARN_ON_ONCE(!mem_cgroup_disabled());
+	VM_WARN_ON_ONCE(!memcg && !mem_cgroup_disabled());
 
-	return &pgdat->__lruvec;
+	return mem_cgroup_lruvec(memcg, pgdat);
 }
 
 static int get_swappiness(struct lruvec *lruvec, struct scan_control *sc)
-- 
2.45.4


