Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62E3AC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 14:49:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51E176B0096; Tue,  8 Sep 2026 10:49:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CF566B0098; Tue,  8 Sep 2026 10:49:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40C936B0099; Tue,  8 Sep 2026 10:49:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 22E796B0096
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:49:06 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B45CF1A0652
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:49:05 +0000 (UTC)
X-FDA: 85190877450.04.2BD7AA4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2B23B14000B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:49:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=otzDxKaM;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788878944;
	b=LDsXYI/pfY+35CFwHYyPn5FFgjN4tK8trCdJ7r86wdSmzL8O4Wt0yW7pS51h4hHzUO7r5A
	i8dKy+jynWrXwcH1dQs5NvxHZwTzlI/pgdszBqFt9u3PvYDvPhT0wKEzrU8lD8y1UTzVTY
	z18s5ime/y9BIEVdbxK0eFl39ets5m0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=otzDxKaM;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788878944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X+99Jcayi+nWYM1zL62pmOjFdwDFaLWV0ywtPPTSgRc=;
	b=RqY9j3YusyOrW0vTDlf/f+SJ1dsgPAJ44SKAH7wpzrIqlrLKV7fWMUV7kXskBfLIkr6RaL
	iEl9pNMGdYE1RKFpozdetgSVSAIEXE0ykXfkWxCxgZoiXcypha1Px3oh0n7WBLjnJz+Jaf
	YaMWRxkRj4bVLZNw0Y5JAjeRfKXz2FM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A382B601FF;
	Tue,  8 Sep 2026 14:49:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 353461F00A3D;
	Tue,  8 Sep 2026 14:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788878943;
	bh=X+99Jcayi+nWYM1zL62pmOjFdwDFaLWV0ywtPPTSgRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=otzDxKaMsEPo5BrTh9lku30PuCzo66+jUoEmpvNdOMJa+mEV0SykNq9Z6gLqExV1h
	 cOZZQxrplmUWtetw0kDKb03j1d8R0zTPZTB6vRkvls2cQZv4B65o38aZMrKzbAbCOu
	 3aveOxcjSZYbfLJf4tDSjdjbBBHPlzW3F4u7cSQ+YmXC+Upe06IiwTXJCGaBBu+ezP
	 yVxQD9Ms9gBNq+fPKvVwN09Gv2HwPG8T3MlGY0PsXJawghAHcT7+04eHJUGo4qFYmH
	 /FkWj5w/Rkaf38nZBXKNILzS7iinjA7szyqzaKSPydOajMCmaxycC63gDVj7785jb0
	 u1AIDhfMppEzA==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 0/3] mm/damon: support access monitoring of hugetlb-backed memory
Date: Tue,  8 Sep 2026 07:48:51 -0700
Message-ID: <20260908144852.104829-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260908135156.97481-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2B23B14000B
X-Stat-Signature: 9zpyknnyushprxwbhmh5protxws78es4
X-HE-Tag: 1788878943-518348
X-HE-Meta: U2FsdGVkX1+/5bulcJe50L5E/r3VpP6B5dPVbDgPAqLPpibRgccE6mwe81kX19UKK5X0FY6aM+p4pgqaaWYWrfbN8RL94JIOlku0z7tna7splUDF+jYgDsZSF77Aq2xZ74OamkL/zop8xKQt/+d4//DoZzzH9CIpQNdWzQsq9egpo0kOBSeDpNXSHRU/SNKOTK9s+t+9bWH5ctvIBuDq+JQWIEW9X2T5TZpQ8sXZMBEfylYWRJxx5TcEqJgYhGnLdy1lcQbT/zeDa34Lds74K7ehyfstNL/A44JqvGiOgQeKd4ZpvpUhzea+of0R7iieIMcHUWTYY5xf4rUjtmcF+xOERpaWv8Z3Mu3O1+tH94vVIbb+tYJ/CVgsEFjUFZmtXyiO3TFOHUfM/9OF7Ny2EE4a7ogJeuCXDCNFhftYipisaYweQACZlliX5wc5UfpxBRMt2ETLvqRq+QsBVGYZmcBs6SxdI/DEQef2fPp/kFGnZyKgInmhTcqBD1CVNmhczmF3c2R5HoJig2URfghnYCBjIXQQIT6gE65Z4aN/v/bV6wZAKgbqH95DJrd9BzfRiLf8cl1mRDozt9ipzv10jsZ1b6w997VSgiEIItln8DrDlRXmDqkwzizdTvMnO4s77kOhUjXp21OoxJZFMn890J/iRIAXy9DDC90KnHhzuCAnxa2N+BqPAHfS3smM8jdVeIXHgBusCK+aEPxn0cVa3lrrZzBW8fVOCStZdaUrXWK5DSlhp+F1XWJrI1hag3lKppNExzy9BsieuthnckDLPvOBbUsE84Ml+H9UABcVAQfGN8rUgxCz+Fu5kG29lsxmlRxjWIR4uGwvZsDtfqGUCLmKhD71nj0vLTvRWdXxSm7ooAh5eKZMiQVMt+Rtyr/9l1ES3bkRwysHsC1ubpFjXND7kEmaTQsENikLfSpIxM/pcj3jV3UP0hn5bgzlA6NLDq9SgE7/QJFmY3e75pm
 b9OuKSgP
 9Hf2Rs7pxkSH63BDiWUfISZQLq2Zebv1cih6kyZ1hClzBvbTs7RMZGgcoSh+IrWuFys/tRwqv0vcIGxlkSZIS6/C6BYoYSwrsXw4Pq2Odzi2COmusiLVRu09Fk7HEYdKK55e/82JL6d0l9GiSK8/RFfknuU8GV4Xidr1BCJtuCdIcrnoJGnYgLKxKr2uAC1FOkgAvjWHEl/4yuPVKXABCojiVi3kX+T9hsdmjHEbOUiEwlKg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series relies on atomic hugetlb pte setup patch [1].  Without it, applying
this series on mm-new will fial with a conflict.  Because of the fact, Sashiko
also failed to review this series.  Sashiko reviewed the previous version of
this series and found no blocker.

[1] https://lore.kernel.org/20260907170358.100168-1-sj@kernel.org


Thanks,
SJ

[...]

