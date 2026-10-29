Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 318E6606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 18:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iIZtMquo
Received: by kanga.kvack.org (Postfix)
	id 2E8466B05D6; Thu, 29 Oct 2026 14:32:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2966A6B05D7; Thu, 29 Oct 2026 14:32:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 185386B05D9; Thu, 29 Oct 2026 14:32:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DDF116B05D6
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:32:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 489D61C3D14
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:32:52 +0000 (UTC)
X-FDA: 85376510184.02.2B9D347
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 26BD412000D
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:32:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iIZtMquo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793298770;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=wp6+XwXTd4L8v9EYFAYebKPgpODdcdORb1VRJJaJilI=;
	b=7Wx2yI06u+4JtlEjB6AHriT6bp3Xa6aP3RKpDwUh73VUKdFCQvSQjdEILAJ0L+f95ufN8D
	Zuw8v7XvGPYOIapDXIYz0tBNB5iGIjUitsI3GrjznG8kCeB44Zwh/qjGKAXihSShkomCH4
	5fXg4/vtUAR6JgZvb4seIe1JXske9PE=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iIZtMquo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793298770;
	b=2ZgiX4nnnWKNouhyDODAYzRAQ7AXJlmHum9i+g7UsKTlVjvUPTLkTdW5Y9+XLrNje7Bs+D
	LVOmlWMwFah/aNCMh2hY4b9gopcwfeHWKiy+GP8kz5RPdDsk3Wa7VO1Q9mGSCGW3YJGqBb
	7uQd5TA7mx0VTBY2WaoaPzpVwNldPAs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 293A143C37;
	Thu, 29 Oct 2026 18:32:49 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793298769;
	b=UfzzSA6h3AmI8B9bwMxClevpWToSuQqbXJiBDyzHZ1QCoqfJnoLNgKs42Cqrn1KWHP/U
	 dE0yy+hor3Hr12QGLyDx2a0EY7wu07J6zqFFKbNJ2zA7RzAGEq5njsSJ+hcvj+Jn8vHny
	 OVLWqiCYS7NihwBsT0OakZwu4reFN8+G3xIyV5u5p0/nV6OLlMkIQNfWxof12eIsJf8Qi
	 vWQnHXkj1kz40PjEbdsZDVWopjQ4JOxutHbu6lZptDlQMwiH9qjdgXc4TJO0IFtx1ZrhO
	 CMNj2lmfGTuMnpEFSszwbVasAGq6kPenTkEUAcFKMKevMJEpeAkm9TWxKeUOM25Q42Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793298769;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=wp6+XwXTd4L8v9EYFAYebKPgpODdcdORb1VRJJaJilI=;
	b=Y8zUMZn2z8FmFJs8N+UuxYwZTYatVNR9R2Nv+ZqLs5OjiorhftwN+7oRhW65fEQpt90T
	 q15PlSPUDejYybAQcNbYb59MhPmoWAiR+shX3cDtF/rzzcIGhimzDBk3DoPP2yMVEfojx
	 fkz1sZEdl6Mw9ub4nnZHPP0lTmYMGFRhDa0RSLgQcHpANWeQ5Sdbhh7tKrTf77AR2+JBE
	 4GVnaxpdzdxWY3d/MExlzK+/ziucbD7ptpKWJLGDpG32v9zBrapZ4iAutjdKMqblAOL7T
	 DZS9dmB0ByqC+rtRkHzvm0Ty4h3eYw4bVQB8w13YZRlXHOHuaEYkBC7Ya6sqIdcjwkQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A0B4C1F01816;
	Thu, 29 Oct 2026 18:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793298768;
	bh=wp6+XwXTd4L8v9EYFAYebKPgpODdcdORb1VRJJaJilI=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=iIZtMquoEj7VeVqxmdSumgtN1S18W9+BjSOSJF5yXV97GPDhTL8zBgO/7LENNde7N
	 U5AKZDWnKkWm7KLPw/o3kP0FnRzSsIptPFCxow4dM7etrIFfC0X/4Z1+wfOCO/CFGC
	 kBFChpWeZCL+9iULkQeP1FyvkQS4+e6Vge2WrJQ9No/SouEzCXFDhQTUv9qCfKZ81m
	 YIkPa1tDNoHMgmnYpEy7BqQAPvU8is+bL1mKmkD+KrgUGM2vRYr03LSBtGzYobzBWV
	 i+vviaEafPbyEuPfWjUxHSZXBgM3bHgYYhlagDsnsOj2EciJrR4tTVwuRqtOeqIzC+
	 sty5VvQPi6kJw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id F0D6645958;
	Thu, 29 Oct 2026 18:32:46 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Subject: [PATCH 0/3] mm/swap, zswap: fix stale zswap data and swap-in bugs
Date: Fri, 30 Oct 2026 02:31:40 +0800
Message-Id: <20261030-swap-fixes-v1-0-73f73a59f2fc@tencent.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMSwqAIBAG4KvErBPUwKirRAuzqaZFhdMLxLtnt
 fz4HwEYPSFDnQXweBLTuiSoPAM32WVEQX0yaKmNkoUUfNlNDHQjC2WtcdopLIcK0mDz+AWp37S
 /+ehmdPv7ADE+X7ruZW4AAAA=
X-Change-ID: 20261030-swap-fixes-1aa6c2c1e7f9
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
 Youngjun Park <youngjun.park@lge.com>, Yosry Ahmed <yosry@kernel.org>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Usama Arif <usamaarif642@gmail.com>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chuanhua Han <hanchuanhua@oppo.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Mani Tofigh <mt4022@columbia.edu>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, Josef Bacik <josef@toxicpanda.com>, 
 stable@vger.kernel.org, Chris Mason <mason@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793298765; l=1904;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=wv3cCqMTcjfUYGycGHsVPNfiqXd3kdzJNqs56uK6eQQ=;
 b=H4nxBiyeHaeYaXxggD0n6aJqOAp/dzE0sKP5vEjlbXqvHybzWiKKiK4xx6FXElidAiRXbZqgv
 vJspPul7updDHMMeyka+FAn9lnBoH3tWJNG/rm6XNfePr1wMD0atdSU
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 26BD412000D
X-Stat-Signature: ndi4j7pubuwrinx5w6xk6au98c1b77eb
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793298769-577362
X-HE-Meta: U2FsdGVkX18pBTjAMqtWjHQx1HuiVD7Z4+VSkGcpXlzfJETMkZie+z5zzWsYZi+B/K4ZSRwC0s4kA02Mrog65tslRXzhzXyhzpQk27C+6pQSW5tu1kGqtDf4HttQvKKwyLFsgiuR21M009xLpn3auJk7C0lD2lLcz+tq3WdN5T5OurQD8YMl8pcNZfwpcoqxey/znGUlMNINh4fmRGmjEW7Rv9ZJv9uMG+fU/QHedkE43qp6yQNLZExkBXvf6J4f0W6A9SBJFYX/aPNN20UlVK+sX1C8DgG6t3BQhlwZnxlUcd/44Hq/5cwE7bQ5gs8T79/pm5R7YVr2FxPLk0LulMGmGHub+TSD8w2ctw1rpnYp76d0S4gdcbTMquvF+svnqsI5pzBhjG2S3ngFZST35T3a5e9EwqrNCneHMKo47rbi2MaVydCDuUrrV/DRUk5dHDv2I+hh6oRZlxDJamy+tlO+DqqcQN8JwZro3u3iQw7Hb8nPMQtAjGzEGi0Qr/3iU0nenWod035GXMzPZw1x4V/ze7qeFquMX8Ls3IPjkW61uuPi9TkPBK0Y+OUjzAgMGCK9XUUyLIWxyE8bkobBD3xd04LPDcWa7jVBk+fPexn2sftEMsvvsFhzvrNYrohqqhXMHL3XNHzFiu1mV/qn4k0v8IHV/2wDkV1JD8hc8sMb9K2GZIsYL0j+/03jBFO+IliOZehUaKiRAsoRAoWDb+ZK7B2mf3haNwOIfvlxUjarc6FQoaCtC0BbvNblTaN05mdIlhIY3/InlmEQvrI0/nY3oJFAelT8K1cYl+woIB0URKKhI5nVbemeccHNhX4+pVM+qadzaMe4FH0FbCs1WtDPQFp5+Bx4MBEjcRWrr4vxBBnXRoD4XQJxxZ+l9TF3SXsbxcHitbp+omcglToG1hpZOzY1nbvciOY0rwlPbZYrjgFxvdnVMOt1mHzL89MvnW5250naRkX2FFurZcr
 ij+7WDDC
 A40bYlbTnlooF/kA5WFqHGP4ww7JtYrtcEsuoRDxEwyVCXJCy29lW/guKyOdIKuIIWAQkFHHwCh9LXy/AG2H1q59whMwXneEHiDVrARnn8TfM6LIiynPJLRcdb6Q5eIRKvO3XOb4tDP3rRYHA3if1lNECDKQgPa4M21F73uagfgI31SUJMhM+z9p8sHKyzPz6Iif/6qYlkR9534VPw4hOwxGpgVjFr9LWdgBS+IZor5m0MZP9FCXQp7YgjDYfqwC6HGacSuJkT6XwPIe0GCOtUs4oOfLpeREbC5TDvdXUI2tVtOk9jJUPxzlnuM3oYPQreRSdTGPK0O/V3Atll/1wYGjsDEbWxjhMRbFLLyCUjLmd4lJpyaR1nGhVdu6EFMvpPaidTPUBdnWq26Hse8byvbifc6/erxtyBT4uhcWmJLdBOEdNGARuyv9Zpk1yr2YXNFwaDC+jHGrbOrdKGiw1GnnLh+3oYxe6EDS7uYqeZBYga3mJd+uQuzmCTYEruTr1qa/5mhz5f/mXvqs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi all,

There are some bug fixes found by AI and collected by David, mostly
originally from Anthropic.  After filtering and dropping a few that are
already being patched up by the community [1] [2], these are the 3 we
kept.  I've reviewed them and they all look good to me, so please help
have a look and we can get them merged soon, they are pretty simple and
clean bug fixes patching real issues.

The zswap bug can return stale data instead of the zeroes that were
written, so it is data corruption and seems critical.  The extent fix is
more urgent than it might look, as it can also read in unexpected data,
but the setup could be really rare. The accounting fix is minor.
The zswap and extent fixes affect stable kernels (v6.12+) and are marked
for stable. The accounting fix only affects v7.3+.

For the extent fix, in the long term we might actually want to detect
extent contiguity and allow mTHP swap-in for single-extent swap files.
We already disable mTHP allocation for swap files, so the current fix is
trivial. It seems the most minimal and correct one for now.
Optimization and cleanups can come later.

Link: https://lore.kernel.org/linux-mm/20261026-swapoff-writeok-v1-1-4f4cd420aa33@columbia.edu/ [1]
Link: https://lore.kernel.org/linux-mm/20260811132209.2862708-3-youngjun.park@lge.com/ [2]

Signed-off-by: Kairui Song <kasong@tencent.com>
---
Chris Mason (1):
      mm, swap: fix large swap-in across swap file extents

Josef Bacik (2):
      mm/zswap: drop the stale zswap entry of a zero folio
      mm/swap: account synchronous swap reads as memory stall

 mm/memory.c  | 16 +++++++++++++---
 mm/page_io.c | 17 +++++++++++++++++
 2 files changed, 30 insertions(+), 3 deletions(-)
---
base-commit: 24d45a1475dd4c671feb1df705f67ef2fc293969
change-id: 20261030-swap-fixes-1aa6c2c1e7f9

Best regards,
--  
Kairui Song <kasong@tencent.com>



