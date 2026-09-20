Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AE86C982D7
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 02:31:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E0506B0095; Sat, 19 Sep 2026 22:31:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16B026B0096; Sat, 19 Sep 2026 22:31:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 032116B0098; Sat, 19 Sep 2026 22:31:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA6986B0095
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 22:31:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3AA3E4036B
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 02:31:30 +0000 (UTC)
X-FDA: 85232564340.30.D4B21B6
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6FA52100002
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 02:31:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pU+vjJ7g;
	spf=pass (imf14.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789871488;
	b=NCxCoJfw8pNQGptPEJYCUXYiD20bBhNCKWdQaqPHV5AwSS1yv9Rqqot+H5tM/Zbvl8Ehkp
	VTaZYYoLDVqfMxcQ+mqT7RvfSMw+yHxseHGYg68AyHw7pt/uZDxIM0bKdhKe4/y9hb1nTU
	DqWiuD31DSKPLh5kzH1tEW3NkLlaE5U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pU+vjJ7g;
	spf=pass (imf14.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789871488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ucMEt/HYfCdI1ngc+n5yPNtAEmxJEE4zo8QA8w8ZEKw=;
	b=TROrTZ4zI/mFwEgoiYEv5sbdpFlLwv9yBu4oywUHuxaGLSkybbqqZAk+wCN0xlhq3+JfOA
	htpyayzakAkeQkENyNeXfX/eke2cbX2BSONYVPtt15cgVzHXWjm/tqKBoHRYjZv/dn5PJo
	TyPEVfY5a905vArz7qDGX7N+EpwFuQY=
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-8692a856865so1849754b3a.2
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 19:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789871487; x=1790476287; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ucMEt/HYfCdI1ngc+n5yPNtAEmxJEE4zo8QA8w8ZEKw=;
        b=pU+vjJ7goStAjdhJ2DxjaeDbgz2koInyXUrpf3wCHovES2GqmEov62mR3ZgaBC3EKS
         x4m1bIgUR7nVZU1jY81qgHYhen6iKhe3ssa0ii32KMo4rjaBTp4bCa4KU30ZJvCzbzBm
         ldiWfPcyV4QzG2ZhXsIAjBO0BbTM0he39Bmv97jYv/yy8PinV30IjbdETtd8ZKUjjvKz
         0X3UxqibdJQwuJBnMi4E/Ys2kER8s8KPfOr8vAheWd1DvtG5enqa8xkXhd9r5Cpu3LPT
         +S0iOvj06vGI9+TTbzZr8j/z+d9zvtH4zqlz7hw3LDp0Z+378IOU5i36gp/CP/c24sgM
         LQ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789871487; x=1790476287;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ucMEt/HYfCdI1ngc+n5yPNtAEmxJEE4zo8QA8w8ZEKw=;
        b=j+0xVGIJYU5K5ThLmBtK4+BAoiiMJIWo6wSO/aPkE2wRtxT6ABN0Sb5WuTF9FJtj0h
         4ceqYogMSsWyMCdEH0RDU23kj2bDcEtpHFzuEuxHPmlZZ/UG3T5HvFykA66y59QtmVnA
         TUYDBD/8wWl3VarXaIM6nV4YPU+Gs0FH9Wg8T3tuVqYB0FZbvEySxwBLuvAL2NWKZFBP
         WHRrB1fr/qwJcHvIEKFwuKR19ioTF1A+SpcEyfO6n3tDazTNBW3aTS+SMggA7wDLH7hG
         JrchbgQNgL9hK7X8K3gK4z1eDrecxW4xJrw5UYkUqI0oSacn7U2f8aEmy1j59YmZ6kHd
         m3dg==
X-Forwarded-Encrypted: i=1; AKwUvBwDs23+HBS8NyVpHSnu5u5cijP0zHDD8G6djDFc+kcuKV537v3PTrCOB3eROj9E6nHJwVwzS6IoWg==@kvack.org
X-Gm-Message-State: AFuF++mkQPjTeosjUhJ7aJM9I1/55jToReNh9N7wY5Y4+e8F91LTinyd
	llbDEsZv+PFlgJRRP99IAd1WYDutQmdBlh1eFM8mYHNicdzQykhyJ9A=
X-Gm-Gg: AYBFou1YyHljUsjwzlgSx2x4IwhPtB327V03PwTUxzpk4L3tGCg/MvYRnnA9fS8/ndY
	aDWbh443EFZiniS7Pof1MxaSo1JOBJPUbctJAJHjVJKzqLLahYfyoe7/4mLyrAD6EvHGLRNDVq8
	RJWGYfzPnpJwePTDairFuciIz2gbP0fGUTwDwa6Vlz6BxR48U4/9NvS2sO6JPGxfLGS1KlfhwYN
	yCYKil//ohiKRjFJ2mCV9zuzpayaHiJUDLLahEXpO2nVKGxEDhd7mGgTDtUfzD4f4gCJcbEGM1O
	Nr6k44Sqhd7lPTHBTmAczCbrH5COjWRrGV0+KwVtlwvBPm5nNxQcZNxyYwPoHNM+olXEBhsg731
	EC3OVR2sGW9dfkpnjY4W/zEa7nSYVilRydcVG7kzxatokGSCafX375QskXoDWBW++/ufixwGXmG
	PTq26eT3icmvh9Qm0zfaNvmbrQoeJ/2S8zQ7/pIa8uE4eAzVVXUmsD63t5t32luGXW3TC9FRgQR
	lHj8xCpXIQAJ623Tink/xyBZZvIiydv4TxMDQ==
X-Received: by 2002:a05:6a20:2586:b0:3dd:85a8:4c66 with SMTP id adf61e73a8af0-3dd8c5db1e1mr10707714637.45.1789871487313;
        Sat, 19 Sep 2026 19:31:27 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([2001:2d8:7f00:8c85:36d8:54a:e0bc:3e5e])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc72aee03efsm1481341a12.24.2026.09.19.19.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 19:31:26 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	donggeunyoo.kernel@gmail.com,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH v2 3/3] Docs/admin-guide/mm/damon/usage: document the temporal tuner's quota limit
Date: Sun, 20 Sep 2026 11:31:11 +0900
Message-ID: <20260920023111.2466265-4-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260920023111.2466265-1-donggeunyoo.kernel@gmail.com>
References: <20260920023111.2466265-1-donggeunyoo.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6FA52100002
X-Stat-Signature: s6bbpwkhcwb89uokbz89weeodsy96oqm
X-HE-Tag: 1789871488-425525
X-HE-Meta: U2FsdGVkX1/kyczZKyBzzyoZy3nSLV5FWOeE18bQNvVwC7hNbq+f4yMh6Yyl8SRfDSZ5Cm8s3rj1NfLeRuRQmm+jETE9llNWRzhT3H5cwA09HsZ2K2lK/GMzKJp+qwSBZA4lmBggHIv2S5IpOEnNLVLMnnuYf3sWkCDwwIIzdKZqvTXQaBlQq/PNqGHd2oWZvlC4fOM7XjBSPK/B6h0p6o0fqgoZmTDd+98B1QUSICk4MMRKwy8f8PFkz90p9aqBqVSPVtS5mNDYTM2Z9f4BLwBTauXzCOOPqJh/+EPijg/IYnOQiiXZwfqVD6YQ0KFtg68DHy1Jdscke99WhslatVEDr6CuFZUlscMHoOP1HkMpqnCH7QgcEwvt+TNzrxwjDUdZAi2ZMTeCpKZHCcJZjb3BscRT+MyUDgK3JL7Ull88mEDnZqk6hcFqJBHxyAze2HJdYB3tnTIT5UI7+Be/LD86tMlTNqtgOxsjP+1xk6vlK5z+7uiITlRiw2SLJjmmVOfuws1EexoqR+mHjKFp57RqqofUf8lVyr3gX49FiDGS4uKCmo0A0tWi3IdZddO7TUeR0zk4vMFSjDKrvGyev3hU/aiJ5k92wp+y6P3eddlSsyUc+6+HYLArjqoBrQ40JYCqQqKDbI/svhreT2Tpu1mACLFZgf/e1IH7+dHhSxn92B1n1CXRuAAsU3b4zdqV5NoXwV+Upf3G3paNzQAjlvFSDmDb9vGaWDl4hSnyaZATPTcJMprPoefQb9EkmQrf8MB1SF4DTwGHf4fm57xdh0VZD/pi9VYcmotNHU7LBUkxG+fZmWT964Loa0/AmbsP4dI5/gZ8puNXqBYlZQPXZwdtYjN/v1y8zxINf5GjpgGGTpt8Q9vwVpLtCIgXhgeoyG+7tzUUFhuzRSFS9SoAkB2CJXFWrDvFPnuWLcvpJVbxKigvUmbYxNsuKvMQXSynDBBe2iUza8r35DnVofk
 Imo7mvHO
 fWmgGff0Qx3kJufzwaqRXl5JTSaEZeTVaymPF98gAG+oZ81tsOGhEgXOT9i4YQrfmXAwWXsRBLkOSKCRTKO8CP6OB0nstjpiB4XxcofK3Jt5IXaiDatmeB1FH1y13y+5OzCmZVVUAblLZjeLhK3ippcOdJQRRD0QFu9r/Mskr/IGSPMxoaHTaWPkx9my4BOdFFQmv+PHqpHDFsuRz6UkzK54HhL3r8oGX/3P6dTvGxRpQx5p9vd6h8V2xPMV4K8P/bu3Di9vtiedJ871cCAjT6VTxkT4EylNULxT1SZNC8YYt3VcbXl9x4jltKzCPfnSQ0sYk6pjlV3rTeYHkA4n+jpadfFweR07Dz+RwQOrrbFgWdw7h3R2Zj8sf50TfNR3usVfQXwhTMWjF/WlvN/I6OSiL/BSxFkByzeb8cezBYQgg0TjahQB7YQSSY41U3QQw4HmY3j/uAIXFVkWTVi0XZj38VotbGY4nGNuYW438LEJUUq1nX1zIi54LzbffJGmat/LkI+MI7S5u9dAhY20mjFYMmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The temporal goal tuner converts the size quota into basis points in an
unsigned long, so a quotas/bytes above ULONG_MAX / 10000 does not fit,
and is handled as if no size quota were set.  On 32-bit that is 429496
bytes, well below the "echo $((1024*1024*1024)) > quotas/bytes" this
document instructs.  addr_unit does not raise the limit, though a larger
unit does make it harder to reach.

Note both in the goal_tuner description.

Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
---
 Documentation/admin-guide/mm/damon/usage.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index ba47255448564..ea7443b307826 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -455,6 +455,13 @@ the background design of the feature and the name of the selectable algorithms.
 Refer to :ref:`goals directory <sysfs_schemes_quota_goals>` for the goals
 setup.
 
+The ``temporal`` algorithm converts the size quota into basis points, so it
+cannot represent a ``bytes`` value larger than 429496 on 32-bit kernels, or
+1844674407370955 on 64-bit ones.  Larger values are handled as if no size
+quota were set.  :ref:`addr_unit <damon_design_addr_unit>` does not raise the
+limit, but it does make the limit harder to reach: with a larger unit, the
+same amount of memory is written to ``bytes`` as a smaller number.
+
 You can set the action-failed memory quota charging ratio by writing the
 numerator and the denominator for the ratio to ``fail_charge_num`` and
 ``fail_charge_denom`` files, respectively.  Reading those files will return the
-- 
2.53.0


