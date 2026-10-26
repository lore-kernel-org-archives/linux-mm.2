Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28414606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 22:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b6rCgVOf
Received: by kanga.kvack.org (Postfix)
	id EA7CE6B05B2; Mon, 26 Oct 2026 18:56:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E30146B05B3; Mon, 26 Oct 2026 18:56:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D46476B05B4; Mon, 26 Oct 2026 18:56:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA6C46B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:56:11 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2670F1A0860
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:56:11 +0000 (UTC)
X-FDA: 85366287342.15.6A8B5D4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 991DDA0003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:56:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b6rCgVOf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793055369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OOBTBPuaXKLXV+zGmde3V82GAJQ+nF6xNw5pBV0Kj8E=;
	b=SsiHIvEMJzhyaiq8GH5QXk01aHbFYBJn+DOrDwPJhK4Fja+7TteOe9ZUs3z2OgXTkPLv7h
	qSBEzinoLKbyjNBM8TJQBprP4bX0lrBE/+BVoM9EpsY6kfhk121U8Q61tukU125Bz4EDLX
	ZlUEdjN/D+bYWb8XMzGyupSlKBdqLzI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b6rCgVOf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793055369;
	b=j4rgGPYavPlvuMd+HZqBuwPimlj2BUeBnjflj4Xq0eGlw1jpE4SZYZlFPKXaOuawnfKf3T
	Zex4eN+vT1XlZSUe/bwlGqIY8zlGbUC/pF/9nrvq+D1XQOkGTLoUWYP2L0w82F1AWKhhyc
	4WwqOBoe1V25tqa09ig8zNUknfi5oMk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1557D60229;
	Mon, 26 Oct 2026 22:56:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22EC1F031E0;
	Mon, 26 Oct 2026 22:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793055368;
	bh=OOBTBPuaXKLXV+zGmde3V82GAJQ+nF6xNw5pBV0Kj8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b6rCgVOfmjpEZtaPMJP1qXkQViIMdl/xQ+hQBoZO0h0mNS19cTVL4/zQ6iczJi0xi
	 /TyJLGsrPQplpPZg1vIssfjzcKqMVRt8r+0nrWtIFWTxNjZ1q29oXFotq1m2VhbUQG
	 GPEMg7bquk6g1GB7jCqBsKMBvRZ0nLTKd6AkdA+RaTdIdWhJnOZE5Wd5aymasZrxKa
	 Pe9otMmRlpzgg/tgfffm9BXAXJiKpGMsRjuGka2V5SkdYbSI3tGQnaViOg17PQvyqf
	 e02ufiFNikP6NQPkKDz6a+JS7nDVnXpIXJQilQTajzJru6gg1wwwqmguc7xqon4rHJ
	 hOhmTTB4cZTSg==
From: Sasha Levin <sashal@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [RFC PATCH 7.2.y v2] mm/damon/core: error damos_commit_quota_goal() for zero target_value
Date: Mon, 26 Oct 2026 18:55:56 -0400
Message-ID: <2026-10-26-1-daily-reply-0005-damon-zero-target-value-7-2@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261026133645.119485-1-sj@kernel.org>
References: <20261026133645.119485-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 991DDA0003
X-Rspam-User: 
X-Stat-Signature: dkmyi14uu6cjg6gki7nge3qjwh1n5zrs
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793055369-655330
X-HE-Meta: U2FsdGVkX1/56O9TGac17GISwt+6DTDQQdYSObwGVsa4bvz/3CYhATnqztLoHFEXfNrDE9Hq3gG7ou0ONUj9Hu7OdL2JEH4i/DGw+/sHrGgnv5ydDbAPH75RE+PAWTj3Ut/VpUuMlbL+SHXv8yw22+lzPrpl9H/YgmXBm3WY/2Ied/IO8VPey1FSuaxyWC5k8bbRZIz2q/B4TuwnFNpY5vFLwPm9YewMRSDp7EeAMWD009JMsBN7mNHWtt/1pMbEXGYGsiStaOuWkip+bPoRyO080KCF3TiVRCp5la4sc0X4wIzFDCTjHfUn0MeSJ9Pjl1ogEAVdRRUqjP6xhixeueh0MhZ0mu/nav+q8Me78QCdRbDaMSI05P4dScX2scuZUiiry+IZGbQ7aNc3Cox4KQ5bLPgmIpvO4h4Tqc6MbQ7RSjB0sJ3BoAc71roaaDuC3ojDLyr7IQ5B0W+hzgEr7m+OFBM4IvPLbsKdA8uwoDNHgmdAEQYiypJtPFAqwkbD099wNuXo9LKAYAGm1PDedOeHFIbIZTJld72iJjL9SIU6hv5/j9u07GNYMm24ddei6Gkd0ZjBiOgZmoS5aJVaqgYXAIpqswSAsq4z7a+sE8y4r/cESjWrpUoInUD0b3PAd/VM0xSiIFun1k/TtPERIumzVk4Pr2behAuDyUbysKurnAbBeSd9eO+8RwC6wSG3l7EWVqR7KnTP4e8vrhM/VbzhYoio81UGxVnYWm8PgaaHT8ScSEFo7ufmCbwh7merQnKR+Tm9VoInrlkRpIQ3e2Z4K9QPRjRPDjdk6yVU2D2Y47fMqvTZc/MVQxHtPKx+y17UeLfDxHas7khSH4keUFYoqAGdtDZi+n7oqdLemOStuEzaqIxZ8ZXKCoyJ73D72WDwAbaKNqnfFS7lzINj2XshoZBtjJ5ZrzyhI49nQxk4tP4iS6ngJOIoVC0zKP9H7k53otMZdJ2c4yMaLPi
 9cvt3lzv
 lD/MRzz0wEqt3bJXR24HYSmpWiZEkwKhmGeA5+zt4AIBM7k5FGHlB8H7EYTlGLaEwGqSPg4d/MApgROL7N6eu1LVwaaCWDNhcAgwzUmUZcOhTKwnB4wnUl/wdynnH9uplYxQ2fihECtF12SAH1Djp3vGAD4Ylv9aqcvqM0xJtznoiwz5mhDbssLrfQlobjQQBkiIdvDZfb2+2G59QSMnVKdqljatuf9nMDb/0Ovz3qN7tuTa97oea2cEKY/OpOXdUlry9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Also, the upstream commit on this stable kernel can fix the issue for
> parameters commit paths but DAMON start path.  That's because DAMON
> start path does not invoke damon_commit_quota_goals().  To fix the path
> with minimum change, add a new small validation of quota goal target
> value before damon_start() call.

Queued for 7.2, thanks.

-- 
Thanks,
Sasha

