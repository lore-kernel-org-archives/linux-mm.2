Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DF7C606A329
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 07:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=VWLsbl5o
Received: by kanga.kvack.org (Postfix)
	id 905536B0421; Tue, 20 Oct 2026 03:49:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B67D6B0422; Tue, 20 Oct 2026 03:49:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CC6B6B0423; Tue, 20 Oct 2026 03:49:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 577D86B0421
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 03:49:21 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DBCF314085E
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:49:20 +0000 (UTC)
X-FDA: 85342229280.11.E3D1FCB
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf16.hostedemail.com (Postfix) with ESMTP id 089A9180002
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:49:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=VWLsbl5o;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf16.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792482559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9L30+UnUca4cXFOJhOKpyYquJIxK9YX+zDZ/0S6HO/M=;
	b=LrpvbqqNCVv79FvCYOqmraZxVhrMIXJ/1WxZmwzRroPAuJwSXRFswbQ46rOPj3bSL77KR0
	7DpMHSboiEMrzQaG7FcnRoYs3pniM+J4wwmxgop64Zu/918pp0PA35S205oedk7LeYTPL1
	FC2o6zRfO3F25ACAoJtVCChImXDZWRQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=VWLsbl5o;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf16.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792482559;
	b=yncjIfkSotiqdRs2AifHD2mvGHgbM2k6VzDUNfbkfx1qOIdqJEZr57GA79b+C1FVB8LTi4
	tOirAMmdsE386Zt9HC88K1TWyjPUDyyvUpgod11n352KY4bnwqlS7ABjvq3+0Pzh9WEUAS
	mNjoSIXNXuJsIY/iQMx6a48k2Ngjc5k=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49d05d51553so20080695e9.2
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 00:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792482557; x=1793087357; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9L30+UnUca4cXFOJhOKpyYquJIxK9YX+zDZ/0S6HO/M=;
        b=VWLsbl5oH9HJdjSqOdK7c8W61mD/yrhUnJP/eB1xsPr1hUmEJeVHL0wGZCQrLnhhWz
         bd1SY5rugk7OVgtTq6FES9Civ874K0HVDpm/JMKB5Wpnw8qvTMTjfdIxRTIrsKsuHrQ6
         FfiFUfCcwxakLe94KQFQbRvXcp0JeMwCa4xRvrFcgWEQwWKPusoUHY/h0YmYhpA7a4H7
         cNNqPQELISVUPXKxfFURIKIdyXDoPbVVIK8Wvx/oqTxt9MiaRQjqEkSPcxUBXyB2+2g0
         QwzZzNHwKfWv8KjsZEzcvtkNA+VEsiCC1gEspfyKbQvG1U43/OF/UpWLzJyxOBZ2OhjZ
         w+hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792482557; x=1793087357;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9L30+UnUca4cXFOJhOKpyYquJIxK9YX+zDZ/0S6HO/M=;
        b=t4AxHUmJTlDoYrUGTFEdP3R05yZg09Y6omn/XFsm8aIz8o8NGuH96RLAPO3yFpmPfn
         4qbEhoT61DPX2c5nQCyMTcGsK2+3wlrS3qIT1iizA41gn81kyOxZJuSVDGyd1fs2SLsB
         LFgiaQ7B2W1GEXAwnXWYRZX0+LA08SyqXecKoJxsUyHU2g04kfHr10Bzg7XKEHusb5KN
         1WuABXZzxuVQxHoyqcm+R+1oOeZShwtjypVNhjcrB2vI2cSu5KoTa/g4DPAae+wo6Ew9
         C9hrI7w7zVg9o5skDJL+8j1mDWH5phxyVNKuo63XbgG2rHjbx82W2/W+s2gYzHXjHrUe
         Bjpg==
X-Gm-Message-State: AFq9FYJdsrKmHGhshWjmOcjwfYaOmIKKzSCUoG138QMvofKPKoMkSxRM
	+/X+hEPezBAUZLEPN5+SQb2gbVw06gMp76TQJ2yHkAAdce79j5mtbS36u7EQ8oKJJnI=
X-Gm-Gg: AYBFou2ojOt0J1eTdm4xBXR8t/JglX8lGAaHmOzEuaCz8l2cFJbrglO0H02ZjnQSoxN
	cNcyfXttYxpJGsZk8ITJxd1xGVOBYmBVLvCsZ37cYjDKQRYXo+vC2dJRfO0Vk2hkXaKbAogMnhB
	3G74DmnGiR+8kKJS2jtyaVt+PgpPGi590y7kWFOpNA/Y/jwZaNjZlliwqU//FAE4LZlIpjD7AKt
	78ZtGv8jVKyoPNI6D/ilE3+96Yo7lBYgrVukY9OMLpRGhxlVN/h9CvQkPDbi2kYrgKZXq7AOvNJ
	emdSCK1/IX3AMlAmevKYeRGSqGLQGQMjuHWXT92tQv4aUJEFiLINssXF4odlhPwEqJM/dvv2UO6
	4BPGZ5bQfgCebElMxfJtP+wP26Iy17JSScKARkzrLbip6v3NO3HE7LHvcjCIDUgGdUxi4zdjOD9
	vhhfrv47gzZ+eaxBalD8MN/Bdxk6ewfI61hGBAXEhlEWaFW8aeW/EYdOYeCeJIWsYoNIIWBr/Jb
	ICXzSdikVoo
X-Received: by 2002:a05:600c:a10c:b0:4a0:1a7f:2abb with SMTP id 5b1f17b1804b1-4a1d75fe221mr168268455e9.11.1792482557376;
        Tue, 20 Oct 2026 00:49:17 -0700 (PDT)
Received: from localhost (109-81-30-107.rct.o2.cz. [109.81.30.107])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1f2c1e0e6sm61126865e9.0.2026.10.20.00.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 00:49:16 -0700 (PDT)
Date: Tue, 20 Oct 2026 09:49:15 +0200
From: Michal Hocko <mhocko@suse.com>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com, hannes@cmpxchg.org, david@kernel.org,
	ljs@kernel.org, dave@stgolabs.net, roman.gushchin@linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: reclaim every zone in per-node proactive
 reclaim
Message-ID: <atcc-91WerBlJ_Q5@tiehlicka>
References: <20261019185002.3428594-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019185002.3428594-1-gourry@gourry.net>
X-Rspamd-Queue-Id: 089A9180002
X-Rspam-User: 
X-Stat-Signature: 6wp6nyo4ydnbxubqo8une13nag78qcga
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792482558-180900
X-HE-Meta: U2FsdGVkX1/l/LD/tezg2g+3fHXD8cSLESolh0cw7AhkH+P9XZSsyH6V3WB6LzfYEs8mvRvuFsObjpFZzk4le4FnxwiZvx/zPzJrtQ84fIkTDpCDMPssFGHO4J1SbD8vmzmOywXyAJ4kfkVMURuQa7WNBgR6ApGiShAf80Lt3dF09unLn0bgQbxrD7+Vc1ELRKHRagiel6KltdCMD1rJen1KpGZCt1hEiObKdAGNgsBAiKp14sp/W6gbZ/EKaR0ieqKIIEPtwILaGnhIi9VcShkGRaWhWseIl4rnp59vM/d83kObgaE/Qw6BJ2PlTO04lbsWgYqA9yCd49u8gHp2n7DRQRd6UHDIZHgUYUST4NUVa+cZx3ikk+ey3VOGkAgFsoLP1EA6sg028vE5OhYbGfvy1JQJrux5uJQBjq4eQhPN+7G1/Xr8kynLFS5kGwzzVB4BqKek3R8vRr3A+612vKbVqUQC7jqmVYBrkNXBUGN0rtFv1+DQzNK6YuODGm2NCgGLQ0E04pMF0QtlJkZmyziqccD7hCcOoOrDWkCo+obyF1BgmOTSllk9AP0enVwRfPZ82/LIdJE2n8YoCwlyyx2uN0AB30rpfficllvl9gn5pJKzQBi14rE2/j/n6FpruJ1weaUYqlm5n5j3sH6X/YG7zZBL3unhJPyJRs+l+iiLXarc/Sm6jxxR+6Pq0ZM70xlg2Lb/11iIUKMaMoEfv9s5wuT7eMr+aPFludmON4YPt1/wEwa3W/WuWWknC6zPFM0M5EH+n4/gfQJ1Kp/RKsyFos1zQMhiHKG75E3vDzjqWo0BVVBFruF3YqXClVHFk0PXVpkIyoXbMjN2SU/vhSsSytb/Q3uliq/7zkatDJWHjvVwPx+5VBvKzPQug94CKo3OoMFGemdgh0GENL28q2HRQc7788OoDMI17y8+ww5vaC9CHG8Yjd6zxnZyGRMqvhLG+mbM4vEncXxM9fC
 UAYpcXET
 qCTlDJJBZXZa6RZQyInTU/C549bKTuVbeJ1YjP8HOzTqe0eyxZRwTdqIL+zu6EkDCHXwf3S771g49VMT9rZc6FqSRLggb4SrLjq32BXYHRyIeMpHjTYd6LIL/NW6z1NG9+q/nZjEiwZb0x2HYrXUTp2E5WmkyfxC/WyG/L+ayITZ/MV/UGfAulByDz019uW8sHREIO5E8rEEJFJyI5KpgTf5XLNCbLYaStl9NEPG8eJkD9cV0JR5pf3p5Tgl9ZB0o3nWNurUFArREhVCFMh161DPTG3u+0uyd2rxwRD+oZcLzc/iERXNn3cK/mvbrH/qeBiw9Nbt1GPKV70LG7MsjC4Oj+rcqoS7wxsdsFzCrD8K17vUdAeuJCNLBGnP2j5r0wt4E+Fd+5vcuJWDydk92arYSYHGnAlzSPO4bTlAUZ2Eb0iBv8Z7TmOKd1ZzAwJx0cBsM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 19-10-26 14:50:02, Gregory Price (Meta) wrote:
> user_proactive_reclaim() limits per-node reclaim to
> gfp_zone(GFP_KERNEL), which is ZONE_NORMAL. Proactive reclaim serves no
> allocation, but that limit makes shrink_node() skip every ZONE_MOVABLE
> folio, so writing to /sys/devices/system/node/nodeN/reclaim never
> reclaims a node's movable memory. A movable-only node, such as dax/kmem
> or hotplugged memory onlined movable, reclaims nothing and fails with
> -EAGAIN.
> 
> To reproduce, fill a movable-only node with clean page cache and write
> 200M to its nodeN/reclaim: the write fails with -EAGAIN and the page
> cache stays. The same write to a ZONE_NORMAL node frees 200MB.
> 
> Scan every zone, as memory.reclaim does.
> 
> Fixes: b980077899ea4 ("mm: introduce per-node proactive reclaim interface")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  mm/vmscan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index e82ba737c028d..90f7a7bf4e426 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -8180,7 +8180,7 @@ int user_proactive_reclaim(char *buf,
>  		} else {
>  			struct scan_control sc = {
>  				.gfp_mask = current_gfp_context(gfp_mask),
> -				.reclaim_idx = gfp_zone(gfp_mask),
> +				.reclaim_idx = MAX_NR_ZONES - 1,
>  				.proactive_swappiness = swappiness == -1 ? NULL : &swappiness,
>  				.priority = DEF_PRIORITY,
>  				.may_writepage = 1,

Would it make more sense to 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index f11491ee9ed5..e07db9514e59 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7963,7 +7963,7 @@ int user_proactive_reclaim(char *buf,
 	int swappiness = -1;
 	char *old_buf, *start;
 	substring_t args[MAX_OPT_ARGS];
-	gfp_t gfp_mask = GFP_KERNEL;
+	gfp_t gfp_mask = GFP_HIGHUSER_MOVABLE;
 
 	if (!buf || (!memcg && !pgdat) || (memcg && pgdat))
 		return -EINVAL;

That would take care of try_to_free_mem_cgroup_pages too.
-- 
Michal Hocko
SUSE Labs

