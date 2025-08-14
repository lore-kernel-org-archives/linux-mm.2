Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60B21CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 16:11:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E86F29001A2; Thu, 14 Aug 2025 12:11:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E37E9900172; Thu, 14 Aug 2025 12:11:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D27C89001A2; Thu, 14 Aug 2025 12:11:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B9BAC900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:11:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 720A3117E3D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:11:30 +0000 (UTC)
X-FDA: 83775853140.03.260A2D2
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf03.hostedemail.com (Postfix) with ESMTP id B977120006
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:11:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="c8K/QkvY";
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755187888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zsy47NKhUY8tIrVXD+3YdDYTjMlSMwXgKAo5KN0TdPM=;
	b=l4RdRrruhymbK/eIMSGQ2C4cZ+mCjrsOesyWZbqx1RwgbUZTIG3u3U5tThxIhZe6G5/NGr
	r7DT+D/IlEWNaekKlR9Hx/i4QXQU9p+DndD8h8uiIK6PfVI3kbS/LReq2VzT+x7MVcWJTP
	zVYihYWs0PkgOoB/ta7py/nOqVqMWlg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="c8K/QkvY";
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755187888; a=rsa-sha256;
	cv=none;
	b=uNpRXsZ1Bof529o1qvGoP6qzjvo913O8xYA1kmxe/dooWo4MoBh5rDFxyxA/33vflT2Oab
	uo8Ld4J/Wm88SyJYxXJeXoFt+7wRuvKKKfCPMM2zWvHShhbuNwfk2+9kflB8nlebfvkwjp
	tqnFiKC8uGvX+6M2/O17eDdmYVN70M8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 04F29A56EAB;
	Thu, 14 Aug 2025 16:11:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81AF8C4CEED;
	Thu, 14 Aug 2025 16:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755187887;
	bh=08/3DM8LoFIHR7/BNGxuLaxDxNLDuFb1zlEw9gyMNdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c8K/QkvYAZUSLTmYvCDdY7DHU0hbICvAA1weY6qGkXzn9FQYu+81sqYA0kcq6k+Cd
	 7rTBOYUMYpkj4Q0wTOKEYyGWuoeOqrcd4HvXijlEUjfWjl1xyKEvR8KypKfiPgOALi
	 9mKkTc6ed5mUsXA9CpT5Kg+Pq/eJANp2zzxfxXZmYTWZ7Nr7Po5CM6wa8Dnz6FQSWH
	 a02UeSlvlFOTpLTivuLE9sS6R4EgutHFLUzead5V+C+WwP6PxQC1gbWdvE5VkvoaJ2
	 R2u2E2xJYtcixHNVl/JOn63noKQOIt8U/1WZxE06cQVJY6ucikVlNHmyV7vaDbBdfe
	 a6rP/W2d5xcvg==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [RFC PATCH -next 11/16] mm/damon: add addr_unit for DAMON_RECLAIM and LRU_SORT
Date: Thu, 14 Aug 2025 09:11:25 -0700
Message-Id: <20250814161125.67602-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <39e07350-2510-49fe-ae4a-e5d10b69291c@huawei.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B977120006
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: r9wdhnjno6qbjuws3kzcjuzunzpzxtyk
X-HE-Tag: 1755187888-586075
X-HE-Meta: U2FsdGVkX1+4QFve//0yxX5eiLgq74vOo3aoxaVB3YJHiB+zG6HaS+Ohr9OGtXXOBMRUbcQOzEft9vlDyEvax+vtAkcDFJ+CuJ++o6nkVDHuqUyHXmmbOXiylIsYfZJavcN1raBpOvWBN0QHN1ObFwbaTLMS0v3UIHB9VocjPkdytPx2DK7TxcaA0XVrMbYOyXI/0GoM6pbErsDlhIu7BxIA4DYL4D2TaLHNHTK5JO7+ssOclBJ4prK3v5b/oFB7/ZOvUYe+cFpjGpNRWxE5a14ArUmDX6uKnIud+JRlDj3SuKuSPLZkbWva7qPbmz22RFN7/YSOBsy/VRjCdXKWZuGBXp/PddnkFG1XE0Khoncorv29s8m4a+J1wBB3toksixt4batO1CEAllNv0NpiDPAdbVJR9vK7KcR7FVs3rL6Lk7mODRUTx+rhxGvJ4den2NVvF5e8Nyk1Dl1L9W+rvE9pyeH41klZ8VlddeT5NCK4r2OBk0+pA5hDKDrpgMfrXLUoEdmOfTSmYLLSCfA76bRv9xsNmLABAidxxuH5XZdaWe0KY7uPXj7R2h2caufolmQIQt6gAxZQMkOOU+PysUesRtVjCsnKCagaezQ5Btuncr612CgbfCf+M5gAxIaNWL+WyPTTb9Pvz2yKT71R8D4/AzpmckKH4/xHMPD0j/QqcynbpO0TmFuRw5QIk0LXJve5Cpg5IvlCiEjB47phfQ6dv/MSVqEY8rZc0Q81YP2p667Z0psNe8WYVQ7G6b4o+WO4kVS80AzMJlbOcneIkUXHcuTuETqlRJa6PTgTobNzrHQH53xsxyN8pT+Vun5purpsNVm+6lmQtE/mSU9xSeGvHJ6tdfgq3PgRvvWPCoRNpeBOOwvibscl97F21rdU+u+IzX2K2D4baiIRt9UATl9t/q71sRAAQJjDS5/8Bfh2qEX1AuweIqO9lsLzJ6qTj7/fL+FIP8E45/5st+J
 GJ/Vx3gQ
 oMsJE9gZTP7oTuVy03iuoBqWA05/bzYiI8hZgx18bfW/IjxEj6FCKAFx2YJkMMMoK0qXYFS1ywf0BoD7dFg8vd0O3OxcoQXPGF8QlWM6ZgMJjc3fGgSFqVhCl3LdQdHkZOZxpO6zU1UGnRwn56/zis7y7AJNj4lfi4A6I9JWaqjjiCJ2QvAKTwI3+THyMdjOhNKeoZRdA3hBtvSMRdQjR6WD9duWOE/GJ/zacfD6G5nhWlcyAl3HSNtDaQZ2+f+dRWpYoboqFPuCadqmr8lFQXktaUUGj570bk7BeVx3c4w4lEFpE4PI0evl+6Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 Aug 2025 20:59:04 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> 
> 在 2025/8/14 0:36, SeongJae Park 写道:
> > On Wed, 13 Aug 2025 13:07:01 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
> >
> >> In module DAMON_RECLAIM and DAMON_LRU_SORT, the damon_ctx is
> >> independent of the core, necessitating dedicated addr_unit
> >> integration for these features.
> >> Additionally, if the input monitor_region_start and monitor_region_end
> >> are both 0 while addr_unit is set to a non-zero valuethe default
> >> system RAM range should be divided by addr_unit.
> > Do you plan to, and need to use DAMON_RECLAIM and DAMON_LRU_SORT on LPAE-ARM32
> > environments?  Can't you use DAMON sysfs interface instead?  If need to use the
> > modules, this change looks good to me in high level.  But if not, I'd like to
> > skip this change, and wait until someone requests it.
> >
> > I'll review the code change in depth after the above question is answered.
> >
> Hi SJ,
> 
> Yes, we need to use these modules in an LPAE-ARM32 environment. The modular
> approach often provides more flexibility in our workflow, so we would greatly
> appreciate it if you could take some time to review the code!🙂

Thank you for clarifying.  Ok, I understand this change is really required.

However, I think reviewing and revising this part may take time.  Meanwhile,
seems this part is not an essential one of this patch series, and has no
problem at be separated and merged after the essential parts.

So, could we separate this part from this patch series?  That is, let's work on
the essential part first.  After the work on the essential part is done, you
could post this part as another patch series, and then we can work together
again on it.


Thanks,
SJ

[...]

