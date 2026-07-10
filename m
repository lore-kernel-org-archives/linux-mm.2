Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D3E8C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 21:27:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF3ED6B00CE; Fri, 10 Jul 2026 17:27:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2F4A6B00CF; Fri, 10 Jul 2026 17:27:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1E1C6B00D0; Fri, 10 Jul 2026 17:27:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6588F6B00CE
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:27:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D7E7640584
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:27:03 +0000 (UTC)
X-FDA: 84974152326.07.7DF14DA
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf14.hostedemail.com (Postfix) with ESMTP id EDAEC100007
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:27:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BvXAoYtx;
	spf=pass (imf14.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783718821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i81Mvoxwiz31acM23+HpM6LiopJwdOVnXlQ0p0m7OMc=;
	b=Hha7ZW/qpSQaldPWT95UgsFf05BepKoWHBLIW3xI2NkVw8O676pD9UjxnXz9zhgcm98xve
	EJoQNpWJo1qbv4y/R1E80cTlmkKHZYfI8Po+uNW4YZw3g9jFEOi5Yz8WDXFfjbyLcDcNuB
	ivsOGr10ldrZyzb2ZKf/iv8A7AILUgI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BvXAoYtx;
	spf=pass (imf14.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783718821;
	b=P5E3sZHs4sZpS9WhPW9CXZZg80Vzn+Zrgd3eO7wbykiQJItvrgvj1dbIUcTYiirwOzYfKZ
	MGCaPvXVv+/Jw6dj0mJNKIJNYY9RogZlcy4YJFuzPh9v4qglY0Zb03YeHoq0wxooCnhKsQ
	x7fqiGtUIqE6+2/4WFoevJUyv07V2Dg=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8487214ad2bso1821082b3a.1
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783718821; x=1784323621; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=i81Mvoxwiz31acM23+HpM6LiopJwdOVnXlQ0p0m7OMc=;
        b=BvXAoYtxteoFg24e2UBXwC5gP96SpJYtQIMraSVQhNjqdVysXLBd/CuG98bjkFDy6i
         TP5Ox/U28nUkYtr1BDvdHf0cNutugDfBmQSRn8BYJTC4DPC0d40oxNktSyKddaCZyxZI
         oohRj0VIm6ni9CO2GhnSL1RDRNGJVwSi2A7Ox4KxskvwF9Zt042ovYGkx4YR2nktFwXW
         4ruVfVhcVkUF5+cVxUYBekokoUT8cTHbC2MI1TFq+7TDyQUfTvmZGzPZeeH5QwJnMw5b
         l2fPuGdt1ETqAKfU/CeLsUosisWVqUzyGafVvDsOhuyOk2PGp2JzolqPxJLo3SLMI2zW
         7k+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783718821; x=1784323621;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i81Mvoxwiz31acM23+HpM6LiopJwdOVnXlQ0p0m7OMc=;
        b=cSPjtT785uBFdnaAFV4GFZXKWRGcVS5Om4gzYDjI7eKAoI2QmkU5S6YQRXJBvNzDGH
         jNOo1RJ3gadLhfrx2i5Fsv78NsnWLMl/ca9TpqpN3IlgB1tT1yWj1gIlui8GSAOyJYyM
         jwdaiVpdTOb1GmzJbbtY6ErPSYyyv3Odf9YmJ0GCbDmquHS28G/spZ3TgodBAMUgvXt7
         X4fmy42u7Tg6LngJIE8s5sGExwLBdc0DAMIaWvNWYQQxCq2chRjICUtBFbx6BgUFYRbF
         oVsqjagXDlFFDSMBFFO6M4zo6bTN0EMkHu7/AWDuLDKlvoEd8uKIcKXl9rH+n7GyDKGl
         u14A==
X-Forwarded-Encrypted: i=1; AHgh+RqNbpzazssp7bP5AU3xqghe5UEXsDeFTevB1c3lYzkCQKOwTMRvCzeHu9JjDxE+ZPR3lISlUxNIiA==@kvack.org
X-Gm-Message-State: AOJu0YyQDL5q7YtEVSfR7dqqxn4COULm4ex30B0uRZNjCNn1wnI1N7St
	0LmFABsILCYgC7Ea6Lx8Lf3l8CWEXjnIfSY4cv5uF6TCI/+MMLIeN7nS
X-Gm-Gg: AfdE7cmCAQtN6jIiqwq25T+kWPjxlehGjzm6USogjSoIhaWYDp9/lIeTyq1gM650I/0
	2GphJi9LIKmnHt+UHlF43O5OSOTuc8ObLjBtROUd4F7yfm2JBk0iZOiJLlOxKriw1iq2goYByf5
	3cjAZJRET+xAZzATykuhpWXOWiNiDSM4DeXatJBUB1cTumgYFxUcH3/Sih/NAu69Vj/ZPnqaBXC
	uRc5wqOiPd7l9aKey63SUNxINGC+20Ue3wDWQyzpTatEID/Hc26QeCUPpbU3kC1ofWUkmk7xjFC
	3PcqZg/9ctT4fMtZuN8AoiXoNW6kUF3d4LBlh5XAzHWca8uMw9ScKrEuHWgK4KRzzWzDReyA3RB
	ygB3OfVNobn8wGgEAj2kDVOVof87eEEKA257bnoxHPALAuniVYty8Wkito20KE6sBe0DBJeNYnu
	/nRJcTy8lzqYiMeCxdjdnYnvnbMGmyMZOmVkVbAtN3vLVa0w3bNNSuoxA/6VUceszSbavliQ==
X-Received: by 2002:a05:6a00:a0e:b0:847:7f38:27ad with SMTP id d2e1a72fcca58-8488975299emr661948b3a.53.1783718820769;
        Fri, 10 Jul 2026 14:27:00 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8482b333d4fsm6649821b3a.54.2026.07.10.14.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 14:27:00 -0700 (PDT)
Subject: [PATCH v8 5/8] drm/nouveau: Use hmm_range_fault_unlocked_timeout()
 for SVM faults
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
 corbet@lwn.net, dakr@kernel.org, david@kernel.org, decui@microsoft.com,
 haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org, kys@microsoft.com,
 leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com, ljs@kernel.org,
 longli@microsoft.com, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
 mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
 nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
 rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, skinsburskii@gmail.com, surenb@google.com,
 tzimmermann@suse.de, vbabka@kernel.org, wei.liu@kernel.org,
 skinsburskii@gmail.com
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org
Date: Fri, 10 Jul 2026 14:26:58 -0700
Message-ID: <178371881847.900500.8789369230260725500.stgit@skinsburskii>
In-Reply-To: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EDAEC100007
X-Stat-Signature: 9o6sha1jg7uehfeouuzezh44jhmpew38
X-HE-Tag: 1783718821-951750
X-HE-Meta: U2FsdGVkX19fW+6DiV6zFPRzbdM272+76IxLs8++3dDUguXSOSWJ4zxX3R21o7dPoyhJZsNCPcpu1zqHEDeuJSAv5fGMT1ij83z5kTuUNl+cUWxPnSd9H32jPhywxBiq4so5Qk6/fUFN3kwj8exf+GbQKPdR/sTsMacEPJQFu7x/JpYqYqkGHBJoZGMTdbCCE5J79wCHDbhM5lvngRNsXWk/AflCakZQukgtDRTuVF+lonMEaxeJSdQBVfj8cqkQyIvDKu8ZyuKxO0ouDVygo3H4IgXrwaLoWjrOMvgYFG9+vNEEEChIoufAxwONHKraGG3PLlUWOA7gOUvRbetW2ZxEdiq7mcMWkhIKpXE70HqS/TV4Osw8UdCYrwbfosfSe/xVA4ErHDOm4G2k08hgLia548175KfFz+ptP/t0EKkhE4MmkE8SVRCbLox7WDVLPjYBkdQkECDZ7uHnDXg6wEfcap2mJCf9A3R4t5blrPVro96kI/6d7i5tre5eDNlKAfwE1qkRZuDWzOQ5wYSIAi//hNxOAEdsbqbz7uJ030KYOs9eg/mrjL2KfEIkKffsJeE/Jw8888Oov+kXTEmeNWLm69WhCRK+yUch9RThShmXKPYrYVa6lt2N3OPvJG8DYXK26lwsipnTJTq+KX9zBapQ6n2QGoQVX+qfjXUmNWabH8w7HOhz4x8CTQE8qRvri1bHiEa9Sn4ov4yYuxDl7CT5KKxkkS7trv6tD5bQd14+mxiD9vI1xpTRA6icmzKrVTsu/ApiO1F4dFN9nPMoM8X08i4wdr/GQuiEPRJh2ph/CCjqloHQ19z62OL6lruJ3E2lrn6hPy60gju19loAJtQSSYrGOAg48frsSzDfttPlVw4Ti44rG8afabpmkW5q3Drxx/h3MX3WiPMmK1kPsfc9NsL5AlSDSk0VkUQSaZubkHrV1FRm1tDZGEk22nupo7vmqcXIj4R6vyCCkZE
 JyXej/EG
 jJr/CabMLM97AytPoDFSyNSvJd5riC5cVNsy9IEiPkBn2L6gWVZUeIf4zh66KMrTUnPPn5cC0RODs9uIx5h9xhOKIMDprm0K/eTgg63dUUiPjZX/PWX8ine26Xm2bcCNQXe9dUngE+QaYs8ZNX2Ln1TY9VsvLjTChfO3gGP1MQHhdTsdrBOXifMmd4EKz4cs907/lqW+ZLMFn1GYKBH28MEv2m1fePoFAPtzGnfPmDjF67YdRsSU+JrS6mc+I6GWsJanrnkB3348NABJrIPUA/a7uHzA5y9phlTr8dCWgzXJpVwQ8kzP8G3BnjH1LglCRgPjTkRrwcAVRi0hhZCdSTZlHS//xTWXnxcn9uISXokEwu6bCxlmSg/TIJLnGwP8AbG+gnBBogNsOQbXvxDu4FOKyTLF5NfQTUWEV/7zpL7FkTDdQU2skA8ptC/+SpWMzkPTgvChShEuP+UEQE24tgTQJkuEHt3qCTwWIkynsVf3/q0gOlP0MgcN//b1HI3YaT8EgHV3G1VxQA7MliXn0RilBcTrhjFTmWT6usBtRexwM7f3tYA/JQoTrnofmE/dE0BUCQhln1euUHfU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

nouveau_range_fault() takes mmap_read_lock() only to call
hmm_range_fault(). It also keeps a single HMM_RANGE_DEFAULT_TIMEOUT
deadline across both HMM -EBUSY retries and post-fault
mmu_interval_read_retry() retries.

Use hmm_range_fault_unlocked_timeout() instead. The HMM helper now owns
the mmap lock and refreshes range->notifier_seq for its internal retries.
Nouveau keeps its existing absolute deadline in the outer loop and passes
the remaining jiffies to the helper for each fault attempt, so retries
caused by mmu_interval_read_retry() do not reset the overall retry budget.

Nouveau still validates the interval notifier sequence while holding
svmm->mutex before programming the GPU mapping.

Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/gpu/drm/nouveau/nouveau_svm.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_svm.c b/drivers/gpu/drm/nouveau/nouveau_svm.c
index dcc92131488e..4cfb6eb7c771 100644
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -683,15 +683,11 @@ static int nouveau_range_fault(struct nouveau_svmm *svmm,
 			goto out;
 		}
 
-		range.notifier_seq = mmu_interval_read_begin(range.notifier);
-		mmap_read_lock(mm);
-		ret = hmm_range_fault(&range);
-		mmap_read_unlock(mm);
-		if (ret) {
-			if (ret == -EBUSY)
-				continue;
+		ret = hmm_range_fault_unlocked_timeout(&range,
+						       max(timeout - jiffies,
+							   1L));
+		if (ret)
 			goto out;
-		}
 
 		mutex_lock(&svmm->mutex);
 		if (mmu_interval_read_retry(range.notifier,



