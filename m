Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D736CD4F47
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 17:52:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB22C6B0005; Sun, 17 May 2026 13:52:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3BF66B0088; Sun, 17 May 2026 13:52:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 929F66B008C; Sun, 17 May 2026 13:52:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7D6786B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 13:52:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2C26DA06BC
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:52:25 +0000 (UTC)
X-FDA: 84777656250.08.EDDC016
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 69AF11A0007
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:52:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LIXT3IN1;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779040343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pRkMFbkzNDXb/GY9e19+BRHIUEIbEEADgqDGSxAouds=;
	b=eTKUyQTcxOgFD6zq4PNbBCduU10pnmE37InQWymyiMl5Fl08Mz5M7kCuBPRyb5yoX6x2Uk
	62tghIEohk4QYoIEvo92gWylWeZ76O17VSZJvjy61BO0MMrWilvY8wXCwwdAVnRwLyPtmQ
	oQNSeFvlGJnaYpKErx/Iea6xgah/K3I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LIXT3IN1;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779040343; a=rsa-sha256;
	cv=none;
	b=GXzM+t6+crs5QJi6jbOUmCIvVBdX3q2gVvf9UNkmkT/k8dNRbw9192q+v7vcVqEGdWJxNi
	q1DMAwNX1sTQ+GeHjzRi8kLggTprpVJvnK2UdQeg4oG9BxXB5cQQLZtO+XK/8CHaxjjGFe
	LdXYbDhPDi5LXO6jr/3auTHaVmcLKoc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7362C405F6;
	Sun, 17 May 2026 17:52:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA28C2BCB0;
	Sun, 17 May 2026 17:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779040342;
	bh=AcuclMGPrrOW6Za7tUM4Up1CwRxD1Fm9/Uh9lY+5/3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LIXT3IN1LvSWc2kCiJwSKg5zgzy4OE9mn+0aPXI/kO25/LVsh3U+BzDgHDAsRraw+
	 reJ9tgcy0bOkepViNnGLjONy6ujSISAp66gT1J3b/K7laoB4jcLBM1PSS2alfhIDKY
	 89gT2bGzQir9LPwwFXktzT32STfi0cRgQ8u9payWBQNqe3IAZcxu38QZDJexaZdeRs
	 a3/e5F1Ixbbwf2bT/NUT/mfVIwZW7U5GVTwfltTpzbUPM2UdCig0teGjNRpkgThX/A
	 7xPPQJYYG1ZYK6xiVVpDiIL0knUom1eajpcUuQ/Yu0FkZTecvxzQF5plMZOKL1mPd+
	 DapYS2s72ut0w==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "# 6 . 2 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v2] mm/damon/sysfs-schemes: delete tried region in regions_rmdirs()
Date: Sun, 17 May 2026 10:52:17 -0700
Message-ID: <20260517175218.2272-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260517172624.888-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 55nn38tk8d7xzt5utogo3hkddmo9keky
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 69AF11A0007
X-Rspam-User: 
X-HE-Tag: 1779040343-590067
X-HE-Meta: U2FsdGVkX1+YoxLk56NLWb5HItjghUKE1AENQ55NW9aI+c8JaM7x8/ai0ovD6UESgCXFQk0Nel3UmsxwZ0A3wOUE+dCme7inp0Pd6Tv+qph1wX3ZuGlSiKcev2WuifE9NLq1s1e7441V3IedcawkLvlyB00UNCuoOtkqBGwLt6IbDbVRcWIw68HOaRUEHy9Sz6e4CZVFqdHQL94mLKqyqG/qjpagdsiGaVPXc5hM2qhOJSlOOCJQf8uThsA2OpASa7h63HEg3quWlrnZQdQMxxnY4GfXht/TVpBQKGgWPZYxDq3ctcLHMuMTSHIEvszvSM3GOT8IWgN3UulFiKWI5UIFt28KLNTdUdmsDnx6K47nXAtKUBWyGqhe/csUNkBAT78Rc8SenVvuAcjECtUKzH3sw8sMGkZWOCSJDKUdh2FBoP9J6DyYkjU6/BOIPdeywF9xiIQFZJIe4UGXcHZwZNqryURNJwojMbJ1hHW2MzNtZVp2PUzqpdUKNgDxwoqZ+nRqz1Xu1nOKrht2ZUzc2++aU6E+W2tG/CR1SnHi0WxUzcHGVyverpje78NWU9hpWakVRzwc/ah183SQ1XPCPRMKpdBImwKcU+NrpUOrLKYlNsxoEjlfkOiUGfcGlQxZjASuGEBGL5vzpYcR+u3sZNIS3IZxsyex2o1gRca2n2Z+FTcwPoOhZWjTmFvecuMkkyHa8unVIiU+WfNr/MIq8F79LAallWA/JkhJ5el4697oAE8pUb4rqnSKl6n5Wa9W7pT7aNwsws0ZGEgJJSY7tCXYmCyLKsT89LKESxuvdwERCzGn+acfFFo7oOjMNX3Niq9ZhWNNdjxfF4woxxqfRwvkzydTnYw7QvXT0wMwJupeAlUGlbgpVcurweBZ0Aa4wMkE/tO10kKyJvv8IJFMMaMdxTeuuvTz+eTTt7FnKTZn/98WLdlgKnhyA4BmtRUCEU2w1GIhKqbH0MmMF3n
 lUoPB0Qg
 R2eFYTWI1p8FqBFyZQCP/49iWm2OgGmZkzTwsL3UfTWhLWaKStrZaJOnP3ekLbb361RxYaFSFg1UR0AaEW76sgZJjYJIgd4nyEpVxCG6S1TgPt4AOd2qBxKYCfLf3TK/7yYNP70yfJRjM/LxkC4fp/W/4oMaQvEfEnWeU374ZVAHk2oyX3liZIlIkHOiIhDxyQJUs865CEgYlEndR9pwnGJG2xYW0E7mCXe9v65v3BzV8VGldEmaaX+6gZKFKPnKgPTHmNJmI5yQ/VqQQSFcqXFz41eaIMt+R9JqljuI4n9Xtw5ZBaBLpHK5OrM65hAy++bh0/APqw8z7gj8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 17 May 2026 10:26:21 -0700 SeongJae Park <sj@kernel.org> wrote:

> DAMON sysfs maintains the DAMOS tried region directory objects via a
> linked list.  When the user requests refresh of the directories, DAMON
> sysfs removes all the region directories first, and then generate
> updated regions directory on the empty space.  The removal function
> (damon_sysfs_scheme_regions_rm_dirs()) only puts the kobj objects.
> Deletion of the container region object from the linked list is done
> inside the kobj release callback function.
> 
> If somehow the callback invocation is delayed, the list will contain
> regions list that gonna be freed.  If the updated region directories
> creation is started in this situation, the list can be corrupted and
> use-after-free can happen.
> 
> Because the kobj objects are managed by only DAMON sysfs, the issue
> cannot happen in normal situation.  But, such delays can be made on
> kernels that built with CONFIG_DEBUG_KOBJECT_RELEASE.  On the kernel,
> the issue can indeed be reproduced like below.
> 
>     # damo start --damos_action stat
>     # cd /sys/kernel/mm/damon/admin/kdamonds/0/
>     # for i in {1..10}; do echo update_schemes_tried_regions > state; done
>     # dmesg | grep underflow
>     [   89.296152] refcount_t: underflow; use-after-free.
> 
> Fix the issue by removing the region object from the list when
> decrementing the reference count.
> 
> Also update damos_sysfs_populate_region_dir() to add the region object
> to the list only after the kobject_init_and_add() is success, so that
> fail of kobject_init_and_add() is not leaving the deallocated object on
> the list.
> 
> The issue was discovered [1] by Sashiko.
> 
> [1] https://lore.kernel.org/20260513011920.119183-1-sj@kernel.org

Sashiko failed reviewing [1] this, due to the not-yet-updsated mm-new tree
baseline problem [2].  I will rebase this to mm-stable and repost.

[1] https://sashiko.dev/#/patchset/20260517172624.888-1-sj%40kernel.org
[2] https://lore.kernel.org/20260514205555.51653-1-sj@kernel.org/


Thanks,
SJ

[...]

