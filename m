Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73BBDCC6B3A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 13:51:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 798926B0095; Thu, 15 Oct 2026 09:51:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76F916B0096; Thu, 15 Oct 2026 09:51:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 686B66B0098; Thu, 15 Oct 2026 09:51:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4328A6B0095
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:51:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BB3341409DF
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 13:50:56 +0000 (UTC)
X-FDA: 85324996512.20.C02B4B0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1B631180009
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 13:50:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eep/pvRW";
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792072255;
	b=AV6JA+jp1dp260pr6qK/0K96RiC9vZmZy7bjjX2j0CHK6ozOUNsXF4Flu2THFF8a0UkgfP
	e4P5fTR+an7iD37j+0yhmWWy/U0o1xLPe8HyN9GS9fIBl8c+ibHO9omTO0vBzGys5nWeF8
	fTZr++uN2z8/klkQMMMWOf/RzxT7Wvw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eep/pvRW";
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792072255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uky4LxVMuNdxzqnRXqwRhSpdCLtiXE4d97pVcYf0z28=;
	b=hQb5Y/xOgs4dyfjtrZLynvGkjxNU9d2iYkvKkx0kvs3gA5ULVlAS4xchul/7KhObbm79Cm
	N1u0/rCIcI3eMZVBVMhzEMhwIll2cUPsbrMDHF0a4xOsXZSQZ8Ir3WOhUP6Vwnq8uJvK9G
	JTDJOZ4Xiez8cZchLcSofKFshlR678c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 958E460120;
	Thu, 15 Oct 2026 13:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9EA41F000C4;
	Thu, 15 Oct 2026 13:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792072254;
	bh=Uky4LxVMuNdxzqnRXqwRhSpdCLtiXE4d97pVcYf0z28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eep/pvRWLeP7LUG6Llnfw1tNk6uZtNkk3PWjmeLelCpsn1VwxSQQqGifW+Owm3H68
	 O44r3hiFFVgv4vpz6w+heQRlMkDt5Zj6cqprL6FuxEy9maxJD8tFIUquiUdSOIkrnL
	 T+crrUqoslxVDIUyk6OPWTDrGs5YuMWlDbxhPO1Q95NT9LqXXVqM8Ahlhcex8ZFy8I
	 2lBEcO/zPkNSqULwIdy9zQQZq2C1pzRXAJ2H6vQDtd9Ihbgp4Qucoqv4ZeDbOn35AY
	 BX/hdcdohYwq9MHltL8ShzcHFu8YAJyO3H20ZhCKt0lyqDzyq7LdcwnHSpw0WJS+Rg
	 BTHUVNoYXbkQg==
From: SJ Park <sj@kernel.org>
To: Manuel Ebner <manuelebnerli@mailbox.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/damon/lru_sort: fix grammar and stlye
Date: Thu, 15 Oct 2026 06:50:46 -0700
Message-ID: <20261015135047.87355-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261015072947.802821-2-manuelebnerli@mailbox.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dd5nk8c9w6py55i1g6msmc6ohj5a57kn
X-Rspamd-Queue-Id: 1B631180009
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792072254-41583
X-HE-Meta: U2FsdGVkX19X/bD1Trne5agUfIayYtiIweKry0UeBSRjWvK25CyYBynax2/S0UJZJH7YfTFxG9qEhlYNrcPYbK2hD8My0eg/Ze26sLtTPb1bfOyhodY4aDTGZ7bDe6IVWIjLYMLklE+QDo/vTuyQmwLqHeLTeFGqdrSTHA0Agg4mKdLLwc3M/pvh8CyBwb7yhS2vAiKRwTzt7YMm1Bjy/vjVy4eLC97aEtF8U5lIdzg6zSRwljyMWO33ZI/PYdQOV854nqY85pcaLj2m77B2QPrZfD0M/E3Q+RgSd29HmyWaD6tu5iHM0FV4QM7/pU2F9cTOfDGsQllkb30U5ArQ35F+E3d4tSZFGgwFqSpnNoiL+XWJUPszyki4YGku8L3spkvWOnXbfdDsoxioT805FKmM7Crasu+a0E+h+/sxePuNWDe0XY5GrQjbor/20xUnLDxHjrB+nbO+bznhT0I05TJb+F/pgRj953HMLlwQ6NdFGmbRy1pNKV2XDccHOWEO5VHe6f9drJzGzb5CQ2Pz0qxFwLo4KDS+iEX3CVyE+Bmb9rHFPKQgYcjPssfPtZZoPiPK5eNzQEuSlYS0M43drfVCrZZWoiNy1y3Oz1qxM5DEA94+FwCVNZ0dpA5U2OFQeERRKe+igsGiZPyCGq25moSCLeMkW4bIWgNNozQ+gzQmDcLbELY/8wmInSNy+1bQFW/prk1xIu+oP/GHp9L1FHxg3Oomha/Wi6eZYKt04T53SyTgGemkAz5/cW5H1tos3KbeGqXev1pgTVH9A0CcgAtK7QBmuuoJddThGb2FgDlEK1LvmrXXDw7Fwkyqe5FIzKwJGycOXqk85laE4h2VvbGxqbgqnvUBYz7tSq5rQ1QzkXf9TS3VyMOAHCNtu6KB9z72WFKFxqD/vgLyod7K3SKYjIG/hVM6GTuXPmgXZBDMkzvstBjilnkYieFzO7+5NKH0cTUEXHZA8xthJDP
 S1CRCy69
 uSxPwUWKsR1JQR8TGfmW+0hVqm1bqxD+DXOS+Fp6K6isDi8If8REJDe9CQ4s/Lfts79HXmDiGCCe08m58TuwURWfexh2ptIhdyKZOc4CHI+Vm7wcBGIsfKURVwbRBs4pMO1ydPrxmi4nXCEQd7C6iFPR6TiFIIXvQ350qHGGOLL6HjTUClRmXAyng2Pa18/UxauHmjDPozxp9vDI6hZToCLHuKJFpR2TsitNbRm6QV7k23pUykHbN0rZUoFRR8Echx3qH5mtN8RBxLoU0UJwkZKRm1l2txpozjT3eS/RRVo2Nd4t57rnQQDphu+W6HjzzEHSzobyJ5QZaXySDQDlZHJxCPHqtG+/uk858dNQR6a6hP8S8Lx4I76gSPWYCXHkfGQUz1ed4ARBY1QQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Oct 2026 09:29:47 +0200 Manuel Ebner <manuelebnerli@mailbox.org> wrote:

> Fix tenses. Split long sentences thereby imporove readability.
> Replace 'set as' with 'set to'. Replace [] with () to make the file uniform.

checkpatch.pl warns as below.

    WARNING: Prefer a maximum 75 chars per line (possible unwrapped commit description?)
    #10:
    Replace 'set as' with 'set to'. Replace [] with () to make the file uniform.

If you don't mind, I will fix this on my end.

> 
> Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>

Assuming you don't mind me fixing the 75 columns warning on my end,

Reviewed-by: SJ Park <sj@kernel.org>

I applied  this patch to damon/next [1] tree with the above mentioned commit
message line length fix.  We are now quite close to next merge window.  It may
better to focus on making mm.git more stabilized and therefore ready for the
next merge window, rather than adding more changes that are not really urgent.
I understand this series is not really urgent.  Hence, Andrew might not add
this patch until next -rc1 release.  In the case, I will request adding this to
mm.git after next -rc1 release.  So, no action from your side is needed for
now.  Let me know if you think this is really  urgent.

> ---

Please add changelog on the commentary area [2], with links to the previous
revisions, from the next time.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees
[2] https://docs.kernel.org/process/submitting-patches.html#commentary


Thanks,
SJ

[...]

