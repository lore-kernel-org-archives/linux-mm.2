Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EF9EFD88ED
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 05:17:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 250926B0088; Sat, 14 Mar 2026 01:17:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 227FB6B0089; Sat, 14 Mar 2026 01:17:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15F3B6B008A; Sat, 14 Mar 2026 01:17:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F3EB06B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 01:17:13 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 91FA6C2292
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 05:17:13 +0000 (UTC)
X-FDA: 84543509946.07.537C349
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0530820006
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 05:17:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LRgPdNx1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773465432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SmjyQxnWiEmoSjbr0D6XvGwBmi06WYy7Onj/F9iGGyw=;
	b=R8OxatblgtF+9jJOOsO/eiXrnC+hon+ZEhdfgSUK/kzUSVvso0Hb4m4aVpnaV4zCO24D5H
	9qip/cdYhZrtDGqN8cYrbzOX/Mq6JtnLMST0dfNVjH5y8J+hWJQzQ3WpkcvcQpSm3V4JI5
	5GNJKbMFRaykpNLT9LW59Xsdmm8mBTI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LRgPdNx1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773465432; a=rsa-sha256;
	cv=none;
	b=AOSeze9Zk4U3LiOB6PyKOMMVHU4PB4jCDFDv4njNccWnzyd+L2ysMyekOwA1IdQisYASxC
	7Tvpk47SAmRSyMJcHbyqv425xZCrFNIIyODOwTCTdGQPNjs3BTEusl/g61rr7xKpk3yvLE
	d9aQmKfvBKPW8o4sSp15uPHlNAUuYfc=
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-1274204434bso2462117c88.1
        for <linux-mm@kvack.org>; Fri, 13 Mar 2026 22:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773465431; x=1774070231; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SmjyQxnWiEmoSjbr0D6XvGwBmi06WYy7Onj/F9iGGyw=;
        b=LRgPdNx18PLdr6hCgob8+/qdqQcQQNhEB/gJHiVyZePQTagRwvhgKNpdlhycmYpd1C
         gBbeaJkI/vAsKaAvms+dgw/18I54jKJAccvVYy7BZu9e1p+9V/dQ0jxf4otV14qA5Oos
         sV0NoGQ/XHnpzaDoPabHQd2PabsiI80rOZidqlGPTdqzhTVtKa71Db/mCeGUoRlPj6PR
         PjealYg69bZrB/3IVAR9VyApUv9ZH0IkRJZGcd+VF0PmVbgMTizHvllao3K5Qm5/Tv5Z
         zqDQ5FGKeJQuNOgy5QiYlrh+ZSvXVXIxLOSYdPRMdqUO/i6gMzSpRTvcEZLVM6hr2HRu
         2org==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773465431; x=1774070231;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SmjyQxnWiEmoSjbr0D6XvGwBmi06WYy7Onj/F9iGGyw=;
        b=n5ji5lb30Dw3H4xxG32Zq1+ROIaiSXdrXbiccC094hXnboX4FqjhmsgDxRQPo5jue6
         rHdXi6jL+r03WHZPknAn5MCdEDfe5PnS7c+X9G05pYpYH+27eZSAwtdjDRPfo9l/xGSg
         O9xEmjsnd/oF7ac91yDRdghSq8ICYKF2q3//qQgA3dUVM/nBnLw0migfb8kDhlzebRyD
         rHnNZPjRtF/OhU223ZxKsrkSJzcSvOzRwo5iZ+bssaYP9zfJhp09Q99D+RR3ntueg3T/
         GxRg62zWA2V6Y29mkkHsoxOA4XsoSXdkhEQj5S42Z4Jr/Djr1FjxScBk/XnyX89CPtwg
         yUSA==
X-Forwarded-Encrypted: i=1; AJvYcCWsR+L7aVE4GaEFeP84eXjXoGZScRXrnjP9LsGE09sADrS17KCrYjQn4/C5o0wKpzc+pCxQvHJjVQ==@kvack.org
X-Gm-Message-State: AOJu0YxWeoj2gUlL18VTizOv1onPVWkTPgEHkGb27eSt2IJ4NkUBvYF3
	3FGKi4vgEh4aMWKwMwZCqPljs+mk/ecKfB0a9uJ2gYi7Uo9ntE3CW3v6
X-Gm-Gg: ATEYQzzO4GVBCun8BKeqyspOh8ydNxu25v5IVgu5cA1FBWW+MQETIxY/fnDhiyVC51+
	itTOa3dv1PI3ykwwQjuIlPELAWJtegEErY8apvvtP5SU+LCEDMVOoA9DfojKdhI7ThNz9w7mZY2
	uU1UQC+L3s29gR4Q7bLHiM44um6EYc1eLRMRzgdjlR375wFAMdh0O2fMPuKmGC8+RLxk76rAtDb
	RUkcWrxQ0woIGbpoAUpJT7Xh4bnT2APuCZDDA8yeLcEQqt9nlDYfyqBXp5D/0H63hseMiTEKWlO
	DPHwlKIiX4G5rB2MVjcJ87vgTjUyMVg/1jkU7tMyMmCAzt4Raj+Z8TQP7FUT+PylA+N772nKYc+
	LChPDF7sclpDyQbgTpV0mta5PSlWv46QO109AurSEdsLFbHU/xjm7UquWl5UaLVQmmCUqA1gyPY
	sSBj7etyy7GW2YIY16II12kCA=
X-Received: by 2002:a05:7022:6187:b0:11a:fb0a:ceca with SMTP id a92af1059eb24-128ecc0559dmr4092464c88.16.1773465430616;
        Fri, 13 Mar 2026 22:17:10 -0700 (PDT)
Received: from penguin.lxd ([2601:647:6400:3ec0:216:3eff:fecd:e4ef])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-128f639a160sm4856196c88.12.2026.03.13.22.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 22:17:09 -0700 (PDT)
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
To: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	akpm@linux-foundation.org,
	kanchanapsridhar2026@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: herbert@gondor.apana.org.au,
	senozhatsky@chromium.org
Subject: [PATCH 0/2] zswap pool per-CPU acomp_ctx simplifications
Date: Fri, 13 Mar 2026 22:16:30 -0700
Message-Id: <20260314051632.17931-1-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0530820006
X-Stat-Signature: gou6k7abwu1e39o3e81etpazhr3iatt8
X-Rspam-User: 
X-HE-Tag: 1773465431-279748
X-HE-Meta: U2FsdGVkX19kRfTdVHHxXrW7Xg6A5VzXGTgl99p6W4jhGjIJ7FuESKYsx0RzGySYHnCuZQ1gG16Z9ljo4N367aVoq1o96YWM1vp6b5BtLCLlLKGCTav5Drp5C4Xm5wVG0/3T6trPlSjfv4m4N8NYRU7nyGfOIa79FqxSw0KsGVRmuYsVA77ptVpcveJRkG56MN5H8/U0vniHx65Uk55neRJ0jK7ZVXVR5z0YBXK830vNyrP9jS8tV6PIOi4y1hu41LlRDp35Xrni3J+w5B/2p+5jTLbDwyeqgrNqeV8y4jiwg5Qjjkfp6L33Mrsnj2BojIQi24VttjjYp7oWW+Nk/DzMivcVyfVEh3Ky52Aj2noN0Mqgm/t7LN7ai2CXOEFRUeE+bmb3PrahnrDi3PcOoO44C5rRaRJ1utmFMAc+erLuBnmFS5AuXJOF7ReLk96jkvFvFd4mYMlEwzrk/CiMMJK6nrxWRwyPKJ1up02O0oDBATqNwl54AziSE/d5h+806THDPJQu+EQFm3IttLMdmUy1k1Qtk1d+0pT4hee97rbF5xJ7GSDk8rqSj3sWjO+U/z03zLJcSnxPTHfyK8fW8IuWdF10tRWZwoqgdOrgWqpI/kU4kvxLZFO7bYN8rm3FWCFYaFs0T7gOGZeKfOtIg4qp3pWTIDf5gGR9h9uFCxQXXFRfvTdHEFxKFwKKoOXDUj4arwOVs7GG3q3AifaI1q7NNS64Z4/GqFKiHeyqqZGJQkxJASZLtBtLxfKCbBQN6M6u1KLIKBTJCegrzGPH7vceYGYM0EEVL9pnGHyZb/WIQukz8DrLR7i0aOIRCDtLHJxmMKO5R37hbPsGN8ssCCs0GJ1nq0gCOQC8mmydJOu3WNscqMmdl3bfuCqJpA3uG+h7I7dKsP03THRq9AaqQYOuEeLmIxCUjBI/IBCx06IOEs+O2Q5BtM3Vo6uDmm6rod+vo5LvTdq7qH36H4c
 JZsGHhKi
 14YK0FVHKqJ3D3E+xmVO3gp3iRUa1iSwVx3YYxAnranv/ve3eT6kSN2FmP0dTta4lS9Xk/DfTe89sSxS0CJzoIT8Q5tmqPhO+6NAL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset persists the zswap pool's per-CPU acomp_ctx resources to
last until the pool is destroyed. It then simplifies the per-CPU
acomp_ctx mutex locking in zswap_compress()/zswap_decompress().

Further, it consistently uses the same checks for valid
acomp_ctx->acomp/req in zswap procedures that allocate/deallocate
acomp_ctx members.

These are independent submissions of patches 23 and 24 from [1], to
facilitate merging. The Acks are preserved from [1].

[1]: https://patchwork.kernel.org/project/linux-mm/list/?series=1046677

Kanchana P. Sridhar (2):
  mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool.
  mm: zswap: Consistently use IS_ERR_OR_NULL() to check acomp_ctx
    resources.

 mm/zswap.c | 163 ++++++++++++++++++++++-------------------------------
 1 file changed, 66 insertions(+), 97 deletions(-)

-- 
2.39.5


