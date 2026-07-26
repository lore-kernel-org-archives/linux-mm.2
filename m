Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C143C531C9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 17:40:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCFDE6B009D; Sun, 26 Jul 2026 13:39:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9DDE6B00A2; Sun, 26 Jul 2026 13:39:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3E4B6B00A4; Sun, 26 Jul 2026 13:39:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 67B566B00A0
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 13:39:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D17A540558
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:50 +0000 (UTC)
X-FDA: 85031640540.23.D089CAC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5E0D840002
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VDMR24we;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785087589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5v3u710N58c3BJ9vFyK6txOeRAXwyATfa8JLFV4jnT8=;
	b=dw9wrk1FrDk4jPv1FZ3tciKi6otfrKlUsnd6l0GcB/GcGDLfds8i/uLdy7aJbmQXFVxfuK
	Tnyp0W+G2UjKH1JIhAjYdf3TGLBu2n+A+lSgCs7yvg/7vWmT2NeN/hy07ktVJ7XS3RcHvq
	LOSc8KS32aFU51EuNE1sgEsbKQRtIoY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VDMR24we;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785087589;
	b=GqFGwJ5VPhZC81exCaSrN8+Awiz49604/jaVkupG771giFDlAowDGP4gxDqJE2ATf5CUJN
	Ht4oOvXmryTqJUUmUjo1xvowP5ewLCzSFmZdW8OcWiFcqwYj/T0cfg/uWKSWlHdNLsEvkY
	pdj5njOc76gIx3GkNxYbVRhoup8bMzA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0746D60A6F;
	Sun, 26 Jul 2026 17:39:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D61E1F00A3F;
	Sun, 26 Jul 2026 17:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785087588;
	bh=5v3u710N58c3BJ9vFyK6txOeRAXwyATfa8JLFV4jnT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VDMR24weEPDS5GWYzlJdIQ6Od8yYpTFdlDpKGv3upAnjCAkSysFCdrGH3RUZpFWZ8
	 cwihFHXxbpAyCeTY6MPqhGXiOMqazBpjaAXoe1EhIgwp8jDmB1oOFpvHOctWkcBiOn
	 JsbE8oCQCCnpxRNF6lJV4WKCG0sJ9TZoRS+YhP0YD45Vt8c+p9361gfCM/gpAG0EIl
	 U82snu6JVmOe6eL0SP3A7cJ0MyABGP77DR3mFdH51Xh/rFCB3rT75l32T0BAl1OwHT
	 A8MUBISnhuoqvjLM5siCgBMLOakbQYyneqJ68/TRRAzx8aP7Dxp1v0Jo8gTv6nXGFn
	 4l8ZrIQB8tvxA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 13/17] mm/damon/sysfs: pass preps to DAMON core
Date: Sun, 26 Jul 2026 10:39:29 -0700
Message-ID: <20260726173935.94046-14-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260726173935.94046-1-sj@kernel.org>
References: <20260726173935.94046-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5E0D840002
X-Rspam-User: 
X-Stat-Signature: 4jnmuwznxzix6pdn1o613w193swppsrh
X-Rspamd-Server: rspam04
X-HE-Tag: 1785087589-617156
X-HE-Meta: U2FsdGVkX18EAGdAyAwOvPGADf6MKlKtC6Zd8F7+Ybh46puNmdAf4GjJlZwinwyl9j8mhEcuw9vRuAXNd5bRRKWOT9deKNnriDeuIvtb0DkGNpet3u6A5PYOrDGxy6Sk54xY7Qy/r8AiZYXEIv2BrZNNxaOEl5sUnAVORck0b4Inb0JdBpvcLEv3/n4NnwBKs86XQViff7KdJRBhrjjCFvjrv4R51qodauE6jZAm/D8h6y0MXREalGFwBi7odb+CxNeSg5aXsd5VIc+ck14i/G1iHf3pipbu82eDlxaV6ow+z3166/7+3C3P38/VT1VPbbcjGOm8IvabnznZLRwpcJ8AHNd7OaL2PYVBuesSq9QyeXzeFhaeF/ZNcCiLeskRSaxNVUtgJg9HKHftDkOyinsRR8mp2g+cyOR7LXAtx8cA0f3PgV5E9wzPJNjJiZyhja6hsN24NCjzHUObPAGlAM9OUa81u00sqe7TeqdYcqx0zJENEyNv2k2ZOkg01sjCxEep7239vqIlkgEdzbLgjX9zorPFzbLUnVE/1z9cfmmcEf91nAkKOsSCwVwK6M9JS+AF9EN7caIxW8qr7tR/x9LRBNwF2W/aZR+YzZMFIOXAps9R9XxUUijF4Bm8YEZfhvCRPIOPyHTs7S9Kbu/PYQVq2wbKCq5TmvMTe+FxtF/p4os2INBt+8Qey07Nt9ZGcJeqfW3mTnwExc989b+DOA4kf68uiZlCTyMhaNhVH3/7JlOCQVzgJ1Ony6EPiCb2FlePbEncte6eKx8/2VzJt4dwDaa8y1F7wD1Fnn9OSt3yNMEK8fZP1D3vACQVzzpaYVZamOarszcox0+fc35rmaaIfo1mlM00YsexvGwsodSK1NNI3Nd04DnOsPmuzcSoP9kcAgrdq35TJhKLVeX06yQdY3CW/GEVRkodY9aSYZngLin37k0pTmSWRhMr1A1CuAzVXBqwC52WvjntIrQ
 GIumw/KZ
 tSb+TNsB8VNG+OqkuAo4NESbC/6YWaoQCWL8YjYq4z/utR4mJikC6xYvKEFK3b9bvChjg2lA8kwWfVTYX03AObaNZWVjaWt+MK2APA0faijxkFmrlZXCurdazseux19Bs832rDOz4tgM83MBwu828vU5qERDra5kuBjcv0t5tWJyMEVYnhMwzqMS1phMzX+yClqUx4VCaLHVwaTt6LPJU1sO3n6MHJfJ9296iq47Trlnu8V4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface provides the files for setting DAMON probe preps.
But the underlying code is not really passing the user-set values to
DAMON core.  Pass those.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index f275a6f73eee1..d7a2b62322841 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2174,6 +2174,23 @@ static int damon_sysfs_set_attrs(struct damon_ctx *ctx,
 	return damon_set_attrs(ctx, &attrs);
 }
 
+static int damon_sysfs_set_preps(struct damon_probe *probe,
+		struct damon_sysfs_preps *sys_preps)
+{
+	int i;
+
+	for (i = 0; i < sys_preps->nr; i++) {
+		struct damon_sysfs_prep *sys_prep = sys_preps->preps_arr[i];
+		struct damon_prep *prep;
+
+		prep = damon_new_prep(sys_prep->action);
+		if (!prep)
+			return -ENOMEM;
+		damon_add_prep(probe, prep);
+	}
+	return 0;
+}
+
 static int damon_sysfs_set_filters(struct damon_probe *probe,
 		struct damon_sysfs_filters *sys_filters)
 {
@@ -2209,7 +2226,15 @@ static int damon_sysfs_set_probe(struct damon_probe *probe,
 		struct damon_sysfs_probe *sys_probe)
 {
 	struct damon_sysfs_filters *sys_filters;
+	struct damon_sysfs_preps *sys_preps;
+	int err;
 
+	sys_preps = sys_probe->preps;
+	if (sys_preps) {
+		err = damon_sysfs_set_preps(probe, sys_preps);
+		if (err)
+			return err;
+	}
 	sys_filters = sys_probe->filters;
 	if (!sys_filters)
 		return 0;
-- 
2.47.3

