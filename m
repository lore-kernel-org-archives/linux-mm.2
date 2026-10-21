Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8ECB606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 01:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hr1WboyO
Received: by kanga.kvack.org (Postfix)
	id 03AD66B018F; Tue, 20 Oct 2026 21:02:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2DF16B0592; Tue, 20 Oct 2026 21:02:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6C046B0594; Tue, 20 Oct 2026 21:02:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C7B126B018F
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 21:02:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5B01B140367
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 01:02:34 +0000 (UTC)
X-FDA: 85344833028.23.B3F5302
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id C4E3320005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 01:02:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hr1WboyO;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792544552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dxapBMnN2fMQ/g84o5Y9DlnPN8flfC6uQghMcWIgUyI=;
	b=1mBi+EnCizOHcaXTJifBM8NzrXoaLA3OGKF4UFdda12NLwFkgfZgJMj26yM42E2PwvxTgZ
	WcVNC/Pz4kwPXH0zBIR/o5ZlFu3LJZKaYsNZETIFUWH3yb6YY/yYQ571h7FKddgmTfs5LA
	RHwKD1t2CWoVbIxC9LXqN1Pwql+/Cko=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792544552;
	b=yY9ygcOzniWvTFKBVkEHZ8ZVLGK0HEI/TIOJsvb/GrHKz4YWR2+MrkxIxcH2IwHq6lOsAX
	Sbd4ctjwDcFFCmMwpUy0iVM0z15wlkxSOA6/hAC/SgyOqIha9640yZigovh/6Zx+anPgu9
	t1ahVY/s1qULmjrTuH08HRfg3vKdEIs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hr1WboyO;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E5BF160098;
	Wed, 21 Oct 2026 01:02:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3D51F000C9;
	Wed, 21 Oct 2026 01:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792544550;
	bh=dxapBMnN2fMQ/g84o5Y9DlnPN8flfC6uQghMcWIgUyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hr1WboyOwa1TDkH2A6h52vTFk8H0+YRNy4ydhMRTZDK9IiMqrH+yJHcLyTXUUQ6Pi
	 oKyXI26fWhMrTgxA6rH8IqA2LuKtXx93v/3BPgwfKy+z3sWP5ZGlK3lLMrmZzO7O38
	 dHsC75sTYd7Z6Q2tx+Fptm6AcQx88Q1Kfx3CRIsQ/uzwlNIth6z+tb8Q07BJa0wEm7
	 nHG90GkwavFP36Y2FkUBIThyxOBUsSFX1VOEVTrLbwT9BlpG0GlGnrES+fxDyWYkEn
	 gGH/7O1B5hJWAJfZgfcGnGwgIbFJjN+4/H6ZPCRhsCuImNEXHlo/skf1b6wPzo3sjX
	 7UgZDEiXBEqcA==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon/sysfs-schemes: hold damon_sysfs_lock in target_value_store()
Date: Tue, 20 Oct 2026 18:02:22 -0700
Message-ID: <20261021010223.94305-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261021005234.94107-1-sj@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C4E3320005
X-Stat-Signature: dbbrtirnco4jtnnzcrikej4nqh5ifw1k
X-Rspam-User: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792544552-228834
X-HE-Meta: U2FsdGVkX18irlOiueW+lDYEG1JmpAugYGA77joxTD0OICNY1TRXsqHV6bIY6jJ34hZg4iwTHUPlvdhvXzCi2QA507CmRfyGKNkBBu63+mY7JPn6zm3rqXdQrSfWHTUC2QbN4lqtYl4lp9Y8yG4XuWYtBJ75Bc5a2ytFPySAUHo8+uXu49PEf9oDrzfcxcE0WtKLmV0HwwxmcjB2rpAUJiKLp4TOsC74RPx46jgIgIB4SQ+/vNV1X82hQsZBgdhMT0umm3pVg/dFbmNKau3ZUGCabVWJ6FBMJsEiolfWQx6bCq37w4XE+l/y7bimVk11N4b+Y7WK4te28Vug/QURtCeStYyhhSR38lUl5GygqkBfJXkCzZTi01mB+EEWg7txkBednZqGq7H8Gu34++vpBVmLQt1klxm+VLezXUAXe1R3CRoIAQCgiq2jf7oZM6RAO71gIqqsSmRnfs3VsnNfqHvkS9QlYefXbM3uuiOhkkWC2dw9FlCsX7kJKPJNyQf+RfKGb8qqY/bFiq6zNkRN73oOdjRz7Jl6Xk7j2J6QKYhqpuzthxgC+7z0VA1jA6OUbFkOPzy2mmre0z0VIuYUVufpxF6wmJ6kWUCBl90X5kSHUyRKGMtpZ6N3z09cq1WclYFkga3AT5b+leY/qVCT1e0aIIqfrLQICvgaG+QHO+yIgK1Y0//U5jdKaCtoHsGogZeWF8KkGpmwAsmkQ26D0hePIfITED+Vu6PWt5UbPtd2Ce/ZGXsEPEwLyNNfNutmGQtY43FF248nDpcoVgmgQTZOEZDFJaC5NvhQvCyKLOVgeK44hkP15H+j6ZMqdjzdDI+8eY44XHFCB2DPS5R3qGIpDnyPsdsdx1rvbD3thkze+zIoML3ceXqo3CO4zyvbkgNikvkkqttcOEdbsBWJXdbBsQ8m6szu8HtJOAnCHw8wIWQTVaFRSyGyF8eHwI14RIBD6fbwNEokO8AFc11
 EVCW4xEX
 jpVMaSHMUpfvyhf4dB0O1ELfd2zy8l48zTnoxXPpgjghAo9vu/v/xNMn5JJtaKhYM7yXDZXfnTVZmQ4Gius2DHo0yv+RTmkXXkgNLCGukmfK54q1dZNfkzN3CbfJDfh91S9CmUdW20rQay742VAjzWALt1THQ+Plbu5G3DRl9KphazL1OSg6fN7GyPA3jnJjRRQ0w1aizFIdnodf5NHgdTfjbPrCC6S/kxjf5clQcbksP9SLHz1VhWlmKZvAowcqspMBWUb5wz9VzPuMuKNZE9Ae/7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 20 Oct 2026 17:52:33 -0700 SJ Park <sj@kernel.org> wrote:

> On Tue, 20 Oct 2026 07:47:25 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > Remove a race condition under certain use cases that can trigger
> > divide-by-zero.
> > 
> > damon_sysfs_add_quota_score() setup damos quota goal as user configured
> > and pass to the core layer.  Because it could have a race with
> > damos_sysfs_quota_goals_rm_dirs(), which destructs the files that carry
> > user configuration, both are called under damon_sysfs_lock protection.
> > 
> > The damos quota goal setup disallows zero target_value parameter because
> > it can be used as a denominator later in the core layer function,
> > damos_quota_score().  Otherwise, divide-by-zero can happen.
> 
> This is no more true due to another patch [1].  The patch added the zero
> target_value case in the core layer central validation pass.  But it forgot
> removing the redundant check in sysfs.
> 
> > 
> > For the zero value check and final assignment,
> > damon_sysfs_add_quota_score() reads damos_sysfs_quota_goal->target_value
> > twice.  And user can update damos_sysfs_quota_goal->target_value via
> > target_value_store(), which doesn't hold damon_sysfs_lock.  As a result,
> > a time-of-check-to time-of-use (toctou) race can happen.  If the user
> > sets the value to zero between the zero value check and final
> > target_value assignment, zero target_value is passed to the core layer
> > and results in divide-by-zero.
> 
> So toctou race exists, but it cannot result in divide-by-zero.

And the toctou doesn't matter because the final value based same check will be
made in the core layer.  But the toctou makes readers easy to be confused.  I
will post another patch removing the unnecessary zero value check.


Thanks,
SJ

[...]

