Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9818DCD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 06:10:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74D216B0005; Wed, 17 Jun 2026 02:10:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FDD06B0088; Wed, 17 Jun 2026 02:10:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6156A6B008A; Wed, 17 Jun 2026 02:10:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 355866B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 02:10:19 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AEE13A0331
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 06:10:18 +0000 (UTC)
X-FDA: 84888379716.16.9FCCB52
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1E4AC20002
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 06:10:15 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf31.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781676616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tQ1F140yU92zZOzRpzYu4UDTbBRUfAVELBtgf1k0MGM=;
	b=T82eAvpQZtHDbd5+Z6uLbZbq0IIwK8d7JITqeF2mjmNCNy0iZOjmdEqvsklNrvIM0TZNsD
	DA3zq+/XKMWpQEvHPtDEGZc3/o2iU9OV+UDYuaZeQnZMEuKIJyjFyhueO6DYEOAIcU6I/z
	JsTpUXmkJqLAlSHgqgmes49Ymux7+/E=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf31.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781676616;
	b=0k+XGfeajt/VTQaB72jcFzDm+fkcz5oRG8W/XfjDki5wIhvWcobH760/T5rEotShKltKid
	imrcak9GDYYekxxNNej7hikNIpyWEJE8S97oxDYSwnDrSg23hRfB78u4aLhaTnSaqEkq7A
	6YpFsoFXmkGDWZli3YzujAg/bI1Jd64=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 17 Jun 2026 15:10:13 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Wed, 17 Jun 2026 15:10:13 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, kasong@tencent.com,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
	baohua@kernel.org, yosry@kernel.org, gunho.lee@lge.com,
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com,
	baver.bae@lge.com, matia.kim@lge.com
Subject: Re: [PATCH v8 3/4] mm: memcontrol: add interface for swap tier
 selection
Message-ID: <ajI6RaSrZYXOKgV9@yjaykim-PowerEdge-T330>
References: <20260617053447.2831896-1-youngjun.park@lge.com>
 <20260617053447.2831896-4-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617053447.2831896-4-youngjun.park@lge.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1E4AC20002
X-Stat-Signature: jt59ui1mjowm8nhn979xxz8o1iewrfpw
X-Rspam-User: 
X-HE-Tag: 1781676615-875574
X-HE-Meta: U2FsdGVkX19pBPx249bbH3gewXV5zFFP2l6op9iMS2pY5HWojqMzN6vvKRGOW9kXQRdx1xDWZGCG8oD9vH4ntmm+GSkpa5B1ko6o0u5pm4daIzKCMg20h7WvWs34OOoQKcRBWJCia24Pg1cWiZCMCFWvZudfYPGzw+6hBaNzQX12jzJOAGfpoX5pd+piuXhnzYMeBe6pO2pATn8Ku5orHk56jRRViuD0aDI/hCdpOsNBnqC/c5Cov02mxaqrn5JRB9kKiyrC8L7gTmLZHh+INjk4rxcxxrBA5JJIgsG5jlQipyETMsucxfqP8ozZeOBWcVvisZJjwoioFgECoOAoENoTDrlrVOPVeleG3RAGEQH9BQVrx2xQ9Dy6/DjjUASvdAE0h46zQElZc3UZALhhR6uNncbqjVAiTjNSmhszaIETpRVwV21IiD5nwLTMalvBbdpI4Xa4D659n6ryi2vYwiT9czm1K8m/SvDxerCiX6IVWwgywOHULWxFb7u1mXlnjOxe1ANALMy8sdqi59OlwBczFhV6joTriRKPPlLDpTt43M2idUnujgUpbhqN668zkVPsaqhNlDjK6XTQhryVHR01XG6jF5zDRe8e4074ixnAhxhoVVDDwovgL9kAvsBLDPa1zUaCtBsbGnVebYqLeKygMANCbzG0z4x79tjadf9pZQ2gTs6TDepmE8swFwWwYtRp8VNdRMn9DCCnNGUtq/32pLyrXAmmtueJYmNfpcG1K47Iy9REbby8VNPTpBvidXyZ7Xtb1DfHUJEU9Jl+tWQBxbUGxyajf9yBTY1PIryJhpvDtteT/ga4ZFky6dZ2EjjQ/DiRye92K3rnYc2eU++/KFp5KpyA4Z7qv+MwzgER5d+yu9syzsePSW1aETVHE82Reeoive3Z6hm2JHvAGBeittYMGAC209wB7jhA+cAbcovDrNVjTVXbNH0HoeLmkOQyuNZKCExp1v4WHtj
 7ibTdXkw
 iVZmcrUClr7yjWd0HOcpIyUkEuzXsLavC5ONI+tvCwDope1de9WNldkAbLmBEyYj1jck9fS6QtyVQ3PTTdOnhT79LZJmHbuqVXJ0m1NPafldt1DOAaow55ZF6VSGGI1rx01L8ei/z6xcRHJJz2+8mdCaHUKtvBldbMWmSRzeFnv4IqH6SoI4wW6H9dq3DTU8oOjdDuSCKv7KZuGW1xP721k4ZfyDEfIUiOUuKwS1ZgMwNnOfYb6pqCs3GCK6Y3FRn42TEf2TSzsaZnyryzxxgpM5mPLgglPAr0KZB55btQyqKK7yWU2o5i9dA7t6FsXsWW4zt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sahiko review

https://sashiko.dev/#/message/20260617053447.2831896-4-youngjun.park%40lge.com

I think this might be an overconcern. In normal
situations, cgroup delegation is strictly under the administrator's control.

Furthermore, if a user already has a delegated root, there are numerous
other ways they could potentially cause a DoS attack. Therefore, I believe
this doesn't need to be modified.

