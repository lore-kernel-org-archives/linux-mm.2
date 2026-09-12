Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02454C88E45
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 07:33:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A62C46B0092; Sat, 12 Sep 2026 03:32:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A14AB6B0093; Sat, 12 Sep 2026 03:32:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DE8D6B0095; Sat, 12 Sep 2026 03:32:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A05C6B0092
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 03:32:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1B6501A0445
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 07:32:57 +0000 (UTC)
X-FDA: 85204293594.30.8CD7B38
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6434D180004
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 07:32:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MWwNdJrg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MWwNdJrg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789198375;
	b=MDCTIlXO9P+OzVSZBe1GfCJaiNybbExM0bHPP3LYG284+Haenqe/18/Xo/DN6CsGfKkLb6
	9vbRcwS7vuodLW8EWyXOup7I3/HTZoDW1VxQNrufkz03mmaEbpBJvydoNQwYcQiPH/Z7Uj
	3LE9giL8YGWXCyXFWci+MmmXaWtV930=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789198375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6dFc0Yt+Kj7ZATDq5PSR3LiOH9LJ6g1QqaQN2LWwgGw=;
	b=ZAyXtEZ7qtiL63kXskCuqQqD2I2RF/g1BktBcXaa5ZwiXshnLhXn2zG6BwlU2yizEJmHZO
	lnftK2Cpny//j+w7uVBAKJi5wi7Cu0+3fq6ccEcJZbXyr1D2PdsHOttJaFo9OxypfAEf1+
	HSpDwE+wb99bsF57j/dPrX0mHDO+Hx0=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-4858bc96fabso208053f8f.3
        for <linux-mm@kvack.org>; Sat, 12 Sep 2026 00:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789198374; x=1789803174; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6dFc0Yt+Kj7ZATDq5PSR3LiOH9LJ6g1QqaQN2LWwgGw=;
        b=MWwNdJrg8ZnXvQIVfxOTNytdos6zYr6M6ukfaMFO+RwpRn26wGG2uWFcS5vqgU0iH6
         hvhv/ER7v5lTlXCjCn4hTfCD7XkRJ/HhcyQnR9nCxWnRH9+vJ3rhVAWBmgRpobIxjPS6
         dQdCesIzlmZpplJASDHR/UlRxR5v7u6ft+LiGOh3sxA+jQv8VHbyl/pwZtEOSZqG1cHT
         nUt+hU5hoRLeblMgt5GKsXip8PXSXCe/VDYO8H6ozk7hligK5fHeEHagI4W1mvwg6NQB
         1bTIjv+2zgQtN8CKDMBe8TAgMdU53zQ6dIz3u1rAOm8CcAYMQ/XzO6hZ7UamvR0dWgQA
         FJaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789198374; x=1789803174;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6dFc0Yt+Kj7ZATDq5PSR3LiOH9LJ6g1QqaQN2LWwgGw=;
        b=kRKoVTEgzWuYf+OGLZoVYiqvQrXx/t5FlIYvDnc0WvFiJ5VnYAWUHeqOokPHWuAuDu
         JZz7bqn6Sw1CySWxBxuOluSqb/4tkZxIJ6SCN8a4+VUYhRRL+iB24p/FQ7LMwlDiwLiL
         PxUiMBExCil8BSa7IsWHcZnIbCnIJtFOqnn8iJAetrkrkxXeJtcP/hJMUM+nN9oIN7Tl
         zUJ+SUuRh3exTEGDa9HlDoWLpMq/qkSnVw9g+/UIKx4DONtSftyWkIH8k7dJit8ztMzo
         WtSD3h5eev4keoCbnWQAbrybOu8PvTd1l4DARaBPAt7798KH++lQL7l4KMR42duwaJ6Z
         n0Iw==
X-Forwarded-Encrypted: i=1; AKwUvBxu67gLsJpm7e1bX8K8YOD6XwWBZ6/sWBQ/uavG6nzqmBmqzePLtOHW4x68/YTNTv9mvaNip9t1rw==@kvack.org
X-Gm-Message-State: AFuF++mGPYY7iXX7+sWx56Gl5aMV1EFWTtc5ecHy6skCTmD1BiNnpDnI
	LLVYhjJZ4sU3wMnUOPjCHdkAKIgL0jsB8wDVHCv9dDmdbAjjJm1bWTk+
X-Gm-Gg: AYBFou2Bfvwj3jYLIdk9Snqq4c9QXJsM0hSkUoKIPxsRpBPWz92O/2f08PtbOMTgwKh
	eOawzOLdqeTszMeEHdwUKtDFKnIdwvSLNZSSWue4rpfbrKhIbHvd6KBE1Y2pZpwsPNANd3k02+l
	l4tcvYXffgis3gmQ2dyoQHli73NV0O/vwZRiWXbIVUG3T3jFOqWFixl47l6ZvOxfhvT+1GkGkvv
	sdA9QEeyy//w18Y6V4HEBhzP+R2PkECpkpD3I4z9+4G4CiONc6sFOHj64d9F2J05c0FRXZZuTzy
	VyxGjYfKVVdTyMyHAQ8TtvH8buXf713Yp/VBb+shdFAU+0Q+e/Jj434Dzxemc2Mv8l7ZlRcpp3M
	LygKEwT0zF+srMp36FYuteGrSoRF0clPJKUMnvYcgm0gPAPs16yjYM6oKEyC8qnwkGoKkZj0IHf
	SjsmO3kx//JBxNVpN2s2IwLQaJSt0RKgf7Hw6kj5a7qfk1Zv5qprH8pZAfIShMyWNOoc4I1AIPK
	I85Lo3t/MB0zumKDMYcrwnkecpOIEglsOWI/9mDcqUgVysoy+bugeI62T3NWtxbQ/h2e7mivKac
	f2HvOH8XTncVpEulyLUJwW9bG/c5gkZ8O8HQ7hSv2ftjgkJfAQXRKMDSBLW2QboD3THdev1aavm
	yS7ri8eqA
X-Received: by 2002:a05:600c:3b03:b0:49c:edd2:855 with SMTP id 5b1f17b1804b1-49e6caa72d2mr15036255e9.6.1789198373741;
        Sat, 12 Sep 2026 00:32:53 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-b260-f201-9983-e8c4-aff5-7a36.310.pool.telefonica.de. [2a02:3100:b260:f201:9983:e8c4:aff5:7a36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e71e300f3sm5495095e9.7.2026.09.12.00.32.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 12 Sep 2026 00:32:53 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] docs/vfs: Fix the struct file_system_type copy
Date: Sat, 12 Sep 2026 09:32:50 +0200
Message-Id: <20260912073250.51074-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6434D180004
X-Stat-Signature: p6nu94ey6e5afnoy9baeqhpqh8jripkg
X-Rspamd-Server: rspam01
X-HE-Tag: 1789198375-43536
X-HE-Meta: U2FsdGVkX1+zSfMfCwjJUpILI1U9Y43LVVrCZwrRHaxQUiGIsrR50XJnns2hFcxiG3QF3Euz9vLT+aVqWHN6kr7nQFLgqGHIhT1RWuoQQe4wyUmEJgQdRMPjuMzUDJ2w3jD+R4vuZTcUqgrYcYuwoAWeAklZn7w3XA5u1bhre7TXsFmsjaOyouscqaORtctaY14j9MEZ0/QMrdlzP3TMrhiE7tmoMMu4+JmcALkSTOU0kmgEhoIeFqj7k4xlXIRNh/0VDn7xlYj61BHAdFcfeb9ilZ4M96r3CObOAd3xCc3sl2R4bDDUjRKFTGeZ1YbNu6iDMZI9e3MZybC6w5OuYYwCd2fgsJA3nGoEthU8EVaCFHddrvEt21aP8lJC/QviquxA7mDgjtdZwyE7NHWzXySrf1lP52WWbUHUpg3MZF71Gks2DbaAaKJfvuSzCPrvYK472hoMChy8nlEz6cOz535WxgoTznauvuBTZracj2f3ZZzfduzpvfILol5m63Dmksh2eoyiHCk3Htnvg/Vb0cvzII+1mcLjNNJPXeJNGvjnufGS+4tnUWsnfcdU2nryWAFLOoShQQZzCvMnzSpJYxdn0EBrXkYO7Lg2uk1py5DEbNGAZTuwEEOGnUsmB0TMpmwaJzw0g2ElRmWcUYdVOSZTxBz4R2cYMgX9235EiwGRDafHWnUEfaPgNx/ZV34yRhAkzH9jIhCRuNfRGfiZKwYdFxGoFIDY2EF40I/aofD5e7zFCBpyiPsXeMmiaG9m9+I8Uzvncntg2fi3Rr9rvFzFUzH6W0IGP9n9kLgyikl8a8y2nt1e0EWXwC81pb6g+/ux7WpAz8XpXqOlNWdgCHzM7qESis3jy7JqifiOB7GtPlAx3smmaeynKkmxwAflBv/Kmxfn60XGRxpU3NiFlBOvfOEcpmoiUE3Qg2ZeJMQ4XE0mDRmu/5oLIH/NG7d2BrRE9a7NdzngmbU+Tyr
 bily9aes
 qgyCEBr5ja8IUCfCqeq6Kdg56fJPjszhd/Jg7lxFXK2sMnbImYuyPGJeoxWzxv82vm88hcvRi1MrO8mxvtKv1Ao4DFJLN5e6Cu+r7dwtLy5Vwzxo3pkwcZEAMSxMQX3RfN9fDypmxwz5S6pQ1HG4qkgt94GbITLnpXxTp8K72dtpB8gYpeHLg/H8AkdCjglPMB1d76YHefNfKVqd+nWMXWizA18SOYtaXL4BbqdtefaC62EuTSqSnnrbBy+czKa5XrM7UQ9KKPj8H/xmQdaJMcrT/tgvD1BlqqZie53ZykqGmyEXYrwjxPXqiGaULFhvFx2f78M6DSt9YeF/T7cVa/WIOdt6NjIX6PTZSZ2Efn1I78MKmPpxZ83Qc+2J6OKcWiKf6+DnVRaOW7QrdohziRtC334lFzI0Jf6RMtaZq7WChPC32BFSzzdxg4Arfy/j5fdrZDKmNaPKcL4qY5LWJAxQydA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit dc651e25a6d2 ("fs: RCU-ify filesystems list") replaced the next
pointer of struct file_system_type with an hlist_node, but the copy of
the structure in vfs.rst still shows "struct file_system_type * next".
Show the hlist_node.

Fixes: dc651e25a6d2 ("fs: RCU-ify filesystems list")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 Documentation/filesystems/vfs.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index d3a93eec3945f83e057fbd6bc3ce519da03ea66f..56c68f4aefbac6f7be979f5ebc2a0aee886e13ae 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -117,7 +117,7 @@ members are defined:
 		const struct fs_parameter_spec *parameters;
 		void (*kill_sb) (struct super_block *);
 		struct module *owner;
-		struct file_system_type * next;
+		struct hlist_node list;
 		struct hlist_head fs_supers;
 
 		struct lock_class_key s_lock_key;
-- 
2.39.5 (Apple Git-154)


