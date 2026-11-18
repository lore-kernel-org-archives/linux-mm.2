Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C53160A260A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 17:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=Qe2xZJm4
Received: by kanga.kvack.org (Postfix)
	id 077A16B05BE; Wed, 18 Nov 2026 12:01:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 002806B05BF; Wed, 18 Nov 2026 12:01:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E34276B05C0; Wed, 18 Nov 2026 12:01:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BD8F16B05BE
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 12:01:09 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C5B3AA0833
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:01:03 +0000 (UTC)
X-FDA: 85448854806.20.578F69B
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf17.hostedemail.com (Postfix) with ESMTP id A2E814000C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:01:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=Qe2xZJm4;
	spf=pass (imf17.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795021261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K0dOJrTdqvBZQHL50wcgAweuMTTjNgpoRfVJHv/VgKg=;
	b=FI2YYifEDLJHEvY3/fr6AruSS2DKMap/VLMkHM0wiXpt9hL62SNop1BZga/suVQ2hT92Wf
	lSWxI3uyhcfCzUWd+trQMsYClMduMIvFYMmZ6E4bvjH7FLwwhFvRUrlfctfP9ygdZAwLUf
	45LgKkdSKYd106KYVH5x3S+OhErnjfA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795021261;
	b=N1IRb39I3MEue+1HZsBaPot6WvOTVbAagJbQSoYbcBRDAQMp3DuICRN4zXec7JuilJ287R
	8Rw7gq3cPtNLU0zR7PfaY8YJlFj7kwr+5FolpgxUeETpN3xaesXGHUsai5mq07UgvJITEj
	6drDywfpm5cNIWj9l1Jr6S8BVB8P9bY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=Qe2xZJm4;
	spf=pass (imf17.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-94958650b09so116841385a.1
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1795021260; x=1795626060; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K0dOJrTdqvBZQHL50wcgAweuMTTjNgpoRfVJHv/VgKg=;
        b=Qe2xZJm4YROWmsPbAy2a/3zellfW1ItubC21ScV8zFGATnsyaoFguw249uR+kw3smJ
         Ncjd01Rw/hyHbwmQhP/coS2wLUDMDczZ4nrUWp7XFTcvT5z/+necvtmajkJdog2tE2gF
         GZyrt4a0Y7X4D2ff5G4+jd0xVPPJCUDflUUbmqcekwLeWFK8ioLupg5sqxaz1s9CpxKk
         KvF04+ctl2OnMEFsz19Y1nmYB+SxoM4Go0xrXWNwO9v5DjapbIslurwA/iBVANYP0WYR
         s/8MT6+DD4+3lVFbgdCak1yae724jyKd12UGTVZPpJjXr0Ho5qbUrjlwH/apnsoPXN+m
         Gh1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795021260; x=1795626060;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K0dOJrTdqvBZQHL50wcgAweuMTTjNgpoRfVJHv/VgKg=;
        b=MW542GMWtLaUd1T8TqHi5+kj9OTvB6t+qLcBsqsaLMw1jpgfGw+gtWUxVJVHHdQAfj
         QEiUcwFI3n5PBTlF8fEqsbPEGJblzNIAJGCROquAyBUcaoyT6W4GEOLaYsHFfceBdOx6
         4UfMQFDVnSyEmtewoRNm+LJK+cYDZY40zjknqSIB3Z3d0e59figu+DJ6f1R1GoV9bg5L
         l45uYX76GYiWVOOJv+pXmqxVkKozBQeGO7bn7tYppbXj2nHLwroTjwbTNn44smfTdyfS
         WjbxRHmJa2BewQQXT2j7asaEWfV81n/d6HmuKEGiti4Z+9g5VwIkUiig0U5S42qdflT6
         bDBQ==
X-Forwarded-Encrypted: i=1; AL+hErFPvLPwW5meaYptDsRfnfOW7EkgiIjriNvuvfkrLR1j8MJqEY99AYIq+po32bn7Q44SUqQmQzQD2w==@kvack.org
X-Gm-Message-State: APuU4Z99t+bd+lwfRKm2oP9G8rOZBospyKiZjpx/y4DzVkFEVYquJ3KI
	zZKT7Kh5iARqiKt93ai94OgLiVUOYYANkckP9PfQXSoyRsceMmRSn91XH1Itp96VL+U=
X-Gm-Gg: AYBFou10lJKq3n+pAmXvpoHc/+A5kWeGlToEHOysLnPHuKULqlitRdvLPv7ZJBoomhr
	UEagb6yqKedL5BhSMlbC1mCLk8mbatWzQdjQREEdWbkU6WEFSBz4cqxGohgreyZbhgQSCmVOtkN
	eR0Xwqqkwbnr2Cvihk6jxEbpYA6tvy9yBhCXui9JYWH1aVgJhMVscHAWsiA6VCguw6XzJKIGAuV
	Kne7RYYz8MYgbrUb6rAj9wu05oEYgdjiC9Ln9tKp47dDrZqLO1ltho5SAz6xhTUFwlsMD6qLOEL
	JzaNqg7V92T/5l/kVyKjQncNVMSWeopu1GJSYvrvtz7ym7o0zW7+/ZfTBLPkGKdk+mQAU0jEoQ+
	8WB9SChdlQrbeqdBNd0uHpPEu7ytammqKqrVBdQlgH3vN4qEoXibb+gwY/oZqfeWMJxewYfgGaF
	lNUKQpI374spwWAk1KLLUo4WVEu/qFqKmxYd/1cRXCirwF/gVpF4+d7PiBiu+nfNtPND9JxotWa
	4peQOLxyilb8wR+bKEm8EghGbRvLRD3m6vswmiz31w1ztbWFU0Q49dGWsRTCwDYvV1GnLC0W+rQ
	GrhJ1mWJ9Opn7oPNWZ6+2CYMI8LSdfHbNR3VUKTwtbLkpU0=
X-Received: by 2002:a05:620a:272a:b0:949:3c50:134 with SMTP id af79cd13be357-949995a8351mr551955885a.33.1795021256584;
        Wed, 18 Nov 2026 09:00:56 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.241])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9499b7ad72csm225447985a.29.2026.11.18.09.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 09:00:56 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 18 Nov 2026 17:00:37 +0000
Subject: [PATCH RFC 5/7] mm/mmap: fail the fork if vm_ops->open() fails
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261118-b4-vma-open-fail-v1-5-c8b0209f2700@toxicpanda.com>
References: <20261118-b4-vma-open-fail-v1-0-c8b0209f2700@toxicpanda.com>
In-Reply-To: <20261118-b4-vma-open-fail-v1-0-c8b0209f2700@toxicpanda.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1795021242; l=1711;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=Brz6SAGkDnCqQqo94c1+uUj/Xh83OKfMX4dA7ifQN8c=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QFUlidvx2D8H+HgGdu+TZWRv0131G5scxDAIU0nC9eYxW0cajhji/wabfprNVTsGifiB8fxgdeY
 1HJoRP4sQ5As=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A2E814000C
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: icw967wiikq9opu44p9643tkq8bbe9bt
X-HE-Tag: 1795021261-982956
X-HE-Meta: U2FsdGVkX183tPb9Lt9+c+v1pMxsplWaw3//Tvx5T/3vf0dDfmN5Uj/F2Fxc2ABmMY2zgaEaO4bDEJQvnPOd7d9ZdPSuhnCfcC5xBC0Cfd2OGm4zSvVaJq9DtPB8o/ilw7ZeA8oPER5tsJxMZjMZ9IjHPToRpmkpEAMgOuHvYCAOqpwzTe66IiiZymRGaCJviSPRefbLanj6ZtVIOY73o86gQuZ+hTsVyCNoWQ+65fTFA+1SSV3cq0n+9kSNJFkl+Z4gZUYEFWNI36OMCOOhlH88w1LJujynPHCVT1HFDRcqUcoIweRJTeaJfXQmAUBnog9S/sIGYk4bsszvyfQlnzIGGLHyrE3qW7Jgm7ulgX+MILpSfTmIKOJ5B94MHJlxCiYyc6nCd8eDFLYkqO9SKBDVFIzWgQ0N7XGTyQbd0Y6W/h+053PcdnXPpKvYDqQtvrnG1c91iu8UqsoP6gmJUHop9Sru3XpSDBGU4AZxctr/ZuWozTk1EaFKjnKYnhXUpNzbJu54v6VqPrySrrZvsZLuT5YFHrF3HsuUgkQ8Fi9Eme9b2G0PvCRNSxFqvdYhAhe/SOX1HvH9Q11nrfY0K+nLqChYbR8l5Pe4c6rX8I5LmiSkct8J6QaVmubxz6YqhbrG9zC/a+8h2SiK57BDvRM6zAt4P8+AxkWrQ3iUY+LyfgzPPOoFC/6veHlXWc7YQ8sz2K/OoQR+I/Q+eKIR9/2qOdK0YwoDvnjwYs+qN4cuhBoU8xhbR5R4HoE1tDMVc+rcOHQrpwFeV7cr8lgCGoiUmpRYW/ndibGARodtSUoPtfVxFpuYnDGiIQYA1mNia6leCsdkIhe9ND9si+ZaO46PN0rVIH1FhPoqG8aHp5ymTFMh2BqislFVNFSsXYWaoO4QgCDVwwNiuB7hq5KitG2VbWXZZNzFCmABRf5JbpcCuIHlzZ4iJnAciieRq6YLpcozZ3fiFOoioi5YT82
 dlrqfFrM
 b7I+WAZndgaQthPiAzSKJKuiMp8NVuwxFjX4/HO4+GpLRz6QYCPSc4phnoimTQMcD/FM3s3wsH3rS8sr3G54cxV8nvDlYbKOUKVyyNywfWDN3ag4GUmMTN7CdoSVkhJm6LpF2BN+85YQ88O9NbGu7VdVZXOwyIqf/nfVNScYVqe4Cs8WQ9Zm2Df1MRiGt1V9MW0oFybFZWEt83wi/CE1l+FOuSNWmMkyxll9Uot6g5WZDZKmGB6PFnHkM1fXAyiD5mauAqvbtC6CvMIhah6n66Al/8dmQXcdlutosJNByEKNK1B8O1ddDbWuUPqd0SJGC84SVoO0ecL0lD/26gp8Us9HftFr5rOhFT+4iN8XhkCXtrXk2IZ29+0PzFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

dup_mmap() ignores the result of vm_ops->open(), and calls it after the new
VMA is in the tree, where a failure would have the exit path call
vm_ops->close() for a VMA that was never opened.

Call it just before the VMA goes into the tree.  __split_vma() and
copy_vma() already call it for a VMA that isn't in the tree, so callbacks
can cope with that.  If it fails then mpnt is still the VMA being copied,
and the failure path clears the rest of the tree from there as it does for
the other allocations in this loop.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 mm/mmap.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 7618e72766a5..de7e007d6c45 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1783,6 +1783,9 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 		if (vma_is_hugetlb(tmp))
 			hugetlb_dup_vma_private(tmp);
 
+		if (vma_open(tmp))
+			goto fail_nomem_open;
+
 		/*
 		 * Link the vma into the MT. After using __mt_dup(), memory
 		 * allocation is not necessary here, so it cannot fail.
@@ -1791,9 +1794,6 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 
 		mm->map_count++;
 
-		if (tmp->vm_ops && tmp->vm_ops->open)
-			tmp->vm_ops->open(tmp);
-
 		file = tmp->vm_file;
 		if (file) {
 			struct address_space *mapping = file->f_mapping;
@@ -1883,6 +1883,8 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 		dup_userfaultfd_fail(&uf);
 	return retval;
 
+fail_nomem_open:
+	unlink_anon_vmas(tmp);
 fail_nomem_anon_vma_fork:
 	mpol_put(vma_policy(tmp));
 fail_nomem_policy:

-- 
2.55.0


