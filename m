Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7F08606A329
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 08:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eTJoyPLd
Received: by kanga.kvack.org (Postfix)
	id BFEBC6B05B4; Mon,  2 Nov 2026 03:31:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAF846B05B5; Mon,  2 Nov 2026 03:31:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4F976B05B7; Mon,  2 Nov 2026 03:31:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 856096B05B4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:31:53 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7E234C0C44
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:31:52 +0000 (UTC)
X-FDA: 85389510864.12.58F933F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id D61D0A0007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:31:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eTJoyPLd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793608310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hO6hwu01hU17gHI381SAIeI3OjjjOxGNRadITsQEheY=;
	b=YqROpsrGo7rIt05vdJMAXOcWc80nzLWZ0xlSVLvU/DWPVcT9QiwoDh7c2QgEJostm+drQo
	Inoa+5Z9jznePx0ZUv47QKRo+TTaGQ5xvGJWhyZUn4JcjFY7a4AVaws+Z7bMQsKCkm92MT
	4qcma8UTYlhr3UL6kSQ9tON43beNu00=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eTJoyPLd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793608310;
	b=gbn03yhW6SxRSzw2+pi/7nZqn4fj+HQpBGQEsXj2gOpm26i/7VTu6ePA0BflCRMNYwltAt
	rRWaQDjG4LkpLY8PZ8g+kBl2CNgPOFK0f1QqM+EGYmJMfBzJyYKKzem078SJ+SHO2UYIM1
	/E9YFgYZfmm5zqyS+gZ5V29hYYGCCC8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3226740541;
	Mon,  2 Nov 2026 08:31:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57541F000C1;
	Mon,  2 Nov 2026 08:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793608310;
	bh=hO6hwu01hU17gHI381SAIeI3OjjjOxGNRadITsQEheY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eTJoyPLdTGTerY/hLfSJSOU8hqzNp84xlYYvFG5Tpkvatn5OnJzBuFgmjrlbIJYn+
	 WiqzKJDEB0D0vEyucAuVfVLESfj3/JXr+LBq6jg3QI+qB0r4tumbMC0xi+vZsCOXXX
	 +IWH9UZOigDZCTervBAd2OzKk5EgmWDP6LjQuW1Sryhzy9Vg0oJihKcL04XWtl2XB5
	 syEBuRUHpwpK/YUfq8/ZQVFO13WE9LuXLXTuOEJST9XFIvpF+8QTKU2Kb7Cgzf5MkY
	 TgZqNQXCJcEEiZJkN1mTsOrLdP+173R+l7nZCz0mTlOiAWODYbH/9qE4kQlB65+YGo
	 LmqeGxNrK5zYw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm: numa_memblks: remove local copy of numa_nodes_parsed
Date: Mon,  2 Nov 2026 10:31:28 +0200
Message-ID: <179360819348.1332963.1236493922584730082.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261014153225.741884-1-ekffu200098@gmail.com>
References: <20261014153225.741884-1-ekffu200098@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D61D0A0007
X-Stat-Signature: umfkj1w1ouq9apy7waiycq1db4536ndg
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793608310-492764
X-HE-Meta: U2FsdGVkX1+PRsQcPrl3Ho51nKmsm50EPP6WVJpHdhD2RIC/Jg61E27Uh03f7NmAeMyrbiaB7GDguAbGlO0xqxO+mLok0lZkXelSZVNeyLC3iuJG2I8TmdV9gJ99VJx9Urdur9tEoBeuuR9WmYoEA8UuiL0y/EHT8cwvxvE9OhAFCXn6sbCQMO6OWIN6+jmm33+Z6KqGKxhGiASvIpDyHWm2kNpWZt+p/qwuX70WNjVWFGHPC6iSZHMDwJCk3nH1Xuc82z2eo3Flxe65ZdWCHdPVPfVF6M1Qi8eCaGscRgj/Wa2uIZhA0quLL3l7p0elC7SruEOY17wMmfaVeNaMYjP+mKL5Iql6p8GyRMcxDwkFBCggeK+mVCbQd25Lyqrtbf+7CIKpczFctQq8p6O8UVCMJPCdJGK/2w5EMgPcIOpZoskwO1S8Xb54apGYR/hFT42pDyxYJXjBnUGkJAQat3OFG1tXb67hO7Fz0uS7onow5HusN93eMna0n9/tpHHVHWNDzUpHaUanopHagZVXazTULQFvwTaqYQBxmVqH5Eo9SZo8aabt+/hWbzHKnjVY9v5AzS1zVF6LnluaPhVZonkgZMqC90LTq1BZ9lvyY8iYKuo9EhtsLvWR0NCJNIb7eCvxpI2wGXChB89YKZX8sQ3FNB292NWbQP3QQ29Kw6z5+jbqn7daM6hTwJThs1PcZ8t1wZrN6xZ6Vef6dY+tYObaq+YyDoRBEYY3jgwNooS9AkBEadWq8T+rLBiHtLAs9pti2Sb2bKc5SI3/U/hozaW/1SnxFZD1yZPfjapKV6wvA5wahepHKicULFjVDFZyU2Z71HmSMHLknqMGq+d7soPOqL7VIQEbRvoVJeOZWbFXdo6+akKj2RP4RSbngEPCozsolWiiZEQC7UPSSYOhYQhFm69dhVIj0oma0oXaCbTDw/sCZBcuZCCc/CeWBuFKjwaEHDilpfeQ85/dlQW
 b33Dl0c2
 ngRPsf6C45zpN+x6r5LT3jbP5463p5zniDTL1fAHojR/HTl1A1sSI5yR5c0OhRS8cOavV6u1cmuPdKppH5SzXsanuuhdNyM3J75GYsjNKfBQ6aOvkI9EdR2T/0SdRDTq9A4q7FuGSuoS4rpqMBywsSMfgyqEr3Ye52zvosOevHF4IhZJTv58aD3wVsAsx5B/6jj84aAffYnZOvur28Dt0g//eN7SQRAR9bCWlHDE+bVsg63cH7BhLwA5+ex5WqBEqlydgmNRp6aGLbgczrrms/vyxpqqJm5zCQw/4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 15 Oct 2026 00:32:24 +0900, Sang-Heon Jeon wrote:
> Since commit a9bafc1832d2 ("mm: numa_memblks: remove redundant
> numa_nodemask_from_meminfo()"), the copy of numa_nodes_parsed in
> numa_alloc_distance() is the same as numa_nodes_parsed.
> 
> So remove the copy and use numa_nodes_parsed directly.
> 
> No functional change.
> 
> [...]

Applied to for-next branch of memblock.git tree, thanks!

[1/1] mm: numa_memblks: remove local copy of numa_nodes_parsed
      commit: dd304f239824e4056e89a7fda9d7f3aa87f4d523

tree: https://git.kernel.org/pub/scm/linux/kernel/git/mm/memblock
branch: for-next

--
Sincerely yours,
Mike.


