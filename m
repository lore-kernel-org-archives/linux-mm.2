Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B2AEC44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 18:16:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A6AA6B00BD; Wed, 15 Jul 2026 14:16:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07EA36B00BE; Wed, 15 Jul 2026 14:16:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED69A6B00BF; Wed, 15 Jul 2026 14:16:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA8806B00BD
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:16:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3E7E140295
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:16:50 +0000 (UTC)
X-FDA: 84991816980.15.DE6267D
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5DDF4A0004
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:16:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CMA+RSeU;
	spf=pass (imf15.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784139408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+q3csfDWWlHf03esSbv28913HL95J8hCqGqZ6tTf+OA=;
	b=oGK1Uj3HbeTnekK2RtEvlKYKVua6uxsYPSolynHXc8Wtv9e/m79byoQzxbC8CdSLkDLn3J
	8N1xRCNliVgUvLwG75t/1Lt22Qm46xDpWMlsnjq2YhSUEM11GDNADgzChy3njANGdypMfW
	r6hTMaLW5AEOhXP1JsbNYbG+csVn83Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CMA+RSeU;
	spf=pass (imf15.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784139408;
	b=fLRYeKUt8EUl+zgw29ZLWn1z8xZOdS05zJ2NF8mkpikZ8Ymj75FaCJL27/pcD6+VsaQAOz
	UV3g9NDJ/x6baU92w3MioOofSil+W6jPoYfcDnUviQfrQKg3Kg450FNqv6KlaMyrKpN8L5
	ftFu+R5hUD8vZkthMu+QpEFm7mM500w=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2cc7e86e7aeso25554285ad.2
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784139407; x=1784744207; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=+q3csfDWWlHf03esSbv28913HL95J8hCqGqZ6tTf+OA=;
        b=CMA+RSeUd5168hPgMZ98H31tFWjP9U+K35s81tr5W6VIlS8w4tk0OUvYjA9p5qWJks
         cCIB7ca0rsecF/8L9xUbKAFIEiwKCwj6DNpyMJXhy9Xp8GEh/5s7sN3MNh0Heo1iMHWh
         5wlMsiiglZeVZ41CX0cTbROoVr0jAAvkPXq0ISwtrXuIAI01EWhKCPF0edaU5zXLNTca
         9pOVdfIiPLuLl0Hzaidr68cLU/k4Id5X8Bk6yWyoI50fuswLMqcol92AboLxueDi8l9v
         3fGLS8Ej5dajGxkZlDBvBEdcZj6BXYhpM+WZZW4ZRKX+SZSJ8HSQCPF4UgAz2Hg5xEl4
         BIfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784139407; x=1784744207;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+q3csfDWWlHf03esSbv28913HL95J8hCqGqZ6tTf+OA=;
        b=iGqxVNCDVZze0M8SgSbiM+c60ZP5RiQ+wHjZyzzlyo2uxDafN1R7QTozciWq8Mf4bt
         IWtiOhH5iJuJbvttV7h8UqsvhyQ/cNhTEimBWIOO6Gr3NtDVIim1b75lDu516YH4JS94
         gl4hEZ3pVnhWLCPiS+kk4g0XoopcNA95gmHRFl5Asj+1TMqxfguRYL1V7VZVknOvXifM
         ihtmbSVUquutK2DxPrM6lIxojA4BGfWE+vvjR+d7vAJ1bnGQqr8ZgKBgSjZ/gAIPdwfA
         8tauuf5rDzxyCbOc7WW0o4f6bj/TYC/vePiyceO2BM1EPVLQzTB6SIQlZj9o2l5lm9JE
         1ANw==
X-Forwarded-Encrypted: i=1; AHgh+RoAuU35qss8nV47/ju63Ig2YjtkYk3j5RQkYqiAADkMl7+XkhDDp02lxXFqkHkav3pfTDTIx+D2Cg==@kvack.org
X-Gm-Message-State: AOJu0YwFhg/4I/p09ciDP5s4RnoLtfBN8R2n1R5puJItQigUq62Kdnzy
	NPpy99zWjPFmzr4oYJ8vZb6a0IRuxxD+9bi9vD5Sqd9Kj/mpUossknS6
X-Gm-Gg: AfdE7cmcAyTT9+/i7g2YNANVCFkuRNQHsGWLx9VR4kiYSVz0AABb0ReMcVod/E82b38
	dskYaVKQYZ5eCkJy7dSUhtbcZeTNTy+hKga6mlNk6xO+gIzByN4iXVbNSaWtb5KuNVzrT7yd3EV
	wEgPof/D3IYQXqCVs/h3pF8fMH8SMc73lZqGnzJlZo0UN/39dAGrS1UgaHUnc4BHOhkdiCP/tU0
	fkxzk4gtMzIigGrwR5Rb/VITWgZIhIk76bF2XS1bNDQLTh9HOdGKLTI/7zH8tvCtrITWwgnrkiv
	WQa328iLGdqsLloSP9aBW7Eu/7EozlMbTvVLlvXBvNGeykJ+0mbJ0tPTMHTTLji6YCkrPEg26aR
	yxXsbOX3Aoh6vX3BQ/VuQkFhDWWKwUr3i5QgucZYqIgWreM0lDvKu4QH2LXAmZrA5i1GNaZ5aQC
	TrG0ool/cC0amexp5QV0+fCx9PQeLqQPQbuNPrHCdg86izF0teFoKgW7M+ezA=
X-Received: by 2002:a17:902:c94a:b0:2ca:b8fd:f31 with SMTP id d9443c01a7336-2ce9e9a175bmr176469515ad.15.1784139406969;
        Wed, 15 Jul 2026 11:16:46 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf1055d661sm6778695ad.42.2026.07.15.11.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 11:16:46 -0700 (PDT)
Subject: [PATCH v9 7/8] accel/amdxdna: Use hmm_range_fault_unlocked_timeout()
 for range population
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
 corbet@lwn.net, dakr@kernel.org, david@kernel.org, decui@microsoft.com,
 haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org, kys@microsoft.com,
 leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com, ljs@kernel.org,
 longli@microsoft.com, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
 mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
 nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
 rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, skinsburskii@gmail.com, surenb@google.com,
 tzimmermann@suse.de, vbabka@kernel.org, wei.liu@kernel.org,
 skinsburskii@gmail.com
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org
Date: Wed, 15 Jul 2026 11:16:44 -0700
Message-ID: <178413940486.1155966.10368807598827608499.stgit@skinsburskii>
In-Reply-To: <178413903133.1155966.3904063656020521607.stgit@skinsburskii>
References: <178413903133.1155966.3904063656020521607.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5DDF4A0004
X-Stat-Signature: oibrucgfepj9bgntuakfitjbgb6q1c4f
X-HE-Tag: 1784139408-362691
X-HE-Meta: U2FsdGVkX183uMK6jtvOPItPse4wxhwJg/oI1AWmeRWIZbgouSfm1eBhGyxl6MCaOH3nXhtc1HWSwDji2au1ajseHSvu68sG9JVMrqJd5/IPFteT+0+s/WNA9Y0uvwh7Gr8LJXmgCIQDnVKSm88qOHkjJgwJDsBE2HzovvjXWopFqWZKUEExaOc+tJ1ccJXAtX7g2URw2+K52DkNseaKkj/N38D3jnSxS51/DilIerf0d3bYTg8Fp50NFxMScDO/qwsB6T/ALQER5xb5k93Kl+GV19sibTnaw6Qw1ZNjtQGRCM6gI8+BVBDTY1HVwhhiW76fhCpuG5BjOAW894VondCvEZYRg8SpXg4scSjlXZBsa3tdvWXaAhdkxU7Ro9VQYt1qnfYDEjGANDhpBtUZdoOlzj0tLsptdTph+n11eHKfCc+5g5WN09sCqjaSo8XA9cheZHUHAPfWn84HQVqSQym6AXuXVtG0vocQBXyxb3Ahk2aFugbH8N5swkQPUiIkcK3Akt+/5H4gUdDaV1yVDsVZtVk/fh2LHtC5WpiaHwja0wJ2eSG2NbgTNwE/oag8nafqW6FI66Ajr4rzM22l7pfyO0QCEfjE1GGtKU4+CFoBlGX0h4Zq1IqpCwIsmcRBXQHs4TP9PPn9IkjKzXYOU8ljFEPt75Dt87lOqqZdDjfykvoqtwAsRHNDm2eC9moWYsbKzLiSAsubLEJA8JU02QgcwvOcEM10VcbuEQ7H9Oe6gV9n/aCwAUFI0mx5QuU85TuAt2VFxJfs7z+PYu1zfOwywp8GzchOYROl24zuBKstiCCkOw/9sNptuZ1SaLO9yWR2lZW9K5WzLTomMtVPeCZT1v5Mr4dDqxAzp2Am+5o4R1MHVuo1x3Ih1KcbptkggBQFtHgxY719BdRxWh0gfGjuFXfRZwbMF8/Dtg/UDOeR8qZb6TmmrdZMTw6lUFXeTmtccbWzHCdQBk9OnYX
 Trw1o/4Z
 yrBHpp11/Gblp6jEUBSA+HXdMxKG7SOmEqebCHyEtI1f4WAALSnH1KcVM4jaDX1bCj2rLUYFDQ0Km2jGU6iSmFHk+749r22LOqC6syhFOYZHo5wHpiH98MdOLLDnQWGu3gJPtaVCabJKBLWM5uveDQunDfqjrODM2Runo/uF/vdbx/Ls9G2JN3Yl2Hjt0UKeyIT8DQnz5Lo3IqhBfKOYhfePVZJRPsGwGO9dRc8uEMLKyIl87VpRU661XvEzbz2OkVokl5yrCad2SVbUFIMINyXYutlskHL6m8OpATVYeRsCmDTdtmbYYHxmObC9bzSuYhOYIRoK86Th0EM6OepAM8hUuJj8uATfg5dK54OHFDDccn4YMW9vzf6/FtQZcGZHkk92FYG/kIlPCGQY0uGkLQUf96jscPUhKSmdSzSkXizHGn8IxCR6JaD+KofjKxex9GbuhKQQCQh+U2KK7wB55oNdhpVzBlwaR3EYak+Y3+7jEHdkaG8iIJZH6hJogYUJIgRfgiIPoGm85HD8jz7Acqzx5n+9jTvSFb5cBgiOP8EIBST8ISIJOzOoifUdqcfDpUKj7k8NDJvmizL0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

aie2_populate_range() takes mmap_read_lock() only around hmm_range_fault().
It also open-codes the mmu interval sequence setup before each HMM walk and
retries -EBUSY until HMM_RANGE_DEFAULT_TIMEOUT expires.

Use hmm_range_fault_unlocked_timeout() instead. The HMM helper now owns
the mmap lock and refreshes mapp->range.notifier_seq for its internal
retries, so the driver only needs to call the helper and then validate the
sequence before marking the mapping populated.

Pass HMM_RANGE_DEFAULT_TIMEOUT as the helper retry budget for each HMM
population attempt. This scopes the timeout to repeated HMM notifier
retries while preserving the existing outer loop that moves between invalid
mappings and restarts when the interval is invalidated before the driver
updates its mapping state.

Keep returning -ETIME when the HMM retry budget expires, matching the
driver's existing timeout error convention.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 drivers/accel/amdxdna/aie2_ctx.c |   23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index 54486960cbf5..b5b4ca263002 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -1034,7 +1034,7 @@ static int aie2_populate_range(struct amdxdna_gem_obj *abo)
 	bool found;
 	int ret;
 
-	timeout = jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
 again:
 	found = false;
 	down_write(&xdna->notifier_lock);
@@ -1061,24 +1061,9 @@ static int aie2_populate_range(struct amdxdna_gem_obj *abo)
 		return -EFAULT;
 	}
 
-	mapp->range.notifier_seq = mmu_interval_read_begin(&mapp->notifier);
-	mmap_read_lock(mm);
-	ret = hmm_range_fault(&mapp->range);
-	mmap_read_unlock(mm);
-	if (ret) {
-		if (time_after(jiffies, timeout)) {
-			ret = -ETIME;
-			goto put_mm;
-		}
-
-		if (ret == -EBUSY) {
-			amdxdna_umap_put(mapp);
-			mmput(mm);
-			goto again;
-		}
-
+	ret = hmm_range_fault_unlocked_timeout(&mapp->range, timeout);
+	if (ret)
 		goto put_mm;
-	}
 
 	down_write(&xdna->notifier_lock);
 	if (mmu_interval_read_retry(&mapp->notifier, mapp->range.notifier_seq)) {
@@ -1096,7 +1081,7 @@ static int aie2_populate_range(struct amdxdna_gem_obj *abo)
 put_mm:
 	amdxdna_umap_put(mapp);
 	mmput(mm);
-	return ret;
+	return ret == -EBUSY ? -ETIME : ret;
 }
 
 int aie2_cmd_submit(struct amdxdna_hwctx *hwctx, struct amdxdna_sched_job *job, u64 *seq)



