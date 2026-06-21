Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AA8CCD98F2
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 15:48:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD1D86B0005; Sun, 21 Jun 2026 11:48:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D824B6B008A; Sun, 21 Jun 2026 11:48:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C72646B008C; Sun, 21 Jun 2026 11:48:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A1F096B0005
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 11:48:17 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 08469166AE9
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:48:17 +0000 (UTC)
X-FDA: 84904351434.18.289D927
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8DA541C0006
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:48:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FrxISM1z;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782056895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WgPuBJVNaV8iXn7vMN0W8u2z/1iTfOUDdPi402d7mmA=;
	b=yBnTtLdXJcTJsNT2ThFRMiebM9KECoNZK5WAx0ujcd+cv3PwuC2y/W5B1Jvw6YXZrVCBeu
	Lz2x0P005MH9EMe0CaOgyk4jwXqcHxGeVtoNyAKGcMgsBpNBe3hBxvt6iyoOlFuhdFuk89
	8w+5hCm8+2Idkf3t3XAEKiAy4jkw6uE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782056895;
	b=Od8mVytJTAY5AvEtrA9hOHhxhDbaVV6ho0Xa/esRavM9OHJBjIV6PPGpa1yiJjbT2MdkAN
	TBnju8IRUcflRSj0kjsJBmnyd4BrXxMQE5MlU/lYJY5Q6yo+vkrn9YL5JdtAIAABpAMYtV
	8F1qvfYxyMxCE5OMGbsf6kXPwokdD/g=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FrxISM1z;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 733D543963;
	Sun, 21 Jun 2026 15:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD3451F000E9;
	Sun, 21 Jun 2026 15:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782056894;
	bh=WgPuBJVNaV8iXn7vMN0W8u2z/1iTfOUDdPi402d7mmA=;
	h=From:To:Cc:Subject:Date;
	b=FrxISM1zgRMO/d2IZ5VFsU3Ox0FmX7tXAqncJWmvpdLmADHpGk5f73S+Sa8rwE1ke
	 c92AVcPIS2diEorB5JftN6EPClV3Bh1YXbPa/XL3Hsxv4BqbUzSXoaA+9zg5RUA4m5
	 f17g6DRjmnQgyJ4PlEZcQ0iDiALUK3mUtII/AoZX3hW0EFPcBqKKrct8tB/XNMikPq
	 lS3ppE5VKbLTjgQjnAwaAIPmVwsEi9LAUZN7WM6zL47PTneVqziTs7iimFVCPzUMC5
	 RtOxN1QmyRV23E7EMZfjeb5DwoUOnqrLuHr+GdUr3xh5VmjLbzVJCAApx+mfCxnrNo
	 djxouOXt73YQQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 16 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm/damon/core: handle zero intervals in damon_max_nr_accesses()
Date: Sun, 21 Jun 2026 08:48:06 -0700
Message-ID: <20260621154808.86431-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3ryhhn9i1wjxiuw8kpyq9kdbhdyk151r
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8DA541C0006
X-HE-Tag: 1782056895-777066
X-HE-Meta: U2FsdGVkX1+oV9DJq+yRNKD7KgNsvw+e0U/FYFWnpU5CMY9TUHPIEBcDpeTMmnJycY1MT0MNudkilzdeiZv5ZRXpde8Nc0v6if23oBsKv9TjaATcgHLjdHws8cN36fGIAciugWcga2wiR8fupYXySRNxr0MQ4nwqnIF/gwbK5TH4np+ETrjILhrpuXfc81VqYKesvdTPO6OSTeyYpVR0JYT4fnQad3eLmt1rHzHS3YHoFxAcXXLoe9gn5mPyMXsqzJrik4Pzq7BJ3oc6O/Xe1hubwl1jmKpsGJSbS+We7qvdnTaBuZKge5AydqresBjbBOi49ZvcodGHF3kMAac7//Fm7+z3pBnZTVYORfHH5D8JjVNEld10JR+Wr9CuXVurQxk4nG8rMycSyr3ZiMVMYXepkUZQZ60VpoAbjz6hj4C+Zk6+s4cw1uxy88MFlDkldWZU6jAxw9+Q7jFgydWJ5yYWMv1FiuwYHLSN+mXyG4JzIgI/1R8oCtG6iLKdz/fwzoEMiEr6AxKxfDWTK+lxVkxuDhZzDYFt8n1TgJI21vabeQp80+X+zbxJccbQ4ZkZEYJSz2iF1QBEYlJjvAytPKhNO8lFLOQegXZ+6SvnqkAM1rcF0DZL9HGDK8Kt9/7VEmG3t8g+tWOXqeVw5XrYxAuxjnAntj1Rr82UODDxwdiLjg0saksQg0RZK/EEOmpg/ezkmpu38cn2513FaSsmJBbDmkvgK5dGYhTYlZZ3/0vlHlmuKRvAVtVPkOHgMOIMBL4x3i5tz2fAzZZKjM520P8DNvsRSLs5kyjz699l1p5RpO4Zixaoc65amqzqWhxiqL3UNVsVzyGLag4e8tcufDVpxEBwIhJQ5ow3enGpA5mDcBhasgWqOFXMvVc4+2n6AK5KYivvP+n8+LDV4l9uoAYiIqLRS2WjH0fbrluDdye9/7wjrwrro02Xe0RDfu3C7QWB/T2nSFcsbbOF9b5
 6cI1BxaC
 4/KmW/DaeRWY3wmztvAfhEtvwXFwfHhTnihEMgkeotXoajlknfzfLhl7xwSFl3xNlqaOt2Szngnx6g67HqK71zNpfFPOgIGP/vMkwvHnsOqjf1s+RMINRcZWVq+hDjeKSZiDjgf4oM+bRWbDv6sTaFzOMZTTesQKCOR7xCci6Yc7XpC4ysscv6KEhFNKAreG845cog5twTjquPJ3+eNNLnIa6quXVJL7WuFIQry+lJfqiO9UWEO0yo7owC8kxDiylGtzCGCub2NPPmASvG2bCLAgnfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_max_nr_accesses() causes a divide-by-zero if the sampling interval
is set to zero by the user.  If the aggregation interval is set to zero,
the function returns zero.  It is wrong, since the real maximum
nr_acceses in the setup should be one.  Worse yet, it can cause another
divide-by-zero from its caller, damon_hot_score(), since it uses
damon_max_nr_accesses() return value as a denominator.

Fix the problem by setting the denominator in the function as 1 when the
sampling interval is zero.  Also ensure the return value is always 1 or
greater.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260619202459.145010-1-sj@kernel.org

Fixes: 198f0f4c58b9 ("mm/damon/vaddr,paddr: support pageout prioritization")
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Changes from RFC v1.1
- rfc v1.1: https://lore.kernel.org/20260620171413.89555-1-sj@kernel.org
- Wordsmith commit message.
- Drop RFC tag.
Changes from RFC v1
- rfc v1: https://lore.kernel.org/20260619205144.150664-1-sj@kernel.org
- Handle zero aggr_interval case.

 include/linux/damon.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 64d75c78f4df4..02ac34537df9a 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1066,9 +1066,13 @@ static inline bool damon_target_has_pid(const struct damon_ctx *ctx)
 
 static inline unsigned int damon_max_nr_accesses(const struct damon_attrs *attrs)
 {
-	/* {aggr,sample}_interval are unsigned long, hence could overflow */
-	return min(attrs->aggr_interval / attrs->sample_interval,
+	unsigned long sample_interval;
+	unsigned long max_nr_accesses;
+
+	sample_interval = attrs->sample_interval ? : 1;
+	max_nr_accesses = min(attrs->aggr_interval / sample_interval,
 			(unsigned long)UINT_MAX);
+	return max_nr_accesses ? : 1;
 }
 
 

base-commit: 7a58ae62cdf3c006a53b805bbb12079ab2621a07
-- 
2.47.3

