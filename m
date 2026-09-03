Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF988C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 14:11:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E74A96B009B; Thu,  3 Sep 2026 10:11:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E25236B009D; Thu,  3 Sep 2026 10:11:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3AE56B009F; Thu,  3 Sep 2026 10:11:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B731A6B009B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:11:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 361F8140557
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:11:33 +0000 (UTC)
X-FDA: 85172638866.22.15D04FD
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4F263C0008
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:11:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="cmuTnD/8";
	spf=pass (imf28.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788444691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VPIQ9McsdCmFW0ky9DkUl1cuYHBnvVUK/3wd/D/dbMo=;
	b=JjKdpoCK0jxfRJ3wBrf5d1qq24ZlztmUhPI8tt7AbObFHMJw+nIgiXMIyxWWke5tRfo6+J
	sqqL8R0OKL2brNXcBaOP0w2d4c9x+D2NXT/zOBSRzK68pyw7ZrWoZL0QdlifgkFpMrUjHy
	jz6DbWY0iTxeFxrERQgndzY3JIkDSz8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788444691;
	b=JndRYtmJt0Ccs2vqt/+1us9E9yRWZ0e5rVLu697VPcBqiCPg02ztfBGeE7JPVdECcEAH9A
	DxgJmeGgJPYXnmxr7WXs/y0rV2L3GgYd2C3l2im1LZ+BGwQkLJKOglZfz9UpBV2bHlFGuZ
	XqXcZc3gOpZA9TceSzTN7OawZt5MrqM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="cmuTnD/8";
	spf=pass (imf28.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8568e3ed034so2021151b3a.0
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 07:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788444690; x=1789049490; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VPIQ9McsdCmFW0ky9DkUl1cuYHBnvVUK/3wd/D/dbMo=;
        b=cmuTnD/8/EDT0ok99ifqIfbYHYrjef4t3KyhoB54FboTXiycGKKEgFLlGbi/Dw+NGF
         Y69MnVjEbH4jts/I6w62AInkSdMCvx45HM72wTE7pcTYpd6gqndJMhiITi+NY2Dl8lMt
         Q2P8paldRg0B+0Wb+REQJOz3r+CHGAKM5y2Vs/qPZ3PnoWdUTC0kq7cebZx6R/FX6Sh/
         H/+alY3lGba5PM1GCL4G92FJMpEZSr7ICgV4aPpUNzSwCa94cXxMHovthmntYXHJytaY
         TbqstRUXGgskxYDs7xvQV/+i3Gu9DMvPJfraZG+lCNFvgPR7TQzHjOUNOtqMcneV8Jtv
         JArw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788444690; x=1789049490;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VPIQ9McsdCmFW0ky9DkUl1cuYHBnvVUK/3wd/D/dbMo=;
        b=P91H+vmEDk9KDc88Hk+puv5SAh0My174rnoKCuejYQBksdBc2mJMoFNQDqBsDohElt
         5laCfgcSL4Q5EaJfmsnfz4M+XmkJWa9XB69Y900AwRgj37NTDTw1sgc7WHQ1LFmWyU+h
         SW6udQjoIt0FYXxLtO626PzrRceumSfvMfUN5l8LPYcFVXwiekhNDi5lX5FVknDTcUv5
         HTqR3YmJ9dfOaIOINbReywhgwEVxmBowS9RqPJwTyxg56uAvfJIieY82XzSg4IPvQjgv
         dkpH6qu7GOlOKVPVCfx5lH5qN/a3OopI38OK/e5DihKR3PmLl+NYOtZYFLrchVSMqNRk
         GsZw==
X-Forwarded-Encrypted: i=1; AKwUvByb1YtZ19qZr9DRjKXKFBLyQT8KtX5ZTyIEMjmQXr8t6A6UYozp5nNJ6dWRb2FmEAsKNZN8VaaeYw==@kvack.org
X-Gm-Message-State: AFuF++nEvt5Xr33Wc2EmwZfA8q3T1AptXq6XBC7LjTfFx6KHpo6LJRrD
	h3svNfV/LT0acZ5l1kvXHCh5jNMctnYL14/3Ge2MyN0oKynLIUifWJCH
X-Gm-Gg: AYBFou1svYZTPOp4UETCXkQLM2qJEfKjyX1A+ovvo8KjF4ED7myCOOKKjPQsPi4zKxV
	eRHWkl1yBAgncod7A6BYzSnA97nnjS/hEJlRQsZmgTQNH0upbTQaHn1zMSV6BevnkN0bbu+PMRU
	YiHkRsO4K8gcvnJvUHYgvbtZtd8Tww7GAFAA3ufOMuvcD86iTCU75XeTkIaTQ/Rjw8XZEqy/eta
	Y083z2VgPrRLkUwu4pNKwy6XAFxyalDQsdNiehgdlz0S62WZ9UP1NTCAjML2SJe4Qx9fuGI2tog
	NidnS1XM5y2lgqIli0SSzgjZzMd1p4+eWUAmaaY1ECo5CvxEm1AQ/Q/4yVKCs4CdS8/+6bDdCSX
	dbj66izhfCMCF6Bq4zseaGIJ29NWLXxrvFbLysPsWUogcFCzHRqeJcovMFqBTEQMRxS+Uqfubun
	PGvp+Z+xAylRZPIAtSotBAcDTg/Oo/dsgiJBanZkUmy0Baiu8NXtTBtXzIDaC2GIZ34+qIlFl8f
	4c6Gw==
X-Received: by 2002:a05:6a21:339f:b0:3cc:c7cf:5a44 with SMTP id adf61e73a8af0-3da35d58a30mr280799637.2.1788444689934;
        Thu, 03 Sep 2026 07:11:29 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc43d240f21sm1049960a12.3.2026.09.03.07.11.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 07:11:29 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: akpm@linux-foundation.org,
	vbabka@kernel.org,
	david@kernel.org
Cc: surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhaonanzhe@xiaomi.com,
	lipengfei28@xiaomi.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] mm: compaction: make proactive compaction mTHP-aware
Date: Thu,  3 Sep 2026 22:11:15 +0800
Message-Id: <20260903141115.4107677-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260825043833.2659350-2-zhangbo56@xiaomi.com>
References: <20260825043833.2659350-2-zhangbo56@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4F263C0008
X-Stat-Signature: 4xz5413smjza9mrxdgxttbgah9hh1egj
X-HE-Tag: 1788444691-608717
X-HE-Meta: U2FsdGVkX18CL/z0RNeQs21xyirAYYsU/o+wchJUMIyz4/TjbJ9u4s2EomIVTXA/rqhIGFHQV5Bu5tSfWd2rb7c48hcyWxAZaTn71d0qi7OCvTzd/X57uxrHpgBzoQ+nfbhVR30KjgRRDd+c0pFfgi/bRF4AC5JNTbVoqKiToJPzhj3YgOP6AFOsOkSrIm5cyjjErbP0NsEqtlMWRXTZPTC6lHgLdqcPSOovafPC6FQkkn/TrNVCiFwwhMR7B98CScv8Mzb+cHrmeg4zBbhQbO93X9vtuAmPiIFq89C8UC6weWyGQX4lxjd9QAk4RUBLLMlkW1J2HikkjYQUiNRY5SQiiUgZUBIolsnllnzLbCQs9P27vMNFurPwS1TSKACORQ8qbleR6h93LipKCZ6f+3fRcjRNIyX4UopUBXtIoHKpsYtdaLZBQYu8PpNEiM6ZZufKBTJpx/5l1y2nu1Lmk3TUocNuZCrElaEvrarUhJZXfidui87QNDvM3Jgr5fitUWOtmNWcT5vPV4OJ+YhH83s9qGm8+x/9NhgVCTi1zlRhubv6bfjVG/rcaNKG9J9L7+/9pe1yQJrQikFKSgHlXCXRk3xaNJ1t/bH3T+EtrMU09RwQRo7A+nsDc5Zd6L7i6QB4ZFN+gfY35vIvdjIKsltHgUKGyt2s0k7s/EYTMxFL6XIBq0vJnkNDuvV3VMKd8AT/J3OnKQj3GCNqwdgPpjKmvZVbDl5Lan41uxmsG1n8zuGqoR2KNYqoHrKkjZFqdUgpzlXlkyaGjiWv13ZaUenLvxab4lg3bf7qDtOIryRVD9wC2k+4wFo1/jP8XQq2q1jd6o3+Sqi68y7fkpR46GbNn48kVYSHttSCq5twhwwxIRtrPThVEfQBMgs7BBWjaf7hZIRkWH60kiNCaAbyDTgSAlpcRJI6grOvOk8Gh4yfqiLn1s/KMVVOWLCAkPBgEh4HyqV6/Omscuflp07
 FFVvBu3W
 Ps+rl5di0P5Qi/ssvJ0r6+ygZpIyWGc4bOz3nSaHKUj+Yjl8XrvT6EsTJBYnpD0PwwF1C3gWrrPmRu0gsbrV4BEqG3rtssZD3Zm6Z/Lf9Bn9SSJniXwoU+bs0beIjHPEIqZXIz9Yk8AcEm3LjCdSbQfc6JgLI8mmvAWOMOuXCWgwxhPSw00YVveQXyQLMJ+x0Mt/eleLd5ZYRcBJNtIMDRLoZSPqSVa6OI/4d6bMqWZdWn9qbm/sgit7mwWQc7Kyur3VPly1wviaQvphSUN0fApNoPn71qCzJW56yj8PWBBPwiuQ42FD1C46NNzJjUpoU5MHJkSm+gJlGIQaz/WHFsmoU6jEHvd3mhW5o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the review. Replying to the three points below.

1) Build breakage when CONFIG_TRANSPARENT_HUGEPAGE is disabled

Sashiko says

"Does this break the build when CONFIG_TRANSPARENT_HUGEPAGE is disabled?
In include/linux/huge_mm.h, the declaration of huge_anon_orders_always is
guarded by #ifdef CONFIG_TRANSPARENT_HUGEPAGE, but here it is referenced
unconditionally."

You're right (the kernel test robot reported the same on m68k). In v2 I'll
guard the access with #ifdef CONFIG_TRANSPARENT_HUGEPAGE and fall back to
COMPACTION_HPAGE_ORDER.

2) __ffs() singles out the lowest enabled mTHP order

Sashiko says

"If an administrator enables both order-2 and order-9 THPs, it seems this
will return order-2, and __compact_finished() will halt compaction early
once enough order-2 blocks are formed, potentially starving the system of
order-9 THPs."

Yes, this is a deliberate simplification, also raised as an open question
in the cover letter. I don't have a firm answer on the best policy for
multiple enabled orders yet and would welcome opinions.

3) Racing with concurrent sysfs updates

Sashiko says

"kcompactd() caches the target order ... However, __compact_finished()
dynamically re-reads it here. If the target order changes mid-compaction
... Could this mismatch falsely indicate a lack of progress and erroneously
defer proactive compaction?"

Good catch. The clean fix would be to read the order once and plumb it
through the compaction path. But during proactive compaction target_order
is -1, and I couldn't find a clean way to pass the mTHP order down - which
is why the code reads huge_anon_orders_always directly. This is the open
question I raised in the cover letter; suggestions welcome.

Bo

