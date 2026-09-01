Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5D3AC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 23:53:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD3466B008A; Tue,  1 Sep 2026 19:53:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B84896B008C; Tue,  1 Sep 2026 19:53:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4C0B6B0092; Tue,  1 Sep 2026 19:53:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88EC66B008A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 19:53:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 216081C1728
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:53:13 +0000 (UTC)
X-FDA: 85166847066.10.487BA83
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 780B010000A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:53:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I5l1te8n;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788306791;
	b=kbDLW4sPQwLWE/LyzWk/Vaji58TqXxZZR+Txlc1YN9bgvGiJplVvlP2n8P/pzLLFT9GQDN
	JQjFbucyXgjcnEd6WncEp2ilQk5EIZByQe09VM2PhApVFsdkdfzf51NNNmKodroD6Zg7Jh
	PgAa9MsYg8DOhao2EGczouHozYhPWoQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I5l1te8n;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788306791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qwo/oxJowOK5NCuSw9/wxwXOLTwjKgO41GHpF7gUkAo=;
	b=lcdDpJYj1IZpckKwFtrkUheet1k0jkhp/Vx6rJzJMNDrUfpveLH5p5Fv4/IxeIB8T/BH4e
	fAcpk+doWTD4p0bNrOu3OwRXDOTiQyHFKJpt1PqnHf7er2H7ENs/CHerHb5RrQBlQWj99u
	Ho0KE4gpSh2+ZO+56KGxft3gBh4pTXQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A631840BC6;
	Tue,  1 Sep 2026 23:53:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2CA1F000E9;
	Tue,  1 Sep 2026 23:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788306790;
	bh=qwo/oxJowOK5NCuSw9/wxwXOLTwjKgO41GHpF7gUkAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I5l1te8nyBGdwEKr1MLPS4uV0mJRTy6THlxjrphsJBK8B6R6L0vFvepMGAFim/ea3
	 HZqx1yzImxla/z2lPgHCf+N68TyJHoSygquTqNiblWau0Cg1kItC+3WV97Zbtc7WYe
	 MA6cZIQerAzA2dLFjvkC6FyVLkvtxYR5RDZp0cy9jARPAMJ5liyog7zQRyB0xY4lZj
	 QTrOB8hYU54uiNDarQfwBAoHf1jRVuZn1HRYwrhmi96pPtPP5hYQWYOgkCCFpj1YhH
	 vMQjCkrZpREBgWrEvBeRFUioa5v4FluEeFS8SpyMB+VUxWoZvAKjh5Huj9IgGaSR1J
	 qKGQKv7mEs6vg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v1.1 00/17] mm/damon: introduce data access-as-a-data attribute
Date: Tue,  1 Sep 2026 16:52:57 -0700
Message-ID: <20260901235258.103447-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901101800.0d76452eb310a4b958d792fd@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 780B010000A
X-Stat-Signature: nc5wcgu6fo6exoheb1jfjri4n7cdnx4g
X-Rspam-User: 
X-HE-Tag: 1788306791-990924
X-HE-Meta: U2FsdGVkX1/6pHfMrojX0sOSITTDVHLjZhiAPhQCItcc8pTsS6uD4QfMB24uTDlbU2uEWO2E0flTsfMcm6RCLlwk1Z7G0+EevyuMG4Ty1hNB4A3gxUnTlSRFcbwtWgIAc9uElMKFwU4o5aiyvS0M8iLPh4pU0X6AuL9r9W7IgCeeHBa2QYq5FcgBpRKmiD2kP6JD955Z1QH1spqD83d7PwSK8szbUxgck0/W/k40oTtSCOTD87M+G63cBdWjt9Fxb7Mhu4askKqYmziZAZ1Klz/8IHnkq+F+fmhTIUjapLd305facNbiOCxJ9dfJPDUJmds0z6UHujRPrHlESOEc56/pKZY00jooN6lIo84ahS/v1FLMxUn/2XQsqSVe+E+XJk5+wFNuqZ6RmL+LIbkrWB4H/B/qYpdc4EJVEd99IX1jqSFNxgrP/qmGjqJ9cgi7rPUtpJUPLnCGbAjPA2DBhlFNRhhyFkQ2R4eo5xAaL1UKs3IrhEs4RLsq6ibvRMWVwwi5M1LPOhGo+tiy8nHZ3EzxyXzA96bYul472UpBMYh8a6YEKgE1iW2uWXBs7gimuoLlmBWt+fSXfKdvOE0CsKGlyFRakiAJMCYv+6fhB2zEhmbKGOEWNKDoocRzHfIwGY2eSOxLX5inJj2FnNeuCJXDf/TuOA4v409NSaPdLJBaRzoF9zt7V6/P+oH/JiaFf0shamVlaT2H9wvhjlXqq8DJHyGK1EOIkWuQu/THqcoFMYAYbVaP+BQSq8LhVBxfKzvxvPq3EG9nyBd0+lgVWVPqDeD6yrLYSp7ErDxy+kVHf3gpYr+55BdVG6yzhoRLXhAks1l61x5hEtcYwyjsvzf4dGNDjmlYeD9GrIjyGU3W3knxKmPbxIJbmxjxCOS6OYvD7YefVD/UbFv0tfMkZXCenWdM7CSuw4AGsRG2GP5n/6Lp2f8+BdmQKjFjwGd0pkvhE2mKxK2NYyUaoz5
 QZ0Zsll2
 DlnNYfLq+G77oKHmMhlXNasIJGvC1rnunoGlh3xhEWHR6CXqf41XRMClGzNxByeU6P4DbQz2j8UOJKF6REJc+odsiTufMkS/P/DU4KE9xr/xYQruy09kLhq0KVareT2jXvSoBxnoUE5viM1CzWbNKgjhoJz4CG5Sn542Vo0vi7t6yjc3usOpI1V3l7TiHAOtysAycIy2tBj4tIZ9VEkDAV4O4030Qazo+D7ce/ZR1xB/FRfurn8wmHXzmmLjtRcdBu4xBEYy5kCgxGX8Eivh7mGp5rH4EzUbRsFHNcDU/Y17d2gPaQGZPiK1exu8yvO68jg0Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 1 Sep 2026 10:18:00 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue,  1 Sep 2026 06:24:47 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > TL;DR: extend DAMON's data attributes monitoring system to support page
> > table accessed bit and PG_idle based access monitoring.
> > 
> 
> Thanks, added.

Thank you Andrew!

> 
> What does "v1.1" mean?

Sashiko found a low priority issue on the previous version.  Before the Sashiko
era, it would be fixed by posting a fixup as a reply to the thread and asking
Andrew to handle it.   But that cannot get review from Sashiko.  So I did
reposting of the series, but with minor version update.  I use this kind of
version scheme nowadays.  If it makes someone be confused, please let me know.
I will be happy to adapt.


Thanks,
SJ

