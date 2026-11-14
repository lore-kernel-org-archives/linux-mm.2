Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B121606A327
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 14:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ithfdhlV
Received: by kanga.kvack.org (Postfix)
	id 1C0886B05C0; Sat, 14 Nov 2026 09:50:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1713A6B05C1; Sat, 14 Nov 2026 09:50:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 061466B05C2; Sat, 14 Nov 2026 09:50:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C4A706B05C0
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 09:50:58 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 49EA2A03E2
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:50:58 +0000 (UTC)
X-FDA: 85434011796.19.477C6FB
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf18.hostedemail.com (Postfix) with ESMTP id 797141C0005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:50:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ithfdhlV;
	spf=pass (imf18.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794667856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iDtGnnmzB8XetLwM09gGYvTUDRew+lNVR5IPpgOPUfI=;
	b=RfLH9VYEoTDvSQo1ljRnyv70liPc7diQuEgj8NUowxe3raGsA10cy72QSkyga5RIgv2iri
	Bq+pSVVixlxTbvWQCi+n6L2Q5SZ6xr7Ktco8ioRP1k4Z004T1mMCsXv/QG/6yfZO8n6LjM
	hBJmw/Rzz/lxWMO4G+hJtrlKNjTcNgQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794667856;
	b=xeHMuCDntGCmpod7qTsBuKm0VvNMv+TdU/XSgGDU2TswB/61JjUI6Dyidamt8GmWLX06Mz
	ZPNsxvqkg4IDnNX1s6rH52aSAwLHXh0PRQnFyKd/uQR5GAjCwCfXMbQm0M77TY2Ed1uMog
	Qs3nzDdiKbQfTLqFPonBYnzoTRKbqmQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ithfdhlV;
	spf=pass (imf18.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8a0880a46e7so868388b3a.1
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 06:50:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794667855; x=1795272655; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iDtGnnmzB8XetLwM09gGYvTUDRew+lNVR5IPpgOPUfI=;
        b=ithfdhlV4io6EjA5MRs41mtD7pt2OjPQ+CqCYk7Pax+DLIrG9urLrBKVg8ByI6eWeO
         WUZ7OVeEJpXxJzXk8AmjHZm8b7geHTUWHiR4rnS7ruSLXzupCMShZiGqVQAgT0F4VSZS
         ymqnrrWBMbE71Hum+arjJptBJLxR02j3uTf0k7MGkq/59yasyljWvacSUxxxp+jHAhlj
         AKOI+DytWSA62m0kUTmhUaCro13+ZZcrbidINgVjcV7iSq0FDwpRw9alhW78k1/rRxyl
         02oiuGwfD9oJ9NlP9uz0YIWz9rdLlZazzrRp9659YUZ6Nle5npTC2aLM8IbGthYIENG7
         hlew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794667855; x=1795272655;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iDtGnnmzB8XetLwM09gGYvTUDRew+lNVR5IPpgOPUfI=;
        b=v4apGFvmd3mfGHzACm9db7V3x6rhf2zNwn3x7/k/xdryO7dEXYI6ogvEujxiLUO/se
         wa3OVsCXvAXm8BHSf2FJ7mrxA8x+zuL/bUB139ud+JgofQOjmNLJBLDjRK1pmGK++NmA
         4BoeH/0PfVeonMn5dgiBuWF/pUK0CiFkNCB9CcnhCLdtlzBcABp1++1C5FVQeNRbGnCN
         ENWR8CVFNtEu3rD8lUsewkIN2442kKB+0uRSYML38MeZlMwPyqAPRTdzcpGU4buaKnXw
         oHLBwqbhG9ws8GPdNymA3QoXEtpUPWCOXlR9Pm8Mv738ptoQ2cpXFlNyO7pHmu9cO3KV
         QbMg==
X-Gm-Message-State: APuU4Z8vYtjRDA2u+BP4JsQicz8ej16tWDl9xv1tdOYuCzgd175dN1i5
	hF1UiX+M3WOd++lErN3cnb/BplDSF7S98NGJxFHI8Gaxi6XRVXEnGQ//GmkEww==
X-Gm-Gg: AYBFou3VApnt2E8bG6S4psbm3hqRmYHfv2oB0OSsu8AbyImFLuP4afxxadl2dxs8XGy
	p0YDor8zq4032YcEuYU+IOtak4oxOm6ek9KasWBHO/W5CRx8IASt1Qko//yqss434Obdnuaogmy
	pkv/vUtx16QSuf46ask+irAVntGk4QZV6saAM1PYfXaU0YfkwhsnPVJfOw9CDIG1NnzT0I2xzu0
	1DHhmxMwNw05VGSvMFHvWobb6XHaO4SPcxZfSW/Yy/ohWv8pCBIrDeBmv1YsCKH+11EPwFbn5yz
	6/fWZSl3xnevAFuIUUC4eCAyu8NWwK/2dItWRc2wr51KJj1AVEB9VtpkgZsdCBaEK6NH5U0J1HZ
	C6WGmxWq3PuRqZNnGdgSZsEFNIdHZeB6rUqW6ouvc+nG2V3goO1pJzm3xeoAN3RVzstZ1tcA6/0
	NPM+72qq+YMYCJc3XTdlUH5hr+kTkO/2PsLgbtG2N94HHww5Qh2UlHxgsjzhASs6wJ+Tjap80Q8
	1Fu3Wl5pxD6pExdKIkCyZS57+Xm3W4ndUEMYe3F2WrE0miNZ/XKpZ94J62+Vej4XgI57J9U+uU+
	fYDQTsIGXCB9Qrh5xr5BICHtvc5eAJcLk7Zs+R05nYNmJ5ywsV54dFleDr6qC6xwhx1Ol6L0KyZ
	14FRsmOvxxI+3xg==
X-Received: by 2002:aa7:9303:0:b0:8b9:227b:bfc with SMTP id d2e1a72fcca58-8bd5c0b5795mr6012445b3a.1.1794667855205;
        Sat, 14 Nov 2026 06:50:55 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed1d5f005sm2141222b3a.29.2026.11.14.06.50.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 14 Nov 2026 06:50:54 -0800 (PST)
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
Subject: [RFC PATCH v4 09/18] mm/swap: avoid direct reclaim when populating swap cluster metadata
Date: Sat, 14 Nov 2026 22:50:40 +0800
Message-ID: <88057ceeb0228fd33f42637a3c9647eea74d5d95.1794666741.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1794666741.git.lianux.mm@gmail.com>
References: <cover.1794666741.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: xousww56kanwr9ynkf5phjw9it3jb8fg
X-Rspamd-Queue-Id: 797141C0005
X-Rspam-User: 
X-HE-Tag: 1794667856-26613
X-HE-Meta: U2FsdGVkX1+Upx+PN2r8qN/mtz8jwaCVf9zcLCCdyXQaOcZeK7/1lqoDI2wabvWHCcYBW+MwNW49TDEI0QklihKvh0h9RayTc+Afy+z15xUsbwG2HPnBq5nEciZEx200xbvbQxAQsbKzO6ups1Z5OhxQeWHCbGpd2OkguIMEV7uUYGjxbML1gZGg2C6CAL7awIiCwUzfRl9vL1HuTTdEqRmFRae+/EH+8JAHG2v9ylqNLVcT4x/WGPpOUFc4NPFvhT+xvK65akDX1AjlGtbkrIvVIxzB0DTXKnhRdEkrXRCty2W9A4OK+b2W2+fswlv5pGagursuL+SPldXAJQiw0+V3S3PruXUttFQWFfzP0DLB8Htn5usFbkRDcgXsZiScCQ+6E+J8HlLdEQI1mjm1UOBnquqvGJO5pTFiPzxBUuxoZT8gbarawDADL2pwT9OeQmiCA59UyRyTKOa5bQyXQvDWyHQGIlUayMo9XB2gfNnIHcb6tCbo3hgNfWxjcqzQfajaycZVZifFXai/qw8IxDjLkKfd34mpZaJ1sz7TCNr/u1XnTG6ELrjcud4yLYWZ7s80ifhd3MYnBSkB/qEB+g+vNqx/qgDBxnjDNLFi482VjUWJJmNjdOfPgTPMExeHTNtw4HWW5ENB5Sutce9mxaKVaJydMPi+/ttmLHMJTnVN/F2GyMU8IQqtexOkGsDDUDA/c/A5kKaLxOzzz5e9AbqTe2Luim8RvCLDFodnNkH4pouWxIviSh2DiAR67WJpoRFuREs08dknjnARlOrFNomnNgGq4t+jdAep89Tf82i090FIqmFh8Bj6pfRkldpo/rKc5/WfFEFFRPs3n8dbxGA1nYjtnjcuoaSkN37fVmegRbm99iJc63wB47rk9gCeGJzFchIRECUxBBK3G//WIrEziCFmK88TH0jVy0oF4Gqct6HM8D6J+fD9dn/XnK6ZJV7mwH0BYP0ukqtWM2z
 /k0Ukk2n
 bNfh85a9m0QhH56O991b4kT5oWODM4btR3Dy9VfScl4Tn2AwhuVQVezkQ9hIBVkzX/AIw4w0ndLiiwok16tWo0a4bTMPWK8cRSzZ1+iqLW9qwrKvqr3EyGpapV6utOt1/sPXFnqDY3qt9lVhmp59pzoNO6+q/plh1PTCkoRpVmK7mlPfQd/SNintBKbKC1RnsT3WlBgucnD7AH1w7e4Ye7u4GHIHFgxUG6SpdzBM4+valDpih3IytqoSkDlZ3GVhRCmYWo9JdgX05r+PXHoPPNn5DOVA3BiCkONP66HTPs5765OZCi+hcKoV9zs0KKsNGb6fz1BQQH2DqcDZYe7qNX4dWejTr/5rr6qAHXpBB5azObxuxRJuA31IIzyXPEw7xiHwx6L9unbN7PKg9+EI1sC+vWZj3DDTXa6Z+ytFkO8LCB9bKxyjx/ZhDXqxK6fFwdoB2fp6LSb3uA8E=
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

Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/swapfile.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index c46b43414bf4..fae862fc873c 100644
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

