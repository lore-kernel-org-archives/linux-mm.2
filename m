Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CA34D277CD
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 03:38:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60CAB6B0088; Fri,  9 Jan 2026 22:38:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 590626B0089; Fri,  9 Jan 2026 22:38:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49C596B008A; Fri,  9 Jan 2026 22:38:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 38D7D6B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 22:38:35 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D431713C874
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 03:38:34 +0000 (UTC)
X-FDA: 84314646948.07.376CD66
Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0FEEEC0005
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 03:38:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QY8Mqddi;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3t8lhaQgKCCQBINGJIAOGOOGLE.COMLINUX-MMKVACK.ORG@flex--bingjiao.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3t8lhaQgKCCQBINGJIAOGOOGLE.COMLINUX-MMKVACK.ORG@flex--bingjiao.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768016313; a=rsa-sha256;
	cv=none;
	b=V1bjmxvblvyjDRRe4sFuF6ZGbFSi2edbOF88ILCQqfw4p1i6Nvhtdm7rsHb4L89jicB/ZH
	AWLsgqlN5aAHZkhnnj82dF0J80ssIY7gRH6/PwuOx0d7sN+YM6fIjiItv+6UUJVuW9ZWlS
	NM9kNdzJf/btGRzJGZMBXTPhOUXFUcw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QY8Mqddi;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3t8lhaQgKCCQBINGJIAOGOOGLE.COMLINUX-MMKVACK.ORG@flex--bingjiao.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3t8lhaQgKCCQBINGJIAOGOOGLE.COMLINUX-MMKVACK.ORG@flex--bingjiao.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768016313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GWx5XWplFY3ByCh+tcD17lzi/sG7paYpqmK7A4jiVOY=;
	b=guq8jyp7kt+8C3nkf0RMv2ig88WfsqQ3FIs+lUN9XvaBeQq7YMRTRLAyX+xtGgxTd/+smY
	qHhU8XNY9M7nR4gOOILzIWGX8oCyI6AWS/K7WvvCDO+74hcCeqGs5ha6CP1H+Fbb3u3jKb
	gxzwuvjV5pz0GMtOsx/wtW4rNyJ4/ow=
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-12055b90b7bso8855802c88.0
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 19:38:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768016312; x=1768621112; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GWx5XWplFY3ByCh+tcD17lzi/sG7paYpqmK7A4jiVOY=;
        b=QY8MqddiX41dpLt5RSL6ajxT503lZGpbIdAJb+pZBAgryHgzhisWk24AZLn3DRKcfA
         UKlRUXi6L927IseJE2YZi2mWzDk74efuGZwbY7ziyc7ECQYDuMzyhq8fhXlqAwo8jMRL
         dbReB0Cmg7f52sTmWAVW3FYN2RkTEkLBD8r1l2y+BS/6yF94ZK5KNyUOkwzD9pIp+hjN
         e0/8mcLRgg23lMUICJkH9V79Wv8wuSW5Yd7I5iuPWEPG1283BQHr90IfOcOMoTmuqPRM
         qNhVP3knYvwsECt4GN+1BKCF6xbdJgF8fIX4Q/CqsYLRLubwmC06DFoqOfEzYLK+hmp0
         CFuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768016312; x=1768621112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GWx5XWplFY3ByCh+tcD17lzi/sG7paYpqmK7A4jiVOY=;
        b=bJ3I97YFvF344o6PnU4FKbJ/Nagyb8cIj4Y1GuW8gtVepSwbIJKQSZhgW5+gPevtT5
         4dSxHKNyvNh+lXlCHQanH0NWlX+pB18El3X+wngUJjuOX3ji0grl+XBg8rKFkSvdozxd
         vpHE5xXyzoEM+UQDIBPfn5iDk2ds3/lO1FgcZX9fO8AgecRL4G0/Wk2IayyeeezS0GOx
         iDTIa6gWe7FbNS8tL1r8xEcfdbu77QVQwx+NP4pgzyuppXJyEUi8zY3uLpi1VOshJg9T
         VHvEKEdHhis0SH6WnBlTSH0Ip2ifsb7WIr1m/6VIPPLFLfV6R7LRWAaxLj3D2I2zpsn7
         Adlw==
X-Gm-Message-State: AOJu0YxVah4KwAkyHCqyj1qFygSwPhwCa9jH3VxaEDMb/CjN/WvygZdQ
	k2ESjkWGrCnvU8Rm0XWix8mLWKyjCHyf59Zo9gJO6AapMqbzGTO7I0cL8LOga4KHv3CtOetqiBF
	yXjRiViOL51O/O1YrXZmlHTl5th+sudIRjGCNA/VnGWlm5FUPGhNqoJA5whQsSv5apERY95fZYZ
	bTwyNKscgvPhliVYZJXkuXq5SdJhC+i8UFicczYbNQew==
X-Google-Smtp-Source: AGHT+IGcgX3ukV3LMDS1C3Tgs3ez4As8aS/ku3irV1SqXJaTqgRC7fZUP6gYVaVdSJfn1NHuFVcSextxpmvEeg==
X-Received: from dlbdm14.prod.google.com ([2002:a05:7022:6b8e:b0:119:9f33:34ae])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:985:b0:11d:fd26:234e with SMTP id a92af1059eb24-121f8ad1c59mr10024716c88.16.1768016311365;
 Fri, 09 Jan 2026 19:38:31 -0800 (PST)
Date: Sat, 10 Jan 2026 03:38:21 +0000
In-Reply-To: <20260108033248.2791579-3-bingjiao@google.com>
Mime-Version: 1.0
References: <20260108033248.2791579-3-bingjiao@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260110033830.443638-1-bingjiao@google.com>
Subject: [PATCH] mm/vmscan: fix uninitialized variable in demote_folio_list()
From: Bing Jiao <bingjiao@google.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org, gourry@gourry.net, longman@redhat.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, tj@kernel.org, 
	mkoutny@suse.com, david@kernel.org, zhengqi.arch@bytedance.com, 
	lorenzo.stoakes@oracle.com, axelrasmussen@google.com, 
	chenridong@huaweicloud.com, yuanchu@google.com, weixugc@google.com, 
	joshua.hahnjy@gmail.com, sj@kernel.org, bingjiao@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0FEEEC0005
X-Stat-Signature: znowa7wfjbju57e7ggecmaop694ghrnc
X-Rspam-User: 
X-HE-Tag: 1768016312-261947
X-HE-Meta: U2FsdGVkX18Uibmaooejd+5T0ZtfW5vYeGFqg/m3Q0+YkukgvR5UAE9VbP7L7duWWSbm78GWKRpf/afmW0G/peEoiIWuvl8SAW0AH0RuNEAMI+4jjvfYxhoVheiWEK3oz8UQ8A8mwNKJnpo1F8x+CsmsCM4vSU72YrO/4qKEgWtuRstxMS8mbyae33n4WqlKagOKbwnMW5VppcP7N7+AADybOxmEqrd0VpibCr2dl0XKdrfQ9IX5w0KMrHmUcDaVD8sy7+4tfKxbkzy2t39aETDeq1c4pYs3pKV6g9qJf+CojJubIjs9Nvsgm15xbz0nb2axD9c0Ncsoip3iKEzy5SuPrE1+veR5jfN5u4zL77EKRijmC/DT94J+BXW0N2jroUwzKVlhnvl5FQlVRHZy1ENttNk4CJ+Z9LWiZMMtOD9NIIbnJGfFEYeBJeoz4lD0Q2UPkfXteYdqatkN1E7EaraAz/Nj569nwaFclmsCL9EYzR+untU5ivQ0BYzWq2mwHxU/5ErWA2bNFtNIU0U//+azqWYAxgEoxEHW4umeFtiNH8vITo5mx3P3arWq/bBf1Z+/+viuI2Oig+/nLWes5W5ccXh45dN4MTft7Q5bz93Oa3/euyl0ik0y6tF6usEEvHIi3vW+tyx29Uy5ZLA6uNPB8LoU5J2/N4Sqf+k6NbznIdtcHOYfw8dA+xZK8zSTF2swF2o0SWaPBsQ9U+km0hX9mtHec4jEZRfkUd4bYxHUL5/VtfGovhPewjlsJDOh+Sl0FXzfD+LIztzgjQLYrSprq4DVBQZ6ZKzBvGMZ0MxWYZvm/UU4qjU/OpkUiY+rZW5b+2ZxGnYCtOT36o8wqnS5iZZUNn6SWw7Ov6Oaej4Mj79axcYuhYDzxISSO7RGwmjwwcLC0IcgpVucqN4cMZRcmE3UsuvO04bNvmqRXZljE3YA4n9jG3NtiZnox8j4JOwX9usIpXbaP0DLaYx
 +dUzGe3g
 Wcmeq84QdEZAwEleb5/3uHjL85P1C+7qwfZX8oB7NUdvFS47v2vAFkM4tfTsFrlmb5JrFoF3EMHuk2Qs8b037jNTTbvgCjfMLvOTABXT4+NKmsRmNlPSr5D51wYP16QeR4Ng0OWdbN2RTdodbRmJWbIBr6EiJH080hfoQMRrzA/STGDxKOi+KdMdHA/xMOo9fp8gnL805BMJVprb/mkppb7V/WmgWL8FAX031nKKif/4wQYny/E1P4goARbyjMSmNsWiMh976PYq8Gog+7fKLy4s9LeBpm6ymxPIddaGbtXE5L+OGvtOSLjGK5Pggg/Vm4DqwcQ9foVHI4yPweQG4YMQvMW1js8umSuEKkXr0797trMRmCXc+vrj+VaUZLvTzR5BolVUa5rzFzOEBs6jpKeO3KHdZlnIJWQnjN21W/BM8lErkkdXC6NDZhR1aj9MNkcRBOzfB4IEszFrYLqptmhcmeXS38hVfYhdSUs0KoD3m+SGpm+ZiPX/cDxiQ2oJEoQNkOcSKKtyQjTMnjqtlJdeU/reAHPJImplbIW3Fx9obNUXlHGYEs9UGeHRWz076JftTtxXN7TCNd8Zu6JgqXIJ95EpBfrtIqhHuiWJ3+QNsaoYgPacl3mEUDAM/49L5oS7kYGl0DWmVC72D9uWbuYnpQc1ttHD/WgEGiVuNR18tS7G+3lZp7EEp3xNZ9IZAOEc9/jbxxJjiZeJPMR7V+8qqSQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit d92027a5f30a6c ("mm/vmscan: select the closest preferred node in
demote_folio_list()") refactored the selection logic for demotion target
nodes. However, it removed the initial assignment of 'target_nid' while
leaving a premature check for 'NUMA_NO_NODE' in place.

Since 'target_nid' is now assigned further down in the function based on
preferred and allowed node masks, the initial check at line 1046 is
redundant.

Remove the redundant check to resolve the compiler warning.

Link: https://lkml.kernel.org/r/20260109055937.3739860-1-bingjiao@google.com
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601091037.vUSHeJCH-lkp@intel.com/
Fixes: d92027a5f30a6c ("mm/vmscan: select the closest preferred node in demote_folio_list()")
Signed-off-by: Bing Jiao <bingjiao@google.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
---

Hi Andrew,

Sorry for bother you again in my patch series.

There is a broken commit in mm-new branch, which is introduced by this
patch series, Commit d92027a5f30a6c ("mm/vmscan: select the closest
preferred node in demote_folio_list()").

As the broken commit is currently only in *mm-new*, could you please
squash the fix into the broken commit before it is pulled into
the mainline?

Thanks for your time!

Best regards,
Bing

---
 mm/vmscan.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 213ee75b3306..590ab3ec1998 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1044,10 +1044,6 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
 	if (list_empty(demote_folios))
 		return 0;

-	if (target_nid == NUMA_NO_NODE)
-		/* No lower-tier nodes or nodes were hot-unplugged. */
-		return 0;
-
 	node_get_allowed_targets(pgdat, &allowed_mask);
 	mem_cgroup_node_filter_allowed(memcg, &allowed_mask);
 	if (nodes_empty(allowed_mask))
--
2.52.0.457.g6b5491de43-goog


