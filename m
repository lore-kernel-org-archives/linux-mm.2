Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D90A5CD5BD1
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 05:58:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FB6C6B00FA; Sun, 31 May 2026 01:58:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 880CA6B00FC; Sun, 31 May 2026 01:58:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 795926B00FD; Sun, 31 May 2026 01:58:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F1306B00FA
	for <linux-mm@kvack.org>; Sun, 31 May 2026 01:58:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1EA73161BA3
	for <linux-mm@kvack.org>; Sun, 31 May 2026 05:58:37 +0000 (UTC)
X-FDA: 84826660674.30.3D7D0EF
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5B8321A0007
	for <linux-mm@kvack.org>; Sun, 31 May 2026 05:58:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Rhwzv9OO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3Cc4baggKCGwTSKaSiKXQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--jiaqiyan.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3Cc4baggKCGwTSKaSiKXQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--jiaqiyan.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780207115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Watx4wiVZz594G8gV72LCTq/SUp1MPbV3HBGL6Hr2ho=;
	b=8b0eZNTGs4OY4Z0lonMfb0iGh5R+3OiJ+iqahrrLTTbcpgl1M6oIkSohdabuuyicydDpHx
	YGJNbNn1iGDlcy5jLSFpCbLR58YBogKInOMUEjoDaz347ebyg8456D7eVmApOHx4Tcg9Lb
	gdNA0VcKvaRj9mZRPhhc77CclLB/ShM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Rhwzv9OO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3Cc4baggKCGwTSKaSiKXQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--jiaqiyan.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3Cc4baggKCGwTSKaSiKXQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--jiaqiyan.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780207115; a=rsa-sha256;
	cv=none;
	b=h4o2ZWVTl4qwUowh+DucgailjL4AkPJRFgYX440K/3hwkeihbQfScl5wUlkUTg6NCXXDlQ
	75P7UBRy93idTCr4luV6g971yC5paWpRjvw2FkKYE2PKHCUi+u6mVgITrwftMTQ/aSSgiW
	8spNEnDOUokGSxAel2GYpodAtu5oMNg=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2bf32fb7cb2so10640035ad.2
        for <linux-mm@kvack.org>; Sat, 30 May 2026 22:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780207114; x=1780811914; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Watx4wiVZz594G8gV72LCTq/SUp1MPbV3HBGL6Hr2ho=;
        b=Rhwzv9OOTPtPtX7/IjHC/0R6xgJ4WCYnB4rP0VQVN404v7XN510LXiSSvd0BM+OQBz
         czc+ZF7eJSGHe3ZIdbrRVk7rZvxp/sGt0bd8vVVi6MjRsJH0cjGo2QQ1SZIAb9V+k/sa
         QMY5e/lYgDfpmdt8sPdyr7bayS3s6SjdBN5XqZxwctHq8OQrajRO69eDimmoF6BCv73t
         VTcfTUfHQWkAowcSwMzpI8dCRTObUy01GYSBYXIxa6dzg3wdR7p08P6sKYGcmhdmU8uj
         fRRp1RLCbHf4TCmy1SUIoWYWYdzetN/nkFJJwN+Mxhwofiuk4uS08YEEjiaD5uJtoc6j
         9QJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780207114; x=1780811914;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Watx4wiVZz594G8gV72LCTq/SUp1MPbV3HBGL6Hr2ho=;
        b=g053a2AUkoE+H6QE2plRsKTZHeXrncf64d8RBAhnecLinhAhQ5vvBqetrvtwZHci8F
         FzeO9fPVpkMXVRr3axfTcytl0WBMb+3b4nW2WcLPNbnFg5mu/9oRHxW2m8ATeJ/nMNCI
         /II10LikI7/FgNrfVlokh3DRKc1RoWHfwdoWd/EGOffVDiEZUTO1D1fc0yiU7qQxyMfU
         Tv2w4eGJSztdPXHL4dJm+CyRnKvr38rF7qC4K9zqIOeFZ3oGHM81lxaYZ6EZU/Piy7ty
         Pd9eidXrQf+xMNtqQIC6RNFycow/f746KKreVpfS52SVYmdvyTpt7nJ3HZALU9HXMlSi
         BVoQ==
X-Forwarded-Encrypted: i=1; AFNElJ9ygH/se7u+6oA/p8gKuGL0CH2+WL2C5oX1DVUQ14SWpFL9AfUH2+QOlYkdG2EC2LvpIrt3iOrS2w==@kvack.org
X-Gm-Message-State: AOJu0Yxe3f+L3qGy8KRgBapeijRYDIuwrjDD5gkLxjgaKdeTuoO30laX
	/qBZ1vfy3Ajkm3ycreZUXbjlchm5mZPljs0APyTiPhstSNJmPnXgy+4XI3AoWsutRjhRCXdWNZO
	fusSND1o+bqZpwg==
X-Received: from plgy12.prod.google.com ([2002:a17:903:22cc:b0:2b2:4713:9ce4])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ce85:b0:2bd:4d4b:9143 with SMTP id d9443c01a7336-2bf36795110mr71007705ad.8.1780207113952;
 Sat, 30 May 2026 22:58:33 -0700 (PDT)
Date: Sun, 31 May 2026 05:58:27 +0000
In-Reply-To: <20260531055829.3636554-1-jiaqiyan@google.com>
Mime-Version: 1.0
References: <20260531055829.3636554-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.54.0.823.g6e5bcc1fc9-goog
Message-ID: <20260531055829.3636554-3-jiaqiyan@google.com>
Subject: [PATCH v5 2/4] mm/memory-failure: set has_hwpoisoned flags on
 dissolved HugeTLB folio
From: Jiaqi Yan <jiaqiyan@google.com>
To: ljs@kernel.org, linmiaohe@huawei.com, osalvador@kernel.org, ziy@nvidia.com, 
	harry.yoo@oracle.com, willy@infradead.org
Cc: osalvador@suse.de, lorenzo.stoakes@oracle.com, jackmanb@google.com, 
	hannes@cmpxchg.org, nao.horiguchi@gmail.com, david@kernel.org, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, muchun.song@linux.dev, 
	liam@infradead.org, rientjes@google.com, duenwen@google.com, 
	jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	vbabka@suse.cz, rppt@kernel.org, shuah@kernel.org, surenb@google.com, 
	mhocko@suse.com, boudewijn@delta-utec.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5B8321A0007
X-Stat-Signature: g6qf4m8q6wyutzc5hmpq7cw93szjcd77
X-Rspam-User: 
X-HE-Tag: 1780207115-408717
X-HE-Meta: U2FsdGVkX19QEZP58omxmOM+zAbv+tZj47CLC6yHVgid4NDbFeB3spD7xpusz9vh7TGj0RQlyTjYOhe6KWfKZnjKSv0FnGPeOX4YxDyv+yX8ww1h+nYWNJ6q9vY2RJ3k7zzltwVdgqso6/Eh4+uqxyS+5YYPNGfIGHtgV877CR8c0fatAYaemqdA117kVoQeul5Ut/ik4QjEeDy8DQEqLAzOTU/XhPb9bX7wsnIBzQ+Rz++mtAp0z9Jyo7vnquwlHBo2yFtMIDz01I0/wO3sndQWnESx1REWFXCGmYUIe5GXYMzj5v1ef5CxEg1ki74tYFB3R/NDs8Wv6P8tt1B6WC0WfOmEeKO7JakgfJMtr4+koQfnTn6LYr5bXN3Sz2FWUnIoPJngym5rJJvyl/3IPuWUOB0Vyl2fqZutnj0anAliFroV/xBMGCgdY4FWKNINJjwaB0Kg0fWv/72ESiWjpd599Na7bBvjTfyqxEeJjuLI6y+Q8lXLpFmHLL0SS1QyI78AbyqIKr7bqqAahQ93DI2m/oBrOIWQW1fxV6Ku7GXxuegXHCsx41LkgKEwv8OqcWFCqu+1quFq3a0SVAcgT9Ydh7U0Vni7shbUynsq6bX9+pwfFVJiN39nGHuPD23ww3xxYPPEE8lTegMboQC5QA/GOI9Lz3baNHf/Cx/tTzGLB83fzg4NthenIeM86Sr25mln4j4KFVWfRCsmaLKsB83nuHTzOGQMthZ8XvvG18/Ip7fPFz/s+RiJZJoqtikH6LIm2VAutPpNckcBaNaxIabhQ/dq9sABiP6vDj8KtYuHRNsDfYFd0l/YEJ0AljezFUP55WTj67PoIr4oPpNTnoh8dCELVl1wWwep6xpj83eded1CWpR63IP3O0nDdqEjTwAJGSs2YoBiLjhHhDmb4PJfdrvnvG2XhcxcanKf9G12o9rNZyC8bIxYefpwc8MSC8j6dJEyv8ktaF5Ya+u
 bBvAxeHC
 hkuXShDuZZVAYigoEoZyQujUJ+iAVd1k3FQ7duMLOBd+b82rH8IH4FKMKd752GltSBUenq1PcTKPXVsjdybYxQ/QzbHvKG+XkjjWbK3Gr0Z40KA0INqyYwrC5IeObdXGitCZ4tyiM4lQ7+DsNHeQppxV5DZPiokKcAJPyQxQMCkz/di0vVnskk0uWBYNXGBP2s5zoPG/VX0+D0ZluWONRq4+oP8KuHNChNNao4Iq3DF84tOzMJKNnPVcXHqanjDx2oTz9r5v7pSDchvhjwmqLkETGMeLw2mr/exaDy8sBnNNwcZca9i36ItVMaOScxGcB5K4rwZ9a4hsC23JriNKx8qysHJnfnYq5CkU3CXFEKl1WqwBW6nxnFmgal0db1tBkwI4r4FzLPwrMTyGizXhxHoclNjgToEczOTEkx53DP9XzbjZQNUWpx5+okfLYqy/WVvFuPLoqmO3plcYn7RKj9W91crZcfTFieohrM59+6dKsUEAJ2NfGWK/GPozIvXQo58AkX7/HzmPh8nN4spmcMmzxZHbgsFTsuuBUwu80FksjP9ZpQDu9YHKyP+mPjsue/UZUYy98l5S/64SrZVGoUBji8+ObkmaoB7Jfid3kdcRS90kL3zK4bOt45gEhIwv0SitBoYydjYZoW4wryRPjyOPFdmYKFmy/8RJHsK0B6QXAnUc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a free HWPoison HugeTLB folio is dissolved, it becomes
non-HugeTLB and is released to buddy allocator as a high-order
folio.

Set has_hwpoisoned flags on the high-order folio so that buddy
allocator can tell that it contains certain HWPoison page(s),
and can handle it specially with free_has_hwpoisoned().

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 include/linux/page-flags.h | 2 +-
 mm/memory-failure.c        | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 7223f6f4e2b4..223ec3b2d62f 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -893,7 +893,7 @@ static inline int PageTransCompound(const struct page *page)
 TESTPAGEFLAG_FALSE(TransCompound, transcompound)
 #endif
 
-#if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
+#if defined(CONFIG_MEMORY_FAILURE) && (defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLB_PAGE))
 /*
  * PageHasHWPoisoned indicates that at least one subpage is hwpoisoned in the
  * compound page.
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 51508a55c405..95979b7995c1 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1951,6 +1951,7 @@ void folio_clear_hugetlb_hwpoison(struct folio *folio)
 	if (folio_test_hugetlb_vmemmap_optimized(folio))
 		return;
 	folio_clear_hwpoison(folio);
+	folio_set_has_hwpoisoned(folio);
 	folio_free_raw_hwp(folio, true);
 }
 
-- 
2.54.0.823.g6e5bcc1fc9-goog


