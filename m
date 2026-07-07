Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1582AC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 19:47:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07A416B00AA; Tue,  7 Jul 2026 15:47:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 051176B00AB; Tue,  7 Jul 2026 15:47:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA9906B00AC; Tue,  7 Jul 2026 15:47:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFC3E6B00AA
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:47:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5A5BB8F36C
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:47:27 +0000 (UTC)
X-FDA: 84963014934.27.D5E4F83
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8F22740002
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:47:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Nf23gXLB;
	spf=pass (imf27.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783453645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WqmeYeEILR9RvWotHFEqmi/tcbmYPgYQ90HTJiqdd/A=;
	b=lVZjdmgCGBrayFOYzFdNW2O+MH2HbtejmWWvsH2a4wSRGiag3Oaq6FWsx6RrxaLh2N0CQ0
	WBE6h11aYn+TbdYnHcOiaJdn07bmc1Tg/cVtqRdlbWxbzf81nE2UC9ftxEWnOmjdYvXFaY
	GrEFTiBy99KC0KZ7jg98DQpUXpeBQtQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Nf23gXLB;
	spf=pass (imf27.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783453645;
	b=KDHMUyiB/gwoKppkNZXCSn2h8bdKJ7G+Sp3uOng1kWy4nu82uDFrjcm956IaDOMqaR0P2r
	4BUaL+LWvBkcqGzQLTY2a/M6P6v5F1Tm+MyPrSKOsUn/g+tHrto714IT30zgBBUxOhnwNr
	ryuj/Yg7TYfFR3OBkzd9wFkDlIxDm7U=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cace91f112so40299335ad.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 12:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783453644; x=1784058444; darn=kvack.org;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WqmeYeEILR9RvWotHFEqmi/tcbmYPgYQ90HTJiqdd/A=;
        b=Nf23gXLBFYBalIHAla7hBu5yFdmKlchLsxMWmAwRFRcIhOQN9/6+MDSK9/s1gzjQ/6
         JFlKe4+EiD9gBu5bg9w4Agsdle4cjoeGtLG3ITKFvTrk4PbSvS9e7106ZIXJb1WBp/RB
         hSe9QIFAFN4APQDqUuSuqkN4WuTogGbCKoAy0RKiD/sQ4NmUTaYmrOT9fBm+KRl9YuZ1
         TWP4yInI+nJdMvV6Y3xtMBgyLRdkf10r4lZh7WgWHg37pxVOCSK4KSeNHsDB2D3ZPzFr
         QWjXTJf16P9iT2RSCT9lKjc0pwnfmMZWLA+iILxVGrDDYGrGThpQ9c4b9r8uWmUvXOP9
         CS0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783453644; x=1784058444;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WqmeYeEILR9RvWotHFEqmi/tcbmYPgYQ90HTJiqdd/A=;
        b=YcXO+DZupopjx6l04c/Vgyt6VGOlFApaEbZzL3ZDBHZAF7HqhQno5jk5/pegWrRy4K
         opLJAB8BW9x0Ke6Z9cSXfPfqN4wJCg+Qe0w+0gHpf0iP8Zxj0lT0apgeYHWipwWjCbAh
         2EMTh/CmO1eJY2jCcjwobfIGWZ6bdwNDdm1SABu+zk/vqlwUQB83Y+nOvVlMz5vdnb0m
         b1MxEuFt4sUo5PBPtdFKdZh1S5FO9oEf0Ith8f2FL9Zl24RVuM6ToctB8OQdzXVjywtE
         XXvmEyn55K610ldjxIPNrhymsI2UEWzTKPb4mIThmFz74uBU/GmxAgkx61rvssUne+4G
         XVAw==
X-Forwarded-Encrypted: i=1; AHgh+RppQowFnjdtKIhJd4vhKC4VflTJkdw6V/QlYxiQw9Spj8psnNqqFRPCDsC3ysWzwnvKrmJiTVNGVQ==@kvack.org
X-Gm-Message-State: AOJu0YzCYGHvA4ZyW7hA9W3QtrFwU0nU3IbrEVM2Swu74Ohoaev4yo8k
	hd51JOgU6QkF/4UyCcLsbVcXITv8d/XUh7YYDZK3kXauXNFdDgWeVsIX
X-Gm-Gg: AfdE7clIbKiWP/olygq7+pFEF1PRlVl6FoCPvnYduHQU+dvlfsAl5o7jaMwYGsmcaKd
	O3MBLVg6PGOlHgt5y4rdevcyPt7qa5+/2ZGinuzT7/BX2+MteLJsjZ6sSe8Rzo6nHhy9jKKAt1G
	NTV0sJt6RX04E5D/pVQDGZeoxjPP4slcVr1xH5SO+lig5q1zDl2OK+jkxaDW+gfmV149Kcjf8ee
	ieI3aPQTDbYlfw3TXlEKVFNVQDHJVQN6VFsvFwPbOgg1xUrS9flrG/gdTOGlnDsDs80ms1JHd8d
	FEl1E2GujlHQX4U3OVnHwhgOzVE/Gba7Xxvm7fYocyOjk7Xgr2i2CMY1JhWZVK4bcRcV0Kjl31z
	Sxl9gI2YgSCFLFJ+G2duGKn7xvLv7cH8khWxKvPrwQ6lDzULN6d4NeJG7lE+e7SIp8jtb8jiNbU
	9hCyRPuVJMrNxq5oZuLRtlxlWu4HGC1NpP4Stqiuf4/QLHBEKtFgSBwFznKBfj3o5tWxZUpg==
X-Received: by 2002:a17:902:ea03:b0:2c9:d8c6:1dc3 with SMTP id d9443c01a7336-2ccbdc41f65mr54794995ad.0.1783453644502;
        Tue, 07 Jul 2026 12:47:24 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bdb7e9sm17819615ad.10.2026.07.07.12.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 12:47:24 -0700 (PDT)
Subject: [PATCH v7 5/8] drm/nouveau: Use hmm_range_fault_unlocked_timeout()
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
Date: Tue, 07 Jul 2026 12:47:22 -0700
Message-ID: <178345364273.660027.15274510603185163961.stgit@skinsburskii>
In-Reply-To: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
References: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8F22740002
X-Stat-Signature: nfwbbzxrt4tpmt7h916j873nz6o5jqn8
X-HE-Tag: 1783453645-248549
X-HE-Meta: U2FsdGVkX19aAXYFuVcxVfbgK6C0UEIKLPQ43cFPj2VmKRr1tkipxBJWuBq1MrgrDx6o6gnPM/SfuUcnFCn73E9/0mVXCocK+UqCwaTPk6D93j0kTM97h7zBPmXGhQJjUmE/Pnp56SeKqbC/j6B3n3F+1quYDfoK5Q2I9vlDIS7F2+z0K3Xfe5KWJhYAgznRFrFeRGp+TBAj4nMRHhsHcbtywMpf6RdaTqhYoeOCyG0MnRPevhA6gbl8bG08HhlUo4+f1JWdhzgZV3KTV+fdGXMQ4eiG4I4Xk7J7pNuwmpCA9ktqpczfizReOaF94h4eosxpxBygnyBIJlTFWwm2tWY+khSwMwBOFt0Hk0LByU1c2OPRhDnUT052hL3zjpoLfo6KTdNjuVVcxbwh7Tz0rm5CBnf9l0d42g49eBkttL7Mpghk+gqQGJHTGxUV1GFv72Fwqa48YNLrMdwCSHVVWbohbDv0g5Yj6MlsyrlmsVAAvSvmqDnQ13r2xeEMVevFlPQjGzm2W2D5CD1QYAnpW2I/bF9DZIaJIS1sY0Pza1/zAX6vS8DRQ+fm/Otoo7Nw9rtOsRG7Qv6PzYH6K/nvOAhr76z/jT+ft6Elj9Uo204AhFEnVd85YQ5dLE3ByI2jLDsHmccPZI1FJx4VfQVx61Doh2cw7jhCWojAnFbw1j0aUVT5sRuSiPMKexbnCyqt8HYcUoeGjT6P2xO37o6YrBkjX1P8SYjNAI4gADJD6KUR0bQUQ+1+x1TK+4xzBD/Rhy/sF/uRf19RBY0LKSENrKmrsvKpDBHVKkhYQ6IuEaSacU5wGsyL10sJk1aJlGQkfy8E4NmhAw5ukX69U776BRPiyBImd0kfLIdWat00dfDXn0F4fKViudu3mCBWx6W1XSlInZdu5so0FVOyzfz1OXIcdTB9yFhsFtjhHsr6N/IHTGoAePLJxemV1WWbrwtEJPRGmP43uiqnjGyhHwO
 jCSgsobi
 y32gBswTRYfrYwQZckZnWBu13v8vaGEYbopf/xQBKGX442F5HbfYyMIQmB4Pt6XIUXTFFBmXwlUC2vMBg+wV6CJh2ulsXkRBWR97bo8RolTUL2geXivDuw/70oN+vFsP/xTwROhwF0JZ5fYP1gb/xh7jCvgfhntcAm0GFQijnFyNbm0/Ml4+HfdWHeiGXcvTJ1pBqQpPhScDysXQKX7LltLQ39lOw9UT/akNfD6n8fyYC+0FdTQX1g8/7H1/5jgqHjDTAlofkdkBcwIBocZvET40eL7Re2ExA/l7IqQJD9vuuesRXAn1z/jRk9IjxF50IKfC54TvRejHBxQ6JHLR10rSM3ysWeiSq14wB6iNOHTo0X7b0SgZzRf/o8FpP1/sv9uAiBMOVWOJfcz7kofQvKiQDz/GxxqitbJB+AFLNzdSXUpc3R0esQbGXlaK8HbO7GDpJPNdX/5sX7XiNMHaaoQgZI7QJIUJRbV9ouxMArn0vuzyeewMx3qlVnl9ORZvQm7/Zmmi79EM/zN7Wluk08N8+qye4Qrqij+ezCxcjO+IsldciCQvf+WL1kQ==
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
---
 drivers/gpu/drm/nouveau/nouveau_svm.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_svm.c b/drivers/gpu/drm/nouveau/nouveau_svm.c
index dcc92131488e..ba93273341af 100644
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -683,15 +683,10 @@ static int nouveau_range_fault(struct nouveau_svmm *svmm,
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
+				       max_t(long, timeout - jiffies, 1UL));
+		if (ret)
 			goto out;
-		}
 
 		mutex_lock(&svmm->mutex);
 		if (mmu_interval_read_retry(range.notifier,



