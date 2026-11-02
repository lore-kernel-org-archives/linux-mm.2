Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70127606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 23:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=B7Hh1qZ4
Received: by kanga.kvack.org (Postfix)
	id 89D636B05B2; Mon,  2 Nov 2026 18:46:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 875126B05B3; Mon,  2 Nov 2026 18:46:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78B176B05B4; Mon,  2 Nov 2026 18:46:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F33C6B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 18:46:20 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C8BAAA768B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 23:46:19 +0000 (UTC)
X-FDA: 85391815278.01.0D152A5
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf25.hostedemail.com (Postfix) with ESMTP id B904CA0005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 23:46:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=B7Hh1qZ4;
	spf=pass (imf25.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793663177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AmQj8uwBx2GfeOV7bhqZUS7hhPWLS2NeFKbOTCeICMQ=;
	b=fcuCHez1NY3oUd/kqIMOW4X/YrcAri1Zi0eSX4eupSrgyFrhtVYMgVo6sdu8rwx31V+Dvj
	Da1j4edhDo1B2sc2RqtPu76IS61T2BOEuG0zde4wPqIrlLBqsOtczy2YDwRBjXwVROsbSI
	GcSyp8/jRDWAhQ1+ZYK4EySh4lsAWkc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793663177;
	b=7i9Pf7eIk8YMDTwtW7vQawQb05A5miGDD7x3M24tLxrIdxuzKIsvgOSSEf9i/4R8cmEFGf
	HotgB8TS6QWoRajoz1RjJ8VYP7szlPN4EKSnyNVvIRRRgpT4S2S99fv7XIpHeAMfu+wMGQ
	dLeXkxmmEfVdZNmLYsCrL0Kp4IDq4Xo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=B7Hh1qZ4;
	spf=pass (imf25.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-53665358476so42033681cf.2
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 15:46:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793663177; x=1794267977; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AmQj8uwBx2GfeOV7bhqZUS7hhPWLS2NeFKbOTCeICMQ=;
        b=B7Hh1qZ4SQ2G50ACsMZoJtNLA1Zz8YeD0K4LZQ+fo+PV8E9GSqCl1vBFHHb9lwd6U3
         Lkzfhg9ui1njmEbCCxJd4gsvsIbj28d24rYSKD0efyR6g9NajnG6w262g+SDSCLpoYZR
         cvS3jy+wT310efs/1XOiocA5H1s4mNQj0OmFiLRNKHdQ726s0zhqBqD3k4bFsr0IGw73
         WmoAjggCGK3ir0h//GoscboOFkdQgko4C/fVdCNZP34DuPPt+NeTUDuft3QQai7zmjKd
         3Hb6+Bgfb+23al5HLaaGSHsvBJHawqEnkNUz2mPWp7VpXxnWM5145Dc5MtXgK+npc0b9
         kfow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793663177; x=1794267977;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AmQj8uwBx2GfeOV7bhqZUS7hhPWLS2NeFKbOTCeICMQ=;
        b=AVwsXs+fDiy8GPOUQluHG8k6UgN1xTMYnS0chzA6FCTj+CBcWBolKhXW904Wo6iBRO
         QBnBTr0mKJ+BRNSNqaNerC6Zw6naBVAW2gRAZ80fly6VoqxxucBHsVj6MTrSdmxt/mRy
         eXi7gF3McmERZw5BbMOKUmkVKv1oXTdnXHUYLXWE5vnbYtt7XC+J6eTu+h4otglXFgxs
         0nUce4EFjogdZ1nRy2Gq9P/5NR59MF1kJjMoW1KCrXI4kSYM4EZwDXOe1q1mwM5+HYco
         TaHcbqbafXLg07NDpYVbK6osAa1700W9BBXO0d9jixCEGgg/UL7Gqt9+YjNNrlYY8xvV
         AWIg==
X-Forwarded-Encrypted: i=1; AKwUvBydpbeAnvGNz1DjWgr3kOmasvqYmzxGGFPatvts7Qllf6V/bNneyUg+Toj6s3vTRcs+mEHR22uUhA==@kvack.org
X-Gm-Message-State: APuU4Z81E+Xo+slt6eMSi8ADWvlKX3Ki9KWzSvbSH90QAOVvNHyv3gvW
	ccv5gJTTh0wPS/wbvz46DRWShnltJdp/2gPoZzwkjf62XCHhVLRLm6nBCXk4Jg++XSo=
X-Gm-Gg: AYBFou1YSTpt0/LvKIHQ+beb7YGkIvoeCxVCXLwPb+MGtTBSzSrfImHrMYhPf8UHKvQ
	WtOaHQV+JoY1y7QY299A+eR7V3x4MhAxxGWi3v3PjFkKqyV1mf2LEx665ElNg915E+N74kVcgI9
	zBHeepRtDoMJ0twZwETa19yN0gE7vuwpgfns4vlo1OVNOA3wp5d0GVAYWRxaelqD4uGFKA4H8Sn
	FeisLxxBMxfZ0heQ/5GyBYxyaOglVm1nMjCWEpuHbjxzWGPXaCiIaDPQxpMPvRqdxYtSjVzGad0
	7neMeSIbLZCTKCsMIXQTmNejbgas+ZrmrWEpbQbG5AqoSwUoryw8m5kkhLZKiJw6DUGy8lIpsTR
	kJ2PD1Eg6qT+9pEKcbKwLFzb2lNGYLKMvQyXOjb7iD+cA+dCAgXKhrH7bjqkBIgQIntA7NduMAE
	8ORn8CMODe1ggymjngDsHAUNVpFDFZ9Finna/Zem0V6jmoKomVQhMRV4LQIAKJ/kbWJ0/V+Ttiz
	hVS3poKKO7S88+NM+AgxjHYH73dsdvB4Leh7TvG3J6wD9LKDHJZpKLXjzLIL93libm64kfs/a0G
	k6RqV1bSiAL3d0loWksJPolNQcMfnHqAn4Nawj3+53sthK8=
X-Received: by 2002:a05:622a:514e:b0:533:8900:4eae with SMTP id d75a77b69052e-542b6689b0bmr183674081cf.13.1793663176618;
        Mon, 02 Nov 2026 15:46:16 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.254])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5498b49ce1dsm10765531cf.5.2026.11.02.15.46.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 15:46:12 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Mon, 02 Nov 2026 23:45:57 +0000
Subject: [PATCH v2 1/5] mm/mremap: fix hugetlb reservation leak on partial
 move
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-b4-mremap-pre-split-v2-1-d281dd11ad7d@toxicpanda.com>
References: <20261102-b4-mremap-pre-split-v2-0-d281dd11ad7d@toxicpanda.com>
In-Reply-To: <20261102-b4-mremap-pre-split-v2-0-d281dd11ad7d@toxicpanda.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, linux-mm@kvack.org, 
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793663165; l=3765;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=KDPLb1ZOv3/5QJLviNYXmvAeGyiuG+gD4HjiBsWGw9U=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QEv7pIUqS9Sy81RCl1FzBVibWv9b2W9xS3EI9szQ232/V3lF5MIsdU1x/nrbQ9F1BlsDUxdBI+P
 Yl2tKP+3tRQA=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B904CA0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: bmazxstnpzumd916umftwszoaxb6pajm
X-Rspam-User: 
X-HE-Tag: 1793663177-628244
X-HE-Meta: U2FsdGVkX1+nwGpYZQ6WKeGTg4mR1DrLTEahvcgVVyzvOc7L/LAdawELLJScVtG0h8DqYutROUzpK4KGQ8fW5Ag0/2J5okXWkCxwmGpPVcgpUS7XJ0OYFyHiWjpJBhxSkAKCUQwPk9zkq3ae51FPOnaQQS2KmLuD4Z4JwTWuVWmjOgvPRpNIJDN9OABWoxKcCc2WvphJDTVfzfgjxZK0dYFgtIt0pvlKvwOBMWXf7aUlfX4vWzy0X6yjORruYS1G3CMInurkDSVEGgxcnEUsNB6uh/3EN2kDKXHAUcRrRjxkTNdx4C1BN4ouSGq+adtsPveGAvcT017uwlBLNOxF2XhPOswN6ol2eTkCs3QMH1CjINmyo7myIvXwzo3qazP7tAySBiPV3g+LFz2uPMMBSN/IS8DyW0NQC8fwVVs3x9Q0zAa8mmzPfFQBKf60fGP/kDHSkmvGDO4f0cRAeq+UBT7vxvfNlay8DTga3TckPompkj0um9YarADnb4AqDO8gfulAtM4pWjgV5JalugUMmPzKOyamL2sIQvNpKXOXgfunMGgjRVusdr0UYqjx+3ep27lbI+NlePqONr/slPwGAY5sJgbQMD3I3ebFX7iuAedF4N+cNvDi2hGG1Mz1tkEcWjJX4YyrI5KKlurfyKrMYurn0XUv784P5ooIIXJS80DrSkf2NgAB5rsQ6qIAznXGgV5goPoqiVaB4ErxmcOFnYgQe0ZCozu2qVs/wne43ZOdT/1W4SHPBCbZHjj6BoB3FEXUFZEMAwryI3GTm5biN96ECb4ZALEhKxcPKCtp6F05iS9FD3bJtPcP99Ua9O8VWaRbWz4p+5UC8gayRuNj/XTq6mTuI4eAjpeJKktHpt+fgCNhe6GRuEDpyUSrJqENeLO9No07+JM3smXc5yi6SpeJq4CCIoCt6uRXCGm30cxoHq/avZUc5WyoRllEBRii5cP2HPCIsTQWIW6G65d
 bhMI8fcC
 FbeWnHPh3sXmIel9Q4uBOYCU1adstQMjkYMP1D5VpJ3VUUu8+OLWPUAErdOkLIZI+5mRTBAI3XoCZjphLqlWeFr7CYwu1mRFW9/zjCezAzOJ7UU2gVUsomai5qNHOOja1g9L127oyvQXJE4ZzprxV6WcBMloQvawRCQtKUFXan/MkeAfmmMq6JBXd1dGGkbton6xoxISc7htFw883fKmVuohCKAlTHAkYHWa6J35nuyVvYzVjoU6I7G6GxeGCbMKkc3qZiaXPTQeazmFnHQYu/nmXmUCEiR4wPj2T+1bi5Tu+nIFtWRQBDp169+xHJ0sXuDWwMRT0o0kJN/nE8j7U8r1q2bPMPjSTb+Bo6MhJpt7MEYs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Moving a part of a private hugetlb mapping with mremap() leaks the huge
page reservations of the parts that stay. They are not returned when the
mapping is unmapped, when the process exits or when the pool is resized.

fixup_hugetlb_reservations() takes the reservation map away from the old
VMA while that VMA still spans its whole range, because the moved part is
only split off by the unmap at the end of the move. hugetlb_vm_op_close()
then finds no map in the parts that remain and returns nothing for them:

    mmap() of 4 pages, MAP_PRIVATE | MAP_HUGETLB    HugePages_Rsvd: 4
    mremap() of the second page to a new address    HugePages_Rsvd: 4
    munmap() of all of it                           HugePages_Rsvd: 3

The source is unmapped in this case, so the number of VMAs ends up where it
did before and the check against sysctl_max_map_count stays as it is.

Fix by splitting a hugetlb VMA in prep_move_vma() before a part of it is
moved, as commit 597e4b9ab48a ("mm/mremap: fix locked_vm leak by splitting
VMA for MREMAP_DONTUNMAP") does for an mlock()'d VMA. A backport needs that
commit, which is tagged for stable itself.

Fixes: 550a7d60bd5e ("mm, hugepages: add mremap() support for hugepage backed vma")
Cc: <stable@vger.kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/mremap.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 0d06d7f37f19..5926ecdb31e9 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1038,7 +1038,7 @@ static void vrm_stat_account(struct vma_remap_struct *vrm,
 }
 
 static bool __check_map_count_against_split(struct mm_struct *mm,
-					    bool pre_split,
+					    bool source_stays,
 					    bool before_unmaps)
 {
 	const int sys_map_count = get_sysctl_max_map_count();
@@ -1092,14 +1092,14 @@ static bool __check_map_count_against_split(struct mm_struct *mm,
 	 */
 	map_count += 2;
 
-	/* If pre-split, the -1 observed above doesn't apply. */
-	if (pre_split)
+	/* If the split off source stays, the -1 observed above doesn't apply. */
+	if (source_stays)
 		map_count++;
 
 	return map_count <= sys_map_count;
 }
 
-static bool needs_pre_split(struct vma_remap_struct *vrm)
+static bool split_source_stays(struct vma_remap_struct *vrm)
 {
 	/*
 	 * An MREMAP_DONTUNMAP of a mlock()'d VMA needs to unlock the
@@ -1109,11 +1109,23 @@ static bool needs_pre_split(struct vma_remap_struct *vrm)
 		vma_test(vrm->vma, VMA_LOCKED_BIT);
 }
 
+static bool needs_pre_split(struct vma_remap_struct *vrm)
+{
+	/*
+	 * fixup_hugetlb_reservations() takes the reservations away from the
+	 * source VMA.  The parts of it that do not move have to keep theirs.
+	 */
+	if (vma_is_hugetlb(vrm->vma))
+		return true;
+
+	return split_source_stays(vrm);
+}
+
 /* Do we violate the map count limit if we split VMAs when moving the VMA? */
 static bool check_map_count_against_split(struct vma_remap_struct *vrm)
 {
 	return __check_map_count_against_split(current->mm,
-		needs_pre_split(vrm), /*before_unmaps=*/false);
+		split_source_stays(vrm), /*before_unmaps=*/false);
 }
 
 /* Do we violate the map count limit if we split VMAs prior to early unmaps? */
@@ -1162,10 +1174,7 @@ static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
 	if (err)
 		return err;
 
-	/*
-	 * To account mlock()'d pages correctly in the MREMAP_DONTUNMAP
-	 * case perform any split ahead of time for an mlock()'d VMA.
-	 */
+	/* Perform any split ahead of time if the source VMA has to be distinct. */
 	if (needs_pre_split(vrm)) {
 		VMA_ITERATOR(vmi, vma->vm_mm, old_addr);
 

-- 
2.55.0


