Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D544CA0EED
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 01:34:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA90F6B009E; Sun, 24 Aug 2025 21:34:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E80F56B009F; Sun, 24 Aug 2025 21:34:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D96DB6B00A0; Sun, 24 Aug 2025 21:34:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C7E026B009E
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 21:34:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 569E3B6C1E
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 01:34:31 +0000 (UTC)
X-FDA: 83813559942.28.FA26B70
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6E4BC40008
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 01:34:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TtFHcNFi;
	spf=pass (imf07.hostedemail.com: domain of visitorckw@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=visitorckw@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756085669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rkTHcDw+15jLqpjUkSNwi/I5M5nWONRiouVZuKjTmL0=;
	b=c4NPNDHFCj7s8QzdsQzwKmnUNjxdOvWh9th9OeBuqPtJxWAZXYYPYU8pRhKQk1pTtgRb0h
	P5pgQUh/Tl+sxWEDKqHm5bPvJHql5YDUKj1DpJ25Ffq4E5DHV3tT3Qw91OKZfT00aCAEU5
	bDXoksRl/+qeUgOApOp/OHEUgAQlemw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TtFHcNFi;
	spf=pass (imf07.hostedemail.com: domain of visitorckw@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=visitorckw@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756085669; a=rsa-sha256;
	cv=none;
	b=qWIaQuqbdqLp2liEy0t+1NyV5mPPV7026irlMlQKaRowwLh+0cArB2fP1AdlITZ+E5XPsl
	AVBcyby8abngei90o8VPNVLfxzLDEuGSrNGMwfjZfk8auOA+pPlqtD39wF4xcGRS/SWj33
	2TTo395F7iee7cymHP8jap6E880HCzg=
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b4c1ed55930so294529a12.1
        for <linux-mm@kvack.org>; Sun, 24 Aug 2025 18:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756085668; x=1756690468; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rkTHcDw+15jLqpjUkSNwi/I5M5nWONRiouVZuKjTmL0=;
        b=TtFHcNFiCQiiSSL8AKEKbjIL1O9RCFrVz/hmyRPZ+GU+Q4bz/daG7VNKMoJ4JnvRNt
         7pVVaFt0BpYZdiHPOUZk8D/3MuvxTHV5z785BTdFTkKUBlTy9Q4NUBtLuAn51GnI4OEK
         xz2M+q1DdPKAqZeN9Uo3r4eBdTKQjkLBRJOEevHyF9PKvs6tUD95QrTrtS8vhB4kf2+G
         7sQEA6hfg0vB/JcQfr7urzIs3pyuSdFhZ3EXCa+HtL/TNF0HpPU15zO8j+ox+AScnBO3
         WLc0FXL1wh3PnEEb8LF+0gXodC2iQcWH3BiRL4FUj0m2AdLLW+eE4hVsyo7TlVRoH9VL
         4f7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756085668; x=1756690468;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rkTHcDw+15jLqpjUkSNwi/I5M5nWONRiouVZuKjTmL0=;
        b=YGcCAAEo5YaEvWjC1r+GefKAZcS2/nY0rfjEjf7C5SpbPeqcRBkzrTz5YQeBB5X5yr
         O8EeOhZ3BsN5FG5RxtGz3QWoO8lyG0OcB9XF/Yr4K4bj3lnfC+5aiEAwIRX4fCL5XzBi
         mQXxubYoeDWPxxVZMM/NoWKAqaEaV+edMrbPuK8INxKp+cOzuPy9VMr9t0cRPWcFbMFx
         91wY4N0fCIZV2W4ReadjsPAb+uXGDcNRWBY5Pi+kyJq7XygPYZmsVANUdnhaUjlzu3ZJ
         xBylHRrrp9iQGuFfxx75hlWczxoGbu3yKqgmh675gcmFarLksKF9iqR2WAUH+zO4hxll
         2AOA==
X-Forwarded-Encrypted: i=1; AJvYcCUITR1Ddcne+L55Azl4LE3bpPdRvcqnEBScPZLcp9/8j6qTbkGj5ynjARFwbqriUeVtO6Zr5k9o5w==@kvack.org
X-Gm-Message-State: AOJu0YxA3LzUKHSVGabiUVYJiVEO1mq5ROS2uDH9EZgXZOubdKF2peUy
	o0M3hGktb86u1/z7Per2R6ciwgBydLYcuXd9du4CYGB5qyOF2LtfbO1q
X-Gm-Gg: ASbGncuwjrN0xbl5OUzOfksC7sXERFOIPqPnU+z8jCixRcBkcYvzahsXs+9q/ExcJ2H
	5Xl0PzrzOEMTn/a1sfnXPe/3BIz1o1GJbuqasHwfwzOrrtbqKj6YPcNQBUznuuwqmLNUaBeaHcA
	sXNfDsze6daQrfqoPz1H6FuTmpY6khqqNkUAXoeyMICCpXQDmJlhmetX3bcwSpDwMSlGuk0abNR
	5E+EVa9VSuJU4aie0uUii8tYVc7Ku39Ca+72A4EA9uE8SHxHsMIc9ood6YoRnibHVbBoTqwdkKw
	kFDBYk9f5xB+nJDSFlyfSSSqj4pLZzwVa/vJgXiPxKAA2SQNjla/EJXdAVpjf56x+mTjgKguq6w
	53xU2NuRnEFxVRIzxG90yLSdmEmckllHRpFSljB3rSCz8mnUgS/jcmiiKYKVaI6M=
X-Google-Smtp-Source: AGHT+IFPavs3Bbx0Gq76QMUc0UeeZlDyoP1050rv1eo9ReYKCveThRPf7S+53lCd/VHSMwZ3zX/UsA==
X-Received: by 2002:a17:902:ecc6:b0:243:38d:b3c5 with SMTP id d9443c01a7336-2462ef1564amr146801935ad.47.1756085668240;
        Sun, 24 Aug 2025 18:34:28 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24668880a99sm52425995ad.121.2025.08.24.18.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Aug 2025 18:34:27 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: vbabka@suse.cz,
	akpm@linux-foundation.org
Cc: cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	harry.yoo@oracle.com,
	glittao@gmail.com,
	jserv@ccns.ncku.edu.tw,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] mm/slub: Fix cmp_loc_by_count() to return 0 when counts are equal
Date: Mon, 25 Aug 2025 09:34:18 +0800
Message-Id: <20250825013419.240278-2-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250825013419.240278-1-visitorckw@gmail.com>
References: <20250825013419.240278-1-visitorckw@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6E4BC40008
X-Stat-Signature: 8pufhxni6k7ez8ray1z7coe1pe1m1xee
X-Rspam-User: 
X-HE-Tag: 1756085669-452512
X-HE-Meta: U2FsdGVkX191p8hkVdeF12F4tyY20G6FfdthmyeMMDAShjDh3CSogvQvdqZMptr0LLl2sbVNfxdbPcOV+XvQ556IXtuNE1yKD1Jv/zqFOU21Z/a58FBNyL9kGhHnKpdbc3e9LV2YipJHOVDHCNCk8npGdXiq04ozQC7pCgUkI54tDEdnobYcpENPRt5behHoh19Zfyw42kRMh+ofOoKrQNqlDOs9M6DTqiN+Ijt+kiPVxUlx2W5IfNn408MKVCUl3aLV0H+Rj32GmRTRdvHcWZJNj60Ic1HnMXWEEy6jW1iJTOh8j10BsO4eiOAkoruMwKG8RFC26GTewJzMgzzAD4KewlrExclfTRCpwSIQpyuYB/PlGQnZ+77bico/CQUfAdwMHlUx/YuOOfdcdpIWCmtmvdlk1+WK6B9ME4x1SU2YoUUJn61uAkqREBZHHg1chqnE9fVHSDdGt4T6j1n+7myXpR6ixdfWdZXnj1RK4XVpuCL3JCSziPlcVBh/xKWIC5hHYBCGVv41oW0GuUgBTm7YS3gDraf6Leh3IkiEbHYPITglF0WPTCntAJWw9nKmaWhGIBLYFgtsScbdCN7f4gZmiHhvWn5zb7SJh9iYFe1jtNKzyrS4c23O8Zb375hw2XsVyozpTdzFnhvhUN9PJNGBLLZMIlhlVqIy8gwa2FFTkkR9Xkukz6o1SfC7srEhpYqd4umnf96d3Wb5RoIPVZc3GNaf/mn8e15QUC5HQGMXtsDVNlMUeKy/A1aspvk9Dq5aIOPlKTQGo60cc7u4stBm/fFw5m9rcVZcgMwcWbgVjqHXmxf4jbbhq5oJF4waqcdtwl/2fjFIHL2sGc563gefpBHjUSNYq9ZNVrCh8YRkoWL1h3jELCxKEeEVvvqlPBGP/3gsULkJl7aJs5eFk+JPHK7J+qUEaP5VimglD3krdg0Ctxg6auyExB22DNZrjl6WIqrlH4l5XBaqX75
 CZ9oSoxP
 LHq+7K36B7/ZGcb81ctDdg/XroyMRgOKbVM3vDAHGDRrkAfzf/WIvokoEgxu1azxlm+6XOn7OKDL2m6qHKfiYR5YQPJnG46uMLZKsmTK0ySt0snkudeCmW+w0HRHphjHEjSd+y/7Pw5EFsKkhkeq+AUKaVLsjMQL+i9xh0mCJ7+e941cyNoQHZgI1JiyCiNsIMd1Z/o+T+k2PtvdRqor+DHtI4ISEabZBfYJcKf36jTSI10Zxu1Vk57Z965HuFbIBXmNAXhwuvFnLDgpve2R7+VC/oQHY09RrfefOYy2XT4g5sgSmCSHNGQfucJUynTywFxUxcuN5x/NNVU6X/kIJgjQtMvmN8Sr3EcxTArwK7KLxhQ7ERMBk9O3muSNT0f25h07x11yX+8wyDnzWVhcwjm/KdIs7+PSCiszs6pR2AkIWH30LkHXb1igj2sZ4ipeGSYEpuMCmf3txBTVC1Tlx4rBGS5xbsPeYxmDhW3CX34rpLsc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The comparison function cmp_loc_by_count() used for sorting stack trace
locations in debugfs currently returns -1 if a->count > b->count and 1
otherwise. This breaks the antisymmetry property required by sort(),
because when two counts are equal, both cmp(a, b) and cmp(b, a) return
1.

This can lead to undefined or incorrect ordering results. Fix it by
explicitly returning 0 when the counts are equal, ensuring that the
comparison function follows the expected mathematical properties.

Fixes: 553c0369b3e1 ("mm/slub: sort debugfs output by frequency of stack traces")
Cc: stable@vger.kernel.org
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 mm/slub.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index 30003763d224..c91b3744adbc 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7718,8 +7718,9 @@ static int cmp_loc_by_count(const void *a, const void *b, const void *data)
 
 	if (loc1->count > loc2->count)
 		return -1;
-	else
+	if (loc1->count < loc2->count)
 		return 1;
+	return 0;
 }
 
 static void *slab_debugfs_start(struct seq_file *seq, loff_t *ppos)
-- 
2.34.1


