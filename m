Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73772606A327
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 07:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=lEAW2Cgq
Received: by kanga.kvack.org (Postfix)
	id 6F4806B05C9; Sat, 14 Nov 2026 02:10:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69EEC6B05CA; Sat, 14 Nov 2026 02:10:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 567626B05CB; Sat, 14 Nov 2026 02:10:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D6856B05C9
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:10:42 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7F5D380130
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:41 +0000 (UTC)
X-FDA: 85432851882.26.153C1D0
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf04.hostedemail.com (Postfix) with ESMTP id BF2A540006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=lEAW2Cgq;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794640239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TW0pg36vCDijleVRTyqZR6UjU0iehYYk3FdVNC+q6Cw=;
	b=5wT91Cf698Dnbr+YeEUraeLcpZaMVpZdaMGWkFX9Kqy5dIlJqy6sGjK5jZ4pjLnaObQxnk
	tkK6ajYFUzU0Rynq8yUihDW8hMmKi6cKznXxgzP4atuA+GJbEwYE3lc9G/G2ApHzsiS1pk
	e+2JyRdX252Uj7VTxtqkZIaE6LxzBbU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=lEAW2Cgq;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794640239;
	b=vcx/1SKhCWwYKrbpigSu0ZwXII6FQZwVpf2rJE/kF9XeCp2F/UUnYid6By6kesQSV+cUxe
	nmc1tmf7k8CqjJdmDuh2UqSo1hHIpcQISg9trMjYWwHwqXQsJUgxBgoYz0FmefmtTXpyc9
	0mORQ0F8t0tEpaiRAoJLh23MWk7Is8Q=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-91ef011e338so29793596d6.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:10:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794640239; x=1795245039; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TW0pg36vCDijleVRTyqZR6UjU0iehYYk3FdVNC+q6Cw=;
        b=lEAW2CgqNLmeMD6Jr2mVGjargYAEpReTOjDmOEEdoTj775tbOdqbxZVQtoaAQplu6P
         smhZXPDg5FF2msfz9sSwv3GaJDPAuNfqkRxfWOTzW5+FuCtOWAHr1XEeFxVSQ191ULKK
         Cj1HhIySPPn1gzStHQisbVBCXBT4pzTPrgQ9cd6lMiJ8HxIHCPNbzUnJtJzAlcYT4REe
         S+xWdNzYKIOdphGKZddXQNg3c7B/tQfmX/IM7pusE73OregCde04CcgAkDWkb+PK029T
         OuWRLX2keyga6xpgJDahMlaRbxF6pk9wLg3FHdE3h9rui8m27GDRTP/ksz4xontvbMF8
         YAEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794640239; x=1795245039;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TW0pg36vCDijleVRTyqZR6UjU0iehYYk3FdVNC+q6Cw=;
        b=BbRi+kLK2QSKtzXjt8UouDwhnf8cBl1CwG6su7zCGBUUZY05CBd3Dj1cVVqOCeY1pL
         8YFfwIaw+m5RlcLomyzFz5BzS52TmWqLdxs1d/MPYwxUe4FsUWs3ocduq7lf5RAk6zNu
         tPRrm8+l1yIFY4Vk/0F0D5wuEMD7yWGTxsMgmlEQJDlGgC2lPo4xABewrz+DEy15wYcI
         UaQCtSkH9XSducTzMXbkkNHE9RBPIocmQOzX7JlKtlU2WCc90cHhMlkLtxTarKqZO+2U
         66qWatccnUjvFXYiWaFnlSmeIN6+3nh6rQu5MDQaXumA5UdVoDGyotAtsQw7coJ9zRoN
         1T5Q==
X-Gm-Message-State: APuU4Z/P3DnWu3Ut6/XEMUZ1h/SQ6Zx8kTHgwcj46bJd4neIATGhVuzs
	0gsaaoxFbCSnm6CYBPlcxF9VbuT3U44Ic/iTrQle3RvFgUYqw04Qlpz/A2jYaF3BCx2qrfx2iPW
	pgCZs
X-Gm-Gg: AYBFou1Dx5ghaktfD4meA+9RVxDUI/qSy2Z104Lwkjs/VFRp6EPJsxTbxv1PfrcCfaM
	gFkIEhZOJgggdZUb7Hf9/aV2jvHgc7eeY6kCvLI+9S8IsylwwuO1y/zlC1UNgcfHhFfZCAAg/im
	wy5lfXjnf2nx/cgltmu4+4tolR/B25r6xBemKYhHwC9RZPLNy/Y38C4w09HfDxseWGvrmqNDPH5
	7LC5lJz4GgxxUgv2Pj16qUh2sOZ8Cxx3aHuMApNsMBkNgnMEe+jDvoO+dG63ANO3VNeltGCop2C
	aduOIH6174YDhz2T1LXQevOQ54uvxeVAj4LGLbm+VMXahuGiImFWugZKMNu8VTAWeGts5K11C+S
	m6EDMFZRQFfCNpEdIHZmTv7Ek2cjEeNCfCdbw8Htq4fLm2ksawAZyC8sq0eHKcUg0bJ6/1JJ6b8
	NxjuHZTH53RqqmdnuBhR+muB220964+NcY4JcBi+y8/wNvTWH3hSFmoJiIqALuvxmxQFhScmcuL
	aL78G4DX+yxXWhsGYatmSPYKHbO7Mgv9dTpEke2mMS0vYZzcsX7/E0sjwzWKsjfcLuFGJz6C3ok
	WGVCpeFqYbVY6mTbggIApdFNRE0XZ6aBIbk7CALK6VQeJLzULFfihMXQHPgbm41pzOACqzx4cet
	GqCpzF/OnqbL0v1WFIkh8dZyt3WBLeKcjIm0c
X-Received: by 2002:a05:6214:1311:b0:91f:2208:b683 with SMTP id 6a1803df08f44-91f2428c6aemr76715686d6.55.1794640238785;
        Fri, 13 Nov 2026 23:10:38 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23db3a99sm37730986d6.40.2026.11.13.23.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 23:10:38 -0800 (PST)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-serial@vger.kernel.org,
	linux-pm@vger.kernel.org,
	damon@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	johan@kernel.org,
	jirislaby@kernel.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	pavel@kernel.org,
	lenb@kernel.org,
	hannes@cmpxchg.org,
	brendan.jackman@linux.dev,
	ziy@nvidia.com,
	sj@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	matthew.brost@intel.com,
	byungchul@sk.com,
	apopple@nvidia.com,
	rientjes@google.com
Subject: [PATCH 16/22] tty/sysrq: use common memory for the manual OOM zonelist
Date: Sat, 14 Nov 2026 02:09:53 -0500
Message-ID: <20261114070959.3490008-17-gourry@gourry.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261114070959.3490008-1-gourry@gourry.net>
References: <20261114070959.3490008-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zimufi3n6p63nd6gy53t9oen3f5c1ryt
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: BF2A540006
X-HE-Tag: 1794640239-693703
X-HE-Meta: U2FsdGVkX19fiMx+W4TBjnDFOBzJdhCArUvaouihUMm9jTfIoH0qxPM3VTEQ9v+dAD65LMrjIpqtQvOH1fpV5KBBcG2Ez82+7dNmzimKFHrTzo4kh4AEa+l+fIxkXDqGu1VJc29KutRARXWollmz5EOeADKzfp54psoJlZ+fRpIB4AILKUgQlVK12Q0LUMUPxS4KWt4pKr8SyDVOa8PjWMxc/zeSw7C318CfHdoDWiL4qt8Kkq95fpmjyixV0VR+7at7+njCaCClEGpt05MIJ3GphMrf88jVm62+yud1qugu35r2W+Ito3qZYQ7ni4jVNHbXv/InThACdFfwqGefDXxOOJNsKXzKpuGzpoG5JQaXSL+uZx5Vp9P7caFewaE7wCgCJHgY7zPrdMfolELTLW3t3e4yfw4JKksMYf+ZbhCuNEoB8jHiijYi19iikVIg24aVn3d3MP6UfE8pIYQht6WVGTUyeWbYd9Xo1Efstps9fzZyhq92+9EQabpFJG+tls4dNITIiV7eMPP6+6X7o6T7oHzq9ai8DJXfyu3tbBs7HI+1lESofY6Iib4tNWJmkMbF696hw/3w8CkgGP7xKJ+y+jM6l79FHPEqrNGe+0fJxfRPljO+4mWwqg7Sk5hfYk6+3N39EuGyvViXZAoxsiLdzLp1EviqGbNNlccYnuF4lRFIPYhl9D48qIyGtx0evzbwPOW6j83n9RgMCM8fmvK5m88/gujqwv/kU7mjTPNzaR4qe+rVT2+RAQgqdIy/YGmi7gOcIHTeClm4fCHBDV1Fz5R1UIuq/IEUMBkGrUDRFtE57Qn8SX48sZ9nSEWRoSgBjSZJmGwOTEGwsKHmFmjKOkuqo4o24eKCMX0tOXB8AGP3oFgxcOTfg2C/s9Ch4D4vPnSarhdmeIeV2TI047IQwQuiKL1BBgVjtF1xwNKppJGEY+MmsJn9dTvGI1H1OpSbjoev7Vq+1l+2YrG
 l/pNjzjl
 6K61AFd0skrfiy0ljeT5NlLxNHP98m00+VK+CgIvNxbZKgMex7Ip3zwxllN0VDxncVmvq7gliyCXvwiADO34inqhvs4aaSnI6KOb+S29DXKQyd9xJDvzKC/7dqQ1zS7OJyP6Iez/BCVsO6E+iMtjBjTVLyG9EWKlGixALXLZXQC69gqIwP4CeUIBEAXaU3BiIraESOYKRJOLqpJMhiwnvQtWSvR3k5ycNMnWffYHJDfQidcXcccYPvySm5tlerLSZNf4IkHEF5sSzC2GiUpJN2tetgHaDPgMCkwGPgYhhqfsdDNqdVQmpFrSygJL4RIH4hbr6RWq5kRb5HcZfFTS1oZgQweFxcOsNJFuzRnRKuTw77NX2K+kKXBZ8ebz54iP81Gjc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

SysRq-f constructs an OOM request with GFP_KERNEL and supplies a
zonelist for allocation-constraint checks. The request represents an
ordinary allocation, whose fallback domain contains common memory rather
than every node that happens to have memory.

Select the zonelist from the first common-memory node instead of the
first memory node. All memory nodes are common at this point, so
behavior is unchanged.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 drivers/tty/sysrq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index f4571d05b4962..824f5836b47d7 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -386,7 +386,8 @@ static void moom_callback(struct work_struct *ignored)
 {
 	const gfp_t gfp_mask = GFP_KERNEL;
 	struct oom_control oc = {
-		.zonelist = node_zonelist(first_memory_node, gfp_mask),
+		.zonelist = node_zonelist(first_node_state(N_MEMORY_COMMON),
+					  gfp_mask),
 		.nodemask = NULL,
 		.memcg = NULL,
 		.gfp_mask = gfp_mask,
-- 
2.53.1-Meta


