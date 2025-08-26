Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F08ABCA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 14:36:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4771A8E00F0; Tue, 26 Aug 2025 10:36:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 427FB8E00EC; Tue, 26 Aug 2025 10:36:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33DB08E00F0; Tue, 26 Aug 2025 10:36:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C3888E00EC
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 10:36:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C20121D9F3C
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:36:27 +0000 (UTC)
X-FDA: 83819159214.01.1C5CCA3
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3050EC0013
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:36:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ayhHbx5X;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756218986; a=rsa-sha256;
	cv=none;
	b=GmDfAtu/VfBUgZRQ9G20mzUxwP48SO8EjNkaS+f5HkIRgAQGuXlDR5SumWVCmiYOP/zZhv
	C7MW9dgjeHk/utfyhlj+WcC0cY4bvAa1uVuKapKwfp5uar9ATkH0SuTTNCbox3DaZxfG6i
	mYpJK5E3VXcC2mWIO9C+2y3bBHFV1Ls=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ayhHbx5X;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756218986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xdhaanYvjiF8STVB0irsdvgCmdV8Djd5Nsw+zQr24j0=;
	b=aRPpsg2tAALT8a2j353bG8aOvVmUB3bkJga+/XMH0VYN4jI7vaJgYGh2gR+Rp/NtLtEzIj
	PhRflxnQTokupUpjgZpyrDgJbQ0onAafa/M9SsT8NpSpAx9D60ezGqmkLujX0mfxxDC7pr
	DWgf2JE35cqSmDx8By+G3ZyBhS13Ksg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 57C115C4D64;
	Tue, 26 Aug 2025 14:36:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C286FC4CEF1;
	Tue, 26 Aug 2025 14:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756218983;
	bh=cm3c4GhML4E6RLlw/VFFFI6QieoD1VhZ+qpko2GXjyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ayhHbx5XdlTVbBQ83nz6wO1nSS9vqlStNZOOG4jTgJgJDS3VtRKhdkP7ZLrRpWPaT
	 JB5ee9SGB2pMIarQFFwO7fifRY1djZycI6TrkVkSDCwqxbkH0Q7NuBBLYnWdnWCT0a
	 fW8fMzjMky/bJjZLQM9Ov/3pXgAlzNv6Q/9NmqTKgdY0dk+8RFJx6s1KVfEXqATzd+
	 QJgN6H7qIlZmqy2y5YspLoUP6ZQiJFR9DMjyA7hlZfUS83FUbZWCsYKIfY767lQfzT
	 RmjLh2JzIjKVAfaGeZbzRaW8s7y5iagKdA7GkXnZm7Kq6rpWS2VOBUTwIeAIlmHtUN
	 q9O3WJBQauSgA==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [RFC PATCH 0/2] mm/damon: void divide-by-zero in DAMON module's parameters application
Date: Tue, 26 Aug 2025 07:36:22 -0700
Message-Id: <20250826143622.54331-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250826033653.1208227-1-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 3050EC0013
X-Stat-Signature: h3yyt1c9a7ux3x8yujwdfyd1wx5hwntw
X-HE-Tag: 1756218986-919272
X-HE-Meta: U2FsdGVkX19aIL4eeQvyFftppm0iWz05xgBvzDlD5V6o4EIknpifZ/UJQ0FVKmvyuldEzGBgv9yVTJRsyLQ6qvpAuLOVM9hWyjCSiYCE60h0o2AOMoRCtper17L8KhZqIhW/LvCSEAInvyUJ8f8Teo7MtJBSBxDXutKujJIz+9qiLsJyZUUukhgW9PpP4XtDhFepDZ2mFbODyTsJeI7bixcgUXlTKhxA4PjmEf+r8IH4ASyjWf7gt/4WSPREtu26wzEqWYcSflr5MqOBbIrssrHZF6x8DTsriZUxs1sMbe1j64y8Zt7QWOtDBfXgBGJbfejokaNjgzCsrD47c0ixpa1AcMegXrqGs32JgbiETVtxd9WoyD/P4ldOF6jTb+lBbh/WYxHTfEZyPrPES4ssD0yiY0hwOXU5bZAuqYPNIdpTFvC4pMHF0deeoSE9kIJ+oHMR7ZhPMncu/g2UG6eRvHqK4rF+exp0HZljyWn/E1bcrF2SXEtGkLK21E/tGaQ3z8y7/nJzLdltqAZuX5NMGUDdJ9sj0Ma/K9vZsCQkvjm8vA/D7xlb5tJQmjXCHm2ofPwh+2BQU5Rwf0qDQ6ibs3Gq0sbhrsl4BoJ23vVL2rRJCrYtELUrDcxz39UyJKEjjCGjYzfoB2Wp+Vs8QKxbhioXG6FFgeCfPvS6PETNdXecjczScpoRwCZtXnU0GyxwBp3pv/t0GqTIYrYNw2vh8yVQw4MD8yeWe6BJEvVul2SL9g+pYCGOYkbOWAJeqGyzWVheY5CoA/tLUIg5AGGX471eBE5tloM6xurIRWrId3PrgWCotevTtKfI8qjU+mUGT5RP7EJuP4hkC3h4hPZT4ouaO5PwizvCNkeVuN8MeS5rmQ5AsPnKPrvmPzS7qOVuObI3wzW8XTFdItYzjAJKxI+e7MMCyhSIBEb2oBBY16MY4TQE7dVUBw9Cz0hfaFoLsee0pq2MHnnTJnHHcYb
 UgcEx52L
 JBetcQag+Ji7AdyG7XlMVYFy74SkYEwQfU/pmKherikUFOQVeTlxBXB49/lunQ4c21UdIC7tueXRgbVKDEkCbfESTdGVCpsC0HlnUNMJrrwXgHKUmxzqsbJcs5nRrnQ34LNoD5Zgt6FKiZ5g3DWVys4tOwN+EzTAGHW4LqrULFYa4+EJuYJEls9rBDWMNnhsI4U4aM3gdQLgH56PTFjSacP6wlbfRa0ysnJS9RWE7ke/ssFZ/gxZkhA6o6ViYJqmxh9cjQetcVaG2xIO/0TFV3bUmyA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 26 Aug 2025 11:36:51 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> DAMON's RECLAIM or LRU_SORT modules perform no validation on
> user-configured parameters during application, which may lead
> to division-by-zero errors.
> 
> Avoid the divide-by-zero by adding validation checks when DAMON
> modules attempt to apply the parameters.

Thank you for finding and fixing these problems, Quanmin!  All looks good,
though I think it would be better to add 'Cc: stable@' tags to each patch.


Thanks,
SJ

[...]

