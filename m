Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A3B7606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 14:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jAfwxev4
Received: by kanga.kvack.org (Postfix)
	id 6C6ED6B05C6; Mon, 23 Nov 2026 09:18:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69E5D6B05C7; Mon, 23 Nov 2026 09:18:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DC806B05C8; Mon, 23 Nov 2026 09:18:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 325D46B05C6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:18:21 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BAF5CA0915
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:18:20 +0000 (UTC)
X-FDA: 85466588760.25.37DE649
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	by imf23.hostedemail.com (Postfix) with ESMTP id D6FE0140005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:18:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=jAfwxev4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795443499;
	b=LJomwl3e+a1rvbXHE3QLy5fnTvbTRguayBFLJPjbM0sgS9lssRWePQJSnHCKWiwTA1gHDG
	EsVgQ5jIwSA3R/O0hTMW3Fq9F56iynw3vpl9mtKAt8bblNIS6rea8NGbAQr38oABPHdI07
	sp72WWs3ePT/4jQv/2XqdjJjiY/br6M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795443499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wZPzpBpjg0sp41buwUabT4ELftt8au76u2ycWcMBhOA=;
	b=ETbTLfJ1ZrJD1Uf1kYHUQ59A3S2M8Os1NrFsfRP7GBRIleSqPmaMC9PI+C9e3iH+C0A0pg
	nBUgiizcJwE7mxhcJnox26k9MTnKOJ3BaZqMJLYa72zom3Ou4kp2FbBLmxfrzHqSCQeHoz
	tbmqSlm65GdAntrpvqTSoM07o+gKMTc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=jAfwxev4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-1b3acec6677so4680175c88.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:18:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795443498; x=1796048298; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wZPzpBpjg0sp41buwUabT4ELftt8au76u2ycWcMBhOA=;
        b=jAfwxev4wEJVu82vEJy88Xb52jmelo/Kv3D8nRiEWKf5V07bkkWliLS1ag+eEWDFvp
         EBn8y4Nr5/7zU4vYwv7LY3IUI0u5GCD4pT4Ns3D6UZks3+Q4zUMvdBpKFvdeIkhX3lZ3
         VXwKZTBpbLkFcuSmM1gpBbPUI3Qk3BGqNdqSGUfi0aSKbwXWdKHTNarigWrvM3Dyed5w
         pWEwWWtCzgxdzh34mqabxVp6bcMhDd0Ay0bMzegyNdqX8mfsMf0Opjl08W67XTGmp4RK
         nIBomygPLFi7G/vBgdoU4Lk5m1yBg9uUNlX/dYGzoJ6y/CJmalETwrVRAIrzT+9TUaWz
         Dh7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795443498; x=1796048298;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wZPzpBpjg0sp41buwUabT4ELftt8au76u2ycWcMBhOA=;
        b=LtWrFcBSiOsds8hz+PkjX9XjefPCY8ghy30p7bBiQ6hWsbL2TOcpS0t8C1DuZ1oY3x
         ILMJCMSyYVPxuyC1HZ85ePoIPve0KIGx+pSg4zR/tcU8U17bmuB0F2OsTyiv6Epzns89
         o3GrB0kGoTKqeB906UtUIp168Gq9zYRBk0ZkBfCXDGZeycHyYBI5mLZTkk8LlQ69Yrzu
         nd5OILGXXWBIAppgeb+2PPsM6ZGBYHJlJYgkZev60dxqVVwNe6ZRgIN5QnGH+gXkItrt
         kpffg+2n24VVp2PaRPMCbxd92nwsv+Sara0eJ7pZ2DzSBJb+52ZGHBYVf4hnVkLp81Zh
         82Qw==
X-Gm-Message-State: APuU4Z+h0Bj/rGnNAXXTQ3gfn3aWbqMTKkzMevmkkyMPJoa7ctHH+Muy
	yKJQ81ouJmd7O8opAD7Up10mSsIDQTHUFQ6nqZ2iGvTLpFSnE5Hwn21Lhf6Gl/u0
X-Gm-Gg: AZFdTZdxkKbkQmkyuLz+9fm7cBBnx1pzf3GYAF4LryTp9D9Qs8RLpf/jFpXHbUBuhfl
	sMwbcfUnkTvzP8+/EGTPht3Uf8BoNBjWCenaMpfBl3Zi1SMVOtmAN/5pqWeHCNpHRdZAmWhajYS
	1NWLYh2FGGd4R/ZczQEILJ0w44BRnhfHAEZDamg8P28HxsLa2IF9LJJpUH810W7uK2xOxA8gxSe
	vcc7gKSbVKhJ3yxn57EPIm5GY1PSTGApzUwmqB9e8PBoLcsq7p+uSBNtt9hHkrX6TGTBUweGolz
	bJNpVG/IPwOUh1ILEzbd0/wDH47pcCFXly9JBYUIj7G3Hm0eBmGuz5cSfgMpFZ1Ly78Fc7nNT1x
	wBBcOFnSrxRXmLMWnjlMPf1n/MXF9eA+vkEBRBl8PcEJGIQ2/mFYrzVeSbAxixDjo46ptDJt+AD
	e0mbOs0NLUsYmf9Va/AXhvZsnnHgmNcj/Lte2Ss3TDE6At9/DCBbfKoPcF9zhkjlTsPTHIYgzue
	cigy8M4zlyI7tVrmE323mZz6g6fjDgflSMGwvETz1PZWoWaFNno3e05u93x8T6f+oxtU97dJVGH
	HxkuuORb9uJ3uej4EB88uM0WhvWvNootZiz6fp4QlTkHDc1acx+dm/0AxiNNClnK8c2zoZqg2vM
	nzJgO0qSymvYtT70=
X-Received: by 2002:a05:7022:f509:b0:1b2:41af:c21c with SMTP id a92af1059eb24-1b55694689amr10214838c88.39.1795443496157;
        Mon, 23 Nov 2026 06:18:16 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5569bffd2sm26797807c88.0.2026.11.23.06.18.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 06:18:15 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH v5 09/19] mm/swap: avoid direct reclaim when populating swap cluster metadata
Date: Mon, 23 Nov 2026 22:18:03 +0800
Message-ID: <e920cffdb3a65905dbcf51fa3520785a8c49fcb4.1795439990.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1795439990.git.lianux.mm@gmail.com>
References: <cover.1795439990.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D6FE0140005
X-Rspam-User:
X-Stat-Signature: 7p56jh6tywgqfsxtxxftnb3jbhkq4i9n
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795443498-668736
X-HE-Meta: U2FsdGVkX19WBwAKzh5BfyTdk3RFpiGpeHv7gzjg9KZbAtOoYD0VJPrFAk2RRLjjtLAvQzA95coTKkFroNqm8mXyv4PxllvYeSPtgyqA71w/M2zWkp8s4eB2X1kQ2x4SqdZYTXk6ZGI2N68Q9DnykxF8qAjck0j3jNLKfpL5vE6np0REkTaNAKSN4RQOME2XGklwCasgDM2GiYV+5BKw4BdkCWVQfbwJxFVRxUiIcu0+0HgS1mKDlC4F/FxYbWo+w7m/2lboJwlZfYwEtYTHEZk+2L+X3nTSRtjnY/din0dckF5JDr1RdzN20dzH2Wl6sAuF4gyejrGnVenGLGukd1SKHidxU3cBzFh/3RnHiCXyTPzslmL3FGCy6mn7uvtv6STu3mXQkXxEjc1vOyURH9mg7YbLgXagldrGH8LTiknNEQp4pgiBCCj1am8jSZ1Esy09VZz3/ysmP7g3Ox98oWOZ9LZDiFYHXO1P9ZV5FA3g/O4CuIJ/6lv82+jkhtiNjWV7sxlZoWXPQviZdlvrTdp6IhQDmCokpSjPQb3LyN8Ch/mnvpj58V+3x8eYYYXX6MIvg6vX/OYB9H0o9hcCghsFnprFzWuNZF2us2CEDJObn9etxGt6kGeenVGWhCiwk9F0hE6xRTp6U1Wc+tTPtsE1yWpbUpgLfwpZqP95XBu57IbODh7QqHx+BWWiSryvkKpKfY5Ogs7dtgbR1QPP3jIKnEWyWtqgcd+Ly43kJOFmEtFQwyBKiSt9O0FZyEl/vT5p0q+6w+n3me1KJHNJ4bxKM2Iv724Hxc47G+5AjDR2CsKAx33RI+88Vni7tfnQz6U+CXjAMzFa9URmejBINTDB1NlZYnn7KAdeNQmFQ/bAzFwZOk3ngED2iuGS65ryzy9gHu9z9HvlMY3XMvVGjdv6DCqnrmCLBJxcByZRwFaaZ1GVyt9aoa71eDF7oj1nKH0Emo4BaKsklMGx47V
 DndaUkrd
 BuorUu8HDf83QQXpUTfyArOYua001SwqYmzL/343Cwh/mJRR908rPiDh6vfDqGKbvE6f5kvMpsLlU1tovcSp9ep78RA2jCfbIV+Naw874VzC/mMCuddPuNzLP4I9Jjmet88Z06Ggh2R4LLD0Y8rwo782UmpaCxNhlP1t/cINFrFvr00INMUixmOUqG21jeELif+7Mk6+1O7icMNT4/T2lbcKVp2HIDfXlm3UQ9n8HSKrV6290KB2OsmfKN1C+hCpUj0ezqd6Kkn4HNvMiQyVjVoTw1DVJZVCNDMg/C1FUHy+zLT/4hvfGq2HWcSLJcEyXBE3UJwQbeKxJh+bwexe3yDVEeh1/jfsvJ/KyD1psg5/YkS7g2nZ+PxkchttuGjraJyuqUUbykyHVJ5M/zSx++9ujt1++XZ/4osMQpJOFXyffDpDYWKFXJacJGHriz2+CeM0MoVx6vtCsquuRkiubvFPkSBWl0FourJe5/vkqEgmOAn3KPkOBZMDA2rkFSNc25/vO4ZsPJegFKqTNwUUnGmrSXYPTLi84NAsDdkWKmq9WZEfoMVaOzkdAGdfB7B7nUoqO/9uNjtpkSCur4V0R3NBVqT3tmYRNnoH9Rw3byqfNZUDGg8aESg5wlPRyFScxN/YkVS66GZJJ5dOfbbN0V2Z+I4X1giwd+bpX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Swap cluster population is entered from swap allocation and may itself
need memory for slot metadata. Its fallback drops the device and cluster
locks before allocating with GFP_KERNEL, which can reenter swap
allocation through direct reclaim.

Make this allocation boundary explicitly non-reclaiming so callers can
retain outer synchronization without a recursive swap allocation.
Clear __GFP_DIRECT_RECLAIM from the fallback request while retaining
__GFP_HIGH and __GFP_NOMEMALLOC. The retry can still wake kswapd, but
fails without direct reclaim when memory is unavailable.

This can make metadata allocation fail earlier under memory pressure.
Keep the existing isolated-cluster rollback and restrict this request
without adding a task-wide PF_MEMALLOC scope.

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/swapfile.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index cd2cb360f274..70913402a265 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -586,13 +586,14 @@ static void swap_cluster_assert_empty(struct swap_cluster_info *ci,
 }
 
 /*
- * Allocate swap table for one cluster. Attempt an atomic allocation first,
- * then fallback to sleeping allocation.
+ * Allocate swap table for one cluster. Attempt allocation under the locks
+ * first, then retry with the locks dropped without entering direct reclaim.
  */
 static struct swap_cluster_info *
 swap_cluster_populate(struct swap_info_struct *si,
 			 struct swap_cluster_info *ci)
 {
+	gfp_t gfp;
 	int ret;
 
 	/*
@@ -610,9 +611,11 @@ swap_cluster_populate(struct swap_info_struct *si,
 		return ci;
 
 	/*
-	 * Try a sleep allocation. Each isolated free cluster may cause
-	 * a sleep allocation, but there is a limited number of them, so
-	 * the potential recursive allocation is limited.
+	 * Drop the device and cluster locks before retrying. Metadata allocation
+	 * must not recurse into swap allocation through direct reclaim: callers
+	 * can retain outer synchronization across cluster population. Restrict
+	 * this request instead of granting the task PF_MEMALLOC, which could
+	 * give allocator hooks and failure cleanup reserve access.
 	 */
 	spin_unlock(&ci->lock);
 	if (si->flags & SWP_SOLIDSTATE)
@@ -620,8 +623,9 @@ swap_cluster_populate(struct swap_info_struct *si,
 	else
 		spin_unlock(&si->global_cluster->lock);
 
-	ret = swap_cluster_alloc_table(si, ci, __GFP_HIGH | __GFP_NOMEMALLOC |
-					     GFP_KERNEL, false);
+	gfp = (GFP_KERNEL | __GFP_HIGH | __GFP_NOMEMALLOC) &
+		~__GFP_DIRECT_RECLAIM;
+	ret = swap_cluster_alloc_table(si, ci, gfp, false);
 
 	/*
 	 * Back to atomic context. We might have migrated to a new CPU with a
@@ -3160,9 +3164,8 @@ static int swap_device_disable(struct address_space *mapping,
 		return err;
 
 	/*
-	 * The swap allocator doesn't take swapon_rwsem. Looping through every
-	 * cluster lock after clearing SWP_WRITEOK ensures that allocators see
-	 * the updated flag and that no allocation remains in flight.
+	 * Drain cluster-lock users after clearing SWP_WRITEOK, so swapoff
+	 * does not race with operations that started before the transition.
 	 */
 	for (offset = 0; offset < end; offset += SWAPFILE_CLUSTER) {
 		ci = swap_cluster_lock(si, offset);

