Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E08ACA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 22:30:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 607468E000D; Wed, 10 Sep 2025 18:30:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B7D28E0001; Wed, 10 Sep 2025 18:30:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CE658E000D; Wed, 10 Sep 2025 18:30:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3B4E68E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 18:30:54 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F069D11989D
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 22:30:53 +0000 (UTC)
X-FDA: 83874786786.22.AEC5970
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7FFF54000C
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 22:30:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=nXg00Kfc;
	spf=pass (imf27.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757543452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OFaJImqH+M3Tf6bY/s3EYHglCBtskmldWnNZq4tgsOk=;
	b=QmEyv/lqEhnIbnfa5jJr4843UHqPHBFAEdxO2C7l3uz0znDQ4Vm6Es1ONlwNImszt7Wxqq
	0vQ+JBp0oiFlP6D7tD+RbWSuRMZ0EUOjVxu0ODJRr+m5BkfjRB3KZjawT1wIyTTw8EmORh
	s09qGSc29O/bqsMEHUDncU49nRGRLls=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=nXg00Kfc;
	spf=pass (imf27.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757543452; a=rsa-sha256;
	cv=none;
	b=0Gzwm18imBvfdK9MBBtpg0hHC10WxjlsqzF3Txnt9XBax8U3Oh+tuwQy42Ysk+EGlfb2aC
	/TpSDrXGBGJw7DRRPKCi8AECeX7lMuA9UXS1Ycb+LkRohmJLsJ21K/B8W9GG0X/sWEYWgA
	za96Jj2JohiKcIp6FZf3FAcmVAOlUFw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1757543451;
	bh=oiTpqayvsa1bV48W5wsBWPJrjlcFWJlU9vEIbb22GyU=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=nXg00KfcTRENvRaKAyn0rIkEYr49GSLHq16/D6PS/wCQv1pm/JWK98AqlJaAjG0Ww
	 dr8PZcTkcbHKu8qIclGdFgQ/BtolHAUvbZPonvUbLw9E2tNY8JnrmLgAK6Tmojir/k
	 spS9yunY60V4RDhUs4yH/Nuvih2U3yYHZ/NpsU24=
Received: by gentwo.org (Postfix, from userid 1003)
	id 8327B4033E; Wed, 10 Sep 2025 15:30:51 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 825D14033A;
	Wed, 10 Sep 2025 15:30:51 -0700 (PDT)
Date: Wed, 10 Sep 2025 15:30:51 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
cc: Vlastimil Babka <vbabka@suse.cz>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    David Rientjes <rientjes@google.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org
Subject: Re: [PATCH v2 04/22] slab: Remove dead code in
 free_consistency_checks()
In-Reply-To: <20250910115507.1991829-5-willy@infradead.org>
Message-ID: <4109cf0b-bd09-115f-5c84-58a8b9fe19de@gentwo.org>
References: <20250910115507.1991829-1-willy@infradead.org> <20250910115507.1991829-5-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 7FFF54000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ojaqyz5inzrshww9isdf8aiidowxu88f
X-HE-Tag: 1757543452-841378
X-HE-Meta: U2FsdGVkX18eY1Wl+67XR4egkvHPolefWWK2KudCWV5rp5bDiZbjHFp+Qp/+lwgCP6zJ9CkFw3eeJemnLTZa35mgm/o8tZuWDh4VNctudS9lLhYHY1uw/6L21AZcRRUKIBYA+fd+comKL/xrB/uDh0jbxn2xtRcUsalTC6iLhB2/k+qoY3RhQlLDIeupoUZMKxHvMAidzWQaQMDBQK2UQJ+7GKy6BDzfRqYNvdfrjfbbXWDmHMim5lDzthi+ToS0cs8jVRYToW2ziPXya89azk/5vHiRvlz3XjpiFpXY6vbWmu7wdFsQcR3khF0ea7eKq34dbcC0yVMR+NT/towpbMNJWcnLXWglHXkrwh/CGfqLtVwyjd9f7uZo2ZkG43lGAaVYtO4RzVLaZYxm+frN9PdC7FVilr12ZzDTacyGoN+wdrCQ0MYPZ/mMo2o4Ny8I/RsBaUL44JVQbMM0nSbyMfOB4kx9bS7nDTlViQ56jooG0i1K62slrS6F0E6ztCWm7Ga9+P4MDl2KNeo8x79vQ7+ipalpKwhpue9PxFiYBI085ZR6nKW3ZSM9ga4QAJU08Bn/g1TaU+ygSs9RWPnLeFGgGkqEv+SsTupeSe43eifZR0sOolfiU4BVwMWIS7mRQHNcxyJ8SeWBDftosqGTbD/4rb+KDF/st+epPpy+8/yQE8umu11uPS1edvvPKF5g1XCJM0/YYhlCQ180b90bFvPIzrZCqHu1ICfaGCiofvjBbbpzaxAW+50eQE4kRyg3pHjqu2DAzUNNE7JktiflNgXIAofKRt4L++KvVt9uBaDerSuAa8S3ofA4CJYQM7AWF0ZI4RhwTXctm2jZBgq/HW+e+91WuqCis83qVQAIWg2VIqHy1x0oTq1iqvWTRPel2nWh5VBiRBVUl4VieXAPdwkyWfggmCZlOUZhjRl315h3+uBZR3PteHN29UR5FXkWDIetMW8qTmCVj6Vavxr
 QOw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Sep 2025, Matthew Wilcox (Oracle) wrote:

> We already know that slab is a valid slab as that's checked by the
> caller.  In the future, we won't be able to get to a slab pointer
> from a non-slab page.

No we dont. This is another case where there is a metadata mismatch and
where we already know that something is wrong.

s should be equal to slab->slab_cache and it is not.

Therefore we should diagnose if this is an actual slab before
doing further diagnostics.

