Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CA1CCA5FE6
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 17:43:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32BB56B008A; Sat,  3 Oct 2026 13:43:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 304656B008C; Sat,  3 Oct 2026 13:43:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2411D6B0092; Sat,  3 Oct 2026 13:43:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F36A06B008A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 13:43:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7A35B1C3001
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:43:21 +0000 (UTC)
X-FDA: 85282036602.23.D7B7374
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id E4489C0006
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:43:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jZU8EOjK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791049399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5i9V/0tMLP2xvI63Csg1dE0fJbtEKQ3vrLYSHswiMsI=;
	b=wmsESharNIaavqJAlDm0KaY4tnX5+bz/sGfskxfHbwYpYAm7UFqw5SJH15qC94gJ3upgkc
	A2SIjArGiuBUxxxsU961Gk8pFsuitZRoPQEvMrwH3snktII9ySk24FLMZInIFcu8jbhlmm
	RHeWsPEnkR/uG1R4Yw142kO8VQ32N38=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jZU8EOjK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791049399;
	b=7xKuJhXgjYa7UUhknqp/ulOWUB8r4/ZzibPkReB0hT4oJQIcqRujJupywpwQwqkXyoA2Rz
	e2uF/HK6IJCqdCTHTrzT9esW8fPyrFaOd8OoCJuxKhURVeKag1h2/FzsCcTtix49juIpH7
	CarFu6t5AvuoPlEDNpiFX/0muh6lBJI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D2A6060D9B;
	Sat,  3 Oct 2026 17:43:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B24E1F0089B;
	Sat,  3 Oct 2026 17:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791049398;
	bh=5i9V/0tMLP2xvI63Csg1dE0fJbtEKQ3vrLYSHswiMsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jZU8EOjKU+MYLZs9eQDZdg4YA56eBHRuQQT5UH/NVxVYtYn58+xxIXgribTe/fJn6
	 0q218POxlTo94NtpcOnJzbNtmZtHHQn9/BGdIg3NP4a1near0NIwDCLHQQ1NReSXh1
	 kmwNWyXNME7PwqmoTm9BkOJdbOaFsOGSFwvEsnYmT6Ls9W2V46qeGOp4CcfdK2iFXy
	 x6EkIwpkNbVNO3JDbnxp4nyaJpfeHLmYoqyFVw03jWqEgRQCo9WNrboRG6OsO/xJr6
	 QIMs83fE36fjspk+OemRnS27dvdZLB/WDD+YyKJbkxC6TMgtpQqHwt8u9Nxml6hKQk
	 KEtZSOIEY1WRw==
From: SJ Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SJ Park <sj@kernel.org>,
	muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	enze.li@gmx.com,
	Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 1/2] MAINTAINERS: cover all hugetlb headers under HUGETLB SUBSYSTEM
Date: Sat,  3 Oct 2026 10:43:12 -0700
Message-ID: <20261003174313.34495-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261003060029.2152489-1-lienze@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: h4oea5pmj65c4yj85emtpcpf43omxg5j
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E4489C0006
X-HE-Tag: 1791049399-22462
X-HE-Meta: U2FsdGVkX19esH+6v6VO4aArljgEIl1GV9eAS5GuNFN/Va6k4yRp8hdEbA8kBv9fWla6TX4Y5/sNgK7F/g8KMypSi2BpihbgJlGq+Cs3zQ2aVdK0zBNkUmOOIC8ML0e+S47RkJHCp04qJ0Rse6jXNVF3jshJWzzHetYLYnCC+dRGmm1uaf4HcenSFRKzWKtYVGN9FkgXlYxraevMDkiRYLefOpxOdtS9cDEBrntwqeo43QyiSmq25tVXOBRcHKyEfw3HPJ15ShcvdL1FzJANDGwQI1uW/KvgAtjIGNm5mIk5xu8NVZGkfXF7ev+hoIbDQDgojpzdMuhvLt4GvUQazvS06Gcuz/Pvwh5XJp4ZUA52BL2CzgKj16pjYzQBeF13v/B/5x9+EhA1c65sttQimXGoY66hT5ZZF0tXsPXkRybS2QBC8xz4lWpTzTw+8AmYtkvk4xQFNRo9SBUNo63a1ni9XhBosihl7XV+lSHVQ8AEavP8ISUY5M+F9Y0V8eYyl/Kk7cxjBpTgpJB8X9aaTsxZ1d5cnkC831ebsjd92TPncyi4Qi61OohSWXxi4yLFW7QyzobeMMXXAPSueZH+bOhlJ922vGXHVMR/czCZzSYYmMcnvUj+zVFbk61QdaYBCcAqlwJsY5mLBD7FGVjbQb2AwvroLTW5NM6T2pzrTmTRdRxeJdkQ9mdsXDiuQMrG3C0DXFP8NDmWunXQYgpbx+5RdD/0APqeiErcGEt8s9+j1fnPZD14feIYlc3kYFBcHqwqh38yVEZbQLzD/lgESBL4HubZ662WY7256glsh7Z7de7J6a1M47zqWzf/MsW1av9wuoQA27gw9nWLenuyYOS1rvZhDvE3Jghrf8SVZCWcvz8q7jPxlawYDDNDwAZ0oOXvlg+SzkDrY+aslj45E8Gg5NyDHkEi8+0IK4J/g78faZhw4EjSrlDu9XwYaftSVZaAotZ7vI4KSqG0yWA
 lrhHP7xE
 G3tX+Cl/rpnG5HC0YvkY2Q0j+K/O6/1t5jMWKqgbt6z9D0KTgwqa5nGHV/1FS+jgCpeuVE66aB+bigC9Tp2rP/SBlgNCgnfCN3uAhePzO8jF9HGl5YsP3HWHN6DyKSXs7rJ67ueUmwRGXYMLqy+7ds0ie/g23WN1R2lKaNqw6j83zHpHH6qZQiSLsM6mOq+NQaiDHpyKKXruyAvGCI7YVYBHhcCQ70LlAw4Kd6YdfWk5rdMq1FvxgE2+Q5HqlIiKEe9cfrmn/E6mUXqtqbmsY3KMIW0/Pdjd95ub4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  3 Oct 2026 14:00:28 +0800 Enze Li <lienze@kylinos.cn> wrote:

> The HUGETLB SUBSYSTEM F: entries list include/linux/hugetlb.h
> explicitly, but other hugetlb headers are not covered, so
> get_maintainer.pl does not attribute them to the hugetlb maintainers.
> 
> Enumerating headers by hand is also fragile: any header not listed (such
> as hugetlb_cgroup.h) falls outside the subsystem.  Joe Perches suggested
> using a glob F: entry, which covers all current and future hugetlb
> headers in one line and avoids the gap.

Looks good to me.

> 
> Suggested-by: Joe Perches <joe@perches.com>
> Signed-off-by: Enze Li <lienze@kylinos.cn>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

