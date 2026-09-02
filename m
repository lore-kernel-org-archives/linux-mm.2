Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F979C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 05:48:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A23D6B0098; Wed,  2 Sep 2026 01:47:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1794F6B009B; Wed,  2 Sep 2026 01:47:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 022006B0099; Wed,  2 Sep 2026 01:47:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D1EA26B0099
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:47:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 641D31C23F5
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:47:58 +0000 (UTC)
X-FDA: 85167741036.11.2BF3045
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id C97F5C0003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:47:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ksz/ymtj";
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788328076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I/Y67EhQFpjjEgQEnOWoPesL4POG7PDn7LCUxcCtOmM=;
	b=yga96vlvJFyEAt2R3avtGXfxO/GpcefEOYCShYSn+lyTdVGZJlQguIaR2SronXw8e1moYb
	cU2/DFryTFDxA0MwZETnJZt0QuYD+U8BkeTezb5W4kf773PAFsLZWHFScXC7gQGkl9Bg0q
	j6UIwINdwvPs1XTCrn7tmZfnstCBIA4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788328076;
	b=DtHMpEnlxurPLqCdI24KEPjD6rxIIEGo5F/yl8slNlA1povGBMo1gWQA33z9+ttJqJgATg
	xWHGsvdj8ZAWYRtrlIz196bsxk5MWTxgr0/PNFkVOtA8cUWJ239LaAUhUEp6Z8AKZEoL22
	mnYDhIMJLeeyEfv6tHVXY8kRjwgzQQs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ksz/ymtj";
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F397602C4;
	Wed,  2 Sep 2026 05:47:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 002AC1F00AC4;
	Wed,  2 Sep 2026 05:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788328076;
	bh=I/Y67EhQFpjjEgQEnOWoPesL4POG7PDn7LCUxcCtOmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ksz/ymtj5L/wmFgbbD7o9+SQyVMFyN5nQR5ZsxvxeJob4b+EGZptDEPduaWnIEzyc
	 WYT72MsN0hIT3tGnKr/6CAkqNznbELWLOtwcuxAyFPup8ue3Rj5Lx2ZvL2+fijuJI+
	 7O1PfMR/ie3XYAqefRFvh5pD74qymBvFIk15w9Z9mNXW5GpeWPlUWZQQvI9+0If4EI
	 2dZYE2M1w8whcZbsmry1LawYvHlhH86KhBwCWEIVii9zW5veuaKCd39MuqaaMYb1Tu
	 igTFv7QyGRQS2rn276w9JJncAG9thvSuo72jglCO2/KYbkm0cEPLrbRkzQpM+n/XY8
	 EpAmuqmhw5qzA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 05/12] mm/damon/sysfs: remove probes number validation
Date: Tue,  1 Sep 2026 22:47:38 -0700
Message-ID: <20260902054747.99370-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902054747.99370-1-sj@kernel.org>
References: <20260902054747.99370-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3yzzg1z7iwxzt9tdez5emujz5zyo6ytn
X-Rspamd-Queue-Id: C97F5C0003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788328076-479686
X-HE-Meta: U2FsdGVkX1/5ISqWZMlZHlwOMkug4ExcS/iQS8xbco9IOMXQSr2Z1lWA/2RJwksshEMyjFJ0WVEM1lXUJjETIFoxOWALvtOMobCjE7QjbKPqG93LG1JzSdNswMZT7Q4FiGdWVUDHBW6QpiEPhL+bmEy/FXMilWcHIez0C20n1TVkglYS/+Sk2iKZMhQHWT19wK1tnBGyl8koFj/RFK5aNntTzq3ayxbCh6jz+IUoyZRj/tjMBklD0WFbW5WlbvM2R2spk8ypaRxGqID3TfWV5iZ1eE/m+IirIxiF0XIlWX3k6B0xKUQcojN+8SdxZCr22pJSzHBeNwGzRlG3c6Nn8WOwTsqak7VQ+lCw6KqgO9jUIrQlK7knNAaCYidTTZR003kIkHAkemdNXWqmr6IEpaJbm3uSJ+O4Vhf8u4YI5/4TJblV3mSv3L65bz3mAgiGz8XBLTLcgwxIe6aAD+pjs3rTsuyffJAxWZ6MJqJlw0ZMI5aPJWcmw/rkvS5tqhn5ulg2JojsAycmefxdSN70B9bX4dAzfN+oPch9XyOYx4lMmVGRzfrpa2yzfu5aopJ10uoZLQYmPyV9CuTC8PaFHGbbvD+Sdk9W2qyZmAOSHBp55PwJ5DZEc37L7HdaupApBsBr4LKjn06Pa/7XrKMo/f37RQcY4QY8vRci/DmXl/JIFXDjW3JA7DjUZPNvd2Kwu2GuaazaxfeOxy/vtb0nHsPgbRtHZ+x34Q2NEaYMycSawEAxvMCfpeyuQVyEt9jV0s7qj2TvCglUmVJQ6SzWQyRpNyb3ybgRrO8qRcrIykxF2KrtHZvvKLOJjMroS38RTSlFRqiCztFmj4YJ+j1nOEzK4uA1jsP+CwegtES36/iTSQcRI3P855T3T9sxOvU8VxtmpUoPnGz9Q1anyA8dipBbmytyY5TWeN8yL9FoNsflZ4OUbAizisARC3fC/Vy4WZzUp+t8YSDzO/k9fNP
 46gT0+0G
 /eQ3sDQGJMHFa8fuEydt/Lwt6YwSRN72dYv0rgZMU+i6h4zvSgkcAima9JZOgezRdHfGGdTabAi+MXw+mdUgCkcp1/KZvj1x7idNzwfwgD3rhMH4OJtcyc/PA5hmMLDepU4VTnZTn7tSrPUw4S3GapM+oSmGoq6V4SnUOl+o5Vj1kwmVD5Kc05eZCQbGlUPdIELvHfV2q0eCusAs2Xzy49SAiOli0D+c44cSE/ignDUmCy88=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface is disallowing >DAMON_MAX_PROBES nr_probes input,
since DAMON_MAX_PROBES is the upper limit of probes per DAMON context.
The core layer is validating the upper limit again, though.  It is
preferred to let DAMON API callers such as sysfs interface to set
parameters in flexible ways, and do parameters validation in the core
layer.  Drop the duplicated validation in the sysfs interface.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 7ec14f48d157a..b576e97cbfdb8 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1479,7 +1479,7 @@ static ssize_t nr_probes_store(struct kobject *kobj,
 
 	if (err)
 		return err;
-	if (nr < 0 || nr > DAMON_MAX_PROBES)
+	if (nr < 0)
 		return -EINVAL;
 
 	probes = container_of(kobj, struct damon_sysfs_probes, kobj);
-- 
2.47.3

