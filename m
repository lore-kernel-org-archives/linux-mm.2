Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 849A2C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 14:37:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 952416B00DA; Wed,  2 Sep 2026 10:37:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 929A36B00DB; Wed,  2 Sep 2026 10:37:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83FA46B00DC; Wed,  2 Sep 2026 10:37:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B3906B00DA
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:37:16 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 086051C0752
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:37:16 +0000 (UTC)
X-FDA: 85169074872.10.A791B99
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5F87A18000E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:37:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gcX7IbD1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788359834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uJ8oZbnT/S4xxSU2BGbADIIkq11+Ga6+O5vtB95nhK0=;
	b=jkOY17a2Ove5QBihVJ2+xcM3IF3910kr94mS8YTfDv7VflfhJMZh1lsTB0FXtscc+h2TUR
	qSU2nyI3h1Gnp5Zq1ChQqkeputTeZZM8Idt+D/PBHSfGKEVRfrPYXZgvPMG/L1qNJuTMTU
	mnJFzGVkvN6pckNh76Gg6JQMa7Rc228=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788359834;
	b=nDdkn+Gsgu1SLpq4LKNNJHQ/zS0HfxE4V3QnCDHliThvzx3bNSJUtPaNIhfpbTxrZAVKG/
	Tq8u/TMMueSJay4CLbf8AbPxkOAdSlEaiKJpMt7efEoU6bpYPCqSlNDCSNtkPpaaHOR8E9
	r/qiM2u3eXqnIAU7ffmUxMNkLBImI0M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gcX7IbD1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BF700600C8;
	Wed,  2 Sep 2026 14:37:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DC21F000E9;
	Wed,  2 Sep 2026 14:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788359833;
	bh=uJ8oZbnT/S4xxSU2BGbADIIkq11+Ga6+O5vtB95nhK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gcX7IbD1yaF6KhJx1sjAKj+kDIfGPBq8StoP/xFceP1LI0AXebsGAYHR3rS8EMCQl
	 O7H9AQUHoilFNp6tkm2Vj0qTcvjTQcqiRZ9QnEU4+OvqSbShgm8fzZypPCg0EbhOB0
	 a/W9WbU1Vaf8Qx+Kon+bROdWBDiNZwX5q4FbwG4JEFFW0mCgsZrvle/x87XLIgdMen
	 Qo0G1Ns1TNxrnKw33LpbJLHD6C1zjHLB6JTEbr8IfWuQtuLImT/y/8QIjwc7eTfaDS
	 l5OU8ziIk2jRyz9DZgoge4GL7gSbofQG7yVFBQOa/lnZENIfJr399XgAp+TDk8kY86
	 hG3DBfzCYle1g==
From: SJ Park <sj@kernel.org>
To: Kunwu Chan <kunwu.chan@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 05/12] mm/damon/sysfs: remove probes number validation
Date: Wed,  2 Sep 2026 07:37:06 -0700
Message-ID: <20260902143706.88115-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902140714.4023700-1-kunwu.chan@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5F87A18000E
X-Stat-Signature: xypabznjmep58mkegxqxyith5nybxuxq
X-Rspam-User: 
X-HE-Tag: 1788359834-580794
X-HE-Meta: U2FsdGVkX1+ZWbwCOpwNXMQ5wd07p3hZvYmYCdFLEGTS7E7stfEukciC7NkiAisUbVHUiiflmFoBMtqtu0VRQfSaopQJDAAM6bnvL9lqQaNVliD1+8O3BBsgFBEQNGfxUsxi8mfSnoqEs/UuVW1yZkA80MpO/Bqwami0WPBOZgOGPFW2w6YNo1iMwq2U6dbK6Wtv/UE5mK/xfOUK+PWkdR5yP+NaiVs7MH/ZFKAyyl/xH+jfwxDjfPNrK0UP0kzUdVCqvu9fThTvshs0lw+1WUN/BFTPLkbSmyOGaisB/9vmodbDmaHol0VqYiJs1Ipf6cjzk+o4VpvDDwNsm6HFw3ybOJRKawdluVLUVcR56dOta+m2GQFN6e23Crvv+gdrhP6q8wWHD7CfmHbjU662ff7kJBUqzA4CDOtfU/g6fLhHhLGI+RGrNnPd65fGCJa/K26hWmK9u6CUjHqkIw3U/c1uhCDsBNL5uhqPd6tJJ88PDc9ZmCTPZ+bBqjrTCvXva0R7qhlf8zbU+ujF/pzqqiuaa3oGcYV0TD0vCGZef+3iqRQ4WutJKtffQYwhO8VqcgI+HfTMG6tzHQZavIY+y/gGm5NOko7IHRjOPqhos5JNB2h1ptJtz9YgjsDLZJNP3Qehq1pvBeJZCukzLta5BC9qWPui8taGQJ8AN9sa1aVSaSoO0XerW7cqqwqLbx/ekZ7IWbqE6+5TtLDB2v/C4iXeSlfSv8SpRLIdAXIS/IJoHSToIGWHNcHX66kdZfGLKxg02+tev9tIZ2b8bl0A5IjiqQ9mSZ1FyXwB5D8JNt/Chr2EQmImJYZjuPt9VcSuRWxyeES7auVFQ/bww1UFMgCzwc9e/NSdQuIE9si5FS+jFrua/ethyT8mq4Mh70/zTqCkqTHHwiw0LGJrybHVFfpPU0YlCcYO7pIT3Q+/yzl8iNhC28+1XKo9tVSc3WlZlDrsKL7oisAsoEDim8a
 KAFHppRZ
 I0GHHsBb3yvIN2aXKRyw5rvaPFfELSrKF2vl0YObeaZp41zRi+6Y8m5KBNQY+bUy/trt+HKSwr9P4CoCXiBigtuCZAsnmo/h8bjmoj6yDms0kQIVleN+EBGGApieXNBuetyvgnefy42VmW0sbDnc2zxNyTxd8fFyn5kpHgXeSNP4qCpZHLLXF8ot4ta2oNH7R087TdSkKpp9iPVR2YtHKPo20YQw5LyyyPNyaEa8Kf39bAQNkIGXZ8QKPn4nLBhAHw4DPrej5b7gkByq3X5VZL+ek3B6xesfljg/xn1A2uLLkYi6NUAvPx5OvSjHD4QodjOgVFM9L7UXZTfI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  2 Sep 2026 22:07:13 +0800 Kunwu Chan <kunwu.chan@gmail.com> wrote:

> On Tue,  1 Sep 2026 22:47:38 -0700 SJ Park <sj@kernel.org> wrote:
[...]
> I was wondering whether DAMON_MAX_PROBES is purely a core invariant
> or also an interface constraint.

Thank you for reviewing my patch and raising this question!

> 
> With this change, sysfs allows nr_probes larger than
> DAMON_MAX_PROBES and damon_sysfs_probes_add_dirs() will start creating
> probe objects before the configuration is later rejected by
> damon_valid_probe_params().
> 
> Since nr_probes directly controls the number of sysfs objects created,
> do we still want to keep an early check here?
> 
> I agree that the core validation is required for non-sysfs callers,
> but I am not sure whether this particular limit should be duplicated
> at the sysfs layer.

I agree the user experience may be not that good.

In my humble opinion, however, keeping code simplicity is more important than
the user experience here.  After all, DAMON_SYSFS is recommended to be used by
another high level tools like DAMON user-space tool (damo) rather than human
fingers.  The user-space tools like damo can do the early check.

Please feel free to let me know if you have any other opinions or questions.


Thanks,
SJ

[...]

