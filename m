Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E7E4CD5BCF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 19:05:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E168B6B0096; Mon, 25 May 2026 15:05:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEE486B0098; Mon, 25 May 2026 15:05:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D066D6B0099; Mon, 25 May 2026 15:05:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AFBA86B0096
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:05:12 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7F565160AAC
	for <linux-mm@kvack.org>; Mon, 25 May 2026 19:05:12 +0000 (UTC)
X-FDA: 84806870064.05.935CA0F
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	by imf12.hostedemail.com (Postfix) with ESMTP id B12664000D
	for <linux-mm@kvack.org>; Mon, 25 May 2026 19:05:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jC5MS5rP;
	spf=pass (imf12.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.43 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779735910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DQ36US7aEGO2e9MShcKJGWBIzONamDGB3D8ceYmvI+8=;
	b=fm9mH2mddkFwjQjy+Wp8WhasKEAdAI22j7PR4nQowAwxU46xfCzkQwioOtwHF6+6n0be3G
	FltewiTg6tHShkesOB9tMiWB5nvYfmTl6kTjDDqdny3b6Hoi9rGnHah2SwqA7NeLaO6QHx
	vCBmuDEPcqWywLEh8qVNJx17H/3z25A=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jC5MS5rP;
	spf=pass (imf12.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.43 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779735910; a=rsa-sha256;
	cv=none;
	b=UB/cP/3B0cwHUMipTVLrSb/7JR7Omo0LtSXwlG3igrYFIOMCdYhL/1ePN9ARbU3DSS4SFq
	Ouwkzk9bX2Q4OVvIyH8sFcCnxE5JSZv4x7MaJpVcbh26wOHMqrjnTtjZGOFBVflK9tw5bV
	CGBpm9lLJrWX+UcMNPLhR6xIpJF+Me0=
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-43b53f048beso3169888fac.1
        for <linux-mm@kvack.org>; Mon, 25 May 2026 12:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779735910; x=1780340710; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DQ36US7aEGO2e9MShcKJGWBIzONamDGB3D8ceYmvI+8=;
        b=jC5MS5rPRhTPiVJsIc7wIbfaqYUUGZtmtTyDANaASm4GQHZmZoStHhQLqOT8ajFRjw
         lRuka0+RHucZK6GIAlcZ4xV08hx60jjFKMRCTDOzrVw6MZ0skfY8kgvXVIq3r+KRuKj8
         JJcnuOGKHQWIoM6QPqaVcyLEwtr2Sqg3eV3Y788fG5wfActK3TNuRjK7vSS1S3VoJ/eE
         qKavzEBXKh8dbibAwIblX+i8rBwclJt9BohjxkmB32014RYHkDwYvGDo3eIhwx1WFSIK
         TjYt5+oj84DC8HJb6KHOmP/FiXC5cBq6MvY9sopWq5XgmrxjzKGRUgPK7aUcK2HMy+8h
         QFkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779735910; x=1780340710;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DQ36US7aEGO2e9MShcKJGWBIzONamDGB3D8ceYmvI+8=;
        b=T+HcXmNKf8cwAiSUFNEB0wP355nnCDg1p0i+nNWOAvDSo6y749qj2+SJjJvxDgPO6s
         kx2xbcS9+d71BlJtIcKraBkN5NPIt6M6aBc8HIk8yfovd41ue8JRgFlXy6k105Li+EJO
         BdVS+9sGyqUWSSjkvoImwmCNLttFbFEjW0Z6yFdrX+XM2GeCQXcIfLEXoX9xoTTk3+74
         /R8un638yUTPsTADQZv80UcpEdlFoF536GH+NEmnnRmscMu7raNHyZanJw6PDRIbBMRo
         Nc6EjFgo0oveDTg+dHSKFbXRXMK6bwgBG6NhYitNPDrqW7pCXR44OW3YTZ0no4RBNIKV
         KsLw==
X-Forwarded-Encrypted: i=1; AFNElJ9iIwL5fhDGPAld8jzaUg5aRCTKbNFihsKat9IrDiJ2TsuhWXtfU9c9IWispd0XAHYjJjw9N3i20A==@kvack.org
X-Gm-Message-State: AOJu0YxsfF8n2mIg+33HASvod/pU4QRpcoILajlyKaMa7HO2uq7B2bYk
	H4JHhiYke73xLGJ8x1N+yDUAhkmY6Hk65Hhyxs+UyRFgYJW0thXjvul0
X-Gm-Gg: Acq92OE1y1REg0EXh2DJpfV8z89zhfuDO8mQYG5Z5jPjqQkqMSHtQ9GndCNY+boYOAK
	7Jwant9P3cTcn/qGCSD7CXENN9fj+hppdZj+to9f/57LbJiBaL9dq1AmrWyZvpfr1s3N3Ta04SQ
	T+eEA9Tz5hXhbLis53wP33/lsOBR5l/gDySvUX5TRLZ2KSoQ1LfdHCmhoDyruf0ISoyVxfx7XNG
	vM5f/UuMEP4uVuewJab943vaBgGRgAP8jTSpFS0F1pqbb5e4IV07Yizu+faY2lFtZRIlQaZpmv4
	0t4rI65xqw/lutfkq/h8ZQ3TSqaCHchWUakiU/L+M3G7WIgCwdlv+wiSL907o9UnG8ioXXuQkSY
	M+TEr5Bkq52E7/83bz2s6eO1/+0gKuOKn19xKrM3avJ1qxGDNwViYJixrY87qVFAtS+XntJq+ys
	AxRHw5jZguVynUP+AvVHc5QGRjW8DWc6v7QPy8Vo9TYDEC55MHJxpwzQ==
X-Received: by 2002:a05:6871:3291:b0:43a:60e5:21c6 with SMTP id 586e51a60fabf-43b2fcaa33bmr9336295fac.24.1779735909636;
        Mon, 25 May 2026 12:05:09 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:4c::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43b635d26b5sm10931436fac.6.2026.05.25.12.05.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 12:05:09 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 6/7 v3] mm/memcontrol: optimize stock usage for cgroup v2
Date: Mon, 25 May 2026 12:04:53 -0700
Message-ID: <20260525190455.2843786-7-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260525190455.2843786-1-joshua.hahnjy@gmail.com>
References: <20260525190455.2843786-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hxxmiy1u6jdct5fguyasfj57ozfwy6gj
X-Rspamd-Queue-Id: B12664000D
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779735910-434147
X-HE-Meta: U2FsdGVkX1+/USqNXDDofTrTmlJV4RMIkj5fg6z/xDIey9C5GC/+OuOBP8cI2um2XcZVXo/tNthIVZc5LpG+IeXmIIHgV/Hq8La7TNQtXPNdealQyMt43Em0bCopv0nbFf9akatiKDZTetCnYZqC98048/y5VErbQKHnFP8+5tbv/gx/xsABSykWs/jGIX2mHbUwVr/MbAdQRWvBGoH7r4X49Ew6nr2BVIVE54CpIQvDLmH2SXjUf46m5tvrnP/hwdBb+V3FS41cdfztqv0av4GfvzSeSFy/qYwu5M0545Y0QFEIQMJ5GP8kLDHzmk2lxngTQXBz50zAk8j4qpm92sC5THUmkiN4sGSI5jUtpU91qBZZzpEvwStsO2UWcVGR9M1IMRJuvl+uX7mgGFQ8Q0jVjTgyD+FHEfmXnGYVmRENBOWsUOTQKD8FVAYk53tlfYLKK42YE9CXNplhyPuV0LhSiMrogm0ZSBiAFopym5Ingh5V4RiIYKyYkZXaBxw8YRO86JjukhI2xIjtPCMhXIeqgMBBlOGDcb+5Pzm3Z58Rx4wovQ2miRQ2Q9BgW02+1XWpuOAJLo92Z8WexAWOXBrdU/se17QZMa0gsDupd7+ah4SF62QmH56UBovss3DHjdZsb41EGpakOTbj0AObitZiRPUHuDFPnfjG9rhEiHKZZo7quc+8frFgqn4CNOu7EtOI5lXSwCI/SUzqPOdnWFh1WPEH0Rno88EwEM0fJbX3s9gmlvNL4xQqs/aF4/9vB16u7tl5QalHOATneQvoXuc2SEviDGpvsZ8P5QU9/jSuv+a24rfpswwsLoBenCxaf+YU8zRYK26RtGZduDQJxrLQr/onJDWo0xI18RNfEHRtoVHZ4eRIwl84pojbWfp9aMoadX+pJ7dqaBhbOoZOWXJgj2jDf2PR2H1jvw19M9gnm+pWHMix3c7I4hpg3i38jElKx2RmeLGlNlzlXfb
 cGI0T1Uk
 fk8zJS7nM56Oizee9u9SO8dv2MnAoAqdYwkMU22ZruKBao2nImh03PaG4KTstM6LLwM9mcqdmhufYU+HAxvG8opZRYPoRz64cbSR65NNAVyU9X/7D7o6huY9T4DzXk6lSXHDfts9fHUlg3T9u1VXTWwBb+21D5Eekm1enWNXyoIs34wHg6qM0mW9oesfYeSMJ3LBM9jvoOOs4VzMmszDobAga/s41jFtIeNccTuXKeql09VPMpLJ+bzwlIOvA/WBRPRa3ASAUZ1/d9gZjnCT1NRh2PUZ470GuSuvjeN+AXNgONZqro/aaLTbzJifvMHbS8tjF2r6LY7PzVR+s40wpmjLJIpOsl8cyGS4hSVg1wK2jGCDsnwsO+C+cazuriEI8XqcPxCdtwLx9svDdi2Q/+FCbjyf3ipJYernLkdc0sCw632Ufr4COgW3uDP0i1MilYwbCYYZO0vsVzz4igDeAFJ4Cftks2ZDxbWucfRlrBzjYkPsDGG0HNpY4pg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In cgroup v2, it is unlikely for memcg charges to happen directly on
non-leaf cgroups. There are a few exceptions, such as processes that
have yet to be migrated to children, and tasks that are reparented on
memcg destruction, that charge to the parent.

Because it is rare for parent cgroups to receive direct charges, stock
that remains in them are wasted memory.

Drain parent stocks when the first child is created to return those
pages for other memcgs to use.

This optimization is not for cgroup v1, where tasks can be attached to
any cgroup in the hierarchy, meaning stock can be consumed & refilled
for non-leaf cgroups as well.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f20c9b829224a..64b82f1782720 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4280,6 +4280,21 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	 */
 	xa_store(&mem_cgroup_private_ids, memcg->id.id, memcg, GFP_KERNEL);
 
+	/*
+	 * It is unlikely for non-leaf memcgs to get direct charges on v2.
+	 * Drain the parent's stock if we are the first child.
+	 */
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
+		struct mem_cgroup *parent = parent_mem_cgroup(memcg);
+		int cpu;
+
+		if (parent && !mem_cgroup_is_root(parent) &&
+			      !css_has_online_children(&parent->css)) {
+			for_each_online_cpu(cpu)
+				work_on_cpu(cpu, drain_stock_on_cpu, parent);
+		}
+	}
+
 	return 0;
 free_objcg:
 	for_each_node(nid) {
-- 
2.53.0-Meta


