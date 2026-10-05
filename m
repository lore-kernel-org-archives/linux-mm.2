Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40D7ECA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 09:40:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D6CC6B0088; Mon,  5 Oct 2026 05:40:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 287436B008C; Mon,  5 Oct 2026 05:40:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14F796B0092; Mon,  5 Oct 2026 05:40:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E09E86B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 05:40:15 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 77E391A01AB
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 09:40:15 +0000 (UTC)
X-FDA: 85288076790.15.FB26741
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf27.hostedemail.com (Postfix) with ESMTP id B4DD340002
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 09:40:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XGrKcD3b;
	spf=pass (imf27.hostedemail.com: domain of neganhat@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=neganhat@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791193213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jY/ReaqTZBp6Cyz8uCafEuEwQewav6MPXXeAgpBCLJ8=;
	b=CQj4bRx3kYlI3i7JLqBP87yakuXhnqWPoDPIh/LrGSoaoF5FJX2WlwImxGGj6FcxgcYt7U
	B80fUhOLcmhWcGXmNxslLacoPHGIM7xWBdkgZKKzzsbDQNNuRPELth6DLR79AT4UFhog7c
	djw9+XPuJDIKMBFudtDvt9+QZiw8/JI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XGrKcD3b;
	spf=pass (imf27.hostedemail.com: domain of neganhat@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=neganhat@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791193213;
	b=deJ2m9me+LAriAlNkU/SxbQ34LgVAJQDemTXOOSbwf13OtpuzvxsRWU+ogcTeRD+d4Zyt0
	1IrzlCMUJcK968+5nWDkLrr3roN2AMucgIxx9ptXGR3kgXDMDLzaAAAGSYmX68jT+JNA4w
	dKAoCpEtIKdlQN4XKgvo5RbImf5ah9A=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8520161fdb9so1016853b3a.3
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 02:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791193212; x=1791798012; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jY/ReaqTZBp6Cyz8uCafEuEwQewav6MPXXeAgpBCLJ8=;
        b=XGrKcD3b00lKQCvlcpiRQa+j7l252++SRXQvegIVLNnwsZQsdfbHUT4kRghZpA8If4
         8C4YJTcC7ZYFaNbsceUTI/7DB1k+r3wBMRKFGycovABodBhHtc9m5u298K842Xh5Kd6C
         z6LOwl+ic8HLbDZfT0cssBIYSso2HddaCRj1gv8nHSCUO6w9shRAmk7dHCSc8W/0ZeU2
         24ybIfR7GsK7wuLYls7X/k4UZVesbrqflOEDsrhnEXH17LwyQKZBOFYG4IsjdUeDlwgT
         1W2ycPB9PIbIceRvnztlOgwX+m7m98KKva7KJCnOiopVxZZt80vVzZItBZ5CXLyJnpoQ
         cyYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791193212; x=1791798012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jY/ReaqTZBp6Cyz8uCafEuEwQewav6MPXXeAgpBCLJ8=;
        b=kB95jdLPcKB9lp8lWKzmMxiSwZC4Zm5/elzznpvXtgVa52xXgMI5Semgy7tZSZglLz
         egJ7sw8jT42frB8ghslrhm2pLoaP9mYfeCG5wM1esuBodm1aPXT8z3AYNgLs3vWJUuPF
         T8nIHIF//hLcnEoob9xf1q8N72HWZ/0vKghQI+U3+u6Gtmgignoo4ZJTtkKiANq4iccS
         6JdfbjQi15zII7vTWe3EeeQ60OqLbnJtRDlpHJztnwnN8SaP1asB8nWqMiz4k/EmnngJ
         mKZ7uwG6Opw/9/MDPuCWh4ijp2BGSQF7aQoKcolhTFGELcY663gYDN65cjrL8gbMit3C
         MP5w==
X-Forwarded-Encrypted: i=1; AKwUvBzLDj01j1Y9DSDD4vfTaCjREZ7hcsdQFOGLEWJFVHkHSsEE6pjApX3xaf4mztXcDOJ8Cq9Anwrp8A==@kvack.org
X-Gm-Message-State: AFuF++kfDy6SZUj81RGCasK17xAKxaFsKU2ofgcksMW1ni6QoBeuRLb4
	oep+AzSpSfjEsY/o6bO2dIaN9xx5X1IA9Jcfrc+vOu/tp+OIBIiePl76
X-Gm-Gg: AYBFou0N41/ACj49XWpcfywgX1rrBfJ/XJmVqjuZjvZ6DD51qXtLtANAXc2IxwVmd80
	l+2OH32I1rZ1kulVh+oopDdGZo1NPVwvsoT/zXAG1vR1EUEVpm9vwI9OeA+U5AqZXMjl1CETZK/
	y1Eda8jQHcdaDhjbu0NMoPupf/05173FgG96NsuA0aE2eRsPpyo/hFnuqBnMr84/OHcxhL47AwO
	XDLPEgvuTzTu5iVz9vGFrJs8EuH5GO4xFqYJ/dEk6XRPs0z6tRquSM2Kcx4QOV+1xAVXboEde4Y
	8M1u5Og+IgflQ/C7+CO4SeBT/CRRdl7V1fldhva/6BH5Ln146KoFrGpx7uzTKUe24Xz6QErg+qJ
	tMvBWEpLnkS6RpLq/Cg/MQT9KWCd3JO3tGBmvRuqDEbRKLFE3jeIA+F5rKWCZPvxYREMFukZtRL
	CcU1IGGf733x54ckLQN77iaOHM47e+jcV42Kdej5sWpbjyeMf7OmooekgUm0nrARPJv/bkgE41p
	17cTtnT4NXyMHb2IrkCDoFjROsR3HWx17f6bcqxbmDA2bDcU98=
X-Received: by 2002:a05:6a00:21d3:b0:886:cde6:694b with SMTP id d2e1a72fcca58-88c6454a9d3mr6145500b3a.38.1791193212542;
        Mon, 05 Oct 2026 02:40:12 -0700 (PDT)
Received: from casta ([2401:d800:280:3061:5aa3:761:cbfb:f123])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-88b0c3a4862sm3156138b3a.32.2026.10.05.02.40.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 02:40:12 -0700 (PDT)
From: Nguyen Duy Nhat Anh <neganhat@gmail.com>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nguyen Duy Nhat Anh <neganhat@gmail.com>
Subject: [PATCH v2] mm/gup: document unlocked invariant in fixup_user_fault
Date: Mon,  5 Oct 2026 16:37:56 +0700
Message-ID: <20261005093756.22709-1-neganhat@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261004125601.c06953a6f0660df9859b0c2a@linux-foundation.org>
References: <20261004125601.c06953a6f0660df9859b0c2a@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B4DD340002
X-Rspam-User: 
X-Stat-Signature: zqg681s8uubcfmbdkf34srk4tooudf6i
X-HE-Tag: 1791193213-552238
X-HE-Meta: U2FsdGVkX18qBriHyFmG6tx8SwQDAVYzQ/04smlaiEZgvEdoG2QuDxbBvYFavrFOry4zdEJshO5Alcih/ZUIoTrYhUVUbFGhNJoFrv/+BQAqo91hfjWbsWVBnY0TeGLGwHc27nlNclKqxLkrD8+GT1SxNJgVCPnTvQcn8yW72J9am68ec6UE8jl3xUCaNFMdwOn4Sl78JeKcw6aQ+fnf1XNo5fRMihECBq2nqPsliTID02StylB/qlrCDQsIKFsIDrX10wF9WC3BFr32ud9lyDkPmV3zsY1ddh21iEWkrTScgVE+YrMm+3oFTDVAly1bOLhYkxqAu6E+MmITJsTGe+i7vHXDHmVyGf1u1dIxMCZhT3QyrZgb8p7WxPxMLZHJ0jXtKIulrA43NheXa6eYSG/2YCLmgYoHDijpMQ8SSM5p3w5Au9GlLI7KcQ1NLahDeHVUSnemWDpYi8/nL2fqZ+U9qfR5v2XhMEE8Tun8OR1fRy/uRl0ALalgNxBAfPyekeKk2zOiaJfp9/+uFOPPMRWsV5m0sQgywPyEYhdBDCo+79ygTTCoput0Pqb/aN5/opRqOKoNf1nE3OfWE6HtRXyz3mGcGBvjd4C/zSuOqBj9abHC9EqPeA2r7Tcq/2zRPK9ZVnxEDhz2WcGUGtUmMQAHsHgnYt5GNg1fLr5bMHWxPTjz4JsucHOCl7b0QPbEYH3LC9hGyAShdvGVN4qT9YzrH/qL2IIWJTje4mMgRob0JkDS1ttrBy83/zZixv81uwvQRi7pcY5BBxjJz6S5kBGpgzUfPMhSS5F95or27BEBOts/h8KnlNNAQLHFrzJst8wfrlSyC0i9OBqo3KM2FsoAOZGINnQQcpWMqZ4T8ojLzu4SQj6+obbSl+DxpkCc2wsKwVfAX1PL3x0WHK3Vp+QNJ6cwMdAsDWBr8/oRXxnYbu5LA61Xc2bsRzICDHnFdecgCsMjLr3vHAjKzCj
 j5Sv5Gp0
 I45C0dsJtOc62D4dUN1lopx3o5WvgU6u+Y2g0rRwGaeJAaRvi/vXZ3mG6+O4y0DfYsYxj/U44mT8U6/enNOmQdQGvB2+OL1Zy7+ei/EYTudhoNYG0b91KTyMl1E03W0u9BOD7gF6Khg4cC+TLmjywomq0G+tmYstN4bXkBINaUaFi8+I9A2cIuJ0MzBPC90iUTSbgT9cH1/8nZ+L7nVdsxGM8AV1xCUi28e5OyDwEIMKSVZ5TIfSlF6V+nHJRDPPXQfHc7Wk1O9D/ss8POEoA2V5z/oCLqp2IP5ZvxjniyIycEdeCei6rgJAIWJdOPEIw7Le8JEy0e0MNRLDHJPWOxAiDytJ1wEcQ3y8gD76CvAtETMnNK6qduxVzhMRhmR6ZBEOwXZ479XO3uZA36YDnIHNJFTxjRL3lpbMahAcM0wMtXKxnz+ou9cqyhtwNNpemXKCq8wPXzFLeb3IRkyEDBYhEG/yUtmqcaGnWnDXLlPLHLnhVvflJujXEzaniv53PHD2PtIHJkjFwyU32CDMaM1Tpz6p/qy6/SU9EULFXTre0GSM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Static analysis tools flag potential NULL pointer
dereferences of 'unlocked' in fixup_user_fault() when handling
VM_FAULT_COMPLETED or VM_FAULT_RETRY.

These warnings are false positives. 'unlocked' is only dereferenced when
handle_mm_fault() returns VM_FAULT_COMPLETED or VM_FAULT_RETRY. Both of
these return codes require FAULT_FLAG_ALLOW_RETRY to be set in
fault_flags, which fixup_user_fault() only sets if 'unlocked' is non-NULL
upon entry. Therefore, if 'unlocked' is NULL, the control flow branches
that dereference 'unlocked' are unreachable.

However, this part of the code is subtle and can trip up
contributors or automated tools. Document this invariant with a comment
above 'if (unlocked)' where fault_flags is constructed, explaining why
omitting FAULT_FLAG_ALLOW_RETRY guarantees 'unlocked' will not be
dereferenced later in the fault recovery loop.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Nguyen Duy Nhat Anh <neganhat@gmail.com>
---
v1: https://lore.kernel.org/linux-mm/20261003194846.205918-1-neganhat@gmail.com/

v2 changes:
- Instead of adding runtime NULL checks at dereference sites,
  document the FAULT_FLAG_ALLOW_RETRY invariant above if (unlocked).
---
 mm/gup.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/gup.c b/mm/gup.c
index eb898ea1ee22..58fa75441da1 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1570,6 +1570,12 @@ int fixup_user_fault(struct mm_struct *mm,
 
 	address = untagged_addr_remote(mm, address);
 
+	/*
+	 * If the caller passes 'unlocked' as NULL, FAULT_FLAG_ALLOW_RETRY is omitted.
+	 * This guarantees handle_mm_fault() will never drop the lock or
+	 * return VM_FAULT_COMPLETED / VM_FAULT_RETRY, making subsequent
+	 * dereferences of 'unlocked' unreachable when NULL.
+	 */
 	if (unlocked)
 		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
 
-- 
2.55.0


