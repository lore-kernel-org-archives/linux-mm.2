Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 581BC60A5BE7
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 08:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=n18gQ95z
Received: by kanga.kvack.org (Postfix)
	id 8070C6B05B0; Mon, 23 Nov 2026 03:01:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B7336B05B1; Mon, 23 Nov 2026 03:01:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CCC96B05B2; Mon, 23 Nov 2026 03:01:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A1C46B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:01:05 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D14AB807E1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:01:03 +0000 (UTC)
X-FDA: 85465638006.26.BA4660A
Received: from mail-pj2-f2.google.com (mail-pj2-f2.google.com [74.125.227.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id D32634000B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:01:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=n18gQ95z;
	spf=pass (imf17.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.130 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795420861;
	b=KqxK4cZCggdKnz+lv/RAIHS2Fyc7vRyHjmfamLeBaHglvwHowpytd24jzlprSon4DDrsm0
	6xcAcumGtiiVUP2krljTLxrH29C/BocE9zWhaLH8Qxz5dcuyi9OTcRz8j2bzy3ONBYJcLw
	tgIYGXhcDtt8v0CGu39XukSm/d9nsFk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795420861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=f4kxL1RSmgNIZ5ncBejETsrMHrpcYl0Fuets3/kxcc4=;
	b=WUE57GZ27tmMDflt7lM2ldu7ofVjr9KurF+cDwSd7B893zp41pcC5Gi0MmTjimiNVyEpKN
	WL3D4AkDatXuz1JlCow6AjTj78W/949zHOFXFNi+tSmTVM3AniEzgoCiWuSNUONOO/mVqe
	oKtYATAj3/75XVSj1/X5akoiS8QAsxM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=n18gQ95z;
	spf=pass (imf17.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.130 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f2.google.com with SMTP id 98e67ed59e1d1-3b14c80b210so637567a91.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795420860; x=1796025660; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=f4kxL1RSmgNIZ5ncBejETsrMHrpcYl0Fuets3/kxcc4=;
        b=n18gQ95zQ51YicL95sQhEGBZOoKJ/lsCBQ3lSyulgJ4qwpA2sMkqAe6uju13jD26EI
         pKjjfnsSTag9V9oWOgBQQYGuNX4bjUW1wvHO6anARMAd+mDA5QfU5w9LhygcWrTxtrHI
         p8voEQmi8Y6Kv2DrjRoxmSRrK6rkA9GyF+fFhpESzSsZsEA85L0MBrXvKsFBfuLi8EOX
         RqDs88qMvM6243wPZbgGE4JuQfug0XxaTdwpUcNR/f5RZbKLI4irzft1+C0ZOL59Rg3E
         LEv2opBsEKs5HtU86b/1dP7t7JGo7ck0KkPOGkogHA9WOoKhFDIh8aD3M6ubYL3av73k
         ESjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795420860; x=1796025660;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=f4kxL1RSmgNIZ5ncBejETsrMHrpcYl0Fuets3/kxcc4=;
        b=icrgg47CNWoekYYIOAS5EiXvFeXvUPAL/kIyXz8AY8aZx+lYM5wW7J2CS+Y4pyqLV1
         yBatBvIZd7RXOTS1r0KPjX1F86N5GTDomDGUNWj0urK6k80CTMLUVn697dfWtKWov4w4
         FwYoDqcxdsTq92gfn8eWe4K3nnKt8nV8Zi0xQivqR3ezxtw7vIkLkpPCpcs7WBANNxQ2
         ruE9U7VjAs87Zg4Tc+h9VAaWDH8HsaCbj4MI36gkMly2owf9o5TS9WMC5q5/3Ti4D5QJ
         Tqqg0/BcIXOQv8uaWqLIsj08ZqXoASpAWCvGbLBwIhwLECVi0jqf4FiQVDNp3cQWaz8D
         YyKw==
X-Forwarded-Encrypted: i=1; AL+hErG3TFvWb0kPJAAF4ZFFDMTP8uPw690tw1fgGdYfDxp3V8wgGTm99LAckyMeN5usVKHkEIv4Dpgz3g==@kvack.org
X-Gm-Message-State: APuU4Z8DSmIwWM33noO3ixkEdoBzrvCsr4fG2C4wr+IqxONXw8al466g
	acR9bHH5ngcyGB1k+wyt+sl2tYrHWFW6gwgMckumiClQO87BVZY3VXLX
X-Gm-Gg: AZFdTZe8CBMu9jVJLFPlKHLwN1ZxmcgRBKXD0QxyyU+eoaRUqfJ8BT8US4pRmWqIrjq
	PVb5NOxH7gGIx6LsdWD8aSJNgiHacJdYfYWXSTvBe3xolbZCfRVCCyUJ+sXzTFpiaZ0+xTi0XIa
	JflBU6Jzpzu+c9F2tsuSgmtV3x9r8cpokIdP8ph8Lijldifwd5d1sbrDKXD/28xuhphGjqvFSDQ
	lQnjxSQ40f7uiWIPOf+RU2VwJzjRxDzTljPwR+LCYspaNl8VK1vaEwRKWEHJ0lksDhZ1la3Dzu2
	j9vHR93dC90V038iDFl4zSXRzjTf5LZ2JJ6uxZxmCDSl8clYNqoy+WpToi9xEumGmcrYW5v7A+y
	t/ugVB0DNbRnQY9KX2FuwGii9KHMbg7m3W3Vw8YyCfnja5OPmsHbT1t2kZnqIQE9Ginp0XuMb6B
	KLHQa/l2E2xOo+PaZK9Da2GNHO038xuBpkHlGwu/Sq99t17QR5wusL+zOjCzmc7r8eOirdxAq0n
	K/osHsMkgUTOj+DpmnCupvRFy0cH9PQDTNj5OGAcGrcuvJCo8y2xQJbfpUh4ePL3Ws3yuUxH92x
	fwy1+rRkSREkvCuRd4RQcl0VJotwQJmyOCSOXdlphBunQeRS9QBRY/yQWIfOM5ItPAsdLTB2sI8
	2xxI9fmIxcvIKL6IaI48DwPMVqoNNJdbk13Gev23uuTve2SAepo0GPUj4iJm+bw==
X-Received: by 2002:a05:6a21:32a0:b0:3e2:90da:9594 with SMTP id adf61e73a8af0-4014a37929emr10127148637.9.1795420860377;
        Mon, 23 Nov 2026 00:01:00 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c873c1cf4fsm5020034b3a.49.2026.11.23.00.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 00:01:00 -0800 (PST)
From: Aveline Noir <jm5905938@gmail.com>
Date: Mon, 23 Nov 2026 18:51:45 +1100
Subject: [PATCH] mm/damon/sysfs: skip registration if DAMON core init fails
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261123-damon-sysfs-init-guard-v1-1-a2a6ca65693a@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/y2NwQ6CMBBEf4Xs2U0sJoj+ivGwLQuspqXpFpUQ/
 l0Qj28y82YG5SSscC1mSPwSlSGsYA4FuJ5CxyjNylAey8qY8oQN+SGgTtoqSpCM3UipwdbVZ67
 qmhwxrOOYuJXPT3y776yjfbDLm21rWFJGmyi4fov+3qdEZB/zhDENlhW9x8Bv3P/NBZblCxZgk
 SS0AAAA
X-Change-ID: 20261123-damon-sysfs-init-guard-fc87e688acae
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Lian Wang <lianux.mm@gmail.com>, Dawei Li <set_pte_at@outlook.com>, 
 damon@lists.linux.dev, linux-mm@kvack.org
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D32634000B
X-Stat-Signature: iak64jwrr74g5gdqy6bdz91wy8jyk45d
X-Rspam-User:
X-HE-Tag: 1795420861-732789
X-HE-Meta: U2FsdGVkX1+922oibQoYfNron80Yi08hBcdKxzoNbsj6ypXQu04XVkAH9g4a9gAcumtfWLAvbfMM0zYMg6E3U8j/NWBF2c5B9NwVclXPiXWAMDZnrPxMFkP2RsnJckrKQ1Kcf1u4rBYyqvRWZ6LqR5PTGUEnLuCPgMaUFIBYUq1uepNteNT8G1afGH1KPTbhdapd3QhMqFcSKoeDdB2RgqUfdYBJYdEGzVSBYXPmZxmdzyd1JVBeiK/+v84axn4bS1Q4uwQSRT970VlVXgzNhsOBOIuItLi/jYtwE3K4+G3HJA7S5rWlQEz1SGHqcjWvgNmS8ljXNFGpHzkH+HZnQ05I0UghRvuT1RtYqBPAmr0pOi1KMOQkTVpHGg1qq7PoK+cdyLFeVmgyip8mStEtzwVwxKgmtyDn1zk48nVAm70OakL3UI4NLHCzTXKeXZeBXmvRv6gJJLvcGec0cwHgltGgvlKAOCxJ2qfzIgtPlawx8bQVZZTw9VWRuyNqZ8ZmmdH1H5gl6fHFEBEOMuJ+ZL0oWgONbomFK7tWi+7HXJxF0zvLGoTGudkywve+jcqiEw0NwRfRj3b2kVob9ZqRBcFCw2B92ZsYAzhdUUCFAfVW+Hk+8Q8TeGpTSsgFUs3RgIeJHVnnpneG1hpSNqqt5PEVzfj/j15SrBH9mX0+s2n3bfjJLITnOlTfco13tLzDvdpbtxFIWCRhWNsU2Jzk7BR28ggQIVIbUYR+1WSDS/piM+U1DOl92+vPaLGvkB+8sMuF3tTXKdSKVQ8N+ov1oFMDOstTSWTVMFAmqb4+TQODheglkFDDFn46Xw370Mo+d5X6wcieL+zaZjNBmpu0YSDlIgWVWLRJ56eqaq8mL/HISEbrx5nSqCjuk0GV9H9N0CTOngdZIz+CYTqmh3UdTCh2C2zR2+S2GTkJS7ZqbVH6e5rZ0UDIbEGcDPnmdhbFacCWdBI48OiVYHcK5jZ
 TULXid1M
 414c5fFgC+grYdHKQTBYTxmWWQu8y3ywFBHP2IFe6KLNgco5wZA4yy8qgFubpaRwUbd39EPhrc+KDy403pXDuCOn04vnz0+bwKotHSIW6yIYvblBCciJarFMBt/hHA2DFARp40Hu040rNIGiQUNoQcTUSGfooSemPJMyQct0J3ENT6hEwDD5tnFxB+RRvaZPzSfBQd058Y/QVbwuRtXoIHt+FasIlIHfmc63gNBsKp+K8xbzAQJORBN5L1EdSyd+lImYlYuS308Shq3GZCpkajACyEpsfbqS4BOCqizToNHEnr2NeuWTsyoMT4cx/EUx8lYLLK0EWcJOGwXZmDkbHdPBb4rc8mboUbNJCF9/K90Xlz4tUSN2/UUf2a2LWgHRqjrLv3QT3EUf0Awn2j4s41TBGQY0kk5B+FNd2ySeE9nnIOM+EHLmoYDsNZdKIabwPZDX2WjGovDNVAZyQHGgHI/8SDNBDKKRbtY7mjhcXZ1AYM0ss2S3HWlj+oBj72UkRJJVEND6gzekswidMBfgIBpQJQfowAS4cUwoXREiLrnSK0sqwYexAsBBznmrIOTsx2062536HkO4WPnutLIfn5D9yeFs6DSYvwEhW3on8bTiooyun7mSxeg0EGO/clwwM0zzDQ/JW7adVpUuTxbE4fZ0HCWEFGbU9MIzfbvl4BXzrZFN2gkkAOCLg9Sp51TRlGxC/Z/kW0MBvDhWIUJH3zHrAVHC0PB32lof9MjVXqIoAFRXC48UDvuYxeWNMJ8MBJyX0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

Here's the sysfs fix I mentioned in the report queue review.

-- >8 --

While reviewing the DAMON report queue series, I noticed that DAMON
sysfs still registers its interface if DAMON core initialization fails.
If damon_init() fails to allocate damon_region_cache, starting a
kdamond with an initial region can pass a NULL cache to
kmem_cache_alloc() via damon_new_region().

Check damon_initialized() before creating the DAMON sysfs directory and
return -ENOMEM if the core is unavailable.

Fixes: a18709442869 ("mm/damon: improve damon_new_region strategy")
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
---
Tests passed in x86-64 QEMU TCG guests on 9f004372ebeb.
---
 mm/damon/sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 779c98205a94..7de0f03a3fd5 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -3035,6 +3035,9 @@ static int __init damon_sysfs_init(void)
 	struct damon_sysfs_ui_dir *admin;
 	int err;
 
+	if (!damon_initialized())
+		return -ENOMEM;
+
 	damon_sysfs_root = kobject_create_and_add("damon", mm_kobj);
 	if (!damon_sysfs_root)
 		return -ENOMEM;

---
base-commit: 9f004372ebeb18fdeb699f9880a0e472df90135b
change-id: 20261123-damon-sysfs-init-guard-fc87e688acae

-- 
Thanks,
Aveline Noir

