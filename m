Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8F1E10F9311
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 00:59:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E9B06B0098; Tue, 31 Mar 2026 20:59:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C1796B0099; Tue, 31 Mar 2026 20:59:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FE596B009B; Tue, 31 Mar 2026 20:59:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 217976B0098
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:59:12 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B96EF1604D6
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 00:59:11 +0000 (UTC)
X-FDA: 84608178102.06.BE23FBD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3211740011
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 00:59:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DpfeV6vm;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775005150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qZh2xaS9Yck5znRKt1VYVbeHm/1hhPVZnMV94M+ncGY=;
	b=vey/FOvXfxw2H4q6RuRK0cBw0aeWIUR6uZAvogNlGQNX0099koJgK9EoV9osxJUSN6fL7F
	7uUDjtuFGynuz7uWrHirt2uaN5pUyi1qDKNlQ6qgEXvMOxO0VqAXkd6SM3t+D21X5gBheJ
	uaQFka6WxJJqmP8ST0DvOOnsR/d8bxg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DpfeV6vm;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775005150; a=rsa-sha256;
	cv=none;
	b=OGcRiB1745rWlrsDagLXMSWx43Y4GDrDE2/J7rQZ15YPiS+MuGEHfUM6wHiHDwjvcFK+6j
	jX8dkW04tjVG11M0bkO56L306jyguKOcCHDMpQ1WFnmNSVS9zujFiuTZ1YZ1o/hZPXbuK5
	YOQGySnEeT/DrC76KrmUIXAOh26gmPA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A91F6600C4;
	Wed,  1 Apr 2026 00:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C6EC2BCB2;
	Wed,  1 Apr 2026 00:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775005149;
	bh=vlrwwARqJyOsWvsUI29VDJAa3DH8Mh38OVXxiNATEv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DpfeV6vmOJE94JC4YmwmGxhAYT13SF+q9j4PN0LkzexOkXJtKrfyIDylj1mXyh6dA
	 T+QJlPEe3K96waxCJUkqkcODvzE4Ca2gwyac79tr+DMkwCkHWFYdjDjgn/5Fz7MGW9
	 8DQEOrGJ9mGfP/gftMTI0F9169kOcNcynWBo9/J3lQnnpPdp1awpJJUs44XsdrX0OX
	 2OJNzQhsKejzkJKbJ6zJjO5cL4I4ww7HiyIOe53jMmayWT0iYUYjhH77jrr5NcnJp6
	 NTMgZI/C2YJkw4EhCQpvD9me7KMFxJvIdKvt827ncwxHqtM5PP/bxWZBsptDaGCZKn
	 vyKpHddEzwVmA==
From: SeongJae Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/1] mm/damon: support MADV_COLLAPSE via DAMOS_COLLAPSE scheme action
Date: Tue, 31 Mar 2026 17:59:07 -0700
Message-ID: <20260401005907.86002-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <4fe88a6b-2d9a-455b-9ab0-5ff153e0e88d@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3211740011
X-Stat-Signature: 1gpfuripyd179yf71sxnjgiykr38zdkm
X-Rspam-User: 
X-HE-Tag: 1775005150-744803
X-HE-Meta: U2FsdGVkX19CG1mPiJYeWIDYVm2YJKvwjHWzR4+DBadBxLLKnnkOp3ZrcpepcZFKyb6odCtxE/mdbOM5j/lPxHk8vfSvyARBllyq375QRYoXldtOPMxUROmUMb3QdJYiWWoVTOOvTDzWUx0dM3ZzfTcQOR9ki3Kmv9xencc1PQ+SeHz6g5o6igkTQTlGovEQnQnwedXpDA1KgFgF91WthaCYW8o9qcNCJbMsXhRqs5scR0W4lhaHXZOzxD6yz4e55zHM+erHxB1eEqlrLvop7mL/hEIErjAo0Kt/rqF7vLW8t9pLK8mE/FXLmjRKVm/yx/ZWmt9eQHCmkZho6JK5IWfzbqqKRSrjcrE5JPoY928b0cvY4HdsWfeF0LVZQoFnnHERmoTwCwXMZCUurggq0WTh7yi2ru7tZXuB00jK6eZwEjzKFsIsfIPjNzbwnVZxyAtbsGtu4cZNWyiAJlPrICqO+UEt0iKSXIwb5zk4l9CLAqKQcqKp93y4DhNoquyEV635Y9kbggk2Ny5d7NnKVTXBEuhzaYZbeRcGEP4yR0JFL3/5xBI1eJhj6kWOszQryIWXtMN9ruGxyofhnDECVEojvY0QUt7TBFQ1xpzoe1drEuUN2QOK2kxRx7f1heqWrTyxIs6+l7gxTkPEtYel+H3WwnfrYgaGCcGWT/Ty3GHog3aiDiS8uCAoERAju+CaVyedgIbT9sLigEa8vU7Z7DYFuJK7uu5MRz7hVjQBAf5+8PLvjJ+v0NM4vgFvu8BAa84iboRdzOsf/zFZhpgVUP6bat8Mv7o7nuP0pZgX5cMm2btKeXaEm2h/M0INR/6UrkhPJcYkCfEsyCFGMUYmD0pkGx3kWehA/tVdghTrOWSFOChYoHe4/elUNK7LQEIH7+tJ6APTp+zUAVc0GeJnsTsVSDkXmSz38ygeGXrjuTv2If9aCGTDiKgSr2pwDeJoXN8D7o34qaGm9VijRdr
 TojKduFq
 sJ5K8N43wxFUn2dx5HPLIH9uu0WyFDKzPn2lYw9f37rVRdUgB1AQzAghD2iDiqCXz6MmypSiwvo4L2XQLQNSroBKd5MCsaRzgf0ZrNRZXjZRDsGc3rb8cwfoVX3qSG3J7Pvr66Lxn8QzH7YdzkSQ9XAFeX5YS2PDDhj9Q4kp9TTcrBh+oZhOgbgG4Pnt1+aaf4l5LM2dHGsaCgM4cYeEVSEy9dFmK/XDePWnjvaJFGqWQk7tXx8JRuYdAgunp++FTo7MPKOCG8CBQMD3tEDAmqelMb4BECB9lxno3yQttcWTW8y3T5DLkotA4hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 18:15:50 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> Hi SJ,
> 
> On 3/31/2026 4:31 AM, SeongJae Park wrote:
[...]
> Thanks for the review.

Thank you for generously accepting my suggestions and answering questions, too.

> 
> I will run some more tests today. The test try to hit every row in the database,
> which may not be realistic. Usually only some parts of the table are really hot.
> I will change the test to get something closer to a normal distribution on the
> table hit.

Sounds good.  I wouldn't strongly request more detailed test results for this
patch, though.  As the idea is solid, just the simple test showing the expected
behavior is already good for me.  I'm rather bit concerned if you will go down
to a rabbit hole while doing more tests.

Nonetheless, if you want to make the commit message more complete, I have no
reason to stop you, either :)


Thanks,
SJ

[...]

