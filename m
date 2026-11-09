Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D4E6606D80A
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 13:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YYEEHVNw
Received: by kanga.kvack.org (Postfix)
	id C1D886B05BA; Mon,  9 Nov 2026 07:59:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF61E6B05BB; Mon,  9 Nov 2026 07:59:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A47756B05BC; Mon,  9 Nov 2026 07:59:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 809576B05BA
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:59:58 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 05AB38068C
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:59:58 +0000 (UTC)
X-FDA: 85415588076.25.0484F83
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf10.hostedemail.com (Postfix) with ESMTP id 25DE7C0003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:59:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=YYEEHVNw;
	spf=pass (imf10.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794229196;
	b=HokUkugbuEQg7WfJO/+m6Xn8bQcqS5xdxdHZ8XUIPUsv7lbD7142ndwDgf2lsD2u3h/6zR
	8e5arhJ1TumaB3+HeUotA7WIoybf9kK2324NgsomYZFsllup0MhPqIhcyDWImlqQoAPQ0v
	nQ2dqFuHJSPXi8LVmfuOXPfCnoTppmw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=YYEEHVNw;
	spf=pass (imf10.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794229196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aMEQbLRWx17UCfhc8SBN68gRj/bApfnEMsZRvsnpiIo=;
	b=yCKnxy+NTg6kSHsrZ85IYp4mgzJXMUx8ydna29paNzE/LrSEic1E9hCtl/m0DJfxTMlNrE
	0563eTzlrHxPLc1eTuMSJgQnVC5LIIyQPt7Qd+4hiJTkZN+Uj+a5/ntNJQp942Lgl09N2e
	CIx/I6pS2t/atM2kPfu0b5tFYcI9eg0=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3b083afebe4so76375a91.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 04:59:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794229195; x=1794833995; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aMEQbLRWx17UCfhc8SBN68gRj/bApfnEMsZRvsnpiIo=;
        b=YYEEHVNw/Hh8BB6gOXCrrSc47p3dgjDZ4iQt+2j9ByKzuMh2lcxWuunlZgNduSVRZW
         0M83K1JxkesAih/aY65HHeaOPvkhzHvUIIqf/Ywy7bdWwQADfQSUwzRGqHfELVREwAwC
         ib9ipf1PI5JeKfb5gStF15+KX34VFUAPiPGJgmddugKKeV6/1+xcAcOUHDwtoftZmUUZ
         DxNe4VXCGu+MCsMAZhqe2Bly8VwnfVmLghatyNvcP1W/9eFQYbIYAKDklQOTkhjHTSrh
         LiEMxwK4VhG27OIeA2/wDJwoZe+Q/EQcfM4eT3md1O9vGOQybA4rUPy7bwyO5KF/crbX
         HGEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794229195; x=1794833995;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aMEQbLRWx17UCfhc8SBN68gRj/bApfnEMsZRvsnpiIo=;
        b=qWzFO36M4T0uFvNFQ8mE1pM6tcfUVtFABnnJUuqZGyOT5UcOKrO/IUuHYzDyk8IcL7
         N9Gd2N29HID2bYC+P8gDjCMnX9kfljy4wkeM3cjimeN+ICN2gaHC1yO5bGya7V1Zx5qR
         EJjOu+AlZyb6+4ET1CejAhXfphnymMZ6+DVbe21L2G99J64UGwlL4zlwhzpepCCwMrlM
         R+FxP4jMmOJGyVVYHNXGwS+7E02EFvNhtAr1rWtjSyFaXKP2+2YOjx/H4BHzfyAeWG+x
         u9AI0VXJnpgYlrp/QxcKPf5I5yQpDnSzHirKLC/L4/0YxN/m/PvbyJ9cTa+27OJKY0RV
         aAyw==
X-Forwarded-Encrypted: i=1; AL+hErFmrEsLS3JnVZdqrfZY/n9lCnU44MsdB3yqWGQ308qk5QYBv3ckDfCzu/JrIxnt0eh5uu04eA+eQQ==@kvack.org
X-Gm-Message-State: APuU4Z/vDSZ22k+r2Nly35QDSPSLGR4ojHYzMSyJL8Rm27KNWvZpI9Hb
	woisxx01QewzVyr+j485UsKwh0N7FGv10KC0DaoctY1T9otg1H/h/I92
X-Gm-Gg: AYBFou0UCxmE5w3+uU0UvnDfxYiGUwiMY7GV/BceeiHbiODJNBEhCVYQU6bQV/u2/ay
	p3Fq6RDsfkCyg83ToUNcvTJ3ae48kAYdsPFxSSYD+AIWNH/Uvjk3o8sAEkO7YH86KOzqpvOZwY7
	V8u7dinPlj+1ji9C8NvmZdkvypq3PUtMgps+WOhBBVjnWrQc3sID7ay6Z9JmK36Spy5z6a5ymkR
	B4SQBZwrAkicnb7MIQ7iDb44EHQvL1McaOiA7UNXApRw/05OCPpF+1PjvzL9HiJcixaqPDKtQYJ
	UCjiKSYmAORfY7sbyOtUlwOw0AZtXDfrQXCLatuqdTXcUnncdP8OTjnSBXgOTlujoDgGIWJg8rP
	zsXOPVmfY+CQ2QYwSy1Yi8hlyZQMAwIY5ClHm+G77Qjle9CzvY8DOHQy1J8QQj9HCVp7iYYT3KT
	wfi3wKCk89SMthHhyifirs74eqQzHQTGmtfECdRtBncXRZak4Csw6pDDr5fIuVPtwR6fiZE2Od8
	yBTWo/iKtCof1emw7V747sp0Of2KrLLw1m8+ZXi+6xPszhh2blq3N1lS2QN/BMNpVZOWABKbDWE
	YN3OUNg7j0QNePfReepiX7QHwh61UiW9rY9cvbblRDMwC1U0ivi4alQxAVviq5fNx5k=
X-Received: by 2002:a17:90b:1802:b0:3a0:238b:db4d with SMTP id 98e67ed59e1d1-3b12d44183fmr6666950a91.5.1794229194774;
        Mon, 09 Nov 2026 04:59:54 -0800 (PST)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb969694aasm1534153a12.25.2026.11.09.04.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 04:59:54 -0800 (PST)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Date: Mon, 09 Nov 2026 20:59:31 +0800
Subject: [PATCH v2 3/3] docs: zsmalloc: describe statistics with
 CONFIG_DEBUG_FS
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261109-zsmalloc_stat-v2-3-caee41684aba@gmail.com>
References: <20261109-zsmalloc_stat-v2-0-caee41684aba@gmail.com>
In-Reply-To: <20261109-zsmalloc_stat-v2-0-caee41684aba@gmail.com>
To: Minchan Kim <minchan@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, 
 Nhat Pham <nphamcs@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Xueyuan Chen <xueyuan.chen21@gmail.com>
X-Mailer: b4 0.16.0
X-Stat-Signature: sfz4om5a568eonbq8uukrexezbt951ud
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 25DE7C0003
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794229195-752309
X-HE-Meta: U2FsdGVkX1+3ycDeaLDZv0+uzFDQTlsoXKsJbdDh8gr4QqUSmdjVJag8FynOIzDbCfVZsPcd3fvRqyPfbODtm/sDTS5lhL/Pgx0CZuA+zlVHSE8lqWZnBsnOCDdm4o38bSfT1VT5KYiX1WG9uY0DhWEv3XLVRShZSSaaJvADU9dw1cNDHkheFfmPsD0AT9JYmWbPjzqoph95YdLOseWurdchLpECZ74A8VkumCZ3tIO2KpZlq1pbE/j3D3n5MBZrzGMoRy2GggzUzpQVFh1B7QTjgXItoSwK79jppT9ShgFEoAP5xinKMWARmEgudiXpBjesRSrYL4/APxZK/R1rNpbncJ1hHcMn9cKpNnpOaMWamZzkHCa2K/nOUNJBfKY9fPf2G/wxpG1oum+TO7xLusnjjKUJ9wDUQw/8jWQw7JQyPWBJwoLzl3Adz1kJIjVygx9Xz5++Mw7svVIDKBcv3iLx9ZbnvLkKw1/rp3r+5nqQEIrglnI3c+P55uPkGJ4e/AsiTJ1lIesvokotU+fmwivhXn+r90lhH431/nzIqwK2GwBb6nOeEy9xi+weT/slfObjjx0W8HTz8zCEH1bATXOMj6R9jJewN5MBN4ZIfgFJM9YlJQSbsaVntcfw585fmHH0UNb7n0q0EbRdwrsTIpLFSEioe67L65TwVAVUdqLupVFzGveJ2HqcKqLjs/VBOx/pO77RprR/vBcECzO53xu/gfMpJ1S1viUnS9QnB4Ncvy3vMkOnZzf+ob+2XWLPIqmtI2U7f6v8k92A3i1J7gO5PEgqEJ8TgXHfnFZvEFAa8FRDDpUxAgWGj8pe502CHUgWFQmNHFXX7bK1wDe3mxuw9lxjjKf7n+sB/EYlMD3Q3fkpIKlHiQ+k3cHXrP8K2P3tnupJKMEE21cNl3beqM0TN43XL0fZjJsD59A4IGze8VpCsDXg8mFiH0bNOr/drm4l8uaFqDbfh7BGnaX
 +DGdO0Dm
 j69DDBa3A8AflYkRCdFf70kp+TrEEPKzOkbbipKBEw3nnkJs9ZNnQJcYgC4ipKqkltobT2LFup+hUEI1VECsPXlcqTOLyAbldAorBwkYxRZKv/aWojEeguTHBgKktvYG1mVrYz+OfyervAEM04/rQPZJ2fhkhFnX3EjujLtpoyZd8AAAos1FTFPlRNnyZwM1acqRsrTMK9O+s6sE6NUjpd0gDqVCiKOY6YiDZyKAvxJhaipectLYc5IAqh3H5hzABkTytBbET/Irla7lYBeVn5wTz4DxrvcfJMkHCTBnCro7/BAhifvI8XU1kDwtr+k7AnBEIL2Ukrh2AgUk8m468wkryRggH1FNVyhTc15QAqttnBAJrmMkYAAtL8cwH1Zlc5WYmRSLYbebOtexPprd+EQ8Hft0TLdBBWvVztjtdHCMYSCDAMQiZcLu8GfzZ1A+qUKs2/b3lNWTJ7QHb1r175RLKkKs3pTGQVzhow5owr7/TxGAgmDG1cuR6pFzNvfyXrZTGhCBXxUY52WBOyAb2y5WxDHbNd3TD+3u6a43eBWVsX/si8YmmWZzRSbtBk/ayiL23nvyzK1+/2B5M1UdWjkYK8FMyPPPvRp+AnShIqSYtWoE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Zsmalloc statistics are now available when debugfs is enabled. Replace
references to CONFIG_ZSMALLOC_STAT with CONFIG_DEBUG_FS in the English
and Chinese documentation.

Suggested-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 Documentation/mm/zsmalloc.rst                    | 2 +-
 Documentation/translations/zh_CN/mm/zsmalloc.rst | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/zsmalloc.rst b/Documentation/mm/zsmalloc.rst
index d2bbecd78e14..8c61733c6749 100644
--- a/Documentation/mm/zsmalloc.rst
+++ b/Documentation/mm/zsmalloc.rst
@@ -33,7 +33,7 @@ proper handle-based APIs.
 stat
 ====
 
-With CONFIG_ZSMALLOC_STAT, we could see zsmalloc internal information via
+With CONFIG_DEBUG_FS, we could see zsmalloc internal information via
 ``/sys/kernel/debug/zsmalloc/<user name>``. Here is a sample of stat output::
 
  # cat /sys/kernel/debug/zsmalloc/zram0/classes
diff --git a/Documentation/translations/zh_CN/mm/zsmalloc.rst b/Documentation/translations/zh_CN/mm/zsmalloc.rst
index 4c8c9b1006a9..d163f4aab341 100644
--- a/Documentation/translations/zh_CN/mm/zsmalloc.rst
+++ b/Documentation/translations/zh_CN/mm/zsmalloc.rst
@@ -32,7 +32,7 @@ zs_unmap_object()解除映射。
 stat
 ====
 
-通过CONFIG_ZSMALLOC_STAT，我们可以通过 ``/sys/kernel/debug/zsmalloc/<user name>``
+通过CONFIG_DEBUG_FS，我们可以通过 ``/sys/kernel/debug/zsmalloc/<user name>``
 看到zsmalloc内部信息。下面是一个统计输出的例子。::
 
  # cat /sys/kernel/debug/zsmalloc/zram0/classes

-- 
2.47.3


