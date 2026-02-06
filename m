Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FCB2EE6B59
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 20:43:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 016576B0005; Fri,  6 Feb 2026 15:43:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F054D6B0088; Fri,  6 Feb 2026 15:43:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E12106B0089; Fri,  6 Feb 2026 15:43:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CFC0A6B0005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 15:43:45 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6C82D1A02AF
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 20:43:45 +0000 (UTC)
X-FDA: 84415208010.12.E5FE4BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id BD102160006
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 20:43:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="cEc/bc8j";
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770410623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=syDLORT/4uzWMK+hnAtj8+YwBgfLLWESBO/oTO1z7vU=;
	b=3ht/KbuF4ccv82ImrAaB6Zdkep+bmHyyzikkIPXuVpAeTyDWV6Xc1Fg1LKbqYj8NX2YHkE
	Ruf/tKBunnwmXdPbP+xkj48h4vO9o+XxCvB+PdRNGdkQb2TkQo7QhhHU9y+gmbYqWSTlYR
	Ff8fm1mNm4F/9fmhoFYzwSNVChFu5So=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="cEc/bc8j";
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770410623; a=rsa-sha256;
	cv=none;
	b=stA8uFLxhnIdyh95UxCa+/9II8AESVaM9XO+MdAL9pk0SrLtVn7YemBvWgsrq95Fqp0O3X
	WoaK3sQlhcaj5b34UwrH+iTONZiclBA6s8KNV/QrQYnenvJrgiPPjiGvUmQgeIWZrkXUJW
	1oNPOGIM1u/7gpjGQUlD6VlRE5gnezc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B2C9140281;
	Fri,  6 Feb 2026 20:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723EEC116C6;
	Fri,  6 Feb 2026 20:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770410622;
	bh=/TnX09Hv5t15PMPchOzqwIa2F9kys99mKm/6GSVU3rI=;
	h=Date:From:To:Cc:Subject:From;
	b=cEc/bc8j40oDPNKYjkoeIt5QOpwDrrjfVP7k8Z8eVNzsNwGXtdV8uhbFatg0YSP+9
	 NafyI79ICSPkzS/NH8SdBKHhVCrmMvpTbFc4+w+U03rGk69A1EO3sagAUm1hPFDxG2
	 HSkjpUl/e6yHxm53HCkjDKqk9I4HVshr9oiDpmuo=
Date: Fri, 6 Feb 2026 12:43:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] more hotfixes against 6.19-rc8
Message-Id: <20260206124341.c7dc8fc55e0f0f9ea68d3951@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BD102160006
X-Stat-Signature: ztrn581rgn49d7tidy5zo8gi4xrs9so8
X-Rspam-User: 
X-HE-Tag: 1770410623-281620
X-HE-Meta: U2FsdGVkX18ipF+lkrkm35ftbcbHKPREZi6DhkBA0Z3nrBYqhzTIxJNMdVyXyaPHn1Y2V9QSKbifNg0BhQ/EOl9y7rJozbtV3LWiP+IvP+Ui9UKIhnkgzboE6kH/zD9w04iuv+OIgQKMYHtV8V+sWrPqiEvlhdrkHOon61kM+PZ7dOBcmmNCFPibgEalIWVOgL05bjjH+jNpyY24iqnS6bbelHF7NaA0uPqLolNWLU8up3qMGknNpa+M4XX+lWIdyDJLqlvsm6aS+5yMjWXpcLhV0MCn2ZlpxGLnNVqiDIqZFougD3hgGezAy19WHdBecQjohp7qOeQOSUvfrq1bGOJQ+O4jv3qb7EmCF/IhfIE8V44FvkY6WLPs1+aMMq5euWCQzlkls3WoIYgktt8JhKQIFcv7RnGz/tMINnYuRRTln2JVao51rsuEqfof8MAZU+9zHa8KLq7LZM3AR8kLBI8CBhbTLU645nvkBbU6fDMTxcpAGdQKNyOQM63zC3BsN//K7j2iNz1Dm4hs/+KePilKnxD8ADSRnJ3tLFdf12fLmmAqaFGYl89K5bd+klOgdfYfpfqYzwUT+6ay7111Lz8KqyFyDewpy1JRRY/Vv49fqdwlSPBTuLACLOfD7XvNSVcrbayLKRTo39NLZlqxj/xY4qvZ0IRTAbcQHbhvpuQsG/QtjiT/K8YiKcMVj6qRN7oOOQ3RGJ7uKiCuZ+O50/AVOKfHGWn9A/eRQZC9c+TXh4w193uYzvuuTA2HzGpmqK4zoRfYeQdWkGp0tFsQkwbMGtYLeQVRAg4ZWUMrmg1nev5HuM6OJh1kttWnpgy20w4dkHsYxs/TTHU+QTkzv4O9AamO6KbfzMgfnpvFZtA9+8QkLLIHKBj/JhJTvYFpN1SZ9FraTINv/Bo2Zw20YbJkzDzSN4aTsvzER2oTTsucNs5TjrxoMAbxNH4c47tpX3B2RW3OMqevdzHvHYW
 tgGICxAd
 3RW1o4cDnZkdRI7kQOLI2IKblVNvT9tP5bKMeznPyPBAbRn0foP4APRrRdsmA+CcgednIBQyjssj5BIQYzL4pYkpqTP6g/HAS3NTdwkc7+bxj4z+7zNY0BcuAZqRlZM7gUEGlOdGWGEzM+A98i6OFcqIiu/lCYgR1xmUUkXRFSGi2closOmEyouj8bcPPOf4tCD7UYkpM4OYP75Z4kM52ZYt7BfeznjqxlWeAzs9mGppMVBoQ59SRvUXYTCTnaTGQlsFpwG5u0rsG8Ld5Xlp8nib0Qg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge these two MM fixes for the upcoming release, thanks.


The following changes since commit 1a47837bfafed7e9ef93f5dfdea6d70869b0c3ab:

  Documentation: document liveupdate cmdline parameter (2026-02-02 18:43:56 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-02-06-12-37

for you to fetch changes up to ae9fd76c111bb4a5293c2831a1ad373605251dd6:

  mm/memory-failure: reject unsupported non-folio compound page (2026-02-05 14:10:00 -0800)

----------------------------------------------------------------
A couple of late-breaking MM fixes.  One against a new-in-this-cycle patch
and the other addresses a locking issue which has been there for 1+ years.

----------------------------------------------------------------
Andrii Nakryiko (1):
      procfs: avoid fetching build ID while holding VMA lock

Miaohe Lin (1):
      mm/memory-failure: reject unsupported non-folio compound page

 fs/proc/task_mmu.c      | 42 +++++++++++++++++++++++++++---------------
 include/linux/buildid.h |  3 +++
 lib/buildid.c           | 42 ++++++++++++++++++++++++++++++------------
 mm/memory-failure.c     | 42 ++++++++++++++++++++----------------------
 4 files changed, 80 insertions(+), 49 deletions(-)


